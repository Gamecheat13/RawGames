/*
	HQ
	Objective: 	Establish a headquarters and gain points as long as your team controls it
	Map ends:	When one teams score reaches the score limit, or time limit is reached
	Respawning:	Attackers respawn after 10 seconds, defenders do not respawn until they lose the radio

	Level requirements
	------------------
		Spawnpoints:
			classname		mp_tdm_spawn
			All players spawn from these. The spawnpoint chosen is dependent on the current locations of teammates and enemies
			at the time of spawn. Players generally spawn behind their teammates relative to the direction of enemies.

		Spectator Spawnpoints:
			classname		mp_global_intermission
			Spectators spawn from these and intermission is viewed from these positions.
			Atleast one is required, any more and they are randomly chosen between.

	Level script requirements
	-------------------------
		Team Definitions:
			game["allies"] = "american";
			game["axis"] = "german";
			This sets the nationalities of the teams. Allies can be american, british, or russian. Axis can be german.

		If using minefields or exploders:
			maps\mp\_load::main();

		Radio Position information:
			To add radios to your map add a section to your level script similar to the one below. To get the origin and angles
			values easily it is recommended that you temporarily place radio models in your level and copy the origin and angles
			values to your script. The reason these are in script and not the level itself is so radio positions can easily be
			changed if needed. See the official level scripts for more examples.

			if(getcvar("g_gametype") == "hq")
			{
				level.radio = [];
				level.radio[0] = spawn("script_model", (174, -310, 16));
				level.radio[0].angles = (0, 57, 0);
				level.radio[1] = spawn("script_model", (-31, -32, 16));
				level.radio[1].angles = (0, 1, 0);
				level.radio[2] = spawn("script_model", (-299, -277, 16));
				level.radio[2].angles = (0, 312, 0);
			}

	Optional level script settings
	------------------------------
		Soldier Type and Variation:
			game["american_soldiertype"] = "normandy";
			game["german_soldiertype"] = "normandy";
			This sets what character models are used for each nationality on a particular map.

			Valid settings:
				american_soldiertype	normandy
				british_soldiertype		normandy, africa
				russian_soldiertype		coats, padded
				german_soldiertype		normandy, africa, winterlight, winterdark
*/

main()
{
	level.callbackStartGameType = ::Callback_StartGameType;
	level.callbackPlayerConnect = ::Callback_PlayerConnect;
	level.callbackPlayerDisconnect = ::Callback_PlayerDisconnect;
	level.callbackPlayerDamage = ::Callback_PlayerDamage;
	level.callbackPlayerKilled = ::Callback_PlayerKilled;
	maps\mp\gametypes\_callbacksetup::SetupCallbacks();

	level.autoassign = ::menuAutoAssign;
	level.allies = ::menuAllies;
	level.axis = ::menuAxis;
	level.spectator = ::menuSpectator;
	level.weapon = ::menuWeapon;
	level.endgameconfirmed = ::endMap;
}

Callback_StartGameType()
{
	level.splitscreen = isSplitScreen();

	// defaults if not defined in level script
	if(!isdefined(game["allies"]))
		game["allies"] = "american";
	if(!isdefined(game["axis"]))
		game["axis"] = "german";

	// server cvar overrides
	if(getcvar("scr_allies") != "")
		game["allies"] = getcvar("scr_allies");
	if(getcvar("scr_axis") != "")
		game["axis"] = getcvar("scr_axis");

	game["radio_prespawn"][0] = "objectiveA";
	game["radio_prespawn"][1] = "objectiveB";
	game["radio_prespawn"][2] = "objective";
	game["radio_prespawn_objpoint"][0] = "objpoint_A";
	game["radio_prespawn_objpoint"][1] = "objpoint_B";
	game["radio_prespawn_objpoint"][2] = "objpoint_star";
	game["radio_none"] = "objective";
	game["radio_axis"] = "objective_" + game["axis"];
	game["radio_allies"] = "objective_" + game["allies"];

	//custom radio colors for different nationalities
	if(game["allies"] == "american")
		game["radio_model"] = "xmodel/military_german_fieldradio_green_nonsolid";
	else if(game["allies"] == "british")
		game["radio_model"] = "xmodel/military_german_fieldradio_tan_nonsolid";
	else if(game["allies"] == "russian")
		game["radio_model"] = "xmodel/military_german_fieldradio_grey_nonsolid";
	assert(isdefined(game["radio_model"]));

	precacheShader("white");
	precacheShader("objective");
	precacheShader("objectiveA");
	precacheShader("objectiveB");
	precacheShader("objective");
	precacheShader("objpoint_A");
	precacheShader("objpoint_B");
	precacheShader("objpoint_radio");
	precacheShader("field_radio");
	precacheShader(game["radio_allies"]);
	precacheShader(game["radio_axis"]);
	precacheStatusIcon("hud_status_dead");
	precacheStatusIcon("hud_status_connecting");
	precacheRumble("damage_heavy");
	precacheModel(game["radio_model"]);
	precacheString(&"MP_TIME_TILL_SPAWN");
	precacheString(&"MP_ESTABLISHING_HQ");
	precacheString(&"MP_DESTROYING_HQ");
	precacheString(&"MP_LOSING_HQ");
	precacheString(&"MP_MAXHOLDTIME_MINUTESANDSECONDS");
	precacheString(&"MP_MAXHOLDTIME_MINUTES");
	precacheString(&"MP_MAXHOLDTIME_SECONDS");
	precacheString(&"MP_UPTEAM");
	precacheString(&"MP_DOWNTEAM");
	precacheString(&"MP_RESPAWN_WHEN_RADIO_NEUTRALIZED");
	precacheString(&"MP_MATCHSTARTING");
	precacheString(&"MP_MATCHRESUMING");
	precacheString(&"PLATFORM_PRESS_TO_SPAWN");

	thread maps\mp\gametypes\_menus::init();
	thread maps\mp\gametypes\_serversettings::init();
	thread maps\mp\gametypes\_clientids::init();
	thread maps\mp\gametypes\_teams::init();
	thread maps\mp\gametypes\_weapons::init();
	thread maps\mp\gametypes\_scoreboard::init();
	thread maps\mp\gametypes\_killcam::init();
	thread maps\mp\gametypes\_shellshock::init();
	thread maps\mp\gametypes\_hud_teamscore::init();
	thread maps\mp\gametypes\_deathicons::init();
	thread maps\mp\gametypes\_damagefeedback::init();
	thread maps\mp\gametypes\_healthoverlay::init();
	thread maps\mp\gametypes\_objpoints::init();
	thread maps\mp\gametypes\_friendicons::init();
	thread maps\mp\gametypes\_spectating::init();
	thread maps\mp\gametypes\_grenadeindicators::init();

	level.xenon = (getcvar("xenonGame") == "true");
	if(level.xenon) // Xenon only
		thread maps\mp\gametypes\_richpresence::init();
	else // PC only
		thread maps\mp\gametypes\_quickmessages::init();

	setClientNameMode("auto_change");
	level.graceperiod = true;

	spawnpointname = "mp_tdm_spawn";
	spawnpoints = getentarray(spawnpointname, "classname");

	if(!spawnpoints.size)
	{
		maps\mp\gametypes\_callbacksetup::AbortLevel();
		return;
	}

	for(i = 0; i < spawnpoints.size; i++)
		spawnpoints[i] placeSpawnpoint();

	level._effect["radioexplosion"] = loadfx("fx/explosions/grenadeExp_blacktop.efx");

	allowed[0] = "tdm";
	maps\mp\gametypes\_gameobjects::main(allowed);

	// Time limit per map
	if(getcvar("scr_hq_timelimit") == "")
		setcvar("scr_hq_timelimit", "30");
	else if(getcvarfloat("scr_hq_timelimit") > 1440)
		setcvar("scr_hq_timelimit", "1440");
	level.timelimit = getcvarfloat("scr_hq_timelimit");
	setCvar("ui_hq_timelimit", level.timelimit);
	makeCvarServerInfo("ui_hq_timelimit", "30");

	// Score limit per map
	if(getcvar("scr_hq_scorelimit") == "")
		setcvar("scr_hq_scorelimit", "300");
	level.scorelimit = getcvarint("scr_hq_scorelimit");
	setCvar("ui_hq_scorelimit", level.scorelimit);
	makeCvarServerInfo("ui_hq_scorelimit", "300");

	// Draws a team icon over teammates
	if(getcvar("scr_drawfriend") == "")
		setcvar("scr_drawfriend", "1");
	level.drawfriend = getcvarint("scr_drawfriend");

	if(!isdefined(game["state"]))
		game["state"] = "playing";

	level.mapended = false;
	level.roundStarted = false;

	level.team["allies"] = 0;
	level.team["axis"] = 0;

	level.zradioradius = 72; // Z Distance players must be from a radio to capture/neutralize it
	level.captured_radios["allies"] = 0;
	level.captured_radios["axis"] = 0;

	level.progressBarHeight = 12;

	if(level.splitscreen)
		level.progressBarWidth = 152;
	else
		level.progressBarWidth = 192;

	level.RadioSpawnDelay = 15;
	level.radioradius = 120;
	level.respawngracetime = 5;
	level.RadioMaxHoldSeconds = 120;
	level.timesCaptured = 0;
	level.nextradio = 0;
	level.spawnframe = 0;
	level.DefendingRadioTeam = "none";
	level.NeutralizingPoints = 10;
	level.MultipleCaptureBias = 1;
	level.respawndelay = 10;

	hq_setup();

	thread hq_points();
	thread startGame();
	thread updateGametypeCvars();
	//thread maps\mp\gametypes\_teams::addTestClients();
}

dummy()
{
	waittillframeend;

	if(isdefined(self))
		level notify("connecting", self);
}

