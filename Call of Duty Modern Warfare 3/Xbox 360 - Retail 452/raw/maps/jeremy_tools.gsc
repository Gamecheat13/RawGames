#include common_scripts\utility;
#include maps\_utility;
#include maps\_hud_util;
#include maps\_anim;


create_overlay_element( shader_name, start_alpha )
{
	overlay = newHudElem();
	overlay.x = 0;
	overlay.y = 0;
	overlay setshader( shader_name, 640, 480 );
	overlay.alignX = "left";
	overlay.alignY = "top";
	overlay.sort = 1;
	overlay.horzAlign = "fullscreen";
	overlay.vertAlign = "fullscreen";
	overlay.alpha = start_alpha;
	overlay.foreground = true;
	return overlay;
}

hide_geo()
{
	self hide();
	self notsolid();
	if ( self.spawnflags & 1 )
		self connectpaths();
}

hideAll( stuffToHide )
{
	if ( !isdefined( stuffToHide ) )
		stuffToHide = getentarray( "hide", "script_noteworthy" );
	for ( i = 0;i < stuffToHide.size;i++ )
	{
		entity = stuffToHide[ i ];
		switch( entity.classname )
		{
			case"script_vehicle":
				entity delete();
				break;
			case"script_model":
				entity hide();
				break;
			case "script_brushmodel":
				entity hide();
				entity notsolid();
				if ( entity.spawnflags & 1 )
					entity connectpaths();
				break;
			case "trigger_radius":
			case "trigger_multiple":
			case "trigger_use":
			case "trigger_use_touch":
			case "trigger_multiple_flag_set":
			case "trigger_multiple_breachIcon":
			case "trigger_multiple_flag_lookat":
			case "trigger_multiple_flag_looking":
				entity trigger_off();
				break;
		}
	}
}


ai_notify( sNotify, duration )
{
	self endon( "death" );
	duration = int( duration * 1000 );

    startTime = getTime();
    curTime = getTime();

    while ( curTime < startTime + duration )
    {
    	wait( 0.05 );
    	curTime = getTime();
    	self notify( sNotify );
    }

    self notify( "ai_notify_complete" );

}

get_all_ents_in_chain( sEntityType )
{
	aChain = [];
	ePathpoint = self;
	i = 0;
	while ( isdefined( ePathpoint.target ) )
	{
		wait( 0.05 );
		if ( isdefined( ePathpoint.target ) )
		{
			switch( sEntityType )
			{
				case "vehiclenode":
					ePathpoint = getvehiclenode( ePathpoint.target, "targetname" );
					break;
				case "pathnode":
					ePathpoint = getnode( ePathpoint.target, "targetname" );
					break;
				case "ent":
					ePathpoint = getent( ePathpoint.target, "targetname" );
					break;
				default:
					assertmsg( "sEntityType needs to be 'vehiclenode', 'pathnode' or 'ent'" );
			}
			aChain[ aChain.size ] = ePathpoint;
		}
		else
			break;
	}
	if ( aChain.size > 0 )
		return aChain;
	else
		return undefined;
}


wait_for_level_notify_or_timeout( msg1, timer )
{
	level endon( msg1 );
	wait( timer );
}

get_ai_within_radius( fRadius, org, sTeam )
{
	if ( isdefined( sTeam ) )
		ai = getaiarray( sTeam );
	else
		ai = getaiarray();

	aDudes = [];
	for ( i = 0;i < ai.size;i++ )
	{
		if ( distance( org, self.origin ) <= fRadius )
			array_add( aDudes, ai[ i ] );
	}
	return aDudes;
}

AI_stun( fAmount )
{
	self endon( "death" );
	if ( ( isdefined( self ) ) && ( isalive( self ) ) && ( self flashBangIsActive() ) )
		self flashBangStart( fAmount );
}

start_teleport( eNode )
{
	self forceTeleport( eNode.origin, eNode.angles );
	self setgoalpos( self.origin );
	//self setgoalradius (eNode.radius);
	self setgoalnode( eNode );
}

waittill_player_in_range( origin, range )
{
	while ( true )
	{
		if ( distance( origin, level.player.origin ) <= range )
			break;
		wait .5;
	}
}

