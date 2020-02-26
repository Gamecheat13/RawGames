#include common_scripts\utility;
#include maps\_utility;
#include maps\_vehicle;
#include maps\_so_code;
#include maps\_specialops;
#include maps\_hud_util;

#define ALLY_SWITCH_BUTTON "DPAD_RIGHT"
#define STINGER_MIN_DISTANCE 500

// ======================================================================
//	Special Ops Mode: WAR
// ======================================================================


// ==========================================================================
// war INITS
// ==========================================================================

war_globals_init()
{
	if( !IsDefined(level.so) )
		level.so = SpawnStruct();

	level.so.CONST_DEATH_FAIL_WAVE						= 0;	//if dead in this wave, player fails

	level.so.CONST_START_REV_TIMER						= 120;	//seconds for revivinG coop partner
	level.so.CONST_MIN_REV_TIMER						= 30;	//min time for reviving coop partner
	level.so.CONST_REV_TIMER_DECREASE					= 8;	//seconds decreased for reviving coop partner

	level.so.CONST_WAVE_START_TIMEOUT					= 8;	//timeout that will trigger first wave if player didn't
	level.so.CONST_WAVE_DELAY_TOTAL						= 30;	//total delay between waves. other delays are subtracted from this. IW: 30
	level.so.CONST_WAVE_DELAY_BEFORE_READY_UP			= 5;	//delay before players are prompted to ready up
	level.so.CONST_WAVE_DELAY_COUNTDOWN					= 5;	//time remaining when when the large countdown shows up in the center of the screen
	level.so.CONST_WAVE_ENDED_TIMER_FADE_DELAY			= 1.75;	//time after a wave ending before the wave timer fades
	level.so.CONST_WAVE_AI_LEFT_TILL_AGGRO				= 4;	//if only this many AIs left, AIs become aggressive

	level.so.CONST_WAVE_REENFORCEMENT_SQUAD				= 0;	//number of squads to re-enforce
	level.so.CONST_WAVE_REENFORCEMENT_SPECIAL_AI		= 2;	//number of special AIs to re-enforce

	level.so.CONST_CAMP_RESPONSE_INTERVAL				= 8;	//enemies respond to player camping every X seconds

	level.so.CONST_ARMOR_POINTS_INITIAL_DISPLAY_TIME	= 14;	//seconds to display armor HP when level starts
	level.so.CONST_ARMOR_POINTS_DISPLAY_TIME			= 6;	//seconds to display armor HP when damaged

	// Player load out from table
	level.so.LOADOUT_TABLE_DEFAULT						= "sp/so_war/war_waves.csv";	// loadout is in waves table for now
	level.so.TABLE_INDEX								= 0;	// Indexing
	level.so.TABLE_SLOT									= 1;	// Load out slot, such as primary weapon, grenades etc...
	level.so.TABLE_REF									= 2;	// Reference string of the item
	level.so.TABLE_AMMO									= 3;	// Ammo for weapon or equipments

	if ( !isdefined( level.loadout_table ) )
		level.loadout_table	= level.so.LOADOUT_TABLE_DEFAULT;

	
}

war_preload()
{
	// war globals
	war_globals_init();
	maps\_so_war_gametypes::war_gametypes_init();

	// war precache
	maps\_so_war_precache::main();
	maps\_so_war_loot::loot_init();
	maps\_so_war_loot::loot_preload(); // precached systematically
	maps\_so_war_classes::preload();
	maps\_so_war_AI::AI_preload();
	maps\_so_war_support::preload();
	maps\sp_killstreaks\_killstreaks::preload();
	maps\_perks_sp::perks_preload();

	// turn on flanking
	SetSavedDvar("ai_coverScore_flanking", 13);
	
	enable_damagefeedback();
	thread MP_ents_cleanup();
	
	/#
	AddDebugCommand("exec devgui_so_war\n");
	#/
}

war_postload()
{
	//maps\_so_war_armory::armory_postload();
	maps\_so_war_loot::loot_postload();
	maps\_so_war_support::postload();
	maps\_laststand::init( true );
	
	// init the stinger
	maps\_heatseekingmissile::init();
	maps\_heatseekingmissile::SetMinimumSTIDistance( STINGER_MIN_DISTANCE );

}

