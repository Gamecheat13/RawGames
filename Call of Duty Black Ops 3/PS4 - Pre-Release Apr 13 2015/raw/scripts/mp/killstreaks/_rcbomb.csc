#using scripts\codescripts\struct;

#using scripts\shared\array_shared;
#using scripts\shared\audio_shared;
#using scripts\shared\challenges_shared;
#using scripts\shared\clientfield_shared;
#using scripts\shared\hostmigration_shared;
#using scripts\shared\hud_shared;
#using scripts\shared\killstreaks_shared;
#using scripts\shared\scoreevents_shared;
#using scripts\shared\tweakables_shared;
#using scripts\shared\util_shared;
#using scripts\shared\weapons\_flashgrenades;
#using scripts\shared\weapons\_weaponobjects;
#using scripts\shared\vehicle_shared;
#using scripts\shared\vehicle_death_shared;

    	   	                                                                                                                         	                                                                                                                                                                                                                                                                                                                                                                    	        	     	             	    	   	                           	                               	                                	                                                              	                                                                                                              	                            	                                     	                                       	                                                               	   	                  	       	                                                    	                   	                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                        	                                                                                        	           	                        	                                            	                                             	                                                   	                                                             	                                                         	                                                                    	                                                                                                                                                                                                    	                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                      	                                                              	                                                          	                                   	                                   	                                                    	                                       
                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                            	                                                                                                                                                                                                                                                                                                                                                                                       

#using scripts\mp\gametypes\_globallogic_audio;
#using scripts\mp\gametypes\_globallogic_utils;
#using scripts\mp\gametypes\_hostmigration;
#using scripts\mp\gametypes\_shellshock;
#using scripts\mp\gametypes\_spawning;

#using scripts\mp\_challenges;

#using scripts\mp\_popups;
#using scripts\mp\_util;
#using scripts\mp\killstreaks\_emp;
#using scripts\mp\killstreaks\_killstreakrules;
#using scripts\mp\killstreaks\_killstreaks;
#using scripts\mp\killstreaks\_remote_weapons;

                                                                                                          	                                              	                       	                   	                                                                         	                       	                                                      	                                                      	                                                       	                                                                                                 	                                                           	                 	                                                   	                	                                          	                                          	       	  	              	                                                  	                                                                 	                                                                  	                                                         	                                                   	                                                   	                                                                             	                                                                	                                                             	                                                             	                                   	                                   	                                                    	                                                    	                                                                                      	                                                         	                                                         	                                                               	                                                               	                                                   	                                                                	                                                     	                                                	                                                	                                                        	                                                                                                  	                                                                                 	                                            	                                                                                    	                                          	                       	                    
                                                                                                                                                                                                                                                                 	                                                                                     														            														           						                           														          														         														        														                      														                                                                                                                                           															      															                                                      	        	       	                	           

#precache( "string", "KILLSTREAK_EARNED_RCBOMB" );
#precache( "string", "KILLSTREAK_RCBOMB_NOT_AVAILABLE" );
#precache( "string", "KILLSTREAK_RCBOMB_INBOUND" );
#precache( "eventstring", "mpl_killstreak_rcbomb" );
#precache( "fx", "_t6/weapon/grenade/fx_spark_disabled_rc_car" );
#precache( "fx", "killstreaks/fx_rcxd_lights_grn" );
#precache( "fx", "killstreaks/fx_rcxd_lights_red" );
#precache( "fx", "killstreaks/fx_rcxd_exp" );

