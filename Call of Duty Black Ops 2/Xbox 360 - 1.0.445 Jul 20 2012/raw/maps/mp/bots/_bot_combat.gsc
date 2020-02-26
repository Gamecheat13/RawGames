#include common_scripts\utility;
#include maps\mp\_utility;

#insert raw\maps\mp\bots\_bot.gsh;

#define EXPLOSION_RADIUS_FRAG	256
#define EXPLOSION_RADIUS_FLASH	650

bot_combat_think( damage, attacker, direction )
{
	aim_error = undefined;
	aim_decay = 0;
	previous = undefined;

	interval = [];

	self AllowAttack( false );
	self PressAds( false );
		
	for ( ;; )
	{
		if ( self AtGoal( "enemy_patrol" ) )
		{
			self CancelGoal( "enemy_patrol" ); 
		}

		bot_select_weapon();
		
		fov = bot_get_fov();

		enemies = self GetThreats( fov );
		enemy = self bot_best_enemy( enemies );

		if ( !IsDefined( enemy ) )
		{
			if ( IsDefined( previous ) && !IsAlive( previous ) )
			{
				wait( 0.5 );
				self AllowAttack( false );
				wait( 1 );
			}
			
			if ( IsDefined( damage ) )
			{
				bot_patrol_near_enemy( damage, attacker, direction );
				self PressAds( false );
				self AllowAttack( false );

				return;
			}

			if ( !self IsSprinting() )
			{
				if ( bot_weapon_ammo_frac() < 0.5 && !self IsReloading() )
				{
					self PressUseButton( 0.1 );
				}
			}

			self ClearLookAt();
			self CancelGoal( "cover" );
			self CancelGoal( "flee" );

			self AllowAttack( false );
			self PressAds( false );

			return;
		}

		self CancelGoal( "enemy_patrol" ); 
		
		if ( IsDefined( previous ) && previous != enemy )
		{
			interval = [];
		}

		if ( enemy IsSprinting() && interval.size )
		{
			interval[0] += 1000;
		}

		if ( self IsReloading() )
		{
			wait( 0.5 );
			interval = [];
			continue;
		}

		previous = enemy;

		if ( !IsDefined( aim_error ) )
		{
			aim_error = bot_calc_initial_error( enemy );
			aim_decay = aim_error * 0.005;
		}

		if ( !interval.size )
		{
			interval_count = bot_get_converge_rate();

			step = bot_get_converge_time() / interval_count;
			step = Int( 50 * ceil( step / 50 ) );
			
			time = GetTime();
			count = 0;

			for ( i = interval_count; i >= 0; i-- )
			{
				interval[ count ] = time + step * i;
				count++;
			}
		}

		dot_from_enemy = bot_dot_product( enemy, self.origin );

		sight = bot_update_sight( enemy );

		origin = bot_update_aim( sight, enemy, dot_from_enemy );

		if ( !IsDefined( origin ) )
		{
			return;
		}

		dot_to_enemy = bot_dot_product( self, origin );
		bot_update_lookat( origin, aim_error, interval );
		aim_error -= aim_decay;

		if ( aim_error < 0 )
		{
			aim_error = 0;
		}

		if ( GetTime() >= interval[0] )
		{
			aim_error = 0;
		}

		bot_update_cover( enemy, dot_from_enemy );
		bot_update_attack( enemy, dot_from_enemy, dot_to_enemy, sight, origin );

		if ( sight == BOT_CAN_SEE_NOTHING )
		{
			bot_combat_throw_lethal( origin );
			bot_combat_throw_tactical( origin );
		}

		wait( 0.05 );
	}
}

bot_get_fov()
{
	difficulty = maps\mp\bots\_bot::bot_get_difficulty();

	switch( difficulty )
	{
		case "easy":
			return BOT_FOV_EASY;
		break;

		case "normal":
			return BOT_FOV_MEDIUM;
		break;

		case "hard":
			return BOT_FOV_HARD;
		break;

		case "fu":
			return BOT_FOV_FU;
		break;
	}

	return BOT_FOV_MEDIUM;
}

