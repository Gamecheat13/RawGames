#include maps\_utility;
#include common_scripts\utility;
#include maps\_anim;
#include maps\_vehicle;
#include maps\prague_code;
#include maps\_util_carlos;
#include maps\_util_carlos_stealth;

main()
{
	array_spawn_function_targetname( "dock_civs", ::dock_civs_think );
	array_spawn_function_targetname( "docks_enemies", ::docks_enemies_think );

	array_spawn_function_targetname( "new_cargo_heli", ::cargo_heli_think );
	array_spawn_function_targetname( "new_cargo_heli", ::build_heli_rumble_unique );

	array_spawn_function_targetname( "new_intro_moving_btr", ::bridge_vehicles_think );
	array_spawn_function_targetname( "bridge_civ", ::bridge_civ_think );
	
	array_thread( getentarray( "slow_swim_trigger", "targetname" ), ::slow_swim_trigger );
	array_thread( getentarray( "fast_swim_trigger", "targetname" ), ::fast_swim_trigger );
	
	flag_init( "city_reveal" );
	flag_init( "fade_up" );
	flag_init( "start_new_intro" );
	flag_init( "player_swimming" );
	flag_init( "player_swim_faster" );
	flag_init( "start_intro_anim" );
	 
	setsaveddvar( "r_specularColorScale", 4 ); //  We need to set it up so it goes dry in 
}

start_new_intro()
{
	spawn_sandman();
	spawn_price();
	set_start_positions( "start_new_intro" );

	setSavedDvar( "hud_showStance", "0" );
	setSavedDvar( "compass", "0" );
	
//	level.price thread enable_ai_swim();
//	level.sandman thread enable_ai_swim();

	flag_set( "fade_up" );	
	flag_set( "city_reveal" );
	
	thread canal_spotlight();
	
//	array_spawn_targetname( "bridge_civ" );
	array_spawn_targetname( "dock_civs" );
	array_spawn_targetname( "docks_enemies" );
	
	level.player disableWeapons();
	level.player AllowSprint( false );
	level.player AllowStand( false );
	level.player AllowProne( false );
	level.player setStance( "crouch" );
	
	node = get_target_ent( "price_intro_node" );
	level.price anim_spawn_tag_model( "prop_price_cigar", "tag_inhand" );
	level.price thread jump_in_water( node );
	level.sandman thread jump_in_water( node );
	
	thread intro_dialogue();
	
	org = level.player spawn_tag_origin();
	level.player PlayerLinkToDelta( org, "tag_origin", 1, 80, 80, 80, 80 );
	level.player player_Speed_Percent( 60, 0.05 );
	light = get_target_ent( "sewer_intro_light" );
	light setLightIntensity( 0 );
//	level.price thread dialogue_queue( "prague_pri_welcome2" );
	wait( 3.2 );
	flag_set( "start_intro_anim" );
	thread intro_dof();
//	level.player AllowStand( true );
	wait( 2.5 );
	thread intro_light_fadein( light );
	wait( 10 );
	level.player unlink();
}

intro_dof()
{
	defaultdof = level.dofdefault;
	
	introdof = [];
	introdof[ "nearStart" ] = 0;
	introdof[ "nearEnd" ] = 0;
	introdof[ "farStart" ] = 15;
	introdof[ "farEnd" ] = 760;
	introdof[ "nearBlur" ] = 7.5;
	introdof[ "farBlur" ] = 5;
	
	blend_dof( defaultdof, introdof, 0.3 );
	wait( 4.5 );
	blend_dof( introdof, defaultdof, 3 );
}

intro_dialogue()
{
	flag_wait( "start_intro_anim" );
	delaythread( 0.8, ::spawn_vehicles_from_Targetname_and_drive, "new_intro_heli" );
	wait( 6 );
	//level.price thread dialogue_queue( "prague_pri_letsmove2" );
	wait( 2.3 );
	node = get_target_ent( "cigar_drop" );
	PlayFX( getfx( "cigar_hit_water" ), node.origin );
	PlayFX( getfx( "water_wake_objects" ), node.origin );
}

intro_light_fadein( light )
{
	while( light getLightIntensity() < 2 )
	{
		i = light getLightIntensity();
		i += 0.05;
		light setLightIntensity( i );
		wait( 0.25 );
	}
}

jump_in_water( node )
{
	playfxOnTag( getfx( "cigar_glow_no_dlight" ), level.price, "tag_cigarglow" );
	node thread anim_first_frame_solo( self, "intro" );
	flag_wait( "start_intro_anim" );
	node notify( "stop_first_frame" );
	node anim_single_solo( self, "intro" );	
	self thread enable_ai_swim();
	self thread animscripts\utility::PersonalColdBreath();
}

player_bubbles()
{
	level endon( "stop_bubbles" );
	
	while( 1 )
	{
		PlayFx( getfx( "scuba_bubbles" ), level.player geteye() );
		wait( RandomFloatRange( 2,3 ) );
	}
}

player_stop_swimming( node )
{
	wait( 15.0 );
	level notify( "stop_bubbles" );
	
	node waittill( "swim_up" );
	
	level.player unlink();
}

new_intro_setup()
{
	setsaveddvar( "ai_friendlyFireBlockDuration", 0 );
	delayThread ( 0.0, ::music_play, "prague_tension_3" );
	flag_wait( "city_reveal" );
	thread maps\_utility::set_ambient( "prague_sewers" );
//	music_play( "prague_tension_1" );
	
//	level.player thread play_sound_on_entity( "scn_prague_plr_break_surface" );
//	level.player delaythread( 0.8, ::play_sound_on_entity, "scn_prague_plr_surface_breathe" );
	
	thread mass_murder();
	thread dock_drag();
	thread team_movement();
	thread player_surface_blur();
	thread player_swim_think();
	thread bodydump();
	thread rocking_items();
	thread dock_step_forward();
	thread dock_dog();
	thread spotted_reactions();
	thread mean_guard();
	thread docks_talking();
}

