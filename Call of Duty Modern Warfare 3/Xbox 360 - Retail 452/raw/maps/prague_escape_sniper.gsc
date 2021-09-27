#include maps\_utility;
#include common_scripts\utility;
#include maps\_anim;
#include maps\_vehicle;
#include maps\_shg_common;
#include maps\prague_escape_code;

// Start Functions	/////////////////////////////////////////////////////////////////////////////////////
start_sniper()
{
	setup_hero_for_start( "soap", "sniper" );
	setup_hero_for_start( "price", "sniper" );
	
	move_player_to_start( "start_sniper" );
}

// Main Functions	/////////////////////////////////////////////////////////////////////////////////////
sniper_main()
{		
	level endon( "sniper_cover_blown" );
	
	/#
	iprintln( "sniper" );
	#/
	maps\_autosave::_autosave_game_now_nochecks(); // no gun, no ammo.  Force the save
	maps\_compass::setupMiniMap( "compass_map_prague_escape_sniper", "sniper_minimap_corner" );
 	setup_event();
 	soap_radio_lines();
	bell_tower_intro();
	level thread pigeons();
	level childthread player_get_on_sniper_rifle();
	level childthread convoy_arrives();
	flag_wait( "start_look_at_price" ); // set by notetrack
	price_rappel_start();
	balcony_snipe();
	price_window_breach();
	its_a_trap();
	hotel_explodes();
	prague_escape_sniper_cleanup();
}

//---------------------------------------------------------
// Pigeon Section
//---------------------------------------------------------

pigeons()
{
//	pigeons = GetEntArray( "pigeon", "targetname" );
//	pigeons = array_randomize( pigeons );
	level.pigeons = [];
	
	//nodes = GetVehicleNodeArray( "pigeon_node", "targetname" );
	nodes = getstructarray( "pigeon" , "targetname" );
	foreach ( node in nodes )
	{
		pigeon = Spawn( "script_model", node.origin );
		pigeon.angles = node.angles;
		pigeon SetModel( "pigeon_iw5" );
		pigeon.node = node;

		level.pigeons[ level.pigeons.size ] = pigeon;

		pigeon thread pigeon_thread();
	}
	level thread delete_pigeons();

}

pigeon_thread()
{
	level endon("balcony_player_fired");
	wait( RandomFloat( 0.5 ) );

	struct = SpawnStruct();
	struct.origin = self.node.origin;
	struct.angles = self.node.angles;

	self.animname = "pigeon";
	self setanimtree();
	self.struct = struct;
	self setcandamage( true );

	struct thread anim_loop_solo( self, "idle" );
	
	self waittill( "damage" );
	playfx( getfx( "pigeon_gibs" ), self.origin + (0,0,5) );
	level.pigeons = array_remove( level.pigeons, self );
	self delete();
}

pigeon_fly()
{
	self.struct notify( "stop_loop" );
	self anim_stopanimscripted();

	level.pigeons = array_remove( level.pigeons, self );

	v_spawner = GetEnt( "bird_vehicle", "targetname" );

	while ( IsDefined( v_spawner.vehicle_spawned_thisframe ) )
	{
		wait( 0.05 );
	}

	vehicle = vehicle_spawn( v_spawner );
//	vehicle SetModel( "tag_origin" );
	vehicle.is_pigeon = true;

//	van Vehicle_Teleport( node.origin, node.angles );
	vehicle.attachedpath = self.node;
	vehicle AttachPath( self.node );
	vehicle StartPath();

	self thread pigeon_fly_loop();
	self LinkTo( vehicle, "" );

	vehicle thread vehicle_paths( self.node );

	vehicle.script_vehicle_selfremove = true;
	vehicle waittill( "death" );

	self Delete();
}

pigeon_fly_loop()
{
	self endon( "death" );
	
	self SetModel( "pigeon_fly_iw5" );
	animation = self getanim( "flying" );

	rate = 1;
	dec = 0.1;
	delay = 0.5;
	for ( i = 0; i < 5; i++ )
	{
		self ClearAnim( animation, 0.5 );
		self SetAnimRestart( animation, 1, 0.5, rate );
		wait( delay );

		rate -= dec;
	}
}

delete_pigeons()
{
	flag_wait("scaffold_use_limp_a");
	foreach ( pigeon in level.pigeons )
	{
		pigeon Delete();
	}
}

soap_radio_lines()
{
	//Sandman: He's down.
	//level.scr_radio[ "prague_killfirm_other_1" ]	= "presc_mct_hesdown";	
	//Sandman: Target down.
	level.scr_radio[ "prague_killfirm_other_2" ]	= "prague_escape_soap_targetdown";		
	//Sandman: Got 'em.
	level.scr_radio[ "prague_killfirm_other_3" ]	= "prague_escape_soap_gotem";	
	//Sandman: That's a kill.
	//level.scr_radio[ "prague_killfirm_other_4" ]	= "presc_mct_thatsakill";	
	//what are you doing?
	level.scr_radio[ "prague_escape_fail_yuridoin" ]	= "prague_escape_fail_yuridoin";
	//what the hell?
	level.scr_radio[ "prague_escape_fail_whatthehell" ]	= "prague_escape_fail_whatthehell";
	
	//Price nag
	//Whats taking so long Yuri?
	level.scr_radio[ "presc_pri_whatstaking" ]	= "presc_pri_whatstaking";

	
}	

init_event_flags()
{
	flag_init( "sniper_cover_blown" );
	
	flag_init( "prague_escape_sniper_complete" );
	flag_init( "start_convoy" );
	flag_init( "convoy_stopped" );
	flag_init( "convoy_arrives_start_makarov" );
	flag_init( "player_used_zoom" );
	flag_init( "makarov_exits_suv" );
	flag_init( "makarov_inside" ); 
	flag_init( "door_guards_inside" );
	flag_init( "player_looked_at_price" );
	flag_init( "balcony_ai_spawned" );
	flag_init( "balcony_player_fired" );
	flag_init( "breach_ai_spawned" );
	flag_init( "breach_complete" );
	flag_init( "price_discover_kamarov_open_doors" );
	
	flag_init( "door_guards_start" );
	flag_init( "door_guards_open_door" );
	flag_init( "door_guards_close_door" );
	
	flag_init( "belltower_intro_dialogue_02" );
	flag_init( "belltower_intro_fade_out" );
	
	flag_init( "start_look_at_price" );
	
	flag_init( "queue_sniper_music" );
}



setup_event()
{
	battlechatter_off( "allies" );
	battlechatter_off( "axis" );
	
	s_align = getstruct( "anim_align_hotel_top", "targetname" );
	s_align anim_first_frame_solo( level.price, "rappel_hook_up_reveal" );
	
	s_align = getstruct( "anim_align_hotel_front", "targetname" );
	s_align thread convoy_arrives_vehicles();
	s_align thread convoy_arrives_escort_guards();	
	
	e_rifle = getent( "bell_tower_sniper_rifle", "targetname" );
	e_rifle hide();
	
	SetSavedDvar( "actionSlotsHide", "1" );
	//setsaveddvar( "compass", "0" );
	SetSavedDvar( "ammoCounterHide", "1" );
	setsaveddvar( "ui_hideMap", "1" );
	SetSavedDvar( "hud_showStance", "1" );	
	SetSavedDvar( "cg_drawCrosshair", "0" );
	
	temp_sniper_nag_lines();
	
	hotel_flank_spawners = GetEntArray( "soap_dont_shoot", "targetname" );
	array_thread( hotel_flank_spawners, ::hotel_flank_guys_think );
	
	m_tower = getent( "fxanim_prague2_bell_tower_mod", "targetname" );
	m_tower Hide();
	
	level.player allowCrouch( false );
	level.player allowProne( false );	
	
	level.n_time_to_clear_breach = 11;//15
	
	level.price place_weapon_on( "m4m203_reflex", "back" );
	level.price forceUseWeapon( "m4m203_reflex", "primary" );		
	
	level thread hotel_curtain_idle();
	
	a_balcony_spawners = GetEntArray( "hotel_balcony_first_guard", "targetname" );	
	a_balcony_guards = [];
	for( i = 0; i < a_balcony_spawners.size; i++ )
	{
		a_balcony_guards[i] = a_balcony_spawners[i] spawn_ai( true );
		a_balcony_guards[i].animname = "generic";
		a_balcony_guards[i] thread smoking_idle();
	}
	
	level thread convoy_arrives_intro_patrollers();
	
	level.sniper_player_failed = false;
}

