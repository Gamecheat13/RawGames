#using scripts\codescripts\struct;

#using scripts\shared\challenges_shared;
#using scripts\shared\clientfield_shared;
#using scripts\shared\damagefeedback_shared;
#using scripts\shared\gameobjects_shared;
#using scripts\shared\hostmigration_shared;
#using scripts\shared\hud_shared;
#using scripts\shared\math_shared;
#using scripts\shared\scoreevents_shared;
#using scripts\shared\util_shared;
#using scripts\shared\weapons\_heatseekingmissile;
#using scripts\shared\weapons\_weapon_utils;
#using scripts\shared\weapons\_weaponobjects;


    	   	                                                                                                                         	                                                                                                                                                                                                                                                                                                                                                                    	        	     	             	    	   	                           	                               	                                	                                                              	                                                                                                              	                            	                                     	                                       	                                                               	   	                  	       	                                                    	                   	                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                        	                                                                                        	           	                        	                                            	                                             	                                                   	                                                             	                                                         	                                                                    	                                                                                                                                                                                                    	                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                      	                                                              	                                                          	                                   	                                   	                                                    	                                       

#using scripts\mp\gametypes\_hostmigration;
#using scripts\mp\gametypes\_spawning;

#using scripts\mp\_challenges;
#using scripts\mp\_popups;
#using scripts\mp\_util;
#using scripts\mp\killstreaks\_airsupport;
#using scripts\mp\killstreaks\_helicopter;
#using scripts\mp\killstreaks\_killstreakrules;
#using scripts\mp\killstreaks\_killstreaks;
#using scripts\mp\killstreaks\_uav;

                                            

#precache( "material", "compass_lodestar" );
#precache( "string", "KILLSTREAK_EARNED_REMOTE_MORTAR" );
#precache( "string", "KILLSTREAK_REMOTE_MORTAR_NOT_AVAILABLE" );
#precache( "string", "KILLSTREAK_REMOTE_MORTAR_INBOUND" );
#precache( "eventstring", "remotemortar" );
#precache( "eventstring", "mpl_killstreak_planemortar" );
#precache( "fx", "killstreaks/fx_lstar_laser_loop" );
#precache( "fx", "killstreaks/fx_lstar_exp"  );

#namespace remotemortar;

function init()
{
	level.remote_mortar_fx["laserTarget"] = "killstreaks/fx_lstar_laser_loop";
	level.remote_mortar_fx["missileExplode"] = "killstreaks/fx_lstar_exp" ;

	killstreaks::register( "remote_mortar", "remote_mortar", "killstreak_remote_mortar", "remote_mortar_used",&remote_mortar_killstreak, true );
	killstreaks::register_alt_weapon( "remote_mortar", "remote_mortar_missile" );
	killstreaks::register_strings( "remote_mortar", &"KILLSTREAK_EARNED_REMOTE_MORTAR", &"KILLSTREAK_REMOTE_MORTAR_NOT_AVAILABLE", &"KILLSTREAK_REMOTE_MORTAR_INBOUND" );
	killstreaks::register_dialog( "remote_mortar", "mpl_killstreak_planemortar", "kls_reaper_used", "", "kls_reaper_enemy", "", "kls_reaper_ready" );
	killstreaks::set_team_kill_penalty_scale( "remote_mortar", level.teamKillReducedPenalty );
	killstreaks::override_entity_camera_in_demo("remote_mortar", true);
	
	util::set_dvar_float_if_unset( "scr_remote_mortar_lifetime", 45.0 );
	
	level.remore_mortar_infrared_vision = "remote_mortar_infrared";
	level.remore_mortar_enhanced_vision = "remote_mortar_enhanced";
	
	minimapOrigins = getEntArray( "minimap_corner", "targetname" );
	if ( miniMapOrigins.size )
		uavOrigin = math::find_box_center( miniMapOrigins[0].origin, miniMapOrigins[1].origin );
	else
		uavOrigin = (0,0,0);

	if( level.script == "mp_la" )
		uavOrigin = uavOrigin + ( 1200, 0, 0 );
	if( level.script == "mp_hydro" )
		uavOrigin = uavOrigin + ( 0, 2000, 0 );
	if( level.script == "mp_concert" )
		uavOrigin = uavOrigin + ( 0, -750, 0 );
	if( level.script == "mp_vertigo" )
		uavOrigin = uavOrigin + ( -500, 0, 0 );
	
	level.remoteMortarRig = spawn( "script_model", uavOrigin );
	level.remoteMortarRig setModel( "tag_origin" );
	level.remoteMortarRig.angles = (0,115,0);
	level.remoteMortarRig hide();

	level.remoteMortarRig thread rotateRig(true);
	
	level.remote_zOffset = 8000;
	level.remote_radiusOffset = 9000;
	remote_mortar_height = struct::get( "remote_mortar_height", "targetname");
	if ( isdefined(remote_mortar_height) )
	{
		level.remote_radiusOffset = (remote_mortar_height.origin[2]/level.remote_zOffset) * level.remote_radiusOffset;
		level.remote_zOffset = remote_mortar_height.origin[2];
	}
}

