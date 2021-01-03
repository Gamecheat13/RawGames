#using scripts\codescripts\struct;

#using scripts\shared\array_shared;
#using scripts\shared\challenges_shared;
#using scripts\shared\clientfield_shared;
#using scripts\shared\entityheadicons_shared;
#using scripts\shared\hud_shared;
#using scripts\shared\killstreaks_shared;
#using scripts\shared\scoreevents_shared;
#using scripts\shared\util_shared;

    	   	                                                                                                                                         	                                	                                                                                                                                                                                                                                                                                                                                                                    	        	     	             	    	   	               	                                              	                                                           	                               	                     	                                                                                                           	                                                                 	                                                              	                                                                                                              	                            	                                     	                                       	                                                                                                              	   	                  	       	                                                    	                   	                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                        	                                  	                                                                                        	           	                        	                                            	                                             	                                                   	                                                             	                                                         	                                                                    	                                                                                                                                                                                                    	                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                         	                                                              	                                                          	                                   	                                   	                                                    	                                       	                                           	     	                                                                                                                                                                                                                                                      	                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                     
                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                            	                           	                           	                                                                                                                                                                                                                                                            	                                                                                                                                                                                                                                                                                                                                                                                       

#using scripts\cp\gametypes\_dev;
#using scripts\cp\gametypes\_spawning;
#using scripts\cp\gametypes\_spawnlogic;
#using scripts\cp\gametypes\_weapons;

#using scripts\cp\_challenges;
#using scripts\cp\_scoreevents;
#using scripts\cp\_util;
#using scripts\cp\killstreaks\_dogs;
#using scripts\cp\killstreaks\_emp;
#using scripts\cp\killstreaks\_killstreakrules;
#using scripts\cp\killstreaks\_killstreaks;
#using scripts\cp\killstreaks\_remote_weapons;
#using scripts\cp\killstreaks\_supplydrop;
















#using_animtree ( "mp_vehicles" );

#precache( "material", "mech_check_line" );
#precache( "material", "mech_check_fill" );
#precache( "string", "KILLSTREAK_EARNED_AI_TANK_DROP" );
#precache( "string", "KILLSTREAK_AI_TANK_NOT_AVAILABLE" );
#precache( "string", "KILLSTREAK_AI_TANK_INBOUND" );
#precache( "eventstring", "mpl_killstreak_ai_tank" );
#precache( "fx", "_t6/vehicle/treadfx/fx_treadfx_talon_dirt" );
#precache( "fx", "_t6/vehicle/treadfx/fx_treadfx_talon_concrete" );
#precache( "fx", "_t6/light/fx_vlight_talon_eye_grn" );
#precache( "fx", "_t6/light/fx_vlight_talon_eye_red" );
#precache( "fx", "_t6/weapon/talon/fx_talon_emp_stun" );
#precache( "fx", "_t6/weapon/talon/fx_muz_talon_rocket_flash_1p" );
#precache( "fx", "_t6/weapon/talon/fx_talon_damage_state" );
#precache( "fx", "_t6/weapon/talon/fx_talon_exp" );
#precache( "fx", "_t6/weapon/talon/fx_talon_drop_box" );

#namespace ai_tank;

