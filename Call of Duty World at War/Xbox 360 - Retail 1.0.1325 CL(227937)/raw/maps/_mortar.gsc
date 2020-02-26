#include maps\_utility; 
#include common_scripts\utility; 

main()
{
}


// Sets up the mortar variables.
init_mortars()
{
	level._explosion_max_range = []; 
	level._explosion_min_range = []; 
	level._explosion_blast_radius = []; 
	level._explosion_max_damage = []; 
	level._explosion_min_damage = []; 
	level._explosion_quake_power = []; 
	level._explosion_quake_time = []; 
	level._explosion_quake_radius = []; 
	level._explosion_min_delay = [];
	level._explosion_max_delay = [];
	level._explosion_barrage_min_delay = [];
	level._explosion_barrage_max_delay = [];
	level._explosion_view_chance = [];
	level._explosion_dust_range = [];
	level._explosion_dust_name = [];
}

// Determines the range of a mortar to go off from a player.
// mortar_name - The mortar group to apply settings to
// min_range - Set the min range a mortar can explode at from a player
// max_range - Set the max range a mortar can explode at from a player
// set_default - To set the defaults (should not be used in level script)
set_mortar_range( mortar_name, min_range, max_range, set_default )
{
	// MikeD (8/13/2007): Check to see if this exists, if not, init them.
	if( !IsDefined( level._explosion_min_range ) )
	{
		init_mortars();
	}

	if( IsDefined( set_default ) && set_default ) // Set default if not already set.
	{
		if( !IsDefined( level._explosion_min_range[mortar_name] ) )
		{
			level._explosion_min_range[mortar_name] = min_range; 
		}
	
		if( !IsDefined( level._explosion_max_range[mortar_name] ) )
		{
			level._explosion_max_range[mortar_name] = max_range;
		}
	}
	else
	{
		level._explosion_min_range[mortar_name] = min_range;
		level._explosion_max_range[mortar_name] = max_range;
	}
}

// Determines the damage settings for the given mortar group
// mortar_name - The mortar group to apply settings to
// blast_radius - Set the damage radius of a explosion
// min_damage - Set the min damage to apply to the RadiusDamage() call
// max_damage - Set the max damage to apply to the RadiusDamage() call
// set_default - To set the defaults (should not be used in level script)
set_mortar_damage( mortar_name, blast_radius, min_damage, max_damage, set_default )
{
	// MikeD (8/13/2007): Check to see if this exists, if not, init them.
	if( !IsDefined( level._explosion_blast_radius ) )
	{
		init_mortars();
	}

	if( IsDefined( set_default ) && set_default ) // Set default if not already set.
	{
		if( !IsDefined( level._explosion_blast_radius[mortar_name] ) )
		{
			level._explosion_blast_radius[mortar_name] = blast_radius;
		}
	
		if( !IsDefined( level._explosion_min_damage[mortar_name] ) )
		{
			level._explosion_min_damage[mortar_name] = min_damage; 
		}
	
		if( !IsDefined( level._explosion_max_damage[mortar_name] ) )
		{
			level._explosion_max_damage[mortar_name] = max_damage;
		}
	}
	else
	{
		level._explosion_blast_radius[mortar_name] = blast_radius;
		level._explosion_min_damage[mortar_name] = min_damage; 
		level._explosion_max_damage[mortar_name] = max_damage;
	}
}

