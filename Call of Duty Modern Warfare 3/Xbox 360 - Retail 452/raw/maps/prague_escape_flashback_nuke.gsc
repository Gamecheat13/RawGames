#include maps\_hud_util;
#include maps\_utility;
#include common_scripts\utility;
#include maps\_anim;
#include maps\_vehicle;
#include maps\prague_escape_code;
#include maps\_shg_common;
#include maps\_utility_chetan;

// Start Functions	/////////////////////////////////////////////////////////////////////////////////////
start_flashback_nuke()
{
	move_player_to_start( "flashback_nuke_player" );
	
	level.player vision_set_fog_changes( "prague_escape_airlift", 0 );
	
	flag_set( "start_nuke_scene" );	
	
	//hide hud
	maps\prague_escape_code::hide_player_hud();	

	level.flashback_overlay = NewClientHudElem( level.player );
	level.flashback_overlay.horzAlign = "fullscreen";
	level.flashback_overlay.vertAlign = "fullscreen";
	level.flashback_overlay SetShader( "overlay_flashback_blur", 640, 480 );
	level.flashback_overlay.archive = true;
	level.flashback_overlay.sort = 10;
	
	battlechatter_off();	
	
	maps\prague_escape_sniper::prague_escape_skippast_cleanup();
}

init_nuke_level_flags()
{
	flag_init( "FLAG_nuke_player_is_upstairs" );
	flag_init( "FLAG_nuke_makarov_take_phone" );
	
	flag_init( "nuke_explosion_done" );
	flag_init( "nuke_explosion_start" );
	flag_init( "change_grass_speed" );
	
	flag_init( "kill_nuke_earthquake" );
	
	flag_init( "spawn_helicopter_1" );		
	
	flag_init( "player_nuke_headlook" );
}

// Main Functions	/////////////////////////////////////////////////////////////////////////////////////
flashback_nuke_main()
{
	thread set_ambient( "prague_flashback_airlift" );
	level.player FreezeControls( true );
		
	level.player UnLink();
	level.player FreezeControls( false );
	level.player player_speed_percent( 30 );
	level.player AllowCrouch( false );
	level.player AllowProne( false );
	level.player AllowSprint( false );
	level.player AllowJump( false );
	
	move_player_to_start( "flashback_nuke_player" );
	
	level.player shellshock( "prague_escape_flashback", 15 );
	
	setup_makarov();

	wait 0.05; //needs a frame to get all the above done.
		
	thread nuke_scene();
	
	flag_wait( "nuke_explosion_done" );
}

setup_makarov()
{
	spawner 						= GetEnt( "ai_makarov_nuke", "targetname" );
	level.makarov_nuke 				= spawner spawn_ai( true );
	level.makarov_nuke.animname 	= "makarov";
	level.makarov_nuke.ignoreme 	= true;
	level.makarov_nuke.ignoreall	= true;
	level.makarov_nuke SetCanDamage( false );
}

