#using_animtree( "generic_human" );

// (Note that animations called left are used with right corner nodes, and vice versa.)

main()
{
	self.animArrayFuncs = [];
	self.animArrayFuncs[ "hiding" ][ "stand" ] = ::SetAnims_CoverLeft_Stand;
	self.animArrayFuncs[ "hiding" ][ "crouch" ] = ::SetAnims_CoverLeft_Stand;

	self endon( "killanimscript" );
    animscripts\utility::initialize( "cover_swim_left" );

	// it's possible the guy was idling near the node, then decided to use it without needing to move there,
	// thus bypassing our regular flow of control.  make sure the necessary variables are set.
	if ( self.approachType != "cover_corner_l" )
		self.approachType = "cover_corner_l";

	assertex( IsDefined( self.approachType ) && self.approachType == "cover_corner_l", self.approachType + " should be cover_corner_l" );

	angles = anim.archetypes["soldier"]["swim"][ "arrival_cover_corner_l_angleDelta" ][ 4 ][ 4 ];
	animscripts\corner::corner_think( "left", angles[1] );
}

end_script()
{
	animscripts\corner::end_script_corner();
	animscripts\cover_behavior::end_script( "left" );
}

SetAnims_CoverLeft_Stand()
{
	self.a.array = animscripts\swim::GetSwimAnim( "cover_corner_l" );
	angles = anim.archetypes["soldier"]["swim"][ "arrival_cover_corner_l_angleDelta" ][ 4 ][ 4 ];
	self.hideYawOffset = angles[1];
}
