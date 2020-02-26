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
	
	declareAmbientPackage( "default" );
		//addAmbientElement( "default", "bomb_far_falloff", 5, 20,100, 300 );
		addAmbientElement( "default", "amb_metal", 1, 5, 50, 300 );
		
	declareAmbientPackage( "at_sea" );
		//addAmbientElement( "at_sea", "bomb_far_falloff", 5, 20,100, 300 );	
	
	//************************************************************************************************
	//                                       ROOMS
	//************************************************************************************************

	//explicitly activate the base ambientpackage, which is used when not touching any ambientPackageTriggers
	//the other trigger based packages will be activated automatically when the player is touching them
	//the same pattern is followed for setting up ambientRooms

	declareAmbientRoom( "default" );
		setAmbientRoomTone( "default", "plane_interor" );
		setAmbientRoomReverb( "default", "forest", 1, 1);

	declareAmbientRoom( "at_sea" );
		setAmbientRoomTone( "at_sea", "at_sea" );
		setAmbientRoomReverb( "at_sea", "forest", 1, 1);
	
	//************************************************************************************************
	//                                      ACTIVATE DEFAULT AMBIENT SETTINGS
	//************************************************************************************************

	activateAmbientRoom( 0, "default", 0 );
	activateAmbientPackage( 0, "default", 0 );	

	//**********************************************************************
	//				MUSIC PACKAGES
	//**********************************************************************


	//TEchNo SECTION

	    declareMusicState("INTRO"); //one shot dont transition until done
		    musicAlias("mx_intro", 3);	  

		 declareMusicState("MERCH_FIRST_PASS");
			 musicAliasloop("mx_merch_loop_a", 0, 1);
			
		declareMusicState("FLAK_BURST");
			musicAlias ("mx_merch_stg_a", 0);	

		declareMusicState ("TURNING_1");
			musicAlias ("mx_turning_1", 0);	
		
		 declareMusicState("MERCH_SECOND_PASS");
			 musicAliasloop("mx_merch_loop_b", 0, 4);

		 declareMusicState("MERCH_LAST_PASS");
			musicAliasloop ("mx_merch_loop_c", 0, 1);
			musicStinger("mx_merch_stg_c", 5);

		declareMusicState("MERCH_DONE");
			musicAlias ("mx_mid_igc", 0);	

		declareMusicState("ZEROS_ONE");
			musicAliasloop("mx_zeros_a",6 ,6);

		declareMusicState("LANDING");
			musicAlias("mx_landing_a",0 );

		declareMusicState("RESCUE_A");
			musicAliasloop("mx_rescue_a",0 ,2);

		declareMusicState("TAKE_OFF");
			musicAliasloop("mx_zeros_a",6 ,2);

		declareMusicState("LEVEL_END");
			musicAlias("mx_level_end", 0);

	//SET BUSSES

	declareBusState("SHHH_PROJECTILES");
	busFadeTime(.25);
	//busVolumesExcept("music", "full_vol","voice", "ui", "ambience", "weapons", 0.8);
	busVolume("projectile", 0.5);
	busVolume("music", 0.9);
	busVolume("hvy_wpn", 0.92);
	busVolume("ambience",0.5 );





}

