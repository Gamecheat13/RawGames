/* zm_zod_quest.gsc
 *
 * Purpose : 	Quest declaration and global quest logic for capturing Lil' Arnie (the Octobomb).
 *		
 * 
 * Author : 	G Henry Schmitt
 * 
 * Players must
 *   1. pick up a Keeper Jar
 *   2. catch Lil' Arnie, who will spawn from a random door in one of the finger districts and run to another random door
 *   3. after throwing the Lil' Arnie weapon, player must wait until the next round for the jar to reform
 *	 4. player can then catch another Lil' Arnie to repopulate the jar
 * 
 */
 
#using scripts\codescripts\struct;

#using scripts\shared\array_shared;
#using scripts\shared\callbacks_shared;
#using scripts\shared\clientfield_shared;
#using scripts\shared\flag_shared;
#using scripts\shared\math_shared;
#using scripts\shared\system_shared;
#using scripts\shared\util_shared;

    	   	                                                                                                                         	                                                                                                                                                                                                                                                                                                                                                                    	        	     	             	    	   	                           	                               	                                	                                                              	                                                                                                              	                            	                                     	                                       	                                                               	   	                  	       	                                                    	                   	                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                       	                                                                                        	           	                        	                                            	                                             	                                                   	                                                             	                                                         	                                                                    	                                                                                                                                                                                                    	                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                     	                                                              	                                                          	                                   	                                   	                                                    	                                       
                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                            	                                                                                                                                                                                                                                                                                                                                                                                       

                                                                                                                               
                                                                                                                                                                                                                                                                                                                                                                                                                 	                                                                                                                                                                          	                                                                                         	                                                                                                                                                                                                                                                                                                                                                                                                                                        	                                                                                                                               	                                                                                                                                                                                                                                              	                                                                                                                                           	                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                   	                                                                                                                       	   	                                                                                                                                                                                                                                                                                                                         	                                                                                                                                                                                                                                      
                        	                                                                                     	                                                                                                    

#using scripts\zm\_load;
#using scripts\zm\_zm;
#using scripts\zm\_zm_pack_a_punch_util;
#using scripts\zm\_zm_unitrigger;
#using scripts\zm\_zm_utility;
#using scripts\zm\_zm_weap_octobomb;
#using scripts\zm\_zm_weapons;

#precache( "triggerstring", "ZM_ZOD_OCTOBOMB_PICKUP_BOMB" );
#precache( "triggerstring", "ZM_ZOD_OCTOBOMB_PICKUP_JAR" );

	// how often per round the players may get a chance to catch the octobomb
	// min amount of time until the next octo catch chance comes up
	// max amount of time until the next octo catch chance comes up

	// how fast the octobomb dashes from octodoor to octodoor



#namespace zm_zod_octobomb_quest;



function autoexec __init__sytem__() {     system::register("zm_zod_octobomb_quest",&__init__,undefined,undefined);    }

function __init__()
{	
	callback::on_connect( &on_player_connect );
	// register randomized-locations for objects so host migration doesn't affect it
	// octobomb states
	clientfield::register( "toplayer", 	"octobomb_state",				1,	3,			"int" );
//	clientfield::register( "world", 	"octobomb_dashing",				VERSION_SHIP,	1,								"int" );
	
	// TODO: any flags init here

	/#
		level thread octobomb_devgui();
	#/
}

function on_player_connect()
{
	self clientfield::set_to_player( "octobomb_state", 0 );

	self player_refresh_quest_hud();
}

// refresh the luimenu for the player's quest hud
// self = player
function player_refresh_quest_hud()
{
	n_octobomb_state = self clientfield::get_to_player( "octobomb_state" );
	
//	self player_refresh_octobomb_quest_hud( n_octobomb_state );
}

function player_refresh_octobomb_quest_hud( value )
{
	self SetLUIMenuData( self.octobomb_hud, "zod_octobomb_quest_plain_alpha", 0 );
	self SetLUIMenuData( self.octobomb_hud, "zod_octobomb_quest_magic_alpha", 0 );
	self SetLUIMenuData( self.octobomb_hud, "zod_octobomb_quest_filled_alpha", 0 );
	self SetLUIMenuData( self.octobomb_hud, "zod_octobomb_quest_broken_alpha", 0 );
	
	switch( value )
	{
		case 0:
			break;
		case 1:
			self SetLUIMenuData( self.octobomb_hud, "zod_octobomb_quest_plain_alpha", 1 );
			break;
		case 2:
			self SetLUIMenuData( self.octobomb_hud, "zod_octobomb_quest_magic_alpha", 1 );
			break;
		case 3:
			self SetLUIMenuData( self.octobomb_hud, "zod_octobomb_quest_filled_alpha", 1 );
			break;
		case 4:
			self SetLUIMenuData( self.octobomb_hud, "zod_octobomb_quest_broken_alpha", 1 );
			break;
	}
}