Callback_PlayerConnect()
{
	thread dummy();

	self.statusicon = "hud_status_connecting";
	self waittill("begin");
	self.statusicon = "";

	level notify("connected", self);

	if(!level.splitscreen)
		iprintln(&"MP_CONNECTED", self);

	lpselfnum = self getEntityNumber();
	lpGuid = self getGuid();
	logPrint("J;" + lpGuid + ";" + lpselfnum + ";" + self.name + "\n");

	if(game["state"] == "intermission")
	{
		spawnIntermission();
		return;
	}

	level endon("intermission");

	if(level.splitscreen)
		scriptMainMenu = game["menu_ingame_spectator"];
	else
		scriptMainMenu = game["menu_ingame"];

	if(isdefined(self.pers["team"]) && self.pers["team"] != "spectator")
	{
		self setClientCvar("ui_allow_weaponchange", "1");

		if(self.pers["team"] == "allies")
			self.sessionteam = "allies";
		else
			self.sessionteam = "axis";

		if(isdefined(self.pers["weapon"]))
			spawnPlayer();
		else
		{
			spawnSpectator();

			if(self.pers["team"] == "allies")
			{
				self openMenu(game["menu_weapon_allies"]);
				scriptMainMenu = game["menu_weapon_allies"];
			}
			else
			{
				self openMenu(game["menu_weapon_axis"]);
				scriptMainMenu = game["menu_weapon_axis"];
			}
		}
	}
	else
	{
		self setClientCvar("ui_allow_weaponchange", "0");

		if(!level.xenon)
		{
			if(!isdefined(self.pers["skipserverinfo"]))
				self openMenu(game["menu_serverinfo"]);
		}
		else
			self openMenu(game["menu_team"]);

		self.pers["team"] = "spectator";
		self.sessionteam = "spectator";

		spawnSpectator();
	}

	self setClientCvar("g_scriptMainMenu", scriptMainMenu);
}

Callback_PlayerDisconnect()
{
	if(!level.splitscreen)
		iprintln(&"MP_DISCONNECTED", self);

	if(isdefined(self.pers["team"]))
	{
		if(self.pers["team"] == "allies")
			setplayerteamrank(self, 0, 0);
		else if(self.pers["team"] == "axis")
			setplayerteamrank(self, 1, 0);
		else if(self.pers["team"] == "spectator")
			setplayerteamrank(self, 2, 0);
	}

	lpselfnum = self getEntityNumber();
	lpGuid = self getGuid();
	logPrint("Q;" + lpGuid + ";" + lpselfnum + ";" + self.name + "\n");
}

Callback_PlayerDamage(eInflictor, eAttacker, iDamage, iDFlags, sMeansOfDeath, sWeapon, vPoint, vDir, sHitLoc, psOffsetTime)
{
	if(self.sessionteam == "spectator")
		return;

	friendly = undefined;

	// Don't do knockback if the damage direction was not specified
	if(!isdefined(vDir))
		iDFlags |= level.iDFLAGS_NO_KNOCKBACK;

	// check for completely getting out of the damage
	if(!(iDFlags & level.iDFLAGS_NO_PROTECTION))
	{
		if(isPlayer(eAttacker) && (self != eAttacker) && (self.pers["team"] == eAttacker.pers["team"]))
		{
			if(level.friendlyfire == "0")
			{
				return;
			}
			else if(level.friendlyfire == "1")
			{
				// Make sure at least one point of damage is done
				if(iDamage < 1)
					iDamage = 1;

				self finishPlayerDamage(eInflictor, eAttacker, iDamage, iDFlags, sMeansOfDeath, sWeapon, vPoint, vDir, sHitLoc, psOffsetTime);

				// Shellshock/Rumble
				self thread maps\mp\gametypes\_shellshock::shellshockOnDamage(sMeansOfDeath, iDamage);
				self playrumble("damage_heavy");
			}
			else if(level.friendlyfire == "2")
			{
				eAttacker.friendlydamage = true;

				iDamage = int(iDamage * .5);

				// Make sure at least one point of damage is done
				if(iDamage < 1)
					iDamage = 1;

				eAttacker finishPlayerDamage(eInflictor, eAttacker, iDamage, iDFlags, sMeansOfDeath, sWeapon, vPoint, vDir, sHitLoc, psOffsetTime);
				eAttacker.friendlydamage = undefined;

				friendly = true;
			}
			else if(level.friendlyfire == "3")
			{
				eAttacker.friendlydamage = true;

				iDamage = int(iDamage * .5);

				// Make sure at least one point of damage is done
				if(iDamage < 1)
					iDamage = 1;

				self finishPlayerDamage(eInflictor, eAttacker, iDamage, iDFlags, sMeansOfDeath, sWeapon, vPoint, vDir, sHitLoc, psOffsetTime);
				eAttacker finishPlayerDamage(eInflictor, eAttacker, iDamage, iDFlags, sMeansOfDeath, sWeapon, vPoint, vDir, sHitLoc, psOffsetTime);
				eAttacker.friendlydamage = undefined;

		        // Shellshock/Rumble
		        self thread maps\mp\gametypes\_shellshock::shellshockOnDamage(sMeansOfDeath, iDamage);
		        self playrumble("damage_heavy");

				friendly = true;
			}
		}
		else
		{
			// Make sure at least one point of damage is done
			if(iDamage < 1)
				iDamage = 1;

			self finishPlayerDamage(eInflictor, eAttacker, iDamage, iDFlags, sMeansOfDeath, sWeapon, vPoint, vDir, sHitLoc, psOffsetTime);

			// Shellshock/Rumble
			self thread maps\mp\gametypes\_shellshock::shellshockOnDamage(sMeansOfDeath, iDamage);
			self playrumble("damage_heavy");
		}

		if(isdefined(eAttacker) && eAttacker != self)
			eAttacker thread maps\mp\gametypes\_damagefeedback::updateDamageFeedback();
	}

	// Do debug print if it's enabled
	if(getCvarInt("g_debugDamage"))
	{
		println("client:" + self getEntityNumber() + " health:" + self.health +
			" damage:" + iDamage + " hitLoc:" + sHitLoc);
	}

	if(self.sessionstate != "dead")
	{
		lpselfnum = self getEntityNumber();
		lpselfname = self.name;
		lpselfteam = self.pers["team"];
		lpselfGuid = self getGuid();
		lpattackerteam = "";

		if(isPlayer(eAttacker))
		{
			lpattacknum = eAttacker getEntityNumber();
			lpattackname = eAttacker.name;
			lpattackGuid = eAttacker getGuid();
			lpattackerteam = eAttacker.pers["team"];
		}
		else
		{
			lpattacknum = -1;
			lpattackGuid = "";
			lpattackname = "";
			lpattackerteam = "world";
		}

		if(isdefined(friendly))
		{
			lpattacknum = lpselfnum;
			lpattackname = lpselfname;
			lpattackGuid = lpselfGuid;
		}

		logPrint("D;" + lpselfGuid + ";" + lpselfnum + ";" + lpselfteam + ";" + lpselfname + ";" + lpattackGuid + ";" + lpattacknum + ";" + lpattackerteam + ";" + lpattackname + ";" + sWeapon + ";" + iDamage + ";" + sMeansOfDeath + ";" + sHitLoc + "\n");
	}
}

Callback_PlayerKilled(eInflictor, attacker, iDamage, sMeansOfDeath, sWeapon, vDir, sHitLoc, psOffsetTime, deathAnimDuration)
{
	self endon("spawned");
	self notify("killed_player");

	if(self.sessionteam == "spectator")
		return;

	doKillcam = false;

	// If the player was killed by a head shot, let players know it was a head shot kill
	if(sHitLoc == "head" && sMeansOfDeath != "MOD_MELEE")
		sMeansOfDeath = "MOD_HEAD_SHOT";

	// send out an obituary message to all clients about the kill
	obituary(self, attacker, sWeapon, sMeansOfDeath);

	self maps\mp\gametypes\_weapons::dropWeapon();
	self maps\mp\gametypes\_weapons::dropOffhand();

	self.sessionstate = "dead";
	self.statusicon = "hud_status_dead";
	self.dead_origin = self.origin;
	self.dead_angles = self.angles;

	if(!isdefined(self.switching_teams))
		self.deaths++;

	lpselfnum = self getEntityNumber();
	lpselfname = self.name;
	lpselfguid = self getGuid();
	lpselfteam = self.pers["team"];
	lpattackerteam = "";

	attackerNum = -1;

	if(isPlayer(attacker))
	{
		if(attacker == self) // killed himself
		{
			doKillcam = false;

			// switching teams
			if(isdefined(self.switching_teams))
			{
				if((self.leaving_team == "allies" && self.joining_team == "axis") || (self.leaving_team == "axis" && self.joining_team == "allies"))
				{
					players = maps\mp\gametypes\_teams::CountPlayers();
					players[self.leaving_team]--;
					players[self.joining_team]++;

					if((players[self.joining_team] - players[self.leaving_team]) > 1)
						attacker.score--;
				}
			}

			if(isdefined(attacker.friendlydamage))
				attacker iprintln(&"MP_FRIENDLY_FIRE_WILL_NOT");
		}
		else
		{
			attackerNum = attacker getEntityNumber();
			doKillcam = true;

			if(self.pers["team"] == attacker.pers["team"]) // killed by a friendly
				attacker.score--;
			else
				attacker.score++;
		}

		lpattacknum = attacker getEntityNumber();
		lpattackguid = attacker getGuid();
		lpattackname = attacker.name;
		lpattackerteam = attacker.pers["team"];
	}
	else // If you weren't killed by a player, you were in the wrong place at the wrong time
	{
		doKillcam = false;

		self.score--;

		lpattacknum = -1;
		lpattackname = "";
		lpattackguid = "";
		lpattackerteam = "world";
	}

	logPrint("K;" + lpselfguid + ";" + lpselfnum + ";" + lpselfteam + ";" + lpselfname + ";" + lpattackguid + ";" + lpattacknum + ";" + lpattackerteam + ";" + lpattackname + ";" + sWeapon + ";" + iDamage + ";" + sMeansOfDeath + ";" + sHitLoc + "\n");

	// Stop thread if map ended on this death
	if(level.mapended)
		return;

	self.switching_teams = undefined;
	self.joining_team = undefined;
	self.leaving_team = undefined;

	level hq_removeall_hudelems(self);

	body = self cloneplayer(deathAnimDuration);
	thread maps\mp\gametypes\_deathicons::addDeathicon(body, self.clientid, self.pers["team"], 5);

	defendingBeforeDeath = true;
	if((isdefined(self.pers["team"])) && (level.DefendingRadioTeam != self.pers["team"]))
		defendingBeforeDeath = false;

	defendingAfterDeath = false;
	if((isdefined(self.pers["team"])) && (level.DefendingRadioTeam == self.pers["team"]))
		defendingAfterDeath = true;

	allowInstantRespawn = false;
	if((!defendingBeforeDeath) && (defendingAfterDeath))
		allowInstantRespawn = true;

	//check if it was the last person to die on the defending team
	level updateTeamStatus();
	if((isdefined(self.pers["team"])) && (level.DefendingRadioTeam == self.pers["team"]) && (level.exist[self.pers["team"]] <= 0))
	{
		allowInstantRespawn = true;
		for(i = 0; i < level.radio.size; i++)
		{
			if(level.radio[i].hidden == true)
				continue;
			level hq_radio_capture(level.radio[i], "none");
			break;
		}
	}

	delay = 2;

	if((level.roundStarted) && (!allowInstantRespawn))
	{
		self thread respawn_timer(delay);
		self thread respawn_staydead(delay);
	}

	wait delay;	// ?? Also required for Callback_PlayerKilled to complete before respawn/killcam can execute

	if(doKillcam && level.killcam)
		self maps\mp\gametypes\_killcam::killcam(attackerNum, delay, psOffsetTime);

	self thread respawn();
}

