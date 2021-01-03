    	   	                                                                                                                         	                                                                                                                                                                                                                                                                                                                                                                    	        	     	             	    	   	                           	                               	                                	                                                              	                                                                                                              	                            	                                     	                                       	                                                               	   	                  	       	                                                    	                   	                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                       	                                                                                        	           	                        	                                            	                                             	                                                   	                                                             	                                                         	                                                                    	                                                                                                                                                                                                    	                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                     	                                                              	                                                          	                                   	                                   	                                                    	                                       
                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                            	                                                                                                                                                                                                                                                                                                                                                                                       
                                                                                                                                                                                                                                                                                                                                                                                                                 	                                                                                                                                                                          	                                                                                         	                                                                                                                                                                                                                                                                                                                                                                                                                                        	                                                                                                                               	                                                                                                                                                                                                                                              	                                                                                                                                           	                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                   	                                                                                                                       	   	                                                                                                                                                                                                                                                                                                                         	                                                                                                                                                                                                                                      

#using scripts\shared\array_shared;
#using scripts\shared\callbacks_shared;
#using scripts\shared\clientfield_shared;
#using scripts\shared\flag_shared;
#using scripts\shared\laststand_shared;
#using scripts\shared\system_shared;
#using scripts\codescripts\struct;

#using scripts\zm\_zm_audio;
#using scripts\zm\_zm_laststand;
#using scripts\zm\_zm_score;
#using scripts\zm\_zm_spawner;
#using scripts\zm\_zm_utility;
#using scripts\shared\ai\zombie_death;
	
                                                                                       	                                
                                                                                                                               

#namespace zm_zod_traps;


#using_animtree( "generic" );

function autoexec __init__sytem__() {     system::register("zm_zod_traps",&__init__,undefined,undefined);    }

function __init__()
{
	clientfield::register( "scriptmover", "trap_chain_state",		1, 2, "int" );
	clientfield::register( "scriptmover", "trap_chain_location",    1, 2, "int" );
}


function init_traps( )
{
	if ( !isdefined( level.a_o_trap_chain ) )
	{
		level.a_o_trap_chain = [];
		init_trap( "theater" );
		init_trap( "slums" );
		init_trap( "canals" );
		init_trap( "pap" );
	}
}

function init_trap( str_areaname )
{		
	if( !isdefined( level.a_o_trap_chain[ str_areaname ] ) )
	{
		level.a_o_trap_chain[ str_areaname ] = new cTrap();
		[[ level.a_o_trap_chain[ str_areaname ] ]]->init_trap( str_areaname );
	}
}

/* ****************************************************************************
 * 	Trap base class
 * ****************************************************************************/






class cTrap
{
	// triggers
	var m_a_t_use; // use-triggers
	var m_t_damage; // damage trigger
	var m_t_rumble; // rumble trigger
	var m_e_who; // player who has most recently activated the trap
	
	// sound
	var m_sfx_activate;
	var m_sfx_finished;
	var m_s_audio_location;
	
	// state / stats
	var m_n_state; // unavailable, available, active, cooldown
	var m_n_cost; // cost to use
	var m_n_duration_active; // active duration
	var m_n_duration_cooldown; // cooldown duration
	var m_n_duration_player_damage_cooldown; // damage cooldown duration
	var m_n_duration_zombie_damage_cooldown; // damage cooldown duration
	var m_n_player_damage;
	var m_n_zombie_damage;

	var m_b_discovered; // has any player discovered this trap yet? (used to trigger discovery VO)
	
	// strings
	var m_str_trap_available;
	var m_str_trap_active;
	var m_str_trap_cooldown;
	var m_str_trap_unavailable;

	// chain trap specific stuff (integrated from previous cTrap_Chains	
	var m_b_are_strikers_moving; // true if the striker-chains are currently moving
	var m_a_e_pullcord;
	var m_a_e_heart;

