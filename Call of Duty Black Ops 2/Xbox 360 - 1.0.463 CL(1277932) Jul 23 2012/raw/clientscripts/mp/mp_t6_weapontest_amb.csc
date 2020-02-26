//
// file: mp_t6_weapontest_amb.csc
// description: clientside ambient script for mp_t6_weapontest: setup ambient sounds, etc.
// scripter: 		(initial clientside work - laufer)
//

#include clientscripts\mp\_utility; 
#include clientscripts\mp\_ambientpackage;

main()
{
	declareAmbientRoom( "outside" , true );
		setAmbientRoomtone ("outside", "amb_wind_airy_ST", 1, 1);
		setAmbientRoomReverb( "outside", "gen_city", 1, 1 );
		setAmbientRoomContext( "outside", "ringoff_plr", "outdoor" );
		
	declareAmbientRoom( "weapontest_room1" );
	setAmbientRoomTone ("weapontest_room1","amb_wind_airy_ST", 3, 3);
	setAmbientRoomReverb ("weapontest_room1","gen_mediumroom", 1, 1);
	setAmbientRoomContext( "weapontest_room1", "ringoff_plr", "indoor" );
	declareAmbientPackage( "weapontest_room1" );
	
	declareAmbientRoom( "weapontest_room2" );
	setAmbientRoomTone ("weapontest_room2","amb_wind_airy_ST", 3, 3);
	setAmbientRoomReverb ("weapontest_room2","gen_largeroom", 1, 1);
	setAmbientRoomContext( "weapontest_room2", "ringoff_plr", "indoor" );
	declareAmbientPackage( "weapontest_room2" );
		
	activateAmbientRoom( 0, "outside", 0 );	
	

	
	
}

