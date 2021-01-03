#using scripts\codescripts\struct;

#using scripts\shared\ai_shared;
#using scripts\shared\array_shared;
#using scripts\shared\flag_shared;
#using scripts\shared\system_shared;
#using scripts\shared\trigger_shared;
#using scripts\shared\spawner_shared;
#using scripts\shared\util_shared;

    	   	                                                                                                                                         	                                	                                                                                                                                                                                                                                                                                                                                                                    	        	     	             	    	   	               	                                              	                                                           	                               	                     	                                                                                                           	                                                                 	                                                              	                                                                                                              	                            	                                     	                                       	                                                                                                              	   	                  	       	                                                    	                   	                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                        	                                  	                                                                                        	           	                        	                                            	                                             	                                                   	                                                             	                                                         	                                                                    	                                                                                                                                                                                                    	                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                         	                                                              	                                                          	                                   	                                   	                                                    	                                       	                                           	     	                                                                                                                                                                                                                                                      	                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                     




#namespace colors;

/*
	Color coded AI travel system
	A colorCode is a color( red, blue, yellow, cyan, green, purple or orange ) and a #.
	When a trigger and AI and node are color grouped in Radiant, they get a unique color and #.
	When when a color coded trigger is hit, that colorCode is "fired" and any AI that are in colorCoded mode get their goalnode set.

	AI can be forced to a color generically. For example if an AI is forced to the color "red" and a trigger fires off "red15", the AI
	will go to that node even if the AI doesn't have script_color_allies( or axis ) "red15". This is mainly for friendlies.
	
	AI can also have their script_careful variable set, which prevents them from advancing to a node or a volume if an enemy is occupying it.
	They will move up if the zone is cleared.
	
	Volumes can also be tagged with a code and a number like r6. So if an enemy is present in this volume, no AI will run to any node tagged r6.
*/

function autoexec __init__sytem__() {     system::register("colors",&__init__,&__main__,undefined);    }

function __init__()
{
	nodes = GetAllNodes();
	
	// friendly spawner global stuff
	level flag::init( "player_looks_away_from_spawner" );
	level flag::init( "friendly_spawner_locked" );
	
	// can be turned on and off to control friendly_respawn_trigger
	level flag::init( "respawn_friendlies" );	
	
	level.arrays_of_colorCoded_nodes = [];
	level.arrays_of_colorCoded_nodes[ "axis" ] = [];
	level.arrays_of_colorCoded_nodes[ "allies" ] = [];

	level.colorCoded_volumes = [];
	level.colorCoded_volumes[ "axis" ] = [];
	level.colorCoded_volumes[ "allies" ] = [];

	volumes = GetEntArray( "info_volume", "classname" );

	// go through all the nodes and if they have color codes then add them too
	for( i=0;i<nodes.size;i++ )
	{
		if( IsDefined( nodes[ i ].script_color_allies ) )
		{
			nodes[ i ] add_node_to_global_arrays( nodes[ i ].script_color_allies, "allies" );
		}

		if( IsDefined( nodes[ i ].script_color_axis ) )
		{
			nodes[ i ] add_node_to_global_arrays( nodes[ i ].script_color_axis, "axis" );
		}		
	}
	
	// volumes that have color codes wait for trigger and then fire their colorcode to control fixednodesafe volumes
	for( i=0;i<volumes.size;i++ )
	{
		if( IsDefined( volumes[ i ].script_color_allies ) )
		{
			volumes[ i ] add_volume_to_global_arrays( volumes[ i ].script_color_allies, "allies" );
		}
		
		if( IsDefined( volumes[ i ].script_color_axis ) )
		{
			volumes[ i ] add_volume_to_global_arrays( volumes[ i ].script_color_axis, "axis" );
		}
	}
	
	/#
		level.colorNodes_debug_array = [];
		level.colorNodes_debug_array[ "allies" ] = [];
		level.colorNodes_debug_array[ "axis" ] = [];	

	#/

	level.color_node_type_function = [];

	add_cover_node( "BAD NODE" );
	add_cover_node( "Cover Stand" );
	add_cover_node( "Cover Crouch" );
	add_cover_node( "Cover Prone" );
	add_cover_node( "Cover Crouch Window" );
	add_cover_node( "Cover Right" );
	add_cover_node( "Cover Left" );
	add_cover_node( "Cover Wide Left" );
	add_cover_node( "Cover Wide Right" );
	add_cover_node( "Cover Pillar" );
	add_cover_node( "Conceal Stand" );
	add_cover_node( "Conceal Crouch" );
	add_cover_node( "Conceal Prone" );
	add_cover_node( "Reacquire" );
	add_cover_node( "Balcony" );
	add_cover_node( "Scripted" );
	add_cover_node( "Begin" );
	add_cover_node( "End" );
	add_cover_node( "Turret" );
	add_path_node( "Guard" );
	add_path_node( "Exposed" );
	add_path_node( "Path" );
	
	level.colorList = [];
	level.colorList[ level.colorList.size ] = "r";
	level.colorList[ level.colorList.size ] = "b";
	level.colorList[ level.colorList.size ] = "y";
	level.colorList[ level.colorList.size ] = "c";
	level.colorList[ level.colorList.size ] = "g";
	level.colorList[ level.colorList.size ] = "p";
	level.colorList[ level.colorList.size ] = "o";
	
	level.colorCheckList[ "red" ] 	= "r";
	level.colorCheckList[ "r" ] 	= "r";
	level.colorCheckList[ "blue" ] 	= "b";
	level.colorCheckList[ "b" ] 	= "b";
	level.colorCheckList[ "yellow" ]= "y";
	level.colorCheckList[ "y" ] 	= "y";
	level.colorCheckList[ "cyan" ] 	= "c";
	level.colorCheckList[ "c" ] 	= "c";
	level.colorCheckList[ "green" ] = "g";
	level.colorCheckList[ "g" ] 	= "g";
	level.colorCheckList[ "purple" ]= "p";
	level.colorCheckList[ "p" ] 	= "p";
	level.colorCheckList[ "orange" ]= "o";
	level.colorCheckList[ "o" ] 	= "o";

	level.currentColorForced = [];
	level.currentColorForced[ "allies" ] = [];
	level.currentColorForced[ "axis" ] = [];

	level.lastColorForced = [];
	level.lastColorForced[ "allies" ] = [];
	level.lastColorForced[ "axis" ] = [];

	for( i = 0; i < level.colorList.size; i++ )
	{
		level.arrays_of_colorForced_ai[ "allies" ][ level.colorList[ i ] ] = [];
		level.arrays_of_colorForced_ai[ "axis" ][ level.colorList[ i ] ] = [];
		level.currentColorForced[ "allies" ][ level.colorList[ i ] ] = undefined;
		level.currentColorForced[ "axis" ][ level.colorList[ i ] ] = undefined;
	}
	
	/#
		thread debugDvars();
		thread debugColorFriendlies();
	#/
}

function __main__()
{
	foreach ( trig in trigger::get_all() )
	{
		if ( isdefined( trig.script_color_allies ) )
		{
			trig thread trigger_issues_orders( trig.script_color_allies, "allies" );
		}

		if ( isdefined( trig.script_color_axis ) )
		{
			trig thread trigger_issues_orders( trig.script_color_axis, "axis" );
		}
	}
}

//////////////////////////////////////////////////////////////////////////////////////////////////////////////////
/////////////////////////////////////////	DEBUG	//////////////////////////////////////////////////////////////
//////////////////////////////////////////////////////////////////////////////////////////////////////////////////

/#
function debugDvars()
{
	if ( GetDvarString( "debug_colornodes" ) == "" )
	{
		SetDvar( "debug_colornodes", "0" );
	}
	
	while ( true )
	{
		if ( GetDvarInt( "debug_colornodes" ) > 0 )
		{
			thread debug_colornodes();
		}
		
		wait .05;
	}
}
function get_team_substr()
{
	if( self.team == "allies" )
	{
		if( !isdefined( self.node.script_color_allies_old ) )
		{
			return;
		}
			
		return self.node.script_color_allies_old;
	}
	
	if( self.team == "axis" )
	{
		if( !isdefined( self.node.script_color_axis_old ) )
		{
			return;
		}
			
		return self.node.script_color_axis_old;
	}
}
function try_to_draw_line_to_node()
{
	if( !isdefined( self.node ) )
	{
		return;
	}
		
	if( !isdefined( self.script_forceColor ) )
	{
		return;
	}
	
	substr = get_team_substr();
	if( !isdefined( substr ) )
	{
		return;
	}
		
	if( !issubstr( substr, self.script_forceColor ) )
	{
		return;
	}
	
	RecordLine( self.origin +( 0, 0, 25 ), self.node.origin, _get_debug_color( self.script_forceColor ), "Script", self );
	line( self.origin +( 0, 0, 25 ), self.node.origin, _get_debug_color( self.script_forceColor ) );
}

