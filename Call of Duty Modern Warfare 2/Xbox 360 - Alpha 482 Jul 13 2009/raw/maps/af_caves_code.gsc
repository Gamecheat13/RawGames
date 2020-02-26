#include maps\_utility;
#include common_scripts\utility;
#include maps\_hud_util;
#include maps\_anim;
#include maps\_stealth_utility;
#include maps\af_caves;
#using_animtree( "generic_human" );

//	****** Player setup ****** //
set_player_positions()	//This is the player's position at the start of the level
{
	level.player SetOrigin( ( 4993.7, 14416.9, -1315.6 ) );
	level.player SetPlayerAngles( ( 6, 48, 1 ) );
	wait .05;
	level.player SetStance( "crouch" );
	level.player disableweapons();
	level.player freezeControls( true );
	level.player stealth_default();
}

price_spawn()
{	
	level.price = self;
	level.price.animname = "price";
	level.price thread magic_bullet_shield();
	level.price cqb_walk( "on" );
	level.price allowedstances( "prone" );
}

price_free_to_kill()
{
	flag_wait ( "enemies_alerted" );
	
	activate_trigger_with_targetname( "spawner_backdoor_barracks_reinforcement_guys_grp1" );
	
	//Price: "So much for stealth" 
	radio_dialogue( "pri_somuch" );

	level.price.ignoreall = false;
	level.price.ignoreame = false;

	level.price enable_ai_color();
	level.price set_force_color( "b" );
	
	level endon( "price_is_red_flag" );
	
	thread set_price_color_red();
	
	enemies = getaiarray( "axis" );
	waittill_dead_or_dying( enemies );
	
	activate_trigger_with_targetname( "price_to_steamroom" );

	//Price: "Clear. Move."
	radio_dialogue( "pri_clearmove" );

	level.price set_force_color( "r" );
	level.price.ignoreame = false;
	
	level notify( "price_is_red_enemies_dead" );
	
	flag_clear ( "enemies_alerted" );
}

set_price_color_red()
{
	level endon( "price_is_red_enemies_dead" );
	
	flag_wait( "set_price_color_red" );
	
	level.price enable_ai_color();
	level.price set_force_color( "r" );
	level.price.ignoreame = false;
	
	level notify( "price_is_red_flag" );
	
	flag_clear( "set_price_color_red" );
	flag_clear ( "enemies_alerted" );
}

stealth_enemy_alerted()
{
	flag_wait ( "_stealth_spotted" );
	flag_set ( "enemies_alerted" );
	battlechatter_on( "axis" );

	flag_set( "destroy_tv" );
}

/*
kill_sentry_minigun()
{
	lookout_minigun = getentarray( "sentry_minigun", "targetname");	
	foreach ( minigun in lookout_minigun )
	minigun kill();
}
*/

//	****** TV SETTINGS ****** //

tv_movie()
{
	level endon( "stop_cinematic" );

	for ( ;; )
	{
	  CinematicInGameLoopResident( "gulag_securitycam" ); // Todo: Change this when we get one for this level.

	  wait 5;

	  while ( IsCinematicPlaying() )
		wait 1;
	}
}

backdoor_barracks_tv_light()// turns off when tv gets shot
{
	light = getent( "tv_light", "targetname" );

	wait_for_targetname_trigger( "tv_trigger" );
	light SetLightIntensity( 0 );
}

backdoor_barracks_destroy_tv()// destroy it when stealth is broken or if the player passes by the stealth area.
{
	flag_wait( "destroy_tv" );
	
	wait( randomintrange( 2, 4 ) );
	exploder( "stealth_broken" );// destroy the tv
	
	light = getent( "tv_light", "targetname" );
	light SetLightIntensity( 0 );
}

enemy_be_aggressive()// specific badies through out the level don't hang around cover for long, watch out.
{
	self.aggressivemode = true;
	self.doorFlashChance = .5;
}

rpg_guys()// fires rpgs near the player when the player comes out of the cavern exit.
{
	// rpg guy will show up and fire one rgp at a random target and then become a normal guy.
	// target node needs to target atleast one script_origin, or the ai have a self.rocket_target

	assertEX( issubstr( ToLower( self.classname ), "rpg" ), "Actor with export: " + self.export + " doesn't have an RPG!" );

	self endon( "death" );

	self set_ignoreme( true );
	self.combatmode = "no_cover";

	goal = getnode( self.target, "targetname" );
	self setgoalnode( goal );
	
	timeout = 5000;

	self.a.rockets = goal.script_shotcount;
	target_arr = getentarray( goal.target, "targetname" );

	for ( i=0; i<goal.script_shotcount; i++ )
	{
		etarget = random( target_arr );

		if ( isdefined( etarget.script_parameters ) && etarget.script_parameters == "straight" )
			self SetStableMissile( true );

		self SetEntityTarget( etarget, 1 );
		self waittill_notify_or_timeout( "missile_fire", timeout );
		
		flag_wait( "location_change_control_room" );
		
		self waittill( "projectile_impact", weaponName, position, radius );
		flag_set( "rpg_hit" );
	}

	wait 2;

	self ClearEntityTarget();
	
	self.goalradius = 1024;
	self.combatmode = "cover";
	self set_ignoreme( false );
	self notify( "rpg_guy_done" );		
}

