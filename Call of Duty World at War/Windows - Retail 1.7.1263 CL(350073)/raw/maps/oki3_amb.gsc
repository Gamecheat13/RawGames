/*-----------------------------------------------------
Ambient stuff
-----------------------------------------------------*/
#include maps\_utility;
#include maps\_ambientpackage;
#include maps\_music;



main()
{

//************************************************************************************************
//                                              Ambient Packages
//************************************************************************************************

 

 

//***************
//oki3_Base
//***************   

            declareAmbientPackage( "oki3_base_pkg" );            

                        addAmbientElement( "oki3_base_pkg", "amb_dog_bark", 15, 30, 300, 1000 );
                        addAmbientElement( "oki3_base_pkg", "amb_seagull", 6, 45, 500, 1000 );
                        addAmbientElement( "oki3_base_pkg", "amb_Japanese_outdoor_1", 10, 15, 500, 1500 );
                        addAmbientElement( "oki3_base_pkg", "amb_raven", 10, 40, 100, 1000 );
 
 

//***************
//oki3_indooroutdoor
//***************
            
            declareAmbientPackage( "oki3_indooroutdoor_pkg" );
            
                        addAmbientElement( "oki3_indooroutdoor_pkg", "amb_dog_bark", 15, 30, 300, 1000 );
			addAmbientElement( "oki3_indooroutdoor_pkg", "amb_seagull", 6, 45, 500, 1000 );
			addAmbientElement( "oki3_indooroutdoor_pkg", "amb_Japanese_outdoor_1", 10, 15, 500, 1500 );
                        addAmbientElement( "oki3_indooroutdoor_pkg", "amb_raven", 10, 40, 100, 1000 );
                   
 //***************
//oki3_indoor_pkg
//***************
            
            declareAmbientPackage( "oki3_indoor_pkg" );
            
                      



           
//************************************************************************************************
//                                              ROOMS
//************************************************************************************************

 
//***************
//oki3_Base
//***************

            declareAmbientRoom( "oki3_base_room" );

                        setAmbientRoomTone( "oki3_base_room", "bgt_wind" );

 

//***************
//oki3_indooroutdoor
//***************

            declareAmbientRoom( "oki3_indooroutdoor_room" );

                        setAmbientRoomTone( "oki3_indooroutdoor_room", "bgt_inout" );
//***************
//oki3_indoor_room
//***************

            declareAmbientRoom( "oki3_indoor_room" );

                        setAmbientRoomTone( "oki3_indoor_room", "bgt_indoor" );


 

            

//************************************************************************************************

//                                              ACTIVATE DEFAULT AMBIENT SETTINGS

//************************************************************************************************

            activateAmbientPackage( "oki3_base_pkg", 0 );
            activateAmbientRoom( "oki3_base_room", 0 );
            
            level thread maps\oki3_amb::Play_Underground_VO();
			level thread end_level_music_switcher();


			//level thread end_level_music_waiter_sarge();
 			//level thread end_level_music_waiter_polonsky();

 

//*************************************************************************************************

//                                              START SCRIPTS

//*************************************************************************************************


}
Play_Underground_VO()
{
	playsoundatposition("", (8929.86, -3246.24, -34));
}
end_level_music_waiter_sarge()
{
	wait(0.1);
	level waittill("sarge_saved");
	
	//TUEY Sets the music state when going downstairs
	//setmusicstate("POLONSKY_DIED");

	setmusicstate("ROEBUCK_DIED");

}
end_level_music_waiter_polonsky()
{
	wait(0.1);
	level waittill("polonsky_saved");
	
	//TUEY Sets the music state when going downstairs
	//setmusicstate("ROEBUCK_DIED");

	setmusicstate("POLONSKY_DIED");

}
end_level_music_switcher()
{
	level waittill ("audio_one_down");
	setmusicstate("COURTYARD_B");


}