// Determines the quake settings for the given mortar group
// mortar_name - The mortar group to apply settings to
// quake_power - Set the amount of power to apply to EarthQuake()
// quake_time - Set the duration of the quake
// quake_radius - Set the radius of the quake
// set_default - To set the defaults (should not be used in level script)
set_mortar_quake( mortar_name, quake_power, quake_time, quake_radius, set_default )
{
	// MikeD (8/13/2007): Check to see if this exists, if not, init them.
	if( !IsDefined( level._explosion_quake_power ) )
	{
		init_mortars();
	}

	if( IsDefined( set_default ) && set_default ) // Set default if not already set.
	{
		if( !IsDefined( level._explosion_quake_power[mortar_name] ) )
		{
			level._explosion_quake_power[mortar_name] = quake_power; 
		}
	
		if( !IsDefined( level._explosion_quake_power[mortar_name] ) )
		{
			level._explosion_quake_time[mortar_name] = quake_time; 
		}
	
		if( !IsDefined( level._explosion_quake_radius[mortar_name] ) )
		{
			level._explosion_quake_radius[mortar_name] = quake_radius; 
		}
	}
	else
	{
		level._explosion_quake_power[mortar_name] = quake_power; 
		level._explosion_quake_time[mortar_name] = quake_time; 
		level._explosion_quake_radius[mortar_name] = quake_radius; 
	}
}

// Determines the delays for the mortars
// mortar_name - The mortar group to apply settings to
// min_delay - Set the min delay between barrages (if the barrage amount in mortar_loop is greater than 1)
// max_delay - Set the max delay between barrages (if the barrage amount in mortar_loop is greater than 1)
// barrage_min_delay - Set the min delay between each explosion within a barrage
// barrage_max_delay - Set the max delay between each explosion within a barrage
// set_default - To set the defaults (should not be used in level script)
set_mortar_delays( mortar_name, min_delay, max_delay, barrage_min_delay, barrage_max_delay, set_default )
{
	// MikeD (8/13/2007): Check to see if this exists, if not, init them.
	if( !IsDefined( level._explosion_min_delay ) )
	{
		init_mortars();
	}

	if( IsDefined( set_default ) && set_default ) // Set default if not already set.
	{
		if( !IsDefined( level._explosion_min_delay[mortar_name] ) && IsDefined( min_delay ) )
		{
			level._explosion_min_delay[mortar_name] = min_delay; 
		}
	
		if( !IsDefined( level._explosion_max_delay[mortar_name] ) && IsDefined( min_delay ) )
		{
			level._explosion_max_delay[mortar_name] = max_delay; 
		}
	
		if( !IsDefined( level._explosion_barrage_min_delay[mortar_name] ) && IsDefined( barrage_min_delay ) )
		{
			level._explosion_barrage_min_delay[mortar_name] = barrage_min_delay; 
		}
	
		if( !IsDefined( level._explosion_barrage_max_delay[mortar_name] ) && IsDefined( barrage_max_delay ) )
		{
			level._explosion_barrage_max_delay[mortar_name] = barrage_max_delay; 
		}
	}
	else
	{
		if( IsDefined( min_delay ) )
		{
			level._explosion_min_delay[mortar_name] = min_delay; 
		}
	
		if( IsDefined( min_delay ) )
		{
			level._explosion_max_delay[mortar_name] = max_delay; 
		}
	
		if( IsDefined( barrage_min_delay ) )
		{
			level._explosion_barrage_min_delay[mortar_name] = barrage_min_delay; 
		}
	
		if( IsDefined( barrage_max_delay ) )
		{
			level._explosion_barrage_max_delay[mortar_name] = barrage_max_delay; 
		}
	}
}

// Determines the "view chance" of the mortar.
// chance - Sets the chance a player will see an explosion (scale 0 - 1)
// set_default - To set the defaults (should not be used in level script)
set_mortar_chance( mortar_name, chance, set_default )
{
	if( !IsDefined( level._explosion_view_chance ) )
	{
		init_mortars();
	}

	assertex( chance <= 1, "_mortar::set_mortar_chance(), the chance parameter needs to be between 0 and 1" );

	if( IsDefined( set_default ) && set_default ) // Set default if not already set.
	{
		if( !IsDefined( level._explosion_view_chance[mortar_name] ) )
		{
			level._explosion_view_chance[mortar_name] = chance;
		}
	}
	else
	{
		level._explosion_view_chance[mortar_name] = chance;
	}
}

