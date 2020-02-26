// MP

#include maps\mp\_utility;
#include maps\mp\zombies\_zm_utility;
#include common_scripts\utility;

#insert raw\maps\mp\_clientflags.gsh;

init()
{
	level.riotshield_name = "riotshield_zm";

	level.deployedShieldModel = [];
	level.stowedShieldModel = [];
	level.carriedShieldModel = [];

	level.deployedShieldModel[0] = "t6_wpn_zmb_shield_world";
	level.deployedShieldModel[1] = "t6_wpn_zmb_shield_dmg1_world";
	level.deployedShieldModel[2] = "t6_wpn_zmb_shield_dmg2_world";
	level.stowedShieldModel[0] = "t6_wpn_zmb_shield_stow";
	level.stowedShieldModel[1] = "t6_wpn_zmb_shield_dmg1_stow";
	level.stowedShieldModel[2] = "t6_wpn_zmb_shield_dmg2_stow";
	level.carriedShieldModel[0] = "t6_wpn_zmb_shield_world";
	level.carriedShieldModel[1] = "t6_wpn_zmb_shield_dmg1_world";
	level.carriedShieldModel[2] = "t6_wpn_zmb_shield_dmg2_world";
	level.viewShieldModel[0] = "t6_wpn_zmb_shield_view";
	level.viewShieldModel[1] = "t6_wpn_zmb_shield_dmg1_view";
	level.viewShieldModel[2] = "t6_wpn_zmb_shield_dmg2_view";

	precacheModel( level.stowedShieldModel[0] );
	precacheModel( level.stowedShieldModel[1] );
	precacheModel( level.stowedShieldModel[2] );
	precacheModel( level.carriedShieldModel[0] );
	precacheModel( level.carriedShieldModel[1] );
	precacheModel( level.carriedShieldModel[2] );
	precacheModel( level.viewShieldModel[0] );
	precacheModel( level.viewShieldModel[1] );
	precacheModel( level.viewShieldModel[2] );

	loadfx( "weapon/riotshield/fx_riotshield_depoly_lights" );
	loadfx( "weapon/riotshield/fx_riotshield_depoly_dust" );
	
	level.riotshield_placement_zoffset = 26;
}

//******************************************************************
//                                                                 *
//                                                                 *
//******************************************************************
AttachRiotShield( model, tag)
{
	if ( isdefined(self.prev_shield_model) && isdefined(self.prev_shield_tag) )
	{
		self DetachShieldModel( self.prev_shield_model, self.prev_shield_tag );
	}
	self.prev_shield_model=model;
	self.prev_shield_tag=tag;
	if ( isdefined(self.prev_shield_model) && isdefined(self.prev_shield_tag) )
	{
		self AttachShieldModel( self.prev_shield_model, self.prev_shield_tag );
	}
}

RemoveRiotShield()
{
	if ( isdefined(self.prev_shield_model) && isdefined(self.prev_shield_tag) )
	{
		self DetachShieldModel( self.prev_shield_model, self.prev_shield_tag );
	}
	self.prev_shield_model=undefined;
	self.prev_shield_tag=undefined;
	if ( self GetCurrentWeapon() != level.riotshield_name )
		return;
	self setheldweaponmodel(0);
}

//******************************************************************
//                                                                 *
//                                                                 *
//******************************************************************
SetRiotShieldViewModel( modelnum )
{
	self.prev_shield_viewmodel=modelnum;
	if ( self GetCurrentWeapon() != level.riotshield_name )
		return;
	if ( isdefined(self.prev_shield_viewmodel) )
	{
		self setheldweaponmodel(self.prev_shield_viewmodel);
	}
	else
	{
		self setheldweaponmodel(0);
	}
}

SpecialRiotShieldViewModel()
{
	if ( self GetCurrentWeapon() != level.riotshield_name )
		return;
	self setheldweaponmodel(3);
}

RestoreRiotShieldViewModel()
{
	if ( self GetCurrentWeapon() != level.riotshield_name )
		return;
	if ( isdefined(self.prev_shield_viewmodel) )
	{
		self setheldweaponmodel(self.prev_shield_viewmodel);
	}
	else
	{
		self setheldweaponmodel(0);
	}
}

//******************************************************************
// 
// Riot shield damage states
//   0 undamaged
//   1 partially damaged
//   2 heavily damaged
//   3 SPECIAL bright red version used to indicate the shield cannot be planted
// 
// Riot shield placement   
//   0 disabled/destroyed
//   1 wielded
//   2 stowed
//   3 deployed 
//
//******************************************************************