#namespace rcbomb;


	
function init()
{
	level._effect["rcbombexplosion"] = "killstreaks/fx_rcxd_exp";

	killstreaks::register( "rcbomb", "rcbomb", "killstreak_rcbomb", "rcbomb_used",&ActivateRCBomb );
	killstreaks::register_strings( "rcbomb", &"KILLSTREAK_EARNED_RCBOMB", &"KILLSTREAK_RCBOMB_NOT_AVAILABLE", &"KILLSTREAK_RCBOMB_INBOUND");
	killstreaks::register_dialog( "rcbomb", "mpl_killstreak_rcbomb", 8, 31, 100, 118, 100 );
	killstreaks::allow_assists( "rcbomb", true);
	killstreaks::register_alt_weapon( "rcbomb", "killstreak_remote" );
	killstreaks::register_alt_weapon( "rcbomb", "rcbomb_turret" );
	remote_weapons::RegisterRemoteWeapon( "rcbomb", &"", &StartRemoteControl, &EndRemoteControl );
	
	vehicle::add_main_callback( "rc_car_mp", &InitRCBomb );
	
	clientfield::register( "vehicle", "rcbomb_stunned", 1, 1, "int" );
	clientfield::register( "vehicle", "rcbomb_countdown", 1, 2, "int" );
}

function InitRCBomb()
{
	rcbomb = self;
	
	rcbomb clientfield::set( "enemyvehicle", 1 );	
	rcbomb.allowFriendlyFireDamageOverride = &RCCarAllowFriendlyFireDamage;
	rcbomb EnableAimAssist();
	rcbomb SetDrawInfrared( true );
	rcbomb.delete_on_death = true;
	rcbomb.no_free_on_death = true;
	rcbomb.disableRemoteWeaponSwitch = true;
	rcbomb.overrideVehicleDamage = &OnDamage;
	rcbomb.overrideVehicleDeath = &OnDeath;
	rcbomb.remoteWeaponShutdownDelay = ( 2 );
}

function ActivateRCBomb( hardpointType )
{
	assert( IsPlayer( self ) );
	player = self;
	
	if( !player killstreakrules::isKillstreakAllowed( hardpointType, player.team ) )
	{
		return false;
	}
	
	placement = CalculateSpawnOrigin( self.origin, self.angles );
	if( !isdefined( placement ) || !self IsOnGround() || self util::isUsingRemote() || killstreaks::is_interacting_with_object() )
	{
		self iPrintLnBold( &"KILLSTREAK_RCBOMB_NOT_PLACEABLE" );
		return false;
	}
	
	killstreak_id = player killstreakrules::killstreakStart( "rcbomb", player.team, undefined, false );
	if( killstreak_id == (-1) )
	{
		return false;
	}
	
	player AddWeaponStat( GetWeapon( "rcbomb" ), "used", 1 );
	
	rcbomb = SpawnVehicle( "rc_car_mp", placement.origin, placement.angles, "rcbomb" );
	rcbomb SetTeam( player.team );
	rcbomb.team = player.team;
	rcbomb SetOwner( player );
	rcbomb.owner = player;
	rcbomb.abandoned = false;
	rcbomb.killstreak_id = killstreak_id;
	
	rcbomb thread WatchShutdown();
	rcbomb thread WatchOwnerGameEvents();
	
	rcbomb spawning::create_entity_enemy_influencer( "small_vehicle", player.team );
	
	self killstreaks::pick_pilot( "rcbomb", 2 );
	self thread killstreaks::play_killstreak_start_dialog( "rcbomb", self.team );
	
	self AddWeaponStat( GetWeapon( "rcbomb" ) , "used", 1 );
	
	remote_weapons::UseRemoteWeapon( rcbomb, "rcbomb", true );
	
	if ( !isdefined( player ) || !isAlive( player ) )
	{
		// TODO: currently lethal, when we get the "fizzle out" effects, make that happen instead
		// rcbomb.abandoned = true;
		rcbomb notify( "remote_weapon_shutdown" );
		return false;
	}
	
	player.killstreak_waitamount = ( 30 ) + ( 6 ) + ( 4 );
	
	return true;
}

function StartRemoteControl( rcbomb )
{
	player = self;
	
	rcbomb UseVehicle( player, 0 );
	
	rcbomb thread audio::sndUpdateVehicleContext(true);
	
	rcbomb thread WatchTimeout();
	rcbomb thread WatchDetonation();
	rcbomb thread WatchHurtTriggers();
	rcbomb thread WatchWater();
}

