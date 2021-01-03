#using scripts\codescripts\struct;

#using scripts\shared\callbacks_shared;
#using scripts\shared\clientfield_shared;
#using scripts\shared\filter_shared;
#using scripts\shared\system_shared;
#using scripts\shared\util_shared;
#using scripts\shared\vehicle_shared;

    	   	                                                                                                                         	                                                                                                                                                                                                                                                                                                                                                                    	        	     	             	    	   	                           	                               	                                	                                                              	                                                                                                              	                            	                                     	                                       	                                                               	   	                  	       	                                                    	                   	                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                       	                                                                                        	           	                        	                                            	                                             	                                                   	                                                             	                                                         	                                                                    	                                                                                                                                                                                                    	                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                     	                                                              	                                                          	                                   	                                   	                                                    	                                       
                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                            	                                                                                                                                                                                                                                                                                                                                                                                       
                 	     

#namespace glaive;

function autoexec main()
{	
	clientfield::register( "vehicle", "glaive_blood_fx", 1, 1, "int", &glaiveBloodFxHandler, !true, !true );
}

function private glaiveBloodFxHandler( localClientNum, oldValue, newValue, bNewEnt, bInitialSnap, fieldName, wasDemoJump )
{	
	if ( IsDefined( self.bloodFxHandle ) )
	{
		StopFX( localClientNum, self.bloodFxHandle );
		self.bloodFxHandle = undefined;
	}
	
	settings = struct::get_script_bundle( "vehiclecustomsettings", "glaivesettings" );
	
	if( IsDefined( settings ) )
	{
		if( newValue )
		{
			self.bloodFxHandle = PlayFXOnTag( localClientNum, settings.weakspotfx, self, "tag_origin" );
		}
	}
}