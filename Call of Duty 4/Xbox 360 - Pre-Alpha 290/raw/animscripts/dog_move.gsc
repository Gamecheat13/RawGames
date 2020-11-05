#include maps\_utility;
#include animscripts\utility;

#using_animtree( "dog" );

main()
{
	self endon( "killanimscript" );
	// self endon( "movemode" );
	
	self clearanim( %root, 0.1 );
	self clearanim( %german_shepherd_run_stop, 0 );
	
	self thread randomSoundDuringRunLoop();

	if ( !isdefined( self.traverseComplete ) )
	{	
		// self OrientMode( "face current" );
		// self animMode( "gravity" );
		
		weights = self getRunStartAnimWeights();
		
		self setanimrestart( %german_shepherd_run_start, weights[ "center" ], 0.2, 1 );
		self setanimrestart( %german_shepherd_run_start_L, weights[ "left" ], 0.2, 1 );
		self setanimrestart( %german_shepherd_run_start_R, weights[ "right" ], 0.2, 1 );

		self setflaggedanimknobrestart( "dog_prerun", %german_shepherd_run_start_knob, 1, 0.2, self.moveplaybackrate );
		
		self animscripts\shared::DoNoteTracks( "dog_prerun" );
		
		// self animMode( "none" );
		// self OrientMode( "face motion" );
	}

	self.traverseComplete = undefined;

	self clearanim( %german_shepherd_run_start, 0 );

	weights = undefined;
	weights = self getRunAnimWeights();
	
	self setanimrestart( %german_shepherd_run, weights[ "center" ], 0, 1 );
	self setanimrestart( %german_shepherd_run_lean_L, weights[ "left" ], 0.1, 1 );
	self setanimrestart( %german_shepherd_run_lean_R, weights[ "right" ], 0.1, 1 );
	self setflaggedanimknob( "dog_run", %german_shepherd_run_knob, 1, 0, self.moveplaybackrate );
	animscripts\shared::DoNoteTracksForTime( 0.1, "dog_run" );
	
	
	while ( 1 )
	{	
		self moveLoop();
		
		if ( self.disableArrivals == false )
			self thread stopMove();

		// if a "run" notify is received while stopping, clear stop anim and go back to moveLoop
		self waittill( "run" );
		self clearanim( %german_shepherd_run_stop, 0.1 );
	}
}


moveLoop()
{
	self endon( "killanimscript" );
	self endon( "stop_soon" );

	while ( 1 )
	{
		if ( self.disableArrivals )
			self.stopAnimDistSq = 0;
		else
			self.stopAnimDistSq = anim.dogStoppingDistSq;

		weights = self getRunAnimWeights();

		self setanim( %german_shepherd_run, weights[ "center" ], 0.2, 1 );
		self setanim( %german_shepherd_run_lean_L, weights[ "left" ], 0.2, 1 );
		self setanim( %german_shepherd_run_lean_R, weights[ "right" ], 0.2, 1 );
		
		animscripts\shared::DoNoteTracksForTime( 0.2, "dog_run" );
	}
}

stopMove()
{
	self endon( "killanimscript" );
	self endon( "run" );

	self clearanim( %german_shepherd_run_knob, 0.1 );
	self setflaggedanimrestart( "stop_anim", %german_shepherd_run_stop, 1, 0.2, 1 );
	self animscripts\shared::DoNoteTracks( "stop_anim" );
}


randomSoundDuringRunLoop()
{
	self endon( "killanimscript" );
	while ( 1 )
	{
/#		
		if ( getdebugdvar( "debug_dog_sound" ) != "" )
			iprintln( "dog " + (self getentnum()) + " bark start " + getTime() );
#/
		if ( isdefined( self.script_growl ) )
			self play_sound_on_tag( "anml_dog_growl", "tag_eye" );
		else
			self play_sound_on_tag( "anml_dog_bark", "tag_eye" );
			
/#		
		if ( getdebugdvar( "debug_dog_sound" ) != "" )
			iprintln( "dog " + (self getentnum()) + " bark end " + getTime() );
#/
			
		wait( randomfloatrange( 0.1, 0.3 ) );
	}
}

getRunStartAnimWeights()
{
	weights = [];
	
	weights[ "center" ] = 1;
	weights[ "left" ]   = 0;
	weights[ "right" ]  = 0;
	
	 /* 
	angle = AngleClamp180( self.lookaheaddir[ 1 ] - self.angles[ 1 ] );

	if ( angle < 0 )
	{
		weights[ "left" ]   = angle / - 90;
		weights[ "right" ]  = 0;

		if ( weights[ "left" ] > 1 )
			weights[ "left" ] = 1;
		if ( weights[ "left" ] < 0 )
			weights[ "left" ] = 0;

		weights[ "center" ] = 1 - weights[ "left" ];
	}
	else if ( angle == 0 )
	{
		weights[ "center" ] = 1;
		weights[ "left" ]   = 0;
		weights[ "right" ]  = 0;
	}
	else
	{
		weights[ "left" ]   = 0;
		weights[ "right" ]  = angle / 90;
		
		if ( weights[ "right" ] > 1 )
			weights[ "right" ] = 1;	
		else if ( weights[ "right" ] < 0 )
			weights[ "right" ] = 0;			

		weights[ "center" ] = 1 - weights[ "right" ];
	}
	 */ 

	
	return weights;
}


getRunAnimWeights()
{
	weights = [];
	weights[ "center" ] = 0;
	weights[ "left" ] = 0;
	weights[ "right" ] = 0;
	
	if ( self.leanAmount > 0 )
	{
		if ( self.leanAmount < 0.95 )
			self.leanAmount	 = 0.95;

		weights[ "left" ] = 0;
		weights[ "right" ] = ( 1 - self.leanAmount ) * 20;

		if ( weights[ "right" ] > 1 )
			weights[ "right" ] = 1;	
		else if ( weights[ "right" ] < 0 )
			weights[ "right" ] = 0;	
			
		weights[ "center" ] = 1 - weights[ "right" ];
	}
	else if ( self.leanAmount < 0 )
	{
		if ( self.leanAmount > - 0.95 )
			self.leanAmount	 = -0.95;

		weights[ "right" ] = 0;
		weights[ "left" ] = ( 1 + self.leanAmount ) * 20;

		if ( weights[ "left" ] > 1 )
			weights[ "left" ] = 1;
		if ( weights[ "left" ] < 0 )
			weights[ "left" ] = 0;		

		weights[ "center" ] = 1 - weights[ "left" ];
	}
	else
	{
		weights[ "left" ] = 0;
		weights[ "right" ] = 0;
		weights[ "center" ] = 1;		
	}
	
	return weights;
}