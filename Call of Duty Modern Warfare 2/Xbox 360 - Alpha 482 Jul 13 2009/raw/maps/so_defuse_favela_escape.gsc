#include maps\_utility;
#include common_scripts\utility;
#include maps\_anim;
#include maps\_hud_util;
#include maps\favela_escape_code;
#include maps\_specialops;
#include maps\_specialops_code;

#using_animtree( "generic_human" );

/*
// custom command stuff
+exec scripter +difficultyhard +set cg_drawfps 1 + set specialops 1 + set so_extra 1
*/

// heli_spawner = getent( "vehicle_hind_reveal", "targetname" );

main()
{
	so_delete_all_by_type( ::type_spawn_trigger, ::type_spawners );

	default_start( ::defuse );
	add_start( "defuse", ::defuse );

	base_map_assets();
	precacheItem( "briefcase_bomb_defuse_sp" );
	precacheModel( "prop_suitcase_bomb" );

	level._effect[ "light_c4_blink_nodlight" ] 			= loadfx( "misc/light_c4_blink_nodlight" );
	level.cosine[ "60" ] = cos( 60 );

	maps\_load::main();
	maps\_compass::setupMiniMap("compass_map_favela_escape");

	defuse_setup();
}

base_map_assets()
{
	maps\createart\favela_escape_art::main();
	maps\createfx\favela_escape_fx::main();
	maps\favela_escape_precache::main();
	maps\favela_escape_fx::main();
	maps\_hiding_door_anims::main();
}

defuse()
{
	thread fade_challenge_in();
	music_loop( "favelaescape_finalrun", 71 );
	
	level thread enable_challenge_timer( "defuse_start", "defuse_complete" );
	level thread fade_challenge_out( "defuse_complete" );
	level thread defuse_score();
}

/*
challenge_add_time( add_msg, add_time )
{
	add_msg_hud = maps\_specialops::so_create_hud_item( 2, 0, add_msg );
	add_msg_hud SetPulseFX( 60, 3 * 1000, 500 );

	// should be set in enable_challenge_timer( ... )
	assert( isdefined( level.start_flag ) );
	assert( isdefined( level.passed_flag ) );

	time_elapsed = ( gettime() - level.challenge_start_time ) / 1000;
	new_time_limit = level.challenge_time_limit - time_elapsed + add_time;

	level notify( "new_challenge_timer" );
	level.challenge_time_limit = new_time_limit;

	level thread enable_challenge_timer( level.start_flag, level.passed_flag );

	wait 6;
	add_msg_hud destroy();
}
*/

defuse_setup()
{
	clean_up_setup();

	level.defuse_count = 0;
	level.defuse_score = 0;

	// 5 minutes in all.
	level.challenge_time_limit = 300;

	flag_init( "defuse_update_score" );

	array_spawn_function_targetname( "civilian", ::civilian );
	add_global_spawn_function( "axis", ::ai_on_death );
	array_thread ( level.players, ::player_defuse_kill_clear );

	// delete some spawners if not coop
	if ( !is_coop() )
	{
		spawners = getentarray( "coop_only", "script_noteworthy" );
		array_call( spawners, ::delete );
	}

	defuse_location_arr = getentarray( "defuse_briefcase", "targetname" );
	array_thread( defuse_location_arr, ::defuse_location_handler );

	level thread enable_escape_warning();
	level thread enable_escape_failure();

	level thread open_door( "sbmodel_market_door_1" );
	level thread open_door( "sbmodel_vista1_door1" );

	change_combatmode_setup();
}

open_door( door_name )
{
	door = getent( door_name, "targetname" );
	linker = GetEnt( door.target, "targetname" );
	door LinkTo( linker );
	door ConnectPaths();
	linker RotateTo( linker.script_angles, .5 );
	linker waittill( "rotatedone" );
	door Unlink();
}

