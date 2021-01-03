    	   	                                                                                                                         	                                                                                                                                                                                                                                                                                                                                                                    	        	     	             	    	   	                           	                               	                                	                                                              	                                                                                                              	                            	                                     	                                       	                                                               	   	                  	       	                                                    	                   	                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                       	                                                                                        	           	                        	                                            	                                             	                                                   	                                                             	                                                         	                                                                    	                                                                                                                                                                                                    	                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                     	                                                              	                                                          	                                   	                                   	                                                    	                                       
                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                            	                                                                                                                                                                                                                                                                                                                                                                                       
                                                                                                                               
                                                                                                                                                                                                                                                                                                                                                                                                                 	                                                                                                                                                                          	                                                                                         	                                                                                                                                                                                                                                                                                                                                                                                                                                        	                                                                                                                               	                                                                                                                                                                                                                                              	                                                                                                                                           	                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                   	                                                                                                                       	   	                                                                                                                                                                                                                                                                                                                         	                                                                                                                                                                                                                                      
                                                                                                                                                                                                                                                                                                    	                                                                                     	                                                                                                                                                                                                                                                                                             	                                                                                                                                                                                                                                                                                                                                                                                                   	                                                                                                                                                                                                                                                                                                         	                                                   

#using scripts\codescripts\struct;

#using scripts\shared\array_shared;
#using scripts\shared\callbacks_shared;
#using scripts\shared\clientfield_shared;
#using scripts\shared\exploder_shared;
#using scripts\shared\flag_shared;
#using scripts\shared\laststand_shared;
#using scripts\shared\system_shared;
#using scripts\shared\util_shared;
#using scripts\shared\vehicle_ai_shared;

#using scripts\shared\ai\zombie_utility;

#using scripts\zm\_zm;
#using scripts\zm\_zm_ai_raps;
#using scripts\zm\_zm_audio;
#using scripts\zm\_zm_equipment;
#using scripts\zm\_zm_laststand;
#using scripts\zm\_zm_score;
#using scripts\zm\_zm_spawner;
#using scripts\zm\_zm_timer;
#using scripts\zm\_zm_unitrigger;
#using scripts\zm\_zm_utility;
#using scripts\zm\_zm_weapons;
#using scripts\zm\craftables\_zm_craftables;

#using scripts\zm\zm_zod_smashables;
#using scripts\zm\zm_zod_util;

#namespace zm_zod_idgun_quest;




#precache( "triggerstring", "ZM_ZOD_IDGUN_PART_SKELETON" );
#precache( "triggerstring", "ZM_ZOD_IDGUN_PART_XENOMATTER" );
#precache( "triggerstring", "ZM_ZOD_IDGUN_PART_HEART" );
	
function autoexec __init__sytem__() {     system::register("zm_zod_idgun_quest",&__init__,&__main__,undefined);    }
	
function __init__()
{	
	callback::on_connect( &on_player_connect );
	
	// idguns stored in the magic box
	clientfield::register( "world", "idguns_in_box",		1, 2,		"int" );
	
	// idgun progression
	n_bits = GetMinBitCountForNum( 4 );
	clientfield::register( "world", "idgun_0_quest_loc",		1, n_bits,	"int" );
	clientfield::register( "world", "idgun_1_quest_loc",		1, n_bits,	"int" );
	n_bits = GetMinBitCountForNum( 6 );
	clientfield::register( "world", "idgun_0_quest_state",		1, n_bits,	"int" );
	clientfield::register( "world", "idgun_1_quest_state",		1, n_bits,	"int" );
	
	/#
		level thread idgun_devgui();
		level thread idgun_quest_devgui();
	#/
}

