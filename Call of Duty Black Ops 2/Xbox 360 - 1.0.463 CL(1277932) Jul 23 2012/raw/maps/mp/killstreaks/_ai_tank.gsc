#include maps\mp\_utility;
#include maps\mp\gametypes\_weapons;
#include common_scripts\utility;
#include maps\mp\killstreaks\_killstreaks;
#include maps\mp\killstreaks\_supplydrop;
#include maps\mp\killstreaks\_airsupport;

#insert raw\maps\mp\_clientflags.gsh;

#define AI_TANK_LIFETIME				120
#define AI_TANK_HEALTH					800
#define AI_TANK_PATH_TIMEOUT			45
#define AI_TANK_MIN_REACTION_TIME		1.15
#define AI_TANK_MAX_REACTION_TIME		1.525
#define AI_TANK_BULLET_MITIGATION		0.3
#define AI_TANK_EXPLOSIVE_MITIGATION	1.5
#define AI_TANK_STUN_DURATION			5
#define AI_TANK_STUN_DURATION_PROXIMITY 2

#define TANK_ROCKET_AMMO_MAX			3
#define TANK_ROCKET_RELOAD_SECS			2

#using_animtree ( "mp_vehicles" );

init()
{
	PrecacheVehicle( "ai_tank_drone_mp" );
	PrecacheModel( "veh_t6_drone_tank" );
	PrecacheModel( "veh_t6_drone_tank_alt" );
	PrecacheItem( "ai_tank_drone_rocket_mp" );
	precacheitem( "killstreak_ai_tank_mp" );
	PrecacheShader( "mech_check_line" );
	PrecacheShader( "mech_check_fill" );
	PrecacheShader( "mech_flame_bar" );
	PrecacheShader( "mech_flame_arrow_flipped" );
		
	loadfx( "vehicle/treadfx/fx_treadfx_talon_dirt" );
	loadfx( "vehicle/treadfx/fx_treadfx_talon_concrete" );
	loadfx( "light/fx_vlight_talon_eye_grn" );
	loadfx( "light/fx_vlight_talon_eye_red" );
	loadfx( "weapon/talon/fx_talon_emp_stun" );

	level.ai_tank_minigun_flash_3p = loadfx("weapon/talon/fx_muz_talon_rocket_flash_1p");

	registerKillstreak( "inventory_ai_tank_drop_mp", "inventory_ai_tank_drop_mp", "killstreak_ai_tank_drop", "ai_tank_drop_used", ::useKillstreakAITankDrop );
	registerKillstreakAltWeapon( "inventory_ai_tank_drop_mp", "ai_tank_drone_gun_mp" );
	registerKillstreakAltWeapon( "inventory_ai_tank_drop_mp", "ai_tank_drone_rocket_mp" );
	registerKillstreakRemoteOverrideWeapon( "inventory_ai_tank_drop_mp", "killstreak_ai_tank_mp" );
	registerKillstreakStrings( "inventory_ai_tank_drop_mp", &"KILLSTREAK_EARNED_AI_TANK_DROP", &"KILLSTREAK_AI_TANK_NOT_AVAILABLE", &"KILLSTREAK_AI_TANK_INBOUND" );
	registerKillstreakDialog( "inventory_ai_tank_drop_mp", "mpl_killstreak_ai_tank", "kls_aitank_used", "","kls_aitank_enemy", "", "kls_aitank_ready" );
	registerKillstreakDevDvar( "inventory_ai_tank_drop_mp", "scr_giveaitankdrop" );

	registerKillstreak( "ai_tank_drop_mp", "ai_tank_drop_mp", "killstreak_ai_tank_drop", "ai_tank_drop_used", ::useKillstreakAITankDrop );
	registerKillstreakAltWeapon( "ai_tank_drop_mp","ai_tank_drone_gun_mp" );
	registerKillstreakAltWeapon( "ai_tank_drop_mp", "ai_tank_drone_rocket_mp" );
	registerKillstreakRemoteOverrideWeapon( "ai_tank_drop_mp", "killstreak_ai_tank_mp" );
	registerKillstreakStrings( "ai_tank_drop_mp", &"KILLSTREAK_EARNED_AI_TANK_DROP", &"KILLSTREAK_AI_TANK_NOT_AVAILABLE", &"KILLSTREAK_AI_TANK_INBOUND" );
	registerKillstreakDialog( "ai_tank_drop_mp", "mpl_killstreak_ai_tank", "kls_aitank_used", "","kls_aitank_enemy", "", "kls_aitank_ready" );

	level.ai_tank_fov				= Cos( 160 );
	level.ai_tank_turret_fire_rate	= WeaponFireTime( "ai_tank_drone_gun_mp" );

	level.ai_tank_valid_locations = [];
	spawns = maps\mp\gametypes\_spawnlogic::getSpawnpointArray( "mp_tdm_spawn" );
	
	level.ai_tank_damage_fx = loadfx( "weapon/talon/fx_talon_damage_state" );
	level.ai_tank_explode_fx = loadfx( "weapon/talon/fx_talon_exp" );
	level.ai_tank_crate_explode_fx = loadfx( "weapon/talon/fx_talon_drop_box" );

	foreach( spawn in spawns )
	{
		level.ai_tank_valid_locations[ level.ai_tank_valid_locations.size ] = spawn.origin;
	}

	anims = [];
	anims[ anims.size ] = %o_drone_tank_missile1_fire;
	anims[ anims.size ] = %o_drone_tank_missile2_fire;
	anims[ anims.size ] = %o_drone_tank_missile3_fire;
	anims[ anims.size ] = %o_drone_tank_missile_full_reload;

	SetDvar("scr_ai_tank_no_timeout", 0);
/#
	level thread tank_devgui_think();
#/

}

