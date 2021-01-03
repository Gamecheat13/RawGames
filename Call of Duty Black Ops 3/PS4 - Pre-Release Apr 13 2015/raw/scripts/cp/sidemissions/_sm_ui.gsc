#using scripts\codescripts\struct;

#using scripts\shared\array_shared;
#using scripts\shared\clientfield_shared;
#using scripts\shared\flag_shared;
#using scripts\shared\gameobjects_shared;
#using scripts\shared\hud_util_shared;
#using scripts\shared\system_shared;
#using scripts\shared\util_shared;

#using scripts\cp\_objectives;

    	   	                                                                                                                         	                                                                                                                                                                                                                                                                                                                                                                    	        	     	             	    	   	                           	                               	                                	                                                              	                                                                                                              	                            	                                     	                                       	                                                               	   	                  	       	                                                    	                   	                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                       	                                                                                        	           	                        	                                            	                                             	                                                   	                                                             	                                                         	                                                                    	                                                                                                                                                                                                    	                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                     	                                                              	                                                          	                                   	                                   	                                                    	                                       


	

	
#precache( "string", "MPUI_SECONDS" );
#precache( "string", "COOP_SMUI_LEFT" );
#precache( "material", "t7_hud_minimap_diamond" );

#namespace sm_ui;

class cRaidUIObjective
{
	var m_str_text;
	var m_n_timer;
	var m_b_paused;
	var m_str_paused_message;
	var m_param;
	var m_b_active;
	var m_n_parent_id;
	var m_n_index;
	
	constructor()
	{
		m_str_text = "";
		m_n_timer = undefined;
		m_b_paused = false;
		m_param = undefined;
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
				set_for_player( player );
			}
			
