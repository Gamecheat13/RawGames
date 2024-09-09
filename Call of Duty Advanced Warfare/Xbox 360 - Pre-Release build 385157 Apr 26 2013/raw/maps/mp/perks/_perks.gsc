#include common_scripts\utility;
#include maps\mp\_utility;
#include maps\mp\gametypes\_hud_util;
#include maps\mp\perks\_perkfunctions;
#include maps\mp\gametypes\_scrambler;
#include maps\mp\gametypes\_portable_radar;

init()
{
	level.perkFuncs = [];

	precacheShader( "combathigh_overlay" );
	//precacheShader( "specialty_painkiller" );
	precacheShader( "specialty_juiced" );
	precacheShader( "compassping_revenge" );
	//precacheShader( "teamperk_health_regen" );
	//precacheShader( "teamperk_blast_shield" );
	//precacheShader( "teamperk_stun_protection" );
	precacheShader( "specialty_c4death" );
	precacheShader( "specialty_finalstand" );

	precacheModel( "weapon_riot_shield_mp" );
	precacheModel( "viewmodel_riot_shield_mp" );
	precacheString( &"MPUI_CHANGING_KIT" );

	//level.spawnGlowSplat = loadfx( "fx/misc/flare_ambient_destroy" );

	level.spawnGlowModel["enemy"] = "mil_emergency_flare_mp";
	level.spawnGlowModel["friendly"] = "mil_emergency_flare_mp";
	level.spawnGlow["enemy"] = loadfx( "vfx/props/flare_ambient" );
	level.spawnGlow["friendly"] = loadfx( "vfx/props/flare_ambient_green" );
	level.c4Death = loadfx( "fx/explosions/javelin_explosion" );

	level.spawnFire = loadfx( "fx/props/barrelexp" );

	precacheModel( level.spawnGlowModel["friendly"] );
	precacheModel( level.spawnGlowModel["enemy"] );

	precacheString( &"MP_DESTROY_TI" );
	
	precacheShaders();

	level._effect["ricochet"] = loadfx( "fx/impacts/large_metalhit_1" );

	// perks that currently only exist in script: these will error if passed to "setPerk", etc... CASE SENSITIVE! must be lower
	level.scriptPerks = [];
	level.perkSetFuncs = [];
	level.perkUnsetFuncs = [];
	level.fauxPerks = [];

	level.scriptPerks["specialty_blastshield"] = true;
	level.scriptPerks["_specialty_blastshield"] = true;
	level.scriptPerks["specialty_akimbo"] = true;
	level.scriptPerks["specialty_siege"] = true;
	level.scriptPerks["specialty_falldamage"] = true;
	level.scriptPerks["specialty_shield"] = true;
	level.scriptPerks["specialty_feigndeath"] = true;
	level.scriptPerks["specialty_shellshock"] = true;
	level.scriptPerks["specialty_delaymine"] = true;
	level.scriptPerks["specialty_localjammer"] = true;
	level.scriptPerks["specialty_thermal"] = true;
	level.scriptPerks["specialty_blackbox"] = true;
	level.scriptPerks["specialty_steelnerves"] = true;
	level.scriptPerks["specialty_flashgrenade"] = true;
	level.scriptPerks["specialty_smokegrenade"] = true;
	level.scriptPerks["specialty_concussiongrenade"] = true;
	level.scriptPerks["specialty_challenger"] = true;
	level.scriptPerks["specialty_saboteur"] = true;
	level.scriptPerks["specialty_endgame"] = true;
	level.scriptPerks["specialty_rearview"] = true;
	level.scriptPerks["specialty_hardline"] = true;
	level.scriptPerks["specialty_ac130"] = true;
	level.scriptPerks["specialty_sentry_minigun"] = true;
	level.scriptPerks["specialty_predator_missile"] = true;
	level.scriptPerks["specialty_helicopter_minigun"] = true;
	level.scriptPerks["specialty_tank"] = true;
	level.scriptPerks["specialty_precision_airstrike"] = true;
	level.scriptPerks["specialty_onemanarmy"] = true;
	level.scriptPerks["specialty_littlebird_support"] = true;
	level.scriptPerks["specialty_primarydeath"] = true;
	level.scriptPerks["specialty_secondarybling"] = true;
	level.scriptPerks["specialty_explosivedamage"] = true;
	level.scriptPerks["specialty_laststandoffhand"] = true;
	level.scriptPerks["specialty_dangerclose"] = true;
	level.scriptPerks["specialty_luckycharm"] = true;
	level.scriptPerks["specialty_hardjack"] = true;
	level.scriptPerks["specialty_extraspecialduration"] = true;
	level.scriptPerks["specialty_rollover"] = true;
	level.scriptPerks["specialty_armorpiercing"] = true;
	level.scriptPerks["specialty_omaquickchange"] = true;
	level.scriptPerks["_specialty_rearview"] = true;
	level.scriptPerks["_specialty_onemanarmy"] = true;
	level.scriptPerks["specialty_steadyaimpro"] = true;
	level.scriptPerks["specialty_stun_resistance"] = true;
	level.scriptPerks["specialty_double_load"] = true;
	level.scriptPerks["specialty_hard_shell"] = true;
	level.scriptPerks["specialty_regenspeed"] = true;
	level.scriptPerks["specialty_twoprimaries"] = true;
	level.scriptPerks["specialty_autospot"] = true;
	level.scriptPerks["specialty_overkillpro"] = true;
	level.scriptPerks["specialty_anytwo"] = true;
	level.scriptPerks["specialty_assists"] = true;
	level.scriptPerks["specialty_fasterlockon"] = true;
	level.scriptPerks["specialty_paint"] = true;
	level.scriptPerks["specialty_paint_pro"] = true;

	level.fauxPerks["specialty_shield"] = true;

	// Blacksmith New PERKS
	level.scriptPerks["specialty_crouchmovement"] = true;
	level.scriptPerks["specialty_sprintfire"] = true;
	level.scriptPerks["specialty_sprintequipment"] = true;
	level.scriptPerks["specialty_countersilencer"] = true;
	level.scriptPerks["specialty_threatdetection"] = true;
	level.scriptPerks["specialty_personaluav"] = true;
	
	level.scriptPerks["specialty_explosiveammoresupply"] = true;
	level.scriptPerks["specialty_lethalresupply"] = true;
	level.scriptPerks["specialty_tacticalresupply"] = true;

	level.scriptPerks["specialty_hardline2"] = true;					// this is a second -1 to killstreak costs.
	level.scriptPerks["specialty_undying_killstreaks"] = true;			// assault killstreaks do not reset upon death.
	level.scriptPerks["specialty_adrenaline_bonus_assist"] = true;		// gives an extra killstreak point when giveAdrenaline("assist") is called.
	level.scriptPerks["specialty_adrenaline_bonus_headshot"] = true;	// gives an extra killstreak point when giveAdrenaline("headshot") is called.
	level.scriptPerks["specialty_adrenaline_bonus_capture"] = true;		// "
	level.scriptPerks["specialty_adrenaline_bonus_assistedCapture"] = true;	
	level.scriptPerks["specialty_adrenaline_bonus_plant"] = true;
	level.scriptPerks["specialty_adrenaline_bonus_defuse"] = true;
	level.scriptPerks["specialty_greater_killstreaks"] = true;			// killstreaks do more damage
	level.scriptPerks["specialty_killstreaks_chain"] = true;			// some killstreak weapons give killstreak points
	level.scriptPerks["specialty_extra_killstreak"] = true;				// gives the player a fourth killstreak

	
	// weapon buffs
	level.scriptPerks["specialty_marksman"] = true;
	level.scriptPerks["specialty_sharp_focus"] = true;
	level.scriptPerks["specialty_bling"] = true;
	level.scriptPerks["specialty_moredamage"] = true;

	// death streaks
	level.scriptPerks["specialty_copycat"] = true;
	level.scriptPerks["specialty_combathigh"] = true;
	level.scriptPerks["specialty_finalstand"] = true;
	level.scriptPerks["specialty_c4death"] = true;
	level.scriptPerks["specialty_juiced"] = true;
	level.scriptPerks["specialty_revenge"] = true;
	level.scriptPerks["specialty_light_armor"] = true;
	level.scriptPerks["specialty_carepackage"] = true;
	level.scriptPerks["specialty_stopping_power"] = true;
	level.scriptPerks["specialty_uav"] = true;

	// equipment
	level.scriptPerks["bouncingbetty_mp"] = true;
	level.scriptPerks["c4_mp"] = true;
	level.scriptPerks["claymore_mp"] = true;
	level.scriptPerks["frag_grenade_mp"] = true;
	level.scriptPerks["semtex_mp"] = true;
	level.scriptPerks["throwingknife_mp"] = true;
	level.scriptPerks["paint_grenade_mp"] = true;

	// special grenades
	level.scriptPerks["concussion_grenade_mp"] = true;
	level.scriptPerks["flash_grenade_mp"] = true;
	level.scriptPerks["smoke_grenade_mp"] = true;
	level.scriptPerks["emp_grenade_mp"] = true;
	level.scriptPerks["specialty_portable_radar"] = true;
	level.scriptPerks["specialty_scrambler"] = true;
	level.scriptPerks["specialty_tacticalinsertion"] = true;
	level.scriptPerks["trophy_mp"] = true;
	
	// specialty_null is assigned as a perk sometimes and it's not a code perk
	level.scriptPerks["specialty_null"] = true;

	/*
	level.perkSetFuncs[""] = ::;
	level.perkUnsetFuncs[""] = ::;
	*/

	level.perkSetFuncs["specialty_blastshield"] = ::setBlastShield;
	level.perkUnsetFuncs["specialty_blastshield"] = ::unsetBlastShield;

	level.perkSetFuncs["specialty_siege"] = ::setSiege;
	level.perkUnsetFuncs["specialty_siege"] = ::unsetSiege;

	level.perkSetFuncs["specialty_falldamage"] = ::setFreefall;
	level.perkUnsetFuncs["specialty_falldamage"] = ::unsetFreefall;

	level.perkSetFuncs["specialty_localjammer"] = ::setLocalJammer;
	level.perkUnsetFuncs["specialty_localjammer"] = ::unsetLocalJammer;

	level.perkSetFuncs["specialty_thermal"] = ::setThermal;
	level.perkUnsetFuncs["specialty_thermal"] = ::unsetThermal;

	level.perkSetFuncs["specialty_blackbox"] = ::setBlackBox;
	level.perkUnsetFuncs["specialty_blackbox"] = ::unsetBlackBox;

	level.perkSetFuncs["specialty_lightweight"] = ::setLightWeight;
	level.perkUnsetFuncs["specialty_lightweight"] = ::unsetLightWeight;

	level.perkSetFuncs["specialty_steelnerves"] = ::setSteelNerves;
	level.perkUnsetFuncs["specialty_steelnerves"] = ::unsetSteelNerves;

	level.perkSetFuncs["specialty_delaymine"] = ::setDelayMine;
	level.perkUnsetFuncs["specialty_delaymine"] = ::unsetDelayMine;

	level.perkSetFuncs["specialty_challenger"] = ::setChallenger;
	level.perkUnsetFuncs["specialty_challenger"] = ::unsetChallenger;

	level.perkSetFuncs["specialty_saboteur"] = ::setSaboteur;
	level.perkUnsetFuncs["specialty_saboteur"] = ::unsetSaboteur;

	level.perkSetFuncs["specialty_endgame"] = ::setEndGame;
	level.perkUnsetFuncs["specialty_endgame"] = ::unsetEndGame;

	level.perkSetFuncs["specialty_rearview"] = ::setRearView;
	level.perkUnsetFuncs["specialty_rearview"] = ::unsetRearView;

	level.perkSetFuncs["specialty_ac130"] = ::setAC130;
	level.perkUnsetFuncs["specialty_ac130"] = ::unsetAC130;

	level.perkSetFuncs["specialty_sentry_minigun"] = ::setSentryMinigun;
	level.perkUnsetFuncs["specialty_sentry_minigun"] = ::unsetSentryMinigun;

	level.perkSetFuncs["specialty_predator_missile"] = ::setPredatorMissile;
	level.perkUnsetFuncs["specialty_predator_missile"] = ::unsetPredatorMissile;

	level.perkSetFuncs["specialty_tank"] = ::setTank;
	level.perkUnsetFuncs["specialty_tank"] = ::unsetTank;

	level.perkSetFuncs["specialty_precision_airstrike"] = ::setPrecision_airstrike;
	level.perkUnsetFuncs["specialty_precision_airstrike"] = ::unsetPrecision_airstrike;

	level.perkSetFuncs["specialty_helicopter_minigun"] = ::setHelicopterMinigun;
	level.perkUnsetFuncs["specialty_helicopter_minigun"] = ::unsetHelicopterMinigun;

	level.perkSetFuncs["specialty_onemanarmy"] = ::setOneManArmy;
	level.perkUnsetFuncs["specialty_onemanarmy"] = ::unsetOneManArmy;

	level.perkSetFuncs["specialty_littlebird_support"] = ::setLittlebirdSupport;
	level.perkUnsetFuncs["specialty_littlebird_support"] = ::unsetLittlebirdSupport;

	level.perkSetFuncs["specialty_tacticalinsertion"] = ::setTacticalInsertion;
	level.perkUnsetFuncs["specialty_tacticalinsertion"] = ::unsetTacticalInsertion;

	level.perkSetFuncs["specialty_scrambler"] = ::setScrambler;
	level.perkUnsetFuncs["specialty_scrambler"] = ::unsetScrambler;

	level.perkSetFuncs["specialty_portable_radar"] = ::setPortableRadar;
	level.perkUnsetFuncs["specialty_portable_radar"] = ::unsetPortableRadar;

	level.perkSetFuncs["specialty_steadyaimpro"] = ::setSteadyAimPro;
	level.perkUnsetFuncs["specialty_steadyaimpro"] = ::unsetSteadyAimPro;

	level.perkSetFuncs["specialty_stun_resistance"] = ::setStunResistance;
	level.perkUnsetFuncs["specialty_stun_resistance"] = ::unsetStunResistance;

	level.perkSetFuncs["specialty_marksman"] = ::setMarksman;
	level.perkUnsetFuncs["specialty_marksman"] = ::unsetMarksman;

	level.perkSetFuncs["specialty_double_load"] = ::setDoubleLoad;
	level.perkUnsetFuncs["specialty_double_load"] = ::unsetDoubleLoad;

	level.perkSetFuncs["specialty_sharp_focus"] = ::setSharpFocus;
	level.perkUnsetFuncs["specialty_sharp_focus"] = ::unsetSharpFocus;

	level.perkSetFuncs["specialty_hard_shell"] = ::setHardShell;
	level.perkUnsetFuncs["specialty_hard_shell"] = ::unsetHardShell;

	level.perkSetFuncs["specialty_regenspeed"] = ::setRegenSpeed;
	level.perkUnsetFuncs["specialty_regenspeed"] = ::unsetRegenSpeed;

	level.perkSetFuncs["specialty_autospot"] = ::setAutoSpot;
	level.perkUnsetFuncs["specialty_autospot"] = ::unsetAutoSpot;

	level.perkSetFuncs["specialty_empimmune"] = ::setEmpImmune;
	level.perkUnsetFuncs["specialty_empimmune"] = ::unsetEmpImmune;

	level.perkSetFuncs["specialty_overkill_pro"] = ::setOverkillPro;
	level.perkUnsetFuncs["specialty_overkill_pro"] = ::unsetOverkillPro;
	
	level.perkSetFuncs["specialty_personaluav"] = ::setPersonalUav;
	level.perkUnsetFuncs["specialty_personaluav"] = ::unsetPersonalUav;
	
	level.perkSetFuncs["specialty_crouchmovement"] = ::setCrouchMovement;
	level.perkUnsetFuncs["specialty_crouchmovement"] = ::unsetCrouchMovement;
		
	
	

	// death streaks
	level.perkSetFuncs["specialty_combathigh"] = ::setCombatHigh;
	level.perkUnsetFuncs["specialty_combathigh"] = ::unsetCombatHigh;

	level.perkSetFuncs["specialty_light_armor"] = ::setLightArmor;
	level.perkUnsetFuncs["specialty_light_armor"] = ::unsetLightArmor;

	level.perkSetFuncs["specialty_revenge"] = ::setRevenge;
	level.perkUnsetFuncs["specialty_revenge"] = ::unsetRevenge;

	level.perkSetFuncs["specialty_c4death"] = ::setC4Death;
	level.perkUnsetFuncs["specialty_c4death"] = ::unsetC4Death;

	level.perkSetFuncs["specialty_finalstand"] = ::setFinalStand;
	level.perkUnsetFuncs["specialty_finalstand"] = ::unsetFinalStand;

	level.perkSetFuncs["specialty_juiced"] = ::setJuiced;
	level.perkUnsetFuncs["specialty_juiced"] = ::unsetJuiced;

	level.perkSetFuncs["specialty_carepackage"] = ::setCarePackage;
	level.perkUnsetFuncs["specialty_carepackage"] = ::unsetCarePackage;

	level.perkSetFuncs["specialty_stopping_power"] = ::setStoppingPower;
	level.perkUnsetFuncs["specialty_stopping_power"] = ::unsetStoppingPower;

	level.perkSetFuncs["specialty_uav"] = ::setUAV;
	level.perkUnsetFuncs["specialty_uav"] = ::unsetUAV;
	// end death streaks

	initPerkDvars();
	
	maps\mp\perks\activecloaking::init();

	level thread onPlayerConnect();
}

