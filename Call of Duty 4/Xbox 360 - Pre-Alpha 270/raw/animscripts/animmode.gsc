#using_animtree( "generic_human" );
main()
{
	self endon( "death" );
	self notify( "killanimscript" );
	self._tag_entity endon( self._anime );

	self.pushable = 0;

	self animMode( self._animmode );
    self clearAnim( %root, 0.3 );
//	self setAnim( %body, 1, 0 );	// The %body node should always have weight 1.
	self OrientMode( "face angle", self._tag_entity.angles[ 1 ] );

	anim_string = "custom_animmode";
	self setflaggedanim( anim_string, level.scr_anim[ self.animname ][ self._custom_anim ], 1, 0.2, 1 );
	self._tag_entity thread maps\_anim::start_notetrack_wait( self, anim_string, self._anime );
	self._tag_entity thread maps\_anim::animscriptDoNoteTracksThread( self, anim_string, self._anime );

	self._custom_anim = undefined;
	self._tag_entity = undefined;
	self._anime = undefined;
	self._animmode = undefined;
	
	self endon( "killanimscript" );
	self waittillmatch( anim_string, "end" );
}