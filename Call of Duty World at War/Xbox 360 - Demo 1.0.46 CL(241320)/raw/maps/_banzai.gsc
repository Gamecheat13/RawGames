#include maps\_utility;

// TODO:
// - Add comments throughout this script

init()
{
	self animscripts\banzai::banzai_init_anims();
	
	// Since the Banzai attacks happen in the American Campaigns, we assume we already have the knife in the FF.
	PrecacheModel( "weapon_usa_kbar_knife" );
	PrecacheShellshock( "banzai_impact" );
	PrecacheString( &"SCRIPT_PLATFORM_BANZAI_HINT" );
	PrecacheString( &"SCRIPT_PLATFORM_BANZAI_DEATH_DO_NOTHING" );
	PrecacheString( &"SCRIPT_PLATFORM_BANZAI_DEATH_TOO_SOON" );
	PrecacheString( &"SCRIPT_PLATFORM_BANZAI_DEATH_TOO_LATE" );
	
	level._effects[ "stab_wound" ] = loadfx( "impacts/fx_flesh_bayonet_neck" );

	level thread check_interactive_hands();
}

check_interactive_hands()
{
/#
	if( !IsDefined( level.loadoutComplete ) || !level.loadoutComplete )
	{
		level waittill( "loadout complete" );
	}

	assertEx( IsDefined( level.player_interactive_hands ), "level.player_interactive_hands is not defined. Use _loadout::set_player_interactivate_hands() to set it up." );
#/	
}

spawned_banzai_immediate()
{
	// Must wait until after the _spawner goalradius check before calling banzai_force, since
	// that calls banzai_charge() and banzai_charge() sets the goalradius.
	if ( spawn_failed( self ) )
		return;
	
	banzai_force();
}

spawned_banzai_dynamic()
{
	banzai();
}

banzai()
{
	self animscripts\banzai::init();

	self endon( "death" );
	self endon( "stop_banzai_thread" );

	if( IsDefined( self.target ) && ( !IsDefined( self.banzai_no_wait ) || ( Isdefined( self.banzai_no_wait ) && !self.banzai_no_wait ) ) )
	{
		// If script_forcegoal isn't true when we reach our goal, the goalradius will get reset.
		self.script_forcegoal = true;
		self waittill( "reached_path_end" );
	}

	wait_time = 3 + RandomFloat( 2 );

	self thread banzai_print( "Banzai wait: " + wait_time );

	wait( wait_time );

	self thread banzai_print( "Getting nearby Banzai-ers" );

	others = self get_nearby_banzai_guys();

	// Plays the "pump up" dialogue, we must wait for it to finish the sound before actually charging.
	self banzai_pump_up();

	self thread staggered_banzai_charge();
	for( i = 0; i < others.size; i++ )
	{
		if ( isalive(others[i]) && isdefined(others[i]) )
		{
			others[i] thread staggered_banzai_charge();
		}
	}
}

banzai_force()
{
	self animscripts\banzai::init();

	self endon( "death" );

	self.banzai = true;
	self.inmeleecharge = true;

	if( IsDefined( self.target ) && ( !IsDefined( self.banzai_no_wait ) || ( Isdefined( self.banzai_no_wait ) && !self.banzai_no_wait ) ) )
	{
		// If script_forcegoal isn't true when we reach our goal, the goalradius will get reset.
		self.script_forcegoal = true;
		self waittill( "reached_path_end" );
	}

	self banzai_charge( true );
}

