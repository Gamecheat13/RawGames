#include maps\_utility;
#include common_scripts\utility;


///////////////////////////////////////////////
// SavePlayerWeaponStatePersistent
// 
// Saves the player's weapons and ammo state persistently( in the game variable )
// so that it can be restored in a different map.
// You can use strings for the slot:
// 
// SavePlayerWeaponStatePersistent( "russianCampaign" );
// 
// Or you can just use numbers:
// 
// SavePlayerWeaponStatePersistent( 0 );
// SavePlayerWeaponStatePersistent( 1 ); etc.
// 
// In a different map, you can restore using RestorePlayerWeaponStatePersistent( slot );
// Make sure that you always persist the data between map changes.
//
// If the bSaveAmmo parameter is true in SavePlayerWeaponStatePersistent(), the gun's clip
// and stock ammo will be saved, and can be restored with bRestoreAmmo true in the call to
// RestorePlayerWeaponStatePersistent().  (Otherwise weapons will be restored with max ammo.)

SavePlayerWeaponStatePersistent( slot, bSaveAmmo )
{
	if ( !IsDefined( bSaveAmmo ) )
		bSaveAmmo = false;
	
	level.player endon( "death" );
	if ( level.player.health == 0 )
		return;
	current = level.player GetCurrentPrimaryWeapon();
	if ( ( !IsDefined( current ) ) || ( current == "none" ) )
		AssertMsg( "Player's current weapon is 'none' or undefined. Make sure 'disableWeapons()' has not been called on the player when trying to save weapon states." );
	game[ "weaponstates" ][ slot ][ "current" ] = current;

	offhand = level.player GetCurrentOffhand();

	game[ "weaponstates" ][ slot ][ "offhand" ] = offhand;
	game[ "weaponstates" ][ slot ][ "list" ]	= [];
	
	weapList = array_combine( level.player GetWeaponsListPrimaries(), level.player GetWeaponsListOffhands() );
	
	for ( weapIdx = 0; weapIdx < weapList.size; weapIdx++ )
	{
		game[ "weaponstates" ][ slot ][ "list" ][ weapIdx ][ "name" ] = weapList[ weapIdx ];

		if ( bSaveAmmo )
		{
			game[ "weaponstates" ][ slot ][ "list" ][ weapIdx ][ "clip"	 ] = level.player GetWeaponAmmoClip ( weapList[ weapIdx ] );
			game[ "weaponstates" ][ slot ][ "list" ][ weapIdx ][ "stock" ] = level.player GetWeaponAmmoStock( weapList[ weapIdx ] );
		}
	}
}

RestorePlayerWeaponStatePersistent( slot, bRestoreAmmo )
{
	if ( !IsDefined( bRestoreAmmo ) )
		bRestoreAmmo = false;
	
	if ( !IsDefined( game[ "weaponstates" ] ) )
		return false;
	if ( !IsDefined( game[ "weaponstates" ][ slot ] ) )
		return false;

	level.player TakeAllWeapons();
	
	weaponRestoreAmmo = [];
	
	for ( weapIdx = 0; weapIdx < game[ "weaponstates" ][ slot ][ "list" ].size; weapIdx++ )
	{
		weapName = game[ "weaponstates" ][ slot ][ "list" ][ weapIdx ][ "name" ];

		// don't carry over C4 or claymores
		if ( weapName == "c4" )
			continue;
		if ( weapName == "claymore" )
			continue;
		level.player GiveWeapon( weapName );
		level.player GiveMaxAmmo( weapName );

		if ( bRestoreAmmo )
		{
			AssertEx( IsDefined( game[ "weaponstates" ][ slot ][ "list" ][ weapIdx ][ "clip" ] ) && IsDefined( game[ "weaponstates" ][ slot ][ "list" ][ weapIdx ][ "stock" ] ), "RestorePlayerWeaponStatePersistent() with bRestoreAmmo true only works if SavePlayerWeaponStatePersistent() was called with bSaveAmmo true" );
			
			restoreIndex = weaponRestoreAmmo.size;
			weaponRestoreAmmo[ restoreIndex ][ "name" ] = weapName;
			weaponRestoreAmmo[ restoreIndex ][ "clip" ] = game[ "weaponstates" ][ slot ][ "list" ][ weapIdx ][ "clip" ];
			weaponRestoreAmmo[ restoreIndex ][ "stock" ] = game[ "weaponstates" ][ slot ][ "list" ][ weapIdx ][ "stock" ];
		}
	}
	
	// restore ammo after weapons are all given; giving an alternate weapon can overwrite the primary ammo =/
	foreach ( weapTuple in weaponRestoreAmmo )
	{
		level.player SetWeaponAmmoClip( weapTuple[ "name" ], weapTuple[ "clip" ] );
		level.player SetWeaponAmmoStock( weapTuple[ "name" ], weapTuple[ "stock" ] );
	}

	level.player SwitchToOffhand( game[ "weaponstates" ][ slot ][ "offhand" ] );
	level.player SwitchToWeapon( game[ "weaponstates" ][ slot ][ "current" ] );
	
	return true;
}

