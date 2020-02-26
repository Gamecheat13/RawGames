#include common_scripts\utility;

#insert raw\common_scripts\utility.gsh;
#insert raw\animscripts\utility.gsh;

/#

	mainDebug()
{
	level thread sendAIMonitorKeys();
}

sendAIMonitorKeys()
{
	while( true )
	{
		dvarVal = GetDvar( "ai_monitorNeedsKeys" );
		if( !IsDefined( dvarVal ) )
		{
			PrintLn( "DVAR NOT DEFINED" );
		}
		else
		{
			if( Int(dvarVal) == 1 )
			{
				sendEntInfoKeys();
				sendAnimScriptKeys();
				sendCodeStateKeys();
				SetDvar( "ai_monitorNeedsKeys", 0 );
			}
		}
		wait( 0.05 );
	}
}

sendEntInfoKeys()
{
	keys = array( "Targetname",
	             "Script_noteworthy",
	             "Enemy",
	             "&newline",
	             
	             "Health",
	             "Goal Radius",
	             "&newline",
	             
	             "Current Weapon",
	             "Primary Weapon",
	             "Secondary Weapon",
	             "Sidearm",
	             "&newline",
	             
	             "Current Stance",
	             "Allowed Stances",
	             "&newline",
	             
	             "Ignore All",
	             "Ignore Me",
	             "&newline",
	             
	             "disableTurns",
	             "disableArrivals",
	             "disableExits",
	             "disablePain",
	             "ignoreSuppression",
	             "&newline",
	             
	             "allowShooting",
	             "grenadeAwareness",
	             "takeDamage",
	             "&newline",
	             
	             "CQB",
	             "Heat",
	             "Sprint",
	             "&newline",
	             
	             "ScriptOrientMode",
	             "CodeOrientMode",
	             "MoveMode",
	             "FixedNode",
	             "&newline",
	             
	             "Movement",
	             "PathEnemyFightDist",
	             "WeaponClass"
	            );
	
	keyNames = "";
	
	for( i = 0; i < keys.size; i++ )
	{
		keyNames += keys[i]+"\n";
	}
	
	SendAIScriptKeys( "entinfo", keyNames );
}

GetStanceString()
{
	stanceString = "";
	if( self IsStanceAllowed("stand") )
	{
		stanceString += "S";
	}
	if( self IsStanceAllowed("crouch" ) )
	{
		stanceString += "C";
	}
	if( self IsStanceAllowed("prone") )
	{
		stanceString += "P";
	}
	
	return stanceString;
}

GetVal( variable )
{
	if( IsDefined( variable ) )
	{
		return variable;
	}
	else
	{
		return "undefined";
	}
}

