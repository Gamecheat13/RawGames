#using scripts\shared\ai_shared;
#using scripts\shared\math_shared;
#using scripts\shared\sound_shared;
#using scripts\shared\util_shared;

#using scripts\shared\ai\systems\debug;
#using scripts\shared\ai\systems\init;
#using scripts\shared\ai\archetype_utility;
#using scripts\shared\ai\systems\weaponList;

    	   	                                                                                                                         	                                                                                                                                                                                                                                                                                                                                                                    	        	     	             	    	   	                           	                               	                                	                                                              	                                                                                                              	                            	                                     	                                       	                                                               	   	                  	       	                                                    	                   	                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                        	                                                                                        	           	                        	                                            	                                             	                                                   	                                                             	                                                         	                                                                    	                                                                                                                                                                                                    	                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                      	                                                              	                                                          	                                   	                                   	                                                    	                                       
                                                              	   	                             	  	                                      

#using_animtree("generic");	

function placeWeaponOn( weapon, position )
{	
	self notify("weapon_position_change");

	if (!isdefined(self.weaponInfo[weapon]))
		self init::initWeapon( weapon );
		
	curPosition = self.weaponInfo[weapon].position;
	
	// make sure we're not out of sync
	assert( curPosition == "none" || self.a.weaponPos[curPosition] == weapon );
	
	// weapon already in place
	if ( position != "none" && self.a.weaponPos[position] == weapon )
		return;
		
	//println("detach all (" + weapon.name + ", " + position + ")"); 
	self detachAllWeaponModels();
	
	// detach if we're already in a position
	if ( curPosition != "none" )
		self detachWeapon( weapon );
			
	// nothing more to do
	if ( position == "none" )
	{
		//println("update(1) all (" + weapon.name + ", " + position + ")"); 
		self updateAttachedWeaponModels();
		self AiUtility::setCurrentWeapon( level.weaponNone );
		return;
	}

	if ( self.a.weaponPos[position] != level.weaponNone )
		self detachWeapon( self.a.weaponPos[position] );

	// to ensure that the correct tags for the active weapon are used, we need to make sure it gets attached first
	if ( position == "left" || position == "right" )
	{
		self updateScriptWeaponInfoAndPos( weapon, position );
		self AiUtility::setCurrentWeapon(weapon);		
	}
	else
	{
		self updateScriptWeaponInfoAndPos( weapon, position );
	}

	self updateAttachedWeaponModels();
	
	// make sure we don't have a weapon in each hand
	assert( self.a.weaponPos["left"] == level.weaponNone || self.a.weaponPos["right"] == level.weaponNone );
}	

function detachWeapon( weapon )
{
	self.a.weaponPos[self.weaponInfo[weapon].position] = level.weaponNone;
	self.weaponInfo[weapon].position = "none";
}


function updateScriptWeaponInfoAndPos( weapon, position )
{
	self.weaponInfo[weapon].position = position;
	self.a.weaponPos[position] = weapon;
}

function detachAllWeaponModels()
{
	if( isdefined(self.weapon_positions) )
	{
		for ( index = 0; index < self.weapon_positions.size; index++ )
		{
			weapon = self.a.weaponPos[self.weapon_positions[index]];
			
			if ( weapon == level.weaponNone )
				continue;
							
			self SetActorWeapon( level.weaponNone );
		}
	}
}

function updateAttachedWeaponModels()
{
	if( isdefined(self.weapon_positions) )
	{
		for ( index = 0; index < self.weapon_positions.size; index++ )
		{
			weapon = self.a.weaponPos[self.weapon_positions[index]];
			
			if ( weapon == level.weaponNone )
				continue;
			
			// weapon should only be assigned (means self.weapon will be set) to the weapon	if its set to go to "right"
			if( self.weapon_positions[index] != "right" )
				continue;
			
			self SetActorWeapon( weapon, self GetActorWeaponOptions() );

			if ( self.weaponInfo[weapon].useClip && !self.weaponInfo[weapon].hasClip )
				self hidepart( "tag_clip" );
		}
	}
}

function getTagForPos( position )
{
	switch ( position )
	{
		case "chest":
			return "tag_weapon_chest";
		case "back":
			return "tag_stowed_back";
		case "left":
			return "tag_weapon_left";
		case "right":
			return "tag_weapon_right";
		case "hand":
			return "tag_inhand";
		default:
			assertMsg( "unknown weapon placement position: " + position );
		break;
	}
}

