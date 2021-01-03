#using scripts\codescripts\struct;

#using scripts\shared\array_shared;
#using scripts\shared\challenges_shared;
#using scripts\shared\clientfield_shared;
#using scripts\shared\hostmigration_shared;
#using scripts\shared\hud_shared;
#using scripts\shared\scoreevents_shared;
#using scripts\shared\tweakables_shared;
#using scripts\shared\util_shared;
#using scripts\shared\weapons\_flashgrenades;
#using scripts\shared\weapons\_weaponobjects;
#using scripts\shared\vehicle_shared;
#using scripts\shared\vehicle_death_shared;

    	   	                                                                                                                         	                                                                                                                                                                                                                                                                                                                                                                    	        	     	             	    	   	                           	                               	                                	                                                              	                                                                                                              	                            	                                     	                                       	                                                               	   	                  	       	                                                    	                   	                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                       	                                                                                        	           	                        	                                            	                                             	                                                   	                                                             	                                                         	                                                                    	                                                                                                                                                                                                    	                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                     	                                                              	                                                          	                                   	                                   	                                                    	                                       
                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                            	                                                                                                                                                                                                                                                                                                                                                                                       

#using scripts\cp\gametypes\_globallogic_utils;
#using scripts\cp\gametypes\_shellshock;
#using scripts\cp\gametypes\_spawning;

#using scripts\cp\_challenges;
#using scripts\cp\_flashgrenades;
#using scripts\cp\_popups;
#using scripts\cp\_scoreevents;
#using scripts\cp\_util;
#using scripts\cp\killstreaks\_emp;
#using scripts\cp\killstreaks\_killstreakrules;
#using scripts\cp\killstreaks\_killstreaks;

#precache( "eventstring", "mpl_killstreak_rcbomb" );
#precache( "fx", "_t6/weapon/grenade/fx_spark_disabled_rc_car" );
#precache( "fx", "_t6/vehicle/light/fx_rcbomb_blinky_light" );
#precache( "fx", "_t6/vehicle/light/fx_rcbomb_solid_light" );
#precache( "fx", "_t6/vehicle/light/fx_rcbomb_light_green_os" );
#precache( "fx", "_t6/vehicle/light/fx_rcbomb_light_red_os"  );
#precache( "fx", "_t6/maps/mp_maps/fx_mp_exp_rc_bomb" );

#namespace rcbomb;

function init()
{
	level._effect["rcbombexplosion"] = "_t6/maps/mp_maps/fx_mp_exp_rc_bomb";

	car_size = GetDvarString( "scr_rcbomb_car_size");
	if ( car_size == "" )
	{
		SetDvar("scr_rcbomb_car_size","1");
	}
	SetDvar("scr_rcbomb_notimeout", 0);
	
	// register the rcbomb hardpoint
	if ( tweakables::getTweakableValue( "killstreak", "allowrcbomb" ) )
	{
		killstreaks::register("rcbomb", "rcbomb", "killstreak_rcbomb", "rcbomb_used",&useKillstreakRCBomb );
		killstreaks::register_strings("rcbomb", &"KILLSTREAK_EARNED_RCBOMB", &"KILLSTREAK_RCBOMB_NOT_AVAILABLE", &"KILLSTREAK_RCBOMB_INBOUND");
		killstreaks::register_dialog("rcbomb", "mpl_killstreak_rcbomb", "kls_rcbomb_used", "","kls_rcbomb_enemy", "", "kls_rcbomb_ready");
		killstreaks::register_dev_dvar("rcbomb", "scr_givercbomb");
		killstreaks::allow_assists("rcbomb", true);
	}
	clientfield::register( "vehicle", "rcbomb_stunned", 1, 1, "int" );	

	level.rcbombOnBlowUp = &rcbomb::blowup;
	
	thread register();
}

function register()
{
	clientfield::register( "vehicle", "rcbomb_countdown", 1, 2, "int" );
}

