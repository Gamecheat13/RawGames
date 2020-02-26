#include maps\_utility;
#include maps\_vehicle;
#include maps\sniperescape_code;
#include common_scripts\utility;
#include maps\_anim;
#include maps\_stealth_logic;

main()
{
	
	precacheItem( "cobra_seeker" );
	maps\createart\sniperescape_art::main();
	maps\sniperescape_fx::main();
	maps\_mi17::main( "vehicle_mi17_woodland_fly_cheap" );
	maps\_mi28::main( "vehicle_mi-28_flying" );
	maps\_uaz::main( "vehicle_uaz_hardtop", undefined, true );

// 	maps\_cobra::main( "vehicle_cobra_helicopter_fly" );
// 	maps\_hind::main( "vehicle_mi24p_hind_woodland" );

	maps\_seaknight::main( "vehicle_ch46e" );
	maps\createfx\sniperescape_fx::main();
	maps\createfx\sniperescape_audio::main();
	
	maps\_stealth_logic::stealth_init();
	maps\_stealth_behavior::main();

	maps\_load::set_player_viewhand_model( "viewhands_player_marines" );

	animscripts\dog_init::initDogAnimations();
	setsaveddvar( "ai_eventDistFootstep", "32" );
	setsaveddvar( "ai_eventDistFootstepLite", "32" );

	precacheModel( "temp" );
	precacheModel( "weapon_c4" );
	precacheItem( "cobra_seeker" );
	precacheItem( "flash_grenade" );
	level.heli_objective = precacheshader( "objective_heli" );
	level.last_price_kill = 0;
	add_start( "rappel", ::rappel );
	add_start( "run", ::start_run );
	add_start( "apart", ::start_apartment );
	add_start( "wounding", ::start_wounding );
	add_start( "wounded", ::start_wounded );
	add_start( "burnt", ::start_burnt );
	add_start( "pool", ::start_pool );
	add_start( "fair", ::start_fair );
	add_start( "fair_battle", ::start_fair_battle );
	add_start( "seaknight", ::start_seaknight );
	default_start( ::snipe );
	createthreatbiasgroup( "price" );
	createthreatbiasgroup( "dog" );
	setignoremegroup( "price", "dog" );


	level.weaponClipModels = [];
	level.weaponClipModels[0] = "weapon_dragunov_clip";
	level.weaponClipModels[1] = "weapon_ak47_clip";
	level.weaponClipModels[2] = "weapon_m16_clip";
	level.weaponClipModels[3] = "weapon_m14_clip";
	level.weaponClipModels[4] = "weapon_g3_clip";
	level.weaponClipModels[5] = "weapon_mp5_clip";
	level.weaponClipModels[6] = "weapon_ak74u_clip";

	
	maps\_load::main();

	add_hint_string( "prone_at_fair", "Hold [ { + stance} ] to go prone", ::should_break_prone_hint );
	add_hint_string( "claymore_plant", "Press [{+actionslot 3}] to use claymores", ::should_break_claymores );
	
	thread maps\_radiation::main();
	maps\sniperescape_anim::main();
	level thread maps\sniperescape_amb::main();	
	

	curtains_left = getentarray( "curtain_left", "targetname" );
	array_thread( curtains_left, ::curtain, "curtain_left" );

	curtains_right = getentarray( "curtain_right", "targetname" );
	array_thread( curtains_right, ::curtain, "curtain_right" );
	
	level.price = getent( "price", "targetname" );
	level.price thread priceInit();
	
	battlechatter_off( "allies" );
	battlechatter_off( "axis" );

	thread do_in_order( ::flag_wait, "player_looks_through_skylight", ::exploder, 1 );
	
	level.engagement_dist_func = [];
	add_engagement_func( "actor_enemy_merc_SHTGN_winchester", ::engagement_shotgun );
	add_engagement_func( "actor_enemy_merc_AR_ak47", ::engagement_rifle );
	add_engagement_func( "actor_enemy_merc_LMG_rpd", ::engagement_gun );
	add_engagement_func( "actor_enemy_merc_SNPR_dragunov", ::engagement_sniper );
	add_engagement_func( "actor_enemy_merc_SMG_skorpion", ::engagement_smg );

	enemies = getaiarray( "axis" );
	array_thread( enemies, ::enemy_override );
	add_global_spawn_function( "axis", ::enemy_override );
	add_global_spawn_function( "axis", ::dog_check );
	add_global_spawn_function( "axis", ::price_kill_check );

	// flags
	flag_init( "player_on_barret" );
	flag_init( "launch_zak" );
	flag_init( "player_rappels" );
	flag_init( "wounding_sight_blocker_deleted" );	
	flag_init( "player_can_rappel" );
	flag_init( "apartment_explosion" );
	flag_init( "heat_area_cleared" );
	flag_init( "player_defends_heat_area" );
	flag_init( "price_is_safe_after_wounding" );
	flag_init( "price_was_hit_by_heli" );
	flag_init( "price_picked_up" );
	flag_init( "stop_adjusting_vision" );
	flag_init( "beacon_placed" );
	flag_init( "beacon_ready" );
	flag_init( "seaknight_flies_in" );
	flag_init( "enemy_choppers_incoming" );
	flag_init( "first_pickup" );
	flag_init( "seaknight_prepares_to_leave" );
	flag_init( "seaknight_leaves" );
	flag_init( "price_cuts_to_woods" );
	flag_init( "fairbattle_detected" );
	flag_init( "price_can_be_left" );
	flag_init( "fair_hold_fire" );
	flag_init( "fairbattle_high_intensity" );
	flag_init( "seaknight_lands" );
	flag_init( "faiground_battle_begins" );
	flag_init( "fairbattle_gunshot" );
	flag_init( "price_wants_apartment_cleared" );
	flag_init( "can_manage_price" );
	flag_set( "can_manage_price" );
	flag_init( "price_moves_to_position" );
	flag_init( "break_for_apartment" );
	flag_init( "player_looked_in_pool" );
	flag_init( "player_made_it_to_seaknight" );
	flag_init( "price_calls_out_kills" );
	flag_set( "price_calls_out_kills" );
	flag_init( "price_calls_out_enemy_location" );
	flag_set( "price_calls_out_enemy_location" );
	flag_init( "price_told_player_to_go_prone" );
	flag_init( "seaknight_leaves_prematurely" );
	flag_init( "exchange_uazs_arrive" );
	
	// group1 initiates group2 when group1 gets low
	group1_enemies = getentarray( "group_1", "script_noteworthy" );
	ent = spawnstruct();
	ent.count = 0;
	array_thread( group1_enemies, ::group1_enemies_think, ent );
	
	level.debounce_triggers = [];
	run_thread_on_targetname( "leave_one", ::leave_one_think );
	run_thread_on_targetname( "heli_trigger", ::heli_trigger );
	run_thread_on_targetname( "block_path", ::block_path );
	run_thread_on_targetname( "debounce_trigger", ::debounce_think );
	run_thread_on_targetname( "set_go_line", ::set_go_line );
// 	run_thread_on_targetname( "flicker_light", ::flicker_light );
	run_thread_on_targetname( "enemy_door_trigger", ::enemy_door_trigger );
	level.kill_heli_index = 0;
	level.kill_heli_progression = 0;
	level.kill_heli_progression_triggers = [];
	level.kill_heli_progression_triggers[ 0 ] = 0;
	level.kill_heli_progression_warnings = [];
	level.kill_heli_progression_warnings[ 0 ] = 0;
	level.kill_heli_triggers = [];
	run_thread_on_targetname( "heat_progression", ::heat_progression_summons_kill_heli );
	
	

	run_thread_on_noteworthy( "patrol_guy", ::add_spawn_function, ::patrol_guy );
	run_thread_on_noteworthy( "chopper_guys", ::add_spawn_function, ::chopper_guys_land );
	run_thread_on_noteworthy( "chase_chopper_guys", ::add_spawn_function, ::chase_chopper_guys_land );

	thread music();	
	
	
	// the turret dvars dont exist onthe first frame
	wait( 0.05 );
	setsaveddvar( "turretScopeZoomMin", "1" );
	
}