// main survial start
war_init(scenario)
{
	// war flag init
	flag_init( "bosses_spawned" );
	flag_init( "aggressive_mode" );
	flag_init( "combat_music" );
	flag_init( "boss_music" );
	flag_init( "slamzoom_finished" );
	flag_init( "so_player_death_nofail" );
	flag_init( "start_war" );
	flag_init( "all_ally_dead" );
	flag_init( "allies_spawned" );
	flag_init( "war_mission_completed");
	flag_init( "war_switch_avail");
	flag_init( "intro_complete");
	
	flag_set( "so_player_death_nofail" );
	
	// hardcoded numbers to match _so_war.csc
	level.CLIENT_FLAG_ALLY_EXTRA_CAM 	= 1;
	level.CLIENT_FLAG_ALLY_SWITCH 		= 2;
	level.CLIENT_FLAG_REMOTE_MISSILE 	= 3;


	level.custom_eog_no_defaults			= true;
	level.teamBased 						= true;
 	game["entity_headicon_allies"]			= "hud_specops_ui_deltasupport";
	game["entity_headicon_axis"]			= "hudicon_spetsnaz_ctf_flag_carry";
	
	// must be before waves table setup
	level.wave_spawn_locs = maps\_squad_enemies::squad_setup( true );

	wait_for_first_player();
	level.players = get_players();
	
	war_init_names();
	maps\_names::add_override_name_func("american", ::war_get_names);
	maps\_perks_sp::perks_init(true);
	maps\_so_war_anim::main();
	maps\_so_war_classes::init();
	maps\_so_war_AI::AI_init();
	maps\_so_war_support::init();
	
	maps\_compass::setupMiniMap(level.compass_map_name); 
	///////////////////////////////////////////////////////////////////////////////
	//killstreaks	
	level thread setup_killstreaks();
	level thread maps\sp_killstreaks\_killstreaks::init();
	level.killstreakscountsdisabled	= true;
	///////////////////////////////////////////////////////////////////////////////
	
	// setup player funcs on spawn
	level thread setup_players();
	OnSaveRestored_Callback( maps\_so_war::setup_players_loadgame );
	
	// intercept player death
	level.prevent_player_damage = maps\_so_war_classes::Callback_PreventPlayerDamage;
	
	/#
		level thread debug_draw();
	#/

	// war logics
	level thread maps\_so_war_gametypes::war_set_scenario(scenario);
	level thread maps\_so_war_gametypes::war_watch_player_life();
	level thread war_logic();
}

setup_killstreaks()
{
	flag_wait( "all_players_connected" );
	
	while( !IsDefined( level.tbl_killStreakData ) && level.tbl_killStreakData.size == 0 )
	{
		wait( 0.05 );
	}
	foreach (player in GetPlayers() )
	{
		player resetUsability();
	
		player.killstreak[0] = level.tbl_killStreakData[37];//mortar
		player.killstreak[1] = level.tbl_killStreakData[38];//supplydrop
		player.killstreak[2] = level.tbl_killStreakData[39];//ai helicopter
		player.killstreak[3] = level.tbl_killStreakData[40];//turret
		player.killstreak[4] = level.tbl_killStreakData[41];//radar
	}
}

// run the war logic after the game loads
war_logic()
{
	// need to wait until the first frame of the game before calling getPlayerData or setPlayerData
	// this is because we may not have our coop player stats until the game is running
	wait( 0.05 ); 

	level thread war_hud();
	
	// temp stinger music
	thread intro_music();
	
	flag_wait( "start_war");//flag is set in _so_war_gametypes

			
	level thread war_wave_maker();
	level thread war_population_manager();
}


// ==========================================================================
// SETUP PLAYERS
// ==========================================================================

setup_players()
{
	players = GetPlayers();
	foreach( player in players )
	{
		player thread maps\_so_war_support::give_loadout();
		player thread maps\_so_war_support::watchWeaponChange();
		player thread maps\_so_war_classes::watchKillstreakUse();
		player thread maps\_so_war_switch::ally_switch_think();
	}
	
	// waves spawn after this wait
	flag_wait( "start_war");//flag is set in _so_war_gametypes
	
	foreach( player in players )
	{
		//player thread camping_think();
		//player thread decrease_rev_time();
	}
}

setup_players_loadgame()
{
	players = GetPlayers();
	foreach( player in players )
	{
		player thread maps\_so_war_support::give_loadout();
	}
}

decrease_rev_time()
{
	if ( !is_coop() )
		return;
		
	while ( 1 )
	{
		level waittill( "wave_ended" );

		rev_time = level.so.CONST_START_REV_TIMER;
		rev_time = rev_time - ( level.current_wave * level.so.CONST_REV_TIMER_DECREASE );
		rev_time = max( rev_time, level.so.CONST_MIN_REV_TIMER );
		
		self.laststand_info.bleedout_time_default = rev_time;
	}
}


// ==========================================================================
// Population Logic
// ==========================================================================
war_population_turn_off_minimum_enemy()
{
	level.enemy_population = undefined;
}

war_population_maintain_minimum_enemy(ai_count)
{
	assert(isDefined(ai_count),"Manadatory paramter is undefined");
	assert(ai_count < 28,"ai_count cannot exceed 28");
	level.enemy_population = ai_count;
}

war_population_maintain_minimum_enemy_for_a_time(ai_count,time_in_seconds,delay_in_seconds)
{
	assert(isDefined(ai_count),"Manadatory paramter is undefined");
	assert(ai_count < 28,"ai_count cannot exceed 28");
	
	if(isDefined(delay_in_seconds))
	{
		wait(delay_in_seconds);
	}
	
	war_population_maintain_minimum_enemy(ai_count);
	if ( isDefined(time_in_seconds) )
	{
		wait(time_in_seconds);
		war_population_turn_off_minimum_enemy();
	}
}

war_population_manager()
{
	level endon( "special_op_terminated" );

	while(1)
	{
		if (isDefined(level.enemy_population))
		{
			total_enemies = get_total_enemies();
			if ( total_enemies < level.enemy_population )
			{
				// spawn squads
				squad_array			= get_squad_array( level.current_wave );	// array of squad sizes
				assert( isdefined( squad_array ) && squad_array.size );
			
				foreach ( squad_size in squad_array )
				{
					if ( squad_size > 0 )
					{
						spawn_squad( 1, squad_size );	//spawn_squad(num of squads,squad size)
						total_enemies = get_total_enemies();
						if ( !isDefined(level.enemy_population) || total_enemies > level.enemy_population )
						{
							break;
						}
					}
				}
			}
		}
		wait 1;
	}
}



