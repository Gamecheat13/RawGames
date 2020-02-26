#include maps\_utility;
#include maps\_vehicle;
#include maps\sniperescape_code;
#include common_scripts\utility;
#include maps\_anim;

main()
{
	maps\createart\sniperescape_art::main();
	maps\sniperescape_fx::main();
	maps\_mi17::main( "vehicle_mi17_woodland_fly_cheap" );
	maps\_mi28::main( "vehicle_mi-28_flying" );
	maps\_cobra::main( "vehicle_cobra_helicopter_fly" );
	maps\_hind::main( "vehicle_mi24p_hind_woodland" );
	maps\_seaknight::main( "vehicle_ch46e" );
	maps\createfx\sniperescape_fx::main();
	maps\createfx\sniperescape_audio::main();

	maps\_load::set_player_viewhand_model( "viewhands_player_marines" );

	animscripts\dog_init::initDogAnimations();
	setsaveddvar( "ai_eventDistFootstep", "32" );
	setsaveddvar( "ai_eventDistFootstepLite", "32" );

	precacheModel( "temp" );
	precacheModel( "weapon_c4" );
	precacheItem( "cobra_seeker" );
	level.heli_objective = precacheshader( "objective_heli" );
	add_start( "run", ::start_run );
	add_start( "apart", ::start_apartment );
	add_start( "wounding", ::start_wound );
	add_start( "wounded", ::start_wounded );
	add_start( "pool", ::start_pool );
	add_start( "fair", ::start_fair );
	default_start( ::rappel );
	createthreatbiasgroup( "price" );
	createthreatbiasgroup( "dog" );
	setignoremegroup( "price", "dog" );

	
	maps\_load::main();
	
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

	// flags
	flag_init( "player_rappels" );
	flag_init( "wounding_sight_blocker_deleted" );	
	flag_init( "player_can_rappel" );
	flag_init( "apartment_explosion" );
	flag_init( "heat_area_cleared" );
	flag_init( "player_defends_heat_area" );
	flag_init( "price_is_safe_after_wounding" );
	flag_init( "price_was_hit_by_heli" );
	flag_init( "price_picked_up" );
	flag_init( "beacon_placed" );
	flag_init( "seaknight_flies_in" );
	flag_init( "enemy_choppers_incoming" );
	flag_init( "seaknight_leaves" );

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

	run_thread_on_noteworthy( "patrol_guy", ::add_spawn_function, ::patrol_guy );
	run_thread_on_noteworthy( "chopper_guys", ::add_spawn_function, ::chopper_guys_land );
	run_thread_on_noteworthy( "chase_chopper_guys", ::add_spawn_function, ::chase_chopper_guys_land );

	thread music();	
	
}

music()
{
//	level endon( "price_is_safe_after_wounding" );
	for( ;; )
	{
		musicPlay( "sniperescape_run_music" ); 
		wait( 137 );
	}
}


priceInit()
{
	self thread magic_bullet_shield();
	self.baseaccuracy = 1000;
	self.animplaybackrate = 1.1;
	self.ignoresuppression = true;
	self.animname = "price";
	
	thread gilli_leaves();
}

playerangles()
{
	for( ;; )
	{
		println( level.player getplayerangles() );
		wait( 0.05 );
	}
}

player_rappel()
{
	// temp glowing object
	rappel_glow = getent( "rappel_glow", "targetname" );
	rappel_glow hide();
	
	// the rappel sequence is relative to this node
	player_node = getnode( "player_rappel_node", "targetname" );

	// this is the model the player will attach to for the rappel sequence
	model = spawn_anim_model( "player_rappel" );
	model hide();
	
	// put the model in the first frame so the tags are in the right place
	player_node anim_first_frame_solo( model, "rappel" );

	// this is sniperescape specific stuff for the helicopter that attacks and the explosion that goes off
	thread heli_attacks_start();
	rappel_trigger = getent( "rappel_trigger", "targetname" );
	rappel_trigger trigger_off();
	flag_wait( "player_can_rappel" );
	rappel_trigger trigger_on();
	rappel_trigger.origin = rappel_glow.origin;
	rappel_trigger sethintstring( "Hold &&1 to rappel" );
	
	rappel_glow show();
	rappel_trigger waittill( "trigger" );	
	rappel_trigger delete();
	rappel_glow hide();
	flag_set( "player_rappels" );
	
	level.player thread take_weapons();
	
	delayThread( 3.2, ::flag_set, "apartment_explosion" );

	// this smoothly hooks the player up to the animating tag
	model lerp_player_view_to_tag( "tag_player", 0.5, 0.9, 35, 35, 45, 0 );

	// now animate the tag and then unlink the player when the animation ends
	player_node thread anim_single_solo( model, "rappel" );
	player_node waittill( "rappel" );
	level.player unlink();
	
	level.player give_back_weapons();
	delaythread( 1.5, ::flag_set, "heli_moves_on" );
}

