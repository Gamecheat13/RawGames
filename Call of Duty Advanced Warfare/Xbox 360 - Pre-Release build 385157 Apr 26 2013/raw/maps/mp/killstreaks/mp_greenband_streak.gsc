#include maps\mp\_utility;
#include maps\mp\gametypes\_hud_util;
#include common_scripts\utility;
#include maps\mp\agents\_agent_utility;
#include maps\mp\gametypes\_damage;
#include maps\mp\bots\_bots_util;
#include maps\mp\bots\_bots_strategy;
#include maps\mp\agents\_scriptedAgents;

init()
{	
	precacheLocationSelector( "map_artillery_selector" );
	precacheString( &"KILLSTREAKS_MP_GREENBAND" );
	
//////// Currently don't need an item for this level killstreak because it does not cause damage	
//
//	PreCacheItem( "killstreak_lab2_mp" );
		
	
	level.killStreakFuncs[ "mp_greenband" ] = ::tryUseMpGreenband;
	
	////////// _agent.gsc pointer so this function only gets called if greenband is the loaded map
	/// 
	level.mp_geenband_killstreak_init_pointer = ::setup_callbacks;
	
	
	///// var to track if killstreak is currently active 
	level.GreenBandKillStreakActive = false;
	
	////// Setting up things so we don't have to get them everytime the killstreak is run
	level.TriggerAgentKiller = GetEnt("agent_kill_trigger01","targetname");
	level.ArrayTotalSpawnLocations = GetEntArray("botspawn_roundside01", "targetname");
}



//////////////////////////////////////////////////////////////////////////////////////////////////
///////// Callbacks for _agent file so it loads my sniper agents instead of "player".  currently bypasses a bunch of damage and kill stuff for agents
setup_callbacks()
{
	level.agent_funcs["sniper_streak"] = level.agent_funcs["player"];
	level.agent_funcs["sniper_streak"]["on_damaged"]	= maps\mp\agents\_agents::on_agent_generic_damaged;
	level.agent_funcs["sniper_streak"]["on_killed"]	= ::on_agent_sniper_killed;
}
tryUseMpGreenband( lifeId )
{
	if ( ! self validateUseStreak() )
		return false;

	if ( self isUsingRemote() )
	{
		return false;
	}

	if( IsDefined(self.mp_greenband_killstreak) && self.mp_greenband_killstreak.size > 0 )
	{
		self iPrintLnBold( &"MP_AIR_SPACE_TOO_CROWDED" );
		return false;
	}
	
	////////// Checking to see if killstreak is active
	if(level.GreenBandKillStreakActive == true)
	{
		self iPrintLnBold( &"MP_GREENBAND_IN_USE" );
		return false;
	}
	result = self LevelKillStreak( lifeId );

	if ( !isDefined( result ) || !result )
		return false;
	
	return true;
}
LevelKillStreak( lifeID )
{
	if (level.GreenBandKillStreakActive == false)
	{
		//////// Starts Killstreak
		self thread KillStreakGreenband();
		return true;
	}
}
KillStreakGreenband()
{
	level endon("snipers_dead");
//	IPrintLnBold("KILLSTREAK");
	
//////////// agent spawn loop ////////////////////////
/// 
	AgentArray = [];
	NumAgents = 3;
	duration = 60;
	AgentWeapon = "iw5_spr34_mp_spr34scope"; 
	SetDvar("laserRange",4000);
	SetDvar("laserRangePlayer",4000);
	
	
	////// array of agent spawn locations.  Copying it into a new array so we can pull spawn points out as they are used
	ArraySpawnPoints = level.ArrayTotalSpawnLocations;
	
	for(i = 0; i < NumAgents; i++)
	{
		///// Choosing Spawn point and removing chosen spawn point from the array
		ChosenSpawnPoint = random(ArraySpawnPoints);
		ArraySpawnPoints = array_remove(ArraySpawnPoints, ChosenSpawnPoint);
		
		////  Get an unsused agent out of the agent array pool that is loaded in every level
		agent = getFreeAgent("sniper_streak");	
		
		if( !IsDefined( agent ) )
		{
			continue;
			// If an agent can't be found skip it and try another one.  Maybe I should do something to make sure we always get the intended total NumAgents 	
		}
		else
		{
			// building agent array and and starting the function to actually to set up and spawn each agent into the world.
			// Setting the killstreak as active now because agents are spawning into the world
			AgentArray[AgentArray.size] = agent;
			agent thread SpawnTheAgents(AgentWeapon, ChosenSpawnPoint, self, duration);
			level.GreenBandKillStreakActive = true;
		}
	}
	//// now that the agent array is fully built we are going to track their deaths so we know if the killstreak is over
	thread TrackDeadAgents(AgentArray);
	
	////// tracking players who are currently connected and who connect during the killstreak so I can trigger events on player deaths by agents 
	thread TrackPlayerConnections(AgentArray, self);
}


