#using scripts\codescripts\struct;

    	   	                                                                                                                         	                                                                                                                                                                                                                                                                                                                                                                    	        	     	             	    	   	                           	                               	                                	                                                              	                                                                                                              	                            	                                     	                                       	                                                               	   	                  	       	                                                    	                   	                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                       	                                                                                        	           	                        	                                            	                                             	                                                   	                                                             	                                                         	                                                                    	                                                                                                                                                                                                    	                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                     	                                                              	                                                          	                                   	                                   	                                                    	                                       

#using scripts\shared\array_shared;
#using scripts\shared\callbacks_shared;
#using scripts\shared\killstreaks_shared;
#using scripts\shared\math_shared;
#using scripts\shared\system_shared;
#using scripts\shared\util_shared;
#using scripts\shared\weapons_shared;


// matches the enum in bot.h













	// 65 degrees
	// 85 degrees
	// 100 degrees
	// 160 degrees










































//Must match code (hkai_influence.h)
	//bullet impacts
	//ai positions
	//player positions






#namespace zm_bot;

function autoexec __init__sytem__() {     system::register("zm_bot",&__init__,undefined,undefined);    }

function __init__()
{
/#	PrintLn( "ZM >> Zombiemode Server Scripts Init (_zm_bot.gsc)" );	#/
}

function movement_think()
{
	for ( ;; )
	{
	/*	if( !isdefined(self.bot.threat.entity) )
		{
			//follow player
			posToUse = self getinfluencepos( INFLUENCE_MAP_INDEX_PLAYER_POS, 0.1, 0.3 );

			self AddGoal( posToUse, 64.0, PRIORITY_HIGH, "follow_player" );
			if ( self AtGoal( "follow_player" ) )
			{
				self CancelGoal( "follow_player" ); 
			}
			wait( 2.0 );
		}*/



		//Else track enemies

		//Try to stay a little bit away from zombies
		//posToUse = self getinfluencepos( INFLUENCE_MAP_INDEX_ACTOR_POS, 0.01, 0.1 );

		//self AddGoal( posToUse, 64.0, PRIORITY_HIGH, "follow_zombies" );

		if ( self AtGoal( "follow_zombies" ) )
		{
			self CancelGoal( "follow_zombies" ); 
		}

		wait( 0.5 );
	}
}

function spawn_init()
{
	time = GetTime();

	if ( !isdefined( self.bot ) )
	{
		self.bot		= SpawnStruct();
		self.bot.threat = SpawnStruct();
	}

	// behaviors
	self.bot.glass_origin				= undefined;
	self.bot.ignore_entity				= [];
	self.bot.previous_origin			= self.origin;
	self.bot.time_ads					= 0;
	self.bot.update_c4					= time + RandomIntRange( 1000, 3000 );
	self.bot.update_crate				= time + RandomIntRange( 1000, 3000 );
	self.bot.update_crouch				= time + RandomIntRange( 1000, 3000 );
	self.bot.update_failsafe			= time + RandomIntRange( 1000, 3000 );
	self.bot.update_idle_lookat			= time + RandomIntRange( 1000, 3000 );
	self.bot.update_killstreak			= time + RandomIntRange( 1000, 3000 );
	self.bot.update_lookat				= time + RandomIntRange( 1000, 3000 );
	self.bot.update_objective			= time + RandomIntRange( 1000, 3000 );
	self.bot.update_objective_patrol	= time + RandomIntRange( 1000, 3000 );
	self.bot.update_patrol				= time + RandomIntRange( 1000, 3000 );
	self.bot.update_toss				= time + RandomIntRange( 1000, 3000 );
	self.bot.update_launcher			= time + RandomIntRange( 1000, 3000 );
	self.bot.update_weapon				= time + RandomIntRange( 1000, 3000 );

	difficulty = "easy";

	switch( difficulty )
	{
		case "easy":
			self.bot.think_interval = 0.5;
			self.bot.fov = 0.4226;
		break;
				
		case "normal":
			self.bot.think_interval = 0.25;
			self.bot.fov = 0.0872;
		break;

		case "hard":
			self.bot.think_interval = 0.2;
			self.bot.fov = -0.1736;
		break;

		case "fu":
			self.bot.think_interval = 0.1;
			self.bot.fov = -0.9396;
		break;

		default:
			self.bot.think_interval = 0.25;
			self.bot.fov = 0.0872;
		break;
	}
	
	// combat
	self.bot.threat.entity				= undefined;
	self.bot.threat.position			= ( 0, 0, 0 );
	self.bot.threat.time_first_sight	= 0;
	self.bot.threat.time_recent_sight	= 0;
	self.bot.threat.time_aim_interval	= 0;
	self.bot.threat.time_aim_correct	= 0;
	self.bot.threat.update_riotshield	= 0;
	
	self thread zm_bot::combat_think();
	self thread zm_bot::movement_think();	
}

