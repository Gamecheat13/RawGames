#include maps\_utility;
#include common_scripts\utility;
#include maps\_vehicle;
#include maps\_anim;
#include maps\_audio;
#include maps\hijack_code;
#include maps\_blizzard_hijack;

start_post_tarmac()
{
	//level.commander = spawn_ally("commander");
	level.commander = spawn_ally("commander_tarmac");
	//level.president = spawn_ally("president");
	//level.advisor   = spawn_ally("advisor");	
	waittillframeend;

	player_start_struct = GetStruct( "player_start_post_tarmac", "targetname" );
	level.player setOrigin( player_start_struct.origin );
	level.player setPlayerAngles( player_start_struct.angles );
	
	maps\_compass::setupMiniMap("compass_map_hijack_tarmac", "tarmac_minimap_corner");
	setsaveddvar( "compassmaxrange", 3500 ); //default is 3500
	
	thread maps\hijack_tarmac::tarmac_dead_allies();
	aud_send_msg("start_post_tarmac");
	
	flag_set("player_on_feet_post_crash");	
	flag_set("spawn_makarov_heli");
	flag_set("start_spotlight_random_targeting");
	flag_init("flag_red_leave_tarmac_combat");
	flag_init("tarmac_combat_level_fail");
	flag_set("fx_crash_trench_fire");
		
	//this will call into main() below
	thread maps\hijack_tarmac::main_script_thread();

	thread combat_scene_fail_trigger();
	
	level.player_original_jump_height = GetDvarFloat("jump_height");	
		
	hover_node = GetStruct("makarov_heli_end_scene_loop", "targetname");
	level.makarov_heli Vehicle_Teleport(hover_node.origin,hover_node.angles);
	level.makarov_heli thread vehicle_paths(hover_node);

	wait(2);
	ai = GetAIArray();
	foreach(guy in ai)
	{
		if ( !IsEnemyTeam(guy.team,level.player.team) )
		{
			guy thread cold_breath_hijack();
		}
	}	
	
	level.player giveWeapon( "fraggrenade" );
	level.player SetOffhandPrimaryClass( "frag" );
	level.player SetWeaponAmmoClip( "fraggrenade", 0 );
	level.player SetWeaponAmmoStock( "fraggrenade", 0 );
	level.player setOffhandSecondaryClass( "flash" );
	level.player giveWeapon( "flash_grenade" );
	level.player SetWeaponAmmoClip( "flash_grenade", 0 );
	level.player SetWeaponAmmoStock( "flash_grenade", 0 );
}

main()
{
	thread maps\hijack_script_2c::end_scene();
	
	level.fixednodesaferadius_default = 256;
	
	thread start_tarmac_combat1();
	thread tarmac_combat_wave2();
	thread tarmac_combat_wave3();
	thread tarmac_combat_wave4();
	
	flag_wait("entered_post_tarmac_area");
	
	//wait 0.5;
	
	thread tarmac_combat_vo();
	
	level waittill("commander_react_to_combat");
	
	level.commander.ignoreall = false;
	level.commander.notarget  = false;
	level.commander.ignoreme  = false;
	level.commander notify("reach_notify");
	level.commander clear_run_anim();
	level.commander clear_generic_idle_anim();
	level.commander notify("stop_relaxed_idle");	
	level.commander anim_stopanimscripted();
	level.commander animscripts\animset::clear_custom_animset();
	level.commander set_force_color("r");
	level.commander enable_ai_color();
	level.commander.moveplaybackrate = 1.0;
	level.commander.disablearrivals = false;
	
	maps\hijack_tarmac::set_player_move_and_jump_speed(1.0);

	level.commander set_run_anim( "tarmac_enter_combat_commander" );
	anim_time = GetAnimLength(level.commander GetAnim("tarmac_enter_combat_commander"));
	wait(anim_time);
	level.commander clear_generic_run_anim();
	wait(0.05);
	old_goal_pos = level.commander.goalpos;
	level.commander SetGoalPos(level.commander.origin);
	wait(0.05);
	level.commander SetGoalPos(old_goal_pos);
}