//	****** Littlebird Settings ****** //

fake_target_delete( fake_target )
{
	self waittill( "death" );
	fake_target delete();
}

my_mg_off()
{
	foreach ( i, turret in self.mgturret )
	{
		if ( IsDefined( turret.script_fireondrones ) )
			turret.script_fireondrones = false;

		turret SetMode( "manual" );
	}
}


link_fake_target( heli )
{
	forward = anglestoforward( heli.angles );
	spot = self.origin + forward * 700 + ( 0,0,-200 );// * 700 -200

	self.fake_target = spawn( "script_model", spot );
//	self.fake_target setmodel( "fx" );
	self.fake_target linkto( self );
}

ent_array_sort( array )
{
	// sort ents by order of script_index

	for( i=0; i<array.size; i++ )
	{
		for( j=i; j<array.size; j++ )
		{
			if ( array[j].script_index < array[i].script_index )
			{
				tmp = array[j];
				array[j] = array[i];
				array[i] = tmp;
			}
		}
	}
	return array;
}

Fire_Missile_Setup()
{
	run_thread_on_noteworthy( "fire_missile", ::fire_missile_thread );
}

fire_missile_thread()
{
	self endon( "death" );
	self waittill( "trigger", vehicle );
	struct_arr = getstructarray( self.target, "targetname" );
	struct_arr = ent_array_sort( struct_arr );

	tags = [];
	tags[0] = "tag_missile_right";
	tags[1] = "tag_missile_left";

	ents = [];

	foreach( index, struct in struct_arr )
	{
		ents[ index ] = spawn( "script_origin", struct.origin );

		vehicle SetVehWeapon( "littlebird_FFAR" );
		vehicle SetTurretTargetEnt( ents[ index ] );
		missile = vehicle FireWeapon( tags[ index % tags.size ], ents[ index ], (0,0,0) );

		missile delaycall( 1, ::Missile_ClearTarget );

		wait randomfloatrange( 0.2, 0.3 );
	}

	wait 10;
	foreach( ent in ents )
	{
		ent delete();
	}
}

/*
set_off_outdoor_exploders()
{
	self endon( "death" );
	exploders = get_exploder_array( "heli_chase" );
	foreach ( ent in exploders )
	{
		ent.origin = ent.v[ "origin" ];
	}
		
	for ( ;; )
	{
		ent = getClosest( self.origin, exploders );
		ent activate_individual_exploder();
		timer = randomfloatrange( 0.1, 0.2 );
		wait( timer );
	}
}
*/

//	****** Flashlight Settings ****** //
attach_flashlight()
{
	PlayFXOnTag( level._effect[ "flashlight" ], self, "tag_flash" );
	self.have_flashlight = true;
}

//	****** Player Rappel stuff ****** //
delay_lerpViewAngleClamp()
{
	wait( 0.2 );
	level.player lerpViewAngleClamp( 1, 0.5, 0.5, 45, 45, 45, 45 );
}

should_stop_descend_hint()
{
	return flag( "player_braked" );
}

player_gets_groundref_and_opens_fov( tag_origin )
{
	level.player PlayerSetGroundReferenceEnt( tag_origin );
	tag_origin waittill( "open_fov" );	
	open_up_fov( 0.5, tag_origin, "tag_origin", 25, 25, 15, 15 );
}

