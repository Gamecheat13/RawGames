#include common_scripts\utility; 
#include maps\_utility;
#include maps\_turret;

#insert raw\common_scripts\utility.gsh;

// interval between grenade launcher rounds
#define LAUNCHER_COOLOFF_MIN 5000
#define LAUNCHER_COOLOFF_MAX 10000
#define LAUNCHER_MIN_DISTANCE_SQR 350 * 350

#define TURRET_NAME "bigdog_dual_turret"
	
// false for now
#define ALLOW_TOP_LEG_TO_BREAK_OFF false
	
// charge shot level requirement	
#define MIN_CHARGE_SHOTLEVEL 2

#using_animtree ("bigdog");

main()
{
	animscripts\init::firstInit();
	
	anim._effect["bigdog_spark_big"] 				= LoadFx( "env/electrical/fx_elec_bigdog_spark_lg_runner" );
	anim._effect["bigdog_explosion"] 				= LoadFx( "destructibles/fx_claw_exp_death" );
	anim._effect["bigdog_panel_explosion_small"] 	= LoadFx( "destructibles/fx_claw_exp_panel" );
	anim._effect["bigdog_panel_explosion_large"] 	= LoadFx( "destructibles/fx_claw_exp_panel_lg" );
	anim._effect["bigdog_leg_explosion"] 			= LoadFx( "destructibles/fx_claw_exp_leg_break" );
	anim._effect["bigdog_stunned"] 					= LoadFx( "destructibles/fx_claw_stun_electric" );
	anim._effect["bigdog_smoke"] 					= LoadFx( "destructibles/fx_claw_dmg_smk_lt" );
	anim._effect["bigdog_dust_cloud"] 				= LoadFx( "dirt/fx_dust_impact_claw" );
	
	if( !IsDefined(anim.bigdog_globals) )
	{
		anim.bigdog_globals = SpawnStruct();

		anim.bigdog_globals.boneMap = [];

		anim.bigdog_globals.boneMap[ "jnt_f_l_balljoint" ]	= "FL";
		anim.bigdog_globals.boneMap[ "jnt_f_l_knee_upper" ] = "FL";
		anim.bigdog_globals.boneMap[ "jnt_f_l_knee_lower" ] = "FL";
		anim.bigdog_globals.boneMap[ "jnt_f_l_ankle" ]		= "FL";

		anim.bigdog_globals.boneMap[ "jnt_f_r_balljoint" ]	= "FR";
		anim.bigdog_globals.boneMap[ "jnt_f_r_knee_upper" ] = "FR";
		anim.bigdog_globals.boneMap[ "jnt_f_r_knee_lower" ] = "FR";
		anim.bigdog_globals.boneMap[ "jnt_f_r_ankle" ]		= "FR";

		anim.bigdog_globals.boneMap[ "jnt_r_l_balljoint" ]	= "RL";
		anim.bigdog_globals.boneMap[ "jnt_r_l_knee_upper" ] = "RL";
		anim.bigdog_globals.boneMap[ "jnt_r_l_knee_lower" ] = "RL";
		anim.bigdog_globals.boneMap[ "jnt_r_l_ankle" ]		= "RL";

		anim.bigdog_globals.boneMap[ "jnt_r_r_balljoint" ]	= "RR";
		anim.bigdog_globals.boneMap[ "jnt_r_r_knee_upper" ] = "RR";
		anim.bigdog_globals.boneMap[ "jnt_r_r_knee_lower" ] = "RR";
		anim.bigdog_globals.boneMap[ "jnt_r_r_ankle" ]		= "RR";
	
		anim.bigdog_globals.legHierarchy[ "FL" ]			= array( "jnt_f_l_balljoint", "jnt_f_l_knee_upper", "jnt_f_l_knee_lower", "jnt_f_l_ankle" );
		anim.bigdog_globals.legHierarchy[ "FR" ]			= array( "jnt_f_r_balljoint", "jnt_f_r_knee_upper", "jnt_f_r_knee_lower", "jnt_f_r_ankle" );
		anim.bigdog_globals.legHierarchy[ "RL" ]			= array( "jnt_r_l_balljoint", "jnt_r_l_knee_upper", "jnt_r_l_knee_lower", "jnt_r_l_ankle" );
		anim.bigdog_globals.legHierarchy[ "RR" ]			= array( "jnt_r_r_balljoint", "jnt_r_r_knee_upper", "jnt_r_r_knee_lower", "jnt_r_r_ankle" );
		
		anim.bigdog_globals.legDamagedMap[ "FL" ]			= "jnt_f_l_knee_upper_dmg";
		anim.bigdog_globals.legDamagedMap[ "FR" ]			= "jnt_f_r_knee_upper_dmg";
		anim.bigdog_globals.legDamagedMap[ "RL" ]			= "jnt_r_l_knee_upper_dmg";
		anim.bigdog_globals.legDamagedMap[ "RR" ]			= "jnt_r_r_knee_upper_dmg";
		
		anim.bigdog_globals.bodyDamageMap[ "left" ]			= array( "tag_panel_mid_l_lower", 	"tag_panel_mid_l_upper" );
		anim.bigdog_globals.bodyDamageMap[ "right" ]		= array( "tag_panel_mid_r_lower", 	"tag_panel_mid_r_upper" );
		anim.bigdog_globals.bodyDamageMap[ "front" ]		= array( "tag_panel_front_l", 		"tag_panel_front_r" );
		anim.bigdog_globals.bodyDamageMap[ "back" ]			= array( "tag_panel_rear_l", 		"tag_panel_rear_r" );
		
		anim.bigdog_globals.bodyDamageTags					= array( "tag_panel_mid_l_lower", 	"tag_panel_mid_l_upper",
																	 "tag_panel_mid_r_lower", 	"tag_panel_mid_r_upper",
																	 "tag_panel_front_l", 		"tag_panel_front_r",
																	 "tag_panel_rear_l", 		"tag_panel_rear_r" );
	}

	self.a = SpawnStruct();
	self.moveplaybackrate = 1; 
	self.usecombatscriptatcover = true;
	self.combatmode = "any_exposed_nodes_only";

	self setCurrentWeapon("none");
	self setPrimaryWeapon(self.weapon);
	self setSecondaryWeapon(self.weapon);

	self.a.weaponPos["right"] = "none";
	self.a.weaponPos["left"] = "none";
	
	self.audio_is_targeting = true;

	self.a.allow_shooting = true;

	/#
		thread animscripts\debug::UpdateDebugInfo();
	#/

	self useAnimTree( #animtree );

	self.animType = "bigdog";
	self.lastAnimType = self.animType;
	self animscripts\anims::clearAnimCache();

	setup_bigdog_anims( self.animType );

	self.a.pose = "stand";
	self.a.prevPose = self.a.pose;
	self.a.movement = "stop";
	self.a.script = "init";
	self.a.alertness = "casual"; // casual, alert, aiming

	// required for using common shooting scripts
	self.isSniper = false;
	self.bulletsInClip = 0;
	self.a.lastShootTime = 0;
	self.a.missTime = 0;
	self.suppressionThreshold = 1;
	
	// locomotion speeds
	self.sprint = 0;
	self.walk = 1;

	// slow down the turns
	self.turnRate = 5;
	self.turnAngleThreshold = 50;
	
	// will be set to false when enough legs are blown off
	self.canMove = true;

	// custom damage
	self.overrideActorDamage = ::bigdog_damage_override;

	// bigdog shoot settings
	self.turretIndependent = false;
	
	// use if legs need to be weaker (they don't)
	const legHealthMod = 1.0;

	// bigdog damage areas
	self.partHealth = [];
	self.partHealth[ "FL" ]		= self.health * legHealthMod;
	self.partHealth[ "FR" ]		= self.health * legHealthMod;
	self.partHealth[ "RL" ]		= self.health * legHealthMod;
	self.partHealth[ "RR" ]		= self.health * legHealthMod;
	self.partHealth[ "body" ]	= self.health;
	
	self.hidePieceCount = 8; // body pieces
	self.hidePieceHealthThreshold = self.health - (self.health / self.hidePieceCount);

	// set health to a huge number since we'll be subtracting 1 for every leg hit
	self.initialHealth = self.health;
	self.initialHealthLeg = self.health * legHealthMod;
	self.health = 99999999;

	// store hit counts
	partKeys = GetArrayKeys(self.partHealth);
	
	self.hitCount = [];
	foreach( key in partKeys )
		self.hitCount[ key ] = 0;	

	self.hitCount[ "total" ] = 0;

	// how many hits in a row before pain anim is played
	self.hitCountPainThreshold = 0;

	// how many hits in a row before grenade launcher retaliation
	self.hitCountLauncherThreshold = 5;
	
	// retaliate cooloff timer
	self.retaliateCooloffTime = -1;
	
	// launcher cooloff timer
	self.launcherCooloffTime = -1;

	// next pain time so the dog can't be infinitely suppressed with pain animations
	self.nextPainTime = -1;

	// so that 1 pt damage can be done for crosshair fx without any pain anims
	self.minPainDamage = 2;

	// for wounded anims
	self.a.wounded = false;

	// no grenades for launcher to start with
	self.grenadeammo = 0;
	
	// start hunkered up
	self.hunkeredDown = false;
	
	self.damageLeg = "";
	self.missingLegs = [];
	self.smokeStacks = 0;
	
	// show the bullet hint only once
	self.bulletHintShown = false;
	self.chargedbulletHintShown = false;
	
	// because we want to make changes to it
	self.bodyDamageMap = anim.bigdog_globals.bodyDamageMap;

	self.baseAccuracy = self.accuracy;

	if( !IsDefined(self.script_accuracy) )
	{
		self.script_accuracy = 1;
	}
	
	// increase phys radius so it doesn't clip into stuff
	self SetPhysParams( 28, 0, 70 );

	animscripts\move::MoveGlobalsInit();

	setup_bigdog_turret();
	
	// hide damaged parts while still pristine
	boneKeys = GetArrayKeys( anim.bigdog_globals.legDamagedMap );
	foreach( key in boneKeys )
	{
		self HidePart( anim.bigdog_globals.legDamagedMap[key] );
	}

	self thread set_fight_dist();
	self thread decay_hit_counts();
	self thread walking_loop_audio();
	self thread play_spawn_alarm();
	self thread bigdog_kill_all_fx_on_death();
	
	//SOUND - Shawn J - added for temporary dialog
	//TODO - REMOVE this variable setting once claw dialog system is in place
	level.is_player_inside_arena = false;
}

end_script()
{
}

set_fight_dist()
{
	self endon("death");

	// have to wait, otherwise spawn stuff overrides it
	wait(0.05);

	// move even if enemy is close
	self.pathEnemyLookAhead = 96;
	self.pathEnemyFightDist = 96;
}

setup_bigdog_anims( animType )
{
	assert( IsDefined(anim.anim_array) && IsArray(anim.anim_array) );

	// check if it's already been initialized
	if( IsDefined(anim.anim_array[animType]) )
	{
		return;
	}

	anim.anim_array = animscripts\bigdog\anims_table_bigdog::setup_bigdog_anim_array( animType, anim.anim_array );
}

setup_bigdog_turret()
{
	// remove the head model
	self Detach( self.headModel );

	// create new turret
	self.turret = create_turret( self.origin, self.angles, self.team, TURRET_NAME, self.headModel, (0,0,50) );
	self.turret MakeTurretUnusable();
	
	// don't shoot anything without being told to, dammit
	self.turret maps\_turret::pause_turret( 0 );

	self setontargetangle( 2 );

	/# recordEnt( self.turret ); #/

	self.turret LinkTo( self, "tag_turret", ( 0, 0, 0 ), ( 0, 0, 0 ) );
		
	self thread update_turret_target();
	self thread fire_when_on_target();
	//SOUND - Shawn J - turning off CLAW speech (commented out thread below)
	//self thread play_ambient_VO();

	self thread stopTurretOnDeath();
}

update_turret_target()
{
	self endon("death");

	paused = false;
	
	offset = (0,0,0);

	while(1)
	{		
		if( !self.turretIndependent )
		{
			if( IsDefined(self.enemy) )
			{
				shootAtPos = self.enemy GetShootAtPos();
				
				// wild shooting if stunned
				// TODO: create a fake ent cause offset doesn't work with sentients
				if( !self.canMove )
				{
					if( !IsDefined( self.fakeEnemy ) )
					{
						self.fakeEnemy = Spawn( "script_origin", self.enemy.origin );
						self thread delete_on_death( self.fakeEnemy );
					}
					
					self.fakeEnemy.origin = self.enemy.origin;					
					offset = ( RandomInt( 400 ), RandomInt( 400 ), RandomInt( 400 ) );
					
					self.turret set_turret_target( self.fakeEnemy, offset );
				}
				else
				{
					self.turret set_turret_target( self.enemy );
				}
			}
			else
			{
				self.turret clear_turret_target();
			}
		}

		wait(0.2);
	}
}

fire_when_on_target()
{
	self endon("death");
	self endon("stop_fire_turret");

//	const n_fire_min = 1.8;  // minimum time we want to fire per burst
//	const n_fire_max = 2.0;  // maximum time we want to fire per burst
//	const n_wait_min = 1.4;  // minimum wait time between bursts
//	const n_wait_max = 1.6;  // maximum wait time between bursts
	
	const n_fire_min = 0.9;	//1.8;  // minimum time we want to fire per burst
	const n_fire_max = 1;	//2.0;  // maximum time we want to fire per burst
	const n_wait_min = 1;	//1.4;  // minimum wait time between bursts
	const n_wait_max = 1.4;	//1.6;  // maximum wait time between bursts

	waitTime = 1;
	burstTime = 1;
	
	const minDistToTarget = 300;
	const maxDistToTarget = 600;
	const forceShootDistSq = 2000 * 2000;
	
	weaponSpinSettings = WeaponSpinSettings( TURRET_NAME );
	spinUpTime = weaponSpinSettings[ "up" ] / 1000;
	
	turretSpinning = false;

	self thread bigdog_targeting_audio();
	
	while(1)
	{
		// no shooting while in pain
		while( self.a.script == "pain" )
			wait(0.05);

		//self thread bigdog_targeting_audio(); //this will run the target audio everytime it locks on.

		self.turret waittill( "turret_on_target" );
		
		currentTarget = self.turret get_turret_target();
		
		// only shoot if we can actually hit something
		canShootTarget = false;
		if( IsDefined( currentTarget ) )
		{
			canShootTarget = BulletTracePassed( self.turret GetTagOrigin( "tag_flash" ), currentTarget GetShootAtPos( self ), true, self, currentTarget );
			
			if( !canShootTarget && DistanceSquared( self.origin, currentTarget.origin ) < forceShootDistSq )
			{
				canShootTarget = true;
			}
		}
		
		if( self.a.allow_shooting && !self.turretIndependent && canShootTarget )
		{
			if( !turretSpinning )
			{
				self.turret SetTurretSpinning( true );
				wait( spinUpTime );
				turretSpinning = true;
			}
			
			burstTime = RandomFloatRange( n_fire_min, n_fire_max );
			waitTime = RandomFloatRange( n_wait_min, n_wait_max );
			
			// no wait time if the enemy is close now that we have contextual melee
			if( IsDefined( self.enemy ) )
			{
				distToEnemy = Distance( self.origin, self.enemy.origin );
				distLerpVal = Min( 1, Max( 0, (distToEnemy - minDistToTarget) / (maxDistToTarget - minDistToTarget) ) );
				waitTime = LerpFloat( 0, waitTime, distLerpVal );
			}
			
			self.audio_is_targeting = false;

			// no need for randomness within the turret system since we're doing it all here
			self.turret maps\_turret::set_turret_burst_parameters( burstTime, burstTime, waitTime, waitTime );
			
			self thread bigdog_fire_turret( burstTime );
			
			// spin down if there will be a pause here
			if( waitTime > 0 )
			{
				self.turret SetTurretSpinning( false );
				turretSpinning = false;
			}
			
			wait( burstTime );
		}
		else
		{
			// don't wait too long to check again
			waitTime = 0.25;
		}
		
		// try random grenade launches
		bigdog_try_launcher();

		wait( waitTime );
		self.audio_is_targeting = true;
	}
}

bigdog_has_target()
{
	return IsDefined( self.turret get_turret_target() );
}

bigdog_fire_turret( burstTime )
{
	self endon("death");
	self endon("pain");
	self endon("stop_fire_turret");

	self.turret notify( "fire_on_target" );
	
	self.turret maps\_turret::fire_turret_for_time( burstTime );
}

stopTurretOnDeath()
{
	self waittill("death");

	// stop the turret threads
	if( IsDefined(self.turret) )
	{
		self.turret maps\_turret::disable_turret();
		
		// wait till the claw is actually removed
		while( IsDefined( self ) )
			wait( 0.05 );
		
		// delete the real turret
		if( IsDefined(self.turret) )
			self.turret Delete();
	}
}

bigdog_add_fx( boneName, effect, sound )
{
	if( !IsDefined( self.fx_ents ) )
	{
		self.fx_ents = [];
	}
	
	fxOrigin = self GetTagOrigin( boneName );
	
	tempEnt = Spawn( "script_model", fxOrigin);
	tempEnt SetModel( "tag_origin" );
	tempEnt LinkTo( self, boneName );
	
	PlayFXOnTag( effect, tempEnt, "tag_origin" );
	
	self.fx_ents[ self.fx_ents.size ] = tempEnt;
	
	//SOUND - Shawn J
	if( IsDefined( sound ) )
		self playsound( sound );
}

bigdog_kill_all_fx_on_death()
{
	self waittill("death");

	if( IsDefined( self.fx_ents ) )
	{
		// save it out for now
		fx_ents = self.fx_ents;
		
		// delete fx only whe it's officially a corpse
		while( IsDefined( self ) )
			wait( 0.2 );
		
		array_delete( fx_ents );
	}
}

bigdog_damage_override( inflictor, attacker, damage, flags, meansofdeath, weapon, vpoint, vdir, sHitLoc, modelIndex, psOffsetTime, boneName )
{
	self.damageLeg = "";
	
	bigdog_bullet_hint_trigger( attacker, damage, meansofdeath, weapon );
	
	// temp fix for war. need to get rid of the trigger_hurt eventually.
	if( meansofdeath == "MOD_TRIGGER_HURT" )
		return 0;
	
	if( IS_TRUE( self.magic_bullet_shield ) )
		return 0;
	
	weaponCharged = IsDefined( attacker ) && IsDefined( attacker.chargeShotLevel ) && attacker.chargeShotLevel >= 2;
	
	// only vulnerable while up
	if( self.hunkeredDown && self.canMove )
	{
		// request move
		if( animscripts\pain::isExplosiveDamageMOD( meansofdeath ) || weaponCharged )
		{
			animscripts\bigdog\bigdog_combat::moveToNextBestNode();
			
			// can't do this or will get a pain indicator
			// return self.minPainDamage + 1;
		}
		
		// now vulnerable even when hunkered down
		// return 0;
	}

	returnDamage = 0;
	legsHit = [];
	doBodyDamage = false;

	// figure out which legs were hit
	if( animscripts\pain::isExplosiveDamageMOD( meansofdeath ) )
	{
		// kill it
		if( !self.canMove )
		{
			return self.health;
		}
		
		damageYaw = AngleClamp180( VectorToAngles(vdir)[1] - self.angles[1] );
		//IPrintLn( "damageYaw: " + damageYaw );

		if( damageYaw > 135 || damageYaw <= -135 ) // Front quadrant
		{
			legsHit = array( "FL", "FR" );
		}
		else if( damageYaw > 45 && damageYaw < 135 ) // Right quadrant
		{
			legsHit = array( "FR", "RR" );
		}
		else if( damageYaw > -135 && damageYaw < -45 ) // Left quadrant
		{
			legsHit = array( "FL", "RL" );
		}
		else // Back quadrant
		{
			legsHit = array( "RL", "RR" );
		}

		// play pain anim
		returnDamage = damage;
	}
	else if( weaponCharged ) // metal storm
	{
		// kill it
		if( !self.canMove && self.hunkeredDown )
		{
			return self.health;
		}
		
		legsHit = array( anim.bigdog_globals.boneMap[ boneName ] );
		
		// make sure it's enough to take out a leg
		damage = self.initialHealth * 0.66;
	}
	else if( meansofdeath == "MOD_MELEE" ) // no melee damage
	{
		return 0;
	}
	else // bullet damage
	{		
		// no bullet damage for mk2 
		return 0;
	}
	
	// do leg damage
	if( legsHit.size )
	{
		self.damageLeg = legsHit[0];
		
		// play hit indicator
		if( returnDamage <= 0 )
			returnDamage = 1;

		// each successive leg will only get half the damage of the previous leg
		const multiLegDamageMod = 0.5;
		i = 0;
		
		foreach( leg in legsHit )
		{
			legDamage = damage * pow( multiLegDamageMod, i );
			
			if( bigdog_damage_leg( legDamage, meansofdeath, weapon, leg, boneName ) )
			{
				return self.health;
			}

			returnDamage = bigdog_try_pain( leg, returnDamage );
			
			i++;
		}
	}
	
	// do body damage
	if( doBodyDamage )
	{
		if( bigdog_damage_body( damage, meansofdeath, weapon, vpoint ) )
		{
			return self.health;
		}
	}

	// disabled 10/20/11
	// retaliate with launcher after a number of consecutive hits
	// bigdog_check_launcher_retaliate( attacker );

	return returnDamage;
}

bigdog_bullet_hint_trigger( attacker, damage, meansofdeath, weapon )
{
	DEFAULT( self.n_bullet_damage, 0 );
		
	if ( self.bulletHintShown && self.chargedbulletHintShown )
	{
		return;
	}
		
	if ( IsPlayer( attacker ) )
	{
		if ( !self.chargedbulletHintShown && ( ( attacker.chargeShotLevel != 0 ) && attacker.chargeShotLevel < MIN_CHARGE_SHOTLEVEL ) )
		{
			if ( !IsDefined( self.bullet_hint_timer ) || ( level.bullet_hint_timer get_time_in_seconds() > 5 ) )
			{
				level thread show_bullet_charge_hint();
				
				level.bullet_hint_timer = new_timer();
				self.n_bullet_damage = 0;
				self.chargedbulletHintShown = true;
			}
		}
		else if ( !self.bulletHintShown && is_bullet_damage( attacker, meansofdeath ) )
		{
			self.n_bullet_damage += damage;
			
			if ( self.n_bullet_damage > 500 )
			{
				if ( !IsDefined( level.bullet_hint_timer ) || ( level.bullet_hint_timer get_time_in_seconds() > 5 ) )
				{
					level thread show_bullet_damage_hint();
					
					level.bullet_hint_timer = new_timer();
					self.n_bullet_damage = 0;
					self.bulletHintShown = true;
				}
			}
		}
	}
}

is_bullet_damage( attacker, mod )
{
	if ( mod == "MOD_PISTOL_BULLET" || mod == "MOD_RIFLE_BULLET" || mod == "MOD_HEAD_SHOT" )
	{
		weaponCharged = IsDefined( attacker ) && IsDefined( attacker.chargeShotLevel ) && attacker.chargeShotLevel >= MIN_CHARGE_SHOTLEVEL;
		
		return !weaponCharged;
	}
	
	return false;
}

show_bullet_damage_hint()
{
	screen_message_create( &"SCRIPT_HINT_BULLET_DAMAGE" );
	wait 3;
	screen_message_delete();
}

show_bullet_charge_hint()
{
	screen_message_create( &"SCRIPT_HINT_CHARGED_SHOT" );
	wait 3;
	screen_message_delete();
}

bigdog_try_pain( location, returnDamage )
{	
	if( self.hitCount[ location ] > self.hitCountPainThreshold )
	{
		// play pain anim
		returnDamage = self.minPainDamage + 1;

		// reset, so only one anim at a time
		self.hitCount[ location ] = 0;

		// let the dog fight for a while
		self.nextPainTime = GetTime() + 3000;
	}

	return returnDamage;
}

bigdog_check_launcher_retaliate( attacker )
{
	increase_hit_count( "total" );

	if( self.grenadeammo == 0 && self.hitCount[ "total" ] > self.hitCountLauncherThreshold && GetTime() > self.retaliateCooloffTime )
	{
		bigdog_launcher_retaliate( attacker );
		
		//Play VO alert - Retaliate 
		self thread play_speech_warning_launcher();
	}
}

bigdog_launcher_retaliate( attacker )
{
	self endon("death");
	self endon("stop_grenade_launcher");

	// one at a time
	if( IS_TRUE(self.retaliating) )
		return;

	self.retaliating = true;

	// allow grenade launcher
	self.grenadeammo = 1;

	// aim at the last attacker
	self.favoriteEnemy = attacker;

	self waittill("grenade_fire");

	// stop firing
	self.grenadeammo = 0;

	self.retaliating = false;
	
	self.retaliateCooloffTime = GetTime() + 5000;
}

bigdog_try_launcher()
{	
	canUseLauncher = bigdog_can_use_launcher();
	shouldUseLauncher = canUseLauncher && self.a.wounded;
	
	// don't fire, even if loaded at this point
	if( !canUseLauncher )
	{
		self.grenadeammo = 0;
		self.grenade_fire = false;
		self notify( "stop_grenade_launcher" );
	}
	
	// not too many grenades between the claw and regular AI
	animscripts\bigdog\bigdog_utility::setActiveGrenadeTimer( self.enemy );
	
	selfCooloff 	= GetTime() >= self.launcherCooloffTime;
	globalCooloff 	= GetTime() >= anim.grenadeTimers[self.activeGrenadeTimer];
	
	if( shouldUseLauncher && IsDefined( self.enemy ) && selfCooloff && globalCooloff )
	{
		self thread bigdog_launcher_fire();
		
		self.launcherCooloffTime = GetTime() + RandomIntRange( LAUNCHER_COOLOFF_MIN, LAUNCHER_COOLOFF_MAX );
		
		// not too many grenades between the claw and regular AI
		nextGrenadeTimeToUse = animscripts\combat_utility::getDesiredGrenadeTimerValue();
		animscripts\combat_utility::setGrenadeTimer( self.activeGrenadeTimer, min( GetTime() + 5000, nextGrenadeTimeToUse ) );
	}
}

bigdog_can_use_launcher()
{
	if( !IsDefined( self.enemy ) )
		return false;
	
	if( DistanceSquared( self.origin, self.enemy.origin ) < LAUNCHER_MIN_DISTANCE_SQR )
		return false;
	
	yawToEnemy = GetYawToSpot( self.enemy.origin );
	if( abs( yawToEnemy ) > 90 )
		return false;
	
	return true;
}

bigdog_launcher_fire()
{
	self endon("death");
	self endon("stop_grenade_launcher");

	// one at a time
	if( IS_TRUE(self.grenade_fire) )
		return;
	
	//Play VO alert - Retaliate 
	self thread play_speech_warning_launcher();

	self.grenade_fire = true;

	// allow grenade launcher
	self.grenadeammo = 1;

	self waittill("grenade_fire");

	// stop firing
	self.grenadeammo = 0;

	self.grenade_fire = false;
	
	self.retaliateCooloffTime = GetTime() + 5000;
}

bigdog_damage_leg( damage, mod, weapon, leg, boneName )
{	
	legDamageMultiplier = 1.0;
		
	// grenades do more damage than normal to legs
	weaponType = WeaponType( weapon );
	if( weaponType == "grenade" )
		legDamageMultiplier = 2.0;
	
	self.partHealth[leg] -= damage * legDamageMultiplier;

	/#
	IPrintLn("leg: " + leg + " health: " + self.partHealth[leg]);
	#/

	// lose the leg
	if( self.partHealth[leg] < (self.initialHealthLeg / 2) )
	{		
		if( tryToBreakOffLeg( leg, self.partHealth[leg] <= 0 ) )
		{
			/*
			// die if the gibbing configuration warrants it
			if( shouldDieBecauseOfMissingLegs() )
			{
				self.canMove = false;
				
				return true;
			}
			else 
			*/
			if( !hasEnoughLegsToMove() )
			{
				//self playsound ("vox_claw_mobility_comp");
				
				self notify( "immobilized" );
				
				self.canMove = false;
			}
		}

		self.a.wounded = true;
		self notify( "wounded" );
	}

	if( GetTime() > self.nextPainTime )
	{
		increase_hit_count( leg );
	}

	return false;
}

tryToBreakOffLeg( leg, allOfIt )
{	
	// break off the top part now
	if( ALLOW_TOP_LEG_TO_BREAK_OFF && IsDefined( self.missingLegs[ leg ] ) && self.missingLegs[ leg ] == "bottom" && allOfIt )
	{
		// hide the entire leg
		self HidePart( anim.bigdog_globals.legHierarchy[ leg ][0] );
		
		// hide the damaged knee
		self HidePart( anim.bigdog_globals.legDamagedMap[ leg ] );
		
		// remove old fx
		boneName = anim.bigdog_globals.legHierarchy[leg][1];
		if( IsDefined( self.fx_ents[ boneName ] ) )
		{
		   self.fx_ents[ boneName ] Delete();
		   self.fx_ents[ boneName ] = undefined;
		}

		// add new fx higher up
		boneName = anim.bigdog_globals.legHierarchy[leg][0];
		bigdog_add_fx( boneName, anim._effect["bigdog_spark_big"], "wpn_bigdog_damaged" );
		
		// play the explosion effect
		PlayFXOnTag( anim._effect["bigdog_leg_explosion"], self, boneName );
		
		self.missingLegs[ leg ] = "top";
	}
	else if( !IsDefined( self.missingLegs[ leg ] ) ) // break off the bottom
	{		
		// hide all the currently showing bones from the knee down
		for( i=1; i < anim.bigdog_globals.legHierarchy[ leg ].size; i++ )
			self HidePart( anim.bigdog_globals.legHierarchy[ leg ][i] );
		
		// show the damaged knee
		self ShowPart( anim.bigdog_globals.legDamagedMap[ leg ] );
		
		boneName = anim.bigdog_globals.legHierarchy[leg][1];
		bigdog_add_fx( boneName, anim._effect["bigdog_spark_big"], "wpn_bigdog_damaged" );
		
		// play the explosion effect
		PlayFXOnTag( anim._effect["bigdog_leg_explosion"], self, boneName );
			
		self.missingLegs[ leg ] = "bottom";
		
		return true;
	}
	
	return false;
}

shouldDieBecauseOfMissingLegs()
{
	// can't stand on one leg
	if( self.missingLegs.size > 2 )
		return true;
	
	return false;
}

hasEnoughLegsToMove()
{
	/*
	// can't stand on two legs on one side or diagonals
	if( self.missingLegs.size == 2 )
	{
		if( IsDefined( self.missingLegs[ "FR" ] ) && IsDefined( self.missingLegs[ "RR" ] ) )
			return false;
		else if( IsDefined( self.missingLegs[ "FL" ] ) && IsDefined( self.missingLegs[ "RL" ] ) )
			return false;
		else if( IsDefined( self.missingLegs[ "FR" ] ) && IsDefined( self.missingLegs[ "RL" ] ) )
			return false;
		else if( IsDefined( self.missingLegs[ "FL" ] ) && IsDefined( self.missingLegs[ "RR" ] ) )
			return false;
	}
	*/
	
	// any two legs
	if( self.missingLegs.size > 1 )
		return false;
	
	return true;
}

bigdog_damage_body( damage, mod, weapon, vpoint )
{
	// bullets don't do no damage
	bodyDamageMultiplier = 0.0;
	
	// but grenades and rpg's do
	if( animscripts\pain::isExplosiveDamageMOD( mod ) )
		bodyDamageMultiplier = 1;

	self.partHealth[ "body" ] -= damage * bodyDamageMultiplier;

	/#
	IPrintLn("body: " + self.partHealth[ "body" ]);
	#/

	// kill the dog
	if( self.partHealth[ "body" ] <= 0 )
		return true;

	// sparks at halfway point
	if( self.partHealth[ "body" ] < (self.initialHealth / 2) )
	{
		self.a.wounded = true;
	}

	if( GetTime() > self.nextPainTime )
	{
		increase_hit_count( "body" );
	}

	return false;
}

bodyPieceFallsOff( point, anyPiece )
{
	direction = "front";
	
	if( !IsDefined(point) )
		anyPiece = true;
	
	if( IS_TRUE(anyPiece) )
	{
		keys = GetArrayKeys( self.bodyDamageMap );
		foreach( key in keys )
		{
			if( self.bodyDamageMap[key].size > 0 )
			{
				direction = key;
				break;
			}
		}
	}
	else
	{
		yaw = animscripts\utility::GetYawToSpot( point );
		
		if( yaw >= 135 || yaw <= -135 )
			direction = "back";
		else if( yaw > 45 && yaw < 135 )
			direction = "right";
		else if( yaw < -45 && yaw > -135 )
			direction = "left";
	}
	
	// pick a random bone that's still available for that direction
	boneArray = self.bodyDamageMap[ direction ];
	
	if( boneArray.size > 0 )
	{
		boneIndex = RandomIntRange( 0, boneArray.size );
		
		self HidePart( boneArray[boneIndex] );
		
		// add a persistent spark effect
		bigdog_add_fx( boneArray[boneIndex], anim._effect["bigdog_spark_big"], "wpn_bigdog_damaged" );
		
		// play the explosion effect
		PlayFXOnTag( anim._effect["bigdog_panel_explosion_large"], self, boneArray[boneIndex] );
		
		// add smoke
		if( self.smokeStacks == 0 && self.partHealth[ "body" ] < (self.initialHealth * 0.66) )
		{
			bigdog_add_fx( boneArray[boneIndex], anim._effect["bigdog_smoke"] );
			self.smokeStacks++;
		}
		else if( self.smokeStacks == 1 && self.partHealth[ "body" ] < (self.initialHealth * 0.33) )
		{
			bigdog_add_fx( boneArray[boneIndex], anim._effect["bigdog_smoke"] );
			self.smokeStacks++;
		}
				
		// make sure it won't be hidden again
		self.bodyDamageMap[ direction ] = boneArray;
		ArrayRemoveIndex(self.bodyDamageMap[direction],boneIndex);
		
		// set the next threshold
		self.hidePieceHealthThreshold = self.hidePieceHealthThreshold - (self.initialHealth / self.hidePieceCount);
	}
	else if( !IS_TRUE(anyPiece) )
	{
		// no pieces left in that direction, just start removing others
		return bodyPieceFallsOff( point, true );
	}
}

increase_hit_count( bodyPart )
{
	self.hitCount[ bodyPart ] += 1;
}

decay_hit_counts()
{
	self endon("death");

	decayRate = 0.15; // 3 hits per second

	while(1)
	{
		keys = GetArrayKeys( self.hitCount );
		foreach( key in keys )
		{
			if( self.hitCount[key] > 0 )
			{
				self.hitCount[key] = max( 0, self.hitCount[key] - decayRate );
				//PrintLn( key + ": " + self.hitCount[key] );
			}
		}

		wait(0.05);
	}
}

///AUDIO///

bigdog_targeting_audio()
{
	self endon("death");
	while(1)
	{
		self.turret waittill( "fire_on_target" );
		//IPrintLnBold( "turretontarget" );
		if (self.audio_is_targeting)
		{
			self.turret playsound( "wpn_bigdog_turret_lockon_npc" );
			wait(1);
		}

	}
}

walking_loop_audio()
{
	self endon("death");
	
	self thread stop_sounds_on_death();

	self playloopsound( "blk_bigdog_loop" , .1 );

	while(1)
	{
		if( self.a.wounded == true )
		{
			self thread damaged_walking_audio();
			break;
		}

		wait_network_frame(); 
	}
}

stop_sounds_on_death()
{
	self waittill( "death" );

	if ( IsDefined( self ) )
	{
		self StopLoopSound( .1 );
	}
}

damaged_walking_audio()
{
	self endon( "death" );
	self stoploopsound(.1);
	wait .2;
	self playloopsound( "blk_bigdog_vuln_loop" , .1 );
	self playsound ("");
}

play_spawn_alarm()
{
	self endon("death");
	
	wait(0.5);
	wait(RandomIntRange(1,6));
	
	// don't play the alarm until an enemy appears
	//Shawn J 4/3/2012 - changing this to play as it spawns (the wait for enemy was causing conflicts 
	//                 with the new alerts for hunker/stand)
	//if( !self bigdog_has_target() )
		//self waittill( "enemy" );
	
	self playsound ("veh_claw_alert");
	
	//SOUND - Shawn J - hand-scripting this VO temporarily
	//TODO - remove call once systematic claw VO is in place - also remove variable setting
	wait (4);
	
	if (level.is_player_inside_arena == false)
	{
		//self playsound ("vox_claw_thrt_100m");
	}
	else
	{
		//self playsound ("vox_claw_perimeter_breach");
	}
}

play_speech_warning_launcher()
{
	self playsound ("veh_claw_alert_grenade");
}

play_speech_warning()
{
	if (!IsDefined (level.bigdog_speak ))
	{
		level.bigdog_speak = 0;	
	}
	if(level.bigdog_speak == 0)
	{
		level.bigdog_speak = 1;
		self playsound ("veh_claw_speak_alert", "sound_complete");
		self waittill ("sound_complete");
		self playsound ("veh_claw_vo", "sound_complete");
		self waittill ("sound_complete");
		level.bigdog_speak = 0;
	}
}

play_ambient_VO()
{
	self endon("death");
	//If we like this, we'll have to implement it differently
	while(1)
	{
		speechvar = randomintrange (0, 100);
		if (speechvar < 30 && self bigdog_has_target() )
		{
			self thread play_speech_warning();
		}
		wait(5.0);
	}		
		
}
