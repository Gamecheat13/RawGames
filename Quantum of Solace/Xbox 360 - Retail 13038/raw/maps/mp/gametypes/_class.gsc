#include common_scripts\utility;

// Hero defines.  (Oh, where are you, #define?)
// Agile Hero = 0
// Sneaky Hero = 1
// Strong Hero = 2
// Balanced Hero = 3
// MI-6 Agent 1 = 10
// MI-6 Agent 2 = 11
// MI-6 Agent 3 = 12
// MI-6 Agent 4 = 13
// Agile Villain = 20
// Sneaky Villain = 21
// Strong Villain = 22
// Balanced Villain = 23
// Terrorist 1 = 30
// Terrorist 2 = 31
// Terrorist 3 = 32
// Terrorist 4 = 33

// Hero Weapon Offset = 100  (Hero define + offset = weapon number.)

// Agent Weapon Range: 0 - 12
// Terrorist Weapon Range: 50 - 62

// Explosives Range: 0 - 5 (0 is Frag, the only option for normal agents or terrorists)
// Gadget Range: 0 - 4 (0 is None, the only option for normal agents or terrorists)

// Player type defines.
// Default MP = 1
// Agile Hero = 3
// Sneaky Hero = 4
// Strong Hero = 5
// Balanced Hero = 6
// Agile Villain = 7
// Sneaky Villain = 8
// Strong Villain = 9
// Balanced Villain = 10

