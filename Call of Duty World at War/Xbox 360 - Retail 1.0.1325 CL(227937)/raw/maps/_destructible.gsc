#include maps\_utility;
#include common_scripts\utility;
#using_animtree( "vehicles" );
main()
{
//	/#
//	if ( getdvar( "debug_destructibles" ) == "" )
//		setdvar( "debug_destructibles", "0" );
//	if ( getdvar( "destructibles_enable_physics" ) == "" )
//		setdvar( "destructibles_enable_physics", "1" );
//	#/
	
//	level.destructibleSpawnedEntsLimit = 50;
//	level.destructibleSpawnedEnts = [];
	
	PrecacheRumble( "explosion_generic" );
	
	find_destructibles();
}

find_destructibles()
{
	// -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- - 
	// Find all destructibles by their targetnames and run the setup
	// -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- - 
	array_thread( getentarray( "destructible", "targetname" ), ::setup_destructibles );
}

// CODER_MOD (1/4/08): JamesS - added support for the new type of destructibles that are setup in the GDT
do_explosion()
{
	self useanimtree( #animtree );
	self.exploded = false;
	preexplode_fx_played = false;
	
	for( ;; )
	{
		self waittill( "damage", damage, attacker, direction_vec, point, type, modelName, tagName );

		if( IsPlayer( attacker ) )
		{
			self.player_damage += damage;
		}
		else
		{
			if( attacker != self )
			{
				self.non_player_damage += damage;
			}
		}
		
		if( self.health <= 200 && !self.exploded )
		{
			
			timer = GetTime() + 5000;
			while( self.health > 0 && GetTime() < timer )
			{
				if( IsDefined( level._effect[self.destructibledef + "_preexplode"] ) && !preexplode_fx_played )
				{
					Playfx( level._effect[self.destructibledef + "_preexplode"], self GetTagOrigin( "hood_jnt" ) );	
					preexplode_fx_played = true;
				}

				wait( 0.2 );
			}

			animation = [[level.destructible_pointers["explosion_anim_" + self.destructibledef]]]();
			self ClearAnim( %root, 0 );
			self SetAnimKnob( animation, 1.0, 1.0, 1.0 );
			
			level thread do_explosion_sound( self.origin );

			if( isdefined( level.vehicle_death_earthquake[ self.destructibledef ] ) )
			earthquake
			( 
				level.vehicle_death_earthquake[ self.destructibledef ].scale, 
				level.vehicle_death_earthquake[ self.destructibledef ].duration, 
				self.origin, 
				level.vehicle_death_earthquake[ self.destructibledef ].radius
			 );
			
			PlayRumbleOnPosition( "explosion_generic", self.origin ); 
			
			self kill_damage( self.destructibledef, attacker );
			
			self.exploded = true;
			
			// CODER MOD: TOMMY K - 07/08/08
			if( arcadeMode_car_kill() && IsPlayer( attacker ) )
			{
				// CODER MOD: TOMMY K - 07/30/08
				arcademode_assignpoints( "arcademode_score_vehicle", attacker );
			}
			
			break;
			
		}
		else
		{
			// if you keep shooting the tires or mirrors, give the vehicle back it's health
			if (IsSubStr( modelName , "_tire" ) || IsSubStr( modelName , "sidemirror" ))
			{
				self.health = self.health + damage;
			}
		}
	}

	self notify( "destroyed" );
}


do_explosion_sound( sound_orig )
{
	temp_org = spawn( "script_origin", sound_orig );
	temp_org playsound( "explo_metal_rand", "explo_metal_rand_done" );
	
	temp_org waittill( "explo_metal_rand_done" );
	
	temp_org delete();
}


do_flat_tires()
{
	self useanimtree( #animtree );
	for( ;; )
	{
		self waittill( "broken", broken_notify );

		animation = [[level.destructible_pointers["flattire_anim_" + self.destructibledef]]]( broken_notify );
		self SetAnim( animation );
	}
}

setup_destructibles()
{
	// -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- - 
	// Figure out what destructible information this entity should use
	// -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- - 
	if( isdefined( self.destructibledef ) )
	{
		if( self.destructibledef == "dest_type95scoutcar"		 ||
				self.destructibledef == "dest_beetle"    		 ||
				self.destructibledef == "dest_horch1a"    		 ||
				self.destructibledef == "dest_mercedesw136"   	 ||
				self.destructibledef == "dest_mercedesw136b"   	 ||
				self.destructibledef == "dest_opel_blitz"   	 ||
				self.destructibledef == "dest_bmwmotorcycle"     ||
				self.destructibledef == "dest_type94truck"		 ||
				self.destructibledef == "dest_type94truckcamo" )
		{
/#
			if( !IsDefined( level.destructible_pointers_inited ) || !IsDefined( level.destructible_pointers_inited[self.destructibledef] ) )
			{
				temp_def = "";
				for( i = 5; i < self.destructibledef.size; i++ )
				{
					temp_def = temp_def + self.destructibledef[i];
				}
				ASSERTMSG( "You have not initialized the destructible script for \"" + self.destructibledef + "\" -- It'd be something like: maps\\_destructible_" + temp_def + "::init(); before _load::main() in your level script." );
				return;
			}
#/

//			level._effect["dest_car_preexplode"] = loadfx("destructibles/fx_dest_fire_car_fade_40");

//			// special fire for type94
//			if( self.destructibledef == "dest_type94truck" )
//			{
//				level._effect["dest_type94_preexplode"] = loadfx("vehicle/vfire/fx_vfire_t94_truck_engine");
//			}

			self add_damage_owner_recorder();
			self thread do_explosion();
			self thread do_flat_tires();
		}
		return;
	}
}

add_damage_owner_recorder()
{
	// Mackey added to track who is damaging the car
	self.player_damage = 0;
	self.non_player_damage = 0;
	
	self.car_damage_owner_recorder = true;
}

arcadeMode_car_kill()
{
	if( !arcadeMode() )
	{
		return false;
	}

	if( isdefined( level.allCarsDamagedByPlayer ) )
	{
		return true;
	}
		
	return self maps\_gameskill::player_did_most_damage();
}

// The following are called from the specific destructible utility scripts
set_function_pointer( type, def, func )
{
	if( !IsDefined( level.destructible_pointers ) )
	{
		level.destructible_pointers = [];
	}

/#
	if( !IsDefined( level.destructible_pointers_inited ) )
	{
		level.destructible_pointers_inited = [];
	}	

	if( !IsDefined( level.destructible_pointers_inited[def] ) )
	{
		level.destructible_pointers_inited[def] = true;
	}
#/

	level.destructible_pointers[type + "_" + def] = func;
}

set_pre_explosion( def, fx )
{
	level._effect[def + "_preexplode"] = LoadFx( fx );
}


// guzzo 5-22-08 - modified from _vehicle to work with destructible types
build_destructible_radiusdamage( destructibledef, offset, range, maxdamage, mindamage, bKillplayer )
{
	if( !isdefined( level.destructible_death_radiusdamage ) )
		level.destructible_death_radiusdamage = []; 
	if( !isdefined( bKillplayer ) )
		bKillplayer = false; 
	if( !isdefined( offset ) )
		offset = ( 0, 0, 0 );
	struct = spawnstruct();
	struct.offset = offset; 
	struct.range = range; 
	struct.maxdamage = maxdamage; 
	struct.mindamage = mindamage; 
	struct.bKillplayer = bKillplayer; 
	level.destructible_death_radiusdamage[ destructibledef ] = struct; 
}


// guzzo 5-22-08 - modified from _vehicle to work with destructible types
kill_damage( destructibledef, attacker )
{
	if( isdefined( level.destructible_death_radiusdamage ) && isdefined( level.destructible_death_radiusdamage[ destructibledef ] ) )
	{
		offset = level.destructible_death_radiusdamage[ destructibledef ].offset;
		range = level.destructible_death_radiusdamage[ destructibledef ].range;
		maxdamage = level.destructible_death_radiusdamage[ destructibledef ].maxdamage;
		mindamage = level.destructible_death_radiusdamage[ destructibledef ].mindamage;
		bKillplayer = level.destructible_death_radiusdamage[ destructibledef ].bKillplayer;		
	}
	else
	{
		println( "build_destructible_radiusdamage() was not called in the util script for destructible: " + destructibledef + ". using default values" );
		
		// values taken from previous radiusDamage() call in do_explosion()
		offset = (0,0,0);
		range = 128;
		maxdamage = 20000; // these need to be high in order for the vehicle to blow up; its health is usually around 10000
		mindamage = 20000;
		bKillplayer = true;
	}

	if( bKillplayer )
	{
		players = get_players();
		for (i = 0; i < players.size; i++)
		{
			players[i] enableHealthShield( false );
		}
	}
	
	// 7/2/08 - switch the order to do the big damage on the destructible first
	// so that only one destructible damage event is sent across the network - JRS
	// damage to the destructible
	self dodamage( 20000, self.origin + offset, attacker );
	
	// damage to the player
	if( !isDefined( attacker ) )
	{
		attacker = self;
	}

	attacker.car_explosion = 1;
	radiusDamage( self.origin + offset, range, maxdamage, mindamage, attacker );
	
	// damage for player
	if( bKillplayer )
	{
		players = get_players();
		for (i = 0; i < players.size; i++)
		{
			players[i] enableHealthShield( true );
		}
	}
	
	wait 0.05;
	attacker.car_explosion = undefined;
}


build_destructible_deathquake( destructible_def, scale, duration, radius )
{
	
	if( !isdefined( level.vehicle_death_earthquake ) )
	{
		level.vehicle_death_earthquake = []; 	
	}
	
	level.vehicle_death_earthquake[ destructible_def ] = spawnstruct();
	
	level.vehicle_death_earthquake[ destructible_def ].scale = scale; 
	level.vehicle_death_earthquake[ destructible_def ].duration = duration; 
	level.vehicle_death_earthquake[ destructible_def ].radius = radius; 
	
}
