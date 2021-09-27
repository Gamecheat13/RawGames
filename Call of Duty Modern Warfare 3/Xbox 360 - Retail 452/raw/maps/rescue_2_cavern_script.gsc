#include maps\_utility;
#include common_scripts\utility;
#include maps\_anim;
#include maps\_vehicle;
#include maps\_util_carlos;
#include maps\rescue_2_code;
#include maps\rescue_2_cavern_code;

#using_animtree( "generic_human" );
main()
{	
	// start_minimap_corner (1024)
	PrecacheShader( "compass_map_rescue_start" );
	// outside_minimap_corner (1024)
	PrecacheShader( "compass_map_rescue_outside" );
	// entrance_minimap_corner (512)
	PrecacheShader( "compass_map_rescue_entrance" );
	// descent_minimap_corner (512)
//	PrecacheShader( "compass_map_rescue_descent" );
	// ending_minimap_corner (512)
	PrecacheShader( "compass_map_rescue_ending" );

	PrecacheShellshock( "default" );
	PrecacheShellshock( "rescue_chopper_drag" );
	PrecacheShellshock( "rescue_chopper_drag_2" );
	
	PrecacheModel( "prop_flex_cuff" );
	PrecacheModel( "weapon_desert_eagle_iw5" );
	PrecacheModel( "viewhands_player_yuri_europe" );
	PrecacheModel( "viewlegs_generic" );
	PrecacheModel( "vehicle_blackhawk_hero_sas_night" );
	PrecacheModel( "weapon_m16_clip_iw5" );
	PrecacheModel( "weapon_parabolic_knife" );
	PrecacheModel( "mil_semtex_belt" );
	PrecacheModel( "mil_semtex_belt_obj" );
	PrecacheModel( "mil_semtex_belt_des_sequence_02" );
	PrecacheModel( "mil_semtex_belt_des_sequence_03" );
	PrecacheModel( "mil_semtex_belt_des_sequence_04" );
	
	PrecacheModel( "weapon_m84_flashbang_grenade" );
	PrecacheModel( "weapon_m84_flashbang_grenade_obj" );
	PrecacheModel( "weapon_rappel_rope_long" );
	PrecacheModel( "weapon_rappel_rope_long_obj" );
	PrecacheModel( "weapon_carabiner_thin_rope" );
	PrecacheModel( "vehicle_little_bird_minigun_right" );
	PrecacheModel( "weapon_minigun" );
	
	PrecacheItem( "deserteagle" );
	PrecacheItem( "smoke_grenade_american" );
	PrecacheItem( "heli_minigun_noai" );
	
	PreCacheShader( "hint_mantle" );
	
	maps\rescue_2_anim_props::main();
	
	array_spawn_function_targetname( "dead_daughter", ::dead_daughter );
	/*array_spawn_function_targetname( "cavern_defend_1", ::bumrush_player );
	array_spawn_function_targetname( "cavern_defend_l", ::bumrush_player );
	array_spawn_function_targetname( "cavern_defend_r", ::bumrush_player ); */
	array_spawn_function_targetname( "rescue_heli", ::rescue_heli_think );
	array_spawn_function_targetname( "rescue_heli_backup", ::rescue_heli_think );
	
	array_spawn_function_noteworthy( "animate", ::guy_anim_think );
	array_spawn_function_noteworthy( "animate_then_idle", ::guy_anim_then_idle_think );
	array_spawn_function_noteworthy( "animate_then_die", ::guy_anim_then_die_think );
	array_spawn_function_noteworthy( "cavern_end_drone", ::cavern_end_drone_think );
	array_spawn_function_noteworthy( "disable_autoaim", ::disable_autoaim_think );
	array_spawn_function_noteworthy( "gimme_deaths", ::gimme_deaths_think );
//	array_spawn_function_noteworthy( "run_to_position", ::run_to_position_think );
	
	array_thread( getentarray( "moveup_when_clear", "targetname" ), ::move_up_when_clear );
	array_thread( getentarray( "cleanup_ai_in_volume", "targetname" ), ::cleanup_ai_in_volume );
	array_thread( getentarray( "explosion_trigger", "targetname" ), ::explosion_trigger );
	array_thread( getentarray( "cavern_shake_trigger", "targetname" ), ::cavern_shake_trigger );
	array_thread( getentarray( "swinging_light", "targetname" ), ::swinging_light );
	array_thread( getentarray( "primary_fire", "script_noteworthy" ), ::fire_light, "hard_targets_dead" );
	
	init_level_flags();
	
	level.player_rope_trigger = get_target_ent( "player_rappel_trigger" );
	level.player_rope_trigger trigger_off();
	
	thread setup_elevator();
	
	maps\_readystand_anims::initReadyStand();
	
	level.slomobreachduration = 8.5;
	level.slowmo_viewhands = "viewhands_player_yuri_europe";
	maps\_slowmo_breach::slowmo_breach_init();
	maps\_slowmo_breach::add_breach_func( ::breach_explosion_notify );
	level._effect[ "breach_door" ]					 = LoadFX( "explosions/breach_door_metal" );
	
	disable_trigger_with_noteworthy( "cavern_breach_exit" );
	disable_defend_triggers();
	
	chopper = get_target_ent( "heli_crash_heli" );
	chopper Hide();
	
	level.slabs = [];
	
	slab = get_Target_Ent( "breach_slab_fall" );
	slab Hide();
	level.slabs[ level.slabs.size ] = slab;
	
	slab = get_Target_Ent( "breach_slab_fall2" );
	slab Hide();
	level.slabs[ level.slabs.size ] = slab;
	
	slab = get_Target_Ent( "breach_slab_fall3" );
	slab Hide();
	level.slabs[ level.slabs.size ] = slab;
	
	level.front_slabs = [];

	slab = get_Target_Ent( "breach_slab_front" );
	slab Hide();
	level.front_slabs[ level.front_slabs.size ] = slab;
	
	slab = get_Target_Ent( "breach_slab_front2" );
	slab Hide();
	level.front_slabs[ level.front_slabs.size ] = slab;
	
	slab = get_Target_Ent( "breach_slab_front3" );
	slab Hide();
	level.front_slabs[ level.front_slabs.size ] = slab;
	
	level.packs = [];
	pack = get_target_Ent( "belt_des" );
	pack hide();
	level.packs[ level.packs.size ] = pack;
	newpack = pack spawn_tag_origin();
	newpack setModel( "mil_semtex_belt_des_sequence_03" );
	newpack Hide();
	level.packs[ level.packs.size ] = newpack;
	newpack = pack spawn_tag_origin();
	newpack setModel( "mil_semtex_belt_des_sequence_04" );
	newpack Hide();
	level.packs[ level.packs.size ] = newpack;
	
	bar = get_Target_ent( "player_rappel_bar" );
	bar Hide();
	
	level.floor_breach_charge = get_target_ent( "floor_breach_charge" );
	level.floor_breach_charge Hide();
	level.floor_breach_charge.animname = "semtexbelt";
	level.floor_breach_charge Assign_AnimTree( "semtexbelt" );
	level.floor_breach_charge.o_model = spawn_anim_model( "semtexbeltnofx", level.floor_breach_charge.origin );
	level.floor_breach_charge.o_model.angles = level.floor_breach_charge.angles;
	level.floor_breach_charge thread anim_single_solo( level.floor_breach_charge.o_model, "floor_breach" );
	level.floor_breach_charge.o_model Hide();
	
	thread level_cleanup();
	fan = getent( "cavern_bottom_fan", "targetname" );
	fan thread fan_spin();
	
	fire = get_target_ent( "cave_entrance_fire" );
	fire.old = fire getLightIntensity();
	fire setLightIntensity( 0 );
	
	level.shake_fx_num = 9;
	
	// grabbed from civilian_init... need to initialize here so I can override some anims
	if ( !isdefined( level.initialized_civilian_animations ) )
	{
		level.initialized_civilian_animations = true;

		level.scr_anim[ "default_civilian" ][ "run_combat" ][ 0 ] 		= %civilian_run_upright;
		
		
		level.scr_anim[ "default_civilian" ][ "run_hunched_combat" ][ 0 ] 		= %civilian_run_hunched_A;
		level.scr_anim[ "default_civilian" ][ "run_hunched_combat" ][ 1 ]		= %civilian_run_hunched_C;
		level.scr_anim[ "default_civilian" ][ "run_hunched_combat" ][ 2 ]		= %civilian_run_hunched_flinch;
		//%civilian_run_hunched_B;
		//%civilian_run_hunched_dodge;
		
		level.scr_anim[ "default_civilian" ][ "run_noncombat" ][ 0 ] 	= %civilian_walk_cool;
		
		weights = [];
		weights[ 0 ] = 3;
		weights[ 1 ] = 3;
		weights[ 2 ] = 1;
		//weights[ 3 ] = 1;
		//weights[ 4 ] = 1;
			
		level.scr_anim[ "default_civilian" ][ "run_hunched_weights" ] = get_cumulative_weights( weights ); 
		
		weights = [];
		weights[ 0 ] = 1;
		
		level.scr_anim[ "default_civilian" ][ "run_weights" ] = get_cumulative_weights( weights ); 
		
		level.scr_anim[ "default_civilian" ][ "idle_noncombat" ][ 0 ] 	= %unarmed_cowerstand_idle;
		//level.scr_anim[ "default_civilian" ][ "idle_noncombat" ][ 1 ] 	= %unarmed_cowerstand_pointidle;

		level.scr_anim[ "default_civilian" ][ "idle_combat" ][ 0 ] 	= %unarmed_cowercrouch_idle;
		level.scr_anim[ "default_civilian" ][ "idle_combat" ][ 1 ] 	= %unarmed_cowercrouch_idle_duck;

		// this animations look bad
		//level.scr_anim[ "default_civilian" ][ "idle_combat" ][ 0 ] 	= %unarmed_crouch_idle1;
		//level.scr_anim[ "default_civilian" ][ "idle_combat" ][ 1 ] 	= %unarmed_crouch_twitch1;
		
		anim.civilianFlashedArray[ 0 ] = %unarmed_cowerstand_react;
		anim.civilianFlashedArray[ 1 ] = %unarmed_cowercrouch_react_A;
		anim.civilianFlashedArray[ 2 ] = %unarmed_cowercrouch_react_B;
	}
	
	level.dshk_viewmodel = "viewhands_player_yuri_europe";
	maps\_dshk_player_rescue::init_dshk_player();
	turret = getent( "cavern_turret", "script_noteworthy" );
	turret thread maps\_dshk_player_rescue::dshk_turret_init();
	
	level.obj_array = [];
}

