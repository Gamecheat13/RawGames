
    	   	                                                                                                                         	                                                                                                                                                                                                                                                                                                                                                                    	        	     	             	    	   	                           	                               	                                	                                                              	                                                                                                              	                            	                                     	                                       	                                                               	   	                  	       	                                                    	                   	                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                       	                                                                                        	           	                        	                                            	                                             	                                                   	                                                             	                                                         	                                                                    	                                                                                                                                                                                                    	                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                     	                                                              	                                                          	                                   	                                   	                                                    	                                       
                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                            	                                                                                                                                                                                                                                                                                                                                                                                       
                                                                                                                                                                                                                                                                                                                                                                                                                 	                                                                                                                                                                          	                                                                                         	                                                                                                                                                                                                                                                                                                                                                                                                                                        	                                                                                                                               	                                                                                                                                                                                                                                              	                                                                                                                                           	                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                   	                                                                                                                       	   	                                                                                                                                                                                                                                                                                                                         	                                                                                                                                                                                                                                      

#using scripts\codescripts\struct;

#using scripts\shared\array_shared;
#using scripts\shared\callbacks_shared;
#using scripts\shared\clientfield_shared;
#using scripts\shared\flag_shared;
#using scripts\shared\hud_shared;
#using scripts\shared\laststand_shared;
#using scripts\shared\system_shared;
#using scripts\shared\util_shared;

#using scripts\zm\_zm_audio;
#using scripts\zm\_zm_laststand;
#using scripts\zm\_zm_score;
#using scripts\zm\_zm_spawner;
#using scripts\zm\_zm_utility;
#using scripts\shared\ai\zombie_death;
	
                                                                                       	                                
                                                                                                                               

#namespace zm_zod_portals;

#using_animtree( "generic" );

	// When a portal goes off, look for AI in this radius to delay cleanup
	// AI in the area will delay cleanup checks for this long

function autoexec __init__sytem__() {     system::register("zm_zod_portals",&__init__,undefined,undefined);    }

function __init__()
{
	clientfield::register( "world",		"portal_state_canal",		1, 1, "int" );
	clientfield::register( "world",		"portal_state_slums",		1, 1, "int" );
	clientfield::register( "world",		"portal_state_theater",		1, 1, "int" );
}

// activates the top and bottom portals (sets threads on triggers, starts up looping vfx) associated with a district's shortcut
function portal_open( str_id )
{
	// get arrays, b/c we have script_noteworthy on the entire prefab; thread on the teleport trigger
	
	// activate top portal
	a_t_portal_top = GetEntArray( str_id + "_top", "script_noteworthy" );
	foreach( ent in a_t_portal_top )
	{
		if( ent.targetname === "teleport_trigger" )
		{
			ent thread portal_think();
		}
	}
	
	// activate bottom portal
	a_t_portal_bottom = GetEntArray( str_id + "_bottom", "script_noteworthy" );
	foreach( ent in a_t_portal_bottom )
	{
		if( ent.targetname === "teleport_trigger" )
		{
			ent thread portal_think();
		}
	}
	
	str_areaname = return_district_name_from_string( str_id );
	level clientfield::set( "portal_state_" + str_areaname, 1 );
}

function return_district_name_from_string( str_input )
{
	a_str_names = array( "canal", "slums", "theater" );
	foreach( str_name in a_str_names )
	{
		if( IsSubStr( str_input, str_name ) )
		{
			return str_name;
		}
	}
}

function portal_think()
{
	// store the possible locations
	self.a_s_port_locs = struct::get_array( self.target, "targetname" );
	
	while ( true )
	{
		self waittill( "trigger", e_portee );
		
		// Don't allow entities to teleport if they're already in the process/cooling down.
		if ( ( isdefined( e_portee.teleporting ) && e_portee.teleporting ) )
		{
			continue;
		}
		
		if ( IsPlayer( e_portee ) )
		{
			if ( e_portee GetStance() != "prone" )
			{
				// play teleport vfx
				PlayFX( level._effect[ "portal_3p" ], e_portee.origin );
				
				// notify level
				//level notify( "player_teleported", e_player, self.script_int );
			
				// actually teleport player
				self thread portal_teleport_player( e_portee );
			}
		}
		else
		{
			self thread portal_teleport_ai( e_portee );
		}
	}
}

