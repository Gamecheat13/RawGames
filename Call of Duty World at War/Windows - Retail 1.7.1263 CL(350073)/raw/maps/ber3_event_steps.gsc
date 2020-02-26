// FALLING COLUMN TARGETNAME:  sb_model_column_collapse

#include common_scripts\utility;
#include maps\_utility;
#include maps\ber3;
#include maps\_anim;
#include maps\ber3_util;
#include maps\_music;
#include maps\_busing;



// -- STARTS --
// start at the very beginning of the intro
event_reich_start()
{		
	warp_players_underworld();
	warp_friendlies( "struct_reich_start_friends", "targetname" );
	warp_players( "struct_reich_start", "targetname" );

	// set up the spawners for the level
	thread simple_spawners_level_init();
	
	// set up some of the drone triggers
	thread maps\ber3_event_intro::e1_drones();	
	
	getent("e3_respawn_trigger", "script_noteworthy") notify("trigger");
	
	level thread e3_init_event();
	level thread e3_objectives();
	level thread maps\ber3_event_intro::add_flag_to_chernov();
}
// -- END STARTS --



e3_init_event()
{
	level.ready_to_count_deaths = false;
	
	thread e3_spawn_axis_controller();	
	thread e3_init_bunker_friendlies();
//	thread e3_fake_throw_molotov();
	thread e3_panzer_guys_setup();
	
	pillarClip = getent("e3_pillar_clip", "targetname");
	pillarclip connectpaths();
	pillarclip trigger_off();
}

e3_objectives()
{
	wait(2);
	
	level.ready_to_count_deaths = true;
	
	// Objective:  Storm the Reichstag
	obj_struct = getstruct( "obj_storm_stag", "targetname" );
	objective_add( 4, "current", &"BER3_OBJ4", obj_struct.origin );
	
	getent("e3_trig_end_mission", "targetname") waittill ("trigger");
	objective_state( 4, "done");
	
	nextmission();		//TEMP:  end the mission here
}



send_friendlies_to_end()
{
	getent("e3_friendlies_to_end", "targetname") notify("trigger");
	
	sargeNode = getnode("e3_sarge_node", "targetname");
	level.sarge setgoalnode(sargeNode);
	
	level waittill("say_final_vo");
	
	//wait(1);
	
	level.sarge anim_single_solo( level.sarge, "e3_rez_02" ); 	// "Move inside."
	
	wait(.5);
	
	level.sarge anim_single_solo( level.sarge, "out_rez_01" ); 	// "This is what you came here for!"
	level.sarge anim_single_solo( level.sarge, "out_rez_02" ); 	// "Kill them all!"
	level.sarge anim_single_solo( level.sarge, "out_rez_04" ); 	// "Pound them into the dust!"
}



e3_panzer_guys_setup()
{
	guys = getentarray("e3_panzerguy", "script_noteworthy");
	
	array_thread( guys, ::add_spawn_function, ::e3_panzer_set_threatgroup );
}


e3_panzer_set_threatgroup()
{
	self setthreatbiasgroup("panzer_group");
}

//////////////////////////////////////////////////////////////////////////////////////////////////////////
////	Axis Spawning Stuffs
//////////////////////////////////////////////////////////////////////////////////////////////////////////

e3_spawn_axis_controller()
{
	getent("e3_begin_spawning", "script_noteworthy") waittill("trigger");
	
	// Change reznov to blue to follow you up the stairs correctly
	level.sarge set_force_color("b");
	
	// allow paths to connect on the models that get deleted
	// Destroy the barricades
	dest_barricades = getentarray("reich_steps_blocker", "targetname");
	
	for(i = 0; i < dest_barricades.size; i++)
	{
		dest_barricades[i] connectpaths();
	}		
	
	// Get all the appropriate triggers for this event
	trig_axis_group1 = getent("e3_axis_group1", "script_noteworthy");						// Group 1
	trig_axis_group2 = getent("e3_axis_group2", "script_noteworthy");						// Group 2
	trig_axis_group3 = getent("e3_axis_group3", "script_noteworthy");						// Group 3
	
	// Begin watching the death counts for each group
	level.spawner_notifies = [];
	level.spawner_num = 0;
	level.group1_deaths = 0;
	level.group2_deaths = 0;
	level.group3_deaths = 0;
	level.playerkill = 0;			// a counter to make sure the player kills their fair share of enemies
	
	level.ready_to_spawn_group2 = false;
	thread wait_to_spawn_group2();
	
	level.ready_to_spawn_group3 = false;
	
	// which group to count at the moment
	level.current_watch_group = 1;
	
	thread watch_group_deaths();
	thread spawner_notify_manager();
	
	thread e3_spawn_group(trig_axis_group1, 1);			// spawn the first group
	level waittill( "finished spawning group 1" );
	
	// wait for the next trigger to be hit
	while( !level.ready_to_spawn_group2 )
	{
		wait(.2);
	}
	
	wait(1.0);																			// Let the network calm a bit..
	thread e3_spawn_group(trig_axis_group2, 2);			// spawn the second group now as well
	
	while( !level.ready_to_spawn_group3 )
	{
		wait(.2);
	}
	
	autosave_by_name( "ber3_steps_checkpoint" );
	
	//level waittill("stop stair group 1");						// wait for the first group to be done spawning
	wait(1.0);																			// Let the network calm a bit..
	thread e3_spawn_group(trig_axis_group3, 3);
}