start_tarmac_combat1()
{
	//spawn guys for assist
	level.secret_service_assist = array_spawn_targetname("secret_service_assist");
	foreach(guy in level.secret_service_assist)
	{
		guy magic_bullet_shield();
		//guy set_force_color("b");
	}
	
	fso_runner = get_living_ai( "tarmac_combat_running_agent", "script_noteworthy" );
	fso_runner thread tarmac_combat_fso_runner();
	
	flag_wait("start_tarmacend_combat");
	level.commander.ignoreall = false;
	level.commander.ignoreme = false;
	//thread autosave_now(0);
	thread autosave_by_name( "start_tarmac_combat" );
	battlechatter_on( "axis" );
	
	level.player giveWeapon( "fraggrenade" );
	level.player SetOffhandPrimaryClass( "frag" );
	level.player SetWeaponAmmoClip( "fraggrenade", 0 );
	level.player SetWeaponAmmoStock( "fraggrenade", 0 );
	level.player setOffhandSecondaryClass( "flash" );
	level.player giveWeapon( "flash_grenade" );
	level.player SetWeaponAmmoClip( "flash_grenade", 0 );
	level.player SetWeaponAmmoStock( "flash_grenade", 0 );
	
	tarmacrunners = array_spawn_targetname("tarmacrunners");
	tarmacrunners_delete = array_spawn_targetname("tarmacrunners_delete");
	
	

	shotgunguys = GetEntArray("tarmacrunners_shgn","script_noteworthy");
	
	foreach(thing in shotgunguys)
	{
		if( !IsSpawner(thing))
		{
			thing SetGoalEntity(level.player);
			break;
		}
	}
	
	

	
	foreach(guy in tarmacrunners_delete)
	{
		guy.ignoreall = true;
	}
	
	thread tarmacrunners_delete();
	
	//wave1veh = create_vehicle_from_spawngroup_and_gopath(200);
	

	gaz = spawn_vehicle_from_targetname_and_drive( "intro_gaz_turret" );
	gaz thread maps\hijack_tarmac::turn_on_headlights();
	gaz thread suv_setup();
	
	//gaz build_bulletshield ( true );
	gaz_turret_guy = undefined;
	
	foreach ( guy in gaz.riders )
	{
		gaz thread handle_rider_death( guy, gaz );

	}	
	
	wait .25;
	
	
	tarmacwave1 = get_ai_group_ai("tarmacwave1");
	
	foreach(guy in tarmacwave1)
	{
		 guy.pathRandomPercent = randomintrange( 30, 100 );
		 //guy.baseaccuracy = 1.5;
	}
	
	aud_send_msg("first_suv");
	
	//waittill_aigroupcount("tarmacwave1", 2);
	
	wait 10;
	flag_set("tarmac_combat_wave2");
	

}
tarmac_combat_fso_runner()
{
	self endon( "death" );
	
	ak = getEnt( "runner_ak74u", "targetname" );
	ak HidePart("tag_acog_2");
	ak HidePart("tag_eotech");
	ak HidePart("tag_hamr_hybrid");
	ak HidePart("tag_silencer");
	ak HidePart("tag_thermal_scope");
	
	self.animname = "generic";
	self gun_remove();
	self.ignoreall = true;
	self.ignoreme = true;
	flag_wait( "entered_post_tarmac_area" );
	
	wait(2.5);
	
	animnode = getStruct( "agent_grabs_gun_origin", "targetname" );
	animnode anim_reach_solo( self, "tarmac_enter_combat_agent" );
	animnode thread anim_single_solo( self, "tarmac_enter_combat_agent" );
	
	wait(1.2);
	
	self gun_recall();
	ak delete();
	
	self waittillmatch("single anim","end");
	
	self.ignoreall = false;
	self.ignoreme = false;
	
	ending_node = GetNode("agent_post_anim_node","targetname");
	self SetGoalNode(ending_node);
	
	wait(10);
	self set_force_color("b");
}

