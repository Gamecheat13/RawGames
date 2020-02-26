#include common_scripts\utility;
#include maps\_utility;
#include maps\_vehicle;
#include maps\_anim;
#include maps\scoutsniper_code;
#include maps\_stealth_logic;

#using_animtree( "generic_human" );
main()
{	
	//flags
	flag_init( "initial_setup_done" );
	
	flag_init( "intro" );
	flag_init( "intro_patrol_guy_down" );
	flag_init( "intro_patrol_guys_dead" );
	flag_init( "intro_last_patrol_dead" );
	flag_init( "intro_leave_area" );
	flag_init( "intro_safezone" );
	flag_init( "intro_left_area" );
	
	flag_init( "church_dialogue_done" );
	flag_init( "church_awareness" );
	flag_init( "church_patroller_dead" );
	flag_init( "church_patroller_faraway" );
	flag_init( "church_lookout_dead" );
	flag_init( "church_area_clear" );
	flag_init( "church_guess_he_cant_see" );
	flag_init( "church_run_for_it" );
	flag_init( "church_door_open" );
	flag_init( "church_and_intro_killed" );
	flag_init( "church_ladder_slide" );
	flag_init( "church_sneakup_dialogue_help" );
	flag_init( "church_start_patroller_line" );
	flag_init( "church_run_for_it_commit" );
	
	flag_init( "graveyard");
	flag_init( "graveyard_moveup" );
	flag_init( "graveyard_church_ladder" );
	flag_init( "graveyard_hind_ready" );
	flag_init( "graveyard_price_at_wall" );
	flag_init( "graveyard_get_down" );
	flag_init( "graveyard_hind_gone" );
	flag_init( "graveyard_hind_down" );
	flag_init( "graveyard_hind_flare" );
	
	flag_init( "field" );		
	flag_init( "field_getdown" );
	flag_init( "field_spawn" );
	flag_init( "field_start" );
	flag_init( "field_price_done" );
		
	//flag_init( "pond"); trigger flag in radient
	flag_init( "pond_enemies_dead" );
	flag_init( "pond_patrol_spawned" );
	flag_init( "pond_thrower_spawned" );
	flag_init( "pond_patrol_dead" );
	flag_init( "pond_thrower_dead" );
	flag_init( "pond_thrower_kill" );
	
	//flag_init( "cargo" ); trigger flag in radient
	flag_init( "cargo_enemy_ready_to_defend1" );
	flag_init( "cargo_enemy_defend_moment_past" );
	flag_init( "cargo_started_defend_moment" );
	flag_init( "cargo_patrol_defend1_dead" );
	flag_init( "cargo_patrol_defend2_dead" );
	flag_init( "cargo_defender1_away" );
	flag_init( "cargo_defender2_away" );
	flag_init( "cargo_patrol_away" );
	flag_init( "cargo_patrol_danger" );
	flag_init( "cargo_patrol_dead" );
	flag_init( "cargo_enemies_dead" );;
	flag_init( "cargo_price_ready_to_kill_patroller" );
	
	flag_init( "dash" );
	flag_init( "dash_start" );
	flag_init( "dash_last" );
	flag_init( "dash_guard_check1" );
	flag_init( "dash_guard_check2" );
	flag_init( "dash_guard_check3" );
	flag_init( "dash_sniper" );
	flag_init( "dash_sniper_dead" );
	flag_init( "dash_stealth_unsure" );
	
	flag_init( "town" );
	//flag_init( "town_no_turning_back" );
	
	flag_init( "dogs" );
	flag_init( "dogs_dog_dead" );
	flag_init( "dogs_backup" );
	flag_init( "dogs_delete_dogs" );
	
	flag_init( "center" );
	
	flag_init( "end" );
		
	//starts
	default_start( ::start_intro );
	add_start( "church", ::start_church );
	add_start( "church_x", ::start_church_x );
	add_start( "graveyard", ::start_graveyard );
	add_start( "graveyard_x", ::start_graveyard_x );
	add_start( "field", ::start_field );
	add_start( "pond", ::start_pond );
	add_start( "cargo", ::start_cargo );
	add_start( "dash", ::start_dash );
	add_start( "town", ::start_town );
	add_start( "dogs", ::start_dogs );
	add_start( "center", ::start_center );
	add_start( "end", ::start_end );
	
	setsaveddvar("ai_friendlyFireBlockDuration", 0);
	
	//globals
	maps\createart\scoutsniper_art::main();
	maps\_hind::main( "vehicle_mi24p_hind_woodland" );
	maps\_t72::main( "vehicle_t72_tank_woodland" );
	maps\_bm21_troops::main( "vehicle_bm21_mobile_cover" );
	maps\_bm21_troops::main( "vehicle_bm21_mobile_bed" );
	maps\_uaz::main( "vehicle_uaz_light_destructible" );
	maps\_uaz::main( "vehicle_uaz_fabric_destructible" );
	maps\_bmp::main( "vehicle_bmp_woodland" );
	
	level.weaponClipModels = [];
	level.weaponClipModels[0] = "weapon_m14_clip";
	level.weaponClipModels[1] = "weapon_ak47_clip";
	level.weaponClipModels[2] = "weapon_g36_clip";
	level.weaponClipModels[3] = "weapon_dragunov_clip";
	level.weaponClipModels[4] = "weapon_g3_clip";
	
	maps\scoutsniper_fx::main();
	maps\_load::main();
	maps\scoutsniper_anim::main();
	maps\_stealth_logic::stealth_init();
	maps\_stealth_behavior::main();
	maps\_load::set_player_viewhand_model( "viewhands_player_marines" );//viewhands_marine_sniper
	animscripts\dog_init::initDogAnimations();
	maps\_stinger::init();
	maps\_compass::setupMiniMap( "compass_map_scoutsniper" );
	
	thread maps\scoutsniper_amb::main();

	//start everything after the first frame so that level.start_point can be
	//initialized - this is a bad way of doing things...if people are initilizing
	//things before they want their start to start, then they should wait on a flag
	waittillframeend;
	
	//these are the actual functions that progress the level
	thread objective_main();	
		
	switch( level.start_point )
	{
		case "default":		intro_main();
		case "church":	
		case "church_x":	church_main();
		case "graveyard":
		case "graveyard_x":	graveyard_main();
		case "field":		thread field_main();
		case "pond":		pond_main();
		case "cargo":		thread cargo_main();
		case "dash":		dash_main();
		case "town":		thread town_main();
		case "dogs":		dogs_main();
		case "center":		center_main();
		case "end":		end_main();
	}
}

/************************************************************************************************************/
/*													INTRO													*/
/************************************************************************************************************/

intro_main()
{
	flag_wait( "initial_setup_done" );
	level.player disableweapons();
	delaythread(12.5, ::giveweapons);
	delaythread(1, ::music_play, "scoutsniper_pripyat_music" );
	
	flag_set( "intro" );
	
	reference = getent( "price_start_node", "targetname" );
	reference thread anim_first_frame_solo( level.price, "scoutsniper_opening_price" );
	
	array_thread( getentarray( "patrollers", "script_noteworthy" ), ::add_spawn_function, ::stealth_ai );
	array_thread( getentarray( "tableguards", "script_noteworthy" ), ::add_spawn_function, ::stealth_ai );
	array_thread( getentarray( "tableguards", "script_noteworthy" ), ::add_spawn_function, ::idle_anim_think );
	array_thread( getentarray( "tableguard_last_patrol", "targetname" ), ::add_spawn_function, ::intro_lastguy_think );
	
	delaythread(1, ::set_blur, 4.8, .25 );
	delaythread(4, ::set_blur, 0, 3 );
	
	thread intro_handle_leave_area_flag();
	thread intro_handle_safezone_flag();
	thread intro_handle_last_patrol_clip();
	thread intro_handle_leave_area_clip();
	thread intro_handle_spotted_dialogue();
		
	delaythread( randomfloatrange( 3, 7 ), ::scripted_array_spawn, "patrollers", "script_noteworthy", true );
	delaythread( 1, ::scripted_array_spawn, "tableguards", "script_noteworthy", true );
	delaythread( 1, ::scripted_array_spawn, "intro_dogs", "script_noteworthy", true );
	
	wait 9;
	
	level thread function_stack(::radio_dialogue, "scoutsniper_mcm_radiation" );
	level delaythread( 5, ::function_stack, ::radio_dialogue, "scoutsniper_mcm_followme" );

	wait 1;
	
	autosave_by_name( "intro" );
	
	level.price.keepNodeDuringScriptedAnim = true;
		
	level.price intro_runup( reference );
	level.price notify( "stop_dynamic_run_speed" );
	level.price intro_holdup();
	
	if( !flag( "_stealth_spotted" ) )
		autosave_by_name( "intro_shack" );
		
	level.price intro_cqb_into_shack();
	level.price ent_flag_set( "_stealth_stance_handler" );
	level.price intro_sneakup_patrollers();
	level.price ent_flag_clear( "_stealth_stance_handler" );
	
	if( !flag( "_stealth_spotted" ) )
		autosave_by_name( "intro_patrollers_killed" );
	
	level.price notify( "stop_path" );
	
	level.price intro_sneakup_tableguys();
	level.price intro_avoid_tableguys();
	level.price allowedstances( "stand", "crouch", "prone" );
	level.price intro_leave_area();
	if( !flag( "_stealth_spotted" ) )
		autosave_by_name( "intro_last_patroller_killed" );
	level.price thread intro_cleanup();
}

intro_handle_spotted_dialogue()
{
	level endon ( "intro_left_area" );
	flag_wait( "_stealth_spotted" );
	
	level function_stack(::radio_dialogue, "scoutsniper_mcm_spotted" );
	
	wait 2;
	
	level function_stack(::radio_dialogue, "scoutsniper_mcm_dogsingrass" );
}

intro_handle_leave_area_clip()
{
	clip = getent("intro_leave_area_clip", "targetname");
	
	clip thread intro_handle_leave_area_clip_spotted();
	
	clip endon("death");
	level endon( "_stealth_spotted" );
	level endon( "church_intro" );
	
	while(1)
	{
		flag_waitopen( "intro_safezone" );
		clip geo_off();
		
		flag_wait( "intro_safezone" );
		clip geo_on();
	}
	
}

intro_handle_leave_area_clip_spotted()
{
	flag_wait_either( "_stealth_spotted", "church_intro" );
	
	self delete();
}

intro_handle_last_patrol_clip()
{		
	clip = getent("intro_last_patrol_clip", "targetname");		
	clip connectpaths();
	clip geo_off();
	
	level endon( "_stealth_spotted" );
	
	flag_wait( "intro_last_patrol" );
	clip thread intro_handle_last_patrol_clip_spotted();
	
	clip geo_on();
	clip disconnectpaths();
}

intro_handle_last_patrol_clip_spotted()
{
	flag_wait( "_stealth_spotted" );
	
	self connectpaths();
	self delete();
}

intro_handle_leave_area_flag()
{
	level endon( "_stealth_spotted" );
	level endon( "intro_last_patrol_dead" );
	level endon( "intro_left_area" );
	
	trig = getent( "intro_leave_area", "script_noteworthy" );
	
	trig trigger_off();
	
	flag_wait( "intro_last_patrol" );
	
	level.intro_last_patrol waittill("goal");

	trig trigger_on();
	
	while(1)
	{
		trig waittill("trigger", other);
		
		if( other == level.intro_last_patrol )
			break;
	}
	
	flag_set( "intro_leave_area" );
}

intro_handle_safezone_flag()
{
	level endon( "_stealth_spotted" );
	level endon( "church_intro" );
	
	safezone = getent("intro_leave_area_safe_zone", "targetname");
	
	while(1)
	{
		safe = true;
		ai = getaiarray("axis");
		for(i=0; i<ai.size; i++)
		{
			if( !( ai[i] istouching( safezone ) ) )
				continue;	
			
			safe = false;
			break;
		}
		
		if(safe)
		{
			if ( !flag( "intro_safezone" ) )
				flag_set( "intro_safezone" );
		}	
		else if( flag( "intro_safezone" ) )
			flag_clear( "intro_safezone" );
			
		wait .1;	
	}
}

intro_runup( ref )
{	
	if( flag("_stealth_spotted") )
		return;
	level endon("_stealth_spotted");
		
	self allowedstances( "stand" );
	ref thread anim_single_solo( self, "scoutsniper_opening_price" );	
		
	//price moves to a stopping point
	node = getent( "price_intro_path", "targetname" );
		
	length = getanimlength( self getanim("scoutsniper_opening_price") );
	wait length - .2;
	self stopanimscripted();
	
	level delaythread( 2, ::function_stack, ::radio_dialogue, "scoutsniper_mcm_deadman" );
	
	self delaythread( .1, ::dynamic_run_speed );
	self follow_path( node );
}

intro_holdup()
{
	if( flag("_stealth_spotted") )
		return;
	level endon("_stealth_spotted");
	
	node = getnode("price_intro_holdup","targetname");
	
	node anim_generic_reach_and_arrive( self, "stop2_exposed" );
	
	level thread function_stack(::radio_dialogue, "scoutsniper_mcm_standby" );
	
	node thread anim_generic( self, "stop2_exposed" );
	node waittill("stop2_exposed");
}

intro_cqb_into_shack()
{
	if( flag("_stealth_spotted") )
		return;
	level endon("_stealth_spotted");
	
	self pushplayer( true );
	
	self enable_cqbwalk();
	node = getnode("price_intro_holdup2","targetname");
	
	//node anim_generic_reach_and_arrive( self, "enemy_exposed" );
	
	self setgoalnode( node );
	self.goalradius = 4;
	self waittill( "goal" );
	
	level thread function_stack(::radio_dialogue, "scoutsniper_mcm_deadahead" );
			
	node thread anim_generic( self, "enemy_exposed" );
	node waittill("enemy_exposed");
	
	level thread function_stack(::radio_dialogue, "scoutsniper_mcm_staylow" );
		
	node thread anim_generic( self, "down_exposed" );
	node waittill("down_exposed");
	
	self pushplayer( false );
}

intro_sneakup_patrollers()
{
	if( flag("_stealth_spotted") )
		return;
	level endon("_stealth_spotted");
		
	self thread intro_sneakup_patrollers_kill();
	self thread intro_sneakup_patrollers_death();
	self disable_cqbwalk();
	self.disablearrivals = true;
	self.disableexits = true;
	
	level endon( "intro_patrol_guys_dead" );
	
	node = getnode("price_intro_sneakup", "targetname");
	self thread follow_path( node );
	
	wait 10;
	if( !flag( "intro_patrol_guy_down" ) )
		level thread function_stack(::radio_dialogue, "scoutsniper_mcm_notlooking" );
		
	flag_wait( "intro_patrol_guys_dead" );
}
intro_sneakup_patrollers_death()
{	
	if( flag("_stealth_spotted") )
		return;
	level endon("_stealth_spotted");
	
	flag_wait( "intro_patrol_guy_down" );
	
	level thread function_stack(::radio_dialogue, "scoutsniper_mcm_hesdown" );
		
	ai = get_living_ai_array("patrollers", "script_noteworthy");
	waittill_dead( ai );
	
	flag_set( "intro_patrol_guys_dead" );
	level thread function_stack(::radio_dialogue, "scoutsniper_mcm_goodnight" );
}

intro_sneakup_patrollers_kill()
{
	if( flag( "_stealth_spotted" ) )
		return;
	level endon( "_stealth_spotted" );
	
	ai = get_living_ai_array( "patrollers", "script_noteworthy" );
	
	if( ai.size > 1 )
		waittill_dead(ai, 1);
	flag_set( "intro_patrol_guy_down" );
	
	level endon( "intro_patrol_guys_dead" );
	
	wait .5;
	
	while( self ent_flag( "_stealth_stay_still" ) )
		self waittill( "_stealth_stay_still" );
	
	enemy = get_living_ai("patrollers", "script_noteworthy");
	
	enemy endon("death");
	
	wait randomfloatrange( .75, 1.25 );
	
	MagicBullet( self.weapon, self gettagorigin( "tag_flash" ), enemy getShootAtPos() );
	wait .05;
	enemy dodamage( enemy.health + 100, self.origin );
}

