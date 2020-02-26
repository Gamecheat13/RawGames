//
// file: mp_cracked_amb.csc
// description: clientside ambient script for mp_cracked: setup ambient sounds, etc.
// scripter: 		(initial clientside work - laufer)
//

#include clientscripts\mp\_utility; 
#include clientscripts\mp\_ambientpackage;
#include clientscripts\mp\_music;
#include clientscripts\mp\_busing;

main()
{
		declareAmbientPackage( "default" );
		declareAmbientRoom( "default" );
			setAmbientRoomReverb( "default", "cracked_outdoor", 1, 1 );
			//setAmbientRoomTone( "default", "amb_default_outdoor" );
			setAmbientRoomContext( "default", "ringoff_plr", "outdoor" );
		
		declareAmbientPackage( "cracked_small_room" );
		declareAmbientRoom( "cracked_small_room" );
			setAmbientRoomReverb( "cracked_small_room", "cracked_small_room", 1, 1 );
			setAmbientRoomContext( "cracked_small_room", "ringoff_plr", "indoor" );
			
		declareAmbientPackage( "cracked_partial_room" );
		declareAmbientRoom( "cracked_partial_room" );
			setAmbientRoomReverb( "cracked_partial_room", "cracked_partial_room", 1, 1 );
			setAmbientRoomContext( "cracked_partial_room", "ringoff_plr", "indoor" );
										
		declareAmbientPackage( "cracked_rubble_room" );
		declareAmbientRoom( "cracked_rubble_room" );
			setAmbientRoomReverb( "cracked_rubble_room", "cracked_rubble_room", 1, 1 );
			setAmbientRoomContext( "cracked_rubble_room", "ringoff_plr", "outdoor" );
			
		declareAmbientPackage( "cracked_alley" );
		declareAmbientRoom( "cracked_alley" );
			setAmbientRoomReverb( "cracked_alley", "cracked_alley", 1, 1 );
			setAmbientRoomContext( "cracked_alley", "ringoff_plr", "outdoor" );
			

		
	 
	 
	 	thread snd_fx_create();

		activateAmbientRoom( 0, "default", 0 );
		
		thread sound_loopers_start();
}
snd_fx_create ()
{
	// TODO make the audio init happen after FX and put snd_play_auto_fx in _audio
	wait (1);
	
	
	
	
	
	clientscripts\mp\_audio::snd_play_auto_fx( "fx_fire_lg", "amb_fire_xlrg");		
	clientscripts\mp\_audio::snd_play_auto_fx( "fx_fire_md", "amb_fire_lrg");		
	clientscripts\mp\_audio::snd_play_auto_fx( "fx_fire_sm", "amb_fire_med");		
	clientscripts\mp\_audio::snd_play_auto_fx( "fx_fire_sm_smolder", "amb_fire_sml");	
	clientscripts\mp\_audio::snd_play_auto_fx( "fx_fire_detail_sm", "amb_fire_sml");	
	//clientscripts\mp\_audio::snd_play_auto_fx( "a_smk_plume_xlg_tall_blk", "amb_smk_plume_xlg_tall_blk");		
	//clientscripts\mp\_audio::snd_play_auto_fx( "a_smk_field_sm", "amb_smk_field_sm");		
	//clientscripts\mp\_audio::snd_play_auto_fx( "a_smk_field_md", "amb_smk_field_md");		
	//clientscripts\mp\_audio::snd_play_auto_fx( "a_smk_field_lg", "amb_smk_field_lg");		
	//clientscripts\mp\_audio::snd_play_auto_fx( "a_smk_plume_lg_blk", "amb_smk_plume_lg_blk");		
	//clientscripts\mp\_audio::snd_play_auto_fx( "a_smk_plume_xlg_blk", "amb_smk_plume_xlg_blk");		
	//clientscripts\mp\_audio::snd_play_auto_fx( "a_smk_smolder_sm", "amb_smk_smolder_sm");		
	//clientscripts\mp\_audio::snd_play_auto_fx( "a_debris_papers", "amb_debris_papers");		
	//clientscripts\mp\_audio::snd_play_auto_fx( "a_fumes_vent_sm", "amb_fumes_vent_sm");		
	//clientscripts\mp\_audio::snd_play_auto_fx( "a_pipe_steam_md", "amb_pipe_steam_md");		
	//clientscripts\mp\_audio::snd_play_auto_fx( "a_fire_md_smolder", "amb_fire_md_smolder");		
	//clientscripts\mp\_audio::snd_play_auto_fx( "a_fire_sm_smolder", "amb_fire_sm_smolder");		
	//clientscripts\mp\_audio::snd_play_auto_fx( "a_dust_crumble_int_sm", "amb_dust_crumble_int_sm");		
	//clientscripts\mp\_audio::snd_play_auto_fx( "a_sand_gust_sm_os", "amb_sand_gust_sm_os");		
		
	
	
	
	
	
	
		
}	

sound_loopers_start()
{
	//Loopers
	thread sound_playloop_sound ((-2044,-1779,-133),"amb_flies");
}
sound_playloop_sound ( org, alias)
{
	 sound = spawn( 0, org, "script_origin" );
	 sound playloopsound ( alias );
}