set_mortar_dust( mortar_name, dust_name, range )
{
	if( !IsDefined( level._explosion_dust_range ) )
	{
		init_mortars();
	}

	level._explosion_dust_name[mortar_name] = dust_name;

	if( !IsDefined( range ) )
	{
		range = 512;
	}

	level._explosion_dust_range[mortar_name] = range;
}

// REQUIRED: level._effect[mortar_name] 		 = LoadFx( ... ); 
// REQUIRED: level._effectType[mortar_name]	 = strType( "mortar", "bomb" or "artillery" )

// Allows for multiple sets of explosions in a single level
// One explosion within max_range distance goes off every( random + random ) seconds but not within min_range units of the player
// Starts on notify specified by level.explosion_start[mortar_name]
// Terminates on notify specified by level.explosion_stop[mortar_name]
// Terminate on demand by setting level._explosion_stop_barrage[mortar_name] == true, operates indefinitely by default
mortar_loop( mortar_name, barrage_amount, no_terrain )
{
	level endon( "stop_all_mortar_loops" );

	//// Safety checks
	assertex( ( IsDefined( mortar_name ) &&( mortar_name != "" ) ), "mortar_name not passed. pass in level script" ); 
	assertex( ( IsDefined( level._effect ) && IsDefined( level._effect[mortar_name] ) ), "level._effect[strMortars] not defined. define in level script" ); 

	//// Set Defaults
	last_explosion = -1; 

	set_mortar_range( mortar_name, 300, 2200, true );
	set_mortar_delays( mortar_name, 5, 7, 5, 7, true );
	set_mortar_chance( mortar_name, 0, true );
	
	if( !IsDefined( barrage_amount ) || barrage_amount < 1 )
	{
		barrage_amount = 1; 
	}
		
	if( !IsDefined( no_terrain ) ) // this allows mortar_loop to get called again and not setup any terrain related stuff
	{
		no_terrain = false; 
	}

	if( IsDefined( level._explosion_stopNotify ) && IsDefined( level._explosion_stopNotify[mortar_name] ) )
	{
		level endon( level._explosion_stopNotify[mortar_name] ); 
	}

	// for backwards compatibility
	if( !IsDefined( level._explosion_stop_barrage ) || !IsDefined( level._explosion_stop_barrage[mortar_name] ) )
	{
		level._explosion_stop_barrage[mortar_name] = false; 
	}

	//// Explosion Points
	explosion_points = [];
	explosion_points = GetEntArray( mortar_name, "targetname" );

	// MikeD (8/13/2007): Struct support
	explosion_points_structs = [];
	explosion_points_structs = getstructarray( mortar_name, "targetname" );

	// MikeD (8/13/2007): Add array to array.
	for( i = 0; i < explosion_points_structs.size; i++ )
	{
		explosion_points_structs[i].is_struct = true;
		explosion_points = add_to_array( explosion_points, explosion_points_structs[i] );
	}

	explosion_points_structs = []; // Save some variables

	//// DUST POINTS
	dust_points = [];
	if( IsDefined( level._explosion_dust_name[mortar_name] ) )
	{
		dust_name = level._explosion_dust_name[mortar_name];

		//// Explosion Points
		dust_points = GetEntArray( dust_name, "targetname" );

		// MikeD (8/13/2007): Struct support
		dust_points_structs = [];
		dust_points_structs = getstructarray( dust_name, "targetname" );

		// MikeD (8/13/2007): Add array to array.
		for( i = 0; i < dust_points_structs.size; i++ )
		{
			dust_points_structs[i].is_struct = true;
			dust_points = add_to_array( dust_points, dust_points_structs[i] );
		}

		dust_points_structs = []; // Save some variables
	}

	//// Terrain Setup
	for( i = 0; i < explosion_points.size; i++ )
	{
		if( IsDefined( explosion_points[i].target ) &&( !no_terrain ) )	//no target necessary, mortar will just play effect and sound
		{
			explosion_points[i] setup_mortar_terrain(); 
		}
	}

	//// Start Wait
	if( IsDefined( level._explosion_start_notify ) && IsDefined( level._explosion_start_notify[mortar_name] ) )
	{
		level waittill( level._explosion_start_notify[mortar_name] ); 
	}

	//// Main Loop
	while( true )
	{
		while( !level._explosion_stop_barrage[mortar_name] )
		{
			do_mortar = false;

			for( j = 0; j < barrage_amount; j++ )
			{
				// putting this here allows for updates during barrage
				max_rangeSQ = level._explosion_max_range[mortar_name] * level._explosion_max_range[mortar_name];
				min_rangeSQ = level._explosion_min_range[mortar_name] * level._explosion_min_range[mortar_name];
				random_num  = RandomInt( explosion_points.size ); 

				for( i = 0; i < explosion_points.size; i++ )
				{
					num = ( i + random_num ) % explosion_points.size; 

					do_mortar = false;
					players = get_players();
					for( q = 0; q < players.size; q++ )
					{
						dist = DistanceSquared( players[q] GetOrigin(), explosion_points[num].origin );

						if( num != last_explosion && dist < max_rangeSQ && dist > min_rangeSQ )
						{
							if( level._explosion_view_chance[mortar_name] > 0 )
							{
								if( players[q] player_view_chance( level._explosion_view_chance[mortar_name], explosion_points[num].origin ) )
								{
									do_mortar = true;
									break;
								}
								else
								{
									do_mortar = false;
								}
							}
							else
							{
								do_mortar = true;
								break;
							}
						}
						else
						{
							do_mortar = false;
						}
					}

					if( do_mortar )	
					{
						explosion_points[num] thread explosion_activate( mortar_name, undefined, undefined, undefined, undefined, undefined, undefined, dust_points ); 
						last_explosion = num; 
						break; 
					}
				}

				last_explosion = -1; 

				if( do_mortar )
				{
					if( IsDefined( level._explosion_delay ) && IsDefined( level._explosion_delay[mortar_name] ) )
					{
						wait( level._explosion_delay[mortar_name] ); 
					}
					else
					{
						wait( RandomFloatRange( level._explosion_min_delay[mortar_name], level._explosion_max_delay[mortar_name] ) ); 
					}
				}
				else // MikeD (8/16/2007): Incase we do not finish off the barrage amount equally.
				{
					j--; // MikeD (8/16/2007):  Decrease j, so we don't skip a barrage explosion.
					wait( 0.25 ); // MikeD (8/16/2007):  Incase for whatever reason there's a forever loop.
				}
			}

			if( barrage_amount > 1 )
			{
				if( IsDefined( level._explosion_barrage_delay ) && IsDefined( level._explosion_barrage_delay[mortar_name] ) )
				{
					wait( level._explosion_barrage_delay[mortar_name] ); 
				}
				else
				{
					wait( RandomFloatRange( level._explosion_barrage_min_delay[mortar_name], level._explosion_barrage_max_delay[mortar_name] ) ); 
				}
			}
		}
		wait( 0.05 ); 
	}
}

