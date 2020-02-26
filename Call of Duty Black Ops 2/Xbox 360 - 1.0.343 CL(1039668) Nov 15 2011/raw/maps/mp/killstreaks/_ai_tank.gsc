#include maps\mp\_utility;
#include common_scripts\utility;
#include maps\mp\killstreaks\_killstreaks;
#include maps\mp\killstreaks\_supplydrop;

#define AI_TANK_LIFETIME			120
#define AI_TANK_HEALTH				700
#define AI_TANK_ROCKET_COOLDOWN		10
#define AI_TANK_PATH_TIMEOUT		45
#define AI_TANK_MIN_REACTION_TIME	0.8
#define AI_TANK_MAX_REACTION_TIME	1.2

init()
{
	PrecacheVehicle( "ai_tank_drone_mp" );
	PrecacheModel( "veh_iw_drone_ugv_talon" );
	PrecacheItem( "ai_tank_drone_rocket_mp" );

	loadfx( "vehicle/treadfx/fx_treadfx_talon_dirt" );
	loadfx( "vehicle/treadfx/fx_treadfx_talon_concrete" );

	registerKillstreak( "ai_tank_drop_mp", "ai_tank_drop_mp", "killstreak_ai_tank_drop", "ai_tank_drop_used", ::useKillstreakAITankDrop );
	registerKillstreakAltWeapon( "ai_tank_drop_mp", "ai_tank_drone_gun_mp" );
	registerKillstreakAltWeapon( "ai_tank_drop_mp", "ai_tank_drone_rocket_mp" );
	registerKillstreakStrings( "ai_tank_drop_mp", &"KILLSTREAK_EARNED_AI_TANK_DROP", &"KILLSTREAK_AI_TANK_NOT_AVAILABLE" );
	registerKillstreakDialog( "ai_tank_drop_mp", "mpl_killstreak_ai_tank", "kls_aitank_used", "","kls_aitank_enemy", "", "kls_aitank_ready" );
	registerKillstreakDevDvar( "ai_tank_drop_mp", "scr_giveaitankdrop" );

	level.ai_tank_fov				= Cos( 160 );
	level.ai_tank_turret_fire_rate	= WeaponFireTime( "ai_tank_drone_gun_mp" );

	level.ai_tank_valid_locations	= maps\mp\gametypes\_spawnlogic::getSpawnpointArray( "mp_tdm_spawn" );

/#
	//level thread tank_devgui_think();
#/

}

useKillstreakAITankDrop(hardpointType)
{	
	team = self.team;
	
	if( !self maps\mp\killstreaks\_supplydrop::isSupplyDropGrenadeAllowed( hardpointType ) )
	{
		return false;
	}

	if ( !self maps\mp\killstreaks\_killstreakrules::killstreakStart( "ai_tank_drop_mp", team, false, true ) )
	{
		return false;
	}

	self thread maps\mp\killstreaks\_supplydrop::refCountDecChopperOnDisconnect();
	
	result = self maps\mp\killstreaks\_supplydrop::useSupplyDropMarker();
	
	self notify( "supply_drop_marker_done" );

	if ( !IsDefined(result) || !result )
	{
		maps\mp\killstreaks\_killstreakrules::killstreakStop( "ai_tank_drop_mp", team );
		return false;
	}

	return result;
}

crateLand( crate, weaponname, owner, team )
{
	if ( !crate valid_location() || team != owner.team )
	{
		maps\mp\killstreaks\_killstreakrules::killstreakStop( "ai_tank_drop_mp", team );
		wait( 10 );
		crate delete();
		return;
	}

	PlayFX( level._supply_drop_explosion_fx, crate.origin );
	PlaySoundAtPosition( "veh_talon_crate_exp", crate.origin );
	origin = crate.origin;

	level thread ai_tank_killstreak_start( owner, origin );

	crate delete();
}

valid_location()
{
	origin = self.origin + ( 0, 0, 32 );

	level.ai_tank_valid_locations = array_randomize( level.ai_tank_valid_locations );
	
	count = Min( level.ai_tank_valid_locations.size, 5 );

	for ( i = 0; i < count; i++ )
	{
		if ( FindPath( origin, level.ai_tank_valid_locations[ i ].origin, false ) )
		{
			return true;
		}
	}

	return false;
}

