#using scripts\codescripts\struct;

#using scripts\shared\array_shared;
#using scripts\shared\audio_shared;
#using scripts\shared\callbacks_shared;
#using scripts\shared\clientfield_shared;
#using scripts\shared\duplicaterender_mgr;
#using scripts\shared\filter_shared;
#using scripts\shared\util_shared;


                                                                           
    	   	                                                                                                                         	                                                                                                                                                                                                                                                                                                                                                                    	        	     	             	    	   	                           	                               	                                	                                                              	                                                                                                              	                            	                                     	                                       	                                                               	   	                  	       	                                                    	                   	                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                        	                                                                                        	           	                        	                                            	                                             	                                                   	                                                             	                                                         	                                                                    	                                                                                                                                                                                                    	                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                      	                                                              	                                                          	                                   	                                   	                                                    	                                       
                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                            	                                                                                                                                                                                                                                                                                                                                                                                       
   

#using scripts\shared\system_shared;

#precache( "client_fx", "weapon/fx_equip_light_red_os" );
#precache( "client_fx", "weapon/fx_equip_light_green_os" );

#namespace weaponobjects;

function init_shared()
{
	callback::on_localclient_connect( &on_player_connect );
	callback::on_spawned( &on_player_spawned );
	
	clientfield::register( "toplayer", "proximity_alarm", 1, 2, "int", &proximity_alarm_changed, !true, true );
	SetupClientFieldCodeCallbacks( "toplayer", 1, "proximity_alarm" );

	clientfield::register( "missile", "retrievable", 1, 1, "int", &retrievable_changed, !true, true );
	clientfield::register( "scriptmover", "retrievable", 1, 1, "int", &retrievable_changed, !true, !true );
	clientfield::register( "missile", "enemyequip", 1, 1, "int", &enemyequip_changed, !true, true );
	clientfield::register( "scriptmover", "enemyequip", 1, 1, "int", &enemyequip_changed, !true, !true );
	clientfield::register( "missile", "enemyexplo", 1, 1, "int", &enemyexplo_changed, !true, true );
	clientfield::register( "scriptmover", "enemyexplo", 1, 1, "int", &enemyexplo_changed, !true, !true );
	clientfield::register( "missile", "teamequip", 1, 1, "int", &teamequip_changed, !true, true );

	clientfield::register( "scriptmover", "enemyvehicle", 1, 1, "int", &enemyvehicle_changed, !true, !true );
	clientfield::register( "vehicle", "enemyvehicle", 1, 1, "int", &enemyvehicle_changed, !true, true );
	clientfield::register( "helicopter", "enemyvehicle", 1, 1, "int", &enemyvehicle_changed, !true, true );
	clientfield::register( "missile", "enemyvehicle", 1, 1, "int", &enemyvehicle_changed, !true, true );
	clientfield::register( "actor", "enemyvehicle", 1, 1, "int", &enemyvehicle_changed, !true, true );

	level._effect[ "powerLight" ] = "weapon/fx_equip_light_red_os";
	level._effect[ "powerLightGrenn" ] = "weapon/fx_equip_light_green_os";
	
	if(!isdefined(level.retrievable))level.retrievable=[];
	if(!isdefined(level.enemyequip))level.enemyequip=[];
	if(!isdefined(level.enemyexplo))level.enemyexplo=[];
	if(!isdefined(level.enemyvehicles))level.enemyvehicles=[];
}

function on_player_connect( local_client_num )
{
}

function on_player_spawned( local_client_num )
{
	player_view = getlocalplayer( local_client_num );
	
	if ( player_view GetEntityNumber() != self GetEntityNumber() )
	{
		return;
	}
	
	if ( !IsDefined( self._proximity_alarm_snd_ent ) )
	{
		self._proximity_alarm_snd_ent = SpawnFakeEnt( local_client_num );
	}
	else
	{
		StopLoopSound( local_client_num, self._proximity_alarm_snd_ent, 0.05 );
	}
	
	self thread watch_perks_changed(local_client_num);
}

function proximity_alarm_changed( local_client_num, oldVal, newVal, bNewEnt, bInitialSnap, fieldName, bWasDemoJump )
{
	update_sound( local_client_num, bNewEnt, newVal, oldVal );	
}

function update_sound( local_client_num, bNewEnt, newVal, oldVal )
{
	if ( !IsDefined( self._proximity_alarm_snd_ent ) )
	{
		self._proximity_alarm_snd_ent = SpawnFakeEnt( local_client_num );
		self thread sndProxAlert_EntCleanup(local_client_num, self._proximity_alarm_snd_ent);
	}

	if ( newVal == 2 )
	{
		playsound( local_client_num, "uin_c4_proximity_alarm_start", (0,0,0) );
		PlayLoopSound( local_client_num, self._proximity_alarm_snd_ent, "uin_c4_proximity_alarm_loop", .1 );
	}
	else if ( newVal == 1 )
	{
		//playsound( local_client_num, "uin_c4_proximity_alarm_deploy", (0,0,0) );
	}
	else if( newVal == 0 && isdefined( oldVal ) && oldVal != newVal )
	{
		playsound( local_client_num, "uin_c4_proximity_alarm_stop", (0,0,0) );
		StopLoopSound( local_client_num, self._proximity_alarm_snd_ent, 0.5 );
	}
}

