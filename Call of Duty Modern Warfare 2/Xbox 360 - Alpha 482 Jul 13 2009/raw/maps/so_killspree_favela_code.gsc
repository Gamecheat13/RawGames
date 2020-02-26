#include common_scripts\utility;
#include maps\_utility;
#include maps\_vehicle;
#include maps\_anim;
#include maps\_specialops;
#include maps\_hud_util;
#using_animtree( "generic_human" );

/*dog_goto_player()
{
	self endon( "death" );
	
	if ( isdefined( self.target ) )
		self waittill( "goal" );

	if ( level.player.size == 2 )
	{
		if ( randomint( 100 ) > 50 )
			self setgoalentity( level.player[ 0 ] );
		else
			self setgoalentity( level.player[ 1 ] );
	}
	else
		self setgoalentity( level.player );
		
	self.goalradius = 300;
}*/

ambush_to_seek()
{
	level endon( "special_op_terminated" );
	self endon( "death" );
	
	if ( !isdefined( self.script_combatmode ) )
		return;
		
	if ( self.script_combatmode == "ambush" )
	{
		while( 1 )
		{
			wait level.ambush_to_seeker_delay + randomint( level.ambush_to_seeker_delay );
			flag_wait( "detailed_enemy_population_info_availabe" );
			if( ( level.ambush_to_seeker + level.enemy_seekers ) > level.current_enemy_population/3 )
				continue;
			else
				break;	
		}
		
		self.combatmode = "cover";	
		self.ambush_to_seeker = true;
		
		self enemy_seek_player( 1024 );
		wait level.ambush_to_seeker_delay;
		self enemy_seek_player( 256 );
	}
}

enemy_seek_player( goalradius )
{
	self endon( "death" );
	
	if ( isdefined( self.target ) )
		self waittill( "goal" );
		
	if ( level.players.size == 2 )
	{
		if ( randomint( 100 ) > 50 )
			self setgoalentity( level.players[ 0 ] );
		else
			self setgoalentity( level.players[ 1 ] );
	}
	else
		self setgoalentity( level.player );

	self.goalradius = goalradius;
}

release_doggy()
{
	level endon( "special_op_terminated" );

	dog_spawner = getentarray( "fence_dog_spawner", "targetname" );
	array_spawn_function( dog_spawner, ::dog_register_death );
	array_spawn_function( dog_spawner, ::enemy_seek_player, 300 );

	if( !isdefined( level.gameskill ) )
		num_of_dogs = max( int( getdvar( "g_gameskill" ) ), 1 );
	else
		num_of_dogs = max( level.gameskill, 1 );
		
	// difficulty modifier
	if( is_Coop() )
		num_of_dogs	+= 1;

	while( 1 )
	{
		level waittill( "who_let_the_dogs_out" );
		
		for( i = 0; i < num_of_dogs; i++ )
		{
			doggy = random( dog_spawner );
			if ( getaiSpeciesArray( "axis", "dog" ).size < level.max_dogs_at_once )
			{
				doggy.count = 1;
				doggy stalingradSpawn();
			}
			wait 1 + randomint( 5 );
		}
	}
}

hud_create_kill_counter()
{
	self endon( "hud_cleaned_up" );

	self.kill_hudelem = so_create_hud_item( 3, so_hud_ypos(), &"SPECIAL_OPS_HOSTILES", self );
	self.kill_hudelem_score = so_create_hud_item( 3, so_hud_ypos(), level.points_counter, self );
	self.kill_hudelem_score.alignx = "left";
	
/*	self thread maps\_specialops::info_hud_handle_fade( hudelem );
	self thread maps\_specialops::info_hud_handle_fade( hudelem_score );*/

	flag_wait( "favela_enemies_spawned" );
	
	while ( level.points_counter > 0 )
	{
		level waittill( "enemy_killed_by_player" );

		if ( level.points_counter <= 5 )
		{
			self.kill_hudelem so_hud_pulse_loop_default( "blue" );
			self.kill_hudelem_score so_hud_pulse_loop_default( "blue" );
		}
				
		self.kill_hudelem thread so_hud_pulse_create();
		self.kill_hudelem_score thread so_hud_pulse_create( level.points_counter );
	}

	flag_set( "challenge_success" );
	thread fade_challenge_out();
	thread hud_clean_up();
}

