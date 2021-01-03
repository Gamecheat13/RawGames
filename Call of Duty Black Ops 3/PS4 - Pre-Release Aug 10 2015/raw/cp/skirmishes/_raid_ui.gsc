#using scripts\codescripts\struct;

#using scripts\shared\array_shared;
#using scripts\shared\util_shared;
#using scripts\shared\hud_util_shared;
#using scripts\shared\flag_shared;
#using scripts\shared\system_shared;
#using scripts\cp\_objectives;

#using scripts\cp\gametypes\_globallogic;
#using scripts\cp\gametypes\_globallogic_score;

    	   	                                                                                                                                         	                                	                                                                                                                                                                                                                                                                                                                                                                    	        	     	             	    	   	               	                                              	                                                           	                               	                     	                                                                                                           	                                                                 	                                                              	                                                                                                              	                            	                                     	                                       	                                                                                                              	   	                  	       	                                                    	                   	                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                        	                                  	                                                                                        	           	                        	                                            	                                             	                                                   	                                                             	                                                         	                                                                    	                                                                                                                                                                                                    	                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                         	                                                              	                                                          	                                   	                                   	                                                    	                                       	                                           	     	                                                                                                                                                                                                                                                      	                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                     




	
#precache( "material", "waypoint_targetneutral" );
#precache( "material", "raid_token" );

#namespace raid_ui;

class cRaidUIObjective
{
	var m_str_text;
	var m_n_timer;
	var m_b_timer_paused;
	var m_n_counter;
	var m_str_counter_label;
	var m_b_active;
	var m_n_parent_id;
	var m_n_index;
	
	constructor()
	{
		m_str_text = "";
		m_n_timer = undefined;
		m_b_paused = false;
		m_n_counter = undefined;
		m_str_counter_label = "seconds";
		m_b_active = false;
		m_n_parent_id = undefined;
		m_n_index = undefined;
	}
	
	function init( n_index, str_objective )
	{
		m_n_index = n_index;
		m_str_text = str_objective;
	}
	
	function restore_for_connecting_player( player )
	{
		if ( ( isdefined( m_b_active ) && m_b_active ) )
		{
			if ( isdefined(m_n_parent_id))
			{
				add_sub_objective_for_player( player, m_n_parent_id );
			} else {
				set_for_player( player, "" );
			}
			
			if ( IsDefined( m_n_timer ) )
			{
				add_timer_for_player( player );
			}
			
			if ( IsDefined( m_n_counter ) )
			{
				add_counter_for_player( player );
			}
		}
	}
	
	function set_for_player( player, str_override_onscreen_message, str_round_msg )
	{
		if ( level flag::get( "raid_game_over" ) )
		{
			return;
		}
	
		if ( !IsDefined( player.raid_obj_list ) )
		{
			player.raid_obj_list = [];
		}
		
		s_obj = SpawnStruct();
		s_obj flag::init( "is_docked", false );
		
		n_index = player.raid_obj_list.size;
		player.raid_obj_list[n_index] = s_obj;
		n_y_pos = _get_y_pos_from_element_index( n_index );
		s_obj.hud_elem = player raid_ui::_create_client_hud_elem( "right", "top", "right", "top", -10, n_y_pos, 1.5, (1.0,1.0,1.0) );
		s_obj.objective_id = m_n_index;
		s_obj.type = "primary";	
		s_obj.hud_elem SetText( m_str_text );
		s_obj.hud_elem.alpha = 0.0;
		s_obj.hud_elem.color = (1.0, 1.0, 0.0);		// yellow for primary objectives.
		
		if ( !isdefined( str_override_onscreen_message ) || str_override_onscreen_message != "" )
		{
			player notify( "new_objective_displayed" );
			
			x = 0;
			y = -100;
			
			if ( isdefined( str_round_msg ) )
			{
				y = 0;
				s_obj.hud_elem_round = player raid_ui::_create_client_hud_elem( "center", "bottom", "center", "middle", x, y, 4, (1.0, 1.0, 0.0) );
				s_obj.hud_elem_round SetText( str_round_msg );
				
				s_obj.hud_elem_big = player raid_ui::_create_client_hud_elem( "center", "top", "center", "middle", x, y, 2, (1.0,1.0,0.0) );
			} else {
				s_obj.hud_elem_big = player raid_ui::_create_client_hud_elem( "center", "middle", "center", "middle", x, y, 2, (1.0,1.0,0.0) );
			}
			
			if ( IsDefined( str_override_onscreen_message ) )
			{
				s_obj.hud_elem_big SetText( str_override_onscreen_message );
			} else {
				s_obj.hud_elem_big SetText( m_str_text );
			}
			
			b_animate_over = !isdefined( str_override_onscreen_message );
			thread _remove_objective_big_text( player, s_obj, b_animate_over );
		} else {
			s_obj.hud_elem.alpha = 1.0;
			s_obj flag::set( "is_docked" );
		}
	}
	
	function add_counter_for_player( player )
	{
		if ( level flag::get( "raid_game_over" ) )
		{
			return;
		}
		
		for ( i = 0; i < player.raid_obj_list.size; i++ )
		{
			s_obj = player.raid_obj_list[i];
			if ( s_obj.objective_id == m_n_index && (s_obj.type == "primary" || s_obj.type == "sub") )
			{
				strlen = m_str_counter_label.size;
				n_scale = 1.5;
				
				if ( IsDefined( s_obj.parent_objective_id ) )
				{
					n_scale = 1.2;
				}
				
				s_counter = spawnstruct();
				n_index = i + 1;
				ArrayInsert( player.raid_obj_list, s_counter, n_index );
				s_counter.hud_elem = player raid_ui::_create_client_hud_elem( "right", "top", "right", "top", 0, 0, n_scale, (1.0,1.0,1.0) );
				s_counter.objective_id = m_n_index;
				s_counter.hud_elem SetValue( m_n_counter );
				s_counter.type = "counter";
				
				s_counter.hud_elem2 = player raid_ui::_create_client_hud_elem( "left", "top", "right", "top", 0, 0, n_scale, (1.0,1.0,1.0) );
				s_counter.hud_elem2 SetText( m_str_counter_label );
				
				text_width = s_counter.hud_elem2 GetTextWidth();
				x_pos = -10 - (text_width);
				
				s_counter.hud_elem.x = x_pos - 5;
				s_counter.hud_elem2.x = x_pos;
				
				if ( IsDefined( s_obj.parent_objective_id ) )
				{
					s_counter.parent_objective_id = s_obj.parent_objective_id;
				}
				
				thread _hud_elem_fade_in( s_counter, s_obj );
			}
		}
		
		// Update all the hud elements.
		_update_positions_for_player( player, true );
	}
	
