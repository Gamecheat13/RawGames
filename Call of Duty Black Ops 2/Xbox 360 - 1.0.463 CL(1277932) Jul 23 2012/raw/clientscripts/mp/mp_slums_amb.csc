//
// file: mp_slums_amb.csc
// description: clientside ambient script for mp_slums: setup ambient sounds, etc.
// scripter: 		(initial clientside work - laufer)
//

#include clientscripts\mp\_utility; 
#include clientscripts\mp\_ambientpackage;

main()
{

	
	
	declareAmbientRoom("slums_outside", true );
		setAmbientRoomReverb( "slums_outside", "gen_outdoor", 1, 1 );
		setAmbientRoomContext( "slums_outside", "ringoff_plr", "outdoor" );

		
	declareAmbientRoom("slums_garage" );
		setAmbientRoomReverb( "slums_garage", "gen_stoneroom", 1, 1 );
		setAmbientRoomContext( "slums_garage", "ringoff_plr", "indoor" );

			
	declareAmbientRoom("slums_broken_bldg" );
		setAmbientRoomReverb( "slums_broken_bldg", "gen_smallroom", 1, 1 );
		setAmbientRoomContext( "slums_broken_bldg", "ringoff_plr", "indoor" );

			
	declareAmbientRoom("slums_broken_bldg_md" );
		setAmbientRoomReverb( "slums_broken_bldg_md", "gen_mediumroom", 1, 1 );
		setAmbientRoomContext( "slums_broken_bldg_md", "ringoff_plr", "indoor" );

			
	declareAmbientRoom("slums_over_hang" );
		setAmbientRoomReverb( "slums_over_hang", "gen_smallroom", 1, 1 );
		setAmbientRoomContext( "slums_over_hang", "ringoff_plr", "outdoor" );

	
	declareAmbientRoom("slums_mtl_shed_open" );
		setAmbientRoomReverb( "slums_mtl_shed_open", "gen_smallroom", 1, 1 );
		setAmbientRoomContext( "slums_mtl_shed_open", "ringoff_plr", "outdoor" );

			
	declareAmbientRoom("slums_alley" );
		setAmbientRoomReverb( "slums_alley", "gen_smallroom", 1, 1 );
		setAmbientRoomContext( "slums_alley", "ringoff_plr", "indoor" );

			
			
			
	//************************************************************************************************
	//                                      ACTIVATE DEFAULT AMBIENT SETTINGS
	//************************************************************************************************

		//activateAmbientPackage( 0, "slums_outside", 0 );
		activateAmbientRoom( 0, "slums_outside", 0 );	

	level thread setup_ambient_fx_sounds();
	thread snd_play_loopers();		
}
snd_play_loopers()
{
	//clientscripts\_audio::playloopat( "amb_water_int_trans_rumb", (2518, 4050, 373));	
}
setup_ambient_fx_sounds()
{
	//snd_play_auto_fx ( "fx_fire_line_xsm", "amb_fire_sml", 0, 0, 0, true );
	
}