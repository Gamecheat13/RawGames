/*
THIS FILE HANDLES BOTH:
 - Chasing the guy through the tunnels
*/


#include maps\_utility;
#include maps\pow_utility;
#include common_scripts\utility;
#include maps\_anim;
#include maps\_music;
#include maps\_scene;
#include maps\_dialog;

start_tunnel_chase()
{
	
	//after russian roulette post Barnes at the tunnel exit and then get everything setup
	//level thread maps\_color_manager::color_manager_think();
	
	//-- barnes at tunnel entrance
	level.woods = GetEnt("barnes_rr_scene_ai", "targetname");
	level.woods set_ignoreall(false);
	level.woods change_movemode("cqb_sprint"); //-- uses tighter turns
	
	flag_set("player_not_left"); //-- a specific flag for the split path
	level.woods thread move_out_of_rr_room();
	flag_set("tunnel_chase_started"); //-- used to sync up other threads
	
	level thread tunnel_ai_spawning();
	level thread tunnel_player_went_left(); //-- if this triggers then the player went left
	level thread tunnel_cleanup_after_fork(); //-- after the player hits the for delete the triggers and spawners for both sides
	level thread tunnel_woods_custom_cover();
	//level thread tunnel_custom_dds();
	
	trigger_wait("trigger_spetz_getaway");
	
	spetz_escape_scene( level.ai_the_russian ); //TODO: come back and look at this to see if we have a living spetz that we can use
																		 // we might need to break all of these scenes up into their own controlling function_stack
																		 // then we can show the spetz in multiple rooms or something
	
	level thread move_tunnel_player_clip( false );
}

tunnel_custom_dds()
{
	level endon("stop_custom_dds");
	trigger = GetEnt("trig_tunnel_scripted_dds", "targetname");
	speaker = GetEnt(trigger.target, "targetname");
	speaker.animname = "fake_dds";
	
	while(1)
	{	
		speaker anim_single( speaker, "rus1");
		RandomFloatRange(0.5, 1);
		speaker anim_single( speaker, "vc1");
		RandomFloatRange(0.5, 1);
		speaker anim_single( speaker, "vc2");
		RandomFloatRange(0.5, 1);
		speaker anim_single( speaker, "vc3");
		RandomFloatRange(0.5, 1);
		
		random_wait = RandomFloatRange(2.0, 5.0);
		wait(random_wait);
	}
}

tunnel_player_went_left()
{
	trigger_wait("trig_finishing_low_path", "script_noteworthy");
	teleport_spot = getstruct( "woods_player_left", "targetname" );
	level.woods ForceTeleport(teleport_spot.origin, teleport_spot.angles);
	
	flag_clear("player_not_left"); //-- a specific flag for color managers
	level notify("player_went_left");
	
	//-- Clean up all the right side guys
	ais = get_ai_group_ai( "big_room_rush_in" );
	other_ais = get_ai_group_ai( "big_room_1st_group" );
	and_other_ais = get_ai_group_ai( "tunnel_1st_rush" );
	
	ai = array_combine(ais, other_ais);
	ai = array_combine(ai, and_other_ais);
	array_thread(ai, ::ragdoll_death);
	
	waittill_ai_group_amount_killed( "tunnel_rushers_1", 1 );
	trigger_use( "woods_color_b24" );
}

move_out_of_rr_room() //self == woods
{
	self endon("death");
	
	self set_force_color( "b" );
	//trigger_use("color_trig_after_roulette_allies");
	
	self thread set_split_flag_on_goal("move_woods_to_split");
	trigger = GetEnt("trig_spawn_very_first_rushers", "targetname");
	self thread set_flag_on_trigger( trigger, "move_woods_to_split" );
	flag_wait("move_woods_to_split");

	player = get_players()[0];
	player.animname = "player";
	player anim_single(player, "the_russian_now");
	trigger_use("move_woods_to_split");
	level.woods anim_single( level.woods, "lets_go");
	level thread VO_tunnel_reminder();
	
	wait(0.5);
	
	level.woods.ignoreall = false; //-- allow woods to shoot again
}

set_split_flag_on_goal( flag_msg )
{
	level endon( flag_msg );
	self waittill("goal");

	self.grenadeawareness = 0;
	
	player = get_players()[0];
	player waittill_player_looking_at( self.origin + (0,0,60), 0.8, true );
	
	flag_set( flag_msg );
}

tunnel_woods_custom_cover()
{
	//-- first few fights
	level thread move_up_and_blowup_in_small_room();
	level thread move_cqb_downhill_until_guys_spawn();
	level thread move_disable_b4_if_b5_is_hit();
	level thread move_through_right_room_when_mostly_clear();
	
	//-- last fights
	level thread move_through_end_tunnel_when_room_clear();
	level thread move_slower_down_last_tunnel();
	level thread move_faster_into_last_room();
	level thread move_disable_node_on_b22();
	
	level thread warp_woods_if_player_sprints();
}