function _get_debug_color( str_color )
{
	switch( str_color )
	{
		case "r":
		case "red":
			return ( 1, 0, 0 );
			break;
			
		case "g":
		case "green":
			return ( 0, 1, 0 );
			break;
			
		case "b":
		case "blue":
			return ( 0, 0, 1 );
			break;
			
		case "y":
		case "yellow":
			return ( 1, 1, 0 );	
			break;
			
		case "o":
		case "orange":
			return ( 1, .5, 0 );
			break;
			
		case "c":
		case "cyan":
			return ( 0, 1, 1 );
			break;
			
		case "p":
		case "purple":
			return ( 1, 0, 1 );
			break;

		default:
			PrintLn( "Debug color " + str_color + " not set in debug::_get_debug_color(). Please add this color." );
			return ( 0, 0, 0 );
			break;
	}
}

function debug_colornodes()
{
	array = [];
	array[ "axis" ] = [];
	array[ "allies" ] = [];
	array[ "neutral" ] = [];
	
	foreach ( ai in GetAIArray() )
	{
		if ( !isdefined( ai.currentColorCode ) )
		{
			continue;
		}
			
		array[ ai.team ][ ai.currentColorCode ] = true;
		
		color = ( 1, 1, 1 );

		if ( isdefined( ai.script_forceColor ) )
		{
			color = _get_debug_color( ai.script_forceColor );
		}
		
		RecordEntText( ai.currentColorCode, ai, color, "Script");
		Print3d( ai.origin + ( 0, 0, 25 ), ai.currentColorCode, color, 1, 0.7 );

		// axis don't do forcecolor behavior, they do follow the leader for force color
		if ( ai.team == "axis" )
		{
			continue;
		}
		
		ai try_to_draw_line_to_node();
	}
	
	draw_colorNodes( array, "allies" );
	draw_colorNodes( array, "axis" );
}

function draw_colorNodes( array, team )
{
	keys = GetArrayKeys( array[ team ] );
	for ( i = 0; i < keys.size; i++ )
	{
		color = _get_debug_color( GetSubStr( keys[ i ], 0, 1 ) );
	
		if ( isdefined( level.colorNodes_debug_array[ team ][ keys[ i ] ] ) )
		{
			a_team_nodes = level.colorNodes_debug_array[ team ][ keys[ i ] ];
	
			for ( p = 0; p < a_team_nodes.size; p++ )
			{
				// there can be multiple colors on the nodes, avoid drawing them on top of each other.
				Print3d( a_team_nodes[ p ].origin, "N-" + keys[ i ], color, 1, 0.7 );
				
				if ( GetDvarString( "debug_colornodes" ) == "2" && isdefined( a_team_nodes[ p ].script_color_allies_old ) )
				{
					if ( isdefined( a_team_nodes[ p ].color_user ) 
						&& IsAlive( a_team_nodes[ p ].color_user )
						&& isdefined( a_team_nodes[ p ].color_user.script_forceColor ) 
						)
					{
						print3d( a_team_nodes[ p ].origin + ( 0, 0, -5 ), "N-" + a_team_nodes[ p ].script_color_allies_old, _get_debug_color( a_team_nodes[ p ].color_user.script_forceColor ), 0.5, 0.4 );
					}
					else
					{
						print3d( a_team_nodes[ p ].origin + ( 0, 0, -5 ), "N-" + a_team_nodes[ p ].script_color_allies_old, color, 0.5, 0.4 );
					}
				}
			}
		}
	}
}

function debugColorFriendlies()
{
	level.debug_color_friendlies = [];
	level.debug_color_huds = [];
	
	level thread debugColorFriendliesToggleWatch();
	
	for( ;; )
	{
		level waittill( "updated_color_friendlies" );
		draw_color_friendlies();
	}
}

function debugColorFriendliesToggleWatch()
{
	just_turned_on = false;
	just_turned_off = false;
	
	while( 1 )
	{
		
		if( GetDvarString( "debug_colornodes" ) == "1" && !just_turned_on )
		{
			just_turned_on = true;
			just_turned_off = false;
			draw_color_friendlies();
		}
		if( GetDvarString( "debug_colornodes" ) != "1" && !just_turned_off )
		{
			just_turned_off = true;
			just_turned_on = false;
			draw_color_friendlies();			
		}
		
		wait( 0.25 );
		
	}
}

function get_script_palette()
{
	rgb = [];
	rgb[ "r" ] = ( 1, 0, 0 );
	rgb[ "o" ] = ( 1, .5, 0 );
	rgb[ "y" ] = ( 1, 1, 0 );
	rgb[ "g" ] = ( 0, 1, 0 );
	rgb[ "c" ] = ( 0, 1, 1 );
	rgb[ "b" ] = ( 0, 0, 1 );
	rgb[ "p" ] = ( 1, 0, 1 );
	return rgb;
}


function draw_color_friendlies()
{
	level endon( "updated_color_friendlies" );
	keys = getarraykeys( level.debug_color_friendlies );
	
	colored_friendlies = [];
	colors = [];
	colors[ colors.size ] = "r";
	colors[ colors.size ] = "o";
	colors[ colors.size ] = "y";
	colors[ colors.size ] = "g";
	colors[ colors.size ] = "c";
	colors[ colors.size ] = "b";
	colors[ colors.size ] = "p";
	
	rgb = colors::get_script_palette();
	

	for( i=0; i < colors.size; i++ )
	{
		colored_friendlies[ colors[ i ] ] = 0;
	}

	for( i=0; i < keys.size; i++ )
	{
		color = level.debug_color_friendlies[ keys[ i ] ];
		colored_friendlies[ color ]++;
	}
	
	for( i=0; i < level.debug_color_huds.size; i++ )
	{
		level.debug_color_huds[ i ] destroy();
	}
	level.debug_color_huds = [];

	if( GetDvarString( "debug_colornodes" ) != "1" )
	{
		return;
	}
		
	const x = 15;
	y = 365;
	const offset_y = 25;
	for( i=0; i < colors.size; i++ )
	{
		if( colored_friendlies[ colors[ i ] ] <= 0 )
		{
			continue;
		}
		for( p=0; p < colored_friendlies[ colors[ i ] ]; p++ )
		{
			overlay = newHudElem();
			overlay.x = x + 25*p;
			overlay.y = y;
			overlay setshader( "white", 16, 16 );
			overlay.alignX = "left";
			overlay.alignY = "bottom";
			overlay.alpha = 1;
			overlay.color = rgb[ colors[ i ] ];
			level.debug_color_huds[ level.debug_color_huds.size ] = overlay;
		}
		
		y += offset_y;
	}
}
#/

function player_init_color_grouping( )
{
	thread player_color_node();
}

function convert_color_to_short_string()
{
	// shorten the forcecolors string to a single letter
	self.script_forceColor = level.colorCheckList[ self.script_forceColor ];
}

function goto_current_ColorIndex()
{
	if( !IsDefined( self.currentColorCode ) )
	{
		return;
	}
	
	nodes = level.arrays_of_colorCoded_nodes[ self.team ][ self.currentColorCode ];
	if ( !isdefined( nodes ) ) nodes = []; else if ( !IsArray( nodes ) ) nodes = array( nodes ); nodes[nodes.size]=level.colorCoded_volumes[ self.team ][ self.currentColorCode ];;
	
	self left_color_node();
	// can be deleted/killed during left_color_node
	if( !isalive( self ) )
	{
		return;
	}
	
	// can lose color during left_color_node
	if( !has_color() )
	{
		return;
	}
	
	
	for( i=0; i <nodes.size; i++ )
	{
		node = nodes[ i ];
		if ( isalive( node.color_user ) && !IsPlayer(node.color_user) )
		{
			continue;
		}
			
		self thread ai_sets_goal_with_delay( node );
			
		thread decrementColorUsers( node );
		return;
	}

	/#println( "AI with export " + self.export + " was told to go to color node but had no node to go to." );#/
}


function get_color_list()
{
	colorList = [];
	// returns an array of the acceptable color letters
	colorList[ colorList.size ] = "r";
	colorList[ colorList.size ] = "b";
	colorList[ colorList.size ] = "y";
	colorList[ colorList.size ] = "c";
	colorList[ colorList.size ] = "g";
	colorList[ colorList.size ] = "p";
	colorList[ colorList.size ] = "o";
	
	return colorList;
}

