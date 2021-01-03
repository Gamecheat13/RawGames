#using scripts\codescripts\struct;
#using scripts\mp\killstreaks\_killstreaks;
#using scripts\shared\killstreaks_shared;
#using scripts\shared\util_shared;
#using scripts\shared\_oob;

    	   	                                                                                                                         	                                                                                                                                                                                                                                                                                                                                                                    	        	     	             	    	   	                           	                               	                                	                                                              	                                                                                                              	                            	                                     	                                       	                                                               	   	                  	       	                                                    	                   	                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                        	                                                                                        	           	                        	                                            	                                             	                                                   	                                                             	                                                         	                                                                    	                                                                                                                                                                                                    	                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                      	                                                              	                                                          	                                   	                                   	                                                    	                                       

#namespace placeables;




function SpawnPlaceable( killstreakRef, killstreakId, 
	                     onPlaceCallback, onCancelCallback, onMoveCallback, onShutdownCallback, onDeathCallback, onEmpCallback,
	                     model, validModel, invalidModel, 
	                     pickupString, 
	                     timeout, 
	                     health,
						 empDamage )
{
	player = self;
	
	self killstreaks::switch_to_last_non_killstreak_weapon();
	
	placeable = spawn( "script_model", player.origin );	
	placeable.cancelable = true;
	placeable.held = false;
	placeable.validModel = validModel;
	placeable.invalidModel = invalidModel;
	placeable.killstreakId = killstreakId;
	placeable.killstreakRef = killstreakRef;
	placeable.onCancel = onCancelCallback;
	placeable.onEmp = onEmpCallback;
	placeable.onMove = onMoveCallback;
	placeable.onPlace = onPlaceCallback;
	placeable.onShutdown = onShutdownCallback;
	placeable.onDeath = onDeathCallback;
	placeable.owner = player;
	placeable.ownerEntNum = player.entNum;
	placeable.pickupString = pickupString;
	placeable.placedModel = model;
	placeable.team = player.team;
	placeable.timedOut = false;
	placeable.timeout = timeout;
	placeable.timeoutStarted = false;
	placeable.angles = player.angles;
	
	placeable NotSolid();
	placeable SetOwner( player );
	placeable SetTeam( player.team );
	Target_Set( placeable );
	
	if( isdefined( health ) && health > 0 )
	{
		placeable.health = health;
		placeable SetCanDamage( false );
		placeable thread killstreaks::MonitorDamage( killstreakRef, health, &OnDeath, 0, undefined, empDamage, &OnEMP, true );
	}
	
	player thread CarryPlaceable( placeable );
	player thread ShutdownOnCancelEvent( placeable );
	player thread CancelOnPlayerDisconnect( placeable );
	player thread CancelOnGameEnd( placeable );
	
	return placeable;
}

function UpdatePlacementModels( model, validModel, invalidModel )
{
	placeable = self;
	placeable.placedModel = model;
	placeable.validModel = validModel;
	placeable.invalidModel = invalidModel;
}

function CarryPlaceable( placeable )
{
	player = self;
	
	placeable Show();
	placeable NotSolid();
	placeable.held = true;
	player.holding_placeable = placeable;
	
	player CarryTurret( placeable, ( 40, 0, 0 ), ( 0, 0, 0 ) );
	player util::_disableWeapon();
	player thread WatchPlacement( placeable );
}

function InNoPlacementTrigger()
{
	placeable = self;	
	
	if( isdefined( level.noTurretPlacementTriggers ) )
	{
		for( i = 0; i < level.noTurretPlacementTriggers.size; i++ )
		{
			if( placeable IsTouching( level.noTurretPlacementTriggers[i] ) )
			{
				return true;
			}
		}
	}
	
	if( isdefined( level.fatal_triggers ) )
	{
		for( i = 0; i < level.fatal_triggers.size; i++ )
		{
			if( placeable IsTouching( level.fatal_triggers[i] ) )
			{
				return true;
			}
		}	
	}
	
	if( placeable oob::IsTouchingAnyOOBTrigger() )
	{
		return true;
	}
	
	return false;
}