tarmac_combat_wave2()
{
	flag_wait("tarmac_combat_wave2");
	//thread autosave_now(1);
	thread autosave_by_name( "wave2_starting" );
	
	gaz = spawn_vehicle_from_targetname_and_drive( "turret_gaz2" );
	

	gaz thread maps\hijack_tarmac::turn_on_headlights();
	gaz thread suv_setup();

	
	//gaz build_bulletshield ( true );
	gaz_turret_guy = undefined;
	
	foreach ( guy in gaz.riders )
	{
		gaz thread handle_rider_death( guy, gaz );

	}
	

	
	/*tarmacrunners_delete = array_spawn_targetname("tarmacrunners_delete");
	foreach(guy in tarmacrunners_delete)
	{
		guy.ignoreall = true;
	}*/
	
	tarmacrunners2 = array_spawn_targetname("tarmacrunners2");
	

	tarmacwave2 = get_ai_group_ai("tarmacwave2");
	
	foreach(guy in tarmacwave2)
	{
		 guy.pathRandomPercent = randomintrange( 30, 100 );
		 //guy.baseaccuracy = 1.5;
	}
	waittill_aigroupcount("tarmacwave2",2);
	
	flag_set("tarmac_combat_wave3");
	
	wait 10;
	
	retreat_from_vol_to_vol("tarmac_goal","tarmac_goal_ret");
}

handle_rider_death( guy, gaz )
{
	guy.noragdoll = true;
	guy.no_vehicle_ragdoll = true;
}

tarmac_combat_wave3()
{
	flag_wait("tarmac_combat_wave3");
	//thread autosave_now(1);
	thread autosave_by_name( "wave3_starting" );
	retreat_from_vol_to_vol("tarmac_goal_ret","tarmac_goal_ret2");
	
	//wave3veh = create_vehicle_from_spawngroup_and_gopath(300);

	gaz = spawn_vehicle_from_targetname_and_drive( "turret_gaz3" );
	gaz thread maps\hijack_tarmac::turn_on_headlights();
	gaz thread suv_setup();
	
	//gaz build_bulletshield ( true );
	gaz_turret_guy = undefined;
	
	foreach ( guy in gaz.riders )
	{
		gaz thread handle_rider_death( guy, gaz );

	}
		
	
	foreach(guy in level.secret_service_assist)
	{
		guy stop_magic_bullet_shield();
	}
	

	

	tarmacwave3 = array_spawn_targetname("tarmacwave3");
	
	foreach(guy in tarmacwave3)
	{
		 guy.pathRandomPercent = randomintrange( 30, 100 );
		 //guy.baseaccuracy = 1.5;
	}
	
	waittill_aigroupcleared("tarmacwave3");
	
	retreat_from_vol_to_vol("tarmac_goal_ret2","tarmac_goal_ret3");
	flag_set("tarmac_combat_wave4");
	trigger = GetEnt( "red_leave_tarmac_combat", "targetname" );
	if(isdefined(trigger))
	{
		//activate_trigger_with_targetname("red_leave_tarmac_combat");
		trigger activate_trigger();
	}
		flag_set("flag_red_leave_tarmac_combat");
	
	//thread autosave_now(1);
	thread autosave_by_name( "wave3_done" );
	
}