	function add_timer_for_player( player, str_label = "seconds" )
	{
		if ( level flag::get( "raid_game_over" ) )
		{
			return;
		}
		
		for ( i = 0; i < player.raid_obj_list.size; i++ )
		{
			s_obj = player.raid_obj_list[i];
			if ( s_obj.objective_id == m_n_index && (s_obj.type == "primary" || s_obj.type == "sub") )
			{
				x_pos = str_label.size * -8;
				
				s_timer = spawnstruct();
				n_index = i + 1;
				
				n_scale = 1.5;
				
				if ( IsDefined( s_obj.parent_objective_id ) )
				{
					n_scale = 1.2;
				}
				
				ArrayInsert( player.raid_obj_list, s_timer, n_index );
				s_timer.hud_elem = player raid_ui::_create_client_hud_elem( "right", "top", "right", "top", x_pos, 0, n_scale, (1.0,1.0,1.0) );
				s_timer.objective_id = m_n_index;
				s_timer.hud_elem SetValue( m_n_timer );
				s_timer.type = "timer";
				
				s_timer.hud_elem2 = player raid_ui::_create_client_hud_elem( "left", "top", "right", "top", x_pos + 5, 0, n_scale, (1.0,1.0,1.0) );
				s_timer.hud_elem2 SetText( "seconds" );
				
				if ( IsDefined( s_obj.parent_objective_id ) )
				{
					s_timer.parent_objective_id = s_obj.parent_objective_id;
				}
				
				player thread _process_timer_for_player( s_timer );
				
				thread _hud_elem_fade_in( s_timer, s_obj );
			}
		}
		
		// Update all the hud elements.
		_update_positions_for_player( player, true );
	}
	
	function add_sub_objective_for_player( player, parent_id )
	{
		if ( level flag::get( "raid_game_over" ) )
		{
			return;
		}
		
		// Look from bottom to top so we add it to the end of the list of sub-objectives.
		//
		n_insert_after = undefined;
		for ( i = player.raid_obj_list.size-1; i >= 0 ; i-- )
		{
			s_obj = player.raid_obj_list[i];
			
			if ( !isdefined( n_insert_after ) )
			{
				b_insert_after = (isdefined(s_obj.parent_objective_id) && s_obj.parent_objective_id == parent_id );
				if ( b_insert_after )
				{
					n_insert_after = i;
				}
			}
			
			if ( s_obj.objective_id == parent_id && s_obj.type == "primary" )
			{
				if ( !isdefined( n_insert_after ) )
				{
					n_insert_after = i;
				}
				
				s_sub = spawnstruct();
				s_sub flag::init( "is_docked", false );
				s_sub.type = "sub";
				n_index = n_insert_after + 1;
				ArrayInsert( player.raid_obj_list, s_sub, n_index );
				
				n_y_pos = _get_y_pos_from_element_index( n_index );
				s_sub.hud_elem = player raid_ui::_create_client_hud_elem( "right", "top", "right", "top", -10, n_y_pos, 1.2, (1.0,1.0,1.0) );
				s_sub.hud_elem SetText( m_str_text );
				
				s_sub.objective_id = m_n_index;
				s_sub.parent_objective_id = parent_id;
				
				thread _hud_elem_fade_in( s_sub, s_obj );
			}
		}
		
		// Update all the hud elements.
		_update_positions_for_player( player, true );
	}
	
	function complete_for_player( player, color )
	{
		if ( !isdefined(color) )
		{
			color = (0.25, 0.25, 0.25);
		}
		
		b_leave_sub_objectives = true;
		
		for ( i = 0; i < player.raid_obj_list.size; i++ )
		{
			s_obj = player.raid_obj_list[i];
			b_is_child = (isdefined(s_obj.parent_objective_id) && s_obj.parent_objective_id == m_n_index);
			
			if (b_is_child && s_obj.type == "sub")
			{
				b_leave_sub_objectives = false;
			}
			
			if ( s_obj.objective_id == m_n_index || b_is_child )
			{
				s_obj.hud_elem.color = color;
				
				if ( isdefined( s_obj.hud_elem2 ) )
				{
					s_obj.hud_elem2.color = color;
				}
			}
		}
		
		util::delay( 5.0, undefined, &remove_for_player, player, undefined, b_leave_sub_objectives );
		
		//player PlaySoundToPlayer( "evt_event_round_end", player );
	}
	
	function remove_for_player( player, str_element_type, b_leave_sub_objectives = false )
	{
		if ( !isdefined( player.raid_obj_list ) )
		{
			return;
		}
		
		for ( i = player.raid_obj_list.size-1; i >= 0; i-- )
		{
			s_obj = player.raid_obj_list[i];
			
			if ( isdefined( str_element_type ) )
			{
				if ( str_element_type != s_obj.type )
				{
					continue;
				}
			}
			
			b_is_child = false;
			if ( s_obj.type == "sub" )
			{
				if (b_leave_sub_objectives)
				{
					continue;
				}
				else if ( s_obj.parent_objective_id == m_n_index )
				{
					b_is_child = true;
				}
			}
			
			if ( s_obj.objective_id == m_n_index || b_is_child )
			{
				s_obj.hud_elem Destroy();
				
				if ( isdefined( s_obj.hud_elem2 ) )
				{
					s_obj.hud_elem2 Destroy();
				}
				
				s_obj notify( "removed" );
				
				player.raid_obj_list[i] = undefined;
			}
		}
		
		ArrayRemoveValue( player.raid_obj_list, undefined, false );
		
		_update_positions_for_player( player );
	}
	
	// self == player
	function _process_timer_for_player( s_objective )
	{
		self endon( "death" );
	
		s_objective endon( "removed" );
		while( true )
		{
			level.raid_ui waittill( "timer_updated", id, n_time );
			if ( id == s_objective.objective_id )
			{
				s_objective.hud_elem SetValue( n_time );
			}
		}
	}
	
	// Hold off on fading this hud element in until its parent element is ready.
	//
	function _hud_elem_fade_in( element, parent_element )
	{
		element.hud_elem.alpha = 0.0;
		if ( isdefined(element.hud_elem2) )
		{
			element.hud_elem2.alpha = 0.0;
		}
		
		element endon( "removed" );
		parent_element endon( "removed" );
		
		parent_element flag::wait_till( "is_docked" );
		
		element.hud_elem FadeOverTime( 0.5 );
		element.hud_elem.alpha = 1.0;
		
		if ( isdefined(element.hud_elem2) )
		{
			element.hud_elem2 FadeOverTime( 0.5 );
			element.hud_elem2.alpha = 1.0;
		}
		
		if ( element flag::exists( "is_docked" ) )
		{
			element flag::set( "is_docked" );
		}
	}
	
	function _update_positions_for_player( player, b_pop_elements = false )
	{
		for ( i = 0; i < player.raid_obj_list.size; i++ )
		{
			s_obj = player.raid_obj_list[i];
			
			if ( !b_pop_elements )
			{
				s_obj.hud_elem MoveOverTime( 0.5 );
			}
			
			s_obj.hud_elem.y = _get_y_pos_from_element_index( i );
			
			if ( isdefined( s_obj.hud_elem2 ) )
			{
				if ( !b_pop_elements )
				{
					s_obj.hud_elem2 MoveOverTime( 0.5 );
				}
				s_obj.hud_elem2.y = s_obj.hud_elem.y;
			}
		}
	}
	
	function _get_y_pos_from_element_index( n_index )
	{
		return 80 + (n_index * 16.0);
	}
	
