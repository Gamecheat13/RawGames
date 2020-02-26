#include common_scripts\utility;
#include maps\_utility;
#include maps\_so_code;

#insert raw\maps\_utility.gsh;

init()
{
	level.CONST_AMMO_ARMOR_START = 250;
	level.CONST_AMMO_ARMOR_JUG_START = 500;
	
	SetDvar( "ui_specops", 1 );
}

preload()
{
	precacheItem( "ally_squad_sp" );
}

postload()
{
}

// Laststand can_give() and give() functions
can_give_laststand( ref )
{
	return maps\_laststand::get_lives_remaining() == 0;
}

give_laststand( ref )
{
	maps\_laststand::update_lives_remaining( true );
}


// Armor can_give() and give() functions as well as general armor logic
can_give_armor( ref )
{
	if ( !isdefined( self.armor ) )
		return true;

	armor_points = 0;

	if ( ref == "armor" )
	{
		armor_points = level.CONST_AMMO_ARMOR_START;
	}
	else if ( ref == "juggernaut_suit" )
	{
		armor_points = level.CONST_AMMO_ARMOR_JUG_START;
	}

	if ( self.armor[ "points" ] < armor_points )
	{
		return true;
	}

	return false;
}

give_armor( ref )
{
	give_armor_amount( ref );
}

armor_init()
{
	assert( isdefined( self ) && isplayer( self ), "Armor init not called on player." );

	self.max_armor_points = 0;
	self.armor = [];
	self.armor[ "type" ] 	= "";
	self.armor[ "points" ]	= 0;

	// catch damage before death and spend armor points
	self thread player_armor_shield();
}

give_armor_amount( type, points )
{
	assert( isdefined( type ) && ( type == "armor" || type == "juggernaut_suit" ), "Invalid armor type: " + type );

	if ( !isdefined( points ) )
	{
		if ( type == "armor" )
		{
			points = level.CONST_AMMO_ARMOR_START;
		}
		else if ( type == "juggernaut_suit" )
		{
			points = level.CONST_AMMO_ARMOR_JUG_START;
		}
		else
		{
			// Invalid type
			return;
		}
	}

	if ( !IsDefined( self.armor ) )
	{
		// Setup up armor on player
		self armor_init();
	}

	// Prevent dogs from pinning the player before armor is out
	self.dogs_dont_instant_kill = true;

	self.armor[ "type" ]	= type;
	self.armor[ "points" ]	= points;
	self.max_armor_points	= points;

	self notify( "health_update" );
}

player_armor_shield()
{
	self endon( "death" );

	assert( !isdefined( self.armor_shield_on ), "Armor shield turned on more than once." );
	if ( isdefined( self.armor_shield_on ) )
	{
		return;
	}

	self.armor_shield_on = true;

	while ( 1 )
	{
		//self.previous_health = self.health;
		self waittill( "damage", damage, attacker, direction, point, type, modelName, tagName, partName, dflags, weaponName );
		self.previous_health = int( min( 100, self.health + damage ) );

		// if armor still active
		self.saved_by_armor = false;

		if ( self.armor[ "points" ] > 0 )
		{
			// armor hit effects - no need!
			//self PlayRumbleOnEntity( "damage_light" );

			self.saved_by_armor = true;

			remaining_armor_points = self.armor[ "points" ] - damage;
			damage_penetration = int( max( 0, 0 - remaining_armor_points ) );

			// recover player health when armor took all the damage
			if ( !damage_penetration )
			{
				self.armor[ "points" ] -= damage;
				self SetNormalHealth( 1 );
			}
			else
			{
				// damage has penetrated the armor, but has yet to kill player
				set_health_frac = int_capped( self.previous_health - damage_penetration, 1, 100 ) / 100;
				self SetNormalHealth( set_health_frac );

				// calculate if player will get deathshield notify
				if ( self.armor[ "points" ] + self.previous_health <= damage )
				{
					self.saved_by_armor = false;
				}

				self.armor[ "points" ] = 0;
			}

			if ( self.armor[ "points" ] <= 0 )
			{
				// Allow dogs to pin and kill the player
				self.dogs_dont_instant_kill = undefined;
			}

			self notify( "health_update" );
		}
	}
}


give_friendlies()
{
	// Broken out to allow threading
	
	self setactionslot( 3, "weapon", "ally_squad_sp" );
	if (!self hasweapon("ally_squad_sp"))
	{
		self GiveWeapon("ally_squad_sp");
	}
	else
	{
		callsLeft = self GetWeaponAmmoClip("ally_squad_sp" );
		self SetWeaponAmmoClip( "ally_squad_sp", callsLeft+1 );
	}
	
	self thread give_friendlies_monitor_use();
}

give_friendlies_monitor_use()
{
	// we only need one, yo
	if( IsDefined( self.give_friendlies_thread_running ) )
		return;
	self.give_friendlies_thread_running = true;

	self endon( "death" );
	
	while(1)
	{
		self waittill( "grenade_fire", weapon, weapname );
		if ( weapname != "ally_squad_sp" )
			continue;

		weapon thread do_weapon_detonation( weapname );;

		/#
		IPrintLn( "chopper incoming" );
		#/
		
		// generate the AI types that will rappel down
		ally_manifest = array( "friendly_sniper", "friendly_heavy", "friendly_assault" );
		//ally_manifest = array_randomize( ally_manifest );
		
		// take only the squad members that we need
		temp_array = [];
		for( i=0; i < level.so.ally_squad_size && i < ally_manifest.size; i++ )
		{
			temp_array[ temp_array.size ] = ally_manifest[i];
		}
		ally_manifest = temp_array;
	
		// Not threaded so this function ends at the time that
		// all allies have spawned.
		weapon waitTillNotMoving();
		self thread spawn_allies( weapon.origin + (0,0,1000), ally_manifest, self, 3.0 );
	}
}

do_weapon_detonation( weapname ) // self == weapon
{
	self endon( "death" );
	self endon ( "grenade_timeout" );

	// control the explosion events to circumvent the code cleanup
	self waitTillNotMoving();
	self.angles = ( 0, self.angles[1], 90 );
	fuse_time = GetWeaponFuseTime( weapname ) / 1000; // fuse time comes back in milliseconds
	wait( fuse_time );
	thread playSmokeSound( self.origin, 6, level.sound_smoke_start, level.sound_smoke_stop, level.sound_smoke_loop );
	PlayFXOnTag( level._supply_drop_smoke_fx, self, "tag_fx" );
	proj_explosion_sound = GetWeaponProjExplosionSound( weapname );
	play_sound_in_space( proj_explosion_sound, self.origin );

	// need to clean up the canisters
	wait( 3 );
	self delete();
}

/@
"Name: is_player_down( <player> )"
"Summary: Returns true if a player is in last stand mode or dead."
"Module: Entity"
"CallOn: A player"
"MandatoryArg: <player>: The player you want to check."
"Example: return is_player_down( level.player );"
"SPMP: singleplayer"
@/
is_player_down( player )
{
	Assert( IsDefined( player ) && IsPlayer( player ), "is_player_down() requires a valid player to test." );

	return player maps\_laststand::player_is_in_laststand();
	/*
	if ( player ent_flag_exist( "laststand_downed" ) )
	return player ent_flag( "laststand_downed" );

	if ( IsDefined( player.laststand ) )
	return player.laststand;

	return !IsAlive( player );
	*/
}

