

#include maps\_utility;
#include maps\_music;




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
            
            
            declareMusicPackage( "roof", "mus_con_actionC_lp", 2.4, 1.5, .5 );
            setMusicPackageIntro( "roof", "mus_con_jump_stinger3" );
            setMusicPackageOutro( "roof", "mus_con_actionC_outro" );
 
          
 
}
 


