/*-----------------------------------------------------
Ambient stuff
-----------------------------------------------------*/
#include maps\_utility;
#include maps\_ambientpackage;



main()
{

//************************************************************************************************
//                                              Ambient Packages
//************************************************************************************************

 

 

//***************
//oki2_Base
//***************   

            declareAmbientPackage( "oki2_base_pkg" );            

                        addAmbientElement( "oki2_base_pkg", "amb_dog_bark", 15, 30, 300, 1000 );
                        addAmbientElement( "oki2_base_pkg", "amb_seagull", 6, 45, 500, 1000 );
                        addAmbientElement( "oki2_base_pkg", "amb_Japanese_outdoor_1", 10, 15, 500, 1500 );
                        addAmbientElement( "oki2_base_pkg", "amb_raven", 10, 40, 100, 1000 );
                        addAmbientElement( "oki2_base_pkg", "rain_granulated", .112, .212, 1, 500 );
 
 

//***************
//oki2_Cave
//***************
            
            declareAmbientPackage( "oki2_cave_pkg" );
            
                        addAmbientElement( "oki2_cave_pkg", "amb_drip", 2, 15, 25, 110 );
                        addAmbientElement( "oki2_cave_pkg", "amb_Japanese_cave_1", 10, 20, 500, 1000 );
                        addAmbientElement( "oki2_cave_pkg", "amb_bats", 2, 15, 25, 110 );
                   
 //***************
//oki2_cave_bigroom_pkg
//***************
            
            declareAmbientPackage( "oki2_cave_bigroom_pkg" );
            
                        addAmbientElement( "oki2_cave_bigroom_pkg", "amb_drip", 2, 15, 25, 110 );
                        addAmbientElement( "oki2_cave_bigroom_pkg", "amb_Japanese_cave_1", 10, 20, 100, 500 );
                        addAmbientElement( "oki2_cave_bigroom_pkg", "amb_bats", 2, 15, 25, 110 );
                              
//***************
//oki2_High Alt
//***************

            declareAmbientPackage( "oki2_high_alt_pkg" );
            

                        addAmbientElement( "oki2_high_alt_pkg", "amb_dog_bark", 15, 30, 300, 1000 );
                        addAmbientElement( "oki2_high_alt_pkg", "amb_seagull", 6, 45, 500, 1000 );
                        addAmbientElement( "oki2_high_alt_pkg", "amb_Japanese_outdoor_1", 10, 15, 500, 1500 );
                        addAmbientElement( "oki2_high_alt_pkg", "amb_raven", 10, 40, 100, 1000 );
                        
                        
                        
 //***************
 //oki2_highalt_bunker_pkg
 //***************
 
             declareAmbientPackage( "oki2_highalt_bunker_pkg" );
             
 
                         addAmbientElement( "oki2_highalt_bunker_pkg", "amb_dog_bark", 15, 30, 300, 1000 );
                         addAmbientElement( "oki2_highalt_bunker_pkg", "amb_seagull", 6, 45, 500, 1000 );
                         addAmbientElement( "oki2_highalt_bunker_pkg", "amb_Japanese_outdoor_1", 10, 15, 500, 1500 );
                         addAmbientElement( "oki2_highalt_bunker_pkg", "amb_raven", 10, 40, 100, 1000 );
                         
//***************
 //oki2_highalt_int_pkg
 //***************
 
             declareAmbientPackage( "oki2_highalt_int_pkg" );
             
 
                        
                        
//***************
//oki2_highalt_smallcave_pkg
//***************

            declareAmbientPackage( "oki2_highalt_smallcave_pkg" );
            

                        addAmbientElement( "oki2_highalt_smallcave_pkg", "amb_dog_bark", 15, 30, 300, 1000 );
                        addAmbientElement( "oki2_highalt_smallcave_pkg", "amb_seagull", 6, 45, 500, 1000 );
                        addAmbientElement( "oki2_highalt_smallcave_pkg", "amb_Japanese_outdoor_1", 10, 15, 500, 1500 );
                        addAmbientElement( "oki2_highalt_smallcave_pkg", "amb_raven", 10, 40, 100, 1000 );
            

           
//************************************************************************************************
//                                              ROOMS
//************************************************************************************************

 
//***************
//oki2_Base
//***************

            declareAmbientRoom( "oki2_base_room" );

                        setAmbientRoomTone( "oki2_base_room", "bgt_wind" );
                        setAmbientRoomReverb( "oki2_base_room", "forest", 1, 0.4 );

 

//***************
//oki2_Cave
//***************

            declareAmbientRoom( "oki2_cave_room" );

                        setAmbientRoomTone( "oki2_cave_room", "bgt_cave" );
                        setAmbientRoomReverb( "oki2_cave_room", "cave", 1, 0.4 );
//***************
//oki2_cave_bigroom_room
//***************

            declareAmbientRoom( "oki2_cave_bigroom_room" );

                        setAmbientRoomTone( "oki2_cave_bigroom_room", "bgt_cave" );
                        setAmbientRoomReverb( "oki2_cave_bigroom_room", "cave", 1, 0.4 );
//***************
//oki2_High Alt
//***************   

            declareAmbientRoom( "oki2_high_alt_room" );

                        setAmbientRoomTone( "oki2_high_alt_room", "bgt_wind_high_alt" );
                        setAmbientRoomReverb( "oki2_high_alt_room", "city", 1, 0.4 );
                        
                        
//***************
//oki2_high_alt_int_room
//***************   

            declareAmbientRoom( "oki2_wind_high_alt_int_room" );

                        setAmbientRoomTone( "oki2_wind_high_alt_int_room", "bgt_wind_high_alt_int" );
                        setAmbientRoomReverb( "oki2_wind_high_alt_int_room", "bathroom", 1, 0.4 );
//***************
//oki2_High Alt_bridge
//***************   

            declareAmbientRoom( "oki2_high_alt_bridge_room" );

                        setAmbientRoomTone( "oki2_high_alt_bridge_room", "bgt_wind_high_alt" );
                        setAmbientRoomReverb( "oki2_high_alt_bridge_room", "bathroom", 1, 0.4 );


//***************
//oki2_highalt_bunker
//***************   

            declareAmbientRoom( "oki2_highalt_bunker_room" );

                        setAmbientRoomTone( "oki2_highalt_bunker_room", "bgt_wind_high_alt_bunker" );
                        setAmbientRoomReverb( "oki2_highalt_bunker_room", "alley", 1, 0.4 );
//***************
//oki2_highalt_smallcave_room
//***************   

            declareAmbientRoom( "oki2_highalt_smallcave_room" );

                        setAmbientRoomTone( "oki2_highalt_smallcave_room", "bgt_wind_high_alt" );
                        setAmbientRoomReverb( "oki2_highalt_smallcave_room", "stonecorridor", 1, 0.4 );

            

            

//************************************************************************************************

//                                              ACTIVATE DEFAULT AMBIENT SETTINGS

//************************************************************************************************

            activateAmbientPackage( "oki2_base_pkg", 0 );
            activateAmbientRoom( "oki2_base_room", 0 );



 

//*************************************************************************************************

//                                              START SCRIPTS

//*************************************************************************************************


//}
//Removed by Rich 8/26/08
///*------------------------------------
//fog settings for the level
//------------------------------------*/
//
//set_opening_fog()
//{
//	//setVolFog(0, 5500, 5000, 0, 0.5, 0.515, 0.5, 0);
//
//}
//
//set_assault_fog()
//{
//	//setVolFog(0, 1950, 5000, 0, 0.5, 0.515, 0.5, 15);
//
//}
//
//set_grotto_fog()
//{
//	//setVolFog(0, 850, 200, 0, 0.5, 0.515, 0.5, 10);
//
//}
//
//set_final_fog()
//{
//	//setVolFog(0, 900, 1000, 0, 0.5, 0.515, 0.5, 10);
//
}