sendEntInfoVals()
{
	if( !ShouldMonitorAI() )
	{
		return;
	}
	
	if( IsDefined( self.enemy ) )
	{
		enemyNum = self.enemy GetEntityNumber();
	}
	else
	{
		enemyNum = undefined;
	}
	
	vals = array( GetVal( self.targetname ),							/* "Targetname" */
	             GetVal( self.script_noteworthy ), 			/* "Script_noteworthy" */
	             GetVal( enemyNum ),											/* "Enemy" */
	             /* "&newline" */
	             
	             GetVal( self.health ),									/* "Health" */
	             GetVal( self.goalradius ), 							/* "Goal Radius" */
	             /* "&newline" */
	             
	             GetVal( self.weapon ),									/* "Current Weapon" */
	             GetVal( self.primaryweapon ),						/* "Primary Weapon" */
	             GetVal( self.secondaryweapon ),					/* "Secondary Weapon" */
	             GetVal( self.sidearm ),									/* "Sidearm" */
	             /* "&newline" */
	             
	             GetVal( self.a.pose ),									/* "Current Stance" */
	             GetVal( self GetStanceString() ),				/* "Allowed Stances" */
	             /* "&newline" */
	             
	             GetVal( self.ignoreall ),								/* "Ignore All" */
	             GetVal( self.ignoreme ),								/* "Ignore Me" */
	             /* "&newline" */
	             
	             GetVal( self.disableTurns ),						/* "disableTurns" */
	             GetVal( self.disableArrivals ),					/* "disableArrivals" */
	             GetVal( self.disableExits ), 						/* "disableExits" */
	             GetVal( self.diablePain ),							/* "disablePain" */
	             GetVal( self.ignoreSuppression ), 			/* "ignoreSuppression" */
	             /* "&newline" */
	             
	             GetVal( self.a.allow_shooting ), 				/* "allowShooting" */
	             GetVal( self.grenadeawareness ),				/* "grenadeAwareness" */
	             GetVal( self.takeDamage ),							/* "takeDamage" */
	             /* "&newline" */
	             
	             GetVal( ISCQB(self) ), 					/* "CQB" */
	             GetVal( self.heat ),										/* "Heat" */
	             GetVal( self.sprint ),									/* "Sprint" */
	             /* "&newline" */
	             
	             GetVal( self GetOrientMode("script") ), /* "ScriptOrientMode" */
	             GetVal( self GetOrientMode("code") ), 	/* "CodeOrientMode" */
	             GetVal( self.moveMode ),								/* "MoveMode" */
	             GetVal( self.fixedNode ),								/* "FixedNode" */
	             /* "&newline" */
	             
	             GetVal( self.a.movement ),							/* "Movement" */
	             GetVal( self.pathenemyfightdist ),				/* "PathEnemyFightDist" */
	             GetVal( self.weaponclass )					/* "WeaponClass" */
	            );
	
	valString = "";
	
	for( i = 0; i < vals.size; i++ )
	{
		valString += vals[i]+"\n";
	}
	
	self SendAIScriptVals( "entinfo", valString );
}

sendAnimScriptKeys()
{
	SendAIScriptKeys( "animscript", "" );
}

sendCodeStateKeys()
{
	SendAIScriptKeys( "codestate", "" );
}

isDebugOn()
{
	return ( (getdebugdvarint("animDebug") == 1) || ( IsDefined (anim.debugEnt) && anim.debugEnt == self ) );
}

drawDebugLineInternal(fromPoint, toPoint, color, durationFrames)
{
	//println ("Drawing line, color "+color[0]+","+color[1]+","+color[2]);
	//player = getent("player", "classname" );
	//println ( "Point1 : "+fromPoint+", Point2: "+toPoint+", player: "+player.origin );
	for (i=0;i<durationFrames;i++)
	{
		line (fromPoint, toPoint, color);
		wait (0.05);
	}
}

drawDebugLine(fromPoint, toPoint, color, durationFrames)
{
	if (isDebugOn())
	{
		thread drawDebugLineInternal(fromPoint, toPoint, color, durationFrames);
	}
}

debugLine(fromPoint, toPoint, color, durationFrames)
{
	for (i=0;i<durationFrames*20;i++)
	{
		line (fromPoint, toPoint, color);
		wait (0.05);
	}
}

drawDebugCross(atPoint, radius, color, durationFrames)
{
	atPoint_high =		atPoint + (		0,			0,		   radius	);
	atPoint_low =		atPoint + (		0,			0,		-1*radius	);
	atPoint_left =		atPoint + (		0,		   radius,		0		);
	atPoint_right =		atPoint + (		0,		-1*radius,		0		);
	atPoint_forward =	atPoint + (   radius,		0,			0		);
	atPoint_back =		atPoint + (-1*radius,		0,			0		);
	thread debugLine(atPoint_high,	atPoint_low,	color, durationFrames);
	thread debugLine(atPoint_left,	atPoint_right,	color, durationFrames);
	thread debugLine(atPoint_forward,	atPoint_back,	color, durationFrames);
}

////////////////////////////////////////////////////////////////////////////////////////////////////////////////
///////////////////////////////////// BEGIN ANIMSCRIPT STATE DEBUGGING /////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////////////////////////////////////

UpdateDebugInfo()
{
	self endon("death");

	self.debugInfo = SpawnStruct();
	self.debugInfo.enabled = GetDvarint( "ai_debugAnimscript") > 0;
	debugClearState();

	while(1)
	{
		waittillframeend;

		UpdateDebugInfoInternal();
		sendEntInfoVals();

		wait(0.05);
	}
}