wait_to_spawn_group2()
{
	getent("e3_start_script_movement", "targetname") waittill("trigger");
	level.ready_to_spawn_group2 = true;
}



spawner_notify_manager()
{
	level endon("stop stair group 3");	
	
	while(true)
	{
		wait(.1);
		
		// allow two AI to spawn
		for(i = 0; i < 2; i++)
		{
			if( isdefined( level.spawner_notifies[0] ) )
			{
				spNotify = level.spawner_notifies[0];
				level notify( spNotify );
				
				level.spawner_notifies = array_remove( level.spawner_notifies, spNotify );
			}
		}
	}
}



// Takes a trigger and threads the spawning function on each of it's targets
e3_spawn_group(trig_spawner, whichGroup)
{
	spawners = getentarray( trig_spawner.target, "targetname" );
	
	for(i = 0; i < spawners.size; i++)
	{
		if( !OkToSpawn() )
		{
			wait_network_frame();
		}
		
		spawners[i] thread e3_stairs_spawner(whichGroup);
		wait_network_frame();
	}
	level notify( "finished spawning group " + whichGroup );
}



// Controls the individual spawner, to keep count up and to stop when needed
e3_stairs_spawner(whichGroup)
{
	level endon("stop stair group " + whichGroup);
	
	spawnerNum = level.spawner_num;
	level.spawner_num++;
	
	// Keeps a tally of deaths for the group this AI belongs to
	self add_spawn_function( ::e3_count_axis_deaths, whichGroup );
	
	while(true)
	{
		level.spawner_notifies[level.spawner_notifies.size] = "e3 spawn guy " + spawnerNum;
		
		level waittill( "e3 spawn guy " + spawnerNum );
		
		//wait for a snapshot after spawning every 2 guys
		while( !OkToSpawn() )
		{
			wait_network_frame();
		}
		
		// Keep the count above 0 until the spawner is turned off
		if( isdefined(self) && self.count <= 0)
		{
			self.count = 1;
		}
		
		// Spawn the AI
		ai = self StalingradSpawn(); 
		
		spawn_failed( ai );	
		
		if( isdefined(ai) )
		{
			ai waittill("death");
		}
		
		wait(.25);
	}
}

e3_count_axis_deaths(whichGroup)
{
	self waittill("death");
	
	// add to the correct group's death count
	switch( whichGroup )
	{
		case 1:
			if(level.current_watch_group == 1)
			{
				if( isdefined(self.attacker) && isai(self.attacker) )
				{
					level.group1_deaths++;
				}				
				else if( isdefined(self.attacker) && isplayer(self.attacker) )
				{
					level.group1_deaths++;
					level.playerkill++;
				}				
			}
			break;
		
		case 2:
			if(level.current_watch_group == 2)
			{
				if( isdefined(self.attacker) && isai(self.attacker) )
				{				
					level.group2_deaths++;		
				}		
				else if( isdefined(self.attacker) && isplayer(self.attacker) )
				{
					level.group2_deaths++;
					level.playerkill++;
				}					
				
			}
			break;
		
		case 3:
			if(level.current_watch_group == 3)
			{
				if( isdefined(self.attacker) && isai(self.attacker) )
				{				
					level.group3_deaths++;	
				}			
				else if( isdefined(self.attacker) && isplayer(self.attacker) )
				{
					level.group3_deaths++;	
					level.playerkill++;
				}	
			}
			break;		
		
		default:
			return;
	}	
}

watch_group_deaths()
{
	while( !level.ready_to_count_deaths )
	{
		wait(1);
	}
	
	level.sarge thread anim_single_solo(level.sarge, "stairs_rez_01");				// "Push them back!"
	
	// Figure out the kills needed to be made to advance the AI, based on the number of players
	players = get_players();
	
	group12_death_min = 5 + (players.size * 5);
	group12_pkill_min = (group12_death_min * 0.5);		// Players must kill 1/2 of the enemies
	group3_death_min = 2 + (players.size * 1);
	group3_pkill_min = (group3_death_min * 0.5);			// Players must kill 1/2 of the enemies
	
	// get all the killspawner triggers
	trig_axis_group1_kill = getent("e3_axis_group1_kill", "script_noteworthy");	
	trig_axis_group2_kill = getent("e3_axis_group2_kill", "script_noteworthy");	
	
	while( level.group1_deaths < group12_death_min )
	{
		wait(.5);
	}
	
	while(level.playerkill < group12_pkill_min)
	{
		wait(.5);
	}

	level notify("stop stair group 1");				// turn off the spawners
	level.ready_to_spawn_group3 = true;
	level.current_watch_group = 2;						// update the watch group
	level.playerkill = 0;											// reset to 0 for next wave
	
	thread e3_friendlies_move_1();						// move guys up
	
	while(level.group2_deaths < group12_death_min) 
	{
		wait(.5);
	}
	
	while(level.playerkill < group12_pkill_min)
	{
		wait(.5);
	}
	
	level notify("stop stair group 2");				// turn off the spawners
	level.current_watch_group = 3;						// update the watch group
	level.playerkill = 0;											// reset to 0 for next wave
	
	thread e3_friendlies_move_2();						// move guys up
	
	while(level.group3_deaths < group3_death_min)
	{
		wait(.5);
	}
	
	while(level.playerkill < group3_pkill_min)
	{
		wait(.5);
	}
	
	level notify("stop stair group 3");				// turn off the spawners
	thread e3_outro_anim_start();
}