function init()
{	
	level.ai_tank_minigun_flash_3p = "_t6/weapon/talon/fx_muz_talon_rocket_flash_1p";

	killstreaks::register( "inventory_ai_tank_drop", "inventory_ai_tank_drop", "killstreak_ai_tank_drop", "ai_tank_drop_used",&useKillstreakAITankDrop );
	killstreaks::register_alt_weapon( "inventory_ai_tank_drop", "ai_tank_drone_gun" );
	killstreaks::register_alt_weapon( "inventory_ai_tank_drop", "ai_tank_drone_rocket" );
	killstreaks::register_remote_override_weapon( "inventory_ai_tank_drop", "killstreak_ai_tank" );
	killstreaks::register_strings( "inventory_ai_tank_drop", &"KILLSTREAK_EARNED_AI_TANK_DROP", &"KILLSTREAK_AI_TANK_NOT_AVAILABLE", &"KILLSTREAK_AI_TANK_INBOUND" );
	killstreaks::register_dialog( "inventory_ai_tank_drop", "mpl_killstreak_ai_tank", "kls_aitank_used", "","kls_aitank_enemy", "", "kls_aitank_ready" );
	killstreaks::register_dev_dvar( "inventory_ai_tank_drop", "scr_giveaitankdrop" );

	killstreaks::register( "ai_tank_drop", "ai_tank_drop", "killstreak_ai_tank_drop", "ai_tank_drop_used",&useKillstreakAITankDrop );
	killstreaks::register_alt_weapon( "ai_tank_drop","ai_tank_drone_gun" );
	killstreaks::register_alt_weapon( "ai_tank_drop", "ai_tank_drone_rocket" );
	killstreaks::register_remote_override_weapon( "ai_tank_drop", "killstreak_ai_tank" );
	killstreaks::register_strings( "ai_tank_drop", &"KILLSTREAK_EARNED_AI_TANK_DROP", &"KILLSTREAK_AI_TANK_NOT_AVAILABLE", &"KILLSTREAK_AI_TANK_INBOUND" );
	killstreaks::register_dialog( "ai_tank_drop", "mpl_killstreak_ai_tank", "kls_aitank_used", "","kls_aitank_enemy", "", "kls_aitank_ready" );

	level.ai_tank_fov				= Cos( 160 );
	level.ai_tank_turret_weapon		= GetWeapon( "ai_tank_drone_gun" );
	level.ai_tank_turret_fire_rate	= level.ai_tank_turret_weapon.fireTime;
	level.ai_tank_remote_weapon		= GetWeapon( "killstreak_ai_tank" );

	level.ai_tank_valid_locations = [];
	spawns = spawnlogic::get_spawnpoint_array( "mp_tdm_spawn" );
	
	level.ai_tank_damage_fx = "_t6/weapon/talon/fx_talon_damage_state";
	level.ai_tank_explode_fx = "_t6/weapon/talon/fx_talon_exp";
	level.ai_tank_crate_explode_fx = "_t6/weapon/talon/fx_talon_drop_box";

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
	thread register();
}

function register()
{
	clientfield::register( "vehicle", "ai_tank_death", 1, 1, "int" );
	clientfield::register( "vehicle", "ai_tank_hack_spawned", 1, 1, "int" );
	clientfield::register( "vehicle", "ai_tank_hack_rebooting", 1, 1, "int" );
	clientfield::register( "vehicle", "ai_tank_missile_fire", 1, 3, "int" );
	
	clientfield::register( "vehicle", "ai_tank_stun", 1, 1, "int" );	
}

function useKillstreakAITankDrop(hardpointType)
{	
	team = self.team;
	
	if( !self supplydrop::isSupplyDropGrenadeAllowed( hardpointType ) )
	{
		return false;
	}

	killstreak_id = self killstreakrules::killstreakStart( hardpointType, team, false, false );
	if ( killstreak_id == -1 )
	{
		return false;
	}

	result = self supplydrop::useSupplyDropMarker( killstreak_id );
	
	// the marker is out but the chopper is yet to come
	self notify( "supply_drop_marker_done" );

	if ( !isdefined(result) || !result )
	{
		//if( !self.supplyGrenadeDeathDrop )
			killstreakrules::killstreakStop( hardpointType, team, killstreak_id );
		return false;
	}

	return result;
}

function crateLand( crate, category, owner, team )
{
	if ( !crate valid_location() || !isdefined( owner ) || team != owner.team || owner emp::isEnemyEMPKillstreakActive() )
	{
		killstreakrules::killstreakStop( category, team, crate.package_contents_id );
		wait( 10 );
		crate delete();
		return;
	}

	origin = crate.origin;

	crateBottom = BulletTrace( origin, origin + (0, 0, -50), false, crate );
	if ( isdefined( crateBottom ) )
	{
		origin = crateBottom["position"] + (0,0,1);
	}
	
	PlayFX( level.ai_tank_crate_explode_fx, origin, (1, 0, 0), (0, 0, 1) );
	PlaySoundAtPosition( "veh_talon_crate_exp", crate.origin );

	level thread ai_tank_killstreak_start( owner, origin, crate.package_contents_id, category );

	crate delete();
}

