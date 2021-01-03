#using scripts\shared\array_shared;
#using scripts\shared\math_shared;
#using scripts\shared\util_shared;
#using scripts\shared\weapons_shared;
#using scripts\shared\weapons\_weapon_utils;
#using scripts\shared\weapons\_weapons;

    	   	                                                                                                                                         	                                	                                                                                                                                                                                                                                                                                                                                                                    	        	     	             	    	   	               	                                              	                                                           	                               	                     	                                                                                                           	                                                                 	                                                              	                                                                                                              	                            	                                     	                                       	                                                                                                              	   	                  	       	                                                    	                   	                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                        	                                  	                                                                                        	           	                        	                                            	                                             	                                                   	                                                             	                                                         	                                                                    	                                                                                                                                                                                                    	                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                         	                                                              	                                                          	                                   	                                   	                                                    	                                       	                                           	     	                                                                                                                                                                                                                                                      	                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                     
                                                                                                  	  	                          	                                         	                     	                 	                                                                         	                       	                                                      	                                                      	                                                       	                                                                                                  	                                                           	                 	                                                                                                           	                	                                          	                                      	       	  	             	                                                     	                                                                             	                         	                                                                	                                                             	                                                             	                                                                                      	                                                         	                                                         	                                                               	                                                               	                                                   	                                                                	                                                     	                                                	                                                	                                                        	                                                                                                  	                                                                             	                                            	                                                                                    	                                          	                     	                                              	                                        	         	     

#using scripts\mp\_util;
#using scripts\mp\bots\_bot;

                                               	               	               	                	                                                               



	
#namespace bot_combat;

function combat_think( damage, attacker, direction )
{
	self AllowAttack( false );
	self PressAds( false );
		
	for ( ;; )
	{
		if ( self AtGoal( "enemy_patrol" ) )
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

		difficulty = bot::get_difficulty();

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

		sight = best_enemy();
		select_weapon();

		ent = self.bot.threat.entity;
		pos = self.bot.threat.position;
		
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

					if ( difficulty != "easy" && math::cointoss() )
					{
						self combat_throw_lethal( pos );
						self combat_throw_tactical( pos );
					}
					
					combat_dead();
					self AddGoal( pos, 24, 4, "enemy_patrol" );
				}
			}
			
			combat_idle( damage, attacker, direction );
			return;
		}
		else if ( threat_dead() )
		{
			combat_dead();
			return;
		}

		update_cover();
		combat_main();

		if ( threat_is_turret() )
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
			self AddGoal( self.origin, 24, 4, "cover" );
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
		else
		{
			{wait(.05);};
		}
	}
}

function can_do_combat()
{
	if ( self IsMantling() || self IsOnLadder() )
	{
		return false;
	}

	return true;
}

function threat_dead()
{
	if ( has_enemy() )
	{
		ent = self.bot.threat.entity;

		if ( threat_is_turret() )
		{
			return ( isdefined( ent.dead ) && ent.dead );
		}
		else if ( threat_is_qrdrone() )
		{
			return ( isdefined( ent.crash_accel ) && ent.crash_accel );
		}

		return ( !IsAlive( ent ) );
	}

	return true;
}

function can_reload()
{
	weapon = self GetCurrentWeapon();

	if ( weapon == level.weaponNone )
	{
		return false;
	}

	if ( !self GetWeaponAmmoStock( weapon ) )
	{
		return false;
	}

	if ( self IsReloading() || self IsSwitchingWeapons() || self IsThrowingGrenade() )
	{
		return false;
	}

	return true;
}

function combat_idle( damage, attacker, direction )
{
	self PressAds( false );
	self AllowAttack( false );
	self AllowSprint( true );
	//clear_enemy();

	weapon = self GetCurrentWeapon();
	
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
	}

	if ( isdefined( damage ) )
	{
		patrol_near_enemy( damage, attacker, direction );
		return;
	}

	self CancelGoal( "cover" );
	self CancelGoal( "flee" );
}

function combat_dead( damage )
{
	difficulty = bot::get_difficulty();

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

function combat_main()
{
	weapon = self GetCurrentWeapon();
	currentAmmo = self GetWeaponAmmoClip( weapon ) + self GetWeaponAmmoStock( weapon );

	if ( !currentAmmo || has_melee_weapon() )
	{
		if ( threat_is_player() || threat_is_dog() )
		{
			combat_melee( weapon );
		}
		return;
	}

	time = GetTime();
	ads = ( !should_hip_fire() && self.bot.threat.dot > 0.96 ); 
	difficulty = bot::get_difficulty();

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

	if ( threat_is_equipment() )
	{
		if ( on_target( self.bot.threat.entity.origin, 3 ) )
		{
			self AllowAttack( true );
		}
		else
		{
			self AllowAttack( false );
		}
	}

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
		
		if ( self.bot.threat.dot > 0 )
		{
			if ( Distance2DSquared( self.origin, self.bot.threat.entity.origin ) < get_melee_range_sq( weapon ) )
		    {
				self CancelGoal( "enemy_patrol" );
				self LookAt( self.bot.threat.entity getCentroid() );
				self PressMelee();
		    }
		    else
		    {
		    	self AddGoal( self.bot.threat.entity.origin, 24, 4, "enemy_patrol" );
		    }
		}
	}

	if ( threat_using_riotshield() )
	{
		self riotshield_think( self.bot.threat.entity );
	}
	else if ( has_shotgun() )
	{
		self shotgun_think();
	}
}

