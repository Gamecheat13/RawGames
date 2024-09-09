#include maps\mp\_utility;
#include common_scripts\utility;


init()
{
	SetDvarIfUninitialized( "scr_solar_killstreak_turn_rate", 20 );
	SetDvarIfUninitialized( "scr_solar_killstreak_duration", 30 );
	
	//Preparing assets for the Solar Reflector
	level.solar_reflector_fx["laserTarget"] = LoadFX("vfx/map/mp_solar/solar_lightbeam_pointlight");
	level.solar_reflector_fx["beahm"] 		= LoadFX( "vfx/map/mp_solar/solar_lightbeam" );
	level.solar_reflector_burn_fx 			= LoadFX( "vfx/map/mp_solar/solar_lightbeam_burnmark" );//TODO: Request laser FX from VFX.
	level.solar_array_lightbeam 		= LoadFX( "vfx/map/mp_solar/solar_array_lightbeam_single" );
	
	PreCacheItem( "killstreak_solar_mp" );

	level.solar_reflector_sfx = "orbital_laser";	//TODO: Request laser SFX from Audio

	PreCacheShader( "compassping_orbitallaser_friendly" );
	level.solar_reflector_friendShader = "compassping_orbitallaser_friendly";		//TODO: create new minimap icons for the solar reflector.
	
	PreCacheShader( "compassping_orbitallaser_hostile" );
	level.solar_reflector_foeShader = "compassping_orbitallaser_hostile";
	
	
	
	//Setting up the tag origin for linking the player's camera.
	solar_reflector_script_origin = GetEnt( "map_killstreak_cam_origin", "targetname" );
	
	level.solar_reflector_cam_tag = spawn_tag_origin();
	if ( IsDefined( solar_reflector_script_origin ) )
	{
		level.solar_reflector_cam_tag.origin = solar_reflector_script_origin.origin;
		level.solar_reflector_cam_tag.angles = solar_reflector_script_origin.angles;
	}
	else
	{
		level.solar_reflector_cam_tag.origin = ( 0, 0, 0 );
		level.solar_reflector_cam_tag.angles = ( 0, 0, 0 );
	}
	level.solar_reflector_cam_tag.owner = undefined;
	level.solar_reflector_cam_tag.thermal_vision = "ac130_thermal_mp";
	level.solar_reflector_cam_tag.enhanced_vision = "ac130_enhanced_mp";
	
	
	
	//Setting up the tag origin to which we will attach the laser vfx (reusing the solar_reflector_script_origin variable).
	solar_reflector_script_origin = GetEnt( "map_killstreak_vfx_origin", "targetname" );
	
	level.solar_reflector_vfx_tag = spawn_tag_origin();
	if ( IsDefined( solar_reflector_script_origin ) )
	{
		level.solar_reflector_vfx_tag.origin = solar_reflector_script_origin.origin;
		level.solar_reflector_vfx_tag.angles = solar_reflector_script_origin.angles;
	}
	else
	{
		level.solar_reflector_vfx_tag.origin = ( 0, 0, 0 );
		level.solar_reflector_vfx_tag.angles = ( 0, 0, 0 );
	}
	
	//We have to show solar_reflector_vfx_tag to see FX played on it.
	level.solar_reflector_vfx_tag Show();
	
	
	
	//Getting the solar reflector's dish script_brushmodel and setting its initial orientation.
	level.solar_reflector_dish = GetEnt( "solar_reflector_dish", "targetname" );
	if ( IsDefined( level.solar_reflector_dish ) )
	{
		level.solar_reflector_dish.angles = level.solar_reflector_cam_tag.angles + (90, 0, 0);
	}
	else
	{
		level.solar_reflector_dish.angles = (0,0,0);
	}
	level.solar_reflector_dish.initial_angles = level.solar_reflector_dish.angles;
	
	//Getting the solar reflector's swivel brushmodel and setting its initial orientation.
	level.solar_reflector_swivel = GetEnt( "solar_reflector_swivel", "targetname" );
	if ( IsDefined( level.solar_reflector_swivel ) )
	{
		level.solar_reflector_swivel.angles = ( 0, level.solar_reflector_cam_tag.angles[1], 0 );
	}
	else
	{
		level.solar_reflector_swivel.angles = (0,0,0);
	}
	level.solar_reflector_swivel.initial_angles = level.solar_reflector_swivel.angles;
	
	
	
	//Creating a tag_origin to which we will attach the solar array beams.
//	level.solar_array_beams_tag = spawn_tag_origin();
//	level.solar_array_beams_tag.origin = (1174.28, 1523.67, 1886.58);
//	level.solar_array_beams_tag.angles = (270, 0, 0);
//	level.solar_array_beams_tag Show();
	
	//create an array for all the solar lightbeam fx objects
	//setupLightbeamArrayFX();
	
	
	level.HUDItem = [];
	
	level.killstreakFuncs["mp_solar"] = maps\mp\killstreaks\mp_solar::tryUseSolarReflector;
	
	level.solar_reflector_default_position_ready = true;
	
	level thread resetSolarReflectorOrientation();
}


/*
=============
///ScriptDocBegin
"Name: findPlayerViewGroundPoint()"
"Summary: does traces to find the point that the player's camera is aiming at"
"Module: Entity"
"CallOn: the player that is controlling the Solar Reflector"
"Example: player thread findPlayerViewGroundPoint()"
"SPMP: MP"
///ScriptDocEnd
=============
*/
findPlayerViewGroundPoint()
{
	level endon( "game_ended" );
	self endon( "disconnect" );
	self endon( "solar_reflector_player_removed" );
	
	self.cam_view_ground_point = spawn_tag_origin();
	self.cam_view_ground_point.origin = (0,0,0);
	self.cam_view_start_point = spawn_tag_origin();
	self.cam_view_start_point.origin = (0,0,0);
	
	while ( true )
	{
	 	self.cam_view_start_point.origin = self GetEye();
		forward = AnglesToForward( self GetPlayerAngles() );
		endpoint = self.cam_view_start_point.origin + forward * 15000;
		self.CamTraceData = BulletTrace( self.cam_view_start_point.origin, endpoint, false );
		
		//Updating the laser_ground_point and laser_start_point used to play the looping laser sound.
		self.cam_view_ground_point.origin = self.CamTraceData["position"];
		
		wait( 0.02 );
	}
}