spawnPlayer()
{
	self endon("disconnect");

	if((!isdefined(self.pers["weapon"])) || (!isdefined(self.pers["team"])))
		return;

	self notify("spawned");
	self notify("end_respawn");

	resettimeout();

	// Stop shellshock and rumble
	self stopShellshock();
	self stoprumble("damage_heavy");

	self.sessionteam = self.pers["team"];
	self.sessionstate = "playing";
	self.spectatorclient = -1;
	self.archivetime = 0;
	self.psoffsettime = 0;
	self.friendlydamage = undefined;
	self.statusicon = "";
	self.maxhealth = 100;
	self.health = self.maxhealth;
	self.dead_origin = undefined;
	self.dead_angles = undefined;

	spawnpointname = "mp_tdm_spawn";
	spawnpoints = getentarray(spawnpointname, "classname");
	spawnpoint = maps\mp\gametypes\_spawnlogic::getSpawnpoint_NearTeam_AwayfromRadios(spawnpoints);

	if(isdefined(spawnpoint))
		self spawn(spawnpoint.origin, spawnpoint.angles);
	else
		maps\mp\_utility::error("NO " + spawnpointname + " SPAWNPOINTS IN MAP");

	if(!isdefined(self.pers["savedmodel"]))
		maps\mp\gametypes\_teams::model();
	else
		maps\mp\_utility::loadModel(self.pers["savedmodel"]);

	maps\mp\gametypes\_weapons::givePistol();
	maps\mp\gametypes\_weapons::giveGrenades();
	maps\mp\gametypes\_weapons::giveBinoculars();

	if(!isdefined(self))
		return;

	self giveWeapon(self.pers["weapon"]);
	self giveMaxAmmo(self.pers["weapon"]);
	self setSpawnWeapon(self.pers["weapon"]);

	if(!level.splitscreen)
	{
		if(level.scorelimit > 0)
			self setClientCvar("cg_objectiveText", &"MP_OBJ_TEXT", level.scorelimit);
		else
			self setClientCvar("cg_objectiveText", &"MP_OBJ_TEXT_NOSCORE");
	}
	else
		self setClientCvar("cg_objectiveText", &"MP_ESTABLISH_AND_DEFEND");

	self thread updateTimer();

	waittillframeend;
	self notify("spawned_player");
}

spawnSpectator(origin, angles)
{
	self notify("spawned");
	self notify("end_respawn");

	resettimeout();

	// Stop shellshock and rumble
	self stopShellshock();
	self stoprumble("damage_heavy");

	self.sessionstate = "spectator";
	self.spectatorclient = -1;
	self.archivetime = 0;
	self.psoffsettime = 0;
	self.friendlydamage = undefined;

	if(self.pers["team"] == "spectator")
		self.statusicon = "";

	maps\mp\gametypes\_spectating::setSpectatePermissions();

	if(isdefined(origin) && isdefined(angles))
		self spawn(origin, angles);
	else
	{
        spawnpointname = "mp_global_intermission";
		spawnpoints = getentarray(spawnpointname, "classname");
		spawnpoint = maps\mp\gametypes\_spawnlogic::getSpawnpoint_Random(spawnpoints);

		if(isdefined(spawnpoint))
			self spawn(spawnpoint.origin, spawnpoint.angles);
		else
			maps\mp\_utility::error("NO " + spawnpointname + " SPAWNPOINTS IN MAP");
	}

	self setClientCvar("cg_objectiveText", "");

	level hq_removeall_hudelems(self);
}

spawnIntermission()
{
	self notify("spawned");
	self notify("end_respawn");

	resettimeout();

	// Stop shellshock and rumble
	self stopShellshock();
	self stoprumble("damage_heavy");

	self.sessionstate = "intermission";
	self.spectatorclient = -1;
	self.archivetime = 0;
	self.psoffsettime = 0;
	self.friendlydamage = undefined;

	spawnpointname = "mp_global_intermission";
	spawnpoints = getentarray(spawnpointname, "classname");
	spawnpoint = maps\mp\gametypes\_spawnlogic::getSpawnpoint_Random(spawnpoints);

	if(isdefined(spawnpoint))
		self spawn(spawnpoint.origin, spawnpoint.angles);
	else
		maps\mp\_utility::error("NO " + spawnpointname + " SPAWNPOINTS IN MAP");

	level hq_removeall_hudelems(self);
	self thread updateTimer();
}

respawn()
{
	self endon("disconnect");
	self endon("end_respawn");

	if(!isdefined(self.pers["weapon"]))
		return;

	self.sessionteam = self.pers["team"];
	self.sessionstate = "spectator";

	if(isdefined(self.dead_origin) && isdefined(self.dead_angles))
	{
		origin = self.dead_origin + (0, 0, 16);
		angles = self.dead_angles;
	}
	else
	{
		origin = self.origin + (0, 0, 16);
		angles = self.angles;
	}

	self spawn(origin, angles);

	while(isdefined(self.WaitingOnTimer) || ((self.pers["team"] == level.DefendingRadioTeam) && isdefined(self.WaitingOnNeutralize)))
		wait .05;

	if(getCvarInt("scr_forcerespawn") <= 0)
	{
		self thread waitRespawnButton();
		self waittill("respawn");
	}

	self thread spawnPlayer();
}

waitRespawnButton()
{
	self endon("disconnect");
	self endon("end_respawn");
	self endon("respawn");

	wait 0; // Required or the "respawn" notify could happen before it's waittill has begun

	if(!isdefined(self.respawntext))
	{
		self.respawntext = newClientHudElem(self);
		self.respawntext.horzAlign = "center_safearea";
		self.respawntext.vertAlign = "center_safearea";
		self.respawntext.alignX = "center";
		self.respawntext.alignY = "middle";
		self.respawntext.x = 0;
		self.respawntext.y = -50;
		self.respawntext.archived = false;
		self.respawntext.font = "default";
		self.respawntext.fontscale = 2;
		self.respawntext setText(&"PLATFORM_PRESS_TO_SPAWN");
	}

	thread removeRespawnText();
	thread waitRemoveRespawnText("end_respawn");
	thread waitRemoveRespawnText("respawn");

	while(self useButtonPressed() != true)
		wait .05;

	self notify("remove_respawntext");

	self notify("respawn");
}

removeRespawnText()
{
	self waittill("remove_respawntext");

	if(isdefined(self.respawntext))
		self.respawntext destroy();
}

waitRemoveRespawnText(message)
{
	self endon("remove_respawntext");

	self waittill(message);
	self notify("remove_respawntext");
}

startGame()
{
	level.starttime = getTime();

	if(level.timelimit > 0)
	{
		level.clock = newHudElem();
		level.clock.horzAlign = "left";
		level.clock.vertAlign = "top";
		level.clock.x = 8;
		level.clock.y = 2;
		level.clock.font = "default";
		level.clock.fontscale = 2;
		level.clock setTimer(level.timelimit * 60);
	}

	for(;;)
	{
		checkTimeLimit();
		wait 1;
	}
}

