#include common_scripts\utility;

init()
{
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

	level.classList = [];
	level.classList[level.classList.size] = "CLASS_CLOSEQUARTERS";
	level.classList[level.classList.size] = "CLASS_ASSAULT";
	level.classList[level.classList.size] = "CLASS_SNIPER";
	level.classList[level.classList.size] = "CLASS_ENGINEER";
	level.classList[level.classList.size] = "CLASS_ANTIARMOR";
	level.classList[level.classList.size] = "CLASS_SUPPORT";

	level.classes["CLASS_CLOSEQUARTERS"] = &"CLASS_CLOSEQUARTERS";
	level.classes["CLASS_ASSAULT"] = &"CLASS_ASSAULT";
	level.classes["CLASS_SNIPER"] = &"CLASS_SNIPER";
	level.classes["CLASS_ENGINEER"] = &"CLASS_ENGINEER";
	level.classes["CLASS_ANTIARMOR"] = &"CLASS_ANTIARMOR";
	level.classes["CLASS_SUPPORT"] = &"CLASS_SUPPORT";
	
	level.classMap["closequarters_mp"] = "CLASS_CLOSEQUARTERS";		
	level.classMap["assault_mp"] = "CLASS_ASSAULT";
	level.classMap["sniper_mp"] = "CLASS_SNIPER";
	level.classMap["engineer_mp"] = "CLASS_ENGINEER";
	level.classMap["antiarmor_mp"] = "CLASS_ANTIARMOR";
	level.classMap["support_mp"] = "CLASS_SUPPORT";
	
	level.proficiencies["PROFICIENCY_MARKSMAN"] = &"CLASS_PROFICIENCY_MARKSMAN";
	level.proficiencies["PROFICIENCY_SHARPSHOOTER"] = &"CLASS_PROFICIENCY_SHARPSHOOTER";
	level.proficiencies["PROFICIENCY_EXPERT"] = &"CLASS_PROFICIENCY_EXPERT";
	
	
	if ( maps\mp\gametypes\_tweakables::getTweakableValue( "weapon", "allowfrag" ) )
		level.weapons["frag"] = "frag_grenade_mp";
	else	
		level.weapons["frag"] = "";

	if ( maps\mp\gametypes\_tweakables::getTweakableValue( "weapon", "allowsmoke" ) )
		level.weapons["smoke"] = "smoke_grenade_mp";
	else	
		level.weapons["smoke"] = "";

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
		level.weapons["claymore"] = "claymore_mp";
	else	
		level.weapons["claymore"] = "";

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
	
	
	level.classWeapons["allies"]["CLASS_CLOSEQUARTERS"][0] = "mp5_mp";
	level.classWeapons["allies"]["CLASS_ASSAULT"][0] = "m16_m203_mp";
	level.classWeapons["allies"]["CLASS_SNIPER"][0] = "m14_scoped_mp";
	level.classWeapons["allies"]["CLASS_ENGINEER"][0] = "winchester1200_mp";
	level.classWeapons["allies"]["CLASS_ANTIARMOR"][0] = "m4_mp";
	level.classWeapons["allies"]["CLASS_SUPPORT"][0] = "saw_mp";
	
	level.classWeapons["axis"]["CLASS_CLOSEQUARTERS"][0] = "mp5_mp";
	level.classWeapons["axis"]["CLASS_ASSAULT"][0] = "m16_m203_mp";
	level.classWeapons["axis"]["CLASS_SNIPER"][0] = "m14_scoped_mp";
	level.classWeapons["axis"]["CLASS_ENGINEER"][0] = "winchester1200_mp";
	level.classWeapons["axis"]["CLASS_ANTIARMOR"][0] = "m4_mp";
	level.classWeapons["axis"]["CLASS_SUPPORT"][0] = "saw_mp";

	level.classSidearm["allies"]["CLASS_CLOSEQUARTERS"]	= "beretta_mp";
	level.classSidearm["allies"]["CLASS_ASSAULT"]		= "beretta_mp";
	level.classSidearm["allies"]["CLASS_SNIPER"]		= "beretta_mp";
	level.classSidearm["allies"]["CLASS_ENGINEER"]		= "beretta_mp";
	level.classSidearm["allies"]["CLASS_ANTIARMOR"]		= "beretta_mp";
	level.classSidearm["allies"]["CLASS_SUPPORT"]		= "beretta_mp";
	
	level.classSidearm["axis"]["CLASS_CLOSEQUARTERS"]	= "beretta_mp";
	level.classSidearm["axis"]["CLASS_ASSAULT"]			= "beretta_mp";
	level.classSidearm["axis"]["CLASS_SNIPER"]			= "beretta_mp";
	level.classSidearm["axis"]["CLASS_ENGINEER"]		= "beretta_mp";
	level.classSidearm["axis"]["CLASS_ANTIARMOR"]		= "beretta_mp";
	level.classSidearm["axis"]["CLASS_SUPPORT"]			= "beretta_mp";
	
	level.classGrenades["CLASS_CLOSEQUARTERS"]	["primary"]		["type"]	= level.weapons["frag"];
	level.classGrenades["CLASS_CLOSEQUARTERS"]	["primary"]		["count"]	= 1;
	level.classGrenades["CLASS_CLOSEQUARTERS"]	["secondary"]	["type"]	= level.weapons["flash"];
	level.classGrenades["CLASS_CLOSEQUARTERS"]	["secondary"]	["count"]	= 1;
	level.classGrenades["CLASS_ASSAULT"]		["primary"]		["type"]	= level.weapons["frag"];
	level.classGrenades["CLASS_ASSAULT"]		["primary"]		["count"]	= 1;
	level.classGrenades["CLASS_ASSAULT"]		["secondary"]	["type"]	= level.weapons["smoke"];
	level.classGrenades["CLASS_ASSAULT"]		["secondary"]	["count"]	= 1;
	level.classGrenades["CLASS_SNIPER"]			["primary"]		["type"]	= level.weapons["frag"];
	level.classGrenades["CLASS_SNIPER"]			["primary"]		["count"]	= 1;
	level.classGrenades["CLASS_SNIPER"]			["secondary"]	["type"]	= level.weapons["concussion"];
	level.classGrenades["CLASS_SNIPER"]			["secondary"]	["count"]	= 1;
	level.classGrenades["CLASS_ENGINEER"]		["primary"]		["type"]	= level.weapons["frag"];
	level.classGrenades["CLASS_ENGINEER"]		["primary"]		["count"]	= 1;
	level.classGrenades["CLASS_ENGINEER"]		["secondary"]	["type"]	= level.weapons["concussion"];
	level.classGrenades["CLASS_ENGINEER"]		["secondary"]	["count"]	= 1;
	level.classGrenades["CLASS_ANTIARMOR"]		["primary"]		["type"]	= level.weapons["frag"];
	level.classGrenades["CLASS_ANTIARMOR"]		["primary"]		["count"]	= 1;
	level.classGrenades["CLASS_ANTIARMOR"]		["secondary"]	["type"]	= level.weapons["flash"];
	level.classGrenades["CLASS_ANTIARMOR"]		["secondary"]	["count"]	= 1;
	level.classGrenades["CLASS_SUPPORT"]		["primary"]		["type"]	= level.weapons["frag"];
	level.classGrenades["CLASS_SUPPORT"]		["primary"]		["count"]	= 1;
	level.classGrenades["CLASS_SUPPORT"]		["secondary"]	["type"]	= level.weapons["smoke"];
	level.classGrenades["CLASS_SUPPORT"]		["secondary"]	["count"]	= 1;
	
	// TODO: allow more than 1 C4 when it's harder to throw & detonate immediately?
	level.classItem["allies"]	["CLASS_CLOSEQUARTERS"]["type"]		= level.weapons["c4"];
	level.classItem["allies"]	["CLASS_CLOSEQUARTERS"]["count"]	= 2;
	level.classItem["allies"]	["CLASS_ASSAULT"]["type"]			= "";
	level.classItem["allies"]	["CLASS_ASSAULT"]["count"]			= 0;
	level.classItem["allies"]	["CLASS_SNIPER"]["type"]			= level.weapons["claymore"];
	level.classItem["allies"]	["CLASS_SNIPER"]["count"]			= 2;
	level.classItem["allies"]	["CLASS_ENGINEER"]["type"]			= level.weapons["at4"];
	level.classItem["allies"]	["CLASS_ENGINEER"]["count"]			= 1;
	//level.classItem["allies"]	["CLASS_ANTIARMOR"]["type"]			= level.weapons["at4"];
	//level.classItem["allies"]	["CLASS_ANTIARMOR"]["count"]		= 1;
	level.classItem["allies"]	["CLASS_SUPPORT"]["type"]			= level.weapons["claymore"];
	level.classItem["allies"]	["CLASS_SUPPORT"]["count"]			= 2;
	
	level.classItem["axis"]		["CLASS_CLOSEQUARTERS"]["type"]		= level.weapons["c4"];
	level.classItem["axis"]		["CLASS_CLOSEQUARTERS"]["count"]	= 2;
	level.classItem["axis"]		["CLASS_ASSAULT"]["type"]			= "";
	level.classItem["axis"]		["CLASS_ASSAULT"]["count"]			= 0;
	level.classItem["axis"]		["CLASS_SNIPER"]["type"]			= level.weapons["claymore"];
	level.classItem["axis"]		["CLASS_SNIPER"]["count"]			= 2;
	level.classItem["axis"]		["CLASS_ENGINEER"]["type"]			= level.weapons["at4"];
	level.classItem["axis"]		["CLASS_ENGINEER"]["count"]			= 1;
	//level.classItem["axis"]		["CLASS_ANTIARMOR"]["type"]			= level.weapons["at4"];
	//level.classItem["axis"]		["CLASS_ANTIARMOR"]["count"]		= 1;
	level.classItem["axis"]		["CLASS_SUPPORT"]["type"]			= level.weapons["claymore"];
	level.classItem["axis"]		["CLASS_SUPPORT"]["count"]			= 2;
	
	
	level.initc4ammo = 2; // initial ammo for c4 and claymore
	level.initclaymoreammo = 2;

	level thread onPlayerConnecting();
}

