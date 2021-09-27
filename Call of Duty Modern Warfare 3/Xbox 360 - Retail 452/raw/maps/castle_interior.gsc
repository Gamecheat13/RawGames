#include common_scripts\utility;
#include maps\_utility;
#include maps\_shg_common;
#include maps\castle_code;
#include maps\_anim;

// Start Functions	/////////////////////////////////////////////////////////////////////////////////////
start_interior()
{
	move_player_to_start( "start_interior" );
	setup_price_for_start( "start_interior" );
	maps\_utility::vision_set_fog_changes( "castle_interior", 0 );
}

// Main Functions	/////////////////////////////////////////////////////////////////////////////////////
interior_main()
{
	/#
	iprintln( "Castle Interior" );
	#/
		
	set_rain_level( 3 );
	
	battlechatter_on( "allies" );
	level.price set_ai_bcvoice( "taskforce" );
	level.price.baseaccuracy = 1;
	
	level thread generator_room();
	level thread flash_grenade_toss();
	level thread computer_room();
	level thread foyer_room();
	
	//wait until the player is approaching foyer before starting courtyard scripts
	flag_wait("start_foyer_entrance");
}

init_event_flags()
{
	flag_init( "player_at_stairs" );
	flag_init( "player_on_stairs" );
	flag_init( "cellar_sneak_broke" );
	flag_init( "flash_grenade_spawn" );
	flag_init( "approaching_computer_room" );
	flag_init( "approaching_foyer" );
	flag_init( "start_foyer_entrance" );
	flag_init( "foyer_retreat_dead" );
}

generator_room()
{
	//GetEnt( "generator_stumble", "script_noteworthy" ) add_spawn_function( ::generator_stumble );
	//GetEnt( "generator_warning", "script_noteworthy" ) add_spawn_function( ::generator_goal_delete );
		
	level.player thread generator_sneak_room();
	level.price thread generator_price();
	
//	level thread generator_rumble();
	
	//auto-save
	autosave_by_name( "generator_room" );  
}

generator_stumble()
{
	self endon( "death" );
	
	waitframe();
	
	self.allowdeath = true;
	self.goalradius = 4;
	
	s_anim_align = get_new_anim_node( "generator_room" );
	
	s_anim_align anim_generic_reach( self, "guard_stumble" );
	s_anim_align anim_generic_run( self, "guard_stumble" );
	
	self SetGoalNode( GetNode( "stumble_goal", "targetname" ) );
}

generator_rumble()
{
	while( true )
	{
		e_player = trigger_wait_targetname( "generator_rumble" );
		if ( IsPlayer( e_player ) )
		{
			e_player PlayRumbleOnEntity( "minigun_rumble" );
			wait 0.5;
		}
	}
}

//volume in the office room that allows the player to be hidden
generator_sneak_room()
{
	self thread generator_sneak_delete();
		
	t_room_volume = GetEnt( "cellar_sneak_room", "targetname");
	
	while( !flag( "cellar_sneak_broke" ) )
	{
		if( self IsTouching( t_room_volume ) )
		{
			self set_ignoreme( true );
		}
		else
		{
			self set_ignoreme( false );
		}
		
		wait 0.05;
	}
	
	t_room_volume Delete();
	self set_ignoreme( false );
}

//detects if the player has fired his weapon in the generator room
generator_sneak_delete()
{
	while ( !self IsFiring() && !self IsThrowingGrenade() )
	{
		wait 0.05;
	}
		
	flag_set( "cellar_sneak_broke" );
}

generator_goal_delete()
{
	self endon( "death" );
	
	self.goalradius = 4;
	
	nd_goal = GetNode( self.target, "targetname" );
	
	self SetGoalNode( nd_goal );
	
	self waittill( "goal" );
	
	self Delete();
}

generator_price_teleport( s_anim_align )
{
	level endon( "player_on_stairs" );
	
	nd_price_goal = GetNode( "after_kitchen_goal", "targetname" );
	
	self disable_ai_color();
	self.goalradius = 8;
	self SetGoalNode( nd_price_goal );
	self waittill( "goal" );	
	
	wait 0.5;
	
	s_anim_align thread anim_loop_solo( self, "stair_start" );
}