vehicle_go_to_end_and_delete( sPath, sVehicleType )
{
	eStartNode = getvehiclenode( sPath, "targetname" );
	assertEx( ( isdefined( eStartNode ) ), "No vehicle node found with this name: " + sPath );
	sVehicleModel = "";
	switch( sVehicleType )
	{
	case "truck":
		sVehicleModel = "vehicle_pickup_4door";
		break;
	case "bmp":
		sVehicleModel = "vehicle_bmp";
		break;
	default:
		assertmsg( "you need to define a valid sVehicletype" );
	}

	eVehicle = spawnvehicle( sVehicleModel, "plane", "truck", eStartNode.origin, eStartNode.angles );
	if ( sVehicleType == "truck" )
		eVehicle truck_headlights_on();
	eVehicle attachpath( eStartNode );
	eVehicle startpath();
	eVehicle Vehicle_SetSpeed( 23, 20 );
	eVehicle waittill( "reached_end_node" );
	eVehicle delete();
}

truck_headlights_on()
{
	//self ==> the truck entity
	playfxontag( level._effect[ "headlight_truck" ], self, "tag_headlight_left" );
	playfxontag( level._effect[ "headlight_truck" ], self, "tag_headlight_right" );
}

set_goalvolume( sVolumeName, eVolume )
{
	self endon( "death" );
	if ( isDefined( sVolumeName ) )
		eVolume = getent( sVolumeName, "targetname" );

	assertEx( ( isdefined( eVolume ) ), "Need to pass a valid room volume" );

	eNode = getnode( eVolume.target, "targetname" );
	assertEx( ( isdefined( eNode ) ), "The volume at " + eVolume.origin + " is not targeting a node" );

	self.goalvolume = eVolume;
	self setgoalnode( eNode );
	self.goalradius = eNode.radius;
	self setgoalvolume( eVolume );
}

waittill_touching_entity( eEnt )
{
	self endon( "death" );

	while ( !self istouching( eEnt ) )
		wait( 0.05 );
}

reset_goalvolume()
{
	self endon( "death" );
	self setgoalpos( self.origin );
	self.goalvolume = undefined;
}

print3Dthread( sMessage, org, fSize, zOffset )
{
	self endon( "death" );
	if ( !isdefined( fSize ) )
		fSize = 0.25;
	if ( !isdefined( zOffset ) )
		zOffset = 0;

	if ( !isdefined( org ) )
		{
		self notify( "stop_3dprint" );
		self endon( "stop_3dprint" );
		self endon( "death" );


		for ( ;; )
		{
			if ( isdefined( self ) )
				print3d( self.origin + ( 0, 0, zOffset ), sMessage, ( 1, 1, 1 ), 1, fSize );
			wait( 0.05 );
		}
	}
	else
	{
		for ( ;; )
		{
			print3d( org, sMessage, ( 1, 1, 1 ), 1, fSize );
			wait( 0.05 );
		}
	}

}

smoke_detect()
{
	//"self" = the room volume you are checking
	self endon( "smoke_has_been_thrown" );
	self.smokethrown = false;
	while ( self.smokethrown == false )
	{
		wait( 0.05 );
		grenades = getentarray( "grenade", "classname" );
		for ( i = 0;i < grenades.size;i++ )
		{
			if ( grenades[ i ].model == "projectile_us_smoke_grenade" )
			{
				if ( grenades[ i ] istouching( self ) )
				{
					self.smokethrown = true;
					self notify( "smoke_has_been_thrown" );
				}
			}
		}
	}
}

/****************************************************************************
    DIALOGUE FUNCTIONS
****************************************************************************/

dialogue_execute( sLineToExecute )
{
	self endon( "death" );

	self dialogue_queue( sLineToExecute );

}

trigArrayWait( sTrig )
{
	aTriggers = getEntarray( sTrig, "targetname" );
	assert( aTriggers.size > 0 );

	if ( aTriggers.size == 1 )
		trigWait( sTrig );
	else
	{
		for ( i = 0;i < aTriggers.size;i++ )
			aTriggers[ i ] thread trigArrayWait2( aTriggers );

		//wait for the first one to get notified
		aTriggers[ 0 ] waittill( "trigger" );
	}
}

trigArrayWait2( aTrigArray )
{
	self waittill( "trigger" );

	//turn off all of the other triggers
	for ( i = 0;i < aTrigArray.size;i++ )
	{
		aTrigArray[ i ] notify( "trigger" );
		aTrigArray[ i ] trigger_off();
	}
}

trigWait( sTrig )
{
	trigger = getent( sTrig, "targetname" );
	assert( isdefined( trigger ) );
	trigger waittill( "trigger" );
	trigger trigger_off();
}

triggersEnable( triggerName, noteworthyOrTargetname, bool )
{
	assertEX( isdefined( bool ), "Must specify true/false parameter for triggersEnable() function" );
	aTriggers = getentarray( triggername, noteworthyOrTargetname );
	assertEx( isDefined( aTriggers ), triggerName + " does not exist" );
	if ( bool == true )
		array_thread( aTriggers, ::trigger_on );
	else
		array_thread( aTriggers, ::trigger_off );
}

