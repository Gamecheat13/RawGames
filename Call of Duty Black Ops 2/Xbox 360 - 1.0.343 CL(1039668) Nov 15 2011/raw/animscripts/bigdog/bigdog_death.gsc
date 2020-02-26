#include common_scripts\utility;
#include animscripts\anims;

#insert raw\common_scripts\utility.gsh;

#using_animtree ("bigdog");

main()
{
	self endon("killanimscript");
	
	// before any ClearAnim calls
	if( IS_TRUE(self.a.noDeathAnim) )
	{
		wait 0.1;
		return; 
	}

	animscripts\bigdog\bigdog_utility::initialize("death");

	death();
}

end_script()
{
}

death()
{	
	if( self.damageweapon == "f35_missile_turret" )
		return explosive_death();
	else if( animscripts\pain::isExplosiveDamageMOD( self.damagemod ) )
		return explosive_death();

	return normal_death();
}

normal_death()
{
	self OrientMode( "face current" );
	self AnimMode( "zonly_physics" );
	
	animSuffix = animscripts\bigdog\bigdog_utility::animSuffix();

	painAnim = undefined;

	if( self.damageyaw > 135 || self.damageyaw <= -135 ) // Front quadrant
	{
		painAnim = animArray( "stun_fall_b" + animSuffix );
	}
	else if( self.damageyaw > 45 && self.damageyaw < 135 ) // Right quadrant
	{
		painAnim = animArray( "stun_fall_l" + animSuffix );
	}
	else if( self.damageyaw > -135 && self.damageyaw < -45 ) // Left quadrant
	{
		painAnim = animArray( "stun_fall_r" + animSuffix );
	}
	else // Back quadrant
	{
		painAnim = animArray( "stun_fall_f" + animSuffix );
	}

	self SetFlaggedAnimRestart( "deathAnim", painAnim, 1, 0.2, 1 );
	self animscripts\shared::DoNoteTracks( "deathAnim" );
	
	self self_destruct();
}

self_destruct()
{
	fxOrigin = self.origin;

	self playsound( "vox_claw_self_destruct", "sound_done" );
	
	self waittill( "sound_done" );
	
	// same as frag_grenade
	RadiusDamage( fxOrigin, 256, 200, 50 );

	PlayFX( anim._effect["bigdog_explosion"], fxOrigin );
	playsoundatposition( "wpn_bigdog_explode" , fxOrigin ); //explosion audio
}

explosive_death()
{
	self OrientMode( "face current" );
	self AnimMode( "zonly_physics" );

	painAnim = undefined;

	if( self.damageyaw > 135 || self.damageyaw <= -135 ) // Front quadrant
	{
		painAnim = animArray("explosive_death_b");
	}
	else if( self.damageyaw > 45 && self.damageyaw < 135 ) // Right quadrant
	{
		painAnim = animArray("explosive_death_l");
	}
	else if( self.damageyaw > -135 && self.damageyaw < -45 ) // Left quadrant
	{
		painAnim = animArray("explosive_death_r");
	}
	else // Back quadrant
	{
		painAnim = animArray("explosive_death_f");
	}

	self SetFlaggedAnimRestart( "deathAnim", painAnim, 1, 0.2, 1 );
	self animscripts\shared::DoNoteTracks( "deathAnim" );
	
	self self_destruct();
}