function get_fov()
{
	weapon = self GetCurrentWeapon();
	reduction = 1;

	if ( weapon != level.weaponNone && weapon.isScopeOverlay && self PlayerAds() >= 1 )
	{
		reduction = 0.25;
	}

	return self.bot.fov * reduction;
}

function dot_product( origin )
{
	angles = self GetPlayerAngles();
	forward = AnglesToForward( angles );

	delta = origin - self GetPlayerCameraPos();
	delta = VectorNormalize( delta );

	dot = VectorDot( forward, delta );
	return dot;
}

function getOtherTeam( team )
{
	// TODO MTEAM - Need to fix this.
	if ( team == "allies" )
		return "axis";
	else if ( team == "axis" )
		return "allies";
	else // all other teams
		return "allies";
		
	assertMsg( "getOtherTeam: invalid team " + team );
}

function threat_should_ignore( entity )
{
	ignore_time = self.bot.ignore_entity[ entity GetEntityNumber() ];
	
	if ( isdefined( ignore_time ) )
	{
		if ( GetTime() < ignore_time )
		{
			return true;
		}
	}

	return false;
}

function clear_enemy()
{
	self ClearLookAt();
	self BotClearMeleeChargeEnt();
	self.bot.threat.entity = undefined;
}

function best_enemy()
{
	fov = get_fov();
	ent = self.bot.threat.entity;
	
	//Check for any really close zombies
	team = getOtherTeam( self.team );
	actors = GetAITeamArray( team );
	closeenemies = [];

	angles = self GetPlayerAngles();

	foreach( actor in actors )
	{
		distSq = DistanceSquared( self.origin, actor.origin );
		
		if( distSq < 1024.0 )
		{
			//Kill this zombie
			dot = dot_product( actor.origin );
			self.bot.threat.time_recent_sight = GetTime();
			self.bot.threat.dot = dot; 
			return true;
		}
	}	

	if ( isdefined( ent ) )
	{
		if ( IsPlayer( ent ) || IsActor( ent ) )
		{
			dot = dot_product( ent.origin );

			if ( dot >= fov )
			{
				if ( self BotSightTracePassed( ent ) )
				{
					self.bot.threat.time_recent_sight = GetTime();
					self.bot.threat.dot = dot; 
					return true;
				}
			}
		}
	}

	//team = getOtherTeam( self.team );
//	actors = GetAITeamArray( team );
	enemies = [];

//	angles = self GetPlayerAngles();

	foreach( actor in actors )
	{
		//if ( util::within_fov( self.origin, angles, actor.origin, fov ) )
		{
			enemies[ enemies.size ] = actor;
		}
	}

	foreach( enemy in enemies )
	{
		if ( threat_should_ignore( enemy ) )
		{
			continue;
		}

		if ( !IsPlayer( enemy ) && enemy.classname != "grenade" )
		{
			if ( level.gameType == "hack" )
			{
				if ( enemy.classname == "script_vehicle" )
				{
					continue;
				}
			}

			if ( enemy.classname == "auto_turret" )
			{
				if ( ( isdefined( enemy.dead ) && enemy.dead ) || ( isdefined( enemy.carried ) && enemy.carried ) )
				{
					continue;
				}

				if ( !( isdefined( enemy.turret_active ) && enemy.turret_active ) )
				{
					continue;
				}
			}

			/*if ( threat_requires_rocket( enemy ) )
			{
				if ( !has_launcher() )
				{
					continue;
				}

				origin = self GetPlayerCameraPos();
				angles = VectorToAngles( enemy.origin - origin );

				if ( angles[0] < 290 )
				{
					threat_ignore( enemy, 3.5 );
					continue;
				}
			}*/
		}

		if ( self BotSightTracePassed( enemy ) )
		{
			self.bot.threat.entity = enemy;
			self.bot.threat.time_first_sight = GetTime();
			self.bot.threat.time_recent_sight = GetTime();
			self.bot.threat.dot = dot_product( enemy.origin ); 
			self.bot.threat.position = enemy.origin; 
			return true;
		}
	}

	return false;
}

