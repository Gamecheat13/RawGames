#using scripts\codescripts\struct;

#using scripts\shared\ai_shared;
#using scripts\shared\clientfield_shared;
#using scripts\shared\fx_shared;
#using scripts\shared\flag_shared;
#using scripts\shared\hud_util_shared;
#using scripts\shared\laststand_shared;
#using scripts\shared\scene_shared;
#using scripts\shared\spawner_shared;
#using scripts\shared\statemachine_shared;
#using scripts\shared\system_shared;
#using scripts\shared\trigger_shared;
#using scripts\shared\util_shared;
#using scripts\shared\vehicle_death_shared;
#using scripts\shared\vehicle_shared;

#using scripts\cp\_util;
#using scripts\cp\_pickups;
#using scripts\cp\_laststand;

    	   	                                                                                                                                         	                                	                                                                                                                                                                                                                                                                                                                                                                    	        	     	             	    	   	               	                                              	                                                           	                               	                     	                                                                                                           	                                                                 	                                                              	                                                                                                              	                            	                                     	                                       	                                                                                                              	   	                  	       	                                                    	                   	                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                        	                                  	                                                                                        	           	                        	                                            	                                             	                                                   	                                                             	                                                         	                                                                    	                                                                                                                                                                                                    	                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                         	                                                              	                                                          	                                   	                                   	                                                    	                                       	                                           	     	                                                                                                                                                                                                                                                      	                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                     
                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                            	                           	                           	                                                                                                                                                                                                                                                            	                                                                                                                                                                                                                                                                                                                                                                                       
       

#using scripts\cp\_scoreevents;

#namespace pickups;



class cPickupItem : cBaseInteractable
{
	var m_e_model; // model
	var m_n_respawn_time; // how long to wait before the item should respawn
	var m_n_respawn_rounds; // how many rounds to wait before the item should respawn
	var m_n_throw_distance_min; // how far the item will be thrown if the player taps r-trigger
	var m_n_throw_distance_max; // how far the item will be thrown if the player holds r-trigger for m_n_throw_max_hold_duration
	var m_n_throw_max_hold_duration; // how long the player has to hold r-trigger to get the maximum throw distance
	var m_v_holding_offset_angle; // angle of the offset for the held item so it is visible on-screen (relative angular offset from the player's view)
	var m_n_holding_distance; // distance of the held item
	var m_v_holding_angle; // angle of the held item so it looks good in-hand
	var m_n_drop_offset; // height offset when dropped to place the model
	var m_fx_glow; // glow effect to play on pickup
	var m_n_despawn_wait; // how long to wait before despawning when sitting on the ground; if this is 0, ignore
	var m_v_respawn_origin; // origin to respawn at
	var m_v_respawn_angles; // angles to respawn at
	var m_custom_spawn_func; // custom spawn function
	var m_custom_despawn_func; // custom despawn function
	var m_str_pickup_hintstring; // hintstring to display when the item is on the ground
	var m_str_holding_hintstring; // hintstring to display when the item is in the player's hands
	
	constructor()
	{
		m_n_respawn_time = 1;
		m_n_respawn_rounds = 0;
		m_n_throw_distance_min = 128;
		m_n_throw_distance_max = 256;
		m_n_throw_max_hold_duration = 2;
		m_v_holding_angle = ( 0, 0, 0 );
		m_n_despawn_wait = 0;
		m_v_holding_offset_angle = ( 45, 0, 0 );
		m_n_holding_distance = 64;
		m_n_drop_offset = 0;
		m_iscarryable = true;
		// carry
		a_carry_threads = [];
		a_carry_threads[0] = &carry_pickupitem;
		// drop
		a_drop_funcs = [];
		a_drop_funcs[0] = &drop_pickupitem;
	}

	function get_model()
	{
		if( isdefined( m_e_carry_model ) )
		{
			return m_e_carry_model;
		}
		else if( isdefined( m_e_model ) )
		{
			return m_e_model;
		}
//		else
//		{
//			AssertMsg( "cPickupItem->get_model() missing model!" );
//		}
		return undefined;
	}