triggerActivate( sTriggerName )	// Activate a trigger, then delete it
{
	eTrig = getent( sTriggerName, "targetname" );
	assert( isdefined( eTrig ) );
	eTrig notify( "trigger", level.player );
	eTrig trigger_off();
}


/****************************************************************************
    AI HOUSEKEEPING FUNCTIONS
****************************************************************************/
AA_AI_functions()
{
	//empty function
}

look_at_position( eEnt )
{
	yaw = VectorToAngles( self.origin - eEnt.origin );
	self setpotentialthreat( yaw[ 1 ] );
}

set_threatbias( iNumber )
{
		if ( !isdefined( self.old_threatbias ) )
			self.old_threatbias = self.threatbias;
		self.threatbias = iNumber;
}

reset_threatbias()
{
		if ( isdefined( self.old_threatbias ) )
			self.threatbias = self.old_threatbias;
		self.old_threatbias = undefined;
}



set_walkdist( dist )
{
		if ( !isdefined( self.old_walkdist ) )
			self.old_walkdist = self.walkdist;
		self.walkdist = dist;
}

reset_walkdist()
{
		if ( isdefined( self.old_walkdist ) )
			self.walkdist = self.old_walkdist;
		self.old_walkdist = undefined;
}

set_health( iHealth )
{
		self.old_health = self.health;
		self.health = iHealth;
}

reset_health()
{
		if ( isdefined( self.old_health ) )
			self.health = self.old_health;
}


set_animname( animname )
{
		if ( !isdefined( self.old_animname ) )
			self.old_animname = self.animname;
		self.animname = animname;
}

reset_animname()
{
		if ( isdefined( self.old_animname ) )
			self.animname = self.old_animname;
		self.old_animname = undefined;
}


set_maxsightdistsqrd( iNumber )
{
	if ( !isdefined( self.old_maxsightdistsqrd ) )
		self.old_maxsightdistsqrd = self.maxsightdistsqrd;
	self.maxsightdistsqrd = iNumber;
}

reset_maxsightdistsqrd()
{
	if ( isdefined( self.old_maxsightdistsqrd ) )
		self.maxsightdistsqrd = self.old_maxsightdistsqrd;
	self.old_maxsightdistsqrd = undefined;
}

set_threatbiasgroup( sName )
{
	if ( !threatbiasgroupexists( sName ) )
		assertmsg( "Threatbias group name does not exist: " + sName );

	if ( !isdefined( self.old_threatBiasGroupName ) )
		self.old_threatBiasGroupName = self.threatBiasGroupName;

	self.threatBiasGroupName = sName;
	self setThreatBiasGroup( sName );
}

reset_threatbiasgroup()
{
	if ( isdefined( self.old_threatBiasGroupName ) )
	{
		self.threatBiasGroupName = self.old_threatBiasGroupName;
		self setThreatBiasGroup( self.old_threatBiasGroupName );
		if ( !threatbiasgroupexists( self.old_threatBiasGroupName ) )
			assertmsg( "Threatbias group name does not exist: " + self.old_threatBiasGroupName );
	}
	else
	{
		self.threatBiasGroupName = undefined;
		self setThreatBiasGroup();
	}

	self.old_threatBiasGroupName = undefined;
}

setGoalRadius( fRadius )
{
	if ( !isdefined( self.old_goalradius ) )
		self.old_goalradius = self.goalradius;
	self.goalradius = fRadius;
}

resetGoalRadius()
{
	if ( isdefined( self.old_goalradius ) )
		self.goalradius = self.old_goalradius;
	self.old_goalradius = undefined;
}

setInterval( iInterval )
{
	if ( !isdefined( self.old_interval ) )
		self.old_interval = self.interval;
	self.interval = iInterval;
}
resetInterval()
{
	if ( isdefined( self.old_interval ) )
		self.interval = self.old_interval;
	self.old_interval = undefined;
}

set_accuracy( fAccuracy )
{
	if ( !isdefined( self.old_accuracy ) )
		self.old_accuracy = self.baseaccuracy;
	self.baseaccuracy = fAccuracy;
}

reset_accuracy()
{
	if ( isdefined( self.old_accuracy ) )
		self.baseaccuracy = self.old_accuracy;
	self.old_accuracy = undefined;
}

run_to_goal_delete( goal )
{
	self endon ( "death" );
	self setgoalentity ( goal );
	self waittill ( "goal" );
	self Delete();
}


get_closest_ally( eEnt )
{
	guy = undefined;

	if ( !isdefined( eEnt ) )
		org = level.player getorigin();
	else
		org = eEnt getorigin();

	if ( isdefined( level.excludedAi ) )
		guy = get_closest_ai_exclude( org, "allies", level.excludedAi );
	else
		guy = get_closest_ai( org, "allies" );

	return guy;
}