function remote_mortar_killstreak( hardpointType )
{
	assert( hardpointType == "remote_mortar" );

	if ( self killstreakrules::isKillstreakAllowed( hardpointType, self.team ) == false )
	{
		return false;	
	}

	if (!self IsOnGround() || self util::isUsingRemote() )
	{
		self iPrintLnBold( &"KILLSTREAK_REMOTE_MORTAR_NOT_USABLE" );
		return false;
	}
	
	self util::setUsingRemote( hardpointType );
	self util::freeze_player_controls( true );
	self DisableWeaponCycling();
		
	result = self killstreaks::init_ride_killstreak( "qrdrone" );		
	
	if ( result != "success" )
	{
		if ( result != "disconnect" )
		{
			self notify( "remote_mortar_unlock" );
			self killstreaks::clear_using_remote();
			self EnableWeaponCycling();
		}

		return false;
	}	

	killstreak_id = self killstreakrules::killstreakStart (hardpointType, self.team, false, true );
	if ( killstreak_id == -1 )
	{
		self killstreaks::clear_using_remote();
		self EnableWeaponCycling();
		self notify( "remote_mortar_unlock" );
		return false;
	}

	self.killstreak_waitamount = ( GetDvarFloat( "scr_remote_mortar_lifetime" ) * 1000 );
	
	remote = self remote_mortar_spawn();
	remote SetDrawInfrared( true );
	remote thread remote_killstreak_abort();
	remote thread remote_killstreak_game_end();
	remote thread remote_owner_exit();
	remote thread remote_owner_teamKillKicked();
	remote thread remote_damage_think();
	remote thread play_lockon_sounds( self );
	//remote thread heatseekingmissile::MissileTarget_LockOnMonitor( self, "remote_end" );				// monitors missle lock-ons
	remote thread heatseekingmissile::MissileTarget_ProximityDetonateIncomingMissile( "crashing" );
	remote.killstreak_id = killstreak_id;
	
	remote thread play_remote_fx();

	remote playloopsound( "mpl_ks_reaper_exterior_loop", 1 );

	self.pilotTalking = false;
	remote.copilotVoiceNumber = self.bcVoiceNumber;
	remote.pilotVoiceNumber = self.bcVoiceNumber + 1;
	if 	(remote.pilotVoiceNumber > 3) 
	{
		remote.pilotVoiceNumber = 0;
	}

	self util::clientNotify( "krms" );

	self player_linkto_remote( remote );
	
	self util::freeze_player_controls( false );

	self thread player_aim_think( remote );
	self thread player_fire_think( remote );
	//self thread create_remote_mortar_hud( remote );
	self killstreaks::play_killstreak_start_dialog( "remote_mortar", self.pers["team"] );
	remote thread remote_killstreak_copilot(remote.copilotVoiceNumber);

	self AddWeaponStat( GetWeapon( "remote_mortar" ), "used", 1 );

	
	self thread visionSwitch();
	
	level waittill( "remote_unlinked" );
	
	if ( isdefined( remote ) )
		remote stoploopsound( 4 );

	if ( !isdefined( self ) )
		return true;

	self util::clientNotify( "krme" );
	
	self clientfield::set( "operating_reaper", 0 );
	self util::clientNotify( "nofutz" );
	self killstreaks::clear_using_remote();

	return true;
}
function remote_killstreak_copilot(voice)
{
	level endon( "remote_end" );
	
	wait 2.5;
		
	while (1)
	{
		self thread helicopter::PlayPilotDialog( "reaper_used", 0, voice );
		wait RandomFloatRange (4.5, 15);
	}
}
function remote_killstreak_abort()
{
	level endon( "remote_end" );
	assert( isdefined( self.owner ) );
	assert( IsPlayer( self.owner ) );

	self.owner util::waittill_any( "disconnect", "joined_team", "joined_spectators" );

	self thread remote_killstreak_end( false, true );
}

