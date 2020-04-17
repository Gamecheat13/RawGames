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
	level thread runStartMusicPackageListener( "playmusicpackage_action1", "action1" );
	level thread runStartMusicPackageListener( "playmusicpackage_action2", "action2" );
	level thread runStartMusicPackageListener( "playmusicpackage_bliss", "bliss" );
	level thread runStartMusicPackageListener( "playmusicpacakge_decouple", "decouple" );
	level thread runStopMusicPackageListener( "endmusicpackage" );
	
}

//Here packages and notifies are declared

music()
{


        
	
	    declareMusicPackage( "ambient", "mus_tra_ambient_lp", 8.5, 1, 1 );
	    setMusicPackageIntro( "ambient", "mus_tra_ambient_intro" );

            declareMusicPackage( "action1", "mus_tra_action1_lp", 2.5, .2, .5 );
            setMusicPackageIntro( "action1", "mus_tra_action1_intro" );
            setMusicPackageOutro( "action1", "gameplay_stinger1" );
            
            declareMusicPackage( "action2", "mus_tra_action2_lp", 0, 0, 4 );
	 
            declareMusicPackage( "bliss",  "mus_tra_bliss_lp", 3.2, .5, .5 );
            setMusicPackageIntro( "bliss", "mus_tra_bliss_Intro" );
            setMusicPackageOutro( "bliss", "mus_tra_bliss_outro" );
            
            declareMusicPackage( "decouple",  "mus_tra_decouple_lp", 3, .25, .5 );
	    setMusicPackageIntro( "decouple", "mus_tra_decouple_intro" );
            setMusicPackageOutro( "decouple", "gameplay_stinger2" );
            
 
}
 





