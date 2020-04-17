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

	level thread runStartMusicPackageListener( "playmusicpackage_ambient", "ambient" );
	level thread runStartMusicPackageListener( "playmusicpackage_house", "house" );
	level thread runStartMusicPackageListener( "playmusicpackage_house_quiet", "house_quiet" );
	level thread runStartMusicPackageListener( "playmusicpackage_stealth", "stealth" );
	level thread runStartMusicPackageListener( "playmusicpackage_boatyard", "boatyard" );
	level thread runStopMusicPackageListener( "endmusicpackage" );
	
}

//Here packages and notifies are declared

music()
{


        
	
	    declareMusicPackage( "ambient", "mus_get_ambient_lp", 0, 2, 1 );
	    setMusicPackageCombatAlias( "ambient", 1, 0, "mus_get_action1_lp", 1, .3, 1.2 );
	    setMusicPackageCombatIntro( "ambient", "mus_get_action1_intro" );
            setMusicPackageCombatOutro( "ambient", "mus_get_action1_outro" );
            
            declareMusicPackage( "stealth", "mus_get_stealth_lp", 0, .2, 2.5 );
            
           
            declareMusicPackage( "boatyard", "mus_get_action2_lp", 2.5, .2, .1 );
	    setMusicPackageIntro( "boatyard", "mus_get_action2_intro" );
            setMusicPackageOutro( "boatyard", "mus_get_action2_outro" );
            
            declareMusicPackage( "house", "mus_get_house_lp", 5.5, .7, 0 );
            setMusicPackageIntro( "house", "mus_get_house_intro" );
            setMusicPackageOutro( "house", "mus_get_house_outro" );
            
            declareMusicPackage( "house_quiet", "mus_get_house2_lp", 0, 1.8, 0 );
 
}
 