rappel()
{
	ai = getaispeciesarray( "axis", "all" );
	array_thread( ai, ::delete_living );

	thread player_rappel();
	price_node = getnode( "price_rappel_node", "targetname" );
	price_node anim_reach_solo( level.price, "rappel_start" );
	
	// birds fly up
	delayThread( 2, ::exploder, 6 );
	
	delaythread( 3, ::flag_set, "player_can_rappel" );
	thread apartment_explosion();
	price_node anim_single_solo( level.price, "rappel_start" );
	price_node thread anim_loop_solo( level.price, "rappel_idle", undefined, "stop_idle" );
	flag_wait( "player_rappels" );
	price_node notify( "stop_idle" );
	price_node thread anim_single_solo( level.price, "rappel_end" );
	wait( 4 );
	level.price set_force_color( "r" );
	thread battle_through_heat_area();
}

apartment_explosion()
{
// temporarily disable this for show
	if ( 1 )
		return;

	// blow up the apartment if the player doesn't rappel soon enough
//	explosion_death_trigger
	
	flag_wait_or_timeout( "apartment_explosion", 8 );

	// blow up the top floor
	exploder( 3 );
	deathtrig = getent( "explosion_death_trigger", "targetname" );
	wait( 2.4 );

	if( !( level.player istouching( deathtrig ) ) )
		return;
		
	level.player enableHealthShield( false );
	level.player dodamage( level.player.health + 99150, deathtrig.origin );
}

start_run()
{
	ai = getaispeciesarray( "axis", "all" );
	array_thread( ai, ::delete_living );
	node = getnode( "tele_node", "targetname" );
	org = getent( "tele_org", "targetname" );
	
	level.player setplayerangles(( 0, 0, 0 ) );
	level.player setorigin( org.origin +( 0, 0, -34341 ) );
	level.price teleport( node.origin );
	level.player setorigin( org.origin );
	
	thread battle_through_heat_area();
}

battle_through_heat_area()
{
	level.move_in_trigger_used = [];
	run_thread_on_targetname( "move_in_trigger", ::move_in );
//	level.price thread price_calls_out_kills();

	weapons_dealers = getentarray( "weapons_dealer", "targetname" );
	array_thread( weapons_dealers, ::delete_living );

	// change enemy accuracy on the fly so we can fight tons of guys without it being lame
	thread enemy_accuracy_assignment();

	east_spawners = getentarray( "east_spawner", "targetname" );
	thread heat_spawners_attack( east_spawners, "start_heat_spawners", "stop_heat_spawners" );

	west_spawners = getentarray( "west_spawner", "targetname" );
	thread heat_spawners_attack( west_spawners, "start_heat_spawners", "stop_heat_spawners" );

	wait( 1 );

	// Leftenant Price, follow me!	
	level.price anim_single_queue( level.price, "follow_me" );
	
	objective_add( 1, "active", "FOLLOW CPT. MACMILLAN TO THE EXTRACTION POINT.", extraction_point() );
	objective_current( 1 );
	level.price thread objective_position_update( 1 );

	// Alpha Six, Seaknight Five-Niner is en route, E.T.A. - 20 minutes. Don't be late. We're stretchin' our fuel as it is. Out.	
	delayThread( 3, ::radio_dialogue_queue, "eta_20_min" );
	delayThread( 5.5, ::countdown, 20 );

	thread price_runs_for_woods_on_contact();

	// We've got to head for the extraction point! Move!	
	level.price delayThread( 10, ::anim_single_queue, level.price, "head_for_extract" );
	
//	thread player_hit_debug();
	
	flag_wait( "start_heat_spawners" );
	
	// temporary work around for -onlyents bug
	spawn_vehicle_from_targetname_and_drive( "introchopper1" );

	wait_for_script_noteworthy_trigger( "heat_enemies_back_off" );
	// _colors is waiting for this script to hit, so we have to wait for that to happen so that
	// the orange and yellow colors get set
	waittillframeend;

	assertex( level.price.script_forcecolor == "g", "Price's color was wrong" );	
	level.price set_force_color( "o" );

	defend_heat_area_until_enemies_leave();	

	assertex( level.price.script_forcecolor == "o", "Price's color was wrong" );	
	level.price set_force_color( "y" );
	
	thread the_apartment();
}

