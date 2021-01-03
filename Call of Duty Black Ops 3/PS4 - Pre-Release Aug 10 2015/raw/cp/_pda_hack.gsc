#using scripts\cp\_util;

#using scripts\shared\system_shared;
#using scripts\shared\flag_shared;
#using scripts\shared\scoreevents_shared;
#using scripts\shared\util_shared;
#using scripts\shared\hud_util_shared;

    	   	                                                                                                                                         	                                	                                                                                                                                                                                                                                                                                                                                                                    	        	     	             	    	   	               	                                              	                                                           	                               	                     	                                                                                                           	                                                                 	                                                              	                                                                                                              	                            	                                     	                                       	                                                                                                              	   	                  	       	                                                    	                   	                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                        	                                  	                                                                                        	           	                        	                                            	                                             	                                                   	                                                             	                                                         	                                                                    	                                                                                                                                                                                                    	                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                         	                                                              	                                                          	                                   	                                   	                                                    	                                       	                                           	     	                                                                                                                                                                                                                                                      	                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                     




	// Each time you hack, the hacking time is multiplied by this number.


function autoexec __init__sytem__() {     system::register("pda_hack",&__init__,undefined,undefined);    }
	
function __init__()
{
}

class cHackableObject
{	
	var m_is_functional;
	var m_is_hackable; // is this thing currently hackable?
	var m_e_hack_trigger; // the hack trigger
	var m_hack_complete_func; // function to call after completed
	var m_hack_custom_complete_func; // custom function to call after completed (set by inheriting class to do class-specific things)
	var m_progress_bar; // progress bar for hack
	var m_str_team; // team name
	var m_n_hack_duration; // how long in seconds it takes to hack the turret
	var m_n_hack_radius; // how close the player must be
	var m_n_hack_height; // height of the trigger	
	var m_e_reference;  // optional entity that completion func will run on, if it exists
	var m_str_hackable_hint;  
	var m_does_hack_time_scale;
	var m_is_trigger_thread_active;
	var m_e_origin; // need a scriptmodel ent to place the diamond indicator on (triggers apparently won't work for some reason)
	
	constructor()
	{
		// default interaction settings
		m_is_functional = true; // things are functional (not in need of repair) by default
		m_is_hackable = false; // hacking is disabled by default; must be enabled on inherited class or on instance
		m_is_trigger_thread_active = false;

		// "hack interaction" default settings
		m_n_hack_duration = 2.0;
		m_n_hack_radius = 72;
		m_n_hack_height = 128;
		m_hack_complete_func = &hacking_completed; // default completion function (can be overridden by inherited class, if the inherited class needs to deviate from the common consequences)
		
		m_does_hack_time_scale = false;
		
		m_str_team = "axis";
	}	
	
	destructor()
	{
		clean_up();
	}
	
	function setup_hackable_object( v_origin, str_hint_string, v_angles, func_on_completion, e_reference )
	{
		Assert( IsDefined( v_origin ), "cHackableObject: setup_hackable_object() missing v_origin!" );
		
		if( !isdefined( v_angles ) )
		{
			v_angles = ( 0,0,0 );
		}
		
		m_str_hackable_hint = str_hint_string;
		
		m_hack_custom_complete_func = func_on_completion;
		m_e_reference = e_reference;
		
		m_e_hack_trigger = spawn_hackable_trigger( v_origin, m_n_hack_radius, m_n_hack_height, m_str_hackable_hint );
		m_e_hack_trigger.angles = v_angles;
		// need this scriptmodel to be able to put a minimap icon on this
		m_e_origin = Spawn( "script_model", v_origin );
		m_e_origin setModel( "" );
		m_e_origin NotSolid();

	
		Assert( !m_is_hackable, "cHackableObject: setup_hackable_object() has already run on this class instance!" );
		
		m_is_hackable = true;
		
		enable_hacking();
		
		self thread thread_hacking_progress();
	}
	
	function set_custom_hack_time( n_time )
	{
		m_n_hack_duration = n_time;
	}
	
