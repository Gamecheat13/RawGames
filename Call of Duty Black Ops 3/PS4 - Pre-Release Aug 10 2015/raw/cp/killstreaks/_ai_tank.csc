#using scripts\codescripts\struct;

#using scripts\shared\clientfield_shared;
#using scripts\shared\system_shared;
#using scripts\shared\util_shared;
#using scripts\shared\vehicle_shared;

    	   	                                                                                                                                         	                                	                                                                                                                                                                                                                                                                                                                                                                    	        	     	             	    	   	               	                                              	                                                           	                               	                     	                                                                                                           	                                                                 	                                                              	                                                                                                              	                            	                                     	                                       	                                                                                                              	   	                  	       	                                                    	                   	                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                        	                                  	                                                                                        	           	                        	                                            	                                             	                                                   	                                                             	                                                         	                                                                    	                                                                                                                                                                                                    	                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                         	                                                              	                                                          	                                   	                                   	                                                    	                                       	                                           	     	                                                                                                                                                                                                                                                      	                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                     
                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                            	                           	                           	                                                                                                                                                                                                                                                            	                                                                                                                                                                                                                                                                                                                                                                                       

#using scripts\shared\util_shared;
#using scripts\cp\_vehicle;



#precache( "client_fx", "_t6/vehicle/treadfx/fx_treadfx_talon_dirt" );
#precache( "client_fx", "_t6/vehicle/treadfx/fx_treadfx_talon_concrete" );
#precache( "client_fx", "_t6/light/fx_vlight_talon_eye_grn" );
#precache( "client_fx", "_t6/light/fx_vlight_talon_eye_red" );
#precache( "client_fx", "_t6/weapon/talon/fx_talon_emp_stun" );

#using_animtree ( "mp_vehicles" );

#namespace ai_tank;

function autoexec __init__sytem__() {     system::register("ai_tank",&__init__,undefined,undefined);    }
	
function __init__()
{
	level._ai_tank_fx = [];
	level._ai_tank_fx[ "dirt" ]			= "_t6/vehicle/treadfx/fx_treadfx_talon_dirt";
	level._ai_tank_fx[ "concrete" ]		= "_t6/vehicle/treadfx/fx_treadfx_talon_concrete";
	level._ai_tank_fx[ "light_green" ]	= "_t6/light/fx_vlight_talon_eye_grn";
	level._ai_tank_fx[ "light_red" ]	= "_t6/light/fx_vlight_talon_eye_red";
	level._ai_tank_fx[ "stun" ]			= "_t6/weapon/talon/fx_talon_emp_stun";

	clientfield::register( "vehicle", "ai_tank_death", 1, 1, "int",&death, !true, !true );
	clientfield::register( "vehicle", "ai_tank_missile_fire", 1, 3, "int",&missile_fire, !true, !true );
	clientfield::register( "vehicle", "ai_tank_hack_spawned", 1, 1, "int",&spawned, !true, !true );
	clientfield::register( "vehicle", "ai_tank_hack_rebooting", 1, 1, "int",&rebooting, !true, !true );

	clientfield::register( "vehicle", "ai_tank_stun", 1, 1, "int", &tank_stun, !true, !true );
	
	vehicle::add_vehicletype_callback( "ai_tank_drone_mp",&spawned );
}

function spawned( localClientNum, oldVal, newVal, bNewEnt, bInitialSnap, fieldName, bWasDemoJump )
{
	self thread play_light_fx( localClientNum );
	self thread play_driving_fx( localClientNum );
	self thread play_driving_rumble( localClientNum );
}

