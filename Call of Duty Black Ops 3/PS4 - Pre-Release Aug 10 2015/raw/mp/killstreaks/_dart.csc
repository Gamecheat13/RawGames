#using scripts\codescripts\struct;

#using scripts\shared\clientfield_shared;
#using scripts\shared\system_shared;
#using scripts\shared\util_shared;
#using scripts\shared\vehicle_shared;
#using scripts\shared\visionset_mgr_shared;

    	   	                                                                                                                                         	                                	                                                                                                                                                                                                                                                                                                                                                                    	        	     	             	    	   	               	                                              	                                                           	                               	                     	                                                                                                           	                                                                 	                                                              	                                                                                                              	                            	                                     	                                       	                                                                                                              	   	                  	       	                                                    	                   	                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                        	                                  	                                                                                        	           	                        	                                            	                                             	                                                   	                                                             	                                                         	                                                                    	                                                                                                                                                                                                    	                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                         	                                                              	                                                          	                                   	                                   	                                                    	                                       	                                           	     	                                                                                                                                                                                                                                                      	                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                     
                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                            	                           	                           	                                                                                                                                                                                                                                                            	                                                                                                                                                                                                                                                                                                                                                                                       
                                                                                                  	  	                          	                                         	                     	                 	                                                                         	                       	                                                      	                                                      	                                                       	                                                                                                  	                                                           	                 	                                                                                                           	                	                                          	                                      	       	  	             	                                                     	                                                                             	                         	                                                                	                                                             	                                                             	                                                                                      	                                                         	                                                         	                                                               	                                                               	                                                   	                                                                	                                                     	                                                	                                                	                                                        	                                                                                                  	                                                                             	                                            	                                                                                    	                                          	                     	                                              	                                        	         	     
#using scripts\shared\visionset_mgr_shared;





#namespace dart;

function autoexec __init__sytem__() {     system::register("dart",&__init__,undefined,undefined);    }	

function __init__()
{	
	clientfield::register( "toplayer", "dart_update_ammo", 1, 2, "int", &update_ammo, !true, !true );
	clientfield::register( "toplayer", "fog_bank_3", 1, 1, "int", &fog_bank_3_callback, !true, !true);
	
	level.dartBundle = struct::get_script_bundle( "killstreak", "killstreak_dart" );
	vehicle::add_vehicletype_callback( level.dartBundle.ksDartVehicle,&spawned );
	visionset_mgr::register_visionset_info( "dart_visionset", 1, 1, undefined, "mp_vehicles_dart" );
	visionset_mgr::register_visionset_info( "sentinel_visionset", 1, 1, undefined, "mp_vehicles_sentinel" );
	visionset_mgr::register_visionset_info( "remote_missile_visionset", 1, 1, undefined, "mp_hellstorm" );
}

function update_ammo( localClientNum, oldVal, newVal, bNewEnt, bInitialSnap, fieldName, bWasDemoJump )
{
	SetUIModelValue( GetUIModel( GetUIModelForController( localClientNum ), "vehicle.ammo" ), newVal );

	// /# IPrintLnBold( "Dart Ammo Count: " + newVal ); #/
}

function spawned(localClientNum)
{
	self.killstreakBundle = level.dartBundle;
}

function fog_bank_3_callback(localClientNum, oldVal, newVal, bNewEnt, bInitialSnap, fieldName, bWasDemoJump)
{
	if ( oldVal != newVal )
	{
		if ( newVal == 1 )
		{
		//	SetWorldFogActiveBank( localClientNum, 3 );
		}
		else
		{
		//	SetWorldFogActiveBank( localClientNum, 1 );
		}
	}
}