#include common_scripts\utility;
#include maps\mp\_utility;

isGrenadeLauncherWeapon( weapon )
{
	if(GetSubStr( weapon,0,3 ) == "gl_")
	{
		return true;
	}
	
	switch( weapon )
	{
	case "xm25_mp":
	case "china_lake_mp":		// we still using this for BO2?
		return true;
	default:
		return false;
	}
}

isDumbRocketLauncherWeapon( weapon )
{
	// should switch these out with code calls
	switch( weapon )
	{
	case "rpg_mp":
	case "m220_tow_mp":
		return true;
	default:
		return false;
	}
}

isGuidedRocketLauncherWeapon( weapon )
{
	// should switch these out with code calls
	switch( weapon )
	{
	case "fhj18_mp":
	case "m72_law_mp":
	case "smaw_mp":
	case "javelin_mp":
	case "m202_flash_mp":
		return true;
	default:
		return false;
	}
}

isRocketLauncherWeapon( weapon )
{
	if(isDumbRocketLauncherWeapon(weapon))
	{
		return true;
	}
	
	if(isGuidedRocketLauncherWeapon(weapon))
	{
		return true;
	}
	
	return false;
}

isLauncherWeapon( weapon )
{
	if(isRocketLauncherWeapon(weapon))
	{
		return true;
	}
	
	if(isGrenadeLauncherWeapon(weapon))
	{
		return true;
	}
	
	return false;
}

isReducedTeamkillWeapon( weapon )
{
	switch( weapon )
	{
	case "planemortar_mp":
		return true;
	default:
		return false;
	}
}

isHackWeapon( weapon )
{
	if ( maps\mp\killstreaks\_killstreaks::isKillstreakWeapon( weapon ) )
		return true;
	if ( weapon == "briefcase_bomb_mp" )
		return true;
	return false;
}

isPistol( weapon )
{
	return isdefined( level.side_arm_array[ weapon ] );
}


isFlashOrStunWeapon( weapon )
{
	if ( IsDefined( weapon ) )
	{
		switch ( weapon ) 
		{
			case "concussion_grenade_mp":
			case "flash_grenade_mp":
			case "proximity_grenade_mp":
			case "proximity_grenade_aoe_mp":
				return true;
		}
	}

	return false;
}

isFlashOrStunDamage( weapon, meansofdeath )
{
	return ( isFlashOrStunWeapon(weapon) && ( meansofdeath == "MOD_GRENADE_SPLASH" || meansofdeath == "MOD_GAS" ) );
}
