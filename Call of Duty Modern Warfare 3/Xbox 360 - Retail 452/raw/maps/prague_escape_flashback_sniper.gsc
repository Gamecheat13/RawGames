#include maps\_utility;
#include common_scripts\utility;
#include maps\_anim;
#include maps\_vehicle;
#include maps\prague_escape_code;
#include maps\_shg_common;

// Start Functions	/////////////////////////////////////////////////////////////////////////////////////
start_flashback_sniper()
{
	move_player_to_start( "flashback_sniper_player" );
	
	level.player vision_set_fog_changes( "prague_escape_sniper_outside", 0 );
	
	if ( !IsDefined( level.player ) )
	{
		level.player = GetEntArray( "player", "classname" )[ 0 ];
		level.player.animname = "player_rig";
	}
	
	flag_set( "start_no_time_scene" );
		
	//hide hud
	maps\prague_escape_code::hide_player_hud();
	
	level.player AllowCrouch( false );
	level.player AllowProne( false );
	level.player AllowSprint( false );
	level.player AllowJump( false );
	level.player AllowAds( false );
	
	level thread take_care_of_fake_weapon_tag();

	battlechatter_off();

	setup_no_time_scene();	
	
//	s_uaz_align_struct = getstruct( "uaz_align_struct", "targetname" );
//	level.player_uaz = spawn_anim_model( "player_uaz", s_uaz_align_struct.origin );
//	level.player_uaz HidePart( "tag_blood" );
	
//	level.s_uaz_align = Spawn( "script_origin", level.player_uaz.origin );
	
	maps\prague_escape_sniper::prague_escape_skippast_cleanup();
}

#using_animtree( "vehicles" );
// Main Functions	/////////////////////////////////////////////////////////////////////////////////////
flashback_sniper_main()
{
	level.player shellshock( "prague_escape_flashback", 10 );
	music_play( "prague_escape_sniper_mx", 1 ); //sniper section
		
	level.flashback_overlay = NewClientHudElem( level.player );
	level.flashback_overlay.horzAlign = "fullscreen";
	level.flashback_overlay.vertAlign = "fullscreen";
	level.flashback_overlay SetShader( "overlay_flashback_blur", 640, 480 );
	level.flashback_overlay.archive = true;
	level.flashback_overlay.sort = 10;
			
	level thread nuke_transition_timer();
	level thread take_care_of_fake_weapon_tag();
		
	no_time_scene();
	bullet_strikes_scene();
}

uaz_backwindow_smash( guy )
{
	level.player thread play_sound_on_entity( "scn_prague_makarov_drive" );
	wait( 1.0 );	
	s_sniper_shot_start = getstruct( "sniper_shot_start", "targetname" );
	level thread play_sound_in_space( "soap_weapon_fire", s_sniper_shot_start.origin );
	wait(.35);
	level.player_uaz thread play_sound_on_tag( "veh_glass_break_small", "tag_origin" );
	level.player PlayRumbleOnEntity( "damage_heavy" );
	PlayFXOnTag( getfx( "glass_exit_car_flashback" ), level.player_uaz, "tag_origin" );
}

setup_no_time_scene()
{
	level thread sniper_flashback_dof();
	s_uaz_align_struct = getstruct( "uaz_align_struct", "targetname" );
	
	level.player.ignoreme = true;
	level.m_player_rig = spawn_anim_model( "player_rig_oneshot", level.player.origin );
	level.m_player_rig.angles = level.player GetPlayerAngles();
	level.m_player_rig.animname = "player_rig";
	level.m_player_rig DontCastShadows();
	level.m_player_rig Hide();
			
	//UAZ	
	level.player_uaz = spawn_anim_model( "player_uaz", s_uaz_align_struct.origin );
	level.player_uaz HidePart( "tag_blood" );

	level.s_uaz_align = Spawn( "script_origin", level.player_uaz.origin );
	
	e_spawner = GetEnt( "ai_makarov_oneshot", "targetname" );
	level.ai_makarov_oneshot = e_spawner spawn_ai( true );
	level.ai_makarov_oneshot.animname = "makarov";
	level.ai_makarov_oneshot SetCanDamage( false );		
	
	level.zakhaev_onearm = spawn_anim_model( "zakhaev" );	
	level.zakhaev_onearm.animname = "zakhaev";
	level.zakhaev_onearm Hide();
	
	level.a_anim_ents = [];
	level.a_anim_ents[0] = level.ai_makarov_oneshot;
	level.a_anim_ents[1] = level.player_uaz;
	level.a_anim_ents[2] = level.m_player_rig;

	level.s_uaz_align anim_first_frame( level.a_anim_ents, "no_time" );		
}

sniper_flashback_dof()
{
	dof_default = level.dofDefault;
	
	//Look at Makarov
	makarov= [];
	makarov[ "nearStart" ]= 10;
	makarov[ "nearEnd" ]  = 38;
	makarov[ "farStart" ] = 1000;
	makarov[ "farEnd" ]   = 1043.27;
	makarov[ "nearBlur" ] = 6.81;
	makarov[ "farBlur" ]  = 1.05942;
	
	wait(1);
	blend_dof( level.dofDefault, makarov, 1 );//2300
	
	//look at Zak
	zak= [];
	zak[ "nearStart" ]= 0;
	zak[ "nearEnd" ]  = 26;
	zak[ "farStart" ] = 7025;
	zak[ "farEnd" ]   = 12062;
	zak[ "nearBlur" ] = 5;
	zak[ "farBlur" ]  = 0.5;
	wait( 14.5 );
	blend_dof( makarov, zak, 1 );//2300
	
	flag_wait("start_nuke_transition"); //1 sec after first guy get shit with car
	blend_dof( zak, dof_default, 1 );
	
}	