function remote_owner_teamKillKicked( hardpointtype )
{
	level endon( "remote_end" );
	
	self.owner waittill( "teamKillKicked" );
	self thread remote_killstreak_end();
}

function remote_owner_exit()
{
	level endon( "remote_end" );
	
	wait( 1 );
	
	while( true )
	{
		timeUsed = 0;
		while( self.owner UseButtonPressed() )
		{
			timeUsed += 0.05;
			if ( timeUsed > 0.25 )
			{
				self thread remote_killstreak_end();
				return;
			}
			{wait(.05);};
		}
		{wait(.05);};
	}	
}

function remote_killstreak_game_end()
{
	level endon( "remote_end" );
	assert( isdefined( self.owner ) );
	assert( IsPlayer( self.owner ) );

	level waittill( "game_ended" );
	self thread remote_killstreak_end();
}

function remote_mortar_spawn()
{
	self clientfield::set( "operating_reaper", 1 );
	self util::clientNotify( "reapfutz" );

	remote = SpawnPlane( self, "script_model", level.remoteMortarRig GetTagOrigin( "tag_origin" ) );
	assert( isdefined( remote ) );

	remote SetModel( "veh_t6_drone_pegasus_mp" );
	remote.targetname = "remote_mortar";

	remote SetOwner( self );
	remote SetTeam( self.team );
	remote.team = self.team;
	remote.owner = self;
	remote.numFlares = 2;
	remote.flareOffset = (0,0,-256);
	remote clientfield::set( "enemyvehicle", 1 );
	remote.attackers = [];
	remote.attackerData = [];
	remote.attackerDamage = [];
	remote.flareAttackerDamage = [];
	
	remote.pilotVoiceNumber = self.bcVoiceNumber + 1;
	if 	(remote.pilotVoiceNumber > 3) 
	{
		remote.pilotVoiceNumber = 0;
	}
	
	//	same height and radius as the AC130 with random angle and counter rotation
	angle = randomInt( 360 );
	xOffset = cos( angle ) * level.remote_radiusOffset;
	yOffset = sin( angle ) * level.remote_radiusOffset;
	angleVector = vectorNormalize( (xOffset,yOffset,level.remote_zOffset) );
	angleVector = ( angleVector * 6100 );
	remote LinkTo( level.remoteMortarRig, "tag_origin", angleVector, (0,angle-90,0) );	
	
	remoteObjIDFriendly = gameobjects::get_next_obj_id();	
	objective_add( remoteObjIDFriendly, "invisible", remote.origin, &"remotemortar", self );
	objective_state( remoteObjIDFriendly, "active" );
	Objective_OnEntity( remoteObjIDFriendly, remote );
	objective_team( remoteObjIDFriendly, self.team );
	self.remoteObjIDFriendly = remoteObjIDFriendly;
	
	// laser fx
//	remote.fx = spawnFx( level.remote_mortar_fx["laserTarget"], (0,0,0) );	
	remote.fx = spawn( "script_model", (0,0,0) );
	remote.fx SetModel( "tag_origin" );

	// the owner is going to have this fx created and updated
	remote.fx SetInvisibleToPlayer( remote.owner, true );

	// visibility
	remote remote_mortar_visibility();

	Target_SetTurretAquire( remote, true );
	
	return remote;
}

function rotateRig( clockwise )
{
	turn = 360;
	if ( clockwise )
		turn = -360;
	
	for (;;)
	{
		if ( !clockwise )
		{
			self rotateyaw( turn, 30 );
			wait ( 30 );
		}
		else
		{
			self rotateyaw( turn, 45 );
			wait ( 45 );
		}
	}
}

