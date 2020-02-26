main()
{
	self endon( "death" );
	self endon( "stop_first_frame" );
	self notify( "killanimscript" );

	self OrientMode( "face angle", self.angles[ 1 ] );

	self setanim( level.scr_anim[ self.animname ][ self.first_frame_anim ], 1, 0, 0 );
	self.first_frame_anim = undefined;
	
	self waittill( "killanimscript" );
}