defuse_location_handler()
{
	self ent_flag_init( "briefcase_bomb_defused" );

	position_index = level.defuse_count;

//	Objective_AdditionalPosition( 0, position_index, self.origin );

	level.defuse_count++;

	bomb_array = getentarray( self.target, "targetname" );
	array_thread( bomb_array, ::defuse_c4_light, self );

	self thread defuse_icon();

	while( !self ent_flag( "briefcase_bomb_defused" ) )
	{
		self makeusable();
		self sethintstring( &"SO_DEFUSE_FAVELA_ESCAPE_DEFUSE_HINT" );

		self waittill( "trigger", player );
		self MakeUnusable();
		self hide();
		player briefcase_defuse( self );
		self show();
	}

	level.defuse_count--;
	flag_set( "defuse_update_score" );

//	Objective_AdditionalPosition( 0, position_index, ( 0,0,0 ) );

//	if ( level.defuse_count )
//		Objective_String( 0, &"SO_DEFUSE_FAVELA_ESCAPE_OBJ_REGULAR", level.defuse_count );
//	else
//		Objective_String( 0, &"SO_DEFUSE_FAVELA_ESCAPE_OBJ_REGULAR_DONE" );

//	if ( level.defuse_count > 0 )
//		challenge_add_time( &"SO_DEFUSE_FAVELA_ESCAPE_TIME_BONUS", 60 );
}

defuse_c4_light( briefcase )
{
	if ( self.model == "weapon_c4" )
	{
		wait randomfloat( 0.5 );
/*
		playFXOnTag( getfx( "light_c4_blink_nodlight" ), self, "tag_fx" );
		briefcase ent_flag_wait( "briefcase_bomb_defused" );
		stopfxontag( getfx( "light_c4_blink_nodlight" ), self, "tag_fx"  );
*/
		fx = PlayLoopedFX( getfx( "light_c4_blink_nodlight" ), 1, self gettagorigin( "tag_fx" ) );
		briefcase ent_flag_wait( "briefcase_bomb_defused" );
		fx delete();
	}
}

defuse_icon()
{
	icon = NewHudElem();
	icon SetShader( "waypoint_defuse", 1, 1 );
	icon.alpha = .5;
	icon.color = ( 1, 1, 1 );
	icon.x = self.origin[ 0 ];
	icon.y = self.origin[ 1 ];
	icon.z = self.origin[ 2 ] + 32;
	icon SetWayPoint( false, true, true );

	self ent_flag_wait( "briefcase_bomb_defused" );

	icon destroy();
}

change_combatmode_setup()
{
	array = getstructarray( "change_combatmode_node", "script_noteworthy" );
	array_thread( array, ::change_combatmode_node );

	array = getentarray( "change_combatmode_trigger", "targetname" );
	array_thread( array, ::change_combatmode_trigger );
}

change_combatmode_trigger()
{
	origin_ent = getent( self.target, "targetname" );

	dist_sqrd = origin_ent.radius * origin_ent.radius;

	while( true )
	{
		self waittill( "trigger", player );
		assert( isplayer( player ) );

		ai_array = getaiarray( "axis" );
		foreach( ai in ai_array )
		{
			if ( distancesquared( ai.origin, origin_ent.origin ) > dist_sqrd )
				continue;

			ai notify( "stop_going_to_node" );
			ai.combatMode = "cover";
			ai.goalradius = 640;
			ai setgoalentity( player );
		}
		wait 10;
	}
}

change_combatmode_node()
{
	assert( isdefined( self.script_combatmode ) );

	while( true )
	{
		self waittill( "trigger", ai );
		assert( isai( ai ) );
		ai.combatMode = self.script_combatmode;
	}
}

clean_up_setup()
{
	add_global_spawn_function( "axis", ::clean_up_spawnfunc );

	array = getentarray( "clean_up_volume", "targetname" );
	array_thread( array, ::clean_up_volume );

	array = getentarray( "clean_up_respawn_trigger", "script_noteworthy" );
	array_thread( array, ::clean_up_respawn_trigger );

}

clean_up_volume()
{
	assert( isdefined( self.script_group ) );

	volume = self;

	while( true )
	{
		wait 1;
		player_in_volume = false;
		foreach( player in level.players )
		{
			if ( player istouching( volume ) )
			{
				player_in_volume = true;
				break;
			}
		}

		if ( !player_in_volume )
			level notify( "clean_up", volume.script_group );
	}
}