function useKillstreakRCBomb(hardpointType)
{
	if ( self killstreakrules::isKillstreakAllowed( hardpointType, self.team ) == false )
		return false;
	
	if (!self IsOnGround() || self util::isUsingRemote() )
	{
		self iPrintLnBold( &"KILLSTREAK_RCBOMB_NOT_PLACEABLE" );
		return false;
	}
		
	placement = self.rcbombPlacement;
	if ( !isdefined( placement ) )
		placement = getRCBombPlacement();
	if ( !isdefined( placement ) )
	{
		self iPrintLnBold( &"KILLSTREAK_RCBOMB_NOT_PLACEABLE" );
		return false;
	}
	
	if (  killstreaks::is_interacting_with_object() )
	{
		self iPrintLnBold( &"KILLSTREAK_RCBOMB_NOT_PLACEABLE" );
		return false;		
	}
	
	self util::setUsingRemote( "rcbomb" );	
	self util::freeze_player_controls( true );

	result = self killstreaks::init_ride_killstreak( "rcbomb" );		
	if ( result != "success" )
	{
		if ( result != "disconnect" )
			self killstreaks::clear_using_remote();

		return false;
	}	

	if( level.gameEnded )
		return false;

	ret = self useRCBomb(placement);
	
	if ( !isdefined(ret) && level.gameEnded )
		ret = true;
	else if( !isdefined(ret) )
		ret = false;
		
	if ( isdefined( self ) )
		self killstreaks::clear_using_remote();	

	return ret;
}

function spawnRCBomb(placement, team)
{
	car_size = GetDvarString( "scr_rcbomb_car_size");
	
	enemymodel = "veh_t6_drone_rcxd_alt";
	car = "rc_car_mp";
	
	vehicle = SpawnVehicle(
	car,
	placement.origin,
	placement.angles,
	"rcbomb" );
	
	vehicle MakeVehicleUnusable();
	vehicle.allowFriendlyFireDamageOverride =&RCCarAllowFriendlyFireDamage;
	vehicle setEnemyModel(enemymodel);
	vehicle EnableAimAssist();
	
	vehicle SetOwner( self );
	vehicle SetTeam( team );
	vehicle.team = team;
	vehicle SetDrawInfrared( true );

	// create the influencers
	vehicle spawning::create_entity_enemy_influencer( "small_vehicle" );

	return vehicle;
}

function getRCBombPlacement()
{
	return calculateSpawnOrigin( self.origin, self.angles );
}

function givePlayerControlOfRCBomb()
{
	self endon( "disconnect" );
	level endon ( "game_ended" );
	
	self thread killstreaks::play_killstreak_start_dialog( "rcbomb", self.team );
	//self AddPlayerStat( "RCBOMB_USED", 1 );
	level.globalKillstreaksCalled++;
	self AddWeaponStat( GetWeapon( "rcbomb" ) , "used", 1 );
	
	xpAmount = killstreaks::get_xp_amount_for_killstreak( "rcbomb" );

	if ( scoreevents::shouldAddRankXP( self ) )
	{
		self AddRankXPValue( "killstreakCalledIn", xpAmount );
	}
	
	self util::freeze_player_controls( false );

	self.rcbomb usevehicle( self, 0 );
	
	self thread playerDisconnectWaiter( self.rcbomb );
	self thread carDetonateWaiter( self.rcbomb );
	//self thread jumpWaiter( self.rcbomb );
	self thread exitCarWaiter( self.rcbomb );
	self thread GameEndWatcher( self.rcbomb );
	self thread changeTeamWaiter( self.rcbomb );
	self.rcbomb thread flashgrenades::monitorRCBombFlash();
	self thread carTimer( self.rcbomb );
	
	self waittill( "rcbomb_done" );
}

