                                                                                                                                                                                                                                                                                                                                                                                                                 	                                                                                                                                                                          	                                                                                         	                                                                                                                                                                                                                                                                                                                                                                                                                                        	                                                                                                                               	                                                                                                                                                                                                                                              	                                                                                                                                           	                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                   	                                                                                                                       	   	                                                                                                                                                                                                                                                                                                                         	                                                                                                                                                                                                                                      
                                                                                                                                                                                                                                                                                                    	                                                                                     	                                                                                                                                                                                                                                                                                             	                                                                                                                                                                                                                                                                                                                                                                                                   	                                                                                                                                                                                                                                                                                                         	                                                   
                                                                                                                               
    	   	                                                                                                                         	                                                                                                                                                                                                                                                                                                                                                                    	        	     	             	    	   	                           	                               	                                	                                                              	                                                                                                              	                            	                                     	                                       	                                                               	   	                  	       	                                                    	                   	                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                       	                                                                                        	           	                        	                                            	                                             	                                                   	                                                             	                                                         	                                                                    	                                                                                                                                                                                                    	                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                     	                                                              	                                                          	                                   	                                   	                                                    	                                       
                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                            	                                                                                                                                                                                                                                                                                                                                                                                       

#using scripts\codescripts\struct;

#using scripts\shared\array_shared;
#using scripts\shared\callbacks_shared;
#using scripts\shared\clientfield_shared;
#using scripts\shared\flag_shared;
#using scripts\shared\system_shared;
#using scripts\shared\table_shared;
#using scripts\shared\util_shared;

#using scripts\shared\ai\zombie_utility; 

#using scripts\zm\_zm_ai_wasp;
#using scripts\zm\_zm_audio;
#using scripts\zm\_zm_equipment;
#using scripts\zm\_zm_laststand;
#using scripts\zm\_zm_powerups;
#using scripts\zm\_zm_score;
#using scripts\zm\_zm_unitrigger;
#using scripts\zm\_zm_utility;
#using scripts\zm\_zm_zonemgr;
#using scripts\zm\zm_zod_idgun_quest;
#using scripts\zm\zm_zod_util;

#namespace zm_zod_pods;

function autoexec __init__sytem__() {     system::register("zm_zod_pods",&__init__,&__main__,undefined);    }




	// New pods will spawn starting in this round, or when the first player picks up a sprayer.


	



#precache( "lui_menu_data", "pod_sprayer" );
#precache( "triggerstring", "ZM_ZOD_POD_HARVEST" );
#precache( "triggerstring", "ZM_ZOD_X_TO_PICK_UP" );

function __init__()
{
	clientfield::register( "scriptmover", "pod_level", 1, 2, "int" );
	clientfield::register( "scriptmover", "pod_harvest", 1, 1, "int" );
	
	level.pods = SpawnStruct();
	level.pods.upgrade_odds = array( 0, 0, 0.25, 0.5, 1.0 ); // odds of a pod upgrading after n rounds have passed.
	
	a_table = table::load( "gamedata/tables/zm/zm_zod_pods.csv", "ScriptID" );
	level.pods.rewards = [];
	level.pods.rewards[1] = [];
	level.pods.rewards[2] = [];
	level.pods.rewards[3] = [];
	
	level.pods.bonus_points_amount = 100; // temp default value to be overridden.
	level.bonus_points_powerup_override = &pod_bonus_points_override;
	
	/#
		level.pods.debug_reward_list = [];
	#/
		
	wpn_none = GetWeapon( "none" );
	
	a_keys = GetArrayKeys( a_table );
	for ( i = 0; i < a_keys.size; i++ )
	{
		str_key = a_keys[i];
		s_reward = SpawnStruct();
		s_reward.reward_level = a_table[str_key]["Level"];
		s_reward.type = a_table[str_key]["Type"];
		if ( s_reward.type == "weapon" )
		{
			s_reward.item = GetWeapon( a_table[str_key]["Item"] );
			if ( s_reward.item == wpn_none )
			{
				/# AssertMsg( "Unknown weapon (" + a_table[str_key]["Item"] + ") in zm_zod_pods.csv." ); #/
				continue;
			}
		}
		else
		{
			s_reward.item = a_table[str_key]["Item"];
		}
		s_reward.count = a_table[str_key]["Count"];
		s_reward.chance = a_table[str_key]["Weight"];
		if ( !isdefined( level.pods.rewards[s_reward.reward_level] ) ) level.pods.rewards[s_reward.reward_level] = []; else if ( !IsArray( level.pods.rewards[s_reward.reward_level] ) ) level.pods.rewards[s_reward.reward_level] = array( level.pods.rewards[s_reward.reward_level] ); level.pods.rewards[s_reward.reward_level][level.pods.rewards[s_reward.reward_level].size]=s_reward;;
		
		// Debug scripts need to reference reward list by ID.
		/#
			level.pods.debug_reward_list[str_key] = s_reward;
		#/
	}
	
	// Normalize the odds to add up to 100 for each reward level.
	normalize_reward_chances();

	level flag::init( "any_player_has_pod_sprayer" );
	
	/#
		level thread pods_devgui();
	#/
}

