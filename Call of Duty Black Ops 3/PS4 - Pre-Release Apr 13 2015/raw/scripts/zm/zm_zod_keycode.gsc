    	   	                                                                                                                         	                                                                                                                                                                                                                                                                                                                                                                    	        	     	            	    	   	                           	                               	                                	                                                              	                                                                          	                            	                                     	                                       	                                                               	   	                  	       	                                                    	                   	                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                      	              	                  	                        	                                            	                                             	                                                   	                                                             	                                                         	                                                                    	                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                    	                                                              	                                                          	                                   	                                   	                                                    	                                       
                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                            	                                                                                                                                                                                                                                                                                                                                                                                       
                                                                                                                                                                                                                                                                                                                                                                                                                 	                                                                                                                                                                          	                                                                                         	                                                                                                                                                                                                                                                                                                                                                                                                                                        	                                                                                                                               	                                                                                                                                                                                                                                              	           

#using scripts\shared\array_shared;
#using scripts\shared\callbacks_shared;
#using scripts\shared\clientfield_shared;
#using scripts\shared\flag_shared;
#using scripts\shared\laststand_shared;
#using scripts\shared\system_shared;

#using scripts\zm\_zm_audio;
#using scripts\zm\_zm_laststand;
#using scripts\zm\_zm_score;
#using scripts\zm\_zm_spawner;
#using scripts\zm\_zm_unitrigger;
#using scripts\zm\_zm_utility;
#using scripts\shared\ai\zombie_death;
	
                                                                                       	                                
                                                                                                                               

#precache( "triggerstring", "ZM_ZOD_NUMBER_CLUE" );
#precache( "triggerstring", "ZM_ZOD_KEYCODE_ACTIVATE" );
#precache( "triggerstring", "ZM_ZOD_KEYCODE_INCREMENT_NUMBER" );
#precache( "triggerstring", "ZM_ZOD_KEYCODE_UNAVAILABLE" );
#precache( "triggerstring", "ZM_ZOD_KEYCODE_TRYING" );
#precache( "triggerstring", "ZM_ZOD_KEYCODE_SUCCESS" );
#precache( "triggerstring", "ZM_ZOD_KEYCODE_FAIL" );

#namespace zm_zod_keycode;

// number clue


// keycode input device


	// Number of digits in our code







#using_animtree( "generic" );

function autoexec __init__sytem__() {     system::register("zm_zod_keycode",&__init__,undefined,undefined);    }

function __init__()
{
}

function init()
{
	// get the keycode input device and readout
	e_keycode_input = GetEnt( "personal_item_canal_input", "targetname" );
	e_keycode_readout = GetEnt( "personal_item_canal_readout", "targetname" );
	
	// create the canal personal item keycode
	level.o_canal_keycode = new cKeyCode();
	[[ level.o_canal_keycode ]]->init( e_keycode_input, e_keycode_readout, &personal_item_canal_open_locker );
	
	// setup the clue-number models for the canal personal item keycode
	a_code = [[ level.o_canal_keycode ]]->get_code();
	a_mdl_clues = undefined;
	
	for( i = 0; i < 3; i++ )
	{
		mdl_clue_number = GetEnt( "personal_item_canal_clue_" + i, "targetname" );
		
		if( !isdefined( a_mdl_clues ) )
		{
			a_mdl_clues = array( mdl_clue_number );
		}
		else
		{
			a_mdl_clues[ a_mdl_clues.size ] = mdl_clue_number;
		}
	}

	[[ level.o_canal_keycode ]]->set_clue_numbers_for_code( a_mdl_clues ); // will associate the number models in a_mdl_clues with the default code index of 0
}

// sets a flag which opens the locker in the canal (listener function is in zm_zod_quest)
function personal_item_canal_open_locker()
{
	level flag::set( "personal_item_canal" );
}

/* ****************************************************************************
 * 	Keypanel class
 * ****************************************************************************/

class cKeyCode
{
	// triggers
	var m_t_use; // use-trigger for the keycode device
	var m_e_who; // player who has most recently activated the panel
	