//start_end_courtyard_one

start_cavern()
{
	spawn_sandman();
	spawn_price();
	spawn_truck();
	spawn_grinch();
	set_start_positions_two( "start_cavern" );
	
	exploder( "cave_door" );	

	if ( !isdefined( level.new_cave_door_collision ) )
	{
		level.new_cave_door_collision = get_target_ent( "new_cave_door_collision" );
		level.new_cave_door_collision connectpaths();
		waitframe();
		level.new_cave_door_collision delete();
	}

	flag_set( "cavern_door_open" );
	flag_set( "start_yard_one" );
	flag_set( "hard_targets_dead" );
}

cavern_breach()
{
	spawn_sandman();
	spawn_price();
	spawn_truck();
	spawn_grinch();
	set_start_positions_two( "start_cavern_breach" );
	
	Objective_Add( obj( "rescue_prez" ), "current", &"RESCUE_2_OBJ_110" );	
	
	flag_set( "cavern_door_open" );
	flag_set( "start_cavern" );
	flag_set( "start_yard_one" );
	flag_set( "hard_targets_dead" );
	flag_set( "cavern_drop_down" );
	
	heroes = get_heroes();
	array_thread( heroes, ::set_force_color, "r" );
	level.price set_force_color( "p" );
	level.sandman set_force_color( "b" );
	
	activate_trigger_with_noteworthy( "heroes_stack" );
}

