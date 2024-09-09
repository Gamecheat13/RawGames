#include animscripts\Utility;
#include animscripts\SetPoseMovement;
#include animscripts\Combat_utility;
#include maps\_anim;
#include maps\_utility;
#include common_scripts\utility;
#using_animtree( "generic_human" );

init_animset_flashed()
{
	// Flashed
	animset = [];
	animset["flashed"] = [ %exposed_flashbang_v1, %exposed_flashbang_v2, %exposed_flashbang_v3, %exposed_flashbang_v4, %exposed_flashbang_v5 ];
	animset["flashed"] = array_randomize( animset["flashed"] );

	assert( !isdefined( anim.archetypes["soldier"]["flashed"] ) );
	anim.archetypes[ "soldier" ]["flashed"] = animset;

	anim.flashAnimIndex["soldier"] = 0;
}

getNextFlashAnim()
{
	archetype = "soldier";
	
	assert( isDefined( anim.flashAnimIndex ) );
	if ( isDefined( self.animArchetype ) && isDefined( anim.flashAnimIndex[ self.animArchetype ] ) )
	{
		archetype = self.animArchetype;
	}

	anim.flashAnimIndex[ archetype ]++;
	
	if ( anim.flashAnimIndex[ archetype ] >= anim.archetypes[archetype]["flashed"]["flashed"].size )
	{
		anim.flashAnimIndex[ archetype ] = 0;
		anim.archetypes[archetype]["flashed"]["flashed"] = array_randomize( anim.archetypes[archetype]["flashed"]["flashed"] );
	}
	return anim.archetypes[archetype]["flashed"]["flashed"][ anim.flashAnimIndex[ archetype ] ];
}

flashBangAnim( animation )
{
	self endon( "killanimscript" );
	self setflaggedanimknoball( "flashed_anim", animation, %body, 0.2, randomFloatRange( 0.9, 1.1 ) );
	self animscripts\shared::DoNoteTracks( "flashed_anim" );
}

main()
{
	self endon( "death" );
	self endon( "killanimscript" );
	
	animscripts\utility::initialize( "flashed" );
	
	flashDuration = self flashBangGetTimeLeftSec();
	if ( flashDuration <= 0 )
		return;

	self animscripts\face::SayGenericDialogue( "flashbang" );

	if ( isdefined( self.specialFlashedFunc ) )
	{
		self [[ self.specialFlashedFunc ]]();
		return;
	}

	animation = getNextFlashAnim();
	flashBangedLoop( animation, flashDuration );
}

flashBangedLoop( animation, duration )
{
	self endon( "death" );
	self endon( "killanimscript" );
	
	assert( isDefined( animation ) );
	assert( isDefined( duration ) );
	assert( duration > 0 );

	if ( self.a.pose == "prone" )
		self ExitProneWrapper( 1 );

	self.a.pose = "stand";
	self.allowdeath = true;

	self thread flashBangAnim( animation );
	wait ( duration );

	self notify( "stop_flashbang_effect" );
	self.flashed = false;
}