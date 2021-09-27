#include maps\_utility;
#include common_scripts\utility;
#include maps\_anim;
#include maps\_vehicle;
#include maps\payback_util;
#include maps\_audio;


init_compound_c_flags()
{
	flag_init( "flag_entered_compound" );
 	flag_init("compound_fire_rpg");
	flag_init("compound_soap_clear_right");
	flag_init("sidehall_guy_dead");
	flag_init("stair_guy_dead");
	flag_init("compound_soap_stairs_clear");
	flag_init("compound_stair_landing1");
	flag_init("compound_upstairs1");
	flag_init("compound_upstairs2");
	flag_init("compound_upstairs3");
	flag_init("compound_upstairs4");
	flag_init("compound_door_shooter");
	flag_init("price_in_position");
	flag_init("compound_soap_kick_door");
	flag_init("compound_int_see_door");
	flag_init("wilhelm_over");
}


compound_c_jumpto()
{
	texploder(2300);
	exploder(2000);
	exploder(2500);
	// AUDIO: jump/checkpoints
	aud_send_msg("s1_main_compound");
	thread sandstorm_fx(2);  // in payback_util
	thread init_kick_doors();
	thread compound_curtain_anims();
	
	//teleport player
	player_start = getstruct( "start_courtyard", "targetname" );
	level.player setOrigin( player_start.origin );
	level.player setPlayerAngles( player_start.angles );
	
	objective_state (obj( "obj_kruger" ), "current");
	
	maps\_compass::setupMiniMap("compass_map_payback_port","port_minimap_corner");
		
	//spawn allies
	level.price = spawn_ally("price");
	level.soap = spawn_ally("soap");
	level.hannibal = spawn_ally("hannibal");
	level.barracus = spawn_ally("barracus");
	level.murdock = spawn_ally("murdock");

	level.player thread maps\payback_1_script_b::no_prone_water_trigger();
		
	//setup chopper
	maps\payback_1_script_d::chopper_main();
//	level.chopper thread vehicle_paths( GetStruct( "chopper_land_setup_am", "targetname" ) );
	flag_clear("chopper_give_player_control");	

	level.price thread dialogue_queue( "payback_pri_bravoteamsecure_r" ); 			// "Bravo Team, secure the perimeter.  Yuri, Soap - come on. Let's find Kruger."
	
	main();	
}


main()
{	
	thread compound_downstairs();
	thread compound_upstairs_hall();
	thread compound_enemy_battlechatter();

	kruger_breach_use_trig = GetEnt( "trigger_use_breach", "classname" );
	kruger_breach_use_trig trigger_off();

	flag_wait("compound_upstairs2");
	level.hannibal thread bravo_bullet_shield("hannibal_spawned");
	level.barracus thread bravo_bullet_shield("barracus_spawned");
	level.murdock thread bravo_bullet_shield("murdock_spawned");
	
	/*
	thread do_compound_end();
	thread do_vo();
	thread do_compound_wave2b();
	thread do_compound_wave3_left();
//	thread do_rpg_spawn();
	thread do_balc_advance();
	*/
}

compound_fire_rpg()
{
//	array_spawn_targetname_allow_fail("compound_int_rpg_guys");

	flag_wait("compound_fire_rpg");
	/*
	wait 0.75;
	aud_send_msg("s1_main_compound");

	
	//rpg shot	
	rpg_start = getStruct( "rpg_start", "targetname" );
	rpg_target = getStruct( "rpg_target", "targetname" );
	target_ent = Spawn( "script_origin", rpg_target.origin );
	missileAttractor = Missile_CreateAttractorEnt( target_ent, 200000, 5000 );
	wait 0.5; // was 1
	magicBullet( "rpg", rpg_start.origin, rpg_target.origin );

	// RPG!
	level.player thread radio_dialogue( "payback_brvl_rpg" );

	//soap drops
	animname = level.soap.animname;
	level.soap.animname = "generic";
	level.soap thread anim_generic(level.soap, "london_kickout_window_kick_reaction");
	
    while( level.soap getanimtime( getgenericanim( "london_kickout_window_kick_reaction" ) ) < 0.65 )
		wait( 0.05 );
    level.soap stopanimscripted();
    
	level.soap.animname = animname;
	
	wait 2;
	Missile_DeleteAttractor(missileAttractor);
	wait 1;
	*/
	autosave_by_name("enter_compound");
}



