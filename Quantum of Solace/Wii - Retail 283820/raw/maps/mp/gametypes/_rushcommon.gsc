#include maps\mp\_utility;
#include maps\mp\gametypes\_hud_util;







rushInit()
{
	
	level.intel_model		= "p_msc_suitcase_vesper_multiplayer";	
	level.extract_model		= "model_multi_extraction_point";		
	level.ggun_p1model		= "golden_gun_case_mp_bx";
	level.ggun_p2model		= "golden_gun_pen_mp_bx";
	level.ggun_p3model		= "golden_gun_lighter_mp_bx";
	level.golden_gun_weapon = "golden_gun_mp";
	
	
	level.intelLocations = getentarray("mp_00rush_intel_pickup","targetname");
	if (!level.intelLocations.size)
	{	
		maps\mp\_utility::error("Map does not appear to be setup for 00Rush. No mp_00rush_intel_pickup trigger found in map.");
		return;
	}
	level.intelExtracts = getentarray("mp_00rush_intel_extract","targetname");
	if (!level.intelExtracts.size)
	{	
		maps\mp\_utility::error("Map does not appear to be setup for 00Rush. No mp_00rush_intel_extract trigger found in map.");
		return;
	}

	
	level.intelVisuals[0] = spawn("script_model", (0,0,-15000));
	level.intelVisuals[0].angles = (0,0,0);
	level.intelVisuals[0] setModel(level.intel_model);

	
	level.extractVisuals[0] = spawn("script_model",(0,0,-15000));
	level.extractVisuals[0].angles = (0,0,0);
	level.extractVisuals[0] setModel(level.extract_model);


	
	level.signalZones = getentarray("mp_00rush_signal_zone","targetname");
	if (!level.signalZones.size)
	{
		maps\mp\_utility::error("Map does not appear to be setup for 00Rush. No mp_00rush_signal_zone trigger found in map.");
		return;
	}


	
	level.computerLocations = getentarray("mp_00rush_computer","targetname");
	if (!level.computerLocations.size)
	{
		maps\mp\_utility::error("Map does not appear to be setup for 00Rush. No mp_00rush_computer trigger found in map.");
		return;
	}


	
	level.ggunLocations = getentarray("mp_00rush_goldengun_part","targetname");
	if (level.ggunLocations.size < 3)
	{
		maps\mp\_utility::error("Map does not appear to be setup for 00Rush. Need at least 3x mp_00rush_goldengun_part triggers.");
		return;
	}

	
	level.ggunP1Visuals[0] = spawn("script_model",(0,0,-15000));
	level.ggunP1Visuals[0].angles = (0,0,0);
	level.ggunP1Visuals[0] setModel(level.ggun_p1model);

	
	level.ggunP2Visuals[0] = spawn("script_model",(0,0,-15000));
	level.ggunP2Visuals[0].angles = (0,0,0);
	level.ggunP2Visuals[0] setModel(level.ggun_p2model);

	
	level.ggunP3Visuals[0] = spawn("script_model",(0,0,-15000));
	level.ggunP3Visuals[0].angles = (0,0,0);
	level.ggunP3Visuals[0] setModel(level.ggun_p3model);




	
	level.points = [];
	level.points["intel_gathered"]		= 5;	
	level.points["intel_extracted"]		= 10;	
	level.points["signal_received"]		= 12;	
	level.points["computer_hacked"]		= 10;	
	level.points["target_killed"]		= 5;	
	level.points["target_survived"]		= 10;	
	level.points["required_kill"]		= 5;	
	level.points["goldengun_assembled"] = 7;	
	level.points["signal_perplayer"]	= 3;	
												
	
	
	level.timers = [];
	level.timers["short"]	= 60;
	level.timers["medium"]	= 150;
	level.timers["long"]	= 240;		
	level.timers["perkill"] = 30;				

	
	level.misc = [];
	level.misc["hud_font_scale"]= 1.75;			
	
	
	setDvar("respawn_delay", 10);
	setDvar("respawn_delay_inc", 5);
	setDvar("respawn_delay_max", 30);
	
	
	level.QuickMessageToAll = true;
	level.commonstate = "start";

	
	level thread onPlayerConnectRush();
	
}


onPlayerConnectRush()
{
	level endon ("game_ended");
	while (1)
	{
		level waittill( "connecting", player );
		player.battleEvaluationKills = 0;
	}
}





