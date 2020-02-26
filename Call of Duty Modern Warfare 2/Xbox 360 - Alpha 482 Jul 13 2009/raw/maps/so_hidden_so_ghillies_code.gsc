#include common_scripts\utility;
#include maps\_utility;
#include maps\_anim;
#include maps\_specialops;

// ---------------------------------------------------------------------------------

should_spawn()
{
	switch ( level.gameSkill )
	{
		case 0:
		case 1:	return !( self.spawnflags & 256 );
		case 2:	return !( self.spawnflags & 512 );
		case 3:	return !( self.spawnflags & 1024 );
	}
}

// ---------------------------------------------------------------------------------

create_ghillie_enemies( enemy_id, wait_id )
{
	ghillie_enemies_init();
	
	assertex( isdefined( enemy_id ), "create_ghillie_enemies() requires a valid enemy_id" );

	ghillie_spawners = getentarray ( enemy_id, "targetname" );
	assertex( ghillie_spawners.size > 0, "create_ghillie_enemies() could not find any spawners with id " + enemy_id );

	if ( isdefined( wait_id ) )
		level waittill( wait_id );

	thread stealth_disable();
	
	array_thread( ghillie_spawners, ::add_spawn_function, ::ghillie_enemy_init, enemy_id );
	foreach ( ghillie in ghillie_spawners )
	{
		if ( ghillie should_spawn() )
			ghillie spawn_ai( true );
	}
}

ghillie_enemies_init()
{
	if ( isdefined( level.ghillie_enemies_initialized ) && level.ghillie_enemies_initialized )
		return;

	level.ghillie_enemies_initialized = true;
	level.ghillies_unaware = [];
	level.ghillies_nofire = [];
	level.ghillies_active = [];
}

ghillie_enemy_init( enemy_id )
{
	level.ghillie_count++;
	
	ghillie_enemy_set_nofire();
	
//	self.sightlatency = 1000;
	self.baseaccuracy = 6;
	self.goalradius = 96;
	self.grenadeAmmo = 0;
	self.dontEverShoot = true;
	self.allowdeath = true;

	self.ghillie_is_prone = false;
	self.ghillie_is_frozen = false;

	ghillie_enemy_set_flub_time();

	anim.shootEnemyWrapper_func = animscripts\utility::ShootEnemyWrapper_shootNotify;

	thread ghillie_enemy_register_death();
	thread ghillie_enemy_behavior();
	maps\_stealth_utility::disable_stealth_for_ai();
}

ghillie_enemy_register_death()
{
	level endon( "so_hidden_complete" );
	self endon ("ghillie_silent_kill" );
	
	my_id = self.unique_id;
	
	self waittill( "death", attacker );

	level.ghillie_count--;
	
	if ( array_contains( level.ghillies_unaware, my_id )	)
		death_register_unaware( attacker, true );
	else
	if ( array_contains( level.ghillies_nofire, my_id ) )
		death_register_nofire( attacker, true );
	else
		death_register_basic( attacker, true );
}

// This can probably be revisited to be simpler.
ghillie_enemy_behavior()
{
	level endon( "so_hidden_complete" );
	self endon( "quit_ghillie_behavior" );
	self endon( "death" );
	self endon( "long_death" );

	self.combatmode = "no_cover";

	thread ghillie_enemy_quit_when_sidearm();
	
	ghillie_enemy_freeze_while_prone();
	ghillie_enemy_resume_moving( "crouch" );
	if ( !ghillie_enemy_can_be_seen( false, true ) )
		ghillie_enemy_crouch_and_fire();
	ghillie_enemy_go_prone();
	ghillie_enemy_freeze_while_prone();

	while( 1 )
	{
		if( ghillie_enemy_can_be_seen( false, true ) )
		{
			wait 0.5;
			continue;
		}

		move_time = ghillie_get_move_time();
		crouch = randomfloat( 1.0 ) < level.ghillie_crouch_chance;
		if ( crouch )
			thread ghillie_enemy_resume_moving( "crouch", move_time );
		else
			thread ghillie_enemy_resume_moving( "prone", move_time );
			
		time_moved = 0.0;
		while( time_moved < move_time )
		{
			wait 0.1;
			time_moved += 0.1;
			if ( ghillie_enemy_can_be_seen( false, false ) )
			{
				self notify( "stop_moving" );
				if ( crouch )
					ghillie_enemy_go_prone();
				ghillie_enemy_freeze_while_prone();
				while ( ghillie_enemy_can_be_seen( false, false ) )
					wait 0.1;
			}

			new_move_time = clamp( move_time - time_moved, 0, move_time );
			if ( new_move_time > 0 )
			{
				if ( crouch )
					thread ghillie_enemy_resume_moving( "crouch", new_move_time );
				else
					thread ghillie_enemy_resume_moving( "prone", new_move_time );
			}
		}

		self notify( "stop_moving" );
		shot_attempts = 0;
		ghillie_enemy_crouch_and_fire();
		while ( !ghillie_enemy_can_be_seen( false, false ) && ( shot_attempts <= randomintrange( 0, 4 ) ) )
		{
			shot_attempts++;
			ghillie_enemy_crouch_and_fire();
		}
		ghillie_enemy_go_prone();
		ghillie_enemy_freeze_while_prone();
	}
}