	// Removes the "big text" either when it times out, or when the objective is removed.
	//
	function _remove_objective_big_text( player, s_objective, b_animate_over )
	{
		player endon( "death" );
	
		_waittill_remove_objective_big_text( player, s_objective );
		
		if ( b_animate_over )
		{
			s_objective.hud_elem_big MoveOverTime( 0.5 );
			s_objective.hud_elem_big.x = s_objective.hud_elem.x;
			s_objective.hud_elem_big.y = s_objective.hud_elem.y;
			s_objective.hud_elem_big.horzAlign = s_objective.hud_elem.horzAlign;
			s_objective.hud_elem_big.vertAlign = s_objective.hud_elem.vertAlign;
			s_objective.hud_elem_big.alignX = s_objective.hud_elem.alignX;
			s_objective.hud_elem_big.alignY = s_objective.hud_elem.alignY;
			
			s_objective.hud_elem_big ChangeFontScaleOverTime( 0.5 );
			s_objective.hud_elem_big.fontScale = s_objective.hud_elem.fontScale;
			
			if ( isdefined( s_objective.hud_elem_round ) )
			{
				s_objective.hud_elem_round FadeOverTime( 0.5 );
				s_objective.hud_elem_round.alpha = 0.0;
			}
			
			wait 0.5;
		} else {
			s_objective.hud_elem_big FadeOverTime( 0.5 );
			s_objective.hud_elem_big.alpha = 0.0;
			
			if ( isdefined( s_objective.hud_elem_round ) )
			{
				s_objective.hud_elem_round FadeOverTime( 0.5 );
				s_objective.hud_elem_round.alpha = 0.0;
			}
			
			wait 0.5;
			s_objective.hud_elem FadeOverTime( 0.5 );
		}
		
		s_objective.hud_elem.alpha = 1.0;
		s_objective.hud_elem_big Destroy();
		
		if ( isdefined( s_objective.hud_elem_round ) )
		{
			s_objective.hud_elem_round Destroy();
		}
		
		s_objective flag::set( "is_docked" );
	}
	
	function _waittill_remove_objective_big_text( player, s_objective )
	{
		player endon( "death" );
	
		s_objective endon( "removed" );
		player endon( "new_objective_displayed" );
		
		wait 5.0;
	}
}

class cRaidUI
{
	var m_str_extract_shader;
	var m_a_s_rewards;
	var m_game_start_time;
	
	var m_a_o_hud_objectives;
	
	constructor()
	{

		m_a_o_hud_objectives = [];
		
		m_str_extract_shader = "waypoint_targetneutral";
		m_a_s_rewards = [];
		
		self flag::init( "extraction_shown", false );
		self flag::init( "rewards_shown", false );
		self flag::init( "wave_vo_suspended", false );
		
		thread onPlayerConnect();
	}
	
	destructor()
	{
		
	}
	
	function init()
	{
		m_game_start_time = GetTime();
	}
	
	function init_for_connecting_player( player )
	{
		player.raid_obj_list = [];
		
		// Update their existing objectives to match what's going on in the level.
		//
		for ( i = 0; i < m_a_o_hud_objectives.size; i++ )
		{
			o_obj = get_objective(i);
			[[o_obj]]->restore_for_connecting_player( player );
		}
	}
	
	function get_id_from_text( str_text )
	{
		for ( i = 0; i < m_a_o_hud_objectives.size; i++ )
		{
			o_obj = get_objective(i);
			if ( o_obj.m_str_text == str_text )
			{
				return i;
			}
		}
		
		return undefined;
	}
	
	function get_objective( id )
	{
		return m_a_o_hud_objectives[id];
	}
	
	function register_objective(str_objective)
	{
		// Check if it's already registered before creating a new one.
		//
		id = get_id_from_text( str_objective );
		if ( isdefined( id ) )
		{
			return id;
		}
		
		// Append it!
		//
		id = m_a_o_hud_objectives.size;
		
		// Create a new entry.
		//
		o_obj = new cRaidUIObjective();
		[[o_obj]]->init( id, str_objective );
		m_a_o_hud_objectives[id] = o_obj;
			
		return id;
	}
	
	function objective_set( id, str_override, str_round_msg, b_play_sound )
	{
		if ( level flag::get( "raid_game_over" ) )
		{
			return;
		}
		
		o_obj = get_objective( id );
		Assert( isdefined( o_obj ) );
		
		foreach ( player in level.players )
		{
			[[o_obj]]->set_for_player( player, str_override, str_round_msg );
			
			if ( b_play_sound )
			{
				player PlaySoundToPlayer( "evt_event_round_start", player );
			}
		}
		
		o_obj.m_b_active = true;
	}
	
	function add_sub_objective( id, parent_id )
	{
		if ( level flag::get( "raid_game_over" ) )
		{
			return;
		}
		
		o_obj = get_objective( id );
		Assert( isdefined( o_obj ) );
		
		o_obj.m_n_parent_id = parent_id;
		o_obj.m_b_active = true;
	
		foreach ( player in level.players )
		{
			[[o_obj]]->add_sub_objective_for_player( player, parent_id );
		}
	}
	
	function objective_remove( id, str_element_type )
	{
		o_obj = get_objective( id );
		Assert( isdefined( o_obj ) );
		
		foreach ( player in level.players )
		{
			[[o_obj]]->remove_for_player( player, str_element_type );
		}
		
		o_obj.m_b_active = false;
		o_obj.m_n_timer = undefined;
		o_obj.m_b_paused = undefined;
		
		if ( !isdefined( str_element_type ) || str_element_type == "primary" || str_element_type == "sub" || str_element_type == "timer" )
		{
			self notify( "kill_timer_" + id );
		}
	}
	
	function remove_all_objectives()
	{
		for (i = 0; i < m_a_o_hud_objectives.size; i++ )
		{
			objective_remove( i );
		}
	}
	
	function objective_complete( id, b_play_sound )
	{
		o_obj = get_objective( id );
		Assert( isdefined( o_obj ) );
		
		foreach ( player in level.players )
		{
			[[o_obj]]->complete_for_player( player );
			
			if( b_play_sound )
			{
				player PlaySoundToPlayer( "evt_event_round_end", player );
			}
		}
		
		o_obj.m_b_active = false;
		o_obj.m_n_timer = undefined;
		o_obj.m_b_paused = undefined;
		
		self notify( "kill_timer_" + id );
	}
	
	function objective_failed( id )
	{
		o_obj = get_objective( id );
		Assert( isdefined( o_obj ) );
		
		foreach ( player in level.players )
		{
			[[o_obj]]->complete_for_player( player, ( 1.0, 0.0, 0.0 ) );
		}
		
		o_obj.m_b_active = false;
	}
	
	function objective_add_timer( id, n_time_s, b_play_sound )
	{
		if ( level flag::get( "raid_game_over" ) )
		{
			return;
		}
		
		o_obj = get_objective(id);
		Assert( isdefined( o_obj ) );
		
		o_obj.m_n_timer = n_time_s;
		o_obj.m_b_paused = undefined;
		
		foreach ( player in level.players )
		{
			[[o_obj]]->add_timer_for_player( player );
			
			if ( b_play_sound )
			{
				player PlaySoundToPlayer( "evt_event_newintel", player );
			}
		}
		
		thread _objective_process_timer( id );
	}
	
	function objective_timer_wait( id, endon_source, str_endon )
	{
		if ( IsDefined( str_endon ) )
		{
			endon_source endon( str_endon );
		}
		
		o_obj = get_objective(id);
		Assert( isdefined( o_obj ) );
		
		if ( o_obj.m_n_timer > 0.0 )
		{
			while ( true )
			{
				self waittill( "timer_elapsed", elapsed_id );
				if ( elapsed_id == id )
				{
					break;
				}
			}
		}
		
		return true;
	}
	