docks_talking()
{
	level endon( "docks_stop_talking" );
	level endon( "_stealth_spotted" );
	level endon( "start_sewers" );
	flag_wait( "docks_get_down" );
	ai = getAIArray( "axis" );
	group_flavorbursts( ai, "ru", 3, 3, true, "start_sewers" );
}

dock_drag()
{
	flag_init( "dock_drag_done" );
	level endon( "_stealth_spotted" );
	flag_wait( "start_dock_drag" );
	civ = spawn_targetname( "drag_civ" );
	civ thread drone_proper_death();
	
	enemy = spawn_targetname( "drag_enemy" );
	enemy set_generic_run_anim( "patrol_walk" );

	enemy.goalradius = 64;
	enemy.combatmode = "no_cover";
	enemy thread delete_on_notify( "start_alcove" );
	enemy thread maps\_patrol::patrol( "drag_after_node" );
	
	node = get_target_ent( "dock_drag_node" );
	civ.deathanim = getgenericanim( "prague_interrogate_1short_civ_kill" );
	civ thread interrupt_anim_on_alert_or_damage( civ );
	node thread interrupt_anim_on_alert_or_damage( enemy );
	node thread anim_generic( civ, "prague_interrogate_1short_civ_drag" );
	
	ai = getaiarray( "axis" );
	foreach ( a in ai )	
	{
		a removeAIEventListener( "gunshot_teammate" );
	}
	enemy childthread enemy_shoot_think();
	node anim_generic( enemy, "prague_interrogate_1short_soldier_drag" );
	
	if ( isalive( civ ) )
		civ kill();
	flag_set( "dock_drag_done" );
	node anim_generic_run( enemy, "prague_interrogate_1_soldier_kill" );
}

enemy_shoot_think()
{
	self endon( "death" );
	wait( 1.0 );
	while ( self getAnimTime( getgenericanim("prague_interrogate_1short_soldier_drag") ) < 0.96 )
		wait ( 0.05 );

	thread maps\_weather::lightningFlash( maps\prague_fx::lightning_normal, maps\prague_fx::lightning_flash );	
	self Shoot();
	wait( 0.15 );
	self Shoot();
	wait( 0.1 );
	self Shoot();
	wait( 0.1 );
}

spotted_reactions()
{
	level endon( "start_alcove" );
	flag_wait( "_stealth_spotted" );
	
	if ( isdefined( level.canal_spotlight ) )
		level.canal_spotlight setTargetEntity( level.player );
	
	wait( 0.1 );
	ai = getaiarray( "axis" );
	foreach ( a in ai )
	{
		a.accuracy = 999;
		a notify( "stop_loop" );
		a StopAnimScripted();
		a.ignoreAll = false;
		a.favoriteenemy = level.player;
		a clear_run_anim();
		a setGoalEntity( level.player );
		a getEnemyInfo( level.player );
	}
	
	wait( 4.0 );
	
	level.player kill();
}

dock_dog()
{
	thread guys_spot_player();
	dog = spawn_targetname( "dock_dog" );
	dog endon( "death" );
	dog thread delete_on_notify( "start_alcove" );
	trigger_wait_Targetname( "dock_dog_move_to_position" );
	
	node = get_target_ent( "dock_dog_growl_node" );
	
	node anim_generic_reach( dog, "german_shepherd_attackidle_growl" );
	trigger_wait_Targetname( "dock_dog_growl_trigger" );
	node anim_generic( dog, "german_shepherd_attackidle_growl" );
	node anim_generic( dog, "german_shepherd_attackidle_growl" );
	node anim_generic( dog, "german_shepherd_attackidle_growl" );
	flag_set( "docks_get_down" );
	node anim_generic( dog, "german_shepherd_attackidle_growl" );
	node anim_generic( dog, "german_shepherd_attackidle_bark" );
	node anim_generic( dog, "german_shepherd_attackidle_bark" );
	
	node = node get_target_ent();
	node anim_generic_reach( dog, "german_shepherd_attackidle_growl" );
	node anim_generic( dog, "german_shepherd_attackidle_bark" );
	node anim_generic( dog, "german_shepherd_attackidle_bark" );
	node anim_generic( dog, "german_shepherd_attackidle_growl" );
	node anim_generic( dog, "german_shepherd_attackidle_growl" );
	node thread stealth_ai_idle_and_react_custom( dog, "german_shepherd_attackidle", "_stealth_dog_howl" );
}

guys_spot_player()
{
	flag_wait( "docks_get_down" );
	wait( 4.0 );
	enable_trigger_with_targetname( "dog_spotted_trigger" );
	enable_trigger_with_targetname( "dog_spotted_trigger2" );
}

dock_step_forward()
{
	level endon( "docks_get_down" );
	trigger = get_target_ent( "step_forward_trigger" );
	trigger waittill( "trigger" );
	guy = undefined;
	guys = trigger get_linked_ents();
	foreach ( g in guys )
	{
		if ( g.classname == "script_model" )
		{
			guy = g;
			break;
		}
	}
	
	while( isdefined( guy ) )
	{
		guy notify( "stop_loop" );
		guy thread anim_generic( guy, guy.animation + "_stepforward" );
		guys = guy get_linked_ents();
		guy = undefined;
		foreach ( g in guys )
		{
			if ( g.classname == "script_model" )
			{
				guy = g;
				break;
			}
		}
		wait( RandomFloatRange( 0.3,0.6 ) );
	}
}

player_swim_think()
{
	trigger_wait_targetname( "player_in_water_trigger" );
	flag_init( "player_is_moving" );
	level.player FreezeControls( true );
	time = 0.1;
	level.player thread play_sound_on_entity( "scn_prague_plr_break_surface" );
	thread fade_out( time );
	thread player_leaves_water();
	level.player setBlurForPlayer( 6, 0.2 );
	wait( 0.3 );
	thread enable_player_swim();
//	level.player SetWaterSheeting( 1, 3.0 );
	fwd = AnglesToForward( level.player.angles );
	playfx( getfx( "body_splash_prague" ), level.player geteye() + fwd );
	level.player setBlurForPlayer( 0, 0.8 );
	thread fade_in( 0.3 );
	level.player player_speed_percent( 5, 0.1 );
	level.player FreezeControls( false );
	flag_wait( "player_out_of_water" );
	disable_player_swim();
}

