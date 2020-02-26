#include common_scripts\utility;

init()
{
	level.canBeHero = ::canBeHero;
	level.setupHeroAccess = ::setupHeroAccess;
	level.giveHeroPoints = ::giveHeroPoints;
	
	precacheString(&"SKIN_MI6_00");
	precacheString(&"SKIN_MASTERMIND");
	precacheString(&"SKIN_OFFENSIVE");
	precacheString(&"SKIN_LOYALIST");
	precacheString(&"SKIN_DISRUPTIVE");
	precacheString(&"SKIN_PERSONAL_BODYGUARD");
	precacheString(&"SKIN_DEFENSIVE");
	precacheString(&"SKIN_BOMBER");
	precacheString(&"SKIN_SHARPSHOOTER");
	precacheString(&"SKIN_SMERSH_ASSASSIN");
	precacheString(&"SKIN_VIP");

	level.classList = [];
	level.classList[level.classList.size] = "DEFAULT";

	level.classes["DEFAULT"] = &"DEFAULT";
	
	level.classMap["default_mp"] = "DEFAULT";	
	
	level.skinList = [];
	level.skinList[level.skinList.size] = "SKIN_MI6_00";
	level.skinList[level.skinList.size] = "SKIN_MASTERMIND";
	level.skinList[level.skinList.size] = "SKIN_OFFENSIVE";
	level.skinList[level.skinList.size] = "SKIN_LOYALIST";
	level.skinList[level.skinList.size] = "SKIN_DISRUPTIVE";
	level.skinList[level.skinList.size] = "SKIN_PERSONAL_BODYGUARD";
	level.skinList[level.skinList.size] = "SKIN_DEFENSIVE";
	level.skinList[level.skinList.size] = "SKIN_BOMBER";
	level.skinList[level.skinList.size] = "SKIN_SHARPSHOOTER";
	level.skinList[level.skinList.size] = "SKIN_SMERSH_ASSASSIN";
	level.skinList[level.skinList.size] = "SKIN_VIP";
	
	level.skins["SKIN_MI6_00"] = &"SKIN_MI6_00";
	level.skins["SKIN_MASTERMIND"] = &"SKIN_MASTERMIND";
	level.skins["SKIN_OFFENSIVE"] = &"SKIN_OFFENSIVE";
	level.skins["SKIN_LOYALIST"] = &"SKIN_LOYALIST";
	level.skins["SKIN_DISRUPTIVE"] = &"SKIN_DISRUPTIVE";
	level.skins["SKIN_PERSONAL_BODYGUARD"] = &"SKIN_PERSONAL_BODYGUARD";
	level.skins["SKIN_DEFENSIVE"] = &"SKIN_DEFENSIVE";
	level.skins["SKIN_BOMBER"] = &"SKIN_BOMBER";
	level.skins["SKIN_SHARPSHOOTER"] = &"SKIN_SHARPSHOOTER";
	level.skins["SKIN_SMERSH_ASSASSIN"] = &"SKIN_SMERSH_ASSASSIN";
	level.skins["SKIN_VIP"] = &"SKIN_VIP";
	
	level.skinMap["character_mp_bx_mi6agent"] = "SKIN_MI6_00";
	level.skinMap["character_mp_bx_mastermind"] = "SKIN_MASTERMIND";
	level.skinMap["character_mp_bx_offensive"] = "SKIN_OFFENSIVE";
	level.skinMap["character_mp_bx_loyalist"] = "SKIN_LOYALIST";
	level.skinMap["character_mp_bx_disruptive"] = "SKIN_DISRUPTIVE";
	level.skinMap["character_mp_bx_personal_bodyguard"] = "SKIN_PERSONAL_BODYGUARD";
	level.skinMap["character_mp_bx_defensive"] = "SKIN_DEFENSIVE";
	level.skinMap["character_mp_bx_bomber"] = "SKIN_BOMBER";
	level.skinMap["character_mp_bx_sharpshooter"] = "SKIN_SHARPSHOOTER";
	level.skinMap["character_mp_bx_smersh_assassin"] = "SKIN_SMERSH_ASSASSIN";
	
	level.skinMap["character_mp_bx_bond"] = "SKIN_VIP";
	level.skinMap["character_mp_bx_villain_vip"] = "SKIN_VIP";

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
	
	
	
	
	level.weaponMap = [];
	
	
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
	
	
	level.weaponMapAlt = [];
	
	
	level.classSidearm["allies"]["DEFAULT"]	= "p99_mp";	
	level.classSidearm["axis"]["DEFAULT"]	= "1911_mp";
	
	
	level.explosiveMap = [];
	level.explosiveMap["type"] = [];
	level.explosiveMap["count"] = [];
	
	level.explosiveMap["type"][0] = level.weapons["frag"];
	level.explosiveMap["count"][0] = 2;  
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
		
	
	level.gadgetMap = [];
	
	
	
	
	
	
	
	
	
	level.classItem["allies"]	["DEFAULT"]["type"]		= "";
	level.classItem["allies"]	["DEFAULT"]["count"]	= 1;
	
	
	level.classItem["axis"]		["DEFAULT"]["type"]		= "";
	level.classItem["axis"]		["DEFAULT"]["count"]	= 1;
	
	


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
	
	if ( !isDefined(self.pers["team"]) || self.pers["team"] == "spectator" )
	{
		return true; 
	}

	
	if ( !isDefined(self.pers["type"] ) )
	{
		self.reason = "No playertype";
		return false;
	} 	
	
	switch ( self.pers["type"] )
	{
	case 10: 
	case 11:
	case 12:
	case 13:
		if ( level.teambased == true && team == "axis" )
		{
			self.reason = "Wrong team for that character.";
			return false;
		}










		return true;
	case 30: 
	case 31:
	case 32:
	case 33:
		if ( level.teambased == true && team == "allies" )
		{
			self.reason = "Wrong team for that character.";
			return false;
		}










		return true;
	}
	
	if ( !(self [[level.canBeHero]]()) )
	{
		self.reason = "Character is locked.";
		return false;
	}
	
	
	if ( self.pers["gadget"] == "" )
	{
		self.reason = "Invalid gadget.";
		return false;
	}
	
	
	if ( self.pers["explosive"] == "" )
	{
		self.reason = "Invalid explosive.";
		return false;
	}
	






	
	
	if ( level.teambased == true && team == "allies" && ( self.pers["type"] < 0 || self.pers["type"] > 3 ) )
	{
		self.reason = "Terrorists can't be heroes.";
		return false;
	}
	
	
	if ( level.teambased == true && team == "axis" && ( self.pers["type"] < 20 || self.pers["type"] > 23 ) )
	{
		self.reason = "MI-6 agents can't be villains.";
		return false;
	}

	return true;
}





