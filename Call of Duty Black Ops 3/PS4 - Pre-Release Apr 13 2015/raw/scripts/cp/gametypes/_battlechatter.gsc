#using scripts\codescripts\struct;
#using scripts\shared\callbacks_shared;
#using scripts\shared\killstreaks_shared;
#using scripts\shared\spawner_shared;
#using scripts\shared\system_shared;
#using scripts\shared\util_shared;
#using scripts\shared\array_shared;

    	   	                                                                                                                         	                                                                                                                                                                                                                                                                                                                                                                    	        	     	             	    	   	                           	                               	                                	                                                              	                                                                                                              	                            	                                     	                                       	                                                               	   	                  	       	                                                    	                   	                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                       	                                                                                        	           	                        	                                            	                                             	                                                   	                                                             	                                                         	                                                                    	                                                                                                                                                                                                    	                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                     	                                                              	                                                          	                                   	                                   	                                                    	                                       
            	      	   	    	           	        	        	              	                                                                                                                            	          	         	                        
                                                                                                            	   	

#using scripts\cp\gametypes\_globallogic;

#using scripts\cp\killstreaks\_killstreaks;

#namespace battlechatter;

function autoexec __init__sytem__() {     system::register("battlechatter",&__init__,undefined,undefined);    }
	
function __init__()
{
	callback::on_start_gametype( &init );
	
	aiSpawnerArray = GetActorSpawnerArray();
	util::array_func( aiSpawnerArray, &spawner::add_spawn_function, &on_joined_ai );
}

function init()
{
	callback::on_spawned( &on_player_spawned);
	
	level.battlechatter_init = true;
	
	// Default battlechatter category is enabled "bc"
	level.allowBattleChatter = [];
	level.allowBattleChatter["bc"] = true;
	
	level thread sndVehicleHijackWatcher();
}

function sndVehicleHijackWatcher()
{
	while(1)
	{
		level waittill("ClonedEntity",clone,vehEntNum);
		if( isdefined( clone ) && isdefined( clone.archetype ) )
		{
			vehicleName = clone.archetype;
			
			if( vehicleName == "wasp" )
				alias = "hijack_wasps";
			else if( vehicleName == "raps" )
				alias = "hijack_raps";
			else if( vehicleName == "quadtank" )
				alias = "hijack_quad";
			else
				alias = undefined;
			
			nearbyEnemy = get_closest_ai_to_object( "axis", clone );
			
			if( isdefined( nearbyEnemy ) && isdefined( alias ) )
			{
				level thread bc_MakeLine( nearbyEnemy, alias );
			}
		}
	}
}