music()
{
// 	level endon( "price_is_safe_after_wounding" );
	for ( ;; )
	{
		musicPlay( "sniperescape_run_music" ); 
		wait( 137 );
	}
}


priceInit()
{
	spawn_failed( self );
	self.provideCoveringFire = false;
	self thread magic_bullet_shield();
	self.baseaccuracy = 1000;
	self.moveplaybackrate = 1.21;
	self.ignoresuppression = true;
	self.animname = "price";
	self.IgnoreRandomBulletDamage = true;
	
	thread gilli_leaves();
}

playerangles()
{
	for ( ;; )
	{
		println( level.player getplayerangles() );
		wait( 0.05 );
	}
}

vision_glow_change()
{
	flag_set( "stop_adjusting_vision" );
	// gotta do 2 vision sets to clear the glow
	set_vision_set( "sniperescape_glow_off", 5 );
	wait( 10 );
	set_vision_set( "sniperescape_outside", 5 );
}

snipe_vision_adjust()
{
	level endon( "stop_adjusting_vision" );

	for ( ;; )
	{
		flag_wait( "near_window" );
		glow_change = 1.25;
		vision_change = 1.25;
		set_vision_set( "sniperescape_glow_off", glow_change );
		flag_waitopen_or_timeout( "near_window", glow_change );
		set_vision_set( "sniperescape_outside", vision_change );
		flag_waitopen_or_timeout( "near_window", vision_change );

		flag_waitopen( "near_window" );
		glow_change = 0.25;
		vision_change = 1.25;
		set_vision_set( "sniperescape_glow_off", glow_change );
		flag_wait_or_timeout( "near_window", glow_change );
		set_vision_set( "sniperescape", vision_change );
		flag_wait_or_timeout( "near_window", vision_change );
	}
}

snipe()
{
	thread price_watches();
	thread price_talks();
	thread snipe_vision_adjust();
	thread exchange_flag();
	thread player_gets_on_barret();
	
	exchange_guards = getentarray( "exchange_guard", "targetname" );
	array_thread( exchange_guards, ::add_spawn_function, ::go_axis );
	array_thread( exchange_guards, ::spawn_ai );

	baddies = get_guys_with_targetname_from_spawner( "exchange_baddy" );
	guard = baddies[ 0 ];
	dealer = baddies[ 1 ];
	
	guard.animname = "guard";
	dealer.animname = "dealer";
	node = getnode( "exchange_node", "targetname" );

	node anim_teleport( baddies, "exchange" );
	array_thread( baddies, ::stay_put );

	flag_wait( "player_on_barret" );	
	thread exchange_uaz();

	flag_wait( "exchange_uazs_arrive" );
	flag_wait( "launch_zak" );
	
	zakhaev = get_guy_with_targetname_from_spawner( "exchange_zak" );
	zakhaev.animname = "zakhaev";
	briefcase = spawn_anim_model( "briefcase" );
	baddies[ baddies.size ] = zakhaev;
	baddies[ baddies.size ] = briefcase;

	node anim_single( baddies, "exchange" );
	
	level.price allowedstances( "prone", "crouch", "stand" );
	thread rappel();
}

exchange_uaz()
{
	uazs = spawn_vehicles_from_targetname_and_drive( "uaz" );
	uaz = get_ent_with_key_from_array( uazs, "zaks_ride", "script_noteworthy" );
	uaz waittill( "reached_end_node" );
	wait( 2 );
	flag_set( "exchange_uazs_arrive" );
}

price_watches()
{
	targ = getent( level.price.target, "targetname" );
	targ anim_single_solo( level.price, "spotter_wave" );
	targ thread anim_loop_solo( level.price, "spotter_idle" );
}

price_talks()
{
	//	Leftenant Price, the meeting is underway. Enemy transport sighted entering the target area.
	level.price dialogue_queue( "transport_sighted" );
	
	// Now get on the Barrett rifle and wait for my signal. Do not engage until I give the word.
	level.price dialogue_queue( "get_on_barrett" );
	flag_wait( "player_on_barret" );	
	
	
	// Remember what I've taught you. Keep in mind variable humidity and wind speed along the bullet's flight path. At this distance you’ll also have to take the Coriolis effect into account.
	level.price dialogue_queue( "remember_my_teaching" );

	/*
	// Prepare for ranging. Standby.
	level.price dialogue_queue( "prepare_for_ranging" );

	// White truck on the left, range, 1203.5 meters.
	level.price dialogue_queue( "white_truck" );

	// Range to BMP, 1207 meters.
	level.price dialogue_queue( "range_to_bmp" );

	// The table with the briefcase, range, 1206 meters.
	level.price dialogue_queue( "table_with_case" );
	*/

	flag_wait( "exchange_uazs_arrive" );

	flag_set( "launch_zak" );

	wait( 10 );
	level.helitimer = gettime();
	heli = spawn_vehicle_from_targetname_and_drive( "view_block_heli" );
	heli thread helipath( heli.target, 35, 35 );

	// Ok... I think I see him. Wait for my mark.
	level.price dialogue_queue( "i_see_him" );

	// Target...acquired. I have a positive I.D. on Imran Zakhaev.
	level.price dialogue_queue( "target_acquired" );
	
	/*
	heli_search_org1
	heli_search_org2
	view_block_heli
	block_heli_moves
	block_heli_arrives
	*/
	flag_wait( "block_heli_arrives" );
	// Ach, where did he come from? Patience laddie... Wait for a clear shot….
	level.price dialogue_queue( "where_did_he_come_from" );
	
	flag_set( "block_heli_moves" );

	// Wait - the wind's picked up. Let it die down before you take the shot. Don’t rush it.
	level.price dialogue_queue( "wind_picked_up" );
	
	

	
	// Ok take the shot.
	level.price dialogue_queue( "take_the_shot" );	
	
}