ai_tank_killstreak_start( owner, origin )
{
	waittillframeend;
	drone = SpawnVehicle( "veh_iw_drone_ugv_talon", "talon", "ai_tank_drone_mp", origin, (0, 0, 0) );
	drone playloopsound ("veh_talon_idle_npc", .2);
	drone SetVehicleAvoidance( true );

	drone SetOwner( owner );
	drone.owner = owner;
	drone.team = owner.team;

	if ( level.teamBased )
	{
		drone SetTeam( owner.team );
	}
	else
	{
		drone SetTeam( "free" );
	}


	drone.maxhealth = AI_TANK_HEALTH;
	drone.health = drone.maxhealth;

	drone.rocket_armed = true;

	drone.killCamEnt = Spawn( "script_model", drone.origin + ( AnglesToForward( drone.angles ) * -120 ) + ( 0, 0, 50 ) );	drone.killCamEnt.angles = drone.angles;
	drone.killCamEnt LinkTo( drone, "tag_turret" );

	drone maps\mp\_entityheadicons::setEntityHeadIcon( drone.team, drone, ( 0, 0, 60 ) );

	drone thread tank_move_think();
	drone thread tank_aim_think();
	drone thread tank_aim_search();
	drone thread tank_scan_think();
	drone thread tank_combat_think();
	drone thread tank_death_think();
	drone thread tank_damage_think();
	drone thread tank_abort_think();
	drone thread tank_ground_abort_think();

/#
	//drone thread tank_debug_health();
#/
}

tank_abort_think()
{
	self endon( "death" );
	
	self.owner wait_endon( AI_TANK_LIFETIME, "disconnect", "joined_team", "joined_specators", "emp_jammed" );

	self notify( "death" );
}

tank_damage_think()
{
	self endon( "death" );

	low_health = false;

	for ( ;; )
	{
		self waittill( "damage", damage, attacker, dir, point, mod, model, tag, part, weapon, flags );

/#
		self.damage_debug = ( damage + " (" + weapon + ")" );
#/

		if ( weapon == "emp_grenade_mp" )
		{
			self notify( "death", attacker );
			return;
		}

		if ( !low_health && self.health > 0 && self.health <= self.maxhealth / 2 )
		{
			PlayFXOnTag( level._equipment_spark_fx, self, "tag_turret" );
			self PlaySound ( "veh_talon_shutdown" );
			self stoploopsound (.2);
			low_health = true;
		}

		if ( IsDefined( attacker ) && IsPlayer( attacker ) && self tank_is_idle() )
		{
			self.aim_entity.origin = attacker GetEye();
			self.aim_entity.delay = 8;
			self notify( "aim_updated" );
		}
	}
}

tank_death_think()
{
	team = self.team;
	self waittill( "death", attacker );

	self ClearVehGoalPos();
	PlaySoundAtPosition( "veh_talon_shutdown", self.origin );
	PlayFXOnTag( level._equipment_spark_fx, self, "tag_turret" );
	wait (1.6);
	PlayFX( level._effect[ "rcbombexplosion" ], self.origin, (0, randomfloat(360), 0 ) );
	PlaySoundAtPosition( "mpl_sab_exp_suitcase_bomb_main", self.origin );
	wait( 0.05 );

	if ( IsDefined( attacker ) && IsPlayer( attacker ) && attacker != self.owner )
	{
		if ( level.teamBased && attacker.team == self.team )
		{
		}
		else
		{
			attacker maps\mp\_medals::destroyerAiTank();
		}
	}


	self.killCamEnt delete();
	self.aim_entity delete();
	self delete();

	maps\mp\killstreaks\_killstreakrules::killstreakStop( "ai_tank_drop_mp", team );
}