	function init_trap( str_areaname )
	{
		m_n_state								= 1;
		m_b_discovered							= false;

		m_n_cost								= 1000;
		m_n_duration_active						= 25;
		m_n_duration_cooldown					= 25;
		m_n_duration_player_damage_cooldown		= 1;
		m_n_duration_zombie_damage_cooldown		= 0.25;
		m_n_player_damage						= 25;
		m_n_zombie_damage						= 6500;
		
		m_str_trap_unavailable					= &"ZM_ZOD_TRAP_CHAIN_UNAVAILABLE";
		m_str_trap_available					= &"ZM_ZOD_TRAP_CHAIN_AVAILABLE";
		m_str_trap_active						= &"ZM_ZOD_TRAP_CHAIN_ACTIVE";
		m_str_trap_cooldown						= &"ZM_ZOD_TRAP_CHAIN_COOLDOWN";
		
		m_a_t_damage = GetEntArray("trap_chain_damage",	"targetname");
		m_a_t_damage = array::filter( m_a_t_damage,		false, &filter_areaname, str_areaname );
		
		m_a_t_rumble = GetEntArray("trap_chain_rumble",	"targetname");
		m_a_t_rumble = array::filter( m_a_t_damage,		false, &filter_areaname, str_areaname );
	
		
		m_a_e_heart = GetEntArray( "trap_chain_heart", "targetname" );
		m_a_e_heart	= array::filter( m_a_e_heart,		false, &filter_areaname, str_areaname );
		
		m_a_t_use = GetEntArray( "use_trap_chain", "targetname" );
		m_a_t_use = array::filter( m_a_t_use,			false, &filter_areaname, str_areaname );
		strings_update_state(); // update all use-trigger strings to COOLDOWN
		array::thread_all( m_a_t_use, &use_trig_think, self );

		a_str_areaname = [];
		a_str_areaname[0] = "theater";
		a_str_areaname[1] = "slums";
		a_str_areaname[2] = "canals";
		a_str_areaname[3] = "pap";

		foreach( heart in m_a_e_heart )
		{
			for( i = 0; i < a_str_areaname.size; i++ )
			{
				if( a_str_areaname[i] == heart.prefabname )
				{
					heart clientfield::set( "trap_chain_location", i );
				}
			}
		}
		
		m_t_damage								= m_a_t_damage[0];
		m_t_rumble								= m_a_t_rumble[0];
		
		a_audio_structs = struct::get_array( "trap_chain_audio_loc", "targetname" );
		a_audio_structs = array::filter( a_audio_structs,false, &filter_areaname, str_areaname );	
		m_s_audio_location = a_audio_structs[0];
		m_s_audio_location = spawn( "script_origin" , m_s_audio_location.origin );
		
		m_b_are_strikers_moving					= false;
		
		self thread update_chain_animation();
	}

	function filter_areaname( e_entity, str_areaname )
	{
		if( e_entity.prefabname !== str_areaname )
		{
			return false;
		}
		return true;
	}

	// threaded on each use-trigger in m_a_t_use
	// starts unavailable, loops through available-active-cooldown loop
	// when available, checks player input and activates the trap if valid
	function use_trig_think( o_trap )
	{
		while( true )
		{
			self waittill( "trigger", who ); // wait until someone uses the trigger
			
			if( who zm_utility::in_revive_trigger() ) // revive triggers override trap triggers
			{
				continue;
			}
			
			if( ( who.is_drinking > 0 ) )
			{
				continue;
			}
		
			if( !zm_utility::is_player_valid( who ) ) // ensure valid player
			{
				continue;
			}
				
			if( who.score < o_trap.m_n_cost ) // ensure sufficient funds
			{
				continue;
			}

			if( o_trap.m_n_state != 1 ) // ensure the trap is available
			{			
				continue;			
			}
			
			// 1. PAY FOR THE TRAP AND ACTIVATE IT
			o_trap.m_n_state = 2; // update state immediately, to prevent race condition between switches
			m_e_who = who; // record current user of trap, so it will be available to other functions on the object
			who zm_score::minus_to_player_score( o_trap.m_n_cost ); // pay for trap
			// the following update functions all update aspects of the trap appropriately for the current state (set in m_n_state)
			[[ o_trap ]]->strings_update_state();
			[[ o_trap ]]->switch_update_state( self );
			[[ o_trap ]]->trap_update_state();
			// active state timer
			wait( o_trap.m_n_duration_active );
			
			// 2. COOLDOWN PERIOD
			// change the state
			o_trap.m_n_state = 3;
			// reupdate everything
			[[ o_trap ]]->trap_update_state();
			[[ o_trap ]]->switch_update_state( self );
			[[ o_trap ]]->strings_update_state();
			// cooldown timer
			wait( o_trap.m_n_duration_cooldown );

			// 3. MAKE AVAILABLE AGAIN
			// change the state
			o_trap.m_n_state = 1; // update trap state to AVAILABLE
			// reupdate everything
			[[ o_trap ]]->strings_update_state();
			[[ o_trap ]]->switch_update_state( self );
			[[ o_trap ]]->trap_update_state();
		}
	}