get_closest_axis()
{
	guy = get_closest_ai( level.player getorigin(), "axis" );
	return guy;
}


groupWarp( aGroupToBeWarped, sNodesToWarpTo )
{
	aNodes = getnodearray( sNodesToWarpTo, "targetname" );
	assert( isdefined( aNodes ) );

	for ( i = 0;i < aGroupToBeWarped.size;i++ )
	{
		if ( isdefined( aNodes[ i ] ) )
		{
			aGroupToBeWarped[ i ] teleport( aNodes[ i ].origin );
		}
	}
}
getAIarrayTouchingVolume( sTeamName, sVolumeName, eVolume )
{
	if ( !isdefined( eVolume ) )
	{
		eVolume = getent( sVolumeName, "targetname" );
		assertEx( isDefined( eVolume ), sVolumeName + " does not exist" );
	}

	if ( sTeamName == "all" )
		aTeam = getaiarray();
	else
		aTeam = getaiarray( sTeamName );

	aGuysTouchingVolume = [];
	for ( i = 0;i < aTeam.size;i++ )
	{
		if ( aTeam[ i ] isTouching( eVolume ) )
			aGuysTouchingVolume[ aGuysTouchingVolume.size ] = aTeam[ i ];
	}

	return aGuysTouchingVolume;
}

volume_waittill_no_axis( volume, tolerance )
{
	if ( !isdefined( volume ) )
		return true;
	
	while ( 1 )
	{
		if ( volume_is_empty( volume, tolerance ) )
			break;
		wait ( 0.2 );
	}	
}

volume_is_empty( volume, tolerance )
{
	if ( !isdefined( tolerance ) )
		tolerance = 0;
	
	enemies = GetAIArray( "axis" );
	num = 0;

	foreach ( e in enemies )
	{
		if ( e IsTouching( volume ) )
		{
			num += 1;
			if ( num > tolerance )
				return false;
		}
	}
	return true;
}

// delete all ai touching a given volume - specify 'all' 'axis' 'allies' or 'neutral'
npcDelete( sVolumeName, sNPCtype, boolKill, aExclude )
{
	if ( !isdefined( aExclude ) )
	{
		aExclude = [];
		aExclude[ 0 ] = level.price;
	}

	volume = getEnt( sVolumeName, "targetname" );
	assertEx( isdefined( volume ), sVolumeName + " volume does not exist" );

	if ( !isdefined( boolKill ) )
		boolKill = false;

	ai = undefined;
	if ( sNPCtype == "all" )
		ai = getaiarray();
	else
		ai = getaiarray( sNPCtype );

	assertEx( isdefined( ai ), "Need to specify 'all' 'axis' 'allies' or 'neutral' for this function" );

	//If an array was passed of dudes to exclude, remove them from the array
	if ( isdefined( aExclude ) )
	{
		for ( i = 0;i < aExclude.size;i++ )
		{
		if ( is_in_array( ai, aExclude[ i ] ) )
			ai = array_remove( ai, aExclude[ i ] );
		}
	}


	for ( i = 0;i < ai.size;i++ )
	{
		if ( ai[ i ] isTouching( volume ) )
			{
				//regardless of what we do, turn off magic bullet shield
				ai[ i ] invulnerable( false );
				//decide weather to kill or delete
				if ( boolKill == true )
					ai[ i ] kill( ( 0, 0, 0 ) );
				else
					ai[ i ] delete();
			}

	}


//	//Delete alll the hostages
//	if ( (sNPCtype == "all") || (sNPCtype == "neutral") )
//	{
//		aHostages = getentarray("actor_civilian", "classname"); 
//		for(i=0;i<aHostages.size;i++)
//		{
//			if(aHostages[i] isTouching(volume))
//				aHostages[i] delete();
//		}
//	}

}

getDudeFromArray( aSpawnArray, sScript_Noteworthy )
{
	dude = undefined;
	//loop through the array and find the guy with that script_noteworthy	
	for ( i = 0;i < aSpawnArray.size;i++ )
	{
		if ( isDefined( aSpawnArray[ i ].script_noteworthy ) && aSpawnArray[ i ].script_noteworthy == sScript_Noteworthy )
			dude = aSpawnArray[ i ];
	}

	assertEX( isdefined( dude ), sScript_Noteworthy + " does not exist in this array" );
	//Return a reference to the guy
	return dude;
}

