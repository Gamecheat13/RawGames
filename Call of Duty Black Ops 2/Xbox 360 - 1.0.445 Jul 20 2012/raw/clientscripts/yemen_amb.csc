//
// file: yemen_amb.csc
// description: clientside ambient script for yemen: setup ambient sounds, etc.
// scripter: 		(initial clientside work - laufer)
//

#include clientscripts\_utility; 
#include clientscripts\_ambientpackage;

#include clientscripts\_music;
#include clientscripts\_busing;
#include clientscripts\_audio;
main()
{
	snd_set_snapshot("spl_yemen_fade_in");	
	
	declareAmbientRoom( "desert_outside" );
	setAmbientRoomTone ("desert_outside","amb_wind_bg_2d", .5, .5);
	setAmbientRoomReverb ("desert_outside","spl_yemen_hills", 1, 1);
	setAmbientRoomContext( "desert_outside", "ringoff_plr", "outdoor" );
	declareAmbientPackage( "desert_outside" );

 			
	declareAmbientRoom( "hills_outside" );
	setAmbientRoomTone ("hills_outside","blk_desert_wind_bg", .5, .5);
	setAmbientRoomReverb ("hills_outside","spl_yemen_hills", 1, 1);
	setAmbientRoomContext( "hills_outside", "ringoff_plr", "outdoor" );
	declareAmbientPackage( "hills_outside" );

	
	//Set this room for the open-air places between buildings and ruins without roofs by the weapon cache - set the reverb for the walls but left the ringoff
	declareAmbientRoom( "open_air_enclosure" );
	setAmbientRoomTone ("open_air_enclosure","amb_wind_bg_2d", .5, .5);
	setAmbientRoomReverb ("open_air_enclosure","spl_yemen_open", 1, 1);
	setAmbientRoomContext( "open_air_enclosure", "ringoff_plr", "outdoor" );
	declareAmbientPackage( "open_air_enclosure" );
	
	declareAmbientRoom( "stone_room_intro" );
	setAmbientRoomReverb ("stone_room_intro","spl_yemen_stone_intro", 1, 1);
	setAmbientRoomContext( "stone_room_intro", "ringoff_plr", "indoor" );
	declareAmbientPackage( "stone_room_intro" );
	
	declareAmbientRoom( "entry_intro" );
	setAmbientRoomReverb ("entry_intro","spl_yemen_entry_intro", 1, 1);
	setAmbientRoomContext( "entry_intro", "ringoff_plr", "indoor" );
	declareAmbientPackage( "entry_intro" );
	
	 declareAmbientRoom( "courtyard_intro" );
	setAmbientRoomReverb ("courtyard_intro","spl_yemen_speech", 1, 1);
	setAmbientRoomContext( "courtyard_intro", "ringoff_plr", "outdoor" );
	declareAmbientPackage( "courtyard_intro" );
 	
	declareAmbientRoom( "partial_room" );
	setAmbientRoomReverb ("partial_room","spl_yemen_partial", 1, 1);
	setAmbientRoomContext( "partial_room", "ringoff_plr", "outdoor" );
	declareAmbientPackage( "partial_room" );
	
	declareAmbientRoom( "large_room" );
	setAmbientRoomReverb ("large_room","spl_yemen_largeroom", 1, 1);
	setAmbientRoomContext( "large_room", "ringoff_plr", "indoor" );
	declareAmbientPackage( "large_room" );
	
	declareAmbientRoom( "stone_room_large" );
	setAmbientRoomTone ("stone_room_large","blk_tunnel_wind_bg", .5, .5);
	setAmbientRoomReverb ("stone_room_large","spl_yemen_stoneroom_lg", 1, 1);
	setAmbientRoomContext( "stone_room_large", "ringoff_plr", "indoor" );
	declareAmbientPackage( "stone_room_large" );
	
	declareAmbientRoom( "bunker_tunnel" );
	setAmbientRoomTone ("bunker_tunnel","blk_tunnel_wind_bg", .5, .5);
	setAmbientRoomReverb ("bunker_tunnel","spl_yemen_cave", 1, 1);
	setAmbientRoomContext( "bunker_tunnel", "ringoff_plr", "indoor" );
	declareAmbientPackage( "bunker_tunnel" );
	
	declareAmbientRoom( "bunker_room" );
	setAmbientRoomTone ("bunker_room","blk_bunker_room_bg", .5, .5);
	setAmbientRoomReverb ("bunker_room","spl_yemen_bunker", 1, 1);
	setAmbientRoomContext( "bunker_room", "ringoff_plr", "indoor" );
	declareAmbientPackage( "bunker_room" );	
	
	declareAmbientRoom( "numbers" );
	setAmbientRoomTone( "numbers", "evt_numbers_amb_trippy", 1, .25 );
	setAmbientRoomReverb ("numbers", "spl_yemen_numbers", 1, 1);
	setAmbientRoomContext( "numbers", "ringoff_plr", "indoor" );
	declareAmbientPackage( "numbers" );
 	addAmbientElement( "numbers", "evt_numbers_small", .25, 2, 25, 250 );	
 	addAmbientElement( "numbers", "evt_numbers_large", 2, 15, 150, 500 );	
 	addAmbientElement( "numbers", "evt_numbers_large_flux", 5, 15, 250, 500 );	
 	
	//*************** Delete these after a level BSP made after CL 1196928 (Eckert)*************************************
 	
 	declareAmbientRoom( "stone_room" );
	setAmbientRoomReverb ("stone_room","spl_yemen_stoneroom", 1, 1);
	setAmbientRoomContext( "stone_room", "ringoff_plr", "indoor" );
	declareAmbientPackage( "stone_room" );
 	
 	declareAmbientRoom( "medium_room" );
	setAmbientRoomReverb ("medium_room","spl_yemen_mediumroom", 1, 1);
	setAmbientRoomContext( "medium_room", "ringoff_plr", "indoor" );
	declareAmbientPackage( "medium_room" );
 	
	declareAmbientRoom( "small_room" );
	setAmbientRoomReverb ("small_room","spl_yemen_smallroom", 1, 1);
	setAmbientRoomContext( "small_room", "ringoff_plr", "indoor" );
	declareAmbientPackage( "small_room" );
	
	
	
	
	//************************************************************************************************
	//                                      ACTIVATE DEFAULT AMBIENT SETTINGS
	//************************************************************************************************

	activateAmbientPackage( 0, "desert_outside", 0 );
	activateAmbientRoom( 0, "desert_outside", 0 );	
	
	
	/// MUSIC STATES
	/// 
	
	declareMusicState ("YEMEN_INTRO");
		musicAlias ("mus_yemen_intro", 1);
		musicAliasLoop ("mus_yemen_march", 0, 0.5);
		musicStinger ("mus_yemen_rally", 36, true);
	
	declareMusicState ("YEMEN_DOOR_OPENED");
		musicAliasLoop ("mus_yemen_farid_battle", 0, 6);
		
	declareMusicState ("YEMEN_HARPER_DECISION");
		musicAlias ("mus_yemen_harper_decision", 6);
	
	declareMusicState ("YEMEN_HARPER_FARID_DIED");
		musicAlias ("null", 0);
	
	declareMusicState ("YEMEN_HARPER_HARPER_DIED");
		musicAlias ("null", 0);
	
	declareMusicState ("YEMEN_MASON_ARRIVES");
		musicAlias("mus_yemen_mason_arrives", 0);
		musicwaittilldone();
		
	declareMusicState ("YEMEN_MASON_KICKS_ASS");
		musicAlias ("mus_yemen_mason_battle", 0);
		
	declaremusicState ("YEMEN_SNIPER");
		musicAliasloop ("mus_sniper", 0, 5);		
		
	declaremusicState ("YEMEN_SNIPER_END");
		musicAlias ("mus_sniper_end", 0);		
	
	setsoundcontext( "f35", "exterior" );			
		
	thread snd_fx_create();
	thread blend_desert_tunnel();
	thread activate_numbers_audio();
	thread slomo_context_wait();
	thread snd_start_autofx_audio();
	thread canyonwind();
	thread crowdswell();
	thread set_osprey_context_ext();
	thread set_osprey_context_int();
	thread torch_sounds();
	thread snapshot_check();
	thread snd_set_low_ambience_snapshot();
	thread snd_set_default_snapshot();
	thread set_morals_snapshot();
}
snapshot_check()
{
	level endon ("intr_on");
	wait (3);
	//iprintlnbold ("snp_default");
	snd_set_snapshot("default");	
}

