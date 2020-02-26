#include common_scripts\utility;
#include maps\_utility;
#include maps\_vehicle;
#include maps\_so_rts_support;
#insert raw\maps\_utility.gsh;
#insert raw\maps\_so_rts.gsh;



/////////////////////////////////////////////////////////////////////////////////////////////////////////////////
// rts.csv table column defines 
#define TABLE_DEF_CSV 				"rts.csv"
#define TABLE_IDX					0
#define TABLE_AI_REF 				1	// AI type ref... AKA the spawner dude
#define TABLE_AI_EQUIPMENT			2	// grenades/claymores/etc	
#define TABLE_AI_ARMOR				3	// armor points
#define TABLE_AI_HEALTH 			4	// AI hitpoints
#define TABLE_AI_ACCURACY 			5	// AI Accuracy
#define TABLE_AI_NAME 				6	// String name of AI
#define TABLE_AI_DESC 				7	// String description of the AI
#define TABLE_AI_INITIALIZER		8	// optinal function entity is passed into after spawn
#define TABLE_AI_SPECIES			9	// species
#define TABLE_AI_SWAP_SPAWNER		10	// optional swap spawner when player takes control
#define TABLE_AI_SWAP_NOTIFY		11	// optional swap notify sent to server level and client level
#define TABLE_AI_REGEN_RATE			12	// regeneration rate %/sec
#define TABLE_AI_VEH_SEAT			13	// seat to use if 'UseVehicle' is called on this ent

#define TABLE_AI_TYPE_INDEX_START 	0	// First index for AI Type Table
#define TABLE_AI_TYPE_INDEX_END 	30	// Last index for AI Type Table

/////////////////////////////////////////////////////////////////////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////////////////////////////////////////////////////
// CONST DEFINES
// Tweakables: Generic
#define CONST_WEAPON_DROP_RATE				1	// 0.0-1.0 rate of weapon drop when dead
#define CONST_AI_UPDATE_DELAY				4.0	// General AI update delay passed to manage_ai_relative_to_player()
#define CONST_AI_SEARCH_PLAYER_TIME			6.0	// Amount of time an ai will pole to see if it has reached the player before giving up
#define CONST_LONG_DEATH_REMOVE_DIST_MIN	540	// Min distance the closest player needs to be to allow long death force kill

	// Tweakables: Player Closest Node Tracker
#define CONST_NODE_CLOSEST_RADIUS_MIN			1		// Check for nodes closest to player greater than this distance away
#define CONST_NODE_CLOSEST_RADIUS_MAX			128		// Check for nodes closest to player less than this distance away
#define CONST_NODE_CLOSEST_RADIUS_INCREASE		64		// If a closest node check fails to find a node, increase the radius by this amount and try again
#define CONST_NODE_CLOSEST_RADIUS_INVALID		2048	// The radius max for the check for nodes should never get this big.
#define CONST_NODE_CLOSEST_HEIGHT				512		// Check for nodes closest to player within this height distance away
#define CONST_NODE_CLOSEST_HEIGHT_INCREASE		128		// If a closest node check fails to find a node, increase the height by this amount and try again
	
#define CONST_BASE_THREAT_WEIGHT				0.4
#define CONST_MAX_VISIBLE_DIST					3072
	
#define CONST_ALLIES_COVER_SEARCH_INTERVAL		10000	// 10 seconds

AI_preload()
{
	assert(isdefined( level.rts) );
	assert(isdefined( level.rts_def_table ) );
	
	
	flag_init( "aggressive_mode" );

	level.rts.boss_drop_target		= undefined;//if defined bosses will use this spot as a target to drop onto;
	level.rts.heloTargetLocations	= [];
		
	level.rts.ai 					= [];
	level.rts.ai 					= ai_type_populate();	
	
	// AI Type: Claymore Items
	PrecacheModel( "weapon_claymore" );
	level._effect[ "claymore_laser" ] 				= loadfx( "misc/claymore_laser" );
	level._effect[ "claymore_explosion" ] 			= loadfx( "weapon/satchel/fx_explosion_satchel_generic" );
	level._effect[ "claymore_disabled" ]			= loadfx( "explosions/sentry_gun_explosion" );
	
//	maps\_chopperboss::chopper_boss_load_fx();
	
}

/////////////////////////////////////////////////////////////////////////////////////////////////////
//"Name: TableLookup( <filename>, <search column num>, <search value>, <return value column num> )"
ai_exist( ref )
{
	return isdefined( level.rts.ai  ) && isdefined( level.rts.ai [ ref ] );
}
get_ai_ref_by_index( idx )
{
	return tablelookup( level.rts_def_table, TABLE_IDX, idx, TABLE_AI_REF );
}
lookup_value( ref, idx, column_index )
{
	assert( IsDefined(idx) );
	return tablelookup( level.rts_def_table, TABLE_IDX, idx, column_index );
}


// ==========================================================================
// AI INIT AND DATA TABLE POPULATION
// ==========================================================================

AI_init()
{	
	foreach ( player in GetPlayers() )
	{
		player thread update_player_closest_node_think();
	}
	
	level.rts.additional_ai_initializers	= [];
	level.rts.additional_ai_initializers["rover"] 		= ::dog_initialize;
	level.rts.additional_ai_initializers["metalstorm"] 	= ::vehicle_initialize;
	level.rts.additional_ai_initializers["quadrotor"] 	= ::vehicle_initialize;
	level.rts.additional_ai_initializers["recon"] 		= ::recon_initialize;
	
	// setup AI types and run them
	add_global_spawn_function( "axis", ::no_grenade_bag_drop );
	add_global_spawn_function( "axis", ::update_enemy_remaining );
	add_global_spawn_function( "axis", ::ai_on_long_death );
	add_global_spawn_function( "axis", ::ai_on_flashed );
	
	battlechatter_on( "allies" );
	battlechatter_on( "axis" );
	
	
	
	level.rts.ai_special_grenades = [];
	level.rts.ai_special_grenades[level.rts.ai_special_grenades.size] = "frag_grenade_future_sp";
//	level.rts.ai_special_grenades[level.rts.ai_special_grenades.size] = "concussion_grenade_future_sp";
//	level.rts.ai_special_grenades[level.rts.ai_special_grenades.size] = "flash_grenade_future_sp";
//	level.rts.ai_special_grenades[level.rts.ai_special_grenades.size] = "sticky_grenade_future_sp";
}

