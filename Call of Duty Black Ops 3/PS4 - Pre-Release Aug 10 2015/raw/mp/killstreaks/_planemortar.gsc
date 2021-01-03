#using scripts\codescripts\struct;

#using scripts\shared\challenges_shared;
#using scripts\shared\clientfield_shared;
#using scripts\shared\scoreevents_shared;
#using scripts\shared\util_shared;

#using scripts\mp\_challenges;
#using scripts\mp\_util;
#using scripts\mp\gametypes\_battlechatter;
#using scripts\mp\gametypes\_globallogic_audio;
#using scripts\mp\gametypes\_spawning;
#using scripts\mp\killstreaks\_airsupport;
#using scripts\mp\killstreaks\_killstreakrules;
#using scripts\mp\killstreaks\_killstreaks;
#using scripts\mp\killstreaks\_satellite;

  
    	   	                                                                                                                                         	                                	                                                                                                                                                                                                                                                                                                                                                                    	        	     	             	    	   	               	                                              	                                                           	                               	                     	                                                                                                           	                                                                 	                                                              	                                                                                                              	                            	                                     	                                       	                                                                                                              	   	                  	       	                                                    	                   	                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                        	                                  	                                                                                        	           	                        	                                            	                                             	                                                   	                                                             	                                                         	                                                                    	                                                                                                                                                                                                    	                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                         	                                                              	                                                          	                                   	                                   	                                                    	                                       	                                           	     	                                                                                                                                                                                                                                                      	                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                     
                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                            	                           	                           	                                                                                                                                                                                                                                                            	                                                                                                                                                                                                                                                                                                                                                                                       














	
#precache( "locationselector", "map_mortar_selector" );
#precache( "locationselector", "map_mortar_selector_done" );
#precache( "string", "MP_EARNED_PLANEMORTAR" );
#precache( "string", "KILLSTREAK_PLANEMORTAR_NOT_AVAILABLE" );
#precache( "string", "MP_WAR_PLANEMORTAR_INBOUND" );
#precache( "string", "MP_WAR_PLANEMORTAR_INBOUND_NEAR_YOUR_POSITION" );
#precache( "string", "KILLSTREAK_PLANEMORTAR_HACKED" );
#precache( "eventstring", "mpl_killstreak_planemortar" );
#precache( "fx", "killstreaks/fx_ls_exhaust_afterburner" );

#namespace planemortar;

function init()
{
	level.planeMortarExhaustFX = "killstreaks/fx_ls_exhaust_afterburner";
	clientfield::register( "scriptmover", "planemortar_contrail", 1, 1, "int" );
	killstreaks::register( "planemortar", "planemortar", "killstreak_planemortar", "planemortar_used",&useKillstreakPlaneMortar, true );
	killstreaks::register_strings( "planemortar", &"MP_EARNED_PLANEMORTAR", &"KILLSTREAK_PLANEMORTAR_NOT_AVAILABLE", &"MP_WAR_PLANEMORTAR_INBOUND", &"MP_WAR_PLANEMORTAR_INBOUND_NEAR_YOUR_POSITION", &"KILLSTREAK_PLANEMORTAR_HACKED" );
	killstreaks::register_dialog( "planemortar", "mpl_killstreak_planemortar", "planeMortarDialogBundle", "planeMortarPilotDialogBundle", "friendlyPlaneMortar", "enemyPlaneMortar", "enemyPlaneMortarMultiple", "friendlyPlaneMortarHacked", "enemyPlaneMortarHacked", "requestPlaneMortar" );
	killstreaks::set_team_kill_penalty_scale( "planemortar", level.teamKillReducedPenalty );
}

