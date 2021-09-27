#include maps\_utility;
#include maps\_vehicle;
#include maps\_anim;
#include maps\_shg_common;
#include common_scripts\utility;


//---------------------------------------------------------
// Utility Section 
//---------------------------------------------------------

init_prague_code_level_flags()
{
	flag_init( "screen_fade_out_start" );
	flag_init( "screen_fade_out_end" );	
	flag_init( "screen_fade_in_start" );
	flag_init( "screen_fade_in_end" );		
	flag_init( "screen_fade_out_active" );
	flag_init( "screen_fade_in_active" );	
	
	flag_init( "play_left_hand_blood" );	
	flag_init( "play_right_hand_blood" );
	
	flag_init( "outof_range" );
	flag_init( "in_range" );
	
	flag_init( "FLAG_soap_blood_fx" );
	flag_init( "FLAG_soap_walk_blood_drip_elbow" );
	flag_init( "FLAG_soap_walk_blood_drip_hip" );
	flag_init( "FLAG_soap_walk_blood_smear" );
}

setup_hero_for_start( str_hero_name, str_start, func_init_hero )
{
	str_hero_name = tolower( str_hero_name );
	setup_hero( str_hero_name, func_init_hero );
	e_hero = get_hero_by_name( str_hero_name );
	
	if ( IsDefined( str_start ) )
	{		
		s_hero = getstruct( str_start + "_" + str_hero_name, "targetname" );
		
		AssertEx( IsDefined( s_hero ), "No struct for " + str_hero_name + " to start at in event " + str_start );
		
		e_hero ForceTeleport( s_hero.origin, s_hero.angles );
		e_hero SetGoalPos( s_hero.origin );
	}	
}

setup_hero( str_hero_name, func_init_hero )
{	
	e_hero = get_hero_by_name( str_hero_name );

	if ( !IsAlive( e_hero ) )
	{
		sp_hero = GetEnt( str_hero_name, "targetname" );
		e_hero = sp_hero spawn_ai( true );
		
		AssertEx( IsAlive( e_hero ), "Failed to spawn " + str_hero_name + "!" );
	
		e_hero.animname = str_hero_name;
		e_hero thread magic_bullet_shield( true );
	}
	
	if ( IsDefined( func_init_hero ) )
	{
		e_hero thread [[ func_init_hero ]]();
	}	
	
	e_hero set_hero_by_name( str_hero_name );
}

get_hero_by_name( str_hero_name )
{
	e_hero = undefined;
	
	switch ( str_hero_name )
	{
		case "price":
			e_hero = level.price;
			break;
			
		case "soap":
			e_hero = level.soap;
			break;
					
		default:
			AssertMsg( "hero function called with the invalid str_hero_name (" + str_hero_name + ").  Use 'price' or 'soap'" ); 
	}
	
	return e_hero;	
}

set_hero_by_name( str_hero_name )
{
	switch ( str_hero_name )
	{
		case "price":
			level.price = self;
			break;
			
		case "soap":
			level.soap = self;
			break;
			
		default:
			AssertMsg( "hero function called with the invalid str_hero_name (" + str_hero_name + ").  Use 'price' or 'soap'" ); 
	}
}

register_anim_node( targetname )
{
	if ( !IsDefined( level.anim_nodes ) )
	{
		level.anim_nodes = [];
	}
	
	node = getstruct( targetname, "targetname" );
	
	AssertEx( IsDefined( node ), "Can't register anim node.  Node does not exist." );
	
	level.anim_nodes[ targetname ] = node;
}

get_new_anim_node( targetname )
{
	if ( IsDefined( level.anim_nodes[ targetname ] ) )
	{
		node = SpawnStruct();
		node.origin = level.anim_nodes[ targetname ].origin;
		node.angles = level.anim_nodes[ targetname ].angles;
		return node;
	}
	else
	{
		AssertMsg( "Can't get new anim node.  Anim node not registered." );
	}
}

