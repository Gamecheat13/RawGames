#include animscripts\Utility;
#include animscripts\anims;
#using_animtree ("generic_human");

main ( )
{
    self trackScriptState( "GrenadeCower Main", "code" );
	self endon("killanimscript");
	animscripts\utility::initialize("grenadecower");

	self maps\_dds::dds_notify( "react_grenade", ( self.team == "allies" ) );

	if ( self.a.pose == "prone" )
	{
		animscripts\stop::main();
		return;	// Should never get to here
	}
	
	self AnimMode( "zonly_physics" );
	self OrientMode( "face angle", self.angles[1] );

	grenadeAngle = 0;

	assert( IsDefined( self.grenade ) );
	
	if ( IsDefined( self.grenade ) ) // failsafe
		grenadeAngle = AngleClamp180( VectorToAngles( self.grenade.origin - self.origin )[1] - self.angles[1] );
	else
		grenadeAngle = self.angles[1];
	
	if ( self.a.pose == "stand" )
	{
		if( IsDefined( self.grenade ) && TryDive( grenadeAngle ) )
			return;
		
		self SetFlaggedAnimKnobAllRestart( "cowerstart", animArray("cower_start"), %body, 1, 0.2 );		
		self animscripts\shared::DoNoteTracks( "cowerstart" );
	}
	
	self.a.pose 	= "crouch";
	self.a.movement = "stop";
	
	self SetFlaggedAnimKnobAllRestart( "cower", animArray("cower_idle"), %body, 1, 0.2 );	
	self animscripts\shared::DoNoteTracks( "cower" );

	self waittill( "never" );
}

TryDive( grenadeAngle )
{
	diveAnim = undefined;
	if ( abs( grenadeAngle ) > 90 ) 			// grenade behind us
		diveAnim = animArray("dive_forward");
	else										// grenade in front of us
		diveAnim = animArray("dive_backward");
			
	// when the dives are split into a dive, idle, and get up,
	// maybe we can get a better point to do the moveto check with
	moveBy = getMoveDelta( diveAnim, 0, 0.5 );
	diveToPos = self localToWorldCoords( moveBy );
	
	if ( !self MayMoveToPoint( diveToPos ) )
		return false;

	self setFlaggedAnimKnobAllRestart( "cowerstart", diveAnim, %body, 1, 0.2 );
	self animscripts\shared::DoNoteTracks( "cowerstart" );

	return true;
}

//--------------------------------------------------------------------------------
// end script
//--------------------------------------------------------------------------------

end_script()
{
	
}