init_sniper_level_flags()
{
	flag_init( "start_no_time_scene" );
	flag_init( "sniper_escape_done" );
	flag_init( "zakhaev_shot" );	
	flag_init( "front_uaz_gone" );
	flag_init( "front_parked_gone" );
	flag_init( "middle_parked_gone" );
	flag_init( "spawn_escape_victims" );
	flag_init( "spawn_onearm_zakhaev" );
	flag_init( "stop_uaz_rumble" );
	flag_init( "start_heli_path" );
	flag_init( "heli_start_path_1" );
	flag_init( "heli_start_path_2" );
	flag_init( "heli_path_wait_1" );
	flag_init( "heli_path_wait_2" );
	flag_init( "heli_blocks_zak" );
	flag_init( "drop_the_flag" );
	flag_init( "play_sniper_glint" );
	flag_init( "play_sniper_glint_2" );
	flag_init( "makarov_no_time_dialogue03" );
	flag_init( "makarov_no_time_dialogue04" );
	flag_init( "makarov_no_time_dialogue05" );
	flag_init( "makarov_bullet_strike_dialogue03" );			
	flag_init( "zakhaev_bullet_strike_dialogue04" );		
	flag_init( "zakhaev_exchange_hadadeal" );
	flag_init( "zakhaev_exchange_argueover" );
	flag_init( "zakhaev_exchange_knownbetter" );
	flag_init( "start_nuke_transition" );
	flag_init( "start_nuke_scene" );
	flag_init( "heli_fire_mw_player" );	
}

no_time_scene()
{
	flag_wait( "start_no_time_scene" );

	level thread intro_blur();

	//level thread autosave_by_name_silent( "flashback_sniper" );
	maps\_autosave::_autosave_game_now_nochecks(); // no gun, no ammo.  Force the save

//	level	thread maps\_utility::set_ambient("prague_flashback_sniperescape");

	level thread exchange_deal();	
	
	level.m_player_rig Show();
	
	level.player PlayerLinkToBlend( level.m_player_rig, "tag_player" );						 
	level.player PlayerLinkToDelta( level.m_player_rig, "tag_player", 1, 10, 10, 10, 10, true );	

	//level thread makarov_wake_up_dialogue();
	level.s_uaz_align anim_single( level.a_anim_ents, "no_time" );
	level.m_player_rig Hide();

	//TODO: have makarov be in the last frame of no_time
	//Hide until the escape scene
	//level.ai_makarov_oneshot Hide();
	level.s_uaz_align anim_last_frame_solo( level.ai_makarov_oneshot, "no_time" );

	sniper_stream_ent = GetEnt( "sniper_stream_ent", "targetname" );
	sniper_stream_ent Delete();
		
	e_player_uaz_spot = Spawn( "script_model", level.player.origin );
	e_player_uaz_spot SetModel( "tag_origin" );
	e_player_uaz_spot.angles = level.player.angles;	
	
	level.player PlayerLinkToDelta( e_player_uaz_spot, "tag_player", 1, 20, 50, 15, 15, false );	

	lines = [];
	// Yuri
	lines[ lines.size ] = &"PRAGUE_ESCAPE_INTRO_ONESHOT_1";
	// Winter - 1996
	lines[ lines.size ] = &"PRAGUE_ESCAPE_INTRO_ONESHOT_2";
	//Pripyat, Ukraine
	lines[ lines.size ] = &"PRAGUE_ESCAPE_INTRO_ONESHOT_3";
	
	maps\_introscreen::introscreen_feed_lines( lines );
}

makarov_wake_up_dialogue()
{
	wait( 0.50 );
	level.ai_makarov_oneshot thread dialogue_queue( "presc_mkv_yuriwakeup" );	
}

block_helicopter()
{
	self endon( "death" );
	level endon("start_nuke_transition");
	self thread delete_on_flag( "start_nuke_transition" );
	
	self SetNearGoalNotifyDist( 1000 );	
	self SetHoverParams( 35, 15, 10 );

	flag_wait( "start_heli_path" );

	flag_wait( "heli_path_wait_1" );	
	
	wait( 3 );

	flag_set( "heli_start_path_1" );
	
	wait( 5.5 );
	
	flag_set( "heli_start_path_2" );

	self Vehicle_SetSpeed( 25, 15, 10 );
	
	flag_wait( "heli_fire_mw_player" );
	
	tag_flash_origin = self GetTagOrigin( "tag_flash" );
	tag_flash_angles = self GetTagAngles( "tag_flash" );
	fire_dir = AnglesToForward( tag_flash_angles );
	
	MagicBullet( "rpg_straight", tag_flash_origin, tag_flash_origin + fire_dir );
	MagicBullet( "rpg_straight", tag_flash_origin, tag_flash_origin + fire_dir );

	wait( 0.25 );
	
	MagicBullet( "rpg_straight", tag_flash_origin, tag_flash_origin + fire_dir );
	MagicBullet( "rpg_straight", tag_flash_origin, tag_flash_origin + fire_dir );

	wait( 0.25 );
	
	MagicBullet( "rpg_straight", tag_flash_origin, tag_flash_origin + fire_dir );
	MagicBullet( "rpg_straight", tag_flash_origin, tag_flash_origin + fire_dir );

	flag_wait( "start_nuke_transition" );	//flag is set when second guy is hit by car
	self Delete();	
}


delete_on_flag( the_flag )
{
	flag_wait( the_flag);
	if(isDefined( self ))
	{
		self delete();
	}
}
		
