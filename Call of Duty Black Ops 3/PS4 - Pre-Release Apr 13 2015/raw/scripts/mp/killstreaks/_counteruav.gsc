#using scripts\codescripts\struct;
#using scripts\shared\util_shared;
#using scripts\shared\clientfield_shared;
#using scripts\shared\hostmigration_shared;
#using scripts\shared\killstreaks_shared;
#using scripts\shared\callbacks_shared;
#using scripts\shared\vehicle_shared;
#using scripts\shared\weapons\_hacker_tool;

#using scripts\mp\gametypes\_shellshock;
#using scripts\mp\killstreaks\_killstreakrules;
#using scripts\mp\killstreaks\_killstreaks;
#using scripts\mp\killstreaks\_remote_weapons;
#using scripts\mp\_util;

    	   	                                                                                                                         	                                                                                                                                                                                                                                                                                                                                                                    	        	     	             	    	   	                           	                               	                                	                                                              	                                                                                                              	                            	                                     	                                       	                                                               	   	                  	       	                                                    	                   	                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                        	                                                                                        	           	                        	                                            	                                             	                                                   	                                                             	                                                         	                                                                    	                                                                                                                                                                                                    	                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                      	                                                              	                                                          	                                   	                                   	                                                    	                                       
                                            
                                                                                                          	                                              	                       	                   	                                                                         	                       	                                                      	                                                      	                                                       	                                                                                                 	                                                           	                 	                                                   	                	                                          	                                          	       	  	              	                                                  	                                                                 	                                                                  	                                                         	                                                   	                                                   	                                                                             	                                                                	                                                             	                                                             	                                   	                                   	                                                    	                                                    	                                                                                      	                                                         	                                                         	                                                               	                                                               	                                                   	                                                                	                                                     	                                                	                                                	                                                        	                                                                                                  	                                                                                 	                                            	                                                                                    	                                          	                       	                    
                                                                                                                                                                                                                                                                 	                                                                                     														            														           						                           														          														         														        														                      														                                                                                                                                           															      															                                                      	        	       	                	           

#namespace dart;



	
#precache( "fx", "killstreaks/fx_dart_death_exp" );
	
function init()
{
	killstreaks::register( "dart", "dart", "killstreak_dart", "dart_used", &ActivateDart, true) ;
	killstreaks::register_strings( "dart", &"KILLSTREAK_DART_EARNED", &"KILLSTREAK_DART_NOT_AVAILABLE", &"KILLSTREAK_DART_INBOUND" );
	killstreaks::register_dialog( "dart", "mpl_killstreak_dart_strt", "kls_dart_used", "","kls_playerheli_enemy", "", "kls_dart_ready" );
	killstreaks::register_dialog( "dart", "mpl_killstreak_dart_strt", 4, undefined, 95, 113, 95 );
	
	killstreaks::register_alt_weapon( "dart", "killstreak_remote" );
	
	remote_weapons::RegisterRemoteWeapon( "dart", &"", &StartDartRemoteControl, &EndDartRemoteControl );
	
	level.active_darts = [];
	callback::on_connect( &OnPlayerConnect );
	
	level._effect["dartxplosion"] = "killstreaks/fx_dart_death_exp";
}

function OnPlayerConnect()
{
	assert( IsPlayer( self ) );
	player = self;
	
	if( !isdefined( player.entNum ) )
	{
		player.entNum = self getEntityNumber();
	}
	
	assert( IsDefined( level.active_darts ) );
	level.active_darts[ player.entNum ] = undefined;
}

function ActivateDart( killstreakType )
{
	assert( IsPlayer( self ) );
	player = self;
	
	if( !player killstreakrules::isKillstreakAllowed( "dart", player.team ) )
	{
		return false;
	}
	
	player DisableOffhandWeapons();
	
	player thread WatchThrow();
	
	missileWeapon = undefined;
	currentWeapon = player GetCurrentWeapon();
	if( currentWeapon.name == "dart" )
	{
		missileWeapon = currentWeapon;
	}
	
	assert( isdefined( missileWeapon ) );
	if( !isdefined( missileWeapon ) )
	{
		return false;
	}

	notifyString = player util::waittill_any_return( "weapon_change", "grenade_fire", "death" );
	if ( notifyString == "weapon_change" ||  notifyString == "death" )
	{
		return false; 
	}
	
	notifyString = player util::waittill_any_return( "weapon_change", "death" );
	if ( notifyString == "death" )
	{
		return true; 
	}
	
	player TakeWeapon( missileWeapon );
	if( player HasWeapon( missileWeapon ) || player GetAmmoCount( missileWeapon ) )
	{
		return false;
	}
	
	return true;
}

