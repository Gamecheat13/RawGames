// Weapon configuration for anim scripts.
// Supplies information for all AI weapons.
#using_animtree ("generic_human");


usingAutomaticWeapon()
{
	return (anim.AIWeapon[self.weapon]["type"] == "auto");
}

usingSemiAutoWeapon()
{
	return (anim.AIWeapon[self.weapon]["type"] == "semi");
}

autoShootAnimRate()
{
	if (usingAutomaticWeapon())
	{
		// The auto fire animation fires 10 shots a second, so we divide the weapon's fire rate by 
		// 10 to get the correct anim playback rate.
		return (anim.AIWeapon[self.weapon]["rate"]) / 10.0;
	}
	else
	{
		println ("weaponList::standAimShootAnims: No auto fire rate for "+self.weapon);
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
		return ((float)1) / (anim.AIWeapon[self.weapon]["rate"]);
	}
	else
	{
		// We randomize the result a little from the real time, just to make things more 
		// interesting.  In reality, the 20Hz server is going to make this much less variable.
		rand = 0.8 + randomfloat(0.4);
		return (anim.AIWeapon[self.weapon]["time"]) * rand;
	}
}

standAimShootAnims()
{
	weaponAnims = anim.AIWeapon[self.weapon]["anims"];

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
		weaponType = anim.AIWeapon[self.weapon]["type"];
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
	weaponAnims = anim.AIWeapon[self.weapon]["anims"];

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
		weaponType = anim.AIWeapon[self.weapon]["type"];
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
	[[anim.assert]](isDefined(anim.AIWeapon), "anim.AIWeapon is not defined");
	[[anim.assert]](isDefined(self.weapon), "Self.weapon is not defined for "+self.model);
	self.bulletsInClip = anim.AIWeapon[self.weapon]["clipsize"];
	[[anim.assert]](isDefined(self.bulletsInClip), "RefillClip failed");
}

ClipSize()
{
    if ( self.weapon == "none" )
        return 0;
	return anim.AIWeapon[self.weapon]["clipsize"];
}

