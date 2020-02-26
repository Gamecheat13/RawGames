//
// file: angola_amb.csc
// description: clientside ambient script for angola: setup ambient sounds, etc.
// scripter: 		(initial clientside work - laufer)
//

#include clientscripts\_utility; 
#include clientscripts\_ambientpackage;
#include clientscripts\_music;
#include clientscripts\_audio;

main()
{
	declareAmbientRoom( "outdoor" );
		setAmbientRoomTone ("outdoor","blk_outdoor_bg", .5, .5);
		setAmbientRoomReverb ("outdoor","angola_outside", 1, 1);
		setAmbientRoomContext( "outdoor", "ringoff_plr", "outdoor" );
		declareAmbientPackage( "outdoor" );
		
	declareAmbientRoom( "riverbed" );
		setAmbientRoomReverb ("riverbed","angola_riverbed", 1, 1);
		setAmbientRoomContext( "riverbed", "ringoff_plr", "outdoor" );
		declareAmbientPackage( "riverbed" );
		
	declareAmbientRoom( "boat_int" );
		setAmbientRoomReverb ("boat_int","angola_boat_cabin", 1, 1);
		setAmbientRoomContext( "boat_int", "ringoff_plr", "outdoor" );
		declareAmbientPackage( "boat_int" );

	declareAmbientRoom( "small_room" );
		setAmbientRoomReverb ("small_room","angola_smallroom", 1, 1);
		setAmbientRoomContext( "small_room", "ringoff_plr", "indoor" );
		declareAmbientPackage( "small_room" );		
		
	declareAmbientRoom( "forest" );
		setAmbientRoomReverb ("forest","angola_forest", 1, 1);
		setAmbientRoomContext( "forest", "ringoff_plr", "outdoor" );
		declareAmbientPackage( "forest" );	
		
	declareAmbientRoom( "village" );
		setAmbientRoomReverb ("village","angola_village", 1, 1);
		setAmbientRoomContext( "village", "ringoff_plr", "outdoor" );
		declareAmbientPackage( "village" );	
		
	declareAmbientRoom( "container" );
		setAmbientRoomReverb ("container","angola_container", 1, 1);
		setAmbientRoomContext( "container", "ringoff_plr", "outdoor" );
		declareAmbientPackage( "container" );	
		
		
	activateAmbientPackage( 0, "outdoor", 0 );
	activateAmbientRoom( 0, "outdoor", 0 );		
	
	
	//MUSIC STATES
	declaremusicState ("ANGOLA_SAVANNAH_BATTLE");
		musicAlias ("mus_angola_savannah", 0);
		musicAliasloop ("NULL", 0, 0);
	

		
		
	level thread buffel_fire();
	//level thread intro_sounds();	
	level thread set_alouette_context_ext();
	level thread heli_snapshot();
	level thread walla_sounds();
	level thread set_default_snapshot();
//	level thread set_intro_snapshot();
}

heli_snapshot()
{
	while (1)
	{
		level waittill ( "heli_int" );
		snd_set_snapshot ( "spl_angola_chopper_int" );	
	 	setsoundcontext( "f35", "interior" );
		wait (.5);
		level waittill ( "heli_done" );
		snd_set_snapshot ( "cmn_no_wind" );	
		setsoundcontext ( "f35", "exterior" );
	}
}

buffel_fire()
{
//	ent = spawn ("script_origin", (-3521, -49, -317));
//	ent playloopsound ("amb_buffel_fire");
	
	level waittill ("intro");
	
	soundloopemitter ("amb_fire_intro", (-3767, 186, -309) );
	snd_set_snapshot ( "spl_angola_intro" );	
	wait(12);
	snd_set_snapshot ( "cmn_no_wind" );
	soundstoploopemitter( "amb_fire_intro", (-3767, 186, -309));
}

/*
intro_sounds()
{
	level waittill ( "intr" );
	wait (5.35);
	playsound( 0, "fly_intro", (0,0,0) );	
	wait (.4);
	playsound( 0, "blk_screams", (-3521, -49, -317) );
	wait (8);
	playsound( 0, "blk_death", (-3521, -49, -317) );	
	
}
*/

walla_sounds()
{
	level waittill( "pgw" );
	
	soundloopemitter( "amb_battle_walla_l", (4613, 1494, 37) );
	soundloopemitter( "amb_battle_walla_r", (4089, 3108, 72) );
	
	level waittill( "sgw" );
	
	soundstoploopemitter( "amb_battle_walla_l", (4613, 1494, 37) );
	soundstoploopemitter( "amb_battle_walla_r", (4089, 3108, 72) );
}

set_alouette_context_ext()
{
	 waitforclient(0);
	 setsoundcontext( "f35", "exterior" );
}

set_intro_snapshot()
{
	level waittill ( "audio_intro" );
	snd_set_snapshot ( "spl_angola_intro" );
}
set_default_snapshot()
{
	level waittill ("pobws");	
	snd_set_snapshot ( "default" );
}