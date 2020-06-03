#include maps\_utility; 
#include common_scripts\utility; 

/*
init_ai_supplements()
{
	level.ai_supplements_settings = [];

	level.ai_supplements_settings[0] = SpawnStruct();
	level.ai_supplements_settings[1] = SpawnStruct();
	level.ai_supplements_settings[2] = SpawnStruct();
	level.ai_supplements_settings[3] = SpawnStruct();

	level.ai_supplements_settings[0].extra_standard_min = 0;
	level.ai_supplements_settings[0].extra_banzai_min = 0;
	level.ai_supplements_settings[0].extra_grenadesuicide_min = 0;

	level.ai_supplements_settings[1].extra_standard_min = 0;
	level.ai_supplements_settings[1].extra_banzai_min = 0;
	level.ai_supplements_settings[1].extra_grenadesuicide_min = 0;

	level.ai_supplements_settings[2].extra_standard_min = 0;
	level.ai_supplements_settings[2].extra_banzai_min = 0;
	level.ai_supplements_settings[2].extra_grenadesuicide_min = 0;

	level.ai_supplements_settings[3].extra_standard_min = 0;
	level.ai_supplements_settings[3].extra_banzai_min = 0;
	level.ai_supplements_settings[3].extra_grenadesuicide_min = 0;

	level.extra_standard_current = 0;
	level.extra_banzai_current = 0;
	level.extra_grenadesuicide_current = 0;

	level.extra_standard_queue = 0;
	level.extra_banzai_queue = 0;
	level.extra_grenadesuicide_queue = 0;

	level.last_ais_spawners = [];

	level.ais_possesion_mode = 0;

	precacheshader( "hud_grenadethrowback" );

	level thread ai_supplements_think();
	level thread display_ai_supplements_menu();
}

add_ai_supplements( player_count, num_standard, num_banzai, num_grenadesuicide, num_treesniper )
{
	if( get_players().size == player_count )
	{
		if( isdefined( num_standard ) )
		{
			level.extra_standard_queue += num_standard;
		}
		if( isdefined( num_banzai ) )
		{
			level.extra_banzai_queue += num_banzai;
		}
		if( isdefined( num_grenadesuicide ) )
		{
			level.extra_grenadesuicide_queue += num_grenadesuicide;
		}
	}
}

set_ai_supplements( player_count, num_standard, num_banzai, num_grenadesuicide, num_treesniper )
{
	if( get_players().size == player_count )
	{
		if( isdefined( num_standard ) )
		{
			level.extra_standard_queue = num_standard;
		}
		if( isdefined( num_banzai ) )
		{
			level.extra_banzai_queue = num_banzai;
		}
		if( isdefined( num_grenadesuicide ) )
		{
			level.extra_grenadesuicide_queue = num_grenadesuicide;
		}
	}
}

score_spawner( spawner, type, enemy_origins )
{
	score = 10;
	
	// if ais_count is set to -1 that means it was really close at one point and is now considered invalid to use
	if( isdefined(spawner.ais_count) && spawner.ais_count == -1 )
	{
		return -1;
	}

	players = get_players();

	// distance check
	closest_dist2 = 1000000;
	for( i = 0; i < players.size; i++ )
	{
		dist2 = DistanceSquared( players[i].origin, spawner.origin );
		if( dist2 < closest_dist2 )
		{
			closest_dist2 = dist2;
		}
	}

	if( closest_dist2 < 420 * 420 )
	{
		spawner.ais_count = -1;		// disable this spawner from ever getting used for ais
		return -1;
	}

	// prefer spawning guys in front of the players
	start = spawner.origin + (0,0,50);
	for( i = 0; i < players.size; i++ )
	{
		forward = anglestoforward( players[i] getplayerangles() );

		dir_to_spawner = vectornormalize( spawner.origin - players[i].origin );

		dot = vectordot( forward, dir_to_spawner );

		if( dot > 0.707 )		// .707 is cos 45' - so if they are roughly within view we need to do a sight check
		{
			end = players[i].origin + (0,0,50);
			wait 0.05;
			if( SightTracePassed( start, end, false, undefined ) )
			{
				return -1;
			}
		}

		score += dot * 100;
	}

	wait 0.05;

	// make sure we spawn close to our team but not too close
	closest_enemy2 = 700 * 700;
	for( i = 0; i < enemy_origins.size; i++ )
	{
		dist2 = DistanceSquared( spawner.origin, enemy_origins[i] );
		if( dist2 < 40*40 )
		{
			return -1;
		}
		else if( dist2 < closest_enemy2 )
		{
			closest_enemy2 = dist2;
		}
	}

	if( closest_enemy2 == 700 * 700 )
	{
		return -1;
	}

	if( type == "banzai" || type == "grenadesuicide" )
	{
		foundpath = findpath( spawner.origin, players[0].origin );
		if( !foundpath )
		{
			return -1;
		}
	}
	
	max_extra_score_dist2 = 2000*2000;
	if( closest_dist2 < max_extra_score_dist2 )
	{
		score += 150 * (1 - closest_dist2/max_extra_score_dist2);
	}
	else
	{
		return -1;
	}

	wait 0.05;

	// prefer spawns further away from the previous spawns
	for( i = 0; i < level.last_ais_spawners.size; i++ )
	{
		if( isdefined(level.last_ais_spawners[i]) )
		{
			dist2 = DistanceSquared( spawner.origin, level.last_ais_spawners[i].origin );
			if( dist2 < 250*250 )
			{
				score += 50 * ( dist2/(250*250) );
			}
			else
			{
				score += 50;
			}
		}
	}

	// try not to use ones that have been used before
	if( isdefined(spawner.ais_count) )
	{
		used_reduction = 20 * spawner.ais_count;
		if( used_reduction > 50 )
			used_reduction = 50;
		score -= used_reduction;
	}

	return score;
}

need_more_enemies_of_type( type, settings_index )
{
	if( type == "standard" )
	{
		add_to_queue = level.ai_supplements_settings[settings_index].extra_standard_min - level.extra_standard_current - level.extra_standard_queue;
		if( add_to_queue > 0 )
		{
			level.extra_standard_queue += add_to_queue;
		}
		return level.extra_standard_queue;
	}
	else if( type == "banzai" )
	{
		add_to_queue = level.ai_supplements_settings[settings_index].extra_banzai_min - level.extra_banzai_current - level.extra_banzai_queue;
		if( !isdefined(anim.banzai_run) )
		{
			return 0;
		}
		else if( add_to_queue > 0 )
		{
			level.extra_banzai_queue += add_to_queue;
		}
		return level.extra_banzai_queue;
	}
	else if( type == "grenadesuicide" )
	{
		add_to_queue = level.ai_supplements_settings[settings_index].extra_grenadesuicide_min - level.extra_grenadesuicide_current - level.extra_grenadesuicide_queue;
		if( !isdefined(anim.banzai_run) )
		{
			return 0;
		}
		if( add_to_queue > 0 )
		{
			level.extra_grenadesuicide_queue += add_to_queue;
		}
		return level.extra_grenadesuicide_queue;
	}
	return 0;
}

need_more_enemies()
{
	players = get_players();
	if( isdefined( players ) )
		settings_index = players.size - 1;
	else
		settings_index = 0;
	
	types = [];
	types[0] = "standard";
	types[1] = "banzai";
	types[2] = "grenadesuicide";

	types = array_randomize( types );

	for( i = 0; i < types.size; i++ )
	{
		if( need_more_enemies_of_type( types[i], settings_index ) > 0 )
			return types[i];
	}
	
	return undefined;
}

setup_banzai( grenade_suicide )
{
	self.goalradius = 64;
	self.preCombatRunEnabled = true;
	self.pathenemyFightdist = 64;
	self.pathenemyLookahead = 64;
	self.script_goalvolume = undefined;
	self.banzai_grenadesuicide = grenade_suicide;
	self.banzai_no_wait = true;
	self.script_chance = 100;
	self setgoalentity( get_closest_player(self.origin) );
	self.script_max_banzai_distance = 500; // for random spawns, only target nearby
	self.script_banzai_within_fov = true; // for random spawns, only target players when within player's fov
	self thread maps\_banzai::banzai_force();
	self OrientMode( "face motion" );

	if( grenade_suicide )
	{
		model = animscripts\utility::getGrenadeModel();
		animscripts\combat_utility::attachGrenadeModel(model, "TAG_INHAND");
		self.hasSuicideGrenade = true;
	}
}


ais_print_3d( message )
{		
	hudelem = newHudElem();
	hudelem.alignX = "center";
	hudelem.alignY = "bottom";
	hudelem.label = message;
	hudelem.color = ( 0.7, 0.7, 0.7 );
	hudelem.fontScale = 1.2;
	hudelem.alpha = 1;
	hudelem SetWayPoint( true );
	hudelem SetTargetEnt( self );

	self waittill( "death" );

	hudelem destroy();
}

can_see_a_player( start )
{
	start += (0,0,50);
	players = get_players();
	for( i = 0; i < players.size; i++ )
	{
		end = players[i].origin;
		end += (0,0,50);
		if( SightTracePassed( start, end, false, undefined ) )
		{
			return true;
		}
		wait 0.05;
	}
	return false;
}

delete_if_not_active()
{
	self endon( "death" );

	inactive_count = 0;
	for( ;; )
	{
		health = self.health;
		wait 5;
		if( health == self.health && !can_see_a_player( self.origin) )
		{
			inactive_count++;
		}
		else
		{
			inactive_count = 0;
		}
		if( inactive_count > 4 )
		{
			self Delete();
		}
	}
}

ai_supplement_tracker( type, possessed )
{
	self.ai_supplement_type = type;

	name = type;
	if( isdefined(possessed) )
	{
		name += " Poss";
	}
	else
	{
		self thread delete_if_not_active();
		if( isdefined( self.targetname ) )
		{
			self.targetname = undefined;
		}
	}

	self thread ais_print_3d( name );

	if( self.ai_supplement_type == "standard" )
	{
		level.extra_standard_current++;
		level.extra_standard_queue--;
		self waittill( "death" );
		level.extra_standard_current--;
		assert( level.extra_standard_current >= 0 ); 
	}
	else if( self.ai_supplement_type == "banzai" )
	{
		level.extra_banzai_current++;
		level.extra_banzai_queue--;
		self setup_banzai( false );
		self waittill( "death" );
		level.extra_banzai_current--;
		assert( level.extra_banzai_current >= 0 ); 
	}
	else if( self.ai_supplement_type == "grenadesuicide" )
	{
		level.extra_grenadesuicide_current++;
		level.extra_grenadesuicide_queue--;
		self setup_banzai( true );
		self waittill( "death" );

		if( isdefined(self.hasSuicideGrenade) )
		{
			grenadeOrigin = self GetTagOrigin ( "tag_inhand" );
			velocity = animscripts\combat_utility::getGrenadeDropVelocity();
			self MagicGrenadeManual( grenadeOrigin, velocity, 1 );
			self.hasSuicideGrenade = undefined;
		}

		level.extra_grenadesuicide_current--;
		assert( level.extra_grenadesuicide_current >= 0 ); 
	}
}

spawn_ai_supplement( type )
{
	count = self.count;
	goal_volume = self.script_goalvolume;

	self.count = 2;	// make sure we can spawn a guy
	self.script_goalvolume = undefined;

	if( isdefined( self.script_noenemyinfo ) && isdefined( self.script_forcespawn ) )
		spawned = self stalingradSpawn( true );
	else if( isdefined( self.script_noenemyinfo ) )
		spawned = self doSpawn( true );
	else if( isdefined( self.script_forcespawn ) )
		spawned = self stalingradSpawn();
	else
		spawned = self doSpawn();

	self.count = count;
	self.script_goalvolume = goal_volume;

	if( !spawn_failed( spawned ) )
	{
		//println( "Spawned AI Supplement " + type );
		spawned thread ai_supplement_tracker( type );
	}

	if( isdefined(self.ais_count) )
	{
		self.ais_count++;
	}
	else
	{
		self.ais_count = 1;
	}

	if( level.last_ais_spawners.size == 2 )
	{
		level.last_ais_spawners[0] = level.last_ais_spawners[1];
		level.last_ais_spawners[1] = self;
	}
	else
	{
		level.last_ais_spawners[level.last_ais_spawners.size] = self;
	}
}

ok_to_possess( guy )
{
	if( isdefined(guy.magic_bullet_shield) || guy animscripts\utility::is_banzai() || isdefined(guy GetTurret()) )
	{
		return 0;
	}

	if( isdefined(guy.animname) || isdefined(guy.deathanim) )
	{
		return 0;
	}
	
	if( !findpath( guy.origin, get_players()[0].origin ) )
	{
		return 0;
	}

	return 1;
}

/*
is_valid_spawner( spawner, type )
{
	if( isdefined( spawner ) )
	{
		if (issubstr(spawner.classname, "jap") || issubstr(spawner.classname, "ger"))
		{
			// spawner.count is 1 then this spawner most likely hasn't been used yet
			if( spawner.count == 0 )
			{
				return true;
			}
		}
	}
	return false;
}
*/

