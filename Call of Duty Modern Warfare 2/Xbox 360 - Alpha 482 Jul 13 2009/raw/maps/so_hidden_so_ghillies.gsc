#include common_scripts\utility;
#include maps\_utility;
#include maps\_anim;
#include maps\_specialops;
#include maps\so_hidden_so_ghillies_code;

// ---------------------------------------------------------------------------------
//	Init
// ---------------------------------------------------------------------------------
main()
{
	level.so_compass_zoom = "far";
	
	default_start( ::start_so_hidden );
	add_start( "so_hidden",					::start_so_hidden,					"SO Hidden" );
	add_start( "so_hidden_ghillie_crates",	::start_so_hidden_ghillie_crates,	"Ghillie - Crates" );
	add_start( "so_hidden_ghillie_valley",	::start_so_hidden_ghillie_valley,	"Ghillie - Valley" );
	add_start( "so_hidden_patrol_church",	::start_so_hidden_patrol_church,	"Patrol - Church" );
	add_start( "so_hidden_patrol_houses",	::start_so_hidden_patrol_houses,	"Patrol - Houses" );
	add_start( "so_hidden_patrol_barn",		::start_so_hidden_patrol_barn,		"Patrol - Barn" );
	add_start( "so_hidden_ghillie_houses",	::start_so_hidden_ghillie_houses,	"Ghillie - Houses" );

	setsaveddvar( "sm_sunShadowScale", "0.7" ); // optimization
	setsaveddvar( "ui_hidemap", "1" );
	
	maps\so_hidden_so_ghillies_anim::main();
	maps\so_ghillies_precache::main();
	maps\createart\so_ghillies_art::main();
	maps\so_ghillies_fx::main();

	maps\_load::main();

	thread maps\so_ghillies_amb::main();

}

// ---------------------------------------------------------------------------------
//	Challenge Initializations
// ---------------------------------------------------------------------------------
start_so_hidden()
{
	start_so_hidden_basics();

	thread enable_patrol_enemies_crates();
	thread enable_ghillie_enemies_crates();
	thread enable_ghillie_enemies_valley();
	thread enable_patrol_enemies_church();
	thread enable_patrol_enemies_houses();
	thread enable_patrol_enemies_barn();
	thread enable_ghillie_enemies_houses();
}

start_so_hidden_ghillie_crates()
{
	start_so_hidden_basics();

	thread enable_ghillie_enemies_crates();
	thread enable_ghillie_enemies_valley();
	thread enable_patrol_enemies_church();
	thread enable_patrol_enemies_houses();
	thread enable_patrol_enemies_barn();
	thread enable_ghillie_enemies_houses();
	
	start_so_hidden_gogogo( "start_ghillie_crates" );
}

start_so_hidden_ghillie_valley()
{
	start_so_hidden_basics();

	thread enable_ghillie_enemies_valley();
	thread enable_patrol_enemies_church();
	thread enable_patrol_enemies_houses();
	thread enable_patrol_enemies_barn();
	thread enable_ghillie_enemies_houses();
	
	start_so_hidden_gogogo( "start_ghillie_valley" );
}

start_so_hidden_patrol_church()
{
	start_so_hidden_basics();

	thread enable_patrol_enemies_church();
	thread enable_patrol_enemies_houses();
	thread enable_patrol_enemies_barn();
	thread enable_ghillie_enemies_houses();

	start_so_hidden_gogogo( "start_patrol_church" );
}

start_so_hidden_patrol_houses()
{
	start_so_hidden_basics();

	thread enable_patrol_enemies_houses();
	thread enable_patrol_enemies_barn();
	thread enable_ghillie_enemies_houses();

	start_so_hidden_gogogo( "start_patrol_houses" );
}

start_so_hidden_patrol_barn()
{
	start_so_hidden_basics();

	thread enable_patrol_enemies_barn();
	thread enable_ghillie_enemies_houses();
	
	start_so_hidden_gogogo( "start_patrol_barn" );
}

start_so_hidden_ghillie_houses()
{
	start_so_hidden_basics();

	thread enable_ghillie_enemies_houses();
	
	start_so_hidden_gogogo( "start_ghillie_houses" );
}