	// model
	var m_mdl_readout; // the readout to show the current input number on
	var m_mdl_input; // the model for the input device
	var m_a_mdl_clues; // an array of clue-number model arrays that visually update to match the corresponding code
	var m_a_s_input_button_tags; // an array of structs that we generate from the tags on the keycode input device; used for doing line-of-sight checks when the player is using the keycode input trigger
	
	// sound
	var m_sfx_cycle; // sound to play when the button clicks and the number advances
	var m_sfx_activate; // sound to play when trying a code to see if it works
	var m_sfx_succeed; // response sound if the code was correct
	var m_sfx_fail; // response sound if the code input was incorrect
	
	// state / stats
	var m_a_current; // the current code input on the device - should show on the device's readout
	var m_a_codes; // an array of arrays, containing all the possible codes that can be used on this particular code-input device
	var m_a_funcs; // an array of func references, containing the functions to call when a code from the corresponding index in a_codes is input, and the activation button is pressed
	var m_n_device_state; // is the device UNAVAILABLE, AVAILABLE, TRYING a code, SUCCESS or FAIL?

	var m_b_discovered; // has any player discovered this yet? (used to trigger discovery VO)
	
	// init will create one randomized code; if this code is input, the flag passed in as str_flag will be set
	// mdl_input - the model of the input device - uses this to get the player inputs and update the stored number
	// mdl_readout - the model of the number readout - this is always updated to match the number stored in m_a_current
	// func_activate - function to run if the code at index 0 in the keycode device's array is input
	function init( mdl_input, mdl_readout, func_activate )
	{
		// set the models
		m_mdl_readout = mdl_readout;
		m_mdl_input = mdl_input;
		
		// start the input on the face
		m_a_current = array( 0, 0, 0, 0 );
		// generate one code
		m_a_codes = array( generate_random_code() );
		m_a_funcs = array( func_activate );
		
		// update keycode readout
		self thread update_readout_for_code();
		
		// setup keycode input device
		self create_keycode_input_tag_structs();
		self thread create_keycode_input_unitrigger();
		
		// set bools
		m_b_discovered = false;
		m_n_device_state = 1;
	}
	
	// return a code as an array
	function get_code( n_code_index = 0 )
	{
		a_code = m_a_codes[ n_code_index ];
		return a_code;
	}
	
	// return a single number from a given place index within a code
	function get_number_in_code( n_code_index, n_place_index )
	{
		return m_a_codes[ n_code_index ][ n_place_index ];
	}
	
	// returns the array of tags from the buttons on the input device - used by the unitrigger, since it has to call from outside the object
	function get_tags_from_input_device()
	{
		return m_a_s_input_button_tags;
	}
	
	function generate_random_code()
	{
		a_code = undefined;
		
		for( i = 0; i < 3; i++ )
		{
			if( !isdefined( a_code ) )
			{
				a_code = array( RandomIntRange( 0, 10 ) );
			}
			else
			{
				a_code[ a_code.size ] = RandomIntRange( 0, 10 );
			}
		}

		return a_code;
	}
	
	function add_code_function_pair( a_code, func_custom )
	{
		
	}
	
	// associates an array of clue number models with a code, so that the clue number models will always display the code
	function set_clue_numbers_for_code( a_mdl_clues, n_index = 0 )
	{
		if( !isdefined( m_a_mdl_clues ) )
		{
			m_a_mdl_clues = array( undefined );
		}
		m_a_mdl_clues[ n_index ] = a_mdl_clues;
		
		self thread create_clue_unitriggers_for_code( n_index ); // create a unitrigger for each clue number, to show the beastmode-only hint
		self thread update_clue_numbers_for_code( n_index );
	}
	
	// create a unitrigger for each clue number, to show the beastmode-only hint
	function create_clue_unitriggers_for_code( n_code_index )
	{
		// sets up a unitrigger for each place index within the specified code
		for( n_place_index = 0; n_place_index < 3; n_place_index++ )
		{
			self thread create_number_clue_unitrigger( n_code_index, n_place_index );
		}
	}
	