is_valid_spawner( spawner, type )
{
	if( isdefined( spawner ) && isdefined(spawner.tosser) )
	{
		spawnerType = spawner.tosser;
		if( spawnerType == "banzai" )
		{
			if( type == spawnerType )
			{
				return true;
			}
		}
		else if( spawnerType == "grenadesuicide" )
		{
			if( type == spawnerType )
			{
				return true;
			}
		}
		else if( spawnerType == "standard" )
		{
			if( type == spawnerType )
			{
				return true;
			}
		}
		else
		{
			return true;
		}
	}
	return false;
}

ai_supplements_think()
{
	level waittill( "first_player_ready" );

	for( ;; )
	{
		wait 1;
		
		type = need_more_enemies();
		if( !isdefined(type) )
		{
			continue;
		}

		wait 0.05;
		aiarray = GetAIArray( "axis" );

		if( level.ais_possesion_mode == 1 && type != "standard" )
		{
			//aiarray = randomize_array( aiarray );
			for( i = 0; i < aiarray.size; i++ )
			{
				if( ok_to_possess( aiarray[i] ) )
				{
					aiarray[i] thread ai_supplement_tracker( type, 1 );
					break;
				}
				wait 0.05;
			}
			continue;
		}

		if( aiarray.size < 3 )
		{
			continue;
		}

		enemy_origins = [];
		for( i = 0; i < aiarray.size; i++ )
		{
			if( !isdefined(aiarray[i].ai_supplement_type) )
			{
				enemy_origins[enemy_origins.size] = aiarray[i].origin;
			}
		}

		if( enemy_origins.size < 3 )
		{
			continue;
		}
	
		spawners = getspawnerarray();
		best_spawner_score = 0;
		best_spawner = undefined;

		// if we made it through, find any enemy spawner and use him
		for (i = 0; i < spawners.size; i++)
		{
			spawner = spawners[i];
			if( is_valid_spawner( spawner, type ) )
			{
				score = score_spawner( spawner, type, enemy_origins );
				//print3d( spawner.origin + (0,0,50), "Score: " + score, (1,1,1), 1, 1, 200 );
				if( score > best_spawner_score )
				{
					best_spawner_score = score;
					best_spawner = spawner;
				}
			}
		}

		if( isdefined( best_spawner ) )
		{
			best_spawner spawn_ai_supplement( type );
			//up = (0,0,70);
			//line( get_players()[0].origin + up, best_spawner.origin + up, (0,1,0), false, 6000 );
			//print3d( best_spawner.origin + (0,0,60), "Winner", (0,1,0), 1, 1, 200 );
			wait 1;
		}
	}
}



