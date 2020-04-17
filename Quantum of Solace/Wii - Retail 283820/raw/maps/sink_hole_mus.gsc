

#include maps\_utility;
#include maps\_music;




main()
{
	music();

	level thread runStartMusicPackageListener( "playmusicpackage_action", "action" );
	level thread runStartMusicPackageListener( "playmusicpackage_action2", "action2" );
	level thread runStartMusicPackageListener( "playmusicpackage_sniper", "sniper" );
	level thread runStartMusicPackageListener( "playmusicpackage_climax", "climax" );
	level thread runStartMusicPackageListener( "playmusicpackage_helicopter", "helicopter" );
	level thread runStartMusicPackageListener( "playmusicpackage_ending", "ending" );
	level thread runStopMusicPackageListener( "endmusicpackage" );
	
}



music()
{


        
	
           
            declareMusicPackage( "action", "mus_sin_action_lp", 2, .5, 2 );
            setMusicPackageIntro( "action", "mus_sin_action_intro" );
           
            declareMusicPackage( "sniper", "mus_sin_sniper_lp", .5, 2, 2.5 );
	 
            declareMusicPackage( "climax",  "mus_sin_climax_lp", 9, .5, 3 );
            setMusicPackageIntro( "climax", "mus_sin_climax_Intro" );
           
            declareMusicPackage( "helicopter",  "mus_sin_helicopter_lp", 3.0, .2, .5 );
	    setMusicPackageIntro( "helicopter", "mus_sin_action_intro" );
            setMusicPackageOutro( "helicopter", "mus_sin_climax_outro" );
            
            declareMusicPackage( "ending", "mus_sin_stealth_lp", 5, 2.5, 1.5 );
            
 
}
 