	// visually updates the readout with the current value of m_a_current
	function update_readout_for_code()
	{
		for( i = 0; i < 3; i++ )
		{
			for ( j = 0; j < 10; j++ )
			{
				m_mdl_readout HidePart( "J_" + i + "_" + j ); // have to hide all the parts individually
			}
			
			m_mdl_readout ShowPart( "J_" + i + "_" + m_a_current[ i ] ); // show the code number
		}
	}
	
	// visually updates the clue numbers associated with a given code index
	function update_clue_numbers_for_code( n_index = 0 )
	{
		a_code = m_a_codes[ n_index ];
		
		for( i = 0; i < 3; i++ )
		{
			mdl_clue_number = m_a_mdl_clues[ n_index ][ i ];

			for ( j = 0; j < 10; j++ )
			{
				mdl_clue_number HidePart( "J_" + j ); // have to hide all the parts individually
			}
			
			mdl_clue_number ShowPart( "J_" + a_code[ i ] ); // show the code number
		}
	}
	
	// increment n_place_index on the current input array, then update the readout on the device
	function increment_slot_of_current_input( n_place_index )
	{
		// increment slot, rolling over if necessary
		m_a_current[ n_place_index ]++;
		if( m_a_current[ n_place_index ] > 9 )
		{
			m_a_current[ n_place_index ] = 0;
		}
		
		// update readout
		self thread update_readout_for_code();
	}

	// activate the input device (try the current input code, and see if it triggers a function)
	function activate_input_device( trig_stub )
	{
		// show "trying..." hintstring, so we know that our input was accepted by the device and is being processed
		m_n_device_state = 2;
		trig_stub zm_unitrigger::run_visibility_function_for_all_triggers();
		wait 1.5;
		
		// iterate through all the codes in the device, and see if m_a_current matches any of them
		for( i = 0; i < m_a_codes.size; i++ )
		{
			// if the current code matches the input code...
			if( test_current_code_against_this_code( m_a_codes[ i ] ) )
			{
				m_n_device_state = 3;

				[[ m_a_funcs[ i ] ]](); // ...run the associated function from the function array
			}
		}
		
		if( m_n_device_state != 3 )
		{
			m_n_device_state = 4;
		}

		// show result hintstring for a few seconds
		trig_stub zm_unitrigger::run_visibility_function_for_all_triggers();
		wait 3;
		
		// make the device available again for further input
		m_n_device_state = 1;
	}
	
	// test a_code against m_a_current, returning true if the same, false otherwise
	function test_current_code_against_this_code( a_code )
	{
		for( i = 0; i < 3; i++ )
		{
			if( a_code[ i ] != m_a_current[ i ] )
			{
				return false;
			}
		}
		
		return true;
	}
	
	function create_keycode_input_unitrigger()
	{
		width = 128;
		height = 128;
		length = 128;
	
		m_mdl_input.unitrigger_stub = spawnstruct();
		m_mdl_input.unitrigger_stub.origin = m_mdl_input.origin;
		m_mdl_input.unitrigger_stub.angles = m_mdl_input.angles;
		m_mdl_input.unitrigger_stub.script_unitrigger_type = "unitrigger_box_use";
		m_mdl_input.unitrigger_stub.cursor_hint = "HINT_NOICON";
		m_mdl_input.unitrigger_stub.script_width = width;
		m_mdl_input.unitrigger_stub.script_height = height;
		m_mdl_input.unitrigger_stub.script_length = length;
		m_mdl_input.unitrigger_stub.require_look_at = false;
		m_mdl_input.unitrigger_stub.o_keycode = self;
		
		m_mdl_input.unitrigger_stub.prompt_and_visibility_func = &keycode_input_visibility;
		zm_unitrigger::register_static_unitrigger( m_mdl_input.unitrigger_stub, &keycode_input_trigger_think );
	}

