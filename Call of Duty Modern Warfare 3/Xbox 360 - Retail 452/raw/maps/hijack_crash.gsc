#include maps\_utility;
#include maps\_shg_common;
#include common_scripts\utility;
#include maps\_anim;
#include maps\_audio;
#include maps\_vehicle;
#include maps\hijack_code;

// JumpTo
//---------------------------------------------------------------------------------------------------------------------
start_crash()
{
	//level.player EnableWeapons();
	level.player GiveWeapon( "fnfiveseven" );
	level.player SwitchToWeapon( "fnfiveseven" );
	
	maps\_compass::setupMiniMap("compass_map_dcemp_static", "crash_minimap_corner");
	setsaveddvar( "compassmaxrange", 50000 ); //default is 3500
	
	flag_set("show_crash_model");
	
	level.door3 = getent( "intro_door3" , "targetname");
	level.door3 MoveY( 50, .1);
	
	//spawn everyone
	level.commander = spawn_ally("commander");
	level.president = spawn_ally("president");	
	level.hero_agent_01 = spawn_ally("hero_agent_01" );
	level.advisor   = spawn_ally("advisor", "end_scene_advisor");
	level.daughter = spawn_targetname( "find_daughter_pre_crash" );
	
	level.hero_agent_01 disable_ai_color();
	
	//hack: force commander to cyan during crash for now
	level.commander set_force_color("c");
	level.commander enable_ai_color();
	
	level.daughter_struct = GetStruct("cargo_room_anim_struct","targetname");
	pres_and_daughter = [];
	pres_and_daughter[0] = level.president;
	pres_and_daughter[1] = level.daughter;
	level.daughter_struct thread anim_loop(pres_and_daughter,"post_find_loop");
	flag_set("find_daughter_moment_finished");
	aud_send_msg("cargo_room_zone_off");
	
	level.daughter_struct thread anim_loop_solo(level.commander,"find_daughter_commander_loop" ); 
	
	//level.crash_agent_1 = spawn_ally("crash_agent_1", "crash_crash_agent_1");
	//waittillframeend;
		
	player_start_struct = GetStruct( "player_start_crash", "targetname" );
	level.player setOrigin( player_start_struct.origin );
	level.player setPlayerAngles( player_start_struct.angles );
	
	//level.player EnableWeapons();
	level.player GiveWeapon( "fnfiveseven" );
	level.player SwitchToWeapon( "fnfiveseven" );
	
	//spawn secret service guys
	hero_agent_node = GetNode("hero_agent_crash_node","targetname");
	level.hero_agent_01 teleport_ai(hero_agent_node);
	level.hero_agent_01 SetGoalNode(hero_agent_node);
	
	thread setup_jump_to_rollers();
	
	thread maps\hijack_crash_fx::handle_crash_lights();	
	thread maps\hijack_crash_fx::pre_sled_light();
	thread open_cargo_door();
	
	thread pre_plane_crash();
	thread maps\hijack::setup_cloud_tunnel();
	thread crash_objectives();
		
	main();

	level waittill("crash_teleport");
	level.daughter_struct notify("stop_loop");	
}

crash_init_flags()
{
	flag_init("stop_managing_crash_player");
	flag_init("crash_throw_player");
	flag_init("hero_agent_ready_for_crash");
	flag_init("commander_finished_wake_up_anim");
	flag_init("stop_sun_crash_lerp");
	flag_init("tower_is_down");
}

/*---------------------------------------------------
	
	               Plane Crash
	
----------------------------------------------------*/

crash_objectives()
{
	objective_add( obj("escape_pod"), "current", &"HIJACK_OBJ_ESCAPE_HATCH", level.hero_agent_01.origin );
	Objective_OnEntity( obj("escape_pod"), level.hero_agent_01, (0, 0, 70));

	level waittill("crash_teleport");
	objective_state( obj("escape_pod"), "failed" );
}

#using_animtree( "animated_props" );
pre_plane_crash()
{
	aud_send_msg("approaching_ground");
	
	// Don't know that we want this for ship?  It's handy for dev, though.
	thread autosave_by_name( "pre_crash" );
	
	thread plane_rumbling();
	thread maps\hijack_airplane::stop_combat();
	
		
	
	//hero_agent_node = GetNode("hero_agent_crash_node","targetname");
	//level.hero_agent_01 SetGoalNode(hero_agent_node);	
	
	//old_plane_models[0] thread anim_reach_solo( level.hero_agent_01, "planecrash_agent1", "tag_agent" );
	
	
	// wait till player moves through door, then get the commander into the door
	flag_wait("player_is_in_crash_room");
	
	thread enemy_pre_crash_chatter();

	//level.commander thread commander_pre_crash_door_anim();
	
	flag_wait( "player_is_in_end_room" );
	
	//plane_crash_airmask = getentarray( "plane_crash_airmask", "script_noteworthy" );
	//array_thread( plane_crash_airmask, ::airmask_think );
			
}

commander_pre_crash_door_anim()
{
	level.commander endon("start_crash_anim");
	level.daughter_struct notify( "stop_loop" );
	level.commander StopAnimScripted();
	anim_struct = GetStruct("cargo_room_anim_struct","targetname");
	anim_struct anim_reach_solo(level.commander, "door1");
	anim_struct anim_single_solo(level.commander,"door1");
	
	level.commander thread anim_loop_solo(level.commander, "corner_standL_alert_twitch04", "stop_door_loop");
}

crash_room_door_blocker()
{

	crash_door_blocker2 = getent("crash_door_blocker_2", "targetname");
	crash_door_blocker2 NotSolid();
	
	flag_wait_any("start_plane_crash_aisle_1", "start_plane_crash_aisle_2");
	
	crash_door_blocker2 Solid();
	
	
}

