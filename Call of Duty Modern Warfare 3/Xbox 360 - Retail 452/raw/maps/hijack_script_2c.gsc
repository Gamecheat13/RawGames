#include maps\_utility;
#include common_scripts\utility;
#include maps\_vehicle;
#include maps\_anim;
#include maps\_audio;
#include maps\hijack_code;
#include maps\_blizzard_hijack;
#include maps\_hud_util;

start_end_scene()
{
	//level.commander = spawn_ally("commander");
	level.commander = spawn_ally("commander_tarmac");
	
	waittillframeend;
	
	//commander_node = GetNode("commander_tarmac_node_5","targetname");
	//level.commander teleport_ai(commander_node);

	player_start_struct = GetStruct( "player_start_end_scene", "targetname" );
	level.player setOrigin( player_start_struct.origin );
	level.player setPlayerAngles( player_start_struct.angles );
	
	maps\_compass::setupMiniMap("compass_map_hijack_tarmac", "tarmac_minimap_corner");
	setsaveddvar( "compassmaxrange", 3500 ); //default is 3500
	
	thread maps\hijack_tarmac::tarmac_dead_allies();
	aud_send_msg("start_end_scene");
	
	flag_set("player_on_feet_post_crash");	
	flag_set("spawn_makarov_heli");
	flag_set("move_heli_to_hover_point");
	flag_set("tarmac_combat_wave4");
	flag_set("start_spotlight_random_targeting");
	
	thread maps\hijack_tarmac::main_script_thread();
	thread maps\hijack_script_2b::tarmac_combat_vo_end();
	
	level.player giveWeapon( "fraggrenade" );
	level.player SetOffhandPrimaryClass( "frag" );
	level.player SetWeaponAmmoClip( "fraggrenade", 4 );
	level.player SetWeaponAmmoStock( "fraggrenade", 4 );
	level.player setOffhandSecondaryClass( "flash" );
	level.player giveWeapon( "flash_grenade" );
	level.player SetWeaponAmmoClip( "flash_grenade", 4 );
	level.player SetWeaponAmmoStock( "flash_grenade", 4 );
	    
    wait(0.4);
    approach_node = GetStruct("heli_approach", "targetname");
	level.makarov_heli Vehicle_Teleport(approach_node.origin,approach_node.angles);
	thread maps\hijack_tarmac::makarov_heli_2();

	wait(0.1);
	level.makarov_heli vehicle_detachfrompath();
	level.makarov_heli SetGoalYaw(approach_node.angles[1]);
	level.makarov_heli SetTargetYaw(approach_node.angles[1]);
	level notify("stop_spotlight_fx");

	wait(2);
	ai = GetAIArray();
	foreach(guy in ai)
	{
		if ( !IsEnemyTeam(guy.team,level.player.team) )
		{
			guy thread cold_breath_hijack();
		}
	}
}

end_scene_fail_trigger()
{
	trigger = GetEnt("end_scene_fail_trigger","targetname");
	trigger trigger_off();
	
	flag_wait("player_entered_end_area");
	trigger trigger_on();
	
	flag_wait("tarmac_level_fail");
	
	setDvar( "ui_deadquote", &"HIJACK_FAIL_TARMAC" );
	level notify( "mission failed" );
	missionFailedWrapper();
}

player_grenade_watcher()
{
	level endon("door_used");
	
	while(1)
	{
		flag_wait("player_disable_grenades");
		level.player DisableOffhandWeapons();
		
		flag_waitopen("player_disable_grenades");
		level.player EnableOffhandWeapons();
	}
}