function __main__()
{
	// setup basic stuff
	a_str_idgun_wpnnames = array( "idgun_0", "idgun_1", "idgun_2", "idgun_3" );
	
	//TODO Sabarish: Move this stuff into _zm_weap_idgun when the file gets checked in
	level vehicle_ai::register_custom_add_state_callback( &idgun_add_vehicle_death_state );
	level zm::register_vehicle_damage_callback( &idgun_apply_vehicle_damage );
	//create an array of all possible idgun weapons for checking against
	level construct_idgun_weapon_array();

	// create a callback for tracking the number of kills that the idgun gets	
	zm_spawner::register_zombie_death_event_callback( &idgun_zombie_death_watch );
	
	for( i = 0; i < 2; i++ )
	{
		level.idgun[ i ] = SpawnStruct();
		level.idgun[ i ].kill_count = 0;
		level.idgun[ i ].n_gun_index = i;
		level.idgun[ i ].state = 0; // ID Guns start in the base state
		
		// determine which of the uniquely identified Alien Guns this one is
		a_str_idgun_wpnnames = array::randomize( a_str_idgun_wpnnames ); // randomize the remaining array of possible guns
		level.idgun[ i ].str_wpnname = array::pop_front( a_str_idgun_wpnnames ); // draw a gun
		
		// init a flag for each quest progression state of each gun
		for( j = 0; j < 6; j++ )
		{
			level flag::init( "idgun_" + i + "_state_" + j );
		}
	}
	
	// TODO: take out debug player test
	// FOR TESTING PURPOSES ONLY
	players = GetPlayers();
	level.idgun[ 0 ].owner = players[0];
	// END OF TEST SECTION
	
	wait 0.5; // wait command, so we can set clientfields after this
	
	// ID Gun Crafting
	level thread idgun_crafting_watcher();
	
	// ID Gun Pickup thread
	//level thread idgun_pickup_watcher();
	
	// ID Gun Upgrade Quest
	level thread setup_idgun_upgrade_quest(); // watch the quest
}

function construct_idgun_weapon_array()
{
	level.idgun_weapons = [];
	
	level.idgun_weapons[level.idgun_weapons.size] = GetWeapon( "idgun_0" );
	level.idgun_weapons[level.idgun_weapons.size] = GetWeapon( "idgun_1" );
	level.idgun_weapons[level.idgun_weapons.size] = GetWeapon( "idgun_2" );
	level.idgun_weapons[level.idgun_weapons.size] = GetWeapon( "idgun_3" );
	
	level.idgun_weapons[level.idgun_weapons.size] = GetWeapon( "idgun_upgraded_0" );
	level.idgun_weapons[level.idgun_weapons.size] = GetWeapon( "idgun_upgraded_1" );
	level.idgun_weapons[level.idgun_weapons.size] = GetWeapon( "idgun_upgraded_2" );
	level.idgun_weapons[level.idgun_weapons.size] = GetWeapon( "idgun_upgraded_3" );
	
	level.idgun_weapons[level.idgun_weapons.size] = GetWeapon( "idgun2_0" );
	level.idgun_weapons[level.idgun_weapons.size] = GetWeapon( "idgun2_1" );
	level.idgun_weapons[level.idgun_weapons.size] = GetWeapon( "idgun2_2" );
	level.idgun_weapons[level.idgun_weapons.size] = GetWeapon( "idgun2_3" );
	

	level.idgun_weapons[level.idgun_weapons.size] = GetWeapon( "idgun2_upgraded_0" );
	level.idgun_weapons[level.idgun_weapons.size] = GetWeapon( "idgun2_upgraded_1" );
	level.idgun_weapons[level.idgun_weapons.size] = GetWeapon( "idgun2_upgraded_2" );
	level.idgun_weapons[level.idgun_weapons.size] = GetWeapon( "idgun2_upgraded_3" );
}

function on_player_connect()
{
}