/*
=============
///ScriptDocBegin
"Name: is_player_down_and_out( <player> )"
"Summary: Returns true if a player is in last stand mode AND been knocked into "out" mode... where they have no weapon."
"Module: Entity"
"CallOn: A player"
"MandatoryArg: <player>: "
"Example: bool = is_player_down_and_out( level.player );"
"SPMP: singleplayer"
///ScriptDocEnd
=============
*/
is_player_down_and_out( player )
{
	assert( isdefined( player ) && isplayer( player ), "is_player_down_and_out() requires a valid player to test." );

	if ( !isdefined( player.down_part2_proc_ran ) )
		return false;

	return player.down_part2_proc_ran;
}

/@
"Name: get_closest_player_healthy( <org> )"
"Summary: Returns the closest player that is not bleeding out to the specified origin."
"Module: Distance"
"CallOn: "
"MandatoryArg: <org> : Origin to be closest to."
"Example: player = get_closest_player_healthy( tank.origin );"
"SPMP: singleplayer"
@/
get_closest_player_healthy( org )
{
	players = GetPlayers();
	if ( players.size == 1 )
		return players[0];

	healthyPlayers = get_players_healthy();

	player = getClosest( org, healthyPlayers );

	return player;
}
get_closest_ent( org,entArray )
{
	return getClosest( org, entArray );
}

/@
"Name: get_players_healthy()"
"Summary: Returns all players not bleeding out."
"Module: Utility"
"Example: players = get_players_healthy();"
"SPMP: singleplayer"
@/
get_players_healthy()
{
	players = GetPlayers();

	healthy_players = [];
	foreach ( player in players )
	{
		if ( is_player_down( player ) )
			continue;

		healthy_players[ healthy_players.size ] = player;
	}

	return healthy_players;
}

/@
"Name: kill_wrapper( <kill_wrapper> )"
"Summary: Wrapper to safely handle killing entities. Does special checks to ensure stability when killing players in Special Ops. Returns true or false depending on whether it actually killed the player."
"Module: Entity"
"CallOn: An entity"
"Example: level.player kill_wrapper();"
"SPMP: singleplayer"
@/
kill_wrapper()
{
	// Only do special checking in special ops for now, and only on players.
	// Players are put into invulnerable states that are unpredictable in Special Ops which can result in
	// attempts to call kill() directly to assert. If the special op has already terminated just exit out. If the
	// player is downed force invulnerability off so the kill will be able to succeed.

	if ( isplayer( self ) )
	{
		if ( flag_exists( "special_op_terminated" ) && flag( "special_op_terminated" ) )
		{
			return false;
		}

		if ( is_player_down( self ) )
		{
			self disableinvulnerability();
		}
	}
	self EnableDeathShield( false );
	self kill();
	return true;
}


/@
"Name: place_weapon_on( <weapon>, <location> )"
"Summary: Equip a wepaon on an AI."
"Module: AI"
"CallOn: An AI"
"MandatoryArg: <weapon> : The name of the weapon to equip"
"MandatoryArg: <> : Slot to store the weapon in. 'right', 'left', 'chest', or 'back'."
"Example: level.price place_weapon_on( "at4", "back" );"
"SPMP: singleplayer"
@/
place_weapon_on( weapon, location )
{
	Assert( IsAI( self ) );

	if( !animscripts\utility::AIHasWeapon( weapon ) )
		animscripts\init::initWeapon( weapon );

	animscripts\shared::placeWeaponOn( weapon, location );
}

/@
"Name: forceUseWeapon( <newWeapon>, <targetSlot> )"
"Summary: Forces the AI to switch to a specified weapon."
"Module: AI"
"CallOn: An AI"
"MandatoryArg: <newWeapon> : The name of the weapon to use/give"
"MandatoryArg: <target slot> : Slot to store the weapon in. primary, secondary or sidearm."
"Example: level.price forceUseWeapon( "glock", "sidearm" );"
"SPMP: singleplayer"
@/
forceUseWeapon( newWeapon, targetSlot )
{
	Assert( IsDefined( newWeapon ) );
	Assert( newWeapon != "none" );
	Assert( IsDefined( targetSlot ) );
	Assert( ( targetSlot == "primary" ) || ( targetSlot == "secondary" ) || ( targetSlot == "sidearm" ), "Target slot is either primary, secondary or sidearm." );

	// Setup the weaponInfo if it wasn't already done
	if ( !animscripts\init::isWeaponInitialized( newWeapon ) )
		animscripts\init::initWeapon( newWeapon );

	// Figure out whether the current and target weapons are side arms, and which slot to go to
	hasWeapon = ( self.weapon != "none" );
	isCurrentSideArm = usingSidearm();
	isNewSideArm = ( targetSlot == "sidearm" );
	isNewSecondary = ( targetSlot == "secondary" );

	// If we have a weapon and we're not replacing it with one of the same "type", we need to hoslter it first
	if ( hasWeapon && ( isCurrentSideArm != isNewSideArm ) )
	{
		Assert( self.weapon != newWeapon );

		// Based on the current weapon - Hide side arms completely, and holster based on the new target otherwise
		if ( isCurrentSideArm )
			holsterTarget = "none";
		else if ( isNewSecondary )
			holsterTarget = "back";
		else
			holsterTarget = "chest";

		animscripts\shared::placeWeaponOn( self.weapon, holsterTarget );

		// Remember we switched out of that weapon
		if( !isCurrentSideArm )
			self.lastWeapon = self.weapon;
	}
	else
	{
		// We didn't have a weapon before, or we're going to loose the one we had, so reset the lastWeapon.
		self.lastWeapon = newWeapon;
	}

	// Put the new weapon in hand
	animscripts\shared::placeWeaponOn( newWeapon, "right" );

	// Replace the equipped weapon slot of the same type with the new weapon ( could stay the same, too )
	// If the AI was using a secondary, replace that slot instead of primary
	if ( isNewSideArm )
		self.sideArm = newWeapon;
	else if ( isNewSecondary )
		self.secondaryweapon = newWeapon;
	else
		self.primaryweapon = newWeapon;

	// Set our current weapon to the new one
	self.weapon = newWeapon;
	self.bulletsinclip = WeaponClipSize( self.weapon );
	self notify( "weapon_switch_done" );
}

/@
"Name: enable_sprint()"
"Summary: Force an ai to sprint."
"Module: AI"
"Example: guy enable_sprint()"
"SPMP: singleplayer"
@/
enable_sprint()
{
	Assert( IsAI( self ), "Tried to make an ai sprint but it wasn't called on an AI" );
	self.sprint = true;
}

/@
"Name: disable_sprint()"
"Summary: Disable forced sprinting."
"Module: AI"
"Example: guy disable_sprint()"
"SPMP: singleplayer"
@/
disable_sprint()
{
	Assert( IsAI( self ), "Tried to unmake an ai sprint but it wasn't called on an AI" );
	self.sprint = undefined;
}

/@
"Name: enable_damagefeedback()"
"Summary: Enable damage feedback that draws a crosshair when player hits NPC."
"Module: Utility"
"Example: enable_damagefeedback();"
"SPMP: singleplayer"
@/
enable_damagefeedback()
{
	SetDvar( "scr_damagefeedback", "1" );
}

/@
"Name: disable_damagefeedback()"
"Summary: Disable damage feedback that draws a crosshair when player hits NPC."
"Module: Utility"
"Example: disable_damagefeedback();"
"SPMP: singleplayer"
@/
disable_damagefeedback()
{
	SetDvar( "scr_damagefeedback", "0" );
}


// We might need this specically for Spec Ops, hence not deleting it.