bot_get_converge_time()
{
	difficulty = maps\mp\bots\_bot::bot_get_difficulty();

	switch( difficulty )
	{
		case "easy":
			return BOT_AIM_CONVERGE_SECS_EASY * 1000;
		break;

		case "normal":
			return BOT_AIM_CONVERGE_SECS_MEDIUM * 1000;
		break;

		case "hard":
			return BOT_AIM_CONVERGE_SECS_HARD * 1000;
		break;

		case "fu":
			return BOT_AIM_CONVERGE_SECS_FU * 1000;
		break;
	}

	return BOT_AIM_CONVERGE_SECS_MEDIUM * 1000;
}

bot_get_converge_rate()
{
	difficulty = maps\mp\bots\_bot::bot_get_difficulty();

	switch( difficulty )
	{
		case "easy":
			return BOT_AIM_CONVERGE_RATE_EASY;
		break;

		case "normal":
			return BOT_AIM_CONVERGE_RATE_MEDIUM;
		break;

		case "hard":
			return BOT_AIM_CONVERGE_RATE_HARD;
		break;

		case "fu":
			return BOT_AIM_CONVERGE_RATE_FU;
		break;
	}

	return BOT_AIM_CONVERGE_RATE_MEDIUM;
}

bot_get_initial_aim_error()
{
	difficulty = maps\mp\bots\_bot::bot_get_difficulty();

	switch( difficulty )
	{
		case "easy":
			return BOT_AIM_INITIAL_ERROR_EASY;
		break;

		case "normal":
			return BOT_AIM_INITIAL_ERROR_MEDIUM;
		break;

		case "hard":
			return BOT_AIM_INITIAL_ERROR_EASY;
		break;

		case "fu":
			return BOT_AIM_INITIAL_ERROR_EASY;
		break;
	}

	return BOT_AIM_INITIAL_ERROR_MEDIUM;
}

bot_update_lookat( origin, error, interval )
{
	angles = VectorToAngles( origin - self.origin );
	right = AnglesToRight( angles );

	if ( cointoss() )
	{
		error *= -1;
	}
	
	end = origin + right * error;

	//bot_debug_star( end, 1, ( 0, 1, 0 ) );

	time = GetTime();

	if ( time >= interval[0] )
	{
		self LookAt( end );
	}

	for( i = 0; i < interval.size; i++ )
	{
		if ( time == interval[i] )
		{
			self LookAt( end );
			break;
		}
	}
}

bot_on_target( enemy, radius, aim_target )
{
	angles = self GetPlayerAngles();
	forward = AnglesToForward( angles );

	origin = self GetPlayerCameraPos();

	len = Distance( aim_target, origin );
	end = origin + forward * len;

//	bot_debug_star( end, 1 );
//	bot_debug_star( enemy.origin, 1 );
//	bot_debug_star( aim_target, 1, ( 0, 1, 0 ) );

	dist = Distance2D( enemy.origin, end );
//	/# println( "dist: " + dist ); #/

	if ( Distance2DSquared( enemy.origin, end ) < radius * radius )
	{
		return true;
	}

	return false;
}

bot_calc_initial_error( enemy )
{
	angles = self GetPlayerAngles();
	forward = AnglesToForward( angles );

	len = Distance( enemy.origin, self.origin );

	origin = self.origin + forward * len;

	dist = Distance( origin, enemy.origin );
	error = bot_get_initial_aim_error();

	if ( dist < error )
	{
		return Max( dist, error / 3 );
	}

	return error;
}

bot_dot_product( player, origin )
{
	angles = player GetPlayerAngles();
	forward = AnglesToForward( angles );

	delta = origin - player GetPlayerCameraPos();
	delta = VectorNormalize( delta );

	dot = VectorDot( forward, delta );
	return dot;
}

