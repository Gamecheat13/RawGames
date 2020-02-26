//
// file: afghanistan_amb.csc
// description: clientside ambient script for afghanistan: setup ambient sounds, etc.
// scripter: 		(initial clientside work - laufer)
//

#include clientscripts\_utility; 
#include clientscripts\_ambientpackage;
#include clientscripts\_music;
#include clientscripts\_busing;
#include clientscripts\_audio;

main()
{
	declareAmbientRoom( "desert_outside" );
	setAmbientRoomTone ("desert_outside","amb_desert_bg", 3, 3);
	setAmbientRoomReverb ("desert_outside","afgan_desert_outside", 1, 1);
	setAmbientRoomContext( "desert_outside", "ringoff_plr", "outdoor" );
	declareAmbientPackage( "desert_outside" );
 	addAmbientElement( "desert_outside", "amb_desert_wind_gusts", 1, 3, 50, 750 );

 	
 	declareAmbientRoom( "afgan_cliff_echo" );
	setAmbientRoomTone ("afgan_cliff_echo","amb_desert_bg", 3, 3);
	setAmbientRoomReverb ("afgan_cliff_echo","afgan_cliff_echo", 1, 1);
	setAmbientRoomContext( "afgan_cliff_echo", "ringoff_plr", "outdoor" );
	declareAmbientPackage( "afgan_cliff_echo" );
 	addAmbientElement( "afgan_cliff_echo", "amb_desert_wind_gusts", 1, 3, 50, 750 );
 	addAmbientElement( "afgan_cliff_echo", "amb_red_tail_hawk", 8, 18, 200, 1000 );
 	
 	declareAmbientRoom( "short_cave_arch" );
	setAmbientRoomTone ("short_cave_arch","amb_desert_bg", 3, 3);
	setAmbientRoomReverb ("short_cave_arch","afgan_short_cave_arch", 1, 1);
	setAmbientRoomContext( "short_cave_arch", "ringoff_plr", "outdoor" );
	declareAmbientPackage( "short_cave_arch" );
	
	 declareAmbientRoom( "big_cave_arch" );
	setAmbientRoomTone ("big_cave_arch","amb_desert_bg", 3, 3);
	setAmbientRoomReverb ("big_cave_arch","afgan_big_cave_arch", 1, 1);
	setAmbientRoomContext( "big_cave_arch", "ringoff_plr", "outdoor" );
	declareAmbientPackage( "big_cave_arch" );
			
	declareAmbientRoom( "hills_outside" );
	setAmbientRoomTone ("hills_outside","amb_desert_bg", 3, 3);
	setAmbientRoomReverb ("hills_outside","afgan_bridges", 1, 1);
	setAmbientRoomContext( "hills_outside", "ringoff_plr", "outdoor" );
	declareAmbientPackage( "hills_outside" );
	
	//Set this room for the open-air places between buildings and ruins without roofs by the weapon cache - set the reverb for the walls but left the ringoff
	declareAmbientRoom( "open_air_enclosure" );
	setAmbientRoomTone ("open_air_enclosure","amb_desert_bg", 3, 3);
	setAmbientRoomReverb ("open_air_enclosure","afgan_open_hut", 1, 1);
	setAmbientRoomContext( "open_air_enclosure", "ringoff_plr", "outdoor" );
	declareAmbientPackage( "open_air_enclosure" );
	
	declareAmbientRoom( "village" );
	setAmbientRoomTone ("village","amb_desert_bg", 3, 3);
	setAmbientRoomReverb ("village","afgan_village", 1, 1);
	setAmbientRoomContext( "village", "ringoff_plr", "outdoor" );
	declareAmbientPackage( "village" );
	
	declareAmbientRoom( "stone_room" );
	setAmbientRoomTone ("stone_room","amb_desert_bg", 3, 3);
	setAmbientRoomReverb ("stone_room","afgan_stone_room", 1, 1);
	setAmbientRoomContext( "stone_room", "ringoff_plr", "indoor" );
	declareAmbientPackage( "stone_room" );
	
	declareAmbientRoom( "stone_room_large" );
	setAmbientRoomTone ("stone_room_large","amb_desert_bg", 3, 3);
	setAmbientRoomReverb ("stone_room_large","afgan_stone_room_lg", 1, 1);
	setAmbientRoomContext( "stone_room_large", "ringoff_plr", "indoor" );
	declareAmbientPackage( "stone_room_large" );
	
	declareAmbientRoom( "bunker_tunnel" );
	setAmbientRoomTone ("bunker_tunnel","amb_cave_bg", 3, 3);
	setAmbientRoomReverb ("bunker_tunnel","afgan_bunker_tunnel", 1, 1);
	setAmbientRoomContext( "bunker_tunnel", "ringoff_plr", "indoor" );
	declareAmbientPackage( "bunker_tunnel" );
	
	declareAmbientRoom( "tunnel_gen" );
	setAmbientRoomTone ("tunnel_gen","amb_cave_bg", 3, 3);
	setAmbientRoomReverb ("tunnel_gen","afgan_tunnel_gen", 1, 1);
	setAmbientRoomContext( "tunnel_gen", "ringoff_plr", "indoor" );
	declareAmbientPackage( "tunnel_gen" );
	
	declareAmbientRoom( "bunker_room" );
	setAmbientRoomTone ("bunker_room","amb_cave_bg", 3, 3);
	setAmbientRoomReverb ("bunker_room","afgan_bunker_room", 1, 1);
	setAmbientRoomContext( "bunker_room", "ringoff_plr", "indoor" );
	declareAmbientPackage( "bunker_room" );	
	
	declareAmbientRoom( "numbers" );
	setAmbientRoomTone( "numbers", "evt_numbers_amb_trippy", 1, .25 );
	setAmbientRoomReverb ("numbers", "afgan_numbers_igc", 1, 1);
	setAmbientRoomContext( "numbers", "ringoff_plr", "indoor" );
	declareAmbientPackage( "numbers" );
 	addAmbientElement( "numbers", "evt_numbers_small", .25, 2, 25, 250 );	
 	addAmbientElement( "numbers", "evt_numbers_large", 2, 15, 150, 500 );	
 	addAmbientElement( "numbers", "evt_numbers_large_flux", 5, 15, 250, 500 );	
 	
 	
 	//************************************************************************************************
	//                                      MUSIC INIT
	//************************************************************************************************
	
	declaremusicState ("AFGHAN_INTRO");
		musicAliasloop ("mus_intro", 0, 2);
		musicStinger ("mus_intro_low_wall", 50);
		
	declaremusicState ("AFGHAN_LOW_WALL");		
		musicAliasloop("mus_base_loop",0, 0.5);
		
		//musicwaittillstingerdone();
		
	declaremusicState ("AFGHAN_HORSE_RIDE");
		musicAlias ("mus_horseride", 0);
		
	declaremusicState ("AFGHAN_BASE_TENSION");
		musicAliasloop ("mus_base_loop", 2, 2);
		
	declaremusicState ("AFGHAN_BATTLE_START");
		musicAliasloop ("mus_attack_start_loop", 0, 0.5);
	
	declareMusicState ("HORSE_REARBACK");
		musicAliasloop ("null", 0, 0);
		musicStinger ("mus_sprint_to_wave_1", 84);
	
	declareMusicState ("ON_TO_BATTLE");
		musicAliasloop ("mus_wave_1_loop", 0.5, 3);
		musicStinger ("mus_c4prep", 31);
			
	declareMusicState ("AFGHAN_C4");		
		musicAliasloop ("mus_c4_wait", 1, 2);
	
	declareMusicState ("RIDE_TO_FIGHT_TWO");
		musicAliasloop ("mus_action_travel_loop", 0.5, 1);
		
	declareMusicState ("AFGHAN_BRIDGE_FIGHT");
		musicAliasloop ("mus_wave_1_loop", 0.5, 1);
		musicStinger ("mus_sprint_to_wave_1", 84, true);
	
	declareMusicState ("AFGHAN_WAVE2_PART2");
		musicAliasloop ("mus_wave_2_part_2_loop", 0.5, 3);
		musicStinger ("mus_action_slowdown", 20);
		
	declareMusicState ("AFGHAN_WAVE3_PART1");
		musicAliasloop ("mus_action_travel_loop", 0.5, 1);
	
	declareMusicState ("AFGHAN_END");
		musicAliasloop ("null", 0.5, 1);	
		
	declaremusicState ("AFGHAN_BINOCULARS");
		musicAliasloop ("mus_horse_charge_calm", 0.5, 1);
	
	declaremusicState ("AFGHAN_HORSE_CHARGE");
		musicAlias ("mus_horse_charge_gallop", 0);	
	
	
	//************************************************************************************************
	//                                      ACTIVATE DEFAULT AMBIENT SETTINGS
	//************************************************************************************************

	activateAmbientPackage( 0, "desert_outside", 0 );
	activateAmbientRoom( 0, "desert_outside", 0 );	
	
	level thread levelStartSnapshot();
	thread snd_fx_create();
	thread blend_desert_tunnel();
	thread activate_numbers_audio();
	//thread punch_timescale_snapshots();
	//thread tank_explo_timescale_snapshots();
	thread distant_explosions_setup();
	level thread set_no_ambient_snapshot();
	level thread sound_fade_out_snapshot();
	//level thread deserted_fadein_snapshot();
	level thread binoc_vehicle_snapshot();
	level thread tankfight_snapshot();
	level thread snd_play_loopers();
	//thread play_test_sound_priority();
	//thread play_base_amb();
}