	// updates all use-trigger strings to match current state of the trap
	function strings_update_state()
	{
		switch( m_n_state )
		{
			case 1:
				array::thread_all( m_a_t_use, &hint_string, m_str_trap_available, m_n_cost );  // update all use-trigger strings to AVAILABLE
				break;
			case 2:
				array::thread_all( m_a_t_use, &hint_string, m_str_trap_active ); // update all use-trigger strings to ACTIVE
				break;
			case 3:
				array::thread_all( m_a_t_use, &hint_string, m_str_trap_cooldown ); // update all use-trigger strings to COOLDOWN
				break;
			case 0:
				array::thread_all( m_a_t_use, &hint_string, m_str_trap_unavailable ); // update all use-trigger strings to UNAVAILABLE
				break;
		}
	}

	// t_use: the use-trigger that activates this switch
	function switch_update_state( t_use )
	{
		switch( m_n_state )
		{
			case 1:
				[[ self ]]->switch_available( t_use );
				break;
			case 2:
				[[ self ]]->switch_active( t_use );
				break;
			case 3:
				[[ self ]]->switch_cooldown( t_use );
				break;
			case 0:
				[[ self ]]->switch_unavailable( t_use );
				break;
		}
	}
	
	function switch_available( t_use )
	{
		self thread update_chain_animation();
		// TODO: heart animation normal
		// TODO: sound
		// TODO: vfx (clientfield updates)
	}
	
	function switch_active( t_use )
	{
		if( !m_b_discovered )
		{
			// TODO: DISCOVERY AUDIO GOES HERE
			level thread zm_audio::sndMusicSystem_PlayState( "trap" );
			//m_e_who do_player_general_vox( "general", "discover_trap" );
			m_b_discovered = true;
		}
		else
		{
			// TODO: NORMAL START-TRAP AUDIO GOES HERE
			//m_e_who do_player_general_vox( "general", "start_trap" );
		}
		
		// move pullcord
		foreach( e_heart in m_a_e_heart )
		{
			e_heart MoveTo( e_heart.origin + ( 0, 0, -32 ), 0.25 );
		}

		wait 0.25;

		// placeholder
		m_t_damage playsound( "zmb_trap_activate" );
		self thread update_chain_animation();

		// TODO: vfx (clientfield updates)
	}
	
	function switch_cooldown( t_use )
	{
		// restore pullcord

		foreach( e_heart in m_a_e_heart )
		{
			e_heart MoveTo( e_heart.origin - ( 0, 0, -32 ), 0.25 );
		}

		wait 0.25;
		
		// placeholder
		self thread update_chain_animation();
		
		// TODO: sound
		// TODO: vfx (clientfield updates)
	}

	function switch_unavailable( t_use )
	{
		// TODO: heart animation stops
		// TODO: sound
		// TODO: vfx (clientfield updates)
	}
	
	function trap_update_state()
	{
		switch( m_n_state )
		{
			case 1:
				[[ self ]]->trap_available();
				break;
			case 2:
				[[ self ]]->trap_active();
				self notify( "trap_start" );
				break;
			case 3:
				[[ self ]]->trap_cooldown();
				self notify( "trap_done" );
				break;
			case 0:
				[[ self ]]->trap_unavailable();
				self notify( "trap_done" );
				break;
		}
	}

	function trap_available()
	{
 		m_t_damage SetInvisibleToAll();
		m_t_damage TriggerEnable( false );
	}
	