start_so_hidden_basics()
{
	so_hidden_init();

	thread enable_stealth();
	thread enable_radiation();
	
	thread fade_challenge_in();
	thread fade_challenge_out( "so_hidden_complete" );

	thread enable_challenge_timer( "so_hidden_start" , "so_hidden_complete" );
	thread enable_triggered_complete( "so_hidden_exit_trigger", "so_hidden_complete", "all" );

	// Hint to show current bonuses.
	array_thread( level.players, ::hud_bonuses_create );
}

so_hidden_init()
{
	flag_init( "so_hidden_complete" );
	flag_init( "so_hidden_exit_trigger" );
	flag_init( "force_disable_stealth" );
	
	flag_init( "church_windows_back" );
	flag_init( "church_windows_front" );
	flag_init( "school_windows" );
	flag_init( "house_windows" );
	
	switch( level.gameSkill )
	{
		case 0:	// Easy
		case 1:	so_hidden_setup_regular();	break;	// Regular
		case 2:	so_hidden_setup_hardened();	break;	// Hardened
		case 3:	so_hidden_setup_veteran();	break;	// Veteran
	}
	
	// Objective marker updates.
	thread objective_set_chopper();
	
	// Prevent prone in the shallow water.
	thread player_noprone_water();
	
	// Prevent dying from falling down the ladder.
//	thread player_protect_falling();

	// Give player a chance to not be seen through windows.	
	array_thread( getentarray( "clip_nosight", "targetname" ), ::clip_nosight_wait_for_activate );

	// Open up the church doorway.
	church_doors = getentarray( "church_door_front", "targetname" );
	foreach ( door in church_doors )
	{
		door ConnectPaths();
		door Delete();
	}

	// Exit Chopper sounds (too quiet right now)	
	exit_chopper = getent( "exit_chopper", "script_noteworthy" );
	play_loopsound_in_space( "blackhawk_idle_high", exit_chopper.origin );
	play_loopsound_in_space( "blackhawk_engine_high", exit_chopper.origin );

	// Keeps track of how many are active at a time.
	level.ghillie_count = 0;
	level.patrol_count = 0;
	
	// Only allow kill announcements every 5 seconds.	
	level.death_dialog_throttle = 5000;
	level.death_dialog_time = gettime() + level.death_dialog_throttle;
	
	level.dialog_kill_stealth = [];
	level.dialog_kill_stealth[ level.dialog_kill_stealth.size ] = "scoutsniper_mcm_goodnight";
	level.dialog_kill_stealth[ level.dialog_kill_stealth.size ] = "scoutsniper_mcm_beautiful";

	level.dialog_kill_quiet = [];
	level.dialog_kill_quiet[ level.dialog_kill_quiet.size ] = "scoutsniper_mcm_toppedhim";
	level.dialog_kill_quiet[ level.dialog_kill_quiet.size ] = "scoutsniper_mcm_gothim";
	
	level.dialog_kill_basic = [];
	level.dialog_kill_basic[ level.dialog_kill_basic.size ] = "scoutsniper_mcm_tangodown";
	level.dialog_kill_basic[ level.dialog_kill_basic.size ] = "scoutsniper_mcm_hesdown";

	// Global time bonuses
	level.bonus_stealth = 6;
	level.bonus_nofire = 3;
	level.bonus_basic = 1;
	level.bonus_time_given = 0;
	
	// Global number of kill counts
	level.deaths_stealth = 0;
	level.deaths_nofire = 0;
	level.deaths_basic = 0;

	// Individual player kill counts
	foreach ( player in level.players )
	{
		player.kills_stealth = 0;
		player.kills_nofire = 0;
		player.kills_basic = 0;
	}
}

start_so_hidden_gogogo( start_id )
{
	start_point = getstruct( start_id, "script_noteworthy" );
	maps\_specialops_code::place_player_at_start_point( level.player, start_point );
	if ( is_coop() )
		maps\_specialops_code::place_player2_near_player1();

	wait 0.05;
	flag_set( "so_hidden_start" );
}

