#include clientscripts\mp\_utility;

// creates a list of wait and speed times to ensure that they are the same for multiple split-screen players
init()
{
	level.fxanim_max_anims = 128;
	
	level.scr_anim = [];
	level.scr_anim[ "fxanim_props" ] = [];

/*
	level.fxanim_waits = [];
	level.fxanim_speeds = [];

	for ( i = 0; i < level.fxanim_max_anims; i++ )
	{
		level.fxanim_waits[ i ] = RandomFloatRange( 0.1, 1.5 );
		level.fxanim_speeds[ i ] = RandomFloatRange( 0.75, 1.4 );
	}
*/
}

fxanim_init( localClientNum )
{
	mapname = GetDvar( "mapname" );

	switch( mapname )
	{
		case "mp_array":	
		case "mp_mountain":
		case "mp_cracked":
		case "mp_nuked":
			return;
	}

	a_fxanims = GetEntArray( localClientNum, "fxanim", "targetname" );
	assert( a_fxanims.size <= level.fxanim_max_anims );

	for ( i = 0; i < a_fxanims.size; i++ )
	{
		if ( IsDefined( a_fxanims[i].fxanim_parent ) )
		{
			parent = GetEnt( localClientNum, a_fxanims[i].fxanim_parent, "targetname" );
			a_fxanims[ a_fxanims.size ] = parent;
			
			a_fxanims[i] thread _fxanim_model_link( localClientNum );
		}
		else
		{
			a_fxanims[i] thread fxanim_think( localClientNum );
		}
	}

	if ( IsDefined( level.fx_anim_level_init ) )
	{
		level thread [[level.fx_anim_level_init]]( localClientNum );
	}
}

// ----------------------------------------------------------------------------------------------------
// ---- KVP-Based FXANIM System ----
// ----------------------------------------------------------------------------------------------------
#using_animtree("fxanim_props");