	function trap_active() // transition to active state
	{
		/# PrintLn( "trap_active()" ); #/

		//who maps\mp\zombies\_zm_stats::increment_client_stat( "zod_chain_trap_used", false ); // TODO: REPORT CLIENT STATS FOR SPECIFIC TRAP USAGE?
		m_t_damage SetVisibleToAll(); // damage trigger detects everything passing through
		m_t_damage TriggerEnable( true );
		thread trap_damage(); // set looping damage thread on the damage trigger
	}
	
	function trap_cooldown()
	{
 		m_t_damage SetInvisibleToAll();
		m_t_damage TriggerEnable( false );
	}
	
	function trap_unavailable()
	{
 		m_t_damage SetInvisibleToAll();
		m_t_damage TriggerEnable( false );
	}
	
	function trap_damage()
	{
		self endon( "trap_done" );

		while( true )
		{
			m_t_damage waittill( "trigger", ent );

			if( isplayer( ent ) ) // player
			{
				thread trap_damage_player( ent );
			}
			else // non-player
			{
				if( isdefined( ent.marked_for_death ) )
				{
					continue;
				}
				
				thread trap_damage_nonplayer( ent );
			}
		}
	}
	
	function trap_damage_player( ent )
	{	
		ent endon( "death" );
		ent endon( "disconnect" );
	
		if( ent laststand::player_is_in_laststand() )
		{
			return;
		}
		
		if( isdefined( ent.trap_damage_cooldown ) )
		{
			return;
		}
		ent.trap_damage_cooldown = true;
		
		if( !ent hasperk( "specialty_armorvest" ) || ent.health - 100 < 1 )
		{
			ent dodamage( m_n_player_damage, ent.origin);
			ent.trap_damage_cooldown = undefined;
		}
		else
		{
			ent dodamage( m_n_player_damage / 2, ent.origin);
			wait( m_n_duration_player_damage_cooldown );
			ent.trap_damage_cooldown = undefined;
		}
	}
	
	function trap_damage_nonplayer( ent )
	{
		ent endon( "death" );
		
		if( isdefined( ent.trap_damage_cooldown ) )
		{
			return;
		}
		ent.trap_damage_cooldown = true;

		if( isDefined( ent.maxhealth ) && m_n_zombie_damage >= ent.maxhealth && !IsVehicle( ent) )
		{
			trap_death_nonplayer( ent ); //give a zombie a cycle to walk into the trap
			ent dodamage( ent.maxhealth * 0.5, ent.origin, m_t_damage, m_t_damage, "none" ); //do half damage
			wait( m_n_duration_zombie_damage_cooldown );
			trap_death_nonplayer( ent );
			ent dodamage( ent.maxhealth, ent.origin, m_t_damage, m_t_damage, "none" ); // ensure death damage
			ent.trap_damage_cooldown = undefined;
		}
		else
		{
			trap_death_nonplayer( ent );
			ent dodamage( m_n_zombie_damage, ent.origin, m_t_damage, m_t_damage, "none" );
			wait( m_n_duration_zombie_damage_cooldown );
			ent.trap_damage_cooldown = undefined;
		}
	}
	
	function trap_death_nonplayer( ent )
	{
		if( !IsVehicle( ent ))
		{
			//ent.marked_for_death = true;
			ent.a.gib_ref = array::random( array( "guts", "right_arm", "left_arm", "head" ) );
			//ent.a.gib_ref = array( "guts", "right_arm", "left_arm", "head" );
			ent thread zombie_death::do_gib();
			//ent thread zm_spawner::zombie_gib_on_damage();
		}
	}

	function update_chain_animation()
	{
		m_a_e_heart[0] clientfield::set( "trap_chain_state", m_n_state );
		m_s_audio_location thread sndChainSound(m_n_state);
	}
	
	function sndChainSound(state)
	{
		
		switch( state )
		{
			case 2:
				self playsound( "evt_chaintrap_start" );
				self playloopsound( "evt_chaintrap_loop", .2 );
				wait(25);
				self stoploopsound( .5 );
				self playsound( "evt_chaintrap_stop" );
				break;
			case 1:
				self playloopsound( "evt_chaintrap_idle", 1 );
				break;
		}
	}

	function hint_string( string, cost )
	{
		if( IsDefined( cost ) )
		{
			self SetHintString( string, cost );
		}
		else
		{
			self SetHintString( string );
		}
	
		self SetCursorHint( "HINT_NOICON" ); 
	}
}