compound_downstairs()
{
	thread compound_fire_rpg();
	
	// wait for player to approach front door
	flag_wait( "compound_fire_rpg" );

	SetSavedDvar( "objectiveFadeTooFar", 5 );
	Objective_OnEntity( obj( "obj_kruger" ), level.price , (0,0,50) );
	Objective_SetPointerTextOverride( obj( "obj_kruger" ) , "" );
	
	//guys = array_spawn_targetname_allow_fail("compound_wave1");

	level.soap.notarget = true;
	level.soap.ignoreme = true;
	
	level.price.notarget = true;
	level.price.ignoreme = true;

	soap_path = GetNode("compound_path_soap1", "targetname");
	price_path = GetNode("price_compound_node03", "targetname");

	player_speed_percent(85);  // slow player down during qcb stuff
	
	level.price enable_interior_compound_behavior();
	level.soap enable_interior_compound_behavior();
	
	level.price thread Follow_Path(price_path);
	wait 1;
	level.soap thread Follow_Path(soap_path);

	thread price_vo_lines();
		
	thread soap_vo_lines();
	price_vo_trigger = GetEnt("price_clear_left_trigger","targetname");
	price_hit_trigger = false;
	while(!price_hit_trigger)
	{
		price_vo_trigger waittill( "trigger", dude );
		if ( dude == level.price )
		{
			price_hit_trigger = true;	
		}
		wait(0.05);
	}
	level.price thread dialogue_queue( "payback_pri_clearleft1_r" ); 				// "Clear left."

	thread first_floor_clear_vo();

	flag_wait("compound_stair_landing2");
	level.soap.notarget = false;
	level.soap.ignoreme = false;
	level.price.notarget = false;
	level.price.ignoreme = false;
}

compound_curtain_anims()
{
    compound_curtains1 = GetEnt( "compound_curtains1", "targetname" );
    compound_curtains2 = GetEnt( "compound_curtains2", "targetname" );   
    compound_curtains_node = GetEnt( "first_floor_curtains", "targetname" );
    
    compound_curtains1.animname = "compound_curtains";
	compound_curtains1 setanimtree();
    wait( RandomFloatRange( 0.0 , 1.5 ));
    compound_curtains_node thread anim_loop_solo( compound_curtains1, "lower_curtains_01", "stop_looping_curtain_anims" );
    
    compound_curtains2.animname = "compound_curtains";
	compound_curtains2 setanimtree();
    wait( RandomFloatRange( 0.0 , 1.5 ));
    compound_curtains_node thread anim_loop_solo( compound_curtains2, "lower_curtains_02", "stop_looping_curtain_anims" );
    
    flag_wait("start_construction_anims");
    compound_curtains1 notify("stop_looping_curtain_anims");
    compound_curtains1 delete();
    
    compound_curtains2 notify("stop_looping_curtain_anims");
    compound_curtains2 delete();
}

price_vo_lines()
{
	level.price  dialogue_queue( "payback_pri_baseplatetarget" ); // Baseplate, we’re entering the target building.
	level.player radio_dialogue( "payback_eol_prepforexfil" );
}

soap_vo_lines()
{
	flag_wait("compound_soap_clear_right");
	level.soap thread dialogue_queue( "payback_mct_clearright1_r" ); // "Clear right."
	
	/* SOAP KILLING GUY ON STAIRS REMOVED
	
	// because script_flag_set doesn't work on color nodes, we have to script soap to go up the steps
	flag_wait("compound_int_soap_go_stairs");
	node = GetNode("compound_int_stair_clear", "targetname");
	level.soap Follow_Path(node);
	
	old_accuracy = level.soap.baseaccuracy;
	level.soap.baseaccuracy = 1000;

	flag_wait("compound_soap_stairs_clear");
	if ( !flag("compound_stair_landing1") )
	{
		flag_wait("stair_guy_dead");
		level.soap dialogue_queue( "payback_mct_stairwayclear1_r" ); 				// "Stair way clear."
	}
	
	level.soap.baseaccuracy = old_accuracy;
*/
}

