#using scripts\cp\_load;
#using scripts\cp\_util;
#using scripts\cp\_spawn_manager;
#using scripts\cp\_objectives;
#using scripts\cp\_debug;
#using scripts\cp\_ai_last_stand;
#using scripts\cp\_skipto;
#using scripts\cp\_dialog;

#using scripts\cp\sidemissions\_sm_ui;
#using scripts\codescripts\struct;

#using scripts\shared\math_shared;
#using scripts\shared\array_shared;
#using scripts\shared\util_shared;
#using scripts\shared\turret_shared;
#using scripts\shared\trigger_shared;
#using scripts\shared\scene_shared;
#using scripts\shared\ai_shared;
#using scripts\shared\ai\systems\ai_interface;
#using scripts\shared\ai\systems\debug;
#using scripts\shared\flag_shared;
#using scripts\shared\spawner_shared;
#using scripts\shared\animation_shared;
#using scripts\shared\spawner_shared;
#using scripts\shared\vehicle_shared;

#using scripts\cp\cp_mi_cairo_aquifer;
#using scripts\cp\cp_mi_cairo_aquifer_objectives;	
    	   	                                                                                                                         	                                                                                                                                                                                                                                                                                                                                                                    	        	     	             	    	   	                           	                               	                                	                                                              	                                                                                                              	                            	                                     	                                       	                                                               	   	                  	       	                                                    	                   	                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                       	                                                                                        	           	                        	                                            	                                             	                                                   	                                                             	                                                         	                                                                    	                                                                                                                                                                                                    	                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                     	                                                              	                                                          	                                   	                                   	                                                    	                                       

#using scripts\cp\cp_mi_cairo_aquifer_utility;

function start_boss()
{
	flag::wait_till("inroom");
	
	thread boss_temp_intro_vo();
	struct = GetEnt("hyperion_death_origin", "targetname");
	struct scene::play("cin_aqu_04_30_hyperion_1st_intro_main", level.hendricks);
	
	thread init_ally_sniper_route("hendricks");
	thread init_sniper_boss();

	// thread monitor_players_on_floor();
}

function defend_obj_hack(ent)
{
	ent endon("death");
	
	while (  !(level flag::get("end_battle")) )
	{
		offset = (0,0,60);
		icon_type = "defend";
		
		if ( ( isdefined( ent._laststand ) && ent._laststand ) )
		{
			offset = (0,0,30);
			icon_type = "return";
		}
		
		level.defend_obj = objectives::create_temp_icon( icon_type, "ally_defend", ent.origin + offset );
		
		wait 0.05;
	}
	
	level.defend_obj objectives::destroy_temp_icon();

}

