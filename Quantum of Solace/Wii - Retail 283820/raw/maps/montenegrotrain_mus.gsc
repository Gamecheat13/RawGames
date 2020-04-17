

#include maps\_utility;
#include maps\_music;




main()
{
	music();

	level thread runStartMusicPackageListener( "playmusicpackage_ambient", "ambient" );
	level thread runStartMusicPackageListener( "playmusicpackage_action1", "action1" );
	level thread runStartMusicPackageListener( "playmusicpackage_action2", "action2" );
	level thread runStartMusicPackageListener( "playmusicpackage_bliss", "bliss" );
	level thread runStartMusicPackageListener( "playmusicpacakge_decouple", "decouple" );
	level thread runStopMusicPackageListener( "endmusicpackage" );
	
}



music()
{


        
	
	    declareMusicPackage( "ambient", "mus_tra_ambient_lp", 0, 1, 1 );

            declareMusicPackage( "action1", "mus_tra_action1_lp", 5, .5, .5 );
            setMusicPackageIntro( "action1", "mus_tra_action1_intro" );
            setMusicPackageOutro( "action1", "gameplay_stinger1" );
            
            declareMusicPackage( "action2", "mus_tra_action2_lp", 0, 0, 4 );
	 
            declareMusicPackage( "bliss",  "mus_tra_bliss_lp", 3, .25, .5 );
            setMusicPackageIntro( "bliss", "mus_tra_bliss_Intro" );
            setMusicPackageOutro( "bliss", "mus_tra_bliss_outro" );
            
            declareMusicPackage( "decouple",  "mus_tra_decouple_lp", 3, .25, .5 );
	    setMusicPackageIntro( "decouple", "mus_tra_decouple_intro" );
            setMusicPackageOutro( "decouple", "gameplay_stinger2" );
            
 
}
 