rushPrecache()
{
	level.glow_fx = loadfx("misc/MP_glow");
	precacheModel("p_msc_suitcase_vesper_multiplayer"); 
	precacheModel("golden_gun_case_mp_bx");
	precacheModel("golden_gun_pen_mp_bx");
	precacheModel("golden_gun_lighter_mp_bx");
	precacheModel("model_multi_extraction_point");
	precacheModel("p_dec_laptop_mp_bx");
	precacheModel("com_laptop_open");

	
	precacheString(&"MP_OBJECTIVE_COMPLETED");
	precacheString(&"MP_OBJECTIVE_FAILED");
	precacheString(&"MP_OBJECTIVE_ABORTED");
	precacheString(&"MP_INTEL_RETRIEVAL");
	precacheString(&"MP_SIGNAL_INTERCEPTION");
	precacheString(&"MP_COMPUTER_HACKING");
	precacheString(&"MP_GOLDEN_GUN");
	precacheString(&"MP_COMBAT_EVALUATION");
	precacheString(&"MP_ASSASSINATION");

	
	precacheString(&"MP_YOU_GOT_BRIEFCASE");
	precacheString(&"MP_GO_EXTRACTION_POINT");
	precacheString(&"MP_GET_INTEL_BACK");
	precacheString(&"MP_HAS_BRIEFCASE");
	precacheString(&"MP_BRIEFCASE_DROPPED");
	precacheString(&"MP_FIND_BRIEFCASE");

	
	precacheString(&"MP_REACH_SIGNALZONE");
	precacheString(&"MP_DEFEND_SIGNALZONE");
	precacheString(&"MP_SYNCHING_SATELLITE");
	precacheString(&"MP_READY_RECEIVE_SIGNAL");


	
	precacheString(&"MP_FIND_HACK_COMPUTER");
	precacheString(&"MP_HACKED_COMPUTER");
	precacheString(&"MP_HACKING");
	precacheString(&"MP_HACK_IN_PROGRESS");
    precacheString(&"MP_HACK_COMPUTER");

	
	precacheString(&"MP_BEEN_TARGETED");
	precacheString(&"MP_DISPOSE_OF");
	precacheString(&"MP_SURVIVE");

	
	precacheString(&"MP_ONE_CANDIDATE_LEFT");
	precacheString(&"MP_ELIMINATE_CANDIDATES");

	
	precacheString(&"MP_ASSEMBLE_GOLDEN_GUN");
	precacheString(&"MP_FOUND_GOLDEN_GUN_PART");
	
	
	precacheShader("compass_waypoint_captureneutral_up");
	precacheShader("compass_waypoint_captureneutral_down");
	precacheShader("compass_waypoint_captureneutral");
	
	
	precacheShader("mp_bx_hud_waypoint_briefcase");
	precacheShader("mp_bx_hud_waypoint_computer");
	precacheShader("mp_bx_hud_waypoint_exit");
	precacheShader("mp_bx_hud_waypoint_golden_gun_p1");
	precacheShader("mp_bx_hud_waypoint_golden_gun_p2");
	precacheShader("mp_bx_hud_waypoint_golden_gun_p3");
	precacheShader("mp_bx_hud_waypoint_satellite");
	precacheShader("mp_bx_hud_waypoint_target");
}






onEndGame()
{
	
	setdvar("genmsg_enabled",false);
}





objectiveTimer(seconds)
{
	level endon ("game_ended");
	level endon ("objective_done");
	wait(seconds);
	level notify ("objective_done");
}




setupObjective(timer_seconds)
{
	
	thread objectiveTimer(timer_seconds);

	hud_font_scale = level.misc["hud_font_scale"];

	
	level.objTimerHUD = createServerTimer("default",hud_font_scale);
	level.objTimerHUD.color = (1,1,1);
	level.objTimerHUD setTenthsTimer(timer_seconds);
	level.objTimerHUD setPoint("TOPLEFT",undefined,0,25);
}
























displayGeneralMessage(string)
{
	setdvar("genmsg_enabled",true);
	setdvar("genmsg_message",string);
	wait(4.0);
	setdvar("genmsg_enabled",false);
}





takeGoldenGun()
{
	self.hasGoldenGun = false;
	self takeWeapon(level.golden_gun_weapon);
	
	
	
}




checkGoldenGunAmmo()
{
	check = true;
	while (check && isAlive(self))
	{
		wait (0.5);
		currentAmmo = self getAmmoCount(level.golden_gun_weapon);

		if (currentAmmo == 0) 
		{
			
			self ReturnWeapon(self.preGoldenGunWeapon);
			self SwitchToWeapon(self.preGoldenGunWeapon);
			self.pers["weap"] = self.preGoldenGunWeapon;
			
			self takeGoldenGun();
			check = false;
		}
	}
}





getGoodExtractZoneIndex(briefcase)
{
	threshold = 2000;
	i = 1 ;
	while (1)
	{
		if (i%5 == 0) 
			threshold -= 500;

		extractIndex = randomInt(level.intelExtracts.size);
		if (distance(briefcase.origin, level.intelExtracts[extractIndex].origin) >= threshold)
		{
			
			return extractIndex;
		}
		i++;
	}
}




getNumberOfTargets()
{
	iPlayersPlaying = 0;
	for (i = 0 ; i < level.players.size; i++)
	{
		if (level.players[i].sessionstate == "playing")
			iPlayersPlaying++;
	}

	if (!iPlayersPlaying)
		return 1;

	return randomIntRange(1,iPlayersPlaying+1);
}