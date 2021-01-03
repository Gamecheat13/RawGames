#using scripts\codescripts\struct;

#using scripts\shared\array_shared;
#using scripts\shared\clientfield_shared;
#using scripts\shared\flag_shared;
#using scripts\shared\gameobjects_shared;
#using scripts\shared\spawner_shared;
#using scripts\shared\system_shared;
#using scripts\shared\util_shared;

#using scripts\cp\_oed;

#using scripts\cp\gametypes\_globallogic;

#using scripts\cp\sm\_sm_round_base;
#using scripts\cp\sm\_sm_round_objective;
#using scripts\cp\sm\_sm_round_beacon;
#using scripts\cp\sm\_sm_ui;

    	   	                                                                                                                         	                                                                                                                                                                                                                                                                                                                                                                    	        	     	             	    	   	                           	                               	                                	                                                              	                                                                                                              	                            	                                     	                                       	                                                               	   	                  	       	                                                    	                   	                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                      	                                                                                        	           	                        	                                            	                                             	                                                   	                                                             	                                                         	                                                                    	                                                                                                                                                                                                    	                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                    	                                                              	                                                          	                                   	                                   	                                                    	                                       
                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                            	                                                                                                                                                                                                                                                                                                                                                                                       

                                                                   	       	     	          	      	                                                                                            	                                                           	                                  





	


	





#precache( "material", "t7_hud_power_coupling" );
#precache( "material", "t7_hud_power_coupling_small" );
#precache( "material", "t7_hud_waypoints_arrow" );
	
#precache( "string", "SM_OBJ_SABOTAGE" );
#precache( "string", "SM_OBJ_SABOTAGE_UPDATE" );
#precache( "string", "t7_hud_power_coupling" );	
#precache( "string", "SM_PROMPT_SABOTAGE_GENERATOR_USING" );

#precache( "triggerstring", "SM_PROMPT_SABOTAGE_GENERATOR_USE" );
	
#namespace sm_round_objective_sabotage;

function autoexec __init__sytem__() {     system::register("sm_round_objective_sabotage",&__init__,undefined,undefined);    }
	
function __init__()
{
	clientfield::register( "scriptmover", "sm_sabotage_fx", 1, 2, "int" );
}

function main()
{
	o_objective = new cSMObjectiveSabotage();
	
	return o_objective;	
}

class cSMObjectiveSabotage : cSideMissionRoundObjective
{
	var m_controller;
	var m_a_generator_gameobjects;
	var m_n_sabotaged_count;
	
	constructor()
	{
		// set objective screen text
		m_str_objective_text = &"SM_OBJ_SABOTAGE";
		m_str_icon = &"t7_hud_power_coupling";
		
		// pick a controller struct
		a_controller_structs = get_sm_struct( "sabotage_controller" );
		
		s_controller = array::random( a_controller_structs );
		Assert( IsDefined( s_controller.target ), "sabotage generator struct at " + s_controller.origin + " is missing generator target KVP! This is used to spawn generator models associated with this controller." );
		
		a_generators = struct::get_array( s_controller.target, "targetname" );
		Assert( ( a_generators.size >= 4 ), "sabotage controller at " + s_controller.origin + " found " + a_generators.size + " generator structs. At least " + 4 + " are required for the sabotage objective." );
		
		// spawn model for controller
		m_controller = util::spawn_model( "p7_int_bio_cache", s_controller.origin, s_controller.angles );
		
		// spawn models for generators
		a_generators = array::randomize( a_generators );
		
		m_a_generator_gameobjects = [];
		
		for ( i = 0; i < 4; i++ )
		{
			m_a_generator_gameobjects[ m_a_generator_gameobjects.size ] = setup_generator( a_generators[ i ] );
		}
		
		// set up end conditions
		m_n_sabotaged_count = 0;	
	}
	
	destructor()
	{

	}
	
	// this is run by _sm_round_objective's main objective func
	function main_objective()
	{
		sm_round_objective::defend_object_add( m_controller );
		
		hud_generator_count_show();
		set_objective_timer_with_images( 300, undefined, &"", &"", &"" );  // just show timer. TODO: replace with UI widget
		
		// wait for all generators to be sabotaged
		self waittill( "all_generators_sabotaged" );
		
		sm_round_objective::defend_object_remove( m_controller );
		
		hud_generator_count_remove();
		
		// blow up controller
		self thread destroy_controller();
	}
	
	function destroy_controller()
	{
		iprintlnbold( "generator explodes in 5 seconds" );
		
		wait 5;
		
		iprintlnbold( "generator explodes" );
		m_controller clientfield::set( "sm_sabotage_fx", 2 );
		
		util::wait_network_frame();
		
		m_controller Ghost();
	}
	
	function hud_generator_count_show()
	{
		// TODO: replace with UI widget
		sm_ui::enemy_message_set( &"SM_OBJ_SABOTAGE_UPDATE", 4 );
	}
	
	function hud_generator_count_update()
	{
		// TODO: replace with UI widget
		sm_ui::enemy_message_update( 4 - m_n_sabotaged_count );
	}
	
	function hud_generator_count_remove()
	{
		// TODO: replace with UI widget
		sm_ui::enemy_message_remove();
	}
	
