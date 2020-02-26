#include animscripts\anims;
#include maps\_utility;

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
	
	// play one last pain and hunker down
	if( !self.canMove )
	{
		self thread playNearDeathFx();
		self thread playStunnedFx( -1 );
		
		if( !self.hunkeredDown )
		{
			painAnim = getHunkerDownPainAnim();
			
			self SetFlaggedAnimRestart( "painAnim", painAnim, 1, 0.2, 0.75 );
			self animscripts\shared::DoNoteTracks( "painAnim" );
		
			self.hunkeredDown = true;
		}
		
		return;
	}
	else if( self.hunkeredDown )
	{
		painAnim = getFlinchAnim();
	}
	else if( self.damageLeg != "" )
	{
		if( animscripts\pain::isExplosiveDamageMOD( self.damagemod ) )
		{
			painAnim = getStumblePainAnim();
			//SOUND - Shawn J
			self playsound ("veh_claw_hit_alert");
		}
		else
		{
			painAnim = getLegPainAnim();
			//SOUND - Shawn J
			self playsound ("veh_claw_hit_alert");
		}
	}

	/*
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
	*/

	// assert( IsDefined(painAnim) );

	if( IsDefined(painAnim) )
	{
		self SetFlaggedAnimRestart( "painAnim", painAnim, 1, 0.2, 0.75 );
		self animscripts\shared::DoNoteTracks( "painAnim" );
	}
}

playNearDeathFx()
{
	// play some explosions + smoke
	for( i=0; i < 3; i++ )
	{
		if (!isDefined(self))
			return;
			
		boneIndex = RandomInt( anim.bigdog_globals.bodyDamageTags.size );
		tag = anim.bigdog_globals.bodyDamageTags[ boneIndex ];
		
		// play the explosion effect
		PlayFXOnTag( anim._effect["bigdog_panel_explosion_large"], self, tag );
		
		wait( 0.2 );
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
		painAnim = animArray( "stun_recover_r" + animSuffix );
	}
	else if( self.damageyaw > -135 && self.damageyaw < -45 ) // Left quadrant
	{
		painAnim = animArray( "stun_recover_l" + animSuffix );
	}
	else // Back quadrant
	{
		painAnim = animArray( "stun_recover_f" + animSuffix );
	}

	return painAnim;
}

getHunkerDownPainAnim()
{
	animSuffix = animscripts\bigdog\bigdog_utility::animSuffix();
	
	painAnim = animArray( "stun_fall" + animSuffix );
	return painAnim;
}

getFlinchAnim()
{
	painAnim = undefined;
	animSuffix = "";
	//animSuffix = animscripts\bigdog\bigdog_utility::animSuffix();

	if( self.damageyaw > 135 || self.damageyaw <= -135 ) // Front quadrant
	{
		painAnim = animArray( "hunker_down_flinch_b" + animSuffix );
	}
	else if( self.damageyaw > 45 && self.damageyaw < 135 ) // Right quadrant
	{
		painAnim = animArray( "hunker_down_flinch_r" + animSuffix );
	}
	else if( self.damageyaw > -135 && self.damageyaw < -45 ) // Left quadrant
	{
		painAnim = animArray( "hunker_down_flinch_l" + animSuffix );
	}
	else // Back quadrant
	{
		painAnim = animArray( "hunker_down_flinch_f" + animSuffix );
	}

	return painAnim;
}

doExplosivePain()
{
	// only stumble, if you have enough legs
	if( self.canMove )
	{	
		painAnim = getStumblePainAnim();
		assert( IsDefined( painAnim ) );
		
		// play the stumble first
		self SetFlaggedAnimRestart( "painAnim", painAnim, 1, 0.2, 1.0 );
		self animscripts\shared::DoNoteTracks( "painAnim" );
	}
}

playStunnedFx( time )
{
	// play the stunned electrical effect
	fxOrigin = Spawn( "script_model", self GetTagOrigin("tag_body") );
	fxOrigin SetModel( "tag_origin" );
	fxOrigin LinkTo( self, "tag_body" );		
	PlayFXOnTag( anim._effect["bigdog_stunned"], fxOrigin, "tag_origin" );
	
	if( time < 0 )
		self waittill( "death" );
	else
		wait( time );
	
	// stop the stunned fx
	fxOrigin Delete();
}