may_banzai_attack( enemy, maxAttackers )
{
	assert ( IsDefined( enemy ) );

	// Our banzai attack animations were authored with the victim standing; crouch works well enough, but not prone or back.
	//if ( enemy.a.pose == "prone" || enemy.a.pose == "back" )
	//	return false;
	
	if ( enemy animscripts\banzai::in_banzai_melee() && DistanceSquared( self.origin, enemy.origin ) < 96 * 96 ) 
		return false;
	
	if ( IsDefined( enemy.num_banzai_chargers ) && enemy.num_banzai_chargers >= maxAttackers )
		return false;
	
	if ( IsDefined( enemy.no_banzai_attack ) && enemy.no_banzai_attack )
		return false;

	if ( IsDefined( enemy.magic_bullet_shield ) && enemy.magic_bullet_shield )
	{
		if ( enemy.a.pose != "stand" )
			return false;
	}		
		
	if ( IsPlayer( enemy ) )
	{ 
		if ( IsDefined( enemy.usingturret ) && enemy.usingturret )
			return false;
			
		if ( IsDefined( enemy.usingvehicle ) && enemy.usingvehicle )
			return false;
		
		if ( !check_player_can_see_me( enemy ) )
			return false;
		
		if ( enemy maps\_laststand::player_is_in_laststand() )
			return false;
		
		//chris_p - make sure typ100 smg guys can't banzai attack a player
		if( IsDefined(self.primaryweapon) && self.primaryweapon == "type100_smg")
			return false;	
	}
	
	//if ( path_blocked( enemy ) )
	//	return false;
		
	return true;	
}

should_switch_immediately( enemy )
{
	if ( !IsDefined( enemy ) )
		return true;
		
	if ( !IsAlive( enemy ) )
		return true;
		
	if ( IsDefined( enemy.no_banzai_attack ) && enemy.no_banzai_attack )
		return true;

	if ( IsDefined( enemy.magic_bullet_shield ) && enemy.magic_bullet_shield )
	{
		if ( enemy.a.pose != "stand" )
			return true;
	}		
		
	if ( IsPlayer( enemy ) )
	{ 
		if ( IsDefined( enemy.usingTurret ) && enemy.usingTurret )
			return true;
			
		if ( IsDefined( enemy.usingVehicle ) && enemy.usingvehicle )
			return true;
			
		if ( enemy maps\_laststand::player_is_in_laststand() )
			return true;
		
		//within 12 feet.  am stopped, and my target is 2 feet above me.
		if ( distanceSquared(self.origin, enemy.origin) < 20736 )
		{	
			if ( self.a.movement == "stop"  && (self.origin[2] < (enemy.origin[2]-24)) )
				return true;	
		}
	}
		
	return false;
}

find_enemy()
{
	self endon("death");
	
	if(!isDefined(self.team))
	{
		return undefined;
	}
	
	if( self.team == "axis" )
	{
		opposite_team = "allies";
	}
	else
	{
		opposite_team = "axis";
	}
	
	maxDistance = 4000;
	
	if ( IsDefined( self.script_max_banzai_distance ) )
	{
		maxDistance = self.script_max_banzai_distance;
	}
		
	clear_blocked_enemy_cache();
			
	// If script_player_chance is not defined, this means to just pick the closest eligible target.
	// If a most-eligible target already has one banzai attacker, go after the next most eligible.
	// If all eligible targets have one banzai attacker already, start again from the closest.
	// Repeat until we've reached the max number of banzai attackers for all eligible targets.
	
	if ( !IsDefined( self.script_player_chance ) )
	{
		ais = GetAiArray( opposite_team );
		players = get_players();		
		enemies = array_combine( players, ais );
		enemies = get_array_of_closest( self.origin, enemies, undefined, undefined, maxDistance );
		
		for ( numAttackers = 1; numAttackers <= 2; numAttackers++)
		{
			for ( i = 0; i < enemies.size; i++ )
			{
				if ( may_banzai_attack( enemies[i], numAttackers ) )
					return enemies[i];
			}
		}
		
		players = get_array_of_closest( self.origin, players, undefined, undefined, maxDistance );

		for ( i = 0; i < players.size; i++ )
		{
			if ( may_banzai_attack( players[i], numAttackers ) )
				return players[i];
		}
		
		return undefined;
	}
	
	// If there's any chance we choose a player, try them first.
	if ( self.script_player_chance > 0 )
	{
		enemies = get_players();
		enemies = get_array_of_closest( self.origin, enemies, undefined, undefined, maxDistance );
		
		for ( i = 0; i < enemies.size; i++ )
		{
			if ( may_banzai_attack( enemies[i], 3 ) )
			{
				dieRoll = RandomInt( 100 );
				if ( dieRoll < self.script_player_chance )
				{
					return enemies[i];
				}
			}
		}
	}

	// If we didn't choose a player, try AIs, closest first.
	enemies = GetAiArray( opposite_team );
	enemies = get_array_of_closest( self.origin, enemies, undefined, undefined, maxDistance );
	
	// Construct a list of eligible targets, still sorted closest first
	for ( i = 0; i < enemies.size; i++ )
	{
		if ( may_banzai_attack( enemies[i], 2 ) )		
			return enemies[i];
	}
	
	return undefined;
}

