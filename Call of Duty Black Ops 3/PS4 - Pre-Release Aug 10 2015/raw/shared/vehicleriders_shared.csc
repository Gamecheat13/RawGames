#using scripts\codescripts\struct;

#using scripts\shared\animation_shared;
#using scripts\shared\array_shared;
#using scripts\shared\clientfield_shared;
#using scripts\shared\flag_shared;
#using scripts\shared\flagsys_shared;
#using scripts\shared\system_shared;
#using scripts\shared\trigger_shared;
#using scripts\shared\util_shared;

    	   	                                                                                                                                         	                                	                                                                                                                                                                                                                                                                                                                                                                    	        	     	             	    	   	               	                                              	                                                           	                               	                     	                                                                                                           	                                                                 	                                                              	                                                                                                              	                            	                                     	                                       	                                                                                                              	   	                  	       	                                                    	                   	                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                        	                                  	                                                                                        	           	                        	                                            	                                             	                                                   	                                                             	                                                         	                                                                    	                                                                                                                                                                                                    	                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                         	                                                              	                                                          	                                   	                                   	                                                    	                                       	                                           	     	                                                                                                                                                                                                                                                      	                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                     
                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                            	                           	                           	                                                                                                                                                                                                                                                            	                                                                                                                                                                                                                                                                                                                                                                                       

#using_animtree( "generic" );

#namespace vehicle;

function autoexec __init__sytem__() {     system::register("vehicleriders",&__init__,undefined,undefined);    }

function __init__()
{
	a_registered_fields = [];
	foreach ( bundle in struct::get_script_bundles( "vehicleriders" ) )
	{
		foreach ( object in bundle.objects )
		{
			if ( IsString( object.VehicleEnterAnim ) )
			{
				array::add( a_registered_fields, object.position + "_enter", false );
			}
			
			if ( IsString( object.VehicleExitAnim ) )
			{
				array::add( a_registered_fields, object.position + "_exit", false );
			}
		}
	}
	
	foreach ( str_clientfield in a_registered_fields )
	{
		clientfield::register( "vehicle", str_clientfield, 1, 1, "counter", &play_vehicle_anim, !true, !true );
	}
}

function play_vehicle_anim( localClientNum, oldVal, newVal, bNewEnt, bInitialSnap, fieldName, bWasDemoJump ) // self = vehicle
{
	s_bundle = struct::get_script_bundle( "vehicleriders", self.vehicleridersbundle );
	
	str_pos = "";
	str_action = "";
	
	if ( StrEndsWith( fieldName, "_enter" ) )
	{
		str_pos = GetSubStr( fieldName, 0, fieldName.size - 6 );
		str_action = "enter";
	}
	else if ( StrEndsWith( fieldName, "_exit" ) )
	{
		str_pos = GetSubStr( fieldName, 0, fieldName.size - 5 );
		str_action = "exit";
	}
	
	str_vh_anim = undefined;
	foreach ( s_rider in s_bundle.objects )
	{
		if ( s_rider.position == str_pos )
		{
			switch ( str_action )
			{
				case "enter":
					
					str_vh_anim = s_rider.VehicleEnterAnim;
					break;
					
				case "exit":
					
					str_vh_anim = s_rider.VehicleExitAnim;
					break;
			}
			
			break;
		}
	}
	
	if ( isdefined( str_vh_anim ) )
	{
		self SetAnimRestart( str_vh_anim );
	}
}

function set_vehicleriders_bundle( str_bundlename )
{
	self.vehicleriders = struct::get_script_bundle( "vehicleriders", str_bundlename );
}
