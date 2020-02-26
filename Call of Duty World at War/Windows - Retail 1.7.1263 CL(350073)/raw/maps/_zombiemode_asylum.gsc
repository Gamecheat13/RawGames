#include maps\_anim; 
#include maps\_utility; 
#include common_scripts\utility;
#include maps\_music; 
#include maps\_zombiemode_utility; 
#include maps\_busing;

#using_animtree( "generic_human" ); 

main()
{
	precache_shaders();
	precache_models();

	PrecacheItem( "fraggrenade" );
	PrecacheItem( "colt" );

	init_strings();
	init_levelvars();
	init_animscripts();
	init_sounds();
	init_shellshocks();
	init_flags();

	// for dogs
	//animscripts\dog_init::initDogAnimations();

	// the initial spawners
	level.enemy_spawns = 		getEntArray( "zombie_spawner_init", 	"targetname" ); 
	level.enemy_dog_spawns = 	getEntArray( "zombie_spawner_dog_init", "targetname" ); 
	SetAILimit( 24 );

	//maps\_destructible_type94truck::init(); 

	level.custom_introscreen = ::zombie_intro_screen; 
	level.reset_clientdvars = ::onPlayerConnect_clientDvars;

	init_fx(); 

	// load map defaults
	maps\_load::main();

	level.hudelem_count = 0;
	// Call the other zombiemode scripts
	maps\_zombiemode_weapons::init();
	maps\_zombiemode_blockers::init();
	maps\_zombiemode_spawner_asylum::init();
	maps\_zombiemode_powerups::init();
	maps\_zombiemode_radio::init();	

/#
	maps\_zombiemode_devgui::init();
#/
	init_utility();

	// register a client system...
	maps\_utility::registerClientSys("zombify");

	level thread coop_player_spawn_placement();

	// zombie ai and anim inits
	init_anims(); 

	// Sets up function pointers for animscripts to refer to
	level.playerlaststand_func = ::player_laststand;
	//	level.global_kill_func = maps\_zombiemode_spawner_asylum::zombie_death; 
	level.global_damage_func = maps\_zombiemode_spawner_asylum::zombie_damage; 
	level.global_damage_func_ads = maps\_zombiemode_spawner_asylum::zombie_damage_ads;
	level.overridePlayerKilled = ::player_killed_override;
	level.overridePlayerDamage = ::player_damage_override;

	// used to a check in last stand for players to become zombies
	level.is_zombie_level = true; 
	level.player_becomes_zombie = ::zombify_player; 

	// so we dont get the uber colt when we're knocked out
	level.laststandpistol = "colt";

	level.round_start_time = 0;

	level thread onPlayerConnect(); 

	init_dvars();
	initZombieLeaderboardData();


	flag_wait( "all_players_connected" ); 

	//thread zombie_difficulty_ramp_up(); 

	// Start the Zombie MODE!
	level thread round_start();
	level thread players_playing();
	level thread check_for_jugg_perk();

	//chrisp - adding spawning vo 
	level thread spawn_vo();
	
	//add ammo tracker for VO
	level thread track_players_ammo_count();
	
	//no more dogs for now
	//level thread dog_round_tracker();

	//level thread prevent_near_origin();

	DisableGrenadeSuicide();

	level.startInvulnerableTime = GetDvarInt( "player_deathInvulnerableTime" );

	// Do a SaveGame, so we can restart properly when we die
	SaveGame( "zombie_start", &"AUTOSAVE_LEVELSTART", "", true );

	// TESTING
	//	wait( 3 );
	//	level thread intermission();
	//	thread testing_spawner_bug();
}


/*------------------------------------
chrisp - adding vo to track players ammo
------------------------------------*/
track_players_ammo_count()
{
	self endon("disconnect");
	self endon("death");
	if(!IsDefined (level.player_ammo_low))	
	{
		level.player_ammo_low = 0;
	}	
	while(1)
	{
		players = get_players();
		for(i=0;i<players.size;i++)
		{
	
			weap = players[i] getcurrentweapon();
			//Excludes all Perk based 'weapons' so that you don't get low ammo spam.
			if(!isDefined(weap) || weap == "none" || weap == "zombie_perk_bottle_doubletap" || weap == "zombie_perk_bottle_jugg" || weap == "zombie_perk_bottle_revive" || weap == "zombie_perk_bottle_sleight" || weap == "mine_bouncing_betty" || weap == "syrette")
			{
				continue;
			}
			if ( players[i] GetAmmoCount( weap ) > 5)
			{
				continue;
			}
			if ( players[i] maps\_laststand::player_is_in_laststand() )
			{				
				continue;
			}
			else if (players[i] GetAmmoCount( weap ) < 5 && players[i] GetAmmoCount( weap ) > 0)
			{
				if (level.player_ammo_low == 0)
				{
					level.player_ammo_low = 1;
					players[i] thread do_player_vo("vox_ammo_low", 5);		
					//put in this wait to keep the game from spamming about being low on ammo.
					wait(20);
					level.player_ammo_low = 0;
				}
	
			}
			else
			{
				continue;
			}
		}
		wait(.5);
	}	
}

/*------------------------------------
audio plays when more than 1 player connects
------------------------------------*/
spawn_vo()
{
	//not sure if we need this
	wait(1);
	
	players = getplayers();
	
	//just pick a random player for now and play some vo 
	if(players.size > 1)
	{
		player = random(players);
		index = maps\_zombiemode_weapons::get_player_index(player);
		player thread spawn_vo_player(index,players.size);
	}

}

spawn_vo_player(index,num)
{
	sound = "plr_" + index + "_vox_" + num +"play";
	self playsound(sound, "sound_done");			
	self waittill("sound_done");
}

testing_spawner_bug()
{
	wait( 0.1 );
	level.round_number = 7;

	spawners = [];
	spawners[0] = GetEnt( "testy", "targetname" );
	while( 1 )
	{
		wait( 1 );
		level.enemy_spawns = spawners;
	}
}

precache_shaders()
{
	precacheshader( "nazi_intro" ); 
	precacheshader( "zombie_intro" ); 
	PrecacheShader( "hud_chalk_1" );
	PrecacheShader( "hud_chalk_2" );
	PrecacheShader( "hud_chalk_3" );
	PrecacheShader( "hud_chalk_4" );
	PrecacheShader( "hud_chalk_5" );
}

precache_models()
{
	precachemodel( "char_ger_honorgd_zomb_behead" ); 
	precachemodel( "char_ger_zombieeye" ); 
	PrecacheModel( "tag_origin" );
}

init_shellshocks()
{
	level.player_killed_shellshock = "zombie_death";
	PrecacheShellshock( level.player_killed_shellshock );
}

init_strings()
{
	PrecacheString( &"ZOMBIE_WEAPONCOSTAMMO" );
	PrecacheString( &"ZOMBIE_ROUND" );
	PrecacheString( &"SCRIPT_PLUS" );
	PrecacheString( &"ZOMBIE_GAME_OVER" );
	PrecacheString( &"ZOMBIE_SURVIVED_ROUND" );
	PrecacheString( &"ZOMBIE_SURVIVED_ROUNDS" );

	add_zombie_hint( "undefined", &"ZOMBIE_UNDEFINED" );

	// Random Treasure Chest
	add_zombie_hint( "default_treasure_chest_950", &"ZOMBIE_RANDOM_WEAPON_950" );

	// Barrier Pieces
	add_zombie_hint( "default_buy_barrier_piece_10", &"ZOMBIE_BUTTON_BUY_BACK_BARRIER_10" );
	add_zombie_hint( "default_buy_barrier_piece_20", &"ZOMBIE_BUTTON_BUY_BACK_BARRIER_20" );
	add_zombie_hint( "default_buy_barrier_piece_50", &"ZOMBIE_BUTTON_BUY_BACK_BARRIER_50" );
	add_zombie_hint( "default_buy_barrier_piece_100", &"ZOMBIE_BUTTON_BUY_BACK_BARRIER_100" );

	// REWARD Barrier Pieces
	add_zombie_hint( "default_reward_barrier_piece", &"ZOMBIE_BUTTON_REWARD_BARRIER" );
	add_zombie_hint( "default_reward_barrier_piece_10", &"ZOMBIE_BUTTON_REWARD_BARRIER_10" );
	add_zombie_hint( "default_reward_barrier_piece_20", &"ZOMBIE_BUTTON_REWARD_BARRIER_20" );
	add_zombie_hint( "default_reward_barrier_piece_30", &"ZOMBIE_BUTTON_REWARD_BARRIER_30" );
	add_zombie_hint( "default_reward_barrier_piece_40", &"ZOMBIE_BUTTON_REWARD_BARRIER_40" );
	add_zombie_hint( "default_reward_barrier_piece_50", &"ZOMBIE_BUTTON_REWARD_BARRIER_50" );

	// Debris
	add_zombie_hint( "default_buy_debris_100", &"ZOMBIE_BUTTON_BUY_CLEAR_DEBRIS_100" );
	add_zombie_hint( "default_buy_debris_200", &"ZOMBIE_BUTTON_BUY_CLEAR_DEBRIS_200" );
	add_zombie_hint( "default_buy_debris_250", &"ZOMBIE_BUTTON_BUY_CLEAR_DEBRIS_250" );
	add_zombie_hint( "default_buy_debris_500", &"ZOMBIE_BUTTON_BUY_CLEAR_DEBRIS_500" );
	add_zombie_hint( "default_buy_debris_750", &"ZOMBIE_BUTTON_BUY_CLEAR_DEBRIS_750" );
	add_zombie_hint( "default_buy_debris_1000", &"ZOMBIE_BUTTON_BUY_CLEAR_DEBRIS_1000" );
	add_zombie_hint( "default_buy_debris_1250", &"ZOMBIE_BUTTON_BUY_CLEAR_DEBRIS_1250" );
	add_zombie_hint( "default_buy_debris_1500", &"ZOMBIE_BUTTON_BUY_CLEAR_DEBRIS_1500" );
	add_zombie_hint( "default_buy_debris_1750", &"ZOMBIE_BUTTON_BUY_CLEAR_DEBRIS_1750" );
	add_zombie_hint( "default_buy_debris_2000", &"ZOMBIE_BUTTON_BUY_CLEAR_DEBRIS_2000" );

	// Doors
	add_zombie_hint( "default_buy_door_100", &"ZOMBIE_BUTTON_BUY_OPEN_DOOR_100" );
	add_zombie_hint( "default_buy_door_200", &"ZOMBIE_BUTTON_BUY_OPEN_DOOR_200" );
	add_zombie_hint( "default_buy_door_250", &"ZOMBIE_BUTTON_BUY_OPEN_DOOR_250" );
	add_zombie_hint( "default_buy_door_500", &"ZOMBIE_BUTTON_BUY_OPEN_DOOR_500" );
	add_zombie_hint( "default_buy_door_750", &"ZOMBIE_BUTTON_BUY_OPEN_DOOR_750" );
	add_zombie_hint( "default_buy_door_1000", &"ZOMBIE_BUTTON_BUY_OPEN_DOOR_1000" );
	add_zombie_hint( "default_buy_door_1250", &"ZOMBIE_BUTTON_BUY_OPEN_DOOR_1250" );
	add_zombie_hint( "default_buy_door_1500", &"ZOMBIE_BUTTON_BUY_OPEN_DOOR_1500" );
	add_zombie_hint( "default_buy_door_1750", &"ZOMBIE_BUTTON_BUY_OPEN_DOOR_1750" );
	add_zombie_hint( "default_buy_door_2000", &"ZOMBIE_BUTTON_BUY_OPEN_DOOR_2000" );

	// Areas
	add_zombie_hint( "default_buy_area_100", &"ZOMBIE_BUTTON_BUY_OPEN_AREA_100" );
	add_zombie_hint( "default_buy_area_200", &"ZOMBIE_BUTTON_BUY_OPEN_AREA_200" );
	add_zombie_hint( "default_buy_area_250", &"ZOMBIE_BUTTON_BUY_OPEN_AREA_250" );
	add_zombie_hint( "default_buy_area_500", &"ZOMBIE_BUTTON_BUY_OPEN_AREA_500" );
	add_zombie_hint( "default_buy_area_750", &"ZOMBIE_BUTTON_BUY_OPEN_AREA_750" );
	add_zombie_hint( "default_buy_area_1000", &"ZOMBIE_BUTTON_BUY_OPEN_AREA_1000" );
	add_zombie_hint( "default_buy_area_1250", &"ZOMBIE_BUTTON_BUY_OPEN_AREA_1250" );
	add_zombie_hint( "default_buy_area_1500", &"ZOMBIE_BUTTON_BUY_OPEN_AREA_1500" );
	add_zombie_hint( "default_buy_area_1750", &"ZOMBIE_BUTTON_BUY_OPEN_AREA_1750" );
	add_zombie_hint( "default_buy_area_2000", &"ZOMBIE_BUTTON_BUY_OPEN_AREA_2000" );
}