exchange_flag()
{
	flag = spawn_anim_model( "flag" );
	flag_org = getent( "flag_org", "targetname" );
	flag.origin = flag_org.origin;
	flag.angles = flag_org.angles;
	
	for ( ;; )
	{
		blend = randomfloat( 99 ) * 0.01;
		blendtime = randomfloatrange( 0.1, 1 );
		flag setanim( flag getanim( "up" ), blend, blendtime, 5 );
		flag setanim( flag getanim( "down" ), 1 - blend, blendtime, 5 );
		wait( blendtime );
	}
}

barline()
{
	for( ;; )
	{
//		Line( self gettagorigin( "tag_origin" ), level.player.origin, (1,1,0) );
		Line( self.origin, level.player.origin, (1,1,0) );
		wait( 0.05 );
	}
}

setup_rappel()
{
	// temp glowing object
	rappel_glow = getent( "rappel_glow", "targetname" );
	rappel_glow hide();
	
	rappel_trigger = getent( "rappel_trigger", "targetname" );
	rappel_trigger trigger_off();
	
	rope = spawn_anim_model( "rope" );
	level.rope = rope;
// 	level.rope hide();
	node = getnode( "price_rappel_node", "targetname" );
	node thread anim_first_frame_solo( rope, "rappel_start" );
	
	
	// It's time to move.	
	org = getent( level.price.target, "targetname" );
	org notify( "stop_loop" );
	level.price stopanimscripted();
//	level.price anim_single_queue( level.price, "time_to_move" );
	org anim_single_solo( level.price, "spotter_exit" );
	

// 	level.rope thread maps\_debug::drawTagForever( "RopeSnap_RI" );
}

player_rappel()
{

	
	// the rappel sequence is relative to this node
	player_node = getnode( "player_rappel_node", "targetname" );

	rope = spawn_anim_model( "player_rope" );
	player_node thread anim_first_frame_solo( rope, "rappel_for_player" );

	// this is the model the player will attach to for the rappel sequence
	model = spawn_anim_model( "player_rappel" );
	model hide();
	
	// put the model in the first frame so the tags are in the right place
	player_node anim_first_frame_solo( model, "rappel" );

	// this is sniperescape specific stuff for the helicopter that attacks and the explosion that goes off
	thread heli_attacks_start();

	flag_wait( "player_can_rappel" );

	rappel_trigger = getent( "rappel_trigger", "targetname" );
	rappel_trigger trigger_on();

	// temp glowing object
	rappel_glow = getent( "rappel_glow", "targetname" );

	rappel_trigger.origin = rappel_glow.origin;
	rappel_trigger sethintstring( "Hold &&1 to rappel" );
	
	rappel_glow show();
	rappel_trigger waittill( "trigger" );	
	rappel_trigger delete();
	
	thread vision_glow_change();
	
	rappel_glow hide();
	flag_set( "player_rappels" );
	
	level.player thread take_weapons();
	
	delayThread( 3.2, ::flag_set, "apartment_explosion" );

	// this smoothly hooks the player up to the animating tag
	model lerp_player_view_to_tag( "tag_player", 0.5, 0.9, 35, 35, 45, 0 );

	// now animate the tag and then unlink the player when the animation ends
	player_node thread anim_single_solo( model, "rappel" );
	player_node thread anim_single_solo( rope, "rappel_for_player" );
	player_node waittill( "rappel" );
	level.player unlink();
	
	level.player give_back_weapons();
	delaythread( 1.5, ::flag_set, "heli_moves_on" );
}

rappel()
{
	thread setup_rappel();

	ai = getaispeciesarray( "axis", "all" );
	array_thread( ai, ::delete_living );

	thread player_rappel();
	price_node = getnode( "price_rappel_node", "targetname" );
	price_node anim_reach_solo( level.price, "rappel_start" );
	
	// birds fly up
	delayThread( 2, ::exploder, 6 );
	
	delaythread( 3, ::flag_set, "player_can_rappel" );
	thread apartment_explosion();

	guys = [];
	guys[ guys.size ] = level.price;
	guys[ guys.size ] = level.rope;

	price_node anim_single( guys, "rappel_start" );
	price_node thread anim_loop( guys, "rappel_idle", undefined, "stop_idle" );
	flag_wait( "player_rappels" );
	price_node notify( "stop_idle" );
	price_node thread anim_single( guys, "rappel_end" );
	wait( 4 );
	level.price set_force_color( "r" );
	thread battle_through_heat_area();
}

apartment_explosion()
{
// temporarily disable this for show
	// blow up the apartment if the player doesn't rappel soon enough
// 	explosion_death_trigger
	
	flag_wait_or_timeout( "apartment_explosion", 8 );

	// blow up the top floor
	exploder( 3 );
	deathtrig = getent( "explosion_death_trigger", "targetname" );
	wait( 2.4 );

	if ( !( level.player istouching( deathtrig ) ) )
		return;
		
	level.player enableHealthShield( false );
	level.player dodamage( level.player.health + 99150, deathtrig.origin );
}

start_run()
{
	thread vision_glow_change();
	ai = getaispeciesarray( "axis", "all" );
	array_thread( ai, ::delete_living );
	node = getnode( "tele_node", "targetname" );
	org = getent( "tele_org", "targetname" );
	
	level.player setplayerangles( ( 0, 0, 0 ) );
	level.player setorigin( org.origin + ( 0, 0, -34341 ) );
	level.price teleport( node.origin );
	plant_price();
	level.player setorigin( org.origin );
	
	thread battle_through_heat_area();
}

