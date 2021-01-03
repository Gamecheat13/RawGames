#using scripts\codescripts\struct;

#using scripts\shared\callbacks_shared;
#using scripts\shared\flag_shared;
#using scripts\shared\system_shared;
#using scripts\shared\util_shared;

    	   	                                                                                                                                         	                                	                                                                                                                                                                                                                                                                                                                                                                    	        	     	             	    	   	               	                                              	                                                           	                               	                     	                                                                                                           	                                                                 	                                                              	                                                                                                              	                            	                                     	                                       	                                                                                                              	   	                  	       	                                                    	                   	                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                        	                                  	                                                                                        	           	                        	                                            	                                             	                                                   	                                                             	                                                         	                                                                    	                                                                                                                                                                                                    	                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                         	                                                              	                                                          	                                   	                                   	                                                    	                                       	                                           	     	                                                                                                                                                                                                                                                      	                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                     

#using scripts\zm\_util;
#using scripts\zm\_zm_perks;

#precache( "material", "overlay_low_health" );

#namespace zm_playerhealth;

function autoexec __init__sytem__() {     system::register("zm_playerhealth",&__init__,undefined,undefined);    }

function __init__()
{
	level.global_damage_func_ads =&empty_kill_func; 
	level.global_damage_func =&empty_kill_func; 

	level.difficultyType[ 0 ] = "easy";
	level.difficultyType[ 1 ] = "normal";
	level.difficultyType[ 2 ] = "hardened";
	level.difficultyType[ 3 ] = "veteran";

	level.difficultyString[ "easy" ] = &"GAMESKILL_EASY";
	level.difficultyString[ "normal" ] = &"GAMESKILL_NORMAL";
	level.difficultyString[ "hardened" ] = &"GAMESKILL_HARDENED";
	level.difficultyString[ "veteran" ] = &"GAMESKILL_VETERAN";

	/#
	thread playerHealthDebug();
	#/

	level.gameSkill = 1;

	switch ( level.gameSkill )
	{
		case 0:
			SetDvar ("currentDifficulty", "easy");	
			break;
		case 1:
			SetDvar ("currentDifficulty", "normal");
			break;
		case 2:
			SetDvar ("currentDifficulty", "hardened");
			break;
		case 3:
			SetDvar ("currentDifficulty", "veteran");	
			break;
	}
	
	/#print( "difficulty: " + level.gameSkill );#/

	level.player_deathInvulnerableTime = 1700;
	level.longRegenTime = 5000;
	level.healthOverlayCutoff = 0.2;
	level.invulTime_preShield = 0.35;
	level.invulTime_onShield = 0.5;
	level.invulTime_postShield = 0.3;
	level.playerHealth_RegularRegenDelay = 2400;
	level.worthyDamageRatio = 0.1;

	callback::on_spawned( &on_player_spawned );
}

function on_player_spawned()
{		
	// Make sure max health is set back to default - Needed for persistent jugg upgrade
	// There are numerous places the health is set, this one should override them all as the player is spawned (MikeA: 12/21/12)
	self zm_perks::perk_set_max_health_if_jugg( "health_reboot", true, false );

	self notify( "noHealthOverlay" );
	self thread playerHealthRegen();
}

function playerHurtcheck()
{
	self endon("noHealthOverlay");
	
	self.hurtAgain = false;
	for ( ;; )
	{
		self waittill( "damage", amount, attacker, dir, point, mod );
		
		if(isdefined(attacker) && isplayer(attacker) && attacker.team == self.team)
		{
			continue;
		}
		
		self.hurtAgain = true;
		self.damagePoint = point;
		self.damageAttacker = attacker;
	}
}