af_caves_rappel_behavior()
{
	old_weapon = level.player GetCurrentWeapon();
	
	level.player DisableWeapons();
	weapon = "rappel_knife";
	level.player GiveWeapon( weapon );
	level.player SwitchToWeapon( weapon );
	
	ent = getent( "rappel_animent", "targetname" );

	// first hook up
	player_rig = spawn_anim_model( "player_rig" );
	player_rig hide();
	
	ending_player_rig = spawn_anim_model( "player_rig" );
	ending_player_rig hide();
	ending_player_rig DontCastShadows();

	node = getent( "guard_assassinate", "script_noteworthy" ); 
	node anim_first_frame_solo( ending_player_rig, "rappel_kill" );
	
	
	player_rope = spawn_anim_model( "rope" );
	player_rope hide();
	
	rig_and_rope[ 0 ] = player_rig;
	rig_and_rope[ 1 ] = player_rope;
	
	ent anim_first_frame( rig_and_rope, "rappel_hookup" );
	
	wait( 0.5 );

	level.player_rig = player_rig;
	tag_origin = spawn_tag_origin();
	tag_origin linkto( player_rig, "tag_player", (0,0,0), (0,0,0) );
	
	shadow_model = spawn( "script_model", (0,0,0));
	shadow_model setmodel( level.price.model );
	shadow_model Attach( "head_hero_price_desert", "" );
	shadow_model linkto( tag_origin, "tag_origin", (-50,0,0), ( 0,0,0) ); // -50,0,0 -90,0,0 use these values if using the new shadow
	shadow_model.animname = "rappel_shadow";
	shadow_model SetAnimTree();
	
//remove these 2 lines if using new shadow stuff
	animation = shadow_model getAnim( "rappel_frame" );
	shadow_model SetAnim( animation, 1, 0, 0 ); // play the anim with no rate so its just first frame.
	
	shadow_model hide();

	time = 0.5;
	
	shadow_model delaycall( time, ::show );// remove this line if using the new shadow stuff
//	shadow_model delaythread( time, ::shadow_model_animate ); // add this line if using the new shadow stuff.

	tag_origin_start = spawn_tag_origin();
	tag_origin_start.angles = level.player getplayerangles();
	tag_origin_start.origin = level.player.origin;
	
	level.player PlayerLinkTo( tag_origin_start );
	wait( 0.05 );	
	level.player PlayerLinkToBlend( tag_origin, "tag_origin", time, 0.2, 0.2 );
	delayThread( time, ::player_gets_groundref_and_opens_fov, tag_origin );
	tag_origin_start delete();

	array_spawn_function_noteworthy( "rappel_guard_2", ::rappel_guard2_patrol );
	array_spawn_function_noteworthy( "rappel_guard_2", ::rappel_guard2_kill_player );
	array_spawn_function_noteworthy( "rappel_guard_2", ::rappel_guard2_death );
	array_spawn_function_noteworthy( "rappel_guard_1", ::rappel_guard1_kill_player );
	array_spawn_function_noteworthy( "rappel_guard_2", ::rappel_guards_think);
	array_spawn_function_noteworthy( "rappel_guard_1", ::rappel_guards_think );

	rappel_baddie_spawners = getentarray( "rappel_baddie_spawner", "targetname" );
	array_spawn( rappel_baddie_spawners );

	delaythread( 6, ::display_hint, "begin_descent" );// 8
	
	player_rig delaycall( 0.6, ::show );
	player_rope delaycall( 0.6, ::show );
	player_rig DontCastShadows();

	flag_set( "player_hooking_up" );
	ent anim_single( rig_and_rope, "rappel_hookup" );
	tag_origin notify( "open_fov" );

	flag_set( "player_hooked_up" );
	
	player_rig hide();

	// do some anim of starting carabiner here
	
	flag_set( "descending" );

	root_anim = player_rig getanim( "rappel_root" );
	
	player_rig SetAnim( root_anim, 0, 0, 1 );

	far_anim = player_rig getAnim( "rappel_far" );
	far_anim_node = player_rig getAnim( "rappel_far_node" );

	close_anim = player_rig getAnim( "rappel_close" );
	close_anim_node = player_rig getAnim( "rappel_close_node" );
	
	start_org = GetStartOrigin( ent.origin, ent.angles, far_anim );
	start_ang = GetStartAngles( ent.origin, ent.angles, far_anim );
		
	player_rig SetAnimLimited( close_anim, 1, 0, 1 );
	player_rig SetAnimLimited( close_anim_node, 1, 0, 1 );
	player_rig SetAnimLimited( far_anim, 0.01, 0, 1 );
	player_rig SetAnimLimited( far_anim_node, 0.01, 0, 1 );
	
	player_rig SetAnimKnob( root_anim, 1, 1, 1 );
	rappel_hookup = player_rig getanim( "rappel_hookup" );
	wait( 0.05 );
	player_rig ClearAnim( rappel_hookup, 0.2 );
	level.player_rig = player_rig;
	
	min_speed = 0.30; // the slowest speed we can rappel
	max_speed = 4; // the fastest rappelling speed
	speed = 1; // ignore this, internal variable
	
	//ending_min_speed = 2; // Min speed during the ending moment
	//ending_max_speed = 2; // max speed during ending moment
	ending_speed = 0.13;
	
	break_speed = 0.375; // how fast the brakes work, the higher the number the more brakes

	nobreak_rate = 0.006; // the speed that we accumulate accelleration while not braking
	nobreak_maxspeed = 0.16;	// the maximum accelleration while not braking
	nobreak_minspeed = 0.08;	// our accelleration the moment we stop braking
	nobreak_speed = nobreak_minspeed; // internal variable
		
	
	// effects the way the player pops off the cliff while rappelling
	close_anim_dest = 100; 
	far_anim_dest = 0.1;
	far_anim_min = 0.1;
	far_anim_max = 50;
	far_anim_rate = 1;
	old_org = level.player.origin;
	
	// the amount of time you have to be moving at max speed to DIE if you dont brake.
	death_buffer = 1500;
	if ( level.gameskill >= 2 )
		death_buffer = 150;
	
		
	//tag_origin thread liner();
	was_breaking = false;
	sin_index_old = 0;
	sin_index = 0;
	sin_index_max = 0;
	
	player_fell = false;
	last_time_braked = 0;
	speaker = spawn( "script_origin", (0,0,0) );
	speaker.origin = level.player.origin;
	speaker linkto( level.player );
	death_fall_timer = undefined;
	speaker playsound( "scn_afcaves_rappel_start_plr" );
	
	able_to_break_time = gettime() + 1500;

	shadow_model notify( "start_jump" );
	
	for ( ;; )
	{
		// at % through the anim, go into ending mode with the knife
		if ( player_rig getanimtime( far_anim ) >= 0.90 )//.94
			flag_set( "rappel_end" );

		breaking = level.player adsbuttonpressed() || level.player attackbuttonpressed() && !flag( "rappel_end" );
	
		if ( breaking )
			flag_set( "player_braked" );

		if ( flag( "rappel_end" ) )
		{
			if ( level.player MeleeButtonPressed() )
				break;
		}
		
		// last_time_braked + the amount of time you have to fall before you can brake
		if ( breaking && gettime() > last_time_braked + 5 && gettime() > able_to_break_time )
		{
			flag_set( "shadow_breaking" );
			nobreak_speed = nobreak_minspeed;
			speed -= break_speed;
			if ( speed < min_speed )
				speed = min_speed;
		
			player_rig SetAnimLimited( close_anim, 1, 0, speed );
			player_rig SetAnimLimited( far_anim, 1, 0, speed );

			far_anim_dest -= far_anim_rate * 3;
			if ( far_anim_dest <= far_anim_min )
				far_anim_dest = far_anim_min;
			
			if ( !was_breaking )
			{
				was_breaking = true;
				death_fall_timer = undefined;
				sin_index = 90;
				sin_index_max = 180;
				sin_index_old = sin_index;
				speaker StopSounds();
				if ( !flag( "rappel_end" ) )
					speaker playsound( "scn_afcaves_rappel_stop_plr" );
			}

		}
		else
		{
			flag_clear( "shadow_breaking" );

			nobreak_speed += nobreak_rate;
			if ( nobreak_speed > nobreak_maxspeed )
				nobreak_speed = nobreak_maxspeed;
			
			speed += nobreak_speed;
			if ( speed > max_speed )
			{
				if ( !isdefined( death_fall_timer ) )
				{
					death_fall_timer = gettime();
				}
				
				speed = max_speed;
				
				if ( gettime() > death_fall_timer + death_buffer )
				{
					if ( !flag( "rappel_end" ) )
					{
						//level.player unlink();
						if ( player_rig getanimtime( far_anim ) >= 0.65 )
						{
							player_fell = true;
							break;
						}
					}
				}
			}

			if ( flag( "rappel_end" ) )
			{
				// blend the current speed with the desired ending_speed
				dif = 0.15;
				speed = ending_speed * dif + speed * ( 1 - dif );
			}

			player_rig SetAnimLimited( close_anim, 1, 0, speed );
			player_rig SetAnimLimited( far_anim, 1, 0, speed );

			if ( was_breaking )
			{
				speaker StopSounds();
				if ( !flag( "rappel_end" ) )
					speaker playsound( "scn_afcaves_rappel_start_plr" );
					
				last_time_braked = gettime();
				was_breaking = false;
				sin_index = 0;
				sin_index_max = 90;
				sin_index_old = sin_index;
			}
			
			

			if ( !flag( "rappel_end" ) )
			{
				far_anim_dest += far_anim_rate;
				if ( far_anim_dest >= far_anim_max )
					far_anim_dest = far_anim_max;
			}
			else
			{
				// use the
				far_anim_dest -= far_anim_rate * 3;
				if ( far_anim_dest <= far_anim_min )
					far_anim_dest = far_anim_min;
			}
		}
		
		player_rig SetAnimLimited( close_anim_node, close_anim_dest, 0, speed );
		player_rig SetAnimLimited( far_anim_node, far_anim_dest, 0, speed );
		old_org = level.player.origin;
		
		wait( 0.05 );
		if ( player_rig getanimtime( far_anim ) >= 0.98 )
		{
			break;
		}
	}
	
	shadow_model delete();
	speaker delete();
	percentage = player_rig getanimtime( far_anim );

	if ( player_fell )
	{
	
		for ( ;; )
		{
			far_anim_dest += far_anim_rate;
			close_anim_dest -= far_anim_rate;
			speed += nobreak_speed;
				
			player_rig SetAnimLimited( close_anim_node, close_anim_dest, 0, speed );
			player_rig SetAnimLimited( far_anim_node, far_anim_dest, 0, speed );
			
			if ( player_rig getanimtime( far_anim ) >= 0.78 )
				break;
	
			wait( 0.05 );
		}
		
		//println( "break!" );
		//angles = ( -15, -100, 0 );
		angles = tag_origin.angles;
		angles = ( 0, angles[1], 0 );
		forward = anglestoforward( angles );
		up = anglestoup( angles );
		velocity = forward * 750;
	//	velocity = up * 500;
		tag_origin unlink();
		tag_origin MoveSlide( ( 0, 0, 0 ), 32, velocity );
		tag_origin delaythread( 0.75, ::hurt_player_on_bounce );
		
		thread player_decent_death();
		
		wait( 3.5 );
		
		level.player kill();
	}
	else
	{

		for ( ;; )
		{	
			if ( !isalive( level.player ) )
				break;
				
			if ( level.player MeleeButtonPressed() )
				break;
			wait( 0.05 );
		}
		
		//level.player unlink();
		// since I removed it at the begining no point in reseting it here.
		// level.player PlayerSetGroundReferenceEnt( undefined );
		// level.player enableweapons();
		if ( flag( "player_failed_rappel" ) )
			return;

		wait( 0.1 );

		flag_set( "player_killing_guard" );
		
		if ( !isalive( level.player ) )
			return;
		level.player endon( "death" );

		knife = spawn( "script_model", (0,0,0) );
		knife setmodel( "weapon_parabolic_knife" );
		knife hide();
		knife DontCastShadows();
		knife linkto( ending_player_rig, "tag_weapon_left", (0,0,0), (0,0,0) );
		
//		ending_player_rig delaycall( 0.6, ::Show );
//		knife delaycall( 0.6, ::show );
	
		thread hint_fade();
		
		node = getent( "guard_assassinate", "script_noteworthy" ); 
		assert( isdefined( node ) );

		guard_1 = get_living_ai_array( "rappel_guard_1", "script_noteworthy");
		assert( isalive( guard_1[ 0 ] ) );
		enemy = guard_1[ 0 ];
		enemy.animname = "guard_1";
		
		guys = [];
		guys[ 0 ] = player_rig;
		guys[ 1 ] = enemy;
				
		
		enemy.a.nodeath = true;
//		node.origin += (0,0,8);
		level.player unlink();
		ending_player_rig relink_player_for_knife_kill( percentage );
		ending_player_rig show();
		knife show();

		node.guard = enemy;
		//enemy delaythread( 1.5, ::clear_nodeath_and_kill );
		enemy gun_Remove();
		
		thread lerp_savedDvar( "sm_sunSampleSizeNear", .0156, .5 );
		node anim_single_solo( ending_player_rig, "rappel_kill" );
	
		thread lerp_savedDvar( "sm_sunSampleSizeNear", .25, 2 );
		
		flag_clear( "descending" );	
		ending_player_rig waittillmatch( "single anim", "end" );
		
		//Print3d( player_rig.origin, ".", (1,0,0), 1, 1, 1000 );
		ending_player_rig MoveTo( ending_player_rig.origin + ( 0,0,12 ), 0.4, .2, .2);
		
		level.player SwitchToWeapon ( old_weapon ); 
		knife hide(); // why not delete()?

		level.player PlayerSetGroundReferenceEnt( undefined );
		wait( 0.4 );

		level.player unlink();
		ending_player_rig delete();
		player_rig delete();
		
		flag_set( "end_of_rappel_scene" );
	}
}