init_sounds()
{
	add_sound( "end_of_round", "round_over" );
	add_sound( "end_of_game", "mx_game_over" ); //Had to remove this and add a music state switch so that we can add other musical elements.
	add_sound( "chalk_one_up", "chalk" );
	add_sound( "purchase", "cha_ching" );
	add_sound( "no_purchase", "no_cha_ching" );

	// Zombification
	// TODO need to vary these up
	add_sound( "playerzombie_usebutton_sound", "attack_vocals" );
	add_sound( "playerzombie_attackbutton_sound", "attack_vocals" );
	add_sound( "playerzombie_adsbutton_sound", "attack_vocals" );

	// Head gib
	add_sound( "zombie_head_gib", "zombie_head_gib" );

	// Blockers
	add_sound( "rebuild_barrier_piece", "repair_boards" );
	add_sound( "rebuild_barrier_hover", "boards_float" );
	add_sound( "debris_hover_loop", "couch_loop" );
	add_sound( "break_barrier_piece", "break_boards" );
	add_sound("blocker_end_move", "board_slam");
	add_sound( "barrier_rebuild_slam", "board_slam" );

	// Doors
	add_sound( "door_slide_open", "door_slide_open" );
	add_sound( "door_rotate_open", "door_slide_open" );

	// Debris
	add_sound( "debris_move", "weap_wall" );

	// Random Weapon Chest
	add_sound( "open_chest", "lid_open" );
	add_sound( "music_chest", "music_box" );
	add_sound( "close_chest", "lid_close" );

	// Weapons on walls
	add_sound( "weapon_show", "weap_wall" );

}

init_levelvars()
{
	level.intermission = false;
	level.zombie_total = 0;
	level.no_laststandmissionfail = true;

	level.zombie_vars = [];

	// Default to not zombify the player till further support
	set_zombie_var( "zombify_player", 					false );

	set_zombie_var( "below_world_check", 				-1000 );

	// Respawn in the spectators in between rounds
	set_zombie_var( "spectators_respawn", 				true );

	// Round	
	set_zombie_var( "zombie_use_failsafe", 				true );
	set_zombie_var( "zombie_round_time", 				30 );
	set_zombie_var( "zombie_between_round_time", 		10 );
	set_zombie_var( "zombie_intermission_time", 		15 );

	// Spawning
	set_zombie_var( "zombie_spawn_delay", 				3 );
	set_zombie_var( "zombie_spawn_dog_delay", 			8 );

	// AI 
	set_zombie_var( "zombie_health_increase", 			100 );
	set_zombie_var( "zombie_health_increase_percent", 	10, 	100 );
	set_zombie_var( "zombie_health_start", 				150 );
	set_zombie_var( "zombie_max_ai", 					24 );
	set_zombie_var( "zombie_ai_per_player", 			6 );

	// Scoring
	set_zombie_var( "zombie_score_start", 				500 );
/#
	if( GetDvarInt( "zombie_cheat" ) >= 1 )
	{
		set_zombie_var( "zombie_score_start", 			100000 );
	}
#/
	set_zombie_var( "zombie_score_kill", 				50 );
	set_zombie_var( "zombie_score_damage", 				5 );
	set_zombie_var( "zombie_score_bonus_melee", 		80 );
	set_zombie_var( "zombie_score_bonus_head", 			50 );
	set_zombie_var( "zombie_score_bonus_neck", 			20 );
	set_zombie_var( "zombie_score_bonus_torso", 		10 );
	set_zombie_var( "zombie_score_bonus_burn", 			10 );

	set_zombie_var( "penalty_no_revive_percent", 		10, 	100 );
	set_zombie_var( "penalty_died_percent", 			0, 		100 );
	set_zombie_var( "penalty_downed_percent", 			5, 		100 );	

	set_zombie_var( "zombie_flame_dmg_point_delay",		500 );	

	if ( IsSplitScreen() )
	{
		set_zombie_var( "zombie_timer_offset", 			280 );	// hud offsets
	}
}

init_dvars()
{
	level.zombiemode = true;

	//coder mod: tkeegan - new code dvar
	setSavedDvar( "zombiemode", "1" );	
	setSavedDvar( "fire_world_damage", "0" );	
	setSavedDvar( "fire_world_damage_rate", "0" );	
	setSavedDvar( "fire_world_damage_duration", "0" );	

	if( GetDvar( "zombie_debug" ) == "" )
	{
		SetDvar( "zombie_debug", "0" );
	}

	if( GetDvar( "zombie_cheat" ) == "" )
	{
		SetDvar( "zombie_cheat", "0" );
	}
	
	if(getdvar("magic_chest_movable") == "")
	{
		SetDvar( "magic_chest_movable", "1" );
	}

	if(getdvar("magic_box_explore_only") == "")
	{
		SetDvar( "magic_box_explore_only", "1" );
	}
}

initZombieLeaderboardData()
{
	// Initializing Leaderboard Stat Variables
	level.zombieLeaderboardStatVariable["nazi_zombie_prototype"]["highestwave"] = "nz_prototype_highestwave";
	level.zombieLeaderboardStatVariable["nazi_zombie_prototype"]["timeinwave"] = "nz_prototype_timeinwave";
	level.zombieLeaderboardStatVariable["nazi_zombie_prototype"]["totalpoints"] = "nz_prototype_totalpoints";

	level.zombieLeaderboardStatVariable["nazi_zombie_asylum"]["highestwave"] = "nz_asylum_highestwave";
	level.zombieLeaderboardStatVariable["nazi_zombie_asylum"]["timeinwave"] = "nz_asylum_timeinwave";
	level.zombieLeaderboardStatVariable["nazi_zombie_asylum"]["totalpoints"] = "nz_asylum_totalpoints";

	// Initializing Leaderboard Number
	level.zombieLeaderboardNumber["nazi_zombie_prototype"]["waves"] = 13;
	level.zombieLeaderboardNumber["nazi_zombie_prototype"]["points"] = 14;

	level.zombieLeaderboardNumber["nazi_zombie_asylum"]["waves"] = 15;
	level.zombieLeaderboardNumber["nazi_zombie_asylum"]["points"] = 16;
}

init_flags()
{
	flag_init("dog_round");
	flag_init("spawn_point_override");
}

init_fx()
{
	level._effect["wood_chunk_destory"]	 	= loadfx( "impacts/large_woodhit" );

	level._effect["edge_fog"]			 	= LoadFx( "env/smoke/fx_fog_zombie_amb" ); 
	level._effect["chest_light"]		 	= LoadFx( "env/light/fx_ray_sun_sm_short" ); 

	level._effect["eye_glow"]			 	= LoadFx( "misc/fx_zombie_eye_single" ); 

	level._effect["zombie_grain"]			= LoadFx( "misc/fx_zombie_grain_cloud" );

	level._effect["headshot"] 				= LoadFX( "impacts/flesh_hit_head_fatal_lg_exit" );
	level._effect["headshot_nochunks"] 		= LoadFX( "misc/fx_zombie_bloodsplat" );
	level._effect["bloodspurt"] 			= LoadFX( "misc/fx_zombie_bloodspurt" );

	// Flamethrower
	level._effect["character_fire_pain_sm"]              		= loadfx( "env/fire/fx_fire_player_sm_1sec" );
	level._effect["character_fire_death_sm"]             		= loadfx( "env/fire/fx_fire_player_md" );
	level._effect["character_fire_death_torso"] 				= loadfx( "env/fire/fx_fire_player_torso" );
}