function remote_mortar_visibility()
{
	players = GetPlayers();

	foreach( player in players )
	{
		if ( player == self.owner )
		{
			self SetInvisibleToPlayer( player );
			continue;
		}

		self SetVisibleToPlayer( player );
	}
}

function play_lockon_sounds( player )
{
	player endon("disconnect");
	self endon( "death" );
	self endon("remote_end");
		
	self.lockSounds = spawn( "script_model", self.origin);
	wait ( 0.1 );
	self.lockSounds LinkTo( self, "tag_player" );
	
	while ( true )
	{
		self waittill( "locking on" );
		
		while ( true )
		{
			if ( enemy_locking() )
			{
				//self PlaySoundToPlayer( "uin_alert_lockon_start", player );				
				//wait ( 0.3 );
								
				self PlaySoundToPlayer( "uin_alert_lockon", player );
				wait ( 0.125 );
			}
			
			if ( enemy_locked() )
			{
				self PlaySoundToPlayer( "uin_alert_lockon", player );
				wait ( 0.125 );
			}
			
			if ( !enemy_locking() && !enemy_locked() )
			{
				break;
			}			
		}
	}
}

function enemy_locking()
{
	if ( isdefined(self.locking_on) && self.locking_on )
		return true;
	
	return false;
}

function enemy_locked()
{
	if ( isdefined(self.locked_on) && self.locked_on )
		return true;
			
	return false;
}

function create_remote_mortar_hud( remote )
{
	self.missile_hud = newclienthudelem( self );
	self.missile_hud.alignX = "left";
	self.missile_hud.alignY = "bottom";
	self.missile_hud.horzAlign = "user_left";
	self.missile_hud.vertAlign = "user_bottom";
	self.missile_hud.font = "small";
	self.missile_hud SetText("[{+attack}]" + "Fire Missile");
	self.missile_hud.hidewheninmenu = true;
	self.missile_hud.hideWhenInDemo = true;
	self.missile_hud.x = 5;
	self.missile_hud.y = -40;
	self.missile_hud.fontscale = 1.25;
	
	self.zoom_hud = newclienthudelem( self );
	self.zoom_hud.alignX = "left";
	self.zoom_hud.alignY = "bottom";
	self.zoom_hud.horzAlign = "user_left";
	self.zoom_hud.vertAlign = "user_bottom";
	self.zoom_hud.font = "small";
	self.zoom_hud SetText(&"KILLSTREAK_INCREASE_ZOOM");
	self.zoom_hud.hidewheninmenu = true;
	self.zoom_hud.hideWhenInDemo = true;
	self.zoom_hud.x = 5;
	self.zoom_hud.y = -25;
	self.zoom_hud.fontscale = 1.25;
	
	self.hud_prompt_exit = newclienthudelem( self );
	self.hud_prompt_exit.alignX = "left";
	self.hud_prompt_exit.alignY = "bottom";
	self.hud_prompt_exit.horzAlign = "user_left";
	self.hud_prompt_exit.vertAlign = "user_bottom";
	self.hud_prompt_exit.font = "small";
	self.hud_prompt_exit.fontScale = 1.25;
	self.hud_prompt_exit.hidewheninmenu = true;
	self.hud_prompt_exit.hideWhenInDemo = true;
	self.hud_prompt_exit.archived = false;
	self.hud_prompt_exit.x = 5;
	self.hud_prompt_exit.y = -10;
	self.hud_prompt_exit SetText(level.remoteExitHint);	
	
	self thread fade_out_hint_hud( remote );
}

function fade_out_hint_hud( remote )
{
	self endon( "disconnect" );
	remote endon( "death" );
	
	wait( 8 );
	time = 0;
	while (time < 2)
	{
		if ( !isdefined(self.missile_hud))
		{
			return;	
		}
		self.missile_hud.alpha -= 0.025;
		self.zoom_hud.alpha -= 0.025;
		time += 0.05;
		{wait(.05);};
	}
	
	self.missile_hud.alpha = 0;
	self.zoom_hud.alpha = 0;
}