cavern_top_fight()
{
	spawn_sandman();
	spawn_price();
	spawn_truck();
	spawn_grinch();
	set_start_positions_two( "start_cavern_top_fight" );

	Objective_Add( obj( "rescue_prez" ), "current", &"RESCUE_2_OBJ_110" );
	
	flag_Set( "start_cavern" );
	flag_set( "start_yard_one" );
	flag_set( "hard_targets_dead" );
	flag_set( "cavern_drop_down" );

	
	heroes = get_heroes();
	array_thread( heroes, ::set_force_color, "r" );
	level.price set_force_color( "p" );
	level.sandman set_force_color( "b" );
	array_thread( heroes, ::disable_cqbwalk );
}

cavern_top_rappel()
{
	spawn_sandman();
	spawn_price();
	spawn_truck();
	spawn_grinch();
	set_start_positions_two( "start_cavern_rappel" );
	
	flag_set( "cavern_elevator_going_down_with_prez" );
	flag_set( "start_yard_one" );
	flag_set( "hard_targets_dead" );
	flag_set( "cavern_drop_down" );
	
	Objective_Add( obj( "rescue_prez" ), "current", &"RESCUE_2_OBJ_110" );
	
	array_thread( get_heroes(), ::disable_cqbwalk );
}

cavern_bottom_fight_one()
{
	spawn_sandman();
	spawn_price();
	spawn_truck();
	spawn_grinch();
	set_start_positions_two( "start_cavern_bottom_fight_one" );
	
	flag_set( "start_yard_one" );
	flag_set( "hard_targets_dead" );
	flag_set( "cavern_drop_down" );
	flag_set( "start_bottom_fight" );
	heroes = get_heroes();
	array_thread( heroes, ::set_force_color, "r" );
	level.price set_force_color( "p" );
	level.sandman set_force_color( "b" );
	array_thread( heroes, ::disable_cqbwalk );
	
	activate_trigger_with_noteworthy( "rappel_color_trigger" );
	
	thread kick_double_door_open( get_Target_ent( "cavern_bottom_enemy_door_l" ), get_Target_ent( "cavern_bottom_enemy_door_r" ) );
}