end_scene()
{
	if ( isdefined(level.intro_origin) )
	{
		level.intro_origin notify( "stop_debate_advisor_loop" );
	}
	
	level.commander_pistol = GetEnt("commander_pistol_on_ground","targetname");
	level.commander_pistol hide();
	
	thread setup_heli_door();
	thread end_scene_fail_trigger();
	thread player_grenade_watcher();
	
	flag_wait("player_approaching_end_guys");
	
	thread ending_distant_combat1();
	thread ending_distant_combat2();
	
	level.end_secret_service = spawn_targetname("end_scene_secretservice", true);
	level.end_secret_service.animname = "end_agent";
	//level.end_secret_service gun_remove();
	//level.end_secret_service DropWeapon( "ak74u", "right", .1);
	level.end_secret_service animscripts\shared::DropAIWeapon();
	waittillframeend;
	level.end_secret_service forceUseWeapon("fnfiveseven","sidearm");
	level.end_secret_service thread cold_breath_hijack();
		
	level.president = spawn_ally("president_tarmac", "end_scene_president");
	level.advisor   = spawn_ally("advisor_tarmac", "end_scene_advisor");
	level.advisor thread cold_breath_hijack();
	
	guys 	= [];
	//guys[0] = level.president;
	guys[1] = level.advisor;
	guys[2] = level.end_secret_service;
	
	level.chopper_land_node = GetStruct("heli_end_node", "targetname");
	
	level.chopper_land_node thread anim_loop_solo(level.president, "end_part1", "stop_part_1" ); //testing to see if this prevents him from running.
	//level.chopper_land_node thread anim_loop_solo(level.advisor, "end_part1", "stop_part_1" ); //testing to see if this prevents him from running.
	//level.chopper_land_node thread anim_loop_solo(level.end_secret_service, "end_part1", "stop_part_1" ); //testing to see if this prevents him from running.
	level.chopper_land_node thread anim_loop(guys, "end_part1", "stop_part_1" );
	
	guys[0] = level.president;
	
	//level.chopper_land_node thread anim_first_frame(guys, "end_part2");
	
	flag_wait("kill_final_enemies");
	
	//thread guys_get_up_from_behind_cover(guys);
	thread handle_commander_move_to_end();
	
	flag_wait_all("player_entered_end_area","endguys_dead");
	aud_send_msg("player_entered_end_area");
	
	thread autosave_by_name("end_scene");
	
	helper_ent = spawn_tag_origin();
	helper_ent.origin = level.chopper_land_node.origin;
	helper_ent.angles = level.chopper_land_node.angles;
	
	flag_wait("end_guys_waiting_for_commander");
	
	helper_ent thread guys_approach_heli(guys);
			
	flag_wait("heli_landed");
			
	//setup for the player opening the chopper door
	level.player_rig = spawn_anim_model( "player_rig", level.player.origin );
	level.player_rig hide();	
	level.chopper_land_node anim_first_frame_solo(level.player_rig, "end_part4");

	level waittill("door_used");
	
	//turn off HUD until you can move.
	SetSavedDvar( "compass", 0 );
    SetSavedDvar( "ammoCounterHide", 1 );
    SetSavedDvar( "hud_showstance", 0 );
    SetSavedDvar( "actionSlotsHide", 1 );
	
	thread set_vision_set( "hijack_ending", 9);
	thread vision_set_fog_changes( "hijack_ending", 9);
	//level.heli_interior show();
	foreach( object in level.heli_interior )
	{
		object show();	
	}
	
	foreach( card in level.end_cards )
	{
		card show();
	}
	level.player DisableWeapons();
	level.player SetDepthOfField( 10, 60, 411, 4679, 4.1, 2.8 );
	
	//maps\_treadfx::setvehiclefx( "script_vehicle_mi17_woodland_landing", "snow");
		
	level.makarov 	   = spawn_targetname("makarov_spawner");
	level.makarov.animname = "makarov";
	
	//spawn two makarov cronies
	level.cronie1 = spawn_targetname("makarov_cronie1");
	level.cronie1.animname = "henchman1";
	level.cronie1 thread cold_breath_hijack();
	
	level.cronie2 = spawn_targetname("makarov_cronie2");
	level.cronie2.animname = "henchman2";
	level.cronie2 thread cold_breath_hijack();

	level.player AllowCrouch(false);
	level.player AllowProne(false);
	
	//lerp player into place
	level.player PlayerLinkToBlend( level.player_rig, "tag_player", 0.3, 0.2);
	
	//play the final scene
	guys[3] = level.commander;
	guys[4] = level.player_rig;
	guys[5] = level.makarov;
	guys[6] = level.makarov_heli;
	guys[7] = level.makarov_heli_door;
	guys[8] = level.cronie1;
	guys[9] = level.cronie2;

	level.makarov_heli.animname = "makarov_heli";
	level.makarov_heli_door.animname = "makarov_heli_door";
	level.makarov_heli_door SetAnimTree();
	//level.commander gun_recall();
	level.commander forceUseWeapon( level.commander.sidearm, "primary" );
		
	//play the final scene on everyone including the player rig
	level.chopper_land_node thread anim_single(guys, "end_part4");
	aud_send_msg ("makarov_slow");
	aud_send_msg ("blackout");
	
	level.player LerpFOV( 45, 2);

	light_struct = GetStruct("makarov_heli_light_struct","targetname");
	light_dir_forward = AnglesToForward(light_struct.angles);
	light_dir_up = AnglesToUp(light_struct.angles);
	PlayFX(getfx("makarov_heli_interior_light"),light_struct.origin,light_dir_forward,light_dir_up);

	level.player_rig delayThread( .5, ::show_entity );
	
	thread player_slo_mo();
	thread player_bloody_screen();
	thread unlock_look_control();
	thread spawn_and_move_extras();
	thread commander_pistol_and_blood();
	thread makarov_switch_weapon_hands();
	thread makarov_gun_shots();
	thread cronie1_gun_shots();
	thread cronie2_gun_shots();
	thread ending_final_choppers();
	thread final_vo();
	
	level.player_rig waittillmatch("single anim", "fade_in");
	level.commander.lastWeapon = "ak74u";	// hack to avoid SRE
	level.commander.weapon = "none";	// hack to avoid SRE

	fade_out_duration = calcNoteTrackDelta(level.player_rig getanim("end_part4"), "fade_in", "fade_out");
	fade_out(fade_out_duration);
	wait(.75);
	
	//turn off HUD until you can move.
	SetSavedDvar( "compass", 1 );
    SetSavedDvar( "ammoCounterHide", 0 );
    SetSavedDvar( "hud_showstance", 1 );
    SetSavedDvar( "actionSlotsHide", 0 );

	nextmission();
}

