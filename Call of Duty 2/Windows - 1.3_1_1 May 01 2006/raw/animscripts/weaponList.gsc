// Weapon configuration for anim scripts.
// Supplies information for all AI weapons.
#using_animtree ("generic_human");


usingAutomaticWeapon()
{
	return (anim.AIWeapon[tolower(self.weapon)]["type"] == "auto");
}

usingSemiAutoWeapon()
{
	return (anim.AIWeapon[tolower(self.weapon)]["type"] == "semi");
}

autoShootAnimRate()
{
	if (usingAutomaticWeapon())
	{
		// The auto fire animation fires 10 shots a second, so we divide the weapon's fire rate by 
		// 10 to get the correct anim playback rate.
		return (anim.AIWeapon[tolower(self.weapon)]["rate"]) / 10.0;
	}
	else
	{
//		println ("weaponList::standAimShootAnims: No auto fire rate for "+self.weapon);
		return 0.2;	// Equates to 2 shots a second, decent for a non-auto weapon.
	}
}

waitAfterShot()
{
	return 0.25;
}

shootAnimTime()
{
	if (usingAutomaticWeapon())
	{
		return 1 / (anim.AIWeapon[tolower(self.weapon)]["rate"]);
	}
	else
	{
		// We randomize the result a little from the real time, just to make things more 
		// interesting.  In reality, the 20Hz server is going to make this much less variable.
//		rand = 0.8 + randomfloat(0.4);
		rand = 0.5 + randomfloat(1); // 0.8 + 0.4
		return (anim.AIWeapon[tolower(self.weapon)]["time"]) * rand;
	}
}

standAimShootAnims()
{
	weaponAnims = anim.AIWeapon[tolower(self.weapon)]["anims"];

	if (weaponAnims == "pistol")
	{
		aimarray["aim_down"] =		%pistol_standshoot_down;	// TODO wrong anim
		aimarray["aim_straight"] =	%pistol_standaim_idle;
		aimarray["aim_up"] =		%pistol_standshoot_up;		// TODO wrong anim
		aimarray["shoot_down"] =	%pistol_standshoot_down;
		aimarray["shoot_straight"] =%pistol_standshoot_straight;
		aimarray["shoot_up"] =		%pistol_standshoot_up;
	}
	else
	{
		weaponType = anim.AIWeapon[tolower(self.weapon)]["type"];
		switch (weaponType)
		{
		case "auto":
			aimarray["aim_down"] =		%stand_aim_down;
			aimarray["aim_straight"] =	%stand_aim_straight;
			aimarray["aim_up"] =		%stand_aim_up;
			aimarray["shoot_down"] =	%stand_shoot_auto_down;
			aimarray["shoot_straight"] =%stand_shoot_auto_straight;
			aimarray["shoot_up"] =		%stand_shoot_auto_up;
			break;
		case "semi":
			aimarray["aim_down"] =		%stand_aim_down;
			aimarray["aim_straight"] =	%stand_aim_straight;
			aimarray["aim_up"] =		%stand_aim_up;
			aimarray["shoot_down"] =	%stand_shoot_down;
			aimarray["shoot_straight"] =%stand_shoot_straight;
			aimarray["shoot_up"] =		%stand_shoot_up;
			break;
		case "bolt":
			aimarray["aim_down"] =		%stand_aim_down;
			aimarray["aim_straight"] =	%stand_aim_straight;
			aimarray["aim_up"] =		%stand_aim_up;
			aimarray["shoot_down"] =	%stand_shoot_down;
			aimarray["shoot_straight"] =%stand_shoot_straight;
			aimarray["shoot_up"] =		%stand_shoot_up;
			break;
		default:
			println ("weaponList::standAimShootAnims: Unhandled weapon type "+weaponType+"!");
			aimarray["aim_down"] =		%stand_aim_down;
			aimarray["aim_straight"] =	%stand_aim_straight;
			aimarray["aim_up"] =		%stand_aim_up;
			aimarray["shoot_down"] =	%stand_shoot_down;
			aimarray["shoot_straight"] =%stand_shoot_straight;
			aimarray["shoot_up"] =		%stand_shoot_up;
			break;
		}
	}
	return aimarray;
}

