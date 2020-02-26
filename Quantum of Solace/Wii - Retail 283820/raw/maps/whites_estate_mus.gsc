

#include maps\_utility;
#include maps\_music;




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
 