e3_friendlies_move_1()
{
	// move the friendlies forward
	trig = getent("e3_stairs_moveup1", "targetname");
	trig notify("trigger");
	
	// have reznov speak
	level.sarge anim_single_solo(level.sarge, "stairs_rez_02");				// "Move forward!"
}

e3_friendlies_move_2()
{
	// move the friendlies forward
	trig = getent("e3_stairs_moveup2", "targetname");
	trig notify("trigger");
	
	// have reznov speak
	level.sarge anim_single_solo(level.sarge, "stairs_rez_03");				// "Forward, men!"
}



e3_allies_storm_reich()
{
	thread spawn_outro_axis();
	spawner_trigs = getentarray("e3_finale_allies", "script_noteworthy");
	
	wait(13);
	
	
	// set spawn functions on all the spawners so we can get a loop of guys going
	for(i = 0; i < spawner_trigs.size; i++)
	{
		spawners = getentarray( spawner_trigs[i].target, "targetname" );
		array_thread( spawners, ::add_spawn_function, ::e3_reich_stormers_init );
		
		thread e3_spawn_group(spawner_trigs[i], 10);
		wait(.5);
	}
	
	allies = getaiarray( "allies" );
	
	for(i = 0; i < allies.size; i++)
	{
		allies[i].grenadeawareness = 0;
		
		if( IsDefined( allies[i].magic_bullet_shield ) && allies[i].magic_bullet_shield )
		{
			continue;
		}
		else
		{		
			allies[i] thread magic_bullet_shield();
		}
	}
	wait 15;
	//kevins notify for battle cry
	level notify("pwn_joyal");
}



e3_reich_stormers_init()
{
	self.ignoreall = true;
	self.ignoreme = true;
	self thread magic_bullet_shield();
	
	
	self waittill("goal");
	self thread stop_magic_bullet_shield();
	self thread bloody_death(true);
}



spawn_outro_axis()
{
	spawners = getentarray( "e3_outro_axis", "script_noteworthy" );
	array_thread( spawners, ::add_spawn_function, ::e3_reich_germans_init );
}

e3_reich_germans_init()
{
	self.grenadeawareness = 0;
	self thread magic_bullet_shield();
}

//////////////////////////////////////////////////////////////////////////////////////////////////////////
////	Outro Animation 
//////////////////////////////////////////////////////////////////////////////////////////////////////////
e3_outro_anim_start()
{
	player_ready = false;
	touch_trig = getent("trig_kill_chernov", "targetname");
	
	players = getplayers();
	
	level.sarge anim_single_solo(level.sarge, "stairs_rez_04");				// "Come with me!"
	
	// Wait for one of the players to move up the stairs
	while(!player_ready)
	{
		for( i = 0; i < players.size; i++ )
		{
			if( IsDefined( players[i] ) && players[i] IsTouching( touch_trig ) )
			{
				player_ready = true;
			}
		}	
		wait(.1);
	}
	
	thread kill_all_nazis();				// remove the enemies for now
	thread chernov_death_init();		// Start up chernov's death
	thread reich_pillar_fall();			// drop the pillar	
}



chernov_death_init()
{		
	level.sarge disable_ai_color();
	level.chernov disable_ai_color();
		
	// Set up the hero characters for the action
	level.sarge.ignoreme = 1;
	level.sarge.pacifist = 1;
	level.sarge.grenadeawareness = 0;
	level.chernov.ignoreme = 1;
	level.chernov.pacifist = 1;
	level.chernov.grenadeawareness = 0;
	
	// set up the flame thrower guy
	flameguy_spawner = getent("e3_flamer", "targetname");
	flameguy_spawner add_spawn_function( ::flameguy_init );
	
	// Play the animation
	thread e3_play_chernov_death_anim();
	thread e3_allies_storm_reich(); 
	
	level waittill("spawn flamethrower");
	wait(3);
	
	flameguy_spawner stalingradspawn();
}