exchange_deal()
{
	level thread uaz_and_soldiers();
	level thread sniper_glint();	
	
	//have a notetrack from no_time anim to start this before players turns
	wait( 12 );

	flag_set( "start_heli_path" );	
	
	//spawn them in
	exchange_baddies = GetEntArray( "exchange_badguys", "targetname" );	
	baddies = array_spawn( exchange_baddies );
	array_thread( baddies, ::sniper_shot_reaction );
	
	level.zakhaev = get_guy_with_targetname_from_spawner( "exchange_zakhaev" );
	
	level.zakhaev.a.disablePain = true;
	level.zakhaev.ignoreall = true;
	level.zakhaev.disableexits = true;
	level.zakhaev.disablearrivals = true;	
	level.zakhaev putGunAway();

	align_node = GetEnt( "exchange_org", "targetname" );
	
	level.exchanger_surprise_time = 0.5;
	guard = baddies[ 0 ];
	dealer = baddies[ 1 ];
	baddies[ 2 ] = level.zakhaev;	
	
	level.zakhaev.animname = "zakhaev";
	guard.animname = "guard";
	dealer.animname = "dealer";
	
	briefcase = spawn_anim_model( "briefcase" );
	briefcase.animname = "briefcase";
	briefcase UseAnimTree( level.scr_animtree[ "briefcase" ] );	
	baddies[ 3 ] = briefcase;	

	level.shorten_amount = .35;
	level thread flag_drop();
	time = getanimlength( level.zakhaev getanim("exchange_short") );  
	align_node thread anim_single( baddies, "exchange_short" );
	array_thread( baddies, ::shorten_scene );
		
	wait( time * level.shorten_amount );

	baddies = array_remove( baddies , briefcase );
	wait( 0.05 );
	array_thread( baddies, ::run_to_node_delete );

	end_pos = level.zakhaev GetTagOrigin( "J_Shoulder_LE" );
	level.zakhaev thread zak_dies();
	
	flag_wait( "zakhaev_shot" );
	thread play_sound_in_space( "zak_shot_pain1", end_pos );
	
	s_sniper_shot_start = getstruct( "sniper_shot_start", "targetname" );
	level thread move_bullet_through_space( s_sniper_shot_start.origin, end_pos );
	

//	wait( 2 );
//
//	s_sniper_second_shot = getstruct( "sniper_second_shot", "targetname" );
//	level thread move_bullet_through_space( s_sniper_shot_start.origin, s_sniper_second_shot.origin, s_sniper_second_shot );

	flag_wait( "spawn_onearm_zakhaev" );

	wait( 1.25 );

	s_sniper_third_shot = getstruct( "sniper_third_shot", "targetname" );
	level thread move_bullet_through_space( s_sniper_shot_start.origin, s_sniper_third_shot.origin );	
}


shorten_scene()
{	
	self anim_self_set_time( "exchange_short", level.shorten_amount);	
}
	
flag_drop()
{
	wait( 30 );
	
// IPrintLnBold( "flag drops" );
	flag_wait( "drop_the_flag" );	
	
	level notify( "wind_stops_flunctuating" );
	level.wind_vel = 0;
	// Ok take the shot.
	level.wind_setting = "end";	
}

run_to_node_delete()
{
	self endon( "death" );
	
	self.goalradius = 32;
	
	delete_guards_node = GetNode( "delete_guards_node", "targetname" );
	self SetGoalNode( delete_guards_node );
	self waittill( "goal" );
	self Delete();
}

move_bullet_through_space( v_start_pos, v_end_pos, physics_org )
{
 	m_bullet = Spawn( "script_model", v_start_pos );
	m_bullet SetModel( "tag_origin" );

	e_muzzle_org = GetEnt( "sniper_glint_org", "script_noteworthy" );
	v_Fwd = AnglesToForward( e_muzzle_org.angles );
	
	PlayFX( getfx( "sniper_muzzle_flash" ), e_muzzle_org.origin, v_Fwd );	
	PlayFXOnTag( getfx( "bullet_geo_flashback" ), m_bullet, "tag_origin" );
	
	m_bullet MoveTo( v_end_pos, .05 );	

	if ( IsDefined( physics_org ) )
	{
		m_bullet waittill( "movedone" );
		PhysicsExplosionSphere( physics_org.origin, 6, 3, 1 );
	}

	wait( 0.50 );

	//level.player PlaySound( "scn_prague_50cal_sniper_fire" );	
	thread play_sound_in_space( "soap_weapon_fire", v_start_pos );
	m_bullet Delete();
}

sniper_shot_reaction()
{
	self endon( "death" );
	
	flag_wait( "zakhaev_shot" );
		
	surprise_anim = "exchange_surprise_" + RandomInt( level.surprise_anims );

	wait( RandomFloatRange( 0.2, 0.4 ) );	
	
	stop_loop();
	self stopanimscripted();
	self anim_generic_custom_animmode( self, "gravity", surprise_anim );
	self clear_run_anim();
	self.disableexits = false;	
	self.animname = "enemy";
	self set_run_anim( "sprint" );
}

stop_loop()
{
	// tell our target to stop looping us
	if ( !IsDefined( self.target ) )
	{
		self notify( "stop_loop" );
		return;
	}

	targ = GetEnt( self.target, "targetname" );
	if ( IsDefined( targ ) )
	{
		targ notify( "stop_loop" );
		return;
	}

	targ = GetNode( self.target, "targetname" );
	if ( IsDefined( targ ) )
	{
		targ notify( "stop_loop" );
		return;
	}
}

wind_setting()
{
	level endon( "start_nuke_transition" ); //flag is set when second guy is hit by car
	
	min = 25;
	max = 100;

	level.wind_vel = 100;
	level.wind_setting = "middle";
		
	for ( ;; )
	{
		wind_change = RandomIntRange( 8, 16 );
		
		if ( cointoss() )
		{
			wind_velocity = level.wind_vel + wind_change;
		}
		else
		{
			wind_velocity = level.wind_vel - wind_change;
		}
		if ( wind_velocity > min && wind_velocity < max )
		{	
			level.wind_vel = wind_velocity;
		}
		
//	IPrintLn( level.wind_vel );
		
		wait RandomIntRange( 1, 3 );
	}
}

