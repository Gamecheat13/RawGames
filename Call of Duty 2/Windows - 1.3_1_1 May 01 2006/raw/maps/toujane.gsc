#include maps\_utility;
#include maps\_anim;
main()
{
	setExpFog(0.00015, 131/255, 116/255, 116/255, 0);
	setCullDist (4000);

	if (getcvar ("start") == "")
		setcvar ("start", "start");
	
	if (getcvar ("start") != "start")
	{
		trigs = getentarray ("trigger_at_playerSpawn","script_noteworthy");
		for (i=0;i<trigs.size;i++)
			trigs[i] thread triggerOff();
	}
	
	// Backdrop
	backdrop = spawn("script_model", (0,0,185) );
	backdrop setmodel("xmodel/backdrop_toujane_card");
	backdrop2 = spawn("script_model", (0,0,-450) );
	backdrop2 setmodel("xmodel/backdrop_toujane_frntmntn");
	backdrop3 = spawn("script_model", (1153, 3526, 1338) );
	backdrop3.angles = (0, 324, 0);
	backdrop3 setmodel("xmodel/backdrop_toujane_frnthill");
	
	level.cos80 = cos(80);
	
	level.maxfriendlies = 5;
	level.friendlyMethod = "friendly chains";
	level.friendlywave_thread = maps\toujane::friendlyMethod;
	
	level.windStrength = 1.0;
	level.GermansTakeMosque_alive = 0;
	level.GermansTakeMosque_maxAlive = 7;
	flag_clear("ladder_failed");
	flag_clear("all tanks dead");
	flag_clear("skip_followme_animation");
	flag_clear("skip_followme_dialogue");
	flag_clear("player_jumped_crack");
	flag_clear("convoy_deaths");
	flag_clear("mission_end");
	
	maps\_tankai::main();
	maps\_tankai_crusader::main("xmodel/vehicle_crusader2");
	maps\_panzer2::main("xmodel/vehicle_panzer_ii");
	maps\_crusader::main("xmodel/vehicle_crusader2");
	maps\_flak88::main("xmodel/german_artillery_flak88");
	maps\_jeep::main("xmodel/vehicle_africa_jeep_can");
	maps\_unicarrier::main("xmodel/vehicle_uni_carrier_yw");
	maps\_sherman::main("xmodel/vehicle_american_sherman_desert");
	maps\_tankai_sherman::main("xmodel/vehicle_american_sherman_desert");
	maps\_truck::main("xmodel/vehicle_opel_blitz_desert");
	
	maps\toujane_fx::main();
	maps\_load::main();
	maps\toujane_anim::main();
	
	if (getcvar ("toujane_hints") == "")
		setcvar ("toujane_hints", "off");
	if (level.xenon)
		setcvar ("toujane_hints", "off");
	
	if (getcvar ("toujane_hints") == "on")
	{
		level.hud_repeat_rate = 7.8;
		
		precacheString(&"TOUJANE_HINT_STAR");
		level.strings["objective_hint"] 			= spawnstruct();
		level.strings["objective_hint"].text		= &"TOUJANE_HINT_STAR";
		
		precacheString(&"TOUJANE_PLATFORM_HINT_OBJECTIVES");
		level.strings["objectives"] 				= spawnstruct();
		level.strings["objectives"].text			= &"TOUJANE_PLATFORM_HINT_OBJECTIVES";
		
		precacheString(&"TOUJANE_HINT_NONLINEAR");
		level.strings["nonlinear"] 					= spawnstruct();
		level.strings["nonlinear"].text				= &"TOUJANE_HINT_NONLINEAR";
		level.strings["nonlinear"].alignY = "bottom";
		
		if (level.gameSkill <= 1)
	    	setcvar( "takeCoverWarnings", 5 );
	    else
		if (level.gameSkill == 2)
	    	setcvar( "takeCoverWarnings", 3 );
	    else
		if (level.gameSkill >= 3)
	    	setcvar( "takeCoverWarnings", 2 );
	    	
		thread nonlinear_hint();
	}
	
	thread maps\_waypoint::init();
	thread maps\_groupmove::main();
	
	precacheModel("xmodel/wall_tank_pieces");
	precacheModel("xmodel/wall_tank_broke");
	precacheItem("panzerfaust");
	precacheShader("objective");
	if(isdefined(level.setHudElmHintBackground) && level.setHudElmHintBackground == true)
		precacheshader("popmenu_bg");
	
	precacheString(&"TOUJANE_OBJ_HARDPOINTS");
	precacheString(&"TOUJANE_OBJ_OP");
	precacheString(&"TOUJANE_OBJ_FLAKCREWS");
	precacheString(&"TOUJANE_OBJ_FLAKCREWS_DONE");
	precacheString(&"TOUJANE_OBJ_MOSQUE");
	precacheString(&"TOUJANE_OBJ_REGROUPBALCONY");
	
	level.dialogueDone["Objective Spotted"] = false;
	level.EndingMusicFinished = false;
	level.AutoSaveIndex = 1;
	level.ObjectiveFinished["Flak88"] = false;
	level.breakingEnts = [];
	level.flags["ladder fell"] = false;
	level.flags["mosque tanks remaining"] = 2;
	level.flags["Breakable Boxes"] = true;
	
	level.friendly_mosque_nodes = getnodearray ("friendly_mosque_node","targetname");
	level.friendly_mosque_nodes_index = 0;
	
	level.flankTimer["0"] = 0.05;
	level.flankTimer["1"] = 0.05;
	level.flankTimer["2"] = 0.05;
	level.flankTimer["3"] = 0.05;
	level.flankTimer["4"] = 0.05;
	level.flankTimer["5"] = 0.05;
	
	flag_clear("mosque_tank1_dead");
	
	level.player.isOnMG42 = false;
	
	//delete entact section of tunnel in this level
	tunnel_before = getentarray("tunnel_before","targetname");
	for (i=0;i<tunnel_before.size;i++)
		tunnel_before[i] delete();
	
	if (getcvar ("start") == "start")
	{
		Intro_Tanks_Setup();
		level SetupCharacters();
		
		level thread Intro_Tankkiller();
		level thread Intro_SetupPlayer(level.thirdtank);
		level thread dialogue_RidingOnTank();
		level thread dialogue_Flak88();
		level thread Plant_Explosives_Wait();
		level thread dialogue_UseSmokeGrenade();
		level thread dialogue_ObjectiveSpotted();
		level thread dialogue_Observation();
		level thread dialogue_IncommingTruck();
		level thread dialogue_FriendlyTanksArrive();
		level thread dialogue_Tank1Destroyed_Panzerfaust();
		level thread dialogue_Tank2Destroyed_Panzerfaust();
		level thread dialogue_FirstFlak88Spotted();
		level thread dialogue_SecondFlak88Spotted();
		level thread dialogue_ThirdFlak88Spotted();
		level thread dialogue_FourthFlak88Spotted();
		level thread dialogue_MG_SecondFlak88();
		level thread Objective_ClearCity();
		//level thread music_intro();
		level thread breakwall();
		level thread first_enemy_tank_think();
		level thread balcony_spawner();
		level thread observation_ladder();
		level thread blow_up_flak();
		level thread hayland();
		level thread axis_truck_badplace();
		level thread walltanks_allow_breakCrates();
		level thread panzerguys_shoot_walltank1();
		level thread panzerguys_shoot_walltank2();
		level thread gate_trigger_flak2();
		level thread gate_trigger_flak3();
		level thread ladder_climber_lookat_trigger();
		
		level.OPLadderBrush = getent ("ladder_usebrush","targetname");
		level.OPLadderBrush.workingOrigin = level.OPLadderBrush.origin;
		level.OPLadderBrush.origin = (level.OPLadderBrush.origin + (0,0,100000));
		level.OPLadderBrushDisableTraverse = getent ("brush_to_disable_ladder_traverse","targetname");
		level.OPLadderBrushDisableTraverse disconnectpaths();
	}
	
	level thread maps\toujane_amb::main();
	level array_thread (getspawnerarray(), ::spawners_tweak);
	level array_thread (getentarray("toujane_autosave","targetname"), ::autosave_triggers);
	level array_thread (getentarray("friendlychain_delete_on_use","script_noteworthy"), ::friendlychain_delete);
	array_thread (getentarray("flak objective","targetname"), ::flak_sounds);
	
	getent ("mosque_spawners","targetname") thread triggerOff();
	getent ("firstalleyspawntrigger","targetname") thread triggerOff();
	getent ("roof_friendly_chain","script_noteworthy") thread triggerOff();
	
	trigs = getentarray("first_spawn_triggers","script_noteworthy");
	for (i=0;i<trigs.size;i++)
		trigs[i] thread triggerOff();
	
	wait 0.05;
	
	//JUMP TO DEFEND THE MOSQUE
	if (getcvar ("start") == "mosque")
	{
		level.player setOrigin (getent("jumpto_defendmosque_player","targetname").origin);
		level.player setplayerangles (getent("jumpto_defendmosque_player","targetname").angles);
		
		level array_thread (getaiarray ("allies"), ::friendlyMethod);
		level remove_vehicle_blockers();
		level thread Objective_Mosque();
	}
	
	if (getcvar ("start") == "convoy")
	{
		level.player setOrigin ( (614, 6081, 415) );
		level.player setPlayerAngles ( (0, 90, 0) );
		
		level array_thread (getaiarray ("allies"), ::friendlyMethod);
		level remove_vehicle_blockers();
		
		thread convoy_start();
	}
}

