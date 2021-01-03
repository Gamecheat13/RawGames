#using scripts\shared\array_shared;
#using scripts\shared\util_shared;
#using scripts\shared\hud_util_shared;
#using scripts\shared\flag_shared;

#using scripts\cp\sidemissions\_sm_ui;

    	   	                                                                                                                         	                                                                                                                                                                                                                                                                                                                                                                    	        	     	             	    	   	                           	                               	                                	                                                              	                                                                                                              	                            	                                     	                                       	                                                               	   	                  	       	                                                    	                   	                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                       	                                                                                        	           	                        	                                            	                                             	                                                   	                                                             	                                                         	                                                                    	                                                                                                                                                                                                    	                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                     	                                                              	                                                          	                                   	                                   	                                                    	                                       

#namespace sm_ui;

class cFakeWorldspaceMessage
{
	var m_v_center;
	var m_n_range;
	var m_n_range_inner;
	var m_a_s_message;
	var m_a_s_icon;
	var m_b_update_messages;
	var m_b_show_text;

	var m_e_parent;
	var m_b_parented;

	var m_valign;
	var m_halign;

	var m_b_destroyed;

	constructor()
	{
		m_v_center = ( 0,0,0 );
		m_n_range = 128;
		m_n_range_inner = 64;
		m_a_s_message = [];
		m_a_s_icon = [];
		m_b_update_messages = false;
		m_valign = "middle";
		m_halign = "left";
		m_b_destroyed = false;
		m_e_parent = undefined;
		m_b_parented = false;
		m_b_show_text = true;

		foreach ( e_player in level.players )
		{
			self thread _player_process( e_player );
		}

		self thread _do_player_connections();
	}

	function init( v_center, n_range, str_icon, n_icon_x_offset )
	{
		clear_lines();

		m_v_center = v_center;
		m_n_range = n_range;
		m_n_range_inner = n_range * 0.5;

		if ( IsDefined( str_icon ) )
		{
			return add_icon( str_icon, n_icon_x_offset );
		}
	}

	function set_parent( e_parent )
	{
		self notify( "parent_changed" );

		if ( IsDefined( e_parent ) )
		{
			m_e_parent = e_parent;
			m_b_parented = true;
		}
		else
		{
			m_e_parent = undefined;
			m_b_parented = false;
		}
	}

	function uninitialize()
	{
		m_b_destroyed = true;
	}

	function add_icon( str_icon, n_icon_x_offset )
	{
		Assert( IsDefined( str_icon ) );

		s_msg = SpawnStruct();
		s_msg.str_ico = str_icon;
		s_msg.n_icon_x_offset = n_icon_x_offset;
		s_msg.b_inner_radius_only = true;
		if ( !isdefined( m_a_s_icon ) ) m_a_s_icon = []; else if ( !IsArray( m_a_s_icon ) ) m_a_s_icon = array( m_a_s_icon ); m_a_s_icon[m_a_s_icon.size]=s_msg;;
		m_b_update_messages = true;

		return m_a_s_icon.size - 1;
	}

	function add_line( str_line, n_line_scale = 1.0, b_inner_radius_only = false, func_override )
	{
		Assert( IsDefined( str_line ) && IsDefined( n_line_scale ) );

		s_msg = SpawnStruct();
		s_msg.str_msg = str_line;
		s_msg.n_scale = n_line_scale;
		s_msg.b_inner_radius_only = b_inner_radius_only;
		s_msg.func_override = func_override;
		if ( !isdefined( m_a_s_message ) ) m_a_s_message = []; else if ( !IsArray( m_a_s_message ) ) m_a_s_message = array( m_a_s_message ); m_a_s_message[m_a_s_message.size]=s_msg;;
		m_b_update_messages = true;

		return m_a_s_message.size - 1;
	}

	function update_line( n_line, str_message, n_line_scale )
	{
		Assert( IsDefined( m_a_s_message[ n_line ] ) );

		if ( IsDefined( str_message ) )
		{
			m_a_s_message[ n_line ].str_msg = str_message;
		}

		if ( IsDefined( n_line_scale ) )
		{
			m_a_s_message[ n_line ].n_scale = n_line_scale;
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

	function can_display_text( b_show_text )
	{
		m_b_show_text = b_show_text;
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
				if ( IsDefined( m_e_parent ) )
				{
					m_v_center = m_e_parent.origin;
				}
				else
				{
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

			if ( b_in_range && m_b_show_text )
			{
				if ( a_elems.size == 0 )
				{
					y = 0;
					i = 0;

					foreach ( s_msg in m_a_s_message )
					{
						if ( i > 0 )
						{
							y += s_msg.n_scale * 14.0;
						}

						elem = e_player sm_ui::_create_client_hud_elem( m_halign, m_valign, "center", "middle", 0, y, s_msg.n_scale, ( 1.0,1.0,1.0 ) );
						elem.base_fontScale = s_msg.n_scale;
						elem.b_inner_radius_only = s_msg.b_inner_radius_only;
						elem.hidewheninmenu = true;
						elem.func_override = s_msg.func_override;
						elem SetText( s_msg.str_msg );
						if ( !isdefined( a_elems ) ) a_elems = []; else if ( !IsArray( a_elems ) ) a_elems = array( a_elems ); a_elems[a_elems.size]=elem;;

						i++;
					}

					foreach ( s_ico in m_a_s_icon )
					{
						elem = NewClientHudElem( e_player );
						elem.alignX = m_halign;
						elem.alignY = m_valign;
						elem.horzAlign = "center";
						elem.vertAlign = "middle";
						elem.x += 0;
						elem.y += 8;
						elem.foreground = true;
						elem.alpha = 1;
						elem.hidewheninmenu = true;
						elem.b_inner_radius_only = s_ico.b_inner_radius_only;
						elem.n_icon_x_offset = s_ico.n_icon_x_offset;
						elem SetShader( s_ico.str_ico, 64, 64 );
						if ( !isdefined( a_elems ) ) a_elems = []; else if ( !IsArray( a_elems ) ) a_elems = array( a_elems ); a_elems[a_elems.size]=elem;;
					}
				}
				else
				{
					foreach ( s_elem in a_elems )
					{
						if ( IsDefined( s_elem.func_override ) )
						{
							m_e_parent thread [[ s_elem.func_override ]]( e_player, s_elem );
						}
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
							dist = sqrt( dist_sq );
							applied_alpha = 1.0 - ( dist - m_n_range_inner ) / ( m_n_range - m_n_range_inner );
						}
					}

					foreach ( s_elem in a_elems )
					{
						x_new = n_dot_horiz * 600;

						if ( abs( x_new - s_elem.x ) > 2.0 )
						{
							s_elem MoveOverTime( n_frametime );
							s_elem.x = n_dot_horiz * 600;

							if ( IsDefined( s_elem.n_icon_x_offset ) )
							{
								s_elem.x += s_elem.n_icon_x_offset;
							}
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
				}
				else
				{
					foreach ( s_elem in a_elems )
					{
						s_elem.alpha = 0.0;
					}
				}

			}
			else
			{
				for ( i = a_elems.size - 1; i >= 0; i-- )
				{
					a_elems[ i ] Destroy();
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