function start_zod_octobomb_quest()
{
//	callback::on_connect( &player_disconnect_watcher );
//	callback::on_connect( &player_death_watcher );
	
	level flag::wait_till( "start_zombie_round_logic" );
	
	// ghost assets outside playable space
	prevent_theater_mode_spoilers();

	level thread setup_jar_quest(); // Quest to get the Plain Jar and upgrade it to the Magic Jar
}

function prevent_theater_mode_spoilers()
{
	level flag::wait_till( "initial_blackscreen_passed" );

	// hide quest key
	mdl_octobomb = GetEnt( "octobomb_pickup", "targetname" );
	mdl_octobomb Ghost();
}

//
// JAR QUEST
//

// setup the quest for the player to acquire and magic up the jar
function setup_jar_quest()
{
	// create octobomb
	if ( !isdefined( level.octobomb_manager ) )
	{
		level.octobomb_manager = new cOctobombManager();
		[[ level.octobomb_manager ]]->init();
	}

	// create jars
	level.a_jar_managers = [];
	for( i = 0; i < 4; i++ )
	{
		level.a_jar_managers[i] = new cJarManager();
		[[ level.a_jar_managers[i] ]]->init( "octobomb_jar_" + i );
	}
}

//
// JAR MANAGER
//

// four of these exist - one for each jar
// will handle connect / disconnect situations, respawning the jar so another player can join and get it
class cJarManager
{	
	var m_mdl_jar; // model of the jar
	var m_b_is_on_table; // is this jar still on the table?
	
	function init( str_mdl_jar )
	{
		m_mdl_jar = GetEnt( str_mdl_jar, "targetname" );
		m_b_is_on_table = true;
		
		// create trigger
		create_jar_pickup_unitrigger();
	}
	
	function create_jar_pickup_unitrigger()
	{
		width = 128;
		height = 128;
		length = 128;
	
		m_mdl_jar.unitrigger_stub = spawnstruct();
		m_mdl_jar.unitrigger_stub.origin = m_mdl_jar.origin;
		m_mdl_jar.unitrigger_stub.angles = m_mdl_jar.angles;
		m_mdl_jar.unitrigger_stub.script_unitrigger_type = "unitrigger_box_use";
		m_mdl_jar.unitrigger_stub.cursor_hint = "HINT_NOICON";
		m_mdl_jar.unitrigger_stub.script_width = width;
		m_mdl_jar.unitrigger_stub.script_height = height;
		m_mdl_jar.unitrigger_stub.script_length = length;
		m_mdl_jar.unitrigger_stub.require_look_at = false;
		m_mdl_jar.unitrigger_stub.o_jar = self;
		
		m_mdl_jar.unitrigger_stub.prompt_and_visibility_func = &jar_trigger_visibility;
		zm_unitrigger::register_static_unitrigger( m_mdl_jar.unitrigger_stub, &jar_trigger_think );
	}

	// should the Keeper Jar currently be on the source table in the Keeper Storeroom?
	function get_is_jar_on_table()
	{
		return m_b_is_on_table;
	}
	
	function pickup_jar( player )
	{
		// this model should now be hidden to all
		m_b_is_on_table = false;
		m_mdl_jar Ghost();
		
		// give the activating player the octobomb plain jar
		player clientfield::set_to_player( "octobomb_state", 2 );
		player zm_zod_octobomb_quest::player_refresh_quest_hud();
	}
	
