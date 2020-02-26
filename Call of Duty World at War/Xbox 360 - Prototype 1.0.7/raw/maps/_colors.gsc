#include maps\_utility;
/*

	Color coded AI travel system
	A colorCode is a color (red, blue, yellow, cyan, green, purple or orange) and a #.
	When a trigger and AI and node are color grouped in Radiant, they get a unique color and #.
	When when a color coded trigger is hit, that colorCode is "fired" and any AI that are in colorCoded mode get their goalnode set.

	AI can be forced to a color generically. For example if an AI is forced to the color "red" and a trigger fires off "red15", the AI
	will go to that node even if the AI doesn't have script_color_allies (or axis) "red15". This is mainly for friendlies.

*/

init_color_grouping(nodes)
{
	// friendly spawner global stuff
	flag_init( "player_looks_away_from_spawner" );
	flag_init( "friendly_spawner_locked" );
	
//	wait(0.05); // begone infinite hangs
	level.arrays_of_colorCoded_nodes = [];
	level.arrays_of_colorCoded_nodes[ "axis" ] = [];
	level.arrays_of_colorCoded_nodes[ "allies" ] = [];
	triggers = [];
	triggers = array_combine(triggers,  getentarray("trigger_multiple"	,"classname"));
	triggers = array_combine(triggers,  getentarray("trigger_radius"	,"classname"));
	triggers = array_combine(triggers,  getentarray("trigger_once"		,"classname"));

	// go through all the nodes and if they have color codes then add them too
	for (i=0;i<nodes.size;i++)
	{
		if (isdefined(nodes[i].script_color_allies))
			nodes[i] add_node_to_global_arrays(nodes[i].script_color_allies, "allies");
		if (isdefined(nodes[i].script_color_axis))
			nodes[i] add_node_to_global_arrays(nodes[i].script_color_axis, "axis");
	}

	// triggers that have color codes wait for trigger and then fire their colorcode
	for (i=0;i<triggers.size;i++)
	{
		if (isdefined(triggers[i].script_color_allies))
			triggers[i] thread trigger_issues_orders( triggers[i].script_color_allies, "allies" );
		if (isdefined(triggers[i].script_color_axis))
			triggers[i] thread trigger_issues_orders( triggers[i].script_color_axis, "axis" );
	}

	/#
		level.colorNodes_debug_array = [];
		level.colorNodes_debug_array[ "allies" ] = [];
		level.colorNodes_debug_array[ "axis" ] = [];
		
//		level.colorNodes_debug_ai = [];
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
	add_path_node( "Path" );
	
	level.colorList = [];
	level.colorList[level.colorList.size] = "r";
	level.colorList[level.colorList.size] = "b";
	level.colorList[level.colorList.size] = "y";
	level.colorList[level.colorList.size] = "c";
	level.colorList[level.colorList.size] = "g";
	level.colorList[level.colorList.size] = "p";
	level.colorList[level.colorList.size] = "o";
	
	level.colorCheckList["red"] 	= "r";
	level.colorCheckList["r"] 		= "r";
	level.colorCheckList["blue"] 	= "b";
	level.colorCheckList["b"] 		= "b";
	level.colorCheckList["yellow"] 	= "y";
	level.colorCheckList["y"] 		= "y";
	level.colorCheckList["cyan"] 	= "c";
	level.colorCheckList["c"] 		= "c";
	level.colorCheckList["green"] 	= "g";
	level.colorCheckList["g"] 		= "g";
	level.colorCheckList["purple"] 	= "p";
	level.colorCheckList["p"] 		= "p";
	level.colorCheckList["orange"] 	= "o";
	level.colorCheckList["o"] 		= "o";

	level.currentColorForced = [];
	level.currentColorForced["allies"] = [];
	level.currentColorForced["axis"] = [];

	level.lastColorForced = [];
	level.lastColorForced["allies"] = [];
	level.lastColorForced["axis"] = [];

	for ( i = 0; i < level.colorList.size; i++)
	{
		level.arrays_of_colorForced_ai["allies"][level.colorList[i]] = [];
		level.arrays_of_colorForced_ai["axis"][level.colorList[i]] = [];
		level.currentColorForced["allies"][level.colorList[i]] = undefined;
		level.currentColorForced["axis"][level.colorList[i]] = undefined;
	}
	
	array_thread (getaiarray(), ::ai_picks_destination);
	array_thread (getspawnerarray(), ::spawner_processes_colorCoded_ai);
}