init()
{
	level.canBeHero = ::canBeHero;
	level.setupHeroAccess = ::setupHeroAccess;
	level.giveHeroPoints = ::giveHeroPoints;

	precacheString(&"CLASS_CLOSEQUARTERS");
	precacheString(&"CLASS_ASSAULT");
	precacheString(&"CLASS_SNIPER");
	precacheString(&"CLASS_ENGINEER");
	precacheString(&"CLASS_ANTIARMOR");
	precacheString(&"CLASS_SUPPORT");
	precacheString(&"CLASS_NEWPROF");
	precacheString(&"CLASS_PROFICIENCY_MARKSMAN");
	precacheString(&"CLASS_PROFICIENCY_SHARPSHOOTER");
	precacheString(&"CLASS_PROFICIENCY_EXPERT");
	precacheString(&"CLASS_DEFAULT");
	
	precacheString(&"SKIN_GENERIC_ONE");
	precacheString(&"SKIN_GENERIC_TWO");
	precacheString(&"SKIN_GENERIC_THREE");
	precacheString(&"SKIN_GENERIC_FOUR");
	precacheString(&"SKIN_HERO_ONE");
	precacheString(&"SKIN_HERO_TWO");
	precacheString(&"SKIN_HERO_THREE");
	precacheString(&"SKIN_HERO_FOUR");

	level.classList = [];
	level.classList[level.classList.size] = "DEFAULT";

	level.classes["DEFAULT"] = &"DEFAULT";
	
	level.classMap["default_mp"] = "DEFAULT";	
	
	level.skinList = [];
	level.skinList[level.skinList.size] = "SKIN_GENERIC_ONE";
	level.skinList[level.skinList.size] = "SKIN_GENERIC_TWO";
	level.skinList[level.skinList.size] = "SKIN_GENERIC_THREE";
	level.skinList[level.skinList.size] = "SKIN_GENERIC_FOUR";
	level.skinList[level.skinList.size] = "SKIN_HERO_ONE";
	level.skinList[level.skinList.size] = "SKIN_HERO_TWO";
	level.skinList[level.skinList.size] = "SKIN_HERO_THREE";
	level.skinList[level.skinList.size] = "SKIN_HERO_FOUR";
	
	level.skins["SKIN_GENERIC_ONE"] = &"SKIN_GENERIC_ONE";
	level.skins["SKIN_GENERIC_TWO"] = &"SKIN_GENERIC_TWO";
	level.skins["SKIN_GENERIC_THREE"] = &"SKIN_GENERIC_THREE";
	level.skins["SKIN_GENERIC_FOUR"] = &"SKIN_GENERIC_FOUR";
	level.skins["SKIN_HERO_ONE"] = &"SKIN_HERO_ONE";
	level.skins["SKIN_HERO_TWO"] = &"SKIN_HERO_TWO";
	level.skins["SKIN_HERO_THREE"] = &"SKIN_HERO_THREE";
	level.skins["SKIN_HERO_FOUR"] = &"SKIN_HERO_FOUR";
	
	level.skinMap["generic_one_mp"] = "SKIN_GENERIC_ONE";
	level.skinMap["generic_two_mp"] = "SKIN_GENERIC_TWO";
	level.skinMap["generic_three_mp"] = "SKIN_GENERIC_THREE";
	level.skinMap["generic_four_mp"] = "SKIN_GENERIC_FOUR";
	level.skinMap["hero_one_mp"] = "SKIN_HERO_ONE";
	level.skinMap["hero_two_mp"] = "SKIN_HERO_TWO";
	level.skinMap["hero_three_mp"] = "SKIN_HERO_THREE";
	level.skinMap["hero_four_mp"] = "SKIN_HERO_FOUR";
	
	level.proficiencies["PROFICIENCY_MARKSMAN"] = &"CLASS_PROFICIENCY_MARKSMAN";
	level.proficiencies["PROFICIENCY_SHARPSHOOTER"] = &"CLASS_PROFICIENCY_SHARPSHOOTER";
	level.proficiencies["PROFICIENCY_EXPERT"] = &"CLASS_PROFICIENCY_EXPERT";

	level.heroWeapons[0] = 4;
	level.heroWeapons[1] = 4;
	level.heroWeapons[2] = 4;
	level.heroWeapons[3] = 4;
	level.heroWeapons[20] = 5;
	level.heroWeapons[21] = 5;
	level.heroWeapons[22] = 5;
	level.heroWeapons[23] = 5;
	
	
	if ( maps\mp\gametypes\_tweakables::getTweakableValue( "weapon", "allowfrag" ) )
		level.weapons["frag"] = "frag_grenade_mp";
	else	
		level.weapons["frag"] = "";

	if ( maps\mp\gametypes\_tweakables::getTweakableValue( "weapon", "allowsmoke" ) )
	{
		level.weapons["smoke"] = "smoke_grenade_mp";
		level.weapons["tear"]  = "tear_grenade_mp";
	}	
	else	
	{
		level.weapons["smoke"] = "";
		level.weapons["tear"]  = "";
	}
		
	if ( maps\mp\gametypes\_tweakables::getTweakableValue( "weapon", "allowflash" ) )
		level.weapons["flash"] = "flash_grenade_mp";
	else	
		level.weapons["flash"] = "";

	level.weapons["concussion"] = "concussion_grenade_mp";

	if ( maps\mp\gametypes\_tweakables::getTweakableValue( "weapon", "allowc4" ) )
		level.weapons["c4"] = "c4_mp";
	else	
		level.weapons["c4"] = "";

	if ( maps\mp\gametypes\_tweakables::getTweakableValue( "weapon", "allowclaymores" ) )
	{
		level.weapons["claymore"] = "claymore_mp";
		level.weapons["proxmine"] = "proxmine_mp";
	}		
	else	
	{
		level.weapons["claymore"] = "";
		level.weapons["proxmine"] = "";
	}
		
	if ( maps\mp\gametypes\_tweakables::getTweakableValue( "weapon", "allowrpgs" ) )
	{
		level.weapons["rpg"] = "rpg_mp";
		level.weapons["at4"] = "at4_mp";
	}
	else	
	{
		level.weapons["rpg"] = "";
		level.weapons["at4"] = "";
	}
	
	//////////////////////////////////////////////////////////////////////////////////
	// this corresponds with character_options.menu
	// note: you must precache these weapons in _weapons.gsc
	level.weaponMap = [];
	
	// Agent Weapons
	level.weaponMap[0] = "mp5_mp";
	level.weaponMap[1] = "mac11_mp";
	level.weaponMap[2] = "scar_mp";
	level.weaponMap[3] = "aksu_mp";
	level.weaponMap[4] = "calico_mp";
	level.weaponMap[5] = "m60e3_mp";
	level.weaponMap[6] = "svd_dragunov_mp";
	level.weaponMap[7] = "m4_mp";
	level.weaponMap[8] = "aug_mp";
	level.weaponMap[9] = "wa2000_mp";

	level.weaponMap[10] = "p99_hero_mp";
	level.weaponMap[11] = "mac11_silenced_mp";
	
	// For weapons with alt fire modes, right now we just give a second weapon.
	level.weaponMapAlt = [];
	
	// Each side has its own sidearm.
	level.classSidearm["allies"]["DEFAULT"]	= "p99_mp";	
	level.classSidearm["axis"]["DEFAULT"]	= "1911_mp";
	
	// Setup the explosives.
	level.explosiveMap = [];
	level.explosiveMap["type"] = [];
	level.explosiveMap["count"] = [];
	
	level.explosiveMap["type"][0] = level.weapons["frag"];
	level.explosiveMap["count"][0] = 2;  // Overriden to 1 later on if the player isn't a hero/villain.
	level.explosiveMap["type"][1] = "concussion_grenade_mp";
	level.explosiveMap["count"][1] = 2;
	level.explosiveMap["type"][2] = level.weapons["smoke"];
	level.explosiveMap["count"][2] = 4;
	level.explosiveMap["type"][3] = level.weapons["tear"];
	level.explosiveMap["count"][3] = 3;
	level.explosiveMap["type"][4] = level.weapons["flash"];
	level.explosiveMap["count"][4] = 4;
	level.explosiveMap["type"][5] = level.weapons["proxmine"];
	level.explosiveMap["count"][5] = 2;
		
	// Not ready yet.
	level.gadgetMap = [];
	// 0 is used for "none"
	//level.gadgetMap[1] = // Nightvision goggles.
	//level.gadgetMap[2] = // Portable Defib
	//level.gadgetMap[3] = // Satellite Beacon
	//level.gadgetMap[4] = // Scrambler
	
	
	// TODO: allow more than 1 C4 when it's harder to throw & detonate immediately?
	//level.classItem["allies"]	["DEFAULT"]["type"]		= level.weapons["c4"];
	level.classItem["allies"]	["DEFAULT"]["type"]		= "";
	level.classItem["allies"]	["DEFAULT"]["count"]	= 1;
	
	//level.classItem["axis"]	["DEFAULT"]["type"]		= level.weapons["c4"];
	level.classItem["axis"]		["DEFAULT"]["type"]		= "";
	level.classItem["axis"]		["DEFAULT"]["count"]	= 1;
	
	//level.initc4ammo = 2; // initial ammo for c4 and claymore


	level thread onPlayerConnecting();
}

getResponseToken( response, tokenID, separator )
{
	tokens = strtok( response, separator );
	
	for (i=0; i<tokens.size; i++)
	{
		if (tokens[i] == tokenID)
		{
			if (tokens.size > i+1)
				return tokens[i+1];
			else
				break;
		}
	}
	
	return "";
}

getSkinChoice( response )
{
  tokens = strtok( response, "," );
  return ( level.skinMap[tokens[0]]);
}

getClassChoice( response )
{
	tokens = strtok( response, "," );
	//return ( level.classMap[tokens[0]] );
	return level.classMap["default_mp"];
}

getWeaponChoice( response )
{
	tokens = strtok( response, "," );
	if ( tokens.size > 1 )
		return int(tokens[1]);
	else
		return 0;
}

getExplosiveChoice( response )
{
	tokens = strtok( response, "," );
	if ( tokens.size > 2 )
		return int(tokens[2]);
	else
		return 0;
}

getGadgetChoice( response )
{
	tokens = strtok( response, "," );
	if ( tokens.size > 3 )
		return int(tokens[3]);
	else
		return 0;
}

