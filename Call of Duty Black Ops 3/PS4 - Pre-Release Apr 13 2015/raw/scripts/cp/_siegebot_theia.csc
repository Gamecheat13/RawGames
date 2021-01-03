#using scripts\codescripts\struct;

#using scripts\shared\clientfield_shared;
#using scripts\shared\filter_shared;
#using scripts\shared\system_shared;
#using scripts\shared\util_shared;
#using scripts\shared\vehicle_shared;

    	   	                                                                                                                         	                                                                                                                                                                                                                                                                                                                                                                    	        	     	             	    	   	                           	                               	                                	                                                              	                                                                                                              	                            	                                     	                                       	                                                               	   	                  	       	                                                    	                   	                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                       	                                                                                        	           	                        	                                            	                                             	                                                   	                                                             	                                                         	                                                                    	                                                                                                                                                                                                    	                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                     	                                                              	                                                          	                                   	                                   	                                                    	                                       
                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                            	                                                                                                                                                                                                                                                                                                                                                                                       

#namespace siegebot_theia;

function autoexec __init__sytem__() {     system::register("siegebot_theia",&__init__,undefined,undefined);    }

function __init__()
{
	vehicle::add_vehicletype_callback( "siegebot_theia", &_setup_ );

	clientfield::register( "vehicle", "sarah_rumble_on_landing", 1, 1, "counter", &sarah_rumble_on_landing, !true, !true ); 
	clientfield::register( "vehicle", "sarah_minigun_spin", 1, 1, "int", &sarah_minigun_spin, !true, !true ); 
}

function _setup_( localClientNum )
{
}

//Rumble and quake when sarah jumps and lands
function sarah_rumble_on_landing( localClientNum, oldVal, newVal, bNewEnt, bInitialSnap, fieldName, bWasDemoJump )
{
	self PlayRumbleOnEntity(localClientNum, "cp_infection_sarah_battle_land" );
}

function sarah_minigun_spin( localClientNum, oldVal, newVal, bNewEnt, bInitialSnap, fieldName, bWasDemoJump )
{
	if( !isdefined( self.scriptbundlesettings ) )
	{
		return;
	}

	settings = struct::get_script_bundle( "vehiclecustomsettings", self.scriptbundlesettings );

	if ( !isdefined( settings ) || !isdefined( settings.lightgroups_numGroups ) )
	{
		return;
	}

	if ( isdefined( self.minigun_spin_fx_handle ) )
	{
		DeleteFX( localClientNum, self.minigun_spin_fx_handle );
	}

	if ( newVal )
	{
		self.minigun_spin_fx_handle = PlayFXOnTag( localClientNum, settings.fx_spin, self, settings.tag_spin );
	}
}