function get_colorcodes_from_trigger( color_team, team )
{
	colorCodes = strtok( color_team, " " );
	colors = [];
	colorCodesByColorIndex = [];
	usable_colorCodes = [];
	
	colorList = get_color_list();
	
	for( i = 0; i < colorCodes.size; i++ )
	{
		color = undefined;
		for( p = 0; p < colorList.size; p++ )
		{
			if( issubstr( colorCodes[ i ], colorList[ p ] ) )
			{
				color = colorList[ p ];
				break;
			}
		}

		// does this order actually tie to existing nodes?
		if( !IsDefined( level.arrays_of_colorCoded_nodes[ team ][ colorCodes[ i ] ] ) 
		    && !IsDefined( level.colorCoded_volumes[ team ][ colorCodes[ i ] ] ) 
		  )
		{
			continue;
		}
		
		
		
		assert( IsDefined( color ), "Trigger at origin " + self getorigin() + " had strange color index " + colorCodes[ i ] );
		
		colorCodesByColorIndex[ color ] = colorCodes[ i ];
		colors[ colors.size ] = color;
		usable_colorCodes[ usable_colorCodes.size ] = colorCodes[ i ];
	}
	
	// color codes that don't tie to existing nodes have been culled
	colorCodes = usable_colorCodes;
	
	array = [];
	array[ "colorCodes" ] = colorCodes;
	array[ "colorCodesByColorIndex" ] = colorCodesByColorIndex;
	array[ "colors" ] = colors;
	return array;	
}	

function trigger_issues_orders( color_team, team )
{
	self endon( "death" );

	array = get_colorcodes_from_trigger( color_team, team );
	colorCodes = array[ "colorCodes" ];
	colorCodesByColorIndex = array[ "colorCodesByColorIndex" ];
	colors = array[ "colors" ];
	
	if ( isdefined( self.target ) )
	{
		a_s_targets = struct::get_array( self.target, "targetname" );
		foreach( s_target in a_s_targets )
		{
			if ( ( s_target.script_string === "hero_catch_up" ) )
			{
				if(!isdefined(self.a_s_hero_catch_up))self.a_s_hero_catch_up=[];
				if ( !isdefined( self.a_s_hero_catch_up ) ) self.a_s_hero_catch_up = []; else if ( !IsArray( self.a_s_hero_catch_up ) ) self.a_s_hero_catch_up = array( self.a_s_hero_catch_up ); self.a_s_hero_catch_up[self.a_s_hero_catch_up.size]=s_target;;
				if( isdefined( s_target.script_num ) )//Check struct for distance override
				{
					self.num_hero_catch_up_dist = s_target.script_num;
				}
			}
		}
	}	
	
	for( ;; )
	{
		self waittill( "trigger" );
			
		if( IsDefined( self.activated_color_trigger ) )
		{
			// activated by an _utility::activate_trigger() call, so don't bother running activate_color_trigger() again.
			self.activated_color_trigger = undefined;
			continue;
		}
		
		if( !IsDefined( self.color_enabled ) || ( IsDefined( self.color_enabled ) && self.color_enabled ) )
		{
			activate_color_trigger_internal( colorCodes, colors, team, colorCodesByColorIndex );
		}

		trigger_auto_disable();
	}
}

function trigger_auto_disable()
{
	if( !IsDefined( self.script_color_stay_on ) )
	{
		self.script_color_stay_on = false;
	}

	if( !IsDefined( self.color_enabled ) )
	{
		if( ( isdefined( self.script_color_stay_on ) && self.script_color_stay_on ) )
		{
			self.color_enabled = true;
		}
		else
		{
			self.color_enabled = false;
		}
	}
}		

function activate_color_trigger( team )
{
	if ( team == "allies" )
	{
		self thread get_colorcodes_and_activate_trigger( self.script_color_allies, team );
	}
	else
	{
		self thread get_colorcodes_and_activate_trigger( self.script_color_axis, team );
	}
}

function get_colorcodes_and_activate_trigger( color_team, team )
{
	array = get_colorcodes_from_trigger( color_team, team );
	colorCodes = array[ "colorCodes" ];
	colorCodesByColorIndex = array[ "colorCodesByColorIndex" ];
	colors = array[ "colors" ];

	activate_color_trigger_internal( colorCodes, colors, team, colorCodesByColorIndex );
}

function private is_target_visible( target )
{
	n_player_fov = GetDvarFloat( "cg_fov" );
	n_dot_check = cos( n_player_fov );
	
	v_pos = target;
	if ( !IsVec( target ) )
	{
		v_pos = target.origin;
	}
	
	foreach ( player in level.players )
	{		
		v_eye = player GetEye();
		v_facing = AnglesToForward( player GetPlayerAngles() );
		v_to_ent = VectorNormalize( v_pos - v_eye );
		n_dot = VectorDot( v_facing, v_to_ent );
		
		if ( n_dot > n_dot_check )
		{
			return true;
		}
		else if ( IsVec( target ) )
		{
			a_trace = BulletTrace( v_eye, target, false, player );
			if ( a_trace["fraction"] == 1 )
			{
				return true;
			}
		}
		else if ( target SightConeTrace( v_eye, player ) != 0 )
		{
			return true;
		}
	}
	
	return false;
}

// Teleports a hero once it's safe to do so (no telefragging, no player visibility)."
//
// Will bail if one of the teleport points is further from the goal than the hero.
//
function private hero_catch_up_teleport( s_teleport, n_min_dist_from_player = 400.0 )
{
	self notify( "hero_catch_up_teleport" );
	self endon( "hero_catch_up_teleport" );
	
	const n_telefrag_radius = 16.0;
	const n_teleport_cooldown_ms = 2000;
	
	n_min_player_dist_sq = n_min_dist_from_player * n_min_dist_from_player;
	
	self endon( "death" );
	
	a_teleport = s_teleport;
	if ( !isdefined( a_teleport ) ) a_teleport = []; else if ( !IsArray( a_teleport ) ) a_teleport = array( a_teleport );;
	a_teleport = array::randomize( a_teleport );
	
	while ( true )
	{
		b_player_nearby = false;
		foreach( player in level.players )
		{
			if ( DistanceSquared( player.origin, self.origin ) < n_min_player_dist_sq )
			{
				b_player_nearby = true;
				break;
			}
		}
		
		if ( !b_player_nearby )
		{
			n_ai_dist = -1.0;
			if ( isdefined( self.goal ) )
			{
				n_ai_dist = self CalcPathLength( self.node );
			}
			
			foreach( s in a_teleport )
			{
				if ( PositionWouldTelefrag( s.origin ) )
				{
					continue;
				}
				
				if ( isdefined( s.teleport_cooldown ) )
				{
					if ( GetTime() < s.teleport_cooldown )
					{
						continue;
					}
				}
				
				// Don't teleport on top of heroes.
				//
				if ( self.team == "allies" && isdefined( level.heroes ) )
				{
					hit_hero = ArrayGetClosest( s.origin, level.heroes, n_telefrag_radius );
					if ( isdefined( hit_hero ) )
					{
						continue;
					}
				}
				
				// Distance from teleport location to the goal node.
				if ( isdefined( self.node ) && n_ai_dist >= 0.0 )
				{
					// If the teleport position would put us further from our goal, we're close enough.
					n_teleport_distance = PathDistance( s.origin, self.node.origin );
					if ( n_teleport_distance > n_ai_dist )
					{
						return;
					}
				}
				
				// Don't teleport if someone's looking at them.
				//
				if ( is_target_visible( self ) )
				{
					continue;
				}
				
				// Don't teleport if someone's looking at the destination.
				//
				if ( is_target_visible( s.origin ) )
				{
					continue;
				}
				
				if ( isdefined( self.script_forceColor ) && self ForceTeleport( s.origin, s.angles, true , true ) )
				{
					s.teleport_cooldown = GetTime() + n_teleport_cooldown_ms;
					self colors::set_force_color( self.script_forceColor );
					return;
				}
			}
		}
		else
		{
			return;//A player is close, no need to keep checking
		}
		
		// Try again soon.
		wait 0.5;
	}
}