function valid_location()
{
	// check for a valid start node
	node = GetNearestNode( self.origin );

	if ( !isdefined( node ) )
	{
		return false;
	}

	start = self GetCentroid();
	end = node.origin + ( 0, 0, 8 );

	trace = PhysicsTrace( start, end, ( 0, 0, 0 ), ( 0, 0, 0 ), self, (1 << 4) );

	if ( trace["fraction"] < 1 )
	{
		return false;
	}
		
	// check for a path 
	origin = self.origin + ( 0, 0, 32 );

	level.ai_tank_valid_locations = array::randomize( level.ai_tank_valid_locations );
	
	count = Min( level.ai_tank_valid_locations.size, 5 );

	for ( i = 0; i < count; i++ )
	{
		if ( self FindPath( origin, level.ai_tank_valid_locations[ i ], false, true ) )
		{
			return true;
		}
	}

	return false;
}

function ai_tank_killstreak_start( owner, origin, killstreak_id, category )
{
	waittillframeend;
	drone = SpawnVehicle( "ai_tank_drone_mp", origin, (0, 0, 0), "talon" );
	drone SetEnemyModel( "veh_t6_drone_tank_alt" );
	drone playloopsound ("veh_talon_idle_npc", .2);
	drone SetVehicleAvoidance( true );
	drone clientfield::set( "ai_tank_missile_fire", 4 );

	drone SetOwner( owner );
	drone.owner = owner;
	drone.team = owner.team;
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

	drone entityheadicons::setEntityHeadIcon( drone.team, drone, ( 0, 0, 52 ) );

	// create the influencers
	drone spawning::create_entity_enemy_influencer( "small_vehicle" );
	
	drone.controlled = false;
	drone MakeVehicleUnusable();
	
	drone.numberRockets = 3;
	drone.warningShots = 3;
	drone SetDrawInfrared( true );
	
	//set up number for this drone
	if (!isdefined(drone.owner.numTankDrones))
		drone.owner.numTankDrones=1;
	else
		drone.owner.numTankDrones++;
	drone.ownerNumber = drone.owner.numTankDrones;
	
	// make the drone targetable
	Target_Set( drone, (0,0,20) );
	Target_SetTurretAquire( drone, false );
	
	drone thread tank_move_think();
	drone thread tank_aim_think();
	drone thread tank_combat_think();
	drone thread tank_death_think( category );
	drone thread tank_damage_think();
	drone thread tank_abort_think();
	drone thread tank_team_kill();
	drone thread tank_ground_abort_think();
	drone thread tank_riotshield_think();
	drone thread tank_rocket_think();
	
	owner remote_weapons::initRemoteWeapon( drone, "killstreak_ai_tank" );

	drone thread deleteOnKillbrush( drone.owner );
	level thread tank_game_end_think(drone);
	
/#
	//drone thread tank_debug_health();
#/
}

function tank_team_kill()
{
	self endon( "death" );
	self.owner waittill( "teamKillKicked" );
	self notify ( "death" );
}

function tank_abort_think()
{
	self endon( "death" );
	
	self.owner util::wait_endon( 120, "disconnect", "joined_team", "joined_spectators", "emp_jammed" );
	shouldTimeout = GetDvarString("scr_ai_tank_no_timeout");	
	if (shouldTimeout == "1")
	{
		return;
	}		
	self notify( "death" );
}

function tank_game_end_think(drone)
{
	drone endon( "death" );
	
	level waittill("game_ended");

	drone notify( "death" );
}


function stop_remote() // dead
{
	if ( !isdefined( self ) )
		return;

	self killstreaks::clear_using_remote();
	self.killstreak_waitamount = undefined;
	self destroy_remote_hud();	
	self util::clientNotify( "nofutz" );
}