shadow_model_animate()
{
	self endon( "death" );

	self show();

	jump_anim = self getAnim( "shadow_jump" );
	stop_anim = self getAnim( "shadow_stop" );
//	jump_anim = self getAnim( "rappel_frame" );
//	stop_anim = self getAnim( "rappel_frame" );

	self SetAnimRestart( jump_anim, 1, 0, 0 );
	self SetAnim( stop_anim, 0, 0, 0 );
	self waittill( "start_jump2" );

	while( true )
	{
		self SetAnimrestart( jump_anim, 1, .25, .5 );
		self SetAnim( stop_anim, 0, .25, .5 );
		flag_wait( "shadow_breaking" );
		self SetAnim( jump_anim, 0, .5, .5 );
		self SetAnimrestart( stop_anim, 1, .5, .5 );
		flag_waitopen( "shadow_breaking" );
	}
}

player_decent_death()
{
	level.player waittill( "death" );
	
	level notify( "new_quote_string" );
	setdvar( "ui_deadquote", &"AF_CAVES_FELL_TO_DEATH" );
}

relink_player_for_knife_kill( percentage )
{
	waittillframeend;

	if ( percentage < 0.94 )
		time = 0.8;	
	else if ( percentage < 0.96 )
		time = 0.6;	
	else
		time = 0.4;	
	
//	time = 0.8;//0.4 // 0.866 sec is the length of the melee anim for the rappel_knife weapon
	level.player PlayerLinkToBlend( self, "tag_player", time, time * 0.5, time * 0.5 );// 0.5
	wait( time );
	
	level.player takeweapon( "rappel_knife" );
}

