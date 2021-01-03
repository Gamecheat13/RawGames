#using scripts\codescripts\struct;

#using scripts\shared\array_shared;
#using scripts\shared\callbacks_shared;
#using scripts\shared\system_shared;

    	   	                                                                                                                         	                                                                                                                                                                                                                                                                                                                                                                    	        	     	             	    	   	                           	                               	                                	                                                              	                                                                                                              	                            	                                     	                                       	                                                               	   	                  	       	                                                    	                   	                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                        	                                                                                        	           	                        	                                            	                                             	                                                   	                                                             	                                                         	                                                                    	                                                                                                                                                                                                    	                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                      	                                                              	                                                          	                                   	                                   	                                                    	                                       

#using scripts\shared\util_shared;



#namespace multi_extracam;

function autoexec __init__sytem__() {     system::register("multi_extracam",&__init__,undefined,undefined);    }

function __init__( localClientNum )
{
	callback::on_localclient_connect( &multi_extracam_init );
}

function multi_extracam_init( localClientNum )
{
	triggers = GetEntArray( localClientNum, "multicam_enable", "targetname" );

	for( i=1 ; i<=4 ; i++ )
	{
		cameraStruct = struct::get( "extracam" + i, "targetname" );
		if ( isdefined( cameraStruct ) )
		{
			camera_ent = Spawn( localClientNum, cameraStruct.origin, "script_origin" );
			camera_ent.angles = cameraStruct.angles;

			camera_ent SetExtraCam( i-1 );
		}
	}	
}