uaz_and_soldiers()
{
	run_thread_on_targetname( "leaning_smoker", ::add_spawn_function, ::lean_and_smoke );
	run_thread_on_targetname( "standing_smoker", ::add_spawn_function, ::stand_and_smoke );
	run_thread_on_targetname( "standing_bored", ::add_spawn_function, ::stand_bored );
	run_thread_on_targetname( "standing_cellphone", ::add_spawn_function, ::stand_cellphone_bored );
	run_thread_on_noteworthy( "smoke_and_run", ::add_spawn_function, ::smoke_and_run );		
	run_thread_on_targetname( "middle_uaz_driver", ::add_spawn_function, ::setup_middle_uaz_driver );

	a_smoke_and_run = GetEntArray( "smoke_and_run", "targetname" );
	array_thread( a_smoke_and_run, ::spawn_ai );

	a_leaning_smoker = GetEntArray( "leaning_smoker", "targetname" );
	array_thread( a_leaning_smoker, ::spawn_ai );

	a_standing_smoker = GetEntArray( "standing_smoker", "targetname" );
	array_thread( a_standing_smoker, ::spawn_ai );

	a_standing_cellphone = GetEntArray( "standing_cellphone", "targetname" );
	array_thread( a_standing_cellphone, ::spawn_ai );	

	a_standing_bored = GetEntArray( "standing_bored", "targetname" );
	array_thread( a_standing_bored, ::spawn_ai );	

	a_escape_runners = GetEntArray( "escape_runners", "targetname" );
	array_thread( a_escape_runners, ::add_spawn_function, ::setup_escape_runners );

	middle_uaz_driver = GetEnt( "middle_uaz_driver", "targetname" );
	ai_middle_uaz_driver = middle_uaz_driver spawn_ai( true );

	//VEHICLES
	front_uaz = spawn_vehicle_from_targetname( "front_uaz" );
	front_uaz.targetname = "front_uaz";
	front_uaz vehicle_turnengineoff();
	
	middle_uaz = spawn_vehicle_from_targetname( "middle_uaz" );
	middle_uaz maps\_vehicle::vehicle_unload();
	middle_uaz.targetname = "middle_uaz";
	middle_uaz vehicle_turnengineoff();
		
	zaks_ride = spawn_vehicle_from_targetname( "zaks_ride" );
	zaks_ride.targetname = "zaks_ride";		
	zaks_ride vehicle_turnengineoff();
			
	//BACK PARKED UAZs
	front_uaz_parked = spawn_vehicle_from_targetname( "front_uaz_parked" );
	front_uaz_parked.targetname = "front_uaz_parked";	
	front_uaz_parked vehicle_turnengineoff();
	
	middle_parked = spawn_vehicle_from_targetname( "middle_parked" );
	middle_parked.targetname = "middle_parked";	
	middle_parked vehicle_turnengineoff();
	
	back_parked = spawn_vehicle_from_targetname( "back_parked" );
	back_parked.targetname = "back_parked";	
	back_parked vehicle_turnengineoff();
	
	wait( 0.05 );
	
	cleanup_veh_spawner();
	
	level thread wind_setting();
	level thread exchange_wind_flag();
	level thread exchange_wind_generator();
		
	run_thread_on_targetname( "flag_org", ::exchange_flag );

	vh_heli = spawn_vehicle_from_targetname_and_drive( "heli_exchange_deal" );
	vh_heli thread block_helicopter();

	flag_wait( "zakhaev_shot" );
	
	trig_front_uaz_go = GetEnt( "front_uaz_go", "targetname" );
	front_uaz thread front_uaz_spline_watch();
	front_uaz thread uaz_load_and_go( trig_front_uaz_go );
	
	trig_middle_uaz_go = GetEnt( "middle_uaz_go", "targetname" );
	middle_uaz thread uaz_load_and_go( trig_middle_uaz_go );

	trig_zaks_ride_go = GetEnt( "zaks_ride_go", "targetname" );
	zaks_ride thread uaz_load_and_go( trig_zaks_ride_go );
	
	//back parked UAZ's
	trig_front_parked_go = GetEnt( "front_parked_go", "targetname" );
	front_uaz_parked thread front_parked_spline_watch();
	front_uaz_parked thread uaz_load_and_go( trig_front_parked_go );		

	trig_middle_parked_go = GetEnt( "middle_parked_go", "targetname" );
	middle_parked thread middle_parked_spline_watch();
	middle_parked thread uaz_load_and_go( trig_middle_parked_go );		
	
	trig_back_parked_go = GetEnt( "back_parked_go", "targetname" );
	back_parked thread uaz_load_and_go( trig_back_parked_go );	

	//level thread heli_flyover_uaz();
}

nuke_transition_timer()
{
	flag_wait( "start_nuke_transition" ); 
	wait( .5 );
	
	level.player PlaySound( "scn_prague_flash_airlift" );
	level.player delayThread( 2.0, ::play_sound_on_entity, "presc_yri_neverforgot2" );
	music_stop(1);
	flashback_teleport( "sniper_escape_done", "start_nuke_scene", "prague_escape_airlift", 0.25, 3, undefined, .75 );
}

heli_flyover_uaz()
{
	wait( 13 );
	
	heli_flyover_uaz = spawn_vehicle_from_targetname( "heli_flyover_uaz" );
	heli_flyover_uaz SetNearGoalNotifyDist( 20 );
	heli_flyover_uaz thread helipath( heli_flyover_uaz.target, 45, 45 );	
	
	//flag_wait( "start_nuke_scene" );
	flag_wait("sniper_escape_done");
	
	heli_flyover_uaz Delete();
}

