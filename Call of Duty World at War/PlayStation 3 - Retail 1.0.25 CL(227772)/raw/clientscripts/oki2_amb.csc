//
// file: template_amb.csc
// description: clientside ambient script for template: setup ambient sounds, etc.
// scripter: 		(initial clientside work - laufer)
//

#include clientscripts\_utility; 
#include clientscripts\_ambientpackage;
#include clientscripts\_music;

main()
{
	//************************************************************************************************
	//                                              Ambient Packages
	//************************************************************************************************

	//declare an ambientpackage, and populate it with elements
	//mandatory parameters are <package name>, <alias name>, <spawnMin>, <spawnMax>
	//followed by optional parameters <distMin>, <distMax>, <angleMin>, <angleMax>

 

//***************
//oki2_Base
//***************   

            declareAmbientPackage( "oki2_base_pkg" );            

                        addAmbientElement( "oki2_base_pkg", "amb_dog_bark", 15, 30, 300, 1000 );
                        addAmbientElement( "oki2_base_pkg", "amb_seagull", 6, 45, 500, 1000 );
                        addAmbientElement( "oki2_base_pkg", "amb_Japanese_outdoor_1", 10, 15, 500, 1500 );
                        addAmbientElement( "oki2_base_pkg", "amb_raven", 10, 40, 100, 1000 );
 
//***************
//oki2_Cave
//***************
            
            declareAmbientPackage( "oki2_cave_pkg" );
            
                        addAmbientElement( "oki2_cave_pkg", "amb_drip", 2, 15, 25, 110 );
                        addAmbientElement( "oki2_cave_pkg", "amb_Japanese_cave_1", 10, 20, 500, 1000 );
                        addAmbientElement( "oki2_cave_pkg", "amb_bats", 2, 15, 25, 110 );
 						addAmbientElement( "oki2_cave_pkg", "amb_wood_creak", 3, 8, 50, 1000 );
                   
 //***************
//oki2_cave_bigroom_pkg
//***************
            
            declareAmbientPackage( "oki2_cave_bigroom_pkg" );
            
                        addAmbientElement( "oki2_cave_bigroom_pkg", "amb_drip", 2, 15, 25, 110 );
                        addAmbientElement( "oki2_cave_bigroom_pkg", "amb_Japanese_cave_1", 10, 20, 100, 500 );
                        addAmbientElement( "oki2_cave_bigroom_pkg", "amb_bats", 2, 15, 25, 110 );
 					addAmbientElement( "oki2_cave_bigroom_pkg", "amb_wood_creak", 3, 8, 50, 1000 );
                              
//***************
//oki2_High Alt
//***************

            declareAmbientPackage( "oki2_high_alt_pkg" );
            

                       // addAmbientElement( "oki2_high_alt_pkg", "amb_dog_bark", 15, 30, 300, 1000 );
                       // addAmbientElement( "oki2_high_alt_pkg", "amb_seagull", 6, 45, 500, 1000 );
                        addAmbientElement( "oki2_high_alt_pkg", "amb_Japanese_outdoor_1", 10, 15, 500, 1500 );
                        addAmbientElement( "oki2_high_alt_pkg", "amb_raven", 10, 40, 100, 1000 );
                       
 
                        
                        
                        
 //***************
 //oki2_highalt_bunker_pkg
 //***************
 
             declareAmbientPackage( "oki2_highalt_bunker_pkg" );             
 
                        // addAmbientElement( "oki2_highalt_bunker_pkg", "amb_dog_bark", 15, 30, 300, 1000 );
                       //  addAmbientElement( "oki2_highalt_bunker_pkg", "amb_seagull", 6, 45, 500, 1000 );
                       //  addAmbientElement( "oki2_highalt_bunker_pkg", "amb_Japanese_outdoor_1", 10, 15, 500, 1500 );
            addAmbientElement( "oki2_highalt_bunker_pkg", "amb_raven", 10, 40, 100, 1000 );
   			addAmbientElement( "oki2_highalt_bunker_pkg", "amb_wood_creak", 3, 8, 50, 1000 );
                         
//***************
 //oki2_highalt_int_pkg
 //***************
 
             declareAmbientPackage( "oki2_highalt_int_pkg" );
             
 
                        
                        
//***************
//oki2_highalt_smallcave_pkg
//***************

            declareAmbientPackage( "oki2_highalt_smallcave_pkg" );           

                     //   addAmbientElement( "oki2_highalt_smallcave_pkg", "amb_dog_bark", 15, 30, 300, 1000 );
                     //   addAmbientElement( "oki2_highalt_smallcave_pkg", "amb_seagull", 6, 45, 500, 1000 );
                    //    addAmbientElement( "oki2_highalt_smallcave_pkg", "amb_Japanese_outdoor_1", 10, 15, 500, 1500 );
                     //   addAmbientElement( "oki2_highalt_smallcave_pkg", "amb_raven", 10, 40, 100, 1000 );
            addAmbientElement( "oki2_highalt_smallcave_pkg", "amb_wood_creak", 3, 8, 50, 1000 );

	
	
	//************************************************************************************************
	//                                       ROOMS
	//************************************************************************************************

	//explicitly activate the base ambientpackage, which is used when not touching any ambientPackageTriggers
	//the other trigger based packages will be activated automatically when the player is touching them
	//the same pattern is followed for setting up ambientRooms

 
//***************
//oki2_Base
//***************

            declareAmbientRoom( "oki2_base_room" );

                        setAmbientRoomTone( "oki2_base_room", "bgt_wind" );
                        setAmbientRoomReverb( "oki2_base_room", "forest", 1, 1 );
//***************
//oki2_Cave
//***************

            declareAmbientRoom( "oki2_cave_room" );

                        setAmbientRoomTone( "oki2_cave_room", "bgt_cave" );
                        setAmbientRoomReverb( "oki2_cave_room", "CAVE", 1, 1 );
//***************
//oki2_cave_bigroom_room
//***************

            declareAmbientRoom( "oki2_cave_bigroom_room" );

                        setAmbientRoomTone( "oki2_cave_bigroom_room", "bgt_cave" );
                        setAmbientRoomReverb( "oki2_cave_bigroom_room", "stoneroom", 1, 1 );
//***************
//oki2_High Alt
//***************   

            declareAmbientRoom( "oki2_high_alt_room" );

                        setAmbientRoomTone( "oki2_high_alt_room", "bgt_wind_high_alt" );
                        setAmbientRoomReverb( "oki2_high_alt_room", "forest", 1, 0.4 );
                        
                        
//***************
//oki2_high_alt_int_room
//***************   

            declareAmbientRoom( "oki2_wind_high_alt_int_room" );

                        setAmbientRoomTone( "oki2_wind_high_alt_int_room", "bgt_wind_high_alt_int" );
                        setAmbientRoomReverb( "oki2_wind_high_alt_int_room", "bathroom", 1, 0.6 );
//***************
//oki2_High Alt_bridge
//***************   

            declareAmbientRoom( "oki2_high_alt_bridge_room" );

                        setAmbientRoomTone( "oki2_high_alt_bridge_room", "bgt_wind_high_alt" );
                        setAmbientRoomReverb( "oki2_high_alt_bridge_room", "bathroom", 1, 0.6 );


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
	//                                      ACTIVATE DEFAULT AMBIENT SETTINGS
	//************************************************************************************************

  activateAmbientPackage( 0, "oki2_base_pkg", 0 );
  activateAmbientRoom( 0, "oki2_base_room", 0 );	




	//************************************************************************************************
	//                                              Music Packages
	//************************************************************************************************




	declareMusicState("INTRO"); //one shot dont transition until done
		musicAlias("mx_intro", 0);
		musicAliasLoop("mx_underscore", 4, 6);
		musicStinger("mx_ambush_stinger", 8);
		

	declareMusicState("OH_SHIT"); //stinger + fadeout		
		musicAliasLoop("mx_hill_fight", 0, 6);
		musicStinger("shaka_sting", 6);

	declareMusicState("BUNKERS");
		musicAliasLoop("mx_bunker_loop", 0, 6);
		
	declareMusicState("FUBAR"); //stinger + fadeout
		musicAliasLoop("mx_fubar", 4, 6);
		musicStinger("mx_bunker_stinger", 28);
		
	declareMusicState("UNDERSCORE"); //stinger + fadeout
		musicAliasLoop("mx_underscore", 0, 6);
		musicStinger("mx_mortars_stg", 3);
	
	declareMusicState("MORTARS");
		musicAliasLoop("mx_mortars_loop", 0, 6);

	declareMusicState("INTO_BUNKERS");
		musicAliasLoop("mx_bunker_int_loop", 6, 4);

	declareMusicState("UP_THE_LADDER");
		musicAliasLoop("mx_bunker_up_ladder", 4, 4);


	declareMusicState("LEVEL_END");
		musicAlias("mx_level_end");

	
}