display_ai_supplements_menu()
{
	/#
	if( getdebugdvar( "debug_ai_supplement" ) == "" )
		setdvar( "debug_ai_supplement", "0" );
	#/

	for ( ;; )
	{
		if ( getdvarInt( "debug_ai_supplement" ) )
		{
			wait .5;
			setdvar( "debug_ai_supplement", 0 );
			setsaveddvar( "hud_drawhud", 1 );
			display_ai_supplements();
		}
		wait( 0.05 );
	}
}

add_to_max_aisupplements( type, settings_index, incr )
{
	if( type == 0 )
	{
		level.ai_supplements_settings[settings_index].extra_standard_min += incr;
		if( level.ai_supplements_settings[settings_index].extra_standard_min < 0 )
		{
			level.ai_supplements_settings[settings_index].extra_standard_min = 0;
		}
	}
	else if( type == 1 )
	{
		level.ai_supplements_settings[settings_index].extra_banzai_min += incr;
		if( level.ai_supplements_settings[settings_index].extra_banzai_min < 0 )
		{
			level.ai_supplements_settings[settings_index].extra_banzai_min = 0;
		}
	}
	else if( type == 2 )
	{
		level.ai_supplements_settings[settings_index].extra_grenadesuicide_min += incr;
		if( level.ai_supplements_settings[settings_index].extra_grenadesuicide_min < 0 )
		{
			level.ai_supplements_settings[settings_index].extra_grenadesuicide_min = 0;
		}
	}
	else if( type == 3 )
	{
		level.extra_standard_queue += incr;
		if( level.extra_standard_queue < 0 )
		{
			level.extra_standard_queue = 0;
		}
	}
	else if( type == 4 )
	{
		level.extra_banzai_queue += incr;
		if( level.extra_banzai_queue < 0 )
		{
			level.extra_banzai_queue = 0;
		}
	}
	else if( type == 5 )
	{
		level.extra_grenadesuicide_queue += incr;
		if( level.extra_grenadesuicide_queue < 0 )
		{
			level.extra_grenadesuicide_queue = 0;
		}
	}
	else if( type == 6 )
	{
		if( level.ais_possesion_mode == 0 )
		{
			level.ais_possesion_mode = 1;
		}
		else
		{
			level.ais_possesion_mode = 0;
		}
	}
}