validateLoadout( team, class )
{
	// If you're a spectator, we just want to get you in watching, you won't have weapons anyways...
	if ( !isDefined(self.pers["team"]) || self.pers["team"] == "spectator" )
	{
		return true; 
	}

	// If you haven't picked a type yet, it must be invalid...
	if ( !isDefined(self.pers["type"] ) )
	{
		self.reason = "No playertype";
		return false;
	} 	
	
	switch ( self.pers["type"] )
	{
	case 10: // Normal Agent
	case 11:
	case 12:
	case 13:
		if ( level.teambased == true && team == "axis" )
		{
			self.reason = "Wrong team for that character.";
			return false;
		}
//		if ( self.pers["primary"] < 0 || self.pers["primary"] > 12 )
//		{
//			self.reason = "Invalid weapon.";
//			return false;
//		}
//		if ( self.pers["explosive"] == "" || self.pers["gadget"] == "" )
//		{
//			self.reason = "Invalid explosive or gadget.";
//			return false;
//		}
		return true;
	case 30: // Normal terrorist
	case 31:
	case 32:
	case 33:
		if ( level.teambased == true && team == "allies" )
		{
			self.reason = "Wrong team for that character.";
			return false;
		}
//		if ( self.pers["primary"] < 50 || self.pers["primary"] > 62 )
//		{
//			self.reason = "Invalid weapon.";
//			return false;
//		}
//		if ( self.pers["explosive"] != 0 || self.pers["gadget"] != 0 )
//		{
//			self.reason = "Invalid explosive or gadget.";
//			return false;
//		}
		return true;
	}
	
	if ( !(self [[level.canBeHero]]()) )
	{
		self.reason = "Character is locked.";
		return false;
	}
	
	// They must have a valid, non-none gadget.
	if ( self.pers["gadget"] == "" )//|| self.pers["gadget"] > 4 )
	{
		self.reason = "Invalid gadget.";
		return false;
	}
	
	// They must have a valid explosive.
	if ( self.pers["explosive"] == "" )//< 0 || self.pers["explosive"] > 5 )
	{
		self.reason = "Invalid explosive.";
		return false;
	}
	
//	// They must have their signature weapon.
//	if ( self.pers["primary"] != self.pers["type"] + 100 )
//	{
//		self.reason = "Invalid weapon.";
//		return false;
//	}
	
	// If team based and on allies, we must be a hero.
	if ( level.teambased == true && team == "allies" && ( self.pers["type"] < 0 || self.pers["type"] > 3 ) )
	{
		self.reason = "Terrorists can't be heroes.";
		return false;
	}
	
	// If team based and on axis, we must be a villain
	if ( level.teambased == true && team == "axis" && ( self.pers["type"] < 20 || self.pers["type"] > 23 ) )
	{
		self.reason = "MI-6 agents can't be villains.";
		return false;
	}
/*	
	// Last check: Make sure nobody else is using this hero!
	players = getentarray("player", "classname");
	
	bFail = false;
	for( i = 0; i < players.size; i++ )
	{
		if( players[i] == self )
			continue;
		switch (players[i] getPlayerType() )
		{
		case 3: 
			if ( self.pers["type"] == 0 )
			{
				bFail = true;
			}
			break;
		case 4:
			if ( self.pers["type"] == 1 )
			{
				bFail = true;
			}
			break;
		case 5:
			if ( self.pers["type"] == 2 )
			{
				bFail = true;
			}
			break;
		case 6:
			if ( self.pers["type"] == 3 )
			{
				bFail = true;
			}
			break;
		case 7: 
			if ( self.pers["type"] == 20 )
			{
				bFail = true;
			}
			break;
		case 8:
			if ( self.pers["type"] == 21 )
			{
				bFail = true;
			}
			break;
		case 9:
			if ( self.pers["type"] == 22 )
			{
				bFail = true;
			}
			break;
		case 10:
			if ( self.pers["type"] == 23 )
			{
				bFail = true;
			}
			break;			
		}
	}
	
	if( bFail )
	{
		self.reason = "That character is already in use.";
		return false;
	}	
*/
	return true;
}


