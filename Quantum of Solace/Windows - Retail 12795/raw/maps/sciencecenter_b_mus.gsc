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

	level thread runStartMusicPackageListener( "playmusicpackage_start", "start" );
	level thread runStartMusicPackageListener( "playmusicpackage_stealth", "stealth" );
	level thread runStartMusicPackageListener( "playmusicpackage_catwalk", "catwalk" );
	level thread runStartMusicPackageListener( "playmusicpackage_hall", "hall" );
	level thread runStopMusicPackageListener( "endmusicpackage" );

}

//Here packages and notifies are declared

music()
{


        
            declareMusicPackage( "start", "mus_scb_stealth_lp", 0, 2, 2 );
            setMusicPackageCombatAlias( "start", 2, 0, "mus_scb_stealth_com_lp", 0, 2, 2 );
	
	    declareMusicPackage( "stealth", "mus_scb_stealth_lp", 0, 2, 1 );
	    setMusicPackageCombatAlias( "stealth", 2, 0, "mus_scb_stealth_com_lp", 0, 1, 1 );

            declareMusicPackage( "catwalk", "mus_scb_catwalk_lp", 1, .2, 1.2 );
            setMusicPackageOutro( "catwalk", "mus_scb_catwalk_outro" );
            
            declareMusicPackage( "hall", "mus_scb_hall_lp", 1, .5, .5 );
            setMusicPackageIntro( "hall", "mus_scb_hall_intro" );
            setMusicPackageOutro( "hall", "mus_scb_hall_outro" );
           
 
}
 