intro_sneakup_tableguys()
{
	if( flag("_stealth_spotted") )
		return;
	level endon("_stealth_spotted");
	
	if( flag("intro_last_patrol") )
		return;
	level endon("intro_last_patrol");
			
	self.favoriteenemy  = undefined;
	self.ignoreall = true;
	self.disablearrivals = false;
	self.disableexits = false;
	self allowedstances( "stand" );	

	level thread function_stack(::radio_dialogue, "scoutsniper_mcm_move" );
	
	node = getnode("price_intro_tableguys_node1", "targetname");
	
	vec = vectornormalize(node.origin - self.origin);
	self maps\_stealth_behavior::friendly_spotted_getup_from_prone( vectortoangles( vec ) );
	
	self delaythread( .25, ::dynamic_run_speed );
	node anim_generic_reach_and_arrive( self, "stop_cornerR" );
	
	self notify( "stop_dynamic_run_speed" );
	
	level thread function_stack(::radio_dialogue, "scoutsniper_mcm_holdup" );	
	self.ref_node.origin = node.origin;
	self.ref_node.angles = node.angles + (0,-90,0);
	self.ref_node thread anim_generic( self, "stop_cornerR" );
	self.ref_node waittill("stop_cornerR");
	
	level thread function_stack(::radio_dialogue, "scoutsniper_mcm_goaround" );	
	self.ref_node thread anim_generic( self, "onme_cornerR" );
	self.ref_node waittill("onme_cornerR");
	
	node = getnode("price_intro_tableguys_node2", "targetname");
	self set_goal_node(node);
	self.goalradius = node.radius;
	self waittill("goal");
	
	//self allowedstances( "crouch" );//took this out so he would arrive at window
	
	node = getnode("price_intro_tableguys_node3", "targetname");
	self.ref_node.origin = node.origin;
	self.ref_node.angles = node.angles + (0,-90,0);
	
	//node anim_generic_reach_and_arrive( self, "enemy_cornerR" );
	self setgoalnode( node );
	self.goalradius = 4;
	self waittill( "goal" );
	
	level thread function_stack(::radio_dialogue, "scoutsniper_mcm_4tangos" );
	self.ref_node thread anim_generic( self, "enemy_cornerR" );
	
	self setgoalpos( self.origin );
	self.goalradius = 4;
	
//	self.ref_node waittill( "enemy_cornerR" )
	level function_stack(::radio_dialogue, "scoutsniper_mcm_donteven" );
}

intro_avoid_tableguys()
{
	if( flag("_stealth_spotted") )
		return;
	level endon("_stealth_spotted");
	
	if( flag("intro_last_patrol_dead") )
		return;
	level endon("intro_last_patrol_dead");
	
	self allowedstances( "stand" );
	self.disablearrivals = false;
	self.disableexits = false;
			
	node = getnode("price_intro_tableguys_node4", "targetname");
	self.ref_node.origin = node.origin;
	self.ref_node.angles = node.angles + (0,-90,0);
	
	self.ref_node anim_generic_reach_and_arrive( self, "stop_cornerR" );
	
	level thread function_stack(::radio_dialogue, "scoutsniper_mcm_tangobycar" ); 
	self.ref_node thread anim_generic( self, "stop_cornerR" );
	self.ref_node waittill( "stop_cornerR" );
	
	self.ref_node thread anim_generic( self, "enemy_cornerR" );
	self.ref_node waittill( "enemy_cornerR" );
	
	self.goalradius = 4;
	
	wait 2;
	level thread function_stack(::radio_dialogue, "scoutsniper_mcm_yourcall" ); 
}

intro_leave_area()
{
	if( flag("_stealth_spotted") )
		return;
	level endon("_stealth_spotted");
	
	flag_wait_either( "intro_leave_area", "intro_last_patrol_dead" );
	
	if( flag( "intro_leave_area" ) && !flag( "intro_last_patrol_dead" ) )
		level function_stack(::radio_dialogue, "scoutsniper_mcm_backinside" );
	
	node = getnode("price_intro_tableguys_node4", "targetname");
	self.ref_node.origin = node.origin;
	self.ref_node.angles = node.angles + (0,-90,0);
	
	self.ref_node anim_generic_reach_and_arrive( self, "stop_cornerR" );
	
	level thread function_stack(::radio_dialogue, "scoutsniper_mcm_okgo" );
	wait .75;
	
	self.ref_node thread anim_generic( self, "moveout_cornerR" );
	self.ref_node waittill( "moveout_cornerR" );
	
	node = getnode("price_intro_leave_node", "targetname");
	self thread follow_path( node );
	self thread intro_leave_area_dialogue();
}

intro_leave_area_dialogue()
{
	if( flag("_stealth_spotted") )
		return;
	level endon("_stealth_spotted");
	
	//first node
	self waittill("goal");
	//by barn
	self waittill("goal");
	//by car
	self waittill("goal");
	wait 1;
	level function_stack(::radio_dialogue, "scoutsniper_mcm_moveup" );
}

intro_lastguy_think()
{	
	level.intro_last_patrol = self;
		
	self thread intro_lastguy_death();
	self endon("death");
	
	flag_wait_either( "intro_last_patrol", "_stealth_spotted" );
	
	if( !flag( "_stealth_spotted") )
	{	
		self stealth_ai_clear_custom_idle_and_react();	
						
		self.target = "intro_last_patrol_smoke";
		self thread maps\_patrol::patrol();
	}
}

intro_lastguy_death()
{
	level.intro_last_patroller_corpse_name = "corpse_" + self.ai_number;
	
	self waittill("death");
	
	flag_set("intro_last_patrol_dead");
}

intro_cleanup()
{
	self thread intro_cleanup2();
	
	if( flag("_stealth_spotted") )
		return;
	level endon("_stealth_spotted");
	
	self waittill( "path_end_reached" );
	flag_set( "intro_left_area" );
}

intro_cleanup2()
{
	level endon( "intro_left_area" );
	
	flag_wait("_stealth_spotted");
	self notify("stop_path");
	waittill_dead_or_dying( getaispeciesarray( "axis", "all" ) );
	
	flag_waitopen( "_stealth_spotted" );
	
	flag_set( "intro_left_area" );
}

/************************************************************************************************************/
/*													CHURCH													*/
/************************************************************************************************************/
church_main()
{
	trigger_off( "church_intro", "script_noteworthy" );
	
	flag_wait( "initial_setup_done" );
	flag_wait( "intro_left_area" );
	
	trigger_on( "church_intro", "script_noteworthy" );
	
	thread church_patroller();
	thread church_lookout();
	thread church_corpse_or_aware_dialogue();
	thread church_handle_spotted_dialogue();
	
	level.price church_runup();
	flag_wait( "church_intro" );
	level.price church_runup2();
	
	if( !flag( "_stealth_spotted" ) )
		autosave_by_name( "at_church" );
	level.price notify( "stop_dynamic_run_speed" );
	
	level.price church_holdup();
	level.price ent_flag_set( "_stealth_stance_handler" );
	level.price church_sneakup();
	level.price church_moveup_car();
	level.price church_run_for_it();
	
	level.price ent_flag_clear( "_stealth_stance_handler" );
	level.price allowedstances( "stand", "crouch", "prone" );
	
	thread church_handle_area_killed();
	if( flag("_stealth_spotted") )
		waittill_dead_or_dying( getaiarray( "axis" ) );
	
	flag_waitopen( "church_run_for_it_commit" );
		
	while( !flag( "church_door_open" ) )
		level.price church_open_door();
	
	level.price thread church_walkthrough();
}

church_handle_spotted_dialogue()
{
	level endon ( "graveyard_moveup" );
	flag_wait( "_stealth_spotted" );
	
	level function_stack(::radio_dialogue, "scoutsniper_mcm_spotted" );
}

church_corpse_or_aware_dialogue()
{
	level endon( "church_door_open" );
	
	if( flag("_stealth_spotted") )
		return;
	level endon("_stealth_spotted");	
	
	if( flag("church_area_clear") )
		return;
	level endon("church_area_clear");
	
	if( !flag( "_stealth_found_corpse" ) )
		level waittill_either( "event_awareness", "_stealth_found_corpse" );
	if( !flag( "_stealth_found_corpse" ) )
		flag_set( "church_awareness" );
		
	wait 2;
	
	//check to see if the only one alive is the lookout
	ai = getaiarray( "axis" );
	if( ai.size < 2 && ai[ 0 ].script_noteworthy == "church_lookout" )
	{
		level function_stack(::radio_dialogue, "scoutsniper_mcm_nooneleft" );
		return;
	}
	
	level function_stack(::radio_dialogue, "scoutsniper_mcm_stayhidden" );
	
	if( !flag( "_stealth_found_corpse" ) )
		return;
	level endon( "_stealth_found_corpse" );
	
	wait 5;
	
	level function_stack(::radio_dialogue, "scoutsniper_mcm_shhh" );
}

church_handle_area_killed()
{
	getaiarray( "axis" );
	waittill_dead_or_dying( getaiarray( "axis" ) );
	flag_set( "church_and_intro_killed" );	
}

church_runup()
{	
	if( flag("_stealth_spotted") )
		return;
	level endon("_stealth_spotted");
		
	self allowedstances( "stand", "crouch", "prone" );
			
	node = getnode( "church_price_node1", "targetname" );	
	
	ai = getaiarray( "axis" );
	if( ( !isdefined( ai ) || ai.size == 0 ) && level.start_point != "church_x" )
	{
		level thread function_stack(::radio_dialogue, "scoutsniper_mcm_getuskilled" );
		self delaythread( .1, ::dynamic_run_speed );
	}
	else if( distance( node.origin, self.origin ) > 512 )
	{
		level thread function_stack(::radio_dialogue, "scoutsniper_mcm_letsgo" );
		self delaythread( .1, ::dynamic_run_speed );
	}	
	
	self follow_path( node );
}

church_runup2()
{
	if( flag("_stealth_spotted") )
		return;
	level endon("_stealth_spotted");
	
	if( flag("church_run_for_it") )
		return;
	level endon( "church_run_for_it" );
	
	level endon( "event_awareness" );
	
	self allowedstances( "stand", "crouch", "prone" );
	
	/*
	node = getnode( "church_price_node1", "targetname" );
	self.ref_node.origin = node.origin;
	self.ref_node.angles = node.angles + (0,-90,0);
		
	level thread function_stack(::radio_dialogue, "scoutsniper_mcm_move" );
	self.ref_node thread anim_generic( self, "moveout_cornerR" );
	self.ref_node waittill( "moveout_cornerR" );	
	*/
	
	node = getnode( "church_price_node2", "targetname" );	
	self follow_path( node );
}

church_holdup()
{
	if( flag("_stealth_spotted") )
		return;
	level endon("_stealth_spotted");
	
	if( flag("church_area_clear") )
		return;
	level endon("church_area_clear");
	
	if( flag("_stealth_found_corpse") )
		return;
	level endon("_stealth_found_corpse");
	
	if( flag("church_run_for_it") )
		return;
	level endon( "church_run_for_it" );
	
	level endon( "event_awareness" );
	
	node = getnode( "church_price_node2", "targetname" );	
	node anim_generic_reach_and_arrive( self, "stop_exposed" );
	
	thread church_holdup_dialogue( node );
	
	node thread anim_generic( self, "stop_exposed" );
	node waittill("stop_exposed");
	
	flag_wait_either( "church_start_patroller_line", "church_patroller_dead" );
	
	if( !flag( "church_patroller_dead" ) )
	{
		node thread anim_generic( self, "enemy_exposed" );
		node waittill("enemy_exposed");
	}
	
	node thread anim_generic( self, "onme2_exposed" );
	node waittill("onme2_exposed");
}

church_holdup_dialogue( node )
{
	if( flag("_stealth_spotted") )
		return;
	level endon("_stealth_spotted");
	
	if( flag("church_area_clear") )
		return;
	level endon("church_area_clear");
	
	if( flag("_stealth_found_corpse") )
		return;
	level endon("_stealth_found_corpse");
	
	if( flag("church_run_for_it") )
		return;
	level endon( "church_run_for_it" );
	
	level endon( "event_awareness" );
		
	if( ! ( flag( "church_patroller_dead" ) && flag( "church_lookout_dead" ) ) )
		level function_stack(::radio_dialogue, "scoutsniper_mcm_dontmove" );
		
	node waittill("stop_exposed");
	if( !flag( "church_lookout_dead" ) )
	{
		if( flag( "church_patroller_dead" ) )
			level function_stack(::radio_dialogue, "scoutsniper_mcm_inthetower" );
		else
			level function_stack(::radio_dialogue, "scoutsniper_mcm_churchtower" );
		if( !flag( "church_patroller_dead" ) )
		{
			flag_set( "church_start_patroller_line" );
			
			if( flag( "church_lookout_dead" ) )
				level thread function_stack(::radio_dialogue, "scoutsniper_mcm_niceshot" );
			else
				level thread function_stack(::radio_dialogue, "scoutsniper_mcm_patrolnorth" );
		}
	}
	else if( !flag( "church_patroller_dead" ) )
	{
		flag_set( "church_start_patroller_line" );
		level thread function_stack(::radio_dialogue, "scoutsniper_mcm_niceshot" );
	}	
	
	node waittill("enemy_exposed");
	
	if( !flag( "church_patroller_dead" ) )
		level function_stack(::radio_dialogue, "scoutsniper_mcm_betterview" );
	
	flag_set( "church_dialogue_done" );
}

church_sneakup()
{
	if( flag("_stealth_spotted") )
		return;
	level endon("_stealth_spotted");
	
	if( flag("church_area_clear") )
		return;
	level endon( "church_area_clear" );
			
	node = getnode( "church_price_sneakup", "targetname" );
	self thread follow_path( node );
		
	if( flag("church_run_for_it") )
		return;
	level endon( "church_run_for_it" );
	
	self waittill( "path_end_reached" );
	
	thread church_sneakup_dialogue_nag();
	thread church_sneakup_dialogue_nag2();
	
	flag_wait( "church_patroller_faraway" );
	flag_set( "church_run_for_it" );
}

church_sneakup_dialogue_nag()
{
	if( flag("_stealth_spotted") )
		return;
	level endon("_stealth_spotted");
	
	if( flag("church_area_clear") )
		return;
	level endon( "church_area_clear" );
	
	if( flag("church_run_for_it") )
		return;
	level endon( "church_run_for_it" );
	
	if( flag("church_lookout_dead") )
		return;
	level endon( "church_lookout_dead" );
	
	if( flag("church_patroller_dead") )
		return;
	level endon( "church_patroller_dead" );
		
	msg_num = 0; 
	msg = [];
	msg[ 0 ] = "scoutsniper_mcm_haveashot";
	msg[ 1 ] = "scoutsniper_mcm_inthetower";
	
	level function_stack(::radio_dialogue, msg[ msg_num ] );
	msg_num++;
	thread church_sneakup_dialogue_help();
	
	while( !flag( "church_lookout_dead" ) )
	{		
		level waittill_notify_or_timeout( "church_sneakup_dialogue_help", 10 );
		if( flag( "church_sneakup_dialogue_help" ) )
		{
			flag_waitopen( "church_sneakup_dialogue_help" );
			continue;
		}
		level function_stack(::radio_dialogue, msg[ msg_num ] );
		
		msg_num++;
		if( msg_num >= msg.size )
			msg_num = 0;
	}
}

church_sneakup_dialogue_help()
{
	if( flag("_stealth_spotted") )
		return;
	level endon("_stealth_spotted");
	
	if( flag("church_area_clear") )
		return;
	level endon( "church_area_clear" );
	
	if( flag("church_run_for_it") )
		return;
	level endon( "church_run_for_it" );
	
	if( flag("church_lookout_dead") )
		return;
	level endon( "church_lookout_dead" );
	
	if( flag("church_patroller_dead") )
		return;
	level endon( "church_patroller_dead" );

	node = getstruct( "church_wrong_tower", "targetname" );

	while( !flag( "church_lookout_dead" ) )
	{		
		while( level.player PlayerAds() < 0.85 )
			wait .05;
		
		while( level.player PlayerAds() > 0.85 )
		{
			vec1 = anglestoforward( level.player getplayerangles() );
			vec2 = vectornormalize( node.origin - level.player.origin );
			if( vectordot( vec1, vec2 ) > .996 )
				break;
			
			wait .05;
		}	
		
		if( level.player PlayerAds() > 0.85 )
		{
			flag_set( "church_sneakup_dialogue_help" );
			level function_stack(::radio_dialogue, "scoutsniper_mcm_wrongtower" );
			flag_clear( "church_sneakup_dialogue_help" );
			wait 5;
		}	
	}		
}