giveLoadout( team, class )
{

	playertype = self getPlayerType();
	playertypename = "DEFAULT";
	
	// this is from 0-10: remap to 0-4
	// hack
	// not sure why specifying the team again seems to be necessary
	switch( playertype )
	{
		case 0:
			playertype = 0;
			playertypename = "DEFAULT";
			break;
			
		case 1:
			playertype = 0;
			playertypename = "DEFAULT";			
			break;	
			
		case 2:
			playertype = 0;
			playertypename = "DEFAULT";
			break;	
			
		case 3:
			playertype = 1;
			playertypename = "AGILE";
			team = "allies";
			break;
		
		case 4:
			playertype = 2;
			playertypename = "SNEAKY";
			team = "allies";
			break;
			
		case 5:
			playertype = 3;
			playertypename = "STRONG";
			team = "allies";
			break;
			
		case 6:
			playertype = 4;
			playertypename = "BALANCED";
			team = "allies";
			break;
			
		case 7:
			playertype = 1;
			playertypename = "AGILE";
			team = "axis";
			break;
			
		case 8:
			playertype = 2;
			playertypename = "SNEAKY";
			team = "axis";
			break;																		

		case 9:
			playertype = 3;
			playertypename = "STRONG";
			team = "axis";
			break;	
			
		case 10:
			playertype = 4;
			playertypename = "BALANCED";
			team = "axis";
			break;	
			
		default:
			playertype = 0;
			playertypename = "DEFAULT";
			break;
	}

	self clearPerks();
	self setPerk( self.pers["gadget1"] );
	self setPerk( self.pers["gadget2"] );

	self detachAll();
	self takeAllWeapons();

	weapon = self.pers["primary"];	
	sidearm = self.pers["sidearm"];

	//iPrintLn( "self.pers[primary]: " + self.pers["primary"] );
	//iPrintLn( "Weapon: " + weapon + " Sidearm: " + sidearm );

	self GiveWeapon( weapon );
	self giveMaxAmmo( weapon );
	self setSpawnWeapon( weapon );
	self.pers["weapon"] = weapon;

	self GiveWeapon( sidearm );
	self giveMaxAmmo( sidearm );

	//self GiveWeapon( "phone_mp" );
	//self GiveWeapon( "phone_interact_mp" );


	isThisPlayerBond = isDefined( level.player_bond ) && level.player_bond == self;
	if( isThisPlayerBond )
	{
		self setPerk( "specialty_exposeenemy" );
		self setPerk( "specialty_endurance" );
		self setPerk( "specialty_retaliation" );
		self setPerk( "specialty_flack_jacket" );
		self setPerk( "specialty_diffuse_kit" );
	}
	else
	{
		// Make sure players who aren't Bond don't get the Bond perks
		self unsetPerk( "specialty_exposeenemy" );
		self unsetPerk( "specialty_endurance" );
		self unsetPerk( "specialty_retaliation" );
		self unsetPerk( "specialty_flack_jacket" );
		self unsetPerk( "specialty_diffuse_kit" );
	}
	
	altWeapon = level.weaponMapAlt[self.pers["primary"]];
	if ( isDefined(altWeapon) )
	{
		self GiveWeapon( altWeapon );
		self giveMaxAmmo( altWeapon );
	}

	if( level.doHero )
	{
		switch ( self.pers["type"] )
		{
		case 0:
			self setPlayerType(3);
			[[game["allies_model"]["SKIN_HERO_ONE"]]]();
			iPrintLn( self.name + " has unlocked Agile Hero." );
			break;
		case 1:
			self setPlayerType(4);
			[[game["allies_model"]["SKIN_HERO_TWO"]]]();
			iPrintLn( self.name + " has unlocked Sneaky Hero." );
			break;
		case 2:
			self setPlayerType(5);
			[[game["allies_model"]["SKIN_HERO_THREE"]]]();
			iPrintLn( self.name + " has unlocked Strong Hero." );
			break;
		case 3:
			self setPlayerType(6);
			[[game["allies_model"]["SKIN_HERO_FOUR"]]]();
			iPrintLn( self.name + " has unlocked Balanced Hero." );
			break;
		case 10:
			self setPlayerType(1);
			[[game["allies_model"]["SKIN_GENERIC_ONE"]]]();
			break;
		case 11:
			self setPlayerType(1);
			[[game["allies_model"]["SKIN_GENERIC_TWO"]]]();
			break;
		case 12:
			self setPlayerType(1);
			[[game["allies_model"]["SKIN_GENERIC_THREE"]]]();
			break;
		case 13:
			self setPlayerType(1);
			[[game["allies_model"]["SKIN_GENERIC_FOUR"]]]();
			break;
		case 20:
			self setPlayerType(7);
			[[game["axis_model"]["SKIN_HERO_ONE"]]]();
			iPrintLn( self.name + " has unlocked Agile Villain." );
			break;
		case 21:
			self setPlayerType(8);
			[[game["axis_model"]["SKIN_HERO_TWO"]]]();
			iPrintLn( self.name + " has unlocked Sneaky Villain." );
			break;
		case 22:
			self setPlayerType(9);
			[[game["axis_model"]["SKIN_HERO_THREE"]]]();
			iPrintLn( self.name + " has unlocked Strong Villain." );
			break;
		case 23:
			self setPlayerType(10);
			[[game["axis_model"]["SKIN_HERO_FOUR"]]]();
			iPrintLn( self.name + " has unlocked Balanced Villain." );
			break;
		case 30:
			self setPlayerType(1);
			[[game["axis_model"]["SKIN_GENERIC_ONE"]]]();
			break;
		case 31:
			self setPlayerType(1);
			[[game["axis_model"]["SKIN_GENERIC_TWO"]]]();
			break;
		case 32:
			self setPlayerType(1);
			[[game["axis_model"]["SKIN_GENERIC_THREE"]]]();
			break;
		case 33:
			self setPlayerType(1);
			[[game["axis_model"]["SKIN_GENERIC_FOUR"]]]();
			break;

		default:
			self setPlayerType(1);
			[[game["allies_model"]["SKIN_GENERIC_ONE"]]]();
			break;		
		}
	}
	else
	{
		skin = self.pers["skin"];
		if(self.pers["team"] == "allies")
			self [[game["allies_model"][skin]]]();
		else if(self.pers["team"] == "axis")
			self [[game["axis_model"][skin]]]();
	}
	
	if ( self getPlayerType() != 1 )
	{
		setupHeroAccessAll();
		if ( isDefined( self.pers["bHeroAvail"] ) && self.pers["bHeroAvail"] ) 
		{
			self.pers["bHeroAvail"] = false;
			self setClientDvar( "ui_hero_avail", 0 );
		}
	}

	// parse the grenades
	grenades = strtok( self.pers["explosive"], "+" );
	for (i=0; i<grenades.size; i++)
	{
		grenadePair = strtok( grenades[i], "=" );
		if (grenadePair.size < 2)
		{
			//iPrintLn("^1Error: bad grenade pair (", grenades[i], ") cannot parse grenades");
			break;
		}
		
		grenadeType = grenadePair[0];
		grenadeCount = int( grenadePair[1] );

		//iPrintLn( "Explosive: " + grenadeType + " Count: " + grenadeCount );
		if ( self hasperkextraspecial() ) {
			//if ( grenadeType != "frag_grenade_mp" ) {
			if ( grenadeType != "proxmine_mp" ) {
				grenadeCount = grenadeCount + 2;
			}
		}

		self GiveWeapon( grenadeType );
		self SetWeaponAmmoStock( grenadeType, grenadeCount );
		self SetWeaponAmmoClip( grenadeType, grenadeCount );
	}

	if ( self hasperkproxmine() ) {
		self GiveWeapon( "proxmine_mp" );
		numProxyMines = self getWeaponAmmoStock( "proxmine_mp" );
		numProxyMines = numProxyMines + 1;
		self SetWeaponAmmoStock( "proxmine_mp", numProxyMines );
	}
	if ( self hasperkextrafrags() ) {
		self GiveWeapon( "frag_grenade_mp" );
		numFragGrenades = self getWeaponAmmoStock( "frag_grenade_mp" );
		numFragGrenades = numFragGrenades + 2;
		self SetWeaponAmmoStock( "frag_grenade_mp", numFragGrenades );
	}

	//self SetActionSlot( 1, "phone", "minimap" );
	//self SetActionSlot( 2, "phone", "fullmap" );
	self SetActionSlot( 3, "grenadecycle" );

	//self SetActionSlot( 4, "phone", "taser" );

	//self SetActionSlot( 5, self.pers["gadget"] );	
}