final_vo()
{
	level.makarov waittillmatch("single anim","ps_hijack_mkv_weakness");
	wait( 3.30 );
	
	radio_dialogue( "hijack_fso3_allteams" );
}

ending_distant_combat1()
{
	level endon("door_used");
	snd_org = getEnt( "ending_distant_combat1", "targetname" );
	level.snd_index = 0;
	
	while(1)
	{
		wait(RandomFloatRange( 2, 9 ));
		
		rand = RandomIntRange(0, 5);
		
		if (rand == level.snd_index)
		{
			rand += 1;
			if (rand == 5)
			{
				rand = 0;
			}
		}
		
		level.snd_index = rand;
		
		switch(rand)	
		{
			case 0:
				snd_org PlaySound( "hijack_fso3_longyell" );
				break;
			case 1:
				snd_org PlaySound( "hijack_fso2_injured" );
				break;
			case 2:
				snd_org PlaySound( "hijack_fso1_surprisedyelp" );
				break;
			case 3:
				snd_org PlaySound( "hijack_fso2_yellofpain" );
				break;
			case 4:
				snd_org PlaySound( "hijack_fso2_yellofpain2" );
				break;
			default:
				break;
		}	
	}
}

ending_distant_combat2()
{
	level endon("door_used");
	snd_org = getEnt( "ending_distant_combat2", "targetname" );
	level.snd_index = 0;
	
	while(1)
	{
		wait(RandomFloatRange( 2, 9 ));
		
		rand = RandomIntRange(0, 5);
		
		if (rand == level.snd_index)
		{
			rand += 1;
			if (rand == 5)
			{
				rand = 0;
			}
		}
		
		level.snd_index = rand;
		
		switch(rand)	
		{
			case 0:
				snd_org PlaySound( "hijack_fso2_yellofpain2" );
				break;
			case 1:
				snd_org PlaySound( "hijack_fso1_agentdown" );
				break;
			case 2:
				snd_org PlaySound( "hijack_fso2_lookout" );
				break;
			case 3:
				snd_org PlaySound( "hijack_fso1_gungun" );
				break;
			case 4:
				snd_org PlaySound( "hijack_fso3_yellofpain" );
				break;
			default:
				break;
		}	
	}
}

/*guys_get_up_from_behind_cover(guys)
{
	level.chopper_land_node anim_single(guys, "end_part0");
	level.chopper_land_node thread anim_loop(guys, "end_part1", "stop loop");
	flag_set("end_guys_waiting_for_commander");
}*/