bot_best_enemy( enemies )
{
	foreach( enemy in enemies )
	{
		if ( self BotSightTracePassed( enemy ) )
		{
			return enemy;
		}
	}

	return undefined;
}

bot_update_sight( enemy )
{
/*
	sight = BOT_CAN_SEE_NOTHING;
	
	if ( self BotSightTracePassed( enemy ) )
	{
		sight |= BOT_CAN_SEE_HEAD;
	}

	height = enemy GetPlayerViewHeight();
	torso = enemy.origin + ( 0, 0, height / 2 );
	
	if ( self BotSightTracePassed( enemy, torso ) )
	{
		sight |= BOT_CAN_SEE_TORSO;
	}

	feet = enemy.origin + ( 0, 0, 5 );
	
	if ( self BotSightTracePassed( enemy, feet ) )
	{
		sight |= BOT_CAN_SEE_FEET;
	}

	return sight;
*/

	return BOT_CAN_SEE_TORSO;
}

bot_update_aim( sight, enemy, dot )
{
	//frames = ( self.combat_interval * SERVER_FRAMES_PER_SEC ) + RandomIntRange( -self.enemy_prediction, self.enemy_prediction );

	//if ( bot_should_hip_fire( enemy ) )
	{
		frames = 4;
	}
		
	prediction = self PredictPosition( enemy, Int( frames ) );
	height = enemy GetPlayerViewHeight();

	if ( dot < 0.80 && sight & BOT_CAN_SEE_HEAD )
	{
		return prediction + ( 0, 0, height );
	}
	else if ( sight & BOT_CAN_SEE_TORSO )
	{
		torso = prediction + ( 0, 0, height / 2 );
		return torso;
	}
	else if ( sight & BOT_CAN_SEE_HEAD )
	{
		return prediction + ( 0, 0, height );
	}
	else if ( sight & BOT_CAN_SEE_FEET )
	{
		return prediction + ( 0, 0, 5 );
	}

	return undefined;
}

bot_update_cover( enemy, dot )
{
	// is he looking at me?
	if ( dot < 0.80 )
	{
		self CancelGoal( "cover" );
		self CancelGoal( "flee" );
		return;
	}

	if ( maps\mp\bots\_bot::bot_get_difficulty() == "easy" )
	{
		return;
	}

	ammo_frac = bot_weapon_ammo_frac();
	health_frac = bot_health_frac();

	cover_score = dot - ammo_frac - health_frac;

	if ( bot_should_hip_fire( enemy ) && !bot_has_shotgun() )
	{
		cover_score += 1;
	}

	if ( cover_score > 0.25 )
	{
		nodes = GetNodesInRadiusSorted( self.origin, 1024, 256, 512, "Path", 8 );
		nearest = bot_nearest_node( enemy.origin );

		if ( IsDefined( nearest ) && !self HasGoal( "flee" ) )
		{
			foreach( node in nodes )
			{
				if ( !NodesVisible( nearest, node ) && !NodesCanPath( nearest, node ) )
				{
					self CancelGoal( "cover" );
					self CancelGoal( "enemy_patrol" ); 
					self AddGoal( node, BOT_DEFAULT_GOAL_RADIUS, PRIORITY_URGENT, "flee" );
					return;
				}
			}
		}
	}
	else if ( cover_score > -0.25 )
	{
		if ( self HasGoal( "cover" ) )
		{
			return;
		}

		nodes = GetNodesInRadiusSorted( self.origin, 512, 0, 256, "Cover" );

		if ( !nodes.size )
		{
			nodes = GetNodesInRadiusSorted( self.origin, 256, 0, 256, "Path", 8 );
		}

		nearest = bot_nearest_node( enemy.origin );

		if ( IsDefined( nearest ) )
		{
			foreach( node in nodes )
			{
				if ( !CanClaimNode( node, self.team ) )
				{
					continue;
				}

				if ( node.type != "Path" && !within_fov( node.origin, node.angles, enemy.origin, bot_get_fov() ) )
				{
					continue;
				}

				if ( !NodesCanPath( nearest, node ) && NodesVisible( nearest, node ) )
				{
					if ( node.type == "Cover Left" )
					{
						right = AnglesToRight( node.angles );
						dir = VectorScale( right, 16 );

						node = node.origin - dir;
					}
					else if ( node.type == "Cover Right" )
					{
						right = AnglesToRight( node.angles );
						dir = VectorScale( right, 16 );

						node = node.origin + dir;
					}

					self CancelGoal( "flee" );
					self CancelGoal( "enemy_patrol" ); 
					self AddGoal( node, 8, PRIORITY_URGENT, "cover" );
					return;
				}
			}
		}
	}
	else if ( bot_has_shotgun() )
	{
		self AddGoal( enemy.origin, 128, PRIORITY_URGENT, "cover" );
	}
}