function special_craftable_spawn( s_loc )
{
	level endon( "idgun_part_found" );
	
	a_parts = [];

	// add the craftables that we haven't gotten yet
	if( !( level flag::get( "part_heart" + "_found" ) ) )
	{
		if ( !isdefined( a_parts ) ) a_parts = []; else if ( !IsArray( a_parts ) ) a_parts = array( a_parts ); a_parts[a_parts.size]="part_heart";;
	}
	if( !( level flag::get( "part_skeleton" + "_found" ) ) )
	{
		if ( !isdefined( a_parts ) ) a_parts = []; else if ( !IsArray( a_parts ) ) a_parts = array( a_parts ); a_parts[a_parts.size]="part_skeleton";;
	}
	if( !( level flag::get( "part_xenomatter" + "_found" ) ) )
	{
		if ( !isdefined( a_parts ) ) a_parts = []; else if ( !IsArray( a_parts ) ) a_parts = array( a_parts ); a_parts[a_parts.size]="part_xenomatter";;
	}

	// randomly pick one of the remaining craftable parts
	str_part = array::random( a_parts );
	
	mdl_part = level zm_craftables::get_craftable_piece_model( "idgun", str_part ); // replaced with the formula we use for the DEFINEs for simplicity
	
	mdl_part.origin = s_loc.origin; // warp the piece
	mdl_part SetVisibleToAll(); // show the piece
	
	wait 10;

	level thread idgun_part_blinks( mdl_part ); // blink to show that the piece is about to disappear
	
	wait 10;
	
	mdl_part SetInvisibleToAll(); // hide the piece
	
	level notify( "idgun_part_blinks" ); // kill the blink thread
}

function idgun_part_blinks( mdl_part )
{
	level notify( "idgun_part_blinks" );
	level endon( "idgun_part_blinks" );
	level endon( "idgun_part_found" ); // kill this immediately if the piece is picked up
	
	while( true )
	{
		mdl_part SetInvisibleToAll();
		wait 0.5;
		mdl_part SetVisibleToAll();
		wait 0.5;
	}
}

// this thread watches to see if the players have gathered all 3 parts
// if they have, it will ensure that the next weapon out of the box is the ID Gun
function idgun_crafting_watcher()
{
	// all three parts
	a_flags = array( "part_heart" + "_found", "part_xenomatter" + "_found", "part_skeleton" + "_found" );
	level flag::wait_till_all( a_flags );

	// add the idgun to the box rotation on client
	clientfield::set( "idguns_in_box", 1 );
	// add the idgun to the server's list of box weapons
	
	weapon_idgun = GetWeapon( level.idgun[ 0 ].str_wpnname ); // add the first IDGun to the box
	level.zombie_weapons[ weapon_idgun ].is_in_box = true;
}

/*
function idgun_pickup_watcher()
{
	self endon("death");
	self endon("disconnect");

	weapon_idgun = GetWeapon( ZOD_IDGUN_WEAPON );
	
	while( true )
	{
		self waittill( "weapon_change_complete", weapon );
		
		if( weapon === weapon_idgun )
		{
			
		}
	}
}
*/

//
// UPGRADE QUEST
//




// idgun upgrade quest passes in the player who has picked up the idgun
// that player must get IDGUN_UPGRADE_QUEST_KILL_COUNT kills using the idgun
// kills may be added across multiple times carrying the same idgun (if the player has dropped it from dying/respawning but then picks the same idgun out of the box)

// s_idgun - the struct for this idgun (struct contains the idgun's identity and memory, as well as its current and previous player "owners")
function idgun_vo( s_idgun )
{
	if( ( isdefined( s_idgun.is_speaking ) && s_idgun.is_speaking ) )
	{
		return;
	}
}

function idgun_zombie_death_watch()
{
	foreach( wpn in level.idgun_weapons )
	{
		if ( ( self.damageweapon === wpn ) )
		{
			idgun = get_idgun_from_owner( self.attacker );
			
			// increment kill counter
			idgun.kill_count++;

			// watch kill count for the upgrade quest
			if( idgun.state != 0 )
			{
				return;
			}
			
			// descending order
			if( idgun.kill_count > 40 )
			{
				// upgrade now!
				idgun.state = 1;
				level clientfield::set( "idgun_" + idgun.n_gun_index + "_quest_state", 1 );
				level flag::set( "idgun_" + idgun.n_gun_index + "_state_" + 1 );
				// TODO: play VO - won't be called twice, because the gun state advances
			}
			else if( ( idgun.kill_count > 30 ) && !( isdefined( idgun.upgrade_near_vo_played ) && idgun.upgrade_near_vo_played ) )
			{
				// TODO: play near upgrade-time VO
				idgun.upgrade_near_vo_played = true;
			}
		}
	}
}

