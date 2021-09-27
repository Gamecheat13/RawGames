#include common_scripts\utility;
#include maps\_utility;
#include maps\_shg_common;
#include maps\castle_code;
#include maps\_anim;
#include maps\_stealth_utility;
#include maps\_audio;

// Start Functions	/////////////////////////////////////////////////////////////////////////////////////
start_bridge_crossing()
{
	move_player_to_start( "start_bridge_crossing" );
	setup_price_for_start( "start_bridge_crossing" );
	maps\_utility::vision_set_fog_changes( "castle_exterior", 0 );

}

// Init Functions	/////////////////////////////////////////////////////////////////////////////////////

init_event_flags()
{
	flag_init( "objective_comm_room" );
	flag_init( "objective_plant_bomb_bridge" );

	flag_init( "bomb_plant_start" );
	flag_init( "bomb_has_been_planted" );

	/*flag_init( "tower_guards_finished_patrol" );
	flag_init( "tower_guard_1_hit" );
	flag_init( "tower_guard_2_hit" );
	flag_init( "buddy_hit" );
	flag_init( "tower_guards_done" );
	flag_init( "guards_alerted" );*/
	
	flag_init( "on_scaffolding" );
	flag_init( "price_teleported" );
//	flag_init( "boards_broken" );
	flag_init( "shimmy_start" );
	flag_init( "shimmy_middle" );
	flag_init( "price_shimmies" );
	flag_init( "price_shimmy_done" );
	flag_init( "price_across_bridge" );
	
	flag_init( "alert_bridge_end_guys" );
}

// Main Functions	/////////////////////////////////////////////////////////////////////////////////////

bridge_crossing()
{
//-----JZ - disable color trigger until tower-guards are done
	//disable_trigger_with_targetname( "move_up_ladder" );

	set_lightning( 3, 10 );
	set_rain_level( 6 );
	level thread maps\castle_into_wet_wall::thundercracker();
	
	maps\_compass::setupMiniMap("compass_map_castle");
	
	level.price PushPlayer( true );
	
	flag_set( "objective_comm_room" );
	
	level.m_bridge_bomb = GetEnt( "bridge_bomb", "targetname" );

	level.price thread price_bridge_dialog();
	level.price thread price_watch_bomb_plant();
//-----JZ - commenting out stealth fail on bridge, adding guards you can optionally kill
	//level thread break_stealth();
	//level thread tower_guards_spawn();
	//level thread tower_guards_price_move();
//-----JZ - end commenting out stealth fail on bridge, adding guards you can optionally kill
	level thread btr_drives_across_bridge();
	level thread bomb_plant();
	level thread bridge_fxanims();
	level thread bridge_exploders();

//-----JZ - add an easy kill power moment at end of sequence
	//level thread easy_kill();
		
	flag_wait( "shimmy_start" );

	level thread player_shimmy_creak_and_rumble();
	level thread player_shimmy( "wall_climb_start" );
	
	// wait until the player is inside
	flag_wait( "wet_wall_start" );
	
	level.price PushPlayer( false );
	
	level notify( "price_stealth_end" );
}