UpdateDebugInfoInternal()
{
	if( IsDefined(anim.debugEnt) && (anim.debugEnt==self) )
	{
		doInfo = true;
	}
	else
	{
		doInfo = GetDvarint( "ai_debugAnimscript") > 0;

		// check if there's a selected ent
		if( doInfo )
		{
			ai_entNum = GetDvarint( "ai_debugEntIndex");
			if( ai_entNum > -1 && ai_entNum != self getEntityNumber() )
			{
				doInfo = false;
			}
		}

		// clear everything out if it was just switched on to make sure we start clean
		if( !self.debugInfo.enabled && doInfo )
		{
			self.debugInfo.shouldClearOnAnimscriptChange = true;
		}

		self.debugInfo.enabled = doInfo;
	}

	if( doInfo )
	{
		drawDebugInfo(doInfo);
	}
}

drawDebugInfo(debugLevel)
{
	allowedStancesStr = "";
	faceMotion = "";

	if( self IsStanceAllowed("stand") )
		allowedStancesStr += "s";
	if( self IsStanceAllowed("crouch") )
		allowedStancesStr += "c";
	if( self IsStanceAllowed("prone") )
		allowedStancesStr += "p";

	// general info: entnum - pose - movement type - goal radius
	drawDebugEntText( "(" + self getEntityNumber() + ") : " + self.a.pose + " (" + allowedStancesStr + ") : " + self.a.movement + " : " + self.movemode + " : " + self.goalradius + " : " + self.pathEnemyFightDist + " : " + self.subclass + " : " + self.animType + " : KCM" + self.keepClaimedNode + " : KCMV" + self.keepClaimedNodeIfValid, self, level.color_debug["cyan"], "Animscript" );

	// extra info
	extraInfoStr = "";
	
	if( self.combatMode != "cover" )
	{
		extraInfoStr += self.combatMode + " ";
	}

	if( self.ignoreall )
	{
		extraInfoStr += "ignoreAll ";
	}

	if( self.ignoreme )
	{
		extraInfoStr += "ignoreMe ";
	}
	
	if( self.pacifist )
	{
		extraInfoStr += "pacifist ";
	}

	if( self.ignoresuppression )
	{
		extraInfoStr += "ignoreSuppression ";
	}

	if( !IS_TRUE(self.a.allow_shooting) )
	{
		extraInfoStr += "!allow_shooting ";
	}

	if( ISCQB(self) )
	{
		extraInfoStr += "cqb ";
	}
	
	if( IS_TRUE(self.heat) )
	{
		extraInfoStr += "heat ";
	}

	if( IS_TRUE(self.walk) )
	{
		extraInfoStr += "walk ";
	}

	if( IS_TRUE(self.sprint) )
	{
		extraInfoStr += "sprint ";
	}

	if( IS_TRUE(self.disableArrivals) )
	{
		extraInfoStr += "!arrivals ";
	}

	if( IS_TRUE(self.disableExits) )
	{
		extraInfoStr += "!exits ";
	}

	if( self.isWounded )
	{
		extraInfoStr += "wounded ";
	}

	if( self.grenadeAwareness == 0 )
	{
		extraInfoStr += "!grenadeAwareness ";
	}

	if( !self.takedamage )
	{
		extraInfoStr += "!takedamage ";
	}

	if( !self.allowPain )
	{
		extraInfoStr += "!allowPain ";
	}

//	if( !self.allowDeath )
//	{
//		extraInfoStr += "!allowDeath ";
//	}

	if( self.delayedDeath )
	{
		extraInfoStr += "delayedDeath ";
	}

	if( IS_TRUE(self.disableTurns) )
	{
		extraInfoStr += "disableTurns ";
	}
	
	if( IsDefined(self.a.script_suffix) )
	{
		extraInfoStr += "CD-" + self.a.script_suffix + " ";
	}
	
	if( IsDefined(self.a.special) )
	{
		extraInfoStr += self.a.special;
	}

	if( IsDefined(self.blockingpain) )
	{
		extraInfoStr += " blockingpain-" + self.blockingpain;
	}
	
	if( IsDefined(self.reacquire_state) )
	{
		extraInfoStr += " reacquire-" + self.reacquire_state;
	}
	
	extraInfoStr += "\n";
	
	if( IsDefined(self.weaponclass) )
	{
		extraInfoStr += " WeaponClass-" + self.weaponclass;
	}
	
	if( IsDefined(self.bulletsInClip) )
	{
		extraInfoStr += " BulletsInClip-" + self.bulletsInClip;
	}
	
	if( IsDefined(self.a.rockets) )
	{
		extraInfoStr += " Rockets-" + self.a.rockets;
	}
	
	if( extraInfoStr != "" )
	{
		drawDebugEntText( extraInfoStr, self, level.color_debug["grey"], "Animscript" );
	}

	// weapon info
	drawDebugEntText( self.primaryweapon + " : " + self.secondaryweapon + " : " + self.sidearm + " (" + self.weapon + ")", self, level.color_debug["grey"], "Animscript" );

	// state info
	for( i=0; i < self.debugInfo.states.size; i++ )
	{
		stateString = self.debugInfo.states[i].stateName;

		if( debugLevel > 1 )
		{
			stateString += " (" + (GetTime() - self.debugInfo.states[i].stateTime)/1000 + ")";
		}

		if( IsDefined(self.debugInfo.states[i].extraInfo) )
		{
			stateString += ": " + self.debugInfo.states[i].extraInfo;
		}

		lineColor = level.color_debug["white"];

		// state was popped this frame
		if( !self.debugInfo.states[i].stateValid )
		{
			stateString += " [end";
			lineColor = (1,0.75,0.75);

			if( IsDefined(self.debugInfo.states[i].exitReason) )
			{
				stateString += ": " + self.debugInfo.states[i].exitReason;
			}

			stateString += "]";
		}
		else if( self.debugInfo.states[i].stateTime == GetTime() - 50 ) // new state
		{
			lineColor = (0.75,1,0.75);
		}

		drawDebugEntText( indent(self.debugInfo.states[i].stateLevel) + "-" + stateString, self, lineColor, "Animscript" );
	}

	// insert empty line
	drawDebugEntText( " ", self, level.color_debug["grey"], "Animscript" );

	// remove popped states
	debugCleanStateStack();
}

