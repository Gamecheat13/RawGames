
setFaceRoot( root )
{
	if( !IsDefined( level.faceStates ) )
	{
		level.faceStates = [];
	}
	
	if( !IsDefined( level.faceStates[self.face_anim_tree] ) )
	{
		level.faceStates[self.face_anim_tree] = [];
	}
	
	level.faceStates[self.face_anim_tree]["face_root"] = root;
}

buildFaceState( face_state, looping, timer, priority, statetype, animation )
{
	if( !IsDefined( level.faceStates ) )
	{
		level.faceStates = [];
	}
		
	if( !IsDefined( level.faceStates[self.face_anim_tree] ) )
	{
		level.faceStates[self.face_anim_tree] = [];
	}
	
	level.faceStates[self.face_anim_tree][face_state][ "looping" ] = looping;
	level.faceStates[self.face_anim_tree][face_state][ "timer" ] = timer;
	level.faceStates[self.face_anim_tree][face_state][ "priority" ] = priority;
	level.faceStates[self.face_anim_tree][face_state][ "statetype" ] = statetype;
	level.faceStates[self.face_anim_tree][face_state][ "animation" ] = [];
	level.faceStates[self.face_anim_tree][face_state][ "animation" ][0] = animation;
}

addAnimToFaceState( face_state, animation ) 
{
	Assert( IsDefined( level.faceStates[self.face_anim_tree][face_state] ) );
	Assert( IsDefined( level.faceStates[self.face_anim_tree][face_state]["animation"] ) );
	
	curr_size = level.faceStates[self.face_anim_tree][face_state][ "animation" ].size;
	level.faceStates[self.face_anim_tree][face_state][ "animation" ][curr_size] = animation;
}

isHigherPriority( new_state, old_state )
{
	// Ignore the same state if we are looping, this will be handled by the event repeat helper function
	if( new_state == old_state && level.faceStates[self.face_anim_tree][old_state]["looping"] )
	{
		return false;
	}
	if( level.faceStates[self.face_anim_tree][new_state]["priority"] >= level.faceStates[self.face_anim_tree][old_state]["priority"] )
	{
		if ( GetDvarint( "cg_debugFace" ) != 0 )
		{
			PrintLn( "FaceState "+new_state+" is higher priority than "+old_state+" for entity "+self GetEntityNumber() );
		}
		return true;
	}
	if ( GetDvarint( "cg_debugFace" ) != 0 )
	{
		PrintLn( "FaceState "+new_state+" is not higher priority than "+old_state+" for entity "+self GetEntityNumber() );
	}
	return false;
}

faceFrameEndNotify()
{
	self endon( "entityshutdown" );
	self endon( "stop_facial_anims" );
	level endon( "save_restore" );
	
	waittillframeend;
	
	self notify( "face", "frameend" );
}

waitForAnyPriorityReturn( prevState )
{
	self endon( "entityshutdown" );
	self endon( "stop_facial_anims" );
	level endon( "save_restore" );
	
	if ( GetDvarint( "cg_debugFace" ) != 0 )
	{
		PrintLn( "Waiting for priority return for "+prevState+" for entity "+self GetEntityNumber() );
	}
	
	while( true )
	{
		self waittill( "face", newState );
		if( isHigherPriority( newState, prevState ) )
		{
			break;
		}
	}
	
	self thread faceFrameEndNotify();
	
	while( true )
	{
		self waittill( "face", tempState );
		
		if( tempState == "frameend" )
		{
			break;
		}
		
		if( isHigherPriority( tempState, newState ) )
		{
			newState = tempState;
		}
	}
	
	return newState;
}

waitForFaceEventRepeat( base_time )
{
	self endon( "entityshutdown" );
	self endon( "stop_face_anims" );
	self endon( "new_face_event" );
	self endon( "face_timer_expired" );
	level endon( "save_restore" );
		
	state = self.face_curr_event;
	
	while( true )
	{
		self waittill( "face", newState );
		if( newState == state )
		{
			self.face_timer = base_time;
		}
	}
}

