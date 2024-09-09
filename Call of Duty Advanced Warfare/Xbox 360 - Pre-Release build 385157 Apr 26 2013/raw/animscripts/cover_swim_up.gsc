#using_animtree( "generic_human" );

main()
{
	self.animArrayFuncs = [];
	self.animArrayFuncs[ "hiding" ][ "stand" ] = ::SetAnims_CoverUp_Stand;
	self.animArrayFuncs[ "hiding" ][ "crouch" ] = ::SetAnims_CoverUp_Stand;

	self endon( "killanimscript" );
    animscripts\utility::initialize( "cover_swim_up" );

	// it's possible the guy was idling near the node, then decided to use it without needing to move there,
	// thus bypassing our regular flow of control.  make sure the necessary variables are set.
	if ( self.approachType != "cover_u" )
		self.approachType = "cover_u";

	assertex( IsDefined( self.approachType ) && self.approachType == "cover_u", self.approachType + " should be cover_u" );

	animscripts\corner::corner_think( "up", 0 );
}

end_script()
{
	animscripts\corner::end_script_corner();
	animscripts\cover_behavior::end_script( "up" );
}

SetAnims_CoverUp_Stand()
{
	self.a.array = animscripts\swim::GetSwimAnim( "cover_u" );
	self.hideYawOffset = 0;
}