	// enable hacking, if hackable (sets hint string and starts thread if appropriate)
	function enable_hacking()
	{
		if ( m_is_hackable )
		{
			if ( m_str_team != "allies" )
			{
				// reenable hacking
				m_e_hack_trigger SetHintString( m_str_hackable_hint );
				m_e_hack_trigger SetHintLowPriority( true );
				
				if ( !m_is_trigger_thread_active )
				{
					self thread thread_hacking_progress();
				}				
			}
			else
			{
				m_e_hack_trigger SetHintString( "" );
				m_e_hack_trigger SetHintLowPriority( true );
			}
		}
	}

	// disable hacking, if hackable (sets hint string and kills thread)
	function disable_hacking()
	{
		if ( m_is_hackable )
		{
			self notify( "hacking_disabled" ); // kill hacking thread
			m_e_hack_trigger SetHintString( "" );
			m_e_hack_trigger SetHintLowPriority( true );
			m_is_trigger_thread_active = false;
		}
	}

	function hacking_completed( e_triggerer )
	{
		self notify( "hacking_completed" );

		// common consequences of completing a hack
		m_str_team = "allies";
		m_e_hack_trigger SetHintString( "" );
		m_e_hack_trigger SetHintLowPriority( true );
		
		// score event and sound
//		scoreevents::processScoreEvent( "raid_terminal_hacked", e_triggerer );
//		e_triggerer PlaySoundToTeam( "mpl_killstreak_auto_turret", e_triggerer.team );

		if ( IsDefined( m_e_reference ) )
		{
			e_reference = m_e_reference;
		}
		else 
		{
			e_reference = self;
		}
		
		//e_reference DO_IF_DEFINED( m_hack_custom_complete_func );
		if ( IsDefined( m_hack_custom_complete_func ) )
		{
			e_reference [[ m_hack_custom_complete_func ]]();
		}
	}
	
	function wait_till_hacking_completed()
	{
		self waittill( "hacking_completed" );
	}
	
