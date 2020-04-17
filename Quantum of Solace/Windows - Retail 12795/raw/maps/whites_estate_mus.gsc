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
	level thread runStartMusicPackageListener( "playmusicpackage_greenhouse", "greenhouse" );
	level thread runStartMusicPackageListener( "playmusicpackage_boathouse", "boathouse" );
	level thread runStartMusicPackageListener( "playmusicpackage_house", "house" );
	level thread runStartMusicPackageListener( "playmusicpackage_cellar", "cellar" );
	level thread runStopMusicPackageListener( "endmusicpackage" );
	

}

//Here packages and notifies are declared

music()
{


        
            
            declareMusicPackage( "start", "mus_wht_action_lp", 15, 0.3, .5 );
	    setMusicPackageIntro( "start", "mus_wht_action_intro" );
	    setMusicPackageOutro( "start", "mus_wht_action_outro" );
	    
	    declareMusicPackage( "greenhouse", "mus_wht_greenhouse_lp", 2.5, 0.2, .5 );
	    setMusicPackageIntro( "greenhouse", "mus_wht_greenhouse_intro" );
	    setMusicPackageOutro( "greenhouse", "mus_wht_greenhouse_outro" );
	    
	    declareMusicPackage( "house", "mus_wht_climax_lp", 12, 0.3, 0.5 );
	    setMusicPackageIntro( "house", "mus_wht_climax_intro" );
	    setMusicPackageOutro( "house", "mus_wht_climax_outro" );
	    
	    declareMusicPackage( "boathouse", "mus_wht_boathouse_lp", 2.5, 5.5, 1.0 );

	    declareMusicPackage( "cellar", "mus_wht_cellar_lp", 0, 0.0, 1.0 );
          
 
}
 