nuke_scene()
{
	thread nuke_intro_screen();
	thread nuke_explosion();
	thread heli_fly_by();
	thread animated_foliage();

	align_to_bunker = getstruct( "anim_align_bunker", "targetname" );
	
	align_to_bunker anim_first_frame( [ level.makarov_nuke ], "shock_and_awe" );
	
	exploder( 1401 ); //all of the smoke columns.
	exploder( 1403 ); //oil field fires.
	
	flag_wait( "start_nuke_scene" );

	//thread autosave_by_name_silent( "flashback_nuke" );	
	maps\_autosave::_autosave_game_now_nochecks(); // no gun, no ammo.  Force the save

	exploder( 1402 ); //the AA tracers.
	exploder( 1404 ); //small fires near the player. 
	
//	level	thread maps\_utility::set_ambient("prague_flashback_airlift");
	
	shock_and_awe_length 	= GetAnimLength( level.makarov_nuke getanim( "shock_and_awe" ) );
	align_to_bunker thread anim_single( [ level.makarov_nuke ], "shock_and_awe" );
	
	wait 2.5;
	
	flag_set( "spawn_helicopter_1" );
	
	thread check_player_is_upstairs();
	
	wait 6.75;
	
	wait gt_op( shock_and_awe_length - 9.25, 0 );
	
	align_to_bunker thread anim_loop_solo( level.makarov_nuke, "idle" );
	
	timeout = 30.0;
	flag_wait_or_timeout( "FLAG_nuke_player_is_upstairs", timeout );
	flag_set( "FLAG_nuke_player_is_upstairs" );
	align_to_bunker notify_delay( "stop_loop", 0.05 );
	
	
	origin 		= level.makarov_nuke GetTagOrigin( "tag_inhand" );
	/*
	up			= -3 * AnglesToUp( origin );
	fwd			= -2 * AnglesToForward( origin );
	right		= -1.15 * AnglesToRight( origin );
	*/
	cellphone 	= Spawn( "script_model", origin );
	cellphone SetModel( "hjk_cell_phone_on" );
	//cellphone.angles = level.makarov_nuke GetTagAngles( "j_wrist_ri" );
	//cellphone LinkTo( level.makarov_nuke, "j_wrist_ri", up + fwd + right, ( 0, 0, 0 ) );
	cellphone LinkTo( level.makarov_nuke, "tag_inhand", ( 0, 0, 0 ), ( 0, 0, 0 ) );
	cellphone Hide();
	
	align_to_bunker thread anim_single_solo( level.makarov_nuke, "phonecall" );
	cellphone thread nuke_unhide_phone();

	wait 7.8;
	
	// Yuri: Thousands of souls extinguished by the push of a button.
	// **TODO: make notetrack
	tag = level.player spawn_tag_origin();
	tag PlaySound( "presc_yri_itwasmadness" );
	
	// Nuke sounds
	level.player delayThread( 3.0, ::play_sound_on_entity, "prague_escape_nuke_incoming" );
	level.player delayThread( 6.0, ::play_sound_on_entity, "prague_escape_nuke_explosion_dist_sub" );
	level.player delayThread( 7.0, ::play_sound_on_entity, "prague_escape_nuke_wave" );
	
	wait 2.2;
	
	cellphone Delete();
	align_to_bunker thread anim_loop_solo( level.makarov_nuke, "idle" );
	
	wait 2.0;
	
	align_to_bunker thread anim_single_solo( level.makarov_nuke, "blast" );
	align_to_bunker notify_delay( "stop_loop", 0.05 );
	
	white_overlay = create_client_overlay( "white", 1, level.player );
	
	stop_exploder( 1401 ); // all of the smoke columns.
	stop_exploder( 1403 ); // oil field fires.
	stop_exploder( 1402 ); // the AA tracers.
	
	thread nuke_player_lookat();

	wait 0.05;
	white_overlay Destroy();
	flag_set( "nuke_explosion_start" );
	
	wait 6.0;
	
	// Make Makarov look at the player
	level.makarov_nuke thread lookat_player( 60, 60, 2.0 );
	
	wait 6.0;
	
	// Yuri: Thousands of souls extinguished by the push of a button.  This wasn't war - it was madness.
	level.player thread play_sound_on_entity( "presc_yri_itwasmadness2" );
	
	flag_wait( "nuke_explosion_done" );
	
	wait 1.0;
	
	level.makarov_nuke Delete();
	tag Delete();
}

nuke_unhide_phone()
{
	flag_wait( "FLAG_nuke_makarov_take_phone" );
	self Show();
}

check_player_is_upstairs()
{
	trigger = GetEnt( "nuke_player_is_upstairs_trigger", "targetname" );
	Assert( IsDefined( trigger ) );
	
	for ( ; !flag( "nuke_explosion_done" ); wait 0.05 )
	{
		if ( level.player IsTouching( trigger ) )
			flag_set( "FLAG_nuke_player_is_upstairs" );
		else
			flag_clear( "FLAG_nuke_player_is_upstairs" );
	}
	trigger Delete();
}