function useRCBomb( placement )
{
	self endon("disconnect");
	level endon ( "game_ended" );
	
	hardpointtype = "rcbomb";
	
	util::WaitTillSlowProcessAllowed();
	
	if ( !isdefined( self ) || !isAlive( self ) ||  ( self IsRemoteControlling() ) || self  killstreaks::is_interacting_with_object() )
	{
		self iPrintLnBold( &"KILLSTREAK_RCBOMB_NOT_PLACEABLE" );
		return false;
	}
	
	if ( !isdefined( self.rcbomb ) )
	{
		self.rcbomb = self spawnRCBomb(placement, self.team );
		self.rcbomb thread carCleanupWaiter( self.rcbomb );
		self.rcbomb thread trigger_hurt_monitor();

		self.rcbomb.team = self.team;
		if ( !isdefined( self.rcbomb ) )
		{
			return false;
		}
	
		self weaponobjects::addWeaponObjectToWatcher( "rcbomb", self.rcbomb );
	}

	killstreak_id = self killstreakrules::killstreakStart( hardpointtype, self.team, undefined, false );
	if ( killstreak_id == -1 )
	{
		if( isdefined( self.rcbomb ) )
		{
			self.rcbomb delete();
		}
		return false;
	}

	self.rcbomb.killstreak_id = killstreak_id;
	self.enteringVehicle = true;

	self thread updateKillstreakOnDisconnect();
	self thread updateKillstreakOnDeletion( self.team );

	self util::freeze_player_controls( true );
	
	if ( !isdefined( self ) || !IsAlive( self ) || !isdefined( self.rcbomb ) )
	{
		if( isdefined( self ) )
		{
			self.enteringVehicle = false;
			self notify("weapon_object_destroyed");
		}
		return false;
	}
	
	self thread givePlayerControlOfRCBomb();
	self.rcbomb thread watchForScramblers();
	self.killstreak_waitamount = 30000;
	self.enteringVehicle = false;
	self StopShellshock();
	
	if ( isdefined( level.killstreaks[hardpointType] ) && isdefined( level.killstreaks[hardpointType].inboundtext ) )
		level thread _popups::DisplayKillstreakTeamMessageToAll( hardpointType, self );
	
	if ( isdefined( level.rcbomb_vision ) )
		self thread setVisionsetWaiter();
	
	self updateRulesOnEnd();
	
	return true;
}

function trigger_hurt_monitor()
{
	self endon( "death" );

	for ( ;; )
	{
		self waittill( "touch", ent );

		if ( ent.classname == "trigger_hurt" )
		{
			if ( level.script == "mp_castaway" )
			{
				// trigger has "SLOW" bit set - used to simulate players drowning
				if ( ent.spawnflags & 16 )
				{
					if ( self DepthInWater() < 23 )
					{
						continue;
					}
				}
			}

			self rcbomb_force_explode();
			return;
		}
	}
}

function watchForScramblers() // self == scrambler
{
	self endon( "death" );

	// If we enter the effect radius of the scrambler then stun
	while( true )
	{
		scrambled = self clientfield::get( "rcbomb_stunned" );
		
		shouldScramble = false;
		
		players = level.players;
		for( i = 0; i < players.size; i++ )
		{
			if ( !isdefined( players[i] ) || !isdefined( players[i].scrambler ) )
			{
				continue;
			}

			player = players[i];
			scrambler = player.scrambler;
			
			// for teambased modes don't stun if the scrambler and rc are on the same team
			if( level.teambased && self.team == player.team )
			{
				continue;
			}
			
			// for non-teambased modes don't stun the rc if the owner's are the same player
			if( !level.teambased && self.owner == player )
			{
				continue;
			}

			if( DistanceSquared( scrambler.origin, self.origin ) < level.scramblerInnerRadiusSq )
			{
				shouldScramble = true;
				break;
			}
		}

		if ( shouldScramble == true && scrambled == false ) 
		{
			self clientfield::set( "rcbomb_stunned", 1 );
		}
		else if ( shouldScramble == false && scrambled == true ) 
		{
			self clientfield::set( "rcbomb_stunned", 0 );
		}

		wait_delay = RandomFloatRange( 0.25, 0.5 );
		wait( wait_delay );
	}
}
	
function updateRulesOnEnd()
{
	team = self.rcbomb.team;
	killstreak_id = self.rcbomb.killstreak_id;
	self endon("disconnect"); 
	
	self waittill( "rcbomb_done" );
	killstreakrules::killstreakStop( "rcbomb", team, killstreak_id );		
}

function updateKillstreakOnDisconnect()
{
	team = self.rcbomb.team;
	killstreak_id = self.rcbomb.killstreak_id;
	self endon("rcbomb_done");
	self waittill("disconnect"); 
	killstreakrules::killstreakStop( "rcbomb", team, killstreak_id );
}