//---------------------------------------------------------
// Objectives
//---------------------------------------------------------

/*==============================================================
SELF: N/A
PURPOSE: Adds an objective
OPTIONAL ARG: [str_objective_text] the text to use for the objective, should be localized
OPTIONAL ARG: [is_new] if true, will increment the objective number and create a new objective.  Defaults to true.
OPTIONAL ARG: [is_current] if true, will mark this objective as the current one.  Defaults to true
OPTIONAL ARG: [v_position] the position of the objective
OPTIONAL ARG: [str_state] define the current state of the objective (empty, active, invisible, done, durrent, failed).  Defaults to active
RETURNS: the objective number
CREATOR: BJoyal (4/6/11)
===============================================================*/
prague_objective_add( str_objective_text, is_new, is_current, v_position, str_state )
{
	if( !IsDefined( str_state ) )
	{
		str_state = "active";
	}	
	
	if( !IsDefined( is_new ) || is_new )
	{
		level.objective_iterator++;
	}
	
	Objective_Add( level.objective_iterator, str_state, str_objective_text );
	
	if( IsDefined( v_position ) )
	{
		Objective_Position( level.objective_iterator, v_position );
	}
	
	if( !IsDefined( is_current ) || is_current ) // default to current objective being true
	{
		objective_current( level.objective_iterator );
	}
	
	return level.objective_iterator;
}

/*==============================================================
SELF: N/A
PURPOSE: Adds an objective on an AI, giving him the 'Follow' marker
MANDATORY ARG: <e_ai> the actor to place the objective marker on
OPTIONAL ARG: [str_objective_text] the text to use for the objective, should be localized
OPTIONAL ARG: [is_new] if true, will increment the objective number and create a new objective.  Defaults to true.
OPTIONAL ARG: [is_current] if true, will mark this objective as the current one.  Defaults to true
OPTIONAL ARG: [str_state] define the current state of the objective (empty, active, invisible, done, durrent, failed).  Defaults to active
OPTIONAL ARG: [str_override] text to override "Follow" (i.e. "Support", "Defend", etc...), should be localized
RETURNS: the objective number
CREATOR: BJoyal (4/6/11)
===============================================================*/
prague_objective_add_on_ai( e_ai, str_objective_text, is_new, is_current, str_state, str_override )
{
	if( !IsDefined( e_ai ) )
	{
		AssertMsg( "prague_objective_add_on_ai called on undefined entity" );
	}
		
	prague_objective_add( str_objective_text, is_new, is_current, undefined, str_state );
	
	Objective_OnEntity( level.objective_iterator, e_ai, (0, 0, 70) );
	
	if ( IsDefined( str_override ) )
	{
		Objective_SetPointerTextOverride( level.objective_iterator, str_override );
	}
	
	return level.objective_iterator;
}

/*==============================================================
SELF: N/A
PURPOSE: Marks an objective as complete
OPTIONAL ARG: [n_objective_index] the objective to mark as complete.  Defaults to the most recently created objective
CREATOR: BJoyal (4/6/11)
===============================================================*/
prague_objective_complete( n_objective_index, should_delete )
{
	if( !IsDefined( n_objective_index ) )
	{
		n_objective_index = level.objective_iterator;
	}
	
	objective_complete( n_objective_index );
	
	if( IsDefined( should_delete ) && should_delete )
	{
		Objective_Delete( n_objective_index );
	}
}