ghillie_enemy_go_prone()
{
	ghillie_enemy_set_nofire();

	self allowedstances( "prone" );

	if ( !self.ghillie_is_prone )
	{
		self.ghillie_is_frozen = false;
		self.ghillie_is_prone = true;
		self anim_generic_custom_animmode( self, "gravity", "pronehide_dive" );
	}
}

ghillie_enemy_freeze_while_prone()
{
	if ( self.ghillie_is_frozen )
		return;
		
	ghillie_enemy_set_unaware();

	self allowedstances( "prone" );
	self.ghillie_is_prone = true;
	self.ghillie_is_frozen = true;
	self thread anim_generic_loop( self, "prone_idle", "end_idle");
}	

ghillie_enemy_resume_moving( stance, move_time )
{
	level endon( "so_hidden_complete" );
	self endon( "quit_ghillie_behavior" );
	self endon( "death" );
	self endon( "long_death" );

	self endon( "stop_moving" );

	self notify( "end_idle" );

	ghillie_enemy_set_nofire();

	self allowedstances( stance );
	self.ghillie_is_frozen = false;
	switch ( stance )
	{
		case "prone":	self.ghillie_is_prone = true;	break;
		case "crouch":	self.ghillie_is_prone = false;	break;
	}
	
	ghillie_enemy_set_goal_pos();

	self waittill( "goal_changed" );

	if ( !isdefined( move_time ) )
		move_time = ghillie_get_move_time();
	
	wait move_time;
}

ghillie_get_move_time()
{
	if ( isdefined( self.ghillie_moved_once ) && self.ghillie_moved_once )
		return ghillie_get_time( level.ghillie_move_time_min, level.ghillie_move_time_max );

	self.ghillie_moved_once = true;
	return ghillie_get_time( level.ghillie_move_intro_min, level.ghillie_move_intro_max );
}

ghillie_enemy_crouch_and_fire()
{
	level endon( "so_hidden_complete" );
	self endon( "quit_ghillie_behavior" );
	self endon( "death" );
	self endon( "long_death" );

	self notify ( "end_idle" );

	ghillie_enemy_set_nofire();

	self allowedstances( "crouch" );
	self.ghillie_is_prone = false;
	self.ghillie_is_froze = false;

	self setgoalpos( self.origin );

	thread ghillie_enemy_enable_shooting();
	thread ghillie_enemy_abandon_shooting();

	waittill_any( "shooting", "abandon_shooting" );
	
	self.dontEverShoot = true;

	wait ghillie_get_time( level.ghillie_shoot_hold_min, level.ghillie_shoot_hold_max );
}

ghillie_enemy_enable_shooting()
{
	level endon( "so_hidden_complete" );
	self endon( "quit_ghillie_behavior" );
	self endon( "death" );
	self endon( "long_death" );
	self endon( "abandon_shooting" );

	wait ghillie_get_time( level.ghillie_shoot_pause_min, level.ghillie_shoot_pause_max );

	self.dontEverShoot = undefined;
}

ghillie_enemy_abandon_shooting()
{
	level endon( "so_hidden_complete" );
	self endon( "quit_ghillie_behavior" );
	self endon( "death" );
	self endon( "long_death" );

	self endon( "shooting" );
	self endon( "enemy_visible" );

	wait ghillie_get_time( level.ghillie_shoot_quit_min, level.ghillie_shoot_quit_max );

	self notify( "abandon_shooting" );
}

ghillie_enemy_quit_when_sidearm()
{
	level endon( "so_hidden_complete" );
	self endon( "quit_ghillie_behavior" );
	self endon( "death" );
	self endon( "long_death" );

	self waittill( "switched_to_sidearm" );

	ghillie_enemy_quit_ghillie();

	self waittill( "switched_to_lastweapon" );

	thread ghillie_enemy_behavior();
}

