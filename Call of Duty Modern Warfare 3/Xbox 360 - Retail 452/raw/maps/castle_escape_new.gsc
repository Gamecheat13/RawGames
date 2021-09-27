#include common_scripts\utility;
#include maps\_utility;
#include maps\_shg_common;
#include maps\castle_code;
#include maps\_anim;
#include maps\_vehicle;
#include maps\_vehicle_aianim;
#include maps\_audio;

PLAYER_SPRINT_SCALE_MIN = 2.0;
PLAYER_SPRINT_SCALE_MAX = 2.0;
PRICE_DISTANCE_MAX = 600*600;
PRICE_DISTANCE_MIN = 100*100;


//asanfilippo note: Based on castle_escape.gsc, modified for potential new ending.


// Start Functions	/////////////////////////////////////////////////////////////////////////////////////
start_escape()
{
	set_ents_visible( "startvista", true );

	maps\_utility::vision_set_fog_changes( "castle_exterior", 0 );
	maps\castle_parachute_sim::setup_player_rig();
	maps\castle_parachute_sim::setup_parachute_model();
	
	thread move_player_to_start( "start_escape" );
	thread setup_price_for_start( "start_escape" );
	
	maps\castle_courtyard_battle::enable_battle_triggers();
	maps\castle_courtyard_battle::outer_courtyard_gate();

	level.price disable_pain();
	level.price disable_bulletwhizbyreaction();
	level.price set_ignoreSuppression( true );
	
	level.price place_weapon_on( "mp5", "right" );
	level.price.grenadeammo = 3;
	level.price.baseaccuracy = 10;
	level.price.aggressivemode = true;
		
	thread escape_doors_set_open(false);
	
	
	level.price disable_danger_react();
	level.price disable_surprise();
	level.price set_ignoreall( true );
	
	//flag_set("player_entering_truck");
	
	
	//asanfilippo: new ending truck
	level thread maps\castle_escape_new::setup_escape_truck();
	waitframe();
	
	flag_set("player_entering_truck");
	//thread truck_ride();	
	
	level.escape_truck guy_enter_vehicle(level.price);
	level.price thread price_idles_in_truck();	
		
	wait 1.0;
	
	flag_set("price_in_truck");
	
	
}

price_idles_in_truck()
{
	level.price notify ("newanim");
    level.price endon( "newanim" );
    level.price endon( "death" );
    
	truck = level.escape_truck;
	
	animpos = anim_pos( truck, 0);
	truck thread anim_loop_solo(level.price, "truck_idle", "stop_loop", animpos.sittag);
	
	level waittill("truck_moving");
	level.price notify("stop_loop");
	
	thread maps\castle_truck_movement::price_starts_driving_price();
	
	//truck guy_idle(level.price, 0);
}

start_cliff()
{
	thread start_escape();
	waitframe();
	
	thread truck_ride();
	flag_set("price_in_truck");
	flag_set("truck_starts_driving");
	waitframe();
	
	//jump to a point further up
	node = GetVehicleNode("approaching_cliff_node", "script_noteworthy");
	level.escape_truck AttachPath(node);
	
	level.escape_truck notify("new_path");
	level.escape_truck thread vehicle_paths(node);	

	//prevents an sre	
	aud_send_msg("truck_doors_crash");

	
}

// Main Functions	/////////////////////////////////////////////////////////////////////////////////////

escape_main()
{
	/#
	iprintln( "Escape" );
	#/
		
	/*a_destroyable_trees = GetEntArray( "trigger_tree_explosion", "targetname" );
	foreach( trigger in a_destroyable_trees )
	{
		trigger thread setup_destroyable_tree();
	}*/
	
	level.player thread player_escape();
	level thread trigger_slide();
	level thread jump_off_cliff_sequence();
	
	set_rain_level(7); // 7 is the always on version (doesnt care about indoor/outdoor)
	
	thread escape_rumble();
	
	level.price thread price_escape();
	level.price thread price_escape_vo();
	
	level thread helicopter();
	level thread btrs();
	level thread fence_pieces();
	level thread crash_through_fence();
	level thread price_turning();
	
	//battlechatter at the end fights with Price's VO.
	battlechatter_off("axis");

}


init_event_flags()
{
	flag_init( "player_entering_truck");
	flag_init( "rpg_on_escape" );
	flag_init( "spawned_escape_helicopter" );
	flag_init( "reveal_escape_helicopter" );
	flag_init( "escape_helicopter_move" );
	flag_init( "player_on_slope" );	
	flag_init( "cliff_deploy_chute" );
	flag_init( "helicopter_shoot_player" );
	flag_init( "stop_dirt_overlay" );
	flag_init( "player_in_landing_zone" );
	flag_init( "truck_went_off_cliff" );
	flag_init( "escape_hydro_fx" );
	flag_init( "escape_show_chute" );	
	flag_init( "player_landed_on_bank" );
	flag_init( "truck_hits_fence" );
	flag_init( "player_chute_opens");
	flag_init( "truck_starts_driving");
	flag_init( "escape_chute_ready" );
	flag_init( "deploy_failed" );
}

trigger_slide()
{
	trigger = GetEnt( "hill_slide", "targetname" );
	while ( 1 )
	{
		trigger waittill( "trigger", player );
		player thread player_slide( trigger );
	}
}

player_slide( trigger )
{
	if ( IsDefined( self.vehicle ) )
		return;

	if ( self IsSliding() )
		return;
		
	if ( isdefined( self.player_view ) )
		return;

	self endon( "death" );
	
	self BeginSliding( undefined, 2.0, 0.045 );
	
	while ( 1 )
	{
		if ( !self IsTouching( trigger ) )
			break;
		self PlayRumbleOnEntity( "damage_light" );
		Earthquake( 0.1, 0.05, self.origin, 100 );
		waitframe();
	}

	self EndSliding();
}

player_escape()
{
	//setSavedDvar( "player_sprintUnlimited", "1" );
	
	flag_wait( "reveal_escape_helicopter" );
	
//	self thread player_distance_kill();
	
	flag_wait( "player_on_slope" );
	
	self thread player_dirt_overlay();
	//self thread player_adjust_sprint_speed();
	
}