drawDebugEntText( text, ent, color, channel )
{
	assert( IsDefined(ent) );

	if( !GetDvarint( "recorder_enableRec") )
	{
		if( !IsDefined(ent.debugAnimScriptTime) || GetTime() > ent.debugAnimScriptTime )
		{
			ent.debugAnimScriptLevel = 0;
			ent.debugAnimScriptTime = GetTime();
		}

		indentLevel = VectorScale( (0,0,-10), ent.debugAnimScriptLevel );
		print3d( self.origin + (0,0,70) + indentLevel, text, color );
		ent.debugAnimScriptLevel++;
	}
	else
	{
		recordEntText( text, ent, color, channel );
	}
}

debugPushState(stateName, extraInfo)
{
	if( !GetDvarint( "ai_debugAnimscript") )
	{
		return;
	}

	// don't do anything if it's not the selected ent
	ai_entNum = GetDvarint( "ai_debugEntIndex");
	if( ai_entNum > -1 && ai_entNum != self getEntityNumber() )
	{
		return;
	}

	assert( IsDefined(self.debugInfo.states) );
	assert( IsDefined(stateName) );

	//recordEntText( "push: " + stateName, self, level.color_debug["green"], "Animscript" );

	state			 = SpawnStruct();
	state.stateName  = stateName;
	state.stateLevel = self.debugInfo.stateLevel;
	state.stateTime  = GetTime();
	state.stateValid = true;

	self.debugInfo.stateLevel++;

	if( IsDefined(extraInfo) )
	{
		state.extraInfo = extraInfo + " ";
	}

	self.debugInfo.states[ self.debugInfo.states.size ] = state;
}

