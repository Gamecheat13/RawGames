#using scripts\codescripts\struct;

#using scripts\shared\challenges_shared;
#using scripts\shared\clientfield_shared;
#using scripts\shared\scoreevents_shared;
#using scripts\shared\util_shared;

    	   	                                                                                                                                         	                                	                                                                                                                                                                                                                                                                                                                                                                    	        	     	             	    	   	               	                                              	                                                           	                               	                     	                                                                                                           	                                                                 	                                                              	                                                                                                              	                            	                                     	                                       	                                                                                                              	   	                  	       	                                                    	                   	                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                        	                                  	                                                                                        	           	                        	                                            	                                             	                                                   	                                                             	                                                         	                                                                    	                                                                                                                                                                                                    	                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                         	                                                              	                                                          	                                   	                                   	                                                    	                                       	                                           	     	                                                                                                                                                                                                                                                      	                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                     
                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                            	                           	                           	                                                                                                                                                                                                                                                            	                                                                                                                                                                                                                                                                                                                                                                                       

#using scripts\cp\gametypes\_spawning;

#using scripts\cp\_challenges;
#using scripts\cp\_scoreevents;
#using scripts\cp\_util;
#using scripts\cp\killstreaks\_airsupport;
#using scripts\cp\killstreaks\_killstreakrules;
#using scripts\cp\killstreaks\_killstreaks;













	
#namespace planemortar;

#precache( "locationselector", "map_mortar_selector" );
#precache( "string", "MP_EARNED_PLANEMORTAR" );
#precache( "string", "KILLSTREAK_PLANEMORTAR_NOT_AVAILABLE" );
#precache( "string", "MP_WAR_PLANEMORTAR_INBOUND" );
#precache( "string", "MP_WAR_PLANEMORTAR_INBOUND_NEAR_YOUR_POSITION" );
#precache( "eventstring", "mpl_killstreak_planemortar" );
#precache( "fx", "_t6/vehicle/exhaust/fx_exhaust_f35_afterburner" );

function init()
{
	level.planeMortarExhaustFX = "_t6/vehicle/exhaust/fx_exhaust_f35_afterburner";
	clientfield::register( "scriptmover", "planemortar_contrail", 1, 1, "int" );
	killstreaks::register( "planemortar", "planemortar", "killstreak_planemortar", "planemortar_used",&useKillstreakPlaneMortar, true );
	killstreaks::register_strings( "planemortar", &"MP_EARNED_PLANEMORTAR", &"KILLSTREAK_PLANEMORTAR_NOT_AVAILABLE", &"MP_WAR_PLANEMORTAR_INBOUND", &"MP_WAR_PLANEMORTAR_INBOUND_NEAR_YOUR_POSITION" );
	killstreaks::register_dialog( "planemortar", "mpl_killstreak_planemortar", "kls_planemortar_used", "","kls_planemortar_enemy", "", "kls_planemortar_ready");
	killstreaks::register_dev_dvar( "planemortar", "scr_giveplanemortar" );
	killstreaks::set_team_kill_penalty_scale( "planemortar", level.teamKillReducedPenalty );
}

function useKillstreakPlaneMortar( hardpointType )
{	
	if ( self killstreakrules::isKillstreakAllowed( hardpointType, self.team ) == false )
	{
		return false;
	}
	
	self thread PlayPilotDialog( "a10_used", 1.5 );
	
	result = self selectPlaneMortarLocation( hardpointType );
	
	if ( !isdefined( result ) || !result )
	{
		return false;
	}
	
	return true;
}

function waittill_confirm_location()
{
	self endon( "emp_jammed" );
	self endon( "emp_grenaded" );

	self waittill( "confirm_location", location );
	
	return location;
}

function selectPlaneMortarLocation( hardpointType )
{
	self beginLocationMortarSelection( "map_mortar_selector", 800 );
	self.selectingLocation = true;

	self thread airsupport::endSelectionThink();

	locations = [];
	if (!isdefined(self.pers["mortarRadarUsed"]) || !self.pers["mortarRadarUsed"])
	{
		self thread singleRadarSweep();
	}
	
	for ( i = 0 ; i < 3 ; i++ )
	{
		location = self waittill_confirm_location();

		// if the player gets disconnected, self will be undefined
		if( !isdefined( self ) )
		   return false;
		   
		if ( !isdefined( location ) )
		{
			self.pers["mortarRadarUsed"] = true;
			self notify("cancel_selection");
			// selection was canceled		
			return false;
		}

		locations[i] = location;
	}

	if ( self killstreakrules::isKillstreakAllowed( hardpointType, self.team ) == false)
	{
		self.pers["mortarRadarUsed"] = true;
		self notify("cancel_selection");
		return false;
	}

	self.pers["mortarRadarUsed"] = false;
	
	return self airsupport::finishHardpointLocationUsage( locations,&usePlaneMortar );
}

