#using scripts\codescripts\struct;
#using scripts\shared\music_shared;
    	   	                                                                                                                         	                                                                                                                                                                                                                                                                                                                                                                    	        	     	             	    	   	                           	                               	                                	                                                              	                                                                                                              	                            	                                     	                                       	                                                               	   	                  	       	                                                    	                   	                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                       	                                                                                        	           	                        	                                            	                                             	                                                   	                                                             	                                                         	                                                                    	                                                                                                                                                                                                    	                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                     	                                                              	                                                          	                                   	                                   	                                                    	                                       

function main()
{
	//************************************************************************************************
	//                                              Ambient Packages
	//************************************************************************************************

	//declare an ambientpackage, and populate it with elements
	//mandatory parameters are <package name>, <alias name>, <spawnMin>, <spawnMax>
	//followed by optional parameters <distMin>, <distMax>, <angleMin>, <angleMax>
	
	
	//************************************************************************************************
	//                                       ROOMS
	//************************************************************************************************

	//explicitly activate the base ambientpackage, which is used when not touching any ambientPackageTriggers
	//the other trigger based packages will be activated automatically when the player is touching them
	//the same pattern is followed for setting up ambientRooms
	
	//************************************************************************************************
	//                                      ACTIVATE DEFAULT AMBIENT SETTINGS
	//************************************************************************************************

	music::declareMusicState("WAVE");
	music::musicAliasloop("mus_theatre_underscore", 4, 2);	
		
	music::declareMusicState("EGG");
	music::musicAlias("mus_egg", 1);
		
	music::declareMusicState("SILENCE");
	music::musicAlias("null", 1 );   
	    
	music::declareMusicState("SILENT");
	music::musicAliasloop("null",0,1);
}
