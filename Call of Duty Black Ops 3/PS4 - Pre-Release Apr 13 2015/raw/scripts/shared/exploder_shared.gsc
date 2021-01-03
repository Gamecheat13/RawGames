#using scripts\codescripts\struct;

#using scripts\shared\util_shared;

    	   	                                                                                                                         	                                                                                                                                                                                                                                                                                                                                                                    	        	     	             	    	   	                           	                               	                                	                                                              	                                                                                                              	                            	                                     	                                       	                                                               	   	                  	       	                                                    	                   	                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                        	                                                                                        	           	                        	                                            	                                             	                                                   	                                                             	                                                         	                                                                    	                                                                                                                                                                                                    	                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                     	                                                              	                                                          	                                   	                                   	                                                    	                                       

#namespace face;

function get_face_callback()
{
	self waittill( "face", value );
	if( ( isdefined( self.zombie_face ) && self.zombie_face ) )
	{
		value = "zombie_" + value;
	}
	return value;
}

function setFaceRoot( root )
{
	if( !isdefined( level.faceStates ) )
	{
		level.faceStates = [];
	}
	
	if( !isdefined( level.faceStates ) )
	{
		level.faceStates = [];
	}
	
	level.faceStates["face_root"] = root;
}

function buildFaceState( face_state, looping, timer, priority, statetype, animation )
{
	if( !isdefined( level.faceStates ) )
	{
		level.faceStates = [];
	}
		
	if( !isdefined( level.faceStates ) )
	{
		level.faceStates = [];
	}
	
	level.faceStates[face_state][ "looping" ] = looping;
	level.faceStates[face_state][ "timer" ] = timer;
	level.faceStates[face_state][ "priority" ] = priority;
	level.faceStates[face_state][ "statetype" ] = statetype;
	level.faceStates[face_state][ "animation" ] = [];
	level.faceStates[face_state][ "animation" ][0] = animation;
}

function addAnimToFaceState( face_state, animation ) 
{
	Assert( isdefined( level.faceStates[face_state] ) );
	Assert( isdefined( level.faceStates[face_state]["animation"] ) );
	
	curr_size = level.faceStates[face_state][ "animation" ].size;
	level.faceStates[face_state][ "animation" ][curr_size] = animation;
}

function waitForAnyPriorityReturn( prevState )
{
	level endon( "demo_jump" );
	self endon( "entityshutdown" );
	self endon( "stop_facial_anims" );
	
	previousPriority = -1; 
	if( isdefined( level.faceStates[prevState] ) )
	{
		previousPriority = level.faceStates[prevState]["priority"];
	}

	while( true )
	{
		newState = get_face_callback();
		if( isdefined( newState ) && IsDefined( level.faceStates[newState] ) && ( level.faceStates[newState]["priority"] > previousPriority ) )
		{
			break;
		}
	}
	
	return newState;
}

function waitForFaceEventRepeat( base_time )
{
	level endon( "demo_jump" );
	self endon( "entityshutdown" );
	self endon( "stop_face_anims" );
	self endon( "new_face_event" );
	self endon( "face_timer_expired" );
		
	state = self.face_curr_event;
	
	while( true )
	{
		newState = get_face_callback();
		if( newState == state )
		{
			self.face_timer = base_time;
		}
	}
}

function waitForFaceEventComplete(localClientNum)
{
	level endon( "demo_jump" );
	self endon( "entityshutdown" );
	self endon( "stop_face_anims" );
	self endon( "new_face_event" );
/#		
	if ( GetDvarint( "cg_debugFace" ) != 0 )
	{
		PrintLn( "Trying to get animation for state "+self.face_curr_event+" # "+self.face_curr_event_idx );
	}
#/	
	Assert( isdefined( level.faceStates[self.face_curr_event]["animation"][self.face_curr_event_idx] ) );

	self.face_timer = GetAnimLength( level.faceStates[self.face_curr_event]["animation"][self.face_curr_event_idx] );
	
	if( level.faceStates[self.face_curr_event]["looping"] )
	{
		self thread waitForFaceEventRepeat( self.face_timer );
	}
/#
	if ( GetDvarint( "cg_debugFace" ) != 0 )
	{
		println("faceTime is " + self.face_timer + "\n");
	}
#/
	if ( !isdefined ( self ) )
		return;
	
	waitrealtime( self.face_timer );
	
	self notify( "face_timer_expired" );
/#
	if ( GetDvarint( "cg_debugFace" ) != 0 )
	{
		println("face_timer_expired");
	}
#/	
	self.face_curr_event = undefined;
	self.face_curr_event_idx = undefined;

	/#
	if ( GetDvarint( "cg_debugFace" ) != 0 )
	{
		println("waiting on dobj");
	}
#/	
	
	self util::waittill_dobj(localClientNum);
	
	if ( !isdefined ( self ) )
		return;
	
	/#
	if ( GetDvarint( "cg_debugFace" ) != 0 )
	{
		println("setAnimKnob Back To base state "+self.face_curr_base);
	}
#/	
	
	if (isdefined(level.faceStates[self.face_curr_base]["animation"][self.face_curr_base_idx]))
	{
		self SetAnimKnob( level.faceStates[self.face_curr_base]["animation"][self.face_curr_base_idx], 1.0, 0.1, 1.0 );
	}
	self notify( "face", "face_advance" );
}