//-- this is to fix the bug where Woods doesn't make it to the Russian's room fast enough
warp_woods_if_player_sprints()
{
	trigger_wait("trigger_player_at_spetz");
	
	trigger = GetEnt("woods_color_b8", "targetname");
	if(IsDefined(trigger))
	{
		self.color_enabled = false;
	}
	
	volume = GetEnt("trigger_woods_at_spetz", "targetname");
	if(level.woods IsTouching(volume)) //-- woods is already on his way
	{
		level.woods change_movemode("cqb_sprint");
		return;
	}
	
	level.woods disable_ai_color();
	
	player = get_players()[0];
	close_struct = getstruct("struct_rush_to_russian_close", "targetname");
	test = player is_player_looking_at(close_struct.origin, 0.3, true);
	
	if(!test)
	{
		level.woods ForceTeleport( close_struct.origin, close_struct.angles );
	}
	else
	{
		far_struct = getstruct("struct_rush_to_russian_far", "targetname");
		level.woods ForceTeleport( far_struct.origin, far_struct.angles );
	}
	
	//level.woods set_force_color( "b" );
	woods_node = GetNode("woods_kill_spetz_node", "targetname");
	level.woods SetGoalNode( woods_node );
	level.woods change_movemode("cqb_sprint");
}

notify_when_both_ai_groups_are_dead( notify_str, ai_group_1, ai_group_2 )
{
	level endon(notify_str);
	
	waittill_ai_group_cleared( ai_group_1 );
	waittill_ai_group_cleared( ai_group_2 );
	
	level notify(notify_str);
}

notify_when_2nd_group_only_has_1_guy( notify_str, ai_group_1, ai_group_2 )
{
	level endon(notify_str);
	
	waittill_ai_group_cleared( ai_group_1 );
	waittill_ai_group_ai_count( ai_group_2, 1);
	
	level notify(notify_str);
}

move_disable_node_on_b22()
{
	trigger_wait("woods_color_b22");
	node = GetNode("disable_on_b22", "script_noteworthy");
	SetEnableNode(node, false);
}

move_through_end_tunnel_when_room_clear()
{
	level endon("woods_warped");
	
	waittill_ai_group_cleared("large_room_ai");
	waittillframeend;
	trigger_use("woods_color_b25");
}

move_faster_into_last_room()
{
	trigger_wait("trigger_spetz_getaway");
	
	level.woods change_movemode("cqb_sprint");
	level.woods reset_movemode();
}

move_slower_down_last_tunnel()
{
	trigger_wait("woods_color_b25");
	
	level.woods reset_movemode();
	level.woods change_movemode("cqb");
}

move_through_right_room_when_mostly_clear()
{
	level endon("player_went_left");
	level thread notify_when_both_ai_groups_are_dead( "move_woods_forward", "big_room_rush_in", "big_room_1st_group" );
	level thread notify_when_2nd_group_only_has_1_guy( "move_woods_forward", "big_room_1st_group", "big_room_rush_in" );
	
	level waittill("move_woods_forward");
	trigger_use("woods_color_b5");
}

move_disable_b4_if_b5_is_hit()
{
	level endon("player_went_left");
	trigger_wait( "woods_color_b5" );
	trigger = GetEnt("woods_color_b4", "targetname");
	trigger.color_enabled = false;;
}

move_up_and_blowup_in_small_room()
{
	level endon("player_went_left");
	trigger = GetEnt("woods_color_b4", "targetname");
	trigger endon("death");
	level endon("player_went_left"); //-- end this if the player went to the left
	
	trigger waittill("trigger");
	//trigger_wait("woods_color_b4"); //-- this doesn't end with the endon of the trigger "death"
	
	struct = getstruct("struct_blow_up_clear_cover", "targetname");
	
	player = get_players()[0];
	player EnableInvulnerability();
	
	RadiusDamage( struct.origin, 34, 300, 299 );
	wait(0.05);
	
	player DisableInvulnerability();
	
	sbm = GetEnt("sbm_woods_color_4", "targetname");
	sbm ConnectPaths();
	sbm Delete();
}

move_cqb_downhill_until_guys_spawn()
{
	level endon("player_went_left");
	trigger_wait("woods_color_b10");
	
	level.woods reset_movemode();
	level.woods change_movemode("cqb");
	
	level waittill("signaler_alive", signaler);
	signaler waittill("death");
	
	trigger_use( "woods_color_b24" );
	wait(1);
	
	level.woods reset_movemode();
	level.woods change_movemode("cqb_sprint");
}