function __main__()
{
	level.pods.unspawned = struct::get_array( "pod_location", "targetname" );
	level.pods.spawned = [];
	foreach( s_pod in level.pods.unspawned )
	{
		s_pod.pod_level = 0;
	}
	
	// Sprayers are grouped by script_int
	level.pods.sprayers = [];
	a_sprayers = struct::get_array( "pod_sprayer_location", "targetname" );
	a_sprayers = array::randomize( a_sprayers );
	
	a_chosen = [];
	foreach( s_sprayer in a_sprayers )
	{
		if ( isdefined( a_chosen[ s_sprayer.script_int ] ) )
		{
			continue;
		}
		
		a_chosen[ s_sprayer.script_int ] = s_sprayer;
	}
	
	foreach ( s_sprayer in a_chosen )
	{
		s_sprayer thread pod_sprayer_think();
	}
	
	level thread respawn_pods();
}

/#
function pods_devgui()
{
	SetDvar( "pod_devgui_command", "" );
	SetDvar( "pod_force_spawn", "" );
	
	AddDebugCommand( "devgui_cmd \"ZM/Zod/Pods/Spawn & Mature\" \"pod_devgui_command spawn_more\"\n" );
	AddDebugCommand( "devgui_cmd \"ZM/Zod/Pods/Spawn & Mature All\" \"pod_devgui_command spawn_all\"\n" );
	
	a_keys = GetArrayKeys( level.pods.debug_reward_list );
	for ( i = 0; i < a_keys.size; i++ )
	{
		str_id = a_keys[i];
		AddDebugCommand( "devgui_cmd \"ZM/Zod/Pods/Force Spawn/" + str_id + "\" \"pod_force_spawn " + str_id + "\"\n" );
	}
	
	s_sword_rock = struct::get( "initial_egg_statue", "script_noteworthy" );
	
	while ( true )
	{
		cmd = GetDvarString( "pod_devgui_command" );
		if ( cmd != "")
		{
			switch ( cmd )
			{
				case "spawn_more":
					level notify( "debug_pod_spawn" );
					break;
				case "spawn_all":
					level.debug_pod_spawn_all = true;
					level notify( "debug_pod_spawn" );
					util::wait_network_frame();
					level.debug_pod_spawn_all = false;
					break;
				default:
					break;
			}
			
			SetDvar( "pod_devgui_command", "" );
		}
		util::wait_network_frame();
	}
}
#/
	
function private pod_sprayer_pickup_msg( e_player )
{
	if ( ( isdefined( e_player.has_pod_spray ) && e_player.has_pod_spray ) )
	{
		return &"";
	}
	else
	{
		return &"ZM_ZOD_X_TO_PICK_UP";
	}
}
	