// fake death
bloody_death( delay )
{
	self endon( "death" );

	if( !IsSentient( self ) || !IsAlive( self ) )
	{
		return;
	}

	if( IsDefined( self.bloody_death ) && self.bloody_death )
	{
		return;
	}

	self.bloody_death = true;

	if( IsDefined( delay ) )
	{
		wait( RandomFloat( delay ) );
	}

	tags = [];
	tags[0] = "j_hip_le";
	tags[1] = "j_hip_ri";
	tags[2] = "j_head";
	tags[3] = "j_spine4";
	tags[4] = "j_elbow_le";
	tags[5] = "j_elbow_ri";
	tags[6] = "j_clavicle_le";
	tags[7] = "j_clavicle_ri";

	for( i = 0; i < 3 + RandomInt( 5 ); i++ )
	{
		random = RandomIntRange( 0, tags.size );
		self thread bloody_death_fx( tags[random], undefined );
		wait( RandomFloat( 0.1 ) );
	}

	self DoDamage( self.health + 50, self.origin );
}

bloody_death_fx( tag, fxName )
{
	if( !IsDefined( fxName ) )
	{
		fxName = level._effect["flesh_hit"];
	}

	PlayFxOnTag( fxName, self, tag );
}

flashback_teleport( str_scene_end_flag, str_next_scene_start, end_visionset, flash_fade, post_flash_fade, snd_alias, fade_out_time )
{
	flag_set( str_scene_end_flag );
	
	set_screen_fade_shader( "white" );
	set_screen_fade_timer( flash_fade );
	
	level.player vision_set_fog_changes( "prague_escape_flashback", flash_fade );

	screen_fade_out();
		
	if(IsDefined( snd_alias ) )
	{
		wait(1); //Flash sound still playing...
		level.player play_sound_on_entity( snd_alias );
	}	
	
	flag_set( str_next_scene_start );
	
	if ( IsDefined( fade_out_time ) )
		wait fade_out_time;
	
	set_screen_fade_timer( 1 );
	wait( 1.5 );
	
	level.player vision_set_fog_changes( end_visionset, post_flash_fade );

	screen_fade_in();
}

do_player_anim( str_scene, additional_ents, b_ground_trace, b_lerp_time )
{
	if ( !IsDefined( b_lerp_time ) )
	{
		b_lerp_time = 0;
	}
		
	level.player _disableWeapon();
	level.player HideViewModel();
	
	if ( !IsDefined( level.player.m_player_rig ) )
	{
		level.player.m_player_rig = spawn_anim_model( "player_rig" );
		level.player.m_player_rig Hide();
	}
	
	anim_ents = [];
	
	if ( IsArray( additional_ents ) )
	{
		anim_ents = array_add( additional_ents, level.player.m_player_rig );
	}
	else
	{
		anim_ents = make_array( level.player.m_player_rig, additional_ents );
	}
	
	s_align = self;
	if ( s_align == level )
	{
		s_align = SpawnStruct();
		s_align.origin = level.player.origin;
		s_align.angles = level.player.angles;
	}
	
	s_align anim_first_frame_solo( level.player.m_player_rig, str_scene );
	
	if ( b_lerp_time > 0 )
	{
		level.player FreezeControls( true );
		level.player PlayerLinkToBlend( level.player.m_player_rig, "tag_player", b_lerp_time, b_lerp_time * 0.25, b_lerp_time * 0.25 );
		wait b_lerp_time;
	}
	else
	{
		level.player PlayerLinkToAbsolute( level.player.m_player_rig, "tag_player" );
	}
	
	waittillframeend;
	level.player notify( "player_anim_started" );
	
	level.player.m_player_rig Show();
	s_align anim_single( anim_ents, str_scene );
	
	level.player Unlink();
	level.player.m_player_rig Delete();
	
	level.player FreezeControls( false );
	
	level.player ShowViewModel();
	level.player _enableWeapon();
	
	if ( IsDefined( b_ground_trace ) && b_ground_trace )
	{
		// Make sure player in not in the ground
		a_trace = BulletTrace( level.player.origin + ( 0, 0, 40 ), level.player.origin + ( 0, 0, -100 ), false, undefined, true );
		level.player SetOrigin( a_trace["position"] );
	}
}

//---------------------------------------------------------
// Screen Fades
//---------------------------------------------------------