// ==========================================================================
// WAVE LOGIC
// ==========================================================================

war_waves_setup()
{
	// wave setup
	level.pmc_alljuggernauts 			= false;
	level.skip_juggernaut_intro_sound	= true;	// we have boss music
//	level.uav_struct.view_cone			= 12;	// enlarged view cone for remote missile
	
	// add all bad guys to remote_missile target
//	array_thread( level.players, maps\_remotemissile_utility::setup_remote_missile_target );
//	add_global_spawn_function( "axis", ::ai_remote_missile_fof_outline );

	// tracking
	level.current_wave 	= 1;
	level.waves_completed = 0;
}

war_set_wave_to(waveNum)
{
	level.current_wave = waveNum;
	level notify("wave_set");
}

war_wave_maker()
{
	level endon( "special_op_terminated" );
	
	//setup waves
	war_waves_setup();

	while(1)
	{
		wave_notify = self waittill_any_return( "wave_ended", "new_wave", "repeat_wave", "wave_set");
		// Update Wave after the intermission
		if ( isDefined(wave_notify) ) 
		{
			if ( wave_notify == "wave_ended" || wave_notify == "new_wave" )
			{
				if ( !level.war_wave[level.current_wave].repeating )
				{
					level.current_wave++;
					
					assert(isDefined(level.war_wave[level.current_wave]),"Current Wave is NOT defined.");
				}
			}
			if ( wave_notify == "wave_set" )
			{
				self notify ("war_wave");//terminate the current wave
				total_enemies = get_total_enemies();
				
				while (total_enemies > maps\_so_war_ai::get_min_ai_threshold(level.current_wave)	 )
				{ //wait for min threshold before kicking off new wave
					level waittill_any_timeout( 1.0, "axis_died" );
					total_enemies = get_total_enemies();
				}
			}
			//war_wave_pickup_downed_players();
		}
		self thread war_wave();
	}
}


//main wave logic, spawn location logic
war_wave()
{
	self notify("war_wave");
	self endon("war_wave");
	level endon( "special_op_terminated" );
	
	current_wave = level.current_wave;

	delay = get_wave_startdelay( current_wave );
	if ( delay > 0 )
		wait(delay);
	
	/#
		// devgui stuff
		if( GetDvarInt("war_wave_index") >= 0 )
		{
			level.current_wave = GetDvarInt("war_wave_index");
			current_wave = level.current_wave;
		}
		// devgui stuff
		while( GetDvarInt("war_wave_paused") == 1 )
		{
			wait(0.05);
		}
	#/
	
	// spawn squads
	squad_array			= get_squad_array( current_wave );	// array of squad sizes
	
	assert( isdefined( squad_array ) && squad_array.size );

	foreach ( squad_size in squad_array )
	{
		if ( squad_size > 0 )
			thread spawn_squad( 1, squad_size );	//spawn_squad(num of squads,squad size)
	}
	
	
	// spawn boss if is defined by string table
	if ( wave_has_boss( current_wave ) )
		thread maps\_so_war_ai::spawn_boss();
	
	// ============= Spawn Special AIs ==============	
	
	level.special_ai 	= [];
	special_ai_types	= get_special_ai( current_wave );
	
	if ( isdefined( special_ai_types ) )
	{
		foreach( special_type in special_ai_types )
		{
			// ============= Spawn Dogs ==============	
			if ( issubstr( special_type, "dog" ) )
			{
				thread spawn_dogs( special_type, get_dog_quantity( current_wave ) );
				continue;
			}
			
			special_ai_num = get_special_ai_type_quantity( current_wave, special_type );
			
			if ( isdefined( special_ai_num ) && special_ai_num > 0 )
			{
				special_ai_spawned	= maps\_so_war_ai::spawn_special_ai( special_type, special_ai_num );
			}
		}
	}
	// reenforce squad(s) of size of the first squad spawned
	if ( squad_array[ 0 ] > 0 )
		thread maps\_so_war_ai::reenforcement_squad_spawn( level.so.CONST_WAVE_REENFORCEMENT_SQUAD, squad_array[ 0 ] );

	minPopulationAndTime = get_min_pop_time( current_wave );
	if ( isDefined(minPopulationAndTime) )
	{
		war_population_maintain_minimum_enemy_for_a_time( minPopulationAndTime[0],minPopulationAndTime[1]);
	}

	// ============= Logic for AI aggression ==============
	
	// wait till a few AIs left, we then have the remaining aggress
	total_enemies = get_total_enemies();
	while ( total_enemies > level.so.CONST_WAVE_AI_LEFT_TILL_AGGRO )
	{
		// Delay, but early out if an enemy died
		level waittill_any_timeout( 1.0, "axis_died" );
		total_enemies = get_total_enemies();
	}
	
	flag_set( "aggressive_mode" );
	maps\_squad_enemies::squad_disband( 0, ::aggressive_squad_leader );
	// aggressing remaining Squad AIs
	level.squad_leader_behavior_func = maps\_so_war_AI::aggressive_ai; // for new leaders to carry
	
	// aggressing remaining Special AIs
	level.special_ai_behavior_func = maps\_so_war_AI::aggressive_ai; // for new special ais to carry
	if ( isdefined( level.special_ai ) && level.special_ai.size > 0 )
		foreach ( guy in level.special_ai )
			guy thread maps\_so_war_AI::aggressive_ai(); // for existing special AIs
	
	// wait till certain number of AIs left, we can start the next wave or boss battle
	total_enemies = get_total_enemies();
	
	while ( total_enemies > maps\_so_war_ai::get_min_ai_threshold(level.current_wave)	 )
	{
		// Delay, but early out if an enemy died
		level waittill_any_timeout( 1.0, "axis_died" );
		total_enemies = get_total_enemies();
	}
	
	// reset aggressing behavior for next wave/spawn
	level.squad_leader_behavior_func 	= maps\_so_war_AI::default_ai;
	level.special_ai_behavior_func 		= maps\_so_war_AI::default_ai;
	
	// ============= Wave Completion ==============
	
	// if boss spawned and not defeated, wait
	if ( wave_has_boss( current_wave ) )
	{
		flag_wait( "bosses_spawned" );
		
		while ( isdefined( level.bosses ) && level.bosses.size )
			wait 0.1;
	}
	
	flag_clear( "aggressive_mode" );
	
	if ( flag( "boss_music" ) )
	{
		//music_stop( 6 );
		flag_clear( "boss_music" );
		//thread music_combat( get_squad_type( current_wave ) );
	}
	
	level.waves_completed++;
	wait( 0.1 ); // wait a couple frames to let anything that was waiting on wave end do its thing
	
	level notify( "wave_ended", current_wave );
}

