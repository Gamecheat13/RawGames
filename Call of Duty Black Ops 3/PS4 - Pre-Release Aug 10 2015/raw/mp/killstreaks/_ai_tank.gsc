#using scripts\codescripts\struct;

#using scripts\shared\_oob;
#using scripts\shared\array_shared;
#using scripts\shared\callbacks_shared;
#using scripts\shared\challenges_shared;
#using scripts\shared\clientfield_shared;
#using scripts\shared\hud_shared;
#using scripts\shared\killstreaks_shared;
#using scripts\shared\scoreevents_shared;
#using scripts\shared\system_shared;
#using scripts\shared\util_shared;
#using scripts\shared\weapons\_weapons;
#using scripts\shared\vehicle_ai_shared;
#using scripts\shared\vehicle_shared;
#using scripts\shared\vehicles\_amws;

#using scripts\mp\_challenges;
#using scripts\mp\_util;
#using scripts\mp\gametypes\_dev;
#using scripts\mp\gametypes\_spawning;
#using scripts\mp\gametypes\_spawnlogic;
#using scripts\mp\killstreaks\_dogs;
#using scripts\mp\killstreaks\_emp;
#using scripts\mp\killstreaks\_killstreak_bundles;
#using scripts\mp\killstreaks\_killstreak_detect;
#using scripts\mp\killstreaks\_killstreak_hacking;
#using scripts\mp\killstreaks\_killstreakrules;
#using scripts\mp\killstreaks\_killstreaks;
#using scripts\mp\killstreaks\_remote_weapons;
#using scripts\mp\killstreaks\_satellite;
#using scripts\mp\killstreaks\_supplydrop;
#using scripts\mp\killstreaks\_uav;
#using scripts\shared\visionset_mgr_shared;

  
                                                                                                  	  	                          	                                         	                     	                 	                                                                         	                       	                                                      	                                                      	                                                       	                                                                                                  	                                                           	                 	                                                                                                           	                	                                          	                                      	       	  	             	                                                     	                                                                             	                         	                                                                	                                                             	                                                             	                                                                                      	                                                         	                                                         	                                                               	                                                               	                                                   	                                                                	                                                     	                                                	                                                	                                                        	                                                                                                  	                                                                             	                                            	                                                                                    	                                          	                     	                                              	                                        	         	     
    	   	                                                                                                                                         	                                	                                                                                                                                                                                                                                                                                                                                                                    	        	     	             	    	   	               	                                              	                                                           	                               	                     	                                                                                                           	                                                                 	                                                              	                                                                                                              	                            	                                     	                                       	                                                                                                              	   	                  	       	                                                    	                   	                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                        	                                  	                                                                                        	           	                        	                                            	                                             	                                                   	                                                             	                                                         	                                                                    	                                                                                                                                                                                                    	                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                         	                                                              	                                                          	                                   	                                   	                                                    	                                       	                                           	     	                                                                                                                                                                                                                                                      	                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                     
                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                            	                           	                           	                                                                                                                                                                                                                                                            	                                                                                                                                                                                                                                                                                                                                                                                       



















#precache( "string", "KILLSTREAK_EARNED_AI_TANK_DROP" );
#precache( "string", "KILLSTREAK_AI_TANK_NOT_AVAILABLE" );
#precache( "string", "KILLSTREAK_AI_TANK_INBOUND" );
#precache( "string", "KILLSTREAK_AI_TANK_HACKED" );
#precache( "string", "KILLSTREAK_DESTROYED_AI_TANK" );
#precache( "string", "mpl_killstreak_ai_tank" );
#precache( "triggerstring", "MP_REMOTE_USE_TANK" );
#precache( "fx", "killstreaks/fx_agr_emp_stun" );
#precache( "fx", "killstreaks/fx_agr_rocket_flash_1p" );
#precache( "fx", "killstreaks/fx_agr_rocket_flash_3p" );
#precache( "fx", "killstreaks/fx_agr_damage_state" );
#precache( "fx", "killstreaks/fx_agr_explosion" );
#precache( "fx", "killstreaks/fx_agr_drop_box" );

#using_animtree ( "mp_vehicles" );
	
#namespace ai_tank;