// sets the amount of ammo in the gun.
// if the clip maxs out, the rest goes into the stock.
setWeaponAmmoOverall( weaponname, amount )
{
	// hack to get around c4 being clip-only
	if ( weaponname == "c4_mp" )
	{
		self setWeaponAmmoStock( weaponname, amount );
	}
	else
	{
		self setWeaponAmmoClip( weaponname, amount );
		diff = amount - self getWeaponAmmoClip( weaponname );
		assert( diff >= 0 );
		self setWeaponAmmoStock( weaponname, diff );
	}
}

replenishLoadout() // used by ammo hardpoint.
{
	team = self.pers["team"];
	class = self getClass();

    weaponsList = self GetWeaponsList();
    for( idx = 0; idx < weaponsList.size; idx++ )
    {
		weapon = weaponsList[idx];

		self giveMaxAmmo( weapon );
		self SetWeaponAmmoClip( weapon, 9999 );
		
		if ( weapon == "claymore_mp" || weapon == "claymore_detonator_mp" )
			self maps\mp\_claymores::setClaymoreAmmo( level.initclaymoreammo );
    }
	
	if ( self getAmmoCount( level.classGrenades[class]["primary"]["type"] ) < level.classGrenades[class]["primary"]["count"] )
 		self SetWeaponAmmoClip( level.classGrenades[class]["primary"]["type"], level.classGrenades[class]["primary"]["count"] );

	if ( self getAmmoCount( level.classGrenades[class]["secondary"]["type"] ) < level.classGrenades[class]["secondary"]["count"] )
 		self SetWeaponAmmoClip( level.classGrenades[class]["secondary"]["type"], level.classGrenades[class]["secondary"]["count"] );	
}

onPlayerConnecting()
{
	for(;;)
	{
		level waittill( "connecting", player );

		if ( !isDefined( player.pers["class"] ) )
		{
			player initClassXP(); //temp
			player.pers["class"] = "";
			player.pers["proficiency"] = 0;
		}
		if( !isDefined( player.pers["skin"] ) )
		  player.pers["skin"] = "";

		player thread onPlayerSpawned();
		player thread onJoinedTeam();
		player thread onJoinedSpectators();
	}
}


onJoinedTeam()
{
	self endon("disconnect");

	for(;;)
	{
		self waittill("joined_team");
		self thread removeClassHUD();
	}
}


onJoinedSpectators()
{
	self endon("disconnect");

	for(;;)
	{
		self waittill("joined_spectators");
		self thread removeClassHUD();
	}
}


onPlayerSpawned()
{
	self endon("disconnect");

	for(;;)
	{
		self waittill("spawned_player");

		if(!isdefined(self.hud_class))
		{
		    self.hud_class = newClientHudElem(self);
		    self.hud_class.horzAlign = "right";
		    self.hud_class.vertAlign = "top";
			  self.hud_class.alignX = "right";
 			  self.hud_class.x = -16;
			  self.hud_class.y = 44;
		    self.hud_class.font = "default";
		    self.hud_class.fontscale = 2;
		    self.hud_class.archived = false;
		    self.hud_class.alpha = 0; // hide class display for now...
		}

		if(!isdefined(self.hud_profannounce))
		{
			self.hud_profannounce = newClientHudElem(self);
			self.hud_profannounce.x = 0;
			self.hud_profannounce.y = 40;
			self.hud_profannounce.alignX = "center";
			self.hud_profannounce.alignY = "top";
			self.hud_profannounce.horzAlign = "center_safearea";
			self.hud_profannounce.vertAlign = "top";
			self.hud_profannounce.archived = false;
			self.hud_profannounce.font = "default";
			self.hud_profannounce.fontscale = 2;
		}

		if(!isdefined(self.hud_newprof))
		{
			self.hud_newprof = newClientHudElem(self);
			self.hud_newprof.x = 0;
			self.hud_newprof.y = 64;
			self.hud_newprof.alignX = "center";
			self.hud_newprof.alignY = "top";
			self.hud_newprof.horzAlign = "center_safearea";
			self.hud_newprof.vertAlign = "top";
			self.hud_newprof.archived = false;
			self.hud_newprof.font = "default";
			self.hud_newprof.fontscale = 2;
		}

		self updateClassHUD();
	}
}


giveClassXP( amount )
{
	xp = self getClassXP( self getClass() );
	self setClassXP( self getClass(), xp + amount );

	self thread updateProfAnnounceHUD();
}


updateProfAnnounceHUD()
{
	self endon("disconnect");

	self notify("update_prof");
	self endon("update_prof");

	if ( self getProficiency( self getClass() ) != self.pers["proficiency"] )
	{
		if ( isDefined( self.hud_newprof ) && isDefined( self.hud_rankannounce ) )
		{
			self.pers["proficiency"] = self getProficiency( self getClass() );
			self.hud_profannounce.alpha = 1;
			self.hud_profannounce setText( &"CLASS_NEWPROF" );
			self.hud_newprof.alpha = 1;
			self.hud_newprof setText( level.proficiencies[self.pers["proficiency"]] );

			self.hud_profannounce thread fadeAway( 3.0, 1.0 );
			self.hud_newprof thread fadeAway( 3.0, 2.0 );
		}
	}
}

fadeAway( waitDelay, fadeDelay )
{
	wait waitDelay;
	
	self fadeOverTime( fadeDelay );
	self.alpha = 0;
}