/*
=============
///ScriptDocBegin
"Name: findLaserGroundPoint()"
"Summary: does traces to find the point that the laser is hitting on the ground."
"Module: Entity"
"CallOn: the player that is controlling the Solar Reflector"
"Example: player thread findLaserGroundPoint()"
"SPMP: MP"
///ScriptDocEnd
=============
*/
findLaserGroundPoint()
{
	level endon( "game_ended" );
	self endon( "disconnect" );
	self endon( "solar_reflector_player_removed" );
	
	//The point at which we will create our damage radius and burn vfx.
	self.laser_ground_point = spawn_tag_origin();
	//The point that we will use to follow the player's camera ground point.
	self.laser_tracking_point = Spawn( "script_origin", (0, 0, 0) );
	if ( IsDefined( self.cam_view_ground_point ) )
	{
		//Using the camera ground point as the initial location for the laser_ground_point, laser_tracking_point, and self.ReflectorTraceData["position"].
		self.laser_ground_point.origin = self.cam_view_ground_point.origin;
		self.laser_tracking_point.origin = self.cam_view_ground_point.origin;
		self.ReflectorTraceData["position"] = self.cam_view_ground_point.origin;
		
		//Using the dish's angles to set the initial angles for level.solar_reflector_vfx_tag.angles.
		//The reason for doing this is because the Solar Reflector Dish resets its position without moving the laser_ground_point, moving the laser_tracking_point, or adjusting level.solar_reflector_dish.angles.
		//TODO: instead, it would be less hacky actually adjust laser_ground_point, laser_tracking_point and level.solar_reflector_dish.angles here, before we enter the loop.
		level.solar_reflector_vfx_tag.angles = level.solar_reflector_dish.angles - (90, 0, 0);
	}
	else
	{
		self.laser_ground_point.origin = (0,0,0);
		self.laser_tracking_point.origin = (0,0,0);
		self.ReflectorTraceData["position"] = (0,0,0);
	}
	
	self.laser_start_point = spawn_tag_origin();
	if ( IsDefined( level.solar_reflector_vfx_tag ) )
	{
		//Using the vfx tag origin as the initial location for the laser_start_point.
		self.laser_start_point.origin = level.solar_reflector_vfx_tag.origin;
	}
	else
	{
		self.laser_start_point.origin = (0,0,0);
	}
	
	//Creating the minimap icon for the solar reflector's ground point.
	self.laser_ground_point thread handleSolarReflectorMinimapDisplay( self );
	self thread removeSolarReflectorMinimapDisplay();
	
	while ( true )
	{
		//Moving the laser's starting point to the location of the solar reflector's vfx tag.
	 	self.laser_start_point.origin = level.solar_reflector_vfx_tag.origin;
	 	
	 	//Only update the laser_ground_point.origin if the player's self.laser_tracking_point.origin is a certain distance away from the cam_view_ground_point.origin.
//	 	if ( Distance2DSquared( self.cam_view_ground_point.origin, self.laser_tracking_point.origin ) > 256 )
//	 	{
//	 	}
	 	
	 	//Moving the level.laser_tracking_point towards the player's cam_view_ground_point.
	 	//Finding the vector normal between the cam_view_ground_point and the laser_tracking_point.
	 	normal_vector = VectorNormalize( self.cam_view_ground_point.origin - self.laser_tracking_point.origin );
	 	//Scale the normal_vector by the turn rate of the Solar Reflector.
	 	normal_vector *= GetDvarInt( "scr_solar_killstreak_turn_rate", 20 );
	 	//Adding the normal_vector to the laser_tracking_point to move it closer to the player's cam_view_ground_point.
	 	self.laser_tracking_point.origin += normal_vector;
	 	
	 	//Find the point on the ground that the laser burns.
	 	//Normalize the vector between the laser_start_point and the laser_tracking_point's new position.
	 	forward = VectorNormalize( self.laser_tracking_point.origin - self.laser_start_point.origin );
	 	//Project an endpoint 15000 units away from the laser_start_point in the "forward" direction.
	 	endpoint = self.laser_start_point.origin + forward * 15000;
	 	//Do a trace from the laser_start_point down the towards our new endpoint.
		self.ReflectorTraceData = BulletTrace( self.laser_start_point.origin, endpoint, false );
		//Updating the laser_ground_point and laser_start_point used to play the looping laser sound.
		self.laser_ground_point.origin = self.ReflectorTraceData["position"];
		
		//Matching the vfx angles to the angles between the laser_start_point and the laser_ground_point.
		self.laser_angles = VectorToAngles( forward );
		level.solar_reflector_vfx_tag.angles = self.laser_angles;
		
		//Rotating the Solar Reflector components.
		//Orient the dish
		level.solar_reflector_dish.angles = self.laser_angles + (90, 0, 0);
		//Orient the swivel
		level.solar_reflector_swivel.angles = (0, self.laser_angles[1], 0);
		
		wait( 0.05 );
	}
}


/*
=============
///ScriptDocBegin
"Name: inflictReflectorDamage()"
"Summary: deal damage to enemy players near the laser's ground point."
"Module: Entity"
"CallOn: a player that is controlling the Solar Reflector"
"Example: player thread inflictReflectorDamage()"
"SPMP: MP"
///ScriptDocEnd
=============
*/
inflictReflectorDamage()
{
	level endon( "game_ended" );
	self endon( "disconnect" );
	self endon( "solar_reflector_player_removed" );
	
	while ( true )
	{
		if ( IsDefined( self.laser_ground_point ) )
		{
			damage_radius = 128;
			damage_radius_sq = damage_radius * damage_radius;
			//Create damage radius at laser point.
			//Below, self is used as the "inflictor". If I was to call RadiusDamage without prepending self, killing a friendly or the killstreak's owner would throw an assert because the inflictor is undefined.
			//In Fortress, RadiusDamage is called on the visuals[0] of the useObject (a planted bomb).
			//Calling RadiusDamage on self causes the RadiusDamage to not hurt self (player can't kill himself with this killstreak).
			level.solar_reflector_cam_tag RadiusDamage( self.ReflectorTraceData["position"], damage_radius, 3, 1, self, "MOD_EXPLOSIVE", "killstreak_solar_mp" );
			foreach ( player in level.players )
			{
				if ( DistanceSquared( self.laser_ground_point.origin, player.origin ) < damage_radius_sq &&
				    BulletTracePassed( self.laser_ground_point.origin, player.origin, false, undefined ) )			//If the player is less than 256 units away from the laser's ground contact point and there is nothing obstructing...
				{
					//TODO: may want to revisit the below commented-out script if we want a more nuanced damage area of effect.
//					player maps\mp\gametypes\_weapons::damageEnt(
//						"killstreak_solar_mp", // eInflictor = the entity that causes the damage (e.g. a claymore)
//						self, // eAttacker = the player that is attacking
//						3, // iDamage = the amount of damage to do
//						"MOD_PROJECTILE_SPLASH", // sMeansOfDeath = string specifying the method of death (e.g. "MOD_PROJECTILE_SPLASH")
//						"killstreak_solar_mp", // sWeapon = string specifying the weapon used (e.g. "claymore_mp")
//						self.laser_ground_point.origin, // damagepos = the position damage is coming from
//						vectornormalize(player.damageCenter - player.pos) // damagedir = the direction damage is moving in
//					);
					player PlayRumbleOnEntity( "damage_heavy" );
					player shellshock( "orbital_laser_mp", 1 );		//TODO: add a solar reflector .shock file if we ultimately want to keep that effect.
				}
			}
		}
		
		wait( 0.05 );
	}
}