//-- spawns characters in front of the player
tunnel_ai_spawning()
{
	level endon("obj_chase_russian_complete");
	
	level thread setup_rusher();
	level thread setup_dropin(); //-- the guys that drop in on the left path of the fork
	level thread setup_tunnel_signaler(); //-- the guy where the fork comes together
	level thread setup_crouch_spot_attacker(); //-- attacks woods/player where they crouch under the low ceiling
	level thread setup_leaper(); //-- the guy that leaps off the ledge and then takes cover
	level thread setup_machete_attacker(); //-- the guy that leaps over the cover and then machetes you!
	level thread setup_strafer(); //-- the guy that passes sideways after the guy runs up the hill
	level thread setup_ledge_respawn(); //-- after the 2 guys from the ledge are killed or have jumped down, spawn 2 more guys
	
	level thread setup_table_pulldown_guy(); //-- the guy that pulls down the table in the path
	level thread setup_table_hindbehind_guy();
	covernodes = GetNodeArray("node_table_pulldown", "targetname");
	for( i=0; i < covernodes.size; i++)
	{
		SetEnableNode(covernodes[i], false);
	}
	
	//-- woods is at the fork, spawn the rushers
	//flag_wait("woods_at_split");
	//trigger_use("trig_spawn_tunnel_rush_1");
	
	//-- the first big room is cleared, so spawn the new tunnel rushers
	
	trigger_wait("trig_spawn_big_room");
	wait(0.1);
	waittill_ai_group_ai_count("big_room_1st_group", 2 );
	trigger_use("trig_spawn_big_room_rushers");
	
	waittill_ai_group_cleared("big_room_rush_in");
	//trigger_use("trig_spawn_tunnel_rushers_1");
	
	//-- spawn the guys that come running into the big room
	//wait(3);
	//trigger_use("trig_spawn_big_room_ai_2");
	
	trigger_wait("trig_spawn_big_room_ai");
	level thread big_room_ai_2_delayed_spawn();
	trigger_wait("trig_spawn_big_room_ai_2");
	
	waittillframeend;
	
	//-- last guys that run out of the russians tunnel
	waittill_ai_group_cleared("large_room_ai");
	trigger_use("trig_rushers_last_tunnel");
}

big_room_ai_2_delayed_spawn() //-- spawn if enough time has gone by
{
	level thread big_room_ai_2_spawn_from_ai_group();
	
	/* -- temp removal
	trigger = trigger_wait("trig_delay_spawn_big_room_ai_2");
	wait(15);
	trigger_use("trig_spawn_big_room_ai_2");
	trigger Delete();
	*/
}

big_room_ai_2_spawn_from_ai_group() //-- spawn if there are only 2 guys current in the big room (would usually mean both ridge guys are dead)
{
	waittill_ai_group_ai_count( "large_room_ai", 2);
	trigger_use("trig_spawn_big_room_ai_2");
}


setup_rusher()
{
	rushers = GetEntArray( "tunnel_rusher", "script_noteworthy" );
	for( i = 0; i < rushers.size; i++)
	{
		if(IsSubStr( rushers[i].classname, "baton"))
		{
			rushers[i] add_spawn_function( maps\_baton_guard::make_baton_guard );
		}
		else
		{
			rushers[i] add_spawn_function( ::player_seek_no_cover, level.woods );
		}
	}
	
	runaway_guy = GetEnt( "run_away_guy", "targetname");
	runaway_guy add_spawn_function( maps\pow_utility::trigger_on_goal_or_death, "trig_spawn_tunnel_rush_1", "trig_spawn_big_room" );
	runaway_guy add_spawn_function( maps\pow_utility::clear_ignore_on_goal);
	runaway_guy add_spawn_function( ::run_away_guy_spawn_strafer_on_death );
	//array_thread( rushers, ::add_spawn_function, maps\_baton_guard::make_baton_guard );
	//array_thread( rushers, ::add_spawn_function, ::player_seek_no_cover );
	//array_thread( rushers, ::add_spawn_function, ::player_seek_no_cover, level.woods );
}

run_away_guy_spawn_strafer_on_death()
{
	level endon("right_trigs_deleted");
	self waittill("death");
	trigger_use( "trig_spawn_strafer" );
}

setup_dropin()
{
	droppers = GetEntArray( "tunnel_drop_in", "script_noteworthy" );
	array_thread( droppers, ::add_spawn_function, ::drop_in_then_seek, level.woods );
	
	for( i = 0; i < droppers.size; i++ )
	{
		droppers[i] add_spawn_function( ::drop_dust_fx, droppers[i].script_int );
	}
	
	//array_thread( droppers, ::add_spawn_function, ::player_seek_no_cover, level.woods );	
}

drop_dust_fx( exploder_num )
{
	if(IsDefined(exploder_num))
	{
		exploder( exploder_num );
	}
}

setup_strafer()
{
	strafer = GetEnt("tunnel_strafe_guy", "targetname");
	strafer add_spawn_function( ::tunnel_strafer_animate );
	
	trigger_wait("trig_ai_spawn_strafer");
	trigger_use("trig_spawn_strafer");
}

