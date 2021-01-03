#using scripts\codescripts\struct;

#using scripts\shared\challenges_shared;
#using scripts\shared\clientfield_shared;
#using scripts\shared\scoreevents_shared;
#using scripts\shared\util_shared;

#using scripts\mp\_challenges;
#using scripts\mp\_util;
#using scripts\mp\gametypes\_spawning;
#using scripts\mp\killstreaks\_airsupport;
#using scripts\mp\killstreaks\_killstreakrules;
#using scripts\mp\killstreaks\_killstreaks;
#using scripts\mp\killstreaks\_satellite;
#using scripts\mp\killstreaks\_planemortar;
#using scripts\mp\killstreaks\_killstreak_bundles;

  
                                                                                                  	  	                          	                                         	                     	                 	                                                                         	                       	                                                      	                                                      	                                                       	                                                                                                  	                                                           	                 	                                                                                                           	                	                                          	                                      	       	  	             	                                                     	                                                                             	                         	                                                                	                                                             	                                                             	                                                                                      	                                                         	                                                         	                                                               	                                                               	                                                   	                                                                	                                                     	                                                	                                                	                                                        	                                                                                                  	                                                                             	                                            	                                                                                    	                                          	                     	                                              	                                        	         	     
    	   	                                                                                                                                         	                                	                                                                                                                                                                                                                                                                                                                                                                    	        	     	             	    	   	               	                                              	                                                           	                               	                     	                                                                                                           	                                                                 	                                                              	                                                                                                              	                            	                                     	                                       	                                                                                                              	   	                  	       	                                                    	                   	                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                        	                                  	                                                                                        	           	                        	                                            	                                             	                                                   	                                                             	                                                         	                                                                    	                                                                                                                                                                                                    	                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                         	                                                              	                                                          	                                   	                                   	                                                    	                                       	                                           	     	                                                                                                                                                                                                                                                      	                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                     
                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                            	                           	                           	                                                                                                                                                                                                                                                            	                                                                                                                                                                                                                                                                                                                                                                                       

#namespace drone_strike;


#precache( "locationselector", "map_directional_selector" );
#precache( "string", "KILLSTREAK_DRONE_STRIKE_NOT_AVAILABLE" );
#precache( "string", "KILLSTREAK_DRONE_STRIKE_EARNED" );
#precache( "string", "KILLSTREAK_DRONE_STRIKE_INBOUND" );
#precache( "string", "KILLSTREAK_DRONE_STRIKE_INBOUND_NEAR_PLAYER" );
#precache( "string", "KILLSTREAK_DRONE_STRIKE_HACKED" );
#precache( "string", "KILLSTREAK_DESTROYED_DRONE_STRIKE" );

#precache( "eventstring", "mpl_killstreak_DRONE_STRIKE" );
#precache( "fx", "killstreaks/fx_rolling_thunder_thruster_trails" );
	
function init()
{
	killstreaks::register( "drone_strike", "drone_strike", "killstreak_drone_strike", "drone_strike_used", &ActivateDroneStrike, true );
	killstreaks::register_strings( "drone_strike", &"KILLSTREAK_DRONE_STRIKE_EARNED", &"KILLSTREAK_DRONE_STRIKE_NOT_AVAILABLE", &"KILLSTREAK_DRONE_STRIKE_INBOUND", &"KILLSTREAK_DRONE_STRIKE_INBOUND_NEAR_PLAYER", &"KILLSTREAK_DRONE_STRIKE_HACKED" );
	killstreaks::register_dialog( "drone_strike", "mpl_killstreak_drone_strike", "droneStrikeDialogBundle", undefined, "friendlyDroneStrike", "enemyDroneStrike", "enemyDroneStrikeMultiple", "friendlyDroneStrikeHacked", "enemyDroneStrikeHacked", "requestDroneStrike", "threatDroneStrike" );
	killstreaks::set_team_kill_penalty_scale( "drone_strike", level.teamKillReducedPenalty );
}

function ActivateDroneStrike()
{
	if ( self killstreakrules::isKillstreakAllowed( "drone_strike", self.team ) == false )
	{
		return false;
	}
	
	result = self SelectDroneStrikePath();
	
	if ( !isdefined( result ) || !result )
	{
		return false;
	}
	
	return true;
}