UpdateRiotShieldModel()
{
	update=0;
	if (!isdefined(self.prev_shield_damage_level) || self.prev_shield_damage_level!=self.shield_damage_level )
	{
		self.prev_shield_damage_level=self.shield_damage_level;
		update=1;
	}
	if (!isdefined(self.prev_shield_placement) || self.prev_shield_placement!=self.shield_placement )
	{
		self.prev_shield_placement=self.shield_placement;
		update=1;
	}
	if (update)
	{
		if ( self.prev_shield_placement == 0 )
		{
			self AttachRiotShield();
		}
		else if ( self.prev_shield_placement == 1 )
		{
			self AttachRiotShield( level.carriedShieldModel[self.prev_shield_damage_level], "tag_weapon_left" );
			self SetRiotShieldViewModel( self.prev_shield_damage_level );
		}
		else if ( self.prev_shield_placement == 2 )
		{
			self AttachRiotShield( level.stowedShieldModel[self.prev_shield_damage_level], "tag_stowed_back" );
		}
		else if ( self.prev_shield_placement == 3 )
		{
			self AttachRiotShield();
			if (IsDefined(self.shield_ent) )
				self.shield_ent  SetModel( level.deployedShieldModel[self.prev_shield_damage_level] );
		}
	}
}

//******************************************************************
//                                                                 *
//                                                                 *
//******************************************************************
trackRiotShield()
{
	self endon ( "death" );
	self endon ( "disconnect" );

	self.hasRiotShield = self hasWeapon( level.riotshield_name );
	self.hasRiotShieldEquipped = (self getCurrentWeapon() == level.riotshield_name);
	self.shield_placement=0;

	if ( self.hasRiotShield )
	{
		if ( self.hasRiotShieldEquipped )
		{
			self.shield_placement = 1; 
			self UpdateRiotShieldModel();
			//self AttachRiotShield( level.carriedShieldModel, "tag_weapon_left" );
		}
		else
		{
			self.shield_placement = 2; 
			self UpdateRiotShieldModel();
			//self AttachRiotShield( level.stowedShieldModel, "tag_stowed_back" );
		}
	}

	for ( ;; )
	{
		self waittill ( "weapon_change", newWeapon );
		
		if ( newWeapon == level.riotshield_name )
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

			self.shield_placement = 1; 
			self UpdateRiotShieldModel();
			if ( self.hasRiotShield )
			{
				//self DetachShieldModel( level.stowedShieldModel, "tag_stowed_back" );
				//self AttachRiotShield( level.carriedShieldModel, "tag_weapon_left" );
			}
			else
			{
				//self AttachRiotShield( level.carriedShieldModel, "tag_weapon_left" );
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
			self.hasRiotShield = self hasWeapon( level.riotshield_name );
			
			if ( self.hasRiotShield )
			{
				self.shield_placement = 2; 
				//self DetachShieldModel( level.carriedShieldModel, "tag_weapon_left" );
				//self AttachRiotShield( level.stowedShieldModel, "tag_stowed_back" );
			}
			else if ( isdefined( self.shield_ent ) )
			{
				assert( self.shield_placement == 3 ); 
			}
			else 
			{
				self.shield_placement = 0; 
				//self DetachShieldModel( level.carriedShieldModel, "tag_weapon_left" );
				//self AttachRiotShield();
			}
			self UpdateRiotShieldModel();
			
			self.hasRiotShieldEquipped = false;
		}
		else if ( self.hasRiotShield )
		{
			if ( !self hasWeapon( level.riotshield_name ) )
			{
				// we probably just lost all of our weapons (maybe switched classes)
				//self DetachShieldModel( level.stowedShieldModel, "tag_stowed_back" );
				self.shield_placement = 0; 
				self UpdateRiotShieldModel();
				//self AttachRiotShield();
				self.hasRiotShield = false;
			}
		}
	}
}

//******************************************************************
//                                                                 *
//                                                                 *
//******************************************************************
updateRiotshieldPlacement() // self == player
{
	self endon( "death" );
	self endon( "disconnect" );
	self endon( "deploy_riotshield" );
	self endon( "start_riotshield_deploy" );

	while( 1 )
	{
		placement = self CanPlaceRiotshield( "raise_riotshield" );

		if ( placement["result"] && riotshieldDistanceTest( placement["origin"] ))
		{
			//self SetHeldWeaponModel( 0 );
			self RestoreRiotShieldViewModel();
			self SetPlacementHint( 1 );
		}
		else
		{
			//self SetHeldWeaponModel( 3 );
			self SpecialRiotShieldViewModel();
			self SetPlacementHint( 0 );
		}

		wait( 0.05 );
	}
}

