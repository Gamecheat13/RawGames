#using scripts\shared\callbacks_shared;
#using scripts\shared\clientfield_shared;
#using scripts\shared\filter_shared;
#using scripts\shared\postfx_shared;
#using scripts\shared\system_shared;
#using scripts\shared\util_shared;

    	   	                                                                                                                         	                                                                                                                                                                                                                                                                                                                                                                    	        	     	             	    	   	                           	                               	                                	                                                              	                                                                                                              	                            	                                     	                                       	                                                               	   	                  	       	                                                    	                   	                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                        	                                                                                        	           	                        	                                            	                                             	                                                   	                                                             	                                                         	                                                                    	                                                                                                                                                                                                    	                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                      	                                                              	                                                          	                                   	                                   	                                                    	                                       
                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                            	                                                                                                                                                                                                                                                                                                                                                                                       









	
#namespace visionset_mgr;

function autoexec __init__sytem__() {     system::register("visionset_mgr",&__init__,undefined,undefined);    }

function __init__()
{
	level.vsmgr_initializing = true;
	level.vsmgr_default_info_name = "__none"; // underscores force this into the zeroth slot

	level.vsmgr = [];
	level.vsmgr_states_inited = [];
	level.vsmgr_filter_custom_enable = [];	// array indexed by filter name, function pointer for special enable function
	level.vsmgr_filter_custom_disable = [];	// array indexed by filter name, function pointer for special enable function

	level thread register_type( "visionset", &visionset_slot_cb, &visionset_lerp_cb, &visionset_update_cb );
	register_visionset_info( level.vsmgr_default_info_name, 1, 1, "undefined", "undefined" );

	level thread register_type( "overlay",&overlay_slot_cb, &overlay_lerp_cb, &overlay_update_cb );
	register_overlay_info_style_none( level.vsmgr_default_info_name, 1, 1 );

	callback::on_finalize_initialization( &finalize_initialization );
	level thread monitor();
}


function register_visionset_info( name, version, lerp_step_count, visionset_from, visionset_to )
{
	if ( !register_info( "visionset", name, version, lerp_step_count ) )
	{
		return;
	}

	level.vsmgr["visionset"].info[name].visionset_from = visionset_from;
	level.vsmgr["visionset"].info[name].visionset_to = visionset_to;
}

function register_overlay_info_style_none( name, version, lerp_step_count )
{
	if ( !register_info( "overlay", name, version, lerp_step_count ) )
	{
		return;
	}

	level.vsmgr["overlay"].info[name].style = 0;
}


function register_overlay_info_style_filter( name, version, lerp_step_count, filter_index, pass_index, material_name, constant_index )
{
	if ( !register_info( "overlay", name, version, lerp_step_count ) )
	{
		return;
	}

	level.vsmgr["overlay"].info[name].style = 2;

	level.vsmgr["overlay"].info[name].filter_index = filter_index;
	level.vsmgr["overlay"].info[name].pass_index = pass_index;
	level.vsmgr["overlay"].info[name].material_name = material_name;
	level.vsmgr["overlay"].info[name].constant_index = constant_index;
}


function register_overlay_info_style_blur( name, version, lerp_step_count, transition_in, transition_out, magnitude )
{
	if ( !register_info( "overlay", name, version, lerp_step_count ) )
	{
		return;
	}

	level.vsmgr["overlay"].info[name].style = 3;

	level.vsmgr["overlay"].info[name].transition_in = transition_in;
	level.vsmgr["overlay"].info[name].transition_out = transition_out;
	level.vsmgr["overlay"].info[name].magnitude = magnitude;
}


function register_overlay_info_style_electrified( name, version, lerp_step_count, duration )
{
	if ( !register_info( "overlay", name, version, lerp_step_count ) )
	{
		return;
	}

	level.vsmgr["overlay"].info[name].style = 4;

	level.vsmgr["overlay"].info[name].duration = duration;
}