// returns the level struct that contains all the persistent idgun information (lasts across weapon being returned to box and picked out again)
function get_idgun_from_owner( player )
{
	for( i = 0; i < 2; i++ )
	{
		if( level.idgun[ i ].owner === player )
		{
			return level.idgun[ i ];
		}
	}
}

function setup_idgun_upgrade_quest()
{
	// initial setup for points in the map
	setup_idgun_upgrade_points();
	
	// watch each gun
	for( i = 0; i < 2; i++ )
	{
		level thread idgun_instance_watcher( i );
	}
}

// select an upgrade point and set clientfield to start a thread on the client for the metal detector behavior
function setup_idgun_upgrade_points()
{
	a_s_upgrade_points = struct::get_array( "idgun_upgrade_point", "targetname" );

	// pick nonindentical upgrade points for the idguns in the map; assign them to the idguns' level structs as .s_upgradepoint
	for( i = 0; i < 2; i++ )
	{
		a_s_upgrade_points = array::randomize( a_s_upgrade_points ); // randomize the remaining array of possible upgrade points
		level.idgun[ i ].s_upgrade_point = array::pop_front( a_s_upgrade_points ); // draw a point
		level clientfield::set( "idgun_" + i + "_quest_loc", level.idgun[ i ].s_upgrade_point.script_int ); // communicate which struct was chosen to the client
		wait 5; // give the client stuff time to generate
		create_idgun_cocoon_unitrigger( level.idgun[ i ].s_upgrade_point, i ); // generate unitrigger (prompt won't show unless it's time to cocoon or harvest an ID Gun)
	}
}

function idgun_instance_watcher( n_gun_index )
{
	// 1 - READY TO UPGRADE
	level flag::wait_till( "idgun_" + n_gun_index + "_state_" + 1 ); // this flag gets set in the damage callback when the weapon has gotten enough kills

	// set clientfield, start the proximity sensor gameplay mechanic
	level clientfield::set( "idgun_" + n_gun_index + "_quest_state", 1 );
	if( isdefined( level.idgun[ n_gun_index ].owner ) )
	{
		level.idgun[ n_gun_index ].owner thread idgun_proximity_sensor( n_gun_index );
	}

	// 2 - COCOONED
	level flag::wait_till( "idgun_" + n_gun_index + "_state_" + 2 );
	
	// 3 - READY TO HATCH; gets set when the round progresses
	level waittill( "between_round_over" );
	set_idgun_quest_state( n_gun_index, 3 );
	
	// 4 - HATCHED
	level flag::wait_till( "idgun_" + n_gun_index + "_state_" + 4 );
	
	// 5 - UPGRADED
	level flag::wait_till( "idgun_" + n_gun_index + "_state_" + 5 );
}

// max distance at which the player holding the ID Gun gets detector pulses

// distance at which the player holding the ID Gun gets detector pulses

// max delay at which the detector pulses fire (scaled from player's proximity measured against the range)

// min delay at which the detector pulses fire (scaled from player's proximity measured against the range)