function threat_is_ai()
{
	ent = self.bot.threat.entity;
	return ( isdefined( ent ) && IsAI( ent ) );
}

function threat_is_player()
{
	ent = self.bot.threat.entity;
	return ( isdefined( ent ) && IsPlayer( ent ) );
}

function has_melee_weapon()
{
	weapon = self GetCurrentWeapon();

	if ( weapon.name == "fhj18" )
	{
		if ( isdefined( self.bot.threat.entity ) && !Target_IsTarget( self.bot.threat.entity ) )
		{
			return true;
		}
	}

	return ( weapon.isRiotShield || weapon == level.weaponBaseMeleeHeld );
}


function should_hip_fire()
{
	enemy = self.bot.threat.entity;
	weapon = self GetCurrentWeapon();

	if ( weapon == level.weaponNone )
	{
		return false;
	}

	if ( weapon.isDualWield )
	{
		return true;
	}

	weaponclass = weapon.weapClass;

	if ( IsPlayer( enemy ) && weaponclass == "spread" )
	{
		return true;
	}

	distSq = DistanceSquared( self.origin, enemy.origin );
	distCheck = 0;

	switch( weaponclass )
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

	if ( weapon.isScopeOverlay )
	{
		// sniper
		distCheck = 500;
	}

	return ( distSq < distCheck * distCheck );
}

function get_converge_time()
{
	difficulty = "easy";

	switch( difficulty )
	{
		case "easy":
			return 3.5 * 1000;
		break;

		case "normal":
			return 2 * 1000;
		break;

		case "hard":
			return 1.5 * 1000;
		break;

		case "fu":
			return 0.1 * 1000;
		break;
	}

	return 2 * 1000;
}

function get_converge_rate()
{
	difficulty = "easy";

	switch( difficulty )
	{
		case "easy":
			return 2;
		break;

		case "normal":
			return 4;
		break;

		case "hard":
			return 5;
		break;

		case "fu":
			return 7;
		break;
	}

	return 4;
}

function update_aim( frames )
{
	ent = self.bot.threat.entity;
	prediction = self PredictPosition( ent, frames );

	/*if ( using_launcher() && !threat_requires_rocket( ent ) )
	{
		return prediction - ( 0, 0, RandomIntRange( 0, 10 ) );
	}*/
	
	if ( !threat_is_player() )
	{
		height = ent GetCentroid()[2] - prediction[2];
		return prediction + ( 0, 0, height );
	}
		
	height = ent GetPlayerViewHeight();

	/*if ( threat_using_riotshield() )
	{
		dot = ent dot_product( self.origin ); 

		if ( dot > 0.8 && ent GetStance() == "stand" )
		{
			return prediction + ( 0, 0, 5 );
		}
	}*/

	torso = prediction + ( 0, 0, height / 1.6 );
	return torso;
}


function get_look_at()
{
	enemy = self get_closest_enemy( self.origin, true );

	if ( isdefined( enemy ) )
	{
		node = GetVisibleNode( self.origin, enemy.origin );

		if ( isdefined( node ) && DistanceSquared( self.origin, node.origin ) > 32 * 32 )
		{
			return node.origin;
		}
	}

	enemies = self get_enemies( false );

	if ( enemies.size )
	{
		enemy = array::random( enemies );
	}

	if ( isdefined( enemy ) )
	{
		node = GetVisibleNode( self.origin, enemy.origin );

		if ( isdefined( node ) && DistanceSquared( self.origin, node.origin ) > 32 * 32 )
		{
			return node.origin;
		}
	}

	spawn = self GetGoal( "wander" );

	if ( isdefined( spawn ) )
	{
		node = GetVisibleNode( self.origin, spawn );
	}
	
	if ( isdefined( node ) && DistanceSquared( self.origin, node.origin ) > 32 * 32 )
	{
		return node.origin;
	}

	return undefined;
}