function tank_damage_think()
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
		self.damage_debug = ( damage + " (" + weapon.name + ")" );
#/

		if ( weapon.isEmp && (mod == "MOD_GRENADE_SPLASH"))
		{
			damage_taken += ( 800 / 2 );
			damage = 0;
			if ( !self.isStunned )
			{
				challenges::stunnedTankWithEMPGrenade( attacker );
				self thread tank_stun( 4 );
				self.isStunned = true;
			}
		}
		
		if ( !self.isStunned )
		{
			if ( weapon.doStun && (mod == "MOD_GRENADE_SPLASH" || mod == "MOD_GAS") )
			{
					self thread tank_stun( 1.5 );
					self.isStunned = true;
			}
		}
		
		if ( mod == "MOD_RIFLE_BULLET" || mod == "MOD_PISTOL_BULLET" || weapon.name == "hatchet" || (mod == "MOD_PROJECTILE_SPLASH" && weapon.bulletImpactExplode) )
		{
			if ( isPlayer( attacker ) )
			    if ( attacker HasPerk( "specialty_armorpiercing" ) )
					damage += int( damage * level.cac_armorpiercing_data );
			
			if ( weapon.weapClass == "spread")
				damage = damage * 4.5;
			
			damage *= 0.3;
		}
		
		if ( ( mod == "MOD_PROJECTILE" || mod == "MOD_GRENADE_SPLASH" || mod == "MOD_PROJECTILE_SPLASH" ) && damage != 0 && !weapon.isEmp && !weapon.bulletImpactExplode)
		{
			damage *= 1.5;
		}
		
		if ( self.controlled )
		{
			self.owner SendKillstreakDamageEvent( int(damage) );
		}

		damage_taken += damage;

		if ( damage_taken >= 800 )
		{
			self notify( "death", attacker, mod, weapon );
			return;
		}

		if ( !low_health && damage_taken > 800 / 1.8 )
		{
			self thread tank_low_health_fx();
			low_health = true;
		}

		if ( isdefined( attacker ) && IsPlayer( attacker ) && self tank_is_idle() && !self.isStunned )
		{
			self.aim_entity.origin = attacker GetCentroid();
			self.aim_entity.delay = 8;
			self notify( "aim_updated" );
		}
	}
}

function tank_low_health_fx()
{
	self endon( "death" );
	
	self.damage_fx = spawn( "script_model", self GetTagOrigin("tag_origin") + (0,0,-14) );
	self.damage_fx SetModel( "tag_origin" );
	self.damage_fx LinkTo(self, "tag_turret", (0,0,-14), (0,0,0) );
	wait ( 0.1 );
	PlayFXOnTag( level.ai_tank_damage_fx, self.damage_fx, "tag_origin" );	
}

function deleteOnKillbrush(player)
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

function tank_stun( duration )
{	
	self endon( "death" );
	self notify( "stunned" );
	
	self ClearVehGoalPos();
	forward = AnglesToForward( self.angles );
	forward = self.origin + forward * 128;
	forward = forward - ( 0, 0, 64 );
	self SetTurretTargetVec( forward );
	self DisableGunnerFiring( 0, true );
	self LaserOff();
	
	if (self.controlled)
	{
		self.owner FreezeControls( true );
		
		//this is for HUD screen scramble
		self.owner SendKillstreakDamageEvent( 400 );
	}
	if (isdefined(self.owner.fullscreen_static))
	{
		self.owner thread remote_weapons::stunStaticFX( duration );
	}
	self clientfield::set( "ai_tank_stun", 1 );
	wait ( duration );
	self clientfield::set( "ai_tank_stun", 0 );
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

function emp_crazy_death()
{
	self clientfield::set( "ai_tank_stun", 1 );
	
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
				rocket = self FireWeapon(1);

				if ( isdefined( rocket ) )
				{
					rocket.from_ai = true;
				}
			}
		}
		time += 0.05;
		{wait(.05);};
	}
	self clientfield::set( "ai_tank_death", 1 );

	PlayFX( level.ai_tank_explode_fx, self.origin, (0, 0, 1) );
	PlaySoundAtPosition( "wpn_agr_explode", self.origin );
	{wait(.05);};
	self hide();
}