convoy_spawnfunc()
{
	self.script_noteworthy = "sniper_convoy_vehicle";
}

bell_tower_intro()
{	
//	SetSavedDvar( "r_znear", 0.001 );
	level thread intro_dof_logic();
	//level.player lerpfov(65, .05);	
	s_align = getstruct( "anim_align_belltower", "targetname" );
	                             
	m_player_rig = spawn_anim_model( "player_rig", level.player.origin );
	m_player_rig.angles = level.player GetPlayerAngles();
	m_sniper_model = spawn_anim_model( "player_rifle", m_player_rig GetTagOrigin( "tag_weapon" ) );
	m_sniper_model.angles = m_player_rig GetTagAngles( "tag_weapon" );
	m_sniper_model hidepart( "TAG_MOTION_TRACKER", "viewmodel_rsass_sp_iw5" );
	m_sniper_model hidepart( "TAG_SILENCER", "viewmodel_rsass_sp_iw5" );
	
	level.player FreezeControls( true );
	level.player PlayerLinkToDelta( m_player_rig, "tag_player", 1, 10, 10, 10, 1, true );
	
	//gun, soap, player rig
	a_anim_ents = make_array( level.soap, m_player_rig, m_sniper_model );
	
	//new array of just gun and player
	a_gun_hands = make_array( m_player_rig, m_sniper_model );
	
	//m_player_rig attach( "viewmodel_rsass_sp_iw5" );
	s_align anim_first_frame( a_anim_ents, "belltower_intro" );
	level waittill( "introscreen_complete" );
	
	flag_set( "queue_sniper_music" );
	flag_wait("introscreen_complete");
	n_lerp_time = .25;
	
	s_align thread bell_tower_intro_soap();
	
	s_align thread anim_single( a_gun_hands, "belltower_intro" );
		
	flag_wait( "belltower_intro_fade_out" );	// set by notetrack
	level.player LerpFOV( 20, 1);
	n_fade_time = .5;
	set_screen_fade_timer( n_fade_time );
	level thread screen_fade_out();
	wait( n_fade_time * 2 );
	
	level.player Unlink();
	m_player_rig Delete();	
	
	//start the convoy guard idle animation a second earlier in order to have 0 skip.	
	e_turret = getent( "bell_tower_sniper_rifle", "targetname" );
	e_turret UseBy( level.player );
	
	m_sniper_model Delete();
	
	s_align notify( "stop_loop" );
	
	vision_set_fog_changes("prague_escape_sniper", .10 );

//	SetSavedDvar( "r_znear", 4 );	
	SetSavedDvar( "sm_sunsamplesizenear", .25 );
	SetSavedDvar( "sv_znear", "100" );
	//setsaveddvar( "sm_cameraoffset", "7035" );
	level thread dyn_shadow_adjust();
	
	level thread screen_fade_in();
}

dyn_shadow_adjust()
{
	//sm_lightScore_eyeProjectDist
	//sm_lightScore_spotProjectFrac 
	//SetSavedDvar( "sm_sunShadowCenterMode", 1 );
	level endon("player_off_rifle");
	while(1)
	{
		start = level.player geteye();
		fwd = anglestoforward( level.player GetPlayerAngles() );
		fwd *= 12000;
		player_fwd = level.player.origin + fwd;
		trace = BulletTrace( start , player_fwd, true, level.player );
		if(isDefined( trace["position"] ) )
		{
			dist = distance( start, trace["position"] );
			//SetSavedDvar( "sm_sunShadowCenter", trace["position"] );
			SetSavedDvar( "sm_lightScore_eyeProjectDist", dist );			
		}	
		wait(.05);
	}	
	
}	

bell_tower_intro_soap()
{
	spawn_vehicle_from_targetname_and_drive("sniper_ambient_chopper");
	level.soap set_ignoreall( true );
	level.soap hidepart( "TAG_SILENCER" );
	
	self anim_single_solo( level.soap, "belltower_intro" );
	self anim_loop_solo( level.soap, "belltower_intro_idle" );
}

intro_dof_logic()
{
	// "dof_change" sent by notetrackcustomfunction
	dof_default = level.dofDefault;
	
	//bullets in clip:
	bullets= [];
	bullets[ "nearStart" ]= 0;
	bullets[ "nearEnd" ]  = 0;
	bullets[ "farStart" ] = 0.0147322;
	bullets[ "farEnd" ]   = 43.588;
	bullets[ "nearBlur" ] = 6.2;
	bullets[ "farBlur" ]  = 4.0;
	
	blend_dof( level.dofDefault, bullets, .10 );
	
	//on soap:
	on_soap= [];
	on_soap[ "nearStart" ]= 0;
	on_soap[ "nearEnd" ]  = 0;
	on_soap[ "farStart" ] = 88.01;
	on_soap[ "farEnd" ]   = 100.924;
	on_soap[ "nearBlur" ] = 4;
	on_soap[ "farBlur" ]  = 1.9;
	
	//wait(7);
	level waittill("dof_change");
	blend_dof( bullets, on_soap, .65 );//6800
	
	//to outside
	to_outside= [];
	to_outside[ "nearStart" ]= 95.5068;
	to_outside[ "nearEnd" ]  = 98.2229;
	to_outside[ "farStart" ] = 9325;
	to_outside[ "farEnd" ]   = 9661;
	to_outside[ "nearBlur" ] = 4;
	to_outside[ "farBlur" ]  = 0.39;
	
	//wait(4.45);
	level waittill("dof_change");
	blend_dof( on_soap, to_outside, .5 );//11800
	
	//look down to gun
	to_gun= [];
	to_gun[ "nearStart" ]= 0;
	to_gun[ "nearEnd" ]  = 3.08329;
	to_gun[ "farStart" ] = 514.52;
	to_gun[ "farEnd" ]   = 2118.8;
	to_gun[ "nearBlur" ] = 4;
	to_gun[ "farBlur" ]  = 2.83;
	
	level waittill("dof_change");
	wait(.3);
	blend_dof( to_outside, to_gun, .4 );
	level.player LerpViewAngleClamp( 1, .5, .5, 0, 0, 0, 0 );
	//wait(3);
	level waittill("dof_change");
	//Back to default as we approach the scope
	blend_dof( to_gun, dof_default, .5 );
		
}

player_get_on_sniper_rifle()
{
	e_rifle = getent( "bell_tower_sniper_rifle", "targetname" );
	
	v_rifle_pos = e_rifle.origin;
	v_target_pos = GetEnt( e_rifle.target, "targetname" ).origin;
	v_look_vector = v_target_pos - v_rifle_pos;
	v_starting_angles = VectorToAngles( v_look_vector );
	
	while( !IsDefined( e_rifle getturretowner() ) )
	{
		wait( 0.05 );
	}
	
	exploder( 105 ); // birds in the courtyard
	exploder( 120 );	
	
	level thread player_fired_too_early_listener();
	
	level.player DisableTurretDismount();
	level.player SetPlayerAngles( v_starting_angles );
	
	e_rifle SetTurretFov( 18 );
	level.player AllowAds( false );
	
	level.level_specific_dof = true;
	level.player SetDepthOfField( 0, 5500, 6850, 8500, 5, 1.5 );
	
	level thread on_sniper_rifle_vo();
	
	//TODO sunsamplenear
	
}

