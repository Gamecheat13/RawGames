// --------------------------------------------------------------------------------
// ---- Juggernaut for Vorkuta ----
// --------------------------------------------------------------------------------
#include maps\_utility; 
#include common_scripts\utility;
#include animscripts\Utility;
#include animscripts\combat_utility;
#include animscripts\Debug;
#include animscripts\anims_table;

// --------------------------------------------------------------------------------
// ---- Init function for Juggernaut, called from level main script ----
// --------------------------------------------------------------------------------
#using_animtree( "generic_human" );
make_juggernaut( startHuntBehavior )
{
	if( !IsDefined( level.JUGGERNAUT_HEALTH ) )
	{
		level.JUGGERNAUT_GOALRADIUS        = 128;
		level.JUGGERNAUT_GOALHEIGHT        = 81;
		level.JUGGERNAUT_HEALTH            = 1500;
		level.JUGGERNAUT_MINDAMAGE         = 150;
		level.JUGGERNAUT_SPRINTDISTSQ      = 500 * 500;
		level.JUGGERNAUT_SPRINTTTIME	   = 3 * 1000;
	}
	
	if (IsDefined(level.juggernaut_damage_override))
	{
		self.overrideActorDamage		= level.juggernaut_damage_override;	
	}
	else
	{
		self.overrideActorDamage			= ::juggernaut_damage_override;	
	}

	self.juggernaut = true;
	
	// set all the script attributes
	self.allowdeath  		  = true; 		
	self.gibbed      		  = false; 
	self.head_gibbed 		  = false;
	self.grenadeawareness     = 0;
	self.badplaceawareness    = 0;
	self.ignoreSuppression    = true; 	
	self.suppressionThreshold = 1; 
	self.grenadeAmmo		  = 0;					
	self.disableExits		  = true;
	self.disableArrivals	  = true;
	self.a.disableLongDeath   = true;
	self.disableTurns		  = true;
	self.pathEnemyFightDist	  = 128;
	self.pathenemylookahead   = 128;
	self.noreload			  = true;
	self.disableIdleStrafing  = true;
	self.combatMode			  = "no_cover";

	self disable_tactical_walk();
	
	self.script_accuracy = 0.7;
	self.baseAccuracy = 0.7;
	
	self.health				  = level.JUGGERNAUT_HEALTH;
	self.minPainDamage		  = level.JUGGERNAUT_MINDAMAGE;

	self enable_additive_pain( true ); // enable additive pains

	self PushPlayer( true ); 		      
	self disable_react();
	self allowedStances( "stand" );
	
	if (self.team == "axis")
	{
		// set animations
		setup_juggernaut_anim_array();
	}

	self setclientflag(14);

	if( !IsDefined(startHuntBehavior) )
		startHuntBehavior = true;

	if( startHuntBehavior )
		self thread juggernaut_hunt_immediately_behavior();

	level notify( "juggernaut_spawned" );
}

juggernaut_hunt_immediately_behavior()
{
	self endon("death");
	self endon("stop_juggernaut_hunt_behavior");
	
	while (1)
	{
		if( isdefined( self.enemy ) )
		{
			self setgoalpos( self.enemy.origin );
			self.goalradius = level.JUGGERNAUT_GOALRADIUS;
			self.goalheight = level.JUGGERNAUT_GOALHEIGHT;

			if( DistanceSquared( self.origin, self.enemy.origin ) > level.JUGGERNAUT_SPRINTDISTSQ || !( self canSee( self.enemy ) ) )
			{
				self.sprintStartTime = GetTime();
				self.sprint = true;
			}
			else if(    ( DistanceSquared( self.origin, self.enemy.origin ) < level.JUGGERNAUT_SPRINTDISTSQ )
				     || ( IsDefined( self.sprintStartTime ) && ( GetTime() > self.sprintStartTime + level.JUGGERNAUT_SPRINTTTIME ) )
				    )
			{
				self.sprintStartTime = undefined;
				self.sprint = false;
			}
		}
		
		wait .5;
	}
}


