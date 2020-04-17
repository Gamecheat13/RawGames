

#include maps\_utility;
#include maps\_music;




main()
{
	music();

	level thread runStartMusicPackageListener( "playmusicpackage_start", "start" );
	level thread runStopMusicPackageListener( "endmusicpackage" );
	

}



music()
{


        
            
            declareMusicPackage( "start", "mus_casp_lp", 0, 0.5, 0.5 );
	    setMusicPackageOutro( "start", "mus_casp_outro" );
 
          
 
}
 