	function spawn_at_struct( str_struct )
	{
		if ( !isdefined( str_struct.angles ) )
		{
			str_struct.angles = (0,0,0);
		}

		respawn_loop( str_struct.origin, str_struct.angles );
	}

	function spawn_at_position( v_pos, v_angles )
	{
		respawn_loop( v_pos, v_angles );
	}

	function respawn_loop( v_pos, v_angles )
	{
		while( true )
		{
			if ( isdefined( m_custom_spawn_func ) )
			{
				[[ m_custom_spawn_func ]]( v_pos, v_angles );
			}
			else
			{
				m_str_holding_hintstring = "Press ^3[{+usereload}]^7 to drop " + m_str_itemname;
				pickupitem_spawn( v_pos, v_angles );
			}
			
			self waittill( "respawn_pickupitem" );
			pickupitem_respawn_delay();
		}
	}
	
	function pickupitem_spawn( v_pos, v_angles )
	{
		// create model if it doesn't exist
		if ( !isdefined( m_e_model ) )
		{
			m_e_model = util::spawn_model( m_str_modelname, v_pos + (0,0,m_n_drop_offset), v_angles );
			m_e_model NotSolid();
			
			// only spawn glow fx when model is created
			if ( isdefined( m_fx_glow ) )
			{
				PlayFXOnTag( m_fx_glow, m_e_model, "tag_origin" );
			}
		}
		m_str_pickup_hintstring = "Press and hold ^3[{+activate}]^7 to pick up " + m_str_itemname;

		// add body trigger (shared for carry and repair functionality)
		if( !isdefined( m_e_body_trigger ) )
		{
			e_trigger = spawn_body_trigger( v_pos );
			set_body_trigger( e_trigger );
		}
		m_e_body_trigger SetVisibleToAll();
		m_e_body_trigger.origin = v_pos;
		m_e_body_trigger notify( "upgrade_trigger_moved" );
		m_e_body_trigger notify( "upgrade_trigger_enable", true );

		m_e_body_trigger SetHintString( m_str_pickup_hintstring );
		m_e_body_trigger.str_itemname = m_str_itemname;
		
		// add targetname to trigger
		if ( !IsDefined( m_e_body_trigger.targetname ) )
		{
			m_str_targetname = "";
			
			m_a_str_targetname = StrTok( ToLower( m_str_itemname ), " " );
			foreach ( n_index, m_str_targetname_piece in m_a_str_targetname )
			{
				if ( n_index > 0 )
				{
					m_str_targetname += "_";
				}
				
				m_str_targetname += m_str_targetname_piece;
			}			
			
			m_e_body_trigger.targetname = "trigger_" + m_str_targetname;
		}
			
		// carry thread
		if ( m_iscarryable )
		{
			self thread cBaseInteractable::thread_allow_carry();
		}
		
	}
	
	// start preparing to despawn item if a despawn timer or condition has been set
	// thread to despawn dropped item after m_n_despawn_wait seconds, if m_n_despawn_wait > 0
	function pickupitem_despawn_timer()
	{
		self endon( "cancel_despawn" );
		
		if ( m_n_despawn_wait <= 0 )
		{
			return;
		}
		
		// start m_n_despawn_wait countdown
		self thread debug_despawn_timer();
		wait m_n_despawn_wait;
		
		// if countdown ends, run despawn func
		if ( isdefined( m_custom_despawn_func ) )
		{
			[[ m_custom_despawn_func ]]();
		}
		else
		{
			pickupitem_despawn();
		}
	}
	
	function debug_despawn_timer()
	{
		self endon( "cancel_despawn" );
		
		n_time_remaining = m_n_despawn_wait;
		while ( ( n_time_remaining >= 0 ) && isdefined( m_e_model ) )
		{
			/# Print3D( m_e_model.origin + ( 0, 0, 15 ), n_time_remaining, ( 1, 0, 0 ), 1, 1, 20 ); #/	//draw for 1 sec (20fps)
			wait 1;
			n_time_remaining -= 1;
		}
	}
	
	function pickupitem_despawn()
	{
		self notify( "respawn_pickupitem" ); // spawn another item
	}

