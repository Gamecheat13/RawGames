#using scripts\codescripts\struct;

#using scripts\shared\callbacks_shared;
#using scripts\shared\challenges_shared;
#using scripts\shared\clientfield_shared;
#using scripts\shared\damagefeedback_shared;
#using scripts\shared\scoreevents_shared;
#using scripts\shared\system_shared;
#using scripts\shared\util_shared;
#using scripts\shared\weapons\_hacker_tool;
#using scripts\shared\weapons\_weaponobjects;

    	   	                                                                                                                         	                                                                                                                                                                                                                                                                                                                                                                    	        	     	             	    	   	                           	                               	                                	                                                              	                                                                                                              	                            	                                     	                                       	                                                               	   	                  	       	                                                    	                   	                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                        	                                                                                        	           	                        	                                            	                                             	                                                   	                                                             	                                                         	                                                                    	                                                                                                                                                                                                    	                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                      	                                                              	                                                          	                                   	                                   	                                                    	                                       
                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                            	                                                                                                                                                                                                                                                                                                                                                                                       

#precache( "fx", "_t6/misc/fx_equip_tac_insert_light_grn" );
#precache( "fx", "_t6/misc/fx_equip_tac_insert_light_red" );
#precache( "fx", "_t6/misc/fx_equip_tac_insert_exp" );

#namespace tacticalinsertion;

function init_shared()
{
	level.weaponTacticalInsertion = GetWeapon( "tactical_insertion" );
	
	level._effect["tacticalInsertionFizzle"] = "_t6/misc/fx_equip_tac_insert_exp";
	
	clientfield::register( "scriptmover", "tacticalinsertion", 1, 1, "int" );

	callback::on_spawned( &on_player_spawned );
}

function on_player_spawned()
{
	self thread begin_other_grenade_tracking();
}

function isTacSpawnTouchingCrates( origin, angles )
{
	crate_ents = GetEntArray( "care_package", "script_noteworthy" );
	mins = ( -17, -17, -40 );
	maxs = ( 17, 17, 40 );
	for ( i = 0 ; i < crate_ents.size ; i++ )
	{
		if ( crate_ents[i] IsTouchingVolume( origin + (0,0,40), mins, maxs ) )
		{	
			return true;
		}
	}
	
	return false;
}

function overrideSpawn(isPredictedSpawn)
{	
	if ( !isdefined( self.tacticalInsertion ) )
		return false;
		
	origin = self.tacticalInsertion.origin;
	angles = self.tacticalInsertion.angles;
	team = self.tacticalInsertion.team;

	if (!isPredictedSpawn)
		self.tacticalInsertion destroy_tactical_insertion();
	
	if ( team != self.team )
		return false;

	if ( isTacSpawnTouchingCrates( origin ) )
		return false;

	if (!isPredictedSpawn)
	{
		self.tacticalInsertionTime = getTime();
		self spawn( origin, angles, "tactical insertion" );
		self SetSpawnClientFlag( "SCDFL_DISABLE_LOGGING" );
 		self AddWeaponStat( level.weaponTacticalInsertion, "used", 1 );
	}
	return true;
}

function waitAndDelete( time )
{
	self endon( "death" );
	
	// Wait a server frame to let missile fully enter the world
	{wait(.05);};

	// Delete grenade entity
	self delete();
}

function watch( player )
{
	// Remove existing tactical insertion, if it exists
	if ( isdefined( player.tacticalInsertion ) )
	{
		player.tacticalInsertion destroy_tactical_insertion();
	}
	
	// Spawn tactical insertion
	player thread spawnTacticalInsertion();

	// Delete grenade entity
	self waitAndDelete( 0.05 );
}

