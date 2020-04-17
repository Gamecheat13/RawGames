/*------------------------------------------------------------------------
Music:

Our music is organized into music packages for scripting.  Each MusicPackage consists of a looping music alias
and optional stingers for intro, outro, and crossfading.  The stingers are one shot sounds that are loaded into ram.
The loops are streamed sounds.  Each package (loop) has a wait, fade in and fade out specified.  Stingers cannot have waits or fades in 
script.

Below is an example of how to declare a package:
	   
	    function:		     package:		   alias:	  wait, fadin, fadeout:
	   
	    declareMusicPackage( "package_name", "soundalias", 1, 1, 5 );
            setMusicPackageIntro( "package_name", "soundalias" );
	    setMusicPackageCrossfade( "package_name", "soundalias" );
            setMusicPackageOutro( "package_name", "soundalias" );
------------------------------------------------------------------------*/
#include maps\_utility;
#include maps\_music;


/*-------------------------------------------------------------------------------------------------

These are functions that set up a listener for a level notify (placed by the scripter in their gsc):

To start a music package from a notify:
level thread runStartMusicPackageListener( "notify_name", "package_name" );

To stop music from a notify:
level thread runStopMusicPackageListener( "notify_name" );

--------------------------------------------------------------------------------------------------*/main()


{
	music();

	level thread runStartMusicPackageListener( "playmusicpackage_start", "start" );
	level thread runStartMusicPackageListener( "playmusicpackage_stealth", "stealth" );
	level thread runStartMusicPackageListener( "playmusicpackage_spa", "spa" );
	level thread runStartMusicPackageListener( "playmusicpackage_ballroom", "ballroom" );
	level thread runStartMusicPackageListener( "playmusicpackage_boss", "boss" );
	level thread runStopMusicPackageListener( "endmusicpackage" );
	//This is currently stopping stealth music, but I may eventually switch to a combat cue
	level thread runStopMusicPackageListener( "playmusicpackage_combat" );

	thread musicstinger_start();	
}


//Here packages and notifies are declared

music()
{


        
            declareMusicPackage( "start", "mus_cas_stealth_lp", 0, 2, 2 );
            setMusicPackageCombatAlias( "start", 2, 0, "mus_cas_stealth_com_lp", 0, 2, 2 );
	
	    declareMusicPackage( "stealth", "mus_cas_stealth_lp", 0, 2, 2 );
	    setMusicPackageCombatAlias( "stealth", 2, 0, "mus_cas_stealth_com_lp", 0, 2, 2 );

            declareMusicPackage( "spa", "mus_cas_spa_lp", 0, 2, 1.2 );
            setMusicPackageIntro( "spa", "mus_cas_spa_intro" );
            setMusicPackageOutro( "spa", "mus_cas_spa_outro" );

            declareMusicPackage( "ballroom", "mus_cas_ballroom_lp", 0, 3, 1.2 );
            setMusicPackageIntro( "ballroom", "mus_cas_ballroom_intro" );
            setMusicPackageOutro( "ballroom", "mus_cas_ballroom_outro" );
            
            declareMusicPackage( "boss", "mus_cas_boss", 0, 0, 0 );
	   
}
 

//This is used for one-off stingers, using playsound.  Here we are waiting for the specified notify to be sent, before
//playing the stinger.

musicstinger_start()
{

            for ( ;; )

            {

                        level waittill( "musicstinger_start" );

                        level.player playsound ("intro_stinger");

            }


}
