#using scripts\shared\util_shared;
#using scripts\shared\hud_util_shared;
#using scripts\cp\_laststand;
#using scripts\shared\laststand_shared;

    	   	                                                                                                                         	                                                                                                                                                                                                                                                                                                                                                                    	        	     	             	    	   	                           	                               	                                	                                                              	                                                                                                              	                            	                                     	                                       	                                                               	   	                  	       	                                                    	                   	                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                       	                                                                                        	           	                        	                                            	                                             	                                                   	                                                             	                                                         	                                                                    	                                                                                                                                                                                                    	                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                     	                                                              	                                                          	                                   	                                   	                                                    	                                       

#namespace ai_laststand;
	
function ai_is_in_laststand()
{
	if ( !( isdefined( self.no_revive_trigger ) && self.no_revive_trigger ) )
	{
		return ( IsDefined( self.revivetrigger ) );
	}
	else
	{
		return ( ( isdefined( self.laststand ) && self.laststand ) );
	}
}

//function AILastStand( eInflictor, attacker, iDamage, sMeansOfDeath, weapon, vDir, sHitLoc, psOffsetTime, delayOverride )
function AILastStand()
{
	self notify("entering_last_stand");

	if( self ai_is_in_laststand() )
	{
		return;
	}
	
/*
	self.lastStandParams = spawnstruct();
	self.lastStandParams.eInflictor = eInflictor;
	self.lastStandParams.attacker = attacker;
	self.lastStandParams.iDamage = iDamage;
	self.lastStandParams.sMeansOfDeath = sMeansOfDeath;
	self.lastStandParams.sWeapon = weapon;
	self.lastStandParams.vDir = vDir;
	self.lastStandParams.sHitLoc = sHitLoc;
	self.lastStandParams.lastStandStartTime = gettime();	
	
	self thread player_last_stand_stats( eInflictor, attacker, iDamage, sMeansOfDeath, weapon, vDir, sHitLoc, psOffsetTime, delayOverride );
	
	if( IsDefined( level.playerlaststand_func ) )
	{
		[[level.playerlaststand_func]]( eInflictor, attacker, iDamage, sMeansOfDeath, weapon, vDir, sHitLoc, psOffsetTime, delayOverride );
	}
*/	
	self.health = 1;
	self.laststand = true;
	self.ignoreme = true;
	self util::magic_bullet_shield();
//	self SetLowReady( true );
	self.meleeAttackers = undefined;

	
//	callback::callback( #"on_player_laststand" );
	

	// revive trigger
	if ( !( isdefined( self.no_revive_trigger ) && self.no_revive_trigger ) )
	{
		self ai_revive_trigger_spawn();
	}
	else
	{
		self UndoLastStand(); // hide the overhead icon if there's no trigger
	}
	
//	self thread laststand_watch_weapon_switch();

	// Reset Disabled Power Perks Array On Downed State
	//-------------------------------------------------
	if ( IsDefined( self.disabled_perks ) )
	{
		self.disabled_perks = [];
	}
/*
	{
		// bleed out timer
		bleedout_time = GetDvarfloat( "player_lastStandBleedoutTime" );
		
		if(delayOverride != 0)
		{
			if(delayOverride == LASTSTAND_DELAY_OVERRIDE_NONE)
				delayOverride = 0;
			
			bleedout_time = delayOverride;
		}
		
		self thread laststand_bleedout( bleedout_time );
	}
*/
//	demo::bookmark( "player_downed", gettime(), self );
	
	self notify( "ai_downed" );
//	self thread refire_player_downed();
	
	//clean up revive trigger if he disconnects while in laststand
	self thread laststand::cleanup_laststand_on_disconnect();
}


// spawns the trigger used for the player to get revived
function ai_revive_trigger_spawn()
{
	radius = GetDvarint( "revive_trigger_radius" );
	self.revivetrigger = spawn( "trigger_radius", (0.0,0.0,0.0), 0, radius, radius );
	self.revivetrigger setHintString( "" ); // only show the hint string if the triggerer is facing me
	self.revivetrigger setCursorHint( "HINT_NOICON" );
	self.revivetrigger SetMovingPlatformEnabled( true );
	self.revivetrigger EnableLinkTo();
	self.revivetrigger.origin = self.origin;
	self.revivetrigger LinkTo( self ); 

	self.revivetrigger.beingRevived = 0;
	self.revivetrigger.createtime = gettime();

	self thread revive_trigger_think();
	//self.revivetrigger thread revive_debug();
}


