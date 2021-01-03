#using scripts\shared\flag_shared;
#using scripts\shared\flagsys_shared;
#using scripts\shared\util_shared;

    	   	                                                                                                                                         	                                	                                                                                                                                                                                                                                                                                                                                                                    	        	     	             	    	   	               	                                              	                                                           	                               	                     	                                                                                                           	                                                                 	                                                              	                                                                                                              	                            	                                     	                                       	                                                                                                              	   	                  	       	                                                    	                   	                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                        	                                  	                                                                                        	           	                        	                                            	                                             	                                                   	                                                             	                                                         	                                                                    	                                                                                                                                                                                                    	                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                         	                                                              	                                                          	                                   	                                   	                                                    	                                       	                                           	     	                                                                                                                                                                                                                                                      	                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                     

#using scripts\shared\ai\systems\weaponList;

#using scripts\codescripts\struct;


#namespace gameskill;

// this script handles all major global gameskill considerations
function setSkill( reset, skill_override )
{
	if ( !isdefined( level.script ) )
	{
		level.script = tolower( GetDvarString( "mapname" ) );
	}
	
	if ( !isdefined( reset ) || reset == false )
	{
		if ( isdefined( level.gameSkill ) )
		{
			return;
		}
	
		// TFLAME - 2/17/11 - useless func pointers for SP, but are set up in zombies.  If they are always set up in zombies we shouldnt need them here... check if we can do without after zombie integrate
		level.global_damage_func_ads =&empty_kill_func;
		level.global_damage_func =&empty_kill_func;
		level.global_kill_func =&empty_kill_func;
	
			// first init stuff
		util::set_console_status();
		
		// CODER_MOD - Sumeet, track skill changes in game
		level thread update_skill_on_change();
		
		thread playerHealthDebug();		
	}

	
	if(!isdefined(level.player_attacker_accuracy_multiplier))
	{
		level.player_attacker_accuracy_multiplier = 1;
	}
	
	level.gameSkill = GetLocalProfileInt( "g_gameskill" );
	if( !isDefined( level.gameskill ) )
	{
		level.gameskill = 0;
	}
	
	if ( isdefined( skill_override ) )
	{
		level.gameSkill = skill_override;
	}
	
	replay_single_mission = GetDvarInt( "ui_singlemission" );
	if ( replay_single_mission == 1 )
	{
		single_mission_difficulty = GetDvarInt( "ui_singlemission_difficulty" );
		if ( single_mission_difficulty >= 0 )
		{
			level.gameSkill = single_mission_difficulty;
		}
	}
	
	SetDvar( "saved_gameskill", level.gameSkill );

	switch (level.gameSkill)
	{
		case 0:
			SetDvar ("currentDifficulty", "easy");
			level.currentDifficulty = "easy";
			break;
		case 1:
			SetDvar ("currentDifficulty", "normal");
			level.currentDifficulty = "normal";
			break;
		case 2:
			SetDvar ("currentDifficulty", "hardened");
			level.currentDifficulty = "hardened";
			break;
		case 3:
			SetDvar ("currentDifficulty", "veteran");
			level.currentDifficulty = "veteran";
			break;
		case 4:
			SetDvar ("currentDifficulty", "realistic");
			level.currentDifficulty = "realistic";
			break;
	}
	
	anim.run_accuracy = 0.5;

	/#print( "difficulty: " + level.gameSkill );#/
	
	level.auto_adjust_threatbias = true;
	
	// TFLAME - 2/22/11 - In Hard/Vet, pain_protection makes some AI not respond to pain if multiple AI are shot by the player in a short interval
	// anim.pain_test
	anim.pain_test =&pain_protection;

	// set all the difficulty based variables according to the current difficulty
	set_difficulty_from_locked_settings();

	// TFLAME - 2/18/11 - Moving all coop code I can to only be called if we actually have co-op players
	if ( util::coopGame() )
	{
		thread coop_player_threat_bias_adjuster(); 		// Makes the coop players get targeted more often
		thread coop_enemy_accuracy_scalar_watcher();
		thread coop_friendly_accuracy_scalar_watcher();
	}
}

function apply_difficulty_var_with_func( difficulty_func )
{
	level.playerHealth_RegularRegenDelay = get_player_health_regular_regen_delay();
	level.worthyDamageRatio = get_worthy_damage_ratio();
		
	if ( level.auto_adjust_threatbias )
	{
		thread apply_threat_bias_to_all_players(difficulty_func);
	}

	level.longRegenTime = get_long_regen_time();
		
	anim.player_attacker_accuracy = get_base_enemy_accuracy() * level.player_attacker_accuracy_multiplier;

//	anim.missTimeConstant = get_miss_time_constant();
//	anim.missTimeDistanceFactor = get_miss_time_distance_factor();
	anim.dog_hits_before_kill = get_dog_hits_before_kill();
	
	anim.dog_health = get_dog_health();
	anim.dog_presstime = get_dog_press_time();
		
//	setsaveddvar( "ai_accuracyDistScale", [[ difficulty_func ]]( "accuracyDistScale" ) );
	setsaveddvar( "ai_accuracyDistScale", 1 );  //GSTELMACK - setting this to one as safety net, due to removing difficulty setting - should be removed once verified as not being used any more
	
	thread coop_damage_and_accuracy_scaling(difficulty_func );
}


function apply_threat_bias_to_all_players(difficulty_func)
{
	level flag::wait_till( "all_players_connected" );
	
	players = GetPlayers();
	for( i = 0; i < players.size; i++ )
	{
		players[i].threatbias = int( get_player_threat_bias() );
	}
}

function coop_damage_and_accuracy_scaling( difficulty_func )
{
	level flag::wait_till( "all_players_spawned" );

	players = GetPlayers();
}
	
function set_difficulty_from_locked_settings()
{
	apply_difficulty_var_with_func(&get_locked_difficulty_val );
}


// returns current level difficulty.  locked refers to as opposed to an old system which used to blend difficulties which is now gone
function get_locked_difficulty_val( msg, ignored ) // ignored is there because this is used as a function pointer with another function that does have a second parm
{
	return level.difficultySettings[ msg ][ level.currentDifficulty ];
}

function always_pain()
{
		return false;
}

// TFLAME - 2/22/11 - If you shoot multiple AI within a short interval, sometimes the second guy won’t play a hit reaction.  This helps stop abuse of players
// spraying a clumped group of AI with bullets as they all pain react on harder difficulties
function pain_protection()
{
	if ( !pain_protection_check() )
	{
		return false;
	}
		
	return( randomint( 100 ) > get_enemy_pain_chance() * 100 );
}