player_view_chance( view_chance, explosion_point )
{
	chance = RandomFloat( 1 );
	if( chance <= view_chance )
	{
		if( within_fov( self GetEye(), self GetPlayerAngles(), explosion_point, cos( 30 ) ) )
		{
			return true;
		}
	}

	return false;	
}

explosion_activate( mortar_name, blast_radius, min_damage, max_damage, quake_power, quake_time, quake_radius, dust_points )
{
	//// Initialize Defaults
	set_mortar_damage( mortar_name, 256, 25, 400, true );
	set_mortar_quake( mortar_name, 0.15, 2, 850, true );
	
	if( !IsDefined( blast_radius ) )
	{
		blast_radius = level._explosion_blast_radius[mortar_name]; 
	}

	if( !IsDefined( min_damage ) )
	{
		min_damage = level._explosion_min_damage[mortar_name]; 
	}

	if( !IsDefined( max_damage ) )
	{
		max_damage = level._explosion_max_damage[mortar_name]; 
	}

	if( !IsDefined( quake_power ) )
	{
		quake_power = level._explosion_quake_power[mortar_name]; 
	}

	if( !IsDefined( quake_time ) )
	{
		quake_time = level._explosion_quake_time[mortar_name]; 
	}

	if( !IsDefined( quake_radius ) )
	{
		quake_radius = level._explosion_quake_radius[mortar_name]; 
	}

	is_struct = IsDefined( self.is_struct ) && self.is_struct;
	temp_ent = undefined;
	if( is_struct )
	{
		temp_ent = Spawn( "script_origin", self.origin );
	}

	//// Incoming Sound
	if( is_struct )
	{
		temp_ent explosion_incoming( mortar_name ); 
	}
	else
	{
		self explosion_incoming( mortar_name ); 
	}

	level notify( "explosion", mortar_name ); 

	RadiusDamage( self.origin, blast_radius, max_damage, min_damage ); 

	//// Process Terrain
	if( ( IsDefined( self.has_terrain ) && self.has_terrain == true ) && ( IsDefined( self.terrain ) ) )
	{
		for( i = 0; i < self.terrain.size; i++ )
		{
			if( IsDefined( self.terrain[i] ) )
			{
				self.terrain[i] Delete(); 
			}
		}
	}
	
	if( IsDefined( self.hidden_terrain ) )
	{
		self.hidden_terrain Show(); 
	}

	self.has_terrain = false; 
	
	//// Explosion Effects
	if( is_struct )
	{
		temp_ent explosion_boom( mortar_name, quake_power, quake_time, quake_radius );
	}
	else
	{
		self explosion_boom( mortar_name, quake_power, quake_time, quake_radius );
	}

	if( IsDefined( dust_points ) && dust_points.size > 0 )
	{
		max_range = 384;
		if( IsDefined( level._explosion_dust_range ) && IsDefined( level._explosion_dust_range[mortar_name] ) )
		{
			max_range = level._explosion_dust_range[mortar_name];
		}

		for( i = 0; i < dust_points.size; i++ )
		{
			if( DistanceSquared( dust_points[i].origin, self.origin ) < max_range * max_range )
			{
				if( IsDefined( dust_points[i].script_fxid ) )
				{
					PlayFx( level._effect[dust_points[i].script_fxid], dust_points[i].origin );
				}
				else
				{
					PlayFx( level._effect[level._explosion_dust_name[mortar_name]], dust_points[i].origin );
				}
			}
		}
	} 

	if( is_struct )
	{
		temp_ent thread delete_temp_ent();
	}
}