/*
=============
///ScriptDocBegin
"Name: triggerSolarReflectorFX()"
"Summary: draws a reaper red dot on the ground where the solar reflector is pointing."
"Module: Entity"
"CallOn: a player"
"Example: player thread triggerSolarReflectorFX();"
"SPMP: MP"
///ScriptDocEnd
=============
*/
triggerSolarReflectorFX()
{
	level endon( "game_ended" );
	self endon( "disconnect" );
	self endon( "solar_reflector_player_removed" );

	level.targetFxEnt = SpawnFx( level.solar_reflector_fx["laserTarget"], (0,0,0) );
	level.burnFxEnt = SpawnFx( level.solar_reflector_burn_fx, (0,0,0) );
	
	//Play the looping orbital_laser vfx on level.solar_reflector_vfx_tag.
	PlayFXOnTag( level.solar_reflector_fx["beahm"], level.solar_reflector_vfx_tag, "tag_origin" );
	
	//Play the looping solar array light beams on level.solar_array_beams_tag.
//	PlayFXOnTag( level._effect[ "solar_array_lightbeams" ], level.solar_array_beams_tag, "tag_origin" );
	
	x = 1;
	while ( true )
	{
		if ( isDefined( self.ReflectorTraceData ) )
		{
			//Rapidly trigger the laser dot (these are not looping effects).
			level.targetFxEnt.origin = self.ReflectorTraceData["position"];
			triggerFX( level.targetFxEnt );
			
			//trigger burning fx every other time
			if(x == 1)
				level.burnFxEnt.origin = self.ReflectorTraceData["position"];
			TriggerFX( level.burnFxEnt );
			x = x * -1;
		}
		
		wait( 0.05 );
	}
}


/*
=============
///ScriptDocBegin
"Name: deleteSolarReflectorFX()"
"Summary: deletes laser dot fx after the player stops using the solar reflector"
"Module: Entity"
"CallOn: a player using the solar reflector"
"Example: player thread deleteSolarReflectorFX()"
"SPMP: MP"
///ScriptDocEnd
=============
*/
deleteSolarReflectorFX()
{
	self waittill( "solar_reflector_player_removed" );
	
	level.targetFxEnt Delete();
	level.burnFxEnt Delete();
	
	StopFXOnTag( level.solar_reflector_fx["beahm"], level.solar_reflector_vfx_tag, "tag_origin" );		//TODO: investigate known issue - sometimes the laser "beahm" effect does not go away after using the killstreak.
	
//	StopFXOnTag( level._effect[ "solar_array_lightbeams" ], level.solar_array_beams_tag, "tag_origin" );
}


/*
=============
///ScriptDocBegin
"Name: playLoopingLaserSound()"
"Summary: starts playing a the looping laser sound. This is ended in end_looping_laser_sound()."
"Module: Entity"
"CallOn: a player"
"Example: player playLoopingLaserSound()"
"SPMP: MP"
///ScriptDocEnd
=============
*/
playLoopingLaserSound()
{
	//Start the looping laser sounds.
	if ( IsDefined( self.laser_ground_point ) )
	{
		//Play the orbital laser sound at ground level.
		self.laser_ground_point thread play_loop_sound_on_entity( level.solar_reflector_sfx );
	}
	
	if ( IsDefined( self.laser_start_point ) )
	{
		//Play the orbital laser sound for the user of the Solar Reflector Tower.
		self.laser_start_point thread play_loop_sound_on_entity( level.solar_reflector_sfx );
	}
	
	//End the looping laser sounds.
	self waittill( "solar_reflector_player_removed" );
	
	if ( IsDefined( self.laser_ground_point ) )
	{
		self.laser_ground_point stop_loop_sound_on_entity( level.solar_reflector_sfx );
	}
	
	if ( IsDefined( self.laser_start_point ) )
	{
		self.laser_start_point stop_loop_sound_on_entity( level.solar_reflector_sfx );
	}
}


/*
=============
///ScriptDocBegin
"Name: handleSolarReflectorMinimapDisplay( <owner> )"
"Summary: creates the minimap icon for the solar reflector's ground point."
"Module: Entity"
"CallOn: a laser_ground_point tag origin"
"MandatoryArg: <owner>: the user of the solar reflector"
"Example: self.laser_ground_point thread handleSolarReflectorMinimapDisplay( player )"
"SPMP: MP"
///ScriptDocEnd
=============
*/
handleSolarReflectorMinimapDisplay( owner )
{
	if( !level.teambased )
	{
		currentObj = maps\mp\gametypes\_gameobjects::getNextObjID();
		objective_add( currentObj, "invisible", (0,0,0) );
		objective_OnEntity( currentObj, self );
		objective_state( currentObj, "active" );
		objective_player( currentObj, owner GetEntityNumber() );
		objective_icon( currentObj, level.solar_reflector_friendShader );
		self.objID01 = currentObj;
		
		currentObj = maps\mp\gametypes\_gameobjects::getNextObjID();
		objective_add( currentObj, "invisible", (0,0,0) );
		objective_OnEntity( currentObj, self );
		objective_state( currentObj, "active" );
		objective_playerenemyteam( currentObj, owner GetEntityNumber() );
		objective_icon( currentObj, level.solar_reflector_foeShader );
		self.objID02 = currentObj;
	}
	else
	{
		currentObj = maps\mp\gametypes\_gameobjects::getNextObjID();
		objective_add( currentObj, "invisible", (0,0,0) );
		objective_OnEntity( currentObj, self );
		objective_state( currentObj, "active" );
		objective_team( currentObj, owner.team );
		objective_icon( currentObj, level.solar_reflector_friendShader );
		self.objID03 = currentObj;
				
		currentObj = maps\mp\gametypes\_gameobjects::getNextObjID();
		objective_add( currentObj, "invisible", (0,0,0) );
		objective_OnEntity( currentObj, self );
		objective_state( currentObj, "active" );
		objective_team( currentObj, level.otherTeam[ owner.team ] );
		objective_icon( currentObj, level.solar_reflector_foeShader );
		self.objID04 = currentObj;
	}
}


/*
=============
///ScriptDocBegin
"Name: removeSolarReflectorMinimapDisplay()"
"Summary: removes the minimap icon for the solar reflector"
"Module: Entity"
"CallOn: a player with a laser_ground_point tag origin"
"Example: self.laser_ground_point thread removeSolarReflectorMinimapDisplay()"
"SPMP: MP"
///ScriptDocEnd
=============
*/
removeSolarReflectorMinimapDisplay()
{
	self waittill( "solar_reflector_player_removed" );
	
	if( IsDefined( self.laser_ground_point.objID01 ) )
		_objective_delete( self.laser_ground_point.objID01 );
	if( IsDefined( self.laser_ground_point.objID02 ) )
		_objective_delete( self.laser_ground_point.objID02 );
	if( IsDefined( self.laser_ground_point.objID03 ) )
		_objective_delete( self.laser_ground_point.objID03 );
	if( IsDefined( self.laser_ground_point.objID04 ) )
		_objective_delete( self.laser_ground_point.objID04 );
}


