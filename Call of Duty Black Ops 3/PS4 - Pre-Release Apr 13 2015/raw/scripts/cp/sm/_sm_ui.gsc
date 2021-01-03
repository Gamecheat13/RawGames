#using scripts\codescripts\struct;

#using scripts\shared\array_shared;
#using scripts\shared\callbacks_shared;
#using scripts\shared\clientfield_shared;
#using scripts\shared\flag_shared;
#using scripts\shared\gameobjects_shared;
#using scripts\shared\hud_util_shared;
#using scripts\shared\system_shared;
#using scripts\shared\util_shared;

#using scripts\cp\_laststand;
#using scripts\cp\_oed;
#using scripts\cp\_objectives;
#using scripts\cp\_popups;
#using scripts\cp\_scoreevents;

#using scripts\cp\gametypes\_globallogic;
#using scripts\cp\gametypes\_persistence;

#using scripts\cp\sm\_sm_score;

    	   	                                                                                                                         	                                                                                                                                                                                                                                                                                                                                                                    	        	     	             	    	   	                           	                               	                                	                                                              	                                                                                                              	                            	                                     	                                       	                                                               	   	                  	       	                                                    	                   	                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                      	                                                                                        	           	                        	                                            	                                             	                                                   	                                                             	                                                         	                                                                    	                                                                                                                                                                                                    	                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                    	                                                              	                                                          	                                   	                                   	                                                    	                                       
                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                            	                                                                                                                                                                                                                                                                                                                                                                                       

                                                                   	       	     	          	      	                                                                                            	                                                           	                                  


	






	




#precache( "eventstring", "wave_bonus_show" );
#precache( "eventstring", "wave_bonus_hide" );
#precache( "eventstring", "wave_bonus_failed" );
#precache( "eventstring", "show_notification_dock_info_a" );
#precache( "eventstring", "hide_notification_dock_info_a" );
#precache( "eventstring", "set_notification_dock_info_a" );
#precache( "eventstring", "show_notification_dock_info_b" );
#precache( "eventstring", "hide_notification_dock_info_b" );
#precache( "eventstring", "set_notification_dock_info_b" );
#precache( "eventstring", "show_text_notification" );
#precache( "eventstring", "show_text_notification_image" );
#precache( "eventstring", "remove_notification_dock_image" );
	
#precache( "string", "COOP_SMUI_MISSION_FAILED" );
#precache( "string", "COOP_SMUI_MISSION_COMPLETE" );
#precache( "string", "SM_GAME_ENDED_EARLY" );
#precache( "string", "SM_ALL_PLAYERS_KILLED" );
#precache( "string", "MPUI_SECONDS" );
#precache( "string", "SM_BONUS_OBJ" );

#precache( "material", "t7_hud_minimap_diamond" );
#precache( "material", "rank_ssgt" );
#precache( "material", "t7_hud_playerlist_revive" );
#precache( "material", "t7_hud_playerlist_dead" );

#precache( "material", "t7_hud_award_objective_beacon" );
#precache( "string", "t7_hud_award_objective_beacon" );

#precache( "material", "t7_hud_award_objective_unobtanium" );
#precache( "string", "t7_hud_award_objective_unobtanium" );

#precache( "material", "t7_hud_award_boss" );
#precache( "string", "t7_hud_award_boss" );

#precache( "material", "t7_hud_award_bonus" );
#precache( "string", "t7_hud_award_bonus" );

#precache( "material", "t7_hud_award_generic" );
#precache( "string", "t7_hud_award_generic" );

// LUI variables.
//
#precache( "lui_menu", "gScript" );
#precache( "lui_menu_data", "teamScore" );
#precache( "lui_menu_data", "enemiesRemaining" );
#precache( "lui_menu_data", "bonusParam" );
#precache( "lui_menu_data", "bonusGoal" );

#precache( "lui_menu_data", "boss1_count" );
#precache( "lui_menu_data", "boss2_count" );
#precache( "lui_menu_data", "boss3_count" );
#precache( "lui_menu_data", "scavenger_count" );

#precache( "lui_menu", "uplink" );
#precache( "lui_menu_data", "progress" );

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
		return 145 + (n_inv_items_shown * 40) + (n_index * 16.0);
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
		if ( !isdefined( player.raid_obj_list ) )
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

