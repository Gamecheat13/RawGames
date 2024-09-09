#include maps\mp\_utility;
#include maps\mp\gametypes\_hud_util;
#include common_scripts\utility;

init()
{

	precacheString( &"KILLSTREAKS_MAP_KILLSTREAK" );

}

checkMapKillstreak( streakName )
{
	if( streakName == "map_killstreak" )
	{
		switch( level.script )
		{
			case "mp_prison":
				streakname = "mp_prison";
				break;
			case "mp_lab2":
				streakname = "mp_lab2";
				break;
			case "mp_solar":
				streakname = "mp_solar";
				break;
			case "mp_laser2":
				streakname = "mp_laser2";
				break;
			case "mp_dam":
				streakname = "mp_dam";
				break;
			case "mp_refraction":
				streakname = "mp_refraction";
				break;
	                case "mp_greenband":
				streakname = "mp_greenband";
				break;
			default:
				streakName = "none";
				break;
		}
	}
		
	return streakname;

}