convert_color_to_short_string()
{
	// shorten the forcecolors tring to a single letter
	self.script_forceColor = level.colorCheckList[ self.script_forceColor ];
}

ai_picks_destination(currentColorCode)
{ 
	if (isdefined(self.script_forcecolor))
	{
		convert_color_to_short_string();
		// axis don't do node behavior if they're forcecolor.
		if ( self.team == "axis" )
		{
			ai_follow_the_leader_behavior();
			return;
		}
					
		self.currentColorCode = currentColorCode;
		color = self.script_forcecolor;
		assert(colorIsLegit(color), "AI at origin " + self.origin + " has non-legit forced color " + color + ". Legit colors are red blue yellow cyan green purple and orange.");
		level.arrays_of_colorForced_ai[self.team][color] = array_add(level.arrays_of_colorForced_ai[self.team][color], self);
		thread goto_current_ColorIndex();
		return;
	}
	
	colorTeam = undefined;	
	if (issubstr(self.classname,"axis") || issubstr(self.classname,"enemy"))
	{
		assertEx (!isdefined(self.script_color_allies), "Axis at origin " + self.origin + " has script_color_allies!");
		if (!isdefined(self.script_color_axis))
			return;
		colorTeam = self.script_color_axis;
	}
	
	if ( (issubstr(self.classname,"ally")) || (issubstr(self.classname,"civilian")) )
	{
		assertEx (!isdefined(self.script_color_axis), "Ally at origin " + self.origin + " has script_color_axis!");
		if (!isdefined(self.script_color_allies))
			return;
		colorTeam = self.script_color_allies;
	}
	
	colorCodes = strtok( colorTeam, " " );
	for (i=0;i<colorCodes.size;i++)
	{
		self.currentColorCode = currentColorCode;
		assertEx (isdefined(level.arrays_of_colorCoded_ai[self.team][colorCodes[i]]), "AI at origin " + self.origin + " has script_color " + colorCodes[i] + " which does not exist on any nodes");
		level.arrays_of_colorCoded_ai[self.team][colorCodes[i]] = array_add(level.arrays_of_colorCoded_ai[self.team][colorCodes[i]], self);
		thread goto_current_ColorIndex();
	}
}

goto_current_ColorIndex()
{
	if (!isdefined(self.currentColorCode))
		return;
	
	nodes = level.arrays_of_colorCoded_nodes[self.team][self.currentColorCode];
	color_users = 0;
	
	self left_color_node();
	// can be deleted/killed during left_color_node
	if ( !isalive( self ) )
		return;
	
	for (;;)
	{
		for (i=0;i<nodes.size;i++)
		{
			if (nodes[i].color_users > color_users)
				continue;
				
			self ai_sets_goal( nodes[i] );
			self.goalradius = nodes[i].radius;
			thread decrementColorUsers(nodes[i]);
			return;
		}
		color_users++;
	}
	
}

