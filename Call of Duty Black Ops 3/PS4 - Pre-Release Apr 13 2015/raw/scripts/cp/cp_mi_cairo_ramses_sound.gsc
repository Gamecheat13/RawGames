#using scripts\codescripts\struct;

    	   	                                                                                                                         	                                                                                                                                                                                                                                                                                                                                                                    	        	     	             	    	   	                           	                               	                                	                                                              	                                                                                                              	                            	                                     	                                       	                                                               	   	                  	       	                                                    	                   	                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                       	                                                                                        	           	                        	                                            	                                             	                                                   	                                                             	                                                         	                                                                    	                                                                                                                                                                                                    	                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                     	                                                              	                                                          	                                   	                                   	                                                    	                                       

#using scripts\cp\voice\voice_ramses;

function main()
{
	voice_ramses::init_voice();              // add this
	level thread intro_music();
	level thread station_defend_music();
	level thread station_defend_complete_music();
}
function intro_music()
{
	if(!IsDefined(level.music_ent))
	{
		level.mus_ent = spawn ("script_origin", (0,0,0));
	}
	
//	level waittill ("cin_ram_01_01_enterstation_1st_ride_complete");  this got broken again so i'm putting the notify back in script
	level waittill ("start_music");
	level.mus_ent playloopsound ("mus_ramses_intro");
	
	level waittill ("sndStopIntroMusic");
	
	level.mus_ent stoploopsound (5);
}
function station_defend_music()
{
	if(!IsDefined(level.music_ent))
	{
		level.mus_ent = spawn ("script_origin", (0,0,0));
	}
	
	level waittill ("start_defend_music");
	wait (5);
	level.mus_ent playloopsound ("mus_ramses_station_defend");
	
	level waittill ("end_fight");
	
	level.mus_ent stoploopsound ();
	
	
}
function station_defend_complete_music()
{
	
	
	if(!IsDefined(level.music_ent))
	{
		level.mus_ent = spawn ("script_origin", (0,0,0));
	}
	
	level waittill ("end_fight");
	
	wait(1);
	
	level.mus_ent playloopsound ("mus_ramses_station_complete");
	
	level waittill ("board_jeep");
	
	level.mus_ent stoploopsound ();
	

	
}
