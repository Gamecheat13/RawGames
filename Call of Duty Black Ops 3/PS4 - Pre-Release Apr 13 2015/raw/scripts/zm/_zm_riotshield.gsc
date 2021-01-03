#using scripts\codescripts\struct;

#using scripts\shared\util_shared;

    	   	                                                                                                                         	                                                                                                                                                                                                                                                                                                                                                                    	        	     	             	    	   	                           	                               	                                	                                                              	                                                                                                              	                            	                                     	                                       	                                                               	   	                  	       	                                                    	                   	                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                       	                                                                                        	           	                        	                                            	                                             	                                                   	                                                             	                                                         	                                                                    	                                                                                                                                                                                                    	                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                     	                                                              	                                                          	                                   	                                   	                                                    	                                       

#using scripts\zm\_zm_buildables;
#using scripts\zm\_zm_equipment;
#using scripts\zm\_zm_utility;
#using scripts\zm\_zm_weap_riotshield;
#using scripts\zm\_zm_weapons;



function init()
{
	level.deployedShieldModel = [];
	level.stowedShieldModel = [];
	level.carriedShieldModel = [];

	/*
	level.deployedShieldModel[0] = "wpn_t7_zmb_shield_world_dmg0";
	level.deployedShieldModel[2] = "wpn_t7_zmb_shield_world_dmg1";
	level.deployedShieldModel[3] = "wpn_t7_zmb_shield_world_dmg2";
	level.stowedShieldModel[0] = "wpn_t7_zmb_shield_stow_dmg0";
	level.stowedShieldModel[2] = "wpn_t7_zmb_shield_stow_dmg1";
	level.stowedShieldModel[3] = "wpn_t7_zmb_shield_stow_dmg2";
	level.carriedShieldModel[0] = "wpn_t7_zmb_shield_world_dmg0";
	level.carriedShieldModel[2] = "wpn_t7_zmb_shield_world_dmg1";
	level.carriedShieldModel[3] = "wpn_t7_zmb_shield_world_dmg2";
	level.viewShieldModel[0] = "wpn_t7_zmb_shield_view_dmg0";
	level.viewShieldModel[2] = "wpn_t7_zmb_shield_view_dmg1";
	level.viewShieldModel[3] = "wpn_t7_zmb_shield_view_dmg2";
	*/
	
	level.riotshield_placement_zoffset = 26;
}

//******************************************************************
//                                                                 *
//                                                                 *
//******************************************************************
function AttachRiotShield( model, tag)
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

function RemoveRiotShield()
{
	if ( isdefined(self.prev_shield_model) && isdefined(self.prev_shield_tag) )
	{
		self DetachShieldModel( self.prev_shield_model, self.prev_shield_tag );
	}
	self.prev_shield_model=undefined;
	self.prev_shield_tag=undefined;
	if ( self GetCurrentWeapon() != level.weaponRiotshield )
		return;
}

//******************************************************************
//                                                                 *
//                                                                 *
//******************************************************************
function SetRiotShieldViewModel( modelnum )
{
	self.prev_shield_viewmodel=modelnum;
	if ( self GetCurrentWeapon() != level.weaponRiotshield )
		return;
//	if ( isdefined(self.prev_shield_viewmodel) )
//	{
//		self setheldweaponmodel(self.prev_shield_viewmodel);
//	}
//	else
//	{
//		self setheldweaponmodel(0);
//	}
}

function SpecialRiotShieldViewModel()
{
	if ( self GetCurrentWeapon() != level.weaponRiotshield )
		return;
//	self setheldweaponmodel(3);
}

function RestoreRiotShieldViewModel()
{
	if ( self GetCurrentWeapon() != level.weaponRiotshield )
		return;
//	if ( isdefined(self.prev_shield_viewmodel) )
//	{
//		self setheldweaponmodel(self.prev_shield_viewmodel);
//	}
//	else
//	{
//		self setheldweaponmodel(0);
//	}
}

//******************************************************************
// 
// Riot shield damage states
//   0 undamaged
//   1 SPECIAL bright red version used to indicate the shield cannot be planted
//   2 partially damaged t6_wpn_zmb_shield_dmg1_view
//   3 heavily damaged t6_wpn_zmb_shield_dmg2_view
// 
// Riot shield placement   
//   0 disabled/destroyed
//   1 wielded
//   2 stowed
//   3 deployed 
//
//******************************************************************