cavern_bottom_breach()
{
	spawn_sandman();
	spawn_price();
	spawn_truck();
	spawn_grinch();
	
	heroes = get_heroes();
	array_thread( heroes, ::set_force_color, "r" );
	level.price set_force_color( "p" );
	level.sandman set_force_color( "b" );

	set_start_positions_two( "cavern_president_breach" );
	
	waitframe();
	
	flag_set( "price_bang_on_door" );
	flag_set( "start_yard_one" );
	flag_set( "hard_targets_dead" );
	flag_set( "cavern_drop_down" );
	flag_set( "start_bottom_fight" );
	
	thread kick_double_door_open( get_Target_ent( "cavern_bottom_enemy_door_l" ), get_Target_ent( "cavern_bottom_enemy_door_r" ) );
}

cavern_bottom_pres_defend()
{
	spawn_sandman();
	spawn_price();
	spawn_truck();
	spawn_grinch();
	set_start_positions_two( "start_cavern_bottom_defend" );
	
	heroes = get_heroes();
	array_thread( heroes, ::set_force_color, "r" );
	level.price set_force_color( "p" );
	level.sandman set_force_color( "b" );
	
	waitframe();
	
	flag_set( "start_bottom_fight" );
	flag_set( "start_bottom_defend" );
	flag_set( "start_yard_one" );
	flag_set( "hard_targets_dead" );
	flag_set( "cavern_drop_down" );
	
	thread kick_double_door_open( get_Target_ent( "cavern_bottom_enemy_door_l" ), get_Target_ent( "cavern_bottom_enemy_door_r" ) );
}