function watchUseTrigger( trigger, callback, playerSoundOnUse, npcSoundOnUse )
{
	self endon( "delete" );
	
	while ( true )
	{
		trigger waittill( "trigger", player );
			
		if ( !isAlive( player ) )
			continue;
			
		if ( !player isOnGround() )
			continue;
			
		if ( isdefined( trigger.triggerTeam ) && ( player.team != trigger.triggerTeam ) )
			continue;
			
		if ( isdefined( trigger.triggerTeamIgnore ) && ( player.team == trigger.triggerTeamIgnore ) )
			continue;
			
		if ( isdefined( trigger.claimedBy ) && ( player != trigger.claimedBy ) )
			continue;
			
		if ( player useButtonPressed() && !player.throwingGrenade && !player meleeButtonPressed() )
		{
			if ( isdefined( playerSoundOnUse ) )
				player playLocalSound( playerSoundOnUse );
			if ( isdefined( npcSoundOnUse ) )
				player playSound( npcSoundOnUse );

			self thread [[callback]]( player );
		}
	}
}

function watchDisconnect()
{
	self.tacticalInsertion endon( "delete" );
	
	self waittill( "disconnect" );
	self.tacticalInsertion thread destroy_tactical_insertion();
}

function destroy_tactical_insertion(attacker)
{
	self.owner.tacticalInsertion = undefined;
	self notify( "delete" );
	self.owner notify( "tactical_insertion_destroyed" );
	
	self.friendlyTrigger delete();
	self.enemyTrigger delete();
	// "destroyed_explosive" notify, for challenges
	if ( isdefined( attacker ) && isdefined( attacker.pers["team"] ) && isdefined( self.owner ) && isdefined( self.owner.pers["team"] ) )
	{
		if ( level.teambased )
		{
			if ( attacker.pers["team"] != self.owner.pers["team"] )
			{
				attacker notify("destroyed_explosive");
				attacker challenges::destroyedEquipment();
				attacker challenges::destroyedTacticalInsert();
				scoreevents::processScoreEvent( "destroyed_tac_insert", attacker );
			}
		}
		else
		{
			if ( attacker!= self.owner )
			{
				attacker notify("destroyed_explosive");
				attacker challenges::destroyedEquipment();
				attacker challenges::destroyedTacticalInsert();
				scoreevents::processScoreEvent( "destroyed_tac_insert", attacker );
			}		
		}
	}
	
	self delete();
}

function fizzle( attacker )
{
	if ( isdefined( self.fizzle ) && self.fizzle )
		return;
	self.fizzle = true;
	PlayFX( level._effect["tacticalInsertionFizzle"], self.origin );
	self playsound ("dst_tac_insert_break");
	//Notify player that their tact insert was destroyed
	if ( isdefined( attacker ) && attacker != self.owner )
	{
		if( isdefined( level.globallogic_audio_dialog_on_player_override ) )//TODO T7 - remove once globallogic_audio is shared
		{
			self.owner [[level.globallogic_audio_dialog_on_player_override]]( "tact_destroyed", "item_destroyed" );
		}		
	}

	self destroy_tactical_insertion( attacker );
}

function pickUp( attacker )
{
	player = self.owner;
	self destroy_tactical_insertion();
	player GiveWeapon( level.weaponTacticalInsertion );
	player setWeaponAmmoClip( level.weaponTacticalInsertion, 1 );
}