spawner_processes_colorCoded_ai()
{
	self endon ("new_color_code");

	axis = (issubstr(self.classname,"axis") || issubstr(self.classname,"enemy"));
	
	// axis don't do forcecolor
	if ( isdefined( self.script_forceColor ) && axis )
	{
		thread spawner_follow_the_leader_behavior();
		return;
	}

	/#
	if (isdefined(self.script_color_axis) || isdefined(self.script_color_allies))
	{
		assertEx(!isdefined(self.script_forceColor), "Can't have script_color_axis/allies and script_forceColor on the spawn spawner.");
	}
	else
	{
		if (isdefined(self.script_forceColor))
			assertEx(!isdefined(self.script_color_axis) && !isdefined(self.script_color_allies), "Can't have script_color_axis/allies and script_forceColor on the spawn spawner.");
	}
	#/
	
	colorTeam = undefined;
	forceTeam = undefined;
	team = undefined;
	
	if ( axis )
	{
		assertEx (!isdefined(self.script_color_allies), "Axis spawner at origin " + self.origin + " has script_color_allies!");
		if (!isdefined(self.script_color_axis) && !isdefined(self.script_forcecolor))
			return;
		colorTeam = self.script_color_axis;
		team = "axis";
	}
	
	if ( (issubstr(self.classname,"ally")) || (issubstr(self.classname,"civilian")) )
	{
		assertEx (!isdefined(self.script_color_axis), "Ally spawner at origin " + self.origin + " has script_color_axis!");
		if (!isdefined(self.script_color_allies) && !isdefined(self.script_forcecolor))
			return;
		colorTeam = self.script_color_allies;
		team = "allies";
	}
	
	
	if (isdefined(colorTeam))
	{
		colorCodes = strtok( colorTeam, " " );
		for ( i=0; i < colorCodes.size; i++ )
		{
			if ( !isdefined( level.arrays_of_colorCoded_spawners[ team ][ colorCodes[ i ] ] ) )
				continue;

			level.arrays_of_colorCoded_spawners[ team ][ colorCodes[ i ] ] = array_add( level.arrays_of_colorCoded_spawners[ team ][ colorCodes[ i ] ], self );
		}
	}

	self endon ("death");
	
	for (;;)
	{
		self waittill ("spawned",spawn);
		if (spawn_failed(spawn))
			continue;
			
		if (isdefined(self.script_forceColor))
			self.currentColorCode = level.currentColorForced[team][self.script_forceColor];

		spawn thread ai_picks_destination(self.currentColorCode);
	}
}

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
	

trigger_issues_orders( color_team, team )
{
	self endon( "death" );
	colorCodes = strtok( color_team, " " );
	colors = [];
	colorCodesByColorIndex = [];
	usable_colorCodes = [];
	
	colorList = get_color_list();
	
	for ( i = 0; i < colorCodes.size; i++ )
	{
		color = undefined;
		for ( p = 0; p < colorList.size; p++ )
		{
			if ( issubstr( colorCodes[ i ], colorList[ p ] ) )
			{
				color = colorList[ p ];
				break;
			}
		}

		// does this order actually tie to existing nodes?
		if ( !isdefined( level.arrays_of_colorCoded_nodes[ "allies" ][ colorCodes[i] ] ) && !isdefined( level.arrays_of_colorCoded_nodes[ "axis" ][ colorCodes[i] ] ) )
			continue;
		
		assertEx( isdefined( color ), "Trigger at origin " + self getorigin() + " had strange color index " + colorCodes[i]);
		
		colorCodesByColorIndex[color] = colorCodes[i];
		colors[colors.size] = color;
		usable_colorCodes[ usable_colorCodes.size ] = colorCodes[i];
	}
	
	// color codes that don't tie to existing nodes have been culled
	colorCodes = usable_colorCodes;
	
	for (;;)
	{
		self waittill( "trigger" );

		waittillframeend; // give spawners activated by this trigger a chance to spawn their AI
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

		for ( i = 0; i < colors.size; i++ )
		{
			// remove the dead from the color forced ai
			level.arrays_of_colorForced_ai[ team ][ colors[ i ] ] = array_removeDead( level.arrays_of_colorForced_ai[ team ][ colors[ i ] ] );
			
			// set the last color forced so we can compare it with current when we tell guys to go to nodes,
			// so they can prefer new nodes over old ones, so they move up
			level.lastColorForced[ team ][ colors[ i ] ] = level.currentColorForced[ team ][ colors[ i ] ];

			// set the destination of the color forced spawners
			level.currentColorForced[ team ][ colors[ i ] ] = colorCodesByColorIndex[ colors[ i ] ];
		}
		
		for ( i = 0; i < colorCodes.size; i++)
		{
			if ( !isdefined( level.arrays_of_colorCoded_ai[ team ][ colorCodes[ i ] ] ) )
				continue;
			self thread issue_color_order_to_ai( colorCodes[ i ], colors[ i ], team );
		}
	}
}