convoy_start()
{
	getent("convoy_start_trigger","targetname") notify ("trigger");
	
	convoy_axis = getentarray("convoy_axis","targetname");
	convoy_escape_node = getnodearray("convoy_escape_node","targetname");
	
	axis = getaiarray("axis");
	for( i = 0 ; i < axis.size ; i++ )
	{
		if (!isdefined(axis[i]))
			continue;
		axis[i] delete();
	}
	
	for( i = 0 ; i < convoy_axis.size ; i++ )
	{
		guy = convoy_axis[i] doSpawn();
		if (spawn_failed(guy))
			continue;
		guy.health = 50;
		guy.goalradius = 512;
		guy.pathenemyfightdist = 64;
		guy.pathenemylookahead = 64;
		runawayNode = undefined;
		runawayNode = convoy_escape_node[getClosestIndex(convoy_axis[i].origin, convoy_escape_node)];
		assert(isdefined(runawayNode));
		guy thread convoy_runaway(runawayNode);
	}
	
	wait 0.05;
	
	spawners = getspawnerarray();
	for( i = 0 ; i < spawners.size ; i++ )
	{
		if (!isdefined(spawners[i]))
			continue;
		if ( (isdefined(spawners[i].script_friendname)) && (spawners[i].script_friendname == "Pvt. MacGregor") )
			continue;
		spawners[i] delete();
	}
	
	thread endmacgregor_spawn();
	wait 5;
	thread ending_dialogue();
	flag_wait("mission_end");
	maps\_endmission::nextmission();
}

convoy_guy_forcedeath()
{
	self endon ("death");
	flag_wait("convoy_deaths");
	wait randomfloat(2);
	if (!isdefined(self))
		return;
	if (!isalive(self))
		return;
	self dodamage(self.health + 1, self.origin);
}

convoy_runaway(runawayNode)
{
	self endon ("death");
	self thread convoy_guy_forcedeath();
	wait (5 + randomfloat(4));
	if ( (!isdefined(self)) || (!isalive(self)) )
		return;
	self setgoalnode(runawayNode);
	wait (3 + randomfloat(4));
	if ( (!isdefined(self)) || (!isalive(self)) )
		return;
	self dodamage(self.health + 1, self.origin);
}

ending_dialogue()
{
	level notify ("stop_macspawner");
	
	level Battlechatter_Allies("off");
	
	//grab 2 soldiers
	bs1 = undefined;
	bs4 = undefined;
	
	allies = getaiarray("allies");
	for( i = 0 ; i < allies.size ; i++ )
	{
		if ( (isdefined(allies[i].script_friendname)) && (allies[i].script_friendname == "Pvt. MacGregor") )
			continue;
		if (!isdefined(bs1))
		{
			bs1 = allies[i];
			bs1 thread magic_bullet_shield();
			bs1.animname = "soldier";
		}
		if (!isdefined(bs4))
		{
			bs4 = allies[i];
			bs4 thread magic_bullet_shield();
			bs4.animname = "soldier";
		}
		if (!isdefined(level.macgregor))
		{
			level.macgregor = allies[i];
			level.macgregor thread magic_bullet_shield();
			level.macgregor.animname = "soldier";
		}	
	}
	
	assert(isdefined(bs1));
	assert(isdefined(bs4));
	assert(isdefined(level.macgregor));
	
	//"Our reinforcements have arrived!!"
	bs4 anim_single_solo (bs4, "toujane_bs4_arrived");
	
	musicplay("toujane_end_music");
	
	//"We've got the bastards on the run! Don't let up!!!"
	bs1 anim_single_solo (bs1, "toujane_bs1_gotthebastards");
	
	wait 5;
	flag_set("convoy_deaths");
	
	//"Tell Rommel you've been beat by the boys of the 7th Armored!"
	level.macgregor anim_single_solo (level.macgregor, "toujane_mcg_tellrommel");
	
	//"And come back any time, you Jerry bastards! We'll be waiting for you!"
	bs4 anim_single_solo (bs4, "toujane_bs4_comebackanytime");
	
	wait 4;
	
	//"Looks like that's the last of the huns, eh Davis?"
	level.macgregor anim_single_solo (level.macgregor, "toujane_mcg_lastofthehuns");
	
	wait 2;
	
	flag_set("mission_end");
}

endmacgregor_spawn()
{
	level endon ("stop_macspawner");
	spawners = getentarray("macgregor_mosque","script_noteworthy");
	assert(isdefined(spawners));
	assert(spawners.size == 2);
	
	level.macgregor = undefined;
	index = 0;
	for (;;)
	{
		index++;
		if (index > 1)
			index = 0;
		
		level.macgregor = spawners[index] doSpawn();
		if (!spawn_failed(level.macgregor))
		{
			level.macgregor thread magic_bullet_shield();
			level.macgregor thread dialogue_LevelEnd_goToPlayer();
			level.macgregor.animname = "soldier";
			return;
		}
		wait 0.05;
	}
}

dialogue_LevelEnd_goToPlayer()
{
	self.goalradius = 96;
	for (;;)
	{
		self setgoalpos (level.player.origin);
		wait 1;
	}
}

flak_sounds()
{
	self endon ("spawntriggered");
	for (;;)
	{
		wait (4 + randomfloat(3));
		self playSoundInSpace("flak88_fire");
	}
}

Allies_All_IgnoreMe(sBool)
{
	ai = getaiarray("allies");
	for (i=0;i<ai.size;i++)
	{
		if (sBool == true)
		{
			ai[i].starting_maxsightdistsqrd = ai[i].maxsightdistsqrd;
			ai[i].maxsightdistsqrd = 0;
		}
		else
		{
			ai[i].maxsightdistsqrd = ai[i].starting_maxsightdistsqrd;
			ai[i].starting_maxsightdistsqrd = undefined;
		}
		ai[i].ignoreme = sBool;
	}
}

Intro_Tanks_Setup()
{
	thread Intro_Tanks_Setup_Wait("leadtank");
	thread Intro_Tanks_Setup_Wait("secondtank");
	thread Intro_Tanks_Setup_Wait("thirdtank");
	
	tanksSetup = 0;
	while (tanksSetup < 3)
	{
		level waittill ("tank setup");
		tanksSetup++;
	}
}

Intro_Tanks_Setup_Wait(targetname)
{
	if (targetname == "leadtank")
	{
		level.leadtank = maps\_vehicle::waittill_vehiclespawn("leadtank");
		level.leadtank.allowUnloadIfAttacked = false;
		level.leadtank thread Intro_LeadTank_Death();
	}
	else if (targetname == "secondtank")
	{
		level.secondtank = maps\_vehicle::waittill_vehiclespawn("secondtank");
		level.secondtank.allowUnloadIfAttacked = false;
		level.secondtank.health = 100000000;
	}
	else if (targetname == "thirdtank")
	{
		level.thirdtank = maps\_vehicle::waittill_vehiclespawn("thirdtank");
		level.thirdtank.allowUnloadIfAttacked = false;
		level.thirdtank.health = 100000000;
	}
	level notify ("tank setup");
}

SetupCharacters()
{
	level.Soldier1 = undefined;
	level.Soldier2 = undefined;
	
	allies = getaiarray("allies");
	//level.totalfriends = allies.size;
	for (alliesIndex=0;alliesIndex<allies.size;alliesIndex++)
	{
		allies[alliesIndex] thread animscripts\shared::SetInCombat(false);
		if (isdefined (allies[alliesIndex].script_noteworthy))
		{
			if (allies[alliesIndex].script_noteworthy == "soldier1")
			{
				level.Soldier1 = allies[alliesIndex];
				level.Soldier1.animname = "soldier1";
				continue;
			}
			else if (allies[alliesIndex].script_noteworthy == "soldier2")
			{
				level.Soldier2 = allies[alliesIndex];
				level.Soldier2.animname = "soldier2";
				continue;
			}
			else if (allies[alliesIndex].script_noteworthy == "lead tank rider")
			{
				allies[alliesIndex].maxsightdistsqrd = 0;
				allies[alliesIndex].ignoreme = true;
				continue;
			}
		}
		allies[alliesIndex].health = (5 + randomint (15));
	}
	
	assertEX(isdefined(level.Soldier1), "Soldier1 isn't being defined");
	assertEX(isdefined(level.Soldier2), "Soldier2 isn't being defined");
	
	level thread Allies_All_IgnoreMe(true);
}

Intro_Tankkiller()
{	
	flak = getent ("tankdestroyer","targetname");
	flak.health = 1000000;
	getent ("killtank","targetname") waittill ("trigger");
	
	flak setTurretTargetEnt( level.leadtank, (0, 0, 32));
	wait 5;
	level.secondtank.health = 100000000;
	level.thirdtank.health = 100000000;
	//flak FireTurret();
	flak clearTurretTarget();
	
	TankFireSound = spawn("script_origin",level.leadtank.origin);
	level.leadtank notify ("death", flak);
	
	trigs = getentarray("first_spawn_triggers","script_noteworthy");
	for (i=0;i<trigs.size;i++)
	{
		trigs[i] thread triggerOn();
		trigs[i] notify ("trigger");
	}
	
	level thread Allies_All_IgnoreMe(false);
	
	//level.leadtank notify ("death");
	level notify ("intro music stop");
	musicStop();
	TankFireSound playloopsound ("medfire");
	
	//kill guys walking with the tank also..
	allies = getaiarray ("allies");
	for (i=0;i<allies.size;i++)
	{
		if ( (isdefined (allies[i].WalkingTank)) && (allies[i].WalkingTank == level.leadtank) )
			allies[i] doDamage ( allies[i].health + 50, (0,0,0) );
	}
	
	level notify ("tank blew up");
	level thread dialogue_Ambient();
	
	//stop the other tanks in the convoy
	wait 0.5;
	level.secondtank notify ("stop moving");
	level.secondtank setSpeed(0,1000);
	level.secondtank notify ("unload");
	//wait 0.5;
	level.thirdtank notify ("stop moving");
	level.thirdtank setSpeed(0,1000);
	level.thirdtank notify ("unload");
	level notify ("player_tank_stopped");
	
	level Battlechatter_Allies("on");
	
	wait 2;
	level array_thread (getaiarray ("allies"), ::friendlyMethod);
	wait 5;
	level array_thread (getaiarray ("allies"), ::friendlyMethod);
}