	// spawns a unitrigger on the number clue model, so that when a beast mode player is near it they will get a localized string number hint
	// assumes that the code has been populated within m_a_codes, and the model for the number clue has been populated within m_a_mdl_clues
	// because this uses the index, it'll stay updated even when we cycle or change the underlying number
	// n_code_index - the index of the specific code within this keycode object that this number clue corresponds to
	// n_place_index - the place within the code that this specific number clue corresponds to
	function create_number_clue_unitrigger( n_code_index, n_place_index )
	{
		width = 256;
		height = 256;
		length = 256;
	
		mdl_number_clue = m_a_mdl_clues[ n_code_index ][ n_place_index ];
		mdl_number_clue.unitrigger_stub = spawnstruct();
		mdl_number_clue.unitrigger_stub.origin = mdl_number_clue.origin;
		mdl_number_clue.unitrigger_stub.angles = mdl_number_clue.angles;
		mdl_number_clue.unitrigger_stub.script_unitrigger_type = "unitrigger_box_use";
		mdl_number_clue.unitrigger_stub.cursor_hint = "HINT_NOICON";
		mdl_number_clue.unitrigger_stub.script_width = width;
		mdl_number_clue.unitrigger_stub.script_height = height;
		mdl_number_clue.unitrigger_stub.script_length = length;
		mdl_number_clue.unitrigger_stub.require_look_at = false;
		mdl_number_clue.unitrigger_stub.n_code_index = n_code_index; // pass this onto the unitrigger stub, so we can see the correctly updated number clue in the visibility thread
		mdl_number_clue.unitrigger_stub.n_place_index = n_place_index; // pass this onto the unitrigger stub, so we can see the correctly updated number clue in the visibility thread
		mdl_number_clue.unitrigger_stub.o_keycode = self;
		
		
		mdl_number_clue.unitrigger_stub.prompt_and_visibility_func = &number_clue_visibility;
		zm_unitrigger::register_static_unitrigger( mdl_number_clue.unitrigger_stub, &number_clue_trigger_think );
	}
	
	// show a number clue
	function number_clue_visibility( player )
	{
		b_is_invis = !( isdefined( player.beastmode ) && player.beastmode ); // is only visible if the player is in beastmode
		self setInvisibleToPlayer( player, b_is_invis );
		
		// get the current number
		n_code_index = self.stub.n_code_index;
		n_place_index = self.stub.n_place_index;
		n_number = [[ self.stub.o_keycode ]]->get_number_in_code( n_code_index, n_place_index );
		
		// display the updated number in the hintstring
		self SetHintString( &"ZM_ZOD_NUMBER_CLUE", n_number );
		
		return !b_is_invis;
	}
	
	function number_clue_trigger_think()
	{
		// do nothing for now; just using these unitriggers for the hint
	}

	// self is the unitrigger
	function keycode_input_visibility( player )
	{
		b_is_invis = ( isdefined( player.beastmode ) && player.beastmode );
		self setInvisibleToPlayer( player, b_is_invis );

		self thread keycode_input_prompt( player );
		
		return !b_is_invis;
	}
	