function tank_death_think( hardpointName )
{	
	team = self.team;
	self waittill( "death", attacker, type, weapon );
	self.dead = true;
	self LaserOff();

	self ClearVehGoalPos();
		
	if ( self.controlled == true && isdefined( self.owner ) )
	{
		self.owner SendKillstreakDamageEvent( 600 );
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
		self clientfield::set( "ai_tank_death", 1 );
		stunned = false;
		PlayFX( level.ai_tank_explode_fx, self.origin, (0, 0, 1) );
		PlaySoundAtPosition( "wpn_agr_explode", self.origin );
		{wait(.05);};
		self hide();

		if (isdefined(self.damage_fx))
		{
			self.damage_fx delete();
		}
	}
	
	if ( isdefined( attacker ) && IsPlayer( attacker ) && isdefined( self.owner ) && attacker != self.owner )
	{
		if ( self.owner util::IsEnemyPlayer( attacker ) )
		{
			scoreevents::processScoreEvent( "destroyed_aitank", attacker, self.owner, weapon );
			attacker AddWeaponStat( weapon, "destroyed_aitank", 1 );
			if ( isdefined( self.wasControlledNowDead ) && self.wasControlledNowDead )
			{
				attacker AddWeaponStat( weapon, "destroyed_controlled_killstreak", 1 );
			}
		}
		else
		{
			//Destroyed Friendly Killstreak 
		}
	}

	wait( 2 );
	killstreakrules::killstreakStop( hardpointName, team, self.killstreak_id );

	self.aim_entity delete();
	self delete();
}

function tank_move_think()
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
				else if ( self FindPath( self.origin, enemy.origin, false ) )
				{
					self SetVehGoalPos( enemy.origin, true, 2 );
					self util::wait_endon( 3, "reached_end_node" );
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

		if ( isdefined( avg_position ) )
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
			event = self util::waittill_any_timeout( 45, "reached_end_node", "force_movement_wake" );

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
function tank_riotshield_think()
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

function tank_ground_abort_think()
{
	self endon( "death" );

	ground_trace_fail = 0;

	for ( ;; )
	{
		wait( 1 );

		nodes = GetNodesInRadius( self.origin, 256, 0, 128, "Path" );

		if ( nodes.size <= 0 )
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

function tank_aim_think()
{
	self endon( "death" );
	self endon( "stunned" );
	self endon( "remote_start" );

	if ( !isdefined( self.aim_entity ) )
	{
		self.aim_entity = spawn( "script_model", (0, 0, 0) );
	}
			
	self.aim_entity.delay = 0;

	self tank_idle();

	for ( ;; )
	{
		self util::wait_endon( RandomFloatRange( 1, 3 ), "aim_updated" );

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

				if ( isdefined( node ) )
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

function tank_combat_think()
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
			dogs = dogs::dog_manager_get_dogs();
			self tank_target_evaluate( dogs, origin, forward );

			tanks = GetEntArray( "talon", "targetname" );
			self tank_target_evaluate( tanks, origin, forward );
			
			rcbombs = GetEntArray( "rcbomb", "targetname" );
			self tank_target_evaluate( rcbombs, origin, forward );
			
			turrets = GetEntArray( "auto_turret", "classname" );
			self tank_target_evaluate( turrets, origin, forward );
			
			shields = GetEntArray( "riotshield_mp", "targetname" );
			self tank_target_evaluate( shields, origin, forward );
		}
	}
}

function tank_target_evaluate( targets, origin, forward )
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

function tank_engage( enemy )
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

		event = self util::waittill_any_return( "turret_on_vistarget", "turret_no_vis" );

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
			self PlaySound( "wpn_metalstorm_lock_on" ); 
			wait( RandomFloatRange( 0.4, 0.8 ) );
			do_fire_delay = false;

			if ( !valid_target( enemy, self.team, self.owner ) )
			{
				return;
			}
		}

		if ( fire_rocket )
		{
			rocket = self FireWeapon( 1, undefined, undefined, self.owner );
			self notify( "missile_fire" );

			if ( isdefined( rocket ) )
			{
				rocket.from_ai = true;
				rocket.killcament = self;
				rocket util::wait_endon( RandomFloatRange( 0.5, 1 ), "death" );
				continue;
			}
		}

		self FireWeapon(0, enemy);
		warning_shots--;
		wait( level.ai_tank_turret_fire_rate );

		if ( isdefined( enemy ) && !IsAlive( enemy ) )
		{
			bullets = RandomIntRange( 8, 15 );
			for ( i = 0; i < bullets; i++ )
			{
				self FireWeapon(0, enemy);
				wait( level.ai_tank_turret_fire_rate );
			}
		}
	}
}