war_wave_catch_player_ready( all_ready_msg, time )
{
	self endon( "death" );
	level endon( "special_op_terminated" );
	level endon( all_ready_msg );
	
	// Everyone passes this ypos as the xoffset... sad
	x_offset = maps\_so_war_hud::so_hud_xpos() + 600;
	
	// Add press button to ready up prompt
	self.elem_ready_up = maps\_so_war_hud::so_create_hud_item( 2, x_offset, &"SO_WAR_READY_UP", self, true );
	self.elem_ready_up maps\_so_war_hud::elem_ready_up_setup();
	
	// Adjust time display of ready up hud elem
	self thread war_wave_catch_player_ready_update( "war_player_ready", all_ready_msg, self.elem_ready_up, time );
	
	// Remove ready up hud elem once all players are ready
	self thread war_wave_catch_player_ready_clean( all_ready_msg );
	
	self thread NotifyOnPlayerCommand( "war_player_ready", "+gostand" );
	self waittill( "war_player_ready" );

	// Increment players ready count
	if ( !isdefined( level.war_players_ready ) )
		level.war_players_ready = 1;
	else
		level.war_players_ready++;
	
	// Remove press button to ready up prompt
	self.elem_ready_up maps\_so_war_hud::so_remove_hud_item( true );
	
	// Check to see if all players are ready
	if ( level.war_players_ready == level.players.size )
	{
		level notify( all_ready_msg );
	}
	else
	{
		/*
		// add prompt of waiting on other player
		otherplayer = get_other_player( self );
		if ( isdefined( otherplayer ) && isdefined( otherplayer.elem_ready_up ) )
			otherplayer.elem_ready_up.label = &"SO_WAR_PARTNER_READY";
		
		self.elem_ready_up = maps\_specialops::so_create_hud_item( -2, x_offset, &"SO_WAR_READY_UP_WAIT", self, true );
		self.elem_ready_up elem_ready_up_setup();
		*/
	}
}

// temp implementation, need to port IW code eventually
NotifyOnPlayerCommand( notifyString, command )
{
	self endon("death");
	self notify("NotifyOnPlayerCommand");
	self endon("NotifyOnPlayerCommand");
	
	while(1)
	{
		switch( command )
		{
			case "+gostand":
				if( self jumpbuttonpressed() )
				{
					self notify( notifyString );
					return;
				}
				break;

			case "+actionslot 3":
				if( self ButtonPressed("DPAD_LEFT") )
				{
					self notify( notifyString );
					return;
				}
				break;
		}

		wait(0.05);
	}
}

war_wave_catch_player_ready_update( player_endon, level_endon, hud_elem, time )
{
	level endon( level_endon );
	self endon( player_endon );
	
	time = int( time );
	
	while( isdefined( hud_elem ) && time > 0 )
	{
		hud_elem SetValue( time );
		wait 1.0;
		
		time--;
	}
}

war_wave_catch_player_ready_clean( msg )
{
	level waittill( msg );
	
	level.war_players_ready = undefined;
	
	if ( isdefined( self.elem_ready_up ) )
	{
		self.elem_ready_up maps\_so_war_hud::so_remove_hud_item( true );
	}
}

war_wave_pickup_downed_players()
{
	foreach( player in level.players )
	{
		if ( is_player_down( player ) )
			player.laststand_getup_fast = true;
	}
}

// spawn a wave with a specific number of squads
spawn_squad( spawn_squad_num, squad_size )
{
	level endon( "special_op_terminated" );

	spawn_squad_num = int( spawn_squad_num ); //insurance
	while( spawn_squad_num )
	{
		squad = maps\_squad_enemies::spawn_far_squad( level.wave_spawn_locs, get_class( "leader" ), get_class( "follower" ), squad_size - 1 );
		
		//squad = maps\_so_war_ai::spawn_enemy_squad_by_chopper( squad_size );

		if (isDefined(squad) )
		{
			foreach( guy in squad )
			{
				guy	setthreatbiasgroup( "axis" );
				guy thread maps\_so_war_ai::setup_AI_weapon();
				guy thread maps\_so_war_ai::ai_awareness();
			}
			spawn_squad_num--;
		}
		else
		{
			wait 1;
		}
	}
	return level.leaders.size;
}

