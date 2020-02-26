#using_animtree ("generic_human");

// Grenade_return_throw
// Picks up a grenade from 32 units in front of the character, and throws it.

main()
{
	self orientMode("face default");
 	self trackScriptState( "Cover Return Throw Main", "code" );
	self endon("killanimscript");
	self animMode ( "zonly_physics" ); // Unlatch the feet

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

/*
	model = getGrenadeModel();
	self waittillmatch("throwanim", "pickup");
	self attachGrenadeModel(model, tag);
	self thread	detachOnScriptChange(model, tag);
*/
	self waittillmatch("throwanim", "pickup");
	self pickUpGrenade();
	
	self waittillmatch("throwanim", "rotation start");
	self animscripts\battleChatter_ai::evaluateAttackEvent("grenade");
//	self animscripts\face::SayGenericDialogue("grenadeattack");

	self waittillmatch("throwanim", "fire");
/*	
	self notify ("stop grenade check");
	self detach(model, tag);
*/	
	self throwGrenade();
	self waittillmatch("throwanim", "finish");
	
	self notify("put_weapon_back_in_right_hand");
	self animscripts\shared::placeWeaponOn( self.weapon, "right" );
	
	// TODO Figure out how to make whatever animation I play next, blend in over 0.5 seconds or so.
}

putWeaponBackInRightHand()
{
	self endon("death");
	self endon("put_weapon_back_in_right_hand");
	
	self waittill("killanimscript");
	
	self animscripts\shared::placeWeaponOn( self.weapon, "right" );
}