delete_temp_ent()
{
	wait( 5 );
	self Delete();
}

explosion_boom( mortar_name, power, time, radius, is_struct )
{
	if( !IsDefined( power ) )
	{
		power = 0.15; 
	}

	if( !IsDefined( time ) )
	{
		time = 2; 
	}

	if( !IsDefined( radius ) )
	{
		radius = 850; 
	}

	if (!isdefined(is_struct))
	{
		explosion_sound( mortar_name ); 
	}
	else
	{
		temp_ent = Spawn( "script_origin", self.origin );
		temp_ent explosion_sound( mortar_name ); 
		temp_ent thread delete_temp_ent();
	}

	explosion_origin = self.origin; 

	PlayFx( level._effect[mortar_name], explosion_origin ); 
	Earthquake( power, time, explosion_origin, radius ); 
	
	thread mortar_rumble_on_all_players("damage_light","damage_heavy", explosion_origin, radius * 0.75, radius * 1.25);

	// MikeD (9/11/2007): Physic items should move.
	physRadius = radius;
	if( physRadius > 500 )
	{
		physRadius = 500;
	}
	PhysicsExplosionSphere( explosion_origin, physRadius, physRadius * 0.25, 0.75 );
	
// SCRIPTER_MOD
// MikeD (3/22/2007): No more level.player
//	if( Distance( level.player.origin, explosion_origin ) > 300 )

	players = get_players();
	player_count = 0;
	for( q = 0; q < players.size; q++ )
	{
		if( Distancesquared( players[q].origin, explosion_origin ) > 300 * 300 )
		{
			player_count++;
		}
	}

	if( player_count == players.size )
	{
		return; 
	}

// MikeD (8/13/2007): Removed hacks from CoD4
//	if( level.script == "carchase" || level.script == "breakout" )
//	{
//		return; 
//	}

	level.playerMortar = true; 		
	level notify( "shell shock player", 	time * 4 ); 

	max_damage = level._explosion_max_damage[mortar_name];
	min_damage = level._explosion_max_damage[mortar_name];
	maps\_shellshock::main( explosion_origin, time * 4, undefined, max_damage, 1, min_damage ); 
}