e3_play_chernov_death_anim()
{
	level.chernov endon("death");
	
	// Safety check, make sure the animnames are correct
	level.sarge = getent("sarge", "script_noteworthy");
	level.sarge.animname = "reznov";
	level.sarge.ignoreall = true;
	level.chernov = getent("chernov", "script_noteworthy");
	level.chernov.animname = "chernov";
	
	reznode = getnode("node_outro_rez_start", "targetname");
	anode = getnode("ber3_column_collapse", "targetname");
	
	//anode anim_reach( guys, "chernov_in", undefined, anode );
	level.sarge setgoalnode( reznode );	// first, send reznov to his starting position
	level.sarge waittill("goal");
	
	// Fire the rockets at the pillar
	schreck1_start = getstruct("e3_pillar_rocket1_start", "targetname");
	schreck1_end = getstruct(schreck1_start.target, "targetname");
	schreck2_start = getstruct("e3_pillar_rocket2_start", "targetname");
	schreck2_end = getstruct(schreck2_start.target, "targetname");
	
	thread maps\ber3_event_intro::fire_shrecks(schreck1_start, schreck1_end, 1);
	wait(.5);
	thread maps\ber3_event_intro::fire_shrecks(schreck2_start, schreck2_end, 1);
	
	wait(1);
	
	//thread reznov_fire_at_fake_target();
	
	level notify("drop pillar");																						// give the ok to drop the pillar
	//anode anim_reach_solo( level.chernov, "chernov_in", undefined, anode);	// send chernov to his starting point
	
	wait(4);
	
	// Do zee animation!
	//thread flameguy_spawn();
	level notify("spawn flamethrower");
	
	level.chernov setmodel("char_rus_guard_grachev_burn");
	
	if( isdefined( level.cher_rus_flag ) )
	{
		level.cher_rus_flag delete();
	}
	
	//level.chernov Attach( "anim_berlin_rus_flag_rolled", "tag_inhand" );	
	thread give_chernov_outro_flag();	
	
	level thread chernov_remove_gun();
	anode anim_single_solo( level.chernov, "chernov_in" ); 
	anode  anim_loop_solo( level.chernov, "chernov_loop", undefined, "stop_chernov" );
	//anode thread anim_loop_solo( level.chernov, "chernov_death_loop", undefined, "stop chernov" );
	
	//thread allow_shoot_chernov();
	//anode anim_single_solo( level.chernov, "chernov_loop" );
	//anode  anim_single_solo( level.chernov, "chernov_death" );
	//anode thread anim_loop_solo( level.chernov, "chernov_death_loop", undefined, "stop chernov" );
}

chernov_remove_gun()
{
	level.chernov.ignoreall = true;
	level.chernov.ignoreme = true;
	wait( 0.1 );
	level.chernov animscripts\shared::PlaceWeaponOn( level.chernov.primaryweapon, "none");
}

give_chernov_outro_flag()
{
	cherFlag = spawn( "script_model", level.chernov.origin );
	cherFlag setmodel( "anim_berlin_rus_flag_rolled" );
	cherFlag linkto( level.chernov, "tag_inhand", (0, 0, 0), (0, 0, 0) );
	
	level waittill( "detach outro flag" );
	
	cherFlag unlink();
}

outro_flag_notify_unlink(guy)
{
	level notify( "detach outro flag" );
}

reznov_fire_at_fake_target()
{
	level.sarge.pacifist = 0;
	level.ignoreall = false;
	targ = getent("reznov_target", "targetname");
	level.sarge SetEntityTarget( targ );	
}

reznov_outro_anims(guy)
{	
	level.sarge StopShoot();	
	
	anode = getnode("ber3_column_collapse", "targetname");
	//anode anim_reach_solo( level.sarge, "chernov_in", undefined, anode);	
	anode anim_single_solo( level.sarge, "chernov_in" ); 
	thread send_friendlies_to_end();
	//anode anim_single_solo( level.sarge, "chernov_death" ); 
	
	level notify("say_final_vo");	
	
	//thread reznov_outro_speak();
	//anode anim_single_solo( level.sarge, "chernov_loop" );
	
//	if(!level.reznov_anims_finished)
//	{
//		reznov_outro_anims_finish();
//	}
}

reznov_outro_attach_book(guy)
{
	if( !has_diary() )
	{
		level.sarge Attach( "static_berlin_books_diary", "tag_inhand" );
	}
}

reznov_outro_detach_book(guy)
{
	if( has_diary() )
	{
		level.sarge detach( "static_berlin_books_diary", "tag_inhand" );
	}
}

has_diary()
{
	size = level.sarge GetAttachSize();
	for( i = 0; i < size; i++ )
	{
		if( level.sarge GetAttachModelName( i ) == "static_berlin_books_diary" )
		{
			return true;
		}
	}

	return false;
}