function WatchPlacement( placeable )
{
	player = self;
	
	player endon( "disconnect" );
	player endon( "death" );
	placeable endon( "placed" );
	placeable endon( "cancelled" );

	while( player AttackButtonPressed() )
	{
		{wait(.05);};
	}
	
	player thread WatchCarryCancelEvents( placeable );
	
  	lastAttempt = -1;
  	placeable.canBePlaced = false;
	
	while( true )
	{
		placement = player CanPlayerPlaceTurret();

		placeable.origin = placement["origin"];
		placeable.angles = placement["angles"];
		placeable.canBePlaced = placement["result"] && !( placeable InNoPlacementTrigger() ) && !( player IsPlayerSwimming() );
		
		if( placeable.canBePlaced != lastAttempt )
		{
			if( placeable.canBePlaced )
			{
				placeable SetModel( placeable.validModel );
			}
			else
			{
				placeable SetModel( placeable.invalidModel );
			}
			
			lastAttempt = placeable.canBePlaced;
		}
		
		if( placeable.canBePlaced && player AttackButtonPressed() )
		{
			if( placement["result"] )
			{
				placeable.origin = placement["origin"];
				placeable.angles = placement["angles"];
				
				player StopCarryTurret( placeable );
				
				if( !player util::isWeaponEnabled() )
				{
					player util::_enableWeapon();	
				}
				
				placeable.held = false;
				player.holding_placeable = undefined;
				placeable.cancelable = false;
				
				if( ( isdefined( placeable.health ) && placeable.health ) )
				{
					placeable SetCanDamage( true );
					placeable Solid();
				}
				
				if( isdefined( placeable.placedModel ) )
				{
					placeable SetModel( placeable.placedModel );
				}
				else
				{
					placeable Hide();	
				}
				
				if( isdefined( placeable.timeout ) )
				{
					if( !placeable.timeoutStarted )
					{
						placeable.timeoutStarted = true;
						placeable thread killstreaks::WaitForTimeout( placeable.killstreakRef, placeable.timeout, &OnTimeout, "death", "cancelled" );
					}
					else if( placeable.timedOut )
					{
						placeable thread killstreaks::WaitForTimeout( placeable.killstreakRef, 5000, &OnTimeout, "cancelled" );
					}
				}
				
				if( isdefined( placeable.onPlace )  )
				{
					player [[ placeable.onPlace ]]( placeable );
					if( isdefined( placeable.onMove ) && !placeable.timedOut )
					{
						SpawnMoveTrigger( placeable, player );
					}
				}
				
				placeable notify( "placed" );
			}
		}

		if( placeable.cancelable && player ActionSlotFourButtonPressed() )
		{
			placeable notify( "cancelled" );
		}
		
		{wait(.05);};
	}
}

function WatchCarryCancelEvents( placeable )
{
	player = self;
	assert( IsPlayer( player ) );

	placeable endon( "cancelled" );
	placeable endon( "placed" );
	
	player util::waittill_any( "death", "emp_jammed", "emp_grenaded", "disconnect", "joined_team" );
	placeable notify( "cancelled" );
}

function OnTimeout()
{
	placeable = self;
	if( ( isdefined( placeable.held ) && placeable.held ) )
	{
		placeable.timedOut = true;
		return;
	}
	
	placeable notify( "delete_placeable_trigger" );
	placeable thread killstreaks::WaitForTimeout( placeable.killstreakRef, 5000, &ForceShutdown, "cancelled" );
}

function OnDeath( attacker, weapon )
{
	placeable = self;
	
	if( isdefined( placeable.onDeath ) )
	{
		[[ placeable.onDeath ]]( attacker, weapon );
	}
	
	placeable notify( "cancelled" );
}

