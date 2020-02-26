#include maps\_utility;
#include common_scripts\utility;
/* 

	Color coded AI travel system
	A colorCode is a color( red, blue, yellow, cyan, green, purple or orange ) and a #.
	When a trigger and AI and node are color grouped in Radiant, they get a unique color and #.
	When when a color coded trigger is hit, that colorCode is "fired" and any AI that are in colorCoded mode get their goalnode set.

	AI can be forced to a color generically. For example if an AI is forced to the color "red" and a trigger fires off "red15", the AI
	will go to that node even if the AI doesn't have script_color_allies( or axis ) "red15". This is mainly for friendlies.

*/ 

init_color_grouping( nodes )
{
	// friendly spawner global stuff
	flag_init( "player_looks_away_from_spawner" );
	flag_init( "friendly_spawner_locked" );

// 	wait( 0.05 );// begone infinite hangs
	level.arrays_of_colorCoded_nodes = [];
	level.arrays_of_colorCoded_nodes[ "axis" ] = [];
	level.arrays_of_colorCoded_nodes[ "allies" ] = [];

	level.arrays_of_colorCoded_volumes = [];
	level.arrays_of_colorCoded_volumes[ "axis" ] = [];
	level.arrays_of_colorCoded_volumes[ "allies" ] = [];
	triggers = [];
	triggers = array_combine( triggers, getentarray( "trigger_multiple"	, "code_classname" ) );
	triggers = array_combine( triggers, getentarray( "trigger_radius"	, "code_classname" ) );
	triggers = array_combine( triggers, getentarray( "trigger_once"		, "code_classname" ) );

	// tmp stuff for making colors work on team 3.
	level.color_teams = [];
	level.color_teams[ "allies" ] = "allies";
	level.color_teams[ "axis" ] = "axis";
	level.color_teams[ "team3" ] = "axis";
	level.color_teams[ "neutral" ] = "neutral";

	volumes = getentarray( "info_volume", "code_classname" );

	// go through all the nodes and if they have color codes then add them too
	foreach ( node in nodes )
	{
		if ( isdefined( node.script_color_allies ) )
			node add_node_to_global_arrays( node.script_color_allies, "allies" );
		if ( isdefined( node.script_color_axis ) )
			node add_node_to_global_arrays( node.script_color_axis, "axis" );
	}

	// volumes that have color codes wait for trigger and then fire their colorcode to control fixednodesafe volumes
	foreach ( volume in volumes )
	{
		if ( isdefined( volume.script_color_allies ) )
			volume add_volume_to_global_arrays( volume.script_color_allies, "allies" );

		if ( isdefined( volume.script_color_axis ) )
			volume add_volume_to_global_arrays( volume.script_color_axis, "axis" );
	}
	
	// triggers that have color codes wait for trigger and then fire their colorcode
	foreach ( trigger in triggers )
	{
		if ( isdefined( trigger.script_color_allies ) )
			trigger thread trigger_issues_orders( trigger.script_color_allies, "allies" );
		if ( isdefined( trigger.script_color_axis ) )
			trigger thread trigger_issues_orders( trigger.script_color_axis, "axis" );
	}
	
	 /#
		level.colorNodes_debug_array = [];
		level.colorNodes_debug_array[ "allies" ] = [];
		level.colorNodes_debug_array[ "axis" ] = [];

// 		level.colorNodes_debug_ai = [];
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
	add_cover_node( "Conceal Stand" );
	add_cover_node( "Conceal Crouch" );
	add_cover_node( "Conceal Prone" );
	add_cover_node( "Reacquire" );
	add_cover_node( "Balcony" );
	add_cover_node( "Scripted" );
	add_cover_node( "Begin" );
	add_cover_node( "End" );
	add_cover_node( "Turret" );
	add_path_node( "Ambush" );
	add_path_node( "Guard" );
	add_path_node( "Path" );
	add_path_node( "Exposed" );

	level.colorList = [];
	level.colorList[ level.colorList.size ] = "r";
	level.colorList[ level.colorList.size ] = "b";
	level.colorList[ level.colorList.size ] = "y";
	level.colorList[ level.colorList.size ] = "c";
	level.colorList[ level.colorList.size ] = "g";
	level.colorList[ level.colorList.size ] = "p";
	level.colorList[ level.colorList.size ] = "o";

	level.colorCheckList[ "red" ] 	 = "r";
	level.colorCheckList[ "r" ] 		 = "r";
	level.colorCheckList[ "blue" ] 	 = "b";
	level.colorCheckList[ "b" ] 		 = "b";
	level.colorCheckList[ "yellow" ] 	 = "y";
	level.colorCheckList[ "y" ] 		 = "y";
	level.colorCheckList[ "cyan" ] 	 = "c";
	level.colorCheckList[ "c" ] 		 = "c";
	level.colorCheckList[ "green" ] 	 = "g";
	level.colorCheckList[ "g" ] 		 = "g";
	level.colorCheckList[ "purple" ] 	 = "p";
	level.colorCheckList[ "p" ] 		 = "p";
	level.colorCheckList[ "orange" ] 	 = "o";
	level.colorCheckList[ "o" ] 		 = "o";

	level.currentColorForced = [];
	level.currentColorForced[ "allies" ] = [];
	level.currentColorForced[ "axis" ] = [];

	level.lastColorForced = [];
	level.lastColorForced[ "allies" ] = [];
	level.lastColorForced[ "axis" ] = [];

	foreach ( color in level.colorList )
	{
		level.arrays_of_colorForced_ai[ "allies" ][ color ] = [];
		level.arrays_of_colorForced_ai[ "axis" ][ color ] = [];
		level.currentColorForced[ "allies" ][ color ] = undefined;
		level.currentColorForced[ "axis" ][ color ] = undefined;
	}

// 	array_thread( getaiarray(), ::ai_picks_destination );
// 	array_thread( getspawnerarray(), ::spawner_processes_colorCoded_ai );

	thread player_color_node();

	spawners = getspawnerteamarray( "allies" );
	
	level._color_friendly_spawners = [];
	foreach ( spawner in spawners )
	{
		level._color_friendly_spawners[ spawner.classname ] = spawner;
	}	
}


convert_color_to_short_string()
{
	// shorten the forcecolors tring to a single letter
	self.script_forceColor = level.colorCheckList[ self.script_forceColor ];
}