nuke_player_lookat()
{
	if ( !flag( "FLAG_nuke_player_is_upstairs" ) )
		return;
	
	player_rig 			= spawn_anim_model( "player_rig_nuke", level.player.origin );
	player_rig.angles 	= level.player GetPlayerAngles();
	player_rig.animname = "player_rig";
	player_rig DontCastShadows();
	player_rig Hide();

	tag = player_rig spawn_tag_origin();
	level.player PlayerLinkToDelta( tag, "tag_origin", 1, 0, 0, 0, 10, true );
	
	focus 	= getstruct_delete( "player_nuke_focus", "targetname" );
	origin 	= ( focus.origin[ 0 ], focus.origin[ 1 ], level.player GetEye()[ 2 ] );
	time 	= 0.5;
	
	player_rig RotateTo( VectorToAngles( origin - level.player GetEye() ), time, time * 0.5, time * 0.5 );
	tag RotateTo( VectorToAngles( origin - level.player GetEye() ), time, time * 0.5, time * 0.5 );
	
	wait time;
	
	player_rig SetAnim( level.scr_anim[ "player_rig" ][ "shock_and_awe" ], 1.0, 0.05, 2.5 );
	
	wait 0.05;
	
	length = GetAnimLength( level.scr_anim[ "player_rig" ][ "shock_and_awe" ] );
	player_rig SetAnimTime( level.scr_anim[ "player_rig" ][ "shock_and_awe" ], 22.5 / length );
	player_rig CastShadows();
	player_rig Show();
	
	lerp_time = 0.75;
	level.player PlayerLinkToBlend( player_rig, "tag_player", lerp_time, lerp_time * 0.5, lerp_time * 0.5 );
	wait lerp_time;
	level.player PlayerLinkToDelta( player_rig, "tag_player", 1, 0, 0, 0, 10, true );
	
	wait 3.0 - lerp_time;
	
	player_rig Delete();
	tag Delete();
}

nuke_intro_screen()
{
	flag_wait( "spawn_helicopter_1" );
	
	wait( 3 );

	e_nuke_stream_ent = GetEnt( "nuke_stream_ent", "targetname" );
	e_nuke_stream_ent Delete();
	
	lines = [];
	// 18:20:[{FAKE_INTRO_SECONDS:11}]
	lines[ lines.size ] 	 = &"PRAGUE_ESCAPE_INTRO_NUKE_1";
	// Al-Asad's Safehouse - 2011
	lines[ lines.size ]		 = &"PRAGUE_ESCAPE_INTRO_NUKE_2";
	// Middle East
	lines[ lines.size ] 	 = &"PRAGUE_ESCAPE_INTRO_NUKE_3";
	
	maps\_introscreen::introscreen_feed_lines( lines );
}

nuke_explosion()
{
	flag_wait( "nuke_explosion_start" );

//	level.player PlayLocalSound( "airlift_nuke_impact" );
//	level.player PlayLocalSound( "airlift_nuke" );
	
	exploder( 666 );
	level.player thread set_vision_set_player( "prague_escape_nuke_flash", 0.25 );
	
	flag_set( "change_grass_speed" );
	
	thread nuke_background_explosions();
	level thread nuke_sunlight_and_fog();
	level thread nuke_rumble();
	level thread nuke_shockwave_blur();
	level thread nuke_earthquake();
	level thread nuke_transition_timer();
	level thread nuke_tree_sway();	

	level.player delaythread( 1, ::set_vision_set_player, "prague_escape_nuke_explosion", 4 );

	e_airport_stream_ent = GetEnt( "e_airport_stream_ent", "targetname" );		
	level.player PlayerSetStreamOrigin( e_airport_stream_ent.origin );
}