/*
=============
///ScriptDocBegin
"Name: resetSolarReflectorOrientation()"
"Summary: once not in use, rotates the Solar Reflector dish and swivel back to their starting orientations."
"Module: Entity"
"CallOn: the level"
"Example: level thread resetSolarReflectorOrientation()"
"SPMP: MP"
///ScriptDocEnd
=============
*/
resetSolarReflectorOrientation()
{
	level endon( "game_ended" );
	
	//While no one is using the Solar Reflector...
	while ( true )
	{
		if ( !IsDefined( level.solar_reflector_player ) )
		{
			swivel_ready = false;
			dish0_ready = false;
			dish1_ready = false;
			dish2_ready = false;
			
			//Resetting the swivel angles.
//			if ( level.solar_reflector_swivel.angles[0] < level.solar_reflector_swivel.initial_angles[0] )
//			{
//				level.solar_reflector_swivel.angles += (1, 0, 0);
//			}
//			else if ( level.solar_reflector_swivel.angles[0] > level.solar_reflector_swivel.initial_angles[0] )
//			{
//				level.solar_reflector_swivel.angles[0] -= (1, 0, 0);
//			}
			
			if ( level.solar_reflector_swivel.angles[1] < level.solar_reflector_swivel.initial_angles[1] - 1 )
			{
				level.solar_reflector_swivel.angles += (0, 1, 0);
			}
			else if ( level.solar_reflector_swivel.angles[1] > level.solar_reflector_swivel.initial_angles[1] + 1 )
			{
				level.solar_reflector_swivel.angles -= (0, 1, 0);
			}
			else
			{
				swivel_ready = true;
			}
			
//			if ( level.solar_reflector_swivel.angles[2] < level.solar_reflector_swivel.initial_angles[2] )
//			{
//				level.solar_reflector_swivel.angles += (0, 0, 1);
//			}
//			else if ( level.solar_reflector_swivel.angles[2] > level.solar_reflector_swivel.initial_angles[2] )
//			{
//				level.solar_reflector_swivel.angles -= (0, 0, 1);
//			}
			
			
			//Resetting the dish angles.
			if ( level.solar_reflector_dish.angles[0] < level.solar_reflector_dish.initial_angles[0] - 1 )
			{
				level.solar_reflector_dish.angles += (1, 0, 0);
			}
			else if ( level.solar_reflector_dish.angles[0] > level.solar_reflector_dish.initial_angles[0] + 1 )
			{
				level.solar_reflector_dish.angles -= (1, 0, 0);
			}
			else
			{
				dish0_ready = true;
			}
			
			if ( level.solar_reflector_dish.angles[1] < level.solar_reflector_dish.initial_angles[1] - 1 )
			{
				level.solar_reflector_dish.angles += (0, 1, 0);
			}
			else if ( level.solar_reflector_dish.angles[1] > level.solar_reflector_dish.initial_angles[1] + 1 )
			{
				level.solar_reflector_dish.angles -= (0, 1, 0);
			}
			else
			{
				dish1_ready = true;
			}
			
			if ( level.solar_reflector_dish.angles[2] < level.solar_reflector_dish.initial_angles[2] - 1 )
			{
				level.solar_reflector_dish.angles += (0, 0, 1);
			}
			else if ( level.solar_reflector_dish.angles[2] > level.solar_reflector_dish.initial_angles[2] + 1 )
			{
				level.solar_reflector_dish.angles -= (0, 0, 1);
			}
			else
			{
				dish2_ready = true;
			}
			
			if ( swivel_ready && dish0_ready && dish1_ready && dish2_ready )
			{
				//The swivel and all dish axes are back to their starting positions.
				level.solar_reflector_default_position_ready = true;
			}
		}
		wait(0.05);
	}
}


/*
=============
///ScriptDocBegin
"Name: setSlowAim()"
"Summary: enables and disables slow aim based on mp_solar map-based killstreak usage."
"Module: Entity"
"CallOn: A player"
"Example: player thread setSlowAim();"
"SPMP: MP"
///ScriptDocEnd
=============
*/
setSlowAim()
{
	level endon( "game_ended" );
	self endon( "disconnect" );
	
	self EnableSlowAim( 0.05, 0.05 );
	
	self waittill( "solar_reflector_player_removed" );
	
	self DisableSlowAim();
}


/*
=============
///ScriptDocBegin
"Name: tryUseSolarReflector( <lifeId> )"
"Summary: the killstreak function added to level.killstreakFuncs[]."
"Module: Entity"
"CallOn: a player"
"MandatoryArg: <lifeId>: "
"Example: "
"SPMP: MP"
///ScriptDocEnd
=============
*/
tryUseSolarReflector( lifeId )
{
	if ( isDefined( level.solar_reflector_player ) )
	{
		self iPrintLnBold( &"MP_SOLAR_REFLECTOR_IN_USE" );
		return false;
	}
	else if ( !level.solar_reflector_default_position_ready )
	{
		self iPrintLnBold( &"MP_SOLAR_REFLECTOR_RESETTING" );
		return false;
	}

	if ( self isUsingRemote() )
	{
		return false;
	}
	
	if ( self isAirDenied() )
	{
		return false;
	}
	
	if ( self isEMPed() )
	{
		return false;
	}

	self setUsingRemote( "mp_solar" );
	result = self maps\mp\killstreaks\_killstreaks::initRideKillstreak();
	if ( result != "success" )
	{
		if ( result != "disconnect" )
			self clearUsingRemote();

		return false;
	}

	result = setSolarReflectorPlayer( self );
	
	// this needs to get set after we say the player is using it because this could get set to true and then they leave the game
	// this fixes a bug where a player calls it, leaves before getting fully in it and then no one else can call it because it thinks it's being used
	if( IsDefined( result ) && result )
	{
		self maps\mp\_matchdata::logKillstreakEvent( "mp_solar", self.origin );		//TODO: set this up for the Solar Reflector.
	}
	else
	{
		self clearUsingRemote();
	}

	return ( IsDefined( result ) && result );
}


/*
=============
///ScriptDocBegin
"Name: setSolarReflectorPlayer( <player> )"
"Summary: kicks off most of the script that controls Solar Reflector functionality."
"Module: Entity"
"CallOn: NA"
"MandatoryArg: <player>: the player who is using the Solar Reflector killstreak."
"Example: result = setSolarReflectorPlayer( self );"
"SPMP: MP"
///ScriptDocEnd
=============
*/
setSolarReflectorPlayer( player )
{
	self endon ( "solar_reflector_player_removed" );
	
	if( IsDefined( level.solar_reflector_player ) )
		return false;
	
	level.solar_reflector_player = player;
	level.solar_reflector_cam_tag.owner = player;
	
	//This will not be set to true again until the Solar Reflector has completely reset its orientation in resetSolarReflectorOrientation().
	level.solar_reflector_default_position_ready = false;
	
	player openMenu( "ac130timer" );
	
	thread teamPlayerCardSplash( "used_mp_solar", player );
	
	// with the way we do visionsets we need to wait for the clearRideIntro() is done before we set thermal
	player thread waitSetThermal( 1.0 );

	if ( getDvarInt( "camera_thirdPerson" ) )
		player setThirdPersonDOF( false );
	
	player thread overlay( player );
	player thread attachPlayer();
	
	player thread createSolarReflectorHUDElems();
	
	player thread findPlayerViewGroundPoint();
	player thread findLaserGroundPoint();
	player thread triggerSolarReflectorFX();
	player thread deleteSolarReflectorFX();
	player thread playLightbeamArrayFX();
	player thread inflictReflectorDamage();
	player thread playLoopingLaserSound();
//	player thread setSlowAim();
	
	player thread removeSolarReflectorPlayerAfterTime( GetDvarInt( "scr_solar_killstreak_duration", 30 ) * player.killStreakScaler );
	player thread removeSolarReflectorPlayerOnDisconnect();
	player thread removeSolarReflectorPlayerOnChangeTeams();
	player thread removeSolarReflectorPlayerOnSpectate();
	player thread removeSolarReflectorPlayerOnGameCleanup();
	player thread removeSolarReflectorPlayerOnCommand();
	
	return true;
}