player_fired_too_early_listener()
{
	level endon( "player_allowed_to_fire" );
	
	while ( !level.player AttackButtonPressed() )
	{
		wait 0.05;
	}		
	
	flag_set( "sniper_cover_blown" );
	thread player_failed_out_of_scope();
	thread fail_after_time( 2.5, &"PRAGUE_ESCAPE_COVER_BLOWN" );
	wait(1.5);
	a_convoy_vehicles = GetEntArray( "convoy_vehicle", "targetname" );
	array_thread( a_convoy_vehicles, ::btr_fire_at_player );
}

btr_fire_at_player()
{
	self Vehicle_SetSpeed( 0, 15 );
	
	self.favoriteenemy = level.player;
	self SetTurretTargetEnt( level.player, ( 0, 0, 48 ) );
	self.baseaccuracy = 9999;	
	self waittill( "turret_on_target" );

	self.mgturret[0] thread maps\_mgturret::burst_fire_unmanned();
		
	self thread btr_fire_main_gun_loop();		
	wait( 1 );
	if( IsDefined( self.mgturret[0] ) )
	{
		MagicBullet( "btr80_ac130_turret", self.mgturret[0] GetTagOrigin( "tag_flash" ), level.player.origin + (0, 0, 32 ) );
	}
}

player_failed_out_of_scope()
{
	radio_dialogue_stop();
	level notify("player_off_rifle");
	wait(.5);
	
	if(cointoss())
	{
		//Yurui, what the hell are you doing
		radio_dialogue( "prague_escape_fail_yuridoin" );
	}	
	else
	{
		//What the hell?!
		radio_dialogue( "prague_escape_fail_whatthehell" );
	}
	
	SetSavedDvar( "sm_sunsamplesizenear", .25 );
	//SetSavedDvar( "sm_sunShadowCenterMode", 0 );
	//SetSavedDvar( "sm_sunShadowCenter", (0,0,0) );
	SetSavedDvar( "sm_lightScore_eyeProjectDist", 64 );		
	SetSavedDvar( "sv_znear", "0" );
	
	level.level_specific_dof = false;
	
	level.player EnableTurretDismount();
	e_rifle = getent( "bell_tower_sniper_rifle", "targetname" );
	e_rifle Delete();		
	
	s_align = getstruct( "anim_align_belltower", "targetname" );
	
	m_player_rig = spawn_anim_model( "player_rig", level.player.origin );
	m_player_rig.angles = level.player GetPlayerAngles();

	level.player PlayerLinkToDelta( m_player_rig, "tag_player", 1, 10, 10, 10, 10, 0 );
	
	level.m_sniper_model = spawn( "script_model", m_player_rig GetTagOrigin( "tag_weapon" ) );
	level.m_sniper_model.angles = m_player_rig GetTagAngles( "tag_weapon" );
	level.m_sniper_model SetModel( "viewmodel_rsass_sp_iw5" );
	level.m_sniper_model LinkTo( m_player_rig, "tag_weapon" );	
	level.m_sniper_model hidepart( "tag_clip", "viewmodel_rsass_sp_iw5" );
	level.m_sniper_model hidepart( "TAG_MOTION_TRACKER", "viewmodel_rsass_sp_iw5" );	
	level.m_sniper_model hidepart( "TAG_SILENCER", "viewmodel_rsass_sp_iw5" );
	
	level.player LerpFOV(65, .05);	

	thread anim_set_rate_single( m_player_rig, "scaffolding_fall", .6 );	
	wait(.05);
	s_align anim_single_solo( m_player_rig, "scaffolding_fall" );	
	
}

btr_fire_main_gun_loop()
{
	while( true )
	{
		self FireWeapon();	
		wait( .2 );
	}	
}

fail_after_time( n_time, str_fail_message )
{
	wait( n_time );
	SetDvar( "ui_deadquote", str_fail_message );
	maps\_utility::missionFailedWrapper();
}

on_sniper_rifle_vo()
{
	level endon( "sniper_cover_blown" );
	
	//level.price dialogue_queue( "presc_mct_almosttime" );
	wait( 1 );
	level.price dialogue_queue( "presc_pri_eyesonconvoy" );
	wait( 2 );
	level.soap dialogue_queue( "presc_mct_iseeit" );
	wait( 1 );
	//level.price dialogue_queue( "presc_pri_sittight" );
	
	flag_wait( "convoy_stopped" );
	wait( 0.5 );
	level.soap dialogue_queue( "presc_mct_stoppinghotel" );
	wait( 1 );
	level.price dialogue_queue( "presc_pri_doyouseetarget" );
	wait( 0.25 );
	level.soap dialogue_queue( "presc_mct_makarovcar" );
	wait(.75);
	level.soap dialogue_queue( "presc_mct_rightatusprice" );
	wait( 1 );
	level.price dialogue_queue( "presc_pri_dontgetskiddish" );	
	wait(3);
	//theyre pulling into the garage now
	level.soap dialogue_queue( "presc_mct_frontdoorhotelnow");
	wait(3);
	//all right kamarov you're up
	level.price dialogue_queue( "presc_pri_alrightkamarov" );
	wait(4);
	// "Kamarov, do you read me?"
	level.price dialogue_queue( "presc_pri_doyouread" );
	wait(1);
	// "Probably forgot to switch it on."
	level.soap dialogue_queue( "presc_mct_switchiton");
	// "Doesn't matter.  Makarov's here.  We move forward with the plan."
	level.price dialogue_queue( "presc_pri_doesntmatter");
	
	flag_set( "start_look_at_price" );
}

player_fire_sniper_listener()
{
	level endon( "player_off_rifle" );
	
	level.player NotifyOnPlayerCommand("player_fired","+attack");
	
	firetime = -5000;
	
	while( true )
	{
		wait_for_buffer_time_to_pass( firetime, 1 );
		level.player waittill( "player_fired" );
		
		level notify( "player_fired_sniper" );
	
		firetime = GetTime();
		level thread fire_delayed_sniper_round();
		
		// wait for the player to release the fire, as its a semi auto weapon
		while ( level.player AttackButtonPressed() )
		{
			wait( 0.05 );
		}
	}	
}

fire_delayed_sniper_round()
{	
	n_delay_length = .25;
	n_start_offset = 360;
	n_trace_distance = 8000;
	e_rifle = getent( "bell_tower_sniper_rifle", "targetname" );
	
	v_player_angles = level.player GetPlayerAngles();
	v_player_forward = VectorNormalize( AnglesToForward( v_player_angles ) );
	
	v_player_eye_pos = level.player geteye();
	v_start_offset = v_player_forward * n_start_offset;
	v_start_pos = v_player_eye_pos + v_start_offset;
	
	v_end_offset = v_player_forward * n_trace_distance;
	v_end_pos = v_player_eye_pos + v_end_offset;
	
	thread move_bullet_through_space( v_start_pos, v_end_pos, e_rifle.origin );
	
	// wait( n_delay_length );
	// thread draw_line_for_time( v_start_pos, v_end_pos, 1, 0, 0, 30 );
	// MagicBullet( "rsass_silenced", v_start_pos, v_end_pos, level.player );
}



move_bullet_through_space( v_start_pos, v_end_pos, v_bullet_start_pos )
{
	level endon( "player_off_rifle" );
	
	n_velocity = 3500;
	a_trace = BulletTrace( v_start_pos, v_end_pos, true );

 	m_bullet = spawn( "script_model", v_bullet_start_pos );
	m_bullet setmodel( "tag_origin" );
	
	playfxontag( getfx( "bullet_geo" ), m_bullet, "tag_origin" );
	m_bullet MoveTo( a_trace[ "position" ], .05 );	
	
//	while( true )
//	{
//		n_scalar = n_velocity * 0.05;
//		n_vector_delta = v_movement_vector * n_scalar;
//		v_final_position = m_bullet.origin + n_vector_delta;
//		m_bullet.origin = v_final_position;	
//		waitframe();
//	}
	wait( 1 );
	m_bullet Delete();
}