Intro_LeadTank_Death()
{
	self waittill ("death");
	level thread array_thread (getaiarray("allies"), ::setInCombat);
}

Intro_SetupPlayer(tank)
{
	wait 0.05;
	//put the player on the tank
	level.player.angles = (0,-45,0);
	level.player setorigin (tank getTagOrigin ("tag_playerride"));
	level.player playerLinkToDelta (tank, "tag_playerride", 0.85);
	
	//Player can only crouch on the tank
	level.player allowLeanLeft(false);
	level.player allowLeanRight(false);
	level.player allowProne(false);
	level.player allowCrouch(false);
	
	level.player setplayerangles ( tank gettagAngles ("tag_playerride") );
	level waittill ("player_tank_stopped");
	getent ("firstalleyspawntrigger","targetname") thread triggerOn();
	wait 1;
	
	dummy = spawn("script_origin", level.thirdtank gettagOrigin("tag_playerride"));
	dummy.angles = level.player.angles;
	level.player playerLinkToDelta (dummy);
	dummy moveto (level.thirdtank gettagOrigin("tag_detach"), .5, .2, .2);
	wait .5;
	level.player unlink();
	
	level notify ("dismounted tank");
	
	//give some controls back to the player
	level.player allowLeanLeft(true);
	level.player allowLeanRight(true);
	level.player allowProne(true);
	level.player allowCrouch(true);
	
	wait 2;
	
	autosave(level.AutoSaveIndex);
	level.AutoSaveIndex++;
}

autosave_triggers()
{
	self waittill ("trigger");
	autosave(level.AutoSaveIndex);
	level.AutoSaveIndex++;
}

dialogue_Thread(dialogue)
{
	if (!isdefined (self.magic_bullet_shield))
	{
		self.health_before_dialogue = self.health;
		self.health = 1000000;
	}
	self.animname = "soldier";
	
	facial = undefined;	
	
	level anim_single_solo(self, dialogue);
	
	if ( (!isdefined (self.magic_bullet_shield)) && (isdefined (self.health_before_dialogue)) )
	{
		self.health = self.health_before_dialogue;
		self.health_before_dialogue = undefined;
	}
}

dialogue_RidingOnTank()
{
	level Battlechatter_Allies("off");
	wait 0.5;
	level notify ("finished intro screen");
	wait 6;
	
	level.Soldier1 thread dialogue_RidingOnTank_Soldier1();
	level.Soldier2 thread dialogue_RidingOnTank_Soldier2();
	
	level waittill ("tank ride dialogue done");
	
	if (getcvar ("toujane_hints") == "on")
	{
		special_hint("objective", "objective_hint", 20, 0, 10, 60, 180);
		add_hudelm_hint(level.strings["objectives"], undefined, level.hud_repeat_rate);
	}
}

dialogue_RidingOnTank_Soldier1()
{
	self setBattleChatter(false);
	
	tag_origin = self.RidingTank getTagOrigin (self.tankride_tag);
	tag_angles = self.RidingTank getTagAngles (self.tankride_tag);
	
	self.playingCustomAnim = true;
	
	self animscripted("tank_dialogue_anim", tag_origin, tag_angles, level.scr_anim["soldier1"]["tankride_dialogue_body"]);
	
	//"You hear that Norman has been sent home?"
	self waittillmatch ("tank_dialogue_anim", "dialogue_01");
	self thread animscripts\face::SaySpecificdialogue(undefined, level.scrsound["soldier1"]["toujane_macgregor_normansenthome"], 1.0);
	
	//"That “lucky bastard” lost his leg."
	self waittillmatch ("tank_dialogue_anim", "dialogue_02");
	self thread animscripts\face::SaySpecificdialogue(undefined, level.scrsound["soldier1"]["toujane_macgregor_losthisleg"], 1.0);
	
	//self waittill("animscript facedone");
	self waittillmatch ("tank_dialogue_anim", "end");
	
	self.playingCustomAnim = undefined;
	self thread maps\_tankai::loop_riding_anim(self.RidingTank);
	
	self setBattleChatter(true);
}

dialogue_RidingOnTank_Soldier2()
{
	self setBattleChatter(false);
	
	tag_origin = self.RidingTank getTagOrigin (self.tankride_tag);
	tag_angles = self.RidingTank getTagAngles (self.tankride_tag);
	
	self.playingCustomAnim = true;
	
	self animscripted("tank_dialogue_anim", tag_origin, tag_angles, level.scr_anim["soldier2"]["tankride_dialogue_body"]);
	
	//"Lucky bastard."
	self waittillmatch ("tank_dialogue_anim", "dialogue_01");
	self thread animscripts\face::SaySpecificdialogue(undefined, level.scrsound["soldier2"]["toujane_bs2_luckybastard"], 1.0);
	
	//"Well at least he’s out of this bleeding desert."
	self waittillmatch ("tank_dialogue_anim", "dialogue_02");
	self thread animscripts\face::SaySpecificdialogue(undefined, level.scrsound["soldier2"]["toujane_bs2_atleastoutofdesert"], 1.0);
	
	self waittillmatch ("tank_dialogue_anim", "end");
	level notify ("tank ride dialogue done");
	self.playingCustomAnim = undefined;
	self thread maps\_tankai::loop_riding_anim(self.RidingTank);
	
	self setBattleChatter(true);
}

dialogue_Flak88()
{	
	wait 0.05;
	level waittill ("tank blew up");
	wait 1.5;
	
	//"Gordon Bennett! What was that!?"
	exclude = [];
	guy1 = undefined;
	guy1 = getaiarray("allies") findClosestToPlayer();
	if (isdefined (guy1))
	{
		guy1 dialogue_Thread("toujane_bs3_gordonbennettwhat");
		exclude[exclude.size] = guy1;
	}
	else
	
	//"Flak 88 dead ahead! Get off the tank!"
	guy2 = undefined;
	guy2 = getaiarray("allies") findClosestToPlayer(exclude);
	if (isdefined (guy2))
	{
		guy2 dialogue_Thread("toujane_bs2_flakdeadahead");
		exclude[0] = guy2;
	}
	
	wait 1;
	
	//"Flank that 88! Go!"
	guy3 = undefined;
	guy3 = getaiarray("allies") findClosestToPlayer(exclude);
	if (isdefined (guy3))
	guy3 dialogue_Thread("toujane_macgregor_flankthatgo");
	
	level Battlechatter_Allies("on");
}

dialogue_PlantExplosives()
{	
	if (!isdefined (level.tommy))
		return;
	
	level Battlechatter_Allies("off");
	
	//"Tommy! Disable that flak with your explosives and let’s go!"
	exclude[0] = level.tommy;
	guy = undefined;
	for (i=0;i<5;i++)
	{
		guy = getaiarray("allies") findClosestToPlayer(exclude);
		if (isdefined (guy))
		{
			guy dialogue_Thread("toujane_macgregor_disableflakexplosives");
			break;
		}
		wait 1;
	}
	
	//"Alright Mac! I'm on it!"
	level.tommy dialogue_Thread("toujane_bs1_imonit");
	
	level Battlechatter_Allies("on");
}

dialogue_UseSmokeGrenade()
{
	trig = undefined;
	ents = getentarray ("trigger_multiple","classname");
	for (i=0;i<ents.size;i++)
	{
		if (!isdefined (ents[i].script_noteworthy))
			continue;
		if (ents[i].script_noteworthy == "Dialogue_MG42")
		{
			trig = ents[i];
			break;
		}
	}
	assertEX(isdefined(trig),"MG42 trigger not being defined...might have been changed to something other than a trigger_multiple which would cause this script to not catch it");
	
	mg42 = undefined;
	ents = getentarray ("misc_turret","classname");
	for (i=0;i<ents.size;i++)
	{
		if (!isdefined (ents[i].script_noteworthy))
			continue;
		if (ents[i].script_noteworthy == "Dialogue_MG42")
		{
			mg42 = ents[i];
			break;
		}
	}
	assertEX(isdefined(mg42),"MG42 not found for dialogue");
	
	trig waittill ("trigger");
	
	//wait until someone has gotten onto the mg42
	owner = mg42 getturretowner();
	while (!isdefined (owner))
	{
		wait 1;
		owner = mg42 getturretowner();
	}
	
	level Battlechatter_Allies("off");
	
	wait 2.5;
	
	//"MG42! Use a smoke grenade!"
	guy = undefined;
	for (i=0;i<5;i++)
	{
		guy = getaiarray("allies") findClosestToPlayer();
		if (isdefined (guy))
		{
			guy dialogue_Thread("toujane_macgregor_useasmokegrenade");
			break;
		}
		wait 1;
	}
	
	level Battlechatter_Allies("on");
}

dialogue_ObjectiveSpotted()
{
	getent ("observation spawners","targetname") waittill ("trigger");
	wait 3;
	level Battlechatter_Allies("off");
	exclude = [];
	
	//"Oi! Look there! Jerries on the roof of that building!"
	guy = getaiarray("allies") findClosestToPlayer();
	if (isdefined (guy))
	{
		guy dialogue_Thread("toujane_macgregor_jerriesontheroof");
		exclude[0] = guy;
	}
	
	//"I think they are using it as their forward observation point."
	guy1 = undefined;
	guy1 = getaiarray("allies") findClosestToPlayer(exclude);
	if (isdefined (guy1))
		guy1 dialogue_Thread("toujane_bs4_forwardobservation");
	
	level.dialogueDone["Objective Spotted"] = true;
	level Battlechatter_Allies("on");
}

