#include maps\_utility;
#include common_scripts\utility;
#include maps\_vehicle;
#include maps\_anim;
#include maps\dubai_code;
#include maps\dubai_anim;
#include maps\dubai_utils;
#include maps\_hud_util;
#include maps\_shg_common;
#include maps\dubai_fx;
#include maps\_audio;
#include maps\_credits;

///////////////////////////////////////////////
//---------------- FINALE -------------------//
///////////////////////////////////////////////
setup_finale()
{
	background = getent( "reflection_background", "targetname" );
	background hide();
	level.rumble_ent = level.player get_rumble_ent();
	level.rumble_ent.intensity = 0;
	
	//chopper sequence
	thread finale_chopper_sequence();
	
	//roof crash sequence
	thread finale_crash_site_sequence();
	
	// beatdown
	thread finale_beatdown_sequence();
	
	thread finale_end_mission();
}

finale_chopper_setup_actor( name, sname, headmodel, useweapon )
{
	spawner = getent( sname, "script_noteworthy" );
	actor = spawner spawn_ai( true );
	actor.ignoreall = true;
	actor.animname = name;
	actor gun_remove();
	if (useweapon)
		actor forceUseWeapon( "usp", "primary" );
	if (isdefined(headmodel))
	{
		if (isdefined(actor.headmodel))
			actor detach(actor.headmodel);
		actor attach(headmodel);
		actor.headmodel = headmodel;
	}
	return actor;
}

finale_chopper_play_anim_and_delete( actor, anime, tag )
{
	self anim_single_solo( actor, anime, tag );
	if (level.yank)
		actor Delete();
}

draw_ent_tag_origin( tag )
{
	/#
	if (!isdefined(tag))
		tag = "tag_origin";
	self attach( "axis", tag );
	/*
	axis = spawn("script_model", self GetTagOrigin(tag));
	axis.angles = self GetTagAngles(tag);
	axis SetModel("axis");
	axis linkto(self, tag);
	self waittill("death");
	axis Delete();
	*/
	#/
}

track_tag( tag )
{
	self endon("death");
	anglearry = [];
	originarry = [];
	maxi = 120;
	idx = 0;
	while (true)
	{
		anglearry[idx] = self GetTagAngles( tag );
		originarry[idx] = self GetTagOrigin( tag );
		first = idx+1;
		last = idx;
		idx++;
		if (idx >= maxi)
			idx = 0;
		if (first >= maxi)
			first = 0;
		if (anglearry.size < maxi)
		{
			first = 0;
			last = anglearry.size-1;
		}
		prev = first;
		while (true)
		{
			/#
			draw_axis(originarry[first], anglearry[first]);
			#/
			if (prev != first)
				line(originarry[prev],originarry[first],(1,1,1));
			prev = first;
			if (first == last)
				break;
			first++;
			if (first >= maxi)
				first = 0;
		}
		
		wait 0.05;
	}
}

finale_autosave_check_override()
{
	return true;
}

finale_player_setup()
{
	level.player takeallweapons();
	level.player allowprone( false );
	level.player allowcrouch( false );
	level.player allowstand( true );
	level.player setstance( "stand" );
	level.player disableusability();

	SetSavedDvar( "compass", "0" );
	SetSavedDvar( "hud_showStance", "0" );
	SetSavedDvar( "ammoCounterHide", 1 );
	SetSavedDvar( "actionSlotsHide", 1 );

	level.autosave_check_override = ::finale_autosave_check_override;
}

finale_chopper_sequence()
{
	add_hint_string( "hint_stab_copilot", &"DUBAI_HIT_MELEE", ::finale_should_break_hit_melee );
	add_hint_string( "hint_throw_pilot", &"DUBAI_HIT_MELEE_THROW", ::finale_should_break_hit_melee_yank );
	level.stabbed = false;
	level.stab_failure = false;
	flag_wait( "finale_sequence_begin");
	aud_send_msg("finale_se", "start_run");
	if (!isdefined(level.attack_button_q))
		thread monitor_button_presses();
	thread finale_chopper_monitor_player_speed();
	finale_chopper_spawner = getent( "finale_chopper", "targetname" );
	finale_chopper_spawner.target = undefined;	// don't spawn the riders
	finale_chopper = spawn_vehicle_from_targetname( "finale_chopper");
	finale_chopper assign_animtree( "md500" );
	aud_send_msg("start_finale_chopper", finale_chopper);
//	finale_chopper thread track_tag( "tag_player" );
	finale_chopper_pilot = finale_chopper_setup_actor( "pilot", "finale_chopper_pilot", "head_tank_a_pilot", false );
	level.pilot = finale_chopper_pilot;
	finale_chopper_copilot = finale_chopper_setup_actor( "copilot", "finale_chopper_copilot", "head_henchmen_c", true );
	level.copilot = finale_chopper_copilot;
//	level.copilot thread track_tag( "tag_origin" );
	makarov = finale_chopper_setup_actor( "makarov", "makarov_finale_chopper", undefined, false );
	level.makarov = makarov;
	player_rig = spawn_anim_model( "player_rig" );
	player_rig thread setup_player_rig_notetracks();
	level.player_rig = player_rig;
//	player_rig thread track_tag( "tag_player" );
	player_legs = spawn_anim_model( "player_legs" );
	level.player_legs = player_legs;
	knife = spawn_anim_model( "knife" );
	scripted_node = getent( "finale_scripted_node", "targetname" );
	level.finale_chopper = finale_chopper;
	thread maps\dubai_fx::setup_helicopter_finale_light();
	
	actors[0] = finale_chopper_pilot;
	actors[1] = finale_chopper_copilot;
	actors[2] = finale_chopper;
	
	target_actors[0] = finale_chopper_pilot;
	target_actors[1] = finale_chopper_copilot;
	target_actors[2] = finale_chopper;
	target_actors[3] = makarov;
	
	pactors[0] = player_rig;
	pactors[1] = player_legs;
	thread finale_chopper_player( pactors, scripted_node );
	
	flag_set( "update_obj_pos_finale_chopper" );

	thread finale_chopper_waitfor_player_jump( finale_chopper );
	thread finale_jump_missed_check();
	thread finale_chopper_adjust_animspeeds( target_actors, pactors );

	thread finale_chopper_makarov( makarov, scripted_node, finale_chopper );
	scripted_node thread anim_single( actors, "helo_jump_1" );
	thread maps\dubai_fx::roof_heli_jumpdof();
	
	flag_wait_either("finale_player_jump_finished", "finale_too_late_to_jump");
	if (flag("finale_player_jump_successful"))
	{
	//	flag_set("finale_chopper_takeoff_finished");
	//	flag_wait("finale_player_jump_finished");
		aud_send_msg("finale_se", "start_helo_sequence");
		aud_send_msg("finale_jump_succesful", finale_chopper);
		thread finale_chopper_hint_and_catch_stab();
		
		thread maps\dubai_fx::roof_environmentfx_stop();
		
		scripted_node thread anim_single_solo( knife, "helo_jump_2" );	// this is actually 2 and 3 on success
		scripted_node thread finale_chopper_play_anim_and_delete( finale_chopper_pilot, "helo_jump_2" );
		actors[0] = undefined;
		finale_chopper_copilot linkto( finale_chopper, "tag_guy1" );
		finale_chopper thread anim_single_solo( finale_chopper_copilot, "helo_jump_2", "tag_guy1" );
		scripted_node anim_single_solo( finale_chopper, "helo_jump_2" );
		if (!level.stabbed)
		{	// fail
			aud_send_msg("finale_se", "fail_helo_sequence");
			knife Delete();	// stop it's animation and get rid of it
			level.stab_failure = true;
			scripted_node thread anim_single_solo_trans( finale_chopper, "helo_jump_3" );
			finale_chopper thread anim_single_solo_trans( finale_chopper_copilot, "helo_jump_stab_fail", 0.0, "tag_guy1" );
			finale_chopper thread anim_single_solo_trans( player_rig, "helo_jump_stab_fail", 0.0, "tag_guy1" );
			finale_chopper_copilot waittillmatch("single anim", "fire");
			thread finale_shot_death( &"DUBAI_FAILED_TO_STAB_COPILOT" );
			level.player_rig linkto( level.finale_chopper, "tag_player" );
			while (true)
			{
				level.player PlayerLinktoDelta( level.player_rig, "tag_player", 1.0, 0,0,0,0,true );
				wait 0.05;
			}
		}
		thread maps\dubai_fx::kill_helicopter_finale_light();
		thread maps\dubai_fx::heli_fire_vfx();
		finale_chopper thread finale_chopper_play_anim_and_delete( finale_chopper_copilot, "helo_jump_3", "tag_guy1" );
		scripted_node anim_single_solo( finale_chopper, "helo_jump_3" );
		player_rig thread finale_crash_site_wait_to_crash();
		scripted_node anim_single_solo_trans( finale_chopper, "helo_jump_idle", 0 );
	}
	else
	{	// we need the fail case anims?
		wait 5;	// allow failure to happen
	}
	// cleanup
	flag_wait( "finale_chopper_crash_complete" );
	makarov Delete();
	//finale_chopper_pilot Delete();
	//finale_chopper_copilot Delete();
	finale_chopper Delete();
	if (isdefined(knife))
		knife Delete();
}

finale_chopper_makarov( makarov, scripted_node, heli )
{
	scripted_node thread anim_single_solo( makarov, "helo_jump_1" );
	aud_send_msg("makarov_doorclose", makarov);
	while (true)
	{	// since anim_single_solo won't return if we muck with anim speeds, we do this wait
		pos = makarov GetAnimTime( level.scr_anim[makarov.animname]["helo_jump_1"]);
		if (pos > 0.99)
			break;
		wait 0.05;
	}
	//flag_wait_either("finale_player_jump_finished", "finale_too_late_to_jump");
	heli anim_first_frame_solo( makarov, "helo_jump_idle_nl", "tag_player" );
	makarov linkto( heli, "tag_player" );
	heli anim_loop_solo( makarov, "helo_jump_idle", "stop_loop", "tag_player" );
}

finale_chopper_player( pactors, scripted_node )
{
	pactors[0] Hide();
	pactors[1] Hide();
	flag_wait( "finale_player_jump_start" );
	SetSavedDvar( "compass", "0" );
	SetSavedDvar( "hud_showStance", "0" );
	thread maps\dubai_fx::heli_environmentfx_start();
	thread finale_player_setup();
	scripted_node anim_first_frame( pactors, "helo_jump_1" );
	time = 0.75;
	level.player PlayerLinktoBlend( pactors[0], "tag_player", time, 0.05, 0.05 );
	pactors[0] delaycall( time, ::Show);
	pactors[1] delaycall( time, ::Show);
	flag_set( "finale_player_jump_successful" );
	scripted_node anim_single( pactors, "helo_jump_1" );
	if (!flag( "finale_too_late_to_jump" ))
	{
		flag_set("finale_player_jump_finished");
		flag_set( "update_obj_pos_finale_no_marker" );
		pactors[0] linkto( level.finale_chopper, "tag_guy1" );
		pactors[1] linkto( level.finale_chopper, "tag_guy1" );
		thread finale_chopper_catch_fail_block_kick();
		level.finale_chopper anim_single_trans( pactors, "helo_jump_2", 0.0, "tag_guy1" );
		if (level.stabbed && level.yank)
		{
			level.finale_chopper anim_single_trans( pactors, "helo_jump_3", 0.0, "tag_guy1" );
		}
		else
		{
			wait 10;	// stab_fail started in finale_chopper_sequence_new
		}
	}
	thread maps\dubai_fx::heli_environmentfx_stop();
	pactors[0] thread finale_chopper_control_stick(level.finale_chopper);
	pactors[1] hide();
	
	pactors[0] linkto( level.finale_chopper, "tag_guy1" );
	level.finale_chopper anim_single_solo_trans( pactors[0], "helo_jump_idle", 0, "tag_guy1" );
	flag_set( "finale_chopper_crash_complete" );
	wait 2.0;
	pactors[0] Delete();
	pactors[1] Delete();
}

finale_chopper_hint_and_catch_block_kick()
{
	anim_time = GetAnimLength( level.scr_anim[ "player_rig" ][ "helo_jump_2" ] );
	nt = getnotetracktimes( level.scr_anim[ "player_rig" ][ "helo_jump_2" ], "fail_start" );
	fail_time = nt[0]*anim_time;
	time = 0;
	block_warning_start = fail_time-1.5;
	level.yank = false;
	level.yank_failure = false;
	yank_hint_given = false;
	while (time < fail_time)
	{
		if (time > block_warning_start)
		{	// display hint and check for melee
			if (!yank_hint_given)
			{
				yank_hint_given = true;
				level.hint_fontscale = 3;
				display_hint( "hint_throw_pilot" );
				level.hint_fontscale = undefined;
			}
			else
			{
			}
			if (level.player MeleeButtonPressed())
			{
				level.yank = true;
				return;
			}
		}
		time += 0.05;
		wait 0.05;
	}
}

finale_chopper_catch_fail_block_kick()
{
	thread finale_chopper_hint_and_catch_block_kick();
	level.player_rig waittillmatch( "single anim", "fail_start" );
	if (!level.yank)
	{
		level.yank_failure = true;
		actors[0] = level.player_rig;
		actors[1] = level.player_legs;
		actors[2] = level.copilot;
		actors[3] = level.makarov;
		snactors[0] = level.finale_chopper;
		snactors[1] = level.pilot;
		scripted_node = getent( "finale_scripted_node", "targetname" );
		level.finale_chopper thread anim_single( actors, "helo_jump_kick_fail", "tag_guy1" );
		scripted_node thread anim_single( snactors, "helo_jump_kick_fail" );
		wait 0.75;
		SetDvar( "ui_deadquote", &"DUBAI_FAILED_TO_THROW_PILOT" );
		SetBlur( 30, 2 );
		missionfailedwrapper();
	}
}

finale_chopper_control_stick( chopper )
{
	anm[0] = level.scr_anim[ "player_rig" ][ "helo_jump_middle" ];
	anm[1] = level.scr_anim[ "player_rig" ][ "helo_jump_pull" ];
	anm[2] = level.scr_anim[ "player_rig" ][ "helo_jump_push" ];
	anm[3] = level.scr_anim[ "player_rig" ][ "helo_jump_left" ];
	anm[4] = level.scr_anim[ "player_rig" ][ "helo_jump_right" ];
	canm[0] = level.scr_anim[ "md500" ][ "helo_jump_middle" ];
	canm[1] = level.scr_anim[ "md500" ][ "helo_jump_pull" ];
	canm[2] = level.scr_anim[ "md500" ][ "helo_jump_push" ];
	canm[3] = level.scr_anim[ "md500" ][ "helo_jump_left" ];
	canm[4] = level.scr_anim[ "md500" ][ "helo_jump_right" ];
	stick_pos = [0,0];
	stick_vel = 1.0;
	//CreateDebugTextHud( "stick_pos", 20, 30, undefined, "stick_pos:" );
	level.rumble_ent.intensity = 1.0;
	while (!flag("finale_chopper_crash_complete"))
	{
		move = level.player GetNormalizedMovement();
		for (i=0; i<2; i++)
		{
			delta = move[i] - stick_pos[i];
			if (delta > stick_vel)
				delta = stick_vel;
			if (delta < -1*stick_vel)
				delta = -1*stick_vel;
			stick_pos[i] += delta;
		}
		
		aud_send_msg("set_stick", stick_pos);
		
		weight = [0,0,0,0,0];
		if (stick_pos[0] >= 0)
		{
			weight[2] = stick_pos[0];
		}
		if (stick_pos[0] < 0)
		{
			weight[1] = -1*stick_pos[0];
		}
		if (stick_pos[1] >= 0)
		{
			weight[4] = stick_pos[1];
		}
		if (stick_pos[1] < 0)
		{
			weight[3] = -1*stick_pos[1];
		}
		total_weight=0;
		for (i=1; i<5; i++)
			total_weight += weight[i];
		if (total_weight < 1)
			weight[0] = 1 - total_weight;
		// now determine the weight left for the idle
		
		for (i=0; i<5; i++)
		{
			self SetAnim( anm[i], weight[i], 0.05 );
			chopper SetAnim( canm[i], weight[i], 0.05 );
		}
		wait 0.05;
	}
	for (i=0; i<5; i++)
	{
		self SetAnim( anm[i], 0, 0.05 );
		if (isdefined(chopper))
			chopper SetAnim( canm[i], 0, 0.05 );
	}
	wait 2;
	
	//rumble a couple seconds before finishing
	level.rumble_ent.intensity = 0.0;
}