function PlayPilotDialog( dialog, waitTime )
{
	if ( isdefined( waitTime ) )
	{
		wait ( waitTime );
	}
	
	self.pilotVoiceNumber = self.bcVoiceNumber + 1;

	soundAlias = level.teamPrefix[self.team] + self.pilotVoiceNumber + "_" + dialog;
	
	if ( isdefined( self ) )
	{
		if (self.pilotisSpeaking)
		{
			while (self.pilotisSpeaking)
			{
				wait (.2);
			}
		}
	}
	if ( isdefined( self ) )
	{
		self playLocalSound(soundAlias);
		self.pilotisSpeaking = true;
		self thread waitPlayBackTime( soundAlias ); 
		self util::waittill_any( soundAlias, "death", "disconnect" );
		
		//If the player disconnects we don't want to do this
		if( isdefined( self ) )
			self.pilotisSpeaking = false;
	}
}

function waitPlayBackTime( soundAlias )
{
	self endon ( "death" );
	self endon ( "disconnect" );

	playbackTime = soundgetplaybacktime ( soundAlias );
	
	if ( playbackTime >= 0 )
	{
		waitTime = playbackTime * .001;
		
		wait ( waitTime );
	}
	else
	{
		wait ( 1.0 );
	}
	self notify ( soundAlias );
}

function singleRadarSweep()
{
	self endon( "disconnect" );
	self endon("cancel_selection");

	// give a bit for the map to come up
	wait(0.5);
	
	self PlayLocalSound("mpl_killstreak_satellite");
	
	if ( level.teamBased )
	{
		has_satellite = ( level.activeSatellites[ self.team ] > 0 );
	}
	else
	{
		has_satellite = ( level.activeSatellites[ self.entnum ] > 0 );
	}

	if (self.hasSpyplane == 0 && !has_satellite && !level.forceRadar )
	{
		self thread doRadarSweep();
	}
}

function doRadarSweep()
{
	self setClientUIVisibilityFlag( "g_compassShowEnemies", 1 );
	
	wait ( 0.2 );		
	
	self setClientUIVisibilityFlag( "g_compassShowEnemies", 0 );
}

function usePlaneMortar( positions )
{
	team = self.team;
	killstreak_id = self killstreakrules::killstreakStart( "planemortar", team, false, true );
	if ( killstreak_id == -1 )
	{
		return false;
	}
	
	self killstreaks::play_killstreak_start_dialog( "planemortar", team, true );
	level.globalKillstreaksCalled++;
	self AddWeaponStat( GetWeapon( "planemortar" ), "used", 1 );
	self thread planeMortar_watchForEndNotify( team, killstreak_id );
	self thread doPlaneMortar( positions, team, killstreak_id );
	
	return true;
}

function doPlaneMortar( positions, team, killstreak_id )
{
	self endon( "emp_jammed" );
	self endon( "disconnect" );
	
	yaw = RandomIntRange( 0,360 );
	odd = 0;
	wait ( 1.25 );
	foreach( position in positions )
	{
		spawning::create_enemy_influencer( "artillery", position, team );
		self thread doBombRun( position, yaw, team );

		if (odd == 0)
		{
			yaw = ( yaw + 35 ) % 360;
		}
		else
		{
			yaw = ( yaw + 290 ) % 360;			
		}
		odd = ( odd + 1 ) % 2;
		
		wait 0.8;
	}
	
	self notify( "planemortarcomplete" );
	wait ( 1 );
	self thread plane_mortar_bda_dialog();
}

function plane_mortar_bda_dialog()
{
	
	if ( !isdefined( self.planeMortarBda ) )
	{
		self.planeMortarBda = 0;
	}
	
	if (self.planeMortarBda == 0)
	{
		bdaDialog = "kls_killn";
	}
	if (self.planeMortarBda == 1)
	{
		bdaDialog = "kls_kill1";
	}
	if (self.planeMortarBda == 2)
	{
		bdaDialog = "kls_kill2";
	}
	if (self.planeMortarBda == 3)
	{
		bdaDialog = "kls_kill3";
	}
	if (self.planeMortarBda > 3)
	{
		bdaDialog = "kls_killm";
	}	
	
	if (isdefined(bdaDialog))
	{
		//play pilot dialog
		self thread PlayPilotDialog( bdaDialog );	
	}
	
	self.planeMortarBda = 0;	
}