// logic for the revive trigger
function revive_trigger_think()
{
	self endon ( "disconnect" );
	self endon ( "stop_revive_trigger" );
	level endon("game_ended");
	self endon( "death" );
	
	while ( 1 )
	{
		wait ( 0.1 );
	
		if( !isdefined(self.revivetrigger) )
		{
			self notify ( "stop_revive_trigger" );
		}
		self.revivetrigger setHintString( "" );

		players = GetPlayers();

		for ( i = 0; i < players.size; i++ )
		{
			if ( players[i] laststand::can_revive( self ) )
			{
				// TODO: This will turn on the trigger hint for every player within
				// the radius once one of them faces the revivee, even if the others
				// are facing away. Either we have to display the hints manually here
				// (making sure to prioritize against any other hints from nearby objects),
				// or we need a new combined radius+lookat trigger type.						
				self.revivetrigger setReviveHintString( &"COOP_BUTTON_TO_REVIVE_PLAYER", self.team );
				break;			
			}
		}

		for ( i = 0; i < players.size; i++ )
		{
			reviver = players[i];
			
			if ( self == reviver || !reviver is_reviving_ai( self ) )
			{
				continue;
			}
			
			// give the syrette
			gun = reviver GetCurrentWeapon();
			assert( IsDefined( gun ) );
			//assert( gun != level.weaponNone );
			if ( gun == level.weaponReviveTool )
			{
				//already reviving somebody
				continue;
			}

			reviver GiveWeapon( level.weaponReviveTool );
			reviver SwitchToWeapon( level.weaponReviveTool );
			reviver SetWeaponAmmoStock( level.weaponReviveTool, 1 );

			reviver DisableWeaponFire();
			reviver DisableWeaponCycling();
			reviver DisableUsability();
			reviver DisableOffhandWeapons();

			//CODER_MOD: TOMMY K
			revive_success = reviver revive_do_revive_ai( self, gun );
			
			reviver laststand::revive_give_back_weapons( gun );

			//PI CHANGE: player couldn't jump - allow this again now that they are revived
			if ( IsPlayer( self ) )
			{
				self AllowJump(true);
			}
			//END PI CHANGE
			
			self.laststand = undefined;

			if( revive_success )
			{
				self notify ( "ai_revived", reviver );
				self.revivetrigger delete();
//				self thread laststand::revive_success( reviver );
//				self cleanup_suicide_hud();
				return;
			}
		}
	}
}


function can_revive_ai( revivee )
{
	if ( !isDefined( revivee.revivetrigger ) )
	{
		return false;
	}

	if ( !isAlive( self ) )
	{
		return false;
	}

	if ( self laststand::player_is_in_laststand() )
	{
		return false;
	}

	if( self.team != revivee.team ) 
	{
		return false;
	}

	if ( ( isdefined( level.can_revive_use_depthinwater_test ) && level.can_revive_use_depthinwater_test ) && revivee depthinwater() > 10 )
	{
		return true;
	}

	if ( isDefined( level.can_revive ) && ![[ level.can_revive ]]( revivee ) )
	{
		return false;
	}

	if ( isDefined( level.can_revive_game_module ) && ![[ level.can_revive_game_module ]]( revivee ) )
	{
		return false;
	}

	ignore_sight_checks = false;
	ignore_touch_checks = false;
	if ( IsDefined( level.revive_trigger_should_ignore_sight_checks ) )
	{
		ignore_sight_checks = [[ level.revive_trigger_should_ignore_sight_checks ]]( self );

		if( ignore_sight_checks && isdefined(revivee.revivetrigger.beingRevived) && (revivee.revivetrigger.beingRevived==1) )
		{
			ignore_touch_checks = true;
		}
	}

	if( !ignore_touch_checks )
	{
		if ( !self IsTouching( revivee.revivetrigger ) )
		{
			return false;
		}
	}

	if( !ignore_sight_checks )
	{
		if ( !self laststand::is_facing( revivee ) )
		{
			return false;
		}

		if ( !SightTracePassed( self.origin + ( 0, 0, 50 ), revivee.origin + ( 0, 0, 30 ), false, undefined ) )				
		{
			return false;
		}

		//chrisp - fix issue where guys can sometimes revive thru a wall	
		if ( !bullettracepassed( self.origin + (0, 0, 50), revivee.origin + (0, 0, 30), false, undefined ) )
		{
			return false;
		}	
	}

	//iprintlnbold("REVIVE IS GOOD");
	return true;
}



