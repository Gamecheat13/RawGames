

#include maps\_utility;
#include maps\_music;




main()
{
	music();

	level thread runStartMusicPackageListener( "playmusicpackage_action", "action" );
	level thread runStartMusicPackageListener( "playmusicpackage_drum", "drum" );
	level thread runStopMusicPackageListener( "endmusicpackage" );
	
}



music()
{


           
            declareMusicPackage( "action",  "mus_sha_action_lp", 3.2, .5, .5 );
	    setMusicPackageIntro( "action", "mus_sha_action_intro" );
            setMusicPackageOutro( "action", "mus_sha_action_outro" );
            
            declareMusicPackage( "drum",  "mus_sha_drum_lp", 3.0, 0, 1 );
            
 
}
 





