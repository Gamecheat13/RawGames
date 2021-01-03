#using scripts\codescripts\struct;

#using scripts\shared\clientfield_shared;
#using scripts\shared\system_shared;
#using scripts\shared\util_shared;
#using scripts\shared\visionset_mgr_shared;

    	   	                                                                                                                                         	                                	                                                                                                                                                                                                                                                                                                                                                                    	        	     	             	    	   	               	                                              	                                                           	                               	                     	                                                                                                           	                                                                 	                                                              	                                                                                                              	                            	                                     	                                       	                                                                                                              	   	                  	       	                                                    	                   	                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                        	                                  	                                                                                        	           	                        	                                            	                                             	                                                   	                                                             	                                                         	                                                                    	                                                                                                                                                                                                    	                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                         	                                                              	                                                          	                                   	                                   	                                                    	                                       	                                           	     	                                                                                                                                                                                                                                                      	                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                     
                                                                                                  	  	                          	                                         	                     	                 	                                                                         	                       	                                                      	                                                      	                                                       	                                                                                                  	                                                           	                 	                                                                                                           	                	                                          	                                      	       	  	             	                                                     	                                                                             	                         	                                                                	                                                             	                                                             	                                                                                      	                                                         	                                                         	                                                               	                                                               	                                                   	                                                                	                                                     	                                                	                                                	                                                        	                                                                                                  	                                                                             	                                            	                                                                                    	                                          	                     	                                              	                                        	         	     

                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                            	                           	                           	                                                                                                                                                                                                                                                            	                                                                                                                                                                                                                                                                                                                                                                                       

#namespace helicopter_gunner;

function autoexec __init__sytem__() {     system::register("helicopter_gunner",&__init__,undefined,undefined);    }	

function __init__()
{
	clientfield::register( "vehicle", "vtol_turret_destroyed_0", 1, 1, "int", &turret_destroyed_0, !true, !true );
	clientfield::register( "vehicle", "vtol_turret_destroyed_1", 1, 1, "int", &turret_destroyed_1, !true, !true );
	clientfield::register( "toplayer", "vtol_update_client", 1, 1, "counter", &update_client, !true, !true );
	clientfield::register( "toplayer", "fog_bank_2", 1, 1, "int", &fog_bank_2_callback, !true, !true);
	
	visionset_mgr::register_visionset_info( "mothership_visionset", 1, 1, undefined, "mp_vehicles_mothership" );
}

function turret_destroyed_0( localClientNum, oldVal, newVal, bNewEnt, bInitialSnap, fieldName, bWasDemoJump )
{	
	// /# IPrintLnBold( "Turret Destroyed A: " + newVal ); #/
}

function turret_destroyed_1( localClientNum, oldVal, newVal, bNewEnt, bInitialSnap, fieldName, bWasDemoJump )
{	
	// /# IPrintLnBold( "Turret Destroyed B: " + newVal ); #/
}

function update_turret_destroyed( localClientNum, ui_model_name, new_value )
{
	part_destroyed_ui_model = GetUIModel( GetUIModelForController( localClientNum ), ui_model_name );

	if ( isdefined( part_destroyed_ui_model ) )
		SetUIModelValue( part_destroyed_ui_model, new_value );
	
	// /# IPrintLnBold( ui_model_name + " set to: " + new_value ); #/
}

function update_client( localClientNum, oldVal, newVal, bNewEnt, bInitialSnap, fieldName, bWasDemoJump )
{
	veh = GetPlayerVehicle( self );
	if( isdefined( veh ) )
	{
		update_turret_destroyed( localClientNum, "vehicle.partDestroyed.0", veh clientfield::get( "vtol_turret_destroyed_0" ) );
		update_turret_destroyed( localClientNum, "vehicle.partDestroyed.1", veh clientfield::get( "vtol_turret_destroyed_1" ) );
	}
}

function fog_bank_2_callback(localClientNum, oldVal, newVal, bNewEnt, bInitialSnap, fieldName, bWasDemoJump)
{
	if ( oldVal != newVal )
	{
		if ( newVal == 1 )
		{
		//	SetWorldFogActiveBank( localClientNum, 2 );
		}
		else
		{
		//	SetWorldFogActiveBank( localClientNum, 1 );
		}
	}
}