function activate_color_trigger_internal( colorCodes, colors, team, colorCodesByColorIndex )
{
	// remove all the dead from any colors this trigger effects
	// a trigger should never effect the same color twice
	for( i = 0; i < colorCodes.size; i++ )
	{
		if( !IsDefined( level.arrays_of_colorCoded_spawners[ team ][ colorCodes[ i ] ] ) )
		{
			continue;
		}

		// remove deleted spawners
		ArrayRemoveValue( level.arrays_of_colorCoded_spawners[ team ][ colorCodes[ i ] ], undefined );

		// set the .currentColorCode on each appropriate spawner
		for( p = 0; p < level.arrays_of_colorCoded_spawners[ team ][ colorCodes[ i ] ].size; p++ )
		{
			level.arrays_of_colorCoded_spawners[ team ][ colorCodes[ i ] ][ p ].currentColorCode = colorCodes[ i ];
		}
	}

	for( i = 0; i < colors.size; i++ )
	{
		// remove the dead from the color forced ai
		level.arrays_of_colorForced_ai[ team ][ colors[ i ] ] = array::remove_dead( level.arrays_of_colorForced_ai[ team ][ colors[ i ] ] );
		
		// set the last color forced so we can compare it with current when we tell guys to go to nodes, 
		// so they can prefer new nodes over old ones, so they move up
		level.lastColorForced[ team ][ colors[ i ] ] = level.currentColorForced[ team ][ colors[ i ] ];

		// set the destination of the color forced spawners
		level.currentColorForced[ team ][ colors[ i ] ] = colorCodesByColorIndex[ colors[ i ] ];

		/#
		assert( IsDefined( level.arrays_of_colorCoded_nodes[ team ][ level.currentColorForced[ team ][ colors[ i ] ] ] )
			   || IsDefined( level.colorCoded_volumes[ team ][ level.currentColorForced[ team ][ colors[ i ] ] ] ),
		"Trigger tried to set colorCode " + colors[ i ] + " but there are no nodes for " + team + " that use that color combo." );
		#/
	}
	
	ai_array = [];
	
	for ( i = 0; i < colorCodes.size; i++ )
	{
		// no need to run this again if it's still the current forced color
		if ( same_color_code_as_last_time( team, colors[ i ] ) )
		{
			continue;
		}

		colorCode = colorCodes[ i ];
			
		if ( !IsDefined( level.arrays_of_colorCoded_ai[ team ][ colorCode ] ) )
		{
			continue;
		}
			
		ai_array[ colorCode ] = issue_leave_node_order_to_ai_and_get_ai( colorCode, colors[ i ], team );
		
		if ( isdefined( self.a_s_hero_catch_up ) && ai_array.size > 0 )
		{
			if( isdefined( ai_array[ colorCode ] ) )
			{
				for ( j = 0; j < ai_array[ colorCode ].size; j++ )
				{
					ai = ai_array[ colorCode ][ j ];
					if ( ( isdefined( ai.is_hero ) && ai.is_hero ) && IsDefined( ai.script_forceColor ) )
					{
						ai thread hero_catch_up_teleport( self.a_s_hero_catch_up );
					}
				}
			}
		}
	}
	
	for( i = 0; i < colorCodes.size; i++ )
	{
		colorCode = colorCodes[ i ];
		if ( !IsDefined( ai_array[ colorCode ] ) )
		{
			continue;
		}
			
		// no need to run this again if it's still the current forced color
		if( same_color_code_as_last_time( team, colors[ i ] ) )
		{
			continue;
		}			

		if ( !IsDefined( level.arrays_of_colorCoded_ai[ team ][ colorCode ] ) )
		{
			continue;
		}

		issue_color_order_to_ai( colorCode, colors[ i ], team, ai_array[ colorCode ] );
	}
}

function same_color_code_as_last_time( team, color )
{
	if( !IsDefined( level.lastColorForced[ team ][ color ] ) )
	{
		return false;
	}
		
	return level.lastColorForced[ team ][ color ] == level.currentColorForced[ team ][ color ];
}


function process_cover_node_with_last_in_mind_allies( node, lastColor )
{
	// nodes that were in the last color order go at the end
	if( issubstr( node.script_color_allies, lastColor ) )
	{
		self.cover_nodes_last[ self.cover_nodes_last.size ] = node;
	}
	else
	{
		self.cover_nodes_first[ self.cover_nodes_first.size ] = node;
	}
}

function process_cover_node_with_last_in_mind_axis( node, lastColor )
{
	// nodes that were in the last color order go at the end
	if( issubstr( node.script_color_axis, lastColor ) )
	{
		self.cover_nodes_last[ self.cover_nodes_last.size ] = node;
	}
	else
	{
		self.cover_nodes_first[ self.cover_nodes_first.size ] = node;
	}
}

function process_cover_node( node, null )
{
	self.cover_nodes_first[ self.cover_nodes_first.size ] = node;
}

function process_path_node( node, null )
{
	self.path_nodes[ self.path_nodes.size ] = node;
}

function prioritize_colorCoded_nodes( team, colorCode, color )
{
	nodes = level.arrays_of_colorCoded_nodes[ team ][ colorCode ];

	// need a place to store the nodes externally so we can put the pathnodes in the back
	ent = spawnstruct();
	ent.path_nodes = [];
	ent.cover_nodes_first = [];
	ent.cover_nodes_last = [];

	lastColorForced_exists = IsDefined( level.lastColorForced[ team ][ color ] );

	// fills ent.path_nodes or .cover_nodes depending on node type	
	for( i=0 ; i < nodes.size; i++ )
	{
		node = nodes[ i ];
		ent [ [ level.color_node_type_function[ node.type ][ lastColorForced_exists ][ team ] ] ]( node, level.lastColorForced[ team ][ color ] );
	}
	
	ent.cover_nodes_first = array::randomize( ent.cover_nodes_first );
	nodes = ent.cover_nodes_first;
	
	// put the path nodes at the end of the array so they're less favored
	for( i=0; i < ent.cover_nodes_last.size; i++ )
	{
		nodes[ nodes.size ] = ent.cover_nodes_last[ i ];
	}

	for( i=0; i < ent.path_nodes.size; i++ )
	{
		nodes[ nodes.size ] = ent.path_nodes[ i ];
	}

	level.arrays_of_colorCoded_nodes[ team ][ colorCode ] = nodes;
}

function get_prioritized_colorCoded_nodes( team, colorCode, color )
{
	if ( IsDefined( level.arrays_of_colorCoded_nodes[ team ][ colorCode ] ) )
	    return level.arrays_of_colorCoded_nodes[ team ][ colorCode ];
	    
	if ( IsDefined( level.colorCoded_volumes[ team ][ colorCode ] ) )
	    return level.colorCoded_volumes[ team ][ colorCode ];
}

function issue_leave_node_order_to_ai_and_get_ai( colorCode, color, team )
{
	// remove dead from this specific colorCode
	level.arrays_of_colorCoded_ai[ team ][ colorCode ] = array::remove_dead( level.arrays_of_colorCoded_ai[ team ][ colorCode ] );
	ai = level.arrays_of_colorCoded_ai[ team ][ colorCode ];
	ai = ArrayCombine( ai, level.arrays_of_colorForced_ai[ team ][ color ], true, false );
	newArray = [];
	for( i=0;i<ai.size;i++ )
	{
		// ignore AI that are already going to this colorCode
		if( IsDefined( ai[ i ].currentColorCode ) && ai[ i ].currentColorCode == colorCode )
		{
			continue;
		}
		newArray[ newArray.size ] = ai[ i ];
	}

	ai = newArray;
	if( !ai.size )
	{
		return;
	}

	for( i=0; i < ai.size; i++ )
	{
		ai[ i ] left_color_node();
	}

	return ai;
}

function issue_color_order_to_ai( colorCode, color, team, ai )
{
	original_ai_array = ai;

	prioritize_colorCoded_nodes( team, colorCode, color );
	nodes = get_prioritized_colorCoded_nodes( team, colorCode, color );
	
	/#
	level.colorNodes_debug_array[ team ][ colorCode ] = nodes;
	#/
	
	/#
	if( nodes.size < ai.size )
	{
		println( "^3Warning, ColorNumber system tried to make " + ai.size + " AI go to " + nodes.size + " nodes." );
	}
	#/

	counter = 0;
	ai_count = ai.size;
	for( i=0; i < nodes.size; i++ )
	{
		node = nodes[ i ];
		// add guys to the nodes with the fewest AI on them
		if( isalive( node.color_user ) )
		{
			continue;
		}

		closestAI = ArraySort( ai, node.origin, true, 1 )[0];
		assert( isalive( closestAI ) );
		ArrayRemoveValue( ai, closestAI );

		closestAI take_color_node( node, colorCode, self, counter );
		counter++;

		if( !ai.size )
		{
			return;
		}
	}
}

function take_color_node( node, colorCode, trigger, counter )
{
	self notify( "stop_color_move" );
	self.script_careful = true;
	self.currentColorCode = colorCode;
	self thread process_color_order_to_ai( node, trigger, counter );
}