function playerHealthRegen()
{
	self notify("playerHealthRegen");
	self endon ("playerHealthRegen");
	self endon ("death");
	self endon ("disconnect");

	if( !isdefined( self.flag ) )
	{
		self.flag = []; 
		self.flags_lock = []; 
	}
	if( !isdefined(self.flag["player_has_red_flashing_overlay"]) )
	{
		self flag::init("player_has_red_flashing_overlay");
		self flag::init("player_is_invulnerable");
	}
	self flag::clear("player_has_red_flashing_overlay");
	self flag::clear("player_is_invulnerable");		

	self thread healthOverlay();
	oldratio = 1;
	health_add = 0;
	
	regenRate = 0.1; // 0.017;

	veryHurt = false;
	playerJustGotRedFlashing = false;
	
	invulTime = 0;
	hurtTime = 0;
	newHealth = 0;
	lastinvulratio = 1;
	self thread playerHurtcheck();
	if(!isdefined (self.veryhurt))
	{
		self.veryhurt = 0;	
	}
	
	self.boltHit = false;
	
	if( GetDvarString( "scr_playerInvulTimeScale" ) == "" )
	{
		SetDvar( "scr_playerInvulTimeScale", 1.0 );
	}

	//CODER_MOD: King (6/11/08) - Local copy of this dvar. Calling dvar get is expensive
	playerInvulTimeScale = GetDvarFloat( "scr_playerInvulTimeScale" );

	for( ;; )
	{
		{wait(.05);};
		waittillframeend; // if we're on hard, we need to wait until the bolt damage check before we decide what to do

		if( self.health == self.maxHealth )
		{
			if( self flag::get( "player_has_red_flashing_overlay" ) )
			{
				self flag::clear( "player_has_red_flashing_overlay" );
			}

			lastinvulratio = 1;
			playerJustGotRedFlashing = false;
			veryHurt = false;
			continue;
		}

		if( self.health <= 0 )
		{
			 /#showHitLog();#/ 
			return;
		}

		wasVeryHurt = veryHurt;
		health_ratio = self.health / self.maxHealth;

		if( health_ratio <= level.healthOverlayCutoff )
		{
			veryHurt = true;
			
			if( !wasVeryHurt )
			{
				hurtTime = gettime();
				self startfadingblur( 3.6, 2 );

				self flag::set( "player_has_red_flashing_overlay" );
				playerJustGotRedFlashing = true;
			}
		}

		if( self.hurtAgain )
		{
			hurtTime = gettime();
			self.hurtAgain = false;
		}

		if( health_ratio >= oldratio )
		{
			if( gettime() - hurttime < level.playerHealth_RegularRegenDelay )
			{
				continue;
			}

			if( veryHurt )
			{
				self.veryhurt = 1;
				newHealth = health_ratio;
				if( gettime() > hurtTime + level.longRegenTime )
				{
					newHealth += regenRate;
				}
			}
			else
			{
				newHealth = 1;
				self.veryhurt = 0;
			}
							
			if( newHealth > 1.0 )
			{
				newHealth = 1.0;
			}
			
			if( newHealth <= 0 )
			{
				 // Player is dead
				return;
			}
			
			 /#
			if( newHealth > health_ratio )
			{
				logRegen( newHealth );
			}
			#/ 

			self setnormalhealth( newHealth );

			oldratio = self.health / self.maxHealth;
			continue;
		}
		// if we're here, we have taken damage: health_ratio < oldratio.

		invulWorthyHealthDrop = lastinvulRatio - health_ratio > level.worthyDamageRatio;

		if( self.health <= 1 )
		{
			 // if player's health is <= 1, code's player_deathInvulnerableTime has kicked in and the player won't lose health for a while.
			 // set the health to 2 so we can at least detect when they're getting hit.
			self setnormalhealth( 2 / self.maxHealth );
			invulWorthyHealthDrop = true;
/#
			if ( !isdefined( level.player_deathInvulnerableTimeout ) )
			{
				level.player_deathInvulnerableTimeout = 0;
			}
			if ( level.player_deathInvulnerableTimeout < gettime() )
			{
				level.player_deathInvulnerableTimeout = gettime() + GetDvarInt( "player_deathInvulnerableTime" );
			}
			#/ 
		}

		oldratio = self.health / self.maxHealth;

		level notify( "hit_again" );

		health_add = 0;
		hurtTime = gettime();
		self startfadingblur( 3, 0.8 );
		
		if( !invulWorthyHealthDrop || playerInvulTimeScale <= 0.0 )
		{
			 /#logHit( self.health, 0 );#/ 
			continue;
		}

		if( self flag::get( "player_is_invulnerable" ) )
			continue;
		self flag::set( "player_is_invulnerable" );
		level notify( "player_becoming_invulnerable" ); // because "player_is_invulnerable" notify happens on both set * and * clear

		if( playerJustGotRedFlashing )
		{
			invulTime = level.invulTime_onShield;
			playerJustGotRedFlashing = false;
		}
		else if( veryHurt )
		{
			invulTime = level.invulTime_postShield;
		}
		else
		{
			invulTime = level.invulTime_preShield;
		}

		invulTime *= playerInvulTimeScale;

		 /#logHit( self.health, invulTime );#/ 
		lastinvulratio = self.health / self.maxHealth;
		self thread playerInvul( invulTime );
	}
}