convoy_arrives()
{
	// prague_objective_add( &"PRAGUE_ESCAPE_WATCH_CONVOY", true, true );
	
	if( !flag( "sniper_cover_blown" ) )
	{
		maps\_autosave::_autosave_game_now_nochecks(); // no gun, no ammo.  Force the save	
	}	
	
	s_align = getstruct( "anim_align_hotel_front", "targetname" );
	
	s_align thread convoy_arrives_door_guards();
	
	wait( 1 );
	level.player thread display_hint( "barrett" );
	level thread player_learns_to_zoom();
	
	flag_wait( "convoy_stopped" );
	wait( 8 );
	
	flag_set( "makarov_exits_suv" );
	level thread spawn_balcony_ai();
	flag_set( "makarov_inside" );
}

convoy_arrives_vehicles()
{
	a_convoy_vehicles = GetEntArray( "convoy_vehicle", "targetname" );
	foreach( veh_car in a_convoy_vehicles )
	{
		veh_car.shadow_card = spawn( "script_model", veh_car.origin );
		veh_car.shadow_card.angles = veh_car.angles;
		veh_car.shadow_card setmodel( "vehicle_shadow_suburban" );
		veh_car.shadow_card linkto( veh_car );
		
		if( IsDefined( veh_car.mgturret ) )
		{
			veh_car.mgturret[0] notify( "stop_burst_fire_unmanned" );
			veh_car vehicle_lights_on( "headlights" );
			veh_car vehicle_lights_on( "taillights" );			
		}
		else 
		{
			veh_car thread suv_add_lights_and_tread_fx();
		}
	}
	
	makarov_spawner = getent( "convoy_makarov", "targetname" );
	makarov_spawner SetSpawnerTeam( "axis" );
	
	flag_wait( "start_convoy" );

	activate_trigger_with_targetname( "convoy_start_to_hotel" );
	
	makarov = makarov_spawner spawn_ai( true );
	makarov.team = "axis";
	makarov.animname = "makarov";

	level thread makarov_convoy_anims( makarov );
	
	flag_wait( "makarov_exits_suv" );
	convoy_enters_garage();
}



makarov_convoy_anims( makarov )
{
	veh_makarov_car = getent( "convoy_vehicle_3", "script_noteworthy" );
	makarov LinkTo( veh_makarov_car, "TAG_GUY1" );
	veh_makarov_car thread anim_loop_solo( makarov, "convoy_arrives_idle", undefined, "TAG_GUY1" );
	
	flag_wait( "convoy_arrives_start_makarov" );
	veh_makarov_car notify( "stop_loop" );

	veh_makarov_car anim_single_solo( makarov, "convoy_arrives_signals", "TAG_GUY1" );
	veh_makarov_car thread anim_loop_solo( makarov, "convoy_arrives_idle", undefined, "TAG_GUY1" );
}



convoy_enters_garage()
{
	a_convoy_vehicles = GetEntArray( "convoy_vehicle", "targetname" );
	for ( i = 1; i < a_convoy_vehicles.size +1; i++ )
	{
		veh_car = getent( "convoy_vehicle_" + i, "script_noteworthy" );
		n_start_point = GetVehicleNode( "convoy_to_garage_" + i, "targetname" );
		
		veh_car StartPath( n_start_point );
		wait( .25 );
	}
	
	wait( 1 );
	
	veh_convoy_suv_1 = getent( "convoy_vehicle_2", "script_noteworthy" );
	veh_convoy_suv_2 = getent( "convoy_vehicle_3", "script_noteworthy" );
	veh_convoy_suv_2 waittill ( "reached_end_node" );	
	veh_convoy_suv_2.shadow_card delete();
	veh_convoy_suv_1 Delete();
	veh_convoy_suv_2 Delete();	
}

btrs_drive_off()
{
	veh_btr1 = getent( "convoy_vehicle_1", "script_noteworthy" );
	veh_btr2 = getent( "convoy_vehicle_4", "script_noteworthy" );
	
	n_start_btr1 = getvehiclenode( "convoy_drive_off_1", "targetname" );
	n_start_btr2 = getvehiclenode( "convoy_drive_off_4", "targetname" );
	
	veh_btr1 StartPath( n_start_btr1 );
	veh_btr2 StartPath( n_start_btr2 );
	
	veh_btr2 waittill ( "reached_end_node" );	
	veh_btr2.shadow_card delete();
	veh_btr1.shadow_card delete();
	wait( 1 );
	veh_btr1 Delete();
	veh_btr2 Delete();	
}

suv_add_lights_and_tread_fx()
{
	PlayFXOnTag( level._effect[ "suv_headlight_l" ], self, "TAG_HEADLIGHT_LEFT" );
	PlayFXOnTag( level._effect[ "suv_headlight_r" ], self, "TAG_HEADLIGHT_RIGHT" );
	PlayFXOnTag( level._effect[ "suv_taillight_l" ], self, "TAG_TAIL_LIGHT_LEFT" );
	PlayFXOnTag( level._effect[ "suv_taillight_r" ], self, "TAG_TAIL_LIGHT_RIGHT" );
	// PlayFXOnTag( level._effect[ "tire_smoketrail" ], self, "TAG_WHEEL_BACK_LEFT" );
	// PlayFXOnTag( level._effect[ "tire_smoketrail" ], self, "TAG_WHEEL_BACK_RIGHT" );
	// PlayFXOnTag( level._effect[ "tire_smoketrail" ], self, "TAG_WHEEL_FRONT_LEFT" );
	// PlayFXOnTag( level._effect[ "tire_smoketrail" ], self, "TAG_WHEEL_FRONT_RIGHT" );
}



convoy_arrives_escort_guards()
{	
	level endon( "sniper_cover_blown" );
	
	a_convoy_guard_spawners = getentarray( "convoy_guard", "targetname" );
	a_convoy_guards = [];
	for( i = 0; i < a_convoy_guard_spawners.size; i++ )
	{
		a_convoy_guards[i] = a_convoy_guard_spawners[i] spawn_ai( true );
		a_convoy_guards[i].animname = "convoy_guard_" + (i + 1);
		a_convoy_guards[i] set_allowdeath( 1 );
	}
	
	self thread anim_loop( a_convoy_guards, "convoy_arrives_idle" );
	
	wait( 5 );
	flag_set("start_convoy");
	
	self notify( "stop_loop" );
	self anim_single( a_convoy_guards, "convoy_setup" );
	self thread anim_loop( a_convoy_guards, "convoy_arrives_wait" );

	veh_convoy_lead = getent( "convoy_vehicle_1", "script_noteworthy" );
	veh_convoy_lead waittill( "reached_end_node" );
		
	flag_set( "convoy_stopped" );
	self thread anim_single( a_convoy_guards, "convoy_arrives" );
}



convoy_arrives_door_guards()
{
	level endon( "sniper_cover_blown" );
	
	self thread convoy_arrives_hotel_doors();
	a_convoy_door_spawners = GetEntArray( "convoy_door_guard", "targetname" );
	e_align = Spawn( "script_model", self.origin );
	e_align SetModel( "tag_origin" );
	e_align.angles = self.angles;
	
	a_door_guards = [];
	for( i = 0; i < a_convoy_door_spawners.size; i++ )
	{
		a_door_guards[i] = a_convoy_door_spawners[i] spawn_ai( true );
		a_door_guards[i].animname = "door_guard_" + (i+1);
		a_door_guards[i] set_allowdeath( 1 );
	}
	
	
	flag_wait( "door_guards_start" );	// set through addNotetrack_flag
	e_align anim_single( a_door_guards, "hotel_door_enter" );
	
	array_thread( a_door_guards, ::door_guard_death_listener, e_align );
	// e_align anim_loop( a_door_guards, "hotel_door_open_wait" );
	
	flag_wait( "door_guards_close_door" );	// set through addNotetrack_flag
	e_align notify( "stop_loop" );
	
	e_align anim_single( a_door_guards, "hotel_door_close" );
	
	flag_set( "door_guards_inside" );
	array_delete( a_door_guards );
}

door_guard_death_listener( e_align )
{
	self endon( "death" );
	if( IsAlive( self ) )
	{
		e_align anim_loop_solo( self, "hotel_door_open_wait" );
	}
}