function SelectDroneStrikePath()
{
	self BeginLocationNapalmSelection( "map_directional_selector" );
	self.selectingLocation = true;
	self thread airsupport::EndSelectionThink();

	locations = [];
	if( !isdefined( self.pers["drone_strike_radar_used"] ) || !self.pers["drone_strike_radar_used"] )
	{
		self thread planemortar::SingleRadarSweep();
	}
	
	location = self WaitForLocationSelection();

	// if the player gets disconnected, self will be undefined
	if( !isdefined( self ) )
	{
	   return false;
	}
	   
	if ( !isdefined( location.origin ) )
	{
		self.pers["drone_strike_radar_used"] = true;
		self notify( "cancel_selection" );
		return false;
	}

	if ( self killstreakrules::isKillstreakAllowed( "drone_strike", self.team ) == false)
	{
		self.pers["drone_strike_radar_used"] = true;
		self notify("cancel_selection");
		return false;
	}

	self.pers["drone_strike_radar_used"] = false;
	return self airsupport::finishHardpointLocationUsage( location, &DroneStrikeLocationSelected );
}

function WaitForLocationSelection()
{
	self endon( "emp_jammed" );
	self endon( "emp_grenaded" );

	self waittill( "confirm_location", location, yaw );
	
	locationInfo = SpawnStruct();
	locationInfo.origin = location;
	locationInfo.yaw = yaw;
	
	return locationInfo;
}

function DroneStrikeLocationSelected( location )
{
	team = self.team;
	killstreak_id = self killstreakrules::killstreakStart( "drone_strike", team, false, true );
	if( killstreak_id == (-1) )
	{
		return false;
	}
	
	self killstreaks::play_killstreak_start_dialog( "drone_strike", team, killstreak_id );
	self AddWeaponStat( GetWeapon( "drone_strike" ), "used", 1 );
	
	spawn_influencer = level spawning::create_enemy_influencer( "artillery", location.origin, team );
	
	self thread WatchForKillstreakEnd( team, spawn_influencer, killstreak_id );
	self thread StartDroneStrike( location.origin, location.yaw, team );
	
	return true;
}

function WatchForKillstreakEnd( team, influencer, killstreak_id )
{
	self util::waittill_any( "disconnect", "joined_team", "joined_spectators", "drone_strike_complete", "emp_jammed" );
	killstreakrules::killstreakStop( "drone_strike", team, killstreak_id );
}

function StartDroneStrike( position, yaw, team )
{
	self endon( "emp_jammed" );
	self endon( "joined_team" );
	self endon( "joined_spectators" );
	self endon( "disconnect" );

	angles = ( 0, yaw, 0 );
	direction = AnglesToForward( angles );
	height = airsupport::getMinimumFlyHeight() + ( 5000 );
	
	selectedPosition = ( position[0], position[1], height );
	startPoint = selectedPosition + VectorScale( direction, ( -14000 ) );
	endPoint = selectedPosition + VectorScale( direction, ( -8000 ) );
	
	// trace to get the target point
	traceStartPos = ( position[0], position[1], height );
	traceEndPos = ( position[0], position[1], -height ); 
	trace = BulletTrace( traceStartPos, traceEndPos, 0, undefined );
	targetPoint = ( ( trace[ "fraction" ] < 1.0 ) ? trace[ "position" ] : ( position[0], position[1], 0.0 ) );
	
	///#sphere( targetPoint, 20, ( 1, 0, 0 ), 1, true, 10, 400 );#/
	
	initialOffset = -VectorScale( direction, ( ( ( 7 ) * 0.5 ) - 1 ) * ( 500 ) );
	
	for( i = 0; i < ( 7 ); i++ )
	{
		right = AnglesToRight( angles );
		rightOffset = VectorScale( right, ( 150 ) );
		forwardOffset = endPoint + initialOffset + VectorScale( direction, i * ( 500 ) );
		
		self thread SpawnDrone( startPoint + rightOffset, forwardOffset + rightOffset, targetPoint, angles, self.team );
		self thread SpawnDrone( startPoint - rightOffset, forwardOffset - rightOffset, targetPoint, angles, self.team );
		wait( ( 1 ) );
		
		self playsound ("mpl_thunder_flyover_wash");
	}
	
	wait( 3 ); //Wait for the last drone to explode
	self notify( "drone_strike_complete" );
}