giveLoadout( team, class )
{
	playertype = self getPlayerType();
	weapon = self.pers["primary"];	
	sidearm = self.pers["sidearm"];
	grenadeType = "frag_grenade_mp";
	grenadeCount = 2;

	team_model = "axis_model";
	if ( self.pers["team"] == "allies" )
		team_model = "allies_model";


	switch( class )
	{
		case "bx_mi6_defender":
			playertype = 2;
			weapon = "scar_mp";
			grenadeType = "smoke_grenade_mp";
			grenadeCount = 2;
			self.pers["skin"] = "SKIN_DEFENSIVE";
			break;
			
		case "bx_mi6_scout":
			playertype = 3;
			weapon = "1300_auto_mp";
			grenadeType = "flash_grenade_mp";
			grenadeCount = 3;
			self.pers["skin"] = "SKIN_DISRUPTIVE";
			break;	
			
		case "bx_mi6_00agent":
			playertype = 4;
			weapon = "mp5_mp";
			grenadeType = "proxmine_mp";
			grenadeCount = 1;
			self.pers["skin"] = "SKIN_MI6_00";
			break;	
			
		case "bx_mi6_veteran":
			playertype = 5;
			weapon = "m4_mp";
			grenadeType = "frag_grenade_mp";
			grenadeCount = 2;
			self.pers["skin"] = "SKIN_OFFENSIVE";
			break;
		
		case "bx_mi6_marksman":
			playertype = 6;
			weapon = "aug_mp";
			grenadeType = "flash_grenade_mp";
			grenadeCount = 2;
			self.pers["skin"] = "SKIN_SHARPSHOOTER";
			break;
			
		case "mp_bx_secretservices_vip":
			playertype = 7;
			weapon = "p99_hero_mp";
			grenadeType = "smoke_grenade_mp";
			grenadeCount = 1;
			self.pers["skin"] = "SKIN_VIP";
			break;
			
		case "bx_org_bomber":
			playertype = 8;
			weapon = "1300_bomber_mp";
			grenadeType = "frag_grenade_mp";
			grenadeCount = 3;
			self.pers["skin"] = "SKIN_BOMBER";
			break;
			
		case "bx_org_mercenary":
			playertype = 9;
			weapon = "aksu_mp";
			grenadeType = "frag_grenade_mp";
			grenadeCount = 2;
			self.pers["skin"] = "SKIN_LOYALIST";
			break;
			
		case "bx_org_mastermind":
			playertype = 10;
			weapon = "calico_mp";
			grenadeType = "proxmine_mp";
			grenadeCount = 1;
			self.pers["skin"] = "SKIN_MASTERMIND";
			break;																		

		case "bx_org_henchman":
			playertype = 11;
			weapon = "mac11_mp";
			grenadeType = "smoke_grenade_mp";
			grenadeCount = 2;
			self.pers["skin"] = "SKIN_PERSONAL_BODYGUARD";
			break;	
			
		case "bx_org_assassin":
			playertype = 12;
			weapon = "svd_dragunov_mp";
			grenadeType = "flash_grenade_mp";
			grenadeCount = 2;
			self.pers["skin"] = "SKIN_SMERSH_ASSASSIN";
			break;

		case "mp_bx_villain_vip":
			playertype = 13;
			weapon = "p99_hero_mp";
			grenadeType = "smoke_grenade_mp";
			grenadeCount = 1;
			self.pers["skin"] = "SKIN_VIP";
			break;	
			
		default:
			break;
	}
	logprint( "\n-------------------\n" );
	logprint( "player selected : " );
	logprint( class );
	logprint( "\nWeapon: " );
	logprint( weapon );
	logprint( "\nSidearm: " );
	logprint( sidearm );
	logprint( "\nPlayertype: " );
	logprint( playertype );
	logprint( "\nGrenade: " );
	logprint( grenadeType );
	logprint( "\nGrenade count: " );
	logprint( grenadeCount );
	logprint( "\nModel team: " );
	logprint( team_model );
	logprint( "\nSkin: " );
	logprint( self.pers["skin"] );
	logprint( "\n-------------------\n" );

	self detachAll();
	self takeAllWeapons();
	
	self GiveWeapon( weapon );
	self giveMaxAmmo( weapon );
	self setSpawnWeapon( weapon );
	self.pers["weapon"] = weapon;
	
	self GiveWeapon( sidearm );
	self giveMaxAmmo( sidearm );
	
	self setPlayerType(playertype);

	[[game[team_model][self.pers["skin"]]]]();


	self.maxhealth = maps\mp\gametypes\_tweakables::getTweakableValue( "player", "maxhealth" );
	self.health = self.maxhealth;

	self GiveWeapon( grenadeType );
	self SetWeaponAmmoStock( grenadeType, grenadeCount );
	self SetWeaponAmmoClip( grenadeType, grenadeCount );
}