battle_through_heat_area()
{
	// kill heli comes and gets you if you take too long in one zone
	thread kill_heli_logic();

	level.price.dontshootwhilemoving = true;
	level.move_in_trigger_used = [];
	run_thread_on_targetname( "move_in_trigger", ::move_in );
// 	level.price thread price_calls_out_kills();

	weapons_dealers = getentarray( "weapons_dealer", "targetname" );
	array_thread( weapons_dealers, ::delete_living );

	// change enemy accuracy on the fly so we can fight tons of guys without it being lame
	thread enemy_accuracy_assignment();

	east_spawners = getentarray( "east_spawner", "targetname" );
	thread heat_spawners_attack( east_spawners, "start_heat_spawners", "stop_heat_spawners" );

	west_spawners = getentarray( "west_spawner", "targetname" );
	thread heat_spawners_attack( west_spawners, "start_heat_spawners", "stop_heat_spawners" );

	wait( 1 );
	autosave_by_name( "follow_me" );

	// Leftenant Price, follow me!	
	level.price anim_single_queue( level.price, "follow_me" );
	
	objective_add( 1, "active", "Follow Cpt. MacMillan to the extraction point.", extraction_point() );
	objective_current( 1 );
	level.price thread objective_position_update( 1 );

	// Alpha Six, Seaknight Five - Niner is en route, E.T.A. - 20 minutes. Don't be late. We're stretchin' our fuel as it is. Out.	
	delayThread( 3, ::radio_dialogue_queue, "eta_20_min" );
	delayThread( 5.5, ::countdown, 20 );

	thread price_runs_for_woods_on_contact();

// 	thread player_hit_debug();
	
	flag_wait( "start_heat_spawners" );
//	autosave_or_timeout( "heat_begins", 2.5 );
	
	// temporary work around for - onlyents bug
	spawn_vehicle_from_targetname_and_drive( "introchopper1" );

	wait_for_script_noteworthy_trigger( "heat_enemies_back_off" );
	// _colors is waiting for this script to hit, so we have to wait for that to happen so that
	// the orange and yellow colors get set
	waittillframeend;

	assertex( level.price.script_forcecolor == "b", "Price's color was wrong" );	
	level.price set_force_color( "o" );

	defend_heat_area_until_enemies_leave();	

	assertex( level.price.script_forcecolor == "o", "Price's color was wrong" );	
	level.price set_force_color( "y" );
	
	thread the_apartment();
}

price_runs_for_woods_on_contact()
{
//	level waittill( "price_sees_enemy" );
	flag_wait( "start_heat_spawners" );

	level.price set_force_color( "b" );
	level.price.dontshootwhilemoving = undefined;

	// Enemy contact up ahead. Let's cut through the woods.	
//	level.price anim_single_queue( level.price, "cut_through_woods" );
//	wait( 8 );
	flag_set( "price_cuts_to_woods" );

}

start_apartment()
{
	thread vision_glow_change();
	thread countdown( 18 );
	objective_add( 1, "active", "Follow Cpt. MacMillan to the extraction point.", extraction_point() );
	objective_current( 1 );

	ai = getaispeciesarray( "axis", "all" );
	array_thread( ai, ::delete_living );
	price_org = getent( "price_apartment_org", "targetname" );
	player_org = getent( "player_apartment_org", "targetname" );
	
	level.player setplayerangles( ( 0, 0, 0 ) );
	level.player setorigin( player_org.origin + ( 0, 0, -34341 ) );
	level.price teleport( price_org.origin );
	plant_price();
	level.player setorigin( player_org.origin );
	level.price set_force_color( "y" );
	thread the_apartment();
}

the_apartment()
{
	flag_set( "break_for_apartment" );
	level notify( "stop_adjusting_enemy_accuracy" );
	// We'll lose 'em in that apartment! Come on!	
	level.price thread anim_single_queue( level.price, "lose_them_in_apartment" );
	create_apartment_badplace();	

	spin_trigger = getent( "price_explore_trigger", "targetname" );
	spin_trigger waittill( "trigger" );
	spin_ent = getent( spin_trigger.target, "targetname" );
	autosave_by_name( "into_the_apartment" );
// 	musicPlay( "bog_a_shantytown" ); 

	spin_ent anim_reach_solo( level.price, "spin" );
	spin_ent anim_single_solo( level.price, "spin" );
	level.price set_force_color( "y" );

	flag_wait( "fence_dog_attacks" );
	
	thread dog_attacks_fence();

	thread the_wounding();
}

start_wounding()
{
// 	thread heli_attacks_price();
	thread vision_glow_change();
	create_apartment_badplace();
	objective_add( 1, "active", "Follow Cpt. MacMillan to the extraction point.", extraction_point() );
	objective_current( 1 );
	thread countdown( 16 );

	ai = getaispeciesarray( "axis", "all" );
	array_thread( ai, ::delete_living );
	price_org = getent( "price_apart_org", "targetname" );
	player_org = getent( "player_apart_org", "targetname" );
	
	level.player setplayerangles( player_org.angles );
	level.player setorigin( player_org.origin + ( 0, 0, -34341 ) );
	level.price teleport( price_org.origin );
	plant_price();
	level.player setorigin( player_org.origin );
	level.price setgoalpos( level.price.origin );
	level.price enable_cqbwalk();
	level.price set_force_color( "y" );
	thread the_wounding();
}