function useKillstreakPlaneMortar( hardpointType )
{	
	if ( self killstreakrules::isKillstreakAllowed( hardpointType, self.team ) == false )
	{
		return false;
	}
	
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
	self beginLocationMortarSelection( "map_mortar_selector", 800, "map_mortar_selector_done" );
	self.selectingLocation = true;
	
	self thread airsupport::endSelectionThink();

	locations = [];
	if (!isdefined(self.pers["mortarRadarUsed"]) || !self.pers["mortarRadarUsed"])
	{
		self thread singleRadarSweep();
		
		otherTeam = util::getOtherTeam( self.team );
		globallogic_audio::leader_dialog( "enemyPlaneMortarUsed", otherTeam );
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
		has_satellite = satellite::HasSatellite( self.team );
	}
	else
	{
		has_satellite = satellite::HasSatellite( self.entnum );
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
		
	self killstreaks::play_killstreak_start_dialog( "planemortar", team, killstreak_id );
	
	self.planeMortarPilotIndex = killstreaks::get_random_pilot_index( "planemortar" );
	self killstreaks::play_pilot_dialog( "arrive", "planemortar", undefined, self.planeMortarPilotIndex );
	
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
	wait ( 2.5 );
	foreach( position in positions )
	{
		level spawning::create_enemy_influencer( "artillery", position, team );
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
	if ( isdefined( self.planeMortarBda ) )
	{
		if (self.planeMortarBda === 1)
		{
			bdaDialog = "kill1";
		}
		else if (self.planeMortarBda === 2)
		{
			bdaDialog = "kill2";
		}
		else if (self.planeMortarBda === 3)
		{
			bdaDialog = "kill3";
		}
		else if (isdefined( self.planeMortarBda ) && self.planeMortarBda > 3)
		{
			bdaDialog = "killMultiple";
		}

		self killstreaks::play_pilot_dialog( bdaDialog, "planemortar", undefined, self.planeMortarPilotIndex );
		
		if ( battlechatter::dialog_chance( "taacomPilotKillConfirmChance" ) )
		{
			self killstreaks::play_taacom_dialog_response( "killConfirmed", "planemortar", undefined, self.planeMortarPilotIndex );		
		}
		else
		{
			self globallogic_audio::play_taacom_dialog( "confirmHit" );
		}
	}
	else
	{
		killstreaks::play_pilot_dialog( "killNone", "planemortar", undefined, self.planeMortarPilotIndex );
		globallogic_audio::play_taacom_dialog( "confirmMiss" );
	}
	
	self.planeMortarBda = undefined;
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
	plane SetModel( "veh_t7_mil_vtol_fighter_mp" );
	plane SetEnemyModel( "veh_t7_mil_vtol_fighter_mp_dark" );
	plane clientfield::set( "planemortar_contrail", 1 );
	plane clientfield::set( "enemyvehicle", 1 );
	plane playsound( "mpl_lightning_flyover_boom" );
	plane SetDrawInfrared( true );
	
	plane.killcamEnt = spawn( "script_model", plane.origin+(0,0,700)+VectorScale( direction, -1 * 1500 ) );
	plane.killcamEnt util::deleteAfterTime( ( 12000 * 2 / 12000 ) * 3 );
	plane.killcamEnt.angles = (15,yaw,0);
	plane.killcamEnt.startTime = gettime();
	plane.killcamEnt LinkTo( plane );
	start = (position[0], position[1], plane.origin[2]);
	impact = BulletTrace( start, start + (0,0,-100000), true, plane);
		
	plane MoveTo( endpoint, ( 12000 * 2 / 12000 ) * 5/4, 0, 0 );				
	
	plane.killcamEnt thread followBomb( plane, position, direction, impact, player );
	
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
	plane.killcamEnt Unlink();
	plane.killcamEnt MoveTo( impact["position"] + (0,0,1000) + VectorScale( direction, -1 * 600 ), 0.8, 0, 0.2);
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
	
	scoreevents::processScoreEvent( "destroyed_plane_mortar", attacker, victim, GetWeapon( "emp" ) );
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
	bomb.soundmod = "heli";
	bomb playsound( "mpl_lightning_bomb_incoming" );
	bomb.killcamEnt = plane.killcamEnt;
	plane.killcamEnt thread lookAtExplosion( bomb );
}