	// self = unitrigger
	function jar_trigger_visibility( player )
	{
		b_player_can_pick_up_jar = false;
		b_jar_is_on_table = false;
		
		if( player clientfield::get_to_player( "octobomb_state" ) === 0 )
		{
			b_player_can_pick_up_jar = true;
		}
		if( [[ self.stub.o_jar ]]->get_is_jar_on_table() )
		{
			b_jar_is_on_table = true;
		}
		
		b_is_invis = ( isdefined( player.beastmode ) && player.beastmode ) || !b_player_can_pick_up_jar || !b_jar_is_on_table;
		self setInvisibleToPlayer( player, b_is_invis );

		self SetHintString( &"ZM_ZOD_OCTOBOMB_PICKUP_JAR" );
		
		return !b_is_invis;
	}

	function jar_trigger_think()
	{
		while( true )
		{
			self waittill( "trigger", player ); // wait until someone uses the trigger
	
			if( player zm_utility::in_revive_trigger() ) // revive triggers override trap triggers
			{
				continue;
			}
			
			if( ( player.is_drinking > 0 ) )
			{
				continue;
			}
		
			if( !zm_utility::is_player_valid( player ) ) // ensure valid player
			{
				continue;
			}

			// pickup
			[[ self.stub.o_jar ]]->pickup_jar( player );
			
			break;
		}
		
		// Octobomb will now begin appearing in the world to be captured
		[[ level.octobomb_manager ]]->start();
	}
}

//
// OCTOBOMB MANAGER
//

class cOctobombManager
{	
	// frequency and timing stats
	var m_n_times_per_round; // how often per round the players may get a chance to catch the octobomb
	var m_n_cooldown_min_base; // base min cooldown for a chance to catch the octobomb
	var m_n_cooldown_max_base; // base max cooldown for a chance to catch the octobomb
	var m_n_cooldown_min_current; // current min cooldown for a chance to catch the octobomb
	var m_n_cooldown_max_current; // current max cooldown for a chance to catch the octobomb
	var m_n_time_last_dashed; // record the time that the last dash ended (cooldown is calculated from this time)

	// stats related to the dash event itself
	var m_n_dash_speed_base; // base speed the octobomb goes from door to door
	var m_n_dash_speed_current; // current speed the octobomb goes from door to door
	
	// entities
	var m_octobomb; // the octobomb pickup
	var t_octobomb;	// the octobomb pickup trigger

	// other
	var m_b_has_started; // has the octobomb manager been started yet?
	
	function init()
	{
		m_n_times_per_round = 1;
		
		m_n_cooldown_min_base = 1;
		m_n_cooldown_max_base = 5;
		m_n_cooldown_min_current = m_n_cooldown_min_base;
		m_n_cooldown_max_current = m_n_cooldown_max_base;
		
		m_n_dash_speed_base =  1 / 196;
		m_n_dash_speed_current = m_n_dash_speed_base;
		
		m_octobomb = GetEnt( "octobomb_pickup", "targetname" );
		t_octobomb = GetEnt( "octobomb_usetrigger", "targetname" );
		t_octobomb EnableLinkTo();
		t_octobomb LinkTo( m_octobomb );
		t_octobomb SetHintString( &"ZM_ZOD_OCTOBOMB_PICKUP_BOMB" );
		
		m_b_has_started = false;
	}
	
	function start()
	{
		update_trigger_visibility();
		
		if( m_b_has_started == true ) // only need to set up the manager threads once, but may call start() from multiple jar triggers
		{
			return;
		}
		m_b_has_started = true;
		
		self thread octobomb_manager();
		self thread octobomb_trigger_think();
	}

	function update_trigger_visibility()
	{
		a_players = GetPlayers();
		foreach( player in a_players )
		{
			if( player clientfield::get_to_player( "octobomb_state" ) == 2 )
			{
				t_octobomb SetVisibleToPlayer( player );
			}
			else
			{
				t_octobomb SetInvisibleToPlayer( player );
			}
		}
	}