bot_update_attack( enemy, dot_from, dot_to, sight, aim_target )
{
	self AllowAttack( false );
	self PressAds( false );

	if ( sight == BOT_CAN_SEE_NOTHING )
	{
		return;
	}

	weapon = self GetCurrentWeapon();

	if ( weapon == "none" )
	{
		return;
	}
	
	radius = 50;

	if ( dot_to > BOT_ADS_DOT_EASY )
	{
		self PressAds( true );
	}
	
	ads = true;
	
	if ( bot_should_hip_fire( enemy ) )
	{
		self PressAds( false );
		ads = false;
		radius = 15;
	}


	if ( IsWeaponScopeOverlay( weapon ) && ads )
	{
		if ( self PlayerAds() < 1 )
		{
			self.ads_time = GetTime();
		}

		if ( GetTime() < self.ads_time + 1000 )
		{
			return;
		}
	}

	if ( /*self bot_on_target( enemy, radius, aim_target ) &&*/ ( !ads || self PlayerAds() >= 1 ) )
	{
		self AllowAttack( true );
	}
}

bot_weapon_ammo_frac()
{
	if ( self IsReloading() )
	{
		return 0;
	}
	
	weapon = self GetCurrentWeapon();

	if ( weapon == "none" )
	{
		return 1;
	}

	total = WeaponClipSize( weapon );

	if ( total <= 0 )
	{
		return 1;
	}
	
	current = self GetWeaponAmmoClip( weapon );

	return ( current / total );
}

bot_select_weapon()
{
	weapon = self GetCurrentWeapon();

	if ( weapon != "none" && weapon != "riotshield_mp" )
	{
		return;
	}

	if ( self IsReloading() || self IsThrowingGrenade() || self IsSwitchingWeapons() )
	{
		return;
	}

	if ( self IsMantling() || self IsOnLadder() || !self IsOnGround() )
	{
		return;
	}

	if ( self.spawn_weapon != "riotshield_mp" )
	{
		if ( self SwitchToWeapon( self.spawn_weapon ) )
		{
			return;
		}
	}

	primaries = self GetWeaponsListPrimaries();

	foreach( weapon in primaries )
	{
		if ( weapon == "riotshield_mp" )
		{
			continue;
		}

		if ( weapon == "knife_held_mp" )
		{
			continue;
		}

		if ( self SwitchToWeapon( weapon ) )
		{
			return;
		}
	}
}

bot_has_shotgun()
{
	if ( self IsReloading() )
	{
		return false;
	}

	weapon = self GetCurrentWeapon();

	if ( weapon == "none" )
	{
		return false;
	}

	return WeaponClass( weapon ) == "spread";
}

bot_health_frac()
{
	return ( self.health / self.maxhealth );
}

bot_should_hip_fire( enemy )
{
	weapon = self GetCurrentWeapon();

	if ( weapon == "none" )
	{
		return false;
	}

	class = WeaponClass( weapon );

	distSq = DistanceSquared( self.origin, enemy.origin );
	distCheck = 0;

	switch( class )
	{
		case "mg":
			distCheck = 250;
		break;

		case "smg":
			distCheck = 350;
		break;

		case "spread":
			distCheck = 400;
		break;

		case "pistol":
			distCheck = 200;
		break;

		case "rocketlauncher":
			distCheck = 0;
		break;

		case "rifle":
		default:
			distCheck = 300;
		break;
	}

	if ( IsWeaponScopeOverlay( weapon ) )
	{
		// sniper
		distCheck = 500;
	}

	return ( distSq < distCheck * distCheck );
}