generator_price()
{
	s_anim_align = get_new_anim_node( "price_talk" );
	
	self generator_price_teleport( s_anim_align );
//	self thread generator_price_enrage();
		
	flag_wait( "player_at_stairs" );
	
	s_anim_align notify( "stop_loop" );
	s_anim_align anim_single_solo( self, "stair_move" );
	s_anim_align thread anim_loop_solo( self, "stair_wait" );
	
	flag_wait( "player_on_stairs" );
	
	s_anim_align notify( "stop_loop" );
	s_anim_align anim_single_solo_run( self, "stair_finish" );
	
	self enable_ai_color();

	//take off the silenced weapon
	//self place_weapon_on( "mp5", "right" );
	
	//aggressive behavior, move forward even with 1 AI alive
	waittill_aigroupcount( "interior_generator", 1 );
	
	//remove all untriggered color triggers in the area
	foreach( trigger in GetEntArray( "generator_color_trigger", "script_noteworthy" ) )
	{
		trigger Delete();
	}
	
	activate_trigger_with_targetname( "before_flash_grenade" );
}

generator_price_enrage()
{
	trigger_wait_targetname( "generator_enrage" );
	
	a_enemies = get_ai_group_ai( "interior_generator" );
		
	foreach( enemy in a_enemies )
	{
		enemy.health = 1;
	}
}

flash_grenade_toss()
{
	flag_wait( "flash_grenade_spawn" );
	
	level thread flash_grenade_lightning();

	s_grenade_start = getstruct( "flash_grenade_origin", "targetname" );
	s_grenade_end = getstruct( s_grenade_start.target, "targetname" );	

	e_grenade = MagicGrenade( "flash_grenade", s_grenade_start.origin, s_grenade_end.origin, 3.0 );

	//	FLASHBANG!	
	wait 1.25;
	level.price thread dialogue_queue( "castle_pri_flashbang" );
	
	level.price delayThread( 1.5, ::flash_grenade_price, e_grenade );

	//spawn the thrower of the grenade
	sp_enemy = GetEnt( "stair_enemy", "targetname" );
	ai_enemy = sp_enemy spawn_ai();
	ai_enemy disable_surprise();
//	ai_enemy setFlashbangImmunity( true );
	
	ai_enemy waittill_notify_or_timeout( "damage" , 3 );

	activate_trigger_with_targetname( "after_flash_grenade" );
	

	level.price thread dialogue_queue( "castle_pri_keepmoving2" );
		
	
	level thread flash_grenade_stairs_melee();

}







flash_grenade_price( e_grenade )
{
	//radius check
	if( Distance2D( e_grenade.origin, self.origin ) < 256 )
	{
		self anim_single_solo( self, "flash_react" );
	
		//	Left side! LEFT SIDE!
		level.price thread dialogue_queue( "castle_pri_leftside2" );
		
		self anim_single_solo( self, "flash_effect" );
	}	
}

flash_grenade_stairs_melee()
{
	flag_wait( "player_up_stairs" );
			
	//auto-save
	autosave_by_name( "flash_grenade_complete" ); 
	
	sp_runner = GetEnt( "computer_runner", "targetname" );
	runner = sp_runner spawn_ai();
	runner.allowdeath = true;
	runner enable_sprint();
	runner.ignoreall = true;

	flag_wait( "approaching_computer_room" );
	level.price thread dialogue_queue( "castle_pri_dontslowdown" );
	
	if( IsDefined( runner ) && IsAlive( runner ) )
	{
		runner disable_sprint();
		runner.ignoreall = false;
		runner.ignoreme = false;
	}

}

flash_grenade_lightning()
{
	a_bolt_origins = getstructarray( "flash_grenade_bolt", "targetname" );
	
	while( !flag( "approaching_computer_room" ) )
	{
		PlayFX( level._effect[ "lightning_bolt" ], a_bolt_origins[ RandomInt( a_bolt_origins.size) ].origin );
	
		wait RandomFloatRange( 10.0, 15.0 );
	}
}



computer_room()
{
	flag_wait( "approaching_computer_room" );
	
	sp_door_guard = GetEnt( "computer_door_guard", "targetname" );
	ai_door_guard = sp_door_guard spawn_ai();
	ai_door_guard.allowdeath = true;
		
	sp_far_guard = GetEnt( "computer_far_guard", "targetname" );
	ai_far_guard = sp_far_guard spawn_ai();
	ai_far_guard.allowdeath = true;
		
	level.price thread computer_room_price( ai_door_guard );
	
	ai_far_guard anim_generic_first_frame( ai_far_guard, "guard_double_take" );
		
	e_doorway = GetEnt( "computer_doorway", "targetname" );
		
	ai_door_guard cqb_aim( e_doorway );
	
	trigger_wait_targetname( "computer_room_visible" );
	
	
	level.price thread dialogue_queue( "castle_pri_sortemout" );
	

	
	if( IsAlive( ai_door_guard ) )
	{
		ai_door_guard cqb_aim();
		ai_door_guard SetEntityTarget( e_doorway );
	}
	
	wait 0.5;
	
	if( IsAlive( ai_door_guard ) )
	{
		ai_door_guard ClearEntityTarget();
	}
	
	if( IsAlive( ai_far_guard ) )
	{
		ai_far_guard anim_generic( ai_far_guard, "guard_double_take" );
	}
		
	waittill_aigroupcleared( "interior_computer" );
	
	e_doorway Delete();
}