price_runs_for_woods_on_contact()
{
	level waittill( "price_sees_enemy" );
	level.price set_force_color( "g" );
}

start_apartment()
{
	thread countdown( 18 );
	objective_add( 1, "active", "FOLLOW CPT. MACMILLAN TO THE EXTRACTION POINT.", extraction_point() );
	objective_current( 1 );

	ai = getaispeciesarray( "axis", "all" );
	array_thread( ai, ::delete_living );
	price_org = getent( "price_apartment_org", "targetname" );
	player_org = getent( "player_apartment_org", "targetname" );
	
	level.player setplayerangles(( 0, 0, 0 ) );
	level.player setorigin( player_org.origin +( 0, 0, -34341 ) );
	level.price teleport( price_org.origin );
	level.player setorigin( player_org.origin );
	level.price set_force_color( "y" );
	thread the_apartment();
}

the_apartment()
{
	// We'll lose 'em in that apartment! Come on!	
	level.price anim_single_queue( level.price, "lose_them_in_apartment" );
	create_apartment_badplace();	

	spin_trigger = getent( "price_explore_trigger", "targetname" );
	spin_trigger waittill( "trigger" );
	spin_ent = getent( spin_trigger.target, "targetname" );
	autosave_by_name( "into_the_apartment" );
//	musicPlay( "bog_a_shantytown" ); 

	spin_ent anim_reach_solo( level.price, "spin" );
	spin_ent anim_single_solo( level.price, "spin" );
	level.price set_force_color( "y" );

	flag_wait( "fence_dog_attacks" );
	
	thread dog_attacks_fence();

	flag_wait( "plant_claymore" );

	// Quickly - plant a claymore in case they come this way!	
	level.price thread anim_single_queue( level.price, "place_claymore" );
	
	flag_wait( "player_moves_through_apartment" );
	thread the_wounding();
}

start_wound()
{
	create_apartment_badplace();
	objective_add( 1, "active", "FOLLOW CPT. MACMILLAN TO THE EXTRACTION POINT.", extraction_point() );
	objective_current( 1 );
	thread countdown( 16 );

	ai = getaispeciesarray( "axis", "all" );
	array_thread( ai, ::delete_living );
	price_org = getent( "price_apart_org", "targetname" );
	player_org = getent( "player_apart_org", "targetname" );
	
	level.player setplayerangles( player_org.angles );
	level.player setorigin( player_org.origin +( 0, 0, -34341 ) );
	level.price teleport( price_org.origin );
	level.player setorigin( player_org.origin );
	level.price enable_cqbwalk();
	level.price set_force_color( "y" );
	thread the_wounding();
}

the_wounding()
{
	thread price_wounding_kill_trigger();
	
	thread player_touches_wounded_blocker();
//	level.price.maxVisibleDist = 32;
//	level.player.maxVisibleDist = 32;
	
	price_waits_for_enemies_to_walk_past();	
	level.price.maxvisibledist = 200;
	delete_wounding_sight_blocker();
	delaythread( 4.0, ::activate_trigger_with_targetname, "surprise_trigger" );	
	
	
	node = getnode( "price_attack_node", "targetname" );
	level.price disable_ai_color();
	level.price.fixedNodeSafeRadius = 32;
	level.price setgoalnode( node );
	level.price.goalradius = 32;
	
	level.price waittill( "goal" );
	level.price.maxvisibledist = 8000;
	
	node = getnode( "price_apartment_destination_node", "targetname" );
	level.price.fixedNodeSafeRadius = node.fixedNodeSafeRadius;
	level.price setgoalnode( node );

	flag_wait( "price_walks_into_trap" );
	
	wait( 3 );
	
	heli = spawn_vehicle_from_targetname_and_drive( "heli_price" );
	level.price_heli = heli;
	heli thread helipath( heli.target, 70, 70 );
	flag_wait( "price_heli_in_position" );
	wait( 1 );
	heli kills_enemies_then_wounds_price_then_leaves();
	thread wounded_combat();
}