player_leaves_water()
{
/*	trigger_wait_targetname( "exit_the_water" );
	
	org = spawn_tag_origin();
	org.origin = level.player.origin;
	org.angles = level.player.angles;
	level.player PlayerLinkToAbsolute( org, "tag_origin" );
	level.player TakeAllWeapons();
	level.player DisableWeapons();
*/	
	level waittill( "player_got_up" );

	rig = get_player_rig();
	while ( rig getanimtime( rig getanim( "sewer_get_out" ) ) < 0.99 )
		wait( .05 );

	autosave_stealth();
	flag_set( "player_out_of_water" );

	/* n = get_target_ent( "player_out_of_water" );
	n.origin = ( level.player.origin[0], n.origin[1], n.origin[2] );
	org moveTo( n.origin, 1 );
//	org rotateTo( n.angles, 1 );
	org waittill( "movedone" ); */
	
	player_speed_percent( 85 );

	wait( 1.3 );
	level.player unlink();
	level.player AllowCrouch( true );
	level.player AllowProne( true );
	rig Stopanimscripted();
	rig Delete();
//	level.player_legs delete();
	
	wait( 1.5 );
	foreach ( guy in level.kamarov_guys )
	{
		guy.pushable = false;
		guy.script_pushable = false;
	}
	level.player maps\_loadout::give_loadout();
	level.player EnableWeapons();
}

enable_player_swim()
{
	setSavedDvar( "hud_showStance", "0" );
	setSavedDvar( "compass", "0" );
	level.player_view_pitch_down = getDvar( "player_view_pitch_down" );
	level.bg_viewBobMax = getDvar( "bg_viewBobMax" );
	level.player_sprintCameraBob = getDvar( "player_sprintCameraBob" );
	setSavedDvar( "player_view_pitch_down", 5 );
	setSavedDvar( "bg_viewBobMax", 0 );
	//setSavedDvar( "player_sprintCameraBob", 0 );
	
	level.ground_ref_ent = spawn_tag_origin();
	level.player playerSetGroundReferenceEnt( level.ground_ref_ent );
	level.player AllowStand( true );
	level.player AllowJump( false );
	level.player AllowCrouch( false );
	level.player AllowProne( false );
	level.player DisableWeapons();
	level.player AllowSprint( false );
	level.player AllowMelee( false );
//	level.player EnableSlowAim();
	player_speed_percent( 20, 0.05 );
	level.player ShellShock( "prague_swim", 999999 );	
	level.player endon( "stop_swimming" );
	level.player thread custom_waterfx( "player_out_of_water" );

	childthread check_stick_movement( 0.4 );
	childthread player_water_wade();
	childthread player_water_death();
	
	time = 4;
	wait( 3 );
	while( 1 )
	{
		level.ground_ref_ent rotatePitch( -2, time, time/2, time/2 );
		level.ground_ref_ent waittill( "rotatedone" );
		level.ground_ref_ent rotatePitch( 2, time, time/2, time/2 );
		level.ground_ref_ent waittill( "rotatedone" );
	}
}

player_water_wade()
{
	while ( 1 )
	{
		flag_wait( "player_is_moving" );
		childthread player_water_wade_sounds();
		childthread player_water_wade_speed();
		wait( 0.1 );
		flag_waitopen( "player_is_moving" );
		level.player notify( "stop_water_sounds" );
	}
}

player_water_wade_sounds()
{
	level.player endon( "stop_water_sounds" );
	wait( RandomFloatRange( 0,1 ) );
	while( 1 )
	{
		level.player play_sound_on_entity( "scn_prague_swim_slow_plr" );
		wait( RandomFloatRange( 0.5,1.5 ) );
	}
}

player_water_wade_speed()
{
	level endon( "player_swim_faster" );
	level.player endon( "stop_water_sounds" );
	while( !flag( "player_swim_faster" ) )
	{
		level.player thread play_sound_on_entity( "scn_prague_swim_slow_plr" );
		thread player_speed_percent( 27, 1 );
		wait( 1 );
		thread player_speed_percent( 18, 0.3 );
		wait( 0.5 );
	}
}

player_water_death()
{
	level.player waittill( "death" );
	setBlur( 20, 0 );
}

check_stick_movement( min_dist )
{	
	while( 1 )
	{
		dist = level.player GetNormalizedMovement();
		if ( Distance( ( 0, 0, 0 ), dist ) > min_dist )
		{
			level.player.moving = true;
			flag_set( "player_is_moving" );
		}
		else
		{
			level.player.moving = false;
			flag_clear( "player_is_moving" );
		}
		waitframe();
	}
}

disable_player_swim()
{
	setSavedDvar( "player_view_pitch_down", level.player_view_pitch_down );
	setSavedDvar( "bg_viewBobMax", level.bg_viewBobMax );
	//setSavedDvar( "player_sprintCameraBob", level.player_sprintCameraBob );
	
	setSavedDvar( "hud_showStance", "1" );
	setSavedDvar( "compass", "1" );
		
	level.player playerSetGroundReferenceEnt( undefined );
	
	level.player AllowJump( true );
	level.player AllowMelee( true );
	level.player AllowSprint( true );
//	level.player DisableSlowAim();
	level.player StopShellShock();
	
	level.player notify( "stop_swimming" );
}

enable_ai_swim()
{
	self disable_cqbwalk();
	self set_generic_idle_forever( "swim_idle" );
	self set_generic_run_anim( "swim_fast", true );
	
	if ( isSubStr( self.classname, "soap" ) )
		self.animplaybackrate = 0.7;
	
	self pushplayer( true );
	self.disableExits = true;
	self.disableArrivals = true;
	self.a.disablePain = true;
	self.ignoreAll = true;
	self thread custom_waterfx( "start_kamarov_scene", (0,0,-0.5) );
	self thread ai_swim_sound();
}