// Weapon list
initWeaponList()
{
	anim.AIWeapon["none"]["type"] =			"auto";
	anim.AIWeapon["none"]["rate"] =			8.0;
	anim.AIWeapon["none"]["clipsize"] =		30;
	anim.AIWeapon["none"]["anims"] =		"rifle";

	anim.AIWeapon["mp40"]["type"] =			"auto";
	anim.AIWeapon["mp40"]["rate"] =			8.0;
	anim.AIWeapon["mp40"]["clipsize"] =		30;
	anim.AIWeapon["mp40"]["anims"] =		"rifle";

	anim.AIWeapon["mp44"]["type"] =			"auto";
	anim.AIWeapon["mp44"]["rate"] =			8.0;
	anim.AIWeapon["mp44"]["clipsize"] =		30;
	anim.AIWeapon["mp44"]["anims"] =		"rifle";

	anim.AIWeapon["FG42"]["type"] =			"auto";
	anim.AIWeapon["FG42"]["rate"] =			13.3;
	anim.AIWeapon["FG42"]["clipsize"] =		20;
	anim.AIWeapon["FG42"]["anims"] =		"rifle";

	anim.AIWeapon["kar98k"]["type"] =		"bolt";
	anim.AIWeapon["kar98k"]["time"] =		1.5;
	anim.AIWeapon["kar98k"]["clipsize"] =	5;
	anim.AIWeapon["kar98k"]["anims"] =		"rifle";

	anim.AIWeapon["kar98k_pavlovsniper"]["type"] =		"bolt";
	anim.AIWeapon["kar98k_pavlovsniper"]["time"] =		1.5;
	anim.AIWeapon["kar98k_pavlovsniper"]["clipsize"] =	5;
	anim.AIWeapon["kar98k_pavlovsniper"]["anims"] =		"rifle";

	anim.AIWeapon["BAR"]["type"] =			"auto";
	anim.AIWeapon["BAR"]["rate"] =			9.5;
	anim.AIWeapon["BAR"]["clipsize"] =		20;
	anim.AIWeapon["BAR"]["anims"] =			"rifle";

	anim.AIWeapon["m1carbine"]["type"] =		"semi";
	anim.AIWeapon["m1carbine"]["time"] =		0.25;
	anim.AIWeapon["m1carbine"]["clipsize"] = 	10;
	anim.AIWeapon["m1carbine"]["anims"] =		"rifle";

	anim.AIWeapon["m1garand"]["type"] =			"semi";
	anim.AIWeapon["m1garand"]["time"] =			0.3;
	anim.AIWeapon["m1garand"]["clipsize"] =		8;
	anim.AIWeapon["m1garand"]["anims"] =		"rifle";

	anim.AIWeapon["springfield"]["type"] =		"bolt";
	anim.AIWeapon["springfield"]["time"] =		1.5;
	anim.AIWeapon["springfield"]["clipsize"] =	5;
	anim.AIWeapon["springfield"]["anims"] =		"rifle";

	anim.AIWeapon["thompson"]["type"] =			"auto";
	anim.AIWeapon["thompson"]["rate"] =			12.0;
	anim.AIWeapon["thompson"]["clipsize"] =		30;
	anim.AIWeapon["thompson"]["anims"] =		"rifle";

	anim.AIWeapon["30cal"]["type"] =			"auto";
	anim.AIWeapon["30cal"]["rate"] =			10.0;
	anim.AIWeapon["30cal"]["clipsize"] =		99999;	// Don't reload the 30 cal.
	anim.AIWeapon["30cal"]["anims"] =			"rifle";

	anim.AIWeapon["bren"]["type"] =			"auto";
	anim.AIWeapon["bren"]["rate"] =			8.0;
	anim.AIWeapon["bren"]["clipsize"] =		30;
	anim.AIWeapon["bren"]["anims"] =		"rifle";

	anim.AIWeapon["sten"]["type"] =			"auto";
	anim.AIWeapon["sten"]["rate"] =			10.0;
	anim.AIWeapon["sten"]["clipsize"] =		32;
	anim.AIWeapon["sten"]["anims"] =		"rifle";

	anim.AIWeapon["sten_engineer"]["type"] =	"auto";
	anim.AIWeapon["sten_engineer"]["rate"] =	10.0;
	anim.AIWeapon["sten_engineer"]["clipsize"] =	32;
	anim.AIWeapon["sten_engineer"]["anims"] =	"rifle";

	anim.AIWeapon["enfield"]["type"] =		"bolt";
	anim.AIWeapon["enfield"]["time"] =		1.5;
	anim.AIWeapon["enfield"]["clipsize"] =	10;
	anim.AIWeapon["enfield"]["anims"] =		"rifle";

	anim.AIWeapon["ppsh"]["type"] =			"auto";
	anim.AIWeapon["ppsh"]["rate"] =			15.0;
	anim.AIWeapon["ppsh"]["clipsize"] =		71;
	anim.AIWeapon["ppsh"]["anims"] =		"rifle";

	anim.AIWeapon["mosin_nagant"]["type"] =		"bolt";
	anim.AIWeapon["mosin_nagant"]["time"] =		1.5;
	anim.AIWeapon["mosin_nagant"]["clipsize"] =	20;
	anim.AIWeapon["mosin_nagant"]["anims"] =	"rifle";

	anim.AIWeapon["mosin_nagant_sniper"]["type"] =		"bolt";
	anim.AIWeapon["mosin_nagant_sniper"]["time"] =		1.5;
	anim.AIWeapon["mosin_nagant_sniper"]["clipsize"] =	20;
	anim.AIWeapon["mosin_nagant_sniper"]["anims"] =		"rifle";
	
	anim.AIWeapon["panzerfaust"]["type"] =		"bolt";
	anim.AIWeapon["panzerfaust"]["time"] =		3.0;
	anim.AIWeapon["panzerfaust"]["clipsize"] =	1;
	anim.AIWeapon["panzerfaust"]["anims"] =		"panzerfaust";

	anim.AIWeapon["colt"]["type"] =			"semi";
	anim.AIWeapon["colt"]["time"] =			0.25;
	anim.AIWeapon["colt"]["clipsize"] = 	7;
	anim.AIWeapon["colt"]["anims"] =		"pistol";

	anim.AIWeapon["luger"]["type"] =		"semi";
	anim.AIWeapon["luger"]["time"] =		0.2;
	anim.AIWeapon["luger"]["clipsize"] = 	8;
	anim.AIWeapon["luger"]["anims"] =		"pistol";
}