snd_play_loopers()
{
	playloopat("amb_air_dank", (569, 1285, 120));
	playloopat("amb_desert_high_dist", (-482, 1782, 36));
}
	
play_test_sound_priority()
{
	//This should not be running unless you have a priority problem.  "blk_test_loop" has been commented out for RAM.
	sound = playloopat( "blk_test_loop", (-690, 1344, -15));
}

snd_fx_create()
{
//	while (!isDefined(level.createFXent))
//	{
		wait (1);
//	}

	//statue this is now the first rope bridge in blocking point 3.
	//clientscripts\_audio::snd_add_exploder_alias( 10350, "fxa_statue_fall_a" );
	//tower
	//clientscripts\_audio::snd_add_exploder_alias( 10330, "fxa_tower_explo_pulse" );
	//cliff - SJ removed call below as there is a notetrack covering this (also, this alis was playing twice during event)
	//clientscripts\_audio::snd_add_exploder_alias( 10340, "fxa_cliff_collapse" );
	snd_add_exploder_alias( 465, "wpn_mortar_fire" );//mortar firing n_exploder
	snd_add_exploder_alias( 650, "wpn_mortar_fire" );//mortar firing n_exploder
	
	
	
	
	
	//level thread snd_play_auto_fx( "fx_afgh_light_tinhat", "amb_lights" );

}
levelStartSnapshot()
{
	snd_set_snapshot( "spl_afghanistan_level_start" );
	wait(3);
	snd_set_snapshot( "default" );
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

play_base_amb()
{
	waitforclient(0);
	base_amb = clientscripts\_audio::playloopat("amb_rebel_base_ext", (13356, -10160, 48));
}

punch_timescale_snapshots()
{
	level waittill ( "punch_timescale_on" );
	snd_set_snapshot ( "spl_afghanistan_reunion_clamp" );
	
	level waittill ( "punch_timescale_off" );
	snd_set_snapshot ( "default" );
}

tank_explo_timescale_snapshots()
{
	level waittill ( "tank_explode" );
	snd_set_snapshot ( "spl_afghanistan_reunion_clamp" );
	
	wait(3);
	snd_set_snapshot ( "default" );
}

distant_explosions_setup()
{
	wait_min = 3;
	wait_max = 15;
	
	location1 = (8328, -19768, 40);
	location2 = (1160, -2632, 8);
	location3 = (-8304, -11096, 40);
	
	level thread play_random_dist_explosions( "dbw1", wait_min, wait_max, location1 );
	level thread play_random_dist_explosions( "dbw2", wait_min, wait_max, location2 );
	level thread play_random_dist_explosions( "dbw2", wait_min, wait_max, location3 );
}

play_random_dist_explosions( string, wait_min, wait_max, location )
{
	level endon( "end_tf" );
	
	level waittill( string );
	
	while(1)
	{
		playsound( 0, "amb_humongoid_explosions", location );
		wait(randomintrange(wait_min,wait_max));
	}
}
set_no_ambient_snapshot()
{
	level waittill ("abs_1");
	wait(2);
	snd_set_snapshot ( "cmn_no_wind" );
	
}

deserted_fadein_snapshot()
{
	level waittill( "snp_desert" );
	
	snd_set_snapshot( "spl_afghanistan_deserted_trans" );
	
	level waittill( "snp_desert" );
	
	snd_set_snapshot( "spl_afghanistan_deserted" );
}

sound_fade_out_snapshot()
{
	level waittill ("fade_out");
	snd_set_snapshot ( "cmn_fade_out" );	
}


binoc_vehicle_snapshot()
{
	level waittill ("binoc_on");
	snd_set_snapshot ( "spl_afghanistan_vehicle_off" );	
	level waittill ("binoc_off");
	snd_set_snapshot ( "default" );	
}

tankfight_snapshot()
{
	level waittill( "strt_tf" );
	snd_set_snapshot( "spl_afghanistan_reunion_1" );
	level waittill( "cut_tf" );
	snd_set_snapshot( "spl_afghanistan_reunion_2" );
	level waittill( "end_tf" );
	snd_set_snapshot( "spl_afghanistan_deserted" );
}