convoy_arrives_hotel_doors()
{
	level endon( "sniper_cover_blown" );
	
	m_door_left = getent( "hotel_front_door_left", "targetname" );
	m_door_right = getent( "hotel_front_door_right", "targetname" );
	
	door_left_anim = spawn( "script_model", m_door_left.origin );
	door_left_anim.angles = ( 0, 212.8, 0 );	// hard coded to fit anim
	door_left_anim SetModel( "tag_origin_animate" );
	door_left_anim UseAnimTree( level.scr_animtree[ "script_model" ] );
	door_left_anim.animname = "hotel_door_2";
	m_door_left linkto( door_left_anim, "origin_animate_jnt" );
	
	door_right_anim = spawn( "script_model", m_door_right.origin );
	door_right_anim.angles = ( 0, 32.8, 0 );	// hard coded to fit anim
	door_right_anim SetModel( "tag_origin_animate" );
	door_right_anim UseAnimTree( level.scr_animtree[ "script_model" ] );
	door_right_anim.animname = "hotel_door_1";
	m_door_right linkto( door_right_anim, "origin_animate_jnt" );
	
	a_animents = make_array( door_left_anim, door_right_anim );
	
	flag_wait( "door_guards_start" );	// set through addNotetrack_flag
	self thread anim_single( a_animents, "enter_door" );
	
	flag_wait( "door_guards_close_door" );	// set through addNotetrack_flag
	self thread anim_single( a_animents, "close_door" );
}
	
convoy_arrives_intro_patrollers()
{
	a_patroller_spawners = GetEntArray( "intro_patroller", "targetname" );
	a_patrollers = [];
	foreach( e_patroller in a_patroller_spawners )
	{
		wait( RandomFloat( 0.5 ) );
		e_guy = e_patroller spawn_ai( true );
		a_patrollers = array_add( a_patrollers, e_guy );
	}
	
	array_spawn_function_targetname( "ambient_street_guys", ::smoking_idle ); 
	array_spawn_function_targetname( "ambient_street_guys", ::delete_on_flag, "player_looked_at_price" ); 
	ambient_street_guys = get_guys_with_targetname_from_spawner( "ambient_street_guys" ); 
	
	level waittill( "player_allowed_to_fire" );
	array_delete( a_patrollers );
}

delete_on_flag( the_flag )
{
	flag_wait( the_flag );
	if( isdefined( self ))
	{
		self delete();
	}
}		

price_rappel_start()
{
	if( !flag( "sniper_cover_blown" ) )
	{
		maps\_autosave::_autosave_game_now_nochecks(); // no gun, no ammo.  Force the save	
	}	
	
	rappel_rope = spawn_anim_model("prague_rappel_rope", (0, 0, 0));

	level.a_rappel_ent = [];
	level.a_rappel_ent[ level.a_rappel_ent.size ] = level.price;
	level.a_rappel_ent[ level.a_rappel_ent.size ] = rappel_rope;
	
	level thread rappel_start_vo();
	
	s_align = getstruct( "anim_align_hotel_top", "targetname" );
	s_align anim_single_solo( level.price, "rappel_hook_up_reveal" );	
	s_align thread anim_loop_solo( level.price, "rappel_hook_up_idle" );
	
	// prague_objective_complete( undefined, true );
	
	// n_objective = prague_objective_add_on_ai( level.price, &"PRAGUE_ESCAPE_FIND_PRICE", true, true );
	// Objective_SetPointerTextOverride( n_objective, &"PRAGUE_ESCAPE_WATCH_PRICE_LOOK" );
	
	wait( 1 );
	
	level thread look_at_price_glint();
	
	is_looking_at_price = false;
	
	s_price_spot = getstruct( "sniper_price_start_spot", "targetname" );
	while( !is_looking_at_price )
	{
		n_angles_dot = player_view_angles_to_entity( s_price_spot );
		
		if( IsDefined( n_angles_dot ) && dot_to_angles( n_angles_dot ) < 4 )
		{
			wait( 1 );
			
			n_angles_dot = player_view_angles_to_entity( s_price_spot );			
			if( IsDefined( n_angles_dot ) && dot_to_angles( n_angles_dot ) < 4 )
			{			
				is_looking_at_price = true;	
			}
		}
		
		wait(.05);
	}
	
	flag_set( "player_looked_at_price" );
	level.soap thread dialogue_queue( "presc_mct_wegotyou" );
	level thread sniper_control_stop_poi();
	// level thread price_rappel_remove_poi( n_objective );
	
	s_align notify( "stop_loop" );
	s_align anim_single( level.a_rappel_ent, "rappel_hook_up" );
	
	level thread btrs_drive_off();
	s_align thread anim_loop( level.a_rappel_ent, "rappel_mid_idle" );
	
	s_align thread price_rappel_cleanup();
}

look_at_price_glint()	
{
	level endon( "player_looked_at_price" );
	
	fx = getfx( "sniper_glint" );
	s_glint_spot = getstruct( "sniper_price", "targetname" );
	
	while( true )
	{
		wait( RandomFloatRange( 1, 1.5 ) );
		
		PlayFX( fx, s_glint_spot.origin, AnglesToForward( s_glint_spot.angles ) );
	}
}

player_view_angles_to_entity( e_lookat )
{		
		v_player_view = VectorNormalize( AnglesToForward( level.player GetPlayerAngles() ) );
		v_angles_to_price = VectorNormalize( e_lookat.origin - level.player.origin );
		
		n_angles_dot = VectorDot( v_player_view, v_angles_to_price );	
		return n_angles_dot;
}

price_rappel_remove_poi( n_objective )
{
	wait( 2 );
	objective_clearAdditionalPositions( n_objective );
}

rappel_start_vo()
{
	level endon( "sniper_cover_blown" );
	level endon( "player_looked_at_price" );
	level.price dialogue_queue( "presc_pri_inposition" );
	wait( 1 );
	level.soap dialogue_queue( "presc_mct_findprice" );
	wait( .25 );
	level.soap dialogue_queue( "presc_mct_ontopofhotel" );
	level thread sniper_control_set_poi_ent( level.price, "Price", 5 );
}



price_rappel_nag_lines()
{
	level endon( "sniper_cover_blown" );
	level endon( "player_looked_at_price" );
	
	while( !flag( "player_looked_at_price" ) )
	{
		wait( 6 );
		level.soap dialogue_queue( "presc_pri_whatstaking" );
		
		if( RandomInt( 2 ) )
		{
			wait( 0.25 );
			level.soap dialogue_queue( "presc_mct_ontopofhotel" );
		}
	}
}



price_rappel_cleanup()
{
	flag_wait( "balcony_player_fired" );
	self notify( "stop_loop" );	
}



player_first_shot_listener()
{
	e_turret = getent( "bell_tower_sniper_rifle", "targetname" );
	while( !level.player AttackButtonPressed() )
	{
		wait( .05 );
	}
	
	flag_set( "balcony_player_fired" );
	wait(0.5);

	balcony_ai_wake_up();
}

balcony_ai_wake_up()
{
	a_balcony_ai = get_ai_group_ai( "hotel_balcony" );
	array_thread( a_balcony_ai, ::balcony_ai_react );
}

balcony_ai_react()
{
	surprise_anim = "exchange_surprise_" + RandomInt( level.surprise_anims );

	wait( RandomFloatRange( 0.2, 0.4 ) );	
	self notify( "end_patrol" );
	self anim_generic_custom_animmode( self, "gravity", surprise_anim );	
	
	self set_ignoreall( false );
}

balcony_snipe()
{
	level endon( "snipe_cover_blown" );
	
	level notify( "player_allowed_to_fire" );
	
	if( !flag( "sniper_cover_blown" ) )
	{
		maps\_autosave::_autosave_game_now_nochecks(); // no gun, no ammo.  Force the save	
	}
	
	// prague_objective_complete( undefined, true );
	prague_objective_add( &"PRAGUE_ESCAPE_BALCONY_SNIPE", true, true );		
	
	level thread balcony_snipe_vo();
	level thread player_fire_sniper_listener();

	level thread player_first_shot_listener();
	level thread balcony_soap_fire();
	
	flag_wait( "balcony_player_fired" );
}