function init()
{
	bundle = struct::get_script_bundle( "killstreak",  "killstreak_" + "ai_tank_drop" );
	
	level.ai_tank_vehicle_version = 2; // 1 == old version, otherwise, new version

	level.ai_tank_minigun_flash_3p = "killstreaks/fx_agr_rocket_flash_3p";

	killstreaks::register( "ai_tank_drop", "ai_tank_marker", "killstreak_ai_tank_drop", "ai_tank_drop_used",&useKillstreakAITankDrop );
	if ( level.ai_tank_vehicle_version == 1 )
	{
		killstreaks::register_alt_weapon( "ai_tank_drop", "ai_tank_drone_gun" );
		killstreaks::register_alt_weapon( "ai_tank_drop", "amws_launcher_turret" );
	}
	else
	{
		killstreaks::register_alt_weapon( "ai_tank_drop", "amws_gun_turret" );
		killstreaks::register_alt_weapon( "ai_tank_drop", "amws_launcher_turret" );
		killstreaks::register_alt_weapon( "ai_tank_drop", "amws_gun_turret_mp_player" );
		killstreaks::register_alt_weapon( "ai_tank_drop", "amws_launcher_turret_mp_player" );
	}
	killstreaks::register_remote_override_weapon( "ai_tank_drop", "killstreak_ai_tank" );
	killstreaks::register_strings( "ai_tank_drop", &"KILLSTREAK_EARNED_AI_TANK_DROP", &"KILLSTREAK_AI_TANK_NOT_AVAILABLE", &"KILLSTREAK_AI_TANK_INBOUND", undefined, &"KILLSTREAK_AI_TANK_HACKED" );
	killstreaks::register_dialog( "ai_tank_drop", "mpl_killstreak_ai_tank", "aiTankDialogBundle", "aiTankPilotDialogBundle", "friendlyAiTank", "enemyAiTank", "enemyAiTankMultiple", "friendlyAiTankHacked", "enemyAiTankHacked", "requestAiTank", "threatAiTank" );
	killstreaks::devgui_scorestreak_command( "ai_tank_drop", "Debug Routes", "set devgui_tank routes");

	// TODO: Move to killstreak data
	level.killstreaks["ai_tank_drop"].threatOnKill = true;
	
	remote_weapons::RegisterRemoteWeapon( "killstreak_ai_tank", &"MP_REMOTE_USE_TANK", &startTankRemoteControl, &endTankRemoteControl, false );
	
	level.ai_tank_fov				= Cos( 160 );
	level.ai_tank_turret_weapon		= GetWeapon( "ai_tank_drone_gun" );
	level.ai_tank_turret_fire_rate	= level.ai_tank_turret_weapon.fireTime;
	level.ai_tank_remote_weapon		= GetWeapon( "killstreak_ai_tank" );

	level.ai_tank_valid_locations = [];
	spawns = spawnlogic::get_spawnpoint_array( "mp_tdm_spawn" );
	
	level.ai_tank_damage_fx = "killstreaks/fx_agr_damage_state";
	level.ai_tank_explode_fx = "killstreaks/fx_agr_explosion";
	level.ai_tank_crate_explode_fx = "killstreaks/fx_agr_drop_box";

	foreach( spawn in spawns )
	{
		level.ai_tank_valid_locations[ level.ai_tank_valid_locations.size ] = spawn.origin;
	}

	anims = [];
	anims[ anims.size ] = %o_drone_tank_missile1_fire;
	anims[ anims.size ] = %o_drone_tank_missile2_fire;
	anims[ anims.size ] = %o_drone_tank_missile3_fire;
	anims[ anims.size ] = %o_drone_tank_missile_full_reload;

	if(!isdefined(bundle.ksMainTurretRecoilForceZOffset))bundle.ksMainTurretRecoilForceZOffset=0;
	if(!isdefined(bundle.ksWeaponReloadTime))bundle.ksWeaponReloadTime=0.5;
	
	visionset_mgr::register_info( "visionset", "agr_visionset", 1, 80, 16, true, &visionset_mgr::ramp_in_out_thread_per_player, false  );
	
/#
	level thread tank_devgui_think();
#/
	thread register();
}

function register()
{
	clientfield::register( "vehicle", "ai_tank_death", 1, 1, "int" );
	clientfield::register( "vehicle", "ai_tank_missile_fire", 1, 2, "int" );	
	clientfield::register( "vehicle", "ai_tank_stun", 1, 1, "int" );
	clientfield::register( "toplayer", "ai_tank_update_hud", 1, 1, "counter" );
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
	
	context = SpawnStruct();
	context.radius = level.killstreakCoreBundle.ksAirdropAITankRadius;
	context.isLocationGood = &is_location_good;
	context.objective = &"airdrop_aitank";
	context.killstreakRef = hardpointType;
	context.validLocationSound = level.killstreakCoreBundle.ksValidAITankLocationSound;	
	
	result = self supplydrop::useSupplyDropMarker( killstreak_id, context );
	
	// the marker is out but the chopper is yet to come
	self notify( "supply_drop_marker_done" );

	if ( !isdefined(result) || !result )
	{
		//if( !self.supplyGrenadeDeathDrop )
			killstreakrules::killstreakStop( hardpointType, team, killstreak_id );
		return false;
	}

	self killstreaks::play_killstreak_start_dialog( "ai_tank_drop", self.team, killstreak_id );	
	self killstreakrules::displayKillstreakStartTeamMessageToAll( "ai_tank_drop" );

	return result;
}