function on_joined_ai()
{
	self endon( "disconnect" );
	
	if (( isdefined( level.deadOps ) && level.deadOps ))
	{
		return;
	}
	if( isVehicle(self) )
	{
		return;
	}
	
	if( (isdefined(self.archetype) && ( self.archetype == "zombie" )) )
	{
		return;
	}
	
	if( !isdefined( self.voicePrefix ) )
	{
		self.voicePrefix = "vox_ax";
	}
	
	if( self.voicePrefix == "vox_hend" || 
		self.voicePrefix == "vox_khal" ||
		self.voicePrefix == "vox_kane"	)
	{
		self.bcVoiceNumber = "";
	}
	else
	{
		self.bcVoiceNumber = (randomintrange(0,4));
	}
	
	self.isSpeaking = false;
	self.soundMod = "player";

	self thread bc_AINotifyConvert();
	self thread bc_GrenadeWatcher();
	self thread bc_StickyGrenadeWatcher();	
	
	if( !(isdefined(self.archetype) && ( self.archetype == "robot" )) )
	{
		self thread bc_death();
		self thread bc_scriptedLine();
		
		if( (isdefined(self.voicePrefix) && ( GetSubStr(self.voicePrefix,7) == "f" )) )
		{
			self.bcVoiceNumber = (randomintrange(0,2));
		}
	}
}
function bc_AINotifyConvert()
{
	self endon ( "death" );
	self endon ( "disconnect" );
	level endon ( "game_ended" );

	while (1)
	{
		self waittill("bhtn_action_notify", notify_string);
		
		switch( notify_string )
		{					
			case "pain":
			{
				if( !(isdefined(self.archetype) && ( self.archetype == "robot" )) )
				{
					level thread bc_MakeLine( self, "exert_pain" );
				}
				break;
			}
			case "death":
			{
				break;
			}
			case "scream":
			{
				if( !(isdefined(self.archetype) && ( self.archetype == "robot" )) )
				{
					level thread bc_MakeLine( self, "exert_scream" );
				}
				break;
			}
			case "reload":
			{
				if( (randomintrange(0,100) <= 20) )
				{
					level thread bc_MakeLine( self, "action_reloading", true  );
				}
				break;
			}				
			case "enemycontact":
			{
				self thread bc_enemyContact();	
				break;
			}
			case "cover_shoot":
			{
				if( (randomintrange(0,100) <= 10) )
				{
					level thread bc_MakeLine( self, "enemy_contact", true  );
				}
				break;
			}
			case "cover_stance":
			{
				if( (randomintrange(0,100) <= 45) )
				{
					level thread bc_MakeLine( self, "action_intocover", true  );
				}
				break;
			}
			case "charge":
			{
				level thread bc_MakeLine( self, "exert_charge" );	
				break;
			}
			case "attack_melee":
			{
				level thread bc_MakeLine( self, "exert_melee" );
				break;
			}				
			case "blindfire":
			{
				level thread bc_MakeLine( self, "action_blindfire" );				
				break;				
			}
			case "flanked":
			{				
				level thread bc_MakeLine( self, "action_flanked" );
				break;
			}
			case "peek":
			case "scan":
			{				
				if( (randomintrange(0,100) <= 25) )
				{
					level thread bc_MakeLine( self, "action_peek" );
				}
				break;				
			}
			case "exposed":
			{				
				level thread bc_MakeLine( self, "action_exposed" );
				break;
			}
			case "taking_cover":
			{				
				if( (randomintrange(0,100) <= 75) )
				{
					level thread bc_MakeLine( self, "action_intocover" );
				}
				break;				
			}
			case "moving_up":
			{				
				if( (randomintrange(0,100) <= 6) )
				{
					level thread bc_MakeLine( self, "action_moving" );
				}
				break;
			}
			case "rbCrawler":
			case "rbPhalanx":
			case "rbTakeover":
			case "rbCharge":
			{
				level thread bc_MakeLine( self, "action_exposed" );
				break;
			}
			case "rbJuke":
			{
				if( (randomintrange(0,100) <= 30) )
				{
					level thread bc_MakeLine( self, "action_moving" );
				}
				break;
			}
			case "firefly_swarm":
			{
				if( (randomintrange(0,100) <= 50) )
				{
					level thread bc_MakeLine( self, "firefly_response" );
				}
				
				if( (randomintrange(0,100) <= 50) )
				{
					alliesGuy = get_closest_ai_to_object( "allies", self );
					if( isdefined( alliesGuy ) )
					{
						level util::delay( 1, undefined, &battlechatter::bc_MakeLine, alliesGuy, "firefly_response" );
					}
				}
				break;	
			}
			case "firefly_explode":
			{
				if( (randomintrange(0,100) <= 50) )
				{
					teammate = get_closest_ai_on_sameteam(self);
					if( isdefined( teammate ) )
					{
						level thread bc_MakeLine( teammate, "firefly_explode" );
					}
				}
				break;	
			}
			case "rapidstrike":
			{
				level thread bc_MakeLine( self, "rapidstrike_response" );
				break;	
			}
			case "warlord_juke":
			case "warlord_angry":
			{
				linearray = array("action_peek","action_moving","enemy_contact");
				line = linearray[randomintrange(0,linearray.size)];
				level thread bc_MakeLine( self, line );
				break;	
			}
			default:
			{
				break;
			}
		}
	}
}
function bc_scriptedLine()
{
	self endon ( "death" );
	self endon ( "disconnect" ); 
	level endon ( "game_ended" );
	
	while(1)
	{
		self waittill( "scriptedBC", alias_suffix );
		level thread bc_MakeLine( self, alias_suffix );
	}
}
function bc_enemyContact()
{
	self endon ( "death" );
	self endon ( "disconnect" );

	//Check to make sure the last attempt has been a while
	if( (randomintrange(0,100) <= 35) )
	{
		if(!( isdefined( level.bc_enemyContact ) && level.bc_enemyContact ))
		{
			level thread bc_MakeLine( self, "enemy_contact" );
			level thread bc_enemyContact_Wait();
		}
	}
}
function bc_enemyContact_Wait()
{
	level.bc_enemyContact = true;
	wait(15);
	level.bc_enemyContact = false;
}
function bc_GrenadeWatcher()
{
	self endon ( "death" );
	self endon ( "disconnect" );

	while(1)
	{
		self waittill ( "grenade_fire", grenade, weapon );

		if( weapon.name == "frag_grenade" )
		{
			if( (randomintrange(0,100) <= 80) && !isplayer(self) )
			{
				level thread bc_MakeLine( self, "grenade_toss" );
			}
			
			level thread bc_IncomingGrenadeWatcher( self, grenade );					
		}
	}
}
function bc_IncomingGrenadeWatcher( thrower, grenade )
{
	if( (randomintrange(0,100) <= 95) )
	{
		wait( 1 );
		
		if( !isdefined( thrower ) || !isdefined( grenade ) )
		{
			return;
		}

		team = "axis";
		if(isdefined(thrower.team) && team == thrower.team )
		{
			team = "allies";
		}
		
		ai = get_closest_ai_to_object(team, grenade);

		if( isdefined( ai ) )
		{
			level thread bc_MakeLine( ai, "grenade_incoming", true );
		}
	}
}
function bc_StickyGrenadeWatcher()
{
	self endon ( "death" );
	self endon ( "disconnect" );
	self endon ( "sticky_explode" );

	while(1)
	{
		self waittill ( "grenade_stuck", grenade );

		if ( isdefined( grenade ) )
		{
			grenade.stuckToPlayer = self;
		}

		if ( IsAlive( self ) )
		{
				level thread bc_MakeLine( self, "grenade_sticky" );
		}

		break;
	}
}

