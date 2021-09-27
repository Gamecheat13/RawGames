#include common_scripts\utility;
#include maps\_utility;
#include maps\_shg_common;
#include maps\castle_code;
#include maps\_anim;
#include maps\_vehicle;
#include maps\_audio;

// Start Functions	/////////////////////////////////////////////////////////////////////////////////////
start()
{
	flag_set( "ruins_done" );
	
	setup_price_for_start( "start_courtyard_activity", ::price_stealth_think );
	move_player_to_start( "start_courtyard_activity" );
	thread maps\castle_courtyard_activity::base_lights_on( level.price );  // have base lights start on
	maps\_utility::vision_set_fog_changes( "castle_exterior", 0 );
	set_ents_visible( "startvista", true );
}

// Main Functions	/////////////////////////////////////////////////////////////////////////////////////

main()
{
	/#
	iprintln( "courtyard activity" );
	#/
/*		
	//if the player has been spotted don't run courtyard logic	
	if( flag( "_stealth_spotted" ) )
	{
		return;
	}
*/		
	//disable_player_clip();
	
	flag_wait("ruins_done");
/*	
	courtyard_trigger = getent("courtyard_stealth_trigger", "targetname");
	courtyard_trigger trigger_off();
*/	
	level thread remove_all_hint_if_alerted();
	
	spawn_vehicles_from_targetname( "courtyard_stealth_btr1" );	
	stealth_guys = array_spawn_targetname( "courtyard_stealth_guys", true );
	array_spawn_targetname( "courtyard_activity_guys", true );
	
	stealth_guys thread do_stealth_check_on_stealth_guards();
	
	setup_price( ::price_courtyard_activity );

	set_lightning( 3, 10 );
	set_cloud_lightning( 3, 6 );
	
	level thread courtyard_scene_btr_lift();
//	level thread courtyard_scene_ledge();  // these guys have a bug, and are hard to see anyway, so commenting out.
	
	courtyard_scene_guards();
	thread courtyard_remove_guys_for_stealth();
	
	battlechatter_off( "allies" );
}

do_stealth_check_on_stealth_guards()
{
	temp_friend_array = [];
	
	for(i = 0; i < self.size; i++)
	{
		if(isdefined( self[i].script_noteworthy ) && self[i].script_noteworthy == "overlook_intro_guard")
		{
			self[i] thread grenade_throw_break_stealth();
			temp_friend_array[ temp_friend_array.size ] = self[i];
			self[i] thread flashlight_on(true);
			
		}	
	}
	
	if(temp_friend_array.size == 2)
	{
		temp_friend_array[0] thread send_alert_if_friend_dies(temp_friend_array[1]);
		temp_friend_array[1] thread send_alert_if_friend_dies(temp_friend_array[0]);
		
	}
	
}

send_alert_if_friend_dies(friend)
{
	level endon( "start_stealth_guard_patroll" );
	level endon( "_stealth_spotted" );
	
	self waittill_any("death", "friend_died");
	
	friend notify("friend_died");
	flag_set("_stealth_spotted");
	
}

init_event_flags()
{
	flag_init("player_at_overlook");
	flag_init( "do_courtyard_activity" );
	flag_init( "do_btr_lift" );
	flag_init( "stadium_lights_on" );
	flag_init( "btr_dropped" );
	flag_init( "courtyard_activity_done" );
	flag_init("price_going_in");
	flag_init("motorpool_guard1_patrol_start");
}

price_go_to_overlook(align)
{
	level endon("_stealth_spotted");
	node = GetNode("price_overlook_pos", "targetname");

	level.price.pacifist = true;
	level.price.ignoreme = true;
	
	old_radius = level.price.goalradius;	
	level.price enable_sprint();
	level.price disable_ai_color();
//	level.price	set_goal_radius(200);
//	level.price SetGoalNode(node);
//	wait 1;
//	level.price waittill("goal");
	align anim_reach_solo(level.price, "approach_overlook");
	align anim_single_solo(level.price, "approach_overlook");
	level.price disable_sprint();
	level.price set_goal_radius(old_radius);
}