hurt_player_on_bounce()
{
	if ( !isalive( level.player ) )
		return;
		
	level.player endon( "death" );
	org = self.origin;
	old_vel = 0;
	maxhealth = level.player.maxhealth;
	for ( ;; )
	{
		vec = self.origin - org;
		vel = length( vec );
		if ( vel < old_vel - 10 )
		{
			randomvec = randomvector( 1000 );
			level.player DoDamage( maxhealth * 0.35, randomvec );
			level.player kill();
		}
		//println(  vel );
		
		if ( vel > old_vel )
			old_vel = vel;
		org = self.origin;
		wait( 0.05 );
	}
}

liner()
{
	for ( ;; )
	{
		Line( self.origin, level.player.origin );
		Print3d( self.origin, "x" );
		wait( 0.05 );
	}
}

//	****** Explosion Earthquake, barrels go boom, rocks fall around you****** //

setup_barrel_earthquake()
{
	array_thread( getentarray( "explodable_barrel", "targetname" ), ::barrel_earthquake_notify );

	level thread explosion_earthquake();
}

barrel_earthquake_notify()
{
	self waittill( "exploding" );
	level notify( "explosion_earthquake", self.origin );
	
	flag_set( "price_unstable_comment" );

	start = self.origin + (0,0,96);
	end = self.origin + (0,0,1024);
	ceiling = PhysicsTrace( start, end );
	if ( ceiling != end )
	{
		current_fx = getfx( "hallway_collapsing_big" );
		PlayFX( current_fx, ceiling );
	}
}

