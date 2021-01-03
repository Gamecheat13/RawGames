#using scripts\codescripts\struct;

    	   	                                                                                                                         	                                                                                                                                                                                                                                                                                                                                                                    	        	     	             	    	   	                           	                               	                                	                                                              	                                                                                                              	                            	                                     	                                       	                                                               	   	                  	       	                                                    	                   	                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                      	                                                                                        	           	                        	                                            	                                             	                                                   	                                                             	                                                         	                                                                    	                                                                                                                                                                                                    	                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                     	                                                              	                                                          	                                   	                                   	                                                    	                                       

//
// file: cp_ctistaert_test_amb.gsc
// description: level ambience script for cp_ctistaert_test
// scripter: 
//



function main()
{
	//declare an ambientpackage, and populate it with elements
	//mandatory parameters are <package name>, <alias name>, <spawnMin>, <spawnMax>
	//followed by optional parameters <distMin>, <distMax>, <angleMin>, <angleMax>
//	_ambientpackage::declareAmbientPackage( "outdoors_pkg" );
//	_ambientpackage::addAmbientElement( "outdoors_pkg", "elm_dog1", 3, 6, 1800, 2000, 270, 450 );
//	_ambientpackage::addAmbientElement( "outdoors_pkg", "elm_dog2", 5, 10 );
//	_ambientpackage::addAmbientElement( "outdoors_pkg", "elm_dog3", 10, 20 );
//	_ambientpackage::addAmbientElement( "outdoors_pkg", "elm_donkey1", 25, 35 );
//	_ambientpackage::addAmbientElement( "outdoors_pkg", "elm_horse1", 10, 25 );

//	_ambientpackage::declareAmbientPackage( "west_pkg" );
//	_ambientpackage::addAmbientElement( "west_pkg", "elm_insect_fly", 2, 8, 0, 150, 345, 375 );
//	_ambientpackage::addAmbientElement( "west_pkg", "elm_owl", 3, 10, 400, 500, 269, 270 );
//	_ambientpackage::addAmbientElement( "west_pkg", "elm_wolf", 10, 15, 100, 500, 90, 270 );
//	_ambientpackage::addAmbientElement( "west_pkg", "animal_chicken_idle", 3, 12 );
//	_ambientpackage::addAmbientElement( "west_pkg", "animal_chicken_disturbed", 10, 30 );

//	_ambientpackage::declareAmbientPackage( "northwest_pkg" );
//	_ambientpackage::addAmbientElement( "northwest_pkg", "elm_wind_buffet", 3, 6 );
//	_ambientpackage::addAmbientElement( "northwest_pkg", "elm_rubble", 5, 10 );
//	_ambientpackage::addAmbientElement( "northwest_pkg", "elm_industry", 10, 20 );
//	_ambientpackage::addAmbientElement( "northwest_pkg", "elm_stress", 5, 20, 200, 2000 );

	//explicitly activate the base ambientpackage, which is used when not touching any ambientPackageTriggers
	//the other trigger based packages will be activated automatically when the player is touching them
//	_ambientpackage::activateAmbientPackage( "outdoors_pkg", 0 );


	//the same pattern is followed for setting up ambientRooms
//	_ambientpackage::declareAmbientRoom( "outdoors_room" );
//	_ambientpackage::setAmbientRoomTone( "outdoors_room", "amb_shanty_ext_temp" );

//	_ambientpackage::declareAmbientRoom( "west_room" );
//	_ambientpackage::setAmbientRoomTone( "west_room", "bomb_tick" );

//	_ambientpackage::declareAmbientRoom( "northwest_room" );
//	_ambientpackage::setAmbientRoomTone( "northwest_room", "weap_sniper_heartbeat" );

//	_ambientpackage::activateAmbientRoom( "outdoors_room", 0 );
}