getDudesFromArray( aSpawnArray, sScript_Noteworthy )
{
	aDudes = [];
	//loop through the array and find the guy with that script_noteworthy	

	if ( isDefined( sScript_Noteworthy ) )
	{
		for ( i = 0;i < aSpawnArray.size;i++ )
		{
			if ( isDefined( aSpawnArray[ i ].script_noteworthy ) && aSpawnArray[ i ].script_noteworthy == sScript_Noteworthy )
				aDudes[ aDudes.size ] = aSpawnArray[ i ];
		}
	}

	else
		assertmsg( "You need to pass a script_noteworthy to this function" );

	if ( aDudes.size > 0 )
		return aDudes;
	else
		return undefined;

}

goToNode( sNode )
{
	self endon( "death" );

	node = getnode( sNode, "targetname" );
	assertEx( isdefined( node ), sNode + "node does not exist" );

	self setGoalRadius( node.radius );
	self setgoalnode( node );

	self waittill( "goal" );
	self resetGoalRadius();
}



goToNodeAndDelete( sNode )
{
	if ( !isdefined( self ) )
		return;
	if ( !isalive( self ) )
		return;

	self endon( "death" );

	node = getnode( sNode, "targetname" );
	assert( isdefined( node ) );

	self setgoalnode( node );
	self setGoalRadius( node.radius );

	self waittill( "goal" );

	self delete();
}

goToNodeAndWait( sNode )
{
	if ( !isdefined( self ) )
		return;
	if ( !isalive( self ) )
		return;

	self endon( "death" );

	eNode = getnode( sNode, "targetname" );
	assert( isdefined( eNode ) );

	self setgoalnode( eNode );
	self setGoalRadius( eNode.radius );

	self waittill( "goal" );

	self set_animname( "guy" );


	self waittill( "stop_waiting_at_node" );

	self resetGoalRadius();

}

forceToNode( sNode )
{
	self endon( "death" );

	node = getnode( sNode, "targetname" );
	assertEx( isdefined( node ), sNode + "node does not exist" );
	self pushplayer( true );

	self setgoalnode( node );

	self waittill( "goal" );

	self pushplayer( false );

	self resetGoalRadius();

}

setPosture( posture )
{
	if ( posture == "all" )
		self allowedStances( "stand", "crouch", "prone" );
	else
		self allowedStances( posture );

}

invulnerable( bool )
{
	if ( bool == false )
	{
		if ( isdefined( self.magic_bullet_shield ) )
			self stop_magic_bullet_shield();
	}
	else
	{
		if ( !isdefined( self.magic_bullet_shield ) )
			self thread magic_bullet_shield();
	}


	self.a.disablePain = bool;
}

killEntity()
{
	self endon( "death" );

	if ( !isdefined( self ) )
		return;
	if ( !isalive( self ) )
		return;

	self.allowdeath = true;
	self invulnerable( false );
	self kill();
}

goToVolume( sVolumeName )
{
	self endon( "death" );
	goalVolume = getEnt( sVolumeName, "targetname" );
	goalNode = getNode( goalVolume.target, "targetname" );
	assertEx( isdefined( goalVolume ), "Need to specify a valid volume name vor this function" );
	assertEx( isdefined( goalNode ), "The volume needs to target a node for this function to work properly" );

	self setGoalNode( goalNode );
	self setGoalVolume( goalVolume );
	self.goalradius = goalNode.radius;
}



/****************************************************************************
    UTILITY FUNCTIONS: SPAWNING
****************************************************************************/
AA_spawning_functions()
{
	//empty
}




/****************************************************************************
    DOOR FUNCTIONS
****************************************************************************/
AA_door_functions()
{
	//empty
}

