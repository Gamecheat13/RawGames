#include common_scripts\utility;
#include maps\_utility;
#include maps\_shg_common;
#include maps\castle_code;
#include maps\_anim;
#include maps\_stealth_utility;

// Start Functions	/////////////////////////////////////////////////////////////////////////////////////
start_ruins()
{
	move_player_to_start( "start_ruins" );
	setup_price_for_start( "start_ruins" );
	maps\_utility::vision_set_fog_changes( "castle_exterior", 0 );
	set_ents_visible( "startvista", true );
}

// Spawn Fucntions	/////////////////////////////////////////////////////////////////////////////////////

setup_spawn_funcs()
{
	// 1st group
	array_spawn_function_noteworthy( "ruins_patroller3", ::ruins_patroller, "ruins_first_patrol_flash", ::ruins_flashlight_patroller_go, "ruin_patrol_goal_0", "ruins_first_patrol_fighting" );
	array_spawn_function_noteworthy( "ruins_patroller4", ::ruins_patroller, "ruins_first_patrol_flash", ::ruins_patroller_go_nolight, "ruin_patrol_goal_1", "ruins_first_patrol_fighting" );
	
	// 2nd group
	array_spawn_function_noteworthy( "ruins_patroller1", ::ruins_patroller, "ruins_seconds_patrol_go", ::ruins_patroller_go, "ruin_patrol_goal_2", "ruins_second_patrol_fighting");
	array_spawn_function_noteworthy( "ruins_patroller2", ::ruins_patroller, "ruins_seconds_patrol_go", ::ruins_patroller_go, "ruin_patrol_goal_3", "ruins_second_patrol_fighting");
}

// Main Functions	/////////////////////////////////////////////////////////////////////////////////////

ruins_main()
{
	/#
	iprintln( "ruins" );
	#/

	level.ruins_spotted = 0;
	level.ruins_spotted_vo = [];
	level.ruins_spotted_vo[0] = "castle_pri_lightemup";
	level.ruins_spotted_vo[1] = "castle_pri_compromised";
		
	thread puddle_splashes();
	thread first_patrol();
	thread second_patrol();
	
	setup_price( ::price_ruins );
	
	thread maps\castle_courtyard_activity::base_lights_on( level.price );  // have base lights start on
//	level thread player_stealth_fail();
	level thread ruins_weather();
//	level thread ruins_fail();
	level thread set_alert_if_player_jump_early();
		
	battlechatter_off( "allies" );
	
	flag_wait( "spawn_courtyard_activity" );
//	flag_wait ("ruins_done");
}

init_event_flags()
{
	flag_init("ruins_alerted");
	flag_init( "ruins_done" );
	flag_init("ruins_seconds_patrol_go");
	flag_init("ruins_first_patrol_flash");
	flag_init("ruins_first_patrol_go");
	flag_init("ruins_flash_patrol_moving");
	flag_init("ruins_price_free");
	flag_init("ruins_first_patrol_fighting");
	flag_init("ruins_second_patrol_fighting");
	flag_init("continue_past_patrol");
	flag_init("ruins_failed");
}

first_patrol()
{
	guys = array_spawn_targetname( "ruins_patrol_spawners", true );
	
	foreach ( guy in guys )
	{
		guy thread stop_ruins_patrol_conv();
	}
	
	thread ruins_patrol_conv();
	
	waittill_dead_or_dying( guys , guys.size);
	
	flag_set("ruins_price_free");
	level.price notify("stop_animating");
}

stop_ruins_patrol_conv()
{
	if( IsDefined( self.animname ) && ( self.animname == "ruins_patroller4" ) )
	{
		level.ruins_patroller_4 = self;
	}
	
	if( IsDefined( self.animname ) && ( self.animname == "ruins_patroller3" ) )
	{
		level.ruins_patroller_3 = self;
	}
	
	self waittill_either( "damage" , "death" );
	
	level notify( "stop_ruins_patrol_conv" );
}