player_adjust_sprint_speed()
{
	self endon( "death" );
	
	self TakeAllWeapons();
	self GiveWeapon( "freerunner" );
	self SwitchToWeapon( "freerunner" );
	
	while( !flag( "cliff_deploy_chute" ) )
	{
		if( self.origin[1] > level.price.origin[1] )
		{
			n_dist = DistanceSquared( level.price.origin, self.origin );
	
			if ( n_dist < PRICE_DISTANCE_MIN )
			{
				SetSavedDvar( "player_sprintSpeedScale", PLAYER_SPRINT_SCALE_MIN );
			}		
			else if ( n_dist < PRICE_DISTANCE_MAX )
			{
				n_speed = linear_map_clamp( n_dist, PRICE_DISTANCE_MIN, PRICE_DISTANCE_MAX, PLAYER_SPRINT_SCALE_MIN, PLAYER_SPRINT_SCALE_MAX );
				SetSavedDvar( "player_sprintSpeedScale", n_speed );
			}
			else
			{
				SetSavedDvar( "player_sprintSpeedScale", PLAYER_SPRINT_SCALE_MAX );
			}
		}
		
		wait 0.05;
	}
}

player_distance_kill()
{
	self endon( "death" );
	
	while( !flag( "cliff_deploy_chute" ) )
	{
		n_dist = DistanceSquared( level.price.origin, self.origin );
		
		if ( n_dist > PRICE_DISTANCE_MAX )
		{
			flag_set( "helicopter_shoot_player" );
		}
		else
		{
			flag_clear( "helicopter_shoot_player" );
		}
		
		wait 0.05;
	}
	
	flag_clear( "helicopter_shoot_player" );
}

player_dirt_overlay()
{
	self endon( "death" );
	
	a_direction[0] = "right";
	a_direction[1] = "left";
	a_direction[2] = "bottom";
	
	n_index = 0;
	
	while ( !flag( "stop_dirt_overlay" ) )
	{
		level.player thread maps\_gameskill::grenade_dirt_on_screen( a_direction[ n_index ] );
		n_index++;
		
		if ( n_index == a_direction.size )
		{
			n_index = 0;
		}
	
		wait 1.5;
	}
}

player_hydro_fx()
{
	flag_wait( "escape_hydro_fx" );
	
	while( flag( "escape_hydro_fx" ) )
	{
		PlayFXOnTag( getfx( "player_hydroplane" ), self.m_player_rig, "TAG_ORIGIN" );
		self PlayRumbleOnEntity( "damage_light" );
		wait 0.1;
	}
}

player_light_rumble( player_arms )
{
	level.player PlayRumbleOnEntity( "damage_light" );
	Earthquake( 0.1, 0.2, level.player.origin, 100 );
}

player_heavy_rumble( player_arms )
{
	level.player PlayRumbleOnEntity( "damage_heavy" );
	Earthquake( 0.3, 0.2, level.player.origin, 100 );
}

jump_off_cliff_sequence()
{
	maps\castle_parachute_sim::setup_player_rig();
	maps\castle_parachute_sim::setup_parachute_model();
	
	flag_wait("truck_goes_off_road");
	if(IsAlive( level.player ))
	{
		level.player LerpViewAngleClamp(0.5, 0.0, 0.0, 0,0,0,0);		
		level.player DisableWeapons();
	}
	
	node = GetVehicleNode("vehicle_jump_node", "script_noteworthy");
	node waittill("trigger");
	
	thread cliffjump_crash();		
	
	flag_wait("truck_hits_fence");
	
	thread maps\castle_truck_movement::price_hit_react();	
	wait 0.2;
	
	new_end_anims();
	
	flag_set( "player_landed_on_bank" );	
	
}

deploy_fail()
{
	self endon( "chute_deployed" );
	
	wait 1.5;
	flag_set("escape_chute_ready");
	self thread deploy_success();
	level thread hint( &"CASTLE_DEPLOY_CHUTE", 3 );
	wait 2;
		
	flag_set("deploy_failed");
	self.m_player_rig StopAnimScripted();
	self.m_player_rig Hide();
	if(isdefined(self.m_player_rig.chute))
	{
		self.m_player_rig.chute Hide();
	}
		
	level thread hint_fade();
	self Unlink();
	
	SetDvar( "ui_deadquote", &"CASTLE_FAILED_TO_DEPLOY" );
	missionFailedWrapper();
	
}

deploy_success()
{
	level endon("deploy_failed");
	
	while( !self use_button_held() )
	{
		waitframe();
	}
	
	childthread deploy_chute_opens();
	thread player_pulls_chord();	
	level.player delayThread(0.75, ::fov_lerp, 65, 0.65);
	aud_send_msg("chute_deployed");
	
	self notify( "chute_deployed" );
	level thread hint_fade();
}

deploy_chute_opens()
{
	level endon("deploy_failed");
	level.player.m_player_rig waittillmatch("single anim", "deploy_chute");
	flag_set("player_chute_opens");
	level.player LerpViewAngleClamp(0.5, 0,0, 25,25,25,25);
	
}

//self is the spawned player viewarms
player_chute()
{
	self.chute = spawn_anim_model( "secondary_chute");
	self.chute Hide();
	PlayFXOnTag( getfx( "wind_rush_chute" ), self, "tag_camera" );
	
	s_anim_align = get_new_anim_node( "anim_align_end_land" );
	s_anim_align thread anim_single_solo( self.chute, "release" );
	
	wait 2;
	
	self.chute Show();
	
	s_anim_align waittill( "release" );
	
	self.chute Delete();
}

//self is the Price's chute being animated
price_chute()
{
	//Price is in front of the player
	if( self.origin[1] < level.price.origin[1] )
	{
		if( !flag( "escape_show_chute" ) )
		{
			self Hide();
		}
		
		flag_wait( "escape_show_chute" );
		
		self Show();
	}
	//Price is behind, hide him for a few seconds to hide animation pop
	else
	{
		self Hide();
		//level.price Hide();
		
		wait 5;
		
		self Show();
		//level.price Show();
	}
	
	flag_waitopen( "escape_show_chute" );
		
	self Hide();
}