/@
"Name: enable_heat_behavior( <shoot_while_moving> )"
"Summary: Enables heat behavior"
"Module: AI"
"CallOn: An AI"
"OptionalArg: <shoot_while_moving>: do regular AI shoot behavior while moving. Defaults to false"
"Example: guy enable_heat_behavior();"
"SPMP: singleplayer"
@/
enable_heat_behavior( shoot_while_moving )
{
	/*	self.heat = true;
	self.no_pistol_switch = true;
	self.useCombatScriptAtCover = true;

	if ( !isdefined( shoot_while_moving ) || !shoot_while_moving )
	{
	self.dontshootwhilemoving = true;
	self.maxfaceenemydist = 64;
	self.pathenemylookahead = 2048;
	self disable_surprise();
	}

	self.specialReloadAnimFunc = animscripts\animset::heat_reload_anim;

	self.customMoveAnimSet[ "run" ] = anim.animsets.move[ "heat_run" ];
	*/	
}


/@
"Name: disable_heat_behavior()"
"Summary: Disables heat behavior"
"Module: AI"
"CallOn: An AI"
"Example: guy disable_heat_behavior();"
"SPMP: singleplayer"
@/
disable_heat_behavior()
{
	/*	self.heat = undefined;
	self.no_pistol_switch = undefined;
	self.dontshootwhilemoving = undefined;
	self.useCombatScriptAtCover = false;
	self.maxfaceenemydist = 512;
	self.specialReloadAnimFunc = undefined;

	self.customMoveAnimSet = undefined;
	*/	
}

/@
"Name: set_baseaccuracy( <val> )"
"Summary: "
"Module: Entity"
"CallOn: An entity"
"MandatoryArg: <param1>: "
"OptionalArg: <param2>: "
"Example: "
"SPMP: singleplayer"
@/
set_baseaccuracy( val )
{
	self.baseaccuracy = val;
}

// ==========================================================================
// ALLY LOGIC
// ==========================================================================

spawn_allies( target_origin, ally_manifest, owner, waitTime )
{
	level endon( "special_op_terminated" );
	
	assert( isdefined( owner ), 		"allies' owner parameter is missing" );
	assert( isdefined( target_origin ), "Invalid target origin" );
	assert( isdefined( ally_manifest ) && ally_manifest.size > 0, 	"Invalid or empty ally_manifest" );

	if( IsDefined(waitTime) )
		wait(waitTime);

	path_start = chopper_wait_for_closest_open_path_start( target_origin, "drop_path_start", "script_unload" );

	// AP_TODO: this needs to be fixed to work properly with sounds
	level notify( "so_airsupport_incoming", ally_manifest[0] );

	maps\_so_war_ai::spawn_ally_team( ally_manifest, path_start, owner );
	
	flag_set( "allies_spawned" );
}

spawn_allies_quietly( ally_manifest )
{
	level endon( "special_op_terminated" );
	
	assert( isdefined( ally_manifest ) && ally_manifest.size > 0, 	"Invalid or empty ally_manifest" );
	
	ally_starts = GetNodeArray( "ally_ladder_start", "script_noteworthy" );
	assert( ally_starts.size >= ally_manifest.size, "Must have enough ladders for all your allies" );

	ally_team = [];	
	
	for( i=0; i < ally_manifest.size; i++ )
	{
		ally_ref = ally_manifest[ i ];
			
		ally_spawner = get_spawners_by_targetname( ally_ref )[ 0 ];
		assert( isdefined( ally_spawner ), "No ally spawner with targetname: " + ally_ref );
		
		if ( !isdefined( ally_spawner ) )
			return ally_team;
		
		ally_spawner.count = 1; // make sure count > 0
		
		new_guy = simple_spawn_single( ally_spawner );
		assert(new_guy.team =="allies", "Spawning an enemy via an ally utility");
		
		ally_team[ ally_team.size ] = new_guy;
		
		new_guy thread maps\_so_war_ai::ally_setup( ally_spawner, "reached_path_end" );
		
		node = ally_starts[ i ];
		
		nodeForward = AnglesToForward( node.angles );
		new_guy forceteleport( node.origin + VectorScale( nodeForward, -20 ), node.angles );
		
		new_guy thread maps\_spawner::go_to_node( node );
		wait( RandomFloatRange( 0.75, 1.5 ) );//delay so that friendly can clear spawn loc and path without running into aother friendly.
	}
	
	flag_set( "allies_spawned" );
	
	return ally_team;
}

spawn_allies_on_boat( boat, ally_manifest, waitTime )
{
	level endon( "special_op_terminated" );
	
	assert( isdefined( boat ), 										"boat parameter is missing" );
	assert( isdefined( ally_manifest ) && ally_manifest.size > 0, 	"Invalid or empty ally_manifest" );
	
	boatSitTags = array( "tag_driver", "tag_guy2", "tag_passenger" );
	
	assert( ally_manifest.size <= boatSitTags.size,					"Boat can only support up to 3 passengers" );

	if( IsDefined(waitTime) )
		wait(waitTime);
	
	ally_team = [];

	for( i=0; i < ally_manifest.size; i++ )
	{
		ally_ref = ally_manifest[ i ];
			
		ally_spawner = get_spawners_by_targetname( ally_ref )[ 0 ];
		assert( isdefined( ally_spawner ), "No ally spawner with targetname: " + ally_ref );
		
		if ( !isdefined( ally_spawner ) )
			return ally_team;
		
		ally_spawner.count = 1; // make sure count > 0
		
		// spawn the dude
		new_guy = simple_spawn_single( ally_spawner );
		assert(new_guy.team =="allies", "Spawning an enemy via an ally utility");
		
		ally_team[ ally_team.size ] = new_guy;
		
		// set all the war attributes and threads in motion
		new_guy thread maps\_so_war_ai::ally_setup( ally_spawner, "unloaded" );
		
		// sit him on a tag		
		sitTagOrigin = boat GetTagOrigin( boatSitTags[i] );
		sitTagAngles = boat GetTagAngles( boatSitTags[i] );
		
		new_guy forceteleport( sitTagOrigin, sitTagAngles );
		new_guy LinkTo( boat, boatSitTags[i] );
	}
	
	flag_set( "allies_spawned" );
	
	return ally_team;
}


watchWeaponChange()
{
	self endon("death");
	self endon("disconnect");
	
	self.lastDroppableWeapon = self GetCurrentWeapon();
	while(1)
	{
		self waittill( "weapon_change", newWeapon );
		
		if ( mayDropWeapon( newWeapon ) )
		{
			self.lastDroppableWeapon = newWeapon;
		}
	}
}

mayDropWeapon( weapon )
{
	if ( GetDvarint( "scr_disable_weapondrop" ) == 1 )
		return false;
		
	if ( weapon == "none" )
		return false;
		
	if ( maps\sp_killstreaks\_killstreaks::isKillstreakWeapon( weapon ) )
		return false;
	
	invType = WeaponInventoryType( weapon );
	if ( invType != "primary" )
		return false;
	
	return true;
}

give_loadout( playerClass )
{
	self endon( "death" );
	
	// load out stuff
	self takeallweapons();
	self maps\sp_killstreaks\_killstreaks::takeAllKillstreaks();
	self maps\_perks_sp::take_all_perks();
	
	if( !IsDefined(playerClass) )
	{
		playerClass = maps\_so_war_classes::get_class_struct( "player" );
		assert( IsDefined(playerClass), "Must have a player class defined in the loadout table" );
	}
			
	self give_player_weapons( playerClass );	
	self give_player_grenades( playerClass );
	self give_player_armor( playerClass );
	
	// because giving equipments perks etc call setplayerdata which requires a delay
	wait 0.05;
	
	self give_player_equipment( playerClass );
	self give_player_perks( playerClass );
	self give_player_killstreaks( playerClass );
}