function WatchThrow()
{
	assert( IsPlayer( self ) );
	player = self;
	playerEntNum = player.entNum;
	
	player endon( "disconnect" );
	player endon( "death" );
	player endon( "cancel_dart_throw" );
	level endon( "game_ended" );
	
	player thread WatchCancelThrowEvents();
	
	player waittill( "grenade_fire", grenade, weapon );
	
	killstreak_id = player killstreakrules::killstreakStart( "dart", player.team, undefined, false );
	if( killstreak_id == (-1) )
	{
		return false;
	}
	
	player AddWeaponStat( GetWeapon( "dart" ), "used", 1 );
	
	player thread SpawnDart( grenade, killstreak_id );
	self killstreaks::play_killstreak_start_dialog( "dart", self.team );
	
	assert( isdefined( level.active_darts ) );	
	level.active_darts[ playerEntNum ] = SpawnStruct();
	remote_weapons::UseRemoteWeapon( level.active_darts[ playerEntNum ], "dart", true );
	
	return true;
}

function WatchCancelThrowEvents()
{
	player = self;
	player endon( "grenade_fire" );
	player endon( "disconnect" );
	player endon( "death" );
	level endon( "game_ended" );

	while( true )
	{
		if( player IsWallRunning() || player IsPlayerSwimming() )
		{
			if( isdefined( player.lastNonKillstreakWeapon ) )
			{
				player killstreaks::switch_to_last_non_killstreak_weapon();
				player notify( "cancel_dart_throw" );
				return;
			}
		}
		
		{wait(.05);};
	}
}

function WaitForTimeout( duration, callback )
{
	self endon( "remote_weapon_end" );
	self.vehicle endon( "death" );
	
	hostmigration::MigrationAwareWait( duration );
	
	if (killstreaks::should_not_timeout("dart"))
	{
		return;
	}		

	self notify( "timed_out" );
	self [[ callback ]]();
}

function SpawnDart( grenade, killstreak_id )
{
	player = self;
	assert( IsPlayer( player ) );
	playerEntNum = player.entNum;
		
	wait( ( 0.2 ) );
	
	grenadeMover = spawn( "script_model", grenade.origin );
	grenadeMover.angles = grenade.angles;
	grenadeMover SetModel( "veh_t7_drone_dart" );
	grenade Delete();
	
	grenadeForward = AnglesToForward( grenadeMover.angles );
	moveAmount = VectorScale( grenadeForward, ( 400 ) );
	trace = BulletTrace( grenadeMover.origin, grenadeMover.origin + moveAmount, true, undefined );
	endPos = grenadeMover.origin + VectorScale( moveAmount, ( trace[ "fraction" ] / 2.0 ) );
	grenadeMover MoveTo( endPos, ( 0.5 ), 0, ( 0.5 ) );
	
	wait( ( 0.5 ) );
	
	level.active_darts[playerEntNum].vehicle = SpawnVehicle( "veh_dart_mp", grenadeMover.origin, player.angles, "dynamic_spawn_ai" );
	grenadeMover Delete();
	
	dart = level.active_darts[playerEntNum].vehicle;
	
	dart SetTeam( player.team );
	dart clientfield::set( "enemyvehicle", 1 );
	dart.team = player.team;
	dart.killstreak_id = killstreak_id;
	dart.hardpointType = "dart";
	dart.owner = player;
	dart.ownerEntNum = playerEntNum;
	level.active_darts[ playerEntNum ] thread WaitForTimeout( ( 999999 ), &OnTimeout );
	player.killstreak_waitamount = ( 999999 );
	dart hacker_tool::registerWithhackerTool( ( 50 ), ( 2000 ) );
	Target_Set( dart );
}

