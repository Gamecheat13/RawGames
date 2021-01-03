#using scripts\codescripts\struct;

#using scripts\cp\_laststand;
#using scripts\cp\_oed;
#using scripts\cp\_pickups;
#using scripts\cp\_scoreevents;
#using scripts\cp\_util;

#using scripts\cp\sm\_sm_round_base;
#using scripts\cp\sm\_sm_round_beacon;
#using scripts\cp\sm\_sm_round_objective;
#using scripts\cp\sm\_sm_ui;
#using scripts\cp\sm\_sm_ui_worldspace;
#using scripts\cp\sm\_sm_wave_mgr;
#using scripts\cp\sm\_sm_zone_mgr;

#using scripts\shared\array_shared;
#using scripts\shared\clientfield_shared;
#using scripts\shared\flag_shared;
#using scripts\shared\gameobjects_shared;
#using scripts\shared\hud_util_shared;
#using scripts\shared\laststand_shared;
#using scripts\shared\math_shared;
#using scripts\shared\system_shared;
#using scripts\shared\util_shared;

    	   	                                                                                                                         	                                                                                                                                                                                                                                                                                                                                                                    	        	     	             	    	   	                           	                               	                                	                                                              	                                                                                                              	                            	                                     	                                       	                                                               	   	                  	       	                                                    	                   	                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                      	                                                                                        	           	                        	                                            	                                             	                                                   	                                                             	                                                         	                                                                    	                                                                                                                                                                                                    	                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                    	                                                              	                                                          	                                   	                                   	                                                    	                                       
                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                            	                                                                                                                                                                                                                                                                                                                                                                                       

                                                                   	       	     	          	      	                                                                                            	                                                           	                                  








	


















	


	


#precache( "material", "hud_suitcase_bomb" );
#precache( "material", "t7_hud_waypoints_unob_a" );
#precache( "material", "t7_hud_waypoints_unob_b" );
#precache( "material", "t7_hud_waypoints_unob_c" );
#precache( "material", "t7_hud_waypoints_d" );
#precache( "material", "t7_hud_unobtanium" );
#precache( "material", "t7_hud_dock_unobtanium" );
#precache( "material", "t7_hud_waypoints_unob_deliver" );

#precache( "string", "SM_OBJ_SECURE_GOODS" );
#precache( "string", "SM_OBJ_SECURE_GOODS_FAIL" );

#precache( "string", "SM_PROMPT_GOODS_DROP" );
#precache( "string", "SM_PROMPT_GOODS_RADIATION" );
#precache( "string", "t7_hud_unobtanium" );
#precache( "string", "t7_hud_dock_unobtanium" );

#precache( "triggerstring", "SM_PROMPT_GOODS_CARRY" );

#precache( "objective", "sm_unobtainium_dropoff" );
#precache( "objective", "sm_unobtainium_carry_a" );
#precache( "objective", "sm_unobtainium_carry_b" );
#precache( "objective", "sm_unobtainium_carry_c" );

#namespace sm_round_objective_secure_goods;

function autoexec __init__sytem__() {     system::register("sm_round_objective_secure_goods",&__init__,undefined,undefined);    }

function __init__()
{
	clientfield::register( "toplayer", "sm_secure_goods_sfx", 1, 1, "int" );
	clientfield::register( "toplayer", "sm_secure_goods_blur", 1, 7, "float" );
	clientfield::register( "toplayer", "sm_secure_goods_intensity",	1, 7, "float" );
	clientfield::register( "toplayer", "sm_secure_goods_visionset", 1, 7, "float" );
	
	clientfield::register( "world", "sm_inv_unobtanium_a", 1, 3, "int" );
	clientfield::register( "world", "sm_inv_unobtanium_b", 1, 3, "int" );
	clientfield::register( "world", "sm_inv_unobtanium_c", 1, 3, "int" );	
}
	
function main()
{
	o_objective = new cObjSecureGoodsMove();
	
	[[o_objective]]->set_custom_goods_count( 3 );
	
	return o_objective;
}