ghillie_enemy_quit_ghillie()
{
	ghillie_enemy_set_active();

	self.ghillie_is_prone = false;
	self.ghillie_is_frozen = false;
	self.combatmode = "cover";
	self.dontEverShoot = undefined;
	self allowedstances( "stand", "crouch" );

	self notify ( "quit_ghillie_behavior" );
}

ghillie_enemies_quit_ghillie()
{
	enemies = getaiarray( "axis" );
	foreach ( guy in enemies )
	{
		if ( guy.classname == "actor_enemy_ghillie_sniper" )
		{
			guy thread ghillie_enemy_silent_remove();
			
			guy ghillie_enemy_set_active();

			guy.ghillie_is_prone = false;
			guy.ghillie_is_frozen = false;
			guy.combatmode = "cover";
			guy.dontEverShoot = undefined;
			guy allowedstances( "stand", "crouch" );
			guy.goalradius = 2048;
			guy setgoalentity( getclosest( guy.origin, level.players ) );
			guy setEngagementMinDist( 0, 0 );
			guy setEngagementMaxDist( 8000, 9000 );

			guy notify ( "end_idle" );
			guy notify ( "quit_ghillie_behavior" );
		}
	}
}

ghillie_enemy_set_goal_pos()
{
	close_player = get_closest_player( self.origin );
	self setgoalpos( close_player.origin );
}

ghillie_enemy_silent_remove()
{
	self endon( "death" );
	level endon( "so_hidden_complete" );
	
	while ( 1 )
	{
		wait 1;
		foreach ( player in level.players )
		{
			if ( distance( player.origin, self.origin ) < 512 )
				continue;
		}
		
		if ( ghillie_enemy_can_be_seen( false, true ) )
			continue;

		self notify( "ghillie_silent_kill" );
		self Delete();
	}
}

ghillie_enemy_can_be_seen( check_for_flub, check_offset )
{
	can_see_me = ghillie_enemy_sight_test( level.player, check_offset );
	if ( !can_see_me && is_coop() )
		can_see_me = ghillie_enemy_sight_test( level.player2, check_offset );

	// If I can be seen, then check for a flub. If not, then restart my flub from scratch.
	if ( isdefined( check_for_flub ) && check_for_flub )
	{
		if ( can_see_me )
			can_see_me = ghillie_enemy_check_flub();
		else
			ghillie_enemy_clear_flub_time();
	}
			
	return can_see_me;
}

ghillie_enemy_sight_test( player, check_offset )
{
	my_eye = self geteye();
	their_eye = player geteye();

	dot = 0.9;
	if ( player playerADS() >= 0.8 )
		dot = 0.998;
		
	if ( !player player_looking_at( my_eye, dot, true ) )
		return false;

	can_see_me = SightTracePassed( my_eye, their_eye, false, self );
	if ( !can_see_me && self.ghillie_is_prone && isdefined( check_offset ) && check_offset )
	{		
		my_eye_offset = my_eye + ( 0, 0, 48 );
		can_see_me = SightTracePassed( my_eye_offset + ( 0, 0, 48 ), their_eye, false, self );
	}

	return can_see_me;
}

ghillie_enemy_check_flub()
{
	// If we aren't allowing flubs, always return true.
	if ( !isdefined( level.ghillie_flub_time_min ) )
		return true;

	// If we don't have a current flub time, set it now and return.
	// This makes it so the time is set from the first moment of being seen again.
	if ( !isdefined( self.ghillie_flub_time ) )
	{
		ghillie_enemy_set_flub_time();
		return true;
	}
	
	// Otherwise, player has been staring at me, see if I should make a mistake.
	if ( gettime() < self.ghillie_flub_time	)
		return true;
	
	// We are ready to make a mistake.
	ghillie_enemy_clear_flub_time();
	return false;
}

ghillie_enemy_set_unaware()
{
	my_id = self.unique_id;
	
	level.ghillies_unaware[ my_id ] = my_id;
	level.ghillies_nofire = array_remove( level.ghillies_nofire, my_id );
	level.ghillies_active = array_remove( level.ghillies_active, my_id );
}

ghillie_enemy_set_nofire()
{
	my_id = self.unique_id;
	
	level.ghillies_nofire[ my_id ] = my_id;
	level.ghillies_unaware = array_remove( level.ghillies_unaware, my_id );
	level.ghillies_active = array_remove( level.ghillies_active, my_id );
}