function private pod_sprayer_think()
{
	while ( true )
	{
		self.model = util::spawn_model( "p7_zm_zod_bug_sprayer", self.origin, self.angles );
		PlayFxOnTag( level._effect[ "memento_glow" ], self.model, "tag_origin" );
		self.trigger = zm_zod_util::spawn_trigger_radius( self.origin, 50, true, &pod_sprayer_pickup_msg );
		
		while ( true )
		{
			self.trigger waittill( "trigger", e_who );
			if ( ( isdefined( e_who.has_pod_spray ) && e_who.has_pod_spray ) )
			{
				continue;
			}
			
			e_who.has_pod_spray = true;
			e_who SetLUIMenuData( e_who.zod_inventory_hud, "pod_sprayer", 1 );
			self.model Delete();
			zm_unitrigger::unregister_unitrigger( self.trigger );
			self.trigger = undefined;
			level flag::set( "any_player_has_pod_sprayer" );
			break;
		}
		
		// Wait for this person to disconnect, then respawn their sprayer where it originally was.
		e_who waittill( "disconnect" );
	}
}

// self == pod struct
//
function private pod_think()
{
	self thread pod_upgrade_think();
	
	while ( true )
	{
		self.trigger waittill( "trigger", e_who );
		
		assert( self.pod_level > 0 );
		
		if ( !( isdefined( e_who.has_pod_spray ) && e_who.has_pod_spray ) )
		{
			continue;
		}
		
		self harvest_pod( e_who );
		return;
	}
}

// self == pod struct
//
function private pod_upgrade()
{
	if ( self.pod_level < 3 )
	{
		self.pod_level++;
		self.model clientfield::set( "pod_level", self.pod_level );
	}
}

// self == pod struct
//
function private pod_upgrade_think()
{
	self endon( "harvested" );
	
	rounds_since_upgrade = 0;
	
	// Pods don't upgrade until their zones have been opened.
	if ( isdefined( self.zone ) )
	{
		while ( !zm_zonemgr::zone_is_enabled( self.zone ) )
		{
			wait 1.0;
		}
	}
	
	while ( true )
	{
		level util::waittill_any( "between_round_over", "debug_pod_spawn" );
		rounds_since_upgrade++;
		
		n_upgrade_odds = level.pods.upgrade_odds[rounds_since_upgrade];
		if ( !isdefined( n_upgrade_odds ) )
		{
			n_upgrade_odds = 1.0;
		}
		else if ( ( isdefined( level.debug_pod_spawn_all ) && level.debug_pod_spawn_all ) )
		{
			n_upgrade_odds = 1.0;
		}
		else if ( n_upgrade_odds == 0 )
		{
			continue;
		}
		
		if ( RandomFloat( 1.0 ) <= n_upgrade_odds )
		{
			self pod_upgrade();
			rounds_since_upgrade = 0;
			
			// No next level?
			if ( self.pod_level >= 3 )
			{
				return;
			}
		}
	}
}

// Respawns a number of pods starting at round FIRST_POD_SPAWN_ROUND or whenever
// a player first picks up a pod sprayer.
//
function private respawn_pods()
{
	level flag::wait_till( "start_zombie_round_logic" );
	for ( i = 0; i < level.pods.unspawned.size; i++ )
	{
		pod = level.pods.unspawned[i];
		pod.zone = zm_zonemgr::get_zone_from_position( pod.origin + (0,0,20), true );
		if ( !isdefined( pod.zone ) )
		{
			/#
				println( "WARNING: Pod at " + zm_zod_util::vec_to_string( pod.origin ) + " is not within a valid zone.  Removing from pod list." );
			#/
			ArrayRemoveValue( level.pods.unspawned, pod );
		}
	}
	
	// Spawn the initial set of pods.
	n_pods = Int( 0.4 * level.pods.unspawned.size );
	spawn_pods( n_pods );
	
	while ( true )
	{
		level util::waittill_any( "between_round_over", "debug_pod_spawn" );
		if ( level.round_number < 4 && !level flag::get( "any_player_has_pod_sprayer" ) && !( isdefined( level.debug_pod_spawn_all ) && level.debug_pod_spawn_all ) )
		{
			continue;
		}
		
		n_pods = RandomIntRange( 3, 5+1 );
		
		if ( ( isdefined( level.debug_pod_spawn_all ) && level.debug_pod_spawn_all ) )
		{
			n_pods = 1000;
		}
		
		spawn_pods( n_pods );
	}
}