class cObjSecureGoodsMove : cSideMissionRoundObjective
{
	var m_n_round;
	var m_n_goods;
	var m_m_dropoff;
	var m_a_goods;
	var	m_a_unobtainium_gobj;
	var	m_dropoff_gameobject;
	var m_hud_waypoint;
	var m_str_dropoff_zone;
	var m_str_objective_text;
	var m_str_icon;
	
	constructor()
	{
		m_n_round = 1;
		m_n_goods = 1;
		
		m_a_unobtainium_gobj = [];
		
		m_str_objective_text = &"SM_OBJ_SECURE_GOODS";
		m_str_icon = &"t7_hud_unobtanium";		
		
		m_str_vox_intro = "vox_stock_unobtanium";
		
		m_hide_beacon_icons_during_objective = false;  // beacon minimap and waypoint icon to show for 'deliver unobtainium' objective
	}
	
	destructor()
	{
		clean_up();
	}
	
	function set_custom_round( n_round )
	{
		m_n_round = n_round;
	}
	
	function set_custom_goods_count( n_count )
	{
		m_n_goods = n_count;
	}
	
	function main_objective()
	{
		set_objective_timer_with_images( 300, "vox_extract_unobtanium", &"t7_hud_dock_unobtanium", &"t7_hud_dock_unobtanium", &"t7_hud_dock_unobtanium", &"t7_hud_unobtanium" );

		o_beacon_gameobject = sm_round_beacon::get_active_beacon_gameobject();
		o_beacon_gameobject sm_round_beacon::beacon_icon_set( "t7_hud_waypoints_unob_deliver" );
		
		sm_round_beacon::beacon_hardpoint_show();
		
		set_zone_mode();
		
		a_goods_structs = get_sm_struct( "secure_goods_parent", sm_round_beacon::get_active_beacon_location() );

		a_goods_structs = array::randomize( a_goods_structs );

		thread show_dropoff();
		thread spawn_goods( a_goods_structs[0] );
		
		self crate_success_watch();
		
		o_beacon_gameobject sm_round_beacon::beacon_icon_reset();
		
		sm_round_beacon::beacon_hardpoint_hide();
	}
	
	function set_zone_mode()
	{
		zone_mgr::set_mode( "objective_unoccupied" );
	}

	function show_dropoff()
	{
		e_beacon = sm_round_beacon::get_active_beacon();
		v_pos = e_beacon.origin;
		v_angles = e_beacon.angles;
		
		// Visual models offset fom the gameobject origin
		gobj_model_offset = ( 0, 0, 0 );
		gobj_visuals[ 0 ] = util::spawn_model( "tag_origin", v_pos + gobj_model_offset, v_angles );
		
		set_objective_spawning_at_position( gobj_visuals[0].origin );
		
		level.e_dropoff = gobj_visuals[0];

		level waittill ( "raid_goods_picked_up" );
		
		// Setup a USE Radius Trigger
		e_trigger = spawn( "trigger_radius", v_pos, 0, 150, 30 );
		e_trigger TriggerIgnoreTeam();
		e_trigger SetVisibleToAll();
		e_trigger SetTeamForTrigger( "none" );
		//e_trigger UseTriggerRequireLookAt();
		e_trigger SetCursorHint( "HINT_NOICON" );

		// Create the gameobject
		gobj_team = "allies";
		gobj_trigger = e_trigger;
		gobj_objective_name = &"sm_unobtainium_dropoff";
		gobj_offset = ( 0, 0, 0 );
		e_object = gameobjects::create_use_object( gobj_team, gobj_trigger, gobj_visuals, gobj_offset, gobj_objective_name );

		// Setup gameobject params
		e_object gameobjects::allow_use( "friendly" );
		e_object gameobjects::set_use_time( 0.0 );						// How long the progress bar takes to complete
		e_object gameobjects::set_use_text( "" );
		e_object gameobjects::set_use_hint_text( "" );
		e_object gameobjects::set_visible_team( "friendly" );				// How can see the gameobject

		e_object gameobjects::set_objective_entity( gobj_visuals[ 0 ] );
		
		e_object.onUse = &onUse_dropoff;
		
		e_object thread dropoff_complete_watch();
	}	
	