	function objective_remove_timer( id )
	{
		o_obj = get_objective(id);
		Assert( isdefined( o_obj ) );
		
		raid_ui::hud_objective_remove( id, "timer" );
		o_obj.m_n_timer = undefined;
		o_obj.m_b_paused = undefined;
	}
	
	function objective_pause_timer( id, b_pause )
	{
		o_obj = get_objective(id);
		Assert( isdefined( o_obj ) );
		
		if ( !isdefined( o_obj.m_n_timer ) )
		{
			AssertMsg( "objective_pause_timer called on objective " + id + ", which has no timer." );
			return;
		}
		
		o_obj.m_b_paused = b_pause;
	}
	
	function objective_timer_get_time( id )
	{
		o_obj = get_objective(id);
		Assert( isdefined( o_obj ) );
		
		n_time = o_obj.m_n_timer;
		if ( !isdefined( n_time ) )
		{
			return 0;
		} else {
			return n_time;
		}
	}
	
	function _objective_process_timer( id )
	{
		self endon( "kill_timer_" + id );
		
		o_obj = get_objective(id);
		Assert( isdefined( o_obj ) );
		
		Assert( IsDefined( o_obj.m_n_timer ) );
		
		while( o_obj.m_n_timer > 0 )
		{
			wait 1.0;
			
			if ( ( isdefined( o_obj.m_b_paused ) && o_obj.m_b_paused ) )
			{
				continue;
			}
			
			if ( isdefined( o_obj.m_n_timer ) )
			{
				o_obj.m_n_timer -= 1;
				self notify( "timer_updated", id, o_obj.m_n_timer );
			} else {
				// Early return.  The timer has been nixed.
				self notify( "timer_cancelled", id );
				return;
			}
		}
		
		self notify( "timer_elapsed", id );
	}
	
	function objective_add_counter( id, n_count, str_label )
	{
		if ( level flag::get( "raid_game_over" ) )
		{
			return;
		}
		
		o_obj = get_objective(id);
		Assert( isdefined( o_obj ) );
			
		o_obj.m_n_counter = n_count;
		o_obj.m_str_counter_label = str_label;
		
		foreach( player in level.players )
		{
			[[o_obj]]->add_counter_for_player( player );
		}
	}
	
	function objective_remove_counter( id )
	{
		o_obj = get_objective(id);
		Assert( isdefined( o_obj ) );
		
		objective_remove( id, "counter" );
		o_obj.m_n_counter = undefined;
	}
	
	function objective_update_counter( id, n_count )
	{
		if ( level flag::get( "raid_game_over" ) )
		{
			return;
		}
		
		o_obj = get_objective( id );
		Assert( isdefined( o_obj ) );
				
		o_obj.m_n_counter = n_count;
		foreach( player in level.players )
		{
			raid_ui::hud_objective_update_counter_for_player( player, id );
		}
	}
	
	function get_counter( id )
	{
		o_obj = get_objective( id );
		if ( !isdefined( o_obj ) || !isdefined( o_obj.m_n_counter ) )
		{
			return 0;
		} else {
			return o_obj.m_n_counter;
		}
	}
	
	function onPlayerConnect()
	{	
		level endon ( "raid_complete" );
		
		while ( true )
		{
			level waittill ( "connecting", player );			
			init_for_connecting_player( player );
		}
	}
}

function _create_client_hud_elem( alignX, alignY, horzAlign, vertAlign, xOffset, yOffset, fontScale, color )	// self = the player
{
	hud_elem = NewClientHudElem( self );
	hud_elem.alignX = alignX;
	hud_elem.alignY = alignY;
	hud_elem.horzAlign = horzAlign;
	hud_elem.vertAlign = vertAlign;
	hud_elem.x += xOffset;
	hud_elem.y += yOffset;
	hud_elem.foreground = true;
	hud_elem.fontScale = fontScale;
	hud_elem.alpha = 1;
	hud_elem.color = color;
	hud_elem.hidewheninmenu = true;		
	
	return hud_elem;
}

/*****************************************************************
 *                       REWARDS                                 *
 *****************************************************************/

// Register a reward with the UI.
//
// str_icon: the icon to show with the reward.
// a_str_reward_names: the strings to show next to the icon (will display top-to-bottom in order).
//
function hud_reward_register( str_icon, a_str_reward_names )
{
	id = level.raid_ui.m_a_s_rewards.size;

	s_reward = SpawnStruct();
	
	s_reward.str_icon = str_icon;
	s_reward.a_str_rewards = ArrayCopy( a_str_reward_names );
	s_reward.str_state = "init";
	
	level.raid_ui.m_a_s_rewards[id] = s_reward;
	
	return id;
}

function hud_reward_set_earned( id )
{
	Assert( id < level.raid_ui.m_a_s_rewards.size, "RAID UIInvalid reward ID referenced in hud_reward_set_earned: " + id );
	level.raid_ui.m_a_s_rewards[id].str_state = "earned";
}

function hud_reward_set_next_up( id )
{
	Assert( id < level.raid_ui.m_a_s_rewards.size, "RAID UI: Invalid reward ID referenced in hud_reward_set_next_up: " + id );
	level.raid_ui.m_a_s_rewards[id].str_state = "next_up";
}

function _hud_reward_dock()
{
	if ( self.b_istext )
	{
		self FadeOverTime( 0.5 );
		self.alpha = 0.0;
	} else {
		self MoveOverTime( 0.5 );
		self.x = -200;
		self.y = 50;
		self.alignx = "left";
		self.aligny = "top";
		self.horzalign = "center";
		self.vertalign = "top";
	}
	
	wait 0.5;
	self Destroy();
}

function _hud_reward_show_center( s_new_earned )
{	
	a_elems = [];
	
	foreach ( e_player in level.players )
	{
		n_x = 0;
		n_y = 150;
		str_suffix = " Awarded";
		
		foreach( str_msg in s_new_earned.a_str_rewards )
		{
			s_text = e_player raid_ui::_create_client_hud_elem( "center", "top", "center", "top", n_x, n_y, 1.5, (1.0,1.0,1.0) );
			s_text SetText( str_msg + str_suffix );
			str_suffix = "";
			n_y += 16;
			s_text.b_istext = true;
			
			if ( !isdefined( a_elems ) ) a_elems = []; else if ( !IsArray( a_elems ) ) a_elems = array( a_elems ); a_elems[a_elems.size]=s_text;;
		}
	
		s_icon = e_player raid_ui::_create_client_hud_elem( "center", "top", "center", "top", n_x, n_y, 1.5, (1.0,1.0,1.0) );
		s_icon SetShader( s_new_earned.str_icon, 50, 50 );
		s_icon.b_istext = false;
		if ( !isdefined( a_elems ) ) a_elems = []; else if ( !IsArray( a_elems ) ) a_elems = array( a_elems ); a_elems[a_elems.size]=s_icon;;
	}
	
	wait 5.0;
	
	foreach ( s_icon in a_elems )
	{
		s_icon thread _hud_reward_dock();
	}
	
	wait 0.5;
}