register()
{
	RegisterClientField( "vehicle", "ai_tank_death", 1, "int" );
	RegisterClientField( "vehicle", "ai_tank_hack_spawned", 1, "int" );
	RegisterClientField( "vehicle", "ai_tank_hack_rebooting", 1, "int" );
	RegisterClientField( "vehicle", "ai_tank_missile_fire", 3, "int" );
}

useKillstreakAITankDrop(hardpointType)
{	
	team = self.team;
	
	if( !self maps\mp\killstreaks\_supplydrop::isSupplyDropGrenadeAllowed( hardpointType ) )
	{
		return false;
	}

	killstreak_id = self maps\mp\killstreaks\_killstreakrules::killstreakStart( hardpointType, team, false, false );
	if ( killstreak_id == -1 )
	{
		return false;
	}

	result = self maps\mp\killstreaks\_supplydrop::useSupplyDropMarker( killstreak_id );
	
	// the marker is out but the chopper is yet to come
	self notify( "supply_drop_marker_done" );

	if ( !IsDefined(result) || !result )
	{
		maps\mp\killstreaks\_killstreakrules::killstreakStop( hardpointType, team, killstreak_id );
		return false;
	}

	return result;
}

crateLand( crate, weaponname, owner, team )
{
	if ( !crate valid_location() || team != owner.team || owner maps\mp\killstreaks\_emp::isEnemyEMPKillstreakActive() )
	{
		maps\mp\killstreaks\_killstreakrules::killstreakStop( weaponname, team, crate.package_contents_id );
		wait( 10 );
		crate delete();
		return;
	}

	origin = crate.origin;

	crateBottom = BulletTrace( origin, origin + (0, 0, -50), false, crate );
	if ( isDefined( crateBottom ) )
	{
		origin = crateBottom["position"] + (0,0,1);
	}
	
	PlayFX( level.ai_tank_crate_explode_fx, origin, (1, 0, 0), (0, 0, 1) );
	PlaySoundAtPosition( "veh_talon_crate_exp", crate.origin );

	level thread ai_tank_killstreak_start( owner, origin, crate.package_contents_id, weaponname );

	crate delete();
}

valid_location()
{
	origin = self.origin + ( 0, 0, 32 );

	level.ai_tank_valid_locations = array_randomize( level.ai_tank_valid_locations );
	
	count = Min( level.ai_tank_valid_locations.size, 5 );

	for ( i = 0; i < count; i++ )
	{
		if ( FindPath( origin, level.ai_tank_valid_locations[ i ], self, false ) )
		{
			return true;
		}
	}

	return false;
}

ai_tank_killstreak_start( owner, origin, killstreak_id, weaponname )
{
	waittillframeend;
	drone = SpawnVehicle( "veh_t6_drone_tank", "talon", "ai_tank_drone_mp", origin, (0, 0, 0) );
	drone SetEnemyModel( "veh_t6_drone_tank_alt" );
	drone playloopsound ("veh_talon_idle_npc", .2);
	drone SetVehicleAvoidance( true );

	drone SetOwner( owner );
	drone.owner = owner;
	drone.team = owner.team;
	drone.aiteam = owner.team;
	drone.killstreak_id = killstreak_id;
	drone.type = "tank_drone";

	if ( level.teamBased )
	{
		drone SetTeam( owner.team );
	}
	else
	{
		drone SetTeam( "free" );
	}

	drone maps\mp\_entityheadicons::setEntityHeadIcon( drone.team, drone, ( 0, 0, 52 ) );

	// create the influencers
	drone maps\mp\gametypes\_spawning::create_aitank_influencers( drone.team );
	
	drone.controlled = false;
	drone MakeVehicleUnusable();
	
	drone.numberRockets = TANK_ROCKET_AMMO_MAX;
	drone.warningShots = 3;
	drone SetDrawInfrared( true );
	
	//set up number for this drone
	if (!isDefined(drone.owner.numTankDrones))
		drone.owner.numTankDrones=1;
	else
		drone.owner.numTankDrones++;
	drone.ownerNumber = drone.owner.numTankDrones;
	
	// make the drone targetable
	Target_Set( drone, (0,0,0) );
	Target_SetTurretAquire( drone, false );
	
	drone thread tank_move_think();
	drone thread tank_aim_think();
	drone thread tank_combat_think();
	drone thread tank_death_think(weaponName);
	drone thread tank_damage_think();
	drone thread tank_abort_think();
	drone thread tank_ground_abort_think();
	drone thread tank_riotshield_think();
	drone thread tank_rocket_watch();
	
	owner maps\mp\killstreaks\_remote_weapons::initRemoteWeapon( drone, "killstreak_ai_tank_mp");

	drone thread deleteOnKillbrush( drone.owner );
	level thread tank_game_end_think(drone);
	
/#
	//drone thread tank_debug_health();
#/
}

tank_abort_think()
{
	self endon( "death" );
	
	self.owner wait_endon( AI_TANK_LIFETIME, "disconnect", "joined_team", "joined_spectators", "emp_jammed" );
	shouldTimeout = GetDvar("scr_ai_tank_no_timeout");	
	if (shouldTimeout == "1")
	{
		return;
	}		
	self notify( "death" );
}

tank_game_end_think(drone)
{
	drone endon( "death" );
	
	level waittill("game_ended");

	drone notify( "death" );
}


stop_remote() // dead
{
	if ( !isDefined( self ) )
		return;

	self clearUsingRemote();
	self.killstreak_waitamount = undefined;
	self destroy_remote_hud();	
	self ClientNotify( "nofutz" );
}

