#include animscripts\Utility;
#include animscripts\SetPoseMovement;
#include animscripts\Combat_utility;
#using_animtree ("generic_human");

mainThink()
{
	self endon("killanimscript");
	if (self.anim_suppressingEnemy)
		self waittill ("suppressionAttackComplete");

	self.anim_desired_script = "combat";
	thread delayedScriptChange();
	while (self.anim_current_script != "none")
		self waittill (anim.scriptChange);
	self.anim_current_script = "combat";
	thread mainThink();	
}

main()
{
	prof_begin("combat");

//	self endon (anim.scriptChange);
	self endon ("killanimscript");
	[[self.exception_exposed]]();

    self trackScriptState( "Combat Main Switch", "code" );

	animscripts\utility::initialize("combat");
	
	// If I'm wounded, I fight differently until I recover
	if (self.anim_pose == "wounded")
	{
		self animscripts\wounded::combat("pose is wounded");
		assertEX(self.anim_pose != "wounded");
	}

	self.anim_meleeState = "aim";			// Assume we're not pulled back for melee hit when we enter combat

	animscripts\combat_say::generic_combat();
//	while (self.anim_desired_script == "combat")
	for (;;)
	{
		prof_begin("combat");
	
		canMelee = animscripts\melee::TryMeleeCharge();
		if (canMelee)
		{
			self thread animscripts\melee::MeleeCombat("TryMeleeCharge passed");
			
			prof_end( "combat" );
            return;
		}
		else 
		{
			backPedalled = tryBackPedal();
			if (!backPedalled)
			{
				self.enemyDistanceSq = self MyGetEnemySqDist();
                ////				if ( (self.enemyDistanceSq > anim.proneRangeSq) && (self CanDoProneCombat(self.origin, self.angles[1])) && (self isStanceAllowed("prone")) )
                if (self.enemyDistanceSq > anim.proneRangeSq && self isStanceAllowed("prone") && weaponAnims() != "panzerfaust") 
				{
					self thread animscripts\prone::ProneRangeCombat("Dist > ProneRangeSq");
					
					prof_end( "combat" );
                    return;
				}
				else
				{
                    self thread animscripts\exposedcombat::GeneralExposedCombat("Dist < ProneRangeSq" );
                    
                    prof_end( "combat" );
                    return;
				}

				TryGrenade();
				Reload(0);		// Note: Reload calls an interrupt point if it decides to reload.
				Rechamber();
			}
		}
		self animscripts\battleChatter::playBattleChatter();
	}

	scriptChange();
}