waitForFaceEventComplete()
{
	self endon( "entityshutdown" );
	self endon( "stop_face_anims" );
	self endon( "new_face_event" );
	level endon( "save_restore" );
		
	if ( GetDvarint( "cg_debugFace" ) != 0 )
	{
		PrintLn( "Trying to get animation for state "+self.face_curr_event+" # "+self.face_curr_event_idx+" for entity "+self GetEntityNumber() );
	}
	
	Assert( IsDefined( level.faceStates[self.face_anim_tree][self.face_curr_event]["animation"][self.face_curr_event_idx] ) );

	if( IsDefined( level.faceStates[self.face_anim_tree][self.face_curr_event]["timer"] ) )
	{
		self.face_timer = level.faceStates[self.face_anim_tree][self.face_curr_event]["timer"];
	}
	else
	{
		self.face_timer = GetAnimLength( level.faceStates[self.face_anim_tree][self.face_curr_event]["animation"][self.face_curr_event_idx] );
	}

	base_time = self.face_timer;

	if( level.faceStates[self.face_anim_tree][self.face_curr_event]["looping"] )
	{
		self thread waitForFaceEventRepeat( self.face_timer );
	}
	
	while( true )
	{
		if( self.face_timer <= 0 )
		{
			break;
		}
		wait( 0.05 );
		self.face_timer -= 0.05;
	}
	
	self notify( "face_timer_expired" );
	
	if ( GetDvarint( "cg_debugFace" ) != 0 )
	{
		PrintLn( "Timing out face state "+self.face_curr_event+" # "+self.face_curr_event_idx+" for entity "+self GetEntityNumber()+" after "+base_time );
	}
	
	
	self.face_curr_event = undefined;
	self.face_curr_event_idx = undefined;
	
	self SetAnimKnob( level.faceStates[self.face_anim_tree][self.face_curr_base]["animation"][self.face_curr_base_idx], 1.0, 0.1, 1.0 );
	self notify( "face", "face_advance" );
}