give_player_weapons( playerClass )
{
	for( i=0; i < playerClass.weapons.size; i++ )
	{
		weapon 	= playerClass.weapons[i];
		
		self giveweapon( weapon );
		
		// override last stand pistol weapon
		weapon_class = weaponclass( weapon );
		assert( isdefined( weapon_class ) );
		if ( weapon_class == "pistol" )
			level.coop_incap_weapon = weapon;
		
		ammo 	= ( IsDefined( playerClass.weapon_ammo[i] ) ? playerClass.weapon_ammo[i] : "max");
		if ( !IsInt(ammo) && ammo == "max" )
			self setweaponammostock( weapon, weaponmaxammo( weapon ) );
		else
			self setweaponammostock( weapon, int( ammo ) );
		
		// weapon slot 1 is default switched to weapon
		if ( i == 0 )
			self switchToWeapon( weapon );
	}
	
	// always has a melee weapon
	self giveweapon( "knife_sp" );
}

give_player_grenades( playerClass )
{
	for( i=0; i < playerClass.grenades.size; i++ )
	{
		grenade 	= playerClass.grenades[i];
		
		self giveweapon( grenade );
		
		ammo 	= ( IsDefined( playerClass.grenade_ammo[i] ) ? playerClass.grenade_ammo[i] : "max" );
		if ( !IsInt(ammo) && ammo == "max" )
			self setweaponammoclip( grenade, weaponmaxammo( grenade ) );
		else
			self setweaponammoclip( grenade, int( ammo ) );
		
		// set flash if got it
		if ( grenade == "flash_grenade_sp" )
			self setOffhandSecondaryClass( "flash" );
		else if( grenade == "claymore_sp" )
			self SetActionSlot( 1, "weapon", grenade );
	}
}

give_player_armor( playerClass )
{
	armor_points 	= playerClass.armor;
	
	if ( armor_points != "" )
	{
		self maps\_so_war_support::give_armor_amount( "armor", int(armor_points) );
	}	
}

give_player_equipment( playerClass )
{
	foreach( equipment in playerClass.equipment )
	{
		switch (equipment)
		{
			case "":
				break;
			case "laststand":
				self maps\_laststand::update_lives_remaining( true );
				break;
			case "ally_drop":
				self maps\_so_war_support::give_friendlies();
				break;
			default:
				if ( maps\sp_killstreaks\_killstreaks::isKillstreakRegistered(equipment))
					self maps\sp_killstreaks\_killstreaks::giveKillstreak( equipment );
				break;
					
		}
	}
}

give_player_killstreaks( playerClass )
{
	foreach( killstreak in playerClass.killstreaks )
	{
		if( maps\sp_killstreaks\_killstreaks::isKillstreakRegistered( killstreak ) )
			self maps\sp_killstreaks\_killstreaks::giveKillstreak( killstreak );
	}
}

give_player_perks( playerClass )
{
	foreach( perk in playerClass.perks )
	{
		self thread maps\_perks_sp::give_perk( perk );
	}
}

// Slam Zoom Test
// ==========================================================================
do_slamzoom( followEnt )
{
	flag_clear( "slamzoom_finished" );
	
	// disable controls
	self DisableWeapons();
	self DisableOffhandWeapons();
	self FreezeControls( true );
	self EnableInvulnerability(); // so the player doesn't get killed by the hurt trigger in mp maps
	self.ignoreme = true;

	// we reset model and detached all from player for slamzoom but they will be restored by 
	// updatemodel() thread the moment player weapon has changed, 
	// which happens at the correct time when they are done with slamzoom and readys up
	if ( isdefined( self.last_modelfunc ) )
	{
		self detachall();
		self setmodel( "" );
	}
	
	// tweakables
	travel_time		= 1.75;
	zoomHeight 		= 16000;
	
	// setup player origin
	origin = self.origin;
	angles = self.angles;
	
	// a potentially moving ent
	if( IsDefined(followEnt) )
	{
		origin = followEnt.origin + (0,0,60); // + player view offset
		angles = followEnt.angles;
	}
	
	hint = createstreamerhint(origin, 0.333);
	self.origin = origin + ( 0, 0, zoomHeight );
	
	// create rig to link player view to
	ent = Spawn( "script_model", ( 69, 69, 69 ) );
	ent SetModel( "tag_origin" );
	ent.origin = self.origin;
	ent.angles = angles;
	
	// link player
	self PlayerLinkTo( ent, undefined, 1, 0, 0, 0, 0 );
	ent.angles = ( ent.angles[ 0 ] + 89, ent.angles[ 1 ], 0 );
	
	ent MoveTo( origin + ( 0, 0, 0 ), travel_time, 0, travel_time );
	
	// delay so sound would play
	wait 0.05;
	
	// SHUUUUUU
	self PlaySound( "war_slamzoom_out" );
	
	delay_thread( travel_time - 0.55, ::slamzoom_rotate_utility, ent );
	
	// actual slamming
	while( travel_time > 0 )
	{
		wait(0.05);
		travel_time -= 0.05;
		
		if( travel_time > 0 && IsDefined(followEnt) && DistanceSquared( origin, followEnt.origin ) > 32*32 )
		{
			ent MoveTo( followEnt.origin + ( 0, 0, 60 ), travel_time, 0, travel_time );
		}
	}
	
	// breif overbrightness
//	self VisionSetNakedForPlayer( "coup_sunblind", 0.25 );
	
	// restore player controls
	self Unlink();
	self EnableWeapons();
	self EnableOffhandWeapons();
	self FreezeControls( false );
	self DisableInvulnerability();
	self.ignoreme = false;
	hint Delete();
	
	// this is to make sure player model is setup correctly after slamzoom is done
	self notify( "player_update_model" );
	flag_set( "slamzoom_finished" );
	
	wait 0.05;

	ent Delete();
}

slamzoom_rotate_utility( ent )
{
	// orient to player view
	ent RotateTo( ( ent.angles[ 0 ] - 89, ent.angles[ 1 ], 0 ), 0.5, 0.3, 0.2 );
}

// Force the player to a specific class
// ==========================================================================
// i.e. player force_ally_switch_toType("friendly_sniper");
force_ally_switch_toType(spawnerTargetName)//self == player
{
	allies = GetAIArray("allies");
	foreach (ally in allies)
	{
		if (ally == self)
			continue;
			
		if ( isDefined(ally.spawner) && ally.spawner.targetname == spawnerTargetName )
		{
			self thread do_ally_switch(ally,true,false);
			return;
		}
	}
}

