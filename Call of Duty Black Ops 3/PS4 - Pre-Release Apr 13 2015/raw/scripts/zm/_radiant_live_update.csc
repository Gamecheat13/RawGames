#using scripts\codescripts\struct;

#using scripts\shared\system_shared;

    	   	                                                                                                                         	                                                                                                                                                                                                                                                                                                                                                                    	        	     	             	    	   	                           	                               	                                	                                                              	                                                                                                              	                            	                                     	                                       	                                                               	   	                  	       	                                                    	                   	                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                       	                                                                                        	           	                        	                                            	                                             	                                                   	                                                             	                                                         	                                                                    	                                                                                                                                                                                                    	                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                     	                                                              	                                                          	                                   	                                   	                                                    	                                       

/* ---------------------------------------------------------------------------------
This script handles player radiant live update commands
-----------------------------------------------------------------------------------*/

#namespace radiant_live_udpate;

/#
function autoexec __init__sytem__() {     system::register("radiant_live_udpate",&__init__,undefined,undefined);    }

function __init__()
{
	thread scriptstruct_debug_render();
}

function scriptstruct_debug_render()
{
	while( 1 )
	{
		level waittill( "liveupdate", selected_struct );
		
		if( isdefined(selected_struct) )
		{
			level thread render_struct( selected_struct );
		}
		else
		{
			level notify( "stop_struct_render" );
		}
	}
}

function render_struct( selected_struct )
{
	self endon( "stop_struct_render" );
	
	while( isdefined( selected_struct ) )
	{
		Box( selected_struct.origin, (-16, -16, -16), (16, 16, 16), 0, (1, 0.4, 0.4) );
		wait 0.01;
	}
}

#/