endMap()
{
	game["state"] = "intermission";
	level notify("intermission");

	alliedscore = getTeamScore("allies");
	axisscore = getTeamScore("axis");

	winners = undefined;
	losers = undefined;

	if(alliedscore == axisscore)
	{
		winningteam = "tie";
		losingteam = "tie";
		text = "MP_THE_GAME_IS_A_TIE";
	}
	else if(alliedscore > axisscore)
	{
		winningteam = "allies";
		losingteam = "axis";
		text = &"MP_ALLIES_WIN";
	}
	else
	{
		winningteam = "axis";
		losingteam = "allies";
		text = &"MP_AXIS_WIN";
	}

	if((winningteam == "allies") || (winningteam == "axis"))
	{
		winners = "";
		losers = "";
	}

	if(winningteam == "allies")
		level thread playSoundOnPlayers("MP_announcer_allies_win");
	else if(winningteam == "axis")
		level thread playSoundOnPlayers("MP_announcer_axis_win");
	else
		level thread playSoundOnPlayers("MP_announcer_round_draw");

	players = getentarray("player", "classname");
	for(i = 0; i < players.size; i++)
	{
		player = players[i];
		if((winningteam == "allies") || (winningteam == "axis"))
		{
			lpGuid = player getGuid();
			if((isdefined(player.pers["team"])) && (player.pers["team"] == winningteam))
					winners = (winners + ";" + lpGuid + ";" + player.name);
			else if((isdefined(player.pers["team"])) && (player.pers["team"] == losingteam))
					losers = (losers + ";" + lpGuid + ";" + player.name);
		}

		player closeMenu();
		player closeInGameMenu();
		player setClientCvar("cg_objectiveText", text);
		player spawnIntermission();
	}

	if((winningteam == "allies") || (winningteam == "axis"))
	{
		logPrint("W;" + winningteam + winners + "\n");
		logPrint("L;" + losingteam + losers + "\n");
	}

	// set everyone's rank on xenon
	if(level.xenon)
	{
		players = getentarray("player", "classname");
		highscore = undefined;

		for(i = 0; i < players.size; i++)
		{
			player = players[i];

			if(!isdefined(player.score))
				continue;

			if(!isdefined(highscore) || player.score > highscore)
				highscore = player.score;
		}

		for(i = 0; i < players.size; i++)
		{
			player = players[i];

			if(!isdefined(player.score))
				continue;

			if(highscore <= 0)
				rank = 0;
			else
			{
				rank = int(player.score * 10 / highscore);
				if(rank < 0)
					rank = 0;
			}

			if(player.pers["team"] == "allies")
				setplayerteamrank(player, 0, rank);
			else if(player.pers["team"] == "axis")
				setplayerteamrank(player, 1, rank);
			else if(player.pers["team"] == "spectator")
				setplayerteamrank(player, 2, rank);
		}
		sendranks();
	}

	wait 10;
	exitLevel(false);
}

checkTimeLimit()
{
	if(level.timelimit <= 0)
		return;

	timepassed = (getTime() - level.starttime) / 1000;
	timepassed = timepassed / 60.0;

	if(timepassed < level.timelimit)
		return;

	if(level.mapended)
		return;
	level.mapended = true;

	if(!level.splitscreen)
		iprintln(&"MP_TIME_LIMIT_REACHED");

	level thread endMap();
}

checkScoreLimit()
{
	if(level.scorelimit <= 0)
		return;

	if(getTeamScore("allies") < level.scorelimit && getTeamScore("axis") < level.scorelimit)
		return;

	if(level.mapended)
		return;
	level.mapended = true;

	if(!level.splitscreen)
		iprintln(&"MP_SCORE_LIMIT_REACHED");

	level thread endMap();
}

updateGametypeCvars()
{
	wait 1;
	for(;;)
	{
		timelimit = getcvarfloat("scr_hq_timelimit");
		if(level.timelimit != timelimit)
		{
			if(timelimit > 1440)
			{
				timelimit = 1440;
				setcvar("scr_hq_timelimit", "1440");
			}

			level.timelimit = timelimit;
			setCvar("ui_hq_timelimit", level.timelimit);
			level.starttime = getTime();

			if(level.timelimit > 0)
			{
				if(!isdefined(level.clock))
				{
					level.clock = newHudElem();
					level.clock.horzAlign = "left";
					level.clock.vertAlign = "top";
					level.clock.x = 8;
					level.clock.y = 2;
					level.clock.font = "default";
					level.clock.fontscale = 2;
				}
				level.clock setTimer(level.timelimit * 60);
			}
			else
			{
				if(isdefined(level.clock))
					level.clock destroy();
			}

			checkTimeLimit();
		}

		scorelimit = getcvarint("scr_hq_scorelimit");
		if(level.scorelimit != scorelimit)
		{
			level.scorelimit = scorelimit;
			setCvar("ui_hq_scorelimit", level.scorelimit);
			level notify("update_allhud_score");
		}
		checkScoreLimit();

		wait 1;
	}
}

printJoinedTeam(team)
{
	if(!level.splitscreen)
	{
		if(team == "allies")
			iprintln(&"MP_JOINED_ALLIES", self);
		else if(team == "axis")
			iprintln(&"MP_JOINED_AXIS", self);
	}
}

hq_setup()
{
	wait 0.05;

	maperrors = [];

	if(!isdefined(level.radio))
		level.radio = getentarray("hqradio", "targetname");

	if(level.radio.size < 3)
		maperrors[maperrors.size] = "^1Less than 3 entities found with \"targetname\" \"hqradio\"";

	if(maperrors.size)
	{
		println("^1------------ Map Errors ------------");
		for(i = 0; i < maperrors.size; i++)
			println(maperrors[i]);
		println("^1------------------------------------");

		return;
	}

	setTeamScore("allies", 0);
	setTeamScore("axis", 0);

	for(i = 0; i < level.radio.size; i++)
	{
		level.radio[i] setmodel(game["radio_model"]);
		level.radio[i].team = "none";
		level.radio[i].holdtime_allies = 0;
		level.radio[i].holdtime_axis = 0;
		level.radio[i].hidden = true;
		level.radio[i] hide();

		if((!isdefined(level.radio[i].script_radius)) || (level.radio[i].script_radius <= 0))
			level.radio[i].radius = level.radioradius;
		else
			level.radio[i].radius = level.radio[i].script_radius;

		level thread hq_radio_think(level.radio[i]);
	}

	hq_randomize_radioarray();

	level thread hq_obj_think();
}

hq_randomize_radioarray()
{
	for(i = 0; i < level.radio.size; i++)
	{
		rand = randomint(level.radio.size);
    	temp = level.radio[i];
    	level.radio[i] = level.radio[rand];
    	level.radio[rand] = temp;
	}
}

hq_obj_think(radio)
{
	NeutralRadios = 0;
	for(i = 0; i < level.radio.size; i++)
	{
		if(level.radio[i].hidden == true)
			continue;
		NeutralRadios++;
	}
	
	if(NeutralRadios <= 0)
	{
		if(level.nextradio > level.radio.size - 1)
		{
			hq_randomize_radioarray();
			level.nextradio = 0;

			if(isdefined(radio))
			{
				// same radio twice in a row so go to the next radio
				if(radio == level.radio[level.nextradio])
					level.nextradio++;
			}
		}

		//find a fake radio position that isn't the last position or the next position
		randAorB = undefined;
		if(level.radio.size >= 4)
		{
			fakeposition = level.radio[randomint(level.radio.size)];
			if(isdefined(level.radio[(level.nextradio - 1)]))
			{
				while((fakeposition == level.radio[level.nextradio]) || (fakeposition == level.radio[level.nextradio - 1]))
					fakeposition = level.radio[randomint(level.radio.size)];
			}
			else
			{
				while(fakeposition == level.radio[level.nextradio])
					fakeposition = level.radio[randomint(level.radio.size)];
			}
			randAorB = randomint(2);
//			objective_add(1, "current", fakeposition.origin, game["radio_prespawn"][randAorB]);
//			thread maps\mp\gametypes\_objpoints::addObjpoint(fakeposition.origin, "1", game["radio_prespawn_objpoint"][randAorB]);
		}
		
		if(!isdefined(randAorB))
			otherAorB = 2; //use original icon since there is only one objective that will show
		else if(randAorB == 1)
			otherAorB = 0;
		else
			otherAorB = 1;
//		objective_add(0, "current", level.radio[level.nextradio].origin, game["radio_prespawn"][otherAorB]);
//		thread maps\mp\gametypes\_objpoints::addObjpoint(level.radio[level.nextradio].origin, "0", game["radio_prespawn_objpoint"][otherAorB]);

		level hq_check_teams_exist();
		restartRound = false;
		
		while((!level.alliesexist) || (!level.axisexist))
		{
			restartRound = true;
			wait 2;
			level hq_check_teams_exist();
		}
		
		if(restartRound)
			restartRound();
		level.roundStarted = true;

		iprintln(&"MP_RADIOS_SPAWN_IN_SECONDS", level.RadioSpawnDelay);
		wait level.RadioSpawnDelay;

		level.radio[level.nextradio] show();
		level.radio[level.nextradio].hidden = false;

		level thread playSoundOnPlayers("explo_plant_no_tick");
		objective_add(0, "current", level.radio[level.nextradio].origin, game["radio_prespawn"][2]);
//		objective_icon(0, game["radio_none"]);
//		objective_delete(1);
		thread maps\mp\gametypes\_objpoints::removeObjpoints();
		thread maps\mp\gametypes\_objpoints::addObjpoint(level.radio[level.nextradio].origin, "0", "objpoint_radio");

		if((level.captured_radios["allies"] <= 0) && (level.captured_radios["axis"] > 0)) // AXIS HAVE A RADIO AND ALLIES DONT
			objective_team(0, "allies");
		else if((level.captured_radios["allies"] > 0) && (level.captured_radios["axis"] <= 0)) // ALLIES HAVE A RADIO AND AXIS DONT
			objective_team(0, "axis");
		else // NO TEAMS HAVE A RADIO
			objective_team(0, "none");

		level.nextradio++;
	}
}