the_wounding()
{
	flag_set( "price_calls_out_kills" );

	flag_wait( "price_signals_holdup" );
	level.price disable_ai_color();

	// ai may already be alerted or dog may be chasing
	if ( should_halt() )
	{
		// price singals to halt
		node = getent( "halt_node", "targetname" );
		node anim_reach_solo( level.price, "halt" );
		node anim_single_solo( level.price, "halt" );

		level.price.disableexits = true;
		// wait 2 seconds or until price has an enemy
		timer = 2 * 20;
		for ( i = 0; i < timer; i++ )
		{
			if ( isalive( level.price.enemy ) )
				break;
				
			wait( 0.05 );
		}
	}
		
	level.price enable_ai_color();
	
// 	flag_wait( "plant_claymore" );
// 	flag_clear( "plant_claymore" );

	// Quickly - plant claymores if they come this way!	
// 	level.price thread anim_single_queue( level.price, "place_claymore" );
	
	flag_wait( "player_moves_through_apartment" );

	thread price_wounding_kill_trigger();
	
	thread player_touches_wounded_blocker();

	wait( 0.2 );	
	level.price.disableexits = false;

// 	level.price.maxVisibleDist = 32;
// 	level.player.maxVisibleDist = 32;
	
	price_waits_for_enemies_to_walk_past();	
	level.price.maxvisibledist = 200;
	delete_wounding_sight_blocker();
// 	delaythread( 4.0, ::activate_trigger_with_targetname, "surprise_trigger" );	
	
	
	node = getnode( "price_attack_node", "targetname" );
	level.price disable_ai_color();
	level.price.fixedNodeSafeRadius = 32;
	level.price setgoalnode( node );
	level.price.goalradius = 32;
	
	level.price waittill( "goal" );
	level.price.maxvisibledist = 8000;
	
	flag_wait( "player_touches_wounding_clip" );
	waittill_noteworthy_dies( "patrol_guy" );
	
	
	node = getnode( "price_apartment_destination_node", "targetname" );
	level.price.fixedNodeSafeRadius = node.fixedNodeSafeRadius;
	level.price setgoalnode( node );
	
	surprisers = getentarray( "surprise_spawner", "targetname" );
	array_thread( surprisers, ::spawn_ai );
	/* 
	// now done via trigger
	door_left = getent( "wounding_door_left", "targetname" );
	door_right = getent( "wounding_door_right", "targetname" );
	door_left thread door_opens();
	door_right thread door_opens( - 1 );
	*/ 
	
// 	flag_wait( "price_walks_into_trap" );
	thread heli_attacks_price();
}
	
heli_attacks_price()
{
	node = getnode( "price_apartment_destination_node", "targetname" );

	heli = spawn_vehicle_from_targetname_and_drive( "heli_price" );
	level.price_heli = heli;
	heli thread helipath( heli.target, 70, 70 );
	wait( 1 );
	
	// More behind us!	
	level.price thread anim_single_queue( level.price, "more_behind" );

	node anim_reach_solo( level.price, "wounded_begins" );
	
	flag_wait( "price_heli_in_position" );

	node anim_reach_solo( level.price, "wounded_begins" );
	
// 	heli thread kills_enemies_then_wounds_price_then_leaves();
	delaythread( 5.5, ::flag_set, "price_heli_moves_on" );
	heli delaythread( 6.5, ::heli_shoots_rockets_at_price );
	delaythread( 7.2, ::exploder, 500 );

	// Chopper!!! Get back! I'll cover you!	sniperescape_mcm_choppergetback
	node anim_single_solo( level.price, "wounded_begins" );
	
	thread wounded_combat();
}

price_waits_for_enemies_to_walk_past()
{
	if ( flag( "enemies_walked_past" ) )
		return;
 	if ( flag( "wounding_sight_blocker_deleted" ) )
 		return;
 		
	level endon( "wounding_sight_blocker_deleted" );
	flag_wait( "price_says_wait" );

	autosave_by_name( "standby" );	

	// Standby…!	
	level.price thread anim_single_queue( level.price, "standby" );
	flag_wait( "walked_past_price" );

	// Now!	
	level.price thread anim_single_queue( level.price, "now" );
}

start_wounded()
{
	thread vision_glow_change();
	create_apartment_badplace();
	objective_add( 1, "active", "Follow Cpt. MacMillan to the extraction point.", extraction_point() );
	objective_current( 1 );
	wounding_sight_blocker = getent( "wounding_sight_blocker", "targetname" );
	wounding_sight_blocker connectpaths();
	wounding_sight_blocker delete();

	thread countdown( 13 );

	ai = getaispeciesarray( "axis", "all" );
	array_thread( ai, ::delete_living );
	price_org = getnode( "price_apartment_destination_node", "targetname" );
	player_org = getent( "player_post_wound_org", "targetname" );
	
	level.player setplayerangles( player_org.angles );
	level.player setorigin( player_org.origin + ( 0, 0, -34341 ) );
	level.price teleport( price_org.origin );
	plant_price();
	level.player setorigin( player_org.origin );
	level.price disable_ai_color();
	
	thread wounded_combat();
}

wounded_combat()
{
	// dont like this guy anymore
	maps\_spawner::kill_spawnerNum( 10 );
	
	run_thread_on_noteworthy( "flee_guy", ::add_spawn_function, ::flee_guy_runs );
	run_thread_on_noteworthy( "force_patrol", ::add_spawn_function, ::force_patrol_think );
	


	delete_apartment_badplace();
	add_global_spawn_function( "axis", ::on_the_run_enemies );

	run_thread_on_targetname( "wounded_combat_trigger", ::wounded_combat_trigger );

	thread second_apartment_line();
	

	flag_set( "price_is_safe_after_wounding" );
	autosave_by_name( "carry_price" );	
// 	musicStop();

	kill_all_enemies();
	
	// Bloody 'ell I’m hit, I can't move!!!!	
	level.price thread anim_single_queue( level.price, "im_hit" );

	objective_string( 1, "Pick up Cpt. MacMillan." );
	objective_position( 1, level.price.origin );
	// price is hit so he is no longer the objective
	level notify( "stop_updating_objective" );
// 	delaythread( 5, ::activate_trigger_with_targetname, "surprise_trigger" );	
	
// 	zones = getentarray( "zone", "targetname" );
// 	array_thread( zones, ::enemy_spawn_zone );
	thread price_wounded_logic();

	thread price_followup_line();

	// The extraction point is to the southwest. We can still make it if we hurry.	
	thread do_in_order( ::flag_wait, "price_picked_up", ::radio_dialogue_queue, "extraction_is_southwest" );
	
	flag_wait( "price_picked_up" );

	autosave_by_name( "price_picked_up" );		
	objective_string( 1, "Drag MacMillan bodily to the extraction point." );
	set_objective_pos_to_extraction_point();

	
	thread enemy_zone_spawner();

	flag_wait( "enter_burnt" );
	thread enter_burnt_apartment();
}

