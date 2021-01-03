#using scripts\codescripts\struct;
#using scripts\shared\audio_shared;
    	   	                                                                                                                         	                                                                                                                                                                                                                                                                                                                                                                    	        	     	             	    	   	                           	                               	                                	                                                              	                                                                                                              	                            	                                     	                                       	                                                               	   	                  	       	                                                    	                   	                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                       	                                                                                        	           	                        	                                            	                                             	                                                   	                                                             	                                                         	                                                                    	                                                                                                                                                                                                    	                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                     	                                                              	                                                          	                                   	                                   	                                                    	                                       
#using scripts\shared\array_shared;

function main()
{
	level thread church_bells();
}
function church_bells()
{
	trigger = getent(0, "bells", "targetname" );
    if (!isdefined (trigger))
    {
    	return;
    }
    while(1)
    {
        trigger waittill( "trigger", who );
        if( who isplayer() )
        {
            playsound( 0, "amb_church_bell", (-47231, 3435, 1024));
            break;
        }
    }	
}