first_floor_clear_vo()
{
	level.price waittill("reached_path_end");	
	
	level.price  dialogue_queue( "payback_pri_firstfloorclear" ); 	
	
	level.player radio_dialogue("payback_eol_proceedtosecond");
}

compound_upstairs_hall()
{
	flag_wait("compound_stair_landing1");
	
	thread compound_kill_rooftop_mg_guys();
	
	if ( !flag("compound_stair_landing2") )
	{
		level.price thread dialogue_queue( "payback_pri_wahtthecorners_r" ); 				// "Watch the corners." 
	}
	
/*		
	// turn off balcony turret to the player - it's distracting
	turret = GetEnt("compound_turret1", "targetname");
	if (IsDefined(turret))
	{
		turret MakeTurretInoperable();
		
	}
*/

	flag_wait("compound_stair_landing2");
	
	thread chopper_flyby();
	thread close_kick_doors();
	
	objective_state( obj ( "follow1" ) , "invisible" );
	

//	price_path = GetNode("price_go_up_stairs", "targetname");
//	level.price thread Follow_Path(price_path);
	/*
	if (!flag("compound_soap_stairs_clear"))
	{
		level.soap thread sprint_to_goal();
	}
	*/
//	level.price thread sprint_to_goal();

	thread balcony_guys();
/*	
	enemies = array_spawn_targetname( "compound_wave2", "targetname" );	// start/stay in hall
	thread ai_array_killcount_flag_set(enemies, enemies.size, "compound_upstairs1");	

	flag_wait("compound_upstairs1");  // price and soap run forward when these guys are dead

	autosave_by_name( "compound_floor2" );
*/	
	flag_wait("compound_upstairs1");
	
	level.price thread dialogue_queue("payback_pri_contactfront");
	
	player_speed_percent(100);
	level.price thread disable_interior_compound_behavior(0);	
	level.soap thread disable_interior_compound_behavior(0);

//	level.price thread dialogue_queue( "payback_pri_allclear1_r" ); 				// "Room clear."
//	wait 1;	
}

breach_lead_up_vo()
{
	level endon( "A door in breach group 1 has been activated." );
	
	level.price dialogue_queue( "payback_pri_bravooneposition" );     // "Bravo-1, get in position."

	wait .75;
	
	radio_dialogue( "payback_brvl_flankingtoback" );  // "Flanking to the back now. Multiple targets entering 2nd floor room."
	
	wait .5;
	
	// price plays a generic animation which causes an error if this dialog line tries to play while it's going.
	while (level.price.animname == "generic")
	{
		wait 0.15;
	}
	
	level.price dialogue_queue( "payback_pri_office" );  // "Kruger's office is just ahead."
}