// zombie specific anims
init_anims()
{
	// deaths
	level.scr_anim["zombie"]["death1"] 	= %ai_zombie_death_v1;
	level.scr_anim["zombie"]["death2"] 	= %ai_zombie_death_v2;
	level.scr_anim["zombie"]["death3"] 	= %ai_zombie_crawl_death_v1;
	level.scr_anim["zombie"]["death4"] 	= %ai_zombie_crawl_death_v2;

	// run cycles
	level.scr_anim["zombie"]["walk1"] 	= %ai_zombie_walk_v1;
	level.scr_anim["zombie"]["walk2"] 	= %ai_zombie_walk_v2;
	level.scr_anim["zombie"]["walk3"] 	= %ai_zombie_walk_v3;
	level.scr_anim["zombie"]["walk4"] 	= %ai_zombie_walk_v4;
	level.scr_anim["zombie"]["walk5"] 	= %ai_zombie_walk_v6;
	level.scr_anim["zombie"]["walk6"] 	= %ai_zombie_walk_v7;
	level.scr_anim["zombie"]["walk7"] 	= %ai_zombie_walk_v8;
	level.scr_anim["zombie"]["walk8"] 	= %ai_zombie_walk_v9;
	
	
	level.scr_anim["zombie"]["run1"] 	= %ai_zombie_walk_fast_v1;
	level.scr_anim["zombie"]["run2"] 	= %ai_zombie_walk_fast_v2;
	level.scr_anim["zombie"]["run3"] 	= %ai_zombie_walk_fast_v3;
	//level.scr_anim["zombie"]["run4"] 	= %ai_zombie_run_v1;
	level.scr_anim["zombie"]["run4"] 	= %ai_zombie_run_v2;
	level.scr_anim["zombie"]["run5"] 	= %ai_zombie_run_v4;
	//level.scr_anim["zombie"]["run6"] 	= %ai_zombie_run_v4;

	level.scr_anim["zombie"]["sprint1"] = %ai_zombie_sprint_v1;
	level.scr_anim["zombie"]["sprint2"] = %ai_zombie_sprint_v2;
	//level.scr_anim["zombie"]["sprint3"] = %ai_zombie_sprint_v3;
	level.scr_anim["zombie"]["sprint3"] = %ai_zombie_sprint_v4;
	level.scr_anim["zombie"]["sprint4"] = %ai_zombie_sprint_v5;

	// run cycles in prone
	level.scr_anim["zombie"]["crawl1"] 	= %ai_zombie_crawl;
	level.scr_anim["zombie"]["crawl2"] 	= %ai_zombie_crawl_v1;
	level.scr_anim["zombie"]["crawl3"] 	= %ai_zombie_crawl_v2;
	level.scr_anim["zombie"]["crawl4"] 	= %ai_zombie_crawl_v3;
	level.scr_anim["zombie"]["crawl5"] 	= %ai_zombie_crawl_v4;
	level.scr_anim["zombie"]["crawl6"] 	= %ai_zombie_crawl_v5;
	
	level.scr_anim["zombie"]["crawl_sprint1"] 	= %ai_zombie_crawl_sprint;
	level.scr_anim["zombie"]["crawl_sprint2"] 	= %ai_zombie_crawl_sprint_1;
	level.scr_anim["zombie"]["crawl_sprint3"] 	= %ai_zombie_crawl_sprint_2;

	level._zombie_melee = [];
	level._zombie_walk_melee = [];
	level._zombie_run_melee = [];

	level._zombie_melee[0] 				= %ai_zombie_attack_forward_v1; 
	level._zombie_melee[1] 				= %ai_zombie_attack_forward_v2; 
	level._zombie_melee[2] 				= %ai_zombie_attack_v1; 
	level._zombie_melee[3] 				= %ai_zombie_attack_v2;	
	level._zombie_melee[4]				=	%ai_zombie_attack_v1;
	level._zombie_melee[5]				= %ai_zombie_attack_v4;
	level._zombie_melee[6]				= %ai_zombie_attack_v6;	

	level._zombie_run_melee[0]				=	%ai_zombie_run_attack_v1;
	level._zombie_run_melee[1]				=	%ai_zombie_run_attack_v2;
	level._zombie_run_melee[2]				=	%ai_zombie_run_attack_v3;

	level._zombie_walk_melee[0]			= %ai_zombie_walk_attack_v1;
	level._zombie_walk_melee[1]			= %ai_zombie_walk_attack_v2;
	level._zombie_walk_melee[2]			= %ai_zombie_walk_attack_v3;
	level._zombie_walk_melee[3]			= %ai_zombie_walk_attack_v4;

	// melee in crawl
	level._zombie_melee_crawl = [];
	level._zombie_melee_crawl[0] 		= %ai_zombie_attack_crawl; 
	level._zombie_melee_crawl[1] 		= %ai_zombie_attack_crawl_lunge;
	//level._zombie_melee_crawl[2]		= %ai_zombie_crawl_attack_A;

	/*
	ground crawl
	*/

	// set up the arrays
	level._zombie_rise_anims = [];

	//level._zombie_rise_anims[1]["walk"][0]		= %ai_zombie_traverse_ground_v1_crawl;
	level._zombie_rise_anims[1]["walk"][0]		= %ai_zombie_traverse_ground_v1_walk;

	//level._zombie_rise_anims[1]["run"][0]		= %ai_zombie_traverse_ground_v1_crawlfast;
	level._zombie_rise_anims[1]["run"][0]		= %ai_zombie_traverse_ground_v1_run;

	level._zombie_rise_anims[1]["sprint"][0]	= %ai_zombie_traverse_ground_climbout_fast;

	//level._zombie_rise_anims[2]["walk"][0]		= %ai_zombie_traverse_ground_v2_walk;	//!broken
	level._zombie_rise_anims[2]["walk"][0]		= %ai_zombie_traverse_ground_v2_walk_altA;
	//level._zombie_rise_anims[2]["walk"][2]		= %ai_zombie_traverse_ground_v2_walk_altB;//!broken

	// ground crawl death
	level._zombie_rise_death_anims = [];

	level._zombie_rise_death_anims[1]["in"][0]		= %ai_zombie_traverse_ground_v1_deathinside;
	level._zombie_rise_death_anims[1]["in"][1]		= %ai_zombie_traverse_ground_v1_deathinside_alt;

	level._zombie_rise_death_anims[1]["out"][0]		= %ai_zombie_traverse_ground_v1_deathoutside;
	level._zombie_rise_death_anims[1]["out"][1]		= %ai_zombie_traverse_ground_v1_deathoutside_alt;

	level._zombie_rise_death_anims[2]["in"][0]		= %ai_zombie_traverse_ground_v2_death_low;
	level._zombie_rise_death_anims[2]["in"][1]		= %ai_zombie_traverse_ground_v2_death_low_alt;

	level._zombie_rise_death_anims[2]["out"][0]		= %ai_zombie_traverse_ground_v2_death_high;
	level._zombie_rise_death_anims[2]["out"][1]		= %ai_zombie_traverse_ground_v2_death_high_alt;
	
	//taunts
	level._zombie_run_taunt = [];
	level._zombie_board_taunt = [];
	
	level._zombie_taunt[0] = %ai_zombie_taunts_1;
	level._zombie_taunt[1] = %ai_zombie_taunts_2;
	level._zombie_taunt[2] = %ai_zombie_taunts_3;
	level._zombie_taunt[3] = %ai_zombie_taunts_4;
	level._zombie_taunt[4] = %ai_zombie_taunts_5;
	level._zombie_taunt[5] = %ai_zombie_taunts_6;
	level._zombie_taunt[6] = %ai_zombie_taunts_7;
	level._zombie_taunt[7] = %ai_zombie_taunts_8;
	level._zombie_taunt[8] = %ai_zombie_taunts_9;
	
	level._zombie_board_taunt[0] = %ai_zombie_taunts_4;
	level._zombie_board_taunt[1] = %ai_zombie_taunts_7;
	level._zombie_board_taunt[2] = %ai_zombie_taunts_9;
	
}

// Initialize any animscript related variables
init_animscripts()
{
	// Setup the animscripts, then override them (we call this just incase an AI has not yet spawned)
	animscripts\init::firstInit();

	anim.idleAnimArray		["stand"] = [];
	anim.idleAnimWeights	["stand"] = [];
	anim.idleAnimArray		["stand"][0][0] 	= %ai_zombie_idle_v1_delta;
	anim.idleAnimWeights	["stand"][0][0] 	= 10;

	anim.idleAnimArray		["crouch"] = [];
	anim.idleAnimWeights	["crouch"] = [];	
	anim.idleAnimArray		["crouch"][0][0] 	= %ai_zombie_idle_crawl_delta;
	anim.idleAnimWeights	["crouch"][0][0] 	= 10;
}

// Handles the intro screen
zombie_intro_screen( string1, string2, string3, string4, string5 )
{
	flag_wait( "all_players_connected" );

	wait( 1 );

	//TUEY Set music state to Splash Screencompass
	setmusicstate( "SPLASH_SCREEN" );
	wait (0.2);
	//TUEY Set music state to WAVE_1
	//	setmusicstate("WAVE_1");
}

players_playing()
{
	// initialize level.players_playing
	players = get_players();
	level.players_playing = players.size;

	wait( 20 );

	players = get_players();
	level.players_playing = players.size;
}

//
// NETWORK SECTION ====================================================================== //
//

watchGrenadeThrow()
{
	self endon( "disconnect" ); 
	self endon( "death" );

	while(1)
	{
		self waittill("grenade_fire", grenade);

		if(isdefined(grenade))
		{
			if(self maps\_laststand::player_is_in_laststand())
			{
				grenade delete();
			}
		}
	}
}

onPlayerConnect()
{
	for( ;; )
	{
		level waittill( "connecting", player ); 

		player.entity_num = player GetEntityNumber(); 
		player thread onPlayerSpawned(); 
		player thread onPlayerDisconnect(); 

		player thread watchGrenadeThrow();

		player.score = level.zombie_vars["zombie_score_start"]; 
		player.score_total = player.score; 
		player.old_score = player.score; 

		player.is_zombie = false; 
		player.initialized = false;
		player.zombification_time = 0;
	}
}

onPlayerConnect_clientDvars()
{
	self SetClientDvars( "cg_deadChatWithDead", "1",
		"cg_deadChatWithTeam", "1",
		"cg_deadHearTeamLiving", "1",
		"cg_deadHearAllLiving", "1",
		"cg_everyoneHearsEveryone", "1",
		"compass", "0",
		"hud_showStance", "0",
		"cg_thirdPerson", "0",
		"cg_fov", "65",
		"cg_thirdPersonAngle", "0",
		"ammoCounterHide", "0",
		"miniscoreboardhide", "0",
		"ui_hud_hardcore", "0" );

	self SetDepthOfField( 0, 0, 512, 4000, 4, 0 );
}

onPlayerDisconnect()
{
	self waittill( "disconnect" ); 
	self remove_from_spectate_list();
}

onPlayerSpawned()
{
	self endon( "disconnect" ); 

	for( ;; )
	{
		self waittill( "spawned_player" ); 

		self SetClientDvars( "cg_thirdPerson", "0",
			"cg_fov", "65",
			"cg_thirdPersonAngle", "0" );

		self SetDepthOfField( 0, 0, 512, 4000, 4, 0 );

		self add_to_spectate_list();

		if( isdefined( self.initialized ) )
		{
			if( self.initialized == false )
			{
				self.initialized = true; 
				//				self maps\_zombiemode_score::create_player_score_hud(); 

				// set the initial score on the hud		
				self maps\_zombiemode_score::set_player_score_hud( true ); 
				self thread player_zombie_breadcrumb();
			}
		}
	}
}

player_laststand()
{
	self maps\_zombiemode_score::player_downed_penalty();

	if( IsDefined( self.intermission ) && self.intermission )
	{
		// Taken from _laststand since we will never go back to it...
		self.downs++;
		maps\_challenges_coop::doMissionCallback( "playerDied", self );

		level waittill( "forever" );
	}
}

