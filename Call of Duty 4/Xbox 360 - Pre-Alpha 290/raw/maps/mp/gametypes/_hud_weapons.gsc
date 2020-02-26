#include maps\mp\gametypes\_hud_util;

/*
"mp5_mp"				smg		30
"m16_mp"				rifle	30
"g36c_mp"				rifle	30
"m14_scoped_mp"			rifle	10
"m40a3_mp"				rifle	5
"barrett_mp"			rifle	10
"winchester1200_mp"		spread	4
"benelli_mp"			spread	7
"m4_mp"					rifle	30
"saw_mp"				rifle	100
"m60e4_mp"				rifle	200
"skorpion_mp"			smg		20
"uzi_mp"				smg		30
"ak47_mp"				rifle	30
"g3_mp"					rifle	30
"dragunov_mp"			rifle	10
"remington700_mp"		rifle	10
"aw50_mp"				rifle	10
"ak74u_mp"				rifle	30
"groza_mp"				rifle	30
"rpd_mp"				rifle	200

"colt1911_mp*"			pistol	15
"beretta_mp"			pistol	15
"usp_mp"				pistol	15
"deserteagle_mp"		pistol	15


pistol	15
smg		30
rifle	30
sniper	10
support	100x2

*/

registerWeaponInfo( name, string, type, clip )
{
	level.weaponInfo[name]["type"] = type;
	level.weaponInfo[name]["clip"] = clip;
	level.weaponInfo[name]["string"] = string;
	
	precacheString( string );	
}

isWeaponRegistered( name )
{
	if ( !isDefined( level.weaponInfo[name] ) )
		return false;
	
	return true;
}

getWeaponInfoType( name )
{
	assertEx( isWeaponRegistered( name ), "ERROR: weapon " + name + " not registered!" );
	return level.weaponInfo[name]["type"];
}

getWeaponInfoClip( name )
{
	assertEx( isWeaponRegistered( name ), "ERROR: weapon " + name + " not registered!" );
	return level.weaponInfo[name]["clip"];
}

getWeaponInfoString( name )
{
	assertEx( isWeaponRegistered( name ), "ERROR: weapon " + name + " not registered!" );
	return level.weaponInfo[name]["string"];
}