///*------------------------------------
//play some flame effects on the guys in the bunker 	(borrowed from oki2_gunbunkers.gsc)
//who burn up
//------------------------------------*/
death_flame_fx()
{
	tagArray = [];
	tagArray[tagArray.size] = "J_Wrist_RI";
	tagArray[tagArray.size] = "J_Wrist_LE";
	tagArray[tagArray.size] = "J_Elbow_LE";
	tagArray[tagArray.size] = "J_Elbow_RI";
	tagArray[tagArray.size] = "J_Knee_RI";
	tagArray[tagArray.size] = "J_Knee_LE";
	tagArray[tagArray.size] = "J_Ankle_RI";
	tagArray[tagArray.size] = "J_Ankle_LE";

	//for( i = 0; i < 3; i++ )
	//{
		//PlayFxOnTag( level._effect["flame_death1"], self, tagArray[randomint(tagArray.size)] );
		PlayFxOnTag( level._effect["flame_death2"], self, "J_SpineLower" );
	//}
	
	self StartTanning(); // burn baby burn
}



kill_all_nazis()
{
	// killspawner for the ai
	getent("e3_axis_group1_kill", "script_noteworthy") notify("trigger");
		
	axis = getaiarray( "axis" );
	
	level waittill("drop pillar");
	
	for(i = 0; i < axis.size; i++)
	{
		if( isdefined(axis[i]) && is_active_ai(axis[i]) )
		{
			axis[i] thread bloody_death(true, 4);
		}
	}
}



//////////////////////////////////////////////////////////////////////////////////////////////////////////
////	Pillar stuff
//////////////////////////////////////////////////////////////////////////////////////////////////////////

e3_pillar_FX1n2(guy)
{
	exploder(1);
	
	thread cover_smoke();
	
	quake_struct = getstruct("e3_pillar_fall_struct", "targetname");
	
	earthquake(0.5, 1.5, quake_struct.origin, 1024);
	
	
	touch_trig = getent("trig_kill_chernov", "targetname");
	players = getplayers();
	
	for(i = 0; i < players.size; i++)
	{
		if( players[i] IsTouching( touch_trig ) )
	{
			players[i] thread e3_knock_down();
		}
	}
}

e3_pillar_FX3(guy)
{
	exploder(3);
}

e3_pillar_FX4(guy)
{
	exploder(4);
}

e3_pillar_FX5(guy)
{
	exploder(5);
}

e3_knock_down()
{
	self allowstand(false);
	self allowcrouch(false);
	self allowsprint(false);
	self allowprone(true);
	
	level waittill("spawn flamethrower");
	
	wait(1);
	
	self allowstand(true);
	self allowcrouch(true);
	self allowsprint(true);
	self allowprone(true);	
}

cover_smoke()
{	
	fxSpot = spawn( "script_model", (1256, 11256, 284) );
	fxSpot setmodel( "tag_origin" );
	fxSpot.angles = (0, 270, 0);
	
	playFXonTag( level._effect["pillar_cover_smoke"], fxSpot, "tag_origin" );
	
	wait(.5);
	
	level.chernov animscripts\shared::PlaceWeaponOn( level.chernov.primaryweapon, "none");
}

//////////////////////////////////////////////////////////////////////////////////////////////////////////
////	Bunker AI
//////////////////////////////////////////////////////////////////////////////////////////////////////////
e3_init_bunker_friendlies()
{
	level.sarge anim_single_solo(level.sarge, "e3_rez_01");	// "The bunkers are heavily fortified."
	level.sarge anim_single_solo(level.sarge, "e3_rez_03");	// "Take out those positions!"
	
	thread bunker1_friendlies();
	thread bunker2_friendlies();
}

bunker1_friendlies()
{
	getent("e3_init_bunker1_friendly", "targetname") waittill("trigger");
	
	guy = get_friendly_by_color("o");
	
	if( isdefined(guy) )
	{
		// change the orange guy to red, then have him move to his node
		guy set_force_color("r");
		wait(1);
		
		getent("e3_move_bunker1_friendly", "targetname") notify("trigger");
	}
}

bunker2_friendlies()
{
	getent("e3_init_bunker2_friendly", "targetname") waittill("trigger");
	
	guy = get_friendly_by_color("o");
	
	if( isdefined(guy) )
	{
		// change the orange guy to yellow, then have him move to his node
		guy set_force_color("y");
		wait(1);
		
		getent("e3_move_bunker2_friendly", "targetname") notify("trigger");
	}
}

get_friendly_by_color(which_color)
{
	allies = getaiarray("allies");
	
	for(i = 0; i < allies.size; i++)
	{
		if(allies[i] check_force_color(which_color) )
		{
			return allies[i];
		}
	}
	
	return undefined;
}












//e3_objectives()
//{
//	wait(2);
//	
//	// Objective:  Storm the Reichstag
//	obj_struct = getstruct( "obj_storm_stag", "targetname" );
//	objective_add( 4, "current", &"BER3_OBJ4", obj_struct.origin );
//	
//	getent("e3_trig_end_mission", "targetname") waittill ("trigger");
//	
//	nextmission();		//TEMP:  end the mission here
//}
//
//
//