ghillie_enemy_set_active()
{
	my_id = self.unique_id;
	
	level.ghillies_active[ my_id ] = my_id;
	level.ghillies_unaware = array_remove( level.ghillies_unaware, my_id );
	level.ghillies_nofire = array_remove( level.ghillies_nofire, my_id );
}

ghillie_enemy_set_flub_time()
{
	if ( !isdefined( level.ghillie_flub_time_min ) )
		return;
		
	self.ghillie_flub_time = gettime() + ghillie_get_time( level.ghillie_flub_time_min, level.ghillie_flub_time_max );
}

ghillie_enemy_clear_flub_time()
{
	self.ghillie_flub_time = undefined;
}

ghillie_get_time( time_min, time_max )
{
	wait_time = randomfloatrange( time_min, time_max );
	if ( is_coop() )
		wait_time *= level.coop_difficulty_scalar;
	return wait_time;
}

// ---------------------------------------------------------------------------------

create_patrol_enemies( enemy_id, wait_id, spawn_delay )
{
	patrol_enemies_init();

	assertex( isdefined( enemy_id ), "create_patrol_enemies() requires a valid enemy_id" );
		
	if ( isdefined( wait_id ) )
		level waittill( wait_id );

	thread stealth_enable();

	patrol_spawners = getentarray( enemy_id, "targetname" );
	assertex( patrol_spawners.size > 0, "create_patrol_enemies() could not find any spawners with id " + enemy_id );
	
	array_thread( patrol_spawners, ::add_spawn_function, ::patrol_enemy_init );
	foreach ( spawner in patrol_spawners )
		spawner patrol_enemy_spawn();
}

patrol_enemy_spawn()
{
	if ( !should_spawn() )
		return ;
		
	level endon( "so_hidden_complete" );

	stagger = isdefined( self.script_noteworthy ) && ( self.script_noteworthy == "patrol_stagger_spawn" );
	if ( stagger )
		wait randomfloatrange( 0.0, 4.0 );
		
	self spawn_ai( true );
}

patrol_enemies_init()
{
	if ( isdefined( level.patrol_enemies_initialized ) && level.patrol_enemies_initialized )
		return;
		
	thread script_chatgroups();
	level.patrol_enemies_initialized = true;
	level.patrols = [];
	level.patrols_unaware = [];
	level.patrols_nofire = [];
}

patrol_enemy_init()
{
	level.patrol_count++;

	thread patrol_enemy_register_alert();
	thread patrol_enemy_register_attack();
	thread patrol_enemy_register_death();
	maps\_stealth_utility::stealth_default();

	if ( isdefined( self.target ) )
		thread maps\_patrol::patrol();
		
	self.patrol_stop = [];
	self.patrol_start = [];
}

patrol_enemy_register_alert()
{
	level endon( "so_hidden_complete" );

	my_id = self.unique_id;
	level.patrols_unaware[ my_id ] = my_id;
	
	self waittill( "enemy" );

	level.patrols_unaware = array_remove( level.patrols_unaware, my_id );
}

patrol_enemy_register_attack()
{
	level endon( "so_hidden_complete" );

	my_id = self.unique_id;
	level.patrols_nofire[ my_id ] = my_id;
	
	self waittill( "shooting" );

	level.patrols_nofire = array_remove( level.patrols_nofire, my_id );
}

patrol_enemy_register_death()
{
	level endon( "so_hidden_complete" );
	self endon( "patrol_silent_kill" );

	my_id = self.unique_id;
	level.patrols = array_add( level.patrols, self );

	self waittill( "death", attacker );

	level.patrol_count--;

	level.patrols = array_removedead( level.patrols );

	if ( array_contains( level.patrols_unaware, my_id )	)
		death_register_unaware( attacker );
	else
	if ( array_contains( level.patrols_nofire, my_id ) )
		death_register_nofire( attacker );
	else
		death_register_basic( attacker );
}

patrol_enemy_silent_remove()
{
	self endon( "death" );
	level endon( "so_hidden_complete" );
	
	while( 1 )
	{
		wait 1;
		foreach ( player in level.players )
		{
			if ( distance( player.origin, self.origin ) < 384 )
				continue;
			
			if ( patrol_enemy_sight_test( player ) )
				continue;
		}
		
		self notify( "patrol_silent_kill" );
		level.patrols = array_remove( level.patrols, self );
		self Delete();
	}
}