function spawnTacticalInsertion() // self == player
{
	self endon( "disconnect" );
		
	// Setup model
	self.tacticalInsertion = spawn( "script_model", self.origin + ( 0, 0, 1 ) );
	self.tacticalInsertion setModel( "t6_wpn_tac_insert_world" );
	self.tacticalInsertion.origin = self.origin + ( 0, 0, 1 );
	self.tacticalInsertion.angles = self.angles;
	self.tacticalInsertion.team = self.team;
	self.tacticalInsertion setTeam( self.team );
	self.tacticalInsertion.owner = self;
	self.tacticalInsertion setOwner( self );
	self.tacticalInsertion setWeapon( level.weaponTacticalInsertion );
	
	// setup recon model
	self.tacticalInsertion thread weaponobjects::attachReconModel( "t6_wpn_tac_insert_detect", self );

	self.tacticalInsertion endon( "delete" );

	self.tacticalInsertion hacker_tool::registerWithHackerTool( level.equipmentHackerToolRadius, level.equipmentHackerToolTimeMs );

	// Make usable
	triggerHeight = 64;
	triggerRadius = 128;
	
	self.tacticalInsertion.friendlyTrigger = spawn( "trigger_radius_use", self.tacticalInsertion.origin + ( 0, 0, 3 ) );
	self.tacticalInsertion.friendlyTrigger SetCursorHint( "HINT_NOICON", self.tacticalInsertion );
	self.tacticalInsertion.friendlyTrigger SetHintString( &"MP_TACTICAL_INSERTION_PICKUP" );
	if ( level.teamBased )
	{
		self.tacticalInsertion.friendlyTrigger SetTeamForTrigger( self.team );
		self.tacticalInsertion.friendlyTrigger.triggerTeam = self.team;
	}
	self ClientClaimTrigger( self.tacticalInsertion.friendlyTrigger );
	self.tacticalInsertion.friendlyTrigger.claimedBy = self;
	
	self.tacticalInsertion.enemyTrigger = spawn( "trigger_radius_use", self.tacticalInsertion.origin + ( 0, 0, 3 ) );
	self.tacticalInsertion.enemyTrigger SetCursorHint( "HINT_NOICON", self.tacticalInsertion );
	self.tacticalInsertion.enemyTrigger SetHintString( &"MP_TACTICAL_INSERTION_DESTROY" );
	self.tacticalInsertion.enemyTrigger SetInvisibleToPlayer( self );
	if ( level.teamBased )
	{
		self.tacticalInsertion.enemyTrigger SetExcludeTeamForTrigger( self.team );
		self.tacticalInsertion.enemyTrigger.triggerTeamIgnore = self.team;
	}
	
	self.tacticalInsertion clientfield::set( "tacticalinsertion", 1 );
	
	self thread watchDisconnect();
	watcher = weaponobjects::getWeaponObjectWatcherByWeapon( level.weaponTacticalInsertion );
	self.tacticalInsertion thread watchUseTrigger( self.tacticalInsertion.friendlyTrigger,&pickUp, watcher.pickUpSoundPlayer, watcher.pickUpSound );
	self.tacticalInsertion thread watchUseTrigger( self.tacticalInsertion.enemyTrigger,&fizzle );

	if ( isdefined( self.tacticalInsertionCount ) )
		self.tacticalInsertionCount++;
	else
		self.tacticalInsertionCount = 1;
	
	self.tacticalInsertion SetCanDamage( true );
	self.tacticalInsertion.health = 1;
	
	while ( true )
	{
		self.tacticalInsertion waittill( "damage", damage, attacker, direction, point, type, tagName, modelName, partname, weapon, iDFlags );
		
		if ( level.teamBased && ( !isdefined( attacker ) || !isPlayer( attacker ) || attacker.team == self.team ) && attacker != self )
			continue;
		
		if( attacker != self )
		{
			attacker challenges::destroyedEquipment( weapon );
			attacker challenges::destroyedTacticalInsert();
			scoreevents::processScoreEvent( "destroyed_tac_insert", attacker );
		}

		// most equipment should be flash/concussion-able, so it'll disable for a short period of time
		// check to see if the equipment has been flashed/concussed and disable it (checking damage < 5 is a bad idea, so check the weapon name)
		// we're currently allowing the owner/teammate to flash their own
		// do damage feedback
		if ( watcher.stunTime > 0 && weapon.doStun )
		{
			self thread weaponobjects::stunStart( watcher, watcher.stunTime ); 
		}

		if ( weapon.doDamageFeedback )
		{
			// if we're not on the same team then show damage feedback
			if ( level.teambased && self.tacticalInsertion.owner.team != attacker.team )
			{
				if ( damagefeedback::doDamageFeedback( weapon, attacker ) )
					attacker damagefeedback::update();
			}
			// for ffa just make sure the owner isn't the same
			else if ( !level.teambased && self.tacticalInsertion.owner != attacker )
			{
				if ( damagefeedback::doDamageFeedback( weapon, attacker ) )
					attacker damagefeedback::update();
			}
		}

		//Notify player that their tact insert was destroyed
		if ( isdefined( attacker ) && attacker != self )
		{
			if( isdefined( level.globallogic_audio_dialog_on_player_override ) )//TODO T7 - remove once globallogic_audio is shared
			{
				self [[level.globallogic_audio_dialog_on_player_override]]( "tact_destroyed", "item_destroyed" );
			}
		}

		self.tacticalInsertion thread fizzle();
	}
}