ai_picks_destination( currentColorCode )
{
	if ( isdefined( self.script_forcecolor ) )
	{
		convert_color_to_short_string();
		/* 
		// axis don't do node behavior if they're forcecolor.
		if ( self get_team() == "axis" )
		{
			ai_follow_the_leader_behavior();
			return;
		}
		*/ 

		self.currentColorCode = currentColorCode;
		color = self.script_forcecolor;
		assert( colorIsLegit( color ), "AI at origin " + self.origin + " has non - legit forced color " + color + ". Legit colors are red blue yellow cyan green purple and orange." );
		level.arrays_of_colorForced_ai[ self get_team() ][ color ] = array_add( level.arrays_of_colorForced_ai[ self get_team() ][ color ], self );
		thread goto_current_ColorIndex();
		return;
	}

	/* 
	colorTeam = undefined;	
	if ( issubstr( self.classname, "axis" ) || issubstr( self.classname, "enemy" ) )
	{
		assertEx( !isdefined( self.script_color_allies ), "Axis at origin " + self.origin + " has script_color_allies!" );
		if ( !isdefined( self.script_color_axis ) )
			return;
		colorTeam = self.script_color_axis;
	}
	
	if ( ( issubstr( self.classname, "ally" ) ) || ( self.type == "civilian" ) )
	{
		assertEx( !isdefined( self.script_color_axis ), "Ally at origin " + self.origin + " has script_color_axis!" );
		if ( !isdefined( self.script_color_allies ) )
			return;
		colorTeam = self.script_color_allies;
	}
	
	colorCodes = strtok( colorTeam, " " );
	for ( i = 0;i < colorCodes.size;i++ )
	{
		self.currentColorCode = currentColorCode;
		assertEx( isdefined( level.arrays_of_colorCoded_ai[ self get_team() ][ colorCodes[ i ] ] ), "AI at origin " + self.origin + " has script_color " + colorCodes[ i ] + " which does not exist on any nodes" );
		level.arrays_of_colorCoded_ai[ self get_team() ][ colorCodes[ i ] ] = array_add( level.arrays_of_colorCoded_ai[ self get_team() ][ colorCodes[ i ] ], self );
		thread goto_current_ColorIndex();
	}
	*/ 
}

goto_current_ColorIndex()
{
	if ( !isdefined( self.currentColorCode ) )
		return;

	nodes = level.arrays_of_colorCoded_nodes[ self get_team() ][ self.currentColorCode ];
	self left_color_node();
	// can be deleted / killed during left_color_node
	if ( !isalive( self ) )
		return;

	// can lose color during left_color_node
	if ( !has_color() )
		return;
	
	if ( !isdefined( nodes ) )
	{
		volume = level.arrays_of_colorCoded_volumes[ self get_team() ][ self.currentColorCode ];
		assertex( isdefined( volume ), "No nodes or volumes for guy at colorcode " + self.currentColorCode );
		send_ai_to_colorVolume( volume, self.currentColorCode );
		return;
	}

	for ( i = 0; i < nodes.size; i++ )
	{
		node = nodes[ i ];
		if ( isalive( node.color_user ) && !isplayer( node.color_user ) )
			continue;

		self thread ai_sets_goal_with_delay( node );

		thread decrementColorUsers( node );
		return;
	}

	no_node_to_go_to();
}

no_node_to_go_to()
{
	println( "AI with export " + self.export + " was told to go to color node but had no node to go to." );
	// what to do?
	/* 
	col = self.script_forcecolor;
	colors = get_script_palette();
	timer = 15 * 20;
	for ( i = 0; i < timer; i++ )
	{
		print3d( self.origin + ( 0, 0, 72 ), "? ? ?", colors[ col ], 0.9, 1.2 );
		wait( 0.05 );
	}
	*/ 
}

/* 
spawner_processes_colorCoded_ai()
{
	if ( isdefined( self.script_forceColor ) )
	{
		// this is for non forcecolor AI
		return;
	}

	self endon( "new_color_code" );

	axis = issubstr( self.classname, "axis" ) || issubstr( self.classname, "enemy" );
	

	 /#
	if ( isdefined( self.script_color_axis ) || isdefined( self.script_color_allies ) )
	{
		assertEx( !isdefined( self.script_forceColor ), "Can't have script_color_axis / allies and script_forceColor on the same spawner." );
	}
	else
	{
		if ( isdefined( self.script_forceColor ) )
			assertEx( !isdefined( self.script_color_axis ) && !isdefined( self.script_color_allies ), "Can't have script_color_axis / allies and script_forceColor on the spawn spawner." );
	}
	#/ 
	
	colorTeam = undefined;
	forceTeam = undefined;
	team = undefined;
	
	if ( axis )
	{
		assertEx( !isdefined( self.script_color_allies ), "Axis spawner at origin " + self.origin + " has script_color_allies!" );
		if ( !isdefined( self.script_color_axis ) && !isdefined( self.script_forcecolor ) )
			return;
		colorTeam = self.script_color_axis;
		team = "axis";
	}
	
	if ( ( issubstr( self.classname, "ally" ) ) || ( self.type == "civilian" ) )
	{
		assertEx( !isdefined( self.script_color_axis ), "Ally spawner at origin " + self.origin + " has script_color_axis!" );
		if ( !isdefined( self.script_color_allies ) && !isdefined( self.script_forcecolor ) )
			return;
		colorTeam = self.script_color_allies;
		team = "allies";
	}
	
	
	if ( isdefined( colorTeam ) )
	{
		colorCodes = strtok( colorTeam, " " );
		for ( i = 0; i < colorCodes.size; i++ )
		{
			if ( !isdefined( level.arrays_of_colorCoded_spawners[ team ][ colorCodes[ i ] ] ) )
				continue;

			level.arrays_of_colorCoded_spawners[ team ][ colorCodes[ i ] ] = array_add( level.arrays_of_colorCoded_spawners[ team ][ colorCodes[ i ] ], self );
		}
	}

	self endon( "death" );
	
	for ( ;; )
	{
		self waittill( "spawned", spawn );
		if ( spawn_failed( spawn ) )
			continue;
			
		if ( isdefined( self.script_forceColor ) )
			self.currentColorCode = level.currentColorForced[ team ][ self.script_forceColor ];

		spawn thread ai_picks_destination( self.currentColorCode );
	}
}
*/ 

get_color_list()
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

array_remove_dupes( array )
{
	// for numerically indexed arrays only
	string_indexed_array = [];
	
	foreach ( val in array )
	{
		string_indexed_array[ val ] = true;
	}
	
	new_array = [];
	foreach ( index, _ in string_indexed_array )
	{
		new_array[ new_array.size ] = index;
	}
	
	return new_array;
}