explosion_earthquake()
{
	fx = [];
	fx[0] = "ceiling_rock_break";
	fx[1] = "ceiling_rock_break";
	fx[2] = "ceiling_rock_break";
	fx[3] = "ceiling_rock_break";
	fx[4] = "ceiling_rock_break";
	fx[5] = "hallway_collapsing_big";
	fx[6] = "hallway_collapsing_big";
	fx[7] = "hallway_collapsing_big";
	fx[8] = "hallway_collapsing_huge";
	fx[9] = "hallway_collapsing_huge";

	fx_angles = [];
	fx_angles[0] = ( 90, 154, 11 );
	fx_angles[1] = ( 90, 154, 11 );
	fx_angles[2] = ( 90, 154, 11 );
	fx_angles[3] = ( 90, 154, 11 );
	fx_angles[4] = ( 90, 154, 11 );
	fx_angles[5] = ( 0,0,0 );
	fx_angles[6] = ( 0,0,0 );
	fx_angles[7] = ( 0,0,0 );
	fx_angles[8] = ( 0,0,0 );
	fx_angles[9] = ( 0,0,0 );

	while( true )
	{
		level waittill( "explosion_earthquake", exploding_ent_origin );

		max_intensity = fx.size-1;
		max_dist = 1500;

		dist = distance( level.player.origin, exploding_ent_origin );
		intensity = ( max_dist - dist ) / max_dist;

		if ( intensity < 0 )
			intensity = 0.01;
		intensity = int( ceil( max_intensity * intensity ) );
	
		duration = intensity / 2.5;

		Earthquake( .25, duration, level.player.origin, 1024 );

		for ( i=0; i <= intensity; i++ )
		{
			direction = flat_angle( level.player.angles ) + ( 0, randomint(80) - 40, 0);

			forward = anglestoforward( direction );
			start = level.player.origin + forward * 256 + ( 0, 0, 72 );
			end = start + ( 0,0,1024 );
	
			ceiling = PhysicsTrace( start, end );
			if ( ceiling == end )
				continue;

			fx_index = intensity-i;
			forward = anglestoforward( fx_angles[ fx_index ] );
			up = anglestoup( fx_angles[ fx_index ] );
			current_fx = getfx( fx[ fx_index ] );
			PlayFX( current_fx, ceiling, forward, up );

			wait randomfloat( .5 );
		}
	}
}

price_unstable_comment()
{
	self endon( "death" );
	level endon( "ustable_comment" );
	level endon( "player_crossed_bridge" );
	level endon( "location_change_control_room" );
	level endon( "steamroom_halfway_point" );
	
	flag_wait( "price_unstable_comment" );
	
	wait 3;
	//Price: "Bloody hell this place is unstable!"
	radio_dialogue( "pri_unstable" );

	wait( randomintrange( 3, 7 ) );
	//Price: "Soap, pick your shots carefully - we don't want this cave to come down on us!"
	radio_dialogue( "pri_pickcarefully" );
	
	level notify( "ustable_comment" );	
}

dog_think()
{
	self endon( "death" );
	
	flag_wait ( "price_orders_roadside_attack" );

	self.goalradius = 6800;
	self setgoalentity( level.player );
}

no_cqb()
{
	self endon( "death" );
	self.neverEnableCQB = true;
}

friendly_adjust_movement_speed()
{
	self notify( "stop_adjust_movement_speed" );
	self endon( "death" );
	self endon( "stop_adjust_movement_speed" );
	
	for(;;)
	{
		wait .15;
		
		while( friendly_should_speed_up() )
		{
//			iPrintLnBold( "friendlies speeding up" );
			self.moveplaybackrate = 2.5;
			wait 0.05;
		}
		
		self.moveplaybackrate = 1.0;
	}
}

