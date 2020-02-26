#include clientscripts\mp\_utility; 
#include clientscripts\mp\_fx;
#include clientscripts\mp\zombies\_zm_utility;

init()
{
	if ( GetDvar( "createfx" ) == "on" )
	{
		return;
	}
	
	if ( isDefined( level.use_freezegun_features ) && level.use_freezegun_features == true )
	{
	}
	else if ( !clientscripts\mp\zombies\_zm_weapons::is_weapon_included( "freezegun_zm" ) )
	{
		return;
	}

	level._ZOMBIE_ACTOR_FLAG_FREEZEGUN_EXTREMITY_DAMAGE_FX = 15;
	register_clientflag_callback( "actor", level._ZOMBIE_ACTOR_FLAG_FREEZEGUN_EXTREMITY_DAMAGE_FX, ::freezegun_extremity_damage_fx );
	level._ZOMBIE_ACTOR_FLAG_FREEZEGUN_TORSO_DAMAGE_FX = 14;
	register_clientflag_callback( "actor", level._ZOMBIE_ACTOR_FLAG_FREEZEGUN_TORSO_DAMAGE_FX, ::freezegun_torso_damage_fx );

	level._gib_overload_func = clientscripts\mp\zombies\_zm_weap_freezegun::freezegun_gib_override;

	level._effect[ "freezegun_shatter" ]				= LoadFX( "weapon/freeze_gun/fx_freezegun_shatter" );
	level._effect[ "freezegun_crumple" ]				= LoadFX( "weapon/freeze_gun/fx_freezegun_crumple" );
	level._effect[ "freezegun_damage_torso" ]			= LoadFX( "maps/zombie/fx_zombie_freeze_torso" );
	level._effect[ "freezegun_damage_sm" ]				= LoadFX( "maps/zombie/fx_zombie_freeze_md" );
	level._effect[ "freezegun_shatter_upgraded" ]		= LoadFX( "weapon/freeze_gun/fx_exp_freezegun_impact" );
	level._effect[ "freezegun_crumple_upgraded" ]		= LoadFX( "weapon/freeze_gun/fx_exp_freezegun_impact" );

	level._effect[ "freezegun_shatter_gib_fx" ]			= LoadFX( "weapon/bullet/fx_flesh_gib_fatal_01" );
	level._effect[ "freezegun_shatter_gibtrail_fx" ]	= LoadFX( "weapon/freeze_gun/fx_trail_freezegun_blood_streak" );
	level._effect[ "freezegun_crumple_gib_fx" ]			= LoadFX( "system_elements/fx_null" );
	level._effect[ "freezegun_crumple_gibtrail_fx" ]	= LoadFX( "system_elements/fx_null" );
	// level._effect[ "freezegun_crumple_gib_fx" ]			= LoadFX( "weapon/bullet/fx_flesh_gib_fatal_01" );
	// level._effect[ "freezegun_crumple_gibtrail_fx" ]	= LoadFX( "trail/fx_trail_blood_streak" );

	level thread player_init();
}


player_init()
{
	waitforclient( 0 );

	players = GetLocalPlayers();
	for( i = 0; i < players.size; i++ )
	{
		player = players[i];
	}
}


freezegun_get_gibfx( shatter )
{
	if ( shatter )
	{
		return level._effect[ "freezegun_shatter_gib_fx" ];
	}
	else
	{
		return level._effect[ "freezegun_crumple_gib_fx" ];
	}
}


freezegun_get_gibtrailfx( shatter )
{
	if ( shatter )
	{
		return level._effect[ "freezegun_shatter_gibtrail_fx" ];
	}
	else
	{
		return level._effect[ "freezegun_crumple_gibtrail_fx" ];
	}
}


freezegun_get_gibsound( shatter )
{
	if ( shatter )
	{
		return "zmb_death_gibs";
	}
	else
	{
		return "zmb_death_gibs";
	}
}


freezegun_get_gibforce( tag, force_from_torso, shatter )
{
	if ( shatter )
	{
		start_pos = self.origin;
		if ( force_from_torso )
		{
			start_pos = self gettagorigin( "J_SpineLower" );
		}

		forward = VectorNormalize( self gettagorigin( tag ) - start_pos );
		forward *= RandomIntRange( 600, 1000 );
		forward += (0, 0, RandomIntRange( 400, 700 ));
		return forward;
	}
	else
	{
		return (0, 0, 0);
	}
}