function register_overlay_info_style_burn( name, version, lerp_step_count, duration )
{
	if ( !register_info( "overlay", name, version, lerp_step_count ) )
	{
		return;
	}

	level.vsmgr["overlay"].info[name].style = 5;

	level.vsmgr["overlay"].info[name].duration = duration;
}


// NOTE: this will run on all clients when used
function register_overlay_info_style_poison( name, version, lerp_step_count )
{
	if ( !register_info( "overlay", name, version, lerp_step_count ) )
	{
		return;
	}	

	level.vsmgr[ "overlay" ].info[ name ].style = 6;
}


function register_overlay_info_style_transported( name, version, lerp_step_count, duration )
{
	if ( !register_info( "overlay", name, version, lerp_step_count ) )
	{
		return;
	}

	level.vsmgr["overlay"].info[name].style = 7;

	level.vsmgr["overlay"].info[name].duration = duration;
}


function register_overlay_info_style_postfx_bundle( name, version, bundle, lerp_step_count, duration )
{
	if ( !register_info( "overlay", name, version, lerp_step_count ) )
	{
		return;
	}

	level.vsmgr["overlay"].info[name].style = 1;
	level.vsmgr["overlay"].info[name].duration = duration;
	level.vsmgr["overlay"].info[name].bundle = bundle;
}


function is_type_currently_default( localClientNum, type )
{
	if ( !level.vsmgr[type].in_use )
	{
		return true;
	}

	state = get_state( localClientNum, type );
	curr_info = get_info( type, state.curr_slot );

	return (curr_info.name == level.vsmgr_default_info_name);
}


function register_type( type, cf_slot_cb, cf_lerp_cb, update_cb )
{
	level.vsmgr[type] = spawnstruct();

	level.vsmgr[type].type = type;
	level.vsmgr[type].in_use = false; // true if items other than the default value has been registered
	level.vsmgr[type].highest_version = 0;
	level.vsmgr[type].server_version = getserverhighestclientfieldversion();
	level.vsmgr[type].cf_slot_name = type + "_slot";
	level.vsmgr[type].cf_lerp_name = type + "_lerp";
	level.vsmgr[type].cf_slot_cb = cf_slot_cb;
	level.vsmgr[type].cf_lerp_cb = cf_lerp_cb;
	level.vsmgr[type].update_cb = update_cb;
	level.vsmgr[type].info = [];
	level.vsmgr[type].sorted_name_keys = [];
}

function finalize_initialization( localclientnum )
{
	thread finalize_clientfields();

	if( !isdefined( level._fv2vs_default_visionset ) )
	{
		init_fog_vol_to_visionset_monitor( GetDvarString( "mapname" ), 0 );
		fog_vol_to_visionset_set_info( 0, GetDvarString( "mapname" ) );		
	}
}

function finalize_clientfields()
{
	typeKeys = GetArrayKeys( level.vsmgr );
	for ( type_index = 0; type_index < typeKeys.size; type_index++ )
	{
		level.vsmgr[typeKeys[type_index]] thread finalize_type_clientfields();
	}

	level.vsmgr_initializing = false; // registering new infos is not allowed after this point
}


function finalize_type_clientfields()
{
	if ( 1 >= self.info.size ) // if only the default info has been registered, don't spend bits on this type
	{
		return;
	}

	self.in_use = true;
	self.cf_slot_bit_count = GetMinBitCountForNum( self.info.size - 1 );
	self.cf_lerp_bit_count = self.info[self.sorted_name_keys[0]].lerp_bit_count;
	
	for ( i = 0; i < self.sorted_name_keys.size; i++ )
	{
		self.info[self.sorted_name_keys[i]].slot_index = i;

		if ( self.info[self.sorted_name_keys[i]].lerp_bit_count > self.cf_lerp_bit_count )
		{
			self.cf_lerp_bit_count = self.info[self.sorted_name_keys[i]].lerp_bit_count;
		}
	}

	clientfield::register( "toplayer", self.cf_slot_name, self.highest_version, self.cf_slot_bit_count, "int", self.cf_slot_cb, !true, true );

	// don't spend a clientfield if all slots are just on/off
	if ( 1 < self.cf_lerp_bit_count )
	{
		clientfield::register( "toplayer", self.cf_lerp_name, self.highest_version, self.cf_lerp_bit_count, "float", self.cf_lerp_cb, !true, true );
	}
}