precacheShaders()
{
	precacheShader( "specialty_blastshield" );
}

validatePerk( perkIndex, perkName )
{
	if ( getDvarInt ( "scr_game_perks" ) == 0 )
	{
		if ( tableLookup( "mp/perkTable.csv", 1, perkName, 5 ) != "equipment" )
			return "specialty_null";
	}

	/* Validation disabled for now
	if ( tableLookup( "mp/perkTable.csv", 1, perkName, 5 ) != ("perk"+perkIndex) )
	{
		println( "^1Warning: (" + self.name + ") Perk " + perkName + " is not allowed for perk slot index " + perkIndex + "; replacing with no perk" );
		return "specialty_null";
	}
	*/

	return perkName;
}

getEmptyPerks()
{
	perks=[];
	for (i=0; i<6; i++)
		perks[i] = "specialty_null";
	return perks;
}

onPlayerConnect()
{
	for(;;)
	{
		level waittill( "connected", player );
		player thread onPlayerSpawned();
	}
}

onPlayerSpawned()
{
	self endon( "disconnect" );

	self.perks = [];
	self.weaponList = [];
	self.omaClassChanged = false;

	for( ;; )
	{
		self waittill( "spawned_player" );

		self.omaClassChanged = false;
		//self thread gambitUseTracker();
		//self initializeProximityPerks();
		self thread playerProximityTracker();
		self thread maps\mp\gametypes\_scrambler::scramblerProximityTracker();
	}
}