patrol_enemy_sight_test( player )
{
	my_eye = self geteye();
	if ( !player player_looking_at( self.origin, 0.9, true ) && !player player_looking_at( my_eye, 0.9, true ) )
		return false;

	their_eye = player geteye();
	if ( !SightTracePassed( self.origin, their_eye, false, self ) && !SightTracePassed( my_eye, their_eye, false, self ) )
		return false;
		
	return true;
}

// ---------------------------------------------------------------------------------

death_register_unaware( attacker, force_dialog )
{
	if ( isdefined( attacker ) && isplayer( attacker ) )
		attacker.kills_stealth++;
		
	level.deaths_stealth++;
	level.bonus_time_given += level.bonus_stealth;
	death_dialog( level.dialog_kill_stealth, level.deaths_stealth, force_dialog );
}

death_register_nofire( attacker, force_dialog )
{
	if ( isdefined( attacker ) && isplayer( attacker ) )
		attacker.kills_nofire++;

	level.deaths_nofire++;
	level.bonus_time_given += level.bonus_nofire;
	death_dialog( level.dialog_kill_quiet, level.deaths_nofire, force_dialog );
}

death_register_basic( attacker, force_dialog )
{
	if ( isdefined( attacker ) && isplayer( attacker ) )
		attacker.kills_basic++;

	level.deaths_basic++;
	level.bonus_time_given += level.bonus_basic;
	death_dialog( level.dialog_kill_basic, level.deaths_basic, force_dialog );
}

death_dialog( dialog, total, force_dialog )
{
	level endon( "so_hidden_complete" );

	if ( !isdefined( force_dialog ) || !force_dialog )
	{
		if ( level.death_dialog_time > gettime() )
			return;
	}
			
	level.death_dialog_time = gettime() + level.death_dialog_throttle;

	wait 0.5;
		
	radio_dialogue( dialog[ total % dialog.size ] );
}

// ---------------------------------------------------------------------------------

turn_on_stealth()
{
	battlechatter_off( "axis" );
	battlechatter_off( "allies" );

	maps\_stealth::main();

	foreach ( player in level.players )
		player maps\_stealth_utility::stealth_default();

	thread stealth_music_loop();
}

stealth_disable()
{
	// Currently the Ghillies behave poorly when the Stealth System is active. The way the map is structured
	// makes it viable to disable stealth from pocket to pocket. Wait until all the patrols are dead before doing
	// so though, just in case they are at the edge. 
	// A flag can be set to force it (player touches a trigger where they've gone too far to allow stealth to continue.
	while ( level.patrol_count > 0 && !flag( "force_disable_stealth" ) )
		wait 1;

	foreach ( player in level.players )
	{
		player.maxVisibleDist = 8192;	
		
		if ( player ent_flag_exist( "_stealth_enabled" ) )
			player ent_flag_clear( "_stealth_enabled" );
	}
	
	
	foreach ( patrol in level.patrols )
		patrol patrol_enemy_silent_remove();
}

stealth_enable()
{
	// Clear this so the next trigger has a chance to set it when new ghillies are spawned.
	flag_clear( "force_disable_stealth" );

	// Force the ghillies out of ghillie mode.
	ghillie_enemies_quit_ghillie();
	
	foreach ( player in level.players )
	{
		if ( player ent_flag_exist( "_stealth_enabled" ) )
			player ent_flag_set( "_stealth_enabled" );

		player thread maps\_stealth_visibility_friendly::friendly_visibility_logic();
	}
}

stealth_music_loop()
{
	level endon( "so_hidden_complete" );

	while ( 1 )
	{
		thread stealth_music_hidden_loop();

		flag_wait( "_stealth_spotted" );

		music_stop( .2 );
		wait .5;
		thread stealth_music_busted_loop();

		flag_waitopen( "_stealth_spotted" );

		music_stop( 3 );
		wait 3.25;
	}
}

stealth_music_hidden_loop()
{
	level endon( "so_hidden_complete" );
	level endon( "_stealth_spotted" );

	hidden_stealth_music_TIME = 119;
	while ( 1 )
	{
		MusicPlayWrapper( "scoutsniper_deadpool_music" );
		wait hidden_stealth_music_TIME;
		wait 2;
	}
}

stealth_music_busted_loop()
{
	level endon( "so_hidden_complete" );
	level endon( "_stealth_spotted" );

	hidden_stealth_busted_music_TIME = 88;
	while ( 1 )
	{
		MusicPlayWrapper( "scoutsniper_dash_music" );
		wait hidden_stealth_busted_music_TIME;
		wait 2;
	}
}

// ---------------------------------------------------------------------------------