function ThrowWeapon( weapon, positionTag, scavenger )
{
	waitTime = 0.1;
	linearScalar = 2.0;
	angularScalar = 10;
	
	// Calculate the linear and angular velocity to launch the weapon.
	startPosition = self GetTagOrigin( positionTag );
	startAngles = self GetTagAngles( positionTag );
	
	// Wait two server frames to calculate velocity.
	wait( waitTime );
	
	if ( IsDefined( self ) )
	{
		endPosition = self GetTagOrigin( positionTag );
		endAngles = self GetTagAngles( positionTag );
		
		linearVelocity = ( endPosition - startPosition ) * ( 1.0 / waitTime ) * linearScalar;
		angularVelocity = VectorNormalize( endAngles - startAngles ) * angularScalar;
		
		return self DropWeapon( weapon, positionTag, linearVelocity, angularVelocity, scavenger );
	}
}

function DropAIWeapon()
{
	if( self.weapon == level.weaponNone )
	{
		return;
	}

	if (( isdefined( self.script_nodropsecondaryweapon ) && self.script_nodropsecondaryweapon ) && (self.weapon == self.initial_secondaryweapon))
	{
		/#PrintLn("Not dropping secondary weapon '" + self.weapon.name + "'");#/
		return;
	}
	else if (( isdefined( self.script_nodropsidearm ) && self.script_nodropsidearm ) && (self.weapon == self.sidearm))
	{
		/#PrintLn("Not dropping sidearm '" + self.weapon.name + "'");#/
		return;
	}
	
    shouldDropWeapon = !IsDefined( self.dontDropWeapon ) || self.dontDropWeapon === false;
    
    current_weapon = self.weapon;
        
    if ( shouldDropWeapon && self.dropWeapon )
	{
		dropWeaponName = player_weapon_drop(current_weapon);
		position = self.weaponInfo[ current_weapon ].position;
		positionTag = getTagForPos( position );
		
		ThrowWeapon( dropWeaponName, positionTag, false );
		
		if ( !IsDefined( self ) )
		{
			return;
		}
	}
	
	if ( self.weapon != level.weaponNone )
	{
		shared::placeWeaponOn( current_weapon, "none" );

		if( self.weapon == self.primaryweapon )
		{
			self AiUtility::setPrimaryWeapon( level.weaponNone );
		}
		else if( self.weapon == self.secondaryweapon )
		{
			self AiUtility::setSecondaryWeapon( level.weaponNone );
		}
	}
	
	self AiUtility::setCurrentWeapon( level.weaponNone );
}

function DropAllAIWeapons()
{
	if (( isdefined( self.a.dropping_weapons ) && self.a.dropping_weapons ))
	{
		// already called
		return;
	}

	if( !self.dropweapon )
	{
		if( self.weapon != level.weaponNone )
		{
			shared::placeWeaponOn( self.weapon, "none" );
			self AiUtility::setCurrentWeapon( level.weaponNone );
		}

		return;
	}

	self.a.dropping_weapons = true;

	self detachAllWeaponModels();
	
	droppedSideArm = false;
	
	if( isdefined(self.weapon_positions) )
	{
		for ( index = 0; index < self.weapon_positions.size; index++ )
		{
			weapon = self.a.weaponPos[ self.weapon_positions[ index ] ];

			if ( weapon != level.weaponNone )
			{
				self.weaponInfo[ weapon ].position = "none";			
				self.a.weaponPos[ self.weapon_positions[ index ] ] = level.weaponNone;

				if (( isdefined( self.script_nodropsecondaryweapon ) && self.script_nodropsecondaryweapon ) && (weapon == self.initial_secondaryweapon))
				{
					/#PrintLn("Not dropping secondary weapon '" + weapon.name + "'");#/
				}
				else if (( isdefined( self.script_nodropsidearm ) && self.script_nodropsidearm ) && (weapon == self.sidearm))
				{
					/#PrintLn("Not dropping sidearm '" + weapon.name + "'");#/
				}
				else
				{

					velocity = self GetVelocity();
					speed = Length( velocity ) * 0.5;
					
					weapon = player_weapon_drop(weapon);
					
					droppedWeapon = self DropWeapon( weapon, self.weapon_positions[ index ], speed );
					
					if ( self.sideArm != level.weaponNone )
					{
						if ( weapon == self.sideArm )
							droppedSideArm = true;
					}						
				}
			}
		}
	}
	
	if( !droppedSideArm && self.sideArm != level.weaponNone )
	{
		// 10% chance of dropping sidearm
		if( RandomInt(100) <= 10 )
		{
			velocity = self GetVelocity();
			speed = Length( velocity ) * 0.5;
	
			droppedWeapon = self DropWeapon( self.sideArm, "chest", speed );
		}
	}
			
	self AiUtility::setCurrentWeapon( level.weaponNone );

	self.a.dropping_weapons = undefined;
}

function player_weapon_drop( weapon )
{
	if ( IsSubStr( weapon.name, "rpg" ) )
	{
		return GetWeapon( "rpg_player" );
	}
	
	return weapon;
}