	function octobomb_manager()
	{
		level notify( "octobomb_manager" );
		level endon( "octobomb_manager" );
		
		// check conditions for when it is right to trigger an octobomb dash
		while( true )
		{
			// 1. sufficient time has passed since the last opportunity to catch an octobomb
			m_n_time_last_dashed = GetTime();
			n_cooldown_current = RandomFloatRange( m_n_cooldown_min_current, m_n_cooldown_max_current ) * 1000; // convert to ms
		
			n_elapsed_time = GetTime() - m_n_time_last_dashed;
			while( n_elapsed_time < n_cooldown_current )
			{
				wait 0.05;
				n_elapsed_time = GetTime() - m_n_time_last_dashed;
			}
		
			// 2. check that there is a player that currently has the magic jar (empty, intact); create an array of these
			a_target_players = [];
			while( a_target_players.size == 0 )
			{
				a_players = GetPlayers();
				foreach( player in a_players )
				{
					if( player clientfield::get_to_player( "octobomb_state" ) == 2 )
					{
						array::add( a_target_players, player );
					}
				}
				
				wait 1.0;
			}
	
			// 3. randomly pick a player from the array, call the octobomb_dash on that octobomb zone that player is in
			target_player = array::random( a_target_players );
			
			// for now just play it in a random zone
			str_octobomb_area = "octobomb_area_" + RandomIntRange( 1, 4 );
		
			// 4. go ahead with the dash (calling octobomb dash includes the beginning pauses and foreshadowing vfx; it handles the whole sequence)
			self octobomb_dash( str_octobomb_area );
		}
	}

	// handles the entire octobomb dash sequence (foreshadowing, the actual dash, vo, etc.)
	function octobomb_dash( str_octobomb_area )
	{
		///# PrintLn( "OCTOBOMB DASH" ); #/
		update_trigger_visibility();

		// randomly pick a door
		a_octobomb_doors = struct::get_array( str_octobomb_area, "script_noteworthy" );
		s_octobomb_start_door = array::random( a_octobomb_doors );

		// teleport octobomb pickup
		m_octobomb.origin = s_octobomb_start_door.origin;
		m_octobomb Show();
		t_octobomb Show();
		
		m_octobomb playsound( "evt_arnie_exit" );
		m_octobomb playloopsound( "evt_arnie_scurry_loop", 2 );

		// octobomb follows the struct path
		a_s_next_path 		= struct::get_array( s_octobomb_start_door.target, "targetname" );
		s_next_path 		= array::random( a_s_next_path );
		v_origin			= s_octobomb_start_door.origin;
		v_dest				= s_next_path.origin;
		n_dist				= Distance2D( v_origin, v_dest );
		n_move_duration		= math::clamp( n_dist * m_n_dash_speed_current, .05 );
		m_octobomb.angles	= ( 0, math::get_2d_yaw( v_dest, v_origin ), 0 );
		m_octobomb			MoveTo( v_dest, n_move_duration );
		wait n_move_duration;
		
		while( !isdefined( s_next_path.script_noteworthy ) )
		{
			s_path				= s_next_path;
			a_s_next_path 		= struct::get_array( s_path.target, "targetname" );
			s_next_path			= array::random( a_s_next_path );
			v_origin			= s_path.origin;
			v_dest				= s_next_path.origin;
			n_dist				= Distance2D( v_origin, v_dest );
			n_move_duration		= n_dist * m_n_dash_speed_current;
			m_octobomb.angles	= ( 0, math::get_2d_yaw( v_origin, v_dest ), 0 );
			m_octobomb			MoveTo( v_dest, n_move_duration );
			wait n_move_duration;
		}
		
		m_octobomb stoploopsound( 1 );
		m_octobomb playsound( "evt_arnie_enter" );
		
		m_octobomb Ghost();
		t_octobomb Ghost();
	}
	
	function octobomb_trigger_think()
	{
		while( true )
		{
			t_octobomb waittill( "trigger", player ); // wait until someone uses the trigger
			
			// make sure the player has the magic jar
			if( player clientfield::get_to_player( "octobomb_state" ) != 2 )
			{
				continue;
			}
			
			octobomb_give_to_player( player );
		}
	}
	
	function octobomb_give_to_player( player )
	{
		player clientfield::set_to_player( "octobomb_state", 3 );
		player thread octobomb_expend_think();
		player zm_zod_octobomb_quest::player_refresh_quest_hud();
		player playlocalsound( "evt_arnie_grab" );

		weapon = GetWeapon( "octobomb" );
		player TakeWeapon( weapon ); // take away if it's already there, to make sure it replenishes properly
		player zm_weapons::weapon_give( weapon, undefined, undefined, true );
		
		m_octobomb stoploopsound( 1 );
		
		m_octobomb Ghost();
		t_octobomb Ghost();
	}
	