freezegun_get_shatter_effect( upgraded )
{
	if ( upgraded )
	{
		return level._effect[ "freezegun_shatter_upgraded" ];
	}
	else
	{
		return level._effect[ "freezegun_shatter" ];
	}
}


freezegun_get_crumple_effect( upgraded )
{
	if ( upgraded )
	{
		return level._effect[ "freezegun_crumple_upgraded" ];
	}
	else
	{
		return level._effect[ "freezegun_crumple" ];
	}
}


freezegun_end_extremity_damage_fx( localclientnum, key )
{
	deletefx( localclientnum, self.freezegun_extremity_damage_fx_handles[localclientnum][key], false );
}


freezegun_end_all_extremity_damage_fx( localclientnum )
{
	keys = getArrayKeys( self.freezegun_extremity_damage_fx_handles[localclientnum] );
	for ( i = 0; i < keys.size; i++ )
	{
		freezegun_end_extremity_damage_fx( localclientnum, keys[i] );
	}
}


freezegun_end_extremity_damage_fx_for_all_localclients( key )
{
	players = GetLocalPlayers();
	for( i = 0; i < players.size; i++ )
	{
		freezegun_end_extremity_damage_fx( i, key );
	}
}


freezegun_play_extremity_damage_fx( localclientnum, fx, key, tag )
{
	self.freezegun_extremity_damage_fx_handles[localclientnum][key] = PlayFxOnTag( localclientnum, fx, self, tag );
}


freezegun_play_all_extremity_damage_fx( localclientnum )
{
	if ( !IsDefined( self.freezegun_extremity_damage_fx_handles ) )
	{
		self.freezegun_extremity_damage_fx_handles = [];
	}

	if ( IsDefined( self.freezegun_extremity_damage_fx_handles[localclientnum] ) )
	{
		return;
	}

	self.freezegun_extremity_damage_fx_handles[localclientnum] = [];

	if ( !self clientscripts\mp\zombies\_zm::has_gibbed_piece( level._ZOMBIE_GIB_PIECE_INDEX_RIGHT_ARM ) )
	{
		freezegun_play_extremity_damage_fx( localclientnum, level._effect[ "freezegun_damage_sm" ], "right_arm", "J_Elbow_RI" );
	}
	if ( !self clientscripts\mp\zombies\_zm::has_gibbed_piece( level._ZOMBIE_GIB_PIECE_INDEX_LEFT_ARM ) )
	{
		freezegun_play_extremity_damage_fx( localclientnum, level._effect[ "freezegun_damage_sm" ], "left_arm", "J_Elbow_LE" );
	}
	if ( !self clientscripts\mp\zombies\_zm::has_gibbed_piece( level._ZOMBIE_GIB_PIECE_INDEX_RIGHT_LEG ) )
	{
		freezegun_play_extremity_damage_fx( localclientnum, level._effect[ "freezegun_damage_sm" ], "right_leg", "J_Knee_RI" );
	}
	if ( !self clientscripts\mp\zombies\_zm::has_gibbed_piece( level._ZOMBIE_GIB_PIECE_INDEX_LEFT_LEG ) )
	{
		freezegun_play_extremity_damage_fx( localclientnum, level._effect[ "freezegun_damage_sm" ], "left_leg", "J_Knee_LE" );
	}
}


freezegun_extremity_damage_fx( localClientNum, set, newEnt )
{
	players = getlocalplayers();
	for ( i = 0; i < players.size; i++ )
	{
		if ( set )
		{
			self thread freezegun_play_all_extremity_damage_fx( i );
		}
		else
		{
			self thread freezegun_end_all_extremity_damage_fx( i );
		}
	}
}


freezegun_end_all_torso_damage_fx( localclientnum )
{
	deletefx( localclientnum, self.freezegun_damage_torso_fx[localclientnum], true );
}