function remove_hud()
{
	if ( isdefined(self.missile_hud) )
		self.missile_hud destroy();
	if ( isdefined(self.zoom_hud) )
		self.zoom_hud destroy();	
	if ( isdefined(self.hud_prompt_exit) )
		self.hud_prompt_exit destroy();	
}


function remote_killstreak_end( explode, disconnected )
{
	level notify( "remote_end" );

	if ( !isdefined( explode ) )
		explode = false;
	
	if ( !isdefined( disconnected ) )
		disconnected = false;
	
	if ( isdefined( self.owner ) )
	{
		if ( disconnected == false ) 
		{
		    if ( explode )
		    {
			    self.owner SendKillstreakDamageEvent( 600 );
			    self.owner thread hud::fade_to_black_for_x_sec( 0.5, 0.5, 0.1, 0.25 );
			    wait 1;
		    }
		    else
		    {
			    self.owner SendKillstreakDamageEvent( 600 );
			    self.owner thread hud::fade_to_black_for_x_sec( 0, 0.25, 0.1, 0.25 );
			    wait 0.25;
		    }
		}
		self.owner Unlink();
		self.owner.killstreak_waitamount = undefined;	

		self.owner EnableWeaponCycling();
		self.owner remove_hud();
		
		if ( isdefined(level.gameEnded) && level.gameEnded )
		{
			self.owner util::freeze_player_controls( true );
		}
	}

	if ( isdefined( self.influencers ) )
	{
		self spawning::remove_influencers();
	}
	Objective_Delete( self.owner.remoteObjIDFriendly );
	gameobjects::release_obj_id( self.owner.remoteObjIDFriendly  );

	Target_SetTurretAquire( self, false );

	level notify( "remote_unlinked" );

	killstreakrules::killstreakStop( "remote_mortar", self.team, self.killstreak_id );
	
	if ( isdefined( self.owner ) )
	{
		self.owner SetInfraredVision( false );
		self.owner UseServerVisionset( false );
	}

	if ( isdefined(self.fx) )
		self.fx delete();
	
	if ( explode )
		self remote_explode();
	else 
		self remote_leave();
}

function player_linkto_remote( remote )
{
	leftArc = 40;
	rightArc = 40;
	upArc = 25;
	downArc = 65;
	
	if ( isdefined( level.remoteMotarViewLeft ) )
	{
		leftArc = level.remoteMotarViewLeft;
	}
	
	if ( isdefined( level.remoteMotarViewRight ) )
	{
		rightArc = level.remoteMotarViewRight;
	}
	
	if ( isdefined( level.remoteMotarViewUp ) )
	{
		upArc = level.remoteMotarViewUp;
	}
	
	if ( isdefined( level.remoteMotarViewDown ) )
	{
		downArc = level.remoteMotarViewDown;
	}
	
/#
	leftArc = GetDvarInt( "scr_remotemortar_right", leftArc ); 
	rightArc = GetDvarInt( "scr_remotemortar_left", rightArc ); 
	upArc = GetDvarInt( "scr_remotemortar_up", upArc ); 
	downArc = GetDvarInt( "scr_remotemortar_down", downArc );
#/
	self PlayerLinkWeaponViewToDelta( remote, "tag_player", 1.0, leftArc, rightArc, upArc, downArc );
	self player_center_view();
}

function player_center_view( org )
{
	{wait(.05);};
	
	lookVec = VectorToAngles( level.UAVRig.origin - self GetEye() );
	self SetPlayerAngles( lookVec  );
}

function player_aim_think( remote )
{	
	level endon( "remote_end" );

	wait( 0.25 );
	
	PlayFxOnTag( level.remote_mortar_fx[ "laserTarget" ], remote.fx, "tag_origin" );
	remote.fx playloopsound( "mpl_ks_reaper_laser" );
	
	while ( true )
	{
		origin = self GetEye();
		forward = AnglesToForward( self GetPlayerAngles() );
		endpoint = origin + forward * 15000;

		trace = BulletTrace( origin, endpoint, false, remote );
		remote.fx.origin = trace[ "position" ];
		remote.fx.angles = VectortoAngles(trace[ "normal" ]);

		self spawning::remove_influencers();
		
		if ( isdefined( self.active_pegasus ) )
		{
			self spawning::create_enemy_influencer( "pegasus", trace[ "position" ], self.team );
		}
		
		{wait(.05);};
	}
}
	