check_player_can_see_me( player )
{
	if ( !IsDefined( self.script_banzai_within_fov ) || !self.script_banzai_within_fov )
		return true;
	
	return player_can_see_me( player );
}

player_can_see_me( player )
{
	playerAngles = player getplayerangles();
	playerForwardVec = AnglesToForward( playerAngles );
	playerUnitForwardVec = VectorNormalize( playerForwardVec );
	
	banzaiPos = self GetOrigin();
	playerPos = player GetOrigin();
	playerToBanzaiVec = banzaiPos - playerPos;
	playerToBanzaiUnitVec = VectorNormalize( playerToBanzaiVec );
	
	forwardDotBanzai = VectorDot( playerUnitForwardVec, playerToBanzaiUnitVec );
	angleFromCenter = ACos( forwardDotBanzai ); 

	playerFOV = GetDVarFloat( "cg_fov" );
	banzaiVsPlayerFOVBuffer = GetDVarFloat( "g_banzai_player_fov_buffer" );	
	if ( banzaiVsPlayerFOVBuffer <= 0 )
	{
		banzaiVsPlayerFOVBuffer = 0.2;
	}

	//println( "Banzai is " + angleFromCenter + " degrees from straight ahead. Player FOV is" + playerFOV );

	playerCanSeeMe = ( angleFromCenter <= ( playerFOV * 0.5 * ( 1 - banzaiVsPlayerFOVBuffer ) ) );
	
	return playerCanSeeMe;
}

get_nearby_banzai_guys()
{
	guys = GetAiArray( self.team );

	banzai_guys = [];
	for( i = 0; i < guys.size; i++ )
	{
		if( guys[i] == self )
		{
			continue;
		}

		if( IsAlive( guys[i] ) && IsDefined( guys[i].script_banzai ) && guys[i].script_banzai )
		{
			if( DistanceSquared( self.origin, guys[i].origin ) < 512 * 512 )
			{
				guys[i] notify( "stop_banzai_thread" );
				guys[i].script_banzai = 0;

				banzai_guys[banzai_guys.size] = guys[i];
			}
		}
	}

	return banzai_guys;
}

staggered_banzai_charge()
{
	wait( RandomFloat( 1.0 ) );
	banzai_charge();
}

banzai_charge( spawned_charge )
{
	self endon( "death" );
	
	if( !IsDefined( spawned_charge ) )
	{
		spawned_charge = false;
	}

	if( !spawned_charge )
	{
		self.banzai = true;
		self.inmeleecharge = true;
	}
	
	// Must reset the goalradius before we get into the run loop 
	// (which is run whenever self.banzai is true), so that when
	// the guy reaches his goal it's not some huge default number
	// that allows the banzai guy to go wander off and do 
	// something else.
	self.goalradius = 64;
	
	self thread start_banzai_announce();
	
	self.favoriteenemy = undefined;
	thread find_new_enemy_immediately();	
	thread find_closer_enemy();	
	thread find_new_enemy_if_blocked();	
	
	wait ( 0.05 );
	
	// Only necessary because we cannot SetGoalEntity() when the 
	// goal entity is an AI or Player.
	while ( 1 )
	{
		if ( IsDefined( self.favoriteenemy ) )
		{
			self SetGoalPos( self.favoriteenemy.origin );
		}
		
		wait( 0.1 );
	}	
}

