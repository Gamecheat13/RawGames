

#include maps\_utility;
#include maps\_music;




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



music()
{


        
	
	    declareMusicPackage( "stealth", "mus_bar_stealth_lp", 0, 1, 2 );
            setMusicPackageCombatAlias( "stealth", 2, 0, "mus_bar_stealth_com_lp", 0, 2, 2 );
           
            declareMusicPackage( "action", "mus_bar_action_lp", 0, .5, 2 );
            
            
            declareMusicPackage( "action2", "mus_bar_action2_lp", 1.5, .5, 2 );
            setMusicPackageIntro( "action2", "mus_bar_action2_intro" );
	 
            declareMusicPackage( "sniper", "mus_bar_sniper_lp", 0, 2, 1.5 );
            
            declareMusicPackage( "postsniper", "mus_bar_postsniper_lp", 3.0, 2, .5 );
            setMusicPackageIntro( "postsniper", "mus_bar_postsniper_Intro" );
	 
            declareMusicPackage( "climax",  "mus_bar_climax_lp", 1.7, .01, .5 );
            setMusicPackageIntro( "climax", "mus_bar_climax_Intro" );
            setMusicPackageOutro( "climax", "mus_bar_climax_outro" );
           
            
 
}
 