function playerInvul( timer )
{
	self endon( "death" );
	self endon( "disconnect" );

	if ( timer > 0 )
	{
		/#
		level.playerInvulTimeEnd = gettime() + timer * 1000;
		#/ 
	
		wait( timer );
	}
	
	self flag::clear( "player_is_invulnerable" );
}


function healthOverlay()
{
	self endon( "disconnect" );
	self endon( "noHealthOverlay" );

	if(!isdefined(self._health_overlay))
	{
		self._health_overlay = newClientHudElem( self );
		self._health_overlay.x = 0;
		self._health_overlay.y = 0;
		self._health_overlay setshader( "overlay_low_health", 640, 480 );
		self._health_overlay.alignX = "left";
		self._health_overlay.alignY = "top";
		self._health_overlay.horzAlign = "fullscreen";
		self._health_overlay.vertAlign = "fullscreen";
		self._health_overlay.alpha = 0;
	}
	
	overlay = self._health_overlay;
	
	// CODER_MOD
	// Austin (4/19/08): fade out the overlay for the 4/21 milestone
	self thread healthOverlay_remove( overlay );
	self thread watchHideRedFlashingOverlay( overlay );
	
	pulseTime = 0.8;
	for( ;; )
	{
		if ( overlay.alpha > 0 )
			overlay fadeOverTime( 0.5 );
		overlay.alpha = 0;

		// CODER_MOD
		// Austin (5/29/07): restore these flags as player flags, these changes were clobbered during the integrate
		self flag::wait_till( "player_has_red_flashing_overlay" );
		self redFlashingOverlay( overlay );
	}	
}

function fadeFunc( overlay, severity, mult, hud_scaleOnly )
{
	pulseTime = 0.8;
	scaleMin = 0.5;
	
	fadeInTime = pulseTime * 0.1;
	stayFullTime = pulseTime * ( .1 + severity * .2 );
	fadeOutHalfTime = pulseTime * ( 0.1 + severity * .1 );
	fadeOutFullTime = pulseTime * 0.3;
	remainingTime = pulseTime - fadeInTime - stayFullTime - fadeOutHalfTime - fadeOutFullTime;
	assert( remainingTime >= -.001 );
	if ( remainingTime < 0 )
	{
		remainingTime = 0;
	}
	
	halfAlpha = 0.8 + severity * 0.1;
	leastAlpha = 0.5 + severity * 0.3;
	
	overlay fadeOverTime( fadeInTime );
	overlay.alpha = mult * 1.0;
	wait fadeInTime + stayFullTime;
	
	overlay fadeOverTime( fadeOutHalfTime );
	overlay.alpha = mult * halfAlpha;
	wait fadeOutHalfTime;
	
	overlay fadeOverTime( fadeOutFullTime );
	overlay.alpha = mult * leastAlpha;
	wait fadeOutFullTime;

	wait remainingTime;
}

function watchHideRedFlashingOverlay( overlay )
{
	self endon( "death_or_disconnect");
	
	while (isdefined(overlay))
	{
		self waittill("clear_red_flashing_overlay"); 
	
		self flag::clear( "player_has_red_flashing_overlay" );
		
		overlay fadeOverTime( 0.05 );
		overlay.alpha = 0;
	
		// MikeD (8/1/2008): Send to CSC that the 'rfo' "red flashing overlay" is getting better and play the better breathing sound
		util::setclientsysstate( "levelNotify", "rfo3", self );
	
		self notify( "hit_again" );
	}
}