clean_up_spawnfunc()
{
	self endon( "death" );

	if ( !isdefined( self.script_group ) )
		return;

	spawner = self.spawner;

	while( true )
	{
		level waittill( "clean_up", script_group );
		if ( self.script_group != script_group )
			continue;

		// to avoid multiple traces on the same frame
		wait randomfloat( .3 );

		can_be_seen = false;
		foreach( player in level.players )
		{
			if ( self SightConeTrace( player geteye(), player ) )
			{
				can_be_seen = true;
				break;
			}
		}

		if ( !can_be_seen )
		{
			spawner.count++;
			self delete();
		}
	}
}

clean_up_respawn_trigger()
{
	assert( isdefined( self.script_group ) );

	while( true )
	{
		self waittill( "trigger" );
		while( true )
		{
			level waittill( "clean_up", script_group );

			if ( self.script_group != script_group )
				continue;

			self thread maps\_spawner::trigger_spawner( self );
			break;
		}
	}
}

civilian()
{
	self endon( "death" );
	self waittill( "reached_path_end" );

	timer = 0;
	dist = 2000 * 2000;

	while( timer < 10 )
	{
		is_safe = true;
		foreach( player in level.players )
		{
			if ( DistanceSquared( self.origin, player.origin ) < dist )
			{
				is_safe = false;
				break;
			}

			if ( within_fov( player.origin, player.angles, self.origin, level.cosine[ "60" ] ) )
			{
				is_safe = false;
				break;
			}			
		}

		if ( is_safe )
		{
			timer++;
		}
		else
		{
			timer = 0;
		}

		wait 0.5;
	}

	self delete();
}

defuse_score()
{
	while( level.defuse_count != 0 )
	{
		flag_wait( "defuse_update_score" );
		flag_clear( "defuse_update_score" );
	}

	wait 2;
	flag_set( "defuse_complete" );
}

/****** no score ******
defuse_score( start_flag )
{
	defuse_score_text = so_create_hud_item( 3, -62, &"SO_DEFUSE_FAVELA_ESCAPE_SCORE" );
	defuse_score = so_create_hud_item( 3, -4 );
	defuse_score.label = "";

	defuse_score_text set_hudelem_blue();
	defuse_score set_hudelem_blue();
	flag_wait( start_flag );

	defuse_score_text set_hudelem_green();
	defuse_score set_hudelem_green();
	defuse_score.label = level.defuse_score;

	level thread defuse_score_cleanup( defuse_score_text, defuse_score );

//	Objective_Add( 0, "current", &"SO_DEFUSE_FAVELA_ESCAPE_OBJ_REGULAR" );
//	Objective_String( 0, &"SO_DEFUSE_FAVELA_ESCAPE_OBJ_REGULAR", 3 );

	while( true  )
	{
		flag_wait( "defuse_update_score" );
		waittillframeend;

		added_score = 0;
		foreach( player in level.players )
			added_score += player calculate_kill_score();

		flag_clear( "defuse_update_score" );

		level.defuse_score += added_score;
		defuse_score.label = level.defuse_score;

		if ( level.defuse_count == 0 )
			break;
	}

//	objective_state( 0, "done" );

	// award score based on time remaining;
	time_elapsed = ( gettime() - level.challenge_start_time ) / 1000;
	remaining_time = level.challenge_time_limit - time_elapsed;

	time_score = floor( remaining_time * 100 );

	level.defuse_score += time_score;
	defuse_score.label = level.defuse_score;

	bonus_msg = maps\_specialops::so_create_hud_item( 2, 0, &"SO_DEFUSE_FAVELA_ESCAPE_SCORE_BONUS" );
	bonus_msg SetPulseFX( 60, 3 * 1000, 500 );

	wait 6;

	flag_set( "defuse_complete" );

	bonus_msg Destroy();
	defuse_score_text Destroy();
	defuse_score Destroy();
}

defuse_score_cleanup( defuse_score_text, defuse_score )
{
	flag_wait( "challenge_timer_expired" );

	defuse_score_text Destroy();
	defuse_score Destroy();
}

calculate_kill_score()
{
	flash = self.defuse_flashed_kills * 3;
	frag = self.defuse_frag_kills;
	knife = self.defuse_knife_kills * 3;
	multiple = self.defuse_kills * self.defuse_kills;

	self player_defuse_kill_clear();

	score = ( flash + frag + knife + multiple ) * 100;
	return score;
}
*/