function validate_info( type, name, version )
{
	keys = GetArrayKeys( level.vsmgr );
	for ( i = 0; i < keys.size; i++ )
	{
		if ( type == keys[i] )
		{
			break;
		}
	}

	assert( i < keys.size, "In visionset_mgr, type '" + type + "'is unknown" );

	if ( version > level.vsmgr[type].server_version )
	{
		return false;
	}

	if ( isdefined( level.vsmgr[type].info[name] ) && version < level.vsmgr[type].info[name].version )
	{
		if ( version < level.vsmgr[type].info[name].version )
		{
			return false;
		}

		// the version of this one is higher than the previously registered one, so let's clear the old one and register the new one.
		level.vsmgr[type].info[name] = undefined;
	}

	return true;
}


function add_sorted_name_key( type, name )
{
	for ( i = 0; i < level.vsmgr[type].sorted_name_keys.size; i++ )
	{
		if ( name < level.vsmgr[type].sorted_name_keys[i] )
		{
			break;
		}
	}

	ArrayInsert( level.vsmgr[type].sorted_name_keys, name, i );
}


function add_info( type, name, version, lerp_step_count )
{
	self.type = type;
	self.name = name;
	self.version = version;
	self.lerp_step_count = lerp_step_count;
	self.lerp_bit_count = GetMinBitCountForNum( lerp_step_count );
}


function register_info( type, name, version, lerp_step_count )
{
	assert( level.vsmgr_initializing, "All info registration in the visionset_mgr system must occur during the first frame while the system is initializing" );

	lower_name = ToLower( name );
	
	if ( !validate_info( type, lower_name, version ) )
	{
		return false;
	}

	add_sorted_name_key( type, lower_name );

	level.vsmgr[type].info[lower_name] = spawnstruct();
	level.vsmgr[type].info[lower_name] add_info( type, lower_name, version, lerp_step_count );

	if ( version > level.vsmgr[type].highest_version )
	{
		level.vsmgr[type].highest_version = version;
	}

	return true;
}


function slot_cb( localClientNum, oldVal, newVal, bNewEnt, bInitialSnap, fieldName, bWasDemoJump, type )
{
	init_states( localClientNum );

	level.vsmgr[type].state[localClientNum].curr_slot = newVal;

	if ( bNewEnt || bInitialSnap )
	{
		level.vsmgr[type].state[localClientNum].force_update = true;
	}
}


function visionset_slot_cb( localClientNum, oldVal, newVal, bNewEnt, bInitialSnap, fieldName, bWasDemoJump )
{
	self slot_cb( localClientNum, oldVal, newVal, bNewEnt, bInitialSnap, fieldName, bWasDemoJump, "visionset" );
}


function overlay_slot_cb( localClientNum, oldVal, newVal, bNewEnt, bInitialSnap, fieldName, bWasDemoJump )
{
	self slot_cb( localClientNum, oldVal, newVal, bNewEnt, bInitialSnap, fieldName, bWasDemoJump, "overlay" );
}


function lerp_cb( localClientNum, oldVal, newVal, bNewEnt, bInitialSnap, fieldName, bWasDemoJump, type )
{
	init_states( localClientNum );

	level.vsmgr[type].state[localClientNum].curr_lerp = newVal;

	if ( bNewEnt || bInitialSnap )
	{
		level.vsmgr[type].state[localClientNum].force_update = true;
	}
}


function visionset_lerp_cb( localClientNum, oldVal, newVal, bNewEnt, bInitialSnap, fieldName, bWasDemoJump )
{
	self lerp_cb( localClientNum, oldVal, newVal, bNewEnt, bInitialSnap, fieldName, bWasDemoJump, "visionset" );
}