function bc_death()
{
	self endon ( "disconnect" );
	
	self waittill ( "death", attacker, meansOfDeath );
		
	if ( isdefined( self ) )
	{	
		meleeAssassinate = isDefined( meansOfDeath ) && meansOfDeath == "MOD_MELEE_ASSASSINATE";

		// Death Yell
		if( !( isdefined( self.quiet_death ) && self.quiet_death ) && !meleeAssassinate && isDefined( attacker ) )
		{
			soundAlias = (self.voicePrefix + self.bcVoiceNumber + "_" + "exert_death" );
			self thread do_sound( soundAlias, true  );
		}
		
		//If the AI getting killed previously sniped someone, have the attacker say Sniper Down line
		if( ( isdefined( self.sndIsSniper ) && self.sndIsSniper ) && isdefined( attacker ) && !isPlayer( attacker ) )
		{
			level thread bc_MakeLine( attacker, "sniper_kill" );
		}
		
		//If the AI was killed by a sniper, have a teammate yell out Sniper, or just yell a generic Man Down line if not a sniper
		sniper = isdefined( attacker ) && isdefined( attacker.scoretype ) && attacker.scoretype == "_sniper";
		if ( !meleeAssassinate && ( sniper || (randomintrange(0,100) <= 35) ) )
		{
			close_ai = get_closest_ai_on_sameteam(self);
			
			if ( isDefined( close_ai ) && !( isdefined( close_ai.quiet_death ) && close_ai.quiet_death ) )
			{
				if ( sniper )
				{
					attacker.sndIsSniper = true;
					level thread bc_MakeLine( close_ai, "sniper_threat" );
				}
				else
				{
					level thread bc_MakeLine( close_ai, "friendly_down" );
				}
			}
		}
	}
}

function bc_AInearExplodable( object,  type )
{
	wait (randomfloatrange (.1, .4));
	
	ai = get_closest_ai_to_object("both", object, 500);
	
	if( isdefined( ai ) )
	{
		if( type == "car" )
			level thread bc_MakeLine( ai, "destructible_car" );
		else
			level thread bc_MakeLine( ai, "destructible_barrel" );
	}
}	

