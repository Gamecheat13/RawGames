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
*/

#using_animtree("generic_human");
main()
{
	setsaveddvar( "r_specularcolorscale", "1.5" );

	setculldist( 14500 );

	add_start("flight", ::start_flight);
	add_start("path", ::start_dirt_path);
	add_start("barn", ::start_barn);
	add_start("field", ::start_field);
	add_start("basement", ::start_basement);
	add_start("dogs", ::start_farm);
	add_start("farm", ::start_farm);
	add_start("creek", ::start_creek);


	precacheShader( "overlay_hunted_red" );
	precacheShader( "overlay_hunted_black" );

//	precacheItem( "tmp_missile_straight" );

	precacheturret( "heli_small_arms_fire" );

	precacheModel( "viewhands_player_usmc" );
	precachemodel( "weapon_saw_MG_setup" );
	precacheModel( "com_flashlight_on" );

	createthreatbiasgroup( "player" );
	createthreatbiasgroup( "dogs" );
	createthreatbiasgroup( "oblivious" );

	setup_flags();

	default_start( ::start_default );

	maps\_bm21_troops::main("vehicle_bm21_mobile_cover");
	maps\_bm21_troops::main("vehicle_bm21_mobile_bed");
	maps\_mi17::main("vehicle_mi17_woodland_fly");
	maps\_blackhawk::main("vehicle_blackhawk");
	maps\_luxurysedan::main("vehicle_luxurysedan");

	animscripts\dog_init::initDogAnimations();

	maps\createart\hunted_art::main();
	maps\hunted_fx::main();
	maps\_load::main();

	maps\hunted_anim::main();

	level.player setthreatbiasgroup( "player" );

	// make oblivious ingnored and ignore by everything.
	setignoremegroup( "allies", "oblivious" );	// oblivious ignore allies
	setignoremegroup( "axis", "oblivious" );	// oblivious ignore axis
	setignoremegroup( "player", "oblivious" );	// oblivious ignore player
	setignoremegroup( "oblivious", "allies" );	// allies ignore oblivious
	setignoremegroup( "oblivious", "axis" );	// axis ignore oblivious
	setignoremegroup( "oblivious", "oblivious" );	// oblivious ignore oblivious

	level thread maps\hunted_amb::main();
	maps\_compass::setupMiniMap("compass_map_hunted");

	setup_setgoalvolume_trigger();
	setup_friendlies();
	setup_dogs();
	setup_visionset_trigger();

	battlechatter_off( "allies" );
	battlechatter_off( "axis" );

}

setup_flags()
{
	// crash area
	flag_init ( "price_help" );
	flag_init ( "wakeup_start" );
	flag_init ( "wakeup_done" );
	flag_init ( "wounded_check" );
	flag_init ( "wounded_check_interrupted" );
	flag_init ( "wounded_check_done" );

	// path area
	flag_init ( "mark_at_goal" );
	flag_init ( "trucks_warning" );
	flag_init ( "tunnel_rush" );
	flag_init ( "spawn_tunnel_helicopter" );
	flag_init ( "helicopter_fly_over" );
	flag_init ( "price_in_tunnel" );
	flag_init ( "mark_in_tunnel" );

	// barn area
	flag_init ( "barn_truck_arrived" );
	flag_trigger_init ( "barn_moveup", getent( "tunnel_trigger", "script_noteworthy" ) );
	flag_init ( "barn_interrogation_start" );
	flag_init ( "barn_rear_open" );
	flag_init ( "barn_front_open" );
	flag_init ( "interrogation_done" );

	// first field area
	flag_init ( "field_open" );
	flag_trigger_init ( "field_cross", getent( "field_cross", "targetname" ) );
	flag_trigger_init ( "field_cover", getent( "field_cover", "targetname" ) );
	flag_init ( "field_defend" );
	flag_trigger_init ( "field_basement", getent( "field_basement", "targetname" ) );
	flag_init ( "field_open_basement" );
	flag_init( "hit_the_deck_music" );

	// basement area
	flag_init ( "basement_open" );
	flag_trigger_init ( "basement_enter", getent( "basement_enter", "targetname" ) );
	flag_trigger_init ( "basement_heli_takeoff", getent( "basement_heli_takeoff", "targetname" ) );
	flag_trigger_init ( "basement_flash", getent( "basement_flash", "targetname" ) );

	flag_init ( "squad_in_basement" );
	flag_init ( "basement_secure" );

	// farm area
	flag_trigger_init ( "farm_start", getent( "farm_start", "targetname" ) );
	flag_trigger_init ( "farm_alert", getent( "farm_alert", "targetname" ) );
	flag_init ( "farm_clear");
	
	// creek area
	flag_trigger_init ( "creek_helicopter", getent( "creek_helicopter", "targetname" ) );
	flag_trigger_init ( "creek_start", getent( "creek_start", "targetname" ) );
	flag_trigger_init ( "creek_bridge", getent( "creek_bridge", "targetname" ) );
	flag_init ( "creek_gate_open" );
	flag_init ( "creek_truck_on_bridge" );

	// road area
	flag_trigger_init ( "road_start", getent( "road_start", "targetname" ) );
	flag_init ( "road_open_field" );
	flag_init ( "roadblock" );
	flag_init ( "roadblock_start" );
	flag_init ( "roadblock_done" );

	// greenhouse area

	// other flags
	flag_init ( "heli_small_arms_fire" );
	flag_init ( "spot_target_path" );
	flag_init ( "helicopter_unloading" );
	flag_init ( "player_interruption" );

}