//
//
//
//
//e3_drones_storm_reich()
//{
//	level.trig_final_drones notify("trigger");
//}
//
//
//
////e3_ambient_panzers()
////{
////	level endon("stop reich panzers");
////	
////	schreck_starts_right = getstructarray("e3_right_schreck_start", "targetname");
////	schreck_starts_left = getstructarray("e3_left_schreck_start", "targetname");	
////	
////	while(true)
////	{
////		// delay between shots
////		wait( randomintrange(5, 12);
////		
////		pickSide = randomint( (schreck_starts_right + schreck_starts_left) );
////		schreckStart = undefined;
////		
////		if(pickSide < schreck_starts_right)
////		{
////			schreckStart = schreck_starts_right[pickSide];
////		}
////		else
////		{
////			schreckStart = schreck_starts_left[pickSide - schreck_starts_right];
////		}
////		
////		thread maps\ber3_event_intro::fire_shrecks(schreck_start, schreck_end, 1);
////	}	
////}
//
//
//


//////////////////////////////////////////////////////////////////////////////////////////////////////////
////	Stairs movement
//////////////////////////////////////////////////////////////////////////////////////////////////////////
//
//e3_stairs_friendly_moveup()
//{
//	trig1 = getent("e3_stairs_moveup1", "targetname");
//	trig2 = getent("e3_stairs_moveup2", "targetname");
//	
//	getent("e3_start_script_movement", "targetname") waittill("trigger");
//	
//	// Change reznov to blue to follow you up the stairs correctly
//	level.sarge set_force_color("b");
//	wait(.1);		
//	
//	// wait for the first group to be defeated
//	while( get_ai_group_count( "e3_stairs_group1" ) > 2 )
//	{
//		wait(1);
//	}
//	
//	// move the group up
//	trig1 notify("trigger");
//	
//	// wait for the second group to be defeated
//	while( get_ai_group_count( "e3_stairs_group2" ) > 2 )
//	{
//		wait(1);
//	}
//	
//	// in case the player hasn't hit this trigger yet, delete it so chernov and reznov don't run backwards
//	trig = getent("e3_move_rez_cher_up", "targetname");
//	if( isdefined(trig) )
//	{
//		trig delete();
//	}
//	
//	// move the group up
//	trig2 notify("trigger");
//	
//	// At this point, wait for the player to advance forward
//	thread e3_wait_begin_ending();
//}
//