setup_middle_uaz_driver()
{
	self endon( "death" );
	
	self.ignoreall = true;
	self.ignoreme = true;

	targ = GetNode( self.target, "targetname" );
		
	self.walkdist = 1000;
	self.fixednode = true;
	self SetGoalNode( targ );
	self.disableexits = true;
	self.disablearrivals = true;
	self set_generic_run_anim( "stealth_walk" );// "stealth_jog", false );
	self.goalradius = 16;
	
	sniper_shot_reaction();	
	
	self.script_vehicleride = 301;	

	uaz = maps\_vehicle_aianim::get_my_vehicleride();	
	uaz vehicle_load_ai_single( self, undefined, "all" );	
}

lean_and_smoke()
{
	self endon( "death" );
	
	self.ignoreall = true;
	self.ignoreme = true;

	wait( RandomFloatRange( 0.1, 0.5 ) );	
	
	anim_node = GetEnt( self.target, "targetname" );
	anim_node thread anim_generic_loop( self, "smoking_lean_idle" );

	flag_wait( "zakhaev_shot" );
		
	wait( RandomFloatRange( 0.2, 0.4 ) );	
	
	stop_loop();
	self stopanimscripted();
	self anim_generic_custom_animmode( self, "gravity", "smoking_lean_react" );
	self clear_run_anim();
	self.disableexits = false;	
	self.animname = "enemy";
	self set_run_anim( "sprint" );
			
	switch( self.script_noteworthy )
	{
		case "front_uaz_guard":
			self.script_vehicleride = 300;
			break;		
		case "middle_uaz_smoker":
			self.script_vehicleride = 301;
			break;
		case "middle_parked_guard":
			self.script_vehicleride = 304;
			break;
		case "zak_uaz_rider":
			self.script_vehicleride = 302;
			break;
	}

	uaz = maps\_vehicle_aianim::get_my_vehicleride();	
	uaz vehicle_load_ai_single( self, undefined, "all" );
}

stand_and_smoke()
{
	self endon( "death" );

	self.ignoreall = true;
	self.ignoreme = true;
	
	anim_node = GetEnt( self.target, "targetname" );
	anim_node thread anim_generic_loop( self, "smoke_idle" );
	
	sniper_shot_reaction();

	switch( self.script_noteworthy )
	{
		case "zak_uaz_rider":
			self.script_vehicleride = 302;
			break;
		case "middle_parked_guard":
			self.script_vehicleride = 304;
			break;
		case "smoke_and_run":
			break;	
	}
		
	uaz = maps\_vehicle_aianim::get_my_vehicleride();	
	uaz vehicle_load_ai_single( self, undefined, "all" );	
}

stand_bored()
{
	self endon( "death" );

	self.ignoreall = true;
	self.ignoreme = true;
	
	anim_node = GetEnt( self.target, "targetname" );
	anim_node thread anim_generic_loop( self, "bored_idle" );
	
	sniper_shot_reaction();

	switch( self.script_noteworthy )
	{
		case "front_uaz_parked_guard":
			self.script_vehicleride = 305;
			break;
		case "middle_parked_guard":
			self.script_vehicleride = 304;
			break;
		case "zak_uaz_rider":
			self.script_vehicleride = 302;
			break;	
	}
		
	uaz = maps\_vehicle_aianim::get_my_vehicleride();	
	uaz vehicle_load_ai_single( self, undefined, "all" );		
}

stand_cellphone_bored()
{
	self.ignoreall = true;
	self.ignoreme = true;
	
	anim_node = GetEnt( self.target, "targetname" );
	anim_node thread anim_generic_loop( self, "smoke_idle" );
	//self attach("com_hand_radio", "tag_weapon_right");
	
	sniper_shot_reaction();

	switch( self.script_noteworthy )
	{
		case "back_parked_guard":
			self.script_vehicleride = 303;
			break;
		case "front_uaz_guard":
			self.script_vehicleride = 300;
			break;	
	}
	
	uaz = maps\_vehicle_aianim::get_my_vehicleride();	
	uaz vehicle_load_ai_single( self, undefined, "all" );			
}

smoke_and_run()
{
	self endon( "death" );
	
	targ = GetEnt( self.target, "targetname" );
	targ thread anim_generic_loop( self, "smoke_idle" );	
	
	sniper_shot_reaction();
	run_to_node_delete();	
}

front_uaz_spline_watch()
{
	node = GetVehicleNode( "front_uaz_gone", "script_noteworthy" );
	node waittill( "trigger" );
	flag_set( "front_uaz_gone" );	
}

front_parked_spline_watch()
{
	node = GetVehicleNode( "front_parked_gone", "script_noteworthy" );
	node waittill( "trigger" );
	flag_set( "front_parked_gone" );		
}

middle_parked_spline_watch()
{
	node = GetVehicleNode( "middle_parked_gone", "script_noteworthy" );
	node waittill( "trigger" );
	flag_set( "middle_parked_gone" );	
}

uaz_load_and_go( trig )
{
	self waittill( "loaded" );

	switch( self.targetname )
	{
		case "front_uaz":
			wait( 0.25 );
			break;
		case "middle_uaz":
			flag_wait( "front_uaz_gone" );
			break;
		case "zaks_ride":
			wait( 0.25 );
			break;
		case "middle_parked":
			wait( 0.25 );
			flag_wait( "front_parked_gone" );
			break;					
		case "back_parked":
			wait( 0.25 );
			flag_wait( "middle_parked_gone" );
			break;			
	}
	
//	IPrintLn( trig.targetname + " Go Pathed!" );	
	trig notify( "trigger" );	
	self waittill( "reached_end_node" );
	self Delete();
}