tunnel_strafer_animate()
{
	self endon("death");
	//struct = getstruct("struct_strafe_guy", "targetname");
	
	//self.animname = "generic";
	//self.allowdeath = true;
	//struct maps\_anim::anim_generic_aligned( self, "strafe_tunnel" );
	add_generic_ai_to_scene( self, "strafe_tunnel" );
	run_scene( "strafe_tunnel" );
	
	self disable_pain();
	self.goalradius = 32;
	self set_ignoreall(true);
	self.ignoreme = true;
	self.noDodgeMove = true;
	
	node = GetNode("strafe_goto_node", "targetname");
	self SetGoalNode( node );
	self waittill("goal");
	//self Delete();
	
	self enable_pain();
	self.goalradius = 1024;
	self set_ignoreall(false);
	self.ignoreme = false;
	self.noDodgeMove = false;
	
	//self SetGoalPos( (-6513, -47880, -406) ); //-- bad hardcoded number
	//self force_goal((-6513, -47880, -406), 32, false, "none_really");
}

setup_tunnel_signaler()
{
	signaler = GetEnt("tunnel_signaler", "script_noteworthy");
	signaler add_spawn_function( ::tunnel_signaler_animate );
}

tunnel_signaler_animate()
{
	struct = getstruct("struct_tunnel_signaler", "targetname");
	//warp_pos = groundpos( struct.origin );
	//self ForceTeleport(warp_pos, struct.angles);
	self ForceTeleport(struct.origin, struct.angles);
	
	level notify("stop_custom_dds");
	level notify("signaler_alive", self);
	//self.allowdeath = true;
	//self maps\_anim::anim_generic( self, "relaxed_signal" );
	add_generic_ai_to_scene( self, "relaxed_signal" );
	run_scene( "relaxed_signal" );
	self.goalradius = 134;
	self SetGoalPos(self.origin);
}

setup_crouch_spot_attacker()
{
	attacker = GetEnt("crouch_attack_guy", "script_noteworthy");
	attacker add_spawn_function( ::tunnel_crouch_attack_animate );
}

tunnel_crouch_attack_animate() //-- self == animating ai
{
	self endon("death");
	//struct = getstruct("struct_attack_crouch", "targetname");
	
	//self.animname = "generic";
	self.ignoreme = true;
	//struct thread anim_first_frame( self, "attack_crouch_through");
	
	trigger_wait("trig_spawn_big_room_ai");
	wait(0.3);
	
	self.ignoreme = false;
	//self.allowdeath = true;
	//struct maps\_anim::anim_generic_aligned( self, "attack_crouch_through" );
	add_generic_ai_to_scene( self, "attack_crouch_through" );
	run_scene( "attack_crouch_through" );
	self.goalradius = 1024;
}

setup_machete_attacker()
{
	attacker = GetEnt("crouch_machette_attack_guy", "script_noteworthy");
	attacker add_spawn_function( ::tunnel_machete_attack_animate );
}

tunnel_machete_attack_animate()
{
	self endon("death");
	struct = getstruct("struct_machete_over", "targetname");
	
	//self thread maps\_baton_guard::make_machete_guard();
	//self.animname = "generic";
	self.ignoreme = true;
	self SetCanDamage(false);
	
	struct thread anim_first_frame( self, "machete_over", undefined, "generic" );
	
	nd_machete = GetNode( "drop_down_guy_goal_1", "targetname" );
	self set_goal_pos( nd_machete.origin );
	self.goalradius = 16;
	
	trigger_wait("trig_baton_rusher");
	
	self thread maps\_baton_guard::make_machete_guard();
	
	//self SetCanDamage(true);
	self.health = 100;
	self.ignoreme = false;
	//self.allowdeath = true;
	//struct maps\_anim::anim_generic_aligned( self, "machete_over" );
	add_generic_ai_to_scene( self, "machete_over" );
	level thread run_scene( "machete_over" );
	
	flag_wait( "machete_over_started" );
	
	wait 0.05;
	
	//RecorderPlayback();
}