function combat_melee( weapon )
{
	if ( !threat_is_player() && !threat_is_dog() )
	{
		threat_ignore( self.bot.threat.entity, 60 );
		self clear_enemy();
		return;
	}

	self CancelGoal( "cover" );
	self PressAds( false );
	self AllowAttack( false );

	maxTryingTime = RandomIntRange(1000, 1500);
	startTryingTime = GetTime();

	for ( ; GetTime() - startTryingTime <= maxTryingTime; )
	{
		if ( !IsAlive( self.bot.threat.entity ) )
		{
			self clear_enemy();
			self CancelGoal( "enemy_patrol" );
			return;
		}

		if ( self IsThrowingGrenade() || self IsSwitchingWeapons() )
		{
			self CancelGoal( "enemy_patrol" );
			return;
		}

		if ( !has_melee_weapon() && self GetWeaponAmmoClip( weapon ) )
		{
			self CancelGoal( "enemy_patrol" );
			return;
		}
		
		frames = 4;
				
		prediction = self PredictPosition( self.bot.threat.entity, frames );

		if ( !IsPlayer( self.bot.threat.entity ) )
		{
			height = self.bot.threat.entity getCentroid()[2] - prediction[2];
			return prediction + ( 0, 0, height );
		}
		else
		{
			height = self.bot.threat.entity GetPlayerViewHeight();
		}
				
		self LookAt( prediction + ( 0, 0, height ) );

		dot = self.bot.threat.entity dot_product( self GetEye() );

		if ( dot < 0.2 && RandomIntRange(0,1000) > 999 )
		{
			if ( change_to_none_melee_weapon() )
			{
				return;
			}
		}
	
		distsq = Distance2DSquared( self.origin, prediction );
		dot = dot_product( self.bot.threat.entity.origin ); 
		
		if ( dot > 0 && distsq < get_melee_range_sq( weapon ) )
		{
			if ( self.bot.threat.entity GetStance() == "prone" )
			{
				self SetStance( "crouch" );
			}

			if ( weapon == level.weaponBaseMeleeHeld )
			{
				self BotSetMeleeChargeEnt( self.bot.threat.entity );
				self PressAttackButton();
				wait( 0.1 );
			}
			else
			{
				self PressMelee();
				wait( 0.1 );
			}
		}

		goal = self GetGoal( "enemy_patrol" );

		melee_enemy_patrol_tolerance = 4;

		if ( !isdefined( goal ) || DistanceSquared( prediction, goal ) > get_melee_range_sq( weapon ) - melee_enemy_patrol_tolerance )
		{
			if ( !self FindPath( self.origin, prediction, false, true ) )
			{
				selfNode = GetNearestNode( self.origin );
				enemyNode = GetNearestNode( prediction );

				if ( !isdefined(selfNode) || !isdefined(enemyNode) || selfNode != enemyNode )
				{
					if ( !change_to_none_melee_weapon() )
					{
						if ( isdefined(selfNode) )
						{
							self.bot.lastAvailableNode = selfNode;
							self AddGoal( prediction, melee_enemy_patrol_tolerance, 4, "enemy_patrol" );
						}
						
						if ( !isdefined(self.meleeStuckTime) || self.meleeStuckTime <= 0 )
						{
							self.meleeStuckTime = GetTime();
						}
						else if ( GetTime() - self.meleeStuckTime > 3000 )
						{
							threat_ignore( self.bot.threat.entity, 10 );
							self clear_enemy();
							self CancelGoal( "enemy_patrol" );
							self.meleeStuckTime = 0;
							
							if ( isdefined(self.bot.lastAvailableNode) )
							{
								self AddGoal( self.bot.lastAvailableNode, melee_enemy_patrol_tolerance, 4, "flee" );
							}
						}
					}
					wait(0.5);
					continue;
				}
			}

			if ( weapon.isRiotShield )
			{
				if ( bot::get_difficulty() != "easy" )
				{
					self SetStance( "crouch" );
					self AllowSprint( false );
				}
			}

			self AddGoal( prediction, melee_enemy_patrol_tolerance, 4, "enemy_patrol" );
		}

		{wait(.05);};
		self.meleeStuckTime = 0;
	}
}