// Sets the next_up reward as earned, and chooses a new next_up reward.
//
function hud_reward_advance( b_show_ui = false )
{
	Assert( level.raid_ui.m_a_s_rewards.size > 0, "RAID UI: Attempting to advance rewards when none have been registered." );
	
	// Search for any "next up" rewards, and move them to the "earned" state.
	//
	b_any_next_up = false;
	s_new_earned = undefined;
	foreach ( s_reward in level.raid_ui.m_a_s_rewards )
	{
		if ( s_reward.str_state == "next_up" )
		{
			s_reward.str_state = "earned";
			b_any_next_up = true;
			s_new_earned = s_reward;
		}
	}
	
	// Find the first available reward, and move it to the "next up" state.
	//
	foreach ( s_reward in level.raid_ui.m_a_s_rewards )
	{
		if ( s_reward.str_state == "init" )
		{
			s_reward.str_state = "next_up";
			break;
		}
	}
	
	if ( b_show_ui && isdefined(s_new_earned) )
	{
		_hud_reward_show_center( s_new_earned );
	}
}

function _hud_reward_show_pre_exfil()
{
	// Don't show them if they're already shown.
	if ( level.raid_ui flag::get( "rewards_shown" ) )
	{
		hud_reward_hide_display();
		util::wait_network_frame();
	}
	
	level.raid_ui flag::set( "rewards_shown" );
	
	const ICON_SIZE = 50;
	const ICON_SPACING = 0;
	
	n_earned_y = 50;
	n_next_up_y = 125;
	
	n_earned_left_align = -200;
	n_next_up_left_align = -200;
	
	a_all_elems = [];
	
	foreach ( player in level.players )
	{
		player.reward_hud_elems = [];
		
		n_earned = 0;
		n_up_next = 0;
		
		n_index = player.reward_hud_elems.size;
		player.reward_hud_elems[n_index] = player raid_ui::_create_client_hud_elem( "left", "bottom", "center", "top", n_earned_left_align, n_earned_y, 1.5, (1.0,1.0,1.0) );
		hud_icon = player.reward_hud_elems[n_index];
		hud_icon.color = (1.0, 1.0, 1.0);

		hud_icon SetText( "Exfil Now to Collect" );
		
		n_index = player.reward_hud_elems.size;
		player.reward_hud_elems[n_index] = player raid_ui::_create_client_hud_elem( "left", "bottom", "center", "top", n_next_up_left_align, n_next_up_y, 1.5, (1.0,1.0,1.0) );
		hud_icon = player.reward_hud_elems[n_index];
		hud_icon.color = (1.0, 1.0, 1.0);
		hud_icon SetText( "Continue to Earn" );
		
		// Show them in reverse order so the newest shows up first.
		//
		for ( i = level.raid_ui.m_a_s_rewards.size-1; i >= 0; i-- )
		{
			s_reward = level.raid_ui.m_a_s_rewards[i];
			if ( s_reward.str_state == "earned" )
			{
				x = n_earned_left_align + ((ICON_SIZE + ICON_SPACING) * n_earned);
				y = n_earned_y;
				n_index = player.reward_hud_elems.size;
				player.reward_hud_elems[n_index] = player raid_ui::_create_client_hud_elem( "left", "top", "center", "top", x, y, 1.0, (1.0,1.0,1.0) );
				hud_icon = player.reward_hud_elems[n_index];
				hud_icon SetShader( s_reward.str_icon, ICON_SIZE, ICON_SIZE );
				
				n_earned++;
			}
			else if ( s_reward.str_state == "next_up" )
			{
				x = n_next_up_left_align + ((ICON_SIZE + ICON_SPACING) * n_up_next);
				y = n_next_up_y;
				
				n_index = player.reward_hud_elems.size;
				player.reward_hud_elems[n_index] = player raid_ui::_create_client_hud_elem( "left", "top", "center", "top", x, n_next_up_y, 1.0, (1.0,1.0,1.0) );
				hud_icon = player.reward_hud_elems[n_index];
				hud_icon SetShader( s_reward.str_icon, ICON_SIZE, ICON_SIZE );
				
				n_up_next++;
			}
		}
		
		a_all_elems = ArrayCombine( a_all_elems, player.reward_hud_elems, true, false );
	}
	
	level.raid_ui flag::wait_till_clear( "rewards_shown" );
	
	for ( i = a_all_elems.size-1; i >= 0; i-- )
	{
		a_all_elems[i] Destroy();
	}
}

function _hud_reward_show_display_internal( b_show_next_up_rewards )
{
	// Don't show them if they're already shown.
	if ( level.raid_ui flag::get( "rewards_shown" ) )
	{
		hud_reward_hide_display();
		util::wait_network_frame();
	}
	
	level.raid_ui flag::set( "rewards_shown" );
	
	const ICON_SIZE = 50;
	const ICON_SPACING = 60;
	
	n_earned_y = 300;
	
	n_earned_left_align = 0;
	n_next_up_left_align = 0;
	
	n_total_earned = 0;
	foreach ( s_reward in level.raid_ui.m_a_s_rewards )
	{
		if (s_reward.str_state == "earned")
		{
			n_earned_left_align -= (ICON_SIZE + ICON_SPACING) * 0.5;
			n_total_earned++;
		} else if (s_reward.str_state == "next_up" ) {
			n_next_up_left_align -= (ICON_SIZE + ICON_SPACING) * 0.5;
		}
	}
	
	foreach ( player in level.players )
	{
		player.reward_hud_elems = [];
		
		n_earned = 0;
		n_up_next = 0;
		
		n_index = player.reward_hud_elems.size;
		player.reward_hud_elems[n_index] = player raid_ui::_create_client_hud_elem( "center", "bottom", "center", "top", 0, n_earned_y, 1.5, (1.0,1.0,1.0) );
		hud_icon = player.reward_hud_elems[n_index];
		hud_icon.color = (1.0, 0.0, 0.0);
		

		if ( n_total_earned > 0 )
		{
			hud_icon SetText( "Rewards Earned" );
		} else {
			hud_icon SetText( "No Rewards Earned" );
		}
		
		for ( i = 0; i < level.raid_ui.m_a_s_rewards.size; i++ )
		{
			s_reward = level.raid_ui.m_a_s_rewards[i];
			if ( s_reward.str_state == "earned" )
			{
				x = n_earned_left_align + ((ICON_SIZE + ICON_SPACING) * n_earned);
				y = n_earned_y;
				n_index = player.reward_hud_elems.size;
				player.reward_hud_elems[n_index] = player raid_ui::_create_client_hud_elem( "left", "top", "center", "top", x, y, 1.0, (1.0,1.0,1.0) );
				hud_icon = player.reward_hud_elems[n_index];
				hud_icon SetShader( s_reward.str_icon, ICON_SIZE, ICON_SIZE );
				
				x += ICON_SIZE;
				for ( j = 0; j < s_reward.a_str_rewards.size; j++ )
				{
					n_index = player.reward_hud_elems.size;
					player.reward_hud_elems[n_index] = player raid_ui::_create_client_hud_elem( "left", "top", "center", "top", x, y, 1.2, (1.0,1.0,1.0) );
					hud_icon = player.reward_hud_elems[n_index];
					hud_icon SetText( s_reward.a_str_rewards[j] );
					y += 16;
				}
				
				n_earned++;
			}
		}
	}
	
	// Kill the HUD when we're told.
	level.raid_ui flag::wait_till_clear( "rewards_shown" );

	// Destroy the hud elements.
	foreach ( player in level.players )
	{
		foreach ( s_elem in player.reward_hud_elems )
		{
			s_elem Destroy();
		}
	}
}

