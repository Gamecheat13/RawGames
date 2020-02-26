#include maps\_utility;
#include common_scripts\utility;

////////////////////////////////power weapons////////////////////////////////
//
//	This script finds power weapon triggers and acts accordingly.
//	The triggers are located in the power weapons prefab made for each level. 
//
/////////////////////////////////////////////////////////////////////////////

main()
{	
	cases = GetEntArray("fxanim_weapon_case_sm", "targetname");
	cases = array_combine(cases, GetEntArray("fxanim_weapon_case_mid", "targetname"));
	cases = array_combine(cases, GetEntArray("fxanim_weapon_case_lrg", "targetname"));
	cases = array_combine(cases, GetEntArray("fxanim_weapon_case_8cat", "targetname"));
	array_thread(cases, ::box);
}

box()
{
	if (!IsDefined(self.target))// old box, level needs to be re-BSPed
	{
		return;
	}

	self SetUseable(true);
	self SetHintString(&"HINT_WEAPON_CASE");

	weapon = getent(self.target, "targetname");
	PickupDisable(weapon, 1);
	weapon Hide();

	self waittill("trigger");
	self SetUseable(false);

	// WW 06-07-08
	// Adding the function call for the achievement tied to locating
	// all the power weapons
	level thread maps\_achievements::power_weapon_set_collectible( level.script );

	if (self.targetname == "fxanim_weapon_case_sm")
	{
		self small_box();
	}
	else if (self.targetname == "fxanim_weapon_case_mid")
	{
		self medium_box();
	}
	else if (self.targetname == "fxanim_weapon_case_lrg")
	{
		self large_box();
	}
	else if (self.targetname == "fxanim_weapon_case_8cat")
	{
		self large_box();
	}

//the 8cat has its own case now

//	if (issubstr(tolower(weapon.classname), "8cat"))
//	{
		// if the weapon is an 8cat wait a sec to show it so the lid starts to open.
		// This way it doesn't show through the top of the case since it doesn't quite fit in the case.
//		wait 1;
//	}

	weapon Show();

	self waittillmatch( "a_weapon_case", "end" );
	PickupDisable(weapon, 0);
}

#using_animtree("fxanim_weapon_case_sm");
small_box()
{
	self UseAnimTree(#animtree);
	self animscripted("a_weapon_case", self.origin, self.angles, %fxanim_weapon_case_sm);
}

#using_animtree("fxanim_weapon_case_mid");
medium_box()
{
	self UseAnimTree(#animtree);
	self animscripted("a_weapon_case", self.origin, self.angles, %fxanim_weapon_case_mid);
}	

#using_animtree("fxanim_weapon_case_lrg");
large_box()
{
	self UseAnimTree(#animtree);
	self animscripted("a_weapon_case", self.origin, self.angles, %fxanim_weapon_case_lrg);
}	