// ==========================================================================
do_ally_switch( toAi, replace, onDeath )
{
	assert( IsAlive(toAi) );

	level notify("war_char_switch",self);
	self notify("war_char_switch");
	
	//incase the player is in the middle of a capture, preserve these variables (other threads will clear)
	CaptureOrigin	 	= self.CaptureOrigin;
	CaptureAngles	 	= self.CaptureAngles;
	CaptureEnt		 	= self.CaptureEnt;
	CaptureObj			= self.CaptureObj;
	CaptureObjNum		= self.CaptureObjNum;
	self Unlink();

	// set player settings based on the AI being swapped into
	self maps\_so_war_classes::update_player_classtype();
	
	// make sure he doesn't die in the meantime
	toAi magic_bullet_shield();
		
	// disable controls
	self DisableWeapons();
	self DisableOffhandWeapons();
	self FreezeControls( true );
	self EnableInvulnerability(); // so the player doesn't get killed by the hurt trigger in mp maps
	self.ignoreme = true;
	
	// stop stealth and force invisible
	self.maxvisibledist = 1;
	self notify( "_stealth_stop_stealth_logic" );
	self._stealth = undefined;
	
	// setup player origin
	hint = createstreamerhint( toAi.origin, 0.333 );
	maps\_so_war_support::turn_off_ally_cam();

	if( is_true(onDeath) )
	{
		// fake death effects
		self SetStance( "prone" );
		self SetBlur( 5, 0.5 );
		wait 1;
	}
	else
	{
		wait(0.5);
	}
	
	self SetClientFlag( level.CLIENT_FLAG_ALLY_SWITCH );

	// we reset model and detached all from player for slamzoom but they will be restored by 
	// updatemodel() thread the moment player weapon has changed, 
	// which happens at the correct time when they are done with slamzoom and readys up
	if ( isdefined( self.last_modelfunc ) )
	{
		self detachall();
		self setmodel( "" );
	}
	
	self PlaySound( "war_slamzoom_out" );// SHUUUUUU

	wait( 1 );

	// spawn the new guy (has to go before take_on_ally_class)
	if( is_true(replace) )
	{
		so = undefined;
		if ( isDefined(CaptureEnt) )
		{
			so = spawnstruct();
			so.type		   = "spawn_thread_on_ent";
			so.cb		   = maps\_so_war_gametypes::war_capture_logicAI;
			so.ent		   = CaptureEnt;
			so.param1	   = CaptureObj;
			so.param2	   = CaptureObjNum;
			so.param3	   = "tag_origin";
		}
		
		self thread maps\_so_war_classes::spawn_replacement_ally( self.origin, self.angles, self GetStance(), so );
	}
	
	self SetStance( toAi.a.pose );

	self SetBlur( 0, 0.5 );
	self SetPlayerAngles( toAi.angles );
	self SetOrigin( toAi.origin );
	self SetStance( toAi.a.pose );
	
	// set player settings based on the AI being swapped into
	self thread maps\_so_war_classes::take_on_ally_class( toAi );
	
	// delete the AI
	toAi Delete();
	
	// restore player controls
	self EnableWeapons();
	self EnableOffhandWeapons();
	self FreezeControls( false );
	self DisableInvulnerability();
	self.ignoreme = false;
	
	// don't want to start stealth right away, because the stance may not be correct yet
	// which will cause the maxvisibledist to be too high and get him noticed
	delay_thread( 1.0, ::resume_player_stealth, self );
	
	hint Delete();
	
	self notify( "player_update_model" );
	wait 0.5;
	self ClearClientFlag(level.CLIENT_FLAG_ALLY_SWITCH);
	level notify("war_char_switch_complete");
	self notify("war_char_switch_complete");	
}

resume_player_stealth( player )
{
	if( IsDefined( player ) )
	{
		// resume stealth, if necessary
		if( level flag_exists( "_stealth_hidden" ) && level flag( "_stealth_hidden" ) )
		{
			player thread maps\_stealth_logic::stealth_ai_logic();
		}
		else
		{
			player.maxVisibleDist = 8192;
		}
	}
}

// ==========================================================================
get_generic_ally_manifest()
{	
	// generate the AI types that will rappel down
	ally_manifest = array( "friendly_sniper", "friendly_heavy", "friendly_assault" );
	//ally_manifest = array_randomize( ally_manifest );
	
	// take only the squad members that we need
	temp_array = [];
	for( i=0; i < level.so.ally_squad_size && i < ally_manifest.size; i++ )
	{
		temp_array[ temp_array.size ] = ally_manifest[i];
	}
	ally_manifest = temp_array;
	
	return ally_manifest;
}

// ==========================================================================
insert_allies_by_ladder()
{
	level endon( "special_op_terminated" );
	
	ally_manifest = get_generic_ally_manifest();

	level thread spawn_allies_quietly( ally_manifest );
}

// ==========================================================================
insert_allies_by_heli()
{
	level endon( "special_op_terminated" );
	
	ally_manifest = get_generic_ally_manifest();

	level thread spawn_allies( get_players()[0].origin + (0,0,1000), ally_manifest, self, 0.0 );
}

war_zodiac_player_insert()
{
	assert( !flag("start_war") );
	
	zodiac = spawn_vehicle_from_targetname( "ally_dropoff_boat" );
	assert( isdefined( zodiac ), "zodiac failed to spawn." );
	
	path_start = GetVehicleNode( "zodiac_path_start", "targetname");
	assert( IsDefined( path_start ), "no zodiac path start found" );
	
	zodiac.origin = path_start.origin;
	zodiac.angles = path_start.angles;
	zodiac thread go_path( path_start );
		
	// spawn the passengers
	ally_manifest = get_generic_ally_manifest();
	ally_team = spawn_allies_on_boat( zodiac, ally_manifest );
	
	// slamzoom the player down to the boat
	player = GetPlayers()[0];
	
	playerPos = zodiac GetTagOrigin( "tag_player" );
	playerAngles = zodiac GetTagAngles( "tag_player" );
	
	followEnt = Spawn( "script_origin", playerPos );
	followEnt.angles = playerAngles;
	followEnt LinkTo( zodiac, "tag_player" );
		
	player thread maps\_so_war_support::do_slamzoom( followEnt );
		
	flag_wait( "slamzoom_finished" );
	
	followEnt Delete();
	
	player PlayerLinkTo( zodiac, "tag_player", 0, 60, 60, 40, 40 );
	
	player DisableWeapons();
	player DisableOffhandWeapons();
	
	// ride the zodiac
	zodiac waittill( "reached_end_node" );
	
	// unload the player via animation eventually
	player Unlink();
	
	player EnableWeapons();
	player EnableOffhandWeapons();
	
	// will also need animation for this at some point
	ally_starts = GetNodeArray( "ally_ladder_start", "script_noteworthy" );
	assert( ally_starts.size >= ally_manifest.size, "Must have enough ladders for all your allies" );
	
	for( i=0; i < ally_team.size; i++ )
	{
		guy = ally_team[i];		
		guy Unlink();
		
		// go straight to the end of the ladded traversal
		start_node = GetNode( ally_starts[i].target, "targetname" );
		
		//guy MoveTo( start_node.origin, 2, 0.5, 0.5 );
		//guy RotateTo( start_node.angles, 2, 0.5, 0.5 );
		
		guy ForceTeleport( start_node.origin, start_node.angles );
		guy notify( "unloaded" );
		
		guy thread maps\_spawner::go_to_node( start_node );
		
		wait( RandomFloatRange( 0.1, 0.5 ) );
	}

	level notify("zodiac_player_insert_done");
}

// ==========================================================================
// VEHICLE FUNCTIONS
// ==========================================================================

// This is all wrapped up in one function so that as soon as a chopper is
// needed the desired path is flagged as in use.
chopper_spawn_from_targetname_and_drive( name, spawn_origin, path_start, team )
{
	msg = "passed start struct without targetname: " + name;
	assert( !isdefined( path_start.in_use ), "helicopter told to use path that is in use." );
	
	// Must happen first since chopper_spawn() functions could 
	// potentially wait for the spawner to be free
	path_start.in_use = true;
	
	chopper = chopper_spawn_from_targetname( name, spawn_origin, team );
	chopper.loc_current = path_start;
	
	//chopper thread vehicle_paths( path_start );
	chopper thread go_path( path_start );

	return chopper;
}