torch_sounds()
{
	playloopat( "amb_fire_torch", (-43, 2207, 69));	
	playloopat( "amb_fire_torch", (-40, 2012, 69));	
	playloopat( "amb_fire_torch", (-1036, 1565, 71));
	playloopat( "amb_fire_torch", (-1037, 1376, 66));	
}

canyonwind()
{
	//turn off line	
	level notify ("snd_canyon_wind_start");
	//wait until trigger	
	level waittill ("snd_canyon_wind");
	//turn on line
	level notify ("snd_canyon_wind_start");
	
}


crowdswell()
{
	crowd_close_ent = spawn( 0, ( 18, 2103, 57), "script_origin" );
	crowd_close_ent thread transition_sounds();
  
	level waittill ("snd_swell_start");
	PlaySound(0, "evt_door_open_squeak", ( 18, 2103, 57 ));
	PlaySound(0, "evt_yem_door_swell", ( 509.5, 1220, 347.5 ));
		
	//plays outdoor crowd loop walla
	crowd_sounds_ent = spawn( 0, ( 509.5, 1220, 347.5), "script_origin" );
	crowd_sounds_ent thread speech_end_sound();

	level notify ("snd_crowd_chant");
}

speech_end_sound()	
{

	self PlayloopSound("evt_yem_crowd_outside_lp");
	level waittill ("speech_done");
	self stoploopsound (1);
	PlaySound(0, "evt_yem_panic", ( self.origin ));
	wait (1);
	self delete();
}