function SpawnDrone( startPoint, endPoint, targetPoint, angles, team )
{
	drone = SpawnPlane( self, "script_model", startPoint );
	drone.team = team;
	drone.targetname = "drone_strike";
	drone SetOwner( self );
	drone.owner = self;
	drone.owner thread WatchOwnerEvents( drone );
	
	drone endon( "delete" );
	drone endon( "death" );
	
	drone.angles = angles;
	drone SetModel( "veh_t7_drone_rolling_thunder" );
	drone SetEnemyModel( "veh_t7_drone_rolling_thunder" );
	
	drone.owner thread WatchOwnerEvents( drone );
	
	drone endon( "delete" );
	drone endon( "death" );
	
	PlayFxOnTag( "killstreaks/fx_rolling_thunder_thruster_trails", drone, "tag_fx");
	drone clientfield::set( "enemyvehicle", 1 );
	
	drone SetupDamageHandling();
	drone thread WatchForEmp( self );
	
	drone MoveTo( endpoint, ( 5 ), 0, 0 );				
	wait ( ( 5 ) );
	
	weapon = GetWeapon( "drone_strike" );
	velocity = drone GetVelocity();
	
	halfGravity = 386;
	dXY = Abs( ( -8000 ) );
	dZ = endPoint[2] - targetPoint[2];
	dVxy = dXY * sqrt( halfGravity / dZ );
	
	nvel = VectorNormalize( velocity );
	launchVel = nvel * dVxy;
	
	bomb = self LaunchBomb( weapon, drone.origin, launchVel );
	bomb clientfield::set( "enemyvehicle", 1 );	
	bomb.targetname = "drone_strike";
	bomb SetOwner( self );
	bomb.owner = self;
	bomb.team = team;
	bomb playsound( "mpl_thunder_incoming_start" );
	bomb SetupDamageHandling();
	bomb thread WatchForEmp( self );
	
	bomb.owner thread WatchOwnerEvents( bomb );
	
	{wait(.05);};
	
	drone Hide();
	
	{wait(.05);};
	
	drone Delete();
}

function SetupDamageHandling()
{
	drone = self;
	drone SetCanDamage( true );
	drone.maxhealth = killstreak_bundles::get_max_health( "drone_strike" );
	drone.lowhealth = killstreak_bundles::get_low_health( "drone_strike" );
	drone.health = drone.maxhealth;
	drone thread killstreaks::MonitorDamage( "drone_strike", drone.maxhealth, &DestroyDronePlane, drone.lowhealth, undefined, 0, &EmpDamageDrone, true );
}

function DestroyDronePlane( attacker, weapon )
{	
	if( isdefined( attacker ) && ( !isdefined( self.owner ) ||  self.owner util::IsEnemyPlayer( attacker ) ) )
	{
		scoreevents::processScoreEvent( "destroyed_drone_strike", attacker, self.owner, weapon );
		LUINotifyEvent( &"player_callout", 2, &"KILLSTREAK_DESTROYED_DRONE_STRIKE", attacker.entnum );
	}
	
	params = level.killstreakBundle["drone_strike"];
	if( isdefined( params.ksExplosionFX ) )
		PlayFXOnTag( params.ksExplosionFX, self, "tag_origin" );
	
	self setModel( "tag_origin" );

	wait( 0.5 );

	self delete();
}

function WatchOwnerEvents( bomb )
{
	player = self;
	
	bomb endon( "death" );
	
	player util::waittill_any( "disconnect", "joined_team", "joined_spectators" );
	
	if( isdefined( isalive( bomb ) ) )
		bomb delete();
}

function WatchForEmp( owner )
{
	self endon( "delete" );
	self endon( "death" );
	
	self waittill( "emp_deployed", attacker );

	thread DroneStrikeAwardEMPScoreEvent( attacker, self );
	self BlowUpDroneStrike();
}

function EmpDamageDrone( attacker )
{
	thread DroneStrikeAwardEMPScoreEvent( attacker, self );
	self BlowUpDroneStrike();
}

function DroneStrikeAwardEMPScoreEvent( attacker, victim )
{
	attacker endon( "disconnect" );
	attacker notify( "DroneStrikeAwardScoreEvent_singleton" );
	attacker endon( "DroneStrikeAwardScoreEvent_singleton" );
	waittillframeend;
	
	scoreevents::processScoreEvent( "destroyed_rolling_thunder_all_drones", attacker, victim, GetWeapon( "emp" ) );
}

function BlowUpDroneStrike()
{
	self delete();
}
