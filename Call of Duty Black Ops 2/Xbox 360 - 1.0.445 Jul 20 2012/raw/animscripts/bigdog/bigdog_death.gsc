#include common_scripts\utility;
#include animscripts\anims;
#include maps\_utility;

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
	else if( IS_TRUE( self.a.meleeDeath ) )
	{
		self self_destruct();
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
	return normal_death();
}

normal_death()
{
	self OrientMode( "face angle", self.angles[1] );
	self AnimMode( "zonly_physics" );

	deathAnim = get_death_anim();
	assert( IsDefined( deathAnim ) );
	
	self SetFlaggedAnimRestart( "death", deathAnim, 1, 0.2, 1 );
		
	self self_destruct();
}

get_death_anim()
{
	deathAnim = undefined;
	
	if( self.damageyaw > 135 || self.damageyaw <= -135 ) // Front quadrant
	{
		deathAnim = animArray( "death_b" );
	}
	else if( self.damageyaw > 45 && self.damageyaw < 135 ) // Right quadrant
	{
		deathAnim = animArray( "death_l" );
	}
	else if( self.damageyaw > -135 && self.damageyaw < -45 ) // Left quadrant
	{
		deathAnim = animArray( "death_r" );
	}
	else // Back quadrant
	{
		deathAnim = animArray( "death_f" );
	}
	
	return deathAnim;
}

self_destruct()
{
	fxOrigin = self GetTagOrigin( "tag_body" );

	//self playsound( "vox_claw_self_destruct", "sound_done" );
	//self waittill( "sound_done" );
	
	// same as frag_grenade
	RadiusDamage( fxOrigin, 256, 200, 50 );

	PlayFX( anim._effect["bigdog_explosion"], fxOrigin );
	playsoundatposition( "wpn_bigdog_explode" , fxOrigin ); //explosion audio
	
	// delete turret
	if( IsDefined( self.turret ) )
		self.turret Delete();
	
	// replace with death mode
	self SetModel( "veh_t6_drone_claw_mk2_dead" );
	
	// TODO: don't let AI run through
	//BadPlace_Cylinder( "dead_claw", -1, self GetTagOrigin( "tag_body" ), 50, 100 );
	
	wait( 0.1 );
}

