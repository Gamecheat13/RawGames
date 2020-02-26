// MP

#include maps\mp\_utility;
#include common_scripts\utility;

#insert raw\maps\mp\_clientflags.gsh;

#using_animtree ( "mp_riotshield" );

init()
{
	if (!isDefined(level.riotshield_name))
	{
		level.riotshield_name = "riotshield_mp";
		if (isDefined(level.is_zombie_level) && level.is_zombie_level)
			level.riotshield_name = "riotshield_zm";
	}

	level.deployedShieldModel = "t6_wpn_shield_carry_world";
	level.stowedShieldModel = "t6_wpn_shield_stow_world";
	level.carriedShieldModel = "t6_wpn_shield_carry_world";
	level.detectShieldModel = "t6_wpn_shield_carry_world_detect";
		
	if (isDefined(level.is_zombie_level) && level.is_zombie_level)
	{
		level.deployedShieldModel = "t6_wpn_zmb_shield_world";
		level.stowedShieldModel = "t6_wpn_zmb_shield_stow";
		level.carriedShieldModel = "t6_wpn_zmb_shield_world";
	}

	precacheModel( level.stowedShieldModel );
	precacheModel( level.carriedShieldModel );
	precacheModel( level.detectShieldModel );

	level.riotshieldDestroyAnim = %o_riot_stand_destroyed;
	level.riotshieldDeployAnim = %o_riot_stand_deploy;
	
	level.riotshieldShotAnimFront = %o_riot_stand_shot;
	level.riotshieldShotAnimBack = %o_riot_stand_shot_back;
	
	level.riotshieldMeleeAnimFront = %o_riot_stand_melee_front;
	level.riotshieldMeleeAnimBack = %o_riot_stand_melee_back;
	
	loadfx( "weapon/riotshield/fx_riotshield_depoly_lights" );
	loadfx( "weapon/riotshield/fx_riotshield_depoly_dust" );
	
	level.riotshield_placement_zoffset = 26;
}