	// Called when a player gets close to the dropoff
	function onUse_dropoff( player )  // self = gameobject
	{
		player endon( "death" );
		player endon( "entering_last_stand" );		
		
		// Is the player carrying an unobtanium crate?
		e_unobtanium = player.carrying_unobtanium;

		if( !IsDefined(e_unobtanium) )
		{
			return;
		}
		
		player goodsobj::player_carry_movement_end();
		
		// scoreevents::processTeamScoreEvent( "ransack_secured_unobtanium" );  // score event may be depricated. -TJanssen 4/3/2014
		
		// Force the player to drop the unobtanium crate
		e_unobtanium goodsobj::target_dropoff();

		level notify( "package_delivered" );
		level notify( "sm_respawn_spectators" );
	}
	
	function spawn_goods( s_spawn_struct )
	{
		assert( IsDefined( s_spawn_struct.target ), "Struct with script_string \"secure_goods\" at " + s_spawn_struct.origin + " must target other structs, used as crate spawn locations" );
		a_crate_points = array::randomize(struct::get_array( s_spawn_struct.target, "targetname" ) );
			
		Assert( ( m_n_goods <= a_crate_points.size ), "cSecureGoods found " + a_crate_points.size + " objective spawn locations, but wants to spawn " + m_n_goods );
		
		a_icons_2d = Array( "t7_hud_waypoints_unob_a", "t7_hud_waypoints_unob_b", "t7_hud_waypoints_unob_c", "t7_hud_waypoints_d" );
		a_icons_3d = Array( "t7_hud_waypoints_unob_a", "t7_hud_waypoints_unob_b", "t7_hud_waypoints_unob_c", "t7_hud_waypoints_d" );
		a_str_clientfields = Array( "sm_inv_unobtanium_a", "sm_inv_unobtanium_b", "sm_inv_unobtanium_c" );
		a_objective_strings = Array( &"sm_unobtainium_carry_a", &"sm_unobtainium_carry_b", &"sm_unobtainium_carry_c" );
		
		for ( i = 0; i < m_n_goods; i++ )
		{
			o_goods = new cGoodsCrate();
			e_gameobject = goodsobj::unobtanium_gameobject( a_crate_points[i].origin, a_crate_points[i].angles, "wpn_t7_prp_unobtainium_box", a_icons_2d[ i ], a_icons_3d[ i ], a_str_clientfields[i], a_objective_strings[ i ] );
			thread [[self]]->add_gameobject( e_gameobject );
			thread [[o_goods]]->start_thinking_gameobject( e_gameobject );

			if ( !isdefined( m_a_goods ) ) m_a_goods = []; else if ( !IsArray( m_a_goods ) ) m_a_goods = array( m_a_goods ); m_a_goods[m_a_goods.size]=o_goods;;
		}
	}
	
	function add_gameobject( e_gameobject )
	{
		m_a_unobtainium_gobj[ m_a_unobtainium_gobj.size ] = e_gameobject;
	}
	
	function crate_success_watch()
	{
		a_vox = Array( "vox_ct_unob_secured_1", "vox_ct_unob_secured_2", "vox_ct_unob_secured_3" );
		
		is_complete = false;
		while ( !is_complete )
		{
			level waittill ( "package_delivered" );
			
			// We've delivered a package at the dropoff point
			// Are there any remaining packages left?
			is_complete = true;
			n_goods_remaining = 0;
			foreach( e_gameobject in m_a_unobtainium_gobj )
			{
				if( !( isdefined( e_gameobject.unobtainium_captured ) && e_gameobject.unobtainium_captured ) )
				{
					is_complete = false;
					n_goods_remaining++;
				}
			}
			
			sm_ui::dock_image_remove( m_n_goods - n_goods_remaining - 1 );  // remove left to right since these don't re-orient themselves, start at index 0 (on screen: 0 1 2, remove order = 1 2 3)
			
			n_line = n_goods_remaining % a_vox.size;
			cSideMissionRoundBase::play_vo_to_all_players( a_vox[ n_line ] );			
		}
		
		level notify( "sm_objective_secure_goods_complete" );
		
		wait 1;  // stagger timing for VO
	}
	
