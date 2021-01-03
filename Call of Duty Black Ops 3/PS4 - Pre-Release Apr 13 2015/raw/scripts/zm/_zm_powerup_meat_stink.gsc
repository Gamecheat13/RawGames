#using scripts\codescripts\struct;

#using scripts\shared\callbacks_shared;
#using scripts\shared\clientfield_shared;
#using scripts\shared\demo_shared;
#using scripts\shared\flag_shared;
#using scripts\shared\laststand_shared;
#using scripts\shared\system_shared;
#using scripts\shared\util_shared;

    	   	                                                                                                                         	                                                                                                                                                                                                                                                                                                                                                                    	        	     	             	    	   	                           	                               	                                	                                                              	                                                                                                              	                            	                                     	                                       	                                                               	   	                  	       	                                                    	                   	                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                       	                                                                                        	           	                        	                                            	                                             	                                                   	                                                             	                                                         	                                                                    	                                                                                                                                                                                                    	                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                     	                                                              	                                                          	                                   	                                   	                                                    	                                       
                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                            	                                                                                                                                                                                                                                                                                                                                                                                       

#using scripts\shared\ai\zombie_death;

#using scripts\zm\_zm_pers_upgrades_functions;
#using scripts\zm\_zm_powerups;
#using scripts\zm\_zm_score;
#using scripts\zm\_zm_stats;
#using scripts\zm\_zm_spawner;
#using scripts\zm\_zm_utility;

                                                                
                                                                                                                               

#precache( "fx", "_t6/maps/zombie/fx_zmb_meat_stink_camera" );
#precache( "fx", "_t6/maps/zombie/fx_zmb_meat_stink_torso" );
#precache( "fx", "_t6/maps/zombie/fx_zmb_meat_impact" );
#precache( "fx", "_t6/maps/zombie/fx_zmb_meat_marker" );

#namespace zm_powerup_meat_stink;

function autoexec __init__sytem__() {     system::register("zm_powerup_meat_stink",&__init__,undefined,undefined);    }

//-----------------------------------------------------------------------------------
// setup
//-----------------------------------------------------------------------------------
function __init__()
{
	zm_powerups::register_powerup( "meat_stink", &grab_meat_stink );
	zm_powerups::register_powerup_weapon( "meat_stink", &meat_stink_countdown );
	zm_powerups::add_zombie_powerup( "meat_stink", "t6_wpn_zmb_meat_world", undefined, &func_should_drop_meat, !true, !true, !true );
	level.zombie_powerup_weapon[ "meat_stink" ] = GetWeapon( "meat_stink" );
	
	clientfield::register( "toplayer", "meat_stink", 1, 1, "int" );
	
	level._effect[ "meat_stink_camera" ] = "_t6/maps/zombie/fx_zmb_meat_stink_camera";
	level._effect[ "meat_stink_torso" ] = "_t6/maps/zombie/fx_zmb_meat_stink_torso";
	level._effect["meat_impact"] = "_t6/maps/zombie/fx_zmb_meat_impact";
	level._effect["meat_marker"] = "_t6/maps/zombie/fx_zmb_meat_marker";
	
	callback::on_spawned( &player_watch_grenade_throw );
}

function grab_meat_stink( player )
{	
	level thread meat_stink( player );
}

function meat_stink( who )
{
	weapons = who GetWeaponsList();
	has_meat = false;
	
	weapon_meat = GetWeapon( "meat_stink" );
	foreach ( weapon in weapons )
	{
		if ( weapon == weapon_meat )
		{
			has_meat = true;
		}
	}
	
	if ( has_meat )
	{
		return;
	}
	
	/*
	PlayFX( level._effect["powerup_grabbed"], who.origin );
	PlayFX( level._effect["powerup_grabbed_wave"], who.origin );
	playsoundatposition( "zmb_powerup_grabbed", who.origin );
	*/
	
	who.pre_meat_weapon = who GetCurrentWeapon();

	level notify ("meat_grabbed" );
	who notify( "meat_grabbed" );
	
	who playsound ("zmb_pickup_meat");
	//who zm_utility::increment_is_drinking();
	//who GiveWeapon( weapon_meat );
	//who SwitchToWeapon( weapon_meat );
	//who SetWeaponAmmoClip( weapon_meat, 1 );

	zm_powerups::weapon_powerup( who, undefined, "meat_stink" );	
}

function func_should_drop_meat()
{
	if ( zm_powerups::minigun_no_drop() )
	{
		return false;
	}
	return true;
}

function player_watch_grenade_throw()
{
	self endon ( "death_or_disconnect" );

	for ( ;; )
	{
		self waittill( "grenade_fire", weapon, weapname );

		if ( weapname == GetWeapon("meat_stink") )
		{
			weapon.owner = self;
			weapon thread item_meat_watch_bounce();
		}
	}
}

function item_meat_watch_bounce()
{
	self endon( "death" );	
	self endon( "picked_up" );
	self.meat_is_flying=true; 
	self waittill("grenade_bounce", pos, normal, ent);
	
	if(isdefined(level.meat_bounce_override))
	{
		self thread [[level.meat_bounce_override]](pos, normal, ent);
		return;
	}
	
	if(isDefined(level.spawned_collmap))
	{
		if(isDefined(ent) && ent == level.spawned_collmap)
		{
			playfx(level._effect["meat_bounce"],pos,normal);
		}
	}
	
	if ( isdefined(ent) && isplayer( ent ) )
	{
		self.owner hit_player_with_meat( ent );
	}
	
	self.meat_is_flying=false; 

	self thread watch_for_roll();
	//play the "stationairy" effect when the meat bounces the first time
	playfxontag( level._effect["meat_marker"], self, "tag_origin"  );
}