church_sneakup_dialogue_nag2()
{
	if( flag("_stealth_spotted") )
		return;
	level endon("_stealth_spotted");
	
	if( flag("church_area_clear") )
		return;
	level endon( "church_area_clear" );
	
	if( flag("church_run_for_it") )
		return;
	level endon( "church_run_for_it" );
	
	if( flag("church_patroller_dead") )
		return;
	level endon( "church_patroller_dead" );
	
	flag_wait( "church_lookout_dead" );	
	
	wait .5;
	level function_stack(::radio_dialogue, "scoutsniper_mcm_targetnorth" );
	level function_stack(::radio_dialogue, "scoutsniper_mcm_yourcall" );
}


church_moveup_car()
{
	if( flag("_stealth_spotted") )
		return;
	level endon("_stealth_spotted");
	
	if( flag( "church_run_for_it" ) )
		return;
	
	//if( flag( "church_awareness" ) )
	//	wait 10;
	
	flag_waitopen( "_stealth_found_corpse" );	
	
	level thread function_stack(::radio_dialogue, "scoutsniper_mcm_go" );
	
	node = getnode( "church_price_node_car", "targetname" );
	
	vec = vectornormalize(node.origin - self.origin);
	self ent_flag_clear( "_stealth_stance_handler" );
	self maps\_stealth_behavior::friendly_spotted_getup_from_prone( vectortoangles( vec ) );
	
	self follow_path( node );
	level thread function_stack(::radio_dialogue, "scoutsniper_mcm_forwardclear" );
}

church_run_for_it()
{
	if( !flag( "church_run_for_it" ) )
		return;
	
	if( flag("_stealth_spotted") )
		return;
	level endon("_stealth_spotted");
	
	if( flag( "church_lookout_dead" ) )
		return;
	level endon("church_lookout_dead");
	
	self thread church_run_for_it_dead_dialogue();
	
	if( flag("church_guess_he_cant_see") )
	{
		level function_stack(::radio_dialogue, "scoutsniper_mcm_closeone" );
		// it sounds weird to be releaved and immediately tell the player 
		// to be ready to move, so we wait a second
		wait .65;
	}	
	else if( flag( "church_patroller_faraway" ) && !flag( "church_patroller_dead" ) )
		level function_stack(::radio_dialogue, "scoutsniper_mcm_ourchance" );
	
	self ent_flag_clear( "_stealth_stance_handler" );
	wait .05;
	waittillframeend;
	self allowedstances( "prone" );
	
	level function_stack(::radio_dialogue, "scoutsniper_mcm_turnaround" );
	
	angles = (0,45,0);
	vec1 = anglestoforward( angles );
	guy = get_living_ai("church_lookout", "script_noteworthy");
	
	vec2 = anglestoforward( guy.angles );
		
	while( isalive( guy ) )
	{
		vec2 = anglestoforward( guy.angles );
		if( vectordot( vec1, vec2 ) > .9 )
			break;
		wait .05;
	}
	
	self thread church_run_for_it_commit();
	self waittill( "path_end_reached" );
}
	
church_run_for_it_commit()
{
	flag_set( "church_run_for_it_commit" );
	
	self allowedstances( "crouch", "stand", "prone" );
	self pushplayer( true );
	self set_generic_run_anim( "sprint" );
	level thread function_stack(::radio_dialogue, "scoutsniper_mcm_readygo" );
	self notify( "scoutsniper_mcm_readygo" );
	node = getnode( "church_price_runforit", "targetname" );
		
	vec = vectornormalize(node.origin - self.origin);
	self maps\_stealth_behavior::friendly_spotted_getup_from_prone( vectortoangles( vec ) );
	
	self thread follow_path( node );
	
	self waittill( "path_end_reached" );
	
	self pushplayer( false );
	self clear_run_anim();
	
	flag_clear( "church_run_for_it_commit" );
}

church_run_for_it_dead_dialogue()
{
	self endon( "scoutsniper_mcm_readygo" );
	
	flag_wait( "church_lookout_dead" );
	
	level thread function_stack(::radio_dialogue, "scoutsniper_mcm_onme" );
}

church_lookout()
{
	spawner = getent( "church_lookout", "script_noteworthy" );
	
	corpse_array = [];
	corpse_array[ "saw" ] 	= ::church_lookout_stealth_behavior_saw_corpse;
	corpse_array[ "found" ] = ::church_lookout_stealth_behavior_found_corpse;
	
	alert_array = [];
	alert_array[ "alerted_once" ] = ::church_lookout_stealth_behavior_alert_level_investigate;
	alert_array[ "alerted_again" ] = ::church_lookout_stealth_behavior_alert_level_attack;
	alert_array[ "attack" ] = ::church_lookout_stealth_behavior_alert_level_attack;
	
	awareness_array = [];
	awareness_array[ "explode" ] = ::church_lookout_stealth_behavior_explosion;
		
	spawner thread add_spawn_function( ::stealth_ai, undefined, alert_array, corpse_array, awareness_array );
	spawner thread add_spawn_function( ::church_lookout_death );
	
	flag_wait( "church_intro" );

	scripted_array_spawn( "church_lookout", "script_noteworthy", true );
	
	waittillframeend;
	guy = get_living_ai( "church_lookout", "script_noteworthy" );
	
	guy endon( "death" );
	
	flag_wait( "church_ladder_slide" );
	
	guy thread church_lookout_cleanup();
	wait 1;
	
	guy.ignoreall = true;
	guy.allowdeath = true;
		
	guy setgoalpos( (-35002, -917, 247.3) );
	guy.goalradius = 1024;
		
	guy maps\_stealth_behavior::ai_change_behavior_function( "alert", "alerted_once", ::church_lookout_stealth_behavior_alert_level_attack );
			
	node = getent( "church_ladder_slide_node", "targetname" );
	node anim_generic( guy, "ladder_slide" );
	
	level.price.ignoreme = false;	
	level.price.ignoreall = false;
	
	guy.ignoreall = false;
}

church_lookout_cleanup()
{
	self waittill( "death" );
	
	level.price.ignoreme = true;	
	level.price.ignoreall = true;
}

church_lookout_wait()
{
	self endon( "_stealth_running_to_corpse" );
	self endon( "_stealth_saw_corpse" );
	self endon( "_stealth_found_corpse" );
	level endon( "_stealth_found_corpse" );
	level endon( "_stealth_spotted" );
	
	self waittill( "enemy_alert_level_change" );
}

church_lookout_death()
{
	self waittill( "death" );
	
	check1 = ( !flag("_stealth_spotted") && flag( "church_dialogue_done" ) );
	check2 = ( !flag("_stealth_spotted") && flag( "church_door_open" ) );
	if( check1 || check2 )
		level thread function_stack(::radio_dialogue, "scoutsniper_mcm_beautiful" );
	
	flag_set( "church_lookout_dead" );
	if( flag( "church_patroller_dead" ) )
		flag_set( "church_area_clear" );	
}

church_patroller()
{
	spawner = getent( "church_smoker", "script_noteworthy" );
	spawner thread add_spawn_function( ::stealth_ai );
	spawner thread add_spawn_function( ::church_patroller_death );
	spawner thread add_spawn_function( ::church_patroller_faraway_trig );
	
	flag_wait( "church_intro" );

	thread scripted_array_spawn( "church_smoker", "script_noteworthy", true );
}

church_patroller_faraway_trig()
{
	self endon( "death" );
	
	if( flag("_stealth_spotted") )
		return;
	level endon("_stealth_spotted");
	
	trig = getent("church_patrol_faraway_trig", "targetname" );	
	
	while( 1 )
	{
		trig waittill( "trigger", other );
		if( other == self )
			break;
	}
	
	flag_set( "church_patroller_faraway" );
}

church_patroller_death()
{	
	self waittill( "death" );
		
	origin = self.origin;
	
	if( !flag("_stealth_spotted") && flag( "church_dialogue_done" ) && flag( "church_lookout_dead" ) )
		level thread function_stack(::radio_dialogue, "scoutsniper_mcm_tangodown" );
	
	flag_set( "church_patroller_dead" );
	if( flag( "church_lookout_dead" ) )
		flag_set( "church_area_clear" );
	else
	{
		lookout = get_living_ai( "church_lookout" , "script_noteworthy" );
		if( distance( origin, lookout.origin ) > ( level._stealth.logic.corpse.sight_dist + 150 ) && !flag("_stealth_spotted") )
	 		flag_set( "church_run_for_it" );
	 	else
	 	{
	 		level thread function_stack(::radio_dialogue, "scoutsniper_mcm_seethebody" );
	 		
	 		wait 12;
	 		if( !flag( "_stealth_spotted" ) && !flag( "_stealth_found_corpse" ) )
	 		{
		 		flag_set( "church_run_for_it" );
		 		flag_set( "church_guess_he_cant_see" );
		 	}
	 	}
	}
}

church_open_door()
{
	if( flag( "_stealth_spotted" ) )
		flag_waitopen( "_stealth_spotted" );
	
	waittillframeend;
	
	level endon("_stealth_spotted");
		
	name = undefined;
	anime = undefined;
	function = undefined;
	
	self.disableexits = false;
	self.disablearrivals = false;
	self.animname = "generic";
	
	if( flag( "church_and_intro_killed" ) )
	{
		level thread function_stack(::radio_dialogue, "scoutsniper_mcm_onme" );
		
		name = "church_price_door_kick_node";
		anime = "open_door_kick";
		function = ::door_open_kick;
		
		node = getnode( name, "targetname");
		
		node anim_generic_reach_and_arrive( self, anime );
	}
	else
	{
		name = "church_price_door_slow_node";
		anime = "open_door_slow";
		function = ::door_open_slow;
		
		node = getnode( name, "targetname");
		
		self setgoalnode( node );
		self.goalradius = 4;
		self waittill( "goal" );
	
		node anim_first_frame_solo( self, anime );
	}
			
	while( distance( level.player.origin, self.origin ) > 200 )
		wait .1;
	
	self thread church_open_door_commit( node, anime, function );
	node waittill( anime );
}

church_open_door_commit( node, anime, function )
{	
	if( flag("_stealth_spotted") )
		return;
	
	flag_set( "church_door_open" );
	
	node thread anim_single_solo( self, anime );	
	
	delaythread( .5, ::music_play, "scoutsniper_pripyat_music" );
	
	self enable_cqbwalk();
	door = getent("church_door_front", "targetname");
	door [[ function ]]();
	self delaythread( 2, ::disable_cqbwalk );
}

church_walkthrough()
{	
	self church_walkthrough_lookaround();
	
	flag_waitopen("_stealth_spotted");
		
	node = getnode("church_price_backdoor_node", "targetname");
	self.ref_node.origin = node.origin;
	self.ref_node.angles = node.angles + (0,-90,0);
	
	self.ref_node anim_generic_reach_and_arrive( self, "moveout_cornerR" );
	
	level thread function_stack(::radio_dialogue, "scoutsniper_mcm_coastclear" ); 
	self.ref_node anim_generic( self, "moveout_cornerR" );
	
	flag_set( "graveyard_moveup" );
}

church_walkthrough_lookaround()
{
	if( flag("_stealth_spotted") )
		return;
	level endon("_stealth_spotted");	
	
	ent = getent("church_price_look_around_node", "targetname");
	self set_goal_pos( ent.origin );
	self.goalradius = 90;
	
	self waittill("goal");
	self enable_cqbwalk();
	
	flag_set( "church_ladder_slide" );
	
	self anim_generic( self, "cqb_look_around" );
	
	ent = getent( ent.target, "targetname" ); 
	self set_goal_pos( ent.origin );
	self waittill("goal");
	
	self disable_cqbwalk();
}


/************************************************************************************************************/
/*												GRAVE YARD													*/
/************************************************************************************************************/

graveyard_main()
{
	flag_wait( "initial_setup_done" );
	flag_set( "graveyard" );
	
	if( !flag( "_stealth_spotted" ) )
		autosave_by_name( "graveyard" );
	
	array_thread( getentarray( "church_breakable", "targetname" ), ::graveyard_church_breakable );
	thread graveyard_Hind();
	thread graveyard_handle_spotted_dialogue();
	
	level.price thread graveyard_waithind();
	level.price thread graveyard_deadhind();
	level.price graveyard_moveup();
	
	level.price notify( "stop_loop" );
	level.price allowedstances("prone", "crouch", "stand" );
	
	flag_wait_either( "graveyard_hind_gone", "graveyard_hind_down" );
	
	if( flag( "graveyard_hind_down" ) )
	{
		wait 7;
		level thread function_stack(::radio_dialogue, "scoutsniper_mcm_showinoff" );
	}
	else
		level thread function_stack(::radio_dialogue, "scoutsniper_mcm_letsgo2" );
	
	flag_set( "field" );
}

graveyard_handle_spotted_dialogue()
{
	level endon ( "field" );
	
	flag_wait( "graveyard_hind_ready" );
	
	flag_wait( "_stealth_spotted" );
	
	level function_stack(::radio_dialogue, "scoutsniper_mcm_spotted" );
}

graveyard_moveup()
{
	flag_wait( "graveyard_moveup" );
	
	if( flag("_stealth_spotted") )
		return;
	level endon( "_stealth_spotted" );
	
	level endon( "graveyard_get_down" );
	
	node = getnode( "graveyard_price_node", "targetname" );
	self delaythread( .25, ::dynamic_run_speed );
		
	self.ref_node.origin = node.origin;
	self.ref_node.angles = node.angles + (0,-90,0);
	self.ref_node anim_generic_reach_and_arrive( self, "stop_cornerR" );
	
	flag_set( "graveyard_price_at_wall" );
}

graveyard_waithind()
{
	flag_wait( "graveyard_hind_ready" );
	
	if( flag("_stealth_spotted") )
		return;
	level endon( "_stealth_spotted" );
	
	while( distance( level.hind.origin, level.player.origin ) > 7500 )
		wait .05;
	
	flag_set( "graveyard_get_down" );
	level thread function_stack(::radio_dialogue, "scoutsniper_mcm_enemyheli" );
	
	self notify( "stop_dynamic_run_speed" );
		
	if( flag( "graveyard_price_at_wall" ) )
	{
		self allowedstances( "crouch" );
		self anim_generic( self, "corner_crouch" );
		self thread anim_generic_loop( self, "corner_idle", undefined, "stop_loop" );
	}
	else
	{
		self allowedstances( "prone" );
		self anim_generic_custom_animmode( self, "gravity", "pronehide_dive" );
	}
	
	self setgoalpos( self.origin );
	self.goalradius = 4;
		
	level thread function_stack(::radio_dialogue, "scoutsniper_mcm_inshadows" );
	
	while( distance( level.hind.origin, self.origin ) < 7500 )
		wait .05;
	
	while( distance( level.hind.origin, level.player.origin ) < 7500 )
		wait .05;
	
	self notify( "stop_loop" );
	self allowedstances("prone", "crouch", "stand" );
	
	wait .5;
	
	flag_set( "graveyard_hind_gone" );
}

graveyard_deadhind()
{
	flag_wait( "graveyard_hind_ready" );
	
	level endon( "field" );

	level.hind waittill( "death" );
	
	level.hind clearlookatent();
	
	flag_set( "graveyard_hind_down" );
}

graveyard_Hind()
{
	trigger = getent( "field_hind_flyover", "targetname" );
	trigger waittill( "trigger" );
	
	level thread function_stack(::radio_dialogue, "scoutsniper_mcm_hearthat" );
		
	hind = spawn_vehicle_from_targetname_and_drive( "field_hind" );
	
	level.hind = hind;
	flag_set( "graveyard_hind_ready" );
	
	hind endon( "death" );
	
	hind thread graveyard_hind_spot_enemy();
	hind thread graveyard_hind_spot_behavior();
	hind thread graveyard_hind_detect_damage();
	hind thread graveyard_hind_stinger_logic();
	
	flag_wait( "_stealth_spotted" );
	
	hind thread graveyard_hind_attack_enemy();
}

graveyard_hind_spot_behavior()
{
	self endon( "death" );
	
	if( flag( "_stealth_spotted" ) )
		return;
	level endon( "_stealth_spotted" );
	
	//you get one chance
	self waittill( "enemy" );
	self thread graveyard_hind_find_best_perimeter( true );
	//level thread function_stack(::radio_dialogue, "scoutsniper_mcm_dontmove" );
	level thread function_stack(::radio_dialogue, "scoutsniper_mcm_circlingback" );
	
	self waittill( "enemy" );
			
	flag_set( "_stealth_spotted" );
	
	pos = level.player.origin;
	self maps\_stealth_behavior::enemy_announce_spotted_bring_team( pos );
}