playerProximityTracker()
{
	self endon( "disconnect" );
	self endon( "death" );
	self endon( "faux_spawn" );
	level endon( "game_ended" );

	self.proximityActive = false;

	for( ;; )
	{
		foreach( player in level.players )
		{
			wait( 0.05 );

			if ( !isDefined( player ) )
				continue;

			if ( player.team != self.team )
				continue;

			if ( player == self )
				continue;

			if ( !isReallyAlive( player ) )
				continue;

			if ( !isReallyAlive(self) )
				continue;
			
			distance = DistanceSquared( player.origin, self.origin );
			if ( distance < 262144 ) //512^2  (in proximity)
			{
				self.proximityActive = true;
				break;
			}
		}		
			
		wait( 0.25 );
	}
}

/* No longer in use IW5
proxyPerkPlayerDiscoWaiter( playerToWatch )
{
	self notify( "proxyPerkPlayerDiscoWaiter" );
	self endon( "proxyPerkPlayerDiscoWaiter" );

	self endon( "disconnect" );
	self endon( "death" );
	level endon( "game_ended" );

	playerToWatch endon( "removedFromProxy" );

	playerToWatch waittill( "disconnect" );
	self proxyPerkRemover( playerToWatch );
	self.proxTeam = self cleanArray( self.proxTeam );
}


proxyPerkActivator( newPlayer )
{
	self endon( "disconnect" );
	self endon( "death" );
	level endon( "game_ended" );


	if ( !isDefined( newPlayer.proximityPerk ) )
		wait 1; //if a player spawns they sometimes will not have this active


	if ( !isDefined( newPlayer ) || !isReallyAlive( newPlayer ) )
	{
		playerRemoved = false;

		foreach ( index, member in self.proxTeam) //prunes from proxTeam array
		{
			if ( member == newPlayer ) //no longer within proximity.
			{
				self.proxTeam[index] = undefined;
				newPlayer notify( "removedFromProxy" );
				playerRemoved = true;
			}
		}

		if ( playerRemoved )
			self.proxTeam = self cleanArray( self.proxTeam );

		playerRemoved = false;
	}


	if ( self.proxTeam.size == 1 && !self.activatedProxyPerk  )
	{
		if ( self.proximityPerk == "stoppingPower" )
		{
			self.stoppingPowerLevel += .33;
			self.activatedProxyPerk = true;
		}
		else if ( self.proximityPerk == "healthRegen" )
		{
			self.healthRegenLevel += .33;
			self.activatedProxyPerk = true;
		}
		else if ( self.proximityPerk == "blastShield" )
		{
			self.blastShieldLevel += .33;
			self.activatedProxyPerk = true;
		}
	}

	//stopping power proxy perk
	if ( self.stoppingPowerLevel < .99 )
	{
		if ( newPlayer.proximityPerk == "stoppingPower" )
			self.stoppingPowerLevel += .33;

		if ( self.stoppingPowerLevel == .33 ) //level1
		{
			self.proxIcon1.alpha = 1;
			self.proxIcon1_Level1.alpha = 1;
		}
		else if ( self.stoppingPowerLevel == .66 ) //level2
		{
			self.proxIcon1_Level1.alpha = 1;
			self.proxIcon1_Level2.alpha = 1;
		}
		else if ( self.stoppingPowerLevel == .99 ) //level3
		{
			self.proxIcon1_Level1.alpha = 1;
			self.proxIcon1_Level2.alpha = 1;
			self.proxIcon1_Level3.alpha = 1;
		}
	}

	//healthRegen proxy perk
	if ( self.healthRegenLevel < .99 )
	{
		if (  isDefined( newPlayer.proximityPerk ) && newPlayer.proximityPerk == "healthRegen" )
			self.healthRegenLevel += .33;

		if ( self.healthRegenLevel == .33 ) //level1
		{
			self.proxIcon2.alpha = 1;
			self.proxIcon2_Level1.alpha = 1;
		}
		else if ( self.healthRegenLevel == .66 ) //level2
		{
			self.proxIcon2_Level1.alpha = 1;
			self.proxIcon2_Level2.alpha = 1;
		}
		else if ( self.healthRegenLevel == .99 ) //level3
		{
			self.proxIcon2_Level1.alpha = 1;
			self.proxIcon2_Level2.alpha = 1;
			self.proxIcon2_Level3.alpha = 1;
		}
	}

	//blastshield proxy perk
	if ( self.blastShieldLevel < .99 )
	{
		if (  isDefined( newPlayer.proximityPerk ) && newPlayer.proximityPerk == "blastShield" )
			self.blastShieldLevel += .33;

		if ( self.blastShieldLevel == .33 ) //level1
		{
			self.proxIcon3.alpha = 1;
			self.proxIcon3_Level1.alpha = 1;
		}
		else if ( self.blastShieldLevel == .66 ) //level2
		{
			self.proxIcon3_Level1.alpha = 1;
			self.proxIcon3_Level2.alpha = 1;
		}
		else if ( self.blastShieldLevel == .99 ) //level3
		{
			self.proxIcon3_Level1.alpha = 1;
			self.proxIcon3_Level2.alpha = 1;
			self.proxIcon3_Level3.alpha = 1;
		}
	}

}

proxyPerkRemover( removedPlayer )
{
	self endon( "disconnect" );
	self endon( "death" );
	level endon( "game_ended" );

	if ( self.stoppingPowerLevel > 0 )
	{
		if ( removedPlayer.proximityPerk == "stoppingPower" )
			self.stoppingPowerLevel -= .33;

		if ( self.proxTeam.size == 0 && self.proximityPerk == "stoppingPower" )
		{
			if ( self.stoppingPowerLevel > 0 )
				self.stoppingPowerLevel -= .33;

			self.activatedProxyPerk = false;
		}

		if ( self.stoppingPowerLevel == 0 )
		{
			self.proxIcon1.alpha = 0.5;
			self.proxIcon1_Level1.alpha = 0;
			self.proxIcon1_Level2.alpha = 0;
			self.proxIcon1_Level3.alpha = 0;
		}
		else if ( self.stoppingPowerLevel == .33 )
		{
			self.proxIcon1_Level2.alpha = 0;
			self.proxIcon1_Level3.alpha = 0;
		}
		else if ( self.stoppingPowerLevel == .66 )
		{
			self.proxIcon1_Level3.alpha = 0;
		}
	}

	if ( self.healthRegenLevel > 0 )
	{
		if ( removedPlayer.proximityPerk == "healthRegen" )
			self.healthRegenLevel -= .33;

		if ( self.proxTeam.size == 0 && self.proximityPerk == "healthRegen" )
		{
			if ( self.healthRegenLevel > 0 )
				self.healthRegenLevel -= .33;

			self.activatedProxyPerk = false;
		}

		if ( self.healthRegenLevel == 0 )
		{
			self.proxIcon2.alpha = 0.5;
			self.proxIcon2_Level1.alpha = 0;
			self.proxIcon2_Level2.alpha = 0;
			self.proxIcon2_Level3.alpha = 0;
		}
		else if ( self.healthRegenLevel == .33 )
		{
			self.proxIcon2_Level2.alpha = 0;
			self.proxIcon2_Level3.alpha = 0;
		}
		else if ( self.healthRegenLevel == .66 )
		{
			self.proxIcon2_Level3.alpha = 0;
		}
	}

	if ( self.blastShieldLevel > 0 )
	{
		if ( removedPlayer.proximityPerk == "blastShield" )
			self.blastShieldLevel -= .33;

		if ( self.proxTeam.size == 0 && self.proximityPerk == "blastShield" )
		{
			if ( self.blastShieldLevel > 0 )
				self.blastShieldLevel -= .33;

			self.activatedProxyPerk = false;
		}

		if ( self.blastShieldLevel == 0 )
		{
			self.proxIcon3.alpha = 0.5;
			self.proxIcon3_Level1.alpha = 0;
			self.proxIcon3_Level2.alpha = 0;
			self.proxIcon3_Level3.alpha = 0;
		}
		else if ( self.blastShieldLevel == .33 )
		{
			self.proxIcon3_Level2.alpha = 0;
			self.proxIcon3_Level3.alpha = 0;
		}
		else if ( self.blastShieldLevel == .66 )
		{
			self.proxIcon3_Level3.alpha = 0;
		}
	}

}
 */