balcony_snipe_vo()
{	
	level.soap dialogue_queue( "presc_mct_fourtargets" );
	
	wait(10);
	
	level thread do_nags_til_flag( "balcony_player_fired", "presc_mct_takethemout", "presc_mct_fourtargets" );

}

spawn_balcony_ai()
{
	s_align = getstruct( "anim_align_hotel_balcony", "targetname" );

	a_balcony_spawners = GetEntArray( "hotel_balcony_backup_guards", "targetname" );
	a_balcony_guards = [];
	for( i = 0; i < a_balcony_spawners.size; i++ )
	{
		a_balcony_guards[i] = a_balcony_spawners[i] spawn_ai( true );
		a_balcony_guards[i].animname = "generic";
		a_balcony_guards[i] thread smoking_idle();
		a_balcony_guards[i] disable_long_death();
	}
	
	flag_set( "balcony_ai_spawned" );
	
	// array_thread( a_balcony_guards, ::balcony_ai_missed_nag_line );
}


smoking_idle()
{	
	self waittill("goal");
	targ = getnode( self.target, "targetname" );
	if( !IsDefined( targ.target ) )
	{
		targ thread anim_generic_loop( self, "bored_idle" );
	}		
}

balcony_soap_fire()
{
	flag_wait( "balcony_player_fired" );
	level thread soap_kill_callout();
	a_soap_targets = get_ai_group_ai( "hotel_balcony" );
	
	foreach( e_soap_target in a_soap_targets )
	{
		if( IsAlive( e_soap_target ) )
		{
			wait( 1.25 );
			level thread soap_fire_sniper( e_soap_target );
		}
	}	
}

soap_fire_sniper( e_target )
{
	n_delay_length = .25;
	n_start_offset = 360;
	n_trace_distance = 8000;
	
	v_fire_point = getstruct( "sniper_soap_fire_pos", "targetname" ).origin;
	
	v_forward_to_target = VectorNormalize( e_target.origin - v_fire_point );
	v_start_offset = v_forward_to_target * n_start_offset;
	v_start_pos = v_fire_point + v_start_offset;
	
	v_end_offset = v_forward_to_target * n_trace_distance;
	v_end_pos = v_fire_point + v_end_offset;
	thread play_sound_in_space("soap_weapon_fire", v_fire_point );
	thread move_bullet_through_space( v_start_pos, v_end_pos + (0, 0, 48), v_fire_point );
	
	//33% chance soap confirms kill
	if( randomint(100) < 33)
	{
		level notify ("soap_confirms_kill");
	}	
	
	if( IsAlive( e_target ) )
	{
		e_target bloody_death();
	}
}

soap_kill_callout()
{
	level endon ("breach_complete");
	
	lines = [];
	//Sandman: He's down.
	//lines[lines.size] =  "prague_killfirm_other_1";
	//Sandman: Target down.
	lines[lines.size] = "prague_killfirm_other_2";	
	//Sandman: Got 'em.
	lines[lines.size] = "prague_killfirm_other_3";
	//Sandman: That's a kill.
	//lines[lines.size] = "prague_killfirm_other_4";
	
	lines = array_randomize( lines );
	
	foreach(line in lines)
	{
		level waittill( "soap_confirms_kill" );
		radio_dialogue( line, 1 );
	}	

}	

price_window_breach()
{
	prague_objective_complete( undefined );
	battlechatter_on( "axis" );
	level.price disable_pain();
	
	// IPrintLnBold( "Price: Breaching Window, cover me" );
	delaythread( 2.3, ::price_shoots_window );
	s_align = getstruct( "anim_align_hotel_balcony", "targetname" );
	n_anim_length = GetAnimLength( level.scr_anim[ "price" ][ "price_window_breach" ] );
	s_align thread anim_single( level.a_rappel_ent, "price_window_breach" );
	
	flag_wait( "breach_ai_spawned" );
	waitframe();

	a_animents = get_ai_group_ai( "hotel_breach" );
	array_thread( a_animents, ::price_window_breach_ai_animate, s_align );

	// TODO: get notetracks added to price's anim in place of these hardcoded waits
	activate_trigger_with_targetname( "trig_price_breach_cover" );	// set price to his node
	level thread window_smash();
	level.price set_ignoreall( false );
	level.price set_ignoreme( false );
	level.price.grenadeammo = 0;
	
	level thread breach_no_shot_nag();
	
	wait( level.n_time_to_clear_breach );
	
	flag_set( "breach_complete" );
	// wait( 4 );
}

price_window_breach_ai_animate( s_align )
{
	if( self.animname == "window_breach_grd_2" )
	{
		str_model = self.model;
		m_dummy = spawn( "script_model", self.origin );
		self Delete();
		
		m_dummy SetModel( str_model );		
		m_dummy UseAnimTree( level.scr_animtree[ "generic_human" ] );
		m_dummy.animname = "window_breach_grd_2";
		s_align thread anim_single_solo( m_dummy, "window_breach" );
		
		level waittill( "sniping done" );
		m_dummy Delete();
	}
	else
	{
		self set_allowdeath( 1 );
		s_align thread anim_single_solo( self, "window_breach" );
	}
}

breach_no_shot_nag()
{
	n_start_time = GetTime();
	n_player_fire_count = 0;
	
	while( GetTime() < n_start_time + 500 )
	{
		if ( !level.player AttackButtonPressed() )
		{
			n_player_fire_count++;
			
			// wait for the player to release the fire, as its a semi auto weapon
			while ( level.player AttackButtonPressed() )
			{
				wait( 0.05 );
			}
		}
		
		wait( 0.05 );
	}
	
	if( n_player_fire_count < 2 )
	{
		//level.soap dialogue_queue( "presc_mct_pickyourshots" );
	}
}

window_smash()
{
	exploder( 150 ); // window smash
	exploder( 151 ); // flashbangs	
	
	m_curtains = getent( "fxanim_prague2_curtain_fall_mod", "targetname" );
	m_curtains.animname = "curtain";
	m_curtains UseAnimTree( level.scr_animtree[ "script_model" ] );
	m_curtains anim_single_solo( m_curtains, "window_breach_curtain_fall" );
// 	m_curtains anim_single_solo( m_curtains, "window_breach_curtain_break" );
}

price_shoots_window()
{
	for( i = 0; i <6; i++ )
	{
		start = level.price gettagorigin( "tag_flash" );
		end = ( 20888, 8680, 448 );
		magicbullet( "ak47", start, end);
		wait( randomfloatrange( .05, .15) );
	}	
	
}	
	

breach_snipe( n_enemy_count )
{
	n_time_to_clear = level.n_time_to_clear_breach; // GetAnimLength( level.scr_anim[ "price" ][ "price_window_breach" ] );
	
	a_soap_kill_count[0] = n_enemy_count;
	a_soap_kill_count[1] = n_enemy_count;
	a_soap_kill_count[2] = n_enemy_count;
	a_soap_kill_count[3] = n_enemy_count;			
	
	waittillframeend;
	
	level thread soap_snipe_targets_over_time( a_soap_kill_count[ level.gameskill ], n_time_to_clear );
	
	waittill_aigroupcleared( "hotel_breach_player_soap_targets" );
}

soap_snipe_targets_over_time( n_soap_kill_count, n_time_to_clear )
{	
	n_soap_firing_delay = n_time_to_clear / ( n_soap_kill_count + 1 );
	// IPrintLn( "killing " + n_soap_kill_count + " over " + n_time_to_clear + ", 1 every " + n_soap_firing_delay );
	// IPrintLn( level.breach_targets.size );
	
	for( i = 0; i < n_soap_kill_count; i++ )	
	{
		wait( n_soap_firing_delay );
		
		level.breach_targets = array_removeDead_or_dying( level.breach_targets );

		if( IsDefined( level.breach_targets[0] ) )
		{
			thread soap_fire_sniper( level.breach_targets[0] );
			level.breach_targets = array_randomize( level.breach_targets );
		}
	}
}