ai_type_populate()
{
	ai_types	= [];

	for( i = TABLE_AI_TYPE_INDEX_START; i <= TABLE_AI_TYPE_INDEX_END; i++ )
	{		
		ref = get_ai_ref_by_index( i );
		if ( !isdefined( ref ) || ref == "" )
			continue;
		
		ai 				= spawnstruct();
		ai.idx			= i;
		ai.ref			= ref;
		ai.equipment	= lookup_value( ref, i, TABLE_AI_EQUIPMENT );
		ai.armor		= int(lookup_value( ref, i, TABLE_AI_ARMOR ));
		ai.health		= int(lookup_value( ref, i, TABLE_AI_HEALTH ));
		ai.accuracy 	= float(lookup_value( ref, i, TABLE_AI_ACCURACY ));
		ai.name			= lookup_value( ref, i, TABLE_AI_NAME );
		ai.desc			= lookup_value( ref, i, TABLE_AI_DESC );
		ai.initializer	= lookup_value( ref, i, TABLE_AI_INITIALIZER ); 
		ai.species		= lookup_value( ref, i, TABLE_AI_SPECIES ); 
		ai.swap_spawner	= lookup_value( ref, i, TABLE_AI_SWAP_SPAWNER );
		ai.swap_notify	= lookup_value( ref, i, TABLE_AI_SWAP_NOTIFY );
		ai.regenrate	= float(lookup_value( ref, i, TABLE_AI_REGEN_RATE ));
		ai.seat			= int(lookup_value(ref,i,TABLE_AI_VEH_SEAT));
		
		if (ai.swap_spawner == "" )
		{
			ai.swap_spawner	= undefined;
		}
		if (ai.swap_notify == "" )
		{
			ai.swap_notify	= undefined;
		}
		ai_types[ ref ] = ai;
	}
	return ai_types;
}
// ==========================================================================
// GLOBAL AI STUFF
// ==========================================================================
update_player_closest_node_think()
{
	Assert( IsPlayer( self ), "Self should be a player in update_player_closest_node_think()" );
	
	self endon( "death" );
	level endon( "rts_terminated" );
	
	flag_wait("intro_complete");
	max_radius = CONST_NODE_CLOSEST_RADIUS_MAX;
	min_radius = CONST_NODE_CLOSEST_RADIUS_MIN;
	max_height = CONST_NODE_CLOSEST_HEIGHT;
	
	while ( 1 )
	{
		nodes = GetNodesInRadiusSorted( self.origin, max_radius, min_radius, max_height );
		if ( !IsDefined( nodes ) || !nodes.size )
		{
			max_radius += CONST_NODE_CLOSEST_RADIUS_INCREASE;
			max_height += CONST_NODE_CLOSEST_HEIGHT_INCREASE;
			
			if ( max_radius > CONST_NODE_CLOSEST_RADIUS_MAX )
				max_radius = CONST_NODE_CLOSEST_RADIUS_MAX;
			if ( max_height > CONST_NODE_CLOSEST_HEIGHT*2 )
				max_height = CONST_NODE_CLOSEST_HEIGHT*2;
			
			wait 1;
			continue;	
		}
		
		self.node_closest = nodes[0];
		
		// Rest the test case values
		max_radius = CONST_NODE_CLOSEST_RADIUS_MAX;
		min_radius = CONST_NODE_CLOSEST_RADIUS_MIN;
		max_height = CONST_NODE_CLOSEST_HEIGHT;
		
		wait 2;
	}
	
}


ai_IsSelectable(ai)
{
	if (!IS_ALIVE(ai))
		return false;
	if (!IS_TRUE(ai.rts_unloaded))
		return false;
	if (!IS_TRUE(ai.initialized))
		return false;
	if (isDefined(ai.melee))
		return false;
	if (IS_TRUE(ai.no_takeover))
		return false;
		
	return true;
}

getAIBySpecies(species,team)
{
	aiS = [];

	if(isDefined(team))
		ailist = ArrayCombine(getAIArray(team),GetVehicleArray(team), false, false);
	else
		ailist = ArrayCombine(getAIArray(),GetVehicleArray(), false, false);
	
	
	foreach(guy in ailist)
	{
		if (isDefined(guy.ai_ref) && guy.ai_ref.species == species && IS_TRUE(guy.rts_unloaded) )
		{
			aiS[aiS.size] = guy;
		}
	}
	return aiS;
}


get_war_enemies_living()
{
	enemy_array = getaiarray( "axis" );
	
	// Add non ai bosses, duplicates are removed by array_merge()
	if ( IsDefined( level.bosses ) && level.bosses.size )
		enemy_array = ArrayCombine( enemy_array, level.bosses, false, false );
		
//	enemy_array = ArrayCombine( enemy_array, dog_get_living(), false, false );
		
	return enemy_array;
}

update_enemy_remaining()
{
	level endon( "rts_terminated" );
	
	// Let the AI and vehicle spawn logic run so that 
	// the level.bosses array and the level.dogs array
	// are updated before grabbing the final ai count;
	waittillframeend;
	
	level.rts.enemy_remaining = get_war_enemies_living().size;
	level notify( "axis_spawned" );
	
	self waittill( "death" );
	
	// Again, let the level.bosses and level.dog arrays
	// get updated then update the enemy remaining
	waittillframeend;
	
	enemies_alive = get_war_enemies_living();
	
	level.rts.enemy_remaining = enemies_alive.size;
	level notify( "axis_died" );
	
	// If ai are done spawning and only one enemy is left 
	// and it's an AI that is not a dog stop long deaths
	if	( flag( "aggressive_mode" ) &&	enemies_alive.size == 1 &&	isai( enemies_alive[ 0 ] ) && enemies_alive[ 0 ].type != "dog"	)
	{
		enemies_alive[ 0 ] thread prevent_long_death();
	}
}

get_enemies_living()
{
	enemy_array = getaiarray( "axis" );
	
	// Add non ai bosses, duplicates are removed by array_merge()
	if ( IsDefined( level.rts.bosses ) && level.rts.bosses.size )
		enemy_array = ArrayCombine( enemy_array, level.rts.bosses, false, false );
		
//	enemy_array = ArrayCombine( enemy_array, dog_get_living(), false, false );
		
	return enemy_array;
}

prevent_long_death()
{
	level endon( "rts_terminated" );
	self endon( "death" );
	
	if ( !isdefined( self.a.doingLongDeath ) )
	{
		self disable_long_death();
		return;
	}
	
	// Once the players are far enough away / out of
	// site kill the ai so he doesn't hand around in
	// in long death delaying the round end
	while ( 1 )
	{
		safe_to_kill = true;
		
		foreach ( player in GetPlayers() )
		{
			player_too_close = Distance2D( player.origin, self.origin ) < CONST_LONG_DEATH_REMOVE_DIST_MIN;
			
			if ( player_too_close )
			{
				safe_to_kill = false;
				break;	
			}
			
			if ( self CanSee( player ) )
			{
				safe_to_kill = false;
				break;
			}
			
			// One trace per script update
			wait 0.05;
		}
		
		if ( safe_to_kill )
		{
			attacker = self get_last_attacker();
			
			if ( isdefined( attacker ) )
				self Kill( self.origin, attacker );
			else
				self Kill( self.origin );
			
			return;
		}

		wait 0.1;
	}
}