start_burnt()
{
	add_global_spawn_function( "axis", ::on_the_run_enemies );
	thread vision_glow_change();
	objective_add( 1, "active", "Drag MacMillan bodily to the extraction point.", extraction_point() );
	objective_current( 1 );
	set_objective_pos_to_extraction_point();
	wounding_sight_blocker = getent( "wounding_sight_blocker", "targetname" );
	wounding_sight_blocker connectpaths();
	wounding_sight_blocker delete();

	thread countdown( 6 );

	ai = getaispeciesarray( "axis", "all" );
	array_thread( ai, ::delete_living );
	player_org = getent( "player_burnt_org", "targetname" );
	price_org = getent( "price_burnt_org", "targetname" );
	
	level.player setorigin( player_org.origin + ( 0, 0, -5150 ) );
	level.price teleport( price_org.origin );
	plant_price();
	level.player setplayerangles( player_org.angles );
	level.player setorigin( player_org.origin );
	
	wait( 0.05 );// magic bullet shield lameness
	thread price_wounded_logic();
	thread enter_burnt_apartment();
}

enter_burnt_apartment()
{

// 	thread apartment_hunters();
// 	thread more_plant_claymores();
// 	thread burnt_spawners();
	thread spooky_sighting();
	thread spooky_dog();

	setdvar( "player_sees_pool_dogs", "" );
	
	run_thread_on_noteworthy( "apartment_guard", ::add_spawn_function, ::set_fixednode_true );
	run_thread_on_noteworthy( "apartment_guard", ::add_spawn_function, ::set_baseaccuracy, 100 );


	thread do_in_order( ::flag_wait, "enter_burnt", ::clear_dvar, "player_hasnt_been_spooked" );
	thread player_navigates_burnt_apartment();
	
	/* 
	assert( level.flag[ "to_the_pool" ] );
	ai = getaiarray( "axis", "all" );
	array_thread( ai, ::deleteme );
	*/ 
	thread pool();
	
	trigger = getent( "level_end", "targetname" );
	trigger.origin += ( 0, 150, 0 );
// 	wait_for_targetname_trigger( "level_end" );
// 	iprintlnbold( "End of current level" );
// 	wait( 2 );
// 	missionsuccess( "icbm", false );
	
	thread fairgrounds_before_battle();
}

start_pool()
{
	thread vision_glow_change();
	objective_add( 1, "active", "Drag MacMillan bodily to the extraction point.", extraction_point() );
	objective_current( 1 );
	set_objective_pos_to_extraction_point();
	wounding_sight_blocker = getent( "wounding_sight_blocker", "targetname" );
	wounding_sight_blocker connectpaths();
	wounding_sight_blocker delete();

	thread countdown( 8 );

	ai = getaispeciesarray( "axis", "all" );
	array_thread( ai, ::delete_living );
	player_org = getent( "player_pool_org", "targetname" );
	price_org = getent( "price_pool_org", "targetname" );
	
	level.player setorigin( player_org.origin + ( 0, 0, -5150 ) );
	level.price teleport( price_org.origin );
	plant_price();
	level.player setplayerangles( player_org.angles );
	level.player setorigin( player_org.origin );
	
	setdvar( "player_sees_pool_dogs", "" );
	wait( 0.05 );// magic bullet shield lameness
	flag_set( "to_the_pool" );
	thread price_wounded_logic();
	thread fairgrounds_before_battle();
	thread pool();
}

pool()
{
	flag_wait( "to_the_pool" );
	
	// We're almost there. The extraction point is on the other side of that building.	
	thread radio_dialogue_queue( "almost_there" );

	if ( !flag( "fairbattle_high_intensity" ) )
	{
		if ( getdvar( "player_sees_pool_dogs" ) == "" )
		{
			setdvar( "player_sees_pool_dogs", "1" );
			dogs = get_guys_with_targetname_from_spawner( "eating_dog" );
			array_thread( dogs, ::pool_dog_think );
		}
	}
	
	flag_wait( "pool_lookat" );
	flag_set( "player_looked_in_pool" );
	
	
	/* 
	flag_wait( "pool_heli_attacks" );
	wait( 1.2 );

	pool_heli = spawn_vehicle_from_targetname_and_drive( "pool_heli" );
	pool_heli setturningability( 1 );
	
	flag_wait( "pool_heli_in_position" );
	wait( 1.5 );
	heli_target = getent( "pool_heli_target_1", "targetname" );
	pool_heli shoot_at_entity_chain( heli_target );

	flag_set( "pool_heli_tries_another_angle" );
	flag_wait( "pool_heli_in_second_position" );
	wait( 1 );

	heli_target = getent( "pool_heli_target_2", "targetname" );
	pool_heli shoot_at_entity_chain( heli_target );

	flag_set( "pool_heli_leaves" );
	wait( 2 );
	if ( !flag( "player_enters_fairgrounds" ) )
	{
// 		iprintlnbold( " < MacMillan > I think it's leaving, let's make a run for it" );
	}
	*/ 
}

start_fair()
{
	thread vision_glow_change();
	objective_add( 1, "active", "Drag MacMillan bodily to the extraction point.", extraction_point() );
	objective_current( 1 );
	set_objective_pos_to_extraction_point();
	wounding_sight_blocker = getent( "wounding_sight_blocker", "targetname" );
	wounding_sight_blocker connectpaths();
	wounding_sight_blocker delete();

	thread countdown( 8 );

	ai = getaispeciesarray( "axis", "all" );
	array_thread( ai, ::delete_living );
	player_org = getent( "player_fair_org", "targetname" );
	price_org = getent( "price_fair_org", "targetname" );
	
	level.player setorigin( player_org.origin + ( 0, 0, -5150 ) );
	level.price teleport( price_org.origin );
	plant_price();
	level.player setplayerangles( player_org.angles );
	level.player setorigin( player_org.origin );
	
	wait( 0.05 );// magic bullet shield lameness
	thread price_wounded_logic();
	flag_wait( "price_picked_up" );
	thread fairgrounds_before_battle();
	flag_set( "player_enters_fairgrounds" );
	flag_set( "to_the_pool" );
}

start_fair_battle()
{
	
	thread vision_glow_change();
	objective_add( 1, "active", "Drag MacMillan bodily to the extraction point.", extraction_point() );
	objective_current( 1 );
	set_objective_pos_to_extraction_point();
	wounding_sight_blocker = getent( "wounding_sight_blocker", "targetname" );
	wounding_sight_blocker connectpaths();
	wounding_sight_blocker delete();

	thread countdown( 8 );

	ai = getaispeciesarray( "axis", "all" );
	array_thread( ai, ::delete_living );
	player_org = getent( "player_fair_org", "targetname" );
	price_org = getent( "price_gnoll", "targetname" );
	
	level.player setorigin( player_org.origin + ( 0, 0, -5150 ) );
	level.price teleport( price_org.origin, price_org.angles );
	plant_price();
	level.player setplayerangles( player_org.angles );
	level.player setorigin( player_org.origin );
	
	wait( 0.05 );// magic bullet shield lameness
	
	flag_set( "price_can_be_left" );
	thread price_wounded_logic();
	thread fairgrounds_after_prep();
	flag_set( "player_enters_fairgrounds" );
	flag_set( "to_the_pool" );
}