door_open( sType, bPlaySound, bPlayDefaultFx )
{
	/*-----------------------
	VARIABLE SETUP
	-------------------------*/		
	if ( !isDefined( bPlaySound ) )
		bPlaySound = true;
	if ( !isDefined( bPlayDefaultFx ) )
		bPlayDefaultFx = true;
	if ( bPlaysound == true )
		self playsound( level.scr_sound[ "snd_wood_door_kick" ] );

	if ( self.classname == "script_brushmodel" )
	{
		eExploder = getent( self.target, "targetname" );
		assertex( isdefined( eExploder ), "A script_brushmodel door needs to target an exploder to play particles when opened. Targetname:  " + self.targetname );
	}
	else
	{
		blocker = getent( self.target, "targetname" );
		assertex( isdefined( blocker ), "A script_model door needs to target a script_brushmodel that blocks the door." );
		eExploder = getent( blocker.script_linkto, "script_linkname" );
		assertex( isdefined( eExploder ), "A script_model door blocker needs to script_linkTo an exploder to play particles when opened. Targetname:  " + self.targetname );
	}
	/*-----------------------
	OPEN DOOR, CONNECT PATHS, PLAY FX
	-------------------------*/		
	switch( sType )
	{
		case "explosive":
			self thread door_fall_over();
			self door_connectpaths( bPlayDefaultFx );
			self playsound( level.scr_sound[ "snd_breach_wooden_door" ] );
			earthquake( 0.4, 1, self.origin, 1000 );
			radiusdamage( self.origin, 56, level.maxDetpackDamage, level.minDetpackDamage );
			break;
		case "kicked":		// Rotate away from kick
			self rotateyaw( -175, 0.5 );
			self door_connectpaths( bPlayDefaultFx );
			break;
		case "kicked_down":
			self thread door_fall_over();
			self door_connectpaths( bPlayDefaultFx );
			//if (bPlayDefaultFx)
				//playfx(level._effect["door_kicked_dust01"], eExploder.origin, anglestoforward(eExploder.angles));
			break;
		default:
			self rotateyaw( -175, 0.5 );
			self door_connectpaths();
			break;
	}
	/*-----------------------
	PLAY EXPLODER IN CASE FX ARTISTS WANT TO ADD
	-------------------------*/		
	iExploderNum = eExploder.script_exploder;
	assertEx( ( isdefined( iExploderNum ) ), "There is no exploder number in the key 'script_exploder'" );
	exploder( iExploderNum );
}

door_connectpaths( bPlayDefaultFx )
{
	if ( self.classname == "script_brushmodel" )
		self connectpaths();
	else
	{
		blocker = getent( self.target, "targetname" );
		assertex( isdefined( blocker ), "A script_model door needs to target a script_brushmodel that blocks the door." );
		blocker hide();
		blocker notsolid();
		blocker connectpaths();
	}
}

door_fall_over()
{
	vector = anglestoforward( self.angles );
	dist = ( vector[ 0 ] * 20, vector[ 1 ] * 20, vector[ 2 ] * 20 );

	self moveto( self.origin + dist, .5, 0, .5 );
	self rotatepitch( 90, 0.45, 0.40 );
	wait 0.449;
	self rotatepitch( -4, 0.2, 0, 0.2 );
	wait 0.2;
	self rotatepitch( 4, 0.15, 0.15 );
}

debug_circle( center, radius, duration, color, startDelay, fillCenter )
{
	circle_sides = 16;

	angleFrac = 360 / circle_sides;
	circlepoints = [];
	for ( i = 0;i < circle_sides;i++ )
	{
		angle = ( angleFrac * i );
		xAdd = cos( angle ) * radius;
		yAdd = sin( angle ) * radius;
		x = center[ 0 ] + xAdd;
		y = center[ 1 ] + yAdd;
		z = center[ 2 ];
		circlepoints[ circlepoints.size ] = ( x, y, z );
	}

	if ( isdefined( startDelay ) )
		wait startDelay;

	thread debug_circle_drawlines( circlepoints, duration, color, fillCenter, center );
}

debug_circle_drawlines( circlepoints, duration, color, fillCenter, center )
{
	if ( !isdefined( fillCenter ) )
		fillCenter = false;
	if ( !isdefined( center ) )
		fillCenter = false;

	for ( i = 0 ; i < circlepoints.size ; i++ )
	{
		start = circlepoints[ i ];
		if ( i + 1 >= circlepoints.size )
			end = circlepoints[ 0 ];
		else
			end = circlepoints[ i + 1 ];

		thread debug_line( start, end, duration, color );

		if ( fillCenter )
			thread debug_line( center, start, duration, color );
	}
}

debug_line( start, end, duration, color )
{
	if ( !isdefined( color ) )
		color = ( 1, 1, 1 );

	for ( i = 0; i < ( duration * 20 );i++ )
	{
		line( start, end, color );
		wait 0.05;
	}
}