getClassChoice( response )
{
	tokens = strtok( response, "," );
	return ( level.classMap[tokens[0]] );
}

getWeaponChoice( response )
{
	tokens = strtok( response, "," );
	if ( tokens.size > 1 )
		return int(tokens[1]);
	else
		return 0;
}

giveLoadout( team, class )
{
	self takeAllWeapons();

//	if ( level.splitscreen )
		primaryIndex = 0;
//	else
//		primaryIndex = self.pers["primary"];
	
	// weapon override for round based gametypes
	// TODO: if they switched to a sidearm, we shouldn't give them that as their primary!
	if ( isDefined( self.pers["weapon"] ) && self.pers["weapon"] != "none" )
		weapon = self.pers["weapon"];
	else
		weapon = level.classWeapons[team][class][primaryIndex];
	
	sidearm = level.classSidearm[team][class];
	
	self GiveWeapon( weapon );
	self giveMaxAmmo( weapon );
	self setSpawnWeapon( weapon );
	
	self GiveWeapon( sidearm );
	self giveMaxAmmo( sidearm );

	self SetActionSlot( 1, "nightvision" );
	self SetActionSlot( 2, "altMode" );

	secondaryWeapon = level.classItem[team][class]["type"];	
	if ( secondaryWeapon != "" )
	{
		self GiveWeapon( secondaryWeapon );
		
		if ( secondaryWeapon == "claymore_mp" )
			self maps\mp\_claymores::setClaymoreAmmo( level.classItem[team][class]["count"] );
		else
			self setWeaponAmmoOverall( secondaryWeapon, level.classItem[team][class]["count"] );
		
		self SetActionSlot( 3, "weapon", secondaryWeapon );
		self SetActionSlot( 4, "" );
	}
	else
	{
		self SetActionSlot( 3, "" );
		self SetActionSlot( 4, "" );
	}
	
	grenadeTypePrimary = level.classGrenades[class]["primary"]["type"];
	if ( grenadeTypePrimary != "" )
	{
		grenadeCount = level.classGrenades[class]["primary"]["count"];

		self GiveWeapon( grenadeTypePrimary );
		self SetWeaponAmmoClip( grenadeTypePrimary, grenadeCount );
		self SwitchToOffhand( grenadeTypePrimary );
	}
	
	grenadeTypeSecondary = level.classGrenades[class]["secondary"]["type"];
	if ( grenadeTypeSecondary != "" )
	{
		grenadeCount = level.classGrenades[class]["secondary"]["count"];

		if ( grenadeTypeSecondary == level.weapons["flash"])
			self setOffhandSecondaryClass("flash");
		else
			self setOffhandSecondaryClass("smoke");
		
		self giveWeapon( grenadeTypeSecondary );
		self SetWeaponAmmoClip( grenadeTypeSecondary, grenadeCount );
	}
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
	if(isDefined(self.hud_class))
		self.hud_class setText( level.classes[self getClass()] );
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
	case "CLASS_CLOSEQUARTERS":
	case "CLASS_ASSAULT":
	case "CLASS_SNIPER":
	case "CLASS_ENGINEER":
	case "CLASS_ANTIARMOR":
	case "CLASS_SUPPORT":
		self.pers["code"]["class"] = newClass;
		break;
	default:
		self.pers["code"]["class"] = "CLASS_CLOSEQUARTERS";
		break;
	}
	
	self.curClass = self.pers["code"]["class"];
	self notify ( "set_class", self.curClass );
}

getClass()
{
	return ( self.pers["code"]["class"] );
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

	self.pers["code"]["CLASS_CLOSEQUARTERS"] = 999;
	self.pers["code"]["CLASS_ASSAULT"] = 999;
	self.pers["code"]["CLASS_SNIPER"] = 999;
	self.pers["code"]["CLASS_ENGINEER"] = 999;
	self.pers["code"]["CLASS_ANTIARMOR"] = 999;
	self.pers["code"]["CLASS_SUPPORT"] = 999;
}