//
//kill_all_nazis()
//{
//	axis = getaiarray( "axis" );
//	
//	level waittill("drop pillar");
//	
//	for(i = 0; i < axis.size; i++)
//	{
//		if( isdefined(axis[i]) && is_active_ai(axis[i]) )
//		{
//			axis[i] thread bloody_death(true, 4);
//		}
//	}
//}
//
//
//// Used to drop the molotovs off the top of the reichstag
//// self is the starting struct, molotov_target is where the molotov should end up
//e3_fake_throw_molotov()
//{
//	getent("e3_toss_molotov", "targetname") waittill("trigger");
//
//	thread e3_fake_throw_molotov_left();
//
//	molotov_targets = getstructarray("e3_ger_molotov_targ", "targetname");
//	molotov_start = getstruct("e3_ger_molotov_start", "targetname");
//	
//	for(i = 0; i < molotov_targets.size; i++)
//	{
//		molotov_start thread throw_molotov(molotov_targets[i]);
//		wait(1);
//	}	
//}
//	
//e3_fake_throw_molotov_left()
//{
//	wait(5);
//	
//	molotov_targets = getstructarray("e3_ger_molotov_targ_left", "targetname");
//	molotov_start = getstruct("e3_ger_molotov_start_left", "targetname");
//	
//	for(i = 0; i < molotov_targets.size; i++)
//	{
//		molotov_start thread throw_molotov(molotov_targets[i]);
//		wait(1);
//	}		
//}	
//	
//throw_molotov(molotov_target)
//{
//	molotov = spawn( "script_model", self.origin );
//	molotov setmodel( "weapon_rus_molotov_grenade" );
//	
//	playfxontag( level._effect["molotov_trail_fire"], molotov, "tag_flash" );
//
//
//	forward = VectorNormalize( ( molotov_target.origin + ( 0, 0, 600 ) ) - molotov.origin );
//	velocities = forward * 12000;
//	molotov physicslaunch( ( molotov.origin ), velocities );
//
//	//velocities = ( forward + ( 300, 0, 0 ) ) * 10;
//	//molotov movegravity( velocities, 4 );
//
//	wait( 1.7 ); // AFTER LUNCH: figure out a good way to check for the time to explode the molotov
//	
//	
//	playfx( level._effect["molotov_explosion"], molotov_target.origin );
//	molotov delete();
//}
//
//
//
//////////////////////////////////////////////////////////////////////////////////////////////////////////
////	Chernov's death
//////////////////////////////////////////////////////////////////////////////////////////////////////////
//
//chernov_death_init()
//{	
//	wait(.5);
//	
//	level.sarge disable_ai_color();
//	level.chernov disable_ai_color();
//	
//	sarge_node = getnode("reznov_node0", "targetname");
//	chernov_node = getnode("chernov_node0", "targetname");
//	
//	// Set up the hero characters for the action
//	level.sarge.ignoreme = 1;
//	level.sarge.pacifist = 1;
//	level.chernov.ignoreme = 1;
//	level.chernov.pacifist = 1;
//	
//	// set up the flame thrower guy
//	flameguy_spawner = getent("e3_flamer", "targetname");
//	flameguy_spawner add_spawn_function( ::flameguy_init );
//	
//	// wait to move the heros to the scene
//	//getent("trig_kill_chernov", "targetname") waittill("trigger");
//	
//	// Play the animation
//	thread e3_play_chernov_death_anim();
//	//thread e3_drones_storm_reich(); 
//	
//	level waittill("spawn flamethrower");
//	flameguy_spawner stalingradspawn();
//}
//
//
//
//e3_play_chernov_death_anim()
//{
//	level.chernov endon("death");
//	
//	guys = [];
//	
//	level.sarge = getent("sarge", "script_noteworthy");
//	level.sarge.animname = "reznov";
//	level.chernov = getent("chernov", "script_noteworthy");
//	level.chernov.animname = "chernov";
//	
//	anode = getnode("ber3_column_collapse", "targetname");
//	
//	guys[0] = level.sarge;
//	guys[1] = level.chernov;
//	
//	//anode anim_reach( guys, "chernov_in", undefined, anode );
//	anode anim_reach_solo( level.sarge, "chernov_in", undefined, anode);		// first, send reznov to his starting position
//	level notify("drop pillar");																			// give the ok to drop the pillar
//	anode anim_reach_solo( level.chernov, "chernov_in", undefined, anode);	// send chernov to his starting point
//	
//	// Do zee animation!
//	//thread flameguy_spawn();
//	level notify("spawn flamethrower");
//	anode anim_single_solo( level.chernov, "chernov_in" ); 
//	thread allow_shoot_chernov();
//	anode anim_single_solo( level.chernov, "chernov_loop" );
//	anode  anim_single_solo( level.chernov, "chernov_death" );
//	anode thread anim_loop_solo( level.chernov, "chernov_death_loop", undefined, "stop chernov" );
//}
//
//#using_animtree("generic_human");
//allow_shoot_chernov()
//{
//	battlechatter_off("allies");
//	
//	level.chernov.ignoreme = true;
//	level.chernov.ignoreall = true;
//	level.chernov.grenadeawareness = 0;
//	
//	level.chernov stop_magic_bullet_shield();
//	level.chernov.allowDeath = true;
//	level.chernov.nodeathragdoll = true;
//	level.chernov.deathAnim = %ch_berlin3_outro_chernov_die;
//	//level.chernov.health = 1;
//	
//	level.chernov.team = "axis";	
//	
//	level.chernov thread wait_for_cher_death();
//}
//
//wait_for_cher_death()
//{
//	level endon("reznov shot chernov");
//	
//	self waittill("damage");
//	
//	self notify("death");
//	
//	if(!level.reznov_anims_finished)
//	{
//		level.sarge stopanimscripted();
//		reznov_outro_anims_finish();
//	}
//}
//
//reznov_outro_anims(guy)
//{
//	level.chernov endon("death");
//	
//	level.reznov_anims_finished = false;
//	
//	anode = getnode("ber3_column_collapse", "targetname");
//	anode anim_single_solo( level.sarge, "chernov_in" ); 
//	//thread reznov_outro_speak();
//	anode anim_single_solo( level.sarge, "chernov_loop" );
//	
////	if(!level.reznov_anims_finished)
////	{
////		reznov_outro_anims_finish();
////	}
//}
//
//reznov_outro_anims_finish()
//{	
//	if(level.reznov_anims_finished)
//		return;
//		
//	level.reznov_anims_finished = true;
//	
//	level notify("reznov shot chernov");
//	
//	anode = getnode("ber3_column_collapse", "targetname");
//	anode  anim_single_solo( level.sarge, "chernov_death" );
//	
//	if( isdefined(level.chernov) && iSalive(level.chernov) )
//	{
//		level.chernov dodamage(level.chernov.health + 10, level.chernov.origin);
//	}
//	
//	thread send_friendlies_to_end();
//	
//	sargeNode = getnode("e3_sarge_node", "targetname");
//	level.sarge setgoalnode(sargeNode);
//	
//	level notify("say_final_vo");	
//}
//
//reznov_outro_speak()
//{
//	level.sarge anim_single_solo( level.sarge, "outro_rez_01" ); 	// "Dimitri! He is suffering."
//	wait(1);
//	level.sarge anim_single_solo( level.sarge, "outro_rez_02" ); 	// "You know what you should do…"
//}
//
//send_friendlies_to_end()
//{
//	getent("e3_friendlies_to_end", "targetname") notify("trigger");
//	
//	level waittill("say_final_vo");
//	
//	wait(1);
//	
//	level.sarge anim_single_solo( level.sarge, "e3_rez_02" ); 	// "Move inside."
//}
//
//
//flameguy_spawn()
//{
//	getent("trig_spawn_flamethrower", "targetname") notify("trigger");
//}
//
flameguy_init()
{
	level.flameguy = self;
	
	level.flameguy.pacifist = 1;
	level.flameguy.ignoreme = 1;
	level.flameguy.goalradius = 32;
	
	level.flameguy.dropweapon = false;
	
	level.flameguy thread magic_bullet_shield();
	level.flameguy setcandamage( false );
	
	level.flameguy.anim_disableLongDeath = true;
	
	flameguy_think();
}