function redFlashingOverlay( overlay )
{
	self endon( "hit_again" );
	self endon( "damage" );
	self endon ("death");
	self endon ("disconnect");
	self endon( "clear_red_flashing_overlay" );

	//prof_begin( "redFlashingOverlay" );
	
	// if severity isn't very high, the overlay becomes very unnoticeable to the player.
	// keep it high while they haven't regenerated or they'll feel like their health is nearly full and they're safe to step out.
	
	self.stopFlashingBadlyTime = gettime() + level.longRegenTime;

	if ( !( isdefined( self.is_in_process_of_zombify ) && self.is_in_process_of_zombify ) && !( isdefined( self.is_zombie ) && self.is_zombie ) )
	{
		fadeFunc( overlay, 1, 1, false );
		while ( gettime() < self.stopFlashingBadlyTime && isalive( self ) && ( !( isdefined( self.is_in_process_of_zombify ) && self.is_in_process_of_zombify ) && !( isdefined( self.is_zombie ) && self.is_zombie ) ) )
		{
			fadeFunc( overlay, .9, 1, false );
		}
	
		if ( !( isdefined( self.is_in_process_of_zombify ) && self.is_in_process_of_zombify ) && !( isdefined( self.is_zombie ) && self.is_zombie ) )
		{
			if ( isalive( self ) )
			{
				fadeFunc( overlay, .65, 0.8, false );
			}
	
			fadeFunc( overlay, 0, 0.6, true );
		}
	}
	
	overlay fadeOverTime( 0.5 );
	overlay.alpha = 0;
	
	// CODER_MOD
	// Austin (5/29/07): restore this flag as a player flag, these changes were clobbered during the integrate
	self flag::clear( "player_has_red_flashing_overlay" );

	// MikeD (8/1/2008): Send to CSC that the 'rfo' "red flashing overlay" is getting better and play the better breathing sound
	util::setClientSysState( "levelNotify", "rfo3", self );


	//prof_end( "redFlashingOverlay" );

	wait( 0.5 );// for fade out
	self notify( "hit_again" );
}

function healthOverlay_remove( overlay )
{
	// this hud element will get cleaned up automatically by the code when the player disconnects
	// so we just need to make sure this thread ends
	self endon ("disconnect");
	// CODER_MOD
	// Austin (5/29/07): restore these they were clobbered during the integrate
	self util::waittill_any ("noHealthOverlay", "death");

	overlay fadeOverTime( 3.5 );
	overlay.alpha = 0;
}

function empty_kill_func( type, loc, point, attacker, amount )
{
	
}

/#
function logHit( newhealth, invulTime )
{
	/* if ( !isdefined( level.hitlog ) )
	{
		level.hitlog = [];
		thread showHitLog();
	}
	
	data = spawnstruct();
	data.regen = false;
	data.time = gettime();
	data.health = newhealth / self.maxhealth;
	data.invulTime = invulTime;
	
	level.hitlog[ level.hitlog.size ] = data;*/ 
}

function logRegen( newhealth )
{
	/* if ( !isdefined( level.hitlog ) )
	{
		level.hitlog = [];
		thread showHitLog();
	}
	
	data = spawnstruct();
	data.regen = true;
	data.time = gettime();
	data.health = newhealth / self.maxhealth;
	
	level.hitlog[ level.hitlog.size ] = data;*/ 
}

function showHitLog()
{
}

function playerHealthDebug()
{
	if ( GetDvarString( "scr_health_debug" ) == "" )
	{
		SetDvar( "scr_health_debug", "0" );
	}

	waittillframeend; // for init to finish
	
	while ( 1 )
	{
		while ( 1 )
		{
			if ( GetDvarString( "scr_health_debug" ) != "0" )
			{
				break;
			}
			wait .5;
		}
		thread printHealthDebug();
		while ( 1 )
		{
			if ( GetDvarString( "scr_health_debug" ) == "0" )
			{
				break;
			}
			wait .5;
		}
		level notify( "stop_printing_grenade_timers" );
		destroyHealthDebug();
	}
}

