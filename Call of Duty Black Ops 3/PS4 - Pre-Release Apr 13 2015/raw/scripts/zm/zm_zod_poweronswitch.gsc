/* zm_zod_poweronswitch.gsc
 *
 * Purpose : 	Powered stairs.
 *		
 * Author : 	G Henry Schmitt
 * 
 * 
 */
 
#using scripts\codescripts\struct;

#using scripts\shared\array_shared;
#using scripts\shared\callbacks_shared;
#using scripts\shared\clientfield_shared;
#using scripts\shared\exploder_shared;
#using scripts\shared\flag_shared;
#using scripts\shared\system_shared;
#using scripts\shared\util_shared;

    	   	                                                                                                                         	                                                                                                                                                                                                                                                                                                                                                                    	        	     	             	    	   	                           	                               	                                	                                                              	                                                                                                              	                            	                                     	                                       	                                                               	   	                  	       	                                                    	                   	                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                       	                                                                                        	           	                        	                                            	                                             	                                                   	                                                             	                                                         	                                                                    	                                                                                                                                                                                                    	                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                     	                                                              	                                                          	                                   	                                   	                                                    	                                       
                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                            	                                                                                                                                                                                                                                                                                                                                                                                       

                                                                                                                               
                                                                                                                                                                                                                                                                                                                                                                                                                 	                                                                                                                                                                          	                                                                                         	                                                                                                                                                                                                                                                                                                                                                                                                                                        	                                                                                                                               	                                                                                                                                                                                                                                              	                                                                                                                                           	                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                   	                                                                                                                       	   	                                                                                                                                                                                                                                                                                                                         	                                                                                                                                                                                                                                      

#using scripts\zm\_load;
#using scripts\zm\_zm;
#using scripts\zm\_zm_utility;

#precache( "triggerstring", "ZM_ZOD_POWERSWITCH_POWERED" );
#precache( "triggerstring", "ZM_ZOD_POWERSWITCH_UNPOWERED" );

#namespace zm_zod_poweronswitch;



//REGISTER_SYSTEM( "zm_zod_poweronswitch", &__init__, &__main__, undefined )


//	Power #s

//	 1-10	Perk Machines
//	11-20	Stairs
//	21-30	Robot Call Boxes

// PERKS
//	 1 - Quick Revive, Start
//	 2 - Staminup, Junction
//	 3 - Widows Wine, Subway
//	 4 - Random Canal
//	 5 - Random, Theater
//	 6 - Random, Slums

// STAIRS
//	11 - Slums
//	12 - Canal
//	13 - Theater
//	14 - Start 
//	15 - Subway


// activator switch that requires power from a source script_int and triggers a target function when used
class cPowerOnSwitch
{
	var m_mdl_switch; // model of the activator (switch skins, play vfx/sfx on model to display different states)
	var m_t_switch;
	var m_n_power_index;
	var m_func; // function to call
	var m_arg1; // parameter for func
	
	var m_n_state; // unpowered, powered, active
	
	function init_poweronswitch( str_areaname, script_int, linkto_target, func, arg1, n_iter )
	{
		if(!isdefined(n_iter))n_iter=0;
		
		a_mdl_switch		= GetEntArray( "stair_control", "targetname" );
		a_mdl_switch		= array::filter( a_mdl_switch, false, &filter_areaname, str_areaname );
		m_mdl_switch		= a_mdl_switch[ n_iter ];
		a_t_switch			= GetEntArray( "stair_control_usetrigger", "targetname" );
		a_t_switch			= array::filter( a_t_switch, false, &filter_areaname, str_areaname );
		m_t_switch			= a_t_switch[ n_iter ];
		
		m_t_switch			SetHintString( &"ZM_ZOD_POWERSWITCH_UNPOWERED" );
		m_n_power_index		= script_int;
		m_func				= func;
		m_arg1				= arg1;
		
		m_t_switch			EnableLinkTo();
		m_t_switch			LinkTo( m_mdl_switch );
		
		if( isdefined( linkto_target ) )
		{
			m_mdl_switch	LinkTo( linkto_target );
		}
		
		self thread poweronswitch_think();
	}

	function filter_areaname( e_entity, str_areaname )
	{
		if( !isdefined( e_entity.script_string ) || ( e_entity.script_string != str_areaname ) )
		{
			return false;
		}
		return true;
	}
	
	function poweronswitch_think()
	{
		level flag::wait_till( "power_on" + m_n_power_index );
		local_power_on();
	}
	
	// for making the switch show the activated state, when another switch has been used to activate the target
	function show_activated_state()
	{
		m_t_switch			SetInvisibleToAll();
	}
	
	function can_player_use( player )
	{
		if( player zm_utility::in_revive_trigger() )
			return false;
		
		if( ( player.is_drinking > 0 ) )
			return false;
		
		return true;
	}

	
	function local_power_on()
	{
		m_t_switch			SetHintString( &"ZM_ZOD_POWERSWITCH_POWERED" );
		do
		{
			m_t_switch			waittill( "trigger", player ); // wait until someone uses the trigger
		} while ( !can_player_use( player ) );
		m_t_switch			SetInvisibleToAll();
		[[ m_func ]]( m_arg1 );
	}
}