so_hidden_setup_regular()
{
	obj = getstruct( "so_hidden_obj_church", "script_noteworthy" );
	objective_add( 1, "current", &"SO_HIDDEN_SO_GHILLIES_OBJ_REGULAR", obj.origin );
	
	level.coop_difficulty_scalar = 0.75;

	level.ghillie_move_intro_min = 2.0;
	level.ghillie_move_intro_max = 4.0;
	level.ghillie_move_time_min = 4.0;
	level.ghillie_move_time_max = 8.0;

	level.ghillie_shoot_pause_min = 2.5;
	level.ghillie_shoot_pause_max = 3.5;
	level.ghillie_shoot_quit_min = 4.0;
	level.ghillie_shoot_quit_max = 8.0;
	level.ghillie_shoot_hold_min = 2.0;
	level.ghillie_shoot_hold_max = 3.0;
	level.ghillie_crouch_chance = 0.33;
	
	level.ghillie_flub_time_min = 5000;
	level.ghillie_flub_time_max = 10000;
}

so_hidden_setup_hardened()
{
	obj = getstruct( "so_hidden_obj_church", "script_noteworthy" );
	objective_add( 1, "current", &"SO_HIDDEN_SO_GHILLIES_OBJ_HARDENED", obj.origin );

	level.coop_difficulty_scalar = 0.33;
	
	level.ghillie_move_intro_min = 2.0;
	level.ghillie_move_intro_max = 4.0;
	level.ghillie_move_time_min = 4.0;
	level.ghillie_move_time_max = 8.0;

	level.ghillie_shoot_pause_min = 1.5;
	level.ghillie_shoot_pause_max = 2.5;
	level.ghillie_shoot_quit_min = 8.0;
	level.ghillie_shoot_quit_max = 12.0;
	level.ghillie_shoot_hold_min = 0.8;
	level.ghillie_shoot_hold_max = 1.6;
	level.ghillie_crouch_chance = 0.15;

	level.ghillie_flub_time_min = 10000;
	level.ghillie_flub_time_max = 20000;
}

so_hidden_setup_veteran()
{
	obj = getstruct( "so_hidden_obj_church", "script_noteworthy" );
	objective_add( 1, "current", &"SO_HIDDEN_SO_GHILLIES_OBJ_VETERAN", obj.origin );

	level.coop_difficulty_scalar = 0.25;

	level.ghillie_move_intro_min = 1.0;
	level.ghillie_move_intro_max = 2.0;
	level.ghillie_move_time_min = 4.0;
	level.ghillie_move_time_max = 8.0;

	level.ghillie_shoot_pause_min = 1.0;
	level.ghillie_shoot_pause_max = 1.5;
	level.ghillie_shoot_quit_min = 10.0;
	level.ghillie_shoot_quit_max = 20.0;
	level.ghillie_shoot_hold_min = 0.2;
	level.ghillie_shoot_hold_max = 0.4;
	level.ghillie_crouch_chance = 0.0;
}

// ---------------------------------------------------------------------------------
//	Enable/Disable events
// ---------------------------------------------------------------------------------

// ---------------------------------------------------------------------------------

enable_patrol_enemies_crates()
{
	thread create_patrol_enemies( "patrol_enemy_crates", "patrol_enemies_spawn_crates" );
}

enable_patrol_enemies_church()
{
	flag_set( "church_windows_back" );
	thread create_patrol_enemies( "patrol_enemy_church", "patrol_enemies_spawn_church", 0.5 );
}

enable_patrol_enemies_houses()
{
	flag_set( "church_windows_front" );
	flag_set( "school_windows" );
	thread create_patrol_enemies( "patrol_enemy_houses", "patrol_enemies_spawn_houses" );
}

enable_patrol_enemies_barn()
{
	flag_set( "house_windows" );
	thread create_patrol_enemies( "patrol_enemy_barn", "patrol_enemies_spawn_barn" );
}

// ---------------------------------------------------------------------------------

enable_ghillie_enemies_crates()
{
	thread create_ghillie_enemies( "ghillie_enemy_crates", "ghillie_enemies_spawn_crates" );
}

enable_ghillie_enemies_valley()
{
	thread create_ghillie_enemies( "ghillie_enemy_valley", "ghillie_enemies_spawn_valley" );
}

enable_ghillie_enemies_houses()
{
	thread create_ghillie_enemies( "ghillie_enemy_houses", "ghillie_enemies_spawn_houses" );
}

// ---------------------------------------------------------------------------------

enable_stealth()
{
	thread turn_on_stealth();
}

enable_radiation()
{
	thread turn_on_radiation();
}

// ---------------------------------------------------------------------------------