tank_move_think()
{
	self endon( "death" );

	for ( ;; )
	{
		
		wait( RandomFloatRange( 1, 4 ) );

		if ( !tank_is_idle() )
		{
			enemy = tank_get_target();

			if ( valid_target( enemy, self.team, self.owner ) )
			{
				origin = enemy.origin;
				/*
				nodes = GetNodesInRadius( origin, 512, 256, 128, "Path" );

				if ( nodes.size > 0 )
				{
				origin = random( nodes ).origin;
				}
				*/
				if ( self SetVehGoalPos( origin, true, 2 ) )
				{
					self wait_endon( 3, "reached_end_node" );
					continue;
				}
			}
		}

		nodes = GetNodesInRadius( self.owner.origin, 1024, 64, 128, "Path" );

		if ( nodes.size > 0 )
		{
			node = random( nodes );
		}
		else
		{
			node = random( level.ai_tank_valid_locations );
		}

		if ( self SetVehGoalPos( node.origin, true, 2 ) )
		{
			self wait_endon( AI_TANK_PATH_TIMEOUT, "reached_end_node" );
		}

		if ( self.aim_entity.delay > 0 )
		{
			self wait_endon( self.aim_entity.delay, "reached_end_node" );
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
		down = self.origin + ( down * -16 );

		//Line( self.origin, down, (1,0,0), 1, false, 1000 );

		if ( BulletTracePassed( self.origin, down, false, self ) )
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

	self.aim_entity = Spawn( "script_model", (0, 0, 0) );
	self.aim_entity.delay = 0;

	self tank_idle();

	for ( ;; )
	{
		self wait_endon( RandomFloatRange( 1, 3 ), "aim_updated" );

		yaw	= ( self.angles[0], self.angles[1] + RandomIntRange( -90, 90 ), self.angles[2] );
		forward = AnglesToForward( yaw );

		origin = self.origin + forward * 1024;
		self.aim_entity.origin = ( origin[0], origin[1], origin[2] + 20 );

		if ( self.aim_entity.delay > 0 )
		{
			wait( self.aim_entity.delay );
			self.aim_entity.delay = 0;
		}
	}
}

tank_aim_search()
{
	self endon( "death" );

	for ( ;; )
	{
		wait( 0.1 );

		if ( !tank_is_idle() )
		{
			wait( 0.5 );
			continue;
		}

		players = GET_PLAYERS();
		players = get_array_of_closest( self.origin, players, undefined, undefined, 2048 );

		foreach( player in players )
		{
			if ( !valid_target( player, self.team, self.owner ) )
			{
				continue;
			}

			if ( !player IsFiring() )
			{
				continue;
			}

			self.aim_entity.origin = player GetEye();
			self.aim_entity.delay = 10;
			self notify( "aim_updated" );

			self SetVehGoalPos( player.origin, true, 2 );
			wait( 10 );
			break;
		}
	}
}

tank_scan_think()
{
	self endon( "death" );

	for ( ;; )
	{
		self waittill( "turret_rotate_moving" );
		self PlayLoopSound( "mpl_turret_servo" );

		self waittill( "turret_rotate_stopped" );
		self StopLoopSound( 0.1 );
		self PlaySound( "mpl_turret_servo_stop" );
	}
}

tank_combat_think()
{
	self endon( "death" );

	for ( ;; )
	{
		wait( 0.25 );

		origin = self GetTagOrigin( "tag_flash" );
		angles = self GetTagAngles( "tag_flash" );

		forward = AnglesToForward( angles );
		forward = VectorNormalize( forward );

		players = GET_PLAYERS();
		players = get_array_of_closest( self.origin, players );
		self tank_target_evaluate( players, origin, forward );

		dogs = maps\mp\killstreaks\_dogs::dog_manager_get_dogs();
		self tank_target_evaluate( dogs, origin, forward );

		tanks = GetEntArray( "talon", "targetname" );
		self tank_target_evaluate( tanks, origin, forward );
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

		if ( IsPlayer( target ) )
		{
			if ( !BulletTracePassed( origin, target GetEye(), false, target ) )
			{
				continue;
			}
		}
		else if ( !BulletTracePassed( origin, target.origin + ( 0, 0, 10 ), false, target ) )
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
	self tank_set_target( enemy );
	self notify( "reached_end_node" ); // wake up the movement thread

	do_fire_delay = true;

	for ( ;; )
	{
		if ( !valid_target( enemy, self.team, self.owner ) )
		{
			return;
		}

		event = self waittill_any_return( "turret_on_vistarget", "turret_no_vis" );
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

		if ( do_fire_delay )
		{
			self PlaySound( "mpl_turret_alert" ); 
			wait( RandomFloatRange( AI_TANK_MIN_REACTION_TIME, AI_TANK_MAX_REACTION_TIME ) );
			do_fire_delay = false;
		}

		if ( self tank_should_fire_rocket( enemy ) )
		{
			origin = self GetTagOrigin( "tag_missile1" );
			rocket = MagicBullet( "ai_tank_drone_rocket_mp", origin, enemy.origin, self );
			rocket.killcament = self.killCamEnt;
			self thread tank_rocket_wait( AI_TANK_ROCKET_COOLDOWN );

			rocket wait_endon( RandomFloatRange( 0.5, 3 ), "death" );
			continue;
		}

		self FireWeapon();
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

tank_rocket_wait( wait_time )
{
	self endon( "death" );

	self.rocket_armed = false;
	wait( wait_time );
	self.rocket_armed = true;
}

tank_should_fire_rocket( enemy )
{
	if ( !self.rocket_armed )
	{
		return false;
	}

	if ( DistanceSquared( self.origin, enemy.origin ) < 256 * 256 )
	{
		self thread tank_rocket_wait( 1 );
		return false;
	}

	return true;
}

tank_set_target( entity )
{
	self.target_entity = entity;

	if ( IsPlayer( entity ) )
	{
		self SetTurretTargetEnt( entity, ( 0, 0, 30 ) );
	}
	else
	{
		self SetTurretTargetEnt( entity, ( 0, 0, 10 ) );
	}
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

	return true;
}

/#
tank_devgui_think()
{
	//level tank_debug_hud_init();

	for ( ;; )
	{
		wait( 0.25 );

		level.ai_tank_turret_fire_rate = WeaponFireTime( "ai_tank_drone_gun_mp" );
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