debugAddStateInfo(stateName, extraInfo)
{
	if( !GetDvarint( "ai_debugAnimscript") )
	{
		return;
	}

	// don't do anything if it's not the selected ent
	ai_entNum = GetDvarint( "ai_debugEntIndex");
	if( ai_entNum > -1 && ai_entNum != self getEntityNumber() )
	{
		return;
	}

	assert( IsDefined(self.debugInfo.states) );

	// find the first matching state from bottom
	if( IsDefined(stateName) )
	{
		for( i = self.debugInfo.states.size - 1; i >= 0; i-- )
		{
			assert( IsDefined( self.debugInfo.states[i] ) );

			if( self.debugInfo.states[i].stateName == stateName )
			{
				if( !IsDefined(self.debugInfo.states[i].extraInfo) )
				{
					self.debugInfo.states[i].extraInfo = "";
				}

				self.debugInfo.states[i].extraInfo += extraInfo + " ";
				break;
			}
		}
	}
	else if( self.debugInfo.states.size > 0 )
	{
		// add to the last one
		lastIndex = self.debugInfo.states.size - 1;

		assert( IsDefined(self.debugInfo.states[lastIndex]) );

		if( !IsDefined(self.debugInfo.states[lastIndex].extraInfo) )
		{
			self.debugInfo.states[lastIndex].extraInfo = "";
		}

		self.debugInfo.states[lastIndex].extraInfo += extraInfo + " ";
	}
}

debugPopState(stateName, exitReason)
{
	if( !GetDvarint( "ai_debugAnimscript") || self.debugInfo.states.size <= 0 )
	{
		return;
	}

	// don't do anything if it's not the selected ent
	ai_entNum = GetDvarint( "ai_debugEntIndex");
	
	if(!IsDefined(self)|| !IsAlive(self))
	{
		return;
	}
	
	if( ai_entNum > -1 && ai_entNum != self getEntityNumber() )
	{
		return;
	}

	assert( IsDefined(self.debugInfo.states) );

	if( IsDefined(stateName) )
	{
		//recordEntText( "pop: " + stateName, self, level.color_debug["red"], "Animscript" );

		// remove elements at and after stateName
		for( i=0; i < self.debugInfo.states.size; i++ )
		{
			if( self.debugInfo.states[i].stateName == stateName && self.debugInfo.states[i].stateValid )
			{
				self.debugInfo.states[i].stateValid	= false;
				self.debugInfo.states[i].exitReason	= exitReason;
				self.debugInfo.stateLevel			= self.debugInfo.states[i].stateLevel;

				// invalidate all states below this one
				for( j=i+1; j < self.debugInfo.states.size && self.debugInfo.states[j].stateLevel > self.debugInfo.states[i].stateLevel; j++ )
				{
					self.debugInfo.states[j].stateValid = false;
				}

				break;
			}
		}
	}
	else
	{
		//recordEntText( "pop", self, level.color_debug["red"], "Animscript" );

		// remove the last element
		for( i = self.debugInfo.states.size - 1; i >= 0; i-- )
		{
			if( self.debugInfo.states[ i ].stateValid )
			{
				self.debugInfo.states[ i ].stateValid = false;
				self.debugInfo.states[ i ].exitReason = exitReason;
				self.debugInfo.stateLevel--;

				break;
			}
		}
	}
}

debugClearState()
{
	self.debugInfo.states		= [];
	self.debugInfo.stateLevel	= 0;
	self.debugInfo.shouldClearOnAnimscriptChange = false;
}

debugShouldClearState()
{
	if( IsDefined(self.debugInfo) && IsDefined(self.debugInfo.shouldClearOnAnimscriptChange) && self.debugInfo.shouldClearOnAnimscriptChange )
	{
		return true;
	}

	return false;
}

debugCleanStateStack()
{
	newArray = [];
	for( i=0; i < self.debugInfo.states.size; i++ )
	{
		if( self.debugInfo.states[i].stateValid )
		{
			newArray[ newArray.size ] = self.debugInfo.states[i];
		}
	}

	self.debugInfo.states = newArray;
}

indent(depth)
{
	indent = "";

	for( i=0; i < depth; i++ )
	{
		indent += " ";
	}

	return indent;
}
#/