function overlay_lerp_cb( localClientNum, oldVal, newVal, bNewEnt, bInitialSnap, fieldName, bWasDemoJump )
{
	self lerp_cb( localClientNum, oldVal, newVal, bNewEnt, bInitialSnap, fieldName, bWasDemoJump, "overlay" );
}


function get_info( type, slot )
{
	return level.vsmgr[type].info[level.vsmgr[type].sorted_name_keys[slot]];
}


function get_state( localClientNum, type )
{
	return level.vsmgr[type].state[localClientNum];
}


function should_update_state()
{
	return (self.force_update || (self.prev_slot != self.curr_slot) || (self.prev_lerp != self.curr_lerp));
}


function transition_state()
{
	self.prev_slot = self.curr_slot;
	self.prev_lerp = self.curr_lerp;
	self.force_update = false;
}


function init_states( localClientNum )
{
	if ( isdefined( level.vsmgr_states_inited[localClientNum] ) )
	{
		return;
	}

	typeKeys = GetArrayKeys( level.vsmgr );

	for ( type_index = 0; type_index < typeKeys.size; type_index++ )
	{
		type = typeKeys[type_index];

		if ( !level.vsmgr[type].in_use )
		{
			continue;
		}

		if ( !isdefined( level.vsmgr[type].state ) )
		{
			level.vsmgr[type].state = [];
		}

		level.vsmgr[type].state[localClientNum] = spawnstruct();

		level.vsmgr[type].state[localClientNum].prev_slot = level.vsmgr[type].info[level.vsmgr_default_info_name].slot_index;
		level.vsmgr[type].state[localClientNum].curr_slot = level.vsmgr[type].info[level.vsmgr_default_info_name].slot_index;

		// we'll default these to 1 since they'll get overwritten anyway, unless we didn't need to use the lerp clientfield, in which we want these set to 1
		level.vsmgr[type].state[localClientNum].prev_lerp = 1;
		level.vsmgr[type].state[localClientNum].curr_lerp = 1;

		level.vsmgr[type].state[localClientNum].force_update = false;
	}

	level.vsmgr_states_inited[localClientNum] = true;
}

function demo_jump_monitor()
{
	if ( !level.isDemoPlaying )
	{
		return;
	}

	typeKeys = GetArrayKeys( level.vsmgr );
	oldLerps = [];

	while ( 1 )
	{
		level util::waittill_any( "demo_jump", "demo_player_switch", "visionset_mgr_reset" );

		for ( type_index = 0; type_index < typeKeys.size; type_index++ )
		{
			type = typeKeys[type_index];

			if ( !level.vsmgr[type].in_use )
			{
				continue;
			}

			level.vsmgr[type].state[0].force_update = true;
		}
	}
}


function demo_spectate_monitor()
{
	if ( !level.isDemoPlaying )
	{
		return;
	}

	typeKeys = GetArrayKeys( level.vsmgr );

	while ( true )
	{
		if ( IsSpectating( 0, false ) )
		{
			if ( !( isdefined( level.vsmgr_is_spectating ) && level.vsmgr_is_spectating ) )
			{
				fog_vol_to_visionset_force_instant_transition( 0 );
				level notify( "visionset_mgr_reset" );
			}

			level.vsmgr_is_spectating = true;
		}
		else
		{
			if ( ( isdefined( level.vsmgr_is_spectating ) && level.vsmgr_is_spectating ) )
			{
				level notify( "visionset_mgr_reset" );
			}

			level.vsmgr_is_spectating = false;
		}

		wait( 0.01 );
	}
}

