#using scripts\codescripts\struct;
#using scripts\shared\audio_shared;
    	   	                                                                                                                         	                                                                                                                                                                                                                                                                                                                                                                    	        	     	             	    	   	                           	                               	                                	                                                              	                                                                                                              	                            	                                     	                                       	                                                               	   	                  	       	                                                    	                   	                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                        	                                                                                        	           	                        	                                            	                                             	                                                   	                                                             	                                                         	                                                                    	                                                                                                                                                                                                    	                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                      	                                                              	                                                          	                                   	                                   	                                                    	                                       

function main()
{
	level thread snd_dmg_monk();
	level thread snd_dmg_cheet();
	level thread snd_dmg_boar();
}	

function snd_dmg_monk()
{
	trigger = getent("snd_monkey", "targetname" );
    if (!isdefined (trigger))
    {
    	return;
    }
    while(1)
    {
        trigger waittill( "trigger", who );
        if( isplayer(who) )
        {
        	trigger playsound ("amb_monkey_shot");
        	wait (15);
        }
    }	
}
function snd_dmg_cheet()
{
	trigger = getent("snd_cheet", "targetname" );
    if (!isdefined (trigger))
    {
    	return;
    }
    while(1)
    {
        trigger waittill( "trigger", who );
        if( isplayer(who) )
        {
        	trigger playsound ("amb_cheeta_shot");
        	wait (15);
        }
    }	
}
function snd_dmg_boar()
{
	trigger = getent("snd_boar", "targetname" );
    if (!isdefined (trigger))
    {
    	return;
    }
    while(1)
    {
        trigger waittill( "trigger", who );
        if( isplayer(who) )
        {
        	trigger playsound ("amb_boar_shot");
        	wait (15);
        }
    }	
}