fairgrounds_before_battle()
{
	level.price_gnoll_dist = 250;

	flag_wait( "player_enters_fairgrounds" );
	for ( ;; )
	{
		flag_wait( "player_reaches_extraction_point" );
		if ( flag( "price_picked_up" ) )
			break;
		flag_clear( "player_reaches_extraction_point" );
	}

	
	// Alpha Six, this is Big Bird. Standing by for your signal, over.
	radio_dialogue_queue( "waiting_for_signal" );
	
	wait( 0.35 );
	// Good. Our helicopter is standing by at a safe distance. The enemy will try to overrun our LZ once they pick him up on radar, so find a good sniping spot and go prone. Once you're in position, I'll call in the helicopter. Go.
	radio_dialogue_queue( "find_sniping_spot" );
	
//	thread add_dialogue_line( "MacMillan", "Put me down on the rise behind the Ferris wheel." );

	wait( 2 );
	objective_state( 1, "done" );
	objective_add( 2, "active", "Put Cpt MacMillan down behind the Ferris Wheel.", price_fair_defendspot() );
	objective_current( 2 );
	thread update_objective_position_for_fairground();
	thread price_says_this_is_fine();
	thread price_says_a_bit_farther();

	price_placement_trigger = getent( "price_placement_trigger", "targetname" );
	
	for ( ;; )
	{
		flag_waitopen( "price_picked_up" );
		if ( level.price istouching( price_placement_trigger ) )
			break;
		if ( distance( level.price.origin, price_fair_defendspot() ) <= level.price_gnoll_dist )
			break;
		flag_wait( "price_picked_up" );
	}
	objective_complete( 2 );

	thread fairgrounds_after_prep();	
}

fairgrounds_after_prep()
{
	flag_set( "price_moves_to_position" );
	flag_clear( "can_manage_price" );
	flag_set( "fair_hold_fire" );
	flag_set( "price_can_be_left" );

	fairground_chopper_spawners = getentarray( "chase_chopper_spawner", "script_noteworthy" );
	array_thread( fairground_chopper_spawners, ::add_spawn_function, ::fairground_enemies );
	
//	thread add_dialogue_line( "MacMillan", "Five niner is waiting at a safe distance." );
	 
	autosave_by_name( "the_fairgrounds" );
	wait( 2 );	
	
	
	claymoreCount = getPlayerClaymores();
	if ( claymoreCount )
	{
//		thread add_dialogue_line( "MacMillan", "Plant the rest of your claymores." );
		// And if you have any claymores left, now is the time to use them.
		thread radio_dialogue_queue( "use_claymores" );
		
		thread display_hint( "claymore_plant" );
		wait( 4 );
	}

		
	thread add_dialogue_line( "MacMillan", "I will signal Five Niner in thirty seconds." );
	wait( 4 );
//	thread add_dialogue_line( "MacMillan", "The enemy is sure to check this area, so find a good sniping spot." );

	claymoreCount = getPlayerClaymores();
	wait_for_player_to_place_claymores();

	
	if ( autosave_on_good_claymore_placement( claymoreCount ) )
	{
		// player did a decent job placing claymores so lets just save it
		autosave_now( "claymores_placed" );
	}
	
	
// 	player_snipe_spot = getent( "player_snipe_spot", "targetname" );
	
	objective_add( 4, "active", "Hold out until evac.", level.price.origin );
	objective_current( 4 );

// 	fairgrounds_wait_until_player_is_ready();

	// Alright lad, I've activated the beacon. Good luck.
	radio_dialogue_queue( "activated_beacon" );
	wait( 2.2 );

	// Alpha Six, we have a fix on your position. Hang tight. Big Bird out.
	thread radio_dialogue_queue( "have_a_fix" );
//	thread add_dialogue_line( "MacMillan", "Alright lad, I've activated the signal. Good luck." );
	
//	objective_complete( 3 );
	
	flag_set( "beacon_placed" );

	
	thread fairground_battle();	

	thread seaknight_flies_in( false );


	// wait until the _vehicle scripts can do assorted waits they do	
	wait( 1 );

// 	thread do_in_order( ::wait_until_seaknight_gets_close, 150000, ::flag_set, "seaknight_flies_in" );
	objective_add( 4, "active", "Seaknight incoming", level.seaknight.origin );
	objective_additionalcurrent( 4 );
	objective_icon( 4, "objective_heli" );
	thread update_seaknight_objective_pos();
	
// 	thread fairground_air_war();
}

rotor_anim()
{
	for ( ;; )
	{
		self setanim( self getanim( "rotors" ), 1, 0, 1 );
		wait( 4 );
	}
}


start_seaknight()
{
	flag_set( "price_can_be_left" );
	thread vision_glow_change();
	objective_add( 1, "active", "Drag MacMillan bodily to the extraction point.", extraction_point() );
	objective_current( 1 );
	set_objective_pos_to_extraction_point();
	wounding_sight_blocker = getent( "wounding_sight_blocker", "targetname" );
	wounding_sight_blocker connectpaths();
	wounding_sight_blocker delete();

	thread countdown( 8 );

	ai = getaispeciesarray( "axis", "all" );
	array_thread( ai, ::delete_living );
	player_org = getent( "player_fair_org", "targetname" );
	price_org = getent( "price_gnoll", "targetname" );
	
	level.player setorigin( player_org.origin + ( 0, 0, -5150 ) );
	level.price teleport( price_org.origin, price_org.angles );
	plant_price();
	level.player setplayerangles( player_org.angles );
	level.player setorigin( player_org.origin );
	
	wait( 0.05 );// magic bullet shield lameness
	thread price_wounded_logic();
	thread fairgrounds_after_prep();
	flag_set( "player_enters_fairgrounds" );
	thread seaknight_flies_in( true );
	wait( 1 );
// 	thread do_in_order( ::wait_until_seaknight_gets_close, 150000, ::flag_set, "seaknight_flies_in" );
	objective_add( 4, "active", "Seaknight incoming", level.seaknight.origin );
	objective_additionalcurrent( 4 );
	objective_icon( 4, "objective_heli" );
	thread update_seaknight_objective_pos();
}