// player: player to teleport
// n_teleport_time_sec: teleport time in seconds.
//
function portal_teleport_player( player, show_fx = true )
{
	player.teleporting = true;

	if ( show_fx )
	{
		player thread hud::fade_to_black_for_x_sec( 0, 0.3, 0, 0.5, "white" );
		util::wait_network_frame();
	}
	
	n_pos = player.characterindex;

	prone_offset = (0, 0, 49);
	crouch_offset = (0, 0, 20);
	stand_offset = (0, 0, 0);

	//	Keep zombies near a portal alive so that they can chase players through it
	a_ai_enemies = GetAITeamArray( "axis" );
	a_ai_enemies = ArraySort( a_ai_enemies, self.origin, true, 99, 768 );	// doesn't like undefined param 4: "must be an int" 
	array::thread_all( a_ai_enemies, &ai_delay_cleanup );
	
	// send players to a black room to flash images for a few seconds
	image_room = struct::get( "teleport_room_" + n_pos, "targetname" );

	player DisableOffhandWeapons();
	player DisableWeapons();
	player FreezeControls( true );
	util::wait_network_frame();
	
	if ( player GetStance() == "prone" )
	{
		desired_origin = image_room.origin + prone_offset;
	}
	else if ( player GetStance() == "crouch" )
	{
		desired_origin = image_room.origin + crouch_offset;
	}
	else
	{
		desired_origin = image_room.origin + stand_offset;
	}
	
	player.teleport_origin = Spawn( "script_model", player.origin );
	player.teleport_origin SetModel( "tag_origin" );
	
	player.teleport_origin.angles = player.angles;
	player PlayerLinkToAbsolute( player.teleport_origin, "tag_origin" );
	player.teleport_origin.origin = desired_origin;
	player.teleport_origin.angles = image_room.angles;
	
	if ( show_fx )
	{
//		player playsoundtoplayer( "zmb_teleporter_tele_2d", player );	
	}
	
	util::wait_network_frame();

	player.teleport_origin.angles = image_room.angles;

	if ( show_fx )
	{
//		image_room thread stargate_play_fx();
	}
	
	wait 2.0;
	
	if ( show_fx )
	{
		player thread hud::fade_to_black_for_x_sec( 0, 0.2, 0, 0.3, "white" );
		util::wait_network_frame();
	}
	
	image_room notify( "stop_teleport_fx" );
	
	// now teleport the player to the actual destination
	// get a free teleport landing position from the set of structs
	
	//TODO Find a free location that is unoccupied by players
	s_pos = array::random( self.a_s_port_locs );

	// play teleport vfx
	PlayFX( level._effect[ "portal_3p" ], s_pos.origin );
	player Unlink();

	if ( IsDefined( player.teleport_origin ) )
	{
		player.teleport_origin Delete();
		player.teleport_origin = undefined;
	}
	
	player SetOrigin( s_pos.origin );
	player SetPlayerAngles( s_pos.angles );
	
	player EnableWeapons();
	player EnableOffhandWeapons();
	player FreezeControls( false );

	player.teleporting = false;
}


//	Prevent ai from getting cleaned up temporarily so they have a chance to run through the portal
//	self is an AI
function ai_delay_cleanup()
{
	self notify( "delay_cleanup" );

	self endon( "death" );
	self endon( "delay_cleanup" );

	self.b_ignore_cleaup = true;	// setting this will cause the cleanup manager to skip over me
	wait 10.0;

	self.b_ignore_cleaup = undefined;
}


//	self is the portal trigger
function portal_teleport_ai( e_portee )
{
	e_portee endon( "death" );

	e_portee.teleporting = true;
	PlayFX( level._effect[ "portal_3p" ], e_portee.origin );
	util::wait_network_frame();

	// teleport zombie  into the portal room
	image_room = struct::get( "teleport_room_zombies", "targetname" ); // all zombies overlap on the same struct in the teleportation room ( players can hear them behind them "in the portal" )
	
	if ( IsActor( e_portee ) )
	{
		e_portee ForceTeleport( image_room.origin, image_room.angles );
	}
	else
	{
		e_portee.origin = image_room.origin;
		e_portee.angles = image_room.angles;
	}
	
	// wait same duration as the player
	wait 2.0;

	// teleport zombie to the teleport destination
	s_port_loc = array::random( self.a_s_port_locs );
	
	if ( IsActor( e_portee ) )
	{
		e_portee ForceTeleport( s_port_loc.origin, s_port_loc.angles );
	}
	else
	{
		e_portee.origin = s_port_loc.origin;
		e_portee.angles = s_port_loc.angles;
	}

	PlayFX( level._effect[ "portal_3p" ], s_port_loc.origin );
	wait 1;
	
	e_portee.teleporting = false;
}