function monitor()
{
	while ( level.vsmgr_initializing )
	{
		wait( 0.01 );
	}

	if ( level.isDemoPlaying ) 
	{
		level thread demo_spectate_monitor();
		level thread demo_jump_monitor();
	}

	typeKeys = GetArrayKeys( level.vsmgr );

	while ( true )
	{
		for ( type_index = 0; type_index < typeKeys.size; type_index++ )
		{
			type = typeKeys[type_index];

			if ( !level.vsmgr[type].in_use )
			{
				continue;
			}

			for ( localClientNum = 0; localClientNum < level.localPlayers.size; localClientNum++ )
			{
				init_states( localClientNum );

				if ( level.vsmgr[type].state[localClientNum] should_update_state() )
				{
					level.vsmgr[type] thread [[level.vsmgr[type].update_cb]]( localClientNum, type );

					level.vsmgr[type].state[localClientNum] transition_state();
				}
			}
		}

		wait( 0.01 );
	}
}


function visionset_update_cb( localClientNum, type )
{
	state = get_state( localClientNum, type );
	curr_info = get_info( type, state.curr_slot );
	prev_info = get_info( type, state.prev_slot );

/#
	//println( "!@#$visionset_update_cb( LCN: " + localClientNum + ", NAME: " + curr_info.name + ", LERP: " + state.curr_lerp + ");" );
#/

	if ( ( isdefined( level.isDemoPlaying ) && level.isDemoPlaying ) && IsSpectating( localClientNum, true ) )
	{
		return;
	}

	if ( level.vsmgr_default_info_name == curr_info.name )
	{
		fog_vol_to_visionset_force_instant_transition( localClientNum );
		return;
	}

	if ( !IsDefined( curr_info.visionset_from ) )
	{
		VisionSetNakedLerp( localClientNum, curr_info.visionset_to, level._fv2vs_prev_visionsets[localClientNum], state.curr_lerp );
	}
	else
	{
		VisionSetNakedLerp( localClientNum, curr_info.visionset_to, curr_info.visionset_from, state.curr_lerp );
	}
}


function set_poison_overlay( amount )
{   
    SetDvar( "r_poisonFX_debug_enable", 1 );
    SetDvar( "r_poisonFX_pulse", 2 );
    SetDvar( "r_poisonFX_warpX", -.3 );
    SetDvar( "r_poisonFX_warpY", .15 );
    SetDvar( "r_poisonFX_dvisionA", 0 );
    SetDvar( "r_poisonFX_dvisionX", 0 );
    SetDvar( "r_poisonFX_dvisionY", 0 );
    SetDvar( "r_poisonFX_blurMin", 0 );
    SetDvar( "r_poisonFX_blurMax", 3 );	

    SetDvar( "r_poisonFX_debug_amount", amount );
}

function clear_poison_overlay()
{
    SetDvar( "r_poisonFX_debug_amount", 0 );
    SetDvar( "r_poisonFX_debug_enable", 0 );	
}

