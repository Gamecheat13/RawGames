#include animscripts\Utility;
#using_animtree( "generic_human" );

// Grenade_return_throw
// Picks up a grenade from 32 units in front of the character, and throws it.

main()
{
	/#
	if ( getdvar( "scr_forcegrenadecower" ) == "on" && isdefined( self.grenade ) )
	{
		self OrientMode( "face angle", randomfloat( 360 ) );
		self animmode( "gravity" );
		wait .2;
		animscripts\grenade_cower::main();
		return;
	}
	#/

	self orientMode( "face default" );
	self endon( "killanimscript" );

	animscripts\utility::initialize( "grenade_return_throw" );

	self animMode( "zonly_physics" );// Unlatch the feet

	throwAnim = undefined;

	throwDist = 1000;
	if ( isdefined( self.enemy ) )
		throwDist = distance( self.origin, self.enemy.origin );

	// unused: grenade_return_running_kick_forward_1; kicks don't read well to player
	// unused: grenade_return_running_kick_forward_2
	// unused: %grenade_return_standing_throw_forward_2; similar to other ones

	animArray = [];
	if ( throwDist < 600 && isLowThrowSafe() )
	{
		if ( throwDist < 300 )
		{
			// really short range
			animArray[ 0 ] = %grenade_return_running_throw_forward;
			animArray[ 1 ] = %grenade_return_standing_throw_forward_1;
		}
		else
		{
			// long range
			animArray[ 0 ] = %grenade_return_running_throw_forward;
			animArray[ 1 ] = %grenade_return_standing_throw_overhand_forward;
		}
	}

	if ( animArray.size == 0 )
	{
		// really long range or can't do low throw
		animArray[ 0 ] = %grenade_return_standing_throw_overhand_forward;
	}

	assert( animArray.size );
	throwAnim = animArray[ randomint( animArray.size ) ];

	 /#
	if ( getdvar( "scr_grenadereturnanim" ) != "" )
	{
		val = getdvar( "scr_grenadereturnanim" );
		//if ( val == "kick1")
		//	throwAnim = %grenade_return_running_kick_forward_1;
		//else if ( val == "kick2")
		//	throwAnim = %grenade_return_running_kick_forward_2;
		//else
		if ( val == "throw1" )
			throwAnim = %grenade_return_running_throw_forward;
		else if ( val == "throw2" )
			throwAnim = %grenade_return_standing_throw_forward_1;
		//else if ( val == "throw3")
		//	throwAnim = %grenade_return_standing_throw_forward_2;
		else if ( val == "throw4" )
			throwAnim = %grenade_return_standing_throw_overhand_forward;
	}
	#/

	assert( isdefined( throwAnim ) );
	self setFlaggedAnimKnoballRestart( "throwanim", throwAnim, %body, 1, .3 );

	hasPickup = ( animHasNotetrack( throwAnim, "grenade_left" ) || animHasNotetrack( throwAnim, "grenade_right" ) );
	if ( hasPickup )
	{
		self animscripts\shared::placeWeaponOn( self.weapon, "left" );
		self thread putWeaponBackInRightHand();

		self thread notifyGrenadePickup( "throwanim", "grenade_left" );
		self thread notifyGrenadePickup( "throwanim", "grenade_right" );
		self waittill( "grenade_pickup" );
		self pickUpGrenade();

		self animscripts\battleChatter_ai::evaluateAttackEvent( "grenade" );

		self waittillmatch( "throwanim", "grenade_throw" );
	}
	else
	{
		// kick animations don't have pickup.
		self waittillmatch( "throwanim", "grenade_throw" );
		self pickUpGrenade();
		
		self animscripts\battleChatter_ai::evaluateAttackEvent( "grenade" );
	}
	
	if ( isDefined( self.grenade ) ) // it may have exploded and we may have magic bullet shield
		self throwGrenade();
	
	// TODO: replace with a notetrack?
	wait 1;

	if ( hasPickup )
	{
		self notify( "put_weapon_back_in_right_hand" );
		self animscripts\shared::placeWeaponOn( self.weapon, "right" );
	}
}

isLowThrowSafe()
{
	start = ( self.origin[ 0 ], self.origin[ 1 ], self.origin[ 2 ] + 20 );
	end = start + anglesToForward( self.angles ) * 50;

	return sightTracePassed( start, end, false, undefined );
}

putWeaponBackInRightHand()
{
	self endon( "death" );
	self endon( "put_weapon_back_in_right_hand" );

	self waittill( "killanimscript" );

	self animscripts\shared::placeWeaponOn( self.weapon, "right" );
}

notifyGrenadePickup( animFlag, notetrack )
{
	self endon( "killanimscript" );
	self endon( "grenade_pickup" );

	self waittillmatch( animFlag, notetrack );
	self notify( "grenade_pickup" );
}
