#include common_scripts\utility;
#include maps\mp\gametypes\_class;

copycat_clone_loadout( attacker )
{
	self.pers[ "copycat_loadout" ] = undefined;
	
	if ( !self HasPerk( "specialty_copycat" ) )
	{
		return;
	}

	if ( !self DeathStreakActive() )
	{
		return;
	}
	
	if ( attacker.curclass == "copycat" )
	{
		return;
	}

	if ( !IsSubStr( attacker.curclass, "CLASS_CUSTOM" ) )
	{
		return; // don't support default classes for now
	}

	self.pers[ "copycat_loadout" ] = attacker.custom_class[ attacker.class_num ];
	self.pers[ "copycat_loadout" ][ "in_use" ] = false;

	// remove this to have copycat clone the attacker's killstreaks
	self.pers[ "copycat_loadout" ][ "killstreak1" ] = self.killstreak[0];
	self.pers[ "copycat_loadout" ][ "killstreak2" ] = self.killstreak[1];
	self.pers[ "copycat_loadout" ][ "killstreak3" ] = self.killstreak[2];
	//

	// remove this to have copycat clone the attacker's deathstreaks
	copycat_remove_deathstreaks();
	//
}

copycat_in_use()
{
	return ( IsDefined( self.pers[ "copycat_loadout" ] ) && self.pers[ "copycat_loadout" ][ "in_use" ] );
}

copycat_remove_deathstreaks()
{
	specialties = self.pers[ "copycat_loadout" ][ "specialties" ];
	
	// remove all deathstreaks
	for ( i = 0; i < specialties.size; i++ )
	{
		switch( specialties[i].name )
		{
			case "specialty_grenadepulldeath":
			case "specialty_painkiller":
			case "specialty_finalstand":
			case "specialty_copycat":
				specialties[i].name = "specialty_null";
			break;
		}
	}

	// and add in copycat
	copycat = SpawnStruct();
	copycat.name = "specialty_copycat";
	copycat.group = "specialty";
	specialties[ specialties.size ] = copycat;

	self.pers[ "copycat_loadout" ][ "specialty4" ] = "specialty_copycat";
	self.pers[ "copycat_loadout" ][ "specialties" ] = specialties;
}

copycat_give_loadout()
{
	Assert( IsDefined( self.pers[ "copycat_loadout" ] ) );
	self.curclass = "copycat";
		
	copycat_give_perks();
	copycat_give_killstreaks();
	copycat_give_primary_weapon();
	copycat_give_sidearm_weapon();
	copycat_give_inventory();
	copycat_give_primary_grenade();
	copycat_give_special_grenade();
		
	self maps\mp\gametypes\_armor::set_player_model();
	self.pers[ "copycat_loadout" ][ "in_use" ] = false;
}

copycat_give_perks()
{
	specialties = self.pers[ "copycat_loadout" ][ "specialties" ];
	
	for ( i = 0; i < specialties.size; i++ )
	{
		if ( specialties[i].group == "specialty" )
		{
			self.specialty[ self.specialty.size ] = specialties[i].name;
		}
	}

	register_perks();
}

copycat_give_killstreaks()
{
	self.killstreak[0] = self.pers[ "copycat_loadout" ][ "killstreak1" ];
	self.killstreak[1] = self.pers[ "copycat_loadout" ][ "killstreak2" ];
	self.killstreak[2] = self.pers[ "copycat_loadout" ][ "killstreak3" ];
}

copycat_give_primary_weapon()
{
	primary = self.pers[ "copycat_loadout" ][ "primary" ];
	options = int( self.pers[ "copycat_loadout" ][ "weapon_options" ] );

	token = StrTok( primary, "_" );
	self.pers[ "primaryWeapon" ] = token[0];

	self GiveWeapon( primary, 0, options );
	self SetSpawnWeapon( primary );

	if ( self cac_hasSpecialty( "specialty_extraammo" ) )
	{
		self GiveMaxAmmo( primary );
	}
}

