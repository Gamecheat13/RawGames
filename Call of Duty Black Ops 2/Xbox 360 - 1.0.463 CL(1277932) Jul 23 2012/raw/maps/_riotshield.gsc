// SP

#include maps\_utility;
#include common_scripts\utility;

//#using_animtree ( "mp_riotshield" );

init()
{
	level.deployedShieldModel = "t6_wpn_shield_carry_world";
	level.stowedShieldModel = "t6_wpn_shield_stow_world";
	level.carriedShieldModel = "t6_wpn_shield_carry_world";

	precacheModel( level.deployedShieldModel );
	precacheModel( level.stowedShieldModel );
	precacheModel( level.carriedShieldModel );
	
	level.riotshield_placement_zoffset = 26;

	//level.riotshieldDestroyAnim = %o_riot_stand_destroyed;
	//level.riotshieldDeployAnim = %o_riot_stand_deploy;
	//
	//level.riotshieldShotAnimFront = %o_riot_stand_shot;
	//level.riotshieldShotAnimBack = %o_riot_stand_shot_back;
	//
	//level.riotshieldMeleeAnimFront = %o_riot_stand_melee_front;
	//level.riotshieldMeleeAnimFront = %o_riot_stand_melee_back;
}

//******************************************************************
//                                                                 *
//                                                                 *
//******************************************************************
trackRiotShield()
{
	self endon ( "death" );
	self endon ( "disconnect" );

	self.hasRiotShield = self hasWeapon( "riotshield_sp" );
	self.hasRiotShieldEquipped = (self getCurrentWeapon() == "riotshield_sp");

	if ( self.hasRiotShield )
	{
		if ( self.hasRiotShieldEquipped )
		{
			self AttachShieldModel( level.carriedShieldModel, "tag_weapon_left" );
		}
		else
		{
			self AttachShieldModel( level.stowedShieldModel, "tag_stowed_back" );
		}
	}

	for ( ;; )
	{
		self waittill ( "weapon_change", newWeapon );
		
		if ( newWeapon == "riotshield_sp" )
		{
			// defensive check in case we somehow get an extra "weapon_change"
			if ( self.hasRiotShieldEquipped )
			{
				continue;
			}
			
			// if we have a deployed riotshield in the world, delete if we pickup another
			if ( IsDefined( self.riotshieldEntity ))
			{
				self notify( "destroy_riotshield" );
			}

			if ( self.hasRiotShield )
			{
				self DetachShieldModel( level.stowedShieldModel, "tag_stowed_back" );
				self AttachShieldModel( level.carriedShieldModel, "tag_weapon_left" );
			}
			else
			{
				self AttachShieldModel( level.carriedShieldModel, "tag_weapon_left" );
			}
			
			self.hasRiotShield = true;
			self.hasRiotShieldEquipped = true;
		}
		else if (( self IsMantling()) && ( newWeapon == "none" ))
		{
			// Do nothing, we want to keep that weapon on their arm.
		}
		else if ( self.hasRiotShieldEquipped )
		{
			assert( self.hasRiotShield );
			self.hasRiotShield = self hasWeapon( "riotshield_sp" );
			
			if ( self.hasRiotShield )
			{
				self DetachShieldModel( level.carriedShieldModel, "tag_weapon_left" );
				self AttachShieldModel( level.stowedShieldModel, "tag_stowed_back" );
			}
			else
			{
				self DetachShieldModel( level.carriedShieldModel, "tag_weapon_left" );
			}
			
			self.hasRiotShieldEquipped = false;
		}
		else if ( self.hasRiotShield )
		{
			if ( !self hasWeapon( "riotshield_sp" ) )
			{
				// we probably just lost all of our weapons (maybe switched classes)
				self DetachShieldModel( level.stowedShieldModel, "tag_stowed_back" );
				self.hasRiotShield = false;
			}
		}
	}
}

//******************************************************************
//                                                                 *
//                                                                 *
//******************************************************************
startRiotshieldDeploy() // self == player
{
	self notify( "start_riotshield_deploy" );
	self thread watchRiotshieldDeploy();
}

//******************************************************************
//                                                                 *
//                                                                 *
//******************************************************************
SpawnRiotshieldCover( origin, angles ) // self == player
{
	shield_ent = Spawn( "script_model", origin );
	shield_ent.angles = angles;
	shield_ent SetModel( level.deployedShieldModel );
	shield_ent SetOwner( self );
	shield_ent.owner = self;

	//shield_ent UseAnimTree( #animtree );
	shield_ent SetScriptMoverFlag( 0 ); // SCRIPTMOVER_FLAG_RIOTSHIELD
	
	return shield_ent;
}