init_fade_settings()
{
	level.fade_screen = SpawnStruct();
	default_screen_fade_settings(); 
}

set_screen_fade_shader( shader, shader_width, shader_height )
{
	if ( IsDefined( shader_width ) )
	{
		level.fade_screen.shader_width = shader_width;
	}
	
	if ( IsDefined( shader_height ) )
	{
		level.fade_screen.shader_height = shader_height;
	}

	AssertEx( IsDefined( shader ), "You must specify a shader to change the fade screen's shader." );
	
	level.fade_screen.shader = shader;
}

set_screen_fade_timer( delay )
{
	AssertEx( IsDefined( delay ), "You must specify a delay to change the fade screen's fadeTimer." );
	
	level.fade_screen.fadeTimer = delay;
}

default_screen_fade_settings()
{	
	level.fade_screen.x = 0; 
	level.fade_screen.y = 0; 
	level.fade_screen.horzAlign = "fullscreen"; 
	level.fade_screen.vertAlign = "fullscreen"; 
	level.fade_screen.foreground = true;
	level.fade_screen.alpha = 0; 
	level.fade_screen.fadeTimer = 2;
	level.fade_screen.shader = "black";
	level.fade_screen.shader_width = 640;
	level.fade_screen.shader_height = 480;
}

screen_fade_out()
{
	//IPrintLn( "screen_fade_out started" );
	
	flag_set( "screen_fade_out_start" );
	flag_clear( "screen_fade_in_start" );
	flag_clear( "screen_fade_in_end" );
	flag_set( "screen_fade_out_active" );
			
	//creating hud element if there isn't one 
	if ( !IsDefined( level.fade_screen.hud ) )
	{
		level.fade_screen.hud = NewHudElem();
	}

	//setting HUD parameters
	level.fade_screen.hud.x 					= level.fade_screen.x; 
	level.fade_screen.hud.y 					= level.fade_screen.y; 
	level.fade_screen.hud.horzAlign 	= level.fade_screen.horzAlign; 
	level.fade_screen.hud.vertAlign 	= level.fade_screen.vertAlign; 
	level.fade_screen.hud.foreground 	= level.fade_screen.foreground;
	level.fade_screen.hud.alpha 			= level.fade_screen.alpha; 
	level.fade_screen.hud.fadeTimer 	= level.fade_screen.fadeTimer;
	level.fade_screen.hud SetShader( level.fade_screen.shader, level.fade_screen.shader_width, level.fade_screen.shader_height );
	level.fade_screen.hud FadeOverTime( level.fade_screen.hud.fadeTimer ); 
	
	//setting the HUD to opaque
	level.fade_screen.hud.alpha = 1; 
	
//	IPrintLn( "out: waiting" );
	wait( level.fade_screen.hud.fadeTimer );

//	IPrintLn( "screen_fade_out_end set" );
	flag_set( "screen_fade_out_end" );
	flag_clear( "screen_fade_out_active" );	
}

screen_fade_in()
{
//	IPrintLn( "screen_fade_in started" );
	
	flag_set( "screen_fade_in_start" );
	flag_clear( "screen_fade_out_start" );
	flag_clear( "screen_fade_out_end" );
	flag_set( "screen_fade_in_active" );
	
	//checking to see if fade screen HUD element exist
	if ( !IsDefined( level.fade_screen.hud ) )
	{
		AssertEx( IsDefined( level.fade_screen.hud ), "You must define level.fade_screen.hud before setting a fade in." );
		return;
	}
	
	level.fade_screen.hud.alpha = 1; 
	level.fade_screen.hud FadeOverTime( level.fade_screen.hud.fadeTimer ); 
	level.fade_screen.hud.alpha = 0; 
	
//	IPrintLn( "in: waiting" );
	wait( level.fade_screen.hud.fadeTimer );

	level.fade_screen.hud Destroy();

//	IPrintLn( "screen_fade_in_end set" );
	flag_set( "screen_fade_in_end" );
	flag_clear( "screen_fade_in_active" );
}

