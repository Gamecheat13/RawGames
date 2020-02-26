

#include maps\_utility;
#include maps\_music;




main()
{
	music();

	level thread runStartMusicPackageListener( "playmusicpackage_ambient", "ambient" );
	level thread runStartMusicPackageListener( "playmusicpackage_house", "house" );
	level thread runStartMusicPackageListener( "playmusicpackage_stealth", "stealth" );
	level thread runStopMusicPackageListener( "endmusicpackage" );
	
}



music()
{


        
	
	    declareMusicPackage( "ambient", "mus_get_ambient_lp", 0, 2, 1 );
	    setMusicPackageCombatAlias( "ambient", 1, 0, "mus_get_action1_lp", 1, .3, 1.2 );
	    setMusicPackageCombatIntro( "ambient", "mus_get_action1_intro" );
            setMusicPackageCombatOutro( "ambient", "mus_get_action1_outro" );
            
            declareMusicPackage( "stealth", "mus_get_stealth_lp", 0, .2, 1 );
	    
	   
           
            
            declareMusicPackage( "house", "mus_get_house_lp", 6.5, .3, 0 );
            setMusicPackageIntro( "house", "mus_get_house_intro" );
            setMusicPackageOutro( "house", "mus_get_house_outro" );
            
 
}
 