computer_room_price( door_guard )
{
	//door_guard waittill( "death" );s
	trigger_wait_targetname( "computer_room_visible" );
	
//	activate_trigger_with_targetname( "computer_room_price" );
	
	//aggressive behavior, move forward even with 1 AI alive
	waittill_aigroupcount( "interior_computer", 1 );
	
	//remove all untriggered color triggers in the area
	foreach( trigger in GetEntArray( "computer_color_trigger", "script_noteworthy" ) )
	{
		trigger Delete();
	}
	
	if( flag( "price_can_do_table_jump" ) )
	{
		s_anim_align = getstruct( "price_dukes", "targetname" );
	
		s_anim_align anim_reach_solo( self, "table_slide" );
		self thread computer_room_price_physics();
		s_anim_align anim_single_solo( self, "table_slide" );
	}
	/*
	self.goalradius = 512;
	self.grenadeammo = 0;
	self.baseaccuracy = 1000;
	self.aggressivemode = true;
	self.badplaceawareness = 0;
	self.dontavoidplayer = true;
	self disable_cqbwalk();
	self disable_danger_react();
	self disable_pain();
	self disable_surprise();
	self disable_bulletwhizbyreaction();
	self set_ignoreSuppression( true );
	
	*/	
	//Progression fix: If the player runs ahead into the courtyard, this would enable colors which would mean he would be locked in the foyer area.
	if( !flag( "inner_courtyard_door_kick" ) )
		self enable_ai_color();
	
	activate_trigger_with_targetname( "after_computer_room" );
}

computer_room_price_physics()
{
	for( i = 0; i < 10; i++ )
	{
		PhysicsExplosionSphere( self.origin, 20, 1, 0.5 );
		wait 0.1;
	}
}

foyer_room()
{
//	array_spawn_function_noteworthy( "foyer", ::foyer_shield );
	array_spawn_function_targetname( "foyer_retreat", ::foyer_retreat );
	array_spawn_function_targetname( "foyer_outer_retreaters", ::foyer_retreat_outdoors );
	
	level thread foyer_warning();
	level thread foyer_doors();
//	level thread foyer_window();
	level thread foyer_price();
}

foyer_retreat()
{
	self endon( "death" );
	self thread flag_on_death( "foyer_retreat_dead" );
	
	self.goalradius = 64;
	self.forcegoal = 1;
	self set_ignoreall( true );
	self enable_sprint();
	
	self SetGoalNode( GetNode( "foyer_retreat_goal", "targetname" ) );
	
	self waittill( "goal" );
	
	self set_ignoreall( false );
	self disable_sprint();	
	self Delete();
	
}

foyer_retreat_outdoors()
{
	self endon( "death" );
	
	self.goalradius = 64;
	self.forcegoal = 1;
	self.ignoreall = true;
	self enable_sprint();
	
	//self SetGoalNode( GetNode( "foyer_outer_retreat", "targetname" ) );
	
	self waittill( "goal" );
	self Delete();
}

foyer_shield()
{
	self magic_bullet_shield();
	
	flag_wait( "start_foyer_entrance" );
	
	self stop_magic_bullet_shield();
}

foyer_warning()
{
	trigger_wait_targetname( "foyer_warning" );
	
	level.price thread dialogue_queue( "castle_pri_throughhere" );
	
	//auto-save
	autosave_or_timeout( "computer_room_complete", 10 );
	
	if( !flag( "approaching_foyer" ) )
	{
		//let Price make it across the entrance
		wait 1.5;
		
		s_start = getstruct( "foyer_warning_bullet", "targetname" );
		s_end = getstruct( s_start.target, "targetname" );
		
		for( i = 0; i < 10; i++ )
		{
			v_end = s_end.origin + ( RandomIntRange( -32, 32 ), RandomIntRange( -32, 32 ), 0 );
			MagicBullet( "mp5", s_start.origin, v_end );
			wait 0.1;
		}
	}
}