/*
=============
///ScriptDocBegin
"Name: handleDamageFeedbackSound()"
"Summary: "
"Module: Entity"
"CallOn: a player who is doing damage to someone else and should get a damage feedback sound."
"Example: self thread handleDamageFeedbackSound();"
"SPMP: MP"
///ScriptDocEnd
=============
*/
handleDamageFeedbackSound()
{
	self.shouldloopdamagefeedback = true;
	self.damagefeedbacktimer = 10;
	
	self PlayLoopSound( "MP_solar_hit_alert" );
	
	while ( self.damagefeedbacktimer > 0 )
	{
		self.damagefeedbacktimer--;
		wait( 0.05 );
	}
	
	self StopLoopSound();
	
	self.shouldloopdamagefeedback = undefined;
}


/*
=============
///ScriptDocBegin
"Name: createSolarReflectorHUDElems()"
"Summary: create additional hud elements for the solar reflector"
"Module: Entity"
"CallOn: the player using the Solar Reflector"
"Example: player thread createSolarReflectorHUDElems()"
"SPMP: MP"
///ScriptDocEnd
=============
*/
createSolarReflectorHUDElems()
{
	level endon( "game_ended" );
	self endon( "disconnect" );
	self endon ( "solar_reflector_player_removed" );
	
	
	self thread createSolarKillstreakClock();
	
	
	level.HUDItem[ "hud_reticle" ] = NewClientHudElem( self );
	level.HUDItem[ "hud_reticle" ].x = -15;
	level.HUDItem[ "hud_reticle" ].y = -15;
	level.HUDItem[ "hud_reticle" ].sort = 6;
	level.HUDItem[ "hud_reticle" ].horzalign = "center";
	level.HUDItem[ "hud_reticle" ].vertalign = "middle";
	level.HUDItem[ "hud_reticle" ] SetShader( "charged_shot_reticle", 30, 30 );
	
	
	
	//Toggle FLIR button instructions
	level.HUDItem[ "toggle_flir" ] = NewClientHudElem( self );
	level.HUDItem[ "toggle_flir" ].x = 150;
	level.HUDItem[ "toggle_flir" ].y = 150;
	level.HUDItem[ "toggle_flir" ].alignX = "left";
	level.HUDItem[ "toggle_flir" ].alignY = "middle";
	level.HUDItem[ "toggle_flir" ].horzAlign = "center";
	level.HUDItem[ "toggle_flir" ].vertAlign = "middle";
	level.HUDItem[ "toggle_flir" ].fontScale = 2.0;
	level.HUDItem[ "toggle_flir" ] SetText( "^3[{+activate}]^7 Toggle FLIR" );		//TODO: replace with localized string.
	level.HUDItem[ "toggle_flir" ].alpha = 1.0;
	
	
	
	//Exit Solar Reflector button instructions
	level.HUDItem[ "exit_early" ] = NewClientHudElem( self );
	level.HUDItem[ "exit_early" ].x = 150;
	level.HUDItem[ "exit_early" ].y = 170;
	level.HUDItem[ "exit_early" ].alignX = "left";
	level.HUDItem[ "exit_early" ].alignY = "middle";
	level.HUDItem[ "exit_early" ].horzAlign = "center";
	level.HUDItem[ "exit_early" ].vertAlign = "middle";
	level.HUDItem[ "exit_early" ].fontScale = 2.0;
	level.HUDItem[ "exit_early" ] SetText( "Hold A to exit" );		//TODO: replace with localized string with proper button icon.
	level.HUDItem[ "exit_early" ].alpha = 1.0;
	
	
	
	level.HUDItem[ "status_message" ] = NewClientHudElem( self );
	level.HUDItem[ "status_message" ].x = 0;
	level.HUDItem[ "status_message" ].y = -160;
	level.HUDItem[ "status_message" ].alignX = "center";
	level.HUDItem[ "status_message" ].alignY = "middle";
	level.HUDItem[ "status_message" ].horzAlign = "center";
	level.HUDItem[ "status_message" ].vertAlign = "middle";
	level.HUDItem[ "status_message" ].fontScale = 1.0;
	level.HUDItem[ "status_message" ] SetText( "Energy Redirection In Progress" );		//TODO: replace with localized string.
	level.HUDItem[ "status_message" ].alpha = 1.0;
	
	
	
	level.HUDItem[ "pitch_meter_bar" ] = NewClientHudElem( self );
	level.HUDItem[ "pitch_meter_bar" ].x = 170;
	level.HUDItem[ "pitch_meter_bar" ].y = -75;
	level.HUDItem[ "pitch_meter_bar" ].sort = 6;
	level.HUDItem[ "pitch_meter_bar" ].horzalign = "center";
	level.HUDItem[ "pitch_meter_bar" ].vertalign = "middle";
	level.HUDItem[ "pitch_meter_bar" ] SetShader( "hudcolorbar", 10, 150 );		//TODO: hudcolorbar already lives in common_mp_materials.csv. Replace it with something new.
	
	level.HUDItem[ "pitch_meter_arrow" ] = NewClientHudElem( self );
	level.HUDItem[ "pitch_meter_arrow" ].x = 150;
	level.HUDItem[ "pitch_meter_arrow" ].y = -85;
	level.HUDItem[ "pitch_meter_arrow" ].sort = 6;
	level.HUDItem[ "pitch_meter_arrow" ].horzalign = "center";
	level.HUDItem[ "pitch_meter_arrow" ].vertalign = "middle";
	level.HUDItem[ "pitch_meter_arrow" ] SetShader( "hud_killstreak_dpad_arrow_right", 20, 20 );		//TODO: hud_killstreak_dpad_arrow_right already lives in common_mp_materials.csv. Replace it with something new.
	
	level.HUDItem[ "pitch_meter_label" ] = NewClientHudElem( self );
	level.HUDItem[ "pitch_meter_label" ].x = 190;
	level.HUDItem[ "pitch_meter_label" ].y = 0;
	level.HUDItem[ "pitch_meter_label" ].alignX = "left";
	level.HUDItem[ "pitch_meter_label" ].alignY = "middle";
	level.HUDItem[ "pitch_meter_label" ].horzAlign = "center";
	level.HUDItem[ "pitch_meter_label" ].vertAlign = "middle";
	level.HUDItem[ "pitch_meter_label" ].fontScale = 2.0;
	level.HUDItem[ "pitch_meter_label" ] SetText( "PITCH" );		//TODO: replace with localized string.
	level.HUDItem[ "pitch_meter_label" ].alpha = 1.0;
	
	
	
	level.HUDItem[ "yaw_meter_bar" ] = NewClientHudElem( self );
	level.HUDItem[ "yaw_meter_bar" ].x = -75;
	level.HUDItem[ "yaw_meter_bar" ].y = 170;
	level.HUDItem[ "yaw_meter_bar" ].sort = 6;
	level.HUDItem[ "yaw_meter_bar" ].horzalign = "center";
	level.HUDItem[ "yaw_meter_bar" ].vertalign = "middle";
	level.HUDItem[ "yaw_meter_bar" ] SetShader( "hudcolorbar", 150, 10 );		//TODO: hudcolorbar already lives in common_mp_materials.csv. Replace it with something new.
	
	level.HUDItem[ "yaw_meter_arrow" ] = NewClientHudElem( self );
	level.HUDItem[ "yaw_meter_arrow" ].x = -85;
	level.HUDItem[ "yaw_meter_arrow" ].y = 150;
	level.HUDItem[ "yaw_meter_arrow" ].sort = 6;
	level.HUDItem[ "yaw_meter_arrow" ].horzalign = "center";
	level.HUDItem[ "yaw_meter_arrow" ].vertalign = "middle";
	level.HUDItem[ "yaw_meter_arrow" ] SetShader( "hud_killstreak_dpad_arrow_down", 20, 20 );		//TODO: hud_killstreak_dpad_arrow_down already lives in common_mp_materials.csv. Replace it with something new.
	
	level.HUDItem[ "yaw_meter_label" ] = NewClientHudElem( self );
	level.HUDItem[ "yaw_meter_label" ].x = 0;
	level.HUDItem[ "yaw_meter_label" ].y = 180;
	level.HUDItem[ "yaw_meter_label" ].alignX = "center";
	level.HUDItem[ "yaw_meter_label" ].alignY = "top";
	level.HUDItem[ "yaw_meter_label" ].horzAlign = "center";
	level.HUDItem[ "yaw_meter_label" ].vertAlign = "middle";
	level.HUDItem[ "yaw_meter_label" ].fontScale = 2.0;
	level.HUDItem[ "yaw_meter_label" ] SetText( "YAW" );		//TODO: replace with localized string.
	level.HUDItem[ "yaw_meter_label" ].alpha = 1.0;
	
	
	
	//Laser ground position.
	level.HUDItem[ "laser_pos_label" ] = NewClientHudElem( self );
	level.HUDItem[ "laser_pos_label" ].x = -170;
	level.HUDItem[ "laser_pos_label" ].y = -90;
	level.HUDItem[ "laser_pos_label" ].alignX = "right";
	level.HUDItem[ "laser_pos_label" ].alignY = "middle";
	level.HUDItem[ "laser_pos_label" ].horzAlign = "center";
	level.HUDItem[ "laser_pos_label" ].vertAlign = "middle";
	level.HUDItem[ "laser_pos_label" ].fontScale = 1.0;
	level.HUDItem[ "laser_pos_label" ] SetText( "Focus" );		//TODO: replace with localized string.
	level.HUDItem[ "laser_pos_label" ].alpha = 1.0;
	
	level.HUDItem[ "laser_posx" ] = NewClientHudElem( self );
	level.HUDItem[ "laser_posx" ].x = -170;
	level.HUDItem[ "laser_posx" ].y = -80;
	level.HUDItem[ "laser_posx" ].alignX = "right";
	level.HUDItem[ "laser_posx" ].alignY = "middle";
	level.HUDItem[ "laser_posx" ].horzAlign = "center";
	level.HUDItem[ "laser_posx" ].vertAlign = "middle";
	level.HUDItem[ "laser_posx" ].fontScale = 1.0;
	level.HUDItem[ "laser_posx" ].alpha = 1.0;
	
	level.HUDItem[ "laser_posy" ] = NewClientHudElem( self );
	level.HUDItem[ "laser_posy" ].x = -170;
	level.HUDItem[ "laser_posy" ].y = -70;
	level.HUDItem[ "laser_posy" ].alignX = "right";
	level.HUDItem[ "laser_posy" ].alignY = "middle";
	level.HUDItem[ "laser_posy" ].horzAlign = "center";
	level.HUDItem[ "laser_posy" ].vertAlign = "middle";
	level.HUDItem[ "laser_posy" ].fontScale = 1.0;
	level.HUDItem[ "laser_posy" ].alpha = 1.0;
	
	level.HUDItem[ "laser_posz" ] = NewClientHudElem( self );
	level.HUDItem[ "laser_posz" ].x = -170;
	level.HUDItem[ "laser_posz" ].y = -60;
	level.HUDItem[ "laser_posz" ].alignX = "right";
	level.HUDItem[ "laser_posz" ].alignY = "middle";
	level.HUDItem[ "laser_posz" ].horzAlign = "center";
	level.HUDItem[ "laser_posz" ].vertAlign = "middle";
	level.HUDItem[ "laser_posz" ].fontScale = 1.0;
	level.HUDItem[ "laser_posz" ].alpha = 1.0;
	
	
	
	// aiming position
	level.HUDItem[ "aim_pos_label" ] = NewClientHudElem( self );
	level.HUDItem[ "aim_pos_label" ].x = -170;
	level.HUDItem[ "aim_pos_label" ].y = -25;
	level.HUDItem[ "aim_pos_label" ].alignX = "right";
	level.HUDItem[ "aim_pos_label" ].alignY = "middle";
	level.HUDItem[ "aim_pos_label" ].horzAlign = "center";
	level.HUDItem[ "aim_pos_label" ].vertAlign = "middle";
	level.HUDItem[ "aim_pos_label" ].fontScale = 1.0;
	level.HUDItem[ "aim_pos_label" ] SetText( "Target" );		//TODO: replace with localized string.
	level.HUDItem[ "aim_pos_label" ].alpha = 1.0;
	
	level.HUDItem[ "aim_posx" ] = NewClientHudElem( self );
	level.HUDItem[ "aim_posx" ].x = -170;
	level.HUDItem[ "aim_posx" ].y = -15;
	level.HUDItem[ "aim_posx" ].alignX = "right";
	level.HUDItem[ "aim_posx" ].alignY = "middle";
	level.HUDItem[ "aim_posx" ].horzAlign = "center";
	level.HUDItem[ "aim_posx" ].vertAlign = "middle";
	level.HUDItem[ "aim_posx" ].fontScale = 1.0;
	level.HUDItem[ "aim_posx" ].alpha = 1.0;
	
	level.HUDItem[ "aim_posy" ] = NewClientHudElem( self );
	level.HUDItem[ "aim_posy" ].x = -170;
	level.HUDItem[ "aim_posy" ].y = -5;
	level.HUDItem[ "aim_posy" ].alignX = "right";
	level.HUDItem[ "aim_posy" ].alignY = "middle";
	level.HUDItem[ "aim_posy" ].horzAlign = "center";
	level.HUDItem[ "aim_posy" ].vertAlign = "middle";
	level.HUDItem[ "aim_posy" ].fontScale = 1.0;
	level.HUDItem[ "aim_posy" ].alpha = 1.0;
	
	level.HUDItem[ "aim_posz" ] = NewClientHudElem( self );
	level.HUDItem[ "aim_posz" ].x = -170;
	level.HUDItem[ "aim_posz" ].y = 5;
	level.HUDItem[ "aim_posz" ].alignX = "right";
	level.HUDItem[ "aim_posz" ].alignY = "middle";
	level.HUDItem[ "aim_posz" ].horzAlign = "center";
	level.HUDItem[ "aim_posz" ].vertAlign = "middle";
	level.HUDItem[ "aim_posz" ].fontScale = 1.0;
	level.HUDItem[ "aim_posz" ].alpha = 1.0;
	
	
	
	// player position
	level.HUDItem[ "player_pos_label" ] = NewClientHudElem( self );
	level.HUDItem[ "player_pos_label" ].x = -170;
	level.HUDItem[ "player_pos_label" ].y = 50;
	level.HUDItem[ "player_pos_label" ].alignX = "right";
	level.HUDItem[ "player_pos_label" ].alignY = "middle";
	level.HUDItem[ "player_pos_label" ].horzAlign = "center";
	level.HUDItem[ "player_pos_label" ].vertAlign = "middle";
	level.HUDItem[ "player_pos_label" ].fontScale = 1.0;
	level.HUDItem[ "player_pos_label" ] SetText( "Operator" );		//TODO: replace with localized string.
	level.HUDItem[ "player_pos_label" ].alpha = 1.0;
	
	level.HUDItem[ "player_posx" ] = NewClientHudElem( self );
	level.HUDItem[ "player_posx" ].x = -170;
	level.HUDItem[ "player_posx" ].y = 60;
	level.HUDItem[ "player_posx" ].alignX = "right";
	level.HUDItem[ "player_posx" ].alignY = "middle";
	level.HUDItem[ "player_posx" ].horzAlign = "center";
	level.HUDItem[ "player_posx" ].vertAlign = "middle";
	level.HUDItem[ "player_posx" ].fontScale = 1.0;
	level.HUDItem[ "player_posx" ].alpha = 1.0;

	level.HUDItem[ "player_posy" ] = NewClientHudElem( self );
	level.HUDItem[ "player_posy" ].x = -170;
	level.HUDItem[ "player_posy" ].y = 70;
	level.HUDItem[ "player_posy" ].alignX = "right";
	level.HUDItem[ "player_posy" ].alignY = "middle";
	level.HUDItem[ "player_posy" ].horzAlign = "center";
	level.HUDItem[ "player_posy" ].vertAlign = "middle";
	level.HUDItem[ "player_posy" ].fontScale = 1.0;
	level.HUDItem[ "player_posy" ].alpha = 1.0;
	
	level.HUDItem[ "player_posz" ] = NewClientHudElem( self );
	level.HUDItem[ "player_posz" ].x = -170;
	level.HUDItem[ "player_posz" ].y = 80;
	level.HUDItem[ "player_posz" ].alignX = "right";
	level.HUDItem[ "player_posz" ].alignY = "middle";
	level.HUDItem[ "player_posz" ].horzAlign = "center";
	level.HUDItem[ "player_posz" ].vertAlign = "middle";
	level.HUDItem[ "player_posz" ].fontScale = 1.0;
	level.HUDItem[ "player_posz" ].alpha = 1.0;
	
	level.HUDItem[ "player_posx" ] SetValue( abs( self.origin[0] ) );
	level.HUDItem[ "player_posy" ] SetValue( abs( self.origin[1] ) );
	level.HUDItem[ "player_posz" ] SetValue( abs( self.origin[2] ) );
	
	
	
	wait 0.05;
	
	while (1)
	{
//		level.solar_reflector_dish.angles = self.laser_angles + (90, 0, 0);
//		level.solar_reflector_swivel.angles = (0, self.laser_angles[1], 0);
		
		level.HUDItem[ "laser_posx" ] SetValue( self.laser_ground_point.origin[0] );
		level.HUDItem[ "laser_posy" ] SetValue( self.laser_ground_point.origin[1] );
		level.HUDItem[ "laser_posz" ] SetValue( self.laser_ground_point.origin[2] );
		
		level.HUDItem[ "aim_posx" ] SetValue( self.cam_view_ground_point.origin[0] );
		level.HUDItem[ "aim_posy" ] SetValue( self.cam_view_ground_point.origin[1] );
		level.HUDItem[ "aim_posz" ] SetValue( self.cam_view_ground_point.origin[2] );
		
		//Pitch varies between ~21 and ~66 degrees.
		level.solar_reflector_pitch_ratio = (level.solar_reflector_vfx_tag.angles[0] - 21) / 66;
		level.HUDItem[ "pitch_meter_arrow" ].y = -85 + 150 * level.solar_reflector_pitch_ratio;
		
		//Yaw varies between ~88 and ~270 degrees.
		level.solar_reflector_yaw_ratio = (level.solar_reflector_vfx_tag.angles[1] - 88) / 182;
		level.HUDItem[ "yaw_meter_arrow" ].x = 65 - 150 * level.solar_reflector_yaw_ratio;
		
//		level.HUDItem[ "player_posx" ] SetValue( level.solar_reflector_vfx_tag.angles[0] );
//		level.HUDItem[ "player_posy" ] SetValue( level.solar_reflector_vfx_tag.angles[1] );
		
		wait(0.05);
	}
}