drawLine( start, end, timeSlice )
{
	drawTime = int(timeSlice * 20);
	for( time = 0; time < drawTime; time++ )
	{
		line( start, end, (1,0,0),false, 1 );
		wait ( 0.05 );
	}
}


cac_modified_damage( victim, attacker, damage, meansofdeath, weapon, impactPoint, impactDir, hitLoc )
{
	assert( isPlayer( victim ) );
	assert( isDefined( victim.team ) );

	damageAdd = 0;

	// NOTE: not sure why this was here, commenting out for now
	//if( ( victim.xpScaler == 2 && isDefined( attacker ) ) && ( isPlayer( attacker ) || attacker.classname == "script_vehicle" ) )
	//	damageAdd += 200;

	if( isBulletDamage( meansOfDeath ) )
	{
		assert( isDefined( attacker ) );

		// show the victim on the minimap for N seconds
		if( IsPlayer( attacker ) && attacker _hasPerk( "specialty_paint_pro" ) && !isKillstreakWeapon( weapon ) )
		{
			// make sure they aren't already painted before we process the challenge
			if( !victim isPainted() )
				attacker maps\mp\gametypes\_missions::processChallenge( "ch_bulletpaint" );

			victim thread maps\mp\perks\_perkfunctions::setPainted();
		}
		
		//20% damage reduction for using silencer on sniper since range reduction has no effect on snipers. 
		if( IsPlayer( attacker ) && isDefined( weapon ) && getWeaponClass( weapon ) == "weapon_sniper" && isSubStr( weapon, "silencer" ) )
			damage *= 0.75;

		// stopping power and armor vest cancel each other out
		if( IsPlayer( attacker ) && 
			( attacker _hasPerk( "specialty_bulletdamage" ) && victim _hasPerk( "specialty_armorvest" ) ) )
		{
			damageAdd += 0;
		}
		// if the attacker has the stopping power or has the more damage weapon buff
		else if( IsPlayer( attacker ) && 
			( attacker _hasPerk( "specialty_bulletdamage" ) || 
			attacker _hasPerk( "specialty_moredamage" ) ) ) 
		{
			damageAdd += damage * level.bulletDamageMod;
		}
		// if the victim has armor vest take some damage off
		else if ( victim _hasPerk( "specialty_armorvest" ) )
		{
			damageAdd -= damage * level.armorVestMod;
		}

		// let's handle juggernaut damaging here
		if( victim isJuggernaut() )
		{
			damage *= level.juggernautMod;

			// TODO: maybe bring this back if we think jugg needs a good counter
			//// player shooting jugg
			//if( IsPlayer( attacker ) )
			//{
			//	if( weaponInheritsPerks( weapon ) )
			//	{
			//		if( attacker _hasPerk( "specialty_armorpiercing" ) )
			//		{
			//			damage = damage * level.armorPiercingMod;
			//		}
			//	}
			//}
		}
	}
	else if( IsExplosiveDamageMOD( meansOfDeath ) )
	{
		// show the victim on the minimap for N seconds
		if( IsPlayer( attacker ) && 
			attacker != victim && 
			( attacker IsItemUnlocked( "specialty_paint" ) && attacker _hasPerk( "specialty_paint" ) ) && !isKillstreakWeapon( weapon ) )
		{
			if( !victim isPainted() )
				attacker maps\mp\gametypes\_missions::processChallenge( "ch_paint_pro" );		

			victim thread maps\mp\perks\_perkfunctions::setPainted();
		}

		if ( isPlayer( attacker ) && weaponInheritsPerks( weapon ) && 
			( ( attacker _hasPerk( "specialty_explosivedamage" ) ) && victim _hasPerk( "_specialty_blastshield" ) ) )
		{
			damageAdd += 0;
		}
		else if ( isPlayer( attacker ) && weaponInheritsPerks( weapon ) && 
			( attacker _hasPerk( "specialty_explosivedamage" ) ) )
		{
			damageAdd += damage*level.explosiveDamageMod;
		}
		else if ( victim _hasPerk( "_specialty_blastshield" ) && ( weapon != "semtex_mp" || damage != 120 ) )
			damageAdd -= int( damage * ( 1 - level.blastShieldMod ) );

		if ( isKillstreakWeapon( weapon ) && isPlayer( attacker ) && 
			( attacker _hasPerk( "specialty_explosivedamage" ) ) )
		{
			damageAdd += damage*level.explosiveDamageMod;
		}

		// let's handle juggernaut damaging here
		if( victim isJuggernaut() )
		{
			switch( weapon )
			{
			case "ac130_25mm_mp": // this is because the 25mm shoots a bunch of bullets and can do over 1000 with multiple hits at once
				damage *= level.juggernautMod;
				break;

			case "remote_mortar_missile_mp": // jugg will be able to take 3 hits from reaper if full health
				damage *= 0.2; // 20% of 200(max damage in gdt) is 40
				break;

			default:
				if ( damage < 1000 ) 	
				{
					if ( damage > 1 )
						damage *= level.juggernautMod;
				}
				break;
			}
		}
		
		//fix for grenade spam at start of round
		if ( ( 10 - (level.gracePeriod - level.inGracePeriod) ) > 0 )
			damage *= level.juggernautMod;
		
	}
	else if( meansOfDeath == "MOD_FALLING" )
	{
		if( victim IsItemUnlocked( "specialty_falldamage" ) && victim _hasPerk( "specialty_falldamage" ) )
		{
			if( damage > 0 )
				victim maps\mp\gametypes\_missions::processChallenge( "ch_falldamage" );

			//eventually set a msg to do a roll
			damageAdd = 0;
			damage = 0;
		}
	}
	else if( meansOfDeath == "MOD_MELEE" )
	{
		if ( isDefined( victim.hasLightArmor ) && victim.hasLightArmor )
		{
			if ( IsSubStr( weapon, "riotshield" ) )
				damage = Int(victim.maxHealth*0.66);
			else //knife
				damage = victim.maxHealth+1;
		}

		// let's handle juggernaut damaging here
		if( victim isJuggernaut() )
		{
			damage = 20;
			damageAdd = 0;
		}
	}
	else if( meansOfDeath == "MOD_IMPACT" )
	{
		// let's handle juggernaut damaging here
		if( victim isJuggernaut() )
		{
			switch( weapon )
			{
			case "concussion_grenade_mp":
			case "flash_grenade_mp":
			case "smoke_grenade_mp":
			case "frag_grenade_mp":
			case "semtex_mp":
				damage = 5;
				break;
			
			default:
				if( damage < 1000 )
					damage = 25;
				break;
			}

			damageAdd = 0;
		}
	}

	if ( victim _hasperk( "specialty_combathigh" ) )
	{
		if ( IsDefined( self.damageBlockedTotal ) && (!level.teamBased || (isDefined( attacker ) && isDefined( attacker.team ) && victim.team != attacker.team)) )
		{
			damageTotal = damage + damageAdd;
			damageBlocked = (damageTotal - ( damageTotal / 3 ));
			self.damageBlockedTotal += damageBlocked;

			if ( self.damageBlockedTotal >= 101 )
			{
				self notify( "combathigh_survived" );
				self.damageBlockedTotal = undefined;
			}
		}

		if ( weapon != "throwingknife_mp" )
		{
			switch ( meansOfDeath )
			{
				case "MOD_FALLING":
				case "MOD_MELEE":
					break;
				default:
					damage = Int( damage/3 );
					damageAdd = Int( damageAdd/3 );
					break;
			}
		}

	}

	if ( isDefined( victim.hasLightArmor ) && victim.hasLightArmor && weapon == "throwingknife_mp" )
	{
		damage = victim.health;
		damageAdd = 0;
	}
	
	/#
		if ( getDvar( "scr_devPrintDamage" ) != "" )
		{
			IPrintLn( damage + damageAdd );
		}
	#/

	if ( damage <= 1 )
	{	
		damage = 1;
		return damage;
	}
	else
		return int( damage + damageAdd );
}

