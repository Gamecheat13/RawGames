//
// file: template_amb.csc
// description: clientside ambient script for template: setup ambient sounds, etc.
// scripter: 		(initial clientside work - laufer)
//

#include clientscripts\_utility; 
#include clientscripts\_ambientpackage;
#include clientscripts\_music;
#include clientscripts\_busing;

main()
{
	//************************************************************************************************
	//                                              Ambient Packages
	//************************************************************************************************

	//declare an ambientpackage, and populate it with elements
	//mandatory parameters are <package name>, <alias name>, <spawnMin>, <spawnMax>
	//followed by optional parameters <distMin>, <distMax>, <angleMin>, <angleMax>
	
//***************
//mak_Base
//***************   

            declareAmbientPackage( "mak_base_pkg" );            

                        addAmbientElement( "mak_base_pkg", "amb_seagull", 30, 60, 300, 2000 );
                        addAmbientElement( "mak_base_pkg", "amb_twigsnap", 30, 120, 10, 500 );
                        
 //***************
 //mak_indoor
 //***************   
 
             declareAmbientPackage( "mak_indoor_pkg" );         

                        
//***************
//mak_bunker
//***************

            declareAmbientPackage( "mak_end_bunker" );
            
            
            
                        
//***************
//mak_deepforest
//***************

            declareAmbientPackage( "mak_deepforest_pkg" );

			addAmbientElement( "mak_deepforest_pkg", "amb_seagull", 30, 60, 300, 2000 );
                        addAmbientElement( "mak_deepforest_pkg", "amb_twigsnap", 30, 120, 10, 500 );
                        addAmbientElement( "mak_deepforest_pkg", "amb_shortbugs", 5, 25, 10, 500 );
	
	//************************************************************************************************
	//                                       ROOMS
	//************************************************************************************************

	//explicitly activate the base ambientpackage, which is used when not touching any ambientPackageTriggers
	//the other trigger based packages will be activated automatically when the player is touching them
	//the same pattern is followed for setting up ambientRooms


 
//***************
//mak_Base
//***************

            declareAmbientRoom( "mak_base_room" );

                        setAmbientRoomTone( "mak_base_room", "none" );
                       setAmbientRoomReverb( "mak_base_room", "mountains", 1, 1 );

 //***************
 //mak_indoor
 //***************
 
             declareAmbientRoom( "mak_indoor_room" ); 
                         setAmbientRoomTone( "mak_indoor_room", "bgt_base" );


//***************
//mak_bunker
//***************

            declareAmbientRoom( "mak_end_bunker" );
                        setAmbientRoomTone( "mak_end_bunker", "bgt_bunker_machine" );
						setAmbientRoomReverb ("mak_end_bunker","stoneroom", 1, 1);
                        
//***************
//mak_deepforest
//***************
			
		declareAmbientRoom( "mak_deepforest_room" );			
                        setAmbientRoomTone( "mak_deepforest_room", "bgt_base" );



//**********************************************************************

//				MUSIC PACKAGES

//**********************************************************************


	

	    declareMusicState("INTRO"); //one shot dont transition until done
	    musicAlias("makin_torture", 0);
	    musicWaitTillDone();

	    declareMusicState("VILLAGE"); //stinger + fadeout
	    musicAliasLoop("village_fight_loop", 0, 6);
	    musicStinger("shaka_sting");
	    musicWaitTillDone();

	    declareMusicState("PATH"); //crossfade
	    musicAliasLoop("makin_stealth", 0, 10);
    	
		declareMusicState("BANZAI");
		musicAlias("mx_banzai_stg", 6);
	    
	    declareMusicState("BEACH_FIGHT"); 
		musicAlias("stg_jungle_hilltop");
	    musicAliasLoop("jungle_depot_fltrd", 0, 6);
       	musicStinger("shaka_sting_beach", 0);
	    musicWaitTillDone();
	    
	    declareMusicState("CREEK"); 
	    musicAliasLoop("wasabe_creek", 0, 2);
  
	    
	    declareMusicState("AMBUSH"); 
	    musicAliasLoop("jungle_depot_fltrd_loud", 0, 4);
		musicStinger("shaka_sting");
		
		declareMusicState("POST_AMBUSH"); 
		musicAliasLoop("makin_stealth", 0, 10);
	    musicStinger("shaka_sting_truck", 7);
	 
		declareMusicState("TRUCK_AMBUSH");
		musicAlias("mx_truck_ambush", 0);
		musicAliasloop ("makin_stealth",0,4);

		declareMusicState("BOMB_IS_ARMING");
		musicAlias ("mx_bomb_arming",4);
		
		declareMusicState("BOMB_IS_ARMED");
		musicAliasLoop("mx_bomb_armed_run", 4, 6);

		declareMusicState("ATTACKED");
		musicAlias("mx_level_end", 0);
		

	    declareMusicState("ENDLEVEL");
	   
	    
	//END LEVEL MUSIC


		declareBusState("AMBUSH");
		busFadeTime(0.1);
		busVolumesExcept("full_vol","voice","explosion", 0.0);		


		declareBusState("TRUCK");
		busFadeTime(1.0);
		busVolumesExcept("full_vol","voice", "ui","pis_1st","smg_1st","rfl_1st", 0.6);


		declareBusState("RESET");
		busFadeTime(2);
		busVolumeAll(1);

		declareBusState("RESET_SLOW");
		busFadeTime(5);
		busVolumeAll(1);


		declareBusState("ATTACKED");
		busFadeTime(0.25);
		busVolumesExcept("music", "full_vol","ambience", "explosion", 0.5);
		busvolume("pis_1st", 0.9);
	
		declareBusState("ENDING");
		busFadeTime(1.0);
		busVolumesExcept("music","explosion", "voice", 0.5);
		busvolume("pis_1st", 0.9);

		declareBusState("LEVEL_OUT");
		busFadeTime(7.5);
		busVolumeAll(0);
		

	
	//************************************************************************************************
	//                                      ACTIVATE DEFAULT AMBIENT SETTINGS
	//************************************************************************************************

  activateAmbientPackage( 0, "mak_base_pkg", 0 );
  activateAmbientRoom( 0, "mak_base_room", 0 );

}