setup_ledge_respawn()
{
	level endon("obj_russian_start"); //-- player already made it to the room with the russian
	
	level waittill("ledge_cleared");
	level waittill("ledge_cleared");
	
	//struct = getstruct( "struct_ledge_dropdown", "targetname" );
	
	wait(2);
	
	//-- this guy takes up the previous guard node
	guy1_spawner = GetEnt("ledge_dropdown_guy_1", "targetname");
	guy1_spawner add_spawn_function( ::drop_dust_fx, guy1_spawner.script_int );
	
	guy1 = simple_spawn_single("ledge_dropdown_guy_1");
	
	//guy1.animname = "generic";
	//guy1.allowdeath = true;
	guy1.goalradius = 32;
	
	//struct anim_generic_aligned( guy1, "drop_down" );
	add_generic_ai_to_scene( guy1, "drop_down" );
	add_scene_properties( "drop_down", "struct_ledge_dropdown" );
	run_scene( "drop_down" );
	
	guy1 SetGoalNode( GetNode("ledge_node", "targetname") );
	
	guy1 waittill_either("goal", "death");
	
	nodes = [];
	nodes[0] = GetNode("drop_down_guy_goal", "targetname");
	nodes[1] = GetNode("drop_down_guy_goal_1", "targetname");
	
	guy2_spawner = GetEnt("ledge_dropdown_guy_2", "targetname");
	guy2_spawner add_spawn_function( ::drop_dust_fx, guy2_spawner.script_int );
	
	for( i=0; i < 2; i++ )
	{
		spawner = GetEnt("ledge_dropdown_guy_2", "targetname");
		spawner.count = 1;
		spawner.target = nodes[i].targetname;
		
		guy2 = simple_spawn_single("ledge_dropdown_guy_2");
		
		//guy2.animname = "generic";
		//guy2.allowdeath = true;
		
		//struct anim_generic_aligned( guy2, "drop_down" );
		add_generic_ai_to_scene( guy2, "drop_down" );
		run_scene( "drop_down" );
		
		guy2.goalradius = 1024;
	}
}

setup_leaper()
{
	leaper = GetEnt("leaper_guy", "script_noteworthy");
	leaper add_spawn_function( ::tunnel_leaper_animate_then_cover );
	leaper add_spawn_function( ::notify_leaper_on_damage );
	leaper add_spawn_function( ::notify_respawner_on_death_or_leap );
	
	leaper_friend = GetEnt("leaper_guy_friend", "script_noteworthy");
	leaper_friend add_spawn_function( ::notify_leaper_on_damage );
	leaper_friend add_spawn_function( ::notify_respawner_on_death_or_leap );
	leaper_friend add_spawn_function( ::kill_me_after_this_trigger_with_delay );
}

kill_me_after_this_trigger_with_delay() //-- this guy needs to die before the respawners will trigger
{
	self endon("death");
	
	trigger_wait("trig_baton_rusher");
	wait(3);
	self ragdoll_death();
}

notify_leaper_on_damage()
{
	self waittill("damage");
	trigger_use("trig_the_leaper");
}

notify_respawner_on_death_or_leap()
{
	self waittill_either("death", "leapt");
	level notify("ledge_cleared");
}

tunnel_leaper_animate_then_cover() //-- self == animating ai
{
	self endon("death");
	//struct = getstruct( "struct_leap_off_point" );
	
	self.health = 10000;
	//self.animname = "generic";
	self.ignoreme = true;
	self.goal_radius = 16;
	self SetGoalPos( self.origin );
	
	trigger_wait("trig_the_leaper"); //-- This goes off when the player goes under the lower section
	
	//struct anim_reach_aligned( self, "leap_off_ledge" );
	//struct anim_generic_aligned( self, "leap_off_ledge" );
	add_generic_ai_to_scene( self, "leap_off_ledge" );
	run_scene( "leap_off_ledge" );
	
	self notify("leapt");
	
	node = GetNode("node_leaper_cover", "targetname");
	self SetGoalNode(node);
	self waittill("goal");
	
	self.health = 100;
	self.ignoreme = false;
	self.goalradius = 1024;
}

setup_table_pulldown_guy()
{
	pull_downer = GetEnt("table_pullover_guy", "script_noteworthy");
	pull_downer add_spawn_function( ::tunnel_pulldown_table_then_fight );
}

tunnel_pulldown_table_then_fight() //-- self == animating ai
{
	self endon("death");
	//self SetCanDamage(false);
	self.ignoreme = true;
	//self.animname = "generic";
	self AllowedStances("stand");
	//struct = getstruct("struct_table_pulldown", "targetname");
	
	self waittill_looked_at_or_trigger("trig_pulldown_table");
	
	//struct anim_reach_aligned( self, "pulldown_table" );
	//struct thread anim_generic_aligned( self, "pulldown_table" );
	add_generic_ai_to_scene( self, "pulldown_table" );
	level thread run_scene( "pulldown_table" );
	
	while(1)
	{
		self waittill( "single anim", msg );
		
		if(msg == "end")
		{
			continue;
		}
		
		if(msg == "rack_fall")
		{
			self SetAnimLimited( level.scr_anim[ "generic" ][ "pulldown_table" ], 1, 0, 0);
			
			player = get_players()[0];
			//player waittill_player_looking_at( self.origin + (0,0,60), 0.92, true );
			player waittill_player_looking_at( self.origin + (0,0,60), 0.88, false );
		
			self SetAnimLimited( level.scr_anim[ "generic" ][ "pulldown_table" ], 1, 0, 1);
			
			level thread rotate_table();
			self SetCanDamage( true );
			self.allowdeath = true;
		}
	}
	
	self AllowedStances("stand", "crouch");
	self.ignoreme = false;
	self.goalradius = 256;
	
}