bot_patrol_near_enemy( damage, attacker, direction )
{
	if ( IsPlayer( attacker ) )
	{
		self LookAt( attacker GetCentroid() );
	}

	if ( maps\mp\bots\_bot::bot_get_difficulty() == "easy" )
	{
		return;
	}
	
	if ( !IsDefined( attacker ) || !IsPlayer( attacker ) )
	{
		attacker = self maps\mp\bots\_bot::bot_get_closest_enemy( self.origin, true );
	}

	if ( !IsDefined( attacker ) )
	{
		return;
	}

	node = bot_nearest_node( attacker.origin );

	if ( !IsDefined( node ) )
	{
		nodes = GetNodesInRadiusSorted( attacker.origin, 1024, 0, 512, "Path", 8 );

		if ( nodes.size )
		{
			node = nodes[0];
		}
	}

	if ( IsDefined( node ) )
	{
		nearest = GetNearestNode( self.origin );

		if ( IsDefined( damage ) && IsDefined( nearest ) && NodesVisible( nearest, node ) )
		{
			self LookAt( node.origin + ( 0, 0, 32 ) );
		}

		if ( IsDefined( damage ) )
		{
			self AddGoal( node, BOT_DEFAULT_GOAL_RADIUS, PRIORITY_URGENT, "enemy_patrol" );
		}
		else
		{
			self AddGoal( node, BOT_DEFAULT_GOAL_RADIUS, PRIORITY_NORMAL, "enemy_patrol" );
		}
	}
}

bot_nearest_node( origin )
{
	nodes = GetNodesInRadiusSorted( origin, 512, 0, 512, "Path", 8 );

	if ( nodes.size )
	{
		return nodes[0];
	}

	return undefined;
}

bot_combat_throw_lethal( origin )
{
	weapons = self GetWeaponsList();

	radius = EXPLOSION_RADIUS_FRAG;

	if ( self HasPerk( "specialty_flakjacket" ) )
	{
		radius *= 0.25;
	}

	if ( DistanceSquared( self.origin, origin ) < radius * radius )
	{
		return false;
	}

	foreach( weapon in weapons )
	{
		if ( self GetWeaponAmmoStock( weapon ) <= 0 )
		{
			continue;
		}

		if ( weapon == "frag_grenade_mp" || weapon == "sticky_grenade_mp" )
		{
			if ( self ThrowGrenade( weapon, origin ) )
			{
				return true;
			}
		}
	}

	return false;
}

bot_combat_throw_tactical( origin )
{
	weapons = self GetWeaponsList();

	if ( !self HasPerk( "specialty_flashprotection" ) )
	{
		if ( DistanceSquared( self.origin, origin ) < EXPLOSION_RADIUS_FLASH * EXPLOSION_RADIUS_FLASH )
		{
			return false;
		}
	}

	foreach( weapon in weapons )
	{
		if ( self GetWeaponAmmoStock( weapon ) <= 0 )
		{
			continue;
		}

		if ( weapon == "flash_grenade_mp" || weapon == "concussion_grenade_mp" )
		{
			if ( self ThrowGrenade( weapon, origin ) )
			{
				return true;
			}
		}
	}

	return false;
}

bot_combat_throw_smoke( origin )
{
	return ( self ThrowGrenade( "willy_pete_mp", origin ) );
}

bot_combat_throw_proximity( origin )
{
	return ( self ThrowGrenade( "proximity_grenade_mp", origin ) );
}

bot_combat_tactical_insertion( origin )
{
	return ( self ThrowGrenade( "tactical_insertion_mp", origin ) );
}