// self = player carrying the idgun
function idgun_proximity_sensor( n_gun_index )
{
	self endon( "bleed_out" );
	self endon( "death" );
	self endon( "disconnect" );
	
	// precalculations
	n_proximity_max_2 = 1024 * 1024;
	n_proximity_min_2 = 64 * 64;
	n_proximity_diff_2 = n_proximity_max_2 - n_proximity_min_2;
	n_pulse_delay_range = 1.0 - 0.25;
	// working vars
	n_scaled_pulse_delay = undefined;
	n_time_before_next_pulse = undefined;
	
	while( true )
	{
		n_dist_2 = DistanceSquared( self.origin, level.idgun[ n_gun_index ].s_upgrade_point.origin );
		
		// are we near enough to the upgrade point to get a pulse?
		if( n_dist_2 <= n_proximity_max_2 )
		{
			if( n_dist_2 <= n_proximity_min_2 )
			{
				n_time_before_next_pulse = 0.25;
			}
			else // not linear scaling, but should read fine for metal-detector style gameplay
			{
				n_scalable_dist_2 = n_dist_2 - n_proximity_min_2; // get the scalable square of the distance
				n_scale = n_scalable_dist_2 / n_proximity_diff_2; // get the scale [0-1] by dividing the adjusted distance by the difference in proximities
				n_scaled_pulse_delay = n_scale * n_pulse_delay_range; // get the scaled portion of the pulse delay by multiplying the scale mod by the range between the min and max pulse delays
				n_time_before_next_pulse = 0.25 + n_scaled_pulse_delay; // add the scaled portion of the pulse delay to the minimum value to get the actual pulse delay
			}
		}
		else
		{
			n_time_before_next_pulse = undefined; // use the definedness of n_time_before_next_pulse to decide if we should be firing a pulse or not
		}
		
		// end func if the player successfully cocoons the gun
		if( level flag::get( "idgun_" + n_gun_index + "_state_" + 2 ) )
		{
			return;
		}
		
		// wait whatever the pulse time is, fire a pulse (if necessary), then loop to check again
		if( isdefined( n_time_before_next_pulse ) ) // n_time_before_next_pulse is only defined when the player is within the max detection range
		{
			wait n_time_before_next_pulse;
			
			zm_zod_util::set_rumble_to_player( 1 );
			util::wait_network_frame();
			zm_zod_util::set_rumble_to_player( 0 );
		}
		else
		{
			wait 1.0; // default wait when outside the detector range
		}
	}
}

function create_idgun_cocoon_unitrigger( s_loc, n_gun_index )
{
	width = 128;
	height = 128;
	length = 128;

	s_loc.unitrigger_stub = spawnstruct();
	s_loc.unitrigger_stub.origin = s_loc.origin;
	s_loc.unitrigger_stub.angles = s_loc.angles;
	s_loc.unitrigger_stub.script_unitrigger_type = "unitrigger_box_use";
	s_loc.unitrigger_stub.cursor_hint = "HINT_NOICON";
	s_loc.unitrigger_stub.script_width = width;
	s_loc.unitrigger_stub.script_height = height;
	s_loc.unitrigger_stub.script_length = length;
	s_loc.unitrigger_stub.require_look_at = false;
	s_loc.unitrigger_stub.n_gun_index = n_gun_index;
	
	s_loc.unitrigger_stub.prompt_and_visibility_func = &idgun_cocoon_trigger_visibility;
	zm_unitrigger::register_static_unitrigger( s_loc.unitrigger_stub, &idgun_cocoon_trigger_think );
}
	
// self = unitrigger
function idgun_cocoon_trigger_visibility( player )
{
	n_gun_index = self.stub.n_gun_index;
	
	// is the quest in the right state?
	n_quest_state = level clientfield::get( "idgun_" + n_gun_index + "_quest_state" );
	switch( n_quest_state )
	{
		case 1:
			self SetHintString( &"ZM_ZOD_IDGUN_READY_TO_UPGRADE" );
			b_is_not_right_quest_stage = false;
			break;
		case 3:
			self SetHintString( &"ZM_ZOD_IDGUN_READY_TO_HATCH" );
			b_is_not_right_quest_stage = false;
			break;
		case 4:
			self SetHintString( &"ZM_ZOD_IDGUN_HATCHED" );
			b_is_not_right_quest_stage = false;
			break;
		default:
			b_is_not_right_quest_stage = true;
			break;
	}

	// is this the right player?
	b_is_not_right_player = true;
	if( player === level.idgun[ n_gun_index ].owner )
	{
		b_is_not_right_player = false;
	}
	
	// visibility
	b_is_invis = ( isdefined( player.beastmode ) && player.beastmode ) || b_is_not_right_quest_stage || b_is_not_right_player;
	self setInvisibleToPlayer( player, b_is_invis );
	
	return !b_is_invis;
}