dialogue_Observation()
{
	trigger = getent ("approaching observation","targetname");
	for (;;)
	{
		trigger waittill ("trigger", other);
		if (other == level.player)
			break;
	}
	
	level thread Objective_ClearObservation();
	
	//make sure the building hasn't been cleared before giving this dialogue
	buildingCleared = true;
	axis = getaiarray ("axis");
	for (i=0;i<axis.size;i++)
	{
		if (axis[i] isTouching(trigger))
		{
			buildingCleared = false;
			break;
		}
	}
	
	if (buildingCleared)
		return;
	
	while (!level.dialogueDone["Objective Spotted"])
		wait 1;
	
	level Battlechatter_Allies("off");
	
	wait 2;
	
	//"Tom is right! The Jerries are using that building as a forward ob. We’ve got to capture it."
	guy = undefined;
	for (i=0;i<4;i++)
	{
		guy = getaiarray("allies") findClosestToPlayer();
		if (isdefined (guy))
		{
			guy dialogue_Thread("toujane_macgregor_captureit");
			break;
		}
		wait 1;
	}
	
	level Battlechatter_Allies("on");
}

dialogue_IncommingTruck()
{
	getent ("incomming_truck","targetname") waittill ("trigger");
	
	level Battlechatter_Allies("off");
	
	//Jerries in that truck! Coming this way!
	guy1 = undefined;
	guy1 = getaiarray("allies") findClosestToPlayer();
	if (isdefined (guy1))
		guy1 dialogue_Thread("toujane_bs4_jerriesintruck");
	
	level Battlechatter_Allies("on");
}

dialogue_FriendlyTanksArrive()
{
	getent ("friendlytanks_arrived","targetname") waittill ("trigger");
	
	//delete old friendly tanks
	if (isdefined (level.secondtank))
		level.secondtank delete();
	if (isdefined (level.thirdtank))
		level.thirdtank delete();
	
	level Battlechatter_Allies("off");
	
	//Look out it’s a tank!
	exclude = [];
	guy1 = undefined;
	guy1 = getaiarray("allies") findClosestToPlayer();
	if (isdefined (guy1))
	{
		guy1 dialogue_Thread("toujane_bs1_lookouttank");
		exclude[0] = guy1;
	}
	
	//Oi! Those are our tanks!
	guy2 = undefined;
	guy2 = getaiarray("allies") findClosestToPlayer(exclude);
	if (isdefined (guy2))
		guy2 dialogue_Thread("toujane_macgregor_oiourtanks");
	
	//Hurry lads! Our tanks are waiting for us to clear the 88s!
	guy3 = undefined;
	guy3 = getaiarray("allies") findClosestToPlayer();
	if (isdefined (guy3))
		guy3 dialogue_Thread("toujane_macgregor_hurrylads");
	
	level Battlechatter_Allies("on");
}

dialogue_Tank1Destroyed_Panzerfaust()
{
	level waittill ("panzer guys about to kill tank1");
	
	level Battlechatter_Allies("off");
	
	//"Jerry with a panzerschreck!"
	guy1 = undefined;
	guy1 = getaiarray("allies") findClosestToPlayer();
	if (isdefined (guy1))
		guy1 dialogue_Thread("toujane_bs1_panzershreck");
	
	//wait until tank dies
	level waittill ("panzer guys shot at tank1");
	
	wait 2;
	
	//"The bastard destroyed out tank!"
	exclude = [];
	if (isdefined (guy1))
		exclude[0] = guy1;
	guy2 = undefined;
	guy2 = getaiarray("allies") findClosestToPlayer(exclude);
	if (isdefined (guy2))
		guy2 dialogue_Thread("toujane_bs2_bastarddestroyed");
	
	level Battlechatter_Allies("on");
}

dialogue_Tank2Destroyed_Panzerfaust()
{
	//wait until tank dies
	level waittill ("panzer guys shot at tank2");
	
	level Battlechatter_Allies("off");
	
	guy = undefined;
	guy = getaiarray("allies") findClosestToPlayer();
	if (isdefined (guy))
		guy dialogue_Thread("toujane_macgregor_damngother");
	wait 4;
	guy = undefined;
	guy = getaiarray("allies") findClosestToPlayer();
	if (isdefined (guy))
		guy dialogue_Thread("toujane_macgregor_withouttanksupport");
	
	level Battlechatter_Allies("on");
}

dialogue_FirstFlak88Spotted()
{
	trig = getent ("first_flak88_spotted","targetname");
	trig waittill ("trigger", other);
	
	level Battlechatter_Allies("off");
	
	//There’s another 88!
	guy = undefined;
	if (other != level.player)
		guy = other;
	else
		guy = getaiarray("allies") findClosestToPlayer();
	
	if (isdefined (guy))
		guy dialogue_Thread("toujane_macgregor_another88");
	
	level Battlechatter_Allies("on");
}

dialogue_SecondFlak88Spotted()
{
	trig = getent ("second_flak88_spotted","targetname");
	for (;;)
	{
		trig waittill ("trigger", other);
		if (other == level.player)
			break;
		wait 0.05;
	}
	
	level Battlechatter_Allies("off");
	
	//88! Destroy it!
	guy1 = undefined;
	guy1 = getaiarray("allies") findClosestToPlayer();
	if (isdefined (guy1))
		guy1 dialogue_Thread("toujane_bs4_88destroyit");
	
	level Battlechatter_Allies("on");
}

dialogue_ThirdFlak88Spotted()
{
	trig = getent ("third_flak88_spotted","targetname");
	for (;;)
	{
		trig waittill ("trigger", other);
		if (other == level.player)
			break;
		wait 0.05;
	}
	
	level Battlechatter_Allies("off");
	
	//Blow up that 88!
	guy1 = undefined;
	guy1 = getaiarray("allies") findClosestToPlayer();
	if (isdefined (guy1))
		guy1 dialogue_Thread("toujane_bs1_blowupthat88");
	
	level Battlechatter_Allies("on");
}

dialogue_FourthFlak88Spotted()
{
	trig = getent ("fourth_flak88_spotted","targetname");
	for (;;)
	{
		trig waittill ("trigger", other);
		if ( (other == level.Soldier2) || (other == level.player) )
			break;
		wait 0.05;
	}
	
	level Battlechatter_Allies("off");
	
	//88! We’ve got destroy it.
	guy1 = undefined;
	guy1 = getaiarray("allies") findClosestToPlayer();
	if (isdefined (guy1))
		guy1 dialogue_Thread("toujane_bs2_88destroyit");
	
	level Battlechatter_Allies("on");
}

dialogue_MG_SecondFlak88()
{
	trig = getent ("mg_at_second_flak88","targetname");
	mg42 = getent ("mg_at_second_flak88","script_noteworthy");
	for (;;)
	{
		trig waittill ("trigger", other);
		if ( (other == level.Soldier2) || (other == level.player) )
			break;
		wait 0.05;
	}
	
	//wait until someone has gotten onto the mg42
	for (;;)
	{
		owner = mg42 getturretowner();
		if ( (isdefined (owner)) && (owner.team == "axis") )
			break;
		wait 0.25;
	}
	
	level Battlechatter_Allies("off");
	
	wait .5;
	
	//MG! Enemy MG nest!
	exclude = [];
	guy1 = undefined;
	guy1 = getaiarray("allies") findClosestToPlayer();
	if (isdefined (guy1))
	{
		exclude[0] = guy1;
		guy1 dialogue_Thread("toujane_bs2_enemymgnest");
	}
	
	//Grenade it!
	guy2 = undefined;
	guy2 = getaiarray("allies") findClosestToPlayer(exclude);
	if (isdefined (guy2))
		guy2 dialogue_Thread("toujane_macgregor_grenadeit");
	
	level Battlechatter_Allies("on");
}

dialogue_CaptureMosque()
{
	level Battlechatter_Allies("off");
	
	wait 2;
	
	//Davis, some Fritz are holed up in the mosque! Let’s get the bastards!
	guy1 = undefined;
	for (i=0;i<10;i++)
	{
		guy1 = getaiarray("allies") findClosestToPlayer();
		if (isdefined (guy1))
		{
			guy1 dialogue_Thread("toujane_macgregor_jerriesholedup");
			break;
		}
		wait 1;
	}
	
	getent ("dialogue_mosque_area","targetname") waittill ("trigger");
	level thread dialogue_CaptureMosque_Cancel();
	
	level endon ("inside the mosque");
	wait 10;
	
	//Into the mosque! On the double!
	guy1 = undefined;
	for (i=0;i<10;i++)
	{
		guy1 = getaiarray("allies") findClosestToPlayer();
		if (isdefined (guy1))
		{
			level notify ("go in mosque dialogue started");
			guy1 dialogue_Thread("toujane_macgregor_intothemosque");
			break;
		}
		wait 1;
	}
	level notify ("go in mosque dialogue started");
	
	level Battlechatter_Allies("on");
}

dialogue_CaptureMosque_Cancel()
{
	level endon ("go in mosque dialogue started");
	getent ("dialogue_mosque_area_inside","targetname") waittill ("trigger");
	level notify ("inside the mosque");
}

dialogue_CapturedMosque()
{
	level Battlechatter_Allies("off");
	
	//That’s done it! No more Fritz! The mosque is ours
	guy = undefined;
	for (i=0;i<5;i++)
	{
		guy = getaiarray("allies") findClosestToPlayer();
		if (isdefined (guy))
		{
			guy dialogue_Thread("toujane_macgregor_timetorest");
			break;
		}
		wait 1;
	}
	level Battlechatter_Allies("on");
}

dialogue_LevelEnd()
{
	level thread Battlechatter_Allies("off");
	
	level endon ("mission end failsafe");
	thread dialogue_LevelEnd_failsafe();
	
	while(!isdefined(level.macgregor))
		wait 0.05;
	level.macgregor waittill ("goal");
	level notify ("mission end non failsafe");
	level.macgregor dialogue_Thread("toujane_macgregor_bloodycrazywar");
	flag_set("end_dialogue_done");
}

dialogue_LevelEnd_failsafe()
{
	level endon ("mission end non failsafe");
	wait 10;
	level notify ("mission end failsafe");
	if ( (isdefined(level.macgregor)) && (isalive(level.macgregor)) )
		guy = level.macgregor;
	else
		guy = getaiarray("allies") findClosestToPlayer();
	
	guy dialogue_Thread("toujane_macgregor_bloodycrazywar");
	flag_set("end_dialogue_done");
}

