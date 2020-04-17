
#include maps\_utility;
#include maps\_music;


main()


{
	music();

	level thread runStartMusicPackageListener( "playmusicpackage_start", "start" );
	level thread runStartMusicPackageListener( "playmusicpackage_stealth", "stealth" );
	level thread runStartMusicPackageListener( "playmusicpackage_spa", "spa" );
	level thread runStartMusicPackageListener( "playmusicpackage_ballroom", "ballroom" );
	level thread runStartMusicPackageListener( "playmusicpackage_boss", "boss" );
	level thread runStopMusicPackageListener( "endmusicpackage" );
	
	level thread runStopMusicPackageListener( "playmusicpackage_combat" );

	thread musicstinger_start();	
}




music()
{


        
            declareMusicPackage( "start", "mus_cas_stealth_lp", 0, 2, 2 );
            setMusicPackageCombatAlias( "start", 2, 0, "mus_cas_stealth_com_lp", 0, 2, 2 );
	
	    declareMusicPackage( "stealth", "mus_cas_stealth_lp", 0, 2, 2 );
	    setMusicPackageCombatAlias( "stealth", 2, 0, "mus_cas_stealth_com_lp", 0, 2, 2 );

            declareMusicPackage( "spa", "mus_cas_spa_lp", 0, 2, 1.2 );
            setMusicPackageIntro( "spa", "mus_cas_spa_intro" );
            setMusicPackageOutro( "spa", "mus_cas_spa_outro" );

            declareMusicPackage( "ballroom", "mus_cas_ballroom_lp", 0, 3, 1.2 );
            setMusicPackageIntro( "ballroom", "mus_cas_ballroom_intro" );
            setMusicPackageOutro( "ballroom", "mus_cas_ballroom_outro" );
            
            declareMusicPackage( "boss", "mus_cas_boss", 0, 0, 0 );
	   
}
 




musicstinger_start()
{

            for ( ;; )

            {

                        level waittill( "musicstinger_start" );

                        level.player playsound ("intro_stinger");

            }


}
