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
	level thread runStartMusicPackageListener( "playmusicpackage_rooftops", "rooftops" );
	level thread runStartMusicPackageListener( "playmusicpackage_boss_fight", "boss_fight" );
	level thread runStopMusicPackageListener( "endmusicpackage" );
	

}

//Here packages and notifies are declared

music()
{


        
            
            declareMusicPackage( "start", "mus_sie_action_lp", 0, 1.0, 1.0 );
	   //setMusicPackageIntro( "start", "mus_sie_action_intro" );
	   //setMusicPackageOutro( "start", "mus_sie_action_outro" );
	    
	    declareMusicPackage( "rooftops", "mus_sie_climax_lp", 0, 0, 0.5 );
	    //setMusicPackageIntro( "rooftops", "mus_sie_climax_intro" );
	    setMusicPackageOutro( "rooftops", "mus_sie_climax_outro" );
 
 	    declareMusicPackage( "boss_fight", "mus_sie_boss", 1.0, 0, 0 );
          
 
}
 


