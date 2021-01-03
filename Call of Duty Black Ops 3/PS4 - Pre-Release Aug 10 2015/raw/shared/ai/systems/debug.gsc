#using scripts\shared\system_shared;
#using scripts\shared\ai\archetype_utility;

    	   	                                                                                                                                         	                                	                                                                                                                                                                                                                                                                                                                                                                    	        	     	             	    	   	               	                                              	                                                           	                               	                     	                                                                                                           	                                                                 	                                                              	                                                                                                              	                            	                                     	                                       	                                                                                                              	   	                  	       	                                                    	                   	                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                        	                                  	                                                                                        	           	                        	                                            	                                             	                                                   	                                                             	                                                         	                                                                    	                                                                                                                                                                                                    	                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                         	                                                              	                                                          	                                   	                                   	                                                    	                                       	                                           	     	                                                                                                                                                                                                                                                      	                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                     
                                                                  	                             	  	                                      

#namespace as_debug;

/#
function autoexec __init__sytem__() {     system::register("as_debug",&__init__,undefined,undefined);    }
#/

/#

function __init__()
{
}

function isDebugOn()
{
	return ( (GetDvarInt("animDebug") == 1) || ( isdefined (anim.debugEnt) && anim.debugEnt == self ) );
}

function drawDebugLineInternal(fromPoint, toPoint, color, durationFrames)
{
	//println ("Drawing line, color "+color[0]+","+color[1]+","+color[2]);
	//player = getent("player", "classname" );
	//println ( "Point1 : "+fromPoint+", Point2: "+toPoint+", player: "+player.origin );
	for (i=0;i<durationFrames;i++)
	{
		line (fromPoint, toPoint, color);
		{wait(.05);};
	}
}

function drawDebugLine(fromPoint, toPoint, color, durationFrames)
{
	if (isDebugOn())
	{
		thread drawDebugLineInternal(fromPoint, toPoint, color, durationFrames);
	}
}

function debugLine(fromPoint, toPoint, color, durationFrames)
{
	for (i=0;i<durationFrames*20;i++)
	{
		line (fromPoint, toPoint, color);
		{wait(.05);};
	}
}

function drawDebugCross(atPoint, radius, color, durationFrames)
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

function UpdateDebugInfo()
{
	self endon("death");

	self.debugInfo = SpawnStruct();
	self.debugInfo.enabled = GetDvarint( "ai_debugAnimscript") > 0;
	debugClearState();

	while(1)
	{
		// the waittillframeend causes a random crash in the VM
		//waittillframeend;
		{wait(.05);};

		UpdateDebugInfoInternal();

		{wait(.05);};
	}
}

function UpdateDebugInfoInternal()
{
	if( isdefined(anim.debugEnt) && (anim.debugEnt==self) )
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
}

function drawDebugEntText( text, ent, color, channel )
{
	assert( isdefined(ent) );

	if( !GetDvarint( "recorder_enableRec") )
	{
		if( !isdefined(ent.debugAnimScriptTime) || GetTime() > ent.debugAnimScriptTime )
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

function debugPushState(stateName, extraInfo)
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

	assert( isdefined(self.debugInfo.states) );
	assert( isdefined(stateName) );

	//recordEntText( "push: " + stateName, self, GREEN, "Animscript" );

	state			 = SpawnStruct();
	state.stateName  = stateName;
	state.stateLevel = self.debugInfo.stateLevel;
	state.stateTime  = GetTime();
	state.stateValid = true;

	self.debugInfo.stateLevel++;

	if( isdefined(extraInfo) )
	{
		state.extraInfo = extraInfo + " ";
	}

	self.debugInfo.states[ self.debugInfo.states.size ] = state;
}

function debugAddStateInfo(stateName, extraInfo)
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

	assert( isdefined(self.debugInfo.states) );

	// find the first matching state from bottom
	if( isdefined(stateName) )
	{
		for( i = self.debugInfo.states.size - 1; i >= 0; i-- )
		{
			assert( isdefined( self.debugInfo.states[i] ) );

			if( self.debugInfo.states[i].stateName == stateName )
			{
				if( !isdefined(self.debugInfo.states[i].extraInfo) )
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

		assert( isdefined(self.debugInfo.states[lastIndex]) );

		if( !isdefined(self.debugInfo.states[lastIndex].extraInfo) )
		{
			self.debugInfo.states[lastIndex].extraInfo = "";
		}

		self.debugInfo.states[lastIndex].extraInfo += extraInfo + " ";
	}
}

function debugPopState(stateName, exitReason)
{
	if( !GetDvarint( "ai_debugAnimscript") || self.debugInfo.states.size <= 0 )
	{
		return;
	}

	// don't do anything if it's not the selected ent
	ai_entNum = GetDvarint( "ai_debugEntIndex");
	
	if(!isdefined(self)|| !IsAlive(self))
	{
		return;
	}
	
	if( ai_entNum > -1 && ai_entNum != self getEntityNumber() )
	{
		return;
	}

	assert( isdefined(self.debugInfo.states) );

	if( isdefined(stateName) )
	{
		//recordEntText( "pop: " + stateName, self, RED, "Animscript" );

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
		//recordEntText( "pop", self, RED, "Animscript" );

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

function debugClearState()
{
	self.debugInfo.states		= [];
	self.debugInfo.stateLevel	= 0;
	self.debugInfo.shouldClearOnAnimscriptChange = false;
}

function debugShouldClearState()
{
	if( isdefined(self.debugInfo) && isdefined(self.debugInfo.shouldClearOnAnimscriptChange) && self.debugInfo.shouldClearOnAnimscriptChange )
	{
		return true;
	}

	return false;
}

function debugCleanStateStack()
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

function indent(depth)
{
	indent = "";

	for( i=0; i < depth; i++ )
	{
		indent += " ";
	}

	return indent;
}

function debugDrawWeightedPoints( entity, points, weights )
{
	lowestValue = 0;
	highestValue = 0;

	for (index = 0; index < points.size; index++)
	{
		if ( weights[index] < lowestValue )
		{
			lowestValue =  weights[index];
		}
		
		if (  weights[index] > highestValue )
		{
			highestValue =  weights[index];
		}
	}
	

	for (index = 0; index < points.size; index++)
	{
		debugDrawWeightedPoint(entity, points[index], weights[index],lowestValue,highestValue);
	}
}

function debugDrawWeightedPoint( entity, point, weight, lowestValue, highestValue )
{
	deltaValue = highestValue - lowestValue;
	halfDeltaValue = deltaValue / 2.0;
	midValue = lowestValue + deltaValue / 2.0;

	if ( halfDeltaValue == 0 )
	{
		halfDeltaValue = 1;
	}

	if ( weight <= midValue )
	{
		// Bad places.
		redColor = 1 - abs( ( weight - lowestValue ) / halfDeltaValue );
		RecordCircle( point, 2, (redColor,0,0), "Script", entity );
	}
	else
	{
		// Good places.
		greenColor = 1 - abs( ( highestValue - weight ) / halfDeltaValue );
		RecordCircle( point, 2, (0,greenColor,0), "Script", entity );
	}
}

#/