function planeMortar_watchForEndNotify( team, killstreak_id )
{
	self util::waittill_any( "disconnect", "joined_team", "joined_spectators", "planemortarcomplete", "emp_jammed" );

	planeMortar_killstreakStop( team, killstreak_id );
}

function planeMortar_killstreakStop( team, killstreak_id )
{
	killstreakrules::killstreakStop( "planemortar", team, killstreak_id );	
}
	

function doBombRun( position, yaw, team )
{
	self endon( "emp_jammed" );
	player = self;

	angles = (0,yaw,0);
	direction = AnglesToForward( angles );
	
	height = airsupport::getMinimumFlyHeight() + 2000;
	position = ( position[0], position[1], height );
	startPoint = position + VectorScale( direction, -1 * 12000 );
	endPoint = position + VectorScale( direction, 12000 * 1.5 );
	height = airsupport::getNoFlyZoneHeightCrossed( startPoint, endPoint, height );
	startPoint = ( startPoint[0], startPoint[1], height );
	position = ( position[0], position[1], height );
	endPoint = ( endPoint[0], endPoint[1], height );
	
	plane = SpawnPlane( self, "script_model", startPoint );
	plane.team = team;
	plane.targetname = "plane_mortar";
	plane.owner = self;
	
	plane endon( "delete" );
	plane endon( "death" );
	
	plane thread planeWatchForEmp( self );
	
	plane.angles = angles;
	plane SetModel( "veh_t6_air_fa38_killstreak" );
	plane SetEnemyModel( "veh_t6_air_fa38_killstreak_alt" );
	plane clientfield::set( "planemortar_contrail", 1 );
	plane playsound( "mpl_lightning_flyover_boom" );
	plane SetDrawInfrared( true );

	start = (position[0], position[1], plane.origin[2]);
	impact = BulletTrace( start, start + (0,0,-100000), true, plane);
		
	plane MoveTo( endpoint, ( 12000 * 2 / 12000 ) * 5/4, 0, 0 );				
	
	wait ( ( 12000 * 2 / 12000 ) /2 );
	if ( isdefined ( self ) ) 
	{
		self thread dropBomb( plane, position );
	}

	wait ( ( 12000 * 2 / 12000 ) * 3/4 );	
	plane Plane_CleanUpOnDeath();
}

function followBomb( plane, position, direction, impact, player )
{
	player endon( "emp_jammed" );
	
	wait ( ( 12000 * 2 / 12000 ) * 5 / 12 );
}

function lookAtExplosion( bomb )
{
	while (isdefined(self) && isdefined( bomb ))
	{
		angles = vectorToAngles( VectorNormalize( bomb.origin - self.origin ));
		self.angles = ( max(angles[0], 15), angles[1], angles[2] );
		{wait(.05);};
	}
}

function planeWatchForEmp( owner )
{
	self endon( "delete" );
	self endon( "death" );
	
	self waittill( "emp_deployed", attacker );

	thread planeAwardScoreEvent( attacker, self );

	// possibly play destroyed effect
	self Plane_CleanUpOnDeath();
}


function planeAwardScoreEvent( attacker, victim )
{
	attacker endon( "disconnect" );
	attacker notify( "planeAwardScoreEvent_singleton" );
	attacker endon( "planeAwardScoreEvent_singleton" );
	waittillframeend;
	
	scoreevents::processScoreEvent( "destroyed_plane_mortar", attacker, victim, "emp" );
	attacker challenges::addFlySwatterStat( "emp" );
}

function Plane_CleanUpOnDeath()
{
	self Delete();
}


function dropBomb( plane, bombPosition )
{
	if ( !isdefined( plane.owner ) )
		return;
		
	targets = getplayers();
	foreach( target in targets )
	{
		if( plane.owner util::IsEnemyPlayer(target) && Distance2DSquared( target.origin, bombPosition ) < 250000 )
		{
			if( BulletTracePassed( (target.origin[0], target.origin[1], plane.origin[2]), target.origin, false, plane) )
			{
				bombPosition = target.origin;
				break;
			}
		}
	}
	
	bombPosition = (bombPosition[0],bombPosition[1],plane.origin[2]);
	bomb = self LaunchBomb( GetWeapon( "planemortar" ), bombPosition, (0,0,-5000) );
	bomb playsound( "mpl_lightning_bomb_incoming" );
}