	function pickupitem_respawn_delay()
	{
		if ( m_n_respawn_rounds > 0 )
		{
			// wait m_n_respawn_rounds number of rounds, then m_n_respawn_time from the start of the round
			// if the round ends before m_n_respawn_time, make the pickup immediately accessible on the next round start
		}
		else if ( m_n_respawn_time > 0 )
		{
			wait m_n_respawn_time;
		}
	}
	
	// carry
	function carry_pickupitem( e_triggerer )
	{
		// delete 
		m_e_model Delete();
		m_e_body_trigger SetInvisibleToAll();
	}
	
	// drop
	function drop_pickupitem( e_triggerer )
	{
		pickupitem_spawn( e_triggerer.origin, e_triggerer.angles );
	}
}


// base class for interaction with items (repair, hacking, etc.)
class cBaseInteractable
{
	var m_e_body_trigger; // trigger on the object itself; used for detecting repair items and for pick-up on player UseButton
	var m_n_body_trigger_radius; // radius of the body trigger
	var m_n_body_trigger_height; // height of the body trigger
		
	var m_str_modelname; // model name

	// repair interaction
	var m_isfunctional; // is this thing currently intact? (otherwise, needs repair)
	var m_repair_complete_func; // function to call after completed
	var m_repair_custom_complete_func; // custom function to call after completed (set by inheriting class to do class-specific things)
	var m_n_repair_radius; // how close the player must be
	var m_n_repair_height; // height of the trigger
	
	// hacking interaction
	var m_ishackable; // is this thing currently hackable?
	var m_e_hack_trigger; // the hack trigger
	var m_hack_custom_complete_func; // custom function to call after completed (set by inheriting class to do class-specific things)
	var m_progress_bar; // progress bar for hack
	var m_str_team; // team name
	
	// carry interaction
	var m_iscarryable; // is this thing currently carryable?
	var a_carry_threads; // threads called when the item is carried
	var a_drop_funcs; // threads called when the item is dropped
	var m_e_carry_model; // model shown to represent the carried item
	var m_str_carry_model; // name of the carry model to load
	var m_v_holding_offset_angle; // angle of the offset for the held item so it is visible on-screen (relative angular offset from the player's view)
	var m_n_holding_distance; // distance of the held item
	var m_v_holding_angle; // angle of the held item so it looks good in-hand
	var m_n_drop_offset; // height offset when dropped to place the model
	var m_str_itemname; // string name of the item (used for inventory checks)
	var m_e_player_currently_holding; // who is currently holding the item?
	var m_allow_carry_custom_conditions_func; // can define for custom conditional check for whether the item can be picked up
	
	// prompts
	var m_prompt_manager_custom_func; // define in inherited classes for custom prompt conditions

	constructor()
	{
		// default interaction settings
		m_isfunctional = true; // things are functional (not in need of repair) by default
		m_ishackable = false; // hacking is disabled by default; must be enabled on inherited class or on instance
		m_iscarryable = false; // carrying is disabled by default; must be enabled on inherited class or on instance

		// body trigger setup
		m_n_body_trigger_radius = 36;
		m_n_body_trigger_height = 128;
		
		// "repair interaction" default settings
		m_n_repair_radius = 72;
		m_n_repair_height = 128;
		m_repair_complete_func = &repair_completed; // default completion function (can be overridden by inherited class, if the inherited class needs to deviate from the common consequences)
		
		m_str_itemname = "Item";
	}

	// *******************************************************************************************************
	// ACCESSORS
	// *******************************************************************************************************

	function get_player_currently_holding()
	{
		return m_e_player_currently_holding;
	}

	// *******************************************************************************************************
	// PROMPT MANAGER
	// *******************************************************************************************************
	
	// monitors the condition of the interactable object to display the correct prompt when the player is within m_e_body_trigger
	function prompt_manager()
	{
		// first pass - update hint strings on trigger (next pass will use hud elements for everything)
		
		if( isdefined( m_prompt_manager_custom_func ) )
		{
			self thread [[ m_prompt_manager_custom_func ]]();
		}
		else
		{
			while( isdefined( m_e_body_trigger ) )
			{
				if( !m_isfunctional ) // need to repair, overrides everything
				{
					m_e_body_trigger SetHintString( "Bring Toolbox to repair" );
					{wait(.05);};
					continue;
				}
				
				{wait(.05);};
			}
		}
	}