hotel_breach_player_targets_think( a_targets )
{
	level endon( "breach_complete" );
	
	a_targets = array_randomize( a_targets );

	n_soap_firing_delay = 1;
	
	while( true )
	{
		wait( n_soap_firing_delay );
		
		a_targets = array_removeDead_or_dying( a_targets );

		if( IsDefined( a_targets[0] ) )
		{
			if( IsDefined( a_targets[0].script_noteworthy ) && a_targets[0].script_noteworthy == "soap_dont_shoot" )
			{
				a_targets = array_remove_index( a_targets, 0 );
			}
			else
			{
				thread soap_fire_sniper( a_targets[0] );
				a_targets = array_randomize( a_targets );
			}
		}
	}	
}

its_a_trap()
{
	a_guys = getaiarray( "axis" );
	foreach( e_guy in a_guys )
	{
		e_guy thread bloody_death();
		wait( RandomFloatRange( .25, .75 ) );
	}
	array_thread( a_guys, ::bloody_death );
		
	s_align = getstruct( "anim_align_hotel_balcony", "targetname" );
	level thread kamarov_in_elevator();
	s_align anim_reach_solo( level.price, "price_discover_kamarov" );
	//level thread kamarov_in_elevator();
	s_align thread anim_single_solo( level.price, "price_discover_kamarov" );
	wait GetAnimLength( level.scr_anim[ "price" ][ "price_discover_kamarov" ] ) - 2;
	
}

kamarov_in_elevator()
{
	speed = 14;
	
	//flag_wait( "price_discover_kamarov_open_doors" );
	
	level thread new_breach_vo_timing();
	
	// set up kamarov in the chair
	s_chair = getstruct( "struct_sniper_elevator_chair", "targetname" );
	m_chair = spawn( "script_model", s_chair.origin );
	m_chair.angles = s_chair.angles;
	m_chair SetModel( "com_office_chair_killhouse" );
	
	kamarov_spawner = getent( "kamarov", "targetname" );
	kamarov = kamarov_spawner spawn_ai( true );
	kamarov.animname = "kamarov";
	
	m_chair thread anim_loop_solo( kamarov, "kamarov_dead" );
	
	m_door_left = GetEnt( "hotel_elevator_door_left", "targetname" );
	m_door_right = GetEnt( "hotel_elevator_door_right", "targetname" );
	s_left_moveto = getstruct( "hotel_elevator_door_moveto_left", "targetname" );
	s_right_moveto = getstruct( "hotel_elevator_door_moveto_right", "targetname" );

	n_dist = abs( Distance( m_door_left.origin, s_left_moveto.origin ) );
	n_moveTime = ( n_dist / speed ) * 0.5;
	
	m_door_left MoveTo( s_left_moveto.origin, n_moveTime, n_moveTime * 0.1, n_moveTime * 0.25 );
	m_door_right MoveTo( s_right_moveto.origin, n_moveTime, n_moveTime * 0.1, n_moveTime * 0.25 );
	
	level waittill( "sniping done" );
	
	kamarov Delete();
	m_chair Delete();
	m_door_left Delete();
	m_door_right Delete();
}

hotel_explodes()
{
	level.level_specific_dof = false;

	stop_exploder( 105 );
	level.soap StopLoopSound();
	exploder( 160 ); // Hotel explosion
	m_pillars = GetEnt( "fxanim_prague2_hotel_mod", "targetname" );
	m_pillars.animname = "hotel_columns";
	m_pillars UseAnimTree( level.scr_animtree[ "script_model" ] );
	m_pillars thread anim_single_solo( m_pillars, "hotel_explode" );
	
	wait( .3 );
	
	level notify( "player_off_rifle" );
	level.player LerpFOV(65, .05);
	SetSavedDvar( "sm_sunsamplesizenear", .25 );
	//SetSavedDvar( "sm_sunShadowCenterMode", 0 );
	//SetSavedDvar( "sm_sunShadowCenter", (0,0,0) );
	SetSavedDvar( "sm_lightScore_eyeProjectDist", 64 );		
	SetSavedDvar( "sv_znear", "0" );
	
	// get player off the sniper rifle
	level.player EnableTurretDismount();
	vision_set_fog_changes("prague_escape_start", .05 );
	e_rifle = getent( "bell_tower_sniper_rifle", "targetname" );
	e_rifle Delete();		
	
	level.player PlayRumbleOnEntity( "damage_heavy" );
	Earthquake( 1.2, 2, level.player.origin, 64 );

}

prague_escape_sniper_cleanup()
{
	level notify( "sniping done" );
	
	a_temp_convoy_ents = GetEntArray( "temp_convoy_checkpoint", "targetname" );
	array_delete( a_temp_convoy_ents );
	
	a_convoy_vehicles = GetEntArray( "convoy_vehicle", "targetname" );
	array_delete( a_convoy_vehicles );		
	
	level.price enable_pain();
}


prague_escape_skippast_cleanup()
{
	a_convoy_vehicles = GetEntArray( "convoy_vehicle", "targetname" );
	array_delete( a_convoy_vehicles );	
}



player_learns_to_zoom()
{
	level endon( "start_convoy" );
	level thread player_learns_to_zoom_timeout();
	
	// flag_clear( "player_used_zoom" );		//make sure we show hint anytime player gets on the rifle
	// movement = level.player GetNormalizedMovement();
	
	while( true )
	{
		wait( 0.05 );
		movement = level.player GetNormalizedMovement();	//needs to move stick forward to learn
		if ( movement[ 0 ] < -0.1 || movement[0] > 0.1 )
			break;
	}
	//wait( 1 );
	//flag_set( "start_convoy" );
}

player_learns_to_zoom_timeout()
{
	level endon( "start_convoy" );
	
	wait( 5 );
	// IPrintLnBold( "Soap: Yuri, zoom in on the barricade!" );
	
	wait( 2 );
	level.player thread display_hint( "barrett" );
	
//	wait( 3 );
//	flag_set( "start_convoy" );
}

spawn_breach_ai( guy )
{
	a_guard_spawners = GetEntArray( "window_breach_guard", "targetname" );
	for( i = 0; i < a_guard_spawners.size; i++ )
	{
		e_guard = a_guard_spawners[i] spawn_ai( true );
		e_guard.animname = "window_breach_grd_" + (i + 1);
		e_guard disable_long_death();
	}
	
	a_targets = [];
	level.breach_targets = [];
	a_target_spawners = GetEntArray( "hotel_breach_player_soap_targets", "targetname" );
	// IPrintLn( "Spawners: " + a_target_spawners.size );
	n_size = a_target_spawners.size;
	for( i = 1; i < a_target_spawners.size; i++ )
	{
		a_target_spawners[i] thread spawn_breach_ai_from_spawner();
	}
	
	level thread breach_snipe( n_size );
	// level thread hotel_breach_player_targets_think( a_targets );
	
	flag_set( "breach_ai_spawned" );
}

// some spawners have script_delay_spawn set, so threading their spawns to not slow down the rest
spawn_breach_ai_from_spawner()
{
	e_guy = self spawn_ai( true );
	e_guy thread breach_ai_spawn_think();
}

belltower_intro_dialogue( guy )
{
	// It's almost time, Yuri?	
	level.soap dialogue_queue( "presc_mct_almosttime" );
	// Makarov's convoy should be here any minute...
	//level.soap dialogue_queue( "presc_mct_makarovconvoy" );
	//flag_wait( "belltower_intro_dialogue_02" );
	// Get in position
	//level.soap dialogue_queue( "presc_mct_getinposition" );
}