#using_animtree( "generic_human" );
price_courtyard_activity()
{
	self endon( "death" );
	level endon( "_stealth_spotted");
	
	if (flag("ruins_failed"))
	{
		flag_waitopen("_stealth_spotted");
	}
	
	//enable_player_clip();
	
	flag_wait( "ruins_done" );
	align = get_new_anim_node( "anim_align_dropdown" );
	price_go_to_overlook(align);
	exploder(50);
	
//	align anim_single_solo( self, "run_to_outlook" );
//	self ClearAnim( %root, 0 );
	
	set_rain_level( 5 );
	
	thread maps\castle_code::price_catch_up_nag(7, "player_at_overlook");
	//make sure the player is close before starting
	self price_overlook_wait( align );
	
/*	-Removed nvg moment-
	align anim_single_solo( self, "put_on_goggles" );
	
	align thread anim_loop_solo( self, "night_watch" );
	
	if( !flag( "nvg_on" ) )
	{
		self thread	price_night_vision_nag();
	}
	waittill_player_uses_goggles();

	align notify( "stop_loop" );
	//self thread price_vo_courtyard_2();
	align anim_single_solo( self, "not_much_at_all" );
	align anim_single_solo( self, "remove_goggles" );
	
	align thread anim_loop_solo( self, "assess_situation" );
	
	waittill_player_takes_off_goggles();
*/	
	flag_set("player_at_overlook");
	flag_set( "do_btr_lift" );
	flag_set( "do_courtyard_activity" );

// 	removed to hasten Price up a bit.	
//	flag_wait( "btr_dropped" );
//	align notify( "stop_loop" );

	align thread anim_single_solo( self, "security_office_talk" );
	waitframe();
	self SetAnimTime((self getanim("security_office_talk")), 0.65);
	
	self waittillmatch("single anim", "end");
	flag_set("price_going_in");
	//delete_player_clip();
	
	stop_exploder(50);
	align anim_single_solo( self, "jump_down" );
	
	thread maps\castle_code::price_catch_up_nag(5, "stealth_player_in_motorpool");
	
	flag_set( "courtyard_activity_done" );
/*	
	courtyard_trigger = getent("courtyard_stealth_trigger", "targetname");
	courtyard_trigger trigger_on();
*/	
}

price_overlook_wait( s_anim_align)
{
	
	self endon("death");
	
	n_player_dist = 200;
	
	if( !players_within_distance( n_player_dist, self.origin ) )
	{
		s_anim_align thread anim_loop_solo( self, "do_not_engage" );
		
		while( !players_within_distance( n_player_dist, self.origin ) )
		{
			waitframe();
		}
		
		s_anim_align notify( "stop_loop" );
	}
	
	save_game("price_overlook");
}
/*
price_night_vision_nag()
{
	level endon( "nvg_on" );
	level endon( "_stealth_spotted");
	self endon( "death" );
	
	wait 5;
	//	Use your NVGs.	
	self dialogue_queue( "castle_pri_usenvgs" );
	wait 5;
	//	Yuri - Put on your bloody NVGs!	
	self dialogue_queue( "castle_pri_putonnvgs" );
}
*/
disable_player_clip()
{
	m_clip = GetEnt( "overlook_player_clip", "targetname" );
	m_clip NotSolid();
}

enable_player_clip()
{
	m_clip = GetEnt( "overlook_player_clip", "targetname" );
	m_clip Solid();
}

delete_player_clip()
{
	m_clip = GetEnt( "overlook_player_clip", "targetname" );
	m_clip Delete();
}

waittill_player_uses_goggles()
{
	flag_set("display_nvg_on_hint");
	flag_wait_or_timeout( "nvg_on", 15 );	
	wait 2;
}