// self == pod struct
function harvest_pod( e_harvester )
{
	const WASP_VERTICAL_OFFSET = 30;
	self.model clientfield::set( "pod_harvest", 0 );
	self.model clientfield::set( "pod_harvest", 1 );
	wait 0.10;

	self.model Delete();
	self.harvested_in_round = level.round_number;
	zm_unitrigger::unregister_unitrigger( self.trigger );
	self.trigger = undefined; // free the struct
	
	n_roll = RandomInt( 100 );
	n_cumulation = 0;
	foreach( s_reward in level.pods.rewards[self.pod_level] )
	{
		/#
		str_forced = GetDvarString( "pod_force_spawn" );
		if ( isdefined( str_forced ) && str_forced != "" )
		{
			s_reward_forced = true;
			s_reward = level.pods.debug_reward_list[str_forced];
			SetDvar( "pod_force_spawn", "" );
		}
		#/

		// reward may need to be ignored by the selection process in certain situations (ex: don't want multiples of a single object to be rolled if the single object is already in-world, but will return to the rotation if not picked up)
		if( ( isdefined( s_reward.do_not_consider ) && s_reward.do_not_consider ) )
		{
			continue;
		}

		n_cumulation += s_reward.chance;
		if ( n_cumulation >= n_roll || ( isdefined( s_reward_forced ) && s_reward_forced ) )
		{
			switch( s_reward.type )
			{
				case "craftable":
					// immediately set the drop chance to zero, so we only have to deal with one possible idgun craftable being dropped in the world at a time
					// then, renormalize the odds after taking the L[1-3] craftable reward out of the pods
					s_reward.do_not_consider = true;
					normalize_reward_chances();
					
					// randomly pick one of the three craftables, and present it to the player
					s_temp = SpawnStruct();
					point =  self.origin;
					s_temp.origin = point + (0,0,30);
					zm_zod_idgun_quest::special_craftable_spawn( s_temp );
					
					// restore the previous odds, if we haven't collected all the parts yet (includes the case where the last part was spawned, but player didn't pick it up and it vanished)
					if( level flag::get( "part_heart" + "_found" ) && level flag::get( "part_xenomatter" + "_found" ) && level flag::get( "part_skeleton" + "_found" ) )
					{
						break;
					}
					else // restore to previous odds
					{
						s_reward.do_not_consider = false;
						normalize_reward_chances();
					}
					
					break;
					
				case "parasite":
					s_temp = SpawnStruct();
					point =  self.origin;
					s_temp.origin = point + (0,0,30);
					zm_ai_wasp::special_wasp_spawn( s_temp, 1, 32, 32 );
					break;
					
				case "powerup":
					str_item = s_reward.item;
					if ( !isdefined( str_item ) )
					{
						str_item = zm_powerups::get_valid_powerup();
					}
					
					if ( isdefined( s_reward.count ) && str_item == "bonus_points_team" )
					{
						level.pods.bonus_points_amount = s_reward.count;
					}
					
					zm_powerups::specific_powerup_drop( str_item, self.origin, undefined, undefined, 1.0 );
					break;
					
				case "weapon":
					self thread dig_up_weapon( e_harvester, s_reward.item );
					break;
					
				case "zombie":
					s_temp = SpawnStruct();
					s_temp.origin = GetClosestPointOnNavMesh( self.origin, 20.0 );
					if ( !isdefined( s_temp.origin ) )
					{
						s_temp.origin = self.origin;
					}
					s_temp.script_noteworthy = "riser_location";
					s_temp.script_string = "find_flesh";
					zombie_utility::spawn_zombie( level.zombie_spawners[0], "aether_zombie", s_temp  );
					break;
					
				default:
					break;
			}
			break;
		}
	}

	self notify( "harvested", e_harvester );
	
	// Move it back into the pool of unspawned pods.
	ArrayRemoveValue( level.pods.spawned, self );
	if ( !isdefined( level.pods.unspawned ) ) level.pods.unspawned = []; else if ( !IsArray( level.pods.unspawned ) ) level.pods.unspawned = array( level.pods.unspawned ); level.pods.unspawned[level.pods.unspawned.size]=self;;
}