get_last_attacker()
{
	assert( isdefined( self ), "Self must be defined to check for last attacker." );
	
	attacker = undefined;
	
	// use the last attacker if available
	if ( isdefined( self.attacker_list ) && self.attacker_list.size )
		attacker = self.attacker_list[ self.attacker_list.size - 1 ];
		
	return attacker;
}
no_grenade_bag_drop()
{
	// every axis resets this value when spawned, am forcing this here
	level.nextGrenadeDrop	= 100000;	// no grenade bag drop!	
}
ai_on_long_death()
{
	if ( !isai( self ) || isdefined( self.type ) && self.type == "dog" )
		return;

	self endon( "death" );
	level endon( "rts_terminated" );
	
	self waittill( "long_death" );
	
	self waittill( "flashbang", amount_distance, amount_angle, attacker, attackerteam );
	
	if ( isdefined( attacker ) && isdefined( attacker.team ) && attacker.team == "allies" )
		self kill( self.origin, attacker );
}
ai_on_flashed()
{
	self endon( "death" );
	level endon( "rts_terminated" );
	
	self waittill( "flashbang", flash_origin, flash_dist, flash_angle, attacker );
	
	if ( IsDefined( attacker ) && IsPlayer( attacker ) )
	{
		attacker maps\_damagefeedback::updateDamageFeedback( );
	}
}

ai_getClassification(ai)
{
	assert(isDefined(ai.ai_ref));
	return (istring(ai.ai_ref.name));
}

ai_DeathMonitor()
{
	entNum = self GetEntityNumber();
	self waittill( "death" );
	LUINotifyEvent( &"rts_remove_ai", 1, entNum );
}


ai_Died(eInflictor, attacker, iDamage, sMeansOfDeath, sWeapon, vDir, sHitLoc, psOffsetTime )
{
	if (IS_VEHICLE(self))
	{
		self SetClientFlag(FLAG_CLIENT_FLAG_DIED_VEH);
	}
	else
	{
		self SetClientFlag(FLAG_CLIENT_FLAG_DIED);
	}
	/#
	println("@@@ AI DIED ("+(self GetEntNum())+") at "+GetTime()+" by " + (isDefined(sMeansOfDeath)?sMeansOfDeath:"unknown") + " SquadID:" + (isDefined(self.squadID)?self.squadID:"NA") + " Team: " + self.team + " Type: " + self.classname + "Weapon: " + (isDefined(sWeapon)?sWeapon:"Unk") + "Damage: " + iDamage + " Took #hits:" + (isDefined(self.hits)?self.hits:0) );
	#/
	if(sMeansOfDeath == "MOD_UNKNOWN")
	{
		i = 1;
	}
}

ai_DeathWatch( eInflictor, eAttacker, iDamage, meansOfDeath)
{
	if (meansOfDeath == "MOD_CRUSH" && isDefined(eInflictor) && eInflictor.vteam == self.team)
		return 0;

	if ( isDefined(eAttacker) && isDefined(eAttacker.team) && eAttacker.team == self.team )
		return 0;

	if ( isDefined(eInflictor) && isDefined(eInflictor.team) && eInflictor.team == self.team )
		return 0;

	if(meansOfDeath == "MOD_UNKNOWN")
	{
		i = 1;
	}
	if (self.team == "allies" )
	{
		if ( flag("rts_mode"))
		{
			iDamage = int(iDamage*level.rts.game_rules.ally_dmg_reducerRTS);
		}
		else
		if ( flag("fps_mode"))
		{
			iDamage = int(iDamage*level.rts.game_rules.ally_dmg_reducerFPS);
		}
	}
	
	
	//damaged entity is a vehicle;  player is in vehicle; 
	if (IS_VEHICLE(self) && isDefined(self.player))
	{
		/#
		println("@@@ PLAYER VEHICLE DAMAGE ENT("+(self GetEntNum())+") Type:"+meansOfDeath+" Damage: " + iDamage + " Armor Left:" + (isDefined(self.armor)?self.armor:0) + "\t Health: " + self.health +" eInflictor:"+(isDefined(eInflictor.ai_ref)?eInflictor.ai_ref.ref:"Unk"));
		#/
		if ( isDefined(eAttacker) && eAttacker == self.player )  //Player vehicle weapon has caused damage to player's vehicle. If so, zero damage out.
		{
			return 0;
		}
	}
	
	self.lastHitStamp = GetTime();
	if(!isDefined(self.hits))
		self.hits = 1;
	else
		self.hits++;
		
	if ( isDefined(self.armor)  && self.armor > 0 )
	{
		self.armor -= iDamage;
		if ( self.armor > 0 )
			iDamage = 0;
		else
		{
			iDamage = -self.armor;
			self.armor = undefined;
		}
	}

	if ( self.health > 0 )
	{
		if(isDefined(self.armor)&&self.armor > 0 )
		{
			/#
			println("@@@ AI("+(self GetEntNum())+") Damage: " + iDamage + " Armor Left:" + (isDefined(self.armor)?self.armor:0) + "\t Health: " + self.health);
			#/
		}
		if ( iDamage > self.health )
		{
			if (self.team == "allies")
			{
				if(flag("fps_mode"))
				{
					maps\_so_rts_event::trigger_event("diedfps_"+self.pkg_ref.ref);
				}
				else
				{
					maps\_so_rts_event::trigger_event("died_"+self.pkg_ref.ref);
				}
			}
		}
		else
		{
			LUINotifyEvent( &"rts_update_health", 3, self GetEntityNumber(), (self.health<0?0:self.health), self.health_max );
		}
	}
	
	return iDamage;
}

set_vehicle_damage_override()
{
	// store the original damage override
	self.overrideVehicleDamageOrig = self.overrideVehicleDamage;	
	if (IS_TRUE(level.friendlyFireDisabled))
	{
		self.friendlyfire_shield = false;	
	}
	else
	{
		self.friendlyfire_shield = true;	
	}
	// set the new override
	self.overrideVehicleDamage = ::veh_DeathWatch;
	self.callbackVehicleKilled = ::ai_Died;
	
	if (isDefined(self.overrideVehicleDamageOrig))
	{
		assert(self.overrideVehicleDamageOrig!=self.overrideVehicleDamage,"Cyclical damage callbacks");
	}
}

