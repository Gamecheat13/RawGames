#using scripts\codescripts\struct;

#using scripts\shared\array_shared;
#using scripts\shared\callbacks_shared;
#using scripts\shared\system_shared;

    	   	                                                                                                                         	                                                                                                                                                                                                                                                                                                                                                                    	        	     	             	    	   	                           	                               	                                	                                                              	                                                                                                              	                            	                                     	                                       	                                                               	   	                  	       	                                                    	                   	                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                        	                                                                                        	           	                        	                                            	                                             	                                                   	                                                             	                                                         	                                                                    	                                                                                                                                                                                                    	                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                      	                                                              	                                                          	                                   	                                   	                                                    	                                       

#using scripts\shared\util_shared;

#namespace multi_extracam;

function extracam_reset_index( index )
{
	if( !isdefined(level.camera_ents) )
	{
		return;
	}

	if( isdefined( level.camera_ents[index] ) )
	{
		level.camera_ents[index] ClearExtraCam();
		level.camera_ents[index] Delete();
		level.camera_ents[index] = undefined;
	}
}

function extracam_init_index( localClientNum, target, index )
{
	if( !isdefined(level.camera_ents) )
	{
		level.camera_ents = [];
	}

	if( isdefined( level.camera_ents[index] ) )
	{
		level.camera_ents[index] ClearExtraCam();
		level.camera_ents[index] Delete();
		level.camera_ents[index] = undefined;
	}

	cameraStruct = struct::get( target, "targetname" );
	if ( isdefined( cameraStruct ) )
	{
		level.camera_ents[index] = Spawn( localClientNum, cameraStruct.origin, "script_origin" );
		level.camera_ents[index].angles = cameraStruct.angles;

		level.camera_ents[index] SetExtraCam( index );
	}
}