//******************************************************************
//                                                                 *
//                                                                 *
//******************************************************************
register()
{
	RegisterClientField( "scriptmover", "riotshield_state", 2, "int" );
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

	if ( self.hasRiotShield )
	{
		if ( self.hasRiotShieldEquipped )
		{
			wait( 1 );
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

			if ( self.hasRiotShield )
			{
				self DetachShieldModel( level.stowedShieldModel, "tag_stowed_back" );
				self AttachShieldModel( level.carriedShieldModel, "tag_weapon_left" );
			}
			else
			{
				if ( IsDefined( self.riotshieldTakeWeapon ))
				{
					self TakeWeapon( self.riotshieldTakeWeapon );
					self.riotshieldTakeWeapon = undefined;
				}

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
			self.hasRiotShield = self hasWeapon( level.riotshield_name );
			
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
			if ( !self hasWeapon( level.riotshield_name ) )
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
resetReconModelVisibility( owner ) // self == recon model
{
	if ( !isDefined( self ) )
		return;

	self SetInvisibleToAll();
	self SetForceNoCull();

	if ( !isDefined( owner ) )
		return;

	for ( i = 0 ; i < level.players.size ; i++ )
	{		
		if( level.players[i] HasPerk( "specialty_showenemyequipment" ) )
		{
			if ( level.players[i].team == "spectator" )
				continue;

			isEnemy = true;
				
			if ( level.teamBased )
			{
				if ( level.players[i].team == owner.team )
					isEnemy = false;
			}
			else
			{
				if ( level.players[i] == owner )
					isEnemy = false;
			}
		
			if ( isEnemy )
			{
				self SetVisibleToPlayer( level.players[i] );
			}
		}
	}
}

//******************************************************************
//                                                                 *
//                                                                 *
//******************************************************************
resetReconModelOnEvent( eventName, owner ) // self == reconModel
{
	self endon( "death" );
	
	for ( ;; )
	{
		level waittill( eventName, newOwner );
		if( IsDefined( newOwner ) )
		{
			owner = newOwner;
		}
		self resetReconModelVisibility( owner );
	}
}

//******************************************************************
//                                                                 *
//                                                                 *
//******************************************************************
attachReconModel( modelName, owner ) // self == shield model
{
	if ( !isDefined( self ) )
		return;
		
	reconModel = spawn( "script_model", self.origin );
	reconModel.angles = self.angles;
	reconModel SetModel( modelName );
	reconModel.model_name = modelName;
	reconModel linkto( self );
	reconModel SetContents( 0 );
	reconModel resetReconModelVisibility( owner );

	reconModel thread resetReconModelOnEvent( "joined_team", owner );
	reconModel thread resetReconModelOnEvent( "player_spawned", owner );

	self.reconModel = reconModel;
}

//******************************************************************
//                                                                 *
//                                                                 *
//******************************************************************
spawnRiotshieldCover( origin, angles ) // self == player
{	
	shield_ent = Spawn( "script_model", origin, 1 ); // third param is spawn flag for dynamic pathing
	shield_ent.targetname = "riotshield_mp";
	shield_ent.angles = angles;
	shield_ent SetModel( level.deployedShieldModel );
	shield_ent SetOwner( self );
	shield_ent.owner = self;
	shield_ent.team = self.team;

	shield_ent attachReconModel( level.detectShieldModel, self );

	shield_ent UseAnimTree( #animtree );
	shield_ent SetScriptMoverFlag( 0 ); // SCRIPTMOVER_FLAG_RIOTSHIELD
	
	shield_ent DisconnectPaths();

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

			shield_ent = self spawnRiotshieldCover( placement["origin"] + (0,0,zoffset), placement["angles"] );
			item_ent = DeployRiotShield( self, shield_ent );

			primaries = self GetWeaponsListPrimaries();

			/#
			assert( IsDefined( item_ent ));
			assert( !IsDefined( self.riotshieldRetrieveTrigger ));
			assert( !IsDefined( self.riotshieldEntity ));
			if (  level.gameType != "shrp" )
			{
				assert( primaries.size > 0 );
			}
			#/

			shield_ent SetClientField( "riotshield_state", 1 );
			shield_ent.reconModel  SetClientField( "riotshield_state", 1 );
			
			if (  level.gameType != "shrp" )
			{
				self SwitchToWeapon( primaries[0] );
			}
			
			if ( !self HasWeapon( "knife_held_mp" ))
			{
				self GiveWeapon( "knife_held_mp" );
				self.riotshieldTakeWeapon = "knife_held_mp";
			}

			self.riotshieldRetrieveTrigger = item_ent;
			self.riotshieldEntity = shield_ent;

			self thread watchDeployedRiotshieldEnts();

			self thread deleteShieldOnTriggerDeath( self.riotshieldRetrieveTrigger );
			self thread deleteShieldOnPlayerDeathOrDisconnect( shield_ent );

			self.riotshieldEntity thread watchDeployedRiotshieldDamage();
			level notify( "riotshield_planted", self );
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

	self waittill( "destroy_riotshield" );

	if ( IsDefined( self.riotshieldRetrieveTrigger ))
	{
		self.riotshieldRetrieveTrigger delete();
	}

	if ( IsDefined( self.riotshieldEntity ))
	{
		if ( IsDefined( self.riotshieldEntity.reconModel ))
		{
			self.riotshieldEntity.reconModel delete();
		}

		self.riotshieldEntity ConnectPaths();
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

		self waittill( "damage", damage, attacker, direction, point, type, tagName, modelName, partname, weaponName, iDFlags );
		
		if( !isdefined( attacker ) )
		{
			continue;
		}

		if ( IsDefined( attacker.targetname ) && attacker.targetname == "talon" )
		{
		}
		else if ( !isplayer( attacker )  )
		{
			continue;
		}

		/#
		assert( isDefined( self.owner ) && isDefined( self.owner.team ));
		#/

		if ( (level.teamBased) && ( attacker.team == self.owner.team ) && ( attacker != self.owner))
		{
			continue;
		}

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

		self.damageTaken += damage;

		if( self.damageTaken >= damageMax )
		{
			self thread damageThenDestroyRiotshield();
			break;
		}
	}
}

//******************************************************************
//                                                                 *
//                                                                 *
//******************************************************************
damageThenDestroyRiotshield() // self == riotshield script_model ent
{
	self notify( "damageThenDestroyRiotshield" );
	self endon("death");

	self.owner.riotshieldRetrieveTrigger delete();
	self.reconModel delete();
	
	self ConnectPaths();
	
	self.owner.riotshieldEntity = undefined;

	self NotSolid();
	self SetClientField( "riotshield_state", 2 );

	wait( GetDvarFloat( "riotshield_destroyed_cleanup_time" ));

	self delete();
}

//******************************************************************
//                                                                 *
//                                                                 *
//******************************************************************
deleteShieldOnTriggerDeath( shield_trigger ) // self == player
{
	shield_trigger waittill_any( "trigger", "death" );
	self notify( "destroy_riotshield" );
}

//******************************************************************
//                                                                 *
//                                                                 *
//******************************************************************
deleteShieldOnPlayerDeathOrDisconnect( shield_ent ) // self == player
{
	shield_ent endon( "death" );
	shield_ent endon( "damageThenDestroyRiotshield" );

	self waittill_any( "death", "disconnect", "remove_planted_weapons" );

	shield_ent thread damageThenDestroyRiotshield();
}