finale_chopper_monitor_player_speed()
{
	level.player endon("death");
	level.player.speed = 0;
	level.player.prv_origin = level.player.origin;
	while (!flag( "finale_too_late_to_jump" ) && !flag( "finale_player_jump_start" ))
	{
		level.player.vel = (level.player.origin - level.player.prv_origin)*20;
		level.player.speed = Length(level.player.vel);
		level.player.prv_origin = level.player.origin;
		wait 0.05;
	}
}

finale_chopper_adjust_animspeeds( actors, pactors )
{
	/*
	CreateDebugTextHud( "h_as", 20, 20, undefined, "h_as:" );
	CreateDebugTextHud( "h_tl", 20, 40, undefined, "h_tl:" );
	CreateDebugTextHud( "pl_s", 20, 60, undefined, "pl_s:" );
	CreateDebugTextHud( "p_as", 20, 80, undefined, "p_as:" );
	CreateDebugTextHud( "p_tl", 20, 100, undefined, "p_tl:" );
	*/

	wait 0.05;	// let the anims start
	jumpstart_vol = GetEnt( "trig_player_chopperjump", "script_noteworthy" );
	ref_point = (1800,0,8112);
	/*/#
	thread draw_point_a_while( ref_point, 24, (1,0,0), 10 );
	#/*/
	base_time_to_jump = (380-210)/30;
	max_time_to_jump = base_time_to_jump + 1.5;		// adjust this to give the player more time to jump
	min_rate = base_time_to_jump/max_time_to_jump;
	max_rate = 1.2;
	anms = [];
	foreach (actor in actors)
	{
		anms[anms.size] = level.scr_anim[ actor.animname ][ "helo_jump_1" ];
	}
	panms = [];
	foreach (actor in pactors)
	{
		panms[panms.size] = level.scr_anim[ actor.animname ][ "helo_jump_1" ];
	}
	
	while (!flag( "finale_too_late_to_jump" ) && !flag( "finale_player_jump_start" ))
	{
		dist_to_jmp = Distance(level.player.origin, ref_point);
		speed = level.player.speed;
		anim_length = getAnimLength( anms[0] );
		anim_time =  actors[0] getAnimTime( anms[0] );
		anim_time *= anim_length;
		anim_time_to_jump = (( 380-210 )/30) - anim_time;
		rate = 1.0;
		if (anim_time_to_jump >= 0)
		{
			if (speed > 0)
			{
				time_to_reach_jmp = dist_to_jmp / speed;
				rate = anim_time_to_jump / time_to_reach_jmp;
			}
			else
			{
				rate = 0;	// force using the min_rate
			}
		}
		else
		{	// could adjust during the jump, but not now.
			flag_set( "finale_too_late_to_jump" );	// too late
		}
		if (rate < min_rate)
			rate = min_rate;
		if (rate >= max_rate)
			rate = max_rate;

		// update the anim rate for all of the target actors
		foreach (i, actor in actors)
		{
			actor SetAnim( anms[i], 1.0, 0.2, rate );
		}
		/*
		PrintDebugTextHud( "h_as", rate );
		PrintDebugTextHud( "h_tl", anim_time_to_jump );
		PrintDebugTextHud( "pl_s", speed );
		*/
		wait 0.05;
	}
	if (flag( "finale_too_late_to_jump" ))
	{	// reset rate to 1 if we failed
		foreach (i, actor in actors)
		{
			actor SetAnim( anms[i], 1.0, 0.2, 1.0 );
		}
	}
	else if (flag( "finale_player_jump_start" ))
	{	// need the two animating things to match at the end of the jump
		time_to_match = getAnimLength( panms[0] );
		anim_length = getAnimLength( anms[0] );
		anim_time_left =  anim_length * (1 - (actors[0] getAnimTime( anms[0] )));
		rate = anim_time_left / time_to_match;	// heli and friends time adjust
		foreach (i, actor in actors)
		{
			actor SetAnim( anms[i], 1.0, 0.2, rate );
		}
		time = time_to_match;
		while (time > 0)
		{
			anim_time_left =  anim_length * (1 - (actors[0] getAnimTime( anms[0] )));
			panim_time_left =  time_to_match * (1 - (pactors[0] getAnimTime( panms[0] )));
			if (panim_time_left > 0.1)
				rate = anim_time_left / panim_time_left;	// heli and friends time adjust
			
			foreach (i, actor in actors)
			{
				actor SetAnim( anms[i], 1.0, 0.2, rate );
			}
			/*
			PrintDebugTextHud( "h_as", rate );
			PrintDebugTextHud( "h_tl", anim_time_left );
			PrintDebugTextHud( "p_as", 1.0 );
			PrintDebugTextHud( "p_tl", panim_time_left );
			*/
			wait 0.05;
			time -= 0.05;
		}
	}
}

finale_jump_watcher()
{
	level endon( "player_jump_watcher_stop" );
	
	jumpflag = "player_jumping";
	if( !flag_exist( jumpflag ) )
	{
		flag_init( jumpflag );
	}
	else
	{
		flag_clear( jumpflag );
	}
	
	NotifyOnCommand( "playerjump", "+gostand" );
	NotifyOnCommand( "playerjump", "+moveup" );
	
	while( 1 )
	{
		level.player waittill( "playerjump" );
		flag_set( jumpflag );
		wait( 0.1 );  // jumps don't happen immediately
		
		while( !level.player IsOnGround() )
		{
			wait( 0.05 );
		}
		flag_clear( jumpflag );
	}
}

finale_chopper_waitfor_player_jump( chopper )
{
	// catch the jump
	jumpstart_vol = GetEnt( "trig_player_chopperjump", "script_noteworthy" );
	jumpForward = AnglesToForward( ( 0, 0, 0 ) );
	thread finale_jump_watcher();
	
	skid_origin = chopper getTagOrigin( "tag_guy1" );
	skid_origin = skid_origin;

	skid = spawn( "script_origin", skid_origin );
	skid LinkTo( chopper, "tag_guy1" );
	
	altLookSpots = GetStructArray( "struct_chopperjump_alt_lookspot", "targetname" );
	ASSERT( altLookSpots.size );
	
	while( 1 )
	{
		breakout = false;
		
		while( level.player IsTouching( jumpstart_vol ) )
		{
			flag_wait( "player_jumping" );
			if( finale_player_leaps_to_chopper_check( jumpstart_vol, skid, altLookSpots, chopper ) )
			{
				breakout = true;
				break;
			}
			wait( 0.05 );
		}
		
		if( breakout )
		{
			break;
		}
		wait( 0.05 );
	}
	
	//if chopper is too far, fail
	if( flag( "finale_too_late_to_jump" ) )
	{
		/#
			iprintln( "jump failed" );
		#/
		return;
	}
	
	/#
		iprintln( "jump successful" );
	#/
	
	flag_set( "finale_player_jump_start" );
	aud_send_msg("finale_se", "end_run");
	
}

finale_player_leaps_to_chopper_check( volume, skid, altLookSpots, chopper )
{
	
	if( !volume IsTouching( level.player ) )
	{
		return false;
	}
	
	if ( level.player GetStance() != "stand" )
	{
		return false;
	}
	
	if( level.player IsOnGround() )
	{
		return false;
	}
	
	// see if the player's velocity is sufficient and in the right direction
	target = chopper GetTagOrigin( "tag_guy1" );
	dir = VectorNormalize(target - level.player.origin);
	dp = VectorDot(dir,level.player.vel);
	if (dp < 100)
		return false;
		
	if (dir[2] < 0)
		return false;
		
	return true;
}

finale_jump_missed_check()
{
	level endon( "finale_player_jump_successful" );
	
	flag_wait( "finale_too_late_to_jump" );
	
	finale_makarov_escaped();
}

finale_makarov_escaped()
{
	SetDvar( "ui_deadquote", &"DUBAI_MAKAROV_ESCAPED_FINALE" );
	SetBlur( 30, 2 );
	missionfailedwrapper();
}

finale_should_break_hit_melee()
{
	return level.stabbed || level.stab_failure;
}

finale_should_break_hit_melee_yank()
{
	return level.yank || level.yank_failure;
}

finale_chopper_hint_and_catch_stab()
{
	anim_time = GetAnimLength( level.scr_anim[ "copilot" ][ "helo_jump_2" ] );
	time = 0;
	stab_warning_start = anim_time-1.5;
	level.stabbed = false;
	stab_hint_given = false;
	fade_time = 1;
	cur_time = 0;
	dir = 0;
	while (time < anim_time)
	{
		if (time > stab_warning_start)
		{	// display hint and check for melee
			if (!stab_hint_given)
			{
				stab_hint_given = true;
				level.hint_fontscale = 3;
				display_hint( "hint_stab_copilot" );
				level.hint_fontscale = undefined;
			}
			else
			{
				/*
				if (isdefined(level.current_hint) && (cur_time <= 0) )
				{
					if (dir == 0)
					{
						level.current_hint FadeOverTime( fade_time );
						level.current_hint.alpha = 0.0;
						level.current_hint ChangeFontScaleOverTime( fade_time );
						level.current_hint.fontScale = 0.25;
						cur_time = fade_time;
						dir = 1;
					}
					else
					{
					}
				}
				*/
			}
			if (level.player MeleeButtonPressed())
			{
				level.stabbed = true;
				return;
			}
		}
		time += 0.05;
		wait 0.05;
	}
}

finale_crash_site_wait_to_crash()
{
	self waittillmatch( "single anim", "crash" );
	
	aud_send_msg("chopper_crash_finale");
	
	white_overlay = finale_get_white_overlay();
	black_overlay = finale_get_black_overlay();
	level.player ShellShock( "dubai_ending_no_control", 2 );
	earthquake( 1, 2, level.player.origin,  8000 );
	level.player PlayRumbleOnEntity( "damage_heavy" );
	wait 0.5;
	white_overlay fadeOverTime( 0.05 );
	white_overlay.alpha = 1.0;
	wait 0.05;
	black_overlay fadeOverTime( 1 );
	black_overlay.alpha = 1.0;
	wait 1.0;
	white_overlay fadeOverTime( 1 );
	white_overlay.alpha = 0.0;
}


movie_loop()
{
	PauseCinematicInGame( 0 );
	while (true)
	{
		while (IsCinematicPlaying())
		{
			wait 0.5;
		}
		break;
		//CinematicInGame( "dubai_reflection" );
	}
}

test()
{
	self.org_origin = self.origin;
	self.org_angles = self.angles;
	offset = ( 3.5, -3.5, 0 );
	angoff = ( 0, 1, -.5 );
	while (true)
	{
		self.origin = self.org_origin + offset;
		self.angles = self.org_angles + angoff;
		wait 0.05;
	}
}

finale_get_black_overlay()
{
	overlay = get_black_overlay();
	overlay.sort = 1;
	return overlay;
}

finale_get_white_overlay()
{
	if (!isdefined(level.white_overlay))
	{
		overlay = newHudElem();
		overlay.x = 0;
		overlay.y = 0;
		overlay setshader( "white", 640, 480 );
		overlay.alignX = "left";
		overlay.alignY = "top";
		overlay.horzAlign = "fullscreen";
		overlay.vertAlign = "fullscreen";
		overlay.alpha = 0;
		overlay.sort = 2;
		level.white_overlay = overlay;
	}
	return level.white_overlay;
}

finale_crash_site_sequence()
{
	add_hint_string( "hint_get_the_gun", &"DUBAI_PRESS_DRAG_RIGHT", ::finale_should_break_get_the_gun );
	thread finale_chopper_crash_parts();
	
	flag_wait( "finale_chopper_crash_complete" );
	thread finale_player_setup();
	
	if (!isdefined(level.attack_button_q))
	thread monitor_button_presses();
	level.player FreezeControls( true );

	overlay = finale_get_black_overlay();	
	if (isdefined(level.debug_start_finale_crash_site) && level.debug_start_finale_crash_site)
	{
		overlay.alpha = 1.0; 
	}
	
	//trigger magic bullet to spawn decal
	thread maps\dubai_fx::crack_on_reflection_vfx();
	
//	wait blackout_time;
	aud_send_msg("finale_se","start_chopper_fire_amb");	


	mirror = getent( "roof_reflection", "targetname" );
	mirror thread test();
	level.player unlink();
	level.player teleport_player( getent( "finale_player_crash_location", "targetname" ) );
	
	time = gettime();
	thread autosave_by_name_silent( "finale_crash_site" );
	wait 0.1;	// give autosave a chance to set the flag
	flag_waitopen( "game_saving" );	// and wait for it to clear
	wait 0.1;	// for safety
	
	// priming the moving must come after the save finishes
	SetSavedDvar( "cg_cinematicFullScreen", "0" );
	CinematicInGame( "dubai_reflection", 1 );	// start it paused
	time2save = (gettime() - time)/1000;
	if (time2save > 2.5)
		wait 2.5;	// minimum time to prime
	else
		wait 5-time2save;
	
	finale_crash_site_makarov = getent( "finale_crash_site_makarov", "script_noteworthy" );
	finale_crash_site_makarov add_spawn_function( ::finale_crash_site_makarov_think );
	level.makarov = finale_crash_site_makarov spawn_ai( true );
	thread maps\dubai_fx::roof_heli_postcrash_fx();
	level notify("fx_mak_light");
	thread finale_crash_site_player();
	if (!isdefined(level.yuri))
	{
		yuri_spawner = getent( "yuri", "targetname" );
		yuri_spawner.script_noteworthy = "yuri";
		yuri_spawner thread remove_spawn_function( ::setup_yuri );
		yuri_spawner thread add_spawn_function( ::finale_crash_site_yuri_think );
		yuri_spawner spawn_ai( true );
	}
	else
	{
		level.yuri thread stop_magic_bullet_shield();
		level.yuri thread finale_crash_site_yuri_think();
	}
	
	
	level.player FreezeControls( false );
	
	level.player SetBlurForPlayer( 6, 0 );
	//level.player thread play_fullscreen_blood(33, 1, 5, 1);
	
	
	
	level.player thread play_fullscreen_blood_splatter_alt(20, 1, 8, 1);
	overlay restoreVision(1, 0);
	wait 0.05;
	level.player SetBlurForPlayer( 3, 0.5 );
	
	thread player_crawling_shell_shock();
}

player_crawling_shell_shock()
{
	wait 9.9;
	level.player ShellShock( "dubai_ending_crash_site", 28 );
}

finale_should_break_get_the_gun()
{
	return level.player.finale_moving;
}


is_button_pressed_since( button_q, dtime )
{
	reftime = gettime() + dtime;
	foreach ( button in button_q)
	{
		if (button > reftime)
			return true;	// may want to eat it.
	}
	return false;
}

is_attack_pressed_since( dtime )
{
	return is_button_pressed_since( level.attack_button_q, dtime );
}

is_use_pressed_since( dtime )
{
	return is_button_pressed_since( level.use_button_q, dtime );
}

monitor_button_presses()
{
	level endon("stop_monitor_button_presses");
	
	cur_attack = level.player AttackButtonPressed();
	cur_use = level.player UseButtonPressed();
	qsize = 3;
	level.attack_button_q = [];
	level.use_button_q = [];
	for (i=0; i<qsize; i++)
	{
		level.attack_button_q[i] = 0;
		level.use_button_q[i] = 0;
	}
	while (true)
	{
		attack = level.player AttackButtonPressed();
		if (!cur_attack && attack)
		{
			for (i=qsize-1; i>0; i--)
				level.attack_button_q[i] = level.attack_button_q[i-1];
			level.attack_button_q[0] = GetTime();
		}
		cur_attack = attack;
		use = level.player UseButtonPressed();
		if (!cur_use && use)
		{
			for (i=qsize-1; i>0; i--)
				level.use_button_q[i] = level.use_button_q[i-1];
			level.use_button_q[0] = GetTime();
		}
		cur_use = use;
		wait 0.05;
	}
}