friendly_should_speed_up()
{
	prof_begin( "friendly_movement_rate_math" );
	
	if ( distanceSquared( self.origin, self.goalpos ) <= level.goodFriendlyDistanceFromPlayerSquared )
	{
		prof_end( "friendly_movement_rate_math" );
		return false;
	}
	
	// check if AI is visible in player's FOV
	if ( within_fov( level.player.origin, level.player getPlayerAngles(), self.origin, level.cosine[ "70" ] ) )
	{
		prof_end( "friendly_movement_rate_math" );
		return false;
	}
	
	prof_end( "friendly_movement_rate_math" );
	
	return true;
}

//	****** Stealth settings ****** //
af_caves_intro_stealth_settings()
{
	// these values represent the BASE huristic for max visible distance base meaning 
	// when the character is completely still and not turning or moving
	// HIDDEN is self explanatory
	hidden = [];
	hidden[ "prone" ]		= 512;
	hidden[ "crouch" ]	 	= 6000;
	hidden[ "stand" ]	 	= 8000;

	// SPOTTED is when they are completely aware and go into NORMAL COD AI mode...however, the
	// distance they can see you is still limited by these numbers because of the assumption that
	// you're wearing a ghillie suit in woodsy areas
	spotted = [];
	spotted[ "prone" ]	 = 4000;
	spotted[ "crouch" ]	 = 8000;
	spotted[ "stand" ]	 = 9000;
	
	stealth_detect_ranges_set( hidden, spotted );
}

turn_off_stealth()// no more stealthy guys from here on.
{
	flag_wait( "grp3_lights_out" );
	
	disable_stealth_system();
	
	waittillframeend;	// wait for stealth system to finish setting ignoreme
	
	level.price cqb_walk( "on" );
	level.price.neverEnableCQB = undefined;
	
	wait 1;
	level.price set_ignoreall( false );
	level.price set_ignoreme( false );
	
	battlechatter_on( "allies" );
}

stealth_settings()
{
	stealth_set_default_stealth_function( "backdoor", ::stealth_caves );
	stealth_set_default_stealth_function( "road", ::stealth_road_patrol );
	
	array = [];
	array[ "player_dist" ]	 = 2000;
	array[ "detect_dist" ]	 = 400;
	stealth_corpse_ranges_custom( array );
}

stealth_caves()
{
	self stealth_plugin_basic();

	if ( isplayer( self ) )
		return;

	switch( self.team )
	{
		case "axis":
		case "team3":
			self stealth_plugin_threat();
			self stealth_enable_seek_player_on_spotted();
			self stealth_plugin_corpse();
			self stealth_plugin_event_all();
			break;

		case "allies":
			self stealth_plugin_smart_stance();
	}
}

stealth_road_patrol()
{
	self stealth_plugin_basic();
	
	if ( isplayer( self ) )
		return;
			
	switch( self.team )
	{
		case "axis":
		case "team3":
			
			self stealth_plugin_threat();
			self stealth_enable_seek_player_on_spotted();
			self stealth_plugin_corpse();
			self stealth_plugin_event_all();
			self thread monitor_stealth_kills();
			self thread monitor_someone_became_alert();
			self thread monitor_stealth_pain();
			break;		
	}
}

monitor_stealth_kills()
{
	self waittill( "death", killer );
	
	if ( !isdefined( killer ) )
		return;
		
	if ( isplayer( killer ) )
	{
		flag_set( "player_shot_someone" );
		return;
	}
}

monitor_stealth_pain()
{
	self waittill( "damage", damage, attacker );
	
	if ( !isdefined( attacker ) )
		return;
	
	if ( ( isplayer( attacker ) ) && ( isdefined( self.script_deathflag ) ) )
	{
		flag_set( "player_shot_someone" );
	}
}

monitor_someone_became_alert()
{
	self endon( "death" );
	
	self ent_flag_waitopen( "_stealth_normal" );
	
	self.ignoreme = false;
	
	if( flag( "someone_became_alert" ) )
		return;
	
	flag_set( "someone_became_alert" );
	thread monitor_waittill_stealth_normal();
	
	wait 1;//gives player a chance to kill the guy before warning dialog
	
	if( flag( "_stealth_spotted" ) )
		return;
}

monitor_waittill_stealth_normal()
{
	wait_till_every_thing_stealth_normal_for( 3 );
	
	flag_clear( "someone_became_alert" );
}


wait_till_every_thing_stealth_normal_for( time )
{
	while( 1 )
	{
		if( stealth_is_everything_normal() )
		{
			wait time;	
			if( stealth_is_everything_normal() )
				return;
		}
		wait 1;
	}
}

//	***** Swinging lamp in the control room *****	//
hunted_hanging_light()
{
	fx = getfx( "gulag_cafe_spotlight" );
	tag_origin = spawn_tag_origin();
	
	tag_origin LinkTo( self.lamp, "j_hanging_light_04", (0,0,-64), (0,0,0) );
	PlayFXOnTag( fx, tag_origin, "tag_origin" );
	
	flag_wait( "sheppard_southwest" );
	stopFXOnTag( fx, tag_origin, "tag_origin" );
}