price_escape()
{
	a_nag[0] = "castle_pri_getin";
	a_nag[1] = "castle_pri_onme2"; //	Come on, let's go!!!	
	a_nag[2] = "castle_pri_overehere"; //	We have to go NOW, Yuri!		
	
	
	//until the player gets to under the gates	
	self nag_vo_until_flag( a_nag, "player_entering_truck", 10, false, true );
	
	//auto-save
	autosave_by_name( "escape_start" );
	
	//faster than normal sprint
	/*self enable_sprint();
	self set_ignoreme( true );
	self.moveplaybackrate = 1.2;
	
	s_anim_align = get_new_anim_node( "anim_align_end_run" );
	s_anim_align anim_reach_solo( self, "escape_turn" );
	
	//make sure the player keeps up with Price or mission fail
	level thread keep_up_fail();
	
	//normal movement just in case
	self.moveplaybackrate = 1.0;
	
	s_anim_align anim_single_solo( self, "escape_turn" );
	s_anim_align anim_single_solo( self, "escape_hill" );
	s_anim_align thread anim_single_solo( self, "escape_jump" );	

	//wait until Price finishes his jump animation or the player has started his chute deploy animation
	waittill_any_ents( level.player, "player_anim_started", s_anim_align, "escape_jump" );
	*/
	
	level waittill("truck_went_off_cliff");
		
	//player didn't make the jump in time
	/*if( !flag( "cliff_jumped" ) )
	{
		level.player DoDamage( level.player.health + 1000, level.player.origin );
	}*/
	
	s_anim_align = get_new_anim_node( "anim_align_end_land" );
	
	/*self.m_parachute = spawn_anim_model( "ai_parachute" );
	self.m_parachute.animname = "price_parachute";
	self.m_parachute thread price_chute();
	
	a_price_and_parachute = make_array( self, level.price.m_parachute );
	
	s_anim_align anim_first_frame( a_price_and_parachute, "escape_parachute" );
	
	flag_wait( "cliff_deploy_chute" );
		
	s_anim_align thread anim_single( a_price_and_parachute, "escape_parachute" );*/
	
	flag_wait( "player_landed_on_bank" );
	
	//s_anim_align anim_single_solo( self, "escape_finish" );
}


keep_up_fail()
{
	flag_wait_or_timeout( "escape_helicopter_move", 5.0 );
		
	if( !flag( "escape_helicopter_move" ) )
	{
		SetDvar( "ui_deadquote", &"CASTLE_FAILED_TO_FOLLOW" );
		level thread missionFailedWrapper();
	}
}

level_end( price )
{
	level.nextmission_exit_time = 2.0;
	nextmission();
}

price_escape_vo()
{
	//flag_wait( "spawned_escape_helicopter" );
	
	//wait 2.0;
	
	//	Keep moving, Yuri!	
	//self dialogue_queue( "castle_pri_keepmoving" );
	
	//flag_wait( "reveal_escape_helicopter" );
	
	//	Damn!  Enemy gunship!	
	//wait 1.0;
	//self dialogue_queue( "castle_pri_gunship" );
	//	MOVE!	
	//self dialogue_queue( "castle_pri_move2" );
	
	//trigger_wait( "escape_price_turn", "script_noteworthy" );
	
	//	Off the road!  Now!	
	//self dialogue_queue( "castle_pri_offtheroad" );
	level waittill("rpg_on_escape");
	
	wait 2.0;
	
	self dialogue_queue("castle_pri_holdon2");
		
	wait 0.75;
	self thread dialogue_queue( "castle_pri_BTRs" );
	
	node = GetVehicleNode("price_chute_line", "script_noteworthy");
	node waittill("trigger");
	
	//trigger_wait( "escape_price_chute", "script_noteworthy" );
	
	//	Hope you're still carrying your reserve, Yuri!	
	self dialogue_queue( "castle_pri_reserve" );
	
	wait 1.7;
	self dialogue_queue( "castle_pri_chuteready" );	
	
	//flag_wait("truck_goes_off_road");
	
	//self dialogue_queue( "castle_pri_jump" );
	
		
	/*trigger_wait( "escape_price_jump", "script_noteworthy" );
	//	Faster!!!	
	self dialogue_queue( "castle_pri_faster" );
	//	Don't so much as think about stopping!	
	self dialogue_queue( "castle_pri_dontthink" );*/
}

//TODO: Implement variations of the line based on level performance
variant_vo( price )
{
	
	//  Nice work back there, Son… Soap would have been proud.
	//	level.scr_sound[ "price" ][ "castle_pri_niceworkback" ] = "castle_pri_niceworkback";
	//  Soap used to think highly of you… I can't see why…
	//	level.scr_sound[ "price" ][ "castle_pri_cantseewhy" ] = "castle_pri_cantseewhy";
	
	//  That wasn't exactly one for the books, but good enough…
	price dialogue_queue( "castle_pri_oneforthebooks" );
}

btrs()
{
	flag_wait( "escape_btrs_spawned" );	
	waitframe();
	
	a_btrs = get_vehicle_array( "escape_btr", "targetname" );
	
	flag_wait("btr_shoots_truck");
	
	level thread btr_shoots_truck(a_btrs[0]);
	
	foreach( btr in a_btrs )
	{
		btr thread btr_fire_logic();
		btr maps\_vehicle::godon();
		
		//offset = randomvector( 15 ) + miss_vec + (0,0,128);
	//	btr SetTurretTargetEnt( level.player, offset );
	//	wait fireTime;
	}
	
	
	//flag_wait("btr_shoots_truck");
	
	
	
}

btr_fire_logic()
{	
	//self fireweapon();
	//self maps\_vehicle::mgon();
	self maps\_vehicle::mgoff();
	
	level waittill("btrs_shoot");
	level endon("truck_went_off_cliff");
	
	//self childthread maps\castle_courtyard_battle::courtyard_btr_mg();
	self SetTurretTargetEnt( level.player );	
	
	while(true)
	{
		self maps\castle_courtyard_battle::btr_burst(15, 0.5, level.escape_truck.dummy_target);
		wait 0.5;
	}

	//self maps\_vehicle::mgoff();
}
	