updateClassHUD()
{
	//if(isDefined(self.hud_class))
	//	self.hud_class setText( level.classes[self getClass()] );
}


removeClassHUD()
{
	if(isDefined(self.hud_class))
		self.hud_class destroy();
}


getProficiency( class )
{
	xp = self getClassXP( class );
	
	if ( xp < 1000 )
		return ("PROFICIENCY_MARKSMAN");
	else if ( xp < 5000 )
		return ("PROFICIENCY_SHARPSHOOTER");
	else
		return ("PROFICIENCY_EXPERT");
}


setClass( newClass )
{
	if ( !isDefined( self.pers["code"] ) )
		self.pers["code"] = [];

	switch( newClass )
	{
	case "DEFAULT":
	case "CLASS_CLOSEQUARTERS":
	case "CLASS_ASSAULT":
	case "CLASS_SNIPER":
	case "CLASS_ENGINEER":
	case "CLASS_ANTIARMOR":
	case "CLASS_SUPPORT":
		self.pers["code"]["class"] = "DEFAULT";
		break;
	default:
		self.pers["code"]["class"] = "DEFAULT";
		break;
	}
	
	self.curClass = self.pers["code"]["class"];
	self notify ( "set_class", self.curClass );
}

setSkin( newSkin )
{
  if ( !isDefined( self.pers["code"] ) )
    self.pers["code"] = [];
 
  // We may want to change this to differentiate for Heroes, setting class as well   
  switch( newSkin )
  {
  case "SKIN_GENERIC_ONE":
  case "SKIN_GENERIC_TWO":
  case "SKIN_GENERIC_THREE":
  case "SKIN_GENERIC_FOUR":
  case "SKIN_HERO_ONE":
  case "SKIN_HERO_TWO":
  case "SKIN_HERO_THREE":
  case "SKIN_HERO_FOUR":
    self.pers["code"]["skin"] = newSkin;
    break;
  default:
    self.pers["code"]["skin"] = "SKIN_GENERIC_ONE";
    break;
  }
  self.curSkin = self.pers["code"]["skin"];
	self notify ( "set_skin", self.curSkin );
}

getClass()
{
	return ( self.pers["code"]["class"] );
}

getSkin()
{
  return ( self.pers["code"]["skin"] );
}

getClassXP( className )
{
	return( self.pers["code"][self.pers["code"]["class"]] );
}

setClassXP( className, amount )
{
	self.pers["code"][className] = amount;
}

initClassXP()
{
	if ( !isDefined( self.pers["code"] ) )
		self.pers["code"] = [];

	self.pers["code"]["DEFAULT"] = 999;

}

onCharacterOptionsResponse( response )
{
	// Ok, we should be getting something like: "spawn,0,0,0,0" where the 4 numbers are 
	// character, weapon, explosive, gadget.  
	
	tokens = strtok( response, "," );
	if(tokens[0] != "spawn" )
	{
		iPrintLn( "Warning: got non-spawn response from menu" );
	}
	
	// Save off the old values, if they represent a non-hero loadout.
	if( isDefined( self.pers["type"] ) )
	{
		if( self.pers["type"] > 3 && ( self.pers["type"] < 20 || self.pers["type"] > 23 ) ) // 0-3 is hero, 20-23 is villain.
		{
			self.pers["oldtype"] = self.pers["type"];
			self.pers["oldprimary"] = self.pers["primary"];
			self.pers["oldexplosive"] = self.pers["explosive"];
			self.pers["oldgadget"] = self.pers["gadget"];
		}	
	}
	self.pers["type"] = int(tokens[1]);
	self.pers["primary"] = int(tokens[2]);
	self.pers["explosive"] = int(tokens[3]);
	self.pers["gadget"] = int(tokens[4]);
	self.pers["skin"] = "SKIN_GENERIC_ONE";
	self.pers["class"] = "DEFAULT";

	// Make sure the new settings are valid.  If not, switch back to the old ones.
	bValid = self maps\mp\gametypes\_class::validateLoadout( self.pers["team"], self.pers["class"] );
	if ( !bValid )
	{
		self setclientdvar( "scr_info", "^1Invalid choice: " + self.reason );
		return;
	}
	
	self closeMenu();
	self closeInGameMenu();

	bHero = true;
	if( self.pers["type"] > 3 && ( self.pers["type"] < 20 || self.pers["type"] > 23 ) ) // 0-3 is hero, 20-23 is villain.
	{
		bHero = false;
	}
		
	if ( self.sessionstate == "playing" )
	{
		self.pers["weapon"] = undefined;
		
		if ( bHero )
		{
			if ( isDefined( self.carryObject ) )
			{
				self.carryObject maps\mp\gametypes\_gameobjects::setDropped();
			}
			self maps\mp\gametypes\_class::setClass( self.pers["class"] );
			self.pers["proficiency"] = self maps\mp\gametypes\_class::getProficiency( self maps\mp\gametypes\_class::getClass() );	
			self.pers["lives"]++;
			self maps\mp\gametypes\_globallogic::spawnplayer();
		}
		else if ( level.inGracePeriod && !self.hasDoneCombat ) // used weapons check?
		{
			self maps\mp\gametypes\_class::setClass( self.pers["class"] );
			self.pers["proficiency"] = self maps\mp\gametypes\_class::getProficiency( self maps\mp\gametypes\_class::getClass() );	
			self maps\mp\gametypes\_class::giveLoadout( self.pers["team"], self.pers["class"] );
		}
	}
	else
	{
		if ( !isDefined( self.pers["class"] ) || self.pers["class"] == "" )
			self thread maps\mp\_utility::printJoinedTeam(self.pers["team"]);
			
		self.pers["weapon"] = undefined;

		if ( game["state"] == "playing" || game["state"] == "prematch" )
			self thread [[level.spawnClient]]();
	}

	level [[level.updateTeamStatus]]();

	if (!isRemovedEntity(self))
		self thread maps\mp\gametypes\_spectating::setSpectatePermissions();
}
	
	
/*	switch( tokens[1] )
	{
		case "0": // agile hero
		
		break;
		case "1": // sneaky hero
		
		break;
		case "2": // strong hero
		
		break;
		case "3": // balanced hero
		
		break;
		case "10": // agent 1
		
		break;
		case "11": // agent 2
		
		break;
		case "12": // agent 3
		
		break;
		case "13": // agent 4
		
		break;
		case "20": // agile villain
		
		break;
		case "21": // sneaky villain
		
		break;
		case "22": // strong villain
		
		break;
		case "23": // balanced villain
		
		break;
		case "30": // terrorist 1
		
		break;
		case "31": // terrorist 2
		
		break;
		case "32": // terrorist 3
		
		break;
		case "33": // terrorist 4
		
		break;*/
		