seaknight_flies_in( debug )
{
	seaknight = spawn_vehicle_from_targetname_and_drive( "seaknight" );
	level.seaknight = seaknight;
	
// 	seaknight.origin = ( - 558000, seaknight.origin[ 1 ], seaknight.origin[ 2 ] );
	if ( !debug )
		seaknight waittill( "reached_dynamic_path_end" );
		
	seaknight_node = getent( "seaknight_landing", "targetname" );

	seaknight = seaknight vehicle_to_dummy();

	if ( level.start_point == "seaknight" )
	{
		seaknight thread liner();
		seaknight thread maps\_debug::drawTagForever( "tag_detach" );
		seaknight thread maps\_debug::drawTagForever( "tag_origin" );
		seaknight thread maps\_debug::drawOriginForever();
	}
	
	seaknight.animname = "seaknight";
	seaknight thread rotor_anim();
	flag_set( "seaknight_flies_in" );
	
	level.seaknight = seaknight;
	seaknight thread seaknight_badplace();
// 	seaknight thread maps\_debug::drawTagForever( "tag_origin" );
// 	seaknight thread maps\_debug::drawTagForever( "tag_detach" );
	seaknight assign_animtree();
	seaknight_collmap = getent( "seaknight_collmap", "targetname" );
	seaknight_collmap linkto( seaknight, "tag_origin", ( 0, 0, 0 ), ( 0, 0, 0 ) );

	seaknight_entrance_trigger = getent( "seaknight_trigger", "targetname" );
	seaknight_entrance_trigger thread attachto( seaknight_collmap );

	seaknight_death_trigger = getent( "seaknight_death_trigger", "targetname" );
	seaknight_death_trigger thread attachto( seaknight );
	seaknight_death_trigger thread seaknight_squashes_stuff();
	
	seaknight thread spawn_seaknight_crew();
	seaknight_node anim_single_solo( seaknight, "landing" );
	flag_set( "seaknight_lands" );

	// Alpha Team, we're at the LZ. Standing by.
	thread radio_dialogue_queue( "heli_at_the_lz" );
	hangout_time = 60;
	
	thread seaknight_leaving_warning( hangout_time );
		
	// dont want to save after this
	flag_clear( "can_save" );

	// no more grenades from baddies for the big exit.
	add_global_spawn_function( "axis", ::no_grenades );
	axis = getaiarray( "axis" );
	array_thread( axis, ::set_grenadeammo, 0 );

	seaknight_node thread anim_loop_solo( seaknight, "idle", undefined, "stop_idle" );
	seaknight_death_trigger delete();

	objective_complete( 4 );

	trigger = spawn( "script_origin", (0,0,0) );
	trigger.origin = seaknight gettagorigin( "door_rear" );
	trigger.radius = 128;

	objective_add( 5, "active", "Get Cpt. MacMillan to the Seaknight.", trigger.origin );
	objective_current( 5 );

	flag_set( "can_manage_price" );

	thread player_abandons_seaknight_protection();
	thread player_boards_seaknight( seaknight, trigger );
	delaythread( hangout_time, ::flag_set, "seaknight_leaves_prematurely" );

	wait_for_seaknight_to_take_off();
	
	flag_set( "seaknight_prepares_to_leave" );

	// wait for the guys to get back on, comes from flag
	wait( 12 );
	seaknight_node notify( "stop_idle" );
	flag_set( "seaknight_leaves" );
	
	seaknight_node anim_single_solo( seaknight, "take_off" );

	if ( flag( "player_made_it_to_seaknight" ) )
	{
		missionsuccess( "village_defend", false );
		return;
	}
	
	setdvar( "ui_deadquote", "You failed to reach the Seaknight in time" );
	maps\_utility::missionFailedWrapper();
}


liner()
{
	for ( ;; )
	{
		line( self.origin, level.player.origin );
		wait( 0.05 );
	}
}

spawn_seaknight_crew()
{
	spawners = getentarray( "seaknight_spawner", "targetname" );
	array_thread( spawners, ::add_spawn_function, ::seaknight_defender );
	org = self gettagorigin( "tag_detach" );
	guys = [];
	for ( i = 0; i < spawners.size; i++ )
	{
		spawners[ i ].origin = org;
		spawn = spawners[ i ] stalingradspawn();
		spawn.animname = "guy" + ( i + 1 );
		guys[ guys.size ] = spawn;
	}
	
	self thread anim_first_frame( guys, "unload", "tag_detach" );
	
	for ( i = 0; i < guys.size; i++ )
	{
		guys[ i ] linkto( self );
	}
	
	flag_wait( "seaknight_lands" );

	for ( i = 0; i < guys.size; i++ )
	{
		guys[ i ] unlink();
	}
	
	array_thread( guys, ::send_notify, "stop_first_frame" );
	self anim_single( guys, "unload", "tag_detach" );
	flag_wait( "seaknight_prepares_to_leave" );
	self anim_single( guys, "load", "tag_detach" );
	
// 	array_thread( guys, ::stop_magic_bullet_shield );
// 	array_thread( guys, ::deleteme );
}

seaknight_defender()
{
	self thread magic_bullet_shield();
	self allowedstances( "crouch" );

	wait( 1 );
	self.a.pose = "crouch";
	self waittillmatch( "single anim", "end" );
	self setgoalpos( self.origin );	
	self.goalradius = 16;

	flag_wait( "seaknight_prepares_to_leave" );
	self waittillmatch( "single anim", "end" );
	self stop_magic_bullet_shield();
	self delete();
}

attachto( target )
{
	self endon( "death" );
	
	for ( ;; )
	{
		self.origin = target.origin;
		self.angles = target.angles;
		wait( 0.05 );
	}
}

wait_until_seaknight_gets_close( dist )
{
	seaknight_node = getent( "seaknight_landing", "targetname" );
	level.seanode = seaknight_node;
	for ( ;; )
	{
		newdist = distance( level.seaknight.origin, seaknight_node.origin );
		if ( newdist < dist )
			return;
		wait( 0.05 );
	}
}

should_break_prone_hint()
{
	player_snipe_spot = getent( "player_snipe_spot", "targetname" );
	if ( distance( level.player.origin, player_snipe_spot.origin ) >= player_snipe_spot.radius )
		return true;
	
	return level.player getstance() == "prone";
}

should_break_claymores()
{
	claymoreCount = getPlayerClaymores();
	if ( claymoreCount <= 0 )
		return true;

	return level.player GetCurrentWeapon() == "claymore";
}