ruins_patrol_conv()
{
	level endon( "_stealth_spotted" );
	level endon( "stop_ruins_patrol_conv" );
	
	level waittill( "start_ruins_patrol_conv" );

	//Hey, Alexi.  How's life?
	level.ruins_patroller_4 dialogue_queue( "castle_ru1_howslife" );
	
	wait .5;
	
	//Cold, dark and wet.
	level.ruins_patroller_3 dialogue_queue( "castle_ru2_colddark" );
	
	wait .5;
	
	//I wasn't talking about your love life...
	level.ruins_patroller_4 dialogue_queue( "castle_ru1_lovelife" );
	
	wait .5;
	
	//Ha Ha.  Very funny.
	level.ruins_patroller_3 dialogue_queue( "castle_ru2_veryfunny" );
}

second_patrol()
{
	level endon("death");
	
	flag_wait("ruins_seconds_patrol_go");
		
	guys = array_spawn_targetname( "ruins_patrol_spawners2", true );
	
	level.price thread dialogue_queue( "castle_pri_wait3" );

	waittill_dead_or_dying( guys , guys.size , 15 );
	
	if (!flag("_stealth_spotted"))
	{
		flag_set( "continue_past_patrol" );
	}

}

price_ruins()
{
	self thread price_stealth_think();
	self thread price_move_think();
}

hide_pistol( price )
{
	price.m_price_pistol Hide();
}

price_move_think()
{
	align = get_new_anim_node( "ruins_middle" );
	
	self.m_price_pistol = spawn_anim_model( "price_pistol" );
	a_ents = make_array( self, self.m_price_pistol );
	waitframe();
		
	align anim_single( a_ents, "ruins_start" );
	align anim_single( a_ents, "ruins_talk" );
	
	self.m_price_pistol Delete();
	
	//starts the first patroller with the flashlight so he gets in his loop position
//	level.player thread player_stealth_break();
	level.ruins_screwups = 0;
	self thread price_stealth_break_think(align);
	flag_set("ruins_first_patrol_flash");

	self thread price_vo_ruins_1();
	self thread price_vo_ruins_2();

	self endon( "death" );
	self endon( "stop_animating" );
	level endon( "player_shot" );
	level endon( "ruins_alerted");
	
	delayThread(3, ::flag_set, "ruins_first_patrol_go");
	align anim_single_solo( self, "ruins_run_to_cover" );
	
///	align thread anim_loop_solo( self, "ruins_cover_wait" );
	//starts the next patroller who meets up with the first
	flag_set("ruins_first_patrol_go");

///	flag_wait( "ruins_movement_1" );
	
	
///	align notify( "stop_loop" );
	
	if (!flag("ruins_alerted"))
	{
		align anim_single_solo( self, "ruins_cover_hide" );
	}

	if( !flag("ruins_movement_1") && !flag("_stealth_spotted") )
	{
		thread maps\castle_code::price_catch_up_nag(5, "ruins_movement_1");
		align thread anim_loop_solo( self, "ruins_cover_wait" );
		flag_wait( "ruins_movement_1" );
		align notify( "stop_loop" );
	}

	save_game( "ruins_half_way" );
	
//	self delayThread( 6, ::price_stealth_break_think, align );
		
	if( !flag( "_stealth_spotted" ) )
	{
		//Move.	
		level.price DelayThread(1, ::dialogue_queue, "castle_pri_move3");

		align thread anim_single_solo( self, "ruins_run_to_patrol" );
		while( self getanimtime( getanim( "ruins_run_to_patrol" ) ) < 0.55 )
		{
			wait( 0.05 );
		}
//		self notify( "stop_animating" );
		self.a.pose = "crouch";
		self anim_stopanimscripted();
		self enable_cqbwalk();
		self enable_ai_color();
		flag_set("ruins_price_free");
		activate_trigger("soap_to_2nd_wall", "targetname");
	}
/// only uncomment the 2 lines below if we don't want price to wait forever at the covernode below	
///	wait 2;
///	do_second_patrol_group();
	thread maps\castle_code::price_catch_up_nag(9, "ruins_seconds_patrol_go");

/*	  
	if( !flag( "_stealth_spotted" ) )
	{
		align thread anim_loop_solo( self, "ruins_patrol_hide" );
	}
		
	level.player thread player_stealth_break();
	
	self waittill( "continue_past_patrol" );
	
	flag_wait( "ruins_movement_2" );
	
	flag_set( "ruins_done" );
	align notify( "stop_loop" );
*/
}

price_vo_ruins_1()
{
	self endon( "death" );
	level endon( "_stealth_spotted" );
	level endon( "player_shot" );
	
	flag_wait("ruins_first_patrol_go");
	//Get down.	
	self dialogue_queue( "castle_pri_getdown" );
	wait 2;
	//Get caught in those lights, and we're done before we've started.	
	self dialogue_queue( "castle_pri_beforestarted" );
}