hq_radio_think(radio)
{
	level endon("intermission");
	while(!level.mapended)
	{
		wait 0.05;
		if(!radio.hidden)
		{
			players = getentarray("player", "classname");
			radio.allies = 0;
			radio.axis = 0;
			for(i = 0; i < players.size; i++)
			{
				if(isdefined(players[i].pers["team"]) && players[i].pers["team"] != "spectator" && players[i].sessionstate == "playing")
				{
					if(((distance(players[i].origin,radio.origin)) <= radio.radius) && (distance((0,0,players[i].origin[2]),(0,0,radio.origin[2])) <= level.zradioradius))
					{
						if(players[i].pers["team"] == radio.team)
							continue;

						if((level.captured_radios[players[i].pers["team"]] > 0) && (radio.team == "none"))
							continue;

						if((!isdefined(players[i].radioicon)) || (!isdefined(players[i].radioicon[0])))
						{
							players[i].radioicon[0] = newClientHudElem(players[i]);
							players[i].radioicon[0].x = 30;
							players[i].radioicon[0].y = 95;
							players[i].radioicon[0].alignX = "center";
							players[i].radioicon[0].alignY = "middle";
							players[i].radioicon[0].horzAlign = "left";
							players[i].radioicon[0].vertAlign = "top";
							players[i].radioicon[0] setShader("field_radio", 40, 32);
						}

						if((level.captured_radios[players[i].pers["team"]] <= 0) && (radio.team == "none"))
						{
							if(!isdefined(players[i].progressbar_capture))
							{
								players[i].progressbar_capture = newClientHudElem(players[i]);
								players[i].progressbar_capture.x = 0;

								if(level.splitscreen)
									players[i].progressbar_capture.y = 70;
								else
									players[i].progressbar_capture.y = 104;

								players[i].progressbar_capture.alignX = "center";
								players[i].progressbar_capture.alignY = "middle";
								players[i].progressbar_capture.horzAlign = "center_safearea";
								players[i].progressbar_capture.vertAlign = "center_safearea";
								players[i].progressbar_capture.alpha = 0.5;
							}
							players[i].progressbar_capture setShader("black", level.progressBarWidth, level.progressBarHeight);
							if(!isdefined(players[i].progressbar_capture2))
							{
								players[i].progressbar_capture2 = newClientHudElem(players[i]);
								players[i].progressbar_capture2.x = ((level.progressBarWidth / (-2)) + 2);

								if(level.splitscreen)
									players[i].progressbar_capture2.y = 70;
								else
									players[i].progressbar_capture2.y = 104;

								players[i].progressbar_capture2.alignX = "left";
								players[i].progressbar_capture2.alignY = "middle";
								players[i].progressbar_capture2.horzAlign = "center_safearea";
								players[i].progressbar_capture2.vertAlign = "center_safearea";
							}
							if(players[i].pers["team"] == "allies")
								players[i].progressbar_capture2 setShader("white", radio.holdtime_allies, level.progressBarHeight - 4);
							else
								players[i].progressbar_capture2 setShader("white", radio.holdtime_axis, level.progressBarHeight - 4);

							if(!isdefined(players[i].progressbar_capture3))
							{
								players[i].progressbar_capture3 = newClientHudElem(players[i]);
								players[i].progressbar_capture3.x = 0;

								if(level.splitscreen)
									players[i].progressbar_capture3.y = 16;
								else
									players[i].progressbar_capture3.y = 50;

								players[i].progressbar_capture3.alignX = "center";
								players[i].progressbar_capture3.alignY = "middle";
								players[i].progressbar_capture3.horzAlign = "center_safearea";
								players[i].progressbar_capture3.vertAlign = "center_safearea";
								players[i].progressbar_capture3.archived = false;
								players[i].progressbar_capture3.font = "default";
								players[i].progressbar_capture3.fontscale = 2;
								players[i].progressbar_capture3 settext(&"MP_ESTABLISHING_HQ");
							}
						}
						else if(radio.team != "none")
						{
							if(!isdefined(players[i].progressbar_capture))
							{
								players[i].progressbar_capture = newClientHudElem(players[i]);
								players[i].progressbar_capture.x = 0;

								if(level.splitscreen)
									players[i].progressbar_capture.y = 70;
								else
									players[i].progressbar_capture.y = 104;

								players[i].progressbar_capture.alignX = "center";
								players[i].progressbar_capture.alignY = "middle";
								players[i].progressbar_capture.horzAlign = "center_safearea";
								players[i].progressbar_capture.vertAlign = "center_safearea";
								players[i].progressbar_capture.alpha = 0.5;
							}
							players[i].progressbar_capture setShader("black", level.progressBarWidth, level.progressBarHeight);

							if(!isdefined(players[i].progressbar_capture2))
							{
								players[i].progressbar_capture2 = newClientHudElem(players[i]);
								players[i].progressbar_capture2.x = ((level.progressBarWidth / (-2)) + 2);

								if(level.splitscreen)
									players[i].progressbar_capture2.y = 70;
								else
									players[i].progressbar_capture2.y = 104;

								players[i].progressbar_capture2.alignX = "left";
								players[i].progressbar_capture2.alignY = "middle";
								players[i].progressbar_capture2.horzAlign = "center_safearea";
								players[i].progressbar_capture2.vertAlign = "center_safearea";
							}
							if(players[i].pers["team"] == "allies")
								players[i].progressbar_capture2 setShader("white", ((level.progressBarWidth - 4) - radio.holdtime_allies), level.progressBarHeight - 4);
							else
								players[i].progressbar_capture2 setShader("white", ((level.progressBarWidth - 4) - radio.holdtime_axis), level.progressBarHeight - 4);

							if(!isdefined(players[i].progressbar_capture3))
							{
								players[i].progressbar_capture3 = newClientHudElem(players[i]);
								players[i].progressbar_capture3.x = 0;

								if(level.splitscreen)
									players[i].progressbar_capture3.y = 16;
								else
									players[i].progressbar_capture3.y = 50;

								players[i].progressbar_capture3.alignX = "center";
								players[i].progressbar_capture3.alignY = "middle";
								players[i].progressbar_capture3.horzAlign = "center_safearea";
								players[i].progressbar_capture3.vertAlign = "center_safearea";
								players[i].progressbar_capture3.archived = false;
								players[i].progressbar_capture3.font = "default";
								players[i].progressbar_capture3.fontscale = 2;
								players[i].progressbar_capture3 settext(&"MP_DESTROYING_HQ");
							}

							if(radio.team == "allies")
							{
								if(!isdefined(level.progressbar_axis_neutralize))
								{
									level.progressbar_axis_neutralize = newTeamHudElem("allies");
									level.progressbar_axis_neutralize.x = 0;

									if(level.splitscreen)
										level.progressbar_axis_neutralize.y = 70;
									else
										level.progressbar_axis_neutralize.y = 104;

									level.progressbar_axis_neutralize.alignX = "center";
									level.progressbar_axis_neutralize.alignY = "middle";
									level.progressbar_axis_neutralize.horzAlign = "center_safearea";
									level.progressbar_axis_neutralize.vertAlign = "center_safearea";
									level.progressbar_axis_neutralize.alpha = 0.5;
								}
								level.progressbar_axis_neutralize setShader("black", level.progressBarWidth, level.progressBarHeight);

								if(!isdefined(level.progressbar_axis_neutralize2))
								{
									level.progressbar_axis_neutralize2 = newTeamHudElem("allies");
									level.progressbar_axis_neutralize2.x = ((level.progressBarWidth / (-2)) + 2);

									if(level.splitscreen)
										level.progressbar_axis_neutralize2.y = 70;
									else
										level.progressbar_axis_neutralize2.y = 104;

									level.progressbar_axis_neutralize2.alignX = "left";
									level.progressbar_axis_neutralize2.alignY = "middle";
									level.progressbar_axis_neutralize2.horzAlign = "center_safearea";
									level.progressbar_axis_neutralize2.vertAlign = "center_safearea";
									level.progressbar_axis_neutralize2.color = (.8,0,0);
								}
								if(players[i].pers["team"] == "allies")
									level.progressbar_axis_neutralize2 setShader("white", ((level.progressBarWidth - 4) - radio.holdtime_allies), level.progressBarHeight - 4);
								else
									level.progressbar_axis_neutralize2 setShader("white", ((level.progressBarWidth - 4) - radio.holdtime_axis), level.progressBarHeight - 4);

								if(!isdefined(level.progressbar_axis_neutralize3))
								{
									level.progressbar_axis_neutralize3 = newTeamHudElem("allies");
									level.progressbar_axis_neutralize3.x = 0;

									if(level.splitscreen)
										level.progressbar_axis_neutralize3.y = 16;
									else
										level.progressbar_axis_neutralize3.y = 50;

									level.progressbar_axis_neutralize3.alignX = "center";
									level.progressbar_axis_neutralize3.alignY = "middle";
									level.progressbar_axis_neutralize3.horzAlign = "center_safearea";
									level.progressbar_axis_neutralize3.vertAlign = "center_safearea";
									level.progressbar_axis_neutralize3.archived = false;
									level.progressbar_axis_neutralize3.font = "default";
									level.progressbar_axis_neutralize3.fontscale = 2;
									level.progressbar_axis_neutralize3 settext(&"MP_LOSING_HQ");
								}
							}
							else
							if(radio.team == "axis")
							{
								if(!isdefined(level.progressbar_allies_neutralize))
								{
									level.progressbar_allies_neutralize = newTeamHudElem("axis");
									level.progressbar_allies_neutralize.x = 0;

									if(level.splitscreen)
										level.progressbar_allies_neutralize.y = 70;
									else
										level.progressbar_allies_neutralize.y = 104;

									level.progressbar_allies_neutralize.alignX = "center";
									level.progressbar_allies_neutralize.alignY = "middle";
									level.progressbar_allies_neutralize.horzAlign = "center_safearea";
									level.progressbar_allies_neutralize.vertAlign = "center_safearea";
									level.progressbar_allies_neutralize.alpha = 0.5;
								}
								level.progressbar_allies_neutralize setShader("black", level.progressBarWidth, level.progressBarHeight);

								if(!isdefined(level.progressbar_allies_neutralize2))
								{
									level.progressbar_allies_neutralize2 = newTeamHudElem("axis");
									level.progressbar_allies_neutralize2.x = ((level.progressBarWidth / (-2)) + 2);

									if(level.splitscreen)
										level.progressbar_allies_neutralize2.y = 70;
									else
										level.progressbar_allies_neutralize2.y = 104;

									level.progressbar_allies_neutralize2.alignX = "left";
									level.progressbar_allies_neutralize2.alignY = "middle";
									level.progressbar_allies_neutralize2.horzAlign = "center_safearea";
									level.progressbar_allies_neutralize2.vertAlign = "center_safearea";
									level.progressbar_allies_neutralize2.color = (.8,0,0);
								}
								if(players[i].pers["team"] == "allies")
									level.progressbar_allies_neutralize2 setShader("white", ((level.progressBarWidth - 4) - radio.holdtime_allies), level.progressBarHeight - 4);
								else
									level.progressbar_allies_neutralize2 setShader("white", ((level.progressBarWidth - 4) - radio.holdtime_axis), level.progressBarHeight - 4);

								if(!isdefined(level.progressbar_allies_neutralize3))
								{
									level.progressbar_allies_neutralize3 = newTeamHudElem("axis");
									level.progressbar_allies_neutralize3.x = 0;

									if(level.splitscreen)
										level.progressbar_allies_neutralize3.y = 16;
									else
										level.progressbar_allies_neutralize3.y = 50;

									level.progressbar_allies_neutralize3.alignX = "center";
									level.progressbar_allies_neutralize3.alignY = "middle";
									level.progressbar_allies_neutralize3.horzAlign = "center_safearea";
									level.progressbar_allies_neutralize3.vertAlign = "center_safearea";
									level.progressbar_allies_neutralize3.archived = false;
									level.progressbar_allies_neutralize3.font = "default";
									level.progressbar_allies_neutralize3.fontscale = 2;
									level.progressbar_allies_neutralize3 settext(&"MP_LOSING_HQ");
								}
							}
						}

						if(players[i].pers["team"] == "allies")
							radio.allies++;
						else
							radio.axis++;

						players[i].inrange = true;
					}
					else if((isdefined(players[i].radioicon)) && (isdefined(players[i].radioicon[0])))
					{
						if((isdefined(players[i].radioicon)) || (isdefined(players[i].radioicon[0])))
							players[i].radioicon[0] destroy();
						if(isdefined(players[i].progressbar_capture))
							players[i].progressbar_capture destroy();
						if(isdefined(players[i].progressbar_capture2))
							players[i].progressbar_capture2 destroy();
						if(isdefined(players[i].progressbar_capture3))
							players[i].progressbar_capture3 destroy();

						players[i].inrange = undefined;
					}
				}
			}

			if(radio.team == "none") // Radio is captured if no enemies around
			{
				if((radio.allies > 0) && (radio.axis <= 0) && (radio.team != "allies"))
				{
					radio.holdtime_allies = int(.667 + (radio.holdtime_allies + (radio.allies * level.MultipleCaptureBias)));

					if(radio.holdtime_allies >= (level.progressBarWidth - 4))
					{
						if((level.captured_radios["allies"] > 0) && (radio.team != "none"))
							level hq_radio_capture(radio, "none");
						else if(level.captured_radios["allies"] <= 0)
							level hq_radio_capture(radio, "allies");
					}
				}
				else if((radio.axis > 0) && (radio.allies <= 0) && (radio.team != "axis"))
				{
					radio.holdtime_axis = int(.667 + (radio.holdtime_axis + (radio.axis * level.MultipleCaptureBias)));

					if(radio.holdtime_axis >= (level.progressBarWidth - 4))
					{
						if((level.captured_radios["axis"] > 0) && (radio.team != "none"))
							level hq_radio_capture(radio, "none");
						else if(level.captured_radios["axis"] <= 0)
							level hq_radio_capture(radio, "axis");
					}
				}
				else
				{
					radio.holdtime_allies = 0;
					radio.holdtime_axis = 0;

					players = getentarray("player", "classname");
					for(i = 0; i < players.size; i++)
					{
						if(isdefined(players[i].pers["team"]) && players[i].pers["team"] != "spectator" && players[i].sessionstate == "playing")
						{
							if(((distance(players[i].origin,radio.origin)) <= radio.radius) && (distance((0,0,players[i].origin[2]),(0,0,radio.origin[2])) <= level.zradioradius))
							{
								if(isdefined(players[i].progressbar_capture))
									players[i].progressbar_capture destroy();
								if(isdefined(players[i].progressbar_capture2))
									players[i].progressbar_capture2 destroy();
								if(isdefined(players[i].progressbar_capture3))
									players[i].progressbar_capture3 destroy();
							}
						}
					}
				}
			}
			else // Radio should go to neutral first
			{
				if((radio.team == "allies") && (radio.axis <= 0))
				{
					if(isdefined(level.progressbar_axis_neutralize))
						level.progressbar_axis_neutralize destroy();
					if(isdefined(level.progressbar_axis_neutralize2))
						level.progressbar_axis_neutralize2 destroy();
					if(isdefined(level.progressbar_axis_neutralize3))
						level.progressbar_axis_neutralize3 destroy();
				}
				else if((radio.team == "axis") && (radio.allies <= 0))
				{
					if(isdefined(level.progressbar_allies_neutralize))
						level.progressbar_allies_neutralize destroy();
					if(isdefined(level.progressbar_allies_neutralize2))
						level.progressbar_allies_neutralize2 destroy();
					if(isdefined(level.progressbar_allies_neutralize3))
						level.progressbar_allies_neutralize3 destroy();
				}

				if((radio.allies > 0) && (radio.team == "axis"))
				{
					radio.holdtime_allies = int(.667 + (radio.holdtime_allies + (radio.allies * level.MultipleCaptureBias)));
					if(radio.holdtime_allies >= (level.progressBarWidth - 4))
						level hq_radio_capture(radio, "none");
				}
				else if((radio.axis > 0) && (radio.team == "allies"))
				{
					radio.holdtime_axis = int(.667 + (radio.holdtime_axis + (radio.axis * level.MultipleCaptureBias)));
					if(radio.holdtime_axis >= (level.progressBarWidth - 4))
						level hq_radio_capture(radio, "none");
				}
				else
				{
					radio.holdtime_allies = 0;
					radio.holdtime_axis = 0;
				}
			}
		}
	}
}

