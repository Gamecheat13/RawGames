    	   	                                                                                                                         	                                                                                                                                                                                                                                                                                                                                                                    	        	     	             	    	   	                           	                               	                                	                                                              	                                                                                                              	                            	                                     	                                       	                                                               	   	                  	       	                                                    	                   	                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                       	                                                                                        	           	                        	                                            	                                             	                                                   	                                                             	                                                         	                                                                    	                                                                                                                                                                                                    	                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                     	                                                              	                                                          	                                   	                                   	                                                    	                                       
                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                            	                                                                                                                                                                                                                                                                                                                                                                                       
                                                                                                                                                                                                                                                                                                                                                                                                                 	                                                                                                                                                                          	                                                                                         	                                                                                                                                                                                                                                                                                                                                                                                                                                        	                                                                                                                               	                                                                                                                                                                                                                                              	                                                                                                                                           	                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                   	                                                                                                                       	   	                                                                                                                                                                                                                                                                                                                         	                                                                                                                                                                                                                                      
                                                                                                                                                                                                                                                                                                    	                                                                                     	                                                                                                                                                                                                                                                                                             	                                                                                                                                                                                                                                                                                                                                                                                                   	                                                                                                                                                                                                                                                                                                         	                                                   

#using scripts\codescripts\struct;
#using scripts\shared\animation_shared;
#using scripts\shared\array_shared;
#using scripts\shared\callbacks_shared;
#using scripts\shared\clientfield_shared;
#using scripts\shared\exploder_shared;
#using scripts\shared\flag_shared;
#using scripts\shared\system_shared;
#using scripts\shared\util_shared;

#using scripts\zm\_load;
#using scripts\zm\_zm;
#using scripts\zm\_zm_utility;
#using scripts\zm\craftables\_zm_craftables;



















#using_animtree( "generic" );

#namespace zm_zod_quest;

function autoexec __init__sytem__() {     system::register("zm_zod_quest",&__init__,undefined,undefined);    }

// spawn the script_models for the rituals
function create_client_ritual_assembly( localClientNum, n_current_ritual )
{
	str_charname = get_name_from_ritual_clientfield_value( n_current_ritual ); // get character name
	s_position = struct::get( "defend_area_" + str_charname, "targetname" ); // get ritual location
	
	// ritual assembly (includes Redemption's Key)
	level.main_quest[ localClientNum ][ n_current_ritual ] = s_position;
	level.main_quest[ localClientNum ][ n_current_ritual ].e_assembly = Spawn( localClientNum, s_position.origin, "script_model" );
	level.main_quest[ localClientNum ][ n_current_ritual ].e_assembly.angles = s_position.angles;
	level.main_quest[ localClientNum ][ n_current_ritual ].e_assembly SetModel( "p7_fxanim_zm_zod_redemption_key_ritual_mod" );
	level.main_quest[ localClientNum ][ n_current_ritual ].e_assembly.vfx_trails = []; // create an array to hold the references for the vfx attached to the assembly

	// add the memento
	level.main_quest[ localClientNum ][ n_current_ritual ].e_memento = Spawn( localClientNum, s_position.origin, "script_model" );
	level.main_quest[ localClientNum ][ n_current_ritual ].e_memento SetModel( "p7_zm_zod_memento_" + str_charname );
		
	// add the relic
	level.main_quest[ localClientNum ][ n_current_ritual ].e_relic = Spawn( localClientNum, s_position.origin, "script_model" );
	level.main_quest[ localClientNum ][ n_current_ritual ].e_relic SetModel( "p7_zm_zod_relic_" + str_charname );
	level.main_quest[ localClientNum ][ n_current_ritual ].e_relic LinkTo( level.main_quest[ localClientNum ][ n_current_ritual ].e_assembly, "tag_ritual_drop" );

	// add the victim
	level.main_quest[ localClientNum ][ n_current_ritual ].e_victim = Spawn( localClientNum, s_position.origin, "script_model" );
	level.main_quest[ localClientNum ][ n_current_ritual ].e_victim SetModel( "c_zom_zod_victim_" + str_charname + "_fb" );
	level.main_quest[ localClientNum ][ n_current_ritual ].e_victim LinkTo( level.main_quest[ localClientNum ][ n_current_ritual ].e_assembly, "tag_char_jnt" );
}