canBeHero()
{
	if ( self.pers["HeroPoints"] >= 10 )
	{
		return true;
	}
	return false;
}

checkHeroAvailable()
{
	bHeroAvail = false;
	bAgileHero = false;
	bSneakyHero = false;
	bStrongHero = false;
	bBalancedHero = false;
	bAgileVillain = false;
	bSneakyVillain = false;
	bStrongVillain = false;
	bBalancedVillain = false;
	targetHero = -1;	
	
	if ( self [[level.canBeHero]]() )
	{
		players = getentarray("player", "classname");
		
		for( i = 0; i < players.size; i++ )
		{
			if( players[i] == self )
				continue;
			switch( players[i] getPlayerType() )
			{
			case 3:
				bAgileHero = true;
				break;
			case 4:
				bSneakyHero = true;
				break;
			case 5:
				bStrongHero = true;
				break;
			case 6:
				bBalancedHero = true;
				break;
			case 7:
				bAgileVillain = true;
				break;
			case 8:
				bSneakyVillain = true;
				break;
			case 9:
				bStrongVillain = true;
				break;
			case 10:
				bBalancedVillain = true;
				break;
			}					
		}				
		if( level.teambased && isDefined( self.pers["team"] ) && self.pers["team"] == "allies" )
		{
			if( !bAgileHero || !bSneakyHero || !bStrongHero || !bBalancedHero )
			{
				bHeroAvail = true;
				if ( !bBalancedHero )
				{
					targetHero = 3;
				}
				else if ( !bAgileHero ) 
				{
					targetHero = 0;
				}
				else if ( !bSneakyHero )
				{
					targetHero = 1;
				}
				else if ( !bStrongHero )
				{
					targetHero = 2;
				} 				
			}
		}
		else if ( level.teambased && isDefined( self.pers["team"] ) && self.pers["team"] == "axis" )
		{
			if( !bAgileVillain || !bSneakyVillain || !bStrongVillain || !bBalancedVillain )
			{
				bHeroAvail = true;
				if ( !bBalancedVillain )
				{
					targetHero = 23;
				}
				else if ( !bAgileVillain ) 
				{
					targetHero = 20;
				}
				else if ( !bSneakyVillain )
				{
					targetHero = 21;
				}
				else if ( !bStrongVillain )
				{
					targetHero = 22;
				} 
			}
		}
		else
		{
			if( !bAgileHero || !bSneakyHero || !bStrongHero || !bBalancedHero || !bAgileVillain || !bSneakyVillain || !bStrongVillain || !bBalancedVillain )
			{
				bHeroAvail = true;
				if ( !bBalancedHero )
				{
					targetHero = 3;
				}
				else if ( !bAgileHero ) 
				{
					targetHero = 0;
				}
				else if ( !bSneakyHero )
				{
					targetHero = 1;
				}
				else if ( !bStrongHero )
				{
					targetHero = 2;
				} 
				else if ( !bBalancedVillain )
				{
					targetHero = 23;
				}
				else if ( !bAgileVillain ) 
				{
					targetHero = 20;
				}
				else if ( !bSneakyVillain )
				{
					targetHero = 21;
				}
				else if ( !bStrongVillain )
				{
					targetHero = 22;
				} 
			}
		}
	}
	
	if ( !isDefined( self.pers["bHeroAvail"] ) || bHeroAvail != self.pers["bHeroAvail"] )
	{
		self.pers["bHeroAvail"] = bHeroAvail;
		if( bHeroAvail )
		{
			self setClientDvar( "ui_hero_avail", 1 );
			//self iPrintLn( "hero now available, setting char to " + targetHero );
			if ( targetHero != -1 )
			{
				self setClientDvar( "ui_char", targetHero );
				self setClientDvar( "ui_weap", level.heroWeapons[targetHero] );
				self setClientDvar( "ui_exp", randomIntRange( 0, 6 ) );
				self setClientDvar( "ui_gad", randomIntRange( 1, 5 ) );
			}
		}
		else
		{
			self setClientDvar( "ui_hero_avail", 0 );
		}
	}	
}

setupHeroAccessAll()
{
	players = getentarray("player", "classname");

	if ( !players.size )
		return;

	for( i = 0; i < players.size; i++ )
	{
		players[i] setupHeroAccess();
	}
}