spawnSpectator()
{
	self endon( "disconnect" ); 
	self endon( "spawned_spectator" ); 
	self notify( "spawned" ); 
	self notify( "end_respawn" );

	if( level.intermission )
	{
		return;
	}

	if( IsDefined( level.no_spectator ) && level.no_spectator )
	{
		wait( 3 );
		ExitLevel();
	}

	// The check_for_level_end looks for this
	self.is_zombie = true;

	// Remove all reviving abilities
	self notify ( "zombified" );

	if( IsDefined( self.revivetrigger ) )
	{
		self.revivetrigger delete();
		self.revivetrigger = undefined;
	}

	self.zombification_time = getTime(); //set time when player died

	resetTimeout(); 

	// Stop shellshock and rumble
	self StopShellshock(); 
	self StopRumble( "damage_heavy" ); 

	self.sessionstate = "spectator"; 
	self.spectatorclient = -1;

	self remove_from_spectate_list();

	self.maxhealth = self.health;
	self.shellshocked = false; 
	self.inWater = false; 
	self.friendlydamage = undefined; 
	self.hasSpawned = true; 
	self.spawnTime = getTime(); 
	self.afk = false; 

	println( "*************************Zombie Spectator***" );
	self detachAll();

	self setSpectatePermissions( true );
	self thread spectator_thread();

	self Spawn( self.origin, self.angles );
	self notify( "spawned_spectator" );
}

setSpectatePermissions( isOn )
{
	self AllowSpectateTeam( "allies", isOn );
	self AllowSpectateTeam( "axis", false );
	self AllowSpectateTeam( "freelook", false );
	self AllowSpectateTeam( "none", false );	
}

spectator_thread()
{
	self endon( "disconnect" ); 
	self endon( "spawned_player" );

	if( IsSplitScreen() )
	{
		last_alive = undefined;
		players = get_players();

		for( i = 0; i < players.size; i++ )
		{
			if( !players[i].is_zombie )
			{
				last_alive = players[i];
			}
		}

		share_screen( last_alive, true );

		return;
	}

	self thread spectator_toggle_3rd_person();
}

spectator_toggle_3rd_person()
{
	self endon( "disconnect" ); 
	self endon( "spawned_player" );

	third_person = true;
	self set_third_person( true );
	//	self NotifyOnCommand( "toggle_3rd_person", "weapnext" );

	//	while( 1 )
	//	{
	//		self waittill( "toggle_3rd_person" );
	//
	//		if( third_person )
	//		{
	//			third_person = false;
	//			self set_third_person( false );
	//			wait( 0.5 );
	//		}
	//		else
	//		{
	//			third_person = true;
	//			self set_third_person( true );
	//			wait( 0.5 );
	//		}
	//	}
}


set_third_person( value )
{
	if( value )
	{
		self SetClientDvars( "cg_thirdPerson", "1",
			"cg_fov", "40",
			"cg_thirdPersonAngle", "354" );

		self setDepthOfField( 0, 128, 512, 4000, 6, 1.8 );
	}
	else
	{
		self SetClientDvars( "cg_thirdPerson", "0",
			"cg_fov", "65",
			"cg_thirdPersonAngle", "0" );

		self setDepthOfField( 0, 0, 512, 4000, 4, 0 );
	}
}

spectators_respawn()
{
	level endon( "between_round_over" );

	if( !IsDefined( level.zombie_vars["spectators_respawn"] ) || !level.zombie_vars["spectators_respawn"] )
	{
		return;
	}

	if( !IsDefined( level.custom_spawnPlayer ) )
	{
		// Custom spawn call for when they respawn from spectator
		level.custom_spawnPlayer = ::spectator_respawn;
	}

	while( 1 )
	{
		players = get_players();
		for( i = 0; i < players.size; i++ )
		{
			if( players[i].sessionstate == "spectator" )
			{
				players[i] [[level.spawnPlayer]]();
			}
		}

		wait( 1 );
	}
}

spectator_respawn()
{
	println( "*************************Respawn Spectator***" );

	spawn_off_player = get_closest_valid_player( self.origin );
	origin = get_safe_breadcrumb_pos( spawn_off_player );

	self setSpectatePermissions( false );

	if( IsDefined( origin ) )
	{
		angles = VectorToAngles( spawn_off_player.origin - origin );
	}
	else
	{
		spawnpoints = GetEntArray( "info_player_deathmatch", "classname" );
		num = RandomInt( spawnpoints.size );
		origin = spawnpoints[num].origin;
		angles = spawnpoints[num].angles;
	}

	//CHRIS_P - additional spawning logic to handle asylum map
	//probably should set this as a flag at some point, instead of making it a script check.
	if(level.script == "nazi_zombie_asylum")
	{
		self.has_betties = undefined;
		self.is_burning = undefined;
		
		origin = self.respawn_point.origin;
		angles = self.respawn_point.angles;	

//3/23/09 - removed this because it was causing respawn issues , should investigate a way to bring back the 'spawn by your buddy' functionality	
/*
		//only modify the respawning logic if this flag is NOT set
		if(!flag("both_doors_opened"))
		{

			//if someone is alive from your 'team' then spawn by them
			myteam = get_players_on_team(self);
			if(myteam.size > 0)
			{
				
				//add 10 units to the z value to prevent the player from spawning into the ground sometimes on stairs
				origin = get_safe_breadcrumb_pos( myteam[0]);
				if(isDefined(origin))
				{
					angles = VectorToAngles( myteam[0].origin - origin );
				}
				else
				{
					origin = self.respawn_point.origin;
					angles = self.respawn_point.angles;
				}
			}

			//if noone is alive on your team then spawn at the original location
			else
			{
				origin = self.respawn_point.origin;
				angles = self.respawn_point.angles;
			}
		}
*/
	}
	
	//add 10 units to the z value to prevent the player from spawning into the ground sometimes on stairs
	origin =  origin +  (0,0,10);
	

	self Spawn( origin, angles );

	if( IsSplitScreen() )
	{
		last_alive = undefined;
		players = get_players();

		for( i = 0; i < players.size; i++ )
		{
			if( !players[i].is_zombie )
			{
				last_alive = players[i];
			}
		}

		share_screen( last_alive, false );
	}

	// The check_for_level_end looks for this
	self.is_zombie = false;
	self.ignoreme = false;

	setClientSysState("lsm", "0", self);	// Notify client last stand ended.
	self RevivePlayer();

	self notify( "spawned_player" );

	// Penalize the player when we respawn, since he 'died'
	self maps\_zombiemode_score::player_reduce_points( "died" );

	self thread player_zombie_breadcrumb();

	return true;
}


get_players_on_team(exclude)
{

	teammates = [];

	players = get_players();
	for(i=0;i<players.size;i++)
	{		
		//check to see if other players on your team are alive and not waiting to be revived
		if(players[i].spawn_side == self.spawn_side && !isDefined(players[i].revivetrigger) && players[i] != exclude )
		{
			teammates[teammates.size] = players[i];
		}
	}

	return teammates;
}



get_safe_breadcrumb_pos( player )
{
	players = get_players();
	valid_players = [];

	min_dist = 150 * 150;
	for( i = 0; i < players.size; i++ )
	{
		if( !is_player_valid( players[i] ) )
		{
			continue;
		}

		valid_players[valid_players.size] = players[i];
	}

	for( i = 0; i < valid_players.size; i++ )
	{
		count = 0;
		for( q = 1; q < player.zombie_breadcrumbs.size; q++ )
		{
			if( DistanceSquared( player.zombie_breadcrumbs[q], valid_players[i].origin ) < min_dist )
			{
				continue;
			}
			
			count++;
			if( count == valid_players.size )
			{
				return player.zombie_breadcrumbs[q];
			}
		}
	}

	return undefined;
}

round_spawning()
{
	level endon( "intermission" );
/#
	level endon( "kill_round" );
#/

	if( level.intermission )
	{
		return;
	}

	if( level.enemy_spawns.size < 1 )
	{
		ASSERTMSG( "No spawners with targetname zombie_spawner in map." ); 
		return; 
	}

/#
	if ( GetDVarInt( "zombie_cheat" ) == 2 || GetDVarInt( "zombie_cheat" ) >= 4 ) 
	{
		return;
	}
#/

	/#
		level.zombies = [];
#/	
	count = 0; 

	//CODER MOD: TOMMY K
	players = get_players();
	for( i = 0; i < players.size; i++ )
	{
		players[i].zombification_time = 0;
	}

	level.round_start_time = getTime();

	max = level.zombie_vars["zombie_max_ai"];

	multiplier = level.round_number / 5;
	if( multiplier < 1 )
	{
		multiplier = 1;
	}

	// After round 10, exponentially have more AI attack the player
	if( level.round_number >= 10 )
	{
		multiplier *= level.round_number * 0.15;
	}

	max += int( ( ( get_players().size - 1 ) * level.zombie_vars["zombie_ai_per_player"] ) * multiplier ); 
	if(level.round_number < 3 && level.script == "nazi_zombie_asylum")
	{
		if(get_players().size > 1)
		{
			
			max = get_players().size * 3 + level.round_number;

		}
		else
		{

			max = 6;	

		}
	}
	else if ( level.first_round )
	{
		max = int( max * 0.2 );	
	}
	else if (level.round_number < 3)
	{
		max = int( max * 0.4 );
	}
	else if (level.round_number < 4)
	{
		max = int( max * 0.6 );
	}
	else if (level.round_number < 5)
	{
		max = int( max * 0.8 );
	}

	// less dogs
	if ( flag("dog_round") )
	{
		//chris_p - modified to scale with the number of players
		players = get_players();
		switch(players.size)
		{
		case 1:
			max = int( max / 5 );
			break;
		case 2:	
			max = int( max / 4 );
			break;
		case 3:
			max = int( max / 3 );
			break;
		case 4: 
			max = int( max / 2 );
			break;
		}

		if (max < 2 )
		{
			max = 2;
		}
	}

	level.zombie_total = max;

	// DEBUG HACK:	
	//max = 1;

	while( count < max )
	{
		if ( !flag("dog_round") )
		{
			spawn_point = level.enemy_spawns[RandomInt( level.enemy_spawns.size )]; 
		}
		else
		{
			spawn_point = level.enemy_dog_spawns[RandomInt( level.enemy_dog_spawns.size )]; 
		}


		while( get_enemy_count() > 31 )
		{
			wait( 0.05 );
		}

		ai = spawn_zombie( spawn_point ); 

		if( IsDefined( ai ) )
		{
			level.zombie_total--;

			/#
				level.zombies[level.zombies.size] = ai;
#/	

			ai thread round_spawn_failsafe();
			count++; 
		}

		if ( !flag("dog_round") )
		{
			wait( level.zombie_vars["zombie_spawn_delay"] ); 
		}
		else
		{
			wait( level.zombie_vars["zombie_spawn_dog_delay"] ); 
		}
		// TESTING! Only 1 Zombie for testing
		//		level waittill( "forever" );
	}
}