cavern_bottom_pres_heli()
{
	spawn_sandman();
	spawn_price();
	spawn_truck();
	spawn_grinch();
	spawn_president();
	
	heroes = get_heroes();
	array_thread( heroes, ::set_force_color, "r" );
	level.price set_force_color( "p" );
	level.sandman set_force_color( "b" );
	
	level.rescue_heli = spawn_vehicle_from_targetname( "rescue_heli" );
	level.rescue_heli_backup = spawn_vehicle_from_targetname( "rescue_heli_backup" );
	
	helis = [ level.rescue_heli, level.rescue_heli_backup ];
	
	foreach ( h in helis )
	{
		node = h get_Target_ent();
		node = node get_last_ent_in_chain( "struct" );
		h Vehicle_Teleport( node.origin, node.angles );
	}
	
	maps\_spawner::killspawner( 550 );
	
	enable_defend_triggers();
	enable_heli_run_triggers();
	
	set_start_positions_two( "cavern_bottom_pres_heli" );
	
	waitframe();
		
	flag_set( "cavern_run_to_heli" );
	flag_set( "start_yard_one" );
	flag_set( "hard_targets_dead" );
	flag_set( "cavern_drop_down" );
	flag_set( "start_bottom_fight" );
	flag_set( "start_bottom_defend" );
		
	thread kick_double_door_open( get_Target_ent( "cavern_bottom_enemy_door_l" ), get_Target_ent( "cavern_bottom_enemy_door_r" ) );
	thread low_earthquakes();
}

cavern_heli_fly_out()
{
	spawn_sandman();
	spawn_price();
	spawn_truck();
	spawn_grinch();
	spawn_president();
	
	waitframe();
		
	flag_set( "start_yard_one" );
	flag_set( "cavern_drop_down" );
	
	exploder( "bridge_break" );

	heroes = get_heroes();
	array_thread( heroes, ::set_force_color, "r" );
	level.price set_force_color( "p" );
	level.sandman set_force_color( "b" );
	
	level.rescue_heli = spawn_vehicle_from_targetname( "rescue_heli" );
	node = get_target_ent( "cavern_heli_land" );
	node = node get_last_ent_in_chain( "struct" );
	level.rescue_heli Vehicle_Teleport( node.origin, node.angles );
	
	maps\_spawner::killspawner( 550 );

	set_start_positions_two( "start_cavern_heli_fly_out" );	

	move_player_to_heli( 0.05 );
	put_player_on_heli( level.rescue_heli );
	
	activate_trigger_with_noteworthy( "cavern_run_friendlies_chopper" );
	thread maps\_spawner::flood_spawner_scripted( getentarray( "cavern_run_chaser", "targetname" ) );
	thread maps\_spawner::flood_spawner_scripted( getentarray( "cavern_run_chaser_2", "targetname" ) );
	thread kick_double_door_open( get_Target_ent( "cavern_bottom_enemy_door_l" ), get_Target_ent( "cavern_bottom_enemy_door_r" ) );
	put_price_on_heli( level.rescue_heli );
	
	level.rescue_heli.turret notify( "stop_shooting" );
	level.rescue_heli.turret Stopfiring();
	level.rescue_heli ClearLookAtEnt();
	
	flag_set( "cavern_player_gets_on_heli" );
	flag_set( "cavern_player_in_heli" );
	flag_set( "start_delta_last_stand" );
	
	wait( 8 );
	
	ents = getentarray( "broken_bridge", "script_noteworthy" );
	array_call( ents, ::delete );

	enable_defend_triggers();
	enable_heli_run_triggers();
	thread low_earthquakes();
}