function player_color_node()
{
	// detect if the player gets a node and set its .color_user
	for( ;; )
	{
		playerNode = undefined;
		if( !IsDefined( self.node ) )
		{
			{wait(.05);};
			continue;
		}

		olduser = self.node.color_user;
		
		playerNode = self.node;
		playerNode.color_user = self;
				
		for( ;; )
		{
			if( !IsDefined( self.node ) )
			{
				break;
			}
			if( self.node != playerNode )
			{
				break;
			}
			{wait(.05);};
		}
		
		playerNode.color_user = undefined;
		
		playerNode color_node_finds_a_user();
	}
}

function color_node_finds_a_user()
{
	if ( IsDefined( self.script_color_allies ) )
	{
		color_node_finds_user_from_colorcodes( self.script_color_allies, "allies" );
	}

	if ( IsDefined( self.script_color_axis ) )
	{
		color_node_finds_user_from_colorcodes( self.script_color_axis, "axis" );
	}
}

function color_node_finds_user_from_colorcodes( colorCodeString, team )
{
	if ( IsDefined( self.color_user ) )
	{
		// If we successfully found a guy for this node then we shouldnt go find another
		return;
	}
	
	colorCodes = strtok( colorCodeString, " " );
	array::thread_all_ents( colorCodes,&color_node_finds_user_for_colorCode, team );
}

function color_node_finds_user_for_colorCode( colorCode, team )
{
	color = colorCode[ 0 ];
	assert( colorIsLegit( color ), "Color " + color + " is not legit" );

	if ( !IsDefined( level.currentColorForced[ team ][ color ] ) )
	{
		// AI of this color are not assigned to a colornode currently
		return;
	}
	
	if ( level.currentColorForced[ team ][ color ] != colorCode )
	{
		// AI of this color are not currently assigned to our colorCode
		return;
	}
	
	ai = get_force_color_guys( team, color );
	if ( !ai.size )
	{
		return;
	}

	for ( i = 0; i < ai.size; i++ )
	{
		guy = ai[ i ];
		if ( guy occupies_colorCode( colorCode ) )
		{
			continue;
		}

		// found a guy that should use this node, so assign and get out		
		guy take_color_node( self, colorCode );
		return;
	}
}

function occupies_colorCode( colorCode )
{
	if ( !IsDefined( self.currentColorCode ) )
	{
		return false;
	}
		
	return self.currentColorCode == colorCode;
}

function ai_sets_goal_with_delay( node )
{
	self endon( "death" );
	delay = my_current_node_delays();
	if ( delay )
	{
		wait( delay );
	}
	ai_sets_goal( node );
}

function ai_sets_goal( node )
{
	// makes AI stop trying to run to their chain of nodes in _spawner go_to_node
	self notify( "stop_going_to_node" );
	
	set_goal_and_volume( node );
	volume = level.colorCoded_volumes[ self.team ][ self.currentColorCode ];
	
	// SUMEET TODO - Do we need support for careful logic anymore?
	//if ( IS_TRUE( self.script_careful ) )
	//{
	//	thread careful_logic( node, volume );
	//}
}

function set_goal_and_volume( node )
{
	if ( IsDefined( self._colors_go_line ) )
	{
		self notify( "colors_go_line_done" );
		self._colors_go_line = undefined;
	}

	if( ( isdefined( node.radius ) && node.radius ) )
	{
		self.goalradius = node.radius;
	}
	
	if ( ( isdefined( node.script_forcegoal ) && node.script_forcegoal ) )
	{
		self thread color_force_goal(node);
	}
	else
	{
		self SetGoal( node );
	}
	
	volume = level.colorCoded_volumes[ self.team ][ self.currentColorCode ];
	if ( IsDefined( volume ) )
	{
		self SetGoal( volume );
	}
	else
	{
		self ClearFixedNodeSafeVolume();
	}
	
	if( IsDefined( node.fixedNodeSafeRadius ) )
	{
		self.fixedNodeSafeRadius = node.fixedNodeSafeRadius;
	}
	else
	{
		self.fixedNodeSafeRadius = 64;
	}
}

function color_force_goal(node)
{
	self endon("death");
	self thread ai::force_goal( node, undefined, true, "stop_color_forcegoal", true );
	self util::waittill_either( "goal", "stop_color_move" );
	self notify( "stop_color_forcegoal" );
}

function careful_logic( node, volume )
{
	self endon( "death" );
	self endon( "stop_being_careful" );
	self endon( "stop_going_to_node" );
	thread recover_from_careful_disable( node );
	
	for ( ;; )
	{
		wait_until_an_enemy_is_in_safe_area( node, volume );
		use_big_goal_until_goal_is_safe( node, volume );
		
		set_goal_and_volume( node );
	}
}

function recover_from_careful_disable( node )
{
	self endon( "death" );
	self endon( "stop_going_to_node" );
	self waittill( "stop_being_careful" );

	set_goal_and_volume( node );
}

function use_big_goal_until_goal_is_safe( node, volume )
{
	self.goalradius = 1024;
	self SetGoal( self.origin );
			
	if ( IsDefined( volume ) )
	{
		for ( ;; )
		{
			wait( 1 );
			
			if ( self isKnownEnemyInRadius( node.origin, self.fixedNodeSafeRadius ) )
			{
				continue;
			}
			if ( self isKnownEnemyInVolume( volume ) )
			{
				continue;
			}
			
			return;
		}
	}
	else
	{
		for ( ;; )
		{
 			if ( !( self isKnownEnemyInRadius( node.origin, self.fixedNodeSafeRadius ) ) )
			{
				return;
			}
 			
			wait( 1 );			
		}
	}
}

function wait_until_an_enemy_is_in_safe_area( node, volume )
{
	if ( IsDefined( volume ) )
	{
		for ( ;; )
		{
			if ( self IsKnownEnemyInRadius( node.origin, self.fixedNodeSafeRadius ) )
			{
				return;
			}
			
			if ( self IsKnownEnemyInVolume( volume ) )
			{
				return;
			}
			
			wait( 1 );			
		}
	}
	else
	{
		for ( ;; )
		{
			if ( self IsKnownEnemyInRadius( node.origin, self.fixedNodeSafeRadius ) )
			{
				return;
			}
			
			wait( 1 );			
		}
	}
}

function my_current_node_delays()
{
	if ( !IsDefined( self.node ) )
	{
		return false;
	}
		
	return self.node util::script_delay();
}

function process_color_order_to_ai( node, trigger, counter )
{
	thread decrementColorUsers( node );

	self endon( "stop_color_move" );
	self endon( "death" );

	if ( IsDefined( trigger ) )
	{
		trigger util::script_delay();
	}
	
	// wait if need to wait on a flag
	if( IsDefined( trigger ) )
	{
		if( IsDefined( trigger.script_flag_wait ) )
			level flag::wait_till( trigger.script_flag_wait );
	}

	if ( !my_current_node_delays() )
	{
		if ( IsDefined( counter ) )
		{
			wait( counter * RandomFloatRange( 0.2, 0.35 ) );
		}
	}
	
	self ai_sets_goal( node );

	// record the node so the guy can find out who has his node, and get that guys
	self.color_ordered_node_assignment = node;

	for( ;; )
	{
		self waittill( "node_taken", taker );
		if( taker == self )
		{
			// give time for the player to claim the node
			{wait(.05);};
		}

		// lost our node so try to get a new one
		node = get_best_available_new_colored_node();
		if( IsDefined( node ) )
		{
			assert( !isalive( node.color_user ), "Node already had color user!" );
			if( isalive( self.color_node.color_user ) && self.color_node.color_user == self )
			{
				self.color_node.color_user = undefined;
			}
			self.color_node = node;
			node.color_user = self;
			self ai_sets_goal( node );
		}
	}
}



function get_best_available_colored_node()
{
	assert( self.team != "neutral" );
	assert( IsDefined( self.script_forceColor ), "AI with export " + self.export + " lost his script_forcecolor.. somehow." );
	colorCode = level.currentColorForced[ self.team ][ self.script_forceColor ];

	nodes = get_prioritized_colorCoded_nodes( self.team, colorCode, self.script_forcecolor );

	assert( nodes.size > 0, "Tried to make guy with export " + self.export + " go to forcecolor " + self.script_forceColor + " but there are no nodes of that color enabled" );
	for( i=0; i < nodes.size; i++ )
	{
		if( !isalive( nodes[ i ].color_user ) )
		{
			return nodes[ i ];
		}
	}
}

