#using scripts\codescripts\struct;

#using scripts\shared\array_shared;
#using scripts\shared\callbacks_shared;
#using scripts\shared\clientfield_shared;
#using scripts\shared\duplicaterender_mgr;
#using scripts\shared\filter_shared;
#using scripts\shared\util_shared;


                                                                                
  
    	   	                                                                                                                                         	                                	                                                                                                                                                                                                                                                                                                                                                                    	        	     	             	    	   	               	                                              	                                                           	                               	                     	                                                                                                           	                                                                 	                                                              	                                                                                                              	                            	                                     	                                       	                                                                                                              	   	                  	       	                                                    	                   	                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                        	                                  	                                                                                        	           	                        	                                            	                                             	                                                   	                                                             	                                                         	                                                                    	                                                                                                                                                                                                    	                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                         	                                                              	                                                          	                                   	                                   	                                                    	                                       	                                           	     	                                                                                                                                                                                                                                                      	                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                     
                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                            	                           	                           	                                                                                                                                                                                                                                                            	                                                                                                                                                                                                                                                                                                                                                                                       
   

#using scripts\shared\system_shared;

#namespace killstreak_detect;

function autoexec __init__sytem__() {     system::register("killstreak_detect",&__init__,undefined,undefined);    }	


function __init__()
{
	callback::on_spawned( &on_player_spawned );
		
	clientfield::register( "scriptmover", "enemyvehicle", 1, 2, "int", &enemyScriptMoverVehicle_changed, !true, !true );
	clientfield::register( "vehicle", "enemyvehicle", 1, 2, "int", &enemyvehicle_changed, !true, true );
	clientfield::register( "helicopter", "enemyvehicle", 1, 2, "int", &enemyvehicle_changed, !true, true );
	clientfield::register( "missile", "enemyvehicle", 1, 2, "int", &enemyMissileVehicle_changed, !true, true );
	clientfield::register( "actor", "enemyvehicle", 1, 2, "int", &enemyvehicle_changed, !true, true );

	clientfield::register( "vehicle", "vehicletransition", 1, 1, "int", &vehicle_transition, !true, true );	

	if(!isdefined(level.enemyvehicles))level.enemyvehicles=[];
	
	level.emp_killstreaks = [];
}

function vehicle_transition( local_client_num, oldVal, newVal, bNewEnt, bInitialSnap, fieldName, bWasDemoJump )
{
	player = GetLocalPlayer( local_client_num );
	friend = self util::friend_not_foe( local_client_num, true );
	
	if( friend && isdefined( player ) && player duplicate_render::show_friendly_outlines( local_client_num ) )
	{
		showOutlines = !(self IsLocalClientDriver( local_client_num ) );
		self duplicate_render::set_item_friendly_vehicle( showOutlines );
	}	
}

function enemyScriptMoverVehicle_changed( local_client_num, oldVal, newVal, bNewEnt, bInitialSnap, fieldName, bWasDemoJump )
{
	if ( isdefined( level.scriptMoverCompassIcons ) && isdefined( self.model ) )
	{
		if ( isdefined( level.scriptMoverCompassIcons[self.model] ) )
		{
			self setCompassIcon( level.scriptMoverCompassIcons[self.model] );
		}
	}
	
	enemyvehicle_changed( local_client_num, oldVal, newVal, bNewEnt, bInitialSnap, fieldName, bWasDemoJump );
}

function enemyMissileVehicle_changed( local_client_num, oldVal, newVal, bNewEnt, bInitialSnap, fieldName, bWasDemoJump )
{
	if ( isdefined( level.missileCompassIcons ) && isdefined( self.weapon ) )
	{
		if ( isdefined( level.missileCompassIcons[self.weapon] ) )
		{
			self setCompassIcon( level.missileCompassIcons[self.weapon] );
		}
	}
	
	enemyvehicle_changed( local_client_num, oldVal, newVal, bNewEnt, bInitialSnap, fieldName, bWasDemoJump );
}
	
function enemyvehicle_changed( local_client_num, oldVal, newVal, bNewEnt, bInitialSnap, fieldName, bWasDemoJump )
{
	self updateTeamVehicles( local_client_num, newVal );
	self util::add_remove_list( level.enemyvehicles, newVal );
	
	self updateEnemyVehicles( local_client_num, newVal );
	
	if ( isdefined( self.model ) && self.model == "wpn_t7_turret_emp_core" )
	{
		if ( !isdefined( level.emp_killstreaks ) ) level.emp_killstreaks = []; else if ( !IsArray( level.emp_killstreaks ) ) level.emp_killstreaks = array( level.emp_killstreaks ); level.emp_killstreaks[level.emp_killstreaks.size]=self;;
	}
}

function updateTeamVehicles( local_client_num, newVal )
{	
	self checkTeamVehicles( local_client_num );
}