ai_play_anim_and_follow_path( start_node, require_player_dist )
{
	self endon( "death" );
	self endon( "stop_path" );

	self notify( "follow_path" );
	self endon( "follow_path" );

	wait 0.1;

	node = start_node;

	getfunc = undefined;
	gotofunc = undefined;

	if ( !IsDefined( require_player_dist ) )
		require_player_dist = 300;

	//only nodes dont have classnames - ents do

	while ( IsDefined( node ) )
	{
		if ( IsDefined( level.struct_class_names[ "targetname" ][ node.targetname ] ) )
		{
			gotofunc = ::follow_path_set_struct;
		}
		else if ( IsDefined( node.classname ) )
		{
			gotofunc = ::follow_path_set_ent;
		}
		else
		{
			gotofunc = ::follow_path_set_node;
		}
		
		if ( IsDefined( node.radius ) && node.radius != 0 )
			self.goalradius = node.radius;
		if ( self.goalradius < 16 )
			self.goalradius = 16;
		if ( IsDefined( node.height ) && node.height != 0 )
			self.goalheight = node.height;

		original_goalradius = self.goalradius;

		self childthread [[ gotofunc ]]( node );

		if ( isdefined( node.animation ) )
			node waittill( node.animation );
		else
			while ( 1 )
			{
				self waittill( "goal" );
				if ( Distance( node.origin, self.origin ) < ( original_goalradius + 10 ) )
					break;
			}

		node notify( "trigger", self );

		// waiting for player
		if ( !IsDefined( node.script_requires_player ) && require_player_dist > 0 )
		{
			while ( IsAlive( level.player ) )
			{
				if ( self wait_for_player( node, require_player_dist ) )
					break;
				if ( IsDefined( node.animation ) )
				{
					self.goalradius = original_goalradius;
					self SetGoalPos( self.origin );
				}
				wait 0.05;
			}
		}

		if ( !IsDefined( node.target ) )
			break;

		node script_delay();

		node = node get_target_ent();
	}

	self notify( "path_end_reached" );
}

follow_path_waitforplayer( start_node, require_player_dist )
{
	self endon( "death" );
	self endon( "stop_path" );

	self notify( "follow_path" );
	self endon( "follow_path" );

	wait 0.1;

	node = start_node;

	getfunc = undefined;
	gotofunc = undefined;

	if ( !IsDefined( require_player_dist ) )
		require_player_dist = 0;

	//only nodes dont have classnames - ents do

	while ( IsDefined( node ) )
	{
		if ( IsDefined( level.struct_class_names[ "targetname" ][ node.targetname ] ) )
		{
			gotofunc = ::follow_path_set_struct;
		}
		else if ( IsDefined( node.classname ) )
		{
			gotofunc = ::follow_path_set_ent;
		}
		else
		{
			gotofunc = ::follow_path_set_node;
		}
		
		if ( IsDefined( node.radius ) && node.radius != 0 )
			self.goalradius = node.radius;
		if ( self.goalradius < 16 )
			self.goalradius = 16;
		if ( IsDefined( node.height ) && node.height != 0 )
			self.goalheight = node.height;

		original_goalradius = self.goalradius;

		self childthread [[ gotofunc ]]( node );

		if ( isdefined( node.animation ) )
			node waittill( node.animation );
		else
			while ( 1 )
			{
				self waittill( "goal" );
				if ( Distance( node.origin, self.origin ) < ( original_goalradius + 10 ) )
					break;
			}

		node notify( "trigger", self );

		// waiting for player
		if ( !IsDefined( node.script_requires_player ) && require_player_dist > 0 )
		{
			while ( IsAlive( level.player ) )
			{
				if ( self wait_for_player( node, require_player_dist ) )
					break;
				if ( IsDefined( node.animation ) )
				{
					self.goalradius = original_goalradius;
					self SetGoalPos( self.origin );
				}
				wait 0.05;
			}
		}

		if ( !IsDefined( node.target ) )
			break;

		node script_delay();

		node = node get_target_ent();
	}

	self notify( "path_end_reached" );
}

wait_for_player( node, dist )
{
	if ( Distance( level.player.origin, node.origin ) < Distance( self.origin, node.origin ) )
		return true;

	vec = undefined;
	//is the player ahead of us?
	vec = AnglesToForward( self.angles );
	vec2 = VectorNormalize( ( level.player.origin - self.origin ) );

	if ( IsDefined( node.target ) )
	{
		temp = get_target_ent( node.target );
		vec = VectorNormalize( temp.origin - node.origin );
	}
	else if ( IsDefined( node.angles ) )
		vec = AnglesToForward( node.angles );
	else
		vec = AnglesToForward( self.angles );

	//i just created a vector which is in the direction i want to
	//go, lets see if the player is closer to our goal than we are				
	if ( VectorDot( vec, vec2 ) > 0 )
		return true;

	//ok so that just checked if he was a mile away but more towards the target
	//than us...but we dont want him to be right on top of us before we start moving
	//so lets also do a distance check to see if he's close behind

	if ( Distance( level.player.origin, self.origin ) < dist )
		return true;

	return false;
}

follow_path_set_node( node )
{
	self notify( "follow_path_new_goal" );
	if ( IsDefined( node.animation ) )
	{
		node anim_generic_reach( self, node.animation );
		node anim_generic_run( self, node.animation );
		self setGoalPos( self.origin );
	}
	else
	{
		self set_goal_node( node );
	}
}

