#include maps\_shg_common;
#include common_scripts\utility;
#include maps\_anim;
#include maps\_audio;
#include maps\hijack_code;
#include maps\_utility;


handle_crash_fx()
{

	//called at the moment the teleport happens
	level waittill("crash_teleport");
	
	thread handle_sled_fx();
	thread handle_wing_fx();
	thread handle_engine_fx();
	thread handle_tail_fx();
	thread handle_tail_impact_fx();
	thread handle_volumetric_fx();
	
	level waittill("crash_impact");
	
	thread handle_paper_explosions();
	
	
	/*
	//sled fx, decompression
	woosh_ents = GetEntArray("sled_woosh_fx_origin", "script_noteworthy");
	foreach(ent in woosh_ents)
	{
		PlayFXOnTag(getfx("crash_cabin_decompression"), ent, "tag_origin");
	}
	
	//player sled, skidding along ground
	sled_skid_ents = GetEntArray("sled_skid_sparks_fx_origin", "script_noteworthy");	
	foreach(ent in sled_skid_ents)
	{
		fxID = getfx("crash_sled_scrape");
		PlayFXOnTag(fxID, ent, "tag_origin");
		ent thread stop_fx_on_notify(fxID, "sled_scrape_stop");
	}
	
	//debris coming off sled
	sled_debris_ents = GetEntArray("sled_skid_sparks_fx_origin", "script_noteworthy");	
	foreach(ent in sled_debris_ents)
	{
		PlayFXOnTag(getfx("crash_falling_debris"), ent, "tag_origin");
	}
	*/
	
	/*sled_fire_ents = GetEntArray("sled_fire_fx_origin", "script_noteworthy");
	foreach(ent in sled_fire_ents)
	{
		PlayFXOnTag(getfx("crash_falling_debris"), ent, "tag_origin");
	}*/

		
	//trail on tail
	/*
	tail_trail_ents = GetEntArray("crash_tail_fx_origin", "script_noteworthy");
	foreach(ent in tail_trail_ents)
	{
		PlayFXOnTag(getfx("crash_snow_trail"), ent, "tag_origin");		
	}
	*/
	//called when the player is thrown at the end of the crash (main logic handled in hijack_crash.gsc)
	level waittill("crash_throw_player");	
	
}

handle_paper_explosions()
{
	sled_drag_ents = GetEntArray("sled_paper_explosion", "script_noteworthy");	
	foreach(ent in sled_drag_ents)
	{
		fxID = getfx("hijack_paper_explosion");
		PlayFXOnTag(fxID, ent, "tag_origin");
		ent thread stop_fx_on_notify(fxID, "sled_scrape_stop");
		
	}
	
	level.crash_models[0] waittillmatch( "single anim", "paper_start" );
	PlayFXOnTag(getfx("hijack_crash_papers"), level.crash_models[0], "J_Mid_Section");	
	
	level.crash_models[0] waittillmatch( "single anim", "paper_stop" );
	StopFXOnTag(getfx("hijack_crash_papers"), level.crash_models[0], "J_Mid_Section");
}