freezegun_play_all_torso_damage_fx( localclientnum )
{
	if ( !IsDefined( self.freezegun_damage_torso_fx ) )
	{
		self.freezegun_damage_torso_fx = [];
	}

	if ( IsDefined( self.freezegun_damage_torso_fx[localclientnum] ) )
	{
		return;
	}

	if ( isDefined( level.use_freezegun_features ) && level.use_freezegun_features == true )
	{
		is_gibbed = self clientscripts\mp\zombies\_zm::has_gibbed_piece( level._ZOMBIE_GIB_PIECE_INDEX_LEFT_LEG ) || self clientscripts\mp\zombies\_zm::has_gibbed_piece( level._ZOMBIE_GIB_PIECE_INDEX_RIGHT_LEG );
		if ( is_gibbed )
		{
			// crawlers get the regular fx
			self.freezegun_damage_torso_fx[localclientnum] = PlayFxOnTag( localclientnum, level._effect[ "freezegun_damage_torso" ], self, "J_SpineLower" );
		}
		else
		{
			self.freezegun_damage_torso_fx[localclientnum] = PlayFxOnTag( localclientnum, level._effect[ "waterfreeze" ], self, "tag_origin" );
		}
	}
	else
	{
		self.freezegun_damage_torso_fx[localclientnum] = PlayFxOnTag( localclientnum, level._effect[ "freezegun_damage_torso" ], self, "J_SpineLower" );
	}
}


freezegun_torso_damage_fx( localClientNum, set, newEnt )
{
	players = getlocalplayers();
	for ( i = 0; i < players.size; i++ )
	{
		if ( set )
		{
			self thread freezegun_play_all_torso_damage_fx( i );
		}
		else
		{
			self thread freezegun_end_all_torso_damage_fx( i );
		}
	}
}


freezegun_do_gib_fx( tag, shatter )
{
	players = getlocalplayers();
	for ( i = 0; i < players.size; i++ )
	{
		PlayFxOnTag( i, freezegun_get_gibtrailfx( shatter ), self, tag ); 
	}
	//PlaySound( 0, freezegun_get_gibsound( shatter ), self gettagorigin( tag ) );
}


freezegun_do_gib( model, tag, force_from_torso, shatter )
{
	//PrintLn( "*** Generating gib " + model + " from tag " + tag );

	if ( shatter && !force_from_torso )
	{
		tag_pos = self.origin;
		tag_angles = (0, 0, 1);
	}
	else
	{
		tag_pos = self gettagorigin( tag );
		tag_angles = self gettagangles( tag );
	}

	CreateDynEntAndLaunch( 0, model, tag_pos, tag_angles, tag_pos, self freezegun_get_gibforce( tag, force_from_torso, shatter ), freezegun_get_gibtrailfx( shatter ), 1 );

	self freezegun_do_gib_fx( tag, shatter );
}