handle_commander_move_to_end()
{
	wait(2);
	
	commander_start_loc = GetStartOrigin(level.chopper_land_node.origin,level.chopper_land_node.angles,level.commander GetAnim("end_part2"));
	distance_to_start = distance(commander_start_loc,level.commander.origin);
	
	level.commander.moveplaybackrate = 0.90;
	//thread commander_vo_pres();
	
	/*if ( distance_to_start < 1200 )
	{
		level.commander enable_cqbwalk();
		level.commander.moveplaybackrate = 0.65;
	}
	else if ( distance_to_start < 1800 )
	{
		level.commander enable_cqbwalk();
		level.commander.moveplaybackrate = 0.90;
	}*/
	level.chopper_land_node anim_reach_solo(level.commander, "end_part2");
	flag_set("end_guys_waiting_for_commander");
}

/*commander_vo_pres()
{
	flag_wait( "commander_says_president" );
	level.commander thread dialogue_queue("hijack_cmd_thepresident");
}*/

makarov_switch_weapon_hands()
{
	level.makarov waittillmatch("single anim","gun_2_left");
	
	level.makarov animscripts\shared::placeWeaponOn( level.makarov.weapon, "left" );
	level.makarov notify( "weapon_switch_done" );
	
	level.makarov waittillmatch("single anim","fire");
	
	weaporig = level.makarov gettagorigin( "tag_weapon" );
	dir = anglestoforward( level.makarov getMuzzleAngle() );
	pos = weaporig + ( dir * 1000 );
	level.makarov shoot( 1, pos );	
}

makarov_gun_shots()
{
	// first shot
	level.makarov waittillmatch("single anim", "fire");
	PlayFXOnTag(getfx("beretta_flash_wv"), level.makarov, "tag_weapon_right");
	
	// second shot
	level.makarov waittillmatch("single anim", "fire");
	aud_send_msg("commander_shot");
	PlayFXOnTag(getfx("beretta_flash_wv"), level.makarov, "tag_weapon_right");
	
	// Commander head shot
	shotPos = level.makarov GetTagOrigin( "tag_weapon_right" );
	shotDir = AnglesToForward( level.makarov GetMuzzleAngle() );
	PlayFX(getfx("commander_headshot"), shotPos, shotDir);
	
	// third shot
	level.makarov waittillmatch("single anim", "fire");
	aud_send_msg("player_shot");
	PlayFXOnTag(getfx("beretta_flash_wv"), level.makarov, "tag_weapon_left");
	
	white 	 = create_client_overlay( "white", 1 );
	white thread fade_over_time( 0, .25 );
}

cronie1_gun_shots()
{
	// first shot
	level.cronie1 waittillmatch("single anim", "fire");
	PlayFXOnTag(getfx("ak47_flash_wv_hijack_crash"), level.cronie1, "tag_weapon_right");
	PlayFXOnTag(getfx("flesh_hit_body_fatal_exit"), level.commander, "tag_weapon_chest" );
	
	// second shot
	level.cronie1 waittillmatch("single anim", "fire");
	PlayFXOnTag(getfx("ak47_flash_wv_hijack_crash"), level.cronie1, "tag_weapon_right");
	PlayFXOnTag(getfx("flesh_hit_body_fatal_exit"), level.end_secret_service, "tag_weapon_chest" );
}

cronie2_gun_shots()
{
	// first shot
	level.cronie2 waittillmatch("single anim", "fire");
	PlayFXOnTag(getfx("ak47_flash_wv_hijack_crash"), level.cronie2, "tag_weapon_right");
	
	// second shot
	level.cronie2 waittillmatch("single anim", "fire");
	PlayFXOnTag(getfx("ak47_flash_wv_hijack_crash"), level.cronie2, "tag_weapon_right");
}

commander_pistol_and_blood()
{
	level.player_rig waittillmatch("single anim", "start_bloody_screen");
	wait(9);
	
	level.commander_pistol show();
	
	wait(1);
	
	tagPos = level.commander gettagorigin( "tag_eye" );
	tagAngles = level.commander gettagangles( "tag_eye" );
	forward = anglestoforward( tagAngles );
	up = anglestoup( tagAngles );
	right = anglestoright( tagAngles );

	tagPos = tagPos + ( forward * -8.5 ) + ( up * 5 ) + ( right * 0 );

	trace = bulletTrace( tagPos + ( 0, 0, 30 ), tagPos - ( 0, 0, 100 ), false, undefined );
	
	fx_dir = AnglesToForward((0,180,0));
	
	if ( trace[ "normal" ][2] > 0.9 )
		playfx( level._effect[ "commander_blood_pool" ], tagPos );
}