price_vo_ruins_2()
{
	self endon( "death" );
	
	flag_wait( "continue_past_patrol" );
//	flag_clear("_stealth_spotted");

	flag_set("spawn_courtyard_activity");

	a_enemies = get_ai_group_ai( "ruins_patrol" );
	a_enemies = array_combine(a_enemies, get_ai_group_ai("ruins_patrol2") );
		
	if (a_enemies.size > 0 && flag("_stealth_spotted") )
	{
		// player has tried to proceed without being very stealthy, spawn in hunter-killer dudes to track 'em down
		thread ruins_fail();
	}
	else
	{
		//This way.  Now.
		self thread dialogue_queue( "castle_pri_thisway3" );
	}

	flag_set( "ruins_done" );
	level notify("ruins_done");
		
	/*	
	wait 4;
	
	//	Maybe the rain means everyone else is tucked up in bed?
	self dialogue_queue( "castle_pri_tuckedinbed" );
	
	//	We should be so lucky?
	self dialogue_queue( "castle_pri_solucky" );
*/
}


//detects if the player is engaging the patrols by grenade or gun fire
player_stealth_break()
{
	self waittill_any( "weapon_fired", "grenade_fire" );
		
	level notify( "player_shot" );
}

player_stealth_fail()
{
	//this function ends once courtyard is spawned, a more elaborate function takes over
	level endon( "ruins_break_stealth_stop" );
		
	flag_wait( "_stealth_spotted" );
	flag_set("ruins_price_free");
	wait 1;
	level.price thread dialogue_queue( "castle_pri_spotted" );

//	level.price.allowdeath = true;	// just in case
//	level.price stop_magic_bullet_shield();
	
//	level.price thread check_for_price_death();
//	level.price thread kill_price_if_taking_too_long();
}

check_for_price_death()
{
	quote = undefined;
	
	level.price waittill( "death", other );
	if ( isplayer( other ) )
	{
		quote = &"SCRIPT_MISSIONFAIL_KILLTEAM_BRITISH";
	}
	else
	{
		quote = &"CASTLE_YOUR_ACTIONS_GOT_PRICE";
	}
	
	wait(2);
	setDvar( "ui_deadquote", quote );
	missionFailedWrapper();
}

price_stealth_break_think( align )
{
	
	//courtyard was reached without a stealth break
	level endon( "ruins_done" );
	
	// Price can die once _stealth_spotted flag is set
	self endon( "death" );
	
	//player was spotted or started to shoot enemies
	level waittill_any( "_stealth_spotted", "player_shot", "ruins_alerted" );

	price_mad_line = [];
	//Next time, I let them kill you.	
	price_mad_line[0] = "castle_pri_nexttime";
	//No more mistakes.  Let's go.	
	price_mad_line[1] =  "castle_pri_mistakes";
	
//	self notify( "stop_animating" );
	
	// 	FIXME: need a new VO line here
//	level.price dialogue_queue("castle_pri_getuskilled");
	level.price dialogue_queue(level.ruins_spotted_vo[level.ruins_spotted]);
	level.ruins_spotted++;
	if (level.ruins_spotted > level.ruins_spotted_vo.size)
	{
		level.ruins_spotted = 0;
	}
	
	flag_set("ruins_alerted");
	level notify("ruins_alerted");
	//stop any current animation and give deadly combat values
	self.a.pose = "crouch";
	self anim_stopanimscripted();
	align notify( "stop_loop" );
	self.pacifist = false;
	flag_set("ruins_price_free");
	
	//only super accurate if alerted but not spotted
/*	
	if( !flag( "_stealth_spotted" ) )
	{
		level.price.baseaccuracy = 5000000;
	}
*/
	level.price.baseaccuracy = 5000000;
	stealth_flag = undefined;
	//help kill
	
//	while( get_ai_group_count( "ruins_patrol" ) > 0 )
	while (true)
	{
		a_enemies = get_ai_group_ai( "ruins_patrol" );
		a_enemies = array_combine(a_enemies, get_ai_group_ai("ruins_patrol2") );
		
		if (a_enemies.size <=0 )
		{
			break;
		}
		foreach( enemy in a_enemies )
		{
			if ( IsDefined(enemy.enemy) || !(enemy ent_flag("_stealth_normal" )) )
			{
				stealth_flag = enemy stealth_get_group_spotted_flag();
				enemy.dontattackme = undefined;
				enemy.threatbias = 5000;
				if( !isalive( level.price.enemy ) )
					level.price.favoriteenemy = enemy;
				enemy.health = 1;
			}
		}
		wait 0.5;		
	}
	
	level.price DelayThread(1.5, ::dialogue_queue, price_mad_line[level.ruins_screwups] );
	level.ruins_screwups++;
	
	// back to stealth
	if (!flag("ruins_failed"))
	{
		level.player ent_flag_set( "_stealth_enabled" );
		flag_set("_stealth_enabled");
		thread maps\_stealth_visibility_system::system_event_change( "hidden" );
		if (IsDefined(stealth_flag))
		{
			flag_clear(stealth_flag);
		}
		flag_clear("ruins_alerted");
		flag_clear("_stealth_spotted");
		self.pacifist = true;
		level.price.baseaccuracy = 1;
	
		//check if patrol 2 hasn't gone yet, if not, reset everything
		if ( get_ai_group_count( "ruins_patrol2" ) > 0 )
		{
	//		level.player thread player_stealth_break();
			self thread price_stealth_break_think(align);
		}
		else
		{
	/*	
		//once everyone is dead anim reach to the start of courtyard
		align = get_new_anim_node( "anim_align_dropdown" );
		align anim_reach_solo( self, "run_to_outlook" );	
	*/	
			flag_set("spawn_courtyard_activity");
			flag_set("continue_past_patrol");
			flag_set( "ruins_done" );
		}
	}
}