distance_to_enemy_less_than( lessThanThis )
{
	assert( IsDefined( self.favoriteenemy ) );
	return DistanceSquared( self.origin, self.favoriteenemy.origin ) < lessThanThis * lessThanThis;
}

find_new_enemy_immediately()
{
	self endon( "death" );
	
	while ( 1 )
	{
		if ( !self animscripts\banzai::in_banzai_attack() )
		{
			enemy = self.favoriteenemy;
		
			if ( should_switch_immediately( enemy ) )
			{
				switch_enemies();
			}
		}
		
		wait( 0.1 );
	}
}

find_closer_enemy()
{
	self endon( "death" );
	
	lastPos = undefined;
	
	while ( 1 )
	{
		if ( !self animscripts\banzai::in_banzai_attack() )
		{
			enemy = self.favoriteenemy;
			if ( IsDefined( enemy ) )
			{
				if ( !IsPlayer( enemy ) && !distance_to_enemy_less_than( 192 ) )
				{
					newEnemy = self find_enemy();
					if ( IsDefined( newEnemy ) && newEnemy != enemy )
					{
						if ( self CanSee( newEnemy ) )
						{
							self notify( "banzai_new_enemy" );
							self.favoriteenemy.num_banzai_chargers--;
							
							banzai_set_enemy( newEnemy );
						}
					}
				}
			}
		}
		
		wait( 0.05 );
	}
}

find_new_enemy_if_blocked()
{
	self endon( "death" );
	
	lastPos = undefined;
	
	while ( 1 )
	{
		if ( !self animscripts\banzai::in_banzai_attack() )
		{
			enemy = self.favoriteenemy;
			if ( IsDefined( enemy ) )
			{				
				currPos = self.origin;
				if ( IsDefined( lastPos ) && DistanceSquared( currPos, lastPos ) < 64 )
				{
					// Only check if path is blocked if we've been stuck in the same spot for a while.
					if ( !findpath( currPos, enemy.origin ) )
					{
						switch_enemies();
					}
					else
					{
						lastPos = currPos;
					}
				}
				else
				{
					lastPos = currPos;
				}
			}
		}
		
		wait( RandomFloatRange( 0.25, 0.35 ) );
	}
}

switch_enemies()
{
	if ( IsDefined( self.favoriteenemy ) )
	{
		self notify( "banzai_new_enemy" );
		self.favoriteenemy.num_banzai_chargers--;
	}
	
	enemy = keep_trying_find_enemy();
			
	banzai_set_enemy( enemy );
}

keep_trying_find_enemy()
{
	while ( 1 )
	{
		enemy = self find_enemy();
		if ( IsDefined( enemy ) && ( !IsDefined( self.favoriteenemy ) || enemy != self.favoriteenemy ) )
		{
			return enemy;
		}
		wait( 0.05 );
	}
}	

path_blocked( enemy )
{
	for ( i = 0; i < self.blocked_enemies.size; i++ )
	{
		if ( enemy == self.blocked_enemies[i] )
		{
			return self.blocked_enemy_flags[i];
		}
	}
	
	blocked = !findPath( self.origin, enemy.origin );
	newIndex = self.blocked_enemies.size;
	
	// Make sure the cache doesn't grow too large.
	if ( newIndex < 10 )
	{
		self.blocked_enemies[ newIndex ] = enemy;
		self.blocked_enemy_flags[ newIndex ] = blocked;
	}
	
	return blocked;
}

clear_blocked_enemy_cache()
{
	self.blocked_enemies = [];
	self.blocked_enemy_flags = [];
}