function updateEnemyVehicles( local_client_num, newVal )
{
	if ( !( isdefined( self ) ) )
	{
	    	return;
	}
	watcher = GetLocalPlayer( local_client_num );
	friend = self util::friend_not_foe( local_client_num, true ); 

	self duplicate_render::set_dr_flag( "enemyvehicle_fb", !friend );

	self duplicate_render::set_item_enemy_vehicle( false );
	self duplicate_render::set_item_friendly_vehicle( false );
	self.isEnemyVehicle = false; 
	if ( !friend && IsDefined( watcher ) && watcher HasPerk( local_client_num, "specialty_showenemyvehicles" ) )
	{
		if ( !isdefined( self.isbreachingfirewall ) || self.isbreachingfirewall == false ) 
		{
			self duplicate_render::set_item_enemy_vehicle( newVal );
		}
		self.isEnemyVehicle = true;
		self duplicate_render::set_item_friendly_vehicle( false );
	}
	else if( ( friend === true ) && isDefined( watcher ) && watcher duplicate_render::show_friendly_outlines(local_client_num) )
	{
		driver = ( self.type === "vehicle" ) && self IsLocalClientDriver( local_client_num );
		showOutlines = ( driver === false ) && ( newVal === 1 || newVal === 2 );
		self duplicate_render::set_item_friendly_vehicle( showOutlines );
	}
	else
	{
		self duplicate_render::set_item_friendly_vehicle( false );
	}
	
	if ( newVal == 2 )
	{
		//self duplicate_render::set_hacker_tool_hacked( true );
		self.killstreakIsHacked = true;
	}
}



function on_player_spawned( local_client_num )
{
	self thread watch_killstreak_detect_perks_changed(local_client_num);
}



function watch_killstreak_detect_perks_changed(local_client_num)
{
	self notify( "watch_killstreak_detect_perks_changed" );
	self endon( "watch_killstreak_detect_perks_changed" );
	self endon( "death" );
	self endon( "disconnect" );
	self endon( "entityshutdown" );
	
	while(IsDefined(self))
	{
		{wait(.016);};
		util::clean_deleted(level.enemyvehicles);
		array::thread_all( level.enemyvehicles, &updateEnemyVehicles, local_client_num, 1 );
		self waittill("perks_changed");
	}
}


function checkTeamVehicles( localClientNum )
{	
	if ( !isdefined ( self.owner ) || !isdefined ( self.owner.team ) )
	{
		return;
	}
	
	if ( !isdefined( self.vehicleOldTeam ) )
	{
		self.vehicleOldTeam = self.team;
	}
	
	if ( !isdefined( self.vehicleOldOwnerTeam ) )
	{
		self.vehicleOldOwnerTeam = self.owner.team;
	}
	
	watcher = GetLocalPlayer( localClientNum );
	
	if ( !isdefined( self.vehicleOldWatcherTeam ) )
	{
		self.vehicleOldWatcherTeam = watcher.team;
	}
	
	if ( self.vehicleOldTeam != self.team || self.vehicleOldOwnerTeam != self.owner.team || self.vehicleOldWatcherTeam != watcher.team)
	{
		self.vehicleOldTeam = self.team;
		self.vehicleOldOwnerTeam = self.owner.team;
		self.vehicleOldWatcherTeam = watcher.team;
		
		self notify( "team_changed" );		
	}
}


function vehicleTeamObject( localClientNum ) 
{
	self endon( "entityshutdown" );	
	
	self util::waittill_dobj(localClientNum);
	
	wait( 0.05 );
	
	fx_handle = self thread playFlareFX( localClientNum );

	self thread vehicleWatchTeamFX( localClientNum, fx_handle );	
	
	self thread vehicleWatchPlayerTeamChanged( localClientNum, fx_handle );
	
	self thread vehicleDR();
}

function playFlareFX( localClientNum )  // self is the vehicle entity
{
	self endon( "entityshutdown" );
	level endon( "player_switch" );
	
	if ( !isdefined( self.vehicleTagFX ) )
	{
		self.vehicleTagFX = "tag_origin";
	}
	
	fx_handle = PlayFXOnTag( localClientNum, level._effect[ "powerLight" ], self, self.vehicleTagFX );

	return fx_handle;	
}



function vehicleWatchTeamFX( localClientNum, fxHandle ) // self is the vehicle entity
{
	msg = self util::waittill_any_return( "entityshutdown", "team_changed", "player_switch" );
	
	if ( isdefined( fxHandle ) )
	{
		stopFx( localClientNum, fxHandle );
	}
	
	waittillframeend;

	if ( msg != "entityshutdown" && isdefined( self ) )
	{
		self thread vehicleTeamObject( localClientNum );
	}
}

function vehicleDR( local_client_num )
{
}

function vehicleWatchPlayerTeamChanged( localClientNum, fxHandle ) // self is the vehicle entity
{
	self endon( "entityshutdown" );	
	self notify( "team_changed_watcher" );
	self endon( "team_changed_watcher" );
	
	watcherPlayer = GetLocalPlayer( localClientNum );

	while ( 1 )
	{
		level waittill( "team_changed", clientNum );
		
		player =  GetLocalPlayer( clientNum );
		
		if ( watcherPlayer == player )
		{
			self notify( "team_changed" );
		}
	}	
}