function init_ally_sniper_route(name)
{
	guy = level.hendricks;


	//we're going to reuse this when we exit out of the boss area.
	level.hendrix_follow_obj = "cp_level_aquifer_followme";
	thread objectives::set(level.hendrix_follow_obj,level.hendricks);

	objectives::hide_for_target(level.hendrix_follow_obj,level.hendricks);
	
	level.ally_target = guy;
	level.hendricks_moving = false;
	guy.sniper_hits = 0;
	
	thread defend_obj_hack(level.ally_target);
	
	guy util::magic_bullet_shield();
	
/* old stuff for when hendricks could be downed	
	guy._laststand = false;
	guy.overrideActorDamage = &callback_hendricks_damage;
	guy thread rescue_nags();
*/	
	ai::CreateInterfaceForEntity( guy );
	guy ai::set_behavior_attribute( "cqb", true );

	guy endon("death");
	
	cover_me_vo = [];
	cover_me_vo[0] = "hend_cover_me_0";
	cover_me_vo[1] = "hend_i_m_moving_0";	
	cover_me_vo[2] = "hend_gimme_some_cover_fir_1";	
	cover_me_vo[3] = "hend_watch_my_back_0";	
	cover_me_vo[4] = "hend_keep_that_sniper_off_0";	
	cover_me_vo[5] = "hend_i_m_on_the_move_0";	
	cover_me_vo[6] = "hend_pushing_ahead_0";	
/*
	cover_me_vo[0] = "Hendricks: Cover me!";
	cover_me_vo[1] = "Hendricks: I'm moving!";	
	cover_me_vo[2] = "Hendricks: Gimme some cover fire!";	
	cover_me_vo[3] = "Hendricks: Watch my back!";	
	cover_me_vo[4] = "Hendricks: Keep that sniper off me!";	
	cover_me_vo[5] = "Hendricks: I'm on the move.";	
*/
	cover_line = 0;

	incoming_vo = [];
	incoming_vo[0] ="hend_we_ve_got_company_0";
	incoming_vo[1] ="hend_tangoes_on_the_floor_0";
	incoming_vo[2] ="hend_more_enemies_inbound_0";
	incoming_vo[3] ="hend_heads_up_more_tango_0";
	incoming_vo[4] ="hend_watch_those_doors_0";
/*
	incoming_vo[0] ="Hendricks: We've got company.";
	incoming_vo[1] ="Hendricks: Tangoes on the floor!";
	incoming_vo[2] ="Hendricks: More enemies inbound.";
	incoming_vo[3] ="Hendricks: Heads up. More tangoes.";
	incoming_vo[4] ="Hendricks: Watch those doors!";
*/
	incoming_line = 0;
	
	all_clear_vo = [];
	all_clear_vo[0] = "hend_all_clear_0";
	all_clear_vo[1] = "hend_that_s_all_of_them_0";
	all_clear_vo[2] = "hend_clear_0";
	all_clear_vo[3] = "hend_all_tangos_down_0";
/*
	all_clear_vo[0] = "Hendricks: All clear.";
	all_clear_vo[1] = "Hendricks: That's all of them.";
	all_clear_vo[2] = "Hendricks: Clear.";
	all_clear_vo[3] = "Hendricks: Boola-boola!";
*/	clear_line = 0;
	
	
/*
	play_all_vo_in_array(cover_me_vo);
	play_all_vo_in_array(incoming_vo);
	play_all_vo_in_array(all_clear_vo);
*/	


	node = GetNode("hendricks_go", "targetname");
	
//	guy SetGoal( node );
	level.hendricks_moving = true;
	guy thread spawner::go_to_node(node, "node");


	level.ally_target dialog::say("hend_we_need_to_interface_0");
	level.ally_target dialog::say("hend_stay_up_here_and_pro_0");

	
	spawner::add_global_spawn_function("axis", &sniper_minion_setup);
	
	spawn_manager::enable("boss_intro_wave");

	wait 2;
	
//	incoming_line = play_vo_from_array(incoming_vo, incoming_line);
	
//	wait 2;
	

//	boss_temp_intro();
	
//	level notify("start_boss_sniping");

	encounters = [];
	encounters[0] = array_create("wave_a", "wave_a_done");
	encounters[1] = array_create("wave_b", "wave_b_done");
	encounters[2] = array_create("wave_c", "wave_c_done");
	
	encounter_count = 0;

	wait 2;

/*	
	guys = spawn_manager::get_ai( "boss_intro_wave" );
	vol = GetEnt( "mid_vol", "targetname" );
	foreach (guy in guys)
	{
		guy SetGoalVolume( vol );
	}

	spawn_manager::wait_till_cleared("boss_intro_wave");
*/

	// force hendricks down early
	util::delay(3, undefined, &trigger::use, "wave_a_done", "targetname");

	while (	encounter_count < encounters.size )
	{
//		level flag::wait_till("ally_in_cover");
		level.hendricks_moving = false;
		
		level flag::clear("minions_cleared");
		
		// spawn a wave of grunts
		spawn_manager::enable(encounters[encounter_count][0]);
//		incoming_line = play_vo_from_array(incoming_vo, incoming_line);
/*		
		enemies = GetAIArray("seeker", "script_notworthy");
		enemies2 = GetAIArray("middle_men", "script_noteworthy");
		enemies = arraycombine(enemies, enemies2, true, false);
*/

		spawn_manager::wait_till_complete(encounters[encounter_count][0]);
		enemies = spawn_manager::get_ai(encounters[encounter_count][0]);
		spawn_manager::wait_till_ai_remaining(encounters[encounter_count][0], int(enemies.size / 2) );
//		spawn_manager::wait_till_cleared(encounters[encounter_count][0]);
		
		clear_line = level.ally_target play_vo_from_array(all_clear_vo, clear_line);

		level flag::set("minions_cleared");

		post_encounter = encounters[encounter_count][1];
		
		// get hendricks moving again
		trig = GetEnt(post_encounter, "targetname");
		
		if ( IsDefined(trig) )
		{
			level flag::clear("ally_in_cover");

			trigger::use(post_encounter, "targetname", guy);
			level.hendricks_moving = true;
		}
		
		encounter_count++;
//		cover_line = play_vo_from_array(cover_me_vo, cover_line);

	}
	
	end_battle();
}

