#using scripts\codescripts\struct;

#using scripts\shared\array_shared;
#using scripts\shared\flag_shared;
#using scripts\shared\gameobjects_shared;
#using scripts\shared\hud_util_shared;
#using scripts\shared\system_shared;
#using scripts\shared\util_shared;

#using scripts\cp\_objectives;
#using scripts\cp\sidemissions\_sm_ui;

    	   	                                                                                                                         	                                                                                                                                                                                                                                                                                                                                                                    	        	     	             	    	   	                           	                               	                                	                                                              	                                                                                                              	                            	                                     	                                       	                                                               	   	                  	       	                                                    	                   	                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                      	                                                                                        	           	                        	                                            	                                             	                                                   	                                                             	                                                         	                                                                    	                                                                                                                                                                                                    	                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                    	                                                              	                                                          	                                   	                                   	                                                    	                                       


	
#namespace sm_manager;

class cSidemissionObjective {
	
	var m_a_intro_vo;
	var m_a_outro_vo;
	
	var m_str_intro_line1;
	var m_str_objective_name;
	
	var m_str_outro_line1;
	var m_str_outro_line2;
	
	var m_obj_id;
	
	function _init()
	{
		m_a_intro_vo = [];
		m_a_outro_vo = [];
		
		m_str_intro_line1 = &"";//"Main Objective";
		m_str_objective_name = &"";//"Sub-Objective Started";
		
		m_str_outro_line1 = &"";//"Objective Complete";
		m_str_outro_line2 = &"";//"Completed Sub-Objective";
		
		m_obj_id = undefined;
	}
	
	function _intro_vo()
	{
		foreach ( s_vo in m_a_intro_vo )
		{
			sm_ui::temp_vo( s_vo.str_subtitle, s_vo.str_audio );
		}
	}
	
	function _outro_vo()
	{		
		foreach ( s_vo in m_a_outro_vo )
		{
			sm_ui::temp_vo( s_vo.str_subtitle, s_vo.str_audio );
		}
	}
	
	function _intro_splash()
	{
		const n_show_time = 3.0;
		sm_ui::splash_text( m_str_intro_line1, m_str_objective_name, n_show_time );		
		if ( isdefined(m_obj_id) )
		{
			Objective_State( m_obj_id, "active" );
		}
		
		foreach ( player in level.players )
		{
			player PlaySoundToPlayer( "evt_event_newintel", player );
		}
		
		wait n_show_time;
	}
	
	function _outro_splash()
	{
		const n_show_time = 3.0;
		sm_ui::splash_text( m_str_outro_line1, m_str_outro_line2, n_show_time );
		if ( isdefined( m_obj_id ) )
		{
			Objective_State( m_obj_id, "done" );
		}
		
		foreach ( player in level.players )
		{
			player PlaySoundToPlayer( "evt_event_round_end", player );
		}
		
		wait n_show_time;
	}
	
	//******************************************************************//
	//                                                                  //
	//                       UTILITY FUNCTIONS                          //
	//                                                                  //
	//******************************************************************//
	
	function add_intro_vo( str_subtitle, str_audio )
	{
		s_vo = SpawnStruct();
		s_vo.str_subtitle = str_subtitle;
		s_vo.str_audio = str_audio;
		m_a_intro_vo[ m_a_intro_vo.size ] = s_vo;
	}
	
	function add_outro_vo( str_subtitle, str_audio )
	{
		s_vo = SpawnStruct();
		s_vo.str_subtitle = str_subtitle;
		s_vo.str_audio = str_audio;
		m_a_outro_vo[ m_a_outro_vo.size ] = s_vo;
	}
	
	function add_intro_splash( str_line1, objective_name )
	{
		m_str_intro_line1 = str_line1;
		m_str_objective_name = objective_name;
	}
	
	function add_pause_objective( str_objective_text )
	{
		assert(!isdefined(m_obj_id));
		m_obj_id = gameobjects::get_next_obj_id();
		objective_add( m_obj_id, "invisible", undefined, str_objective_text );
	}
	
	function add_outro_splash( str_line1, str_line2 )
	{
		m_str_outro_line1 = str_line1;
		m_str_outro_line2 = str_line2;
	}
	
	// Fails the mission with a message displayed the player explaining why.
	//
	function mission_fail( str_reason )
	{
		level notify( "sidemission_objective_complete", false, str_reason );
	}
	
	//******************************************************************//
	//                                                                  //
	//                   OVERRIDE THESE FUNCTIONS                       //
	//                                                                  //
	//******************************************************************//
	
	// Runs immediately when the sub-objective is registered.
	//
	function level_init()
	{
	}
	
	// Main processing thread considered completed when it returns.
	//
	function main()
	{
	}
}

class cSidemissionManager {
	var m_a_objectives;
	
	function init()
	{
		m_a_objectives = [];
		
		self thread main();
	}
	
	function add_objective( o_objective )
	{
		m_a_objectives[m_a_objectives.size] = o_objective;
	}
	
	function main()
	{
		self flag::init( "all_objectives_complete", false );
		self flag::init( "objectives_running", false );
		
		self flag::wait_till( "objectives_running" );
		
		// Run each objective sequentially.
		foreach( o_objective in m_a_objectives )
		{
			[[o_objective]]->_intro_vo();
			thread [[o_objective]]->_intro_splash();		// don't block.
			
			[[o_objective]]->main();
			
			wait 0.25;
			
			[[o_objective]]->_outro_vo();
			[[o_objective]]->_outro_splash();	// blocking call
			
			// Wait before showing the next one.
			wait 2.0;
		}
		
		// All sub-objectives completed!
		self flag::set( "all_objectives_complete" );
	}
}

function autoexec __init__sytem__() {     system::register("sm_manager",&__init__,undefined,undefined);    }

function __init__()
{
	level.sm_manager = new cSidemissionManager();
	[[level.sm_manager]]->init();
	
	level flag::init( "raid_game_over", false );
}

//******************************************************************//
//                                                                  //
//                   EXTERNAL ACCESS FUNCTIONS                      //
//                                                                  //
//******************************************************************//

function start()
{
	[[level.sm_manager]]->start();
}

function add_objective( o_objective )
{
	[[o_objective]]->_init();
	[[o_objective]]->level_init();
	[[level.sm_manager]]->add_objective( o_objective );
}

function waittill_complete()
{
	level.sm_manager flag::wait_till( "all_objectives_complete" );
}

function start_objectives()
{
	level.sm_manager flag::set( "objectives_running" );
}