setWeaponAmmoOverall( weaponname, amount )
{
	
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

replenishLoadout() 
{
	team = self.pers["team"];
	class = self getClass();

    weaponsList = self GetWeaponsList();
    for( idx = 0; idx < weaponsList.size; idx++ )
    {
		weapon = weaponsList[idx];

		self giveMaxAmmo( weapon );
		self SetWeaponAmmoClip( weapon, 9999 );
		
		
		
		
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
			player initClassXP(); 
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
		    self.hud_class.alpha = 0; 
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


fadeAway( waitDelay, fadeDelay )
{
	wait waitDelay;
	
	self fadeOverTime( fadeDelay );
	self.alpha = 0;
}

updateClassHUD()
{
	
	
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
  
  switch( newSkin )
  {
  case "SKIN_MI6_00":
  case "SKIN_MASTERMIND":
  case "SKIN_OFFENSIVE":
  case "SKIN_LOYALIST":
  case "SKIN_DISRUPTIVE":
  case "SKIN_PERSONAL_BODYGUARD":
  case "SKIN_DEFENSIVE":
  case "SKIN_BOMBER":
  case "SKIN_SHARPSHOOTER":
  case "SKIN_SMERSH_ASSASSIN":
  case "SKIN_VIP":
    self.pers["code"]["skin"] = newSkin;
    break;
  default:
    self.pers["code"]["skin"] = "SKIN_MI6_00";
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
	
	
	
	tokens = strtok( response, "," );
	if(tokens[0] != "spawn" )
	{
		iPrintLn( "Warning: got non-spawn response from menu" );
	}
	
	
	if( isDefined( self.pers["type"] ) )
	{
		if( self.pers["type"] > 3 && ( self.pers["type"] < 20 || self.pers["type"] > 23 ) ) 
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
	self.pers["skin"] = "SKIN_MI6_00";
	self.pers["class"] = "DEFAULT";

	
	bValid = self maps\mp\gametypes\_class::validateLoadout( self.pers["team"], self.pers["class"] );
	if ( !bValid )
	{
		self setclientdvar( "scr_info", "^1Invalid choice: " + self.reason );
		return;
	}
	
	self closeMenu();
	self closeInGameMenu();

	bHero = true;
	if( self.pers["type"] > 3 && ( self.pers["type"] < 20 || self.pers["type"] > 23 ) ) 
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
		else if ( level.inGracePeriod && !self.hasDoneCombat ) 
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
	return;		



























	










}