hint_get_the_gun()
{
	pressed = is_attack_pressed_since( -500 );

	if ( pressed )
		return;	// hint not needed
	level.player.finale_moving = false;
	level.hint_fontscale = 3;
	display_hint_timeout( "hint_get_the_gun", 12 );
	level.hint_fontscale = undefined;
}

wait_for_forward( actor, anime, nohint, dontstopidle )
{
	pressed = is_attack_pressed_since( -500 );
	scripted_node = self;
	loop_started = false;
	if (!pressed)
	{
		scripted_node thread anim_loop_solo( actor, anime, "stop_player_loop" );
		loop_started = true;
		level.player.finale_moving = false;
		level.hint_fontscale = 3;
		if (!isdefined(nohint) || !nohint)
			display_hint_timeout( "hint_get_the_gun", 12 );
		while ( !pressed )
		{
			pressed = is_attack_pressed_since( -500 );
			wait 0.05;
		}
		level.hint_fontscale = undefined;
	}
	scripted_node notify( "stop_player_loop" );
	if (!isdefined(dontstopidle) || !dontstopidle)
		level.player.finale_moving = true;
	else
		level.player.finale_moving = false;
}

prep_wait_for_forward( player_rig, animname, idlename, dontstopidle )
{
	flag_clear("wait_for_forward_anim");
	flag_clear("wait_for_forward");
	scripted_node = self;
	anm = player_rig GetAnim( animname );
	totaltime = GetAnimLength( anm );
	desiredtime = totaltime - 0.4;
	hint_at_frac = desiredtime/totaltime;
	while ( player_rig GetAnimTime( anm ) < hint_at_frac )
		wait 0.05;
	
	pressed = is_attack_pressed_since( -100 );
	if (!pressed)
	{
		level.player.finale_moving = false;	// so the hint doesn't go away right away
		level.hint_fontscale = 3;
		display_hint_timeout( "hint_get_the_gun", 12 );
		level.hint_fontscale = undefined;
	}
	flag_wait("wait_for_forward_anim");
	scripted_node wait_for_forward( player_rig, idlename, false, dontstopidle );
	flag_set("wait_for_forward");
}

finale_crash_site_player()
{
	level endon("player_dies");
	player_rig = spawn_anim_model( "player_rig", (0, 0, 0) );
	player_rig thread setup_player_rig_notetracks();
//player_rig thread draw_ent_tag_origin( );
	level.player_rig = player_rig;
	level.player playerlinktoblend( player_rig, "tag_player", 0.2 );
	scripted_node = getent( "finale_scripted_node", "targetname" );
	anime = "finale_wake";
	scripted_node anim_teleport_solo( player_rig, anime );
	animlen = GetAnimLength( player_rig GetAnim( anime ) );
	delaythread( animlen-1, ::hint_get_the_gun );
//thread finale_test_reflection();
	thread movie_loop();		// start the movie at the same time as the player's wake
	player_rig thread finale_wake_dof_control();
	scripted_node anim_single_solo( player_rig, anime );
	aud_send_msg("finale_se", "end_helo_sequence");
	
	flag_init("wait_for_forward");
	flag_init("wait_for_forward_anim");
	level.crawl_idx = 1;
	level.crawl_animbase = "finale_crawl0";
	scripted_node wait_for_forward( player_rig, "finale_wake_idle", true );
	thread finale_crash_site_slowdown_crawl_test();
	aud_send_msg("finale_se", "start_crawl");
	scripted_node thread prep_wait_for_forward( player_rig, level.crawl_animbase+level.crawl_idx, "finale_crawl01_idle" );
	scripted_node anim_single_solo( player_rig, level.crawl_animbase+level.crawl_idx );
	flag_set("wait_for_forward_anim");
	flag_wait("wait_for_forward");
	level.crawl_idx++;
	scripted_node thread prep_wait_for_forward( player_rig, level.crawl_animbase+level.crawl_idx, "finale_crawl02_idle" );
	scripted_node anim_single_solo( player_rig, level.crawl_animbase+level.crawl_idx );
	flag_set("wait_for_forward_anim");
	flag_wait("wait_for_forward");
	level.crawl_idx++;
	scripted_node thread prep_wait_for_forward( player_rig, level.crawl_animbase+level.crawl_idx, "finale_crawl03_idle", level.player_dies );
	scripted_node anim_single_solo( player_rig, level.crawl_animbase+level.crawl_idx );
	flag_set("wait_for_forward_anim");
	flag_wait("wait_for_forward");
	level.crawl_idx++;
	flag_set( "player_started_draw" );
	level notify("crawling_finished");
	if (isdefined(level.player_dies) && level.player_dies)
	{	// start the last fail crawl, which has an additive that get's turned on at the appropriate time
		scripted_node thread finale_crash_final_crawl_player_blend( level.player_rig );
		scripted_node thread anim_single_solo( level.player_rig, "finale_draw_fail" );
		blendanms = level.player_rig getanim("finale_draw_fail_blend");
		player_rig SetFlaggedAnimKnobRestart( "single anim", blendanms[0], 1.0, 0.2, 1.0 );
		player_rig thread finale_crash_crawl_idx_monitor( blendanms );
		wait GetAnimLength(blendanms[0]);
		return;
	}
	aud_send_msg("finale_se", "start_showdown");
	scripted_node anim_single_solo( player_rig, "finale_draw" );
	flag_wait("start_finale_showdown");
	scripted_node thread anim_single_solo(player_rig, "finale_showdown");
	
	player_rig thread finale_crash_site_showdown_slowmo();
}

finale_wake_dof_control()
{
//	level.player SetBlurForPlayer( 5.0, 0);
	self waittillmatch("single anim", "dof_on");	// wait for focus near
	self waittillmatch("single anim", "dof_off"); // wait for focus far
	level.player SetBlurForPlayer( 0.0, 0.5);
	/*
	level.level_specific_dof = true;
	// start out focused mid, before focusing on reflection
	startDOF = level.dofDefault;
	dof_wake = [];
	dof_wake[ "nearStart" ] = .1;
	dof_wake[ "nearEnd" ] = 1.0;
	dof_wake[ "nearBlur" ] = 6.0;
	dof_wake[ "farStart" ] = 360;
	dof_wake[ "farEnd" ] = 480;
	dof_wake[ "farBlur" ] = 1.0;
	level thread update_dof();
	level.dofDefault = dof_wake;
	
	self waittillmatch("single anim", "dof_on");	// wait for focus near
	start = level.dofDefault;	
	dof_wake_near = [];
	dof_wake_near[ "nearStart" ] = .1;
	dof_wake_near[ "nearEnd" ] = 0.0;
	dof_wake_near[ "nearBlur" ] = 4.0;
	dof_wake_near[ "farStart" ] = 240;
	dof_wake_near[ "farEnd" ] = 480;
	dof_wake_near[ "farBlur" ] = 4.0;
	blend_dof( start, dof_wake_near, 0.5 );
	
	self waittillmatch("single anim", "dof_off"); // wait for focus far
	start = level.dofDefault;	
	dof_wake_far = [];
	dof_wake_far[ "nearStart" ] = 0.1;
	dof_wake_far[ "nearEnd" ] = 0.0;
	dof_wake_far[ "nearBlur" ] = 6.0;
	dof_wake_far[ "farStart" ] = 4800;
	dof_wake_far[ "farEnd" ] = 7200;
	dof_wake_far[ "farBlur" ] = 6.0;
	blend_dof( start, dof_wake_far, 0.5 );
	wait 8;
	blend_dof( dof_wake_far, startDOF, 5.0 );
	*/
}

finale_crash_crawl_idx_monitor( blendanms )
{
	track = getnotetracktimes( blendanms[1], "faila" );
	ntrack[0] = track[0];
	track = getnotetracktimes( blendanms[1], "failb" );
	ntrack[1] = track[0];
	track = getnotetracktimes( blendanms[1], "failc" );
	ntrack[2] = track[0];
	level.finale_start = 0;
	level.finale_end = ntrack[0];
	idx = 0;
	prvpos = 0;
	lastrefanm = level.player_rig GetAnim( "finale_draw_fail" );
	
	while (idx < ntrack.size)
	{
		pos = self GetAnimTime( lastrefanm );
		if ((prvpos <= ntrack[idx]) && (ntrack[idx] < pos))
		{
			level.crawl_idx++;
			idx++;
			if (idx < ntrack.size)
			{
				level.finale_start = level.finale_end;
				level.finale_end = ntrack[idx];
			}
		}
		prvpos = pos;
		wait 0.05;
	}
}

finale_crash_final_crawl_player_blend( player_rig )
{
	flag_wait( "finale_crawl_lookup");
	wait 0.05;	// ensure the animation has started if this is immediate
	anm = player_rig getanim("finale_draw_fail");
	animpos = player_rig GetAnimTime( anm );
	blendanms = player_rig getanim("finale_draw_fail_blend");
	player_rig SetFlaggedAnimKnob( "single anim", blendanms[1], 1.0, 0.5, 1.0 );
	player_rig SetAnimTime( blendanms[1], animpos );
}

finale_crash_site_test_notetrack( anime, notetrack )
{
	anm = self getanim( anime );
	tracks = getnotetracktimes( anm, notetrack );
	assert( isdefined(tracks));
}

finale_crash_site_showdown_slowmo( notetrack, speed, lerp_in_time, lerp_out_time )
{
	start = "slowmo_start";
	end = "slowmo_end";
	if (!isdefined(speed))
		speed = 0.4;
	if (isdefined(notetrack))
	{
		start = notetrack + "_start";
		end = notetrack + "_end";
	}
	if( !isdefined( lerp_in_time ) )
		lerp_in_time = 0;
	if( !isdefined( lerp_out_time ) )
		lerp_out_time = 0.25;
	
	self waittillmatch( "single anim", start );
	slowmo_setspeed_slow( speed );
	slowmo_setlerptime_in( lerp_in_time );
	slowmo_setlerptime_out( lerp_out_time );
	
	slowmo_lerp_in();
	self.in_slowmo = true;
	
	self waittillmatch( "single anim", end );
	slowmo_lerp_out();
	self.in_slowmo = false;
}

finale_crash_site_slowdown_crawl_test()
{
	slowmo_setspeed_slow( .85 );
	slowmo_setlerptime_in( 0 );
	slowmo_setlerptime_out( .0 );
	
	slowmo_lerp_in();
	level waittill("crawling_finished");
	slowmo_lerp_out();
}

finale_crash_site_yuri_think()
{
	level.yuri = self;
	
	self.animname = "yuri";
	scripted_node = getent( "finale_scripted_node", "targetname" );
	scripted_node anim_teleport_solo( self, "finale_showdown" );
	self gun_remove();
	wait 1;
	self forceUseWeapon( "usp", "primary" );	

	flag_wait("start_finale_showdown");
	thread maps\dubai_fx::showdown_vfx();
	thread maps\dubai_fx::showdown_yuri_vfx();
	scripted_node anim_single_solo( self, "finale_showdown" );
	//self Delete();
}

finale_crash_site_gun( gun, makarov )
{
	scripted_node = self;
	scripted_node anim_single_solo( gun, "finale_draw" );
	tag = "j_wrist_ri";
	gun linkto( makarov, tag );
	makarov anim_single_solo( gun, "finale_draw02", tag);
}

finale_crash_site_makarov_think()
{
	//climb out of wreckage and shoot at player
	//finale_makarov_crash_location = getent( "finale_makarov_crash_location", "targetname" );
	//self teleport_ai( finale_makarov_crash_location );
	aimref_actors = [];
	for (j=0; j<2; j++)
	{
	for (i=0; i<5; i++)
	{
			level.makarov_aimref[j][i] = spawn_anim_model( "makarov" );
			level.makarov_aimref[j][i] Hide();
			aimref_actors[j][i][0] = level.makarov_aimref[j][i];
		}
	}
	self.animname = "makarov";
	level.makarov = self;
	level.makarovs[0] = self;
	level.makarovs[1] = spawn_anim_model( "makarov" );
	level.makarovs[1] Hide();
	self gun_remove();	// we'll use an animated gun for Makarov
	scripted_node = getent( "finale_scripted_node", "targetname" );
	gun = spawn_anim_model("deagle");
	level.gun = gun;
	level.gun HidePart( "TAG_SILENCER" );
	level.gun HidePart( "TAG_KNIFE" );
	level.guns[0] = gun;
	level.guns[1] = spawn_anim_model("deagle");
	level.guns[1] HidePart( "TAG_SILENCER" );
	level.guns[1] HidePart( "TAG_KNIFE" );
	level.guns[1] Hide();
	scripted_node anim_first_frame_solo( gun, "finale_draw" );
	actors[0] = self;
	
	anime = "finale_wake";
	scripted_node anim_teleport_solo( level.makarov, anime );
	self linkto( scripted_node );
	scripted_node anim_single_solo( level.makarov, anime );
	// idle here as long as we need for tuning
	if (!flag( "player_started_draw" ))
	{
		scripted_node thread anim_loop_solo( level.makarov, "finale_wake_idle", "makarov_loop" );
		time = 3.0;
		while ( !flag( "player_started_draw" ) && (time >= 0) )
		{
			time -= 0.05;
			wait 0.05;
		}
		scripted_node notify( "makarov_loop" );
	}
	player_dies = !flag( "player_started_draw" );
	level.player_dies = player_dies;
	flag_set( "vo_finale_roof_start" );
	if (player_dies)
	{	// player fail case
		level notify("crawling_finished");	// stops the slowmo used to tune length of scene
		level.crawl_animbase = "finale_fail_crawl0";	// only play the fail crawls now
		aud_send_msg("finale_se", "fail_crawl");
		
		level.player ShellShock( "dubai_ending_crash_site", 40 );
		
		actors[1] = gun;
		// if we didn't have an anim, we'd still let the
		anime = "finale_draw_fail";
		blendanims = actors[0] getanim( "finale_draw_fail_blend" );
		level.makarovs_fail_anm = actors[0] getanim( anime );
		actors[0] thread finale_last_crawl_wait_to_lookup();	// always start this, since we may reach the last crawl during the anim
		anm = gun getanim( anime );
		tracks = getnotetracktimes( anm, "mfire" );
		firetime = tracks[0]*getanimlength(anm);
		for (i=0; i<5; i++)
			scripted_node thread anim_single( aimref_actors[0][i], anime );	// play the base anim on our aimrefs
		wait 0.05; // allow prediction
		scripted_node thread anim_single( actors, anime );
		self thread finale_chopper_crash_aim_blend2( 0 );
		//self thread finale_chopper_crash_fail_stopcrawl();
		gun thread finale_chopper_crash_fail_gunfire(firetime);
		aud_send_msg("makarov_fail_getgun");
		//gun waittillmatch( "single anim", "mfire" );
		wait firetime;
		level.player.finale_moving = true;	// just to make any hint go away
		finale_shot_death( &"DUBAI_MAKAROV_KILLED_YOU" );
	}
	scripted_node  thread finale_crash_site_gun( gun, level.makarov );
	scripted_node anim_single_trans( actors, "finale_draw", 1.0 );
	// determine fail state here based on how long it took the player
	flag_set( "start_finale_showdown" );
	thread finale_chopper_start_button_mash( scripted_node );
	thread autosave_by_name_silent( "finale_showdown" );
	level.makarov thread anim_single_solo_trans( gun, "finale_showdown", 0, "j_wrist_ri" );
	scripted_node anim_single_trans( actors, "finale_showdown", 0 );
	gun unlink();
	flag_set( "end_finale_showdown" );
	aud_send_msg("finale_se", "end_showdown");
	
	
	
//	flag_set( "level_end" );
}

finale_last_crawl_wait_to_lookup()
{
	tracks = GetNotetrackTimes( level.makarovs_fail_anm, "stopcrawl" );
	length = GetAnimLength( level.makarovs_fail_anm );
	wait length*tracks[0] - (40/30);
	//self waittillmatch("single anim", "lookup");
	flag_set( "finale_crawl_lookup" );
}

