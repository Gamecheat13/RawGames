#include clientscripts\mp\_utility;
#include clientscripts\mp\_fx;
#include clientscripts\mp\_music;

init()
{
	if ( GetDvar( "createfx" ) == "on" )
	{
		return;
	}
	
	if ( !clientscripts\mp\zombies\_zm_weapons::is_weapon_included( "jetgun_zm" ) )
	{
		return;
	}
	
/*	
	level._effect["jetgun_viewmodel_power_cell1"] = loadfx("weapon/thunder_gun/fx_thundergun_power_cell_view1");
	level._effect["jetgun_viewmodel_power_cell2"] = loadfx("weapon/thunder_gun/fx_thundergun_power_cell_view2");
	level._effect["jetgun_viewmodel_power_cell3"] = loadfx("weapon/thunder_gun/fx_thundergun_power_cell_view3");
	level._effect["jetgun_viewmodel_steam"] = loadfx("weapon/thunder_gun/fx_thundergun_steam_view");

	level._effect["jetgun_viewmodel_power_cell_upgraded1"] = loadfx("weapon/thunder_gun/fx_thundergun_power_cell_view1");
	level._effect["jetgun_viewmodel_power_cell_upgraded2"] = loadfx("weapon/thunder_gun/fx_thundergun_power_cell_view2");
	level._effect["jetgun_viewmodel_power_cell_upgraded3"] = loadfx("weapon/thunder_gun/fx_thundergun_power_cell_view3");
	level._effect["jetgun_viewmodel_steam"] = loadfx("weapon/thunder_gun/fx_thundergun_steam_view");
	level._effect["jetgun_viewmodel_steam_upgraded"] = loadfx("weapon/thunder_gun/fx_thundergun_steam_view");

	level.jetgun_steam_vents = 3;
	level.jetgun_power_cell_fx_handles = [];
	level.jetgun_power_cell_fx_handles[level.jetgun_power_cell_fx_handles.size] = -1;
	level.jetgun_power_cell_fx_handles[level.jetgun_power_cell_fx_handles.size] = -1;
	level.jetgun_power_cell_fx_handles[level.jetgun_power_cell_fx_handles.size] = -1;
	
	level thread player_init();
	level thread jetgun_notetrack_think(); 
*/
}

player_init()
{
	waitforclient( 0 );
	level.jetgun_play_fx_power_cell = [];
	
	players = GetlocalPlayers();
	for( i = 0; i < players.size; i++ )
	{
		level.jetgun_play_fx_power_cell[i] = true;
		players[i] thread jetgun_fx_power_cell( i );
	}
}

jetgun_fx_power_cell( localclientnum )
{
	self endon( "disconnect" );

	oldAmmo = -1;
	oldCount = -1;
	
	self thread jetgun_fx_listener( localclientnum );

	for( ;; )
	{
		waitrealtime( 0.1 );

		// Fix for SP Campaign save game restore issue
		while ( !ClientHasSnapshot(0) )
		{
			wait( 0.05 );
		}

		weaponname = undefined;
		
		currentweapon = GetCurrentWeapon( localclientnum ); 
		if ( !level.jetgun_play_fx_power_cell[localclientnum] || IsThrowingGrenade( localclientnum ) || IsMeleeing( localclientnum ) || IsOnTurret( localclientnum ) || (currentweapon != "jetgun_zm" && currentweapon != "jetgun_upgraded_zm") )
		{
			if ( oldAmmo != -1 )
			{
				jetgun_play_power_cell_fx( localclientnum, 0 );
			}
			oldAmmo = -1;
			oldCount = -1;
			continue;
		}
		
		ammo = GetWeaponAmmoClip( localclientnum, currentweapon );
		if ( oldAmmo > 0 && oldAmmo != ammo )
		{
			jetgun_fx_fire( localclientnum );
			
		}
		oldAmmo = ammo;

		if ( ammo > level.jetgun_power_cell_fx_handles.size )
		{
			ammo = level.jetgun_power_cell_fx_handles.size;
		}

		if ( oldCount == -1 || oldCount != ammo )
		{
			level thread jetgun_play_power_cell_fx( localclientnum, ammo );
		}
		oldCount = ammo;
	}
}

jetgun_play_power_cell_fx( localclientnum, count )
{
	level notify( "kill_power_cell_fx" );

	for ( i = 0; i < level.jetgun_power_cell_fx_handles.size; i++ )
	{
		if ( IsDefined(level.jetgun_power_cell_fx_handles[i]) && level.jetgun_power_cell_fx_handles[i] != -1 )
		{
			deletefx( localclientnum, level.jetgun_power_cell_fx_handles[i] );
			level.jetgun_power_cell_fx_handles[i] = -1;
		}
	}
	
	if ( !count )
	{
		return;
	}

	level endon( "kill_power_cell_fx" );

	for ( ;; )
	{
		currentweapon = GetCurrentWeapon( localclientnum ); 
		if ( currentweapon != "jetgun_zm" && currentweapon != "jetgun_upgraded_zm" )
		{
			wait( 0.05 );
			continue;
		}

		for ( i = count; i > 0; i-- )
		{
			fx = level._effect["jetgun_viewmodel_power_cell" + i];
			if( currentweapon == "jetgun_upgraded_zm" )
			{
				fx = level._effect["jetgun_viewmodel_power_cell_upgraded" + i];
			}

			level.jetgun_power_cell_fx_handles[i - 1] = PlayViewmodelFx( localclientnum, fx, "tag_bulb" + i );
		}
		waitrealtime( 3 );
	}
}

jetgun_fx_fire( localclientnum )
{
	currentweapon = GetCurrentWeapon( localclientnum );

	fx = level._effect["jetgun_viewmodel_steam"];
	if( currentweapon == "jetgun_upgraded_zm" )
	{
		fx = level._effect["jetgun_viewmodel_steam_upgraded"];
	}

	for ( i = level.jetgun_steam_vents; i > 0; i-- )
	{
		PlayViewmodelFx( localclientnum, fx, "tag_steam" + i );
	}
	playsound(localclientnum,"wpn_thunder_breath", (0,0,0));
}

jetgun_notetrack_think()
{
	for ( ;; )
	{
		level waittill( "notetrack", localclientnum, note );

		//println( "@@@ Got notetrack: " + note + " for client: " + localclientnum );

		switch( note )
		{
		case "jetgun_putaway_start":
			level.jetgun_play_fx_power_cell[localclientnum] = false;
		break;

		case "jetgun_pullout_start":
			level.jetgun_play_fx_power_cell[localclientnum] = true;
		break;

		case "jetgun_fire_start":
			jetgun_fx_fire( localclientnum );
		break;
		}
	}
}

jetgun_death_effects( localclientnum, weaponname, userdata )
{
}
thread_zombie_vox()
{
	ent = spawn (0,  self.origin, "script_origin");
	playsound(0, "wpn_thundergun_proj_impact_zombie", ent.origin);
	wait(5);
	ent delete();
	
}

// listen for the fx to be enabled/disabled
jetgun_fx_listener( localclientnum )
{
	self endon( "disconnect" );

	while (1)
	{
		level waittill( "tgfx0" );	// Thundergun fx off

		level.jetgun_play_fx_power_cell[localclientnum] = false;

		level waittill( "tgfx1" );

		level.jetgun_play_fx_power_cell[localclientnum] = true;
	}
}