bullet_strikes_scene()
{
	flag_wait( "zakhaev_shot" );
	
	//wait until player looks down in nextscene
	wait( 1 );	
	
	e_nuke_stream_ent = GetEnt( "nuke_stream_ent", "targetname" );		
	level.player PlayerSetStreamOrigin( e_nuke_stream_ent.origin );
	
	level thread victims_escape();	
	level thread zakhaev_escape();
	
	level.ai_makarov_oneshot Show();
	level.m_player_rig Show();	
	
	a_anim_ents = [];
	a_anim_ents[0] = level.ai_makarov_oneshot;
	a_anim_ents[1] = level.player_uaz;
	a_anim_ents[2] = level.m_player_rig;
	a_anim_ents[3] = level.zakhaev_onearm;
	
	level.zakhaev_onearm delaythread(3, ::play_sound_on_entity, "zak_pain_car" );
	level.player_uaz delaythread(5, ::play_sound_on_entity, "zak_lands_on_car" );
	
	level.player PlayerLinkToAbsolute( level.m_player_rig, "tag_player" );	
	
	//play narration in the car ride out
	level.player delaythread(9.35, ::play_sound_on_entity, "presc_yri_neverforgot" );
	
	level.s_uaz_align anim_single( a_anim_ents, "bullet_strikes" );

	array_thread( a_anim_ents, ::self_delete );
}

hit_1_rumble_fx( guy ) //notetrack calls this
{
	//first car hit victim
	wait(1);
	flag_set("start_nuke_transition");
	level.player PlayRumbleOnEntity( "grenade_rumble" );	
	Earthquake( 0.4, 0.5, level.player.origin, 512 );	
	PlayFXOnTag( getfx( "car_impact_1_flashback" ), level.player_uaz, "tag_origin" );	
}

hit_2_rumble_fx( guy ) //notetrack calls this
{
	level.player PlayRumbleOnEntity( "grenade_rumble" );	
	Earthquake( 0.4, 0.5, level.player.origin, 512 );		
	PlayFXOnTag( getfx( "car_impact_2_flashback" ), level.player_uaz, "tag_origin" );
}

bullet_strikes_headlook( guy )
{
	
	level.player PlayerLinkToBlend( level.m_player_rig, "tag_player" );
	level.player PlayerLinkToDelta( level.m_player_rig, "tag_player", 0, 15, 30, 15, 15, true );	
}

sniper_glint()
{
	fx = getfx( "sniper_glint" );
	e_sniper_glint_org = GetEnt( "sniper_glint_org", "script_noteworthy" );
	
	flag_wait( "play_sniper_glint" );
	wait( 2 );	
	PlayFX( fx, e_sniper_glint_org.origin );
	wait( 0.50 );
	PlayFX( fx, e_sniper_glint_org.origin );
	
	flag_wait( "play_sniper_glint_2" );		
	PlayFX( fx, e_sniper_glint_org.origin );
	wait( 0.50 );	
	PlayFX( fx, e_sniper_glint_org.origin );	
}

victims_escape()
{
	//these are the guys who get hit by the truck
	flag_wait( "spawn_escape_victims" );
	
	//truck is just turning to leave at this point..
	a_escape_runners = GetEntArray( "escape_runners", "targetname" );
	array_thread( a_escape_runners, ::spawn_ai );
		
	ai_guard_1_victim = get_guy_with_targetname_from_spawner( "guard_1_victim" );
	ai_guard_2_victim = get_guy_with_targetname_from_spawner( "guard_2_victim" );

	ai_guard_1_victim.animname = "guard_1";
	ai_guard_2_victim.animname = "guard_2";

	a_victims = [];
	a_victims[0] = ai_guard_1_victim;
	a_victims[1] = ai_guard_2_victim;
	
	array_thread( a_victims, ::gun_remove );
	
	level.s_uaz_align anim_single( a_victims, "bullet_strikes" );
	
	array_thread( a_victims, ::self_delete );
}

zakhaev_escape()
{
	flag_wait( "spawn_onearm_zakhaev" );

	level.zakhaev_onearm Show();
	PlayFXOnTag( getfx( "zak_arm_blood" ), level.zakhaev_onearm, "J_Shoulder_LE" );		
}

zak_dies()
{
	//self = Zak
	self.health = 50000;
	self endon( "death" );
	self disable_long_death();
	
	zakmodel = spawn_anim_model( "zakhaev" );
	zakmodel Hide();
	zakmodel LinkTo( self, "tag_origin", ( 0, 0, 0 ), ( 0, 0, 0 ) );

	PlayFXOnTag( getfx( "blood" ), self, "J_Shoulder_LE" );
	
	run_thread_on_targetname( "blood_pool", ::blood_pool );

	zakmodel Unlink();
	ent = spawn( "script_origin", ( 0, 0, 0 ) );
	ent.origin = self.origin;
	yaw = 135;
	ent.angles = ( 0, yaw, 0 );

	org = GetStartOrigin( ent.origin, ent.angles, level.scr_anim[ "zak_left_arm" ][ "zak_pain" ] );
	arm_model = spawn_anim_model( "zak_left_arm", org );
	arm_model thread zak_arm_blood();

	ent anim_first_frame_solo( arm_model, "zak_pain" );
	ent thread anim_single_solo( zakmodel, "zak_pain" );
	ent delaythread( 0.05, ::anim_single_solo, arm_model, "zak_pain" );
	
	thread play_sound_in_space ( "scn_prague_sniped_bulletimpact", self.origin);
	
	zakmodel thread zak_blood();
	zakmodel thread zak_blood_pool();
	zakmodel thread zakmodel_delete();

	flag_set( "zakhaev_shot" );	

	zakmodel Show();
	self Delete();
}

zakmodel_delete()
{
	flag_wait( "spawn_onearm_zakhaev" );
	
	level notify( "stop_zak_blood" );
	self stopanimscripted();	
	self Delete();	
}

zak_blood()
{
	level endon( "stop_zak_blood" );

	for ( ;; )
	{
		PlayFXOnTag( getfx( "blood" ), self, "J_Shoulder_LE" );
		wait( 0.1 );
	}
}

