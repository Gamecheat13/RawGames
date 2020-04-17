#include animscripts\Utility;
#include common_scripts\utility;

MoveRun()
{
}

UpdateRunShootWeights(animName, notifyString)
{
}


MoveRunNonShoot( desiredPose )
{
}

ProneCrawl()
{
}

RunAim()
{
}


DoNoteTracksNoShootStandCombat(animName)
{
}

MoveStandCombatOverride()
{
}

MoveStandCombatNormal()
{
}

handleRunNGunFireNotetracks()
{
}

aimedSomewhatAtEnemy()
{
}

CanShootWhileRunningAnyDir()
{
 	return true;
}

CanShootWhileRunningForward()
{
	return true;
}

CanShootWhileRunningBackward()
{
	return true;
}

CanShootWhileRunning()
{
	return CanShootWhileRunningAnyDir() && (CanShootWhileRunningForward() || CanShootWhileRunningBackward());
}

GetPredictedYawToEnemy( lookAheadTime )
{
	assert( isValidEnemy( self.enemy ) );
	
	selfPredictedPos = self.origin;
	moveAngle = self.angles[1] + self getMotionAngle();
	selfPredictedPos += (cos( moveAngle ), sin( moveAngle ), 0) * 200.0 * lookAheadTime;
	
	yaw = self.angles[1] - VectorToAngles(self.enemy.origin - selfPredictedPos)[1];
	yaw = AngleClamp180( yaw );
	return yaw;
}

MoveStandNoncombatOverride()
{
}

MoveStandNoncombatNormal()
{
}

MoveCrouchRunOverride()
{
}

MoveCrouchRunNormal()
{
}

ReloadStandRun()
{
}

ReloadStandRunInternal()
{
}

runLoopIsNearBeginning()
{
	return false;
}
chooseAnim(currentAnim, probabilityCurrent, option1, probability1, option2, probability2, option3, probability3)
{
}


UpdateRunWeights(notifyString, frontAnim, backAnim, leftAnim, rightAnim)
{
}

UpdateRunWeightsOnce( frontAnim, backAnim, leftAnim, rightAnim )
{
}

UpdateRunWeightsBiasForward(notifyString, frontAnim, backAnim, leftAnim, rightAnim)
{
}

MakeRunSounds ( notifyString )
{
}

InfiniteMoveStandCombatOverride()
{
}



changeWeaponStandRun()
{
}

shotgunSwitchStandRunInternal( flagName, switchAnim, dropGunNotetrack, putGunOnTag, newGun, pickupNewGunNotetrack )
{
}

interceptNotetracksForWeaponSwitch( notetrack )
{
}

watchShotgunSwitchNotetracks( flagName, dropGunNotetrack, putGunOnTag, newGun, pickupNewGunNotetrack )
{
}

shotgunSwitchFinish( newGun )
{
}