function tank_target_lost()
{
	self endon( "turret_on_vistarget" );

	wait( 5 );
	self tank_idle();
}

function tank_should_fire_rocket( enemy )
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

	if ( !BulletTracePassed( origin, enemy.origin + ( 0, 0, 10 ), false, enemy ) )
	{
		return false;
	}

	return true;
}

function tank_rocket_think()
{
	self endon( "death" );
	self endon( "remote_start" );

	if ( self.numberRockets <= 0 )
	{
		self DisableGunnerFiring( 0, true );
		wait ( 2 );

		self clientfield::set( "ai_tank_missile_fire", 4 );
		self.numberRockets = 3;

		wait (0.4);

		if ( !self.isStunned )
		{
			self DisableGunnerFiring( 0, false );
		}
	}
	
	while( true )
	{
		self waittill( "missile_fire" );
		self.numberRockets--;

		self clientfield::set( "ai_tank_missile_fire", self.numberRockets );

		angles = self GetTagAngles( "tag_flash_gunner1" );
		dir = AnglesToForward( angles );

		self LaunchVehicle( dir * -30, self.origin + (0,0,50), false );
		Earthquake( 0.4, 0.5, self.origin, 200 );

		if ( self.numberRockets <= 0 )
		{
			self DisableGunnerFiring( 0, true );
			wait ( 2 );

			self clientfield::set( "ai_tank_missile_fire", 4 );
			self.numberRockets = 3;

			wait (0.4);

			if ( !self.isStunned )
			{
				self DisableGunnerFiring( 0, false );
			}
		}
	}
}

function tank_set_target( entity, use_rocket )
{
	if ( !isdefined( use_rocket ) ) 
	{
		use_rocket = false;
	}

	self.target_entity = entity;

	if ( use_rocket )
	{
		angles = self GetTagAngles( "tag_barrel" );
		right = AnglesToRight( angles );
		offset = VectorScale( right, 8 );
		
		velocity = entity GetVelocity();
		speed = Length( velocity );

		forward = AnglesToForward( entity.angles );
		origin = offset + VectorScale( forward, speed );

		self SetTurretTargetEnt( entity, origin );
	}
	else
	{
		self SetTurretTargetEnt( entity );
	}
}

function tank_get_target()
{
	return ( self.target_entity );
}

function tank_idle()
{
	tank_set_target( self.aim_entity );
}

function tank_is_idle()
{
	return ( tank_get_target() == self.aim_entity );
}

function tank_has_radar()
{
	if ( level.teambased )
	{
		return ( killstreaks::HasUAV( self.team ) || killstreaks::HasSatellite( self.team ) ); 
	}

	return ( killstreaks::HasUAV( self.entnum ) || killstreaks::HasSatellite( self.entnum ) ); 
}