get_colorcodes_from_trigger( color_team, team )
{
	colorCodes = strtok( color_team, " " );
	colorCodes = array_remove_dupes( colorCodes );
	
	colors = [];
	colorCodesByColorIndex = [];
	usable_colorCodes = [];

	colorList = get_color_list();

	foreach ( colorCode in colorCodes )
	{
		color = undefined;
		foreach ( color in colorList )
		{
			if ( issubstr( colorCode, color ) )
				break;
		}

		assertEx( isdefined( color ), "Trigger at origin " + self getorigin() + " had strange color index " + colorCode );

		if ( !colorCode_is_used_in_map( team, colorCode ) )
			continue;

		colorCodesByColorIndex[ color ] = colorCode;
		colors[ colors.size ] = color;
		usable_colorCodes[ usable_colorCodes.size ] = colorCode;
	}

	// color codes that don't tie to existing nodes have been culled
	colorCodes = usable_colorCodes;

	array = [];
	array[ "colorCodes" ] = colorCodes;
	array[ "colorCodesByColorIndex" ] = colorCodesByColorIndex;
	array[ "colors" ] = colors;
	return array;
}

colorCode_is_used_in_map( team, colorCode )
{
	// does this order actually tie to existing nodes?
	if ( isdefined( level.arrays_of_colorCoded_nodes[ team ][ colorCode ] ) )
		return true;

	// what about a goalvolume
	return isdefined( level.arrays_of_colorCoded_volumes[ team ][ colorCode ] );
}

trigger_issues_orders( color_team, team )
{
	array = get_colorcodes_from_trigger( color_team, team );
	colorCodes = array[ "colorCodes" ];
	colorCodesByColorIndex = array[ "colorCodesByColorIndex" ];
	colors = array[ "colors" ];


	for ( ;; )
	{
		self waittill( "trigger" );

		if ( isdefined( self.activated_color_trigger ) )
		{
			// activated by an activate_trigger() call, so don't bother running activate_color_trigger() again.
			self.activated_color_trigger = undefined;
			continue;
		}

		activate_color_trigger_internal( colorCodes, colors, team, colorCodesByColorIndex );
	}
}

activate_color_trigger( team )
{
	if ( team == "allies" )
		self thread get_colorcodes_and_activate_trigger( self.script_color_allies, team );
	else
		self thread get_colorcodes_and_activate_trigger( self.script_color_axis, team );
}

get_colorcodes_and_activate_trigger( color_team, team )
{
	array = get_colorcodes_from_trigger( color_team, team );
	colorCodes = array[ "colorCodes" ];
	colorCodesByColorIndex = array[ "colorCodesByColorIndex" ];
	colors = array[ "colors" ];

	activate_color_trigger_internal( colorCodes, colors, team, colorCodesByColorIndex );
}


activate_color_trigger_internal( colorCodes, colors, team, colorCodesByColorIndex )
{
	// give spawners activated by this trigger a chance to spawn their AI
	// removing this because for one thing people shouldn't use compound triggers, but if they do, 
	// the level.currentColorForced will get set, so any AI that spawn will still go to a colored node
	// even if it happens after this
// 		waittillframeend; 


	// remove all the dead from any colors this trigger effects
	// a trigger should never effect the same color twice
	for ( i = 0; i < colorCodes.size; i++ )
	{
		if ( !isdefined( level.arrays_of_colorCoded_spawners[ team ][ colorCodes[ i ] ] ) )
			continue;

		// remove deleted spawners
		level.arrays_of_colorCoded_spawners[ team ][ colorCodes[ i ] ] = array_removeUndefined( level.arrays_of_colorCoded_spawners[ team ][ colorCodes[ i ] ] );

		// set the .currentColorCode on each appropriate spawner
		for ( p = 0; p < level.arrays_of_colorCoded_spawners[ team ][ colorCodes[ i ] ].size; p++ )
			level.arrays_of_colorCoded_spawners[ team ][ colorCodes[ i ] ][ p ].currentColorCode = colorCodes[ i ];
	}

	foreach ( color in colors )
	{
		// remove the dead from the color forced ai
		level.arrays_of_colorForced_ai[ team ][ color ] = array_removeDead( level.arrays_of_colorForced_ai[ team ][ color ] );

		// set the last color forced so we can compare it with current when we tell guys to go to nodes, 
		// so they can prefer new nodes over old ones, so they move up
		level.lastColorForced[ team ][ color ] = level.currentColorForced[ team ][ color ];

		// set the destination of the color forced spawners
		level.currentColorForced[ team ][ color ] = colorCodesByColorIndex[ color ];


		/#
		color_forced = level.currentColorForced[ team ][ color ];
		color_defined = isdefined( level.arrays_of_colorCoded_nodes[ team ][ color_forced ] ) || isdefined( level.arrays_of_colorCoded_volumes[ team ][ color_forced ] );
		assertEx( color_defined, "Trigger tried to set colorCode " + color + " but there are no nodes for " + team + " that use that color combo." );
		#/
	}

	ai_array = [];

	for ( i = 0; i < colorCodes.size; i++ )
	{
		// no need to run this again if it's still the current forced color
		if ( same_color_code_as_last_time( team, colors[ i ] ) )
			continue;

		colorCode = colorCodes[ i ];

		if ( !isdefined( level.arrays_of_colorCoded_ai[ team ][ colorCode ] ) )
			continue;

		ai_array[ colorCode ] = issue_leave_node_order_to_ai_and_get_ai( colorCode, colors[ i ], team );
	}

	for ( i = 0; i < colorCodes.size; i++ )
	{
		colorCode = colorCodes[ i ];
		if ( !isdefined( ai_array[ colorCode ] ) )
			continue;

		// no need to run this again if it's still the current forced color
		if ( same_color_code_as_last_time( team, colors[ i ] ) )
			continue;


		if ( !isdefined( level.arrays_of_colorCoded_ai[ team ][ colorCode ] ) )
			continue;

		issue_color_order_to_ai( colorCode, colors[ i ], team, ai_array[ colorCode ] );
	}
}

same_color_code_as_last_time( team, color )
{
	if ( !isdefined( level.lastColorForced[ team ][ color ] ) )
		return false;

	return level.lastColorForced[ team ][ color ] == level.currentColorForced[ team ][ color ];
}


process_cover_node_with_last_in_mind_allies( node, lastColorNumberCode )
{
	// nodes that were in the last color order go at the end
	if ( issubstr( node.script_color_allies, lastColorNumberCode ) )
		self.cover_nodes_last[ self.cover_nodes_last.size ] = node;
	else
		self.cover_nodes_first[ self.cover_nodes_first.size ] = node;
}

