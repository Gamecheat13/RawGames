#using scripts\codescripts\struct;
#using scripts\shared\audio_shared;
    	   	                                                                                                                         	                                                                                                                                                                                                                                                                                                                                                                    	        	     	             	    	   	                           	                               	                                	                                                              	                                                                                                              	                            	                                     	                                       	                                                               	   	                  	       	                                                    	                   	                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                       	                                                                                        	           	                        	                                            	                                             	                                                   	                                                             	                                                         	                                                                    	                                                                                                                                                                                                    	                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                     	                                                              	                                                          	                                   	                                   	                                                    	                                       
#using scripts\shared\array_shared;



function main()
{
	level thread hornSndTrigger();
	level thread defibSndTrigger();
	//level thread sndPAannouncer();
	level thread post_interview_weapon_snapshot();
	level thread vital_snd();
	level thread sndPlayRandomExplosions_vtol_ride_start();
	level thread sndLevelFadeout();
}

function hornSndTrigger()
{
    trigger = getent(0, "subway_horn", "targetname" );
    if (!isdefined (trigger))
    {
    	return;
    }
    while(1)
    {
        trigger waittill( "trigger", who );
        if( who isplayer() )
        {
            playsound( 0, "amb_subway_horn", (7608, 1158, -415) );
            break;
        }
    }
}
function defibSndTrigger()
{
    trigger = getent(0, "defibrillator", "targetname" );
     if (!isdefined (trigger))
    {
    	return;
    }
    
    while(1)
    {
        trigger waittill( "trigger", who );
        if( who isplayer() )
        {
            playsound( 0, "amb_defibrillator", (7443, -1682, 74) );
            break;
        }
    }
}

function sndPAannouncer()
{
	level endon( "hosp_amb" );
    
    while(1)
    {
        playsound ( 0, "amb_hospital_pa", (7068, -1791, 548) );
        wait (randomintrange(30, 46));
	}
}
function post_interview_weapon_snapshot()
{
	level waittill ("inv");
	//audio::snd_set_snapshot( "cmn_3p_weapon_occ" ); //C.Ayers - Right now, we don't need this, as the demo goes straight into the door kick. Reinstate this stuff once we have real progression
	audio::snd_set_snapshot( "cp_ramses_raps_intro" );
	
	level waittill ("dro");
	audio::snd_set_snapshot( "default" );
	
}
function vital_snd()
{
	if(!IsDefined (level.snd_hrt))
	{
		level.snd_hrt = spawn (0, (6610, -2082, 66), "script.origin");
	}
	level waittill ("vital_sign"); //from notetrack ch_ram_02_04_walk_1st_introduce_02_rachel
	level.snd_hrt PlayLoopSound ( "amb_heart_monitor_lp" );
	
	level waittill ("hosp_amb"); // attack happens
	level.snd_hrt stoploopsound(0.25);
	wait (1);
	level.snd_hrt delete();
	
}
function sndPlayRandomExplosions_vtol_ride_start()
{
	level endon ("ride_vtol");
	
    spot1 = (10198,-9557,755);
    spot2 = (6406,-9437,894);
    spot3 = (4810,-8798,833);
    spot4 = (2412,-7377,859);
    spot5 = (28,-6302,777);
    spot6 = (-257,-3146,658);
    spot7 = (334,-300, 620);
    
    spots = array(spot1,spot2,spot3,spot4,spot5,spot6,spot7);
    
    level waittill ("hosp_amb");
    while(1)
    {
        spot = array::random(spots);
        playsound(0, "exp_dist_heavy", spot );
        wait(randomintrange(3,6));
    }
}
function sndLevelFadeout()
{
	level waittill( "sndLevelEnd" );
	audio::snd_set_snapshot( "cmn_level_fadeout" );
}
 