// self = unitrigger
function idgun_cocoon_trigger_think()
{
	while( true )
	{
		self waittill( "trigger", player ); // wait until someone uses the trigger

		if( player zm_utility::in_revive_trigger() ) // revive triggers override trap triggers
		{
			continue;
		}
		
		if( ( player.is_drinking > 0 ) )
		{
			continue;
		}
	
		if( !zm_utility::is_player_valid( player ) ) // ensure valid player
		{
			continue;
		}
		
		level thread idgun_cocoon_trigger_activate( self.stub, player );
		
		break;
	}
}

function idgun_cocoon_trigger_activate( trig_stub, player )
{
	n_quest_state = level clientfield::get( "idgun_" + trig_stub.n_gun_index + "_quest_state" );
	
	if( n_quest_state == 1 )
	{
		// take the base ID Gun from the player
		wpn_idgun = GetWeapon( level.idgun[ trig_stub.n_gun_index ].str_wpnname );
		if( player HasWeapon( wpn_idgun ) )
		{
			player TakeWeapon( wpn_idgun );
		}
	}
	else if( n_quest_state == 4 )
	{
		// give the upgraded ID Gun to the player
		wpn_idgun2 = get_transformed_idgun( level.idgun[ trig_stub.n_gun_index ].str_wpnname );
		player zm_weapons::weapon_give( wpn_idgun2, false, false );
		player SwitchToWeapon( wpn_idgun2 );
	}
	
	// increment quest state
	level clientfield::set( "idgun_" + trig_stub.n_gun_index + "_quest_state", ( n_quest_state + 1 ) );
	level flag::set( "idgun_" + trig_stub.n_gun_index + "_state_" + ( n_quest_state + 1 ) );

	// update the trigger's visibility
	trig_stub zm_unitrigger::run_visibility_function_for_all_triggers();
}

function get_transformed_idgun( str_wpn_idgun )
{
	a_str_idgun		= array( "idgun_0",	"idgun_1",		"idgun_2",		"idgun_3" );
	a_str_idgun2	= array( "idgun2_0",	"idgun2_1",	"idgun2_2",	"idgun2_3" );

	for( i = 0; i < 4; i++ )
	{
		if( str_wpn_idgun == a_str_idgun[ i ] )
		{
			wpn_idgun2 = GetWeapon( a_str_idgun2[ i ] );
			return wpn_idgun2;
		}
	}
}

function set_idgun_quest_state( n_gun_index, n_state )
{
	level.idgun[ n_gun_index ].state = n_state;
	level flag::set( "idgun_" + n_gun_index + "_state_" + n_state );
	level clientfield::set( "idgun_" + n_gun_index + "_quest_state", n_state );
}

//
// DEBUG
//

// self == player
function give_idgun( n_idgun_level )
{
	wpn_idgun = GetWeapon( level.idgun[ n_idgun_level ].str_wpnname );
	assert( isdefined( wpn_idgun ) );
	
	self zm_weapons::weapon_give( wpn_idgun, false, false );
	self SwitchToWeapon( wpn_idgun );
	
	level.idgun[ n_idgun_level ].owner = self;
}

//self = vehicle
function idgun_apply_vehicle_damage( eInflictor, eAttacker, iDamage, iDFlags, sMeansOfDeath, weapon, vPoint, vDir, sHitLoc, vDamageOrigin, psOffsetTime, damageFromUnderneath, modelIndex, partName, vSurfaceNormal )
{
	if( isdefined( weapon ) )
	{
		if( zm::is_idgun_damage( weapon ) && self vehicle_ai::get_current_state() != "idgun_death" )
		{
			params = SpawnStruct();
			params.vpoint = vpoint;
			params.attacker = eAttacker;
			params.weapon = weapon;
			self vehicle_ai::set_state( "idgun_death", params );
			iDamage = 0;
		}
	}
	return iDamage;
}