function StartDartRemoteControl( dart )
{
	player = self;
	assert( IsPlayer( player ) );
	
	dart.vehicle UseVehicle( player, 0 );
	dart thread WatchDeath();
	dart thread WatchAmmo();
	dart thread WatchTeamChange();
	dart thread WatchCollision();
	dart thread WatchOwnerDeath();
}

function EndDartRemoteControl( dart, exitRequestedByOwner )
{
	dart LeaveDart();
}

function WatchCollision()
{
	dart = self.vehicle;
	dart endon( "death" );
	dart.owner endon( "disconnect" );
	
	while( 1 )
	{
		dart waittill( "veh_collision", velocity, normal );
		
		if( abs( normal[1] ) == 1 && abs( velocity[ 1 ] ) > ( 500.0 ) )
		{
			self notify( "remote_weapon_end" );
			self LeaveDart();
		}
	}
}

function WatchDeath()
{
	dart = self.vehicle;
	dart endon( "dart_destroyed" );
	dart.owner endon( "disconnect" );
	
	dart waittill( "death" );
	
	if( isdefined( dart ) )
	{
		self OnTimeout();
	}
}

function WatchOwnerDeath()
{
	dart = self.vehicle;
	dart endon( "dart_destroyed" );
	dart.owner waittill( "death" );
	if( isdefined( dart ) )
	{
		self OnTimeout();
	}
}

function WatchTeamChange()
{
	dart = self.vehicle;
	dart endon( "death" );
	dart.owner endon( "disconnect" );
	
	dart.owner util::waittill_any( "joined_team", "disconnect", "joined_spectators" );
	self notify( "remote_weapon_end" );
	self LeaveDart();
}

function WatchAmmo()
{
	dart = self.vehicle;
	dart endon( "death" );
	dart.owner endon( "disconnect" );
	
	shotCount = 0;
	
	while( true )
	{
		dart waittill( "weapon_fired" );
		shotCount++;
		
		if( shotCount >= ( 2 ) )
		{
			self notify( "remote_weapon_end" );
			self LeaveDart();
		}
	}
}

function OnTimeout()
{
	self LeaveDart();
	self notify( "remote_weapon_end" );
}

function LeaveDart( attacker, weapon )
{
	dart = self.vehicle;
	
	explosionOrigin = dart.origin;
	explosionAngles = dart.angles;
	
	if ( !isdefined( attacker ) )
	{
		attacker = dart.owner;
	}
	
	if( !isdefined( weapon ) || !weapon.isEmp )
	{
		PhysicsExplosionSphere( dart.origin, 256, 256, 1, ( 25 ), ( 350 ) );
		dart shellshock::rcbomb_earthquake( dart.origin );
		PlayFX( level._effect["dartxplosion"] , explosionOrigin, ( 0, 0, 1 ) );
		PlaySoundAtPosition( "veh_dart_explo" , explosionOrigin );
		dart vehicle::lights_off();
		dart Hide();
	}
	
	if( isdefined( dart.owner ) )
	{
		dart.owner util::freeze_player_controls( true );
		
		forward = AnglesToForward( dart.angles );
		moveAmount = VectorScale( forward, -( ( 300 ) ) );
		cam = spawn( "script_model", dart.origin + moveAmount );
		cam SetModel( "tag_origin" );
		cam LinkTo( dart );
			
		dart.owner CameraSetPosition( cam );
		dart.owner CameraSetLookAt( dart );
		dart.owner CameraActivate( true );	
	
		wait( ( 2 ) );
		
		dart.owner CameraActivate( false );
		cam delete();
		
		dart.owner util::freeze_player_controls( false );
		dart.owner unlink();
		dart.owner killstreaks::clear_using_remote();
		dart.owner.killstreak_waitamount = undefined;
	}
	
	killstreakrules::killstreakStop( "dart", dart.team, dart.killstreak_id );

	dart Delete();
	dart notify( "dart_destroyed" );
}