function play_all_vo_in_array(arr)
{
	for (i=0; i < arr.size; i++)
	{
		level.ally_target play_vo_from_array(arr, i);
	}
}

function play_vo_from_array(array, num)
{
	self dialog::say(array[num]);
	
//	sm_ui::temp_vo(array[num]);
	num++;
	if (num >= array.size)
		num = 0;
	
	return num;
}

function init_sniper_boss()
{
	level.turret = GetEnt("veh_turret", "targetname");
	level.turret setmaxhealth(9999);
	level.turret vehicle::god_on();
	
	level.sniper_boss = GetEnt("hyperion", "targetname", true);
	level.sniper_boss ai::set_ignoreall(true);
	ai::CreateInterfaceForEntity( level.sniper_boss );
	level.sniper_boss ai::set_behavior_attribute( "coverIdleOnly", true );
	
//	level waittill("start_boss_sniping");
	
	level.sniper_origins = GetEntArray("sniper_origin", "targetname");
//	level.sniper_origins = GetNodeArray("sniper_node", "targetname");
	level.sniper_loc = undefined;
	level.sniper_target = level.ally_target;
	
	thread monitor_players_shooting();

	interrupted = true;	
	shot_count = 0;
	
	shots_between_relocate = 3;

	// main sniper loop
	while ( !(level flag::get("end_battle")) )
	{
		if ( interrupted || shot_count >= shots_between_relocate )
		{
			// only move the sniper origin every 3 shots or if the player has shot at him
			shot_count = 0;
			level.sniper_boss choose_sniper_location();
		}
		
		cur_target = level.sniper_target;
		
		if ( !level.hendricks_moving || level.ally_target ai_laststand::ai_is_in_laststand() )
		{
			// choose best player to target
			cur_target = choose_best_player_target(level.sniper_loc.origin);
			
			if ( !IsDefined(cur_target) )
			{
				// choose any random AI person to fire
				targets = get_enemy_sniper_targets();
				
				if (! level.sniper_target ai_laststand::ai_is_in_laststand() )
				{
					targets[targets.size] = level.sniper_target;
				}
				
				if ( targets.size > 0 )
				{
					
					target_num = RandomIntRange(0, targets.size);
					
					cur_target = targets[target_num];
					while (cur_target == level.sniper_boss && targets.size > 1)
					{
						target_num++;
						
						if (target_num > targets.size)
							target_num = 0;
						
						cur_target = targets[target_num];
					}
				}
			}
		}

		interrupted = false;
		
		if (IsDefined(cur_target) && cur_target != level.sniper_boss)
		{
			interrupted = !(level.sniper_boss target_and_shoot(cur_target, 3));
			shot_count++;
		}
		
		if ( interrupted || shot_count >= shots_between_relocate )
		{
			wait 3;
		}
		
		wait 3;  // minimum wait between shots
		
		if ( !level.hendricks_moving )
		{
			// wait longer between shots when combat is happening
			wait ( randomfloatrange(1,3) );
		}
	}
}

function get_enemy_sniper_targets()
{
	targets = GetAITeamArray("axis");
	new_targets = [];
	
	foreach ( target in targets )
	{
		if ( IsAI(target) && !IsVehicle(target) )
		{
			new_targets[new_targets.size] = target;
		}
	}
	
	return new_targets;
}