get_delta_angles( from, to )
{
	dp = AngleClamp180(to[0]) - AngleClamp180(from[0]);
	dp = AngleClamp180(dp);
	dy = AngleClamp180(to[1]) - AngleClamp180(from[1]);
	dy = AngleClamp180(dy);
	return (dp,dy,0);
}

create_plane( pt0, pt1, pt2 )
{
	d0 = pt1 - pt0;
	d1 = pt2 - pt0;
	normal = VectorCross( d0, d1 );
	normal = VectorNormalize(normal);
	d = VectorDot( normal, pt0 );
/*
//start = pt0 + pt1;
//start = start + pt2;
//start = (1/3)*start;
//line( start, start+ 24*normal, (1,1,0) );

line( pt0, pt1, (0,0,1) );
line( pt0, pt2, (0,0,1) );
line( pt2, pt1, (0,0,1) );
*/
	return [ normal, d ];
}

test_plane( plane, pt )
{
	d = VectorDot( plane[0], pt );
	if (d >= plane[1])
		return 1;
	else
		return -1;
}

project_to_plane( pt, plane )
{
	d = VectorDot( plane[0], pt );
	d -= plane[1];
	pt = pt - d*plane[0];
	return pt;
}

line_plane_intersect( pt, dir, plane )
{
	dp = VectorDot( dir, plane[0] );
	if (dp == 0)
		return (0,0,0);	// no intersection
	
	pl_pt = plane[1] * plane[0];
	t = VectorDot((pl_pt - pt), plane[0] )/dp;
	pl_pt = pt + t*dir;
	return pl_pt;
}

calc_barycentric_coords( p0, p1, p2, tgt )
{
	m[0][0] = p0[0]; m[0][1] = p0[1]; m[0][2] = p0[2];
	m[1][0] = p1[0]; m[1][1] = p1[1]; m[1][2] = p1[2];
	m[2][0] = p2[0]; m[2][1] = p2[1]; m[2][2] = p2[2];
	
	det = 	m[0][0]*(m[2][2]*m[1][1] - m[2][1]*m[1][2])
		-	m[0][1]*(m[2][2]*m[1][0] - m[1][2]*m[2][0])
		+	m[0][2]*(m[2][1]*m[1][0] - m[1][1]*m[2][0]);
	if (det != 0)
	{
		ood = 1.0/det;
		i[0][0] =    ood*(m[2][2]*m[1][1] - m[2][1]*m[1][2]);
			i[0][1] = -1*ood*(m[2][2]*m[0][1] - m[2][1]*m[0][2]);
				i[0][2] =    ood*(m[1][2]*m[0][1] - m[1][1]*m[0][2]);
		
		i[1][0] = -1*ood*(m[2][2]*m[1][0] - m[2][0]*m[1][2]);
			i[1][1] =    ood*(m[2][2]*m[0][0] - m[2][0]*m[0][2]);
				i[1][2] = -1*ood*(m[1][2]*m[0][0] - m[1][0]*m[0][2]);

		i[2][0] =    ood*(m[2][1]*m[1][0] - m[2][0]*m[1][1]);
			i[2][1] = -1*ood*(m[2][1]*m[0][0] - m[2][0]*m[0][1]);
				i[2][2] =    ood*(m[1][1]*m[0][0] - m[1][0]*m[0][1]);
		
		// now we have the inverse
		axis = undefined;
		orgaxis = undefined;
		for (j=0; j<3; j++)
		{
			axis[j]		= (i[0][j], i[1][j], i[2][j]);
			orgaxis[j]	= (m[j][0], m[j][1], m[j][2]);
		}
		n[0] = ( VectorDot(orgaxis[0],axis[0]), VectorDot(orgaxis[0],axis[1]), VectorDot(orgaxis[0],axis[2]) );
		n[1] = ( VectorDot(orgaxis[1],axis[0]), VectorDot(orgaxis[1],axis[1]), VectorDot(orgaxis[1],axis[2]) );
		n[2] = ( VectorDot(orgaxis[2],axis[0]), VectorDot(orgaxis[2],axis[1]), VectorDot(orgaxis[2],axis[2]) );
		
		b = (VectorDot(axis[0],tgt), VectorDot(axis[1],tgt), VectorDot(axis[2],tgt) );
		t = b[0]*p0 + b[1]*p1 + b[2]*p2;
		return b;
	}
	else
		return (1,0,0);
}

finale_chopper_crash_aim2( makarov, gun, makarov_aimref, basey )
{
/*
if (!isdefined(basey))
	basey = 60;
labels=["ctr", "dwn", "up ", "lft", "rgt" ];
for (i=0; i<5; i++)
	CreateDebugTextHud( "weight"+i, 40, basey+i*20, undefined, labels[i]+"=" );
*/
	pos_tag = "tag_flash";

	anms = self GetAnim("finale_draw_fail_blend");
	baseanm = self GetAnim("finale_draw_fail");
	
	weight = 0;
	transtime = 0.5;
	while (true)
	{
		ref_origins = [];
		ref_angles = [];
		ref_dirs = [];
		cur_origin = makarov GetTagOrigin( pos_tag );
		// get our target, which is the camera
		height = level.player GetPlayerViewHeight();
		player_eye = level.player.origin + ( 0, 0, height );	// aim for the head
		desired_gun_dir = player_eye - cur_origin;		// this may need to change due to the gun actually moving from the aiming
		cur_gun_angles = makarov GetTagAngles( pos_tag );
		cur_gun_dir = AnglesToForward(cur_gun_angles);
		target = player_eye;
		// determine the distance to the target, so we can use that as our projection basis
		dist = Length( desired_gun_dir );
	for (i=0; i<5; i++)
	{
			ref_origins[i] = makarov_aimref[i] GetTagOrigin( pos_tag );
			ref_angles[i] = makarov_aimref[i] GetTagAngles( pos_tag );
			ref_dirs[i] = dist*AnglesToForward(ref_angles[i]);
		}
	/*
	for (i=0; i<5; i++)
	{
		line( ref_origins[i], ref_origins[i] + ref_dirs[i], (0,1,0) );
	}
	
	line( ref_origins[0], player_eye, (1,0,0) );
	line( cur_origin, cur_origin + dist*cur_gun_dir, (1,1,1) );
	*/
		// calculate the planes defining the quadrants
		center_end = ref_origins[0] + ref_dirs[0];
		planes[0] = create_plane( ref_origins[0], center_end, ref_origins[1] );	// dwn plane
		planes[1] = create_plane( ref_origins[0], center_end, ref_origins[2] );	// up plane
		planes[2] = create_plane( ref_origins[0], center_end, ref_origins[3] );	// lft plane
		planes[3] = create_plane( ref_origins[0], center_end, ref_origins[4] );	// rgt plane
		quadmap = [ [0,2], [0,3], [1,2], [1,3] ];
		quadsign = [ [1,-1], [-1,1], [-1,1], [1,-1] ];
		// get which side of each plane the point is on
		side = [];
		for (p=0; p<4; p++)
			side[p] = test_plane( planes[p], target );
		// for each quadrant determine if the target point is in that quadrant
		map = undefined;
		for (quad = 0; quad<4; quad++)
		{
			map = quadmap[quad];
			sign = quadsign[quad];
			value = side[map[0]]*sign[0];
			if (value > 0)
			{
				value = side[map[1]]*sign[1];
				if (value > 0)
					break;
			}
		}
		weights = [1,0,0,0,0];	// default is 100% on the center
		if (quad < 4)
		{
		// now we determine if the point is inside the bounding plane
		/*
		pt0 = ref_origins[map[0]+1];
		pt1 = ref_origins[map[1]+1];
		pt2 = pt0 + ref_dirs[map[0]+1];
		bounding_plane = create_plane( pt0, pt1, pt2 );
		sign = test_plane( bounding_plane, target );
		if (sign < 0)
		{	// project point back onto the plane using a line to the closest point on the center line
			
		}
		*/
		// create the end plane, then project the target onto it.
		//  we'll use the triangle on that plane to determine the weights
		pt0 = ref_origins[0] + ref_dirs[0];
		pt1 = ref_origins[map[0]+1] + ref_dirs[map[0]+1];
		pt2 = ref_origins[map[1]+1] + ref_dirs[map[1]+1];
		end_plane = create_plane( pt0, pt1, pt2 );
			target = line_plane_intersect( target, ref_dirs[0], end_plane );
			//target = project_to_plane( target, end_plane );
			/#
		//	draw_point( target, 12, (1,0,1) );
			#/
		b = calc_barycentric_coords( pt0, pt1, pt2, target );
		weights[0] = b[0];
		weights[map[0]+1] = b[1];
		weights[map[1]+1] = b[2];
			total = 0;
		for (i=0; i<5; i++)
		{
			if (weights[i] < 0)
				weights[i] = 0;
				total += weights[i];
			}
			if (total > 0)
			{
				for (i=0; i<5; i++)
					weights[i] = weights[i]/total;
			}
		}
		animpos = self GetAnimTime( baseanm );
		for (i=0; i<5; i++)
		{
	//		PrintDebugTextHud( "weight"+i, weights[i] );
			self SetAnim( anms[i], weights[i], transtime, 1.0 );
			self SetAnimTime( anms[i], animpos );
		}
		transtime -= 0.10;
		if (transtime < 0.05)
			transtime = 0.05;
		wait 0.05;
	}
	/*
	for (i=0; i<5; i++)
		DeleteDebugTextHud( "weight"+i);
	*/
}

finale_chopper_crash_aim( makarov, gun, makarov_aimref, basey )
	{
/*
if (!isdefined(basey))
	basey = 60;
labels=["ctr", "dwn", "up ", "lft", "rgt" ];
for (i=0; i<5; i++)
	CreateDebugTextHud( "weight"+i+"_"+basey, 40, basey+i*20, undefined, labels[i]+"=" );
CreateDebugTextHud( "err_"+basey, 40, basey+5*20, undefined, "err=" );
*/
	pos_tag = "j_shoulder_ri";

	anms = self GetAnim("finale_draw_fail_blend");
	baseanm = self GetAnim("finale_draw_fail");
	max_angle = 30;
	err = (0,0,0);
	
	test = 1;
	testidx = 0;
	weight = 0;
	transtime = 0.5;
	while (true)
	{
		ref_origins = [];
		ref_angles = [];
		ref_dirs = [];
		cur_origin = makarov GetTagOrigin( pos_tag );
		for (i=0; i<5; i++)
		{
			ref_origins[i] = makarov_aimref[i] GetTagOrigin( pos_tag );
		//ref_origins[i] = cur_origin;
			ref_angles[i] = makarov_aimref[i] GetTagAngles( "tag_flash" );
			ref_dirs[i] = 120*AnglesToForward(ref_angles[i]);
		}
		// get our target, which is the camera
		height = level.player GetPlayerViewHeight();
		player_eye = level.player.origin + ( 0, 0, height-6 );	// aim for the chest
		desired_gun_dir = player_eye - cur_origin;		// this may need to change due to the gun actually moving from the aiming
		cur_gun_angles = makarov GetTagAngles( "tag_flash" );
		cur_gun_dir = AnglesToForward(cur_gun_angles);
	/*
	for (i=0; i<5; i++)
	{
		line( ref_origins[i], ref_origins[i] + ref_dirs[i], (0,1,0) );
	}
	
	line( ref_origins[0], player_eye, (1,0,0) );
	line( cur_origin, cur_origin + 120*cur_gun_dir, (1,1,1) );
	*/
		
		angles = VectorToAngles( desired_gun_dir );
		d = get_delta_angles( ref_angles[0], angles );
		dpitch = d[0];
		dyaw = d[1];
		vi = 0;
		dv = undefined;
		hi = 0;
		dh = undefined;
		
		weights = [0,0,0,0,0]; // ctr, dwn, up, lft, rgt
		if (test)
		{
		if (dpitch > 0)
			vi = 1;
		else
			vi = 2;
		if (dyaw > 0)
			hi = 3;
		else
			hi = 4;
		retry = 1;
		combo=0;
		best_weights = [0,0,0,0,0]; // ctr, dwn, up, lft, rgt
		best_combo = -1;
		best_sum = 100000;
		while (retry && (combo < 4))
		{
			weights = [0,0,0,0,0]; // ctr, dwn, up, lft, rgt
			if ((combo & 1) == 0)
				vi = 1;
			else
				vi = 2;
			if ((combo & 2) == 0)
				hi = 3;
			else
				hi = 4;
			dv = get_delta_angles( ref_angles[0], ref_angles[vi] );
			dh = get_delta_angles( ref_angles[0], ref_angles[hi] );
			m[0][0] = dv[0];
			m[0][1] = dv[1];
			m[1][0] = dh[0];
			m[1][1] = dh[1];
			det = m[0][0]*m[1][1] - m[0][1]*m[1][0];
			retry=0;
			if (det != 0)
			{
				im[0][0] = (1/det)*m[1][1];
				im[0][1] = (-1/det)*m[0][1];
				im[1][0] = (-1/det)*m[1][0];
				im[1][1] = (1/det)*m[0][0];
				weights[vi] = im[0][0]*d[0] + im[1][0]*d[1];
				if ((weights[vi] < 0) || (1 < weights[vi]))
				{
					retry = 1;
				}
				weights[hi] = im[0][1]*d[0] + im[1][1]*d[1];
				if ((weights[hi] < 0) || (1 < weights[hi]))
				{
					retry = 1;
				}
				dt = weights[vi]*dv + weights[hi]*dh;
				err = dt-d;
				if (retry)
				{
					if ((weights[vi] >= 0) && (weights[hi] >= 0))
					{
						sum = weights[0]+weights[1]+weights[2]+weights[3]+weights[4];
						if (sum < best_sum)
						{
							best_weights = weights;
							best_combo = combo;
							best_sum = sum;
						}
					}
				}
			}
			else
				retry = 1;
			combo++;
		}
		if (retry)
		{
			weights = best_weights;
			if ((best_combo & 1) == 0)
				vi = 1;
			else
				vi = 2;
			if ((best_combo & 2) == 0)
				hi = 3;
			else
				hi = 4;
		}
		if (weights[vi] < 0)
			weights[vi] = 0;
		if (weights[hi] < 0)
			weights[hi] = 0;
		}
		else
		{
			weights[testidx]=1;
		}
		total = weights[hi] + weights[vi];
		if (total < 1)
			weights[0] = 1-total;
		animpos = self GetAnimTime( baseanm );
		for (i=0; i<5; i++)
		{
		//	PrintDebugTextHud( "weight"+i+"_"+basey, weights[i] );
			self SetAnim( anms[i], weights[i], transtime, 1.0 );
			self SetAnimTime( anms[i], animpos );
		}
	//	PrintDebugTextStringHud( "err_"+basey, "("+err[0]+","+err[1]+")" );
		transtime -= 0.05;
		if (transtime < 0.05)
			transtime = 0.05;
		wait 0.05;
	}
	/*
	for (i=0; i<7; i++)
		DeleteDebugTextHud( "weight"+i+"_"+basey);
	DeleteDebugTextHud( "err_"+basey);
	*/
}

finale_chopper_crash_aim_blend2( idx )
{
	
	anms = level.makarovs[idx] GetAnim("finale_draw_fail_blend");
	baseanm = level.makarovs[idx] GetAnim("finale_draw_fail");
	tracks = GetNotetrackTimes( baseanm, "aimblend" );
	time = tracks[0] * GetAnimLength( baseanm );
	ppretime = 2.1;
	pretime = 1.8;
	time -= pretime;
	// set blend for all of our reference makarovs
	for (i=0; i<5; i++)
	{
		level.makarov_aimref[idx][i] SetAnimRestart( anms[i], 1.0, 0.0, 1.0 );
	}
	level.makarovs[idx] SetAnimRestart( anms[0], 1.0, 0.2, 1.0 );
	while (time > 0)
	{
		for (i=0; i<5; i++)
		{
			level.makarov_aimref[idx][i] SetAnim( anms[i], 1.0, 0.0, 1.0 );
		}
		level.makarovs[idx] SetAnim( anms[0], 1.0, 0.2, 1.0 );
		wait 0.05;
		time -= 0.05;
	}
	level.guns[idx] StopAnimScripted();
	tag = "j_wrist_ri";
	level.guns[idx] linkto( self, tag);
	for (i=0; i<5; i++)
	{
		model = "viewmodel_desert_eagle_sp_dubai_finale";
		level.makarov_aimref[idx][i] attach( model, tag );
		level.makarov_aimref[idx][i] HidePart( "TAG_SILENCER", model );
		level.makarov_aimref[idx][i] HidePart( "TAG_KNIFE", model );
	}
	if (idx == 0)
		thread test_adjusting_gun();
	wait ppretime;
self thread finale_chopper_crash_aim2( level.makarovs[idx], level.guns[idx], level.makarov_aimref[idx] );
//	wait pretime;
//	self thread finale_chopper_crash_aim( level.makarovs[idx], level.guns[idx], level.makarov_aimref[idx] );
}

