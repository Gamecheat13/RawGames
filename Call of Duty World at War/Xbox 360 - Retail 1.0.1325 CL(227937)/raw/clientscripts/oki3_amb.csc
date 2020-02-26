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
//oki3_Base
//***************   

            declareAmbientPackage( "oki3_base_pkg" );            


 
 

//***************
//oki3_indooroutdoor
//***************
            
            declareAmbientPackage( "oki3_indooroutdoor_pkg" );

                   
 //***************
//oki3_indoor_pkg
//***************
            
            declareAmbientPackage( "oki3_indoor_pkg" );
            
            
 //***************
//oki3_tunnel
//***************
            
            declareAmbientPackage( "oki3_tunnel" );



//***************
//oki3_Cave
//***************
            
            declareAmbientPackage( "oki3_cave_pkg" );
            
                      
                      

	
	//************************************************************************************************
	//                                       ROOMS
	//************************************************************************************************

	//explicitly activate the base ambientpackage, which is used when not touching any ambientPackageTriggers
	//the other trigger based packages will be activated automatically when the player is touching them
	//the same pattern is followed for setting up ambientRooms


 
//***************
//oki3_Base
//***************

            declareAmbientRoom( "oki3_base_room" );

                        setAmbientRoomTone( "oki3_base_room", "bgt_wind" );
                        setAmbientRoomReverb( "oki3_base_room", "FOREST",  1, 1 );

 

//***************
//oki3_indooroutdoor
//***************

            declareAmbientRoom( "oki3_indooroutdoor_room" );

                        setAmbientRoomTone( "oki3_indooroutdoor_room", "bgt_inout" );
                        setAmbientRoomReverb( "oki3_indooroutdoor_room", "LIVINGROOM", 1, 1 );
//***************
//oki3_indoor_room
//***************

            declareAmbientRoom( "oki3_indoor_room" );

                        setAmbientRoomTone( "oki3_indoor_room", "bgt_indoor" );
                        setAmbientRoomReverb( "oki3_indoor_room", "LIVINGROOM",  1, 1 );
 
 
 //***************
 //oki3_tunnel
 //***************
 
             declareAmbientRoom( "oki3_tunnel" );
 
                         setAmbientRoomTone( "oki3_tunnel", "bgt_tunnel" );
                        setAmbientRoomReverb( "oki3_tunnel", "STONEROOM",  1, 1 );


//***************
//oki3_Cave
//***************

            declareAmbientRoom( "oki3_cave_room" );

                        setAmbientRoomTone( "oki3_cave_room", "bgt_cave" );
                        setAmbientRoomReverb( "oki3_cave_room", "CAVE", 1, 1 );


//***************
//oki3_Courtyard
//***************

            declareAmbientRoom( "oki3_courtyard_room" );

                        setAmbientRoomTone( "oki3_courtyard_room", "bgt_wind" );
                        setAmbientRoomReverb( "oki3_courtyard_room", "ALLEY", 1, 1 );
	
	//************************************************************************************************
	//                                      ACTIVATE DEFAULT AMBIENT SETTINGS
	//************************************************************************************************

  activateAmbientPackage( 0, "oki3_base_pkg", 0 );
  activateAmbientRoom( 0, "oki3_base_room", 0 );

	//**********************************************************************
	//				MUSIC PACKAGES
	//**********************************************************************
	
		// TO DO:  USE FOR UNDERSCORE OF THE OPENING SCENE later
		   
		    declareMusicState("INTRO"); //one shot dont transition until done
		    musicAliasloop("mx_underscore", 0, 20);  
			musicStinger("mx_ramp_supplies", 20);
			
		    declareMusicState("SUPPLIES");		
			musicAliasloop("mx_ramp_loop", 2, 1);  
			musicStinger("mx_ramp_stg", 6);
	
			declareMusicState("AMBUSH");			
		    musicAlias ("mx_grass_ambush");
			musicAliasLoop("mx_underscore", 0, 2);	


			
			
			declareMusicState("MORTARS_INC");	
			musicAlias ("mx_mortar_inc", 6);
			musicAliasloop("mx_underscore", 2, 4); 
			//musicStinger("mx_tunnel_stg", 0, true);

			declareMusicState("TUNNEL");			
			musicAliasLoop("mx_tunnel_loop", 0 , 1);
			musicStinger("mx_t_ambush_stg", 2, true);  //true = force

			declareMusicState("TUNNEL_AMBUSH");			
			musicAliasLoop("mx_tunnel_loop", 0, 4);
			musicStinger("mx_spider_stg", 4, true);
			
			declareMusicState("SPIDER_HOLES");	
			musicAliasLoop("mx_spider_loop", 2 , 4);
			musicStinger("mx_underscore_b_stg", 4, true);

			declareMusicState("PRE_MORTARS");
			musicAliasloop("mx_underscore_b", 2, 4); 

			declareMusicState("MORTAR_PITS");
			musicAliasloop("mx_mortar_pits", 0, 4);
			musicStinger("mx_underscore_b_stg", 4); 

			declareMusicState("MORTAR_BANZAI");			
		    musicAlias ("mx_ambush_stinger");
			musicAliasLoop("mx_first_fight", 0, 2);	

			declareMusicState("POST_MORTARS");
			musicAliasloop("mx_underscore", 4, 4); 
			musicStinger("mx_ambush_stinger_duex", 17);

			declareMusicState("PLANTERS");
			musicAliasloop("mx_planters_fight", 2, 6);
			musicStinger("mx_planters_stg", 2);

			declareMusicState("PLANTERS_CLEARED");
			musicAliasloop("mx_post_planters", 2, 4); 
			musicStinger("mx_underscore_b_stg", 4);

		
			declareMusicState("DEATH_SCENE");	
			musicAlias("mx_who_dies", 2);		

			declareMusicState("ROEBUCK_DIED");
			musicAlias("mx_roebuck_died", 8);			

			declareMusicState("POLONSKY_DIED");
			musicAlias("mx_polonsky_died", 8);		

			declareMusicState("COURTYARD_A");
			musicAliasloop("final_battle_ambushed_a", 8, 4);
				
			declareMusicState("COURTYARD_B");
			musicAliasloop("final_battle_ambushed_b", 4, 2);
			musicStinger("mx_theme_stg",6 );

			declareMusicState("END_LEVEL_POLONSKY");
			musicAlias("mx_theme_polonsky_stg",2 );
			//musicAliasloop("mx_underscore",0,4);

			declareMusicState("END_LEVEL_ROEBUCK");
			musicAlias("mx_theme_roebuck_stg",2 );

}