waittill_player_takes_off_goggles()
{
	flag_set("display_nvg_off_hint");
	flag_waitopen_or_timeout( "nvg_on", 5 );
}

/*
//don't play VO directing player to use NVG if they are already on
nvg_line_check_1( price )
{
	price endon("death");
	
	if( !flag( "nvg_on" ) )
	{
		price dialogue_queue( "castle_pri_usenvg" ); //	Can't see much activity...  Use your NVGs.
	}
}

nvg_line_check_2( price )
{
	price endon("death");
	
	if( flag( "nvg_on" ) )
	{
		price dialogue_queue( "castle_pri_gogglesoff" ); // Goggles off!
	}
}
*/
//
//	Controls the big spotlights
//	This is used as a notetrack function, so price is needed
base_lights_on( price )
{
	level endon( "security_office_closed" );		// door is closed, can't return to courtyard
	
	flag_set( "stadium_lights_on" );

	while ( true )
	{
		if ( flag( "nvg_on" ) )
		{
			/* goggles are on - use IR versions of stadium lights */
			
			wait .9; // magic timing for putting the goggles on
			
			exploder( 504 );
			exploder( 505 );
			exploder( 506 );
			
			stop_exploder( 501 );
			stop_exploder( 502 );
			stop_exploder( 503 );
		}
		else
		{
			/* goggles are off - use regular versions of stadium lights */
			
			wait .5; // magic timing for taking the goggles off
			
			exploder( 501 );
			exploder( 502 );
			exploder( 503 );
			
			stop_exploder( 504 );
			stop_exploder( 505 );
			stop_exploder( 506 );
		}
		
		
		level.player waittill_either( "night_vision_on", "night_vision_off" );
		waittillframeend;
	}
}

courtyard_scene_guards()
{
	run_thread_when_spawned( "activity_initial_group2_guard1", "script_noteworthy", ::courtyard_scene_guard, "player_approaches_overlook" );
	run_thread_when_spawned( "activity_initial_group2_guard2", "script_noteworthy", ::courtyard_scene_guard, "player_approaches_overlook" );
	run_thread_when_spawned( "activity_initial_group2_guard3", "script_noteworthy", ::courtyard_scene_guard, "player_approaches_overlook" );
	
	run_thread_when_spawned( "btr_lift_guard1", "script_noteworthy", ::courtyard_scene_btr_lift_guard );
	run_thread_when_spawned( "btr_lift_guard2", "script_noteworthy", ::courtyard_scene_btr_lift_guard );
	run_thread_when_spawned( "btr_lift_guard3", "script_noteworthy", ::courtyard_scene_btr_lift_guard );
	run_thread_when_spawned( "btr_lift_guard4", "script_noteworthy", ::courtyard_scene_btr_lift_guard );
	run_thread_when_spawned( "btr_lift_guard5", "script_noteworthy", ::courtyard_scene_btr_lift_guard );

/*	converted messed up animation guys to pathing guys - also separated them from the motorpool stealth guys
	run_thread_when_spawned( "activity_group2_guard1", "script_noteworthy", ::courtyard_scene_guard, "do_courtyard_activity" );
	run_thread_when_spawned( "activity_group2_guard2", "script_noteworthy", ::courtyard_scene_guard, "do_courtyard_activity" );
	run_thread_when_spawned( "activity_group2_guard3", "script_noteworthy", ::courtyard_scene_guard, "do_courtyard_activity" );
 */

	run_thread_when_spawned( "activity_group2_guard1", "script_noteworthy", maps\castle_courtyard_stealth::motorpool_patrol );
	run_thread_when_spawned( "activity_group2_guard2", "script_noteworthy", maps\castle_courtyard_stealth::motorpool_patrol );
	run_thread_when_spawned( "activity_group2_guard3", "script_noteworthy", maps\castle_courtyard_stealth::motorpool_guard );


	run_thread_when_spawned( "activity_group2_guard_walker1", "script_noteworthy", ::courtyard_patrol_guard );
	run_thread_when_spawned( "activity_group2_guard_walker2", "script_noteworthy", ::courtyard_patrol_guard );

	run_thread_when_spawned( "activity_group3_guard1", "script_noteworthy", ::courtyard_scene_guard, "do_courtyard_activity" );
	run_thread_when_spawned( "activity_group3_guard2", "script_noteworthy", ::courtyard_scene_guard, "do_courtyard_activity" );
//	run_thread_when_spawned( "activity_group3_guard3", "script_noteworthy", ::courtyard_scene_guard, "do_courtyard_activity" );
}

