#using_animtree("generic_human");

get_turret_anim( weapon_name, anim_name )
{
	str_pose = self.desired_anim_pose;
	if ( !IsDefined( str_pose ) )
	{
		str_pose = self.a.pose;
	}
	
	if ( IsSubStr( weapon_name, "bipod" ) )
	{
		// assume all bipods use the same animations for now
		weapon_name = "bipod";
	}
	
	return anim.anim_array[ self.animType ][ self.a.movement ][ str_pose ][ weapon_name ][ anim_name ];
}

//PARAMETER CLEANUP
main( /*str_pose*/ )
{
	e_turret = self GetTurret();
	
	if ( !IsDefined( e_turret ) )
	{
		return;
	}
	
	self.primaryTurretAnim = get_turret_anim( e_turret.weaponinfo, "aim" );
	self.additiveTurretIdle = get_turret_anim( e_turret.weaponinfo, "idle" );
	self.additiveTurretFire = get_turret_anim( e_turret.weaponinfo, "fire" );
	
	self endon( "killanimscript" ); // code
	 	
	e_turret maps\_turret::_animscripts_init( self ); // uses desired_anim_pose, call before UpdateAnimPose
	animscripts\utility::initialize( "turret" );
			
	self.a.special = "turret";
	
	self animscripts\shared::placeWeaponOn( self.weapon, "none" );

	if ( IsDefined( e_turret.aiOwner ) )
	{
		Assert( e_turret.aiOwner == self );
		
		self.a.postScriptFunc = ::post_script_func;
		self.a.usingTurret = e_turret;
		
		e_turret notify( "being_used" );
		
		self thread stop_using_turret_when_node_lost();
	}
	else
	{
		self.a.postScriptFunc = ::preplaced_post_script_func;
	}

	self SetTurretAnim( self.primaryTurretAnim );
	self SetAnimKnobRestart( self.primaryTurretAnim, 1, 0.2, 1 );
	
	self SetAnimKnobLimitedRestart( self.additiveTurretIdle );
	self SetAnimKnobLimitedRestart( self.additiveTurretFire );
	
	self SetAnim( %additive_turret_idle, 1, .1 );
	self SetAnim( %additive_turret_fire, 0, .1 );
	
	while ( true )
	{
		e_turret waittill( "shooting" );
		
		self SetAnim( %additive_turret_idle, 0, .1 );
		self SetAnim( %additive_turret_fire, 1, .1 );
		
		e_turret waittill( "idle" );
		
		self SetAnim( %additive_turret_idle, 1, .1 );
		self SetAnim( %additive_turret_fire, 0, .1 );
	}
}

stop_using_turret_when_node_lost()
{
	self endon( "killanimscript" );
	
	// sometimes someone else will come and steal our node. when that happens,
	// we should leave so we don't try to use the same MG at once.
	
	while ( true )
	{
		if ( !IsDefined( self.node ) || DistanceSquared( self.origin, self.node.origin ) > 64 * 64 )
		{
			self StopUseTurret();
		}
		
		wait .25;
	}
}

post_script_func( animscript )
{
	if ( animscript == "pain" )
	{
		if ( isdefined( self.node ) && distancesquared( self.origin, self.node.origin ) < 64*64 )
		{
			self.a.usingTurret hide();
			self animscripts\shared::placeWeaponOn( self.weapon, "right" );
			self.a.postScriptFunc = ::post_pain_func;
			return;
		}
		else
		{
			self StopUseTurret();
		}
	}
	
	assert( self.a.usingTurret.aiOwner == self );
	
	if ( animscript == "saw" )
	{
		turret = self getTurret();
		assert( isDefined( turret ) && turret == self.a.usingTurret );
		return;
	}
	
	self.a.usingTurret delete();
	self.a.usingTurret = undefined;

	self animscripts\shared::placeWeaponOn( self.weapon, "right" );
}

post_pain_func( animscript )
{
	assert( isDefined( self.a.usingTurret ) );
	assert( self.a.usingTurret.aiOwner == self );
	
	if ( !isdefined( self.node ) || distancesquared( self.origin, self.node.origin ) > 64*64 )
	{
		self stopUseTurret();
		
		self.a.usingTurret delete();
		self.a.usingTurret = undefined;
		
		// we may have gone into long death, in which case our weapon is gone
		if ( isdefined( self.weapon ) && self.weapon != "none" )
		{
			self animscripts\shared::placeWeaponOn( self.weapon, "right" );
		}
	}
	else if ( animscript != "saw" )
	{
		self.a.usingTurret delete();
	}
}

preplaced_post_script_func( animscript )
{
	self animscripts\shared::placeWeaponOn( self.weapon, "right" );
}