function choose_best_player_target(origin)
{
	targets = util::get_all_alive_players_s();
	targets = targets.a;
	
	see_targets = [];
	
	// make sure they're visible
	foreach (player in targets)
	{
		if ( SightTracePassed( origin, player GetTagOrigin( "tag_eye" ), true, level.turret) )
		{
			see_targets[see_targets.size] = player;
		}
	}
	
	if ( see_targets.size > 0 )
	{
		target_num = RandomIntRange(0, see_targets.size);
	
		return see_targets[target_num];
	}
	
	return undefined;
}

function choose_sniper_location()
{
	loc = RandomInt( level.sniper_origins.size );
	loc_ent = level.sniper_origins[loc];
	
	if ( !IsDefined(level.sniper_loc) || loc_ent == level.sniper_loc )
	{
		loc = loc + 1;
		
		if ( loc >= level.sniper_origins.size )
			loc = 0;
	}
		
	set_up_sniper_location( loc );
}
	
function set_up_sniper_location(index)
{
	level notify("sniper_moved");
	level.sniper_target = level.ally_target;
	level.sniper_override_target = undefined;
	
	if ( index >= 0 && index < level.sniper_origins.size )
	{
		level.sniper_loc = level.sniper_origins[index];
		level.sniper_hit_trigger = GetEnt( level.sniper_loc.target, "targetname");

		level.turret.origin = level.sniper_loc.origin - (0,0,32);
		
//		self teleport(level.sniper_loc.origin, level.sniper_loc.angles);
//		self SetGoal( level.sniper_loc, true);
		
		if ( !IsDefined(level.sniper_hit_trigger) )
		{
			AssertMsg("All sniper_origin's need to target a trigger_damage");
		}
	}
}

function target_and_shoot(target, duration, offset)
{
	// returns true if shot fired successfully, false if interrupted
	
	if ( !IsDefined(offset) )
	{
		offset = (0,0,60);
	}
	
//	level.turret turret::set_target(target);
//	level.turret turret::shoot_at_target(target, 1, undefined, 0, true);
	
	level.sniper_loc thread fake_laser_target(target, duration, offset);
	thread sniper_suppression_monitor();

	thread sniper_timer(duration);

	note = "";
	
	if ( level.hendricks_moving )
	{
		note = level util::waittill_any_return("sniper_interrupted", "retarget_sniper", "sniper_fire_timeout");
	}
	else
	{	
		// no retargeting during minion fights
		note = level util::waittill_any_return("sniper_fire_timeout");
	}

	if ( note != "sniper_interrupted" )
	{
		if ( note == "retarget_sniper")
		{
			wait 1;
			target = level.sniper_override_target;
		}
		
		if ( IsDefined(target) )
		{
			if ( IsPlayer(target) || target == level.ally_target )
			{
				MagicBullet( GetWeapon("sniper_hyperion"), level.sniper_loc.origin, target GetTagOrigin( "tag_eye" ), level.sniper_boss);
			}
			else
			{
				MagicBullet( GetWeapon("sniper_hyperion"), level.sniper_loc.origin, target GetTagOrigin( "tag_eye" ));
			}
	//		MagicBullet( GetWeapon("sniper_hyperion"), level.sniper_loc.origin, target.origin + offset, level.sniper_boss);
	//		level.turret turret::fire(0);

	
			foreach (player in level.players) // hack for now to hear sniper shot
			{
				player playsoundtoplayer("wpn_dsr50_fire_npc", player);
			}
		}
	}

	level.turret turret::enable_laser(false, 0);
	
	return ( note != "sniper_interrupted" );
}

function sniper_timer(duration)
{
	level endon("sniper_interrupted");
//	level endon("retarget_sniper");
	
	wait duration;
	
	level notify("sniper_fire_timeout");
}

function sniper_suppression_monitor()
{
	level endon("sniper_interrupted");
	level endon("sniper_moved");
	
	level.sniper_hit_trigger waittill("damage");

	level notify("sniper_interrupted");
}

function monitor_players_shooting()
{
	level flag::wait_till("inroom");
	
	foreach (player in level.players)
	{
		player thread monitor_weapon_fire();
	}
}

function monitor_weapon_fire()
{
	self endon("death");
	self endon("disconnect");
	
	while (  !(level flag::get("end_battle")) )
	{
//		self util::waittill_any("weapon_fired", "weapon_fire", "grenade_fire", "fire");
		self waittill("weapon_fired");
		
		level.sniper_override_target = self;

		level notify("retarget_sniper");
		wait 1;
	}
}