function missile_fire( localClientNum, oldVal, newVal, bNewEnt, bInitialSnap, fieldName, bWasDemoJump )
{
	if( IsDefined( self.classname ) && self.classname != "spawner_bo3_quadtank_enemy" )
	{
		self UseAnimTree( #animtree );

		if ( newVal == 2 )
		{
			self SetAnimRestart( %o_drone_tank_missile1_fire, 1.0, 0.0, 0.5 );
		}
		else if ( newVal == 1 )
		{
			self SetAnimRestart( %o_drone_tank_missile2_fire, 1.0, 0.0, 0.5 );
		}
		else if ( newVal == 0 )
		{
			self SetAnimRestart( %o_drone_tank_missile3_fire, 1.0, 0.0, 0.5 );
		}
		else if ( newVal == 4 )
		{
			self SetAnimRestart( %o_drone_tank_missile_full_reload, 1.0, 0.0, 1.0 );
		}
	}
}

function play_light_fx( localClientNum )
{
	self notify( "light_disable" );
	
	self endon( "entityshutdown" );
	self endon( "light_disable" );
	self endon( "death" );

	self notify( "reboot_disable" );

	self util::waittill_dobj( localClientNum );

	self stop_light_fx( localClientNum );
	self start_light_fx( localClientNum );
	
	for( ;; )
	{
		level util::waittill_any( "snap_processed", "demo_jump", "demo_player_switch" );

		if ( IsDemoPlaying() && GetDvarString( "ui_gametype" ) == "hack" && self clientfield::get( "ai_tank_hack_spawned" ) <= 0 )
		{
			self stop_light_fx( localClientNum );
			return;
		}

		player = GetLocalPlayer( localClientNum );
		
		if ( !isdefined( player ) )
		{
			self stop_light_fx( localClientNum );
			continue;
		}
		else if ( IsInVehicle( localClientNum, self ) )
		{
			self stop_light_fx( localClientNum );
		}
		else if ( player GetInKillcam( localClientNum ) )
		{
			continue;
		}
		else if ( self.friend != self util::friend_not_foe( localClientNum ) )
		{
			self stop_light_fx( localClientNum );
		}

		if ( !IsInVehicle( localClientNum, self ) && !isdefined( self.fx ) )
		{
			self start_light_fx( localClientNum );
		}
	}
}

function tank_stun( localClientNum, oldVal, newVal, bNewEnt, bInitialSnap, fieldName, bWasDemoJump )
{
	self endon( "entityshutdown" );
	self endon( "death" );
	
	if ( newVal )
	{
		self notify( "light_disable" );
		self stop_light_fx( localClientNum );

		self stop_stun_fx( localClientNum );
		self start_stun_fx( localClientNum );
	}
	else
	{
		self thread play_light_fx( localClientNum );			
		self stop_stun_fx( localClientNum );
	}
}

function death( localClientNum, oldVal, newVal, bNewEnt, bInitialSnap, fieldName, bWasDemoJump )
{
	player = GetLocalPlayer( localClientNum );

	if ( !isdefined( player ) )
	{
		return;
	}

	if ( player GetInKillcam( localClientNum ) )
	{
		return;
	}

	if ( newVal )
	{
		self stop_light_fx( localClientNum );
		self stop_stun_fx( localClientNum );
		self notify( "light_disable" );
	}
}

function start_light_fx( localClientNum )
{
	friend = self util::friend_not_foe( localClientNum );

	player = GetLocalPlayer( localClientNum );

	if ( IsInVehicle( localClientNum, self ) )
	{
		return;
	}


	if ( friend )
	{
		self.fx = playfxontag( localClientNum, level._ai_tank_fx[ "light_green" ], self, "tag_scanner" );
		self.friend = true;
	}
	else
	{
		self.fx = playfxontag( localClientNum, level._ai_tank_fx[ "light_red" ], self, "tag_scanner" );
		self.friend = false;
	}
}

function stop_light_fx( localClientNum )
{
	if ( isdefined( self.fx ) )
	{
		StopFx( localClientNum, self.fx );
		self.fx = undefined;
	}
}

function start_stun_fx( localClientNum )
{
	self.stun_fx = PlayFxOnTag( localClientNum, level._ai_tank_fx[ "stun" ], self, "tag_origin" );
	PlaySound( localClientNum, "veh_talon_shutdown", self.origin );
}

function stop_stun_fx( localClientNum )
{
	if ( isdefined( self.stun_fx ) )
	{
		StopFx( localClientNum, self.stun_fx );
		self.stun_fx = undefined;
	}
}

function play_driving_fx( localClientNum )
{
	self notify( "driving_fx" );
	
	self endon( "entityshutdown" );
	self endon( "driving_fx" );

	for( ;; )
	{
		if ( self GetSpeed() >= 40 )
		{
			forward = AnglesToForward( self.angles );
			up = AnglesToUp( self.angles );
						
			fx = self get_surface_fx();
			PlayFx( localClientNum, fx, self.origin, forward, up );

			wait( 0.5 );
			continue;
		}

		util::server_wait( localClientNum, 0.1 );
	}
}

function play_driving_rumble( localClientNum )
{
	self notify( "driving_rumble" );

	self endon( "entityshutdown" );
	self endon( "death" );
	self endon( "driving_rumble" );

	for ( ;; )
	{
		if ( IsInVehicle( localClientNum, self ) )
		{
			speed = self GetSpeed();

			if ( speed >= 40 || speed <= -40 )
			{
				player = GetLocalPlayer( localClientNum );

				if ( isdefined( player ) )
				{
					player Earthquake( 0.1, 0.1, self.origin, 200 );
				}
			}
		}

		util::server_wait( localClientNum, 0.05 );
	}
}

function rebooting( localClientNum, oldVal, newVal, bNewEnt, bInitialSnap, fieldName, bWasDemoJump )
{
	player = GetLocalPlayer( localClientNum );

	if ( !isdefined( player ) )
	{
		return;
	}

	if ( player GetInKillcam( localClientNum ) )
	{
		return;
	}

	if ( newVal )
	{
		self thread start_reboot_fx( localClientNum );
	}
	else
	{
		self notify( "reboot_disable" );
		self stop_light_fx( localClientNum );
	}
}

function start_reboot_fx( localClientNum )
{
	self endon( "entityshutdown" );
	self endon( "reboot_disable" );
	self endon( "death" );

	self start_light_fx( localClientNum );
	util::server_wait( localClientNum, 0.3 );
	self stop_light_fx( localClientNum );
	util::server_wait( localClientNum, 0.3 );
	self start_light_fx( localClientNum );
	util::server_wait( localClientNum, 0.2 );
	self stop_light_fx( localClientNum );
	util::server_wait( localClientNum, 0.2 );
	self start_light_fx( localClientNum );
	util::server_wait( localClientNum, 0.2 );
	self stop_light_fx( localClientNum );
	util::server_wait( localClientNum, 0.2 );
	self start_light_fx( localClientNum );
	util::server_wait( localClientNum, 0.1 );
	self stop_light_fx( localClientNum );
	util::server_wait( localClientNum, 0.1 );
	self start_light_fx( localClientNum );
	util::server_wait( localClientNum, 0.1 );
	self stop_light_fx( localClientNum );
	util::server_wait( localClientNum, 0.1 );
	self start_light_fx( localClientNum );
	util::server_wait( localClientNum, 0.1 );
	self stop_light_fx( localClientNum );
	util::server_wait( localClientNum, 0.1 );
	self start_light_fx( localClientNum );
	util::server_wait( localClientNum, 0.1 );
	self stop_light_fx( localClientNum );
}

function get_surface_fx()
{
	surface_type = self GetWheelSurface( "front_right" );
	
	switch( surface_type )
	{
		case "dirt":
		case "mud":
		case "gravel":
		case "grass":
		case "foliage":
		case "sand":
		case "water":
			return level._ai_tank_fx[ "dirt" ];	
	}
	
	return level._ai_tank_fx[ "concrete" ];
}
