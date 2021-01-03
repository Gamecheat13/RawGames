#using scripts\codescripts\struct;
#using scripts\cp\voice\voice_vengeance;

    	   	                                                                                                                         	                                                                                                                                                                                                                                                                                                                                                                    	        	     	             	    	   	                           	                               	                                	                                                              	                                                                                                              	                            	                                     	                                       	                                                               	   	                  	       	                                                    	                   	                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                       	                                                                                        	           	                        	                                            	                                             	                                                   	                                                             	                                                         	                                                                    	                                                                                                                                                                                                    	                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                     	                                                              	                                                          	                                   	                                   	                                                    	                                       

function main()
{
	//level thread temp_stealth_music();
	voice_vengeance::init_voice();
}

function temp_stealth_music()
{
	wait(2);
	
	if(!IsDefined(level.temp_music_ent))
	{
		level.temp_music_ent = spawn ("script_origin", (0,0,0));
	}
	
	level.temp_music_ent playloopsound ("mus_stealth_temp");		
}