handle_volumetric_fx()
{
	level waittill("crash_impact");
	
	wait 1;
	
	// double window (sled)
	crash_window_ents = GetEntArray("crash_window_volseq1", "script_noteworthy");	
	foreach(ent in crash_window_ents)
	{
		fxID = getfx("hijack_crash_window_volumetric");
		PlayFXOnTag(fxID, ent, "tag_origin");
		ent thread stop_fx_on_notify(fxID, "sled_scrape_stop");
		
	}
	
	wait 0.1;
	
	// double window (sled)
	crash_window_ents = GetEntArray("crash_window_volseq2", "script_noteworthy");	
	foreach(ent in crash_window_ents)
	{
		fxID = getfx("hijack_crash_window_volumetric");
		PlayFXOnTag(fxID, ent, "tag_origin");
		ent thread stop_fx_on_notify(fxID, "sled_scrape_stop");
		
	}
	
	wait 0.1;
	
	// double window (sled)
	crash_window_ents = GetEntArray("crash_window_volseq3", "script_noteworthy");	
	foreach(ent in crash_window_ents)
	{
		fxID = getfx("hijack_crash_window_volumetric");
		PlayFXOnTag(fxID, ent, "tag_origin");
		ent thread stop_fx_on_notify(fxID, "sled_scrape_stop");
		
	}
	
	wait 0.3;
	/*
	// damaged window (tail)
	crash_window_ents = GetEntArray("crash_window_volseq4", "script_noteworthy");	
	foreach(ent in crash_window_ents)
	{
		fxID = getfx("hijack_crash_window_volumetric");
		PlayFXOnTag(fxID, ent, "tag_origin");
		ent thread stop_fx_on_notify(fxID, "sled_scrape_stop");
		
	}
	*/
	wait 0.1;
	
	// destroyed window (tail)
	/*
	crash_window_ents = GetEntArray("crash_window_volseq5", "script_noteworthy");	
	foreach(ent in crash_window_ents)
	{
		fxID = getfx("hijack_crash_window_volumetric");
		PlayFXOnTag(fxID, ent, "tag_origin");
		ent thread stop_fx_on_notify(fxID, "sled_scrape_stop");
		
	}*/
	
	wait 0.1;
	
	// destroyed window (tail)
	crash_window_ents = GetEntArray("crash_window_volseq6", "script_noteworthy");	
	foreach(ent in crash_window_ents)
	{
		fxID = getfx("hijack_crash_window_volumetric");
		PlayFXOnTag(fxID, ent, "tag_origin");
		ent thread stop_fx_on_notify(fxID, "sled_scrape_stop");
		
	}
	
	wait 0.1;
	
	// double window (tail)
	crash_window_ents = GetEntArray("crash_window_volseq7", "script_noteworthy");	
	foreach(ent in crash_window_ents)
	{
		fxID = getfx("hijack_crash_window_volumetric");
		PlayFXOnTag(fxID, ent, "tag_origin");
		ent thread stop_fx_on_notify(fxID, "sled_scrape_stop");
		
	}	
	
}

handle_sled_fx()
{
	level.crash_models[0] waittillmatch( "single anim", "split" );
	
	sled_ent = level.crash_models[0];
	
	break_sparks_fx = getfx("fuselage_break_sparks1");
	
	PlayFXOnTag(break_sparks_fx, sled_ent, "FX_Mid_Break_1");
	PlayFXOnTag(break_sparks_fx, sled_ent, "FX_Mid_Break_2");
	PlayFXOnTag(break_sparks_fx, sled_ent, "FX_Mid_Break_3");
	
	sled_drag_ents = GetEntArray("sled_drag", "script_noteworthy");	
	foreach(ent in sled_drag_ents)
	{
		fxID = getfx("fuselage_scrape");
		PlayFXOnTag(fxID, ent, "tag_origin");
		ent thread stop_fx_on_notify(fxID, "sled_scrape_stop");
		
	}
	/*
	sparkBones		= ["J_cable_bundle_21", "J_cable_bundle_26", "J_cable_bundle_28"];	
	crash_spark_fx	= getfx("hijack_crash_sparks");
	
	level.crash_models[0] waittillmatch( "single anim", "separate" );
	foreach(bone in sparkBones)
	{
		PlayFXOnTag(crash_spark_fx, sled_ent, bone);
	}
	sled_ent thread stop_fx_on_notify(crash_spark_fx, "sled_scrape_stop");
	*/
}

handle_wing_fx()
{
	level waittill("crash_impact");
	
	wait 1;
	
	//PlayFXOnTag(getfx("wing_fuel_explosion"), level.crash_models[0], "FX_R_Wing_Mid_1");
	PlayFXOnTag(getfx("wing_fuel_explosion"), level.crash_models[0], "FX_R_Wing");
	level.crash_models[0] thread stop_fx_on_notify(getfx("wing_fuel_explosion"), "sled_scrape_stop");	
}

handle_engine_fx()
{
	wait 6.733;
	PlayFXOnTag(getfx("engine_explosion"), getent("engine_explosion", "script_noteworthy"), "tag_origin");
	
	// play FX on engine that crashes at the end
	level.crash_models[0] waittillmatch( "single anim", "engine_fire" );
	
	// engine trail effect
	PlayFXOnTag(getfx("hijack_engine_trail"), level.crash_models[0], "J_rwing_engine");
	
	// small debris effect
	enginePos = level.crash_models[0] GetTagOrigin("J_rwing_engine");
	PlayFX(getfx("hijack_engine_split"), enginePos);	
}