function fake_laser_target(target, duration, offset, blendTime)
{
	level endon("sniper_interrupted");
	
	curTarget = target;
	curOffset = offset;
	
	if ( !IsDefined(blendTime) )
		blendtime = 0;
	
	endtime = GetTime() + duration * 1000;
	
	level.turret turret::enable_laser(true, 0);
	level.turret settargetentity(target, (0,0,40) );
//	wait duration;

  	while ( GetTime() < endTime && IsDefined(curTarget) )
	{
		if ( IsDefined(level.sniper_override_target) && level.hendricks_moving )
		{
			level.turret settargetentity(level.sniper_override_target, (0,0,40) );
//			curTarget = level.sniper_override_target;
//			curOffset = (0,0,70);
		}
//		level.turret.angles = VectorToAngles(curTarget GetTagOrigin( "tag_eye" ) - self.origin);
//		level.turret.angles = VectorToAngles(curTarget.origin + curOffset - self.origin);
//		drawDebugLineOverride(self.origin, curTarget.origin + curOffset, (255,0,0), 0.05);
		wait 0.05;
	}

//	dir = target.origin - self.origin;
//	self.angles = math::vec_to_angles (dir );
	
//	self LaserOn();

//	wait duration;
	
//	self LaserOff();
}


function monitor_players_on_floor()
{
	while (  !(level flag::get("end_battle")) )
	{
		level flag::wait_till("on_floor");
		guys = spawner::simple_spawn("ground_troops", &ground_troops_spawnfunc);
		
		ai::waittill_dead_or_dying(guys, guys.size);
		
		level flag::clear("on_floor");
	}
}

function spawn_enemy_wave(name)
{
	
}

function callback_hendricks_damage( eInflictor, eAttacker, iDamage, iDFlags, sMeansOfDeath, weapon, vPoint, vDir, sHitLoc, modelIndex, psOffsetTime, boneName )
{

	// Don't allow players to kill friendlies
	if( IsDefined(eAttacker) && isplayer(eAttacker) )
	{
		iDamage = 0;
	}
	else		
	{
		if ( !self._laststand && ( eAttacker == level.sniper_boss || eAttacker == level.turret ) )
		{
			iDamage = 0;
			self.sniper_hits++;
			
			//if ( self.sniper_hits >= 3 )
			{
				// man down
				self._laststand = true;
				self.ignoreme = true;
//				iDamage = self.health;
				
				self notify("shot_down");
				self thread animation::play( "ch_ram_03_02_defend_vign_last_stand_loop_guy01", self.origin, self.angles);
				
				self thread ai_laststand::AILastStand();
				self thread wait_for_revive();
			}
		}
	}
	
	return iDamage;
}

function rescue_nags()
{
	self endon("death");
	rescue_nag = [];
	
	rescue_nag[0] = "hend_i_m_down_need_assis_0";
	rescue_nag[1] = "hend_i_m_not_going_to_las_0";
	rescue_nag[2] = "hend_a_little_help_here_0";
	rescue_nag[3] = "hend_i_m_bleeding_out_dow_0";
	
	nag_line = 0;

	while (1)
	{
		nag_wait = 4;
		self waittill("shot_down");
		wait 1;
		while ( self._laststand )
		{
			being_revived = false;
			foreach (player in level.players)
			{
				if ( player ai_laststand::is_reviving_ai( self ) )
				{
					being_revived = true;
					break;
				}
			}
			
			if ( !being_revived)
			{
				nag_line = self play_vo_from_array(rescue_nag, nag_line);
				wait nag_wait;
				nag_wait *= 2;
			}
			else
			{
				wait nag_wait;
			}
		}
	}
}
		

function wait_for_revive()
{
	self endon("death");
	
	self waittill("ai_revived");

	self StopAnimScripted( 0.2 );
	self._laststand = false;
	self.ignoreme = false;
}