function hud_reward_show_display( b_pre_exfil = true )
{
	if ( b_pre_exfil )
	{
		thread _hud_reward_show_pre_exfil();
	} else {
		thread _hud_reward_show_display_internal();
	}
}

function hud_reward_hide_display()
{
	level.raid_ui flag::clear( "rewards_shown" );
}

function wave_vo_enable( b_enable = true )
{
	if ( b_enable )
	{
		level.raid_ui flag::clear( "wave_vo_suspended" );
	} else {
		level.raid_ui flag::set( "wave_vo_suspended" );
	}	
}

function hud_wave_show()
{	
	a_elems = [];
	foreach( player in level.players )
	{
		player PlaySoundToPlayer( "evt_event_enemies_incoming", player );
	}
	
	if ( level.raid_ui flag::get( "wave_vo_suspended" ) )
	{
		return;
	}
	
	n_random = RandomInt( 100 );
	if ( n_random < 25 )
	{
		temp_vo( "Black Station: Enemy reinforcements inbound.  Stay frosty!", "vox_stay_frosty" );
	} else if ( n_random < 50 ) {
		temp_vo( "Black Station: Heads up, team! Enemy reinforcements are on their way.", "vox_heads_up_team" );
	} else if ( n_random < 75 ) {
		temp_vo( "Black Station: Enemy reinforcements are en route.", "vox_enemy_reinforcements" );
	} else {
		temp_vo( "Black Station: Enemies inbound.  Stay sharp!", "vox_enemies_inbound" );
	}

}

/*****************************************************************
 *                    HUD OBJECTIVES                             *
 *****************************************************************/

function hud_objective_register( str_objective )
{
	return [[level.raid_ui]]->register_objective( str_objective );
}

function hud_objective_set( id, str_override_onscreen_message, b_play_sound = true )
{
	return [[level.raid_ui]]->objective_set( id, str_override_onscreen_message, undefined, b_play_sound );
}

function hud_round_objective_set( id, str_round_msg )
{
	return [[level.raid_ui]]->objective_set( id, undefined, str_round_msg, true );
}

function hud_objective_set_text_for_player( player, id, str_message )
{	
	for ( i = 0; i < player.raid_obj_list.size; i++ )
	{
		s_obj = player.raid_obj_list[i];
		if ( s_obj.objective_id == id && s_obj.type == "primary" )
		{
			s_obj.hud_elem SetText( str_message );
		}
	}
}

function hud_objective_add_counter( id, n_count, str_label = "left" )
{
	[[level.raid_ui]]->objective_add_counter( id, n_count, str_label );
}

function hud_objective_update_counter( id, n_count )
{
	[[level.raid_ui]]->objective_update_counter( id, n_count );
}

function hud_objective_get_counter( id )
{
	return [[level.raid_ui]]->get_counter( id );
}

function hud_objective_update_counter_for_player( player, id )
{
	if ( level flag::get( "raid_game_over" ) )
	{
		return;
	}
	
	for ( i = 0; i < player.raid_obj_list.size; i++ )
	{
		s_obj = player.raid_obj_list[i];
		if ( s_obj.objective_id == id && s_obj.type == "counter" )
		{
			s_obj.hud_elem SetValue( level.raid_ui.m_a_o_hud_objectives[id].m_n_counter );
		}
	}
}

function hud_objective_timer_get_time( id )
{
	return [[level.raid_ui]]->objective_timer_get_time( id );
}

// Returns "true" if the timer elapses successfully, or "undefined" if the timer is cut off by the "endon" notify.
//
function hud_objective_timer_wait( id, str_endon )
{
	[[level.raid_ui]]->objective_timer_wait( id, self, str_endon );
}

function hud_objective_add_sub_objective( id, parent_id )
{
	[[level.raid_ui]]->add_sub_objective( id, parent_id );
}

function hud_objective_add_timer( id, n_time_s, b_play_sound = false )
{
	[[level.raid_ui]]->objective_add_timer( id, n_time_s, b_play_sound );
}

function hud_objective_remove_timer( id )
{
	[[level.raid_ui]]->objective_remove_timer( id );
}

function hud_objective_pause_timer( id, b_do_pause = true )
{
	[[level.raid_ui]]->objective_pause_timer( id, b_do_pause );
}

function hud_objective_remove_counter( id )
{
	[[level.raid_ui]]->objective_remove_counter( id );
}

function hud_objective_complete( id, b_play_sound = true )
{
	[[level.raid_ui]]->objective_complete( id, b_play_sound );
}

function hud_objective_failed( id )
{
	[[level.raid_ui]]->objective_failed( id );
}

function hud_objective_remove( id, str_element_type )
{
	[[level.raid_ui]]->objective_remove( id, str_element_type );
}

/*****************************************************************
 *                      WAYPOINTS                                *
 *****************************************************************/

function create_objective_waypoint( str_shader, v_origin, z_offset)
{
	hud_waypoint = NewHudElem();
	hud_waypoint.horzAlign = "right";
	hud_waypoint.vertAlign = "middle";
	hud_waypoint.sort = 2;		
	hud_waypoint SetShader( str_shader, 5, 5 );
	hud_waypoint SetWaypoint( true, str_shader, false, false );
	hud_waypoint.hidewheninmenu = true;
	hud_waypoint.immunetodemogamehudsettings = true;	

	hud_waypoint.x = v_origin[0];
	hud_waypoint.y = v_origin[1];
	hud_waypoint.z = v_origin[2] + z_offset;	
	
	return hud_waypoint;
}

/*****************************************************************
 *                      EXTRACTION                               *
 *****************************************************************/

function extraction_hide()
{
	level.raid_ui flag::clear( "extraction_shown" );
}

function extraction_show_internal( s_extract )
{
	level.raid_ui flag::set( "extraction_shown" );
			
	hud_waypoint = NewHudElem();
	hud_waypoint.horzAlign = "right";
	hud_waypoint.vertAlign = "middle";
	hud_waypoint.sort = 2;		
	hud_waypoint SetShader( level.raid_ui.m_str_extract_shader, 5, 5 );
	hud_waypoint SetWaypoint( true, level.raid_ui.m_str_extract_shader, false, false );
	hud_waypoint.hidewheninmenu = true;
	hud_waypoint.immunetodemogamehudsettings = true;	
	hud_waypoint.x = s_extract.origin[0];
	hud_waypoint.y = s_extract.origin[1];
	hud_waypoint.z = s_extract.origin[2] + 64;

	foreach ( player in level.players )
	{
		player.exfil_hud_elem = NewClientHudElem( player ); 
		player.exfil_hud_elem.alignX = "center";
		player.exfil_hud_elem.alignY = "middle";	
		player.exfil_hud_elem.horzAlign = "center";
		player.exfil_hud_elem.vertAlign = "middle";
		player.exfil_hud_elem.x = 0;
		player.exfil_hud_elem.y = 0;
		player.exfil_hud_elem.foreground = true;
		player.exfil_hud_elem.alpha = 0;
		player.exfil_hud_elem.fontscale = 1.5;
	
		player.exfil_hud_elem SetText( "Waiting for all players" );
		
		player PlaySoundToPlayer( "evt_event_newintel", player );
	}
	
	while ( level.raid_ui flag::get( "extraction_shown" ) )
	{
		foreach ( player in level.players )
		{
			if ( level.players.size > 1 )
			{
				player.exfil_hud_elem.alpha = 1;
			}
			if ( DistanceSquared( player.origin, s_extract.origin ) > (s_extract.radius * s_extract.radius) )
			{
				player.exfil_hud_elem.alpha = 0;
			}
		}
		
		util::wait_network_frame();
	}
	
	foreach ( player in level.players )
	{
		player.exfil_hud_elem Destroy();
		player.exfil_hud_elem = undefined;
	}
	
	hud_waypoint Destroy();
}