function get_best_available_new_colored_node()
{
	assert( self.team != "neutral" );
	assert( IsDefined( self.script_forceColor ), "AI with export " + self.export + " lost his script_forcecolor.. somehow." );
	colorCode = level.currentColorForced[ self.team ][ self.script_forceColor ];
	nodes = get_prioritized_colorCoded_nodes( self.team, colorCode, self.script_forcecolor );

	assert( nodes.size > 0, "Tried to make guy with export " + self.export + " go to forcecolor " + self.script_forceColor + " but there are no nodes of that color enabled" );
	
	nodes = ArraySort( nodes, self.origin );

	for( i=0; i < nodes.size; i++ )
	{
		if( !isalive( nodes[ i ].color_user ) )
		{
			return nodes[ i ];
		}
	}
}

function process_stop_short_of_node( node )
{
	self endon( "stopScript" );
	self endon( "death" );

	if( IsDefined( self.node ) )
	{
		return;
	}
		
	// first check to see if we're right near it
	if( distancesquared( node.origin, self.origin ) < 32*32 )
	{
		reached_node_but_could_not_claim_it( node );
		return;
	}
		
	// if we're far away, maybe somebody cut us off then took our node, now we're stuck in limbo
	// so wait one second, if we're still in stop script( ie no killanimscripts ) then push the guy
	// off the node
	currentTime = gettime();
	wait_for_killanimscript_or_time( 1 );
	newTime = gettime();

	// did we break out of stop fast enough to indicate we continued moving? If not, then reclaim the node		
	if( newTime - currentTime >= 1000 )
	{
		reached_node_but_could_not_claim_it( node );
	}
}

function wait_for_killanimscript_or_time( timer )
{
	self endon( "killanimscript" );
	wait( timer );
}


function reached_node_but_could_not_claim_it( node )
{
	

	ai = GetAIArray();
	for( i=0;i<ai.size;i++ )
	{
		if( !IsDefined( ai[ i ].node ) )
		{
			continue;
		}
		
		if( ai[ i ].node != node )
		{
			continue;
		}
		
		ai[ i ] notify( "eject_from_my_node" );
		wait( 1 );
		self notify( "eject_from_my_node" );
		return true;
	}
	return false;
}


function decrementColorUsers( node )
{
	node.color_user = self;
	self.color_node = node;

	/#
	self.color_node_debug_val = true;
	#/

	self endon( "stop_color_move" );
	self waittill( "death" );
	self.color_node.color_user = undefined;
}

function colorIsLegit( color )
{
	for( i = 0; i < level.colorList.size; i++ )
	{
		if( color == level.colorList[ i ] )
		{
			return true;
		}
	}
	return false;
}

function add_volume_to_global_arrays( colorCode, team )
{
	colors = strtok( colorCode, " " );

	for( p = 0; p < colors.size; p++ )
	{
		assert( !IsDefined( level.colorCoded_volumes[ team ][ colors[ p ] ] ), "Multiple info_volumes exist with color code " + colors[ p ] );

		level.colorCoded_volumes[ team ][ colors[ p ] ] = self;
	}
}

function add_node_to_global_arrays( colorCode, team )
{
	self.color_user = undefined;
	colors = strtok( colorCode, " " );

	for( p = 0; p < colors.size; p++ )
	{
		if( IsDefined( level.arrays_of_colorCoded_nodes[ team ] ) && IsDefined( level.arrays_of_colorCoded_nodes[ team ][ colors[ p ] ] ) )
		{
			// array already exists so add this color coded node to that color code array.
			if ( !isdefined( level.arrays_of_colorCoded_nodes[ team ][ colors[ p ] ] ) ) level.arrays_of_colorCoded_nodes[ team ][ colors[ p ] ] = []; else if ( !IsArray( level.arrays_of_colorCoded_nodes[ team ][ colors[ p ] ] ) ) level.arrays_of_colorCoded_nodes[ team ][ colors[ p ] ] = array( level.arrays_of_colorCoded_nodes[ team ][ colors[ p ] ] ); level.arrays_of_colorCoded_nodes[ team ][ colors[ p ] ][level.arrays_of_colorCoded_nodes[ team ][ colors[ p ] ].size]=self;;
			continue;
		}		

		// array doesn't exist so we have to initialize all the variables related to this color coding.
		level.arrays_of_colorCoded_nodes[ team ][ colors[ p ] ][ 0 ] = self;
		level.arrays_of_colorCoded_ai[ team ][ colors[ p ] ] = [];
		level.arrays_of_colorCoded_spawners[ team ][ colors[ p ] ] = [];
	}
}

function left_color_node()
{
	/#
	self.color_node_debug_val = undefined;
	#/
	if( !IsDefined( self.color_node ) )
	{
		return;
	}
	
	if( IsDefined( self.color_node.color_user ) && self.color_node.color_user == self )
	{
		self.color_node.color_user = undefined;
	}
		
	self.color_node = undefined;
	self notify( "stop_color_move" );
}


function GetColorNumberArray()
{	
	array = [];
	if( issubstr( self.classname, "axis" ) || issubstr( self.classname, "enemy" ) )
	{
		array[ "team" ] = "axis";
		array[ "colorTeam" ] = self.script_color_axis;
	}
	
	if(( issubstr( self.classname, "ally" ) ) ||( issubstr( self.classname, "civilian" ) ) )
	{
		array[ "team" ] = "allies";
		array[ "colorTeam" ] = self.script_color_allies;
	}

	if( !IsDefined( array[ "colorTeam" ] ) )
	{
		array = undefined;
	}
	
	return array;
}

function removeSpawnerFromColorNumberArray()
{
	colorNumberArray = GetColorNumberArray();
	if( !IsDefined( colorNumberArray ) )
	{
		return;
	}

	team = colorNumberArray[ "team" ];
	colorTeam = colorNumberArray[ "colorTeam" ];

	// remove this spawner from any array it was in
	colors = strtok( colorTeam, " " );
	for( i=0;i<colors.size;i++ )
	{
		ArrayRemoveValue( level.arrays_of_colorCoded_spawners[ team ][ colors[ i ] ], self );
	}
}

function add_cover_node( type )
{
	level.color_node_type_function[ type ][ true ][ "allies" ] =&process_cover_node_with_last_in_mind_allies;
	level.color_node_type_function[ type ][ true ][ "axis" ] =&process_cover_node_with_last_in_mind_axis;
	level.color_node_type_function[ type ][ false ][ "allies" ] =&process_cover_node;
	level.color_node_type_function[ type ][ false ][ "axis" ] =&process_cover_node;
}

function add_path_node( type )
{
	level.color_node_type_function[ type ][ true ][ "allies" ] =&process_path_node;
	level.color_node_type_function[ type ][ false ][ "allies" ] =&process_path_node;
	level.color_node_type_function[ type ][ true ][ "axis" ] =&process_path_node;
	level.color_node_type_function[ type ][ false ][ "axis" ] =&process_path_node;
}


// ColorNode respawn system
function colorNode_spawn_reinforcement( classname, fromColor )
{
	level endon( "kill_color_replacements" );
	
	friendly_spawners_type = getClassColorHash(classname, fromColor);
	
	while(level.friendly_spawners_types[friendly_spawners_type] > 0)
	{
		spawn = undefined;
	
		for( ;; )
		{
			if( !level flag::get( "respawn_friendlies" ) )
			{
				if( !IsDefined( level.friendly_respawn_vision_checker_thread ) )
					thread friendly_spawner_vision_checker();
	
				// have to break if respawn_friendlies gets enabled because that disables the
				// fov check that toggles player_looks_away_from_spawner.
				for ( ;; )
				{
					level flag::wait_till_any( array( "player_looks_away_from_spawner", "respawn_friendlies" ) );
					level flag::wait_till_clear( "friendly_spawner_locked" );
					if ( level flag::get( "player_looks_away_from_spawner" ) || level flag::get( "respawn_friendlies" ) )
					{
						break;
					}
				}
				level flag::set( "friendly_spawner_locked" );
			}
	
			spawner = get_color_spawner( classname, fromColor );
			spawner.count = 1;
			
			level.friendly_spawners_types[friendly_spawners_type] = level.friendly_spawners_types[friendly_spawners_type] - 1;
	
			spawner util::script_wait(); 		
			
			spawn = spawner spawner::spawn();	
			if( spawner::spawn_failed( spawn ) )
			{
				thread lock_spawner_for_awhile();
				wait( 1 );
				continue;
			}
			
			level notify( "reinforcement_spawned", spawn );
			break;
		}
		
		// figure out which color the spawned guy should be
		for( ;; )
		{
			if( !IsDefined( fromColor ) )
			{
				break;
			}
			
			if( get_color_from_order( fromColor, level.current_color_order ) == "none" )
			{
				break;
			}
			fromColor = level.current_color_order[ fromColor ];
		}
		if( IsDefined( fromColor ) )
		{
			spawn set_force_color( fromColor );
		}
		
		thread lock_spawner_for_awhile();
	
		if( IsDefined( level.friendly_startup_thread ) )
		{
			spawn thread [ [ level.friendly_startup_thread ] ]();
		}
	
		spawn thread colorNode_replace_on_death();
	}
}

