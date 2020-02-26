#include maps\mp\_utility;
#include common_scripts\utility;

init()
{
	setMatchFlag( "radar_allies", 0 );
	setMatchFlag( "radar_axis", 0 );
	level.spyplane = [];
	level.counterspyplane = [];
	level.satellite = [];
	level.spyplaneType = [];
	level.satelliteType = [];
	level.radarTimers = [];
	foreach( team in level.teams )
	{
		level.radarTimers[team] = getTime();
	}
	level.spyplaneViewTime = 30; // time spy plane remains active
	level.counterUAVViewTime = 30; // time counter UAV remains active
	level.radarLongViewTime = 45; // time radar remains active with fuel tanks killstreak

	// register the radar hardpoint
	if ( maps\mp\gametypes\_tweakables::getTweakableValue( "killstreak", "allowradar" ) )
	{
		maps\mp\killstreaks\_killstreaks::registerKillstreak("radar_mp", "radar_mp", "killstreak_spyplane", "uav_used", ::useKillstreakRadar);
		maps\mp\killstreaks\_killstreaks::registerKillstreakStrings("radar_mp", &"KILLSTREAK_EARNED_RADAR", &"KILLSTREAK_RADAR_NOT_AVAILABLE", &"KILLSTREAK_RADAR_INBOUND" );
		maps\mp\killstreaks\_killstreaks::registerKillstreakDialog("radar_mp", "mpl_killstreak_radar", "kls_u2_used", "","kls_u2_enemy", "", "kls_u2_ready");
		maps\mp\killstreaks\_killstreaks::registerKillstreakDevDvar("radar_mp", "scr_giveradar");
		maps\mp\killstreaks\_killstreaks::createKillstreakTimer( "radar_mp" );
	}

	// register the ounteruav hardpoint
	if ( maps\mp\gametypes\_tweakables::getTweakableValue( "killstreak", "allowcounteruav" ) )
	{
		maps\mp\killstreaks\_killstreaks::registerKillstreak("counteruav_mp", "counteruav_mp", "killstreak_counteruav", "counteruav_used", ::useKillstreakCounterUAV);
		maps\mp\killstreaks\_killstreaks::registerKillstreakStrings("counteruav_mp", &"KILLSTREAK_EARNED_COUNTERUAV", &"KILLSTREAK_COUNTERUAV_NOT_AVAILABLE", &"KILLSTREAK_COUNTERUAV_INBOUND" );
		maps\mp\killstreaks\_killstreaks::registerKillstreakDialog("counteruav_mp", "mpl_killstreak_radar", "kls_cu2_used", "","kls_cu2_enemy", "", "kls_cu2_ready");
		maps\mp\killstreaks\_killstreaks::registerKillstreakDevDvar("counteruav_mp", "scr_givecounteruav");
		maps\mp\killstreaks\_killstreaks::createKillstreakTimer( "counteruav_mp" );
	}

	// register the radar hardpoint
	if ( maps\mp\gametypes\_tweakables::getTweakableValue( "killstreak", "allowradardirection" ) )
	{
		maps\mp\killstreaks\_killstreaks::registerKillstreak("radardirection_mp", "radardirection_mp", "killstreak_spyplane_direction", "uav_used", ::useKillstreakSatellite );
		maps\mp\killstreaks\_killstreaks::registerKillstreakStrings("radardirection_mp", &"KILLSTREAK_EARNED_SATELLITE", &"KILLSTREAK_SATELLITE_NOT_AVAILABLE", &"KILLSTREAK_SATELLITE_INBOUND" );
		maps\mp\killstreaks\_killstreaks::registerKillstreakDialog("radardirection_mp", "mpl_killstreak_satellite", "kls_sat_used", "","kls_sat_enemy", "", "kls_sat_ready");
		maps\mp\killstreaks\_killstreaks::registerKillstreakDevDvar("radardirection_mp", "scr_giveradardirection");
		maps\mp\killstreaks\_killstreaks::createKillstreakTimer( "radardirection_mp" );
	}
}

useKillstreakRadar(hardpointType)
{
	if ( self maps\mp\killstreaks\_killstreakrules::isKillstreakAllowed( hardpointType, self.team ) == false )
		return false;

	killstreak_id = self maps\mp\killstreaks\_killstreakrules::killstreakStart( hardpointType, self.team );
	if (  killstreak_id == -1 )
		return false;

	return self maps\mp\killstreaks\_spyplane::callspyplane( hardpointType, false, killstreak_id );
}

useKillstreakCounterUAV(hardpointType)
{
	if ( self maps\mp\killstreaks\_killstreakrules::isKillstreakAllowed( hardpointType, self.team ) == false )
		return false;

	killstreak_id = self maps\mp\killstreaks\_killstreakrules::killstreakStart( hardpointType, self.team );
	if (  killstreak_id == -1 )
		return false;

	return self maps\mp\killstreaks\_spyplane::callcounteruav( hardpointType, false, killstreak_id );
}

useKillstreakSatellite(hardpointType)
{
	if ( self maps\mp\killstreaks\_killstreakrules::isKillstreakAllowed( hardpointType, self.team ) == false )
		return false;

	killstreak_id = self maps\mp\killstreaks\_killstreakrules::killstreakStart( hardpointType, self.team );
	if (  killstreak_id == -1 )
		return false;

	return self maps\mp\killstreaks\_spyplane::callsatellite( hardpointType, false, killstreak_id );
}