function tank_get_player_enemies( on_radar )
{
	enemies = [];
	
	if ( !isdefined( on_radar ) )
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

function tank_compute_enemy_position()
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

function valid_target( target, team, owner )
{
	if ( !isdefined( target ) )
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

		if ( isdefined( target.lastspawntime ) && GetTime() - target.lastspawntime < 3000 )
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
		if ( isdefined( target.team ) && team == target.team )
		{
			return false;
		}
	}

	if ( isdefined( target.owner ) && target.owner == owner )
	{
		return false;
	}

	if ( isdefined( target.script_owner ) && target.script_owner == owner )
	{
		return false;
	}
	
	if ( ( isdefined( target.dead ) && target.dead ) )
	{
		return false;
	}

	if ( isdefined( target.targetname ) && target.targetname == "riotshield_mp" )
	{
		if ( isdefined( target.damageTaken ) && target.damageTaken >= GetDvarInt( "riotshield_deployed_health" ) )
		{
			return false;
		}
	}

	return true;
}

function startTankRemoteControl( drone ) // self == player
{
	self.killstreak_waitamount = 120 * 1000;

	drone MakeVehicleUsable();
	drone ClearVehGoalPos();
	drone ClearTurretTarget();
	drone LaserOff();

	drone usevehicle( self, 0 );

	drone MakeVehicleUnusable();
	drone SetBrake( false );
	
	self create_weapon_hud();
	drone update_weapon_hud( self );

	self thread tank_fire_watch( drone );
	drone thread tank_rocket_watch( self );
}

function endTankRemoteControl( drone, isDead ) // self == player
{
	drone MakeVehicleUnusable();

	if ( !isDead )
	{
		drone thread tank_move_think();
		drone thread tank_riotshield_think();
		drone thread tank_aim_think();
		drone thread tank_combat_think();
		drone thread tank_rocket_think();
	}
}

function end_remote_control_ai_tank( drone ) // dead
{
	if (!isdefined(drone.dead) || !drone.dead)
	{			
		self thread hud::fade_to_black_for_x_sec( 0, 0.25, 0.1, 0.25 );
		wait( .3 );
	}
	else
	{
		wait( 0.75 );
		self thread hud::fade_to_black_for_x_sec( 0, 0.25, 0.1, 0.25 );
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
	if (isdefined(self.hud_prompt_control) && (!isdefined(drone.dead) || !drone.dead))
	{
		self.hud_prompt_control SetText("HOLD [{+activate}] TO CONTROL A.G.R.");	
		self.hud_prompt_exit SetText("");
	}
	self killstreaks::switch_to_last_non_killstreak_weapon();
	wait (.5);
	self takeweapon( level.ai_tank_remote_weapon );
				
	if (!isdefined(drone.dead) || !drone.dead)
	{
		drone thread tank_move_think();
		drone thread tank_riotshield_think();
		drone thread tank_aim_think();
		drone thread tank_combat_think();	
	}
}

function tank_fire_watch( drone )
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
		drone LaunchVehicle( dir * -5, drone.origin + (0,0,10), false );

		wait( level.ai_tank_turret_fire_rate );
	}
}

function tank_rocket_watch( player )
{
	self endon( "death" );
	player endon( "stopped_using_remote");

	if ( self.numberRockets <= 0 )
	{
		self DisableGunnerFiring( 0, true );
		wait ( 2 );

		self clientfield::set( "ai_tank_missile_fire", 4 );
		self.numberRockets = 3;

		wait (0.4);

		if ( !self.isStunned )
		{
			self DisableGunnerFiring( 0, false );
		}

		self update_weapon_hud( player );
	}

	if ( !self.isStunned )
	{
		self DisableGunnerFiring( 0, false );
	}
		
	while( true )
	{
		player waittill( "missile_fire" );
		self.numberRockets--;

		self clientfield::set( "ai_tank_missile_fire", self.numberRockets );

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
			wait ( 2 );

			self clientfield::set( "ai_tank_missile_fire", 4 );
			self.numberRockets = 3;
			
			wait (0.4);

			if ( !self.isStunned )
			{
				self DisableGunnerFiring( 0, false );
			}

			self update_weapon_hud( player );
		}
	}
}