function get_aim_error()
{
	difficulty = "easy";

	switch( difficulty )
	{
		case "easy":
			return 30;
		break;

		case "normal":
			return 20;
		break;

		case "hard":
			return 15;
		break;

		case "fu":
			return 2;
		break;
	}

	return 20;
}



function update_lookat( origin, frac )
{
	angles = VectorToAngles( origin - self.origin );
	right = AnglesToRight( angles );
	error = get_aim_error() * ( 1 - frac );

	if ( math::cointoss() )
	{
		error *= -1;
	}

	height = origin[2] - self.bot.threat.entity.origin[2];
	height *= ( 1 - frac );

	if ( math::cointoss() )
	{
		height *= -1;
	}
		
	end = origin + right * error;
	end = end + ( 0, 0, height );

	red = ( 1 - frac );
	green = frac;
	//bot::debug_star( end, 1, ( red, green, 0 ) );

	self LookAt( end );
}



function on_target( aim_target, radius )
{
	angles = self GetPlayerAngles();
	forward = AnglesToForward( angles );

	origin = self GetPlayerCameraPos();

	len = Distance( aim_target, origin );
	end = origin + forward * len;

	if ( Distance2DSquared( aim_target, end ) < radius * radius )
	{
		//bot::debug_star( end, 1, ( 0, 1, 0 ) );
		//bot::debug_star( aim_target, 1, ( 0, 0, 1 ) );
		return true;
	}

	//bot::debug_star( end, 1, ( 1, 0, 0 ) );
	//bot::debug_star( aim_target, 1, ( 0, 0, 1 ) );
	return false;
}

function combat_main()
{
	weapon = self GetCurrentWeapon();
	currentAmmo = self GetWeaponAmmoClip( weapon ) + self GetWeaponAmmoStock( weapon );

	if ( !currentAmmo || has_melee_weapon() )
	{
		if ( threat_is_player() || threat_is_ai() )
		{
			// TODO combat_melee( weapon );
		}
		return;
	}

	time = GetTime();
	ads = ( !should_hip_fire() && self.bot.threat.dot > 0.96 ); 
	difficulty = "easy";

	if ( ads )
	{
		self PressAds( true );
	}
	else
	{
		self PressAds( false );
	}

	if ( ads && self PlayerAds() < 1 )
	{
		ratio = Int( Floor( get_converge_time() / get_converge_rate() ) );
		step = ratio % 50;

		self.bot.threat.time_aim_interval = ratio - step;
		self.bot.threat.time_aim_correct = time;

		ideal = update_aim( 4 );
		update_lookat( ideal, 0 );

		return;
	}

	frames = 4;
	frames += RandomIntRange( 0, 3 );

	if ( difficulty != "fu" )
	{
		if ( DistanceSquared( self.bot.threat.entity.origin, self.bot.threat.position ) > 15 * 15 )
		{
			self.bot.threat.time_aim_correct = time;

			if ( time > self.bot.threat.time_first_sight )
			{
				self.bot.threat.time_first_sight = time - 100;
			}
		}
	}
	
	if ( time >= self.bot.threat.time_aim_correct )
	{
		self.bot.threat.time_aim_correct += self.bot.threat.time_aim_interval;
		
		frac = ( time - self.bot.threat.time_first_sight ) / get_converge_time();
		frac = math::clamp( frac, 0, 1 );

		if ( !threat_is_player() )
		{
			frac = 1;
		}
		
		self.bot.threat.aim_target = update_aim( frames );
		self.bot.threat.position = self.bot.threat.entity.origin;
		
		update_lookat( self.bot.threat.aim_target, frac );
	}

	if ( difficulty == "hard" || difficulty == "fu" )
	{
		if ( on_target( self.bot.threat.entity.origin, 30 ) )
		{
			self AllowAttack( true );
		}
		else
		{
			self AllowAttack( false );
		}
	}
	else
	{
		if ( on_target( self.bot.threat.aim_target, 45 ) )
		{
			self AllowAttack( true );
		}
		else
		{
			self AllowAttack( false );
		}
	}

	/*if ( threat_is_equipment() )
	{
		if ( on_target( self.bot.threat.entity.origin, 3 ) )
		{
			self AllowAttack( true );
		}
		else
		{
			self AllowAttack( false );
		}
	}*/

	if ( ( isdefined( self.stingerLockStarted ) && self.stingerLockStarted ) )
	{
		self AllowAttack( self.stingerLockFinalized );
		return;
	}
			
	if ( threat_is_player() )
	{
		if ( self IsCarryingTurret() && self.bot.threat.dot > 0 )
		{
			self PressAttackButton();
		}
		
		if ( self.bot.threat.dot > 0 && Distance2DSquared( self.origin, self.bot.threat.entity.origin ) < get_melee_range_sq( weapon ) )
		{
			self AddGoal( self.bot.threat.entity.origin, 24, 4, "enemy_patrol" );
			self PressMelee();
		}
	}

	/*if ( threat_using_riotshield() )
	{
		self riotshield_think( self.bot.threat.entity );
	}
	else if ( has_shotgun() )
	{
		self shotgun_think();
	}*/
}