initPerkDvars()
{
	level.juggernautMod = 8/100;		// percentage of damage juggernaut takes
	level.juggernatuDefMod = 8/100;		// percentage of damage juggernaut takes
	level.armorPiercingMod = 1.5;		// increased bullet damage * this on vehicles and juggernauts
	level.regenHealthMod = 0.25;		// regen health at a percent of the normal speed

	level.bulletDamageMod =		getIntProperty( "perk_bulletDamage",	12 )/100;	// increased bullet damage by this % //using 12% of base 30 change 4 - 3 rnds to kill
	level.explosiveDamageMod =	getIntProperty( "perk_explosiveDamage", 40 )/100;	// increased explosive damage by this %
	level.blastShieldMod =		getIntProperty( "perk_blastShield",		40 )/100;	// percentage of damage subtracted from total damage
	level.riotShieldMod =		getIntProperty( "perk_riotShield",		100 )/100;
	level.armorVestMod =		getIntProperty( "perk_armorVest",		20 )/100;	// percentage of damage subtracted from total damage
	
	if( IsDefined( level.hardcoreMode ) && level.hardcoreMode )
	{
		level.blastShieldMod = getIntProperty( "perk_blastShield_hardcore", 45 )/100;		// percentage of damage you take
	}
}

// CAC: Selector function, calls the individual cac features according to player's class settings
// Info: Called every time player spawns during loadout stage
cac_selector()
{
	perks = self.specialty;

	/*
	self.detectExplosives = false;

	if ( self _hasPerk( "specialty_detectexplosive" ) )
		self.detectExplosives = true;

	maps\mp\gametypes\_weapons::setupBombSquad();
	*/
}