function colorNode_replace_on_death()
{
	level endon( "kill_color_replacements" );

	assert( isalive( self ), "Tried to do replace on death on something that was not alive" );
	self endon( "_disable_reinforcement" );
	
	
	if( self.team == "axis" )
	{
		return;
	}
	
	if ( IsDefined( self.replace_on_death ) )
	{
		return;
	}
		
	self.replace_on_death = true;
	assert( !IsDefined( self.respawn_on_death ), "Guy with export " + self.export + " tried to run respawn on death twice." );
	
	// when a red or green guy dies, an orange guy becomes a red guy
	// when an orange guy dies, a yellow guy becomes an orange guy	
	classname = self.classname;
	color = self.script_forceColor;

	// if we spawn a new guy with spawn_reinforcement, he needs to get his color assignment before he checks his forcecolor
	waittillframeend; 
	
	if( isalive( self ) )
	{
		// could've died in waittillframeend
		self waittill( "death" );
	}
	
	color_order = level.current_color_order;

	if( !IsDefined( self.script_forceColor ) )
	{
		return;
	}
	
	//Create only 1 respawn thread per class/color
	friendly_spawners_type = getClassColorHash(classname, self.script_forceColor);
		
	if(!isdefined(level.friendly_spawners_types) || !isdefined(level.friendly_spawners_types[friendly_spawners_type]) 
	   || level.friendly_spawners_types[friendly_spawners_type] <= 0)
	{
		level.friendly_spawners_types[friendly_spawners_type] = 1;
		
		// spawn a replacement yellow guy
		thread colorNode_spawn_reinforcement( classname, self.script_forceColor );
	}
	else
	{
		level.friendly_spawners_types[friendly_spawners_type] = level.friendly_spawners_types[friendly_spawners_type] + 1;
	}

	
	if( IsDefined( self ) && IsDefined( self.script_forceColor ) )
	{
		color = self.script_forceColor;
	}
		
	if( IsDefined( self ) && IsDefined( self.origin ) )
	{
		origin = self.origin;
	}


	// a replacement has been spawned, so now promote somebody to our color
	for( ;; )
	{
		if( get_color_from_order( color, color_order ) == "none" )
		{
			return;
		}
			
		correct_colored_friendlies = get_force_color_guys( "allies", color_order[ color ] );

		//correct_colored_friendlies = remove_heroes( correct_colored_friendlies );//TODO T7 - bring over hero system if we need it

		correct_colored_friendlies = array::filter_classname( correct_colored_friendlies, true, classname );
		
		
		if( !correct_colored_friendlies.size )
		{
			// nobody of the correct color existed, so give them more time to spawn
			wait( 2 );
			continue;
		}
		
		players = GetPlayers();
		//correct_colored_guy = _utility::getClosest( players[0].origin, correct_colored_friendlies );
		correct_colored_guy = ArraySort( correct_colored_friendlies, players[0].origin, 1 )[0];
		assert( correct_colored_guy.script_forceColor != color, "Tried to replace a " + color + " guy with a guy of the same color!" );
		
		// have to wait until the end of the frame because the guy may have just spawned and been given his forcecolor, 
		// and you cant give a guy forcecolor twice in one frame currently.		
		waittillframeend;
		if( !isalive( correct_colored_guy ) )
		{
			// if he died during the frame then try again!
			continue;
		}
		
		correct_colored_guy set_force_color( color );

		// should something special happen when a guy is promoted? Like a change in threatbias group?
		if( IsDefined( level.friendly_promotion_thread ) )
		{
			correct_colored_guy [ [ level.friendly_promotion_thread ] ]( color );
		}

		color = color_order[ color ];
	}
}

function get_color_from_order( color, color_order )
{
	if( !IsDefined( color ) )
	{
		return "none";
	}
		
	if( !IsDefined( color_order ) )
	{
		return "none";
	}
		
	if( !IsDefined( color_order[ color ] ) )
	{
		return "none";
	}

	return color_order[ color ];
}

function friendly_spawner_vision_checker()
{
	level.friendly_respawn_vision_checker_thread = true;
	// checks to see if the player is looking at the friendly spawner
	
	successes = 0;
	for( ;; )
	{
		level flag::wait_till_clear( "respawn_friendlies" );
		wait( 1 );
		// friendly_respawn is disabled but if the player is far enough away and looking away
		// from the spawner then we can still spawn from it.
		if( !IsDefined( level.respawn_spawner ) )
		{
			continue;
		}
			
		spawner = level.respawn_spawner;

		players = GetPlayers();

		player_sees_spawner = false;
		for( q = 0; q < players.size; q++ )
		{
			difference_vec = players[q].origin - spawner.origin;
			if( length( difference_vec ) < 200 )
			{
				player_sees_spawner();
				player_sees_spawner = true;
				break;
			}

		    forward = anglesToForward(( 0, players[q] getplayerangles()[ 1 ], 0 ) );
			difference = vectornormalize( difference_vec );
		    dot = vectordot( forward, difference );
			if( dot < 0.2 )
			{
				player_sees_spawner();
				player_sees_spawner = true;
				break;
			}
		
			successes++;
			if( successes < 3 )
			{
				continue;
			}
		}

		if( player_sees_spawner )
		{
			continue;
		}

		// player has been looking away for 3 seconds
		level flag::set( "player_looks_away_from_spawner" );
	}
}

function get_color_spawner( classname, fromColor )
{
	// make sure we don't assume that this array is defined!
	specificFromColor = false;
	
	if( IsDefined( level.respawn_spawners_specific ) && IsDefined( level.respawn_spawners_specific[fromColor] ) )
	{
		specificFromColor = true;
	}
	
	if( !IsDefined( level.respawn_spawner ) )
	{
		// make sure we're not using color-specific respawners instead
		if( !IsDefined( fromColor ) || !specificFromColor )
		{
			ASSERTMSG( "Tried to spawn a guy but neither level.respawn_spawner or level.respawn_spawners_specific is defined.  Either set it to a spawner or use targetname trigger_friendly_respawn triggers.  HINT: has the player hit a friendly_respawn_trigger for ALL allied color groups in the map by the time the player has reached this point?" );
		}
	}
	
	// if the classname is not set, just use the global respawn spawner
	if( !IsDefined( classname ) )
	{
		if( IsDefined( fromColor ) && specificFromColor )
		{
			return level.respawn_spawners_specific[fromColor];
		}
		else
		{
			return level.respawn_spawner;
		}
	}
	
	spawners = GetEntArray( "color_spawner", "targetname" );
	class_spawners = [];
	for( i=0; i < spawners.size; i++ )
	{
		class_spawners[ spawners[ i ].classname ] = spawners[ i ];
	}

	// find the spawner that has the supplied classname as a substr
	spawner = undefined;
	keys = getarraykeys( class_spawners );
	for( i=0; i < keys.size; i++ )
	{
		if( !issubstr( class_spawners[ keys[ i ] ].classname, classname ) )
		{
			continue;
		}
		spawner = class_spawners[ keys[ i ] ];
		break;
	}
//	spawner = class_spawners[ classname ];

	if( !IsDefined( spawner ) )
	{
		if( IsDefined( fromColor ) && specificFromColor )
		{
			return level.respawn_spawners_specific[fromColor];
		}
		else
		{
			return level.respawn_spawner;
		}
	}

	if( IsDefined( fromColor ) && specificFromColor )
	{
		spawner.origin = level.respawn_spawners_specific[fromColor].origin;
	}
	else
	{
		spawner.origin = level.respawn_spawner.origin;
	}
	
	return spawner;	
}

function getClassColorHash(classname, fromcolor )
{
	//Create only 1 respawn thread per class/color
	classColorHash = classname;
	
	if(isdefined(fromcolor))
	{
		classColorHash += "##" + fromcolor;
	}

	return classColorHash;
}

function lock_spawner_for_awhile()
{
	level flag::set( "friendly_spawner_locked" );
	wait( 2 );
	level flag::clear( "friendly_spawner_locked" );
}

function player_sees_spawner()
{
	level flag::clear( "player_looks_away_from_spawner" );
}


function kill_color_replacements()
{
	// kills ALL color respawning
	level flag::clear( "friendly_spawner_locked" );
	level notify( "kill_color_replacements" );
	level.friendly_spawners_types = undefined;
	
	ai = GetAIArray();
	array::thread_all( ai,&remove_replace_on_death );
}