crouchAimShootAnims()
{
	weaponAnims = anim.AIWeapon[tolower(self.weapon)]["anims"];

	if (weaponAnims == "pistol")
	{
		aimarray["aim_down"] =		%pistol_crouchshoot_down;	// TODO wrong anim
		aimarray["aim_straight"] =	%pistol_crouchaim_idle;
		aimarray["aim_up"] =		%pistol_crouchshoot_up;		// TODO wrong anim
		aimarray["shoot_down"] =	%pistol_crouchshoot_down;
		aimarray["shoot_straight"] =%pistol_crouchshoot_straight;
		aimarray["shoot_up"] =		%pistol_crouchshoot_up;
	}
	else if (weaponAnims == "panzerfaust")
	{
		aimarray["aim_down"] =		%panzerfaust_crouchaim_down;
		aimarray["aim_straight"] =	%panzerfaust_crouchaim_straight;
		aimarray["aim_up"] =		%panzerfaust_crouchaim_up;
		aimarray["shoot_down"] =	%panzerfaust_crouchshoot_down;
		aimarray["shoot_straight"] =%panzerfaust_crouchshoot_straight;
		aimarray["shoot_up"] =		%panzerfaust_crouchshoot_up;
	}
	else
	{
		weaponType = anim.AIWeapon[tolower(self.weapon)]["type"];
		switch (weaponType)
		{
		case "auto":
			aimarray["aim_down"] =		%crouch_aim_down;
			aimarray["aim_straight"] =	%crouch_aim_straight;
			aimarray["aim_up"] =		%crouch_aim_up;
			aimarray["shoot_down"] =	%crouch_shoot_auto_down;
			aimarray["shoot_straight"] =%crouch_shoot_auto_straight;
			aimarray["shoot_up"] =		%crouch_shoot_auto_up;
			break;
		case "semi":
			aimarray["aim_down"] =		%crouch_aim_down;
			aimarray["aim_straight"] =	%crouch_aim_straight;
			aimarray["aim_up"] =		%crouch_aim_up;
			aimarray["shoot_down"] =	%crouch_shoot_down;
			aimarray["shoot_straight"] =%crouch_shoot_straight;
			aimarray["shoot_up"] =		%crouch_shoot_up;
			break;
		case "bolt":
			aimarray["aim_down"] =		%crouch_aim_down;
			aimarray["aim_straight"] =	%crouch_aim_straight;
			aimarray["aim_up"] =		%crouch_aim_up;
			aimarray["shoot_down"] =	%crouch_shoot_down;
			aimarray["shoot_straight"] =%crouch_shoot_straight;
			aimarray["shoot_up"] =		%crouch_shoot_up;
			break;
		default:
			println ("aim::crouchAimShootAnims: Unhandled weapon type "+weaponType+"!");
			aimarray["aim_down"] =		%crouch_aim_down;
			aimarray["aim_straight"] =	%crouch_aim_straight;
			aimarray["aim_up"] =		%crouch_aim_up;
			aimarray["shoot_down"] =	%crouch_shoot_down;
			aimarray["shoot_straight"] =%crouch_shoot_straight;
			aimarray["shoot_up"] =		%crouch_shoot_up;
			break;
		}
	}
	return aimarray;
}

RefillClip()
{
	assertEX(isDefined(anim.AIWeapon), "anim.AIWeapon is not defined");
	assertEX(isDefined(self.weapon), "Self.weapon is not defined for "+self.model);
	self.bulletsInClip = anim.AIWeapon[tolower(self.weapon)]["clipsize"];
	assertEX(isDefined(self.bulletsInClip), "RefillClip failed");
}

ClipSize()
{
    if ( self.weapon == "none" )
        return 0;
	assertEx(isdefined(anim.AIWeapon[tolower(self.weapon)]), "Weapon " + self.weapon + " is not defined in anim.aiweapon");
	return anim.AIWeapon[tolower(self.weapon)]["clipsize"];
}