graveyard_hind_spot_enemy()
{
	self endon( "death" );
	
	if( flag( "_stealth_spotted" ) )
		return;
	level endon( "_stealth_spotted" );
		
	trig = getent( "graveyard_inside_church_trig", "targetname" );
	
	while( 1 )
	{		
		wait .05;	
		
		if( level.player istouching( trig ) )
			continue;
		
		checkmov = 1300;
		origin1 = level.player.origin;
		origin2 = (self.origin[0], self.origin[1], origin1[2] );
		velocity = length( level.player getVelocity() );
		
		check1 = ( velocity > 10 && level.player._stealth.logic.stance == "crouch" );
		check2 = ( velocity > 25 && level.player._stealth.logic.stance == "prone" );
		
		if( distance( origin1, origin2 ) < checkmov && ( check1 || check2 ) )
		{
			trace = bullettrace(self.origin + (0,0,-128), level.player.origin, true, level.price );
			
			if( !isdefined( trace[ "entity" ] ) || trace[ "entity" ] != level.player )
				continue;
		}
		else if( level.player._stealth.logic.stance == "prone" || level.player._stealth.logic.stance == "crouch" )
			continue;
		else
		{
			//helicopter can see better through your camo because 
			//of it's high angle in the sky
			check = level.player.maxvisibledist;
			check += 3500;
					
			if( distance( self.origin, level.player.origin ) > check )
				continue;
			
			trace = bullettrace(self.origin + (0,0,-128), level.player.origin, true, level.price );
			
			if( !isdefined( trace[ "entity" ] ) || trace[ "entity" ] != level.player )
				continue;
		}
		
		self notify( "enemy" );
		//we wait to give the player a chance to hide
		
		timefrac = distance( self.origin, level.player.origin ) * .0005;
		time = ( .5 + timefrac );
		//iprintlnbold( time );
		wait time;			
	}	
}

graveyard_hind_detect_damage()
{
	self endon( "death" );
	
	self waittill( "damage" );
	
	flag_set( "_stealth_spotted" );
	
	pos = level.player.origin;
	self maps\_stealth_behavior::enemy_announce_spotted_bring_team( pos );
}

graveyard_hind_attack_enemy()
{
	self endon( "death" );
	
	self thread graveyard_hind_find_best_perimeter();
	
	wait 1;
	
	self thread chopper_ai_mode( level.player );
	self thread chopper_ai_mode_missiles( level.player );
}

/************************************************************************************************************/
/*													FIELD													*/
/************************************************************************************************************/

field_main()
{
	flag_wait( "initial_setup_done" );
	flag_wait( "field" );
	
	flag_waitopen( "_stealth_spotted" );
		autosave_by_name( "field" );
		
	level.price stop_magic_bullet_shield();
	
	thread field_handle_enemys();
	thread field_handle_special_nodes();
	thread field_handle_flags();
	thread field_handle_church_door();
	thread field_handle_cleanup();

	//level.price field_road();
	level.price allowedstances( "stand", "crouch", "prone" );
	level.price thread field_getdown();
	level.price field_moveup();
	level.player thread field_creep_player();
	level.price thread field_creep();
}

field_handle_cleanup()
{
	if( flag( "_stealth_spotted" ) )
		return;
	level endon( "_stealth_spotted" );
	
	flag_wait( "field_clean" );
	
	ai = get_living_ai_array( "field_guard", "script_noteworthy" );
	ai = array_combine( ai, get_living_ai_array( "field_guard2", "script_noteworthy" ) );
	for(i=0; i<ai.size; i++)
		ai[ i ] delete();
	
	for(i=0; i< level.bmps.size; i++)
		level.bmps[ i ] setspeed( 5, 5 );
}

field_handle_church_door()
{
	flag_wait( "field_close_church_door" );
	
	door = getent("church_door_front", "targetname");
	door thread door_close();
}

field_handle_flags()
{
	trigger = getent( "field_price_getdown", "targetname" );
	trigger waittill( "trigger" );
	
	flag_set( "field_getdown" );
}

field_road()
{
	if( flag( "_stealth_spotted" ) )
		return;
	level endon( "_stealth_spotted" );
	
	if( flag( "field_player_way_ahead" ) )
		return;
	level endon( "field_player_way_ahead" );
			
	node = getnode( "field_before_road_node", "targetname" );
	delaythread( .25, ::dynamic_run_speed );
	self follow_path( node );
	self notify( "stop_dynamic_run_speed" );
	
	level thread function_stack(::radio_dialogue, "scoutsniper_mcm_stop" );
		
	wait 2;
	level function_stack(::radio_dialogue, "scoutsniper_mcm_clearleft" );
	level function_stack(::radio_dialogue, "scoutsniper_mcm_clearright" );
	level function_stack(::radio_dialogue, "scoutsniper_mcm_staylow2" );
	level function_stack(::radio_dialogue, "scoutsniper_mcm_go" );
	
	node = getnode( "field_after_road_node", "targetname" );
	node anim_generic_reach( level.price, "pronehide_dive" );
	
	self allowedstances( "prone" );
	self anim_generic_custom_animmode( self, "gravity", "pronehide_dive" );
	self setgoalpos( self.origin );

	wait 1;
	level function_stack(::radio_dialogue, "scoutsniper_mcm_areaclear" );
	self allowedstances( "stand", "crouch" );
	self maps\_stealth_behavior::friendly_spotted_getup_from_prone();
}

field_moveup()
{
	if( flag( "_stealth_spotted" ) )
		return;
	level endon( "_stealth_spotted" );
	
	level endon( "field_cutting_it_close" );
	
	node = getent( "field_price_node1", "targetname" );
	delaythread( .25, ::dynamic_run_speed );
	
	self thread follow_path( node );
	self pushplayer( true );
	
	node = getent( "field_price_stop_dynamic", "targetname" );
	node waittill( "trigger" );
	
	self notify( "stop_dynamic_run_speed" );
	waittillframeend;
	self.moveplaybackrate = 1.44;
	
	flag_set( "field_spawn" );
	
	node = getent( "field_price_decide_start", "targetname" );
	node waittill( "trigger" );

	flag_set( "field_start" );
	
	self waittill( "path_end_reached" );
	
	self allowedstances( "prone" );
	self anim_generic_custom_animmode( self, "gravity", "pronehide_dive" );
}

field_getdown()
{
	if( flag( "_stealth_spotted" ) )
		return;
	level endon( "_stealth_spotted" );
	
	flag_wait( "field_getdown" );
	
	if( !flag( "_stealth_spotted" ) )
		autosave_by_name( "field2" );
	
	level thread function_stack(::radio_dialogue, "scoutsniper_mcm_getdown" );
		
	delaythread(1, ::music_play, "scoutsniper_surrounded_music" );	
}

field_creep()
{
	if( flag( "_stealth_spotted" ) )
		return;
	level endon( "_stealth_spotted" );
		
	node = getent( "field_price_prone_node", "targetname" );
	self thread follow_path( node );
	
	delaythread( 12, ::field_creep_dialogue );
		
	self.moveplaybackrate = 1;
	wait 12;
	self.moveplaybackrate = .9;
	wait 3;//6
	self.moveplaybackrate = .8;
	wait 3;//9
	self.moveplaybackrate = .7;
	wait 3;//12
	self.moveplaybackrate = .6;
	wait 3;//15
	self.moveplaybackrate = .5;
	
	wait 7;
	
	self maps\_stealth_behavior::friendly_stance_handler_stay_still();
	wait 40;
		
	self maps\_stealth_behavior::friendly_stance_handler_resume_path();
	
	wait 1;
	self.moveplaybackrate = .6;
	wait 1;
	self.moveplaybackrate = .7;
	wait 1; 
	self.moveplaybackrate = .8;
	wait 1; 
	self.moveplaybackrate = .9;
	wait 1;
	self.moveplaybackrate = 1;
	
	wait 1;
		
	self ent_flag_set( "_stealth_stance_handler" );	
	level thread function_stack(::radio_dialogue, "scoutsniper_mcm_niceandslow" );
	
	node = getent( "field_price_clear", "targetname" );
	node waittill( "trigger" );
	
	self ent_flag_clear( "_stealth_stance_handler" );	
	self allowedstances( "prone", "crouch", "stand" );
	flag_set( "field_price_done" );
}

field_creep_dialogue()
{
	if( flag( "_stealth_spotted" ) )
		return;
	level endon( "_stealth_spotted" );
	
	level function_stack(::radio_dialogue, "scoutsniper_mcm_holdyourfire" );
	wait 3;	
	level function_stack(::radio_dialogue, "scoutsniper_mcm_anticipatepaths" );	
	wait 2;
	level function_stack(::radio_dialogue, "scoutsniper_mcm_slowandsteady" );	
}

field_creep_player()
{
	if( flag( "_stealth_spotted" ) )
		return;
	level endon( "_stealth_spotted" );
	
	if( flag( "pond" ) )
		return;
	level endon( "pond" );
	
	thread field_creep_player_cleanup();
	
	nomovement = undefined;
	hidden = [];
	hidden[ "stand" ] = 2;
	hidden[ "crouch" ] = 1;
	hidden[ "prone" ] = .5;
	level.player stealth_friendly_movespeed_scale_set( hidden, hidden );
	
	while( 1 )
	{
		nomovement = self field_creep_player_calc_movement();
		
		if( nomovement )
		{
			badplace_cylinder( "_stealth_player_prone", 0, self.origin, 30, 90,"axis" );
			
			while( nomovement )
			{
				wait .05;
				nomovement = self field_creep_player_calc_movement();
			}	
			
			badplace_delete( "_stealth_player_prone" ); 
		}
		else 
			wait .05;
	}
}

field_creep_player_cleanup()
{
	flag_wait_either( "_stealth_spotted", "pond" );
	
	level.player stealth_friendly_movespeed_scale_default();
	badplace_delete( "_stealth_player_prone" ); 
}

field_handle_enemys()
{
	//field_bmp1 = spawn_vehicle_from_targetname_and_drive( "bmp1" );
	field_bmp1 = spawn_vehicle_from_targetname( "bmp1" );
	field_bmp2 = spawn_vehicle_from_targetname( "bmp2" );
	field_bmp3 = spawn_vehicle_from_targetname( "bmp3" );
	field_bmp4 = spawn_vehicle_from_targetname( "bmp4" );
	
	level.bmps = [];
	level.bmps[ level.bmps.size ] = field_bmp1;
	level.bmps[ level.bmps.size ] = field_bmp2;
	level.bmps[ level.bmps.size ] = field_bmp3;
	level.bmps[ level.bmps.size ] = field_bmp4;
	
	for(i=0; i<level.bmps.size; i++)
	{
		level.bmps[ i ] field_bmp_make_followme();
		level.bmps[ i ] thread field_bmp_quake();
		level.bmps[ i ] thread execVehicleStealthDetection();
	}
	
	state_functions = [];
	state_functions[ "hidden" ] 	= ::dash_state_hidden;
	state_functions[ "alert" ] 		= maps\_stealth_behavior::enemy_state_alert;
	state_functions[ "spotted" ] 	= maps\_stealth_behavior::enemy_state_spotted;
	
	array_thread( getentarray( "field_guard", "script_noteworthy" ), ::add_spawn_function, ::stealth_ai, state_functions);
	array_thread( getentarray( "field_guard2", "script_noteworthy" ), ::add_spawn_function, ::stealth_ai, state_functions);
	array_thread( getentarray( "field_guard", "script_noteworthy" ), ::add_spawn_function, ::field_enemy_think);
	array_thread( getentarray( "field_guard2", "script_noteworthy" ), ::add_spawn_function, ::field_enemy_think);
	array_thread( getentarray( "field_guard", "script_noteworthy" ), ::add_spawn_function, ::deleteOnPathEnd);
	array_thread( getentarray( "field_guard2", "script_noteworthy" ), ::add_spawn_function, ::deleteOnPathEnd);
	
	flag_wait( "field_spawn" );
	
	thread scripted_array_spawn( "field_guard2", "script_noteworthy", true );
	thread scripted_array_spawn( "field_guard", "script_noteworthy", true );

	flag_wait( "field_start" );
	
	thread maps\_vehicle::gopath( field_bmp1 );
	delaythread( 1, maps\_vehicle::gopath, field_bmp2 );
	delaythread( 3, maps\_vehicle::gopath, field_bmp3 );
	delaythread( 3.5, maps\_vehicle::gopath, field_bmp4 );
	
	ai = get_living_ai_array( "field_guard", "script_noteworthy" );
	
	for(i=0; i<ai.size; i++)
	{
		if( issubstr( ai[ i ].target, "bmp" ) )
			ai[ i ] thread field_enemy_walk_behind_bmp();
		else
		{
			ai[ i ] thread maps\_patrol::patrol();
			ai[ i ] ent_flag_set( "field_walk" );
		}
	}
	
	wait 11;
	
	ai = get_living_ai_array( "field_guard2", "script_noteworthy" );
	
	for(i=0; i<ai.size; i++)
	{
		if( issubstr( ai[ i ].target, "bmp" ) )
			ai[ i ] thread field_enemy_walk_behind_bmp();
		else
		{
			ai[ i ] thread maps\_patrol::patrol();
			ai[ i ] ent_flag_set( "field_walk" );
		}
	}
	
	flag_wait( "field_bmp_badplace" );
}

field_enemy_think()
{
	self endon( "death" );
	
	self ent_flag_init( "field_walk" );

	self thread field_enemy_death();
	self.ignoreme = true;
	
	waittillframeend;
	self maps\_stealth_behavior::ai_change_behavior_function( "alert", "alerted_once", ::field_enemy_alert_level_1 );
	self maps\_stealth_behavior::ai_change_behavior_function( "alert", "alerted_again", ::field_enemy_alert_level_2 );
	self thread field_enemy_patrol_thread();
		
	wait .05;
	self setgoalpos( self.origin );
	self.goalradius = 4;
	wait .05;
	self.fixednode = false;
	
	flag_wait( "field_start" );		
			
	trig = getent( "field_turn_around_trig", "targetname" );

	while(1)
	{
		trig waittill( "trigger", other );
		if( other == self )
			break;			
	}
	
	self maps\_stealth_behavior::ai_change_behavior_function( "alert", "alerted_once", maps\_stealth_behavior::enemy_alert_level_alerted_again );
	self maps\_stealth_behavior::ai_change_behavior_function( "alert", "alerted_again", maps\_stealth_behavior::enemy_alert_level_alerted_again );
	
	dist = 700;
	distsqrd = dist * dist;
	
	while( 1 )
	{
		if( distancesquared( level.player.origin, self.origin ) < distsqrd )
			break;
		
		wait .25;
	}	
	
	self.favoriteenemy = level.player;
}

/************************************************************************************************************/
/*													POND													*/
/************************************************************************************************************/