init_level_flags()
{
	flag_init( "start_base_alarm" );
	flag_init( "start_chase" );
	flag_init( "bottom_breach_started" );
	flag_init( "cavern_heli_force_land" );
	flag_init( "cavern_drop_down" );
	flag_init( "cavern_door_open" );
	flag_init( "player_mount_rappel" );
	flag_init( "player_starts_rappel" );
	flag_init( "cavern_elevator_going_down_with_prez" );
	flag_init( "price_bang_on_door" );
	flag_init( "start_bottom_defend" );
	flag_init( "cavern_defend_wave_1" );
	flag_init( "cavern_defend_wave_2" );
	flag_init( "cavern_rescue_arrives" );
	flag_init( "cavern_run_to_heli" );
	flag_init( "cavern_heli_landing" );
	flag_init( "rescue_backup_heli_dead" );
	flag_init( "begin_player_shellshock" );
	flag_init( "cavern_player_gets_on_heli" );
	flag_init( "cavern_player_in_heli" );
	flag_init( "the_end" );
	flag_init( "lots_of_time" );
	
	flag_set( "lots_of_time" );
}


breach_explosion_notify( breach_rig )
{
	level notify( "breach_explosion" );
}

spawn_president()
{
	spawner = getent( "president", "script_noteworthy" );
	level.president = spawner spawn_ai( true );
	level.president.animname = "president";
	level.president thread magic_bullet_shield();
}

level_cleanup()
{
	maps\_compass::setupMiniMap( "compass_map_rescue_start", "start_minimap_corner" );
	
	fx_volume_pause_noteworthy( "cavern_hole_fx_trigger" );
	wait( 0.1 );
	fx_volume_pause_noteworthy( "cavern_holetop_fx_trigger" );
	wait( 0.1 );
	fx_volume_pause_noteworthy( "cavern_holesnow_fx_trigger" );
	wait( 0.1 );
	fx_volume_pause_noteworthy( "cavern_holebottom_fx_trigger" );
	wait( 0.1 );
	fx_volume_pause_noteworthy( "fireroom_fx_trigger" );
	
	if ( !flag( "hard_targets_dead" ) )
	{
		array_thread( get_heroes(), ::waterfx, "start_bay_sequence", "step_run_water" ); //AI stop waterfx earlier so we do less traces
		level.player thread waterfx( "hard_targets_dead", "step_run_plr_water" );
	}
	
	flag_wait("open_bay_double_doors");
	maps\_compass::setupMiniMap( "compass_map_rescue_outside", "outside_minimap_corner" );
	
	flag_wait( "hard_targets_dead" );
	flag_set( "start_bay_sequence" ); // turn off waterfx in case of jump start
	level notify( "level_cleanup" );
	wait( 0.1 );
	
	flag_wait( "cavern_drop_down" );
	maps\_compass::setupMiniMap( "compass_map_rescue_entrance", "entrance_minimap_corner" );
	fx_volume_pause_noteworthy( "mine_fx_trigger" );
	wait( 0.1 );
	fx_volume_restart_noteworthy( "cavern_hole_fx_trigger" );
	wait( 0.1 );
	fx_volume_restart_noteworthy( "cavern_holetop_fx_trigger" );
	wait( 0.1 );
	fx_volume_restart_noteworthy( "cavern_holebottom_fx_trigger" );
	wait( 0.1 );
	fx_volume_restart_noteworthy( "cavern_holesnow_fx_trigger" );
	
	flag_wait( "start_bottom_fight" );
	maps\_compass::setupMiniMap( "compass_map_rescue_ending", "ending_minimap_corner" );
	level notify( "level_cleanup" );
	wait( 0.1 );
	
	flag_wait( "start_bottom_defend" );
	fx_volume_pause_noteworthy( "cavern_holetop_fx_trigger" );
	wait( 0.1 );
	
	flag_wait( "begin_player_shellshock" );
	fx_volume_pause_noteworthy( "cavern_hole_fx_trigger" );
	wait( 0.1 );
}