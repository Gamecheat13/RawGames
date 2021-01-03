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

    	   	                                                                                                                         	                                                                                                                                                                                                                                                                                                                                                                    	        	     	             	    	   	                           	                               	                                	                                                              	                                                                                                              	                            	                                     	                                       	                                                               	   	                  	       	                                                    	                   	                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                      	                                                                                        	           	                        	                                            	                                             	                                                   	                                                             	                                                         	                                                                    	                                                                                                                                                                                                    	                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                    	                                                              	                                                          	                                   	                                   	                                                    	                                       
                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                            	                                                                                                                                                                                                                                                                                                                                                                                       

                                                                   	       	     	          	      	                                                                                            	                                                           	                                  
	









#precache( "triggerstring", "SM_PROMPT_GOODS_CARRY" );
#precache( "material", "t7_hud_waypoints_arrow" );
#precache( "material", "t7_hud_waypoints_defend" );
#precache( "material", "t7_hud_award_bonus" );
#precache( "string", "SM_OBJ_UPLINK" );
#precache( "string", "SM_OBJ_UPLINK_PROGRESS" );
#precache( "objective", "sm_uplink" );

#precache( "string", "t7_hud_award_bonus" );
#precache( "string", "SM_VO_TEMP_UPLINK_INTRO_1" );
#precache( "string", "SM_VO_TEMP_UPLINK_INTRO_2" );
#precache( "string", "SM_VO_TEMP_UPLINK_COMPLETE" );
#precache( "string", "SM_VO_TEMP_UPLINK_RECLAIMED" );

#namespace sm_round_objective_uplink;





function autoexec __init__sytem__() {     system::register("sm_round_objective_uplink",&__init__,undefined,undefined);    }

function __init__()
{
	// Remove dishes until we're down to the desired number.
	//
	a_models = GetEntArray( "uplink_dish", "targetname" );
	a_models = array::randomize( a_models );
	while ( a_models.size > 4 )
	{
		n_index = a_models.size-1;
		a_models[n_index] Delete();
		ArrayRemoveIndex( a_models, n_index );
	}
}
	
function main()
{
	o_objective = new cObjUplink();
	
	return o_objective;
}

class cObjUplink : cSideMissionRoundObjective
{
	var m_a_satellites;
	var m_n_data_remaining;
	
	constructor()
	{
		m_str_objective_text = &"SM_OBJ_UPLINK";
		m_str_icon = &"t7_hud_award_bonus";
//		m_str_vox_intro = "vox_stock_unobtanium";
		m_n_data_remaining = 2048;
		m_a_satellites = [];
	}
	
	destructor()
	{
		clean_up();
	}
	
	function main_objective()
	{
		sm_ui::dock_text_show( &"SM_OBJ_UPLINK_PROGRESS" );
		a_models = GetEntArray( "uplink_dish", "targetname" );
		
		foreach( model in a_models )
		{
			
			fwd = AnglesToForward( model.angles );
			v_interact = model.origin + (fwd * 50.0) + (0,0,20.0);
			
			trigger = Spawn( "trigger_radius_use", v_interact, 0, 100, 100 );
			trigger TriggerIgnoreTeam();
			trigger SetVisibleToAll();
			trigger SetTeamForTrigger( "none" );
			trigger SetCursorHint( "HINT_INTERACTIVE_PROMPT" );
			trigger SetHintLowPriority( true );
			trigger SetHintString( &"SM_PROMPT_BEACON_USE" );
			trigger SetIgnoreEntForTrigger( model );
			
			visuals[0] = model;
			visuals[1] = util::spawn_model( "tag_origin", v_interact, model.angles );
			visuals[1] linkto( trigger );
			
			satellite = gameobjects::create_use_object( "allies", trigger, visuals, (0,0,60), &"sm_uplink" );
			satellite.curOrigin = model.origin;
			
			satellite gameobjects::set_use_time( 3 );
			satellite gameobjects::allow_use( "friendly" );
			satellite gameobjects::set_visible_team( "friendly" );
			satellite satellite_set_uploading( false );
			
			satellite gameobjects::set_objective_entity( visuals[ 1 ] );
			
			satellite.b_uploading = false;
			satellite.onUse = &on_satellite_used;
			
			sm_round_objective::defend_object_add( visuals[ 0 ] );
			
			if ( !isdefined( m_a_satellites ) ) m_a_satellites = []; else if ( !IsArray( m_a_satellites ) ) m_a_satellites = array( m_a_satellites ); m_a_satellites[m_a_satellites.size]=satellite;;
		}		
		set_objective_timer_with_images( 300, undefined, &"t7_hud_prompt_beacon_64", &"t7_hud_prompt_beacon_64", &"t7_hud_prompt_beacon_64", &"t7_hud_unobtanium" );
		
		sm_ui::temp_vo( &"SM_VO_TEMP_UPLINK_INTRO_1" );
		sm_ui::temp_vo( &"SM_VO_TEMP_UPLINK_INTRO_2" );
		
		satellite_upload();
		
		sm_ui::temp_vo( &"SM_VO_TEMP_UPLINK_COMPLETE" );
		
		sm_ui::dock_text_remove();
		satellite_destroy_gameobjects();
	}
	
