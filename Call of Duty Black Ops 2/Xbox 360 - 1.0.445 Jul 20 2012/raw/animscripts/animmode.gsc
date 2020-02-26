main()
{
	self endon( "death" );
	self endon( "stop_animmode" );
	self notify( "killanimscript" );

	self._tag_entity endon( self._scene );

	thread notify_on_end( self._scene );
	anime = self._scene;

	origin = GetStartOrigin( self._tag_entity.origin, self._tag_entity.angles, level.scr_anim[ self._animname ][ self._scene ] );
	angles = GetStartAngles( self._tag_entity.origin, self._tag_entity.angles, level.scr_anim[ self._animname ][ self._scene ] );

	origin = PhysicsTrace( origin + (0,0,2 ), origin + (0,0,-60) );
		
	self Teleport( origin, angles );
	
	self.pushable = 0;

	self AnimMode( self._animmode );
    self ClearAnim( self.root_anim, 0.3 );
//	self SetAnim( %body, 1, 0 );	// The %body node should always have weight 1.
	self OrientMode( "face angle", angles[ 1 ] );

	anim_string = "custom_animmode";
	self SetFlaggedAnimRestart( anim_string, level.scr_anim[ self._animname ][ self._scene ], 1, 0.2, 1 );
	self._tag_entity thread maps\_anim::notetrack_wait( self, anim_string, self._scene, self._animname );
	self._tag_entity thread maps\_anim::animscriptDoNoteTracksThread( self, anim_string/*, self._scene*/ );

	//thread maps\_debug::drawArrowForever( self._tag_entity.origin, self._tag_entity.angles );

	self._tag_entity = undefined;
	anime = self._scene;
	self._scene = undefined;
	self._animmode = undefined;
	
	self endon( "killanimscript" );
	self waittillmatch( anim_string, "end" );
	self notify( "finished_custom_animmode" + anime );
}

notify_on_end( msg )
{
	self endon( "death" );
	self endon( "finished_custom_animmode" + msg );

	self waittill( "killanimscript" );

	self notify( "finished_custom_animmode" + msg );
}