// TESTING: spawn one zombie at a time
round_spawning_test()
{
	while (true)
	{
		spawn_point = level.enemy_spawns[RandomInt( level.enemy_spawns.size )];	// grab a random spawner

		ai = spawn_zombie( spawn_point );
		ai waittill("death");

		wait 5;
	}
}
/////////////////////////////////////////////////////////

round_text( text )
{
	if( level.first_round )
	{
		intro = true;
	}
	else
	{
		intro = false;
	}

	hud = create_simple_hud();
	hud.horzAlign = "center"; 
	hud.vertAlign = "middle";
	hud.alignX = "center"; 
	hud.alignY = "middle";
	hud.y = -100;
	hud.foreground = 1;
	hud.fontscale = 16.0;
	hud.alpha = 0; 
	hud.color = ( 1, 1, 1 );

	hud SetText( text ); 
	hud FadeOverTime( 1.5 );
	hud.alpha = 1;
	wait( 1.5 );

	if( intro )
	{
		wait( 1 );
		level notify( "intro_change_color" );
	}

	hud FadeOverTime( 3 );
	//hud.color = ( 0.8, 0, 0 );
	hud.color = ( 0.423, 0.004, 0 );
	wait( 3 );

	if( intro )
	{
		level waittill( "intro_hud_done" );
	}

	hud FadeOverTime( 1.5 );
	hud.alpha = 0;
	wait( 1.5 ); 
	hud destroy();
}

round_start()
{
	level.zombie_health = level.zombie_vars["zombie_health_start"]; 
	level.round_number = 1; 
	level.first_round = true;

	// so players get init'ed with grenades
	players = get_players();
	for (i = 0; i < players.size; i++)
	{
		players[i] giveweapon( "stielhandgranate" );	
		players[i] setweaponammoclip( "stielhandgranate", 0);
	}

	/#
		//level thread bunker_ui(); 
#/

		level.chalk_hud1 = create_chalk_hud();
	level.chalk_hud2 = create_chalk_hud( 64 );

	//	level waittill( "introscreen_done" );

	level thread round_think(); 
}


create_chalk_hud( x )
{
	if( !IsDefined( x ) )
	{
		x = 0;
	}

	hud = create_simple_hud();
	hud.alignX = "left"; 
	hud.alignY = "bottom";
	hud.horzAlign = "left"; 
	hud.vertAlign = "bottom";
	hud.color = ( 0.423, 0.004, 0 );
	hud.x = x; 
	hud.alpha = 0;

	hud SetShader( "hud_chalk_1", 64, 64 );

	return hud;
}
play_intro_VO()
{
	variation_count =5;
	wait(3);
	players = getplayers();
	index = maps\_zombiemode_weapons::get_player_index(players[0]);
	wait (4);

	//Plays a random start line on one of the characters
	i = randomintrange(0,players.size);
	players[i] playsound ("plr_" + i + "_vox_start" + "_" + randomintrange(0, variation_count));
	
}
wait_until_first_player()
{
	players = get_players();
	if( !IsDefined( players[0] ) )
	{
		level waittill( "first_player_ready" );
	}
}
chalk_one_up()
{
	if( level.first_round )
	{
		intro = true;
		//Play the intro sound at the beginning of the round
	 	level thread play_intro_VO();

	}
	else
	{
		intro = false;
	}

	round = undefined;	
	if( intro )
	{
		round = create_simple_hud();
		round.alignX = "center"; 
		round.alignY = "bottom";
		round.horzAlign = "center"; 
		round.vertAlign = "bottom";
		round.fontscale = 16;
		round.color = ( 1, 1, 1 );
		round.x = 0;
		round.y = -265;
		round.alpha = 0;
		round SetText( &"ZOMBIE_ROUND" );

		round FadeOverTime( 1 );
		round.alpha = 1;
		wait( 1 );

		round FadeOverTime( 3 );
		//		round.color = ( 0.8, 0, 0 );
		round.color = ( 0.423, 0.004, 0 );
	}

	hud = undefined;
	if( level.round_number < 6 || level.round_number > 10 )
	{
		hud = level.chalk_hud1;
		hud.fontscale = 32;
	}
	else if( level.round_number < 11 )
	{
		hud = level.chalk_hud2;
	}

	if( intro )
	{
		hud.alpha = 0;
		hud.horzAlign = "center";
		hud.x = -5;
		hud.y = -200;
	}

	hud FadeOverTime( 0.5 );
	hud.alpha = 0;

	if( level.round_number == 11 && IsDefined( level.chalk_hud2 ) )
	{
		level.chalk_hud2 FadeOverTime( 0.5 );
		level.chalk_hud2.alpha = 0;
	}

	wait( 0.5 );

	//	play_sound_at_pos( "chalk_one_up", ( 0, 0, 0 ) );

	if(IsDefined(level.eggs) && level.eggs !=1)
	{
		setmusicstate("round_begin");
	}

	if( level.round_number == 11 && IsDefined( level.chalk_hud2 ) )
	{
		level.chalk_hud2 destroy_hud();
	}

	if( level.round_number > 10 )
	{
		hud SetValue( level.round_number );
	}

	hud FadeOverTime( 0.5 );
	hud.alpha = 1;

	if( intro )
	{
		wait( 3 );

		if( IsDefined( round ) )
		{
			round FadeOverTime( 1 );
			round.alpha = 0;
		}

		wait( 0.25 );

		level notify( "intro_hud_done" );
		hud MoveOverTime( 1.75 );
		hud.horzAlign = "left";
		//		hud.x = 0;
		hud.y = 0;
		wait( 2 );

		round destroy_hud();
	}

	if( level.round_number > 10 )
	{
	}
	else if( level.round_number > 5 )
	{
		hud SetShader( "hud_chalk_" + ( level.round_number - 5 ), 64, 64 );
	}
	else if( level.round_number > 1 )
	{
		hud SetShader( "hud_chalk_" + level.round_number, 64, 64 );
	}
	//TUEY TODO STUFF
	if ( flag("dog_round") )
	{
		players = getplayers();				
		array_thread(players,::play_dog_round);	
	}
	/*
	else 
	{
	setmusicstate("WAVE_1");
	}
	*/

	//	ReportMTU(level.round_number);	// In network debug instrumented builds, causes network spike report to generate.
}
play_dog_round()
{
	self playlocalsound("dog_round_start");
	setmusicstate("mx_dog_round");
}
chalk_round_hint()
{
	huds = [];
	huds[huds.size] = level.chalk_hud1;

	if( level.round_number > 5 && level.round_number < 11 )
	{
		huds[huds.size] = level.chalk_hud2;
	}

	time = level.zombie_vars["zombie_between_round_time"];
	for( i = 0; i < huds.size; i++ )
	{
		huds[i] FadeOverTime( time * 0.25 );
		huds[i].color = ( 1, 1, 1 );
	}
	if(IsDefined(level.eggs) && level.eggs !=1)
	{
		setmusicstate("round_end");
		wait( time * 0.25 );
	}
	//	play_sound_at_pos( "end_of_round", ( 0, 0, 0 ) );



	// Pulse
	fade_time = 0.5;
	steps =  ( time * 0.5 ) / fade_time;
	for( q = 0; q < steps; q++ )
	{
		for( i = 0; i < huds.size; i++ )
		{
			if( !IsDefined( huds[i] ) )
			{
				continue;
			}

			huds[i] FadeOverTime( fade_time );
			huds[i].alpha = 0;
		}

		wait( fade_time );

		for( i = 0; i < huds.size; i++ )
		{
			if( !IsDefined( huds[i] ) )
			{
				continue;
			}

			huds[i] FadeOverTime( fade_time );
			huds[i].alpha = 1;		
		}

		wait( fade_time );
	}

	for( i = 0; i < huds.size; i++ )
	{
		if( !IsDefined( huds[i] ) )
		{
			continue;
		}

		huds[i] FadeOverTime( time * 0.25 );
		//		huds[i].color = ( 0.8, 0, 0 );
		huds[i].color = ( 0.423, 0.004, 0 );
		huds[i].alpha = 1;
	}
}

round_think()
{
	//TUEY - MOVE THIS LATER
	//TUEY Set music state to round 1
	//setmusicstate( "WAVE_1" );

	for( ;; )
	{
		//////////////////////////////////////////
		//designed by prod DT#36173
		maxreward = 50 * level.round_number;
		if ( maxreward > 500 )
			maxreward = 500;
		level.zombie_vars["rebuild_barrier_cap_per_round"] = maxreward;
		//////////////////////////////////////////

		level.round_timer = level.zombie_vars["zombie_round_time"]; 

		ai_calculate_health(); 
		add_later_round_spawners();

		chalk_one_up();
		//		round_text( &"ZOMBIE_ROUND_BEGIN" );

		maps\_zombiemode_powerups::powerup_round_start();

		players = get_players();
		array_thread( players, maps\_zombiemode_blockers::rebuild_barrier_reward_reset );

		level thread award_grenades_for_survivors();

		round_spawn_func = ::round_spawning;

		/#
			if (GetDVarInt("zombie_rise_test"))
			{
				round_spawn_func = ::round_spawning_test;		// FOR TESTING, one zombie at a time, no round advancement
			}
#/

			level thread [[round_spawn_func]]();

			round_wait(); 
			level.first_round = false;

			level thread spectators_respawn();

			//		round_text( &"ZOMBIE_ROUND_END" );
			level thread chalk_round_hint();

			wait( level.zombie_vars["zombie_between_round_time"] ); 

			// here's the difficulty increase over time area
			if ( !flag("dog_round") )
			{
				timer = level.zombie_vars["zombie_spawn_delay"];
			}
			else
			{
				timer = level.zombie_vars["zombie_spawn_dog_delay"];
			}

			if( timer < 0.08 )
			{
				timer = 0.08; 
			}	

			// keep scaling dog and human delays, but dog delay has a second at least so they dont clump as much
			level.zombie_vars["zombie_spawn_dog_delay"] = timer * 0.95;
			level.zombie_vars["zombie_spawn_delay"] = timer * 0.95;

			// Increase the zombie move speed
			level.zombie_move_speed = level.round_number * 8;

			level.round_number++; 

			level notify( "between_round_over" );
	}
}


//Chris_P - made changes to this, it wasn't working properly
dog_round_tracker()
{	
	
	//force the dogs every round for testing
	if(getdvar("force_dogs")!= "")
	{
		flag_set("dog_round");
		return;
	}
	
	next_dog_round = 7;	
	while ( isdefined(level.dogs_enabled) && level.dogs_enabled )
	{
		level waittill ("between_round_over");

		//clear the dog flag after each round just to make sure
		flag_clear("dog_round"); 		

		if ( level.round_number == 4) //first dog round
		{
			flag_set("dog_round");
		}
		else if(level.round_number >= next_dog_round)	//the next dog round has a 50% chance of happening every round after the initial 3 round minimum.
		{
			if(randomint(100) >50) 
			{
				flag_set("dog_round");
				next_dog_round = level.round_number + 3; 
			}
			else
			{
				flag_clear("dog_round");
			}			
		}
	}	
}