test_adjusting_gun()
{
	tag = "j_wrist_ri";
	//level.makarovs[0] thread draw_ent_tag_origin( tag );
	level.guns[0] Hide();
	model = "viewmodel_desert_eagle_sp_dubai_finale";
	level.makarovs[0] attach( model, tag );
	level.makarovs[0] HidePart( "TAG_SILENCER", model );
	level.makarovs[0] HidePart( "TAG_KNIFE", model );
	/*
	while (true)
	{
		level.guns[0] unlink();
		level.guns[0].origin = level.guns[1].origin;
		level.guns[0] linkto( level.makarovs[0], tag );
		wait 0.05;
	}
	*/
}

finale_chopper_crash_fail_stopcrawl()
{
	self waittillmatch( "single anim", "stopcrawl" );
	level notify("player_dies");		// send this again, to kill any anim we let the player trigger to make him feel better
}

finale_chopper_crash_fail_gunfire( waittime )
{
	if (isdefined(waittime))
		wait waittime;
	else
		self waittillmatch( "single anim", "mfire" );
	// fire fx for the gun which is self are here
}

finale_chopper_stop_camera_additive()
{
	level notify("release_camera");
	addanm = level.player_rig GetAnim("beatdown_additive");
	level.player_rig SetAnim(addanm,0.0,0.2,1.0);
}

finale_chopper_force_camera_additive()
{
	level endon("release_camera");
	addanm = level.player_rig GetAnim("beatdown_additive");
	while (true)
	{
		level.player_rig SetAnim(addanm,1.0,0.5,1.0);
		wait 0.05;
	}
}
finale_chopper_start_button_mash( scripted_node )
{
	wait 3;		// should be a notetrack
	// start the additive camera loop
	thread finale_chopper_force_camera_additive();
	thread use_hint_blinks();
	finale_beatdown_button_count( 2 );
	scripted_node thread finale_beatdown_player( );
}

finale_chopper_crash_parts()
{
	//Hide parts initially
	finale_chopper_crash_parts = getentarray( "finale_chopper_crash_parts", "targetname" );
	array_call( finale_chopper_crash_parts, ::hide );
	
	//Hide off spotlight initially
	finale_spotlight_off = getentarray( "finale_spotlight_off", "targetname" );
	array_call( finale_spotlight_off, ::hide );
	
	flag_wait( "finale_chopper_crash_complete" );
	
	//Show parts after crash
	array_call( finale_chopper_crash_parts, ::show );
	
	//Hide on spotlight and show off one
	finale_spotlight_on = getentarray( "finale_spotlight_on", "targetname" );
	array_call( finale_spotlight_on, ::hide );
	array_call( finale_spotlight_off, ::show );
	
	getent( "finale_chopper_rotor", "script_noteworthy" ) thread finale_chopper_crash_rotor_spin();
	
	//remove vase near the downed chopper
	finale_roof_vase = getentarray( "finale_roof_vase", "script_noteworthy" );
	array_call( finale_roof_vase, ::delete );
}

finale_chopper_crash_rotor_spin()
{
	self thread maps\dubai_fx::roof_heli_blade_fire();
	while(1)
	{
		self AddPitch(2);
		wait(0.05);
	}	
}

finale_test_reflection()
{
	scripted_node = getent( "finale_scripted_node", "targetname" );
	
	anime = "finale_reflection_test";
	// use makarov for now
	yourself = spawn_anim_model("price");
	yourself attach( level.scr_head["price"] );
	
	actors[0] = yourself;
	yourself Hide();
	scripted_node anim_first_frame( actors, anime );

	yourself Show();
	while (true)
	{
		scripted_node anim_first_frame( actors, anime );
		scripted_node anim_single( actors, anime );
	}	
}


finale_capture_reflection()
{
	scripted_node = getent( "finale_scripted_node", "targetname" );
	background = getent( "reflection_background", "targetname" );
	background.origin = background.origin + (0,0,120);
	background show();
	skylights = getentarray( "reflection_sky_light", "script_noteworthy" );
	foreach ( skylight in skylights)
		skylight Hide();
	
	anime = "finale_reflection";
	player_rig = spawn_anim_model( "player_rig", (0, 0, 0) );
	player_rig thread setup_player_rig_notetracks();
	level.player playerlinktoblend( player_rig, "tag_player", 0.0 );
	yourself = spawn_anim_model("price");
	yourself attach( level.scr_head["price"] );
	level.player disableweapons();
	
	actors[0] = player_rig;
	actors[1] = yourself;
	yourself Hide();
	scripted_node anim_first_frame( actors, anime );
	CreateDebugTextHud( "countdown", 300, 300, (1,1,1), "", 5 );
	visionsetnaked( "dubai_roof_nobloom", 0.0 );

	while (true)
	{
		PrintDebugTextStringHud( "countdown", "3" );
		time=1;
		while (time > 0)
		{
			level.player playerlinktoblend( player_rig, "tag_player", 0.0 );
			wait 0.05;
			time -= 0.05;
		}
		PrintDebugTextStringHud( "countdown", "2" );
		wait 1;
		PrintDebugTextStringHud( "countdown", "1" );
		wait 1;
		PrintDebugTextStringHud( "countdown", "" );
		
		yourself Show();
		scripted_node anim_first_frame( actors, anime );
		scripted_node anim_single( actors, anime );
		yourself Hide();
		scripted_node anim_first_frame( actors, anime );
		
		PrintDebugTextStringHud( "countdown", "FINISHED" );
		wait 1;
	}	
}

shellshock_very_long( shock )
{
	level.player ShellShock( shock, 31720 );
}

finale_shot_fx()
{
	white_overlay = finale_get_white_overlay();
	white_overlay.alpha = 1.0;
	white_overlay.color = (1,1,1);
	level.player VisionSetNakedForPlayer( "dubai_hurt", 1 );
	wait 0.05;
	level.player ShellShock( "dubai_ending_wounded", 6 );
	white_overlay fadeOverTime( 1 );
	white_overlay.alpha = 0.0;
}

finale_shot_death( quote )
{
	finale_shot_fx();
	level notify("player_dies");		// send this again, to kill any anim we let the player trigger to make him feel better
	SetDvar( "ui_deadquote", quote );
	missionFailedWrapper();
	wait 100;	// don't return
}

finale_beatdown_fail()
{
	thread fade_out_use_hint( 0.1 );
	finale_shot_death( &"DUBAI_MAKAROV_KILLED_YOU" );
}

finale_beatdown_button_count( tgt_count, successflag )
{
	if (!isdefined(tgt_count))
		tgt_count = 3;
	if (!isdefined(successflag))
		successflag = "beatdown_start_success";
	count = 0;
	while (!flag( "beatdown_failure" ))
	{
		while ( !level.player UseButtonPressed())
		{
			wait 0.05;
		}
		count++;
		if (count >= tgt_count)
		{
			flag_set( successflag );
			return;
		}
		while ( level.player UseButtonPressed())
		{
			wait 0.05;
		}
	}
}

finale_beatdown_makarov_shootsyou()
{
	level notify("fail_started");
	
	level.player ShellShock( "dubai_ending_crash_site", 30 );
	
	SetSavedDvar( "hud_missionFailed", 1 );
	//level.player ShellShock( "dubai_ending_wounded", 2 );
	actors[0] = level.player_rig;
	actors[1] = level.makarov;
	actors[2] = level.gun;
	level.makarov gun_remove();
	scripted_node = getent( "finale_scripted_node", "targetname" );
	level.player thread play_fullscreen_blood_splatter_alt(5, 0, 2.5, 0.7);
	aud_send_msg("finale_mak_shoots_failstate");
	/**/
	red_overlay = finale_get_white_overlay();
	red_overlay.color = (0.5,0,0);
	red_overlay.alpha = 0.5;
	wait 0.05;
	red_overlay fadeovertime(1.5);
	red_overlay.alpha = 0;
	/**/
	thread maps\dubai_fx::setup_mak_gun_light_fail();
	scripted_node thread anim_single_trans( actors, "beatdown_fail_2", 0.0, undefined, level.player_rig.curanim );
	actors[1] waittillmatch( "single anim", "fire" );
	finale_shot_death( &"DUBAI_MAKAROV_KILLED_YOU" );
}

finale_beatdown_controlanims( anime, speed )
{
	foreach (actor in level.current_actors)
	{
		anm = actor getanim( anime );
		actor SetFlaggedAnim( "single anim", anm, 1.0, 0.2, speed );
	}
	
}

maxrecordedpresses=20;

ShowButtonPresses()
{
	level endon("stop_buttonmashmonitor");
	level.debug_lr_pressed = [];
	level.debug_lr_idx = 0;
	masks = [ 1, 2, 4 ];
	x=20;
	y=20;
	dy=16;
	height = 10;
	fontsize = 2;
	CreateDebugTextHud( "left ", x, y, undefined, undefined, fontsize );
	CreateDebugTextHud( "right", x, y+dy, undefined, undefined, fontsize );
	CreateDebugTextHud( "mash ", x, y+2*dy, undefined, undefined, fontsize );
	while (true)
	{
		start = level.debug_lr_idx;
		last = level.debug_lr_idx-1;
		if (last < 0)
			last += maxrecordedpresses;
		if (level.debug_lr_pressed.size < maxrecordedpresses)
		{
			start = 0;
			last = level.debug_lr_pressed.size;
		}
		texts = ["","",""];
		for (i=start; i != last; i++)
		{
			if (i >= maxrecordedpresses)
				i -= maxrecordedpresses;
			mask = level.debug_lr_pressed[ i ];
			for (bit=0; bit<3; bit++)
			{
				value = "_";
				if (mask & masks[bit])
					value = "|";
				texts[bit] = texts[bit] + value;
			}
		}
		if (isdefined(texts[0]))
		{
			PrintDebugTextStringHud("left ", texts[0] );
			PrintDebugTextStringHud("right", texts[1] );
			PrintDebugTextStringHud("mash ", texts[2] );
		}
		wait 0.05;
	}	
}

MonitorButtonMash()
{
	level notify("stop_buttonmashmonitor");
	level endon("stop_buttonmashmonitor");
	style = 1;	// 0 - X, 1 - LT & RT, 1 - LT & RT Hold
	/#
	setdvarifuninitialized( "debug_mashstyle", ""+style );
	style = getdebugdvarint("debug_mashstyle");
	#/
	level.buttonmashpressed = 0;
	level.buttonmashhits = 0;
	level.buttonmashstyle = style;
	level.rumble_ent.intensity = 1.0;
	switch(style)
	{
		case 0:	// Use button
			prvpressed = self UseButtonPressed();
			level.buttonmashhits = 3;
			while (true)
			{
				curpressed = self UseButtonPressed();
				level.buttonmashpressed = 0;
				if (!prvpressed && curpressed)
				{
					level.buttonmashpressed = 1;
					level.rumble_ent.intensity = 0.0;
				}
				level.rumble_ent.intensity += 0.05;
				if (level.rumble_ent.intensity > 1.0)
					level.rumble_ent.intensity = 1.0;

				prvpressed = curpressed;
				level waittill("sample_button_mash");
			}
			break;
		case 1: // LT & RT
			prvpressedl = self AdsButtonPressed();
			prvpressedr = self AttackButtonPressed();
			prvnotpressed = !prvpressedr && !prvpressedl;
		//	thread ShowButtonPresses();
			while (true)
			{
				curpressedl = self AdsButtonPressed();
				curpressedr = self AttackButtonPressed();
				curpressed = curpressedr && curpressedl;
				level.buttonmashpressed = 0;
				if (!prvpressedl && curpressedl)
				{
					level.buttonmashhits = level.buttonmashhits | 1;
					level.buttonmashpressed = 1;
				}
				if (!prvpressedr && curpressedr)
				{
					level.buttonmashhits = level.buttonmashhits | 2;
					level.buttonmashpressed = 1;
				}
				prvpressedl = curpressedl;
				prvpressedr = curpressedr;
				if (level.buttonmashpressed)
					level.rumble_ent.intensity = 0.5;
				level.rumble_ent.intensity += 0.05;
				if (level.rumble_ent.intensity > 1.0)
					level.rumble_ent.intensity = 1.0;
				/*
				mask = 0;
				if (curpressedl)
					mask = mask | 1;
				if (curpressedr)
					mask = mask | 2;
				if (level.buttonmashpressed)
					mask = mask | 4;
				level.debug_lr_pressed[level.debug_lr_idx] = mask;
				level.debug_lr_idx++;
				if (level.debug_lr_idx >= maxrecordedpresses)
					level.debug_lr_idx = 0;
				*/
				level waittill("sample_button_mash");
			}
			break;
		case 2: // LT & RT Hold
			level.buttonmashhits = 3;
			while (true)
			{
				curpressedl = self AdsButtonPressed();
				curpressedr = self AttackButtonPressed();
				curpressed = curpressedr && curpressedl;
				level.buttonmashpressed = curpressed;
				if (level.buttonmashpressed)
					level.rumble_ent.intensity = 0.5;
				level.rumble_ent.intensity += 0.05;
				if (level.rumble_ent.intensity > 1.0)
					level.rumble_ent.intensity = 1.0;
				level waittill("sample_button_mash");
			}
			break;
	}
}