// Handles actually spawning the agents into the world, giving them a mesh, a weapon, their tuning values,
// and turning off their crazy defualt AI, then tells them to go
SpawnTheAgents(weapon, spawnpoint, killstreak_owner, duration)
{
	self endon("death");
	self SetAgentValues(killstreak_owner);
	
	randomnumber = RandomFloatRange(0.05,0.1);
	wait(randomnumber);
	
	self SpawnAgent(spawnpoint.origin, spawnpoint.angles);
	
	wait(0.05);
	
	self MakeAgentStupid();
	self GiveLaserSightAndWeapon(weapon);
	self maps\mp\agents\_agents::createKillCamEntity();
	self TuneBotDifficultySettings();
	self thread RunToWindow(spawnpoint);
	self thread KillStreakTimer(duration, spawnpoint);
	self thread AgentTriggerCheck();
	self thread AgentReload(weapon);
//	self thread TrackKills();
}


// Checks state of agents ammo and gives them ammo if they are out
AgentReload(weapon)
{
	self endon("death");
	while(true)
	{
		if (self GetAmmoCount(weapon) == 0)
		{
		//	IPrintLnBold("giving bot ammo");
			self GiveMaxAmmo(weapon, 1);
		}
		wait(1);
	}
}

/// tracks players when killstreak is called and tracks newly connected players so we can do stuff to them, or agents when agents kill them
///  NOTE: Not filtering teammates on agents team because they might switch teams, maybe should track switch teams and not run a thread on all players
TrackPlayerConnections(agents, owner)
{
	level endon("snipers_dead");
	foreach(player in level.players)
	{
		player.trackeddeath = true;
		player thread TrackKills(agents, owner);
	}
	while(true)
	{
		level waittill("connected", player);
		{
			//using another thread to check on spawned because I don't want to be stuck in waitting till spawned when others could be connected
			player thread OnPlayerSpawned(agents, owner);
		}
		wait(0.05);
	}
}

// Just wait for new connected players during killstreak to spawn so we can track them
OnPlayerSpawned(agents, owner)
{
	level endon("snipers_dead");
	self endon("disconnect");
	self waittill( "spawned_player" );
	if(!IsDefined(self.trackeddeath))
	{
		self thread TrackKills(agents, owner);
		self.trackeddeath = true;
	}
}

// Tracks kills by agents and plays a sound when they get a kill.  can reward owner of agent or agent when agent gets a kill
TrackKills(agents, owner)
{
	level endon("snipers_dead");
	self endon("disconnect");
	while(true)
	{
		self waittill("death", attacker_ent);
		if(IsDefined(attacker_ent))
		{
		   	if(IsAlive(attacker_ent))
		   	{
		   		foreach(agent in agents)
		   		{
		   			if(IsDefined(agent))
		   			{ 
				   		if(agent == attacker_ent)
				   		{
		   					agent thread playSoundInSpace( "US_0_inform_killfirm_sniper_greenband", agent.origin );
		   				//	owner thread maps\mp\gametypes\_rank::giveRankXP( "kill", 100 );
				   		}
			   		}
		   		}
		   	}
		}
		wait(0.05);
	}
}

// Bots currently do not fire at targets that are about 1200 units away from them but they do find targets that are much farther away
// Checks to see if bots chosen target is far away, and if it is does a raycast and if target is possible to hit, I force agent to face target and fire.
// if agent has no enemy target loops stops until agent has target.
BotForceAttackDistance()
{
	long_shot_distance = 1000;
	long_shot_time = 2;
	self endon("death");
	while(true)
	{
		wait(long_shot_time);
		if ( IsDefined( self.enemy ) )
		{
			BotEye = self GetEye();
			EnemyEye = self.enemy GetEye();
			
			if (long_shot_distance <= Distance(BotEye, EnemyEye))
			{
				trace = BulletTrace(BotEye, EnemyEye, true, self, false);
				if ( IsDefined( trace["entity"] ))
				{
					if(self.enemy == trace["entity"])
					{
						self BotLookAtPoint(EnemyEye, long_shot_time + 1, "script_forced");
						wait(1);
					//	self BotPressAttackButton();
					}
				}
			}
		}
		else if ( !IsDefined( self.enemy ) )
		{
			self waittill( "enemy" );
		}
	}
	/*
		bot_get_attacker_entity
		bot_notify_on_lost_enemy
		bot_in_combat
	*/
}


// Clears goals /  tactical goals of agent.  Makes them settle down.
BotClearGoals()
{
	self BotClearScriptEnemy();
	self BotClearScriptGoal();
	self bot_disable_tactical_goals();
}