//---------------------------------------------------------
// Old Functions
//---------------------------------------------------------

set_player_location( targetname )
{
	struct = getstruct( targetname, "targetname" );
	origin = drop_to_ground( struct.origin, 32 );

	level.player SetOrigin( origin );
	level.player SetPlayerAngles( struct.angles );
}


set_flag_on_death( str_flag )
{
	self waittill( "death" );
	
	flag_set( str_flag );
}


molotov_goes_jeremy( org, impact_point, create_trail ) // fake grenades that are thrown without ai.
{
	grenade = MagicGrenade( "molotov", org.origin, impact_point.origin, 5 );
	
	if ( !isdefined( grenade ) )
		return;
	
	grenade waittill( "death" );

	// create runner	
	if ( isdefined( impact_point.script_exploder ) )
	{
		exploder( impact_point.script_exploder );
	}
	
	if ( isdefined( create_trail ) )
	{
		trail_angle = VectorToAngles( impact_point.origin - org.origin );
		
		orig = grenade.origin;
		ent = Spawn( "script_model", orig );
		ent setModel( "tag_origin" );
		ent.angles = (270, 180, 180);
		ent2 = Spawn( "script_model", orig );
		ent2 setModel( "tag_origin" );
		ent2.angles = (0, 0, 0);
		
		ent linkTo( ent2 );
		ent2.angles = (0,180,0) + trail_angle;
		
		PlayFxOnTag( getfx( "molotov_trail_F" ), ent, "tag_origin" );
		
		for( i=0; i<20; i++ )
		{
			vec = AnglesToForward( trail_angle );
			orig2 = orig + (vec * ( i * 10 )) + ( 0, 0, 4 );
			line( orig, orig2, (1,0,0) );
			RadiusDamage( orig2, 32, 100, 100 );
			wait( 0.05 );
		}
	}
}


killSpawner( num )
{
	thread maps\_spawner::kill_spawnerNum( num );
}

play_extreme_rumble( guy )
{
	level.player PlayRumbleOnEntity( "grenade_rumble" );
}

play_extreme_rumble_and_earthquake( guy )
{
	level.player PlayRumbleOnEntity( "grenade_rumble" );
	Earthquake( 1, 1, level.player.origin, 64 );
}

play_heavy_rumble( guy )
{
	level.player PlayRumbleOnEntity( "damage_heavy" );
}

play_heavy_rumble_and_earthquake( guy )
{
	level.player PlayRumbleOnEntity( "damage_heavy" );
	Earthquake( 1, 1, level.player.origin, 64 );

	setblur(4, .10);
	wait(.15);
	setblur(0, .10);	
}

play_light_rumble( guy )
{
	level.player PlayRumbleOnEntity( "damage_light" );
}

play_uaz_rumble( guy )
{
	level.player PlayRumbleOnEntity( "grenade_rumble" );	
	
//	level.player PlayRumbleLoopOnEntity( "tank_rumble" );
//	
//	flag_wait( "stop_uaz_rumble" );
//	
//	wait( 2 );
//	
//	level.player StopRumble( "tank_rumble" );		
}

stop_uaz_rumble( guy )
{
//	flag_wait( "start_nuke_transition" );	
//	IPrintLnBold( "uaz rumble stop" );	
//	level.player StopRumble( "tank_rumble" );	
}

elevator_rumble_blood( guy )
{
	level.player PlayRumbleOnEntity( "damage_light" );

	PlayFXOnTag( getfx( "blood_handprint" ), level.player_rig, "J_Wrist_RI" );
	PlayFXOnTag( getfx( "blood_handprint" ), level.player_rig, "J_Wrist_LE" );	
}

left_hand_blood_on_rig( guy )
{
	while ( flag( "play_left_hand_blood" ) )
	{
		PlayFXOnTag( getfx( "blood_handprint" ), level.player_rig, "J_Wrist_LE" );
		wait( 0.20 );
	}	
}

