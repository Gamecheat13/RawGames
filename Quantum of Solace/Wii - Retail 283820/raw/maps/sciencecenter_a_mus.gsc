

#include maps\_utility;
#include maps\_music;




main()
{
	music();

	level thread runStartMusicPackageListener( "playmusicpackage_sniper1", "sniper1" );
	level thread runStartMusicPackageListener( "playmusicpackage_sniper2", "sniper2" );
	level thread runStartMusicPackageListener( "playmusicpackage_alley", "alley" );
	level thread runStartMusicPackageListener( "playmusicpackage_ledge", "ledge" );
	level thread runStartMusicPackageListener( "playmusicpackage_backlot", "backlot" );
	level thread runStartMusicPackageListener( "playmusicpackage_roof", "roof" );
	level thread runStartMusicPackageListener( "playmusicpackage_helicopter", "helicopter" );
	level thread runStopMusicPackageListener( "endmusicpackage" );

	thread musicstinger_start();	
}



music()
{


        
            declareMusicPackage( "sniper1", "mus_sca_sniper1_lp", 0, 2, 2 );
       
	    declareMusicPackage( "sniper2", "mus_sca_sniper2_lp", 4, .5, 1.2 );
            setMusicPackageIntro( "sniper2", "mus_sca_sniper2_intro" );
            setMusicPackageOutro( "sniper2", "mus_sca_sniper2_outro" );
	    
	    declareMusicPackage( "alley", "mus_sca_stealth_lp", 0, 2, 2 );
	    setMusicPackageCombatAlias( "alley", 1, 0, "mus_sca_action_lp", 4, .5, 0);
	    setMusicPackageCombatIntro( "alley", "mus_sca_action_intro" );
            setMusicPackageCombatOutro( "alley", "mus_sca_action_outro" );
           
            declareMusicPackage( "backlot", "mus_sca_backlot_lp", 1, .2, 1.2 );
            setMusicPackageIntro( "backlot", "mus_sca_backlot_intro" );
            setMusicPackageOutro( "backlot", "mus_sca_backlot_outro" );
            
            declareMusicPackage( "ledge", "mus_sca_stealth_lp", 0, 2, 2 );
            
            declareMusicPackage( "roof", "mus_sca_roof_lp", 4, .5, 1.2 );
            setMusicPackageIntro( "roof", "mus_sca_roof_intro" );
            
            declareMusicPackage( "helicopter", "mus_sca_helicopter_lp", 6, .3, 1.2 );
            setMusicPackageIntro( "helicopter",  "mus_sca_helicopter_intro" );
            setMusicPackageOutro( "helicopter", "mus_sca_helicopter_outro" );
            
          
 
}
 




musicstinger_start()
{

            for ( ;; )

            {

                        level waittill( "musicstinger_rope" );

                        level.player playsound ("mus_scb_rope_stinger");

            }


}