unlock_look_control()
{
	level.player EnableSlowAim(0.1,0.1);
	level.player_rig waittillmatch("single anim", "unlock_player_look_control");
	
	level.player PlayerLinkToDelta( level.player_rig, "tag_player", 1, 15, 15, 10, 10, true );
	
	wait(20);
	level.player PlayerLinkToBlend( level.player_rig, "tag_player", 6, 0.1, 0.1 );
}

player_bloody_screen()
{
	level.player_rig waittillmatch("single anim", "start_bloody_screen");
	
	white 	 = create_client_overlay( "white", 1 );
	white thread fade_over_time( 0, .5 );
	
	overlay = NewClientHudElem(level.player);
	overlay.x = 0;
	overlay.y = 0;
	overlay SetShader( "fullscreen_bloodsplat_bottom", 640, 480 );//"splatter_alt_sp"
	overlay.splatter = true;
	overlay.alignX = "left";
	overlay.alignY = "top";
	overlay.sort = 1;
	overlay.foreground = 0;
	overlay.horzAlign = "fullscreen";
	overlay.vertAlign = "fullscreen";
	overlay.alpha = 1;

	thread maps\_blizzard_hijack::blizzard_level_transition_none( 2 );
	//iprintln( "shot" );
	setblur( 1.0, 0.1 );
	wait( 1.65 );
	//iprintln( "hitground" );
	setblur( 4.0, 0.2 );
	wait( 0.3 );
	setblur( 0.0, 1.0 );

	while ( true )
	{	
		blur = randomint( 3 ) + 2;
		blur_time = randomfloatrange( 0.8, 1.2 );
		recovery_time = randomfloatrange( 0.5, 1.0 );
	
		setblur( blur, blur_time );
		wait( blur_time );
		setblur( 0, recovery_time );
		wait( 3 );	
	}
}

player_slo_mo()
{
	level.player_rig waittillmatch("single anim", "slomo_in");
	SetSlowMotion(1.0, 0.3, 0.05);
	level.player_rig waittillmatch("single anim", "slomo_out");
	SetSlowMotion(0.3, 1.0, 0.05);

	level.player_rig waittillmatch("single anim", "slomo_in");
	SetSlowMotion(1.0, 0.3, 0.80);
	level.player LerpFOV( 65, 1.5);
	level.player_rig waittillmatch("single anim", "slomo_out");
	SetSlowMotion(0.3, 1.0, 0.05);
	
}

spawn_and_move_extras()
{
	level.player_rig waittillmatch("single anim", "ai_start");
	
	extras = array_spawn_targetname("makarov_extra_henchmen");
	extras[0] thread cold_breath_hijack();
	extras[1] thread cold_breath_hijack();
	
	final_node_1 = GetNode("henchmen_1_final_dest","targetname");
	final_node_2 = GetNode("henchmen_1_final_dest","targetname");
	extras[1] go_to_final_dest(final_node_1);
	wait(0.5);
	extras[0] go_to_final_dest(final_node_2);
}

go_to_final_dest(final_node)
{
	self.goalradius = 24;
	self set_forcegoal();
	self SetGoalNode(final_node);
}

calcNoteTrackDelta(animation, noteTrack1, noteTrack2)
{
	time1 = GetNotetrackTimes(animation, notetrack1)[0];
	time2 = GetNotetrackTimes(animation, notetrack2)[0];
	
	assertex(IsDefined(time1), "calcNoteTrackDelta didn't find: " + noteTrack1);
	assertex(IsDefined(time2), "calcNoteTrackDelta didn't find: " + noteTrack2);
	
	delta = (time2 - time1) * GetAnimLength(animation);
	return delta;
}

setup_heli_door()
{
	flag_wait("spawn_makarov_heli");
	flag_wait("guys_ready_for_door");
	flag_wait("heli_landed");
	
	use_obj = spawn_tag_origin();
	use_obj.origin = level.makarov_heli GetTagOrigin("tag_left_door_handle");
	use_obj SetCursorHint("HINT_ACTIVATE");
	use_obj SetHintString(&"HIJACK_OPEN_HELI_DOOR");
	use_obj MakeUsable();
	level.makarov_heli_door glow();
	thread player_door_nag();
	
	use_obj waittill( "trigger", player );
	
	use_obj SetHintString("");
	level.makarov_heli_door stopGlow();
	level notify("door_used");
}

player_door_nag()
{
	level endon("door_used");
	
	wait(2);
	level.commander dialogue_queue("hijack_cmd_openthedoor2");
	
	while(1)
	{
		wait(RandomFloatRange(10,15));
		level.commander dialogue_queue("hijack_cmd_openthedoor2");
	}
}