function overlay_update_cb( localClientNum, type )
{
	state = get_state( localClientNum, type );
	curr_info = get_info( type, state.curr_slot );
	prev_info = get_info( type, state.prev_slot );
	player = level.localPlayers[localClientNum];

/#
	//println( "!@#$overlay_update_cb( LCN: " + localClientNum + ", NAME: " + curr_info.name + ", LERP: " + state.curr_lerp + ");" );
#/

	if ( state.force_update || state.prev_slot != state.curr_slot )
	{
		switch ( prev_info.style )
		{
		case 0:
			// do nothing
			break;
		case 1:
			player thread postfx::StopPostfxBundle();
			break;
		case 2:
			if ( IsDefined( level.vsmgr_filter_custom_disable[ curr_info.material_name ] ) )
			{
				player [[ level.vsmgr_filter_custom_disable[ curr_info.material_name ] ]]( state, prev_info, curr_info );
			}
			else
			{
				player set_filter_pass_enabled( prev_info.filter_index, prev_info.pass_index, false );
			}
			break;
		case 3:
			SetBlurByLocalClientNum( localClientNum, 0, prev_info.transition_out );
			break;
		case 4:
			SetElectrified( localClientNum, 0 );
			break;
		case 5:
			SetBurn( localClientNum, 0 );
			break;
		case 6:
			clear_poison_overlay();
			break;
		case 7:
			player thread postfx::StopPostfxBundle();
			break;
		}
	}

	if ( ( isdefined( level.isDemoPlaying ) && level.isDemoPlaying ) && IsSpectating( localClientNum, false ) )
	{
		return;
	}

	switch ( curr_info.style )
	{
	case 0:
		// do nothing
		break;
	case 1:
		if ( state.force_update || state.prev_slot != state.curr_slot || state.prev_lerp <= state.curr_lerp )
		{
			player thread postfx::PlayPostfxBundle( curr_info.bundle );
		}
		break;
	case 2:
		if ( state.force_update || state.prev_slot != state.curr_slot || state.prev_lerp != state.curr_lerp )
		{
			if ( IsDefined( level.vsmgr_filter_custom_enable[ curr_info.material_name ] ) )
			{
				player [[ level.vsmgr_filter_custom_enable[ curr_info.material_name ] ]]( state, prev_info, curr_info );
			}
			else
			{
				player set_filter_pass_material( curr_info.filter_index, curr_info.pass_index, level.filter_matid[curr_info.material_name] );
				player set_filter_pass_enabled( curr_info.filter_index, curr_info.pass_index, true );

				if ( IsDefined( curr_info.constant_index ) )
				{
					player set_filter_pass_constant( curr_info.filter_index, curr_info.pass_index, curr_info.constant_index, state.curr_lerp );
				}					
			}
		}
		break;
	case 3:
		if ( state.force_update || state.prev_slot != state.curr_slot || state.prev_lerp <= state.curr_lerp )
		{
			SetBlurByLocalClientNum( localClientNum, curr_info.magnitude, curr_info.transition_in );
		}
		break;
	case 4:
		if ( state.force_update || state.prev_slot != state.curr_slot || state.prev_lerp <= state.curr_lerp )
		{
			SetElectrified( localClientNum, (curr_info.duration * state.curr_lerp) );
		}
		break;
	case 5:
		if ( state.force_update || state.prev_slot != state.curr_slot || state.prev_lerp <= state.curr_lerp )
		{
			SetBurn( localClientNum, (curr_info.duration * state.curr_lerp) );
		}
		break;
	case 6:
		if ( state.force_update || state.prev_slot != state.curr_slot || state.prev_lerp != state.curr_lerp )
		{
			set_poison_overlay( state.curr_lerp );
		}
		break;
	case 7:
		if ( state.force_update || state.prev_slot != state.curr_slot || state.prev_lerp <= state.curr_lerp )
		{
			level thread filter::SetTransported( player );
		}
		break;
	}
}

///FOG VOL FUNCTIONS

function init_fog_vol_to_visionset_monitor( default_visionset, default_trans_in, host_migration_active )
{
	level._fv2vs_default_visionset = default_visionset;
	level._fv2vs_default_trans_in = default_trans_in;
	level._fv2vs_suffix = "";
	level._fv2vs_unset_visionset = "_fv2vs_unset";

	level._fv2vs_prev_visionsets = [];
	level._fv2vs_prev_visionsets[0] = level._fv2vs_unset_visionset;
	level._fv2vs_prev_visionsets[1] = level._fv2vs_unset_visionset;
	level._fv2vs_prev_visionsets[2] = level._fv2vs_unset_visionset;
	level._fv2vs_prev_visionsets[3] = level._fv2vs_unset_visionset;

	level._fv2vs_force_instant_transition = [];
	level._fv2vs_force_instant_transition[0] = false;
	level._fv2vs_force_instant_transition[1] = false;
	level._fv2vs_force_instant_transition[2] = false;
	level._fv2vs_force_instant_transition[3] = false;

	if ( !isdefined( host_migration_active ) )
	{
		level._fv2vs_infos = [];

		fog_vol_to_visionset_set_info( -1, default_visionset, default_trans_in );
	}

	level._fv2vs_inited = true;
	
	level thread fog_vol_to_visionset_monitor();
	level thread reset_player_fv2vs_infos_on_respawn();
}


function fog_vol_to_visionset_set_suffix( suffix )
{
	level._fv2vs_suffix = suffix;
}