pond_main()
{
	array_thread( getentarray( "pond_patrol", "script_noteworthy" ), ::add_spawn_function, ::stealth_ai);
	array_thread( getentarray( "pond_throwers", "script_noteworthy" ), ::add_spawn_function, ::stealth_ai);
	array_thread( getentarray( "pond_backup", "script_noteworthy" ), ::add_spawn_function, ::stealth_ai);
	array_thread( getentarray( "pond_runners", "script_noteworthy" ), ::add_spawn_function, ::stealth_ai);

	array_thread( getentarray( "pond_patrol", "script_noteworthy" ), ::add_spawn_function, ::pond_patrol);
	array_thread( getentarray( "pond_throwers", "script_noteworthy" ), ::add_spawn_function, ::pond_thrower);
	array_thread( getentarray( "pond_runners", "script_noteworthy" ), ::add_spawn_function, ::deleteOntruegoal);
		
	thread pond_handle_kills( "pond_patrol_spawned", "pond_patrol", "pond_patrol_dead", "scoutsniper_mcm_toppedhim" );
	thread pond_handle_kills( "pond_thrower_spawned", "pond_throwers", "pond_thrower_dead", "scoutsniper_mcm_goodnight" );
	thread pond_handle_clear();
	thread pond_handle_backup();
	
	flag_wait( "initial_setup_done" );
	flag_wait( "pond" );
	
	level.player._stealth_move_detection_cap = 0;
	
	level.price ent_flag_init( "pond_in_position" );
	
	if( !flag( "_stealth_spotted" ) )
		autosave_by_name( "pond" );
	
	level.price pond_moveup();
	level.price thread magic_bullet_shield();
	level.price pond_betterview();
	
	level.player._stealth_move_detection_cap = undefined;
	
	if( !flag( "_stealth_spotted" ) )
		autosave_by_name( "pond2" );
	
	level.price allowedstances( "prone", "crouch", "stand" );
	level.price thread pond_kill_patrol();
	level.price thread pond_kill_thrower();
	level.price pond_sneakup();
	
	if( !flag( "_stealth_spotted" ) )
		autosave_by_name( "pond3" );
	
	level.price pond_inposition();
	
	if( flag( "pond_enemies_dead" ) )
	{
		level.price ent_flag_clear( "_stealth_stance_handler" );
		level.price allowedstances( "prone", "crouch", "stand" );
	}
	level.price disable_cqbwalk();
	
	if( flag( "_stealth_spotted" ) )
	{
		flag_waitopen( "_stealth_spotted" );
		level thread function_stack(::radio_dialogue, "scoutsniper_mcm_thewordstealth" );
	}
	
	{
		flag_wait_either( "pond_enemies_dead", "cargo" );
		level thread function_stack(::radio_dialogue, "scoutsniper_mcm_moveup" );
	}	
	
	flag_set( "cargo" );
}

pond_patrol()
{
	flag_set( "pond_patrol_spawned" );
		
	self.ignoreme = true;
/*	
	truck = get_vehicle( "pond_truck", "script_noteworthy" );
	truck waittill( "unload" );
	
	wait 2;*/
	
	self waittill( "jumpedout" );
	
	self thread maps\_patrol::patrol();
	
	if( flag( "_stealth_spotted" ) )
		return;
	level endon( "_stealth_spotted" );
	
	while( isalive( self ) )
	{
		self waittill( "damage", ammount, other );
		if( other == level.price && isalive( self ) )
			self dodamage( self.health + 100, level.price.origin );
	}	
}

pond_thrower()
{
	flag_set( "pond_thrower_spawned" );
		
	self.ignoreme = true;
	/*
	truck = get_vehicle( "pond_truck", "script_noteworthy" );
	truck waittill( "unload" );
	
	wait 2;
	*/
	
	self waittill( "jumpedout" );
	
	self set_generic_run_anim( "combat_jog" );
	
	self thread idle_anim_think();
	
	if( flag( "_stealth_spotted" ) )
		return;
	level endon( "_stealth_spotted" );
	
	while( isalive( self ) )
	{
		self waittill( "damage", ammount, other );
		if( other == level.price && isalive( self ) )
			self dodamage( self.health + 100, level.price.origin );
	}
}

pond_moveup()
{
	flag_wait( "field_price_done" );
	
	if( flag( "_stealth_spotted" ) )
		return;
	level endon( "_stealth_spotted" );
	
	self pushplayer( true );
	
	level thread function_stack(::radio_dialogue, "scoutsniper_mcm_followme2" );
	node = getnode( "pond_price_moveup_node", "targetname" );
	
	self.ref_node.origin = node.origin;
	self.ref_node.angles = node.angles;
	
	self setgoalnode( node );
	self.goalradius = 4;
	self waittill( "goal" );
	
	wait 1;
	
	self.ref_node thread anim_generic( self, "look_up_stand" );
	self.ref_node waittill("look_up_stand");
	
	self thread anim_generic_loop( self, "look_idle_stand", undefined, "stop_loop" );	
	
	thread music_play( "scoutsniper_deadpool_music" );
		
	level function_stack(::radio_dialogue, "scoutsniper_mcm_buyout" );
		
	self notify( "stop_loop" );
	
	self thread anim_generic( self, "look_down_stand" );
	self waittill("look_down_stand");
	
	level thread function_stack(::radio_dialogue, "scoutsniper_mcm_betterview" );		
	
	wait 1;
}

pond_betterview()
{
	if( flag( "_stealth_spotted" ) )
		return;
	level endon( "_stealth_spotted" );
	
	node = getnode( "price_pond_better_node", "targetname" );
	
	self.ref_node.origin = node.origin;
	self.ref_node.angles = node.angles + (0,90,0);
		
	self setgoalnode( node );
	self.goalradius = 100;
	
	wait 1;
	self allowedstances( "crouch" );
	self waittill( "goal" );
	
	self allowedstances( "crouch", "stand" );
	
	self setgoalnode( node );
	self.goalradius = 4;
	self waittill( "goal" );
	
	wait .5;
	
	self.ref_node thread anim_generic( self, "alert2look_cornerL" );
	self.ref_node waittill("alert2look_cornerL");
	
	self thread anim_generic_loop( self, "look_idle_cornerL", undefined, "stop_loop" );	
	
	level function_stack(::radio_dialogue, "scoutsniper_mcm_withoutalerting" );		
	level thread function_stack(::radio_dialogue, "scoutsniper_mcm_sneakingpast" );		
			
	self notify( "stop_loop" );
	
	self thread anim_generic( self, "look2alert_cornerL" );
	self waittill("look2alert_cornerL");
	
	level function_stack(::radio_dialogue, "scoutsniper_mcm_yourcall2" );	
}

pond_sneakup()
{
	if( flag( "_stealth_spotted" ) )
		return;
	level endon( "_stealth_spotted" );
	
	if( flag( "pond_enemies_dead" ) )
		return;
	level endon( "pond_enemies_dead" );
	
	if( flag( "pond_patrol_dead" ) )
		return;
	level endon( "pond_patrol_dead" );
	
	if( flag( "cargo" ) )
		return;
	level endon( "cargo" );
	
	self ent_flag_set( "_stealth_stance_handler" );
	
	while( distance( level.player.origin, self.origin ) < 96 )
		wait .05;
	
	node = getnode( "price_pond_sneak_node", "targetname" );
	self follow_path( node, 128 );
}

pond_inposition()
{
	if( flag( "_stealth_spotted" ) )
		return;
	level endon( "_stealth_spotted" );
	
	if( flag( "pond_enemies_dead" ) )
		return;
	level endon( "pond_enemies_dead" );
	
	if( flag( "pond_thrower_dead" ) )
		return;
	level endon( "pond_thrower_dead" );
	
	if( flag( "cargo" ) )
		return;
	level endon( "cargo" );
	
	flag_wait( "pond_patrol_dead" );
	
	level function_stack(::radio_dialogue, "scoutsniper_mcm_dontfire" );
	level function_stack(::radio_dialogue, "scoutsniper_mcm_sametime" );
	
	nodes = getnodearray( "pond_in_position", "script_noteworthy" );
	nodes = get_array_of_closest( self.origin, nodes );
		
	node = nodes[0];
	self delaythread(.05, ::follow_path, node, 1 );
	first = true;
	msg = "scoutsniper_mcm_whenyoureready";
	
	
	while( isdefined( node ) )
	{
		self waittill( "follow_path_new_goal" );
		self disable_cqbwalk();
		self ent_flag_set( "_stealth_stance_handler" );
		self ent_flag_clear( "pond_in_position" );
		
		if( first )
		{
			if( distance( node.origin, self.origin ) < 8 ) 
				msg = undefined;
			else
				level thread function_stack(::radio_dialogue, "scoutsniper_mcm_waitforme" );
			first = false;	
		}
		else
			level thread function_stack(::radio_dialogue, "scoutsniper_mcm_holdyourfiremoving" );
			
		node waittill( "trigger" );	
		self thread pond_inposition_takeshot( node, msg );
		msg = undefined;
		
		if( isdefined( node.target ) )
			node = getnode( node.target, "targetname" );
		else
			node = undefined;
	}
}

pond_handle_kills( _wait, name, _flag, msg )
{
	flag_wait( _wait );
	
	waittillframeend;
	
	ai = get_living_ai_array( name, "script_noteworthy" );
	
	waittill_dead( ai );
	
	flag_set( _flag );
	
	if( flag( "_stealth_spotted" ) )
		return;
		
	level thread function_stack(::radio_dialogue, msg );
}

pond_handle_clear()
{
	flag_wait( "pond_patrol_dead" );
	flag_wait( "pond_thrower_dead" );
	flag_set( "pond_enemies_dead" );
}

pond_kill_patrol()
{
	if( flag( "_stealth_spotted" ) )
		return;
	level endon( "_stealth_spotted" );
	
	if( flag( "pond_enemies_dead" ) )
		return;
	level endon( "pond_enemies_dead" );
	
	if( flag( "pond_patrol_dead" ) )
		return;
	level endon( "pond_patrol_dead" );
	
	ai = get_living_ai_array( "pond_patrol", "script_noteworthy" );
	
	if( ai.size > 1 )
	{
		waittill_dead(ai, 1);
		level thread function_stack(::radio_dialogue, "scoutsniper_mcm_targetelim" );
	}		
	
	wait .25;
		
	while( self ent_flag( "_stealth_stay_still" ) )
		self waittill( "_stealth_stay_still" );
	
	enemy = get_living_ai("pond_patrol", "script_noteworthy");
		
	enemy endon("death");
	
	//self thread intro_sneakup_patrollers_moveto_kill( enemy );
		
	while( isalive( enemy ) )
	{
		test = get_living_ai_array( "pond_throwers", "script_noteworthy" );
		
		//this makes sure price doesn't kill him and leave a corpse right infront of
		//the throwers
		if( test.size && isalive( test[0] ) )
		{
			if( distance( enemy.origin, test[0].origin ) < 550 )
			{
				wait .5;
				continue;	
			}
		}
		
		break;
	}
	self.ignoreall = false;
	enemy.ignoreme = false;
	self.favoriteenemy  = enemy;
	wait 1;
}

pond_kill_thrower()
{
	/*if( flag( "_stealth_spotted" ) )
		return;
	level endon( "_stealth_spotted" );*/
	
	if( flag( "pond_enemies_dead" ) )
		return;
	level endon( "pond_enemies_dead" );
	
	if( flag( "pond_thrower_dead" ) )
		return;
	level endon( "pond_thrower_dead" );
	
	ai = get_living_ai_array( "pond_throwers", "script_noteworthy" );
	
	if( ai.size > 1 )
		waittill_dead(ai, 1);
		
	flag_set( "pond_thrower_kill" );
	
	wait .15;
		
	enemy = get_living_ai("pond_throwers", "script_noteworthy");
	
	self.ignoreall = false;
	enemy.ignoreme = false;
	
	enemy endon("death");
	
	//self thread intro_sneakup_patrollers_moveto_kill( enemy );
	
	if( flag( "pond_patrol_dead" ) )
	{
		self ent_flag_wait( "pond_in_position" );
		MagicBullet( self.weapon, self gettagorigin( "tag_flash" ), enemy getShootAtPos() );
		wait .05;
		enemy dodamage( enemy.health + 100, self.origin );
	}
	else
	{
		while( isalive( enemy ) )
		{
			self.favoriteenemy  = enemy;
			wait 1;
		}
	}
}

/************************************************************************************************************/
/*													CARGO													*/
/************************************************************************************************************/

cargo_main()
{
	array = [];
	array[ "attack" ] = ::cargo_enemy_attack;
	
	array_thread( getentarray( "cargo_guys", "targetname" ), ::add_spawn_function, ::stealth_ai, undefined, array);
	array_thread( getentarray( "cargo_smokers", "script_noteworthy" ), ::add_spawn_function, ::idle_anim_think);
	array_thread( getentarray( "cargo_sleeper", "script_noteworthy" ), ::add_spawn_function, ::idle_anim_think);
	array_thread( getentarray( "cargo_patrol_defend2", "script_noteworthy" ), ::add_spawn_function, ::idle_anim_think);
	array_thread( getentarray( "cargo_sleeper", "script_noteworthy" ), ::add_spawn_function, ::cargo_sleeper);
	array_thread( getentarray( "cargo_patrol", "script_noteworthy" ), ::add_spawn_function, ::cargo_patrol_death);
	array_thread( getentarray( "cargo_patrol_defend1", "script_noteworthy" ), ::add_spawn_function, ::cargo_patrol_defend1_death);
	array_thread( getentarray( "cargo_patrol_defend2", "script_noteworthy" ), ::add_spawn_function, ::cargo_patrol_defend2_death);
	
	thread cargo_enemies_death();
	thread cargo_handle_patroller();
	thread cargo_defender2_move();
				
	flag_wait( "initial_setup_done" );
	flag_wait( "cargo" );
		
	if( !flag( "_stealth_spotted" ) )
	{
		level.price.ignoreall = true;
		autosave_by_name( "cargo" );
		
		if( flag(  "pond_enemies_dead" ) )
		{
			level.price allowedstances( "prone", "crouch", "stand" );
			thread clean_previous_ai( "cargo", "pond_backup", "script_noteworthy" );
			level.price thread dynamic_run_speed();
		}
	}
	
	thread cargo_handle_defend1_flag();
	
	level.price ent_flag_clear( "_stealth_stance_handler" );
	level.price cargo_moveup();
	level.price notify( "stop_dynamic_run_speed" );
	level.price cargo_sneakup();
	level.price cargo_attack1();
	level.price allowedstances( "prone", "crouch", "stand" );
	level.price cargo_attack2();
	
	level.price cargo_waitmove();
	level.price notify( "stop_dynamic_run_speed" );
	if( !flag( "_stealth_spotted" ) )	
		autosave_by_name( "cargo2" );
	
	level.price cargo_slipby();
	level.price disable_cqbwalk();
	level.price cargo_leave();
	
	if( flag( "_stealth_spotted" ) )
	{
		flag_waitopen( "_stealth_spotted" );
		level.price cargo_leave();
	}
	
	flag_set( "dash" );	
}

cargo_patrol_death()
{
	self waittill( "death" );
	flag_set( "cargo_patrol_dead" );
	
	if( flag( "_stealth_spotted" ) )
		return;
	level endon( "_stealth_spotted" );
	
	if( level.price cansee( self ) )
		level function_stack(::radio_dialogue, "scoutsniper_mcm_tangodown" );
}

cargo_enemies_death()
{
	trig = getent( "cargo_guys", "target" );
	trig waittill( "trigger" );
	
	wait .1;
	
	ai = get_living_ai_array( "cargo_smokers", "script_noteworthy" );
	ai = array_combine( ai, get_living_ai_array( "cargo_sleeper", "script_noteworthy" ) );
	ai = array_combine( ai, get_living_ai_array( "cargo_patrol", "script_noteworthy" ) );
	ai = array_combine( ai, get_living_ai_array( "cargo_patrol_defend1", "script_noteworthy" ) );
	ai = array_combine( ai, get_living_ai_array( "cargo_patrol_defend2", "script_noteworthy" ) );
	
	waittill_dead( ai );
	
	flag_set( "cargo_enemies_dead" );
}

cargo_sleeper()
{
	self endon( "death" );
	self.ignoreall = true;
	
	cargo_sleeper_wait_wakeup();
	
	self.ignoreall = false;	
}

cargo_patrol_defend1_death()
{
	self SetTalkToSpecies();//talk to no one
	
	name = "corpse_" + self.ai_number;
	
	self waittill("death");
	
	flag_set( "cargo_patrol_defend1_dead" );
	
	wait 1.25;
	
	corpse = getent( name, "script_noteworthy" );
		if( isdefined( corpse ) )
			level._stealth.logic.corpse.array = array_remove( level._stealth.logic.corpse.array, corpse );
}

cargo_patrol_defend2_death()
{
	self SetTalkToSpecies();//talk to no one

	self waittill("death");
	
	flag_set( "cargo_patrol_defend2_dead" );
}

cargo_handle_defend1_flag()
{
	level endon( "cargo_started_defend_moment" );
	
	node = getent( "cargo_defend1_node", "targetname" );
	node waittill( "trigger" );
	
	flag_set( "cargo_enemy_ready_to_defend1" );
	
	length = getanimlength( %patrol_bored_idle_smoke );
	wait length - 1.25;
	flag_clear( "cargo_enemy_ready_to_defend1" );
	flag_set( "cargo_enemy_defend_moment_past" );
}

cargo_moveup()
{
	if( flag( "_stealth_spotted" ) )
		return;
	level endon( "_stealth_spotted" );
	
	node = getnode( "cargo_price_node1", "targetname" );
	self follow_path( node );
	level function_stack(::radio_dialogue, "scoutsniper_mcm_inshadows" );
	thread cargo_moveup_dialogue();
}