/*
=============
///ScriptDocBegin
"Name: createSolarKillstreakClock()"
"Summary: HUD clock for mp_solar map-based killstreak duration."
"Module: Entity"
"CallOn: the player using the mp_solar map-based killstreak."
"Example: player thread createSolarKillstreakClock()"
"SPMP: MP"
///ScriptDocEnd
=============
*/
createSolarKillstreakClock()
{
	level endon( "game_ended" );
	self endon( "disconnect" );
	self endon ( "solar_reflector_player_removed" );
	
	self.solar_clock = maps\mp\gametypes\_hud_util::createTimer( "hudsmall", 0.9 );
	self.solar_clock maps\mp\gametypes\_hud_util::setPoint( "CENTER", "CENTER", 0, -145 );
	self.solar_clock setTimer( GetDvarFloat( "scr_solar_killstreak_duration", 30.0 ) );
	self.solar_clock.color = ( 1.0, 1.0, 1.0 );
	self.solar_clock.archived = false;
	self.solar_clock.foreground = true;
	
	self thread destroySolarKillstreakClock();
}


/*
=============
///ScriptDocBegin
"Name: destroySolarKillstreakClock()"
"Summary: cleans up the timer for the mp_solar map-based killstreak HUD."
"Module: Entity"
"CallOn: the player using the mp_solar map-based killstreak."
"Example: player thread destroySolarKillstreakClock()"
"SPMP: MP"
///ScriptDocEnd
=============
*/
destroySolarKillstreakClock()
{
	self waittill( "solar_reflector_player_removed" );
	
	if ( IsDefined( self.solar_clock ) )
	{
		self.solar_clock Destroy();
	}
}