setupHeroAccess()
{
	self checkHeroAvailable();
	// Set the dvars saying if hero is locked, in use, or available for the player that is self.
	if ( self [[level.canBeHero]]() )
	{
		bDoAllies = true;
		bDoAxis = true;
		if ( level.teambased )
		{
			if ( self.pers["team"] == "allies" )
			{
				bDoAxis = false;
			}
			if ( self.pers["team"] == "axis" ) 
			{ 
				bDoAllies = false;
			}
		}
		
		bAgileHero = false;
		bSneakyHero = false;
		bStrongHero = false;
		bBalancedHero = false;
	
		bAgileVillain = false;
		bSneakyVillain = false;
		bStrongVillain = false;
		bBalancedVillain = false;
		
		players = getentarray("player", "classname");

		if ( !players.size )
			return;

		for( i = 0; i < players.size; i++ )
		{
			if ( self == players[i] )
				continue;
			type = players[i] getPlayerType();
			switch ( type )
			{
			case 3:
				bAgileHero = true;
				break;
			case 4:
				bSneakyHero = true;
				break;
			case 5:
				bStrongHero = true;
				break;
			case 6:
				bBalancedHero = true;
				break;
			case 7:
				bAgileVillain = true;
				break;
			case 8:
				bSneakyVillain = true;
				break;
			case 9:
				bStrongVillain = true;
				break;
			case 10:
				bBalancedVillain = true;
				break;
			}
		}
		
		// Setup the ally vars.
		if( bDoAllies )
		{
			if ( !isDefined( self.pers["bAgileHero"] ) || bAgileHero != self.pers["bAgileHero"] ) 
			{
				self.pers["bAgileHero"] = bAgileHero;
				if( bAgileHero ) 
				{
					self setClientDvar( "ui_agile_hero", 1 );
				}
				else
				{
					self setClientDvar( "ui_agile_hero", 0 );
				}
			}
			if ( !isDefined( self.pers["bSneakyHero"] ) || bSneakyHero != self.pers["bSneakyHero"] ) 
			{
				self.pers["bSneakyHero"] = bSneakyHero;
				if( bSneakyHero ) 
				{
					self setClientDvar( "ui_sneaky_hero", 1 );
				}
				else
				{
					self setClientDvar( "ui_sneaky_hero", 0 );
				}
			}
			if ( !isDefined( self.pers["bStrongHero"] ) || bStrongHero != self.pers["bStrongHero"] ) 
			{
				self.pers["bStrongHero"] = bStrongHero;
				if( bStrongHero ) 
				{
					self setClientDvar( "ui_strong_hero", 1 );
				}
				else
				{
					self setClientDvar( "ui_strong_hero", 0 );
				}
			}
			if ( !isDefined( self.pers["bBalancedHero"] ) || bBalancedHero != self.pers["bBalancedHero"] ) 
			{
				self.pers["bBalancedHero"] = bBalancedHero;
				if( bBalancedHero ) 
				{
					self setClientDvar( "ui_balanced_hero", 1 );
				}
				else
				{
					self setClientDvar( "ui_balanced_hero", 0 );
				}
			}			
		}

		// Setup the axis vars.
		if( bDoAxis )
		{
			if ( !isDefined( self.pers["bAgileVillain"] ) || bAgileVillain != self.pers["bAgileVillain"] ) 
			{
				self.pers["bAgileVillain"] = bAgileVillain;
				if( bAgileVillain ) 
				{
					self setClientDvar( "ui_agile_villain", 1 );
				}
				else
				{
					self setClientDvar( "ui_agile_villain", 0 );
				}
			}
			if ( !isDefined( self.pers["bSneakyVillain"] ) || bSneakyVillain != self.pers["bSneakyVillain"] ) 
			{
				self.pers["bSneakyVillain"] = bSneakyVillain;
				if( bSneakyVillain ) 
				{
					self setClientDvar( "ui_sneaky_villain", 1 );
				}
				else
				{
					self setClientDvar( "ui_sneaky_villain", 0 );
				}
			}
			if ( !isDefined( self.pers["bStrongVillain"] ) || bStrongVillain != self.pers["bStrongVillain"] ) 
			{
				self.pers["bStrongVillain"] = bStrongVillain;
				if( bStrongVillain ) 
				{
					self setClientDvar( "ui_strong_villain", 1 );
				}
				else
				{
					self setClientDvar( "ui_strong_villain", 0 );
				}
			}
			if ( !isDefined( self.pers["bBalancedVillain"] ) || bBalancedVillain != self.pers["bBalancedVillain"] ) 
			{
				self.pers["bBalancedVillain"] = bBalancedVillain;
				if( bBalancedVillain ) 
				{
					self setClientDvar( "ui_balanced_villain", 1 );
				}
				else
				{
					self setClientDvar( "ui_balanced_villain", 0 );
				}
			}			
		}		
		
		if ( !isDefined( self.pers["ui_no_hero"] ) || self.pers["ui_no_hero"] == 1 )
		{
			self.pers["ui_no_hero"] = 0;
			self setClientDvar( "ui_no_hero", 0 );
		}
	}
	else
	{
		// All that matters is the locked status.  Make sure it is set, and exit.
		if ( !isDefined( self.pers["ui_no_hero"] ) || self.pers["ui_no_hero"] == 0 )
		{
			self.pers["ui_no_hero"] = 1;
			self setClientDvar( "ui_no_hero", 1 );
		}
	}
}

heroPointsTick()
{
	self endon ( "disconnect" );

	if( !isDefined( self.pers["HeroPoints"] ) )
	{
		self.pers["HeroPoints"] = 0;
	}

	while ( 1 )
	{
		self giveHeroPoints( 1 );
		wait 5;
	}
}

giveHeroPoints( pointsToGive )
{
	return;		// disabled for now

//	if ( !isPlayer( self ) ) // Make the entity we're trying to give points to is a player.
//	{
//		return;
//	}
//	
//	type = self getPlayerType();
//	
//	if ( type != 1 )
//	{
//		//self iPrintLn ("Resetting hero points because type was: " + type );
//		self.pers["HeroPoints"] = 0;
//		
//		// Make sure the bHeroAvail display isn't still up.
//		if ( isDefined( self.pers["bHeroAvail"] ) && self.pers["bHeroAvail"] ) 
//		{
//			self.pers["bHeroAvail"] = false;
//			self setClientDvar( "ui_hero_avail", 0 );
//		}
//		self setupHeroAccess();
//		return;
//	}
//
//	if ( !isDefined( self.pers["HeroPoints"] ) )
//	{
//		self.pers["HeroPoints"] = 0;
//	}
	
//	self.pers["HeroPoints"] += pointsToGive;
//	if( pointsToGive == 1 )
//	{
//		self iPrintLn( "Got hero point! Total: " + self.pers["HeroPoints"] );
//	}
//	else
//	{
//		self iPrintLn( "Got " + pointsToGive + " hero points! Total: " + self.pers["HeroPoints"] );
//	}
//	self setupHeroAccess();
}