function meat_bounce( pos, normal, ent )
{
	if ( IsDefined( ent ) && IsPlayer( ent ) )
	{
		//Directly hit a player!
		if( !ent laststand::player_is_in_laststand() )
		{
			level thread meat_stink_player( ent );
			
			//stat tracking 
			if(isDefined(self.owner))
			{
				demo::bookmark( "zm_player_meat_stink", gettime(), ent, self.owner, 0, self );
				self.owner zm_stats::increment_client_stat( "contaminations_given" );
			}
		}
	}
	else
	{
		//Do a check and see if any players are close to this bounce!
		players = GetPlayers();
		closest_player = undefined;
		closest_player_dist = 100.0 * 100.0;	//distance for splash from meat
		for ( player_index = 0; player_index < players.size; player_index++ )
		{
			player_to_check = players[player_index];
			
			if( self.owner == player_to_check )
				continue;

			if( player_to_check laststand::player_is_in_laststand() )
				continue;
			
			distSq =  distancesquared( pos, player_to_check.origin );
			
			if( distSq < closest_player_dist )
			{
				closest_player = player_to_check;
				closest_player_dist = distSq;
			}
		}
		
		if( isdefined( closest_player ) )
		{
			level thread meat_stink_player( closest_player );
			
			//stat tracking 
			if(isDefined(self.owner))
			{
				demo::bookmark( "zm_player_meat_stink", gettime(), closest_player, self.owner, 0, self );
				self.owner zm_stats::increment_client_stat( "contaminations_given" );
			}
		}
		else
		{
			valid_poi = zm_utility::check_point_in_enabled_zone( pos, undefined, undefined );
			
			if ( valid_poi )
			{
				self Hide();
				level thread meat_stink_on_ground( self.origin );
			}
		}
		PlayFX( level._effect[ "meat_impact" ], self.origin );		
	}
	
	self Delete();
}

function meat_stink_on_ground( position_to_play )
{
	level.meat_on_ground = true;
	attractor_point = Spawn( "script_model", position_to_play );
	attractor_point SetModel( "tag_origin" );
	attractor_point PlaySound ("zmb_land_meat");
	
	wait ( 0.2 ); // TODO: TEMP WAIT TO PLAY FX ON SPAWNED ENTITY
	
	PlayFXOnTag( level._effect[ "meat_stink_torso" ], attractor_point, "tag_origin" );
	
	attractor_point PlayLoopSound ("zmb_meat_flies");
	
	attractor_point zm_utility::create_zombie_point_of_interest( 1536, 32, 10000 );
	attractor_point.attract_to_origin = true;
	
	attractor_point thread zm_utility::create_zombie_point_of_interest_attractor_positions( 4, 45 );
	attractor_point thread zm_utility::wait_for_attractor_positions_complete();
	
	attractor_point util::delay( 15, undefined, &zm_utility::self_delete );
	wait( 16.0 );
	level.meat_on_ground = undefined;
}

function meat_stink_player( who )
{
	level notify( "new_meat_stink_player" );
	level endon( "new_meat_stink_player" );
	
	who.ignoreme = false;
	
	players = GetPlayers();	
	foreach ( player in players )
	{
		player thread meat_stink_player_cleanup();
		
		if ( player != who )
		{
			player.ignoreme = true;
		}
	}
	
	who thread meat_stink_player_create();
	                                                                                                              
	who util::waittill_any_timeout( 30, "disconnect", "player_downed", "bled_out" );
	
	players = GetPlayers();	
	foreach ( player in players )
	{
		player thread meat_stink_player_cleanup();
		player.ignoreme = false;
	}
}

function meat_stink_player_create()
{	
	//stat tracking
	self zm_stats::increment_client_stat( "contaminations_received" );
	
	self endon( "disconnect" );
	self endon( "death" );
	
	tagName = "J_SpineLower";
	self.meat_stink_3p = Spawn( "script_model", self GetTagOrigin( tagName ) );
	self.meat_stink_3p SetModel( "tag_origin" );
	self.meat_stink_3p LinkTo( self, tagName );
	wait ( 0.5 ); // TODO: TEMP WAIT TO PLAY FX ON SPAWNED ENTITY
	PlayFXOnTag( level._effect[ "meat_stink_torso" ], self.meat_stink_3p, "tag_origin" );
	
	self clientfield::set_to_player( "meat_stink", 1 );
}

function meat_stink_player_cleanup()
{
	if ( IsDefined( self.meat_stink_3p ) )
	{
		self.meat_stink_3p UnLink();
		self.meat_stink_3p Delete();
	}	
	
	self clientfield::set_to_player( "meat_stink", 0 );
}

function hit_player_with_meat( hit_player )
{
/#
	println( "MEAT: Player " + self.name + " hit " + hit_player.name + " with the meat\n");
#/
}

function watch_for_roll()
{
	self endon( "stationary" );	
	self endon( "death" );	
	self endon( "picked_up" );	
	self.meat_is_rolling = false;
	while(1)
	{
		old_z = self.origin[2];
		wait(1);
		if( Abs(old_z - self.origin[2]) < 10 )
		{
			self.meat_is_rolling = true;
			self PlayLoopSound( "zmb_meat_looper", 2 );
		}
	}	
}

function meat_stink_countdown( ent_player, str_weapon_time )
{
	while ( true )
	{
		ent_player waittill( "grenade_fire", weapon, weapname );

		if ( weapname == GetWeapon("meat_stink") )
		{
			break;
		}
	}	
}
