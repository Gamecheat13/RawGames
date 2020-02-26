#include maps\_utility;
#include common_scripts\utility;

preload()
{
	maps\sp_killstreaks\_killstreaks::registerKillstreak("radar_sp", "radar_sp", "killstreak_spyplane", "uav_used", ::useKillstreakRadar);
	maps\sp_killstreaks\_killstreaks::registerKillstreakStrings("radar_sp", &"KILLSTREAK_EARNED_RADAR", &"KILLSTREAK_RADAR_NOT_AVAILABLE", &"KILLSTREAK_RADAR_INBOUND" );
	maps\sp_killstreaks\_killstreaks::registerKillstreakDialog("radar_sp", "mpl_killstreak_radar", "kls_u2_used", "","kls_u2_enemy", "", "kls_u2_ready");
	maps\sp_killstreaks\_killstreaks::registerKillstreakDevDvar("radar_sp", "scr_giveradar");

	maps\sp_killstreaks\_killstreaks::registerKillstreak("counteruav_sp", "counteruav_sp", "killstreak_counteruav", "counteruav_used", ::useKillstreakCounterUAV);
	maps\sp_killstreaks\_killstreaks::registerKillstreakStrings("counteruav_sp", &"KILLSTREAK_EARNED_COUNTERUAV", &"KILLSTREAK_COUNTERUAV_NOT_AVAILABLE", &"KILLSTREAK_COUNTERUAV_INBOUND" );
	maps\sp_killstreaks\_killstreaks::registerKillstreakDialog("counteruav_sp", "mpl_killstreak_radar", "kls_cu2_used", "","kls_cu2_enemy", "", "kls_cu2_ready");
	maps\sp_killstreaks\_killstreaks::registerKillstreakDevDvar("counteruav_sp", "scr_givecounteruav");

	maps\sp_killstreaks\_killstreaks::registerKillstreak("radardirection_sp", "radardirection_sp", "killstreak_spyplane_direction", "uav_used", ::useKillstreakSatellite );
	maps\sp_killstreaks\_killstreaks::registerKillstreakStrings("radardirection_sp", &"KILLSTREAK_EARNED_SATELLITE", &"KILLSTREAK_SATELLITE_NOT_AVAILABLE", &"KILLSTREAK_SATELLITE_INBOUND" );
	maps\sp_killstreaks\_killstreaks::registerKillstreakDialog("radardirection_sp", "mpl_killstreak_satellite", "kls_sat_used", "","kls_sat_enemy", "", "kls_sat_ready");
	maps\sp_killstreaks\_killstreaks::registerKillstreakDevDvar("radardirection_sp", "scr_giveradardirection");
}

init()
{
	level.spyplane = [];
	level.counterspyplane = [];
	level.satellite = [];
	level.spyplaneType = [];
	level.satelliteType = [];
	level.radarTimers = [];
	level.radarTimers["allies"] = getTime();
	level.radarTimers["axis"] = getTime();
	level.spyplaneViewTime = 20; // time spy plane remains active
	level.radarViewTime = 30; // time radar remains active
	level.radarLongViewTime = 45; // time radar remains active with fuel tanks killstreak
}

useKillstreakRadar(hardpointType)
{
	if ( self maps\sp_killstreaks\_killstreakrules::isKillstreakAllowed( hardpointType, self.team ) == false )
		return false;

	if ( self maps\sp_killstreaks\_killstreakrules::killstreakStart( hardpointType, self.team ) == false )	 
		return false;

	self thread  maps\sp_killstreaks\_spyplane::callspyplane( hardpointType, false );
	return true;
}

useKillstreakCounterUAV(hardpointType)
{
	if ( self maps\sp_killstreaks\_killstreakrules::isKillstreakAllowed( hardpointType, self.team ) == false )
		return false;

	if ( self maps\sp_killstreaks\_killstreakrules::killstreakStart( hardpointType, self.team ) == false )	 
		return false;

	self thread  maps\sp_killstreaks\_spyplane::callcounteruav( hardpointType, false );
	return true;
}

useKillstreakSatellite(hardpointType)
{
	if ( self maps\sp_killstreaks\_killstreakrules::isKillstreakAllowed( hardpointType, self.team ) == false )
		return false;

	if ( self maps\sp_killstreaks\_killstreakrules::killstreakStart( hardpointType, self.team ) == false )	 
		return false;

	self thread  maps\sp_killstreaks\_spyplane::callsatellite( hardpointType, false );
	return true;
}

useRadarItem( hardpointType, team, displayMessage )
{
	team = self.team;
	otherteam = "axis";
	if (team == "axis")
		otherteam = "allies";

	players = get_players();

	assert( isdefined( players ) );

	self maps\sp_killstreaks\_killstreaks::playKillstreakStartDialog( hardpointType, team );

	if ( !isdefined ( self.pers["spyplaneType"] ) )
		self.pers["spyplaneType"] = 0;
	currentTypeSpyplane = self.pers["spyplaneType"];
	if ( !isdefined ( self.pers["satelliteType"] ) )
		self.pers["satelliteType"] = 0;
	currentTypeSatellite = self.pers["satelliteType"];

	radarViewType = 0;
	normal = 1;
	fastSweep = 2;
	notifyString = "";
	isSatellite = false;
	isRadar = false;
	isCounterUAV = false;

	viewTime = level.radarViewTime;
	switch ( hardpointType )
	{
	case "radar_sp":
		{
			notifyString = "spyplane";
			isRadar = true;
			viewTime = level.spyplaneViewTime;

			level.globalKillstreaksCalled++;
		}
		break;
	case "radardirection_sp":
		{
			notifyString = "satellite";
			isSatellite = true;
			viewTime = level.radarLongViewTime;
			level notify( "satelliteInbound", team, self );

			level.globalKillstreaksCalled++;
		}
		break;
	case "counteruav_sp":
		{
			notifyString = "counteruav";
			isCounterUAV = true;
			viewTime = level.radarViewTime;
			level.globalKillstreaksCalled++;
		}
		break;
	}

	return viewTime;
}

radarDestroyed( team, otherteam ) 
{
	if ( !isdefined( level.spyplane[self.team]) || level.spyplane[self.team] == 0 )
	{
		level notify( "spyplane_sp_timer_kill_" + team);
	}
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

enemyObituaryText( type, numseconds )
{
	switch ( type )
	{
	case "radarupdate_sp":
		{	
			self iprintln( &"MP_WAR_RADAR_ACQUIRED_UPDATE_ENEMY", numseconds  );
		}	
		break;
	case "radardirection_sp":
		{
			self iprintln( &"MP_WAR_RADAR_ACQUIRED_DIRECTION_ENEMY", numseconds  );
		}	
		break;
	case "counteruav_sp":
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
	case "radarupdate_sp":
		{	
			self iprintln( &"MP_WAR_RADAR_UPDATE_ACQUIRED", callingPlayer, numseconds ); 
		}	
		break;
	case "radardirection_sp":
		{
			self iprintln( &"MP_WAR_RADAR_DIRECTION_ACQUIRED", callingPlayer, numseconds ); 
		}	
		break;
	case "counteruav_sp":
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

