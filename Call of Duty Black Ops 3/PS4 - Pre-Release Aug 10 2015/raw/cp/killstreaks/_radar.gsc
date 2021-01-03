#using scripts\codescripts\struct;

#using scripts\shared\popups_shared;
#using scripts\shared\tweakables_shared;

    	   	                                                                                                                                         	                                	                                                                                                                                                                                                                                                                                                                                                                    	        	     	             	    	   	               	                                              	                                                           	                               	                     	                                                                                                           	                                                                 	                                                              	                                                                                                              	                            	                                     	                                       	                                                                                                              	   	                  	       	                                                    	                   	                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                        	                                  	                                                                                        	           	                        	                                            	                                             	                                                   	                                                             	                                                         	                                                                    	                                                                                                                                                                                                    	                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                         	                                                              	                                                          	                                   	                                   	                                                    	                                       	                                           	     	                                                                                                                                                                                                                                                      	                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                     

#using scripts\cp\killstreaks\_killstreakrules;
#using scripts\cp\killstreaks\_killstreaks;
#using scripts\cp\killstreaks\_spyplane;

#precache( "string", "KILLSTREAK_EARNED_RADAR" );
#precache( "string", "KILLSTREAK_RADAR_NOT_AVAILABLE" );
#precache( "string", "KILLSTREAK_RADAR_INBOUND" );
#precache( "string", "KILLSTREAK_EARNED_COUNTERUAV" );
#precache( "string", "KILLSTREAK_COUNTERUAV_NOT_AVAILABLE" );
#precache( "string", "KILLSTREAK_COUNTERUAV_INBOUND" );
#precache( "string", "KILLSTREAK_EARNED_SATELLITE" );
#precache( "string", "KILLSTREAK_SATELLITE_NOT_AVAILABLE" );
#precache( "string", "KILLSTREAK_SATELLITE_INBOUND" );
#precache( "eventstring", "mpl_killstreak_radar" );
#precache( "eventstring", "mpl_killstreak_satellite" );

#namespace radar;

function init()
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
	level.spyplaneViewTime = 25; // time spy plane remains active
	level.counterUAVViewTime = 30; // time counter UAV remains active
	level.radarLongViewTime = 45; // time radar remains active with fuel tanks killstreak

	// register the radar hardpoint
	if ( tweakables::getTweakableValue( "killstreak", "allowradar" ) )
	{
		killstreaks::register("radar", "radar", "killstreak_spyplane", "uav_used",&useKillstreakRadar);
		killstreaks::register_strings("radar", &"KILLSTREAK_EARNED_RADAR", &"KILLSTREAK_RADAR_NOT_AVAILABLE", &"KILLSTREAK_RADAR_INBOUND" );
		killstreaks::register_dialog("radar", "mpl_killstreak_radar", "kls_u2_used", "","kls_u2_enemy", "", "kls_u2_ready");
		killstreaks::register_dev_dvar("radar", "scr_giveradar");
		killstreaks::create_killstreak_timer( "radar" );
	}

	// register the ounteruav hardpoint
	if ( tweakables::getTweakableValue( "killstreak", "allowcounteruav" ) )
	{
		killstreaks::register("counteruav", "counteruav", "killstreak_counteruav", "counteruav_used",&useKillstreakCounterUAV);
		killstreaks::register_strings("counteruav", &"KILLSTREAK_EARNED_COUNTERUAV", &"KILLSTREAK_COUNTERUAV_NOT_AVAILABLE", &"KILLSTREAK_COUNTERUAV_INBOUND" );
		killstreaks::register_dialog("counteruav", "mpl_killstreak_radar", "kls_cu2_used", "","kls_cu2_enemy", "", "kls_cu2_ready");
		killstreaks::register_dev_dvar("counteruav", "scr_givecounteruav");
		killstreaks::create_killstreak_timer( "counteruav" );
	}

	// register the radar hardpoint
	if ( tweakables::getTweakableValue( "killstreak", "allowradardirection" ) )
	{
		killstreaks::register("radardirection", "radardirection", "killstreak_spyplane_direction", "uav_used",&useKillstreakSatellite );
		killstreaks::register_strings("radardirection", &"KILLSTREAK_EARNED_SATELLITE", &"KILLSTREAK_SATELLITE_NOT_AVAILABLE", &"KILLSTREAK_SATELLITE_INBOUND" );
		killstreaks::register_dialog("radardirection", "mpl_killstreak_satellite", "kls_sat_used", "","kls_sat_enemy", "", "kls_sat_ready");
		killstreaks::register_dev_dvar("radardirection", "scr_giveradardirection");
		killstreaks::create_killstreak_timer( "radardirection" );
	}
}