finale_beatdown_monitor_fail_notetrack( animes )
{
	notetrack = "fail";
	hinttrack = "hint";
	hintleadtime = 0.1;		// used if no hint notetracks
	pressleadtime = 0.1;
	speed = 0.10;		// use slowmo at hint time if < 1
	lerp_in_time = 0.0;
	lerp_out_time= 0.0;
	button_mash_first_time = 1.2;
	button_mash_time = 0.5;
	choke_mash_first_time = 1.5;
	choke_mash_time = 0.9;
	button_release_first_time = 1.2;
	button_release_time = 0.5;
	anms = [];
	tracks = [];
	hints = [];
	presses = [];
	pressed = [];
	mash_start = [];
	mash_end = [];
	animstarttime = 0;
	starttimes = [];
	level.cur_beatdown_anim_idx = 0;
	for (i=0; i<animes.size; i++)
	{
		starttimes[i] = animstarttime;
		anms[i] = self getanim( animes[i] );
		length = GetAnimLength( anms[i] );
		reftracks = getnotetracktimes( anms[i], notetrack );
		foreach (track in reftracks)
		{
			time = animstarttime + track*length;
			if ((tracks.size > 0) && (tracks[tracks.size-1] == time))
				continue;	// don't add the same time twice
			tracks[tracks.size] = time;
			pressed[pressed.size] = false;
		}
		reftracks = getnotetracktimes( anms[i], hinttrack );
		foreach (track in reftracks)
		{
			time = animstarttime + track*length;
			if ((hints.size > 0) && (hints[hints.size-1] == time))
				continue;	// don't add the same time twice
			hints[hints.size] = time;
			presses[presses.size] = time - pressleadtime;
		}
		reftracks = getnotetracktimes( anms[i], "mash_start" );
		foreach (track in reftracks)
		{
			time = animstarttime + track*length;
			if ((mash_start.size > 0) && (mash_start[mash_start.size-1] == time))
				continue;	// don't add the same time twice
			mash_start[mash_start.size] = time;
		}
		reftracks = getnotetracktimes( anms[i], "mash_end" );
		foreach (track in reftracks)
		{
			time = animstarttime + track*length;
			if ((mash_end.size > 0) && (mash_end[mash_end.size-1] == time))
				continue;	// don't add the same time twice
			mash_end[mash_end.size] = time;
		}
		animstarttime += length;
	}
	if (hints.size == 0)
	{
		foreach (i, track in tracks)
		{
			hints[i] = track - hintleadtime;
			presses[i] = hints[i] - pressleadtime;
		}
	}
	animstarttime = 0;
	curidx = level.cur_beatdown_anim_idx;
	prvpressed = level.player UseButtonPressed();
	prvtime = self GetAnimTime( anms[curidx] );
	current = 0;
	current_mash = 0;
	button_mash = false;
	button_time = 0;
	while (isdefined(tracks) && tracks.size && (level.cur_beatdown_anim_idx<animes.size) && isdefined(pressed[current]))
	{
		curidx = level.cur_beatdown_anim_idx;
		length = GetAnimLength( anms[curidx] );
		time = self GetAnimTime( anms[curidx] );
		time *= length;
		time += starttimes[curidx];
		curpressed = level.player UseButtonPressed();
		justpressed = false;
		if (!prvpressed && curpressed)
			justpressed = true;
		prvpressed = curpressed;
		press = presses[current];
		if ((press >= -1) && (time > press))
		{
			if (justpressed)
			{
				pressed[current] = true;
				presses[current] = -1;
			}
		}
		hint = hints[current];
		if ((prvtime < hint) && (hint <= time))
		{	// see if we need flashing hint and remove it from hints
			if (!pressed[current])
			{
				if (speed < 1)
				{
					thread finale_beatdown_controlanims( animes[curidx], speed );
				}
				thread use_hint_blink();
				if (button_mash)
				{	// hint will clobber the button mash hint, so cancel the button_mash
					button_mash = false;
					current_mash++;
				}
			}
		}
		if (isdefined(level.use_hint_active) && pressed[current])
		{	// see if the use button has been pressed and remove the hint if it has
			if (speed < 1)
			{
				thread finale_beatdown_controlanims( animes[curidx], 1.0 );
			}
			level.use_hint_active = undefined;	// make hint go away
		}
		track = tracks[current];
		if ((prvtime < track) && (track <= time))
		{	// see if we fail and remove this track
			level.use_hint_active = undefined; // ensure the hint goes away
			if (speed < 1)
			{
				thread finale_beatdown_controlanims( animes[curidx], 1.0 );
			}
			if (!pressed[current])
			{	// fail
				finale_beatdown_makarov_shootsyou();
			}
			current++;
		}
		if (current_mash < mash_start.size)
		{
			track = mash_start[current_mash];
			if ((prvtime < track) && (track <= time))
			{	// start monitoring button mashing
				button_mash = true;
				level.player thread MonitorButtonMash();
				add_time = button_mash_first_time;
				maxscale = 3;
				if (level.buttonmashstyle == 0)
				{
					thread use_hint_blinks( maxscale );
				}
				else if (level.buttonmashstyle == 1)
				{
					thread choke_hint_blinks(1.25, maxscale, 0.0);
					add_time = choke_mash_first_time;
				}
				else
				{
					thread choke_hint_blinks(1.75, maxscale, 0.75 );
					add_time = button_release_first_time;
				}
				button_time = gettime()+1000*add_time;
			}
			track = mash_end[current_mash];
			if ((prvtime < track) && (track <= time))
			{	// end monitoring button mashing
				level notify("stop_buttonmashmonitor");
				level.rumble_ent.intensity = 0.0;
				if (level.buttonmashhits != 3)
				{	// the player only hit one side when require to hit both
					if (level.buttonmashstyle < 1)
						thread fade_out_use_hint( 0.1 );
					else
						thread fade_out_choke_hint( 0.1 );
					finale_beatdown_makarov_shootsyou();
				}

				button_mash = false;
				if (level.buttonmashstyle < 1)
					thread fade_out_use_hint( 0.2 );
				else
					thread fade_out_choke_hint( 0.2 );
				current_mash++;
			}
		}
		if (button_mash)
		{
			testtime = gettime();
			time_add = button_mash_time;
			if (level.buttonmashstyle == 1)
				time_add = choke_mash_time;
			else if (level.buttonmashstyle == 2)
				time_add = button_release_time;
			if (level.buttonmashpressed)
				button_time = gettime()+1000*time_add;
			if (testtime > button_time)
			{	// didn't press fast enough, so fail
				if (level.buttonmashstyle < 1)
					thread fade_out_use_hint( 0.1 );
				else
					thread fade_out_choke_hint( 0.1 );
				finale_beatdown_makarov_shootsyou();
			}
		}
		
		prvtime = time;
		level notify("sample_button_mash");	// ensure synchronization btn buttonmash monitor and this thread
		wait 0.05;
	}
}


finale_should_stop_flash_use()
{
	return 0;
}

loop_on_dupd_node_solo( actor, anime, ender, trans )
{
	new_node = spawn("script_origin", self.origin);
	new_node.angles = self.angles;
	if (isdefined(trans))
		new_node thread anim_loop_solo_trans( actor, anime, ender, trans );
	else
		new_node thread anim_loop_solo( actor, anime, ender );
	actor waittill( ender );
	new_node notify( ender );
	new_node Delete();
}

finale_beatdown_sequence()
{
	level endon("fail_started");
	thread maps\dubai_fx::finale_environmentfx_start();
	add_hint_string( "hint_flash_use", &"DUBAI_FLASH_USE", ::finale_should_stop_flash_use );
	add_hint_string( "hint_flash_choke", &"DUBAI_FLASH_CHOKE", ::finale_should_stop_flash_use );
	level.flash_choke_hint = &"DUBAI_FLASH_CHOKE";
	add_hint_string( "hint_hold_choke", &"DUBAI_HOLD_CHOKE", ::finale_should_stop_flash_use );
	level.hold_choke_hint = &"DUBAI_HOLD_CHOKE";
	if (!level.console)
	{
		add_hint_string( "hint_flash_choke_pc", &"DUBAI_FLASH_CHOKE_PC", ::finale_should_stop_flash_use );
		level.flash_choke_hint_pc = &"DUBAI_FLASH_CHOKE_PC";
		add_hint_string( "hint_hold_choke_pc", &"DUBAI_HOLD_CHOKE_PC", ::finale_should_stop_flash_use );
		level.hold_choke_hint_pc = &"DUBAI_HOLD_CHOKE_PC";
	}
	
	finale_glass = getentarray( "finale_rail_glass_shattered", "script_noteworthy" );
	array_call( finale_glass, ::hide );
	
	finale_rail_broken = getent( "finale_rail_broken", "script_noteworthy" );
	finale_rail_broken hide();
	
	flag_wait( "end_finale_showdown" );
	level.player FadeOutShellShock();
	//player blood fx
	exploder("price_finale_blood");
	thread finale_player_setup();
	if (!isdefined(level.attack_button_q))
		thread monitor_button_presses();
	if (!isdefined(level.player_rig))
	{
		player_rig = spawn_anim_model( "player_rig", (0, 0, 0) );
		player_rig thread setup_player_rig_notetracks();
		level.player_rig = player_rig;
		level.player playerlinktoblend( player_rig, "tag_player", 0.0 );
	}
	if (!isdefined(level.makarov))
	{
		finale_crash_site_makarov = getent( "finale_crash_site_makarov", "script_noteworthy" );
		finale_crash_site_makarov add_spawn_function( ::finale_beatdown_makarov_think );
		level.makarov = finale_crash_site_makarov spawn_ai( true );
		level.makarov.animname = "makarov";
	}
	if (!isdefined(level.gun))
	{
		level.gun = spawn_anim_model("deagle");
		level.gun HidePart( "TAG_SILENCER" );
		level.gun HidePart( "TAG_KNIFE" );
	}
	if (!isdefined(level.fx_char_light_rig))
	{
		level.fx_char_light_rig = spawn_anim_model("fx_char_light_rig");
	}
	ropea = spawn_anim_model("ropea");
	ropeb = spawn_anim_model("ropeb");
	scripted_node = getent( "finale_scripted_node", "targetname" );
	mactors[0] = level.makarov;
	mactors[1] = level.gun;
	mactors[2] = level.fx_char_light_rig;
	
	//start char lighting logic
	level.fx_char_light_rig thread maps\dubai_fx::rooftop_lighting_rig();

	scripted_node thread loop_on_dupd_node_solo( ropea, "beatdown_idle_1", "stop_loop", 0.0 );
	scripted_node thread finale_idle_1(mactors);
//	scripted_node thread finale_beatdown_player( );
	
	
	actors[0] = level.player_rig;
	actors[1] = level.makarov;
	actors[2] = level.gun;
	actors[3] = level.fx_char_light_rig;

	flag_wait( "beatdown_tackle_start" );
	thread finale_beatdown_tackle_notetracks();
	aud_send_msg("finale_se", "start_beatdown");
	level notify("fx_beatdown_msg");
	flag_set("stop_makarov_blobshadow");
	level.current_actors = actors;
	level.player_rig thread finale_beatdown_monitor_fail_notetrack( ["beatdown_tackle", "beatdown_choke", "beatdown_slam"] );
	level.player_rig.curanim = "beatdown_tackle";
	scripted_node anim_single_trans( actors, "beatdown_tackle" );
	actors[2] = undefined;	// no gun in choke
	actors[4] = ropea;
	actors[5] = ropeb;
	level.current_actors = actors;
	level.cur_beatdown_anim_idx++;
	ropea notify("stop_loop");	// stop loop on dup'd node
	level notify("fx_beatdown_msg_startchoke");
	level.player_rig.curanim = "beatdown_choke";
	scripted_node anim_single( actors, "beatdown_choke" );
	playerbody = spawn_anim_model( "player_body" );
	thread maps\dubai_fx::finale2_environmentfx_start();
	cigar = spawn_anim_model("cigar");
	zippo = spawn_anim_model("zippo");
	actors[6] = playerbody;
	actors[7] = cigar;
	actors[8] = zippo;
	actors[9] = getent( "dub_finale_railing_glass","targetname" );
	if (isdefined(actors[9]))
	{
		actors[9] Show();
		actors[9].animname = "floor_glass";
		actors[9] SetAnimTree();
	}
	level.current_actors = actors;
	level.cur_beatdown_anim_idx++;
	
	thread finale_beatdown_stop_button_mash();
	scripted_node thread finale_beatdown_slam_notetracks();
	level notify("fx_beatdown_msg_startslam");
	level.player_rig.curanim = "beatdown_slam";
	scripted_node anim_single( actors, "beatdown_slam" );
	actors[0] = undefined;
	actors[3] = undefined;
//	actors[4] = undefined;
//	actors[5] = undefined;
	actors[6] = undefined;
	actors[7] = undefined;
	actors[8] = undefined;
	actors[9] = undefined;
	pactors[0] = level.player_rig;
	pactors[1] = playerbody;
	pactors[2] = cigar;
	level.cur_beatdown_anim_idx++;
	aud_send_msg("finale_se", "end_beatdown");
	
	finale_beatdown_during_credits( actors, pactors );
}

wait_to_start_credits()
{
	self waittillmatch("single anim", "start_credits");
	flag_set( "level_end" );
}

finale_beatdown_player()
{
	level.player_beatdown_started = true; 	// flag so we don't play beatdown_idle_1_look from other thread

	if (isdefined(level.player_rig.in_slowmo) && level.player_rig.in_slowmo)
	{
		slowmo_lerp_out();
		level.player_rig.in_slowmo = false;
	}
	scripted_node = self;
	anm = level.player_rig getanim( "beatdown_tackle_start" );
	level.player_rig.curanim = "beatdown_tackle_start";
	scripted_node thread anim_single_solo( level.player_rig, "beatdown_tackle_start" );
	if (!flag("beatdown_start_success"))	// don't start the loop if we already mashed enough
	{
		level.player_rig SetFlaggedAnimKnob( "single anim", anm, 1.0, 0.5, 0 );
	}
	else
	{
		level.player_rig SetFlaggedAnimKnob( "single anim", anm, 1.0, 0.5, 1.0 );
	}
	if (isdefined(level.beatdown_debugstart))
	{
		flag_set("beatdown_start_success");
	}
	flag_wait_either( "beatdown_start_success", "beatdown_failure" );
	if (flag( "beatdown_failure" ))
	{	// failure during the idle_1 stage, so play the appropriate anim
		scripted_node anim_single_solo( level.player_rig, "beatdown_idle_1_look" );
		wait 100;	// wait for failure
	}
	flag_clear( "beatdown_start_success" );
	thread finale_beatdown_button_count( 2 );
	// turn off the additive camera
	thread finale_chopper_stop_camera_additive();
	level.player_rig SetFlaggedAnim( "single anim", anm, 1.0, 0.2, 1 );
	level.player_rig waittillmatch( "single anim", "idle2" );
	if (flag( "beatdown_failure" ) || !flag("beatdown_start_success"))	// don't start the loop if we already mashed enough
	{
		thread finale_chopper_force_camera_additive();
		level.player_rig SetFlaggedAnim( "single anim", anm, 1.0, 0.2, 0 );
	}
	if (flag( "beatdown_failure" ))
	{
		wait 100;	// wait for failure
	}
	flag_wait_either( "beatdown_start_success", "beatdown_failure" );
	if (flag( "beatdown_failure" ))
	{
		wait 100;	// wait for failure
	}
	level.use_hint_active = undefined;	// turn off the current hint
	level notify("start_tackle");
	thread finale_chopper_stop_camera_additive();
	level.player_rig SetFlaggedAnim( "single anim", anm, 1.0, 0.2, 1 );
	level.player_rig waittillmatch( "single anim", "end" );
	flag_set( "beatdown_tackle_start" );
}

finale_beatdown_during_credits( actors, pactors, debugending )
{
	just_credits = !isdefined(actors) && !isdefined(debugending);
	aud_send_msg("finale_se", "start_smoking");
	if (!isdefined(level.player_rig))
	{
		player_rig = spawn_anim_model( "player_rig", (0, 0, 0) );
		player_rig thread setup_player_rig_notetracks();
		level.player_rig = player_rig;
		level.player playerlinktoblend( player_rig, "tag_player", 0.0 );
	}
	if (!isdefined(level.makarov))
	{
		finale_crash_site_makarov = getent( "finale_crash_site_makarov", "script_noteworthy" );
		finale_crash_site_makarov add_spawn_function( ::finale_beatdown_makarov_think );
		level.makarov = finale_crash_site_makarov spawn_ai( true );
		level.makarov.animname = "makarov";
	}
	scripted_node = getent( "finale_scripted_node", "targetname" );
	if (!isdefined(actors))
	{
		ropea = spawn_anim_model("ropea");
		ropeb = spawn_anim_model("ropeb");
		actors[1] = level.makarov;
		actors[2] = ropea;
		actors[3] = ropeb;
	}
	if (!isdefined(pactors))
	{
		playerbody = spawn_anim_model( "player_body" );
		cigar = spawn_anim_model("cigar");
		pactors[0] = level.player_rig;
		pactors[1] = playerbody;
		pactors[2] = cigar;
	}
	scripted_node thread finale_beatdown_hanging( actors );
	
	if (just_credits)
	{
		black_overlay = finale_get_black_overlay();
		black_overlay.alpha = 1.0;
	}
	else
	{
		level.player_rig thread wait_to_start_credits();
		if (!isdefined(level.ending_debugstart))
		{
			thread finale_beatdown_smoking_process( level.player_rig );
			scripted_node anim_single( pactors, "beatdown_smoking_idle" );
		}
		else
			scripted_node thread anim_single( pactors, "beatdown_smoking_idle" );
	}
	
	if (!isdefined(level.ending_debugstart))
		flag_set( "level_end" );	//start credits
	else
	{
		black_overlay = finale_get_black_overlay();
		black_overlay.alpha = 1.0;
		wait 1;
	}
	flag_wait( "end_of_credits");

	/*
	// handle mysterious stranger
	thread maps\dubai_fx::setup_mysterious_stranger_rimlight();
	stranger = spawn_anim_model("stranger");
	stranger attach( level.scr_head["stranger"] );
	scripted_node anim_first_frame_solo( stranger, "beatdown_end" );
	pactors[3] = stranger;
	aud_send_msg("finale_se", "end_smoking");
	aud_send_msg("finale_se", "start_stranger");
	thread finale_beatdown_end_process( level.player_rig );
	stranger thread maps\dubai_fx::finale_mysterious_stranger_shadow_start();
	scripted_node anim_single( pactors, "beatdown_end" );
	aud_send_msg("finale_se", "end_stranger");
	*/
	
	flag_set( "fadeout_at_end_done");
	//scripted_node notify( "stop_loop");
	// second actor is figure in black
}