right_hand_blood_on_rig( guy )
{
	flag_set( "play_right_hand_blood" );

	while ( flag( "play_right_hand_blood" ) )
	{
		PlayFXOnTag( getfx( "blood_handprint" ), level.player_rig, "J_Wrist_RI" );
		wait( 0.20 );
	}
}

monitor_suv_damage()
{
	self endon( "death" );
	
	n_suv_damage = ( self.script_startinghealth * 0.5 );
	
	while( 1 )
	{
		self waittill( "damage", amount, attacker, direction, point, damage_type );
		
		if ( damage_type == "MOD_GRENADE" )
		{
			self DoDamage( n_suv_damage, attacker.origin );
		}
	}
}

hide_player_hud()
{
	SetSavedDvar( "ui_hidemap", 1 );
	SetSavedDvar( "hud_showStance", "0" );
	SetSavedDvar( "compass", "0" );
	SetDvar( "old_compass", "0" );
	SetSavedDvar( "ammoCounterHide", "1" );
	SetSavedDvar( "cg_drawCrosshair", 0 );
}

show_player_hud()
{
	SetSavedDvar( "ui_hidemap", 0 );
	SetSavedDvar( "hud_showStance", "1" );
	SetSavedDvar( "compass", "1" );
	SetDvar( "old_compass", "1" );
	SetSavedDvar( "ammoCounterHide", "0" );
	SetSavedDvar( "cg_drawCrosshair", 1 );
}

deathfunc_ragdoll()
{
	self StartRagDoll();
	wait( 0.05 );
}

intro_blur()
{
	blur = 3;
	blur_time = 1;
	recovery_time = 1.4;
	SetBlur( blur * 1.2, blur_time );
	wait blur_time;
	SetBlur( 0, recovery_time );	
}

monitor_player_distance( n_fail_dist )
{
	level endon( "end_fail_monitor" );
		
	while( 1 )
	{
		if ( Distance2D( level.player.origin, level.soap.origin ) > n_fail_dist )
		{
			if ( !flag( "outof_range" ) )
			{
				flag_set( "outof_range" );
				
				flag_clear( "in_range" );
				
				level.price thread nag_protect_soap();
			
				wait RandomIntRange( 4, 8 );
			
				level thread start_fail_timer();
			}
		}
		else
		{
			if ( flag( "outof_range" ) )
			{
				flag_set( "in_range" );
				
				flag_clear( "outof_range" );
			}
		}
		
		wait 0.1;
	}
}

do_nags_til_flag(flag_ender, alias0, alias1, alias2, alias3, alias4)
{
	level endon (flag_ender);
	
	lines = [];
	lines[0] = alias0;
	
	if(isdefined(alias1))
	{
		lines[1] = alias1;
	}
	
	if(isdefined(alias2))
	{
		lines[2] = alias2;
	}
	
	if(isdefined(alias3))
	{
		lines[3] = alias3;
	}
	
	if(isdefined(alias4))
	{
		lines[4] = alias4;
	}
	
	while(!flag(flag_ender))
	{
		foreach (radio_line in lines)
		{
			radio_dialogue(radio_line);		
			wait(randomintrange (13, 16) );
		}
	}
}

start_fail_timer()
{
	level endon( "in_range" );
	level endon( "end_fail_monitor" );
	
	wait 12;
	
	SetDvar( "ui_deadquote", &"PRAGUE_ESCAPE_PROTECT_FAIL" );
	
	level thread missionFailedWrapper();
}


