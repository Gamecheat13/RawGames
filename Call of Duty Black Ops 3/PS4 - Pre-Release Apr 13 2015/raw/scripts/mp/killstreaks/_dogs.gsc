#using scripts\codescripts\struct;

#using scripts\shared\challenges_shared;
#using scripts\shared\clientfield_shared;
#using scripts\shared\scoreevents_shared;
#using scripts\shared\util_shared;

#using scripts\mp\gametypes\_spawning;
#using scripts\mp\_challenges;
#using scripts\mp\_util;
#using scripts\mp\killstreaks\_airsupport;
#using scripts\mp\killstreaks\_killstreakrules;
#using scripts\mp\killstreaks\_killstreaks;
#using scripts\mp\killstreaks\_satellite;
#using scripts\mp\killstreaks\_planemortar;

    	   	                                                                                                                         	                                                                                                                                                                                                                                                                                                                                                                    	        	     	             	    	   	                           	                               	                                	                                                              	                                                                                                              	                            	                                     	                                       	                                                               	   	                  	       	                                                    	                   	                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                        	                                                                                        	           	                        	                                            	                                             	                                                   	                                                             	                                                         	                                                                    	                                                                                                                                                                                                    	                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                      	                                                              	                                                          	                                   	                                   	                                                    	                                       
                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                            	                                                                                                                                                                                                                                                                                                                                                                                       
                                                                                                          	                                              	                       	                   	                                                                         	                       	                                                      	                                                      	                                                       	                                                                                                 	                                                           	                 	                                                   	                	                                          	                                          	       	  	              	                                                  	                                                                 	                                                                  	                                                         	                                                   	                                                   	                                                                             	                                                                	                                                             	                                                             	                                   	                                   	                                                    	                                                    	                                                                                      	                                                         	                                                         	                                                               	                                                               	                                                   	                                                                	                                                     	                                                	                                                	                                                        	                                                                                                  	                                                                                 	                                            	                                                                                    	                                          	                       	                    
                                                                                                                                                                                                                                                                 	                                                                                     														            														           						                           														          														         														        														                      														                                                                                                                                           															      															                                                      	        	       	                	           

#namespace drone_strike;


#precache( "locationselector", "map_directional_selector" );
#precache( "string", "KILLSTREAK_DRONE_STRIKE_NOT_AVAILABLE" );
#precache( "string", "KILLSTREAK_DRONE_STRIKE_EARNED" );
#precache( "string", "KILLSTREAK_DRONE_STRIKE_INBOUND" );
#precache( "string", "KILLSTREAK_DRONE_STRIKE_INBOUND_NEAR_PLAYER" );
#precache( "eventstring", "mpl_killstreak_DRONE_STRIKE" );
	
function init()
{
	killstreaks::register( "drone_strike", "drone_strike", "killstreak_drone_strike", "drone_strike_used", &ActivateDroneStrike, true );
	killstreaks::register_strings( "drone_strike", &"KILLSTREAK_DRONE_STRIKE_EARNED", &"KILLSTREAK_DRONE_STRIKE_NOT_AVAILABLE", &"KILLSTREAK_DRONE_STRIKE_INBOUND", &"KILLSTREAK_DRONE_STRIKE_INBOUND_NEAR_PLAYER" );
	killstreaks::register_dialog( "drone_strike", "mpl_killstreak_drone_strike", 26, undefined, 104, 122, 104 );
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
	
	self killstreaks::play_killstreak_start_dialog( "drone_strike", team, true );
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
	angles = ( 0, yaw, 0 );
	direction = AnglesToForward( angles );
	height = airsupport::getMinimumFlyHeight() + ( 2000 );
	
	selectedPosition = ( position[0], position[1], height );
	startPoint = selectedPosition + VectorScale( direction, ( -14000 ) );
	endPoint = selectedPosition + VectorScale( direction, ( -8000 ) );
	
	for( i = 0; i < ( 6 ); i++ )
	{
		right = AnglesToRight( angles );
		rightOffset = VectorScale( right, ( 150 ) );
		forwardOffset = endPoint + VectorScale( direction, i * ( 100 ) );
		
		self thread SpawnDrone( startPoint + rightOffset, forwardOffset + rightOffset, angles, self.team );
		self thread SpawnDrone( startPoint - rightOffset, forwardOffset - rightOffset, angles, self.team );
		wait( ( 1 ) );
	}
	
	wait( 3 ); //Wait for the last drone to explode
	self notify( "drone_strike_complete" );
}

function SpawnDrone( startPoint, endPoint, angles, team )
{
	drone = SpawnPlane( self, "script_model", startPoint );
	drone.team = team;
	drone.targetname = "plane_mortar";
	drone.owner = self;
	
	drone endon( "delete" );
	drone endon( "death" );
	
	drone.angles = angles;
	drone SetModel( "veh_t7_mil_bomber" );
	drone SetEnemyModel( "veh_t7_mil_bomber" );
	drone clientfield::set( "planemortar_contrail", 1 );
	drone clientfield::set( "enemyvehicle", 1 );
	drone playsound( "mpl_lightning_flyover_boom" );
	drone SetDrawInfrared( true );
	
	drone MoveTo( endpoint, ( 3 ), 0, 0 );				
	wait ( ( 3 ) );
	
	weapon = GetWeapon( "drone_strike" );
	velocity = drone GetVelocity();
	bomb = self LaunchBomb( weapon, drone.origin, velocity + ( 0, 0, ( -50 ) ) );
	
	wait( 0.1 );
	drone Delete();
}