tank_damage_think()
{
	self endon( "death" );

	self.maxhealth = 999999;
	self.health = self.maxhealth;
	self.isStunned = false;
	
	low_health = false;
	damage_taken = 0;

	for ( ;; )
	{
		self waittill( "damage", damage, attacker, dir, point, mod, model, tag, part, weapon, flags );

		self.maxhealth = 999999;
		self.health = self.maxhealth;

/#
		self.damage_debug = ( damage + " (" + weapon + ")" );
#/

		if ( weapon == "emp_grenade_mp" && (mod == "MOD_GRENADE_SPLASH"))
		{
			damage_taken += ( AI_TANK_HEALTH / 2 );
			damage = 0;
			if ( !self.isStunned )
			{
				maps\mp\_challenges::stunnedTankWithEMPGrenade( attacker );
				self thread tank_stun( AI_TANK_STUN_DURATION );
				self.isStunned = true;
			}
		}
		
		if ( !self.isStunned )
		{
			if ( (weapon == "proximity_grenade_mp" || weapon == "proximity_grenade_aoe_mp" ) && (mod == "MOD_GRENADE_SPLASH" || mod == "MOD_GAS") )
			{
					self thread tank_stun( AI_TANK_STUN_DURATION_PROXIMITY );
					self.isStunned = true;
			}
		}
		
		if ( mod == "MOD_RIFLE_BULLET" || mod == "MOD_PISTOL_BULLET" || weapon == "hatchet_mp" || (mod == "MOD_PROJECTILE_SPLASH" && isExplosiveBulletWeapon(weapon)) )
		{
			if ( isPlayer( attacker ) )
			    if ( attacker HasPerk( "specialty_armorpiercing" ) )
					damage += int( damage * level.cac_armorpiercing_data );
			damage *= AI_TANK_BULLET_MITIGATION;
		}
		
		if ( ( mod == "MOD_PROJECTILE" || mod == "MOD_GRENADE_SPLASH" || mod == "MOD_PROJECTILE_SPLASH" ) && damage != 0 && weapon != "emp_grenade_mp" && !isExplosiveBulletWeapon(weapon))
		{
			damage *= AI_TANK_EXPLOSIVE_MITIGATION;
		}

		damage_taken += damage;

		if ( damage_taken >= AI_TANK_HEALTH )
		{
			self notify( "death", attacker, mod, weapon );
			return;
		}

		if ( !low_health && damage_taken > AI_TANK_HEALTH / 1.8 )
		{
			self thread tank_low_health_fx();
			low_health = true;
		}

		if ( IsDefined( attacker ) && IsPlayer( attacker ) && self tank_is_idle() && !self.isStunned )
		{
			self.aim_entity.origin = attacker GetCentroid();
			self.aim_entity.delay = 8;
			self notify( "aim_updated" );
		}
	}
}

tank_low_health_fx()
{
	self endon( "death" );
	
	self.damage_fx = Spawn( "script_model", self GetTagOrigin("tag_origin") + (0,0,-14) );
	self.damage_fx SetModel( "tag_origin" );
	self.damage_fx LinkTo(self, "tag_turret", (0,0,-14), (0,0,0) );
	wait ( 0.1 );
	PlayFXOnTag( level.ai_tank_damage_fx, self.damage_fx, "tag_origin" );	
}

deleteOnKillbrush(player)
{
	player endon("disconnect");
	self endon("death");
		
	killbrushes = GetEntArray( "trigger_hurt","classname" );

	while(1)
	{
		for (i = 0; i < killbrushes.size; i++)
		{
			if (self istouching(killbrushes[i]) )
			{
				
				if( self.origin[2] > player.origin[2] )
					break;

				if ( isdefined(self) )
				{
					self notify( "death", self.owner );
				}

				return;
			}
		}
		wait( 0.1 );
	}
	
}

tank_stun( duration )
{	
	self endon( "death" );
	self notify( "stunned" );
	
	self ClearVehGoalPos();
	forward = AnglesToForward( self.angles );
	forward = self.origin + forward * 128;
	forward = forward - ( 0, 0, 64 );
	self SetTurretTargetVec( forward );
	self DisableGunnerFiring( 0, true );
	
	if (self.controlled)
	{
		self.owner FreezeControls( true );
	}
	if (isDefined(self.owner.fullscreen_static))
	{
		self.owner thread maps\mp\killstreaks\_remote_weapons::stunStaticFX( duration );
	}
	self SetClientFlag( CLIENT_FLAG_STUN );
	wait ( duration );
	self ClearClientFlag( CLIENT_FLAG_STUN );
	if (self.controlled)
	{
		self.owner FreezeControls( false );
	}
	
	if (self.controlled == false)
	{
		self thread tank_move_think();
		self thread tank_aim_think();
		self thread tank_combat_think();
	}

	self DisableGunnerFiring( 0, false );
	self.isStunned = false;
}

emp_crazy_death()
{
	self SetClientFlag( CLIENT_FLAG_STUN );
	
	wait( 1 );
	self notify ("death");
	
	time = 0;
	randomAngle = RandomInt(360);
	while (time < 1.45)
	{
		self SetTurretTargetVec(self.origin + AnglesToForward((RandomIntRange(305, 315), int((randomAngle + time * 180)), 0)) * 100);
		if (time > 0.2)
		{
			self FireWeapon();
			if ( RandomInt(100) > 85)
			{
				self FireGunnerWeapon(0);
			}
		}
		time += 0.05;
		wait (0.05);
	}
	self SetClientField( "ai_tank_death", 1 );

	PlayFX( level.ai_tank_explode_fx, self.origin, (0, 0, 1) );
	PlaySoundAtPosition( "mpl_sab_exp_suitcase_bomb_main", self.origin );
	wait ( 0.05 );
	self hide();
}