explosion_sound( mortar_name )
{
	if( !IsDefined( level._explosion_last_sound ) )
	{
		level._explosion_last_sound = 0; 
	}

	soundnum = RandomInt( 3 ) + 1; 
	while( soundnum == level._explosion_last_sound )
	{
		soundnum = RandomInt( 3 ) + 1; 
	}

	level._explosion_last_sound = soundnum; 

	if( level._effectType[mortar_name] == "mortar" )
	{
		switch( soundnum )
		{
		case 1:
			self PlaySound( "mortar_dirt" ); 
			break; 
		case 2:
			self PlaySound( "mortar_dirt" ); 
			break; 
		case 3:
			self PlaySound( "mortar_dirt" ); 
			break; 
		}
	}
	if( level._effectType[mortar_name] == "mortar_water" )
	{
		switch( soundnum )
		{
		case 1:
			self PlaySound( "mortar_impact_water" ); 
			break; 
		case 2:
			self PlaySound( "mortar_impact_water" ); 
			break; 
		case 3:
			self PlaySound( "mortar_impact_water" ); 
			break; 
		}
	}
	else if( level._effectType[mortar_name] == "artillery" )
	{
		switch( soundnum )
		{
		case 1:
			self PlaySound( "mortar_explosion4" ); 
			break; 
		case 2:
			self PlaySound( "mortar_explosion5" ); 
			break; 
		case 3:
			self PlaySound( "mortar_explosion1" ); 
			break; 
		}
	}
	else if( level._effectType[mortar_name] == "bomb" )
	{
		switch( soundnum )
		{
		case 1:
			self PlaySound( "mortar_explosion1" ); 
			break; 
		case 2:
			self PlaySound( "mortar_explosion4" ); 
			break; 
		case 3:
			self PlaySound( "mortar_explosion5" ); 
			break; 
		}
	}
}

explosion_incoming( mortar_name )
{
	if( level._effectType[mortar_name] == "mortar" )
	{
		if (!SoundExists("art_incoming"))
		{
			return;	
		}
		
		self PlaySound( "art_incoming", "sounddone" ); 
	}
	if( level._effectType[mortar_name] == "mortar_water" )
	{
		if (!SoundExists("art_incoming"))
		{
			return;	
		}
		
		self PlaySound( "art_incoming", "sounddone" ); 
	}
	else if( level._effectType[mortar_name] == "artillery" )
	{
		if (!SoundExists("art_incoming"))
		{
			return;	
		}
		
		self PlaySound( "art_incoming", "sounddone" ); 
	}
	else if( level._effectType[mortar_name] == "bomb" )
	{
		if (!SoundExists("art_incoming"))
		{
			return;	
		}
		
		self PlaySound( "art_incoming", "sounddone"); 		
	}
	// SCRIPTER_MOD: JesseS (4/15/2008): waittill the sound is done now.
	self waittill ("sounddone");
}