function processFaceEvents( localClientNum )
{
	level endon( "demo_jump" );
	self endon( "entityshutdown" );
	
	if( true )//TODO T7 - temp solution until ZM is
	{
		return;	
	}
		
	// Start the entity in face_alert
	state = "face_alert";
	self.face_curr_base = "face_alert";
	if( ( isdefined( self.zombie_face ) && self.zombie_face ) )
	{
		self.face_curr_base = "zombie_"+self.face_curr_base;
		state = "zombie_"+state;
	}	
	numAnims = level.faceStates[state]["animation"].size;
	self.face_curr_base_idx = RandomInt( numAnims );
/#
	if ( GetDvarint( "cg_debugFace" ) != 0 )
	{
		println("setAnimKnobProcessFaceEvents");
	}
#/	
	self util::waittill_dobj(localClientNum);
	if ( !isdefined ( self ) )
		return;
	self SetAnimKnob( level.faceStates[self.face_curr_base]["animation"][self.face_curr_base_idx], 1.0, 0.0, 1.0 ); 
	
	// Unless we already have preset them as disabled or dead
	if ( isdefined( self.face_disable ) && self.face_disable )
		state = "face_disable";
	else if ( isdefined( self.face_death ) && self.face_death )
		state = "face_death";

	if ( !isdefined(self) )
		return;
	
	self.face_state = state;
/#
	self thread showState();
#/
	self thread watchfor_death();
	
	while ( true )
	{
/#
		if ( GetDvarint( "cg_debugFace" ) != 0 )
		{
			if ( !isdefined( state ) )
				PrintLn( "state undefined\n" );
			if ( !isdefined( level.faceStates ) )
				PrintLn( "level.faceStates undefined\n" );			
			if ( !isdefined( level.faceStates ) )
				PrintLn( "level.faceStates undefined\n" );
			if ( !isdefined( level.faceStates[state] ) )
				PrintLn( "level.faceStates[state] undefined\n" );

			if ( !isdefined( level.faceStates[state] ) )
			{
				
				faceStatesArray = getArrayKeys( level.faceStates );
				PrintLn( state + " undefined\n" );

				for( i = 0; i < faceStatesArray.size; i++ )
				{
					println( i + ":" );
					PrintLn( faceStatesArray[i] + "\n" );
				}
			}
		}
#/
		if ( state == "face_disable")
			numAnims = 0;
		else
			numAnims = level.faceStates[state]["animation"].size;
/#
		if ( GetDvarint( "cg_debugFace" ) != 0 )
		{
			PrintLn( "Found "+numAnims+" anims for state "+state );
		}
#/
		
		// If we have set face_disable on this entity, clear anims and wait for it to unset
		if( isdefined( self.face_disable ) && self.face_disable == true )
		{
/#
			if ( GetDvarint( "cg_debugFace" ) != 0 )
			{
				PrintLn( "Disabling face anims" );
			}
#/
			setFaceState( "face_disabled" );
			self ClearAnim( level.faceStates[ "face_root" ], 0 );
			self notify( "stop_face_anims" );
			
			while( self.face_disable )
			{
				wait( 0.05 );
			}
		}
/#
		if ( GetDvarint( "cg_debugFace" ) != 0 )
		{
			if ( !isdefined( state ) )
				PrintLn( "state undefined\n" );
			if ( !isdefined( level.faceStates ) )
				PrintLn( "level.faceStates undefined\n" );			
			if ( !isdefined( level.faceStates ) )
				PrintLn( "level.faceStates undefined\n" );
			if ( !isdefined( level.faceStates[state] ) )
				PrintLn( "level.faceStates[state] undefined\n" );

			if ( !isdefined( level.faceStates[state] ) )
			{
				
				faceStatesArray = getArrayKeys( level.faceStates );
				PrintLn( state + " undefined\n" );

				for( i = 0; i < faceStatesArray.size; i++ )
				{
					println( i + ":" );
					PrintLn( faceStatesArray[i] + "\n" );
				}
			}
		}
#/

		setFaceState( state );
		
		// If our current state is an exit state, nothing will supercede this animation so we should return
		if( level.faceStates[state]["statetype"] == "exitstate" )
		{
/#
			if ( GetDvarint( "cg_debugFace" ) != 0 )
			{
				PrintLn( "Exitstate found, returning" );
			}
#/
			self util::waittill_dobj(localClientNum);
			if ( !isdefined ( self ) )
				return;
/#
			if ( GetDvarint( "cg_debugFace" ) != 0 )
			{
				println("setAnimKnob286");
			}
#/
			self SetAnimKnob( level.faceStates[state]["animation"][RandomInt(numAnims)], 1.0, 0.1, 1.0 );
			self notify( "stop_face_anims" );
			self.curr_face_base = undefined;
			self.curr_face_event = undefined;
			return; // All done!
		}
		else if( level.faceStates[state]["statetype"] == "basestate" )
		{
			if( !isdefined( self.face_curr_base ) || self.face_curr_base != state )
			{
				self.face_curr_base = state;
				self.face_curr_base_idx = RandomInt( numAnims );
/#
				if ( GetDvarint( "cg_debugFace" ) != 0 )
				{
					PrintLn( "New base face anim state "+self.face_curr_base+" anim # "+self.face_curr_base_idx );
				}
#/
				if( !isdefined( self.face_curr_event ) )
				{
/#
					if ( GetDvarint( "cg_debugFace" ) != 0 )
					{
						PrintLn( "trying to play animation for state "+self.face_curr_base+" w/ index "+self.face_curr_base_idx );
					}
#/
					self util::waittill_dobj(localClientNum);
					if ( !isdefined ( self ) )
						return;
					self SetAnimKnob( level.faceStates[self.face_curr_base]["animation"][self.face_curr_base_idx], 1.0, 0.1, 1.0 );
				}
			}
		}
		else if( level.faceStates[state]["statetype"] == "eventstate" )
		{
			if( !isdefined( self.face_curr_event ) || !level.faceStates[self.face_curr_event]["looping"] || self.face_curr_event != state )
			{
				self.face_curr_event= state;
				self.face_curr_event_idx = RandomInt( numAnims );
/#
				if ( GetDvarint( "cg_debugFace" ) != 0 )
				{
					PrintLn( "New face anim event "+self.face_curr_event+" anim # "+self.face_curr_event_idx );
				}
#/
				self util::waittill_dobj(localClientNum);
				if ( !isdefined ( self ) )
					return;
				self SetFlaggedAnimKnob( "face_event", level.faceStates[self.face_curr_event]["animation"][self.face_curr_event_idx], 1.0, 0.1, 1.0 );
				self thread waitForFaceEventComplete(localClientNum);
			}
		}
		else if( level.faceStates[state]["statetype"] == "nullstate" )
		{
			if( isdefined( self.face_curr_event ) )
			{
				self SetAnimKnob( level.faceStates[self.face_curr_event]["animation"][self.face_curr_event_idx], 1.0, 0.1, 1.0 );
			}
			else if( isdefined( self.face_curr_base ) )
			{
				self SetAnimKnob( level.faceStates[self.face_curr_base]["animation"][self.face_curr_base_idx], 1.0, 0.1, 1.0 );
			}
		}
		
		if( isdefined( self.face_curr_event ) )
		{
			state = self waitForAnyPriorityReturn( self.face_curr_event );
		}
		else
		{
			state = self waitForAnyPriorityReturn( self.face_curr_base );
		}
	}
}