function extraction_show( s_extract )
{
	self thread extraction_show_internal( s_extract );
}

/*****************************************************************
 *                          TEMP VO                              *
 *****************************************************************/

function temp_vo( str_vo_line, str_vo_alias )
{
	foreach( player in level.players )
	{
		player thread _temp_vo_internal( str_vo_line, str_vo_alias );
	}
}

function temp_vo_kill_all()
{
	foreach( player in level.players )
	{
		// Kill the threads.
		player notify( "kill_temp_vo" );
		
		// Destroy the existing message (if any).
		if ( isdefined( player.temp_vo_elem ) )
		{
			player.temp_vo_elem Destroy();
			player.temp_vo_elem = undefined;
		}
	}
}

// self == player
//
function _temp_vo_internal( str_vo_line, str_vo_alias )
{
	if ( level flag::get( "raid_game_over" ) )
	{
		return;
	}
	
	self endon( "death" );
	self endon( "kill_temp_vo" );
	
	if ( !isdefined( self.vo_now_serving ) )
	{
		self.vo_now_serving = 0;
		self.vo_last_customer = -1;
	}
	
	n_queue_ticket = self.vo_last_customer + 1;
	self.vo_last_customer = n_queue_ticket;
	
	while( n_queue_ticket != self.vo_now_serving )
	{
		util::wait_network_frame();
	}
	
	if ( IsDefined( self.temp_vo_elem ) )
	{
		self.temp_vo_elem Destroy();
	}
	
	self.temp_vo_elem = self raid_ui::_create_client_hud_elem( "center", "bottom", "center", "bottom", 0, -115, 1.5, (1.0,1.0,1.0) );
	self.temp_vo_elem SetText( str_vo_line );
	if ( isdefined( str_vo_alias) )
	{
		self PlaySoundToPlayer( str_vo_alias, self );
	}
	wait 4.0;
	
	if ( isdefined( self.temp_vo_elem ) )
	{
		self.temp_vo_elem Destroy();
		self.temp_vo_elem = undefined;
	}
	
	self.vo_now_serving++;
}

/*****************************************************************
 *                  SYSTEM INITIALIZATION                        *
 *****************************************************************/

function autoexec __init__sytem__() {     system::register("raid_ui",&__init__,undefined,undefined);    }

function __init__()
{
	level.raid_ui = new cRaidUI();
	[[level.raid_ui]]->init();
		
	level flag::init( "raid_game_over", false );
}

/*****************************************************************
 *                     GAME OVER SCREEN                          *
 *****************************************************************/

function show_game_results( b_victory )
{
	// Already called.  Don't bother.
	if ( level flag::get( "raid_game_over" ) )
	{
		return;
	}
	
	level flag::set( "raid_game_over" );
	[[level.raid_ui]]->remove_all_objectives();
	temp_vo_kill_all();

	ms_per_sec = 1000;
	ms_per_min = ms_per_sec * 60;
	ms_per_hour = ms_per_min * 60;
	
	n_ms_played = GetTime() - level.raid_ui.m_game_start_time;
	n_hours_played = Floor(n_ms_played / ms_per_hour);
	n_ms_played -= n_hours_played * ms_per_hour;
	n_minutes_played = Floor(n_ms_played / ms_per_min);
	n_ms_played -= n_minutes_played * ms_per_min;
	n_seconds_played = Floor(n_ms_played / ms_per_sec);
	n_ms_played -= n_seconds_played * ms_per_sec;
	
	str_time = n_hours_played + ":" + n_minutes_played + ":" + n_seconds_played + "." + n_ms_played;
	
	foreach ( player in level.players )
	{
		raid_end_hud = player raid_ui::_create_client_hud_elem( "center", "middle", "center", "middle", 0, 0, 2, (1.0,1.0,1.0) );
		time_elem = player raid_ui::_create_client_hud_elem( "center", "middle", "center", "middle", 0, -25, 2, (1.0,1.0,1.0) );
		
		if ( b_victory )
		{
			raid_end_hud SetText( "Mission Complete" );
		} else {
			raid_end_hud SetText( "Mission Failed" );
		}
		
		time_elem SetText( "Time Played: " + str_time );
	}
}

/*****************************************************************
 *                        RAID TOKENS                            *
 *****************************************************************/
 



 
function _set_num_tokens( e_player, n_tokens )
{
	if ( n_tokens > 0 )
	{
		if ( !isdefined( e_player.token_elem ) )
		{
			e_player.token_elem = e_player raid_ui::_create_client_hud_elem( "right", "bottom", "right", "bottom", -25 - 24 - 3, -92, 2.0, (1.0,1.0,1.0) );
			e_player.token_icon = e_player raid_ui::_create_client_hud_elem( "right", "bottom", "right", "bottom", -25, -92, 1.0, (1.0,1.0,1.0) );
			e_player.token_icon SetShader( "raid_token", 24, 24 );
		}
		
		e_player.token_elem SetValue( n_tokens );
	} else {
		if ( isdefined( e_player.token_elem ) )
		{
			e_player.token_elem Destroy();
			e_player.token_icon Destroy();
			e_player.token_elem = undefined;
			e_player.token_icon = undefined;
		}
	}
}
 
function _get_num_tokens(e_player)
{
	if ( !isdefined(e_player.n_raid_tokens) )
	{
		return 0;
	} else {
		return e_player.n_raid_tokens;
	}
}
 
function _give_tokens( e_player, n_tokens )
{
	if ( n_tokens <= 0 )
	{
		refresh_tokens( e_player );
		return;
	}
	
	a_icons = [];
	
	const token_spacing = 100;
	n_x = 0;
	if ( n_tokens > 1 )
	{
		n_x += token_spacing * (n_tokens - 1) * 0.5;
	}
	
	s_text = e_player raid_ui::_create_client_hud_elem( "center", "bottom", "center", "top", n_x, 150, 1.5, (1.0,1.0,1.0) );
	if ( n_tokens > 1 )
	{
		s_text SetText( "Tokens Awarded" );
	} else {
		s_text SetText( "Token Awarded" );
	}
	
	for ( i = 0; i < n_tokens; i++ )
	{
		s_icon = e_player raid_ui::_create_client_hud_elem( "center", "bottom", "center", "top", n_x, 200, 1.5, (1.0,1.0,1.0) );
		s_icon SetShader( "raid_token", 50, 50 );
		
		if ( !isdefined( a_icons ) ) a_icons = []; else if ( !IsArray( a_icons ) ) a_icons = array( a_icons ); a_icons[a_icons.size]=s_icon;;
		n_x -= token_spacing;
	}
	
	wait 2.5;
	n_unmoved = a_icons.size;
	
	s_text FadeOverTime( 0.5 );
	s_text.alpha = 0.0;
	
	wait 0.5;
	s_text Destroy();
	
	foreach ( s_icon in a_icons )
	{
		s_icon MoveOverTime( 0.5 );
		s_icon.horzAlign = "right";
		s_icon.vertAlign = "bottom";
		s_icon.alignX = "right";
		s_icon.alignY = "bottom";
		s_icon.y = -92;
		s_icon.x = -25;

		s_icon ScaleOverTime( 0.5, 0, 0 );
		
		wait 0.5;
		s_icon Destroy();
		n_unmoved--;
		
		n_total_tokens = _get_num_tokens( e_player );
		n_displayed_tokens = n_total_tokens - n_unmoved;
		_set_num_tokens( e_player, n_displayed_tokens );
	}
}