	// *******************************************************************************************************
	// INTERACTION: REPAIR
	// *******************************************************************************************************
	function repair_completed( player )
	{
		self notify( "repair_completed" );
				
		if( isdefined( m_repair_custom_complete_func ) )
		{
			self thread [[ m_repair_custom_complete_func ]]( player );
		}
	}
	
	function repair_trigger()
	{
		self endon( "unmake" );
		
		while( true ) // can now repair at any time
		{
			m_e_body_trigger waittill( "trigger", player );
			
			// does player have toolbox?
			if( ( isdefined( player.is_carrying_pickupitem ) && player.is_carrying_pickupitem ) && ( player.o_pickupitem.m_str_itemname == "Toolbox" ) )
			{
				// expend toolbox
				[[ player.o_pickupitem ]]->remove( player );

				// custom repair function
				[[ m_repair_complete_func ]]( player );
			}
			
			{wait(.05);};
		}
	}


	// *******************************************************************************************************
	// INTERACTION: CARRYING
	// *******************************************************************************************************
	
	function set_body_trigger( e_trigger )
	{
		Assert( !isdefined( m_e_body_trigger ) );
		m_e_body_trigger = e_trigger;
	}

	function enable_carry()
	{
		m_iscarryable = true;
		self thread thread_allow_carry();
	}

	function disable_carry()
	{
		m_iscarryable = false;
		self notify( "thread_allow_carry" );
	}
	
	function thread_allow_carry()
	{
		self notify( "thread_allow_carry" );
		self endon( "thread_allow_carry" );
		self endon( "unmake" );
		
		while( true )
		{
			{wait(.05);};
			
			if( !isdefined( m_e_body_trigger ) )
			{
				return;
			}
			
			m_e_body_trigger waittill( "trigger", e_triggerer );
			
			// before anything else, set the hint string per player to not show the prompt, if the player is carrying something
			if( ( isdefined( e_triggerer.is_carrying_pickupitem ) && e_triggerer.is_carrying_pickupitem ) )
			{
				m_e_body_trigger SetHintStringForPlayer( e_triggerer, "" );
				continue;
			}
			
			if( !m_iscarryable )
			{
				continue;
			}
			
			if ( ( isdefined( e_triggerer.disable_object_pickup ) && e_triggerer.disable_object_pickup ) )
			{
				continue;
			}
			
			if( !e_triggerer util::use_button_held() )
			{
				continue;
			}
			
			// check m_allow_carry_custom_conditions_func, if it has been defined
			if( isdefined( m_allow_carry_custom_conditions_func ) && ![[ m_allow_carry_custom_conditions_func ]]() )
			{
				continue;
			}
			
			if( !isdefined( m_e_body_trigger ) )
			{
				return;
			}
			
			// make sure player is still inside the trigger after debounce
			if( !e_triggerer IsTouching( m_e_body_trigger ) )
			{
				continue;
			}
			
			// make sure the triggerer is not already carrying a pickup item
			if( ( isdefined( e_triggerer.is_carrying_pickupitem ) && e_triggerer.is_carrying_pickupitem ) )
			{
				continue;
			}
			
			if ( e_triggerer laststand::player_is_in_laststand() )
			{
				continue;
			}
			
			e_triggerer.is_carrying_pickupitem = true;			
			self thread carry( e_triggerer ); // carry the item

			return; // end thread, since the object has been picked up
		}
	}

	function carry( e_triggerer )
	{
		e_triggerer endon( "death" );
		e_triggerer endon( "player_downed" );
		
		e_triggerer.o_pickupitem = self;
		m_e_player_currently_holding = e_triggerer;
		
		m_e_body_trigger notify( "upgrade_trigger_enable", false );
		
		// TODO clear carry hint here, so it is blank while no command is available
		self notify( "cancel_despawn" );
		
		e_triggerer DisableWeapons(); // take away weapons
		// TODO disable slide
		wait 0.5; // let weapon drop away to the side before removing	
		
		// run threads defined in custom spawn func on the inherited class
		if( isdefined( a_carry_threads ) )
		{
			foreach( carry_thread in a_carry_threads )
			{
				self thread [[ carry_thread ]]( e_triggerer ); // e_triggerer is passed into every item-carry thread
			}
		}
		else // default stuff
		{
			e_triggerer AllowJump( false );
		}

		// "how to drop" prompt
		self thread show_drop_prompt( e_triggerer );
		
		// 	show carry model, now that the object is done being picked up
		self thread show_carry_model( e_triggerer );
		// only allow dropping after the object is done being picked up
		self thread thread_allow_drop( e_triggerer );
	}
	