tank_death_think( hardpointName )
{
	self.owner endon( "disconnect" );
	
	team = self.team;
	self waittill( "death", attacker, type, weapon );
	self.dead = true;
	self LaserOff();

	self ClearVehGoalPos();
		
	if ( self.controlled == true )
	{
		self.owner thread maps\mp\killstreaks\_remotemissile::staticEffect( 1.0 );
		self.owner destroy_remote_hud();	
	}
	if (self.isStunned)
	{
		stunned = true;
		self thread emp_crazy_death();
		wait( 1.55 );
	}
	else
	{
		self SetClientField( "ai_tank_death", 1 );
		stunned = false;
		PlayFX( level.ai_tank_explode_fx, self.origin, (0, 0, 1) );
		PlaySoundAtPosition( "mpl_sab_exp_suitcase_bomb_main", self.origin );
		wait( 0.05 );
		self hide();

		if (isDefined(self.damage_fx))
		{
			self.damage_fx delete();
		}
	}
	
	if ( IsDefined( attacker ) && IsPlayer( attacker ) && attacker != self.owner )
	{
		if ( level.teamBased && attacker.team == self.team )
		{
		}
		else
		{
			maps\mp\_scoreevents::processScoreEvent( "destroyed_aitank", attacker, self, weapon );
		}
	}

	wait( 2 );
	maps\mp\killstreaks\_killstreakrules::killstreakStop( hardpointName, team, self.killstreak_id );

	self.aim_entity delete();
	self delete();
}

tank_move_think()
{
	self endon( "death" );
	self endon( "stunned" );
	self endon( "remote_start" );
	level endon ( "game_ended" );

/#
	self endon( "debug_patrol" );
#/

	do_wait = true;

	for ( ;; )
	{
		if ( do_wait )
		{
			wait( RandomFloatRange( 1, 4 ) );
		}

		do_wait = true;

		if ( !tank_is_idle() )
		{
			enemy = tank_get_target();

			if ( valid_target( enemy, self.team, self.owner ) )
			{
				if ( DistanceSquared( self.origin, enemy.origin ) < 256 * 256 )
				{
					self ClearVehGoalPos();
					wait( 1 );
				}
				else if ( FindPath( self.origin, enemy.origin, self, false ) )
				{
					self SetVehGoalPos( enemy.origin, true, 2 );
					self wait_endon( 3, "reached_end_node" );
				}
				else
				{
					self ClearVehGoalPos();
					wait( 1 );
				}

				if ( valid_target( enemy, self.team, self.owner ) )
				{
					do_wait = false;
				}

				continue;
			}
		}

		avg_position = tank_compute_enemy_position();

		if ( IsDefined( avg_position ) )
		{
			nodes = GetNodesInRadiusSorted( avg_position, 256, 0 );
		}
		else
		{
			nodes = GetNodesInRadiusSorted( self.owner.origin, 1024, 256, 128 );
		}
		
		if ( nodes.size > 0 )
		{
			node = nodes[0];
		}
		else
		{
			continue;
		}

		if ( self SetVehGoalPos( node.origin, true, 2 ) )
		{
			event = self waittill_any_timeout( AI_TANK_PATH_TIMEOUT, "reached_end_node", "force_movement_wake" );

			if ( event != "reached_end_node" )
			{
				do_wait = false;
			}
		}
		else
		{
			self ClearVehGoalPos();
		}
	}
}

// attempts to re-path around friendly deployed riotshields
tank_riotshield_think()
{
	self endon( "death" );
	self endon( "remote_start" );

	for ( ;; )
	{
		level waittill( "riotshield_planted", owner );

		if ( owner == self.owner || owner.team == self.team )
		{
			if ( DistanceSquared( owner.riotshieldEntity.origin, self.origin ) < 512 * 512 )
			{
				self ClearVehGoalPos();
			}
			
			self notify( "force_movement_wake" ); // wake up the movement thread
		}
	}
}

tank_ground_abort_think()
{
	self endon( "death" );

	ground_trace_fail = 0;

	for ( ;; )
	{
		wait( 1 );

		nodes = GetNodesInRadius( self.origin, 512, 8, 128, "Path" );

		down = AnglesToUp( self.angles );
		down = self.origin + ( down * -26 );

		if ( BulletTracePassed( self.origin + (AnglesToUp( self.angles) * 10), down, false, self ) )
		{
			ground_trace_fail++;
		}
		else if ( nodes.size <= 0 )
		{
			ground_trace_fail++;
		}
		else
		{
			ground_trace_fail = 0;
		}

		if ( ground_trace_fail >= 4 )
		{
			self notify( "death" );
		}
	}
}

tank_aim_think()
{
	self endon( "death" );
	self endon( "stunned" );
	self endon( "remote_start" );

	if ( !IsDefined( self.aim_entity ) )
	{
		self.aim_entity = Spawn( "script_model", (0, 0, 0) );
	}
			
	self.aim_entity.delay = 0;

	self tank_idle();

	for ( ;; )
	{
		self wait_endon( RandomFloatRange( 1, 3 ), "aim_updated" );

		if ( self.aim_entity.delay > 0 )
		{
			wait( self.aim_entity.delay );
			self.aim_entity.delay = 0;
			continue;
		}

		if ( !tank_is_idle() )
		{
			continue;
		}

		if ( self GetSpeed() <= 1 )
		{
			enemies = tank_get_player_enemies( false );

			if ( enemies.size )
			{
				enemy = enemies[0];
				node = GetVisibleNode( self.origin, enemy.origin, self );

				if ( IsDefined( node ) )
				{
					self.aim_entity.origin = node.origin + ( 0, 0, 16 );
					continue;
				}
			}
		}

		yaw	= ( 0, self.angles[1] + RandomIntRange( -75, 75 ), 0 );
		forward = AnglesToForward( yaw );

		origin = self.origin + forward * 1024;
		self.aim_entity.origin = ( origin[0], origin[1], origin[2] + 20 );
	}
}