function bc_RobotBehindVox()
{
	level endon("unloaded");
	self endon("death_or_disconnect");
	
	if(!IsDefined(level._bc_robotBehindVoxTime))
	{
		level._bc_robotBehindVoxTime = 0;
		enemies = GetAITeamArray("axis");
		level._bc_robotBehindArray = array();
		foreach( enemy in enemies )
		{
			if( (isdefined(enemy.archetype) && ( enemy.archetype == "robot" )) )
			{
				array::add( level._bc_robotBehindArray, enemy, false );
			}
		}
	}
	
	while(1)
	{
		wait(1);		
		
		t = GetTime();
		
		if(t > level._bc_robotBehindVoxTime + 1000)
		{
			level._bc_robotBehindVoxTime = t;
			enemies = GetAITeamArray("axis");
			array::remove_dead( level._bc_robotBehindArray );
			array::remove_undefined( level._bc_robotBehindArray );
			foreach( enemy in enemies )
			{
				if( (isdefined(enemy.archetype) && ( enemy.archetype == "robot" )) )
				{
					array::add( level._bc_robotBehindArray, enemy, false );
				}
			}
		}
		
		if( level._bc_robotBehindArray.size <= 0 )
		{
			continue;
		}
		
		played_sound = false;
		
		foreach( robot in level._bc_robotBehindArray )
		{
			if( !isdefined( robot ) )
			{
				continue;
			}
			
			if( distancesquared( robot.origin, self.origin ) < 200*200 )
			{
				//If Robot is currently in the middle of an anim
				if( isdefined( robot.current_scene ) )
				{
					continue;
				}
				
				yaw = self GetYawToSpot(robot.origin );
				diff = self.origin[2] - robot.origin[2];
				if( (yaw < -95 || yaw > 95) && abs(diff) < 50 )
				{
					robot playsound( "chr_robot_behind" );
					played_sound = true;
					break;
				}
			}
		}
		
		if(played_sound)
		{
			wait(5);
		}
	}
}
function GetYawToSpot(spot)
{
	pos = spot;
	yaw = self.angles[1] - GetYaw(pos);
	yaw = AngleClamp180( yaw );
	return yaw;
}
function GetYaw(org)
{
	angles = VectorToAngles(org-self.origin);
	return angles[1];
}

//function say_kill_battle_chatter( attacker, weapon, victim )
//{
//	if ( weapon.skipBattlechatterKill )
//	{
//		return;
//	}
//	
//	if 	( isdefined(victim.isSniperSpotted) && (victim.isSniperSpotted) && BC_PROBABILITY_KILLENEMY )
//	{
//		//level thread bc_MakeLine( attacker, "kill", "sniper" );
//		victim.isSniperSpotted = false;
//	}	
//	
//	else if( BC_PROBABILITY_KILLENEMY )
//	{
//		if ( !killstreaks::is_killstreak_weapon( weapon ) )
//		{
//			//level thread bc_MakeLine( attacker, "kill", "infantry" );
//		}
//	}
//}


//*************************BC PLAYVOX FUNCTIONS**********************\\

function bc_MakeLine( ai, line, causeResponse, category, alwaysPlay )
{
	if( !isdefined( ai ) )
		return;
	
	ai endon ( "death" );
	ai endon ( "disconnect" );
	
	response = undefined;
	if( isdefined( causeResponse ) )
	{
		response = line + "_response";
	}
	
	if( !isdefined( ai.voicePrefix ) || !isdefined( ai.bcVoiceNumber ) )
	{
		return;
	}
	
	if( (isdefined(ai.archetype) && ( ai.archetype == "robot" )) )
	{
		soundAlias = (ai.voicePrefix + ai.bcVoiceNumber + "_" + "chatter" );
	}
	else
	{
		soundAlias = (ai.voicePrefix + ai.bcVoiceNumber + "_" + line );
	}
	
	ai thread do_sound( soundAlias, alwaysPlay, response, category );		
}
  