	function get_drop_prompt()
	{
		return "Press ^3[{+usereload}]^7 to drop " + m_str_itemname;
	}
	
	function show_drop_prompt( player )
	{
		player util::screen_message_create_client( get_drop_prompt() );
	}

	function flash_drop_prompt( player )  // self = player
	{
		self endon( "death" );
		player endon( "death" );
		player endon( "stop_flashing_drop_prompt" );
		
		const FLASH_TIME = 0.35;
		
		while ( true )
		{
			player util::screen_message_create_client( get_drop_prompt(), undefined, undefined, 0, FLASH_TIME );
			
			wait FLASH_TIME;
		}		
	}
	
	function flash_drop_prompt_stop( player )  // self = player
	{
		player notify( "stop_flashing_drop_prompt" );
		
		player util::screen_message_delete_client();
	}
	
	function thread_allow_drop( e_triggerer )
	{
		e_triggerer endon( "restore_player_controls_from_carry" );
		e_triggerer endon( "death" );
		e_triggerer endon( "player_downed" );

		self thread drop_on_death( e_triggerer );
			
		// make sure use button has been released before allowing drop
		while ( e_triggerer UseButtonPressed() )
		{
			{wait(.05);};
		}			
		
		while( !e_triggerer UseButtonPressed() )
		{
			{wait(.05);};
		}
		
		self thread drop( e_triggerer );		
	}

	function show_carry_model( e_triggerer )
	{
		e_triggerer endon( "restore_player_controls_from_carry" );
		e_triggerer endon( "death" );
		e_triggerer endon( "player_downed" );
	
		// spawn m_e_carry_model
		v_eye_origin = e_triggerer GetEye();
		v_player_angles = e_triggerer GetPlayerAngles();
		v_player_angles += m_v_holding_offset_angle;
		v_player_angles = AnglesToForward( v_player_angles );
		
		v_angles = e_triggerer.angles + m_v_holding_angle;
		v_origin = v_eye_origin + ( v_player_angles * m_n_holding_distance );

		if( !isdefined( m_str_carry_model ) )
		{
			if ( isdefined( m_str_modelname ) )
			{
				m_str_carry_model = m_str_modelname;
			}
			else
			{
				m_str_carry_model = "script_origin";
			}
		}
        m_e_carry_model = util::spawn_model( m_str_carry_model, v_origin, v_angles );
        m_e_carry_model NotSolid();
			
        while( isdefined( m_e_carry_model ) )
		{
			v_eye_origin = e_triggerer GetEye();
			v_player_angles = e_triggerer GetPlayerAngles();
			v_player_angles += m_v_holding_offset_angle;
			v_player_angles = AnglesToForward( v_player_angles );
			
			m_e_carry_model.angles = e_triggerer.angles + m_v_holding_angle;
			m_e_carry_model.origin = v_eye_origin + ( v_player_angles * m_n_holding_distance );
			{wait(.05);};
		}
	}

	function restore_player_controls_from_carry( e_triggerer )
	{
		e_triggerer endon( "death" );
		e_triggerer endon( "player_downed" );
		
		// check if player is carrying an item
		if ( !e_triggerer.is_carrying_pickupitem )
		{
			return;
		}
		
		e_triggerer notify( "restore_player_controls_from_carry" );

//		// debounce
//		while ( e_triggerer ChangeSeatButtonPressed() )
//		{
//			WAIT_SERVER_FRAME;
//		}

		// restore stowed weapon
		e_triggerer EnableWeapons();
		e_triggerer.is_carrying_pickupitem = false;

		// player movement
		e_triggerer AllowJump( true );
		// TODO disable slide
	}
	