zak_arm_blood()
{
	/*
	tags = [];
	tags[ tags.size ] = "J_Clavicle_LE";
	tags[ tags.size ] = "TAG_INHAND";
	tags[ tags.size ] = "J_Shoulder_LE";
	tags[ tags.size ] = "J_Elbow_Bulge_LE";
	tags[ tags.size ] = "J_Elbow_LE";
	tags[ tags.size ] = "J_ShoulderTwist_LE";
	tags[ tags.size ] = "J_Wrist_LE";
	tags[ tags.size ] = "J_WristTwist_LE";
	tags[ tags.size ] = "TAG_WEAPON_LEFT";

	self array_levelthread( tags, maps\_debug::drawtagforever );
	*/

//	self thread maps\_debug::drawtagforever( "J_Shoulder_LE" );

	rate = 0.2;
	timer = 0.5;
	zak_arm_blood_pump( timer, self, rate );
	wait( 0.5 );
	zak_arm_blood_pump( timer, self, rate );
	wait( 0.5 );
	zak_arm_blood_pump( timer, self, rate );
	wait( 0.5 );
	zak_arm_blood_pump( timer, self, rate * 0.5 );
	wait( 0.5 );
	zak_arm_blood_pump( timer, self, rate * 0.25 );
	wait( 0.5 );

	if ( 1 )
		return;
		
//	self thread maps\_debug::drawtagforever( "J_Shoulder_LE" );

	model = spawn( "script_model", ( 0, 0, 0 ) );
	model setmodel( "tag_origin" );
	model linkto( self, "J_Shoulder_LE", ( 0, 0, 0 ), ( 0, 0, 0 ) );
	model thread maps\_debug::drawtagforever( "tag_origin" );


	for ( i = 0; i < timer; i++ )
	{
		PlayFXOnTag( getfx( "blood" ), model, "tag_origin" );
		wait( rate );
	}

	wait( 5 );
	model delete();
}

zak_arm_blood_pump( timer, model, rate )
{
	timer = timer * ( 1 / rate );
	for ( i = 0; i < timer; i++ )
	{
		PlayFXOnTag( getfx( "blood" ), model, "J_Shoulder_LE" );
		wait( rate );
	}
}

zak_blood_pool()
{
	level endon( "stop_zak_blood" );
	
	wait( 1 );
	blood_pool = GetEnt( "blood_pool", "targetname" );
	z = blood_pool.origin[ 2 ];

	for ( ;; )
	{
		start = self GetTagOrigin( "J_Shoulder_LE" ) + ( 0, 0, 50 );
		end = start + ( 0, 0, -250 );
		trace = BulletTrace( start, end, false, undefined );
		pos = ( trace[ "position" ][ 0 ], trace[ "position" ][ 1 ], z );
		PlayFX( getfx( "blood_pool" ), pos, ( 0, 0, 1 ) );
		wait( 0.35 );
	}
}

blood_pool()
{
	level endon( "stop_zak_blood" );
	
	pool = self;
	// spreads from under the table
	count = 5;
	for ( ;; )
	{
		PlayFX( getfx( "blood_pool" ), pool.origin + ( 0, 0, 1 ), ( 0, 0, 1 ) );
		count -- ;
		if ( count <= 0 )
			wait( 0.3 );
		if ( !IsDefined( pool.target ) )
			return;
		pool = GetEnt( pool.target, "targetname" );
	}
}

setup_background_patroller()
{
	self endon( "death" );
	
	targ = GetNode( self.target, "targetname" );
	
	self set_ignoreall( true );
	self.walkdist = 1000;
	self.fixednode = true;
	self SetGoalNode( targ );
	self.disableexits = true;
	self.disablearrivals = true;
	self set_generic_run_anim( "stealth_walk" );
	self.goalradius = 16;
	
	sniper_shot_reaction();	
	
	self.fixednode = false;
	self thread run_to_node_delete();		
}

setup_escape_runners()
{
	self endon( "death" );
	
	self set_ignoreall( true );
	self.disableexits = true;
	self.disablearrivals = true;	
	
	nd_delete_runners = GetNode( "delete_runners_node", "targetname" );
	
	self SetGoalNode( nd_delete_runners );
	self waittill( "goal" );
	self Delete();	
}

//TODO: Give a script_noteworthy on the UAZ's and grab them all and clean up spawner
cleanup_veh_spawner()
{
	//-- cleanup the spawner
	a_vehicles = GetEntArray("front_uaz", "targetname");
	foreach ( veh in a_vehicles )
	{
		if( IsSpawner(veh) )
		{
			veh Delete();
		}
	}	

	//-- cleanup the spawner
	a_vehicles = GetEntArray("middle_uaz", "targetname");
	foreach ( veh in a_vehicles )
	{
		if( IsSpawner(veh) )
		{
			veh Delete();
		}
	}
	
	//-- cleanup the spawner
	a_vehicles = GetEntArray("zaks_ride", "targetname");
	foreach ( veh in a_vehicles )
	{
		if( IsSpawner(veh) )
		{
			veh Delete();
		}
	}	
	
	//-- cleanup the spawner
	a_vehicles = GetEntArray("front_uaz_parked", "targetname");
	foreach ( veh in a_vehicles )
	{
		if( IsSpawner(veh) )
		{
			veh Delete();
		}
	}		
	
	//-- cleanup the spawner
	a_vehicles = GetEntArray("middle_parked", "targetname");
	foreach ( veh in a_vehicles )
	{
		if( IsSpawner(veh) )
		{
			veh Delete();
		}
	}		
	
	//-- cleanup the spawner
	a_vehicles = GetEntArray("back_parked", "targetname");
	foreach ( veh in a_vehicles )
	{
		if( IsSpawner(veh) )
		{
			veh Delete();
		}
	}	
}