function printHealthDebug()
{
	level notify( "stop_printing_health_bars" );
	level endon( "stop_printing_health_bars" );
	
	x = 40;
	y = 40;
	
	level.healthBarHudElems = [];
	
	level.healthBarKeys[ 0 ] = "Health";
	level.healthBarKeys[ 1 ] = "No Hit Time";
	level.healthBarKeys[ 2 ] = "No Die Time";
	
	if ( !isdefined( level.playerInvulTimeEnd ) )
	{
		level.playerInvulTimeEnd = 0;
	}

	if ( !isdefined( level.player_deathInvulnerableTimeout ) )
	{
		level.player_deathInvulnerableTimeout = 0;
	}
	
	for ( i = 0; i < level.healthBarKeys.size; i++ )
	{
		key = level.healthBarKeys[ i ];
		
		textelem = newHudElem();
		textelem.x = x;
		textelem.y = y;
		textelem.alignX = "left";
		textelem.alignY = "top";
		textelem.horzAlign = "fullscreen";
		textelem.vertAlign = "fullscreen";
		textelem setText( key );
		
		bgbar = newHudElem();
		bgbar.x = x + 79;
		bgbar.y = y + 1;
		bgbar.alignX = "left";
		bgbar.alignY = "top";
		bgbar.horzAlign = "fullscreen";
		bgbar.vertAlign = "fullscreen";
		bgbar.maxwidth = 3;
		bgbar setshader( "white", bgbar.maxwidth, 10 );
		bgbar.color = ( 0.5, 0.5, 0.5 );

		bar = newHudElem();
		bar.x = x + 80;
		bar.y = y + 2;
		bar.alignX = "left";
		bar.alignY = "top";
		bar.horzAlign = "fullscreen";
		bar.vertAlign = "fullscreen";
		bar setshader( "black", 1, 8 );
		
		textelem.bar = bar;
		textelem.bgbar = bgbar;
		textelem.key = key;
		
		y += 10;
		
		level.healthBarHudElems[ key ] = textelem;
	}

	level flag::wait_till( "start_zombie_round_logic" );
	
	while ( 1 )
	{
		wait .05;
		
		// CODER_MOD - JamesS fix for coop
		players = GetPlayers();
		
		for ( i = 0; i < level.healthBarKeys.size && players.size > 0; i++ )
		{
			key = level.healthBarKeys[ i ];
			
			player = players[0];
			
			width = 0;
			if ( i == 0 )
			{
				width = player.health / player.maxhealth * 300;
			}
			else if ( i == 1 )
			{
				width = ( level.playerInvulTimeEnd - gettime() ) / 1000 * 40;
			}
			else if ( i == 2 )
			{
				width = ( level.player_deathInvulnerableTimeout - gettime() ) / 1000 * 40;
			}

			width = int( max( width, 1 ) );
			width = int( min( width, 300 ) );

			bar = level.healthBarHudElems[ key ].bar;
			bar setShader( "black", width, 8 );

			bgbar = level.healthBarHudElems[ key ].bgbar;
			if( width+2 > bgbar.maxwidth )
			{
				bgbar.maxwidth = width+2;
				bgbar setshader( "white", bgbar.maxwidth, 10 );
				bgbar.color = ( 0.5, 0.5, 0.5 );
			}
		}
	}
}

function destroyHealthDebug()
{
	if ( !isdefined( level.healthBarHudElems ) )
	{
		return;
	}
	for ( i = 0; i < level.healthBarKeys.size; i++ )
	{
		level.healthBarHudElems[ level.healthBarKeys[ i ] ].bgbar destroy();
		level.healthBarHudElems[ level.healthBarKeys[ i ] ].bar destroy();
		level.healthBarHudElems[ level.healthBarKeys[ i ] ] destroy();
	
	}
}
#/ 