// Weapon list
initWeaponList()
{
	anim.AIWeapon["none"]["type"] =			"auto";
	anim.AIWeapon["none"]["rate"] =			8.0;
	anim.AIWeapon["none"]["clipsize"] =		30;
	anim.AIWeapon["none"]["anims"] =		"rifle";

	anim.AIWeapon["bar"]["type"] =			"auto";
	anim.AIWeapon["bar"]["rate"] =			9.5;
	anim.AIWeapon["bar"]["clipsize"] =		20;
	anim.AIWeapon["bar"]["anims"] =			"rifle";
	anim.AIWeapon["bar"]["reloadSound"] 		= "weap_bar_reload_npc";

	anim.AIWeapon["bar_slow"]["type"] =			"auto";
	anim.AIWeapon["bar_slow"]["rate"] =			9.5;
	anim.AIWeapon["bar_slow"]["clipsize"] =		20;
	anim.AIWeapon["bar_slow"]["anims"] =			"rifle";
	anim.AIWeapon["bar_slow"]["reloadSound"] 	= "weap_bar_reload_npc";

	anim.AIWeapon["bergman"]["type"] =			"auto";
	anim.AIWeapon["bergman"]["rate"] =			8.0;
	anim.AIWeapon["bergman"]["clipsize"] =		30;
	anim.AIWeapon["bergman"]["anims"] =		"rifle";
	anim.AIWeapon["bergman"]["reloadSound"] 	= "weap_bar_reload_npc";

	anim.AIWeapon["bren"]["type"] =			"auto";
	anim.AIWeapon["bren"]["rate"] =			8.0;
	anim.AIWeapon["bren"]["clipsize"] =		30;
	anim.AIWeapon["bren"]["anims"] =		"rifle";
	anim.AIWeapon["bren"]["reloadSound"] 		= "weap_bren_reload_npc";

	anim.AIWeapon["colt"]["type"] =			"semi";
	anim.AIWeapon["colt"]["time"] =			0.25;
	anim.AIWeapon["colt"]["clipsize"] = 	7;
	anim.AIWeapon["colt"]["anims"] =		"pistol";
	anim.AIWeapon["colt"]["reloadSound"] 		= "weap_colt_reload_npc";

	anim.AIWeapon["enfield"]["type"] =		"bolt";
	anim.AIWeapon["enfield"]["time"] =		1.5;
	anim.AIWeapon["enfield"]["clipsize"] =	10;
	anim.AIWeapon["enfield"]["anims"] =		"rifle";
	anim.AIWeapon["enfield"]["reloadSound"] 	= "weap_enfield_reload_npc";

	anim.AIWeapon["enfield_scope"]["type"] =		"bolt";
	anim.AIWeapon["enfield_scope"]["time"] =		1.5;
	anim.AIWeapon["enfield_scope"]["clipsize"] =	10;
	anim.AIWeapon["enfield_scope"]["anims"] =		"rifle";
	anim.AIWeapon["enfield_scope"]["reloadSound"] 	= "weap_enfield_reload_npc";

	anim.AIWeapon["g43"]["type"] =		"semi";
	anim.AIWeapon["g43"]["time"] =		0.25;
	anim.AIWeapon["g43"]["clipsize"] = 	10;
	anim.AIWeapon["g43"]["anims"] =		"rifle";
	anim.AIWeapon["g43"]["reloadSound"] 		= "weap_g43_reload_npc";

	anim.AIWeapon["g43_sniper"]["type"] =		"semi";
	anim.AIWeapon["g43_sniper"]["time"] =		0.25;
	anim.AIWeapon["g43_sniper"]["clipsize"] = 	10;
	anim.AIWeapon["g43_sniper"]["anims"] =		"rifle";
	anim.AIWeapon["g43_sniper"]["reloadSound"] 		= "weap_g43_reload_npc";

	anim.AIWeapon["kar98k"]["type"] =		"bolt";
	anim.AIWeapon["kar98k"]["time"] =		1.5;
	anim.AIWeapon["kar98k"]["clipsize"] =	5;
	anim.AIWeapon["kar98k"]["anims"] =		"rifle";
	anim.AIWeapon["kar98k"]["reloadSound"] 		= "weap_kar98k_reload_npc";

	anim.AIWeapon["kar98k_sniper"]["type"] =	"bolt";
	anim.AIWeapon["kar98k_sniper"]["time"] =	1.5;
	anim.AIWeapon["kar98k_sniper"]["clipsize"] =	5;
	anim.AIWeapon["kar98k_sniper"]["anims"] =	"rifle";
	anim.AIWeapon["kar98k"]["reloadSound"] 		= "weap_kar98k_reload_npc";

	anim.AIWeapon["luger"]["type"] =		"semi";
	anim.AIWeapon["luger"]["time"] =		0.2;
	anim.AIWeapon["luger"]["clipsize"] = 	8;
	anim.AIWeapon["luger"]["anims"] =		"pistol";
	anim.AIWeapon["luger"]["reloadSound"] 		= "weap_luger_reload_npc";

	anim.AIWeapon["m1carbine"]["type"] =		"semi";
	anim.AIWeapon["m1carbine"]["time"] =		0.25;
	anim.AIWeapon["m1carbine"]["clipsize"] = 	10;
	anim.AIWeapon["m1carbine"]["anims"] =		"rifle";
	anim.AIWeapon["m1carbine"]["reloadSound"] 	= "weap_m1carbine_reload_npc";

	anim.AIWeapon["m1garand"]["type"] =			"semi";
	anim.AIWeapon["m1garand"]["time"] =			0.3;
	anim.AIWeapon["m1garand"]["clipsize"] =		8;
	anim.AIWeapon["m1garand"]["anims"] =		"rifle";
	anim.AIWeapon["m1garand"]["reloadSound"]	= "weap_m1garand_reload_npc";

	anim.AIWeapon["mosin_nagant"]["type"] =		"bolt";
	anim.AIWeapon["mosin_nagant"]["time"] =		1.5;
	anim.AIWeapon["mosin_nagant"]["clipsize"] =	20;
	anim.AIWeapon["mosin_nagant"]["anims"] =	"rifle";
	anim.AIWeapon["mosin_nagant"]["reloadSound"]= "weap_nagant_reload_npc";
	
	anim.AIWeapon["mosin_nagant_sniper"]["type"] =		"bolt";
	anim.AIWeapon["mosin_nagant_sniper"]["time"] =		1.5;
	anim.AIWeapon["mosin_nagant_sniper"]["clipsize"] =	20;
	anim.AIWeapon["mosin_nagant_sniper"]["anims"] =		"rifle";
	anim.AIWeapon["mosin_nagant"]["reloadSound"]= "weap_nagant_reload_npc";
	
	anim.AIWeapon["mp40"]["type"] =			"auto";
	anim.AIWeapon["mp40"]["rate"] =			8.0;
	anim.AIWeapon["mp40"]["clipsize"] =		30;
	anim.AIWeapon["mp40"]["anims"] =		"rifle";
	anim.AIWeapon["mp40"]["reloadSound"]= "weap_mp40_reload_npc";

	anim.AIWeapon["mp44"]["type"] =			"auto";
	anim.AIWeapon["mp44"]["rate"] =			8.0;
	anim.AIWeapon["mp44"]["clipsize"] =		30;
	anim.AIWeapon["mp44"]["anims"] =		"rifle";
	anim.AIWeapon["mp44"]["reloadSound"]= "weap_mp44_reload_npc";

	anim.AIWeapon["mp44_semi"]["type"] =			"auto";
	anim.AIWeapon["mp44_semi"]["rate"] =			8.0;
	anim.AIWeapon["mp44_semi"]["clipsize"] =		30;
	anim.AIWeapon["mp44_semi"]["anims"] =		"rifle";
	anim.AIWeapon["mp44"]["reloadSound"]= "weap_mp44_reload_npc";

	anim.AIWeapon["pps42"]["type"] =		"auto";
	anim.AIWeapon["pps42"]["rate"] =			8.0;
	anim.AIWeapon["pps42"]["clipsize"] =		30;
	anim.AIWeapon["pps42"]["anims"] =		"rifle";
	anim.AIWeapon["pps42"]["reloadSound"]= "weap_ppsh42_reload_npc";

	anim.AIWeapon["ppsh"]["type"] =			"auto";
	anim.AIWeapon["ppsh"]["rate"] =			15.0;
	anim.AIWeapon["ppsh"]["clipsize"] =		71;
	anim.AIWeapon["ppsh"]["anims"] =		"rifle";
	anim.AIWeapon["ppsh"]["reloadSound"]= "weap_ppsh_reload_npc";

	anim.AIWeapon["ppsh_semi"]["type"] =			"auto";
	anim.AIWeapon["ppsh_semi"]["rate"] =			15.0;
	anim.AIWeapon["ppsh_semi"]["clipsize"] =		71;
	anim.AIWeapon["ppsh_semi"]["anims"] =		"rifle";
	anim.AIWeapon["ppsh"]["reloadSound"]= "weap_ppsh_reload_npc";

	anim.AIWeapon["springfield"]["type"] =		"bolt";
	anim.AIWeapon["springfield"]["time"] =		1.5;
	anim.AIWeapon["springfield"]["clipsize"] =	5;
	anim.AIWeapon["springfield"]["anims"] =		"rifle";
	anim.AIWeapon["springfield"]["reloadSound"]= "weap_springfield_reload_npc";

	anim.AIWeapon["sten"]["type"] =			"auto";
	anim.AIWeapon["sten"]["rate"] =			10.0;
	anim.AIWeapon["sten"]["clipsize"] =		32;
	anim.AIWeapon["sten"]["anims"] =		"rifle";
	anim.AIWeapon["sten"]["reloadSound"]= "weap_sten_reload_npc";

	anim.AIWeapon["svt40"]["type"] =			"semi";
	anim.AIWeapon["svt40"]["time"] =			0.3;
	anim.AIWeapon["svt40"]["clipsize"] =		8;
	anim.AIWeapon["svt40"]["anims"] =		"rifle";
	anim.AIWeapon["svt40"]["reloadSound"]= "weap_svt40_reload_npc";

	anim.AIWeapon["thompson"]["type"] =			"auto";
	anim.AIWeapon["thompson"]["rate"] =			12.0;
	anim.AIWeapon["thompson"]["clipsize"] =		30;
	anim.AIWeapon["thompson"]["anims"] =		"rifle";
	anim.AIWeapon["thompson"]["reloadSound"]= "weap_thompson_reload_npc";

	anim.AIWeapon["thompson_semi"]["type"] =			"auto";
	anim.AIWeapon["thompson_semi"]["rate"] =			12.0;
	anim.AIWeapon["thompson_semi"]["clipsize"] =		30;
	anim.AIWeapon["thompson_semi"]["anims"] =		"rifle";
	anim.AIWeapon["thompson"]["reloadSound"]= "weap_thompson_reload_npc";

	anim.AIWeapon["tt30"]["type"] =		"semi";
	anim.AIWeapon["tt30"]["time"] =		0.2;
	anim.AIWeapon["tt30"]["clipsize"] = 	8;
	anim.AIWeapon["tt30"]["anims"] =		"pistol";
	anim.AIWeapon["tt30"]["reloadSound"]= "weap_webley_reload_npc";

	anim.AIWeapon["webley"]["type"] =		"semi";
	anim.AIWeapon["webley"]["time"] =		0.2;
	anim.AIWeapon["webley"]["clipsize"] = 	8;
	anim.AIWeapon["webley"]["anims"] =		"pistol";
	anim.AIWeapon["webley"]["reloadSound"]= "weap_webley_reload_npc";

	//The AI Overlay for squad role title is done in the weapon (bleh!).
	//BAR_medic is a custom weapon that is taken away from the Brecourt 
	//medic at the start of the level so he appears as a "Medic" on the player's hud.

	anim.AIWeapon["30cal"]["type"] =			"auto";
	anim.AIWeapon["30cal"]["rate"] =			10.0;
	anim.AIWeapon["30cal"]["clipsize"] =		99999;	// Don't reload the 30 cal.
	anim.AIWeapon["30cal"]["anims"] =			"rifle";


	//Another instance of having to use the weapon to change the 
	//squad role overlay, this time on Private Mills in Pegasusnight
	//so he appears as an "Army Engineer"

	anim.AIWeapon["sten_engineer"]["type"] =	"auto";
	anim.AIWeapon["sten_engineer"]["rate"] =	10.0;
	anim.AIWeapon["sten_engineer"]["clipsize"] =	32;
	anim.AIWeapon["sten_engineer"]["anims"] =	"rifle";
	anim.AIWeapon["sten_engineer"]["reloadSound"]= "weap_sten_reload_npc";

	anim.AIWeapon["panzerfaust"]["type"] =		"bolt";
	anim.AIWeapon["panzerfaust"]["time"] =		3.0;
	anim.AIWeapon["panzerfaust"]["clipsize"] =	1;
	anim.AIWeapon["panzerfaust"]["anims"] =		"panzerfaust";

	anim.AIWeapon["panzerschreck"]["type"] =		"bolt";
	anim.AIWeapon["panzerschreck"]["time"] =		3.0;
	anim.AIWeapon["panzerschreck"]["clipsize"] =	1;
	anim.AIWeapon["panzerschreck"]["anims"] =		"panzerfaust";

	addTurret("panzer2_Turret");
	addTurret("flak88_turret");
	addTurret("sherman_turret");
	addTurret("flakveirling_turret");
	addTurret("armoredcar_turret");
	addTurret("buffalo_turret");
	addTurret("crusader_turret");
	addTurret("flakveirling_turret_player");
	addTurret("t34_turret");
	addTurret("tiger_turret");
}

addTurret(turret)
{
	anim.AIWeapon[tolower(turret)]["type"] = "turret";
}