veh_DeathWatch( eInflictor, eAttacker, idamage, n_dflags, str_means_of_death, str_weapon, v_point, v_dir, str_hit_loc, psOffsetTime, b_damage_from_underneath, n_model_index, str_part_name )
{
	if( IsDefined( self.overrideVehicleDamageOrig ) && self.overrideVehicleDamageOrig!=::veh_DeathWatch)
		iDamage = [[ self.overrideVehicleDamageOrig ]]( eInflictor, eAttacker, idamage, n_dflags, str_means_of_death, str_weapon, v_point, v_dir, str_hit_loc, psOffsetTime, b_damage_from_underneath, n_model_index, str_part_name );
	
	return self ai_DeathWatch( eInflictor, eAttacker, iDamage,str_means_of_death );
}

set_actor_damage_override()
{
	// store the original damage override (example: claw)
	self.overrideActorDamageOrig = self.overrideActorDamage;	
	
	// set the new override
	self.overrideActorDamage = ::actor_DeathWatch;	              
	self.overrideActorKilled = ::ai_Died;
	

	if (isDefined(self.overrideActorDamageOrig))
	{
		assert(self.overrideActorDamageOrig!=self.overrideActorDamage,"Cyclical damage callbacks");
	}

}

actor_DeathWatch( eInflictor, eAttacker, iDamage, iDFlags, sMeansOfDeath, sWeapon, vPoint, vDir, sHitLoc, modelIndex, psOffsetTime, boneName )
{
	if( IsDefined( self.overrideActorDamageOrig ) && self.overrideActorDamageOrig!=::actor_DeathWatch )
		iDamage = [[ self.overrideActorDamageOrig ]]( eInflictor, eAttacker, iDamage, iDFlags, sMeansOfDeath, sWeapon, vPoint, vDir, sHitLoc, modelIndex, psOffsetTime, boneName );
	
	return self ai_DeathWatch( eInflictor, eAttacker, iDamage, sMeansOfDeath );
}



enemy_contact_watcher()
{
	self endon("death");
	
	while( isDefined(self) )
	{
		self waittill("enemy");
		if (!IS_TRUE(self.rts_unloaded) )
			continue;
			
		if (isdefined(self.enemy) && self canShootEnemy() ) 
		{
			if ( RandomInt(100)<20 )
			{
				maps\_so_rts_event::trigger_event("dlg_generic_enemy");
			}
			else
			{
				if (isDefined(self.enemy.pkg_ref) )
				{
					maps\_so_rts_event::trigger_event("dlg_enemy_"+self.enemy.pkg_ref.ref);
				}
			}
		}
		wait 1;
	}
}

enemy_death_watcher()
{
	pkg_ref = self.pkg_ref;
	
	self waittill("death");
	maps\_so_rts_event::trigger_event("dlg_deadenemy_"+pkg_ref.ref);
}


ai_preInitialize(ref,pkg_ref,team,squadID)
{
	self.ai_ref			= ref;
	self.pkg_ref		= pkg_ref;
	self.team 			= team;
	self.squadID		= squadID;
	self.ignoreme		= true;
	self.ignoreall		= true;
	self.takedamage		= false;
	self maps\_so_rts_support::set_gpr(maps\_so_rts_support::make_gpr_opcode(GPR_OP_CODE_SET_TEAM) + (self.team=="allies"?1:0) ); //for sonar coloration
}

ai_postInitialize()
{
	self.ignoreme		= false;
	self.ignoreall		= false;
	self.takedamage		= true;
}


ai_initialize(ref,team,origin,squadID,angles,pkg_ref,health)
{
	if ( flag("rts_game_over") )
		return;
		
	assert(!isDefined(self.initialized),"AI being reinitialized");
	assert(isDefined(self.gpr_queue),"AI not preinitialized");
	
	self.health 		= ((isDefined(health)&&health>0)?health:ref.health);
	self.health_max 	= ref.health;
	self.goalradius 	= 512;
	self.accuracy 		= ref.accuracy;
	self.pkg_ref		= pkg_ref;
	self.maxvisibledist = 3072;
	
	if( IsDefined( origin ) )
	{
		if (ref.species == "human" || ref.species == "dog" || ref.species == "robot_actor" )
		{
			self SetGoalPos(origin);
			if(isDefined(angles))
			{
				self forceTeleport(origin,angles);
			}
			else
			{
				self forceTeleport(origin);
			}
		}
		else if ( ref.species == "vehicle" )
		{
			self.goalpos = origin;
			self.origin	 = origin;
		}
	}
	
	if( ref.species == "human" )
	{
		//recreate name(team was changed above)
		self maps\_names::get_name();
        self.canFlank 		= true;     // The AI will attempt to move to flanking positions around the player
        self.aggressiveMode	= true;     // The AI will approach the player’s position, especially if he’s hiding.
        
        self maps\_so_rts_event::allocVOXID();
        
        if (isDefined (level.rts.ai_special_grenades))
        {
        	self.special_grenade_type = level.rts.ai_special_grenades[RandomInt(level.rts.ai_special_grenades.size)];
        }
	}

	self thread maps\_so_rts_support::boundary_watcher(true);
	
	if (IS_VEHICLE(self))
	{
		self.vehdontejectoccupantsondeath = true;
		set_vehicle_damage_override();
		self.vteam = team;
		/# RecordEnt( self ); #/
	}
	else
	{
		self set_actor_damage_override();
	}
	self.team = team;
	self SetTeam(team);
	self thread ai_DeathMonitor();
	
	//optional initializer cb
	if(isDefined(ref.initializer) && isDefined(level.rts.additional_ai_initializers[ref.initializer]))
	{
		self [[level.rts.additional_ai_initializers[ref.initializer]]]();
	}
	

	if (self.team == "allies" && isDefined(squadID) )
	{
		if (!IS_VEHICLE(self))
		{
			self thread enemy_contact_watcher();
		}
			
		if ( ref.species == "human" )
		{
			LUINotifyEvent( &"rts_add_friendly_human", 3, self GetEntityNumber(), squadID, 35 );
		}
		else
		{
			LUINotifyEvent( &"rts_add_friendly_ai", 3, self GetEntityNumber(), squadID, 0 );
		}
		
		// TODO: this is temp while the network intruder is still a grenade
		self.grenadeawareness = 0;
		
		self.fixedNode = false;
		self.coverSearchInterval = CONST_ALLIES_COVER_SEARCH_INTERVAL;
	}
	else
	{
		self thread enemy_death_watcher();
	}
	

	if ( self.ai_ref.armor > 0 )
	{
		self.armor = self.ai_ref.armor;
	}
	
	self.initialized = true;
	self maps\_so_rts_support::flush_gpr();
}

