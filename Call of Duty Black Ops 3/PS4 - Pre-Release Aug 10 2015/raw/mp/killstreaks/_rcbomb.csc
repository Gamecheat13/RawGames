#using scripts\codescripts\struct;

#using scripts\shared\clientfield_shared;
#using scripts\shared\math_shared;
#using scripts\shared\system_shared;
#using scripts\shared\util_shared;
#using scripts\shared\vehicle_shared;
#using scripts\shared\vehicles\_driving_fx;

                                                                                                  	  	                          	                                         	                     	                 	                                                                         	                       	                                                      	                                                      	                                                       	                                                                                                  	                                                           	                 	                                                                                                           	                	                                          	                                      	       	  	             	                                                     	                                                                             	                         	                                                                	                                                             	                                                             	                                                                                      	                                                         	                                                         	                                                               	                                                               	                                                   	                                                                	                                                     	                                                	                                                	                                                        	                                                                                                  	                                                                             	                                            	                                                                                    	                                          	                     	                                              	                                        	         	     
    	   	                                                                                                                                         	                                	                                                                                                                                                                                                                                                                                                                                                                    	        	     	             	    	   	               	                                              	                                                           	                               	                     	                                                                                                           	                                                                 	                                                              	                                                                                                              	                            	                                     	                                       	                                                                                                              	   	                  	       	                                                    	                   	                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                        	                                  	                                                                                        	           	                        	                                            	                                             	                                                   	                                                             	                                                         	                                                                    	                                                                                                                                                                                                    	                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                         	                                                              	                                                          	                                   	                                   	                                                    	                                       	                                           	     	                                                                                                                                                                                                                                                      	                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                     
                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                            	                           	                           	                                                                                                                                                                                                                                                            	                                                                                                                                                                                                                                                                                                                                                                                       

#using scripts\mp\_callbacks;
#using scripts\mp\_util;
#using scripts\mp\_vehicle;

// _rcbomb.csc
// Sets up clientside behavior for the rcbomb

#precache( "client_fx", "killstreaks/fx_rcxd_lights_blinky" );
#precache( "client_fx", "killstreaks/fx_rcxd_lights_solid" );
#precache( "client_fx", "killstreaks/fx_rcxd_lights_red" );
#precache( "client_fx", "killstreaks/fx_rcxd_lights_grn" );
#precache( "client_fx", "_t6/weapon/grenade/fx_spark_disabled_rc_car" );

#namespace rcbomb;






function autoexec __init__sytem__() {     system::register("rcbomb",&__init__,undefined,undefined);    }
	
function __init__()
{
	level._effect["rcbomb_enemy_light"] = "killstreaks/fx_rcxd_lights_blinky";
	level._effect["rcbomb_friendly_light"] = "killstreaks/fx_rcxd_lights_solid";
	level._effect["rcbomb_enemy_light_blink"] = "killstreaks/fx_rcxd_lights_red";
	level._effect["rcbomb_friendly_light_blink"] = "killstreaks/fx_rcxd_lights_grn";
	level._effect["rcbomb_stunned"] = "_t6/weapon/grenade/fx_spark_disabled_rc_car";

	level.rcBombBundle = struct::get_script_bundle( "killstreak", "killstreak_rcbomb" );
	
	// vehicle flags	
	clientfield::register( "vehicle", "rcbomb_stunned", 1, 1, "int", &callback::callback_stunned, !true, !true );
	
	vehicle::add_vehicletype_callback( "rc_car_mp",&spawned );
}

function spawned(localClientNum)
{
	self thread demo_think( localClientNum );
	self thread stunnedHandler(localClientNum);
	self thread boost_think( localClientNum );
	self thread shutdown_think( localClientNum );
	
	self.driving_fx_collision_override = &OnDrivingFxCollision;
	self.driving_fx_jump_landing_override = &OnDrivingFxJumpLanding;
	
	self.killstreakBundle = level.rcBombBundle;
}

function demo_think( localClientNum )
{
	self endon( "entityshutdown" );

	if ( !IsDemoPlaying() )
	{
		return;
	}

	for ( ;; )
	{
		level util::waittill_any( "demo_jump", "demo_player_switch" );
		self vehicle::lights_off( localClientNum );
	}
}

function boost_blur( localClientNum )
{
	self endon( "entityshutdown" );
	
	if ( isdefined( self.owner ) && self.owner isLocalPlayer() )
	{
		EnableSpeedBlur( localClientNum, GetDvarFloat( "scr_rcbomb_amount", 0.1 ), GetDvarFloat( "scr_rcbomb_inner_radius", 0.5 ), GetDvarFloat( "scr_rcbomb_outer_radius", 0.75 ), false, 0 );
		
		wait( GetDvarFloat( "scr_rcbomb_duration", 1.0 ) );
		
		DisableSpeedBlur( localClientNum );
	}
}

function boost_think( localClientNum )
{
	self endon( "entityshutdown" );
	
	for ( ;; )
	{
		self waittill( "veh_boost" );
		self boost_blur( localClientNum );
	}
}