waitSetThermal( delay )
{
	self endon( "disconnect" );
	level endon( "solar_reflector_player_removed" );

	wait( delay	);

	self VisionSetThermalForPlayer( game["thermal_vision"], 0 );
	self ThermalVisionFOFOverlayOn();
	self thread thermalVision();
}


/*
=============
///ScriptDocBegin
"Name: removeSolarReflectorPlayerOnCommand()"
"Summary: removes the Solar Reflector player if the player holds down the exit button"
"Module: Entity"
"CallOn: the player controlling the Solar Reflector"
"Example: player thread removeSolarReflectorPlayerOnCommand()"
"SPMP: MP"
///ScriptDocEnd
=============
*/
removeSolarReflectorPlayerOnCommand()
{
	self endon ( "solar_reflector_player_removed" );
	
	while ( true )
	{
		button_hold_time = 0;
		while ( self JumpButtonPressed() )
		{
			button_hold_time += 0.05;
			if ( button_hold_time > 0.75 )
			{
				level thread removeSolarReflectorPlayer( self, false );
				return;
			}
			wait(0.05);
		}
		wait(0.05);
	}
}


removeSolarReflectorPlayerOnGameCleanup()
{
	self endon ( "solar_reflector_player_removed" );
	
	level waittill ( "game_cleanup" );

	level thread removeSolarReflectorPlayer( self, false );
}