function player_fire_think( remote )
{
	level endon( "remote_end" );
	
	end_time = GetTime() + self.killstreak_waitamount;

	shot = 0;
	
	while( GetTime() < end_time )
	{
		self.active_pegasus = undefined;
		
		if ( !self AttackButtonPressed() )
		{
			{wait(.05);};
			continue;
		}
			
		self playLocalSound( "mpl_ks_reaper_fire" );
		self PlayRumbleOnEntity( "sniper_fire" );
		
		if (shot % 3 == 1)
		{
			if ( isdefined(remote.owner) && isdefined(remote.owner.pilotTalking) && remote.owner.pilotTalking )
				shot = 0;				
			remote thread helicopter::PlayPilotDialog( "reaper_fire", 0.25, undefined, false );
		}
		shot = ( shot + 1 ) % 3;

		origin = self GetEye();
		Earthquake( 0.3, 0.5, origin, 256 );

		angles = self GetPlayerAngles();
		forward = AnglesToForward( angles );
		right = AnglesToRight( angles );
		up = AnglesToUp( angles );

		offset = origin + ( forward * 100 ) + ( right * -40 ) + ( up * -100 );
					
		missile = MagicBullet( GetWeapon( "remote_mortar_missile" ), offset, origin + ( forward * 1000 ) + ( up * -100 ), self, remote.fx );
		
		self.active_pegasus = missile;
		
		missile thread remote_missile_life(remote);
		
		missile waittill( "death" );
		
		self playlocalsound( "mpl_ks_reaper_explosion" );
	}

	self spawning::remove_influencers();
	
	remote thread remote_killstreak_end();
}

function remote_missile_life( remote )
{
	self endon( "death" );
	
	hostmigration::waitLongDurationWithHostMigrationPause( 6 );
	
	playFX( level.remote_mortar_fx["missileExplode"], self.origin );
	self delete();
}

function remote_damage_think()
{	
	level endon( "remote_end" );
	
	self.health = 999999; // keep it from dying anywhere in code
	maxHealth = level.heli_amored_maxhealth; 
	damageTaken = 0; 
	self.lowHealth = false;

	self SetCanDamage( true );
	Target_Set( self, ( 0, 0, 30 ) );
	
	while( true )
	{
		self waittill( "damage", damage, attacker, direction_vec, point, meansOfDeath, tagName, modelName, partname, weapon );		
		self.health = 999999;

		heli_friendlyfire = weaponobjects::friendlyFireCheck( self.owner, attacker );

		// skip damage if friendlyfire is disabled
		if( !heli_friendlyfire )
			continue;
	
		if( IsPlayer( attacker ) )
		{					
			attacker damagefeedback::update( meansOfDeath, undefined, undefined, weapon );

			if ( attacker HasPerk( "specialty_armorpiercing" ) )
			{
				if( meansOfDeath == "MOD_RIFLE_BULLET" || meansOfDeath == "MOD_PISTOL_BULLET" )
				{
					damage += int( damage * level.cac_armorpiercing_data );
				}
			}
		}
		
		if( meansOfDeath == "MOD_RIFLE_BULLET" || meansOfDeath == "MOD_PISTOL_BULLET"  )
		{			
			damage *= level.heli_armor_bulletdamage;
		}
		
		if( weapon == level.weaponNone )
		{
			continue;
		}
		
		if ( isdefined( weapon.isLauncherWeapon ) && weapon.isLauncherWeapon )
		{
			damage = maxHealth + 1;
		}

		if ( damage <= 0 )
		{
			continue;
		}
		
		self.owner PlayLocalSound( "reaper_damaged" );
		
		self.owner SendKillstreakDamageEvent( int(damage) );
					
		damageTaken += damage;
		if ( damageTaken >= maxHealth )
		{

			if ( self.owner util::IsEnemyPlayer( attacker ) )
			{
				attacker challenges::addFlySwatterStat( weapon, self );
				attacker AddWeaponStat( weapon, "destroyed_controlled_killstreak", 1 );
				attacker challenges::destroyedPlayerControlledAircraft();
			}
			else
			{
				//Destroyed Friendly Killstreak 
			}

			level thread popups::DisplayTeamMessageToAll( &"KILLSTREAK_DESTROYED_REMOTE_MORTAR", attacker ); 

			self thread remote_killstreak_end(true);			
			return;
		}
		else if(!self.lowHealth && damageTaken >= maxHealth / 2)
		{
			PlayFXOnTag( level.fx_u2_damage_trail, self, "tag_origin" );
			self.lowHealth = true;
		}
	}	
}