setup_mortar_terrain()
{
	self.has_terrain = false; 
	if( IsDefined( self.target ) )
	{
		self.terrain = GetEntArray( self.target, "targetname" ); 
		self.has_terrain = true; 
	}
	else
	{
		println( "z:          mortar entity has no target: ", self.origin ); 
	}

	if( !IsDefined( self.terrain ) )
	{
		println( "z:          mortar entity has target, but target doesnt exist: ", self.origin ); 
	}

	if( IsDefined( self.script_hidden ) )
	{
		if( IsDefined( self.script_hidden ) )
		{
			self.hidden_terrain = GetEnt( self.script_hidden, "targetname" ); 
		}
		else if( ( IsDefined( self.terrain ) ) &&( IsDefined( self.terrain[0].target ) ) )
		{
			self.hidden_terrain = GetEnt( self.terrain[0].target, "targetname" ); 
		}
		
		if( IsDefined( self.hidden_terrain ) )
		{
			self.hidden_terrain Hide(); 
		}
	}
	else if( IsDefined( self.has_terrain ) )
	{
		if( IsDefined( self.terrain ) && IsDefined( self.terrain[0].target ) )
		{
			self.hidden_terrain = GetEnt( self.terrain[0].target, "targetname" ); 
		}
		
		if( IsDefined( self.hidden_terrain ) )
		{
			self.hidden_terrain Hide(); 
		}
	}		

}

activate_mortar( range, max_damage, min_damage, quake_power, quake_time, quake_radius , bIsstruct )
{
//	if( bIsstruct )
//	{
//		if( Distance( self.origin, level.player.origin ) < 1000 )
//			incoming_sound( undefined, bIsstruct ); 
//	}
//	else
	incoming_sound( undefined, bIsstruct ); 

	level notify( "mortar" ); 
	self notify( "mortar" ); 
	

	if( !IsDefined( range ) )
	{
		range = 256; 
	}

	if( !IsDefined( max_damage ) )
	{
		max_damage = 400; 
	}

	if( !IsDefined( min_damage ) )
	{
		min_damage = 25; 
	}

	RadiusDamage( self.origin, range, max_damage, min_damage ); 

	if( ( IsDefined( self.has_terrain ) && self.has_terrain == true ) &&( IsDefined( self.terrain ) ) )
	{
		for( i = 0; i < self.terrain.size; i++ )
		{
			if( IsDefined( self.terrain[i] ) )
			{
				self.terrain[i] Delete(); 
			}
		}
	}
	
	if( IsDefined( self.hidden_terrain ) )
	{
		self.hidden_terrain Show(); 
	}
	self.has_terrain = false; 
	
	mortar_boom( self.origin, quake_power, quake_time, quake_radius , undefined, bIsstruct ); 
}

mortar_boom( origin, power, time, radius, effect, bIsstruct )
{
	if( !IsDefined( power ) )
	{
		power = 0.15; 
	}
	
	if( !IsDefined( time ) )
	{
		time = 2; 
	}

	if( !IsDefined( radius ) )
	{
		radius = 850; 
	}

	thread mortar_sound( bIsstruct ); 

	if( IsDefined( effect ) )
	{
		PlayFx( effect, origin ); 
	}
	else
	{
		PlayFx( level.mortar, origin ); 
	}
		
	Earthquake( power, time, origin, radius ); 
	thread mortar_rumble_on_all_players("damage_light","damage_heavy", origin, radius * 0.75, radius * 1.25);


	// MikeD (9/11/2007): Physic items should move.
	physRadius = radius;
	if( physRadius > 500 )
	{
		physRadius = 500;
	}
	PhysicsExplosionSphere( origin, physRadius, physRadius * 0.25, 0.75 );
	
//	waterplop(origin,4,6);
	
	if( IsDefined( level.playerMortar ) )
	{
		return; 
	}

	players = get_players(); 

// SCRIPTER_MOD
// MikeD( 3/16/200 ): No more level.player
	players = get_players();
	player_count = 0;
	for( q = 0; q < players.size; q++ )
	{
		if( Distancesquared( players[q].origin, origin ) > 300 * 300 )
	{
			player_count++;
		}
	}

	if( player_count == players.size )
	{
		return; 
	}

// MikeD( 3/16/200 ): Note, these are for rails...
	if( level.script == "carchase" || level.script == "breakout" )
	{
		return; 
	}

	level.playerMortar = true; 		
	level notify( "shell shock player", 	time*4 ); 
	maps\_shellshock::main( origin, time * 4 ); 
}