process_cover_node_with_last_in_mind_allies( node, lastColor )
{
	// nodes that were in the last color order go at the end
	if ( issubstr( node.script_color_allies, lastColor ) )
		self.cover_nodes_last[ self.cover_nodes_last.size ] = node;
	else
		self.cover_nodes_first[ self.cover_nodes_first.size ] = node;
}

process_cover_node_with_last_in_mind_axis( node, lastColor )
{
	// nodes that were in the last color order go at the end
	if ( issubstr( node.script_color_axis, lastColor ) )
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

issue_color_order_to_ai(colorCode, color, team)
{
	// remove dead from this specific colorCode
	level.arrays_of_colorCoded_ai[team][colorCode] = array_removeDead(level.arrays_of_colorCoded_ai[team][colorCode]);
	ai = level.arrays_of_colorCoded_ai[team][colorCode];
	ai = array_combine(ai, level.arrays_of_colorForced_ai[team][color]);
	newArray = [];
	for (i=0;i<ai.size;i++)
	{
		// ignore AI that are already going to this colorCode
		if (isdefined(ai[i].currentColorCode) && ai[i].currentColorCode == colorCode)
			continue;
		newArray[newArray.size] = ai[i];
	}

	ai = newArray;
	if (!ai.size)
		return;

	for ( i=0; i < ai.size; i++ )
		ai[ i ] left_color_node();

	// can be deleted during left_color_node
	ai = remove_dead_from_array( ai );

	original_ai_array = ai;

	
	nodes = level.arrays_of_colorCoded_nodes[ team ][ colorCode ];

	// need a place to store the nodes externally so we can put the pathnodes in the back
	ent = spawnstruct();
	ent.path_nodes = [];
	ent.cover_nodes_first = [];
	ent.cover_nodes_last = [];

	lastColorForced_exists = ( isdefined( level.lastColorForced[ team ][ color ] ) );

	// fills ent.path_nodes or .cover_nodes depending on node type	
	for ( i=0 ; i < nodes.size; i++ )
	{
		node = nodes[ i ];
		ent [[ level.color_node_type_function[ node.type ][ lastColorForced_exists ][ team ] ]]( node, level.lastColorForced[ team ][ color ] );
	}
	
	ent.cover_nodes_first = array_randomize( ent.cover_nodes_first );
	nodes = ent.cover_nodes_first;
	
	// put the path nodes at the end of the array so they're less favored
	for ( i=0; i < ent.cover_nodes_last.size; i++ )
	{
		nodes[ nodes.size ] = ent.cover_nodes_last[ i ];
	}

	for ( i=0; i < ent.path_nodes.size; i++ )
	{
		nodes[ nodes.size ] = ent.path_nodes[ i ];
	}
	
	/#
	level.colorNodes_debug_array[ team ][ colorCode ] = nodes;
	#/
	
	color_users = 0;
	
	debounceTime = 1.2 / ai.size;
	
	if ( nodes.size < ai.size )
		println("^3Warning, ColorNumber system tried to make " + ai.size + " AI go to " + nodes.size + " nodes.");
	
	for (;;)
	{
		ai_count = ai.size;
		for ( i=0; i < nodes.size; i++ )
		{
			node = nodes[i];
			// add guys to the nodes with the fewest AI on them
			if ( node.color_users > color_users )
				continue;

			closestAI = getclosest( node.origin, ai );
  			assert( isalive( closestAI ) );
			ai = array_remove( ai, closestAI );

			closestAI notify( "new_color_order" );
			closestAI.currentColorCode = colorCode;			
			closestAI thread process_color_order_to_ai( node, self, ai_count, original_ai_array );

			closestAI thread decrementColorUsers( node );

			if ( !ai.size )
				return;
		}
		
		color_users++;
	}
}

ai_sets_goal( node )
{
//	level.colorNodes_debug_ai[ self.ai_number ] = self.currentColorCode;

	// makes AI stop trying to run to their chain of nodes in _spawner go_to_node
	self notify( "stop_going_to_node" );
	self setgoalnode( node );
}


process_color_order_to_ai( node, trigger, delay_size, ai )
{
	self endon("new_color_order");
	self endon("stop_color_move");
	self endon("death");

	trigger script_delay();
	waitSpread( delay_size * 0.5 ); // they spread out the time they leave based on how many guys it is
	self ai_sets_goal( node );
	self.goalradius = node.radius;

	// record the node so the guy can find out who has his node, and get that guys
	self.color_ordered_node_assignment = node;

	wait (0.05);
	if ( isdefined( self.node ) )
		return;
	
	for (;;)
	{
		newNode = undefined;
		
		// get the guy that is going to my node
		for( i=0; i<ai.size; i++ )
		{
			if ( !isalive( ai[i] ) )
				continue;
			if ( ai[i] == self )
				continue;
			if ( !isdefined( ai[i].node ) )
				continue;
			if ( ai[i].node != node )
				continue;

			// get the node he was originally assigned to			
			newNode = ai[i].color_ordered_node_assignment;
		}
		
		if ( !isdefined( newNode ) )
		{
//			println ("Failed to find a new node for a guy that had his node stolen!");
			return;
		}

		node = newNode;		
		self ai_sets_goal( node );
		self.goalradius = node.radius;
//		println ("Trying to send a guy to a new node because his was taken");
		wait (0.05);
		if ( isdefined( self.node ) )
			return;
//		println ("..failed");
	}
	
//	self thread respond_to_forcing_to_leave_node ( node );
	// changing this to a new approach shortly
	/*

	for (;;)
	{
		self waittill ("stopScript");
		thread process_stop_short_of_node( node );
	}
	*/
}

process_stop_short_of_node( node )
{
	self endon ("stopScript");
	self endon ("death");

	if (isdefined(self.node))
		return;
		
	// first check to see if we're right near it
	if (distance(node.origin, self.origin) < 32)
	{
		reached_node_but_could_not_claim_it(node);
		return;
	}
		
	// if we're far away, maybe somebody cut us off then took our node, now we're stuck in limbo
	// so wait one second, if we're still in stop script (ie no killanimscripts) then push the guy
	// off the node
//	println("waiting a second..");
	currentTime = gettime();
	wait_for_killanimscript_or_time(1);
	newTime = gettime();

	// did we break out of stop fast enough to indicate we continued moving? If not, then reclaim the node		
	if (newTime - currentTime >= 1000)
		reached_node_but_could_not_claim_it(node);
}

wait_for_killanimscript_or_time ( timer )
{
	self endon ("killanimscript");
	wait (timer);
}


reached_node_but_could_not_claim_it ( node )
{
	// reached our node but somebody else has it so we're gonna tell him to scram
//	println("Reached node " + node.origin);

	ai = getaiarray();
	guy = undefined;
	for (i=0;i<ai.size;i++)
	{
		if (!isdefined(ai[i].node))
			continue;
		if (ai[i].node != node)
			continue;
		
		ai[i] notify ("eject_from_my_node");
		wait (1);
		self notify ("eject_from_my_node");
		return true;
	}
	return false;
}

respond_to_forcing_to_leave_node ( node )
{
	self endon("new_color_order");
	self endon("death");

	for (;;)
	{
		self waittill ("eject_from_my_node");
		radius = self.goalradius;
		self.goalradius = 16;
		self ai_sets_goal( node );
		wait (1);
		self.goalradius = radius;
	}
}

decrementColorUsers(node)
{
	node.color_users++;
	self waittill_either ("death", "left_color_node");
	node.color_users--;
}

colorIsLegit(color)
{
	for ( i = 0; i < level.colorList.size; i++)
	{
		if (color == level.colorList[i])
			return true;
	}
	return false;
}

add_node_to_global_arrays(colorTeam, team)
{
	self.color_users = 0;
	assertEx (self.radius > 0, "Node " + self.type + " at origin " + self.origin + " does not have a radius set in Radiant.");
	colors = strtok( colorTeam, " " );
	for (p=0;p<colors.size;p++)
	{
		if (isdefined (level.arrays_of_colorCoded_nodes[team]) && isdefined (level.arrays_of_colorCoded_nodes[team][colors[p]]))
		{
			// array already exists so add this color coded node to that color code array.
			level.arrays_of_colorCoded_nodes[team][colors[p]] = array_add(level.arrays_of_colorCoded_nodes[team][colors[p]], self);
			continue;
		}		

		// array doesn't exist so we have to initialize all the variables related to this color coding.
		level.arrays_of_colorCoded_nodes[team][colors[p]][0] = self;
		level.arrays_of_colorCoded_ai[team][colors[p]] = [];
		level.arrays_of_colorCoded_spawners[team][colors[p]] = [];
	}
}

/*
nodeusers()
{
	array_thread(getallnodes(),::nodeThink);
}

nodeThink()
{
	if (!isdefined(self.script_color_allies))
		return;
	
	for (;;)
	{
		if (isdefined (self.color_users))
			print3d(self.origin + (0,0,16), "N-" + self.color_users, (1,1,1));
		wait (0.05);
	}
}
*/

left_color_node()
{
	self notify ("left_color_node"); // so we deceremnt the # of users on that node
	waittillframeend; // so the node can get the notify and be effected
}


GetColorNumberArray()
{	
	array = [];
	if (issubstr(self.classname,"axis") || issubstr(self.classname,"enemy"))
	{
		array["team"] = "axis";
		array["colorTeam"] = self.script_color_axis;
	}
	
	if ( (issubstr(self.classname,"ally")) || (issubstr(self.classname,"civilian")) )
	{
		array["team"] = "allies";
		array["colorTeam"] = self.script_color_allies;
	}

	if (!isdefined(array["colorTeam"]))
		array = undefined;
	
	return array;
}

removeAIFromColorNumberArray()
{
	colorNumberArray = GetColorNumberArray();
	if (!isdefined(colorNumberArray))
		return;

	team = colorNumberArray["team"];
	colorTeam = colorNumberArray["colorTeam"];
		
	// remove this spawner from any array it was in
	colors = strtok( colorTeam, " " );
	for (i=0;i<colors.size;i++)
		level.arrays_of_colorCoded_ai[team][colors[i]] = array_remove (level.arrays_of_colorCoded_ai[team][colors[i]], self);
	
	
	self notify ("new_color_order"); // clear out any existing color/number processes
}

removeSpawnerFromColorNumberArray()
{
	colorNumberArray = GetColorNumberArray();
	if (!isdefined(colorNumberArray))
		return;

	team = colorNumberArray["team"];
	colorTeam = colorNumberArray["colorTeam"];

	// remove this spawner from any array it was in
	colors = strtok( colorTeam, " " );
	for (i=0;i<colors.size;i++)
		level.arrays_of_colorCoded_spawners[team][colors[i]] = array_remove (level.arrays_of_colorCoded_spawners[team][colors[i]], self);
}

leaderThink()
{
	self.goalradius = 5000;
	self waittill( "death" );
	
	livingFollowers = [];
	for ( i=0; i<self.followers.size; i++ )
	{
		if ( isalive( self.followers[i] ) )
			livingFollowers[ livingFollowers.size ] = self.followers[i];
	}
	
	if ( livingFollowers.size < 1 )
		return;

	leader = livingFollowers[0];
	leader.goalradius = 5000;
	leader.followers = [];
	leader thread leaderThink();

	for ( i=1; i<livingFollowers.size; i++ )
	{
		livingFollowers[i] thread followerThink( leader );
		leader.followers[ leader.followers.size ] = livingFollowers[i];
	}
}

followerThink( leader )
{
	self endon( "death" );
	leader endon( "death" );
	self.goalradius = 250;

	for (;;)
	{
		leaderGoal = undefined;
		if ( isdefined( leader.node ) )
			leaderGoal = leader.node.origin;
		else
			leaderGoal = leader.origin;
			
		if ( distance( leaderGoal, self.origin ) > self.goalradius )
		{
			if ( isdefined( leader.node ) )
				self setgoalnode( leader.node );
			else
				self setgoalpos( leader.origin );
		}

		wait (0.1);
	}
}


ai_follow_the_leader_behavior()
{
	if ( spawn_failed( self ) )
		return;

	follow_the_leader_behavior();
}

follow_the_leader_behavior()
{
	assert( isdefined( self.script_forcecolor ) );
	color = self.script_forcecolor;
	// start an array that will get filled with all the guys of this color that spawn in this frame or exist in this frame if its the first frame
	if ( !isdefined( level.follow_the_leader ) )
		level.follow_the_leader = [];

	if ( !isdefined( level.follow_the_leader[ color ] ) )
	{
		level.follow_the_leader[ color ] = [];
	
		// add him to the array		
		level.follow_the_leader[ color ][ level.follow_the_leader[ color ].size ] = self;
		waittillframeend;
	
		// now all the guys of this color should be in the array
		ai = level.follow_the_leader[ color ];
		leader = undefined;
		
		for ( i=0; i<ai.size; i++)
		{
			guy = ai[i];
			if ( !isdefined( leader ) )
			{
				leader = guy;
				leader.followers = [];
				leader thread leaderThink();
				continue;
			}
	
			leader.followers[ leader.followers.size ] = guy;
			guy thread followerThink( leader );
			
			if ( leader.followers.size >= 2 )
				leader = undefined;
		}	
		
	
		// clear the array so that the next time it occurs, the array will be empty
		level.follow_the_leader[ color ] = undefined;
		return;
	}

	// if we weren't the one that created the array then we just get added to it and the
	// first one to run it will do the actual logic
	level.follow_the_leader[ color ][ level.follow_the_leader[ color ].size ] = self;
		
}

spawner_follow_the_leader_behavior()
{
	for (;;)
	{
		self waittill( "spawned", spawn );
		if ( spawn_failed( spawn ) )
			continue;
		spawn thread follow_the_leader_behavior();
	}
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
	reinforcement = spawn_hidden_reinforcement( classname, fromColor );
	if ( isdefined( level.friendly_startup_thread ) )
		reinforcement thread [[ level.friendly_startup_thread ]]();

	reinforcement thread colorNode_replace_on_death();
}


colorNode_replace_on_death()
{
	self endon( "disable_reinforcement" );
	assertEx( !isdefined( self.respawn_on_death ), "Guy with export " + self.export + " tried to run respawn on death twice." );
	
	// when a red or green guy dies, an orange guy becomes a red guy
	// when an orange guy dies, a yellow guy becomes an orange guy	

	// if we spawn a new guy with spawn_reinforcement, he needs to get his color assignment before he checks his forcecolor
	waittillframeend; 
	
	classname = self.classname;
	// yellow guys have no guys to take their place so they return
	self waittill( "death" );
	color_order = level.current_color_order;

	if ( !isdefined( self.script_forceColor ) )
		return;
		
	// spawn a replacement yellow guy
	thread colorNode_spawn_reinforcement( self.classname, self.script_forceColor );

	color = self.script_forceColor;
	origin = self.origin;

	
	for ( ;; )
	{
		assertEx( isdefined( color_order[ color ] ), "Tried to replace a guy with color " + color + " but there is no color_order for that color. If that color is not meant to be replaced, you must explicitly specify this with set_empty_promotion_order( color )." );
		if ( color_order[ color ] == "none" )
			return;
			
		correct_colored_friendlies = get_force_color_guys( "allies", color_order[ color ] );
		correct_colored_friendlies = remove_heroes_from_array( correct_colored_friendlies );
		correct_colored_friendlies = remove_ai_without_classname( correct_colored_friendlies, classname );
		
		
		if ( !correct_colored_friendlies.size )
		{
			// nobody of the correct color existed, so give them more time to spawn
			wait( 2 );
			continue;
		}
		
		correct_colored_guy = getclosest( level.player.origin, correct_colored_friendlies );
		assertEx( correct_colored_guy.script_forceColor != color, "Tried to replace a " + color + " guy with a guy of the same color!" );
		correct_colored_guy set_force_color( color );

		// should something special happen when a guy is promoted? Like a change in threatbias group?
		if ( isdefined( level.friendly_promotion_thread ) )
		{
			correct_colored_guy [[ level.friendly_promotion_thread ]]( color );
		}

		color = color_order[ color ];
	}
}


friendly_spawner_vision_checker()
{
	level.friendly_respawn_vision_checker_thread = true;
	// checks to see if the player is looking at the friendly spawner
	
	successes = 0;
	for ( ;; )
	{
		flag_waitopen( "respawn_friendlies" );
		wait( 1 );
		// friendly_respawn is disabled but if the player is far enough away and looking away
		// from the spawner then we can still spawn from it.
		spawner = level.respawn_spawner;
		difference_vec = level.player.origin - spawner.origin;
		if ( length( difference_vec ) < 200 )
		{
			player_sees_spawner();
			continue;
		}

	    forward = anglesToForward( ( 0, level.player getplayerangles()[1], 0 ) );
		difference = vectornormalize( difference_vec );
	    dot = vectordot( forward, difference );
		if ( dot < 0.2 )
		{
			player_sees_spawner();
			continue;
		}
		
		successes++;
		if ( successes < 3 )
			continue;

		// player has been looking away for 3 seconds
		flag_set( "player_looks_away_from_spawner" );
	}
}

get_color_spawner( classname )
{
	assertEx( isdefined( level.respawn_spawner ), "Tried to spawn a guy but level.respawn_spawner is not defined. Either set it to a spawner or use targetname trigger_friendly_respawn triggers." );
	
	// if the classname is not set, just use the global respawn spawner
	if ( !isdefined( classname ) )
	{
		return level.respawn_spawner;
	}
	
	spawners = getentarray( "color_spawner", "targetname" );
	class_spawners = [];
	for ( i=0; i < spawners.size; i++ )
		class_spawners[ spawners[ i ].classname ] = spawners[ i ];

	// find the spawner that has the supplied classname as a substr
	spawner = undefined;
	keys = getarraykeys( class_spawners );
	for ( i=0; i < keys.size; i++ )
	{
		if ( !issubstr( class_spawners[ keys[ i ] ].classname, classname ) )
			continue;
		spawner = class_spawners[ keys[ i ] ];
		break;
	}
//	spawner = class_spawners[ classname ];

	if ( !isdefined( spawner ) )
	{
		return level.respawn_spawner;
	}

	spawner.origin = level.respawn_spawner.origin;
	return spawner;	
}

spawn_hidden_reinforcement( classname, fromColor )
{
	spawn = undefined;
	for ( ;; )
	{
		if ( !flag( "respawn_friendlies" ) )
		{
			if ( !isdefined( level.friendly_respawn_vision_checker_thread ) )
				thread friendly_spawner_vision_checker();

			// have to break if respawn_friendlies gets enabled because that disables the
			// fov check that toggles player_looks_away_from_spawner.
			flag_wait_either( "player_looks_away_from_spawner", "respawn_friendlies" );
			flag_waitopen( "friendly_spawner_locked" );
			flag_set( "friendly_spawner_locked" );
		}

		spawner = get_color_spawner( classname );
		spawner.count = 1;
		spawn = spawner stalingradspawn();
		
		if ( spawn_failed( spawn ) )
		{
			thread lock_spawner_for_awhile();
			wait( 1 );
			continue;
		}
		break;
	}
	
	// figure out which color the spawned guy should be
	for ( ;; )
	{
		if ( !isdefined( fromColor ) )
			break;
		if ( !isdefined( level.current_color_order[ fromColor ] ) )
			break;
		if ( level.current_color_order[ fromColor ] == "none" )
			break;
		fromColor = level.current_color_order[ fromColor ];
	}
	if ( isdefined( fromColor ) )
		spawn set_force_color( fromColor );
	
	thread lock_spawner_for_awhile();
	return spawn;	
}

lock_spawner_for_awhile()
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