init()
{
	precacheShader( "hud_bullets_rifle" );
	precacheShader( "hud_bullets_pistol" );
	precacheShader( "hud_bullets_sniper" );
	precacheShader( "hud_bullets_spread" );
	precacheShader( "hud_bullets_support_front" );
	precacheShader( "hud_bullets_support_back" );

	level.bulletAlphas = [];
	level.bulletAlphas[level.bulletAlphas.size] = 1.000;
	level.bulletAlphas[level.bulletAlphas.size] = 0.996;
	level.bulletAlphas[level.bulletAlphas.size] = 0.949;
	level.bulletAlphas[level.bulletAlphas.size] = 0.909;
	level.bulletAlphas[level.bulletAlphas.size] = 0.870;
	level.bulletAlphas[level.bulletAlphas.size] = 0.835;
	level.bulletAlphas[level.bulletAlphas.size] = 0.803;
	level.bulletAlphas[level.bulletAlphas.size] = 0.776;
	level.bulletAlphas[level.bulletAlphas.size] = 0.749;
	level.bulletAlphas[level.bulletAlphas.size] = 0.721;
	level.bulletAlphas[level.bulletAlphas.size] = 0.698;
	level.bulletAlphas[level.bulletAlphas.size] = 0.674;
	level.bulletAlphas[level.bulletAlphas.size] = 0.654;
	level.bulletAlphas[level.bulletAlphas.size] = 0.635;
	level.bulletAlphas[level.bulletAlphas.size] = 0.615;
	level.bulletAlphas[level.bulletAlphas.size] = 0.596;
	level.bulletAlphas[level.bulletAlphas.size] = 0.580;
	level.bulletAlphas[level.bulletAlphas.size] = 0.564;
	level.bulletAlphas[level.bulletAlphas.size] = 0.549;
	level.bulletAlphas[level.bulletAlphas.size] = 0.537;
	level.bulletAlphas[level.bulletAlphas.size] = 0.521;
	level.bulletAlphas[level.bulletAlphas.size] = 0.509;
	level.bulletAlphas[level.bulletAlphas.size] = 0.498;

	level.weaponInfo = [];
	registerWeaponInfo( "mp5_mp",				&"WEAPON_MP5",				"smg",		30 );
	registerWeaponInfo( "m16_mp",				&"WEAPON_M16",				"rifle",	30 );
	registerWeaponInfo( "m16_m203_mp",			&"WEAPON_M16",				"rifle",	30 );
	registerWeaponInfo( "m203_mp",				&"WEAPON_M203",				"spread",	3 );
	registerWeaponInfo( "g36c_mp",				&"WEAPON_G36C",				"rifle",	30 );
	registerWeaponInfo( "g36c_ag36_mp",			&"WEAPON_G36C",				"rifle",	30 );
	registerWeaponInfo( "ag36_mp",				&"WEAPON_AG36",				"spread",	3 );
	registerWeaponInfo( "m14_scoped_mp",		&"WEAPON_M14",				"sniper",	10 );
	registerWeaponInfo( "m40a3_mp",				&"WEAPON_M40A3",			"sniper",	5 );
	registerWeaponInfo( "barrett_mp",			&"WEAPON_BARRETT",			"sniper",	10 );
	registerWeaponInfo( "winchester1200_mp",	&"WEAPON_WINCHESTER1200",	"spread",	4 );
	registerWeaponInfo( "m1014_mp",			&"WEAPON_BENELLI",			"spread",	7 );
	registerWeaponInfo( "m4_mp",				&"WEAPON_M4",				"rifle",	30 );
	registerWeaponInfo( "saw_mp",				&"WEAPON_SAW",				"support",	100 );
	registerWeaponInfo( "m60e4_mp",				&"WEAPON_M60E4",			"support",	200 );
	registerWeaponInfo( "skorpion_mp",			&"WEAPON_SKORPION",			"smg",		20 );
	registerWeaponInfo( "uzi_mp",				&"WEAPON_UZI",				"smg",		25 );
	registerWeaponInfo( "ak47_mp",				&"WEAPON_AK47",				"rifle",	30 );
	registerWeaponInfo( "ak47_gp25_mp",			&"WEAPON_AK47",				"rifle",	30 );
	registerWeaponInfo( "gp25_mp",				&"WEAPON_GP25",				"spread",	3 );
	registerWeaponInfo( "g3_mp",				&"WEAPON_G3",				"rifle",	20 );
	registerWeaponInfo( "g3_hk79_mp",			&"WEAPON_G3",				"rifle",	20 );
	registerWeaponInfo( "hk79_mp",				&"WEAPON_HK79",				"spread",	3 );
	registerWeaponInfo( "m203_f_mp",			&"WEAPON_M203",				"spread",	3 );
	registerWeaponInfo( "dragunov_mp",			&"WEAPON_DRAGUNOV",			"sniper",	10 );
	registerWeaponInfo( "remington700_mp",		&"WEAPON_REMINGTON700",		"sniper",	10 );
	registerWeaponInfo( "aw50_mp",				&"WEAPON_AW50",				"sniper",	10 );
	registerWeaponInfo( "ak74u_mp",				&"WEAPON_AK74U",			"rifle",	30 );
	registerWeaponInfo( "rpd_mp",				&"WEAPON_RPD",				"support",	200 );
	registerWeaponInfo( "rpg_mp",				&"WEAPON_RPG",				"pistol",	1 );
	registerWeaponInfo( "at4_mp",				&"WEAPON_AT4",				"pistol",	1 );

	registerWeaponInfo( "colt1911_mp*",			&"WEAPON_COLT1911",			"pistol",	15 );
	registerWeaponInfo( "beretta_mp",			&"WEAPON_BERETTA",			"pistol",	15 );
	registerWeaponInfo( "usp_mp",				&"WEAPON_USP",				"pistol",	15 );
	registerWeaponInfo( "deserteagle_mp",		&"WEAPON_DESERTEAGLE",		"pistol",	15 );
	
	registerWeaponInfo( "c4_mp",				&"WEAPON_C4",				"special",	0 );
	registerWeaponInfo( "c4_detonator_mp",		&"WEAPON_C4",				"special",	0 );
	registerWeaponInfo( "claymore_mp",			&"WEAPON_CLAYMORE",			"special",	0 );
	registerWeaponInfo( "claymore_detonator_mp",&"WEAPON_CLAYMORE",			"special",	0 );
	
	if ( !maps\mp\gametypes\_tweakables::getTweakableValue( "hud", "showweaponinfo" ) )
		return;

	level thread onPlayerConnect();
}

