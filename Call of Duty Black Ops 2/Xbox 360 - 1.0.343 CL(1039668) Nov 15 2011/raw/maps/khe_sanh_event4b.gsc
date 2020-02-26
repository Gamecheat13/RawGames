//////////////////////////////////////////////////////////
//
// khe_sanh_event4b.gsc
//
//////////////////////////////////////////////////////////

#include maps\_utility;
#include common_scripts\utility;
#include maps\khe_sanh_util;
#include maps\_anim;
#include maps\_music;
#include maps\_scene;

main()
{
	level threatbiasgroups();
	event4b_intro();
}

event4b_intro()
{
	flag_set("obj_retake_the_hill");

	flag_init("e4b_line_a_taken");
	flag_init("e4b_line_b_taken");
	flag_init("huey_shoot");
	flag_init("huey_switch_targets");
	flag_init("enter_bunker");
	flag_init("hilltop_melee_start");
	//flag_init("hilltop_window_start");
	flag_init("woods_jam_hit");
	flag_init("player_jam_window_end");
	//flag_init("line_a_legit");
	//flag_init("line_b_legit");
	flag_init("flag_e4b_first_approach");

	array_thread(GetEntArray("e4b_redshirts", "targetname"), ::add_spawn_function, ::event4b_allies_think);

	//tree burst explode fx
	level thread event4b_tree_fx();
	level thread event4b_death_loops();

	//allow FTs to drop now
	level.rw_ft_allowed = true;
	level thread wait_player_gets_flamethrower();

	if(!level.e4c_woods_jam)
	{
		level.player thread line_b_kill_watcher();
		level thread event4b_start_line_a();
		level thread event4b_start_line_b();
		level thread event4b_start_line_c();
		level thread event4b_first_approach();
	}
	else
	{
		level thread event4b_woods_jam();
	}

	flag_wait("obj_retake_the_hill_complete");
}

event4b_start_line_a()
{
	//turn on allies
	trigger_use("e4b_redshirt_sm");
	trigger_use("e4b_redshirt_sm_color");

	//trigger = GetEnt("e4b_start", "targetname");
	//trigger waittill("trigger");

	flag_wait("e4b_start");

	//always set ignoreall off on heroes here because player is ahead
	//event4_squad_rally ends when this is hit
	level.squad["woods"].ignoreall = false;
	level.squad["hudson"].ignoreall = false;
	level.squad["woods"].ignoreme = false;
	level.squad["hudson"].ignoreme = false;

	//stop the e4 transition mortars
	level notify("stop_mortars");

	level.squad["hudson"] anim_single(level.squad["hudson"], "HQ_rush");//Toward the HQ!
	wait 0.1;
	level.squad["woods"] thread anim_single(level.squad["woods"], "up_hill");//Get up the hill!

	//start uphill amb mortars
	//ambient_mortar_explosion(struct_name, grp_name, wait_time, interval, range)
	level thread ambient_mortar_explosion("struct_e4b_amb_mortar_", "efb_amb_mortar", 1, 2.25, 100);

	e4b_start_guys = simple_spawn("e4b_line_a_start");

	trigger_use("e4b_line_a_sm");
	trigger_use("e4b_line_a_color");
	
	//FOR TUEY: end music as the guys are going into event 4
	setmusicstate ("HAMBURGER_HILL");
	
	//trigger_use("e4b_redshirt_sm");
}

line_a_cleared()
{
	waittill_spawn_manager_cleared("e4b_line_a_sm");
	flag_set("e4b_line_a_taken");
}

event4b_start_line_b()
{
//	waittill_spawn_manager_cleared("e4b_line_a_sm");
//	waittill_spawn_manager_complete("e4b_line_a_sm");
	line_a_sm = GetEnt("e4b_line_a_sm", "targetname");
	//first_line_trig = GetEnt("trig_e4b_firstline", "targetname");
	flag_wait("flag_e4b_first_approach");//

	level thread line_a_cleared();

	//waittill_any_ents(first_line_trig, "trigger", line_a_sm, "cleared");
	//									//player charges trigger flag    //spawn cleared
	level waittill_any_or_timeout( 25, "trig_e4b_firstline", "e4b_line_a_taken");

	level thread kill_e4_trans_drones();

	//turn OFF ambient effects Downhill areas
	//stop_exploder(40);

	array_thread(GetEntArray("e4b_line_c_start", "targetname"), ::add_spawn_function, ::set_rocketguy_ammo);
	level thread event4b_marine_yell_huey();

	flag_set("e4b_line_a_taken");

	autosave_by_name("e4b_line_b");

	flag_set("obj_rally_at_hill_complete");
	flag_set("obj_retake_the_hill");

	trigger_use("e4b_allies_take_a"); //colors
	level thread throttle_line_b_enemy_spawn();


	level.squad["woods"] thread anim_single(level.squad["woods"], "head_down");//Keep your heads down!

	wait(3.0);

	level.squad["hudson"] thread anim_single(level.squad["hudson"], "move_up");//Move up!
	
	flame_guys = simple_spawn("e4b_line_b_flamethrower_left");
}

throttle_line_b_enemy_spawn()
{
	trigger_use("e4b_line_b_sm"); //enemies left

	wait 4;

	//killed by trig "e4b_line_b_flank" with sm_die kvp
	trigger_use("e4b_line_b_flankers_sm");
}

kill_e4_trans_drones()
{
	level notify("stop_drone_speed_adjust");
	
	//dont generate any more drone yelling threads 
	level notify("stop_setup_drone_yells"); //nukes the manager that creates yelling
	level notify("stop_drone_yells"); //nukes all VO created on drones
	
	remove_drone_structs(level.drone_e4_hill_trans, true, false);
}

line_b_ai_killed_watcher()
{
	x = 2;
	switch( GetDifficulty() )
	{
	case "easy": 
	case "medium":
		x = 2;
		break;
	case "hard":
	case "fu":
		x = 4;
		break;
	}	
	
	waittill_ai_group_amount_killed("line_b", x);
	flag_set("e4b_line_b_taken");
}

