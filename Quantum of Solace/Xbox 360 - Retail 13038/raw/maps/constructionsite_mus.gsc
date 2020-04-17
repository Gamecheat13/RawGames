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
	level thread runStartMusicPackageListener( "playmusicpackage_floorfall", "floorfall" );
	level thread runStartMusicPackageListener( "playmusicpackage_crane1", "crane1" );
	level thread runStartMusicPackageListener( "playmusicpackage_crane2", "crane2" );
	level thread runStartMusicPackageListener( "playmusicpackage_roof", "roof" );
	level thread runStopMusicPackageListener( "endmusicpackage" );
	

}

//Here packages and notifies are declared

music()
{


        
            
            declareMusicPackage( "start", "mus_con_actionA_lp", 9.3, 0.3, 0.1 );
	    setMusicPackageIntro( "start", "mus_con_actionA_intro" );
	    setMusicPackageOutro( "start", "mus_con_actionA_outro" );
            
            declareMusicPackage( "floorfall", "mus_con_actionB_LP", 3.2, 0.2, 0.1 );
            setMusicPackageIntro( "floorfall", "mus_con_actionB_intro" );
            setMusicPackageOutro( "floorfall", "mus_con_actionB_outro" );
            
            declareMusicPackage( "crane1", "mus_con_perc1_lp", 2.0, 0, 0.1);
            setMusicPackageOutro( "crane1", "mus_con_jump_stinger1" );

            declareMusicPackage( "crane2", "mus_con_perc3_lp", 1.8, 0.2, 0.1 );
            //setMusicPackageIntro( "crane2", "mus_con_jump_stinger2" );
            
            declareMusicPackage( "roof", "mus_con_actionC_lp", 2.4, 1.5, .5 );
            setMusicPackageIntro( "roof", "mus_con_jump_stinger3" );
            setMusicPackageOutro( "roof", "mus_con_actionC_outro" );
 
          
 
}
 