price_waits_for_enemies_to_walk_past()
{
	if( flag( "enemies_walked_past" ) )
		return;
 	if( flag( "wounding_sight_blocker_deleted" ) )
 		return;
 		
	level endon( "wounding_sight_blocker_deleted" );
	flag_wait( "price_says_wait" );

	autosave_by_name( "standby" );	

	// Standby…!	
	level.price thread anim_single_queue( level.price, "standby" );
	flag_wait( "enemies_walked_past" );

	// Now!	
	level.price thread anim_single_queue( level.price, "now" );
}

start_wounded()
{
	create_apartment_badplace();
	objective_add( 1, "active", "FOLLOW CPT. MACMILLAN TO THE EXTRACTION POINT.", extraction_point() );
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
	level.player setorigin( player_org.origin +( 0, 0, -34341 ) );
	level.price teleport( price_org.origin );
	level.player setorigin( player_org.origin );
	level.price disable_ai_color();
	
	thread wounded_combat();
}

wounded_combat()
{
	delete_apartment_badplace();
	add_global_spawn_function( "axis", ::on_the_run_enemies );

	flag_set( "price_is_safe_after_wounding" );
	autosave_by_name( "carry_price" );	
//	musicStop();

	wait( 3.5 );
	// Bloody 'ell I’m hit, I can't move!!!!	
	level.price anim_single_queue( level.price, "im_hit" );

	objective_string( 1, "Pick up Cpt. MacMillan." );
	objective_position( 1, level.price.origin );
	// price is hit so he is no longer the objective
	level notify( "stop_updating_objective" );
//	delaythread( 5, ::activate_trigger_with_targetname, "surprise_trigger" );	
	
	zones = getentarray( "zone", "targetname" );
	array_thread( zones, ::enemy_spawn_zone );
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

enter_burnt_apartment()
{
	thread apartment_hunters();
	player_navigates_burnt_apartment();
	
	assert( level.flag[ "to_the_pool" ] );
	ai = getaiarray( "axis", "all" );
	array_thread( ai, ::deleteme );
	thread pool();
}

start_pool()
{
	objective_add( 1, "active", "DRAG MACMILLAN BODILY TO THE EXTRACTION POINT.", extraction_point() );
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
	level.player setplayerangles( player_org.angles );
	level.player setorigin( player_org.origin );
	
	wait( 0.05 ); // magic bullet shield lameness
	thread price_wounded_logic();
	thread pool();
}

pool()
{
	thread fairgrounds();
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
	if( !flag( "player_enters_fairgrounds" ) )
	{
//		iprintlnbold( "<MacMillan> I think it's leaving, let's make a run for it" );
	}
}

start_fair()
{
	objective_add( 1, "active", "DRAG MACMILLAN BODILY TO THE EXTRACTION POINT.", extraction_point() );
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
	level.player setplayerangles( player_org.angles );
	level.player setorigin( player_org.origin );
	
	wait( 0.05 ); // magic bullet shield lameness
	thread price_wounded_logic();
	thread fairgrounds();
	flag_set( "player_enters_fairgrounds" );
}

fairgrounds()
{
	fairground_chopper_spawners = getentarray( "chase_chopper_spawner", "script_noteworthy" );
	array_thread( fairground_chopper_spawners, ::add_spawn_function, ::fairground_enemies );
	
	flag_wait( "player_enters_fairgrounds" );
	flag_wait( "player_reaches_extraction_point" );
//	iprintlnbold( "<MacMillan> Activate the transponder so Five-Niner can come pick us up." );
	
	objective_state( 1, "done" );
	objective_add( 2, "active", "SIGNAL FOR EVAC.", extraction_point() );
	objective_current( 2 );
	
//	iprintlnbold( "Alright lad, plant the signal beacon. We'll have to be on our toes in case OpFor notices." );
	trigger = getent( "transponder_trigger", "targetname" );
	trigger sethintstring( "Hold &&1 to plant and activate the signal beacon." );
	trigger waittill( "trigger" );
	flag_set( "beacon_placed" );

	objective_state( 2, "done" );
	objective_add( 3, "active", "HOLD OUT UNTIL EVAC.", extraction_point() );
	objective_current( 3 );
	
	transponder = getent( "transponder", "targetname" );
	transponder setmodel( "weapon_c4" );
	trigger delete();
	
	autosave_by_name( "the_fairgrounds" );
	wait( 0.5 );
//	iprintlnbold( "Good, now let's find a place to hide." );

	thread fairground_battle();	

	thread seaknight_flies_in();


	// wait until the _vehicle scripts can do assorted waits they do	
	wait( 1 );

//	thread do_in_order( ::wait_until_seaknight_gets_close, 150000, ::flag_set, "seaknight_flies_in" );
	objective_add( 4, "active", "SEAKNIGHT INCOMING", level.seaknight.origin );
	objective_additionalcurrent( 4 );
	objective_icon( 4, "objective_heli" );
	thread update_seaknight_objective_pos();
	
	thread fairground_air_war();
}


seaknight_flies_in()
{
	seaknight = spawn_vehicle_from_targetname_and_drive( "seaknight" );
	level.seaknight = seaknight;
//	seaknight.origin = ( -558000, seaknight.origin[ 1 ], seaknight.origin[ 2 ] );
	seaknight waittill( "reached_dynamic_path_end" );
	seaknight = seaknight vehicle_to_dummy();
//	flag_set( "seaknight_flies_in" );
	wait( 95 );
	flag_set( "seaknight_flies_in" );
	wait( 32 );
	
	level.seaknight = seaknight;
	seaknight thread seaknight_badplace();
//	seaknight thread maps\_debug::drawTagForever( "tag_origin" );
//	seaknight thread maps\_debug::drawTagForever( "tag_detach" );
	seaknight.animname = "seaknight";
	seaknight assign_animtree();
	seaknight_collmap = getent( "seaknight_collmap", "targetname" );
	seaknight_collmap linkto( seaknight, "tag_origin", (0,0,0), (0,0,0) );

	seaknight_entrance_trigger = getent( "seaknight_trigger", "targetname" );
	seaknight_entrance_trigger thread attachto( seaknight_collmap );

	seaknight_death_trigger = getent( "seaknight_death_trigger", "targetname" );
	seaknight_death_trigger thread attachto( seaknight );
	seaknight_death_trigger thread seaknight_squashes_stuff();
	
	seaknight_node = getent( "seaknight_landing", "targetname" );
	seaknight_node anim_single_solo( seaknight, "landing" );
	seaknight_node thread anim_loop_solo( seaknight, "idle", undefined, "stop_idle" );
	seaknight_death_trigger delete();

	spawn_seaknight_crew();

	/*	
	seaknight_entrance_trigger waittill_notify_or_timeout( "trigger", 10 );
	
	if ( level.player istouching( seaknight_entrance_trigger ) )
	{
	*/
	
	trigger = spawn( "script_origin", (0,0,0) );
	trigger.origin = seaknight gettagorigin( "door_rear" );
//	seaknight thread maps\_debug::drawtagforever( "door_rear" );
	trigger.radius = 128;
//	trigger waittill_notify_or_timeout( "trigger", 10 );
	
	player_made_it = false;
	timer = gettime() + 10000;
	for ( ;; )
	{
		wait( 0.05 );
		if ( gettime() > timer )
			break;

		if ( isalive( level.price ) )
			continue;
			
		if ( distance( level.player.origin, trigger.origin ) < trigger.radius )
		{
			player_made_it = true;
			break;
		}
	}
	
	if ( player_made_it )
	{
		// this smoothly hooks the player up to the animating tag
		level.player unlink();
		seaknight lerp_player_view_to_tag( "tag_playerride", 0.5, 0.9, 35, 35, 45, 0 );
	}
	
	flag_set( "seaknight_leaves" );
	seaknight_node notify( "stop_idle" );
	seaknight_node anim_single_solo( seaknight, "take_off" );

	if ( player_made_it )
		missionsuccess( "village_defend", false );
}

spawn_seaknight_crew()
{
	spawners = getentarray( "seaknight_spawner", "targetname" );
	array_thread( spawners, ::add_spawn_function, ::seaknight_defender );
	for( i = 0; i < spawners.size; i++ )
	{
		spawners[ i ] stalingradspawn();
	}
}

seaknight_defender()
{
	self thread magic_bullet_shield();
	self.goalradius = 32;
	self allowedstances( "crouch" );
	flag_wait( "seaknight_leaves" );
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