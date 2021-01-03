#using scripts\codescripts\struct;

#using scripts\shared\array_shared;
#using scripts\shared\ai_shared;
#using scripts\shared\clientfield_shared;
#using scripts\shared\flag_shared;
#using scripts\shared\gameobjects_shared;
#using scripts\shared\hud_util_shared;
#using scripts\shared\laststand_shared;
#using scripts\shared\math_shared;
#using scripts\shared\scene_shared;
#using scripts\shared\system_shared;
#using scripts\shared\util_shared;
#using scripts\shared\vehicle_shared;

#using scripts\cp\sidemissions\_sm_type_base;
#using scripts\cp\sidemissions\_sm_ui;
#using scripts\cp\sidemissions\_sm_ui_worldspace;
#using scripts\cp\sidemissions\_sm_zone_mgr;
#using scripts\cp\sidemissions\_sm_manager;
#using scripts\cp\sidemissions\_sm_wave_mgr;

#using scripts\cp\_pickups;
#using scripts\cp\_laststand;
#using scripts\cp\_oed;
#using scripts\cp\_util;
#using scripts\cp\_scoreevents;

    	   	                                                                                                                         	                                                                                                                                                                                                                                                                                                                                                                    	        	     	             	    	   	                           	                               	                                	                                                              	                                                                                                              	                            	                                     	                                       	                                                               	   	                  	       	                                                    	                   	                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                      	                                                                                        	           	                        	                                            	                                             	                                                   	                                                             	                                                         	                                                                    	                                                                                                                                                                                                    	                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                    	                                                              	                                                          	                                   	                                   	                                                    	                                       
                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                            	                                                                                                                                                                                                                                                                                                                                                                                       

          











	












	



 // client screen message appears on top of progress bar otherwise


	






	


	


	



#precache( "material", "hud_suitcase_bomb" );
#precache( "material", "t7_hud_waypoints_a" );
#precache( "material", "t7_hud_waypoints_b" );
#precache( "material", "t7_hud_waypoints_c" );
#precache( "material", "t7_hud_waypoints_d" );
#precache( "material", "t7_hud_prompt_drop_64" );
#precache( "material", "t7_hud_prompt_press_64" );
#precache( "material", "t7_hud_waypoints_arrow" );

#precache( "model", "wpn_t7_prp_unobtainium_box" );
#precache( "model", "t6_wpn_supply_drop_detect" );

#precache( "string", "SM_TYPE_SECURE_GOODS_OBJ_MAIN" );
#precache( "string", "SM_TYPE_SECURE_GOODS_OBJ_MOVE" );
#precache( "string", "SM_TYPE_SECURE_GOODS_OBJ_MOVE_PAUSE" );
#precache( "string", "SM_TYPE_SECURE_GOODS_OBJ_SECURITY" );
#precache( "string", "SM_TYPE_SECURE_GOODS_OBJ_SECURITY_PAUSE" );
#precache( "string", "SM_TYPE_SECURE_GOODS_OBJ_SECURITY_DONE" );
#precache( "string", "SM_TYPE_SECURE_GOODS_OBJ_SECURITY_STATUS" );
#precache( "string", "SM_TYPE_SECURE_GOODS_OBJ_MOVE_DONE" );
#precache( "string", "SM_TYPE_SECURE_GOODS_OBJ_MOVE_STATUS" );
#precache( "string", "SM_TYPE_SECURE_GOODS_OBJ_DEFEND" );
#precache( "string", "SM_TYPE_SECURE_GOODS_OBJ_DEFEND_PAUSE" );
#precache( "string", "SM_TYPE_SECURE_GOODS_OBJ_DEFEND_DONE" );
#precache( "string", "SM_TYPE_SECURE_GOODS_OBJ_DEFEND_STATUS_TIME" );
#precache( "string", "SM_TYPE_SECURE_GOODS_OBJ_DEFEND_STATUS_HEALTH" );
#precache( "string", "SM_TYPE_SECURE_GOODS_OBJ_EXFIL" );
#precache( "string", "SM_TYPE_SECURE_GOODS_OBJ_EXFIL_PAUSE" );
#precache( "string", "SM_TYPE_SECURE_GOODS_OBJ_EXFIL_STATUS" );

#precache( "string", "SM_TYPE_SECURE_GOODS_VO_DEFEND_ANNOUNCE" );
#precache( "string", "SM_TYPE_SECURE_GOODS_VO_DEFEND_DONE" );
#precache( "string", "SM_TYPE_SECURE_GOODS_VO_DEFEND_FAIL_SOFT" );
#precache( "string", "SM_TYPE_SECURE_GOODS_VO_DEFEND_FAIL_HARD" );
#precache( "string", "SM_TYPE_SECURE_GOODS_VO_DEFEND_PROGRESS" );
#precache( "string", "SM_TYPE_SECURE_GOODS_VO_EXFIL_ANNOUNCE" );
#precache( "string", "SM_TYPE_SECURE_GOODS_VO_EXFIL_DONE" );
#precache( "string", "SM_TYPE_SECURE_GOODS_VO_EXFIL_ENCOURAGE" );
#precache( "string", "SM_TYPE_SECURE_GOODS_VO_EXFIL_FAIL_HARD" );
#precache( "string", "SM_TYPE_SECURE_GOODS_VO_INFIL_ANNOUNCE" );
#precache( "string", "SM_TYPE_SECURE_GOODS_VO_MOVE_ANNOUNCE" );
#precache( "string", "SM_TYPE_SECURE_GOODS_VO_MOVE_DONE" );
#precache( "string", "SM_TYPE_SECURE_GOODS_VO_MOVE_FAIL_SOFT" );
#precache( "string", "SM_TYPE_SECURE_GOODS_VO_MOVE_PROGRESS_1" );
#precache( "string", "SM_TYPE_SECURE_GOODS_VO_MOVE_PROGRESS_2" );
#precache( "string", "SM_TYPE_SECURE_GOODS_VO_MOVE_PROGRESS_3" );
#precache( "string", "SM_TYPE_SECURE_GOODS_VO_MOVE_PROGRESS" );
#precache( "string", "SM_TYPE_SECURE_GOODS_VO_SECURITY_ANNOUNCE" );
#precache( "string", "SM_TYPE_SECURE_GOODS_VO_SECURITY_DONE" );
#precache( "string", "SM_TYPE_SECURE_GOODS_VO_SECURITY_ENCOURAGE_1" );
#precache( "string", "SM_TYPE_SECURE_GOODS_VO_SECURITY_ENCOURAGE_2" );
#precache( "string", "SM_TYPE_SECURE_GOODS_VO_SECURITY_ENCOURAGE_3" );
#precache( "string", "SM_TYPE_SECURE_GOODS_VO_SECURITY_FAIL_SOFT" );
#precache( "string", "SM_TYPE_SECURE_GOODS_VO_SECURITY_PROGRESS" );