			if ( IsDefined( m_n_timer ) )
			{
				add_timer_for_player( player );
			}
		}
	}
	
	function set_for_player( player )
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
		n_y_pos = _get_y_pos_from_element_index( player, n_index );
		s_obj.hud_elem = player sm_ui::_create_client_hud_elem( "left", "top", "left", "top", 10, n_y_pos, 1.5, (1.0,1.0,1.0) );
		s_obj.objective_id = m_n_index;
		s_obj.type = "primary";
		if ( isdefined( m_param ) )
		{
			s_obj.hud_elem.label = m_str_text;
			if ( IsString( m_param ) )
			{
				s_obj.hud_elem SetText( m_param );
			} else {
				s_obj.hud_elem SetValue( m_param );
			}
		} else {
			s_obj.hud_elem SetText( m_str_text );
		}
		s_obj.hud_elem.alpha = 0.0;
		
		b_never_show_big_text = true;
		
		if ( !b_never_show_big_text )
		{
			player notify( "new_objective_displayed" );
			
			x = 0;
			y = -100;
			
			s_obj.hud_elem_big = player sm_ui::_create_client_hud_elem( "center", "middle", "center", "middle", x, y, 2, (1.0,1.0,0.0) );
			
			s_obj.hud_elem_big SetText( m_str_text );
			
			thread _remove_objective_big_text( player, s_obj, true );
		} else {
			s_obj.hud_elem.alpha = 1.0;
			s_obj flag::set( "is_docked" );
		}
	}
	
	function add_timer_for_player( player, str_label = &"MPUI_SECONDS" )
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
				player thread _process_timer_for_player( s_obj );
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
				
				n_y_pos = _get_y_pos_from_element_index( player, n_index );
				s_sub.hud_elem = player sm_ui::_create_client_hud_elem( "left", "top", "left", "top", 10, n_y_pos, 1.2, (1.0,1.0,1.0) );
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
		
		b_leave_sub_objectives = false;
		
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
			level.sm_ui waittill( "timer_updated", obj );
			if ( obj.m_n_index == s_objective.objective_id )
			{
				if ( ( isdefined( obj.m_b_paused ) && obj.m_b_paused ) && isdefined( obj.m_str_paused_message ) )
				{
					s_objective.hud_elem SetText( obj.m_str_paused_message );
				} else {
					s_objective.hud_elem SetValue( obj.m_n_timer );
					s_objective.hud_elem.label = obj.m_str_text;
				}
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
			
			s_obj.hud_elem.y = _get_y_pos_from_element_index( player, i );
			
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
	
	function _get_y_pos_from_element_index( player, n_index )
	{
		sm_ui::init_num_items_held( player );
		n_inv_items_shown = (level.num_inventory_items_shown - player.num_items_held);
		if (n_inv_items_shown < 0)
		{
			n_inv_items_shown = 0;
		}
		return 120 + (n_inv_items_shown * 40) + (n_index * 16.0);
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
	var m_game_start_time;
	var m_a_o_hud_objectives;
	
	constructor()
	{		
		m_a_o_hud_objectives = [];
		
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
		if ( isdefined( player.raid_obj_list ) )
		{
			return;
		}
		
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
	
	function objective_update( id, param )
	{
		if ( level flag::get( "raid_game_over" ) )
		{
			return;
		}
		
		o_obj = get_objective( id );
		Assert( isdefined( o_obj ) );
				
		o_obj.m_param = param;
		foreach( player in level.players )
		{
			objective_update_for_player( player, id );
		}
	}
	
	function objective_update_for_player( player, id )
	{
		if ( level flag::get( "raid_game_over" ) )
		{
			return;
		}
		
		for ( i = 0; i < player.raid_obj_list.size; i++ )
		{
			s_obj = player.raid_obj_list[i];
			if ( s_obj.objective_id == id && (s_obj.type == "primary" || s_obj.type == "sub") )
			{
				if ( IsString( m_a_o_hud_objectives[id].m_param ) )
				{
					s_obj.hud_elem SetText( m_a_o_hud_objectives[id].m_param );
				} else {
					s_obj.hud_elem SetValue( m_a_o_hud_objectives[id].m_param );
				}
			}
		}
	}
	
	function objective_set( id, param )
	{
		if ( level flag::get( "raid_game_over" ) )
		{
			return;
		}
		
		o_obj = get_objective( id );
		Assert( isdefined( o_obj ) );
		
		o_obj.m_param = param;
		
		foreach ( player in level.players )
		{
			[[o_obj]]->set_for_player( player );
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
		o_obj.m_str_paused_message = undefined;
		
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
	
	function refresh_positions()
	{
		// Update all the hud elements for all players.
		foreach( player in level.players )
		{
			for (i = 0; i < m_a_o_hud_objectives.size; i++ )
			{
				[[m_a_o_hud_objectives[i]]]->_update_positions_for_player( player, true );
			}
		}
	}
	
	function objective_complete( id )
	{
		o_obj = get_objective( id );
		Assert( isdefined( o_obj ) );
		
		foreach ( player in level.players )
		{
			[[o_obj]]->complete_for_player( player );
		}
		
		o_obj.m_b_active = false;
		o_obj.m_n_timer = undefined;
		o_obj.m_b_paused = undefined;
		o_obj.m_str_paused_message = undefined;
		
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
	
	function objective_add_timer( id, n_time_s )
	{
		if ( level flag::get( "raid_game_over" ) )
		{
			return;
		}
		
		o_obj = get_objective(id);
		Assert( isdefined( o_obj ) );
		
		o_obj.m_n_timer = n_time_s;
		o_obj.m_b_paused = undefined;
		o_obj.m_str_paused_message = undefined;
		
		foreach ( player in level.players )
		{
			[[o_obj]]->add_timer_for_player( player );
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
		
		sm_ui::hud_objective_remove( id, "timer" );
		o_obj.m_n_timer = undefined;
		o_obj.m_b_paused = undefined;
		o_obj.m_str_paused_message = undefined;
	}
	
	function objective_pause_timer( id, b_pause, str_pause_message )
	{
		o_obj = get_objective(id);
		Assert( isdefined( o_obj ) );
		
		if ( !isdefined( o_obj.m_n_timer ) )
		{
			AssertMsg( "objective_pause_timer called on objective " + id + ", which has no timer." );
			return;
		}
		
		o_obj.m_b_paused = b_pause;
		o_obj.m_str_paused_message = str_pause_message;
		
		self notify( "timer_updated", o_obj );
	}
	
	function objective_set_timer( id, n_time )
	{
		o_obj = get_objective(id);
		Assert( isdefined( o_obj ) );
		
		if ( !isdefined( o_obj.m_n_timer ) )
		{
			AssertMsg( "objective_set_timer called on objective " + id + ", which has no timer." );
			return;
		}
		
		o_obj.m_n_timer = n_time;
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
			
			if ( !( isdefined( o_obj.m_b_paused ) && o_obj.m_b_paused ) )
			{
				o_obj.m_n_timer -= 1;
			}
			
			if ( isdefined( o_obj.m_n_timer ) )
			{
				self notify( "timer_updated", o_obj );
			} else {
				// Early return.  The timer has been nixed.
				self notify( "timer_cancelled", id );
				return;
			}
		}
		
		self notify( "timer_elapsed", id );
	}
	
	function objective_remove_counter( id )
	{
		o_obj = get_objective(id);
		Assert( isdefined( o_obj ) );
		
		objective_remove( id, "counter" );
		o_obj.m_param = undefined;
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
 *                    HUD OBJECTIVES                             *
 *****************************************************************/

function hud_objective_register( str_objective )
{
	return [[level.sm_ui]]->register_objective( str_objective );
}

function hud_objective_set( id, n_param )
{
	return [[level.sm_ui]]->objective_set( id, n_param );
}

function hud_objective_update( id, n_param, str_new_label = undefined )
{
	return [[level.sm_ui]]->objective_update( id, n_param, str_new_label );
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

function hud_objective_timer_get_time( id )
{
	return [[level.sm_ui]]->objective_timer_get_time( id );
}

// Returns "true" if the timer elapses successfully, or "undefined" if the timer is cut off by the "endon" notify.
//
function hud_objective_timer_wait( id, str_endon )
{
	[[level.sm_ui]]->objective_timer_wait( id, self, str_endon );
}

function hud_objective_add_sub_objective( id, parent_id )
{
	[[level.sm_ui]]->add_sub_objective( id, parent_id );
}

function hud_objective_add_timer( id, n_time_s )
{
	[[level.sm_ui]]->objective_add_timer( id, n_time_s );
}

function hud_objective_remove_timer( id )
{
	[[level.sm_ui]]->objective_remove_timer( id );
}

function hud_objective_pause_timer( id, b_do_pause = true, str_pause_message = undefined )
{
	[[level.sm_ui]]->objective_pause_timer( id, b_do_pause, str_pause_message );
}

function hud_objective_set_timer( id, n_time )
{
	[[level.sm_ui]]->objective_set_timer( id, n_time );
}

function hud_objective_complete( id )
{
	[[level.sm_ui]]->objective_complete( id );
}

function hud_objective_failed( id )
{
	[[level.sm_ui]]->objective_failed( id );
}

function hud_objective_remove( id, str_element_type )
{
	[[level.sm_ui]]->objective_remove( id, str_element_type );
}

function hud_objective_remove_all()
{
	[[level.sm_ui]]->remove_all_objectives();
}

function hud_objective_refresh_positions()
{
	[[level.sm_ui]]->refresh_positions();
}

function init_num_items_held( e_player )
{
	if ( !isdefined( e_player.num_items_held ) )
	{
		e_player.num_items_held = 0;
	}
}

function inventory_pickup( str_clientfield, e_player )
{	
	sm_ui::init_num_items_held( e_player );
	level clientfield::set( str_clientfield, e_player GetEntityNumber() + 1);
	level.num_inventory_items_shown++;
	e_player.num_items_held++;
	sm_ui::hud_objective_refresh_positions();
}

function inventory_drop( str_clientfield, e_player )
{
	level clientfield::set( str_clientfield, 0);
	level.num_inventory_items_shown--;
	e_player.num_items_held--;
	sm_ui::hud_objective_refresh_positions();
}


/*****************************************************************
 *                  SIDEMISSION SPLASH TEXT                      *
 *****************************************************************/
 
 function splash_text( str_line1, str_line2, n_show_time = 4.0 )
{
	foreach( player in level.players )
	{
		player thread _splash_text_internal( str_line1, str_line2, n_show_time );
	}
}

// self == player
//
function _splash_text_internal( str_line1, str_line2, n_show_time )
{
	self notify( "new_splash_text" );
	
	self endon( "new_splash_text" );
	self endon( "death" );
	
	if ( IsDefined( self.s_splash_line1 ) )
	{
		self.s_splash_line1 Destroy();
	}
	
	if ( IsDefined( self.s_splash_line2 ) )
	{
		self.s_splash_line2 Destroy();
	}
	
	// If only one line is provided, that line is the big one.
	if ( !isdefined( str_line2 ) || str_line2 == &"" )
	{
		str_line2 = str_line1;
		str_line1 = "";
	}
	
	self.s_splash_line1 = self sm_ui::_create_client_hud_elem( "center", "bottom", "center", "middle", 0, -50, 1.5, (1.0,1.0,1.0) );
	self.s_splash_line1 SetText( str_line1 );
	
	self.s_splash_line2 = self sm_ui::_create_client_hud_elem( "center", "top", "center", "middle", 0, -50, 2.5, (1.0,1.0,1.0) );
	self.s_splash_line2 SetText( str_line2 );

	wait n_show_time;
	
	self.s_splash_line1 Destroy();
	self.s_splash_line2 Destroy();
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
	
	self.temp_vo_elem = self sm_ui::_create_client_hud_elem( "center", "bottom", "center", "bottom", 0, -115, 1.5, (1.0,1.0,1.0) );
	self.temp_vo_elem SetText( str_vo_line );
	if ( isdefined( str_vo_alias) )
	{
		self PlaySoundToPlayer( str_vo_alias, self );
	}
	wait 2.5;
	
	if ( isdefined( self.temp_vo_elem ) )
	{
		self.temp_vo_elem Destroy();
		self.temp_vo_elem = undefined;
	}
	
	self.vo_now_serving++;
}

/*****************************************************************
 *                      MINIMAP ICONS                            *
 *****************************************************************/

function _icon_remove_on_death()
{
	icon_id = self.sm_minimap_icon;
	self waittill( "death" );
	
	// Set it back to the default white value so it's white when we come back to it.
	objective_SetColor( icon_id, 1.0, 1.0, 1.0, 1.0 );
	
	Objective_Delete( icon_id );
	gameobjects::release_obj_id( icon_id );
}

// e_target: The entity on which to put the icon.
// str_type: "interact", "kill", or "location"--determines color
// str_icon: icon to show
function icon_add( e_target, str_type = "interact", str_icon = "t7_hud_minimap_diamond", b_remove_on_death = true )
{
	if (isdefined( e_target.sm_minimap_icon ) )
	{
		icon_remove( e_target );
	}
	
	obj_id = gameobjects::get_next_obj_id();
	
	objective_add( obj_id, "active", e_target.origin, &"", e_target );
	objective_icon( obj_id, str_icon );
	Objective_OnEntity( obj_id, e_target );
	objective_team( obj_id, "allies" );
	
	if (isdefined( str_type ))
	{
		if ( str_type == "interact" )
		{
			objective_SetColor( obj_id, 0.0, 1.0, 1.0, 1.0 );
		}
		else if (str_type == "kill" )
		{
			objective_SetColor( obj_id, 1.0, 0.0, 0.0, 1.0 );
		}
		else if (str_type == "location" )
		{
			objective_SetColor( obj_id, 1.0, 1.0, 0.0, 1.0 );
		}
	}
	
	e_target.sm_minimap_icon = obj_id;
	
	if ( b_remove_on_death )
	{
		e_target thread _icon_remove_on_death();
	}
}

function icon_remove( e_target )
{
	if ( !isdefined( e_target.sm_minimap_icon ) )
	{
		return;
	}
	
	Objective_Delete( e_target.sm_minimap_icon );
	
	gameobjects::release_obj_id( e_target.sm_minimap_icon );
	e_target.sm_minimap_icon = undefined;
}

/*****************************************************************
 *                  SYSTEM INITIALIZATION                        *
 *****************************************************************/

function autoexec __init__sytem__() {     system::register("side_mission_ui",&__init__,undefined,undefined);    }

function __init__()
{
	level.sm_ui = new cRaidUI();
	[[level.sm_ui]]->init();
	
	level flag::init( "raid_game_over", false );
	level.num_inventory_items_shown = 0;
}