hq_radio_capture(radio, team)
{
	radio.holdtime_allies = 0;
	radio.holdtime_axis = 0;

	players = getentarray("player", "classname");
	for(i = 0; i < players.size; i++)
	{
		players[i].WaitingOnTimer = undefined;
		players[i].WaitingOnNeutralize = undefined;
		if(isdefined(players[i].pers["team"]) && players[i].pers["team"] != "spectator" && players[i].sessionstate == "playing")
		{
			if((isdefined(players[i].radioicon)) && (isdefined(players[i].radioicon[0])))
			{
				players[i].radioicon[0] destroy();
				if(isdefined(players[i].progressbar_capture))
					players[i].progressbar_capture destroy();
				if(isdefined(players[i].progressbar_capture2))
					players[i].progressbar_capture2 destroy();
				if(isdefined(players[i].progressbar_capture3))
					players[i].progressbar_capture3 destroy();
			}
		}
	}

	if(radio.team != "none")
	{
		level.captured_radios[radio.team] = 0;
		playfx(level._effect["radioexplosion"], radio.origin);
		level.timesCaptured = 0;
		// Print some text
		if(radio.team == "allies")
		{
			if(getTeamCount("axis") && !level.splitscreen)
				iprintln(&"MP_SHUTDOWN_ALLIED_HQ");

			if(isdefined(level.progressbar_axis_neutralize))
				level.progressbar_axis_neutralize destroy();
			if(isdefined(level.progressbar_axis_neutralize2))
				level.progressbar_axis_neutralize2 destroy();
			if(isdefined(level.progressbar_axis_neutralize3))
				level.progressbar_axis_neutralize3 destroy();
		}
		else if(radio.team == "axis")
		{
			if(getTeamCount("allies") && !level.splitscreen)
				iprintln(&"MP_SHUTDOWN_AXIS_HQ");

			if(isdefined(level.progressbar_allies_neutralize))
				level.progressbar_allies_neutralize destroy();
			if(isdefined(level.progressbar_allies_neutralize2))
				level.progressbar_allies_neutralize2 destroy();
			if(isdefined(level.progressbar_allies_neutralize3))
				level.progressbar_allies_neutralize3 destroy();
		}
	}

	if(radio.team == "none")
		radio playsound("explo_plant_no_tick");

	NeutralizingTeam = undefined;
	if(radio.team == "allies")
		NeutralizingTeam = "axis";
	else if(radio.team == "axis")
		NeutralizingTeam = "allies";
	radio.team = team;

	level notify("Radio State Changed");

	if(team == "none")
	{
		// RADIO GOES NEUTRAL
		radio setmodel(game["radio_model"]);
		radio hide();
		radio.hidden = true;

		radio playsound("explo_radio");
		if(isdefined(NeutralizingTeam))
		{
			if(NeutralizingTeam == "allies")
				level thread playSoundOnPlayers("mp_announcer_axishqdest");
			else if(NeutralizingTeam == "axis")
				level thread playSoundOnPlayers("mp_announcer_alliedhqdest");
		}

		objective_delete(0);
		thread maps\mp\gametypes\_objpoints::removeObjpoints();
		level.DefendingRadioTeam = "none";
		level notify("Radio Neutralized");

		//give some points to the neutralizing team
		if(isdefined(NeutralizingTeam))
		{
			if((NeutralizingTeam == "allies") || (NeutralizingTeam == "axis"))
			{
				if(getTeamCount(NeutralizingTeam))
				{
					setTeamScore(NeutralizingTeam, getTeamScore(NeutralizingTeam) + level.NeutralizingPoints);
					level notify("update_allhud_score");

					if(!level.splitscreen)
					{
						if(NeutralizingTeam == "allies")
							iprintln(&"MP_SCORED_ALLIES", level.NeutralizingPoints);
						else
							iprintln(&"MP_SCORED_AXIS", level.NeutralizingPoints);
					}
				}
			}
		}

		//give all the alive players that are alive full health
		players = getentarray("player", "classname");
		for(i = 0; i < players.size; i++)
		{
			if(isdefined(players[i].pers["team"]) && players[i].sessionstate == "playing")
			{
				players[i].maxhealth = 100;
				players[i].health = players[i].maxhealth;
			}
		}

		level thread hq_removehudelem_allplayers(radio);
	}
	else
	{
		// RADIO CAPTURED BY A TEAM
		level.captured_radios[team] = 1;
		level.DefendingRadioTeam = team;

		if(team == "allies")
		{
			if(!level.splitscreen)
				iprintln(&"MP_SETUP_HQ_ALLIED");

			if(game["allies"] == "british")
				alliedsound = "UK_mp_hqsetup";
			else if(game["allies"] == "russian")
				alliedsound = "RU_mp_hqsetup";
			else
				alliedsound = "US_mp_hqsetup";

			level thread playSoundOnPlayers(alliedsound, "allies");
			if(!level.splitscreen)
				level thread playSoundOnPlayers("GE_mp_enemyhqsetup", "axis");
		}
		else
		{
			if(!level.splitscreen)
				iprintln(&"MP_SETUP_HQ_AXIS");

			if(game["allies"] == "british")
				alliedsound = "UK_mp_enemyhqsetup";
			else if(game["allies"] == "russian")
				alliedsound = "RU_mp_enemyhqsetup";
			else
				alliedsound = "US_mp_enemyhqsetup";

			level thread playSoundOnPlayers("GE_mp_hqsetup", "axis");
			if(!level.splitscreen)
				level thread playSoundOnPlayers(alliedsound, "allies");
		}

		//give all the alive players that are now defending the radio full health
		players = getentarray("player", "classname");
		for(i = 0; i < players.size; i++)
		{
			if(isdefined(players[i].pers["team"]) && players[i].pers["team"] == level.DefendingRadioTeam && players[i].sessionstate == "playing")
			{
				players[i].maxhealth = 100;
				players[i].health = players[i].maxhealth;
			}
		}

		level thread hq_maxholdtime_think();
	}

	objective_icon(0, (game["radio_" + team ]));
	objective_team(0, "none");

	objteam = "none";
	if((level.captured_radios["allies"] <= 0) && (level.captured_radios["axis"] > 0))
		objteam = "allies";
	else if((level.captured_radios["allies"] > 0) && (level.captured_radios["axis"] <= 0))
		objteam = "axis";

	// Make all neutral radio objectives go to the right team
	for(i = 0; i < level.radio.size; i++)
	{
		if(level.radio[i].hidden == true)
			continue;
		if(level.radio[i].team == "none")
			objective_team(0, objteam);
	}

	level notify("finish_staydead");

	level thread hq_obj_think(radio);
}