function _create_server_hud_elem( alignX, alignY, horzAlign, vertAlign, xOffset, yOffset, fontScale, color = (1.0, 1.0, 1.0) )
{
	hud_elem = NewHudElem();
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
 	if ( level.sm_ui flag::get( "new_splashes_disabled" ) )
 	{
 		return;
 	}
 	
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
	
	self.s_splash_line1 = self sm_ui::_create_client_hud_elem( "center", "bottom", "center", "middle", 0, -75, 1.5, (1.0,1.0,1.0) );
	self.s_splash_line1 SetText( str_line1 );
	
	self.s_splash_line2 = self sm_ui::_create_client_hud_elem( "center", "top", "center", "middle", 0, -75, 2.5, (1.0,1.0,1.0) );
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

function _player_score_display()
{	
	self endon( "death" );
	self endon( "disconnect" );
	
	while ( true )
	{
		self sm_score::get();
		util::wait_network_frame();
	}
}

function _player_message_internal( str_msg, n_param, n_time )
{
	self notify( "new_player_message" );
	
	sm_ui_message = sm_ui::_create_client_hud_elem( "center", "middle", "center", "middle", 0, 50, 1.5, (1.0,1.0,1.0) );
	if ( isdefined( n_param ) )
	{
		sm_ui_message.label = str_msg;
		sm_ui_message SetValue( n_param );
	} else {
		sm_ui_message SetText( str_msg );
	}
	
	self util::waittill_any_timeout( n_time, "new_player_message" );
	sm_ui_message Destroy();
}

function player_message( str_msg, n_param = undefined, n_time = 3.0 )
{
	self thread _player_message_internal( str_msg, n_param, n_time );
}

function team_message( str_msg, e_subject )
{
	_popups::DisplayTeamMessageToAll( str_msg, e_subject );
}

/*****************************************************************
 *                 MISSION SUCCESS/FAIL SPLASH                   *
 *****************************************************************/

function _sidemission_end_game_ui( winner, endReasonText, endImage )
{
//	wait 1.75;  // give players a moment to process info

	level.gameEndMessage1 = &"COOP_SMUI_MISSION_FAILED";
	level.gameEndMessage1Color = PackRGBA( 1.0, 1.0, 1.0, 1.0 );
	level.gameEndMessage2Color = PackRGBA( 1.0, 1.0, 1.0, 1.0 );		
	level.gameEndMessageIcon = undefined;

	//change the end message if the host ended the game early
	if ( ( isdefined( level.hostForcedEnd ) && level.hostForcedEnd ) )
	{
		level.gameEndMessage2 = &"SM_GAME_ENDED_EARLY";
	}
	else
	{
		if ( winner != level.enemy_ai_team )
		{
			level.gameEndMessage1 = &"";
			level.gameEndMessage2 = &"COOP_SMUI_MISSION_COMPLETE";
		}
		else
		{
			level.gameEndMessage2 = endReasonText;
			level.gameEndMessage2Color = PackRGBA( 0.92549, 0.10980, 0.14118, 1 );
			level.gameEndMessageIcon = endImage;
		}
	}
		
	if ( IsDefined( level.gameEndMessageIcon ) )
	{
		show_text_notification_with_image( level.gameEndMessage1, level.gameEndMessage1Color, level.gameEndMessage2, level.gameEndMessage2Color, level.gameEndMessageIcon );
	}
	else 
	{
		show_text_notification( level.gameEndMessage1, level.gameEndMessage1Color, level.gameEndMessage2, level.gameEndMessage2Color );
	}
	
	level.sm_ui flag::set( "new_splashes_disabled" );			// Lock out any other system using splashes.
	
	level waittill( "round_end_done" );
	
	level.sm_ui flag::clear( "new_splashes_disabled" );
	level.sm_ui flag::set( "new_splashes_disabled" );
}

function on_end_game( success )
{
	sm_ui::temp_vo_kill_all();
	sm_ui::hud_objective_remove_all();
}

function _mission_failed_all_players_died()
{
	globallogic::endGame( level.enemy_ai_team, &"SM_ALL_PLAYERS_KILLED" );
}

/*****************************************************************
 *                   WAVE NUMBER, BONUS UI                       *
 *****************************************************************/

function wave_display( str_message )	
{
	sm_ui::wave_remove();
	
	level.sm_wave_elem = sm_ui::_create_server_hud_elem( "right", "top", "right", "top", -25, 25, 2.0, (1.0,1.0,1.0) );
	level.sm_wave_elem SetText( str_message );
}

function wave_remove()
{
	if ( isdefined( level.sm_wave_elem ) )
	{
		level.sm_wave_elem Destroy();
	}
}

function bonus_display( str_message, n_param = undefined, n_goal = undefined )
{
	// Set the parameter if there is one.
	if ( isdefined(n_param) )
	{
		set_lui_global( "bonusParam", n_param );
	}
	
	if ( isdefined( n_goal ) )
	{
		set_lui_global( "bonusGoal", n_goal );
	}
	
	foreach( e_player in level.players )
	{
		e_player PlaySoundToPlayer( "evt_bonus_displayed", e_player );
	}
	
	LUINotifyEvent( &"wave_bonus_show", 4, &"SM_BONUS_OBJ", &"SM_BONUS_OBJ", &"t7_hud_award_generic", str_message );
}

function bonus_update( n_param )
{
	if ( isdefined( n_param ) )
	{
		set_lui_global( "bonusParam", n_param );
	}
}

function bonus_failed()
{
	foreach( e_player in level.players )
	{
		e_player PlaySoundToPlayer( "evt_bonus_failed", e_player );
	}
	
	LUINotifyEvent( &"wave_bonus_failed", 0 );
}

function bonus_completed()
{
	foreach( e_player in level.players )
	{
		e_player PlaySoundToPlayer( "evt_bonus_success", e_player );
	}
	
	LUINotifyEvent( &"wave_bonus_hide", 0 );
}

function enemy_message_set( str_message, n_param = undefined )
{
	set_lui_global( "enemiesRemaining", n_param );
	LuiNotifyEvent( &"show_notification_dock_info_a", 2, str_message, packrgba(1.0,0.0,0.0,0.0) );
}

function enemy_message_update( n_param )
{
	set_lui_global( "enemiesRemaining", n_param );
}

function enemy_message_remove()
{
	LuiNotifyEvent( &"hide_notification_dock_info_a", 0 );
}

function dock_text_show( str_message )
{
	foreach ( player in level.players )
	{
		player LuiNotifyEvent( &"show_notification_dock_info_b", 2, str_message, PackRGBA( 1.0, 1.0, 1.0, 1.0 ) );
	}
}

function dock_text_set( str_message )
{
	foreach ( player in level.players )
	{
		player LuiNotifyEvent( &"set_notification_dock_info_b", 2, str_message, PackRGBA( 1.0, 1.0, 1.0, 1.0 ) );
	}
}

function dock_text_remove()
{
	foreach ( player in level.players )
	{
		player LuiNotifyEvent( &"hide_notification_dock_info_b", 0 );
	}
}

function dock_image_remove( n_index )
{
	foreach ( player in level.players )
	{
		player LUINotifyEvent( &"remove_notification_dock_image", 1, n_index );
	}	
}

function interact_prompt_set( n_id, b_show_keyline = true )
{
	assert( n_id >= 0 && n_id <= 9 );
	
	if ( level flag::get( "prematch_active" ) )
	{
		thread _interact_prompt_set_delayed( n_id );
		return;
	}
	
	if ( isdefined( self.interact_prompt_clientfield ) )
	{
		self interact_prompt_remove();
	}
	
	self.interact_prompt_clientfield = "obj_interactive_prompt_" + n_id;
	self clientfield::set( self.interact_prompt_clientfield, 1 );
	
	if ( b_show_keyline )
	{
		self thread oed::enable_keyline( true );
	}
}

function _interact_prompt_set_delayed( n_id )
{
	self endon( "death" );
	self endon( "remove_interact_prompt" );
	
	level flag::wait_till_clear( "prematch_active" );
	self interact_prompt_set( n_id );
}

function interact_prompt_remove( b_hide_keyline = true )
{
	self notify( "remove_interact_prompt" );
	if ( !isdefined( self.interact_prompt_clientfield ) )
	{
		return;
	}
	
	self clientfield::set( self.interact_prompt_clientfield, 0 );
	self.interact_prompt_clientfield = undefined;
	
	if ( b_hide_keyline )
	{
		self thread oed::disable_keyline();
	}
}

function show_model_in_sitrep( str_level_notify_to_disable )
{
	self thread oed::enable_keyline( false, str_level_notify_to_disable );
}

function sm_teamscore_ui_callback( event )
{
	str_icon = level.scoreInfo[event]["team_icon"];
	
	if ( isdefined( str_icon ) )
	{
		str_title = level.scoreInfo[event]["label"];
		n_score = level.scoreInfo[event]["value"];	
		str_score = &"COOP_SCORE_NOTIFY_FORMAT";
		
		level.sm_ui flag::wait_till_clear( "teamscore_displaying" );
		level.sm_ui flag::set( "teamscore_displaying" );
		
		if ( n_score > 0 && !( isdefined( level.avoid_lui_crash ) && level.avoid_lui_crash ) )
		{
			set_lui_global( "teamScore", n_score );
		}
		else
		{
			str_score = &"";
		}
		
		LuiNotifyEvent( &"show_text_notification_image", 5, str_title, packrgba( 1.0, 1.0, 1.0, 1.0 ), str_score, packrgba( 0.0, 0.75, 0.25, 1.0 ), str_icon );
		
		wait 4.0;
		level.sm_ui flag::clear( "teamscore_displaying" );
	}
}

function show_text_notification( str_text_top, n_text_top_color, str_text_bottom = &"", n_text_bottom_color )
{
	if(!isdefined(n_text_top_color))n_text_top_color=PackRGBA( 1.0, 1.0, 1.0, 1.0 );
	if(!isdefined(n_text_bottom_color))n_text_bottom_color=PackRGBA( 1.0, 1.0, 1.0, 1.0 );
	
	foreach ( player in level.players )
	{
		player LuiNotifyEvent( &"show_text_notification", 4, str_text_top, n_text_top_color, str_text_bottom, n_text_bottom_color );
	}
}

function show_text_notification_with_image( str_text_top, n_text_top_color, str_text_bottom = &"", n_text_bottom_color, str_image = &"" )
{
	if(!isdefined(n_text_top_color))n_text_top_color=PackRGBA( 1.0, 1.0, 1.0, 1.0 );
	if(!isdefined(n_text_bottom_color))n_text_bottom_color=PackRGBA( 1.0, 1.0, 1.0, 1.0 );
	
	foreach ( player in level.players )
	{
		player LuiNotifyEvent( &"show_text_notification_image", 5, str_text_top, n_text_top_color, str_text_bottom, n_text_bottom_color, str_image );
	}
}

function energy_bar_set( b_show_keyline = true )
{
	// Can't set energy bars during the prematch period.
	assert(!level flag::get( "prematch_active" ) );
	
	if ( isdefined( self.e_energy_bar ) )
	{
		self energy_bar_remove();
	}
	
	self.e_energy_bar = util::spawn_model( "tag_origin", self.origin, self.angles );
	self.e_energy_bar LinkTo( self );
	self.e_energy_bar clientfield::set( "resource_energy_bar", 1 );
}

function _energy_bar_remove_internal()
{
	e_bar = self.e_energy_bar;
	self.e_energy_bar = undefined;	// Clear it just in case someone is creating a new one this frame.
	e_bar clientfield::set( "resource_energy_bar", 0 );
	
	// Wait several frames before deleting, because LUA won't get updated correctly otherwise.
	util::wait_network_frame();
	util::wait_network_frame();
	util::wait_network_frame();
	e_bar Delete();
}

function energy_bar_remove( b_hide_keyline = true )
{
	self notify( "remove_energy_bar" );
	if ( !isdefined( self.e_energy_bar ) )
	{
		return;
	}
	
	self thread _energy_bar_remove_internal();
}

function energy_value_update( progress )
{
	if ( isdefined( self.e_energy_bar ) )
	{
		self.e_energy_bar clientfield::set( "resource_energy_value", progress );
	}
}

function set_lui_global( str_global_name, parameter, str_category = "gScript" )
{
	foreach( e_player in level.players )
	{
		if ( isdefined( e_player.lui_script_globals ) && isdefined(e_player.lui_script_globals[str_category]) )
		{
			e_player SetLuiMenuData( e_player.lui_script_globals[str_category], str_global_name, parameter );
		}
	}
}

function set_lui_global_for_player( str_global_name, parameter, str_category = "gScript" )
{
	if ( isdefined( self.lui_script_globals ) && isdefined(self.lui_script_globals[str_category]) )
	{
		self SetLuiMenuData( self.lui_script_globals[str_category], str_global_name, parameter );
	}
}

/*****************************************************************
 *                    SYSTEM INITIALIZATION                      *
 *****************************************************************/

function init_player_ui()
{
	self.lui_script_globals["gScript"] = self OpenLUIMenu("gScript");	
	self.lui_script_globals["uplink"] = self OpenLUIMenu("uplink");
	
	sm_ui::set_lui_global( "teamScore", 0 );
	sm_ui::set_lui_global( "bonusParam", 0 );
	sm_ui::set_lui_global( "bonusGoal", 0 );
	sm_ui::set_lui_global( "enemiesRemaining", 0 );
	sm_ui::set_lui_global( "boss1_count", 0 );
	sm_ui::set_lui_global( "boss2_count", 0 );
	sm_ui::set_lui_global( "boss3_count", 0 );
	sm_ui::set_lui_global( "scavenger_count", 0 );
	sm_ui::set_lui_global( "progress", 0, "uplink" );
	
	self thread sm_ui::_player_score_display();
}
 
function initialize_lui_script_globals()
{
	level.teamScoreUICallback = &sm_ui::sm_teamscore_ui_callback;
	callback::on_spawned(&init_player_ui);
}

function autoexec __init__sytem__() {     system::register("side_mission_ui",&__init__,undefined,undefined);    }

function __init__()
{
	level.sm_ui = new cRaidUI();
	[[level.sm_ui]]->init();
	
	level flag::init( "raid_game_over", false );
	level.sm_ui flag::init( "new_splashes_disabled", false );
	level.sm_ui flag::init( "teamscore_displaying", false );
	level.num_inventory_items_shown = 0;
	
	level.gameEndUICallback = &_sidemission_end_game_ui;
//	level.nextBspToLoad = "cp_sm_sing_chinatown_defend";
	level.gameEndMessage1 = &"COOP_SMUI_MISSION_FAILED";
	level.gameEndMessage2 = &"SM_ALL_PLAYERS_KILLED";
	
	level.bleedout_time = GetDvarFloat( "player_lastStandBleedoutTime" );
	
	// Set "inner radius" distance for interact prompts.
	SetDvar( "interactivePromptNextToDist", 2 );
	
	sm_ui::init_clientfields();
	
	level thread initialize_lui_script_globals();
}

function init_clientfields()
{
	clientfield::register( "scriptmover", "obj_interactive_prompt_0", 1, 1, "int" );
	clientfield::register( "scriptmover", "obj_interactive_prompt_1", 1, 1, "int" );
	clientfield::register( "scriptmover", "obj_interactive_prompt_2", 1, 1, "int" );
	clientfield::register( "scriptmover", "obj_interactive_prompt_3", 1, 1, "int" );
	clientfield::register( "scriptmover", "obj_interactive_prompt_4", 1, 1, "int" );
	clientfield::register( "scriptmover", "obj_interactive_prompt_5", 1, 1, "int" );
	clientfield::register( "scriptmover", "obj_interactive_prompt_6", 1, 1, "int" );
	clientfield::register( "scriptmover", "obj_interactive_prompt_7", 1, 1, "int" );
	clientfield::register( "scriptmover", "resource_energy_bar", 1, 1, "int" );
	clientfield::register( "scriptmover", "resource_energy_value", 1, 7, "float" );
	clientfield::register( "actor", "resource_energy_bar", 1, 1, "int" );
	clientfield::register( "actor", "resource_energy_value", 1, 7, "float" );
}
