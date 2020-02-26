#using_animtree( "generic_human" );
main()
{
	self endon( "death" );
	self endon( "stop_animmode" );
	self notify( "killanimscript" );
	self._tag_entity endon( self._anime );

	thread notify_on_end( self._anime );
	anime = self._anime;

	self.pushable = 0;

	self animMode( self._animmode );
    self clearAnim( %root, 0.3 );
//	self setAnim( %body, 1, 0 );	// The %body node should always have weight 1.
	self OrientMode( "face angle", self._tag_entity.angles[ 1 ] );

	anim_string = "custom_animmode";
	self setflaggedanimrestart( anim_string, level.scr_anim[ self._animname ][ self._custom_anim ], 1, 0.2, 1 );
	self._tag_entity thread maps\_anim::start_notetrack_wait( self, anim_string, self._anime, self._animname );
	self._tag_entity thread maps\_anim::animscriptDoNoteTracksThread( self, anim_string, self._anime );

	self._custom_anim = undefined;
	self._tag_entity = undefined;
	anime = self._anime;
	self._anime = undefined;
	self._animmode = undefined;
	
	
	self endon( "killanimscript" );
	self waittillmatch( anim_string, "end" );
	self notify( "finished_custom_animmode" + anime );
}

notify_on_end( msg )
{
	self endon( "death" );

	self waittill( "killanimscript" );

	self notify( "finished_custom_animmode" + msg );
}