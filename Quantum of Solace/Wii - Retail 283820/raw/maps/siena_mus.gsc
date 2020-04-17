

#include maps\_utility;
#include maps\_music;




main()
{
	music();

	level thread runStartMusicPackageListener( "playmusicpackage_start", "start" );
	level thread runStartMusicPackageListener( "playmusicpackage_rooftops", "rooftops" );
	level thread runStartMusicPackageListener( "playmusicpackage_boss_fight", "boss_fight" );
	level thread runStopMusicPackageListener( "endmusicpackage" );
	

}



music()
{


        
            
            declareMusicPackage( "start", "mus_sie_action_lp", 0, 1.0, 1.0 );
	   
	   
	    
	    declareMusicPackage( "rooftops", "mus_sie_climax_lp", 0, 0, 0.5 );
	    
	    setMusicPackageOutro( "rooftops", "mus_sie_climax_outro" );
 
 	    declareMusicPackage( "boss_fight", "mus_sie_boss", 1.0, 0, 0 );
          
 
}
 