function pain_protection_check()
{
	if ( !isalive( self.enemy ) )
	{
		return false;
	}
		
	if ( !IsPlayer(self.enemy) )
	{
		return false;
	}
		
	if ( !isalive( level.painAI ) || level.painAI.a.script != "pain" )
	{
		level.painAI = self;
	}

	// The pain AI can always take pain, so if the player focuses on one guy he'll see pain animations.
	if ( self == level.painAI )
	{
		return false;
	}

	if ( self.damageWeapon != level.weaponNone && self.damageWeapon.isBoltAction )
	{
		return false;
	}

	return true;
}

 
function playerHealthDebug()
{
	/#
	//if ( GetDvarString( "scr_health_debug" ) == "" )
	{
		//SetDvar( "scr_health_debug", "1" );
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
	#/
}

function printHealthDebug()
{
	level notify( "stop_printing_health_bars" );
	level endon( "stop_printing_health_bars" );
	
	const x = 150;
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
		bgbar.z = 1;
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
		bar.sort = 1;
		
		textelem.bar = bar;
		textelem.bgbar = bgbar;
		textelem.key = key;
		
		y += 10;
		
		level.healthBarHudElems[ key ] = textelem;
	}

	level flag::wait_till( "all_players_spawned" );
	
	while ( 1 )
	{
		wait .05;
		
		players = GetPlayers();
		
		for ( i = 0; i < level.healthBarKeys.size && players.size > 0; i++ )
		{
			key = level.healthBarKeys[ i ];
			
			player = players[0];
			
			width = 0;
			if ( i == 0 )
			{
				width = player.health / player.maxhealth * 300;
				level.healthBarHudElems[ key ] SetText( level.healthBarKeys[ 0 ] + " " + player.health );
			}
			else if ( i == 1 )
			{
				width = ( level.playerInvulTimeEnd - GetTime() ) / 1000 * 40;
			}
			else if ( i == 2 )
			{
				width = ( level.player_deathInvulnerableTimeout - GetTime() ) / 1000 * 40;
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
	level notify( "stop_printing_health_bars" );
	
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



// this is run on each enemy AI.
function axisAccuracyControl()
{
	self endon( "long_death" );
	self endon( "death" );
		
	if( level.script != "core_frontend" )
	{
		self coop_axis_accuracy_scaler();
	}
}


// this is run on each friendly AI.
function alliesAccuracyControl()
{
	self endon( "long_death" );
	self endon( "death" );
		
	self coop_allies_accuracy_scaler();
}


function playerHurtcheck()
{
	self endon("killHurtCheck");
	
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

// MikeD (8/7/2007): New player_burned effect.
		if( isdefined (mod) && mod == "MOD_BURNED" )
		{
			self setburn( 0.5 );
			self PlaySound( "chr_burn" );
		}

		invulWorthyHealthDrop = amount / self.maxhealth >= level.worthyDamageRatio; // true if dmg was over 10, or any dmg on easy
		
		death_invuln_time = 0;
		
		if( self.health <= 1 && self player_eligible_for_death_invulnerability() )
		{
			invulWorthyHealthDrop = true;
			
			player_death_invulnerability_time = get_player_death_invulnerable_time();
			coop_death_invulnerability_time_modifier = get_coop_player_death_invulnerable_time_modifier();

			death_invuln_time = player_death_invulnerability_time * coop_death_invulnerability_time_modifier;
			
			self.eligible_for_death_invulnerability = false;
			
			self thread monitor_player_death_invulnerability_eligibility();
			
			level.player_deathInvulnerableTimeout = GetTime() + death_invuln_time; //for health debug overlay tracking only
		}

		oldratio = self.health / self.maxHealth;

		level notify( "hit_again" );

		health_add = 0;
		hurtTime = gettime();
		if( !isdefined( level.disable_damage_blur ) )
		{
			self startfadingblur( 3, 0.8 ); //We get this mini-blur on every hit
		}
		
		if( !invulWorthyHealthDrop  )
		{
			continue;
		}

		if( self flag::get( "player_is_invulnerable" ) )
			continue;
		
		self flag::set( "player_is_invulnerable" );
		level notify( "player_becoming_invulnerable" ); // because "player_is_invulnerable" notify happens on both set * and * clear

		if( death_invuln_time < get_player_hit_invuln_time() )
		{
			invulTime = get_player_hit_invuln_time();
		}
		else
		{
			invulTime = death_invuln_time;
		}

		self thread playerInvul( invulTime );
	}
}


// controls player health regeneration
function playerHealthRegen() //self = player
{
	self endon ("death");
	self endon ("disconnect");
	self endon ("removehealthregen");

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

	self thread increment_take_cover_warnings_on_death(); // TFLAME - 2/22/11 - These systems are broken atm
	self setTakeCoverWarnings();

	self thread healthOverlay();
	oldratio = 1;
	health_add = 0;
	
	veryHurt = false;
	playerJustGotRedFlashing = false;
	
	invulTime = 0;
	hurtTime = 0;
	newHealth = 0;
	self thread playerHurtcheck();
	if(!isdefined (self.veryhurt))
	{
		self.veryhurt = 0;
	}
	
	self.boltHit = false;
	
	for( ;; )
	{
		{wait(.05);};
		waittillframeend; // if we're on hard, we need to wait until the bolt damage check before we decide what to do

		if( self.health == self.maxHealth )
		{
			if( self flag::get( "player_has_red_flashing_overlay" ) )
			{
				flag::clear( "player_has_red_flashing_overlay" );
			}

			playerJustGotRedFlashing = false;
			veryHurt = false;
			continue;
		}

		if( self.health <= 0 )
		{
			return;
		}

		wasVeryHurt = veryHurt;
		health_ratio = self.health / self.maxHealth;

		// Checks difficulty, decides if we're hurt enough to show red hurt overlay/blur.  The harder the difficulty, the sooner this plays.
		if( health_ratio <= get_health_overlay_cutoff() )
		{
			veryHurt = true;	// This controls whether the delay for regenning uses playerHealth_RegularRegenDelay or longRegenTime for the regen delay
			self thread cover_warning_check();
			
			if( !wasVeryHurt )
			{
				hurtTime = gettime();
//				if( !isdefined( level.disable_damage_blur ) )
//				{
//					self startfadingblur( 3.6, 2 );  // GSTELMACK - 7/28/2014 This currently does not seem to have any function in-game
//				}
				
				self flag::set( "player_has_red_flashing_overlay" );
				playerJustGotRedFlashing = true;
			}
		}

		if( self.hurtAgain )
		{
			hurtTime = gettime();
			self.hurtAgain = false;
		}

		
		if( health_ratio >= oldratio ) // Make sure we haven't taken damage since the last frame
		{
			if( gettime() - hurttime < level.playerHealth_RegularRegenDelay ) // based on difficulty, can we start regenerating yet?
			{
				continue;
			}

			if( veryHurt ) // once we're veryhurt, we stay veryhurt until we fully regenerate
			{
				self.veryhurt = 1;
				newHealth = health_ratio;
				if( gettime() > hurtTime + level.longRegenTime ) // has it been 5 seconds since we were hurt? (same for all difficulties)
				{
					const regenRate = 0.1; // 0.017;
					newHealth += regenRate; // always adds 10 health per frame.  At this rate we always regenerate within half a second after the 5 second delay
				}

				if ( newHealth >= 1 )
				{
					reduceTakeCoverWarnings();
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
			
			if( newHealth <= 0 ) // Player is dead
			{
				return;
			}
			
			self setnormalhealth( newHealth );

			oldratio = self.health / self.maxHealth;
			continue;
		}

	}
}

function reduceTakeCoverWarnings()
{
	players = GetPlayers();
	
	if ( isdefined( players[0] ) && isAlive( players[0] ) )
	{
		takeCoverWarnings = GetLocalProfileInt( "takeCoverWarnings" );
		if ( takeCoverWarnings > 0 )
		{
			takeCoverWarnings -- ;
			SetLocalProfileVar( "takeCoverWarnings", takeCoverWarnings );
			 /#DebugTakeCoverWarnings();#/
		}
	}
}

 /#
function DebugTakeCoverWarnings()
{
	if ( GetDvarString( "scr_debugtakecover" ) == "" )
	{
		SetDvar( "scr_debugtakecover", "0" );
	}
	if ( GetDvarString( "scr_debugtakecover" ) == "1" )
	{
		iprintln( "Warnings remaining: ", GetLocalProfileInt( "takeCoverWarnings" ) - 3 );
	}
}
#/


// Makes attacker accuracy 0 and other bullets not hurt player. But I think grenades, melee, and other explosives will still kill player.
function playerInvul( timer )// self = player
{
	self endon( "death" );
	self endon( "disconnect" );
	self.oldattackeraccuracy = self.attackeraccuracy;

	if ( timer > 0 )
	{
		self.attackerAccuracy = 0;
		self.ignoreBulletDamage = true;
		
		level.playerInvulTimeEnd = gettime() + timer * 1000;
		
	
		wait( timer );
	}
	
	self.attackerAccuracy = self.oldattackeraccuracy;
	self.ignoreBulletDamage = false;

	self flag::clear( "player_is_invulnerable" );
}

// sets grenade awareness for all ai.  Appaerntly enemies don't have very good grenade awareness but friendlies all do
function grenadeAwareness()
{
	if ( self.team == "allies" )
	{
		self.grenadeawareness  = 0.9;
		return;
	}
		
	if ( self.team == "axis" )
	{
		if ( isdefined(level.gameSkill) && level.gameSkill >= 2 )
		{
			 // hard and fu
			if ( randomint( 100 ) < 33 )
			{
				self.grenadeawareness = 0.2;
			}
			else
			{
				self.grenadeawareness = 0.5;
			}
		}
		else
		{
			 // normal
			if ( randomint( 100 ) < 33 )
			{
				self.grenadeawareness = 0;
			}
			else
			{
				self.grenadeawareness = 0.2;
			}
		}
	}
}

function playerheartbeatloop(healthcap)
{
	self endon( "disconnect" );
 	self endon( "killed_player" );

	wait (2);
	player = self;
	ent = undefined;
	
	for (;;)
	{
		wait .2;
		// Player still has a lot of health so no hearbeat sound and set to default hearbeat wait
		if (player.health >= healthcap)
		{
			if( isdefined( ent ) )
			{
				ent stoploopsound( 1.5 );
				level thread delayed_delete( ent, 1.5 );
			}
			continue;
		}

		ent = Spawn( "script_origin", self.origin );
		ent playloopsound( "", .5 );
	}
}

function delayed_delete( ent, time )
{
	wait(time);
	ent delete();
	ent = undefined;
}


function healthfadeOffWatcher(overlay,timeToFadeOut)
{
	self notify("new_style_health_overlay_done");
	self endon ("new_style_health_overlay_done");
	while(!( isdefined( level.disable_damage_overlay ) && level.disable_damage_overlay ) && timeToFadeOut>0)
	{
		{wait(.05);};
		timeToFadeOut -= 0.05;
	}
	if (( isdefined( level.disable_damage_overlay ) && level.disable_damage_overlay ))
	{
		overlay.alpha = 0;
		overlay fadeOverTime( 0.05 );
	}
}

function new_style_health_overlay() //self = player
{
	overlay = NewClientHudElem( self );
	overlay.x = 0;
	overlay.y = 0;

	if ( issplitscreen() )
	{
		overlay SetShader( "overlay_low_health_splat", 640, 480 * 2 );

		// offset the blood a little so it looks different for each player
		if ( self == level.players[ 0 ] )
		{
			overlay.y -= 120;
		}
	}
	else
	{
		overlay SetShader( "overlay_low_health_splat", 640, 480 );
	}
	overlay.splatter = true;
	overlay.alignX = "left";
	overlay.alignY = "top";
	overlay.sort = 1;
	overlay.foreground = 0;
	overlay.horzAlign = "fullscreen";
	overlay.vertAlign = "fullscreen";
	overlay.alpha = 0;

	thread healthOverlay_remove( overlay );

	const updateTime = 0.05;
	const timeToFadeOut = 0.75;
	
	while (1)
	{
		wait updateTime;

		if( ( isdefined( level.disable_damage_overlay ) && level.disable_damage_overlay ) )
		{
			targetDamageAlpha 	= 0;
			overlay.alpha 		= 0;
		}
		else
		{
			targetDamageAlpha = 1.0 - self.health / self.maxHealth;
		}

		if ( overlay.alpha < targetDamageAlpha ) // took damage since last update
		{
			overlay.alpha = targetDamageAlpha; // pop to alpha.  jarring effect.  nice.
		}
		else if (  overlay.alpha != 0  ) // full health
		{
			level thread healthfadeOffWatcher(overlay,timeToFadeOut);
			overlay FadeOverTime( timeToFadeOut );
			overlay.alpha = 0;
			// play the breathing better sound
			//self playsound ("chr_breathing_better");
		}
	}
}

function healthOverlay()//self = player
{
	self endon( "disconnect" );
	self endon( "noHealthOverlay" );
	
	new_style_health_overlay();
}

function add_hudelm_position_internal( alignY )
{
	if ( level.console )
	{
		self.fontScale = 2;
	}
	else
	{
		self.fontScale = 1.6;
	}
		
	self.x = 0;// 320;
	self.y = -36;// 200;
	self.alignX = "center";
	self.alignY = "bottom";
	self.horzAlign = "center";
	self.vertAlign = "middle";
	
	if ( !isdefined( self.background ) )
	{
		return;
	}
	self.background.x = 0;// 320;
	self.background.y = -40;// 200;
	self.background.alignX = "center";
	self.background.alignY = "middle";
	self.background.horzAlign = "center";
	self.background.vertAlign = "middle";
	if ( level.console )
	{
		self.background setshader( "popmenu_bg", 650, 52 );
	}
	else
	{
		self.background setshader( "popmenu_bg", 650, 42 );
	}
	self.background.alpha = .5;
}

function create_warning_elem( player )
{
	level notify( "hud_elem_interupt" );
	hudelem = newHudElem();
	hudelem add_hudelm_position_internal();
	hudelem thread destroy_warning_elem_when_mission_failed( player );
	hudelem setText( &"GAME_GET_TO_COVER" );
	hudelem.fontscale = 1.85;
	hudelem.alpha = 1;
	hudelem.color = ( 1, 0.6, 0 );

	return hudelem;
}

function play_hurt_vox()
{
	if(isdefined (self.veryhurt))
	{
		//Randomly plays a "hurt" sound when shot
		if(self.veryhurt == 0)
		{
			if(randomintrange(0,1) == 1)
			{
				playsoundatposition ("chr_breathing_hurt_start", self.origin);
			}
		}
	}
}

function waitTillPlayerIsHitAgain()
{
	level endon( "hit_again" );
	self waittill( "damage" );
}


function destroy_warning_elem_when_mission_failed( player )
{
	self endon( "being_destroyed" );
	self endon ("death");
	
	level flag::wait_till( "missionfailed" );
	
		// TFLAME - 3/22/11 - This shouldn't be player, should be self.  But this was never called in BO because the cover warning stuff was broken
	self thread destroy_warning_elem( true );
}

function destroy_warning_elem( fadeout )
{
	self notify( "being_destroyed" );
	self.beingDestroyed = true;
	
	if ( fadeout )
	{
		self fadeOverTime( 0.5 );
		self.alpha = 0;
		wait 0.5;
	}
	self util::death_notify_wrapper();
	self destroy();
}

function mayChangeCoverWarningAlpha( coverWarning )
{
	if ( !isdefined( coverWarning ) )
	{
		return false;
	}
	if ( isdefined( coverWarning.beingDestroyed ) )
	{
		return false;
	}
	return true;
}


// TFLAME - 2/24/11 - This currently crashes the game, in particular if you use changeFontScaleOverTime. As far as i can tell this is somehow told not to run in zombies, the only time it would get called
function fontScaler( scale, timer )
{
	self endon( "death" );
	scale *= 2;
	dif = scale - self.fontscale;
	self changeFontScaleOverTime( timer );
	self.fontscale += dif;
}

// TFLAME - 2/24/11 - Get the cover warnings working again, will see if any bugs pop up since the system wasn't running at all since midway through black ops
// Seperated the old cover warning system which was integrated together with the old hud since we don't use that hud anymore.  That old health hud really needs to be updated
function cover_warning_check()
{
	level endon( "missionfailed" );
	
	if ( self shouldShowCoverWarning() )
	{
		coverwarning = create_warning_elem( self );
		level.cover_warning_hud = coverwarning;
		
		coverwarning endon( "death" );

		stopFlashingBadlyTime = gettime() + level.longRegenTime;
		
		yellow_fac = 0.7;
		
		while ( gettime() < stopFlashingBadlyTime && isalive( self ) )
		{
			for (i=0; i< 7; i++)
			{
				yellow_fac +=0.03;
				coverwarning.color = (1,yellow_fac,0);
				{wait(.05);};
			}
			
			for (i=0; i< 7; i++)
			{
				yellow_fac -=0.03;
				coverwarning.color = (1,yellow_fac,0);
				{wait(.05);};
			}
		}
		
		if ( mayChangeCoverWarningAlpha( coverwarning ) )
		{
			coverwarning fadeOverTime( 0.5 );
			coverwarning.alpha = 0;
		}
		
		wait( 0.5 );// for fade out
		wait 5;
		coverwarning destroy();
	}
}


// TFLAME - 2/24/11 - Get the cover warnings working again, will see if any bugs pop up since the system wasn't running at all since midway through black ops
function shouldShowCoverWarning()
{
	return false;	// TODO: remove after GL
	
	// Glocke: need to disable this for the Makin outro so adding in a level var
	if( isdefined(level.enable_cover_warning) )
	{
		return level.enable_cover_warning;
	}
	
	if ( !isAlive( self ) )
	{
		return false;
	}
	
	if ( level.gameskill > 1 )
	{
		return false;
	}
	
	if ( level.missionfailed )
	{
		return false;
	}

	if ( isSplitScreen() || util::coopGame() )
	{
		return false;
	}
	
	// note: takeCoverWarnings is 3 more than the number of warnings left.
	// this lets it stay away for a while unless we die 3 times in a row without taking cover successfully.
	takeCoverWarnings = GetLocalProfileInt( "takeCoverWarnings" );
	if ( takeCoverWarnings <= 3 )
	{
		return false;
	}
	
	if (isdefined(level.cover_warning_hud))
	{
		return false;
	}

	return true;
}


// TFLAME - 2/24/11 - Also only used in zombies for the old COD 2 legacy hurt hud.  Campaign uses the blood splat.  At some point we should consolidate the design.
function fadeFunc( overlay, coverWarning, severity, mult, hud_scaleOnly )
{
	const pulseTime = 0.8;
	
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
	if ( mayChangeCoverWarningAlpha( coverWarning ) )
	{
		if ( !hud_scaleOnly )
		{
			coverWarning fadeOverTime( fadeInTime );
			coverWarning.alpha = mult * 1.0;
		}
	}
	if ( isdefined( coverWarning ) )
	{
		coverWarning thread fontScaler( 1.0, fadeInTime );
	}
	wait fadeInTime + stayFullTime;
	
	overlay fadeOverTime( fadeOutHalfTime );
	overlay.alpha = mult * halfAlpha;
	if ( mayChangeCoverWarningAlpha( coverWarning ) )
	{
		if ( !hud_scaleOnly )
		{
			coverWarning fadeOverTime( fadeOutHalfTime );
			coverWarning.alpha = mult * halfAlpha;
		}
	}
	
	wait fadeOutHalfTime;
	
	overlay fadeOverTime( fadeOutFullTime );
	overlay.alpha = mult * leastAlpha;
	if ( mayChangeCoverWarningAlpha( coverWarning ) )
	{
		if ( !hud_scaleOnly )
		{
			coverWarning fadeOverTime( fadeOutFullTime );
			coverWarning.alpha = mult * leastAlpha;
		}
	}
	if ( isdefined( coverWarning ) )
	{
		coverWarning thread fontScaler( 0.9, fadeOutFullTime );
	}
	wait fadeOutFullTime;

	wait remainingTime;
}

// TFLAME - 2/24/11 - Fades out the overlay on death, not sure if that is already covered by mission failing, also fades out if a nohealthoverlay notify is sent.  Althoguh it would only fade back in as soon as it would anyway from the other threads
function healthOverlay_remove( overlay ) //self = player
{
	// this hud element will get cleaned up automatically by the code when the player disconnects
	// so we just need to make sure this thread ends
	self endon ("disconnect");

	self util::waittill_any ( "noHealthOverlay", "death" );

	// CODER_MOD
	// Austin (4/19/08): fade out the overlay for the 4/21 milestone

	//overlay destroy();
	
	overlay fadeOverTime( 3.5 );
	overlay.alpha = 0;
	
}

// TFLAME - 2/24/11 - Get the cover warnings working again, will see if any bugs pop up since the system wasn't running at all since midway through black ops
function setTakeCoverWarnings()
{
	 // generates "Get to Cover" x number of times when you first get hurt
	// dvar defaults to - 1
	
	// TFLAME - 2/22/11 - MW 1 specific ... needs to be updated.
	isPreGameplayLevel = ( level.script == "training" || level.script == "cargoship" || level.script == "coup" );
	
	if ( GetLocalProfileInt( "takeCoverWarnings" ) == -1 || isPreGameplayLevel )
	{
		// takeCoverWarnings is 3 more than the number of warnings we want to occur.
		SetLocalProfileVar( "takeCoverWarnings", 3 + 6 );
	}
	 /#DebugTakeCoverWarnings();#/
}

// TFLAME - 2/24/11 - Get the cover warnings working again, will see if any bugs pop up since the system wasn't running at all since midway through black ops
function increment_take_cover_warnings_on_death()
{
	// MikeD (7/30/2007): This function is intended only for players.
	if( !IsPlayer( self ) )
	{
		return;
	}

	level notify( "new_cover_on_death_thread" );
	level endon( "new_cover_on_death_thread" );
	self waittill( "death" );
	
	// dont increment if player died to grenades, explosion, etc
	if( !(self flag::get( "player_has_red_flashing_overlay" ) ) )
	{
		return;
	}
		
	if ( level.gameSkill > 1 )
	{
		return;
	}
	
	warnings = GetLocalProfileInt( "takeCoverWarnings" );
	if ( warnings < 10 )
	{
		SetLocalProfileVar( "takeCoverWarnings", warnings + 1 );
	}
	 /#DebugTakeCoverWarnings();#/
}


//GSTELMACK 7/28/2014 - this func is empty, do we need it?
function empty_kill_func( type, loc, point, attacker, amount )
{
	
}


// CODER_MOD - Sumeet - On COD:BO we are supporting skill change in game
// ALEXP Note - this actually only works if the gameskill value is lowered. If it's increased,
// like it is in challenge_bloodbath, this function will restore the lower value.
function update_skill_on_change()
{
	level endon("stop_update_skill_on_change");

	waittillframeend; // for everything to be defined

	for(;;)
	{
		level waittill("difficulty_change");
		
		level notify( "new_difficulty_request" );
		level thread difficulty_pump_thread();
	}
}

function difficulty_pump_thread()
{
	level endon( "new_difficulty_request" );
	
	for( i = 0; i < 3; i++ )
	{
		lowest_current_skill = GetDvarint( "saved_gameskill" );
		gameskill 			 = GetLocalProfileInt( "g_gameskill" );
		if( !isDefined( gameskill ) )
		{
			gameskill = 0;
		}
		
		if ( gameskill < lowest_current_skill )
			lowest_current_skill = gameskill;
			
		setSkill( true, lowest_current_skill );
		
		util::wait_network_frame();
	}
}

// updated the levelvar to lower or increase enemy accuracy
function coop_enemy_accuracy_scalar_watcher()
{
	level flagsys::wait_till( "load_main_complete" );
	level flag::wait_till("all_players_connected");
		
	while (GetPlayers().size > 1) 
	{
		players = GetPlayers("allies");
		
		level.coop_enemy_accuracy_scalar = get_coop_enemy_accuracy_modifier();
		
		wait (0.5);
	}

}

function coop_friendly_accuracy_scalar_watcher()
{
	level flagsys::wait_till( "load_main_complete" );
	level flag::wait_till("all_players_connected");
	
	while (GetPlayers().size > 1) 
	{
		// CODER_MOD : DSL - only use friendly players.
		
		players = GetPlayers("allies");
		
		level.coop_friendly_accuracy_scalar = get_coop_friendly_accuracy_modifier();
		
		wait (0.5);
	}
}


// this gets called everytime an axis spawns in
function coop_axis_accuracy_scaler()
{
	self endon ("death");
	
	// use the GDT value as the starting point
	initialValue = self.baseAccuracy;

	self.baseAccuracy = initialValue * get_coop_enemy_accuracy_modifier();
	
	//level waittill ("player_disconnected");
	wait randomfloatrange(3,5);


}


// this gets called everytime an axis spawns in
function coop_allies_accuracy_scaler()
{
	self endon ("death");
		
	// use the GDT value as the starting point
	initialValue = self.baseAccuracy;

	while (GetPlayers().size > 1)
	{
		if( !isdefined( level.coop_friendly_accuracy_scalar ) )
		{
			wait 0.5;
			continue;
		}

		self.baseAccuracy = initialValue * level.coop_friendly_accuracy_scalar;
				
		//level waittill ("player_disconnected");
		wait randomfloatrange(3,5);
	}
}

// to make the enemies shoot at players more often
function coop_player_threat_bias_adjuster()
{
	while (1)
	{
		// we don't need to do this all the time, only if players drop out
		wait 5;
		
		if ( level.auto_adjust_threatbias )
		{
			players = GetPlayers("allies");
				
			// the usual threat bias times some scalar
			for( i = 0; i < players.size; i++ )
			{
				// adjust according to the setup system
				enable_auto_adjust_threatbias(players[i]);
			}
		}
	}
}

function enable_auto_adjust_threatbias(player)
{
	level.auto_adjust_threatbias = true;
	
	// get the scalar value for threat bias
	players = GetPlayers();
	level.coop_player_threatbias_scalar = get_coop_friendly_threat_bias_scalar();

	if (!isdefined(level.coop_player_threatbias_scalar))
	{
		level.coop_player_threatbias_scalar = 1;
	}

	player.threatbias = int( get_player_threat_bias() * level.coop_player_threatbias_scalar);
}

// The following functions grab variable values from the gdt scriptbundles for difficulty

function setDiffStructArrays()  //called each time a variable is grabbed for live updates while debugging, for performance, should probably be done once at start for shipping game
{
	level.s_game_difficulty = [];
	level.s_game_difficulty[ 0 ] = struct::get_script_bundle( "gamedifficulty", "gamedifficulty_easy" );
	level.s_game_difficulty[ 1 ] = struct::get_script_bundle( "gamedifficulty", "gamedifficulty_medium" );
	level.s_game_difficulty[ 2 ] = struct::get_script_bundle( "gamedifficulty", "gamedifficulty_hard" );
	level.s_game_difficulty[ 3 ] = struct::get_script_bundle( "gamedifficulty", "gamedifficulty_veteran" );
	level.s_game_difficulty[ 4 ] = struct::get_script_bundle( "gamedifficulty", "gamedifficulty_realistic" );
	
}

function get_player_threat_bias()
{
	gameskill::setdiffstructarrays();
	
	gameSkill_setting = GetLocalProfileInt( "g_gameskill" );
	if( !isDefined( level.gameskill ) )
	{
		gameSkill_setting = 0;
	}
	
	diff_struct_value = level.s_game_difficulty[ gameSkill_setting ].threatbias;
	
	if( isDefined( diff_struct_value ))
	{
		return diff_struct_value;
	}
	else
	{
 		return 0;	
	}
}


// Returns the difficulty scalar applied to the player's XP
function get_player_xp_difficulty_multiplier()
{
	gameskill::setdiffstructarrays();
	
	gameSkill_setting = GetLocalProfileInt( "g_gameskill" );
	if( !isDefined( level.gameskill ) )
	{
		gameSkill_setting = 0;
	}
	
	diff_xp_mult = level.s_game_difficulty[ gameSkill_setting ].difficulty_xp_multiplier;
	
	if( isDefined( diff_xp_mult ))
	{
		return diff_xp_mult;
	}
	else
	{
		// If no difficulty multiplier retrieved, assume no scalar.
 		return 1;	
	}
}


function get_health_overlay_cutoff()
{
	gameskill::setdiffstructarrays();
	
	gameSkill_setting = GetLocalProfileInt( "g_gameskill" );
	if( !isDefined( level.gameskill ) )
	{
		gameSkill_setting = 0;
	}
	
	diff_struct_value = level.s_game_difficulty[ gameSkill_setting ].healthOverlayCutoff;
	
	if( isDefined( diff_struct_value ))
	{
		return diff_struct_value;
	}
	else
	{
 		return 0;	
	}
}


function get_enemy_pain_chance()
{
	gameskill::setdiffstructarrays();
	gameSkill_setting = GetLocalProfileInt( "g_gameskill" );
	if( !isDefined( level.gameskill ) )
	{
		gameSkill_setting = 0;
	}
	
	diff_struct_value = level.s_game_difficulty[ gameSkill_setting ].enemyPainChance;
	
	modifier = get_coop_enemy_pain_chance_modifier();
	
	if( isDefined( diff_struct_value ))
	{
		diff_struct_value = modifier * diff_struct_value;
		return diff_struct_value;
	}
	
	if( isDefined( diff_struct_value ))
	{
		return diff_struct_value;
	}
	else
	{
 		return 0;	
	}
}


function get_player_death_invulnerable_time()
{
	gameskill::setdiffstructarrays();
	gameSkill_setting = GetLocalProfileInt( "g_gameskill" );
	if( !isDefined( level.gameskill ) )
	{
		gameSkill_setting = 0;
	}
	
	diff_struct_value = level.s_game_difficulty[ gameSkill_setting ].player_deathInvulnerableTime;
	
	if( isDefined( diff_struct_value ))
	{
		return diff_struct_value;
	}
	else
	{
 		return 0;	
	}
}


function get_base_enemy_accuracy()
{
	gameskill::setdiffstructarrays();
	gameSkill_setting = GetLocalProfileInt( "g_gameskill" );
	if( !isDefined( level.gameskill ) )
	{
		gameSkill_setting = 0;
	}
	
	diff_struct_value = level.s_game_difficulty[ gameSkill_setting ].base_enemy_accuracy;
	
	if( isDefined( diff_struct_value ))
	{
		return diff_struct_value;
	}
	else
	{
 		return 0;	
	}
}


function get_player_difficulty_health()
{
	gameskill::setdiffstructarrays();
	gameSkill_setting = GetLocalProfileInt( "g_gameskill" );
	if( !isDefined( level.gameskill ) )
	{
		gameSkill_setting = 0;
	}
	
	diff_struct_value = level.s_game_difficulty[ gameSkill_setting ].playerDifficultyHealth;
	
	if( isDefined( diff_struct_value ))
	{
		return diff_struct_value;
	}
	else
	{
 		return 0;	
	}
}

function get_player_hit_invuln_time()
{
	gameskill::setdiffstructarrays();
	gameSkill_setting = GetLocalProfileInt( "g_gameskill" );
	if( !isDefined( level.gameskill ) )
	{
		gameSkill_setting = 0;
	}
	
	diff_struct_value = level.s_game_difficulty[ gameSkill_setting ].playerHitInvulnTime;
	
	modifier = get_coop_hit_invulnerability_modifier();
	
	if( isDefined( diff_struct_value ))
	{
		diff_struct_value = modifier * diff_struct_value;
		return diff_struct_value;
	}
	else
	{
 		return 0;	
	}
}

function get_miss_time_constant()
{
	gameskill::setdiffstructarrays();
	gameSkill_setting = GetLocalProfileInt( "g_gameskill" );
	if( !isDefined( level.gameskill ) )
	{
		gameSkill_setting = 0;
	}
	
	diff_struct_value = level.s_game_difficulty[ gameSkill_setting ].missTimeConstant;
	
	if( isDefined( diff_struct_value ))
	{
		return diff_struct_value;
	}
	else
	{
 		return 0;	
	}
}

function get_miss_time_reset_delay()
{
	gameskill::setdiffstructarrays();
	gameSkill_setting = GetLocalProfileInt( "g_gameskill" );
	if( !isDefined( level.gameskill ) )
	{
		gameSkill_setting = 0;
	}
	
	diff_struct_value = level.s_game_difficulty[ gameSkill_setting ].missTimeResetDelay;
	
	if( isDefined( diff_struct_value ))
	{
		return diff_struct_value;
	}
	else
	{
 		return 0;	
	}
}

function get_miss_time_distance_factor()
{
	gameskill::setdiffstructarrays();
	gameSkill_setting = GetLocalProfileInt( "g_gameskill" );
	if( !isDefined( level.gameskill ) )
	{
		gameSkill_setting = 0;
	}
	
	diff_struct_value = level.s_game_difficulty[ gameSkill_setting ].missTimeDistanceFactor;
	
	if( isDefined( diff_struct_value ))
	{
		return diff_struct_value;
	}
	else
	{
 		return 0;	
	}
}

function get_dog_health()
{
	gameskill::setdiffstructarrays();
	gameSkill_setting = GetLocalProfileInt( "g_gameskill" );
	if( !isDefined( level.gameskill ) )
	{
		gameSkill_setting = 0;
	}
	
	diff_struct_value = level.s_game_difficulty[ gameSkill_setting ].dog_health;
	
	if( isDefined( diff_struct_value ))
	{
		return diff_struct_value;
	}
	else
	{
 		return 0;	
	}
}

function get_dog_press_time()
{
	gameskill::setdiffstructarrays();
	gameSkill_setting = GetLocalProfileInt( "g_gameskill" );
	if( !isDefined( level.gameskill ) )
	{
		gameSkill_setting = 0;
	}
	
	diff_struct_value = level.s_game_difficulty[ gameSkill_setting ].dog_presstime;
	
	if( isDefined( diff_struct_value ))
	{
		return diff_struct_value;
	}
	else
	{
 		return 0;	
	}
}

function get_dog_hits_before_kill()
{
	gameskill::setdiffstructarrays();
	gameSkill_setting = GetLocalProfileInt( "g_gameskill" );
	if( !isDefined( level.gameskill ) )
	{
		gameSkill_setting = 0;
	}
	
	diff_struct_value = level.s_game_difficulty[ gameSkill_setting ].dog_hits_before_kill;
	
	if( isDefined( diff_struct_value ))
	{
		return diff_struct_value;
	}
	else
	{
 		return 0;	
	}
}


function get_long_regen_time()
{
	gameskill::setdiffstructarrays();
	gameSkill_setting = GetLocalProfileInt( "g_gameskill" );
	if( !isDefined( level.gameskill ) )
	{
		gameSkill_setting = 0;
	}
	
	diff_struct_value = level.s_game_difficulty[ gameSkill_setting ].longRegenTime;
	
	if( isDefined( diff_struct_value ))
	{
		return diff_struct_value;
	}
	else
	{
 		return 0;	
	}
}

function get_player_health_regular_regen_delay()
{
	gameskill::setdiffstructarrays();
	gameSkill_setting = GetLocalProfileInt( "g_gameskill" );
	if( !isDefined( level.gameskill ) )
	{
		gameSkill_setting = 0;
	}
	
	diff_struct_value = level.s_game_difficulty[ gameSkill_setting ].playerHealth_RegularRegenDelay;
	
	if( isDefined( diff_struct_value ))
	{
		return diff_struct_value;
	}
	else
	{
 		return 0;	
	}
}

function get_worthy_damage_ratio()
{
	gameskill::setdiffstructarrays();
	gameSkill_setting = GetLocalProfileInt( "g_gameskill" );
	if( !isDefined( level.gameskill ) )
	{
		gameSkill_setting = 0;
	}
	
	diff_struct_value = level.s_game_difficulty[ gameSkill_setting ].worthyDamageRatio;
	
	if( isDefined( diff_struct_value ))
	{
		return diff_struct_value;
	}
	else
	{
 		return 0;	
	}
}

function get_coop_enemy_accuracy_modifier()
{
	gameskill::setdiffstructarrays();
	
	gameSkill_setting = GetLocalProfileInt( "g_gameskill" );
	if( !isDefined( level.gameskill ) )
	{
		gameSkill_setting = 0;
	}
	
	
	switch( GetPlayers().size )
	{
		case 1:
			diff_struct_value = level.s_game_difficulty[ gameSkill_setting ].one_player_coopEnemyAccuracyScalar;
			
			if( isDefined( diff_struct_value ))
			{
				return diff_struct_value;
			}
			else
			{
		 		return 0;	
			}
			break;
		
		case 2:
			diff_struct_value = level.s_game_difficulty[ gameSkill_setting ].two_player_coopEnemyAccuracyScalar;
			
			if( isDefined( diff_struct_value ))
			{
				return diff_struct_value;
			}
			else
			{
		 		return 0;	
			}
			break;
		
		case 3:
			diff_struct_value = level.s_game_difficulty[ gameSkill_setting ].three_player_coopEnemyAccuracyScalar;
			
			if( isDefined( diff_struct_value ))
			{
				return diff_struct_value;
			}
			else
			{
		 		return 0;	
			}
			break;	

		case 4:
			diff_struct_value = level.s_game_difficulty[ gameSkill_setting ].four_player_coopEnemyAccuracyScalar;
			
			if( isDefined( diff_struct_value ))
			{
				return diff_struct_value;
			}
			else
			{
		 		return 0;	
			}
			break;
	}
	return 1;
}

function get_coop_friendly_accuracy_modifier()
{
	gameskill::setdiffstructarrays();
	
	gameSkill_setting = GetLocalProfileInt( "g_gameskill" );
	if( !isDefined( level.gameskill ) )
	{
		gameSkill_setting = 0;
	}
	
	
	switch( getPlayers().size )
	{
		case 1:
			diff_struct_value = level.s_game_difficulty[ gameSkill_setting ].one_player_coopFriendlyAccuracyScalar;
			
			if( isDefined( diff_struct_value ))
			{
				return diff_struct_value;
			}
			else
			{
		 		return 0;	
			}
			break;
		
		case 2:
			diff_struct_value = level.s_game_difficulty[ gameSkill_setting ].two_player_coopFriendlyAccuracyScalar;
			
			if( isDefined( diff_struct_value ))
			{
				return diff_struct_value;
			}
			else
			{
		 		return 0;	
			}
			break;
		
		case 3:
			diff_struct_value = level.s_game_difficulty[ gameSkill_setting ].three_player_coopFriendlyAccuracyScalar;
			
			if( isDefined( diff_struct_value ))
			{
				return diff_struct_value;
			}
			else
			{
		 		return 0;	
			}
			break;	

		case 4:
			diff_struct_value = level.s_game_difficulty[ gameSkill_setting ].four_player_coopFriendlyAccuracyScalar;
			
			if( isDefined( diff_struct_value ))
			{
				return diff_struct_value;
			}
			else
			{
		 		return 0;	
			}
			break;
			
		default: return 1;
	}
	
}

function get_coop_friendly_threat_bias_scalar()
{
	gameskill::setdiffstructarrays();

	gameSkill_setting = GetLocalProfileInt( "g_gameskill" );
	if( !isDefined( level.gameskill ) )
	{
		gameSkill_setting = 0;
	}
		
	switch( getPlayers().size )
	{
		case 1:
			diff_struct_value = level.s_game_difficulty[ gameSkill_setting ].one_player_coopFriendlyThreatBiasScalar;
			
			if( isDefined( diff_struct_value ))
			{
				return diff_struct_value;
			}
			else
			{
		 		return 0;	
			}
			break;
		
		case 2:
			diff_struct_value = level.s_game_difficulty[ gameSkill_setting ].two_player_coopFriendlyThreatBiasScalar;
			
			if( isDefined( diff_struct_value ))
			{
				return diff_struct_value;
			}
			else
			{
		 		return 0;	
			}
			break;
		
		case 3:
			diff_struct_value = level.s_game_difficulty[ gameSkill_setting ].three_player_coopFriendlyThreatBiasScalar;
			
			if( isDefined( diff_struct_value ))
			{
				return diff_struct_value;
			}
			else
			{
		 		return 0;	
			}
			break;	

		case 4:
			diff_struct_value = level.s_game_difficulty[ gameSkill_setting ].four_player_coopFriendlyThreatBiasScalar;
			
			if( isDefined( diff_struct_value ))
			{
				return diff_struct_value;
			}
			else
			{
		 		return 0;	
			}
			break;
			
		default: return 1;
	}
	
}

function get_coop_player_health_modifier()
{
	gameskill::setdiffstructarrays();

	gameSkill_setting = GetLocalProfileInt( "g_gameskill" );
	if( !isDefined( level.gameskill ) )
	{
		gameSkill_setting = 0;
	}
		
	switch( getPlayers().size )
	{
		case 1:
			diff_struct_value = level.s_game_difficulty[ gameSkill_setting ].one_player_coopPlayerDifficultyHealth;
			
			if( isDefined( diff_struct_value ))
			{
				return diff_struct_value;
			}
			else
			{
		 		return 0;	
			}
			break;
		
		case 2:
			diff_struct_value = level.s_game_difficulty[ gameSkill_setting ].two_player_coopPlayerDifficultyHealth;
			
			if( isDefined( diff_struct_value ))
			{
				return diff_struct_value;
			}
			else
			{
		 		return 0;	
			}
			break;
		
		case 3:
			diff_struct_value = level.s_game_difficulty[ gameSkill_setting ].three_player_coopPlayerDifficultyHealth;
			
			if( isDefined( diff_struct_value ))
			{
				return diff_struct_value;
			}
			else
			{
		 		return 0;	
			}
			break;	

		case 4:
			diff_struct_value = level.s_game_difficulty[ gameSkill_setting ].four_player_coopPlayerDifficultyHealth;
			
			if( isDefined( diff_struct_value ))
			{
				return diff_struct_value;
			}
			else
			{
		 		return 0;	
			}
			break;

		default: return 1;
	}
	
}

function get_coop_player_death_invulnerable_time_modifier()
{
	gameskill::setdiffstructarrays();

	gameSkill_setting = GetLocalProfileInt( "g_gameskill" );
	if( !isDefined( level.gameskill ) )
	{
		gameSkill_setting = 0;
	}
		
	switch( getPlayers().size )
	{
		case 1:
			diff_struct_value = level.s_game_difficulty[ gameSkill_setting ].one_player_deathInvulnerableTimeModifier;
			
			if( isDefined( diff_struct_value ))
			{
				return diff_struct_value;
			}
			else
			{
		 		return 0;	
			}
			break;
		
		case 2:
			diff_struct_value = level.s_game_difficulty[ gameSkill_setting ].two_player_deathInvulnerableTimeModifier;
			
			if( isDefined( diff_struct_value ))
			{
				return diff_struct_value;
			}
			else
			{
		 		return 0;	
			}
			break;
		
		case 3:
			diff_struct_value = level.s_game_difficulty[ gameSkill_setting ].three_player_deathInvulnerableTimeModifier;
			
			if( isDefined( diff_struct_value ))
			{
				return diff_struct_value;
			}
			else
			{
		 		return 0;	
			}
			break;	

		case 4:
			diff_struct_value = level.s_game_difficulty[ gameSkill_setting ].four_player_deathInvulnerableTimeModifier;
			
			if( isDefined( diff_struct_value ))
			{
				return diff_struct_value;
			}
			else
			{
		 		return 0;	
			}
			break;

		default: return 1;			
	}
}

	
function get_coop_hit_invulnerability_modifier()
{
	gameskill::setdiffstructarrays();
	
	gameSkill_setting = GetLocalProfileInt( "g_gameskill" );
	if( !isDefined( level.gameskill ) )
	{
		gameSkill_setting = 0;
	}
	
	
	switch( GetPlayers().size )
	{
		case 1:
			diff_struct_value = level.s_game_difficulty[ gameSkill_setting ].one_player_hit_invulnerability_modifier;
			
			if( isDefined( diff_struct_value ))
			{
				return diff_struct_value;
			}
			else
			{
		 		return 0;	
			}
			break;
		
		case 2:
			diff_struct_value = level.s_game_difficulty[ gameSkill_setting ].two_player_hit_invulnerability_modifier;
			
			if( isDefined( diff_struct_value ))
			{
				return diff_struct_value;
			}
			else
			{
		 		return 0;	
			}
			break;
		
		case 3:
			diff_struct_value = level.s_game_difficulty[ gameSkill_setting ].three_player_hit_invulnerability_modifier;
			
			if( isDefined( diff_struct_value ))
			{
				return diff_struct_value;
			}
			else
			{
		 		return 0;	
			}
			break;	

		case 4:
			diff_struct_value = level.s_game_difficulty[ gameSkill_setting ].four_player_hit_invulnerability_modifier;
			
			if( isDefined( diff_struct_value ))
			{
				return diff_struct_value;
			}
			else
			{
		 		return 0;	
			}
			break;
	}
	return 1;
}


function get_coop_enemy_pain_chance_modifier()
{
	gameskill::setdiffstructarrays();
	
	gameSkill_setting = GetLocalProfileInt( "g_gameskill" );
	if( !isDefined( level.gameskill ) )
	{
		gameSkill_setting = 0;
	}
	
	
	switch( GetPlayers().size )
	{
		case 1:
			diff_struct_value = level.s_game_difficulty[ gameSkill_setting ].one_player_enemy_pain_chance_modifier;
			
			if( isDefined( diff_struct_value ))
			{
				return diff_struct_value;
			}
			else
			{
		 		return 0;	
			}
			break;
		
		case 2:
			diff_struct_value = level.s_game_difficulty[ gameSkill_setting ].two_player_enemy_pain_chance_modifier;
			
			if( isDefined( diff_struct_value ))
			{
				return diff_struct_value;
			}
			else
			{
		 		return 0;	
			}
			break;
		
		case 3:
			diff_struct_value = level.s_game_difficulty[ gameSkill_setting ].three_player_enemy_pain_chance_modifier;
			
			if( isDefined( diff_struct_value ))
			{
				return diff_struct_value;
			}
			else
			{
		 		return 0;	
			}
			break;	

		case 4:
			diff_struct_value = level.s_game_difficulty[ gameSkill_setting ].four_player_enemy_pain_chance_modifier;
			
			if( isDefined( diff_struct_value ))
			{
				return diff_struct_value;
			}
			else
			{
		 		return 0;	
			}
			break;
	}
	return 1;
}


function get_general_difficulty_level()
{
	// "0-5" + "1-4" = 0 - 9 scale
	value = GetLocalProfileInt( "g_gameskill" ) + GetPlayers().size -1;
	
	if( value < 0 )
		value = 0;
	
	return value;
}

function player_eligible_for_death_invulnerability()
{
	player = self;
	
	if( GetLocalProfileInt( "g_gameskill" ) >= 4 )  //death invulnerability is disabled for Realistic
	{
		return false;
	}
	
	if( !isDefined( self.eligible_for_death_invulnerability ))
	{
		self.eligible_for_death_invulnerability = true;
	}
	
	return self.eligible_for_death_invulnerability;
	
}

function monitor_player_death_invulnerability_eligibility()
{
	self endon( "disconnect" );
	self endon( "death" );
	
	while( !self.eligible_for_death_invulnerability )
	{
		if( self.health >= self.maxhealth )
		{
			self.eligible_for_death_invulnerability = true ;
		}
		
		wait 0.05;
	}
	
}

function adjust_damage_for_player_health( player, eAttacker, eInflictor, iDamage, weapon, sHitLoc, sMeansOfDamage )
{	
	coop_healthscalar = get_coop_player_health_modifier();
	player_difficulty_health = get_player_difficulty_health() * coop_healthscalar;
	player_damage_difficulty_modifier = 100 / player_difficulty_health;
	
	iDamage = iDamage * player_damage_difficulty_modifier;
	
	return iDamage;
}


function adjust_melee_damage( player, eAttacker, eInflictor, iDamage, weapon, sHitLoc, sMeansOfDamage )
{
	if ( ( sMeansOfDamage == "MOD_MELEE" || sMeansOfDamage == "MOD_MELEE_WEAPON_BUTT" ) && IsEntity( eAttacker ) )
	{
		iDamage = iDamage/5; //adjust melee damage vs. player because melee against enemies was increased greatly
		
		if ( iDamage > 40 )
		{
			playerForward = AnglesToForward( player.angles );
			toAttacker = VectorNormalize( eAttacker.origin - player.origin );
		
			// cos(70) = 0.342
			// Dampen all melee damage that comes from behind the player.
			if ( VectorDot( playerForward, toAttacker ) < 0.342 )
			{
				iDamage = 40;
			}
		}
	}
	
	return iDamage;
}

function accuracy_buildup_over_time_init()
{
	self endon( "death" );
	
	self.baseaccuracy = self.accuracy;//store out the gdt accuracy value as the baseline that we can return to
}

function accuracy_buildup_before_fire( ai )
{
	self endon( "death" );
	
	if ( GetDvarInt( "ai_codeGameskill" ) )
	{
		return;
	}
	
	while ( true )
	{
		if( isDefined( ai.enemy ) )
		{
			if( isPlayer( ai.enemy ))//only modify the enemy accuracy if they are targeting a player
			{
				if( !isDefined( ai.lastEnemyShotAt ) )
				{
					ai.lastEnemyShotAt = ai.enemy;
					ai.buildupAccuracyModifier = 0;//if lastEnemyShotAt is undefined, this should be the first time the AI is shooting at this enemy
					ai.shootTimeStart = GetTime();
					ai.lastShotTime = ai.shootTimeStart;
				}
				
				if( ai.enemy != ai.lastEnemyShotAt )// if it's the first shot at a target, set the accuracy to 0
				{
					ai.lastEnemyShotAt = ai.enemy;
					ai.buildupAccuracyModifier = 0;
					ai.shootTimeStart = GetTime();
					ai.lastShotTime = ai.shootTimeStart;
				}
				else
				{
					//Gather factors from gamedifficulty GDT's
					ai.miss_time_constant = get_miss_time_constant();
					ai.miss_time_distance_factor = get_miss_time_distance_factor();
					ai.miss_time_reset_delay = get_miss_time_reset_delay();
					if( ai.accurateFire )
					{
						ai.miss_time_reset_delay *=2;  //double miss time reset for accurate fire AI due to lower fire rate
					}
					shotTime = GetTime();
					timeShooting = shotTime - ai.shootTimeStart;
					
					//Get Distance from shooter to target and calculate accuracy build up time
					distance = Distance( ai.origin, ai.enemy.origin );
					missTime = ai.miss_time_constant * 1000; //converts miss time to ms for later calculations
					accuracyBuildupTime = missTime + ( distance * ai.miss_time_distance_factor );
					
					//Modify build up time if shooter is behind or to the side of the target
					targetFacingAngle = AnglesToForward( ai.enemy.angles );
					angleFromTarget = VectorNormalize( ai.origin - ai.enemy.origin );
					
					if( VectorDot( targetFacingAngle, angleFromTarget ) < 0.7)
					{
						accuracyBuildupTime *= 2;	
					}
					
					//If time between this shot and the last one is greater than Miss Time Reset Delay, set accuracy back to 0, and set shootTimeStart and last shot time to current time
					if( shotTime - ai.lastShotTime > ai.miss_time_reset_delay )
					{
						ai.buildupAccuracyModifier = 0;
						ai.shootTimeStart = shotTime;
						timeShooting = 0;
					}
					
					//If the difference between GetTime and shootTimeStart is greater than buildup time, set buildupAccuracyModifier to 1
					if( timeShooting > accuracyBuildupTime )
					{
						ai.buildupAccuracyModifier = 1;	
					}
					
					//If the time spent shooting is less than the accuracy build up time, modify the accuracy according to how much time was spent shooting
					//This was broken into steps as a linear build up wasn't very noticeable
					if( timeShooting <= accuracyBuildupTime && timeShooting > accuracyBuildupTime * 0.66)
					{
						ai.buildupAccuracyModifier = 0.66;
					}
					
					if( timeShooting <= accuracyBuildupTime * 0.66 && timeShooting > accuracyBuildupTime * 0.33)
					{
						ai.buildupAccuracyModifier = 0.33;
					}
					
					if( timeShooting <= accuracyBuildupTime * 0.33 )
					{
						ai.buildupAccuracyModifier = 0;
					}
					
					ai.lastShotTime = shotTime;	//sets the last shot time to the current shot time for next iteration				
				}
			}
			else
			{
				ai.buildupAccuracyModifier = 1;// this resets the AI accuracy if they are not shooting a player
			}
			
			ai.accuracy = ai.baseaccuracy * ai.buildupAccuracyModifier;
		}
		
		self waittill( "about_to_shoot" );
	}
}