	function setup_generator( s_generator )
	{
		const TRIGGER_SPAWN_FLAGS = 0;
		const TRIGGER_RADIUS = 15;
		const TRIGGER_HEIGHT = 10;
		
		if(!isdefined(s_generator.angles))s_generator.angles=( 0, 0, 0 );
		
		v_offset = ( 0, 0, 0 );
		
		trigger = Spawn( "trigger_radius_use", s_generator.origin + v_offset, TRIGGER_SPAWN_FLAGS, TRIGGER_RADIUS, TRIGGER_HEIGHT );	
		trigger.angles = s_generator.angles;
		
		trigger SetCursorHint( "HINT_INTERACTIVE_PROMPT" );
		trigger SetHintString( &"SM_PROMPT_SABOTAGE_GENERATOR_USE" );
		trigger TriggerIgnoreTeam();
		trigger UseTriggerRequireLookAt();
		
		// You can add multiple models into the gameobjects model array, each with their own relative offset
		a_gameobject_visuals[ 0 ] = util::spawn_model( "machinery_generator", s_generator.origin, s_generator.angles );
		
		a_gameobject_visuals[ 0 ] linkto( trigger );  // this is required for interactive prompts
		
		a_gameobject_visuals[ 0 ] DisconnectPaths();
		
		// Create the gameobject
		str_gameobject_team = "allies";
		t_gameobject = trigger;
		str_objective_name = undefined;
		v_gameobject_offset = ( 0, 0, 24 );  // offset icon to top of model
		s_gameobject = gameobjects::create_use_object( str_gameobject_team, t_gameobject, a_gameobject_visuals, v_gameobject_offset, str_objective_name );
	
		// Setup gameobject params
		s_gameobject gameobjects::allow_use( "friendly" );
		s_gameobject gameobjects::set_use_time( 8 );	// How long the progress bar takes to complete
		s_gameobject gameobjects::set_use_text( &"SM_PROMPT_SABOTAGE_GENERATOR_USING" );
		s_gameobject gameobjects::set_use_hint_text( &"SM_PROMPT_SABOTAGE_GENERATOR_USE" );
		s_gameobject gameobjects::set_visible_team( "friendly" );				// How can see the gameobject
	
		// Setup gameobject callbacks
		s_gameobject.onUse = &on_use;
		s_gameobject.onBeginUse = &on_begin_use;
		s_gameobject.onUseUpdate = &on_use_update;
		s_gameobject.onCantUse = &on_cant_use;
		s_gameobject.onEndUse = &on_end_use;		
		
		// set up icons
		s_gameobject gameobjects::set_2d_icon( "enemy", "t7_hud_power_coupling_small" );
		s_gameobject gameobjects::set_3d_icon( "enemy", "t7_hud_waypoints_arrow" );
		s_gameobject gameobjects::set_2d_icon( "friendly", "t7_hud_power_coupling_small" );
		s_gameobject gameobjects::set_3d_icon( "friendly", "t7_hud_waypoints_arrow" );	
		
		s_gameobject.activated = false;  // used by this round objective only
		
		a_gameobject_visuals[ 0 ].o_gameobject = s_gameobject;  // store gameobject on model since model is easily accessible globally
		
		// objective round critical stuff
		self thread wait_for_generator_sabotaged( s_gameobject );
		
		sm_round_objective::defend_object_add( a_gameobject_visuals[ 0 ] );
		
		// TODO: remove this when interact prompts are submitted
		a_gameobject_visuals[ 0 ] sm_ui::interact_prompt_set( 7 );
		
		return s_gameobject;		
	}
	
	function wait_for_generator_sabotaged( s_gameobject )
	{
		self endon( "death" );
		
		s_gameobject waittill( "generator_sabotaged" );  // sent from onUse notify from gameobject
		
		sm_round_objective::defend_object_remove( s_gameobject.visuals[ 0 ] );
		
		m_n_sabotaged_count++;
		
		hud_generator_count_update();
		
		if ( m_n_sabotaged_count == 4 )
		{
			self notify( "all_generators_sabotaged" );
		}
	}

	// Called when gameobject has been "used"
	function on_use( player )  // self = gameobject
	{
		self.activated = true;
		
		self gameobjects::set_visible_team( "none" );
		
		self gameobjects::allow_use( "none" );
		
		self notify( "generator_sabotaged" );
		
		self.visuals[ 0 ] sm_ui::interact_prompt_remove();
		self.visuals[ 0 ] clientfield::set( "sm_sabotage_fx", 1 );
	}
	
	// Called when the Use Functionality Starts
	function on_begin_use( player )  // self = gameobject
	{

	}
	
	// When Using gameobject
	function on_use_update( team, progress, change )  // self = gameobject
	{
		
	}
	
	// Called when the Use Functionality Ends
	function on_end_use( team, player, success )  // self = gameobject
	{
		self notify( "damage_interrupt_end" );
		
		self.interrupted = undefined;
		
		if ( !self.activated )
		{
			self gameobjects::allow_use( "friendly" );
		}
	}
	
	// Called when not able to use
	function on_cant_use( player )  // self = gameobject
	{
		
	}	
	
	function clean_up( b_send_notify = false )
	{		
		if ( IsDefined( m_a_generator_gameobjects ) )
		{
			foreach ( o_gameobject in m_a_generator_gameobjects )
			{
				if ( b_send_notify )
				{
					o_gameobject notify( "generator_sabotaged" );
					
					util::wait_network_frame();  // let notify behavior finish
				}
				
				o_gameobject gameobjects::disable_object( false );
				o_gameobject gameobjects::release_all_objective_ids();
			}
			
			m_a_generator_gameobjects = undefined;
		}
		
		self notify( "all_generators_sabotaged" );
	}
	
	function dev_clean_up_round()
	{
		clean_up( true );
	}	
}