setup_table_hindbehind_guy()
{
	hide_behinder = GetEnt("cover_behind_table_guy", "script_noteworthy");
	hide_behinder add_spawn_function( ::tunnel_hide_behind_table_guy );
}

tunnel_hide_behind_table_guy()
{
	self endon("death");
	self.goalradius = 16;
	self SetGoalPos( self.origin );
	
	level waittill("table_now_cover");
	
	self.goalradius = 256;
}

rotate_table()
{
	table = GetEnt("prop_table_pulldown", "targetname");
	
	struct = getstruct( "struct_table_pivot", "targetname" );
	pivot = Spawn("script_model", struct.origin );
	pivot SetModel( "tag_origin" );
	pivot.angles = struct.angles;
	
	table LinkTo(pivot);
	
	pivot RotateRoll(90, 0.75, 0.7, 0);
	pivot waittill("rotatedone");
	
	covernodes = GetNodeArray("node_table_pulldown", "targetname");
	for( i=0; i < covernodes.size; i++)
	{
		SetEnableNode(covernodes[i], true);
	}
	level notify("table_now_cover");
	
	table Unlink();
	pivot Delete();
}

waittill_looked_at_or_trigger(trig_name) //-- self is the AI to look at
{
	trigger = GetEnt(trig_name, "targetname");
	trigger endon("trigger");
	
	get_players()[0] waittill_player_looking_at( self.origin + (0,0,60), 0.8, false );
}

drop_in_then_seek( extra_target )
{
	//struct = getstruct( self.script_string, "targetname" );
	
	//self.animname = "generic";
	//self.allowdeath = true;
	
	//struct anim_generic_aligned( self, "drop_down" );
	add_generic_ai_to_scene( self, "drop_down" );
	add_scene_properties( "drop_down", self.script_string );
	run_scene( "drop_down" );
	
	self thread player_seek_no_cover(extra_target);
}


spetz_escape_scene( spetz )
{
	/#
	get_players()[0] FreezeControls(false);
	#/
	
	if( !IsDefined( spetz ) )
	{
			spetz_spawner = GetEnt( "spetz_escape_spawner", "targetname");
			spetz = spetz_spawner DoSpawn();
			
			if( !IsDefined( spetz.animname ) )
			{
				spetz.animname = "spetsnaz";
			}
			
			level.ai_the_russian = spetz;
	}
	
	level.ai_the_russian SetCanDamage( false );
	
	level thread kill_all_other_ai( level.ai_the_russian ); //-- pass the exception
	
	spetz.health = 200;
	spetz set_ignoreme(true);
	align_node = getstruct("struct_align_spetz_escape", "targetname");
	
	spetz thread adjust_bullet_cam_based_on_notetracks();
	align_node thread when_hit_play_fall(spetz); //-- self == align_node
	//align_node thread maps\_anim::anim_single_aligned( spetz, "escape");
	level thread run_scene( "escape" );
	
	escape_anim_time = GetAnimLength( level.scr_anim["spetsnaz"]["escape"] );
	level thread woods_kill_russian( escape_anim_time - 3.0 );
	
	flag_set("obj_russian_start");
	
	level thread VO_spetz_escaping();
	
	//-- Continue with the rest of the scene
	flag_wait("spetz_fell");
	flag_set("obj_chase_russian_complete");
	autosave_by_name( "russian_killed" );
	
	level.woods thread stop_shoot_at_target();
	level.woods.perfectaim = false;	//-- incase it was turned on, but the thread ended
	align_node thread woods_climb_up_animation();
	
	flag_wait("bowman_vo_finished");
	flag_wait("obj_boost_woods");
	
	//-- Spawn Trigger Radius for the player
	level.boost_up_trig_origin = GetStartOrigin( align_node.origin, align_node.angles, level.scr_anim[ "player_hands" ][ "climb_up" ]);
	boost_up_trig = spawn( "trigger_radius", level.boost_up_trig_origin - (0,0,100), 0, 24, 1000);
	boost_up_trig waittill("trigger", who);	
	if(who GetStance() != "stand")
	{
		while(who.divetoprone)
		{
			wait(0.2);
		}
		
		who FreezeControls(true);
		
		who SetStance( "stand" );
		wait(0.5);
		who FreezeControls(false);
	}
	
	flag_set("obj_boost_woods_complete");
	
	//player = get_players()[0];
	//level.player AllowPickupWeapons( false );
	//player_body = spawn_anim_model( "player_hands", (0,0,0) );
	//player_body Hide();
	//level.player thread take_and_giveback_weapons( "climb_up_scene_done" );
	//player PlayerLinkToAbsolute(player_body, "tag_player");
	
	//player StartCameraTween(1.0);
	//show_friendly_names( 0 );
	//align_node thread anim_single_aligned( player_body, "climb_up" );
	//wait(0.10);
	//player_body Show();
	//align_node waittill("climb_up");
	//show_friendly_names( 1 );
	//level.player Unlink();
	//player_body Delete();
	//level.player notify( "climb_up_scene_done" );
	//level.player AllowPickupWeapons( true );
	
	//level thread move_tunnel_player_clip( true );
	
	//autosave_by_name( "pow_boosted_out_of_tunnel" );
}