update_dof()
{
	level notify("stop_update_dof");
	level endon("stop_update_dof");
	while (level.level_specific_dof)
	{
		level.player SetDepthOfField(
								self.dofDefault[ "nearStart" ],
								self.dofDefault[ "nearEnd" ],
								self.dofDefault[ "farStart" ],
								self.dofDefault[ "farEnd" ],
								self.dofDefault[ "nearBlur" ],
								self.dofDefault[ "farBlur" ]
								 );
		wait 0.05;
	}
}

finale_beatdown_smoking_process( player_rig )
{
	fades = [];
	anm = player_rig getanim( "beatdown_smoking_idle" );
	start_fades = getnotetracktimes( anm, "start_fade" );
	end_fades = getnotetracktimes( anm, "end_fade" );
	length = GetAnimLength( anm );
	foreach ( i, start in start_fades )
	{
		fades[i] = length*(end_fades[i] - start);
	}
	// switch to passing out shellshock before fading out
	sstime = (length*start_fades[0])-5;
	wait sstime;
	// start ShellShock
	level notify("stop_woozy");
//	level.player ShellShock( "dubai_injured_passout", 3+fades[0] );
	wait 4;
//	SetBlur( 3.5, 4+fades[0] );
	
	black_overlay = finale_get_black_overlay();
	// we'll hardcode our notetrack waits here
	player_rig waittillmatch( "single anim", "start_fade" );

	// some cleanup
	level notify("stop_button_mash_monitor");
	
	black_overlay fadeOverTime( fades[0] );
	black_overlay.alpha = 1.0;
	wait fades[0];
}


finale_beatdown_end_process( player_rig )
{
	dof_makarov = [];
	dof_makarov[ "nearStart" ] = 5;
	dof_makarov[ "nearEnd" ] = 10.0;
	dof_makarov[ "nearBlur" ] = 4.0;
	dof_makarov[ "farStart" ] = 300;
	dof_makarov[ "farEnd" ] = 1200;
	dof_makarov[ "farBlur" ] = 3.8;
	
	dof_stranger = [];
	dof_stranger[ "nearStart" ] = 30;
	dof_stranger[ "nearEnd" ] = 400;
	dof_stranger[ "nearBlur" ] = 5.25;
	dof_stranger[ "farStart" ] = 1200;
	dof_stranger[ "farEnd" ] = 2500;
	dof_stranger[ "farBlur" ] = 1.0;
	
	dof_cigar = [];
	dof_cigar[ "nearStart" ] = 1;
	dof_cigar[ "nearEnd" ] = 10;
	dof_cigar[ "nearBlur" ] = 4.1;
	dof_cigar[ "farStart" ] = 300;
	dof_cigar[ "farEnd" ] = 1000;
	dof_cigar[ "farBlur" ] = 4.1;
	


	fades = [];
	anm = player_rig getanim( "beatdown_end" );
	start_fades = getnotetracktimes( anm, "start_fade" );
	end_fades = getnotetracktimes( anm, "end_fade" );
	length = GetAnimLength( anm );
	foreach ( i, start in start_fades )
	{
		fades[i] = length*(end_fades[i] - start);
	}
	black_overlay = finale_get_black_overlay();
	level.player SetBlurForPlayer(10,0);
	// we'll hardcode our notetrack waits here
	player_rig waittillmatch( "single anim", "fade_up" );
	black_overlay fadeOverTime( 1.0 );
	black_overlay.alpha = 0.0;
	level.player delaycall( 1, ::SetBlurForPlayer, 0, 2.0 );
	level.level_specific_dof = true;
	level thread update_dof();
	level.dofDefault = dof_makarov;
	player_rig waittillmatch( "single anim", "focus_change" );
	// focus on makarov
	start = level.dofDefault;	

	blend_dof( start, dof_stranger, 2.1 );
	player_rig waittillmatch( "single anim", "focus_change" );
	// focus on cigar
	start = level.dofDefault;	

	blend_dof( start, dof_cigar, 2.5 );
	player_rig waittillmatch( "single anim", "start_fade" );
	blurtime = fades[0] - 2;
	if (blurtime < 0)
		blurtime = 1;
	level.player SetBlurForPlayer( 10.0, blurtime );
	wait 2;
	black_overlay fadeOverTime( 2 );
	black_overlay.alpha = 1.0;
	wait fades[0];
	level.level_specific_dof = false;
	
}


finale_beatdown_stranger_view()
{
	wait 20;
	SetBlur( 10, 65 );
	wait 20;
	black_overlay = finale_get_black_overlay();
	black_overlay fadeOverTime( 25 );
	black_overlay.alpha = 1.0;
	wait 45;
}

finale_beatdown_tackle_notetracks()
{
	level.player_rig thread finale_crash_site_showdown_slowmo( "slomo" );
	level.player_rig thread finale_crash_site_showdown_slowmo( "slomo1" );
	level.player_rig thread finale_crash_site_showdown_slowmo( "slomo2" );
	level.player_rig thread finale_crash_site_showdown_slowmo( "slomo3" );
}

finale_beatdown_slam_notetracks()
{
	level.player_rig thread finale_crash_site_showdown_slowmo( "slomo", 0.25 );
	level.player_rig thread finale_crash_site_showdown_slowmo( "slomo1" );
	level.player_rig thread finale_crash_site_showdown_slowmo( "slomo2" );
	level.player_rig thread finale_crash_site_showdown_slowmo( "slomo3" );
	thread finale_beatdown_break_glass_rail_watcher();
	self thread finale_beatdown_break_glass_roof();
	self thread finale_beatdown_woozy_price();
	aud_send_msg("finale_se", "start_hanging");
}

finale_beatdown_stop_button_mash()
{
	level.player_rig waittillmatch( "single anim", "end_buttonmash" );
	level notify("stop_button_mash_monitor");
	thread fade_out_use_hint( 0.5 );
}

finale_beatdown_break_glass_roof()
{
	skylight = spawn( "script_model", self.origin );
	
	skylight setmodel( "dub_finale_skylight_shards" );
	skylight.animname = "skylight";
	skylight UseAnimTree( level.scr_animtree[ "skylight" ] );
	anime = "skylight_shatter";
		
	skylight hide();
		
	self thread anim_first_frame_solo( skylight, anime );  
	
	thread finale_skylight_glass_shatter_vfx();
	
	level.player_rig waittillmatch( "single anim", "roof_break" );
		
	//remove original piece
	skylight_shatter_frame_static_piece = getent( "skylight_shatter_frame", "script_noteworthy" );
	skylight_shatter_frame_static_piece setmodel( "dub_roof_top_sky_light_broken" );

	skylight_shatter_glass_static_piece = getent( "skylight_shatter_glass", "script_noteworthy" );
	skylight_shatter_glass_static_piece delete();

	skylight show();
	self anim_single_solo( skylight, anime );
	
	//skylight delete();
}

finale_skylight_glass_shatter_vfx()
{
	level.player_rig waittillmatch( "single anim", "shatter_vfx" );
	
	exploder (21010);//skylight shatter vfx
	
	//vision set change to reduce character spec during fall..
	thread maps\dubai_fx::setup_glass_fall_lighting();
}

finale_beatdown_break_glass_rail_watcher()
{
	level.player_rig waittillmatch( "single anim", "balcony_break" );

	time = 10;
	fade_in = 0.05;
	fade_out = 9;
	level.player delaythread(0, ::play_fullscreen_blood,(time), (fade_in), (fade_out), 1);
	level.player delaythread(0, ::play_fullscreen_blood_bottom, (time), (fade_in), (fade_out), 1);
	level.player delaythread(0, ::play_fullscreen_blood_splatter_alt,(time), (fade_in), (fade_out), 1);

	thread finale_beatdown_break_glass_rail();
	delaythread (1.3, ::exploder, 21020); //5 glass impacts with delayed timing set in exploder nodes in the rail area
	wait 1.0;	// wait a short time after landing to allow the player to look around
	level.player PlayerLinkToDelta( level.player_rig, "tag_player", 1.0, 5,20,20,0, true );
	level.player enableslowaim();
}

finale_beatdown_break_glass_rail()
{
	funcglass = getglassarray( "finale_rail_glass" );
	foreach( glass in funcglass )
		deleteglass( glass );
	
	finale_glass = getentarray( "finale_rail_glass_shattered", "script_noteworthy" );
	array_call( finale_glass, ::show );
	
	finale_rail_intact = getent( "finale_rail_intact", "script_noteworthy" );
	finale_rail_intact hide();
	
	finale_rail_broken = getent( "finale_rail_broken", "script_noteworthy" );
	finale_rail_broken show();
	
	wait 27;
	objective_state( 1, "done" );
}

finale_beatdown_woozy_price()
{
	level endon("stop_woozy");
	level.player_rig waittillmatch( "single anim", "balcony_break" );
	period = 3;
	while (!flag("level_end"))
	{
		SetBlur(2,period);
		wait period;
		SetBlur(0.0,period);
		wait period;
	}
	
}

finale_idle_1( actors )
{
	scripted_node = self;
	level endon("start_tackle");	// bail if start_tackle called
	thread finale_beatdown_fail_fire( actors[0], actors[1] );
	aud_send_msg("finale_showdown_fail");
	scripted_node thread anim_single_trans( actors, "beatdown_idle_1" );
	actors[0] waittillmatch( "single anim", "fail" );
	flag_set( "beatdown_failure" );
	if (!isdefined(level.player_beatdown_started))
	scripted_node thread anim_single_solo( level.player_rig, "beatdown_idle_1_look" );
	// let anim finish then tell player to mission fail
	actors[0] waittillmatch( "single anim", "fire" );
	finale_beatdown_fail();
}

finale_beatdown_fail_fire( actor, gun )
{
	actor waittillmatch( "single anim", "weapon_fire" );
	// hook up gun effects here
}

finale_beatdown_hanging( actors )
{
	scripted_node = self;
	scripted_node thread anim_loop_trans( actors, "beatdown_hanging_idle", "stop_loop" );
	flag_wait( "fadeout_at_end_done");
//	scripted_node notify( "stop_loop");
}


finale_beatdown_makarov_think()
{
	//climb out of wreckage and shoot at player
	//finale_makarov_crash_location = getent( "finale_makarov_crash_location", "targetname" );
	//self teleport_ai( finale_makarov_crash_location );
	self.animname = "makarov";
	level.makarov = self;
}


set_default_hud_stuff()
{
//	MYFADEINTIME = 2.0;
//	MYFLASHTIME = 0.75;
//	MYALPHAHIGH = 0.95;
//	MYALPHALOW = 0.4;


	self.alignx = "center";
	self.aligny = "middle";
	self.horzAlign = "center";
	self.vertAlign = "middle";
	//self.foreground = false;
	self.hidewhendead = true;
	self.hidewheninmenu = true;

	self.sort = 205;
	self.foreground = true;

	self.alpha = 0;
//	self FadeOverTime( MYFADEINTIME );
//	self.alpha = MYALPHAHIGH;

}

monitor_choke_hint( choke_text )
{
	level endon( "fade_out_choke_hint" );
	while (true)
	{
		adsholdbound = true;
		adsbound = false;
		if (!level.console)
		{
			binds = GetKeyBinding( "+speed_throw");
			if (!isdefined(binds) || (binds["count"] == 0))
			{
				adsholdbound = false;
				binds = GetKeyBinding( "+toggleads_throw");
				if (isdefined(binds) && (binds["count"] > 0))
					adsbound = true;
			}
		}
		if (adsholdbound)
			choke_text SetText( level.flash_choke_hint );
		else
			choke_text SetText( level.flash_choke_hint_pc );
			
		wait 0.05;
	}
}

draw_choke_hint()
{
	y_offset = 90;
	x_offset = 35;


	choke_text = level.player createClientFontString( "default", 2 );
	choke_text.x = x_offset * -1;
	choke_text.y = y_offset;
	choke_text.horzAlign = "right";
	choke_text.alignX = "right";
	choke_text set_default_hud_stuff();
	// ^3[{+usereload}]^7
	if (level.buttonmashstyle < 2)
	{
		choke_text SetText( level.flash_choke_hint );
		thread monitor_choke_hint( choke_text );
	}
	else
		choke_text SetText( level.hold_choke_hint );
	//use_text SetPulseFX( 100, 5000, 1000 );

	/*
	use_icon = createIcon( "hud_icon_commando_knife", 64, 32 );
	use_icon.x = x_offset;
	use_icon.y = y_offset;
	use_icon set_default_hud_stuff();
	*/


	elements = [];
	elements[ "text" ] = choke_text;
	//elements[ "icon" ] = use_icon;

	level.choke_hint = elements;
}

stop_choke_hint_blink()
{
	level endon( "fade_out_choke_hint" );
	while (isdefined(level.choke_hint_active) && level.choke_hint_active)
		wait 0.05;
	
	foreach ( elem in level.choke_hint )
	{
		elem.alpha = 0;
	}
	level notify( "fade_out_choke_hint" );
}

choke_hint_blink( minscale, maxscale )
{
	level notify( "fade_out_choke_hint" );
	level endon( "fade_out_choke_hint" );

	if ( !isdefined( level.choke_hint ) )
		draw_choke_hint();

	fade_time = 0.4;
	hold_time = 0.1;
	level.choke_hint_active = true;
	thread stop_choke_hint_blink();

	foreach ( elem in level.choke_hint )
	{
		elem.alpha = 0.95;
	}

	hud_button = level.choke_hint[ "text" ];

	hud_button FadeOverTime( 0.01 );
	hud_button.alpha = 0.95;
	hud_button ChangeFontScaleOverTime( 0.01 );
	hud_button.fontScale = maxscale;
	
	wait 0.1;

	hud_button FadeOverTime( fade_time );
	hud_button.alpha = 0.0;
	hud_button ChangeFontScaleOverTime( fade_time );
	hud_button.fontScale = minscale;

	wait hold_time;

	foreach ( elem in level.choke_hint )
	{
		elem.alpha = 0;
	}
}

choke_hint_blinks( minscale, maxscale, minalpha )
{
	level notify( "fade_out_choke_hint" );
	level endon( "fade_out_choke_hint" );

	if ( !isdefined( level.choke_hint ) )
		draw_choke_hint();

	fade_time = 0.10;
	hold_time = 0.20;
	level.choke_hint_active = true;

	foreach ( elem in level.choke_hint )
	{
		elem FadeOverTime( 0.1 );
		elem.alpha = 0.95;
	}

	wait 0.1;

	hud_button = level.choke_hint[ "text" ];

	for ( ;; )
	{
		if (isdefined(level.choke_hint[ "icon" ]))
			level.choke_hint[ "icon" ].alpha = 0.95;

		hud_button FadeOverTime( 0.01 );
		hud_button.alpha = 0.95;
		hud_button ChangeFontScaleOverTime( 0.01 );
		hud_button.fontScale = maxscale;

		wait 0.1;

		hud_button FadeOverTime( fade_time );
		hud_button.alpha = minalpha;
		hud_button ChangeFontScaleOverTime( fade_time );
		hud_button.fontScale = minscale;

		wait hold_time;

		if (!isdefined(level.choke_hint_active))
		{
			foreach ( elem in level.choke_hint )
			{
				elem.alpha = 0;
			}
			return;
		}
	}
}

fade_out_choke_hint( time )
{
	level notify( "fade_out_choke_hint" );
	if ( !isdefined( time ) )
		time = 1.5;

	if ( !isdefined( level.choke_hint ) )
		draw_choke_hint();

	foreach ( elem in level.choke_hint )
	{
		elem FadeOverTime( time );
		elem.alpha = 0;
	}
	level.choke_hint_active = undefined;
}


//*********************************************************************************************************