chopper_spawn_from_targetname( name, spawn_origin, team )
{
	chopper_spawner = maps\_vehicle::getspawners_by_targetname( name )[0];
	assert( isdefined( chopper_spawner ), "Invalid chopper spawner targetname: " + name );
	
	// set health if defined in string table
	/*
	set_health = maps\_so_war_ai::get_ai_health( name );
	if ( isdefined( set_health ) )
		chopper_spawner.script_startinghealth = set_health;
	*/
	
	while ( isdefined( chopper_spawner.vehicle_spawned_thisframe ) )
		wait 0.05;
		
	if ( isdefined( spawn_origin ) )
		chopper_spawner.origin = spawn_origin;

	chopper = spawn_vehicle_from_targetname( name );
	assert( isdefined( chopper ), "chopper failed to spawn." );
	
	if( team == "axis" )
		Target_Set( chopper );
		
	return chopper;
}

// pilot is a drone
chopper_spawn_pilot_from_targetname( name, position )
{
	all_spawners = getspawnerarray();
	spawner = undefined;
	foreach ( spawner in all_spawners )
		if ( isdefined( spawner.targetname ) && spawner.targetname == name )
			break;
			
	assert( isdefined( spawner ), "no spawner with targetname of: " + name );
	
	pilot = self chopper_spawn_passenger( spawner, position, true );
	
	// Pilot should not die, magic_bullet_shield is not an option because
	// vehicle scripts assert when dying with a magically shielded passenger
	pilot.health = 9999;
	
	return pilot;
}

chopper_spawn_passenger( spawner, position, drone )
{
	passenger = undefined;
	while( 1 )
	{
		spawner.count = 1;
		if ( isdefined( drone ) && drone )
		{
			passenger = dronespawn( spawner );
			break;
		}
		else
		{
			passenger = spawner spawn_ai( true );
		
			if ( !spawn_failed( passenger ) )
				break;
		}
		
		wait 0.5;
	}
	
	if ( isdefined( position ) )
		passenger.forced_startingposition = position;
	
	self enter_vehicle( passenger );
	
	return passenger;
}

chopper_drop_smoke_at_unloading()
{
	self endon( "death" );

	self waittill_either( "unloading", "unload" );

	rappel_left_origin = self GetTagOrigin("tag_fastrope_le");
	if( !IsDefined( rappel_left_origin ) )
	{
		rappel_left_origin = self GetTagOrigin("tag_enter_gunner");
		assert( IsDefined(rappel_left_origin), "Heli has no rappel tags" );
	}
	
	groundposition = GROUNDPOS(self, rappel_left_origin );
	self magicgrenadetype( "willy_pete_sp", groundposition, ( 0, 0, -1 ), 0 );
}

chopper_wait_for_closest_open_path_start( target_origin, start_name, struct_string_field )
{
	path_start = undefined;
	while ( 1 )
	{
		path_start = chopper_closest_open_path_start( target_origin, start_name, struct_string_field );
		if ( isdefined( path_start ) )
			break;
			
		wait 0.25;
	}
	
	return path_start;
}

// returns the start struct of the helicopter path containing the
// closest struct with the specified struct_string_field that is
// not currently in use
chopper_closest_open_path_start( target_origin, start_name, struct_string_field )
{
	path_starts = GetVehicleNodeArray( start_name, "targetname" );
	assert( path_starts.size, "No heli path nodes with targetname: " + start_name );
	
	closest_path_start = undefined;
	closest_path_start_dist = undefined;
	closest_path_drop = undefined;
	
	foreach ( path_start in path_starts )
	{
		if ( isdefined( path_start.in_use ) )
			continue;
		
		path_drop = path_start;
		found_path = false;
		
		switch ( struct_string_field )
		{
			case "script_unload":
			{
				while ( !isdefined( path_drop.script_unload ) )
					path_drop = GetVehicleNode( path_drop.target, "targetname" );
					
				assert( isdefined( path_drop.script_unload ), "Level has a helicopter path without a struct with script_unload defined." );
				if ( !isdefined( path_drop.script_unload ) )
					continue;
				
				found_path = true;
					
				break;
			}
				
			case "script_stopnode":
			{
				while ( !isdefined( path_drop.script_stopnode ) )
					path_drop = GetVehicleNode( path_drop.target, "targetname" );
					
				assert( isdefined( path_drop.script_stopnode ), "Level has a helicopter path without a struct with script_stopnode defined." );
				if ( !isdefined( path_drop.script_stopnode ) )
					continue;
				
				found_path = true;
					
				break;
			}
				
			// look for script_noteworthy match
			default:
			{
				while ( isdefined( path_drop.target ) && ( !isdefined( path_drop.script_noteworthy ) || path_drop.script_noteworthy != struct_string_field ) )
					path_drop = GetVehicleNode( path_drop.target, "targetname" );
					
				// reject this path if it's the last node
				if ( !isdefined( path_drop.target ) )
					continue;
				
				found_path = true;
					
				// accept path
				break;
			}
		}
		
		assert( found_path, "No heli path found with a kvp matching: " + struct_string_field );
		
		if ( !isdefined( closest_path_drop ) )
		{
			closest_path_drop = path_drop;
			closest_path_start_dist = distance2d( target_origin, path_drop.origin );
			closest_path_start = path_start;
		}
		else
		{
			path_drop_dist = distance2d( target_origin, path_drop.origin );
			if ( path_drop_dist < closest_path_start_dist )
			{
				closest_path_drop = path_drop;
				closest_path_start_dist = distance2d( target_origin, closest_path_drop.origin );
				closest_path_start = path_start;
			}
		}	
	}
	
	return closest_path_start;	
}


so_kill_ai( attacker, dmg_type, weapon_type )
{
	assert( IsDefined( self ), "kill AI must have defined self." );
	assert( IsAlive( self ), "kill AI called on already dead actor." );
	assert( IsAI( self ), "kill AI called on non AI." );
	assert( !IsDefined( self.magic_bullet_shield ), "kill AI called on AI with magic_bullet_shield." );
	
	if ( IsDefined( attacker ) )
	{
		if ( IsDefined( dmg_type ) && IsDefined( weapon_type ) )
		{
			// Need to make sure script waiting for this AI to die get
			// the passed damage type and weapon type so notify death
			// with these parameters and then kill the AI.
			self notify( "death", attacker, dmg_type, weapon_type );
			
			// Notify death does not kill the AI so make sure he's
			// actually dead for any function waiting on death or
			// using getaiarray() to see who is alive
			self kill();
		}
		else
		{
			self kill(attacker.origin, attacker );	
		}
	}
	else
	{
		self kill();
	}	
}