function pod_player_msg( e_player )
{
	if ( ( isdefined( e_player.has_pod_spray ) && e_player.has_pod_spray ) )
	{
		return &"ZM_ZOD_POD_HARVEST";
	}
	else
	{
		return &"";
	}
}

// Choose up to N pod locations and spawn new pods there.
//
function spawn_pods( n_pods )
{
	a_available = [];
	foreach( pod in level.pods.unspawned )
	{
		// Exclude pods that were harvested too recently.
		if ( isdefined( pod.harvested_in_round ) )
		{
			n_rounds_since_spawn = level.round_number - pod.harvested_in_round;
			if ( n_rounds_since_spawn < 2 && !( isdefined( level.debug_pod_spawn_all ) && level.debug_pod_spawn_all ) )
			{
				continue;
			}
		}
		
		if ( !isdefined( a_available ) ) a_available = []; else if ( !IsArray( a_available ) ) a_available = array( a_available ); a_available[a_available.size]=pod;;
	}
	
	a_available = array::randomize( a_available );
	a_spawned_zones = [];
	
	// Grab the first n off the top and spawn them.
	for ( i = 0; i < n_pods && a_available.size > 0; i++ )
	{
		n_index = a_available.size-1;
		s_pod = a_available[n_index];
		
		// If we're only spawning a handful of these, then only spawn one per zone per round.
		if ( n_pods <= 5 && isdefined( s_pod.zone ) && isdefined( a_spawned_zones[ s_pod.zone] ) )
		{
			continue;
		}
		
		ArrayRemoveValue( level.pods.unspawned, s_pod );
		ArrayRemoveIndex( a_available, n_index );
		if ( !isdefined( level.pods.spawned ) ) level.pods.spawned = []; else if ( !IsArray( level.pods.spawned ) ) level.pods.spawned = array( level.pods.spawned ); level.pods.spawned[level.pods.spawned.size]=s_pod;;
		
		s_pod.pod_level = 1;
		s_pod.model = util::spawn_model( "tag_origin", s_pod.origin, s_pod.angles );
		s_pod.model clientfield::set( "pod_level", s_pod.pod_level );
		
		s_pod.trigger = zm_zod_util::spawn_trigger_radius( s_pod.origin + (AnglesToUp( s_pod.angles ) * 8), 50, true, &pod_player_msg );
		s_pod thread pod_think();
		
		if ( isdefined( s_pod.zone ) )
		{
			if(!isdefined(a_spawned_zones[ s_pod.zone ]))a_spawned_zones[ s_pod.zone ]=0;
			a_spawned_zones[ s_pod.zone ]++;
		}
	}
}

function weapon_trigger_update_prompt( player )
{
	self setCursorHint( "HINT_WEAPON", self.stub.wpn ); 
	self SetHintString( &"ZOMBIE_TRADE_WEAPON_FILL" );
	return true;
}