function is_reviving_ai( revivee )
{	
	return ( self UseButtonPressed() && can_revive_ai( revivee ) );
}



// self = reviver
function revive_do_revive_ai( playerBeingRevived, reviverGun )
{
	assert( self is_reviving_ai( playerBeingRevived ) );
	// reviveTime used to be set from a Dvar, but this can no longer be tunable:
	// it has to match the length of the third-person revive animations for
	// co-op gameplay to run smoothly.
	reviveTime = 3;

	if ( self HasPerk( "specialty_quickrevive" ) )
	{
		reviveTime = reviveTime / 2;
	}

	timer = 0;
	revived = false;
	
	playerBeingRevived.revivetrigger.beingRevived = 1;
	
	if( !isdefined(self.reviveProgressBar) )
	{
		self.reviveProgressBar = self hud::createPrimaryProgressBar();
	}

	if( !isdefined(self.reviveTextHud) )
	{
		self.reviveTextHud = newclientHudElem( self );
	}
	
	self thread laststand_ai_clean_up_on_interrupt( playerBeingRevived, reviverGun );

	if ( !IsDefined( self.is_reviving_any ) )
	{
		self.is_reviving_any = 0;
	}
	self.is_reviving_any++;
	self thread laststand_ai_clean_up_reviving_any( playerBeingRevived );
	
	if ( isdefined( self.reviveProgressBar ) )
	{
		self.reviveProgressBar hud::updateBar( 0.01, 1 / reviveTime );
	}

	self.reviveTextHud.alignX = "center";
	self.reviveTextHud.alignY = "middle";
	self.reviveTextHud.horzAlign = "center";
	self.reviveTextHud.vertAlign = "bottom";
	self.reviveTextHud.y = -113;
	if ( self IsSplitScreen() )
	{
		self.reviveTextHud.y = -347;
	}
	self.reviveTextHud.foreground = true;
	self.reviveTextHud.font = "default";
	self.reviveTextHud.fontScale = 1.8;
	self.reviveTextHud.alpha = 1;
	self.reviveTextHud.color = ( 1.0, 1.0, 1.0 );
	self.reviveTextHud.hidewheninmenu = true;
	self.reviveTextHud setText( &"COOP_REVIVING" );
	
	while( self is_reviving_ai( playerBeingRevived ) )
	{
		wait 0.05;
		timer += 0.05;

		if ( self ai_is_in_laststand() )
		{
			break;
		}
		
		if( timer >= reviveTime)
		{
			revived = true;
			break;
		}
	}
	
	if( isdefined( self.reviveProgressBar ) )
	{
		self.reviveProgressBar hud::destroyElem();
	}
	
	if( isdefined( self.reviveTextHud ) )
	{
		self.reviveTextHud destroy();
	}
	
	if( !revived )
	{
		if ( IsPlayer( playerBeingRevived ) )
		{
			playerBeingRevived stoprevive( self );
		}
	}

	playerBeingRevived.revivetrigger setHintString( &"COOP_BUTTON_TO_REVIVE_PLAYER" );
	playerBeingRevived.revivetrigger.beingRevived = 0;

	self notify( "do_revive_ended_normally" );
	self.is_reviving_any--;

	/*
	// This player stopper reviving (kick of a thread to check to see if the player now bleeds out)
	if( !revived )
	{
		playerBeingRevived thread checkforbleedout( self );
	}
	*/	
	
	return revived;
}

function laststand_ai_clean_up_on_interrupt( playerBeingRevived, reviverGun )
{
	self endon( "do_revive_ended_normally" );

	reviveTrigger = playerBeingRevived.revivetrigger;

	playerBeingRevived util::waittill_any("disconnect", "game_ended" );	
	
	if( isdefined( reviveTrigger ) )
	{
		reviveTrigger delete();
	}
	//self cleanup_suicide_hud();
	
	if( isdefined( self.reviveProgressBar ) )
	{
		self.reviveProgressBar hud::destroyElem();
	}
	
	if( isdefined( self.reviveTextHud ) )
	{
		self.reviveTextHud destroy();
	}
	
	self laststand::revive_give_back_weapons( reviverGun );
}

function laststand_ai_clean_up_reviving_any( playerBeingRevived )
{
	self endon( "do_revive_ended_normally" );

	playerBeingRevived util::waittill_any( "disconnect", "zombified", "stop_revive_trigger" );

	self.is_reviving_any--;
	if ( 0 > self.is_reviving_any )
	{
		self.is_reviving_any = 0;
	}
}