//self = vehicle
function idgun_add_vehicle_death_state()
{
	self vehicle_ai::add_state( "idgun_death",
		&state_idgun_death_enter,
		&state_idgun_death_update,
		undefined );
}

// ----------------------------------------------
//vehicle idgun death state
// ----------------------------------------------

function state_idgun_death_enter( params )
{
	self vehicle_ai::ClearAllLookingAndTargeting();
	self vehicle_ai::ClearAllMovement();
}

function state_idgun_death_update( params )
{
	self endon( "change_state" );
	self endon( "death" );
	
	black_hole_center = params.vpoint;
	attacker = params.attacker;
	weapon = params.weapon;
	
	timeOfHit = GetTime();

	fly_vector = self.origin - black_hole_center;
	fly_vector = ( fly_vector[0], fly_vector[1], 0 );
	fly_vector = VectorNormalize( fly_vector );
	
	for( ;; )
	{
		timeDiff = GetTime() - timeOfHit;
		
		if( timeDiff > 5000.0 )
		{
			self DoDamage( self.health + 666, self.origin, attacker, undefined, "none", "MOD_UNKNOWN", 0, weapon );
		}
		
		radius = ( 1 - timeDiff / 5000.0 ) * 60.0;
		theta = ( timeDiff / 5000.0 ) * 150.0;
		
		self.origin = black_hole_center + radius * fly_vector;
		
		x_rotated = fly_vector[0] * cos( theta ) - fly_vector[1] * sin( theta );
		y_rotated = fly_vector[0] * sin( theta ) + fly_vector[1] * cos( theta );
		
		fly_vector = ( x_rotated, y_rotated, fly_vector[2] );
		
		wait 0.1;
	}
}


//
// DEVGUI
//

/#
function idgun_devgui()
{
	level thread zm_zod_util::setup_devgui_func( "ZM/Zod/ID_Gun/Level 1",	"zod_idgun_level", 1, &devgui_idgun_give );
	level thread zm_zod_util::setup_devgui_func( "ZM/Zod/ID_Gun/Level 2",	"zod_idgun_level", 2, &devgui_idgun_give );
}

function idgun_quest_devgui()
{
	level thread zm_zod_util::setup_devgui_func( "ZM/Zod/ID_Gun Quest/0 - Base",				"zod_idgun_quest_level", 0, &devgui_idgun_quest );
	level thread zm_zod_util::setup_devgui_func( "ZM/Zod/ID_Gun Quest/1 - Ready to Upgrade",	"zod_idgun_quest_level", 1, &devgui_idgun_quest );
	level thread zm_zod_util::setup_devgui_func( "ZM/Zod/ID_Gun Quest/2 - Cocooned",			"zod_idgun_quest_level", 2, &devgui_idgun_quest );
	level thread zm_zod_util::setup_devgui_func( "ZM/Zod/ID_Gun Quest/3 - Ready To Hatch",		"zod_idgun_quest_level", 3, &devgui_idgun_quest );
	level thread zm_zod_util::setup_devgui_func( "ZM/Zod/ID_Gun Quest/4 - Hatched",				"zod_idgun_quest_level", 4, &devgui_idgun_quest );
	level thread zm_zod_util::setup_devgui_func( "ZM/Zod/ID_Gun Quest/5 - Upgraded",			"zod_idgun_quest_level", 5, &devgui_idgun_quest );
}

function devgui_idgun_give( n_value )
{
	foreach( e_player in level.players )
	{
		e_player give_idgun( n_value - 1 );
		util::wait_network_frame();
	}
}

function devgui_idgun_quest( n_value )
{
	level clientfield::set( "idgun_" + 0 + "_quest_state", n_value );
	level.idgun[ 0 ].state = n_value;
	level flag::set( "idgun_" + 0 + "_state_" + n_value );
}

#/