function do_sound( soundAlias, alwaysPlay, response, category )
{
	if (!isdefined (soundAlias))
	{
		return;
	}	
	
	if (!isdefined (alwaysPlay))
	{
		alwaysPlay = false;
	}
		
	if( self bc_allowed( category ) && ( !( isdefined( self.isSpeaking ) && self.isSpeaking ) || alwaysPlay ) )
	{	
		if ( ( isdefined( self.isSpeaking ) && self.isSpeaking ) )
			self notify( "bc_interrupt" );
		
		self PlaySoundOnTag( soundAlias, "J_Head");
		
		self thread wait_playback_time( soundAlias ); 
		
		result = self util::waittill_any_return( soundAlias, "death", "disconnect", "bc_interrupt" );
		
		if ( result == soundAlias )
		{
			if ( isDefined( response ) )
			{
				ai = get_closest_ai_on_sameteam(self);
		
				if( isdefined( ai ) )
					level thread bc_MakeLine( ai, response );
			}
		}
		else if ( isDefined( self ) )
		{
			// Interrupted
			self StopSound( soundAlias );
		}
	}
}

function bc_Allowed( category )
{
	if ( !isdefined( category ) )
		category = "bc";

	if ( isDefined( level.allowBattleChatter ) && !( isdefined( level.allowBattleChatter[category] ) && level.allowBattleChatter[category] ) )
		return false;

	if ( isDefined( self.allowBattleChatter ) && !( isdefined( self.allowBattleChatter[category] ) && self.allowBattleChatter[category] ) )
		return false;
	
	return true;
}


//*************************PLAYER PAIN AUDIO AND GRENADE TRACKING**********************\\


function on_player_spawned()
{
	self endon( "disconnect" );

	self.soundMod = "player";
	self.voxShouldGasp = 0;
	self.voxShouldGaspLoop = 1;	
	self.isSpeaking = false;

	self thread pain_vox();
	self thread bc_GrenadeWatcher();
	self thread bc_robotBehindVox();
	self thread bc_plrNotifyConvert();
	self thread cybercoreMeleeWatcher();
}
function bc_plrNotifyConvert()
{
	self endon ( "death" );
	self endon ( "disconnect" );
	level endon ( "game_ended" );

	while (1)
	{
		self waittill("bhtn_action_notify", notify_string);
		
		switch( notify_string )
		{
			case "firefly_deploy":
				//self thread bc_doPlayerVox(notify_string);
				break;
			case "firefly_end":
				//self thread bc_doPlayerVox(notify_string);
				break;
			default:
				break;
		}
	}
}

function bc_doPlayerVox(suffix)
{
	soundAlias = "vox_plyr_" + suffix;
	if( isdefined( self.bodyType ) && self.bodyType == "female" )
	{
		soundAlias = "vox_plrf_" + suffix;
	}
	
	if( self bc_Allowed() && !( isdefined( self.isTalking ) && self.isTalking ) && !( isdefined( self.isSpeaking ) && self.isSpeaking ) )
	{
		self playsoundtoplayer( soundAlias, self );
		self thread wait_playback_time( soundAlias );
	}
}

function pain_vox()
{
	self endon ( "death" );
	self endon ( "disconnect" );
	
	while(1)
	{
		self waittill ( "snd_pain_player", meansOfDeath );

		if( (randomintrange(0,100) <= 100) )
		{
			if ( IsAlive( self ) )
			{	
				if( meansOfDeath == "MOD_DROWN" )
				{
					soundAlias = "chr_swimming_drown";
					self.voxShouldGasp = 1;
					if (self.voxShouldGaspLoop)
					{
						self thread water_gasp();
					}
				}
				else
				{
					//soundAlias = self.voicePrefix + self.bcVoiceNumber + "_" + level.bcSounds["pain"] + "_" + "small";
				}
				
				soundAlias = "vox_plyr_exert_pain";
				if( isdefined( self.bodyType ) && self.bodyType == "female" )
				{
					soundAlias = "vox_plrf_exert_pain";
				}
				self thread do_sound( soundAlias, true  );
			}
		}
		
		wait(.5);	
	}
}
function water_gasp()
{
	self endon ( "death" );
	self endon ( "disconnect" );
	self endon ( "snd_gasp" );	
	level endon ( "game_ended" );

	self.voxShouldGaspLoop = 0;
			
	while (1)
	{
		if ( !self IsPlayerUnderwater() && self.voxShouldGasp)
		{
			self.voxShouldGasp = 0;
			self.voxShouldGaspLoop = 1;
			self thread do_sound( "vox_pm1_gas_gasp", true  );
			self notify ( "snd_gasp" );
			
		}
		wait (.5);
	}
}

