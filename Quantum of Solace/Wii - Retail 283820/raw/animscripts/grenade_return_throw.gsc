#using_animtree ("generic_human");




main()
{
	self orientMode("face default");
 	self trackScriptState( "Cover Return Throw Main", "code" );
	self endon("killanimscript");
	self animMode ( "zonly_physics" ); 

	if (self.a.pose == "stand")
	{
		self setFlaggedAnimKnoballRestart("throwanim",%stand_grenade_return_throw, %body, 1, .3, 1);
	}
	else
	{
		self setFlaggedAnimKnoballRestart("throwanim",%crouch_grenade_return_throw, %body, 1, .3, 1);
	}
	self animscripts\shared::placeWeaponOn( self.weapon, "left" );
	self thread putWeaponBackInRightHand();
	tag = "TAG_WEAPON_RIGHT";


	self waittillmatch("throwanim", "pickup");
	self pickUpGrenade();
	
	self waittillmatch("throwanim", "rotation start");
	self animscripts\battleChatter_ai::evaluateAttackEvent("grenade");


	self waittillmatch("throwanim", "fire");
	
	self throwGrenade();
	self waittillmatch("throwanim", "finish");
	
	self notify("put_weapon_back_in_right_hand");
	self animscripts\shared::placeWeaponOn( self.weapon, "right" );
	
	
}

putWeaponBackInRightHand()
{
	self endon("death");
	self endon("put_weapon_back_in_right_hand");
	
	self waittill("killanimscript");
	
	self animscripts\shared::placeWeaponOn( self.weapon, "right" );
}