// returns AI type appropriate for current difficulty, class is either leader or follower
get_class( class )
{
	squad_type 	= maps\_so_war_ai::get_squad_type( level.current_wave );
	classname 	= maps\_so_war_ai::get_ai_classname( squad_type );
	
	if ( isdefined( class ) )
	{
		// this is if "leader" / "follower" uses different AI Types
		// right now we dont need this
	}
	
	return classname;
}


// ==========================================================================
// BOSS LOGIC
// ==========================================================================

wave_has_boss( wave_num )
{
	// does current wave have boss?
	AI_bosses 		= maps\_so_war_ai::get_bosses_ai( wave_num );
	nonAI_bosses 	= maps\_so_war_ai::get_bosses_nonai( wave_num );
	
	if ( isdefined( AI_bosses ) || isdefined( nonAI_bosses ) )
		return true;
	
	return false;
}


// ==========================================================================
// PLAYER CAMPING LOGIC
// ==========================================================================
camping_think()
{
	self endon( "death" );

	if ( !isdefined( self.camper_detection ) )
		self.camper_detection = false;
	
	// keep track of all camped locations
	self.camping_locs = [];
	self.camping_time	= 0;
	
	// enemy response to player camping
	self thread camp_response();
	
	old_origin 	= self.origin;
	camp_points = 0;
	kills 		= 0;
	
	while ( 1 )
	{
		self.camping 		= 0;
		self.camping_loc 	= self.origin;
		camp_points			= 0;
		old_origin 			= self.origin;
		
		// counting seconds toward camping status
		while ( camp_points <= 20 )
		{
			if ( distance( old_origin, self.origin ) < 220 )
				camp_points++;
			else
				camp_points-=2;
			
			// having low health is excused
			if ( self.health < 40 )
				camp_points--;
			
			// kills will make player 
			//if ( self.stats[ "kills" ] - kills > 0 )
			//	camp_points += ( self.stats[ "kills" ] - kills );
			
			if ( camp_points <= 0 || ( self ent_flag_exist( "laststand_downed" ) && self ent_flag( "laststand_downed" ) )
				)
			{
				camp_points = 0;
				old_origin = self.origin;
			}
			//kills = self.stats[ "kills" ];
			wait 1;
		}
	
		self.camping 		= 1;
		self.camping_loc 	= self.origin;
		
		// keep track of all camped locations
		self.camping_locs[ self.camping_locs.size ] = self.camping_loc;
	
		self notify( "camping" );

		// wait till out of camping area
		while ( distance( old_origin, self.origin ) < 260 )
		{
			self.camping_time++;
			wait 1;
		}
		
		self notify( "stopped camping" );
	}
}

// enemy response to player camping
camp_response()
{
	self endon( "death" );
	
	level.camp_response_interval = level.so.CONST_CAMP_RESPONSE_INTERVAL;
	
	while ( 1 )
	{
		wait 0.05;
		
		// wait till camping
		if ( !isdefined( self.camping ) 	|| 
			 !isdefined( self.camping_loc ) || 
			 !isdefined( self.camping_time ) 
		)
			continue;
		
		// awww man you are in trouble now boy
		if ( self.camping )
		{
			//iprintln( "R::grenade" );
			self thread level_AI_respond( self.camping_loc, self.camping_time );
			self thread level_AI_boss_respond( self.camping_loc, self.camping_time );
			wait level.camp_response_interval;
		}
	}
}

level_AI_respond( last_camp_loc, camp_time )
{
	all_ai = getaiarray( "axis" );
	foreach ( ai in all_ai )
		ai thread throw_grenade_at_player( self );
}

// if bosses exist in level, respond
level_AI_boss_respond( last_camp_loc, camp_time )
{
	if ( isdefined( level.bosses ) && level.bosses.size )
	{
		// just one respond for now
		responder = level.bosses[ randomint( level.bosses.size ) ];
	}	
}

wrap_array_index( index, array_size )
{
	// too low
	while( index < 0 )
	{
		index = index + array_size;
	}

	// too high
	while( index >= array_size )
	{
		index = index - array_size;
	}

	return index;
}



// ==========================================================================
// MUSIC
// ==========================================================================

intro_music( type )
{
	level endon( "special_op_terminated" );
	
	//music_alias = "so_war_easy_music";
	music_alias = "so_war_regular_music";
	
	wait 1.5;
	
	//MusicPlayWrapper( music_alias );
	
	wait 5;
	
	//music_stop( 20 );
}

music_combat( type )
{
}

music_boss( type )
{
}

// ==========================================================================
// ==========================================================================
// HUD LOGIC
// ==========================================================================
// ==========================================================================

hud_init()
{
	level endon( "special_op_terminated" );
}

war_hud()
{
	thread hud_init();

	foreach ( player in GetPlayers() )
	{
		player thread armor_HUD();
		//player thread laststand_HUD();
		//player thread ally_drop_HUD();
	}
}

// ==========================================================================
// ARMOR UI