turn_on_radiation()
{
	thread maps\_radiation::main();
	
	wait 4;
	thread radio_dialogue( "scoutsniper_mcm_deadman" );
}

// ---------------------------------------------------------------------------------

player_noprone_water()
{
	water = getent( "water_no_prone", "targetname" );

	while ( 1 )
	{
		water waittill( "trigger" );

		player_touching = true;
		while ( player_touching )
		{
			player_touching = false;
			foreach( player in level.players )
			{
				if ( player_touching_water( player, water ) )
					player_touching = true;
			}
			
			wait 0.05;
		}
	}
}

player_touching_water( player, water )
{
	// If they are touching, set them up if they haven't been setup yet and return true.
	if ( player istouching( water ) )
	{
		if ( !isdefined( player.touching_water ) )
		{
			player.touching_water = true;
			player allowprone( false );
		}
		return true;
	}

	// Otherwise unset the properties and return false.
	if ( isdefined( player.touching_water ) )
	{
		player.touching_water = undefined;
		player allowprone( true );
	}
	return false;
}

// ---------------------------------------------------------------------------------

hud_bonuses_create()
{
	ypos = so_hud_ypos();
	stealth_title	= so_create_hud_item( 3, ypos, &"SO_HIDDEN_SO_GHILLIES_KILL_STEALTH", self );
	nofire_title	= so_create_hud_item( 4, ypos, &"SO_HIDDEN_SO_GHILLIES_KILL_NOFIRE", self );
	basic_title		= so_create_hud_item( 5, ypos, &"SO_HIDDEN_SO_GHILLIES_KILL_BASIC", self );

	stealth_kills	= so_create_hud_item( 3, ypos, "", self );
	nofire_kills	= so_create_hud_item( 4, ypos, "", self);
	basic_kills		= so_create_hud_item( 5, ypos, "", self);
	
	stealth_kills.alignx	= "left";
	nofire_kills.alignx		= "left";
	basic_kills.alignx		= "left";
	
	thread info_hud_handle_fade( stealth_title, "so_hidden_complete" );
	thread info_hud_handle_fade( nofire_title, "so_hidden_complete" );
	thread info_hud_handle_fade( basic_title, "so_hidden_complete" );

	thread info_hud_handle_fade( stealth_kills, "so_hidden_complete" );
	thread info_hud_handle_fade( nofire_kills, "so_hidden_complete" );
	thread info_hud_handle_fade( basic_kills, "so_hidden_complete" );

	if ( is_coop() )
		thread hud_bonuses_update_scores_coop( stealth_kills, nofire_kills, basic_kills, self );
	else
		thread hud_bonuses_update_scores_sp( stealth_kills, nofire_kills, basic_kills );
	
	flag_wait( "so_hidden_complete" );
	
	stealth_title	thread so_remove_hud_item();
	nofire_title	thread so_remove_hud_item();
	basic_title		thread so_remove_hud_item();

	stealth_kills	thread so_remove_hud_item();
	nofire_kills	thread so_remove_hud_item();
	basic_kills		thread so_remove_hud_item();
}


hud_bonuses_update_scores_coop( stealth_kills, nofire_kills, basic_kills, player )
{
	while ( !flag( "so_hidden_complete" ) )
	{
		stealth_kills.label	= player.kills_stealth	+ " (" + level.deaths_stealth	+ ")";
		nofire_kills.label	= player.kills_nofire	+ " (" + level.deaths_nofire		+ ")";
		basic_kills.label	= player.kills_basic	+ " (" + level.deaths_basic		+ ")";
		wait 0.5;
	}
}

hud_bonuses_update_scores_sp( stealth_kills, nofire_kills, basic_kills )
{
	while ( !flag( "so_hidden_complete" ) )
	{
		stealth_kills.label	= level.deaths_stealth;
		nofire_kills.label	= level.deaths_nofire;
		basic_kills.label	= level.deaths_basic;
		wait 0.5;
	}
}

// ---------------------------------------------------------------------------------

objective_set_chopper()
{
	flag_wait( "so_hidden_obj_chopper" );
	
	obj = getstruct( "so_hidden_obj_chopper", "script_noteworthy" );
	objective_position( 1, obj.origin );
}

// ---------------------------------------------------------------------------------

player_protect_falling()
{
	protect_trigger = getent( "protect_falling_player", "script_noteworthy" );
	assertex( isdefined( protect_trigger ), "player_protect_falling() was unable to find a valid trigger." );
	
	while ( 1 )
	{
		protect_trigger waittill( "trigger", player );
		if ( !isplayer( player ) )
			continue;

		protect_trigger thread player_protect( player );
	}
}