// Checks to see if each agent passes through a large trigger below the windows and kills them if they touch it.  Prevents bots from walking
// around in player space if something bad happens.
AgentTriggerCheck()
{
	self endon("death");
	
	while(true)
	{
		level.TriggerAgentKiller waittill("trigger", hitEnt );
		if(IsDefined(hitEnt) && hitEnt == self)
		{
			if(isalive(self))
			{
				self thread RemoveAgent();
			}
		}
	}
}

// Makes bot run to window and knocks the window out if it exists
RunToWindow(spawn_point)
{
	self endon ("death");
		
	bot_goto = getent(spawn_point.target,"targetname");
	bot_lookat = getent(bot_goto.target,"targetname");
	glass = GetGlass(bot_lookat.target);
	
	self.bot_lookat = bot_lookat;
	
	self thread BotClearGoals();
	self BotSetFlag("disable_movement", 0);
	
	randomnumber = RandomFloatRange(0.05,0.1);
	wait(randomnumber);
	
	self BotSetScriptGoal(bot_goto.origin, 32, "critical", bot_lookat.angles[1] );
	self waittill("goal");
	self BotSetStance("stand");

	if( IsGlassDestroyed(glass) == false)
	{
		dir = anglestoforward(bot_lookat.angles);
		DestroyGlass(glass , dir * 200);
	}
	else if( IsGlassDestroyed(glass) == true)
	{
	//	IPrintLnBold("returned true");
	}
	// bots done getting to window, set up aim behavior
	// don't need this if AI aims corectly on it's own....
	self thread BotForceAttackDistance();
}

// Setting bot difficulty tuning values
TuneBotDifficultySettings()
{
	// Awareness at 0.01 makes bot really dumb
	self BotSetAwareness(10);
	self BotSetDifficulty("veteran");
	
	self BotSetDifficultySetting("yawSpeed",4.5);
	self BotSetDifficultySetting("yawSpeedAds",5);
	self BotSetDifficultySetting("pitchSpeed",2.5);
	self BotSetDifficultySetting("pitchSpeedAds",5);
	self BotSetDifficultySetting("adsAllowed",1);
	self BotSetDifficultySetting("maxFireTime",2000);
	self BotSetDifficultySetting("minFireTime",1000);
	self BotSetDifficultySetting("adsDelayFireTime",50);
	self BotSetDifficultySetting("adsDelayFireTimeScoped",50);
//	self BotSetDifficultySetting("holdBreathChance",1);
	self BotSetDifficultySetting("adsDelayFireIn",1);
	self BotSetDifficultySetting("minAimResponse",50);
	self BotSetDifficultySetting("maxAimResponse",50);
	self BotSetDifficultySetting("minInaccuracy",0.05);
	self BotSetDifficultySetting("maxInaccuracy",0.15);
	self BotSetDifficultySetting("targetLeadBias",4);
}

// Track the death of agents so we know when killstreak is over
TrackDeadAgents(Agents)
{
	// global death count checked in while loop
	level.deathcount = Agents.size;
	foreach(agent in Agents)
	{
		agent thread CheckForDeath();
	}
	while(level.deathcount > 0)
	{
		wait(0.1);
	}
//	IPrintLnBold("END KILL STREAK ALL AGENTS DEAD");
	
	// below lets script know killstreak is over and should kill all threads and allow killstreak to be called again
	level notify("snipers_dead");
	level.GreenBandKillStreakActive = false;
}

// Finds out when the agent dies
CheckForDeath()
{
	self waittill("death") ;
	self.isActive 	= false;
//	self.hasDied 	= false;
	self.owner		= undefined;
	
	// decrement global agent death count, hopefully getting to zero eventually
	level.deathcount--;
//	IPrintLnBold("Agent Died");
}

// Give agent the weapon and laser sight
GiveLaserSightAndWeapon(weapon)
{
	self endon("death");
	randomnumber = RandomFloatRange(0.05,0.1);
	wait(randomnumber);
	tag = "j_gun";
	if(IsALive(self))
	{
		self GiveWeapon(weapon);
		self LaserForceOn();
		SetDvar("laserRange",4000);
		SetDvar("laserRangePlayer",4000);
	}
}

// makes agent stupid, clearing goals and prevents agent from moving.
MakeAgentStupid()
{
	self thread BotClearGoals();
	self BotSetFlag("disable_movement", 1);
}

// set agent values like agent mesh, health, owner, and team
SetAgentValues(killstreak_owner)
{
	self SetModel( "mp_body_ally_pmc_sniper" );
	// set the agent to the player's team, need a wayway to modify agent name because now it is exactly the same as the owner and it is confusing
	self set_agent_team( killstreak_owner.team, killstreak_owner );
	
	self.agent_gameParticipant = false;
	self maps\mp\agents\_agents::set_agent_health( 100 );
//	self.owner = level.player;
	self.isActive 	= true;
	self.spawnTime 	= GetTime();
	self.IsSniper = true;
	self TakeAllWeapons();
	self.sessionteam = killstreak_owner.sessionteam;;
}