award_grenades_for_survivors()
{
	players = get_players();

	for (i = 0; i < players.size; i++)
	{
		if (!players[i].is_zombie)
		{
			if( !players[i] HasWeapon( "stielhandgranate" ) )
			{
				players[i] GiveWeapon( "stielhandgranate" );	
				players[i] SetWeaponAmmoClip( "stielhandgranate", 0 );
			}

			if ( players[i] GetFractionMaxAmmo( "stielhandgranate") < .25 )
			{
				players[i] SetWeaponAmmoClip( "stielhandgranate", 2 );
			}
			else if (players[i] GetFractionMaxAmmo( "stielhandgranate") < .5 )
			{
				players[i] SetWeaponAmmoClip( "stielhandgranate", 3 );
			}
			else
			{
				players[i] SetWeaponAmmoClip( "stielhandgranate", 4 );
			}
		}
	}
}

ai_calculate_health()
{
	// After round 10, get exponentially harder
	if( level.round_number >= 10 )
	{
		level.zombie_health += Int( level.zombie_health * level.zombie_vars["zombie_health_increase_percent"] ); 
		return;
	}

	if( level.round_number > 1 )
	{
		level.zombie_health = Int( level.zombie_health + level.zombie_vars["zombie_health_increase"] ); 
	}

}

//put the conditions in here which should
//cause the failsafe to reset
round_spawn_failsafe()
{
	self endon("death");//guy just died

	//////////////////////////////////////////////////////////////
	//FAILSAFE "hack shit"  DT#33203
	//////////////////////////////////////////////////////////////
	prevorigin = self.origin;
	while(1)
	{
		if( !level.zombie_vars["zombie_use_failsafe"] )
		{
			return;
		}

		wait( 30 );

		//if i've torn a board down in the last 5 seconds, just 
		//wait 30 again.
		if ( isDefined(self.lastchunk_destroy_time) )
		{
			if ( (getTime() - self.lastchunk_destroy_time) < 5000 )
				continue; 
		}

		//fell out of world
		if ( self.origin[2] < level.zombie_vars["below_world_check"] )
		{
			self dodamage( self.health + 100, (0,0,0) );	
			break;
		}

		//hasnt moved 24 inches in 30 seconds?	
		if ( DistanceSquared( self.origin, prevorigin ) < 576 ) 
		{
			// DEBUG HACK
			self dodamage( self.health + 100, (0,0,0) );	
			break;
		}

		prevorigin = self.origin;
	}
	//////////////////////////////////////////////////////////////
	//END OF FAILSAFE "hack shit"
	//////////////////////////////////////////////////////////////
}

// Waits for the time and the ai to die
round_wait()
{
	/#
		if (GetDVarInt("zombie_rise_test"))
		{
			level waittill("forever"); // TESTING: don't advance rounds
		}
#/

	/#
		if ( GetDVarInt( "zombie_cheat" ) == 2 || GetDVarInt( "zombie_cheat" ) >= 4 )
		{
			level waittill("forever");
		}
	#/

		wait( 1 );

		while( get_enemy_count() > 0 || level.zombie_total > 0 || level.intermission )
		{
			wait( 0.5 );
		}
}

zombify_player()
{
	self maps\_zombiemode_score::player_died_penalty(); 

	if( !IsDefined( level.zombie_vars["zombify_player"] ) || !level.zombie_vars["zombify_player"] )
	{
		self thread spawnSpectator(); 
		return; 
	}

	self.ignoreme = true; 
	self.is_zombie = true; 
	self.zombification_time = getTime(); 

	self.team = "axis"; 
	self notify( "zombified" ); 

	if( IsDefined( self.revivetrigger ) )
	{
		self.revivetrigger Delete(); 
	}
	self.revivetrigger = undefined; 

	self setMoveSpeedScale( 0.3 ); 
	self reviveplayer(); 

	self TakeAllWeapons(); 
	self starttanning(); 
	self GiveWeapon( "zombie_melee", 0 ); 
	self SwitchToWeapon( "zombie_melee" ); 
	self DisableWeaponCycling(); 
	self DisableOffhandWeapons(); 
	self VisionSetNaked( "zombie_turned", 1 ); 

	maps\_utility::setClientSysState( "zombify", 1, self ); 	// Zombie grain goooo

	self thread maps\_zombiemode_spawner_asylum::zombie_eye_glow(); 

	// set up the ground ref ent
	self thread injured_walk(); 
	// allow for zombie attacks, but they lose points?

	self thread playerzombie_player_damage(); 
	self thread playerzombie_soundboard(); 
}

playerzombie_player_damage()
{
	self endon( "death" ); 
	self endon( "disconnect" ); 

	self thread playerzombie_infinite_health();  // manually keep regular health up
	self.zombiehealth = level.zombie_health; 

	// enable PVP damage on this guy
	// self EnablePvPDamage(); 

	while( 1 )
	{
		self waittill( "damage", amount, attacker, directionVec, point, type ); 

		if( !IsDefined( attacker ) || !IsPlayer( attacker ) )
		{
			wait( 0.05 ); 
			continue; 
		}

		self.zombiehealth -= amount; 

		if( self.zombiehealth <= 0 )
		{
			// "down" the zombie
			self thread playerzombie_downed_state(); 
			self waittill( "playerzombie_downed_state_done" ); 
			self.zombiehealth = level.zombie_health; 
		}
	}
}

playerzombie_downed_state()
{
	self endon( "death" ); 
	self endon( "disconnect" ); 

	downTime = 15; 

	startTime = GetTime(); 
	endTime = startTime +( downTime * 1000 ); 

	self thread playerzombie_downed_hud(); 

	self.playerzombie_soundboard_disable = true; 
	self thread maps\_zombiemode_spawner_asylum::zombie_eye_glow_stop(); 
	self DisableWeapons(); 
	self AllowStand( false ); 
	self AllowCrouch( false ); 
	self AllowProne( true ); 

	while( GetTime() < endTime )
	{
		wait( 0.05 ); 
	}

	self.playerzombie_soundboard_disable = false; 
	self thread maps\_zombiemode_spawner_asylum::zombie_eye_glow(); 
	self EnableWeapons(); 
	self AllowStand( true ); 
	self AllowCrouch( false ); 
	self AllowProne( false ); 

	self notify( "playerzombie_downed_state_done" ); 
}

playerzombie_downed_hud()
{
	self endon( "death" ); 
	self endon( "disconnect" ); 

	text = NewClientHudElem( self ); 
	text.alignX = "center"; 
	text.alignY = "middle"; 
	text.horzAlign = "center"; 
	text.vertAlign = "bottom"; 
	text.foreground = true; 
	text.font = "default"; 
	text.fontScale = 1.8; 
	text.alpha = 0; 
	text.color = ( 1.0, 1.0, 1.0 ); 
	text SetText( &"ZOMBIE_PLAYERZOMBIE_DOWNED" ); 

	text.y = -113; 	
	if( IsSplitScreen() )
	{
		text.y = -137; 
	}

	text FadeOverTime( 0.1 ); 
	text.alpha = 1; 

	self waittill( "playerzombie_downed_state_done" ); 

	text FadeOverTime( 0.1 ); 
	text.alpha = 0; 
}

playerzombie_infinite_health()
{
	self endon( "death" ); 
	self endon( "disconnect" ); 

	bighealth = 100000; 

	while( 1 )
	{
		if( self.health < bighealth )
		{
			self.health = bighealth; 
		}

		wait( 0.1 ); 
	}
}

playerzombie_soundboard()
{
	self endon( "death" ); 
	self endon( "disconnect" ); 

	self.playerzombie_soundboard_disable = false; 

	self.buttonpressed_use = false; 
	self.buttonpressed_attack = false; 
	self.buttonpressed_ads = false; 

	self.useSound_waitTime = 3 * 1000;  // milliseconds
	self.useSound_nextTime = GetTime(); 
	useSound = "playerzombie_usebutton_sound"; 

	self.attackSound_waitTime = 3 * 1000; 
	self.attackSound_nextTime = GetTime(); 
	attackSound = "playerzombie_attackbutton_sound"; 

	self.adsSound_waitTime = 3 * 1000; 
	self.adsSound_nextTime = GetTime(); 
	adsSound = "playerzombie_adsbutton_sound"; 

	self.inputSound_nextTime = GetTime();  // don't want to be able to do all sounds at once

	while( 1 )
	{
		if( self.playerzombie_soundboard_disable )
		{
			wait( 0.05 ); 
			continue; 
		}

		if( self UseButtonPressed() )
		{
			if( self can_do_input( "use" ) )
			{
				self thread playerzombie_play_sound( useSound ); 
				self thread playerzombie_waitfor_buttonrelease( "use" ); 
				self.useSound_nextTime = GetTime() + self.useSound_waitTime; 
			}
		}
		else if( self AttackButtonPressed() )
		{
			if( self can_do_input( "attack" ) )
			{
				self thread playerzombie_play_sound( attackSound ); 
				self thread playerzombie_waitfor_buttonrelease( "attack" ); 
				self.attackSound_nextTime = GetTime() + self.attackSound_waitTime; 
			}
		}
		else if( self AdsButtonPressed() )
		{
			if( self can_do_input( "ads" ) )
			{
				self thread playerzombie_play_sound( adsSound ); 
				self thread playerzombie_waitfor_buttonrelease( "ads" ); 
				self.adsSound_nextTime = GetTime() + self.adsSound_waitTime; 
			}
		}

		wait( 0.05 ); 
	}
}

can_do_input( inputType )
{
	if( GetTime() < self.inputSound_nextTime )
	{
		return false; 
	}

	canDo = false; 

	switch( inputType )
	{
	case "use":
		if( GetTime() >= self.useSound_nextTime && !self.buttonpressed_use )
		{
			canDo = true; 
		}
		break; 

	case "attack":
		if( GetTime() >= self.attackSound_nextTime && !self.buttonpressed_attack )
		{
			canDo = true; 
		}
		break; 

	case "ads":
		if( GetTime() >= self.useSound_nextTime && !self.buttonpressed_ads )
		{
			canDo = true; 
		}
		break; 

	default:
		ASSERTMSG( "can_do_input(): didn't recognize inputType of " + inputType ); 
		break; 
	}

	return canDo; 
}

playerzombie_play_sound( alias )
{
	self play_sound_on_ent( alias ); 
}