player_protect( player )
{
	if ( isdefined( player.protected_health ) )
		return;

	player endon( "trigger_stop_protecting" );
	player.protected_health = player.health;

	thread player_protect_stop( player );

	player.health = 1000;
	while( 1 )
	{
		player waittill( "damage", damage, attacker );
		if ( attacker.classname == "worldspawn" )
			player.health = player.protected_health;
	}
}

player_protect_stop( player )
{
	wait 0.25;
	player notify( "trigger_stop_protecting" );
	player.health = player.protected_health;
	player.protected_health = undefined;
}

// ---------------------------------------------------------------------------------

create_chatter_aliases_for_patrols()
{
	aliases = [];
	aliases[ aliases.size ] = "scoutsniper_ru1_passcig";
	aliases[ aliases.size ] = "scoutsniper_ru2_whoseturnisit";
	aliases[ aliases.size ] = "scoutsniper_ru1_wakeup";
	aliases[ aliases.size ] = "scoutsniper_ru2_buymotorbike";
	aliases[ aliases.size ] = "scoutsniper_ru1_tooexpensive";
	aliases[ aliases.size ] = "scoutsniper_ru2_illtakecareofit";
	aliases[ aliases.size ] = "scoutsniper_ru1_otherteam";
	aliases[ aliases.size ] = "scoutsniper_ru2_notwandering";
	aliases[ aliases.size ] = "scoutsniper_ru1_wandering";
	aliases[ aliases.size ] = "scoutsniper_ru2_zahkaevspayinggood";
	aliases[ aliases.size ] = "scoutsniper_ru1_wasteland";
	//aliases[ aliases.size ] = "scoutsniper_ru2_imonit";//yelling
	//aliases[ aliases.size ] = "scoutsniper_ru1_takealook";//radio and loud
	aliases[ aliases.size ] = "scoutsniper_ru2_whoseturnisit";
	aliases[ aliases.size ] = "scoutsniper_ru1_onourway";
	aliases[ aliases.size ] = "scoutsniper_ru1_passcig";
	aliases[ aliases.size ] = "scoutsniper_ru2_youidiot";
	aliases[ aliases.size ] = "scoutsniper_ru1_wakeup";
	aliases[ aliases.size ] = "scoutsniper_ru2_call";
	aliases[ aliases.size ] = "scoutsniper_ru1_tooexpensive";
	aliases[ aliases.size ] = "scoutsniper_ru2_americagoingtostartwar";
	aliases[ aliases.size ] = "scoutsniper_ru4_raise";
	aliases[ aliases.size ] = "scoutsniper_ru2_sendsomeonetocheck";
	aliases[ aliases.size ] = "scoutsniper_ru4_ifold";
	aliases[ aliases.size ] = "scoutsniper_ru2_andreibringingfood";
	aliases[ aliases.size ] = "scoutsniper_ru4_thisonesheavy";
	aliases[ aliases.size ] = "scoutsniper_ru2_quicklyaspossible";
	aliases[ aliases.size ] = "scoutsniper_ru4_didnteatbreakfast";
	aliases[ aliases.size ] = "scoutsniper_ru2_yescomrade";
	aliases[ aliases.size ] = "scoutsniper_ru4_takenzakhaevsoffer";
	aliases[ aliases.size ] = "scoutsniper_ru2_clearrotorblades";
	//aliases[ aliases.size ] = "scoutsniper_ru4_mayhaveproblem";//fear
	aliases[ aliases.size ] = "scoutsniper_ru2_radiationdosimeters";
	aliases[ aliases.size ] = "scoutsniper_ru4_canceltransactions";
	aliases[ aliases.size ] = "scoutsniper_ru2_dontbelieveatall";
	aliases[ aliases.size ] = "scoutsniper_ru4_cantwaitforshiftend";
	aliases[ aliases.size ] = "scoutsniper_ru2_ok";
	aliases[ aliases.size ] = "scoutsniper_ru4_hopeitdoesntrain";
	aliases[ aliases.size ] = "scoutsniper_ru2_professionaljob";

	level.chatter_aliases = aliases;
}