tarmac_combat_wave4()
{
	flag_wait("tarmac_combat_wave4");
	endguys = array_spawn_noteworthy("endsceneguys_SUV");
	if ( level.start_point != "end_scene" )
	{
		endguys_2 = array_spawn_noteworthy("endsceneguys");
		endguys = array_combine(endguys,endguys_2);
	}
	
	//commander advance when endtarmacguys1 aigroup is cleared
	thread check_endsceneguys_commander_advance();
	
	endsuburban = spawn_vehicle_from_targetname("endsuburban");
	
	endsuburban thread maps\hijack_tarmac::turn_on_headlights();
	//endsuburban.health = 1500;
	//endsuburban.maxhealth = 1500;
	level.commander.ignoresuppression = true;

	level.endguytarget = GetEnt("endguytarget","targetname");
	
	foreach(guy in endguys)
	{
		if(IsAlive(guy))
		{
			if(guy.script_aigroup == "endsceneguys" )
			{
				guy SetEntityTarget(level.endguytarget);
				guy thread damagemonitor(endguys);
			}
		}
	}
	
	retreat_from_vol_to_vol("tarmac_goal_ret","tarmac_goal_ret2");
	
	thread force_kill_endguys(endguys);
	
	waittill_aigroupcleared( "endsceneguys" );
	wait 1; // give their ragdoll a chance to settle down before saving checkpoint
	flag_set("endguys_dead");
}

check_endsceneguys_commander_advance()
{
	waittill_aigroupcleared( "endtarmacguys1" );
	
	trigger = GetEnt( "red_leave_tarmac_combat2", "targetname" );
	trigger2 = GetEnt( "red_leave_tarmac_combat" , "targetname");
	if(isdefined(trigger))
	{
		//activate_trigger_with_targetname("red_leave_tarmac_combat");
		trigger activate_trigger();
	}
	level.commander.ignoreall = true;
	
	if(IsDefined(trigger2))
	{
		trigger2 trigger_off();
	}
}

combat_scene_fail_trigger()
{
	trigger = GetEnt("combat_scene_fail_trigger","targetname");

	flag_wait("tarmac_combat_level_fail");
	
	setDvar( "ui_deadquote", &"HIJACK_FAIL_TARMAC" );
	level notify( "mission failed" );
	missionFailedWrapper();
}

force_kill_endguys(endguys)
{
	flag_wait("kill_final_enemies");
	
	foreach(guy in endguys)
	{
		if(IsAlive(guy))
		{
			MagicBullet("AK74u",level.end_secret_service GetTagOrigin("tag_weapon"), guy.origin+(0,0,36));
			wait(0.05);
			MagicBullet("AK74u",level.end_secret_service GetTagOrigin("tag_weapon"), guy.origin+(0,0,36));
			wait(0.05);
			MagicBullet("AK74u",level.end_secret_service GetTagOrigin("tag_weapon"), guy.origin+(0,0,36));
			wait(0.05);
			MagicBullet("AK74u",level.end_secret_service GetTagOrigin("tag_weapon"), guy.origin+(0,0,36));
			wait(0.05);
			guy kill();
		}
		wait(0.5);
	}
}

damagemonitor( guys )
{
	while( 1 )
	{
		self waittill( "damage", amount, attacker);
		level.commander.ignoreall = false;

		if( IsDefined(attacker) && IsPlayer(attacker) )
		{
			foreach( guy in guys)
			{
				if( IsDefined(guy) && IsAlive(guy) )
				{
					guy ClearEntityTarget( level.endguytarget );
				}
			}
			
			break;
		}
	}
}