	// track hacking progress, show bar
	function thread_hacking_progress()
	{
		self endon( "hacking_completed" ); // if one co-op player completes the hack, it kills any other thread_hacking_progress a co-op player may have up
		self endon( "hacking_disabled" ); // if thing becomes nonfunctional (is destroyed) or for some other reason hacking is disabled on it
		m_e_hack_trigger endon( "death" );

		const n_lookat_restrictiveness = 0.75;

		m_is_trigger_thread_active = true;
		
		m_e_hack_trigger SetHintString(	"" );
		m_e_hack_trigger SetHintLowPriority( true );

		while( true )
		{
			m_e_hack_trigger waittill( "trigger", e_triggerer );
			
			// can't hack if not functional to begin with
			if( !m_is_functional )
			{
				continue;
			}
		
			// require lookat to even see the hintstring
			if( !e_triggerer util::is_player_looking_at( m_e_hack_trigger.origin, n_lookat_restrictiveness, false ) )
			{
				m_e_hack_trigger SetHintString(	"" ); // clear hint string since we can't see the trigger origin
				m_e_hack_trigger SetHintLowPriority( true );
				continue;
			}
			
			// show the hint string now
			m_e_hack_trigger SetHintString(	m_str_hackable_hint );
			m_e_hack_trigger SetHintLowPriority( true );
			
			// by default, player must press "use" inside the trigger to begin hack
			if( !e_triggerer UseButtonPressed() )
			{
				continue;
			}
			
			// The hintstring should now only display to the one doing the hacking.
			foreach( player in level.players )
			{
				if ( player != e_triggerer )
				{
					m_e_hack_trigger SetHintStringForPlayer( player, "" );
				}
			}
			
			// primaryProgressBar settings
			level.primaryProgressBarX = 0;
			level.primaryProgressBarY = 110;
			level.primaryProgressBarHeight = 8;
			level.primaryProgressBarWidth = 120;
			level.primaryProgressBarY_ss = 280;	

			// hold up hacking device player model
			e_triggerer temp_player_lock_in_place( m_e_hack_trigger );
//			str_current_weapon = e_triggerer GetCurrentWeapon();
//			e_triggerer GiveWeapon( level.weaponHackerTool );
//			e_triggerer SwitchToWeaponImmediate( level.weaponHackerTool );
//			e_triggerer DisableWeaponCycling();

			// Give a moment for the hack tool to come up.
			wait 0.8;
			
			// start time counter
			n_start_time = 0;
			
			n_hack_time = m_n_hack_duration;
			
			if ( m_does_hack_time_scale )
			{
				if ( isdefined( level.n_hack_time_multiplier ) )
				{
					n_hack_time *= level.n_hack_time_multiplier;
				}
			}
			
			n_hack_range_sq = m_n_hack_radius * m_n_hack_radius;
			n_user_dist_sq = Distance2DSquared( e_triggerer.origin, m_e_hack_trigger.origin );
			if ( n_user_dist_sq > n_hack_range_sq )
			{
				n_hack_range_sq = n_user_dist_sq;
			}
			b_looking = true;

			// hacking progress			
			while( n_start_time < n_hack_time && e_triggerer UseButtonPressed() && n_user_dist_sq <= n_hack_range_sq && b_looking )
			{
				n_start_time += 0.05;
				
				if( !isdefined( m_progress_bar ) )
				{	
					m_progress_bar = e_triggerer hud::createPrimaryProgressBar();
					m_progress_bar thread do_bar_update( n_hack_time );
				}
				
				{wait(.05);};
				
				n_user_dist_sq = Distance2DSquared( e_triggerer.origin, m_e_hack_trigger.origin );
				b_lookig = e_triggerer util::is_player_looking_at( m_e_hack_trigger.origin, n_lookat_restrictiveness, false );
			}
			// exiting hack

			// delete progress bar, if present
			if ( isdefined( m_progress_bar ) )
			{
				m_progress_bar notify( "kill_bar" );
				m_progress_bar hud::destroyElem();
			}
			
			// restore player's weapon
			e_triggerer temp_player_lock_in_place_remove();
//			e_triggerer EnableWeaponCycling();
//			e_triggerer TakeWeapon( level.weaponHackerTool ); // return to normal weapons
//			if ( IsDefined( str_current_weapon ) && ( str_current_weapon != level.weaponNone ) )
//			{
//				e_triggerer SwitchToWeaponImmediate( str_current_weapon );
//			}

			// was the hack completed?
			if ( n_start_time >= n_hack_time )
			{
				if ( m_does_hack_time_scale )
				{
					if ( !isdefined( level.n_hack_time_multiplier ) )
					{
						level.n_hack_time_multiplier = 1.0;
					}
					level.n_hack_time_multiplier += 0.2;
				}
				
				// CHANGE TEAM
				self thread [[ m_hack_complete_func ]]( e_triggerer );
			}
			
			// debounce (prevent weird limbo at edge of triggerable radius - weapon perpetually being down with no visible progress if the player holds the button)
			while( e_triggerer UseButtonPressed() )
			{
				wait 0.1;
			}
		}
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

	// self = progressbar hud
	function do_bar_update( n_hack_duration )
	{
		self endon( "kill_bar" );

		self hud::updateBar( 0.01, 1 / n_hack_duration );
	}

	// generic trigger spawn function for turret interactions (pickup items, hacking, etc.)
	function spawn_hackable_trigger( v_origin, n_radius, n_height, str_hint )
	{
		Assert( isdefined( v_origin ), "spawn_interact_trigger - v_origin not defined" );
		Assert( isdefined( n_radius ), "spawn_interact_trigger - n_radius not defined" );
		Assert( isdefined( n_height ), "spawn_interact_trigger - n_height not defined" );
		
		e_trigger = spawn( "trigger_radius", v_origin, 0, n_radius, n_height );
		e_trigger TriggerIgnoreTeam();
		e_trigger SetVisibleToAll();
		e_trigger SetTeamForTrigger( "none" );
		e_trigger SetCursorHint( "HINT_NOICON" );
		
		if ( isdefined( str_hint ) )
		{
			e_trigger SetHintString( str_hint );
		}
		
		return e_trigger;
	}	
	
	function clean_up()
	{
		if ( IsDefined( m_e_hack_trigger ) )
		{
			m_e_hack_trigger Delete();
		}
	}
}