function remove_replace_on_death()
{
	self.replace_on_death = undefined;
}

/@
"Name: set_force_color( <_color> )"
"Summary: Sets a guy's force color"
"Module: Color"
"CallOn: An AI"
"Example: guy set_force_color( "p" );"
"SPMP: singleplayer"
@/
function set_force_color( _color )
{
	// shorten and lowercase the ai's forcecolor to a single letter
	color = shortenColor( _color );

	assert( colorIsLegit( color ), "Tried to set force color on an undefined color: " + color );

	if( !IsActor( self ) )
	{
		set_force_color_spawner( color );
		return;
	}

	assert( isalive( self ), "Tried to set force color on a dead / undefined entity." );
		
	self.fixedNodeSafeRadius = 64;	
	
	self.script_color_axis = undefined;
	self.script_color_allies = undefined;
	self.old_forcecolor = undefined;

	if( IsDefined( self.script_forcecolor ) )
	{
		// first remove the guy from the force color array he used to belong to
		ArrayRemoveValue( level.arrays_of_colorForced_ai[ self.team ][ self.script_forcecolor ], self );
	}
	
	self.script_forceColor = color;

	// get added to the new array of AI that are forced to this color
	if ( !isdefined( level.arrays_of_colorForced_ai[ self.team ][ self.script_forceColor ] ) ) level.arrays_of_colorForced_ai[ self.team ][ self.script_forceColor ] = []; else if ( !IsArray( level.arrays_of_colorForced_ai[ self.team ][ self.script_forceColor ] ) ) level.arrays_of_colorForced_ai[ self.team ][ self.script_forceColor ] = array( level.arrays_of_colorForced_ai[ self.team ][ self.script_forceColor ] ); level.arrays_of_colorForced_ai[ self.team ][ self.script_forceColor ][level.arrays_of_colorForced_ai[ self.team ][ self.script_forceColor ].size]=self;;


	// set it here so that he continues in script as the correct color
	self thread new_color_being_set( color );
}

function shortenColor( color )
{
	Assert( IsDefined( level.colorCheckList[ ToLower( color ) ] ), "Tried to set force color on an undefined color: " + color );
	return level.colorCheckList[ ToLower( color ) ];
}

function set_force_color_spawner( color )
{
	self.script_forceColor = color;
	self.old_forceColor = undefined;
}

function new_color_being_set( color )
{
	self notify( "new_color_being_set" );
	self.new_force_color_being_set = true;
	left_color_node();

	self endon( "new_color_being_set" );
	self endon( "death" );

	// insure we're only getting one color change, multiple in one frame will get overwritten.
	waittillframeend;
	waittillframeend;
	
	if ( IsDefined( self.script_forceColor ) )
	{
		// grab the current colorCode that AI of this color are forced to, if there is one
		self.currentColorCode = level.currentColorForced[ self.team ][ self.script_forceColor ];
		self thread goto_current_ColorIndex();
	}
	
	self.new_force_color_being_set = undefined;
	self notify( "done_setting_new_color" );
	
	 /#
	update_debug_friendlycolor();
	#/ 
}

function update_debug_friendlycolor_on_death()
{
	self notify( "debug_color_update" );
	self endon( "debug_color_update" );
	self waittill( "death" );
	
	/#
	a_keys = GetArrayKeys( level.debug_color_friendlies );
	foreach( n_key in a_keys )
	{
		ai = GetEntByNum( n_key );
		if ( !IsAlive( ai ) )
		{
			ArrayRemoveIndex( level.debug_color_friendlies, n_key, true );
		}
	}
	#/
	
	// updates the debug color friendlies info
	level notify( "updated_color_friendlies" );
}


function update_debug_friendlycolor()
{
	self thread update_debug_friendlycolor_on_death();
	
	if ( isdefined( self.script_forceColor ) )
	{
		level.debug_color_friendlies[ self GetEntityNumber() ] = self.script_forceColor;
	}
	else
	{
		level.debug_color_friendlies[ self GetEntityNumber() ] = undefined;
	}
	
	// updates the debug color friendlies info
	level notify( "updated_color_friendlies" );
}

function has_color()
{
	// can lose color during the waittillframeend in left_color_node
	if ( self.team == "axis" )
	{
		return IsDefined( self.script_color_axis ) || IsDefined( self.script_forceColor );
	}

	return IsDefined( self.script_color_allies ) || IsDefined( self.script_forceColor );
}

/@
"Name: get_force_color()"
"Summary: Returns a guy's force color"
"Module: Color"
"CallOn: An AI"
"Example: color = guy get_force_color()"
"SPMP: singleplayer"
@/
function get_force_color()
{
	color = self.script_forceColor;
	return color;
}

/@
"Name: get_force_color_guys( <team>, <color> )"
"Summary: Returns all alive ai of a certain force color."
"Module: AI"
"CallOn: "
"Example: red_guys = get_force_color_guys( "allies", "r" );"
"MandatoryArg: <team> : the team of the guys to check"
"MandatoryArg: <color> : the color value of the guys you want to collect"
"SPMP: singleplayer"
@/
function get_force_color_guys( team, color )
{
	ai = GetAITeamArray( team );
	guys = [];
	for( i = 0; i < ai.size; i++ )
	{
		guy = ai[ i ];
		if( !IsDefined( guy.script_forceColor ) )
		{
			continue;
		}

		if( guy.script_forceColor != color )
		{
			continue;
		}
		guys[ guys.size ] = guy;
	}

	return guys;
}

function get_all_force_color_friendlies()
{
	ai = GetAITeamArray( "allies" );
	guys = [];
	for( i = 0; i < ai.size; i++ )
	{
		guy = ai[ i ];
		if( !IsDefined( guy.script_forceColor ) )
		{
			continue;
		}
		guys[ guys.size ] = guy;
	}

	return guys;
}

/@
"Name: disable()"
"Summary: disables an ai's force color. Essentially takes him off the color chain."
"Module: Color"
"CallOn: An AI"
"Example: guy colors::disable();"
"SPMP: singleplayer"
@/
function disable( stop_being_careful )
{
	if( IsDefined( self.new_force_color_being_set ) )
	{
		self endon( "death" );
		// setting force color happens after waittillframeend so we need to wait until it finishes
		// setting before we disable it, so a set followed by a disable will send the guy to a node.
		self waittill( "done_setting_new_color" );
	}

	// SUMEET_TODO - AI should stop going to node/running careful right when color is disabled.
	// Added this late on Black Ops2 ( 08/10/2012 ) hence not making it global. Might introduce issues 
	// on other maps. 
	if( ( isdefined( stop_being_careful ) && stop_being_careful ) )
	{
		self notify( "stop_going_to_node" );
		self notify( "stop_being_careful" );
	}
		
	self clearFixedNodeSafeVolume();
	// any color on this guy?
	if( !IsDefined( self.script_forceColor ) )
	{
		return;
	}

	assert( !IsDefined( self.old_forcecolor ), "Tried to disable forcecolor on a guy that somehow had a old_forcecolor already. Investigate!!!" );

	self.old_forceColor = self.script_forceColor;


	// first remove the guy from the force color array he used to belong to
	ArrayRemoveValue( level.arrays_of_colorForced_ai[ self.team ][ self.script_forcecolor ], self );
	// 	self _colors::removeAIFromColorNumberArray();

	left_color_node();
	self.script_forceColor = undefined;
	self.currentColorCode = undefined;
	/#
		update_debug_friendlycolor();
	#/
}

/@
"Name: enable()"
"Summary: Re-enables an ai's force color. Only works on guys that have had a forceColor set previously."
"Module: Color"
"CallOn: An AI"
"Example: guy colors::enable();"
"SPMP: singleplayer"
@/
function enable()
{
	if ( IsDefined( self.script_forceColor ) )
	{
		return;
	}
	
	if ( !IsDefined( self.old_forceColor ) )
	{
		return;
	}

	set_force_color( self.old_forcecolor );
	self.old_forceColor = undefined;
}

function is_color_ai()
{
	return ( isdefined( self.script_forcecolor ) || isdefined( self.old_forcecolor ) );
}


/#

function insure_player_does_not_set_forcecolor_twice_in_one_frame()
{
	assert( !IsDefined( self.setforcecolor ), "Tried to set forceColor on an ai twice in one frame. Don't spam set_force_color." );
	self.setforcecolor = true;
	waittillframeend;
	if ( !isalive( self ) )
	{
		return;
	}
	self.setforcecolor = undefined;
}

#/