new_breach_vo_timing()
{
	//level.player play_sound_on_entity("presc_pri_allclear" );//Kamarov
	//level.player thread play_sound_on_entity("presc_mct_makarov" );//Im sorry price Im sorry
	
	level.player  play_sound_on_entity("presc_mct_zoominyuri"); //Who the hells' that?
	level.player play_sound_on_entity("presc_pri_allclear");//kamarov
	//level.player play_sound_on_entity("presc_pri_nosign" );//Kamarov what did you tell him
	//level.player play_sound_on_entity("presc_mct_price" );//everything
	level.player play_sound_on_entity("presc_mct_makarov" );//Im sorry price Im sorry
	//level.player play_sound_on_entity("presc_pri_damnit" ); //Dammit
	level.player play_sound_on_entity( "presc_mkv_welcometohell" );//Captian price ["Welcome to hell"]
	//level.player play_sound_on_entity("presc_pri_itsasetup" );//its a setup
	level.player play_sound_on_entity( "presc_mct_getouttathere" );	//Price get out of there!	
	
	/*
	Plays in prague_escape_scaffold.gsc :
	level.scr_sound[ "price" ][ "presc_mkv_yurimyfriend" ] = "presc_mkv_yurimyfriend";
	// What the hell's he talking about, Yuri?!!			
	level.scr_sound[ "soap" ][ "presc_mct_hellshetalkinabout" ] = "presc_mct_hellshetalkinabout";
	*/
}	


start_hotel_flashing_bomb( guy )
{
	//level.price thread dialogue_queue( "presc_pri_nosign" );
	level.soap PlayLoopSound( "scn_prague_belltower_bomb_beep" );
	exploder( 155 ); // bomb flashing lights inside hotel
}

hotel_flashing_bomb_vo( guy )
{
	level.soap thread dialogue_queue( "presc_pri_damnit" ); // TODO: remove once sound is playing correctly for price
}

breach_ai_spawn_think()
{
	self disable_long_death();
	self waittill( "goal" );
	level.breach_targets[ level.breach_targets.size ] = self;
	// IPrintLn( "Added AI to breach_targets" );
}

temp_sniper_nag_lines()
{
	level.sniper_nag_lines[ "convoy" ][0] = "presc_mct_eyesonconvoy";
	level.sniper_nag_lines[ "convoy" ][1] = "presc_mct_outofyoursights";
	level.sniper_nag_lines[ "convoy" ][2] = "presc_mct_focus";
		
	//level.sniper_nag_lines[ "makarov" ][0] = "presc_pri_doyouseemak";
	//level.sniper_nag_lines[ "makarov" ][0] = "presc_pri_confirmtarget";
	level.sniper_nag_lines[ "makarov" ][0] = "presc_pri_doyouseetarget";
	
	level.sniper_nag_lines[ "Price" ][0] = "presc_mct_findprice";
	level.sniper_nag_lines[ "Price" ][1] = "presc_mct_ontopofhotel";
	level.sniper_nag_lines[ "Price" ][2] = "presc_pri_whatstaking";
}

hotel_flank_guys_think()
{
	self enable_cqbwalk( true );
}

hotel_curtain_idle()
{
	a_curtains = GetEntArray( "fxanim_prague2_curtain_win_long_mod", "targetname" );
	
	foreach( m_curtain in a_curtains )
	{
		m_curtain.animname = "curtain";
		m_curtain UseAnimTree( level.scr_animtree[ "script_model" ] );
		m_curtain thread anim_loop_solo( m_curtain, "curtain_idle" );
	}
	
	flag_wait( "soap_picked_up" );	
	array_notify( a_curtains, "stop_loop" );
}

////////////////////////////////////////////////////////////////////////////////////////////
// SNIPER CONTROLS

sniper_control_set_poi_ent( e_poi, str_poi, n_max_angles )
{
	level notify( "sniper_control_stop_poi" );
	level endon( "sniper_control_stop_poi" );
	
	level.str_current_sniper_poi = str_poi;
	
	level thread sniper_control_look_at_nag( e_poi, n_max_angles );
}



sniper_control_stop_poi()
{
	level notify( "sniper_control_stop_poi" );
}



sniper_control_look_at_nag( e_poi, n_max_angles )
{
	level endon( "sniper_cover_blown" );
	level endon( "sniper_control_stop_poi" );
	
	e_rifle = getent( "bell_tower_sniper_rifle", "targetname" );

	n_frames_to_line = 180;	

	v_rotate_speed = (0, 5, 0 );
	n_frames_off_target = 0;
    
	while( !flag("player_looked_at_price") )
    {
        // a_normalized_rotation = level.player GetNormalizedCameraMovement();

    	v_player_angles = level.player GetPlayerAngles();
    	v_player_forward = VectorNormalize( AnglesToForward( v_player_angles ) );
	        	
		v_rifle_pos = e_rifle.origin;
		v_to_poi_vector = e_poi.origin - v_rifle_pos;
		v_to_poi_normal = VectorNormalize( v_to_poi_vector );
		
		v_dot = VectorDot( v_player_forward, v_to_poi_normal );
		
		if( IsDefined( v_dot ) )
		{
			n_angles = dot_to_angles( v_dot );
		}
		else
		{
			continue;	
		}
		
		if ( isdefined( n_angles ) && IsDefined( n_max_angles ) && (n_angles > n_max_angles) )
		{
			n_frames_off_target++;
		}
		else
		{
			n_frames_off_target = 0;	
		}
		
		if ( n_frames_off_target > n_frames_to_line )
		{
			if( ! RandomInt( 4 ) )
			{
				n_line_index = RandomIntRange( 1, level.sniper_nag_lines[ level.str_current_sniper_poi ].size ) - 1;
				level.soap thread dialogue_queue( level.sniper_nag_lines[ level.str_current_sniper_poi ][ n_line_index ] );
			}
			
			n_frames_off_target = 0;	
			
			// Where does the player need to look?
			v_to_poi_angles = VectorToAngles( v_to_poi_normal );
			v_to_poi_angles_up = VectorNormalize( AnglesToUp( v_to_poi_angles ) );
			v_to_poi_angles_right = VectorNormalize( AnglesToRight( v_to_poi_angles ) );
			n_height_dot = VectorDot( v_to_poi_angles_up, v_player_forward );
			n_right_dot = VectorDot( v_to_poi_angles_right, v_player_forward );
			
			str_comment = undefined;
			if( n_height_dot < -0.07 )
			{
				if( n_right_dot < -0.07 )
				{
					str_comment = "presc_mct_upandright";
				}
				else if( n_right_dot > 0.07 )
				{
					str_comment = "presc_mct_upandleft";
				}
				else
				{
					str_comment = "presc_mct_upalittle";
				}
			}
			else if( n_height_dot > 0.07 )
			{
				if( n_right_dot < -0.07 )
				{
					str_comment = "presc_mct_downandright";
				}
				else if( n_right_dot > 0.07 )
				{
					str_comment = "presc_mct_lowerleft";
				}
				else
				{
					str_comment = "presc_mct_downabit";
				}
			}
			else if( n_right_dot < -0.07 )
			{
				str_comment = "presc_mct_pullitmore";
			}
			else if( n_right_dot > 0.07 )
			{
				str_comment = "presc_mct_totheleft";
			}
		
			if( IsDefined( str_comment ) )
			{
				level.soap thread dialogue_queue( str_comment );
			}
		}
		
		waitframe();
    }
    
}



dot_to_angles( n_dot )
{
	assert( IsDefined( n_dot ), "n_dot is a required parameter for dot_to_angles" );
	
	n_fov = ACos( n_dot ) * 2; 
	
	return n_fov;
}

start_anim_on_object(animname,name_of_animation,delay)
{
	self endon("deleted_through_script");
	
	if ( isdefined(delay) )
	{
		wait(delay);
	}
	self.animname = animname;
	self useAnimTree( level.scr_animtree[ self.animname ] );
	self thread anim_single_solo(self, name_of_animation, "stop_looping_anims");
	//self setAnimRestart( level.scr_anim[self.animname][name_of_animation][0], 1, 0, 1 );
}

wait_then_notify( time, ent, notify_msg)
{
	wait(time);
	ent notify(notify_msg);
	          	
}