handle_tail_fx()
{
	tail_debris_fx	= getfx("smoke_geotrail_debris");
	explosion_fx	= getfx("reaper_explosion");
	trail_fx		= getfx("hijack_engine_split");
	tail_impact_fx	= getfx("tail_wing_impact");
	
	//wait 14.3667;
	wait 17.333;
	tail_wing_impact = GetEnt("tail_wing_impact1", "script_noteworthy");
	//PlayFXOnTag(getfx("tail_wing_impact"), tail_wing_impact, "tag_origin");
	PlayFXOnTag(trail_fx, tail_wing_impact, "tag_origin");
	PlayFXOnTag(explosion_fx, tail_wing_impact, "tag_origin");
	//PlayFXOnTag(tail_debris_fx, level.crash_models[0], "J_LFin_tip2");
	//PlayFXOnTag(tail_debris_fx, level.crash_models[0], "J_LFin_tip3");
	//PlayFXOnTag(tail_debris_fx, level.crash_models[0], "J_LFin_3");
	
	//explosionPos = level.crash_models[0] gettagorigin("J_LFin_tip2");
	//PlayFX(explosion_fx, explosionPos);
	level.player thread play_sound_on_entity( "hijk_explosion_lfe" );
	
	wait 0.7333;
	tail_wing_impact = GetEnt("tail_wing_impact2", "script_noteworthy");
	//PlayFXOnTag(getfx("tail_wing_impact"), tail_wing_impact, "tag_origin");
	PlayFX(tail_impact_fx, tail_wing_impact.origin);
	
	wait 0.2667;
	tail_wing_impact = GetEnt("tail_wing_impact3", "script_noteworthy");
	//PlayFXOnTag(explosion_fx, tail_wing_impact, "tag_origin");
	//PlayFXOnTag(tail_debris_fx, level.crash_models[0], "J_RFin_tip2");
		
	explosionPos = level.crash_models[0] gettagorigin("J_RFin_tip2");
	PlayFX(explosion_fx, explosionPos);
	level.player thread play_sound_on_entity( "hijk_explosion_lfe" );
		
	wait 1.7333;
	tail_wing_impact = GetEnt("tail_wing_impact4", "script_noteworthy");
	//PlayFXOnTag(getfx("tail_wing_impact"), tail_wing_impact, "tag_origin");
	PlayFX(tail_impact_fx, tail_wing_impact.origin);
	PlayFXOnTag(trail_fx, tail_wing_impact, "tag_origin");
	//PlayFXOnTag(tail_debris_fx, level.crash_models[0], "J_Fin2");
	//PlayFXOnTag(tail_debris_fx, level.crash_models[0], "J_Fin1");
	
	//explosionPos = level.crash_models[0] gettagorigin("J_Fin2");
	//PlayFX(explosion_fx, explosionPos);
	level.player thread play_sound_on_entity( "hijk_explosion_lfe" );
	
	wait 0.6;
	exploder(2000);
	
	//explosionPos = level.crash_models[0] gettagorigin("J_Fin2");
	//PlayFX(explosion_fx, explosionPos);
	aud_send_msg("tower_impact");
	
	level notify("tail_hits_tower");
}

handle_tail_impact_fx()
{
	tail_impact = GetEnt("tail_impact1", "script_noteworthy");
	wait 18.5;
	PlayFX(getfx("hijack_tail_impact"), tail_impact.origin);
	
	PlayFXOnTag(getfx("hijack_tail_trail"), level.crash_models[0], "J_Tail_Sled"); 
	level.crash_models[0] thread stop_fx_on_notify(getfx("hijack_tail_trail"), "sled_scrape_stop");	
	
	tail_impact = GetEnt("tail_impact2", "script_noteworthy");
	wait 1.3;
	PlayFX(getfx("hijack_tail_impact"), tail_impact.origin);
	
	tail_impact = GetEnt("tail_spray", "script_noteworthy");
	wait 1;
	PlayFX(getfx("hijack_tail_spray"), tail_impact.origin);
	
}


//copied from oilrig - just does a random light flicker (for pre-teleport, might not want this anymore)
fluorescentFlicker()
{
	level endon("stop_flicker");
	for ( ;; )
	{
		wait( randomfloatrange( .05, .1 ) );
		self setLightIntensity( randomfloatrange( .25, 3.0 ) );
	}
}

// FX lights for before you enter the sled.
handle_pre_sled_lights()
{
	flag_wait( "turn_on_crash_sled_lights" );
	thread pre_sled_light();
}