disable_ai_swim()
{
	self notify( "stop_swimming" );
	self notify( "clear_idle_anim" );
	self clear_generic_idle_anim();
	self set_moveplaybackrate( 1 );
	self clear_run_anim();
	self.disableExits = false;
	self.disableArrivals = false;
	self.a.disablePain = false;
	self.animplaybackrate = 1;
}

team_movement()
{
	flag_init( "player_rushing" );
	flag_init( "team_move_1" );
	flag_init( "team_move_2" );
	flag_init( "team_move_3" );
	flag_init( "team_move_4" );

	flag_set( "player_rushing" );

	level endon( "_stealth_spotted" );
	thread team_move_1();
	thread team_move_2();
	thread team_move_3();
	
	level endon( "team_move_1" );
	
	wait( 0.3 );
	radio_dialogue( "prague_pri_welcome" );
	wait( 0.6 );
	level.sandman anim_single_solo( level.sandman, "prague_pri_halfaclick" );
	
	flag_clear( "player_rushing" );
	flag_set( "team_move_1" );
}

team_move_1()
{	
	level endon( "_stealth_spotted" );
	level endon( "team_move_2" );
	flag_wait( "team_move_1" );
	thread team_set_goal( "docks_position1", 256 );
	
	flag_wait( "player_close_to_docks" );
	
	thread spawn_vehicles_from_Targetname_and_drive( "new_cargo_heli" );
	radio_dialogue_stop();	
	if ( !flag( "player_rushing" ) )
		level.price delaythread( 0.3, ::anim_generic, level.price, "signal_stop_swim" );
	flag_set( "player_rushing" );
	radio_dialogue( "prague_pri_contact" );
	wait( 0.6 );
	radio_dialogue( "prague_mct_takenprisoners" );	
	wait( 0.3 );
	radio_dialogue( "prague_pri_movingfaster" );
	wait( 0.3 );
	radio_dialogue( "prague_pri_singlefile" );
	
	flag_clear( "player_rushing" );
	flag_set( "team_move_2" );
}

team_move_2()
{
	level endon( "_stealth_spotted" );
	level endon( "team_move_3" );
	flag_wait( "team_move_2" );
	level.price StopAnimScripted();
	
	autosave_stealth();
	
	if ( !flag( "player_rushing" ) )
	{
		level.price set_generic_run_anim( "swim" );
		level.sandman set_generic_run_anim( "swim" );
	}
	else
	{
		level.price set_generic_run_anim( "swim_fast" );
		level.sandman set_generic_run_anim( "swim_fast" );
		structs = getstructarray( "docks_position2", "targetname" );
		foreach ( s in structs )
		{
			s.animation = undefined;
		}
	}
	
//	delayThread ( 0.0, ::music_play, "prague_tension_3" );
	thread team_set_goal( "docks_position2", 256 );
	
//	delayThread( 2.0, ::radio_dialogue_stop );
//	delayThread( 2.1, ::radio_dialogue, "prague_pri_useboats" );
	
	trigger_wait_targetname( "dock_dog_move_to_position" );
	level.price set_generic_run_anim( "swim_fast" );
	level.sandman set_generic_run_anim( "swim_fast" );
	wait( 2.3 );
	radio_dialogue(  "prague_pri_underdocks" );
	//iprintlnbold( "P: That dog's trouble.  Quick, get under the dock." );
}

team_move_3()
{
	level endon( "_stealth_spotted" );
	flag_wait( "player_at_dock_gap" );
	wait( 0.6 );
	if ( player_is_behind_price() )
		level.price thread anim_generic( level.price, "signal_stop_swim" );
	level.price.pushable = false;
	level.sandman.pushable = false;
	level.price Pushplayer( true );
	level.sandman Pushplayer( true );
	radio_dialogue( "prague_pri_easy" );
	wait( 1.0 );
	radio_dialogue( "prague_pri_letthempass" );
	flag_wait( "dock_drag_done" );
	wait( 2.6 );
	radio_dialogue( "prague_pri_okay" );
	wait( 2.0 );
	disable_trigger_with_targetname( "dock_gap_spotted_trigger" );
	thread radio_dialogue( "prague_pri_go" );
	flag_set( "player_swim_faster" );
	player_speed_percent( 37, 4 );
	level.price set_generic_run_anim( "swim_fast" );
	level.sandman set_generic_run_anim( "swim_fast" );
	
	thread team_set_goal( "docks_position3", 256 );

	
	flag_wait( "player_at_dock_end" );
	radio_dialogue( "prague_pri_guarddown" );
	delayThread( 4, ::music_stop, 8 );
	
	flag_wait( "start_sewers" );
	
	nodes = getstructarray( "start_sewers", "targetname" );
	foreach ( n in nodes )
	{
		if ( n.script_noteworthy == "sandman" )
		{
			level.sandman delayThread( 2.0, ::set_goal_pos, n.origin );
		}
		if ( n.script_noteworthy == "price" )
		{
			level.price set_goal_pos( n.origin );
		}
	}
	level.price waittill( "goal" );
	
	flag_set( "start_kamarov_scene" );
}