hq_maxholdtime_think()
{
	level endon("Radio State Changed");
	assert(level.RadioMaxHoldSeconds > 2);
	if(level.RadioMaxHoldSeconds > 0)
		wait(level.RadioMaxHoldSeconds - 0.05);
	level thread hq_radio_resetall();
}

hq_points()
{
	while(!level.mapended)
	{
		if(level.DefendingRadioTeam != "none")
		{
			if(getTeamCount(level.DefendingRadioTeam))
			{
				setTeamScore(level.DefendingRadioTeam, getTeamScore(level.DefendingRadioTeam) + 1);
				level notify("update_allhud_score");
				checkScoreLimit();
			}
		}
		wait 1;
	}
}

hq_radio_resetall()
{
	// Find the radio that is in play
	radio = undefined;
	for(i = 0; i < level.radio.size; i++)
	{
		if(level.radio[i].hidden == false)
			radio = level.radio[i];
	}

	if(!isdefined(radio))
		return;

	radio.holdtime_allies = 0;
	radio.holdtime_axis = 0;

	players = getentarray("player", "classname");
	for(i = 0; i < players.size; i++)
	{
		players[i].WaitingOnTimer = undefined;
		players[i].WaitingOnNeutralize = undefined;
		if(isdefined(players[i].pers["team"]) && players[i].pers["team"] != "spectator" && players[i].sessionstate == "playing")
		{
			if((isdefined(players[i].radioicon)) && (isdefined(players[i].radioicon[0])))
			{
				players[i].radioicon[0] destroy();
				if(isdefined(players[i].progressbar_capture))
					players[i].progressbar_capture destroy();
				if(isdefined(players[i].progressbar_capture2))
					players[i].progressbar_capture2 destroy();
				if(isdefined(players[i].progressbar_capture3))
					players[i].progressbar_capture3 destroy();
			}
		}
	}

	if(radio.team != "none")
	{
		level.captured_radios[radio.team] = 0;

		playfx(level._effect["radioexplosion"], radio.origin);
		level.timesCaptured = 0;

		localizedTeam = undefined;
		if(radio.team == "allies")
		{
			localizedTeam = (&"MP_UPTEAM");
			if(isdefined(level.progressbar_axis_neutralize))
				level.progressbar_axis_neutralize destroy();
			if(isdefined(level.progressbar_axis_neutralize2))
				level.progressbar_axis_neutralize2 destroy();
			if(isdefined(level.progressbar_axis_neutralize3))
				level.progressbar_axis_neutralize3 destroy();
		}
		else if(radio.team == "axis")
		{
			localizedTeam = (&"MP_DOWNTEAM");
			if(isdefined(level.progressbar_allies_neutralize))
				level.progressbar_allies_neutralize destroy();
			if(isdefined(level.progressbar_allies_neutralize2))
				level.progressbar_allies_neutralize2 destroy();
			if(isdefined(level.progressbar_allies_neutralize3))
				level.progressbar_allies_neutralize3 destroy();
		}

		minutes = 0;
		maxTime = level.RadioMaxHoldSeconds;
		while(maxTime >= 60)
		{
			minutes++;
			maxTime -= 60;
		}
		seconds = maxTime;
		if((minutes > 0) && (seconds > 0))
			iprintlnbold(&"MP_MAXHOLDTIME_MINUTESANDSECONDS", localizedTeam, minutes, seconds);
		else
		if((minutes > 0) && (seconds <= 0))
			iprintlnbold(&"MP_MAXHOLDTIME_MINUTES", localizedTeam);
		else
		if((minutes <= 0) && (seconds > 0))
			iprintlnbold(&"MP_MAXHOLDTIME_SECONDS", localizedTeam, seconds);
	}

	radio.team = "none";
	level.DefendingRadioTeam = "none";
	objective_team(0, "none");

	radio setmodel(game["radio_model"]);
	radio hide();

	if(!level.mapended)
	{
		radio playsound("explo_radio");
		level thread playSoundOnPlayers("mp_announcer_hqdefended");
	}

	radio.hidden = true;
	objective_delete(0);
	thread maps\mp\gametypes\_objpoints::removeObjpoints();

	level.graceperiod = false;
	level thread hq_obj_think(radio);
	level thread hq_removehudelem_allplayers(radio);

	// All dead people should now respawn
	players = getentarray("player", "classname");
	for(i = 0; i < players.size; i++)
	{
		players[i].WaitingOnTimer = undefined;
		players[i].WaitingOnNeutralize = undefined;
	}

	level notify("finish_staydead");
}

hq_removeall_hudelems(player)
{
	if(isdefined(self))
	{
		for(i = 0; i < level.radio.size; i++)
		{
			if((isdefined(player.radioicon)) && (isdefined(player.radioicon[0])))
				player.radioicon[0] destroy();
			if(isdefined(player.progressbar_capture))
				player.progressbar_capture destroy();
			if(isdefined(player.progressbar_capture2))
				player.progressbar_capture2 destroy();
			if(isdefined(player.progressbar_capture3))
				player.progressbar_capture3 destroy();
		}
	}
}

hq_removehudelem_allplayers(radio)
{
	players = getentarray("player", "classname");
	for(i = 0; i < players.size; i++)
	{
		if(!isdefined(players[i]))
			continue;
		if((isdefined(players[i].radioicon)) && (isdefined(players[i].radioicon[0])))
			players[i].radioicon[0] destroy();
		if(isdefined(players[i].progressbar_capture))
			players[i].progressbar_capture destroy();
		if(isdefined(players[i].progressbar_capture2))
			players[i].progressbar_capture2 destroy();
		if(isdefined(players[i].progressbar_capture3))
			players[i].progressbar_capture3 destroy();
	}
}

hq_check_teams_exist()
{
	players = getentarray("player", "classname");
	level.alliesexist = false;
	level.axisexist = false;
	for(i = 0; i < players.size; i++)
	{
		if(!isdefined(players[i].pers["team"]) || players[i].pers["team"] == "spectator")
			continue;
		if(players[i].pers["team"] == "allies")
			level.alliesexist = true;
		else if(players[i].pers["team"] == "axis")
			level.axisexist = true;

		if(level.alliesexist && level.axisexist)
			return;
	}
}

updateTeamStatus()
{
	level.exist["allies"] = 0;
	level.exist["axis"] = 0;

	players = getentarray("player", "classname");
	for(i = 0; i < players.size; i++)
	{
		if(isdefined(players[i].pers["team"]) && players[i].pers["team"] != "spectator" && players[i].sessionstate == "playing")
			level.exist[players[i].pers["team"]]++;
	}
}

restartRound()
{
	if(level.roundStarted)
	{
		iprintln(&"MP_MATCHRESUMING");
		return;
	}
	else
	{
		iprintln(&"MP_MATCHSTARTING");
		wait 5;
	}

	players = getentarray("player", "classname");
	for(i = 0; i < players.size; i++)
	{
		player = players[i];

		if(isdefined(player.pers["team"]) && (player.pers["team"] == "allies" || player.pers["team"] == "axis"))
		{
		    player.score = 0;
		    player.deaths = 0;

			player spawnPlayer();
		}
	}
}