/*tower_guards_price()
{
	level.price disable_ai_color();
	//IPrintLnBold( "Contact - on the roof.  Don't even think about it." );
	level.price thread dialogue_queue( "castle_pri_ontheroof" );
	
	level.price.ignoreall = true;
	level.price.ignoreme = true;
	level.price.script_pushable = false;
	
	level.player.ignoreme = true;
	battlechatter_off( "axis" );
	
	monitor_tower_guards();

	level.price.ignoreall = false;
	level.price.script_pushable = true;
	
	level.price enable_ai_color();
	trigger = GetEnt( "move_up_ladder", "targetname" );
	if ( isdefined(trigger) && !isdefined(trigger.trigger_off) )
	{
		enable_trigger_with_targetname( "move_up_ladder" );
	}	
}

monitor_tower_guards()
{
	level endon( "tower_guards_done" );
	level endon( "tower_guards_finished_patrol" );
	
	while(!flag("guards_alerted"))
	{
		if( flag( "_stealth_spotted" ))
		{
			flag_set( "guards_alerted" );
		}
		wait(.05);
	}
}
	
tower_guards_price_move()
{
	level endon( "tower_guards_finished_patrol" );
	flag_wait( "guards_alerted" );
	//IPrintLnBold( "You trying to be clever?" );
	level.price dialogue_queue( "castle_pri_becleva" );
	//wait(1);
	//IPrintLnBold( "Dammit!  Take 'em out!" );
	level.price thread dialogue_queue( "castle_pri_takehimout2" );
	
	level.price.ignoreall = false;
	level.price.baseaccuracy = 50000;
	
	waittill_dead_or_dying( level.tower_guards , level.tower_guards.size , 20 );
	flag_set( "tower_guards_done" );
	
	level.price.baseaccuracy = 1;
	level.price.ignoreall = true;
	level.price.ignoreme = true;
	
	level.player.ignoreme = true;
	
	battlechatter_off( "axis" );
}


tower_guards_spawn()
{
	flag_wait( "spawn_tower_guards" );
	
	level thread tower_guards_price();
	
	array_spawn_function_targetname( "bridge_tower_guards", ::tower_guards_patrol );
	level.tower_guards = array_spawn_targetname( "bridge_tower_guards" );
	level.tower_guard_1 = get_living_ai( "tower_guard_1", "script_noteworthy" );
	level.tower_guard_2 = get_living_ai( "tower_guard_2", "script_noteworthy" );
	
	//wait until player fires his weapon or throws a grenade
	while( 1 )
	{
		msg = level.player waittill_any_return( "weapon_fired", "grenade_fire" );
		if( msg == "grenade_fire" )
			break;
		if( msg == "weapon_fired" )
		{
			weap = level.player GetCurrentWeapon(); 
    		if( ( weap != level.castle_main_weapon ) && ( weap != level.castle_side_weapon ) ) 
    			break;
		}
		if( flag("_stealth_spotted"))
		{
			break;
		}
	}
	
	level.tower_guard_1 notify( "player_found" );
	level.tower_guard_2 notify( "player_found" );
}

tower_guards_patrol()
{
	self endon( "damage" );
	self endon( "death");
	self endon( "enemy");

	self.ignoreall = true;
	wait(.25);
	
	self thread tower_guards_damage();

	self waittill( "reached_path_end" );
	flag_set( "tower_guards_finished_patrol" );
	self delete();
}

tower_guards_damage()
{
	//self endon( "death" );
	self endon( "reached_path_end" );
		
	self waittill_any( "damage", "buddy_hit", "player_found" );
	if( self == level.tower_guard_1)
	{
		level.tower_guard_2 notify( "buddy_hit" );
	}
	else if( self == level.tower_guard_2)
	{
		level.tower_guard_1 notify( "buddy_hit" );
	}
	flag_set("_stealth_spotted");
	level notify( "enemy" );
	self.ignoreall = false;
	
	level.price.ignoreme = false;
	level.player.ignoreme = false;
		
	battlechatter_on( "axis" );
	
	if( self == level.tower_guard_1)
	{
		if( isAlive(self))
		{
			flag_set( "tower_guard_1_hit" );
			self.fixednode = true;
			self.forcednode = true;
			node = GetNode( "tower_node1", "targetname" );
			self SetGoalNode( node );
		}
	}
	else if( self == level.tower_guard_2)
	{
		if( isAlive(self))
		{
			flag_set( "tower_guard_2_hit" );
			self.fixednode = true;
			self.forcednode = true;
			node = GetNode( "tower_node2", "targetname" );
			self SetGoalNode( node );
		}

	}
}*/
	
//
//	Spawn guards and Allow Price to be killed
/*break_stealth()
{
	level endon( "wet_wall_start" );
	level.player endon( "death" );
	
	//wait until player fires his weapon or throws a grenade
	while( 1 )
	{
		msg = level.player waittill_any_return( "weapon_fired", "grenade_fire" );
		if( msg == "grenade_fire" )
			break;
		if( msg == "weapon_fired" )
		{
			weap = level.player GetCurrentWeapon(); 
    		if( ( weap != level.castle_main_weapon ) && ( weap != level.castle_side_weapon ) ) 
    			break;
		}
	}
	
	level notify( "bridge_stealth_broken" );

	level.price.ignoreme = 0;
	level.player.ignoreme = 0;

	//spawn snipers on the overlook and enemies coming from the other side
	a_spawners = GetEntArray( "bridge_stealth_break", "targetname" );
	foreach( e_spawner in a_spawners )
	{
		e_ai = e_spawner spawn_ai( true );
		e_ai.favoriteenemy = level.price;
		e_ai.baseaccuracy = 1000;
	}
		
	level.price thread dialogue_queue( "castle_pri_spotted" );
	level.price stop_magic_bullet_shield();
	level.price.allowdeath = true;	// just in case
	
	level.price thread kill_price_if_taking_too_long();
	level.price waittill( "death", other );

	quote = undefined;
	if ( isplayer( other ) )
		// Friendly fire will not be tolerated.
		quote = &"SCRIPT_MISSIONFAIL_KILLTEAM_BRITISH";
	else
		// Your actions got Captain Price killed.
		quote = &"CASTLE_YOUR_ACTIONS_GOT_PRICE";

	setDvar( "ui_deadquote", quote );
	missionFailedWrapper();
}*/