function give_tokens( e_player, n_tokens )
{
	thread _give_tokens( e_player, n_tokens );
}

function refresh_tokens( e_player )
{
	n_total_tokens = _get_num_tokens( e_player );
	_set_num_tokens( e_player, n_total_tokens );
}

class cFakeWorldspaceMessage
{
	var m_v_center;
	var m_n_range;
	var m_n_range_inner;
	var m_a_s_message;
	var m_b_update_messages;
	
	var m_e_parent;
	var m_b_parented;
	
	var m_valign;
	var m_halign;
	
	var m_b_destroyed;
	
	constructor()
	{
		m_v_center = (0,0,0);
		m_n_range = 128;
		m_n_range_inner = 64;
		m_a_s_message = [];
		m_b_update_messages = false;
		m_valign = "middle";
		m_halign = "left";
		m_b_destroyed = false;
		m_e_parent = undefined;
		m_b_parented = false;
		
		foreach( e_player in level.players )
		{
			self thread _player_process( e_player );
		}
				
		self thread _do_player_connections();
	}
	
	function init( v_center, n_range, str_msg, n_msg_scale = 1.0 )
	{
		clear_lines();
		
		m_v_center = v_center;
		m_n_range = n_range;
		m_n_range_inner = n_range * 0.5;
		
		if ( isdefined( str_msg ) )
		{
			return add_line( str_msg, n_msg_scale );
		}
	}
	
	function set_parent( e_parent )
	{
		self notify( "parent_changed" );
		
		if ( isdefined( e_parent ) )
		{
			m_e_parent = e_parent;
			m_b_parented = true;
		} else {
			m_e_parent = undefined;
			m_b_parented = false;
		}
	}
	
	function uninitialize()
	{
		m_b_destroyed = true;
	}
	
	function add_line( str_line, n_line_scale = 1.0, b_inner_radius_only = false )
	{
		Assert( isdefined( str_line ) && isdefined( n_line_scale ) );
		s_msg = SpawnStruct();
		s_msg.str_msg = str_line;
		s_msg.n_scale = n_line_scale;
		s_msg.b_inner_radius_only = b_inner_radius_only;
		if ( !isdefined( m_a_s_message ) ) m_a_s_message = []; else if ( !IsArray( m_a_s_message ) ) m_a_s_message = array( m_a_s_message ); m_a_s_message[m_a_s_message.size]=s_msg;;
		m_b_update_messages = true;
		
		return m_a_s_message.size - 1;
	}
	
	// Use the value passed back from add_line.
	//
	function update_line( n_line, str_message, n_line_scale )
	{
		Assert( isdefined( m_a_s_message[n_line] ) );
		if ( isdefined( str_message ) )
		{
			m_a_s_message[n_line].str_msg = str_message;
		}
		if ( isdefined( n_line_scale ) )
		{
			m_a_s_message[n_line].n_scale = n_line_scale;
		}
		
		m_b_update_messages = true;
	}
	
	function set_alignment( str_horizontal, str_vertical )
	{
		m_halign = str_horizontal;
		m_valign = str_vertical;
	}
	
	function clear_lines()
	{
		m_a_s_message = [];
		m_b_update_messages = true;
	}
	
	function _do_player_connections()
	{
		while ( true )
		{
			level waittill( "connected", e_player );
			self thread _player_process( e_player );
		}
	}
	
	function _player_process( e_player )
	{
		e_player endon( "disconnect" );
		
		a_elems = [];
		
		n_frametime = 0.1;
		
		while ( true )
		{
			if ( m_b_parented )
			{
				if ( isdefined( m_e_parent ) )
				{
					m_v_center = m_e_parent.origin;
				} else {
					uninitialize();
				}
			}
			
			dist_sq = DistanceSquared( m_v_center, e_player.origin );
			b_in_range = dist_sq < m_n_range * m_n_range;
			
			if ( m_b_destroyed )
			{
				b_in_range = false;
			}
			
			if ( m_b_update_messages )
			{
				b_in_range = false;
				m_b_update_messages = false;
			}
			
			if ( b_in_range )
			{
				if ( a_elems.size == 0 )
				{
					y = 0;
					i = 0;
					foreach( s_msg in m_a_s_message )
					{
						if ( i > 0 )
						{
							y += s_msg.n_scale * 14.0;
						}
						
						elem = e_player raid_ui::_create_client_hud_elem( m_halign, m_valign, "center", "middle", 0, y, s_msg.n_scale, (1.0,1.0,1.0) );
						elem.base_fontScale = s_msg.n_scale;
						elem.b_inner_radius_only = s_msg.b_inner_radius_only;
						elem.hidewheninmenu = true;
						elem SetText( s_msg.str_msg );
						if ( !isdefined( a_elems ) ) a_elems = []; else if ( !IsArray( a_elems ) ) a_elems = array( a_elems ); a_elems[a_elems.size]=elem;;
						
						i++;
					}
				}
				
				v_right = AnglesToRight( e_player.angles );
				v_fwd = AnglesToForward( e_player.angles );
				v_to_trig = VectorNormalize( m_v_center - e_player.origin );
				n_dot_horiz = VectorDot( v_to_trig, v_right );
				n_dot_fwd = VectorDot( v_to_trig, v_fwd );
				
				if ( n_dot_fwd > 0 )
				{
					applied_alpha = 1.0;
					if ( m_n_range_inner < m_n_range )
					{
						b_outer_range = false;
						if ( dist_sq > m_n_range_inner * m_n_range_inner )
						{
							b_outer_range = true;
							dist = sqrt(dist_sq);
							applied_alpha = 1.0 - (dist - m_n_range_inner) / (m_n_range - m_n_range_inner );
						}
					}
				
					foreach ( s_elem in a_elems )
					{
						x_new = n_dot_horiz * 600;
						if ( abs(x_new - s_elem.x) > 2.0 )
						{
							s_elem MoveOverTime( n_frametime );
							s_elem.x = n_dot_horiz * 600;
						}
						
						if ( s_elem.b_inner_radius_only && b_outer_range )
						{
							s_elem.alpha = 0.0;
						}
						else if ( abs( applied_alpha - s_elem.alpha ) >  0.05 )
						{
							s_elem.alpha = applied_alpha;
						}
					}
				} else {
					foreach( s_elem in a_elems )
					{
						s_elem.alpha = 0.0;
					}
				}
				
			} else {
				for ( i = a_elems.size-1; i >= 0; i-- )
				{
					a_elems[i] Destroy();
				}
				a_elems = [];
				
				if ( m_b_destroyed )
				{
					return;
				}
			}
			
			wait n_frametime;
		}
	}
}