function change_to_none_melee_weapon()
{
	weapons = self GetWeaponsList();
	changeCandidates = [];

	foreach( weapon in weapons )
	{
		if ( ( weapons::is_primary_weapon(weapon) || weapons::is_side_arm(weapon) ) && 
		( self GetWeaponAmmoClip(weapon) > 0 || self GetWeaponAmmoStock(weapon) > 0 ) && 
		weapon.name != "minigun" && 
		weapon.name != "m32" && 
		!weapon.isRiotShield && 
		weapon != level.weaponBaseMeleeHeld && 
		weapon != level.weaponNone && 
		!( weapon.name == "fhj18" && isdefined( self.bot.threat.entity ) && !Target_IsTarget( self.bot.threat.entity ) ) )
		{
			changeCandidates[changeCandidates.size] = weapon;
		}
	}

	if ( changeCandidates.size )
	{
		weapon = array::random(changeCandidates);
		self switchToWeapon( weapon );

		return true;
	}

	return false;
}

function get_fov()
{
	weapon = self GetCurrentWeapon();
	reduction = 1;

	if ( weapon != level.weaponNone && weapon.isSniperWeapon && self PlayerAds() >= 1 )
	{
		reduction = 0.25;
	}

	return self.bot.fov * reduction;
}

function get_converge_time()
{
	difficulty = bot::get_difficulty();

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
	difficulty = bot::get_difficulty();

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
		difficulty = bot::get_difficulty();


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

function get_aim_error()
{
	difficulty = bot::get_difficulty();

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

function dot_product( origin )
{
	angles = self GetPlayerAngles();
	forward = AnglesToForward( angles );

	delta = origin - self GetPlayerCameraPos();
	delta = VectorNormalize( delta );

	dot = VectorDot( forward, delta );
	return dot;
}

function has_enemy()
{
	return ( isdefined( self.bot.threat.entity ) );
}

function threat_is_player()
{
	ent = self.bot.threat.entity;
	return ( isdefined( ent ) && IsPlayer( ent ) );
}

function threat_is_dog()
{
	ent = self.bot.threat.entity;
	return ( isdefined( ent ) && IsAI( ent ) );
}

function threat_is_turret()
{
	ent = self.bot.threat.entity;
	return ( isdefined( ent ) && ent.classname == "auto_turret" );
}

function threat_is_ai_tank()
{
	ent = self.bot.threat.entity;
	return ( isdefined( ent ) && isdefined( ent.targetname ) && ent.targetname == "talon" );
}

function threat_is_qrdrone( ent )
{
	if ( !isdefined( ent ) )
	{
		ent = self.bot.threat.entity;
	}
	
	return ( isdefined( ent ) && isdefined( ent.heliType ) && ent.heliType == "qrdrone" );
}

function threat_using_riotshield()
{
	if ( threat_is_player() )
	{
		weapon = self.bot.threat.entity GetCurrentWeapon();
		return ( weapon.isRiotShield );
	}

	return false;
}

function threat_is_equipment()
{
	ent = self.bot.threat.entity;
	
	if ( !isdefined( ent ) )
	{
		return false;
	}

	if ( threat_is_player() )
	{
		return false;
	}

	if ( isdefined( ent.model ) && ent.model == "t6_wpn_tac_insert_world" )
	{
		return true;
	}

	return ( isdefined( ent.isEquipment ) && ent.isEquipment );
}

function clear_enemy()
{
	self ClearLookAt();
	self BotClearMeleeChargeEnt();
	self.bot.threat.entity = undefined;
}

function already_has_enemy( fov )
{
	ent = self.bot.threat.entity;

	if ( isdefined( ent ) )
	{
/# 
		if ( IsPlayer( ent ) )
		{
			if ( GetDvarInt( "bot_IgnoreHumans" ) && ( !isdefined( ent.pers[ "isBot" ] ) || !ent.pers[ "isBot" ] ) )
			{
				clear_enemy();
				return false;
			}
			if ( ent IsInMoveMode( "ufo", "noclip" ) )
			{
				clear_enemy();
				return false;
			}
		}
#/
		if ( IsPlayer( ent ) || IsAI( ent ) )
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
	return false;
}

function best_enemy()
{
	fov = get_fov();

	if ( already_has_enemy( fov ) )
		return true;
	
	enemies = self GetThreats( fov );

	foreach( enemy in enemies )
	{
/# 
		if ( !IsPlayer(enemy) && !GetDvarInt( "bot_PressAttackBtn" ) )
		{
			continue;
		}
#/
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

			if ( threat_requires_rocket( enemy ) )
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
			}
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

function threat_requires_rocket( enemy ) 
{
	if ( !isdefined( enemy ) || IsPlayer( enemy ) )
	{
		return false;
	}
		
	if ( isdefined( enemy.heliType ) && enemy.heliType == "qrdrone" )
	{
		return false;
	}

	if ( isdefined( enemy.targetname ) )
	{
		if ( enemy.targetname == "remote_mortar" )
		{
			return true;
		}
		else if ( enemy.targetname == "uav" || enemy.targetname == "counteruav" )
		{
			return true;
		}
	}

	if ( enemy.classname == "script_vehicle" && enemy.vehicleclass == "helicopter" )
	{
		return true;
	}

	return false;
}

function threat_is_warthog( enemy )
{
	if ( !isdefined( enemy ) || IsPlayer( enemy ) )
	{
		return false;
	}

	if ( enemy.classname == "script_vehicle" && enemy.vehicleclass == "plane" )
	{
		return true;
	}

	return false;
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

function threat_ignore( entity, secs )
{
	self.bot.ignore_entity[ entity GetEntityNumber() ] = GetTime() + ( secs * 1000 );
}

function update_aim( frames )
{
	ent = self.bot.threat.entity;
	prediction = self PredictPosition( ent, frames );

	if ( using_launcher() && !threat_requires_rocket( ent ) )
	{
		return prediction - ( 0, 0, RandomIntRange( 0, 10 ) );
	}
	
	if ( !threat_is_player() )
	{
		height = ent GetCentroid()[2] - prediction[2];
		return prediction + ( 0, 0, height );
	}
		
	height = ent GetPlayerViewHeight();

	if ( threat_using_riotshield() )
	{
		dot = ent dot_product( self.origin ); 

		if ( dot > 0.8 && ent GetStance() == "stand" )
		{
			return prediction + ( 0, 0, 5 );
		}
	}

	torso = prediction + ( 0, 0, height / 1.6 );
	return torso;
}

function create_cover() // not used
{
	currentWeapon = self GetCurrentWeapon();

	if ( currentWeapon.isRiotShield )
	{
		return false;
	}
	
	placement = self CanPlaceRiotshield("deploy_riotshield");

	if ( placement["result"] )
	{
		self PressAttackButton();
	}

	return placement["result"];
}

function update_cover()
{
	if ( bot::get_difficulty() == "easy" )
	{
		return;
	}

	if ( has_melee_weapon() )
	{
		self CancelGoal( "cover" );
		self CancelGoal( "flee" );
		return;
	}

	if ( threat_using_riotshield() )
	{
		self CancelGoal( "enemy_patrol" ); 
		self CancelGoal( "flee" );
		return;
	}

	enemy = self.bot.threat.entity;

	if ( threat_is_turret() && !has_sniper() && !has_melee_weapon() )
	{
		goal = enemy turret_get_attack_node();

		if ( isdefined( goal ) )
		{
			self CancelGoal( "enemy_patrol" ); 
			self AddGoal( goal, 24, 3, "cover" );
		}
	}

	if ( !IsPlayer( enemy ) )
	{
		return;
	}

	dot = enemy dot_product( self.origin ); 

	// is he looking at me?
	if ( dot < 0.80 && !has_shotgun() )
	{
		self CancelGoal( "cover" );
		self CancelGoal( "flee" );
		return;
	}

	ammo_frac = weapon_ammo_frac();
	health_frac = health_frac();

	cover_score = dot - ammo_frac - health_frac;

	if ( should_hip_fire() && !has_shotgun() )
	{
		cover_score += 1;
	}

	if ( cover_score > 0.25 )
	{
		nodes = GetNodesInRadiusSorted( self.origin, 1024, 256, 512, "Path", 8 );
		nearest = nearest_node( enemy.origin );

		if ( isdefined( nearest ) && !self HasGoal( "flee" ) )
		{
			foreach( node in nodes )
			{
				if ( !NodesVisible( nearest, node ) /*&& !NodesCanPath( nearest, node )*/ )
				{
					self CancelGoal( "cover" );
					self CancelGoal( "enemy_patrol" ); 
					self AddGoal( node, 24, 4, "flee" );
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

		nearest = nearest_node( enemy.origin );

		if ( isdefined( nearest ) )
		{
			foreach( node in nodes )
			{
				if ( !CanClaimNode( node, self.team ) )
				{
					continue;
				}

				if ( node.type != "Path" && !util::within_fov( node.origin, node.angles, enemy.origin, get_fov() ) )
				{
					continue;
				}

				if ( /*!NodesCanPath( nearest, node ) &&*/ NodesVisible( nearest, node ) )
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
					self AddGoal( node, 8, 4, "cover" );
					return;
				}
			}
		}
	}
	else if ( has_shotgun() )
	{
		self AddGoal( enemy.origin, 24, 4, "cover" );
	}
}

function update_attack( enemy, dot_from, dot_to, sight, aim_target )
{
	self AllowAttack( false );
	self PressAds( false );

	if ( sight == ( 0 ) )
	{
		return;
	}

	weapon = self GetCurrentWeapon();

	if ( weapon == level.weaponNone )
	{
		return;
	}
	
	radius = 50;

	if ( dot_to > 0.9 )
	{
		self PressAds( true );
	}
	
	ads = true;
	
	if ( should_hip_fire() )
	{
		self PressAds( false );
		ads = false;
		radius = 15;
	}
	
	if ( weapon.isSniperWeapon && ads )
	{
		if ( self PlayerAds() < 1 )
		{
			self.bot.time_ads = GetTime();
		}

		if ( GetTime() < self.bot.time_ads + 1000 )
		{
			return;
		}
	}

	if ( /*self on_target( enemy, radius, aim_target ) &&*/ ( !ads || self PlayerAds() >= 1 ) )
	{
		self AllowAttack( true );
	}
}

function weapon_ammo_frac()
{
	if ( self IsReloading() || self IsSwitchingWeapons() )
	{
		return 0;
	}
	
	weapon = self GetCurrentWeapon();

	if ( weapon == level.weaponNone )
	{
		return 1;
	}

	total = weapon.clipSize;

	if ( total <= 0 )
	{
		return 1;
	}
	
	current = self GetWeaponAmmoClip( weapon );

	return ( current / total );
}

function select_weapon()
{
	if ( self IsThrowingGrenade() || self IsSwitchingWeapons() || self IsReloading() )
	{
		return;
	}
	
	if ( !self IsOnGround() )
	{
		return;
	}

	ent = self.bot.threat.entity;

	if ( !isdefined( ent ) )
	{
		return;
	}
	
	primaries	= self GetWeaponsListPrimaries();
	weapon		= self GetCurrentWeapon();
	stock		= self GetWeaponAmmoStock( weapon );
	clip		= self GetWeaponAmmoClip( weapon );

	fhj_weapon = GetWeapon( "fhj18" );

	if ( weapon == level.weaponNone )
	{
		return;
	}
	
	if ( threat_requires_rocket( ent ) || threat_is_qrdrone() ) 
	{
		if ( !using_launcher() )
		{
			foreach( primary in primaries )
			{
				if ( !self GetWeaponAmmoClip( primary ) && !self GetWeaponAmmoStock( primary ) )
				{
					continue;
				}

				if ( primary.name == "smaw" || primary == fhj_weapon )
				{
					self SwitchToWeapon( primary );
					return;
				}
			}
		}
		else if ( !clip && !stock && !threat_is_qrdrone() )
		{
			threat_ignore( ent, 5 );
		}

		return;
	}
	else if ( weapon == fhj_weapon && !Target_IsTarget( ent ) )
	{
		foreach( primary in primaries )
		{
			if ( primary != weapon )
			{
				self SwitchToWeapon( primary );
				return;
			}
		}

		return;
	}

	if ( !clip )
	{
		if ( stock )
		{
			if ( WeaponHasAttachment( weapon, "supply", "fastreload" ) )
			{
				return;
			}
		}

		foreach( primary in primaries )
		{
			if ( primary == weapon || primary == fhj_weapon )
			{
				continue;
			}

			if ( self GetWeaponAmmoClip( primary ) )
			{
				self SwitchToWeapon( primary );
				return;
			}
		}

		if ( using_launcher() || has_lmg() )
		{
			foreach( primary in primaries )
			{
				if ( primary == weapon || primary == fhj_weapon )
				{
					continue;
				}

				self SwitchToWeapon( primary );
				return;
			}
		}
	}
}

function has_shotgun()
{
	weapon = self GetCurrentWeapon();

	if ( weapon == level.weaponNone )
	{
		return false;
	}
	
	if ( weapon.isDualWield )
	{
		return true;
	}
		
	return ( has_weapon_class( "spread" ) || has_weapon_class( "pistol spread" ) );
}

function has_crossbow()
{
	return ( false );
}

function has_launcher()
{
	smaw_weapon = GetWeapon( "smaw" );
	if ( self GetWeaponAmmoClip( smaw_weapon ) > 0 || self GetWeaponAmmoStock( smaw_weapon ) > 0 )
	{
		return true;
	}

	fhj_weapon = GetWeapon( "fhj18" );
	if ( self GetWeaponAmmoClip( fhj_weapon ) > 0 || self GetWeaponAmmoStock( fhj_weapon ) > 0 )
	{
		return true;
	}

	return false;
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

function has_pistol()
{
	return ( has_weapon_class( "pistol" ) || has_weapon_class( "pistol spread" ) );
}

function has_lmg()
{
	return has_weapon_class( "mg" );
}

function has_sniper()
{
	return has_weapon_class( "sniper" );
}

function using_launcher()
{
	weapon = self GetCurrentWeapon();
	return weapon.isRocketLauncher;
}

function has_minigun()
{
	weapon = self GetCurrentWeapon();
	return ( weapon.name == "minigun" || weapon.name == "inventory_minigun" );
}

function has_weapon_class( weaponclass )
{
	if ( self IsReloading() )
	{
		return false;
	}

	weapon = self GetCurrentWeapon();

	if ( weapon == level.weaponNone )
	{
		return false;
	}

	return weapon.weapClass == weaponclass;
}

function health_frac()
{
	return ( self.health / self.maxhealth );
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

	if ( weapon.isSniperWeapon )
	{
		// sniper
		distCheck = 500;
	}

	return ( distSq < distCheck * distCheck );
}

function patrol_near_enemy( damage, attacker, direction )
{
	if ( threat_is_warthog( attacker ) )
	{
		return;
	}

	if ( threat_requires_rocket( attacker ) && !self has_launcher() )
	{
		return;
	}
		
	if ( isdefined( attacker ) )
	{
		self lookat_entity( attacker );
	}

	if ( bot::get_difficulty() == "easy" )
	{
		return;
	}
		
	if ( !isdefined( attacker ) )
	{
		attacker = self bot::get_closest_enemy( self.origin, true );
	}

	if ( !isdefined( attacker ) )
	{
		return;
	}

	if ( attacker.classname == "auto_turret" )
	{
		self turret_set_dangerous( attacker );
	}
	
	node = nearest_node( attacker.origin );

	if ( !isdefined( node ) )
	{
		nodes = GetNodesInRadiusSorted( attacker.origin, 1024, 0, 512, "Path", 8 );

		if ( nodes.size )
		{
			node = nodes[0];
		}
	}

	if ( isdefined( node ) )
	{
		if ( isdefined( damage ) )
		{
			self AddGoal( node, 24, 4, "enemy_patrol" );
		}
		else
		{
			self AddGoal( node, 24, 2, "enemy_patrol" );
		}
	}
}

function nearest_node( origin )
{
	node = GetNearestNode( origin );

	if ( isdefined( node ) )
	{
		return node;
	}

	nodes = GetNodesInRadiusSorted( origin, 256, 0, 256 );

	if ( nodes.size )
	{
		return nodes[0];
	}

	return undefined;
}

function lookat_entity( entity )
{
	if ( IsPlayer( entity ) && entity GetStance() != "prone" )
	{
		if ( DistanceSquared( self.origin, entity.origin ) < 256 * 256 )
		{
			origin = entity GetCentroid() + ( 0, 0, 10 );
			self LookAt( origin );
			return;
		}
	}

	offset = Target_GetOffset( entity );

	if ( isdefined( offset ) )
	{
		self LookAt( entity.origin + offset );
	}
	else
	{
		self LookAt( entity GetCentroid() );
	}
}

function combat_throw_lethal( origin )
{
	weapons = self GetWeaponsList();

	radius = 256;

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

		if ( weapon.name == "frag_grenade" || weapon.name == "sticky_grenade" )
		{
			if ( self ThrowGrenade( weapon, origin ) )
			{
				return true;
			}
		}
	}

	return false;
}

function combat_throw_tactical( origin )
{
	weapons = self GetWeaponsList();

	if ( !self HasPerk( "specialty_flashprotection" ) )
	{
		if ( DistanceSquared( self.origin, origin ) < 650 * 650 )
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

		if ( weapon.name == "flash_grenade" || weapon.name == "concussion_grenade" )
		{
			if ( self ThrowGrenade( weapon, origin ) )
			{
				return true;
			}
		}
	}

	return false;
}

function combat_throw_smoke( origin )
{
	smoke_weapon = GetWeapon( "willy_pete" );
	if ( self GetWeaponAmmoStock( smoke_weapon ) <= 0 )
	{
		return false;
	}

	time = GetTime();
	
	foreach( player in level.players )
	{
		if ( !isdefined( player.smokeGrenadeTime ) )
		{
			continue;
		}

		if ( time - player.smokeGrenadeTime > 12000 )
		{
			continue;
		}

		if ( DistanceSquared( origin, player.smokeGrenadePosition ) < 256 * 256 )
		{
			return false;
		}
	}

	return ( self ThrowGrenade( smoke_weapon , origin ) );
}

function combat_throw_emp( origin )
{
	emp_weapon = GetWeapon( "emp" );
	if ( self GetWeaponAmmoStock( emp_weapon ) <= 0 )
	{
		return false;
	}

	return ( self ThrowGrenade( emp_weapon, origin ) );
}

function combat_throw_proximity( origin )
{
	foreach( missile in level.missileEntities )
	{
		if ( isdefined( missile ) && DistanceSquared( missile.origin, origin ) < 256 * 256 )
		{
			return false;
		}
	}
	
	return ( self ThrowGrenade( GetWeapon( "proximity_grenade" ), origin ) );
}

function combat_tactical_insertion( origin )
{
	foreach( missile in level.missileEntities )
	{
		if ( isdefined( missile ) && DistanceSquared( missile.origin, origin ) < 256 * 256 )
		{
			return false;
		}
	}

	return ( self ThrowGrenade( GetWeapon( "tactical_insertion" ), origin ) );
}

function combat_toss_flash( origin )
{
	if ( bot::get_difficulty() == "easy" )
	{
		return false;
	}

	if ( self GetWeaponAmmoStock( GetWeapon( "sensor_grenade" ) ) <= 0 && self GetWeaponAmmoStock( GetWeapon( "proximity_grenade" ) ) <= 0 && self GetWeaponAmmoStock( GetWeapon( "trophy_system" ) ) <= 0 )
	{
		return false;
	}

	foreach( missile in level.missileEntities )
	{
		if ( isdefined( missile ) && DistanceSquared( missile.origin, origin ) < 256 * 256 )
		{
			return false;
		}
	}

	self PressAttackButton( 2 );
	return true;
}

function combat_toss_frag( origin )
{
	if ( bot::get_difficulty() == "easy" )
	{
		return false;
	}

	if ( self GetWeaponAmmoStock( GetWeapon( "bouncingbetty" ) ) <= 0 && self GetWeaponAmmoStock( GetWeapon( "claymore" ) ) <= 0 && self GetWeaponAmmoStock( GetWeapon( "satchel_charge" ) ) <= 0 )
	{
		return false;
	}

	foreach( missile in level.missileEntities )
	{
		if ( isdefined( missile ) && DistanceSquared( missile.origin, origin ) < 128 * 128 )
		{
			return false;
		}
	}

	self PressAttackButton( 1 );
	return true;
}

function shotgun_think()
{
	if ( self IsThrowingGrenade() || self IsSwitchingWeapons() )
	{
		return;
	}
	
	enemy = self.bot.threat.entity;
	weapon = self GetCurrentWeapon();

	self AllowAttack( false );
	
	distSq = DistanceSquared( enemy.origin, self.origin );

	if ( threat_is_turret() )
	{
		goal = enemy turret_get_attack_node();

		if ( isdefined( goal ) )
		{
			self CancelGoal( "enemy_patrol" ); 
			self AddGoal( goal, 24, 4, "cover" );
		}

		if ( weapon != level.weaponNone && !weapon.isDualWield && distSq < 256 * 256 )
		{
			self PressAds( true );
		}
	}
	else if ( self GetWeaponAmmoClip( weapon ) && distSq < 300 * 300 )
	{
		self CancelGoal( "enemy_patrol" ); 
		self AddGoal( self.origin, 24, 4, "cover" );
	}
	
	dot = self dot_product( self.bot.threat.aim_target ); 

	if ( distSq < 500 * 500 && dot > 0.98 )
	{
		self AllowAttack( true );
		return;
	}

	if ( bot::get_difficulty() == "easy" )
	{
		return;
	}

	if ( self threat_is_player() )
	{
		dot = enemy dot_product( self.origin ); 

		// is he looking at me?
		if ( dot < 0.90 )
		{
			return;
		}
	}
	else
	{
		return;
	}
	
	// try to switch to a weapon with range
	primaries = self GetWeaponsListPrimaries();
	weapon = self GetCurrentWeapon();

	foreach( primary in primaries )
	{
		if ( primary == weapon )
		{
			continue;
		}

		if ( !self GetWeaponAmmoClip( primary ) )
		{
			continue;
		}

		if ( primary.lockonType == "Legacy Single" )
		{
			continue;
		}

		weaponclass = primary.weapClass;

		if ( weaponclass == "spread" || weaponclass == "pistol spread" ||  weaponclass == "melee" || weaponclass == "item" )
		{
			continue;
		}

		if ( self SwitchToWeapon( primary ) )
		{
			return;
		}
	}

	// pop smoke
	if ( self GetWeaponAmmoStock( GetWeapon( "willy_pete" ) ) > 0 )
	{
		self PressAttackButton( 2 );
		return;
	}
}

function turret_set_dangerous( turret )
{
	if ( !level.teamBased )
	{
		return;
	}

	if ( ( isdefined( turret.dead ) && turret.dead ) || ( isdefined( turret.carried ) && turret.carried ) )
	{
		return;
	}

	if ( !( isdefined( turret.turret_active ) && turret.turret_active ) )
	{
		return;
	}

	if ( turret.dangerous_nodes.size )
	{
		return;
	}
	
	nearest = turret_nearest_node( turret );

	if ( !isdefined( nearest ) )
	{
		return;
	}

	forward = AnglesToForward( turret.angles );

	//bot::debug_star( nearest.origin, 10 );
		
	if ( turret.turretType == "sentry" )
	{
		nodes = GetVisibleNodes( nearest );

		foreach( node in nodes )
		{
			dir = VectorNormalize( node.origin - turret.origin );
			dot = VectorDot( forward, dir );

			if ( dot >= 0.5 )
			{
				turret turret_mark_node_dangerous( node );
			}
		}
	}
	else if ( turret.turretType == "microwave" )
	{
		nodes = GetNodesInRadius( turret.origin, ( 750 ), 0 );

		foreach( node in nodes )
		{
			if ( !NodesVisible( nearest, node ) )
			{
				continue;
			}
			
			dir = VectorNormalize( node.origin - turret.origin );
			dot = VectorDot( forward, dir );
						
			if ( dot >= cos( ( 15 ) ) )
			{
				turret turret_mark_node_dangerous( node );
			}
		}
	}
}

function turret_nearest_node( turret )
{
	nodes = GetNodesInRadiusSorted( turret.origin, 256, 0 );
	forward = AnglesToForward( turret.angles );

	foreach( node in nodes )
	{
		dir = VectorNormalize( node.origin - turret.origin );
		dot = VectorDot( forward, dir );

		if ( dot > 0.5 )
		{
			return node;
		}
	}

	if ( nodes.size )
	{
		return nodes[0];
	}

	return undefined;
}

function turret_mark_node_dangerous( node )
{
	foreach( team in level.teams )
	{
		if ( team == self.owner.team )
		{
			continue;
		}

		node SetDangerous( team, true );
	}

	self.dangerous_nodes[ self.dangerous_nodes.size ] = node;
}

function turret_get_attack_node()
{
	nearest = nearest_node( self.origin );

	if ( !isdefined( nearest ) )
	{
		return undefined;
	}

	nodes = GetNodesInRadiusSorted( self.origin, 512, 64 );
	forward = AnglesToForward( self.angles );

	foreach( node in nodes )
	{
		if ( !NodesVisible( node, nearest ) )
		{
			continue;
		}

		dir = VectorNormalize( node.origin - self.origin );
		dot = VectorDot( forward, dir );

		if ( dot < 0.5 )
		{
			//bot::debug_star( node.origin, 10 );
			return node;
		}
	}

	return undefined;
}

// attacking a player with a riotshield
function riotshield_think( enemy )
{
	dot = enemy dot_product( self.origin ); 

	// is he looking at me?
	if ( !has_crossbow() && !using_launcher() && enemy GetStance() != "stand" )
	{
		if ( dot > 0.80 )
		{
			self AllowAttack( false );
		}
	}

	forward = AnglesToForward( enemy.angles );
	origin = enemy.origin + forward * RandomIntRange( 256, 512 );
	
	if ( self combat_throw_lethal( origin ) )
	{
		return;
	}

	if ( self combat_throw_tactical( origin ) )
	{
		return;
	}

	if ( self ThrowGrenade( GetWeapon( "proximity_grenade" ), origin ) )
	{
		return;
	}

	if ( self AtGoal( "cover" ) )
	{
		self.bot.threat.update_riotshield = 0;
	}

	if ( GetTime() > self.bot.threat.update_riotshield )
	{
		self thread riotshield_dangerous_think( enemy );
		self.bot.threat.update_riotshield = GetTime() + RandomIntRange( 5000, 7500 );
	}
}

function riotshield_dangerous_think( enemy, goal )
{
	nearest = nearest_node( enemy.origin );

	if ( !isdefined( nearest ) )
	{
		threat_ignore( enemy, 10 );
		return;
	}

	nodes = GetNodesInRadius( enemy.origin, 768, 0 );

	if ( !nodes.size )
	{
		threat_ignore( enemy, 10 );
		return;
	}

	nodes = array::randomize( nodes );
	forward = AnglesToForward( enemy.angles );

	foreach( node in nodes )
	{
		if ( !NodesVisible( node, nearest ) )
		{
			continue;
		}
				
		dir = VectorNormalize( node.origin - enemy.origin );
		dot = VectorDot( forward, dir );

		if ( dot < 0 )
		{
			if ( DistanceSquared( self.origin, enemy.origin ) < 512 * 512 )
			{
				self AddGoal( node, 24, 4, "cover" );
			}
			else
			{
				self AddGoal( node, 24, 3, "cover" );
			}

			break;
		}
	}

	if ( !level.teamBased )
	{
		return;
	}

	nodes = GetNodesInRadius( enemy.origin, 512, 0 );
	
	foreach( node in nodes )
	{
		dir = VectorNormalize( node.origin - enemy.origin );
		dot = VectorDot( forward, dir );

		if ( dot >= 0.5 )
		{
			node SetDangerous( self.team, true );
		}
	}
	
	enemy util::wait_endon( 5, "death" );

	foreach( node in nodes )
	{
		node SetDangerous( self.team, false );
	}
}