/#
function showState( state )
{
	level endon( "demo_jump" );
	self endon( "entityshutdown" );
	
	while ( true )
	{
		if ( GetDvarint( "cg_debugFace" ) != 0 )
		{
			if ( isdefined( self.face_state ) && isdefined( self.origin ) )
			{
				entNum = self getentitynumber();
				if ( !isdefined( entNum ) )
					entNum = "?";

				if ( isdefined( self.face_disable ) && self.face_disable )
					disableChar = "-";
				else
					disableChar = "+";

				if ( isdefined( self.face_death ) && self.face_death )
					deathChar = "D";
				else
					deathChar = "A";

				Print3d( self.origin + ( 0, 0, 72 ), disableChar + deathChar + "["+ entNum +"]" + self.face_state, (1,1,1), 1, 0.25 );
			}
		}
		
		wait( 0.01 );
	}
}
#/

function setFaceState( state )
{
	if( state == "face_advance" || state == "zombie_face_advance" )
	{
		if( IsDefined( self.face_curr_event ) )
		{
			if( ( isdefined( self.zombie_face ) && self.zombie_face ) && !IsSubStr( self.face_curr_event, "zombie_" ) )
			{
				self.face_curr_event = "zombie_"+self.face_curr_event;
			}
			else if( !( isdefined( self.zombie_face ) && self.zombie_face ) && IsSubStr( self.face_curr_event, "zombie_" ) )
			{
				self.face_curr_base = "face_alert";
				self.face_state = self.face_curr_base;
				return;
			}
			self.face_state = self.face_curr_event;
		}
		else if( IsDefined( self.face_curr_base ) )
		{
			if( ( isdefined( self.zombie_face ) && self.zombie_face ) && !IsSubStr( self.face_curr_base, "zombie_" ) )
			{
				self.face_curr_base = "zombie_"+self.face_curr_base;
			}
			else if( !( isdefined( self.zombie_face ) && self.zombie_face ) && IsSubStr( self.face_curr_base, "zombie_" ) )
			{
				self.face_curr_base = "face_alert";
			}
			self.face_state = self.face_curr_base;
		}
		return;
	}
	self.face_state = state;
}

function watchfor_death()
{
	level endon( "demo_jump" );
	self endon( "entityshutdown" );
	
	if ( !isdefined( self.face_death ) )
	{
		self waittillmatch( "face", "face_death" );
		self.face_death = true;
	}
}