nuke_background_explosions()
{
	spots = getstructarray( "nuke_ambient_explosion", "targetname" );
	spots = array_index_by_script_index( spots );
	
	line_1 = add_to_array( get_connected_ents( spots[ 1 ].target ), spots[ 1 ] );
	line_2 = add_to_array( get_connected_ents( spots[ 2 ].target ), spots[ 2 ] );
	line_3 = add_to_array( get_connected_ents( spots[ 3 ].target ), spots[ 3 ] );
	
	wait 4.0;
	thread nuke_background_explosions_line( line_1, 1.0 );
	wait 1.0;
	thread nuke_background_explosions_line( line_2, 1.25 );
	wait 0.5;
	thread nuke_background_explosions_line( line_3, 1.5 );
}

nuke_background_explosions_line( spots, interval )
{
	Assert( IsDefined( spots ) );
	
	interval 	= gt_op( interval, 0.05 );
	fx			= getfx( "FX_nuke_background_explosion" );
	
	foreach ( spot in spots )
	{
		PlayFX( fx, spot.origin, ( 0, 0, 1 ) );
		wait interval;
	}
}

nuke_tree_sway()
{
	wait( 4.5 );
	
	//trees - furthest to closest
	e_nuke_tree_01 = GetEnt( "nuke_trees_01", "targetname" ); //short bushy tree
	e_nuke_tree_02 = GetEnt( "nuke_trees_02", "targetname" ); //short bushy tree
	e_nuke_tree_03 = GetEnt( "nuke_trees_03", "targetname" ); //short bushy tree
	e_nuke_tree_04 = GetEnt( "nuke_trees_04", "targetname" ); //short bushy tree
	e_nuke_tree_05 = GetEnt( "nuke_trees_05", "targetname" ); //short bushy tree
	e_nuke_tree_06 = GetEnt( "nuke_trees_06", "targetname" ); //short bushy tree
	e_nuke_tree_07 = GetEnt( "nuke_trees_07", "targetname" ); //short bushy tree
	e_nuke_tree_08 = GetEnt( "nuke_trees_08", "targetname" ); //tall skinny tree
	e_nuke_tree_09 = GetEnt( "nuke_trees_09", "targetname" ); //tall skinny tree
	e_nuke_tree_10 = GetEnt( "nuke_trees_10", "targetname" ); //tall skinny tree
	e_nuke_tree_11 = GetEnt( "nuke_trees_11", "targetname" ); //short bushy tree
	e_nuke_tree_12 = GetEnt( "nuke_trees_12", "targetname" ); //tall skinny tree
	e_nuke_tree_13 = GetEnt( "nuke_trees_13", "targetname" ); //short bushy tree
	e_nuke_tree_14 = GetEnt( "nuke_trees_14", "targetname" ); //short bushy tree
	e_nuke_tree_15 = GetEnt( "nuke_trees_15", "targetname" ); //tall skinny tree
	
	e_nuke_tree_01 thread start_tree_sway_anim( "bushy_palm_tree", "bushy_palm_tree_sway" );
	e_nuke_tree_02 thread start_tree_sway_anim( "bushy_palm_tree", "bushy_palm_tree_sway" );
	wait( 0.15 );
	e_nuke_tree_03 thread start_tree_sway_anim( "bushy_palm_tree", "bushy_palm_tree_sway" );
	e_nuke_tree_04 thread start_tree_sway_anim( "bushy_palm_tree", "bushy_palm_tree_sway" );
	wait( 0.15 );
	e_nuke_tree_05 thread start_tree_sway_anim( "bushy_palm_tree", "bushy_palm_tree_sway" );
	e_nuke_tree_06 thread start_tree_sway_anim( "bushy_palm_tree", "bushy_palm_tree_sway" );
	wait( 0.10 );	
	e_nuke_tree_07 thread start_tree_sway_anim( "bushy_palm_tree", "bushy_palm_tree_sway" );
	e_nuke_tree_08 thread start_tree_sway_anim( "tall_palm_tree", "tall_palm_tree_sway" );
	wait( 0.10 );	
	e_nuke_tree_09 thread start_tree_sway_anim( "tall_palm_tree", "tall_palm_tree_sway" );
	e_nuke_tree_10 thread start_tree_sway_anim( "tall_palm_tree", "tall_palm_tree_sway" );
	wait( 0.10 );	
	e_nuke_tree_11 thread start_tree_sway_anim( "bushy_palm_tree", "bushy_palm_tree_sway" );
	wait( 0.10 );
	e_nuke_tree_12 thread start_tree_sway_anim( "tall_palm_tree", "tall_palm_tree_sway" );
	wait( 0.08 );
	e_nuke_tree_13 thread start_tree_sway_anim( "bushy_palm_tree", "bushy_palm_tree_sway" );
	wait( 0.08 );
	e_nuke_tree_14 thread start_tree_sway_anim( "bushy_palm_tree", "bushy_palm_tree_sway" );
	e_nuke_tree_15 thread start_tree_sway_anim( "tall_palm_tree", "tall_palm_tree_sway" );
}