ruins_weather()
{
	set_rain_level( 5 );   // spray wanted it like this from the start
	
	set_cloud_lightning( 3, 6 );
/*	
 	set_rain_level( 1 );
 	
	flag_wait( "ruins_movement_1" );
	
	set_rain_level( 2 );
	
	flag_wait( "spawn_courtyard_activity" );
	
	set_rain_level( 3 );
	
	flag_wait( "ruins_movement_2" );
	
	set_rain_level( 4 );
*/
}	

// spawn function
ruins_flashlight_patroller_go()
{
	self thread ruins_flashlight_patroller();
}

ruins_patroller_go_nolight()
{
}

ruins_patroller_go()
{
	self thread flashlight_on( true );
}

// spawn function
ruins_patroller( str_start_patrol_notify, func_run_when_patrol_starts, goal_node, fight_flag )
{
//	self maps\castle_courtyard_stealth::stealth_reset();
	self endon( "stealth_enemy_endon_alert" );
	self endon( "death" );
	
	self.animname = self.script_noteworthy;
	
//	self stealth_set_group("ruins_guys");
	align = get_new_anim_node( "ruins_middle" );
	align anim_first_frame_solo( self, "ruins_patrol" );
	
	//level waittill( str_start_patrol_notify );
	flag_wait(str_start_patrol_notify);

/*	
	// HACK to get around crappy animations instead of pathing:  give these guys time to start their animation and get unstuck in geo before allowing them to have ai
	if (self.animname == "ruins_patroller1" || self.animname == "ruins_patroller2")
	{
		delayThread(4, ::ruins_setup_stealth_patrol_alerts, fight_flag);
	}
	else
	{
*/
		ruins_setup_stealth_patrol_alerts(fight_flag);
//	}

	if ( IsDefined( func_run_when_patrol_starts ) )
	{
		self [[ func_run_when_patrol_starts ]]();
	}
	
	align thread stealth_anim_single( self, "ruins_patrol" );

	// HACK: jump animation ahead 25% so you don't wait around for these guys
	if (self.animname == "ruins_patroller1" || self.animname == "ruins_patroller2")
	{
		waitframe();
		self SetAnimTime(level.scr_anim[self.animname]["ruins_patrol"], 0.25);
	}
	
	self waittillmatch("single anim", "end");
	
	if( self.animname == "ruins_patroller3" )
	{
		level notify( "cheap_light" );
		level notify ( "start_ruins_patrol_conv" );
	}

	self thread maps\_patrol::patrol( goal_node );
	
	flag_wait( "stealth_player_in_motorpool" );	
	self Delete();
}
ruins_setup_stealth_patrol_alerts(fight_flag)
{
	self thread ruins_grenade_throw_break_stealth(fight_flag);
	self thread stealth_enemy_endon_alert();
}

