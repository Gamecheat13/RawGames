#include animscripts\anims;
#include maps\_utility;

#define STUNNED_TIME 2

#using_animtree ("bigdog");

main()
{
	self endon("killanimscript");

	animscripts\bigdog\bigdog_utility::initialize("pain");

	pain();
}

end_script()
{
}

pain()
{
	self OrientMode( "face current" );
	self AnimMode( "zonly_physics" );

	painAnim = undefined;

	// explosive is special cause it has a stun state
	if( animscripts\pain::isExplosiveDamageMOD( self.damagemod ) )
	{
		doExplosivePain();
		return;
	}
	
	// plain anim pains
	if( self.damageLeg != "" )
	{
		painAnim = getLegPainAnim();
	}
	else
	{
		painAnim = getBodyPainAnim();
	}

	assert( IsDefined(painAnim) );

	if( IsDefined(painAnim) )
	{
		self SetFlaggedAnimRestart( "painAnim", painAnim, 1, 0.2, 0.75 );
		self animscripts\shared::DoNoteTracks( "painAnim" );
	}
}

getBodyPainAnim()
{
	painAnim = undefined;

	if( self.damageyaw > 135 || self.damageyaw <= -135 ) // Front quadrant
	{
		painAnim = animArray("body_pain_f");
	}
	else if( self.damageyaw > 45 && self.damageyaw < 135 ) // Right quadrant
	{
		painAnim = animArray("body_pain_r");
	}
	else if( self.damageyaw > -135 && self.damageyaw < -45 ) // Left quadrant
	{
		painAnim = animArray("body_pain_l");
	}
	else // Back quadrant
	{
		painAnim = animArray("body_pain_b");
	}

	return painAnim;
}

getLegPainAnim()
{
	painAnim = undefined;

	if( self.damageLeg == "FL" )
	{
		painAnim = animArray("leg_pain_fl");
	}
	else if( self.damageLeg == "FR" )
	{
		painAnim = animArray("leg_pain_fr");
	}
	else if( self.damageLeg == "RL" )
	{
		painAnim = animArray("leg_pain_rl");
	}
	else
	{
		painAnim = animArray("leg_pain_rr");
	}

	return painAnim;
}

getStumblePainAnim()
{
	painAnim = undefined;
	animSuffix = animscripts\bigdog\bigdog_utility::animSuffix();

	if( self.damageyaw > 135 || self.damageyaw <= -135 ) // Front quadrant
	{
		painAnim = animArray( "stun_recover_b" + animSuffix );
	}
	else if( self.damageyaw > 45 && self.damageyaw < 135 ) // Right quadrant
	{
		painAnim = animArray( "stun_recover_l" + animSuffix );
	}
	else if( self.damageyaw > -135 && self.damageyaw < -45 ) // Left quadrant
	{
		painAnim = animArray( "stun_recover_r" + animSuffix );
	}
	else // Back quadrant
	{
		painAnim = animArray( "stun_recover_f" + animSuffix );
	}

	return painAnim;
}

doExplosivePain()
{
	painAnim = getStumblePainAnim();
	assert( IsDefined( painAnim ) );
	
	// play the stumble first
	self SetFlaggedAnimRestart( "painAnim", painAnim, 1, 0.2, 1.0 );
	self animscripts\shared::DoNoteTracks( "painAnim" );
	
	// go into stunned state for a bit
	stunnedLoop = animArray( "idle_stunned" );
	
	self SetFlaggedAnimKnobAll( "stunned", stunnedLoop, %body, 1, 0.2, 1.0 );
	
	self thread playStunnedFx( STUNNED_TIME );
	
	wait( STUNNED_TIME );
	
	// blow off a panel
	animscripts\bigdog\bigdog_init::bodyPieceFallsOff( undefined, true );
	
	// return to regular idle
	idleLoop = animArray( "idle" + animSuffix(), "stop" );
	
	self SetFlaggedAnimKnobAll( "idle", idleLoop, %body, 1, 0.2, 1.0 );
	
	// recovery time
	wait( 1.0 );
}

playStunnedFx( time )
{
	// play the stunned electrical effect
	fxOrigin = Spawn( "script_model", self GetTagOrigin("tag_body") );
	fxOrigin SetModel( "tag_origin" );
	fxOrigin LinkTo( self, "tag_body" );		
	PlayFXOnTag( anim._effect["bigdog_stunned"], fxOrigin, "tag_origin" );
	
	wait( time );
	
	// stop the stunned fx
	fxOrigin Delete();
}