mass_murder()
{
	flag_wait( "start_mass_murder" );
	/*
	ai = getaiarray( "axis" );
	ai = SortByDistance( ai, level.player.origin );
	ai = ai[0];
	ai play_sound_on_entity( "RU_" + ai.npcId + "_stealth_alert" );
	
	n1 = getentarray( "murder_start_node", "targetname" );
	array_thread( n1, ::bulletspray );
	*/
	org = spawn_tag_origin();
	org2 = spawn_tag_origin();
	thread woman_crying( org, org2 );
	wait( 3.0 );
	
	s = getstructarray( "blood_drip_source", "targetname" );
	array_thread( s, ::blood_drip_thread );
	
	flag_wait_or_timeout( "player_at_dock_gap", 5 );
	
	node = get_target_ent( "water_fall_node" );
	
	wait( 0.1 );
	src = get_target_ent( "woman_murder_bullet" );
	dest = src get_target_ent();
	MagicBullet( "ak47", src.origin, dest.origin );
	PlayFX( getfx( "headshot1" ), org.origin );
	thread play_sound_in_space( "generic_death_falling_scream", org.origin );
	wait( 0.2 );
	MagicBullet( "ak47", src.origin, dest.origin );
	PlayFX( getfx( "bodyshot1" ), org.origin );
	wait( 0.5 );
	guy = spawn_targetname( "water_fall_drone" );
	node thread anim_generic_first_frame( guy, node.animation );
	wait( 0.05 );
	org StopSounds();
	org2 StopSounds();
	
	ai = getAIArray( "axis" );
	thread group_flavorbursts( ai, "ru", 3, 3, true, "start_sewers" );
	
	guy.deathanim = getgenericanim( node.animation );
	animtime = getAnimLength( guy.deathanim );
	node notify( "stop_first_frame" );
	guy.allowdeath = true;
	guy kill();
	
	wait( 1.35 );
	org delete();
	org2 delete();
	fxorg = get_target_Ent( "water_splash_node" );
	PlayFX( getfx( "body_splash" ), fxorg.origin );
	play_sound_in_space( "scn_prague_enemy_water_splash", fxorg.origin );
}

woman_crying( org, org2 )
{
	level notify( "docks_stop_talking" );
	node = get_target_ent( "water_fall_node" );
	org.origin = node.origin;
	org2.origin = node.origin;
	
	org playsound( "prague_czw_death" );
	org2 playsound( "prague_rus_killswoman" );
}

bulletspray()
{
	n1 = self;
	while( isdefined( n1 ) )
	{
		n2 = n1 get_target_ent();
		MagicBullet( "ak47", n1.origin, n2.origin );
		wait( RandomFloatRange( 0.15, 0.25 ) );
		if ( isdefined( n1.script_linkTo ) )
			n1 = n1 get_linked_ent();
		else
			break;
	}
}

blood_drip_thread()
{
	level endon( "start_sewers" );
	while( 1 )
	{
		wait( RandomFloatRange( 1,5 ) );
		PlayFX( getfx( "blood_drip" ), self.origin );
	}
}

alert_on_fast_movement()
{
	level endon( "_stealth_spotted" );
	level endon( "start_kamarov_scene" );
	level endon( "dock_smoker_dead" );
	
	volume = get_target_ent( "dead_body_volume" );
	
	while( 1 )
	{
		dist = level.player GetNormalizedMovement();
		if ( Distance( ( 0, 0, 0 ), dist ) > 0.5 && level.player isTouching(volume) )
			break;
		wait( 0.1 );
	}
	flag_set( "_stealth_spotted" );
}

player_surface_blur()
{
//	SetBlur( 5, 2 );
//	level.player SetWaterSheeting( 1, 10.0 );
	wait( 0.4 );
	level.player thread vision_set_fog_changes( "prague", 0.5 );
	wait( .2 );
	level.player thread play_sound_in_space( "splash_player_water_exit" );
//	SetBlur( 0, 3 );
}

team_set_goal( targetname, req_distance )
{
	structs = getstructarray( targetname, "targetname" );
	foreach ( s in structs )
	{
		switch ( s.script_noteworthy )
		{
			case "price":
				level.price thread follow_path_waitforplayer( s, req_distance*1.25 );
				break;
			case "sandman":
				level.sandman delaythread( 1, ::follow_path_waitforplayer, s, req_distance*0.75 );
		}
	}
}

breathing_civ()
{
	level endon( "start_sewers" );
	flag_wait( "docks_get_down" );
	wait( 3.0 );
	while ( 1 )
	{
		self play_sound_on_entity( "scn_prague_civ_breathing" );
		wait( RandomFloatRange( 2,6 ) );
	}
}

dock_civs_think()
{
	self thread delete_on_notify( "start_alcove" );
	self.idleAnim = level.scr_anim[ "generic" ][ self.animation ][ 0 ];
	self.runAnim = level.scr_anim[ "generic" ][ "civ_captured" ][ RandomIntRange( 0,2 ) ];

	self.noragdoll = true;
	
	
	anime = "london_enemy_capture_enemy_death_01";
	if ( cointoss() )
		anime = "london_enemy_capture_enemy_death_04";
	
	self.deathanim = getgenericanim( anime );
	
	self thread drone_proper_death();
	self drone_parameters( self );
	if ( isdefined( self.script_parameters ) && isSubstr( self.script_parameters, "breathing" ) )
	{
		self thread breathing_civ();
	}
	
	if ( isdefined( self.target ) )
	{
		flag_wait( "player_close_to_docks" );
		wait( RandomFloatRange( 0, 0.5 ) );
		self.moveplaybackrate = RandomFloatRange( 0.75, 0.85 );
		self notify( "move" );
		self waittill( "goal" );
	} 
	else
	{
		self delaythread( RandomFloatRange( 0,3 ), ::spawnfunc_idle );
	}
	
	flag_wait_either( "docks_get_down", "_stealth_spotted" );

	wait( RandomFloatRange( 2, 3 ) );	
	self notify( "stop_loop" );
	self anim_generic( self, self.animation + "_getdown" );
	self thread anim_generic_loop( self, self.animation + "_getdown_idle" );
	
	self thread deletable_magic_bullet_shield();
	self waittill( "damage" );
	self notify( "stop_loop" );
	self anim_generic( self, anime );
}