	function dropoff_complete_watch()
	{
		level waittill( "sm_objective_secure_goods_complete" );
		wait( 1 );

		self gameobjects::set_2d_icon( "enemy", undefined );
		self gameobjects::set_3d_icon( "enemy", undefined );
		self gameobjects::set_2d_icon( "friendly", undefined );
		self gameobjects::set_3d_icon( "friendly", undefined );

		self gameobjects::disable_object( true );
		
		self gameobjects::release_all_objective_ids();
	}
	
	function clean_up()
	{
		zone_mgr::clear_all_objective_zones();
		
		foreach ( o_gameobject in m_a_unobtainium_gobj )
		{
			o_gameobject gameobjects::release_all_objective_ids();
		}
	}
	
	function dev_clean_up_round()
	{
		foreach ( o_gameobject in m_a_unobtainium_gobj )
		{
			if ( !( isdefined( o_gameobject.unobtainium_captured ) && o_gameobject.unobtainium_captured ) )
			{
				o_gameobject gameobjects::set_picked_up( level.players[ 0 ] );  // pick up unobtainium
				
				// since onpickup is normally threaded, wait for carrier to be registered for pickup
				while ( !IsDefined( o_gameobject.carrier ) )
				{
					{wait(.05);};
				}
				
				o_gameobject onUse_dropoff( level.players[ 0 ] );  // capture unobtainium
			
				util::wait_network_frame();  // each capture sends a notify, so space them out
			}
		}
		
		stop_wave_spawning_and_kill_all_enemies();
	}		
}


class cGoodsCrate : cPickupItem
{
	var m_radiation_decrease_per_frame;
	var m_radiation_increase_per_frame;
	
	constructor()
	{
		m_n_holding_distance = 32;
		m_n_drop_offset = 16;
		m_str_modelname = "wpn_t7_prp_unobtainium_box";
		m_str_carry_model = "wpn_t7_prp_unobtainium_box";
		m_str_itemname = "Unobtainium";
		
		m_radiation_decrease_per_frame = ( 100 / ( 5 * 20 ) );
		m_radiation_increase_per_frame = ( 100 / ( 11 * 20 ) );
	}
	
	function start_thinking_gameobject( e_gameobject )
	{
		wait 1; // TODO: the spawn function must be threaded due to a loop.  Wait 1 to make sure everything is set.  Find better solution

		thread track_objective_zone_gameobject( e_gameobject );						// Entity zone manager stuff

		thread set_hindrance_on_pickup_gameobject( e_gameobject );					// Player movement and radiation

		thread sndGeigerOnCrate_gameobject( e_gameobject );							// Sound Loop
	}

	function track_objective_zone_gameobject( e_gameobject )
	{
		str_zone = zone_mgr::get_zone_from_position( e_gameobject.visuals[0].origin+(0,0,32), TRUE );
		zone_mgr::set_objective_zone( str_zone );
		
		while( IsDefined(e_gameobject.visuals[0]) )
		{
			if( !e_gameobject.visuals[0] zone_mgr::entity_in_zone(str_zone) )
			{
				zone_mgr::clear_objective_zone( str_zone );

				// If being carried, use players position, else use objects model position
				e_carrier = e_gameobject gameobjects::get_carrier();
				if( IsDefined(e_carrier) )
				{
					v_pos = e_carrier.origin;
				}
				else
				{
					v_pos = e_gameobject.visuals[0].origin;
				}

				v_pos = v_pos + ( 0, 0, 32 );
				str_zone = zone_mgr::get_zone_from_position( v_pos, TRUE );
				zone_mgr::set_objective_zone( str_zone );
			}
			
			wait 1;
		}
		
		zone_mgr::clear_objective_zone( str_zone );
	}