#precache( "string", "SM_TYPE_SECURE_GOODS_PROMPT_GOODS_CARRY" );
#precache( "string", "SM_TYPE_SECURE_GOODS_PROMPT_GOODS_CAPTURE" );
#precache( "string", "SM_TYPE_SECURE_GOODS_PROMPT_GOODS_DROP" );
#precache( "string", "SM_TYPE_SECURE_GOODS_PROMPT_SECURITY" );
#precache( "string", "SM_TYPE_SECURE_GOODS_PROMPT_SECURITY_USE" );
#precache( "string", "SM_TYPE_SECURE_GOODS_PROMPT_SECURITY_LEFT_WIRE" );
#precache( "string", "SM_TYPE_SECURE_GOODS_PROMPT_SECURITY_RIGHT_WIRE" );
#precache( "string", "SM_TYPE_SECURE_GOODS_PROMPT_RADIATION" );

#precache( "string", "SM_TYPE_SECURE_GOODS_OBJ_SECURITY_TEMP_START" );
#precache( "string", "SM_TYPE_SECURE_GOODS_OBJ_SECURITY_TEMP_DONE" );

function autoexec __init__sytem__() {     system::register("sm_type_secure_goods",&__init__,undefined,undefined);    }
	
function __init__()
{
	clientfield::register( "toplayer", "sm_secure_goods_sfx", 			1, 1, "int" );
	clientfield::register( "toplayer", "sm_secure_goods_blur", 			1, 7, "float" );
	clientfield::register( "toplayer", "sm_secure_goods_intensity",	1, 7, "float" );
	clientfield::register( "toplayer", "sm_secure_goods_visionset", 1, 7, "float" );
	
	clientfield::register( "scriptmover", "sm_secure_goods_circuit_breaker_panel_fx", 1, 1, "int" );
	
	clientfield::register( "world", "sm_ransack_inv_unobtanium_a", 1, 3, "int" );
	clientfield::register( "world", "sm_ransack_inv_unobtanium_b", 1, 3, "int" );
	clientfield::register( "world", "sm_ransack_inv_unobtanium_c", 1, 3, "int" );
}

class cSecureGoods : cSideMissionBase
{
	var m_n_goods;
	var m_a_goods;
	var m_m_dropoff;
	var m_hud_waypoint;
	var m_n_last_reminder;
	var m_str_dropoff_zone;
	var	m_a_unobtainium_gobj;
		
	constructor()
	{
		m_a_unobtainium_gobj = [];

		_precache();
	}

	function clean_up()
	{
//#if 0
//		if ( IsDefined( m_str_dropoff_zone ) )
//		{
//			zone_mgr::clear_objective_zone( m_str_dropoff_zone );
//		}
//#endif
	}
	
	function _precache()
	{

	}
	
	function init()
	{
		m_n_last_reminder = GetTime();
		
		vehicle::add_spawn_function( "sm_ransack_exfil", &sm_ransack::sm_ransack_exfil_think );
		
		/#
			AddDebugCommand( "devgui_cmd \"Sidemission/Ransack/Exfil/Call:1\" \"set level_notify sm_exfil_call\"\n" );
			AddDebugCommand( "devgui_cmd \"Sidemission/Ransack/Exfil/Skip Defend:1\" \"set level_notify sm_exfil_skip_defend\"\n" );
		#/
		
		thread onPlayerConnect();
	}
	
	function onPlayerConnect()
	{
		level endon ( "raid_complete" );
		
		while ( true )
		{
			level waittill ( "connecting", player );
		}
	}
	
	function start_objective( n_round, n_goods = 1 )
	{
		sidemission_type_base::clear_jumpto();
		
		sm_ui::temp_vo( &"SM_TYPE_SECURE_GOODS_VO_INFIL_ANNOUNCE" );
		
		wait 4;
		
		self thread vo_mission_fail();
		
		sm_manager::add_objective( new cObjSecureGoodsSecurity() );	
		sm_manager::add_objective( init_objective_move( n_round, n_goods ) );
		sm_manager::add_objective( new cObjSecureGoodsDefend() );
		sm_manager::add_objective( new cObjSecureGoodsExfil() );
		
		sm_manager::start_objectives();
		sm_manager::waittill_complete();
		wait 1.0;
		cSideMissionBase::sidemission_success();
	}
	
	// use this for test maps to bypass other objectives
	function start_crate_test( n_round, n_goods = 1 )
	{
		sm_manager::add_objective( init_objective_move( n_round, n_goods ) );
		
		sm_manager::start_objectives();
	}
	
	// initializing a class doesn't currently support input arguments, so initialize this manually. -TJanssen 3/20/2014
	function init_objective_move( n_round, n_goods )
	{
		o_objective = new cObjSecureGoodsMove();
		
		[[o_objective]]->set_custom_round( n_round );
		[[o_objective]]->set_custom_goods_count( n_goods );
		
		return o_objective;
	}
	