helicopter()
{
	//remove tread fx since it just rained
	maps\_treadfx::setallvehiclefx( "mi28", undefined ); 
	
	flag_wait( "spawned_escape_helicopter" );
	
	waitframe();
	
	v_heli = get_vehicle( "escape_helicopter", "targetname" );
	
	if(!IsDefined(v_heli))
	{
	   	return;
	}
	   
	flag_wait( "reveal_escape_helicopter" );
	
	s_pos = getstruct( "escape_intro_pos", "targetname" );
	v_heli SetGoalYaw( s_pos.angles[1] );
	v_heli SetTargetYaw( s_pos.angles[1] );
	v_heli SetVehGoalPos( s_pos.origin);	
	
	//heli has made entrance, begin attacking
	v_heli waittill( "goal" );
		
	s_pos = getstruct( s_pos.target, "targetname" );
	v_heli SetGoalYaw( s_pos.angles[1] );
	v_heli SetTargetYaw( s_pos.angles[1] );
	v_heli SetVehGoalPos( s_pos.origin, true );	
	
	v_heli thread helicopter_attack_think();
	
	level thread helicopter_trees();
	
	flag_wait( "escape_helicopter_move" );
	
	gopath( v_heli );
	
	/*s_pos = getstruct( s_pos.target, "targetname" );
	v_heli SetGoalYaw( s_pos.angles[1] );
	v_heli SetTargetYaw( s_pos.angles[1] );
	v_heli SetVehGoalPos( s_pos.origin, true );	*/
	
	/*flag_wait( "cliff_deploy_chute" );
	
	wait 5.0;
	
	v_heli maps\_vehicle::vehicle_paths( getstruct( "escape_heli_end", "targetname" ) );*/
}