function get_name_from_ritual_clientfield_value( current_ritual )
{
	switch( current_ritual )
	{
		case 1:
			return "boxer";
		case 2:
			return "detective";
		case 3:
			return "femme";
		case 4:
			return "magician";
	}
}

function __init__()
{
	if( !isdefined( level.main_quest ) )
	{
	   level.main_quest = [];
	}
	
	clientfield::register( "world", "quest_key",	1,	1,												"int",		undefined,					!true, true );
	clientfield::register( "world", "ritual_progress",							1,	7,					"float",	&ritual_progress,			!true, !true );
	clientfield::register( "world", "ritual_current",							1,	3,							"int",		undefined,					!true, !true );
	clientfield::register( "world", "ritual_state_boxer",						1,	2,							"int",		&ritual_state_boxer,		!true, true );
	clientfield::register( "world", "ritual_state_detective",					1,	2,							"int",		&ritual_state_detective,	!true, true );
	clientfield::register( "world", "ritual_state_femme",						1,	2,							"int",		&ritual_state_femme,		!true, true );
	clientfield::register( "world", "ritual_state_magician",					1,	2,							"int",		&ritual_state_magician,		!true, true );
	clientfield::register( "world", "ritual_state_pap",							1,	2,							"int",		&ritual_state_pap,			!true, true );

	SetupClientFieldCodeCallbacks( "world", 1, "quest_key" );
	
	flag::init( "set_ritual_finished_flag" );
}