processFaceEvents( localClientNum )
{
	self endon( "entityshutdown" );
	level endon( "save_restore" );
		
	// Start the entity in face_alert
	state = "face_alert";
	self.face_curr_base = "face_alert";
	numAnims = level.faceStates[self.face_anim_tree][state]["animation"].size;
	self.face_curr_base_idx = RandomInt( numAnims );
	
	if ( GetDvarint( "cg_debugFace" ) != 0 )
	{
		PrintLn( "Starting entity "+ self GetEntityNumber() +" in state face_alert" );
		PrintLn( "Found "+numAnims+" anims for state face_alert for entity "+self GetEntityNumber() );
		PrintLn( "Selected anim "+self.face_curr_base_idx+" for entity "+self GetEntityNumber() );
	}
	self SetAnimKnob( level.faceStates[self.face_anim_tree][self.face_curr_base]["animation"][self.face_curr_base_idx], 1.0, 0.0, 1.0 ); 
	
	// Unless we already have preset them as disabled or dead
	if ( isdefined( self.face_death ) && self.face_death )
		state = "face_death";

	self.face_state = state;
	self thread showState();
	self thread watchfor_death();
	
	while ( true )
	{
		if( GetDvarint( "cg_debugFace" ) != 0 )
		{
			if( !IsDefined( level.faceStates ) )
			{
				PrintLn( "No face state array!\n" );
			}
			else if( !IsDefined( self.face_anim_tree ) )
			{
				PrintLn( "No face anim tree for entity "+self GetEntityNumber() );
			}
			else if( !IsDefined( state ) )
			{
				PrintLn( "No face state for entity "+self GetEntityNumber() );
			}
			else if( !IsDefined( level.faceStates[self.face_anim_tree] ) )
			{
				PrintLn( "No face state array for anim tree "+self.face_anim_tree+" used by entity "+self GetEntityNumber() );
			}
			else if( !IsDefined( level.faceStates[self.face_anim_tree][state] ) )
			{
				PrintLn( "No face state array entry for state "+state+" in anim tree "+self.face_anim_tree+" for entity "+self GetEntityNumber() );
			}
		}
		
		if ( GetDvarint( "cg_debugFace" ) != 0 )
		{
			PrintLn( "Found "+numAnims+" anims for state "+state+" for entity "+self GetEntityNumber() );
		}
		
		// If we have set face_disable on this entity, clear anims and wait for it to unset
		if( IsDefined( self.face_disable ) && self.face_disable )
		{
			if ( GetDvarint( "cg_debugFace" ) != 0 )
			{
				PrintLn( "Disabling face anims for entity "+self GetEntityNumber() );
			}
			setFaceState( "face_disabled" );
			self ClearAnim( level.faceStates[self.face_anim_tree][ "face_root" ], 0 );
			self notify( "stop_face_anims" );
			
			self.face_curr_event = undefined;
			self.face_curr_event_idx = undefined;
			
			while( self.face_disable )
			{
				wait( 0.05 );
			}
		}
		
		numAnims = level.faceStates[self.face_anim_tree][state]["animation"].size;
		
		setFaceState( state );
		
		// If our current state is an exit state, nothing will supercede this animation so we should return
		if( level.faceStates[self.face_anim_tree][state]["statetype"] == "nullstate" )
		{
			if( IsDefined( self.face_curr_event ) )
			{
				self SetAnimKnob( level.faceStates[self.face_anim_tree][self.face_curr_event]["animation"][self.face_curr_event_idx], 1.0, 0.1, 1.0 );
			}
			else if( IsDefined( self.face_curr_base ) )
			{
				self SetAnimKnob( level.faceStates[self.face_anim_tree][self.face_curr_base]["animation"][self.face_curr_base_idx], 1.0, 0.1, 1.0 );
			}
		}
		else if( level.faceStates[self.face_anim_tree][state]["statetype"] == "exitstate" )
		{
			if ( GetDvarint( "cg_debugFace" ) != 0 )
			{
				PrintLn( "Exitstate found, returning for entity "+self GetEntityNumber() );
			}
			self SetAnimKnob( level.faceStates[self.face_anim_tree][state]["animation"][RandomInt(numAnims)], 1.0, 0.1, 1.0 );
			self notify( "stop_face_anims" );
			self.face_curr_event = undefined;
			self.face_curr_event_idx = undefined;
			return; // All done!
		}
		else if( level.faceStates[self.face_anim_tree][state]["statetype"] == "basestate" )
		{
			if( !IsDefined( self.face_curr_base ) || self.face_curr_base != state )
			{
				self.face_curr_base = state;
				self.face_curr_base_idx = RandomInt( numAnims );
				if ( GetDvarint( "cg_debugFace" ) != 0 )
				{
					PrintLn( "New base face anim state "+self.face_curr_base+" anim # "+self.face_curr_base_idx+"  for entity "+self GetEntityNumber() );
				}
				if( !IsDefined( self.face_curr_event ) )
				{
					if ( GetDvarint( "cg_debugFace" ) != 0 )
					{
						PrintLn( "trying to play animation for state "+self.face_curr_base+" w/ index "+self.face_curr_base_idx+" for entity "+self GetEntityNumber() );
					}
					self SetAnimKnob( level.faceStates[self.face_anim_tree][self.face_curr_base]["animation"][self.face_curr_base_idx], 1.0, 0.1, 1.0 );
				}
			}
		}
		else if( level.faceStates[self.face_anim_tree][state]["statetype"] == "eventstate" )
		{
			if( !IsDefined( self.face_curr_event ) || !level.faceStates[self.face_anim_tree][self.face_curr_event]["looping"] || self.face_curr_event != state )
			{
				self.face_curr_event= state;
				self.face_curr_event_idx = RandomInt( numAnims );
				if ( GetDvarint( "cg_debugFace" ) != 0 )
				{
					PrintLn( "New face anim event "+self.face_curr_event+" anim # "+self.face_curr_event_idx+" for entity "+self GetEntityNumber() );
				}
				self SetFlaggedAnimKnob( "face_event", level.faceStates[self.face_anim_tree][self.face_curr_event]["animation"][self.face_curr_event_idx], 1.0, 0.1, 1.0 );
				self thread waitForFaceEventComplete();
			}
		}
		
		if( IsDefined( self.face_curr_event ) )
		{
			state = self waitForAnyPriorityReturn( self.face_curr_event );
		}
		else
		{
			state = self waitForAnyPriorityReturn( self.face_curr_base );
		}
	}
}

showState( state )
{
	self endon( "entityshutdown" );
	level endon( "save_restore" );
	
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
		
		wait( 0.01667 );
	}
}

setFaceState( state )
{
	if( state == "face_advance" )
	{
		if( IsDefined( self.face_curr_event ) )
		{
			self.face_state = self.face_curr_event;
		}
		else if( IsDefined( self.face_curr_base ) )
		{
			self.face_state = self.face_curr_base;
		}
		return;
	}
	self.face_state = state;
}

watchfor_death()
{
	self endon( "entityshutdown" );
	level endon( "save_restore" );
	
	if ( !isdefined( self.face_death ) )
	{
		self waittillmatch( "face", "face_death" );
		self.face_death = true;
	}
}