onPlayerConnect()
{
	for(;;)
	{
		level waittill("connecting", player);

//		player thread onPlayerSpawned();
//		player thread onUpdatePlayerWeaponHUD();
	}
}

onJoinedSpectators()
{
	self endon("disconnect");
	
	for(;;)
	{
		self waittill("joined_spectators");
		self thread removePlayerWeaponHUD();
	}
}

onPlayerSpawned()
{
	self endon("disconnect");
	
	for(;;)
	{
		self waittill("spawned_player");

		if ( !isDefined( self.hud_bullets ) )
			self.hud_bullets = [];

		if ( !isDefined( self.hud_bullets[0] ) )
		{
			self.hud_bullets[0] = createIcon( undefined, 24, 96 );
			self.hud_bullets[0] setPoint( "BOTTOMRIGHT", "BOTTOMRIGHT", -6, -50 );
			self.hud_bullets[0].sort = 10;
		}

		if ( !isDefined( self.hud_bullets[1] ) )
		{
			self.hud_bullets[1] = createIcon( undefined, 24, 96 );
			self.hud_bullets[1] setPoint( "BOTTOMRIGHT", "BOTTOMRIGHT", -6, -50 );
			self.hud_bullets[1].color = (0.7,0.7,0.7);
			self.hud_bullets[1].sort = 9;
		}

		if ( !isDefined( self.hud_bullets[2] ) )
		{
			self.hud_bullets[2] = createIcon( undefined, 24, 96 );
			self.hud_bullets[2] setPoint( "BOTTOMRIGHT", "BOTTOMRIGHT", -6, -50 );
			self.hud_bullets[2].sort = 10;
		}

		if ( !isDefined( self.hud_bullets[3] ) )
		{
			self.hud_bullets[3] = createIcon( undefined, 24, 96 );
			self.hud_bullets[3] setPoint( "BOTTOMRIGHT", "BOTTOMRIGHT", -6, -50 );
			self.hud_bullets[3].color = (0.7,0.7,0.7);
			self.hud_bullets[3].sort = 9;
		}

		if ( !isDefined( self.hud_bullets[4] ) )
		{
			self.hud_bullets[4] = createIcon( undefined, 24, 96 );
			self.hud_bullets[4] setPoint( "BOTTOMRIGHT", "BOTTOMRIGHT", -6, -50 );
			self.hud_bullets[4].sort = 10;
		}
		/*
		if ( !isDefined( self.hud_totalammo ) )
		{
			self.hud_totalammo = createFontString( "default", 1.5 );
			self.hud_totalammo setParent( self.hud_bullets[0] );
			self.hud_totalammo setPoint( "TOPRIGHT", "BOTTOMRIGHT", 0, 5 );
		}
		
		if ( !isDefined( self.hud_weaponname ) )
		{
			self.hud_weaponname = createFontString( "default", 1.5 );
			self.hud_weaponname setParent( self.hud_totalammo );
			self.hud_weaponname setPoint( "RIGHT", "LEFT", -40, 0 );
			self.hud_weaponname setText( &"MP_KILL" );
		}
		*/
		self thread updateBulletHudThink();
		self thread updatePlayerWeaponHUD();
	}
}