#using_animtree( "animated_props" );
open_cargo_door()
{
	//have the agent open the door
	foreach(model in level.crash_models)
	{
		model.animname = "generic";
		model UseAnimTree(#animtree);	
	}
	
	props = getent("hijack_crash_model_props", "script_noteworthy");
	props thread anim_loop_solo(props, "hijack_pre_plane_crash_compartments", "stop loop");
	
	doorprop = getent("hijack_crash_model_front_interior", "script_noteworthy");
	aud_send_msg("pre_crash_door");
	doorprop anim_single_solo(doorprop, "hijack_pre_plane_crash_door");
	
	
	crash_door_blocker = getent("crash_door_blocker", "targetname");
	crash_door_blocker NotSolid();
	
	thread crash_room_door_blocker();
		
	flag_wait("player_is_in_crash_room");
	crash_door_blocker solid();
	
	doorprop anim_single_solo(doorprop, "hijack_pre_plane_crash_door_close");	
}

start_plane_crash()
{	
	//wait(1);
	
	thread main();
	//thread maps\hijack_airplane::airplane_cleanup();
}


// NOTE: Setup and running the rollers is kind of interleaved into other logic.  May want to break all of those things out
//	so can easily call into the needed parts without duplicating so much code.  Not sure how permanent any of that stuff is, though.
//---------------------------------------------------------------------------------------------------------------------
setup_jump_to_rollers()
{
	level.org_view_roll = getent("org_view_roll", "targetname");
	assert(isdefined(level.org_view_roll));
	level.player playerSetGroundReferenceEnt(level.org_view_roll);
	level.aRollers = [];
	level.aRollers = array_add(level.aRollers, level.org_view_roll);
	
	thread plane_rumbling();
	array_thread(level.aRollers, ::rotate_rollers_roll, -10, 1, 0, 0);
	wait(1);
	array_thread(level.aRollers, ::rotate_rollers_roll, 20, 1.5, 0, 0);
	wait(1.5);
	array_thread(level.aRollers, ::rotate_rollers_roll, -10, 1, 0, 0);	
	level waittill("planecrash_approaching");
	
	//array_thread(level.aRollers, ::rotate_rollers_roll, -30, 2, 0, 0);	
	
	
}


//---------------------------------------------------------------------------------------------------------------------
#using_animtree( "animated_props" );
main()
{	
	//find our reference entity in the bsp tail that matches the model's origin
	//level.bsp_crash_scene_origin = getstruct("crash_scene_origin_bsp", "targetname");
	
	thread handle_crash_enemies();	
	thread maps\hijack_crash_fx::handle_crash_fx();

	//level.hero_agent_01 thread hero_agent_node();
	level.hero_agent_01 hero_agent_prepare_for_crash(level.crash_models[0]);
		
	//wait until we enter one aisle or another
	flag_wait_any("start_plane_crash_aisle_1", "start_plane_crash_aisle_2");	
	
	thread maps\hijack_airplane::airplane_cleanup();
		
	// decide which tag to attach the player onto...
	level.using_aisle_1 = false;
	attach_tag = "tag_player1_rotate";
	reference_struct_front = GetStruct("struct_aisle2_front", "targetname");
	reference_struct_back = GetStruct("struct_aisle2_back", "targetname");
	
	reference_struct_left = GetStruct("struct_aisle2_left", "targetname");
	reference_struct_right = GetStruct("struct_aisle2_right", "targetname");
	
	
	if (flag("start_plane_crash_aisle_1"))
	{
		level.using_aisle_1 = true;
	//	attach_tag = "tag_player1_rotate";
		//reference_struct_front = GetStruct("struct_aisle1_front", "targetname");
		//reference_struct_back = GetStruct("struct_aisle1_back", "targetname");
	}	
		
	delayThread(0.75, ::quickfade, 0.05);
	
	
	//spawn a new crash model since it seems to take a frame to get into place, and that would leave the player staring at skybox for a frame
	old_plane_models = level.crash_models; 
	i=0;
	foreach(model in old_plane_models)
	{
		level.crash_models[i] = spawn("script_model",(0,0,0));
		level.crash_models[i] SetModel(old_plane_models[i].model);
		level.crash_models[i].animname = "generic";
		level.crash_models[i] UseAnimTree(#animtree);
		if(isdefined(model.script_noteworthy))
		{
			level.crash_models[i].script_noteworthy = model.script_noteworthy + "_new";
		}
	
		i++;
	}		
		

	old_plane_models[0] UseAnimTree(#animtree);
	old_plane_models[0].animname = "generic";
	//get the final destination model into position
	plane_crash_anim_firstframe(level.crash_models);
	
	// create intermediate entity so we can pass it to SetGroundRefEnt, otherwise could do without this extra step
	tag_origin_player_link = spawn_tag_origin();
	attach_tag = "tag_player1_rotate";
	if(!level.using_aisle_1)
	{
		//attach_tag = "tag_player2_rotate";
	}
	
	calculate_plane_movement_limits(old_plane_models[0], attach_tag);
	
	                                
	tag_origin_player_link LinkTo(level.crash_models[0], attach_tag, (0, 0, 0), (0, 0, 0));
	level.groundent = tag_origin_player_link;
	level.player PlayerSetGroundReferenceEnt(tag_origin_player_link);
	level.attach_tag = attach_tag;		
	
	level notify("planecrash_approaching");
		
	
	level notify("crash_lights_out");
	
	//get agent 1 into position relative to the old model
	//level.hero_agent_01.animname = "generic";
	
	//old_plane_models[0] anim_reach_solo( level.hero_agent_01, "planecrash_agent1", "tag_agent" );
	
	//level.hero_agent_01 waittill("goal");
	//waittill_multiple_ents(level.hero_agent_01, "goal", level.crash_agent_1, "goal");
	wait_for_agents_to_align_for_crash();
	level.hero_agent_01.ignoreall = true;
	
		
	// figure out a rough position in the anims.  This is only a coarse approx, unfortunately.
	//	NOTE: might be possible to set the anim time to the start and end of the anim and query the tag pos
	//		at each point...that should be basically exact? 
	//	ALSO NOTE: left/right perc is not calculated but could be.  The aisles are so narrow right now that
	//		it might not even be noticed, especially since some kind of screen flash to cover everything up might
	//		be needed anyway?
	
	thread handle_crash_sunlight();
	
	//rumble, camera shake\
	Earthquake( 0.3, 1.2, level.player.origin, 200000 );
	
	//fade out momenarily to hide the teleport		
	thread quickfade(0.05);
	flag_clear( "in_flight" );
	
	//turn off the fill lights so we're not going over fx limits
	//level notify("crash_stop_pre_sled_lights");
		
	wait .05;
	
	
	fwd_percent = (reference_struct_front.origin[0] - level.player.origin[0]) /
					(reference_struct_front.origin[0] - reference_struct_back.origin[0]);
	fwd_percent = clamp(fwd_percent, 0.0, 1.0);
	
	right_percent = (reference_struct_left.origin[1] - level.player.origin[1]) /
					(reference_struct_left.origin[1] - reference_struct_right.origin[1]);
	right_percent = clamp(right_percent, 0.0, 1.0);
	

	//hack: take advantage of the fact that plane is facing down -X axis
	//current_fwd_pct = (level.player.origin[0] - level.back_point[0]) / (level.fwd_point[0] - level.back_point[0]);
	
//	current_right_pct = (level.player.origin[1] - level.left_point[1]) / (level.right_point[1] - level.left_point[1]);
		
	//do the actual teleport of the player, agents, and both of the agents
	teleport_crash_ents(old_plane_models[1], level.crash_models[1]);
	maps\_compass::setupMiniMap("compass_map_dcemp_static", "crash_minimap_corner");
	setsaveddvar( "compassmaxrange", 50000 ); //default is 3500
	
	level.player PlayRumbleloopOnEntity( "hijack_plane_medium" );
	
	level.hero_agent_01 thread handle_hero_agent_crash();
	level.commander thread handle_commander_crash();
		
	level notify("crash_teleport");
	
	//thread maps\hijack_code::fade_in(.05);
	
	
			
	

	// NOTE: Order is important...Must start plane anim first...
	//	player control anims are started after in crash_manage_player_position
	thread plane_crash_anim(level.crash_models);
	//thread crash_manage_player_position(level.crash_models[0], fwd_percent, level.using_aisle_1);
	thread crash_manage_player_position_new(level.crash_models[0], fwd_percent, right_percent, level.using_aisle_1);	
	
	
	thread crash_hit_throw_player(level.crash_models[0]);
	
	
	flag_wait("stop_managing_crash_player");	
	
	//sets up commander, secret service etc. outside the plane
	transition_to_tarmac();
}

calculate_plane_movement_limits(model, attach_tag)
{
	//figure out the extents of the player's movement by just setting the animation to those values.
	fwd_anim= %hijack_plane_crash_player_move_forward;
	right_anim= %hijack_plane_crash_player_move_right;	
	
	tag_origin = spawn_tag_origin();
	tag_origin LinkTo(model, attach_tag, (0,0,0), (0,0,0));
		
	model SetAnim(fwd_anim, 1, 0, 0 );
	model SetAnim(right_anim, 1, 0, 0 );
	
	waittillframeend;
	
	model SetAnimTime(fwd_anim, 1.0);
	waittillframeend;	
	level.fwd_point = model GetTagOrigin(attach_tag);
	
	model SetAnimTime(fwd_anim, 0.0);	
	waittillframeend;
	level.back_point = model GetTagOrigin(attach_tag);
	
	model SetAnimTime(right_anim, 1.0);
	waittillframeend;
	level.right_point = model GetTagOrigin(attach_tag);
	
	model SetAnimTime(right_anim, 0.0);	
	waittillframeend;
	level.left_point = model GetTagOrigin(attach_tag);
	
}

hero_agent_prepare_for_crash(planemodel)
{
	
	//hero_agent_crash_node = getnode("hero_agent_crash_node", "targetname");
	//hero_agent_crash_node waittill("trigger");
	//self waittill("goal");
	//waittill_true_goal(hero_agent_crash_node.origin, 45);
	level.hero_agent_01.animname = "generic";
	level.hero_agent_01.disablearrivals = true;
	level.hero_agent_01.disableexits = true;
	planemodel anim_reach_solo( level.hero_agent_01, "planecrash_agent1", "tag_agent" );
	
	flag_set("hero_agent_ready_for_crash");
}
	
	
wait_for_agents_to_align_for_crash()
{
	//level.commander waittill("goal");
	//level.crash_models[0] anim_reach_solo(level.commander, "commander_blocks_door_right", "j_mid_section");
	//commander_blocks_door_right
	//flag_wait("hero_agent_ready_for_crash");
}

pre_crash_radio_vo(model)
{
	model waittillmatch("single anim", "vo_line");
	radio_dialogue("hijack_plt_brace");
}

quickfade(outTime)
{
	fade_out(outTime);
	fade_in(0.05);
}

thread_spin()
{
	while(true)
	{
		x = 0;
		wait 0.05;
	}
	
}
//---------------------------------------------------------------------------------------------------------------------
//#using_animtree( "animated_props" );

plane_crash_anim_firstframe(models)
{	
	struct_align_crash = GetStruct("hijack_crash_align", "targetname");
		
	foreach(model in models)
	{
		model.animname = "generic";	
	}
	
	struct_align_crash anim_first_frame(models, "hijack_plane_crash_anim"); 
	
}

plane_crash_anim(models)
{
	aud_send_msg ("crash_sequence");
	
	level notify("crash_anim_start");
		
	struct_align_crash = GetStruct("hijack_crash_align", "targetname");
	
	level thread notify_delay("luggage_falls_out", 15.5);
	
	struct_align_crash thread  plane_crash_trees();
	
	thread pre_crash_radio_vo(models[0]);
	thread crash_hit_ground_thread(models[0]);
	aud_send_msg("suitcase_prop_sound_impact", models[0]);
		
	//animate the tower in too.
	tower = spawn_anim_model("crash_tower", (0,0,0));
	towerlights = spawn_anim_model("crash_tower_lights", (0,0,0));
	
	towerpieces[0] = tower;
	towerpieces[1] = towerlights;
	
	struct_align_crash thread anim_single(towerpieces, "hijack_plane_crash_anim");
	towerlights thread tower_light_flicker();
	
	
	thread plane_crash_audio_messages(models[0]);
	
	//add in an engine model
	engine = spawn_anim_model("crash_engine_1",(0,0,0));
	models = array_add(models, engine);
	
	thread handle_engine_swap(engine);
	
	struct_align_crash anim_single(models, "hijack_plane_crash_anim");
	
	//level notify("sled_scrape_stop");
	level notify("crash_done");
	flag_set("stop_managing_crash_player");	
	
	waittillframeend;
	//get rid of the models, all bsp from here on out
	array_delete(level.crash_models);
	
}

tower_light_flicker()
{
	level waittill("tail_hits_tower");
	
	wait 0.3;
	thread flag_set_delayed("tower_is_down", 2.0);	
	
	self hide();
	wait 0.15;
	self show();
	
	scalar = 1.0;
	while(!flag("tower_is_down"))
	{
		self hide();
			
		wait_time = RandomFloatRange(0.1*scalar, 0.2*scalar);
		wait(wait_time);
		
		self show();
		
		wait_time = RandomFloatRange(0.1*scalar, 0.5*scalar);
		wait(wait_time);
		
		scalar *= 0.80;
	}

	//hide after the tower is down
	self Delete();
		
}

plane_crash_audio_messages(model)
{
	level.crash_explosion_origin = spawn_tag_origin();
	level.crash_explosion_origin LinkTo(model, "FX_R_Wing",(0,0,0),(0,0,0));

	level.crash_breakaway_chunk = spawn_tag_origin();
	level.crash_breakaway_chunk LinkTo(model, "J_Break_Chunk",(0,0,0),(0,0,0));
	
	level waittill("crash_impact");
	wait 0.5;
	
	//note to audio: call level.crash_explosion_origin play_sound_on_ent()
	aud_send_msg("crash_chunk_breaks_away");
	
	wait 1.0;	
	//note to audio: call level.crash_breakaway_chunk play_sound_on_ent()
	aud_send_msg("crash_explosion");
	
	flag_wait("crash_throw_player");
	
	level.crash_explosion_origin delete();
	level.crash_breakaway_chunk delete();
	
}

handle_engine_swap(engineEnt)
{
	engineEnt waittillmatch("single anim", "engine_fire");
	
	engineEnt SetModel(level.scr_model["crash_engine_2"]);
}

plane_crash_trees()
{
	tree1 = spawn_anim_model("pine_tree_lg");
	tree2 = spawn_anim_model("pine_tree_lg");
	tree3 = spawn_anim_model("pine_tree_sm");
	tree4 = spawn_anim_model("pine_tree_sm");
	tree5 = spawn_anim_model("pine_tree_lg");
	tree6 = spawn_anim_model("pine_tree_sm");
	
	self thread anim_single_solo(tree1, "crash_tree_1");
	self thread anim_single_solo(tree2, "crash_tree_2");
	self thread anim_single_solo(tree3, "crash_tree_3");
	self thread anim_single_solo(tree4, "crash_tree_4");
	self thread anim_single_solo(tree5, "crash_tree_5");
	self thread anim_single_solo(tree6, "crash_tree_6");

	flag_wait("crash_throw_player");
	
	//delete them?
	
}


//---------------------------------------------------------------------------------------------------------------------
transition_to_tarmac()
{
	level notify( "stop_rumbling" );
	
	level.commander notify("stop_loop");
	level.commander stopanimscripted();
	
	//advisor_start_tarmac = GetStruct( /*"advisor_start_tarmac"*/ "tarmac_advisor", "targetname" );
    //level.advisor ForceTeleport( advisor_start_tarmac.origin, advisor_start_tarmac.angles );

	thread maps\hijack_tarmac::tarmac_carnage();
	
	level.player setweaponammostock ( "fnfiveseven", 60 );
		
	maps\hijack_tarmac::main_script_thread();
}

//---------------------------------------------------------------------------------------------------------------------
CMPP_FORWARD_SCALE = 0.5;// fwd/back movement speed multiplier
CMPP_SIDE_SCALE = 0.5;// left/right movement speed multiplier


crash_manage_player_position_new(player_spot, fwd_percent, right_pct, is_using_aisle_1)
{
	thread manage_player_movement_limits();
	
	attach_tag = "tag_player1_rotate";
	CMPP_FWD_ANIM = %hijack_plane_crash_player_move_forward;
	CMPP_BACK_ANIM = %hijack_plane_crash_player_move_back;
	CMPP_LEFT_ANIM = %hijack_plane_crash_player_move_left;
	CMPP_RIGHT_ANIM = %hijack_plane_crash_player_move_right;	


	//how movement limiting works:
	// If you're in a "forward" aisle:
	//	1. your forward movement is limited by the aisles "front" and "back" limits
	//  2. Your left/right movement is limited by the horizontal aisle you're in, or by the aisle limits otherwise.
	
	//if you're in a "sideways" aisle (betwen seats)
	//  1. Your left/right movement is limited by "left" right" limits
	//  2. your forward/back movement is limited by the 
	
	
	level.fwd_aisle_ranges = [];
	
	//right aisle
	level.fwd_aisle_ranges[0]["left"]  = 0.30;
	level.fwd_aisle_ranges[0]["right"] = 0.40;	
	level.fwd_aisle_ranges[0]["front"] = 1.0;
	level.fwd_aisle_ranges[0]["back"]  = 0.45;
	
	
	//left aisle
	level.fwd_aisle_ranges[1]["left"] = 0.70;
	level.fwd_aisle_ranges[1]["right"] = 0.79;	
	level.fwd_aisle_ranges[1]["front"] = 1.0;
	level.fwd_aisle_ranges[1]["back"]  = 0.3;
	
	//first aisle in room
	level.side_aisle_ranges = [];
	level.side_aisle_ranges[0]["back"] = 0.84;
	level.side_aisle_ranges[0]["front"] = 0.9;
	level.side_aisle_ranges[0]["left"] = 0.15;
	level.side_aisle_ranges[0]["right"] = 1.0;	
	
	//second aisle in room
	level.side_aisle_ranges[1]["back"] = 0.55;
	level.side_aisle_ranges[1]["front"] = 0.6;
	level.side_aisle_ranges[1]["left"] = 0.1;
	level.side_aisle_ranges[1]["right"] = 1.0;	
	
	
	//level.side_aisle_ranges[2]["back"] = 0.29;
	//level.side_aisle_ranges[2]["front"] = 0.33;
	//level.side_aisle_ranges[2]["left"] = 0;
	//level.side_aisle_ranges[2]["right"] = 1.0;	
	

    //initialize aisles based on where we started 
    /*right_pct = .05;
    if(is_using_aisle_1)
    {
    	right_pct = .55;
    }*/
    find_player_aisles(fwd_percent, right_pct);	//punt - todo: figure this out beforehand
    
		
    cur_fwd_anim = CMPP_FWD_ANIM;
    dest_fwd_anim = CMPP_FWD_ANIM;
    player_spot SetAnim(cur_fwd_anim, 1, 0, 0);
    player_spot SetAnimTime(cur_fwd_anim, fwd_percent);
	
    cur_right_anim = CMPP_RIGHT_ANIM;
    dest_right_anim = CMPP_RIGHT_ANIM;
    player_spot SetAnim(cur_right_anim, 1, 0, 0);
    player_spot SetAnimTime(cur_right_anim, right_pct);// TODO: add proper place in left/right anim if needed.

		
    level.player PlayerLinkToDelta(level.groundent, "tag_origin", 0.0, 180, 180, 70, 70, true);

    fwd_movement_updated = false;
    right_movement_updated = false;

    playerThrown = false;
    
    move_speed_scale = 1;
    
    level.pushing_at_edge_time = 0;
    level.pushing_at_edge_measure_time = GetTime();;
    
    while(!flag("stop_managing_crash_player"))
    {
    	if(!flag("crash_throw_player"))
    	{
    		
    		if (!IsAlive(level.player))
			{
	            normalized_movement = (0, 0, 0);
			}
			else
			{
		        normalized_movement = level.player GetNormalizedMovement();
			}
	            
			//player-space movement vector
	        movement_strength = Distance((0, 0, 0), normalized_movement);
	        
	        //reverse Y for some reason...
	        normalized_movement = (normalized_movement[0], normalized_movement[1] * -1, 0);
	        
	        //convert to local space angles
	        normalized_movement_angles = VectorToAngles(normalized_movement);
	        player_angles = level.player GetPlayerAngles();
	        
	        //convert to make movement relative to entity we're riding on... I think.
	        if (IsDefined(level.groundent))
			{
	            player_angles = CombineAngles(level.groundent.angles, player_angles);
			}
	
	        //create a world space movement vector/angles?
	        fwd_movement_angle = CombineAngles(player_angles, normalized_movement_angles);
	        movement_vector = VectorNormalize(AnglesToForward(fwd_movement_angle));
	        
	        //Line((level.player.origin)+(0,0,30), level.player.origin+(0,0,30)+movement_vector * 30, (1,1,1));
	        
			spot_angles = player_spot GetTagAngles(attach_tag);
	        fwd_base = VectorNormalize(AnglesToForward(spot_angles));
	        right_base = VectorNormalize(AnglesToRight(spot_angles));
	
	        fwd_movement_vector_dot = VectorDot(movement_vector, fwd_base);
	        fwd_movement_strength = movement_strength * fwd_movement_vector_dot;
			
	        right_movement_vector_dot = VectorDot(movement_vector, right_base);
	        right_movement_strength = movement_strength * right_movement_vector_dot;
	                
	        fwd_animtime = player_spot GetAnimTime(cur_fwd_anim);
	        fwd_animlength = GetAnimLength(cur_fwd_anim);
	        fwd_anim_fraction = fwd_animtime / fwd_animlength;
	
	        right_animtime = player_spot GetAnimTime(cur_right_anim);
	        right_animlength = GetAnimLength(cur_right_anim);
	        right_anim_fraction = right_animtime / right_animlength;
	        
	        if (movement_strength == 0 || fwd_movement_strength == 0)
	        {
	            if (fwd_movement_updated)
				{
	                player_spot SetAnim(cur_fwd_anim, 1, 0, 0);
				}
	            if (right_movement_updated)
				{
	                player_spot SetAnim(cur_right_anim, 1, 0, 0);
				}
	            fwd_movement_updated = false;
	            right_movement_updated = false;
	        	wait(0.05);			
	            continue;
	        }
			
	        override_fwd_scale = 1.0;	
			override_right_scale = 1.0;	        
	       

			move_fraction_max = 1.0;
			move_fraction_min = 0.0;
			
			if (fwd_movement_strength <= 0)
	        {
				dest_fwd_anim = CMPP_BACK_ANIM;
			//	move_fraction_max = level.backward_move_limit;
			}
			else
			{
				dest_fwd_anim = CMPP_FWD_ANIM;
			//	move_fraction_min = (1.0 - level.backward_move_limit);
			}
			
			////////////////////////////////////////
			//figure out our move limits in each direction
			////////////////////////////////////////
			
			back_move_limit = 1.0;	//towards back of plane
			fwd_move_limit = 1.0;	//towards front of plane
			
			left_move_limit=1.0;	//towards player's right, left of plane
			right_move_limit=1.0;	//towards player's left, right of plane
			
			//calculate forward/back move limits
			if(level.current_fwd_aisle != -1)
			{
				//in an aisle, limit forward movement by aisle front/back boundaries
				back_move_limit = 1.0 - level.fwd_aisle_ranges[level.current_fwd_aisle]["back"];
				fwd_move_limit = level.fwd_aisle_ranges[level.current_fwd_aisle]["front"];	
			}			
			else
			{
				//not in an aisle, so limit forward/backwards horizontal aisle boundaries
				Assert(level.current_side_aisle != -1);
				back_move_limit = 1.0 - level.side_aisle_ranges[level.current_side_aisle]["back"];
				fwd_move_limit = level.side_aisle_ranges[level.current_side_aisle]["front"];								

				//left_move_limit =  1.0 - level.side_aisle_ranges[level.current_side_aisle]["left"];
				//right_move_limit = level.side_aisle_ranges[level.current_side_aisle]["right"];				
				
			}
			
			//calculate left/right move limits
			if(level.current_side_aisle != -1)				
			{
				//in a side aisle, limit left/right by aisle boundaries
				left_move_limit =  1.0 - level.side_aisle_ranges[level.current_side_aisle]["left"];
				right_move_limit = level.side_aisle_ranges[level.current_side_aisle]["right"];		
			}
			else
			{
				//not between seats, so limit sideways movement by foward aisle limits
				Assert(level.current_fwd_aisle != -1);
				right_move_limit = level.fwd_aisle_ranges[level.current_fwd_aisle]["right"];
				left_move_limit = 1.0 - level.fwd_aisle_ranges[level.current_fwd_aisle]["left"];		
				
				//back_move_limit = 1.0 - level.fwd_aisle_ranges[level.current_fwd_aisle]["back"];
				//fwd_move_limit = level.fwd_aisle_ranges[level.current_fwd_aisle]["front"];	
			}
			
			//limit backward movement (toward back of plane)
	        if(dest_fwd_anim == CMPP_BACK_ANIM)
	        {
	        	//try and predict if we'll cross over this threshold this frame.
	        	projected_fwd_pct = fwd_animtime + 0.05*(abs(fwd_movement_strength) * override_fwd_scale * CMPP_FORWARD_SCALE * move_speed_scale);
	        	
	        	if(projected_fwd_pct > back_move_limit)
	        	{
	        		//can't go forward any more.
	        		//fwd_movement_strength = 0;
	        		override_fwd_scale = 0.0;
	        		fwd_animtime = back_move_limit;//TODO: level.backward_move_limit;
	        		
	        		player_spot SetAnimTime(CMPP_BACK_ANIM, back_move_limit);	        		
	        	}
	        }
	        
	        //limit forward movement (towards front of plane)
	        if(dest_fwd_anim == CMPP_FWD_ANIM)
	        {
	        	//try and predict if we'll cross over this threshold this frame.
	        	projected_fwd_pct = fwd_animtime + 0.05*(abs(fwd_movement_strength) * override_fwd_scale * CMPP_FORWARD_SCALE * move_speed_scale);
	        	
	        	if(projected_fwd_pct > fwd_move_limit)
	        	{
	        		//can't go forward any more.
	        		//fwd_movement_strength = 0;
	        		override_fwd_scale = 0.0;
	        		fwd_animtime = fwd_move_limit;
	        		
	        		player_spot SetAnimTime(CMPP_BACK_ANIM, fwd_move_limit);	        		
	        	}
	        }
	        
	        //limit left movement 
	        if(dest_right_anim == CMPP_LEFT_ANIM)
	        {
	        	//try and predict if we'll cross over this threshold this frame.
	        	projected_left_pct = right_animtime + 0.05*(abs(right_movement_strength) * override_right_scale * CMPP_SIDE_SCALE * move_speed_scale);
	        	
	        	if(projected_left_pct > left_move_limit)
	        	{
	        		//can't go forward any more.
	        		//fwd_movement_strength = 0;
	        		override_right_scale = 0.0;
	        		right_animtime = left_move_limit;//TODO: level.backward_move_limit;
	        		
	        		player_spot SetAnimTime(CMPP_LEFT_ANIM, left_move_limit);	        		
	        	}
	        }
	        
	        //limit right movement 
	        if(dest_right_anim == CMPP_RIGHT_ANIM)
	        {
	        	//try and predict if we'll cross over this threshold this frame.
	        	projected_right_pct = right_animtime + 0.05*(abs(right_movement_strength) * override_right_scale * CMPP_SIDE_SCALE * move_speed_scale);
	        	
	        	if(projected_right_pct > right_move_limit)
	        	{
	        		//can't go forward any more.
	        		//fwd_movement_strength = 0;
	        		override_right_scale = 0.0;
	        		right_animtime = right_move_limit;//TODO: level.backward_move_limit;
	        		
	        		player_spot SetAnimTime(CMPP_RIGHT_ANIM, right_move_limit);	        		
	        	}
	        }
	          
	        
	   	    if (cur_fwd_anim != dest_fwd_anim)
			{
				player_spot ClearAnim(cur_fwd_anim, 0);
				
				fwd_anim_fraction = 1 - fwd_anim_fraction;
				fwd_anim_fraction = clamp(fwd_anim_fraction, move_fraction_min, move_fraction_max);
				
				
		        player_spot SetAnim(dest_fwd_anim, 1, 0, abs(fwd_movement_strength) * override_fwd_scale * CMPP_FORWARD_SCALE * move_speed_scale);
	    	    player_spot SetAnimTime(dest_fwd_anim, fwd_anim_fraction);
		        cur_fwd_anim = dest_fwd_anim;
			}
			else
			{
				player_spot SetAnim(cur_fwd_anim, 1, 0, abs(fwd_movement_strength) * override_fwd_scale * CMPP_FORWARD_SCALE * move_speed_scale );			
			}
	
	        if (right_movement_strength < 0)
	        {
	            dest_right_anim = CMPP_LEFT_ANIM;
			}
			else
			{
	            dest_right_anim = CMPP_RIGHT_ANIM;
			}
			
	        if (cur_right_anim != dest_right_anim)
			{
	            player_spot ClearAnim(cur_right_anim, 0);
				
				right_anim_fraction = 1 - right_anim_fraction;
		        right_anim_fraction = clamp(right_anim_fraction, 0.0, 1.0);
				
		        player_spot SetAnim(dest_right_anim, 1, 0, abs(right_movement_strength) * override_right_scale* CMPP_SIDE_SCALE * move_speed_scale);
	    	    player_spot SetAnimTime(dest_right_anim, right_anim_fraction);
		        cur_right_anim = dest_right_anim;
			}
			else
			{
		        player_spot SetAnim(cur_right_anim, 1, 0, abs(right_movement_strength) * CMPP_SIDE_SCALE * move_speed_scale);
			}
	        
	        fwd_movement_updated = true;
	        right_movement_updated = true;
	        
	        //if we've gone to the edge, fall out
	        if(/*level.allow_player_fall && */fwd_movement_strength < 0 && cur_fwd_anim == CMPP_BACK_ANIM && (player_spot GetAnimTime(cur_fwd_anim)) > 0.99)
	        {
	        	
	        	level.pushing_at_edge_time += (GetTime() - level.pushing_at_edge_measure_time) ;   
	        	if(level.pushing_at_edge_time > 1000)
	        	{
	        		thread player_falls_out();
		        	return;
		        }	        
	        }
	        else
	        {
	        	levelpushing_at_edge_time = 0;
	        }
	        	
	       	level.pushing_at_edge_measure_time = GetTime();
	       	
	       	wait(0.05);
	        
	       	//update our aisles
	       	fwd = player_spot GetAnimTime(cur_fwd_anim);
	       	if(cur_fwd_anim == CMPP_BACK_ANIM)
	       	{
	       		fwd = 1.0 - fwd;
	       	}
	       	
	       	right = player_spot GetAnimTime(cur_right_anim);
	       	if(cur_right_anim == CMPP_LEFT_ANIM)
	       	{
	       		right = 1.0 - right;	
	       	}
	       	
	       	//PrintLn("right: "+ right);
    		find_player_aisles( fwd, right );
	        
	        //find_player_aisles( fwd, right );
    	}
    	else
    	{
    		if(!playerThrown)
    		{
    			playerThrown = true;
    			level.player FreezeControls(true);
    			
    			 //when the player is thrown, simulate is by setting the foward animation all the way on.
    			//player_spot SetAnimTime(CMPP_FWD_ANIM, 1.0);
			    player_spot SetAnim(CMPP_FWD_ANIM,1.0,0,3.0);
			    player_spot SetAnim(CMPP_BACK_ANIM,0.0,0);   

				//make sure you're not too close to the walls
				rightTime = player_spot GetAnimTime(cur_right_anim);
				if(rightTime > 0.80)
				{
					player_spot SetAnimTime(cur_right_anim, 0.80);
				}
				else if (rightTime < 0.35)
				{
					player_spot SetAnimTime(cur_right_anim, 0.35);
				}
				
				player_spot SetAnim(cur_right_anim,1.0,0.0,0.0);
				
			    wait 0.85;
			    level.player FreezeControls(false);
    			
			    move_speed_scale = 0.6;
			    flag_clear("crash_throw_player");
			    
			    dest_fwd_anim = CMPP_FWD_ANIM;
			    cur_fwd_anim  = CMPP_FWD_ANIM;
			    fwd_anim_fraction = 1.0;
			    
    		}
    		wait 0.05;
    	}    	
    	
    }
 
}


find_player_aisles(fwd_anim_pct, right_anim_pct)
{
	
	//IPrintLnBold("forward pct: "+fwd_anim_pct);
	//IPrintLnBold("right pct: "+right_anim_pct);
	
	//find forward aisle first
	level.current_fwd_aisle = -1;
	best_fwd_aisle_index = -1;
	best_fwd_aisle_dist = 1.0;	
	for(i=0; i<level.fwd_aisle_ranges.size; i++)
	{
		distFromAisleCenter = abs(right_anim_pct - 0.5 * (level.fwd_aisle_ranges[i]["left"] + level.fwd_aisle_ranges[i]["right"]));
		
		if(right_anim_pct >= level.fwd_aisle_ranges[i]["left"] && right_anim_pct <= level.fwd_aisle_ranges[i]["right"])
		{
			level.current_fwd_aisle = i;
			break;
		}
		if(distFromAisleCenter < best_fwd_aisle_dist)
		{
			best_fwd_aisle_dist = distFromAisleCenter;
			best_fwd_aisle_index = i;			
		}
	}
	
	//find sideways aisle
	level.current_side_aisle = -1;
	best_side_aisle_index = -1;
	best_side_aisle_dist = 1.0;
	
	for(i=0; i<level.side_aisle_ranges.size; i++)
	{
		distFromAisleCenter = abs(fwd_anim_pct - 0.5 * (level.side_aisle_ranges[i]["back"] + level.side_aisle_ranges[i]["front"]));
		
		if(fwd_anim_pct >= level.side_aisle_ranges[i]["back"] && fwd_anim_pct <= level.side_aisle_ranges[i]["front"])
		{
			level.current_side_aisle = i;
			break;
		}
		
		if(distFromAisleCenter < best_side_aisle_dist)
		{
			best_side_aisle_dist = distFromAisleCenter;
			best_side_aisle_index = i;			
		}
	}
	
	//need to pick an aisle here if we're not in a forward aisle - this prevents the case where we're not in any aisle.	
	
	if(level.current_fwd_aisle == -1 && level.current_side_aisle == -1)
	{
		if(best_side_aisle_dist < best_fwd_aisle_dist)
		{
			//snap into a side aisle
			level.current_side_aisle = best_side_aisle_index;				
		}
		else
		{
			//snap into a fwd aisle
			level.current_fwd_aisle = best_fwd_aisle_index;
		}
	}
}


//control how far forward you can move depending on what part of the crash you're in.
manage_player_movement_limits()
{
	//level.allow_player_fall = false;
	//level.backward_move_limit = 0.70;
	
	thread handle_left_aisle_limit();
	thread handle_right_aisle_limit();
	
	//level.allow_player_fall = true;	
}

handle_left_aisle_limit()
{
	level waittill("luggage_falls_out");
	level.fwd_aisle_ranges[1]["back"] = 0.0;	
}

handle_right_aisle_limit()
{
	level waittill("agent_falls_out");		
	level.fwd_aisle_ranges[0]["back"] = 0.0;
	
}

teleport_to_crashmodel( oldModel, newModel)
{
	//figure out position relative to old model
	//we use the J_Mid_Section bone because it's the same relative to the plane geo in the refpose and the firstframe of the crash
	
	if(!isdefined(level.helper))
	{
		level.helper = spawn_tag_origin();		
	}
	
	level.helper.origin = oldmodel GetTagOrigin("J_Mid_Section");// LinkTo(oldModel, "J_Mid_Section", (0,0,0), (0,0,0));
	
	
	localOffset = level.helper WorldToLocalCoords(self.origin);
		
	//convert this to an offset relative to the new model.
	//helper LinkTo(newModel, "J_Mid_Section", (0,0,0), (0,0,0));	
	level.helper.origin = newModel GetTagOrigin("J_Mid_Section");
	
	newWorldLoc = level.helper LocalToWorldCoords(localOffset);
	
	if(IsAI(self))
	{
		self ForceTeleport(newWorldLoc, self.angles);		
	}
	else if(IsPlayer(self))
	{
		//helper = spawn_tag_origin();
		level.helper.origin = newWorldLoc;		
		level.helper.angles = self GetPlayerAngles();
		self teleport_player(level.helper);
		//helper delete();
	}
	else
	{
		self.origin = newWorldLoc;
	}
}
	
//attach various utility entities to the plane model for fx, etc.
teleport_crash_ents(oldModel, newModel)
{
	//teleport the player
	level.player teleport_to_crashmodel(oldModel, newModel);
	
	level.hero_agent_01 teleport_to_crashmodel(oldModel, newModel);
	level.hero_agent_01 LinkTo(newModel,"tag_agent",(0,0,0), (0,0,0));
	
	level.commander teleport_to_crashmodel(oldModel, newModel);		
	level.commander LinkTo(newModel,"J_Mid_Section");
	
	
	
	
	//attach sled entities	
	sled_ents = getentarray("sled_attach_ents", "targetname");
	foreach(ent in sled_ents)
	{
		ent teleport_to_crashmodel(oldmodel, newModel);
		ent setmodel("tag_origin");
		ent Linkto(newModel, "J_Mid_Section" );
	}
	
	//attach tail entities
	tail_ents = GetEntArray("tail_attach_ents","targetname");
	foreach(ent in tail_ents)
	{
		ent teleport_to_crashmodel(oldModel, newModel);
		ent setmodel("tag_origin");
		ent Linkto(newModel, "J_Tail_Sled" );
	}
	
}

handle_hero_agent_crash()
{
	self.ignoreall = true;
	
	self.animname = "generic";
	aud_send_msg("agent_scream", level.hero_agent_01); // AUDIO: plays screaming sound on the agent	
	
	//todo: notetrack?
	level thread notify_delay("agent_falls_out", 19.5);
	
	level.crash_models[0] anim_single_solo(self,"planecrash_agent1", "tag_agent"); 
	if( IsDefined( self.magic_bullet_shield ) && self.magic_bullet_shield )
		self stop_magic_bullet_shield();
	self.deathfunction = undefined;
	waittillframeend;
	self kill();
	
	//meant to play after the agent falls out of the plane.
	//wait(.1);
	//radio_dialogue( "hijack_cmd_holdonhark" );
}

handle_commander_crash()
{
	level.commander notify( "stop_door_loop" );		
}


handle_crash_enemies()
{
	level waittill("crash_teleport");
	
	thread tail_enemy_spawn(GetEnt("planecrash_enemy1", "targetname"), "planecrash_enemy1");
	thread tail_enemy_spawn(GetEnt("planecrash_enemy2", "targetname"), "planecrash_enemy2");
	thread tail_enemy_spawn(GetEnt("planecrash_enemy3", "targetname"), "planecrash_enemy3"); 
	thread tail_enemy_spawn(GetEnt("planecrash_enemy4", "targetname"), "planecrash_enemy4");
	thread tail_enemy_spawn(GetEnt("planecrash_enemy5", "targetname"), "planecrash_enemy5");
	thread tail_enemy_spawn(GetEnt("planecrash_enemy6", "targetname"), "planecrash_enemy6");
	
	
}

tail_enemy_spawn(spawner, anim_name)
{
	ai = spawner spawn_ai();
	ai.ignoreall = true;
	ai LinkTo(level.crash_models[0], "tag_enemy", (0,0,0), (0,0,0));
	
	//kind of a hack to prevent a certain codepath in firing notetracks from firing
	ai.dontShootStraight = true;
	
	level.crash_models[0] thread anim_generic(ai, anim_name, "tag_enemy");
	ai.allowdeath = true;
	ai.noragdoll = true;
	level waittill("crash_done");
	if(isdefined(ai))
	{
		ai delete();
	}
	
}

//hack to let me delay call this
shell_shock(name, duration)
{
	self ShellShock( name, duration );	
}

player_falls_out()
{
	//spawn a player rig		
	player_rig = spawn_anim_model( "player_rig", level.player.origin );
	player_rig.angles = level.player.angles;
	player_rig SetAnimTree();
	
	level.player DisableWeapons();
	level.player SetStance("stand");
	level.player AllowCrouch(false);
	
	level.player delayThread(0.75, ::shell_shock, "hijack_airplane", 3.0 );
	aud_send_msg("crash_death");
	
	player_rig LinkTo(level.crash_models[0], level.attach_tag, (0,0,0),(0,180,0));
	level.player PlayerLinkToAbsolute( player_rig, "tag_player");
	level.player PlayerSetGroundReferenceEnt(undefined);
		
	animlen = GetAnimLength(player_rig getanim("crash_fall_out"));
	
	level.crash_models[0] thread anim_single_solo( player_rig, "crash_fall_out", level.attach_tag);
	wait animlen - .5;
	
	//fade_out(0.5);
	//level.player Unlink();	
	//player_rig delete();
	
	setDvar( "ui_deadquote", &"HIJACK_FELL_OUT_OF_PLANE" );
	level notify( "mission failed" );
	missionFailedWrapper();
	
	//level.player Kill(level.player.origin, level.player);		
}

handle_crash_sunlight()
{
	//want zero sun for first part of crash
	SetSunLight(0,0,0);
	
	
	level waittill("crash_impact");
	setsaveddvar( "sm_sunSampleSizeNear", 2.5 );// to see the shadows on the tail section
	
	//force sun shadows to fix a bug caused by the fact that the sun doesn't cast shadows for part of this sequence
	enableforcedsunshadows();
	
	
	ResetSunLight();
	
	thread sunlight_flicker();
	thread sunlight_direction_lerp();
	
	//force sun shadows to fix a bug caused by the fact that the sun doesn't cast shadows for part of this sequence
	flag_wait("crash_throw_player");
	DisableForcedSunShadows();
	
	
	setsaveddvar( "sm_sunSampleSizeNear", 0.25 );// default	
	
	
	//after impact, reset to values from level/stage volume		
}

sunlight_flicker()
{
	wait 0.5;	
	current_val = (0,0,0);
	
	thread sunlight_flicker_lifetime_values();
	
	while(!flag("stop_sun_crash_lerp"))
	{
		scale = RandomFloatRange(level.crash_light_scale_min, level.crash_light_scale_max);
		wait(RandomFloatRange(0.1, 0.3));
		
		current_val = level.crash_light_val_base * scale;
		
		SetSunLight(current_val[0], current_val[1], current_val[2]);
	}	
	
	//final resting place for sun values - setup as seperate value so we can have ultimate control
	end_value = (0.878431, 0.443137, 0.121569);
	
	sun_lerp_value(current_val, end_value, 0.5);
	
	//ResetSunLight();
}

sunlight_flicker_lifetime_values()
{
	//Tweakable values
	//this is the starting point for the crash - hot orange or whatever	
	crash_light_val_base_start = (0.878431, 0.443137, 0.121569);
	
	//this is the value at the end of the crash - cooler, but still firelight. Or something like that.	
	crash_light_val_base_end = (0.965, 0.847, 0.584);
	
	//this is scalar range applied to the base value, at the start of the crash
	crash_light_scale_min_start = 1.2;
	crash_light_scale_max_start = 3.0;
	
	//this is scalar range applied to the base value, at the end - gradually getting less dramatic
	crash_light_scale_min_end = 0.9;
	crash_light_scale_max_end = 0.98;
	
	level.crash_light_val_base  = crash_light_val_base_start;
	level.crash_light_scale_min = crash_light_scale_min_start;
	level.crash_light_scale_max = crash_light_scale_max_start;
	
	
	//lifetime over which to interpolate these ranges
	total_time =  13;

	//logic for interpolating between these values
	life =total_time ;
	while(life > 0)
	{
		pct = (total_time - life)/total_time;
		
		//exponential ramp
		pct = pct*pct;
		
		level.crash_light_val_base = VectorLerp(crash_light_val_base_start, crash_light_val_base_end, pct);
		
		level.crash_light_scale_min = linear_interpolate(pct, crash_light_scale_min_start, crash_light_scale_min_end);
		level.crash_light_scale_max = linear_interpolate(pct, crash_light_scale_max_start, crash_light_scale_max_end);
		life -= 0.1;
		wait 0.1;		
	}
	
	flag_set("stop_sun_crash_lerp");
	
	
	//IPrintLnBold("done interpolating sun");
		
}

sun_lerp_value(start, end, time)
{
	timeLeft = time;
	pct = 0;
	while(timeLeft > 0)
	{
		timeLeft -= 0.05;
		pct = (time - timeLeft) / time;
		
		val = start + (end - start) * pct;
		SetSunLight(val[0], val[1], val[2]);
	}	
}

sunlight_direction_lerp()
{
	start_sun_dir = (-5, -90, 0);
	defaultYaw = -5;
	start_yaw = -120;
	end_yaw = -70;
	
	//-130, -50
	angles_start = (-5, -130, 0);
	angles_end = (-5, -80, 0);
	
	start_light = (0.878431, 0.443137, 0.121569);
	
	//pop to start
	LerpSunAngles(start_sun_dir, angles_start, 0.05);
	
	while(!flag("stop_sun_crash_lerp"))
	{
		//lerp to end
		LerpSunAngles(angles_end, angles_start  , RandomFloatRange(0.5, 1.1) );
		//sun_lerp_value(start_light*
		wait (RandomFloatRange(0.6, 0.9));
		
		//pop back to start
		LerpSunAngles(angles_start, angles_end,  0.05);				
		wait 0.05;		
	}
	
	//LerpSunAngles(angles_end, angles_end, 0.05);	
}


//called from notetrack when plane hits ground
crash_hit_ground_thread(planeModel)
{
	planeModel waittillmatch("single anim", "hit_ground");
	
	level notify("crash_impact");
	//level notify("crash_stop_flashing_lights");
	
	level notify("crash_stop_pre_sled_lights");
		
	thread handle_runner_lights();
	
	level.player StopRumble("hijack_plane_medium");
	
	Earthquake( 0.7, 1.2, level.player.origin, 200000 );
	
	level.player DisableWeapons();
	wait .5;
	
	level.player PlayRumbleLoopOnEntity("hijack_plane_large");
	
	thread plane_rumbling();
	
	wait 1.5;
	
	level.player EnableWeapons();
	
	//wait 1.0;
		
	
}

//called from notetrack just before plane comes to a stop
crash_hit_throw_player(planeModel)
{
	planeModel waittillmatch("single anim", "hit_stop");
	                                    
	flag_set("crash_throw_player");
	
	level notify("crash_stop_flashing_lights");
	level notify("sled_scrape_stop");
	
	
	//level.player StopRumble( "hijack_plane_large");
	StopAllRumbles();
	level notify("stop_rumbling");
	
	//point the player at the look at entity
	lookatEnt = getstruct("player_crash_end_lookat", "targetname");	
	
	
	
	player_dest = getent("crash_player_dest_2", "script_noteworthy");//getstruct("player_crash_end_aisle_2", "targetname");
	
	if(	level.using_aisle_1)
	{
		player_dest = getent("crash_player_dest_1", "script_noteworthy"); // getstruct("player_crash_end_aisle_1", "targetname");		
	}
	
	newPlayerAngles = VectorToAngles(lookatEnt.origin - player_dest.origin);
	newPlayerAngles = (0,newPlayerAngles[1],0);
	
	remove_all_weapons_post_crash();
	
	//force player to look out back of plane.	
	//forward = AnglesToForward(planeModel GetTagAngles("tag_origin"));
	//backward = (-1 * forward);
	//level.groundent.angles = level.player GetPlayerAngles();
	//level.player PlayerLinkToAbsolute(level.groundent, "tag_origin");
	
	//put an entity between me and the groundref entity, to point me in the right direction without changing our reference point.
	
	newPlayerLinkTo = spawn_tag_origin();
	newPlayerLinkTo.origin = planeModel GetTagOrigin(level.attach_tag);
	newPlayerLinkTo.angles = planeModel GetTagAngles(level.attach_tag) + (10,180, 0);
	newPlayerLinkTo linkto(level.groundent);
	
	//level.groundent linkTo(planeModel, level.attach_tag, (0, 0, 0), (30, 180, 0));	
	level.player PlayerLinkToBlend(newPlayerLinkTo, "tag_origin", .1, 0,0);
	
	
	//level.groundent Unlink();
	//level.groundent RotateTo(VectorToAngles(backward), .1, 0, 0);
	
	//level.player PlayerSetGroundReferenceEnt(undefined);
		
	wait 0.1;
	if(isdefined(level.commander))
	{	   	
		//level.crash_agent_1 stop_magic_bullet_shield();
		//level.crash_agent_1 delete();	
		level.commander stop_magic_bullet_shield();
		level.commander delete();
		
		level.commander = spawn_ally( "commander_tarmac", "tarmac_commander_tarmac" );
		exitGoal = GetNode("commander_pre_ramp_node", "targetname");
		level.commander teleport_ai(exitGoal);
		
		level.commander Hide();
		
	}
	
	
	level.player ShellShock( "hijack_airplane", 2.5 );	
	
	//playerEnt waittill("movedone");

	level.player PlayRumbleOnEntity( "damage_heavy" );	
	
	wait .3;
	//level.player PlayerLinkToDelta(level.groundent, "tag_origin", 0.0, 180, 180, 70, 70, true);
	
	planeModel waittillmatch("single anim", "hit_end");
	flag_set("stop_managing_crash_player");
	
	//level.player Unlink();
	level.player PlayRumbleOnEntity( "damage_heavy" );		
	thread maps\hijack_code::fade_out(.05);	
	
	
		
	wait .2;
	
	
	//level.player PlayerSetGroundReferenceEnt(undefined);
	
	//teleportSpot = getstruct("player_crash_end_aisle_1", "targetname");		
	//level.player teleport_player(teleportSpot);
	
	level notify("crash_sequence_done");
	SetSavedDvar( "compass", 0 );
	SetSavedDvar( "hud_showStance", 0 );
	SetSavedDvar( "ammoCounterHide", 1 );
	SetSavedDvar( "actionSlotsHide", 1 );
	level.player EnableSlowAim(0,0);
	wait(10.0); // How long to stay blacked out after the crash, before waking up
	SetSavedDvar( "compass", 1 );
	SetSavedDvar( "hud_showStance", 1 );
	SetSavedDvar( "ammoCounterHide", 0 );
	SetSavedDvar( "actionSlotsHide", 0 );

	level.player DisableSlowAim();
	
	level.commander show();
	
	level.player AllowCrouch(false);
		
	maps\_compass::setupMiniMap("compass_map_hijack_tarmac", "tarmac_minimap_corner");
	setsaveddvar( "compassmaxrange", 3500 ); //default is 3500
	
	thread maps\hijack_code::fade_in(3.0);
	thread post_crash_background_chatter();
	
	scene_origin = getstruct("agent_helps_player_origin", "targetname");
	thread player_wake_up(scene_origin);
	thread commander_wake_up(scene_origin);
	thread animated_telephone();
}

remove_all_weapons_post_crash()
{
	level.player disableweapons();
}

animated_telephone()
{
	scene_origin = getstruct("agent_helps_player_origin", "targetname");
	
	telephone = GetEnt("post_crash_phone","targetname");
	telephone.animname = "post_crash_telephone";
	telephone SetAnimTree();
	
	scene_origin thread anim_single_solo(telephone,"telephone_swing");
}

player_wake_up(scene_origin)
{
	player_rig = spawn_anim_model( "player_rig", level.player.origin );
	level.player PlayerLinkToDelta(player_rig,"tag_player", 1.0, 10,10,10,10,true);
	
	thread player_blur();
	level.player EnableSlowAim();
	
	scene_origin anim_single_solo(player_rig,"help_player_up");
	
	level.player Unlink();
	player_rig Delete();
	thread slowly_restore_aim_speed();
	
	flag_set("player_on_feet_post_crash");
}

commander_wake_up(scene_origin)
{
	level notify("start_commander_wake_up_anim");
	scene_origin anim_single_solo(level.commander,"help_player_up");
	
	flag_set("commander_finished_wake_up_anim");
}

slowly_restore_aim_speed()
{
	wait_time = 0.4;
	level.player EnableSlowAim(0.2,0.2);
	wait(wait_time);
	level.player EnableSlowAim(0.3,0.3);
	wait(wait_time);
	level.player EnableSlowAim(0.4,0.4);
	wait(wait_time);
	level.player EnableSlowAim(0.5,0.5);
	wait(wait_time);
	level.player EnableSlowAim(0.6,0.6);
	wait(wait_time);
	level.player EnableSlowAim(0.7,0.7);
	wait(wait_time);
	level.player EnableSlowAim(0.8,0.8);
	wait(wait_time);
	level.player EnableSlowAim(0.9,0.9);
	wait(wait_time);
	level.player DisableSlowAim();	
}

player_blur()
{
	setblur( 9, 1 );
	wait(1);
	setblur(0,1);
	wait(2);
	setblur(4,0.5);
	wait(0.5);
	setblur(0,0.5);
	wait(2.5);
	setblur( 5, 3);
	wait(2.5);
	setblur( 0, 1.5 );
	wait(0.5);

	start = level.dofDefault;	
	dof_injured = [];
	dof_injured[ "nearStart" ] = .1;
	dof_injured[ "nearEnd" ] = .2;
	dof_injured[ "nearBlur" ] = 6.0;
	dof_injured[ "farStart" ] = 50;
	dof_injured[ "farEnd" ] = 100;
	dof_injured[ "farBlur" ] = 5;

	blend_dof( start, dof_injured, 2.5 );
	
	flag_wait("player_on_feet_post_crash");
	blend_dof( dof_injured, start, 5 );
}

post_crash_background_chatter()
{
	level endon( "player_exit_plane_3" );

	level.tarmac_radio_org = spawn( "script_origin", level.player.origin );
	level.tarmac_radio_org linkto( level.player );
	level.tarmac_radio_org.linked = true;
	
	min_time = 1.75;
	max_time = 3.0;
	
	background_chatter( "hijack_rt1_stillinarea", level.tarmac_radio_org );
	wait(RandomFloatRange( min_time, max_time ));
	background_chatter( "hijack_rt2_command", level.tarmac_radio_org );
	wait(RandomFloatRange( min_time, max_time ));
	background_chatter( "hijack_rt3_scrambling", level.tarmac_radio_org );
	wait(RandomFloatRange( min_time, max_time ));
	background_chatter( "hijack_rt1_clearing", level.tarmac_radio_org );
	wait(RandomFloatRange( min_time, max_time ));
	background_chatter( "hijack_rt2_neutralized", level.tarmac_radio_org );
	wait(RandomFloatRange( min_time-1, max_time-1 ));
	background_chatter( "hijack_rt3_wounded", level.tarmac_radio_org );
	wait(RandomFloatRange( min_time-1, max_time-1 ));
	background_chatter( "hijack_rt1_verifylocation", level.tarmac_radio_org );
	wait(RandomFloatRange( min_time-1, max_time-1 ));
	background_chatter( "hijack_rt2_hamburg", level.tarmac_radio_org );
	wait(RandomFloatRange( min_time-1, max_time-1 ));
	background_chatter( "hijack_fso1_flightpath", level.tarmac_radio_org );
}

//called at moment of impact
handle_runner_lights()
{
	
	front_ent = getent("hijack_crash_model_front_interior_new", "script_noteworthy");
	rear_ent  = getent("hijack_crash_model_rear_interior_new", "script_noteworthy");
	
	//at moment of impact, lights go off for a second
	runner_lights_seton(false, front_ent,"plane_crash_lights_on_front", "plane_crash_lights_off_front");
	runner_lights_seton(false, rear_ent,"plane_crash_lights_on_rear", "plane_crash_lights_off_rear");
	
	wait 2.0;
	
	thread flicker_model(front_ent,"stop_front_flicker", "plane_crash_lights_on_front", "plane_crash_lights_off_front");
	//thread flicker_model(rear_ent, "stop_rear_flicker", "plane_crash_lights_on_rear", "plane_crash_lights_off_rear");	
	
	wait 3.0;
	
	//level notify("stop_rear_flicker");
	runner_lights_seton(false, rear_ent,"plane_crash_lights_on_rear", "plane_crash_lights_off_rear");
	
	flag_wait("crash_throw_player");
	level notify("stop_front_flicker");
	
	runner_lights_seton(false, front_ent,"plane_crash_lights_on_front", "plane_crash_lights_off_front");
	runner_lights_seton(false, rear_ent,"plane_crash_lights_on_rear", "plane_crash_lights_off_rear");
			
}

enemy_pre_crash_chatter()
{	
	level endon("crash_teleport");
	
	soundOrg = getent("crash_battlechatter_origin", "script_noteworthy");
		
	while(true)
	{
		soundOrg play_sound_on_entity("RU_1_order_move_combat");
		
		//wait 0.5;
		
		soundOrg play_sound_on_entity("RU_1_hostile_burst");		
		
		//wait 0.5;
	}
}

flicker_model(model, ender, onModelAlias, offModelAlias)
{
	level endon(ender);
	
	while(true)
	{
		runner_lights_seton(true, model, onModelAlias, offModelAlias);	;
		wait(RandomFloatRange(0.05, 0.5));
		
		runner_lights_seton(false, model, onModelAlias, offModelAlias);	;
		wait(RandomFloatRange(0.05, 0.2));		
	}
	
}

runner_lights_seton(on, ent, onModelAlias, offModelAlias)
{
	if(on)
	{
		ent SetModel(level.scr_model[onModelAlias]);
	}
	else
	{
		ent SetModel(level.scr_model[offModelAlias]);
	}
}