draw_use_hint()
{
	y_offset = 90;
	x_offset = 35;


	use_text = level.player createClientFontString( "default", 2 );
	use_text.x = x_offset * -1;
	use_text.y = y_offset;
	use_text.horzAlign = "right";
	use_text.alignX = "right";
	use_text set_default_hud_stuff();
	// ^3[{+usereload}]^7
	use_text SetText( &"DUBAI_FLASH_USE" );
	//use_text SetPulseFX( 100, 5000, 1000 );

	/*
	use_icon = createIcon( "hud_icon_commando_knife", 64, 32 );
	use_icon.x = x_offset;
	use_icon.y = y_offset;
	use_icon set_default_hud_stuff();
	*/


	elements = [];
	elements[ "text" ] = use_text;
	//elements[ "icon" ] = use_icon;

	level.use_hint = elements;
}

stop_use_hint_blink()
{
	level endon( "fade_out_use_hint" );
	fade_time = 0.2;
	while (isdefined(level.use_hint_active) && level.use_hint_active)
		wait 0.05;
	
	foreach ( elem in level.use_hint )
	{
		elem FadeOverTime( fade_time );
		elem.alpha = 0.0;
		elem ChangeFontScaleOverTime( fade_time );
		elem.fontScale = 0.25;
	}
	level notify( "fade_out_use_hint" );
}

use_hint_blink()
{
	level notify( "fade_out_use_hint" );
	level endon( "fade_out_use_hint" );

	if ( !isdefined( level.use_hint ) )
		draw_use_hint();

	display_time = 1.5;
	fade_time = 0.4;
	hold_time = 0.1;
	level.use_hint_active = true;
	thread stop_use_hint_blink();

	foreach ( elem in level.use_hint )
	{
		elem.alpha = 0.95;
	}

	hud_button = level.use_hint[ "text" ];

	hud_button FadeOverTime( 0.01 );
	hud_button.alpha = 0.95;
	hud_button ChangeFontScaleOverTime( 0.01 );
	hud_button.fontScale = 2.0;
	
	wait display_time;

	hud_button FadeOverTime( fade_time );
	hud_button.alpha = 0.0;
	hud_button ChangeFontScaleOverTime( fade_time );
	hud_button.fontScale = 0.25;

	wait hold_time;

	foreach ( elem in level.use_hint )
	{
		elem.alpha = 0;
	}
}

use_hint_blinks( maxscale )
{
	level notify( "fade_out_use_hint" );
	level endon( "fade_out_use_hint" );
	if (!isdefined(maxscale))
		maxscale = 3;

	if ( !isdefined( level.use_hint ) )
		draw_use_hint();

	fade_time = 0.10;
	hold_time = 0.20;
	level.use_hint_active = true;

	foreach ( elem in level.use_hint )
	{
		elem FadeOverTime( 0.1 );
		elem.alpha = 0.95;
	}

	wait 0.1;

	hud_button = level.use_hint[ "text" ];

	for ( ;; )
	{
		if (isdefined(level.use_hint[ "icon" ]))
			level.use_hint[ "icon" ].alpha = 0.95;

		hud_button FadeOverTime( 0.01 );
		hud_button.alpha = 0.95;
		hud_button ChangeFontScaleOverTime( 0.01 );
		hud_button.fontScale = maxscale;

		wait 0.1;

		hud_button FadeOverTime( fade_time );
		hud_button.alpha = 0.0;
		hud_button ChangeFontScaleOverTime( fade_time );
		hud_button.fontScale = 0.25;

		wait hold_time;

		if (!isdefined(level.use_hint_active))
		{
			foreach ( elem in level.use_hint )
			{
				elem.alpha = 0;
			}
			return;
		}
	}
}

fade_out_use_hint( time )
{
	level notify( "fade_out_use_hint" );
	if ( !isdefined( time ) )
		time = 1.5;

	if ( !isdefined( level.use_hint ) )
		draw_use_hint();

	foreach ( elem in level.use_hint )
	{
		elem FadeOverTime( time );
		elem.alpha = 0;
	}
	level.use_hint_active = undefined;
}

use_pressed()
{
	return level.player UseButtonPressed();
}

get_blend_to_makarov_jump_dof()
{
	dofsets = [];
	dofsets[0] = level.dofDefault;

	// get to here quickly, the blend btn here and below
	dofsets[1] = [];
	dofsets[1][ "nearStart" ] = 1;
	dofsets[1][ "nearEnd" ] = 1;
	dofsets[1][ "nearBlur" ] = 6;
	dofsets[1][ "farStart" ] = 40;
	dofsets[1][ "farEnd" ] = 60;
	dofsets[1][ "farBlur" ] = 6;

	dofsets[2] = [];
	dofsets[2][ "nearStart" ] = 1;
	dofsets[2][ "nearEnd" ] = 40;
	dofsets[2][ "nearBlur" ] = 6;
	dofsets[2][ "farStart" ] = 100;
	dofsets[2][ "farEnd" ] = 220;
	dofsets[2][ "farBlur" ] = 6;
	
	level.player.dof_crossfade = 1;
	level.player.dof_crossfade_delta = 0.05;

	return dofsets;
}

anim_loop_solo_frozen( actor, anime, ender )
{
	scripted_node = self;
	if (isdefined(ender))
		scripted_node endon( ender );
	scripted_node thread anim_loop_solo( actor, anime, ender );
	anm = level.scr_anim[ actor.animname ][ anime ][ 0 ];
	actor SetAnim( anm, 1.0, 0.2, 0.0 );
}

anim_single_solo_trans( actor, anime, trans, tag )
{
	if (!isdefined(trans))
		trans = 0.0;
	anm = level.scr_anim[ actor.animname ][ anime ];
	time = GetAnimLength( anm );
	self thread anim_single_solo( actor, anime, tag );
	actor SetFlaggedAnimKnob( "single anim", anm, 1.0, trans, 1.0 );
	actor waittillmatch( "single anim", "end" );
}

anim_single_trans( actors, anime, trans, tag, curanime )
{
	if (!isdefined(trans))
		trans = 0.0;
	time = 0.0;
	actor = undefined;	
	foreach (actor in actors)
	{
		anm = actor GetAnim( anime );
		time = GetAnimLength( anm );
		self thread anim_single_solo( actor, anime, tag );
		actor SetFlaggedAnimKnob( "single anim", anm, 1.0, trans, 1.0 );
		if ((trans > 0.2) && isdefined(curanime))
		{	// work around the way internals work, since the anim_single_solo will set the interp out to 0.2
			anm = level.scr_anim[ actor.animname ][ curanime ];
			if (isdefined(anm))
				actor SetFlaggedAnim( "single anim", anm, 0.001, trans, 1.0 );
		}
	}
	if ((trans > 0.2) && isdefined(curanime) && (trans < time))
	{	// deal with longer transitions having issues with the fadeout transition of the previous anim
		wait trans;
		foreach (actor in actors)
		{
			anm = level.scr_anim[ actor.animname ][ curanime ];
			if (isdefined(anm))
				actor ClearAnim(  anm, 0.0 );
		}
		time -= trans;
	}
	actor waittillmatch( "single anim", "end" );
}

anim_loop_solo_trans( actor, anime, ender, trans )
{
	if (!isdefined(trans))
		trans = 0.0;
	anm = level.scr_anim[ actor.animname ][ anime ][0];
	self thread anim_loop_solo( actor, anime, ender );
	actor SetFlaggedAnimKnob( "looping anim", anm, 1.0, trans, 1.0 );
}

anim_loop_trans( actors, anime, ender, trans )
{
	if (!isdefined(trans))
		trans = 0.0;
	self thread anim_loop( actors, anime, ender );
	foreach (actor in actors)
	{
		anm = level.scr_anim[ actor.animname ][ anime ][0];
		actor SetFlaggedAnimKnob( "looping anim", anm, 1.0, trans, 1.0 );
	}
}

catch_rumble_notetrack( notetrack, rumble, anim_string )
{
	self notify("end_"+notetrack+anim_string);
	self endon("end_"+notetrack+anim_string);
	while (true)
	{
		self waittillmatch( anim_string, notetrack );
		level.player PlayRumbleOnEntity( rumble );
	}
}

catch_rumble_onoff(anim_string)
{
	self notify("end_rumble_onoff");
	self endon("end_rumble_onoff");
	while (true)
	{
		self waittillmatch( anim_string, "rumble_on" );
		if (isdefined(level.rumble_ent))
			level.rumble_ent.intensity = 1;
		self waittillmatch( anim_string, "rumble_off" );
		if (isdefined(level.rumble_ent))
			level.rumble_ent.intensity = 0;
	}
}

setup_player_rig_notetracks()
{
	anim_string = "single anim";
	self thread catch_rumble_notetrack( "rumble_light", "damage_light", anim_string );
	self thread catch_rumble_notetrack( "rumble_heavy", "damage_heavy", anim_string );
	self thread catch_rumble_notetrack( "rumble_small", "viewmodel_small", anim_string );
	self thread catch_rumble_notetrack( "rumble_medium", "viewmodel_medium", anim_string );
	self thread catch_rumble_notetrack( "rumble_large", "viewmodel_large", anim_string );
	self thread catch_rumble_notetrack( "rumble_falling_land", "falling_land", anim_string );
	self thread catch_rumble_onoff( anim_string );
	anim_string = "looping anim";
	self thread catch_rumble_notetrack( "rumble_light", "damage_light", anim_string );
	self thread catch_rumble_notetrack( "rumble_heavy", "damage_heavy", anim_string );
	self thread catch_rumble_notetrack( "rumble_small", "viewmodel_small", anim_string );
	self thread catch_rumble_notetrack( "rumble_medium", "viewmodel_medium", anim_string );
	self thread catch_rumble_notetrack( "rumble_large", "viewmodel_large", anim_string );
	self thread catch_rumble_notetrack( "rumble_falling_land", "falling_land", anim_string );
	self thread catch_rumble_onoff( anim_string );
}

//full screen blood bottom
play_fullscreen_blood_bottom(time, fadein, fadeout, max_alpha)
{
	overlay = NewClientHudElem( self );
	overlay.x = 0;
	overlay.y = 0;

	overlay SetShader( "fullscreen_bloodsplat_bottom", 640, 480 );
	
	overlay.splatter = true;
	overlay.alignX = "left";
	overlay.alignY = "top";
	overlay.sort = 1;
	overlay.foreground = 0;
	overlay.horzAlign = "fullscreen";
	overlay.vertAlign = "fullscreen";
	overlay.alpha = 0;
	
	fade_counter = 0;
	if (!IsDefined(fadein))
		fadein = 1;
	if (!IsDefined(fadeout))
		fadeout = 1;
	if (!IsDefined(max_alpha))
		max_alpha = 1;
	
	//fade up
	step_time = 0.05;
	
	if ( fadein > 0 )
	{
		current_alpha = 0;
		increment_alpha = max_alpha / (fadein/step_time); 
		AssertEx( increment_alpha > 0, "alpha not increasing; infinite loop" );
		while ( current_alpha < max_alpha )
		{
			overlay.alpha = current_alpha;
			current_alpha = current_alpha + increment_alpha;
			wait step_time;
	}
	}
	
	overlay.alpha = max_alpha;
	
	wait(time - (fadein + fadeout));

	//fade down
	if ( fadeout > 0 )
	{
		current_alpha = max_alpha;
		decrement_alpha = max_alpha / (fadeout/step_time);
		AssertEx( decrement_alpha > 0, "alpha not decreasing; infinite loop" );
		while ( current_alpha > 0 )
		{
			overlay.alpha = current_alpha;
			current_alpha = current_alpha - decrement_alpha;
			wait step_time;
		}
	}
	
	overlay.alpha = 0;
	
	overlay destroy();
}

play_fullscreen_blood(time, fadein, fadeout, max_alpha)
{
	/*sides = [];
	sides[ "bottom" ] = true;
	sides[ "left" ] = true;
	sides[ "right" ] = true;


	foreach ( type, _ in sides )
	{
		material = "fullscreen_bloodsplat_" + type;
		hud = self thread maps\_gameskill::display_screen_effect_nofade( "bloodsplat", type, material, undefined, RandomFloatRange( 0.45, 0.56 ), time );
	}*/
	
	overlay_left = NewClientHudElem( self );
	overlay_left.x = 0;
	overlay_left.y = 0;

	overlay_left SetShader( "fullscreen_bloodsplat_left", 640, 480 );
	
	overlay_left.splatter = true;
	overlay_left.alignX = "left";
	overlay_left.alignY = "top";
	overlay_left.sort = 1;
	overlay_left.foreground = 0;
	overlay_left.horzAlign = "fullscreen";
	overlay_left.vertAlign = "fullscreen";
	overlay_left.alpha = 0;
	
	overlay_right = NewClientHudElem( self );
	overlay_right.x = 0;
	overlay_right.y = 0;

	overlay_right SetShader( "fullscreen_bloodsplat_right", 640, 480 );
	
	overlay_right.splatter = true;
	overlay_right.alignX = "left";
	overlay_right.alignY = "top";
	overlay_right.sort = 1;
	overlay_right.foreground = 0;
	overlay_right.horzAlign = "fullscreen";
	overlay_right.vertAlign = "fullscreen";
	overlay_right.alpha = 0;
	
	if (!IsDefined(fadein))
		fadein = 1;
	if (!IsDefined(fadeout))
		fadeout = 1;
	if (!IsDefined(max_alpha))
		max_alpha = 1;
	
	//fade up
	step_time = 0.05;
	
	if ( fadein > 0 )
	{
		current_alpha = 0;
		increment_alpha = max_alpha / (fadein/step_time); 
		AssertEx( increment_alpha > 0, "alpha not increasing; infinite loop" );
		while ( current_alpha < max_alpha )
		{
			overlay_left.alpha = current_alpha;
			overlay_right.alpha = current_alpha;
			current_alpha = current_alpha + increment_alpha;
			wait step_time;
	}
	}
	
	overlay_left.alpha = max_alpha;
	overlay_right.alpha = max_alpha;
	
	wait(time - (fadein + fadeout));

	//fade down
	if ( fadeout > 0 )
	{
		current_alpha = max_alpha;
		decrement_alpha = max_alpha / (fadeout/step_time);
		AssertEx( decrement_alpha > 0, "alpha not decreasing; infinite loop" );
		while ( current_alpha > 0 )
		{
			overlay_left.alpha = current_alpha;
			overlay_right.alpha = current_alpha;
			current_alpha = current_alpha - decrement_alpha;
			wait step_time;
	}
	}
	
	overlay_left.alpha = 0;
	overlay_right.alpha = 0;
	
	overlay_left destroy();
	overlay_right destroy();
}

play_fullscreen_blood_splatter_alt(time, fadein, fadeout, max_alpha)
{
	overlay = NewClientHudElem( self );
	overlay.x = 0;
	overlay.y = 0;

	overlay SetShader( "splatter_alt_sp", 640, 480 );
	
	overlay.splatter = true;
	overlay.alignX = "left";
	overlay.alignY = "top";
	overlay.sort = 1;
	overlay.foreground = 0;
	overlay.horzAlign = "fullscreen";
	overlay.vertAlign = "fullscreen";
	overlay.alpha = 0;
	
	fade_counter = 0;
	if (!IsDefined(fadein))
		fadein = 1;
	if (!IsDefined(fadeout))
		fadeout = 1;
	if (!IsDefined(max_alpha))
		max_alpha = 1;
	
	//fade up
	step_time = 0.05;
	
	if ( fadein > 0 )
	{
		current_alpha = 0;
		increment_alpha = max_alpha / (fadein/step_time); 
		AssertEx( increment_alpha > 0, "alpha not increasing; infinite loop" );
		while ( current_alpha < max_alpha )
		{
			overlay.alpha = current_alpha;
			current_alpha = current_alpha + increment_alpha;
			wait step_time;
	}
	}
	
	overlay.alpha = max_alpha;
	
	wait(time - (fadein + fadeout));

	//fade down
	if ( fadeout > 0 )
	{
		current_alpha = max_alpha;
		decrement_alpha = max_alpha / (fadeout/step_time);
		AssertEx( decrement_alpha > 0, "alpha not decreasing; infinite loop" );
		while ( current_alpha > 0 )
		{
			overlay.alpha = current_alpha;
			current_alpha = current_alpha - decrement_alpha;
			wait step_time;
		}
	}
	
	overlay.alpha = 0;
	
	overlay destroy();
}
