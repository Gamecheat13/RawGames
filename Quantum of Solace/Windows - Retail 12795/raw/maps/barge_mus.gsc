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

	level thread runStartMusicPackageListener( "playmusicpackage_stealth", "stealth" );
	level thread runStartMusicPackageListener( "playmusicpackage_action", "action" );
	level thread runStartMusicPackageListener( "playmusicpackage_action2", "action2" );
	level thread runStartMusicPackageListener( "playmusicpackage_sniper", "sniper" );
	level thread runStartMusicPackageListener( "playmusicpackage_postsniper", "postsniper" );
	level thread runStartMusicPackageListener( "playmusicpackage_climax", "climax" );
	level thread runStopMusicPackageListener( "endmusicpackage" );
	
}

//Here packages and notifies are declared

music()
{


        
	
	    declareMusicPackage( "stealth", "mus_bar_stealth_lp", 0, 1, 2 );
            setMusicPackageCombatAlias( "stealth", 3, 1, "mus_bar_stealth_com_lp", 0, 2, 2 );
           
            declareMusicPackage( "action", "mus_bar_action_lp", 0, .5, 2 );
            //setMusicPackageIntro( "action", "mus_bar_action_intro" );
            
            declareMusicPackage( "action2", "mus_bar_action2_lp", 1.5, .5, 2 );
            setMusicPackageIntro( "action2", "mus_bar_action2_intro" );
           
            declareMusicPackage( "sniper", "mus_bar_sniper_lp", 0, 2, 1.5 );
            
            declareMusicPackage( "postsniper", "mus_bar_postsniper_lp", 3.0, 2, .5 );
            setMusicPackageIntro( "postsniper", "mus_bar_postsniper_Intro" );
	 
            declareMusicPackage( "climax",  "mus_bar_climax_lp", 1.7, .01, .5 );
            setMusicPackageIntro( "climax", "mus_bar_climax_Intro" );
            setMusicPackageOutro( "climax", "mus_bar_climax_outro" );
           
            
 
}
 