// display ritual effects that are updated when the ritual advances in state
function ritual_state_internal( localClientNum, newVal, n_current_ritual )
{
	level notify( "ritual_state_internal" );
	level endon( "ritual_state_internal" );
	
	str_name = get_name_from_ritual_clientfield_value( n_current_ritual );
	
	if( !isdefined( level.main_quest ) )
	{
		level.main_quest = [];
	}

	if( !isdefined( level.main_quest[ localClientNum ] ) )
	{
		level.main_quest[ localClientNum ] = [];
	}

	// setup all the clientside models for the ritual
	if( !isdefined( level.main_quest[ localClientNum ][ n_current_ritual ] ) )
	{
		create_client_ritual_assembly( localClientNum, n_current_ritual );
	}

	// get the assembly model for the ritual (animations are played on this)
	mdl_ritual = level.main_quest[ localClientNum ][ n_current_ritual ].e_assembly;
	mdl_ritual util::waittill_dobj( localClientNum );
	if ( !mdl_ritual HasAnimTree() )
	{
		mdl_ritual UseAnimTree( #animtree );
	}
	// get shortened references to all the other models, for readability
	mdl_memento	= level.main_quest[ localClientNum ][ n_current_ritual ].e_memento;
	mdl_relic	= level.main_quest[ localClientNum ][ n_current_ritual ].e_relic;
	mdl_victim	= level.main_quest[ localClientNum ][ n_current_ritual ].e_victim;
	
	// show/hide parts of the ritual and play vfx/anims
	switch( newVal )
	{
		case 0:
			
			// hide all the ritual parts, since the ritual table is empty
			mdl_ritual Hide();
			mdl_memento Hide();
			mdl_relic Hide();
			mdl_victim Hide();
			
			// sfx
			level thread sndRitual(0, mdl_ritual );
			
			break;

		case 1:
			
			// show only the memento, so we're ready to start the ritual
			mdl_ritual Hide();
			mdl_memento Show();
			mdl_relic Hide();
			mdl_victim Hide();
			
			// clear all possible previous anims
			mdl_ritual ClearAnim( "p7_fxanim_zm_zod_redemption_key_ritual_start_anim", 0 );
			mdl_ritual ClearAnim( "p7_fxanim_zm_zod_redemption_key_ritual_loop_anim", 0 );
			mdl_ritual ClearAnim( "p7_fxanim_zm_zod_redemption_key_ritual_loop_fast_anim", 0 );
			
			level thread sndRitual(1, mdl_ritual);
			
			// place item at centered location on pedestal
			s_ritual_item = struct::get( "quest_ritual_item_placed_" + str_name, "targetname" );
			mdl_memento.origin = s_ritual_item.origin;
			mdl_memento.angles = s_ritual_item.angles;
			
			level thread exploder::stop_exploder( "ritual_light_" + str_name );
			
			// stop altar vfx
			toggle_altar_vfx( localClientNum, str_name, false );
			
			break;
			
		case 2:
			
			// show the assembly (quest key), hide everything else for now
			mdl_ritual Show();
			mdl_memento Hide();
			mdl_relic Hide();
			mdl_victim Show();

			// play trail vfx
			for( i = 0; i < 4; i++ )
			{
				mdl_ritual.vfx_trails[ i ] = PlayFXOnTag( localClientNum, level._effect[ "ritual_trail" ], mdl_ritual, "key_pcs0" + ( i + 1 ) + "_jnt" );
			}
			
			// Ritual starting sound
			level thread sndRitual(2, mdl_ritual);
			// play lighting change for ritual beginning...
			level thread exploder::exploder( "ritual_light_" + str_name );
			
			// play altar vfx
			toggle_altar_vfx( localClientNum, str_name, true );

			// Redemption's Key lifts off and separates into pieces
			mdl_ritual animation::play( "p7_fxanim_zm_zod_redemption_key_ritual_start_anim" );
			mdl_ritual ClearAnim( "p7_fxanim_zm_zod_redemption_key_ritual_start_anim", 0 );
			
			// Redemption's Key pieces orbit slowly
			mdl_ritual animation::play( "p7_fxanim_zm_zod_redemption_key_ritual_loop_anim" );
			mdl_ritual ClearAnim( "p7_fxanim_zm_zod_redemption_key_ritual_loop_anim", 0 );
			
			// Redemption's Key orbits quickly now
			mdl_ritual animation::play( "p7_fxanim_zm_zod_redemption_key_ritual_loop_fast_anim" );
			
			break;
			
		case 3:
			
			// hide everything
			mdl_ritual Show();
			mdl_memento Hide();
			mdl_relic Hide();
			mdl_victim Show();
			
			// play glow vfx from ritual victim about to burst
			mdl_victim = level.main_quest[ localClientNum ][ n_current_ritual ].e_victim;
			mdl_victim.vfx_chest = PlayFXOnTag( localClientNum, level._effect[ "ritual_glow_chest" ], mdl_victim, "j_spineupper" );
			mdl_victim.vfx_head = PlayFXOnTag( localClientNum, level._effect[ "ritual_glow_head" ], mdl_victim, "tag_eye" );
			
			// clear the fast looping anim
			mdl_ritual ClearAnim( "p7_fxanim_zm_zod_redemption_key_ritual_loop_fast_anim", 0 );
			
			// play trail vfx
			for( i = 0; i < 4; i++ )
			{
				StopFX( localClientNum, mdl_ritual.vfx_trails[ i ] );
			}
			
			// play ritual end anim (includes lowering of gateworm)
			level thread key_combines_notetrack_watcher( localClientNum, mdl_ritual, mdl_relic, mdl_victim, str_name );
			mdl_ritual animation::play( "p7_fxanim_zm_zod_redemption_key_ritual_end_anim" );
			
			// hide all the ritual parts, since we're done now
			mdl_ritual Hide();
			mdl_memento Hide();
			mdl_relic Hide();
			mdl_victim Hide();
			
			break;
	}
}

function key_combines_notetrack_watcher( localClientNum, mdl_ritual, mdl_relic, mdl_victim, str_name )
{
	flag::wait_till( "set_ritual_finished_flag" );
	
	// hide / show
	mdl_ritual Hide(); // hide the quest key
	mdl_relic Show(); // show the relic (gateworm)
	mdl_victim Hide(); // hide the victim
	StopFX( localClientNum, mdl_victim.vfx_chest );
	StopFX( localClientNum, mdl_victim.vfx_head );
	
	// play gateworm landing sfx
	level thread sndRitual(3, mdl_ritual);
	// timed lighting sequence
	level thread ritual_success_light_exploder( str_name );
	// stop altar vfx
	toggle_altar_vfx( localClientNum, str_name, false );
	
	flag::clear( "set_ritual_finished_flag" );
}

// ritual lights
function ritual_success_light_exploder( str_name )
{
	// turn off light exploder for ritual
	level thread exploder::stop_exploder( "ritual_light_" + str_name );
	level thread exploder::exploder( "ritual_light_" + str_name + "_fin" );
	wait 5; // show the finale light for a few seconds to reinforce end of ritual
	level thread exploder::stop_exploder( "ritual_light_" + str_name + "_fin" );
}

// turn the vfx that play directly on the altar on or off as required
function toggle_altar_vfx( localClientNum, str_name, b_on )
{
	a_ritual_pedestal = GetEntArray( localClientNum, "ritual_pedestal", "targetname" );
	foreach( e_ritual_pedestal in a_ritual_pedestal )
	{
		if( ( b_on ) && ( e_ritual_pedestal.script_string == ( "ritual_" + str_name ) ) )
		{
			e_ritual_pedestal.ritual_fx = PlayFX( localClientNum, level._effect[ "ritual_altar" ], e_ritual_pedestal.origin );
		}
		else if( isdefined( e_ritual_pedestal.ritual_fx ) )
		{
			StopFX( localClientNum, e_ritual_pedestal.ritual_fx );
			e_ritual_pedestal.ritual_fx = undefined;
		}
	}
}

function sndRitual( state, e_model )
{
	level notify( "sndRitual" );
	level endon( "sndRitual" );
	
	switch( state )
	{
		case 0:
			e_model playsound( 0, "evt_zod_ritual_reset" );
			if( isdefined( e_model.sndEnt ) )
			{
				e_model.sndEnt delete();
				e_model.sndEnt = undefined;
			}
			break;
		case 1:
			e_model playsound( 0, "evt_zod_ritual_ready" );
			if( !isdefined( e_model.sndEnt ) )
			{
				e_model.sndEnt = spawn( 0, e_model.origin, "script_origin" );
				e_model.sndEnt linkto( e_model, "tag_origin" );
			}
			e_model.sndEnt playloopsound("evt_zod_ritual_ready_loop", 2);
			break;
		case 2:
			e_model playsound( 0, "evt_zod_ritual_started" );
			if( !isdefined( e_model.sndEnt ) )
			{
				e_model.sndEnt = spawn( 0, e_model.origin, "script_origin" );
				e_model.sndEnt linkto( e_model, "tag_origin" );
			}
			looper = e_model.sndEnt playloopsound( "evt_zod_ritual_started_loop", 2 );
			pitch = .5;
			while(1)
			{
				setsoundpitch( looper, pitch );
				setsoundpitchrate( looper, .1 );
				wait(1);
				pitch = pitch+.05;
			}
			break;
		case 3:
			e_model playsound( 0, "evt_zod_ritual_finished" );
			if( isdefined( e_model.sndEnt ) )
			{
				e_model.sndEnt delete();
				e_model.sndEnt = undefined;
			}
			break;
	}
}

// display ritual effects that are updated when the ritual advances in state
function ritual_state_boxer( localClientNum, oldVal, newVal, bNewEnt, bInitialSnap, fieldName, bWasDemoJump )
{
	ritual_state_internal( localClientNum, newVal, 1 );
}

// display ritual effects that are updated when the ritual advances in state
function ritual_state_detective( localClientNum, oldVal, newVal, bNewEnt, bInitialSnap, fieldName, bWasDemoJump )
{
	ritual_state_internal( localClientNum, newVal, 2 );
}

// display ritual effects that are updated when the ritual advances in state
function ritual_state_femme( localClientNum, oldVal, newVal, bNewEnt, bInitialSnap, fieldName, bWasDemoJump )
{
	ritual_state_internal( localClientNum, newVal, 3 );
}

// display ritual effects that are updated when the ritual advances in state
function ritual_state_magician( localClientNum, oldVal, newVal, bNewEnt, bInitialSnap, fieldName, bWasDemoJump )
{
	ritual_state_internal( localClientNum, newVal, 4 );
}

function quest_state_boxer( localClientNum, oldVal, newVal, bNewEnt, bInitialSnap, fieldName, bWasDemoJump )
{
}

function quest_state_detective( localClientNum, oldVal, newVal, bNewEnt, bInitialSnap, fieldName, bWasDemoJump )
{
}

function quest_state_femme( localClientNum, oldVal, newVal, bNewEnt, bInitialSnap, fieldName, bWasDemoJump )
{
}

function quest_state_magician( localClientNum, oldVal, newVal, bNewEnt, bInitialSnap, fieldName, bWasDemoJump )
{
}

// display ritual effects that are updated when the ritual advances in state
function ritual_state_pap( localClientNum, oldVal, newVal, bNewEnt, bInitialSnap, fieldName, bWasDemoJump )
{
	if( newVal ==  2 )
	{
		level thread exploder::exploder( "ritual_light_pap" );
		
		a_ritual_pedestal = GetEntArray( localClientNum, "ritual_pedestal", "targetname" );
		foreach( e_ritual_pedestal in a_ritual_pedestal )
		{
			if( e_ritual_pedestal.script_string == ( "ritual_pap" ) )
			{
				e_ritual_pedestal.ritual_fx = PlayFX( localClientNum, level._effect[ "pap_altar_glow" ], e_ritual_pedestal.origin );
			}
		}
	}
	else if( newVal == 3 )
	{
		level thread exploder::stop_exploder( "ritual_light_pap" );
		
		a_ritual_pedestal = GetEntArray( localClientNum, "ritual_pedestal", "targetname" );
		foreach( e_ritual_pedestal in a_ritual_pedestal )
		{
			if( isdefined( e_ritual_pedestal.ritual_fx ) )
			{
				StopFX( localClientNum, e_ritual_pedestal.ritual_fx );
				e_ritual_pedestal.ritual_fx = undefined;
			}
		}
	}
}

// display ritual effects that are updated frequently via the progress clientfield
// TODO: evaluate whether this is still necessary later, when we have a better sense of the specific effects
function ritual_progress( localClientNum, oldVal, newVal, bNewEnt, bInitialSnap, fieldName, bWasDemoJump )
{
	if( !isdefined( level.main_quest[ localClientNum ] ) )
	{
		return;
	}

	// based on the current ritual progress, switch us from one anim to the next
	
	ritual_current = level clientfield::get( "ritual_current" );
	if( ( ritual_current != 5 ) && ( ritual_current != 0 ) ) // character ritual progress effects
	{
//		level.main_quest[ localClientNum ][ ritual_current ].e_model.origin = VectorLerp( level.main_quest[ localClientNum ][ ritual_current ].origin, level.main_quest[ localClientNum ][ ritual_current ].origin + ( 0, 0, N_RITUAL_CORPSE_RISE_Z ), newVal );
	}
	else // pack-a-punch progress effects
	{
	}
}