SetDefaultActionSlot()
{
	self SetActionSlot( 1, "" );
	self SetActionSlot( 2, "" );
	self SetActionSlot( 3, "altMode" );	// toggles between attached grenade launcher
	self SetActionSlot( 4, "" );
}

init_player()
{
	self SetDefaultActionSlot();
	self TakeAllWeapons();
}

get_loadout()
{
    if ( IsDefined( level.loadout ) )
        return level.loadout;
    return level.script;
}

Campaign( campainname )
{
	level._lc = campainname;
}

// I don't want to overdesign this right now. It's only for innocent, was a special case, I think that logic should hold up here , not testing since innocent is not a supported iw6 map.
Persist( Levelname, prevLoadout, secondary_offhand )
{
	loadout_name = get_loadout();
	if ( Levelname != loadout_name )
		return;
	
	if ( !IsDefined( game[ "previous_map" ] ) )
		return;
	
	level._lc_persists = true;
	if ( IsDefined( secondary_offhand ) )
		level.player SetOffhandSecondaryClass( secondary_offhand );
	RestorePlayerWeaponStatePersistent( prevLoadout, true );
	level.has_loadout = true;
}

///Give loadoutby level.
LoadOut( Levelname, Starting_Weapon, Weapon2, Weapon3, Weapon4, Set_View_Model, Offhand_Secondary )
{
	if ( IsDefined( levelname ) )
	{
		loadout_name = get_loadout();
		if ( levelname != loadout_name || IsDefined( level._lc_persists ) )
			return;
	}
	
	if ( IsDefined( Starting_Weapon ) )
	{
		level.default_weapon = Starting_Weapon;
		level.player GiveWeapon( Starting_Weapon );
	}
	if ( IsDefined( weapon2 ) )
		level.player GiveWeapon( weapon2 );
	if ( IsDefined( weapon3 ) )
		level.player GiveWeapon( weapon3 );
	if ( IsDefined( weapon4 ) )
		level.player GiveWeapon( weapon4 );
	
	level.player SwitchToWeapon( Starting_Weapon );
	
	if ( IsDefined( Set_View_Model ) )
		level.player SetViewModel( Set_View_Model );
	if ( IsDefined( Offhand_Secondary ) )
		level.player SetOffhandSecondaryClass( Offhand_Secondary );
	
	level.campaign = level._lc;
	level._lc	   = undefined;
	
	level.has_loadout = true;
}

loadout_complete()
{
	level.loadoutComplete = true;
	level notify( "loadout complete" );
}

default_loadout_if_notset()
{
	if ( level.has_loadout )
		return;

	/# PrintLn( "loadout.gsc:     No level listing in _loadout.gsc, giving default guns" );#/
	
	LoadOut( undefined, "mp5", undefined	, "flash_grenade", "fraggrenade", "viewmodel_base_viewhands", "flash" );
	
	level.map_without_loadout = true; // meh
}