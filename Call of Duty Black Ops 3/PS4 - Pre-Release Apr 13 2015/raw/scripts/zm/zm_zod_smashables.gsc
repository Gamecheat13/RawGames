/* zm_zod_smashables.gsc
 *
 * Purpose : 	Smashables.
 *		
 * Author : 	G Henry Schmitt
 * 
 * 
 */
 
#using scripts\codescripts\struct;

#using scripts\shared\array_shared;
#using scripts\shared\callbacks_shared;
#using scripts\shared\clientfield_shared;
#using scripts\shared\exploder_shared;
#using scripts\shared\flag_shared;
#using scripts\shared\scene_shared;
#using scripts\shared\system_shared;
#using scripts\shared\util_shared;

    	   	                                                                                                                         	                                                                                                                                                                                                                                                                                                                                                                    	        	     	             	    	   	                           	                               	                                	                                                              	                                                                                                              	                            	                                     	                                       	                                                               	   	                  	       	                                                    	                   	                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                       	                                                                                        	           	                        	                                            	                                             	                                                   	                                                             	                                                         	                                                                    	                                                                                                                                                                                                    	                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                     	                                                              	                                                          	                                   	                                   	                                                    	                                       
                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                            	                                                                                                                                                                                                                                                                                                                                                                                       

                                                                                                                               
                                                                                                                                                                                                                                                                                                                                                                                                                 	                                                                                                                                                                          	                                                                                         	                                                                                                                                                                                                                                                                                                                                                                                                                                        	                                                                                                                               	                                                                                                                                                                                                                                              	                                                                                                                                           	                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                   	                                                                                                                       	   	                                                                                                                                                                                                                                                                                                                         	                                                                                                                                                                                                                                      

#using scripts\zm\_load;
#using scripts\zm\_zm;
#using scripts\zm\_zm_utility;
#using scripts\zm\_zm_zonemgr;

#using scripts\zm\zm_zod_portals;
#using scripts\zm\zm_zod_quest;

#namespace zm_zod_smashables;






function autoexec __init__sytem__() {     system::register("zm_zod_smashables",undefined,&__main__,undefined);    }

class cSmashable
{
	var m_a_clip;
	var m_e_trigger;
	var m_a_callbacks;
	var m_a_b_parameters;
	var m_a_e_models;
	var m_b_shader_on;
	var m_func_trig; // function triggered when the smashable is smashed
	var m_arg; // argumented passed to the function
	var m_arg2;
	var m_e_linkto;
	
	constructor()
	{
		m_a_callbacks = [];
		m_a_b_parameters = [];
		m_a_e_models = [];
	}
	
	function init( e_trigger )
	{
		m_e_trigger = e_trigger;
		m_a_clip = GetEntArray( e_trigger.target, "targetname" );
		
		// if we've set a custom linkto target, define m_e_linkto so everything can move
		/*
		if( isdefined( m_e_trigger.script_linkto ) && !IsSubStr( m_e_trigger.script_linkto, "smash_unnamed_" ) )
		{
			m_e_linkto = GetEnt( m_e_trigger.script_linkto, "targetname" );
			
			// link trigger
			m_e_trigger EnableLinkTo();
			m_e_trigger LinkTo( m_e_linkto );
			
			// link clip
			foreach( e_clip in m_a_clip )
			{
				e_clip EnableLinkTo();
				e_clip LinkTo( m_e_linkto );
			}
		}
		*/

		setup_fxanims();
		parse_parameters();
		toggle_shader( true );
		
		thread main();
	}
	
	function set_trigger_func( func_trig, arg )
	{
		m_func_trig = func_trig;
		m_arg = arg;
	}
	
	// Process the (comma-separated) list of script_parameters.
	//
	// possible values:
	//       connect_paths - will connect paths when the smashable is smashed.
	//       any_damage - can be smashed by any type of damage
	//
	function private parse_parameters()
	{
		if ( !isdefined( m_e_trigger.script_parameters ) )
		{
			return;
		}
		
		a_params = StrTok( m_e_trigger.script_parameters, "," );
		foreach( str_param in a_params )
		{
			m_a_b_parameters[ str_param ] = true;
			if ( str_param == "connect_paths" )
			{
				add_callback( &zm_zod_smashables::cb_connect_paths );
			}
			else if ( str_param == "any_damage" )
			{
				foreach( e_clip in m_a_clip )
				{
					thread watch_all_damage( e_clip );
				}
			}
			else
			{
				/# AssertMsg( "Unknown script_parameter (" + str_param + ") on smashable (" + m_e_trigger.targetname + ")" ); #/
			}
		}
	}
	