//manages everyone getting up to the heli initially
guys_approach_heli(guys)
{
	level.commander disable_cqbwalk();
	level.commander.moveplaybackrate = 0.8;
	//level.commander thread dialogue_queue("hijack_cmd_thepresident");
	self anim_reach_solo(level.commander, "end_part2");
	
	//stop the loop on the rest of the guys
	level.chopper_land_node notify("stop_part_1");
	foreach(guy in guys)
	{
		guy StopAnimScripted();
	}

	flag_set("start_heli_descent");
	foreach(guy in guys)
	{
		guy.lastGroundtype = "snow"; // hack to get footsteps to show up
	}
	self thread anim_single(guys,"end_part2", "tag_origin");
	self anim_single_solo(level.commander,"end_part2", "tag_origin");
	
	level notify("player_told_to_open_door");
	
	//play the loop waiting for the player
	guys[3] = level.commander;
	self thread anim_loop(guys, "end_part3", "stop_part2_loop", "tag_origin");
	flag_set("guys_ready_for_door");
}

heli_lands()
{
	// we can afford the treadfx now, so turn them on.
	maps\_treadfx::setvehiclefx( "script_vehicle_mi17_woodland_landing", "snow", "treadfx/heli_snow_hijack");
	maps\_treadfx::setvehiclefx( "script_vehicle_mi17_woodland_landing", "ice", "treadfx/heli_snow_hijack");
	maps\_treadfx::setvehiclefx( "script_vehicle_mi17_woodland_landing", "slush", "treadfx/heli_snow_hijack");
	
	self.originheightoffset = distance( self gettagorigin( "tag_origin" ), self gettagorigin( "tag_ground" ) );
	
	level.makarov_heli ent_flag_wait("makarov_heli_disable_spotlight");
	level notify("stop_spotlight_fx");
	
	ent_flag_wait("makarov_heli_reached_end");
	
	self vehicle_detachfrompath();
	
	level.chopper_land_node = GetStruct("heli_end_node", "targetname");
	
	self SetGoalYaw(level.chopper_land_node.angles[1]);
	self SetTargetYaw(level.chopper_land_node.angles[1]);	
	self setHoverParams( 0, 0, 0 );
	self SetVehGoalPos(level.chopper_land_node.origin, 1);
	
	self waittill("goal");
	
	wait(0.25);
	self Vehicle_Teleport(level.chopper_land_node.origin,level.chopper_land_node.angles);
	wait(0.25);
	flag_set("heli_landed");
}

move_around_target(center_ent)
{
	level endon("stop_spotlight_fx");
	
	while(1)
	{
		new_offset = (RandomFloatRange(-150,150),RandomFloatRange(-150,150),0);
		new_loc = center_ent.origin + new_offset;
		move_time = RandomFloatRange(1.5,2.5);
		self MoveTo(new_loc,move_time);
		extra_wait_time = RandomFloatRange(0,1);
		wait(move_time+extra_wait_time);
	}
}

spotlight_monitor_end()
{
	self endon( "death" );
	self notify("start_random_spotlight_targets");
	self notify("shine_spotlight_on_president");

	objective_end_3 = getstruct("objective_end_3", "targetname");
		
	dummy_spotlight_target =  Spawn( "script_origin", objective_end_3.origin );
	//self.spotlight SetTargetEntity( level.president );
	self.spotlight SetTargetEntity( dummy_spotlight_target );
	
	dummy_spotlight_target thread move_around_target(objective_end_3);
	
	level waittill("stop_spotlight_fx");
	
	wait(0.9);
	
	dummy_spotlight_target delete();

	left = AnglesToForward( self.angles + ( 60, 90, 0 ) );
	left_origin = self GetTagOrigin( "tag_turret" ) + ( left * 200 );
	self.spotlight_target_final = Spawn( "script_origin", left_origin );
	self.spotlight_target_final LinkTo( self );
	self.spotlight SetTargetEntity( self.spotlight_target_final );
}

ending_final_choppers()
{
	level.makarov waittillmatch("single anim", "gun_2_left");
	
	end_choppers = spawn_vehicles_from_targetname_and_drive("end_choppers");
	wait(.35);
	end_choppers2 = spawn_vehicles_from_targetname_and_drive("end_choppers2");
}