joanna_debug_trap()
{
	if ( !IsDefined( level.joanna ) )
	{
		level.joanna = 0;
	}
	
	level.joanna++;
}

kill_all_other_ai( exception ) //-- pass the exception
{
	axis = GetAIArray( "axis" );
	
	for( i = 0; i < axis.size; i++ )
	{
		if( axis[i] != exception && axis[i].targetname != "last_tunne_rusher_spawner_ai")
		{
			axis[i] thread ragdoll_death();
		}
	}
}

woods_kill_russian( delay )
{
	level endon("spetz_hit");
	wait( delay );
	
	level.woods.perfectaim = true;
	level.woods thread shoot_at_target_untill_dead( level.ai_the_russian );
	level.woods thread woods_VO_tunnel_fail();
	
	while(!flag("spetz_fell"))
	{
		wait(0.05);
	}	
	
	level.woods.perfectaim = false;	
}

woods_VO_tunnel_fail()
{
	level.after_russian_VO = true;

	level.woods say_dialog( "wakeup" );
	
	level.after_russian_VO = false;
}

adjust_bullet_cam_based_on_notetracks() //-- self is the spetsnaz escaping
{
	spetz = self;
	
	spetz endon("death");
	level endon("spetz_hit");
	
	times_invulnerable = 0;
	
	while(1)
	{
		self waittill( "single anim", msg );
		
		if(msg == "end")
		{
			break;
		}
		
		if( msg == "invulnerable")
		{
			if(times_invulnerable == 0)
			{
				times_invulnerable++;
				spetz SetCanDamage(false);
			}
		}
		else if(msg == "death_1")
		{
			spetz SetCanDamage(true);
			spetz.canned_death = "escape_death_1";
		}
		else if( msg == "death_2")
		{
			spetz SetCanDamage(true);
			spetz.canned_death = "escape_death_2";
		}
	}
}

woods_climb_up_animation()
{
	//-- prep woods and the player
	level.woods set_ignoreall(true);
	level.woods set_ignoreme(true);
	
	//self anim_reach_aligned( level.woods, "to_climb_up");
	//self anim_single_aligned( level.woods, "to_climb_up");
	run_scene( "to_climb_up" );
	//self thread anim_loop_aligned( level.woods, "wait_climb_up");
	level thread run_scene( "wait_climb_up" );
	
	flag_set("obj_boost_woods"); //-- woods is in position
	flag_wait("obj_boost_woods_complete"); //-- player is in position
	
	//-- give the exploder a little time to populate
	exploder(90);
	
	flag_wait("bowman_vo_finished");
	//self anim_single_aligned( level.woods, "climb_up");
	level.player AllowPickupWeapons( true );
	
	run_scene( "climb_up" );
	
	level.player AllowPickupWeapons( true );
	level thread move_tunnel_player_clip( true );
	autosave_by_name( "pow_boosted_out_of_tunnel" );
	
	flag_set("woods_done_with_climbup_anim");
}

play_escape_anim_watch_for_hit( spetz, my_anim ) //-- self == align_node
{
	level endon("spetz_hit");
	
	self thread when_hit_play_fall( spetz, my_anim );
	self anim_single_aligned( spetz, my_anim );
	
	self notify("stop_damage_watch");
}

#using_animtree( "generic_human" );
when_hit_play_fall(spetz, my_anim ) //-- self == align_node
{
	while(1)
	{
		spetz waittill("damage", amount, attacker);
		if(IsDefined(spetz.canned_death))
		{
			break;
		}
	}
	
	if(IsPlayer(attacker))
	{
		level thread player_killed_russian_vo(attacker);
	}

	if(!IsDefined(my_anim))
	{
		my_anim = spetz.canned_death;
	}
		
	flag_set("spetz_hit");
	
	level thread new_after_death_vo();
	
	//TUEY set music state to KILLED_RUSKY
	setmusicstate ("KILLED_RUSKY");
		
	self.allowdeath = false;
	//self anim_single_aligned( spetz, my_anim );
	run_scene( my_anim );
	
	//TUEY play radio per Cork
	level clientNotify ("rsd");
	clientnotify( "spetz_ded" );
	
	flag_set("spetz_fell");
}

