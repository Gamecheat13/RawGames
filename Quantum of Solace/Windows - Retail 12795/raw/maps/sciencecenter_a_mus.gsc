/*------------------------------------------------------------------------------------------------------------------
Our music is organized into music packages for scripting.  Each MusicPackage consists of a looping music alias
and optional stingers for intro, outro, and crossfading.  The stingers are one shot sounds that are loaded into ram.
The loops are streamed sounds.  Each package (loop) has a wait, fade in and fade out specified.  Stingers cannot have waits or fades in 
script.

Below is an example of how to declare a package:
	   
	    function:		     package:		   alias:	  delay, fadin, fadeout:
	   
	    declareMusicPackage( "package_name", "soundalias", 1, 1, 5 );
            setMusicPackageIntro( "package_name", "soundalias" );
	    setMusicPackageCrossfade( "package_name", "soundalias" );
            setMusicPackageOutro( "package_name", "soundalias" );
            
-------------------------------------------------------------------------------------------------------------------*/

#include maps\_utility;
#include maps\_music;


/*-------------------------------------------------------------------------------------------------

These are functions that set up a listener for a level notify (placed by the scripter in their gsc):

To start a music package from a notify:
level thread runStartMusicPackageListener( "notify_name", "package_name" );

To stop music from a notify:
level thread runStopMusicPackageListener( "notify_name" );

--------------------------------------------------------------------------------------------------*/

main()
{
	music();

	level thread runStartMusicPackageListener( "playmusicpackage_sniper1", "sniper1" );
	level thread runStartMusicPackageListener( "playmusicpackage_sniper2", "sniper2" );
	level thread runStartMusicPackageListener( "playmusicpackage_alley", "alley" );
	level thread runStartMusicPackageListener( "playmusicpackage_ledge", "ledge" );
	level thread runStartMusicPackageListener( "playmusicpackage_backlot", "backlot" );
	level thread runStartMusicPackageListener( "playmusicpackage_roof", "roof" );
	level thread runStartMusicPackageListener( "playmusicpackage_helicopter", "helicopter" );
	level thread runStopMusicPackageListener( "endmusicpackage" );

	thread musicstinger_start();	
}

//Here packages and notifies are declared

music()
{


        
            declareMusicPackage( "sniper1", "mus_sca_sniper1_lp", 0, 2, 2 );
       
	    declareMusicPackage( "sniper2", "mus_sca_sniper2_lp", 4, .5, 1.2 );
            setMusicPackageIntro( "sniper2", "mus_sca_sniper2_intro" );
            setMusicPackageOutro( "sniper2", "mus_sca_sniper2_outro" );
	    
	    declareMusicPackage( "alley", "mus_sca_stealth_lp", 2.5, 2, 2 );
	    setMusicPackageCombatAlias( "alley", 1, 0, "mus_sca_action_lp", 4, .5, 0);
	    setMusicPackageCombatIntro( "alley", "mus_sca_action_intro" );
            setMusicPackageCombatOutro( "alley", "mus_sca_action_outro" );
           
            declareMusicPackage( "backlot", "mus_sca_backlot_lp", 1, .2, 1.2 );
            setMusicPackageIntro( "backlot",  "mus_sca_backlot_intro" );
            setMusicPackageOutro( "backlot",  "mus_sca_backlot_outro" );
            
            declareMusicPackage( "ledge", "mus_sca_stealth_lp", 0, 2, 2 );
            
            declareMusicPackage( "roof", "mus_sca_roof_lp", 4, .5, 1.2 );
            setMusicPackageIntro( "roof", "mus_sca_roof_intro" );
         
            declareMusicPackage( "helicopter", "mus_sca_helicopter_lp", 6, .3, 1.2 );
            setMusicPackageIntro( "helicopter",  "mus_sca_helicopter_intro" );
            setMusicPackageOutro( "helicopter", "mus_sca_helicopter_outro" );
            
          
 
}
 

//This is used for one-off stingers, using playsound.  Here we are waiting for the specified notify to be sent, before
//playing the stinger.

musicstinger_start()
{

            for ( ;; )

            {

                        level waittill( "musicstinger_rope" );

                        level.player playsound ("mus_scb_rope_stinger");

            }


}