function shutdown_think( localClientNum )
{
	self waittill( "entityshutdown" );
	DisableSpeedBlur( localClientNum );
}

function play_screen_fx_dirt(localClientNum)
{
		// support for this has been removed with the .menu system
		/*
		pick_one = RandomIntRange(0,4);
		if ( pick_one == 0 )
		{
			AnimateUI( localClientNum, "fullscreen_dirt", "dirt", "in", 0 );
		}
		else if ( pick_one == 1 )
		{
			AnimateUI( localClientNum, "fullscreen_dirt", "dirt_right_splash", "in", 0 );
		}
		else if ( pick_one == 2 )
		{
			AnimateUI( localClientNum, "fullscreen_dirt", "dirt_left_splash", "in", 0 );
		}
		else
		{
			AnimateUI( localClientNum, "fullscreen_dirt", "blurred_dirt_random", "in", 0 );
		}
		*/
}

function play_screen_fx_dust(localClientNum)
{
		// support for this has been removed with the .menu system
		/*
		pick_one = RandomIntRange(0,4);
		if ( pick_one == 0 )
		{
			AnimateUI( localClientNum, "fullscreen_dust", "dust", "in", 0 );
		}
		else if ( pick_one == 1 )
		{
			AnimateUI( localClientNum, "fullscreen_dust", "dust_right_splash", "in", 0 );
		}
		else if ( pick_one == 2 )
		{
			AnimateUI( localClientNum, "fullscreen_dust", "dust_left_splash", "in", 0 );
		}
		else
		{
			AnimateUI( localClientNum, "fullscreen_dust", "blurred_dust_random", "in", 0 );
		}
		*/
}

function play_driving_screen_fx( localClientNum )
{
	speed_fraction = 0;
	
	while(1)
	{
		speed = self getspeed();
		maxspeed = self getmaxspeed();
		
		if ( speed < 0 )
		{
			maxspeed = self getmaxreversespeed();
		}
		
		if ( maxspeed > 0 )
		{
			speed_fraction = Abs(speed) / maxspeed;
		}
		else
		{
			speed_fraction = 0;
		}
		if ( self iswheelcolliding( "back_left" ) || self iswheelcolliding( "back_right" ) )
		{
			// probably need to fix this to work on spectators
			if ( self IsLocalClientDriver( localClientNum ) )
			{
			}
		}
	}
}

function play_boost_fx( localClientNum )
{
	self endon( "entityshutdown" );

	while( 1 )
	{
		speed = self GetSpeed();

		if ( speed > 400 )
		{
			self PlaySound( localClientNum, "mpl_veh_rc_boost" );
			return;
		}

		util::server_wait( localClientNum, 0.1 );
	}
}

function stunnedHandler( localClientNum )
{
	self endon( "entityshutdown" );
	
	self thread engineStutterHandler( localClientNum );
	
	while( 1 )
	{
		self waittill( "stunned" );
///#
//		PrintLn( "CLIENT ***************** stunned" );
//#/
	
		self setstunned( true );
		
		self thread notStunnedHandler( localClientNum );
	
		self thread play_stunned_fx_handler( localClientNum );
	}
}

function notStunnedHandler( localClientNum )
{
	self endon( "entityshutdown" );
	self endon( "stunned" );
	
	self waittill( "not_stunned" );
///#
//		PrintLn( "CLIENT ***************** not stunned" );
//#/
	
	self setstunned( false );
}

function play_stunned_fx_handler( localClientNum ) // self == rc car
{
	self endon( "entityshutdown" );
	self endon( "stunned" );
	self endon( "not_stunned" );

	// we need this so we can continue to play fx if being stunned by the jammer
	while( true )
	{
		playfxontag( localClientNum, level._effect["rcbomb_stunned"], self, "tag_origin" );
		wait( 0.5 );
	}
}

function engineStutterHandler( localClientNum )
{
	self endon( "entityshutdown" );
	
	while( 1 )
	{
		self waittill( "veh_engine_stutter" );
		if ( self IsLocalClientDriver( localClientNum ) )
		{
			player = getlocalplayer( localClientNum );
			
			if( isdefined( player ) )
			{
				player PlayRumbleOnEntity( localClientNum, "rcbomb_engine_stutter" );
			}
		}
	}
}

function OnDrivingFxCollision( localClientNum, player, hip, hitn, hit_intensity )
{
	if( isdefined( hit_intensity ) && hit_intensity > 15 )
	{
		volume = driving_fx::get_impact_vol_from_speed();
		
		if (isdefined (self.sounddef))
		{
			alias = self.sounddef + "_suspension_lg_hd";
		}
		else
		{
			alias = "veh_default_suspension_lg_hd";
		}
		
		id = PlaySound( 0, alias, self.origin, volume);
		player Earthquake( 0.7, 0.25, player.origin, 1500 );
		player PlayRumbleOnEntity( localClientNum, "damage_heavy" );
	}
}

function OnDrivingFxJumpLanding( localClientNum, player )
{
	// do nothing for now
}


