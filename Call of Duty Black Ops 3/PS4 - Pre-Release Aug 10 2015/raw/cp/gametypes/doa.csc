#using scripts\codescripts\struct;
#using scripts\shared\system_shared;

    	   	                                                                                                                                         	                                	                                                                                                                                                                                                                                                                                                                                                                    	        	     	             	    	   	               	                                              	                                                           	                               	                     	                                                                                                           	                                                                 	                                                              	                                                                                                              	                            	                                     	                                       	                                                                                                              	   	                  	       	                                                    	                   	                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                        	                                  	                                                                                        	           	                        	                                            	                                             	                                                   	                                                             	                                                         	                                                                    	                                                                                                                                                                                                    	                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                         	                                                              	                                                          	                                   	                                   	                                                    	                                       	                                           	     	                                                                                                                                                                                                                                                      	                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                     

function main()
{
}

function onPrecacheGameType()
{
}

function onStartGameType()
{	
}

function autoexec ignore_systems()
{
    //shutdown unwanted systems - doing it in an autoexec is the only clean way to do it
    system::ignore("cybercom");
    system::ignore("healthoverlay");
    system::ignore("challenges");
    system::ignore("rank");
    system::ignore("hacker_tool");
    system::ignore("grapple");
    system::ignore("replay_gun");
    system::ignore("riotshield");
    system::ignore("oed");
    system::ignore("explosive_bolt");
    system::ignore("empgrenade");
	system::ignore("spawning");	
	system::ignore("save");	
}