spawn_ai_package_standard(pkg_ref, team, callback, searchPoint)	//units spawn at player start pos
{
	if(!isDefined(searchPoint))
	{
		if ( team == "axis" )
		{
			searchPoint = level.rts.enemy_center.origin;
		}
		else
		if ( team == "allies" )
		{
			searchPoint = level.rts.allied_center.origin;
		}
	}
	squadID = maps\_so_rts_squad::createSquad(searchPoint,team,pkg_ref); //every PACKAGE spawned should have a unique identifyer
	if (team=="allies" && isDefined(pkg_ref.hot_key_takeover) )
	{
		LUINotifyEvent( &"rts_add_squad", 3, squadID, pkg_ref.idx, 0 );
	}
	maps\_so_rts_squad::removeDeadFromSquad(squadID);

	nodes = GetNodesInRadiusSorted( searchPoint, 512, 0, 128);
	i 	  = 0;
	foreach(unit in pkg_ref.units)
	{
		ai_ref = level.rts.ai[unit];
		
		if (ai_ref.species == "human" || ai_ref.species == "robot_actor" )
		{
			ai = simple_spawn_single( ai_ref.ref, undefined, undefined, undefined, undefined, undefined, undefined, true);
		}
		else
		if (ai_ref.species == "vehicle")
		{
			origin = ( isDefined(nodes[i])?nodes[i].origin:searchPoint);
			ai = maps\_so_rts_support::placeVehicle( ai_ref.ref, origin +(0,0,36), team );
		}
		else
		if (ai_ref.species == "dog")
		{
			ai = simple_spawn_single( ai_ref.ref, undefined, undefined, undefined, undefined, undefined, undefined, true);
		}
		
		if(isDefined(ai))
		{
			ai.ai_ref = ai_ref;
			ai maps\_so_rts_squad::addAIToSquad(squadID);
			
			ai.initNode = nodes[i];
			i++;
			if ( i>=nodes.size)
				i = 0;
		}
	}
	maps\_so_rts_catalog::units_delivered(team,squadID);
	
	// finish spawning callback
	if( IsDefined( callback ) )
		thread [[ callback ]]( squadID );


	return squadID;
}

get_package_drop_target( team )
{
	if ( team == "axis" )
		dropTarget = level.rts.enemy_center.origin;
	else
		dropTarget = level.rts.allied_center.origin;
	
	return dropTarget;
}

spawn_ai_package_helo(transport)		//units spawn in via infantry fast rope from helo	[INFANTRY ONLY]
{
	pkg_ref 	= transport.pkg_ref;
	team 		= transport.team;
	callback	= transport.param;
	squadID		= transport.squadID;
	dropTarget 	= transport.dropTarget;
	type		= transport.type;
	spawned		= 0;

	// send the chopper
	chopper = chopper_send( dropTarget, team, type, false );

	maps\_so_rts_squad::removeDeadFromSquad(squadID);

	// set the squad to stay at dropoff point until further orders
	if( team == "axis"  )
		maps\_so_rts_squad::OrderSquadDefend( get_package_drop_target(team), squadID );
	
	// setup the passengers
	foreach(unit in pkg_ref.units)
	{
		ai_ref = level.rts.ai[unit];
		guy = simple_spawn_single( ai_ref.ref, undefined, undefined, undefined, undefined, undefined, undefined, true);
		
		if( isDefined(guy) )
		{
			spawned++;
			guy enter_vehicle( chopper );
			guy.ai_ref = ai_ref;
			guy maps\_so_rts_squad::addAIToSquad(squadID);
		}
	}
	if (spawned == 0 )
	{
		chopper maps\_so_rts_support::chopper_release_path();
		chopper delete();
		return -1;
	}
	
	chopper thread callbackOnNotify( "unloaded", 	maps\_so_rts_catalog::units_delivered,team, squadID );
	chopper thread callbackOnNotify( "death", 		maps\_so_rts_catalog::deallocateTransport, transport );
	chopper thread callbackOnNotify( "unloaded", 	maps\_so_rts_catalog::unloadTransport, transport );
	chopper thread callbackOnNotify( "unloaded", 	maps\_so_rts_support::chopper_release_path );
	
	if( IsDefined( callback ) )
		chopper thread callbackOnNotify( "unloaded", callback, squadID );
	
	return squadID;
}

spawn_ai_package_cargo(transport)		//units spawn in via dangling from rope off of helo, ala war mode bigdog [MECHANIZED ONLY]
{
	pkg_ref 	= transport.pkg_ref;
	team 		= transport.team;
	callback	= transport.param;
	squadID		= transport.squadID;
	dropTarget 	= transport.dropTarget;
	
	maps\_so_rts_squad::removeDeadFromSquad(squadID);
	// send the chopper
	chopper = chopper_send( dropTarget, team, "vtol", true );
	
	chopper thread chopper_unload_cargo( pkg_ref, team, squadID );
	
	//chopper thread chopper_drop_smoke_at_unloading();
	chopper thread callbackOnNotify( "unloaded",	maps\_so_rts_catalog::units_delivered,team, squadID );
	chopper thread callbackOnNotify( "death", 		maps\_so_rts_catalog::deallocateTransport, transport );
	chopper thread callbackOnNotify( "unloaded", 	maps\_so_rts_catalog::unloadTransport, transport );
	chopper thread callbackOnNotify( "unloaded", 	maps\_so_rts_support::chopper_release_path );
	
	if( IsDefined( callback ) )
		chopper thread callbackOnNotify( "unloaded", callback, squadID );
	
	return squadID;
}

#using_animtree ("vehicles");
chopper_unload_cargo( pkg_ref, team, squadID )
{
	self endon( "death" );
	
	self waittill( "unload" );
	
	self SetFlaggedAnimRestart( "door_open", %v_vtol_doors_open, 1, 0.2, 1 );
	self waittillmatch( "door_open", "end" );
	
	if( pkg_ref.ref == "quadrotor_pkg" )
	{
		self chopper_unload_cargo_quad( pkg_ref, team, squadID );
	}
	else if( pkg_ref.ref == "metalstorm_pkg" )
	{
		self chopper_unload_cargo_metalstorm( pkg_ref, team, squadID );
	}
	else
	{
		assert( pkg_ref.ref == "bigdog_pkg" );
		self chopper_unload_cargo_claw( pkg_ref, team, squadID );
	}
	
	// delay chopper for a bit
	wait( 1 );
	
	self notify( "unloaded" );
}

