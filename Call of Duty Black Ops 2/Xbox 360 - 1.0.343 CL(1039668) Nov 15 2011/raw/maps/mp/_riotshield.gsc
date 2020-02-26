#include maps\mp\_utility;
#include common_scripts\utility;

#using_animtree ( "mp_riotshield" );

init()
{
	level.deployedShieldModel = "t6_wpn_shield_carry_world";
	level.stowedShieldModel = "t6_wpn_shield_stow_world";
	level.carriedShieldModel = "t6_wpn_shield_carry_world";

	level.riotshieldDestroyAnim = %o_riot_stand_destroyed;
	level.riotshieldDeployAnim = %o_riot_stand_deploy;
	
	level.riotshieldShotAnimFront = %o_riot_stand_shot;
	level.riotshieldShotAnimBack = %o_riot_stand_shot_back;
	
	level.riotshieldMeleeAnimFront = %o_riot_stand_melee_front;
	level.riotshieldMeleeAnimFront = %o_riot_stand_melee_back;
}

//******************************************************************
//                                                                 *
//                                                                 *
//******************************************************************
trackRiotShield()
{
	self endon ( "death" );
	self endon ( "disconnect" );

	self.hasRiotShield = self hasWeapon( "riotshield_mp" );
	self.hasRiotShieldEquipped = (self getCurrentWeapon() == "riotshield_mp");

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
		
		if ( newWeapon == "riotshield_mp" )
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
			self.hasRiotShield = self hasWeapon( "riotshield_mp" );
			
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
			if ( !self hasWeapon( "riotshield_mp" ) )
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
createRiotShieldWatcher() //self == player
{
	watcher = self maps\mp\gametypes\_weaponobjects::createUseWeaponObjectWatcher( "riotshield", "riotshield_mp", self.team );
	watcher.onSpawn = ::onSpawnRiotShield;
	watcher.onDamage = ::watchRiotShieldDamage;
	watcher.pickUp = ::riotshieldPickUp;
	watcher.onSpawnRetrieveTriggers = ::riotshieldRetrieveTrigger;
}


//******************************************************************
//                                                                 *
//                                                                 *
//******************************************************************
riotshieldRetrieveTrigger( watcher, player ) // self == riotshield
{
	player endon( "death" );
	player endon( "disconnect" );
	level endon( "game_ended" );

	pickup_trigger = Spawn( "trigger_radius_use", self.origin );
	pickup_trigger SetCursorHint( "HINT_NOICON", watcher.weapon );
	pickup_trigger.owner = player;

	self.pickupTrigger = pickup_trigger;

	if( IsDefined( level.retrieveHints[watcher.name] ))
	{
		self.pickUpTrigger SetHintString( level.retrieveHints[watcher.name].hint );
	}
	else
	{
		self.pickUpTrigger SetHintString( &"MP_GENERIC_PICKUP" );
	}

	//Check for FFA
	if( !level.teamBased )
	{
		pickup_trigger SetTeamForTrigger( "none" );
	}
	else
	{
		pickup_trigger SetTeamForTrigger( player.team );
	}

	pickup_trigger EnableLinkTo();
	pickup_trigger LinkTo( self );

	self thread watchRiotshieldRetrieveTrigger( pickup_trigger, watcher );

	// tagTMR<NOTE>: Need another trigger for enemy team since anyone can pickup the riotshield
	other_team_pickup_trigger = Spawn( "trigger_radius_use", self.origin );
	other_team_pickup_trigger SetCursorHint( "HINT_NOICON", watcher.weapon );
	self.otherTeamPickupTrigger = other_team_pickup_trigger;

	if( IsDefined( level.retrieveHints[watcher.name] ))
	{
		self.pickUpTrigger SetHintString( level.retrieveHints[watcher.name].hint );
	}
	else
	{
		self.pickUpTrigger SetHintString( &"MP_GENERIC_PICKUP" );
	}

	if ( level.teamBased )
	{
		other_team_pickup_trigger SetTeamForTrigger( GetOtherTeam( player.team ));
	}
	else
	{
		other_team_pickup_trigger SetTeamForTrigger( "none" );
	}

	triggers = [];
	triggers[ "owner_pickup" ] = pickup_trigger;
	triggers[ "enemy_pickup" ] = other_team_pickup_trigger;

	self thread watchRiotshieldTriggerVisibility( triggers );
	self thread watchRiotshieldRetrieveTrigger( other_team_pickup_trigger, watcher );
	self thread watchRiotshieldShutdown();
}

//******************************************************************
//                                                                 *
//                                                                 *
//******************************************************************
watchRiotshieldTriggerVisibility( triggers ) // self == riotshield ent
{
	self notify( "watchTriggerVisibility" );
	self endon( "watchTriggerVisibility" );

	self endon( "death" );

	while( true )
	{
		players = level.players;
		for( i=0; i < players.size; i++ )
		{
			if ( !IsAlive( players[i] ))
			{
				wait( 0.05 );
				continue;
			}


			if ( self.owner == players[i] )
			{
				if ( players[i] HasWeapon( "riotshield_mp" ))
				{
					triggers[ "owner_pickup" ] SetInvisibleToPlayer( players[i] );
				}
				else
				{	
					triggers[ "owner_pickup" ] SetVisibleToPlayer( players[i] );
				}
			}
			else
			{
				if ( players[i] HasWeapon( "riotshield_mp" ))
				{
					triggers[ "enemy_pickup" ] SetInvisibleToPlayer( players[i] );
				}
				else
				{	
					triggers[ "enemy_pickup" ] SetVisibleToPlayer( players[i] );
				}
			}
		}

		wait( 0.05 );
	}
}

//******************************************************************
//                                                                 *
//                                                                 *
//******************************************************************
watchRiotshieldShutdown()  // self == riotshield ent
{
	owner_trigger = self.pickUpTrigger;
	enemy_trigger = self.otherTeamPickupTrigger;

	self waittill( "death" );

	if( IsDefined( owner_trigger ) )
	{
		owner_trigger delete();
	}
	if( IsDefined( enemy_trigger ) )
	{
		enemy_trigger delete();
	}
}

//******************************************************************
//                                                                 *
//                                                                 *
//******************************************************************
watchRiotshieldRetrieveTrigger( trigger, watcher ) // self == riotshield ent
{
	self endon( "death" );
	self endon( "delete" );
	level endon ( "game_ended" );

	while( true )
	{
		trigger waittill( "trigger", player );

		if ( !IsAlive( player ) )
			continue;

		if ( !player IsOnGround() )
			continue;

		if ( IsDefined( trigger.claimedBy ) && ( player != trigger.claimedBy ) )
			continue;

		if ( player UseButtonPressed() && !player.throwingGrenade && !player meleeButtonPressed() )
		{
			if ( isdefined( watcher.pickUpSoundPlayer ))
			{
				player playLocalSound( watcher.pickUpSoundPlayer );
			}
			if ( isdefined( watcher.pickUpSound ))
			{
				player playSound( watcher.pickUpSound );
			}

			self thread [[ watcher.pickUp ]]( player );
			break;
		}
	}
}

//******************************************************************
//                                                                 *
//                                                                 *
//******************************************************************
onSpawnRiotShield( watcher, player ) // self == riotshield ent
{
	self endon( "death" );

	self thread maps\mp\gametypes\_weaponobjects::onSpawnUseWeaponObject( watcher, player );
	
	self SetOwner( player );
	self SetTeam( player.team );
	self.owner = player;
}

//******************************************************************
//                                                                 *
//                                                                 *
//******************************************************************
watchRiotShieldDamage( watcher ) // self == riotshield ent
{
	// tagTMR<TODO>: add riotshield health for destruction
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
			self SetHeldWeaponModel( 0 );
			self SetPlacementHint( 1 );
		}
		else
		{
			self SetHeldWeaponModel( 1 );
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
	shield_ent = Spawn( "script_model", origin );
	shield_ent.angles = angles;
	shield_ent SetModel( level.deployedShieldModel );
	shield_ent SetOwner( self );
	shield_ent.owner = self;

	shield_ent UseAnimTree( #animtree );
	shield_ent SetScriptMoverFlag( 0 ); // SCRIPTMOVER_FLAG_RIOTSHIELD
	
	return shield_ent;
}

//******************************************************************
//                                                                 *
//                                                                 *
//******************************************************************
shieldDeployAnim() // self == shield ent
{
	self SetAnim( level.riotshieldDeployAnim, 1.0, 0.0, 1.0 );
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
			zoffset = GetDvarfloat("riotshield_placement_zoffset");

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

			shield_ent SetClientFlag( level.const_flag_riotshield_deploy );

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
			
			clip_max_ammo = WeaponClipSize( "riotshield_mp" );
			self setWeaponAmmoClip( "riotshield_mp", clip_max_ammo );
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

		if( !isdefined( attacker ) || !isplayer( attacker ))
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
	self SetClientFlag( level.const_flag_riotshield_destroy );

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

//******************************************************************
//                                                                 *
//                                                                 *
//******************************************************************
riotshieldPickUp( player ) // self == riotshield
{
	primaries = player GetWeaponsListPrimaries();

	if ( primaries.size > 1 )
	{
		current = player getCurrentWeapon();
		player maps\mp\gametypes\_weapons::dropWeaponToGround( current );
	}

	self.playDialog = false;

	self destroyEnt();
	player GiveWeapon( self.name );
	
	clip_ammo = player GetWeaponAmmoClip( self.name );
	clip_max_ammo = WeaponClipSize( self.name );

	if( clip_ammo < clip_max_ammo )
	{
		clip_ammo++;
	}
	player setWeaponAmmoClip( self.name, clip_ammo );

	assert( player HasWeapon( "riotshield_mp" ));
	player SwitchToWeapon( "riotshield_mp" );
}