start_tree_sway_anim( animname, name_of_animation )
{
	self.animname = animname;
	self UseAnimTree( level.scr_animtree[ self.animname ] );
	self thread anim_single_solo( self, name_of_animation );	
}

nuke_rumble()
{
	wait 1;
	
	level.player PlayRumbleOnEntity( "grenade_rumble" );

	wait 1;

	//stop_exploder( 1401 ); //all of the smoke columns.
	//stop_exploder( 1403 ); //oil field fires.
	//stop_exploder( 1402 ); //the AA tracers.
	
	level.player PlayRumbleLoopOnEntity( "tank_rumble" );
	
	wait 3.25;

	level.player StopRumble( "tank_rumble" );
	level.player PlayRumbleOnEntity( "grenade_rumble" );
			
	n_time = GetTime() + ( 5 * 125 );
	while ( GetTime() < n_time )
	{
		level.player PlayRumbleOnEntity( "light_1s" );
		wait .05;
	}	
	
	n_time = GetTime() + ( 5 * 20 );
	while ( GetTime() < n_time )
	{
		level.player PlayRumbleOnEntity( "grenade_rumble" );
		wait .05;
	}		
}

nuke_earthquake()
{
	Earthquake( .15, 0.5, level.player.origin, 512 );	
	
	wait( 1 );
	
	time = GetTime() + ( 5 * 850 );
	while ( GetTime() < time )
	{
		Earthquake( .15, .05, level.player.origin, 512 );
		wait .05;
	}
	
	Earthquake( .3, 2.0, level.player.origin, 512 );
	wait 1;
	Earthquake( .15, 0.5, level.player.origin, 512 );		
}

nuke_transition_timer()
{
	wait 11.0;
	level.player player_speed_default();
	level.player PlaySound( "scn_prague_flash_airport" );
	flashback_teleport( "nuke_explosion_done", "start_betray_me_scene", "prague_escape_airport", 3, 0.05 );		
}

nuke_sunlight_and_fog()
{
	SetExpFog( 0, 17000, 0.678352, 0.498765, 0.372533, 1, 0.5 );
		
	level.defaultSun = GetMapSunLight();
	level.nukeSun = ( 3.11, 2.05, 1.67 );
	sun_light_fade( level.defaultSun, level.nukeSun, 2 );
	wait 2;
	level thread sun_light_fade( level.nukeSun, level.defaultSun, 2 );
}

nuke_shockwave_blur()
{
	Earthquake( 0.3, .5, level.player.origin, 80000 );
	SetBlur( 3, .1 );
	wait 1;
	SetBlur( 0, .5 );
}

heli_fly_by()
{
	flag_wait( "start_nuke_scene" );

	trig_ground_vehicles = GetEnt( "trig_ground_vehicles", "targetname" );
	trig_ground_vehicles notify( "trigger" );

	flag_wait( "spawn_helicopter_1" );
	
	intro_helis = spawn_vehicles_from_targetname_and_drive( "intro_helis" );
	array_thread( intro_helis, ::intro_heli_think );

	foreach ( heli in intro_helis )
		PlayFXOnTag( getfx( "cobra_treadfx" ), heli, "tag_origin" );	
	
	flag_wait( "FLAG_nuke_makarov_take_phone" );
		
	//Original MW1 Choppers
	//chinook = spawn_vehicle_from_targetname_and_drive( "mw_chinook" );	
	//chinook thread chinook_flight_path();
			
	nuke_helis = spawn_vehicles_from_targetname_and_drive( "nuke_helis" );
	array_thread( nuke_helis, ::nuke_choppers_think );	
}