	function vo_mission_fail()
	{	
		level.sm_manager endon( "all_objectives_complete" );
		level endon( "sidemission_objective_complete" );
		
		level waittill( "game_ended" );
		
		sm_ui::temp_vo( &"SM_TYPE_SECURE_GOODS_VO_EXFIL_FAIL_HARD", "vox_ct_operatives_down" );
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
		m_radiation_increase_per_frame = ( 100 / ( 15 * 20 ) );
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
		
//		zone_mgr::clear_objective_zone( str_zone );
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
		if(!isdefined(player.sm_ransack_radiation_hud_text))player.sm_ransack_radiation_hud_text=create_radiation_hud( player, 0, &"SM_TYPE_SECURE_GOODS_PROMPT_RADIATION" );
	
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
					
					sm_ui::temp_vo( &"SM_TYPE_SECURE_GOODS_VO_MOVE_FAIL_SOFT", "vox_ct_unob_radioactive" );
					
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
		return 15 - ( ( player.sm_ransack_radiation / m_radiation_increase_per_frame ) * 0.05 );
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
			self.sm_ransack_radiation_hud_text SetText( &"SM_TYPE_SECURE_GOODS_PROMPT_RADIATION" );
			
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
		if(!isdefined(player.sm_ransack_radiation_hud_text))player.sm_ransack_radiation_hud_text=create_radiation_hud( player, 0, &"SM_TYPE_SECURE_GOODS_PROMPT_RADIATION" );
		
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

#namespace sm_ransack;
function sm_ransack_exfil_think()  // self = exfil vehicle
{
	self.team = "allies";  // heli_vtol is axis by default
	
	self waittill( "reached_end_node" );
	
	level notify( "sm_vtol_arrived" );
}

function get_living_players()
{
	a_players = [];
	
	foreach ( player in level.players )
	{
		if ( IsAlive( player ) )  // this should return false for spectators, and true for players in last stand
		{
			if ( !isdefined( a_players ) ) a_players = []; else if ( !IsArray( a_players ) ) a_players = array( a_players ); a_players[a_players.size]=player;;
		}
	}
	
	return a_players;
}

function get_living_player_count()
{
	return get_living_players().size;
}

function push_all_ai_into_combat()
{
	foreach ( ai_enemy in GetAIArray( "axis" ) )
	{
		if ( ( ai_enemy.script_noteworthy === "scene" ) )
		{
			ai_enemy StopAnimScripted();  // not using scene::stop since this guy may not be the root of the scene
		}
		
		if ( !ai_enemy flag::exists( "approach_players_thread" ) )
		{
			ai_enemy thread wave_mgr::approach_players();  // override infil behavior and attack players
		}
		
		// ai_enemy ai::force_awareness_to_combat();
	}
}

/******************************************************************************
 * OBJECTIVES
 *****************************************************************************/
class cObjSecureGoodsSecurity : cSidemissionObjective
{
	var m_m_panel;
	var m_m_panel_door;
	var m_trigger;
	var m_objective;
	var m_o_worldspace;
	
	constructor()
	{
		// set up trigger for circuit breaker panel
		const TRIGGER_SPAWN_FLAGS = 0;
		const TRIGGER_RADIUS = 32;
		const TRIGGER_HEIGHT = 32;
		
		v_offset = ( 0, 0, -46 );
		
		s_panel = struct::get( "circuit_breaker_panel_struct", "targetname" );
		
		m_trigger = Spawn( "trigger_radius_use", s_panel.origin + v_offset, TRIGGER_SPAWN_FLAGS, TRIGGER_RADIUS, TRIGGER_HEIGHT );
		m_trigger.angles = s_panel.angles;  // used in temp anim setup for player orientation
		m_trigger SetCursorHint( "HINT_NOICON" );
		m_trigger TriggerIgnoreTeam();
		
		// set up circuit breaker panel model
		m_m_panel = util::spawn_model( "p7_int_electric_meter_01", s_panel.origin, s_panel.angles );		
		m_m_panel_door = util::spawn_model( "p7_int_electric_meter_01_door", s_panel.origin, s_panel.angles );
	}
	
	destructor()
	{
		if ( isdefined( m_trigger ) ) { m_trigger Delete(); };
	}
	
	function level_init()
	{
		add_intro_vo( &"SM_TYPE_SECURE_GOODS_VO_SECURITY_ANNOUNCE", "vox_ct_sec_system" );
		add_intro_splash( &"SM_TYPE_SECURE_GOODS_OBJ_MAIN", &"SM_TYPE_SECURE_GOODS_OBJ_SECURITY" );
		add_outro_splash( &"SM_TYPE_SECURE_GOODS_OBJ_MAIN", &"SM_TYPE_SECURE_GOODS_OBJ_SECURITY_DONE" );
		
		add_pause_objective( &"SM_TYPE_SECURE_GOODS_OBJ_SECURITY_PAUSE" );
		
		add_outro_vo( &"SM_TYPE_SECURE_GOODS_VO_SECURITY_DONE", "vox_ct_sec_offline" );
	}

	function main()
	{
		m_trigger thread vo_circuit_breaker_panel_approach();
		self thread vo_encouragement();
		self thread vo_soft_fail();
		
		set_zone_mode();
		
		m_o_worldspace = sm_ransack::worldspace_prompt_create( m_trigger, 512, &"SM_TYPE_SECURE_GOODS_PROMPT_SECURITY", &"SM_TYPE_SECURE_GOODS_PROMPT_SECURITY_USE", 52, "t7_hud_prompt_press_64", -60 );
		m_o_worldspace.m_e_parent thread sm_ransack::worldspace_icon_3d_show( "t7_hud_prompt_press_64", 52 );
		
		e_temp = util::spawn_model( "tag_origin", m_trigger.origin, m_trigger.angles );  // important: sm_ui::icon_add won't work with a trigger for some reason, so use a temp model.
		sm_ui::icon_add( e_temp, "interact" );
		
		m_trigger thread circuit_breaker_panel_think( m_o_worldspace, m_m_panel, m_m_panel_door );
		
		thread sidemission_type_base::set_jumpto( m_trigger.origin, "Ransack/Security Panel" );
		
		level waittill( "sm_secure_goods_security_disabled" );
		
		e_temp sm_ransack::reset_objective_color();
		
		e_temp Delete();
		
		m_o_worldspace.m_e_parent sm_ransack::worldspace_icon_3d_hide();
		m_o_worldspace sm_ransack::worldspace_prompt_delete();
		
		self notify( "objective_complete" );
	}
	
	function vo_circuit_breaker_panel_approach()
	{
		self endon( "death" );
		
		const DISTANCE_TO_PLAY_VO = 500;
		
		n_distance_squared = ( DISTANCE_TO_PLAY_VO * DISTANCE_TO_PLAY_VO );
		
		b_played_line = false;
		
		while ( !b_played_line )
		{
			foreach ( player in level.players )
			{
				if ( ( Distance2DSquared( player.origin, self.origin ) < n_distance_squared ) && player util::is_player_looking_at( self.origin, 0.65, false ) )
				{
					sm_ui::temp_vo( &"SM_TYPE_SECURE_GOODS_VO_SECURITY_PROGRESS", "vox_ct_disable_sec" );
					b_played_line = true;
				}
			}
			
			wait 1;
		}
	}
	
	function vo_encouragement()
	{
		self endon( "objective_complete" );
		level endon( "sm_secure_goods_security_disabled" );
	
		a_subtitles = Array( &"SM_TYPE_SECURE_GOODS_VO_SECURITY_ENCOURAGE_1", &"SM_TYPE_SECURE_GOODS_VO_SECURITY_ENCOURAGE_2", &"SM_TYPE_SECURE_GOODS_VO_SECURITY_ENCOURAGE_3" );
		a_vox = Array( "vox_ct_sec_down_1", "vox_ct_sec_down_2", "vox_ct_sec_down_3" );
		
		n_counter = 0;
		
		while ( true )
		{
			wait RandomFloatRange( 15, 30 );
			
			n_line = n_counter % a_vox.size;
			
			sm_ui::temp_vo( a_subtitles[ n_line ], a_vox[ n_line ] );
			
			n_counter++;
		}
	}
	
	function vo_soft_fail()
	{
		self endon( "objective_complete" );
		
		level waittill( "sm_combat_started" );  // comes from _sm_initial_spawns when AI goes into combat
		
		sm_ui::temp_vo( &"SM_TYPE_SECURE_GOODS_VO_SECURITY_FAIL_SOFT", "vox_ct_been_detected" );
	}
	
	function set_zone_mode()
	{
		zone_mgr::set_mode( "objective_unoccupied" );
	}
	
	function circuit_breaker_panel_think( m_o_worldspace, m_m_panel, m_m_panel_door )  // self = trigger
	{
		self flag::init( "start_anim_done" );
		self flag::init( "wire_rip_right_done" );
		self flag::init( "wire_rip_left_done" );
		
		// store the models on the trigger since we'll use them later 
		self.m_panel = m_m_panel;
		self.m_panel_door = m_m_panel_door;
		
		do
		{
//			 self SetHintString( &"SM_TYPE_SECURE_GOODS_PROMPT_SECURITY_USE" );  // left in commented out since it's annoying to test trigger radius consistency between worldspace UI and trigger since they don't work together.
			m_o_worldspace sm_ransack::worldspace_prompt_show();
			
			self waittill( "trigger", player );
			
			if ( !player is_player_valid() )
			{
				continue;
			}
			
			m_o_worldspace sm_ransack::worldspace_prompt_hide();
//			 self SetHintString( "" );
			
			b_event_completed = self circuit_breaker_panel_interactive_sequence( player );
		}
		while ( !b_event_completed );
		
		level notify( "sm_secure_goods_security_disabled" );
		level notify( "sm_respawn_spectators" );
	}
	
	function circuit_breaker_panel_interactive_sequence( player )  // self = trigger
	{
		player temp_player_lock_in_place( self );
		
		self circuit_breaker_start_anim( player );
		self circuit_breaker_wire_rip_left( player );
		self circuit_breaker_wire_rip_right( player );
		
		player temp_player_lock_in_place_remove();
		
		b_sequence_complete = ( flag::get( "start_anim_done" ) && flag::get( "wire_rip_right_done" ) && flag::get( "wire_rip_left_done" ) );
		
		return b_sequence_complete;	
	}
	
	function circuit_breaker_start_anim( player )
	{
		if ( IsDefined( player ) )
		{
			if ( !self flag::get( "start_anim_done" ) )
			{
				m_progress_bar = player hud::createPrimaryProgressBar();
				m_progress_bar thread do_bar_update( 3 );		
				
				player util::screen_message_create_client( &"SM_TYPE_SECURE_GOODS_OBJ_SECURITY_TEMP_START", undefined, undefined, -60 );

				self play_circuit_breaker_panel_start_anim( player );	
				
				m_progress_bar notify( "kill_bar" );
				m_progress_bar hud::destroyElem();

				if ( IsDefined( player ) )
				{
					player util::screen_message_delete_client();
				}
			}
		}
	}
	
	function circuit_breaker_wire_rip_left( player )
	{
		if ( IsDefined( player ) && player is_player_valid() )
		{
			if ( !self flag::get( "wire_rip_left_done" ) )
			{
				// prompt player to push left on left stick
				player util::screen_message_create_client( &"SM_TYPE_SECURE_GOODS_PROMPT_SECURITY_LEFT_WIRE", undefined, undefined, -60 );
				
				// wait for input
				self wait_for_left_stick_input( player );
				
				if ( IsDefined( player ) )
				{
					player util::screen_message_delete_client();
				}
			}
		}
	}
	
	function wait_for_left_stick_input( player )  // self = trigger
	{
		player endon( "death" );
		player endon( "entering_last_stand" );
		
		const LEFT_MAGNITUDE = -0.5;
		
		n_frames_held = 0;
		
		while ( n_frames_held < ( 1 * 20 ) )
		{
			v_stick = player GetNormalizedMovement();
			n_left = v_stick[ 1 ];
			
			if ( n_left < LEFT_MAGNITUDE )
			{
				if ( n_frames_held == 0 )
				{
					m_progress_bar = player hud::createPrimaryProgressBar();
					m_progress_bar thread do_bar_update( 1 );						
				}
				
				n_frames_held++;
			}
			else 
			{
				n_frames_held = 0;
				
				if ( IsDefined( m_progress_bar ) )
				{
					m_progress_bar destroy_progress_bar();
				}
			}
			
			{wait(.05);};
		}
		
		if ( IsDefined( m_progress_bar ) )
		{
			m_progress_bar destroy_progress_bar();
		}
		
		self.m_panel clientfield::set( "sm_secure_goods_circuit_breaker_panel_fx", 2 );
		self.m_panel HidePart( "j_wire_red" );		
		
		flag::set( "wire_rip_left_done" );
	}
	
	function destroy_progress_bar()  // self = hud elem
	{
		if ( IsDefined( self ) )
		{
			self notify( "kill_bar" );
			self hud::destroyElem();				
		}
	}
	
	function wait_for_right_stick_input( player )  // self = trigger
	{
		player endon( "death" );
		player endon( "entering_last_stand" );
		
		const RIGHT_MAGNITUDE = 0.5;
		
		n_frames_held = 0;
		
		while ( n_frames_held < ( 1 * 20 ) )
		{
			v_stick = player GetNormalizedCameraMovement();
			n_right = v_stick[ 1 ];
			
			if ( n_right > RIGHT_MAGNITUDE )
			{
				if ( n_frames_held == 0 )
				{
					m_progress_bar = player hud::createPrimaryProgressBar();
					m_progress_bar thread do_bar_update( 1 );						
				}				
				
				n_frames_held++;
			}
			else 
			{
				n_frames_held = 0;
				
				if ( IsDefined( m_progress_bar ) )
				{
					m_progress_bar destroy_progress_bar();
				}				
			}
			
			{wait(.05);};
		}
		
		if ( IsDefined( m_progress_bar ) )
		{
			m_progress_bar destroy_progress_bar();
		}		
		
		player thread util::screen_message_create_client( &"SM_TYPE_SECURE_GOODS_OBJ_SECURITY_TEMP_DONE", undefined, undefined, 0, 2 );
		
		self.m_panel clientfield::set( "sm_secure_goods_circuit_breaker_panel_fx", 1 );
		self.m_panel HidePart( "j_wire_blue" );		
		
		flag::set( "wire_rip_right_done" );
		
		player EnableWeapons();
		
		wait 1;  // player should not immediately drop out of this sequence, so hold for a little extra time
	}	
	
	function circuit_breaker_wire_rip_right( player )
	{
		if ( IsDefined( player ) && player is_player_valid() )
		{
			if ( !self flag::get( "wire_rip_right_done" ) )
			{
				// prompt player to push left on left stick
				player util::screen_message_create_client( &"SM_TYPE_SECURE_GOODS_PROMPT_SECURITY_RIGHT_WIRE", undefined, undefined, -60 );
				
				// wait for input
				self wait_for_right_stick_input( player );
				
				if ( IsDefined( player ) )
				{
					player util::screen_message_delete_client();
				}
			}
		}
	}	
	
	function play_circuit_breaker_panel_start_anim( player )
	{
		player endon( "death" );
		player endon( "entering_last_stand" );
		
		wait 3;  // this is where the animation will play
		
		self flag::set( "start_anim_done" );
		
		self.m_panel_door Hide();  // temp: door is "open"
	}
	
	// self = progressbar hud
	function do_bar_update( n_duration )
	{
		self endon( "kill_bar" );

		self hud::updateBar( 0.01, 1 / n_duration );
		
		wait n_duration;
		
		self hud::destroyElem();;
	}

	function is_player_valid()  // self = player
	{
		b_is_valid = true;
		
		if ( self laststand::player_is_in_laststand() )
		{
			b_is_valid = false;
		}
		
		return b_is_valid;
	}
	
	function temp_player_lock_in_place( trigger )  // self = player
	{
		const DISTANCE_PROJECTION = 50;
		
		v_lock_position = ( trigger.origin + VectorNormalize( AnglesToForward( trigger.angles ) ) * DISTANCE_PROJECTION );
		v_lock_position_ground = BulletTrace( v_lock_position, v_lock_position - ( 0, 0, 100 ), false, undefined )[ "position" ];
		v_lock_angles = ( 0, VectorToAngles( VectorScale( AnglesToForward( trigger.angles ), -1 ) )[1], 0 );  // face the trigger (circuit breaker panel)
		
		self.circuit_breaker_lock_ent = Spawn( "script_origin", v_lock_position_ground );
		self.circuit_breaker_lock_ent.angles = v_lock_angles;
		
		self PlayerLinkTo( self.circuit_breaker_lock_ent, undefined, 0, 0, 0, 0, 0 );  // don't allow player to look around during this sequence
		
		self DisableWeapons();
	}
	
	function temp_player_lock_in_place_remove()  // self = player
	{
		if ( IsDefined( self ) && IsDefined( self.circuit_breaker_lock_ent ) )
		{
			self Unlink();
			
			self.circuit_breaker_lock_ent Delete();
			
			self EnableWeapons();
		}
	}
}

class cObjSecureGoodsMove : cSidemissionObjective
{
	var m_n_round;
	var m_n_goods;
	var m_m_dropoff;
	var m_a_goods;
	var	m_a_unobtainium_gobj;
	var	m_dropoff_gameobject;
	var m_hud_waypoint;
	var m_str_dropoff_zone;
	var m_objective_main;
	
	constructor()
	{
		m_n_round = 1;
		m_n_goods = 1;
		
		m_a_unobtainium_gobj = [];
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
	
	function level_init()
	{
		add_intro_vo( &"SM_TYPE_SECURE_GOODS_VO_MOVE_ANNOUNCE", "vox_ct_move_unob" );
		add_intro_splash( &"SM_TYPE_SECURE_GOODS_OBJ_MAIN", &"SM_TYPE_SECURE_GOODS_OBJ_MOVE" );
		add_outro_splash( &"SM_TYPE_SECURE_GOODS_OBJ_MAIN", &"SM_TYPE_SECURE_GOODS_OBJ_MOVE_DONE" );
		
		add_pause_objective( &"SM_TYPE_SECURE_GOODS_OBJ_MOVE_PAUSE" );
		
		add_outro_vo( &"SM_TYPE_SECURE_GOODS_VO_MOVE_DONE", "vox_ct_unob_ready" );
	}
	
	function main()
	{
		set_zone_mode();
		
		a_goods_structs = cSideMissionBase::get_structs_for_sm_element( "secure_goods" );
		assert( a_goods_structs.size, "cObjMove: no sm_loc structs with script_string 'secure_goods' found!" );
		
		a_goods_structs = array::randomize( a_goods_structs );

		thread show_dropoff();
		thread spawn_goods( a_goods_structs[0] );
		
		m_objective_main = sm_ui::hud_objective_register( &"SM_TYPE_SECURE_GOODS_OBJ_MOVE_STATUS" );
		
		sm_ui::hud_objective_set( m_objective_main, 0 );
		
		self crate_success_watch();
	}
	
	function set_zone_mode()
	{
		zone_mgr::set_mode( "objective_unoccupied" );
	}

	function show_dropoff()
	{
		a_dropoff_structs = cSideMissionBase::get_structs_for_sm_element( "secure_goods_dropoff" );
		assert( a_dropoff_structs.size, "cSecureGoods - no secure_goods_dropoff structs found!" );
		
		s_dropoff = array::random( a_dropoff_structs );
		v_pos = s_dropoff.origin;
		v_angles = s_dropoff.angles;
		
		// Visual models offset fom the gameobject origin
		gobj_model_offset = ( 0, 0, 0 );
		gobj_visuals[ 0 ] = util::spawn_model( "t6_wpn_supply_drop_detect", v_pos + gobj_model_offset, v_angles );

		m_str_dropoff_zone = zone_mgr::get_zone_from_position( gobj_visuals[0].origin+( 0, 0,32 ), TRUE );
		zone_mgr::set_objective_zone( m_str_dropoff_zone );
		
		level.e_dropoff = gobj_visuals[0];
		level.e_dropoff thread oed::enable_keyline( true );

		level waittill ( "raid_goods_picked_up" );
		
		// Setup a USE Radius Trigger
		e_trigger = spawn( "trigger_radius", v_pos, 0, 96, 30 );
		e_trigger TriggerIgnoreTeam();
		e_trigger SetVisibleToAll();
		e_trigger SetTeamForTrigger( "none" );
		//e_trigger UseTriggerRequireLookAt();
		e_trigger SetCursorHint( "HINT_NOICON" );

		// Create the gameobject
		gobj_team = "any";
		gobj_trigger = e_trigger;
		gobj_objective_name = undefined;
		gobj_offset = ( 0, 0, 0 );
		e_object = gameobjects::create_use_object( gobj_team, gobj_trigger, gobj_visuals, gobj_offset, gobj_objective_name );

		// Setup gameobject params
		e_object gameobjects::allow_use( "any" );
		e_object gameobjects::set_use_time( 0.0 );						// How long the progress bar takes to complete
		e_object gameobjects::set_use_text( "" );
		e_object gameobjects::set_use_hint_text( "" );
		e_object gameobjects::set_visible_team( "any" );				// How can see the gameobject

		// Add waypoint 3d locator, add 2d compass locator
		e_object gameobjects::set_2d_icon( "friendly", "t7_hud_prompt_drop_64" );
		e_object gameobjects::set_3d_icon( "friendly", "t7_hud_prompt_drop_64" );

		e_object gameobjects::set_3d_icon_color( "friendly", ( 0, 1, 0 ), 1 );
		e_object gameobjects::set_3d_icon_color( "enemy", ( 1, 1, 1 ), 1 );

		e_object.onUse = &onUse_dropoff;
		
		e_object thread dropoff_complete_watch();
		
		thread sidemission_type_base::set_jumpto( e_trigger.origin, "Ransack/Dropoff" );
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

		player thread util::screen_message_create_client( &"SM_TYPE_SECURE_GOODS_PROMPT_GOODS_CAPTURE" );

		while ( player IsTouching( self.trigger ) && !player UseButtonPressed() )
		{
			{wait(.05);};
		}

		if ( IsDefined( player ) && !player IsTouching( self.trigger ) && IsDefined( player.carrying_unobtanium ) )
		{
			// reset prompt
			player thread util::screen_message_create_client( &"SM_TYPE_SECURE_GOODS_PROMPT_GOODS_DROP" );	
			return;
		}
		
		player util::screen_message_delete_client();
		
		player goodsobj::player_carry_movement_end();
		
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
		
		a_icons_2d = Array( "t7_hud_waypoints_a", "t7_hud_waypoints_b", "t7_hud_waypoints_c", "t7_hud_waypoints_d" );
		a_icons_3d = Array( "t7_hud_waypoints_a", "t7_hud_waypoints_b", "t7_hud_waypoints_c", "t7_hud_waypoints_d" );
		a_str_clientfields = Array( "sm_ransack_inv_unobtanium_a", "sm_ransack_inv_unobtanium_b", "sm_ransack_inv_unobtanium_c" );
		
		for ( i = 0; i < m_n_goods; i++ )
		{
			o_goods = new cGoodsCrate();
			e_gameobject = goodsobj::unobtanium_gameobject( a_crate_points[i].origin, a_crate_points[i].angles, "wpn_t7_prp_unobtainium_box", a_icons_2d[ i ], a_icons_3d[ i ], a_str_clientfields[i] );
			thread [[self]]->add_gameobject( e_gameobject );
			thread [[o_goods]]->start_thinking_gameobject( e_gameobject );
			
			thread sidemission_type_base::set_jumpto( a_crate_points[i].origin, "Ransack/Crate" );
			
			if ( !isdefined( m_a_goods ) ) m_a_goods = []; else if ( !IsArray( m_a_goods ) ) m_a_goods = array( m_a_goods ); m_a_goods[m_a_goods.size]=o_goods;;
		}
	}
	
	function add_gameobject( e_gameobject )
	{
		m_a_unobtainium_gobj[ m_a_unobtainium_gobj.size ] = e_gameobject;
	}
	
	function crate_success_watch()
	{
		a_subtitles = Array( &"SM_TYPE_SECURE_GOODS_VO_MOVE_PROGRESS_1", &"SM_TYPE_SECURE_GOODS_VO_MOVE_PROGRESS_2", &"SM_TYPE_SECURE_GOODS_VO_MOVE_PROGRESS_3" );
		a_vox = Array( "vox_ct_unob_secured_1", "vox_ct_unob_secured_2", "vox_ct_unob_secured_3" );
		
		is_complete = false;
		while ( !is_complete )
		{
			level waittill ( "package_delivered" );
			
			// We've delivered a package at the dropoff point
			// Are there any remaining packages left?
			is_complete = true;
			n_count = 0;
			foreach( e_gameobject in m_a_unobtainium_gobj )
			{
				if( !( isdefined( e_gameobject.dropped_cleanup ) && e_gameobject.dropped_cleanup ) )
				{
					is_complete = false;
					n_count++;
				}
			}
			sm_ui::hud_objective_update( m_objective_main, 3 - n_count );
			
			n_line = n_count % a_vox.size;
			sm_ui::temp_vo( a_subtitles[ n_line ], a_vox[ n_line ] );			
		}
		
		wait 1;  // stagger timing for VO
		
		sm_ui::hud_objective_remove( m_objective_main );
		
		level notify( "sm_exfil_call" );
	}
	
	function dropoff_complete_watch()
	{
		level waittill( "sm_exfil_call" );
		wait( 1 );

		self gameobjects::set_2d_icon( "enemy", undefined );
		self gameobjects::set_3d_icon( "enemy", undefined );
		self gameobjects::set_2d_icon( "friendly", undefined );
		self gameobjects::set_3d_icon( "friendly", undefined );

		self gameobjects::destroy_object( true );
		self gameobjects::release_all_objective_ids();
	}
	
	function clean_up()
	{
		if ( IsDefined( m_str_dropoff_zone ) )
		{
			zone_mgr::clear_objective_zone( m_str_dropoff_zone );
		}
	}
}

class cObjSecureGoodsDefend : cSideMissionObjective
{
	var m_objective_wait;
	var m_objective_defend;
	var m_m_flight_case;
	
	constructor()
	{
		m_objective_wait = sm_ui::hud_objective_register( &"SM_TYPE_SECURE_GOODS_OBJ_DEFEND_STATUS_TIME" );
		m_objective_defend = sm_ui::hud_objective_register( &"SM_TYPE_SECURE_GOODS_OBJ_DEFEND_STATUS_HEALTH" );
		
		a_dropoff_structs = cSideMissionBase::get_structs_for_sm_element( "secure_goods_dropoff" );	
		s_dropoff = array::random( a_dropoff_structs );
		
		m_m_flight_case = util::spawn_model( "t6_wpn_supply_drop_axis", s_dropoff.origin, s_dropoff.angles );
	}
	
	destructor()
	{
		
	}
	
	function level_init()
	{
		add_intro_vo( &"SM_TYPE_SECURE_GOODS_VO_DEFEND_ANNOUNCE", "vox_ct_vtol_enroute" );
		add_intro_splash( &"SM_TYPE_SECURE_GOODS_OBJ_MAIN", &"SM_TYPE_SECURE_GOODS_OBJ_DEFEND" );
		add_outro_splash( &"SM_TYPE_SECURE_GOODS_OBJ_MAIN", &"SM_TYPE_SECURE_GOODS_OBJ_DEFEND_DONE" );
		
		add_pause_objective( &"SM_TYPE_SECURE_GOODS_OBJ_DEFEND_PAUSE" );
		
		add_outro_vo( &"SM_TYPE_SECURE_GOODS_VO_DEFEND_DONE", "vox_ct_cargo_secured" );
	}
	
	function main()
	{	
		sm_ransack::push_all_ai_into_combat();
		
		sm_ui::hud_objective_set( m_objective_wait, 60 );		
		
		sm_ui::icon_add( m_m_flight_case, "interact" );
		m_m_flight_case thread sm_ransack::worldspace_icon_3d_show( "t7_hud_waypoints_arrow", undefined, 20 );
		
		n_arrival_delay = 60;
		
		sp_vtol = GetEnt( "sm_ransack_exfil", "targetname" );
		
		if ( IsDefined( sp_vtol ) && IsDefined( sp_vtol.target ) )  // make sure exfil vehicle targets a node for use in estimate
		{
			n_vtol_arrival_estimate = sm_ransack::get_estimated_time_on_spline( sp_vtol.target );
			
			n_arrival_delay = 60 - n_vtol_arrival_estimate;
		}
		
		sm_ui::hud_objective_add_timer( m_objective_wait, 60 );
		self thread remove_objective_timer_at_zero( m_objective_wait, 60 );

		level util::waittill_any_timeout( n_arrival_delay, "sm_exfil_skip_defend" );  // blocking
		
		m_vh_exfil = vehicle::simple_spawn_single_and_drive( "sm_ransack_exfil" );
		
		m_vh_exfil vtol_loads_goods_on_arrival( m_objective_defend, m_m_flight_case );

		m_vh_exfil thread vtol_leaves_level();

		sm_ui::icon_remove( m_m_flight_case );
		m_m_flight_case sm_ransack::worldspace_icon_3d_hide();
		m_m_flight_case sm_ransack::reset_objective_color();
		
		sm_ui::hud_objective_remove( m_objective_defend );
	}
	
	function remove_objective_timer_at_zero( m_objective_wait, n_delay )
	{
		wait n_delay + 1;  // give an extra second to show zero on the hud before we remove it
		
		sm_ui::hud_objective_remove( m_objective_wait );
	}
	
	function vtol_loads_goods_on_arrival( m_objective_defend, m_flight_case )  // self = vtol
	{
		self endon( "death" );
		
		level waittill( "sm_vtol_arrived" );  // sent at spline end; ready to load goods now
		
		sm_ui::hud_objective_set( m_objective_defend, 100 );
		
		self thread health_display_think( m_objective_defend );
		
		sm_ui::temp_vo( &"SM_TYPE_SECURE_GOODS_VO_DEFEND_PROGRESS", "vox_ct_vtol_unob" );
		
		str_move_tag = "tag_origin";
		
		if ( IsDefined( self GetTagOrigin( "tag_winch" ) ) )
		{
			str_move_tag = "tag_winch";
		}
		
		v_move_pos = self GetTagOrigin( str_move_tag );
		
		m_flight_case MoveTo( v_move_pos, 30, 3, 3 );  // TODO: replace with animation
		m_flight_case NotSolid();  // don't let players ride the crate to the vtol
		
		wait 30;  // time it takes for vtol to load crates. to be replaced by animation later.
		
		level notify( "sm_secure_goods_vtol_defend_complete" );  // kill damage watcher
		
		m_flight_case LinkTo( self, str_move_tag );
	}
	
	function vtol_leaves_level()  // self = vtol
	{
		self SetCanDamage( false );  // vtol is safe at this point, don't let it die
		
		self.drivepath = true;  // drive to start position, don't warp
		
		nd_path_start = GetVehicleNode( "sm_exfil_spline_exit", "targetname" );
		
		self vehicle::get_on_and_go_path( nd_path_start );
		
		self waittill( "reached_end_node" );
		
		self Delete();
	}
	
	function health_display_think( m_objective_defend )  // self = VTOL
	{
		level endon( "sm_secure_goods_vtol_defend_complete" );
		
		sm_ui::hud_objective_update( m_objective_defend, 100 );  // always start at full health
		b_played_vo = false;
		
		while ( self.health > 0 )
		{
			n_health_percentage = Int( ( self.health / self.healthmax ) * 100 );
			
			sm_ui::hud_objective_update( m_objective_defend, n_health_percentage );
			
			if ( ( n_health_percentage < 50 ) && !b_played_vo )
			{
				sm_ui::temp_vo( &"SM_TYPE_SECURE_GOODS_VO_DEFEND_FAIL_SOFT", "vox_ct_vtol_damaged" );
				b_played_vo = true;
			}
			
			util::wait_network_frame();
		}
		
		// mission failure condition: VTOL destroyed
		sm_ui::temp_vo( &"SM_TYPE_SECURE_GOODS_VO_DEFEND_FAIL_HARD", "vox_ct_cargo_destroyed" );
		
		wait 3;
		
		cSidemissionObjective::mission_fail();
	}
}

class cObjSecureGoodsExfil : cSideMissionObjective
{
	var m_objective_main;
	
	constructor()
	{
		
	}
	
	function level_init()
	{
		add_intro_vo( &"SM_TYPE_SECURE_GOODS_VO_EXFIL_ANNOUNCE", "vox_ct_enemy_converging" );
		add_intro_splash( &"SM_TYPE_SECURE_GOODS_OBJ_MAIN", &"SM_TYPE_SECURE_GOODS_OBJ_EXFIL" );
		
		add_pause_objective( &"SM_TYPE_SECURE_GOODS_OBJ_EXFIL_PAUSE" );
		
		add_outro_vo( &"SM_TYPE_SECURE_GOODS_VO_EXFIL_DONE", "vox_ct_excellent_work" );
	}
	
	function main()
	{
		wait 5;
		
		wave_mgr::stop_wave_spawning();
		
		m_objective_main = sm_ui::hud_objective_register( &"SM_TYPE_SECURE_GOODS_OBJ_EXFIL_STATUS" );
		
		wait_for_player_to_kill_all_enemies();
		
		sm_ui::hud_objective_remove( m_objective_main );
	}
	
	function wait_for_player_to_kill_all_enemies()
	{
		b_showing_radar = false;
		
		sm_ui::hud_objective_set( m_objective_main, GetAIArray( "axis" ).size );
		
		do
		{
			util::wait_network_frame();
			
			a_enemies = GetAIArray( "axis" );
			
			sm_ui::hud_objective_update( m_objective_main, a_enemies.size );
			
			if ( !b_showing_radar && ( a_enemies.size < 10 ) )
			{
				self thread show_enemies_on_mini_map();
				
				b_showing_radar = true;
			}
		}
		while ( a_enemies.size > 0 );
		
		sm_ui::hud_objective_update( m_objective_main, 0 );  // make sure we clear this objective at zero
	}
	
	function show_enemies_on_mini_map()
	{
		sm_ui::temp_vo( &"SM_TYPE_SECURE_GOODS_VO_EXFIL_ENCOURAGE", "vox_ct_enemy_reduced" );
		
		wait 3;  // wait as if VO was actually played
		
		SetTeamSatellite( "allies", 1 );  // enemies displayed on mini-map
	}
}

function worldspace_prompt_create( ent, n_range_top_line, str_top_line, str_bottom_line, n_range_bottom_line, str_icon_name, n_icon_x_offset )
{
	o_3d_message = new cFakeWorldspaceMessage();
	
	const TEXT_SCALE_TOP = 2.0;
	const TEXT_SCALE_BOTTOM = 1.0;
	
	[[o_3d_message]]->init( ent.origin, n_range_top_line, str_icon_name, n_icon_x_offset );
	[[o_3d_message]]->set_parent( ent );
	
	if ( IsDefined( str_top_line ) )
	{
		[[o_3d_message]]->add_line( str_top_line, TEXT_SCALE_TOP, true );
	}	
	
	if ( IsDefined( str_bottom_line ) )
	{
		[[o_3d_message]]->add_line( str_bottom_line, TEXT_SCALE_BOTTOM, true );
	}
	
	if ( IsDefined( n_range_bottom_line ) )
	{
		o_3d_message.m_n_range_inner = n_range_bottom_line;	
	}
	
	return o_3d_message;
}

function worldspace_icon_3d_hide()
{
	self notify( "kill_3d_icon_display" );
	
	if ( IsDefined( self.a_player_hud_elements ) )
	{
		foreach ( player in level.players )
		{
			if ( IsDefined( self.a_player_hud_elements[ player.entnum ] ) )
			{
				self.a_player_hud_elements[ player.entnum ] Destroy();
			}
		}
	}
}

// TODO: put this in _sm_ui_worldspace.gsc -TJanssen 3/27/2014
function worldspace_icon_3d_show( str_icon, n_min_draw_distance = 72, n_z_offset = 40 ) // self = ent the 3d icon should be displayed on
{
	self endon( "kill_3d_icon_display" );
	
	self.a_player_hud_elements = [];

	const DRAW_DISTANCE = 6000;
	
	while ( true )
	{
		foreach ( player in level.players )
		{
			if ( DistanceSquared( player.origin, self.origin ) < ( DRAW_DISTANCE * DRAW_DISTANCE ) &&
			DistanceSquared( player.origin, self.origin ) > ( n_min_draw_distance * n_min_draw_distance ) &&
			player util::is_player_looking_at( self.origin, 0.65, false ) /* &&
			SightTracePassed( player.origin + ( 0, 0, 64 ), self.origin + ( 0, 0, 64 ), false, undefined ) */ )
			{
				if ( !IsDefined( self.a_player_hud_elements[ player.entnum ] ) )
				{
					hud_icon = NewClientHudElem( player );
					hud_icon.x = self.origin[ 0 ];
					hud_icon.y = self.origin[ 1 ];
					hud_icon.z = self.origin[ 2 ] + n_z_offset;
					hud_icon.alpha = 0.61;
					hud_icon.archived = true;
					hud_icon SetShader( str_icon, 7, 7 );
					hud_icon SetWaypoint( true ) ;

					self.a_player_hud_elements[ player.entnum ] = hud_icon;
				}
				else 
				{
					hud_icon = self.a_player_hud_elements[ player.entnum ];
					
					hud_icon.x = self.origin[ 0 ];
					hud_icon.y = self.origin[ 1 ];
					hud_icon.z = self.origin[ 2 ] + n_z_offset;					
				}
			}
			else
			{
				if ( IsDefined( self.a_player_hud_elements[ player.entnum ] ) )
				{
					self.a_player_hud_elements[ player.entnum ] Destroy();
				}
			}
		}

		wait randomfloatrange(0.1-0.1/3,0.1+0.1/3);
	}
}

function worldspace_prompt_hide()
{
	[[self]]->can_display_text( false );
}

function worldspace_prompt_show()
{
	[[self]]->can_display_text( true );
}

function worldspace_prompt_delete()  // self = cFakeWorldSpaceMessage object
{
	[[self]]->uninitialize();
}

// this is a rough estimate only and will never be 100% accurate
function get_estimated_time_on_spline( str_start_node )
{
	nd_current = GetVehicleNode( str_start_node, "targetname" );
	
	n_time_estimate = 0;
	n_speed = nd_current.speed;
	
	while ( IsDefined( nd_current.target ) )
	{
		nd_next = GetVehicleNode( nd_current.target, "targetname" );
		
		if ( IsDefined( nd_current.speed ) )
		{
			n_speed = nd_current.speed;
		}
		
		n_distance_to_next = Distance( nd_current.origin, nd_next.origin );
		n_time_to_next = ( n_distance_to_next / n_speed );
		
		n_time_estimate += n_time_to_next;
		
		nd_current = nd_next;
	}
	
	return n_time_estimate;
}

function reset_objective_color()  // self = ent with objective icon on it
{
	// HACK: _gameobjects and _sm_ui can reuse the same objective icon, which causes the incorrect color to show up after objective is released. Manually set color here:
	// TODO: notify code that when an objective is released, it should reset the color to default automatically -TJanssen 3/27/2014
	if ( IsDefined( self.sm_minimap_icon ) )
	{
		objective_SetColor( self.sm_minimap_icon, 1.0, 1.0, 1.0 );  // white
	}	
}

//*****************************************************************************
//*****************************************************************************
// unobtanium gameobject
//*****************************************************************************
//*****************************************************************************

#namespace goodsobj;

function unobtanium_gameobject( v_pos, v_angles, str_model_name, str_icon_2d, str_icon_3d, str_carrying_clientfield )
{
	v_spawn_pos = ( v_pos[0], v_pos[1], v_pos[2] + 15 );

	// Setup a USE Trigger
	e_trigger = spawn( "trigger_radius_use", v_spawn_pos, 0, 96, 30 );
	e_trigger TriggerIgnoreTeam();
	e_trigger SetVisibleToAll();
	e_trigger SetTeamForTrigger( "none" );
	e_trigger UseTriggerRequireLookAt();
	e_trigger SetHintString( &"SM_TYPE_SECURE_GOODS_PROMPT_GOODS_CARRY" );
	e_trigger SetCursorHint( "HINT_NOICON" );

	// Set Model
	visuals[ 0 ] = util::spawn_model( str_model_name, v_spawn_pos, v_angles );
	visuals[ 0 ] NotSolid();							// Turn off collision
	visuals[ 0 ] thread oed::enable_keyline( true );

	// Set gameobject
	e_object = gameobjects::create_carry_object( "neutral", e_trigger, visuals, (0,0,0) );
	e_object gameobjects::allow_carry( "any" );

	e_object gameobjects::set_2d_icon( "enemy", str_icon_2d );
	e_object gameobjects::set_3d_icon( "enemy", str_icon_3d );
	
	e_object gameobjects::set_2d_icon( "friendly", str_icon_2d );
	e_object gameobjects::set_3d_icon( "friendly", str_icon_3d ); 

	e_object gameobjects::set_visible_team( "any" );

	e_object gameobjects::set_3d_icon_color( "friendly", ( 0, 1, 0 ), 1 );
	e_object gameobjects::set_3d_icon_color( "enemy", ( 1, 1, 1 ), 1 );

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
	self.visuals[0] thread oed::disable_keyline();
	
	player.carrying_unobtanium = self;
	
	self.visuals[0] hide();

	// Wait for the player to press USE to drop
	self thread wait_for_user_to_drop( player );

	// Notify the goods have been picked up
	level notify ( "raid_goods_picked_up" );
	
	sm_ui::inventory_pickup( self.str_carrying_clientfield, player );

	// Prompt
	player util::screen_message_create_client( &"SM_TYPE_SECURE_GOODS_PROMPT_GOODS_DROP" );

	// Carry object in 3D
	player thread goodsobj::attach_pickup_to_player( self, "wpn_t7_prp_unobtainium_box" );
}

// self = gameobject
function wait_for_user_to_drop( player )
{
	player endon( "disconnect" );
	//player endon("entering_last_stand");
	self endon( "death" );
	self endon( "dropped_cleanup" );

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
			self gameobjects::allow_carry( "any" );
			break;
		}

		// If the carry is forced to break (can happen with collision problems), then kill thread
		if( !IsDefined(player.carryObject) )
		{
			self gameobjects::allow_carry( "any" );
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
	
	carry_obj = spawn( "script_model", pos );
	carry_obj.angles = self.angles + holding_angle;
	carry_obj setModel( str_model );
	carry_obj NotSolid();

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
	carry_obj Delete();
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
	}
	
	sm_ui::inventory_drop( self.str_carrying_clientfield, player );

	self.visuals[ 0 ] thread oed::enable_keyline( true );
	self gameobjects::allow_carry( "any" );
}

// self = gameobject
function target_dropoff()
{
	self notify( "dropped_cleanup" );
	self.dropped_cleanup = 1;

	self gameobjects::set_dropped();
	
	self gameobjects::destroy_object( 1, 1 );
	self gameobjects::release_all_objective_ids();
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