	function set_hindrance_on_pickup_gameobject( e_gameobject )
	{
		wait 1;  // fake pickup delay time
		
		e_holder = e_gameobject gameobjects::get_carrier();
		while ( true )
		{
			while ( !IsDefined( e_holder ) )
			{
				e_holder = e_gameobject gameobjects::get_carrier();
				wait .1;
			}
			
			// Start wave spawning in _sm_initial_spawns
			level notify( "sm_combat_started" );
			
			// Impair movement
			e_old_holder = e_holder;
			
			e_holder goodsobj::player_carry_movement_begin();

			self thread increase_radiation_level( e_old_holder );

			// geiger Sound
			e_old_holder.sndEnt = spawn( "script_origin", e_old_holder.origin );
			e_old_holder.sndEnt linkto( e_old_holder );
			e_old_holder.sndEnt playloopsound( "amb_geiger_loop" );
			//radiation sound
			n_time_remaining = get_time_remaining_to_radiation_max( e_old_holder );
			e_old_holder.sndEnt2 = spawn( "script_origin", e_old_holder.origin );
			e_old_holder.sndEnt2 linkto( e_old_holder );
			e_old_holder.sndEnt2 playloopsound( "evt_radiation_plr" , n_time_remaining );
			//IPrintLnBold( n_time_remaining );

			while ( IsDefined( e_holder ) && e_old_holder == e_holder )
			{
				m_n_last_reminder = GetTime();
				e_holder = e_gameobject gameobjects::get_carrier();
				wait .1;
			}

			// Restore movement
			e_old_holder goodsobj::player_carry_movement_end();

			
			
			self thread decrease_radiation_level( e_old_holder );

			// clean up sound
			e_old_holder.sndEnt delete();
			e_old_holder.sndEnt = undefined;
			e_old_holder.sndEnt2 delete();
			e_old_holder.sndEnt2 = undefined;
		}
	}
	
	function increase_radiation_level( player )
	{
		player endon( "death" );
		player endon( "radiation_increase_stop" );
		
		player notify( "radiation_decrease_stop" );
		
		wait 0.5;  // TODO: add pickup animation. Don't raise radiation level while picking up crate	
		
		if(!isdefined(player.sm_ransack_radiation))player.sm_ransack_radiation=0;
		if(!isdefined(player.sm_ransack_radiation_hud))player.sm_ransack_radiation_hud=create_radiation_hud( player, 75 );
		if(!isdefined(player.sm_ransack_radiation_hud_text))player.sm_ransack_radiation_hud_text=create_radiation_hud( player, 0, &"SM_PROMPT_GOODS_RADIATION" );
	
		b_warned_player = false;
		
		while ( true )
		{
			player.sm_ransack_radiation = math::clamp( player.sm_ransack_radiation + m_radiation_increase_per_frame, 0, 100 );

			player show_radiation_level();
			n_time_remaining = get_time_remaining_to_radiation_max( player );
			
			if ( player.sm_ransack_radiation == 100 )
			{
				n_damage_amount = 10;
				n_delay = 1;
				
				if ( !b_warned_player )
				{
					n_damage_amount = 1;
					n_delay = 2;
					thread [[self]]->flash_drop_prompt( player );
					
					cSideMissionRoundBase::play_vo_to_all_players( "vox_ct_unob_radioactive" );
					
					b_warned_player = true;
				}
				
				player DoDamage( n_damage_amount, player.origin );
			
				wait n_delay;
			}
			
			{wait(.05);};
		}
	}
	
	function get_time_remaining_to_radiation_max( player )
	{
		if(!isdefined(player.sm_ransack_radiation))player.sm_ransack_radiation=0;
		return 11 - ( ( player.sm_ransack_radiation / m_radiation_increase_per_frame ) * 0.05 );
	}
	
	function get_time_remaining_to_radiation_min( player, b_use_delay = true )  // self = player
	{
		if(!isdefined(player.sm_ransack_radiation))player.sm_ransack_radiation=0;
		
		n_delay = 0;
		
		if ( b_use_delay )
		{
			n_delay = 5;
		}
		
		return n_delay + ( ( player.sm_ransack_radiation / m_radiation_decrease_per_frame ) * 0.05 );
	}
	