function EndRemoteControl( rcbomb, exitRequestedByOwner )
{
	rcbomb notify( "rcbomb_shutdown" );
	rcbomb thread audio::sndUpdateVehicleContext(false);
}

function WatchDetonation()
{
	rcbomb = self;
	rcbomb endon( "rcbomb_shutdown" );
	
	while( !rcbomb.owner attackbuttonpressed() ) 
	{
		{wait(.05);};
	}
	
	rcbomb notify( "rcbomb_shutdown" );
}





	
function WatchWater()
{
	self endon( "rcbomb_shutdown" );
			
	inWater = false;
	while( !inWater )
	{
		wait ( 0.5 );
		trace = physicstrace( self.origin + ( 0, 0, 10 ), self.origin + ( 0, 0, 6 ), ( -2, -2, -2 ), (  2,  2,  2 ), self, ( (1 << 2) ));
		inWater = trace["fraction"] < 1.0;
	}

	self.abandoned = true;
	self notify( "rcbomb_shutdown" );
}

function WatchOwnerGameEvents()
{
	rcbomb = self;
	rcbomb endon( "rcbomb_shutdown" );
	
	rcbomb.owner util::waittill_any( "joined_team", "disconnect", "joined_spectators" );
	
	rcbomb.abandoned = true;
	rcbomb notify( "rcbomb_shutdown" );
}

function WatchTimeout()
{
	rcbomb = self;
	rcbomb endon("rcbomb_shutdown");

/#
	if (killstreaks::should_not_timeout("rcbomb"))
	{
		return;
	}		
#/

	hostmigration::waitLongDurationWithHostMigrationPause( ( 30 ) );
	rcbomb clientfield::set( "rcbomb_countdown", 1 );
	hostmigration::waitLongDurationWithHostMigrationPause( ( 6 ) );
	// this second state is needed for killcam
	rcbomb clientfield::set( "rcbomb_countdown", 2 );
	hostmigration::waitLongDurationWithHostMigrationPause( ( 4 ) );
	
	rcbomb notify( "rcbomb_shutdown" );
}

function WatchShutdown()
{
	rcbomb = self;
	rcbomb endon( "death" );
	
	rcbomb waittill( "rcbomb_shutdown" );

	attacker = ( isdefined( rcbomb.owner ) ? rcbomb.owner : undefined );
	rcbomb DoDamage( rcbomb.health + 1, rcbomb.origin + (0, 0, 10), attacker, attacker, "none", "MOD_EXPLOSIVE", 0 );
}

function WatchHurtTriggers()
{
	rcbomb = self;
	rcbomb endon( "rcbomb_shutdown" );
	
	while( true )
	{
		rcbomb waittill ( "touch", ent );
		if( isdefined( ent.classname ) && ( ent.classname == "trigger_hurt" || ent.classname == "trigger_out_of_bounds" ) )
		{
			rcbomb notify( "rcbomb_shutdown" );
		}
	}
}

function OnDamage( eInflictor, eAttacker, iDamage, iDFlags, sMeansOfDeath, weapon, vPoint, vDir, sHitLoc, vDamageOrigin, psOffsetTime, damageFromUnderneath, modelIndex, partName, vSurfaceNormal )
{
	if( isdefined( eAttacker ) && isdefined( eAttacker.team ) && eAttacker.team != self.team )
	{
		if( weapon.isEmp )
		{
			iDamage += int( ( self.healthdefault * ( 1 ) ) + 0.5 );
		}
	}
	
	// C4 destroys the HC-XD with any damage (TODO: consider creating a more robust solution if need be)
	if ( weapon.name == "satchel_charge" )
	{
		iDamage = self.healthdefault + 1;
	}

	return iDamage;
}