menuAutoAssign()
{
	if(!level.xenon && isdefined(self.pers["team"]) && (self.pers["team"] == "allies" || self.pers["team"] == "axis"))
	{
		self openMenu(game["menu_team"]);
		return;
	}
	
	numonteam["allies"] = 0;
	numonteam["axis"] = 0;

	players = getentarray("player", "classname");
	for(i = 0; i < players.size; i++)
	{
		player = players[i];

		if(!isdefined(player.pers["team"]) || player.pers["team"] == "spectator")
			continue;

		numonteam[player.pers["team"]]++;
	}

	// if teams are equal return the team with the lowest score
	if(numonteam["allies"] == numonteam["axis"])
	{
		if(getTeamScore("allies") == getTeamScore("axis"))
		{
			teams[0] = "allies";
			teams[1] = "axis";
			assignment = teams[randomInt(2)];	// should not switch teams if already on a team
		}
		else if(getTeamScore("allies") < getTeamScore("axis"))
			assignment = "allies";
		else
			assignment = "axis";
	}
	else if(numonteam["allies"] < numonteam["axis"])
		assignment = "allies";
	else
		assignment = "axis";

	if(assignment == self.pers["team"] && (self.sessionstate == "playing" || self.sessionstate == "dead"))
	{
	    if(!isdefined(self.pers["weapon"]))
	    {
		    if(self.pers["team"] == "allies")
			    self openMenu(game["menu_weapon_allies"]);
		    else
			    self openMenu(game["menu_weapon_axis"]);
	    }

		return;
	}

	if(assignment != self.pers["team"] && (self.sessionstate == "playing" || self.sessionstate == "dead"))
	{
		self.switching_teams = true;
		self.joining_team = assignment;
		self.leaving_team = self.pers["team"];
		self suicide();
	}

	self.pers["team"] = assignment;
	self.pers["weapon"] = undefined;
	self.pers["savedmodel"] = undefined;

	self setClientCvar("ui_allow_weaponchange", "1");

	if(self.pers["team"] == "allies")
	{
		self openMenu(game["menu_weapon_allies"]);
		self setClientCvar("g_scriptMainMenu", game["menu_weapon_allies"]);
	}
	else
	{
		self openMenu(game["menu_weapon_axis"]);
		self setClientCvar("g_scriptMainMenu", game["menu_weapon_axis"]);
	}

	self notify("joined_team");
	self notify("end_respawn");
}

menuAllies()
{
	if(self.pers["team"] != "allies")
	{
		if(!level.xenon && !maps\mp\gametypes\_teams::getJoinTeamPermissions("allies"))
		{
			self openMenu(game["menu_team"]);
			return;
		}

		if(self.sessionstate == "playing")
		{
			self.switching_teams = true;
			self.joining_team = "allies";
			self.leaving_team = self.pers["team"];
			self suicide();
		}

		self.pers["team"] = "allies";
		self.pers["weapon"] = undefined;
		self.pers["savedmodel"] = undefined;

		self setClientCvar("ui_allow_weaponchange", "1");
		self setClientCvar("g_scriptMainMenu", game["menu_weapon_allies"]);

		self notify("joined_team");
		self notify("end_respawn");
	}

	if(!isdefined(self.pers["weapon"]))
		self openMenu(game["menu_weapon_allies"]);
}

menuAxis()
{
	if(self.pers["team"] != "axis")
	{
		if(!level.xenon && !maps\mp\gametypes\_teams::getJoinTeamPermissions("axis"))
		{
			self openMenu(game["menu_team"]);
			return;
		}

		if(self.sessionstate == "playing")
		{
			self.switching_teams = true;
			self.joining_team = "axis";
			self.leaving_team = self.pers["team"];
			self suicide();
		}

		self.pers["team"] = "axis";
		self.pers["weapon"] = undefined;
		self.pers["savedmodel"] = undefined;

		self setClientCvar("ui_allow_weaponchange", "1");
		self setClientCvar("g_scriptMainMenu", game["menu_weapon_axis"]);

		self notify("joined_team");
		self notify("end_respawn");
	}

	if(!isdefined(self.pers["weapon"]))
		self openMenu(game["menu_weapon_axis"]);
}

menuSpectator()
{
	if(self.pers["team"] != "spectator")
	{
		if(isAlive(self))
		{
			self.switching_teams = true;
			self.joining_team = "spectator";
			self.leaving_team = self.pers["team"];
			self suicide();
		}

		self.pers["team"] = "spectator";
		self.pers["weapon"] = undefined;
		self.pers["savedmodel"] = undefined;

		self.sessionteam = "spectator";
		self setClientCvar("ui_allow_weaponchange", "0");

		self thread updateTimer();

		spawnSpectator();

		if(level.splitscreen)
			self setClientCvar("g_scriptMainMenu", game["menu_ingame_spectator"]);
		else
			self setClientCvar("g_scriptMainMenu", game["menu_ingame"]);

		self notify("joined_spectators");
		self notify("end_respawn");
	}
}

menuWeapon(response)
{
	if(!isdefined(self.pers["team"]) || (self.pers["team"] != "allies" && self.pers["team"] != "axis"))
		return;

	weapon = self maps\mp\gametypes\_weapons::restrictWeaponByServerCvars(response);

	if(weapon == "restricted")
	{
		if(self.pers["team"] == "allies")
			self openMenu(game["menu_weapon_allies"]);
		else if(self.pers["team"] == "axis")
			self openMenu(game["menu_weapon_axis"]);

		return;
	}

	if(level.splitscreen)
		self setClientCvar("g_scriptMainMenu", game["menu_ingame_onteam"]);
	else
		self setClientCvar("g_scriptMainMenu", game["menu_ingame"]);

	if(isdefined(self.pers["weapon"]) && self.pers["weapon"] == weapon)
		return;

	if(!isdefined(self.pers["weapon"]))
	{
		self.pers["weapon"] = weapon;

		if(isdefined(self.WaitingOnTimer) || ((self.pers["team"] == level.DefendingRadioTeam) && isdefined(self.WaitingOnNeutralize)))
		{
			self thread respawn();
			self thread updateTimer();
		}
		else
			spawnPlayer();

		self thread printJoinedTeam(self.pers["team"]);
	}
	else
	{
		self.pers["weapon"] = weapon;

		weaponname = maps\mp\gametypes\_weapons::getWeaponName(self.pers["weapon"]);

		if(maps\mp\gametypes\_weapons::useAn(self.pers["weapon"]))
			self iprintln(&"MP_YOU_WILL_RESPAWN_WITH_AN", weaponname);
		else
			self iprintln(&"MP_YOU_WILL_RESPAWN_WITH_A", weaponname);
	}

	self thread maps\mp\gametypes\_spectating::setSpectatePermissions();
}

respawn_timer(delay)
{
	self endon("disconnect");

	self.WaitingOnTimer = true;

	if(level.respawndelay > 0)
	{
		if(!isdefined(self.respawntimer))
		{
			self.respawntimer = newClientHudElem(self);
			self.respawntimer.x = 0;
			self.respawntimer.y = -50;
			self.respawntimer.alignX = "center";
			self.respawntimer.alignY = "middle";
			self.respawntimer.horzAlign = "center_safearea";
			self.respawntimer.vertAlign = "center_safearea";
			self.respawntimer.alpha = 0;
			self.respawntimer.archived = false;
			self.respawntimer.font = "default";
			self.respawntimer.fontscale = 2;
			self.respawntimer.label = (&"MP_TIME_TILL_SPAWN");
			self.respawntimer setTimer(level.respawndelay + delay);
		}

		wait delay;
		self thread updateTimer();

		wait level.respawndelay;

		if(isdefined(self.respawntimer))
			self.respawntimer destroy();
	}

	self.WaitingOnTimer = undefined;
}

respawn_staydead(delay)
{
	self endon("disconnect");

	if(isdefined(self.WaitingOnNeutralize))
		return;
	self.WaitingOnNeutralize = true;

	if(!isdefined(self.staydead))
	{
		self.staydead = newClientHudElem(self);
		self.staydead.x = 0;
		self.staydead.y = -50;
		self.staydead.alignX = "center";
		self.staydead.alignY = "middle";
		self.staydead.horzAlign = "center_safearea";
		self.staydead.vertAlign = "center_safearea";
		self.staydead.alpha = 0;
		self.staydead.archived = false;
		self.staydead.font = "default";
		self.staydead.fontscale = 2;
		self.staydead setText(&"MP_RESPAWN_WHEN_RADIO_NEUTRALIZED");
	}

	self thread delayUpdateTimer(delay);
	level waittill("finish_staydead");

	if(isdefined(self.staydead))
		self.staydead destroy();

	if(isdefined(self.respawntimer))
		self.respawntimer destroy();

	self.WaitingOnNeutralize = undefined;
}

delayUpdateTimer(delay)
{
	self endon("disconnect");

	wait delay;
	thread updateTimer();
}

updateTimer()
{
	if(isdefined(self.pers["team"]) && (self.pers["team"] == "allies" || self.pers["team"] == "axis") && isdefined(self.pers["weapon"]))
	{
		if((isdefined(self.pers["team"])) && (self.pers["team"] == level.DefendingRadioTeam))
		{
			if(isdefined(self.respawntimer))
				self.respawntimer.alpha = 0;

			if(isdefined(self.staydead))
				self.staydead.alpha = 1;
		}
		else
		{
			if(isdefined(self.respawntimer))
				self.respawntimer.alpha = 1;

			if(isdefined(self.staydead))
				self.staydead.alpha = 0;
		}
	}
	else
	{
		if(isdefined(self.respawntimer))
			self.respawntimer.alpha = 0;

		if(isdefined(self.staydead))
			self.staydead.alpha = 0;
	}
}

playSoundOnPlayers(sound, team)
{
	players = getentarray("player", "classname");

	if(level.splitscreen)
	{
		if(isdefined(players[0]))
			players[0] playLocalSound(sound);
	}
	else
	{
		if(isdefined(team))
		{
			for(i = 0; i < players.size; i++)
			{
				if((isdefined(players[i].pers["team"])) && (players[i].pers["team"] == team))
					players[i] playLocalSound(sound);
			}
		}
		else
		{
			for(i = 0; i < players.size; i++)
				players[i] playLocalSound(sound);
		}
	}
}

getTeamCount(team)
{
	count = 0;

	players = getentarray("player", "classname");
	for(i = 0; i < players.size; i++)
	{
		player = players[i];

		if(isdefined(player.pers["team"]) && (player.pers["team"] == team))
			count++;
	}

	return count;
}