freezegun_gib_override( type, locations )
{
	if ( "freeze" != type && "up" != type )
	{
		if ( IsDefined( self.freezegun_damage_fx_handles ) )
		{
			for ( i = 0; i < locations.size; i++ )
			{
				switch( locations[i] )
				{
					case 0: // level._ZOMBIE_GIB_PIECE_INDEX_ALL
						players = getlocalplayers();
						for ( i = 0; i < players.size; i++ )
						{
							self freezegun_end_all_extremity_damage_fx( i );
						}
						break;

					case 1: // level._ZOMBIE_GIB_PIECE_INDEX_RIGHT_ARM
						freezegun_end_extremity_damage_fx_for_all_localclients( "right_arm" );
						break;

					case 2: // level._ZOMBIE_GIB_PIECE_INDEX_LEFT_ARM
						freezegun_end_extremity_damage_fx_for_all_localclients( "left_arm" );
						break;

					case 3: // level._ZOMBIE_GIB_PIECE_INDEX_RIGHT_LEG
						freezegun_end_extremity_damage_fx_for_all_localclients( "right_leg" );
						break;

					case 4: // level._ZOMBIE_GIB_PIECE_INDEX_LEFT_LEG
						freezegun_end_extremity_damage_fx_for_all_localclients( "left_leg" );
						break;

					// our guts torso is missing left arm, so we need to cancel fx on it for the guts case as well
					case 6: // level._ZOMBIE_GIB_PIECE_INDEX_GUTS
						freezegun_end_extremity_damage_fx_for_all_localclients( "left_arm" );
						break;
				} 
			}
		}

		return false;
	}

	upgraded = false;
	for ( i = 0; i < locations.size; i++ )
	{
		switch( locations[i] )
		{
			case 7:
				upgraded = true;
				break;
		}
	}

	shatter = false;
	explosion_effect = freezegun_get_crumple_effect( upgraded );
	alias = "wpn_freezegun_collapse_zombie";
	if ( "up" == type )
	{
		shatter = true;
		explosion_effect = freezegun_get_shatter_effect( upgraded );
		alias = "wpn_freezegun_shatter_zombie";
	}

	// kill the eye glow and damage fx and play the right explosion effect for each player
	players = getlocalplayers();
	for ( i = 0; i < players.size; i++ )
	{
		self clientscripts\mp\zombies\_zm::deleteZombieEyes( i );
		self freezegun_end_all_extremity_damage_fx( i );
		self freezegun_end_all_torso_damage_fx( i );
		PlayFX( i, explosion_effect, self.origin );
		PlaySound( 0, alias, self.origin );
	}

	for ( i = 0; i < locations.size; i++ )
	{
		switch( locations[i] )
		{
			case 0: // level._ZOMBIE_GIB_PIECE_INDEX_ALL
				if ( !self clientscripts\mp\zombies\_zm::has_gibbed_piece( level._ZOMBIE_GIB_PIECE_INDEX_RIGHT_ARM ) &&
						IsDefined( self._gib_def.gibSpawn1 ) && IsDefined( self._gib_def.gibSpawnTag1 ) )
				{
					self thread freezegun_do_gib( self._gib_def.gibSpawn1, self._gib_def.gibSpawnTag1, true, shatter );
				}
				if ( !self clientscripts\mp\zombies\_zm::has_gibbed_piece( level._ZOMBIE_GIB_PIECE_INDEX_LEFT_ARM ) &&
						IsDefined( self._gib_def.gibSpawn2 ) && IsDefined( self._gib_def.gibSpawnTag2 ) )
				{
					self thread freezegun_do_gib( self._gib_def.gibSpawn2, self._gib_def.gibSpawnTag2, true, shatter );
				}
				if ( !self clientscripts\mp\zombies\_zm::has_gibbed_piece( level._ZOMBIE_GIB_PIECE_INDEX_RIGHT_LEG ) &&
						IsDefined( self._gib_def.gibSpawn3 ) && IsDefined( self._gib_def.gibSpawnTag3 ) )
				{
					self thread freezegun_do_gib( self._gib_def.gibSpawn3, self._gib_def.gibSpawnTag3, false, shatter );
				}
				if ( !self clientscripts\mp\zombies\_zm::has_gibbed_piece( level._ZOMBIE_GIB_PIECE_INDEX_LEFT_LEG ) &&
						IsDefined( self._gib_def.gibSpawn4 ) && IsDefined( self._gib_def.gibSpawnTag4 ) )
				{
					self thread freezegun_do_gib( self._gib_def.gibSpawn4, self._gib_def.gibSpawnTag4, false, shatter );
				}

				self thread freezegun_do_gib_fx( "J_SpineLower", shatter ); //guts

				self clientscripts\mp\zombies\_zm::mark_piece_gibbed( level._ZOMBIE_GIB_PIECE_INDEX_RIGHT_ARM );
				self clientscripts\mp\zombies\_zm::mark_piece_gibbed( level._ZOMBIE_GIB_PIECE_INDEX_LEFT_ARM );
				self clientscripts\mp\zombies\_zm::mark_piece_gibbed( level._ZOMBIE_GIB_PIECE_INDEX_RIGHT_LEG );
				self clientscripts\mp\zombies\_zm::mark_piece_gibbed( level._ZOMBIE_GIB_PIECE_INDEX_LEFT_LEG );
				self clientscripts\mp\zombies\_zm::mark_piece_gibbed( level._ZOMBIE_GIB_PIECE_INDEX_HEAD );
				break;
		} 
	}

	self.gibbed = true;
	return true;
}