armor_HUD()
{
	self endon( "death" );
	
	self.armor_x = 65;
	self.armor_y = 186; //182;
	self.armor_shield_size = 28; //22;

	// shield
	self.shield_elem 		= self special_item_hudelem( self.armor_x, self.armor_y );
	self.shield_elem 		setShader( "perk_backing_blueshield", self.armor_shield_size, self.armor_shield_size );
	self.shield_elem.alpha 	= 0.85;
	
	// shield fade
	self.shield_elem_fade	= self special_item_hudelem( self.armor_x, self.armor_y );
	self.shield_elem_fade.alpha = 0;
		
	waittillframeend;
	while ( 1 )
	{
		if ( isdefined( self.armor ) && isdefined( self.armor[ "points" ] ) && self.armor[ "points" ] )
		{
			// armor is green until under 100
			weaked_armor = 100;

			green 	= float_capped( self.armor["points"] / (weaked_armor/2), 0, 1 );
			red		= 1 - float_capped( ( self.armor[ "points" ] - weaked_armor/2 ) / (weaked_armor/2), 0, 1 );

			self.shield_elem.alpha 	= 0.85;
			self.shield_elem.color 	= ( 1, float_capped( green, 0, 0.95 ), float_capped( green, 0, 0.7 ) );
			
			self thread armor_jitter();
		}
		else
		{
			self.shield_elem.alpha = 0;
			self thread destroy_armor_icon();
			return;
		}
		
		self waittill_any( "damage", "health_update" );
	}
}

armor_jitter()
{
	self endon( "death" );
	
	if (!isdefined(self.jitter_shield) )
	{
		self.jitter_shield = 1;
	}
	else
	{
		self.jitter_shield++;
	}
	self.shield_elem_fade.alpha = 0.85;
	samples = 20;
	for( i=0; i<=samples; i++ )
	{
		// jittering
		jitter_amount = randomint( int( max( 1, 5 - i/(samples/5) ) ) ) - int( 2 - i/(samples/2) );
		self.shield_elem.x = self.armor_x + jitter_amount;
		self.shield_elem.y = self.armor_y + jitter_amount;
		
		// this is the fading enlarging shield
		enlarge_amount = int( i*(40/samples) );
		self.shield_elem_fade setShader( "perk_backing_blueshield", self.armor_shield_size + enlarge_amount, self.armor_shield_size + enlarge_amount );
		self.shield_elem_fade.alpha = max( ( samples*0.85 - i )/samples, 0 );
		
		wait 0.05;
	}
	
	self.shield_elem_fade.alpha = 0;
	self.shield_elem.x = self.armor_x;
	self.shield_elem.y = self.armor_y;
	self.jitter_shield--;
}

destroy_armor_icon()
{
	if( IsDefined(self.jitter_shield) )
	{
		while(self.jitter_shield > 0 )
		{
			wait 0.5;
		}
	}
	
	if ( IsDefined(self.shield_elem) )
	{
		self.shield_elem maps\_hud_util::destroyElem();
		self.shield_elem = undefined;
	}
	if ( IsDefined(self.shield_elem_fade) )
	{
		self.shield_elem_fade maps\_hud_util::destroyElem();
		self.shield_elem_fade = undefined;
	}
}

laststand_HUD()
{
	self endon( "death" );
	
	self.laststand_HUD_lives 				= spawnstruct();
	self.laststand_HUD_lives.pos_x			= -44;
	self.laststand_HUD_lives.pos_y			= 196;
	self.laststand_HUD_lives.icon_size		= 28;			// Width & height

	// Laststand Icon
	self.laststand_HUD_lives.icon 		= self special_item_hudelem( self.laststand_HUD_lives.pos_x, self.laststand_HUD_lives.pos_y );
	self.laststand_HUD_lives.icon 		setShader( "perk_second_chance", self.laststand_HUD_lives.icon_size, self.laststand_HUD_lives.icon_size );
	self.laststand_HUD_lives.icon.color	= ( 1, 1, 1 ); //( 1, 0.9, 0.65 );
	
	while ( 1 )
	{		
		if ( self maps\_laststand::get_lives_remaining() > 0 )
			self.laststand_HUD_lives.icon.alpha	= 0.45;
		else
			self.laststand_HUD_lives.icon.alpha	= 0.0;		

		self waittill( "laststand_lives_updated" );
	}
}

ally_drop_HUD()
{
	self endon( "death" );

	self.ally_drop_HUD 				= spawnstruct();
	self.ally_drop_HUD.pos_x		= 44;
	self.ally_drop_HUD.pos_y		= 196;
	self.ally_drop_HUD.icon_size	= 28;			// Width & height

	// Laststand Icon
	self.ally_drop_HUD.icon 		= self special_item_hudelem( self.ally_drop_HUD.pos_x, self.ally_drop_HUD.pos_y );
	self.ally_drop_HUD.icon 		setShader( "flag_usa", self.ally_drop_HUD.icon_size, self.ally_drop_HUD.icon_size );
	self.ally_drop_HUD.icon.color	= ( 1, 1, 1 );

	while ( 1 )
	{		
		if ( is_true( self.has_ally_drop ) )
			self.ally_drop_HUD.icon.alpha	= 0.45;
		else
			self.ally_drop_HUD.icon.alpha	= 0.0;		

		self waittill( "ally_drops_updated" );
	}
}
	