tank_combat_think()
{
	self endon( "death" );
	self endon( "stunned" );
	self endon( "remote_start" );
	level endon ( "game_ended" );

	for ( ;; )
	{
		wait( 0.5 );

		self LaserOff();

		origin = self.origin + ( 0, 0, 32 );
		forward = VectorNormalize( self.target_entity.origin - self.origin );

		players = tank_get_player_enemies( false );
		self tank_target_evaluate( players, origin, forward );

		if ( level.gameType != "hack" )
		{
			dogs = maps\mp\killstreaks\_dogs::dog_manager_get_dogs();
			self tank_target_evaluate( dogs, origin, forward );

			tanks = GetEntArray( "talon", "targetname" );
			self tank_target_evaluate( tanks, origin, forward );

			shields = GetEntArray( "riotshield_mp", "targetname" );
			self tank_target_evaluate( shields, origin, forward );
		}
	}
}

tank_target_evaluate( targets, origin, forward )
{
	foreach( target in targets )
	{
		if ( !valid_target( target, self.team, self.owner ) )
		{
			continue;
		}

		delta = target.origin - origin;
		delta = VectorNormalize( delta );

		dot = VectorDot( forward, delta );

		if ( dot < level.ai_tank_fov )
		{
			continue;
		}

		if ( !BulletTracePassed( origin, target GetCentroid(), false, target ) )
		{
			continue;
		}
		
		self tank_engage( target );
		break;
	}

	self tank_idle();
}

tank_engage( enemy )
{
	do_fire_delay = true;
	warning_shots = self.warningShots;

	self LaserOn();

	for ( ;; )
	{
		if ( !valid_target( enemy, self.team, self.owner ) )
		{
			return;
		}

		fire_rocket = ( warning_shots <= 2 && self tank_should_fire_rocket( enemy ) );
		self tank_set_target( enemy, fire_rocket );

		if ( fire_rocket )
		{
			self ClearVehGoalPos();
		}

		event = self waittill_any_return( "turret_on_vistarget", "turret_no_vis" );

		if ( !valid_target( enemy, self.team, self.owner ) )
		{
			return;
		}

		self.aim_entity.origin = enemy GetCentroid();

		distSq = DistanceSquared( self.origin, enemy.origin );

		if ( distSq > 64 * 64 && event == "turret_no_vis" )
		{
			self tank_target_lost();

			if ( self tank_is_idle() )
			{
				return;
			}

			continue;
		}
		else
		{
			self notify( "force_movement_wake" ); // wake up the movement thread
		}
		
		if ( event == "turret_no_vis" )
		{
			warning_shots = self.warningShots;	
		}

		if ( do_fire_delay )
		{
			self PlaySound( "mpl_turret_alert" ); 
			wait( RandomFloatRange( AI_TANK_MIN_REACTION_TIME, AI_TANK_MAX_REACTION_TIME ) );
			do_fire_delay = false;

			if ( !valid_target( enemy, self.team, self.owner ) )
			{
				return;
			}
		}

		if ( fire_rocket )
		{
			rocket = self FireGunnerWeapon( 0, self.owner );

			if ( IsDefined( rocket ) )
			{
				rocket.killcament = self;
				rocket wait_endon( RandomFloatRange( 0.5, 1 ), "death" );
				continue;
			}
		}

		self FireWeapon();
		warning_shots--;
		wait( level.ai_tank_turret_fire_rate );

		if ( IsDefined( enemy ) && !IsAlive( enemy ) )
		{
			bullets = RandomIntRange( 8, 15 );
			for ( i = 0; i < bullets; i++ )
			{
				self FireWeapon();
				wait( level.ai_tank_turret_fire_rate );
			}
		}
	}
}

tank_target_lost()
{
	self endon( "turret_on_vistarget" );

	wait( 5 );
	self tank_idle();
}

tank_should_fire_rocket( enemy )
{
	if ( self.numberRockets <= 0 )
	{
		return false;
	}

	if ( DistanceSquared( self.origin, enemy.origin ) < 384 * 384 )
	{
		return false;
	}

	origin = self GetTagOrigin( "tag_flash_gunner1" );

	if ( !BulletTracePassed( origin, enemy.origin + ( 0, 0, 10 ), false, enemy, self ) )
	{
		return false;
	}

	return true;
}

tank_set_target( entity, use_rocket )
{
	if ( !IsDefined( use_rocket ) ) 
	{
		use_rocket = false;
	}

	self.target_entity = entity;

	if ( use_rocket )
	{
		velocity = entity GetVelocity();
		speed = Length( velocity );

		forward = AnglesToForward( entity.angles );
		origin = VectorScale( forward, speed );

		self SetTurretTargetEnt( entity, origin );
		return;
	}

	self SetTurretTargetEnt( entity );
}

tank_get_target()
{
	return ( self.target_entity );
}

tank_idle()
{
	tank_set_target( self.aim_entity );
}

tank_is_idle()
{
	return ( tank_get_target() == self.aim_entity );
}

tank_has_radar()
{
	if ( level.teambased )
	{
		return ( maps\mp\killstreaks\_radar::teamHasSpyplane( self.team ) || maps\mp\killstreaks\_radar::teamHasSatellite( self.team ) ); 
	}

	return ( is_true( self.owner.hasSpyplane ) || is_true( self.owner.hasSatellite ) );
}

tank_get_player_enemies( on_radar )
{
	enemies = [];
	
	if ( !IsDefined( on_radar ) )
	{
		on_radar = false;
	}

	if ( on_radar )
	{
		time = GetTime();
	}
	
	foreach( teamKey, team in level.alivePlayers )
	{
		if ( level.teambased && teamKey == self.team )
		{
			continue;
		}

		foreach( player in team )
		{
			if ( !valid_target( player, self.team, self.owner ) )
			{
				continue;
			}
			
			if ( on_radar )
			{
				if ( time - player.lastFireTime > 3000 && !tank_has_radar() )
				{
					continue;
				}
			}

			enemies[ enemies.size ] = player;
		}
	}

	return enemies;
}