chinook_flight_path()
{
	self endon( "death" );

	self thread seaknight_open_doors();
	
	//start flight settings
	speed = RandomIntRange( 125, 155 );
	
	self Vehicle_SetSpeed( speed );
	self ClearGoalYaw();
	self SetMaxPitchRoll( 25, 50 );
	self SetAirResistance( 1 );
	self SetAcceleration( 50 );	
	self SetHoverParams( 35, 15, 10 );

	//self thread poor_bastard();
	
	flag_wait( "nuke_explosion_start" );
	
	wait 3;

	self.yawspeed = 400;
	self.yawaccel = 100;
		
	self thread nuke_seaknight_spin();		
//	self thread poor_bastard();
	
	heli_crash_spot = getstruct_delete( "mw_chinook_crashspot", "targetname" );
	self SetVehGoalPos( heli_crash_spot.origin, false );	
}

poor_bastard()
{
	wait 10;
	//setup guy who gets sucked out
	spawner 				= GetEnt( "poor_bastard", "targetname" );
	poor_bastard 			= spawner spawn_ai( true );
	poor_bastard.animname 	= "poor_bastard";
	poor_bastard.ignoreme 	= true;
	poor_bastard.ignoreall 	= true;
	
	poor_bastard LinkTo( self );	
	self anim_single_solo( poor_bastard, "crewchief_sucked_out", "tag_detach" );
	poor_bastard.allowdeath = true;
//	level.poor_bastard SetCanDamage( true );
	poor_bastard Die();
}