flameguy_think()
{
	targ_node = getnode("e3_flamer_pos", "targetname");

	//level waittill("chernov moving");

	//wait(1);
	
	// flame guy runs to his goal node
	level.flameguy setgoalnode(targ_node);
	level.flameguy waittill("goal");
	
	//wait(.5);
	
	// flame guy fires at his target (conveniently behind chernov)
	targ = getent("flameguy_target", "targetname");
	
	level.flameguy.pacifist = 0;
	level.flameguy SetEntityTarget( targ );
	wait( .5 );
	//level.flameguy ClearEntityTarget();
	level.flameguy StopShoot();
	
	level.flameguy.pacifist = 1;
	
	wait(1.5);
	
	level.chernov thread death_flame_fx();		// start chernov on fire
	
	wait(1.5);
	
	// now have him die
	level.flameguy setcandamage( true );
	level.flameguy flamer_blow();
}

flamer_blow()
{
	wait(2.5);
	
	if (isalive(self))
	{
		self enable_pain();
	}

	earthquake (0.2, 0.2, self.origin, 1500);
	playfx (level._effect["flameguy_explode"], self.origin+(0,0,50) );
	self.health = 50;
	allies = getaiarray("allies");
	allies[0] magicgrenade(self.origin+(-20,-25,20), self.origin, 0.01);	
	allies[0] magicgrenade(self.origin+(-25,-30,10), self.origin, 0.01);
	spot = self.origin;
	allies = getaiarray("allies");

	wait 0.1;
	if (isdefined(self) && isdefined(self.health) && self.health > 0)
	{
		self dodamage(self.health*10, self.origin);
	}
}



#using_animtree("ber3_reich_pillar");
reich_pillar_fall()
{
	level waittill("drop pillar");
	
	//chris_p - add rumble when the pillar gets hit
	thread rumble_all_players("damage_light");
	
	pillar = getent("sb_model_column_collapse", "targetname");
	pillar delete();
	
	//anode = getnode("ber3_column_collapse", "targetname");
	anode = getstruct("e3_pillar_fall_struct", "targetname");
	
	amodel = spawn("script_model", anode.origin, 1);
	amodel setmodel( level.scr_model["reich_pillar"] );
	amodel.animname = "reich_pillar";
	amodel useanimtree( level.scr_animtree["reich_pillar"] );	
	
	// kill any player under the pillar
	thread kill_players_under_pillar();		
	
	//Kevin adding pillar sound
	amodel playsound("explosion");
	
	//TUEY Set music state to PILLAR
	setmusicstate("PILLAR");


	anode anim_single_solo(amodel, "pillar_collapse");	
	
	// Destroy the barricades
	dest_barricades = getentarray("reich_steps_blocker", "targetname");
	
	//chris_p - add rumble when the pillar hits the ground
	thread rumble_all_players("damage_heavy");
	earthquake(0.4,3,amodel.origin,1000);
	
	for(i = 0; i < dest_barricades.size; i++)
	{
		dest_barricades[i] delete();
	}	

	//TUEY Shock the players.
	set_all_players_shock( "ber3_outro", 6);
	
	dest_barricades_brush = getent("e3_reich_steps_blocker_brush", "targetname");
	dest_barricades_brush connectpaths();
	wait(.1);
	dest_barricades_brush delete();
	
	pillarClip = getent("e3_pillar_clip", "targetname");
	pillarclip trigger_on();
	
	wait(.1);
	pillarclip disconnectpaths();
	amodel disconnectpaths();	

	//TUEY Set bus state to Pillar
	setbusstate("PILLAR");
}

kill_players_under_pillar()
{
	wait(3);
	
	pillarClip = getent("e3_pillar_deathzone", "targetname");
	
	players = get_players();
	
	for(i = 0; i < players.size; i++)
	{
		if(players[i] istouching( pillarClip ) )
		{
			players[i] enableHealthShield( false );
			players[i] dodamage( players[i].health * 10, players[i].origin );		
		}
		else
		{
			// player can no longer take damage
			players[i] setcandamage( false );
		}
	}
}