nag_protect_soap()  //self = price
{
	level endon( "in_range" );
	level endon( "end_fail_monitor" );
	
	n_past = 3;
	
	while ( 1)
	{
		n_current = RandomInt( 3 );
		
		if ( n_current != n_past )
		{
			switch( n_current )
			{
				case 0:
					self dialogue_queue( "presc_pri_yurigetbackhere" );
					break;
			
				case 1:
					self dialogue_queue( "presc_pri_yurigetoverhere2" );
					break;
			
				case 2:
					self dialogue_queue( "presc_pri_whereareyougoing" );
					break;
			}
			
			n_past = n_current;
			
			wait RandomFloatRange( 4.0, 6.0 );
		}
		
		wait 0.1;
	}
}


waittill_enemy_count( n_count )
{
	while( 1 )
	{
		n_enemycount = GetAICount( "axis" );
		
		if ( n_enemycount < n_count + 1 )
		{
			break;
		}
		
		wait 0.05;
	}
}


price_soap_kill( n_dist )
{
	self endon( "stop_phantom_kills" );
	
	while( 1 )
	{
		a_ai_enemies = GetAIArray( "axis" );
		
		if ( a_ai_enemies.size )
		{
			foreach( ai_enemy in a_ai_enemies )
			{
				if ( isAlive( ai_enemy ) )
				{
					if ( Distance2D( ai_enemy.origin, self.origin ) < n_dist )
					{
						v_gun = self GetTagOrigin( "tag_flash" );
						v_enemy_head = ai_enemy GetTagOrigin( "J_Head" );
						MagicBullet( "p99", v_gun, v_enemy_head );	
					}
				}
			}
		}
		
		wait 0.1;
	}
}


get_enemy_tag()
{
	tags = [];
	tags[0] = "J_Shoulder_LE";
	tags[1] = "J_Knee_LE";
	tags[2] = "J_SpineLower";
	tags[3] = "J_SpineUpper";
	tags[4] = "J_Neck";
	tags[5] = "J_Elbow_LE";
	tags[6] = "J_Ankle_LE";
	
	n_index = RandomInt( 7 );
	
	return tags[ n_index ];
}


get_tag_origin()
{
	m_tag_origin = Spawn( "script_model", self.origin );
	m_tag_origin SetModel( "tag_origin" );
	m_tag_origin.angles = ( 0, 0, 0 );

	return m_tag_origin;	
}

chopper_fire_at_target( kill, target_ent )
{
	//self = chopper
	self endon ("death");
	self endon ("stop_attacking");
	burstsize = RandomIntRange( 15, 25 );
	fireTime = 0.1;
	
	if(!isdefined( self.target_offset ))
	{
		self.target_offset = randomintrange(200, 250);	
	}
	if( isdefined (kill) )
	{
		self.target_offset = 0;	
	}
				
	for ( i = 0; i < burstsize; i++ )
	{
		if(cointoss() )
		{
			self.target_offset = (self.target_offset *-1);	
		}	
		if(!isdefined( target_ent ) )
		{
			target = level.player.origin;
		}	
		else
		{
			target = target_ent.origin;
		}
				
		if( isdefined (kill) )
		{
			target = level.player geteye();
		}

		self setturrettargetvec( target +(self.target_offset, self.target_offset, 0) );	
		//self thread draw_line_for_time( self.origin, target +(offset, offset, 0), 1, 0, 0, 1 );	
		self FireWeapon();
		wait fireTime;
	}
}

chopper_loudspeaker()
{
	self endon("death");
	//self = ent to play 2 random lines from (chopper) 
	lines = [];
	//"I see the intruder! He's armed!"
	lines[0] = "presc_rcp_intruder";
	// "Drop your weapon! Drop it now!"
	lines[1] =  "presc_rcp_dropweapon"; 
	// "Get your hands up! Do it now!"
	lines[2] =  "presc_rcp_handsup";
	
	lines = array_randomize( lines );
	random_line = random( lines );	
	lines  = array_remove( lines, random_line );

	foreach(line in lines)
	{
		self play_sound_on_entity( line );
	}	
	
}	

notify_dof_change( actor )
{
	level notify("dof_change" );		
}