tank_compute_enemy_position()
{
	enemies = tank_get_player_enemies( false );
	position = undefined;

	if ( enemies.size )
	{
		x = 0;
		y = 0;
		z = 0;
		
		foreach( enemy in enemies )
		{
			x += enemy.origin[0];
			y += enemy.origin[1];
			z += enemy.origin[2];
		}

		x /= enemies.size;
		y /= enemies.size;
		z /= enemies.size;

		position = ( x, y, z );
	}

	return position;
}

valid_target( target, team, owner )
{
	if ( !IsDefined( target ) )
	{
		return false;
	}

	if ( !IsAlive( target ) )
	{
		return false;
	}

	if ( target == owner )
	{
		return false;
	}
	
	if ( IsPlayer( target ) )
	{
		if ( target.sessionstate != "playing" )
		{
			return false;
		}

		if ( IsDefined( target.lastspawntime ) && GetTime() - target.lastspawntime < 3000 )
		{
			return false;
		}

/#
		if ( target IsInMoveMode( "ufo", "noclip" ) )
		{
			return false;
		}
#/
	}

	if ( level.teambased )
	{
		if ( IsDefined( target.team ) && team == target.team )
		{
			return false;
		}

		if ( IsDefined( target.aiteam ) && team == target.aiteam )
		{
			return false;
		}
	}

	if ( IsDefined( target.owner ) && target.owner == owner )
	{
		return false;
	}

	if ( IsDefined( target.script_owner ) && target.script_owner == owner )
	{
		return false;
	}
	
	if ( is_true( target.dead ) )
	{
		return false;
	}

	if ( IsDefined( target.targetname ) && target.targetname == "riotshield_mp" )
	{
		if ( IsDefined( target.damageTaken ) && target.damageTaken >= GetDvarInt( "riotshield_deployed_health" ) )
		{
			return false;
		}
	}

	return true;
}

startTankRemoteControl( drone ) // self == player
{
	self.killstreak_waitamount = AI_TANK_LIFETIME * 1000;

	drone MakeVehicleUsable();
	drone ClearVehGoalPos();
	drone ClearTurretTarget();
	drone LaserOff();

	drone usevehicle( self, 0 );

	drone MakeVehicleUnusable();
	
	self create_weapon_hud();
	drone update_weapon_hud( self );

	self thread tank_fire_watch( drone );
}

endTankRemoteControl( drone, isDead ) // self == player
{
	drone MakeVehicleUnusable();

	if ( !isDead )
	{
		drone thread tank_move_think();
		drone thread tank_riotshield_think();
		drone thread tank_aim_think();
		drone thread tank_combat_think();
	}
}

end_remote_control_ai_tank( drone ) // dead
{
	if (!isDefined(drone.dead) || !drone.dead)
	{			
		self thread maps\mp\gametypes\_hud::fadeToBlackForXSec( 0, 0.25, 0.1, 0.25 );
		wait( .3 );
	}
	else
	{
		wait( 0.75 );
		self thread maps\mp\gametypes\_hud::fadeToBlackForXSec( 0, 0.25, 0.1, 0.25 );
		wait( 0.3 );
	}
	drone MakeVehicleUsable();
	drone.controlled = false;
	drone notify("remote_stop");
	self unlink();
	drone MakeVehicleUnusable();
	self stop_remote();
	drone ShowPart( "tag_pov_hide" );
	//self.exitTankTrigger SetInvisibleToAll(); // tagTMR<TODO>: remove these tank triggers
	//self.useTankTrigger SetVisibleToPlayer( self );

	// tagTMR<TODO>: remove instances of hud_prompt_control
	if (IsDefined(self.hud_prompt_control) && (!isDefined(drone.dead) || !drone.dead))
	{
		self.hud_prompt_control SetText("HOLD [{+activate}] TO CONTROL A.G.R.");	
		self.hud_prompt_exit SetText("");
	}
	self switchToLastNonKillstreakWeapon();
	wait (.5);
	self takeweapon("killstreak_ai_tank_mp");
				
	if (!isDefined(drone.dead) || !drone.dead)
	{
		drone thread tank_move_think();
		drone thread tank_riotshield_think();
		drone thread tank_aim_think();
		drone thread tank_combat_think();	
	}
}

tank_fire_watch( drone )
{	
	self endon( "disconnect" );
	self endon( "stopped_using_remote");
	drone endon( "death" );
	level endon ( "game_ended" );	
	
	while( true )
	{
		drone waittill( "turret_fire" );

		if ( drone.isStunned )
		{
			continue;
		}

		drone FireWeapon();
		Earthquake( 0.2, 0.2, drone.origin, 200 );
		//recoil
		angles = drone GetTagAngles( "tag_barrel" );
		dir = AnglesToForward( angles );
		drone LaunchVehicle( dir * -15, drone.origin + (0,0,10), false );

		wait( level.ai_tank_turret_fire_rate );
	}
}

tank_rocket_watch()
{
	self endon( "death" );

	player = self.owner;
	
	while( true )
	{
		player waittill( "missile_fire" );
		self.numberRockets--;

		self SetClientField( "ai_tank_missile_fire", self.numberRockets );

		angles = self GetTagAngles( "tag_flash_gunner1" );
		dir = AnglesToForward( angles );

		if ( !self.controlled )
		{
			self LaunchVehicle( dir * -30, self.origin + (0,0,50), false );
		}
		else
		{
			self LaunchVehicle( dir * -30, self.origin + (0,0,50), false );
			player PlayRumbleOnEntity( "sniper_fire" );
		}
						
		Earthquake( 0.4, 0.5, self.origin, 200 );

		self update_weapon_hud( player );
		
		if ( self.numberRockets <= 0 )
		{
			self DisableGunnerFiring( 0, true );
			wait ( TANK_ROCKET_RELOAD_SECS );

			self SetClientField( "ai_tank_missile_fire", 4 );
			self.numberRockets = TANK_ROCKET_AMMO_MAX;
			
			wait (0.4);

			if ( !self.isStunned )
			{
				self DisableGunnerFiring( 0, false );
			}

			self update_weapon_hud( player );
		}
	}
}