//spawns random primary weapon
function dig_up_weapon( e_digger, wpn_to_spawn )  //self = pod struct
{
	const FLOAT_HEIGHT = 40;
	
	v_spawnpt = self.origin + ( 0, 0, FLOAT_HEIGHT );
	v_spawnang = ( 0, 0, 0 );

	v_angles = e_digger GetPlayerAngles();
	v_angles = (0, v_angles[1], 0) + ( 0, 90, 0 ) + v_spawnang;
		
	//create the model
	m_weapon = zm_utility::spawn_weapon_model( wpn_to_spawn, undefined, v_spawnpt, v_angles );
	
	m_weapon.angles = v_angles;
	m_weapon thread timer_til_despawn( v_spawnpt, -FLOAT_HEIGHT );
	m_weapon endon( "dig_up_weapon_timed_out" );
		
	//add a glow to the spawned weapon
//	PlayFXOnTag( level._effect["special_glow"], m_weapon, "tag_origin" );
		
	m_weapon.trigger = zm_zod_util::spawn_trigger_radius( v_spawnpt, 100, true );
	m_weapon.trigger.wpn = wpn_to_spawn;
	m_weapon.trigger.prompt_and_visibility_func = &weapon_trigger_update_prompt;
	
	m_weapon.trigger waittill( "trigger", player );
	m_weapon.trigger notify( "weapon_grabbed" );
	m_weapon.trigger thread swap_weapon( wpn_to_spawn, player );
	
	if ( IsDefined( m_weapon.trigger ) )
	{
		zm_unitrigger::unregister_unitrigger( m_weapon.trigger );
		m_weapon.trigger = undefined;
	}

	if ( IsDefined( m_weapon ) )
	{
		m_weapon Delete();
	}
	
	if ( player != e_digger )
	{
		e_digger notify( "dig_up_weapon_shared" );
	}
}

function swap_weapon( wpn_new, e_player )
{
	wpn_current = e_player GetCurrentWeapon();	
	
	if ( !zm_utility::is_player_valid( e_player ) )
	{
		return;
	}
	
	if ( ( e_player.is_drinking > 0 ) )
	{
		return;
	}
	
	//only attempt to give them the new weapon if all conditions are met
	if ( zm_utility::is_placeable_mine( wpn_current ) || zm_equipment::is_equipment( wpn_current ) || wpn_current == level.weaponNone )
	{
		return;
	}

	if ( !e_player HasWeapon( wpn_new ) )
	{
		e_player take_old_weapon_and_give_new( wpn_current, wpn_new );
	}
	else 
	{
		e_player GiveMaxAmmo( wpn_new );
	}
}

function take_old_weapon_and_give_new( current_weapon, weapon ) // self = player
{
	a_weapons = self GetWeaponsListPrimaries();
		
	if ( IsDefined( a_weapons ) && a_weapons.size >= zm_utility::get_player_weapon_limit( self ) )
	{
		self TakeWeapon( current_weapon );
	}
	
	self GiveWeapon( weapon );
	self SwitchToWeapon( weapon );
}

//weapon times out if not picked up within time limit
function timer_til_despawn( v_float, n_dist )  //self = weapon trigger
{
	self endon( "weapon_grabbed" );
	
	putBackTime = 12;
	
	self MoveZ( n_dist, putBackTime, ( putBackTime * 0.5 ) );
	self waittill( "movedone" );

	self notify( "dig_up_weapon_timed_out" );

	if ( IsDefined( self.trigger ) )
	{
		zm_unitrigger::unregister_unitrigger( self.trigger );
		self.trigger = undefined;
	}

	if ( IsDefined( self ) )
	{	
		self Delete();
	}
}

function pod_bonus_points_override()
{
	return level.pods.bonus_points_amount;
}

// Normalize the odds to add up to 100 for each reward level.
function normalize_reward_chances()
{
	for ( i = 1; i <= 3; i++ )
	{
		n_total = 0.0;
		foreach( reward in level.pods.rewards[i] )
		{
			if( !( isdefined( reward.do_not_consider ) && reward.do_not_consider ) ) // reward may need to be ignored by the selection process in certain situations (ex: don't want multiples of a single object to be rolled if the single object is already in-world, but will return to the rotation if not picked up)
			{
				n_total += Float(reward.chance);
			}
		}
		
		assert( reward.chance > 0 );
		foreach( reward in level.pods.rewards[i] )
		{
			if( !( isdefined( reward.do_not_consider ) && reward.do_not_consider ) )
			{
				reward.chance = (reward.chance / n_total) * 100;
			}
		}
	}
}
