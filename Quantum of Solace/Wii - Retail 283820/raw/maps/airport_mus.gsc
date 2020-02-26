

#include maps\_utility;
#include maps\_music;




main()
{
	music();

	
	level thread runStartMusicPackageListener( "playmusicpackage_stealth", "stealth" );
	level thread runStartMusicPackageListener( "playmusicpackage_luggage_01", "luggage_01" );
	level thread runStartMusicPackageListener( "playmusicpackage_luggage_02", "luggage_02" );
	level thread runStartMusicPackageListener( "playmusicpackage_tarmac", "tarmac" );
	level thread runStopMusicPackageListener( "endmusicpackage" );
	
}



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