function OnDeath( eInflictor, eAttacker, iDamage, sMeansOfDeath, weapon, vDir, sHitLoc, psOffsetTime )
{
	rcbomb = self;
	player = rcbomb.owner;
	
	killstreakrules::killstreakStop( "rcbomb", rcbomb.team, rcbomb.killstreak_id );
	
	rcbomb clientfield::set( "rcbomb_countdown", 0 );
	rcbomb clientfield::set( "enemyvehicle", 0 );	
	rcbomb Explode( eAttacker, weapon );
	
	if( isdefined( player ) )
	{
		player util::freeze_player_controls( true );
		rcbomb thread HideAfterWait( ( 0.1 ) );
		wait( ( 2 ) );
		player util::freeze_player_controls( false );
		rcbomb delete();
	}
	else
	{
		rcbomb thread HideAfterWait( ( 0.1 ) );
		wait( ( 10 ) );
		rcbomb delete();
	}
}

function HideAfterWait( waitTime )
{
	self endon( "death" );

	wait waitTime;
	self SetInvisibleToAll();
}

function Explode( attacker, weapon )
{
	self endon ("death");
	 
	if ( !isdefined( attacker ) && isdefined( self.owner ) )
	{
		attacker = self.owner;
	}

	self vehicle_death::death_fx();
	self thread vehicle_death::death_radius_damage();
	self thread vehicle_death::set_death_model( self.deathmodel, self.modelswapdelay );
	
	self vehicle::toggle_tread_fx( false );
	self vehicle::toggle_exhaust_fx( false );
	self vehicle::toggle_sounds( false );
	self vehicle::lights_off();
	
	if ( !self.abandoned && attacker != self.owner && isPlayer( attacker ) )
	{	
		attacker challenges::destroyRCBomb( weapon );
		if ( self.owner util::IsEnemyPlayer( attacker ) )
		{		
			scoreevents::processScoreEvent( "destroyed_hover_rcxd", attacker, self.owner, weapon );
			if ( isdefined( weapon ) && weapon.isValid )
			{
				weaponStatName = "destroyed";
				attacker AddWeaponStat( weapon, weaponStatName, 1 );
				level.globalKillstreaksDestroyed++;
				// increment the destroyed stat for this, we aren't using the weaponStatName variable from above because it could be "kills" and we don't want that
				weapon_rcbomb = GetWeapon( "rcbomb" );
				attacker AddWeaponStat( weapon_rcbomb, "destroyed", 1 );
				attacker AddWeaponStat( weapon, "destroyed_controlled_killstreak", 1 );
			}
			
			if( isdefined( self.owner) )
			{
				self.owner killstreaks::play_taacom_dialog( "rcbomb", 2 );
			}
		}
	}
}

function RCCarAllowFriendlyFireDamage( eInflictor, eAttacker, sMeansOfDeath, weapon )
{
	if ( isdefined( eAttacker ) && eAttacker == self.owner )
		return true;
		
	if ( isdefined( eInflictor ) && eInflictor islinkedto( self ) )
		return true;
	
	return false;
}

function GetPlacementStartHeight()
{
	startheight = ( 50 );
	
	switch( self GetStance() )
	{
		case "crouch":
			startheight = ( 30 );
			break;
		case "prone":
			startheight = ( 15 );
			break;
	}
	return startheight;
}

