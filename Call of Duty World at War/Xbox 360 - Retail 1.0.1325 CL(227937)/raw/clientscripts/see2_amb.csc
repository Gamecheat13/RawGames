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
	//see2_Base
	//***************   
	
	            declareAmbientPackage( "see2_base_pkg" );            
	
	                        //addAmbientElement( "see2_base_pkg", "amb_dog_bark", 30, 60, 300, 2000 );
	                        //addAmbientElement( "see2_base_pkg", "amb_birds", 30, 60, 1000, 4000 );
	                        //addAmbientElement( "see2_base_pkg", "amb_raven", 30, 60, 1000, 4000 );
	                        
	 //***************
	 //see2_interior_pkg
	 //***************   
	 
	             declareAmbientPackage( "see2_interior_pkg" );        	
	
	//************************************************************************************************
	//                                       ROOMS
	//************************************************************************************************

	//explicitly activate the base ambientpackage, which is used when not touching any ambientPackageTriggers
	//the other trigger based packages will be activated automatically when the player is touching them
	//the same pattern is followed for setting up ambientRooms

	 
	//***************
	//see2_Base
	//***************
	
	            declareAmbientRoom( "see2_outdoor" );	
	                        //setAmbientRoomTone( "see2_outdoor", "outdoor_room" );
							setAmbientRoomReverb("see2_outdoor", "FOREST",1,1);
	
	 //***************
	 //see2_interior_room
	 //***************
	 
	             declareAmbientRoom( "see2_interior_room" );
	 
	                         //setAmbientRoomTone( "see2_interior_room", "indoor_room" );
	

  activateAmbientPackage( 0, "see2_base_pkg", 0 );
	activateAmbientRoom( 0, "see2_outdoor", 0 );
	 


	//**********************************************************************
	//				MUSIC PACKAGES
	//**********************************************************************
	    declareMusicState("INTRO"); //one shot dont transition until done
	    musicAlias("mx_intro", 0);	  
		musicwaittilldone();

	    declareMusicState("FIRST_FIGHT"); 
	    musicAliasloop("mx_battle_loop", 0, 2);	 

	    declareMusicState("LEVEL_END"); 
	    musicAlias("mx_level_end", 1);	 



//SET BUSSES

	declareBusState("TANKS");
	busFadeTime(.25);
	busVolumesExcept("music", "full_vol","voice", "ui", "vehicle_mp", "explosion", 0.8);



}