btr_drives_across_bridge()
{
	btr = maps\_vehicle::create_vehicle_from_spawngroup_and_gopath( 910 )[0];
	// Prevent the BTR from shooting us
	level.price.ignoreme = true;
	level.price.ignoreall = true;
	level.price.alertlevel = "noncombat";
	level.player.ignoreme = true;
	
	aud_send_msg("btr_drives_across_bridge", btr);
	btr thread scaffold_shake();
	
	// Stops at the middle of the bridge, over the shimmy section
	btr waittill( "reached_end_node" );
	flag_wait( "shimmy_start" );

	nd_leave = GetVehicleNode( "nd_bomb_btr_leave", "targetname" );
	btr StartPath( nd_leave );

	// wait until the player is inside
	flag_wait( "wet_wall_start" );
	
	// Return to normal for next section
	level.price.ignoreme = false;
	level.price.ignoreall = false;
	level.player.ignoreme = false;
	
	btr Delete();
}


//
// self is the BTR
scaffold_shake()
{
	self endon( "death" );
	
	while (1)
	{
		self PlayRumbleOnEntity( "subtle_tank_rumble" );
		wait( 0.2 );
	}
}


//
//	Shaking scaffolding and breaking boards
bridge_fxanims()
{
	a_m_scaffolding_sm = GetEntArray( "fxanim_castle_scaff_sm_mod", "targetname" );
	foreach( m_scaffolding in a_m_scaffolding_sm )
	{
		m_scaffolding.animname = "bridge_scaffolding_small";
		m_scaffolding assign_animtree();
		m_scaffolding thread anim_loop_solo( m_scaffolding, "shake" );
		wait RandomFloatRange( 0.5, 3.0 );
	}

	a_m_scaffolding_lg = GetEntArray( "fxanim_castle_scaff_lrg_x_mod", "targetname" );
	foreach( m_scaffolding in a_m_scaffolding_lg )
	{
		m_scaffolding.animname = "bridge_scaffolding_large";
		m_scaffolding assign_animtree();
		m_scaffolding thread anim_loop_solo( m_scaffolding, "shake" );
		wait RandomFloatRange( 0.5, 3.0 );
	}
	
	// Flying Tarp
	flag_wait( "bridge_tarp_fly" );	// TEMP FLAG CHECK NEED A REAL ONE

	m_tarp = GetEnt( "fxanim_castle_bridge_tarp06_mod", "targetname" );
	m_tarp.animname = "bridge_tarp";
	m_tarp assign_animtree();
	m_tarp thread anim_single_solo( m_tarp, "gone_with_the_wind" );
	
	// Stop scaffold anims
	flag_wait( "wet_wall_start" );
	
	foreach( m_scaffolding in a_m_scaffolding_sm )
	{
		m_scaffolding notify( "stop_loop" );
	}
	foreach( m_scaffolding in a_m_scaffolding_lg )
	{
		m_scaffolding notify( "stop_loop" );
	}
}


bridge_exploders()
{
	flag_wait( "on_scaffolding" );
	
	exploder( 910 );		// Light crumble effects under the 1st arch.
	flag_wait( "bomb_plant_start" );

	exploder( 911 ); 		// Light Crumble effects under the second arch.

	flag_wait( "shimmy_middle" );

	exploder( 914 );		// debris falls from overhead
	
	flag_wait( "passed_bomb" );
	
	exploder( 912 );		// Light Crumble effects under the third arch.
}
	