gambitUseTracker()
{
	self endon ( "death" );
	self endon ( "disconnect" );
	level endon ( "game_ended" );

	if ( getDvarInt ( "scr_game_perks" ) != 1 )
		return;

	gameFlagWait( "prematch_done" );

	self notifyOnPlayerCommand( "gambit_on", "+frag" );
}

giveBlindEyeAfterSpawn()
{
	self endon( "death" );
	self endon( "disconnect" );

	self givePerk( "specialty_blindeye", false );
	self.spawnPerk = true;
	while( self.avoidKillstreakOnSpawnTimer > 0 )
	{
		self.avoidKillstreakOnSpawnTimer -= 0.05;
		wait( 0.05 );
	}

	self _unsetPerk( "specialty_blindeye" );
	self.spawnPerk = false;
}

applyPerkStack()
{
	self notify("new_perk_stack");
	stackCount = [];
	stackCount["specialty_class_sleightofhand"] = 0;
	stackCount["specialty_class_quickdraw"] = 0;
	stackCount["specialty_class_extremeconditioning"] = 0;
	stackCount["specialty_class_assassin"] = 0;
	stackCount["specialty_class_scavenger"] = 0;
	stackCount["specialty_class_hardline"] = 0;
	self.lightwghtscalar = undefined;
	self.stalkerscalar = undefined;
	self.activemovescalar = undefined;
	self.extraammo_fraction = undefined;
	// We may need to turn off all perks before this (must ensure the class perks aren't reset)
	
	for (i=0; i<6; i++)
	{
		foreach (perk, count in stackCount)
		{
			if (self HasPerk( perk, false, i ))
			{
				stackCount[ perk ]++;
			}
		}
	}
	// now we'll apply them as appropriate
	if (stackCount["specialty_class_sleightofhand"] > 0)
	{
		stackCnt = stackCount["specialty_class_sleightofhand"];
		if (stackCnt >= 4)
		{
			givePerk( "specialty_sprintreload", false );
		}
		// the rest of sleightofhand is handled in code
	}
	// quickdraw is handled in code
	if (stackCount["specialty_class_extremeconditioning"] > 0)
	{
		stackCnt = stackCount["specialty_class_extremeconditioning"];
		self.lightwghtscalar = float( TableLookup( "mp/perkStack.csv", 0, "specialty_lightweight", stackCnt ) );
		self.stalkerscalar = float( TableLookup( "mp/perkStack.csv", 0, "specialty_stalker", stackCnt ) );
		self.activemovescalar = self.lightweightscalar;
		givePerk( "specialty_lightweight", false );
		givePerk( "specialty_stalker", false );
		self thread stalker_monitor();
		/* Latest integration removes fastmantle, but gives us smoothmantle (not a perk)
		if (stackCnt >= 3)
		{
			givePerk( "specialty_fastmantle", false );
			// TODO: Need to add support to scale the fastmantle
		}
		*/
		if (stackCnt >= 6)
		{
			givePerk( "specialty_marathon", false );
		}
	}
	if (stackCount["specialty_class_assassin"] > 0)
	{
		stackCnt = stackCount["specialty_class_assassin"];
		givePerk( "specialty_quieter", false );
		givePerk( "specialty_selectivehearing", false );
		if ( stackCnt > 1 )
			givePerk( "specialty_coldblooded", false );
		if ( stackCnt > 2 )
		{
			givePerk( "specialty_empimmune", false );
			givePerk( "specialty_spygame", false );
			// rad tag doesn't show up
		}
		if ( stackCnt > 3 )
		{
			givePerk( "specialty_blindeye", false );
			// hidden to sentry guns
		}
		if ( stackCnt > 4 )
		{
			givePerk( "specialty_detectgrenade", false );
			givePerk( "specialty_moreminimap", false );
			givePerk( "specialty_activecloaking", false );
			self thread maps\mp\perks\activecloaking::active_cloaking_monitor();
		}
		if ( stackCnt > 5 )
		{
			givePerk( "specialty_personaluav", false );
		}
	}
	if (stackCount["specialty_class_scavenger"] > 0)
	{
		stackCnt = stackCount["specialty_class_scavenger"];
		
		//scaler to determine how much extra ammo is pickedup
		self.ammopickup_scalar = float( TableLookup( "mp/perkStack.csv", 0, "specialty_scavenger", stackCnt ) );
		givePerk( "specialty_scavenger", false );
			
		// TODO: Need to add support to scale the % of Bullet Ammo Pickups
		if (stackCnt > 1)
		{
			self.extraammo_fraction = float( TableLookup( "mp/perkStack.csv", 0, "specialty_extraammo", stackCnt ) );
			givePerk( "specialty_extraammo", false );
			givePerk( "specialty_explosiveammoresupply", false );
		}
		if (stackCnt > 2)
		{
			givePerk( "specialty_tacticalresupply", false );
		}
		if (stackCnt > 3)
		{
			givePerk( "specialty_lethalresupply", false );
		}
		if (stackCnt > 4)
		{
			givePerk( "specialty_extratactical", false );
			offhandWeapons = self getWeaponsListOffhands();
			foreach ( offhand in offhandWeapons )
			{
				if( maps\mp\gametypes\_class::isValidOffhand( offhand ) )
				{
					currentClipAmmo = self GetWeaponAmmoClip( offhand );
					self SetWeaponAmmoClip( offhand, currentClipAmmo + 1 );
				}
			}
			
		}
		if (stackCnt > 5)
		{
			givePerk( "specialty_extralethal", false );
			
			offhandWeapons = self getWeaponsListOffhands();
			foreach ( offhand in offhandWeapons )
			{
				if( maps\mp\gametypes\_class::isValidEquipment( offhand ) )
				{
					currentClipAmmo = self GetWeaponAmmoClip( offhand );
					self SetWeaponAmmoClip( offhand, currentClipAmmo + 1 );
				}
			}
		}
	}
	if (stackCount["specialty_class_hardline"] > 0)
	{
		stackCnt = stackCount["specialty_class_hardline"];
		givePerk( "specialty_hardline", false );
		if (stackCnt > 1)
		{
			//givePerk( "specialty_adrenaline_bonus_assist", false );
			givePerk( "specialty_assists", false );

		}
		if (stackCnt > 2)
		{
			//givePerk( "specialty_adrenaline_bonus_headshot", false ); //removing for opness
			givePerk( "specialty_adrenaline_bonus_capture", false );
			givePerk( "specialty_adrenaline_bonus_assistedCapture", false );
			givePerk( "specialty_adrenaline_bonus_plant", false );
			givePerk( "specialty_adrenaline_bonus_defuse", false );
			
			givePerk( "specialty_greater_killstreaks", false );
		}
		if (stackCnt > 3)
		{
			givePerk( "specialty_killstreaks_chain", false );
			
		}
		if (stackCnt > 4)
		{
			givePerk( "specialty_extra_killstreak", false ); //gives extra killstreak in the menus
		}
		if (stackCnt > 5)
		{
			givePerk( "specialty_hardline2", false );
			//givePerk( "specialty_undying_killstreaks", false ); //removing for opness
		}
	}
}

stalker_monitor()
{
	self endon("connect");
	self endon("disconnect");
	self endon("death");
	self endon("new_perk_stack");
	
	if (self PlayerADS() < 0.5)
		inADS = true;
	else
		inADS = false;
	
	while (true)
	{
		if ( !inADS && ( (self PlayerAds()) >= 0.5 ) )
		{
			self.activemovescalar = self.stalkerscalar;
			setLightWeight();
			inADS = true;
		}
		else if ( inADS && ( (self PlayerAds()) < 0.5 ) )
		{
			self.activemovescalar = self.lightwghtscalar;
			setLightWeight();
			inADS = false;
		}
		wait 0.05;
	}
}