function CalculateSpawnOrigin( origin, angles )
{
	startheight = GetPlacementStartHeight();
	
	mins = (-5,-5,0); // keep the min z 0 so the return point is the exact height of the collision
	maxs = (5,5,10);
	
	startPoints = [];
	startAngles = [];
	wheelCounts = [];
	testCheck = [];
	largestCount = 0;
	largestCountIndex = 0;
	
	testangles = [];
	testangles[0] = (0,0,0);
	testangles[1] = (0,20,0);
	testangles[2] = (0,-20,0);
	testangles[3] = (0,45,0);
	testangles[4] = (0,-45,0);
	
	heightoffset = 5;
	
	for (i = 0; i < testangles.size; i++ )
	{
		testCheck[i] = false;

		startAngles[i] = ( 0, angles[1], 0 );
		startPoint = origin + VectorScale( anglestoforward( startAngles[i] + testangles[i]), ( 70 ) );
		endPoint = startPoint - (0,0,100);
		startPoint = startPoint + (0,0,startheight);

		// ignore water on this one
		mask = (1 << 0) | (1 << 1);
			
		// using physicstrace so we dont slip through small cracks
		trace = physicstrace( startPoint, endPoint, mins, maxs, self, mask);
			
		// if any player intersection then skip
		if ( isdefined(trace["entity"]) && IsPlayer(trace["entity"]))
		{
			wheelCounts[i] = 0;
			continue;
		}
			 
		startPoints[i] = trace["position"] + (0,0,heightoffset);
		wheelCounts[i] = TestWheelLocations(startPoints[i],startAngles[i],heightoffset);
		
		if ( positionWouldTelefrag( startPoints[i] ) )
			continue;
	
		if ( largestCount < wheelCounts[i] )
		{
			largestCount = wheelCounts[i];
			largestCountIndex = i;
		}
		
		// going to early out on the first I find with valid tire positions
		if ( wheelCounts[i] >=  3 )
		{
			testCheck[i] = true;

			if ( TestSpawnOrigin( startPoints[i], startAngles[i] ) )
			{
				placement = SpawnStruct();
				placement.origin = startPoints[i];
				placement.angles = startAngles[i];
				return placement;
			}
		}
	}
	
	for (i = 0; i < testangles.size; i++ )
	{
		if ( !testCheck[i] )
		{
			if ( wheelCounts[i] >=  2 )
			{
				if ( TestSpawnOrigin( startPoints[i], startAngles[i] ) )
				{
					placement = SpawnStruct();
					placement.origin = startPoints[i];
					placement.angles = startAngles[i];
					return placement;
				}
			}
		}
	}
	
	return undefined;
}

function TestWheelLocations( origin, angles, heightoffset )
{
	forward = 13;
	side = 10;
	
	wheels = [];
	wheels[0] = ( forward, side, 0 );
	wheels[1] = ( forward, -1 * side, 0 );
	wheels[2] = ( -1 * forward, -1 * side, 0 );
	wheels[3] = ( -1 * forward, side, 0 );

	height = 5;
	touchCount = 0;
	
	yawangles = (0,angles[1],0);
	
	for (i = 0; i < 4; i++ )
	{
		wheel = RotatePoint( wheels[i], yawangles  );
		startPoint = origin + wheel;
		endPoint = startPoint + (0,0,(-1 * height) - heightoffset);
		startPoint = startPoint + (0,0,height - heightoffset) ;
	
		trace = bulletTrace( startPoint, endPoint, false, self );
		if ( trace["fraction"] < 1 )
		{
			touchCount++;
		}
	}
	
	return touchCount;
}

function TestSpawnOrigin( origin, angles )
{
	liftedorigin = origin + (0,0,5);
	size = 12;
	height = 15;
	mins = (-1 * size,-1 * size,0 );
	maxs = ( size,size,height );
	absmins = liftedorigin + mins;
	absmaxs = liftedorigin + maxs;
	
	if( BoundsWouldTelefrag( absmins, absmaxs ) )
	{
		return false;
	}
	
	startheight = getPlacementStartHeight();
	
	mask = (1 << 0) | (1 << 1) | (1 << 2);
	
	// test the volume where we are going to place the car
	// note that this physics trace is not an  oriented box.
	trace = physicstrace( liftedorigin, (origin +(0,0,1)), mins, maxs, self, mask);

	if ( trace["fraction"] < 1 )
	{
		return false;
	}

	// swept trace of a small bounding box from head height to where we are placing the car
	// to make sure there is no wall between us and the car
	size = 2.5;
	height = size * 2;
	mins = (-1 * size,-1 * size,0 );
	maxs = ( size,size,height );
	
	sweeptrace = physicstrace( (self.origin + (0,0,startheight)), liftedorigin, mins, maxs, self, mask);

	if ( sweeptrace["fraction"] < 1 )
	{
		return false;
	}
	
	return true;
}