	function has_parameter( str_parameter )
	{
		return ( isdefined( m_a_b_parameters[ str_parameter ] ) && m_a_b_parameters[ str_parameter ] );
	}
	
	function add_model( e_model )
	{
		if ( !isdefined( m_a_e_models ) ) m_a_e_models = []; else if ( !IsArray( m_a_e_models ) ) m_a_e_models = array( m_a_e_models ); m_a_e_models[m_a_e_models.size]=e_model;;
		if ( has_parameter( "any_damage" ) )
		{
			thread watch_all_damage( e_model );
		}
		
		// Refresh the shader.
		//
		toggle_shader( m_b_shader_on );
	}
	
	function private setup_fxanims()
	{
		s_bundle_inst = struct::get( m_e_trigger.target, "targetname" );
		if ( isdefined( s_bundle_inst ) && isdefined( s_bundle_inst.scriptbundlename ) )
		{
			if(!isdefined(level.zod_smashable_scriptbundles))level.zod_smashable_scriptbundles=[];
			if(!isdefined(level.zod_smashable_scriptbundles[ s_bundle_inst.scriptbundlename ]))level.zod_smashable_scriptbundles[ s_bundle_inst.scriptbundlename ]=s_bundle_inst.scriptbundlename;
			if( isdefined( m_e_linkto ) )
			{
				m_e_linkto scene::init( m_e_trigger.target, "targetname" );
			}
			else
			{
				level scene::init( m_e_trigger.target, "targetname" );
			}
			add_callback( &zm_zod_smashables::cb_fxanim );
		}
	}
	
	function private toggle_shader( b_shader_on )
	{
		foreach( e_model in m_a_e_models )
		{
			e_model clientfield::set( "bminteract", b_shader_on );
		}
		m_b_shader_on = b_shader_on;
	}
	
	function private main()
	{		
		m_e_trigger waittill( "trigger", who ); // wait until someone uses the trigger
		
		execute_callbacks();
		
		// Delete the clip *after* the callbacks fire, as some of the callbacks use the clip.
		//
		foreach( e_clip in m_a_clip )
		{
			e_clip Delete();
		}
		
		// Disable the interact shader.
		toggle_shader( false );

		// Set flag if specified.  This can be used to activate zones like doors
		if ( isdefined( m_e_trigger.script_flag_set ) )
		{
			level flag::set( m_e_trigger.script_flag_set );
		}
		
		// Run triggerable function
		if( isdefined( m_func_trig ) )
		{
			[[ m_func_trig ]]( m_arg );
		}
	}
	
	function private execute_callbacks()
	{
		foreach( s_cb in m_a_callbacks )
		{
			switch( s_cb.params.size )
			{
				case 0:
					self thread [[s_cb.fn]]();
					break;
				case 1:
					self thread [[s_cb.fn]]( s_cb.params[0] );
					break;
				case 2:
					self thread [[s_cb.fn]]( s_cb.params[0], s_cb.params[1] );
					break;
				case 3:
					self thread [[s_cb.fn]]( s_cb.params[0], s_cb.params[1], s_cb.params[2] );
					break;
			}
		}
	}
	
	function add_callback( fn_callback, param1, param2, param3 )
	{
		Assert( isdefined( fn_callback ) && IsFunctionPtr( fn_callback ) );
		
		s = SpawnStruct();
		s.fn = fn_callback;
		s.params = [];
		
		if ( isdefined( param1 ) )
		{
			if ( !isdefined( s.params ) ) s.params = []; else if ( !IsArray( s.params ) ) s.params = array( s.params ); s.params[s.params.size]=param1;;
		}
		
		if ( isdefined( param2 ) )
		{
			if ( !isdefined( s.params ) ) s.params = []; else if ( !IsArray( s.params ) ) s.params = array( s.params ); s.params[s.params.size]=param2;;
		}
		
		if ( isdefined( param3 ) )
		{
			if ( !isdefined( s.params ) ) s.params = []; else if ( !IsArray( s.params ) ) s.params = array( s.params ); s.params[s.params.size]=param3;;
		}
		
		if ( !isdefined( m_a_callbacks ) ) m_a_callbacks = []; else if ( !IsArray( m_a_callbacks ) ) m_a_callbacks = array( m_a_callbacks ); m_a_callbacks[m_a_callbacks.size]=s;;
	}
	