courtyard_remove_guys_for_stealth()
{
	flag_wait("stealth_player_in_motorpool");
	delete_noteworthy("activity_initial_group2_guard2");
	delete_noteworthy("activity_initial_group2_guard3");
	delete_noteworthy("activity_group2_guard_walker1");
	delete_noteworthy("activity_group2_guard_walker2");
}

delete_noteworthy(name)
{
	guys = GetEntArray(name, "script_noteworthy");
	foreach (guy in guys)
	{
		if (IsDefined(guy))
		{
			guy Delete();
		}
	}
}


courtyard_scene_btr_lift()
{
	align = get_new_anim_node( "anim_align_helipad" );
	
	v_helicopter = spawn_vehicles_from_targetname( "courtyard_helicopter" )[0];
	v_helicopter.animname = "btr_helicopter";
		
	v_btr = spawn_vehicles_from_targetname( "courtyard_stealth_btr2" )[0];
	v_btr.animname = "btr";
	v_btr Vehicle_TurnEngineOff();
	
	m_rope = spawn_anim_model( "btr_rope" );
	
	align anim_first_frame( make_array( v_helicopter, v_btr, m_rope ), "btr_lift" );
	
	flag_wait( "do_btr_lift" );
	
	v_helicopter thread play_rotor_rain_fx();
	v_helicopter thread break_stealth_if_damaged();
	
	exploder( 520 );	// turns on warning lights on landing pad
	
	delayThread( 15, ::flag_set, "btr_dropped" );
	
	aud_send_msg("btr_sequence_start");
	
	align thread anim_single( make_array( v_helicopter, v_btr, m_rope ), "btr_lift" );
	
	wait(16);
	exploder(350);
	
	wait(20);
	stop_exploder(350);
	wait(15);

	array_delete( make_array( v_helicopter, m_rope ) );
}

//play rain fx on rotor.
play_rotor_rain_fx()
{
	self endon("death");
	
	while( isdefined( self ) )
	{
		PlayFXOnTag(level._effect[ "rotor_rain_effect" ], self, "origin_animate_jnt");
		wait(0.1);
	}
}

break_stealth_if_damaged()
{
	self endon("death");
	level endon("_stealth_spotted");
	
	self waittill("damage");
	flag_set("_stealth_spotted");
	
}


courtyard_scene_btr_lift_guard()
{
	self.animname = self.script_noteworthy;
	
	self thread grenade_throw_break_stealth();
	
	align = get_new_anim_node( "anim_align_helipad" );
	
	if ( level.start_point != "platform_crawl" && level.start_point != "security_office" )
	{
		align anim_first_frame_solo( self, "courtyard_activity_runup" );
		self hide();
		flag_wait( "do_btr_lift" );
		
		self endon( "death" );
		self endon( "bulletwhizby" );
		self endon( "flashbang" );
		self endon(	"grenade danger"); 
		self endon( "explode" );
		self endon( "stealth_enemy_endon_alert" );
		self endon( "damage" );
		level endon( "_stealth_spotted");
		
		self show();
		self.allowpain = true;
		align stealth_anim_single(self, "courtyard_activity_runup");
//		align anim_single_solo( self, "courtyard_activity_runup" );
		self ClearAnim( %root, 0 );
		align stealth_anim_single(self, "courtyard_activity");
//		align anim_single_solo( self, "courtyard_activity" );
	}
	
	if(isdefined(self.engage_enemy) && self.engage_enemy == true)
	{
		//iprintlnbold("enemy_spotted");
		
	}
	else if ( IsDefined( self.script_parameters ) && ( self.script_parameters == "delete" ) )
	{
		self Delete();
	}
	else
	{
		self SetGoalPos( self.origin );
		align stealth_anim_loop( self, "courtyard_activity_idle" );
	}
}