new_after_death_vo()
{
	while(IsDefined(level.after_russian_VO) && level.after_russian_VO)
	{
		wait(0.05);
	}
	
	wait(0.5);
	player = get_players()[0];
	
	level.for_bowman_vo = true;
	level.woods anim_single( level.woods, "for_bowman" );
	wait(0.3);
	player anim_single( player, "for_bowman" );
	level.for_bowman_vo = false;
	wait(1.0);
	level.woods anim_single( level.woods, "lets_go" );
	level.woods anim_single( level.woods, "we_aint_got" );
	flag_set("bowman_vo_finished");
	
	/*
	level.scr_sound["barnes"]["for_bowman"] = "vox_pow1_s01_406A_wood"; // For Bowman.
  level.scr_sound["player"]["for_bowman"] = "vox_pow1_s01_407A_maso"; // For Bowman.
  //level.scr_sound["barnes"]["lets_go"] = "vox_pow1_s01_267A_wood_m"; //Let's go. //-- This line exists earlier, but is still in use for this scene
  level.scr_sound["barnes"]["we_aint_got"] = "vox_pow1_s11_002A_wood"; //We ain't got time to waste
  */
}

player_killed_russian_vo(attacker)
{
	level.after_russian_VO = true;
	attacker.animname = "player";
	level anim_single( attacker, "player_shot_russian" );
	wait(0.2);
	level anim_single( level.woods, "you_got_im");
	level.after_russian_VO = false;
}

tunnel_cleanup_after_fork()
{
	trigger_wait("tunnel_cleanup_sides");

	//-- disable trigger, but don't delete it
	trigger = GetEnt("woods_color_b4", "targetname");
	if(IsDefined(trigger))
	{
		trigger.color_enabled = false;
	}
	
	if (isdefined(level.woods))
	{
		level.woods maps\_gameskill::grenadeAwareness();
	}	

	ent_targetnames = array( "trig_spawn_very_first_rushers", "trig_spawn_big_room", "trig_spawn_big_room_rushers", "trig_spawn_tunnel_rushers_1",
													 "trig_spawn_left_tunnels_1", "trig_spawn_left_tunnels_dropin_1", "trig_spawn_left_tunnels_2",
													 "trig_spawn_left_tunnels_dropin_2", "trig_spawn_left_tunnel_rushers_1", "move_woods_to_split", "woods_color_b2", "woods_color_b3",
													 "tunnel_cleanup_sides", "trig_before_crouch_spot", "trig_ai_spawn_strafer", "trig_spawn_strafer", "woods_color_b10");

	for(i = ent_targetnames.size - 1 ; i > -1; i-- )
	{
		main_ent = GetEnt( ent_targetnames[i], "targetname" );
		
		if(IsDefined(main_ent) && IsDefined(main_ent.target))
		{
			sub_ents = GetEntArray( main_ent.target, "targetname" );
			array_delete(sub_ents);
		}
		
		if(IsDefined(main_ent))
		{
			main_ent Delete();
		}
	}
	
	level notify("right_trigs_deleted");
}

move_tunnel_player_clip( up )
{
	player_clip = GetEnt( "player_tunnel_blocker", "targetname" );
	
	if( up )
	{
		player_clip.origin = player_clip.origin + (0,0,5000);
	}
	else
	{
		player_clip.origin = player_clip.origin - (0,0,5000);
	}
}

VO_spetz_escaping()
{
	level notify("stop_tunnel_nag_lines");
	level.woods anim_single( level.woods, "trying_to_escape" );
	wait(0.1);
	if(!flag("spetz_hit"))
	{
		level.woods anim_single( level.woods, "bring_him_down" );
	}
}

VO_tunnel_reminder()
{
	level endon("stop_tunnel_nag_lines");
	level thread turn_battlechatter_back_on();
	
	player = get_players()[0];
	
	talkers = [];
	talkers[1] = array("barnes");
	talkers[2] = array("barnes", "player");
	talkers[3] = array("barnes");
	talkers[4] = array("barnes", "player");
	talkers[5] = array("barnes", "player");
	talkers[6] = array("barnes");
	//talkers[7] = array("barnes", "player");
	talkers[7] = array("barnes", "player");
	talkers[8] = array("player");
	talkers[9] = array("barnes");
	talkers[10] = array("barnes", "player");
	
	talk_num = 1;
	
	while(1)
	{
		wait(15);
		if(IsDefined(level.woods.color_node) && IsSubStr(level.woods.color_node.script_color_allies, "b23")) //-- kill this when Woods is running into the last section
		{
			return;
		}
		battlechatter_off();
		
		for(i=0; i<talkers[talk_num].size; i++)
		{
			if(talkers[talk_num][i] == "barnes")
			{
				level.woods anim_single( level.woods, "nag_" + talk_num );
			}
			else
			{
				player anim_single( player, "nag_" + talk_num );
			}
			wait(0.1);
		}
		
		battlechatter_on();
		
		talk_num++;
		if(talk_num > 10)
		{
			talk_num = 1;
		}
	}
}

turn_battlechatter_back_on()
{
	level waittill("stop_tunnel_nag_lines");
	battlechatter_on();
}