pre_sled_light()
{
	// light for door
	//door_spotlight_origin = getent("sled_door_light", "script_noteworthy");
	//door_light_fx = getfx("hijack_fxlight_default_tiny");
	//PlayFXOnTag(door_light_fx, door_spotlight_origin, "tag_origin");
	//door_spotlight_origin thread stop_fx_on_notify(door_light_fx, "crash_stop_pre_sled_lights");
	
	// light for hall between cargo and crash
	//hall_spotlight_origin = getentarray("sled_hall_light", "script_noteworthy"); 
	//hall_light_fx = getfx("hijack_fxlight_default_med_dim");
	//PlayFXOnTag(hall_light_fx, hall_spotlight_origin, "tag_origin");
	//hall_spotlight_origin thread stop_fx_on_notify(hall_light_fx, "crash_stop_pre_sled_lights");
	
	// when above lights turn off, we can afford to turn on this one, fill light for sled.
	//flag_wait( "player_is_in_end_room" );
	//level notify("crash_stop_pre_sled_lights");
	sled_fill_lights = getentarray("sled_fill_light", "script_noteworthy");
	foreach(ent in sled_fill_lights)
	{	
		id = getfx("hijack_fxlight_default_med_dim");
		PlayFXOnTag(id, ent, "tag_origin");
		ent thread stop_fx_on_notify(id, "crash_stop_pre_sled_lights");
	}
}

// put dynamic fxlights on sled/tail sections.
handle_crash_lights()
{
	
	//then turn on emergency lights in sled a moment later	
	sled_light_origins = getentarray("sled_emergency_light_fx", "script_noteworthy");
	id = getfx("hijack_fx_light_red_blink");
	
	foreach(ent in sled_light_origins)
	{	
		PlayFXOnTag(id, ent, "tag_origin");
		ent thread stop_fx_on_notify(id, "crash_impact");
	}

	thread sled_emergency_light_post_impact_flicker();
	
	sled_spotlight_origin = getent("sled_emergency_spotlight_fx", "script_noteworthy"); //can only have one of these in scene
	//id = getfx("hijack_fx_light_red_blink_spot");
	//PlayFXOnTag(id, sled_spotlight_origin, "tag_origin");
	//sled_spotlight_origin thread stop_fx_on_notify(id, "crash_stop_flashing_lights");

	//precrash_lights = GetEntArray("precrash_lights", "targetname");
	//array_thread(precrash_lights, ::fluorescentFlicker);
	
	level waittill("crash_sequence_done");
		
	//turn off dynamic lights
	/*foreach( light in precrash_lights)
	{
		level notify("stop_flicker");
		light SetLightIntensity(0);
	}*/
	
	//wait until we teleport.
	//level waittill("crash_teleport");
	//wait .1;
	
}
	
sled_emergency_light_post_impact_flicker()
{
	level waittill("crash_impact");
	wait 2.0;
	
	sled_light_origins = getentarray("sled_emergency_light_fx", "script_noteworthy");
	id = getfx("hijack_fxlight_red_blink_flicker");
		
	foreach(ent in sled_light_origins)
	{	
		PlayFXOnTag(id, ent, "tag_origin");
		ent thread stop_fx_on_notify(id, "crash_throw_player");
	}
	
	
	/*while(!flag("crash_throw_player"))
	{
		foreach(ent in sled_light_origins)
		{		
			PlayFXOnTag(id, ent, "tag_origin");		
		}
		
		wait(RandomFloatRange(0.2, 0.5));
		
		foreach(ent in sled_light_origins)
		{
			StopFXOnTag(id, ent, "tag_origin");
		}
		
		wait(RandomFloatRange(0.3, 0.6));		
	}*/
}

stop_fx_on_notify(id,msg)
{
	level waittill(msg);
	StopFXOnTag(id, self, "tag_origin");
}

custom_fire_fx(guy)
{
	guy.a.lastShootTime = gettime();
	
	guy thread play_sound_on_tag( "weap_ak47_fire_npc", "tag_flash" );
	
	PlayFXOnTag( getfx( "ak47_flash_wv_hijack_crash" ), guy, "tag_flash" );
	
	//do a trace straight ahead
	weaporig = guy gettagorigin( "tag_weapon" );
	dir = anglestoforward( guy getMuzzleAngle() );
	pos = weaporig + ( dir * 1000 );
	
	MagicBullet(guy.weapon, weaporig, pos);
	//print("boom");
}