create_weapon_hud()
{
	self.tank_rocket_1 = newclienthudelem( self );
	self.tank_rocket_1.alignX = "right";
	self.tank_rocket_1.alignY = "bottom";
	self.tank_rocket_1.horzAlign = "user_center";
	self.tank_rocket_1.vertAlign = "user_bottom";
	self.tank_rocket_1.foreground = true;
	self.tank_rocket_1.font = "small";
	self.tank_rocket_1 SetShader( "mech_check_fill", 32, 16 );
	self.tank_rocket_1.hidewheninmenu = false;
	self.tank_rocket_1.x = -250;
	self.tank_rocket_1.y = -75;
	self.tank_rocket_1.fontscale = 1.25;
	
	self.tank_rocket_2 = newclienthudelem( self );
	self.tank_rocket_2.alignX = "right";
	self.tank_rocket_2.alignY = "bottom";
	self.tank_rocket_2.horzAlign = "user_center";
	self.tank_rocket_2.vertAlign = "user_bottom";
	self.tank_rocket_2.foreground = true;
	self.tank_rocket_2.font = "small";
	self.tank_rocket_2 SetShader( "mech_check_fill", 32, 16 );
	self.tank_rocket_2.hidewheninmenu = false;
	self.tank_rocket_2.x = -250;
	self.tank_rocket_2.y = -65;
	self.tank_rocket_2.fontscale = 1.25;
	
	self.tank_rocket_3 = newclienthudelem( self );
	self.tank_rocket_3.alignX = "right";
	self.tank_rocket_3.alignY = "bottom";
	self.tank_rocket_3.horzAlign = "user_center";
	self.tank_rocket_3.vertAlign = "user_bottom";
	self.tank_rocket_3.foreground = true;
	self.tank_rocket_3.font = "small";
	self.tank_rocket_3 SetShader( "mech_check_fill", 32, 16 );
	self.tank_rocket_3.hidewheninmenu = false;
	self.tank_rocket_3.x = -250;
	self.tank_rocket_3.y = -55;
	self.tank_rocket_3.fontscale = 1.25;
	
	self.tank_rocket_hint = newclienthudelem( self );
	self.tank_rocket_hint.alignX = "right";
	self.tank_rocket_hint.alignY = "bottom";
	self.tank_rocket_hint.horzAlign = "user_center";
	self.tank_rocket_hint.vertAlign = "user_bottom";
	self.tank_rocket_hint.foreground = true;
	self.tank_rocket_hint.font = "small";
	self.tank_rocket_hint SetText(&"KILLSTREAK_AI_TANK_ROCKETS");
	self.tank_rocket_hint.hidewheninmenu = true;
	self.tank_rocket_hint.archived = false;
	self.tank_rocket_hint.x = -257;
	self.tank_rocket_hint.y = -40;
	self.tank_rocket_hint.fontscale = 1.25;
	
//	self.tank_mg_bar = newclienthudelem( self );
//	self.tank_mg_bar.alignX = "left";
//	self.tank_mg_bar.alignY = "bottom";
//	self.tank_mg_bar.horzAlign = "user_center";
//	self.tank_mg_bar.vertAlign = "user_bottom";
//	self.tank_mg_bar.foreground = true;
//	self.tank_mg_bar.font = "small";
//	self.tank_mg_bar SetShader( "mech_flame_bar", 10, 80 );
//	self.tank_mg_bar.hidewheninmenu = false;
//	self.tank_mg_bar.x = 250;
//	self.tank_mg_bar.y = -60;
//	self.tank_mg_bar.fontscale = 1.25;	
//	
//	self.tank_mg_arrow = newclienthudelem( self );
//	self.tank_mg_arrow.alignX = "left";
//	self.tank_mg_arrow.alignY = "bottom";
//	self.tank_mg_arrow.horzAlign = "user_center";
//	self.tank_mg_arrow.vertAlign = "user_bottom";
//	self.tank_mg_arrow.foreground = true;
//	self.tank_mg_arrow.font = "small";
//	self.tank_mg_arrow SetShader( "mech_flame_arrow_flipped", 20, 10 );
//	self.tank_mg_arrow.hidewheninmenu = false;
//	self.tank_mg_arrow.x = 258;
//	self.tank_mg_arrow.y = -57;
//	self.tank_mg_arrow.fontscale = 1.25;	
		
	self.tank_mg_hint = newclienthudelem( self );
	self.tank_mg_hint.alignX = "left";
	self.tank_mg_hint.alignY = "bottom";
	self.tank_mg_hint.horzAlign = "user_center";
	self.tank_mg_hint.vertAlign = "user_bottom";
	self.tank_mg_hint.foreground = true;
	self.tank_mg_hint.font = "small";
	self.tank_mg_hint SetText(&"KILLSTREAK_AI_TANK_GUNS");
	self.tank_mg_hint.hidewheninmenu = true;
	self.tank_mg_hint.archived = false;
	self.tank_mg_hint.x = 257;
	self.tank_mg_hint.y = -40;
	self.tank_mg_hint.fontscale = 1.25;
	
	self thread fade_out_weapon_hud();
}

fade_out_weapon_hud()
{
	wait( 8 );
	time = 0;
	while (time < 2)
	{
		if ( !isDefined(self.tank_rocket_hint))
		{
			return;	
		}
		self.tank_rocket_hint.alpha -= 0.025;
		self.tank_mg_hint.alpha -= 0.025;
		time += 0.05;
		wait (0.05);
	}
	
	self.tank_rocket_hint.alpha = 0;
	self.tank_mg_hint.alpha = 0;
}