function ground_troops_spawnfunc()
{
	// hack for bug in waittill_dead_or_dying
	self.ignoreForFixedNodeSafeCheck = false;
	
	wait 0.1;
	
	self cleargoalvolume();

	// TODO: set any players in the ground triggers as enemies
	trig =  getEnt("floor_trigger", "targetname");
	guys = get_players_touching(trig);
	guys[guys.size] = level.ally_target;
	
	target =  guys[randomintrange(0, guys.size)];
	self thread ai::shoot_at_target( "normal", target );
	self.e_target = target;
//	self thread ai::set_goal(target.targetname);
}

function sniper_minion_setup()
{
	ai::CreateInterfaceForEntity( self );
	self ai::set_behavior_attribute( "cqb", true );
	
	if ( IsDefined( self.script_noteworthy ) )
	{
		switch ( self.script_noteworthy )
		{
			case "seeker":
				self thread ground_troops_spawnfunc();
				break;
			case "back_boys":
				self SetGoalVolume( GetEnt( "back_vol", "targetname" ) );
				break;
			case "middle_men":
				self SetGoalVolume( GetEnt( "close_vol", "targetname" ) );
				break;
		}
	}
}

function get_players_touching(trigger)
{
	touchers = [];

	players = GetPlayers();
	
	foreach( player in players )
	{
		if ( player IsTouching( trigger ) )
		{
			touchers[touchers.size] = player;
		}
	}
	
	return touchers;
}

function drawDebugLineOverride(fromPoint, toPoint, color, durationFrames)
{
	as_debug::drawDebugLineInternal(fromPoint, toPoint, color, durationFrames);
/*
	for (i=0;i<durationFrames;i++)
	{
		line (fromPoint, toPoint, color, true);
		wait 0.05;
	}
*/
}

function array_create(e1, e2)
{
	a = [];
	a[0] = e1;
	a[1] = e2;
	
	return a;
}

function boss_temp_intro_vo()
{
	wait 2;
	sm_ui::temp_vo("Hendricks: Slow down.");
	wait 1;
	sm_ui::temp_vo("Hendricks: He's close...");
	wait 5;
	sm_ui::temp_vo("Hendricks: He could be anywhere, stay sharp.");
	wait 10;
	sm_ui::temp_vo("Wounded Soldier: Over here! Help ... Please!");
	sm_ui::temp_vo("Soldier: We have to help!");
	sm_ui::temp_vo("Hendricks: Stay.");
	wait 3;
	sm_ui::temp_vo("Hendricks. No Get down!");
}

function boss_temp_intro()
{
	text_array = [];
	text_array[ 0 ] = "Prometheus Sniper Battle";
	text_array[ 1 ] = "Hendricks must make it to the far side of the room";
	text_array[ 2 ] = "where Prometheus is sniping at the player from hidden positions.";
	text_array[ 3 ] = "Watch out for the laser sight and enemy soldiers.";
	
	debug::debug_info_screen( text_array, undefined, undefined, undefined, undefined, undefined, undefined, false );
}


function end_battle()
{
	// hack/fix below
//	if(Isdefined(level.end_battle_hack))
//		return;
//	level.end_battle_hack = 1;
	// end hack/fix
	
	level.hendricks util::magic_bullet_shield();
	level.hendricks.script_ignoreme = true;

	level flag::set("end_battle");
	
	level flag::wait_till_timeout(10, "ally_in_cover");
	level.hendricks_moving = false;
	level.hendricks ai::set_behavior_attribute( "cqb", false );
/*	
	txt = [];
	txt[txt.size]="Hyperion's death on the tree / spike.";
	txt[txt.size]="See video: Aquifer_Hyperion_Death.mov";
	thread debug::debug_info_screen(txt);
*/
	struct = GetEnt("hyperion_death_origin", "targetname");
	struct scene::play( "cin_aqu_05_20_boss_1st_death_main", level.sniper_boss );
	
	level.hendricks dialog::say("hend_son_of_a_bitch_comm_0");
	level dialog::remote( "comm_command_copies_all_0" );
	level.hendricks dialog::say("hend_we_re_ready_to_assis_0");
	level dialog::remote( "kane_hendricks_this_is_k_0" );
	level.hendricks dialog::say("hend_we_re_on_it_hendric_0");

	level flag::set("hyperion_start_tree_scene"); 
	aquifer_util::toggle_interior_doors(true);
}