banzai_set_enemy( enemy )
{
	level thread banzai_death_thread( self, enemy );

	self.favoriteEnemy = enemy;
	self SetGoalPos( enemy.origin );

	// Notify last set of debug lines to turn off before starting new set.
	//self notify( "banzai_enemy_set" );
	
  //thread draw_line_from_ent_to_ent_until_notify( self, enemy, 1, 1, 0, self, "banzai_enemy_set" );

	//thread draw_forward_line_until_notify( self, 1, 0, 1, self, "banzai_enemy_set" );
	//thread draw_forward_line_until_notify( enemy, 1, 0, 1, self, "banzai_enemy_set" );

	if( !IsDefined( enemy.num_banzai_chargers ) )
	{
		enemy.num_banzai_chargers = 0;
	}

	enemy.num_banzai_chargers++;
}

draw_forward_line_until_notify( ent, r, g, b, notifyEnt, notifyString )
{
	assert( isdefined( notifyEnt ) );
	assert( isdefined( notifyString ) );
	
	ent endon( "death" );
	notifyEnt endon( "death" );
	notifyEnt endon( notifyString );
	
	while( 1 )
	{
		forwardVec = VectorNormalize( AnglesToForward( ent.angles ) );
		pointForward = ent.origin + forwardVec * 64;
		line( ent.origin, pointForward, ( r, g, b ), 0.05 );
		wait .05;		
	}
}

banzai_death_thread( attacker, enemy )
{
	attacker endon( "banzai_new_enemy" );
	attacker waittill( "death" );

	if( IsDefined( enemy ) )
	{
		enemy.num_banzai_chargers--;
	}
}


start_banzai_announce()
{
	self endon( "death" );
	
	// This will wait until battlechatter is finished before continuing with the actual banzai announcement.
	//self maps\_utility::set_battlechatter( false );
	self.battlechatter = false;

	// Only ever want to do this once, not every time we restart banzai behavior.
	if ( !IsDefined( self.banzai_announcing ) )
	{
		self.banzai_announcing = true;
		self thread listen_for_end_of_banzai_announce();
		self banzai_dialogue( "banzai_charge_announce", undefined, "banzai_announce_ended" );
	}
}

listen_for_end_of_banzai_announce()
{
	self endon( "death" );
	self waittill( "banzai_announce_ended" );
	self.banzai_announcing = false;
}

banzai_charge_yell( enemy )
{
	self endon( "death" );
	self endon( "pain" );

	// TODO: Get facial anims for the charge
	facial_anim = undefined;

	if ( IsPlayer( enemy ) )
	{
		soundalias = "banzai_charge_plr";
	}
	else
	{
		soundalias = "banzai_charge";
	}

	self banzai_dialogue( soundalias, facial_anim );
	
	self thread end_banzai_charge_yell();
}

end_banzai_charge_yell()
{
	self endon( "banzai_new_enemy" );
	self waittill( "pain" );
	self stopSounds();
}

banzai_pump_up()
{
	// TODO: Get facial anims for the charge
	facial_anim = undefined;

	// TODO: Mix up the yell sounds
	soundalias = "banzai_pump";

	self banzai_dialogue( soundalias, facial_anim, "banzai_pump" );
	self waittill( "banzai_pump" );
}

banzai_print( msg )
{
/#
	if( GetDvar( "debug_banzai" ) != "1" )
	{
		return;
	}

	self endon( "death" );

	self notify( "stop_banzai_print" );
	self endon( "stop_banzai_print" );

	time = GetTime() + ( 3 * 1000 );
	offset = ( 0, 0, 0 );
	while( GetTime() < time )
	{
		offset = offset + ( 0, 0, 2 );
		print3d( self GetTagOrigin( "J_Head" ) + offset, msg, ( 1, 1, 1 ) );
		wait( 0.05 );
	}
#/
}

#using_animtree( "generic_human" );
banzai_dialogue( soundalias, facial_anim, notify_string )
{
	self animscripts\face::SaySpecificDialogue( facial_anim, soundalias, 0.9, notify_string );
}