Mosque_MG42s_MinitorPlayerUsage()
{
	level.player endon ("death");
	level.player endon ("stop monitoring mg42 usage");
	
	mg42 = getent ("mosque_mg","script_noteworthy");
	
	for (;;)
	{
		//check gun to see if the player is on it
		owner = mg42 getturretowner();
		if ( (isdefined (owner)) && (owner == level.player) )
		{
			level.player.isOnMG42 = true;
			level.player notify ("on mg42");
		}
		else
		{
			level.player.isOnMG42 = false;
			level.player notify ("off mg42");
		}
		wait 1;
	}
}

dialogue_Ambient()
{
	level endon ("area secure");
	ents = getentarray("ambient dialogue","targetname");
	
	for (;;)
	{
		for (i=1;i<12;i++)
		{
			soundEnt = ents findClosestToPlayer();
			soundEnt playsound ("elm_ge_idlechatter" + i);
			wait (8 + randomint(15));
		}
	}
}

Objective_ClearCity()
{
	wait 7;
	location = getent ("objective1","targetname");
	objective_add(1, "active", &"TOUJANE_OBJ_HARDPOINTS", location.origin);
	objective_current(1);
}

Objective_ClearObservation()
{
	location = getent ("objective2","targetname");
	objective_state(1,"done"); 
	objective_add(2, "active", &"TOUJANE_OBJ_OP", location.origin);
	objective_current(2);
	
	level thread Objective_ClearObservation_Trig();
	
	level endon ("flak88 objective started");
	
	wait 1;
	area = getent ("approaching observation","targetname");
	for (;;)
	{
		axis = getaiarray("axis");
		guys = [];
		for (i=0;i<axis.size;i++)
		{
			if (!axis[i] istouching (area))
				continue;
			guys[guys.size] = axis[i];
		}
		if (guys.size == 0)
			break;
		waittill_dead (guys, 1);
	}
	
	getent ("onroof","targetname") waittill ("trigger");
	level thread Objective_ClearObservation_Done();
}

Objective_ClearObservation_Trig()
{
	level endon ("flak88 objective started");
	trig = getent ("objective_op_done","targetname");
	if (!isdefined (trig))
		return;
	
	trig waittill ("trigger");
	level thread Objective_ClearObservation_Done();
}

Objective_ClearObservation_Done()
{
	level notify ("flak88 objective started");
	
	level thread maps\_spawner::kill_spawnerNum(1);
	level thread maps\_spawner::kill_spawnerNum(2);
	
	objective_state(2,"done");
	level thread Objective_Flak88s();
	
	level notify ("area secure");
	level thread Kill_Germans_NotAtObservation();
	
	wait 1;
	autosave(level.AutoSaveIndex);
	level.AutoSaveIndex++;
}

Objective_Flak88s()
{
	level.flak_objectives = getentarray ("flak objective","targetname");
	level.flaksRemaining = level.flak_objectives.size;
	objective_add(3, "active", &"TOUJANE_OBJ_FLAKCREWS_DONE", level.flak_objectives[0].origin);
	objective_string_nomessage(3, &"TOUJANE_OBJ_FLAKCREWS", level.flaksRemaining);
	
	for (i=0;i<level.flak_objectives.size;i++)
		level.flak_objectives[i] thread Objective_Flak88s_Think(i);
	objective_current(3);
}

Objective_Flak88s_Think(index)
{
	if (index != 0)
		objective_additionalposition(3, index, self.origin);
	self thread Objective_Flak88s_Autosaves();
	self waittill_any ("death","crew dead");
	//self waittill ("crew dead");
	objective_additionalposition(3, index, (0,0,0));
	level.flaksRemaining--;
	
	level thread delayed_autosave(2.0);
	
	objective_string(3, &"TOUJANE_OBJ_FLAKCREWS", level.flaksRemaining);
	if (level.flaksRemaining <= 0)
	{
		objective_string(3, &"TOUJANE_OBJ_FLAKCREWS_DONE");
		objective_state(3,"done");
		level thread remove_vehicle_blockers();
		level thread Objective_Mosque();
		level thread Kill_Germans_NotAtMosque();
	}	
}

delayed_autosave(delayTime)
{
	wait (delayTime);
	autosave(level.AutoSaveIndex);
	level.AutoSaveIndex++;
}

remove_vehicle_blockers()
{
	//remove the vehicle blocker stuff to give the player more access to the mosque
	vehicle_blocker = getentarray ("vehicle_blocker","targetname");
	vehicle_blocker_clip = getent ("vehicle_blocker_clip","targetname");
	for (i=0;i<vehicle_blocker.size;i++)
		vehicle_blocker[i] delete();
	vehicle_blocker_clip connectpaths();
	vehicle_blocker_clip delete();
}

Objective_Flak88s_Autosaves()
{
	self waittill_any("death","bomb planted");
	autosave(level.AutoSaveIndex);
	level.AutoSaveIndex++;
}

Objective_Mosque()
{
	mosque = getent ("objective_mosque","targetname");
	trig = getent ("mosque_spawners","targetname");
	trig thread triggerOn();
	
	objective_add(5,"active",&"TOUJANE_OBJ_MOSQUE",mosque.origin);
	objective_current(5);
	level thread maps\_spawner::kill_spawnerNum(8);
	level.friendlyMethod = "mosque node";
	level array_thread (getaiarray ("allies"), ::friendlyMethod);
	
	level thread dialogue_CaptureMosque();
	
	trig waittill ("trigger");
	wait 0.05;
	
	//get all guys in the mosque and wait until they are dead
	axis = getaiarray("axis");
	area = getent ("mosque_area","targetname");
	guys = [];
	for (i=0;i<axis.size;i++)
	{
		if (!axis[i] istouching (area))
			continue;
		guys[guys.size] = axis[i];
	}
	waittill_dead (guys);
	
	//mosque guys are dead...
	objective_state(5,"done");
	
	wait 1;
	
	//player should now get the speach before the counter attack
	objective_add(6,"active",&"TOUJANE_OBJ_REGROUPBALCONY",mosque.origin);
	objective_current(6);
	getent ("mosque_objective_area","targetname") waittill ("trigger");
	objective_state(6,"done");
	
	autosave(level.AutoSaveIndex);
	level.AutoSaveIndex++;
	
	level dialogue_CapturedMosque();
	
	thread convoy_start();
}

German_Tank_Think(delay)
{
	self endon ("death");
	self endon ("stop think");
	
	if (isdefined (delay))
		wait (delay);
	
	while (self.health > 0)
	{
		randomOffsetX = randomint(100);
		randomOffsetY = randomint(100);
		randomOffsetZ = (50 + randomint(50));
		
		if (randomint(2) == 0)
			randomOffsetX = (randomOffsetX * -1);
		if (randomint(2) == 0)
			randomOffsetY = (randomOffsetY * -1);
		if (randomint(2) == 0)
			randomOffsetZ = (randomOffsetZ * -1);
		
		targetVec = (level.player.origin + (randomOffsetX,randomOffsetY,randomOffsetZ));
		self setTurretTargetVec(targetVec);
		self waittill("turret_on_target");
		
		wait (5 + randomfloat(5));
		self notify ("turret_fire");
		
		d = distance(level.player.origin, targetVec);
		//do earthquake if it was close
		wait .25;
		if (d <= 600)
			earthquake( 0.25, 3, targetVec, 750 );
		
		wait (2 + randomfloat(4));
	}
}

Kill_Germans_NotAtObservation()
{
	trig = getent ("approaching observation","targetname");
	axis = getaiarray ("axis");
	for (i=0;i<axis.size;i++)
	{
		if (axis[i] istouching(trig))
			continue;
		if (isdefined (axis[i].script_flak88))
			continue;
		if ( (isdefined (axis[i].script_noteworthy)) && (axis[i].script_noteworthy == "battleshowguys") )
			continue;
		axis[i] doDamage ( axis[i].health + 50, (0,0,0) );
	}
}

Kill_Germans_NotAtMosque()
{
	//player entered mosque - remove remaining axis from other areas of the level
	getent ("inside_mosque","targetname") waittill ("trigger");
	
	mosque_area = getent ("mosque_area","targetname");
	axis = getaiarray ("axis");
	for (i=0;i<axis.size;i++)
	{
		if (axis[i] istouching(mosque_area))
			continue;
		axis[i] doDamage ( axis[i].health + 50, (0,0,0) );
	}
}

balcony_spawner()
{
	trig = getent ("balcony_spawner","targetname");
	door = getent (trig.target,"targetname");
	spawnerEnt = getent (door.target,"targetname");
	
	trig waittill ("trigger");
	
	if (!isdefined (spawnerEnt))
		return;
	
	door rotateyaw(90, 1,0.25,0.25);
	door connectpaths();
	
	wait 1;
	
	guy = spawnerEnt stalingradSpawn();
}

blow_up_flak()
{
	trig = getent ("blow_up_flak","targetname");
	allflaks = getentarray ("flak objective","targetname");
	flak = undefined;
	for (i=0;i<allflaks.size;i++)
	{
		if ( (isdefined (allflaks[i].script_flak88)) && (allflaks[i].script_flak88 == trig.script_noteworthy) )
		{
			flak = allflaks[i];
			break;
		}
	}
	if (!isdefined (flak))
		return;
	trig waittill ("trigger");
}
/*
Plant_Explosives_Notes()
{
	self endon ("stop watching notes");
	for (;;)
	{
		self waittill ("single anim", notetrack);
		switch (notetrack)
		{
			case "release bomb from hands":
				org = self gettagOrigin("tag_weapon_right");
				level.flakbomb = spawn("script_model", org);
				level.flakbomb setModel ("xmodel/military_tntbomb");
				badplace_node = getnode ("plantexplosives","targetname");
				break;
		}
	}
}
*/
reset_SightDistOnGoal()
{
	self endon ("death");
	if (!isdefined (self))
		return;
	self waittill ("goal");
	if (isdefined (self.old_maxsightdistsqrd))
		self.maxsightdistsqrd = self.old_maxsightdistsqrd;
}