foyer_doors()
{
	flag_wait( "foyer_doors_open" );
	foyer_door_left();
	foyer_door_right();
	/*
	sp_kicker = GetEnt( "foyer_door_kicker", "targetname" );
	
	ai_kicker_a = sp_kicker spawn_ai( true );
	ai_kicker_a.allowdeath = true;
	ai_kicker_a.animname = "guarda";
	ai_kicker_a thread magic_bullet_shield();
	ai_kicker_a thread foyer_kicker_think( "door_kick_1" );
	
	wait( 0.1 );
	
	ai_kicker_b = sp_kicker spawn_ai( true );
	ai_kicker_b.allowdeath = true;
	ai_kicker_b.animname = "guardb";
	ai_kicker_b thread magic_bullet_shield();
	ai_kicker_b thread foyer_kicker_think( "door_kick_2" );
	
	wait 3;
	*/
//	sp_reinforce = GetEnt( "foyer_reinforce", "targetname" );
//	sp_reinforce spawn_ai();
	
//	wait 1;
	
//	sp_reinforce spawn_ai();
}

foyer_kicker_think( goal_name )
{
	s_align = get_new_anim_node( "foyer" );
	s_align anim_single_solo( self, "foyer_door_kick" );
	nd_goal = GetNode( goal_name, "targetname" );
	self set_forcegoal();
	self SetGoalNode( nd_goal );
}

foyer_door_left( kicker )
{
//	kicker stop_magic_bullet_shield();
	
	m_l_door = GetEnt( "foyer_left_door", "targetname" );
	bm_l_door_clip = GetEnt( "foyer_left_door_clip", "targetname" );
	m_l_door LinkTo( bm_l_door_clip );
	bm_l_door_clip RotateYaw( -90, 0.5, 0.0, 0.3 );
	bm_l_door_clip waittill( "rotatedone" );
	bm_l_door_clip ConnectPaths();
	bm_l_door_clip RotateYaw(5, 0.5, 0.0, 0.2);
}

foyer_door_right( kicker )
{
	//kicker stop_magic_bullet_shield();
	
	m_r_door = GetEnt( "foyer_right_door", "targetname" );
	bm_r_door_clip = GetEnt( "foyer_right_door_clip", "targetname" );
	m_r_door LinkTo( bm_r_door_clip );
	bm_r_door_clip RotateYaw( 90, 0.7, 0.0, 0.5 );
	bm_r_door_clip waittill( "rotatedone" );
	bm_r_door_clip ConnectPaths();
	bm_r_door_clip RotateYaw(-3, 0.5, 0.0, 0.2);
}

foyer_window()
{
	t_window = GetEnt( "trigger_foyer_window", "targetname" );
	t_window waittill("trigger");
	
	sp_shooter = GetEnt( "foyer_window_shooter", "targetname" );
	ai_shooter = sp_shooter spawn_ai();
	
	flag_wait("start_foyer_entrance");
		
	e_target = GetEnt( "foyer_window_target", "targetname" );
	
	if( IsAlive( ai_shooter ) )
	{
		ai_shooter SetEntityTarget( e_target );
	}
	
	wait 3;
	
	if( IsAlive( ai_shooter ) )
	{	
		ai_shooter ClearEntityTarget();
	}
	
	e_target Delete();
}

//used to advance Price into the foyer based on how many AI are alive
foyer_price()
{
	flag_wait( "approaching_foyer" );
	
	n_aigroup_size = get_ai_group_count( "interior_foyer" );
	n_move = n_aigroup_size - 3;
		/*
	if( flag( "foyer_retreat_dead" ) )
	{
		wait 4;
	}
	else
	{
		flag_wait( "foyer_retreat_dead" );
	}
	*/
	/*
	wait 4;
	t_color = GetEnt( "move_price_foyer", "targetname" );
	if( IsDefined( t_color ) )
	{
		t_color UseBy( level.player );
	}
	//waittill_aigroupcount( "interior_foyer", n_move );
	t_color = GetEnt( "move_price_foyer_2", "targetname" );
	if( IsDefined( t_color ) )
	{
		t_color UseBy( level.player );
	}
	*/
	
	waittill_aigroupcount( "interior_foyer", 1 );
	//remove all untriggered color triggers in the area
	foreach( trigger in GetEntArray( "foyer_color_trigger", "script_noteworthy" ) )
	{
		trigger Delete();
	}

	if( !flag( "inner_courtyard_door_kick" ) )
	{
		t_color = GetEnt( "exit_foyer", "targetname" );
		if( IsDefined( t_color ) )
		{
			t_color UseBy( level.player );
		}
	}
	autosave_or_timeout( "foyer", 5 );
}