transition_sounds()
{
	self PlayloopSound("amb_crowd_walla_close");
	level waittill ("snd_swell_start");
	wait 3;
	self StopLoopSound (3);
	wait 1;
	self delete();
}


//Play looping sound on looping effects using createfx ents: (effect name, alias name, coord, snap to ground T/F)
snd_start_autofx_audio()
{


	snd_play_auto_fx ( "fx_fireplace01", "amb_fireplace", 0, 0, 0, false );
	snd_play_auto_fx ( "fx_insects_fly_swarm", "amb_insects", 0, 0, 0, false );
	//snd_play_auto_fx ( "fx_yemen_wake01", "amb_ocean_wake", 0, 0, 0, true );
	snd_play_auto_fx ( "fx_seagulls_circle_overhead", "amb_seagull", 0, 0, 0, false );
	snd_play_auto_fx ( "fx_yemen_leaves_blow01", "amb_wind_tree", 0, 0, 0, false );
	snd_play_auto_fx ( "fx_yemen_leaves_blow02", "amb_wind_tree", 0, 0, 0, false );
	snd_play_auto_fx ( "fx_fire_line_md", "amb_fire_md", 0, 0, 0, false );
	snd_play_auto_fx ( "fx_yemen_burningdrone01", "amb_fire_sm", 0, 0, 0, false );
	snd_play_auto_fx ( "fx_yemen_burningfoliage01", "amb_fire_foliage", 0, 0, 0, false );
	snd_play_auto_fx ( "fx_fire_line_xsm_thin", "amb_fire_md", 0, 0, 0, false );
	snd_play_auto_fx ( "fx_yemen_smokeflare01", "amb_flare", 0, 0, 0, true );
	//snd_play_auto_fx ( "fx_yemen_rotorwash01", "amb_rotor_wash", 0, 0, 0, false );
	snd_play_auto_fx ( "fx_yemen_burningfoliage_custom01", "amb_fire_sm", 0, 0, 0, false );
	

}
snd_fx_create()
{
//	while (!isDefined(level.createFXent))
//	{
		wait (1);
//	}


	//Explos in timeslow
	clientscripts\_audio::snd_add_exploder_alias( 330, "exp_yem_timeslow_canned_explo" );
	clientscripts\_audio::snd_add_exploder_alias( 331, "exp_yem_timeslow_exp" );
	clientscripts\_audio::snd_add_exploder_alias( 332, "exp_yem_timeslow_exp" );
	clientscripts\_audio::snd_add_exploder_alias( 333, "exp_yem_timeslow_exp" );
	clientscripts\_audio::snd_add_exploder_alias( 334, "exp_yem_timeslow_exp" );
	
}

blend_desert_tunnel()
{

	playloopat ("blk_blend", (15104, -10119, -32));
		
}

activate_numbers_audio()
{
	level endon( "ensc" );
	
	level waittill( "snsc" );
	
	level thread cleanup_numbers_audio();
	activateambientpackage( 0, "numbers", 100 );
	activateambientroom( 0, "numbers", 100 );
	level notify( "updateActiveAmbientPackage" );
	level notify( "updateActiveAmbientRoom" );
	
	num = 1;
	while(1)
	{
		playsound( 0, "evt_numbers_heartbeat_loud", (0,0,0) );
		if( num == 2 )
		{
			num = 0;
			playsound( 0, "evt_numbers_breath_cold", (0,0,0) );
		}
		wait(1.5);
		num++;
	}
}

cleanup_numbers_audio()
{
	level waittill( "ensc" );
	
	deactivateambientpackage( 0, "numbers", 100 );
	deactivateambientroom( 0, "numbers", 100 );
}

slomo_context_wait()
{
	
	level waittill ( "slomo_on" );
	setsoundcontext( "f35", "interior" );
	
	level waittill ( "slomo_off" );
	//iprintlnbold ( "Slomo Off Received" );
	setsoundcontext( "f35", "exterior" );
	
}



set_osprey_context_ext()
{
	 waitforclient(0);
	 setsoundcontext( "f35", "exterior" );
}


set_osprey_context_int()
{
	level waittill ("inside_osprey");
	osp_ent = spawn ( 0, (0,0,0), "script_origin" );
	setsoundcontext ( "f35", "interior" );
	osp_ent playloopsound ("veh_osp_interior",.5);
	level waittill ("osprey_done");
	setsoundcontext ( "f35", "exterior" );
	player = GetLocalPlayers()[0];
	fade_ent = spawn (0, player.origin, "script_origin");
	wait (1);
	fade_ent playsound (0, "veh_osp_fade");
	wait (1);
	osp_ent stoploopsound (2);
	wait (5);
	osp_ent delete();
	fade_ent delete();
}
snd_set_low_ambience_snapshot()
{
	while(1)
	{
		level waittill ("mbs");
		snd_set_snapshot( "cmn_low_ambience" );
	}	
	
}
snd_set_default_snapshot()
{
	while(1)
	{
		level waittill ("mbss");
		snd_set_snapshot( "default" );
	}	
	
}
set_morals_snapshot()
{
	level waittill ("morals");
	snd_set_snapshot( "spl_yemen_morals" );
	
}