turn_on_ally_cam( ally, player )
{
	assert( IsDefined(ally) );
	if (!isDefined(level.extra_cam_window))
	{
		level.extra_cam_window = newClientHudElem( player );
		level.extra_cam_window.x = 3;
		level.extra_cam_window.y = -150;
		level.extra_cam_window.height = 100;
		level.extra_cam_window.width = 102;
		level.extra_cam_window.alignX = "left";
		level.extra_cam_window.alignY = "middle";
		level.extra_cam_window.horzAlign = "left";
		level.extra_cam_window.vertAlign = "middle";
		level.extra_cam_window setshader( "extracam2d_clean", 100, 102 );
		level.extra_cam_window.alpha = 1;
	}
	if ( !isDefined(level.extra_cam_title ))
	{
		level.extra_cam_title = newClientHudElem( player );
		level.extra_cam_title.x = 00;
		level.extra_cam_title.y = -85;
		level.extra_cam_title.alignX = "left";
		level.extra_cam_title.alignY = "middle";
		level.extra_cam_title.horzAlign = "left";
		level.extra_cam_title.vertAlign = "middle";
		level.extra_cam_title.fontScale = 1.5;
		level.extra_cam_title.alpha = 1;
	}

	
	ally_cam_ent = GetEnt("ally_cam", "targetname");
	ally_cam_ent.origin = ally GetTagOrigin( "j_helmet" );
	ally_cam_ent.angles = ally GetTagAngles( "j_helmet" );
	
	eyeForward = AnglesToForward( ally_cam_ent.angles );
	ally_cam_ent.origin += VectorScale( eyeForward, 5 );
	ally_cam_ent LinkTo( ally, "j_helmet" );
	ally_cam_ent SetClientFlag( level.CLIENT_FLAG_ALLY_EXTRA_CAM );
	ai_type = get_ai_struct( ally.spawner.targetname );
	
	level.extra_cam_title SetText( ai_type.name );
	
	SetDvar("ui_hideminimap","1");
}

turn_off_ally_cam(player)
{
	ally_cam_ent = GetEnt("ally_cam", "targetname");
	ally_cam_ent ClearClientFlag( level.CLIENT_FLAG_ALLY_EXTRA_CAM );
	
	if (isDefined(level.extra_cam_window))
	{
		level.extra_cam_window maps\_hud_util::destroyElem();
		level.extra_cam_window = undefined;
	}
	if (isDefined(level.extra_cam_title))
	{
		level.extra_cam_title maps\_hud_util::destroyElem();
		level.extra_cam_title = undefined;
	}
	SetDvar("ui_hideminimap","0");
}


// This function returns the count of dogs currently alive
// as well as any dog that is currently getting spawned
// this frame. This is to handle the frame delay that happens
// when spawn_ai() is called in the threaded spawn_dogs() func
dog_get_count()
{
	dog_count = dog_get_living().size;
	
	if ( isdefined( level.war_dog_spawning ) )
		dog_count++;
	
	return dog_count;
}

// Returns all living dogs not including a dog that
// has spawned but is in spawn_failed() phase of
// spawn_ai()
dog_get_living()
{
	if ( !isdefined( level.dogs ) )
	{
		level.dogs = [];
		return level.dogs;
	}
	
	dog_array = [];
	foreach( dog in level.dogs )
	{
		if ( isdefined( dog ) && isalive( dog ) )
			dog_array[ dog_array.size ] = dog;
	}
	
	return dog_array;	
}

get_total_enemies()
{
	// wait till a few AIs left, we then have the remaining aggress
	return getaiarray( "axis" ).size + dog_get_count();
}
	

/#
debugLine(fromPoint, toPoint, color, durationFrames)
{
	for (i=0;i<durationFrames*20;i++)
	{
		line (fromPoint, toPoint, color);
		wait (0.05);
	}
}


drawcylinder( pos, rad, height )
{

	currad = rad; 
	curheight = height; 

	for( r = 0; r < 20; r++ )
	{
		theta = r / 20 * 360; 
		theta2 = ( r + 1 ) / 20 * 360; 

		line( pos +( cos( theta ) * currad, sin( theta ) * currad, 0 ), pos +( cos( theta2 ) * currad, sin( theta2 ) * currad, 0 ) ); 
		line( pos +( cos( theta ) * currad, sin( theta ) * currad, curheight ), pos +( cos( theta2 ) * currad, sin( theta2 ) * currad, curheight ) ); 
		line( pos +( cos( theta ) * currad, sin( theta ) * currad, 0 ), pos +( cos( theta ) * currad, sin( theta ) * currad, curheight ) ); 
	}

}

debug_sphere( origin, radius, color, alpha, time )
{

	if ( !IsDefined(time) )
	{
		time = 1000;
	}
	if ( !IsDefined(color) )
	{
		color = (1,1,1);
	}
	
	sides = Int(10 * ( 1 + Int(radius) % 100 ));
	sphere( origin, radius, color, alpha, true, sides, time );

}

debug_draw_goalpos(center,color)
{

	self endon("death");
	self notify("draw_goalpos");
	self endon("draw_goalpos");
	while(1)
	{
	
		if (isDefined(self.special_node) )
		{
			debug_sphere( self.special_node.origin, 32, (.7,0,1), 0.5, 1 );
			line (self.origin, self.special_node.origin, (0,0,1));
			drawnode(self.special_node);
		}
		else
		{
			line (self.origin, center, color);	
			if(isDefined(self.node))
			{
				line (self.origin, self.node.origin, (0,0,1));
				drawnode(self.node);
			}
			
			debug_sphere( center, 32, color, 0.5, 1 );
		}
		wait 0.05;
	}
	
}
#/



special_item_hudelem( pos_x, pos_y, hide )
{
	elem 				= NewClientHudElem( self );
	elem.hidden 		= (isDefined(hide)?true:false);
	elem.elemType 		= "icon";
	elem.hideWhenInMenu = true;
	elem.archived 		= false;
	elem.x 				= pos_x;
	elem.y 				= pos_y;
	elem.alignx 		= "center";
	elem.aligny 		= "middle";
	elem.horzAlign 		= "center";
	elem.vertAlign 		= "middle";
	elem.hidden			= false;
	
	return elem;
}

// ==========================================================================
// Intermission countdown timer using MP Style
// DIRECT COPY/PASE with minor removal of MP only stuff - 5/3/2011

matchStartTimer( duration )
{
	matchStartTimer = self creatCountDownHudElem( "big", 2.5 );
	matchStartTimer setPoint( "CENTER", "CENTER", 0, 0 );
	matchStartTimer.sort = 1001;
	//matchStartTimer.color = (1,1,0);
	
	matchStartTimer.glowColor = ( 0.15, 0.35, 0.85 );
	matchStartTimer.color	= ( 0.95, 0.95, 0.95 );
	
	matchStartTimer.foreground = false;
	matchStartTimer.hidewheninmenu = true;
	matchStartTimer fontPulseInit();
	
	matchStartTimer_Internal( int( duration ), matchStartTimer );
	
	matchStartTimer destroy();
}

fontPulseInit( maxFontScale )
{
	self.baseFontScale = self.fontScale;
	if ( isDefined( maxFontScale ) )
		self.maxFontScale = min( maxFontScale, 6.3 );
	else
		self.maxFontScale = min( self.fontScale * 2, 6.3 );
	self.inFrames = 2;
	self.outFrames = 4;
}

creatCountDownHudElem( font, fontScale )
{
	fontElem = NewClientHudElem( self );
	
	fontElem.elemType = "font";
	fontElem.font = "big";
	fontElem.fontscale = fontScale;
	fontElem.baseFontScale = fontScale;
	fontElem.x = 0;
	fontElem.y = 0;
	fontElem.width = 0;
	fontElem.height = int(level.fontHeight * fontScale);
	fontElem.xOffset = 0;
	fontElem.yOffset = 0;
	fontElem.children = [];
	fontElem setParent( level.uiParent );
	fontElem.hidden = false;
	
	return fontElem;
}