	function show_radiation_level()  // self = player
	{
		// don't show visionset or hud elements while in last stand
		if ( self laststand::player_is_in_laststand() || !IsDefined( self.sm_ransack_radiation ) || self.sm_ransack_radiation <= 0 )
		{
			if ( IsDefined( self.sm_ransack_radiation_hud ) )
			{
				self.sm_ransack_radiation_hud SetText( "" );
				self.sm_ransack_radiation_hud_text SetText( "" );	
			}
			
			self clientfield::set_to_player( "sm_secure_goods_sfx", 0 );
			
			// Vision Set
			self clientfield::set_to_player( "sm_secure_goods_visionset", 0 );
			
			// Blur
			self clientfield::set_to_player( "sm_secure_goods_blur", 0 );
			
			// Overlay
			self clientfield::set_to_player( "sm_secure_goods_intensity", 0 );
		}
		else
		{
			self.sm_ransack_radiation_hud SetValue( Int( self.sm_ransack_radiation ) );
			self.sm_ransack_radiation_hud_text SetText( &"SM_PROMPT_GOODS_RADIATION" );
			
			self clientfield::set_to_player( "sm_secure_goods_sfx", 1 );

			// Vision Set
			if ( self.sm_ransack_radiation >= 33 )
			{
				n_vision_amount = math::linear_map( self.sm_ransack_radiation * 0.01, 33 * 0.01, 1.00, 0.00, 1.00 );

				self clientfield::set_to_player( "sm_secure_goods_visionset", n_vision_amount );
			}
			
			// Blur
			if ( self.sm_ransack_radiation >= 66 )
			{
				n_blur_amount = math::linear_map( self.sm_ransack_radiation, 66, 100, 0, 1.0 );
				
				self clientfield::set_to_player( "sm_secure_goods_blur", n_blur_amount );
			}
			
			// Overlay
			if ( self.sm_ransack_radiation >= 99 )
			{
				n_intensity_amount = self clientfield::get_to_player( "sm_secure_goods_intensity" );
				
				if ( n_intensity_amount < 0.15 && self.maxhealth == self.health ) // Do buildup prior to the damage delay to minimize pop
				{
					n_intensity_amount += ( 0.01 );
				}
				else
				{					
					n_intensity_amount = math::linear_map( self.maxhealth - self.health, 0, self.maxhealth, 0.15, 1.00 );
				}
				
				self clientfield::set_to_player( "sm_secure_goods_intensity", n_intensity_amount );
			}
		}
	}
	
	function decrease_radiation_level( player )
	{
		player endon( "death" );
		player endon( "radiation_decrease_stop" );
		
		player notify( "radiation_increase_stop" );
		
		[[self]]->flash_drop_prompt_stop( player );
		
		player show_radiation_level();  // call here in case player died holding crate
		
		n_time_remaining = get_time_remaining_to_radiation_min( player, true );
		
		wait 5;
		
		if(!isdefined(player.sm_ransack_radiation))player.sm_ransack_radiation=0;
		if(!isdefined(player.sm_ransack_radiation_hud))player.sm_ransack_radiation_hud=create_radiation_hud( player, 75 );
		if(!isdefined(player.sm_ransack_radiation_hud_text))player.sm_ransack_radiation_hud_text=create_radiation_hud( player, 0, &"SM_PROMPT_GOODS_RADIATION" );
		
		while ( player.sm_ransack_radiation > 0 )
		{
			player.sm_ransack_radiation = math::clamp( player.sm_ransack_radiation - m_radiation_decrease_per_frame, 0, 100 );
			
			player show_radiation_level();
			
			n_time_remaining = get_time_remaining_to_radiation_min( player, false );
			
			{wait(.05);};
		}
		
		player.sm_ransack_radiation_hud Destroy();
		player.sm_ransack_radiation_hud_text Destroy();
	}
	
	function create_radiation_hud( player, x_offset = 0, str_text )
	{
		hud_elem = NewClientHudElem( player );
		hud_elem.horzAlign = "center";
		hud_elem.vertAlign = "middle";
		hud_elem.sort = 2;
		hud_elem.hidewheninmenu = true;
		hud_elem.immunetodemogamehudsettings = true;
	
		hud_elem.x = -50 + x_offset;
		hud_elem.y = 150;
		
		hud_elem.fontscale = 2;
		
		if ( IsDefined( str_text ) )
		{
			hud_elem SetText( str_text );
		}
		
		return hud_elem;
	}
	