function clean_deleted( &array )
{
	done = false; 
	while ( !done && array.size > 0 )
	{
		done = true;
		foreach( key, val in array )
		{
			if (!IsDefined(val))
			{
				ArrayRemoveIndex(array,key,false);
				done = false; 
				break;
			}
		}
	}
}

function add_remove_list( &a, on_off )
{
	if(!isdefined(a))a=[];
	if ( on_off )
	{
		if ( !IsInArray( a, self ) )
		{
			ArrayInsert(a,self,a.size);
		}
	}
	else
	{
		ArrayRemoveValue( a, self, false );
	}
}

	
function enemyvehicle_changed( local_client_num, oldVal, newVal, bNewEnt, bInitialSnap, fieldName, bWasDemoJump )
{
	self updateTeamVehicles( local_client_num, newVal );
	self add_remove_list( level.enemyvehicles, newVal );
	
	self updateEnemyVehicles( local_client_num, newVal );
	
}

function updateTeamVehicles( local_client_num, newVal )
{	
	self checkTeamVehicles( local_client_num );
}
	
function teamequip_changed( local_client_num, oldVal, newVal, bNewEnt, bInitialSnap, fieldName, bWasDemoJump )
{
	self updateTeamEquipment( local_client_num, newVal );
}

function updateTeamEquipment( local_client_num, newVal )
{	
	self checkTeamEquipment( local_client_num );
}

function retrievable_changed( local_client_num, oldVal, newVal, bNewEnt, bInitialSnap, fieldName, bWasDemoJump )
{
	self add_remove_list( level.retrievable, newVal );
	
	self updateRetrievable( local_client_num, newVal );
}

function updateRetrievable( local_client_num, newVal )
{
	if ( IsDefined(self.owner) && self.owner == getlocalplayer( local_client_num ) )
	{
		self duplicate_render::set_item_retrievable( newVal );
	}
	else
	{
		if ( IsDefined(self.currentdrfilter))
			self duplicate_render::set_item_retrievable( false );
	}	
}

function enemyequip_changed( local_client_num, oldVal, newVal, bNewEnt, bInitialSnap, fieldName, bWasDemoJump )
{
	self add_remove_list( level.enemyequip, newVal );
	
	self updateEnemyEquipment( local_client_num, newVal );
}

function updateEnemyEquipment( local_client_num, newVal )
{
	watcher = GetLocalPlayer( local_client_num );
	friend = self util::friend_not_foe( local_client_num, true ); 
	
	if ( !friend && IsDefined( watcher ) && watcher HasPerk( local_client_num, "specialty_showenemyequipment" ) )
	{
		self duplicate_render::set_item_enemy_equipment( newVal );
	}
	else
	{
		if ( IsDefined(self.currentdrfilter))
			self duplicate_render::set_item_enemy_equipment( false );
	}
}


function updateEnemyVehicles( local_client_num, newVal )
{
	if ( !( isdefined( self ) ) )
	{
	    	return;
	}
	watcher = GetLocalPlayer( local_client_num );
	friend = self util::friend_not_foe( local_client_num, true ); 

	if ( !friend && IsDefined( watcher ) && watcher HasPerk( local_client_num, "specialty_showenemyvehicles" ) )
	{
		self duplicate_render::set_item_enemy_vehicle( newVal );
	}
	else
	{
		if ( IsDefined(self.currentdrfilter))
			self duplicate_render::set_item_enemy_vehicle( false );
	}
}


function enemyexplo_changed( local_client_num, oldVal, newVal, bNewEnt, bInitialSnap, fieldName, bWasDemoJump )
{
	self add_remove_list( level.enemyexplo, newVal );
	
	self updateEnemyExplosive( local_client_num, newVal );
}

function updateEnemyExplosive( local_client_num, newVal )
{
	watcher = GetLocalPlayer( local_client_num );
	friend = self util::friend_not_foe( local_client_num, true ); 

	if ( !friend && IsDefined( watcher ) && watcher HasPerk( local_client_num, "specialty_detectexplosive" ) )
	{
		self duplicate_render::set_item_enemy_explosive( newVal );
	}
	else
	{
		if ( IsDefined(self.currentdrfilter))
			self duplicate_render::set_item_enemy_explosive( false );
	}
}

function vehicleDR( local_client_num )
{
}

function equipmentDR( local_client_num )
{
}