courtyard_scene_guard( str_flag )
{
	self.animname = self.script_noteworthy;

	self thread grenade_throw_break_stealth();
	
	if( isdefined( self.animname ) )
	{
		self.noragdoll = true;	
	}

	align = get_new_anim_node( "anim_align_helipad" ); // put it on self so we can access it later
	
	if ( level.start_point != "platform_crawl" && level.start_point != "security_office" )
	{
		align anim_first_frame_solo( self, "courtyard_activity" );
		self hide();
		if ( IsDefined( str_flag ) )
		{
			flag_wait( str_flag );
		}

		self endon( "death" );
		self endon( "stealth_enemy_endon_alert" );
		self endon( "bulletwhizby");
		self endon( "flashbang" );
		self endon(	"grenade danger"); 
		self endon( "explode" );
		self endon( "damage" );
		level endon( "_stealth_spotted");
		

		self show();
		align stealth_anim_single( self, "courtyard_activity" );
	}
	
	if(isdefined(self.engage_enemy) && self.engage_enemy == true)
	{
		//iprintlnbold("enemy_spotted");
		
	}
	else if ( IsDefined( self.script_parameters ) && ( self.script_parameters == "delete" ) )
	{
		self Delete();
	}
	else
	{
		self SetGoalPos( self.origin );
		
		if( IsDefined( level.scr_anim[ self.animname ][ "courtyard_activity_idle" ] ) )
		{
			align stealth_anim_loop( self, "courtyard_activity_idle" );
		}
	}
}

courtyard_patrol_guard()
{
	self endon( "death" );
	self endon( "stealth_enemy_endon_alert" );
	self endon( "bulletwhizby");
	self endon( "flashbang" );
	self endon(	"grenade danger"); 
	self endon( "explode" );
	self endon( "damage" );
	level endon( "_stealth_spotted");

	
	self.animname = self.script_noteworthy;

	self thread grenade_throw_break_stealth();

	
	if( isdefined( self.animname ) )
	{
		self.noragdoll = true;	
	}
	
	wait (RandomFloat(0.5));
	self thread maps\_patrol::patrol( self.target );

	self waittill("goal");
	
	self anim_loop_solo(self, "pairguards_idle");
}

	
track_location()
{
	while(1)
	{
		iprintln(self.origin[0] + " " + self.origin[1] + " " + self.origin[2]);
		wait(0.05);
	}
	
}

courtyard_scene_ledge()
{
	sp_ledge = GetEnt( "courtyard_activity_ledge", "targetname" );
	sp_ledge add_spawn_function( ::courtyard_scene_ledge_think );
	
	flag_wait( "do_btr_lift" );

	wait 5;
	
	while( sp_ledge.count > 0 )
	{
		sp_ledge spawn_ai();
		wait RandomFloatRange( 3.0, 7.0 );
	}
	
}

courtyard_scene_ledge_think()
{
	self endon( "death" );
	
	nd_goal = GetNode( "courtyard_activity_ledge_goal", "targetname" );
	
	self.goalradius = 32;
	self SetGoalPos( nd_goal.origin );
	self waittill( "goal" );
	self Delete();
}
remove_all_hint_if_alerted()
{
	level waittill("_stealth_spotted");
	level.player.nightVision_Started = true;
	wait(1);
	level.player.nightVision_Started = undefined;
}