script_chatgroups()
{
	level.last_talker = undefined;
	talker = undefined;
	create_chatter_aliases_for_patrols();
	spawners = GetSpawnerTeamArray( "axis" );
	array_thread( spawners, ::add_spawn_function, ::setup_chatter );

	level.current_conversation_point = RandomInt( level.chatter_aliases.size );


	while ( true /*!flag( "done_with_stealth_camp" )*/ )
	{
		flag_waitopen( "_stealth_spotted" );

		closest_talker = undefined;
		next_closest = undefined;
		enemies = GetAIArray( "axis" );
		//sort from closest to furthest
		closest_enemies = get_array_of_closest( getAveragePlayerOrigin(), enemies );

		for ( i = 0; i < closest_enemies.size; i++ )
		{
			if ( IsDefined( closest_enemies[ i ].script_chatgroup ) )
			{
				closest_chat_group = closest_enemies[ i ].script_chatgroup;
				closest_talker = closest_enemies[ i ];
				if ( closest_talker ent_flag_exist( "_stealth_normal" ) )
					if ( !closest_talker ent_flag( "_stealth_normal" ) )
						continue;

				//find next closest member of same chat group
				next_closest = find_next_member( closest_enemies, i, closest_chat_group );

				//if has no buddy or is too far from buddy or buddy is alert find another

				if ( !isdefined( next_closest ) )
					continue;
				if ( next_closest ent_flag_exist( "_stealth_normal" ) )
					if ( !next_closest ent_flag( "_stealth_normal" ) )
						continue;
				d = Distance( next_closest.origin, closest_talker.origin );
				if ( d > 220 )
				{
					//println( d );
					continue;
				}
				else
					break;
			}
		}
		//we have a group, say something
		if ( IsDefined( next_closest ) )
		{
			//check if closest guy is our last talker, if so use second closest
			if ( IsDefined( level.last_talker ) )
			{
				if ( level.last_talker == closest_talker )
					talker = next_closest;
				else
					talker = closest_talker;
			}
			else
				talker = closest_talker;

			talker chatter_play_sound( level.chatter_aliases[ level.current_conversation_point ] );

			level.current_conversation_point++;
			if ( level.current_conversation_point >= level.chatter_aliases.size )
				level.current_conversation_point = 0;
			level.last_talker = talker;

			wait .5;// conversation has pauses
		}
		else
			wait 2;// lets try again in 2 seconds
	}
}

setup_chatter()
{
	if ( !isdefined( self.script_chatgroup ) )
		return;

	self endon( "death" );

	self ent_flag_init( "mission_dialogue_kill" );
	self setup_chatter_kill_wait();
	self ent_flag_set( "mission_dialogue_kill" );
}

setup_chatter_kill_wait()
{
	self endon( "death" );
	self endon( "event_awareness" );
	self endon( "enemy" );

	flag_wait_any( "_stealth_spotted", "_stealth_found_corpse" );
}

chatter_play_sound( alias )
{
	if ( is_dead_sentient() )
		return;

	org = Spawn( "script_origin", ( 0, 0, 0 ) );
	org endon( "death" );
	thread maps\_utility::delete_on_death_wait_sound( org, "sounddone" );

	org.origin = self.origin;
	org.angles = self.angles;
	org LinkTo( self );

	org PlaySound( alias, "sounddone" );
	//println( "script_chatter alias = " + alias );

	self chatter_play_sound_wait( org );
	if ( IsAlive( self ) )
		self notify( "play_sound_done" );

	org StopSounds();
	wait( 0.05 );// stopsounds doesnt work if the org is deleted same frame

	org Delete();
}

chatter_play_sound_wait( org )
{
	self endon( "death" );
	self endon( "mission_dialogue_kill" );
	org waittill( "sounddone" );
}


find_next_member( closest_enemies, closest, closest_chat_group )
{
	for ( i = closest + 1; i < closest_enemies.size; i++ )
	{
		if ( IsDefined( closest_enemies[ i ].script_chatgroup ) )
		{
			if ( closest_enemies[ i ].script_chatgroup == closest_chat_group )
				return closest_enemies[ i ];
		}
	}
	return undefined;
}

// ---------------------------------------------------------------------------------

clip_nosight_wait_for_activate()
{
	self endon( "death" );

	flag_wait( self.script_flag );

	self thread clip_nosight_wait_damage();
	self thread clip_nosight_wait_stealth();
}

clip_nosight_wait_damage()
{
	if ( flag( "_stealth_spotted" ) )
		return;

	level endon( "_stealth_spotted" );

	self setcandamage( true );
	self waittill( "damage" );

	self delete();
}

clip_nosight_wait_stealth()
{
	self endon( "death" );

	flag_wait_either( "_stealth_spotted", "_stealth_found_corpse" );

	self delete();
}

// ---------------------------------------------------------------------------------