matchStartTimer_Internal( countTime, matchStartTimer )
{
	while ( countTime > 0 )
	{
		if ( countTime > 99 )
			matchStartTimer.alpha = 0;
		else
			matchStartTimer.alpha = 1;
		
		foreach( player in level.players )
			player PlaySound( "so_countdown_beep" );
		
		matchStartTimer thread fontPulse();
		wait ( matchStartTimer.inFrames * 0.05 );
		matchStartTimer setValue( countTime );
		countTime--;
		wait ( 1 - (matchStartTimer.inFrames * 0.05) );
	}
}

fontPulse()
{
	self notify ( "fontPulse" );
	self endon ( "fontPulse" );
	self endon( "death" );
	
	self ChangeFontScaleOverTime( self.inFrames * 0.05 );
	self.fontScale = self.maxFontScale;	
	wait self.inFrames * 0.05;
	
	self ChangeFontScaleOverTime( self.outFrames * 0.05 );
	self.fontScale = self.baseFontScale;
}

missionCompleteMsg(success)
{
	//default game over handler.
	game_over_msg 					= NewHudElem();
	game_over_msg.alignX 			= "center";
	game_over_msg.alignY 			= "middle";
	game_over_msg.horzAlign			= "center";
	game_over_msg.vertAlign			= "middle";
	game_over_msg.y 	 	   	   -= 130;
	game_over_msg.foreground 		= true;
	game_over_msg.fontScale 		= 4;
	game_over_msg.color 			= ( 1.0, 0.0, 0.0 );
	game_over_msg.hidewheninmenu	= false;
	game_over_msg.alpha 			= 0;
	if (success)
	{
		game_over_msg SetText( &"SO_WAR_MISSION_SUCCESS" );
	}
	else
	{
		game_over_msg SetText( &"SO_WAR_MISSION_FAILED" );
	}
	game_over_msg FadeOverTime( 1 );
	game_over_msg.alpha 			= 1;
	
	wait 10;
	game_over_msg FadeOverTime( 1 );
	game_over_msg.alpha 			= 0;
	game_over_msg	maps\_hud_util::destroyElem();
}

war_create_trigger_use(origin,radius,hintString,endNote,activeNote,entToNotify)
{
	trigger = spawn("trigger_radius", origin ,0, radius, 64);
	trigger thread war_trigger_use(hintString,endNote,activeNote,entToNotify);
	return trigger;
}

war_trigger_use(hintString,endNote,activeNote,entToNotify)
{
	self endon("delete");
	self endon("death");
	if ( isDefined(endNote) )
	{
		self endon(endNote);
	}
	self SetCursorHint( "HINT_NOICON" );
	while(1)
	{
		self SetHintString( "");
		self waittill("trigger",who);
		if (!isPlayer(who))
			continue;

		self SetHintString( istring(hintString) );

		btnDown = false;
		while(who istouching(self))
		{
			if ( who UseButtonPressed() && !who.throwingGrenade && !who meleeButtonPressed() )
			{
				btnDown = true;
			}
			if (btnDown && !who UseButtonPressed())
			{
				entToNotify notify(activeNote,who);
			}
			wait 0.05;
		}
	}
}

war_spawn_helicopter(team,guardLocation,timeOnTarget)
{
	if (isDefined(timeOnTarget) )
	{
		level.heli_dest_wait 	= timeOnTarget;
		level.heli_protect_time = timeOnTarget;
	}
	else
	{
		level.heli_dest_wait = maps\sp_killstreaks\_helicopter::heli_get_dvar_int( "scr_heli_dest_wait", "8" );	
		level.heli_dest_wait = maps\sp_killstreaks\_helicopter::heli_get_dvar_int( "scr_heli_protect_time", "60" );	
	}
		
	getPlayers()[0] thread maps\sp_killstreaks\_helicopter::useKillstreakHelicopter( "helicopter_comlink_sp",guardLocation,team);
}


hide_player_hud()
{
	SetSavedDvar( "hud_showStance", "0" );
	SetSavedDvar( "compass", "0" );
	SetDvar( "old_compass", "0" );
	SetSavedDvar( "ammoCounterHide", "1" );
	SetSavedDvar( "cg_drawCrosshair", 0 );
	foreach(player in GetPlayers())
	{
		turn_off_ally_cam(player);
		player maps\_perks_sp::hide_perks();
		player maps\_utility::hide_hud();
	}
	
	SetDvar("ui_specops","0");
	
	
	for( i=0; i < level.player_classes.size; i++ )
	{
		classType = level.player_classes[i];
		if (isDefined(classType.hudElm))
			classType.hudElm maps\_hud_util::hideElem();
	}
	
	if ( isDefined(level.highlight_icon ) )
	{
		level.highlight_icon maps\_hud_util::hideElem();
	}
	
}

show_player_hud()
{
	SetSavedDvar( "hud_showStance", "1" );
	SetSavedDvar( "compass", "1" );
	SetDvar( "old_compass", "1" );
	SetSavedDvar( "ammoCounterHide", "0" );
	SetSavedDvar( "cg_drawCrosshair", 1 );
	SetDvar("ui_specops","1");
	
	foreach(player in GetPlayers())
	{
		player maps\_perks_sp::show_perks();
		player maps\_utility::show_hud();
	}
	
	for( i=0; i < level.player_classes.size; i++ )
	{
		classType = level.player_classes[i];
		if (isDefined(classType.hudElm))
			classType.hudElm maps\_hud_util::ShowElem();
	}

	if ( isDefined(level.highlight_icon ) )
	{
		level.highlight_icon maps\_hud_util::showElem();
	}
}


show_hint(string,endNotify)
{
	level endon("special_op_terminated");
	GetPlayers()[0] SetScriptHintString( istring(string) );
	level waittill(endNotify);
	GetPlayers()[0] SetScriptHintString( "" );
}

icon_jitter_delete(hudelm)
{
	self notify("icon_jitter_delete");
	self endon("icon_jitter_delete");
	self waittill("death");
	if (isDefined(hudelm.jittericon) )
	{
		 hudelm.jittericon maps\_hud_util::destroyElem();
		 hudelm.jittericon = undefined;
	}
}
icon_jitter(hudelm)
{
	self endon( "death" );
	self thread icon_jitter_delete(hudelm);
	
	if (!isdefined(hudelm.jitter) )
	{
		hudelm.jitter = 1;
	}
	else
	{
		hudelm.jitter++;
	}

	assert( isDefined(hudelm.jitterIcon));

	hudelm.jitterIcon.alpha = 0.85;
	hudelm.jitterIcon.color = (0.7,0,0);
	samples = 20;
	for( i=0; i<=samples; i++ )
	{
		// jittering
		jitter_amount = randomint( int( max( 1, 5 - i/(samples/5) ) ) ) - int( 2 - i/(samples/2) );
		hudelm.jitterIcon.x = hudelm.x + jitter_amount;
		hudelm.jitterIcon.y = hudelm.y + jitter_amount;
		
		// this is the fading enlarging shield
		enlarge_amount = int( i*(40/samples) );
		hudelm.jitterIcon setShader( hudelm.mat, hudelm.iconsize + enlarge_amount, hudelm.iconsize + enlarge_amount );
		hudelm.jitterIcon.alpha = max( ( samples*0.85 - i )/samples, 0 );
		
		wait 0.05;
	}
	
	hudelm.jitterIcon.alpha = 0;
	hudelm.jitterIcon.x = hudelm.x;
	hudelm.jitterIcon.y = hudelm.y;
	hudelm.jitter--;
}