ruins_grenade_throw_break_stealth(fight_flag)
{
	self endon ("death");
	
	self waittill_any("flashbang", "explode", "grenade danger" );
	
	wait 1.5;
	
	if (IsAlive(self))
	{
		flag_set(fight_flag);
		flag_set("ruins_alerted");
		level notify("ruins_alerted");
//		flag_set( "_stealth_spotted" );
	
		self anim_stopanimscripted();
	}
}

do_second_patrol_group( price )
{
	flag_set("ruins_seconds_patrol_go");
}

ruins_patrol_lightning_flash( price )
{
	IPrintLnBold( "flash!" );
}

ruins_flashlight_patroller()
{
	self endon( "death" );
	
	flashlight_on( false );
	self thread maps\castle_courtyard_stealth::castle_spotlight_detect_player( "tag_flash", .98 );
	self thread ruins_flashlight_spot_you();
	
	//switch to cheap light to match either in combat or when you should move closer
	level waittill_any( "cheap_light" );
	flashlight_on( true );
}

ruins_flashlight_spot_you()
{
	self endon("death");
	
	level waittill_any( "_stealth_spotted", "ruins_alerted");
	self GetEnemyInfo(level.player);

	self waittill("death");
	level notify("cheap_light");
}

ruins_fail()
{
	flag_set("ruins_failed");
	level.price.baseaccuracy = 0.3;
	level.price disable_sprint();
	level.price disable_ai_color();
	
	price_fail_node = GetNode("price_fail_location", "targetname");
	level.price set_fixednode_true();
	level.price SetGoalNode(price_fail_node);
		
	sp_enemy = GetEnt( "ruins_fail", "targetname" );
	
	while( sp_enemy.count > 0 )
	{
		guy = sp_enemy spawn_ai();
		waitframe();
		if ( isDefined(guy) && IsAlive(level.price) )
		{
			guy GetEnemyInfo(level.player);
			guy GetEnemyInfo(level.price);
			guy SetGoalEntity(level.price);
		}
		wait 1;
	}
}

set_alert_if_player_jump_early()
{
	level endon("start_stealth_guard_patroll");
	
	trigger = getent("alert_trigger_for_overlook", "targetname");
	trigger waittill( "trigger" );

	flag_set("_stealth_spotted");
}

ai_array_killcount_flag_set( enemies , killcount , flag , timeout )
{
	waittill_dead_or_dying( enemies , killcount , timeout );
	flag_set( flag );
}

watch_first_patrol(guys)
{
	ai_array_killcount_flag_set(guys, guys.count, "first_patrol_dead");
}

puddle_splashes()
{
	while (!flag("stealth_player_in_motorpool"))
	{
		flag_wait("price_mud");
	    animscripts\utility::setFootstepEffect( "mud",		level._effect[ "castle_wet_footstep" ] );
	    animscripts\utility::setFootstepEffectSmall( "mud",	level._effect[ "castle_wet_footstep" ] );
	    
	    flag_waitopen("price_mud");
	    unSetFootstepEffect( "mud" );
	    unSetFootstepEffectSmall( "mud" );
	}
}

unSetFootstepEffect( name )
{
	assertEx( isdefined( name ), "Need to define the footstep surface type to unset." );
	if ( isdefined( anim.optionalStepEffects ) )
	{
		idx = array_find(anim.optionalStepEffects, name);
		if (IsDefined(idx))
		{
			anim.optionalStepEffects = array_remove_index(anim.optionalStepEffects, idx);
		}
	}
	level._effect[ "step_" + name ] = undefined;
//	level._effect = array_removeUndefined(level._effect);
}

unSetFootstepEffectSmall( name)
{
	assertEx( isdefined( name ), "Need to define the footstep surface type to unset." );
	if ( isdefined( anim.optionalStepEffectsSmall ) )
	{
		idx = array_find(anim.optionalStepEffectsSmall, name);
		if (IsDefined(idx))
		{
			anim.optionalStepEffectsSmall = array_remove_index(anim.optionalStepEffectsSmall, idx);
		}
	}
	level._effect[ "step_small_" + name ] = undefined;
//	level._effect = array_removeUndefined(level._effect);
}