swing_light_org_think()
{
	lamp = spawn_anim_model( "lamp" );
	lamp thread lamp_animates( self );
}

swing_light_org_off_think()
{
	lamp = spawn_anim_model( "lamp_off" );
	lamp thread lamp_animates( self );
}

lamp_animates( root )
{
	root.lamp = self;
	self.animname = "lamp"; // uses one set of anims
	self.origin = root.origin;
	self dontcastshadows();

	// cant blend to the same anim	
	odd = true;
	anims = [];
	anims[ 0 ] = self getanim( "swing" );
	anims[ 1 ] = self getanim( "swing_dup" );
	
	thread lamp_rotates_yaw();
	
	for ( ;; )
	{
		level waittill( "swing", mag );
		animation = anims[ odd ];
		off = !odd;
		self SetAnimRestart( animation, 1, 0.3, 1 );
		wait( 2.5 );
	}
}

lamp_rotates_yaw()
{
	ent = spawn_tag_origin();

	for ( ;; )
	{
		yaw = randomfloatrange( -30, 30 );
		ent addyaw( yaw );
		time = randomfloatrange( 0.5, 1.5 );
		self rotateto( ent.angles, time, time * 0.4, time * 0.4 );
		wait( time );
	}
}

//	*******  Utility stuff	****** //
delete_corpse_in_volume( volume )
{
	assert( isdefined( volume ) );
	if ( self istouching( volume ) )
		self delete();
}


clip_nosight_logic()
{
	self endon( "death" );

	flag_wait( self.script_flag );

	self thread clip_nosight_logic2();
	self setcandamage( true );

	self clip_nosight_wait();

	self delete();
}

clip_nosight_wait()
{
	if ( flag( "_stealth_spotted" ) )
		return;
	level endon( "_stealth_spotted" );

	self waittill( "damage" );
}

clip_nosight_logic2()
{
	self endon( "death" );

	flag_wait_either( "_stealth_spotted", "_stealth_found_corpse" );

	self delete();
}

half_particles_setup()
{
	flag_wait( "disable_half_buffer" );
	SetHalfResParticles( false );	
}	
		
lock_obj_location( objective_number )
{
	level endon( "unlock_obj" );
	while ( true )
	{
		objective_position( objective_number, self.origin + ( 0, 0, 48 ) );
		wait .5;
	}
}

attach_model_if_not_attached( model, tag )
{
	hasModel = false;
	
	attachedCount = self GetAttachSize();
	for( i = 0 ; i < attachedCount ; i++ )
	{
		if ( self getAttachModelName( i ) != model )
			continue;
		hasModel = true;
		break;
	}
	
	if ( !hasModel )
		self attach( model, tag );
}

play_sound_on_speaker( soundalias, interrupt )
{
	speaker_array = getentarray( "speaker", "targetname" );

	if ( isdefined( interrupt ) )
	{
		level notify( "speaker_interrupt" );

		for ( i = 0; i < speaker_array.size; i++ )
		{
			speaker_array[ i ] stopsounds();
		}
		wait .5;
	}
	else if ( flag( "speakers_active" ) )
		return;

	level endon( "speaker_interrupt" );
	flag_set( "speakers_active" );

	speaker_array = get_array_of_closest( level.player.origin, speaker_array, undefined, 2 );

	speaker_array[ 0 ] playsound( soundalias, "sounddone", true );
	speaker_array[ 1 ] playsound( soundalias );
	speaker_array[ 0 ] waittill( "sounddone" );

	flag_clear( "speakers_active" );
}

makesentient( team )
{
	self MakeEntitySentient( team );
	self waittill( "death" );

	if ( isdefined( self ) )
		self FreeEntitySentient();
}

enemy_starting_health()// there are some dudes I want to die easier.
{
	self.health = 100;
}

set_thread_bias_group( group )
{
	assert( isdefined( group ) );
	self setThreatbiasGroup( group );
}

// if any trigger is activated in a trigger array
waittill_trigger_array( triggers )
{
	for ( k = 1; k < triggers.size; k++ )
		triggers[ k ] endon( "trigger" );
	triggers[ 0 ] waittill( "trigger" );
}

hide_triggers( trigger_name )
{
	friendly_trigger = getentarray( trigger_name, "script_noteworthy" );
	foreach ( trigger in friendly_trigger )
	trigger trigger_off();
}

player_falling_kill_trigger()
{
	trigger_kill_player = getent( "player_falling_kill", "targetname" );
	
	trigger_kill_player waittill( "trigger" );
	if ( flag( "descending" ) )
		return;
	
	blackout = create_client_overlay( "black", 0, level.player );
	blackout FadeOverTime( 2 );
	blackout.alpha = 1;	
	
	level.player kill();
}

player_falling_removegun()
{
	trigger = getent( "player_falling_removegun", "targetname" );
	trigger waittill( "trigger" );
	
	level.player DisableWeapons();
}

end_of_level()
{
	wait .5;
	maps\_loadout::SavePlayerWeaponStatePersistent( "af_caves" );
	nextmission();
}