exchange_flag()
{	
	level endon( "start_nuke_transition" ); //flag is set when second guy is hit by car
	
	flag = spawn_anim_model( "flag" );
	flag.origin = self.origin;
	flag.angles = self.angles;

	vehicle = GetEnt( self.script_linkto, "script_linkname" );
	self LinkTo( flag );
	flag LinkTo( vehicle );
	flag thread exchange_flag_rotates();
	flag thread exchange_flag_relinks( vehicle );

//	blend = randomfloatrange( 50, 99 ) * 0.01;
	blend = 0;
	rate = 0.5;
	for ( ;; )
	{
		// blend the flag to the current wind vel
		desired_blend = level.wind_vel / 100;
		if ( desired_blend < 0 )
			desired_blend = 0;
		else
		if ( desired_blend > 0.99 )
			desired_blend = 0.99;

		if ( blend < desired_blend )
		{
			blend += rate;
			if ( blend > desired_blend )
				blend = desired_blend;
		}
		else
		{
			blend -= rate;
			if ( blend < desired_blend )
				blend = desired_blend;
		}

		blendtime = RandomFloatRange( 0.1, 1 );
		flag SetAnim( flag getanim( "up" ), blend, blendtime, 5 );
		flag SetAnim( flag getanim( "down" ), 1 - blend, blendtime, 5 );
		wait( blendtime );
	}
}

exchange_flag_rotates()
{
	level endon( "start_nuke_transition" ); //flag is set when second guy is hit by car
	
	wait( 0.1 );// wait to get linked up and for the vehicle to settle
	self Unlink();

	for ( ;; )
	{
		level waittill( "wind_flag_rotation", rotation, timer );
		self RotateYaw( rotation, timer, timer * 0.25, timer * 0.25 );
	}
}

exchange_flag_relinks( vehicle )
{
	waittillframeend;// wait for flag to be initialized
//	vehicle ent_flag_wait( "time_to_go" );
//	flag_wait_either( "zak_uaz_leaves", "player_attacks_exchange" );
	flag_wait( "spawn_onearm_zakhaev" );
	self.angles = ( 0, vehicle.angles[ 1 ] + 180, 0 );
	self LinkTo( vehicle );

//	level notify( "wind_stops_flunctuating" );
	level.wind_vel = 80;
	// Ok take the shot.
	level.wind_setting = "middle";	
	

	flag_wait( "start_nuke_transition" ); //flag is set when second guy is hit by car
	self Delete();
}

exchange_wind_generator()
{
	range = 140;
	for ( ;; )
	{
		timer = RandomFloatRange( 0.3, 0.9 );
		level notify( "wind_flag_rotation", RandomInt( range ) - range * 0.5, timer );
		wait( timer );
	}
}

exchange_wind_flag()
{
	wind_flag = GetEnt( "wind_flag", "script_noteworthy" );
	wind_flag endon( "death" );

	for ( ;; )
	{
		forward = AnglesToForward( wind_flag.angles );
		level.wind_vec = ( forward * level.wind_vel );
		 /#
		if ( GetDvar( "nowind" ) != "" )
			level.wind_vec = ( 0, 0, 0 );
		#/
		wait( 0.05 );
	}
}

makarov_no_time_dialogue( guy )
{
	level.ai_makarov_oneshot dialogue_queue( "presc_mkv_wearelucky" );	
	flag_wait( "makarov_no_time_dialogue03" );
	level.ai_makarov_oneshot dialogue_queue( "presc_mkv_tensofmillions" );	
	flag_wait( "makarov_no_time_dialogue04" );
	level.ai_makarov_oneshot dialogue_queue( "presc_mkv_moneycan" );		
	flag_wait( "makarov_no_time_dialogue05" );	
	level.ai_makarov_oneshot dialogue_queue( "presc_mkv_roadtothefuture" );			
	
	flag_wait( "makarov_bullet_strike_dialogue03" );	
	level.ai_makarov_oneshot dialogue_queue( "presc_mkv_itsanattack" );				

	flag_wait( "zakhaev_bullet_strike_dialogue04" );	
	level.zakhaev_onearm dialogue_queue( "presc_rl_getusout" );				
}

zakhaev_deal_dialogue( guy )
{
	level.scr_radio[ "presc_yri_firstmetmakarov" ] = "presc_yri_firstmetmakarov";
	level.scr_radio[ "presc_yri_neverforgot" ] = "presc_yri_neverforgot";
	
	//level.zakhaev dialogue_queue( "presc_zkv_whatdoyou" );	
	level.zakhaev play_sound_on_entity( "presc_zkv_whatdoyou" );	
	
	flag_wait( "zakhaev_exchange_hadadeal" );
	level.zakhaev dialogue_queue( "presc_zkv_hadadeal" );	
	
	wait(4);
	//"I was young and patriotic when I first met Vladimir Makarov.."
	//radio_dialogue( "presc_yri_firstmetmakarov");
	
	flag_wait( "zakhaev_exchange_argueover" );
	level.zakhaev dialogue_queue( "presc_zkv_argueover" );
	flag_wait( "zakhaev_exchange_knownbetter" );
	level.zakhaev dialogue_queue( "presc_zkv_knownbetter" );	
}

take_care_of_fake_weapon_tag()
{
	weapons = getentarray( "fake_ak_models", "targetname");
	
	for(i = 0; i < weapons.size; i++)
	{
		weapons[i] HidePart( "TAG_Shotgun" );
		weapons[i] HidePart( "TAG_SILENCER" );
		weapons[i] HidePart( "TAG_THERMAL_SCOPE" );	
		weapons[i] HidePart( "TAG_RETICLE_ACOG" );	
		weapons[i] HidePart( "TAG_RETICLE_RED_DOT" );
		weapons[i] HideAllParts();
	}
	
}