balcony_guys()
{
	balc_guys = array_spawn_targetname( "compound_wave2b", "targetname" );	// balcony guys
	array_thread(balc_guys, ::run_and_delete);

/*
	flag_wait("compound_int_balcony");
	
	balc_guys = array_combine(balc_guys, array_spawn_targetname( "compound_int_balcony", "targetname" ));	
	balc_guys = array_removedead_or_dying(balc_guys);
	thread ai_array_killcount_flag_set(balc_guys, 2, "compound_upstairs2");  // after 2 guys are dead, do this
*/	
	flag_wait("compound_upstairs2");
	autosave_by_name( "compound_floor2" );
	
	thread breach_lead_up_vo();
		
	thread soap_kick_door();
	thread price_kick_door();
	thread compound_door_shooter();
	
	// send price and soap to next goal and spawn in a new wave of baddies
	//activate_trigger_with_targetname("compound_int_balcony_wait_pos2");
	
	
	enemies = array_spawn_targetname( "compound_wave3_left", "targetname" );	// start/stay in hall
	spawner = getEnt( "compound_anim_overbalcony_ai" , "targetname" );
	
	// the guy soap throws over the balcony (handled in a different thread)
	level.wilhelm = spawner spawn_ai();
	if ( IsDefined(level.wilhelm) )
	{
		level.wilhelm.notarget = true;
		level.wilhelm.ignoreme = true;
		level.wilhelm.ignoreall = true;
		level.wilhelm thread wake_up_when_player_close(200);
		enemies = array_add(enemies, level.wilhelm);
	}
	
	thread ai_array_killcount_flag_set(enemies, (enemies.size-3), "compound_upstairs3");
	thread ai_array_killcount_flag_set(enemies, enemies.size, "compound_upstairs4");
	thread balcony_room_dynamic_accuracy(enemies);
	
	soap_accuracy = level.soap.baseaccuracy;
	price_accuracy = level.soap.baseaccuracy;
	level.soap.baseaccuracy = level.soap.baseaccuracy * 2;
	level.price.baseaccuracy = level.price.baseaccuracy * 2;
	
	flag_wait("compound_upstairs3");
	level.soap.baseaccuracy = 1000;
	level.price.baseaccuracy = 1000;
	
	// make remaining baddies run out into the open
	activate_trigger_with_targetname("compound_int_last_room");

	
	flag_wait("compound_upstairs4");
	flag_wait("compound_soap_kick_door");  // safety check incase the player manages to kill everyone before soap even gets to the door
	//done fighting
	level.soap.baseaccuracy = soap_accuracy;
	level.price.baseaccuracy = price_accuracy;
	thread maps\payback_1_script_e::setup_breach();
}

wake_up_when_player_close(range)
{
	level endon("death");
	self endon("death");
	
	self waittill_entity_in_range(level.player, range);
	self.ignoreall = false;
	wait 10;
	if (IsDefined(self) && IsAlive(self))
	{
		self GetEnemyInfo(level.player);
		self.ignoreme = false;
		self.notarget = false;
		self set_fixednode_false();
		self set_goal_radius(500);
		self SetGoalEntity(level.player);
	}
}

balcony_room_dynamic_accuracy(guys)
{
	// ramps up accuracy of bad guys as more allies become available to fight, so they don't completely own you if you run in
	control_enemy_accuracy(guys, 0.75);
	level waittill("price_in_fight");
	if (!flag("compound_upstairs4"))
	{
		control_enemy_accuracy(guys, 1.0);
		flag_wait("wilhelm_over");
		if (!flag("compound_upstairs4"))
		{
			control_enemy_accuracy(guys, 1.5);
		}
	}
}

control_enemy_accuracy(guys, accuracy)
{
	foreach (guy in guys)
	{
		if (IsDefined(guy) && IsAlive(guy))
		{
			guy.baseaccuracy = accuracy;
		}
	}
}

run_and_delete()
{
	self endon("death");
	
	self waittill("goal");
	wait 1;

	//I can't get these to work: "if(player_can_see_ai(self))" or "if(level.player can_see_origin(self.origin, true))
	if (flag("compound_upstairs2"))
	{
		// player managed to see them get to the end of the path.  start a fight.
		self.ignoreall = false;
		self.ignoreme = false;
		wait 1;
		self GetEnemyInfo(level.player);
	}
	else
	{
		self Delete();
	}
}



compound_door_shooter()
{
	flag_wait("compound_door_shooter");

	if (!flag("compound_soap_kick_door"))
	{
		guys = GetEntArray("compound_door_shooter", "script_noteworthy");
		foreach (guy in guys)
		{
			if (IsAlive(guy))
			{
				targ = GetEnt("compound_door_targ", "targetname");
				guy SetEntityTarget(targ);
				wait 2;
				guy ClearEntityTarget();
			}
		}
	}
}