flak_planter_lookat()
{
	getent("flak_planter_lookat","targetname") waittill ("trigger");
	flag_set("flakplant_stop_loop");
}

Plant_Explosives_Wait()
{
	getent ("plant explosives","targetname") waittill ("trigger");
	
	level.tommy = undefined;
	level.tommy = getaiarray("allies") findClosestToPlayer();
	if (!isdefined (level.tommy))
		return;
	level.tommy thread magic_bullet_shield();
	level.tommy endon ("death");
	level dialogue_PlantExplosives();
	level.tommy.health = 100000000;
	
	node = getnode("plantexplosives","targetname");
	level.tommy notify ("stop friendly think");
	level.tommy.goalradius = 4;
	level.tommy.old_pathEnemyFightDist = level.tommy.pathEnemyFightDist;
	level.tommy.pathEnemyFightDist = 32;
	level.tommy.animname = "soldier";
	level.tommy anim_reach_solo( level.tommy, "plant", undefined, node);
	if (!isdefined (level.tommy))
		return;
	//level.tommy thread Plant_Explosives_Notes();
	level.tommy animscripts\shared::PutGunInHand("none");
	level.tommy anim_single_solo( level.tommy, "plant", undefined, node);
	if (!isdefined (level.tommy))
		return;
	level.tommy thread anim_loop_solo( level.tommy, "loop", undefined, "stop_plant_loop", node);
	
	badplace_node = getent ("flak1badplace","targetname");
	badplace_cylinder("bpFlak1", -1, badplace_node.origin, badplace_node.radius, 300);
	
	//wait until player has seen the planter or time expires
	flag_clear("flakplant_stop_loop");
	thread flak_planter_lookat();
	for( i = 0 ; i < 25 ; i++ )
	{
		if(flag("flakplant_stop_loop"))
			break;
		wait 1;
	}
	if (!isdefined (level.tommy))
		return;
	level.tommy notify ("stop_plant_loop");
	level.tommy animscripts\shared::PutGunInHand("right");
	level.tommy notify ("stop watching notes");
	wait 5;
	badplace_delete("bpFlak1");
	if (!isdefined (level.tommy))
		return;
	level.tommy.goalradius = 512;
	level.tommy.pathEnemyFightDist = level.tommy.old_pathEnemyFightDist;
	level.tommy thread friendlyMethod();
	level.tommy notify ("stop magic bullet shield");
	level.tommy = undefined;
	if (isdefined (level.flakbomb))
		level.flakbomb delete();
	flak = getent ("tankdestroyer","targetname");
	flak notify ("death");
	
	level notify ("flak88 blew up");
	earthquake(0.25, 3, flak.origin, 1050);
}

Battlechatter_Allies(OnOff)
{
	if (OnOff == "on")
		battleChatterOn("allies");
	else if (OnOff == "off")
		battleChatterOff("allies");
}

setInCombat()
{
	self thread animscripts\shared::SetInCombat();
}

flak_badplace()
{
	area = getent ("flak_badplace","targetname");
	node = getnode (area.target, "targetname");
	allies = getaiarray ("allies");
	for (i=0;i<allies.size;i++)
	{
		if (!allies[i] istouching (area))
			continue;
		allies[i] thread flak_badplace_runaway(node);
	}
}

flak_badplace_runaway(node)
{
	self notify ("stop friendly think");
	self setGoalNode (node);
	level waittill ("flak88 blew up");
	self thread friendlyMethod();
}

music_intro()
{
	level endon ("intro music stop");
	for (;;)
	{
		musicplay("music_toujane_ridein");
		wait 1;
	}
}

first_enemy_tank_think()
{
	trig = getent("first_enemy_tank_trig","targetname");
	for (;;)
	{
		trig waittill ("trigger", other);
		if ((isdefined (other.targetname)) && (other.targetname == "first_enemy_tank"))
			break;
	}
	
	//someone shouts out about the tank
	guy = getaiarray("allies") findClosestToPlayer();
	if (isdefined (guy))
	guy thread dialogue_Thread("UK_3_threat_vehicle_panzer");
	
	other thread German_Tank_Think();
}

findClosestToPlayer(exclude, otherPlayerEnt)
{
	closestEnt = undefined;
	closest = 100000000;
	
	if (isdefined(level.tommy))
	{
		if (!isdefined(exclude))
			exclude = [];
		else
			exclude[exclude.size] = level.tommy;
	}
	
	for (i=0;i<self.size;i++)
	{
		isExcluder = false;
		if ( (isdefined (exclude)) && (isdefined (exclude[0])) )
		{
			//find if it's one of the exclude entities
			for (j=0;j<exclude.size;j++)
			{
				if (exclude[j] == self[i])
					isExcluder = true;
			}
		}
		
		if (isExcluder)
			continue;
		
		if (isdefined (otherPlayerEnt))
			dist = distance (otherPlayerEnt.origin, self[i].origin);
		else
			dist = distance (level.player.origin, self[i].origin);
		if (dist < closest)
		{
			closest = dist;
			closestEnt = self[i];
		}
	}
	return closestEnt;
}