removeSolarReflectorPlayerOnDeath()
{
	self endon ( "solar_reflector_player_removed" );
	
	self waittill ( "death" );

	level thread removeSolarReflectorPlayer( self, false );
}


removeSolarReflectorPlayerOnDisconnect()
{
	self endon ( "solar_reflector_player_removed" );

	self waittill ( "disconnect" );

	level thread removeSolarReflectorPlayer( self, true );
}


removeSolarReflectorPlayerOnChangeTeams()
{
	self endon ( "solar_reflector_player_removed" );

	self waittill ( "joined_team" );

	level thread removeSolarReflectorPlayer( self, false);
}


removeSolarReflectorPlayerOnSpectate()
{
	self endon ( "solar_reflector_player_removed" );

	self waittill_any ( "joined_spectators", "spawned" );

	level thread removeSolarReflectorPlayer( self, false);
}


removeSolarReflectorPlayerAfterTime( removeDelay )
{
	self endon ( "solar_reflector_player_removed" );
	
	maps\mp\gametypes\_hostmigration::waitLongDurationWithHostMigrationPause( removeDelay );
	
	level thread removeSolarReflectorPlayer( self, false );
}


removeSolarReflectorPlayer( player, disconnected )
{
	player notify ( "solar_reflector_player_removed" );
	level notify ( "solar_reflector_player_removed" );
	
	waittillframeend;
	
	if ( !disconnected )
	{
		player clearUsingRemote();

		player show();
		player unlink();

		player ThermalVisionOff();
		player ThermalVisionFOFOverlayOff();
		player VisionSetThermalForPlayer( level.solar_reflector_cam_tag.thermal_vision, 0 );
		player.lastVisionSetThermal = level.solar_reflector_cam_tag.thermal_vision;
		player setBlurForPlayer( 0, 0 );

		if ( getDvarInt( "camera_thirdPerson" ) )
			player setThirdPersonDOF( true );

		if ( isDefined( player.darkScreenOverlay ) )
			player.darkScreenOverlay destroy();	

		keys = getArrayKeys( level.HUDItem );
		
		foreach ( key in keys )
		{
			level.HUDItem[key] destroy();
			level.HUDItem[key] = undefined;
		}
	}
	
	// TODO: this might already be undefined if the player disconnected... need a better solution.
	// we could set it to "true" or something... but we'll have to check places it is used for potential issues with that.
	level.solar_reflector_player = undefined;

	wait ( 30.0 );
}


overlay( player )
{
	level.HUDItem[ "thermal_vision" ] = NewClientHudElem( player );
	level.HUDItem[ "thermal_vision" ].x = 200;
	level.HUDItem[ "thermal_vision" ].y = 0;
	level.HUDItem[ "thermal_vision" ].alignX = "left";
	level.HUDItem[ "thermal_vision" ].alignY = "top";
	level.HUDItem[ "thermal_vision" ].horzAlign = "left";
	level.HUDItem[ "thermal_vision" ].vertAlign = "top";
	level.HUDItem[ "thermal_vision" ].fontScale = 2.5;
	level.HUDItem[ "thermal_vision" ] SetText( &"AC130_HUD_FLIR" );
	level.HUDItem[ "thermal_vision" ].alpha = 1.0;

	level.HUDItem[ "enhanced_vision" ] = NewClientHudElem( player );
	level.HUDItem[ "enhanced_vision" ].x = -200;
	level.HUDItem[ "enhanced_vision" ].y = 0;
	level.HUDItem[ "enhanced_vision" ].alignX = "right";
	level.HUDItem[ "enhanced_vision" ].alignY = "top";
	level.HUDItem[ "enhanced_vision" ].horzAlign = "right";
	level.HUDItem[ "enhanced_vision" ].vertAlign = "top";
	level.HUDItem[ "enhanced_vision" ].fontScale = 2.5;
	level.HUDItem[ "enhanced_vision" ] SetText( &"AC130_HUD_OPTICS" );
	level.HUDItem[ "enhanced_vision" ].alpha = 1.0;
	
	player setBlurForPlayer( 1.2, 0 );
}


attachPlayer()
{
	self PlayerLinkWeaponviewToDelta( level.solar_reflector_cam_tag, "tag_player", 1.0, 80, 80, 30, 12 );
	self setPlayerAngles( level.solar_reflector_cam_tag getTagAngles( "tag_player" ) );
}


thermalVision()
{
	self endon ( "solar_reflector_player_removed" );
	
	if ( getIntProperty( "ac130_thermal_enabled", 1 ) == 0 )
		return;
	
	inverted = false;
	
	self ThermalVisionOff();
	self VisionSetThermalForPlayer( level.solar_reflector_cam_tag.enhanced_vision, 1 );
	self.lastVisionSetThermal = level.solar_reflector_cam_tag.enhanced_vision;
	level.HUDItem["thermal_vision"].alpha = 0.25;
	level.HUDItem["enhanced_vision"].alpha = 1.0;

	self notifyOnPlayerCommand( "switch thermal", "+usereload" );
	self notifyOnPlayerCommand( "switch thermal", "+activate" );

	for (;;)
	{
		self waittill ( "switch thermal" );
		
		if ( !inverted )
		{
			self ThermalVisionOn();
			self VisionSetThermalForPlayer( level.solar_reflector_cam_tag.thermal_vision, 0.62 );
			self.lastVisionSetThermal = level.solar_reflector_cam_tag.thermal_vision;
			level.HUDItem["thermal_vision"].alpha = 1.0;
			level.HUDItem["enhanced_vision"].alpha = 0.25;
		}
		else
		{
			self ThermalVisionOff();
			self VisionSetThermalForPlayer( level.solar_reflector_cam_tag.enhanced_vision, 0.51 );
			self.lastVisionSetThermal = level.solar_reflector_cam_tag.enhanced_vision;
			level.HUDItem["thermal_vision"].alpha = 0.25;
			level.HUDItem["enhanced_vision"].alpha = 1.0;
		}

		inverted = !inverted;
	}
}

setupLightbeamArrayFX()
{
	level.solar_lightbeam_array = [];
			
	LightbeamFocus = GetStruct("solar_lightbeam_focus", "targetname");
	LightbeamStruct = getStructArray("solar_lightbeam", "targetname");
	foreach (beam in LightbeamStruct)
	{
		beamangle = VectorToAngles(LightbeamFocus.origin - beam.origin);
		beamfx = spawnfx(level.solar_array_lightbeam, beam.origin, AnglesToForward(beamangle), AnglesToUp(beamangle));
		level.solar_lightbeam_array[level.solar_lightbeam_array.size] = beamfx;
	}
}

playLightbeamArrayFX()
{
	level endon( "game_ended" );
	self endon( "disconnect" );
	self endon( "solar_reflector_player_removed" );
	
	for(;;)
	{
		ActivateClientExploder(20);
		wait 0.2;
	}
}
		