	function satellite_upload()
	{
		self endon( "sm_objective_complete" );
		
		sm_ui::set_lui_global( "progress", m_n_data_remaining, "uplink" );
		n_time_between_uploads = 1.0 / 3;
		while ( m_n_data_remaining > 0 )
		{
			n_uploading = 0;
			foreach( satellite in m_a_satellites )
			{
				if ( satellite.b_uploading )
				{
					n_uploading++;
				}
			}
			
			if ( m_n_data_remaining < 0 )
			{
				m_n_data_remaining = 0;
			}
			
			if ( n_uploading > 0 )
			{
				m_n_data_remaining --;
				sm_ui::set_lui_global( "progress", m_n_data_remaining, "uplink" );
				wait n_time_between_uploads / Float(n_uploading);
			}
			else
			{
				wait n_time_between_uploads;
			}
		}
	}
	
	function satellite_destroy_gameobjects()
	{
		level notify( "uplink_complete" );
		
		foreach( satellite in m_a_satellites )
		{
			sm_round_objective::defend_object_remove( satellite.visuals[ 0 ] );
			satellite.visuals[1] sm_ui::interact_prompt_remove();
			satellite notify( "objective_complete" );
		}
		
		// Interact Prompt UI requires several network frames between removing the prompt and deleting the parent entity.
		//
		util::wait_network_frame();
		util::wait_network_frame();
		util::wait_network_frame();
		
		foreach( satellite in m_a_satellites )
		{
			// Only destroy the tag_origin model.  Don't destroy the satellite model itself.
			satellite.visuals[0] = satellite.visuals[1];
			satellite.visuals[1] = undefined;
			satellite gameobjects::release_all_objective_ids();
			satellite gameobjects::destroy_object( true, true );
		}
		
		m_a_satellites = [];
	}
	
	function satellite_set_uploading( b_uploading )
	{
		if ( b_uploading )
		{
			v_color = (0.0, 0.8, 0.3 );
			self gameobjects::allow_use( "none" );
			self gameobjects::set_3d_icon( "friendly", "t7_hud_waypoints_defend" );
			self gameobjects::set_3d_icon_color( "friendly", v_color );
			self gameobjects::set_2d_icon( "friendly", "t7_hud_minimap_beacon_key" );
			self gameobjects::set_objective_color( "friendly", v_color );
			self.visuals[0] thread oed::enable_keyline( false, "uplink_complete" );
			self.visuals[1] sm_ui::interact_prompt_remove();
		}
		else
		{
			v_color = (0.8, 0.0, 0.0 );
			self gameobjects::allow_use( "friendly" );
			self gameobjects::set_3d_icon( "friendly", "t7_hud_waypoints_arrow" );
			self gameobjects::set_3d_icon_color( "friendly", v_color );
			self gameobjects::set_2d_icon( "friendly", "t7_hud_minimap_beacon_key" );
			self gameobjects::set_objective_color( "friendly", v_color );
			self.visuals[0] thread oed::enable_keyline( true, "uplink_complete" );
			self.visuals[1] sm_ui::interact_prompt_set( 6, false );
		}
		self.b_uploading = b_uploading;
	}
	
	function on_satellite_used( player )
	{
		self endon( "objective_complete" );
		
		self satellite_set_uploading( true );
		
		n_time_away = 0.0;
		n_max_dist_sq = 600.0 * 600.0;
		n_revert_time = RandomFloatRange( 30.0, 60.0 );
		while ( n_time_away < n_revert_time )
		{
			wait 1.0;
			
			n_time_away += 1.0;
			
			foreach( player in level.players )
			{
				n_dist_sq = DistanceSquared( self.visuals[0].origin, player.origin );
				if ( n_dist_sq < n_max_dist_sq )
				{
					n_time_away = 0.0;
				}
			}
		}
		
		sm_ui::temp_vo( &"SM_VO_TEMP_UPLINK_RECLAIMED" );
		
		self satellite_set_uploading( false );
	}
	
	function set_zone_mode()
	{
		zone_mgr::set_mode( "objective_unoccupied" );
	}
	
	function clean_up()
	{
		zone_mgr::clear_all_objective_zones();
	}
	
	function dev_clean_up_round()
	{
		m_n_data_remaining = 0;
	}
}