#using_animtree("toujane_wall_tank_collapse");
breakwall()
{
	trig = getent("breakwall","targetname");
	breakwall = getent (trig.target,"targetname");
	breakwall UseAnimTree(#animtree);
	
	trig waittill ("trigger");
	breakwall setmodel ("xmodel/wall_tank_pieces");
	breakwall setflaggedanim("wall done", %wall_tank_collapse);
	breakwall playsound ("wall_crumble");
	exploder(0);
	level thread kill_germans_wallbreak();
	breakwall waittill ("wall done");
	breakwall setmodel ("xmodel/wall_tank_broke");
	getent ("breakingwall_collision","targetname") delete();
}

kill_germans_wallbreak()
{
	wait 2;
	axis = getaiarray("axis");
	volume = getent ("tankcrush_volume","targetname");
	for (i=0;i<axis.size;i++)
	{
		if (axis[i] isTouching (volume))
			axis[i] doDamage( axis[i].health + 1 , axis[i] getOrigin() );
	}
}

gate_trigger_flak2()
{
	flak = getent ("flak2","script_noteworthy");
	//flak waittill ("crew dead");
	flak waittill_any ("death","crew dead");
	trig = getent ("gate_trigger_flak2","script_noteworthy");
	if (isdefined (trig))
		trig notify ("trigger");
}

gate_trigger_flak3()
{
	flak = getent ("flak3","script_noteworthy");
	flak waittill_any ("death","crew dead");
	trig = getent ("gate_trigger_flak3","script_noteworthy");
	if (isdefined (trig))
		trig notify ("trigger");
}

panzerguys_shoot_walltank1()
{
	trig = getent ("panzerguys_shoot_walltank1","targetname");
	for (;;)
	{
		trig waittill ("trigger", ent);
		if ( (isdefined (ent.script_noteworthy)) && (ent.script_noteworthy == "walltank1") )
			break;
		wait 0.05;
	}
	level notify ("panzer guys about to kill tank1");
	spawners = getentarray ("panzerguys_shoot_walltank1_spawners","targetname");
	for (i=0;i<spawners.size;i++)
		spawners[i] thread panzerguys_shoot_walltank1_firepanzerfaust(ent);
}

panzerguys_shoot_walltank1_firepanzerfaust(tank)
{
	node1 = getnode (self.target,"targetname");
	node2 = getnode ("panzer_guy_runaway_node","targetname");
	
	guy = self stalingradSpawn();
	if (spawn_failed(guy))
		return;
	
	guy endon ("death");
	guy thread magic_bullet_shield();
	guy.ignoreme = true;
	guy.anim_disablepain = true;
	guy.pathenemyfightdist = 0;
	guy.pathenemylookahead = 0;
	
	wait randomfloat(3);
	tank.health = 10;
	guy.anim_dropPanzer = true;
	maps\_spawner::panzer_target(guy, node1, undefined, tank, (0,0,40) );
	
	guy notify ("stop magic bullet shield");
	guy.ignoreme = false;
	guy.anim_disablepain = false;
	
	wait 0.75;
	if ( (isdefined (tank)) && (tank.health > 0) )
		tank notify ("death");
	level notify ("panzer guys shot at tank1");
	
	wait 4;
	
	if (!isdefined(guy))
		return;
	guy endon ("death");
	guy setgoalnode (node2);
	guy waittill ("goal");
	guy delete();
}

panzerguys_shoot_walltank2()
{
	trig = getent ("panzerguys_shoot_walltank2","targetname");
	for (;;)
	{
		trig waittill ("trigger", ent);
		if ( (isdefined (ent.script_noteworthy)) && (ent.script_noteworthy == "walltank2") )
			break;
		wait 0.05;
	}
	level notify ("panzer guys about to kill tank2");
	spawners = getentarray ("panzerguys_shoot_walltank2_spawners","targetname");
	for (i=0;i<spawners.size;i++)
		spawners[i] thread panzerguys_shoot_walltank2_firepanzerfaust(ent);
}

panzerguys_shoot_walltank2_firepanzerfaust(tank)
{
	node = getnode (self.target,"targetname");
	
	guy = self dospawn();
	if (spawn_failed(guy))
		return;
	
	guy endon ("death");
	guy thread magic_bullet_shield();
	guy.ignoreme = true;
	guy.anim_disablepain = true;
	
	wait randomfloat(3);
	tank.health = 100;
	guy.anim_dropPanzer = true;
	maps\_spawner::panzer_target(guy, node, undefined, tank, (0,0,40) );
	
	guy notify ("stop magic bullet shield");
	guy.ignoreme = false;
	guy.anim_disablepain = false;
	
	wait 0.75;
	if ( (isdefined (tank)) && (tank.health > 0) )
		tank notify ("death");
	level notify ("panzer guys shot at tank2");
}

hayland()
{
	trig = getent ("hayland","targetname");
	
	done = [];
	for (;;)
	{
		trig waittill ("trigger",ent);
		
		flag_set("player_jumped_crack");
		
		dupe = false;
		//see if this ent already triggered the trigger
		for (j=0;j<done.size;j++)
		{
			if (ent == done[j])
				dupe = true;
		}
		if (!dupe)
		{
			done[done.size] = ent;
			exploder(2);
			ent playsoundinspace("land_wood");
		}
	}
}

axis_truck_badplace()
{	
	truck = maps\_vehicle::waittill_vehiclespawn("axis_truck");
	truck playsound ("truck_skid_toujane");
	truck waittill ("reached_end_node");
	
	badplace_cylinder("axis truck badplace", 8, truck.origin, 185, 300, "axis");
}

observation_ladder()
{
	//wait until the other guys on the roof spawn
	getent ("observation spawners","targetname") waittill ("trigger");
	
	//spawn the ladder kicker guy
	eSpawner = getent ("ladder_guy1","targetname");
	ladder_guy1 = eSpawner stalingradSpawn();
	if (spawn_failed(ladder_guy1))
	{
		//make the ladder usable and forget the whole scripted sequence
		observation_ladder_makeUsable();
		return;
	}
	
	//make sure he can't die until he's kicked the ladder down
	ladder_guy1 thread magic_bullet_shield();
	ladder_guy1.anim_disableLongDeath = true;
	ladder_guy1.animname = "germankicker";
	
	//make him go to his waiting node
	ladder_guy1.goalradius = 4;
	ladder_guy1 setgoalnode (getnode("ladder_node_guy1_wait","targetname"));
	
	//wait until the event is triggered (by getting within the radius trigger or the player looks at the ladder
	observation_ladder_trigger_kick();
	
	if ( (!isdefined(ladder_guy1)) || ( (isdefined(ladder_guy1)) && (!isalive(ladder_guy1)) ) )
	{
		observation_ladder_makeUsable();
		return;
	}
	
	//make the guy go to his kick node and play the animation
	ladder_guy1 thread observation_ladder_guy1();
	
	//wait until the OP is cleared then make a guy set the ladder back up
	area = getent ("groundfloor_op","targetname");
	axis = getaiarray ("axis");
	touching = [];
	for (i=0;i<axis.size;i++)
	{
		if (axis[i] isTouching (area))
			touching[touching.size] = axis[i];
	}
	if (touching.size > 0)
		waittill_dead(touching);
	thread crackjump_hints_playerDisableAnimation();
	getent ("roof_friendly_chain","script_noteworthy") thread triggerOn();
	level thread crackjump_hints();
	level thread observation_ladder_guy2();
}

crackjump_hints()
{	
	//first AI to touch the 'near_crack' trigger goes to the node
	//-----------------------------------------------------------
	trigger = getent("near_crack","targetname");
	crackGuy = undefined;
	for (;;)
	{
		trigger waittill ("trigger", other);
		if (other != level.player)
		{
			crackGuy = other;
			break;
		}
	}
	assert(isdefined(crackGuy));
	crackGuy thread magic_bullet_shield();
	node = getnode("crack_node_followme","targetname");
	crackGuy.animname = "soldier";
	crackGuy anim_reach_solo (crackGuy, "comehere", undefined, node);
	
	dialogue = [];
	nextDialogue = 0;
	dialogue[0] = "UK_3_order_move_generic";
	dialogue[1] = "UK_3_order_move_generic";
	dialogue[2] = "UK_3_order_move_generic";
	dialogue[3] = "UK_3_order_move_follow";
	
	//waits for the player to look that direction (while on the roof)
	//---------------------------------------------------------------
	if (!flag("skip_followme_animation"))
	{
		roofArea = getent("onroof","targetname");
		qWait = false;
		for (;;)
		{
			if (qWait)
				wait 1;
			qWait = true;
			
			if (flag("skip_followme_animation"))
				break;
			
			//player on roof?
			if (!level.player isTouching (roofArea))
				continue;
			
			//player looking towards guy?
			forwardvec = anglestoforward(level.player.angles);
			normalvec = vectorNormalize(node.origin - (level.player getOrigin()) );
			vecdot = vectordot(forwardvec,normalvec);
			if (vecdot > level.cos80)
				break;
		}
		
		//guy does animation
		if (!flag("skip_followme_animation"))
		{
			crackGuy thread anim_single_solo (crackGuy, "comehere", undefined, node);
			crackGuy thread animscripts\face::SaySpecificdialogue(undefined, dialogue[nextDialogue], 1.0);
			nextDialogue++;
		}
	}
	
	//does repeating dialogue until someone jumps the crack
	//-----------------------------------------------------
	for (;;)
	{
		if (flag("player_jumped_crack"))
			break;
		if (soundexists(dialogue[nextDialogue]))
			crackGuy thread animscripts\face::SaySpecificdialogue(undefined, dialogue[nextDialogue], 1.0);
		nextDialogue++;
		if (nextDialogue >= dialogue.size)
			nextDialogue = 0;
		wait 15;
	}
	
	//continue as normal
	//------------------
	flag_wait("player_jumped_crack");
	crackGuy setgoalentity (level.player);
	crackGuy notify ("stop_magic_bullet_shield");
}

crackjump_hints_playerDisableAnimation()
{
	trigger = getent("near_crack","targetname");
	for (;;)
	{
		if (level.player isTouching (trigger))
			break;
		wait 1;
	}
	flag_set("skip_followme_animation");
}

observation_ladder_trigger_kick()
{
	thread observation_ladder_trigger_kick_lookat();
	thread observation_ladder_trigger_kick_radius();
	level waittill ("ladder triggered");
}

observation_ladder_trigger_kick_lookat()
{
	level endon ("ladder triggered");
	getent ("ladder_trigger_lookat","targetname") waittill ("trigger");
	level notify ("ladder triggered");
}

observation_ladder_trigger_kick_radius()
{
	level endon ("ladder triggered");
	getent ("ladder_trigger_radius","targetname") waittill ("trigger");
	level notify ("ladder triggered");
}

observation_ladder_guy1()
{
	animNode = getnode ("ladder_node_guy1","targetname");
	
	assert(isdefined(self));
	assert(isalive(self));
	
	self.old_maxsightdistsqrd = self.maxsightdistsqrd;
	self.old_pathEnemyFightDist = self.pathEnemyFightDist;
	self.old_pathEnemyLookAhead = self.pathEnemyLookAhead;
	self.pathEnemyFightDist = 0;
	self.pathEnemyLookAhead = 0;
	self.ignoreme = true;
	self.maxsightdistsqrd = 0;
	self.goalradius = 4;
	
	//self setgoalnode (animNode);
	//self waittill ("goal");
	self anim_reach_solo(self, "kickladder", undefined, animNode);
	
	self thread observation_ladder_guy1_notetracks();
	self anim_single_solo(self, "kickladder", undefined, animNode);
	
	self.pathEnemyFightDist = self.old_pathEnemyFightDist;
	self.pathEnemyLookAhead = self.old_pathEnemyLookAhead;
	self.maxsightdistsqrd = self.old_maxsightdistsqrd;
	self.ignoreme = false;
	
	//make him go back over the wall
	self setgoalnode (getnode("ladder_node_guy1_done","targetname"));
}

observation_ladder_guy1_notetracks()
{
	for (;;)
	{
		self waittill ("single anim", notetrack);
		if (notetrack == "kickladder")
		{
			level thread observation_ladder_ladderAnim("fall");
			self notify ("stop magic bullet shield");
			self.health = 10;
			self.allowdeath = 1;
			return;
		}
	}
}

observation_ladder_guy2()
{
	while (!level.flags["ladder fell"])
		wait 1;
		
	animNode = getnode ("ladder_node_guy2","targetname");
	
	guy = undefined;
	exclude = [];
	for (;;)
	{
		guy = getaiarray("allies") findClosestToPlayer(exclude, animNode);
		if (isdefined (guy))
			break;
		wait 1;
	}
	guy.health = 10000000;
	guy.animname = "soldier";
	guy.laddersetup = true;
	anim_reach_solo (guy, "setupladder", undefined, animNode);
	guy thread observation_ladder_guy2_notetracks();
	anim_single_solo (guy, "setupladder", undefined, animNode);
	
	standNode = getnode("ladder_climber_node","targetname");
	guy.goalradius = 16;
	guy setgoalnode (standNode);
	guy waittill ("goal");
	
	trig = getent ("ladder_climber_lookat","targetname");
	trig waittill ("trigger");
	
	if (isdefined (guy))
		thread friendlyMethod(guy);
	wait 5;
	if (isdefined (guy))
		guy.health = 100;
}

observation_ladder_guy2_notetracks()
{
	tempgun = undefined;
	for (;;)
	{
		self waittill ("single anim", notetrack);
		if (notetrack == "lift")
		{
			level thread observation_ladder_ladderAnim("setup");
			return;
		}
	}
}

#using_animtree("toujane_ladder");
observation_ladder_ladderAnim(animName)
{
	ladder = getent("ladder","targetname");
	ladder UseAnimTree(#animtree);
	
	if (animName == "fall")
	{
		ladder setflaggedanim ("ladder", %toujane_ladder_fall);
		exploder(1);
		wait 4;
		level.flags["ladder fell"] = true;
	}
	else if (animName == "setup")
	{
		ladder playsound("toujane_raiseladder");
		ladder setflaggedanimknob ("ladder", %toujane_ladder_setup);
		ladder waittillmatch ("ladder", "end");
		thread observation_ladder_makeUsable();
	}
}

observation_ladder_makeUsable()
{
	ladder_clip = getentarray ("ladder_clip","targetname");
	if (!isdefined (ladder_clip))
		return;
	
	for (i=0;i<ladder_clip.size;i++)
	{
		ladder_clip[i] connectpaths();
		ladder_clip[i] delete();
	}
	
	//wait to make sure player and friendlyAI are not inside the ladder brush when moving it back to position
	area = getent ("ladder_proximity","targetname");
	areaClear = false;
	ents = getaiarray("allies");
		ents[ents.size] = level.player;
	while (!areaClear)
	{
		wait 0.25;
		
		touching = 0;
		for (i=0;i<ents.size;i++)
		{
			if (!isdefined (ents[i]))
				continue;
			if (ents[i] isTouching (area))
			{
				if (!isdefined (ents[i].laddersetup))
					touching++;
			}
		}
		
		if (touching <= 0)
			areaClear = true;
	}
	
	level.OPLadderBrush.origin = level.OPLadderBrush.workingOrigin;
	if (isdefined (level.OPLadderBrushDisableTraverse))
	{
		level.OPLadderBrushDisableTraverse connectpaths();
		level.OPLadderBrushDisableTraverse delete();
	}
}

friendlyMethod(guy)
{
	if (!isdefined (guy))
		guy = self;
	
	self.animname = "soldier";
	
	if (level.friendlyMethod == "friendly chains")
	{
		guy.followmin = 0;
		guy.followmax = 6;
		guy setgoalentity (level.player);
	}
	else if (level.friendlyMethod == "mosque node")
	{
		if (level.friendly_mosque_nodes_index >= level.friendly_mosque_nodes.size)
			level.friendly_mosque_nodes_index = 0;
		guy setgoalnode (level.friendly_mosque_nodes[level.friendly_mosque_nodes_index]);
		guy.goalradius = 128;
		level.friendly_mosque_nodes_index++;
	}
}

ai_pathEnemyFightDist_decrease()
{
	self endon ("death");
	
	self.pathEnemyFightDist = 512;
	wait 10;
	self.pathEnemyFightDist = 256;
	wait 10;
	self.pathEnemyFightDist = 128;
	wait 10;
	self.pathEnemyFightDist = 64;
}

spawners_tweak()
{
	attackPlayer = false;
	
	node = undefined;
	if (isdefined (self.target))
		node = getnode (self.target,"targetname");
	
	self waittill ("spawned", spawned);
	if (spawn_failed(spawned))
		return;
	
	spawned.maxsightdistsqrd = (2500 * 2500);
	spawned.badplaceawareness = 1;
	
	if ( (isdefined (spawned.script_squad)) && (spawned.script_squad == "3") )
	{
		spawned.pathenemyfightdist = 512;
		spawned.pathenemylookahead = 512;
	}
	
	if (!isdefined (spawned.script_noteworthy))
		return;
	
	switch (spawned.script_noteworthy)
	{
		case "delete_at_goal":
			spawned waittill ("goal");
			spawned delete();
			break;
		case "battleshowguys":
			spawned.drawoncompass = false;
			break;
		case "battleshowguys_delete_at_goal_nosight":
			spawned.drawoncompass = false;
			spawned.pathEnemyFightDist = 0;
			spawned.maxsightdistsqrd = 4;
			spawned.ignoreme = true;
			spawned.goalradius = 64;
			spawned waittill ("goal");
			spawned delete();
			break;
		case "delete_at_goal_nosight":
			spawned.pathEnemyFightDist = 0;
			spawned.maxsightdistsqrd = 4;
			spawned.ignoreme = true;
			spawned.goalradius = 64;
			spawned waittill ("goal");
			spawned delete();
			break;
		case "no_sight_till_goal":
			spawned.goalradius = 350;
			spawned.old_pathEnemyFightDist = spawned.pathEnemyFightDist;
			spawned.pathEnemyFightDist = 4;
			spawned waittill ("goal");
			spawned.pathEnemyFightDist = spawned.old_pathEnemyFightDist;
			break;
		case "walk_chain_then_attack_player":
			if (isdefined (node))
			{
				for (;;)
				{
					spawned.pathenemyfightdist = 512;
					spawned.pathenemylookahead = 512;
					spawned.goalradius = node.radius;
					spawned setgoalnode (node);
					spawned waittill ("goal");
					if (!isdefined (node.target))
						break;
					node2 = getnode(node.target,"targetname");
					if (!isdefined (node2))
						break;
					node = node2;
				}
			}
			spawned thread attack_player_closein();
			break;
		case "attackplayer":
			spawned.pathenemyfightdist = 512;
			spawned.pathenemylookahead = 512;
			spawned thread attack_player_closein();
			break;
		case "smallgoalfirst":
			if (!isdefined (node))
				return;
			spawned.goalradius = 16;
			spawned setgoalnode (node);
			spawned waittill ("goal");
			if (!isdefined(spawned))
				break;
			if (isdefined (node.radius))
				spawned.goalradius = node.radius;
			else
				spawned.goalradius = 500;;
			break;
		default:
			break;
	}
}

attack_player_closein()
{
	self endon ("death");
	wait (1 + randomfloat (1));
	if (!isdefined (self))
		return;
	self.goalradius = (800 + randomint(200));
	self setgoalentity (level.player);
	while ( (isdefined (self)) && (isalive (self)) )
	{
		if (self.goalradius <= 200)
		{
			self.goalradius = 200;
			return;
		}
		self.goalradius -= 200;
		wait (6 + randomfloat(2));
	}
}

walltanks_allow_breakCrates()
{
	level thread walltanks_allow_breakCrates_spawnWait("walltank1");
	level thread walltanks_allow_breakCrates_spawnWait("walltank2");
}

walltanks_allow_breakCrates_spawnWait(targetname)
{
	tank = maps\_vehicle::waittill_vehiclespawn(targetname);
	level.breakingEnts[level.breakingEnts.size] = tank;
}

friendlychain_delete()
{
	self waittill ("trigger");
	wait 0.05;
	self delete();
}

ladder_climber_lookat_trigger()
{
	thread ladder_climber_lookat_trigger2();
	
	trig = getent ("onroof","targetname");
	for (;;)
	{
		trig waittill ("trigger", other);
		if (other == level.player)
			break;
		wait 1;
	}
	level thread ladder_climber_lookat();
}

ladder_climber_lookat_trigger2()
{
	trig = getent ("objective_op_done","targetname");
	for (;;)
	{
		trig waittill ("trigger", other);
		if (other == level.player)
			break;
		wait 1;
	}
	level thread ladder_climber_lookat();
}

ladder_climber_lookat()
{
	trig = getent ("ladder_climber_lookat","targetname");
	for (i=0;i<30;i++)
	{
		trig notify ("trigger");
		wait 1;
	}
}

special_hint_background()
{
	if(!isdefined(self.background))
		return;
	self.background.x = 320;
	self.background.y = 206;
	self.background.alignX = "center";
	self.background.alignY = "middle";
	if(level.xenon)
		self.background setshader("popmenu_bg", 650, 60);
	else
		self.background setshader("popmenu_bg", 650, 50);
	self.background.alpha = .5;
}

special_hint(shader, hint, scale, xoffset, yoffset, xnum, ynum, horzAlign)
{
	if (flag("player_has_red_flashing_overlay"))
		return undefined;
	level notify("hud_elem_going_up");
	level endon("hud_elem_going_up");
	level endon("hud_elem_interupt");
	
	background = undefined;
	if(isdefined(level.setHudElmHintBackground) && level.setHudElmHintBackground == true)
		background = newHudElem();
		
	stancehint = newHudElem();
	stancehint.label = (level.strings[hint].text);
	if(isdefined(level.strings[hint].bind))
		stancehint setText(level.strings[hint].bind);
	
	stancehint.background = background;
	stancehint special_hint_background();
	
	stancehint add_hudelm_position();

	stanceicon = newHudElem();
	stanceicon add_hudelm_position(true, (xoffset - 15), (xoffset - 10), yoffset);

	if(level.xenon)
		stanceicon setShader(shader, (scale + 5), (scale + 5));
	else
		stanceicon setShader(shader, scale,  scale);
	
	stanceicon thread add_hudelem_pulse(1, true);
	stancehint thread add_hudelem_pulse(1, true);
	
	stanceicon thread remove_specialhint("hud_elem_going_up");
	stanceicon thread remove_specialhint("hud_elem_interupt");
	stancehint thread remove_hudelm_hint("hud_elem_going_up");
	stancehint thread remove_hudelm_hint("hud_elem_interupt");
	
	wait 5;
	
	stanceicon destroy();
	stanceicon = newHudElem();
	if(level.xenon)
		stanceicon setShader(shader, (scale + 5), (scale + 5));
	else
		stanceicon setShader(shader, scale, scale);
	
	stanceicon add_hudelm_position(true, (xoffset - 15), (xoffset - 10), yoffset);
	stanceicon thread remove_specialhint("hud_elem_going_up");
	stanceicon thread remove_specialhint("hud_elem_interupt");
	stanceicon.alpha = 1;
	
	stanceicon moveovertime(1);
	stanceicon.x = xnum; 
	stanceicon.y = ynum;
	if(isdefined(horzAlign))
		stanceicon.horzAlign = horzAlign;
	else
		stanceicon.horzAlign = "left";
	stanceicon.vertAlign = "middle";
	
	if(level.xenon)
		stanceicon scaleovertime(1, scale, scale);
	else
		stanceicon scaleovertime(1, (scale-5), scale-5);
	wait .85;
	stanceicon fadeovertime(.15);
	stanceicon.alpha = 0;

	wait .5;
	
	stancehint fadeovertime(.5);
	stancehint.alpha = 0;
	if(isdefined(stancehint.background))
	{
		stancehint.background fadeovertime(.5);
		stancehint.background.alpha = 0;
		stancehint.background destroy();
	}
	
	stancehint destroy();
	stanceicon destroy();	
}

remove_specialhint(ender)
{
	level waittill(ender);
	if(!isdefined(self))
		return;
	self notify("destroying");
	self notify("destroyed");
	self destroy();
}

nonlinear_hint()
{
	getent ("nonlinear_hint","script_noteworthy") waittill ("trigger");
	add_hudelm_hint(level.strings["nonlinear"], undefined, level.hud_repeat_rate);
}