ai_on_death()
{
	self waittill( "death", attacker, cause );

	if ( !isplayer( attacker ) )
		return;

	attacker.defuse_kills++;
	if ( self isFlashed() )
		attacker.defuse_flashed_kills++;
	if ( common_scripts\_destructible::getDamageType( cause ) == "splash" )	
		attacker.defuse_frag_kills++;
	if ( common_scripts\_destructible::getDamageType( cause ) == "melee" )	
		attacker.defuse_knife_kills++;

	flag_set( "defuse_update_score" );
}

player_defuse_kill_clear()
{
	self.defuse_kills = 0;
	self.defuse_flashed_kills = 0;
	self.defuse_frag_kills = 0;
	self.defuse_knife_kills = 0;
}

briefcase_defuse( briefcase )
{
	// link player
	self playerLinkTo( briefcase );
	self PlayerLinkedOffsetEnable();

	// get current weapon?
	lastWeapon = self getCurrentWeapon();

	// give briefcase weapon
	self giveWeapon( "briefcase_bomb_defuse_sp" );
	self setWeaponAmmoStock( "briefcase_bomb_defuse_sp", 0 );
	self setWeaponAmmoClip( "briefcase_bomb_defuse_sp", 0 );
	self switchToWeapon( "briefcase_bomb_defuse_sp" );

	self thread downed_while_defusing( lastWeapon, briefcase );

	self waittill_either( "coop_downed", "weapon_change" );

	if ( !self ent_flag( "coop_downed" ) )
	{
		// add 3d person briefcase
		self attach_briefcase_model();

		if ( !self ent_flag( "coop_downed" ) )
		{
			self DisableWeaponSwitch();
	
			// display usebar
			if ( self defuse_use_bar( 4.5, briefcase ) )
			{
				briefcase ent_flag_set( "briefcase_bomb_defused" );
			}
		
			// remove 3d person briefcase
			self thread detach_briefcase_model();
	
			self EnableWeaponSwitch();		
		}
	}

	// switch back to lastWeapon
	self switchToWeapon( lastWeapon );
	self unlink();
}

downed_while_defusing( lastWeapon, briefcase )
{
	briefcase endon( "briefcase_bomb_defused" );
	self ent_flag_wait( "coop_downed" );

	self SwitchToWeaponImmediate( lastWeapon );
}

defuse_use_bar( fill_time, briefcase )
{
	if ( !isdefined( briefcase.defuse_time ) )
	{
		briefcase.defuse_time = 0;
	}

	buttonTime = briefcase.defuse_time;
	totalTime = fill_time;
	bar = self createClientProgressBar( self );

    text = self createClientFontString( "default", 1.2 );
    text setPoint( "CENTER", undefined, 0, 20 ); //45
	text settext( &"SO_DEFUSE_FAVELA_ESCAPE_DEFUSING" );

	while ( self UseButtonPressed() && !self ent_flag( "coop_downed" ) )
	{
		bar updateBar( buttonTime / totalTime );
		wait( 0.05 );
		buttonTime += 0.05;
		if ( buttonTime > totalTime )
		{
			text destroyElem();
			bar destroyElem();
			return true;
		}
	}

	briefcase.defuse_time = buttonTime;
	text destroyElem();
	bar destroyElem();

	return false;
}

attach_briefcase_model()
{
	wait ( 0.6 );
	self attach( "prop_suitcase_bomb", "tag_inhand", true );
}


detach_briefcase_model()
{
	self detach( "prop_suitcase_bomb", "tag_inhand", true );
}

/*
 TODO
  - less enemies. - DONE
  - half enemies for single - DONE
  - guns and grenades etc around spawn point and each bomb point. - DONE
  - countdown + addtime for each defused bomb - DONE
  - give points for each kill. - DONE
  - reward score based on time left - DONE
  - add other enemy types - DONE
  - cansel defuse if releasing use button. - DONE
  - activate in menu.
*/