	function drop( e_triggerer ) // triggered when player switched weapon to drop the crate
	{
		restore_player_controls_from_carry( e_triggerer ); // restore player's weapon and controls
		e_triggerer util::screen_message_delete_client();
		if ( isdefined( m_e_carry_model ) ) { m_e_carry_model Delete(); }; // delete the item
		
		// run threads defined in custom spawn func on the inherited class
		if( isdefined( a_drop_funcs ) )
		{
			foreach( drop_func in a_drop_funcs )
			{
				[[ drop_func ]]( e_triggerer ); // e_triggerer is passed into every item-drop thread
			}
		}

		m_e_player_currently_holding = undefined;
		self thread thread_allow_carry(); // reallow carrying
		
		e_triggerer thread wait_for_button_release();
	}
	
	function remove( e_triggerer ) // triggered when player expends item (deletes it and sets the flag to spawn another)
	{
		restore_player_controls_from_carry( e_triggerer ); // restore player's weapon and controls
		e_triggerer util::screen_message_delete_client();
		if ( isdefined( m_e_carry_model ) ) { m_e_carry_model Delete(); }; // delete the item
		// TODO // clear prompt while no command is available
		m_e_player_currently_holding = undefined;
		self notify( "respawn_pickupitem" ); // spawn another item
	}

	function destroy() // destroy the item without respawning it
	{
		if ( isdefined( m_e_player_currently_holding ) )
		{
			restore_player_controls_from_carry( m_e_player_currently_holding ); // restore player's weapon and controls
			m_e_player_currently_holding util::screen_message_delete_client();
		}
		
		if ( isdefined( m_e_carry_model ) ) { m_e_carry_model Delete(); };
		
		m_e_player_currently_holding = undefined;
	}
	
	function wait_for_button_release()  // self = player
	{
		self endon( "death_or_disconnect" );
		
		self.disable_object_pickup = true;
		
		self _wait_for_button_release();
		
		self.disable_object_pickup = undefined;
	}
	
	function _wait_for_button_release()  // self = player
	{
		self endon( "player_downed" );
		
		while ( self UseButtonPressed() )
		{
			{wait(.05);};
		}
	}
	
	// drop item if the player dies or is downed
	function drop_on_death( e_triggerer )
	{
		self notify( "drop_on_death" );
		self endon( "drop_on_death" );
		
		e_triggerer util::waittill_any( "player_downed", "death" );
		
		if ( isdefined( m_e_player_currently_holding ) )
		{
			drop( e_triggerer );
		}
	}

	// *******************************************************************************************************
	// TRIGGERS
	// *******************************************************************************************************
	
	// spawn repair trigger
	function spawn_repair_trigger( v_origin )
	{
		e_repair_trigger = spawn_interact_trigger( v_origin, m_n_repair_radius, m_n_repair_height, "Bring Toolbox to repair" );
		return e_repair_trigger;
	}
	
	function spawn_body_trigger( v_origin )
	{
		e_trigger = spawn_interact_trigger( v_origin, m_n_body_trigger_radius, m_n_body_trigger_height, "" );
		e_trigger SetHintLowPriority( true );
		return e_trigger;
	}
	
	// generic trigger spawn function for turret interactions (pickup items, hacking, etc.)
	function spawn_interact_trigger( v_origin, n_radius, n_height, str_hint )
	{
		Assert( isdefined( v_origin ), "spawn_interact_trigger - v_origin not defined" );
		Assert( isdefined( n_radius ), "spawn_interact_trigger - n_radius not defined" );
		Assert( isdefined( n_height ), "spawn_interact_trigger - n_height not defined" );
		
		e_trigger = spawn( "trigger_radius", v_origin, 0, n_radius, n_height );
		e_trigger TriggerIgnoreTeam();
		e_trigger SetVisibleToAll();
		e_trigger SetTeamForTrigger( "none" );
		e_trigger SetCursorHint( "HINT_NOICON" );
		if ( isdefined( str_hint ) )
		{
			e_trigger SetHintString( str_hint );
		}
		
		return e_trigger;
	}

}