//******************************************************************
//                                                                 *
//                                                                 *
//******************************************************************
startRiotshieldDeploy() // self == player
{
	self notify( "start_riotshield_deploy" );
	self thread updateRiotshieldPlacement();
	self thread watchRiotshieldDeploy();
}

//******************************************************************
//                                                                 *
//                                                                 *
//******************************************************************
SpawnRiotshieldCover( origin, angles ) // self == player
{
	shield_ent = Spawn( "script_model", origin, 1 );
	shield_ent.angles = angles;
	//shield_ent SetModel( level.deployedShieldModel );
	shield_ent SetOwner( self );
	shield_ent.owner = self;
	shield_ent.owner.shield_ent = shield_ent;
	self.shield_placement = 3; 
	self UpdateRiotShieldModel();

	shield_ent SetScriptMoverFlag( 0 ); // SCRIPTMOVER_FLAG_RIOTSHIELD
	
	//shield_ent DisconnectPaths();

	self thread maps\mp\zombies\_zm_buildables::delete_on_disconnect( shield_ent, "destroy_riotshield", true );

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
	//self SetHeldWeaponModel( 0 );
	self RestoreRiotShieldViewModel();
	self SetPlacementHint( 1 );

	placement_hint = false;

	if ( deploy_attempt )
	{
		placement =	self CanPlaceRiotshield( "deploy_riotshield" );

		if ( placement["result"] && riotshieldDistanceTest( placement["origin"] ))
		{
			self notify( "deployed_riotshield" );

			zoffset = level.riotshield_placement_zoffset;

			shield_ent = self SpawnRiotshieldCover( placement["origin"] + (0,0,zoffset), placement["angles"] );
			item_ent = DeployRiotShield( self, shield_ent );

			primaries = self GetWeaponsListPrimaries();

			/#
			assert( IsDefined( item_ent ));
			assert( !IsDefined( self.riotshieldRetrieveTrigger ));
			assert( !IsDefined( self.riotshieldEntity ));
			#/

			if ( primaries.size )
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
			
			clip_max_ammo = WeaponClipSize( level.riotshield_name );
			self setWeaponAmmoClip( level.riotshield_name, clip_max_ammo );
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

	for ( i = 0; i < level.players.size; i++ )
	{
		if ( IsDefined( level.players[i].riotshieldEntity ))
		{
			dist_squared = DistanceSquared( level.players[i].riotshieldEntity.origin, origin );
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

	riotshieldRetrieveTrigger = self.riotshieldRetrieveTrigger;
	riotshieldEntity = self.riotshieldEntity;

	self waittill_either( "destroy_riotshield", "disconnect" );

	self.shield_placement = 0; 
	self UpdateRiotShieldModel();

	if ( IsDefined( riotshieldRetrieveTrigger ))
	{
		riotshieldRetrieveTrigger delete();
	}

	if ( IsDefined( riotshieldEntity ))
	{
		//self.riotshieldEntity ConnectPaths();
		riotshieldEntity delete();
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

		self waittill( "damage", damage, attacker, direction, point, type, tagName, modelName, partname, weaponName, iDFlags );

		if( !isdefined( attacker ) || !isplayer( attacker ))
		{
			continue;
		}

		/#
		assert( isDefined( self.owner ) && isDefined( self.owner.team ));
		#/

		if ( (is_Encounter()) && ( attacker.team == self.owner.team ) && ( attacker != self.owner))
		{
			continue;
		}

		if (isdefined(level.riotshield_damage_callback))
		{
			self.owner [[level.riotshield_damage_callback]]( damage, false );
		}
		else
		{
			// this is largely obsolete - it is left over from the MP version of the riot shield
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
}

//******************************************************************
//                                                                 *
// OBSOLETE                                                        *
//                                                                 *
//******************************************************************
damageThenDestroyRiotshield() // self == riotshield script_model ent
{
	self endon("death");

	self.owner.riotshieldRetrieveTrigger delete();
	self NotSolid();
	self SetClientFlag( CLIENT_FLAG_RIOTSHIELD_DESTROY );

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
	shield_trigger waittill( "trigger", player );
	pickup = true; 
	if (IsDefined(level.canTransferRiotShield))
		pickup = [[level.canTransferRiotShield]](self,player);
	if ( pickup )
	{
		self notify( "destroy_riotshield" );
		if ( self != player )
		{
			if (IsDefined(level.transferRiotShield))
				[[level.transferRiotShield]](self,player);
		}
	}
	else
	{
		iprintlnbold("cannot pickup shield");
	}
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