juggernaut_damage_override(eInflictor, eAttacker, iDamage, iDFlags, sMeansOfDeath, sWeapon, vPoint, vDir, sHitLoc, modelIndex, psOffsetTime)
{
	Assert( IsDefined( self.minPainDamage ) );
		
	// if its a headshot then instant kill
	isHeadShot = ( sHitLoc == "head" || sHitLoc == "helmet" );
	if( isHeadShot )
		return self.health;
	
	// modify damage and return it
	damage = iDamage;
	
	if( sWeapon == "ak47_gl_sp" &&  sMeansOfDeath == "MOD_RIFLE_BULLET" ) // AK47 
		damage = int( iDamage );
	else if( sWeapon == "ak47_gl_sp" ) // // AK47 grenade launcher
		damage = self.health;
		
	// grenade
	if( sMeansOfDeath == "MOD_EXPLOSIVE" || sMeansOfDeath == "MOD_EXPLOSIVE_SPLASH" 
			|| sMeansOfDeath == "MOD_GRENADE" || sMeansOfDeath == "MOD_GRENADE_SPLASH" )
	{
		// if within 150 units of a grenade, instant death
		if( DistanceSquared( vPoint, self.origin ) > 150 * 150 )
			damage = iDamage;
		else
			damage = self.health;	
	}
		
	// minigun
	if( sWeapon == "minigun_sp" )
		damage = int( iDamage * 1.5 );
	
	// spread	
	if( weaponClass( sWeapon ) == "spread" )
		damage = iDamage;
			
	return damage;
}

juggernaut_protect_behavior( vip )
{
	self endon("death");
	self endon("stop_juggernaut_protect_behavior");

	assert( IsDefined(vip) );

	vip thread juggernaut_vip_protect_spot_manager();

	// AI_TODO: turn this into a subscriber system
	if( !IsDefined(vip.vip_protectors) )
		vip.vip_protectors = 0;
	else
		vip.vip_protectors++;

	vip_protector_index = vip.vip_protectors;

	self.goalradius = 128 * RandomFloatRange( 0.8, 1.2 );

	while (1)
	{
		// go back to hunt if vip dies
		if( !IsDefined(vip) )
		{
			self thread juggernaut_hunt_immediately_behavior();
			break;
		}

		self SetGoalPos( vip.vip_spots[vip_protector_index] );

		wait(0.5);
	}
}

juggernaut_vip_protect_spot_manager()
{
	self endon("death");

	if( is_true(self.vip_spot_manager) )
		return;

	// only one global thread
	self.vip_spot_manager = true;

	// four spots for now
	spotOffsets = array( array(1, 0.5), array(1, -0.5), array(-1, 0.5), array(-1, -0.5) );

	// protect radius
	protectRadius = 150;

	// init the protect spot array
	self.vip_spots = [];
	self.vip_guards = [];
	for( i=0; i < spotOffsets.size; i++ )
	{
		self.vip_spots[ self.vip_spots.size ] = self.origin;
		self.vip_guards[ self.vip_guards.size ] = undefined;

		spotOffsets[i][0] = spotOffsets[i][0] * protectRadius * RandomFloatRange(0.8, 1.2);
		spotOffsets[i][1] = spotOffsets[i][1] * protectRadius * RandomFloatRange(0.8, 1.2);
	}

	while(1)
	{
		vipForward = AnglesToForward( self.angles );
		vipRight = AnglesToRight( self.angles );

		for( i=0; i < spotOffsets.size; i++ )
		{
			forwardOffset = VectorScale( vipForward, spotOffsets[i][0] );
			lateralOffset = VectorScale( vipRight, spotOffsets[i][1] );

			self.vip_spots[i] = self.origin + forwardOffset + lateralOffset;

			// RecordLine( self.origin, self.vip_spots[i], (1,1,1), "Script", self );
		}

		wait(0.2);
	}
}