cargo_moveup_dialogue()
{
	if( flag( "_stealth_spotted" ) )
		return;
	level endon( "_stealth_spotted" );
			
	if( !flag( "cargo_patrol_defend1_dead" ) )
		level function_stack(::radio_dialogue, "scoutsniper_mcm_letsgo" );
	else
	{
		level function_stack(::radio_dialogue, "scoutsniper_mcm_tangodown" );
		//level function_stack(::radio_dialogue, "scoutsniper_mcm_move" );
	}
}

cargo_sneakup()
{
	if( flag( "_stealth_spotted" ) )
		return;
	level endon( "_stealth_spotted" );
	
	node = getent( "cargo_price_sneakup_node", "targetname" );
	
	self allowedstances( "crouch" );
	
	self follow_path( node );
	thread music_play( "scoutsniper_stealth_01_music" );
	thread cargo_sneakup_dialogue();
}

cargo_sneakup_dialogue()
{
	if( flag( "_stealth_spotted" ) )
		return;
	level endon( "_stealth_spotted" );
	
	if( flag( "cargo_enemies_dead" ) )
		return;
	level endon( "cargo_enemies_dead" );
	
	if( !flag( "cargo_patrol_defend1_dead" ) )
	{
		level function_stack(::radio_dialogue, "scoutsniper_mcm_waithere" );
		
		flag_wait_either( "cargo_enemy_ready_to_defend1", "cargo_patrol_defend1_dead" );
		
		if( !flag( "cargo_patrol_defend1_dead" ) )
		{
			level function_stack(::radio_dialogue, "scoutsniper_mcm_holdfast" );
		}
		else
		{
			level function_stack(::radio_dialogue, "scoutsniper_mcm_tangodown" );
			level function_stack(::radio_dialogue, "scoutsniper_mcm_move" );
		}
	}
	else
	{
		level function_stack(::radio_dialogue, "scoutsniper_mcm_move" );
	}
}

cargo_attack1()
{
	if( flag( "_stealth_spotted" ) )
		return;
	level endon( "_stealth_spotted" );
	
	if( flag( "cargo_patrol_defend1_dead" ) )
		return;
	level endon( "cargo_patrol_defend1_dead" );
	
	if( flag( "cargo_enemy_defend_moment_past" ) )
		return;
	level endon( "cargo_enemy_defend_moment_past" );
		
	flag_wait( "cargo_enemy_ready_to_defend1" );
	flag_set( "cargo_started_defend_moment" );
	
	defender = get_living_ai( "cargo_patrol_defend1", "script_noteworthy" );
	defender endon( "death" );
	
	node = spawn( "script_origin", defender.origin );
	node.angles = defender.angles;	
	
	node anim_generic_reach(self, "cargo_attack_1" );
	
	self thread cargo_attack1_commit( node, defender );
	node waittill ( "cargo_attack_1" );
}

cargo_attack1_commit( node, defender )
{	
	defender endon( "death" );
		
	defender notify( "end_patrol" );
	defender notify( "_stealth_stop_stealth_logic" );
	waittillframeend;//this sets allowdeath to false...so we need to wait a frame to make sure we can turn it back on below
	
	defender.ignoreall = true;
	defender.allowdeath = true;
	
	thread dialogprint( "Price - OYE! Suzy!.", 2 );
	alias = "scoutsniper_ru" + defender._stealth.behavior.sndnum + "_huh";
	defender delaythread(1, ::play_sound_on_entity, alias );
	
	self.favoriteenemy = defender;
	node thread anim_generic_custom_animmode( defender, "gravity", "cargo_defend_1" );
	
	self thread cargo_attack_commit_fail( defender, node, "cargo_attack_1" );
	node thread anim_generic_custom_animmode( self, "gravity", "cargo_attack_1" );
}

cargo_attack_commit_fail( guy, node, msg )
{
	node endon( msg );
	
	guy thread killed_by_player();
	
	guy waittill( "killed_by_player" );
	self stopanimscripted(); 
	self notify ( "stop_animmode" );
	node notify ( "stop_animmode" );
	anime = "run_2_stop";
	self anim_generic_custom_animmode( self, "gravity", anime );
}

cargo_attack2()
{
	if( flag( "_stealth_spotted" ) )
		return;
	level endon( "_stealth_spotted" );
	
	if( flag( "cargo_patrol_defend2_dead" ) )
		return;
	level endon( "cargo_patrol_defend2_dead" );
	
	if( flag( "cargo_enemy_defend_moment_past" ) )
		return;
	level endon( "cargo_enemy_defend_moment_past" );
	
	thread cargo_attack2_dialogue();
	
	defender = get_living_ai( "cargo_patrol_defend2", "script_noteworthy" );
	defender endon( "death" );
	
	self thread cargo_attack2v2( defender );
	defender thread stealth_enemy_endon_alert();
	defender endon( "stealth_enemy_endon_alert" );
	
	defender maps\_stealth_behavior::ai_change_behavior_function( "alert", "alerted_once", ::empty_function );
	defender maps\_stealth_behavior::ai_change_behavior_function( "alert", "alerted_again", ::empty_function );
	
	node = getnode( "cargo_price_attack2_node", "targetname" );
	self set_goal_node( node );
	self.goalradius = 4;	
	
	defender stealth_ai_clear_custom_idle_and_react();
	defender clear_run_anim();

	node = getent( "cargo_attack2_node", "targetname" );	
	node anim_generic_reach(defender, "cargo_defend_2" );
	
	self thread cargo_attack2_commit( node, defender );
	node waittill ( "cargo_attack_2" );
}

cargo_attack2_dialogue()
{
	if( flag( "_stealth_spotted" ) )
		return;
	level endon( "_stealth_spotted" );
	
	if( !flag( "cargo_patrol_defend2_dead" ) )
		level function_stack(::radio_dialogue, "scoutsniper_mcm_targeteast" );
	if( !flag( "cargo_patrol_defend2_dead" ) )
		level function_stack(::radio_dialogue, "scoutsniper_mcm_staylow2" );
	if( !flag( "cargo_patrol_defend2_dead" ) )
		dialogprint( "Price - he's mine.", 2 );
	
	flag_wait( "cargo_patrol_defend2_dead" );
		
	level function_stack(::radio_dialogue, "scoutsniper_mcm_goodnight" );
}

cargo_attack2_commit( node, defender )
{	
	defender endon( "death" );
	defender notify( "_stealth_stop_stealth_logic" );
	
	defender.ignoreall = true;
	defender.allowdeath = true;
	
	thread dialogprint( "Price - < whistle >", 2 );
	alias = "scoutsniper_ru" + defender._stealth.behavior.sndnum + "_huh";
	defender delaythread(1, ::play_sound_on_entity, alias );
	
	self.favoriteenemy = defender;
	node thread anim_generic( defender, "cargo_defend_2" );
	
	self thread cargo_attack_commit_fail( defender, node, "cargo_attack_2" );
	node thread anim_generic( self, "cargo_attack_2" );
}

cargo_waitmove()
{
	if( flag( "_stealth_spotted" ) )
		return;
	level endon( "_stealth_spotted" );
	
	if( flag( "cargo_enemies_dead" ) )
		return;
	level endon( "cargo_enemies_dead" );
	
	if( !flag( "cargo_enemy_defend_moment_past" ) )
		return;
	
	self delaythread( .1, ::dynamic_run_speed );
	
	check1 = (flag( "cargo_defender1_away" ) || flag( "cargo_patrol_defend1_dead" ) );
//	check2 = (flag( "cargo_defender2_away" ) || flag( "cargo_patrol_defend2_dead" ) );
	if( !check1 )
	{
		dialogprint( "Price - Wait a moment, and observe the situation", 2 );	
	}
	else
	{
		level thread function_stack(::radio_dialogue, "scoutsniper_mcm_go" );
		return;
	}
		
	while( 1 )
	{
		flag_wait_any( "cargo_defender1_away", "cargo_defender2_away", "cargo_patrol_defend1_dead", "cargo_patrol_defend2_dead" );	
		
		check1 = (flag( "cargo_defender1_away" ) || flag( "cargo_patrol_defend1_dead" ) );
//		check2 = (flag( "cargo_defender2_away" ) || flag( "cargo_patrol_defend2_dead" ) );
		
		if( check1 )
			break;
		
		else
			level thread function_stack(::radio_dialogue, "scoutsniper_mcm_standby" );
	}
	
	level thread function_stack(::radio_dialogue, "scoutsniper_mcm_ourchance" );
}

cargo_defender2_move()
{	
	if( flag( "_stealth_spotted" ) )
		return;
	level endon( "_stealth_spotted" );
	
	if( flag( "cargo_enemies_dead" ) )
		return;
	level endon( "cargo_enemies_dead" );
	
	if( flag( "cargo_patrol_defend2_dead" ) )
		return;
	level endon( "cargo_patrol_defend2_dead" );
	
	flag_wait( "cargo_defender2_move" );
	
	if( !flag( "cargo_enemy_defend_moment_past" ) )
		return;
	
	ai = get_living_ai( "cargo_patrol_defend2", "script_noteworthy" );
	ai stealth_ai_clear_custom_idle_and_react();
	ai.target = "defend2_patrol_node";
	ai thread maps\_patrol::patrol();
}

cargo_slipby()
{
	if( flag( "_stealth_spotted" ) )
		return;
	level endon( "_stealth_spotted" );
	
	if( flag( "cargo_enemies_dead" ) )
		return;
	level endon( "cargo_enemies_dead" );
	
	thread cargo_insane();
	
	self enable_cqbwalk();
	
	dist = 300;
	//get to the next spot and wait for the player
		node = getnode( "cargo_price_slipby_1", "targetname" );	
		level delaythread(1, ::function_stack, ::radio_dialogue, "scoutsniper_mcm_followme" );
		self follow_path( node );
	
	//handle the situation
	self cargo_slipby_part1( dist );
	//if we hit this line of code then the patroller is still alive and 
	//is either coming up on us, or has just past us and into the container
	
	dist = 450;
	//get to the next spot and wait for the player
		node = getnode( "cargo_price_slipby_3", "targetname" );
		self.ref_node.origin = node.origin;
		self.ref_node.angles = node.angles + (0,-90,0);
		self.ref_node anim_generic_reach_and_arrive( self, "stop_cornerR" );
		self.goalradius = 4;
		
		while( !( self wait_for_player( node, ::follow_path_get_node, dist ) ) )
			wait .05;
	
	//handle the situation
	self cargo_slipby_part2( dist );
	
	dist = 500;
	//get to the next spot and wait for the player	
		node = getnode( "cargo_price_slipby_4", "targetname" );
		self.ref_node.origin = node.origin;
		self.ref_node.angles = node.angles;
		self.ref_node anim_generic_reach_and_arrive( self, "stop_cqb" );
		self.goalradius = 4;
		
		//we're in plain view here - so if the player doesn't hurry up
		//and we're about to be spotted - we move on
		while( 1 )
		{
			wait .05;
			if( !flag( "cargo_patrol_away" ) && !flag( "cargo_patrol_dead" ) )
				break;
			if( self wait_for_player( node, ::follow_path_get_node, dist ) )
				break;
		}
	
	//handle the situation
	self cargo_slipby_part3( dist );
}

cargo_insane()
{	
	trig = getent( "cargo_insane", "targetname" );
	use = getentarray( "intelligence_item", "targetname" );
	use = get_array_of_closest( trig getorigin(), use );
	
	use[0] thread cargo_insane_handle_use();
	
	if( flag( "_stealth_spotted" ) )
		return;
	level endon( "_stealth_spotted" );
	
	if( flag( "cargo_enemies_dead" ) )
		return;
	level endon( "cargo_enemies_dead" );
	
	trig waittill( "trigger" );
	thread dialogprint( "Price - Are you insane?.", 2 );
	
	use[0] waittill( "trigger" );
	thread dialogprint( "Price - I'll say one thing, you've certainly got the minerals.", 2 );
}

cargo_leave()
{
	if( flag( "_stealth_spotted" ) )
		return;
	level endon( "_stealth_spotted" );
	
	if( flag( "cargo_enemies_dead" ) )
		return;
	level endon( "cargo_enemies_dead" );
	
	node = getnode( "cargo_price_leave_node", "targetname" );
	
	self follow_path( node, 90 );
}

/************************************************************************************************************/
/*													DASH													*/
/************************************************************************************************************/

dash_main()
{
	state_functions = [];
	state_functions[ "hidden" ] 	= ::dash_state_hidden;
	state_functions[ "alert" ] 		= maps\_stealth_behavior::enemy_state_alert;
	state_functions[ "spotted" ] 	= maps\_stealth_behavior::enemy_state_spotted;
		
	//intro guys
	array_thread( getentarray( "dash_intro_guy", "targetname" ), ::add_spawn_function, ::stealth_ai, state_functions );
	array_thread( getentarray( "dash_intro_runner", "script_noteworthy" ), ::add_spawn_function, ::dash_intro_runner );
	array_thread( getentarray( "dash_intro_patroller", "script_noteworthy" ), ::add_spawn_function, ::dash_intro_patrol );
	array_thread( getentarray( "dash_intro_guy2", "targetname" ), ::add_spawn_function, ::stealth_ai, state_functions );
	array_thread( getentarray( "dash_stander", "targetname" ), ::add_spawn_function, ::stealth_ai, state_functions );
	array_thread( getentarray( "dash_stander", "targetname" ), ::add_spawn_function, ::dash_stander );
	
	//random
	array_thread( getentarray( "dash_bus_guys", "targetname" ), ::add_spawn_function, ::stealth_ai, state_functions );
	array_thread( getentarray( "dash_bus_idler", "script_noteworthy" ), ::add_spawn_function, ::dash_idler );	
	array_thread( getentarray( "dash_bus_runner", "script_noteworthy" ), ::add_spawn_function, ::deleteOntruegoal );	
	
	array_thread( getentarray( "dash_crawl_patroller", "script_noteworthy" ), ::add_spawn_function, ::stealth_ai, state_functions );
	array_thread( getentarray( "dash_crawl_patroller", "script_noteworthy" ), ::add_spawn_function, ::dash_crawl_patrol );
	
	array_thread( getentarray( "dash_on_road_guy", "targetname" ), ::add_spawn_function, ::stealth_ai, state_functions );
	array_thread( getentarray( "dash_on_road_guy", "targetname" ), ::add_spawn_function, ::deleteOntruegoal );
	array_thread( getentarray( "dash_on_road_guy2", "targetname" ), ::add_spawn_function, ::stealth_ai, state_functions );
	array_thread( getentarray( "dash_on_road_guy2", "targetname" ), ::add_spawn_function, ::deleteOntruegoal );
	
	array_thread( getentarray( "dash_last_runner", "targetname" ), ::add_spawn_function, ::stealth_ai );
	array_thread( getentarray( "dash_last_runner", "targetname" ), ::add_spawn_function, ::deleteOntruegoal );
	
	//guys in cars
	array_thread( getentarray( "dash_patroller", "targetname" ), ::add_spawn_function, ::stealth_ai, state_functions );
	array_thread( getentarray( "dash_idler", "targetname" ), ::add_spawn_function, ::stealth_ai, state_functions );
	array_thread( getentarray( "dash_patroller", "targetname" ), ::add_spawn_function, ::dash_ai );
	array_thread( getentarray( "dash_idler", "targetname" ), ::add_spawn_function, ::dash_ai );
	
	alert_functions = [];
	alert_functions[ "reset" ] = ::dash_sniper_alert;
	alert_functions[ "alerted_once" ] = ::dash_sniper_alert;
	alert_functions[ "alerted_again" ] = ::dash_sniper_attack;
	alert_functions[ "attack" ] = ::dash_sniper_attack;
	
	//sniper
	array_thread( getentarray( "dash_sniper", "targetname" ), ::add_spawn_function, ::stealth_ai, undefined, alert_functions );
	array_thread( getentarray( "dash_sniper", "targetname" ), ::add_spawn_function, ::dash_sniper_death );
		
	//nodes that set flags
	array_thread( getentarray( "dash_guard_check", "script_noteworthy" ), ::dash_run_check );
		
	thread dash_handle_nosight_clip();
	thread dash_handle_heli();
	thread dash_handle_stealth_unsure();
	
	flag_wait( "initial_setup_done" );
	flag_wait( "dash" );
	
	level.price stop_magic_bullet_shield();	
	level.price.maxhealth = 1;
	level.price.health = 1;	
	
	level.price dash_holdup();
	if( !flag( "dash_stealth_unsure" ) )	
		autosave_by_name( "dash_start" );	
	level.price dash_run();
	if( !flag( "dash_stealth_unsure" ) )	
		autosave_by_name( "dash_run" );
	level.price dash_crawl();
	level.price dash_last();
	level.price dash_sniper();
	
	if( !flag( "dash_stealth_unsure" ) )	
		autosave_by_name( "dash_run" );
	
	level.price.moveplaybackrate = 1;
	level.price clear_run_anim();	
	level.price allowedstances( "stand", "crouch", "prone" );
	
	if( flag( "_stealth_spotted" ) )
	{
		flag_waitopen( "_stealth_spotted" );
		level thread function_stack(::radio_dialogue, "scoutsniper_mcm_getuskilled" );
	}
	else
		level thread function_stack(::radio_dialogue, "scoutsniper_mcm_moveout" );	
	
	flag_set( "town" );
}