function HandleNoteTrack( note, flagName, customFunction, var1 )
{

}

// DoNoteTracks waits for and responds to standard noteTracks on the animation, returning when it gets an "end" or a "finish"
// For level scripts, a pointer to a custom function should be passed as the second argument, which handles notetracks not
// already handled by the generic function. This call should take the form DoNoteTracks(flagName,&customFunction);
// The custom function will be called for each notetrack not recognized, and will pass the notetrack name. Note that this
// function could be called multiple times for a single animation.
function DoNoteTracks( flagName, customFunction, debugIdentifier, var1 ) // debugIdentifier isn't even used. we should get rid of it.
{
	for (;;)
	{
		self waittill (flagName, note);

		if ( !isdefined( note ) )
		{
			note = "undefined";
		}
		
		val = self HandleNoteTrack( note, flagName, customFunction, var1 );
		
		if ( isdefined( val ) )
		{
			return val;
		}
	}
}


function DoNoteTracksIntercept( flagName, interceptFunction, debugIdentifier ) // debugIdentifier isn't even used. we should get rid of it.
{
	assert( isdefined( interceptFunction ) );
	
	for (;;)
	{
		self waittill ( flagName, note );

		if ( !isdefined( note ) )
		{
			note = "undefined";
		}

		intercepted = [[interceptFunction]]( note );
		if ( isdefined( intercepted ) && intercepted )
		{
			continue;
		}

		val = self HandleNoteTrack( note, flagName );
		
		if ( isdefined( val ) )
		{
			return val;
		}
	}
}


function DoNoteTracksPostCallback( flagName, postFunction )
{
	assert( isdefined( postFunction ) );
	
	for (;;)
	{
		self waittill ( flagName, note );

		if ( !isdefined( note ) )
		{
			note = "undefined";
		}

		val = self HandleNoteTrack( note, flagName );
		
		[[postFunction]]( note );
		
		if ( isdefined( val ) )
		{
			return val;
		}
	}
}

// Don't call this function except as a thread you're going to kill - it lasts forever.
function DoNoteTracksForever(flagName, killString, customFunction, debugIdentifier)
{
	DoNoteTracksForeverProc(&DoNoteTracks, flagName, killString, customFunction, debugIdentifier);
}

function DoNoteTracksForeverIntercept(flagName, killString, interceptFunction, debugIdentifier)
{
	DoNoteTracksForeverProc(&DoNoteTracksIntercept, flagName, killString, interceptFunction, debugIdentifier );
}

function DoNoteTracksForeverProc( notetracksFunc, flagName, killString, customFunction, debugIdentifier )
{
	if (isdefined (killString))
	{
		self endon (killString);
	}

	self endon ("killanimscript");
	
	if (!isdefined(debugIdentifier))
	{
		debugIdentifier = "undefined";
	}

	for (;;)
	{
		time = GetTime();
		returnedNote = [[notetracksFunc]](flagName, customFunction, debugIdentifier);
		timetaken = GetTime() - time;
		if ( timetaken < 0.05)
		{
			time = GetTime();
			returnedNote = [[notetracksFunc]](flagName, customFunction, debugIdentifier);
			timetaken = GetTime() - time;
			if ( timetaken < 0.05)
			{
				/#println (GetTime()+" "+debugIdentifier+" shared::DoNoteTracksForever is trying to cause an infinite loop on anim "+flagName+", returned "+returnedNote+".");#/
				wait ( 0.05 - timetaken );
			}
		}
		//(GetTime()+" "+debugIdentifier+" DoNoteTracksForever returned in "+timetaken+" ms.");#/
	}	
}

// Designed for using DoNoteTracks on looping animations, so you can wait for a time instead of the "end" parameter
function DoNoteTracksForTime(time, flagName, customFunction, debugIdentifier)
{
	ent = SpawnStruct();
	ent thread doNoteTracksForTimeEndNotify(time);
	DoNoteTracksForTimeProc(&DoNoteTracksForever, time, flagName, customFunction, debugIdentifier, ent);
}

function DoNoteTracksForTimeIntercept( time, flagName, interceptFunction, debugIdentifier)
{
	ent = SpawnStruct();
	ent thread doNoteTracksForTimeEndNotify(time);
	DoNoteTracksForTimeProc(&DoNoteTracksForeverIntercept, time, flagName, interceptFunction, debugIdentifier, ent);
}

function DoNoteTracksForTimeProc( doNoteTracksForeverFunc, time, flagName, customFunction, debugIdentifier, ent)
{
	ent endon ("stop_notetracks");
	[[doNoteTracksForeverFunc]](flagName, undefined, customFunction, debugIdentifier);
}

function doNoteTracksForTimeEndNotify(time)
{
	wait (time);
	self notify ("stop_notetracks");
}

