#using scripts\codescripts\struct;

#using scripts\shared\array_shared;
#using scripts\shared\audio_shared;
#using scripts\shared\callbacks_shared;
#using scripts\shared\clientfield_shared;
#using scripts\shared\duplicaterender_mgr;
#using scripts\shared\filter_shared;
#using scripts\shared\util_shared;


                                                                                
    	   	                                                                                                                                         	                                	                                                                                                                                                                                                                                                                                                                                                                    	        	     	             	    	   	               	                                              	                                                           	                               	                     	                                                                                                           	                                                                 	                                                              	                                                                                                              	                            	                                     	                                       	                                                                                                              	   	                  	       	                                                    	                   	                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                        	                                  	                                                                                        	           	                        	                                            	                                             	                                                   	                                                             	                                                         	                                                                    	                                                                                                                                                                                                    	                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                         	                                                              	                                                          	                                   	                                   	                                                    	                                       	                                           	     	                                                                                                                                                                                                                                                      	                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                     
                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                            	                           	                           	                                                                                                                                                                                                                                                            	                                                                                                                                                                                                                                                                                                                                                                                       
   

#using scripts\shared\system_shared;

#precache( "client_fx", "weapon/fx_equip_light_os" );

#namespace weaponobjects;

function init_shared()
{
	callback::on_spawned( &on_player_spawned );
	
	clientfield::register( "toplayer", "proximity_alarm", 1, 2, "int", &proximity_alarm_changed, !true, true );

	clientfield::register( "missile", "retrievable", 1, 1, "int", &retrievable_changed, !true, true );
	clientfield::register( "scriptmover", "retrievable", 1, 1, "int", &retrievable_changed, !true, !true );
	clientfield::register( "missile", "enemyequip", 1, 1, "int", &enemyequip_changed, !true, true );
	clientfield::register( "scriptmover", "enemyequip", 1, 1, "int", &enemyequip_changed, !true, !true );
	clientfield::register( "missile", "enemyexplo", 1, 1, "int", &enemyexplo_changed, !true, true );
	clientfield::register( "scriptmover", "enemyexplo", 1, 1, "int", &enemyexplo_changed, !true, !true );
	clientfield::register( "missile", "teamequip", 1, 1, "int", &teamequip_changed, !true, true );

	level._effect[ "powerLight" ] = "weapon/fx_equip_light_os";
	
	if(!isdefined(level.retrievable))level.retrievable=[];
	if(!isdefined(level.enemyequip))level.enemyequip=[];
	if(!isdefined(level.enemyexplo))level.enemyexplo=[];
}

function on_player_spawned( local_client_num )
{
	player_view = getlocalplayer( local_client_num );
	
	if ( player_view GetEntityNumber() != self GetEntityNumber() )
	{
		return;
	}
	
	self thread watch_perks_changed(local_client_num);

	self thread watch_killstreak_tap_activation( local_client_num );	
}

function watch_killstreak_tap_activation( local_client_num )
{
	self notify( "watch_killstreak_tap_activation" );
	self endon( "watch_killstreak_tap_activation" );
	self endon( "death" );
	self endon( "disconnect" );
	self endon( "entityshutdown" );

	while ( IsDefined( self ) ) 
	{
		level waittill( "notetrack", local_client_num, note );
		if ( note == "activate_datapad" )
		{
			uimodel = CreateUIModel( GetUIModelForController( local_client_num ), "hudItems.killstreakActivated" );
			SetUIModelValue( uimodel, 1 );
		}

		if ( note == "deactivate_datapad" )
		{
			uimodel = CreateUIModel( GetUIModelForController( local_client_num ), "hudItems.killstreakActivated" );
			SetUIModelValue( uimodel, 0 );
		}
	}
}


function proximity_alarm_changed( local_client_num, oldVal, newVal, bNewEnt, bInitialSnap, fieldName, bWasDemoJump )
{
	update_sound( local_client_num, bNewEnt, newVal, oldVal );	
}