//******************************************************************
//                                                                 *
//                                                                 *
//******************************************************************
watchRiotshieldDeploy() // self == player
{
	self endon( "death" );
	self endon( "disconnect" );
	self endon( "start_riotshield_deploy" );

	self waittill( "deploy_riotshield", deploy_attempt );
	self SetHeldWeaponModel( 0 );
	self SetPlacementHint( 1 );

	placement_hint = false;

	if ( deploy_attempt )
	{
		placement =	self CanPlaceRiotshield( "deploy_riotshield" );

		if ( placement["result"] && riotshieldDistanceTest( placement["origin"] ))
		{
			zoffset = level.riotshield_placement_zoffset;

			shield_ent = self SpawnRiotshieldCover( placement["origin"] + (0,0,zoffset), placement["angles"] );
			item_ent = DeployRiotShield( self, shield_ent );

			primaries = self GetWeaponsListPrimaries();

			/#
			assert( IsDefined( item_ent ));
			assert( !IsDefined( self.riotshieldRetrieveTrigger ));
			assert( !IsDefined( self.riotshieldEntity ));
			assert( primaries.size > 0 );
			#/

			//shield_ent thread shieldDeployAnim();
			//shield_ent SetClientFlag( level.const_flag_riotshield_deploy );

			self SwitchToWeapon( primaries[0] );

			self.riotshieldRetrieveTrigger = item_ent;
			self.riotshieldEntity = shield_ent;

			self thread watchDeployedRiotshieldEnts();

			self thread deleteShieldOnDamage( self.riotshieldEntity );
			self thread deleteShieldModelOnWeaponPickup( self.riotshieldRetrieveTrigger );
			self thread deleteRiotshieldOnPlayerDeath();

			self.riotshieldEntity thread watchDeployedRiotshieldDamage();
		}
		else
		{
			placement_hint = true;
			
			clip_max_ammo = WeaponClipSize( "riotshield_sp" );
			self setWeaponAmmoClip( "riotshield_sp", clip_max_ammo );
		}
	}
	else
	{
		// tagTMR<NOTE>: just lowering the shield not trying to deploy
		placement_hint = true;
	}

	if ( placement_hint )
	{
		self SetRiotshieldFailHint();
	}

}

//******************************************************************
//                                                                 *
//                                                                 *
//******************************************************************
// tagTMR<NOTE>: distance check to keep riotshields from deploying too near each other
riotshieldDistanceTest( origin )
{
	/#
	assert ( IsDefined( origin ));
	#/

	min_dist_squared = GetDvarFloat( "riotshield_deploy_limit_radius" );
	min_dist_squared *= min_dist_squared;
	players = get_players();

	for ( i = 0; i < players.size; i++ )
	{
		if ( IsDefined( players[i].riotshieldEntity ))
		{
			dist_squared = DistanceSquared( players[i].riotshieldEntity.origin, origin );
			if ( min_dist_squared > dist_squared )
			{
				/# 
				println( "Shield placement denied!  Failed distance check to other riotshields." );
				#/
				return false;
			}
		}
	}

	return true;
}

//******************************************************************
//                                                                 *
//                                                                 *
//******************************************************************
watchDeployedRiotshieldEnts() // self == player
{
	/#
	assert( IsDefined( self.riotshieldRetrieveTrigger ));
	assert( IsDefined( self.riotshieldEntity ));
	#/

	self waittill( "destroy_riotshield" );

	if ( IsDefined( self.riotshieldRetrieveTrigger ))
	{
		self.riotshieldRetrieveTrigger delete();
	}

	if ( IsDefined( self.riotshieldEntity ))
	{
		self.riotshieldEntity delete();
	}
}

//******************************************************************
//                                                                 *
//                                                                 *
//******************************************************************
watchDeployedRiotshieldDamage() // self == riotshield script_model ent
{
	self endon("death");

	damageMax = GetDvarInt("riotshield_deployed_health");
	self.damageTaken = 0;

	while( true )
	{
		self.maxhealth = 100000;
		self.health = self.maxhealth;

		self waittill( "damage", damage, attacker, direction, point, type );

		if( !isdefined( attacker ) || !isplayer( attacker ))
		{
			continue;
		}

		/#
		assert( isDefined( self.owner ) && isDefined( self.owner.team ));
		#/

		//if ( (level.teamBased) && ( attacker.team == self.owner.team ) && ( attacker != self.owner))
		//{
		//	continue;
		//}

		if ( type == "MOD_MELEE" )
		{
			damage *= GetDvarfloat( "riotshield_melee_damage_scale" );
		}
		else if ( type == "MOD_PISTOL_BULLET" || type == "MOD_RIFLE_BULLET" )
		{
			damage *= GetDvarfloat( "riotshield_bullet_damage_scale" );
		}
		else if ( type == "MOD_GRENADE" || type == "MOD_GRENADE_SPLASH" || type == "MOD_EXPLOSIVE" || type == "MOD_EXPLOSIVE_SPLASH" || type == "MOD_PROJECTILE" || type == "MOD_PROJECTILE_SPLASH")
		{
			damage *= GetDvarfloat( "riotshield_explosive_damage_scale" );
		}
		else if ( type == "MOD_IMPACT" )
		{
			damage *= GetDvarFloat( "riotshield_projectile_damage_scale" );
		}

		//self SetAnim( level.riotshieldDestroyAnim, 1.0, 0.0, 1.0 );

		self.damageTaken += damage;

		if( self.damageTaken >= damageMax )
		{
			self damageThenDestroyRiotshield();
		}
	}
}

//******************************************************************
//                                                                 *
//                                                                 *
//******************************************************************
damageThenDestroyRiotshield() // self == riotshield script_model ent
{
	self endon("death");

	self.owner.riotshieldRetrieveTrigger delete();
	self NotSolid();
	//self SetClientFlag( level.const_flag_riotshield_destroy );

	wait( GetDvarFloat( "riotshield_destroyed_cleanup_time" ));

	self.owner notify( "destroy_riotshield" );
}

//******************************************************************
//                                                                 *
//                                                                 *
//******************************************************************
deleteShieldOnDamage( shield_ent ) // self == player
{
	shield_ent waittill( "death" );
	self notify( "destroy_riotshield" );
}

//******************************************************************
//                                                                 *
//                                                                 *
//******************************************************************
deleteShieldModelOnWeaponPickup( shield_trigger ) // self == player
{
	shield_trigger waittill( "trigger" );
	self notify( "destroy_riotshield" );
}

//******************************************************************
//                                                                 *
//                                                                 *
//******************************************************************
deleteRiotshieldOnPlayerDeath() // self == player
{
	self.riotshieldEntity endon( "death" );
	self waittill( "death" );
	self notify( "destroy_riotshield" );
}