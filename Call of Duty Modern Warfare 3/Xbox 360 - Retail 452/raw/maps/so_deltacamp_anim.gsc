#using_animtree( "generic_human" );
main()
{
	anims();
	radio();
	fx();
}

anims()
{
	level.scr_anim[ "generic" ][ "sandman_idle" ][ 0 ]		= %killhouse_sas_price_idle;
	level.scr_anim[ "generic" ][ "truck_idle" ][ 0 ]		= %killhouse_gaz_idleB;
	level.scr_anim[ "generic" ][ "grinch_idle" ][ 0 ]		= %sitting_guard_loadAK_idle;
}

radio()
{
	// -.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-. //
	//		Regular (Version 1)
	// -.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-. //
	
	// Sandman
	level.scr_sound[ "generic" ][ "so_deltacamp_snd_thanks" ] = "so_deltacamp_snd_thanks";
	
	level.scr_sound[ "generic" ][ "so_deltacamp_snd_nicelydone" ] = "so_deltacamp_snd_nicelydone";
	level.scr_sound[ "generic" ][ "so_deltacamp_snd_nogood" ] = "so_deltacamp_snd_nogood";
	
	// Truck
	level.scr_sound[ "generic" ][ "so_deltacamp_trk_youreup" ] = "so_deltacamp_trk_youreup";
	level.scr_sound[ "generic" ][ "so_deltacamp_trk_startingarea" ] = "so_deltacamp_trk_startingarea";
	level.scr_sound[ "generic" ][ "so_deltacamp_trk_owntoys" ] = "so_deltacamp_trk_owntoys";
	
	level.scr_radio[ "so_deltacamp_trk_tangos" ] = "so_deltacamp_trk_tangos";
	level.scr_radio[ "so_deltacamp_trk_vehicles" ] = "so_deltacamp_trk_vehicles";
	level.scr_radio[ "so_deltacamp_trk_targets" ] = "so_deltacamp_trk_targets";
	level.scr_radio[ "so_deltacamp_trk_clear" ] = "so_deltacamp_trk_clear";
	level.scr_radio[ "so_deltacamp_trk_knife" ] = "so_deltacamp_trk_knife";
	level.scr_radio[ "so_deltacamp_trk_upthestairs" ] = "so_deltacamp_trk_upthestairs";
	level.scr_radio[ "so_deltacamp_trk_allclear" ] = "so_deltacamp_trk_allclear";
	level.scr_radio[ "so_deltacamp_trk_dogs" ] = "so_deltacamp_trk_dogs";
	level.scr_radio[ "so_deltacamp_trk_bridgeclear" ] = "so_deltacamp_trk_bridgeclear";
	
	level.scr_radio[ "so_deltacamp_trk_moveup" ] = "so_deltacamp_trk_moveup";
	
	level.scr_radio[ "so_deltacamp_trk_civilians" ] = "so_deltacamp_trk_civilians";
	level.scr_radio[ "so_deltacamp_trk_dontshoot" ] = "so_deltacamp_trk_dontshoot";
	
	// -.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-. //
	//		Breach (Version 2)
	// -.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-. //
	
	// Course Comments
	level.scr_radio[ "so_trainer2_trk_breach" ] = "so_trainer2_trk_breach";
	level.scr_radio[ "so_trainer2_trk_roomclear" ] = "so_trainer2_trk_roomclear";
	level.scr_radio[ "so_trainer2_trk_sniper" ] = "so_trainer2_trk_sniper";
	level.scr_radio[ "so_trainer2_trk_anothercharge" ] = "so_trainer2_trk_anothercharge";
	level.scr_radio[ "so_trainer2_trk_downstairs" ] = "so_trainer2_trk_downstairs";
	level.scr_radio[ "so_trainer2_trk_uponbridge" ] = "so_trainer2_trk_uponbridge";
	level.scr_radio[ "so_trainer2_trk_lastgroup" ] = "so_trainer2_trk_lastgroup";
	level.scr_radio[ "so_deltacamp_trk_sprinttofinish" ] = "so_deltacamp_trk_sprinttofinish";
	
	// Finish Comments
	level.scr_radio[ "so_deltacamp_trk_runthecourse" ] = "so_deltacamp_trk_runthecourse";
	level.scr_radio[ "so_deltacamp_trk_notgood" ] = "so_deltacamp_trk_notgood";
	level.scr_radio[ "so_deltacamp_trk_betterthan" ] = "so_deltacamp_trk_betterthan";
	level.scr_radio[ "so_deltacamp_trk_teamrecord" ] = "so_deltacamp_trk_teamrecord";
	level.scr_radio[ "so_deltacamp_trk_personalbest" ] = "so_deltacamp_trk_personalbest";
	
	// -.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-. //
	//		Both (Version 2)
	// -.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-. //
	
	// Nag for player to start
	level.scr_radio[ "so_deltacamp_trk_yourgo" ] = "so_deltacamp_trk_yourgo";
	level.scr_radio[ "so_deltacamp_trk_whenever" ] = "so_deltacamp_trk_whenever";
	
	level.scr_radio[ "so_deltacamp_trk_showinoff" ] = "so_deltacamp_trk_showinoff";
}

fx()
{
	
}