function OnEMP( attacker )
{
	placeable = self;
	
	if( isdefined( placeable.onEmp ) )
	{
		placeable [[ placeable.onEmp ]]( attacker );
	}
}
	
function CancelOnPlayerDisconnect( placeable )
{
	player = self;
	assert( IsPlayer( player ) );
	
	placeable endon( "cancelled" );
	player util::waittill_any( "disconnect", "joined_team" );
	placeable notify( "cancelled" );
}

function CancelOnGameEnd( placeable )
{
	placeable endon( "cancelled" );
	level waittill( "game_ended" );
	placeable notify( "cancelled" );
}

function SpawnMoveTrigger( placeable, player )
{
	pos = placeable.origin + ( 0, 0, 15 );
	placeable.pickupTrigger = spawn( "trigger_radius_use", pos );
	placeable.pickupTrigger SetCursorHint( "HINT_NOICON", placeable );
	placeable.pickupTrigger SetHintString( placeable.pickupString );

	if( level.teamBased )
	{
		placeable.pickupTrigger SetTeamForTrigger( player.team );
	}
	
	player ClientClaimTrigger( placeable.pickupTrigger );
	placeable thread WatchPickup( player);
	placeable.pickupTrigger thread WatchMoveTriggerShutdown( placeable );
}

function WatchMoveTriggerShutdown( placeable )
{
	trigger = self;
	placeable util::waittill_any( "cancelled", "picked_up", "death", "delete_placeable_trigger" );
	placeable.pickupTrigger delete();
}

function WatchPickup( player )
{
	placeable = self;
	placeable endon( "death" );
	placeable endon( "cancelled" );
	
	assert( isdefined( placeable.pickupTrigger ) );
	trigger = placeable.pickupTrigger;
	
	while ( true )
	{
		trigger waittill( "trigger", player );
		
		if( !isAlive( player ) )
		{
			continue;
		}
		
		if( player isUsingOffhand() )
		{
			continue;
		}

		if( !player isOnGround() )
		{
			continue;
		}
		
		if( isdefined( trigger.triggerTeam ) && ( player.team != trigger.triggerTeam ) )
		{
			continue;
		}
		
		if( isdefined( trigger.claimedBy ) && ( player != trigger.claimedBy ) )
		{
			continue;
		}
		
		if( player useButtonPressed() && !player.throwingGrenade && !player meleeButtonPressed() && !player attackButtonPressed() && 
		   !( isdefined( player.isPlanting ) && player.isPlanting ) && !( isdefined( player.isDefusing ) && player.isDefusing ) && !player IsRemoteControlling() && !isdefined( player.holding_placeable ) )
		{
			placeable notify( "picked_up" );
			placeable.held = true;
			placeable SetCanDamage( false );
			assert( isdefined( placeable.onMove ) );
			player [[ placeable.onMove ]]( placeable );
			player thread CarryPlaceable( placeable );
			return;
		}
	}
}

function ForceShutdown()
{
	placeable = self;
	placeable.cancelable = false;
	placeable notify( "cancelled" );
}

function ShutdownOnCancelEvent( placeable )
{
	player = self;
	assert( IsPlayer( player ) );
	
	placeable util::waittill_any( "cancelled", "death" );
	
	if( isdefined( player ) && isdefined( placeable ) )
	{
		player StopCarryTurret( placeable );
		
		if( !player util::isWeaponEnabled() )
		{
			player util::_enableWeapon();		
		}
	}
	
	if( isdefined( placeable ) )
	{
		if( placeable.cancelable )
		{
			if( isdefined( placeable.onCancel ) )
			{
				[[ placeable.onCancel ]]( placeable );
			}	
		}
		else
		{
			if( isdefined( placeable.onShutdown ) )
			{
				[[ placeable.onShutdown ]]( placeable );
			}
		}
		
		placeable delete();
	}
}