// Timer that dictates total time of killstreak
KillStreakTimer(duration, spawnpoint)
{
	self endon("death");
	level endon("snipers_dead");
	wait(duration);
//	IPrintLnBold("TIMER IS UP");
	self thread GetRidofAgent(spawnpoint);
}

// tells agent to move to where they can be despawned out of view
GetRidofAgent(exitpoint)
{
	self endon("death");
	if(IsAlive(self))
   	{
	   	self thread BotClearGoals();
		self BotSetFlag("disable_movement", 0);
		LookAtAngle = exitpoint.angles[1] +180;
		
		randomnumber = RandomFloatRange(0.01,0.3);
		wait(randomnumber);
		
	//	IPrintLnBold("Bot go to");
		self BotSetScriptGoal(exitpoint.origin, 32, "critical", LookAtAngle );
		
		//// calling this here to protect against agents that won't leave for some reason
		self thread ForceRemoveBotTimer();
		
		self waittill("goal");
		self thread RemoveAgent();
	}
	else 
	return false;
}

// This removes the agent on a backup timer incase the agent wont leavel.  Hopefully this never happens but if it does it 
// removes the agent even if the player can see the agent.
ForceRemoveBotTimer()
{
	self endon("death");
	level endon("snipers_dead");
	Timer = 20;
	wait(Timer);
	if(IsAlive(self))
   	{
		self thread RemoveAgent();
	}
}

// Kills the agent, other tasks in removing an agent are handled by function that listens for killed agents
RemoveAgent()
{
	self Suicide();
}

// Starts ragdoll, no death animations because who knows how that works for agents.... and gives agent cloned ragdoll mesh and impulse
// so they hopfully fall out of the window
RagDoll(eAttacker)
{
	self.body = self CloneAgent( 1000 );
	self.body startragdoll();
	
	PushAngles = self.bot_lookat.angles;
	/*
	if(IsDefined(eAttacker))
	{
		if(IsAlive(eAttacker))
		{
			AngleX = eAttacker.angles[0];
			AngleY = eAttacker.angles[1] + 180;
			AngleZ = eAttacker.angles[2];
			
			PushAngles = (AngleX, AngleY, AngleZ);
		}
	}
	*/
	RagDollSpot = anglestoforward(PushAngles);
	push_origin = self.body.origin;
	
	for(i = 0; i < 3; i++)
	{
	//	IPrintLnBold("phys jolt!");
		PhysicsJolt( push_origin + (0,0,44), 196, 96, RagDollSpot * 75 );
		wait(0.05);
	}
}

// Everytime an agent gets killed it runs this code.  Bypasses _agent kill code
on_agent_sniper_killed( eInflictor, eAttacker, iDamage, sMeansOfDeath, sWeapon, vDir, sHitLoc, timeOffset, deathAnimDuration )
{
	
	self.isActive 	= false;
	self.hasDied 	= false;
	self.owner		= undefined;
	
	self thread RagDoll(eAttacker);
	
	
	
//////////////////// Dumped all agent death anim stuff because anim state errors that plague this kill streak
///////////////////   Most of the time no animstate errors but could never remove them all.
/*
	if(RandomInt(100) > 75)
	{	
		self SetAnimState( "death" );
		
		animEntry = self GetAnimEntry();
		if(isdefined(animEntry))
		{
			animLength = GetAnimLength( animEntry );
			if(isdefined(animLength) && isdefined(animEntry))
			{
				IPrintLnBold("play animation death");
				deathAnimDuration = int( animLength * 1000 ); // duration in milliseconds
				self.body = self CloneAgent( deathAnimDuration );
				// ragdoll
				thread delayStartRagdoll( self.body, sHitLoc, vDir, sWeapon, eInflictor, sMeansOfDeath );
			}
		}
		else 
		{
			IPrintLnBold(" FAILED to play animation death");
			thread RagDoll();
		}
	}
	else 
	{
		IPrintLnBold("RAGDOLL DEATH");
		thread RagDoll();
		
	}
	*/
	
	// award XP for killing agents
	if( isPlayer( eAttacker ) && (!isDefined(self.owner) || eAttacker != self.owner) )
	{
		eAttacker thread maps\mp\gametypes\_rank::giveRankXP( "kill", 100, sWeapon, sMeansOfDeath );	
	//	eAttacker thread maps\mp\killstreaks\_killstreaks::giveAdrenaline( "vehicleDestroyed" );		
	}

	// cleaning up dead agents
	self maps\mp\agents\_agents::removeKillCamEntity();
	self maps\mp\agents\_agent_utility::deactivateAgent();

	self notify( "killanimscript" );
}