updateBulletHudThink()
{
	self endon ( "disconnect" );
	self endon ( "death" );
	lastAmmoCount = -1;
	lastWeapon = "";
	lastWeaponType = "";

	altSlotAmmo = 0;
	altPrimary = "";
	altAmmo = 0;
	altAmmoSet = false;

	while ( true )
	{
		weapon = self getCurrentWeapon();
		if ( isWeaponRegistered( weapon ) )
		{
			weaponType = self getWeaponInfoType( weapon );
			ammoCount = self GetWeaponAmmoClip( weapon );

			if ( (weapon != lastWeapon) && (weaponType != lastWeaponType ) )
			{
				self setHudWeaponType( weaponType );
				lastWeapon = weapon;
				lastWeaponType = weaponType;
				lastAmmoCount = -1;
			}

			if ( ammoCount != lastAmmoCount )
			{
				self updateHudWeaponAmmo( weapon, ammoCount );
				lastAmmoCount = ammoCount;
			}
			
			/*
			self.hud_totalammo setValue( self GetWeaponAmmoStock( self GetCurrentWeapon() ) );
			if ( self getFractionMaxAmmo( weapon ) < 0.25 )
				self.hud_totalammo.color = (1,0,0);
			else
				self.hud_totalammo.color = (1,1,1);
			
			self.hud_weaponname setText( getWeaponInfoString( weapon ) );
			*/
		}
		wait ( 0.05 );
	}

}

onUpdatePlayerWeaponHUD()
{
	for(;;)
	{
		self waittill("update_playerweapon_hud");
		
		self thread updatePlayerWeaponHUD();
	}
}

updatePlayerWeaponHUD()
{
}

removePlayerWeaponHUD()
{
}

setHudWeaponType( type )
{
	self.pers["weaponType"] = type;
	
	if ( !isDefined( self.hud_bullets ) )
		return;

	for ( index = 0; index < self.hud_bullets.size; index++ )
		self.hud_bullets[index].alpha = 0;
	
	switch( type )
	{
		case "pistol":
			self.hud_bullets[0] setPoint( "BOTTOMRIGHT", "BOTTOMRIGHT", -6, -50 );
			self.hud_bullets[0] setIconShader( "hud_bullets_pistol" );
			self.hud_bullets[0].alpha = 1;
		break;
		case "smg":
			self.hud_bullets[0] setPoint( "BOTTOMRIGHT", "BOTTOMRIGHT", -6, -50 );
			self.hud_bullets[0] setIconShader( "hud_bullets_rifle" );
			self.hud_bullets[1] setIconShader( "hud_bullets_rifle" );
			self.hud_bullets[1] setPoint( "BOTTOMRIGHT", "BOTTOMRIGHT", -4, -53 );
			self.hud_bullets[0].alpha = 1;
			self.hud_bullets[1].alpha = 1;
		break;
		case "rifle":
			self.hud_bullets[0] setPoint( "BOTTOMRIGHT", "BOTTOMRIGHT", -6, -50 );
			self.hud_bullets[0] setIconShader( "hud_bullets_rifle" );
			self.hud_bullets[1] setIconShader( "hud_bullets_rifle" );
			self.hud_bullets[1] setPoint( "BOTTOMRIGHT", "BOTTOMRIGHT", -4, -53 );
			self.hud_bullets[0].alpha = 1;
			self.hud_bullets[1].alpha = 1;
		break;
		case "sniper":
			self.hud_bullets[0] setPoint( "BOTTOMRIGHT", "BOTTOMRIGHT", -6, -50 );
			self.hud_bullets[0] setIconShader( "hud_bullets_sniper" );
			self.hud_bullets[0].alpha = 1;
		break;
		case "spread":
			self.hud_bullets[0] setPoint( "BOTTOMRIGHT", "BOTTOMRIGHT", -6, -50 );
			self.hud_bullets[0] setIconShader( "hud_bullets_spread" );
			self.hud_bullets[0].alpha = 1;
		break;
		case "support":
			xOffset = 0;
			for ( index = 0; index < 5; index++ )
			{
				self.hud_bullets[index] setPoint( "BOTTOMRIGHT", "BOTTOMRIGHT", -6 + xOffset, -50 );
				self.hud_bullets[index].alpha = 1;
				
				if ( index % 2 )
					self.hud_bullets[index] setIconShader( "hud_bullets_support_back" );
				else
					self.hud_bullets[index] setIconShader( "hud_bullets_support_front" );

				xOffset -= 14;
			}
		break;
		case "special":
			break;
	}
}