function get_enemies( on_radar )
{
	if ( !isdefined( on_radar ) )
	{
		on_radar = false;
	}

	enemies = self GetEnemies( true );

/#
	for ( i = 0; i < enemies.size; i++ )
	{
		if ( enemies[i] IsInMoveMode( "ufo", "noclip" ) )
		{
			ArrayRemoveIndex( enemies, i );
			i--;
		}
	}
#/

	/*if ( on_radar && !self has_radar() )
	{
		for ( i = 0; i < enemies.size; i++ )
		{
			if ( !isdefined( enemies[i].lastFireTime ) )
			{
				ArrayRemoveIndex( enemies, i );
				i--;
			}
			else if ( GetTime() - enemies[i].lastFireTime > 2000 ) 
			{
				ArrayRemoveIndex( enemies, i );
				i--;
			}
		}
	}*/

	return enemies;
}


function get_closest_enemy( origin, on_radar )
{
	enemies = self get_enemies( on_radar );
	enemies = ArraySort( enemies, origin );

	if ( enemies.size )
	{
		return enemies[0];
	}

	return undefined;
}


function get_melee_range_sq( weapon )
{
	rangeAdjustment = 1.0;

	player_meleeRange = 0;

	if( Int(GetDvarString("bot_AllowMeleeCharge") ) && isDefined( weapon ) )
	{
		player_meleeRange = weapon.meleeChargeRange;
	}
	
	if( player_meleeRange == 0 )
	{
		difficulty = "easy";


		switch( difficulty )
		{
			case "easy":
				rangeAdjustment = 0.73;
			break;

			case "normal":
				rangeAdjustment = 1.0;
			break;

			case "hard":
				rangeAdjustment = 1.0;
			break;

			case "fu":
				rangeAdjustment = 1.0;
			break;
		}

		player_meleeRange = Int(GetDvarString("player_meleeRange"));
	}
	assert( IsDefined(player_meleeRange) );

	return ( rangeAdjustment * player_meleeRange ) * ( rangeAdjustment * player_meleeRange );
}


function combat_dead( damage )
{
	difficulty = "easy";

	switch( difficulty )
	{
		case "easy":
			wait( 0.75 );
		break;

		case "normal":
			wait( 0.5 );
		break;

		case "hard":
			wait( 0.25 );
		break;

		case "fu":
			wait( 0.1 );
		break;
	}
	
	self AllowAttack( false );

	switch( difficulty )
	{
		case "easy":
		case "normal":
			wait( 1 );
		break;

		case "hard":
			util::wait_endon( 0.5, "damage" );
		break;

		case "fu":
			util::wait_endon( 0.25, "damage" );
		break;
	}
	
	clear_enemy();
}