process_cover_node_with_last_in_mind_axis( node, lastColorNumberCode )
{
	// nodes that were in the last color order go at the end
	if ( issubstr( node.script_color_axis, lastColorNumberCode ) )
		self.cover_nodes_last[ self.cover_nodes_last.size ] = node;
	else
		self.cover_nodes_first[ self.cover_nodes_first.size ] = node;
}

process_cover_node( node, null )
{
	self.cover_nodes_first[ self.cover_nodes_first.size ] = node;
}

process_path_node( node, null )
{
	self.path_nodes[ self.path_nodes.size ] = node;
}

prioritize_colorCoded_nodes( team, colorCode, color )
{
	nodes = level.arrays_of_colorCoded_nodes[ team ][ colorCode ];

	// need a place to store the nodes externally so we can put the pathnodes in the back
	ent = spawnstruct();
	ent.path_nodes = [];
	ent.cover_nodes_first = [];
	ent.cover_nodes_last = [];

	lastColorForced_exists = isdefined( level.lastColorForced[ team ][ color ] );

	// fills ent.path_nodes or .cover_nodes depending on node type	
	for ( i = 0 ; i < nodes.size; i++ )
	{
		node = nodes[ i ];
		ent [[ level.color_node_type_function[ node.type ][ lastColorForced_exists ][ team ] ]]( node, level.lastColorForced[ team ][ color ] );
	}

	ent.cover_nodes_first = array_randomize( ent.cover_nodes_first );
	
	// these nodes are forced to be last from radiant
	lastnodes = [];
	nodes = [];
	foreach ( index, node in ent.cover_nodes_first )
	{
		if ( isdefined( node.script_colorLast ) )
		{
			lastnodes[ lastnodes.size ] = node;
			nodes[ index ] = undefined;
			continue;
		}
		
		nodes[ nodes.size ] = node;
	}

	for ( i = 0; i < ent.cover_nodes_last.size; i++ )
	{
		nodes[ nodes.size ] = ent.cover_nodes_last[ i ];
	}

	// put the path nodes at the end of the array so they're less favored
	for ( i = 0; i < ent.path_nodes.size; i++ )
	{
		nodes[ nodes.size ] = ent.path_nodes[ i ];
	}
	
	// put the forced lastnodes at the end
	foreach ( node in lastnodes )
	{
		nodes[ nodes.size ] = node;
	}	

	level.arrays_of_colorCoded_nodes[ team ][ colorCode ] = nodes;
}

get_prioritized_colorCoded_nodes( team, colorCode, color )
{
	return level.arrays_of_colorCoded_nodes[ team ][ colorCode ];
}

get_colorCoded_volume( team, colorCode )
{
	return level.arrays_of_colorCoded_volumes[ team ][ colorCode ];
}

issue_leave_node_order_to_ai_and_get_ai( colorCode, color, team )
{
	// remove dead from this specific colorCode
	level.arrays_of_colorCoded_ai[ team ][ colorCode ] = array_removeDead( level.arrays_of_colorCoded_ai[ team ][ colorCode ] );
	ai = level.arrays_of_colorCoded_ai[ team ][ colorCode ];
	ai = array_combine( ai, level.arrays_of_colorForced_ai[ team ][ color ] );
	newArray = [];
	foreach ( guy in ai )
	{
		// ignore AI that are already going to this colorCode
		if ( isdefined( guy.currentColorCode ) && guy.currentColorCode == colorCode )
			continue;
		newArray[ newArray.size ] = guy;
	}

	ai = newArray;
	if ( !ai.size )
		return;

	array_thread( ai, ::left_color_node );

	return ai;
}

send_ai_to_colorVolume( volume, colorCode )
{
	self notify( "stop_color_move" );
	self.currentColorCode = colorCode;

	if ( isdefined( volume.target ) )
	{
		node = getnode( volume.target, "targetname" );
		if ( isdefined( node ) )
			self setgoalnode( node );
	}
		
	self.fixednode = false;	
	self setGoalVolumeAuto( volume );
}

issue_color_order_to_ai( colorCode, color, team, ai )
{
	original_ai_array = ai;

	/# level.colorNodes_debug_array[ team ][ colorCode ] = undefined; #/

	nodes = [];
	if ( isdefined( level.arrays_of_colorCoded_nodes[ team ][ colorCode ] ) )
	{
		prioritize_colorCoded_nodes( team, colorCode, color );
		nodes = get_prioritized_colorCoded_nodes( team, colorCode, color );

		 /#
		level.colorNodes_debug_array[ team ][ colorCode ] = nodes;
		#/
	}
	else
	{
		volume = get_colorCoded_volume( team, colorCode );
		assertex( isdefined( volume ), "More than 1 volume has the same colorcode. Don't know what to do! Color code was " + colorCode + " but this may be changed at compile time." );
		array_thread( ai, ::send_ai_to_colorVolume, volume, colorCode );
	}

	 /#
	if ( nodes.size < ai.size )
		println( "^3Warning, ColorNumber system tried to make " + ai.size + " AI go to " + nodes.size + " nodes." );
	#/

	counter = 0;
	ai_count = ai.size;
	for ( i = 0; i < nodes.size; i++ )
	{
		node = nodes[ i ];
		// add guys to the nodes with the fewest AI on them
		if ( isalive( node.color_user ) )
			continue;

		closestAI = getclosest( node.origin, ai );
		assert( isalive( closestAI ) );
		ai = array_remove( ai, closestAI );

// 			println( "sent ai to node" );
		closestAI take_color_node( node, colorCode, self, counter );
		counter++ ;

		if ( !ai.size )
			return;
	}
}

take_color_node( node, colorCode, trigger, counter )
{
	self notify( "stop_color_move" );
	self.currentColorCode = colorCode;
	self thread process_color_order_to_ai( node, trigger, counter );
}

player_color_node()
{
	// detect if the player gets a node and set its .color_user
	for ( ;; )
	{
		playerNode = undefined;
		if ( !isdefined( level.player.node ) )
		{
			wait( 0.05 );
			continue;
		}

		olduser = level.player.node.color_user;

		playerNode = level.player.node;
		playerNode.color_user = level.player;

/* 
		if ( isalive( olduser ) )
		{
			// send this guy somewhere else
			node = olduser get_best_available_colored_node();
			if ( !isdefined( node ) )
			{
				olduser no_node_to_go_to();
			}
			else
			{
				olduser setgoalnode( node );
				olduser.goalradius = node.radius;
			}
		}
*/ 

		for ( ;; )
		{
			if ( !isdefined( level.player.node ) )
				break;
			if ( level.player.node != playerNode )
				break;
			wait( 0.05 );
		}

		playerNode.color_user = undefined;

		playerNode color_node_finds_a_user();
	}
}