function UpdateRiotShieldModel()
{
	{wait(.05);}; 
	self.hasRiotShield = self hasWeapon( level.weaponRiotshield );
	self.hasRiotShieldEquipped = (self getCurrentWeapon() == level.weaponRiotshield);
	if ( self.hasRiotShield )
	{
		if ( self.hasRiotShieldEquipped )
		{
			self SetStowedWeapon( level.weaponNone );
		}
		else
		{
			self SetStowedWeapon( level.weaponRiotshield );
		}
	}
	else
	{
		self SetStowedWeapon( level.weaponNone );
	}
	
	
	/*
	if (!isdefined(self.shield_damage_level))
	{
		if ( isdefined(self.player_shield_reset_health))
			self [[self.player_shield_reset_health]]();
	}
	
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
	*/
}

function UpdateStandaloneRiotShieldModel() // self == shield
{
	/*
	update=0;
	if (!isdefined(self.prev_shield_damage_level) || self.prev_shield_damage_level!=self.shield_damage_level )
	{
		self.prev_shield_damage_level=self.shield_damage_level;
		update=1;
	}
	if (update)
	{
		self SetModel( level.deployedShieldModel[self.prev_shield_damage_level] );
	}
	*/
}

function watchShieldLastStand()
{
	/*
	self endon ( "death" );
	self endon ( "disconnect" );
	
	self notify("watchShieldLastStand");
	self endon("watchShieldLastStand");
	
	while(1)
	{
		self waittill("weapons_taken_for_last_stand");
		self.riotshield_hidden = 0; 
		if (IS_TRUE(self.hasRiotShield))
		{
			if ( self.prev_shield_placement==1 || self.prev_shield_placement==2 )
			{
				self.riotshield_hidden = 2; 
				self.shield_placement = 0;
				self UpdateRiotShieldModel();
			}
		}
		str_notify = self util::waittill_any_return("player_revived","bled_out");
		if(str_notify == "player_revived")
		{
			if (isdefined(self.riotshield_hidden) && self.riotshield_hidden > 0)
			{
				self.shield_placement = self.riotshield_hidden;
				self UpdateRiotShieldModel();
			}
		}
		else
		{
			self player_take_riotshield();
		}
		self.riotshield_hidden = undefined;
	}
	*/
	
}


//******************************************************************
//                                                                 *
//                                                                 *
//******************************************************************
function trackRiotShield()
{
	self endon ( "death" );
	self endon ( "disconnect" );

	self.hasRiotShield = self hasWeapon( level.weaponRiotshield );
	self.hasRiotShieldEquipped = (self getCurrentWeapon() == level.weaponRiotshield);
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
		
		if ( newWeapon == level.weaponRiotshield )
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
			self thread UpdateRiotShieldModel();
		}
		else if (( self IsMantling()) && ( newWeapon == level.weaponNone ))
		{
			// Do nothing, we want to keep that weapon on their arm.
		}
		else if ( self.hasRiotShieldEquipped )
		{
			assert( self.hasRiotShield );
			self.hasRiotShield = self hasWeapon( level.weaponRiotshield );
			
			if ( ( isdefined( self.riotshield_hidden ) && self.riotshield_hidden ) )
			{
			}
			else if ( self.hasRiotShield )
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
			
			self.hasRiotShieldEquipped = false;
			self thread UpdateRiotShieldModel();
		}
		else if ( self.hasRiotShield )
		{
			if ( !self hasWeapon( level.weaponRiotshield ) )
			{
				// we probably just lost all of our weapons (maybe switched classes)
				//self DetachShieldModel( level.stowedShieldModel, "tag_stowed_back" );
				self.shield_placement = 0; 
				//self AttachRiotShield();
				self.hasRiotShield = false;
				self thread UpdateRiotShieldModel();
			}
		}
		else if ( self hasWeapon( level.weaponRiotshield ) )
		{
			// usually get here after picking up a planted riotshield and dropping some other equipment
			self.shield_placement = 2; 
			self.hasRiotShield = true;
			self thread UpdateRiotShieldModel();
		}
	}
}

function trackEquipmentChange()
{
	self endon ( "death" );
	self endon ( "disconnect" );
	for ( ;; )
	{
		self waittill ( "equipment_dropped", equipname );
		self notify( "weapon_change", self GetCurrentWeapon() );
	}
		
}

//******************************************************************
//                                                                 *
//                                                                 *
//******************************************************************
function riotshieldSupportsPlacement( weapon ) 
{
	if ( IsDefined( level.riotshield_supports_deploy ) && !level.riotshield_supports_deploy )
	{
		return false; 
	}
	
	// may want to add some sort of control on a per-weapon basis, but for now

	return true; 
}

//******************************************************************
//                                                                 *
//                                                                 *
//******************************************************************
function updateRiotshieldPlacement() // self == player
{
	self endon( "death" );
	self endon( "disconnect" );
	self endon( "deploy_riotshield" );
	self endon( "start_riotshield_deploy" );
	self endon( "weapon_change" );

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

		{wait(.05);};
	}
}

