#include maps\_utility;
#include common_scripts\utility;








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
	if (!IsDefined(self.target))
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





		
		



	weapon Show();

	wait 4;
	PickupDisable(weapon, 0);
}

#using_animtree("fxanim_weapon_case_sm");
small_box()
{
	self UseAnimTree(#animtree);
	self animscripted("a_weapon_case_sm", self.origin, self.angles, %fxanim_weapon_case_sm);
}

#using_animtree("fxanim_weapon_case_mid");
medium_box()
{
	self UseAnimTree(#animtree);
	self animscripted("a_weapon_case_mid", self.origin, self.angles, %fxanim_weapon_case_mid);
}	

#using_animtree("fxanim_weapon_case_lrg");
large_box()
{
	self UseAnimTree(#animtree);
	self animscripted("a_weapon_case_lrg", self.origin, self.angles, %fxanim_weapon_case_lrg);
}	
