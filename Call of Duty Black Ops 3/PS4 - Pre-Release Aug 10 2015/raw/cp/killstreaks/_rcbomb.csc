#using scripts\codescripts\struct;

#using scripts\shared\clientfield_shared;
#using scripts\shared\math_shared;
#using scripts\shared\system_shared;
#using scripts\shared\util_shared;
#using scripts\shared\vehicle_shared;

    	   	                                                                                                                                         	                                	                                                                                                                                                                                                                                                                                                                                                                    	        	     	             	    	   	               	                                              	                                                           	                               	                     	                                                                                                           	                                                                 	                                                              	                                                                                                              	                            	                                     	                                       	                                                                                                              	   	                  	       	                                                    	                   	                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                        	                                  	                                                                                        	           	                        	                                            	                                             	                                                   	                                                             	                                                         	                                                                    	                                                                                                                                                                                                    	                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                         	                                                              	                                                          	                                   	                                   	                                                    	                                       	                                           	     	                                                                                                                                                                                                                                                      	                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                     
                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                            	                           	                           	                                                                                                                                                                                                                                                            	                                                                                                                                                                                                                                                                                                                                                                                       

#using scripts\cp\_callbacks;
#using scripts\shared\util_shared;
#using scripts\cp\_vehicle;



// _rcbomb.csc
// Sets up clientside behavior for the rcbomb

#precache( "client_fx", "_t6/vehicle/light/fx_rcbomb_blinky_light" );
#precache( "client_fx", "_t6/vehicle/light/fx_rcbomb_solid_light" );
#precache( "client_fx", "_t6/vehicle/light/fx_rcbomb_light_red_os" );
#precache( "client_fx", "_t6/vehicle/light/fx_rcbomb_light_green_os" );
#precache( "client_fx", "_t6/weapon/grenade/fx_spark_disabled_rc_car" );

#namespace rcbomb;

function autoexec __init__sytem__() {     system::register("rcbomb",&__init__,undefined,undefined);    }
	
function __init__()
{
	type = "rc_car_mp";

	level._effect["rcbomb_enemy_light"] = "_t6/vehicle/light/fx_rcbomb_blinky_light";
	level._effect["rcbomb_friendly_light"] = "_t6/vehicle/light/fx_rcbomb_solid_light";
	level._effect["rcbomb_enemy_light_blink"] = "_t6/vehicle/light/fx_rcbomb_light_red_os";
	level._effect["rcbomb_friendly_light_blink"] = "_t6/vehicle/light/fx_rcbomb_light_green_os";
	level._effect["rcbomb_stunned"] = "_t6/weapon/grenade/fx_spark_disabled_rc_car";

	clientfield::register( "vehicle", "rcbomb_countdown", 1, 2, "int", &countdown, !true, !true );
	
	// vehicle flags	
	clientfield::register( "vehicle", "rcbomb_stunned", 1, 1, "int", &callback::callback_stunned, !true, !true );
	
	vehicle::add_vehicletype_callback( "rc_car_mp", &spawned );
}


function spawned(localClientNum)
{
	self thread demo_think( localClientNum );
	self thread stunnedHandler(localClientNum);
}

function countdown( localClientNum, oldVal, newVal, bNewEnt, bInitialSnap, fieldName, bWasDemoJump )
{
	if ( !newVal )
	{
		return;
	}

	self notify( "light_disable" );

	self endon( "entityshutdown" );
	self endon( "light_disable" );
	
	interval = 1;

	if ( newVal == 2 )
	{
		interval = 0.133;
	}

	//self stop_light_fx( localClientNum );

	for( ;; )
	{
		self PlaySound( localClientNum, "wpn_crossbow_alert" );
		//self start_light_fx( localClientNum, true );

		util::server_wait( localClientNum, interval );
		interval = math::clamp( ( interval / 1.17 ), 0.1, 1 );
	}
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
		// self stop_light_fx( localClientNum );
	}
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