update_weapon_hud( player )
{
	if ( IsDefined( player.tank_rocket_hint ) )
	{
		player.tank_rocket_3 SetShader( "mech_check_fill", 32, 16 );
		player.tank_rocket_2 SetShader( "mech_check_fill", 32, 16 );
		player.tank_rocket_1 SetShader( "mech_check_fill", 32, 16 );
		
		switch ( self.numberRockets )
		{
			case 0:
				player.tank_rocket_3 SetShader( "mech_check_line", 32, 16 );
			case 1:
				player.tank_rocket_2 SetShader( "mech_check_line", 32, 16 );
			case 2:
				player.tank_rocket_1 SetShader( "mech_check_line", 32, 16 );
			break;
		}
	}
}

//THIS IS OLD - USE THE ONE IN remote_weapons.gsc
destroy_remote_hud()
{	
	self UseServerVisionset( false );
	self SetInfraredVision( false );
	if ( isdefined(self.fullscreen_static) )
		self.fullscreen_static destroy();
	if ( isdefined(self.remote_hud_reticle) )
		self.remote_hud_reticle destroy();
	if ( isdefined(self.remote_hud_bracket_right) )
		self.remote_hud_bracket_right destroy();
	if ( isdefined(self.remote_hud_bracket_left) )
		self.remote_hud_bracket_left destroy();
	if ( isdefined(self.remote_hud_arrow_right) )
		self.remote_hud_arrow_right destroy();
	if ( isdefined(self.remote_hud_arrow_left) )
		self.remote_hud_arrow_left destroy();
	if ( isdefined(self.tank_rocket_1) )
		self.tank_rocket_1 destroy();	
	if ( isdefined(self.tank_rocket_2) )
		self.tank_rocket_2 destroy();
	if ( isdefined(self.tank_rocket_3) )
		self.tank_rocket_3 destroy();
	if ( isdefined(self.tank_rocket_hint) )
		self.tank_rocket_hint destroy();
	if ( isdefined(self.tank_mg_bar) )
		self.tank_mg_bar destroy();
	if ( isdefined(self.tank_mg_arrow) )
		self.tank_mg_arrow destroy();
	if ( isdefined(self.tank_mg_hint) )
		self.tank_mg_hint destroy();
}

/#
tank_devgui_think()
{
	SetDvar( "devgui_tank", "" );

	for ( ;; )
	{
		wait( 0.25 );

		level.ai_tank_turret_fire_rate = WeaponFireTime( "ai_tank_drone_gun_mp" );

		if ( GetDvar( "devgui_tank" ) == "routes" )
		{
			devgui_debug_route();
			SetDvar( "devgui_tank", "" );
		}
	}
}

tank_debug_patrol( node1, node2 )
{
	self endon( "death" );
	self endon( "debug_patrol" );

	for( ;; )
	{
		self SetVehGoalPos( node1.origin, true, 2 );
		self waittill( "reached_end_node" );

		wait( 1 );

		self SetVehGoalPos( node2.origin, true, 2 );
		self waittill( "reached_end_node" );

		wait( 1 );
	}
}

devgui_debug_route()
{
	iprintln( "Choose nodes with 'A' or press 'B' to cancel" );
	nodes = maps\mp\gametypes\_dev::dev_get_node_pair();

	if ( !IsDefined( nodes ) )
	{
		iprintln( "Route Debug Cancelled" );
		return;
	}

	iprintln( "Sending talons to chosen nodes" );

	tanks = GetEntArray( "talon", "targetname" );

	foreach( tank in tanks )
	{
		tank notify( "debug_patrol" );
		tank thread tank_debug_patrol( nodes[0], nodes[1] );
	}
}

tank_debug_hud_init()
{
	host = GetHostPlayer();

	while ( !IsDefined( host ) )
	{
		wait( 0.25 );
		host = GetHostPlayer();
	}

	x = 80;
	y = 40;

	level.ai_tank_bar = NewClientHudElem( host );
	level.ai_tank_bar.x = x + 80;
	level.ai_tank_bar.y = y + 2;
	level.ai_tank_bar.alignX = "left";
	level.ai_tank_bar.alignY = "top";
	level.ai_tank_bar.horzAlign = "fullscreen";
	level.ai_tank_bar.vertAlign = "fullscreen";
	level.ai_tank_bar.alpha = 0;
	level.ai_tank_bar.foreground = 0;
	level.ai_tank_bar setshader( "black", 1, 8 );

	level.ai_tank_text = NewClientHudElem( host );
	level.ai_tank_text.x = x + 80;
	level.ai_tank_text.y = y;
	level.ai_tank_text.alignX = "left";
	level.ai_tank_text.alignY = "top";
	level.ai_tank_text.horzAlign = "fullscreen";
	level.ai_tank_text.vertAlign = "fullscreen";
	level.ai_tank_text.alpha = 0;
	level.ai_tank_text.fontScale = 1;
	level.ai_tank_text.foreground = 1;
}

tank_debug_health()
{
	self.damage_debug = "";

	level.ai_tank_bar.alpha = 1;
	level.ai_tank_text.alpha = 1;
	
	for ( ;; )
	{
		wait ( 0.05 );

		if ( !IsDefined( self ) || !IsAlive( self ) )
		{
			level.ai_tank_bar.alpha = 0;
			level.ai_tank_text.alpha = 0;
			return;
		}

		width = self.health / self.maxhealth * 300;
		width = int( max( width, 1 ) );
		level.ai_tank_bar setShader( "black", width, 8 );

		str = ( self.health + "  Last Damage: " + self.damage_debug );
		level.ai_tank_text SetText( str );
	}
}

#/