function useKillstreakRadar(hardpointType)
{
	if ( self killstreakrules::isKillstreakAllowed( hardpointType, self.team ) == false )
		return false;

	killstreak_id = self killstreakrules::killstreakStart( hardpointType, self.team );
	if (  killstreak_id == -1 )
		return false;

	return self spyplane::callspyplane( hardpointType, false, killstreak_id );
}

function useKillstreakCounterUAV(hardpointType)
{
	if ( self killstreakrules::isKillstreakAllowed( hardpointType, self.team ) == false )
		return false;

	killstreak_id = self killstreakrules::killstreakStart( hardpointType, self.team );
	if (  killstreak_id == -1 )
		return false;

	return self spyplane::callcounteruav( hardpointType, false, killstreak_id );
}

function useKillstreakSatellite(hardpointType)
{
	if ( self killstreakrules::isKillstreakAllowed( hardpointType, self.team ) == false )
		return false;

	killstreak_id = self killstreakrules::killstreakStart( hardpointType, self.team );
	if (  killstreak_id == -1 )
		return false;

	return self spyplane::callsatellite( hardpointType, false, killstreak_id );
}

function useRadarItem( hardpointType, team, displayMessage )
{
	team = self.team;

	assert( isdefined( level.players ) );

	self killstreaks::play_killstreak_start_dialog( hardpointType, team );

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
	case "radar":
		{
			notifyString = "spyplane";
			isRadar = true;
			viewTime = level.spyplaneViewTime;

			//self AddPlayerStat( "RECON_USED", 1 );
			level.globalKillstreaksCalled++;
			self AddWeaponStat( hardpointType, "used", 1 );
		}
		break;
	case "radardirection":
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
	case "counteruav":
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
			level thread popups::DisplayKillstreakTeamMessageToAll( hardpointType, self );
	}

	return viewTime;
}

function resetSpyplaneTypeOnEnd( type )
{
	self waittill( type + "_timer_kill" );
	self.pers["spyplane"] = 0;
}

function resetSatelliteTypeOnEnd( type )
{
	self waittill( type + "_timer_kill" );
	self.pers["satellite"] = 0;
}


function setTeamSpyplaneWrapper( team, value )
{
	setTeamSpyplane( team, value );

	if( team == "allies" )
		setMatchFlag( "radar_allies", value );
	else if ( team == "axis" ) 
		setMatchFlag( "radar_axis", value );

	if ( level.multiTeam == true )
	{
		foreach( player in level.players )
		{
			if ( player.team == team ) 
			{
				player setClientUIVisibilityFlag( "radar_client", value );
			}
		}
	}

	level notify( "radar_status_change", team );
}

function setTeamSatelliteWrapper( team, value )
{
	setTeamSatellite( team, value );

	if( team == "allies" )
		setMatchFlag( "radar_allies", value );
	else if ( team == "axis" ) 
		setMatchFlag( "radar_axis", value );

	if ( level.multiTeam == true )
	{
		foreach( player in level.players )
		{
			if ( player.team == team ) 
			{
				player setClientUIVisibilityFlag( "radar_client", value );
			}
		}
	}

	level notify( "radar_status_change", team );
}

function enemyObituaryText( type, numseconds )
{
	switch ( type )
	{
	case "radarupdate":
		{	
			self iprintln( &"MP_WAR_RADAR_ACQUIRED_UPDATE_ENEMY", numseconds  );
		}	
		break;
	case "radardirection":
		{
			self iprintln( &"MP_WAR_RADAR_ACQUIRED_DIRECTION_ENEMY", numseconds  );
		}	
		break;
	case "counteruav":
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

function friendlyObituaryText( type, callingPlayer, numseconds )
{
	switch ( type )
	{
	case "radarupdate":
		{	
			self iprintln( &"MP_WAR_RADAR_UPDATE_ACQUIRED", callingPlayer, numseconds ); 
		}	
		break;
	case "radardirection":
		{
			self iprintln( &"MP_WAR_RADAR_DIRECTION_ACQUIRED", callingPlayer, numseconds ); 
		}	
		break;
	case "counteruav":
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