follow_path_set_ent( ent )
{
	self notify( "follow_path_new_goal" );
	if ( IsDefined( ent.animation ) )
	{
		ent anim_generic_reach( self, ent.animation );
		ent anim_generic_run( self, ent.animation );
		self setGoalPos( self.origin );
	}
	else
	{
		self set_goal_ent( ent );
	}
}


//quick_anim_with_node( node )
//{
//	gotofunc = undefined;
//
//	while ( IsAlive( self ) )
//	{
//		if ( IsDefined( level.struct_class_names[ "targetname" ][ node.targetname ] ) )
//		{
//			gotofunc = ::follow_path_set_struct;
//		}
//	}
//}

follow_path_set_struct( struct )
{
	self notify( "follow_path_new_goal" );
	if ( IsDefined( struct.animation ) )
	{
		struct anim_generic_reach( self, struct.animation );
		struct anim_generic_run( self, struct.animation );
		self setGoalPos( self.origin );
	}
	else
	{
		self set_goal_pos( struct.origin );
	}
}

ai_anim_target( start_node, require_ai_dist )
{
	self endon( "death" );
	self endon( "stop_path" );

	wait 0.1;

	node = start_node;

	getfunc = undefined;
	gotofunc = undefined;

//	if ( !IsDefined( require_player_dist ) )
//		require_ai_dist = 300;

	//only nodes dont have classnames - ents do

	while ( IsDefined( node ) )
	{
		if ( IsDefined( level.struct_class_names[ "targetname" ][ node.targetname ] ) )
		{
			gotofunc = ::follow_path_set_struct;
		}
		else if ( IsDefined( node.classname ) )
		{
			gotofunc = ::follow_path_set_ent;
		}
		else
		{
			gotofunc = ::follow_path_set_node;
		}
		
		if ( IsDefined( node.radius ) && node.radius != 0 )
			self.goalradius = node.radius;
		if ( self.goalradius < 16 )
			self.goalradius = 16;
		if ( IsDefined( node.height ) && node.height != 0 )
			self.goalheight = node.height;

		original_goalradius = self.goalradius;

		self childthread [[ gotofunc ]]( node );

		if ( isdefined( node.animation ) )
		//	if( isDefined( walk_to ) )
				node waittill( node.animation );
			//if( isDefined( dont_walk ) )	
				
		else
			while ( 1 )
			{
				self waittill( "goal" );
				if ( Distance( node.origin, self.origin ) < ( original_goalradius + 10 ) )
					break;
			}

		node notify( "trigger", self );

		if ( !IsDefined( node.target ) )
			break;

		node script_delay();

		node = node get_target_ent();
	}

	self notify( "path_end_reached" );
}

//	axis = getaiarray( "axis" );

kick_double_door_open( door_l, door_r, soundalias, delay , rotate_too, fxnode )
{
	if ( isdefined( delay ) )
		wait( delay );
	else
		wait( 0.5 );

	if ( IsDefined( soundalias ) )
		door_l PlaySound( soundalias );
	else
		door_l PlaySound( "wood_door_kick" );
		
	if ( isdefined( fxnode ) )
	{
		if ( !isdefined( fxnode.script_fxid ) )
			fxnode.script_fxid = "door_kick";
		if ( !isdefined( fxnode.angles ) )
			fxnode.angles = (0,0,0);
		PlayFX( getfx( fxnode.script_fxid ), fxnode.origin, AnglesToForward( fxnode.angles ) );
	}	
	

	if( isDefined ( door_l ) )
		door_l RotateTo( door_l.angles + ( 0, rotate_too, 0 ), 0.5, 0.2, 0.1 );
	if( isDefined ( door_r ) )
		door_r RotateTo( door_r.angles - ( 0, rotate_too, 0 ), 0.5, 0.2, 0.1 );
	
	if( isDefined ( door_l ) )
	door_l waittill( "rotatedone" );
	
	if( isDefined ( door_r ) )
		door_r ConnectPaths();
	if( isDefined ( door_l ) )
		door_l ConnectPaths();
	
	if( isDefined ( door_l ) )
		door_l RotateTo( door_l.angles - ( 0, 5, 0 ), 0.2, 0.0, 0.1 );
	if( isDefined ( door_r ) )
		door_r RotateTo( door_r.angles + ( 0, 5, 0 ), 0.2, 0.0, 0.1 );
}

flickering_light( light, min, max )
{
	level endon( "level_cleanup" );
	light endon( "stop_flicker" );

	while ( 1 )
	{
		i = RandomFloatRange( min, max );
		light SetLightIntensity( i );
//		if ( i > 0.4 )
//			light modelOnState();
//		else
//			light modelOffState();
		wait( RandomFloatRange( 0.1, 0.2 ) );
	}
}