//Protection on the edge case you are killed right as you drop the rc bomb but before you can link to it.
//The rc bomb will be deleted on respawn so ensure that the killstreak rules are updated.
function updateKillstreakOnDeletion( team )
{
	killstreak_id = self.rcbomb.killstreak_id;

	self endon("disconnect");
	self endon("rcbomb_done");

	self waittill( "weapon_object_destroyed" );
	killstreakrules::killstreakStop( "rcbomb", team, killstreak_id );
	
	if( isdefined( self.rcbomb ) )
		self.rcbomb delete();
}

function carDetonateWaiter( vehicle )
{
	//self endon("death"); 
	self endon("disconnect"); 
	vehicle endon("death"); 
	
	watcher = weaponobjects::getWeaponObjectWatcher( "rcbomb" );
		
	while( !self attackbuttonpressed() ) 
		{wait(.05);};
		
	watcher thread weaponobjects::waitAndDetonate( vehicle, 0, undefined, watcher.weapon );
	
	self thread hud::fade_to_black_for_x_sec( GetDvarfloat( "scr_rcbomb_fadeOut_delay" ), GetDvarfloat( "scr_rcbomb_fadeOut_timeIn" ), GetDvarfloat( "scr_rcbomb_fadeOut_timeBlack" ), GetDvarfloat( "scr_rcbomb_fadeOut_timeOut" ) );
}

function jumpWaiter( vehicle )
{
	self endon("disconnect"); 
	vehicle endon("death"); 

	self.jump_hud = newclienthudelem( self );
	self.jump_hud.alignX = "left";
	self.jump_hud.alignY = "bottom";
	self.jump_hud.horzAlign = "user_left";
	self.jump_hud.vertAlign = "user_bottom";
	self.jump_hud.font = "small";
	self.jump_hud.hidewheninmenu = true;
	self.jump_hud.x = 5;
	self.jump_hud.y = -60;
	self.jump_hud.fontscale = 1.25;
	
	while( 1 )
	{
		self.jump_hud SetText("[{+gostand}]" + "Jump");
		if ( self JumpButtonPressed())
		{
			vehicle LaunchVehicle( (0, 0, -1) * -10, vehicle.origin, false );
			self.jump_hud SetText("");
			wait( 5 ); //jump cooldown
		}
		{wait(.05);};
	}
}

function playerDisconnectWaiter( vehicle )
{
	vehicle endon("death"); 
	self endon("rcbomb_done"); 

	self waittill( "disconnect" );
		
	vehicle Delete();
}

function GameEndWatcher( vehicle )
{
	vehicle endon("death"); 
	self endon("rcbomb_done"); 

	level waittill( "game_ended" );
		
	watcher = weaponobjects::getWeaponObjectWatcher( "rcbomb" );
	watcher thread weaponobjects::waitAndDetonate( vehicle, 0, undefined, watcher.weapon );
	
	self thread hud::fade_to_black_for_x_sec( GetDvarfloat( "scr_rcbomb_fadeOut_delay" ), GetDvarfloat( "scr_rcbomb_fadeOut_timeIn" ), GetDvarfloat( "scr_rcbomb_fadeOut_timeBlack" ), GetDvarfloat( "scr_rcbomb_fadeOut_timeOut" ) );

}

function exitCarWaiter( vehicle )
{
	self endon("disconnect"); 

	self waittill( "unlink" );
	
	self notify("rcbomb_done");
}

function changeTeamWaiter( vehicle )
{
	self endon("disconnect"); 
	self endon("rcbomb_done"); 
	vehicle endon("death");
	
	self util::waittill_either( "joined_team", "joined_spectators" );
	
	vehicle.owner Unlink();
	self.killstreak_waitamount = undefined;
	vehicle Delete();
}

function carDeathWaiter( vehicle )
{
	self endon("disconnect"); 
	self endon("rcbomb_done"); 

	self waittill( "death" );
	
	killstreaks::remove_used_killstreak("rcbomb");	
	self notify("rcbomb_done");
}

function carCleanupWaiter( vehicle )
{
	self endon("disconnect"); 

	self waittill( "death" );
	
	self.rcbomb = undefined;
}