function watch_perks_changed(local_client_num)
{
	self notify( "watch_perks_changed" );
	self endon( "watch_perks_changed" );
	self endon( "death" );
	self endon( "disconnect" );
	self endon( "entityshutdown" );
	
	while(IsDefined(self))
	{
		{wait(.016);};
		clean_deleted(level.retrievable);
		clean_deleted(level.enemyequip);
		clean_deleted(level.enemyexplo);
		array::thread_all( level.retrievable, &updateRetrievable, local_client_num, 1 );
		array::thread_all( level.enemyequip, &updateEnemyEquipment, local_client_num, 1 );
		array::thread_all( level.enemyexplo, &updateEnemyExplosive, local_client_num, 1 );
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

//******************************************************************
//                                                                 *
//                                                                 *
//******************************************************************
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



function checkTeamEquipment( localClientNum )
{		
	if ( !isdefined( self.owner ) )
	{
		return;	
	}
	if ( !isdefined( self.equipmentOldTeam ) )
	{
		self.equipmentOldTeam = self.team;
	}
	
	if ( !isdefined( self.equipmentOldOwnerTeam ) )
	{
		self.equipmentOldOwnerTeam = self.owner.team;
	}
	
	watcher = GetLocalPlayer( localClientNum );
	
	if ( !isdefined( self.equipmentOldWatcherTeam ) )
	{
		self.equipmentOldWatcherTeam = watcher.team;
	}
	
	if ( self.equipmentOldTeam != self.team || self.equipmentOldOwnerTeam != self.owner.team || self.equipmentOldWatcherTeam != watcher.team)
	{
		self.equipmentOldTeam = self.team;
		self.equipmentOldOwnerTeam = self.owner.team;
		self.equipmentOldWatcherTeam = watcher.team;
		
		self notify( "team_changed" );		
	}
}

//******************************************************************
//                                                                 *
//                                                                 *
//******************************************************************
function equipmentTeamObject( localClientNum ) 
{
	if ( ( isdefined( level.disable_equipment_team_object ) && level.disable_equipment_team_object ) )
	{
		return;
	}

	self endon( "entityshutdown" );	
	
	self util::waittill_dobj(localClientNum);
	
	wait( 0.05 );
	
	fx_handle = self thread playFlareFX( localClientNum );

	self thread equipmentWatchTeamFX( localClientNum, fx_handle );	
	
	self thread equipmentWatchPlayerTeamChanged( localClientNum, fx_handle );
	
	self thread equipmentDR();
}

//******************************************************************
//                                                                 *
//                                                                 *
//******************************************************************
function playFlareFX( localClientNum )  // self is the equipment entity
{
	self endon( "entityshutdown" );
	level endon( "player_switch" );
	
	if ( !isdefined( self.equipmentTagFX ) )
	{
		self.equipmentTagFX = "tag_origin";
	}
	
	if ( !isdefined( self.equipmentFriendFX ) )
	{
		self.equipmentTagFX = level._effect[ "powerLightGreen" ];
	}
	
	if ( !isdefined( self.equipmentEnemyFX ) )
	{
		self.equipmentTagFX = level._effect[ "powerLight" ];
	}
	
	if ( self util::friend_not_foe( localClientNum, true ) )
	{
		fx_handle = PlayFXOnTag( localClientNum, self.equipmentFriendFX, self, self.equipmentTagFX );
	}
	else
	{
		fx_handle = PlayFXOnTag( localClientNum, self.equipmentEnemyFX, self, self.equipmentTagFX );
	}

	return fx_handle;	
}

//******************************************************************
//	equipmentWatchTeamFX                                           *
//	handles notifies that may cause the FX to change               *
//******************************************************************
function equipmentWatchTeamFX( localClientNum, fxHandle ) // self is the equipment entity
{
	msg = self util::waittill_any_return( "entityshutdown", "team_changed", "player_switch" );
	
	if ( isdefined( fxHandle ) )
	{
		stopFx( localClientNum, fxHandle );
	}
	
	waittillframeend;

	if ( msg != "entityshutdown" && isdefined( self ) )
	{
		self thread equipmentTeamObject( localClientNum );
	}
}

//*****************************************************************
//	equipmentWatchPlayerTeamChanged                               *
//	handles the player changing teams and notifies the equipment  *
//*****************************************************************
function equipmentWatchPlayerTeamChanged( localClientNum, fxHandle ) // self is the equipment entity
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

//*****************************************************************
//	vehicleWatchPlayerTeamChanged                                 *
//	handles the player changing teams and notifies the vehicles   *
//*****************************************************************
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

//******************************************************************
//	vehicleWatchTeamFX                                           *
//	handles notifies that may cause the FX to change               *
//******************************************************************
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

function sndProxAlert_EntCleanup(localClientNum, ent)
{

	while(1)
	{
		level waittill( "sndDEDe" );
		
		
		//self util::waittill_any( "entityshutdown", "sndDEDe" );
		if (isdefined(ent))
		{
			deletefakeent( localClientNum, ent );
			return;
		}
	}
	
}