color_node_finds_a_user()
{
	if ( isdefined( self.script_color_allies ) )
	{
		color_node_finds_user_from_colorcodes( self.script_color_allies, "allies" );
	}

	if ( isdefined( self.script_color_axis ) )
	{
		color_node_finds_user_from_colorcodes( self.script_color_axis, "axis" );
	}
}

color_node_finds_user_from_colorcodes( colorCodeString, team )
{
	if ( isdefined( self.color_user ) )
	{
		// If we successfully found a guy for this node then we shouldnt go find another
		return;
	}

	colorCodes = strtok( colorCodeString, " " );
	colorCodes = array_remove_dupes( colorCodes );

	array_levelthread( colorCodes, ::color_node_finds_user_for_colorCode, team );
}

color_node_finds_user_for_colorCode( colorCode, team )
{
	color = colorCode[ 0 ];
	assertex( colorIsLegit( color ), "Color " + color + " is not legit" );

	if ( !isdefined( level.currentColorForced[ team ][ color ] ) )
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

occupies_colorCode( colorCode )
{
	if ( !isdefined( self.currentColorCode ) )
	{
		return false;
	}

	return self.currentColorCode == colorCode;
}

ai_sets_goal_with_delay( node )
{
	self endon( "death" );
	delay = my_current_node_delays();
	if ( delay )
	{
		self endon( "stop_color_move" );
		// can get a stop color notify during the delay
		wait( delay );
	}

	thread ai_sets_goal( node );
}

ai_sets_goal( node )
{
	// makes AI stop trying to run to their chain of nodes in _spawner go_to_node
	self notify( "stop_going_to_node" );
	
	set_goal_and_volume( node );
	volume = level.arrays_of_colorCoded_volumes[ self get_team() ][ self.currentColorCode ];

	if ( isdefined( self.script_careful ) )
	{
		thread careful_logic( node, volume );
	}
}

set_goal_and_volume( node )
{
	if ( isdefined( self.colornode_func ) )
	{
		// run optional function
		self thread [[ self.colornode_func ]]( node );
	}
	
	if ( isdefined( self._colors_go_line ) )
	{
		self thread maps\_anim::anim_single_queue( self, self._colors_go_line );
		self._colors_go_line = undefined;
	}
	
	if ( isdefined( self.colornode_setgoal_func ) )
	{
		// run optional function
		self thread [[ self.colornode_setgoal_func ]]( node );
	}
	else
		self setgoalnode( node );
		
	if ( self is_using_forcegoal_radius( node ) )
		self thread forcegoal_radius( node );
	else if ( node.radius > 0 )
		self.goalradius = node.radius;

	volume = level.arrays_of_colorCoded_volumes[ self get_team() ][ self.currentColorCode ];
	if ( isdefined( volume ) )
	{
		self setFixedNodeSafeVolume( volume );
	}
	else
	{
		self clearFixedNodeSafeVolume();
	}

	if ( isdefined( node.fixedNodeSafeRadius ) )
	{
		self.fixedNodeSafeRadius = node.fixedNodeSafeRadius;
	}
	else
	{
		if( isdefined( level.fixednodesaferadius_default ) )
			self.fixedNodeSafeRadius = level.fixednodesaferadius_default;
		else
			self.fixedNodeSafeRadius = 64;
	}
}


is_using_forcegoal_radius( node )
{
	if ( !isdefined( self.script_forcegoal ) )
		return false;		

	if ( !self.script_forcegoal )
		return false;		

	if ( !isdefined( node.fixedNodeSafeRadius ) )
		return false;		

	if ( self.fixednode )
		return false;		

	else
		return true;
}

forcegoal_radius( node )
{
	self endon( "death" );
	self endon( "stop_going_to_node" );

	self.goalradius = node.fixedNodeSafeRadius;
	self waittill_either( "goal", "damage" );
	if ( node.radius > 0 )
		self.goalradius = node.radius;
}

careful_logic( node, volume )
{
	self endon( "death" );
	self endon( "stop_being_careful" );
	self endon( "stop_going_to_node" );
	thread recover_from_careful_disable( node );

	for ( ;; )
	{
		wait_until_an_enemy_is_in_safe_area( node, volume );
		use_big_goal_until_goal_is_safe( node, volume );

		self.fixednode = true;
		set_goal_and_volume( node );
	}
}

recover_from_careful_disable( node )
{
	self endon( "death" );
	self endon( "stop_going_to_node" );
	self waittill( "stop_being_careful" );

	self.fixednode = true;
	set_goal_and_volume( node );
}

use_big_goal_until_goal_is_safe( node, volume )
{
	self setgoalpos( self.origin );
	self.goalradius = 1024;
	self.fixednode = false;
	if ( isdefined( volume ) )
	{
		for ( ;; )
		{
			wait( 1 );
			if ( self isKnownEnemyInRadius( node.origin, self.fixedNodeSafeRadius ) )
				continue;
			if ( self isKnownEnemyInVolume( volume ) )
				continue;
			return;
		}
	}
	else
	{
		for ( ;; )
		{
// 			if ( !( self isKnownEnemyInRadius( node.origin, self.fixedNodeSafeRadius ) ) )
			if ( !( self isKnownEnemyInRadius_tmp( node.origin, self.fixedNodeSafeRadius ) ) )
				return;
			wait( 1 );
		}
	}
}

isKnownEnemyInRadius_tmp( node_origin, safe_radius )
{
	ai = getaiarray( "axis" );
	for ( i = 0 ; i < ai.size ; i++ )
	{
		if ( distance2d( ai[ i ].origin, node_origin ) < safe_radius )
			return true;
	}
	return false;
}

wait_until_an_enemy_is_in_safe_area( node, volume )
{
	if ( isdefined( volume ) )
	{
		for ( ;; )
		{
			if ( self isKnownEnemyInRadius( node.origin, self.fixedNodeSafeRadius ) )
				return;
			if ( self isKnownEnemyInVolume( volume ) )
				return;
			wait( 1 );
		}
	}
	else
	{
		for ( ;; )
		{
			if ( self isKnownEnemyInRadius_tmp( node.origin, self.fixedNodeSafeRadius ) )
				return;
			wait( 1 );
		}
	}
}

my_current_node_delays()
{
	if ( !isdefined( self.node ) )
		return false;

	return self.node script_delay();
}

process_color_order_to_ai( node, trigger, counter )
{
	thread decrementColorUsers( node );

	self endon( "stop_color_move" );
	self endon( "death" );

	if ( isdefined( trigger ) )
	{
		trigger script_delay();
	}

// 	waitSpread( delay_size * 0.5 );// they spread out the time they leave based on how many guys it is

	if ( !my_current_node_delays() )
	{
		if ( isdefined( counter ) )
		{
			wait( counter * randomfloatrange( 0.2, 0.35 ) );
		}
	}

	self ai_sets_goal( node );

	// record the node so the guy can find out who has his node, and get that guys
	self.color_ordered_node_assignment = node;

	for ( ;; )
	{
		self waittill( "node_taken", taker );
		if ( isplayer( taker ) )
		{
			// give time for the player to claim the node
			wait( 0.05 );
		}

		// lost our node so try to get a new one
		node = get_best_available_new_colored_node();
		if ( isdefined( node ) )
		{
			assertEx( !isalive( node.color_user ), "Node already had color user!" );
			if ( isalive( self.color_node.color_user ) && self.color_node.color_user == self )
				self.color_node.color_user = undefined;
			self.color_node = node;
			node.color_user = self;
			self ai_sets_goal( node );
		}
	}
}



get_best_available_colored_node()
{
	assertEx( self get_team() != "neutral" );
	assertEx( isdefined( self.script_forceColor ), "AI with export " + self.export + " lost his script_forcecolor.. somehow." );
	colorCode = level.currentColorForced[ self get_team() ][ self.script_forceColor ];

// 	nodes = level.arrays_of_colorCoded_nodes[ self get_team() ][ colorCode ];
	nodes = get_prioritized_colorCoded_nodes( self get_team(), colorCode, self.script_forcecolor );

	assertEx( nodes.size > 0, "Tried to make guy with export " + self.export + " go to forcecolor " + self.script_forceColor + " but there are no nodes of that color enabled" );
	for ( i = 0; i < nodes.size; i++ )
	{
		if ( !isalive( nodes[ i ].color_user ) )
			return nodes[ i ];
	}
}

get_best_available_new_colored_node()
{
	assertEx( self get_team() != "neutral" );
	assertEx( isdefined( self.script_forceColor ), "AI with export " + self.export + " lost his script_forcecolor.. somehow." );
	colorCode = level.currentColorForced[ self get_team() ][ self.script_forceColor ];
	nodes = get_prioritized_colorCoded_nodes( self get_team(), colorCode, self.script_forcecolor );

	assertEx( nodes.size > 0, "Tried to make guy with export " + self.export + " go to forcecolor " + self.script_forceColor + " but there are no nodes of that color enabled" );
	for ( i = 0; i < nodes.size; i++ )
	{
		if ( nodes[ i ] == self.color_node )
			continue;
		if ( !isalive( nodes[ i ].color_user ) )
			return nodes[ i ];
	}
}

process_stop_short_of_node( node )
{
	self endon( "stopScript" );
	self endon( "death" );

	if ( isdefined( self.node ) )
		return;

	// first check to see if we're right near it
	if ( distance( node.origin, self.origin ) < 32 )
	{
		reached_node_but_could_not_claim_it( node );
		return;
	}

	// if we're far away, maybe somebody cut us off then took our node, now we're stuck in limbo
	// so wait one second, if we're still in stop script( ie no killanimscripts ) then push the guy
	// off the node
// 	println( "waiting a second.." );
	currentTime = gettime();
	wait_for_killanimscript_or_time( 1 );
	newTime = gettime();

	// did we break out of stop fast enough to indicate we continued moving? If not, then reclaim the node		
	if ( newTime - currentTime >= 1000 )
		reached_node_but_could_not_claim_it( node );
}

wait_for_killanimscript_or_time( timer )
{
	self endon( "killanimscript" );
	wait( timer );
}


reached_node_but_could_not_claim_it( node )
{
	// reached our node but somebody else has it so we're gonna tell him to scram
// 	println( "Reached node " + node.origin );

	ai = getaiarray();
	guy = undefined;
	for ( i = 0;i < ai.size;i++ )
	{
		if ( !isdefined( ai[ i ].node ) )
			continue;
		if ( ai[ i ].node != node )
			continue;

		ai[ i ] notify( "eject_from_my_node" );
		wait( 1 );
		self notify( "eject_from_my_node" );
		return true;
	}
	return false;
}


decrementColorUsers( node )
{
	node.color_user = self;
	//assertEx( !isdefined( self.color_node ), "Decrement had color_node" );
	self.color_node = node;

	/*
	needs debugging cause it happened after a guy was attacked by a dog
	 /#
	assertEx( !isdefined( self.color_node_debug_val ), "Guy had double color_node_debug_val" );
	self.color_node_debug_val = true;
	#/
	*/

	self endon( "stop_color_move" );
	self waittill( "death" );
	self.color_node.color_user = undefined;
}

colorIsLegit( color )
{
	for ( i = 0; i < level.colorList.size; i++ )
	{
		if ( color == level.colorList[ i ] )
			return true;
	}
	return false;
}

add_volume_to_global_arrays( colorCode_string, team )
{
	colorCodes = strtok( colorCode_string, " " );
	colorCodes = array_remove_dupes( colorCodes );


	foreach ( colorCode in colorCodes )
	{
		assert( !isdefined( level.arrays_of_colorCoded_volumes[ team ][ colorCode ] ), "Multiple info_volumes exist with color code " + colorCode );

		level.arrays_of_colorCoded_volumes[ team ][ colorCode ] = self;
		level.arrays_of_colorCoded_ai[ team ][ colorCode ] = [];
		level.arrays_of_colorCoded_spawners[ team ][ colorCode ] = [];
	}
}

add_node_to_global_arrays( colorCode_string, team )
{
	self.color_user = undefined;
// 	assertEx( self.radius > 0, "Node " + self.type + " at origin " + self.origin + " does not have a radius set in Radiant." );
	colorCodes = strtok( colorCode_string, " " );
	colorCodes = array_remove_dupes( colorCodes );
	

	foreach ( colorCode in colorCodes )
	{
		if ( isdefined( level.arrays_of_colorCoded_nodes[ team ] ) && isdefined( level.arrays_of_colorCoded_nodes[ team ][ colorCode ] ) )
		{
			// array already exists so add this color coded node to that color code array.
			level.arrays_of_colorCoded_nodes[ team ][ colorCode ] = array_add( level.arrays_of_colorCoded_nodes[ team ][ colorCode ], self );
			continue;
		}

		// array doesn't exist so we have to initialize all the variables related to this color coding.
		level.arrays_of_colorCoded_nodes[ team ][ colorCode ][ 0 ] = self;
		level.arrays_of_colorCoded_ai[ team ][ colorCode ] = [];
		level.arrays_of_colorCoded_spawners[ team ][ colorCode ] = [];
	}
}

/* 
nodeusers()
{
	array_thread( getallnodes(), ::nodeThink );
}

nodeThink()
{
	if ( !isdefined( self.script_color_allies ) )
		return;
	
	for ( ;; )
	{
		if ( isdefined( self.color_users ) )
			print3d( self.origin + ( 0, 0, 16 ), "N - " + self.color_users, ( 1, 1, 1 ) );
		wait( 0.05 );
	}
}
*/ 

left_color_node()
{
	 /#
	self.color_node_debug_val = undefined;
	#/
	if ( !isdefined( self.color_node ) )
		return;
// 	assertEx( self.color_node.color_user == self, "Color Node user wasnt self!" );

	if ( isdefined( self.color_node.color_user ) && self.color_node.color_user == self )
		self.color_node.color_user = undefined;

	self.color_node = undefined;
	self notify( "stop_color_move" );
}


GetColorNumberArray()
{
	array = [];
	if ( issubstr( self.classname, "axis" ) || issubstr( self.classname, "enemy" ) || issubstr( self.classname, "team3" ) )
	{
		array[ "team" ] = "axis";
		array[ "colorTeam" ] = self.script_color_axis;
	}

	if ( ( issubstr( self.classname, "ally" ) ) || ( self.type == "civilian" ) )
	{
		array[ "team" ] = "allies";
		array[ "colorTeam" ] = self.script_color_allies;
	}

	if ( !isdefined( array[ "colorTeam" ] ) )
		array = undefined;

	return array;
}

/* 
removeAIFromColorNumberArray()
{
	colorNumberArray = GetColorNumberArray();
	if ( !isdefined( colorNumberArray ) )
		return;

	team = colorNumberArray[ "team" ];
	colorTeam = colorNumberArray[ "colorTeam" ];
		
	// remove this spawner from any array it was in
	colors = strtok( colorTeam, " " );
	for ( i = 0;i < colors.size;i++ )
		level.arrays_of_colorCoded_ai[ team ][ colors[ i ] ] = array_remove( level.arrays_of_colorCoded_ai[ team ][ colors[ i ] ], self );
	
	self notify( "stop_color_move" );// clear out any existing color / number processes
}
*/ 

removeSpawnerFromColorNumberArray()
{
	colorNumberArray = GetColorNumberArray();
	if ( !isdefined( colorNumberArray ) )
		return;

	team = colorNumberArray[ "team" ];
	colorTeam = colorNumberArray[ "colorTeam" ];

	// remove this spawner from any array it was in
	colors = strtok( colorTeam, " " );
	colors = array_remove_dupes( colors );
	
	for ( i = 0;i < colors.size;i++ )
		level.arrays_of_colorCoded_spawners[ team ][ colors[ i ] ] = array_remove( level.arrays_of_colorCoded_spawners[ team ][ colors[ i ] ], self );
}


add_cover_node( type )
{
	level.color_node_type_function[ type ][ true ][ "allies" ] = ::process_cover_node_with_last_in_mind_allies;
	level.color_node_type_function[ type ][ true ][ "axis" ] = ::process_cover_node_with_last_in_mind_axis;
	level.color_node_type_function[ type ][ false ][ "allies" ] = ::process_cover_node;
	level.color_node_type_function[ type ][ false ][ "axis" ] = ::process_cover_node;
}

add_path_node( type )
{
	level.color_node_type_function[ type ][ true ][ "allies" ] = ::process_path_node;
	level.color_node_type_function[ type ][ false ][ "allies" ] = ::process_path_node;
	level.color_node_type_function[ type ][ true ][ "axis" ] = ::process_path_node;
	level.color_node_type_function[ type ][ false ][ "axis" ] = ::process_path_node;
}


// ColorNode respawn system

colorNode_spawn_reinforcement( classname, fromColor )
{
	level endon( "kill_color_replacements" );
	level endon( "kill_hidden_reinforcement_waiting" );
	
	reinforcement = spawn_hidden_reinforcement( classname, fromColor );
	if ( isdefined( level.friendly_startup_thread ) )
		reinforcement thread [[ level.friendly_startup_thread ]]();

	reinforcement thread colorNode_replace_on_death();
}

colorNode_replace_on_death()
{
	level endon( "kill_color_replacements" );

	assertex( isalive( self ), "Tried to do replace on death on something that was not alive" );
	self endon( "_disable_reinforcement" );

	if ( isdefined( self.replace_on_death ) )
		return;

	self.replace_on_death = true;
	assertEx( !isdefined( self.respawn_on_death ), "Guy with export " + self.export + " tried to run respawn on death twice." );

	// when a red or green guy dies, an orange guy becomes a red guy
	// when an orange guy dies, a yellow guy becomes an orange guy	
	classname = self.classname;
	color = self.script_forceColor;

	// if we spawn a new guy with spawn_reinforcement, he needs to get his color assignment before he checks his forcecolor
	waittillframeend;

	if ( isalive( self ) )
	{
		// could've died in waittillframeend
		self waittill( "death" );
	}

	color_order = level.current_color_order;

	if ( !isdefined( self.script_forceColor ) )
		return;

	// spawn a replacement yellow guy
	thread colorNode_spawn_reinforcement( classname, self.script_forceColor );

	if ( isdefined( self ) && isdefined( self.script_forceColor ) )
		color = self.script_forceColor;

	if ( isdefined( self ) && isdefined( self.origin ) )
		origin = self.origin;


	// a replacement has been spawned, so now promote somebody to our color
	for ( ;; )
	{
		if ( get_color_from_order( color, color_order ) == "none" )
			return;

		correct_colored_friendlies = get_force_color_guys( "allies", color_order[ color ] );
		if ( !isdefined( level.color_doesnt_care_about_heroes ) )
			correct_colored_friendlies = remove_heroes_from_array( correct_colored_friendlies );
		if ( !isdefined( level.color_doesnt_care_about_classname ) )
			correct_colored_friendlies = remove_without_classname( correct_colored_friendlies, classname );

		if ( !correct_colored_friendlies.size )
		{
			// nobody of the correct color existed, so give them more time to spawn
			wait( 2 );
			continue;
		}

		correct_colored_guy = getclosest( level.player.origin, correct_colored_friendlies );
		assertEx( correct_colored_guy.script_forceColor != color, "Tried to replace a " + color + " guy with a guy of the same color!" );

		// have to wait until the end of the frame because the guy may have just spawned and been given his forcecolor, 
		// and you cant give a guy forcecolor twice in one frame currently.		
		waittillframeend;
		if ( !isalive( correct_colored_guy ) )
		{
			// if he died during the frame then try again!
			continue;
		}

		correct_colored_guy set_force_color( color );

		// should something special happen when a guy is promoted? Like a change in threatbias group?
		if ( isdefined( level.friendly_promotion_thread ) )
		{
			correct_colored_guy [[ level.friendly_promotion_thread ]]( color );
		}

		color = color_order[ color ];
	}
}

get_color_from_order( color, color_order )
{
	if ( !isdefined( color ) )
		return "none";

	if ( !isdefined( color_order ) )
		return "none";

	if ( !isdefined( color_order[ color ] ) )
		return "none";

	return color_order[ color ];
}

friendly_spawner_vision_checker()
{
	level.friendly_respawn_vision_checker_thread = true;
	// checks to see if the player is looking at the friendly spawner

	successes = 0;
	for ( ;; )
	{
		//flag_waitopen( "respawn_friendlies" );
		for ( ;; )
		{
			if ( !respawn_friendlies_without_vision_check() )
				break;
				
			wait( 0.05 );
		}
		wait( 1 );
		// friendly_respawn is disabled but if the player is far enough away and looking away
		// from the spawner then we can still spawn from it.
		if ( !isdefined( level.respawn_spawner_org ) )
			continue;

		difference_vec = level.player.origin - level.respawn_spawner_org;
		if ( length( difference_vec ) < 200 )
		{
			player_sees_spawner();
			continue;
		}

	    forward = anglesToForward( ( 0, level.player getplayerangles()[ 1 ], 0 ) );
		difference = vectornormalize( difference_vec );
	    dot = vectordot( forward, difference );
		if ( dot < 0.2 )
		{
			player_sees_spawner();
			continue;
		}

		successes++ ;
		if ( successes < 3 )
			continue;

		// player has been looking away for 3 seconds
		flag_set( "player_looks_away_from_spawner" );
	}
}

get_color_spawner( classname )
{
	if ( isdefined( classname ) )
	{
		// the spawner we were using was deleted
		if ( !isdefined( level._color_friendly_spawners[ classname ] ) )
		{
			spawners = getspawnerteamarray( "allies" );
			foreach ( spawner in spawners )
			{
				if ( spawner.classname != classname )
					continue;
				
				level._color_friendly_spawners[ classname ] = spawner;
				break;
			}
		}
	}
		
	// if the classname is not set, just use the global respawn spawner
	if ( !isdefined( classname ) )
	{
		spawner = random( level._color_friendly_spawners );
		if ( !isdefined( spawner ) )
		{
			// that spawner is gone, rebuild it.
			spawners = [];
			foreach ( index, spawner in level._color_friendly_spawners )
			{
				if ( isdefined( spawner ) )
					spawners[ index ] = spawner;
			}
			
			level._color_friendly_spawners = spawners;
			
			return random( level._color_friendly_spawners );
		}
		
		return spawner;
	}

	return level._color_friendly_spawners[ classname ];
}

respawn_friendlies_without_vision_check()
{
	if ( isdefined( level.respawn_friendlies_force_vision_check ) )
		return false;

	return flag( "respawn_friendlies" );
}

wait_until_vision_check_satisfied_or_disabled()
{
	if ( flag( "player_looks_away_from_spawner" ) )
		return;
	level endon( "player_looks_away_from_spawner" );
	
	for ( ;; )
	{
		if ( respawn_friendlies_without_vision_check() )
			return;
		wait( 0.05 );
	}
}

spawn_hidden_reinforcement( classname, fromColor )
{
	level endon( "kill_color_replacements" );
	level endon( "kill_hidden_reinforcement_waiting" );
	
	spawn = undefined;
	for ( ;; )
	{
		if ( !respawn_friendlies_without_vision_check() )
		{
			if ( !isdefined( level.friendly_respawn_vision_checker_thread ) )
				thread friendly_spawner_vision_checker();

			// have to break if respawn_friendlies gets enabled because that disables the
			// fov check that toggles player_looks_away_from_spawner.
			for ( ;; )
			{
				wait_until_vision_check_satisfied_or_disabled();
				flag_waitopen( "friendly_spawner_locked" );
				if ( flag( "player_looks_away_from_spawner" ) || respawn_friendlies_without_vision_check() )
					break;
			}
			flag_set( "friendly_spawner_locked" );
		}

		spawner = get_color_spawner( classname );
		spawner.count = 1;
		oldorg = spawner.origin;
		spawner.origin = level.respawn_spawner_org;
//		assertEx( spawner.spawnflags & 4, "Friendly color spawner with export " + spawner.export + " does not have UNDELETEABLE checkbox." );
		spawn = spawner stalingradspawn();

		spawner.origin = oldorg;
		
		if ( spawn_failed( spawn ) )
		{
			thread lock_spawner_for_awhile();
			wait( 1 );
			continue;
		}
		level notify( "reinforcement_spawned", spawn );
		break;
	}

	// figure out which color the spawned guy should be
	for ( ;; )
	{
		if ( !isdefined( fromColor ) )
			break;

		if ( get_color_from_order( fromColor, level.current_color_order ) == "none" )
			break;
		fromColor = level.current_color_order[ fromColor ];
	}
	if ( isdefined( fromColor ) )
		spawn set_force_color( fromColor );

	thread lock_spawner_for_awhile();
	return spawn;
}

lock_spawner_for_awhile ()
{
	flag_set( "friendly_spawner_locked" );
	wait( 2 );
	flag_clear( "friendly_spawner_locked" );
}

player_sees_spawner()
{
	successes = 0;
	flag_clear( "player_looks_away_from_spawner" );
}


kill_color_replacements()
{
	// kills ALL color respawning
	flag_clear( "friendly_spawner_locked" );
	level notify( "kill_color_replacements" );
	ai = getaiarray();
	array_thread( ai, ::remove_replace_on_death );
}

remove_replace_on_death()
{
	self.replace_on_death = undefined;
}

get_team( team )
{
	if ( isdefined( self.team ) && !isdefined( team ) )
		team = self.team;
	// tmp stuff for making colors work on team 3.
	return( level.color_teams[ team ] );
}