chopper_flyby()
{
	flag_wait("compound_stair_landing2");

	wait(3);
	
	/*
	guys = GetEntArray("heli_gunner_guy", "script_noteworthy");
	mg_guy = undefined;
	foreach (guy in guys)
	{
		if (isalive(guy))
		{
			
			guy.pathenemyfightdist = 10000;
			guy setengagementmaxdist(10000,10000);
//			guy setEngagementMinDist( 1300, 1000 );
			guy SetEntityTarget(level.chopper);
			mg_guy = guy;
		}
	}
	
	mg = GetEnt("compound_mg", "script_noteworthy");
//	mg SetTurretIgnoreGoals(true);
	mg SetTargetEntity(level.chopper);
//	mg SetTopArc(45);
//	mg SetRightArc(90);
//	mg SetLeftArc(90);
//	mg StartFiring();
*/
//	startStruct = GetStruct( "chopper_balcony_flyby_struct", "targetname" );

	chopper_path = getvehiclenode( "chopper_balcony_flyby_structB", "targetname" );
	
	level.chopper notify( "chopper_new_path" );
	level.chopper notify( "end_strafing_run" );
	level.chopper vehicle_teleport( chopper_path.origin , chopper_path.angles );
	level.chopper ClearLookAtEnt();
	level.chopper SetMaxPitchRoll(80,80);
	
//	level.chopper AttachPath( chopper_path );

	level.chopper StartPath(chopper_path);
	level.chopper Vehicle_SetSpeedImmediate( 50, 20, 20 );
	aud_send_msg("compound_chopperby");
	
	level.player radio_dialogue("payback_nik_2ndflrbalcony");
	level.player radio_dialogue("payback_eol_2ndfloor");
	
	level.chopper waittill("reached_end_node");
	
	bye_node = getvehiclenode( "post_compound_heli_flyoff", "targetname" );
	level.chopper SetVehGoalPos(bye_node.origin, 1);
	
	wait(15);
	level.chopper delete();
/*		
	if (IsAlive(mg_guy))
	{
		mg_guy SetGoalPos(level.player.origin);
	}
*/	
}
/*
sprint_to_goal()
{
	wait 0.1;
	self ignore_everything();
	self disable_cqbwalk();
	self enable_sprint();
	self waittill("goal");
	self clear_ignore_everything();
	self disable_sprint();
	self enable_cqbwalk();
}
*/

enable_interior_compound_behavior()
{
	self enable_cqbwalk();
	self disable_surprise();
	
	self.ignoreSuppression = true;
	//self.ignoreme = true;
	self.IgnoreRandomBulletDamage = true;
	self.ignoreExplosionEvents = true;
	self.disableBulletWhizbyReaction = true;	
	self.dontavoidplayer = true;
//	self.baseaccuracy = 1;
	
	//self.suppressionwait = 0;
	//self.pathrandompercent = 0;
	//self.grenadeawareness = 0;
	//self.takedamage = false;
	//self.attackeraccuracy = 0;	
	
	//remove flashbangs
	self.grenadeWeapon = "flash_grenade";
	self.grenadeAmmo = 0;
}

disable_interior_compound_behavior( baseacc )
{
	self disable_cqbwalk();
	self enable_surprise();
	
	self.ignoreSuppression = false;
	//self.ignoreme = false;
	self.IgnoreRandomBulletDamage = false;
	self.ignoreExplosionEvents = false;
	self.disableBulletWhizbyReaction = false;	
	self.dontavoidplayer = false;

//	self.baseaccuracy = baseacc;
	//self.suppressionwait = 0;
	//self.pathrandompercent = 0;
	//self.grenadeawareness = 0;
	//self.takedamage = false;
	//self.attackeraccuracy = 0;	
}

compound_enemy_battlechatter()
{
	level.player endon( "death" );
	
	while ( !flag( "compound_int_see_door" ))
	{
		enemies = GetAIArray( "axis" );
		if ( enemies.size > 0 )
		{
			index = RandomIntRange( 0 , enemies.size );
			enemy = enemies[index];
			if ( IsAlive(enemy))
			{
				enemy custom_battlechatter( "order_move_combat" );
			}
		}
		else
		{
			break;
		}
		wait( RandomFloatRange( 1.5 , 5.0 ));
	}
}

compound_kill_rooftop_mg_guys()
{

	dead_men = GetEntArray("rooftop_mg", "script_noteworthy");
	
	foreach(mens in dead_men)
	{
		if (IsAlive(mens))
		{	
			mens Kill();
		}
	}
}