	// self is the unitrigger
	function keycode_input_prompt( player )
	{
		self endon("kill_trigger");
		player endon( "death_or_disconnect" );
		
		// figure out which of the five tags the player is facing
		CONST N_TAG_LOOKAT_DOT_MAX = 0.996;	// cos(5 degrees)
	
		str_hint = &"";
		str_old_hint = &"";
		
		// get the tag structs from the input device
		a_s_input_button_tags = [[ self.stub.o_keycode ]]->get_tags_from_input_device();
		
		while ( true )
		{
			// if the device is trying a code or responding to a code input, then just show that hintstring
			n_state = [[ self.stub.o_keycode ]]->get_keycode_device_state();
			switch( n_state )
			{
				case 2:
					str_hint = &"ZM_ZOD_KEYCODE_TRYING";
					break;
					
				case 3:
					str_hint = &"ZM_ZOD_KEYCODE_SUCCESS";
					break;
					
				case 4:
					str_hint = &"ZM_ZOD_KEYCODE_FAIL";
					break;
					
				case 0:
					str_hint = &"ZM_ZOD_KEYCODE_UNAVAILABLE";
					break;
					
				case 1:
					player.n_keycode_lookat_tag = undefined;
			
					// check to see if the player is looking at one of the tags
					n_closest_dot = N_TAG_LOOKAT_DOT_MAX;
					v_eye_origin = player GetPlayerCameraPos();
					v_eye_direction = AnglesToForward( player GetPlayerAngles() );
			
					// iterate through tags
					foreach( s_tag in a_s_input_button_tags )
					{
						v_tag_origin = s_tag.v_origin;
						v_eye_to_tag = VectorNormalize( v_tag_origin - v_eye_origin );
						n_dot = VectorDot( v_eye_to_tag, v_eye_direction );
						if ( n_dot > n_closest_dot )
						{
							n_closest_dot = n_dot;
							player.n_keycode_lookat_tag = s_tag.n_index;
						}
					}
		
					// determine the correct hintstring
					if( !isdefined( player.n_keycode_lookat_tag ) )
					{
						str_hint = &"";
					}
					else if( player.n_keycode_lookat_tag < 3 )
					{
						str_hint = &"ZM_ZOD_KEYCODE_INCREMENT_NUMBER";
					}
					else
					{
						str_hint = &"ZM_ZOD_KEYCODE_ACTIVATE";
					}
					
					break;
			}
			
			// update string only if necessary
			if ( str_old_hint != str_hint )
			{
				str_old_hint = str_hint;
				self.stub.hint_string = str_hint;
				
				if( str_hint === &"ZM_ZOD_KEYCODE_INCREMENT_NUMBER" )
				{
					self SetHintString( self.stub.hint_string, player.n_keycode_lookat_tag + 1 ); // add one for the string, since everything is base zero
				}
				else
				{
					self SetHintString( self.stub.hint_string );
				}
			}

			
			wait( 0.1 );
		}
	}
	
	// self = unitrigger
	function keycode_input_trigger_think()
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
			
			if( !( isdefined( [[ self.stub.o_keycode ]]->get_keycode_device_state() ) && [[ self.stub.o_keycode ]]->get_keycode_device_state() ) ) // ensure the keycode is available
			{			
				continue;			
			}

			if( !isdefined( player.n_keycode_lookat_tag ) )
			{
				continue;
			}

			[[ self.stub.o_keycode ]]->interpret_trigger_event( player, self.stub );
		}
	}

	function get_keycode_device_state()
	{
		return m_n_device_state;
	}
	
	// self = the keycode object (gets called from the unitrigger on the dereferenced keycode object, passing in the player who triggered the keycode device)
	// player - the player who triggered the keycode device
	// trig_stub - unitrigger stub of the keycode device
	function interpret_trigger_event( player, trig_stub )
	{
			m_n_device_state = 0;
			
			m_e_who = player; // record current user of panel, so it will be available to other functions on the object
			n_tag = player.n_keycode_lookat_tag;

			if( n_tag < 3 ) // increment a number slot
			{
				increment_slot_of_current_input( n_tag );
			}
			else // activate
			{
				activate_input_device( trig_stub );
			}
			
			wait 0.25;
			m_n_device_state = 1;
	}

	// creates an array of structs that the player's view will be checked against to determine which button the player is trying to press
	function create_keycode_input_tag_structs()
	{
		m_a_s_input_button_tags = []; // init the array of structs we'll use for line-of-sight checking
		
		a_tags = array( "btn_01", "btn_02", "btn_03", "btn_lrg" ); // activation button, then four buttons for each slot of the keycode
		
		i = 0;
		
		foreach( str_tag in a_tags )
		{
			s_tag = SpawnStruct();
			s_tag.v_origin = m_mdl_input GetTagOrigin( str_tag );
			s_tag.n_index = i; // ( buttons are indexed 0-2, to be consistent with other naming conventions; activation button is index 3)
			if ( !isdefined( m_a_s_input_button_tags ) ) m_a_s_input_button_tags = []; else if ( !IsArray( m_a_s_input_button_tags ) ) m_a_s_input_button_tags = array( m_a_s_input_button_tags ); m_a_s_input_button_tags[m_a_s_input_button_tags.size]=s_tag;;
			i++;
		}
	}
}
