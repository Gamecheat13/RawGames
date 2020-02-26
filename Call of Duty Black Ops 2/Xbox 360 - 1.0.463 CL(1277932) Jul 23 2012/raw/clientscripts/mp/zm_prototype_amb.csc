//
// file: template_amb.csc
// description: clientside ambient script for template: setup ambient sounds, etc.
// scripter: 		(initial clientside work - laufer)
//

#include clientscripts\mp\_utility; 
#include clientscripts\mp\_ambientpackage;
#include clientscripts\mp\_music;

main()
{
	//************************************************************************************************
	//                                              Ambient Packages
	//************************************************************************************************

	//declare an ambientpackage, and populate it with elements
	//mandatory parameters are <package name>, <alias name>, <spawnMin>, <spawnMax>
	//followed by optional parameters <distMin>, <distMax>, <angleMin>, <angleMax>
	
 		
 		//Enclosed
 		declareAmbientRoom( "zombies" );	
    declareAmbientPackage( "zombies" );
 		setAmbientRoomReverb ("zombies","RV_ZOMBIES_PROTO_MEDIUM_ROOM", 1, 1);
 		setAmbientRoomContext( "zombies", "ringoff_plr", "indoor" );
 		addAmbientElement( "zombies", "amb_spooky_2d", 5, 8, 300, 2000 );
 	  
 	  //Upstairs Semi Open	
 		declareAmbientRoom( "upstairs" );	
    declareAmbientPackage( "upstairs" );
 		setAmbientRoomReverb ("upstairs","RV_ZOMBIES_PROTO_UPSTAIRS", 1, 1);
 		setAmbientRoomContext( "upstairs", "ringoff_plr", "indoor" );
 		addAmbientElement( "upstairs", "amb_spooky_2d", 5, 8, 300, 2000 );
 		
 		//Downstairs Semi Open	
 		declareAmbientRoom( "downstairs" );	
    declareAmbientPackage( "downstairs" );
 		setAmbientRoomReverb ("downstairs","RV_ZOMBIES_PROTO_DOWNSTAIRS", 1, 1);
 		setAmbientRoomContext( "downstairs", "ringoff_plr", "indoor" );
 		addAmbientElement( "downstairs", "amb_spooky_2d", 5, 8, 300, 2000 );
 		
	//************************************************************************************************
	//                                      ACTIVATE DEFAULT AMBIENT SETTINGS
	//************************************************************************************************

  activateAmbientPackage( 0, "zombies", 0 );
  activateAmbientRoom( 0, "zombies", 0 );



  declareMusicState("SPLASH_SCREEN"); //one shot dont transition until done
	musicAlias("mx_splash_screen", 12);	
	musicwaittilldone();
	
  //C. Ayers 9/10/10: Adding these in for future use, once this branch has what I'll be submitting on Treyarch branch	
	declareMusicState("WAVE");
	 musicAliasloop("mus_zombie_wave_loop", 0, 4);

	declareMusicState("EGG");
	  musicAlias("mus_prototype_egg", 1 );
				
	declareMusicState( "SILENCE" );
	    musicAlias("null", 1 );	
	
//t6todo	thread clientscripts\_waw_zombiemode_radio::init();
	thread play_fire_loops();
}
play_fire_loops()
{
	fire = clientscripts\mp\_audio::playloopat ("fire_med", (164.8,-63.5, 127.1));
	
}
