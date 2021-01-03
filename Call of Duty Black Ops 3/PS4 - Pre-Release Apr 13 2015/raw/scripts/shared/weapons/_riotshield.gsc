#using scripts\codescripts\struct;

#using scripts\shared\callbacks_shared;
#using scripts\shared\clientfield_shared;
#using scripts\shared\killstreaks_shared;
#using scripts\shared\scoreevents_shared;
#using scripts\shared\system_shared;
#using scripts\shared\util_shared;

    	   	                                                                                                                         	                                                                                                                                                                                                                                                                                                                                                                    	        	     	             	    	   	                           	                               	                                	                                                              	                                                                                                              	                            	                                     	                                       	                                                               	   	                  	       	                                                    	                   	                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                        	                                                                                        	           	                        	                                            	                                             	                                                   	                                                             	                                                         	                                                                    	                                                                                                                                                                                                    	                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                      	                                                              	                                                          	                                   	                                   	                                                    	                                       
                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                            	                                                                                                                                                                                                                                                                                                                                                                                       

#precache( "fx", "_t6/weapon/riotshield/fx_riotshield_depoly_lights" );
#precache( "fx", "_t6/weapon/riotshield/fx_riotshield_depoly_dust" );

#using_animtree ( "mp_riotshield" );

#namespace riotshield;

function init_shared()
{
	if ( !isdefined( level.weaponRiotshield ) )
	{
		level.weaponRiotshield = GetWeapon( "riotshield" );
	}

	level.deployedShieldModel = "t6_wpn_shield_carry_world";
	level.stowedShieldModel = "t6_wpn_shield_stow_world";
	level.carriedShieldModel = "t6_wpn_shield_carry_world";
	level.detectShieldModel = "t6_wpn_shield_carry_world_detect";

	level.riotshieldDestroyAnim = %o_riot_stand_destroyed;
	level.riotshieldDeployAnim = %o_riot_stand_deploy;
	
	level.riotshieldShotAnimFront = %o_riot_stand_shot;
	level.riotshieldShotAnimBack = %o_riot_stand_shot_back;
	
	level.riotshieldMeleeAnimFront = %o_riot_stand_melee_front;
	level.riotshieldMeleeAnimBack = %o_riot_stand_melee_back;
	
	level.riotshield_placement_zoffset = 26;
	
	thread register();
	
	callback::on_spawned( &on_player_spawned );
}

//******************************************************************
//                                                                 *
//                                                                 *
//******************************************************************
function register()
{
	clientfield::register( "scriptmover", "riotshield_state", 1, 2, "int" );
}

//******************************************************************
//                                                                 *
//                                                                 *
//******************************************************************
function watchPregameClassChange()
{
	self endon ( "death" );
	self endon ( "disconnect" );
	self endon ( "track_riot_shield" );

	self waittill( "changed_class" );
	
	if (( level.inGracePeriod && !self.hasDoneCombat ))
	{
		self ClearStowedWeapon();
		self RefreshShieldAttachment();
		self thread trackRiotShield();
	}
}

//******************************************************************
//                                                                 *
//                                                                 *
//******************************************************************
function watchRiotshieldPickup() // self == player 
{
	self endon ( "death" );
	self endon ( "disconnect" );
	self endon ( "track_riot_shield" );
	
	self notify( "watch_riotshield_pickup" );
	self endon( "watch_riotshield_pickup" );

	// tagTMR<NOTE>: fix for rare case when riotshield is given by the server
	// but the client fails to equip because of prone

	self waittill( "pickup_riotshield" );
	self endon( "weapon_change" );

	/#println( "Picked up riotshield, expecting weapon_change notify..." );#/

	wait 0.5;

	/#println( "picked up shield but didn't change weapons, attach it!" );#/

	currentWeapon = self getCurrentWeapon();
	self.hasRiotShield = self HasRiotShield();
	self.hasRiotShieldEquipped = ( currentWeapon.isRiotshield );

	self RefreshShieldAttachment();
}

function trackRiotShield() // self == player
{
	self endon( "death" );
	self endon( "disconnect" );

	self notify ( "track_riot_shield" );
	self endon ( "track_riot_shield" );

	self thread watchPregameClassChange();

	self waittill( "weapon_change", newWeapon );

	self RefreshShieldAttachment();

	currentWeapon = self getCurrentWeapon();
	self.hasRiotShield = self HasRiotShield();
	self.hasRiotShieldEquipped = ( currentWeapon.isRiotshield );
	self.lastNonShieldWeapon = level.weaponNone;

	while( true )
	{
		self thread watchRiotshieldPickup();
		currentWeapon = self getCurrentWeapon();

		currentWeapon = self getCurrentWeapon();
		self.hasRiotShield = self HasRiotShield();
		self.hasRiotShieldEquipped = ( currentWeapon.isRiotshield );
		
		refresh_attach = false;

		self waittill( "weapon_change", newWeapon );

		if ( newWeapon.isRiotShield )
		{
			refresh_attach = true;

			// if we have a deployed riotshield in the world, delete if we pickup another
			if ( isdefined( self.riotshieldEntity ))
			{
				self notify( "destroy_riotshield" );
			}

			if ( self.hasRiotShield )
			{
				if ( isdefined( self.riotshieldTakeWeapon ))
				{
					self TakeWeapon( self.riotshieldTakeWeapon );
					self.riotshieldTakeWeapon = undefined;
				}
			}

			if( isValidNonShieldWeapon( currentWeapon ))
			{
				self.lastNonShieldWeapon = currentWeapon;
			}
		}
		
		if ( self.hasRiotShield || ( refresh_attach == true ))
		{
			self RefreshShieldAttachment();
		}
	}
}