event4b_start_line_c()
{
//	waittill_spawn_manager_cleared("e4b_line_b_sm");
//	waittill_spawn_manager_complete("e4b_line_b_sm");

	//trig = GetEnt("e4b_line_b_flank", "targetname");
	//trig waittill("trigger");

	flag_wait("e4b_line_a_taken");

	//update pos
	flag_set("obj_retake_the_hill_rally");

	spawn_manager_kill("e4b_line_b_sm");

	level thread line_b_ai_killed_watcher();

	//waittill_ai_group_amount_killed("line_b", 1);
	//waittill_spawn_manager_cleared("e4b_line_b_flankers_sm");
	//player charges trigger flag "e4b_line_b_flank" //amount of spawn cleared
	//not letting this progress if player hits trigger because we need to keep the AI counts low so the lines have to be killed
	level waittill_any_or_timeout( 45, "e4b_line_b_taken");

	level.squad["woods"] anim_single(level.squad["woods"], "incoming_yell");//INCOMING!!!

	flag_set("e4b_line_b_taken");
	trigger_use("e4b_allies_take_b");

	//waittill_spawn_manager_cleared("e4b_line_b_sm");

	autosave_by_name("e4b_line_c");

	level.squad["woods"] anim_single(level.squad["woods"], "foxhole");//Use the foxholes for cover!

	level thread move_heroes_after_closer();

	e4b_line_c_start_guys = simple_spawn("e4b_line_c_start");
	e4b_mmg_guy = simple_spawn_single("e4b_line_c_mmg");

	level thread rpg_spawn_vo();

	//set stances for this line of spawners
	array_thread(GetEntArray("e4b_line_c", "targetname"), ::add_spawn_function, ::spawners_crouch_prone);
	level thread delay_e4b_line_c_sm();

	
	//stop amb mortars
	level notify("stop_mortars");
	
	wait 0.1;

	//start mortars tophill
	//ambient_mortar_explosion(struct_name, grp_name, wait_time, interval, range)
	level thread ambient_mortar_explosion("struct_e4b_mortar_", "e4b_hill_bunker_mortars", 0.5, 2.25, 100);

	level thread event4b_woods_jam();

	//waittill_spawn_manager_cleared("e4b_line_c_sm");
	flag_wait("obj_retake_the_hill_complete");
}

delay_e4b_line_c_sm()
{
	//spawn manager for top of hill
	wait 4;
	trigger_use("e4b_line_c_sm");
}

move_heroes_after_closer()
{
	wait 5;
	//heroes get closer to third line to move player up
	trigger_use("e4b_heroes_push_forward");
}

//if player pass a certain point and line b is not clear mortar death him. oi
//self is player
line_b_kill_watcher()
{
	level endon("woods_jam_hit"); //this is a script_flag_set on the woods jam trigger
	level endon("e4b_line_b_taken"); //if line c has started kill it //

	source_loc = getstruct("struct_e4b_mortar_7", "script_noteworthy");
	
	//while(self.origin[1] > node.origin[1]) //if player passes this node heading up
	while(self.origin[1] < -4685) 
	{
		wait(0.05);
	}		

	x = RandomIntRange(0, 9);

	//fake multiple ways you can die
	if(x < 4)
	{
		level thread maps\_shellshock::main(level.player.origin, 5, 256, 0, 0, 0, undefined, "default", 0); 
		level.player thread maps\_mortar::activate_mortar(256, 1, 0, 0.55, 2.0, 512, true, level._effect["e4_trans_mortar"], false); 
		level waittill("mortar_inc_done");
	}
	else
	{
		loc = level.player GetEye();
		y = RandomIntRange(0, 9);

		if(y < 5)
		{	
			MagicBullet("ak47_sp", source_loc.origin, loc);
		}
		else
		{
			if(y < 5)
			{
				MagicBullet("rpg_sp", source_loc.origin, loc);
			}
			else
			{
				level.player MagicGrenadeType( "frag_grenade_sp", source_loc.origin, VectorNormalize(loc - source_loc.origin) * 100, 0.1 );
			}
		}
	}

	level.player khe_sanh_die();
}

rpg_spawn_vo()
{
	wait 3;
	level.squad["woods"] anim_single(level.squad["woods"], "rpg_line_woods");//RPG!

	allies = GetAIArray("allies");
	heroes = [];
	heroes = array_add( heroes, level.squad["woods"] );
	heroes = array_add( heroes, level.squad["woods"] );
	closest = [];

	while(closest.size <= 0)
	{
		closest = get_array_of_closest(level.player.origin, allies, heroes, 5, 700);
		wait 0.05;
	}

	if(closest.size > 0 )
	{
		guy = random(closest);

		if( IsDefined(guy) && !IsDefined(guy.animname) )
		{
			guy.animname = "redshirt_rpg";
			guy anim_single(guy, "rpg_line_0");//Anybody see that RPG?
			guy anim_single(guy, "rpg_line_1");//No, check the other side.
			guy anim_single(guy, "rpg_line_2");//Negative. Negative.
		}
	}
}

event4b_allies_think()
{
	// start IK processing
	self.ikpriority = 5;

	if (!flag("e4b_line_a_taken"))
	{
		self thread event4b_allies_goprone_a();
	}
	else if (!flag("e4b_line_b_taken"))
	{
		self thread event4b_allies_goprone_b();
	}
}

event4b_allies_goprone_a()
{
	self endon("death");

	flag_wait("e4b_line_a_taken");

	trigger = GetEnt("e4b_line_a_go_prone", "targetname");

	while (!self IsTouching(trigger))
	{
		wait(0.05);
	}

	self AllowedStances("crouch");
	//self.ignoreall = true;
	self.ignoresuppression = true;
	self waittill("goal");
	self.ignoreall = false;
	self AllowedStances("stand", "crouch", "prone");
}

event4b_allies_goprone_b()
{
	trigger = GetEnt("e4b_line_b_go_prone", "targetname");
	self endon("death");
	trigger endon("death");

	flag_wait("e4b_line_a_taken");

	while (!self IsTouching(trigger))
	{
		wait(0.05);
	}

	self AllowedStances("crouch");
	//self.ignoreall = true;
	self.ignoresuppression = true;
	self waittill("goal");
	self.ignoreall = false;
	self AllowedStances("stand", "crouch", "prone");

}