function remote_leave()
{
	level endon( "game_ended" );
	self  endon( "death" );
	
//	self notify( "remote_done" );			

	self unlink();
	
	tries = 10;
	yaw = 0;
	while (tries > 0)
	{
		exitVector = ( anglestoforward( self.angles + (0, yaw, 0)) * 20000 );
					
		exitPoint = ( self.origin[0] + exitVector[0], self.origin[1] + exitVector[1], self.origin[2] - 2500);
		exitPoint = self.origin + exitVector;
		
		nfz = airsupport::crossesNoFlyZone (self.origin, exitPoint);
		if( isdefined(nfz) )
		{
			if ( tries % 2 == 1 && tries != 1)
			{
				yaw = yaw * -1;
			}
			else if ( tries != 1 )
			{
				yaw = yaw + 10;
				yaw = yaw * -1;
			}
			tries--;
		}
		else
		{
			tries = 0;	
		}
	}

	self thread airsupport::flattenYaw( self.angles[1] + yaw );
	
	self moveTo( exitPoint, 8, 4 );
	if (self.lowHealth)
	{
		PlayFXOnTag( level.chopper_fx["damage"]["heavy_smoke"], self, "tag_origin" );
	}
	self thread play_afterburner_fx();
	hostmigration::waitLongDurationWithHostMigrationPause( 8 );		
	
	self delete();
}

function play_remote_fx()
{	
	self.exhaustFX = spawn( "script_model", self.origin );
	self.exhaustFX SetModel( "tag_origin" );
	self.exhaustFX LinkTo( self, "tag_turret", (0,0,25) );
	wait( 0.1 );
	PlayFXOnTag( level.fx_cuav_burner, self.exhaustFX, "tag_origin" );	
}

function play_afterburner_fx()
{	
	if ( !isdefined( self.exhaustFX ) )
	{
		self.exhaustFX = spawn( "script_model", self.origin );
		self.exhaustFX SetModel( "tag_origin" );
		self.exhaustFX LinkTo( self, "tag_turret", (0,0,25) );
	}
	self endon( "death" );
	wait( 0.1 );
	PlayFXOnTag( level.fx_cuav_afterburner, self.exhaustFX, "tag_origin" );	
}
	
function remote_explode()
{
	self notify( "death" );
	self Hide();
	forward = ( AnglesToForward( self.angles ) * 200 );
	playFx ( level.fx_u2_explode, self.origin, forward );
	self playsound ( "evt_helicopter_midair_exp" );	
	wait(0.2);
	self notify( "delete" );
	self delete();
}

function visionSwitch()
{
	self endon( "disconnect" );
	level endon( "remote_end" );

	inverted = true;
	
	self SetInfraredVision( true );
	self UseServerVisionset( true );
	self SetVisionSetForPlayer( level.remore_mortar_infrared_vision, 1 );

	for (;;)
	{
		if ( self ChangeSeatButtonPressed() )
		{
			if ( !inverted )
			{
				self SetInfraredVision( true );
				self SetVisionSetForPlayer( level.remore_mortar_infrared_vision, 0.5 );
				self PlayLocalSound ("mpl_ks_reaper_view_select");
			}
			else
			{
				self SetInfraredVision( false );
				self SetVisionSetForPlayer( level.remore_mortar_enhanced_vision, 0.5 );
				self PlayLocalSound ("mpl_ks_reaper_view_select");
			}

			inverted = !inverted;
			
			// wait for the button to release:
			while ( self ChangeSeatButtonPressed() )
				{wait(.05);};
		}
		{wait(.05);};
	}
}