playerzombie_waitfor_buttonrelease( inputType )
{
	if( inputType != "use" && inputType != "attack" && inputType != "ads" )
	{
		ASSERTMSG( "playerzombie_waitfor_buttonrelease(): inputType of " + inputType + " is not recognized." ); 
		return; 
	}

	notifyString = "waitfor_buttonrelease_" + inputType; 
	self notify( notifyString ); 
	self endon( notifyString ); 

	if( inputType == "use" )
	{
		self.buttonpressed_use = true; 
		while( self UseButtonPressed() )
		{
			wait( 0.05 ); 
		}
		self.buttonpressed_use = false; 
	}

	else if( inputType == "attack" )
	{
		self.buttonpressed_attack = true; 
		while( self AttackButtonPressed() )
		{
			wait( 0.05 ); 
		}
		self.buttonpressed_attack = false; 
	}

	else if( inputType == "ads" )
	{
		self.buttonpressed_ads = true; 
		while( self AdsButtonPressed() )
		{
			wait( 0.05 ); 
		}
		self.buttonpressed_ads = false; 
	}
}

player_damage_override( eInflictor, eAttacker, iDamage, iDFlags, sMeansOfDeath, sWeapon, vPoint, vDir, sHitLoc, modelIndex, psOffsetTime )
{
	/*	
	if(self hasperk("specialty_armorvest") && eAttacker != self)
	{
			iDamage = iDamage * 0.75;
			iprintlnbold(idamage);
	}*/

	if( iDamage < self.health )
	{
		//iprintlnbold(iDamage);
		return;
	}
	if( level.intermission )
	{
		level waittill( "forever" );
	}

	players = get_players();
	count = 0;
	for( i = 0; i < players.size; i++ )
	{
		if( players[i] == self || players[i].is_zombie || players[i] maps\_laststand::player_is_in_laststand() || players[i].sessionstate == "spectator" )
		{
			count++;
		}
	}

	if( count < players.size )
	{
		return;
	}

	self.intermission = true;

	self thread maps\_laststand::PlayerLastStand( eInflictor, eAttacker, iDamage, sMeansOfDeath, sWeapon, vDir, sHitLoc, psOffsetTime );
	self player_fake_death();

	if( count == players.size )
	{
		end_game();
	}
}

end_game()
{
	level.intermission = true;

	update_leaderboards();

	game_over = NewHudElem( self );
	game_over.alignX = "center";
	game_over.alignY = "middle";
	game_over.horzAlign = "center";
	game_over.vertAlign = "middle";
	game_over.y -= 10;
	game_over.foreground = true;
	game_over.fontScale = 3;
	game_over.alpha = 0;
	game_over.color = ( 1.0, 1.0, 1.0 );
	game_over SetText( &"ZOMBIE_GAME_OVER" );

	game_over FadeOverTime( 1 );
	game_over.alpha = 1;

	survived = NewHudElem( self );
	survived.alignX = "center";
	survived.alignY = "middle";
	survived.horzAlign = "center";
	survived.vertAlign = "middle";
	survived.y += 20;
	survived.foreground = true;
	survived.fontScale = 2;
	survived.alpha = 0;
	survived.color = ( 1.0, 1.0, 1.0 );

	if( level.round_number < 2 )
	{
		survived SetText( &"ZOMBIE_SURVIVED_ROUND" );
	}
	else
	{
		survived SetText( &"ZOMBIE_SURVIVED_ROUNDS", level.round_number );
	}

	survived FadeOverTime( 1 );
	survived.alpha = 1;

	wait( 1 );

	//TUEY had to change this since we are adding other musical elements
	setmusicstate("end_of_game");
	setbusstate("default");

	//play_sound_at_pos( "end_of_game", ( 0, 0, 0 ) );
	wait( 2 );
	intermission();

	wait( level.zombie_vars["zombie_intermission_time"] );

	level notify( "stop_intermission" );
	array_thread( get_players(), ::player_exit_level );

	wait( 1.5 );

	if( is_coop() )
	{
		ExitLevel( false );
	}
	else
	{
		MissionFailed();
	}

	// Let's not exit the function
	wait( 666 );
}

update_leaderboards()
{
	if( level.systemLink || IsSplitScreen() )
	{
		return; 
	}

	nazizombies_upload_highscore();	
}

player_fake_death()
{
	level notify ("fake_death");
	self notify ("fake_death");

	self TakeAllWeapons();
	self AllowStand( false );
	self AllowCrouch( false );
	self AllowProne( true );

	self.ignoreme = true;
	self EnableInvulnerability();

	wait( 1 );
	self FreezeControls( true );
}

player_exit_level()
{
	self AllowStand( true );
	self AllowCrouch( false );
	self AllowProne( false );

	if( IsDefined( self.game_over_bg ) )
	{
		self.game_over_bg.foreground = true;
		self.game_over_bg.sort = 100;
		self.game_over_bg FadeOverTime( 1 );
		self.game_over_bg.alpha = 1;
	}
}

player_killed_override()
{
	// BLANK
	level waittill( "forever" );
}


injured_walk()
{
	self.ground_ref_ent = Spawn( "script_model", ( 0, 0, 0 ) ); 

	self.player_speed = 50; 

	// TODO do death countdown	
	self AllowSprint( false ); 
	self AllowProne( false ); 
	self AllowCrouch( false ); 
	self AllowAds( false ); 
	self AllowJump( false ); 

	self PlayerSetGroundReferenceEnt( self.ground_ref_ent ); 
	self thread limp(); 
}

limp()
{
	level endon( "disconnect" ); 
	level endon( "death" ); 
	// TODO uncomment when/if SetBlur works again
	//self thread player_random_blur(); 

	stumble = 0; 
	alt = 0; 

	while( 1 )
	{
		velocity = self GetVelocity(); 
		player_speed = abs( velocity[0] ) + abs( velocity[1] ); 

		if( player_speed < 10 )
		{
			wait( 0.05 ); 
			continue; 
		}

		speed_multiplier = player_speed / self.player_speed; 

		p = RandomFloatRange( 3, 5 ); 
		if( RandomInt( 100 ) < 20 )
		{
			p *= 3; 
		}
		r = RandomFloatRange( 3, 7 ); 
		y = RandomFloatRange( -8, -2 ); 

		stumble_angles = ( p, y, r ); 
		stumble_angles = vector_multiply( stumble_angles, speed_multiplier ); 

		stumble_time = RandomFloatRange( .35, .45 ); 
		recover_time = RandomFloatRange( .65, .8 ); 

		stumble++; 
		if( speed_multiplier > 1.3 )
		{
			stumble++; 
		}

		self thread stumble( stumble_angles, stumble_time, recover_time ); 

		level waittill( "recovered" ); 
	}
}

stumble( stumble_angles, stumble_time, recover_time, no_notify )
{
	stumble_angles = self adjust_angles_to_player( stumble_angles ); 

	self.ground_ref_ent RotateTo( stumble_angles, stumble_time, ( stumble_time/4*3 ), ( stumble_time/4 ) ); 
	self.ground_ref_ent waittill( "rotatedone" ); 

	base_angles = ( RandomFloat( 4 ) - 4, RandomFloat( 5 ), 0 ); 
	base_angles = self adjust_angles_to_player( base_angles ); 

	self.ground_ref_ent RotateTo( base_angles, recover_time, 0, ( recover_time / 2 ) ); 
	self.ground_ref_ent waittill( "rotatedone" ); 

	if( !IsDefined( no_notify ) )
	{
		level notify( "recovered" ); 
	}
}

adjust_angles_to_player( stumble_angles )
{
	pa = stumble_angles[0]; 
	ra = stumble_angles[2]; 

	rv = AnglesToRight( self.angles ); 
	fv = AnglesToForward( self.angles ); 

	rva = ( rv[0], 0, rv[1]*-1 ); 
	fva = ( fv[0], 0, fv[1]*-1 ); 
	angles = vector_multiply( rva, pa ); 
	angles = angles + vector_multiply( fva, ra ); 
	return angles +( 0, stumble_angles[1], 0 ); 
}

coop_player_spawn_placement()
{
	structs = getstructarray( "initial_spawn_points", "targetname" ); 

	flag_wait( "all_players_connected" ); 
	
	//chrisp - adding support for overriding the default spawning method
	if(flag("spawn_point_override"))
	{
		return;
	}
	players = get_players(); 

	for( i = 0; i < players.size; i++ )
	{
		players[i] setorigin( structs[i].origin ); 
		players[i] setplayerangles( structs[i].angles ); 
	}
}


player_zombie_breadcrumb()
{
	self endon( "disconnect" ); 
	self endon( "spawned_spectator" ); 
	level endon( "intermission" );

	self.zombie_breadcrumbs = []; 
	self.zombie_breadcrumb_distance = 24 * 24; // min dist (squared) the player must move to drop a crumb
	self.zombie_breadcrumb_area_num = 3;	   // the number of "rings" the area breadcrumbs use
	self.zombie_breadcrumb_area_distance = 16; // the distance between each "ring" of the area breadcrumbs

	self store_crumb( self.origin ); 
	last_crumb = self.origin;

	self thread debug_breadcrumbs(); 

	while( 1 )
	{
		wait_time = 0.1;
		
		store_crumb = true; 
		airborne = false;
		crumb = self.origin;
		
		if ( !self IsOnGround() )
		{
			airborne = true;
			store_crumb = false; 
			wait_time = 0.05;
		}
		
		if( !airborne && DistanceSquared( crumb, last_crumb ) < self.zombie_breadcrumb_distance )
		{
			store_crumb = false; 
		}

		if ( airborne && self IsOnGround() )
		{
			// player was airborne, store crumb now that he's on the ground
			store_crumb = true;
			airborne = false;
		}

		if( store_crumb )
		{
			debug_print( "Player is storing breadcrumb " + crumb );
			last_crumb = crumb;
			self store_crumb( crumb );
		}

		wait( wait_time ); 
	}
}


store_crumb( origin )
{
	offsets = [];
	height_offset = 32;
	
	index = 0;
	for( j = 1; j <= self.zombie_breadcrumb_area_num; j++ )
	{
		offset = ( j * self.zombie_breadcrumb_area_distance );
		
		offsets[0] = ( origin[0] - offset, origin[1], origin[2] );
		offsets[1] = ( origin[0] + offset, origin[1], origin[2] );
		offsets[2] = ( origin[0], origin[1] - offset, origin[2] );
		offsets[3] = ( origin[0], origin[1] + offset, origin[2] );

		offsets[4] = ( origin[0] - offset, origin[1], origin[2] + height_offset );
		offsets[5] = ( origin[0] + offset, origin[1], origin[2] + height_offset );
		offsets[6] = ( origin[0], origin[1] - offset, origin[2] + height_offset );
		offsets[7] = ( origin[0], origin[1] + offset, origin[2] + height_offset );

		for ( i = 0; i < offsets.size; i++ )
		{
			self.zombie_breadcrumbs[index] = offsets[i];
			index++;
		}
	}
}


////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
/////////////////////////////////////////////////LEADERBOARD CODE///////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

