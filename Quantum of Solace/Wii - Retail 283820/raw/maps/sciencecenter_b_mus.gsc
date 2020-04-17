

#include maps\_utility;
#include maps\_music;




main()
{
	music();

	level thread runStartMusicPackageListener( "playmusicpackage_start", "start" );
	level thread runStartMusicPackageListener( "playmusicpackage_stealth", "stealth" );
	level thread runStartMusicPackageListener( "playmusicpackage_catwalk", "catwalk" );
	level thread runStartMusicPackageListener( "playmusicpackage_hall", "hall" );
	level thread runStartMusicPackageListener( "playmusicpackage_boss_start", "boss_start" );
	level thread runStopMusicPackageListener( "endmusicpackage" );

	thread musicstinger_start();	
}



music()
{


        
            declareMusicPackage( "start", "mus_scb_stealth_lp", 0, 2, 2 );
            setMusicPackageCombatAlias( "start", 2, 0, "mus_scb_stealth_com_lp", 0, 2, 2 );
	
	    declareMusicPackage( "stealth", "mus_scb_stealth_lp", 0, 2, 1 );
	    setMusicPackageCombatAlias( "stealth", 2, 0, "mus_scb_stealth_com_lp", 0, 1, 1 );

            declareMusicPackage( "catwalk", "mus_scb_catwalk_lp", 0, 0, 1.2 );
            setMusicPackageOutro( "catwalk", "mus_scb_catwalk_outro" );
            
            declareMusicPackage( "hall", "mus_scb_hall_lp", 0, 0, 1.2 );
            setMusicPackageOutro( "hall", "mus_scb_hall_outro" );
            
            declareMusicPackage( "boss_start", "mus_scb_boss_lp", 0, 1, 2 );
            setMusicPackageOutro( "boss_start", "gameplay_stinger1" );
 
}
 




musicstinger_start()
{

            for ( ;; )

            {

                        level waittill( "musicstinger_rope" );

                        level.player playsound ("mus_scb_rope_stinger");

            }


}