//******************************************************************
//                                                                 *
//                                                                 *
//******************************************************************
function startRiotshieldDeploy() // self == player
{
	self notify( "start_riotshield_deploy" );
	self thread updateRiotshieldPlacement();
	self thread watchRiotshieldDeploy();
}

//******************************************************************
//                                                                 *
//                                                                 *
//******************************************************************
function SpawnRiotshieldCover( origin, angles ) // self == player
{
	shield_ent = Spawn( "script_model", origin, 1 );
	shield_ent.angles = angles;
	//shield_ent SetModel( level.deployedShieldModel );
	shield_ent SetOwner( self );
	shield_ent.owner = self;
	shield_ent.owner.shield_ent = shield_ent;
	shield_ent.isRiotShield=1;
	self.shield_placement = 3; 
	self UpdateRiotShieldModel();

	shield_ent SetScriptMoverFlag( 0 ); // SCRIPTMOVER_FLAG_RIOTSHIELD
	
	//shield_ent DisconnectPaths();

	self thread zm_buildables::delete_on_disconnect( shield_ent, "destroy_riotshield", true );
	zm_equipment::destructible_list_add( shield_ent );


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

	self waittill( "deploy_riotshield", deploy_attempt );
	//self SetHeldWeaponModel( 0 );
	self RestoreRiotShieldViewModel();
	self SetPlacementHint( 1 );

	placement_hint = false;

	if ( deploy_attempt )
	{
		placement =	self CanPlaceRiotshield( "deploy_riotshield" );

		if ( placement["result"] && riotshieldDistanceTest( placement["origin"] ) && self check_plant_position( placement["origin"], placement["angles"] ) )
		{
			self DoRiotshieldDeploy(placement["origin"], placement["angles"]);
		}
		else
		{
			placement_hint = true;
			
			self setWeaponAmmoClip( level.weaponRiotshield, level.weaponRiotshield.clipSize );
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

function check_plant_position( origin, angles )
{
	if (isdefined(level.equipment_safe_to_drop))
	{
		ret = true;
		test_ent = Spawn( "script_model", origin );
		test_ent  SetModel( level.deployedShieldModel[0] );
		test_ent.angles = angles;
		if (! self [[level.equipment_safe_to_drop]](test_ent) )
		{
			ret = false;
		}
		test_ent delete();
		return ret;
	}
	return true;
}


//******************************************************************
//                                                                 *
//                                                                 *
//******************************************************************
function DoRiotshieldDeploy(origin, angles) // self == player
{
	self endon( "death" );
	self endon( "disconnect" );
	self endon( "start_riotshield_deploy" );

	self notify( "deployed_riotshield" );
	
	//stat tracking
	self zm_buildables::track_placed_buildables(level.weaponRiotshield);

	if ( isdefined(self.current_equipment) && self.current_equipment == level.weaponRiotshield )
		self zm_equipment::to_deployed(level.weaponRiotshield);			
	
	zoffset = level.riotshield_placement_zoffset;

	//shield_ent = self SpawnRiotshieldCover( placement["origin"] + (0,0,zoffset), placement["angles"] );
	shield_ent = self SpawnRiotshieldCover( origin + (0,0,zoffset), angles );
	item_ent = DeployRiotShield( self, shield_ent );

	primaries = self GetWeaponsListPrimaries();

	/#
	assert( IsDefined( item_ent ));
	assert( !IsDefined( self.riotshieldRetrieveTrigger ));
	assert( !IsDefined( self.riotshieldEntity ));
	#/

	self zm_weapons::switch_back_primary_weapon(primaries[0]);

	if (isdefined(level.equipment_planted))
		self [[level.equipment_planted]](shield_ent,level.weaponRiotshield,self);

	if (isdefined(level.equipment_safe_to_drop))
	{
		if (! self [[level.equipment_safe_to_drop]](shield_ent) )
		{
			//self.riotshieldRetrieveTrigger notify("tigger", self);
			
			self notify( "destroy_riotshield" );
			shield_ent delete();
			item_ent delete();
			return;
			
		}
	}
	
	self.riotshieldRetrieveTrigger = item_ent;
	self.riotshieldEntity = shield_ent;

	self thread watchDeployedRiotshieldEnts();

	self thread deleteShieldOnDamage( self.riotshieldEntity );
	self thread deleteShieldModelOnWeaponPickup( self.riotshieldRetrieveTrigger );
	self thread deleteRiotshieldOnPlayerDeath();
	self thread watchShieldTriggerVisibility( self.riotshieldRetrieveTrigger );

	self.riotshieldEntity thread watchDeployedRiotshieldDamage();
	
	return shield_ent;
}
//******************************************************************
//                                                                 *
//                                                                 *
//******************************************************************
// tagTMR<NOTE>: distance check to keep riotshields from deploying too near each other
function riotshieldDistanceTest( origin )
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
function watchDeployedRiotshieldEnts() // self == player
{
	/#
	assert( IsDefined( self.riotshieldRetrieveTrigger ));
	assert( IsDefined( self.riotshieldEntity ));
	#/

	riotshieldRetrieveTrigger = self.riotshieldRetrieveTrigger;
	riotshieldEntity = self.riotshieldEntity;

	self util::waittill_any( "destroy_riotshield", "disconnect", "riotshield_zm_taken" );

	if (isdefined(self))
	{
		self.shield_placement = 0; 
		self UpdateRiotShieldModel();
	}

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

		if (!( isdefined( level.players_can_damage_riotshields ) && level.players_can_damage_riotshields ))
			continue;
		
		if( !isdefined( attacker ) || !isplayer( attacker ))
		{
			continue;
		}

		/#
		assert( isDefined( self.owner ) && isDefined( self.owner.team ));
		#/

		if ( (zm_utility::is_Encounter()) && ( attacker.team == self.owner.team ) && ( attacker != self.owner))
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
function damageThenDestroyRiotshield() // self == riotshield script_model ent
{
	self endon("death");

	self.owner.riotshieldRetrieveTrigger delete();
	self NotSolid();

	wait( GetDvarFloat( "riotshield_destroyed_cleanup_time" ));

	self.owner notify( "destroy_riotshield" );
}

//******************************************************************
//                                                                 *
//                                                                 *
//******************************************************************
function deleteShieldOnDamage( shield_ent ) // self == player
{
	shield_ent waittill( "death" );
	self notify( "destroy_riotshield" );
}

//******************************************************************
//                                                                 *
//                                                                 *
//******************************************************************
function deleteShieldModelOnWeaponPickup( shield_trigger ) // self == player
{
	shield_trigger waittill( "trigger", player );
	//pickup = true; 
	//if (IsDefined(level.canTransferRiotShield))
	//	pickup = [[level.canTransferRiotShield]](self,player);
	//if ( pickup )
	{
		self zm_equipment::from_deployed(level.weaponRiotshield);			
		self notify( "destroy_riotshield" );
		if ( self != player )
		{
			if (IsDefined(level.transferRiotShield))
				[[level.transferRiotShield]](self,player);
		}
	}
	//else
	//{
	//	iprintlnbold("cannot pickup shield");
	//}
}

function watchShieldTriggerVisibility( trigger )
{
	self endon("death");
	trigger endon("death");
	while(isdefined(trigger))
	{
		players = GetPlayers();
		foreach(player in players)
		{
			pickup = true; 
			if (!isdefined(player))
				continue;
			if (IsDefined(level.canTransferRiotShield))
				pickup = [[level.canTransferRiotShield]](self,player);
			if (!isdefined(trigger))
				return;
			if (pickup)
				trigger SetVisibleToPlayer(player);
			else
				trigger SetInvisibleToPlayer(player);
			{wait(.05);};
		}
		{wait(.05);};
	}
}


//******************************************************************
//                                                                 *
//                                                                 *
//******************************************************************
function deleteRiotshieldOnPlayerDeath() // self == player
{
	self.riotshieldEntity endon( "death" );
	self waittill( "death" );
	self notify( "destroy_riotshield" );
}

function player_take_riotshield()
{
//iprintlnbold( "riot shield destroyed" );
	self notify( "destroy_riotshield" );

	if ( self GetCurrentWeapon() == level.weaponRiotshield )
	{
		new_primary = "";
		if (( isdefined( self.laststand ) && self.laststand ))
		{
			new_primary = self.laststandpistol;
			self GiveWeapon(new_primary);
		}
		else
		{
			primaryWeapons = self GetWeaponsListPrimaries();
			for ( i = 0; i < primaryWeapons.size; i++ )
			{
				if ( primaryWeapons[i] != level.weaponRiotshield )
				{
					new_primary = primaryWeapons[i];
					break;
				}
			}
			if (new_primary == "" )
			{
				self zm_weapons::give_fallback_weapon();
				new_primary = level.weaponZMFists;
			}
		}
		self SwitchToWeaponImmediate( new_primary );
		self PlaySound( "wpn_riotshield_zm_destroy" );//when zombies destroy the shield while you are holding it
		self waittill ( "weapon_change" );
	}

	self RemoveRiotShield();	

	self zm_equipment::take(level.weaponRiotshield);

	self.hasRiotShield = false;
	self.hasRiotShieldEquipped = false;
}

