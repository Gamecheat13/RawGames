#using scripts\codescripts\struct;

#using scripts\shared\callbacks_shared;
#using scripts\shared\clientfield_shared;
#using scripts\shared\system_shared;
#using scripts\shared\util_shared;
#using scripts\shared\vehicle_shared;

    	   	                                                                                                                                         	                                	                                                                                                                                                                                                                                                                                                                                                                    	        	     	             	    	   	               	                                              	                                                           	                               	                     	                                                                                                           	                                                                 	                                                              	                                                                                                              	                            	                                     	                                       	                                                                                                              	   	                  	       	                                                    	                   	                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                        	                                  	                                                                                        	           	                        	                                            	                                             	                                                   	                                                             	                                                         	                                                                    	                                                                                                                                                                                                    	                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                         	                                                              	                                                          	                                   	                                   	                                                    	                                       	                                           	     	                                                                                                                                                                                                                                                      	                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                     
                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                            	                           	                           	                                                                                                                                                                                                                                                            	                                                                                                                                                                                                                                                                                                                                                                                       
                                                                                                  	  	                          	                                         	                     	                 	                                                                         	                       	                                                      	                                                      	                                                       	                                                                                                  	                                                           	                 	                                                                                                           	                	                                          	                                      	       	  	             	                                                     	                                                                             	                         	                                                                	                                                             	                                                             	                                                                                      	                                                         	                                                         	                                                               	                                                               	                                                   	                                                                	                                                     	                                                	                                                	                                                        	                                                                                                  	                                                                             	                                            	                                                                                    	                                          	                     	                                              	                                        	         	     
#using scripts\shared\visionset_mgr_shared;

#using scripts\mp\_util;
#using scripts\mp\_vehicle;



#precache( "client_fx", "killstreaks/fx_agr_emp_stun" );

#using_animtree ( "mp_vehicles" );

#namespace ai_tank;

function autoexec __init__sytem__() {     system::register("ai_tank",&__init__,undefined,undefined);    }

function __init__()
{
	bundle = struct::get_script_bundle( "killstreak", "killstreak_ai_tank_drop" );
	level.aiTankKillstreakBundle = bundle;
	
	level._ai_tank_fx = [];
	level._ai_tank_fx[ "light_green" ]	= "killstreaks/fx_agr_vlight_eye_grn";
	level._ai_tank_fx[ "light_red" ]	= "killstreaks/fx_agr_vlight_eye_red";
	level._ai_tank_fx[ "stun" ]			= "killstreaks/fx_agr_emp_stun";

	clientfield::register( "vehicle", "ai_tank_death", 1, 1, "int",&death, !true, !true );
	clientfield::register( "vehicle", "ai_tank_missile_fire", 1, 2, "int",&missile_fire, !true, !true );	
	clientfield::register( "vehicle", "ai_tank_stun", 1, 1, "int", &tank_stun, !true, !true );
	clientfield::register( "toplayer", "ai_tank_update_hud", 1, 1, "counter", &update_hud,  !true, !true );
	
	vehicle::add_vehicletype_callback( "ai_tank_drone_mp", &spawned );
	vehicle::add_vehicletype_callback( "spawner_bo3_ai_tank_mp", &spawned );
	vehicle::add_vehicletype_callback( "spawner_bo3_ai_tank_mp_player", &spawned );
	
	visionset_mgr::register_visionset_info( "agr_visionset", 1, 16, undefined, "mp_vehicles_agr" );
}

function spawned( localClientNum, killstreak_duration )
{
	self thread play_driving_rumble( localClientNum );
	self.killstreakBundle = level.aiTankKillstreakBundle;
}

function missile_fire( localClientNum, oldVal, newVal, bNewEnt, bInitialSnap, fieldName, bWasDemoJump )
{
	self endon( "entityshutdown" );
	self util::waittill_dobj( localClientNum );	

	if ( self HasAnimTree() == false )
		self UseAnimTree( #animtree );

	missiles_loaded = newVal;

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
	else if ( newVal == 3 )
	{
		self SetAnimRestart( %o_drone_tank_missile_full_reload, 1.0, 0.0, 1.0 );
	}
	
	if ( missiles_loaded <= ( 3 ) )
		update_ui_ammo_count( localClientNum, missiles_loaded );
}

function update_hud( localClientNum, oldVal, newVal, bNewEnt, bInitialSnap, fieldName, bWasDemoJump ) // self == player
{
	self endon( "disconnect" );

	{wait(.016);};
	
	vehicle = GetPlayerVehicle( self );
	if ( isdefined( vehicle ) )
	{
		self update_ui_model_ammo_count( localClientNum, vehicle clientfield::get( "ai_tank_missile_fire" ) );
	}
}

function update_ui_ammo_count( localClientNum, missiles_loaded ) // self == vehicle
{
	if ( self isLocalClientDriver( localClientNum ) || IsSpectating( localClientNum ) )
	{		
		update_ui_model_ammo_count( localclientnum, missiles_loaded );
	}
}

function update_ui_model_ammo_count( localClientNum, missiles_loaded )
{
	ammo_ui_data_model = GetUIModel( GetUIModelForController( localClientNum ), "vehicle.ammo" );
	
	if ( isdefined( ammo_ui_data_model ) )
		SetUIModelValue( ammo_ui_data_model, missiles_loaded );

	// /# IPrintLnBold( "Missile Count: " + missiles_loaded ); #/
}


function tank_stun( localClientNum, oldVal, newVal, bNewEnt, bInitialSnap, fieldName, bWasDemoJump )
{
	self endon( "entityshutdown" );
	self endon( "death" );
	
	if ( newVal )
	{
		self notify( "light_disable" );

		self stop_stun_fx( localClientNum );
		self start_stun_fx( localClientNum );
	}
	else
	{
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
		self stop_stun_fx( localClientNum );
		self notify( "light_disable" );
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