//
//	Price instructs player to plant bomb, gets angry if player doesn't
//	self is level.price
price_watch_bomb_plant()
{
	self endon( "death" );
	
	s_align = get_new_anim_node( "castle_bridge" );

	flag_wait_any( "bomb_plant_start", "bomb_has_been_planted" );

	// hopefully making sure he stays in place.
	level.price disable_ai_color();
	
	flag_set( "objective_plant_bomb_bridge" );

	if( !flag( "bomb_has_been_planted" ))
	{
		s_align price_to_bomb_plant( level.price );
	}
	
//	level.price StopAnimScripted();
//	level.price notify( "killanimscript" );
	//wait(3);
	//s_align notify( "stop_loop" );

	// Price "plants" the bomb himself if the player didn't
	/*if ( !flag( "bomb_has_been_planted" ) )
	{
		level.m_bridge_bomb SetModel( "weapon_c4" );
		
		t_bomb_plant = GetEnt( "trig_bridge_bomb", "targetname" );
		t_bomb_plant Delete();

		flag_set( "bomb_has_been_planted" );

		level.price dialogue_queue( "castle_pri_plantmyself" ); // Bloody hell, Yuri! I'll plant the damn thing myself!
	}*/
	
	distance_player_to_price = Distance(level.player.origin,level.price.origin);
	if ( distance_player_to_price > 250 )
	{
		// Incase price is climbing a ladder
		level.price notify( "killanimscript" );

		s_teleport = getstruct( "bridge_price_teleport", "targetname" );
		level.price ForceTeleport( s_teleport.origin, s_teleport.angles );
		flag_set( "price_teleported" );
	}
		
	s_align anim_reach_solo( level.price, "bridge_shimmy" );
	
	if( !flag( "price_teleported" ))
	{
		wait(3.0);
	}
	else
	{
		wait(1.25);
	}
	
	flag_set( "price_shimmies" );
	s_align notify( "stop_loop" ); //trying stop loop here to keep him in place.
	s_align anim_single_solo( level.price, "bridge_shimmy" );
	flag_set( "price_shimmy_done" );
	
	level.price enable_ai_color();
	
	flag_wait( "passed_bomb" );
	
	wait 3;
	
	s_align anim_reach_solo( level.price, "bridge_mantle" );
	s_align anim_single_solo_run( level.price, "bridge_mantle" );
	
	level.price enable_ai_color();
	
	flag_set( "price_across_bridge" );
}

//seperate function end early if player plants bomb fast
price_to_bomb_plant( price )
{
	level endon( "bomb_has_been_planted" );
	//level endon( "passed_bomb" );
	
	self anim_reach_solo( price, "bridge_instruct_bombplant" );
	self anim_single_solo( price, "bridge_instruct_bombplant" );
	self anim_loop_solo( price, "bridge_instruct_idle" );
}

bomb_plant()
{
	//level endon( "passed_bomb" );
	
	t_bomb_plant = GetEnt( "trig_bridge_bomb", "targetname" );
	t_bomb_plant UseTriggerRequireLookAt();
	t_bomb_plant waittill( "trigger" );
	t_bomb_plant Delete();
	
	aud_send_msg("player_plant_c4_bridge");
	
	level.player AllowCrouch( false );
	level.player AllowProne( false );

	//timed so Price starts the ledge crawl cinematically
	//delayThread( 3.0, ::flag_set, "bomb_has_been_planted" );
	flag_set( "bomb_has_been_planted" );
	
	level.m_bridge_bomb Hide();
	s_align = get_new_anim_node( "castle_bridge" );
	s_align thread do_player_anim( "bridge_bomb_plant", undefined, true, 0.5 );
	level.player.m_player_rig Attach( "weapon_c4", "tag_weapon", true );
	s_align waittill( "bridge_bomb_plant" );
	
	level.player AllowCrouch( true );
	level.player AllowProne( true );

	level.m_bridge_bomb SetModel( "weapon_c4" );
	level.m_bridge_bomb Show();
}


//
//	Dialog
//	self is price
price_bridge_dialog()
{
	level endon( "bridge_stealth_broken" );
	
	//self dialogue_queue( "castle_pri_undergoing" );
	//self dialogue_queue( "castle_pri_restoration" );
	//self dialogue_queue( "castle_pri_rightpath" );
	
	//flag_wait_any( "tower_guards_done", "tower_guards_finished_patrol" );
	flag_wait( "on_scaffolding" );
	
	self thread price_ladder_wait();

	flag_wait( "bomb_plant_start" );

	self dialogue_queue( "castle_pri_thisbridge2" );
	self dialogue_queue( "castle_pri_c4oncolumn" );

	self thread price_shimmy_wait();
}