init_kick_doors()
{
	door1 = GetEnt("compound_price_door_r", "targetname");
	door2 = GetEnt("compound_price_door_l", "targetname");
 
	door1 ConnectPaths();
	door2 ConnectPaths();
	door1 RotateYaw(-120,0.1);
	door2 RotateYaw(120,0.1);
}

close_kick_doors()
{
	door1 = GetEnt("compound_price_door_r", "targetname");
	door2 = GetEnt("compound_price_door_l", "targetname");
 
	door1 RotateYaw(120,0.1);
	door2 RotateYaw(-120,0.1);
	wait 0.2;
	door1 DisConnectPaths();
	door2 DisConnectPaths();
	
}

soap_kick_door()
{
	level.soap PushPlayer( true );
	animname = level.soap.animname;
	level.soap disable_ai_color();
	level.soap.animname = "generic" ;
//	stack_node = GetNode("compound_soap_stack_up", "targetname");
//	level.soap SetGoalNode(stack_node);
//	level.soap waittill("goal");
		
//	flag_wait("price_in_position");

	goalnode = GetNode( "soap_door_kick_node" , "targetname" );
	goalnode anim_reach_and_approach_node_solo( level.soap, "doorkick_2_stand");
	flag_set("compound_soap_kick_door");
	
	thread doors_open_from_kick("compound_soap_door_l", "compound_soap_door_r");
 	goalnode anim_single_solo_run( level.soap, "doorkick_2_stand" );
	
	level.soap PushPlayer( false );
	level.soap.animname = animname;
	level.soap enable_ai_color();
	level.soap.ignoresuppression = true;
	
	soap_over_balcony_sequence();
//	activate_trigger_with_targetname("compound_enter_last_combat");
}


price_kick_door()
{
	level.price PushPlayer( true );
	animname = level.price.animname;
	level.price disable_ai_color();
	goalnode = GetNode( "price_door_kick_node" , "targetname" );
	goalnode anim_reach_and_approach_node_solo( level.price, "doorkick_2_stand");
	flag_set("price_in_position");
// soap no longer waits, this stuff isn't needed
//	level.price dialogue_queue("payback_pri_doit");
//	wait 0.25;

	level.price.animname = "generic" ;
	thread doors_open_from_kick("compound_price_door_l", "compound_price_door_r");
	goalnode anim_single_solo_run( level.price, "doorkick_2_stand" );
	
	level.price PushPlayer( false );
	level.price.animname = animname;
	level.price enable_ai_color();
	level notify("price_in_fight");
}

doors_open_from_kick(left_door, right_door)
{
	wait 0.4;
	
	doorl = GetEnt( left_door, "targetname" );
	doorl ConnectPaths();
	doorr = GetEnt( right_door, "targetname" );
	doorr ConnectPaths();
	doorr RotateYaw( (-80 + randomIntRange(-10,10)), 0.15 );
	doorl RotateYaw( (80 + randomIntRange(-10,10)), 0.15 );	
	wait(RandomFloatRange(0.05, 0.1));
	doorr playSound("pybk_door_kick");
	wait(RandomFloatRange(0.05, 0.15));
	doorl playSound("pybk_door_kick");
}

soap_over_balcony_sequence()
{
	ref = getStruct( "compound_anim_overbalcony" , "targetname" );
	
	if (IsDefined(level.wilhelm) && IsAlive(level.wilhelm)  && level.wilhelm.ignoreall == true)
	{
		level.wilhelm.animname = "generic";
		ref thread anim_reach_solo( level.wilhelm , "payback_comp_balcony_kick_enemy" );
		ref anim_reach_solo( level.soap , "payback_comp_balcony_kick_soap" );
		if (IsDefined(level.wilhelm) && IsAlive(level.wilhelm))
		{
			ref thread anim_single_solo( level.soap , "payback_comp_balcony_kick_soap" );
			ref thread anim_single_solo( level.wilhelm , "payback_comp_balcony_kick_enemy" );
			aud_send_msg("soap_over_balcony", level.wilhelm);
			level.wilhelm.a.nodeath = true;
			level.wilhelm Kill();
		}
	}
	level.soap enable_ai_color();
	level.soap.ignoresuppression = false;
	flag_set("wilhelm_over");
}