/#
debug_draw()
{
	level endon( "special_op_terminated" );
	
	wait_for_first_player();
	
	while(1)
	{
		level waittill("war_wave");
		
		totalAi = maps\_so_war_ai::get_ai_count( "regular", level.current_wave );
		totalDogs = maps\_so_war_ai::get_ai_count( "dogs", level.current_wave );
		totalSpecialAi = maps\_so_war_ai::get_ai_count( "special", level.current_wave ) - totalDogs;
		totalBoss = maps\_so_war_ai::get_ai_count( "boss", level.current_wave );
		
		lastWavesCompleted = level.waves_completed;
		
		while( lastWavesCompleted == level.waves_completed )
		{
			if( GetDvarInt("war_wave_debug_info") == 0 )
			{
				debug_draw_showHud( false );
				wait(0.05);
				continue;
			}
			
			debug_draw_showHud( true );
			
			numAi = 0;
			numSpecialAi = 0;
			numDogs = 0;
			numBoss = 0;
			
			enemies = GetAiArray( "axis" );
			foreach( enemy in enemies )
			{
				if( !is_true(enemy.isboss) && !enemy.isdog )
				{
					if( is_true(enemy.isspecial) )
						numSpecialAi++;
					else
						numAi++;
				}
			}
			
			if( IsDefined(level.dogs) )
				numDogs = level.dogs.size;
			
			if( IsDefined(level.bosses) )
				numBoss = level.bosses.size;
		
			level.waveNumberHud_value SetText( level.current_wave + " (" + lastWavesCompleted + ")" );
			
			level.waveNumAiHud_value SetText( numAi + " / " + totalAi );
			level.waveNumSpecialAiHud_value SetText( numSpecialAi + " / " + totalSpecialAi );
			level.waveNumDogsHud_value SetText( numDogs + " / " + totalDogs );
			level.waveNumBossesHud_value SetText( numBoss + " / " + totalBoss );
			
			if( flag("aggressive_mode") && GetDvarInt("war_wave_debug_info") > 0 )
				level.waveAggressiveHud_label.alpha = 1;
			else
				level.waveAggressiveHud_label.alpha = 0;
			
			wait(0.05);
			
			level.waveNumAiHud_value clearAllTextAfterHudElem();
		}
	}
}