dash_holdup()
{		
	self pushplayer( true );
	
	node = getnode("dash_price_start_node", "targetname");
	
	self follow_path( node, 200 );
	
	thread dash_fake_easy_mode();
		
	flag_set( "dash_start" );
	
	if( flag( "_stealth_spotted" ) )
		return;
	level endon( "_stealth_spotted" );
	
	
	
	wait 1;
	
	doorR = getent( "dash_door_right", "script_noteworthy" );	
	doorL = getent( "dash_door_left", "script_noteworthy" );	
	doorR dash_door_slow( 1 );
	
	level thread function_stack(::radio_dialogue, "scoutsniper_mcm_mysignal" );	
}

dash_run()
{
	if( flag( "_stealth_spotted" ) )
		return;
	level endon( "_stealth_spotted" );
	
	doorR = getent( "dash_door_right", "script_noteworthy" );	
	doorL = getent( "dash_door_left", "script_noteworthy" );
	
	self.moveplaybackrate = 1.25;
	self set_generic_run_anim( "sprint" );	
	
	wait 8;
	
	thread dialogprint( "Price - Hoooold....", 3 );
	
	wait 6.5;
	
	delaythread( 1, ::music_play, "scoutsniper_dash_music" );
	level thread function_stack(::radio_dialogue, "scoutsniper_mcm_okgo" );
	
	wait .5;
	
	doorR thread dash_door_fast( .35 );
	doorL thread dash_door_fast( -1.35 );
/*	
	node = getnode( "dash_price_node1", "targetname" );
	self follow_path( node );
	
	level function_stack(::radio_dialogue, "scoutsniper_mcm_waithere" );
	
	wait 4;
	level function_stack(::radio_dialogue, "scoutsniper_mcm_donteven" );
	
	flag_wait_all( "dash_guard_check1", "dash_guard_check2", "dash_guard_check3" );
		
	level thread function_stack(::radio_dialogue, "scoutsniper_mcm_readygo" );*/
	
	node = getnode( "dash_price_node2", "targetname" );
	self thread follow_path( node );
	
	self waittill( "goal" );
	level thread function_stack(::radio_dialogue, "scoutsniper_mcm_stickwithme" );
	self waittill( "path_end_reached" );
	/*wait .5;
	
	node = getnode( "dash_price_node3", "targetname" );
	self.ref_node.origin = node.origin;
	self.ref_node.angles = node.angles + (0,-90,0);
	
	
	self.ref_node thread anim_generic( self, "onme_cornerR" );
	self.ref_node waittill("onme_cornerR");
	
	level thread function_stack(::radio_dialogue, "scoutsniper_mcm_standby" );
	self.ref_node thread anim_generic( self, "stop_cornerR" );
	self.ref_node waittill("stop_cornerR");*/
	
	wait 2;
}

dash_crawl()
{
	if( flag( "_stealth_spotted" ) )
		return;
	level endon( "_stealth_spotted" );
	
	self.moveplaybackrate = 1;
	self clear_run_anim();	
	
	node = getent( "dash_price_crawl_start", "targetname" );
	
	level thread function_stack(::radio_dialogue, "scoutsniper_mcm_letsgo2" );
	self thread crawl_path( node );
	
	trig = getent( "dash_crawl_patroller1", "target" );
	trig waittill( "trigger" );
	
	thread music_play( "scoutsniper_surrounded_music" );	
	
	trig = getent( "dash_crawl_firsttruck", "targetname" );
	trig waittill( "trigger" );
	thread dialogprint( "Price - There's a truck coming...we'll use it as cover, keep moving", 3 );
		
	self waittill( "path_end_reached" );
	
	flag_set( "dash_last" );
	
	thread dialogprint( "Price - Just wait here a moment.  When they leave, crawl out and stay low.", 3 );
	
	wait 21.5;
	
	level thread function_stack(::radio_dialogue, "scoutsniper_mcm_standbygo" );
	
	wait 2.5;
}

dash_last()
{
	if( flag( "_stealth_spotted" ) )
		return;
	level endon( "_stealth_spotted" );
	
	node = getnode( "dash_last_stretch1", "targetname" );
	
	vec = node.origin - self.origin;
	angles =  vectortoangles( vec );
	self.ref_node.origin = self.origin;
	self.ref_node.angles = ( 0, angles[ 1 ], 0 );
	
	//level thread function_stack(::radio_dialogue, "scoutsniper_mcm_go" );
	
	self.ref_node anim_generic( self, "crawl_loop" );
	self anim_generic( self, "prone2stand" );
	
	self allowedstances( "stand", "crouch", "prone" );
	
/*	self.ref_node.origin = node.origin;
	self.ref_node.angles = node.angles + (0,-90,0);
		
	self.ref_node anim_generic_reach_and_arrive( self, "onme_cornerR" );
	
	level thread function_stack(::radio_dialogue, "scoutsniper_mcm_staylow2" );
	self.ref_node thread anim_generic( self, "stop_cornerR" );
	self.ref_node waittill("stop_cornerR");
	
	wait 8;
	
	level thread function_stack(::radio_dialogue, "scoutsniper_mcm_readygo" );
		
	wait 2;*/
	
	self follow_path( node, 100 );
	
	if( !flag( "dash_stealth_unsure" ) )	
		autosave_by_name( "dash_last" );
	
	self.moveplaybackrate = 1.25;
	self set_generic_run_anim( "sprint" );		
	node = getnode( "dash_last_stretch2", "targetname" );
	
	level thread function_stack(::radio_dialogue, "scoutsniper_mcm_readygo" );
	
	wait .5;
	
	delaythread( 1, ::music_play, "scoutsniper_dash_music" );
	self follow_path( node );
	
	self.moveplaybackrate = 1;
	self clear_run_anim();
	
	wait 1;
	
	self.ref_node.origin = node.origin;
	self.ref_node.angles = node.angles + (0,-90,0);
	
	level thread function_stack(::radio_dialogue, "scoutsniper_mcm_holdfast" );
	self.ref_node thread anim_generic( self, "stop_cornerR" );
	self.ref_node waittill("stop_cornerR");
		
	wait .5;
	level thread function_stack(::radio_dialogue, "scoutsniper_mcm_coastclear" );
	
	wait .5;
	level thread function_stack(::radio_dialogue, "scoutsniper_mcm_letsgo" );
	self.ref_node thread anim_generic( self, "onme_cornerR" );
	self.ref_node waittill("onme_cornerR");
}

dash_sniper()
{
	if( flag( "_stealth_spotted" ) )
		return;
	level endon( "_stealth_spotted" );
	
	if( flag( "dash_sniper_dead" ) )
		return;
	level endon( "dash_sniper_dead" );
	
	node = getnode( "dash_lookout_node", "targetname" );
	//delay to give price a chance to face in the right direction...otherwise
	//since he's facing the wrong way - he thinks the player hasn't caught up
	//when in fact he's actually ahead
	self delaythread( 1, ::dynamic_run_speed ); 
	self follow_path( node );	
	self notify( "stop_dynamic_run_speed" );
		
	wait .5;
	
	self.ref_node.origin = node.origin;
	self.ref_node.angles = node.angles + (0,-90,0);
	
	level thread function_stack(::radio_dialogue, "scoutsniper_mcm_dontmove" );
	self.ref_node thread anim_generic( self, "stop_cornerR" );
	self.ref_node waittill("stop_cornerR");
	
	thread dialogprint( "Price - Sniper.  Balcony, 4th floor, dead ahead.", 2 );
	self.ref_node thread anim_generic( self, "enemy_cornerR" );
	self.ref_node waittill( "enemy_cornerR" );
	
	dialogprint( "Price - Take him out, or he'll give away our position", 3 );
	
	while( !flag( "dash_sniper_dead" ) )
	{
		wait randomfloatrange( 12, 15 );
		
		dialogprint( "Price - he's on the 4th floor balcony - look for his silhouette", 3 );		
	}
}

/************************************************************************************************************/
/*													TOWN													*/
/************************************************************************************************************/

town_main()
{
	flag_wait( "initial_setup_done" );
	flag_wait( "town" );
		
	thread dash_fake_easy_mode();
	
	flag_waitopen( "_stealth_spotted" );
	level.price town_moveup();
	level.price notify( "stop_dynamic_run_speed" );
	
	flag_waitopen( "_stealth_spotted" );
	level.price town_moveup2();
	level.price notify( "stop_dynamic_run_speed" );
	
	flag_waitopen( "_stealth_spotted" );
	while( !flag( "town_no_turning_back" ) )
	{
		level.price town_moveup3();
		level.price notify( "stop_dynamic_run_speed" );
		flag_waitopen( "_stealth_spotted" );	
	}
	
	if( !flag( "_stealth_spotted" ) )	
		autosave_by_name( "town" );
	
	level.player stealth_friendly_movespeed_scale_default();
	stealth_detect_ranges_default();
	
	flag_set( "dogs" );
}

town_moveup()
{
	if( flag( "_stealth_spotted" ) )
		return;
	level endon( "_stealth_spotted" );
	
	node = getnode( "town_moveup_node", "targetname" );	
	
	//delay to give price a chance to face in the right direction...otherwise
	//since he's facing the wrong way - he thinks the player hasn't caught up
	//when in fact he's actually ahead	
	self delaythread( .5, ::dynamic_run_speed );
	self follow_path( node );
		
	level thread function_stack(::radio_dialogue, "scoutsniper_mcm_go" );	
}

town_moveup2()
{
	if( flag( "_stealth_spotted" ) )
		return;
	level endon( "_stealth_spotted" );
	
	node = getnode( "town_moveup_node2", "targetname" );	
		
	self thread dynamic_run_speed();
	self follow_path( node, 180 );
	self notify( "stop_dynamic_run_speed" );
	
	wait .5;
	
	self.ref_node.origin = node.origin;
	self.ref_node.angles = node.angles + (0,-90,0);
	
	level thread function_stack(::radio_dialogue, "scoutsniper_mcm_areaclear" );
	self.ref_node thread anim_generic( self, "moveout_cornerR" );
	self.ref_node waittill("moveout_cornerR");
}

town_moveup3()
{
	if( flag( "_stealth_spotted" ) )
		return;
	level endon( "_stealth_spotted" );
	
	node = getnode( "town_moveup_node3", "targetname" );	
	
	self thread dynamic_run_speed();
	self follow_path( node, 400 );
	self notify( "stop_dynamic_run_speed" );	
	
	thread dialogprint( "Price - don't let your guard down, it's almost too quiet if you ask me.", 2 );
}

/************************************************************************************************************/
/*													DOGS													*/
/************************************************************************************************************/
dogs_main()
{
	array_thread( getentarray( "dogs_backup", "targetname" ), ::add_spawn_function, ::stealth_ai );
	array_thread( getentarray( "dogs_backup", "targetname" ), ::add_spawn_function, ::dogs_backup );
	array_thread( getentarray( "dogs_food", "script_noteworthy" ), ::add_spawn_function, ::dogs_food );
	array_thread( getentarray( "dogs_eater", "script_noteworthy" ), ::add_spawn_function, ::dogs_eater );
	array_thread( getentarray( "dogs_eater", "script_noteworthy" ), ::add_spawn_function, ::dogs_eater_death );
		
	flag_wait( "initial_setup_done" );
	
	flag_wait( "dogs" );
	
	level.price dogs_moveup();
	
	if( !flag( "_stealth_spotted" ) && !flag( "dogs_dog_dead" ) && !flag( "dogs_backup" ) )	
		autosave_by_name( "dogs1" );
	
	level.price dogs_sneakpast();
	
	flag_waitopen( "_stealth_spotted" );
	flag_waitopen( "dogs_dog_dead" );
	flag_waitopen( "dogs_backup" );
	
	flag_set( "center" );
	
	autosave_by_name( "dogs2" );
	
	level.price.ignoreme = true;
}

dogs_food()
{
	self.dieQuietly = true;
	self.deathanim = %covercrouch_death_1;
	self gun_remove();
	self dodamage( self.health + 300, self.origin );
}

dogs_eater()
{
	self endon( "death" );
	
	self.team = "neutral";
	node = getent( "dogs_eat_node", "targetname" );
	self.ref_node = node;
	self.ref_angles = node.angles;
	self.mode = "none";
	
	self linkto( node );
		
	while( 1 )
	{		
		if( distance( self.origin, level.player.origin) > 500 )
			self thread dogs_eater_eat();
		else
		if( distance( self.origin, level.player.origin) > 350 )
			self thread dogs_eater_growl();
		else	
		if( distance( self.origin, level.player.origin) > 200 )
			self thread dogs_eater_bark();
		else
			break;
		
		wait .1;
	}
	
	self unlink();
	
	self notify( "stop_loop" );
	self.ref_node notify( "stop_loop" );
	self stopanimscripted();
	self.team = "axis";
	self.favoriteenemy = level.player;
}

dogs_eater_death()
{
	level endon( "dogs_delete_dogs" );
	
	self waittill( "death" );
	
	self stoploopsound();
	
	flag_set( "dogs_dog_dead" );
	trigger_on( "dogs_backup", "target" );	
	
	flag_wait( "dogs_backup" );
	
	thread music_play( "scoutsniper_surrounded_music" );
	
	wait 3;
	
	thread dialogprint( "Price - that doesn't sound good.", 3 );
	
	flag_wait( "_stealth_spotted" );
	flag_waitopen( "_stealth_spotted" );
	
	flag_clear( "dogs_backup" );
	thread dialogprint( "Price - damn that was close.", 3 );
}

dogs_backup()
{
	flag_set( "dogs_backup" );
	flag_clear( "dogs_dog_dead" );
	
	self endon( "death" );
	
	if( isdefined( self.script_animation ) )
	{	
		self script_delay();	
		self playsound( "anml_dog_excited_distant" );
		wait randomfloatrange( 1.5, 3 );
	}
	else
		wait randomfloatrange( 4, 6 );
			
	self.ignoreall = false;
	self setthreatbiasgroup();
		
	if( randomint( 100 ) < 65 )
		self.favoriteenemy = level.player;	
	else
		self.favoriteenemy = level.price;
	
	level.price.ignoreme = false;
}

dogs_moveup()
{
	if( flag( "_stealth_spotted" ) )
		return;
	level endon( "_stealth_spotted" );	
	
	if( flag( "dogs_backup" ) )
		return;
	level endon( "dogs_backup" );
	
	if( flag( "dogs_dog_dead" ) )
		return;
	level endon( "dogs_dog_dead" );
		
	node = getnode( "dogs_moveup_node1", "targetname" );	
		
	self thread dynamic_run_speed();
	self thread follow_path( node );
	
	//node waittill( "trigger" );
	
	self waittill( "path_end_reached" );
	thread music_play( "scoutsniper_pripyat_music" );
	self notify( "stop_dynamic_run_speed" );
	
	wait .5;
	self enable_cqbwalk();
	
	self.ref_node.origin = self.origin;
	self.ref_node.angles = self.angles;
	
	level thread function_stack(::radio_dialogue, "scoutsniper_mcm_stop" );
	self.ref_node thread anim_generic( self, "stop2_exposed" );
	self.ref_node waittill("stop2_exposed");
	
	thread dialogprint( "Price - there's a dog further up the path.  I dont see any personnel, must be wild.", 3 );
	self.ref_node thread anim_generic( self, "enemy_exposed" );
	self.ref_node waittill("enemy_exposed");
	
	thread dialogprint( "Price - just leave it alone, no need to attract unnecessary attention.", 3 );
	
	node = getent( "dogs_moveup_node2", "targetname" );
	node anim_generic_reach( self, "cqb_look_around" );
	node anim_generic( self, "cqb_look_around" );
	
	node = getnode( "dogs_moveup_node3", "targetname" );
	self follow_path( node );
}

