#include maps\_utility;
#include maps\_anim;
#include common_scripts\utility;

/*
	TODO'S
	- Crash area
		- check so that other ai don't do stupid shit.
		- get dialogue changed. to be about woudned friendly.
	- Interrogation scene
		- Need a solution for making the glass on the shed door breakable and movable
		- get the shorter dialgoue in there.
		- Add running in to the house animations.
		- remove joke and just add a comment. "This place is a dump!" followed by laughter.
		- Farmer ragdoll notetrack to late.
	- Field area
		- Close the rear barn door, so that the player can't fall back once we know he's on the field.
		- have enemy soldiers hunt him down and kill him as soon as they unload if he's not in the basement area.
		- Chopper should shoot him when tries to rush the fast roping enemies in the field
		- Make helicopter door open.
		- Need an autosave in the field right before the chopper shows up
		- Dog from the truck across the field?
	- Basement area
		- Add flash bang dialogue.
		- Clear dialogue after eferyone is dead in the house.
		- Move farm flag trigger out side the building.
		- change the fallback stuff to targetent player.
	- Farm area
		- We may need another autosave in the farm area with the dogs
		- kill off the player if he moves up to fast. Have the helicopter spot him and gun him down.
	- Creek
		- Kill of the player if he falls back too far once the road area has started.
	
	- dialogue that you can't shoot the helicopter down with rifle fire.
		"Stop wasting ammo, we need something heavier to take that bird out."

*/

#using_animtree("generic_human");
main()
{
	setsaveddvar( "r_specularcolorscale", "1.5" );

//	setculldist( 14500 );

	add_start( "crash", ::start_crash );
	add_start( "path", ::start_dirt_path );
	add_start( "barn", ::start_barn );
	add_start( "field", ::start_field );
	add_start( "basement", ::start_basement );
	add_start( "dogs", ::start_farm );
	add_start( "farm", ::start_farm );
	add_start( "creek", ::start_creek );
	add_start( "greenhouse", ::start_greenhouse );
	add_start( "ac130", ::start_ac130);


	precacheShader( "overlay_hunted_red" );
	precacheShader( "overlay_hunted_black" );

	precachemodel( "weapon_saw_MG_setup" );
	precacheModel( "com_flashlight_on" );

	precacheItem( "hunted_crash_missile" );

	precacherumble ( "tank_rumble" );

	createthreatbiasgroup( "player" );
	createthreatbiasgroup( "dogs" );
	createthreatbiasgroup( "oblivious" );
	createthreatbiasgroup( "heli_guy" );

	setup_flags();

	default_start( ::start_default );

	maps\_truck::main("vehicle_pickup_4door");
	maps\_t72::main("vehicle_t72_tank");
	maps\_bm21_troops::main("vehicle_bm21_mobile_cover");
	maps\_bm21_troops::main("vehicle_bm21_mobile_bed");
	maps\_mi17::main("vehicle_mi17_woodland_fly");
	maps\_blackhawk::main("vehicle_blackhawk_hero");
	maps\_load::set_player_viewhand_model( "viewhands_player_usmc" );

	animscripts\dog_init::initDogAnimations();

	maps\createart\hunted_art::main();
	maps\hunted_fx::main();
	maps\_load::main();

	maps\_stinger::init();

	maps\hunted_anim::main();

	level.player setthreatbiasgroup( "player" );

	// make oblivious ingnored and ignore by everything.
	setignoremegroup( "allies", "oblivious" );	// oblivious ignore allies
	setignoremegroup( "axis", "oblivious" );	// oblivious ignore axis
	setignoremegroup( "player", "oblivious" );	// oblivious ignore player
	setignoremegroup( "oblivious", "allies" );	// allies ignore oblivious
	setignoremegroup( "oblivious", "axis" );	// axis ignore oblivious
	setignoremegroup( "oblivious", "oblivious" );	// oblivious ignore oblivious

	// make heli guy hate the player
	setignoremegroup( "heli_guy", "allies" );	// allies ignore oblivious
	setthreatbias( "player", "heli_guy", 1000000 );	// make the player a great threat

	level thread maps\hunted_amb::main();
	maps\_compass::setupMiniMap("compass_map_hunted");

	setup_setgoalvolume_trigger();
	setup_dogs();
	setup_visionset_trigger();
	setup_heli_guy();
	setup_spot_target();
	setup_helicopter_delete_node();
	setup_tmp_detour_node();
	setup_gas_station();
	setup_basement_door();

	battlechatter_off( "allies" );
	battlechatter_off( "axis" );

}

setup_flags()
{
	// flight
	flag_init( "blackhawk_hit" );
	flag_init( "blackhawk_down" );

	// crash area
	flag_init( "price_help" );
	flag_init( "wakeup_start" );
	flag_init( "wakeup_done" );
	flag_init( "wounded_check" );
	flag_init( "wounded_check_interrupted" );
	flag_init( "wounded_check_done" );

	// path area
	flag_init( "mark_at_goal" );
	flag_init( "trucks_warning" );
	flag_init( "tunnel_rush" );
	flag_init( "spawn_tunnel_helicopter" );
	flag_init( "helicopter_fly_over" );
	flag_init( "price_in_tunnel" );
	flag_init( "mark_in_tunnel" );

	// barn area
	flag_init( "barn_truck_arrived" );
	flag_trigger_init( "barn_moveup", getent( "tunnel_trigger", "script_noteworthy" ) );
	flag_init( "barn_interrogation_start" );
	flag_init( "barn_rear_open" );
	flag_init( "barn_front_open" );
	flag_init( "interrogation_done" );

	// first field area
	flag_init( "field_open" );
	flag_trigger_init( "field_cross", getent( "field_cross", "targetname" ) );
	flag_trigger_init( "field_cover", getent( "field_cover", "targetname" ) );
	flag_init( "field_defend" );
	flag_trigger_init( "field_basement", getent( "field_basement", "targetname" ) );
	flag_init( "field_open_basement" );
	flag_init( "hit_the_deck_music" );
	flag_init( "basement_door_open" );

	// basement area
	flag_init( "basement_open" );
	flag_trigger_init( "basement_enter", getent( "basement_enter", "targetname" ) );

//	can't do this since script_flag_wait initiates the flag in the vehicle script. That is bad, bad, bad.
//	flag_trigger_init( "basement_shine", getent( "basement_shine", "targetname" ) );

	flag_trigger_init( "trim_field", getent( "trim_field", "targetname" ) );
	flag_trigger_init( "basement_heli_takeoff", getent( "basement_heli_takeoff", "targetname" ) );

//	todo: check if nate fixed this.
//	can't do this since script_flag_wait initiates the flag in the vehicle script. That is bad, bad, bad.
//	flag_trigger_init( "basement_flash", getent( "basement_flash", "targetname" ) );

	flag_init( "squad_in_basement" );
	flag_init( "basement_secure" );

	// farm area
	flag_trigger_init( "farm_start", getent( "farm_start", "targetname" ) );
	flag_trigger_init( "farm_alert", getent( "farm_alert", "targetname" ) );
	flag_init( "farm_clear");
	
	// creek area
	flag_trigger_init( "creek_helicopter", getent( "creek_helicopter", "targetname" ) );
	flag_trigger_init( "creek_start", getent( "creek_start", "targetname" ) );
	flag_trigger_init( "creek_bridge", getent( "creek_bridge", "targetname" ) );
	flag_init( "creek_gate_open" );
	flag_init( "creek_truck_on_bridge" );

	// road area
	flag_trigger_init( "road_start", getent( "road_start", "targetname" ) );
	flag_init( "road_open_field" );
	flag_trigger_init( "roadblock", getent( "roadblock", "targetname" ) );
	flag_init( "roadblock_start" );
	flag_init( "roadblock_done" );
	flag_trigger_init( "road_field_search", getent( "road_field_search", "targetname" ) );
	flag_init( "road_field_end" );

	// greenhouse area
	flag_trigger_init( "greenhouse_area", getent( "greenhouse_area", "targetname" ) );
	flag_init( "helicopter_down" );
	flag_trigger_init( "greenhouse_rear_exit", getent( "greenhouse_rear_exit", "targetname" ), true );
	flag_init( "greenhouse_done" );

	// AC-130 area
	flag_trigger_init( "gasstation_start", getent( "gasstation_start", "targetname" ) );
	flag_trigger_init( "ac130_inplace", getent( "ac130_inplace", "targetname" ) );
	flag_init( "ac130_barrage" );
	flag_init( "go_dazed" );
	flag_init( "ac130_barrage_over" );

	// other flags
	flag_init( "helicopter_unloading" );
	flag_init( "player_interruption" );

}

/**** objectives ****/

objective_lz()
{
	lz_origin = getstruct( "bridge_origin", "targetname" );
	objective_add( 1, "active", &"HUNTED_OBJ_EXTRACTION_POINT", lz_origin.origin );
	objective_current( 1 );
}

objective_stinger()
{
	stinger_origin = getent( "stinger_objective", "targetname" );
	objective_add( 2, "active", &"HUNTED_OBJ_DESTROY_HELICOPTER", stinger_origin.origin );
	objective_current( 2 );
	flag_wait ( "helicopter_down" );
	wait 1;
	objective_state( 2, "done" );
	objective_current( 1 );
}

/**** helicopter flight ****/
area_flight_init()
{
	thread hud_hide( true );

	crash_mask = getent( "crash_mask", "targetname" );
	crash_mask.origin = crash_mask.origin + (-3000,64,64);

	level.player disableweapons();
	level thread fligth_missile();

	VisionSetNaked( "hunted_crash", 0 );
	flight_helicopter();

	setExpFog(2500, 5000, 0.045, 0.17, 0.2, 0);

	crash_mask delete();

	thread area_crash_init();

}

flight_dialogue()
{
	wait 8;
//	fake_price thread queue_anim( "incomingmissile" );
	self play_sound_on_tag( "hunted_pri_incomingmissile", "tag_guy7");
	self play_sound_on_tag( "hunted_hp1_missileinbound", "tag_driver");

	flag_wait( "blackhawk_hit" );
	wait 1;
	self play_sound_on_tag( "hunted_hp1_maydaymayday", "tag_driver");
//	self play_sound_on_tag( "hunted_hp1_goingdown", "tag_driver");
}

fligth_missile()
{
	missile_point = getstruct( "missile_point", "script_noteworthy" );
	missile_point waittill( "trigger", blackhawk );

	missile_source = getent( "missile_source", "targetname" );
	missile_source hide();

	missile_source setVehWeapon( "hunted_crash_missile" );
	missile_source setturrettargetent( blackhawk );
	wait 1.5;

	dummy_target = getent( "dummy_target", "targetname" );

	missile = missile_source fireweapon( "tag_gun_r", dummy_target, ( 0,0,0 ) );

	while( distance2d( missile.origin, dummy_target.origin ) > 350 && isdefined(missile) )
		wait 0.05;

	maps\_vehicle::delete_group( missile_source );

	missile missile_settarget( blackhawk, ( 80,20,-200 ) );

	wait 2;

	old_dist = distancesquared( missile.origin, blackhawk.origin );
	wait 0.05;
	while( distancesquared( missile.origin, blackhawk.origin ) < old_dist )
	{
		old_dist = distancesquared( missile.origin, blackhawk.origin );
		wait 0.1;
	}

	org = missile.origin;
	missile delete();
	
	playfx( level._effect["missile_explosion"], org );

	level thread play_sound_in_space( "car_explode", org );

	flag_set( "blackhawk_hit" );

}

kill_missile( missile )
{
	missile delete();
}

flight_crash()
{
	flag_wait( "blackhawk_hit" );

	self thread flight_crash_rotate();
	self thread flight_crash_overlay();
	
	struct = getstruct( "crash_location", "targetname" );
	self thread heli_path_speed(  struct );

	self playsound( "blackhawk_helicopter_hit" );
	wait 0.5;
	self playsound( "blackhawk_helicopter_dying_loop" );
	wait 8.5;
	self playsound( "blackhawk_helicopter_crash" );
	self stopenginesound();
	self notify( "stop_rotate" );
	wait 7;
	flag_set( "blackhawk_down" );

	self delete();
}

flight_crash_overlay()
{
	red_overlay = create_overlay_element( "overlay_hunted_red", 0 );
	black_overlay = create_overlay_element( "overlay_hunted_black", 0 );
	wait 4;
	red_overlay thread exp_fade_overlay( 1, 4.5);
	black_overlay thread exp_fade_overlay( 0.5, 4.5);
	wait 5.25;
	black_overlay thread fade_overlay( 1, 0.1);

//	black_overlay thread fade_overlay( 1, 1);
	
	flag_wait( "blackhawk_down" );
	red_overlay destroy();
	black_overlay thread fade_overlay( 0, 4);

}

flight_crash_rotate()
{
	self setturningability( 1 );
	self setyawspeed( 1200, 100);

	self endon( "stop_rotate" );
	while ( true )
	{
		earthquake( 0.4, .35, self.origin, 256 );
		level.player PlayRumbleOnEntity( "tank_rumble" );
		self settargetyaw( self.angles[1] - 170 );
		wait 0.1;
	}
}

flight_helicopter()
{
	blackhawk = maps\_vehicle::spawn_vehicle_from_targetname_and_drive( "crash_blackhawk" );
	blackhawk thread maps\_vehicle::lights_on( "interior" );

	blackhawk setturningability( 0.2 );
	blackhawk thread flight_crash();
	blackhawk maps\_vehicle::godon();

	blackhawk thread flight_dialogue();

	playfxontag( level._effect["heli_dlight"], blackhawk, "tag_player" );

	blackhawk.tag_ent = blackhawk fake_tag( "tag_origin", (-10,32,-132), (0,140,0) );

	level.player playerlinktodelta( blackhawk.tag_ent, "tag_origin", 0.5, 80, 80, 0, 20);
	level.player setplayerangles( (0,35,0) );

	flag_wait( "blackhawk_down" );
	level.player unlink();

}

fake_tag( tag, origin_offset, angles_offset )
{
	ent = spawn( "script_model", self.origin);
	ent setmodel( "tag_origin" );
	ent hide();
	ent linkto( self, tag, origin_offset, angles_offset );
	return ent;
}

/**** crash area ****/
area_crash_init()
{
	// todo: tweak to the lowest value possible.
	setculldist( 14500 );
	setExpFog(512, 6145, 0.132176, 0.192839, 0.238414, 0);
	VisionSetNaked( "hunted", 0 );

	setup_friendlies();

	array_thread( level.squad, ::set_fixednode, false );

	level thread crash_player();
	level.price thread crash_price();
	level.steve thread crash_steve();
	level thread crash_wounded_dialogue();
	level thread music();

	flag_set("price_help");

	flag_wait( "wakeup_done" );

	hud_hide( false );

	getent( "path_trigger", "targetname" ) waittill( "trigger" );

	flag_set( "wounded_check_interrupted" );

	flag_wait( "wounded_check_done" );

	level thread area_dirt_path_init();
}

crash_wounded_dialogue()
{
	flag_wait( "wakeup_done" );

//	level.price queue_anim( "getequipoutchopper" );
	wait 1;
	level.mark queue_anim( "howsourvip" );
	wait 1;
	level.steve queue_anim( "check_soldier" );
}