#using_animtree( "vehicles" );
seaknight_open_doors()
{
	self UseAnimTree( #animtree );
	//self SetAnimKnobRestart( %ch46_doors_open, 1, 0, 1 );
}

intro_heli_think()
{
	self endon( "death" );

	self SetNearGoalNotifyDist( 10000 );	
	self SetMaxPitchRoll( 30, 30 );
	self SetHoverParams( 35, 15, 10 );
	
	//self waittill( "reached_end_node" );

	flag_wait( "nuke_explosion_start" );
	
	wait 3;
	
	self Delete();
}

nuke_choppers_think()
{
	self endon( "death" );
	self notify( "stop_default_behavior" );
	
	//start flight settings
	speed = RandomIntRange( 155, 175 );
	
	self Vehicle_SetSpeed( speed );
	self ClearGoalYaw();
	
	pitch = RandomIntRange( 20, 30 );
	roll = RandomIntRange( 40, 50 );

	self SetMaxPitchRoll( pitch, roll );
	self SetAirResistance( 1 );
	self SetAcceleration( 50 );	
	self SetHoverParams(  RandomIntRange( 20, 30 ),  RandomIntRange( 10, 15 ),  RandomIntRange( 7, 12 ) );
		
	flag_wait( "nuke_explosion_start" );
	
	wait( RandomFloatRange( 3.5, 5 ) );
	
	is_close_cobra = false;
	if ( ( IsDefined( self.targetname ) ) && ( self.targetname == "near_left_cobra" ) )
		is_close_cobra = true;

	self thread nuke_chopper_spin_and_fx( is_close_cobra );

	heli_crash_spot = undefined;
	
	switch( self.script_noteworthy )  
	{
		case "second_chinook":
			heli_crash_spot = getstruct( "second_chinook_crashspot", "targetname" );
			break;
		case "middle_cobra":
			heli_crash_spot = getstruct( "middle_cobra_crashspot", "targetname" );
			break;											
		case "near_left_cobra":
			heli_crash_spot = getstruct( "near_left_crashspot", "targetname" );
			break;			
		case "far_left_cobra":
			heli_crash_spot = getstruct( "far_left_crashspot", "targetname" );
			break;						
		case "near_right_cobra":
			heli_crash_spot = getstruct( "near_right_crashspot", "targetname" );
			break;
		case "far_right_cobra":
			heli_crash_spot = getstruct( "far_right_crashspot", "targetname" ); 
			break;
	}
		
	self SetVehGoalPos( heli_crash_spot.origin, false );	
	
	wait( 10 );

	self notify( "stop spin" );
	PlayFXOnTag( getfx( "nuked_chopper_explosion" ), self, "tag_origin");

	self Delete();
}

nuke_chopper_spin_and_fx( is_close_cobra )
{
	self endon( "death" );
	self endon( "stop spin" );
	
	self SetMaxPitchRoll( 100, 200 );
	self SetTurningAbility( 1 );
	
	yawspeed = 1400;
	yawaccel = 200;
	
	targetyaw = undefined;
	spinLeft = undefined;
	
	if ( RandomInt( 100 ) > 50 )
	{
		spinLeft = true;
	}

	if ( ( IsDefined( is_close_cobra ) ) && ( is_close_cobra == true ) )
	{
		PlayFXOnTag( getfx( "heli_aerial_explosion_large" ), self, "tag_engine_left" );
	}
	else
	{
		//custom fx for default choppers instead of looping
		PlayFXOnTag( getfx( "nuked_chopper_explosion" ), self, "tag_engine_left" );
	}
				
	while ( IsDefined( self ) )
	{
		if ( IsDefined( spinLeft ) )
		{
			targetyaw = self.angles[ 1 ] + RandomIntRange(80, 150);
		}
		else
		{
			targetyaw = self.angles[ 1 ] - RandomIntRange(80, 150);
		}
		
		self SetYawSpeed( yawspeed, yawaccel );
		self SetTargetYaw( targetyaw );
		
		if ( ( IsDefined( is_close_cobra ) ) && ( is_close_cobra == true ) )
		{
			PlayFXOnTag( getfx( "chopper_smoke_trail" ), self, "tag_engine_left" );
		}
		else
			PlayFXOnTag( getfx( "chopper_smoke_trail" ), self, "tag_engine_left" );
		wait 0.1;
	}
}

nuke_seaknight_spin()
{
	self endon( "stop_rotate" );
	
	self SetTurningAbility( 1 );	
	self Vehicle_SetSpeed( 20 );
	
	while ( IsDefined( self ) )
	{
		self SetYawSpeed( self.yawspeed, self.yawaccel );
		self SetTargetYaw( self.angles[ 1 ] + 150 );
		wait 0.1;
	}
}

animated_foliage()
{
	moving_grass = GetEntArray( "nuke_grass", "targetname" );

	//SLOW MOVING GRASS
	foreach( grass_patch in moving_grass )
	{
		grass_patch thread start_anim_on_object( "slow_grass", "slow_anim_grass", RandomFloatRange( 0.0, 2 ) );
	}	
	
	flag_wait( "change_grass_speed" );

	//FAST MOVING GRASS
	foreach( grass_patch in moving_grass )
	{
		grass_patch notify("stop_animating");
		grass_patch thread start_anim_on_object( "fast_grass", "fast_anim_grass", RandomFloatRange( 0.0, 1 ) );
	}	
	
	flag_wait( "nuke_explosion_done" );
	
	foreach( grass_patch in moving_grass )
	{
		//grass_patch notify("stop_animating");
		//grass_patch Delete();
	}		
}

// self = model
start_anim_on_object( animname, name_of_animation, delay)
{
	self endon( "stop_animating" );
	
	if ( IsDefined(delay) )
	{
		wait( delay );
	}
	self.animname = animname;
	self UseAnimTree( level.scr_animtree[ self.animname ] );
	self thread anim_loop_solo(self, name_of_animation, "stop_animating");
}