dogs_sneakpast()
{
	if( flag( "_stealth_spotted" ) )
		return;
	level endon( "_stealth_spotted" );	
	
	if( flag( "dogs_backup" ) )
		return;
	level endon( "dogs_backup" );
	
	if( flag( "dogs_dog_dead" ) )
		return;
	level endon( "dogs_dog_dead" );
		
	dialogprint( "Price - pooch doesn't look too friendly.", 2 );
	
	self.ref_node.origin = self.origin;
	self.ref_node.angles = self.angles;
	
	thread dialogprint( "Price - lets move around him, keep your distance.", 2 );
	self.ref_node thread anim_generic( self, "moveup_exposed" );
	self.ref_node waittill("moveup_exposed");
	
	node = getnode( "dogs_sneakpast", "targetname" );
	self follow_path( node, 200 );	
	
	node = self.last_set_goalnode;
	self.ref_node.origin = node.origin;
	self.ref_node.angles = node.angles + (0,-90,0);
	
	level function_stack(::radio_dialogue, "scoutsniper_mcm_clearright" );
	level thread function_stack(::radio_dialogue, "scoutsniper_mcm_go" );
	self.ref_node thread anim_generic( self, "moveout_cornerR" );
	self.ref_node waittill("moveout_cornerR");
}

/************************************************************************************************************/
/*													CENTER													*/
/************************************************************************************************************/
center_main()
{
	flag_wait( "initial_setup_done" );
	flag_wait( "center" );
	
	thread center_handle_heli();
	
	level.price center_moveup();
	
	flag_waitopen( "_stealth_spotted" );
	flag_waitopen( "dogs_dog_dead" );
	flag_waitopen( "dogs_backup" );
	
	level.price center_moveup2();
	
	flag_waitopen( "_stealth_spotted" );
	flag_waitopen( "dogs_dog_dead" );
	flag_waitopen( "dogs_backup" );
	
	flag_set( "dogs_delete_dogs" );
	trigger_off( "dogs_backup", "target" );	
	
	level.price center_moveup3();
	level.price center_moveup4();
	//level.price center_moveup5();
	
	flag_set( "end" );
}

center_handle_heli()
{
	msg = "kill_center_handle_heli_thread";
	level endon( msg );
	node = getent( "center_heli_path", "targetname" );
	
	glass = getentarray( "glass", "script_noteworthy" );
		
	node waittill( "trigger", heli );
	
	heli thread center_heli_quake( msg );
	thread center_heli_price();
	
	level thread notify_delay( msg, 10 );
	
	dist = 450;
	distsqrd = dist * dist;
	
	while( 1 )
	{
		breaks = [];
		for( i=0; i<glass.size; i++ )
		{
			if( distancesquared( heli.origin, glass[ i ].origin ) < distsqrd )
				breaks[ breaks.size ] = glass[ i ];
		}	
		
		glass = array_exclude( glass, breaks );
		
		array_thread( breaks, ::break_glass );
				
		wait .2;		
	}
}

center_heli_price()
{
	wait 4;
	
	thread dialogprint( "Price - jesus, I hate those things", 2 );
}

center_moveup()
{
	if( flag( "_stealth_spotted" ) )
		return;
	level endon( "_stealth_spotted" );	
	
	if( flag( "dogs_backup" ) )
		return;
	level endon( "dogs_backup" );
	
	if( flag( "dogs_dog_dead" ) )
		return;
	level endon( "dogs_dog_dead" );
	
	self disable_cqbwalk();
	self delaythread( .5, ::dynamic_run_speed );
	
	node = getnode( "center_node1", "targetname" );
	self follow_path( node );
	
	//thread music_play( "scoutsniper_stealth_01_music" );
	level thread function_stack(::radio_dialogue, "scoutsniper_mcm_forwardclear" );
}

center_moveup2()
{
	if( flag( "_stealth_spotted" ) )
		return;
	level endon( "_stealth_spotted" );	
	
	if( flag( "dogs_backup" ) )
		return;
	level endon( "dogs_backup" );
	
	if( flag( "dogs_dog_dead" ) )
		return;
	level endon( "dogs_dog_dead" );
	
	
	node = getnode( "center_node2", "targetname" );
	self thread follow_path( node );
	
	if( distance( self.origin, node.origin ) > 700 )
	{
		self disable_cqbwalk();
		self delaythread( .5, ::dynamic_run_speed );
	}
	else
		self enable_cqbwalk();
	
	node waittill( "trigger" );
	self notify( "stop_dynamic_run_speed" );
	self enable_cqbwalk();
	 
	self waittill( "path_end_reached" );
	level thread function_stack(::radio_dialogue, "scoutsniper_mcm_moveup" );
}

center_moveup3()
{
	self disable_cqbwalk();
	
	node = getnode( "center_node4", "targetname" );
	self thread follow_path( node, 325 );
	
	node waittill( "trigger" );
	thread music_play( "scoutsniper_deadpool_music" );
		
	self notify( "stop_dynamic_run_speed" );
	self enable_cqbwalk();
	
	wait 2;
	
	level thread function_stack(::radio_dialogue, "scoutsniper_mcm_ghosttown" );	
			
	self waittill( "path_end_reached" );
}

center_moveup4()
{
	self disable_cqbwalk();
	
	node = getnode( "center_node5", "targetname" );
	self follow_path( node, 200 );
	
	wait .25;
	
	self.ref_node.origin = node.origin;
	self.ref_node.angles = node.angles + (0,-90,0);
	
	level thread function_stack(::radio_dialogue, "scoutsniper_mcm_move" );
	self.ref_node thread anim_generic( self, "moveout_cornerR" );
	self.ref_node waittill("moveout_cornerR");
	
	self enable_cqbwalk();
		
	node = getnode( "center_node6", "targetname" );
	self follow_path( node );
}

/************************************************************************************************************/
/*													END														*/
/************************************************************************************************************/

end_main()
{
	flag_wait( "initial_setup_done" );
	flag_wait( "end" );
	
	level.price end_moveup();
	
	maps\_loadout::SavePlayerWeaponStatePersistent( "scoutsniper" );
	missionsuccess( "sniperescape", true );
}

end_moveup()
{
	node = getnode( "end_node_look", "targetname" );
	level thread function_stack(::radio_dialogue, "scoutsniper_mcm_letsgo" );
	
	self disable_cqbwalk();
	self delaythread( .25, ::dynamic_run_speed );
	
	self follow_path( node, 200 );
	
	level function_stack(::radio_dialogue, "scoutsniper_mcm_thereshotel" );
}

/************************************************************************************************************/
/*												OBJECTIVES													*/
/************************************************************************************************************/

objective_main()
{
	flag_wait( "intro" );
	wait 14;
	//hotel_entrance = getent( "hotel_entrance", "targetname" );
	objective_add( 1, "active", "Follow Cpt. MacMillan" );
	objective_current( 1 );
	thread objective_price();
}

objective_price()
{
	while( isalive( level.price ) )
	{
		objective_position( 1, level.price.origin );
		wait .05;
	}
}

/************************************************************************************************************/
/*											START POINT INITS												*/
/************************************************************************************************************/

turn_off_triggers()
{
	/*switch(level.start_point)
	{
		"field":{
		}
				
	}*/
}

start_intro()
{
	start_common();
	
	flag_set( "initial_setup_done" );
}

start_church()
{
	start_church_x();
	
	array_thread( getentarray( "tableguards", "script_noteworthy" ), ::add_spawn_function, ::stealth_ai);
	array_thread( getentarray( "tableguards", "script_noteworthy" ), ::add_spawn_function, ::idle_anim_think);
	array_thread( getentarray( "tableguard_last_patrol", "targetname" ), ::add_spawn_function, ::intro_lastguy_think);
	
	delaythread( .1, ::scripted_array_spawn, "tableguards", "script_noteworthy", true );
	delaythread( .1, ::scripted_array_spawn, "intro_dogs", "script_noteworthy", true );
	
	flag_set( "initial_setup_done" );
}

start_church_x()
{
	start_common();
	
	level.price teleport_actor( getnode( "church_price_node1", "targetname" ) );
	teleport_player( "church" );
	
	flag_set( "initial_setup_done" );
	thread flag_set_delayed( "intro_last_patrol", 2 );
	thread flag_set_delayed( "intro_left_area", .5 );
}

start_graveyard()
{
	start_graveyard_x();
	
	array_thread( getentarray( "tableguards", "script_noteworthy" ), ::add_spawn_function, ::stealth_ai);
	array_thread( getentarray( "tableguards", "script_noteworthy" ), ::add_spawn_function, ::idle_anim_think);
	array_thread( getentarray( "tableguard_last_patrol", "targetname" ), ::add_spawn_function, ::intro_lastguy_think);
	
	delaythread( .1, ::scripted_array_spawn, "tableguards", "script_noteworthy", true );
	delaythread( .1, ::scripted_array_spawn, "intro_dogs", "script_noteworthy", true );
}

start_graveyard_x()
{
	start_common();
	
	door = getent("church_door_front", "targetname");
	door thread door_open_slow();
	
	level.price teleport_actor( getnode( "church_price_backdoor_node", "targetname" ) );
	teleport_player( "graveyard" );
	
	flag_set( "initial_setup_done" );
	thread flag_set_delayed( "graveyard_moveup", 1 );
	thread music_play( "scoutsniper_pripyat_music" );
}

start_field()
{
	start_common();
	
	level.price teleport_actor( getnode( "price_field_start", "targetname" ) );
	teleport_player();
	
	waittillframeend;//wait for price to have a magic bullet shield before we take it away
	
	flag_set( "initial_setup_done" );
	flag_set( "field" );
}

start_pond()
{
	start_common();
	
	waittillframeend;
	
	trig = getent( "pond_guys_trig", "targetname" );
	trig notify( "trigger" );
	
	level.price teleport_actor( getent( "field_price_clear", "targetname" ) );
	
	waittillframeend;
	
	teleport_player();
	
	flag_set( "initial_setup_done" );
	flag_set( "field_price_done" );
	flag_set( "pond" );
}

start_cargo()
{
	start_common();
	
	trigger_off( "pond_backup", "target" );
	waittillframeend;
	
	level.price teleport_actor( getnode( "cargo_price_node1", "targetname" ) );
	teleport_player();
	
	flag_set( "initial_setup_done" );
	flag_set( "cargo" );	
}

start_dash()
{
	start_common();
		
	level.price teleport_actor( getnode( "dash_price_start_node", "targetname" ) );
	teleport_player();
	
	waittillframeend;//wait for price to have a magic bullet shield before we take it away
	
	flag_set( "initial_setup_done" );
	flag_set( "dash" );
}

start_town()
{
	start_common();
	
	/*
	alert_functions = [];
	alert_functions[ "reset" ] = ::dash_sniper_alert;
	alert_functions[ "alerted_once" ] = ::dash_sniper_alert;
	alert_functions[ "alerted_again" ] = ::dash_sniper_attack;
	alert_functions[ "attack" ] = ::dash_sniper_attack;
	
	//sniper
	array_thread( getentarray( "dash_sniper", "targetname" ), ::add_spawn_function, ::stealth_ai, undefined, alert_functions );
	array_thread( getentarray( "dash_sniper", "targetname" ), ::add_spawn_function, ::dash_sniper_death );
	*/
	
	trigger_off( "dash_sniper", "target" );
	waittillframeend;
		
	level.price teleport_actor( getnode( "town_moveup_node", "targetname" ) );
	teleport_player();
	
	waittillframeend;//wait for price to have a magic bullet shield before we take it away
	
	flag_set( "initial_setup_done" );
	flag_set( "town" );
}

start_dogs()
{
	start_common();
	
	level.price teleport_actor( getnode( "dogs_moveup_node1", "targetname" ) );
	teleport_player();
	
	flag_set( "initial_setup_done" );
	flag_set( "dogs" );
}

start_center()
{
	start_common();
	
	level.price teleport_actor( getnode( "center_node1", "targetname" ) );
	teleport_player();
	
	flag_set( "initial_setup_done" );
	flag_set( "center" );
}

start_end()
{
	start_common();
	
	level.price teleport_actor( getnode( "center_node_last", "targetname" ) );
	teleport_player();
	
	flag_set( "initial_setup_done" );
	flag_set( "end" );
}

start_common()
{
	initLevel();
	initPlayer();
	initPrice();
	initDogs();
	turn_off_triggers();
	miscprecache();
	
	thread clean_previous_ai( "field_clean_ai" );//complete clean
	thread clean_previous_ai( "cargo", "field_guard", "script_noteworthy" );
	thread clean_previous_ai( "cargo", "field_guard2", "script_noteworthy" );
	thread clean_previous_ai( "dash", "pond_patrol", "script_noteworthy" );
	thread clean_previous_ai( "dash", "pond_throwers", "script_noteworthy" );
	thread clean_previous_ai( "dash", "pond_backup", "script_noteworthy" );
	thread clean_previous_ai( "dash_clean_ai", "cargo_smokers", "script_noteworthy" );
	thread clean_previous_ai( "dash_clean_ai", "cargo_patrol_defend1", "script_noteworthy" );
	thread clean_previous_ai( "dash_clean_ai", "cargo_patrol_defend2", "script_noteworthy" );
	thread clean_previous_ai( "dash_clean_ai", "cargo_sleeper", "script_noteworthy" );	
	thread clean_previous_ai( "town_no_turning_back" );//complete clean	
	thread clean_previous_ai( "dogs_delete_dogs" );//complete clean	
				
	array_thread( getentarray( "fake_radiation", "targetname" ), ::fake_radiation );
	
	//this is valid - it turns off the spawning trigger for the dogs sequence
	trigger_off( "dogs_backup", "target" );
	
	//eventually remove these from the map file - these are dash spawners that need to be removed
	trigger_off( "dash_bus_guys", "target" );
	trigger_off( "dash_last_runner", "target" );
	trigger_off( "dash_on_road_guy", "target" );
}

miscprecache()
{
	precacheitem( "flash_grenade" );
	precacheItem( "hind_FFAR" );
	precacheModel( "tag_origin" );
	precacheModel( "vehicle_bm21_mobile_cover" );
	precacheString( &"SCRIPT_ARMOR_DAMAGE" );
}

initLevel()
{
	level.cosine["180"] = cos(180);
	level.minBMPexplosionDmg = 50;
	level.maxBMPexplosionDmg = 100;
	level.bmpCannonRange = 2048;
	level.bmpMGrange = 850;
	level.bmpMGrangeSquared = level.bmpMGrange * level.bmpMGrange;
	
	thread maps\_radiation::main();
	thread updateFog();//should move this into a fcuntion closer to where it happens
	
	battlechatter_off( "allies" );
	battlechatter_off( "axis" );
	
	array_thread( getentarray( "clip_nosight", "targetname" ), ::clip_nosight_logic );
	
	createthreatbiasgroup( "price" );
	createthreatbiasgroup( "dog" );
	setignoremegroup( "price", "dog" );
}

initPlayer()
{
	level.player setthreatbiasgroup( "allies" );
	level.player thread stealth_ai();
	thread player_health_shield();
}

giveweapons()
{
	level.player enableweapons();
	
}

player_health_shield()
{
	level.player enableHealthShield( false );
	
	while(1)
	{
		level.player waittill("death");
		level.player enableHealthShield(true);
	}	
}

initPrice()
{
	spawner = getent( "price", "script_noteworthy" );
	level.price = spawner dospawn();
	level.price.ref_node = spawn("script_origin", level.price.origin);
	spawn_failed( level.price );
	assert( isDefined( level.price ) );
	
	level.price.fixednode = false;	
	level.price.ignoreall = true;
	level.price.ignoreme = true;
	level.price disable_ai_color();
	
	level.price setthreatbiasgroup( "allies" );
	level.price thread stealth_ai();
	
	level.price.animname = "price";
	level.price thread magic_bullet_shield();
	level.price make_hero();
	level.price thread price_death();
	level.price setthreatbiasgroup( "price" );
}

