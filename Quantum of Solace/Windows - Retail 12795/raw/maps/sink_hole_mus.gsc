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
	
	level thread runStartMusicPackageListener( "playmusicpackage_action", "action" );
	level thread runStartMusicPackageListener( "playmusicpackage_sniper", "sniper" );
	level thread runStartMusicPackageListener( "playmusicpackage_climax", "climax" );
	level thread runStartMusicPackageListener( "playmusicpackage_helicopter", "helicopter" );
	level thread runStartMusicPackageListener( "playmusicpackage_ending", "ending" );
	level thread runStopMusicPackageListener( "endmusicpackage" );
	
}

//Here packages and notifies are declared

music()
{

        
           
            declareMusicPackage( "sniper", "mus_sin_sniper_lp", 1.5, 3, 2.5 );
	 
            declareMusicPackage( "climax",  "mus_sin_climax_lp", 9, .5, 3 );
            setMusicPackageIntro( "climax", "mus_sin_climax_Intro" );
            //setMusicPackageOutro( "climax", "mus_sin_climax_Outro" );
           
           declareMusicPackage( "action",  "mus_sin_action_lp", 0, .7, 10 );
           //setMusicPackageOutro( "action", "mus_sin_action_Outro" );
           
            declareMusicPackage( "helicopter",  "mus_sin_helicopter_lp", 3.0, .2, .5 );
	    setMusicPackageIntro( "helicopter", "mus_sin_climax_intro" );
            setMusicPackageOutro( "helicopter", "mus_sin_climax_outro" );
            
            declareMusicPackage( "ending", "mus_sin_stealth_lp", 5, 2.5, 1.5 );
            
 
}
 