copycat_give_sidearm_weapon()
{
	sidearm = self.pers[ "copycat_loadout" ][ "secondary" ];
	self GiveWeapon( sidearm );
	
	if ( self cac_hasSpecialty( "specialty_extraammo" ) )
	{
		self GiveMaxAmmo( sidearm );
	}

	//If it is a pistol, don't play first raise anim
	if( maps\mp\gametypes\_weapons::isPistol( sidearm ) )
		self setSpawnWeapon( sidearm );
}

copycat_give_inventory()
{
	inventory	= self.pers[ "copycat_loadout" ][ "inventory" ];
	count		= self.pers[ "copycat_loadout" ][ "inventory_count" ];
	
	if ( inventory != "" )
	{
		self GiveWeapon( inventory );
		self SetWeaponAmmoOverall( inventory, count );

		self SetActionSlot( 3, "weapon", inventory );
		self SetActionSlot( 4, "" );
	}
	else
	{
		self SetActionSlot( 3, "altMode" );
		self SetActionSlot( 4, "" );
	}
}

copycat_give_primary_grenade()
{
	grenade = self.pers[ "copycat_loadout" ][ "grenades" ]; 
	count	= self.pers[ "copycat_loadout" ][ "grenades_count" ];
	
	if ( grenade != "" && grenade != "weapon_null_mp" )
	{
		self GiveWeapon( grenade );
		self SetWeaponAmmoClip( grenade, count );
		self SwitchToOffhand( grenade );
		
		isFrag = self SetOffhandPrimaryClass( grenade );
		if( isFrag != "frag" )
		{
			self GiveWeapon( level.weapons["frag"] );
			self SetWeaponAmmoClip( level.weapons["frag"], 0 );
		}
	}
	else
	{
		self GiveWeapon( level.weapons["frag"] );
		self SetWeaponAmmoClip( level.weapons["frag"], 0 );
	}
}

copycat_give_special_grenade()
{
	grenade = self.pers[ "copycat_loadout" ][ "specialgrenades" ];
	count	= self.pers[ "copycat_loadout" ][ "specialgrenades_count" ];
	
	if ( grenade != "" && grenade != "weapon_null_mp" )
	{
		self SetOffhandSecondaryClass( grenade );
		self GiveWeapon( grenade );
		self SetWeaponAmmoClip( grenade, count );
	}
}

copycat_button_think()
{
	if ( !IsDefined( self.pers[ "copycat_loadout" ] ) )
	{
		return;
	}

	icon = copycat_button_create();
	text = copycat_text_create();

	self thread copycat_button_press();
	
	event = self waittill_any_return( "disconnect", "end_killcam", "abort_killcam", "copycat_used" );

	if ( event == "copycat_used" )
	{
		self.pers[ "copycat_loadout" ][ "in_use" ] = true;
	}
	else
	{
		self.pers[ "copycat_loadout" ] = undefined;
	}

	icon Destroy();
	text Destroy();
}

copycat_button_press()
{
	self endon( "disconnect" );
	self endon( "end_killcam" );
	self endon( "abort_killcam" );

	while( !self changeSeatButtonPressed() )
	{
		wait( .05 );
	}

	self notify( "copycat_used" );
}

copycat_button_create()
{
	icon = NewClientHudElem( self );
	icon.archived = false;
	icon.x = 16;
	icon.y = 16;
	icon.alignX = "left";
	icon.alignY = "top";
	icon.horzAlign = "center";
	icon.vertAlign = "middle";
	icon.sort = 1; 
	icon.foreground = true;
	icon.hideWhenInMenu = true;		
	icon setShader( "specialty_copycat", 48, 48 );
	icon.alpha = 1;

	return icon;
}

copycat_text_create()
{
	text = NewClientHudElem( self );
	text.archived = false;
	text.y = 48;
	text.alignX = "left";
	text.alignY = "top";
	text.horzAlign = "center";
	text.vertAlign = "middle";
	text.sort = 10; // force to draw after the bars
	text.font = "small";
	text.foreground = true;
	text.hideWhenInMenu = true;
		
	if ( level.splitscreen )
	{
		text.x = 16;
		text.fontscale = 1.2;
	}
	else
	{
		text.x = 32;
		text.fontscale = 1.6;
	}

	text setText( &"PLATFORM_PRESS_TO_COPYCAT" );
	text.alpha = 1;

	return text;
}