#using scripts\codescripts\struct;

#using scripts\mp\_popups;
#using scripts\mp\_util;
#using scripts\mp\gametypes\_hostmigration;
#using scripts\mp\killstreaks\_airsupport;
#using scripts\mp\killstreaks\_emp;
#using scripts\mp\killstreaks\_killstreakrules;
#using scripts\mp\killstreaks\_killstreaks;
#using scripts\mp\killstreaks\_placeables;
#using scripts\mp\teams\_teams;
#using scripts\mp\teams\_teams;

#using scripts\shared\callbacks_shared;
#using scripts\shared\clientfield_shared;
#using scripts\shared\entityheadicons_shared;
#using scripts\shared\hostmigration_shared;
#using scripts\shared\killstreaks_shared;
#using scripts\shared\killstreaks_shared;
#using scripts\shared\util_shared;
#using scripts\shared\weapons\_weaponobjects;
#using scripts\shared\scoreevents_shared;

                                                                                                          	                                              	                       	                   	                                                                         	                       	                                                      	                                                      	                                                       	                                                                                                 	                                                           	                 	                                                   	                	                                          	                                          	       	  	              	                                                  	                                                                 	                                                                  	                                                         	                                                   	                                                   	                                                                             	                                                                	                                                             	                                                             	                                   	                                   	                                                    	                                                    	                                                                                      	                                                         	                                                         	                                                               	                                                               	                                                   	                                                                	                                                     	                                                	                                                	                                                        	                                                                                                  	                                                                                 	                                            	                                                                                    	                                          	                       	                    
                                                                                                                                                                                                                                                                 	                                                                                     														            														           						                           														          														         														        														                      														                                                                                                                                           															      															                                                      	        	       	                	           
    	   	                                                                                                                         	                                                                                                                                                                                                                                                                                                                                                                    	        	     	             	    	   	                           	                               	                                	                                                              	                                                                                                              	                            	                                     	                                       	                                                               	   	                  	       	                                                    	                   	                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                        	                                                                                        	           	                        	                                            	                                             	                                                   	                                                             	                                                         	                                                                    	                                                                                                                                                                                                    	                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                      	                                                              	                                                          	                                   	                                   	                                                    	                                       

#precache( "string", "KILLSTREAK_EARNED_EMP" );
#precache( "string", "KILLSTREAK_EMP_NOT_AVAILABLE" );
#precache( "string", "KILLSTREAK_EMP_INBOUND" );
#precache( "eventstring", "mpl_killstreak_emp_activate" );

#precache( "fx", "killstreaks/fx_emp_core" );
#precache( "fx", "killstreaks/fx_emp_exp_death" );


#namespace emp;

function init()
{
	if ( level.teamBased )
	{
		foreach( team in level.teams )
		{
			level.ActiveEMPs[ team ] = false;
		}
	}
	
	level.enemyEMPActiveFunc = &EnemyEMPActive;
	
	level thread EMPTracker();
	
	killstreaks::register( "emp", "emp", "killstreak_emp", "emp_used", &ActivateEMP );
	killstreaks::register_strings( "emp", &"KILLSTREAK_EARNED_EMP", &"KILLSTREAK_EMP_NOT_AVAILABLE", &"KILLSTREAK_EMP_INBOUND" );
	killstreaks::register_dialog( "emp", "mpl_killstreak_emp_activate", 5, undefined, 96, 114, 96 );
	
	callback::on_spawned( &OnPlayerSpawned );
	callback::on_connect( &OnPlayerConnect );
}

function OnPlayerSpawned()
{
	self endon( "disconnect" );
	self setEMPJammed( self EnemyEMPActive() );
}

function OnPlayerConnect()
{
	self.entNum = self getEntityNumber();
	level.ActiveEMPs[ self.entNum ] = 0;
}

function ActivateEMP()
{
	player = self;
	
	killstreakId = player killstreakrules::killstreakStart( "emp", player.team, false, false );
	if( killstreakId == (-1) )
	{
		return false;
	}
	
	maxhealth = ( 3000 );
	
	tableHealth = killstreaks::get_max_health( "emp" );
	
	if ( isdefined( tableHealth ) )
	{
		maxhealth = tableHealth;
	}	
	
	empBase = player placeables::SpawnPlaceable( "emp", killstreakId, &OnPlaceEMP, &OnCancelPlacement, undefined, &OnShutdown, &OnDeath, undefined,
	                                           	 "wpn_t7_turret_emp_core", "wpn_t7_turret_emp_core_yellow", "wpn_t7_turret_emp_core_red", "", ( 40000 ), ( 3000 ), 0 );
	
	event = empBase util::waittill_any_return( "placed", "cancelled", "death" );
	if( event != "placed" )
	{
		return false;
	}
	
	return true;
}