docks_enemies_think()
{
	self endon( "death" );
	level endon( "_stealth_spotted" );
	
	self thread delete_on_notify( "start_alcove" );

	if ( isdefined( self.script_parameters ) )
	{
		if ( issubstr( self.script_parameters, "flag_on_death" ) )
		{
			flag_init( self.script_flag );
			self thread flag_on_damage( self.script_flag );
		}
		
		if ( issubstr( self.script_parameters, "light_on_gun" ) )
		{
			self thread light_on_gun();
		}
	}
	
	self endon( "_stealth_spotted" );
	
	if ( isdefined( self.script_noteworthy ) )
	{
		flag_wait( "docks_get_down" );
		self notify( "stop_radiobursts" );
		self notify( "end_patrol" );
		self clear_run_anim();
		
		if ( self.script_noteworthy == "yell_getdown" )
		{
			if ( !isdefined( self.animation ) )
				self.animation = "yell_getdown";
			
			wait( RandomFloatRange( 0.3, 2.2 ) );
			
			if ( isdefined( self.target ) )
				oldnode = self get_target_ent();
			else
				oldnode = self;
			
			self notify( "stop_idle_proc" );
			oldnode notify( "stop_loop" );
			self notify( "stop_loop" );

			self thread play_sound_on_entity( "RU_" + self.npcID + "_stealth_alert" );
			self anim_generic( self, self.animation );
			self anim_generic( self, "_stealth_behavior_generic2" );
			
			nodes = getstructarray( "water_search_node", "targetname" );
			nodes = SortByDistance( nodes, self.origin );
			for ( i=0; i<nodes.size; i++ )
			{
				node = nodes[i];
				if ( isdefined( node.claimed ) )
					continue;
					
				node.claimed = true;
				oldnode notify( "stop_loop" );
				self notify( "stop_loop" );
				oldnode notify( "stop_idle_proc" );
				self notify( "stop_idle_proc" );
				self StopAnimScripted();
				self water_node_logic( node );
				break;
			}
		}
		else if ( self.script_noteworthy == "near_dock" )
		{
			nodes = getstructarray( "dock_edge_node", "targetname" );
			nodes = SortByDistance( nodes, self.origin );
			
			wait( RandomFloatRange( 2,3 ) );
			
			for ( i=0; i<nodes.size; i++ )
			{
				node = nodes[i];
				if ( isdefined( node.claimed ) )
					continue;
					
				node.claimed = true;
				self notify( "stop_loop" );
				self StopAnimScripted();
				self anim_generic( self, "_stealth_behavior_generic2" );
				node anim_generic_reach( self, "_stealth_look_around" );
				node stealth_ai_idle_and_react_custom( self, "_stealth_look_around", "_stealth_behavior_spotted_short" );
				break;
			}
		}
		else if ( self.script_noteworthy == "water_search" || self.script_noteworthy == "mean_guard" || self.script_noteworthy == "bodydump_guys" )
		{	
			wait( RandomFloatRange( 1,3 ) );
			self notify( "stealth_enemy_endon_alert" );
			self anim_generic( self, "_stealth_behavior_generic2" );
			
			nodes = getstructarray( "water_search_node", "targetname" );
			nodes = SortByDistance( nodes, self.origin );
			for ( i=0; i<nodes.size; i++ )
			{
				node = nodes[i];
				if ( isdefined( node.claimed ) )
					continue;
					
				node.claimed = true;
				self notify( "stop_loop" );
				self StopAnimScripted();
				
				self water_node_logic( node );
				
				if ( isdefined( node.target ) )
				{
					flag_wait( "player_at_dock_gap" );
					self set_generic_run_anim( "_stealth_patrol_search_a" );
					self notify( "stop_idle_proc" );
					node notify( "stop_loop" );
					self notify( "stop_loop" );
					self StopAnimScripted();
					node = node get_target_ent();
					self water_node_logic( node );
				}
				
				break;
			}
		}
	}
	else
	{
		flag_wait( "docks_get_down" );
		self notify( "stop_radiobursts" );
		
		wait( RandomFloatRange( 1,3 ) );
		
		self anim_generic( self, "_stealth_behavior_generic2" );
	}
}

water_node_logic( node )
{
	node script_delay();
	node anim_generic_reach( self, node.animation );
	
	if ( issubstr( node.animation, "run2water" ) )
	{
		node anim_generic( self, node.animation );
		if ( issubstr( node.animation, "left" ) )
			node thread stealth_ai_idle_and_react_custom( self, "prague_intro_dock_guard_searchwater_left", "_stealth_behavior_spotted_short", undefined, true );
		else if ( issubstr( node.animation, "right" ) )
			node thread stealth_ai_idle_and_react_custom( self, "prague_intro_dock_guard_searchwater_right", "_stealth_behavior_spotted_short", undefined, true );
		else if ( issubstr( node.animation, "center" ) )
			node thread stealth_ai_idle_and_react_custom( self, "prague_intro_dock_guard_searchwater_center", "_stealth_behavior_spotted_short", undefined, true );
	}
	else
		node thread stealth_ai_idle_and_react_custom( self, node.animation, "_stealth_behavior_spotted_short" );
}

bodydump()
{
	flag_init( "bodydump_abort" );

	level endon( "bodydump_abort" );

	ai = get_living_ai_array( "bodydump_guys", "script_noteworthy" );
	guy1 = ai[ 0 ];
	guy2 = ai[ 1 ];

	guy1 thread pond_dump_bodies_check_abort();
	guy2 thread pond_dump_bodies_check_abort();

	guy1 endon( "death" );
	guy2 endon( "death" );

	spot = get_target_ent( "bodydump_node" );

	num = 1;

	guy1.allowdeath = true;
	guy2.allowdeath = true;

	while ( 1 )
	{
		guy1 notify( "single anim", "end" );

		spot thread anim_generic( guy1, "bodydump_guy1" );
		spot thread pond_dump_createbody( "deadguy_throw1" );
		spot thread pond_dump_2nd( guy1 );
		//spot delaythread(10.75, ::pond_dump_createbody, "deadguy_throw2" );
		spot anim_generic( guy2, "bodydump_guy2" );
	}
}