function cancel_button_think()
{
	if ( !isdefined( self.tacticalInsertion ) )
	{
		return;
	}

	text = cancel_text_create();

	self thread cancel_button_press();
	
	event = self util::waittill_any_return( "tactical_insertion_destroyed", "disconnect", "end_killcam", "abort_killcam", "tactical_insertion_canceled", "spawned" );

	if ( event == "tactical_insertion_canceled" )
	{
		self.tacticalInsertion destroy_tactical_insertion();
	}

	if ( isdefined( text ) )
	{
		text Destroy();
	}
}

function cancelTackInsertionButton()
{
	if( level.console )
		return self changeSeatButtonPressed();
	else
		return self jumpButtonPressed();
}

function cancel_button_press()
{
	self endon( "disconnect" );
	self endon( "end_killcam" );
	self endon( "abort_killcam" );

	while( true )
	{
		wait( .05 );
		if ( self cancelTackInsertionButton() )
		 break;
	}

	self notify( "tactical_insertion_canceled" );
}

function cancel_text_create()
{
	text = NewClientHudElem( self );
	text.archived = false;
	text.y = -100;
	text.alignX = "center";
	text.alignY = "middle";
	text.horzAlign = "center";
	text.vertAlign = "bottom";
	text.sort = 10; // force to draw after the bars
	text.font = "small";
	text.foreground = true;
	text.hideWhenInMenu = true;
		
	if ( self IsSplitscreen() )
	{
		text.y = -80;
		text.fontscale = 1.2;
	}
	else
	{
		text.fontscale = 1.6;
	}

	text setText( &"PLATFORM_PRESS_TO_CANCEL_TACTICAL_INSERTION" );
	text.alpha = 1;

	return text;
}

function getTacticalInsertions()
{
	tac_inserts = [];

	foreach( player in level.players )
	{
		if ( isdefined( player.tacticalInsertion ))
		{
			tac_inserts[ tac_inserts.size ] = player.tacticalInsertion;
		}
	}

	return tac_inserts;
}

function tacticalInsertionDestroyedByTrophySystem( attacker, trophySystem ) // self == tac insert
{
	owner = self.owner;

	if ( isdefined( attacker ))
	{
		attacker challenges::destroyedEquipment( trophySystem.name );
		attacker challenges::destroyedTacticalInsert();		
	}

	self thread fizzle();

	if( isdefined( owner ))
	{
		owner endon( "death" );
		owner endon( "disconnect" );

		wait (.05); // prevents clash with the player killed/lead change leader dialog(s)

		if( isdefined( level.globallogic_audio_dialog_on_player_override ) )//TODO T7 - remove once globallogic_audio is shared
		{
			owner [[level.globallogic_audio_dialog_on_player_override]]( "tact_destroyed", "item_destroyed" );
		}
	}
}

function begin_other_grenade_tracking()
{
	self endon( "death" );
	self endon( "disconnect" );
	
	self notify( "insertionTrackingStart" );	
	self endon( "insertionTrackingStart" );
	
	for (;;)
	{
		self waittill ( "grenade_fire", grenade, weapon, cookTime );

		if ( grenade util::isHacked() )
		{
			continue;
		}
		
		if ( weapon == level.weaponTacticalInsertion )
		{
			grenade thread watch( self );
		}
	}
}