function create_weapon_hud()
{
	self.tank_rocket_1 = newclienthudelem( self );
	self.tank_rocket_1.alignX = "right";
	self.tank_rocket_1.alignY = "bottom";
	self.tank_rocket_1.horzAlign = "user_center";
	self.tank_rocket_1.vertAlign = "user_bottom";
	self.tank_rocket_1.font = "small";
	self.tank_rocket_1 SetShader( "mech_check_fill", 32, 16 );
	self.tank_rocket_1.hidewheninmenu = false;
	self.tank_rocket_1.immunetodemogamehudsettings = true;
	self.tank_rocket_1.x = -250;
	self.tank_rocket_1.y = -75;
	self.tank_rocket_1.fontscale = 1.25;
	
	self.tank_rocket_2 = newclienthudelem( self );
	self.tank_rocket_2.alignX = "right";
	self.tank_rocket_2.alignY = "bottom";
	self.tank_rocket_2.horzAlign = "user_center";
	self.tank_rocket_2.vertAlign = "user_bottom";
	self.tank_rocket_2.font = "small";
	self.tank_rocket_2 SetShader( "mech_check_fill", 32, 16 );
	self.tank_rocket_2.hidewheninmenu = false;
	self.tank_rocket_2.immunetodemogamehudsettings = true;
	self.tank_rocket_2.x = -250;
	self.tank_rocket_2.y = -65;
	self.tank_rocket_2.fontscale = 1.25;
	
	self.tank_rocket_3 = newclienthudelem( self );
	self.tank_rocket_3.alignX = "right";
	self.tank_rocket_3.alignY = "bottom";
	self.tank_rocket_3.horzAlign = "user_center";
	self.tank_rocket_3.vertAlign = "user_bottom";
	self.tank_rocket_3.font = "small";
	self.tank_rocket_3 SetShader( "mech_check_fill", 32, 16 );
	self.tank_rocket_3.hidewheninmenu = false;
	self.tank_rocket_3.immunetodemogamehudsettings = true;
	self.tank_rocket_3.x = -250;
	self.tank_rocket_3.y = -55;
	self.tank_rocket_3.fontscale = 1.25;
	
	self thread fade_out_weapon_hud();
}

function fade_out_weapon_hud()
{
	self endon( "death" );

	wait( 8 );
	time = 0;
	while (time < 2)
	{
		if ( !isdefined(self.tank_rocket_hint))
		{
			return;	
		}
		self.tank_rocket_hint.alpha -= 0.025;
		self.tank_mg_hint.alpha -= 0.025;
		time += 0.05;
		{wait(.05);};
	}
	
	self.tank_rocket_hint.alpha = 0;
	self.tank_mg_hint.alpha = 0;
}

function update_weapon_hud( player )
{
	if ( isdefined( player.tank_rocket_3 ) )
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
function destroy_remote_hud()
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
function tank_devgui_think()
{
	SetDvar( "devgui_tank", "" );

	for ( ;; )
	{
		wait( 0.25 );

		level.ai_tank_turret_fire_rate = level.ai_tank_turret_weapon.fireTime;

		if ( GetDvarString( "devgui_tank" ) == "routes" )
		{
			devgui_debug_route();
			SetDvar( "devgui_tank", "" );
		}
	}
}

function tank_debug_patrol( node1, node2 )
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

function devgui_debug_route()
{
	iprintln( "Choose nodes with 'A' or press 'B' to cancel" );
	nodes = dev::dev_get_node_pair();

	if ( !isdefined( nodes ) )
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

function tank_debug_hud_init()
{
	host = util::getHostPlayer();

	while ( !isdefined( host ) )
	{
		wait( 0.25 );
		host = util::getHostPlayer();
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

function tank_debug_health()
{
	self.damage_debug = "";

	level.ai_tank_bar.alpha = 1;
	level.ai_tank_text.alpha = 1;
	
	for ( ;; )
	{
		{wait(.05);};

		if ( !isdefined( self ) || !IsAlive( self ) )
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