function OnPlaceEMP( emp )
{
	player = self;
	
	player thread EMP_JamEnemies( emp.killstreakId );
	
	player.EMPTime = GetTime();
	player killstreaks::play_killstreak_start_dialog( "emp", player.pers["team"] );
	player AddWeaponStat( GetWeapon( "emp" ), "used", 1 );
	
	level thread popups::DisplayKillstreakTeamMessageToAll( "emp", player );
	
	emp clientfield::set( "enemyvehicle", 1 );
	emp playsound( "mpl_emp_turret_activate" );
	
	emp thread PlayEMPFx();
	emp thread entityheadicons::setEntityHeadIcon( player.team, player, ( 0, 0, 90 ) );
}

function PlayEMPFx()
{
	emp = self;
	
	tagOffset = ( -25, 0, 55 );
	fxId = PlayFxOnTag( "killstreaks/fx_emp_core", emp, "tag_fx" );
	emp playloopsound( "mpl_emp_turret_loop_close" );

	fxTagOrigin = emp GetTagorigin( "tag_fx" );
	emp killstreaks::WaitForTimeout( "emp", ( 40000 ),  "death" );
	PlayFx( "killstreaks/fx_emp_exp_death", fxTagOrigin );
	playsoundatposition( "mpl_emp_turret_deactivate", fxTagOrigin );
}

function OnCancelPlacement( emp )
{
	StopEMP( emp.team, emp.ownerEntNum, emp.killstreakId );
}

function OnDeath( attacker, weapon )
{
	turret = self;
	scoreevents::processScoreEvent( "destroyed_emp", attacker, turret, weapon );
}

function OnShutdown( emp )
{
	StopEMP( emp.team, emp.ownerEntNum, emp.killstreakId );
}

function StopEMP( team, ownerEntNum, killstreakId )
{
	if( level.teamBased )
	{
		level.ActiveEMPs[ team ] = false;
	}
	
	level.ActiveEMPs[ ownerEntNum ] = false;
	level notify ( "emp_updated" );
	
	killstreakrules::killstreakStop( "emp", team, killstreakId );
}

function HasActiveEMP()
{
	return ( level.ActiveEMPs[ self.entNum ] > 0 );
}

function TeamHasActiveEMP( team )
{
	return ( level.ActiveEMPs[ team ] > 0 );
}

function EnemyEMPActive()
{
	if( level.teamBased )
	{
		foreach( team in level.teams )
		{
			if( ( team != self.team ) && TeamHasActiveEMP( team ) )
			{
				return true;
			}
		}
	}
	else
	{
		enemies = self teams::GetEnemyPlayers();
		foreach( player in enemies )
		{
			if( player HasActiveEMP() )
			{
				return true;
			}
		}
	}
	
	return false;
}

function EMP_JamEnemies( killstreak_id )
{
	level endon ( "game_ended" );
	
	if( level.teamBased )
	{
		level.ActiveEMPs[ self.team ] = true;
	}
	
	level.ActiveEMPs[ self.entNum ] = true;
	level notify( "emp_updated" );
	level notify( "emp_deployed" );
	
	enemies = self teams::GetEnemyPlayers();
	
	VisionSetNaked( "flash_grenade", 1.5 );
	wait ( 0.1 );
	VisionSetNaked( "flash_grenade", 0 );
	VisionSetNaked( GetDvarString( "mapname" ), 5.0 );
	
	level killstreaks::DestroyOtherTeamsActiveVehicles( self, GetWeapon( "emp" ) );
	level killstreaks::DestroyOtherTeamsEquipment( self, GetWeapon( "emp" ) );
}

function EMPTracker()
{
	level endon ( "game_ended" );
	
	while( true )
	{
		level waittill( "emp_updated" );
		
		foreach ( player in level.players )
		{
			if( isdefined( player.empGrenaded ) && player.empGrenaded == true )
			{
				continue;
			}
			
			emped = player EnemyEMPActive();
			player setEMPJammed( emped );
			player clientfield::set_to_player( "empd", emped );
			
			if( emped )
			{
				player notify( "emp_jammed" );
			}
		}
	}
}