teamHasSpyplane( team )
{
	return ( getTeamSpyplane( team ) > 0 );
}

teamHasSatellite( team )
{
	return ( getTeamSatellite(team) > 0 );
}

useRadarItem( hardpointType, team, displayMessage )
{
	team = self.team;

	assert( isdefined( level.players ) );

	self maps\mp\killstreaks\_killstreaks::playKillstreakStartDialog( hardpointType, team );

	if ( level.teambased )
	{
		if ( !isdefined ( level.spyplane[team] ) )
			level.spyplaneType[team] = 0;
		currentTypeSpyplane = level.spyplaneType[team];
		if ( !isdefined ( level.satelliteType[team] ) )
			level.satelliteType[team] = 0;
		currentTypeSatellite = level.satelliteType[team];
	}
	else
	{
		if ( !isdefined ( self.pers["spyplaneType"] ) )
			self.pers["spyplaneType"] = 0;
		currentTypeSpyplane = self.pers["spyplaneType"];
		if ( !isdefined ( self.pers["satelliteType"] ) )
			self.pers["satelliteType"] = 0;
		currentTypeSatellite = self.pers["satelliteType"];
	}

	radarViewType = 0;
	normal = 1;
	fastSweep = 2;
	notifyString = "";
	isSatellite = false;
	isRadar = false;
	isCounterUAV = false;

	viewTime = level.spyplaneViewTime;
	switch ( hardpointType )
	{
	case "radar_mp":
		{
			notifyString = "spyplane";
			isRadar = true;
			viewTime = level.spyplaneViewTime;

			//self AddPlayerStat( "RECON_USED", 1 );
			level.globalKillstreaksCalled++;
			self AddWeaponStat( hardpointType, "used", 1 );
		}
		break;
	case "radardirection_mp":
		{
			notifyString = "satellite";
			isSatellite = true;
			viewTime = level.radarLongViewTime;
			level notify( "satelliteInbound", team, self );

			//self AddPlayerStat( "SATELLITE_USED", 1 );
			level.globalKillstreaksCalled++;
			self AddWeaponStat( hardpointType, "used", 1 );
		}
		break;
	case "counteruav_mp":
		{
			notifyString = "counteruav";
			isCounterUAV = true;
			viewTime = level.counterUAVViewTime;
			//self AddPlayerStat( "COUNTERUAV_USED", 1 );
			level.globalKillstreaksCalled++;
			self AddWeaponStat( hardpointType, "used", 1 );
		}
		break;
	}

	if ( displayMessage )
	{
		if ( isdefined( level.killstreaks[hardpointType] ) && isdefined( level.killstreaks[hardpointType].inboundtext ) )
			level thread maps\mp\_popups::DisplayKillstreakTeamMessageToAll( hardpointType, self );
	}

	return viewTime;
}

resetSpyplaneTypeOnEnd( type )
{
	self waittill( type + "_timer_kill" );
	self.pers["spyplane"] = 0;
}

resetSatelliteTypeOnEnd( type )
{
	self waittill( type + "_timer_kill" );
	self.pers["satellite"] = 0;
}


setTeamSpyplaneWrapper( team, value )
{
	setTeamSpyplane( team, value );

	radarType = "ui_radar_" + team;

	if( radarType == "ui_radar_allies" )
		setMatchFlag( "radar_allies", value );
	else
		setMatchFlag( "radar_axis", value );

	level notify( "radar_status_change", team );
}

setTeamSatelliteWrapper( team, value )
{
	setTeamSatellite( team, value );

	radarType = "ui_radar_" + team;

	if( radarType == "ui_radar_allies" )
		setMatchFlag( "radar_allies", value );
	else
		setMatchFlag( "radar_axis", value );

	if ( value == false )
		level notify( "satellite_finished_" + team );
	level notify( "radar_status_change", team );
}

enemyObituaryText( type, numseconds )
{
	switch ( type )
	{
	case "radarupdate_mp":
		{	
			self iprintln( &"MP_WAR_RADAR_ACQUIRED_UPDATE_ENEMY", numseconds  );
		}	
		break;
	case "radardirection_mp":
		{
			self iprintln( &"MP_WAR_RADAR_ACQUIRED_DIRECTION_ENEMY", numseconds  );
		}	
		break;
	case "counteruav_mp":
		{
			self iprintln( &"MP_WAR_RADAR_COUNTER_UAV_ACQUIRED_ENEMY", numseconds  );
		}	
		break;
	default:
		{
			self iprintln( &"MP_WAR_RADAR_ACQUIRED_ENEMY", numseconds  );
		}
	}	
}

friendlyObituaryText( type, callingPlayer, numseconds )
{
	switch ( type )
	{
	case "radarupdate_mp":
		{	
			self iprintln( &"MP_WAR_RADAR_UPDATE_ACQUIRED", callingPlayer, numseconds ); 
		}	
		break;
	case "radardirection_mp":
		{
			self iprintln( &"MP_WAR_RADAR_DIRECTION_ACQUIRED", callingPlayer, numseconds ); 
		}	
		break;
	case "counteruav_mp":
		{
			self iprintln( &"MP_WAR_RADAR_COUNTER_UAV_ACQUIRED", numseconds  );
		}	
		break;
	default:
		{
			self iprintln( &"MP_WAR_RADAR_ACQUIRED", callingPlayer, numseconds ); 
		}
	}	
}

