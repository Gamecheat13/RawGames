#include maps\_utility;


#include maps\_ambientpackage;

main()
{
	
	
	//************************************************************************************************
	//                                              Ambient Packages
	//************************************************************************************************
	
	 
	
	 
	
	//***************
	//see2_Base
	//***************   
	
	            //declareAmbientPackage( "see2_base_pkg" );            
	
	                        //addAmbientElement( "see2_base_pkg", "amb_dog_bark", 30, 60, 300, 2000 );
	                        //addAmbientElement( "see2_base_pkg", "amb_birds", 30, 60, 1000, 4000 );
	                        //addAmbientElement( "see2_base_pkg", "amb_raven", 30, 60, 1000, 4000 );
	                        
	 //***************
	 //see2_interior_pkg
	 //***************   
	 
	             //declareAmbientPackage( "see2_interior_pkg" );         
	
	
	            
			
	
	           
	//************************************************************************************************
	//                                              ROOMS
	//************************************************************************************************
	
	 
	//***************
	//see2_Base
	//***************
	
	            //declareAmbientRoom( "see2_outdoor" );
	
	                        //setAmbientRoomTone( "see2_outdoor", "outdoor_room" );
	
	 //***************
	 //see2_interior_room
	 //***************
	 
	             //declareAmbientRoom( "see2_interior_room" );
	 
	                         //setAmbientRoomTone( "see2_interior_room", "indoor_room" );
	
	
	
	
	//************************************************************************************************
	
	//                                              ACTIVATE DEFAULT AMBIENT SETTINGS
	
	//************************************************************************************************
	
	            //activateAmbientPackage( "see2_base_pkg", 0 );
	
			//activateAmbientRoom( "see2_outdoor", 0 );
	 
	
	 
	
	//*************************************************************************************************
	
	//                                              START SCRIPTS
	
	//*************************************************************************************************
	
	
		level thread walla_audio_notify();

}

walla_audio_notify()
{
	level waittill("walla");
	walla1 = getent("walla1","targetname");
	walla2 = getent("walla2","targetname");
	chug = getent("chug","targetname");
	whistle = getent("whistle","targetname");
	
	//whistle playsound("train_whistle");
	
	walla1 playloopsound("See1_IGD_703A_RURS",1);
	chug playloopsound("train_chug",1);
	wait(5);
	walla2 playloopsound("See1_IGD_703A_RURS",1);
	
	level waittill("audio_fade");
	playsoundatposition("train_whistle", whistle.origin);
	
	walla1 stoploopsound(4);
	walla2 stoploopsound(4);

}