canal_spotlight()
{
	s = get_target_ent( "canal_spotlight" );

	wait( 0.6 );
	node = get_target_ent( "heli_spot_start" );
	level.scan_nodes = [ node ];
	level.target_dummy.origin = node.origin;
	level notify( "change_spot" );
	level.canal_spotlight = SpawnTurret( "misc_turret", s.origin, "heli_spotlight" );
	spotlight = level.canal_spotlight ;
	spotlight SetMode( "manual" );
	spotlight SetModel( "com_blackhawk_spotlight_on_mg_setup" );
	spotlight thread spot_light( "heli_spotlight", "heli_spotlight_cheap", "tag_flash" );
	spotlight setTargetEntity( level.target_dummy );
	
	flag_wait( "player_out_of_water" );
	
	spotlight delete();
}

/* ---- BODYDUMP STUFF ------*/

pond_dump_2nd( guy )
{
	guy endon( "death" );
	guy waittillmatch( "single anim", "start_deadbody" );
	self pond_dump_createbody( "deadguy_throw2" );
}

pond_dump_bodies_check_abort()
{
	self endon( "death" );
	self gun_remove();

	self thread maps\_stealth_utility::stealth_enemy_endon_alert();
	self thread pond_dump_bodies_abort_thrower();
	self thread pond_dump_bodies_abort_thrower2();

	self waittill( "stealth_enemy_endon_alert" );
	flag_set( "bodydump_abort" );

	self gun_recall();
}

pond_dump_bodies_abort_thrower2()
{
	level endon( "bodydump_abort" );
	self waittill( "death" );
	flag_set( "bodydump_abort" );
}


pond_dump_bodies_abort_thrower()
{
	self endon( "death" );
	self endon( "stealth_enemy_endon_alert" );

	flag_wait( "bodydump_abort" );

	self stopanimscripted();
	self gun_recall();
}

pond_dump_bodies_abort()
{
	self endon( "death" );
	flag_wait( "bodydump_abort" );

	self thread pond_dump_bodies_abort2();
	self notify( "ragdoll" );
}

pond_dump_bodies_abort2()
{
	self kill();
	waittillframeend;// if you dont do this - a ghost ai will appear.
	self startragdoll();
	wait( 0.5 );
	if ( isdefined( self ) )
		self delete();
}

pond_dump_createbody( anime )
{
	level endon( "bodydump_abort" );
	spot = self;
	body = pond_dump_createbody2();

	if ( !isalive( body ) )
	{
		if ( isdefined( body ) )
			body delete();
		return;
	}

	body endon( "ragdoll" );

	body thread pond_dump_bodies_abort();

	spot thread anim_generic( body, anime );
	
//	iprintln( anime );
	if ( issubstr( anime, "throw2" ) )
	{
		wait( 7.4 );
	}
	else
	{
		wait( 7.4 );
	}
	spot waittill( anime );
	
	body delete();
}

pond_dump_createbody2()
{
	spawner = getent( "pond_deadguy1", "targetname" );
	spawner.count = 1;

	ai = dronespawn( spawner );

//	spawn_failed( ai );
	assert( isDefined( ai ) );

	ai.script_noteworthy = undefined;
	ai.ignoreall = true;
	ai.ignoreme = true;
	ai.team = "neutral";
	ai.name = "";

	if ( flag( "bodydump_abort" ) && isdefined( ai ) )
	{
		ai delete();
		return undefined;
	}
	return ai;
}

rocking_items()
{
	rockers = getstructarray_delete( "water_rock", "script_noteworthy" );

	foreach ( r in rockers )
	{
		m = Spawn( "script_model", r.origin );
		m.angles = r.angles;
		m setModel( r.script_modelname );
		m thread water_rock( r );
		m thread delete_on_notify( "player_out_of_water" );
	}
}

water_rock( node )
{
	self endon( "death" );
	self childthread water_bob( node );
	self childthread water_rock_angles( node );
}

water_bob( node )
{
	old = node.origin;
	
	maxdist = 5;
	if ( isdefined( node.script_maxdist ) )
	{
		maxdist = node.script_maxdist;
	}
	mindist = maxdist * 0.5;
	
	maxtime = 8;
	if ( isdefined( node.script_duration ) )
	{
		maxtime = node.script_duration;
	}
	mintime = maxtime * 0.5;
	
	node = undefined;
	
	while( 1 )
	{
		dist = RandomFloatRange( mindist, maxdist );
		time = RandomFloatRange( mintime,maxtime );
		
		self moveTo( old + (0,0,dist), time, time/2.0, time/2.0 );
		self waittill( "movedone" );
		self moveTo( old - (0,0,dist), time, time/2.0, time/2.0 );
		self waittill( "movedone" );
	}
}

water_rock_angles( node )
{
	old = node.angles;
	
	maxdist = 5;
	if ( isdefined( node.script_max_left_angle ) )
	{
		maxdist = node.script_max_left_angle;
	}
	mindist = maxdist * 0.5;
	
	maxtime = 8;
	if ( isdefined( node.script_duration ) )
	{
		maxtime = node.script_duration;
	}
	mintime = maxtime * 0.5;
	
	node = undefined;
	
	while( 1 )
	{
		dist = ( RandomFloatRange( mindist, maxdist ), 0, RandomFloatRange( mindist, maxdist ) );
		time = RandomFloatRange( 5,8 );
		
		self rotateTo( old + dist, time, time/2.0, time/2.0 );
		self waittill( "rotatedone" );
		self rotateTo( old - dist, time, time/2.0, time/2.0 );
		self waittill( "rotatedone" );
	}
}

bridge_vehicles_think()
{
	self endon( "death" );
	
	if ( isdefined( self.mgturret ) )
		foreach ( turret in self.mgturret )
			turret notify( "stop_burst_fire_unmanned" );
	
	if ( IsSubStr( self.classname, "btr80" ) )
	{
		nodes = getstructarray( "bridge_btr_scan_node", "targetname" );
		while ( 1 )
		{
			n = RandomIntRange( 0, nodes.size );
			self SetTurretTargetVec( nodes[ n ].origin );
			wait( RandomFloatRange( 1, 2 ) );
		}
	}
}