function isValidNonShieldWeapon( weapon )
{
	if( killstreaks::is_killstreak_weapon( weapon ) )
		return false;

	if( weapon.isCarriedKillstreak )
		return false;

	if( weapon.isGameplayWeapon )
		return false;
	
	if( weapon == level.weaponNone )
		return false;

	if ( weapon.isEquipment )
		return false;

	return true;

}
//******************************************************************
//                                                                 *
//                                                                 *
//******************************************************************
function startRiotshieldDeploy() // self == player
{
	self notify( "start_riotshield_deploy" );
	self thread watchRiotshieldDeploy();
}

//******************************************************************
//                                                                 *
//                                                                 *
//******************************************************************
function resetReconModelVisibility( owner ) // self == recon model
{
	if ( !isdefined( self ) )
		return;

	self SetInvisibleToAll();
	self SetForceNoCull();

	if ( !isdefined( owner ) )
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
function resetReconModelOnEvent( eventName, owner ) // self == reconModel
{
	self endon( "death" );
	
	for ( ;; )
	{
		level waittill( eventName, newOwner );
		if( isdefined( newOwner ) )
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
function attachReconModel( modelName, owner ) // self == shield model
{
	if ( !isdefined( self ) )
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
function spawnRiotshieldCover( origin, angles ) // self == player
{	
	shield_ent = spawn( "script_model", origin, 1 ); // third param is spawn flag for dynamic pathing
	shield_ent.targetname = "riotshield_mp";
	shield_ent.angles = angles;
	shield_ent SetModel( level.deployedShieldModel );
	shield_ent SetOwner( self );
	shield_ent.owner = self;
	shield_ent.team = self.team;
	shield_ent SetTeam( self.team );

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
function watchRiotshieldDeploy() // self == player
{
	self endon( "death" );
	self endon( "disconnect" );
	self endon( "start_riotshield_deploy" );

	self waittill( "deploy_riotshield", deploy_attempt, weapon );
	self SetPlacementHint( 1 );

	placement_hint = false;

	if ( deploy_attempt )
	{
		placement =	self CanPlaceRiotshield( "deploy_riotshield" );

		if ( placement["result"] /*&& riotshieldDistanceTest( placement["origin"] )*/)
		{
			self.hasDoneCombat = true;

			zoffset = level.riotshield_placement_zoffset;

			shield_ent = self spawnRiotshieldCover( placement["origin"] + (0,0,zoffset), placement["angles"] );
			item_ent = DeployRiotShield( self, shield_ent );

			primaries = self GetWeaponsListPrimaries();

			/#
			assert( isdefined( item_ent ));
			assert( !isdefined( self.riotshieldRetrieveTrigger ));
			assert( !isdefined( self.riotshieldEntity ));
			if (  level.gameType != "shrp" )
			{
				assert( primaries.size > 0 );
			}
			#/

			shield_ent clientfield::set( "riotshield_state", 1 );
			shield_ent.reconModel  clientfield::set( "riotshield_state", 1 );
			
			if (  level.gameType != "shrp" )
			{
				if( self.lastNonShieldWeapon != level.weaponNone && self hasWeapon( self.lastNonShieldWeapon ) )
					self SwitchToWeapon( self.lastNonShieldWeapon );
				else
					self SwitchToWeapon( primaries[0] );
			}
			
			if ( !self HasWeapon( level.weaponBaseMeleeHeld ))
			{
				self GiveWeapon( level.weaponBaseMeleeHeld );
				self.riotshieldTakeWeapon = level.weaponBaseMeleeHeld;
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
			
			clip_max_ammo = weapon.clipSize;
			self setWeaponAmmoClip( weapon, clip_max_ammo );
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
function riotshieldDistanceTest( origin )
{
	/#
	assert ( isdefined( origin ));
	#/

	min_dist_squared = GetDvarFloat( "riotshield_deploy_limit_radius" );
	min_dist_squared *= min_dist_squared;

	for ( i = 0; i < level.players.size; i++ )
	{
		if ( isdefined( level.players[i].riotshieldEntity ))
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
function watchDeployedRiotshieldEnts() // self == player
{
	/#
	assert( isdefined( self.riotshieldRetrieveTrigger ));
	assert( isdefined( self.riotshieldEntity ));
	#/

	self waittill( "destroy_riotshield" );

	if ( isdefined( self.riotshieldRetrieveTrigger ))
	{
		self.riotshieldRetrieveTrigger delete();
	}

	if ( isdefined( self.riotshieldEntity ))
	{
		if ( isdefined( self.riotshieldEntity.reconModel ))
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
function watchDeployedRiotshieldDamage() // self == riotshield script_model ent
{
	self endon("death");

	damageMax = GetDvarInt("riotshield_deployed_health");
	self.damageTaken = 0;

	while( true )
	{
		self.maxhealth = 100000;
		self.health = self.maxhealth;

		self waittill( "damage", damage, attacker, direction, point, type, tagName, modelName, partname, weapon, iDFlags );
		
		if( !isdefined( attacker ) )
		{
			continue;
		}

		/#
		assert( isdefined( self.owner ) && isdefined( self.owner.team ));
		#/

		if ( isplayer( attacker ) )
		{
			if ( (level.teamBased) && ( attacker.team == self.owner.team ) && ( attacker != self.owner))
			{
				continue;
			}
		}

		if ( type == "MOD_MELEE" || type == "MOD_MELEE_ASSASSINATE" )
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
		else if ( type == "MOD_CRUSH" )
		{
			damage = damageMax;
		}

		self.damageTaken += damage;

		if( self.damageTaken >= damageMax )
		{
			self thread damageThenDestroyRiotshield( attacker, weapon );
			break;
		}
	}
}

//******************************************************************
//                                                                 *
//                                                                 *
//******************************************************************
function damageThenDestroyRiotshield( attacker, weapon ) // self == riotshield script_model ent
{
	self notify( "damageThenDestroyRiotshield" );
	self endon("death");

	if ( isdefined( self.owner.riotshieldRetrieveTrigger ))
	{
		self.owner.riotshieldRetrieveTrigger delete();
	}
	
	if ( isdefined( self.reconModel ))
	{
		self.reconModel delete();
	}
	
	self ConnectPaths();
	self.owner.riotshieldEntity = undefined;

	self NotSolid();
	self clientfield::set( "riotshield_state", 2 );
	
	if (isdefined (attacker) && attacker != self.owner && isplayer( attacker ) )
	{
		scoreevents::processScoreEvent( "destroyed_shield", attacker, self.owner, weapon );
	}
	
	wait( GetDvarFloat( "riotshield_destroyed_cleanup_time" ));

	self delete();
}

//******************************************************************
//                                                                 *
//                                                                 *
//******************************************************************
function deleteShieldOnTriggerDeath( shield_trigger ) // self == player
{
	shield_trigger util::waittill_any( "trigger", "death" );
	self notify( "destroy_riotshield" );
}

//******************************************************************
//                                                                 *
//                                                                 *
//******************************************************************
function deleteShieldOnPlayerDeathOrDisconnect( shield_ent ) // self == player
{
	shield_ent endon( "death" );
	shield_ent endon( "damageThenDestroyRiotshield" );

	self util::waittill_any( "death", "disconnect", "remove_planted_weapons" );

	shield_ent thread damageThenDestroyRiotshield();
}

//******************************************************************
//                                                                 *
//                                                                 *
//******************************************************************
function watchRiotshieldStuckEntityDeath( grenade, owner ) // self == entity stuck with nade
{
	grenade endon( "death" );

	self util::waittill_any( "damageThenDestroyRiotshield", "death", "disconnect", "weapon_change", "deploy_riotshield" );

	grenade Detonate( owner );
}

function on_player_spawned()
{
	self thread watch_riot_shield_use();
	self thread begin_other_grenade_tracking();
}

function watch_riot_shield_use() // self == player
{
	self endon( "death" );
	self endon( "disconnect" );

	// watcher for attaching the model to correct player bones
	self thread trackRiotShield();

	for ( ;; )
	{
		self waittill( "raise_riotshield" );
		self thread startRiotshieldDeploy();
	}
}

function begin_other_grenade_tracking()
{
	self endon( "death" );
	self endon( "disconnect" );

	self notify( "riotshieldTrackingStart" );	
	self endon( "riotshieldTrackingStart" );

	for (;;)
	{
		self waittill ( "grenade_fire", grenade, weapon, cookTime );
		
		if ( grenade util::isHacked() )
		{
			continue;
		}

		switch ( weapon.name )
		{
			case "sticky_grenade":
			case "proximity_grenade":
			case "explosive_bolt":				
				grenade thread check_stuck_to_shield();
				break;
		}

	}
}

function check_stuck_to_shield() // self == grenade
{
	self endon( "death" );

	self waittill( "stuck_to_shield", other, owner );
	
	other watchRiotshieldStuckEntityDeath( self, owner );
}