	function sndGeigerOnCrate_gameobject( e_gameobject )
	{
		m_goods = e_gameobject.visuals[0] ;
		m_goods playloopsound( "amb_geiger_loop" );
	}
}


//*****************************************************************************
//*****************************************************************************
// unobtanium gameobject
//*****************************************************************************
//*****************************************************************************

#namespace goodsobj;

function unobtanium_gameobject( v_pos, v_angles, str_model_name, str_icon_2d, str_icon_3d, str_carrying_clientfield, str_objective_string )
{
	// Setup a USE Trigger
	v_trigger_offset = ( 0, 0, 4 ); //handles edges cases where the origin of the struct competes with geo
	e_trigger = spawn( "trigger_radius_use", v_pos + v_trigger_offset, 0, 96, 30 );
	e_trigger TriggerIgnoreTeam();
	e_trigger SetVisibleToAll();
	e_trigger SetTeamForTrigger( "none" );
	e_trigger UseTriggerRequireLookAt();
	e_trigger SetHintString( &"SM_PROMPT_GOODS_CARRY" );
	e_trigger SetCursorHint( "HINT_INTERACTIVE_PROMPT" );

	// Set Model
	visuals[ 0 ] = util::spawn_model( str_model_name, v_pos, v_angles );
	visuals[ 0 ] NotSolid();							// Turn off collision
	visuals[ 0 ] sm_ui::interact_prompt_set( 4 );
	visuals[ 0 ] LinkTo( e_trigger );
	
	sm_round_objective::defend_object_add( visuals[ 0 ] );

	// Set gameobject
	v_icon_offset = ( 0, 0, 23 );
	e_object = gameobjects::create_carry_object( "allies", e_trigger, visuals, v_icon_offset, str_objective_string );
	e_object gameobjects::allow_carry( "friendly" );

	e_object gameobjects::set_2d_icon( "enemy", str_icon_2d );
	e_object gameobjects::set_3d_icon( "enemy", str_icon_3d );
	
	e_object gameobjects::set_2d_icon( "friendly", str_icon_2d );
	e_object gameobjects::set_3d_icon( "friendly", str_icon_3d ); 

	e_object gameobjects::set_visible_team( "friendly" );
	
	e_object gameobjects::set_objective_entity( visuals[ 0 ] );

	//e_object.objIDPingEnemy = true;				// If true the 2d radar updates as a ping, else its a constant smooth 2d radar update
	//e_object.objIDPingFriendly = true;

	e_object.onPickup = &onPickup;
	e_object.onDrop = &onDrop;
	
	e_object.str_carrying_clientfield = str_carrying_clientfield;

	//e_object.autoResetTime = 60.0;				// If dropped, go back to home position after X seconds, 0 = never move back

	e_object.allowWeapons = false;					// If FALSE, player weapon is automatically taken away when object picked up
	
	return( e_object );
}


//*****************************************************************************
// gameobject: Pickup
//*****************************************************************************
function onPickup( player )
{
	self.visuals[0] sm_ui::interact_prompt_remove();
	self.visuals[0] Unlink();
	
	player.carrying_unobtanium = self;

	// Wait for the player to press USE to drop
	self thread wait_for_user_to_drop( player );

	// Notify the goods have been picked up
	level notify ( "raid_goods_picked_up" );
	
	sm_ui::inventory_pickup( self.str_carrying_clientfield, player );

	// Prompt
	player util::screen_message_create_client( &"SM_PROMPT_GOODS_DROP" );

	// Carry object in 3D
	player thread goodsobj::attach_pickup_to_player( self, "wpn_t7_prp_unobtainium_box" );
}