crash_price()
{
	anim_ent = getent( "start_animent", "targetname" );
	flag_wait("price_help");

	self notify( "stop_going_to_node" );

	wait 7.5;

	self set_run_anim( "path_slow" );

	anim_ent anim_reach_solo( self, "hunted_opening_price" );
	flag_set( "wakeup_start" );

	anim_ent thread anim_single_solo( self, "hunted_opening_price" );

	self waittillmatch( "single anim", "fuel_ignition");

	maps\hunted_fx::fuel_explosion();

	node = getnode( "price_dirt_path", "targetname" );
	self set_goalnode( node );
}

crash_steve()
{
	self set_run_anim( "path_slow" );

	anim_ent = getent( "wounded_animent", "targetname" );
	wounded = crash_setup_wounded( anim_ent );

	flag_wait( "wounded_check" );

	wait 18;

	self notify( "stop_going_to_node" );
	anim_ent anim_reach_solo( self, "hunted_woundedhostage_check" );

	actors[0] = level.steve;
	actors[1] = wounded;

	anim_ent notify( "stop_idle" );

	thread crash_wounded_interrupt( wounded );

	anim_ent anim_single( actors, "hunted_woundedhostage_check" );
	flag_set( "wounded_check_done" );
	anim_ent thread anim_loop_solo( wounded, "hunted_woundedhostage_idle_end", undefined, "stop_idle" );

	anim_ent anim_single_solo( level.steve, "hunted_woundedhostage_check_end" );

	self set_goalnode( getnode( "steve_dirt_path", "targetname" ) );

	flag_wait( "tunnel_rush" );
	wounded delete();

}

crash_wounded_interrupt( wounded )
{
	level endon( "wounded_check_done" );

	wait 7;

	flag_wait( "wounded_check_interrupted" );

	level.steve stopanimscripted();
	wounded stopanimscripted();
	level.steve notify( "single anim", "end" );
	wounded notify( "single anim", "end" );
}