#using_animtree( "script_model" );
helicopter_trees()
{
	m_tree_large = GetEnt( "fxanim_castle_tree_large_sway_mod", "targetname" );
	m_tree_large.animname = "tree_large";
	m_tree_large UseAnimTree( #animtree );
	m_tree_large thread anim_loop_solo( m_tree_large, "sway" );
	
	m_tree_small = GetEnt( "fxanim_castle_tree_small_sway_mod", "targetname" );
	m_tree_small.animname = "tree_small";
	m_tree_small UseAnimTree( #animtree );
	m_tree_small thread anim_loop_solo( m_tree_small, "sway" );	
	
	a_trees = GetEntArray( "chopper_tree", "script_noteworthy" );
	
	foreach( tree in a_trees )
	{
		tree notify( "trigger" );
		wait RandomFloatRange( 0.5, 1.0 );
	}
	
	flag_wait( "escape_helicopter_move" );
	m_tree_small thread anim_single_solo( m_tree_small, "stop" );
	m_tree_large thread anim_single_solo( m_tree_large, "stop" );
}

helicopter_attack_think()
{
	while( !flag( "cliff_deploy_chute" ) )
	{
		if( flag( "helicopter_shoot_player" ) )
		{
			self helicopter_fire_at_player( level.player );
		}
		else
		{
			self helicopter_miss_player( level.player );
		}
		wait 0.5;
	}
}

helicopter_miss_player( player )
{
	//point in front of player
	forward = AnglesToForward( level.player.angles );
	forwardfar = ( forward* 100 );
	miss_vec = forwardfar + randomvector( 50 );
		
	burstsize = randomintrange( 4, 6 );
	fireTime = .2;
	for ( i = 0; i < burstsize; i++ )
	{
		offset = randomvector( 15 ) + miss_vec + (0,0,128);
		self setturrettargetent( player, offset );
		self fireweapon();
		wait fireTime;
	}
}

helicopter_fire_at_player( player )
{
	burstsize = randomintrange( 3, 5 );
	println("         **HITTING PLAYER, burst: " + burstsize );
	fireTime = .2;
	for ( i = 0; i < burstsize; i++ )
	{
		self setturrettargetent( player, randomvector( 20 ) + ( 0, 0, 32 ) );//randomvec was 50
		self fireweapon();
		wait fireTime;
	}
}

setup_destroyable_tree()
{
	small_tree = false;
	tree_base = getent( self.target, "targetname" );
	destroyed_top = undefined;
	clip_brush = undefined;
	if( tree_base.model == "foliage_tree_pine_snow_tall_b_broken_btm" )
	{
		small_tree = true;
		tree_base.endmodel = tree_base.model;
		tree_base setmodel( "ctl_foliage_tree_pine_tall_b" );
	}
	else
	{
		tree_base.endmodel = tree_base.model;
		tree_base setmodel( "ctl_foliage_tree_pine_tall_c" );
	}
	parts = getentarray( tree_base.target, "targetname" );
	foreach( part in parts )
	{
		if( part.classname == "script_model" )
			destroyed_top = part;
		if( part.classname == "script_brushmodel" )
			clip_brush = part;
	}
	assert( isdefined( destroyed_top ) );
	destroyed_top.goalangles = destroyed_top.angles;
	destroyed_top.angles = tree_base.angles;
	destroyed_top hide();
	
	
	hits_ground = false;
	if( ( isdefined( destroyed_top.script_noteworthy ) ) && ( destroyed_top.script_noteworthy == "hits_the_ground" ) )
		hits_ground = true;
	
	if( isdefined( clip_brush ) )
	{
		assert( hits_ground );
		clip_brush notsolid();
	}
		
	self waittill( "trigger" );
	
	v_shot = destroyed_top.origin - self.origin;
	v_forward = AnglesToForward( v_shot );
	v_up = AnglesToUp( v_shot );
	PlayFX( getfx( "bullet_strafe" ), self.origin, v_forward, v_up );
		
	tree_base setmodel( tree_base.endmodel );
	forward = AnglesToForward( destroyed_top.angles );
	up = AnglesToUp( destroyed_top.angles );
	
	//play splinter FX in the opposite direction of where the tree will fall
	PlayFX( getfx( "tree_trunk_snap" ), destroyed_top.origin, up, (-1 * forward) );

	//play water coming off branches FX
	playfx( getfx( "tree_fall_impact_wet" ), destroyed_top.origin, up , forward );

	destroyed_top show();

	pre_hit_fx_time = .25;
	
	if( small_tree )
	{
		pre_hit_fx_time = pre_hit_fx_time - .25;
	}
	
	drop_time = 2;
	accel_time = drop_time;
	destroyed_top RotateTo( destroyed_top.goalangles, drop_time, accel_time, 0 );
	
	wait ( drop_time - pre_hit_fx_time );
	
	if( hits_ground )
	{
		forward = AnglesToForward( destroyed_top.angles );
		up = AnglesToUp( destroyed_top.angles );
    	playfx( getfx( "tree_shake_wet" ), destroyed_top.origin , up , forward );
	}
	wait pre_hit_fx_time;
	
	//tree has stopped falling
	if( hits_ground )
	{
		clip_brush solid();
		clip_brush thread tree_clip_fx();
	}
	
	if( ( hits_ground ) && ( !small_tree ) )
	{
		if( level.player point_in_fov( destroyed_top.origin ) )
			Earthquake( 0.3, .3, destroyed_top.origin, 2000 );
	}
	
	if( !hits_ground )
	{
		forward = AnglesToForward( destroyed_top.angles );
		up = AnglesToUp( destroyed_top.angles );
    	playfx( getfx( "tree_shake_wet" ), destroyed_top.origin , up , forward );
	}
	
	shake_time = .2;
	
	destroyed_top movez( 4, shake_time, 0, shake_time );
	wait shake_time;
	
	destroyed_top movez( -3, shake_time, 0, shake_time );
	wait shake_time;
	
	destroyed_top movez( 2, shake_time, 0, shake_time );
	wait shake_time;
	
	destroyed_top movez( -1, shake_time, 0, shake_time );
	wait shake_time;	
}

tree_clip_fx()
{
	while( 1 )
	{
		if( level.player IsTouching( self ) )
		{
			level.player SetBlurForPlayer( 25, 0 );
			//level.player ShellShock( "default", 2.0 );
			Earthquake( 0.3, 0.5, level.player.origin, 100 );
			level.player PlayRumbleOnEntity( "damage_heavy" );
			waitframe();
			level.player SetBlurForPlayer( 0, 0.5 );
			wait 0.5;
			return;
		}
		waitframe();
	}
}


///////////////////////////////////////////////////////////////////////
//New ending stuff
////////////////////////////////////////////////////////////////////////

setup_escape_truck()
{
	thread escape_drive_events();
	
	truckspawner = getent("escape_truck", "targetname");
	truck = truckspawner spawn_vehicle();
//	truck DoDamage(truck.health - 10, truck.origin);
	
	truck maps\_vehicle::godon();
//	truck.vehicle_stays_alive = true;
	
	truck.dontunloadonend = true;
	//truck.BadPlaceModifier = 2.0;
	
	tag = spawn_tag_origin();
	
	tag.origin = truck GetTagOrigin("TAG_PLAYER1_ROTATE");
	tag.origin = (tag.origin[0], tag.origin[1], tag.origin[2] - 20);
	
	tag.angles = truck GetTagAngles("TAG_PLAYER1_ROTATE");
	tag LinkTo(truck, "TAG_PLAYER1_ROTATE");
		
	truck.player_attach_spot = tag;
	level.truck_attach_tag = "tag_origin";
		
	level.escape_truck = truck;
	
	truck thread maps\castle_truck_movement::truck_reaches_bottom_of_hill();
	//level waittill("get_to_truck");
	flag_wait("get_to_escape_truck");
	truck_door = Spawn("script_model",truck.origin);
	truck_door SetModel("vehicle_uaz_open_player_ride_door_backl_obj");
	truck_door.angles = truck.angles;
	truck_door LinkTo(truck, "body_animate_jnt");			
	//truck_door hide();
	
	dummy_target = spawn_tag_origin();
	dummy_target.origin = truck GetTagOrigin("TAG_HOOD_FX") + (0,0, 30);
	dummy_target linkto(truck);
	truck.dummy_target = dummy_target;
	
	use_target = getent("escape_truck_use_target", "targetname");
	use_target SetCursorHint("HINT_ACTIVATE");
	use_target SetHintString(&"CASTLE_CLIMB_IN");
	use_target MakeUsable();
	
	//use_target waittill("trigger");	
	use_target thread trigger_flag_on_use("player_entering_truck");
	flag_wait("player_entering_truck");	
	
	use_target delete();
	truck_door delete();			
	
}

trigger_flag_on_use(flag)
{
	self waittill("trigger");
	flag_set(flag);
}

escape_drive_events()
{
	if(level.start_point == "cliff")
	{
		return;
	}
	flag_wait("player_entering_truck");
	
	//enemies will flood the landing pad and fire at the player
	thread player_entered_truck_spawn();
	thread fire_rpg_at_truck();
	
	level.player DisableWeapons();
	
	level.player AllowCrouch(false);
	level.player thread deathshield_except_grenades();
	maps\castle_truck_movement::player_mounts_truck();
	
	stop_exploder ( 8000 );
	
	level.player PlayerLinkToBlend(level.escape_truck.player_attach_spot, level.truck_attach_tag, 0.2, 0.1, 0.1);
	wait 0.2;
		
	level.player EnableWeapons();
	
	truck_ride();	
}

player_entered_truck_spawn()
{
	targetname = "player_on_truck";
	spawners = GetEntArray( targetname, "targetname" );
	if ( spawners.size > 0 )
	{
		array_spawn_targetname( targetname, 1, 1 );
	}

	activate_trigger( "courtyard_kill_200", "targetname" );
	level notify( "notify_player_entered_car" );
}

fake_deathshield()
{
	while(true)
	{
		self waittill( "damage", damage, attacker, direction, point, type );
		
		if ( attacker != self)
		{
			self.health  += int(damage * 0.5); //max(1, self.health - damage);
			
		//	level.player.health += int( ammount * .2 );
		}
	}
}

deathshield_except_grenades()
{
	while(true)
	{
		if(self IsThrowingGrenade())
		{
			self EnableDeathShield(false);
			if(flag("through_escape_doors"))
			{
				self DisableInvulnerability();
			}
		}
		else
		{
			self EnableDeathShield(true);			
			if(flag("through_escape_doors"))
			{
				self EnableInvulnerability();
			}
		}
		wait 0.05;
	}
}

fire_rpg_at_truck()
{
	flag_wait( "rpg_on_escape" );
	rpg1_start = getStruct( "truck_rpg1_start", "targetname" );
	rpg1_target = getStruct( "truck_rpg1_target", "targetname" );
	target_ent1 = Spawn( "script_origin", rpg1_target.origin );
	missileAttractor1 = Missile_CreateAttractorEnt( target_ent1, 200000, 2000 );
	rpg = magicBullet( "rpg_straight", rpg1_start.origin, rpg1_target.origin );	
	wait 7;
	Missile_DeleteAttractor( missileAttractor1 );
}

truck_fx(truck)
{

	level waittill("truck_moving");
	
	level.truck_fire_fx = spawn_tag_origin();
	//level.truck_fire_fx.origin = truck.origin;
	level.truck_fire_fx LinkTo(truck, "tag_hood_fx", (0, 0, 0), (0, 0, 0));
	level waittill("truck_gets_shot");
	
	PlayFXOnTag(getfx("castle_truck_damage_moving"), level.truck_fire_fx, "tag_origin");
	
	level waittill("truck_swap", newtruck);
	
	level.truck_fire_fx linkto(newtruck,"tag_hood_fx", (0, 0, 0), (0, 0, 0));
}

truck_ride()
{
	truck = level.escape_truck;
	thread truck_fx(truck);
	//thread maps\westminster_truck_movement::manage_player_position(truck);
	
	level.player AllowCrouch(false);
	link_to_truck(true, 0.8);
	level notify("start_manage_player_position");
	
	level.player delayThread (1.0, ::player_regen_increase);
	
	flag_wait("price_in_truck");
    
	aud_send_msg("start_driving");
	
	//wait 1.0;
	thread flag_set_delayed("truck_starts_driving", 1.0);
	flag_wait("truck_starts_driving");
	
	maps\castle_escape_new::truck_lights_on(level.escape_truck, true);	
	path = GetVehicleNode("escape_path_start", "targetname");
	
	truck 	StartPath(path);
	truck thread vehicle_paths(path);
	level notify("truck_moving");
	
	level.price thread delayThread(0.5, ::dialogue_queue, "castle_pri_detonating");
	delaythread(1.5, maps\castle_courtyard_battle::courtyard_detonate_c4, level.price);
		
	
	
	// aud_send_msg("truck_ride");
	aud_send_msg("truck_ride_start");
	                    
	thread escape_doors();
	thread player_linking();
	//truck waittill("reached_path_end");
	
	jump_node = GetVehicleNode("vehicle_jump_node", "script_noteworthy");
	jump_node waittill("trigger");
	
	//truck PlayLoopSound("so_jeep_fast");
	truck StopLoopSound();
	
	
	flag_set("truck_went_off_cliff");
}

btr_shoots_truck(btr)
{
	
	//wait 1.0;
	source = btr.origin;
	
	target = level.escape_truck GetTagOrigin("tag_hood_fx");
	
	PlayFX( getfx( "bmp_flash_wv" ), source, VectorNormalize(target-source), ( 0,0,1 ) );
	MagicBullet("btr80_turret2", source, target);
	wait 0.5;
	
	level notify("btrs_shoot");
	wait 0.3;
	level notify("truck_gets_shot");
	maps\castle_truck_movement::truck_hood_rattle(level.escape_truck);
	
}

link_to_truck(useDelta, viewFraction, useabsolute)
{
	attach_tag = level.truck_attach_tag;
	b = level.escape_truck.player_attach_spot;
	
	if(useDelta)
	{
		level.player PlayerLinkToDelta(b, attach_tag , viewFraction);
	}
	else if( isdefined(useabsolute) && useabsolute)
	{
		level.player PlayerLinkToAbsolute(b, attach_tag);
	}
	else
	{
		level.player PlayerLinkTo(b, attach_tag, viewFraction);
	}	
}

player_linking()
{
	node = GetVehicleNode("escape_on_hill", "script_noteworthy");
	node waittill("trigger");
	flag_set( "rpg_on_escape" );
	
	
	//level waittill("hit_escape_doors");
	wait 0.1;
	link_to_truck(true, 0.5);
	
	node = GetVehicleNode("reached_bottom_of_hill", "script_noteworthy");
	node waittill("trigger");
	level notify("reached_bottom_of_hill");
	
	link_to_truck(true, 0.8);	
}

escape_rumble()
{
	node = GetVehicleNode("escape_on_hill", "script_noteworthy");
	node waittill("trigger");
	thread hillRumble("stop_hill_rumble");
	//heavy rumble, shakes	
	
	node = GetVehicleNode("reached_bottom_of_hill", "script_noteworthy");
	node waittill("trigger");
	level notify("stop_hill_rumble");
	
	thread roadRumble("stop_road_rumble");
	
	flag_wait("truck_went_off_cliff");
	level notify("stop_road_rumble");
	
}

hillRumble(ender)
{
	level endon(ender);
	while(true)
	{
		level.player PlayRumbleOnEntity("damage_heavy");
		Earthquake(0.25, 0.2, level.player.origin, 400);
		wait .15;
	}
}

roadRumble(ender)
{
	level endon(ender);
	while(true)
	{
		//level.player PlayRumbleOnEntity("damage_heavy");
		Earthquake(0.3, 0.4, level.player.origin, 600);
		level.player PlayRumbleOnEntity("damage_light");
		wait RandomFloatRange(0.5, 1.5);
	}
}

escape_doors()
{
	//node = GetVehicleNode("escape_gatecrash_node", "script_noteworthy");
	//node waittill("trigger");
	flag_wait("through_escape_doors");
	
	level notify("hit_escape_doors");
	thread maps\castle_truck_movement::price_hit_react();
	thread maps\castle_truck_movement::truck_windshield_breaks(level.escape_truck);
	
	thread escape_doors_set_open(true);	
	maps\_compass::setupMiniMap("compass_map_castle_road", "road_minimap_corner");
	
	//level.player EnableInvulnerability();
	
	aud_send_msg("truck_doors_crash");
}


player_regen_increase()
{
    level.player.gs.invultime_onshield = 2;
    level.player.gs.invultime_postshield = 2;
    level.player.gs.invultime_preshield = 2;
    level.player.gs.longregentime = 250;
    //level.player.gs.player_attacker_accuracy = .1;
    level.player.gs.playerhealth_regularregendelay = 500;
    level.player.gs.invultime_postshield = 2;
    level.player.gs.regenrate = .33;
    level.player.gs.worthydamageratio = .01;
}


price_turning()
{
	level waittill("hit_escape_doors");
	wait 0.75;
	
	thread maps\castle_truck_movement::price_turn_right();
	
	wait 1.35;
	thread maps\castle_truck_movement::price_turn_left();
	
	wait 2.15;
	
//	level waittill("reached_bottom_of_hill");
	
	thread maps\castle_truck_movement::price_turn_left();	
	
	
	node = GetVehicleNode("price_chute_line", "script_noteworthy");
	node waittill("trigger");
	
	wait 1.0;
	thread maps\castle_truck_movement::price_turn_right();
	
	
}

escape_doors_set_open(bOpen)
{
	escape_gate_left = getent("escape_gate_left", "targetname");
	escape_gate_right = getent("escape_gate_right", "targetname");

	if(bOpen)
	{
		escape_gate_left RotateYaw(90, 0.2, 0, .1);
		escape_gate_right RotateYaw(-90, 0.15, 0, .1);		
		
		
		level.player PlayRumbleOnEntity( "damage_heavy" );
		Earthquake( 1.0, 0.8, level.player.origin, 500 );
		exploder ( 2000 ); //Impact sparks on truck as it smashes through metal doors
		stop_exploder ( 9100 ); //stop all water splash fx as the truck smashes through metal doors
		exploder ( 650 ); //start lights near cliff guard tower
	}			
	else
	{						
		escape_gate_left RotateYaw(-90, 1.0, 0, .05);
		escape_gate_right RotateYaw(90, 1.0, 0, .05);		
	}
}

#using_animtree("animated_props");

fov_lerp(val, duration)
{
	//self LerpFOV(val, duration);
}

set_slow_motion(start, end, time)
{
	SetSlowMotion(start,end,time);
}
	
new_end_anims(player_rig)
{
	
	level.player thread deploy_fail();		
	level endon("deploy_failed");
	

	//start player's anim
	origin = getstruct("new_end_origin", "targetname");
	origin.angles = (0,0,0);
	
	origin thread do_player_anim("cliffjump_new", undefined, false, 0.0, false, true, 0,0,0,0);	
	level.player.m_player_rig delayThread(0.05, ::do_hide);
	
	//spawn a visible hands model 
	level.visible_hands = spawn_anim_model("player_rig", level.player.m_player_rig.origin);	
	level.visible_hands LinkTo(level.player.m_player_rig, "tag_player", (0,0,0),(0,0,0));
	level.visible_hands hide();
	
	level.player.m_player_rig anim_first_frame_solo(level.visible_hands, "escape_player_deploy_chute", "tag_player");
	
	//thread truck_explodes();	
	thread new_end_glide_player();
	
	level.player waittill( "player_anim_started" );
	level.player PlayerLinkToDelta(level.visible_hands, "tag_player", 1.0, 0,0,0,0,true);
	

	//slowmo, fov lerp etc.	
	level.player  delayThread(0.5, ::fov_lerp, 75, 0.5);
	
	slow_duration = 0.5;
	
	level.player delayThread(0.25, ::set_slow_motion, 1.0, 0.25, 0.5);
	level.player delayThread(0.85, ::set_slow_motion, 0.25, 1.0, 0.5);
	
	
	//swap truck
	old_truck = level.escape_truck;	
	truck_lights_on(old_truck, false);	
	level.price unlink();
	
	truck = spawn_anim_model("escape_truck", level.escape_truck.origin);		
	level notify("truck_swap", truck);
	
	delayThread(0.1, ::truck_lights_on, truck, true, true, false);
	
	truck HidePart("tag_glass_front");
	truck HidePart("tag_glass_front_d");	
	truck HidePart("J_windshield_frame");
	
	truck.angles = level.escape_truck.angles;
	truck.origin = level.escape_truck.origin;
	
	//PlayFXOnTag(getfx("castle_truck_damage_moving"), truck, "tag_hood_fx");
	
	
	//remove price from riders array so the system doesn't think he's still attached
	old_truck.riders = array_remove( old_truck.riders, level.price );
    old_truck.usedPositions[ 0 ] = false;
    
    old_truck delete();	
	guys = [];
	guys[0] = level.price;
	guys[1] = truck;
	
	chute = spawn_anim_model("escape_chute_price", level.price.origin);
	chute hide();
	
	chute2 = spawn_anim_model("escape_chute_price_2", level.price.origin);
	chute2 hide();
	
		
	guys[2] = chute;
	guys[3] = chute2;
	
	chute thread price_chute_show(chute, chute2);	
	
	origin thread anim_single(guys, "cliffjump_new");
	thread nikolai_end_line();
	
	//play glide anims	
	len = GetAnimLength(level.player.m_player_rig getanim("cliffjump_new"));
	
   	level.player.m_player_rig waittill_match_or_timeout("single anim", "fade_out", len-0.75);
   	level_end(level.price);	
	
    	
}

truck_explodes()
{
	//level.player.m_player_rig waittillmatch("truck_explodes");
	aud_send_msg("escape_truck_explodes");
	
	if(flag("deploy_failed"))
	{
		//yada yada yada
	}
	//explosion effect
	exploder ( 4000 );	
}

new_end_glide_player()
{
	level endon("deploy_failed");
	
	playerchute = spawn_anim_model("escape_chute_player", level.player.m_player_rig.origin);
	playerchute LinkTo(level.player.m_player_rig, "tag_player", (0,0,0),(0,0,0));
	playerchute hide();
	
	//hands = spawn_anim_model("player_rig", level.player.m_player_rig.origin);	
	//hands LinkTo(level.player.m_player_rig, "tag_player", (0,0,0),(0,0,0));
	//hands hide();
	
	
	
	
	level.player.m_player_rig anim_first_frame_solo(playerchute, "cliffjump_glide", "tag_player");
		
	level.player.m_player_rig waittillmatch("single anim", "start_glide_anim");
	playerchute delayThread(0.05, ::do_show);
	
	guys = [];
	guys[0] = playerchute;
	guys[1] = level.visible_hands;	
	
	
	level.player.m_player_rig thread anim_single(guys, "cliffjump_glide", "tag_player" );
	wait 0.5;
	if(IsAlive(level.player))
	{
		level.player LerpViewAngleClamp(0.5, 0.1, 0.1, 25,25,25,25);		
	}
	
	
	
}

price_chute_show(chute1, chute2)
{
	level.price waittillmatch("single anim", "unhide_chute");
	chute1 show();
	
	//switch to a higher res chute
	level.price waittillmatch("single anim", "switch_parachutes");	
	
	chute1 delete();
	chute2 show();
	
}

do_show()
{
	self show();
}

do_hide()
{
	self hide();
}

player_pulls_chord()
{
	hands = level.visible_hands;
	
	ripcord = spawn_anim_model("player_rig_ripcord", level.player.m_player_rig.origin);
	ripcord LinkTo(level.player.m_player_rig, "tag_player", (0,0,0),(0,0,0));
	ripcord hide();
	ripcord delayThread(0.05, ::do_show);	
	
	//level.player PlayerLinkToDelta(level.visible_hands, "tag_player", 1.0, 0,0,0,0,true);
	
	
	//guys = [];
	//guys[0] = ripcord;
	//guys[1] = hands;
	
		
	hands delayThread(0.1, ::do_show);	
	level.player.m_player_rig  thread anim_single_solo(hands, "escape_player_deploy_chute", "tag_player");	
	level.player.m_player_rig  thread anim_single_solo(ripcord, "escape_player_deploy_chute", "tag_player");	
	
	
	//hands Delete();
}

nikolai_end_line()
{
	level.player.m_player_rig waittillmatch("single anim", "vo_line_nikolai");
	radio_dialogue("castle_nik_onmyway");	                          
}

cliffjump_crash()
{
	wait 0.5;
	level.player PlayRumbleOnEntity( "damage_heavy" );
	Earthquake( 1.0, 0.4, level.player.origin, 500 );
	aud_send_msg("truck_off_cliff");
	//level.player shellshock( "default", 1.5 );
	
}

truck_lights_on(truck, on, bUseBeams, bUseDlight)
{
	headlight_fx = level._effect["car_headlight_beam_50_percent"];
	taillight_fx = level._effect["uaz_taillight"];
	
	//level.escape_truck maps\_vehicle::lights_on( "headlights" );
// 	level.escape_truck maps\_vehicle::lights_on( "brakelights" );
 	
	if(on)
	{
		if( isdefined(bUseBeams) && bUseBeams)
		{
			
	 		PlayFXOnTag( headlight_fx, truck, "TAG_LIGHT_RIGHT_FRONT" );
			PlayFXOnTag( headlight_fx, truck, "TAG_LIGHT_LEFT_FRONT" );
			PlayFXOnTag( taillight_fx, truck, "TAG_LIGHT_LEFT_TAIL" );
			PlayFXOnTag( taillight_fx, truck, "TAG_LIGHT_RIGHT_TAIL" );
		}
		
	 	//attach an actual dlight to the front of the thing to help light up the road in front of us
	 	tag = spawn_tag_origin();
	 	left_origin = truck GetTagOrigin("tag_light_left_front");
	 	right_origin = truck GetTagOrigin("tag_light_right_front");
	 	tag.origin =  (left_origin + right_origin) * 0.5;
	 	tag.angles = truck GetTagAngles("tag_light_right_front");
	 	tag LinkTo(truck, "tag_light_left_front", (0,0,0), (0,0,0));
	 	if(!IsDefined(bUseDlight))
	 	{
	 		bUseDlight = true;	 		
	 	}
	 	
	 	if(bUseDlight)
	 	{
	 		PlayFXOnTag(getfx("spotlight_dlight"), tag, "tag_origin");
	 	}
	 	
	 	truck.light_tag = tag;
	}
	else
	{
		StopFXOnTag(getfx("spotlight_dlight"), truck.light_tag, "tag_origin");
		StopFXOnTag( headlight_fx, truck, "TAG_LIGHT_RIGHT_FRONT" );
		StopFXOnTag( headlight_fx, truck, "TAG_LIGHT_LEFT_FRONT" );
		StopFXOnTag( taillight_fx, truck, "TAG_LIGHT_LEFT_TAIL" );
		StopFXOnTag( taillight_fx, truck, "TAG_LIGHT_RIGHT_TAIL" );
		truck.light_tag delete();
		
	}
	
	
}

fence_pieces()
{
	origins = getstructarray("escape_physics_explosion", "script_noteworthy");
	foreach (spot in origins)
	{
		spot thread fence_explosion();
	}
	
	level.fence_exploder_num = 200;
}

fence_explosion()
{
	
	while(IsDefined(level.escape_truck) && length(level.escape_truck.origin - self.origin) > 115)
	{
		wait 0.05;	
	}
	
	if (IsDefined(self.script_exploder))
	{
		exploder(level.fence_exploder_num);
		level.fence_exploder_num += 1;
	}
	
	RadiusDamage( self.origin, 100, 1, 1);
	
	
	PhysicsExplosionSphere(self.origin, 100,100,50);
	
	aud_send_msg("fence_debris");
}

crash_through_fence()
{
	node = getvehiclenode("escape_fence_crash", "script_noteworthy");
	node waittill("trigger");
	
		
	
	
	//some wiggle room here for timing, the node is a couple feet before the fence
	wait 0.02;
	
	//PlayFXOnTag(getfx("castle_truck_damage_moving"), level.escape_truck, "tag_hood_fx");
	
	//to break away actual destructible pieces
	PhysicsExplosionSphere(node.origin, 500,500, 50);
	
	exploder ( 2200 ); //fx fence particles
	exploder ( 2201 );	// brick wall particles
	exploder ( 8100 ); //start river water rapid fx
	
	//moved to truck_explodes function to be driven by a notetrack (to match up with audio)
	wait 3.85;
	truck_explodes();
	//exploder ( 4000 );
}
	
	
	