	function octobomb_expend_think()
	{
		self notify( "octobomb_expend_think" );

		self endon( "disconnect" );
		self endon( "bled_out" );
		self endon( "octobomb_expend_think" );
		
//		weapon_octobomb = GetWeapon( "octobomb" );
//		self waittill ( "weapon_fired", weapon_octobomb ); // jar breaks when thrown
//		self clientfield::set_to_player( CF_OCTOBOMB_STATE, OCTOBOMB_JAR_BROKEN_ENUM );
//		self zm_ZOD_OCTOBOMB_quest::player_refresh_quest_hud();
//		self TakeWeapon( weapon_octobomb );
		level waittill( "between_round_over" ); // magic jar resets on round transition
		self clientfield::set_to_player( "octobomb_state", 2 );
		self zm_zod_octobomb_quest::player_refresh_quest_hud();
	}

}

// devgui so we can test the Octobomb
// let the player give themselves the magic jar or the octobomb itself
function octobomb_devgui()
{
	AddDebugCommand( "devgui_cmd \"ZM/Zod/Octobomb/Jar/0\" \"zod_give_magic_jar 0\"\n" );
	AddDebugCommand( "devgui_cmd \"ZM/Zod/Octobomb/Jar/1\" \"zod_give_magic_jar 1\"\n" );
	AddDebugCommand( "devgui_cmd \"ZM/Zod/Octobomb/Jar/2\" \"zod_give_magic_jar 2\"\n" );
	AddDebugCommand( "devgui_cmd \"ZM/Zod/Octobomb/Jar/3\" \"zod_give_magic_jar 3\"\n" );
	AddDebugCommand( "devgui_cmd \"ZM/Zod/Octobomb/Jar/Give to All\" \"zod_give_magic_jar 4\"\n" );
	level thread watch_dvar_for_magic_jar();
	
	AddDebugCommand( "devgui_cmd \"ZM/Zod/Octobomb/Bomb/0\" \"zod_give_octobomb 0\"\n" );
	AddDebugCommand( "devgui_cmd \"ZM/Zod/Octobomb/Bomb/1\" \"zod_give_octobomb 1\"\n" );
	AddDebugCommand( "devgui_cmd \"ZM/Zod/Octobomb/Bomb/2\" \"zod_give_octobomb 2\"\n" );
	AddDebugCommand( "devgui_cmd \"ZM/Zod/Octobomb/Bomb/3\" \"zod_give_octobomb 3\"\n" );
	AddDebugCommand( "devgui_cmd \"ZM/Zod/Octobomb/Bomb/Give to All\" \"zod_give_octobomb 4\"\n" );
	level thread watch_dvar_for_octobomb();
}

function watch_dvar_for_magic_jar()
{
	SetDvar( "zod_give_magic_jar", -1 );
	
	while ( true )
	{
		n_val = GetDvarInt( "zod_give_magic_jar" );
		
		if ( ( n_val > -1 ) && ( n_val <= 3 ) ) // player index
		{
			player = GetPlayers()[ n_val ];
			if( isdefined( player ) )
			{
				// give the activating player the octobomb plain jar
				player clientfield::set_to_player( "octobomb_state", 2 );
				player zm_zod_octobomb_quest::player_refresh_quest_hud();
			}
			SetDvar( "zod_give_magic_jar", -1 );
		}
		else if ( n_val > 3 ) // give to all
		{
			a_players = GetPlayers();
			foreach( player in a_players )
			{
				// give the activating player the octobomb plain jar
				player clientfield::set_to_player( "octobomb_state", 2 );
				player zm_zod_octobomb_quest::player_refresh_quest_hud();
			}
			SetDvar( "zod_give_magic_jar", -1 );
		}
		
		wait 0.1;
	}
}

function watch_dvar_for_octobomb()
{
	SetDvar( "zod_give_octobomb", -1 );
	
	while ( true )
	{
		n_val = GetDvarInt( "zod_give_octobomb" );
		
		if ( ( n_val > -1 ) && ( n_val <= 3 ) ) // player index
		{
			player = GetPlayers()[ n_val ];
			if( isdefined( player ) )
			{
				[[ level.octobomb_manager ]]->octobomb_give_to_player( player );
			}
			SetDvar( "zod_give_octobomb", -1 );
		}
		else if ( n_val > 3 ) // give to all
		{
			a_players = GetPlayers();
			foreach( player in a_players )
			{
				[[ level.octobomb_manager ]]->octobomb_give_to_player( player );
			}
			SetDvar( "zod_give_octobomb", -1 );
		}
		
		wait 0.1;
	}
}