#using_animtree ("generic_human");
chopper_unload_cargo_quad( pkg_ref, team, squadID, cb )
{
	// find a good model to use so we don't waste an AI slot for this guy
	if( !IsDefined( level.rts.quad_thrower_model ) )
	{
		aiArray = GetAIArray( team );
		
		if( aiArray.size > 0 )
		{
			level.rts.quad_thrower_model = aiArray[0].model;
			level.rts.quad_thrower_headmodel = aiArray[0].headModel;
		}
		else
		{
			spawner = GetSpawnerTeamArray( "allies" )[0];
			guy = simple_spawn_single( spawner, undefined, undefined, undefined, undefined, undefined, undefined, true);
			
			assert( IsDefined( guy ) );
			
			level.rts.quad_thrower_model = guy.model;
			level.rts.quad_thrower_headmodel = guy.headModel;
			
			guy Delete();
		}
	}
	
	assert( IsDefined( level.rts.quad_thrower_model ) );
	
	guy = Spawn( "script_model", self.origin );
	guy SetModel( level.rts.quad_thrower_model );
	guy UseAnimTree( #animtree );
	
	if( IsDefined( level.rts.quad_thrower_headmodel ) )
		guy Attach( level.rts.quad_thrower_headmodel, "", true );
	
	tagOrigin = self GetTagOrigin( "tag_detach" );
	tagAngles = self GetTagAngles( "tag_detach" );
	
	throwTags = [];
	throwTags[ 0 ] = "tag_weapon_right";
	throwTags[ 1 ] = "tag_weapon_left";
	
	assert( AnimHasNotetrack( %ai_crew_vtol_quad_launch, "quad_launch" ) );
	
	// throw two at a time
	for( i=0; i < pkg_ref.units.size; i += 2 )
	{
		guy animscripted( "throw", tagOrigin, tagAngles, %ai_crew_vtol_quad_launch );
		guy waittillmatch( "throw", "quad_launch" );
		
		quads = [];
		
		for( j = i; j < pkg_ref.units.size; j++ )
		{
			unit = pkg_ref.units[ j ];
			ai_ref = level.rts.ai[ unit ];
			
			throwTag = throwTags[ j%2 ];
	
			quad = placeVehicle(ai_ref.ref, guy GetTagOrigin( throwTag ), team);
			quad LinkTo( guy, throwTag );
			quads[ quads.size ] = quad;
			
			if (isDefined(quad))
			{
				quad.ai_ref = ai_ref;
				quad maps\_so_rts_squad::addAIToSquad(squadID);
			}
			
			// wait( 0.05 );
		}
		
		guy waittillmatch( "throw", "end" );
		
		foreach( quad in quads )
		{
			quad Unlink();
			quad maps\_vehicle::move_to(level.rts.squads[squadID].centerPoint);
		}
	}
	self notify("unloaded_"+pkg_ref.ref);
	level notify("unloaded_"+pkg_ref.ref);
	guy Delete();
	if (isDefined(cb))
		thread [[cb]](squadID);
}

#using_animtree ("fxanim_props");
chopper_unload_cargo_metalstorm( pkg_ref, team, squadID )
{
	tagOrigin = self GetTagOrigin( "tag_body" );
	tagAngles = self GetTagAngles( "tag_body" );
	
	// spawn anim rig
	animRig = Spawn( "script_model", tagOrigin );
	animRig.angles = tagAngles;
	animRig LinkTo( self, "tag_body" );
	animRig UseAnimTree( #animtree );
	animRig SetModel( "fxanim_gp_vtol_drop_asd_drone_mod" );
	
	unit = pkg_ref.units[ 0 ];
	ai_ref = level.rts.ai[ unit ];
	
	assert( IsDefined( ai_ref ) );
			
	// spawn and attach the vehicle
	asd = placeVehicle( ai_ref.ref, animRig GetTagOrigin( "asd_attach_jnt" ), team );
	asd LinkTo( animRig, "asd_attach_jnt" );
	
	// animate the rig
	animRig SetFlaggedAnimRestart( "drop", %fxanim_gp_vtol_drop_asd_drone_anim, 1, 0.2, 1 );
	
	// drop the vehicle
	animRig waittillmatch( "drop", "drop_asd" );
	asd Unlink();
	
	// init the AI
	asd.ai_ref = ai_ref;
	asd maps\_so_rts_squad::addAIToSquad( squadID );
	asd maps\_vehicle::defend( asd.origin, 600 );
	
	animRig waittillmatch( "drop", "end" );
	animRig Delete();
}
/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////	

chopper_unload_cargo_claw( pkg_ref, team, squadID )
{
	tagOrigin = self GetTagOrigin( "tag_body" );
	tagAngles = self GetTagAngles( "tag_body" );
	
	// spawn anim rig
	animRig = Spawn( "script_model", tagOrigin );
	animRig.angles = tagAngles;
	animRig LinkTo( self, "tag_body" );
	animRig UseAnimTree( #animtree );
	animRig SetModel( "fxanim_gp_vtol_drop_claw_mod" );
	
	unit = pkg_ref.units[ 0 ];
	ai_ref = level.rts.ai[ unit ];
	
	assert( IsDefined( ai_ref ) );
			
	// spawn and attach the claw
	claw = simple_spawn_single( ai_ref.ref, undefined, undefined, undefined, undefined, undefined, undefined, true);
	assert( IsDefined( claw ) );
	
	if( isDefined( claw ) )
	{
		claw SetTeam(team);
		claw ForceTeleport( animRig GetTagOrigin( "claw_attach_jnt" ), animRig GetTagAngles( "claw_attach_jnt" ) );
		claw LinkTo( animRig, "claw_attach_jnt" );
		
		// animate the rig
		animRig SetFlaggedAnimRestart( "drop", %fxanim_gp_vtol_drop_claw_anim, 1, 0.2, 1 );
		
		// drop the vehicle
		animRig waittillmatch( "drop", "drop_claw" );
		claw Unlink();
		
		// init the AI
		claw.ai_ref = ai_ref;
		claw maps\_so_rts_squad::addAIToSquad( squadID );
		
		animRig waittillmatch( "drop", "end" );
	}
	
	animRig Delete();
}
/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////	

cargoCheck(pkg_ref)
{
	if ( isDefined(self.cargo) )
	{
		/#
		println("@@@@@@@@@@@@@@@@@@@  RIP  Delivery ["+pkg_ref.ref+"] at ("+self.origin+") self destructed for not being unloaded");
		#/
		self.cargo Delete();
		self.cargo = undefined;
	}
}
/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////	

/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////	
spawnReplacement(spawner) //self is player
{
	if (!isDefined(self.ally) )
		return;
	if (!isDefined(spawner) )
	{
		spawner = self.ally.ai_ref.ref;
	}
	
	guy = simple_spawn_single( spawner, undefined, undefined, undefined, undefined, undefined, undefined, true);
	if(isDefined(guy))
	{
		guy.ai_ref				= self.ally.ai_ref;
		guy maps\_so_rts_squad::addAIToSquad(self.ally.squadID);
		guy ai_initialize(self.ally.ai_ref,self.team,self.origin,self.ally.squadID,self.angles,self.ally.pkg_ref,self.ally.health);	
		guy.armor				= self.ally.armor;
		guy.goalradius			= self.ally.goalradius;
		guy.last_goalradius 	= self.ally.lastgoalrad;
		guy.accuracy			= self.ally.accuracy;
		guy SetgoalPos(self.origin);
		guy.name				= self.ally.name;
		guy.rts_unloaded 		= true;
		guy ai_postInitialize();
		
		if (isDefined(self.ally.grenadeweapon) )//restore grenades
		{
			guy.grenadeweapon = self.ally.grenadeweapon;
			guy.grenadeammo	  = self GetWeaponAmmoClip( self.ally.grenadeweapon );
		}
		if(isDefined(self.ally.sidearm) )
		{
			guy.sideArm = self.ally.sidearm;
		}
		if(isDefined(self.ally.primaryweapon)) 
		{
			guy maps\_so_rts_support::forceUseWeapon( self.ally.primaryweapon, "primary" );
		}

		if ( isDefined(self.ally)  && isDefined(self.ally.prevHealth))
			self.health = self.ally.prevHealth;

	
		self.ally = undefined;
	}
}

restoreReplacement()
{
	if (!isDefined(self.ally) )
		return;
	
	LUINotifyEvent( &"rts_remove_ai", 1, self GetEntityNumber() );
	clientnotify("restore_"+self.ally.pkg_ref.ref);
	
	if (self.ally.ai_ref.species == "human" || self.ally.ai_ref.species =="dog" )
	{
		spawnReplacement();
	}
	else
	if (self.ally.ai_ref.species == "robot_actor" )
	{
		assert(isDefined(self.ally.ai_ref.swap_spawner) );
		self.ally.vehicle UseBy( self );
		self.ally.vehicle.playerDeleted = 1;
		self.ally.vehicle delete();
		spawnReplacement(self.ally.ai_ref.ref);
	}
	else
	if (self.ally.ai_ref.species == "vehicle" )
	{//is vehicle
		if ( isDefined(self.ally.vehicle) )
		{
			self.ally.vehicle UseBy( self );
			self.ally.vehicle notify("player_exited");
			self.ally.vehicle.selectable = true;
			self.ally.vehicle.player = undefined;
		}
	}
	
	if (isDefined(self.ally) && isDefined(self.ally.prevHealth))
		self.health = self.ally.prevHealth;
		
	self.ally = undefined;
}


takeOverSelectedInfantry(entity) //self is player
{

	self.ally = spawnstruct();
	self.ally.ai_ref 		= entity.ai_ref;
	self.ally.pkg_ref		= entity.pkg_ref;
	self.ally.health  		= (entity.health>0?entity.health:1);
	self.ally.health_max	= entity.health_max;
	self.ally.armor   		= entity.armor;
	self.ally.goalradius	= entity.goalradius;
	self.ally.lastgoalrad	= entity.last_goalradius;
	self.ally.accuracy		= entity.accuracy;
	self.ally.squadID		= entity.squadID;
	self.ally.goalpos		= entity.goalpos;
	self.ally.grenadeweapon	= entity.grenadeweapon;
	self.ally.grenadeammo	= entity.grenadeammo;
	self.ally.name			= entity.name;
	self.ally.primaryweapon	= entity.primaryweapon;
	self.ally.sidearm		= entity.sidearm;
	self.ally.origin		= entity.origin;
	self.ally.angles		= entity.angles;
	self.ally.prevHealth	= self.health;
	self.health				= DEFAULT_PLAYER_HEALTH;
	
	
	// load out stuff
	self takeallweapons();

	//grenade weapon
	if (isDefineD(entity.special_grenade_type))
	{
		self GiveWeapon(entity.special_grenade_type);
	}
	else
	if (isDefined(self.ally.grenadeweapon) && self.ally.grenadeweapon!= "" && self.ally.grenadeweapon !="none" )
	{
		self GiveWeapon(self.ally.grenadeweapon);
		self SetWeaponAmmoClip( self.ally.grenadeweapon, self.ally.grenadeammo  );
	}
	else
		self.ally.grenadeweapon = undefined;
	
	//sidearm weapon
	if (isDefined(self.ally.sidearm) && self.ally.sidearm !="" && self.ally.sidearm !="none" )
	{
		self GiveWeapon(self.ally.sidearm);
		self GiveStartAmmo( self.ally.sidearm );
	}
	else
		self.ally.sidearm = undefined;

	//primary weapon
	if (isDefined(self.ally.primaryweapon))
	{
		if ( self.ally.primaryweapon == "none" )
		{
			self.ally.primaryweapon = entity.initial_primaryweapon;
			assert(isDefined(self.ally.primaryweapon) && self.ally.primaryweapon != "none","illegal weapon");
		}
	
		self GiveWeapon(self.ally.primaryweapon);
		self GiveStartAmmo( self.ally.primaryweapon );
		self SwitchToWeapon( self.ally.primaryweapon);
	}
	else
		assert(0,"must have a primary weapon");
	
	
	
	// always have a melee weapon
	self GiveWeapon( "knife_sp" );
	
	level.rts.player setOrigin(self.ally.origin);
	level.rts.player setplayerangles(getBestInitialOrientAngles(entity));

	entity maps\_so_rts_support::flush_gpr();

	if ( entity.ai_ref.armor > 0 )
	{
		self.armor = entity.ai_ref.armor;//DT#24813 //requested by prod to armor up the quadrotor if the player is in control so that he can take a few its.
	}
	entity Delete();
	LUINotifyEvent( &"rts_add_friendly_human", 4, self GetEntityNumber(), self.ally.squadID, 0, 1 );
}

vehicleDeathWatcher(vehicle)//self is player
{
	vehicle endon("player_exited");
	vehicle waittill("death");
	if ( !isDefined(vehicle.playerDeleted) )
	{	
		maps\_so_rts_squad::removeDeadFromSquad(self.ally.squadID);
		if (level.rts.squads[self.ally.squadID].members.size == 0 )
		{
			level.rts.squads[self.ally.squadID].destroyed = 1;
			nextSquad = maps\_so_rts_squad::getNextValidSquad(self.ally.squadID);
		}
		else
		{
			nextSquad = self.ally.squadID;
		}
		
		maps\_so_rts_event::trigger_event("vehicle_death");
		
		if (nextSquad == -1  )
		{
			level.rts.lastFPSpoint = level.rts.player.origin;
			level thread player_eyeInTheSky();
			self.ally = undefined;
		}
		else
		{
			maps\_so_rts_event::trigger_event("forceswitch_"+level.rts.squads[nextSquad].pkg_ref.ref);
			maps\_so_rts_main::player_nextAvailUnit(nextSquad,true);
		}
		
		wait 1;
	
		if (isDefined(vehicle) && isDefined(vehicle.ai_ref.swap_spawner))
			vehicle delete();
	}
}

getBestInitialOrientAngles(entity)
{
	angles = entity.angles;
	if (isDefined(level.rts.enemy_base) )
	{
		enemyEnt = level.rts.enemy_base.entity;
	}
	if(isDefined(entity.enemy))
	{
		enemyEnt=entity.enemy;
	}
	else
	{
		closeEnemy = getClosestAI(self.origin,"axis",750*750);
		if (isDefined(closeEnemy) )
		{
			enemyEnt = closeEnemy;
		}
	}
	if (isDefined(enemyEnt))
	{
		dirToPos = enemyEnt.origin - level.rts.player.origin;
		angles = vectortoangles( dirToPos );
	}
	return angles;
}


takeOverSelectedVehicle(entity) //self is player
{
	entity notify("taken_control_over");
	wait 0.05;

	if (isDefined(entity.ai_ref.swap_notify))
	{
		level notify(entity.ai_ref.swap_notify,entity);
		clientnotify(entity.ai_ref.swap_notify);
		entity notify(entity.ai_ref.swap_notify);
	}
	
	if ( isDefined(entity.ai_ref.swap_spawner) )
	{
		vehicle = maps\_vehicle::spawn_vehicle_from_targetname(  entity.ai_ref.swap_spawner );
		if (isDefined(vehicle) )
		{
			self.ally 				= spawnstruct();
			self.ally.ai_ref 		= entity.ai_ref;
			self.ally.pkg_ref		= entity.pkg_ref;
			self.ally.health  		= (entity.health>0?entity.health:1);
			self.ally.health_max	= entity.health_max;
			self.ally.armor   		= entity.armor;
			self.ally.goalradius	= entity.goalradius;
			self.ally.lastgoalrad	= entity.last_goalradius;
			self.ally.accuracy		= entity.accuracy;
			self.ally.squadID		= entity.squadID;
			self.ally.goalpos		= entity.goalpos;
			self.ally.origin		= entity.origin;
			self.ally.angles		= entity.angles;
			self.ally.vehicle		= vehicle;
			self.ally.prevHealth	= self.health;
			self.health				= DEFAULT_PLAYER_HEALTH;
			vehicle.ai_ref			= entity.ai_ref;
			vehicle.health			= entity.health_max;
			vehicle.health_max		= entity.health_max;
			entity maps\_so_rts_support::flush_gpr();
			
			vehicle.origin = entity.origin;
			vehicle.angles = getBestInitialOrientAngles(entity);
			
			vehicle MakeVehicleUsable();
			self.ignoreme 	= true; //vehicle will be targeted
			self EnableInvulnerability();
			self SetOrigin(vehicle.origin);
			self SetPlayerAngles(vehicle.angles);
			vehicle UseVehicle( self, entity.ai_ref.seat );
			self thread vehicleDeathWatcher(vehicle);//self is player
			vehicle MakeVehicleUnusable();
			vehicle maps\_so_rts_squad::addAIToSquad(self.ally.squadID);
			vehicle ai_initialize(self.ally.ai_ref,self.team,undefined,self.ally.squadID,undefined,self.ally.pkg_ref,vehicle.health);
			vehicle.rts_unloaded = true;
			vehicle ai_postInitialize();

			if ( vehicle.ai_ref.armor > 0 )
			{
				vehicle.armor = vehicle.ai_ref.armor;//DT#24813 //requested by prod to armor up the quadrotor if the player is in control so that he can take a few its.
			}
			entity Delete();
			entity = vehicle;
		}
	}
	else
	{
		entity maps\_vehicle::stop();
		wait 0.05;
		entity veh_magic_bullet_shield(false);
		entity MakeVehicleUsable();
		self.ignoreme 	= true; //vehicle will be targeted
		self EnableInvulnerability();
		self.ally 				= spawnstruct();
		self.ally.ai_ref 		= entity.ai_ref;
		self.ally.pkg_ref		= entity.pkg_ref;
		self.ally.vehicle		= entity;
		self.ally.squadID		= entity.squadID;
		self.health				= DEFAULT_PLAYER_HEALTH;
		entity.angles 			= getBestInitialOrientAngles(entity);
		self.ally.vehicle notify("player_entering");
		self SetOrigin(entity.origin);
		entity UseVehicle( self, entity.ai_ref.seat );
		entity.health 			= entity.health_max;
		self thread vehicleDeathWatcher(entity);//self is player
		entity MakeVehicleUnusable();
		if ( entity.ai_ref.armor > 0 )
		{
			entity.armor = entity.ai_ref.armor;//DT#24813 //requested by prod to armor up the quadrotor if the player is in control so that he can take a few its.
		}
	}
	entity.player = self;
	self notify("vehicle_taken_over",entity);
	return entity;
}
/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////	
IS_MECHANICAL(entity)
{
	return (entity.ai_ref.species == "robot_actor");
}


health_regen(amountPerSec,maxHealth)
{
	self endon("death");
	while(1)
	{
		self.health += amountPerSec;
		if (self.health > maxHealth )
			self.health = maxHealth;
		wait 1;
	}
}

takeOverSelected(entity) //self is player
{
	self.ignoreme = false;
	if ( !isDefined(entity) )
		return;
		
	assert(isDefined(entity.pkg_ref));
	assert(!IS_TRUE(entity.no_takeover),"illegal target");
	assert(IS_TRUE(entity.rts_unloaded),"illegal target");
	
	pkg_ref = entity.pkg_ref;
	
	if ( IS_VEHICLE(entity) || IS_MECHANICAL(entity)	)
	{
		if ( IS_MECHANICAL(entity) )
		{
			entity.takedamage = true;
		}
		else
		{
			entity veh_magic_bullet_shield(false);
		}
		entity = takeOverSelectedVehicle(entity);
	}
	else
	{
		self thread maps\_so_rts_support::block_player_damage_fortime(5);
		self thread takeOverSelectedInfantry(entity);
	}
	
	level notify("takeover_"+pkg_ref.ref,entity);
	clientnotify("takeover_"+pkg_ref.ref);
	return entity;
}


/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////	
dog_initialize()
{
}

/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////	
vehicle_initialize()
{
	// don't break AI paths
	self.dontDisconnectPaths = true;
}

/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////	
recon_initialize()
{
	if (self.team == level.rts.player.team )
	{
		self thread maps\_so_rts_support::deleteMeOnNotify("player_exited");
		level.rts.targetTeamMate = self;
		self thread maps\_so_rts_main::player_in_control();
	}
}

/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////	
removeBaseAsThreat()
{
	allEnemies = GetAIArray( "axis" );
	
	foreach( enemy in allEnemies )
		enemy ClearEntityTarget();
	
	allVehicles = GetVehicleArray( "axis" );

	foreach( vehicle in allVehicles )
	{
		if( IsSentient( vehicle ) )
		{
			vehicle VehClearEntityTarget();	
		}
	}
}

