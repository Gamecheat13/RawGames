#include common_scripts\utility;
#include maps\_utility;
#include maps\_objectives;
#include maps\_vehicle;

skipto_setup()
{
	skipto = level.skipto_point;
		
	if (skipto == "speech_skipto")
		return;													

	if (skipto == "market_skipto")
		return;													

	if (skipto == "terrorist_hunt_skipto")
		return;													

	if (skipto == "metal_storm_skipto")
		return;													

	if (skipto == "morals_skipto")
		return;													

	if (skipto == "drone_control_skipto")
		return;													
		
	if (skipto == "hijacked_skipto")
		return;													

	if (skipto == "capture_skipto")
		return;													
}



/* ------------------------------------------------------------------------------------------
	Terrorist/Yemeni Team Functions
-------------------------------------------------------------------------------------------*/
teamswitch_threatbias_setup()
{
	CreateThreatBiasGroup( "player" );
	CreateThreatBiasGroup( "yemeni" );
	CreateThreatBiasGroup( "terrorist" );
	CreateThreatBiasGroup( "terrorist_team3" );

	// Yemeni should shoot the player
	SetThreatBias( "player", "yemeni", 1500 );
	
	// Yemeni and Terrorists should shoot at each other
	SetThreatBias( "terrorist", "yemeni", 1500 );
	SetThreatBias( "terrorist_team3", "yemeni", 1500 );
	SetThreatBias( "yemeni", "terrorist", 1500 );
	
	// Terrorist_team3 should shoot at the player and Yemeni, but not at Terrorists.
	SetThreatBias( "terrorist_team3", "terrorist", -15000 );
	SetThreatBias( "terrorist", "terrorist_team3", -15000 );
	SetThreatBias( "player", "terrorist_team3", 15000 );
	SetThreatBias( "yemeni", "terrorist_team3", 1000 );
}

// Sets the yemeni soldier (normally a friendly) to axis, other logic on the way
yemeni_teamswitch_spawnfunc()
{
	self.team = "axis";
	self SetThreatBiasGroup( "yemeni" );
}



// Sets terrorist soldier to friendly, detects if the player shoots him or anyone near him
terrorist_teamswitch_spawnfunc()
{
	self.team = "allies";
	self SetThreatBiasGroup( "terrorist" );

	while( self.team == "allies" )
	{
		self waittill( "damage", damage, ai_guy );
		
		if( ai_guy == level.player )
		{
			self terrorist_teamswitch_player_detected();
			
			self terrorist_teamswitch_radius_check();
		}
	}
}

terrorist_teamswitch_radius_check()
{
	n_detect_radius = 512 * 512;
	
	a_terrorists = get_ai_group_ai( "terrorist" );
	
	foreach( ai_terrorist in a_terrorists )
	{
		if ( Distance2DSquared( self.origin, ai_terrorist.origin ) < n_detect_radius )
		{
			ai_terrorist terrorist_teamswitch_player_detected();
		}
		else if ( Distance2DSquared( level.player.origin, ai_terrorist.origin ) < n_detect_radius )
		{
			ai_terrorist terrorist_teamswitch_player_detected();
		}
	}
}

terrorist_teamswitch_player_detected()
{
	self.team = "team3";
	self SetThreatBiasGroup( "terrorist_team3" );	
}

/* ------------------------------------------------------------------------------------------
	VTOL Rappeler Functions
-------------------------------------------------------------------------------------------*/

// To set up a VTOL with rappelers, follow these steps:
//  - Set up your Vehicle path and VTOL like any other vehicle.
//  - On the path node you want the VTOL to stop at, give it the script_noteworthy of "vtol_rappel_spot"
//  - Give that path node a unique script_string
//  - create a struct at the position you want each rappeler to start at 
//     - the targetname of [script_string]_start, where [script_string] is the script_string you gave the vehicle node
// 	   - give have the struct target a second struct, which is where the rappel action stops
//     - Have that second struct target a cover node, where the AI will run to after it rappels
//  - Create an AI spawner with the targetname [script_string]_rappelers (and give it an appropriate count)
// DONE!

temp_vtol_stop_and_rappel()
{
	a_rappel_nodes = GetVehicleNodeArray( "vtol_rappel_spot", "script_noteworthy" );
	array_thread( a_rappel_nodes, ::temp_vtol_rappel_start );
}

temp_vtol_rappel_start()
{
	self waittill( "trigger", veh_vtol );
	
	n_speed = veh_vtol GetSpeed();
	veh_vtol SetSpeed( 0, 50, 50 );	
	
	str_rappel_spawner_targetname 	= self.script_string + "_rappelers";
	str_rappel_start_targetname		= self.script_string + "_start";
	
	level thread temp_vtol_rappel_guys( str_rappel_start_targetname, str_rappel_spawner_targetname );
	
	wait 5;
	veh_vtol SetSpeed( n_speed );	
	
	veh_vtol waittill( "goal" );
	veh_vtol Delete();
}

temp_vtol_rappel_guys( str_struct_starts, str_rappeler )
{
	a_start_structs = GetStructArray( str_struct_starts, "targetname" );
	sp_rappeler		= GetEnt( str_rappeler, "targetname" );
	
	foreach( s_rappel_start in a_start_structs )
	{
		ai_guy = sp_rappeler spawn_ai( true );
		ai_guy thread temp_vtol_rappel_guy( s_rappel_start );
		
		wait .5;
	}
}

temp_vtol_rappel_guy( s_rappel_start )
{
	s_rappel_end = GetStruct( s_rappel_start.target, "targetname" );
	nd_goal = GetNode( s_rappel_end.target, "targetname" );
	
	m_mover = Spawn( "script_origin", self.origin );
	// m_mover SetModel( "tag_origin" );
	self LinkTo( m_mover );
	m_mover.origin = s_rappel_start.origin;
	
	m_mover MoveTo( s_rappel_end.origin, 2, .5, .5 );
	m_mover waittill( "movedone" );
	
	self Unlink();
	self SetGoalNode( nd_goal );
}