tarmac_combat_vo()
{	
	//temp_dialogue("Radio", "This is Team 4. We’re taking heavy fire and multiple enemy vehicles are inbound.", 5);
	radio_dialogue("hijack_fso4_heavyfire");
	
	level notify("commander_react_to_combat");	
	//temp_dialogue("Commander", "Harkov, we have to move!");
	level.commander dialogue_queue("hijack_cmd_wehavetomove");

	//temp_dialogue("Radio", "The President is not secure; we need backup immediately", 5);
	radio_dialogue("hijack_fso4_notsecure");
	
	level notify("commander_call_to_combat");		
	//temp_dialogue("Commander", "Team 2, get Alena out of there. All other agents close in on the president’s location.", 5.0);	             	
	level.commander dialogue_queue("hijack_cmd_getalenaout");
	
	flag_wait("tarmac_combat_wave2");
	wait 1.0;
	//temp_dialogue("Radio", "Additional enemy positions near the hangar and closing!");
	radio_dialogue("hijack_fso1_nearhangar");
	
	//temp_dialogue("Commander", "Let’s move it, Harkov!");
	level.commander dialogue_queue("hijack_cmd_letsmoveit");
	
//	wait 3.0;
	flag_wait("tarmac_combat_wave3");
	wait 1.5;
	
	//temp_dialogue("Commander", "Keep pushing forward!!");
	level.commander dialogue_queue("hijack_cmd_keeppushing2");
	
	flag_wait("tarmac_combat_wave4");	
	wait 2.0;
	
	//temp_dialogue("Radio","3 agents down. Multiple wounded. We’re losing ground. Where the hell  is our evac?!", 5.0);
	radio_dialogue("hijack_fso2_multiplewounded");
	
	//temp_dialogue("Commander","Move up! Move up!", 5.0);
	level.commander dialogue_queue("hijack_cmd_moveupmoveup");

	//temp_dialogue("Radio", "All agents, our situation is critical. The President’s safety has been compromised!", 5.0);
	radio_dialogue("hijack_fso3_critical");
	
	wait 2.0;
	
	tarmac_combat_vo_end();
}

tarmac_combat_vo_end()
{
	//temp_dialogue("Radio", "Code black! Code black!");
	radio_dialogue("hijack_fso3_codeblack");

	flag_wait("player_approaching_end_guys");
	//temp_dialogue("Commander", "Take them down!");
	level.commander dialogue_queue("hijack_cmd_takethemdown");
	
	flag_wait("player_entered_end_area");
	//temp_dialogue("Commander", "FSO inbound. How your fire! Hold your fire!");
	level.commander dialogue_queue("hijack_cmd_holdyourfire");
}

tarmacrunners_delete()
{
	volume = getent("tarmacrunners_goal2","targetname");
	
	while(1)
	{
		wait 1;
		
		axis = volume get_ai_touching_volume( "axis" );
		
		foreach (dude in axis)
		{
			if( IsDefined(dude) && IsAlive(dude) && IsDefined(dude.script_noteworthy) )
			{
				if ( dude.script_noteworthy == "tarmacrunners_goal2" )
				{
				dude delete();
			}
		}
	}
}
}
	
retreat_from_vol_to_vol( from_vol, retreat_vol)
{
	AssertEx (  ((IsDefined(retreat_vol)  && IsDefined( from_vol ) ) ), "Need the two info volume names ." );

	checkvol = getEnt( from_vol , "targetname" );
	retreaters = checkvol get_ai_touching_volume(  "axis" );
	goalvolume = getEnt( retreat_vol , "targetname" );
	goalvolumetarget = getNode( goalvolume.target , "targetname" );
	foreach( retreater in retreaters )
	{
		if(IsDefined(retreater) && IsAlive(retreater))
		{
			//retreater thread streets_ignore_enemies();
			retreater.fixednode = 0;
			//retreater.sprint = true;
			retreater.pathRandomPercent = randomintrange( 75, 100 );
			retreater SetGoalNode( goalvolumetarget );
			retreater SetGoalVolume( goalvolume );		
			//wait(RandomFloatRange(.25,.5)); // Only want to wait if we actually processed someone.
			
		}
	}
	
}

streets_ignore_enemies( delay , mark_for_delete )
{
	if( !IsDefined(delay))
		delay = 3;
	if( !IsDefined(mark_for_delete))
		mark_for_delete = false;
	
	self.ignoreall = true;
	self ClearEnemy();
	if( delay == -1 )
	{
		self waittill( "goal" );
	}
	else
	{
		wait delay;
	}
	if(IsDefined(self) && IsAlive(self) )
	{
		if( mark_for_delete )
		{
			self Delete();
			return;
		}
		self.ignoreall = false;
		self disable_sprint();
		
	}
	
}

suv_setup()
{
	//self vehicle_lights_on();
	
	self waittill( "death" );
	
	//self vehicle_lights_off( "all" );
	
	aud_send_msg("suv_explosion");
	self play_sound_on_entity ("hijk_suv_explosion");
}
