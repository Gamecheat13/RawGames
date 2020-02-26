//
// file: mp_t6_weapontest_amb.csc
// description: clientside ambient script for mp_t6_weapontest: setup ambient sounds, etc.
// scripter: 		(initial clientside work - laufer)
//

#include clientscripts\mp\_utility; 
#include clientscripts\mp\_ambientpackage;

main()
{
	declareAmbientRoom("outside" );
		setAmbientRoomtone ("outside", "amb_wind_airy_ST", 1, 1);
		setAmbientRoomReverb( "outside", "mp_la_outside", 1, 1 );
		setAmbientRoomContext( "outside", "ringoff_plr", "outdoor" );
		
	activateAmbientRoom( 0, "outside", 0 );	
	

	
	
}