event4b_first_approach()
{
	trigger_wait("e4b_first_approach");
	flag_set("flag_e4b_first_approach");

	level notify("first_approach");

	level thread event4_cleanup_firetrig();
	level thread event4b_backtrack_blocker();
	level thread event4b_vignette_marine_arm();

	//cleanup the trap door fom event 3 to 4 transition. Doing it here since they will die if they go back
	if(IsDefined(level.event3_doors))
	{
		array_delete(level.event3_doors);
	}
}

#using_animtree( "generic_human" );
event4b_vignette_marine_arm()
{
	level endon("e4b_line_b_taken");
	
	align_node = GetEnt("align_missing_arm", "targetname");
	mortar = GetEnt("align_missing_arm_mortar", "targetname");

	while(level.player is_player_looking_at( align_node.origin, 0.1, false ))
	{
		wait 0.05;
	}

	mortar = GetEnt("align_missing_arm_mortar", "targetname");
	mortar thread maps\_mortar::activate_mortar(256, 1, 0, 0.55, 2.0, 512, true, level._effect["e4_trans_mortar"], false);

	mortar waittill("mortar");

	if( is_mature() && !is_gib_restricted_build() )
	{
		marine = spawn_fake_character(mortar.origin, mortar.angles, "blown_head");
	}
	else
	{
		marine = spawn_fake_character(mortar.origin, mortar.angles, "sergeant");
	}

	marine.animname = "marine_death";
	marine UseAnimTree(#animtree);

	align_node anim_single_aligned(marine, "marine_missing_arm");
	marine setlookattext("", &"");
	align_node Delete();
	mortar Delete();
}

event4b_marine_yell_huey()
{
	level.player endon("death");
	align_node = GetEnt("align_friendly_fire_yell", "targetname");

	marine_yell = simple_spawn_single("marine_huey_yell");
	marine_yell.animname = "marine_yell";
	marine_yell.ignoresuppression = true;
	marine_yell magic_bullet_shield();

	marine_yell endon("death");

	marine_yell SetGoalNode(GetNode("node_marine_huey_yell", "targetname"));
	marine_yell waittill("goal");

	level thread event4b_friendly_fire_incident();

	flag_wait("huey_switch_targets");
	
	align_node anim_reach_aligned(marine_yell, "yell_at_huey");
	run_scene("e4_yell_huey");
	//align_node anim_single_aligned(marine_yell, "yell_at_huey");

	//in case the player hits woods jam and this guy gets deleted. should be handled by the endon though
	if(IsDefined(marine_yell))
	{
		marine_yell stop_magic_bullet_shield();
	}
	align_node Delete();
}

#using_animtree("generic_human");
event4b_friendly_fire_incident()
{
	//spawn huey and allies 
	activate_trigger_with_targetname("trig_e4b_heli_friendlyfire");

	//make sure created vehicle runs through _vehicle init()
	wait 0.05;

	level.heli_friendly_fire = GetEnt("e4b_heli_friendlyfire", "targetname");
	level.heli_friendly_fire.goalradius = 64;
	level.heli_friendly_fire.ignoreme = true;
	level.heli_friendly_fire SetForceNoCull();

	level.heli_friendly_fire.crew = [];

	//fill in crew
	for(i = 0; i < 4; i++)
	{
		if(i < 3)
		{
			level.heli_friendly_fire.crew[i] = spawn_fake_character(level.heli_friendly_fire.origin, (0,0,0), "huey_pilot_1");
		}
		else
		{
			level.heli_friendly_fire.crew[i] = spawn_fake_character(level.heli_friendly_fire.origin, (0,0,0), "huey_pilot_2");
		}

		level.heli_friendly_fire.crew[i] SetForceNoCull();
	}

	level.heli_friendly_fire.crew[0].animname = "huey_pilot_1";
	level.heli_friendly_fire.crew[1].animname = "huey_pilot_2";
	level.heli_friendly_fire.crew[2].animname = "gunner_pilot_1";
	level.heli_friendly_fire.crew[3].animname = "gunner_pilot_2";

	level.heli_friendly_fire.crew[0] LinkTo(level.heli_friendly_fire,"tag_driver");
	level.heli_friendly_fire.crew[1] LinkTo(level.heli_friendly_fire,"tag_passenger");
	level.heli_friendly_fire.crew[2] LinkTo(level.heli_friendly_fire,"tag_gunner1");
	level.heli_friendly_fire.crew[3] LinkTo(level.heli_friendly_fire,"tag_gunner2");


	for(i = 0; i < level.heli_friendly_fire.crew.size; i++ )
	{
		level.heli_friendly_fire.crew[i] UseAnimTree(#animtree);
		level.heli_friendly_fire.crew[i] thread anim_loop(level.heli_friendly_fire.crew[i], "huey_idle");
	}

	level.heli_friendly_fire thread huey_shoot_start();
	level.heli_friendly_fire thread huey_shoot_stop();
	level.heli_friendly_fire thread huey_switch_targets();
	level.heli_friendly_fire thread huey_shoot_logic(0);
	
	level.heli_friendly_fire thread go_path(GetNode("node_friendly_fire_start", "targetname"));


	level.heli_friendly_fire waittill("reached_end_node");

	for(i = 0; i < level.heli_friendly_fire.crew.size; i++ )
	{
		level.heli_friendly_fire.crew[i] Delete();
	}

	level.heli_friendly_fire Delete();

}

//self is huey
huey_shoot_logic(index)
{
	level.player endon("death");
	self endon("death");
	
	shoot_vec = self.origin;
	self SetGunnerTurretOnTargetRange(0, 20);
	
	sound_ent = spawn( "script_origin" , (0,0,0));
	self thread audio_ent_fakelink( sound_ent );
	sound_ent thread audio_ent_fakelink_delete(self);

	while(1)
	{
		axis = GetAIArray("axis");
		allies = GetAIArray("allies");

		target_right = self.origin + AnglesToRight(self.angles) * 300;

		//targets = array_combine(axis, allies);

		if(flag("huey_shoot"))
		{
			if(flag("huey_switch_targets"))
			{
				if(allies.size > 0)
				{
					x = random(allies);
					if(IsDefined(x))
					{
						shoot_vec = x.origin;	
					}
					else
					{
						shoot_vec = target_right + (0, 0, -500);
					}
				}
			}
			else
			{
				if(axis.size > 0)
				{
					x = random(axis);
					if(IsDefined(x))
					{					
						shoot_vec = x.origin;
					}
					else
					{
						shoot_vec = target_right + (0, 0, -500);
					}
				}		
			}

			self SetGunnerTargetVec( shoot_vec, index );	
			sound_ent playloopsound( "wpn_hind_pilot_fire_loop_npc" );
			self FireGunnerWeapon( index );
			wait 0.65;
			
		}

		if(!flag("huey_shoot"))
		{
			sound_ent stoploopsound(.05);
			wait 0.05;
		}

		wait 0.05;
	}
}

//Kevin's audio functions
audio_ent_fakelink( ent )
{
	level.player endon("death");
	self endon ("death");
	
	while(1)
	{
		ent moveto( self.origin, .1 );
		ent waittill("movedone");
	}
}

audio_ent_fakelink_delete(chopper)
{
	chopper waittill( "death" );
	
	self delete();
}

huey_shoot_start()
{
	level.player endon("death");
	self endon("death");

	while(1)
	{
		vehicle_node_wait("huey_start_fire", "script_noteworthy");
		flag_set("huey_shoot");
		wait 0.05;
	}
}

huey_shoot_stop()
{
	level.player endon("death");
	self endon("death");

	while(1)
	{
		vehicle_node_wait("huey_stop_fire", "script_noteworthy");
		flag_clear("huey_shoot");
		wait 0.05;
	}
}

huey_switch_targets()
{
	level.player endon("death");
	self endon("death");

	while(1)
	{
		vehicle_node_wait("huey_switch_targets", "script_noteworthy");
		flag_set("huey_switch_targets");
		wait 0.05;
	}
}

threatbiasgroups()
{
	//SetIgnoreMeGroup("player", "anti_allies");
	//SetIgnoreMeGroup("player_allies", "anti_player");


	add_global_spawn_function( "axis", ::spawnfunc_setthreatbiasgroup );
	add_global_spawn_function( "allies", ::spawnfunc_setthreatbiasgroup );

	level.player setThreatBiasGroup( "player" );
	level.squad["woods"] setThreatBiasGroup( "player_allies" );
	level.squad["hudson"] setThreatBiasGroup( "player_allies" );

	//This is the base threat of group1 against group2, which translates to how much entities in group2 will favor entities in group1.
	SetThreatBias("player", "anti_player", 1000);
	SetThreatBias("player_allies", "anti_allies", 1000);
	SetThreatBias("player", "anti_allies", 500);//-8000
	SetThreatBias("player_allies", "anti_player", 500);
}

spawnfunc_setthreatbiasgroup()
{
	if(IsDefined(self.script_noteworthy) && 
		(self.script_noteworthy == "anti_player" || self.script_noteworthy == "anti_allies" || self.script_noteworthy == "player_allies")
		)
	{
		self setThreatBiasGroup( self.script_noteworthy );

		if(self.script_noteworthy == "anti_player" || self.script_noteworthy == "anti_allies")
		{
			self.script_accuracy = 0.40;
		}

	}
}

event4b_woods_jam()
{
	//origins in same location in radiant FYI
	align_node_player = GetEnt("align_woods_jam_player", "targetname");
	align_node = GetEnt("align_woods_jam", "targetname");

	//trigger_wait("trig_woods_jam");
	flag_wait("trig_woods_jam_flag");

	level.player SetClientDvar("compass", 0);
	level.player SetClientDvar("cg_drawfriendlynames", 0);

	//turn ON ambient effects Uphill areas to entrance of destroyed bunker
	//Exploder(42);

	autosave_by_name("woods_jam_save");

	level.squad["woods"] anim_single(level.squad["woods"], "keep_pushin");//Keep pushin'!

	level thread woods_jam_heli();

	spawn_manager_kill("e4b_line_c_sm");

	level clear_ai_slop();

	level thread event4b_transition_event5();

	//bunker tunnel mouth explosion
	Earthquake(0.6, 2, level.player.origin, 200, level.player);
	level thread custom_rumble(0.02, 20);
	//Exploder(480);
	
	//Notify Client for snapshot
	level clientNotify("wds_scene");
	
	//TUEY Setmusic state to PLAYER SHOCKED
	setmusicstate ("PLAYER_SHOCKED");

	wait 0.5;

	//move allies up
	trigger_use("e4b_allies_take_hill");

	level.player magic_bullet_shield();

	//actors waiting 
	level thread event4b_hilltop_melee(align_node);
	level thread event4b_hilltop_woods(align_node);

	//level.player DisableWeaponCycling();
	level.player thread take_and_giveback_weapons("giveback");
	level.player DisableWeapons();
	level.player HideViewModel();

	player = spawn_anim_model("player_body", level.player.origin, level.player.angles);
	player.animname = "player_body";
	player Hide();

	//depth of field
	level.player maps\createart\khe_sanh_art::woods_jam_dof();

	level thread maps\_shellshock::main(level.player.origin, 13, 256, 0, 0, 0, undefined, "khe_sanh_woods", 0); 
	align_node_player thread anim_single_aligned(player, "player_gun_jam");

	wait 0.05;
	player Show();
	level.player StartCameraTween(0.2);
	level.player PlayerLinkToAbsolute(player, "tag_player");

	flag_wait("hilltop_window_start");

	player Hide();
	level.player SetMoveSpeedScale( 0.2 );
	level.player AllowPickupWeapons(false);
	level.player GiveWeapon( "python_sp" );
	level.player SwitchToWeapon( "python_sp" );
	level.player EnableWeapons();
	level.player ShowViewModel();

	level.player StartCameraTween( 1 );	
	level.player SetStance("crouch");
	level.player AllowJump(false);
	level.player AllowProne(false);
	level.player AllowStand(false);
	level.player AllowSprint(false);
	
	origin = player GetTagOrigin("tag_player");
	level.player Unlink();
	level.player SetOrigin(origin);//level.player.origin + (0,0,50));
	//level.player PlayerLinkToDelta(player, "tag_player");
	angles = VectorToAngles(level.squad["woods"].origin - level.player.origin);
	level.player SetPlayerAngles( angles );

	flag_wait("player_jam_window_end");
	//align_node notify("end_gun_jam");
	//level.player Unlink();
	player Delete();

	//ORIGIN HACK SINCE PLAYER FALLS THROUGH WORLD. FIX LOOP
	//level.player SetOrigin(level.player.origin + (0,0,25));

	level.player SetMoveSpeedScale( 1.0 );
	level.player TakeWeapon( "python_sp" );
	level.player notify("giveback");
	level.player EnableWeaponCycling();
	level.player AllowPickupWeapons(true);
	level.player stop_magic_bullet_shield();

	level.player AllowJump(true);
	level.player AllowProne(true);
	level.player AllowStand(true);
	level.player AllowSprint(true);
	level.player SetStance("stand");

	level.player SetClientDvar("compass", 1);
	level.player SetClientDvar("cg_drawfriendlynames", 1);

	align_node_player Delete();

	level notify("jam_done");
	flag_set("obj_retake_the_hill_complete");
	
	level clientNotify ("dflt");
}

event4b_hilltop_woods(align)
{
	actors = [];
	marine_vic = simple_spawn_single("woods_jam_redshirt");
	actors[0] = simple_spawn_single("woods_jam_nva");
	actors[1] = level.squad["woods"];

	marine_vic.animname = "gun_jam_marine";
	marine_vic magic_bullet_shield();
	marine_vic.ignoreme = true;
	
	actors[0].animname = "gun_jam_nva";
	actors[0].ignoreme = true;
	actors[0] magic_bullet_shield();
	//actors[0].allowdeath = true;
	if( is_mature() && !is_gib_restricted_build() )
	{
		actors[0].force_gib = true; 
		actors[0].custom_gib_refs = [];
		actors[0].custom_gib_refs[0] = "head";
		actors[0].custom_gib_refs[1] = "right_arm";
		actors[0].custom_gib_refs[2] = "left_arm";
	}
	actors[0] disable_long_death();
	actors[0].script_nodropweapon = true;
	actors[0] thread woods_jam_nva_watcher(align);
	
	actors[1].animname = "woods";

	flag_wait("hilltop_melee_start");

	level thread timescale_hilltop();
	
	//turn off bullet shield for marine
	marine_vic stop_magic_bullet_shield();
	
	//marine
	//align thread anim_single_aligned(marine_vic, "gun_jam_start");
	////nva
	//align thread anim_single_aligned(actors[0], "gun_jam_start");
	////woods - he plays the full duration of the anim so we wait on him
	

	level thread run_scene("e4_gun_jam_npc");
	//iprintln("npc_start");
	run_scene("e4_gun_jam_woods");
	//iprintln("wood_animation_finish");

//	align anim_single_aligned(actors[1], "gun_jam_start");
	
	
	actors[0] stop_magic_bullet_shield();
	
	if(flag("woods_jam_hit"))
	{
		//return dof to normal
		level.player maps\_art::setdefaultdepthoffield();
		//align anim_single_aligned(actors[1], "gun_jam_success");
		run_scene("e4_gun_jam_success");
		flag_set("player_jam_window_end");
	}
	else
	{
		actors[0] notify("no_damage");
		actors[0].allowdeath = false;
		actors[1] stop_magic_bullet_shield();
		//align thread anim_single_aligned(actors, "gun_jam_fail");
		level thread run_scene("e4_gun_jam_fail");
		wait 0.5;
		missionFailedWrapper(&"KHE_SANH_WOODS_JAM_FAIL");
	}
}

woods_jam_nva_watcher(align_node)
{
	self endon("no_damage");
	level endon("player_jam_window_end");

	while(1)
	{
		self magic_bullet_shield();

		flag_wait("hilltop_window_start");
		
		self stop_magic_bullet_shield();	
		
		self waittill( "damage", damage, attacker);

		if(attacker == level.player)
		{
			if(is_mature())
			{
				//self bloody_death(true);
				self bloody_death( "body" );
			}

			self gun_remove();
			self StartRagdoll( 1 );
			self LaunchRagdoll( ( 0, 30, 0), "J_Spine4" );
			//self StopAnimScripted();
			//align_node thread anim_single_aligned(self, "gun_jam_success");
			break;
		}

		wait 0.05;
	}


	flag_set("woods_jam_hit");
}

//heli flyover
woods_jam_heli()
{
	wait 0.5;
	
	jam_heli = [];

	for(i = 0; i < 4; i++)
	{
		activate_trigger_with_targetname("trig_jam_heli_" + i);
	}

	wait 0.05;

	for(i = 0; i < 4; i++)
	{
		//stagger the flight
		if(i == 1)
		{
			wait 6;
		}

		if(i == 3)
		{
			wait 4;
		}

		jam_heli[i] = GetEnt("jam_heli_" +i, "targetname");
		jam_heli[i].path = GetVehicleNode("node_jam_heli_" +i, "targetname"); 
		jam_heli[i] thread go_path(jam_heli[i].path);
		jam_heli[i] thread cleanup_vehicle();
		jam_heli[i] SetForceNoCull();

		if(i == 1 || i == 3)
		{
			jam_heli[i] thread shoot_side_guns();

		}
	}
}

//self is a huey: fires left and right guns downward
shoot_side_guns()
{
	self endon("death");

	self SetGunnerTurretOnTargetRange(0, 20);//right
	self SetGunnerTurretOnTargetRange(1, 20);//left

	while(1)
	{
		target_right = self.origin + AnglesToRight(self.angles) * 200;
		target_left = self.origin + AnglesToRight(self.angles) * (200 * -1);

		if(RandomIntRange(0, 10) > 3)
		{
			self SetGunnerTargetVec( target_right + (RandomIntRange(15, 45), 0, -500), 0 );
			self FireGunnerWeapon( 0 );
			wait 0.3;
		}

		if(RandomIntRange(0, 10) > 2)
		{
			self SetGunnerTargetVec( target_left + (RandomIntRange(15, 45), 0, -500), 1 );
			self FireGunnerWeapon( 1 );
			wait 0.2;
		}

		wait 0.05;
	}
}

timescale_hilltop()
{
	level.nva_qte_timescale = 1.0;
	timescale_vel = -1.0;

	wait 7.2;

	while(level.nva_qte_timescale > 0.4)
	{
		level.nva_qte_timescale += timescale_vel * 0.05;
		SetTimeScale(level.nva_qte_timescale);
		wait(0.05);
	}

	//wait 1;
	//flag_wait("woods_jam_hit");
	flag_wait("hilltop_window_start");

	wait 0.25;

	while(level.nva_qte_timescale < 1.0)
	{
		level.nva_qte_timescale += 2.0 * 0.05;
		SetTimeScale(level.nva_qte_timescale);
		wait(0.05);
	}
}

event4b_hilltop_melee(align)
{
	melee_align = [];
	marines = [];
	nva = [];
	actors["melee_0"] = [];
	actors["melee_1"] = [];
	actors["melee_2"] = [];


	flag_wait("hilltop_melee_start");

	for(i = 0; i < 3; i++)
	{
		melee_align[i] = GetEnt("align_hilltop_melee_" +i, "targetname");

		if(i == 0 || i == 1)
		{
			marines[i] = simple_spawn_single("marine_melee_" +i);
			marines[i] magic_bullet_shield();
			marines[i].ignoreme = true;
			marines[i].animname = "h2h_guy_01";
		}

		nva[i] = simple_spawn_single("nva_melee_" +i);
		nva[i].animname = "h2h_guy_02";
		//nva[i] magic_bullet_shield();
		nva[i].ignoreme = true;
		
	}

	actors["melee_0"] = array_add(actors["melee_0"], marines[0]);
	actors["melee_0"] = array_add(actors["melee_0"], nva[0]);

	actors["melee_1"] = array_add(actors["melee_1"], marines[1]);
	actors["melee_1"] = array_add(actors["melee_1"], nva[1]);

	actors["melee_2"] = array_add(actors["melee_2"], level.squad["hudson"]);
	actors["melee_2"] = array_add(actors["melee_2"], nva[2]);

	marines[0] thread redshirt_follow_hudson();
	
	level thread melee_vignette(align, actors["melee_0"], "hilltop_h2h_a");
	level thread melee_vignette(align, actors["melee_1"], "hilltop_h2h_b");
	level thread melee_vignette(align, actors["melee_2"], "hilltop_h2h_c");

/*
	melee_align[0] thread anim_single_aligned(actors["melee_0"], "hand2hand_a");
	melee_align[1] thread anim_single_aligned(actors["melee_1"], "hand2hand_b");
	melee_align[2] thread anim_single_aligned(actors["melee_2"], "hand2hand_c");
*/

	//flag_wait("obj_retake_the_hill_complete");
	level waittill("jam_done");

	for(i = 0; i < 3; i++)
	{
		if(IsDefined(marines[i]))
		{
			marines[i] stop_magic_bullet_shield();	
			marines[i].ignoreme = false;
		}
		
		if(IsDefined(nva[i]))
		{
			nva[i] stop_magic_bullet_shield();
			nva[i].ignoreme = false;
		}
	}

	trigger_wait("e4b_trans_to_event5");

	melee_align = array_combine(melee_align, marines);
	melee_align = array_combine(melee_align, nva);

	for(i = 0; i < 3; i++)
	{
		if(IsDefined(melee_align[i]))
		{
			melee_align[i] Delete();
		}
	}
}

redshirt_follow_hudson()
{
	self endon("death");
	self SetGoalNode(GetNode("node_rubble_end", "targetname"));
	self waittill("goal");
	self Delete();
}

melee_vignette(node, actor_array, scene)
{
	//node anim_reach_aligned(actor_array, scene);
	node thread anim_single_aligned(actor_array, scene);
}

clear_ai_slop()
{
	ally_cleanup = GetAIArray("allies");
	nva_cleanup = GetAIArray("axis");

	ally_cleanup = array_removeUndefined( ally_cleanup );
	
	if(IsDefined(nva_cleanup) && nva_cleanup.size > 0)
	{
		nva_cleanup = array_removeUndefined( nva_cleanup );
		array_delete(nva_cleanup);
	}

	for(i = 0; i < ally_cleanup.size; i++)
	{
		if(IsDefined(ally_cleanup[i]))
		{
			ally_cleanup[i] StopAnimScripted();	//if this was a vignette marine
			if(IsDefined(ally_cleanup[i].script_noteworthy) 
				&& ally_cleanup[i].script_noteworthy != "hero_squad" && ally_cleanup[i].script_noteworthy != "dont_delete")
			{
				ally_cleanup[i] Delete();
			}
			else if(IsDefined(ally_cleanup[i].script_noteworthy) && ally_cleanup[i].script_noteworthy == "player_allies")
			{
				ally_cleanup[i] Delete();
			}
			else if(!IsDefined(ally_cleanup[i].script_noteworthy))
			{
				ally_cleanup[i] Delete();
			}
		}
	}
}

#using_animtree( "generic_human" );
event4b_transition_event5()
{
	level.e4b_bunker_ents = [];

	align_nodes =[];
	//align_node = GetEnt("align_destroy_rescue_0", "targetname");
	for(i = 0; i < 3; i++)
	{
		align_nodes[i] = GetEnt("align_destroy_rescue_" +i, "targetname");
		
		//add to cleanup array
		level.e4b_bunker_ents[i] = align_nodes[i];
	}
	
	trigger_wait("e4b_trans_to_event5");

	//turn OFF ambient effects Uphill areas to entrance of destroyed bunker
	//stop_exploder(41);

	level thread e4b_e5_prevent_backtrack();
	level thread e4c_enter_bunker_radio();

	flag_set("enter_bunker");

	//setup player and allies 
	level.squad["woods"] change_movemode("cqb_sprint");
	level.squad["hudson"] change_movemode("cqb_sprint");

	//TODO SLOW CQB HEROES

	//player settings //cleared in e5 intro
	weapon = level.player GetCurrentWeapon();
	level.player GiveStartAmmo( weapon );
	//level.player player_force_walk(true);

	//vigneete of guy freeing himself
	level thread solo_rubble_vignette(align_nodes[1]);
	level thread coughing_guy(align_nodes[2]);
	level thread bunker_collapse();

	marine_rubble= [];
	marine_rubble[0] = spawn_fake_character(align_nodes[0].origin, align_nodes[0].angles, "medic");
	marine_rubble[1] = spawn_fake_character(align_nodes[0].origin, align_nodes[0].angles, "wounded_torso");
	marine_rubble[0].animname = "buddy_rubble_0";
	marine_rubble[1].animname = "buddy_rubble_1";
	marine_rubble[0] UseAnimTree(#animtree);
	marine_rubble[1] UseAnimTree(#animtree);
	
	//marine rubble props
	marine_rubble[2] = spawn_anim_model("plank_01", align_nodes[0].origin, align_nodes[0].angles, true);
	marine_rubble[3] = spawn_anim_model("plank_02", align_nodes[0].origin, align_nodes[0].angles, true);
	marine_rubble[4] = spawn_anim_model("crate", align_nodes[0].origin, align_nodes[0].angles, true);

	wait 1;

	for(i = 0; i < marine_rubble.size; i++)
	{
		align_nodes[0] thread anim_single_aligned(marine_rubble[i], "e5_rubble_start");
	}

	align_nodes[0] waittill("e5_rubble_start");		

	for(i = 0; i < marine_rubble.size; i++)
	{
		align_nodes[0] thread anim_loop_aligned(marine_rubble[i], "e5_rubble_loop");
	}

	//add to cleanup array
	level.e4b_bunker_ents = array_combine( level.e4b_bunker_ents , marine_rubble );

	//level waittill("solo_rubble_deleted");
	//array_delete(marine_rubble);
	//array_delete(align_nodes);
	//align_node Delete();
}

e4c_enter_bunker_radio()
{
	radio = GetEnt("e5_enter_radio", "targetname");
	radio.animname = "post_jam_radio";

	radio anim_single(radio, "line_0");//Do not. Repeat. Do not engage.
	wait 0.15;
	radio anim_single(radio, "line_1");//Fire. Put it right there.
	radio anim_single(radio, "line_2");//I'm comin' around again, stay with me.
	wait 0.25;
	radio anim_single(radio, "line_3");//Belay that order. Get your ass out of there.
	
	wait 0.25;
	radio anim_single(radio, "line_4");//Arc Light establishing orbit, please stand by.
}

//collapsing beam anim
bunker_collapse()
{
	trigger_wait("lookat_rubble");
	level notify("bunker01_start");
	player = get_players()[0];
	player playsound( "exp_mortar_dirt" );
	Earthquake(0.65, 2, level.player.origin, 200, level.player);
	level thread custom_rumble(0.02, 15);

	trigger = GetEnt("lookat_rubble", "targetname");
	trigger Delete();
}

//marine frees himself
solo_rubble_vignette(align)
{
	solo_rubble = [];
	//prep dude
	solo_rumble_spawner = GetEnt("solo_rubble", "targetname");
	solo_rubble[0] = simple_spawn_single(solo_rumble_spawner);
	solo_rubble[0].animname = "solo_rubble";
	solo_rubble[0].goalradius = 64;
	solo_rubble[0].script_noteworthy = "dont_delete";
	solo_rubble[0] magic_bullet_shield();

	//props
	solo_rubble[1] = spawn_anim_model("wood_plank_large_0", solo_rubble[0].origin, solo_rubble[0].angles, true);
	solo_rubble[2] = spawn_anim_model("wood_plank_large_1", solo_rubble[0].origin, solo_rubble[0].angles, true);
	solo_rubble[3] = spawn_anim_model("wood_plank_small_0", solo_rubble[0].origin, solo_rubble[0].angles, true);
	solo_rubble[4] = spawn_anim_model("wood_plank_small_1", solo_rubble[0].origin, solo_rubble[0].angles, true);

	//add to cleanup array
	level.e4b_bunker_ents = array_combine(level.e4b_bunker_ents, solo_rubble);
	level.e4b_bunker_ents = array_add(level.e4b_bunker_ents, solo_rumble_spawner);

	wait 0.05;

	/#
//	SetDvar( "g_dumpAnims", solo_rubble[1] GetEntNum() );
	#/

	//reuse our cool sprints that we are paying for
	x = RandomIntRange(1, 9);
	solo_rubble[0] set_generic_run_anim("sprint_" + x);
	
	//loop of dude being trapped. Free's himself when player gets near
	//align thread anim_loop_aligned(solo_rubble, "rubble_dude_loop", undefined, "end_solo_loop");
	for( i = 0; i < solo_rubble.size; i++ )
	{
		align thread anim_loop_aligned( solo_rubble[i], "rubble_dude_loop"); //undefined, "end_solo_loop" );
	}

	//wait for player
	trigger = GetEnt("trig_solo_rubble", "targetname");
	trigger waittill("trigger");

	//clean up allies again that were standing out of the tunnel mouth
	spawn_manager_kill("e4b_redshirt_sm");

	//align notify("end_solo_loop");
	wait 0.05;
	level clear_ai_slop();

	for( i = 0; i < solo_rubble.size; i++ )
	{
		align thread anim_single_aligned(solo_rubble[i], "rubble_dude");
	}

	//clean up trig and spawner
	trigger Delete();

	node = GetNode("node_rubble_end", "targetname");
	solo_rubble[0] SetGoalNode(node);
	//solo_rubble[0] waittill("goal");

	//level notify("solo_rubble_deleted");

	//delete AI
	//solo_rubble[0] Delete();
	//array_delete(solo_rubble);
	//solo_rumble_spawner Delete();
}

#using_animtree( "generic_human" );
coughing_guy(align)
{
	angles = VectorToAngles(level.squad["woods"].origin - align.origin);
	cougher = spawn_fake_character(align.origin, angles, "driver");
	cougher.animname = "marine_cough";
	cougher UseAnimTree(#animtree);

	cougher.my_weapon = GetWeaponModel( "m16_sp" );
	cougher Attach(cougher.my_weapon, "tag_weapon_right");
	cougher UseWeaponHideTags("m16_sp");

	//add to clean up array
	level.e4b_bunker_ents = array_add(level.e4b_bunker_ents, cougher);

	//PlayFXOnTag(level._effect["fx_ks_smk_cough"], cougher, "J_head");

	align thread anim_loop(cougher, "coughing");

	//level waittill("solo_rubble_deleted");
	//cougher Delete();
}

event4b_backtrack_blocker()
{
	level.player endon("death");
	level endon("enter_bunker");

	timer = 0;

	trigger = GetEnt("e4b_backtrack_trig", "targetname");
	structs = getstructarray("structs_e4_mortars", "targetname");

	//level thread ambient_mortar_explosion("struct_e4_mortar_", "structs_e4_mortars", 6, 1.15);

	while(1)
	{
		if(timer >= 5 )
		{
			timer = 0;
			level.player thread maps\_mortar::activate_mortar(256, 1, 0, 0.55, 2.0, 512, true, level._effect["e4_trans_mortar"], false); 
			wait 0.25;
			level.player khe_sanh_die();
			//level.player DoDamage( (level.player.health * 10), level.player.origin, level.player );
		}

		if(level.player IsTouching(trigger))
		{
			hit = random(structs);
			hit thread maps\_mortar::activate_mortar(256, 1, 0, 0.55, 2.0, 512, true, level._effect["e4_trans_mortar"], false); 
			
			wait 1;
			timer++;
		}

		wait 0.05;
	}
}

event4_cleanup_firetrig()
{
	//cleanup fire structs
	fire_struct = getstructarray("flame_point", "script_noteworthy");
	if(fire_struct.size > 0)
	{
		for(i = 0; i < fire_struct.size; i++)
		{
			fire_struct[i] notify("turn_off_fire_struct");
			remove_drone_struct(fire_struct[i]);
		}
	}
	
	if(IsDefined(level.fire_trig))
	{
		level.fire_trig = array_removeUndefined( level.fire_trig );
		array_delete(level.fire_trig);
	}

	//cleanup fire exploders from downhill
	//stop_exploder(420);//napalm drop
	//stop_exploder(440);//trench a
	//stop_exploder(460);//trench b
}

set_rocketguy_ammo()
{
	if(IsDefined(self.script_string) && self.script_string == "line_b_rocket")
	{
		self.a.rockets = 1000;
	}
}

//these are tree bursts effects i time them with mortar explosions
//also sets up custom damage state trees
event4b_tree_fx()
{
	level endon("obj_retake_the_hill_complete");

	//get damage trees
	level thread manage_tree_damage_state();

	while(1)
	{
		level waittill("mortar");

		if(!flag("e4b_line_a_taken"))
		{
			//Exploder(470);
		}

		if(!flag("e4b_line_b_taken") && flag("e4b_line_a_taken"))
		{
			//Exploder(471);
			x = RandomIntRange(0, 10);
			if(x < 3)
			{
				//Exploder(472);
			}
		}


		if(!flag("hilltop_melee_start") && flag("e4b_line_a_taken") && flag("e4b_line_b_taken"))
		{
			//Exploder(473);
		}

		if(flag("e4b_line_a_taken") && flag("e4b_line_b_taken")
			&& flag("hilltop_melee_start"))
		{
			break;
		}


		wait 0.05;
	}

}

manage_tree_damage_state()
{
	pristine = [];
	blown = [];

	for(i = 0; i < 3; i++)
	{
		pristine[i] = GetEnt("e4b_tree_" +i, "targetname");
		blown[i] = GetEnt("e4b_dead_tree_" +i, "targetname");

		blown[i] Hide();
	}

	blown[0] thread tree_kaboom(pristine[0], 0);
	
	flag_wait("e4b_line_a_taken");
	blown[1] thread tree_kaboom(pristine[1], 1);
	
	flag_wait("e4b_line_b_taken");
	blown[2] thread tree_kaboom(pristine[2], 2);
}

//self is blown version of tree
tree_kaboom(pristine, index)
{
	level endon("obj_retake_the_hill_complete");
	/#
	Debugstar(self.origin, 10000, (0,0,1));
	#/
	level.player waittill_player_looking_at( self.origin, 0.95, false );

	self Show();
	switch(index)
	{
	case 0:
		//Exploder(475);
		break;
	case 1:
		//Exploder(476);
		break;
	case 2:
		//Exploder(477);
		break;
	}
	
	pristine Delete();
}

#using_animtree( "generic_human" );
event4b_death_loops()
{
	align = [];
	actors = [];
	for(i = 0; i < 2; i++)
	{
		align[i] = GetEnt("align_dead_" +i, "targetname");
	}

	actors[0] = spawn_fake_character(align[0].origin + (0, 0, -60), align[0].angles, "wounded_torso"); //death b
	actors[1] = spawn_fake_character(align[1].origin + (0, 0, -60), align[1].angles, "wounded_knee");//death a

	for(i = 0; i < 2; i++)
	{
		actors[i] setlookattext("", &"");
		actors[i].animname = "dead_guy_" + i; 
		actors[i] UseAnimTree(#animtree);
		align[i] thread anim_loop_aligned(actors[i], "death_" +i);

	}

	trigger_wait("trig_woods_jam");

	for(i = 0; i < 2; i++)
	{
		actors[i] Delete();
		align[i] Delete();
	}
}

e4b_e5_prevent_backtrack()
{
	level endon("player_on_jeep");
	trigger = GetEnt("trig_woods_jam", "targetname");
	timer = 0;

	while(1)
	{
		if(timer > 1.25)
		{
			timer = 0;
			level.player thread maps\_mortar::activate_mortar(256, 1, 0, 0.55, 2.0, 512, true, level._effect["e4_trans_mortar"], false); 
			level waittill("mortar_inc_done");
			level thread maps\_shellshock::main(level.player.origin, 5, 256, 0, 0, 0, undefined, "default", 0); 
			level.player khe_sanh_die();
		}

		if(level.player IsTouching(trigger))
		{
			timer += 0.05;
		}

		wait 0.05;
	}

}