function setVisionsetWaiter()
{
	self endon("disconnect"); 
	
	self UseServerVisionset( true );
	self SetVisionSetForPlayer( level.rcbomb_vision, 1 );

	self waittill("rcbomb_done"); 
	
	self UseServerVisionset( false );
}

function carTimer( vehicle )
{
	self endon("disconnect"); 
	vehicle endon("death"); 
	
	if ( !level.vehiclesTimed ) 
		return;
/#
	if ( GetDvarInt( "scr_rcbomb_notimeout" ) != 0 )
	{
		return;
	}
#/
	hostmigration::waitLongDurationWithHostMigrationPause( 20 );
	vehicle clientfield::set( "rcbomb_countdown", 1 );
	hostmigration::waitLongDurationWithHostMigrationPause( 6 );
	// this second state is needed for killcam
	vehicle clientfield::set( "rcbomb_countdown", 2 );
	hostmigration::waitLongDurationWithHostMigrationPause( 4 );
	
	watcher = weaponobjects::getWeaponObjectWatcher( "rcbomb" );
	watcher thread weaponobjects::waitAndDetonate( vehicle, 0, undefined, watcher.weapon );
}

function detonateIfTouchingSphere( origin, radius )
{
	if ( DistanceSquared( self.origin, origin ) < radius * radius )
	{
		self rcbomb_force_explode();
	}
}

function detonateAllIfTouchingSphere( origin, radius )
{
	rcbombs = GetEntArray( "rcbomb","targetname" );
	for ( index = 0; index < rcbombs.size; index ++ )
	{
		rcbombs[index] detonateIfTouchingSphere(origin, radius);
	}
}

function blowup( attacker, weapon )
{
	self.owner endon("disconnect");
	self endon ("death");
	 
	if ( !isdefined( attacker ) )
	{
		attacker = self.owner;
	}

	weapon_rcbomb = GetWeapon( "rcbomb" );

	self vehicle_death::death_fx();
	self thread vehicle_death::death_radius_damage();
	self thread vehicle_death::set_death_model( self.deathmodel, self.modelswapdelay );
	
	self vehicle::toggle_tread_fx( false );
	self vehicle::toggle_exhaust_fx( false );
	self vehicle::toggle_sounds( false );
	self vehicle::lights_off();

	if ( attacker != self.owner && isPlayer( attacker ) )
	{	
		attacker challenges::destroyRCBomb( weapon );
		if ( self.owner util::IsEnemyPlayer( attacker ) )
		{
			if ( isdefined( weapon ) && weapon.isValid )
			{
				weaponStatName = "destroyed";
				attacker AddWeaponStat( weapon, weaponStatName, 1 );
				level.globalKillstreaksDestroyed++;
				// increment the destroyed stat for this, we aren't using the weaponStatName variable from above because it could be "kills" and we don't want that
				attacker AddWeaponStat( weapon_rcbomb, "destroyed", 1 );
				attacker AddWeaponStat( weapon, "destroyed_controlled_killstreak", 1 );
			}
		}
		else
		{
			//Destroyed Friendly Killstreak 
		}
	}

	util::waitForTimeandNetworkFrame( 1.0 );
	
	if ( isdefined( self.neverDelete ) && self.neverDelete )
	{
		return;
	}
	
	
	if (isdefined(self.owner.jump_hud))
	{
		self.owner.jump_hud destroy();
	}
	self.owner Unlink();
	
	if ( isdefined(level.gameEnded) && level.gameEnded )
	{
		self.owner util::freeze_player_controls( true );
	}
	
	self.owner.killstreak_waitamount = undefined;
	self Delete();
}

function RCCarAllowFriendlyFireDamage( eInflictor, eAttacker, sMeansOfDeath, weapon )
{
	if ( isdefined( eAttacker ) && eAttacker == self.owner )
		return true;
		
	if ( isdefined( eInflictor ) && eInflictor islinkedto( self ) )
		return true;
	
	return false;
}

function getPlacementStartHeight()
{
	startheight = 50;
	
	switch( self GetStance() )
	{
		case "crouch":
			startheight = 30;
			break;
		case "prone":
			startheight = 15;
			break;
	}
	return startheight;
}