fxanim_think( localClientNum, random_wait, random_speed )	
{	
	self waittill_dobj( localClientNum );

	self thread _fxanim_hide();
	self _fxanim_wait();		// if defined, wait until the animation is told to start
	
	self UseAnimTree( #animtree );	
	
	n_anim_count = self _fxanim_get_anim_count();
	
	self notify( "fxanim_start" );
	
	for ( n_current_anim = 0; n_current_anim < n_anim_count; n_current_anim++ )
	{
		str_scene = self _fxanim_get_scene_name( n_current_anim );
		
		if( !self _fxanim_modifier( str_scene ) )	// check if the scene is actually a modifier (hide/delete/etc)
		{
			self _fxanim_animate( str_scene );
			self _fxanim_play_fx( localClientNum );
		}
		
		self _fxanim_change_anim( n_current_anim );
	}
}



// ----------------------------------------------------------------------------------------------------
// FXANIM Hiding/Showing
// ----------------------------------------------------------------------------------------------------

// If fxanim_hide is set, hide the model until the animation begins
// self = model the fxanim will be played on
_fxanim_hide()
{
	if ( IsDefined( self.fxanim_hide ) && self.fxanim_hide )
	{
		self Hide();
		self waittill( "fxanim_start" );
		self Show();
	}	
}



// Instead of defining a scene to play, the fxanim model can be modified (deleted, hidden, etc).  
// Check the scene to see if a modifier is specified instead of a scene
_fxanim_modifier( str_scene )
{
	switch ( str_scene )
	{
		case "delete":		
			self Delete();
			break;
		case "hide":
			self Hide();
			break;
		default:
			return false;
			break;
	}
	
	return true;
}


// ----------------------------------------------------------------------------------------------------
// FXANIM Wait Functions
// ----------------------------------------------------------------------------------------------------

// Delay playing the animation based on the set kvps.
// self = model the fxanim will be played on
_fxanim_wait()
{
	// wait for level notify first
	if ( IsDefined( self.fxanim_waittill_1 ) )
	{
		if ( IsDefined( self.fxanim_waittill_1 ) )
		{
			_fxanim_change_anim( -1 );
		}
	}	
	
	// use wait timers last (wait, wait_min/wait_max)
	if ( IsDefined( self.fxanim_wait ) )
	{
		wait self.fxanim_wait;
	}
	else if ( IsDefined( self.fxanim_wait_min ) && IsDefined( self.fxanim_wait_max ) )
	{
		n_wait_time = RandomFloatRange( self.fxanim_wait_min, self.fxanim_wait_max );
		wait n_wait_time;
	}
}



// blocking function that waits for various input before playing the next animation
// self = model the fxanim will be played on
_fxanim_change_anim( n_fxanim_id )			// fxanim_change_on( str_change_on, is_loop )
{
	str_waittill = undefined;
	
	if( n_fxanim_id == -1 && IsDefined( self.fxanim_waittill_1 ) )	// -1, no anim (fxanim_waittill_1 waits before the first anim plays)
	{
		str_waittill = self.fxanim_waittill_1;	
	}	
	else if ( n_fxanim_id == 0 && IsDefined( self.fxanim_waittill_2 ) )
	{
		str_waittill = self.fxanim_waittill_2;	
	}
	else if( n_fxanim_id == 1 && IsDefined( self.fxanim_waittill_3 ) )
	{
		str_waittill = self.fxanim_waittill_3;	
	}
	
	if( !IsDefined( str_waittill ) && n_fxanim_id != -1 )
	{
		self _fxanim_wait_for_anim_to_end( n_fxanim_id );
	}
	else 
	{	
		a_changer = StrTok( str_waittill, "_" );
		level waittill( str_waittill );	
	}
}



// Wait for the current anim to end
// self is the model animating 
_fxanim_wait_for_anim_to_end( n_fxanim_id )
{
	str_scene = _fxanim_get_scene_name( n_fxanim_id );
	
	if( IsSubStr( str_scene, "_loop" ) )
	{
		self waittillmatch( "looping anim", "end" );
	}
	else 
	{
		self waittillmatch( "single anim", "end" );
	}	
}


// ----------------------------------------------------------------------------------------------------
// FXANIM Anim Functions
// ----------------------------------------------------------------------------------------------------

// Animate the fxanim model
// self = model the fxanim will be played on
_fxanim_animate( str_scene )
{
	if ( !IsDefined( level.scr_anim[ "fxanim_props" ][ str_scene ] ) )
	{
		/#
		if ( IsDefined( str_scene ) )
		{
			println( "Error: fxanim entity at " + self.origin + " is missing animation: " + str_scene );	
		}
		else
		{
			println( "Error: fxanim entity at " + self.origin + " is missing animation" );	
		}
		#/
		return;
	}

	// Animate
	self AnimScripted( level.scr_anim[ "fxanim_props" ][ str_scene ], 1.0, 0.0, 1.0 );
}
	
	

// ----------------------------------------------------------------------------------------------------
// FXANIM Utility Functions
// ----------------------------------------------------------------------------------------------------

_fxanim_play_fx( localClientNum )
{
	if( IsDefined( self.fxanim_fx_1 ) )
	{
		Assert( IsDefined( self.fxanim_fx_1_tag ), "KVP fxanim_fx_1_tag must be set on fxanim at " + self.origin );
		PlayFXOnTag( localClientNum, GetFX( self.fxanim_fx_1 ), self, self.fxanim_fx_1_tag );
	}
	
	if( IsDefined( self.fxanim_fx_2 ) )
	{
		Assert( IsDefined( self.fxanim_fx_2_tag ), "KVP fxanim_fx_2_tag must be set on fxanim at " + self.origin );
		PlayFXOnTag( localClientNum, GetFX( self.fxanim_fx_2 ), self, self.fxanim_fx_2_tag );
	}
	
	if( IsDefined( self.fxanim_fx_3 ) )
	{
		Assert( IsDefined( self.fxanim_fx_3_tag ), "KVP fxanim_fx_3_tag must be set on fxanim at " + self.origin );
		PlayFXOnTag( localClientNum, GetFX( self.fxanim_fx_3 ), self, self.fxanim_fx_3_tag );
	}
	
	if( IsDefined( self.fxanim_fx_4 ) )
	{
		Assert( IsDefined( self.fxanim_fx_4_tag ), "KVP fxanim_fx_4_tag must be set on fxanim at " + self.origin );
		PlayFXOnTag( localClientNum, GetFX( self.fxanim_fx_4 ), self, self.fxanim_fx_4_tag );
	}
	
	if( IsDefined( self.fxanim_fx_5 ) )
	{
		Assert( IsDefined( self.fxanim_fx_5_tag ), "KVP fxanim_fx_5_tag must be set on fxanim at " + self.origin );
		PlayFXOnTag( localClientNum, GetFX( self.fxanim_fx_5 ), self, self.fxanim_fx_5_tag );
	}	
}



// ----------------------------------------------------------------------------------------------------
// FXANIM Utility Functions
// ----------------------------------------------------------------------------------------------------

// Count the number of anims assigned to this model and returns the number
// self = model the fxanim will be played on
_fxanim_get_anim_count()
{
	Assert( IsDefined( self.fxanim_scene_1 ), "fxanim at position " + self.origin + " needs at least one scene defined.  Use the KVP fxanim_scene_1" );
	
	n_fx_count = 0;
	if ( !IsDefined( self.fxanim_scene_2 ) )
	{
		n_fx_count = 1;	
	}
	else if ( !IsDefined( self.fxanim_scene_3 ) )
	{
		n_fx_count = 2;
	}
	else
	{
		n_fx_count = 3;	
	}
	
	return n_fx_count;
}



_fxanim_get_scene_name( n_anim_id )
{
	str_scene_name = undefined;
	
	switch ( n_anim_id )
	{
		case 0:
			str_scene_name = self.fxanim_scene_1;
			break;
		case 1:
			str_scene_name = self.fxanim_scene_2;
			break;
		case 2:
			str_scene_name = self.fxanim_scene_3;
			break;
	}
	
	return str_scene_name;
}


// ----------------------------------------------------------------------------------------------------
// FXANIM Model Link Functions
// ----------------------------------------------------------------------------------------------------
_fxanim_model_link( localClientNum )
{
	Assert( IsDefined( self.fxanim_tag ), "Model at origin " + self.origin + " needs an fxanim_tag defined, to show which tag the model will link to" );
	
	m_parent = GetEnt( localClientNum, self.fxanim_parent, "targetname" );
	
	Assert( IsDefined( m_parent ), "Model at origin " + self.origin + " does not have a proper parent.  Make sure the fxanim_parent matches the targetname of the fxanim" );
	
	m_parent waittill_dobj( localClientNum );
	
	self.origin = m_parent GetTagOrigin( self.fxanim_tag );
	self.angles = m_parent GetTagAngles( self.fxanim_tag );		
	
	self LinkTo( m_parent, self.fxanim_tag );
	
	if ( IsDefined( self.fxanim_hide ) )
	{
		self Hide();
		
		m_parent waittill( "fxanim_start" );
		self Show();
	}
}

getfx( fx )
{
	assert( IsDefined( level._effect[ fx ] ), "Fx " + fx + " is not defined in level._effect." );
	return level._effect[ fx ];
}