function crateLand( crate, category, owner, team )
{
	if ( !crate valid_location() || !isdefined( owner ) || team != owner.team || ( owner EMP::EnemyEMPActive() && !owner hasperk("specialty_immuneemp") ) )
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

function is_location_good( location, context )
{
	return supplydrop::IsLocationGood( location, context ) && valid_location( location );
}

function valid_location( location )
{
	if ( !isdefined( location ) )
		location = self.origin;

	// check for a valid start node	
	node = GetClosestPointOnNavMesh( location, 96, 48 );

	if ( !isdefined( node ) )
		return false;
	
	// make sure the selected point is roughly on the same floor
	if ( Abs( location[2] - node[2] ) > 96 )
		return false;

	start = self GetCentroid();
	end = node + ( 0, 0, 16 );

	trace = PhysicsTrace( start, end, ( 0, 0, 0 ), ( 0, 0, 0 ), self, (1 << 4) );

	if ( trace["fraction"] < 1 )
		return false;
		
	// check for a path 
	origin = location + ( 0, 0, 32 );

	level.ai_tank_valid_locations = array::randomize( level.ai_tank_valid_locations );
	
	if( self oob::IsTouchingAnyOOBTrigger() )
	{
		return false;
	}
	
	return true;
}

function HackedCallbackPre( hacker )
{
	drone = self;
	drone clientfield::set( "enemyvehicle", 2 );
	drone.owner stop_remote();
	drone.owner clientfield::set_to_player( "static_postfx", 0 );
	visionset_mgr::deactivate( "visionset", "agr_visionset", drone.owner );
	drone.owner remote_weapons::RemoveAndAssignNewRemoteControlTrigger( drone.useTrigger );
	drone remote_weapons::EndRemoteControlWeaponUse( true );
	drone.owner unlink();	
	drone clientfield::set( "vehicletransition", 0 );
}

function HackedCallbackPost( hacker )
{
	drone = self;
	
	hacker remote_weapons::UseRemoteWeapon( drone, "killstreak_ai_tank", false );
	drone notify("WatchRemoteControlDeactivate_remoteWeapons");
	drone.killstreak_end_time = hacker killstreak_hacking::set_vehicle_drivable_time_starting_now( drone );
}

function ConfigureTeamPost( owner, isHacked )
{
	drone = self;
	drone thread tank_watch_owner_events();
}

function ai_tank_killstreak_start( owner, origin, killstreak_id, category )
{
	waittillframeend;
	drone = SpawnVehicle( get_vehicle_name( level.ai_tank_vehicle_version ), origin, (0, 0, 0), "talon" );
	drone.customDamageMonitor = true;	// Disable the default monitor_damage_as_occupant thread 
	
	drone killstreaks::configure_team( "ai_tank_drop", killstreak_id, owner, "small_vehicle", undefined, &ConfigureTeamPost );
	drone killstreak_hacking::enable_hacking( "ai_tank_drop", &HackedCallbackPre, &HackedCallbackPost );
	
	drone killstreaks::setup_health( "ai_tank_drop", 800, 0 );
	drone.original_vehicle_type = drone.vehicletype;

	drone clientfield::set( "enemyvehicle", 1 );
	drone SetVehicleAvoidance( true );
	drone clientfield::set( "ai_tank_missile_fire", ( 3 ) );
	drone.killstreak_id = killstreak_id;
	drone.type = "tank_drone";
	drone.dontDisconnectPaths = 1;
	drone.isStunned = false;
	drone.soundmod = "drone_land";
	drone.ignore_vehicle_underneath_splash_scalar = true;

	drone.controlled = false;
	drone MakeVehicleUnusable();
	
	drone.numberRockets = ( 3 );
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
	
	// setup target group for missile lock on monitoring
	drone vehicle::init_target_group();
	drone vehicle::add_to_target_group( drone );
		
	drone setup_ai_think( level.ai_tank_vehicle_version );
	drone setup_gameplay_think( category );
	
	drone.killstreak_end_time = GetTime() + ( 120 * 1000 );

	owner remote_weapons::UseRemoteWeapon( drone, "killstreak_ai_tank", false );
	
	drone thread kill_monitor();
	drone thread deleteOnKillbrush( drone.owner );
	level thread tank_game_end_think(drone);

/#
	drone thread tank_think_debug();
#/
		
/#
	//drone thread tank_debug_health();
#/
}

function get_vehicle_name( vehicle_version )
{	
	switch( vehicle_version )
	{
		case 2:
		default:
			return "spawner_bo3_ai_tank_mp";
			break;
		
		case 1:
			return "ai_tank_drone_mp";
			break;
	}
}

function setup_ai_think( vehicle_version )
{
	drone = self;
	
	switch( vehicle_version )
	{
		case 2:
		default:
			break;
		
		case 1:
			{
				drone thread tank_move_think();
				drone thread tank_aim_think();
				drone thread tank_combat_think();
				drone thread tank_riotshield_think();
				drone thread tank_rocket_think();
			}
			break;
	}
}

function setup_gameplay_think( category )
{
	drone = self;
	
	drone thread tank_abort_think();
	drone thread tank_team_kill();
	drone thread tank_ground_abort_think();
	drone thread tank_death_think( category );
	drone thread tank_damage_think();
}


function tank_think_debug()	// self == drone
{
	self endon ( "death" );

	server_frames_to_persist = 1;
	text_scale = 0.5;
	text_alpha = 1.0;
	text_color = ( 1, 1, 1 );

	while ( 1 )
	{
		if ( GetDvarInt( "scr_ai_tank_think_debug" ) == 0 )
		{
			wait 5;
			continue;
		}

		target_name = "unknown";
		target_entity = undefined;
		if ( level.ai_tank_vehicle_version == 1 )
		{

			tank_is_idle = self tank_is_idle();
			target_entity = self.target_entity;
		}
		else
		{
			tank_is_idle = !isdefined( self.enemy ); // NOTE: enemy is set by code-side ai system
			target_entity = self.enemy;
		}
	
		if ( isdefined( target_entity ) && !tank_is_idle )
		{
			if ( isdefined ( target_entity.name ) )
			{
				target_name = target_entity.name;
			}	
			else if ( isdefined ( target_entity.remotename ) )
			{
				target_name = target_entity.remotename;
			}
		}
		
		target_text = ( ( tank_is_idle ) ? "Target: none" : "Target: " + target_name );
		/# Print3d( self.origin, target_text, text_color, text_alpha, text_scale, server_frames_to_persist ); #/
		
		duration_text = "Duration: " + ( (self.killstreak_end_time - GetTime()) * 0.001 );
		/# Print3d( self.origin + ( 0, 0, 12 ), duration_text, text_color, text_alpha, text_scale, server_frames_to_persist ); #/
		
		can_see_text = "Can see: ";
		if ( tank_is_idle )
		{
			can_see_text += "---";
		}
		else
		{
			can_see_text += ( ( self VehCanSee( target_entity ) ) ? "yes" : "no" );
		}
		/# Print3d( self.origin + ( 0, 0, -12 ), can_see_text, text_color, text_alpha, text_scale, server_frames_to_persist ); #/
		
		movement_type_text = "Movement: ";
		if ( isdefined( self.debug_ai_movement_type ) )
		{
			movement_type_text += self.debug_ai_movement_type;
		}
		else
		{
			movement_type_text += "---";
		}
		/# Print3d( self.origin + ( 0, 0, -24 ), movement_type_text, text_color, text_alpha, text_scale, server_frames_to_persist ); #/			
	
		if ( isdefined( self.debug_ai_move_to_point ) )
		{
			/# util::debug_sphere( self.debug_ai_move_to_point + ( 0, 0, 16 ), 10, ( 0.1, 0.95, 0.1 ), 0.9, server_frames_to_persist ); #/
				
			if ( isdefined( self.debug_ai_move_to_points_considered ) )
			{
				foreach( point in self.debug_ai_move_to_points_considered )
				{
					point_color = ( 0.65, 0.65, 0.65 ); // grey-ish
					
					if ( isdefined( point.score ) )
					{
						if ( point.score != 0 )
						{
						    if ( point.score < 0 )
							{
								point_color = ( 0.65, 0.1, 0.1 ); //dark red-ish
							}
						    else if ( point.score > 50 )
						    {
						    	point_color = ( 0.1, 0.65, 0.1 ); // dark green-ish
						    }
						    else
						    {
								point_color = ( 0.95, 0.95, 0.1 ); // yellow-ish
						    }
						    
						    score_text_scale = text_scale;
						  	score_text_color = text_color;
							if ( point.origin != self.debug_ai_move_to_point )
							{
								score_text_scale *= 0.67;
							}
							else
							{
								score_text_scale *= 1.5;
								score_text_color = ( 0.05, 0.98, 0.05 ); // green-ish
							}
						    
							/# Print3d( point.origin + ( 0, 0, 16 ), point.score, score_text_color, text_alpha, score_text_scale, server_frames_to_persist ); #/
						}
					}
						
					if ( point.origin != self.debug_ai_move_to_point )
					{
						/# util::debug_sphere( point.origin + ( 0, 0, 16 ), 3, point_color, 0.5, server_frames_to_persist ); #/
					}
				}
			}
		}
		
		{wait(.05);};
	}
}

function tank_team_kill()
{
	self endon( "death" );
	self.owner waittill( "teamKillKicked" );
	self notify ( "death" );
}

function kill_monitor()
{
	self endon( "death" );
	
	last_kill_vo = 0;
	kill_vo_spacing = 4000;
	
	while(1)
	{
		self waittill( "killed", victim );		

		if ( !isdefined( self.owner ) || !isdefined( victim ) )
			continue;
			
		if ( self.owner == victim )
			continue;
		
		if ( level.teamBased && self.owner.team == victim.team )
			continue;
			
		if ( !self.controlled && last_kill_vo + kill_vo_spacing < GetTime() )
		{
			self killstreaks::play_pilot_dialog_on_owner( "kill", "ai_tank_drop", self.killstreak_id );
		
			last_kill_vo = GetTime();	
		}
	}
}

function tank_abort_think()
{
	tank = self;	

	tank thread killstreaks::WaitForTimeout( "ai_tank_drop", ( 120 * 1000 ), &tank_timeout_callback, "death", "emp_jammed" );
}

function tank_timeout_callback()
{
	self killstreaks::play_pilot_dialog_on_owner( "timeout", "ai_tank_drop" );
	
	self notify( "death" );
}

function tank_watch_owner_events()
{
	self notify( "tank_watch_owner_events_singleton" );
	self endon ( "tank_watch_owner_events_singleton" );
	self endon( "death" );
	
	self.owner util::waittill_any( "joined_team", "disconnect", "joined_spectators" );

	self MakeVehicleUsable();
	self.controlled = false;
	
	if ( isdefined( self.owner ) )
	{
		self.owner unlink();
		self clientfield::set( "vehicletransition", 0 );
	}
	
	self MakeVehicleUnusable();
	
	if ( isdefined( self.owner ) )
		self.owner stop_remote();
	
	self.abandoned = true;

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
	self remote_weapons::destroyRemoteHUD();	
	self util::clientNotify( "nofutz" );
}


function tank_hacked_health_update( hacker )
{
	tank = self;
	hackedDamageTaken = tank.defaultMaxHealth - tank.hackedHealth;
	assert ( hackedDamageTaken > 0 );
	if ( hackedDamageTaken > tank.damageTaken )
	{
		tank.damageTaken = hackedDamageTaken;
	}
}


function tank_damage_think()
{
	self endon( "death" );

	assert( isdefined( self.maxhealth ) );
	self.defaultMaxHealth = self.maxhealth;
	maxhealth = self.maxhealth; // actual max heath should be set now.

	self.maxhealth = 999999;
	self.health = self.maxhealth;
	self.isStunned = false;
	
	self.hackedHealthUpdateCallback = &tank_hacked_health_update;
	self.hackedHealth = killstreak_bundles::get_hacked_health( "ai_tank_drop" );
	
	low_health = false;
	self.damageTaken = 0;

	for ( ;; )
	{
		self waittill( "damage", damage, attacker, dir, point, mod, model, tag, part, weapon, flags, inflictor, chargeLevel );		
		
		self.maxhealth = 999999;
		self.health = self.maxhealth;

/#
		self.damage_debug = ( damage + " (" + weapon.name + ")" );
#/

		if ( weapon.isEmp && (mod == "MOD_GRENADE_SPLASH"))
		{
			emp_damage_to_apply = killstreak_bundles::get_emp_grenade_damage( "ai_tank_drop", maxhealth );
			
			if ( !isdefined( emp_damage_to_apply ) )
				emp_damage_to_apply = ( maxhealth / 2 );

			self.damageTaken += emp_damage_to_apply;
			damage = 0;
			if ( !self.isStunned && emp_damage_to_apply > 0 )
			{
				self.isStunned = true;
				challenges::stunnedTankWithEMPGrenade( attacker );
				self thread tank_stun( 4 );
			}
		}
		
		if ( !self.isStunned )
		{
			if ( weapon.doStun && (mod == "MOD_GRENADE_SPLASH" || mod == "MOD_GAS") )
			{
				self.isStunned = true;
				self thread tank_stun( 1.5 );
			}
		}
		
		weapon_damage = killstreak_bundles::get_weapon_damage( "ai_tank_drop", maxhealth, attacker, weapon, mod, damage, flags, chargeLevel );		
		
		if ( !isdefined( weapon_damage ) )
		{
			if ( mod == "MOD_RIFLE_BULLET" || mod == "MOD_PISTOL_BULLET" || weapon.name == "hatchet" || (mod == "MOD_PROJECTILE_SPLASH" && weapon.bulletImpactExplode) )
			{
				if ( isPlayer( attacker ) )
				    if ( attacker HasPerk( "specialty_armorpiercing" ) )
						damage += int( damage * level.cac_armorpiercing_data );
				
				if ( weapon.weapClass == "spread")
					damage = damage * 4.5;
				
				weapon_damage = damage * 0.3;
			}
			
			if ( ( mod == "MOD_PROJECTILE" || mod == "MOD_GRENADE_SPLASH" || mod == "MOD_PROJECTILE_SPLASH" ) && damage != 0 && !weapon.isEmp && !weapon.bulletImpactExplode)
			{				
				weapon_damage = damage * 1.5;
			}
			
			if ( !isdefined( weapon_damage ) )
			{
				weapon_damage = damage;
			}
		}		

		self.damageTaken += weapon_damage;

		if ( self.controlled )
		{
			self.owner SendKillstreakDamageEvent( int( weapon_damage ) );
			self.owner vehicle::update_damage_as_occupant( self.damageTaken, maxhealth );
		}
		
		if ( self.damageTaken >= maxhealth )
		{
			if( isdefined( self.owner ) )
				self.owner.dofutz = true;
			
			self.health = 0;
			self notify( "death", attacker, mod, weapon );
			return;
		}

		if ( !low_health && self.damageTaken > maxhealth / 1.8 )
		{
			self killstreaks::play_pilot_dialog_on_owner( "damaged", "ai_tank_drop", self.killstreak_id );
			
			self thread tank_low_health_fx();
			low_health = true;
		}

		if ( level.ai_tank_vehicle_version == 1 )
		{
			if ( isdefined( attacker ) && IsPlayer( attacker ) && self tank_is_idle() && !self.isStunned )
			{
				self.aim_entity.origin = attacker GetCentroid();
				self.aim_entity.delay = 8;
				self notify( "aim_updated" );
			}
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
		
		self.owner SendKillstreakDamageEvent( 400 );
	}
	if (isdefined(self.owner.fullscreen_static))
	{
		self.owner thread remote_weapons::stunStaticFX( duration );
	}
	
	self clientfield::set( "ai_tank_stun", 1 );
	
	if( self.controlled )
		self.owner clientfield::set_to_player( "static_postfx", 1 );
	
	wait ( duration );
	
	self clientfield::set( "ai_tank_stun", 0 );
	
	if( self.controlled )
		self.owner clientfield::set_to_player( "static_postfx", 0 );

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
	self notify ("death");
	
	time = 0;
	randomAngle = RandomInt(360);
	while (time < 1.45)
	{
		self SetTurretTargetVec(self.origin + AnglesToForward((RandomIntRange(305, 315), int((randomAngle + time * 180)), 0)) * 100);
		if (time > 0.2)
		{
			self FireWeapon( 1 );
			if ( RandomInt(100) > 85)
			{
				rocket = self FireWeapon( 0 );

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
	
	not_abandoned = ( !isdefined( self.abandoned ) || !self.abandoned );

	if ( self.controlled == true )
	{
		self.owner SendKillstreakDamageEvent( 600 );
		self.owner remote_weapons::destroyRemoteHUD();	
	}

	self clientfield::set( "ai_tank_death", 1 );
	stunned = false;
	PlayFX( level.ai_tank_explode_fx, self.origin, (0, 0, 1) );
	PlaySoundAtPosition( "wpn_agr_explode", self.origin );

	if ( not_abandoned )
	{
		util::wait_network_frame();
	}

	if ( self.controlled )
	{
		self Ghost(); // keep the view for player with the dead by using ghost, otherwise, will end up at feet of player
	}
	else
	{
		self Hide();
	}

	if (isdefined(self.damage_fx))
	{
		self.damage_fx delete();
	}

	if ( isdefined( attacker ) && IsPlayer( attacker ) && isdefined( self.owner ) && attacker != self.owner )
	{
		if ( self.owner util::IsEnemyPlayer( attacker ) )
		{
			scoreevents::processScoreEvent( "destroyed_aitank", attacker, self.owner, weapon );
			LUINotifyEvent( &"player_callout", 2, &"KILLSTREAK_DESTROYED_AI_TANK", attacker.entnum );		
			attacker AddWeaponStat( weapon, "destroyed_aitank", 1 );
			if ( isdefined( self.wasControlledNowDead ) && self.wasControlledNowDead )
			{
				attacker AddWeaponStat( weapon, "destroyed_controlled_killstreak", 1 );
			}
			
			self killstreaks::play_destroyed_dialog_on_owner( "ai_tank_drop", self.killstreak_id );
		}
		else
		{
			//Destroyed Friendly Killstreak 
		}
	}

	if ( not_abandoned )
		self util::waittill_any_timeout( 2.0, "remote_weapon_end" );
		
	killstreakrules::killstreakStop( hardpointName, team, self.killstreak_id );

	if ( isdefined( self.aim_entity ) )
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
		
	bundle = level.killstreakBundle["ai_tank_drop"];

	do_wait = true;

	for ( ;; )
	{
		if ( do_wait )
		{
			wait( RandomFloatRange( bundle.ksThinkWaitMin, bundle.ksThinkWaitMax ) );
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
					wait( 0.2 );
				}
				else
				{
					self SetVehGoalPos( enemy.origin, true, true );
					self util::wait_endon( 3, "reached_end_node" );
				}
				
				if ( valid_target( enemy, self.team, self.owner ) )
				{
					do_wait = false;
				}

				continue;
			}
		}

		nodes = [];
		avg_position = tank_compute_enemy_position();

		if ( isdefined( avg_position ) )
		{
			nodes = util::PositionQuery_PointArray( avg_position, 0, 256, 70, 40 );
		}
		
		if ( nodes.size == 0 )
		{
			nodes = util::PositionQuery_PointArray( self.owner.origin, 256, 1024, 70, 128 );
		}
	
		if ( nodes.size > 0 )
		{
			node = nodes[ RandomIntRange( 0, nodes.size ) ];
		}
		else
		{
			continue;
		}

		path_distance = PathDistance( self.origin, node );
		if ( !isdefined( path_distance ) )
			path_distance = 999999; // really far

		should_set_new_goal = ( path_distance > 256 );

		if ( should_set_new_goal && self SetVehGoalPos( node, true, true ) )
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
	const GRID_CELL_SIZE = 20;

	ground_trace_fail = 0;

	for ( ;; )
	{
		wait( 1 );
		nodes = util::PositionQuery_PointArray( self.origin, 0, 512, 70, GRID_CELL_SIZE );

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
		self util::wait_endon( RandomFloatRange( 0.5, 1.5 ), "aim_updated", "force_aim_wake" );

		if ( self.aim_entity.delay > 0 )
		{
			wait( self.aim_entity.delay );
			self.aim_entity.delay = 0;
		}

		if ( !tank_is_idle() )
		{
			continue;
		}

		if ( self GetSpeed() <= 1 )
		{
			enemies = tank_get_player_enemies( false );			
			if ( enemies.size > 0 )
			{
				remaining_attempts = 3;
				enemy_picked = false;
				
				while ( !enemy_picked && remaining_attempts > 0 )
				{
					enemy = enemies[ RandomIntRange( 0, enemies.size ) ];
	
					if ( self VehCanSee( enemy ) )
					{
						self.aim_entity.origin = enemy GetCentroid();
						enemy_picked = true;
						self notify( "aim_entity_acquired" );
					}
					
					remaining_attempts--;
				}
				
				if ( enemy_picked )
					continue;
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

		if ( !BulletTracePassed( origin, target GetCentroid(), false, self, target ) )
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
	
	bundle = level.killstreakBundle["ai_tank_drop"];

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

		can_see_enemy = self VehCanSee( enemy );

		if ( !valid_target( enemy, self.team, self.owner ) )
		{
			return;
		}

		self.aim_entity.origin = enemy GetCentroid();

		distSq = DistanceSquared( self.origin, enemy.origin );

		if ( distSq > 64 * 64 && !can_see_enemy )
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
			self notify( "force_aim_wake" ); // wake up aim thread
		}
		
		if ( !can_see_enemy )
		{
			warning_shots = self.warningShots;	
		}

		if ( do_fire_delay )
		{
			self PlaySound( "wpn_metalstorm_lock_on" ); 
			wait( RandomFloatRange( bundle.ksEngageTargetReactionTimeMin , bundle.ksEngageTargetReactionTimeMax ) );
			do_fire_delay = false;

			if ( !valid_target( enemy, self.team, self.owner ) )
			{
				return;
			}
		}

		if ( fire_rocket )
		{
			rocket = self FireWeapon( 0, undefined, undefined, self.owner );
			self notify( "missile_fire" );

			if ( isdefined( rocket ) )
			{
				rocket.from_ai = true;
				rocket.killcament = self;
				rocket util::wait_endon( RandomFloatRange( 0.5, 1 ), "death" );
				continue;
			}
		}

		self FireWeapon( 1, enemy );
		
		warning_shots--;
		wait( level.ai_tank_turret_fire_rate );

		if ( isdefined( enemy ) && !IsAlive( enemy ) )
		{
			bullets = RandomIntRange( 8, 15 );
			for ( i = 0; i < bullets; i++ )
			{
				self FireWeapon( 1, enemy );
				wait( level.ai_tank_turret_fire_rate );
			}
		}

		self StopFireWeapon();
	}
}

function tank_target_lost()
{
	self endon( "turret_on_vistarget" );
	self endon( "aim_entity_acquired" );
	self endon( "death" );

	give_up_on_lost_target_time = GetTime() + 1000 * 5;
	
	while ( GetTime() < give_up_on_lost_target_time && !self tank_is_idle() )
	{
		if ( self VehCanSee( self.target_entity ) )
			return;
	
		wait ( 0.1 );
	}	
	
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

	origin = self GetTagOrigin( "tag_flash" );

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
	
	bundle = level.killstreakBundle["ai_tank_drop"];

	if ( self.numberRockets <= 0 )
	{
		self DisableDriverFiring( true );
		wait ( bundle.ksWeaponReloadTime );

		self.numberRockets = ( 3 );
		self update_client_ammo( self.numberRockets );

		wait (0.4);

		if ( !self.isStunned )
		{
			self DisableDriverFiring( false );
		}
	}
	
	while( true )
	{
		self waittill( "missile_fire" );
		self.numberRockets--;
		self update_client_ammo( self.numberRockets );

		self perform_recoil_missile_turret();

		if ( self.numberRockets <= 0 )
		{
			self DisableDriverFiring( true );
			wait ( bundle.ksWeaponReloadTime );

			self.numberRockets = ( 3 );
			self update_client_ammo( self.numberRockets );

			wait (0.4);

			if ( !self.isStunned )
			{
				self DisableDriverFiring( false );
			}
		}
	}
}

function tank_set_target( entity, aim_using_missile_turret = false )
{
	self.target_entity = entity;

	if ( aim_using_missile_turret )
	{
		angles = self GetTagAngles( "tag_barrel" );
		right = AnglesToRight( angles );
		offset = VectorScale( right, 8 );
		
		velocity = entity GetVelocity();
		speed = Length( velocity );

		forward = AnglesToForward( entity.angles );
		origin = offset + VectorScale( forward, speed );

		self ClearTurretTarget( 1 );
		self SetTurretTargetEnt( entity, origin );
		
		// /# sphere( entity.origin + origin, 16, ( 0.8, 0.05, 0.05 ), 0.5, false, 20, 500 ); #/
	}
	else
	{
		// note: still need to aim with main turret, but use an offset
		vector_to_ent_xy = ( entity.origin[0] - self.origin[0], entity.origin[1] - self.origin[1], 0 );
		if ( Abs( vector_to_ent_xy[0] ) > 0.01 || Abs( vector_to_ent_xy[1] ) > 0.01 )
		{
			ent_dir_xy = VectorNormalize( vector_to_ent_xy );
			ent_right = VectorCross( ent_dir_xy, (0,0,1) );
			aim_offset = VectorScale( ent_right, -24 );
		}
		else
		{
			aim_offset = ( 0, 0, 0 );
		}
		self SetTurretTargetEnt( entity, aim_offset );
		
		// also aim gunner turret
		self SetGunnerTargetEnt( entity, (0,0,0), 1 - 1 );
		
		// /# sphere( entity.origin, 16, ( 0.3, 0.6, 0.05 ), 0.5, false, 20, 500 ); #/
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
		return ( uav::HasUAV( self.team ) || satellite::HasSatellite( self.team ) );
	}

	return ( uav::HasUAV( self.entnum ) || satellite::HasSatellite( self.entnum ) );
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
		
		if ( target hasPerk( "specialty_nottargetedbyaitank" ) )
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
	drone MakeVehicleUsable();
	drone ClearVehGoalPos();
	drone ClearTurretTarget();
	drone LaserOff();
	
	if ( isdefined( drone.PlayerDrivenVersion ) )
		drone SetVehicleType( drone.PlayerDrivenVersion );

	drone usevehicle( self, 0 );
	drone clientfield::set( "vehicletransition", 1 );
	

	drone MakeVehicleUnusable();
	drone SetBrake( false );

	drone thread tank_rocket_watch( self );
	drone thread vehicle::monitor_missiles_locked_on_to_me( self );
	
	self vehicle::set_vehicle_drivable_time( ( 120 * 1000 ), drone.killstreak_end_time );
	drone update_client_ammo( drone.numberRockets, true );
	
	visionset_mgr::activate( "visionset", "agr_visionset", self, 1, 90000, 1 );
}

function endTankRemoteControl( drone, exitRequestedByOwner )
{
	not_dead = !( isdefined( drone.dead ) && drone.dead );

	if ( isdefined( drone.owner ) )	
	{
		drone.owner remote_weapons::destroyRemoteHUD();
	}
	
	if( drone.classname == "script_vehicle")
		drone MakeVehicleUnusable();

	if ( isdefined( drone.original_vehicle_type ) && not_dead )
		drone SetVehicleType( drone.original_vehicle_type );
	
	if ( isdefined( drone.owner ) )
		drone.owner vehicle::stop_monitor_missiles_locked_on_to_me();

	if( exitRequestedByOwner && not_dead )
	{
		if ( level.ai_tank_vehicle_version == 1 )
		{
			drone thread tank_move_think();
			drone thread tank_riotshield_think();
			drone thread tank_aim_think();
			drone thread tank_combat_think();
			drone thread tank_rocket_think();
		}
		else
		{
			drone vehicle_ai::set_state( "combat" );
		}
	}
	
	if ( drone.cobra === true && not_dead )
		drone thread amws::cobra_retract();

	if ( isdefined( drone.owner ) )
		visionset_mgr::deactivate( "visionset", "agr_visionset", drone.owner );
	
	drone clientfield::set( "vehicletransition", 0 );
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
	drone clientfield::set( "vehicletransition", 0 );
	drone MakeVehicleUnusable();
	self stop_remote();

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
		if ( level.ai_tank_vehicle_version == 1 )
		{
			drone thread tank_move_think();
			drone thread tank_riotshield_think();
			drone thread tank_aim_think();
			drone thread tank_combat_think();
		}
		else
		{
			drone vehicle_ai::set_state( "combat" );
		}
	}
}

function perform_recoil_missile_turret( player ) // self == drone
{
	bundle = level.killstreakBundle["ai_tank_drop"];
	Earthquake( 0.4, 0.5, self.origin, 200 );
	self perform_recoil( "tag_barrel",  ( ( ( isdefined( self.controlled ) && self.controlled ) ? bundle.ksMainTurretRecoilForceControlled : bundle.ksMainTurretRecoilForce ) ), bundle.ksMainTurretRecoilForceZOffset );
	
	if ( self.controlled && isdefined( player ) )
	{
		player PlayRumbleOnEntity( "sniper_fire" );
	}
}

function perform_recoil( recoil_tag, force_scale_factor, force_z_offset ) // self == drone
{
	angles = self GetTagAngles( recoil_tag );
	dir = AnglesToForward( angles );
	self LaunchVehicle( dir * force_scale_factor, self.origin + ( 0, 0, force_z_offset ), false );
}

function update_client_ammo( ammo_count, driver_only_update = false ) // self == vehicle
{
	if ( !driver_only_update )
	{
		self clientfield::set( "ai_tank_missile_fire", ammo_count );
	}

	if ( self.controlled )
	{
		self.owner clientfield::increment_to_player( "ai_tank_update_hud", 1 );
	}
}

function tank_rocket_watch( player )
{
	self endon( "death" );
	player endon( "stopped_using_remote");

	if ( self.numberRockets <= 0 )
	{
		self reload_rockets( player );
	}

	if ( !self.isStunned )
	{
		self DisableDriverFiring( false );
	}
		
	while( true )
	{
		player waittill( "missile_fire", missile );
		missile.killCamEnt = player GetVehicleOccupied();
		self.numberRockets--;
		self update_client_ammo( self.numberRockets );

		self perform_recoil_missile_turret( player );
		
		if ( self.numberRockets <= 0 )
		{
			self reload_rockets( player );
		}
	}
}

function reload_rockets( player )
{
	bundle = level.killstreakBundle["ai_tank_drop"];
	self DisableDriverFiring( true );
	wait ( bundle.ksWeaponReloadTime );
	
	// setup the "reload" time for the player's vehicle HUD
	weapon_wait_duration_ms = Int( bundle.ksWeaponReloadTime * 1000 );
	player SetVehicleWeaponWaitDuration( weapon_wait_duration_ms );
	player SetVehicleWeaponWaitEndTime( GetTime() + weapon_wait_duration_ms );

	self.numberRockets = ( 3 );
	self update_client_ammo( self.numberRockets );

	wait (0.4);

	if ( !self.isStunned )
	{
		self DisableDriverFiring( false );
	}
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
		self SetVehGoalPos( node1.origin, true );
		self waittill( "reached_end_node" );

		wait( 1 );

		self SetVehGoalPos( node2.origin, true );
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