function cybercoreMeleeWatcher()
{
	self endon ( "death" );
	self endon ( "disconnect" );
	level endon ( "game_ended" );
	
	while(1)
	{
		self waittill( "melee_cybercom" );
		self thread sndCybercoreMeleeResponse();
	}
}
function sndCybercoreMeleeResponse()
{
	self endon( "melee_cybercom" );
	wait(2);
	if( isdefined( self ) )
	{
		ai = level get_closest_ai_to_object("axis", self, 700);
		if( isdefined( ai ) )
		{
			ai notify("bhtn_action_notify", "rapidstrike");
		}	
	}
}

//*************************BC UTILITY FUNCTIONS**********************\\


function wait_playback_time( soundAlias, timeout )
{
	self endon ( "death" );
	self endon ( "disconnect" );

	playbackTime = soundgetplaybacktime ( soundAlias );
	
	self.isSpeaking = true;
	
	if ( playbackTime >= 0 )
	{
		waitTime = playbackTime * .001;
		wait ( waitTime );
	}
	else
	{
		wait ( 1.0 );
	}
	self notify ( soundAlias );	
	self.isSpeaking = false;
}

function get_closest_ai_on_sameteam(some_ai,maxdist)
{
	if ( isdefined( some_ai ) )
	{
		AiArray = GetAITeamArray(some_ai.team);
		AiArray = ArraySort( AiArray, some_ai.origin );
		
		if(!isdefined(maxdist))
			maxdist = 1000;
		
		foreach( dude in AiArray )
		{
			if( !isdefined( some_ai ) )
			{
				return undefined;
			}
			if( !isdefined( dude ) || !IsAlive( dude ) || !isdefined( dude.bcVoiceNumber ) )
			{
			   	continue;
			}
			
			if( dude == some_ai )
			{
				continue;
			}
			
			if( isVehicle( dude ) )
			{
				continue;
			}
			
			if( (isdefined(dude.archetype) && ( dude.archetype == "robot" )) )
			{
				continue;
			}
			
			if( !(isdefined(dude.voicePrefix) && ( dude.voicePrefix == "vox_hend" || dude.voicePrefix == "vox_khal" || dude.voicePrefix == "vox_kane" )) && !(isdefined(some_ai.voicePrefix) && ( some_ai.voicePrefix == "vox_hend" || some_ai.voicePrefix == "vox_khal" || some_ai.voicePrefix == "vox_kane" )) )
			{
				if( dude.bcVoiceNumber == some_ai.bcVoiceNumber )
					continue;
			}
			
			if( distance( some_ai.origin, dude.origin ) > maxdist )
			{
				continue;
			}
	
			return dude;
		}
	}
	return undefined;
}
function get_closest_ai_to_object(team, object, maxdist)
{
	if( !isdefined( object ) )
		return;
	
	if( team == "both" )
	{
		AiArray = GetAITeamArray("axis", "allies");
	}
	else
	{
		AiArray = GetAITeamArray(team);
	}
	
	AiArray = ArraySort( AiArray, object.origin );
	
	if(!isdefined(maxdist))
		maxdist = 1000;
	
	foreach( dude in AiArray )
	{
		if( !isdefined( dude ) || !IsAlive( dude ) )
		{
		   	continue;
		}
		
		if( isVehicle( dude ) )
		{
			continue;
		}
		
		if( (isdefined(dude.archetype) && ( dude.archetype == "robot" )) )
		{
			continue;
		}
		
		if( !isdefined( dude.voicePrefix ) || !isdefined( dude.bcVoiceNumber ) )
		{
			continue;
		}
		
		if( distance( dude.origin, object.origin ) > maxdist )
		{
			continue;
		}

		return dude;
	}
	
	return undefined;
}