crash_setup_wounded( anim_ent )
{
	model = level.charlie.model;

	wounded = spawn( "script_model", anim_ent.origin );
	wounded setmodel( model );
	wounded useAnimTree( #animtree );

	attachSize = level.charlie getAttachSize();
	for (i = 0; i < attachSize; i++)
	{
		head = level.charlie getAttachModelName(i);
		if ( !issubstr( head, "head" ) )
			continue;
		tag = level.charlie getAttachTagName(i);
		wounded attach( head, tag );
		break;
	}

	wounded.animname = "wounded";
	anim_ent thread anim_loop_solo( wounded, "hunted_woundedhostage_idle_start", undefined, "stop_idle" );

	return wounded;
}

crash_player()
{
	level thread crash_wakeup();

	level.player.g_speed = int( getdvar( "g_speed" ) );
	setsaveddvar( "g_speed", 130 );

	flag_set( "wounded_check" );

	flag_wait("wakeup_done");

	level.player EnableWeapons();

//	give_weapons();

}

#using_animtree("player");
crash_wakeup()
{
	anim_ent = getent( "start_animent", "targetname" );

	start_origin = getstartorigin( anim_ent.origin, anim_ent.angles, %hunted_opening_player );
	start_angles = getstartangles( anim_ent.origin, anim_ent.angles, %hunted_opening_player );

	view_ent = PlayerView_Spawn( start_origin, start_angles );
	level.player setorigin( start_origin );
	level.player setplayerangles( start_angles ); 
	level.player playerlinktoabsolute( view_ent, "tag_player" );

	view_ent setflaggedanimrestart( "viewanim", %hunted_opening_player_idle );

	level thread crash_wakeup_overlay();
	flag_wait( "wakeup_start" );
	view_ent clearanim( %hunted_opening_player_idle, 0 );
	view_ent setflaggedanimrestart( "viewanim", %hunted_opening_player );
	view_ent animscripts\shared::DoNoteTracks( "viewanim" );

	view_ent clearanim( %hunted_opening_player, 0 );

	level.player unlink();
	view_ent delete();
	flag_set( "wakeup_done" );

}

PlayerView_Spawn( start_origin, start_angles )
{
	playerView = spawn( "script_model", start_origin );
	playerView.angles = start_angles;
	playerView setModel( "viewhands_player_usmc" );
	playerView useAnimTree( #animtree );
	playerView hide();

	return playerView;
}

#using_animtree("generic_human");
crash_wakeup_overlay()
{
/*	if (true)
	{
		wait 2+1.5+1.5+3+2+.5+2+1+3;
		return;
	}
*/
	red_overlay = create_overlay_element( "overlay_low_health", 0 );
	black_overlay = create_overlay_element( "overlay_hunted_black", 1 );

	wait 2;
	setblur(4, 0);
	// todo: put a shellshock in here maybe?
	
	black_overlay thread exp_fade_overlay( 0.25, 4);
	wait 1.5;
	level.player play_sound_on_entity("breathing_better");
	wait 1.5;
	setblur(0, 2);
	wait 3;
	black_overlay exp_fade_overlay( 1, 2);
	wait .5;
	black_overlay thread exp_fade_overlay( 0, 3);
	wait 2;
	setblur(2, 1);
	wait 1;
	setblur(0, 2);
	wait 2;

	black_overlay destroy();
	red_overlay destroy();
}

/**** dirt path area ****/
area_dirt_path_init()
{
	autosave_by_name( "dirt_path" );

	level thread objective_lz();

	level thread dirt_path_truck();
	level thread dirt_path_barn_truck();
	level thread dirt_path_helicopter();
	level thread dirt_path_allies();
	level thread dirt_path_player_speed();
	level thread dirt_path_player();

	level thread player_interruption();

	flag_wait( "price_in_tunnel" );
	flag_wait( "mark_in_tunnel" );
	flag_wait( "barn_moveup" );

	level thread area_barn_init();
}

dirt_path_allies()
{
	level.price thread dirt_path_price();
	level.steve thread dirt_path_steve();
	level.charlie thread dirt_path_charlie();
	level.mark thread dirt_path_mark();
}

dirt_path_player()
{
	flag_wait("tunnel_rush");
	wait 1;
	for (i = int( getdvar( "g_speed" ) ); i<level.player.g_speed; i++)
	{
		setsaveddvar( "g_speed", int(i) );
		wait 0.15;
	}
	setsaveddvar( "g_speed", level.player.g_speed );
	level.player.g_speed = undefined;
}

dirt_path_price()
{
	self notify( "stop_going_to_node" );

	self thread queue_anim( "lowprofile" );
	
	node = getnode( "price_dirt_path", "targetname" );
	self set_run_anim( "path_slow" );
	self pushplayer( true );
	self thread follow_path( node );
	self thread dynamic_run_speed( 200 );

	trigger = getent( "truck_alert", "targetname" );
	trigger waittill( "trigger" );

	self notify( "stop_path" );
	self notify( "stop_dynamic_run_speed" );
	self.animplaybackrate = 1;
	self clear_run_anim();

	anim_ent = getent( "truck_warning_animent", "targetname" );
	anim_ent anim_reach_solo( self, "hunted_wave_chat" );

	flag_set("trucks_warning");
	anim_ent anim_single_solo( self, "hunted_wave_chat" );

	self.disableArrivals = false;

	anim_ent = getent( "tunnel_animent", "targetname" );
	anim_ent anim_reach_solo( self, "hunted_tunnel_guy2_runin" );

	anim_ent anim_single_solo( self, "hunted_tunnel_guy2_runin" );
	anim_ent thread anim_loop_solo( self, "hunted_tunnel_guy2_idle", undefined, "price_stop_idle" );
	
	wait 3;

	flag_wait( "helicopter_fly_over" );

	flag_set( "price_in_tunnel" );

	getent( "tunnel_trigger", "script_noteworthy" ) thread trigger_timeout( 5 );
	flag_wait_either( "barn_moveup", "player_interruption" );
	flag_set( "barn_moveup" );

	anim_ent notify( "price_stop_idle" );
	if ( flag( "player_interruption" ) )
		anim_ent anim_single_solo( self, "hunted_tunnel_guy2_runout_interrupt" );
	else
		anim_ent anim_single_solo( self, "hunted_tunnel_guy2_runout" );

	self pushplayer( false );
}

dirt_path_charlie()
{
	anim_ent = getent( "truck_warning_animent", "targetname" );
	anim_ent anim_reach_and_idle_solo( self, "hunted_wave_chat", "hunted_spotter_idle", "charlie_stop_idle" );

	flag_wait("trucks_warning");

	level thread flag_set_delayed( "tunnel_rush", 3);

	anim_ent notify( "charlie_stop_idle" );
	anim_ent anim_single_solo( self, "hunted_wave_chat" );

	node = getnode( "charlie_tunnel", "targetname" );
	self setgoalnode( node );
	self.goalradius = 0;
	self waittill("goal");
	self clear_run_anim();
}

dirt_path_mark()
{
	self notify( "stop_going_to_node" );

	node = getnode( "mark_dirt_path", "targetname" );

	self set_run_anim( "path_slow" );
	self thread follow_path( node );
	self thread dynamic_run_speed( 600 );
	self thread dirt_path_mark_path_end();
	self pushplayer( true );

	flag_wait("tunnel_rush");

	self notify( "stop_path" );
	self notify( "stop_dynamic_run_speed" );

	self.animplaybackrate = 1;
	self clear_run_anim();
	self.disableArrivals = false;

	self pushplayer( true );

	anim_ent = getent( "tunnel_animent", "targetname" );
	anim_ent anim_reach_solo( self, "hunted_tunnel_guy1_runin" );
	anim_ent anim_single_solo( self, "hunted_tunnel_guy1_runin" );

	if ( !flag( "helicopter_fly_over" ) )
	{
		anim_ent thread anim_loop_solo( self, "hunted_tunnel_guy1_idle", undefined, "mark_stop_idle" );

		flag_wait( "helicopter_fly_over" );

		anim_ent notify( "mark_stop_idle" );
		anim_ent anim_single_solo( self, "hunted_tunnel_guy1_lookup" );
	}

	anim_ent thread anim_loop_solo( self, "hunted_tunnel_guy1_idle", undefined, "mark_stop_idle" );

	flag_set( "mark_in_tunnel" );
	flag_wait( "barn_moveup" );

	wait 2;
	anim_ent notify( "mark_stop_idle" );
	anim_ent anim_single_solo( self, "hunted_tunnel_guy1_runout" );
	self pushplayer( false );
}

dirt_path_mark_path_end()
{
	self endon( "stop_path" );
	self waittill( "path_end_reached" );
	flag_set ("mark_at_goal");
}

dirt_path_steve()
{
	self notify( "stop_going_to_node" );

	node = getnode( "steve_dirt_path", "targetname" );
	self set_run_anim( "path_slow" );
//	self thread dynamic_run_speed( 300 );
	self thread follow_path( node );

	self pushplayer( true );

	flag_wait("trucks_warning");

	self notify( "stop_path" );
	self notify( "stop_dynamic_run_speed" );
	self.animplaybackrate = 1;
	self clear_run_anim();

	self.disableArrivals = false;
	node = getnode( "steve_tunnel", "targetname" );
	self setgoalnode( node );
	self.goalradius = 0;
	self pushplayer( false );

}

dirt_path_helicopter()
{
	flag_wait( "spawn_tunnel_helicopter" );

	helicopter = maps\_vehicle::spawn_vehicle_from_targetname( "tunnel_heli" );

	helicopter sethoverparams(128, 10, 3);

	assert( isdefined( helicopter.riders ) );
	for ( i=0; i<helicopter.riders.size; i++ )
	{
		helicopter.riders[i] setthreatbiasgroup ( "oblivious" );
		helicopter.riders[i] thread delete_on_unloaded();
	}

	helicopter thread heli_path_speed();
	helicopter waittill_either( "near_goal", "goal" );
	wait 0.05;

	helicopter_alloted_time = level.move_time;
	fly_over_point = getstruct( "fly_over_point", "script_noteworthy" );
	dist = distance( helicopter.origin, fly_over_point.origin );
	MPH = dist / helicopter_alloted_time / 17.6;

	helicopter setSpeed( MPH, MPH);
	helicopter helicopter_searchlight_on();

	fly_over_point waittill( "trigger" );
	flag_set( "helicopter_fly_over" );

}

dirt_path_player_speed()
{
	calc_speed_trigger = getent( "calc_speed_trigger", "script_noteworthy" ) ;
	helicopter_trigger = getent( "helicopter_trigger", "script_noteworthy" ) ;

	calc_speed_trigger waittill( "trigger" );
	start_time = gettime();

	helicopter_trigger waittill( "trigger" );
	end_time = gettime();

	move_time = (end_time - start_time) / 1000;

	if ( move_time > 0.75 )
		move_time = 0.75;

	move_time = 1 + move_time * 4;

	level.move_time = move_time;

	// no helicopter until the tunnel rush is started.
	flag_wait ( "tunnel_rush" );
	flag_set( "spawn_tunnel_helicopter" );
}

dirt_path_truck()
{
	flag_wait("trucks_warning");
	wait 2;

	truck = maps\_vehicle::spawn_vehicle_from_targetname( "path_truck" );
	thread maps\_vehicle::gopath ( truck );
	truck maps\_vehicle::lights_on( "headlights" );

}

player_interruption()
{
	flag_wait( "tunnel_rush" );

	wait 3;

	level thread set_flag_on_player_action( "player_interruption", 5, false, true);
}

dirt_path_barn_truck()
{
	flag_wait("trucks_warning");
	wait 2;

	truck  = maps\_vehicle::spawn_vehicle_from_targetname( "barn_truck" );
	truck.health = 10000000;

	barn_axis = truck.riders;

	for ( i=0; i<barn_axis.size; i++ )
	{
		barn_axis[i] thread magic_bullet_shield();
		barn_axis[i] setthreatbiasgroup ( "oblivious" );
	}

	thread maps\_vehicle::gopath ( truck );
	truck maps\_vehicle::lights_on( "headlights" );

	// todo: add joke
//	truck thread barn_russian_joke( thugs );

	truck waittill( "reached_end_node" );
	wait 1;

	flag_set("barn_truck_arrived");

	array_thread( barn_axis, ::stop_magic_bullet_shield );

	// reconnects the path that got disconnected when the truck stoped.
	truck connectpaths();

	if ( !flag( "player_interruption" ) )
	{
		activate_trigger_with_targetname( "barn_truck_color_init" );
		flag_wait( "interrogation_done" );
	}

	truck dirt_path_disable_truck();
}

dirt_path_disable_truck()
{
	wait 10;

//	self maps\_vehicle::lights_off ( "headlights" );

	while ( true )
	{
		playfx( level._effect["truck_smoke"], self gettagorigin( "tag_engine_left" ) );
		wait .5;
	}
}
/**** barn area ****/

area_barn_init()
{
	if ( !flag("player_interruption") )
	{
		autosave_by_name( "barn" );
		level thread set_flag_on_player_action( "player_interruption", 1, true, true);
	}

	getent( "barn_traverse", "targetname" ) connectpaths();

	level thread barn_early_interruption();

	level thread barn_interrogation_wait();

	level.price thread barn_price_moveup();
	level.mark thread barn_mark_moveup();

	level.steve set_force_color( "r" );
	level.charlie set_force_color( "r" );

	flag_wait( "barn_front_open" );
	
	waittill_aigroupcleared( "barn_enemies" );

	level.mark disable_ai_color();
	level.price disable_ai_color();
	level.steve disable_ai_color();
	level.charlie disable_ai_color();

	level.price set_goalnode( getnode( "price_barn_exterior", "targetname" ) );
	level.mark set_goalnode( getnode( "mark_barn_exterior2", "targetname" ) );
	level.steve set_goalnode( getnode( "steve_barn_exterior", "targetname" ) );
	level.charlie set_goalnode( getnode( "charlie_barn_exterior", "targetname" ) );

	level.mark waittill( "goal" );
	
	level thread area_field_init();

}

barn_interrogation_wait()
{
	level endon( "player_interruption" );
	flag_wait( "barn_interrogation_start" );

	wait 2;

	level notify( "stop_barn_early_interruption" );

	level thread barn_interrogation();
}

barn_interrogation()
{
	anim_ent = getent( "barnfarm_animent","targetname");

	farmer = scripted_spawn( "farmer", "targetname", true );
	farmer set_battlechatter( false );
	farmer.animname = "farmer";
	farmer setthreatbiasgroup( "oblivious" );

	// todo: see if this works.
	farmer gun_remove();

//	farmer animscripts\shared::detachWeapon( farmer.weapon );
//	farmer detachall();


	leader = undefined;
	thug = undefined;
	thug2 = undefined;

	axis = getaiarray( "axis" );
	for ( i=0; i<axis.size; i++ )
	{
		if ( isdefined( axis[i].script_noteworthy ) && axis[i].script_noteworthy == "leader" )
			leader = axis[i];
		if ( isdefined( axis[i].script_noteworthy ) && axis[i].script_noteworthy == "thug" )
			thug = axis[i];
		if ( isdefined( axis[i].script_noteworthy ) && axis[i].script_noteworthy == "thug2" )
			thug2 = axis[i];
	}

	assert( isdefined( leader ) && isdefined( thug ) && isdefined( farmer ) );

	leader.animname = "leader";
	thug.animname = "thug";
	thug2.animname = "thug2";

	actors[0] = leader;
	actors[1] = farmer;
	actors[2] = thug;
	actors[3] = thug2;

	level thread barn_interrogation_dialogue( leader, farmer );
	level thread barn_interrogation_interruption();

	array_thread( actors, ::barn_abort_actors );

	farmer thread barn_farmer( anim_ent );
	barn_interrogation_anim( anim_ent, actors );

	activate_trigger_with_targetname( "barn_ambush_color_init" );
	setthreatbiasgroup_on_array( "axis", get_ai_group_ai( "barn_enemies" ) );
//	array_thread( get_ai_group_ai( "barn_enemies" ), ::expand_goalradius_ongoal );

	if ( isalive( farmer ) )
		farmer set_goalnode( getnode( "hide", "targetname" ) );

	if ( isalive( leader ) && !flag( "player_interruption" ) )
	{
		leader dodamage( leader.health + 5, level.player.origin );
	}

	flag_set( "interrogation_done" );
	flag_set( "player_interruption" );

}

barn_interrogation_dialogue( leader, farmer )
{
	leader endon( "death" );
	farmer endon( "death" );
	level endon( "player_interruption" );

	level.price thread barn_price_dialogue();

	wait 2;
	farmer playsound( "hunted_ruf_whatsgoingon" );
	wait 3.5;
	leader playsound( "hunted_ru1_dontplaystupid" );
	wait 4;
	farmer playsound( "hunted_ruf_hidingwho" );
	wait 3.75;
	leader playsound( "hunted_ru2_yougotanimals" );
	wait 4;
	farmer playsound( "hunted_ruf_american" );
	wait 1.5;
	leader playsound( "hunted_ru1_forgetit" );
}

barn_price_dialogue()
{
	level endon( "player_interruption" );
	// todo: change this to notetrack and get rid of the waittill

	wait 16;
	level.price thread queue_anim( "killoldman" );
}

barn_interrogation_interruption()
{
	level endon( "interrogation_done" );
	level endon( "kill_action_flag" );

	flag_wait( "player_interruption" );
	level notify( "interrogation_interrupted" );
}

barn_interrogation_anim( anim_ent, actors )
{
	level endon( "interrogation_interrupted" );

	anim_ent thread anim_single( actors, "hunted_farmsequence");
	actors[0] waittillmatch( "single anim", "fire" );
	level notify( "kill_farmer_thread" );
	actors[0] waittillmatch( "single anim", "pistol_putaway" );
}

barn_abort_actors()
{
	level endon( "interrogation_done" );

	flag_wait( "player_interruption" );

	self stopanimscripted();
	self notify( "single anim", "end" );
}

barn_farmer( anim_ent )
{
	level endon( "interrupt_farmer" );
	self endon( "death" );

	self thread barn_farmer_interrupt();

	self set_ignoreSuppression( true );

	self waittillmatch( "single anim", "end" );
	anim_ent thread anim_loop_solo( self, "farmer_deathpose");

	flag_wait( "field_cover" );
	self delete();
}

barn_farmer_interrupt()
{
	level endon( "kill_farmer_thread" );
	flag_wait( "player_interruption" );
	level notify( "interrupt_farmer" );
}

barn_early_interruption()
{
	level endon( "stop_barn_early_interruption" );

	flag_wait( "player_interruption" );

	setthreatbiasgroup_on_array( "axis", get_ai_group_ai( "barn_enemies" ) );
//	array_thread( get_ai_group_ai( "barn_enemies" ), ::expand_goalradius_ongoal );

	wait 0.5;
	
	array_thread( level.squad, ::set_force_color, "y" );
	activate_trigger_with_targetname( "barn_early_interruption" );

	level.price notify( "end_wait" );

	while( get_ai_group_count( "barn_enemies" ) > 2 )
		wait 0.05;

	level.mark disable_ai_color();
	level.price disable_ai_color();
	level.steve set_force_color( "r" );
	level.charlie set_force_color( "r" );

	level.price thread barn_early_interruption_price();
}

barn_early_interruption_price()
{
	self barn_price_move_to_door();
	self barn_price_wait_at_door();

	trigger = getent( "barn_rear_trigger", "script_noteworthy" );
	trigger waittill( "trigger" );

	self barn_price_open_door();
	self price_enter_barn();
}

barn_price_moveup()
{
	self barn_price_move_to_door();

	if ( flag( "player_interruption" ) )
		return;	

	self barn_price_wait_at_door();

	trigger = getent( "barn_rear_trigger", "script_noteworthy" );
	trigger waittill( "trigger" );

	flag_wait( "barn_truck_arrived" );

	if ( flag( "player_interruption" ) )
		return;	

	flag_set( "barn_interrogation_start" );

	self barn_price_open_door();
	self price_enter_barn();
}

price_enter_barn()
{
	self enable_cqbwalk();
	self make_ai_move();
	self set_goalnode( getnode( "price_barn_interior", "targetname" ) );
	self waittill( "goal" );
	self make_ai_normal();
	self disable_cqbwalk();
}

barn_price_move_to_door()
{
	anim_ent = getnode( "price_barn_rear", "targetname" );
	anim_ent anim_reach_solo( self, "hunted_open_barndoor_stop" );
	self waittill( "goal" );
}

barn_price_wait_at_door()
{
	anim_ent = getnode( "price_barn_rear", "targetname" );
	anim_ent anim_single_solo( self, "hunted_open_barndoor_stop" );
	self thread barn_price_wait_at_door_idle();
}

barn_price_wait_at_door_idle()
{
	anim_ent = getnode( "price_barn_rear", "targetname" );
	anim_ent thread anim_loop_solo( self, "hunted_open_barndoor_idle", undefined, "stop_idle" );
	self waittill( "end_wait" );
	anim_ent notify( "stop_idle" );
}

barn_price_open_door()
{
	self notify( "end_wait" );

	anim_ent = getnode( "price_barn_rear", "targetname" );

	if ( !flag( "player_interruption" ) )
		anim_ent thread anim_single_solo( self, "hunted_open_barndoor" );
	else
		anim_ent thread anim_single_solo( self, "hunted_open_barndoor_nodialogue" );

	// todo: get notetrack.
	wait 1.75;

	door = getent( "barn_rear_door","targetname");
	old_angles = door.angles;
	door rotateto( door.angles + (0,70,0), 2, .5, 0 );
	door connectpaths();
	door waittill( "rotatedone");
	door rotateto( door.angles + (0,40,0), 2, 0, 2 );

	flag_set( "barn_rear_open" );

	// close the rear barn door so that the player can't backtrack.
	level thread barn_close_rear_door( door, old_angles );
}

barn_close_rear_door( door, old_angles )
{
	flag_wait( "field_cross" );
	door rotateto( old_angles, 1 );
}

barn_mark_moveup()
{
	node = getnode( "mark_barn_rear", "targetname" );
	level.mark set_goalnode( node );

	flag_wait( "barn_rear_open" );

	node = getnode( "mark_barn_interior", "targetname" );
	self set_goalnode( node );

	if ( !flag( "player_interruption" ) )
	{
		flag_wait( "interrogation_done" );
		wait 5;
	}

	level.mark barn_front_door();
	level.mark set_goalnode( getnode( "mark_barn_exterior", "targetname" ) );

	flag_set("barn_front_open");
}

barn_front_door()
{
	self make_ai_move();

	self enable_cqbwalk();

	doors = getentarray( "barn_main_door","targetname");

	anim_ent = getent( "front_door_animent", "targetname" );

	anim_ent anim_reach_solo( self, "door_kick_in" );
	anim_ent thread anim_single_solo( self, "door_kick_in" );
	self waittillmatch( "single anim", "kick" );

	doors[0] playsound( "hunted_barn_door_kick" );

	for ( i=0; i<doors.size; i++ )
	{
		doors[i] connectpaths();

		if ( doors[i].script_noteworthy == "right" )
			doors[i] rotateto( doors[i].angles + (0,-160,0), .6, 0 , .1 );
		else
			doors[i] rotateto( doors[i].angles + (0,175,0), .75, 0 , .1 );
	}

	self make_ai_normal();
	self disable_cqbwalk();

}

/**** field area ****/

area_field_init()
{
	autosave_by_name( "field" );

	getent( "barn_traverse", "targetname" ) disconnectpaths();

	wait 2;
	level thread field_dialgue();
	level.mark thread field_kick_open();

	array_thread( level.squad, ::field_allies );
	level thread field_helicopter();
	level thread field_truck();
	level thread field_basement();

	flag_wait( "field_defend" );

	autosave_by_name( "field_defend" );

	activate_trigger_with_targetname( "field_defend_color_init" );

	flag_wait( "basement_open" );

	level thread area_basement_init();
}

field_dialgue()
{
	level.charlie thread queue_anim( "areaclear" );
	level.price thread anim_single_solo_delayed( 1, level.price, "keepmoving" );

	struct = getstruct( "field_go_prone", "script_noteworthy" );
	struct waittill( "trigger" );
	
	flag_set( "hit_the_deck_music" );

	level.price queue_anim( "hitdeck" );

	flag_wait( "field_defend" );
	level.price queue_anim( "ontous" );
	wait 4.5;
	level.mark queue_anim( "contact6oclock" );
	level.price queue_anim( "returnfire2" );

	flag_wait( "field_open_basement" );
	level.price queue_anim( "basementdooropen2" );
	level.mark queue_anim( "imonit" );

	flag_wait( "basement_open" );

	level.price queue_anim( "getinhouse" );

	if ( !flag( "squad_in_basement" ) )
		level thread field_basement_nag();
}

field_basement_nag()
{
	while( true )
	{
		wait 4;
		if ( flag( "squad_in_basement") )
			return;

		level.price queue_anim( "whatwaitingfor" );

		wait 4;
		if ( flag( "squad_in_basement") )
			return;
	
		level.price queue_anim( "getinbasement" );

		wait 6;
		if ( flag( "squad_in_basement") )
			return;
	
		level.price queue_anim( "getinhouse" );

		wait 4;
	}
}

field_kick_open()
{
	field_blocker = getent( "field_blocker", "targetname" );
	clip = getent( "field_clip", "targetname" );
	clip connectpaths();

	anim_ent = getent( "kick_animent", "targetname" );

	// todo: change to other kick animation.
	anim_ent anim_reach_solo( self, "door_kick_in" );
	flag_set( "field_open" );
	anim_ent thread anim_single_solo( self, "door_kick_in" );

	self waittillmatch( "single anim", "kick" );

	contact_point = self gettagorigin( "j_ball_le" ) + (0,0,-16);
	contact_point = ( 906, -3328, 148.7 ); 	// todo: check if this is needed any more.

	force = anglestoforward( self.angles );
	force += (0,0,0.4);
	force = vectorScale( force, 6000 );

	field_blocker physicslaunch( contact_point, force );

	clip delete();
}

field_allies()
{
	ai_name = self.animname;
	
	flag_wait( "field_open" );
	wait randomfloatrange( 0.25, 1 );

	node = getnode( ai_name + "_field_path", "targetname" );
	self set_goalnode( node );

	flag_wait( "field_cross" );
	wait randomfloat(.25);
	self thread follow_path( node );

	flag_wait( "field_cover" );
	self notify("stop_path");
	wait randomfloat(.25);

	old_animplaybackrate = self.animplaybackrate;
	self.animplaybackrate = 1.15;

	node = getnode( ai_name + "_field_cover", "targetname" );
	self field_prone_goal( node );

	anim_ent = self get_prone_ent( node );

	anim_ent anim_reach_solo( self, "hunted_dive_2_pronehide" );
	anim_ent anim_single_solo( self, "hunted_dive_2_pronehide" );
	anim_ent thread anim_loop_solo( self, "hunted_pronehide_idle", undefined, "stop_all_idle" );

	self set_force_color( "r" );

	flag_wait( "field_defend" );

	self.animplaybackrate = old_animplaybackrate;

	node notify( "stop_all_idle" );
	anim_ent thread anim_single_solo( self, "hunted_pronehide_2_stand" );
}

get_prone_ent( node )
{
	ent_array = getentarray( "prone_ent", "targetname" );

	current_vector = vectornormalize( node.origin - self.origin );
	current_angle = vectortoangles( current_vector )[1];

	ent_array = get_array_of_closest( self.origin, ent_array );

	for ( i=0; i<ent_array.size; i++)
	{
		vector = ent_array[i].origin - self.origin;
		angle = vectortoangles( vector  )[1];

		dif_angle = abs( current_angle - angle );
		if ( dif_angle < 22.5 && !isdefined( ent_array[i].inuse ) )
		{
			ent_array[i].inuse = true;
			return ent_array[i];
		}
	}

	assertmsg( "No good prone position could be found." );
	return node;
}

field_prone_goal( node )
{
	self set_goalnode( node );
	self endon( "goal");

	struct = getstruct( "field_go_prone", "script_noteworthy" );
	struct waittill( "trigger" );
}

field_helicopter()
{
	flag_wait( "field_cover");

	helicopter = maps\_vehicle::spawn_vehicle_from_targetname( "field_heli" );
	helicopter sethoverparams(128, 10, 3);

	level.helicopter = helicopter;

	assert( isdefined( helicopter.riders ) );
	array_thread( helicopter.riders, ::field_axis );

	helicopter thread heli_path_speed();
	helicopter helicopter_searchlight_on();

	helicopter field_flyby_speed();

	struct = getstruct( "field_go_prone", "script_noteworthy" );
	struct waittill( "trigger" );

	helicopter waittill( "unload" );
	flag_set( "field_defend" );
}

helicopter_setturrettargetent( target_ent )
{
	if ( !isdefined( target_ent ) )
		target_ent = self.spotlight_default_target;

	self.current_turret_target = target_ent;
	self setturrettargetent( target_ent );
}

helicopter_getturrettargetent()
{
	return self.current_turret_target;
}

setup_spot_target()
{
	structs = getstructarray( "spot_target", "script_noteworthy" );
	array_thread( structs, ::spot_target_node );
}

spot_target_node()
{
	while( true )
	{
		self waittill( "trigger", vehicle );		
		links = self get_links();
		assert( isdefined( links ) );
		script_origin = getent( links[0], "script_linkname" );
		vehicle thread spot_target_path( script_origin );
	}
}

spot_target_path( script_origin )
{
	/*
	takes the first script_origin in a path
	speed is units per second.
	script_delay works
	*/

	assert( isdefined( script_origin ) );

	// a new spot path terminates the old.
	self notify( "spot_target_path" );
	self endon( "spot_target_path" );

	if ( !isdefined( self.spot_target_ent ) )
		self.spot_target_ent = spawn( "script_model", script_origin.origin );

	target_ent = self.spot_target_ent;
//	target_ent setmodel( "fx" );

	old_origin = script_origin.origin;

	self helicopter_setturrettargetent( target_ent );
	while ( true )
	{
		if ( !isdefined( script_origin.target ) )
			break;

		speed = 350;
		if ( isdefined( script_origin.speed ) ) 
			speed = script_origin.speed;

		current_origin = script_origin.origin;
		script_origin = getent( script_origin.target, "targetname" );

		movespeed = ( distance( script_origin.origin, current_origin ) / speed );

		if ( isdefined( script_origin.radius ) )
			target_ent.spot_radius = script_origin.radius;
		else
			target_ent.spot_radius = undefined;

		target_ent moveto( script_origin.origin, movespeed );
		target_ent waittill( "movedone" );
		script_origin script_delay();

		if ( isdefined( script_origin.script_flag ) )
			flag_wait( script_origin.script_flag );
	}

	self helicopter_setturrettargetent( self.spotlight_default_target );
	self.spot_target_ent delete();
}

setup_tmp_detour_node()
{
	delete_nodes = getstructarray( "tmp_detour_node", "script_noteworthy" );
	array_thread( delete_nodes, ::tmp_detour_node );
}

tmp_detour_node()
{
	while ( true )
	{
		self waittill( "trigger", vehicle );
		path_struct = getstruct( "tmp_detour_node2", "script_noteworthy" );
		vehicle thread heli_path_speed( path_struct );
	}
}

setup_helicopter_delete_node()
{
	delete_nodes = getstructarray( "delete_helicopter", "script_noteworthy" );
	array_thread( delete_nodes, ::helicopter_delete_node );
}

helicopter_delete_node()
{
	while ( true )
	{
		self waittill( "trigger", vehicle );
		maps\_vehicle::delete_group( vehicle );
	}
}

field_flyby_speed()
{
	pos1 = level.player.origin;
	wait 2;
	pos2 = level.player.origin;
	dist = distance( pos1, pos2 );

	if ( dist < 250 )
		alloted_time = 9;
	else
		alloted_time = 7;

	dist = distance( self.origin, level.player.origin );
	MPH = dist / alloted_time / 17.6;

	accel = MPH/2;
	if ( accel < 30 )
		accel = 30;

	self setspeed( MPH, accel );
}

field_truck()
{
	flag_wait( "field_basement" );

	wait 10;

	truck = maps\_vehicle::spawn_vehicle_from_targetname( "field_truck" );
	thread maps\_vehicle::gopath ( truck );

	assert( isdefined( truck.riders ) );
	array_thread( truck.riders, ::field_axis );

//	truck truck_headlights_on();
	truck maps\_vehicle::lights_on( "headlights" );

	truck waittill( "unload" );
}

field_axis()
{
	self endon( "death" );
	self setthreatbiasgroup( "oblivious" );

	self waittill( "jumpedout" );
	self setthreatbiasgroup( "axis" );

	self waittill( "goal" );
	flag_wait( "field_basement" );

	wait randomfloatrange( 4, 9 ) * 3; // 12 to 28 seconds wait.
	self set_goalnode( getnode( "field_attack_node", "targetname" ) );

}

field_basement()
{
	flag_wait( "field_basement" );
	wait 14; // let the player defend for a while.
	flag_set( "field_open_basement" );
	wait 2;

	self set_ignoreSuppression( true );
	level.mark pushplayer( true );
	level.mark setthreatbiasgroup( "oblivious" );

	anim_ent = getentarray( "basement_animent", "targetname" )[0];

	anim_ent anim_reach_solo( level.mark, "hunted_open_basement_door_kick" );
	anim_ent thread anim_single_solo( level.mark, "hunted_open_basement_door_kick" );
	
	// todo: change to use door model with lock etc and animations for the same.
	// todo: once the door model is in I need to attack a clip etc.

	getent( "basement_player_block", "targetname" ) notsolid();

	flag_set( "basement_door_open" );

	level.mark set_ignoreSuppression( false );
	level.mark pushplayer( false );
	level.mark setthreatbiasgroup( "allies" );
	level.mark enable_ai_color();
}

#using_animtree("door");
setup_basement_door()
{
	getent( "field_basement_door_open_clip", "targetname" ) notsolid();
	door = getent( "basement_door", "targetname" );
	door thread field_basement_door();
}

field_basement_door()
{
	anim_ent = getentarray( "basement_animent", "targetname" )[0];
	start_origin = getstartorigin( anim_ent.origin, anim_ent.angles, %hunted_open_basement_door_kick_door );
	start_angles = getstartangles( anim_ent.origin, anim_ent.angles, %hunted_open_basement_door_kick_door );

	self.angles = start_angles;
	self.origin = start_origin;

	self useanimtree( #animtree );

	self.animname = "door";
	level.scr_anim[ "door" ][ "door_kick_door" ] =		%hunted_open_basement_door_kick_door;

	anim_ent anim_first_frame_solo( self, "door_kick_door" );
		
	flag_wait( "basement_door_open" );

	clip = getent( self.target, "targetname" );
	clip connectpaths();

	self SetFlaggedAnim( "door_anim", %hunted_open_basement_door_kick_door );
//	self waittillmatch( "door_anim", "end" );
	time = getanimlength( %hunted_open_basement_door_kick_door );
	wait time-0.5;
	clip delete();

	level.mark queue_anim( "doorsopen" );

	flag_set( "basement_open" );

	volume = getent( "basement_door_volume", "targetname" );
	while ( level.player istouching( volume ) )
		wait 0.1;

	getent( "field_basement_door_open_clip", "targetname" ) solid();
}

/**** basement area ****/
#using_animtree("generic_human");
area_basement_init()
{
	level.price thread basement_price();
	level thread basement_allies();
	level thread basement_helicopter();
	level thread basement_trim_field();
	level thread basement_flash();

	flag_wait( "basement_secure" );
	autosave_by_name( "basement" );

	flag_wait( "farm_start" );

	level thread area_farm_init();

	// todo: add the helicopter shining in trough the windows, some where in this section of script.
}

basement_allies()
{
	volume = getent( "basement_building", "targetname" );
	volume2 = getent( "stair_volume", "targetname" );


	array_thread( level.squad, ::make_ai_move );

	activate_trigger_with_targetname( "basement_color_init" );

	tmp_array = array_remove( level.squad, level.price );
	tmp_array = array_add( tmp_array, level.player );

	loop_count = 0;

	for ( touching = false; !touching; )
	{
		loop_count++;
		if ( loop_count > ( 20 / 0.05 ) && !level.player istouching(volume) && !level.player istouching(volume2) ) // 20 seconds until death 
			level.player magic_kill( level.helicopter );

		touching = true;
		for ( i=0; i<tmp_array.size; i++)
		{
			if( !tmp_array[i] istouching( volume ) )
				touching = false;
		}
		wait 0.05;
	}

	flag_set( "squad_in_basement" );

	flag_wait( "basement_secure" );

	array_thread( level.squad, ::make_ai_normal );
	array_thread( level.squad, ::make_walk );

	flag_wait( "farm_start" );
	level notify( "stop_walk");

}

basement_price()
{
	self disable_ai_color();

	old_awareness = self.grenadeawareness;
	self.grenadeawareness = 0;
	self set_goalnode( getnode( "basement_enter_price", "targetname" ) );

	flag_wait( "squad_in_basement" );

	player_block = getent( "basement_player_block", "targetname" );
	player_block solid();

	anim_ent = getentarray( "basement_animent", "targetname" )[0];
	anim_ent anim_reach_solo( self, "hunted_basement_door_block" );
	anim_ent thread anim_single_solo( self, "hunted_basement_door_block" );

	wait 1;

	door = getent( "basement_inner_door", "targetname" );
	door notsolid();
	door rotateyaw( -180, 1.5, .25, 0 );
	door waittill( "rotatedone" );
	door solid();
	door disconnectpaths();

	self set_force_color( "y" );

	flag_set( "basement_secure" );

	player_block delete();

	wait 1;
	self thread queue_anim( "takepoint" );

	self.grenadeawareness = old_awareness;

	flag_wait( "farm_start" );
}

basement_helicopter()
{
	// todo: make sure all this works.

	helicopter = level.helicopter;

	flag_wait( "squad_in_basement" );

	path_struct = getstruct( "heli_basement_path", "targetname" );

	helicopter thread heli_path_speed( path_struct );
	helicopter deactivate_heli_guy();

	helicopter setSpeed( 90, 90 );

	getent( "basement_shine", "targetname" ) waittill( "trigger" );
	flag_set( "basement_shine" );

	helicopter sethoverparams( 0, 0, 0 );

	flag_wait( "basement_heli_takeoff" );

	path_struct = getstruct( "heli_flash_path", "targetname" );

	helicopter thread heli_path_speed( path_struct );

}

basement_trim_field()
{
	flag_wait ( "trim_field" );

	axis = getaiarray( "axis" );
	axis = array_exclude( axis, get_ai_group_ai( "basement_field_guy" ) );

	for ( i=0; i<axis.size; i++ )
	{
		axis[i] delete();
	}

	while( !flag( "basement_flash" ) && get_ai_group_count( "basement_field_guy" ) > 3 )
		wait 0.05;

	axis = get_ai_group_ai( "basement_field_guy" );
	node = getnode( "field_retreat_node", "targetname" );
	array_thread( axis, ::set_goalnode, node );
	array_thread( axis, ::delete_on_goal );

}

basement_flash()
{
	trigger = getent( "basement_flash", "targetname" );
	trigger waittill( "trigger" );

	flag_set( "basement_flash" );

	scripted_array_spawn( "basement_flash_guy", "targetname", true );

	wait 2;

	axis = getaiarray( "axis" );
	array_thread( axis, ::flash_immunity, 2 );

	if ( isdefined( axis[0] ) )
	{
		flash_guy = axis[0];
		oldGrenadeWeapon = flash_guy.grenadeWeapon;
		flash_guy.grenadeWeapon = "flash_grenade";
		flash_guy.grenadeAmmo++;

		ent = getent( "enemy_flash_bang", "targetname" );
		ent2 = getent( ent.target, "targetname" );

		flash_guy magicgrenade( ent.origin, ent2.origin, 1 );
		flash_guy.grenadeWeapon = oldGrenadeWeapon;
	}

	level.mark thread queue_anim( "flashbang" );

	while( !flag( "farm_start" ) && get_ai_group_count( "basement_flash_guy" ) )
		wait 0.05;

	flag_set( "farm_start" );

	axis = get_ai_group_ai( "basement_flash_guy" );
	for ( i=0; i<axis.size; i++ )
	{
		axis[i] setgoalentity( level.player );
	}
}

/**** farm area ****/
area_farm_init()
{
	// todo: Make steve and charlie killable by dogs. But only one of them may die.

	array_thread( getentarray( "farm_dog", "script_noteworthy" ), ::add_spawn_function, ::farm_dog_spawn_function );
	array_thread( getentarray( "farm_forerunners", "script_noteworthy" ), ::add_spawn_function, ::farm_forerunners );
	array_thread( getentarray( "farm_defenders", "script_noteworthy" ), ::add_spawn_function, ::farm_defenders );

	level thread farm_dialogue();
	level.player thread rush_on_flash();

	level.player.maxflashedseconds = 3;

	level.price set_force_color( "y" );
	level.mark set_force_color( "y" );
	level.steve set_force_color( "r" );
	level.charlie set_force_color( "r" );

	wait 1;
//	todo: make sure battlechatter is turned on and off when it should
//	battlechatter_off( "allies" );
//	battlechatter_off( "axis" );

	activate_trigger_with_targetname( "farm_color_init" );

	setthreatbias( "dogs", "allies", -10000 );

	flag_wait( "farm_alert" );

//	todo: make sure battlechatter is turned on and off when it should
//	battlechatter_on( "allies" );
//	battlechatter_on( "axis" );

	level thread farm_clear_enemies();

	waittill_aigroupcleared( "farm_forerunners" );
	waittill_aigroupcleared( "farm_defenders" );

	flag_set( "farm_clear");
	
	farm_color_trigger = getentarray( "farm_color_trigger", "script_noteworthy" );
	array_thread( farm_color_trigger, ::trigger_off );

	activate_trigger_with_targetname( "farm_cleared_color_init" );

	level thread area_creek_init();	
}

farm_dialogue()
{
	trigger = getent( "quiet_dialogue" , "targetname" );
	trigger waittill( "trigger" );

	level.charlie queue_anim( "helicoptersgone" );
	level.mark queue_anim( "regrouping" );
	wait 2;
	level.price queue_anim( "staysharp" );

	autosave_by_name( "farm" );
}

farm_forerunners()
{
	self endon( "death" );

	if ( randomint(100) > 25 )
		self.grenadeWeapon = "flash_grenade";

	while ( 4 < get_ai_group_count( "farm_forerunners" ) )
		wait 0.1;

	self set_goalvolume( "farm_volume" );
}

farm_defenders()
{
	self endon( "death" );

	if ( randomint(100) > 25 )
		self.grenadeWeapon = "flash_grenade";

	while ( 4 < get_ai_group_count( "farm_defenders" ) )
		wait 0.1;

	self set_goalvolume( "farm_volume" );
}

farm_dog_spawn_function()
{
	self setgoalentity( level.player );
	self.goalradius = 300;
}

farm_clear_enemies()
{
	trigger = getent( "farm_clear_enemies", "targetname" );
	trigger waittill( "trigger" );
	
	axis1 = get_ai_group_ai( "farm_forerunners" );
	axis2 = get_ai_group_ai( "farm_defenders" );
	axis = array_combine( axis1, axis2 );
	volume = getent( "farm_volume", "targetname" );

	for ( i=0; i<axis.size; i++ )
	{
		if ( axis[i] istouching( volume ) )
				continue;
		axis[i] setgoalentity( level.player );
		axis[i].goalradius = 450;
	}
}

area_creek_init()
{
	autosave_by_name( "creek" );

	flag_clear( "player_interruption" );

	spawner_array = getentarray( "creek_bridge_guy", "script_noteworthy" );
	array_thread( spawner_array, ::add_spawn_function, ::creek_bridge_guy );

	array_thread( getnodearray( "patroll_animation", "script_noteworthy"), ::creek_guard_node );

	flag_wait( "creek_helicopter");

	level thread set_player_speed( 150, 6 );

	level thread creek_dialogue();
	level thread creek_truck();
	level thread creek_helicopter();
	level thread creek_gate();

	level thread creek_cqb_setup();

	flag_wait( "creek_truck_on_bridge" );

	level thread set_flag_on_player_action( "player_interruption", 1, true, true);

	flag_wait_either( "road_start", "player_interruption" );

	level thread area_road_init();
}

creek_gate()
{
	wait 6;

	// todo: check that the player is close.

	gate = getent( "creek_gate", "targetname" );
	anim_ent = getent( "creek_gate_animent", "targetname" );

	level.price disable_ai_color();
	activate_trigger_with_targetname( "creek_gate_color_init" );

	anim_ent anim_reach_solo( level.price, "hunted_open_creek_gate" );
	anim_ent anim_single_solo( level.price, "hunted_open_creek_gate_stop" );
	anim_ent thread anim_single_solo( level.price, "hunted_open_creek_gate" );
	level.price enable_cqbwalk();

	flag_set( "creek_gate_open" );

	wait 1.75;

	old_angles = gate.angles;
	gate rotateto( gate.angles + (0,70,0), 2, .5, 0 );
	gate connectpaths();
	gate waittill( "rotatedone");
	gate rotateto( gate.angles + (0,40,0), 2, 0 , 2 );

	level.price set_force_color( "y" );
	level.price waittill( "done_setting_new_color" );

	activate_trigger_with_targetname( "creek_color_init" );

	flag_wait( "creek_bridge" );

	// close gate to stop the player from falling back.
	gate rotateto( old_angles, .1 );
	gate waittill( "rotatedone");
}

creek_dialogue()
{
	wait 6;
	level.mark queue_anim( "helicoptersback" );
	wait 3;
	level.price queue_anim( "keepitthatway" );

	flag_wait( "creek_gate_open" );
	wait 0.5;
	level.price queue_anim( "presson" );

	level endon( "player_interruption" );

	heli_node = getstruct( "creek_heli_warning", "script_noteworthy" );
	heli_node waittill( "trigger" );

	level.price thread queue_anim( "sentriesatbridge" );
}

creek_truck()
{
	flag_wait( "creek_start" );
	
	truck = maps\_vehicle::spawn_vehicle_from_targetname( "creek_truck" );
	thread maps\_vehicle::gopath ( truck );
	truck maps\_vehicle::lights_on( "headlights" );

	truck waittill( "unload" );
	flag_set( "creek_truck_on_bridge" );
/*
	truck setspeed( 0, 35 );
	wait 2;
	truck resumespeed( 35 );
*/
}

creek_helicopter()
{
	wait 3;

	helicopter = maps\_vehicle::spawn_vehicle_from_targetname( "creek_heli" );
	helicopter sethoverparams(128, 35, 25);

	for ( i=0; i<helicopter.riders.size; i++ )
	{
		helicopter.riders[i] setthreatbiasgroup ( "oblivious" );
	}

	level.helicopter = helicopter;

	helicopter thread heli_path_speed();
	helicopter helicopter_searchlight_on();

	flag_wait( "creek_bridge" );

	path_struct = getstruct( "creek_flyover_struct", "targetname" );
	
	helicopter thread heli_path_speed( path_struct );
}

creek_bridge_guy()
{
	// todo: idle animations with flashlights.
	self endon( "death" );
	self notify( "stop_going_to_node" );

	self setthreatbiasgroup( "oblivious" );
	self thread magic_bullet_shield();

	self.animname = "axis";

	self.disableArrivals = true;
	self set_run_anim( "patrolwalk_" + ( randomint(5) + 1 ) );
	self.alwaysRunForward = true;

	self waittill( "jumpedout" );

	path_node = getnode( self.target, "targetname" );
	self thread follow_path( path_node, true );

	wait 2;

	self attach_flashlight( true );

	self thread road_axis_interrupt();
}

creek_guard_node()
{
	level endon( "player_interruption" );

	while ( true )
	{
		self waittill( "trigger", ai);

		self thread interrupt_guard_node( ai );
		self anim_single_solo( ai, self.script_animation );

		self notify( "guard_anim_done" );
	}
}

interrupt_guard_node( ai )
{
	ai endon( "death" );
	self endon( "guard_anim_done" );

	level waittill( "player_interruption" );

	ai stopanimscripted();
	ai notify( "single anim", "end" );
}

creek_cqb_setup()
{
	array_thread( getentarray( "creek_cqb_start", "targetname" ), ::creek_cqb_start );
	array_thread( getentarray( "creek_cqb_end", "targetname" ), ::creek_cqb_start );
}

creek_cqb_start()
{
	while( true )
	{
		self waittill( "trigger", guy );
		guy thread ignore_triggers( 1 );
		guy enable_cqbwalk();
	}	
}

creek_cqb_end()
{
	while( true )
	{
		self waittill( "trigger", guy );
		guy thread ignore_triggers( 1 );
		guy disable_cqbwalk();
	}	
}

area_road_init()
{
	level thread road_allies();
	level thread road_axis();
	level thread road_helicopter();
	level thread road_reset_speed();

	if ( !flag( "player_interruption" ) )
	{
		autosave_by_name( "road" );
		level thread road_field();
		level thread road_roadblock();
	}
	else
	{
		flag_wait( "road_start" );
		flag_set( "road_open_field" );
	}

	flag_wait( "greenhouse_area" ) ;

	if ( !flag( "player_interruption" ) )
		wait randomfloat(2);

	waittill_aigroupcleared( "road_group" );

	level thread area_greenhouse_init();
}

road_reset_speed()
{
	flag_wait( "player_interruption" );
	level thread set_player_speed( 190, 6 );
}

road_helicopter()
{
	// todo this needs to be the correct notify to die on.
	level endon( "greenhouse" );

	flag_wait( "player_interruption" );

	wait 2;

	level.helicopter notify("stop_path");

	setthreatbias( "player", "heli_guy", 10000 );
	setthreatbias( "heli_guy", "player", 20000 );

	level.heli_guy_accuracy = 2;
	level.heli_guy_health_multiplier = 1;
	level.heli_guy_respawn_delay = 10;

	level.helicopter thread activate_heli_guy();

	// get in position for the fight faster
	level.helicopter heli_path_speed( getstruct( "road_heli_start", "targetname" ) );

	level.helicopter thread helicopter_attack( 15, "attack_helicopter" );

	wait 4;

	level.price queue_anim( "watchhelicopter" );

}

road_field()
{
	// todo: wait for ai to reach a good spot before setting the flag.
	flag_wait_or_timeout( "player_interruption", 8 );
	flag_set( "road_open_field" );
}

road_allies()
{
	flag_wait( "road_open_field" );

	for( i = 0 ; i < level.squad.size ; i ++ )
	{
		level.squad[i] pushplayer( true );
	}

	road_bridge_wait();

	flag_set( "roadblock" );

	wait 2;

	// todo: get sub vocalized dialogue "Alright, lets move, now!"
	if ( !flag( "player_interruption" ) )
	{
		level.price queue_anim( "staylow" );
		level thread road_allies_exposed();
	}
	else
		level.price queue_anim( "moveit" );

	activate_trigger_with_targetname( "road_color_stage_1" );

	wait 1;	// todo: get rid of these when activate... runs color 
	level.price waittill( "goal" );
	wait 6;

	activate_trigger_with_targetname( "road_color_stage_2" );

	wait 1;	// todo: get rid of these when activate... runs color 
	level.price waittill( "goal" );
	wait 6;

	activate_trigger_with_targetname( "road_color_stage_3" );

	wait 1;	// todo: get rid of these when activate... runs color 
	level.steve waittill( "goal" );
	flag_wait( "road_field_search" ) ;
	wait 4;

	activate_trigger_with_targetname( "road_color_stage_4" );

	wait 1;	// todo: get rid of these when activate... runs color 
	level.price waittill( "goal" );
	wait 2;

	activate_trigger_with_targetname( "road_color_stage_5" );

	flag_set( "road_field_end" );

	level.price waittill( "goal" );

	flag_wait( "player_interruption" ) ;
	while ( get_ai_group_count( "road_group" ) > 4 )
		wait 0.05;

	activate_trigger_with_targetname( "road_color_stage_6" );

	for( i = 0 ; i < level.squad.size ; i ++ )
	{
		level.squad[i] pushplayer( false );
	}

}

road_allies_exposed()
{
	flag_wait( "player_interruption" );

	wait 2;

	if ( !flag( "road_field_end" ) )
		level.price queue_anim( "endoffield" );
	else	
		level.price queue_anim( "returnfire2" );
}

road_bridge_wait()
{
	level endon( "player_interruption" );
	level endon( "roadblock" );

	if ( flag( "player_interruption" ) )
		return;

	bridge_volume = getent( "bridge_volume", "targetname" );

	// todo: check if the next node is a animation node or if they are playing an animation.

		level.price thread queue_anim( "outofspotlight" );

	// todo: check if the next node is a animation node or if they are playing an animation.

	wait 1;

}

road_axis()
{
	flag_wait( "roadblock" );

	if ( !flag( "player_interruption" ) )
	{
		array_thread( getentarray( "road_idle_guy", "targetname" ), ::add_spawn_function, ::road_idle_guy );
		array_thread( getentarray( "road_guy", "targetname" ), ::add_spawn_function, ::road_guy );
		road_guys = scripted_array_spawn( "road_idle_guy", "targetname", true );
		road_guys = scripted_array_spawn( "road_guy", "targetname", true );
	}
	else
	{
		array_thread( getentarray( "road_idle_guy", "targetname" ), ::add_spawn_function, ::road_guy_attack );
		array_thread( getentarray( "road_guy", "targetname" ), ::add_spawn_function, ::road_guy_attack );
		road_guys = scripted_array_spawn( "road_guy", "targetname", true );
		wait 10;
		road_guys = scripted_array_spawn( "road_idle_guy", "targetname", true );
	}
}

road_guy_attack()
{
	self notify( "stop_going_to_node" );
	self set_force_color( "p" );
}

road_guy()
{
	self endon( "death" );
	level endon( "player_interruption" );

	self thread magic_bullet_shield();
	self setthreatbiasgroup( "oblivious" );
	self.disableArrivals = true;
	self.alwaysRunForward = true;

	self.animname = "axis";
	self set_run_anim( "patrolwalk_" + ( randomint(5) + 1 ) );

	self attach_flashlight( true );

	self thread road_axis_interrupt();

	self notify( "stop_going_to_node" );
	path_node = getnode( self.target, "targetname" );
	self thread follow_path( path_node, true );

	self waittill( "path_end_reached" );

	flag_set( "player_interruption" );
}

road_idle_guy()
{
	// don't do much.
	self thread magic_bullet_shield();
	self setthreatbiasgroup( "oblivious" );
	self.disableArrivals = true;

	self.animname = "axis";
	self set_run_anim( "patrolwalk_nolight" );
	self thread road_axis_interrupt();
	self.alwaysRunForward = true;

}

road_roadblock()
{
	level endon( "player_interruption" );

	flag_wait( "roadblock" );

	actors = scripted_array_spawn( "roadblock_guy", "script_noteworthy", true );
	level thread road_roadblock_anim( actors );

//	todo: make this work
//	sedan maps\_vehicle::lights_on( "headlights" );

	start_vnode = getvehiclenode( "roadblock_start", "script_noteworthy" );
	stop_vnode = getvehiclenode( "roadblock_stop", "script_noteworthy" );

	sedan = maps\_vehicle::spawn_vehicle_from_targetname( "road_pickup" );
	thread maps\_vehicle::gopath ( sedan );

	start_vnode waittill( "trigger" );

	flag_set( "roadblock_start" );

	stop_vnode waittill( "trigger" );

	sedan setspeed( 0, 15 );
	
	flag_wait( "roadblock_done" );

	sedan resumespeed( 35 );
}

road_roadblock_anim( actors )
{
	level endon( "player_interruption" );

	nodes = getnodearray( "roadblock_path", "targetname" );
	actors[0] thread road_roadblock_guy( "guard1", nodes[1] );
	actors[1] thread road_roadblock_guy( "guard2", nodes[0] );

	anim_ent = getent( "roadblock_animent", "targetname" );

	level thread road_roadblock_interrupt( actors, anim_ent );

	anim_ent anim_reach( actors, "roadblock_sequence" );

	if ( !flag( "roadblock_start" ) && !flag( "player_interruption" ) )
		anim_ent anim_loop( actors, "roadblock_startidle", undefined, "stop_idle" );

	flag_wait( "roadblock_start" );

	anim_ent notify( "stop_idle" );

	anim_ent anim_single( actors, "roadblock_sequence" );

	flag_set( "roadblock_done" );
}

road_roadblock_interrupt( actors, anim_ent )
{
	flag_wait( "player_interruption" );

	anim_ent notify( "stop_idle" );

	if ( !flag( "roadblock_start" ) )
		return;

	actors[0] stopanimscripted();
	actors[0] notify( "single anim", "end" );
	actors[1] stopanimscripted();
	actors[1] notify( "single anim", "end" );

	flag_set( "roadblock_done" );
}

road_roadblock_guy( animname, path_node )
{
	self endon( "death" );
	level endon( "player_interruption" );

	self.animname = animname;
	self.disableArrivals = true;
	self set_run_anim( "patrolwalk" );
	self setthreatbiasgroup( "oblivious" );
	self thread magic_bullet_shield();
	
	self attach_flashlight( true );

	self thread road_axis_interrupt();

	flag_wait( "roadblock_done" );
	self.disableArrivals = true;
	self.animname = "axis";
	self thread follow_path( path_node, true );
}

road_axis_interrupt()
{
	self endon( "death" );

	self thread road_axis_proximity();

	flag_wait( "player_interruption" );

	if ( !self.spotter )
		wait randomfloat( 2 ) + 0.5;

	self notify( "stop_path" );
	self flashlight_light( false );
	self.disableArrivals = false;
	self clear_run_anim();
	self.alwaysRunForward = undefined;

	self setthreatbiasgroup( "axis" );
	self stop_magic_bullet_shield();
	self set_force_color( "p" );

	self detach_flashlight();
}

road_axis_proximity()
{
	level endon( "player_interruption" );
	self endon( "death" );

	self.spotter = false;

	wait randomfloat(1);

	while ( true )
	{
		fov = cos( 65 );
		wait 1;
		dist = distance2d( level.player.origin, self.origin );

		if ( dist > 1000 )
			continue;

		if ( dist < 400 && level.player getstance() != "prone" )
			fov = cos( 120 );

		if ( !within_fov( self.origin, self.angles, level.player.origin, fov ) )
			continue;

		min_visible = dist / 1000;

/*
		if ( self.export == 150 || self.export == 153 )
		{
			iprintln( self.export + ": " + level.player scripted_sightconetrace( self geteye(), self ) + " > " + min_visible );
		}
*/

		if ( min_visible > level.player scripted_sightconetrace( self geteye() , self ) )
			continue;

		self.spotter = true;

		flag_set( "player_interruption" );
	}
}

area_greenhouse_init()
{
	autosave_by_name( "greenhouse" );

	level.helicopter deactivate_heli_guy();
	activate_trigger_with_targetname( "greenhouse_color_init" );

	level thread greenhouse_stinger();
	level thread greenhouse_fake_target();
	level thread greenhouse_barn_door();

	flag_wait( "greenhouse_done" );

	level thread area_ac130_init();
}

greenhouse_stinger()
{
	while( get_ai_group_count( "greenhouse_group" ) > 8 )
		wait 0.05;

	autosave_by_name( "greenhouse" );

	level.heli_guy_accuracy = 5;
	level.heli_guy_health_multiplier = 2;
	level.heli_guy_respawn_delay = 10;

	level.helicopter thread activate_heli_guy();

	level.price thread queue_anim( "anotherpass" );

	waittill_aigroupcleared( "greenhouse_group" );

	activate_trigger_with_targetname( "stinger_color_init" );

	if ( !isdefined( level.helicopter ) )
	{
		// if the heli is killed out outside of the mission.
		flag_set( "helicopter_down" );
		return;
	}

	level.helicopter stop_helicopter_attack();

	wait 1;

	level.heli_guy_accuracy = 10;
	level.heli_guy_health_multiplier = 2;
	level.heli_guy_respawn_delay = 10;

	if ( isalive(level.helicopter.heli_guy) )
		level.helicopter.heli_guy.baseAccuracy = level.heli_guy_accuracy;

	level.helicopter thread heli_path_speed( getstruct( "stinger_path", "targetname" ) );

	level.mark waittill( "goal" );

	autosave_by_name( "stinger" );
	
	level.mark queue_anim( "missilesinbarn" );
	level.price thread queue_anim( "takeoutchopper" );

	delayThread( 3, ::activate_trigger_with_targetname, "heli_fight_color_init" );

	level thread objective_stinger();

	if ( !isalive( level.helicopter ) )
	{
		flag_set( "helicopter_down" );
		return;
	}

	level.helicopter waittill( "death" );
	level.helicopter deactivate_heli_guy();

	wait 9;

	level.mark queue_anim( "niceshooting" );
	wait 1;
	level.price thread queue_anim( "everyoneonme" );
	
	flag_set( "helicopter_down" );
}

greenhouse_fake_target()
{
	level.helicopter endon( "death" );

	ent = spawn( "script_model", level.helicopter.origin );
	ent linkto( level.helicopter, "tag_origin", (0,0,0), (0,0,0) );

	target_set( ent, ( 0,0,-80 ) );
	target_setJavelinOnly( ent, true );

	level.player waittill( "stinger_fired" );

	if ( isalive( level.heli_guy ) )
		level.heli_guy setthreatbiasgroup( "oblivious" );

	greenhouse_helicopter_reaction_wait( 2 );
	level.helicopter thread evasion_path( "evasion_pattern" );
	wait 0.5;

	level thread hunted_flares_fire_burst( level.helicopter, 8, 6, 5.0 );
	wait 0.5;

	ent unlink();
	vec = maps\_helicopter_globals::flares_get_vehicle_velocity( level.helicopter );
	ent movegravity( vec, 8 );

	target_set( level.helicopter, ( 0,0,-80 ) );
	target_setJavelinOnly( level.helicopter, true );

	if ( isalive( level.heli_guy ) )
		level.heli_guy setthreatbiasgroup( "heli_guy" );

	level.player waittill( "stinger_fired" );
	if ( isalive( level.heli_guy ) )
		level.heli_guy setthreatbiasgroup( "oblivious" );

	greenhouse_helicopter_reaction_wait( 3 );
	level.helicopter thread evasion_path( "evasion_pattern" );

	hunted_flares_fire_burst( level.helicopter, 8, 1, 5.0 );
}

greenhouse_helicopter_reaction_wait( remainder )
{
	projectile_speed = 1100 ;
	dist = distance( level.player.origin, level.helicopter.origin );
	travel_time = dist / projectile_speed - remainder;

//	iprintln( travel_time );

	if ( travel_time > 0 )
		wait travel_time;
}

hunted_flares_fire_burst( vehicle, fxCount, flareCount, flareTime )
{
	/*
		copied from maps\_helicopter_globals
		had to change it a litle since I couldn't redirect the missile in my case.
	*/

	assert( isdefined( level.flare_fx[vehicle.vehicletype] ) );
	
	assert( fxCount >= flareCount );
	
	for ( i = 0 ; i < fxCount ; i++ )
	{
		playfx ( level.flare_fx[vehicle.vehicletype], vehicle getTagOrigin( "tag_light_belly" ) );
//		playfx ( level.flare_fx[vehicle.vehicletype], vehicle getTagOrigin( "tag_flare" ) );
		
		if ( vehicle == level.playervehicle )
		{
			level.stats["flares_used"]++;
			level.player playLocalSound( "weap_flares_fire" );
		}		
		wait 0.25;
	}
}

evasion_path( path_name )
{
	self endon( "death" );

	old_path = getstruct( self.currentnode.target, "targetname"  );

	path_struct = self make_evasion_path( path_name );
	self heli_path_speed( path_struct );

	if ( isdefined( old_path ) )
		self heli_path_speed( old_path );
}

make_evasion_path( path_name )
{
	base_struct = getstruct( path_name, "targetname" );

	struct = spawnstruct();
	origin_offset = base_struct.origin;
	start_struct = struct;
	struct_targetname = undefined;

	if ( !isdefined( level.evasion_index ) )
		level.evasion_index = 0;

	while ( true )
	{
		base_struct = getstruct( base_struct.target, "targetname" );
		
		struct.origin = self localtoworldcoords( base_struct.origin - origin_offset );

		if ( isdefined( base_struct.angles ) )
			struct.angles = self.angles + base_struct.angles;
		if ( isdefined( struct_targetname ) )
			struct.targetname = struct_targetname;
		struct_targetname = "evasion_" + level.evasion_index;
		if ( isdefined( base_struct.target ) )
		{
			struct.target = struct_targetname;
			struct add_struct_to_level_array();
		}
		else
		{
			struct add_struct_to_level_array();
			break;
		}

		struct = spawnstruct();
		level.evasion_index++;
	}
	return start_struct;
}

add_struct_to_level_array()
{
	level.struct[ level.struct.size ] = self;

	if ( isdefined( self.targetname ) )
		self add_struct( self.targetname, "targetname" );
	if ( isdefined( self.target ) )
		self add_struct( self.target, "target" );
	if ( isdefined( self.script_noteworthy ) )
		self add_struct( self.script_noteworthy, "script_noteworthy" );
}

add_struct( value, key )
{
	if ( !isdefined( level.struct_class_names[ key ][ value ] ) )
		level.struct_class_names[ key ][ value ] = [];
	size = level.struct_class_names[ key ][ value ].size;
	level.struct_class_names[ key ][ value ][size] = self;
}

greenhouse_barn_door()
{
	flag_wait ( "helicopter_down" );
	
	activate_trigger_with_targetname( "greenhouse_exit_stuckup_color_init" );

	flag_wait( "greenhouse_rear_exit" );

	gate = getent( "big_barn_door", "targetname" );
	anim_ent = getent( "big_barn_animent", "targetname" );

	level.price disable_ai_color();
	anim_ent anim_reach_solo( level.price, "hunted_open_big_barn_gate" );

	anim_ent anim_single_solo( level.price, "hunted_open_big_barn_gate_stop" );
	anim_ent thread anim_single_solo( level.price, "hunted_open_big_barn_gate" );

	wait 1.75;

	gate rotateto( gate.angles + (0,70,0), 2, .5, 0 );
	gate connectpaths();
	gate waittill( "rotatedone");
	gate rotateto( gate.angles + (0,40,0), 2, 0 , 2 );

	activate_trigger_with_targetname( "barn_exit_y_color_init" );

	level.price set_force_color( "o" );
	level.price enable_cqbwalk();

	wait 0.5;
	activate_trigger_with_targetname( "barn_exit_r_color_init" );

	level.price waittill_notify_or_timeout( "goal", 3 );
	level.price disable_cqbwalk();

	flag_set( "greenhouse_done" );
}

area_ac130_init()
{
	/*
		On "gasstation_start"
			- have vehicles start to drive over the bridge.
			- Tank walkers and truck riders.
		On "player_interruption"
			- have a few run up to cover and return fire.
			- tank start rolling towards the player and then kills him with the main gun
		On "ac130_inplace" (lower case)
			- play AC-130 dialogue.
			- AC-130 barrage
				- swap gasstation geo
			- dazed and confused enemies on paths.
			- move out towards bridge.
			- end mission.
	*/

	level thread ac130_devastation();
	level thread ac130_gas_station();
	level thread ac130_enemy_vehicles();

	flag_wait( "ac130_barrage_over" );
	wait 10;
	missionsuccess( "ac130", false );

}

ac130_dazed_guy()
{
	self endon( "death" );

	self setthreatbiasgroup( "oblivious" );
	self.animname = "axis";
	self set_run_anim( "patrolwalk_nolight" );
	self.alwaysRunForward = true;

	flag_wait( "ac130_barrage" );
	self clear_run_anim();
	self.alwaysRunForward = undefined;

	if ( isdefined( self.script_noteworthy ) && self.script_noteworthy == "runners" )
	{
		flag_wait( "ac130_barrage_over" );
		self waittill( "goal" );
		self setthreatbiasgroup( "axis" );
	}
	else
	{
		flag_wait( "go_dazed" );
		self set_run_anim( "dazed_" + randomint(5) );
		self.alwaysRunForward = true;
		flag_wait( "ac130_barrage_over" );
		self waittill( "damage" );
		self clear_run_anim();
		self.alwaysRunForward = undefined;
		self setthreatbiasgroup( "axis" );
	}
}

ac130_devastation()
{
	flag_wait( "ac130_inplace" );

	level.mark thread queue_anim( "bringingintanks" );
	wait 2.5;
	level.price thread queue_anim( "blockedpath" );
	wait 6;
	radio_dialogue( "requestfire" );
	level.mark thread queue_anim( "airsupport" );
	wait 3;
	level thread radio_dialogue( "usesomehelp" );
	wait 4.5;
	level.price thread queue_anim( "100metres" );
	wait 6;
	radio_dialogue( "comindown" );
	wait .5;
	flag_set( "ac130_barrage" );
	wait 1;

	activate_trigger_with_targetname( "cover_color_init" );
	wait 7;

	level.mark.alwaysRunForward = true;
	level.steve.alwaysRunForward = true;
	level.charlie.alwaysRunForward = true;
	level.mark.disableArrivals = true;
	level.steve.disableArrivals = true;
	level.charlie.disableArrivals = true;
	level.mark set_run_anim( "path_slow" );
	level.steve set_run_anim( "path_slow" );
	level.charlie set_run_anim( "path_slow" );

	activate_trigger_with_targetname( "celebrate_color_init" );

	level.mark thread anim_on_goal( "hunted_celebrate", 2.5 );
	level.steve thread anim_on_goal( "hunted_celebrate", 0 );
	level.charlie thread anim_on_goal( "hunted_celebrate", 1 );
	wait 3;

	activate_trigger_with_targetname( "dazed_color_init" );
	flag_set( "go_dazed" );
	wait 6;

	radio_dialogue( "getmovin" );
	level.price thread queue_anim( "comeonletsgo" );

	level.mark.alwaysRunForward = undefined;
	level.steve.alwaysRunForward = undefined;
	level.charlie.alwaysRunForward = undefined;
	level.mark clear_run_anim();
	level.steve clear_run_anim();
	level.charlie clear_run_anim();

	activate_trigger_with_targetname( "mission_end_color_init" );

	flag_set( "ac130_barrage_over" );
}

anim_on_goal( anime, time_delay )
{
	wait 0.5;
	self waittill( "goal" );
	wait time_delay;
	self thread queue_anim( anime );
}

ac130_enemy_vehicles()
{
	dazed_array = getentarray( "dazed_guy", "targetname" );
	array_thread( dazed_array, ::add_spawn_function, ::ac130_dazed_guy );

	activate_trigger_with_targetname( "gas_station_color_init" );

	flag_wait( "gasstation_start" );

	vehicles = maps\_vehicle::spawn_vehicles_from_targetname_and_drive( "gasstation_truck" );

//	array_thread( vehicles, ::ac130_vehicle_die );

}

ac130_vehicle_die()
{
	self endon( "death" );

	flag_wait( "ac130_barrage" );

	switch( self.script_noteworthy )
	{
		case "1":
			wait 1;
			break;
		case "2":
			wait 2.5;
			break;
		case "3":
			wait 9;
			break;
		default:
	}
	self notify( "death" );
}

ac130_gas_station()
{
	flag_wait( "ac130_barrage" );

//	gas_station_origin = getent( "gas_station_origin", "targetname" );
//	gas_station_d_origin = getent( "gas_station_d_origin", "targetname" );
//	offset = ( gas_station_d_origin.origin[0] - gas_station_origin.origin[1], 0, 0 );

	gas_station = getentarray( "gas_station" ,"targetname" );
	gas_station_d = getentarray( "gas_station_d" ,"targetname" );
	big_explosion = getentarray( "big_explosion" ,"targetname" );
	small_explosion = getentarray( "small_explosion" ,"targetname" );

	array_thread( gas_station, ::hide_ent );
	array_thread( gas_station_d, ::swap_ent, (7680,0, 0) );

	array_thread( big_explosion, ::explosion );
	array_thread( small_explosion, ::explosion );
}


// todo: change this to something better when the real effect show up.
/* temp AC130 barrage stuff */
hide_ent( nodelay )
{
	if ( isdefined( self.script_delay ) && !isdefined( nodelay ) )
		wait self.script_delay + 0.1;
	self hide();
}

swap_ent( offset )
{
	if ( isdefined( self.script_delay ) )
		wait self.script_delay;
	self.origin = self.origin + offset;
	wait 0.1; 
	self show();
}

explosion()
{
	if ( isdefined( self.script_delay ) )
		wait self.script_delay;
	playfx( level._effect[ self.targetname ], self.origin );
	if ( self.targetname == "small_explosion" )
	{
		self playsound( "car_explode" );
		radiusdamage( self.origin, 300, 1000, 50);
		earthquake( .2, 1, level.player.origin, 1250 );
	}
	else
	{
		self playsound( "blackhawk_helicopter_crash" );
		radiusdamage( self.origin, 500, 1000, 50);
		earthquake( .2, 2, level.player.origin, 1250 );
	}
}

setup_gas_station()
{
	gas_station_d = getentarray( "gas_station_d" ,"targetname" );
	array_thread( gas_station_d, ::hide_ent, true );
}

/**** start and setup functions ****/

setup_friendlies()
{
	level.squad = [];
	level.price = scripted_spawn( "price", "script_noteworthy", true );
	level.price.animname = "price";
	level.price thread squad_init();

	level.mark = scripted_spawn( "mark", "script_noteworthy", true );
	level.mark.animname = "mark";
	level.mark thread squad_init();

	level.steve = scripted_spawn( "steve", "script_noteworthy", true );
	level.steve.animname = "steve";
	level.steve thread squad_init();

	level.charlie = scripted_spawn( "charlie", "script_noteworthy", true );
	level.charlie.animname = "charlie";
	level.charlie thread squad_init();
}

squad_init()
{
	self thread magic_bullet_shield();
	level.squad[ level.squad.size ] = self;

//	self thread println_on_goal();

	self waittill( "death" );
	level.squad = array_remove( level.squad, self );
}

setup_dogs()
{
	dog_array = getentarray( "actor_enemy_dog", "classname" );
	array_thread( dog_array, ::add_spawn_function, ::dog_settings );
}

dog_settings()
{
	self setthreatbiasgroup( "dogs" );
	self.battlechatter = false;
}

setup_visionset_trigger()
{
	struct = spawnstruct();
	triggers = getentarray( "vision_trigger", "targetname" );
	array_thread( triggers, ::visionset_trigger, struct );
}

visionset_trigger( struct )
{
	while ( true )
	{
		self waittill( "trigger" );
		struct notify( "new_visionset" );
		VisionSetNaked( self.script_noteworthy, self.script_delay );
		struct waittill( "new_visionset" );
	}
}

start_default()
{
	area_flight_init();
}

start_flight_cleanup()
{
	crash_mask = getent( "crash_mask", "targetname" );
	crash_mask delete();
	missile_source = getent( "missile_source", "targetname" );
	missile_source delete();
}

start_crash()
{
	start_flight_cleanup();

	thread hud_hide( true );
	level.player disableweapons();

	area_crash_init();
}

start_dirt_path()
{
	setup_friendlies();
	start_teleport_squad( "path" );

	start_flight_cleanup();

	level.player.g_speed = int( getdvar( "g_speed" ) );
	setsaveddvar( "g_speed", 130 );

	area_dirt_path_init();
}

start_barn()
{
	setup_friendlies();
	start_teleport_squad( "barn" );

	start_flight_cleanup();

	level thread set_flag_on_player_action( "player_interruption", 1, true, true);

	level thread objective_lz();

	flag_set("trucks_warning");
	level thread dirt_path_barn_truck();

	// don't spawn the helicopter.
	getent( "calc_speed_trigger", "script_noteworthy") delete();

	flag_wait( "barn_moveup" );

	area_barn_init();
}

start_field()
{
	setup_friendlies();
	start_teleport_squad( "field" );

	start_flight_cleanup();

	level thread objective_lz();

	area_field_init();
}

start_basement()
{
	setup_friendlies();
	start_teleport_squad( "basement" );

	start_flight_cleanup();

	level thread objective_lz();

	door = getent( "basement_door", "targetname" );
	door_clip = getent( door.target, "targetname" );
	door_clip connectpaths();
	door delete();
	door_clip delete();

	for ( i=0; i<level.squad.size; i++ )
	{
		level.squad[i] set_force_color( "r" );
	}

	flag_set( "squad_in_basement" );

	helicopter = maps\_vehicle::spawn_vehicle_from_targetname( "field_heli" );
	level.helicopter = helicopter;
	helicopter helicopter_searchlight_on();

	area_basement_init();

}

start_farm()
{
	setup_friendlies();
	start_teleport_squad( "farm" );

	start_flight_cleanup();

	level thread objective_lz();

	area_farm_init();
}

start_creek()
{
	setup_friendlies();
	start_teleport_squad( "creek" );
	
	start_flight_cleanup();

	level.price set_force_color( "y" );
	level.mark set_force_color( "y" );
	level.steve set_force_color( "r" );
	level.charlie set_force_color( "r" );

	farm_color_trigger = getentarray( "farm_color_trigger", "script_noteworthy" );
	array_thread( farm_color_trigger, ::trigger_off );

	activate_trigger_with_targetname( "farm_cleared_color_init" );

	flag_set( "farm_clear");
	flag_set( "creek_helicopter");

	level thread objective_lz();

	area_creek_init();
}

start_greenhouse()
{
	setup_friendlies();
	start_teleport_squad( "greenhouse" );
	
	start_flight_cleanup();

	level.price set_force_color( "y" );
	level.mark set_force_color( "y" );
	level.steve set_force_color( "r" );
	level.charlie set_force_color( "r" );

	level.price enable_cqbwalk();
	level.mark enable_cqbwalk();
	level.steve enable_cqbwalk();
	level.charlie enable_cqbwalk();

	flag_set( "player_interruption" );

	// get the creek helicopter on the scene
	start_greenhouse_helicopter();

	level thread objective_lz();

	area_greenhouse_init();
}

start_greenhouse_helicopter()
{
	helicopter = maps\_vehicle::spawn_vehicle_from_targetname( "creek_heli" );
	helicopter sethoverparams(128, 35, 25);

	for ( i=0; i<helicopter.riders.size; i++ )
	{
		helicopter.riders[i] setthreatbiasgroup ( "oblivious" );
	}

	helicopter helicopter_searchlight_on();

	level.helicopter = helicopter;

	setthreatbias( "player", "heli_guy", 10000 );
	setthreatbias( "heli_guy", "player", 20000 );

	level.heli_guy_accuracy = 1;
	level.heli_guy_health_multiplier = 2;
	level.heli_guy_respawn_delay = 20;

	level.helicopter thread activate_heli_guy();
	level.helicopter thread helicopter_attack( 15, "attack_helicopter" );
}

start_ac130()
{
	setup_friendlies();
	start_teleport_squad( "ac130" );
	
	start_flight_cleanup();

	level.price set_force_color( "o" );
	level.mark set_force_color( "y" );
	level.steve set_force_color( "r" );
	level.charlie set_force_color( "r" );

	level thread objective_lz();

	activate_trigger_with_targetname( "barn_exit_y_color_init" );
	activate_trigger_with_targetname( "barn_exit_r_color_init" );

	area_ac130_init();
}

start_teleport_squad( startname )
{
	node = getnode( "startnodeplayer_"+ startname, "targetname" );
	level.player setorigin ( node.origin );
	level.player setplayerangles ( node.angles );

	for ( i=0; i<level.squad.size; i++ )
	{
		level.squad[i] notify( "stop_going_to_node" );
		nodename = "startnode" + level.squad[i].animname + "_" + startname;
		node = getnode( nodename, "targetname" );
		level.squad[i] start_teleport( node );
	}
}

start_teleport( node )
{
	if ( !isdefined( node ) )
		return;
	self teleport ( node.origin, node.angles );
	self setgoalpos ( self.origin );
	self.goalradius = node.radius;
	self setgoalnode ( node );
}


/****************************************************/
/****************************************************/
/******************** Utilities *********************/
/****************************************************/
/****************************************************/

scripted_sightconetrace( start_origin, ignore_entity )
{
	eye = level.player geteye();
	point[0] = eye + ( 14, 14,-0);
	point[2] = eye + (-14, 14,-10);
	point[1] = eye + (-14,-14,-20);
	point[3] = eye + ( 14,-14,-30);

	visible = 0;
	for( i = 0 ; i < point.size ; i ++ )
	{
		if ( bullettracepassed( start_origin, point[i], false, ignore_entity ) )
			visible += 0.25;
	}
	return visible;
}

// todo: get rid of this once it's not in use any more.
are_touching( ent_array, volume )
{
	for ( i=0; i<ent_array.size; i++ )
	{
		if ( ent_array[i] istouching( volume ) )
			return true;
	}
	return false;
}

rush_on_flash()
{
	self endon( "death" );

	while ( true )
	{
		level.player waittill( "flashed" );

		max_attackers = 4;
		axis = get_array_of_closest( level.player.origin, getaiarray( "axis" ), undefined,  max_attackers );
		array_thread( axis, ::rush_on_flash_action );
	}
}

rush_on_flash_action()
{
	self endon( "death" );

	if ( self getFlashBangedStrength() < 0.75 )
		self setFlashBanged( false );

	node = self getcovernode();
	volume = self getgoalvolume();

	self setgoalentity( level.player );
	self.goalradius = 450;

	wait 6;
	
	if ( isdefined( node ) )
		self set_goalnode( node );
	if ( isdefined( volume ) )
	{
		self setgoalnode( getnode( volume.target, "targetname" ) );
		self setgoalvolume( volume );
	}
}

attach_flashlight( state )
{
	self attach( "com_flashlight_on" ,"tag_inhand", true );
	self.have_flashlight = true;
	self flashlight_light( state );
}

detach_flashlight()
{
	if ( !isdefined( self.have_flashlight ) )
		return;
	self detach( "com_flashlight_on", "tag_inhand" );
	self flashlight_light( false );
	self.have_flashlight = undefined;
}

flashlight_light( state )
{
	flash_light_tag = "tag_inhand";

	//todo: remove the offset etc. once the real fx shows up
	if ( state )
	{
		flashlight_fx_ent = spawn( "script_model", ( 0, 0, 0 ) );
		flashlight_fx_ent setmodel( "tag_origin" );
		flashlight_fx_ent hide();
		flashlight_fx_ent linkto( self, flash_light_tag, ( 0, 0, 8 ), ( -90, 0, 0 ) );

		self thread flashlight_light_death( flashlight_fx_ent );
		playfxontag( level._effect["flashlight"], flashlight_fx_ent, "tag_origin" );
	}
	else if( isdefined( self.have_flashlight ) )
		self notify( "flashlight_off" );
}

flashlight_light_death( flashlight_fx_ent )
{
	self waittill_either( "death", "flashlight_off" );

	flashlight_fx_ent delete();
	self.have_flashlight = undefined;

}

hud_hide( state )
{
	wait 0.05;
	if ( state )
	{
		SetSavedDvar( "compass", "0" );
		SetSavedDvar( "ammoCounterHide", "1" );
		SetSavedDvar( "hud_showTextNoAmmo", "0" ); 
	}
	else
	{
		SetSavedDvar( "compass", "1" );
		SetSavedDvar( "ammoCounterHide", "0" );
		SetSavedDvar( "hud_showTextNoAmmo", "1" ); 
	}
}

set_player_speed( g_speed, transition_time )
{
	old_g_speed = int( getdvar( "g_speed" ) );

	steps = abs( old_g_speed - g_speed );
	delay = transition_time/steps;

	dir = 1;
	if ( old_g_speed > g_speed )
		dir = -1;

	old_g_speed = int( getdvar( "g_speed" ) );
	steps = abs( old_g_speed - g_speed );

	for( i = old_g_speed; i != g_speed; )
	{
		setsaveddvar( "g_speed", i );
		wait delay;
		i += dir;
	}

	setsaveddvar( "g_speed", g_speed );
}

set_flag_on_player_action( flag_str, num_bullets, flash, grenade )
{
	// todo: change to use -> notifyOnCommand(<notify>, <command>).
	
	level notify( "kill_action_flag" );
	level endon( "kill_action_flag" );
	level endon( flag_str );

	if ( flag( flag_str ) )
		return;

	while ( true )
	{
		if ( level.player isfiring() )
		{
			num_bullets--;
			if ( num_bullets <= 0 )
				break;
		}

		if ( level.player isthrowinggrenade() )
		{
			if ( isdefined( grenade ) && level.player buttonPressed( "BUTTON_RSHLDR" ) )
			{
				wait 5;
				break;
			}
			else if ( isdefined( flash ) )
			{
				while ( level.player isthrowinggrenade() )
					wait 0.05;
				break;
			}
		}
		wait 0.2;
	}

	flag_set( flag_str );
}

set_fixednode( state )
{
		self.fixedNode = state;
}

make_walk()
{
	old_walkdist = self.walkdist;
	self.walkdist = 1000;
	level waittill( "stop_walk");
	self.walkdist = old_walkdist;
}

flash_immunity( immunity_time )
{
	self endon( "death" );
	self setFlashbangImmunity( true );
	wait immunity_time;
	self setFlashbangImmunity( false );
}

make_ai_move()
{
	self pushplayer( true );
	self set_ignoreSuppression( true );
	self.a.disablePain = true;
	self setthreatbiasgroup( "oblivious" );
}

make_ai_normal()
{
	self pushplayer( false );
	self set_ignoreSuppression( false );
	self.a.disablePain = false;
	self setthreatbiasgroup( "allies" );
}

delete_on_goal()
{
	self endon( "death" );
	self waittill( "goal" );
	self delete();
}

magic_kill( attacker )
{
	ai = getaiarray( "allies" )[0];

	assert( isdefined( ai ) );

	level.player enableHealthShield(false);

	ai magicgrenade( level.player.origin + ( 100, 100, 250), level.player.origin, 1.5 );
	wait 1.6;
	if( isalive( self ) )
		self doDamage ( 50000 , level.player.origin );
}

setthreatbiasgroup_on_array( group, array, array_exclude )
{
	if ( isdefined( array_exclude ) )
		array = array_exclude( array, array_exclude );

	for ( i=0; i<array.size; i++)
	{
		array[i] setthreatbiasgroup( group );
	}
}

setup_heli_guy()
{
	guy = getent( "heli_guy", "targetname" );
	guy add_spawn_function( ::heli_guy );

	// todo: might add normal triggers here an not just structs
	on_triggers = getstructarray( "activate_heli_guy", "script_noteworthy" );
	array_thread( on_triggers, ::activate_heli_guy_trigger );

	off_triggers = getstructarray( "deactivate_heli_guy", "script_noteworthy" );
	array_thread( off_triggers, ::deactivate_heli_guy_trigger );

}

activate_heli_guy_trigger()
{
	while (true )
	{
		self waittill( "trigger", helicopter );
		helicopter activate_heli_guy();
	}
}

activate_heli_guy()
{
	self endon( "death" );
	self endon( "deactivate_heli_guy" );

	assert( !isdefined( self.heli_guy ) );

	if ( !isdefined( level.heli_guy_respawn_delay ) )
		level.heli_guy_respawn_delay = 6;

	while ( true )
	{
		heli_guy = scripted_spawn( "heli_guy", "targetname" );
		heli_guy waittill( "death" );
		wait randomfloat( 3 ) + level.heli_guy_respawn_delay;
	}
}

deactivate_heli_guy_trigger()
{
	while (true )
	{
		self waittill( "trigger", helicopter );
		helicopter deactivate_heli_guy();
	}
}

deactivate_heli_guy()
{
	self notify( "deactivate_heli_guy" );

	self helicopter_close_door();

	wait 1;
	if ( isalive( self.heli_guy ) )
		self.heli_guy delete();

	self.heli_guy = undefined;
}

heli_guy()
{
	assert ( isdefined( level.helicopter ) );

	level.helicopter endon( "death" );

	if ( !isdefined( level.heli_guy_accuracy ) )
		level.heli_guy_accuracy = 1;
	if ( !isdefined( level.heli_guy_health_multiplier ) )
		level.heli_guy_health_multiplier = 1.5;

//	todo: add a custom death animation.
//	self.deathanim = %helicopter_fallout_death;

	self linkto( level.helicopter, "tag_origin", ( 120, 30, -140 ), ( 0,90,0 ) );
	self allowedstances( "crouch" );

	self.health = int( self.health * level.heli_guy_health_multiplier );
	self.baseAccuracy = level.heli_guy_accuracy;

	self setthreatbiasgroup( "heli_guy" );

	level.helicopter notify( "dont_clear_anim" );
	
	level.helicopter helicopter_open_door();
	level.helicopter.heli_guy = self;

	level.helicopter notify( "heli_guy_spawned" );

	self waittill( "death" );

	level.helicopter.heli_guy_died = true;
}

#using_animtree("vehicles");
helicopter_open_door()
{
	wait .5;
	// get a non instant animation
	self UseAnimTree( #animtree );
	self setanim( %mi17_heli_idle, 1, 1 );
}

helicopter_close_door()
{
	// get a non instant animation
	self ClearAnim( %mi17_heli_idle, 1 );
}

#using_animtree("generic_human");
expand_goalradius_ongoal()
{
	self endon( "death" );
	self waittill( "goal" );
	self.goalradius = 1000;
}

setthreatbiasgroup_on_notify( notify_string, group_name )
{
	self endon( "death" );
	self waittill( notify_string );
	self setthreatbiasgroup( group_name );
}

delete_on_unloaded()
{
	// todo: see it there is a way to get away from the wait .5;
	self endon( "death" );
	self waittill( "jumpedout" );
	wait .5;
	self delete();
}

set_goalnode( node )
{
	self setgoalnode( node );
	if ( isdefined( node.radius ) )
		self.goalradius = node.radius;
}

set_goalvolume( volume_targetname )
{
	volume = getent( volume_targetname, "targetname" );
	if ( isdefined(volume.target) )
	{
		node = getnode( volume.target, "targetname" );
		self set_goalnode( node );
	}
	self setgoalvolume( volume );
}

/*
give_weapons()
{
	level.player giveWeapon("Beretta");
	level.player giveWeapon("m4_grunt");
	level.player giveWeapon("fraggrenade");
	level.player giveWeapon("flash_grenade");
	level.player setOffhandSecondaryClass( "flash" );
	wait 0.05;
	level.player switchToWeapon( "m4_grunt" );
}
*/
trigger_timeout( timeout_time )
{
	self endon( "trigger" );
	wait timeout_time;
	self notify( "trigger" );
}

setup_setgoalvolume_trigger()
{
	array_thread( getentarray( "setgoalvolume", "targetname" ), ::setgoalvolume_trigger );
}

setgoalvolume_trigger()
{
	volume = getent( self.target, "targetname" );
	node = getnode( volume.target, "targetname" );
	self waittill( "trigger" );

	axis = getaiarray( "axis" );
	for ( i=0; i<axis.size; i++ )
	{
		axis[i] set_goalnode( node );
		axis[i] setgoalvolume( volume );
	}
}

dynamic_run_speed( pushdist )
{
	self endon( "stop_dynamic_run_speed" );
	self.oldwalkdist = self.walkdist;
	self.old_animplaybackrate = self.animplaybackrate;
	self.run_speed_state = "";

	while ( true )
	{
		wait 0.05;

		dist = distance( self.origin, level.player.origin );

		// todo: fix ahead with within_fov from ai destination to his location and 
		// within_fov( start_origin, start_angles, end_origin, fov )
		// ex: within_fov( level.player.origin, level.player.angles, target1.origin, cos( 45 ) );"


//		ahead broken for now.
//		ai_ahead = self ahead_of_player();
//		if ( !ai_ahead || dist < pushdist / 2 )

		if ( dist < pushdist / 2 )
		{
			// sprint when player is inside half push dist or ai is not ahead of player.
			if ( self.run_speed_state == "sprint" )
				continue;
			self.run_speed_state = "sprint";
//			self set_run_anim( "sprint" );
			self clear_run_anim();
//			self.animplaybackrate = 1.4;
			self waittill("goal");
		}
		else if ( dist < pushdist )
		{
			// run when player is inside push dist.
			if ( self.run_speed_state == "run" )
				continue;
			self.run_speed_state = "run";
			self clear_run_anim();
			self waittill("goal");
//			self.animplaybackrate = 1.2;
//			self waittill("goal");
		}
		else if ( dist < pushdist * 3 )
		{
			// walk if player is outside.
			if ( self.run_speed_state == "walk" )
				continue;
			self set_run_anim( "path_slow" );
			self.animplaybackrate = 1;
			self.run_speed_state = "walk";
		}
		else
		{
			self.disableArrivals = false;
			self.path_halt = true;
//			ahead broken for now.
//			while ( self ahead_of_player() && distance( self.origin, level.player.origin ) > pushdist * 2 )
			while ( distance( self.origin, level.player.origin ) > pushdist * 2 )
				wait 0.05;
			self.path_halt = false;
			self notify("path_resume");
			self.run_speed_state = "";
		}
	}
}

ahead_of_player()
{
	return false;
	// returns true when the ai is ahead of the player.
	// this fails if the ai faces the wrong way. Fix this at some point if needed.
/*
	a = self.angles;
	b = flat_angle( vectortoangles(level.player.origin - self.origin ) );
	c = abs ( a[1] - b[1] ) ;
	if ( c < 90 || c > 270 )
		return false; // ahead of player
	return true;
*/
}

helicopter_attack( hover_time, trigger_name )
{
	// run: helicopter thread activate_heli_guy(); before this thread.

	self endon( "death" );
	self endon( "stop_helicopter_attack" );

	point_struct = setup_helicopter_attack_points( trigger_name );
	elapsed_time = 10000; // so that a point is picked the first time around.

	self sethoverparams( 200, 30, 30);

	if ( !isdefined( self.look_at_ent ) )
		self.look_at_ent = spawn( "script_model", (0, 0, 0) );

	vector = anglestoforward( self.angles );
	self.look_at_ent.origin = self.origin + vector_multiply( vector, 3000 );

	struct = undefined;

	while ( true )
	{
		wait 0.05;

//		iprintln( elapsed_time );

		if ( isdefined( self.heli_guy_died ) )
		{
			elapsed_time += 8; // one time add
			self.heli_guy_died = undefined;
		}
		else if ( distance2d( self.origin, level.player.origin ) < 900 )
			elapsed_time += 0.2;
		//  else if ( isalive( self.heli_guy ) && !self.heli_guy canshoot( level.player geteye(), (0,0,0) ) )
		else if ( isalive( self.heli_guy ) && !sighttracepassed( self.heli_guy geteye(), level.player geteye(), false, self.heli_guy ) )
			elapsed_time += 0.2;
		else
			elapsed_time += 0.05;

		if ( elapsed_time < hover_time && !isdefined( struct.new_selection ) )
			continue;

		struct = helicopter_attack_pick_points( point_struct, struct );
		struct.new_selection = undefined;

		assert( isdefined( struct.angles ) );

		vector = anglestoforward( struct.angles );
		new_pos = struct.origin + vector_multiply( vector, 3000 );
		movetime = distance2d( struct.origin, self.origin ) / 350;
		self.look_at_ent moveto( new_pos, movetime, movetime/2, movetime/2 );

		self setLookAtEnt( self.look_at_ent );

		self heli_path_speed( struct );
		self clearLookAtEnt();
		elapsed_time = 0;
		self.heli_guy_died = undefined;
	}
}

stop_helicopter_attack()
{
	self clearLookAtEnt();
	self notify( "stop_helicopter_attack" );
}

helicopter_attack_pick_points( point_struct, current_point )
{
	points = array_randomize( point_struct.attack_points );

	if ( isdefined( current_point ) )
		points = array_remove ( points, current_point );

	for( i = 0 ; i < points.size ; i ++ )
	{
		if ( distance2d( points[i].origin, level.player.origin ) < 900 )
			continue;
		if ( sighttracepassed( points[i].origin, level.player geteye(), false, undefined ) )
			return points[i];
	}

	return points[0];
}

setup_helicopter_attack_points( trigger_name )
{
	struct = spawnstruct();
	triggers = getentarray( trigger_name, "targetname" );
	array_thread( triggers, ::helicopter_attack_points , struct );
	struct waittill( "new_trigger" );
	return struct;
}

helicopter_attack_points( struct )
{
	self endon( "stop_helicopter_attack" );

	while ( true )
	{
		self waittill( "trigger" );
		if ( isdefined( struct.current_trigger ) && level.player istouching(struct.current_trigger) )
			continue;
		struct notify( "new_trigger" );
		struct.current_trigger = self;
		struct.new_selection = true;
		struct.attack_points = getstructarray( self.target, "targetname" );
		struct waittill( "new_trigger" );
	}
}

follow_path( start_node, disablearrivals )
{
	self endon( "death" );
	self endon( "stop_path" );

	self.path_halt = false;

	node = start_node;
	while ( isdefined( node ) )	
	{
		if ( node.radius != 0 )
			self.goalradius = node.radius;
		if ( isdefined( node.height ) && node.height != 0)
			self.goalheight = node.height;

		self setgoalnode( node );

		if ( isdefined( disablearrivals ) && !disablearrivals )
			self.disableArrivals = true;
		else if ( node node_have_delay() )
			self.disableArrivals = false;
		else
			self disablearrivals_delayed();

		self waittill( "goal" );
		node notify( "trigger", self );

		if (!isdefined (node.target))
			break;

		node script_delay();

		if ( isdefined( node.script_flag ) )
			flag_wait( node.script_flag );

		if ( self.path_halt )
			self waittill( "path_resume" );

		node = getnodearray( node.target, "targetname" );
		node = node[ randomint( node.size ) ];
	}

	self notify( "path_end_reached" );
	self.path_halt = undefined;
}

node_have_delay()
{
	if ( !isdefined (self.target) )
		return true;
	if ( isdefined( self.script_noteworthy ) && self.script_noteworthy == "spot_target" )
	{
		array = getstructarray( self.target, "targetname" );
		if ( !isdefined( array ) )
			return true;
	}
	if ( isdefined ( self.script_delay ) && self.script_delay > 0 )
		return true;
	if ( isdefined ( self.script_delay_max ) && self.script_delay_max > 0 )
		return true;
	if ( isdefined( self.script_flag ) && !flag( self.script_flag ) )
		return true;
	return false;
}

disablearrivals_delayed()
{
	self endon("death");
	self endon( "stop_path" );
	self endon("goal");
	wait 0.5;
	self.disableArrivals = true;
}

scripted_spawn( value, key, stalingrad, spawner )
{
	if ( !isdefined( spawner ) )
		spawner = getent( value, key );

	assertEx( isdefined( spawner ), "Spawner with script_noteworthy " + value + " does not exist." );
	
	if ( isdefined( stalingrad ) )
		ai = spawner stalingradSpawn();
	else
		ai = spawner dospawn();
	spawn_failed( ai );
	assert( isDefined( ai ) );
	return ai;
}

scripted_array_spawn( value, key, stalingrad )
{
	spawner = getentarray( value, key );
	ai = [];

	for ( i=0; i<spawner.size; i++ )
		ai[i] = scripted_spawn( value, key, stalingrad, spawner[i] );
	return ai;
}

waittill_vehicle_group_spawn ( group )
{
	level waittill ("vehiclegroup spawned"+group,vehicles);
	return vehicles;
}

spawn_ent_on_tag( tag )
{
	tag_ent = spawn( "script_model", self gettagorigin( tag ) );
	tag_ent.angles = self.angles;
	tag_ent setmodel( "tag_origin" );
	tag_ent linkto( self, tag );

	return tag_ent;
}

heli_path_speed( struct )
{
	if( isdefined( struct ) && isdefined( struct.speed ) )
	{
		accel = 25; 
		decel = undefined;
		if( isdefined( struct.script_decel ) )
		{
			decel = struct.script_decel;
		}
		speed = struct.speed;

		if( isdefined( struct.script_accel ) )
		{
			accel = struct.script_accel;
		}
		else
		{
			max_accel = speed / 4;
			if( accel > max_accel )
			{
				accel = max_accel;
			}
		}
		if ( isdefined( decel ) )
		{
			self setSpeed( speed, accel, decel );
		}
		else
		{
			self setSpeed( speed, accel );
		}
	}

	maps\_vehicle::vehicle_paths( struct );
}

helicopter_searchlight_on()
{
	// todo: look in to why the search light didn't show up when the heli is far away.
	while ( distance( level.player.origin, self.origin ) > 7000 )
	{
		wait 0.2;
	}

	playfxontag (level._effect["spotlight"], self, "tag_barrel");
	self spawn_searchlight_target();
	self helicopter_setturrettargetent( self.spotlight_default_target );

	self.dlight = spawn( "script_model", self gettagorigin("tag_barrel") );
	self.dlight setModel( "tag_origin" );

/*
	model = spawn( "script_model", self gettagorigin("tag_barrel") );
	model setModel( "fx" );
	model linkto (self.dlight);
*/

	self thread helicopter_searchlight_effect();

	if ( getDvar( "scr_huntedSpotLight" ) == "" )
	{		
		wait 1;
		playfxontag (level._effect["spotlight_dlight"], self.dlight, "tag_origin");
	}
}


helicopter_searchlight_effect()
{
	self endon("death");

	self.dlight.spot_radius = 256;
	self thread spotlight_interruption();
	
	count = 0;
	while( true )
	{
		targetent = self helicopter_getturrettargetent();
		
		if ( isdefined( targetent.spot_radius ) )
			self.dlight.spot_radius = targetent.spot_radius;
		else
			self.dlight.spot_radius = 256;

		vector = anglestoforward( self gettagangles( "tag_barrel" ) );
		start = self gettagorigin( "tag_barrel" );
		end = self gettagorigin( "tag_barrel" ) + vector_multiply ( vector, 3000 );

		trace = bullettrace( start, end, false, self );
		dropspot = trace[ "position" ];
		dropspot = dropspot + vector_multiply ( vector, -96 );

		if ( getDvar( "scr_huntedSpotLight" ) != "" )
		{
			playfx ( level._effect["spotlight_cloud"], dropspot, ( 0.0, 1.0, 0.0 ), ( 0.0, 0.0, 1.0 ) );

			if ( count == 0 )
				playfx ( level._effect["spotlight_dust"], dropspot, ( 0.0, 1.0, 0.0 ), ( 0.0, 0.0, 1.0 ) );
			
			count++;
			if ( count == 10 )
				count = 0;
		}

//		self.dlight moveto( dropspot, .05 );
		self.dlight moveto( dropspot, .5 );

//		thread drawline(start, end, (1,0,1) , 0.1 );
//		thread drawline(start, dropspot, (0,0,1) , 0.1 );

//		wait .05;
		wait .5;
	}
}

spotlight_interruption()
{
	self endon( "death" );
	level endon( "player_interruption" );

	while ( distance( level.player.origin, self.dlight.origin ) > self.dlight.spot_radius )
		wait 0.25;

//	iprintln ( distance( level.player.origin, self.dlight.origin ) );
//	iprintln ( self.dlight.spot_radius ) ;

	flag_set( "player_interruption" );
}

spawn_searchlight_target()
{
	spawn_origin = self gettagorigin( "tag_ground" );

	target_ent = spawn( "script_origin", spawn_origin );
	target_ent linkto( self, "tag_ground", (320,0,-256), (0,0,0) );
	self.spotlight_default_target = target_ent;
	self thread searchlight_target_death();
}

searchlight_target_death()
{
	ent = self.spotlight_default_target;
	self waittill( "death" );
	ent delete();
}


create_overlay_element( shader_name, start_alpha )
{
	overlay = newHudElem();
	overlay.x = 0;
	overlay.y = 0;
	overlay setshader ( shader_name, 640, 480);
	overlay.alignX = "left";
	overlay.alignY = "top";
	overlay.horzAlign = "fullscreen";
	overlay.vertAlign = "fullscreen";
	overlay.alpha = start_alpha;
	return overlay;
}

fade_overlay( target_alpha, fade_time )
{
	self fadeOverTime( fade_time );
	self.alpha = target_alpha;
	wait fade_time;
}

exp_fade_overlay( target_alpha, fade_time )
{
	fade_steps = 4;
	step_angle = 90 / fade_steps;
	current_angle = 0;
	step_time = fade_time / fade_steps;

	current_alpha = self.alpha;
	alpha_dif = current_alpha - target_alpha;

	for ( i=0; i<fade_steps; i++ )
	{
		current_angle += step_angle;

		self fadeOverTime( step_time );
		if ( target_alpha > current_alpha )
		{
			fraction = 1 - cos( current_angle );
			self.alpha = current_alpha - alpha_dif * fraction;
		}
		else
		{
			fraction = sin( current_angle );
			self.alpha = current_alpha - alpha_dif * fraction;
		}

		wait step_time;
	}
}

music()
{
	//musicplay( "hunted_intro_mysterious_music" );
	
	musicplay( "hunted_danger_music" );
	
	flag_wait("trucks_warning");
	
	musicstop(5);
	
	flag_wait( "hit_the_deck_music" );
	wait 0.3;
	
	musicplay( "hunted_danger_music" );
}

/**** debug stuff ****/
// todo: delete these functions when done.

drawline(p1, p2, color, show_time)
{
	if ( !isdefined(show_time) )
		show_time = 100;

	show_time = gettime() + (show_time * 1000);
	while ( gettime() < show_time)
	{
		line( p1, p2, color);
		wait 0.05;
	}
}