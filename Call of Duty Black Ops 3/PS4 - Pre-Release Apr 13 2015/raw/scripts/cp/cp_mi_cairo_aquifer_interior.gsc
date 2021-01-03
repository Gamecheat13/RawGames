#using scripts\cp\_load;
#using scripts\cp\_util;
#using scripts\cp\_skipto;
#using scripts\cp\_debug;
#using scripts\cp\_dialog;
#using scripts\cp\_objectives;
#using scripts\cp\_spawn_manager;

#using scripts\shared\flag_shared;
#using scripts\shared\ai_shared;
#using scripts\shared\trigger_shared;
#using scripts\shared\util_shared;
#using scripts\shared\spawner_shared;
#using scripts\shared\array_shared;
#using scripts\shared\ai\systems\ai_interface;
#using scripts\shared\scene_shared;

#using scripts\cp\cp_mi_cairo_aquifer_utility;
#using scripts\cp\cp_mi_cairo_aquifer_objectives;


function post_breach_setup()
{
	aquifer_util::toggle_interior_doors(true);
	
	guy = aquifer_obj::SpawnHendricksIfNeeded("hendricks_hangar");
//	wait 0.05;
	//TEMP
	guy util::magic_bullet_shield();
	guy.script_ignoreme = true;
	guy.baseAccuracy = 0.25;

	level.hendrix_follow_obj = "cp_level_aquifer_followme";
	thread objectives::set(level.hendrix_follow_obj,level.hendricks);
	thread objectives::set("cp_level_aquifer_follow_hendricks");
	
	level.hendricks dialog::say("hend_hyperion_s_escaping_0");

	thread hangar_combat();
	
	thread handle_round_room();
}
	
function hangar_combat()
{
	if ( !IsDefined(level.prometheus) )
	{
		level.prometheus = spawner::simple_spawn("promethius_hangar");
	}

	promethius = level.prometheus;

	promethius thread handle_prometheus_flee();
	
	// guys behind the vtol
	thread handle_hangar_extras();

	// main enemies
	spawn_manager::wait_till_complete("main_hangar_enemies");
	spawn_manager::wait_till_ai_remaining("main_hangar_enemies", 2);
	
	thread aquifer_util::safe_use_trigger("extras_exposed");
	trigger::use("hangar_enemies_exposed");
	
	spawn_manager::wait_till_cleared("main_hangar_enemies");
	level.hendricks.baseAccuracy = 10;
	
	spawn_manager::wait_till_cleared("hangar_breach_extras");
	
	trigger::use("hendricks_leave_hangar", "targetname");
	level.hendricks.baseAccuracy = 0.25;
}

function handle_prometheus_flee()
{
	util::magic_bullet_shield( self );
	ai::CreateInterfaceForEntity( self );
	self ai::set_behavior_attribute( "sprint", true );
	self ai::disable_pain();

	trigger::use("promethius_flee_hangar", "targetname");
	
	self waittill("goal");
	
	self delete();
}

function handle_hangar_extras()
{
	spawn_manager::enable("hangar_breach_extras");
	spawn_manager::wait_till_complete("hangar_breach_extras");
	spawn_manager::wait_till_ai_remaining("hangar_breach_extras", 2);
	trigger::use("extras_exposed");
}

function handle_round_room()
{
	level flag::wait_till("exit_round_room");
	guys1 = spawn_manager::get_ai("roundroom_allies");
	guys2 = spawn_manager::get_ai("roundroom_enemies");
	
	guys = ArrayCombine(guys1, guys2, true, true);
	
	array::thread_all(guys, &delete_me);
	
}

function handle_hideout()
{
	level flag::wait_till("in_hideout");
	
	
/*	
	level flag::set( "hold_for_debug_splash" );
	
	txt = [];
	txt[txt.size]="See video: Aquifer_Prometheus_Capture.mov";
	txt[txt.size]="Capture of Prometheus by NRC forces";
	thread hideout_scene();
	debug::debug_info_screen(txt);

	level flag::clear( "hold_for_debug_splash" );
*/	
	struct = GetEnt("hyperion_death_origin", "targetname");
	struct scene::play("cin_aqu_06_10_hideout_1st_hack_main", level.hendricks);
	
	thread hideout_scene();
	
	struct = GetEnt("prometheus_escape_scene", "targetname");
	struct scene::play("cin_aqu_06_20_hideout_1st_escape_main");

	thread leave_hideout_scene();
	
	struct = GetEnt("prometheus_escape_scene", "targetname");
	struct scene::play("cin_aqu_06_10_hideout_1st_hack_exit", level.hendricks);

	
	skipto::objective_completed("hideout");
}


function hideout_scene()
{
	level.hendricks dialog::say("hend_kane_we_re_uploadin_0");
	level dialog::remote( "kane_got_it_good_work_0" );
	level dialog::remote( "kane_the_nrc_have_capture_0" );
}

function leave_hideout_scene()
{
	level dialog::remote( "kane_fire_orders_have_bee_0" );
	level.hendricks dialog::say("hend_the_whole_place_is_c_0");
	level dialog::remote( "kane_hendricks_get_out_o_0" );
}

function delete_me()
{
	self delete();
}