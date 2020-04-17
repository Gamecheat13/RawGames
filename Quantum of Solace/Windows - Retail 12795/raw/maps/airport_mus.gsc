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
	level thread runStartMusicPackageListener( "playmusicpackage_luggage_01", "luggage_01" );
	level thread runStartMusicPackageListener( "playmusicpackage_luggage_02", "luggage_02" );
	level thread runStartMusicPackageListener( "playmusicpackage_tarmac", "tarmac" );
	level thread runStopMusicPackageListener( "endmusicpackage" );
	
}

//Here packages and notifies are declared

music()
{


        
           
	    declareMusicPackage( "stealth", "mus_arp_stealth_lp", 0, 2, 1 );
	    setMusicPackageCombatAlias( "stealth", 2, 0, "mus_arp_stealth_com_lp", 0, 1, 2 );

            declareMusicPackage( "luggage_01", "mus_arp_luggage_01_lp", 1.6, 0, 1.2 );
            setMusicPackageIntro( "luggage_01", "mus_arp_luggage_01_intro" );
            setMusicPackageOutro( "luggage_01", "mus_arp_luggage_01_outro" );
            
            declareMusicPackage( "luggage_02", "mus_arp_luggage_02_lp", 2, 0, 1.2 );
            setMusicPackageOutro( "luggage_02", "mus_arp_luggage_02_outro" );
            
            declareMusicPackage( "tarmac", "mus_arp_luggage_tarmac_lp", 0, 2, 1.2 );
	    setMusicPackageIntro( "tarmac", "mus_arp_luggage_tarmac_intro" );
            setMusicPackageOutro( "tarmac", "mus_arp_luggage_tarmac_outro" );
            


}