//CODER MOD: TOMMY K
nazizombies_upload_highscore()
{
	// Nazi Zombie Leaderboards
	// nazi_zombie_prototype_waves = 13
	// nazi_zombie_prototype_points = 14

	// this has gotta be the dumbest way of doing this, but at 1:33am in the morning my brain is fried!
	playersRank = 1;
	if( level.players_playing == 1 )
		playersRank = 4;
	else if( level.players_playing == 2 )
		playersRank = 3;
	else if( level.players_playing == 3 )
		playersRank = 2;

	map_name = GetDvar( "mapname" );

	if ( !isZombieLeaderboardAvailable( map_name, "waves" ) || !isZombieLeaderboardAvailable( map_name, "points" ) )
		return;

	players = get_players();		
	for( i = 0; i < players.size; i++ )
	{
		pre_highest_wave = players[i] playerZombieStatGet( map_name, "highestwave" ); 
		pre_time_in_wave = players[i] playerZombieStatGet( map_name, "timeinwave" );

		new_highest_wave = level.round_number + "" + playersRank;
		new_highest_wave = int( new_highest_wave );

		if( new_highest_wave >= pre_highest_wave )
		{
			if( players[i].zombification_time == 0 )
			{
				players[i].zombification_time = getTime();
			}

			player_survival_time = players[i].zombification_time - level.round_start_time; 
			player_survival_time = int( player_survival_time/1000 ); 			

			if( new_highest_wave > pre_highest_wave || player_survival_time > pre_time_in_wave )
			{
				rankNumber = makeRankNumber( level.round_number, playersRank, player_survival_time );

				leaderboard_number = getZombieLeaderboardNumber( map_name, "waves" );

				players[i] UploadScore( leaderboard_number, int(rankNumber), level.round_number, player_survival_time, level.players_playing ); 
				//players[i] UploadScore( leaderboard_number, int(rankNumber), level.round_number ); 

				players[i] playerZombieStatSet( map_name, "highestwave", new_highest_wave );
				players[i] playerZombieStatSet( map_name, "timeinwave", player_survival_time );	
			}
		}		

		pre_total_points = players[i] playerZombieStatGet( map_name, "totalpoints" ); 				
		if( players[i].score_total > pre_total_points )
		{
			leaderboard_number = getZombieLeaderboardNumber( map_name, "points" );

			players[i] UploadScore( leaderboard_number, players[i].score_total, players[i].kills, level.players_playing ); 

			players[i] playerZombieStatSet( map_name, "totalpoints", players[i].score_total );	
		}			
	}
}

isZombieLeaderboardAvailable( map, type )
{
	if ( !isDefined( level.zombieLeaderboardNumber[map][type] ) )
		return 0;

	return 1;
}

getZombieLeaderboardNumber( map, type )
{
	if ( !isDefined( level.zombieLeaderboardNumber[map][type] ) )
		assertMsg( "Unknown leaderboard number for map " + map + "and type " + type );
	
	return level.zombieLeaderboardNumber[map][type];
}

getZombieStatVariable( map, variable )
{
	if ( !isDefined( level.zombieLeaderboardStatVariable[map][variable] ) )
		assertMsg( "Unknown stat variable " + variable + " for map " + map );
		
	return level.zombieLeaderboardStatVariable[map][variable];
}

playerZombieStatGet( map, variable )
{
	stat_variable = getZombieStatVariable( map, variable );
	result = self zombieStatGet( stat_variable );

	return result;
}

playerZombieStatSet( map, variable, value )
{
	stat_variable = getZombieStatVariable( map, variable );
	self zombieStatSet( stat_variable, value );
}

makeRankNumber( wave, players, time )
{
	if( time > 86400 ) 
		time = 86400; // cap it at like 1 day, need to cap cause you know some muppet is gonna end up trying it

	//pad out time
	padding = "";
	if ( 10 > time )
		padding += "0000";
	else if( 100 > time )
		padding += "000";
	else if( 1000 > time )
		padding += "00";
	else if( 10000 > time )
		padding += "0";

	rank = wave + "" + players + padding + time;

	return rank;
}


//CODER MOD: TOMMY K
/*
=============
statGet

Returns the value of the named stat
=============
*/
zombieStatGet( dataName )
{
	if( level.systemLink || true == IsSplitScreen() )
	{
		return; 
	}

	return self getStat( int(tableLookup( "mp/playerStatsTable.csv", 1, dataName, 0 )) );
}

//CODER MOD: TOMMY K
/*
=============
setStat

Sets the value of the named stat
=============
*/
zombieStatSet( dataName, value )
{
	if( level.systemLink || true == IsSplitScreen() )
	{
		return; 
	}

	self setStat( int(tableLookup( "mp/playerStatsTable.csv", 1, dataName, 0 )), value );	
}


////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

//
// INTERMISSION =========================================================== //
//

intermission()
{
	level.intermission = true;
	level notify( "intermission" );

	players = get_players();
	for( i = 0; i < players.size; i++ )
	{
		setclientsysstate( "levelNotify", "zi", players[i] ); // Tell clientscripts we're in zombie intermission

		players[i] SetClientDvars( "cg_thirdPerson", "0",
			"cg_fov", "65" );

		players[i].health = 100; // This is needed so the player view doesn't get stuck
		players[i] thread player_intermission();
	}

	wait( 0.25 );

	// Delay the last stand monitor so we are 100% sure the zombie intermission ("zi") is set on the cients
	players = get_players();
	for( i = 0; i < players.size; i++ )
	{
		setClientSysState( "lsm", "1", players[i] );
	}

	visionset = "zombie";
	if( IsDefined( level.zombie_vars["intermission_visionset"] ) )
	{
		visionset = level.zombie_vars["intermission_visionset"];
	}

	level thread maps\_utility::set_all_players_visionset( visionset, 2 );
	level thread zombie_game_over_death();
}

zombie_game_over_death()
{
	// Kill remaining zombies, in style!
	zombies = GetAiArray( "axis" );
	for( i = 0; i < zombies.size; i++ )
	{
		if( !IsAlive( zombies[i] ) )
		{
			continue;
		}

		zombies[i] SetGoalPos( zombies[i].origin );
	}

	for( i = 0; i < zombies.size; i++ )
	{
		if( !IsAlive( zombies[i] ) )
		{
			continue;
		}

		wait( 0.5 + RandomFloat( 2 ) );

		zombies[i] maps\_zombiemode_spawner_asylum::zombie_head_gib();
		zombies[i] DoDamage( zombies[i].health + 666, zombies[i].origin );
	}
}

player_intermission()
{
	self closeMenu();
	self closeInGameMenu();

	level endon( "stop_intermission" );

	//Show total gained point for end scoreboard and lobby
	self.score = self.score_total;

	self.sessionstate = "intermission";
	self.spectatorclient = -1; 
	self.killcamentity = -1; 
	self.archivetime = 0; 
	self.psoffsettime = 0; 
	self.friendlydamage = undefined;

	points = getstructarray( "intermission", "targetname" );

	if( !IsDefined( points ) || points.size == 0 )
	{
		points = getentarray( "info_intermission", "classname" ); 
		if( points.size < 1 )
		{
			println( "NO info_intermission POINTS IN MAP" ); 
			return;
		}	
	}

	self.game_over_bg = NewClientHudelem( self );
	self.game_over_bg.horzAlign = "fullscreen";
	self.game_over_bg.vertAlign = "fullscreen";
	self.game_over_bg SetShader( "black", 640, 480 );
	self.game_over_bg.alpha = 1;

	org = undefined;
	while( 1 )
	{
		points = array_randomize( points );
		for( i = 0; i < points.size; i++ )
		{
			point = points[i];
			// Only spawn once if we are using 'moving' org
			// If only using info_intermissions, this will respawn after 5 seconds.
			if( !IsDefined( org ) )
			{
				self Spawn( point.origin, point.angles );
			}

			// Only used with STRUCTS
			if( IsDefined( points[i].target ) )
			{
				if( !IsDefined( org ) )
				{
					org = Spawn( "script_origin", self.origin + ( 0, 0, -60 ) );
				}

				self LinkTo( org, "", ( 0, 0, -60 ), ( 0, 0, 0 ) );
				self SetPlayerAngles( points[i].angles );
				org.origin = points[i].origin;

				speed = 20;
				if( IsDefined( points[i].speed ) )
				{
					speed = points[i].speed;
				}

				target_point = getstruct( points[i].target, "targetname" );
				dist = Distance( points[i].origin, target_point.origin );
				time = dist / speed;

				q_time = time * 0.25;
				if( q_time > 1 )
				{
					q_time = 1;
				}

				self.game_over_bg FadeOverTime( q_time );
				self.game_over_bg.alpha = 0;

				org MoveTo( target_point.origin, time, q_time, q_time );
				wait( time - q_time );

				self.game_over_bg FadeOverTime( q_time );
				self.game_over_bg.alpha = 1;

				wait( q_time );
			}
			else
			{
				self.game_over_bg FadeOverTime( 1 );
				self.game_over_bg.alpha = 0;

				wait( 5 );

				self.game_over_bg FadeOverTime( 1 );
				self.game_over_bg.alpha = 1;

				wait( 1 );
			}
		}
	}
}

prevent_near_origin()
{
	while (1)
	{
		players = get_players();

		for (i = 0; i < players.size; i++)
		{
			for (q = 0; q < players.size; q++)
			{
				if (players[i] != players[q])
				{	
					if (check_to_kill_near_origin(players[i], players[q]))
					{
						p1_org = players[i].origin;
						p2_org = players[q].origin;

						wait 5;

						if (check_to_kill_near_origin(players[i], players[q]))
						{
							if ( (distance(players[i].origin, p1_org) < 30) && distance(players[q].origin, p2_org) < 30)
							{
								setsaveddvar("player_deathInvulnerableTime", 0);
								players[i] DoDamage( players[i].health + 1000, players[i].origin, undefined, undefined, "riflebullet" );
								setsaveddvar("player_deathInvulnerableTime", level.startInvulnerableTime);	
							}
						}
					}	
				}
			}	
		}

		wait 0.2;
	}
}

check_to_kill_near_origin(player1, player2)
{
	if (!isdefined(player1) || !isdefined(player2))
	{
		return false;		
	}

	if (distance(player1.origin, player2.origin) > 12)
	{
		return false;
	}

	if ( player1 maps\_laststand::player_is_in_laststand() || player2 maps\_laststand::player_is_in_laststand() )
	{
		return false;
	}

	if (!isalive(player1) || !isalive(player2))
	{
		return false;		
	}

	return true;
}

check_for_jugg_perk()
{

	
	while(true)
	{
		players = getplayers();
		for(i = 0; i < players.size; i++)
		{
			if(players[i] hasperk("specialty_armorvest") && !isdefined(players[i].is_burning))
			{
				players[i].health += 40;
				//iprintlnbold("I gain some health");
				if(players[i].health > 160)
				{
					players[i].health = 160;
					
				}

			}

		}

		wait(0.5);


	}


}