mortar_sound( bIsstruct )
{
	if( !IsDefined( level.mortar_last_sound ) )
	{
		level.mortar_last_sound = -1; 
	}

	soundnum = RandomInt( 3 ) + 1; 
	while( soundnum == level.mortar_last_sound )
	{
		soundnum = RandomInt( 3 ) + 1; 
	}

	level.mortar_last_sound	 = soundnum; 
	
	if( !bIsstruct )
	{
// SCRIPTER_MOD
// MikeD( 3/16/200 ): These sounds do not exist
//		self PlaySound( "mortar_explosion"+soundnum ); 
	}
	else
	{
		play_sound_in_space( "mortar_explosion"+soundnum, self.origin ); 
	}
}

incoming_sound( soundnum , bIsstruct )
{
	currenttime = GetTime(); 
	if( !IsDefined( level.lastmortarincomingtime ) )
	{
		level.lastmortarincomingtime = currenttime; 
	}
	else if( ( currenttime-level.lastmortarincomingtime ) < 1000 )
	{
		wait( 1 ); 
		return; 
	}
	else
	{
		level.lastmortarincomingtime = currenttime; 
	}	

	if( !IsDefined( soundnum ) )
	{
		soundnum = RandomInt( 3 ) + 1; 
	}

	if( soundnum == 1 )
	{
		if( bIsstruct )
		{
			thread play_sound_in_space( "mortar_incoming1", self.origin ); 
		}
		else
		{
// SCRIPTER_MOD
// MikeD( 3/16/200 ): These sounds do not exist
//			self PlaySound( "mortar_incoming1" ); 
		}
		wait( 1.07 - 0.25 ); 
	}
	else if( soundnum == 2 )
	{
		if( bIsstruct )
		{
			thread play_sound_in_space( "mortar_incoming2", self.origin ); 
		}
		else
		{
// SCRIPTER_MOD
// MikeD( 3/16/200 ): These sounds do not exist
//			self PlaySound( "mortar_incoming2" ); 
		}
		wait( 0.67 - 0.25 ); 
	}
	else
	{
		if( bIsstruct )
		{
			thread play_sound_in_space( "mortar_incoming3", self.origin ); 
		}
		else
		{
// SCRIPTER_MOD
// MikeD( 3/16/200 ): These sounds do not exist
//			self PlaySound( "mortar_incoming3" ); 
		}
		wait( 1.55 - 0.25 ); 
	}
}

mortar_rumble_on_all_players(high_rumble_string, low_rumble_string, rumble_org, high_rumble_range, low_rumble_range)
{
	players = get_players();
	
	for (i = 0; i < players.size; i++)
	{
		if (isdefined (high_rumble_range) && isdefined (low_rumble_range) && isdefined(rumble_org))
		{
			if (distance (players[i].origin, rumble_org) < high_rumble_range)
			{
				players[i] playrumbleonentity(high_rumble_string);
			}
			else if (distance (players[i].origin, rumble_org) < low_rumble_range)
			{
				players[i] playrumbleonentity(low_rumble_string);
			}
		}
		else
		{
			players[i] playrumbleonentity(high_rumble_string);
		}
	}
}