function update_sound( local_client_num, bNewEnt, newVal, oldVal )
{
	if ( newVal == 2 )
	{
		if ( !IsDefined( self._proximity_alarm_snd_ent ) )
		{
			self._proximity_alarm_snd_ent = Spawn( local_client_num, self.origin, "script_origin" );
			self thread sndProxAlert_EntCleanup(local_client_num, self._proximity_alarm_snd_ent);
		}
		
		playsound( local_client_num, "uin_c4_proximity_alarm_start", (0,0,0) );
		self._proximity_alarm_snd_ent PlayLoopSound( "uin_c4_proximity_alarm_loop", .1 );
	}
	else if ( newVal == 1 )
	{
		//playsound( local_client_num, "uin_c4_proximity_alarm_deploy", (0,0,0) );
	}
	else if( newVal == 0 && isdefined( oldVal ) && oldVal != newVal )
	{
		playsound( local_client_num, "uin_c4_proximity_alarm_stop", (0,0,0) );
		if ( IsDefined( self._proximity_alarm_snd_ent ) )
		{
			self._proximity_alarm_snd_ent StopAllLoopSounds( 0.5 );
		}
	}
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
	self util::add_remove_list( level.retrievable, newVal );
	
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
	self util::add_remove_list( level.enemyequip, newVal );
	
	self updateEnemyEquipment( local_client_num, newVal );
}

function updateEnemyEquipment( local_client_num, newVal )
{
	watcher = GetLocalPlayer( local_client_num );
	friend = self util::friend_not_foe( local_client_num, true ); 
	
	self duplicate_render::set_item_enemy_equipment( false );
	self duplicate_render::set_item_friendly_equipment( false );
	
	if ( !friend && IsDefined( watcher ) && watcher HasPerk( local_client_num, "specialty_showenemyequipment" ) )
	{
		self duplicate_render::set_item_enemy_equipment( newVal );
	}
	else if( friend && isDefined( watcher ) && watcher duplicate_render::show_friendly_outlines(local_client_num) )
	{
		self duplicate_render::set_item_friendly_equipment( newVal );
	}
}




function enemyexplo_changed( local_client_num, oldVal, newVal, bNewEnt, bInitialSnap, fieldName, bWasDemoJump )
{
	self util::add_remove_list( level.enemyexplo, newVal );
	
	self updateEnemyExplosive( local_client_num, newVal );
}

function updateEnemyExplosive( local_client_num, newVal )
{
	watcher = GetLocalPlayer( local_client_num );
	friend = self util::friend_not_foe( local_client_num, true ); 

	self duplicate_render::set_item_enemy_explosive( false );
	self duplicate_render::set_item_friendly_explosive( false );
	
	if ( !friend && IsDefined( watcher ) && watcher HasPerk( local_client_num, "specialty_detectexplosive" ) )
	{
		self duplicate_render::set_item_enemy_explosive( newVal );
	}
	else if( friend && isDefined( watcher ) && watcher duplicate_render::show_friendly_outlines(local_client_num) )
	{
		self duplicate_render::set_item_friendly_explosive( newVal );
	}
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
		util::clean_deleted(level.retrievable);
		util::clean_deleted(level.enemyequip);
		util::clean_deleted(level.enemyexplo);
		array::thread_all( level.retrievable, &updateRetrievable, local_client_num, 1 );
		array::thread_all( level.enemyequip, &updateEnemyEquipment, local_client_num, 1 );
		array::thread_all( level.enemyexplo, &updateEnemyExplosive, local_client_num, 1 );
		self waittill("perks_changed");
	}
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



function sndProxAlert_EntCleanup( localClientNum, ent )
{
	level util::waittill_any( "sndDEDe", "demo_jump", "player_switch", "killcam_begin", "killcam_end" );

	if ( isdefined(ent) )
	{		
		ent StopAllLoopSounds( 0.5 );
		ent delete();
	}
}