//
//	Nags if you don't get up the ladder
price_ladder_wait()
{
	level endon( "bomb_has_been_planted" );
	level endon( "bridge_stealth_broken" );
	
	self waittill( "goal" );

	wait 3;	
	
	if( !flag( "on_scaffolding" ) )
	{
		//self dialogue_queue( "castle_pri_morecharges" );
	}
}

//
//	Price waits for the player to plant the bomb so he can advance
price_shimmy_wait()
{
	//level endon( "passed_bomb" );
	//level endon( "bridge_stealth_broken" );
	
	a_nag_lines[0] = "castle_pri_plantc4hurry"; // Plant the damn C4, Yuri.  Hurry.
	a_nag_lines[1] = "castle_pri_plantc4hurry"; // Plant the damn C4, Yuri.  Hurry.
	a_nag_lines[2] = "castle_pri_plantc4hurry"; // Plant the damn C4, Yuri.  Hurry.
	
	nag_vo_until_flag( a_nag_lines, "bomb_has_been_planted", 10, false, false );
	
	flag_wait( "bomb_has_been_planted" );
	wait(3.0);
	
	flag_wait( "price_shimmies" );
	wait 3.0;	// give him time to get moving

	self dialogue_queue( "castle_pri_abouttocollapse" );
	wait(.5);
	self dialogue_queue( "castle_pri_sotakeitslow" );
	
	//flag_wait( "price_shimmy_done" );
	wait(6);
	
	if ( !flag( "shimmy_creak2" ) )
	{
		self dialogue_queue( "castle_pri_alittletooslow" );
	}
	//flag_wait( "flag_rooftops_shimmy_player_slow" );
	
	//self dialogue_queue( "castle_pri_watchstep" );
	
	// Move Price up
	/*if ( !flag( "passed_bomb" ) )
	{
		activate_trigger( "bomb_bypass", "targetname" );
	}*/
}

player_shimmy_creak_and_rumble()
{
	flag_wait( "shimmy_creak1" );
	level.player PlayRumbleOnEntity( "grenade_rumble" );
	aud_send_msg("player_shimmy_boards");
	
	flag_wait( "shimmy_creak2" );
	level.player PlayRumbleOnEntity( "grenade_rumble" );
	aud_send_msg("player_shimmy_boards");
	
	flag_wait( "shimmy_creak3" );
	level.player PlayRumbleOnEntity( "grenade_rumble" );
	aud_send_msg("player_shimmy_boards");
	
}

/*easy_kill()
{
	flag_wait( "spawn_bridge_end_guys" );
	
	disable_trigger_with_targetname( "start_wet_wall" );
	
	array_spawn_function_targetname( "bridge_easy_kill", ::easy_kill_guard_setup );
	level.end_guards = array_spawn_targetname( "bridge_easy_kill" );
	
	flag_wait( "bridge_end_player_sees" );
	wait(.25);
	//IPrintLnBold( "Enemy patrol.  Make it quick." );
	level.price dialogue_queue( "castle_pri_enemypartrol" );
	
	flag_wait_or_timeout( "alert_bridge_end_guys", 5 );

	flag_set( "alert_bridge_end_guys" );
	battlechatter_on( "axis" );
	
	level.price.ignoreall = false;
	level.price.ignoreme = false;
	level.price.baseaccuracy = 50000;
		
	level.player.ignoreme = false;
	
	waittill_dead_or_dying( level.end_guards , 2 , 12 );
	
	enable_trigger_with_targetname( "start_wet_wall" );

	// Return to normal for next section
	level.price.baseaccuracy = 1;
}

easy_kill_guard_setup()
{
	self.ignoreall = true;
	self.ignoreme = true;
		
	self thread easy_kill_guard_react();
	
	level.player waittill_any_return( "weapon_fired", "grenade_fire" );
	flag_set( "alert_bridge_end_guys" );
}

easy_kill_guard_react()
{
	flag_wait( "alert_bridge_end_guys" );
	
	flag_set("_stealth_spotted");
	
	self.ignoreall = false;
	self.ignoreme = false;
	self.favoriteenemy = level.player;
}*/
