// MikeD (10/24/2007 6:57:36): Forces an AI to throw a grenade at a specific position
// MikeD: Use this until we get a animscripted method? Do we need to?
#using_animtree( "generic_human" );
force_grenade_toss( pos, grenade_weapon, explode_time, anime, throw_tag )
{
	self endon( "death" );

	og_grenadeweapon = undefined;

	// Give him a the grenade
	if( IsDefined( grenade_weapon ) )
	{
		og_grenadeweapon = self.grenadeWeapon;
		self.grenadeWeapon = grenade_weapon;
	}
	self.grenadeammo++;

	if( !IsDefined( explode_time ) )
	{
		explode_time = 4;
	}

	if( !IsDefined( throw_tag ) )
	{
		throw_tag = "tag_inhand";
	}
	
	// Point him towards the grenade point
	angles = VectorToAngles( pos - self.origin );
	self OrientMode( "face angle", angles[1] );
	
	// Don't throw a grenade if the pos is too close
	if( DistanceSquared( self.origin, pos ) < 200 * 200 )
	{
/#
		println( "^3Grenade position is too close!" );
#/
		return false;
	}

	// Save the pos to throw the grenade at.
	self.force_grenade_throw_tag = throw_tag;
	self.force_grenade_pos = pos;
	self.force_grenade_explod_time = explode_time;

	if( !IsDefined( anime ) )
	{
		anime = "force_grenade_throw";

		// If no animname on the AI already, create a temp one.
		if( !IsDefined( self.animname ) )
		{
			self.animname = "force_grenader";
		}
	
		// If there isn't a anime setup with the attach/detach and animation, then create one.
		if( !IsDefined( level.scr_anim[self.animname] ) || !IsDefined( level.scr_anim[self.animname][anime] ) )
		{
			switch( self.a.special )
			{
				case "cover_crouch":
				case "none":
					if (self.a.pose == "stand")
					{
						throw_anim = %stand_grenade_throw;
					}
					else // if (self.a.pose == "crouch")
					{
						throw_anim = %crouch_grenade_throw;
					}
		
					gun_hand = "left";
					break;
				default: // Do nothing - we don't have an appropriate throw animation.
					throw_anim = %stand_grenade_throw;
					gun_hand = "left";
					break;
			}

			// Setup the _anim stuff.
			level.scr_anim[self.animname][anime] = throw_anim;
			maps\_anim::addNotetrack_attach( self.animname, "grenade_right", GetWeaponModel( self.grenadeweapon ), self.force_grenade_throw_tag, anime );
			maps\_anim::addNotetrack_detach( self.animname, "fire", GetWeaponModel( self.grenadeweapon ), self.force_grenade_throw_tag, anime );
		}
	}

	// SRS 7/17/2008: checks to see if the function exists, so it doesn't get set up multiple times if multiple guys with the
	//	same animname are doing force_grenade_toss throughout the level (default is that this will happen)
	function = ::force_grenade_toss_internal;
	if( !maps\_anim::notetrack_customfunction_exists( self.animname, "fire", function, anime ) )
	{
		maps\_anim::addNotetrack_customFunction( self.animname, "fire", function, anime );
	}
	
	if( !IsDefined( level.scr_sound[self.animname] ) || !IsDefined( level.scr_sound[self.animname][anime] ) )
	{
		self animscripts\battleChatter_ai::evaluateAttackEvent("grenade");
	}

	// Play the anim!
	self maps\_anim::anim_single_solo( self, anime );

	// Now reset anything that needs to be.
	if( self.animname == "force_grenader" )
	{
		self.animname = undefined;
	}

	if( IsDefined( og_grenadeweapon ) )
	{
		self.grenadeWeapon = og_grenadeweapon;
	}

	self notify( "forced_grenade_thrown" );

	return true;
}

force_grenade_toss_internal( guy )
{
	guy MagicGrenade( guy GetTagOrigin( guy.force_grenade_throw_tag ), guy.force_grenade_pos, guy.force_grenade_explod_time );
	
	guy.grenadeammo--;	

	guy.force_grenade_pos = undefined;
	guy.force_grenade_explod_time = undefined;
	guy.force_grenade_throw_tag = undefined;
}