	function watch_all_damage( e_clip )
	{
		e_clip SetCanDamage( true );
		while ( true )
		{
			e_clip waittill( "damage", n_amt, e_attacker, v_dir, v_pos, str_type );
			if ( isdefined( e_attacker ) && IsPlayer( e_attacker ) && ( isdefined( e_attacker.beastmode ) && e_attacker.beastmode ) )
			{
				m_e_trigger notify( "trigger", e_attacker );
				break;
			}
		}
	}
}	
	
function __main__()
{
	level thread init_smashables();

	foreach( str_bundle in level.zod_smashable_scriptbundles )
	{
		scene::add_scene_func( str_bundle, &add_scriptbundle_models, "init" );
	}
}

function private smashable_from_scriptbundle_targetname( str_targetname )
{
	foreach( o_smash in level.zod_smashables )
	{
		if ( isdefined( o_smash.m_e_trigger.target ) && o_smash.m_e_trigger.target == str_targetname )
		{
			return o_smash;
		}
	}
	
	return undefined;
}

function private add_scriptbundle_models( a_models )
{
	o_smash = undefined;
	foreach( e_model in a_models )
	{
		if ( !isdefined( o_smash ) )
		{
			o_smash = smashable_from_scriptbundle_targetname( e_model._o_scene._e_root.targetname );
		}
		
		if ( isdefined( o_smash ) )
		{
			[[o_smash]]->add_model( e_model );
		}
	}
}

function private init_smashables()
{
	level.zod_smashables = [];
	a_smashable_triggers = GetEntArray( "beast_melee_only", "script_noteworthy" );
	
	n_id = 0;
	foreach( trigger in a_smashable_triggers )
	{
		str_id = "smash_unnamed_" + n_id;
		if ( isdefined( trigger.targetname ) )
		{
			str_id = trigger.targetname;
		}
		else
		{
			trigger.targetname = str_id;
			n_id++;
		}
		
		if ( isdefined( level.zod_smashables[ str_id ] ) )
		{
			/# AssertMsg( "Multiple smashables share the targetname \"" + str_id + "\"" ); #/
			continue;
		}
		
		o_smashable = new cSmashable();
		level.zod_smashables[ str_id ] = o_smashable;
		// set the portal activation function to trigger when one of the "portal" doors is smashed by the beast
		if ( IsSubStr( str_id, "portal" ) )
		{
			[[o_smashable]]->set_trigger_func( &zm_zod_portals::portal_open, str_id );
		}
		if ( IsSubStr( str_id, "memento" ) )
		{
			[[o_smashable]]->set_trigger_func( &zm_zod_quest::reveal_personal_item, str_id );
		}
		if ( IsSubStr( str_id, "beast_kiosk" ) )
		{
			[[o_smashable]]->set_trigger_func( &unlock_beast_kiosk, str_id );
		}
		if ( str_id === "unlock_quest_key" )
		{
			[[o_smashable]]->set_trigger_func( &unlock_quest_key, str_id );
		}
		[[o_smashable]]->init( trigger );
	}
}

function unlock_beast_kiosk( str_id )
{
	unlock_beast_trigger( "beast_mode_kiosk_unavailable", str_id );
	unlock_beast_trigger( "beast_mode_kiosk", str_id );
}

// self = trigger
function unlock_beast_trigger( str_targetname, str_id )
{
	triggers = GetEntArray( str_targetname, "targetname" );
	
	foreach( trigger in triggers )
	{
		if( trigger.script_noteworthy === str_id )
		{
			trigger.is_unlocked = true;
		}
	}
}

function unlock_quest_key( str_id )
{
	level.quest_key_can_be_picked_up = true;
}

// Add a callback to the smashable.
//
// self will be the smashable object (cSmashable).
//
function add_callback( targetname, fn_callback, param1, param2, param3 )
{
	o_smashable = level.zod_smashables[ targetname ];
	if ( !isdefined( o_smashable ) )
	{
		/# AssertMsg( "zm_zod_smashables::add_callback - No smashable with targetname \"" + targetname + "\" exists." ); #/
		return;
	}
	
	[[ o_smashable ]]->add_callback( fn_callback, param1, param2, param3 );
}




///////////////////////////////////////////////////
//                CUSTOM CALLBACKS               //
///////////////////////////////////////////////////



///////////////////////////////////////////////////
//               GENERIC CALLBACKS               //
///////////////////////////////////////////////////

function private cb_connect_paths()
{
	self.m_a_clip[0] ConnectPaths();
}

function private cb_fxanim()
{
	str_fxanim = self.m_e_trigger.target;
	level scene::play( str_fxanim, "targetname" );
}
