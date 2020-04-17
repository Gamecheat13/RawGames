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
	level thread runStartMusicPackageListener( "playmusicpackage_ambient", "ambient" );
	level thread runStartMusicPackageListener( "playmusicpackage_garage", "garage" );
	level thread runStartMusicPackageListener( "playmusicpackage_greene", "greene" );
	level thread runStartMusicPackageListener( "playmusicpackage_bond", "bond" );
	level thread runStartMusicPackageListener( "playmusicpackage_medrano", "medrano" );
	level thread runStartMusicPackageListener( "playmusicpackage_atrium", "atrium" );
	level thread runStartMusicPackageListener( "playmusicpackage_ending", "ending" );
	level thread runStopMusicPackageListener( "endmusicpackage" );
	

}

//Here packages and notifies are declared

music()
{


        
            
            declareMusicPackage( "garage", "mus_eco_action_lp", 3.8, .4, .5 );
	    setMusicPackageIntro( "garage", "mus_eco_action_intro" );
	    setMusicPackageOutro( "garage", "mus_eco_action_outro" );
	    
	    declareMusicPackage( "start", "mus_eco_start_lp", 0, 0, .5 );
	    
	    declareMusicPackage( "ambient", "mus_eco_ambient_lp", 0, 0, 3.5 );
	    
	    declareMusicPackage( "ending", "mus_eco_end_lp", 7.5, 5, .5 );
	    
	    declareMusicPackage( "medrano", "mus_eco_medrano_lp", 0, 1.0, 1.0);
	     
	     declareMusicPackage( "bond", "mus_eco_bond_lp", 0, 0, .5 );
	    
	    declareMusicPackage( "greene", "mus_eco_climax_lp", 0, 0, 0.5 );
	    setMusicPackageIntro( "greene", "mus_eco_climax_intro" );
	    setMusicPackageOutro( "greene", "mus_eco_climax_outro" );
 
 
 	    declareMusicPackage( "atrium", "mus_eco_atrium_lp", 0, 0, 0.5 );
 	    setMusicPackageIntro( "atrium", "mus_eco_atrium_intro" );
	    //setMusicPackageOutro( "atrium", "mus_eco_atrium_outro" );
 	   
          
 
}
 