function combat_idle( ) // damage, attacker, direction )
{
	self PressAds( false );
	self AllowAttack( false );
	self AllowSprint( true );
	clear_enemy();

	/*weapon = self GetCurrentWeapon();
	
	if ( can_reload() )
	{
		frac = 0.5;

		if ( has_lmg() )
		{
			frac = 0.25;
		}

		frac += RandomFloatRange( -0.1, 0.1 );

		if ( weapon_ammo_frac() < frac )
		{
			self PressUseButton( 0.1 );
		}
	}*/

	/*if ( isdefined( damage ) )
	{
		patrol_near_enemy( damage, attacker, direction );
		return;
	}*/

	self CancelGoal( "cover" );
	self CancelGoal( "flee" );
}


function has_enemy()
{
	return ( isdefined( self.bot.threat.entity ) );
}


function threat_dead()
{
	if ( has_enemy() )
	{
		ent = self.bot.threat.entity;

		/*if ( threat_is_turret() )
		{
			return IS_TRUE( ent.dead );
		}
		else if ( threat_is_qrdrone() )
		{
			return IS_TRUE( ent.crash_accel );
		}*/

		return ( !IsAlive( ent ) );
	}

	return true;
}

function combat_think()
{
	self AllowAttack( false );
	self PressAds( false );
		
	for ( ;; )
	{
	/*if ( self AtGoal( "enemy_patrol" ) )
		{
			self CancelGoal( "enemy_patrol" ); 
		}

		self bot::update_failsafe();
		self bot::update_crouch();
		self bot::update_crate();

		if ( !can_do_combat() )
		{
			return;
		}

		difficulty = "easy";

/#
		if ( has_enemy() )
		{
			if ( GetDvarInt( "bot_IgnoreHumans" ) )
			{
				if ( IsPlayer( self.bot.threat.entity ) && !self.bot.threat.entity util::is_bot() )
				{
					self combat_idle();
				}
			}
		}
#/
*/
		sight = best_enemy();
	//	select_weapon();

		ent = self.bot.threat.entity;
		pos = self.bot.threat.position;
		
		/* if( !sight )
		 {
			clear_enemy();
		 	wait( 1.0 );
		 	continue;
		 }*/


		if ( !sight )
		{
			if ( threat_is_player() )
			{
				if ( DistanceSquared( self.origin, ent.origin ) < 256 * 256 )
				{
					prediction = self PredictPosition( ent, 4 );
					height = ent GetPlayerViewHeight();
					
					self LookAt( prediction + ( 0, 0, height ) );
					self AddGoal( ent.origin, 24, 4, "enemy_patrol" );
					self AllowAttack( false );

					{wait(.05);};
					continue;
				}
				else
				{
					self AddGoal( self.origin, 24, 3, "enemy_patrol" );

					/*if ( difficulty != "easy" && math::cointoss() )
					{
						self combat_throw_lethal( pos );
						self combat_throw_tactical( pos );
					}*/
					
					combat_dead();
					self AddGoal( pos, 24, 4, "enemy_patrol" );
				}
			}
			
			combat_idle( );//damage, attacker, direction );
		}
		else if ( threat_dead() )
		{
			combat_dead();
		}
		else
		{

		//update_cover();
			combat_main();
		}
		/*if ( threat_is_turret() )
		{
			turret_set_dangerous( ent );
			combat_throw_smoke( ent.origin );
		}

		if ( threat_is_turret() || threat_is_ai_tank() || threat_is_equipment() )
		{
			combat_throw_emp( ent.origin );
			combat_throw_lethal( ent.origin );
		}
		else if ( threat_is_qrdrone() )
		{
			combat_throw_emp( ent.origin );
		}
		else if ( threat_requires_rocket( ent ) )
		{
			self CancelGoal( "enemy_patrol" ); 
			self AddGoal( self.origin, BOT_DEFAULT_GOAL_RADIUS, PRIORITY_URGENT, "cover" );
		}
						
		if ( difficulty == "easy" )
		{
			wait( 0.5 );
		}
		else if ( difficulty == "normal" )
		{
			wait( 0.25 );
		}
		else if ( difficulty == "hard" )
		{
			wait( 0.1 );
		}
		else*/
		{
			{wait(.05);};
		}
	}
}