function calculateSpawnOrigin( origin, angles )
{

	distance_from_player = 70;

	startheight = getPlacementStartHeight();
	
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
		startPoint = origin + VectorScale( anglestoforward( startAngles[i] + testangles[i]), distance_from_player );
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
		wheelCounts[i] = testWheelLocations(startPoints[i],startAngles[i],heightoffset);
		
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

			if ( testSpawnOrigin( startPoints[i], startAngles[i] ) )
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
				if ( testSpawnOrigin( startPoints[i], startAngles[i] ) )
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

function testWheelLocations( origin, angles, heightoffset )
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
			rcbomb_debug_line( startPoint, endPoint,(1,0,0) );
		}
		else
		{
			rcbomb_debug_line( startPoint, endPoint,(0,0,1) );
		}
	}
	
	return touchCount;
}

function testSpawnOrigin( origin, angles )
{
	liftedorigin = origin + (0,0,5);
	size = 12;
	height = 15;
	mins = (-1 * size,-1 * size,0 );
	maxs = ( size,size,height );
	absmins = liftedorigin + mins;
	absmaxs = liftedorigin + maxs;
	
	// check to see if we would telefrag any players
	if ( BoundsWouldTelefrag( absmins, absmaxs ) )
	{
		rcbomb_debug_box( liftedorigin, mins, maxs,(1,0,0) );
		return false;
	}
	else
	{
		rcbomb_debug_box( liftedorigin, mins, maxs,(0,0,1) );
	}
	
	startheight = getPlacementStartHeight();
	
	mask = (1 << 0) | (1 << 1) | (1 << 2);
	// test the volume where we are going to place the car
	// note that this physics trace is not an  oriented box.
	trace = physicstrace( liftedorigin, (origin +(0,0,1)), mins, maxs, self, mask);

	if ( trace["fraction"] < 1 )
	{
		rcbomb_debug_box( trace["position"], mins, maxs, (1,0,0) );
		return false;
	}
	else
	{
		rcbomb_debug_box( (origin +(0,0,1)), mins, maxs, (0,1,0) );
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
		rcbomb_debug_box( sweeptrace["position"], mins, maxs, (1,0,0) );
		return false;
	}
	
	return true;
}

//Starts a thread on my trigger_hurt's to check for rc_bombs. Self is the trigger.
function trigger_monitor_init()
{
	hurt_triggers = GetEntArray( "trigger_hurt","classname" );
	
	//this function acts as an array::thread_all, but it has a small 'wait' between each thread
	array::spread_all( hurt_triggers, &trigger_monitor );
	
}

//Destroy any rc_bomb that touches it. Self is the trigger.
function trigger_monitor()
{
	while(1)
	{
		self waittill ( "trigger", ent );
		
		if ( isdefined( ent.targetname ) && ent.targetname == "rcbomb" )
		{
			if ( level.script == "mp_castaway" )
			{
				// trigger has "SLOW" bit set - used to simulate players drowning
				if ( ent.spawnflags & 16 )
				{
					if ( self DepthInWater() < 23 )
					{
						continue;
					}
				}
			}

			self rcbomb_force_explode();
			return;
		}
	}
}

function rcbomb_force_explode()
{
	self endon("death");
  assert( self.targetname == "rcbomb" );

	while ( !isdefined( self getseatoccupant(0) ) )
	{
		wait(0.1);
	}
	self DoDamage( 10,self.origin + (0, 0, 10), self.owner, self.owner, "none", "MOD_EXPLOSIVE" ); 
}


function rcbomb_debug_box( origin, mins, maxs, color )
{
/#
	debug_rcbomb = GetDvarString( "debug_rcbomb" );
	if ( debug_rcbomb == "1" )
	{
		box( origin, mins, maxs, 0, color, 1, 1, 300 );
	}
#/
}

function rcbomb_debug_line( start, end, color )
{
/#
	debug_rcbomb = GetDvarString( "debug_rcbomb" );
	if ( debug_rcbomb == "1" )
	{
			line(start, end, color, 1, 1, 300);
	}
#/
}
