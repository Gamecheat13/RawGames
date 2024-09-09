//
// Scripted agent common functions.
//

// called from code when animation state changes.
OnEnterState( prevState, nextState )
{
	if ( IsDefined( self.OnEnterAnimState ) )
		self [[ self.OnEnterAnimState ]]( prevState, nextState );
}

// called from code when the agent is freed.
OnDeactivate()
{
	self notify( "killanimscript" );
}


// util function
PlayAnimUntilNotetrack( animState, animLabel, notetrack )
{
	PlayAnimNUntilNotetrack( animState, 0, animLabel, notetrack );
}

PlayAnimNUntilNotetrack( animState, animIndex, animLabel, notetrack )
{
	self SetAnimState( animState, animIndex );

	if ( !IsDefined( notetrack ) )
		notetrack = "end";

	WaitUntilNotetrack( animLabel, notetrack );
}

PlayAnimNAtRateUntilNotetrack( animState, animIndex, animRate, animLabel, notetrack )
{
	self SetAnimState( animState, animIndex, animRate );

	if ( !IsDefined( notetrack ) )
		notetrack = "end";

	WaitUntilNotetrack( animLabel, notetrack );
}

WaitUntilNotetrack( animLabel, notetrack )
{
	while ( true )
	{
		self waittill( animLabel, note );
		if ( note == notetrack || note == "end" || note == "anim_will_finish" || note == "finish" )
			break;
	}
}

PlayAnimForTime( animState, time )
{
	PlayAnimNForTime( animState, 0, time );
}

PlayAnimNForTime( animState, animIndex, time )
{
	self SetAnimState( animState, animIndex );
	wait( time );
}

PlayAnimNAtRateForTime( animState, animIndex, animRate, time )
{
	self SetAnimState( animState, animIndex, animRate );
	wait( time );
}