function fog_vol_to_visionset_set_info( id, visionset, trans_in )
{
	if ( !IsDefined( trans_in ) )
	{
		trans_in = level._fv2vs_default_trans_in;
	}

	level._fv2vs_infos[id] = SpawnStruct();

	level._fv2vs_infos[id].visionset = visionset;
	level._fv2vs_infos[id].trans_in = trans_in;
}


function fog_vol_to_visionset_force_instant_transition( localClientNum )
{
	if ( !( isdefined( level._fv2vs_inited ) && level._fv2vs_inited ) )
	{
		return;
	}

	level._fv2vs_force_instant_transition[localClientNum] = true;
}


function fog_vol_to_visionset_instant_transition_monitor()
{
	level endon( "hmo" );

	level thread fog_vol_to_visionset_hostmigration_monitor();

	while ( true )
	{
		level util::waittill_any( "demo_jump", "demo_player_switch" );

/#
		//println( "CLIENT: force instant transition" );
#/

		players = GetLocalPlayers();
		for ( localClientNum = 0; localClientNum < players.size; localClientNum++ )
		{
			level._fv2vs_force_instant_transition[localClientNum] = true;
		}
	}
}

function fog_vol_to_visionset_hostmigration_monitor()
{
	level waittill( "hmo" );
	wait 3;

/#
	//println( "CLIENT: force instant transition due to host migration" );
#/
	
	init_fog_vol_to_visionset_monitor( level._fv2vs_default_visionset, level._fv2vs_default_trans_in, true );

	wait 1;

	level notify( "visionset_mgr_reset" );
	return;
}

function fog_vol_to_visionset_monitor()
{
	level endon( "hmo" ); // Hostmigration kills this thread - it will be rethreaded.

	level thread fog_vol_to_visionset_instant_transition_monitor();

	while ( true )
	{
		wait( 0.01 );
		waittillframeend; // let the vsmgr update states for this frame first

		players = GetLocalPlayers();
		for ( localClientNum = 0; localClientNum < players.size; localClientNum++ )
		{
			if ( !is_type_currently_default( localClientNum, "visionset" ) )
			{
				level._fv2vs_prev_visionsets[localClientNum] = level._fv2vs_unset_visionset;
				continue;
			}

			id = GetWorldFogScriptID( localClientNum );

			//assert( IsDefined( level._fv2vs_infos[id] ), "WorldFogScriptID '" + id + "' was not registered with fog_vol_to_visionset_set_info()" );
			if ( !IsDefined( level._fv2vs_infos[id] ) )
			{
				id = -1; // temp fix for now to not require scriptIDs to be set up on world fogs, discussions need to occur between gameplay and graphics engineering about the way forward
			}

			new_visionset = level._fv2vs_infos[id].visionset + level._fv2vs_suffix;

			if ( level._fv2vs_prev_visionsets[localClientNum] != new_visionset || level._fv2vs_force_instant_transition[localClientNum] )
			{
/#
				//iprintlnbold( "setting " + new_visionset );
#/
				trans = level._fv2vs_infos[id].trans_in;
				if ( level._fv2vs_force_instant_transition[localClientNum] )
				{
/#
					//println( "Force instant transition set: " + new_visionset );
#/

					trans = 0;
				}

				VisionSetNaked( localClientNum, new_visionset, trans );
				level._fv2vs_prev_visionsets[localClientNum] = new_visionset;
			}

			level._fv2vs_force_instant_transition[localClientNum] = false;
		}
	}
}

function reset_player_fv2vs_infos_on_respawn()
{
	level endon( "hmo" );	// Hostmigration kills this thread - it will be rethreaded.

	while ( 1 )
	{
		level waittill( "respawn" );
		players = GetLocalPlayers();
		for ( localClientNum = 0; localClientNum < players.size; localClientNum++ )
		{
			level._fv2vs_prev_visionsets[localClientNum] = level._fv2vs_unset_visionset;
		}
	}
}