debug_draw_showHud( show )
{
	if( show )
	{
		player 		= get_players()[0];
		fontScale 	= 1.5;
		leftX 		= 660;
		// create the hud
		if( !IsDefined( level.waveNumberHud_label ) )
		{
			level.waveNumberHud_label = NewClientHudElem( player );
			level.waveNumberHud_label.alignX = "right";
			level.waveNumberHud_label.x = leftX;
			level.waveNumberHud_label.y = 225;
			level.waveNumberHud_label.fontscale = fontScale;		
			level.waveNumberHud_label settext("Wave: ");
		}
		if( !IsDefined( level.waveNumberHud_value ) )
		{
			level.waveNumberHud_value = NewClientHudElem( player );
			level.waveNumberHud_value.alignX = "left";
			level.waveNumberHud_value.x = leftX + 10;
			level.waveNumberHud_value.y = 225;
			level.waveNumberHud_value.fontscale = fontScale;
		}
		if( !IsDefined( level.waveNumAiHud_label ) )
		{
			level.waveNumAiHud_label = NewClientHudElem( player );
			level.waveNumAiHud_label.alignX = "right";
			level.waveNumAiHud_label.x = leftX;
			level.waveNumAiHud_label.y = 240;
			level.waveNumAiHud_label.fontscale = fontScale;		
			level.waveNumAiHud_label settext("AI: ");
		}
		if( !IsDefined( level.waveNumAiHud_value ) )
		{
			level.waveNumAiHud_value = NewClientHudElem( player );
			level.waveNumAiHud_value.alignX = "left";
			level.waveNumAiHud_value.x = leftX + 10;
			level.waveNumAiHud_value.y = 240;
			level.waveNumAiHud_value.fontscale = fontScale;
		}
		if( !IsDefined( level.waveNumSpecialAiHud_label ) )
		{
			level.waveNumSpecialAiHud_label = NewClientHudElem( player );
			level.waveNumSpecialAiHud_label.alignX = "right";
			level.waveNumSpecialAiHud_label.x = leftX;
			level.waveNumSpecialAiHud_label.y = 255;
			level.waveNumSpecialAiHud_label.fontscale = fontScale;		
			level.waveNumSpecialAiHud_label settext("Special AI: ");
		}
		if( !IsDefined( level.waveNumSpecialAiHud_value ) )
		{
			level.waveNumSpecialAiHud_value = NewClientHudElem( player );
			level.waveNumSpecialAiHud_value.alignX = "left";
			level.waveNumSpecialAiHud_value.x = leftX + 10;
			level.waveNumSpecialAiHud_value.y = 255;
			level.waveNumSpecialAiHud_value.fontscale = fontScale;
		}
		if( !IsDefined( level.waveNumDogsHud_label ) )
		{
			level.waveNumDogsHud_label = NewClientHudElem( player );
			level.waveNumDogsHud_label.alignX = "right";
			level.waveNumDogsHud_label.x = leftX;
			level.waveNumDogsHud_label.y = 270;
			level.waveNumDogsHud_label.fontscale = fontScale;		
			level.waveNumDogsHud_label settext("Dogs: ");
		}
		if( !IsDefined( level.waveNumDogsHud_value ) )
		{
			level.waveNumDogsHud_value = NewClientHudElem( player );
			level.waveNumDogsHud_value.alignX = "left";
			level.waveNumDogsHud_value.x = leftX + 10;
			level.waveNumDogsHud_value.y = 270;
			level.waveNumDogsHud_value.fontscale = fontScale;
		}
		if( !IsDefined( level.waveNumBossesHud_label ) )
		{
			level.waveNumBossesHud_label = NewClientHudElem( player );
			level.waveNumBossesHud_label.alignX = "right";
			level.waveNumBossesHud_label.x = leftX;
			level.waveNumBossesHud_label.y = 285;
			level.waveNumBossesHud_label.fontscale = fontScale;		
			level.waveNumBossesHud_label settext("Boss: ");
		}
		if( !IsDefined( level.waveNumBossesHud_value ) )
		{
			level.waveNumBossesHud_value = NewClientHudElem( player );
			level.waveNumBossesHud_value.alignX = "left";
			level.waveNumBossesHud_value.x = leftX + 10;
			level.waveNumBossesHud_value.y = 285;
			level.waveNumBossesHud_value.fontscale = fontScale;
		}
		if( !IsDefined( level.waveAggressiveHud_label ) )
		{
			level.waveAggressiveHud_label = NewClientHudElem( player );
			level.waveAggressiveHud_label.alignX = "right";
			level.waveAggressiveHud_label.x = leftX;
			level.waveAggressiveHud_label.y = 300;
			level.waveAggressiveHud_label.fontscale = fontScale;		
			level.waveAggressiveHud_label.alpha = 0;
			level.waveAggressiveHud_label settext("Aggressive Mode");
		}
	}
	else
	{
		if( IsDefined( level.waveNumberHud_label ) )
		{
			level.waveNumberHud_label maps\_hud_util::destroyElem();
			level.waveNumberHud_label = undefined;
		}
		if (isDefined(level.waveNumberHud_value) )
		{
			level.waveNumberHud_value maps\_hud_util::destroyElem();
			level.waveNumberHud_value = undefined;
		}
		if (isDefined(level.waveNumAiHud_label) )
		{
			level.waveNumAiHud_label maps\_hud_util::destroyElem();
			level.waveNumAiHud_label = undefined;
		}
		if (isDefined(level.waveNumAiHud_value) )
		{
			level.waveNumAiHud_value maps\_hud_util::destroyElem();
			level.waveNumAiHud_value = undefined;
		}
		if (isDefined(level.waveNumSpecialAiHud_label) )
		{
			level.waveNumSpecialAiHud_label maps\_hud_util::destroyElem();
			level.waveNumSpecialAiHud_label = undefined;
		}
		if (isDefined(level.waveNumSpecialAiHud_value) )
		{
			level.waveNumSpecialAiHud_value maps\_hud_util::destroyElem();
			level.waveNumSpecialAiHud_value = undefined;
		}
		if (isDefined(level.waveNumDogsHud_label) )
		{
			level.waveNumDogsHud_label maps\_hud_util::destroyElem();
			level.waveNumDogsHud_label = undefined;
		}
		if (isDefined(level.waveNumDogsHud_value) )
		{
			level.waveNumDogsHud_value maps\_hud_util::destroyElem();
			level.waveNumDogsHud_value = undefined;
		}
		if (isDefined(level.waveNumBossesHud_label) )
		{
			level.waveNumBossesHud_label maps\_hud_util::destroyElem();
			level.waveNumBossesHud_label = undefined;
		}
		if (isDefined(level.waveNumBossesHud_value) )
		{
			level.waveNumBossesHud_value maps\_hud_util::destroyElem();
			level.waveNumBossesHud_value = undefined;
		}
		if (isDefined(level.waveAggressiveHud_label) )
		{
			level.waveAggressiveHud_label maps\_hud_util::destroyElem();
			level.waveAggressiveHud_label = undefined;
		}
	}
}
#/

war_init_names()
{
	level.war_names = [];
	level.war_names[level.war_names.size] = "King";
	level.war_names[level.war_names.size] = "Perelman";
	level.war_names[level.war_names.size] = "Jakatdar";
	level.war_names[level.war_names.size] = "Seibert";
	level.war_names[level.war_names.size] = "Aziz";
	level.war_names[level.war_names.size] = "Velev";
	level.war_names[level.war_names.size] = "Snider";
	level.war_names[level.war_names.size] = "Goodey";
	level.war_names[level.war_names.size] = "Doran";
	level.war_names[level.war_names.size] = "Olson";
	level.war_names[level.war_names.size] = "Chock";
	level.war_names[level.war_names.size] = "Walker";

	level.war_names = array_randomize(level.war_names);
	level.next_war_name = 0;
}
war_get_names()
{
	lastname = level.war_names[level.next_war_name];

	level.next_war_name++;
	if (level.next_war_name >= level.war_names.size)
		level.next_war_name = 0;
	
	rank = RandomInt( 100 ); 
	if( rank > 20 )
	{
		fullname = "Sgt. " + lastname; 
	}
	else if( rank > 10 )
	{
		fullname = "Lt. " + lastname; 
	}
	else
	{
		fullname = "Cpt. " + lastname; 
	}
	
	return fullname;
}