bridge_civ_think()
{
	if ( self.team == "axis" )
	{
		self.runAnim = level.scr_anim[ "generic" ][ "casual_killer_walk_F" ];
		self.moveplaybackrate = 0.95;
	}
	else
	{
		self.runAnim = level.scr_anim[ "generic" ][ "civ_captured" ][ RandomIntRange( 0,2 ) ];
	}
	
	wait( RandomFloatRange( 0,1 ) );
	self notify( "move" );
}


slow_swim_trigger()
{
	level endon( "start_sewers" );
	while( 1 )
	{
		self waittill( "trigger", guy );
		guy set_generic_run_anim( "swim" );
	}
}

fast_swim_trigger()
{
	level endon( "start_sewers" );
	while( 1 )
	{
		self waittill( "trigger", guy );
		guy set_generic_run_anim( "swim_fast" );
	}
}

custom_waterfx( endflag, offset )
{
// currently using these devraw fx:
//	level._effect[ "water_stop" ]						= LoadFX( "misc/parabolic_water_stand" );
//	level._effect[ "water_movement" ]					= LoadFX( "misc/parabolic_water_movement" );

	self endon( "death" );

	if ( IsDefined( endflag ) )
	{
		flag_assert( endflag );
		level endon( endflag );
	}
	
	if ( !IsDefined( offset ) )
	{
		offset = ( 0, 0, 0 );
	}
	
	for ( ;; )
	{
		wait( RandomFloatRange( 0.15, 0.3 ) );
		start = self.origin + ( 0, 0, 150 );
		end = self.origin - ( 0, 0, 150 );
		trace = BulletTrace( start, end, false, undefined );
		if ( trace[ "surfacetype" ] != "water" )
			continue;

		fx = "water_movement";
		if ( IsPlayer( self ) )
		{
			if ( Distance( self GetVelocity(), ( 0, 0, 0 ) ) < 5 )
			{
				fx = "water_stop";
			}
		}
		else
		if ( IsDefined( level._effect[ "water_" + self.a.movement ] ) )
		{
			fx = "water_" + self.a.movement;
		}

		water_fx = getfx( fx );
		start = trace[ "position" ] + offset;
		//angles = vectortoangles( trace[ "normal" ] );
		angles = (0,self.angles[1],0);
		forward = anglestoforward( angles );
		up = anglestoup( angles );
		PlayFX( water_fx, start, up, forward );
	}
}

mean_guard()
{
	level endon( "_stealth_spotted" );
	level endon( "docks_get_down" );
	
	guard = get_living_ai( "mean_guard", "script_noteworthy" );
	node = get_Target_ent( "mean_guard_node" );
	wait( 1.0 );
	
	maps\_spawner::killspawner( 100 );
	
	guy1 = getent( "guy1", "script_noteworthy" );
	guy1.animname = "guy1";
	guy2 = getent( "guy2", "script_noteworthy" );
	guy2.animname = "guy2";
	
	flag_wait( "player_close_to_docks" );
	
	guard.animname = "guard";
	guard notify( "end_patrol" );
	node anim_reach_solo( guard, "mean_guard" );
	
	node thread anim_single( [ guard, guy1 ], "mean_guard" );
	
	guy1 waittillmatch( "single anim", "resistance2_start" );
	node anim_single_solo( guy2, "mean_guard" );
}

ai_swim_sound()
{
	self endon( "stop_swimming" );
	childthread ai_swim_sound_idle();
	
	while( 1 )
	{
		self waittill( "moveanim", notetrack ); 
		if ( notetrack == "ps_scn_prague_swim_slow_npc" || notetrack == "end" ) // using "end" notetrack because it doesn't seem to detect the notetrack on the first frame after the first instance
			self play_sound_on_entity( "scn_prague_swim_slow_npc" );
		wait( 0.2 );
	}
}

ai_swim_sound_idle()
{
	self endon( "stop_swimming" );
	
	while( 1 )
	{
		self waittill( "Special_idle", notetrack ); 
		if ( notetrack == "ps_scn_prague_swim_idle_npc" || notetrack == "end" ) // using "end" notetrack because it doesn't seem to detect the notetrack on the first frame after the first instance
			self play_sound_on_entity( "scn_prague_swim_idle_npc" );
		wait( 0.2 );
	}
}

stealth_ai_idle_and_react_custom( guy, idle_anim, reaction_anim, tag, no_gravity )
{	
	if ( IsDefined( no_gravity ) )
		AssertEx( no_gravity, "no_gravity must be true or undefined" );
	
	guy maps\_stealth_utility::stealth_insure_enabled();

	spotted_flag = guy maps\_stealth_shared_utilities::group_get_flagname( "_stealth_spotted" );

	if ( flag( spotted_flag ) )
		return;

	ender = "stop_loop";

	guy.allowdeath = true;
	
	if( !isdefined( no_gravity ) )
		self thread maps\_anim::anim_generic_custom_animmode_loop( guy, "gravity", idle_anim, tag );
	else
		self thread maps\_anim::anim_generic_loop( guy, idle_anim, tag );
		
	guy maps\_stealth_shared_utilities::ai_set_custom_animation_reaction( guy, reaction_anim, tag, ender );

	self add_wait( ::waittill_msg, "stop_idle_proc" );
	self add_func( maps\_stealth_utility::stealth_ai_clear_custom_idle_and_react );
	
	self thread maps\_stealth_utility::do_wait_thread();
}

player_is_behind_price()
{
	start = level.player GetEye();
	end = level.price GetEye();

	angles = VectorToAngles( start - end );
	forward = AnglesToForward( angles );
	player_forward = AnglesToForward( level.price.angles );

	dot = 0.65;
	new_dot = VectorDot( forward, player_forward );
	
	return ( new_dot < dot );
}