getHudWeaponType()
{
	return ( self.pers["weaponType"] );
}

updateHudWeaponAmmo( weapon, ammoCount )
{
	if ( !isDefined( self.hud_bullets ) )
		return;	

	switch( self getHudWeaponType() )
	{
		case "pistol":
			baseDiff = 15 - getWeaponInfoClip( weapon );
			diff = getWeaponInfoClip( weapon ) - ammoCount;
			
			self.hud_bullets[0].alpha = level.bulletAlphas[baseDiff + diff];
		break;
		case "rifle":
			baseDiff = 30 - getWeaponInfoClip( weapon );
			diff = getWeaponInfoClip( weapon ) - ammoCount;
			diff = baseDiff + diff;

			col1Diff = int( diff / 2 );
			col1Diff += (diff %2);
			col2Diff = int( diff / 2 );

			self.hud_bullets[0].alpha = level.bulletAlphas[col1Diff];
			self.hud_bullets[1].alpha = level.bulletAlphas[col2Diff];
		break;
		case "smg":
			baseDiff = 30 - getWeaponInfoClip( weapon );
			diff = getWeaponInfoClip( weapon ) - ammoCount;
			diff = baseDiff + diff;

			col1Diff = int( diff / 2 );
			col1Diff += (diff %2);
			col2Diff = int( diff / 2 );

			self.hud_bullets[0].alpha = level.bulletAlphas[col1Diff];
			self.hud_bullets[1].alpha = level.bulletAlphas[col2Diff];
		break;
		case "sniper":
			baseDiff = 15 - getWeaponInfoClip( weapon );
			diff = getWeaponInfoClip( weapon ) - ammoCount;
			
			self.hud_bullets[0].alpha = level.bulletAlphas[baseDiff + diff];			
		break;
		case "spread":
			baseDiff = 15 - getWeaponInfoClip( weapon );
			diff = getWeaponInfoClip( weapon ) - ammoCount;
			
			assertEx( ((baseDiff + diff) < level.bulletAlphas.size) && ((baseDiff + diff) >= 0), "assert: baseDiff = " + baseDiff + " diff = " + diff + " ammoCount = " + ammoCount );
			
			self.hud_bullets[0].alpha = level.bulletAlphas[baseDiff + diff];
		break;
		case "support":
			baseDiff = 100 - getWeaponInfoClip( weapon );
			diff = getWeaponInfoClip( weapon ) - ammoCount;
			diff = baseDiff + diff;
			
			bulletOffset = 20;
			for ( index = 4; index >= 0; index-- )
			{
				if ( diff > bulletOffset )
					self.hud_bullets[index].alpha = 0;
				else if ( (bulletOffset - diff) <= 20 )
					self.hud_bullets[index].alpha = level.bulletAlphas[diff - (bulletOffset - 20)];
				else
					self.hud_bullets[index].alpha = 1;
				
				bulletOffset += 20;
			}
		break;
	}
}