create_ais_hudelem( message, index )
{
	hudelem = newHudElem();
	hudelem.alignX = "left";
	hudelem.alignY = "middle";
	hudelem.x = 0;
	hudelem.y = 83 + index * 18;
	hudelem.label = message;
	hudelem.alpha = 0;
	hudelem.color = ( 0.7, 0.7, 0.7 );

	hudelem.fontScale = 1.7;
	hudelem fadeOverTime( 0.5 );
	hudelem.alpha = 1;
	return hudelem;
}

display_ai_supplements()
{
	title = create_ais_hudelem( "    AI Supplementals", 0 );

	elems = [];
	elems[0] = create_ais_hudelem( "", 1 );
	elems[1] = create_ais_hudelem( "", 2 );
	elems[2] = create_ais_hudelem( "", 3 );
	elems[3] = create_ais_hudelem( "", 4 );
	elems[4] = create_ais_hudelem( "", 5 );
	elems[5] = create_ais_hudelem( "", 6 );
	elems[6] = create_ais_hudelem( "", 7 );
	elems[7] = create_ais_hudelem( "Exit Menu", 8 );

	selected = 0;
	
	up_pressed = false;
	down_pressed = false;
	right_pressed = false;
	left_pressed = false;
	
	for ( ;; )
	{	
		players = get_players();
		if( isdefined( players ) )
			settings_index = players.size - 1;
		else
			settings_index = 0;

		for ( i = 0; i < 8; i++ )
		{
			elems[ i ].color = ( 0.7, 0.7, 0.7 );
		}
		elems[0].label = "Min Standard: " + level.ai_supplements_settings[settings_index].extra_standard_min + "  Cur: " + level.extra_standard_current;
		elems[1].label = "Min BanzaiCh: " + level.ai_supplements_settings[settings_index].extra_banzai_min + "  Cur: " + level.extra_banzai_current;
		elems[2].label = "Min GrenSuic: " + level.ai_supplements_settings[settings_index].extra_grenadesuicide_min + "  Cur: " + level.extra_grenadesuicide_current;
		elems[3].label = "Queue Standard: " + level.extra_standard_queue;
		elems[4].label = "Queue BanzaiCh: " + level.extra_banzai_queue;
		elems[5].label = "Queue GrenSuic: " + level.extra_grenadesuicide_queue;
		elems[6].label = "Possesion: " + level.ais_possesion_mode;
	
		elems[ selected ].color = ( 1, 1, 0 );

		if ( !up_pressed )
		{
			if ( players[0] buttonPressed( "UPARROW" ) || players[0] buttonPressed( "DPAD_UP" ) )
			{
				up_pressed = true;
				selected--;
			}
		}
		else
		{
			if ( !players[0] buttonPressed( "UPARROW" ) && !players[0] buttonPressed( "DPAD_UP" ) )
				up_pressed = false;
		}
		if ( !down_pressed )
		{
			if ( players[0] buttonPressed( "DOWNARROW" ) || players[0] buttonPressed( "DPAD_DOWN" ) )
			{
				down_pressed = true;
				selected++;
			}
		}
		else
		{
			if ( !players[0] buttonPressed( "DOWNARROW" ) && !players[0] buttonPressed( "DPAD_DOWN" ) )
				down_pressed = false;
		}
		if ( !left_pressed )
		{
			if ( players[0] buttonPressed( "LEFTARROW" ) || players[0] buttonPressed( "DPAD_LEFT" ) )
			{
				left_pressed = true;
				add_to_max_aisupplements( selected, settings_index, -1 );
			}
		}
		else
		{
			if ( !players[0] buttonPressed( "LEFTARROW" ) && !players[0] buttonPressed( "DPAD_LEFT" ) )
				left_pressed = false;
		}
		if ( !right_pressed )
		{
			if ( players[0] buttonPressed( "RIGHTARROW" ) || players[0] buttonPressed( "DPAD_RIGHT" ) )
			{
				right_pressed = true;
				add_to_max_aisupplements( selected, settings_index, 1 );
			}
		}
		else
		{
			if ( !players[0] buttonPressed( "RIGHTARROW" ) && !players[0] buttonPressed( "DPAD_RIGHT" )  )
				right_pressed = false;
		}

		if ( players[0] buttonPressed( "kp_enter" ) || players[0] buttonPressed( "BUTTON_A" ) || players[0] buttonPressed( "enter" ))
		{
			if ( selected == 7 )
			{
				title destroy();
				for ( i = 0; i < elems.size; i++ )
				{
					elems[ i ] destroy();
				}
				break;
			}
		}

		if( selected < 0 )
		{
			selected = 7;
		}
		else if( selected > 7 )
		{
			selected = 0;
		}
		wait( 0.05 );
	}

}
*/