hud_create_civ_counter()
{
	self endon( "hud_cleaned_up" );

	self.civ_hudelem = so_create_hud_item( 4, so_hud_ypos(), &"SO_KILLSPREE_FAVELA_CIVILIANS", self );
	self.civ_hudelem_score = so_create_hud_item( 4, so_hud_ypos(), level.civilian_killed + " (" + level.civilian_kill_fail + ")", self );
	self.civ_hudelem_score.alignx = "left";
	
/*	self thread maps\_specialops::info_hud_handle_fade( hudelem );
	self thread maps\_specialops::info_hud_handle_fade( hudelem_score );*/

	flag_wait( "favela_enemies_spawned" );
	
	while ( level.civilian_killed < level.civilian_kill_fail )
	{
		level waittill( "civilian_died" );

		kills_remaining = level.civilian_kill_fail - level.civilian_killed;
		
		if ( kills_remaining >= 1 )
			thread so_dialog_killing_civilians();

		if ( kills_remaining == 2 )
		{
			self.civ_hudelem set_hud_yellow();
			self.civ_hudelem_score set_hud_yellow();
		}
		else if ( kills_remaining == 1 )
		{
			self.civ_hudelem so_hud_pulse_loop_default( "red" );
			self.civ_hudelem_score so_hud_pulse_loop_default( "red" );
		}
		
		self.civ_hudelem thread so_hud_pulse_create();
		self.civ_hudelem_score thread so_hud_pulse_create( level.civilian_killed + " (" + level.civilian_kill_fail + ")" );
	}

	so_force_deadquote( "@SO_KILLSPREE_FAVELA_MISSION_FAILED_CIVILIAN" );
	thread missionfailedwrapper();
	thread hud_clean_up();
}

hud_clean_up()
{
	if ( isdefined( self.kill_hudelem ) )
	{
		self.kill_hudelem thread so_remove_hud_item();
		self.kill_hudelem_score thread so_remove_hud_item();
		self.civ_hudelem thread so_remove_hud_item();
		self.civ_hudelem_score thread so_remove_hud_item();
	}
	
	self notify( "hud_cleaned_up" );
}

// ---------------------------------------------------------------------------------


enemy_type_monitor()
{
	level endon( "special_op_terminated" );

	flag_wait( "enemy_population_info_availabe" );
	
	while ( 1 )
	{
		enemies = getaiarray( "axis" );
		
		level.ambush_to_seeker = 0;
		level.enemy_seekers = 0;
		level.enemy_ambushers = 0;
		
		foreach ( ai in enemies )
		{
			if( isdefined( ai.ambush_to_seeker ) )
				level.ambush_to_seeker++;
			
			if( isdefined( ai.script_noteworthy ) && ai.script_noteworthy == "seek_player" )
				level.enemy_seekers++;
				
			if( isdefined( ai.combatmode ) && ai.combatmode == "ambush" )
				level.enemy_ambushers++;
		}
		
		flag_set( "detailed_enemy_population_info_availabe" );
		wait 1;
	}
}

hunter_enemies_level_init()
{
	if ( !isdefined( level.hunter_kill_value ) )
		level.hunter_kill_value = 1;
}

hunter_register_death()
{
	if( !isdefined( level.current_enemy_population ) )
		level.current_enemy_population = 1;
	level.current_enemy_population++;
	level notify( "enemy_number_changed" );
	
	flag_set( "enemy_population_info_availabe" );
	
	self waittill( "death", attacker );
	
	level.current_enemy_population--;
	level notify( "enemy_number_changed" );
	level notify( "enemy_downed" );

	if ( isplayer( attacker ) )
	{
		level.points_counter--;
		level notify( "enemy_killed_by_player" );
	}
}

dog_register_death()
{
	self waittill( "death", attacker );
	
	if ( isplayer( attacker ) )
		attacker.dogs_killed++;
}

civilian_register_death()
{
	self waittill( "death", attacker );
	
	assert( isdefined( level.gameskill ) );
	if ( isplayer( attacker ) )
	{
		attacker.civilians_killed++;
		level.civilian_killed++;
		level notify( "civilian_died" );
	}
}