/**** objectives ****/

objective_lz()
{
	gear_origin = getstruct( "bridge_origin", "targetname" );
	objective_add( 1, "active", &"HUNTED_EXTRACTION_POINT", gear_origin.origin );
	objective_current( 1 );
}

/**** helicopter flight ****/
area_flight_init()
{
	VisionSetNaked( "hunted_crash", 0 );
	flight_helicopter();

	level.player takeallweapons();

	setExpFog(2500, 5000, 0.045, 0.17, 0.2, 0);

}

flight_helicopter()
{
	array = maps\_vehicle::scripted_spawn ( 3 );
	blackhawk = array[0];
	blackhawk thread fly_path();

	tag_ent = blackhawk fake_tag( "tag_ground", (-64,24,16), (0,0,0) );

	level.player playerlinktodelta(tag_ent, "tag_origin", 0.5, 45, 45, 30, 30);
	
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
	setExpFog(512, 6145, 0.132176, 0.192839, 0.238414, 0);

	thread hud_hide( true );

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
	anim_ent thread anim_loop_solo( wounded, "hunted_woundedhostage_idle_end", undefined, "stop_idle" );

	anim_ent anim_single_solo( level.steve, "hunted_woundedhostage_check_end" );

	self set_goalnode( getnode( "steve_dirt_path", "targetname" ) );

	flag_set( "wounded_check_done" );

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
	level.player takeallweapons();

	level thread crash_wakeup();

	level.player.g_speed = int( getdvar( "g_speed" ) );
	setsaveddvar( "g_speed", 130 );

	flag_set( "wounded_check" );

	flag_wait("wakeup_done");

	give_weapons();
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

	self thread queue_anim( "letsgo" );
	
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

dirt_path_mark()
{
	self notify( "stop_going_to_node" );

	node = getnode( "mark_dirt_path", "targetname" );

	self set_run_anim( "path_slow" );
	self thread follow_path( node );
	self thread dynamic_run_speed( 600 );
	self thread dirt_path_mark_path_end();

	flag_wait("tunnel_rush");

	self notify( "stop_path" );
	self notify( "stop_dynamic_run_speed" );
	self.animplaybackrate = 1;
	self clear_run_anim();
	self.disableArrivals = false;

	if ( flag( "mark_at_goal" ) )
		wait 2;

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

dirt_path_charlie()
{
	anim_ent = getent( "truck_warning_animent", "targetname" );
	anim_ent anim_reach_and_idle_solo( self, "hunted_spotter_wave_chat", "hunted_spotter_idle", "charlie_stop_idle" );

	flag_wait("trucks_warning");

	anim_ent notify( "charlie_stop_idle" );
	anim_ent anim_single_solo( self, "hunted_spotter_wave_chat" );

	flag_set("tunnel_rush");

	node = getnode( "charlie_tunnel", "targetname" );
	self setgoalnode( node );
	self.goalradius = 0;
	self waittill("goal");
	self clear_run_anim();
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

	helicopter thread fly_path();

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

	level thread set_flag_on_player_action( "player_interruption", 1, true, true);
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
	autosave_by_name( "barn" );

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
	level.mark set_goalnode( getnode( "mark_barn_exterior", "targetname" ) );
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
	farmer animscripts\shared::detachWeapon( farmer.weapon );
	farmer detachall();


	leader = undefined;
	thug = undefined;

	axis = getaiarray( "axis" );
	for ( i=0; i<axis.size; i++ )
	{
		if ( isdefined( axis[i].script_noteworthy ) && axis[i].script_noteworthy == "leader" )
			leader = axis[i];
		if ( isdefined( axis[i].script_noteworthy ) && axis[i].script_noteworthy == "thug" )
			thug = axis[i];
	}

	assert( isdefined( leader ) && isdefined( thug ) && isdefined( farmer ) );

	leader.animname = "leader";
	thug.animname = "thug";

	actors[0] = leader;
	actors[1] = farmer;
	actors[2] = thug;

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
	level.price thread queue_anim( "wastebeforekill" );
}

barn_interrogation_interruption()
{
	level endon( "interrogation_done" );

	flag_wait( "player_interruption" );
	level notify( "interrogation_interrupted" );
}

barn_interrogation_anim( anim_ent, actors )
{
	level endon( "interrogation_interrupted" );

	anim_ent thread anim_single( actors, "hunted_farmsequence");
	actors[0] waittillmatch( "single anim", "pistol_putaway" );
}

barn_abort_actors()
{
//	level endon( "interrogation_done" );

	flag_wait( "player_interruption" );
	self stopanimscripted();
	self notify( "single anim", "end" );
}

barn_farmer( anim_ent )
{
	// todo: have the ragdoll notetrack moved so that I don't have to do this by hand.
	level endon( "player_interruption" );

	self set_ignoreSuppression( true );
	wait 20;
	self.deathFunction = ::barn_farmer_death_wait;
	self doDamage( self.health + 5, (0,0,0) );
	self startragdoll();
}

barn_farmer_death_wait()
{
	flag_wait( "field_cover" );
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
	self make_ai_move();
	self set_goalnode( getnode( "price_barn_interior", "targetname" ) );
	self waittill( "goal" );
	self make_ai_normal();
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
	self make_ai_move();
	self set_goalnode( getnode( "price_barn_interior", "targetname" ) );
	self waittill( "goal" );
	self make_ai_normal();
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
	door rotateto( door.angles + (0,70,0), 2, .5, 0 );
	door connectpaths();
	door waittill( "rotatedone");
	door rotateto( door.angles + (0,40,0), 2, 0, 2 );

	flag_set("barn_rear_open");
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

	doors = getentarray( "barn_main_door","targetname");

	anim_ent = spawn( "script_origin", (962, -3849, 110.475) );
	anim_ent.angles = (0,164,0);

	anim_ent anim_reach_solo( self, "door_kick_in" );
	anim_ent thread anim_single_solo( self, "door_kick_in" );
	self waittillmatch( "single anim", "kick" );

	for ( i=0; i<doors.size; i++ )
	{
		if ( doors[i].script_noteworthy == "right" )
			doors[i] rotateto( doors[i].angles + (0,-160,0), .6, 0 , .1 );
		else
			doors[i] rotateto( doors[i].angles + (0,175,0), .75, 0 , .1 );
		doors[i] connectpaths();
			
	}
	self make_ai_normal();
}

/**** field area ****/

area_field_init()
{
	autosave_by_name( "field" );

	wait 2;
	level thread field_dialgue();
	level.mark thread field_kick_open();

	array_thread( level.squad, ::field_allies );
	level thread field_helicopter();
	level thread field_truck();
	level thread field_basement();

	flag_wait( "field_defend" );

	activate_trigger_with_targetname( "field_defend_color_init" );

	flag_wait( "basement_open" );

	level thread area_basement_init();
}

field_dialgue()
{
	level.charlie thread queue_anim( "goodtogo" );
	level.price thread anim_single_solo_delayed( 1, level.price, "goodtogo" );

	struct = getstruct( "field_go_prone", "script_noteworthy" );
	struct waittill( "trigger" );
	
	flag_set( "hit_the_deck_music" );

	level.price queue_anim( "spotlighthitdeck" );

	flag_wait( "field_defend" );
	level.price queue_anim( "letsgo" );
	wait 4.5;
	level.mark thread queue_anim( "contactsix" );

	flag_wait( "field_open_basement" );
	level.price thread queue_anim( "basementdooropen" );
	flag_wait( "basement_open" );
	level.price thread queue_anim( "gethousegogo" );
}

field_kick_open()
{
	field_blocker = getent( "field_blocker", "targetname" );
	clip = getent( "field_clip", "targetname" );
	clip connectpaths();

	anim_ent = getent( "kick_animent", "targetname" );

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
	
	if ( self != level.charlie )
	{
		flag_wait( "field_open" );
		wait randomfloatrange( 1.7, 2 );
	}

	node = getnode( ai_name + "_field_path", "targetname" );
	self set_goalnode( node );

	flag_wait( "field_cross" );
	wait randomfloat(.25);
	self thread follow_path( node );

	flag_wait( "field_cover" );
	self notify("stop_path");
	wait randomfloat(.25);

	old_animplaybackrate = self.animplaybackrate;
	self.animplaybackrate = 1.25;

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
	current_vector = anglestoforward( self.angles );
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

	helicopter thread heli_small_arms_fire();

	assert( isdefined( helicopter.riders ) );
	array_thread( helicopter.riders, ::field_axis );

	helicopter thread fly_path();
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

spot_target_path( script_origin )
{
	/*
	takes the first script_origin in a path
	script_speed is units per second.
	script_delay works
	*/

	assert( isdefined( script_origin ) );

	flag_waitopen( "spot_target_path" );

	flag_set( "spot_target_path" );

	target_ent = spawn( "script_model", script_origin.origin );
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

		target_ent moveto( script_origin.origin, movespeed );
		target_ent waittill( "movedone" );
		script_origin script_delay();

		if ( isdefined( script_origin.script_flag ) )
			flag_wait( script_origin.script_flag );
	}
	self helicopter_setturrettargetent();
	target_ent delete();

	flag_clear( "spot_target_path" );
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

	anim_ent = getent ( "basement_animent", "targetname" );

	anim_ent anim_reach_solo( level.mark, "hunted_open_basement_door_kick" );
	anim_ent thread anim_single_solo( level.mark, "hunted_open_basement_door_kick" );
	
	// todo: change to use door model with lock etc and animations for the same.
	// todo: once the door model is in I need to attack a clip etc.
	wait 8;

	getent( "basement_player_block", "targetname" ) notsolid();

	door = getent( "basement_door", "targetname" );
	door connectpaths();


	door_target1 = getent( door.target, "targetname" );
	door_target2 = getent( door_target1.target, "targetname" );
	door_target3 = getent( door_target2.target, "targetname" );

	door notsolid();

	door rotateto( door_target1.angles, .25, .25, 0 );
	door waittill( "rotatedone" );
	door rotateto( door_target2.angles, .25 );
	door waittill( "rotatedone" );
	door rotateto( door_target3.angles, .4 );
	door waittill( "rotatedone" );

	// todo: mark dialogue.

	flag_set( "basement_open" );

	level.mark set_ignoreSuppression( false );
	level.mark pushplayer( false );
	level.mark setthreatbiasgroup( "allies" );

	level.mark enable_ai_color();

	volume = getent( "basement_door_volume", "targetname" );
	while ( level.player istouching( volume ) )
		wait 0.1;

	door solid();

}

/**** basement area ****/
area_basement_init()
{
	autosave_by_name( "basement" );

	level.price thread basement_price();
	level thread basement_allies();
	level thread basement_helicopter();
	level thread basement_trim_field();
	level thread basement_flash();

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

	self set_goalnode( getnode( "basement_enter_price", "targetname" ) );

	flag_wait( "squad_in_basement" );

	player_block = getent( "basement_player_block", "targetname" );
	player_block solid();

	anim_ent = getent ( "basement_animent", "targetname" );
	anim_ent anim_reach_solo( self, "hunted_basement_door_block" );
	anim_ent thread anim_single_solo( self, "hunted_basement_door_block" );

	wait 1;

	door = getent( "basement_inner_door", "targetname" );
	door notsolid();
	door rotateyaw( -180, 1.5, .25, 0 );
	door waittill( "rotatedone" );
	door disconnectpaths();
	door solid();

	self set_force_color( "y" );

	flag_set( "basement_secure" );

	player_block delete();

	wait 1;
	self thread queue_anim( "takepointscout" );

	flag_wait( "farm_start" );
}

basement_helicopter()
{
	helicopter = level.helicopter;

	flag_wait( "squad_in_basement" );

	flag_clear( "heli_small_arms_fire" );

	path_struct = getstruct( "heli_basement_path", "targetname" );
	helicopter notify( "stop_path" );

	helicopter setSpeed( 90, 90 );
	helicopter thread fly_to( path_struct );

	trigger = getent( "basement_shine", "targetname" );
	trigger waittill( "trigger" );

	helicopter sethoverparams( 0, 0, 0 );

	path_struct = getstruct( path_struct.target, "targetname" );
	helicopter fly_path( path_struct );

	flag_wait( "basement_heli_takeoff" );
	path_struct = getstruct( "heli_flash_path", "targetname" );
	helicopter notify( "stop_path" );
	helicopter thread fly_to( path_struct );

	flag_wait( "basement_flash" );

	path_struct = getstruct( path_struct.target, "targetname" );

	helicopter fly_path( path_struct );

}

basement_trim_field()
{
	axis = getaiarray( "axis" );
	axis = array_exclude( axis, get_ai_group_ai( "basement_field_guy" ) );

	for ( i=0; i<axis.size; i++ )
	{
		axis[i] delete();
	}

	while( !flag( "basement_flash" ) && get_ai_group_count( "basement_field_guy" ) > 3 )
		wait 0.05;

	axis = getaiarray( "axis" );
	node = getnode( "field_retreat_node", "targetname" );
	array_thread( axis, ::set_goalnode, node );
	array_thread( axis, ::delete_on_goal );

}

basement_flash()
{
	flag_wait( "basement_flash" );

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

	autosave_by_name( "farm" );

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
	battlechatter_off( "allies" );
	battlechatter_off( "axis" );

	activate_trigger_with_targetname( "farm_color_init" );

	setthreatbias( "dogs", "allies", -10000 );

	flag_wait( "farm_alert" );

	battlechatter_on( "allies" );
	battlechatter_on( "axis" );

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

	level.steve queue_anim( "tooquiet" );
	level.mark queue_anim( "regroupin" );
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
		axis[i] settargetentity( level.player );
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

	gate rotateto( gate .angles + (0,70,0), 2, .5, 0 );
	gate connectpaths();
	gate waittill( "rotatedone");
	gate rotateto( gate.angles + (0,40,0), 2, 0 , 2 );

	activate_trigger_with_targetname( "creek_color_init" );
	level.price set_force_color( "y" );

	flag_wait( "creek_truck_on_bridge" );

	level thread set_flag_on_player_action( "player_interruption", 1, true, true);
}

creek_dialogue()
{
	wait 5;
	level.mark queue_anim( "helicopterscomin" );
	wait 3;
	level.price queue_anim( "theyvelostus" );
	flag_wait( "creek_gate_open" );
	wait 0.5;
	level.price queue_anim( "dontknowexactly" );

	level endon( "player_interruption" );

	heli_node = getstruct( "creek_heli_warning", "script_noteworthy" );
	heli_node waittill( "trigger" );

	// get dialogue, sub vocalized: "helicopter! stay in cover."
	level.price queue_anim( "helicopter_cover" );
}

creek_truck()
{
	flag_wait( "creek_start" );
	
	truck = maps\_vehicle::spawn_vehicle_from_targetname( "creek_truck" );
	thread maps\_vehicle::gopath ( truck );
	truck maps\_vehicle::lights_on( "headlights" );

	truck waittill( "unload" );
	flag_set( "creek_truck_on_bridge" );

	truck setspeed( 0, 35 );
	wait 2;
	truck resumespeed( 35 );
}

creek_helicopter()
{
	wait 3;

	helicopter = maps\_vehicle::spawn_vehicle_from_targetname( "creek_heli" );
	helicopter sethoverparams(128, 35, 25);

	level.helicopter = helicopter;

	helicopter thread fly_path();
	helicopter helicopter_searchlight_on();

	flag_wait( "creek_bridge" );

	// todo: tweak this if need to make the helicopter show up at the optimal time in the creek.
//	wait 4;

	path_struct = getstruct( "creek_flyover_struct", "targetname" );
	
	helicopter thread fly_path( path_struct );
}

creek_bridge_guy()
{
	// todo: idle animations with flashlights.
	self endon( "death" );
	self notify( "stop_going_to_node" );

	self setthreatbiasgroup( "oblivious" );

	self.animname = "axis";

	self.disableArrivals = true;
	self set_run_anim( "patrolwalk_" + ( randomint(5) + 1 ) );

	self waittill( "jumpedout" );

	path_node = getnode( self.target, "targetname" );
	self thread follow_path( path_node );

	wait 2;

	self attach( "com_flashlight_on" ,"tag_inhand", true );

	self flashlight_light( true );

	self thread axis_interrupt();
}

creek_guard_node()
{
	while ( true )
	{
		self waittill( "trigger", ai);
		self anim_single_solo( ai, self.script_animation );
	}
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
	if ( !flag( "player_interruption" ) )
	{
		autosave_by_name( "road" );
		level thread road_field();
		level thread road_roadblock();
		level thread road_allies();

		flag_wait( "player_interruption" );
		iprintlnbold( "End of currently scripted level" );
	}
	else
	{
		// todo: what needs to be done to spawn in guys to fight the player
		iprintlnbold( "End of currently scripted level" );
	}

	// todo: start the next area thread.
}

road_field()
{
	// todo:
	wait 10;
	flag_set( "road_open_field" );
}

road_allies()
{
	level endon( "player_interruption" );

	flag_wait( "road_open_field" );

	bridge_volume = getent( "bridge_volume", "targetname" );
	creek_bridge_guys = get_ai_group_ai( "creek_bridge_guy" );

	if ( are_touching( creek_bridge_guys, bridge_volume ) )
		level.price queue_anim( "bridge_holdup" );

	while ( are_touching( creek_bridge_guys, bridge_volume ) )
		wait .5;

	flag_set( "roadblock" );

	// todo: get sub vocalized dialogue "Alright, lets move, now!"
	level.price queue_anim( "creek_move_now" );

	activate_trigger_with_targetname( "road_color_stage_1" );

	// todo: check if the player does stupid shit.
	// todo: make these stages activated based on the player
	wait 0.1;
	level.price waittill( "goal" );
	wait 6;

	activate_trigger_with_targetname( "road_color_stage_2" );

	level.price waittill( "goal" );
	flag_wait( "roadblock_done" );
	wait 2;

	activate_trigger_with_targetname( "road_color_stage_3" );

	level.price waittill( "goal" );
	wait 6;

	activate_trigger_with_targetname( "road_color_stage_4" );

	wait 4;

	iprintlnbold( "End of currently scripted level" );

}

road_roadblock()
{
	flag_wait( "roadblock" );

	actors = scripted_array_spawn( "roadblock_guy", "script_noteworthy", true );
	level thread road_roadblock_anim( actors );

//	todo: make this work
//	sedan maps\_vehicle::lights_on( "headlights" );

	start_vnode = getvehiclenode( "roadblock_start", "script_noteworthy" );
	stop_vnode = getvehiclenode( "roadblock_stop", "script_noteworthy" );

	sedan = maps\_vehicle::spawn_vehicle_from_targetname( "road_sedan" );
	thread maps\_vehicle::gopath ( sedan );

	level endon( "player_interruption" );

	start_vnode waittill( "trigger" );

	flag_set( "roadblock_start" );

	stop_vnode waittill( "trigger" );

	sedan setspeed( 0, 15 );
	
	flag_wait( "roadblock_done" );

	sedan resumespeed( 35 );
}

road_roadblock_anim( actors )
{
	nodes = getnodearray( "roadblock_path", "targetname" );
	actors[0] thread road_roadblock_guy( "guard1", nodes[0] );
	actors[1] thread road_roadblock_guy( "guard2", nodes[1] );

	anim_ent = getent( "roadblock_animent", "targetname" );

	level thread road_roadblock_interrupt( actors, anim_ent );

	anim_ent anim_reach_and_idle( actors, "roadblock_sequence", "roadblock_startidle", "stop_idle" );

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
}

road_roadblock_guy( animname, path_node )
{
	self endon( "death" );

	self.animname = animname;
	self.disableArrivals = true;
	self set_run_anim( "patrolwalk" );
	self setthreatbiasgroup( "oblivious" );
	
	self attach( "com_flashlight_on" ,"tag_inhand", true );
	self flashlight_light( true );

	self thread axis_interrupt();

	flag_wait( "roadblock_done" );
	self.animname = "axis";
	self thread follow_path( path_node );
}

axis_interrupt()
{
	self endon( "death" );

	flag_wait( "player_interruption" );
	wait randomfloat( 1.5 );

	self notify( "stop_path" );
	self flashlight_light( false );
	self.disableArrivals = false;
	self clear_run_anim();
	self setthreatbiasgroup( "axis" );
	self set_force_color( "p" );

	self detach( "com_flashlight_on" ,"tag_inhand" );
}

/**** start and setup functions ****/

setup_friendlies()
{
	level.squad = [];
	level.price = scripted_spawn( "price", "script_noteworthy" );
	level.price.animname = "price";
	level.price thread squad_init();

	level.mark = scripted_spawn( "mark", "script_noteworthy" );
	level.mark.animname = "mark";
	level.mark thread squad_init();

	level.steve = scripted_spawn( "steve", "script_noteworthy" );
	level.steve.animname = "steve";
	level.steve thread squad_init();

	level.charlie = scripted_spawn( "charlie", "script_noteworthy" );
	level.charlie.animname = "charlie";
	level.charlie thread squad_init();
}

squad_init()
{
	self thread magic_bullet_shield();
	level.squad[ level.squad.size ] = self;
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
	area_crash_init();
}

start_flight()
{
	area_flight_init();
}

start_dirt_path()
{
	start_teleport_squad( "path" );

	level.player.g_speed = int( getdvar( "g_speed" ) );
	setsaveddvar( "g_speed", 130 );

	area_dirt_path_init();
}

start_barn()
{
	start_teleport_squad( "barn" );

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
	start_teleport_squad( "field" );

	battlechatter_on( "allies" );
	battlechatter_on( "axis" );

	level thread objective_lz();

	area_field_init();
}

start_basement()
{
	start_teleport_squad( "basement" );

	battlechatter_on( "allies" );
	battlechatter_on( "axis" );

	level thread objective_lz();

	door = getent( "basement_door", "targetname" );
	door connectpaths();
	door delete();

	for ( i=0; i<level.squad.size; i++ )
	{
		level.squad[i] set_force_color( "r" );
	}

	flag_set( "squad_in_basement" );

	helicopter = maps\_vehicle::spawn_vehicle_from_targetname( "field_heli" );
	level.helicopter = helicopter;

	area_basement_init();

}

start_farm()
{
	start_teleport_squad( "farm" );

	battlechatter_on( "allies" );
	battlechatter_on( "axis" );

	level thread objective_lz();

	area_farm_init();
}

start_creek()
{
	start_teleport_squad( "creek" );
	
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

flashlight_light( state )
{
	flash_light_tag = "tag_inhand";

	if ( state )
	{
		flashlight_fx_ent = spawn( "script_model", ( 0, 0, 0 ) );
		flashlight_fx_ent setmodel( "tag_origin" );
		flashlight_fx_ent hide();
		flashlight_fx_ent linkto( self, flash_light_tag, ( 0, 0, 0 ), ( 0, 0, 0 ) );

		self thread flashlight_light_death( flashlight_fx_ent );
		playfxontag( level._effect["flashlight"], flashlight_fx_ent, "tag_origin" );
	}
	else
		self notify( "flashlight_off" );
}

flashlight_light_death( flashlight_fx_ent )
{
	self waittill_either( "death", "flashlight_off");
	flashlight_fx_ent delete();
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
	level notify( "kill_old" );
	level endon( "kill_old" );

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
				wait 4.5;
				break;
			}
			else if ( isdefined( flash ) )
			{
				while ( level.player isthrowinggrenade() )
					wait 0.05;
				break;
			}
		}
		wait 0.05;
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
	dmgAmount = ( self.health / 2 );
	while( isalive( self ) )
	{
		self doDamage ( dmgAmount, attacker.origin );
		wait randomfloatrange( 0.05, 0.3 );
	}
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

heli_small_arms_fire()
{
	turret = spawnturret( "misc_turret", self gettagorigin( "left_door" ), "heli_small_arms_fire" );
	turret setmodel( "weapon_saw_MG_setup" );
	turret linkto( self, "left_door", (0,0,-24), (0,90,0) );
	turret maketurretunusable();
	turret setmode("manual");
	turret setturretteam("axis");
	turret setconvergencetime(1, "yaw");
	turret setconvergencetime(5, "pitch");

	heli_damage_trigger = getent( "heli_damage_trigger", "targetname" );
	heli_damage_trigger enablelinkto();
	heli_damage_trigger linkto( self, "left_door", (0,0,-16), (0,0,0) );
	heli_damage_trigger thread react_damage( self );

	default_target = spawn( "script_model", self gettagorigin( "left_door" ) );
	default_target linkto( self, "left_door", (0,300,-150), (0,0,0) );

	turret thread heli_minigun_firethread( default_target, self );
}

heli_minigun_firethread( default_target, helicopter )
{
	self endon( "stop_firing" );

	self.clear_to_fire = true;

	base_ammo = 30;
	ammo = base_ammo;

	while( true )
	{
		burst = randomintrange( 3, 7 );

		if ( !flag( "heli_small_arms_fire" ) || !self.clear_to_fire )
		{
			self settargetentity( default_target );
			ammo = base_ammo;
			flag_wait( "heli_small_arms_fire" );
		}

		self settargetentity( level.player );

		if ( !level.player sightConeTrace( helicopter gettagorigin( "tag_driver" ), helicopter ) )
		{
			wait 1;
			continue;
		}

		for ( i = 0; i < burst; i++ )
		{
			self shootturret();
			wait( 0.1 );
			ammo--;
		}

		if ( ammo < 0 )
		{
			ammo = base_ammo;
			self settargetentity( default_target );
			wait randomfloatrange( 2, 2.5 );
			self settargetentity( level.player );
		}
		else
			wait randomfloat( 0.5, 2 );
	}
}

react_damage( helicopter )
{
	helicopter endon( "death" );
	total_damage = 0;
	while ( true )
	{
		self waittill( "damage", damage, attacker );

		if ( attacker != level.player)
			continue;

		total_damage += damage;
		if ( total_damage > 350 )
		{
			helicopter.clear_to_fire = false;

			if ( helicopter getspeedmph() < 11 )
			{
				drop_corpse = 0;
				helicopter drop_corpse();
				wait 5;
			}
			wait 3;
			helicopter.clear_to_fire = true;
			total_damage = 0;
		}
	}
}

drop_corpse()
{
	fall_out_animation = %mi17_pilot_idle;

	spawner = getent( "ragdoll_guy", "targetname" );
	spawner.count = 1;
	ragdoll_guy = spawner dospawn();
	
	spawn_failed( ragdoll_guy );
	assert( isdefined( ragdoll_guy ) );

	// todo: make this not a ugly hack.
	// todo: use drone make drone function 
	ragdoll_guy dontInterpolate();
	ragdoll_guy hide();
	ragdoll_guy animscripted( "ragdoll_guy", self gettagorigin( "left_door" ), (0,0,-48), fall_out_animation );
	wait 0.1;
	ragdoll_guy stopanimscripted();
	wait 0.1;

	ragdoll_guy doDamage( ragdoll_guy.health + 100, (0,0,0) );
	ragdoll_guy show();
	ragdoll_guy startragdoll();
}

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
			// start moving again at twice the push dist.
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

follow_path( start_node )
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

		if ( node node_have_delay() )
			self.disableArrivals = false;
		else
			self disablearrivals_delayed();

		self waittill( "goal" );
		node notify( "trigger", self );

		if (!isdefined (node.target))
			return;

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

//	model = spawn( "script_model", self gettagorigin("tag_barrel") );
//	model setModel( "fx" );
//	model linkto (self.dlight);

	self thread helicopter_searchlight_dlight();

	wait 1;

	playfxontag (level._effect["spotlight_dlight"], self.dlight, "tag_origin");

}

helicopter_searchlight_dlight()
{
	self endon("death");

	while( true )
	{
		targetent = self helicopter_getturrettargetent();

		vector = anglestoforward( self gettagangles( "tag_barrel" ) );
		start = self gettagorigin( "tag_barrel" );
		end = self gettagorigin( "tag_barrel" ) + vector_multiply ( vector, 3000 );

		trace = bullettrace( start, end, false, self );
		dropspot = trace[ "position" ];
		dropspot = dropspot + vector_multiply ( vector, -96 );

		self.dlight moveto( dropspot, .5 );

//		thread drawline(start, end, (1,0,1) , 0.1 );
//		thread drawline(start, dropspot, (0,0,1) , 0.1 );

		wait .5;
	}
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

fly_path( path_struct )
{
	self notify("stop_path");
	self endon("stop_path");
	self endon("death");

	if ( !isdefined( path_struct ) )
		path_struct = getstruct( self.target, "targetname" );

	self setNearGoalNotifyDist(512);

	if ( !isdefined( path_struct.speed ) )
		self fly_path_set_speed( 30, true );

	while( true )
	{
		self fly_to( path_struct );

		if( !isdefined ( path_struct.target ) )
			break;
		path_struct = getstruct( path_struct.target, "targetname" );
		if ( !isdefined( path_struct ) )
			break;
	}
}

fly_to( path_struct )
{
	self endon("stop_path");
	self endon("death");

	self fly_path_set_speed( path_struct.speed );

	if ( isdefined( path_struct.script_noteworthy ) && path_struct.script_noteworthy == "small_arms_fire" )
		flag_set( "heli_small_arms_fire" );
	else
		flag_clear( "heli_small_arms_fire" );

	if ( isdefined( path_struct.script_noteworthy ) && path_struct.script_noteworthy == "spot_target" )
	{
		path_start = getent( path_struct.target, "targetname" );
		self thread spot_target_path( path_start );
	}

	if ( isdefined( path_struct.radius ) )
		self setNearGoalNotifyDist( path_struct.radius );
	else
		self setNearGoalNotifyDist(512);
		
//	if ( isdefined( path_struct.script_delay ) || isdefined( path_struct.script_delay_min ) )
//		stop = true;
	stop = path_struct node_have_delay();

	if ( isdefined( path_struct.script_unload ) )
	{
		stop = true;
		path_struct = self unload_struct_adjustment( path_struct );
		self thread unload_helicopter();
	}

	if ( isdefined( path_struct.angles ) )
	{
		if ( stop )
			self setgoalyaw( path_struct.angles[1] );
		else
			self settargetyaw( path_struct.angles[1] );
	}
	else
		self cleartargetyaw();

	self setvehgoalpos( path_struct.origin + (0, 0, self.originheightoffset), stop );

	self waittill_any ("near_goal","goal");
	path_struct notify( "trigger", self );

	flag_waitopen ( "helicopter_unloading" );	// wait if helicopter is unloading.

	if ( stop )
		path_struct script_delay();

	if ( isdefined( path_struct.script_flag ) )
		flag_wait( path_struct.script_flag );

	if ( isdefined(path_struct.script_noteworthy) && path_struct.script_noteworthy == "delete_helicopter" ) 
	{
		maps\_vehicle::delete_group( self );
	}
}

fly_path_set_speed( new_speed, immediate )
{
	if ( isdefined( new_speed ) )
	{
		accel = 20;
		if ( accel < new_speed / 2.5 )
			accel = ( new_speed / 2.5 );

		decel = accel;
		current_speed = self getspeedmph();
		if ( current_speed > accel )
			decel = current_speed;

		if ( isdefined( immediate ) )
			self setspeedimmediate( new_speed, accel, decel);
		else
			self setSpeed( new_speed, accel, decel);
	}
}

unload_helicopter()
{
	/*
	maps\_vehicle::waittill_stable();
	*/

	self endon("stop_path");
	self endon("death");

	flag_set ( "helicopter_unloading" );

	self sethoverparams( 0, 0, 0 );
	self waittill ("goal");
	self notify ( "unload", "both" );
	wait 12;	// todo: the time it takes to unload must exist somewhere.
	flag_clear ( "helicopter_unloading" );
	self sethoverparams(128, 10, 3);

}

unload_struct_adjustment( path_struct )
{
	ground = physicstrace( path_struct.origin, path_struct.origin + (0,0,-10000) );
	path_struct.origin = ground + (0,0,self.fastropeoffset);
//	path_struct.origin = ground + (0,0,self.fastropeoffset + self.originheightoffset );
	return path_struct;
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