// self = gameobject
function wait_for_user_to_drop( player )
{
	player endon( "disconnect" );
	//player endon("entering_last_stand");
	self endon( "death" );
	self endon( "unobtainium_captured" );

	// Wait until the player release the button
	while( player UseButtonPressed() )
	{
		{wait(.05);};
	}

	drop_at_origin = 0;

	// Wait for it to be pressed again
	while( 1 )
	{
		if( player UseButtonPressed() )
		{
			// Drop at players feet or return to pickup point?
			if( drop_at_origin )
			{
				e_obj = player.carryObject;
			}
			player.carryObject gameobjects::set_dropped();
			if( drop_at_origin )
			{
				e_obj gameobjects::return_home();
			}
			break;
		}

		// TODO - This seems like a hack, the gameobject system should be doing this
		if( player laststand::player_is_in_laststand() )
		{
			self gameobjects::allow_carry( "friendly" );
			break;
		}

		// If the carry is forced to break (can happen with collision problems), then kill thread
		if( !IsDefined(player.carryObject) )
		{
			self gameobjects::allow_carry( "friendly" );
			break;
		}

		{wait(.05);};
	}
}

// Attach a model to the player while carrying it
// self = player
function attach_pickup_to_player( e_gameobject, str_model )
{
	holding_offset_angle = ( 30, 0, 0 );
	holding_distance = 40;	// 26
	holding_angle = (0, 0, 0);
	
	// find in front of player to attach pickup
	v_eye_origin = self GetEye();
	v_player_angles = self GetPlayerAngles();
	v_player_angles += holding_offset_angle;
	v_player_angles = AnglesToForward( v_player_angles );
	pos = v_eye_origin + ( v_player_angles * holding_distance );
	
	carry_obj = e_gameobject.visuals[ 0 ];
	carry_obj.angles = self.angles + holding_angle;
	
	carry_obj setModel( str_model );
	carry_obj NotSolid();
	carry_obj Show();

	while( 1 )
	{
		e_carrier = e_gameobject gameobjects::get_carrier();
		if( !IsDefined(e_carrier) )
		{
			break;
		}
		v_eye_origin = self GetEye();
		v_player_angles = self GetPlayerAngles();
		v_player_angles += holding_offset_angle;
		v_player_angles = AnglesToForward( v_player_angles );
			
		carry_obj.angles = self.angles + holding_angle;
		carry_obj.origin = v_eye_origin + ( v_player_angles * holding_distance );
		{wait(.05);};
	}

	carry_obj Unlink();
	carry_obj LinkTo( e_gameobject.trigger );
}

//*****************************************************************************
// gameobject: Drop
//*****************************************************************************
function onDrop( player )
{	
	if ( IsDefined( player ) )
	{
		player.carrying_unobtanium = undefined;
		
		player util::screen_message_delete_client();
	
		// Drop the object in the same orientation as it's currently carried by the player
		self.visuals[0].angles = player.angles;
		
		sm_ui::inventory_drop( self.str_carrying_clientfield, player );
	}

	if ( !( isdefined( self.unobtainium_captured ) && self.unobtainium_captured ) )
	{
		self.visuals[0] LinkTo( self.trigger );
		self.visuals[0] sm_ui::interact_prompt_set( 4 );
		self gameobjects::allow_carry( "friendly" );
	}
	
	self gameobjects::set_objective_entity( self.visuals[ 0 ] );	
}

// self = gameobject
function target_dropoff()
{
	self notify( "unobtainium_captured" );
	self.unobtainium_captured = 1;

	sm_round_objective::defend_object_remove( self.visuals[ 0 ] );
	self.visuals[0] sm_ui::interact_prompt_remove();
	self.visuals[0] Unlink();
	
	util::wait_network_frame();
	
	self gameobjects::set_dropped();
	
	self gameobjects::disable_object( true );
	//self gameobjects::destroy_object( 1, 1 );
	
	// set objective to "done" as unobtainium is captured
	foreach ( n_id in self gameobjects::get_objective_ids( self.ownerTeam ) )
	{
		Objective_State( n_id, "done" );
	}
}

//*****************************************************************************
//*****************************************************************************

// self = player
function player_carry_movement_begin()
{
	self SetMoveSpeedScale( 0.7 );
	self AllowSprint( false );
	self AllowJump( false );
	self SetCarryingObject( true );  // disables doublejump and juke
}

function player_carry_movement_end()
{
	self SetMoveSpeedScale( 1 );
	self AllowSprint( true );
	self AllowJump( true );
	self SetCarryingObject( false );  // enables doublejump and juke
}

