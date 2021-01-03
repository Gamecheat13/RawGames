#using scripts\codescripts\struct;
#using scripts\cp\voice\voice_aquifer;
    	   	                                                                                                                         	                                                                                                                                                                                                                                                                                                                                                                    	        	     	             	    	   	                           	                               	                                	                                                              	                                                                                                              	                            	                                     	                                       	                                                               	   	                  	       	                                                    	                   	                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                       	                                                                                        	           	                        	                                            	                                             	                                                   	                                                             	                                                         	                                                                    	                                                                                                                                                                                                    	                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                     	                                                              	                                                          	                                   	                                   	                                                    	                                       

function main()
{
	//level thread test_music_loop();
	voice_aquifer::init_voice();
}

//testing music loop
function test_music_loop()
{
	//self endon( "death" );
	
	if(!IsDefined(level.music_ent))
	{
		level.mus_ent = spawn ("script_origin", (0,0,0));
	}
	
	wait( 0.5 );
	level.mus_ent playloopsound ("mus_aquifer_test_loop");
	
	level waittill ("death");
	
	level.mus_ent stoploopsound ();
	
}
