// "Stop" makes the character not walk, run or fight.  He can be standing, crouching or lying 
// prone; he can be alert or idle. 

//#include animscripts\combat_utility;
#include animscripts\Utility;
//#include animscripts\SetPoseMovement; 
#using_animtree ("generic_human");

main()
{
	self notify("stopScript");
	self endon("killanimscript");
	/#
	if (getdebugdvar("anim_preview") != "")
		return;
	#/

	[[ self.exception[ "stop_immediate" ] ]]();
	// We do the exception_stop script a little late so that the AI has some animation they're playing
	// otherwise they'd go into basepose.
	thread delayedException();

	self trackScriptState( "Stop Main", "code" );
	animscripts\utility::initialize("stop");

	transitionedIntoIdle = false;

	PrecacheLevelAIAnims();
	
    PrecacheNewAIAnim();
    
    PrecachePlayerCoverAnims();
    
	for(;;)
	{
		myNode = animscripts\utility::GetClaimedNode();
		if ( isDefined( myNode ) )
		{
			myNodeAngle = myNode.angles[1];
			myNodeType = myNode.type;
		}
		else
		{
			myNodeAngle = self.desiredAngle;
			myNodeType = "node was undefined";
		}
		
		self animscripts\face::SetIdleFace(anim.alertface);

		// Find out if we should be standing, crouched or prone
		desiredPose = animscripts\utility::choosePose();

		if ( myNodeType == "Cover Stand" || myNodeType == "Conceal Stand" )
		{
			// At cover_stand nodes, we don't want to crouch since it'll most likely make our gun go through the wall.
			desiredPose = animscripts\utility::choosePose("stand");
		}
		else if ( myNodeType == "Cover Crouch" || myNodeType == "Conceal Crouch")
		{
			// We should crouch at concealment crouch nodes.
			desiredPose = animscripts\utility::choosePose("crouch");
		}
		else if ( myNodeType == "Cover Prone" || myNodeType == "Conceal Prone" )
		{
			// We should go prone at prone nodes.
			desiredPose = animscripts\utility::choosePose("prone");
		}
		
		if ( desiredPose == "stand" )
		{
			transitionedIntoIdle = self StandStillThink(transitionedIntoIdle);
		}
		else if ( desiredPose == "crouch" )
		{
			transitionedIntoIdle = self CrouchStillThink(transitionedIntoIdle);
		}
		else
		{
			assert( desiredPose == "prone" );
			self ProneStill();
		}
	}
}

StandStillThink(transitionedIntoIdle)
{
	nowTime = gettime();

	if ( isDefined(self.standanim) )
	{
		self setFlaggedAnimKnobAllRestart("idleanim", self.standanim, %body, 1, .1, 1);
		self animscripts\shared::DoNoteTracks("idleanim");
	}
	else if (self animscripts\utility::weaponAnims() == "pistol")
	{
		self setFlaggedAnimKnobAllRestart("idleanim", %pistol_standaim_idle, %body, 1, .1, 1);
		self animscripts\shared::DoNoteTracks("idleanim");
	}
	else
	{
		if ( 
			(self.a.pose != "stand") || (self.a.movement != "stop") || (self.a.alertness == "aiming") || 
			( (self.a.idleSet != "a") && (self.a.idleSet != "b") ) 
			)
		{
			// Decide which idle animation to do
			if (randomint(100)<50)
				idleSet = "a";
			else
				idleSet = "b";
		}
		else
		{
			assertEX(self.a.idleSet=="a" || self.a.idleSet=="b", "stop::standStill: anim_idleSet isn't a or b, it's "+self.a.idleSet);
			idleSet = self.a.idleSet;
		}
		
		transitionedIntoIdle = poseIdle(transitionedIntoIdle, "stand", idleSet);
		
		if ( nowTime == gettime() )
		{
			print ("stand alert animation finished instantly!!!!");
			wait 0.2;
		}
	}
	
	return transitionedIntoIdle;
}


poseIdle(transitionedIntoIdle, pose, idleSet)
{
// 	self.a.idleSet = idleSet;
// 	self SetPoseMovement(pose, "stop");
// 	
// 	if ( self isCQBWalking() && self.a.pose == "stand" && self IsInCombat() )
// 	{
// 		// special cqb idle
// 		idleAnimArray		= anim.idleAnimArray[ pose ][ "cqb" ];
// 		idleAnimWeights		= anim.idleAnimWeights[ pose ][ "cqb" ];
// 		transitionArray		= anim.idleTransArray[ pose ][ "cqb" ];
// 		subsetAnimArray		= anim.subsetAnimArray[ pose ][ "cqb" ];
// 		subsetAnimWeights	= anim.subsetAnimWeights[ pose ][ "cqb" ];
// 	}
// 	else if ( isdefined(self.node) && isdefined(self.node.script_stack) )
// 	{
// 		if (weaponAnims() == "pistol")
// 		{
// 			idleAnimArray		= anim.pistolStackIdleAnimArray[pose][idleSet];
// 			idleAnimWeights		= anim.pistolStackIdleAnimWeights[pose][idleSet];
// 			transitionArray		= anim.pistolStackIdleTransArray[pose][idleSet];
// 			subsetAnimArray		= anim.pistolStackSubsetAnimArray[pose][idleSet];
// 			subsetAnimWeights	= anim.pistolStackSubsetAnimWeights[pose][idleSet];
// 		}
// 		else
// 		{
// 			idleAnimArray		= anim.stackIdleAnimArray[pose][idleSet];
// 			idleAnimWeights		= anim.stackIdleAnimWeights[pose][idleSet];
// 			transitionArray		= anim.stackIdleTransArray[pose][idleSet];
// 			subsetAnimArray		= anim.stackSubsetAnimArray[pose][idleSet];
// 			subsetAnimWeights	= anim.stackSubsetAnimWeights[pose][idleSet];
// 		}
// 	}
// 	else
// 	{
// 		idleAnimArray		= anim.idleAnimArray[pose][idleSet];
// 		idleAnimWeights		= anim.idleAnimWeights[pose][idleSet];
// 		transitionArray		= anim.idleTransArray[pose][idleSet];
// 		subsetAnimArray		= anim.subsetAnimArray[pose][idleSet];
// 		subsetAnimWeights	= anim.subsetAnimWeights[pose][idleSet];
// 	}
// 	
// 	if (subsetAnimArray.size)
// 	{
// 		assert (transitionArray.size);
// 		
// 		// Have a random chance to transition into the subset animations
// 		if (randomint(100) > 60)
// 		{
// 			transitionedIntoIdle = !transitionedIntoIdle;
// 			if (transitionedIntoIdle)
// 			{
// 				// Transition into the subset
// 				self setFlaggedAnimKnobAllRestart("poseIdle", transitionArray[0], %body, 1, .1, self.animplaybackrate);
// 			}
// 			else
// 			{
// 				// Transition out of the subset
// 				self setFlaggedAnimKnobAllRestart("poseIdle", transitionArray[1], %body, 1, .1, self.animplaybackrate);
// 			}
// 				
// 			self animscripts\shared::DoNoteTracks ("poseIdle");
// 		}
// 		
// 		if (transitionedIntoIdle)
// 		{
// 			// Play a subset animation since we've transitioned in
// 			self setFlaggedAnimKnobAllRestart("poseIdle", anim_array(subsetAnimArray, subsetAnimWeights), %body, 1, .1, self.animplaybackrate);
// 		}
// 		else	
// 		{
// 			// Play a regular idle since we are not transitioned in
// 			self setFlaggedAnimKnobAllRestart("poseIdle", anim_array(idleAnimArray, idleAnimWeights), %body, 1, .3, self.animplaybackrate);
// 		}
// 	}
// 	else
// 	{
// 		// There is no subset animation
// 		
// 		if ((!transitionedIntoIdle) && (transitionArray.size))
// 		{
// 			// we have a transition animation so we have to play that first before we can play the idles
// 			self setFlaggedAnimKnobAllRestart("poseIdle", transitionArray[0], %body, 1, .1, self.animplaybackrate);
// 			self animscripts\shared::DoNoteTracks ("poseIdle");
// 			transitionedIntoIdle = true;
// 		}
// 		
// 		// Now we can play a random idle animation
// 		self setFlaggedAnimKnobAllRestart("poseIdle", anim_array(idleAnimArray, idleAnimWeights), %body, 1, .1, self.animplaybackrate);
// 	}
// 
// 	// Each possibility ends with playing an animation, so now we have to wait for it to finish	
// 	self animscripts\shared::DoNoteTracks ("poseIdle");
// 	return transitionedIntoIdle;
}


CrouchStillThink(transitionedIntoIdle)
{
//	for (;;)
//	{
	if (!self animscripts\utility::holdingWeapon())
	{
		unarmed_crouch_idle();
	}
	else
	{
		if ( 
			(self.a.pose != "crouch") || (self.a.movement != "stop") || (self.a.alertness == "aiming") || 
			( (self.a.idleSet != "a") && (self.a.idleSet != "b") ) 
			)
		{
			// Decide which idle animation to do
			if (randomint(100)<50)
				idleSet = "a";
			else
				idleSet = "b";
		}
		else
		{
			assertEX( self.a.idleSet=="a" || self.a.idleSet=="b", "stop::CrouchStill: anim_idleSet isn't a or b, it's "+self.a.idleSet);
			idleSet = self.a.idleSet;
		}
		transitionedIntoIdle = poseIdle(transitionedIntoIdle, "crouch", idleSet);
	}
	return transitionedIntoIdle;
}

ProneStill()
{
//	self SetPoseMovement("prone","stop");
//
//	for (;;)
//	{
//		self setAnimKnobAll (%prone_aim_idle, %body, 1, 0.1, 1);
//		myCurrentYaw = self.angles[1];
//		angleDelta = AngleClamp180( self.desiredangle - myCurrentYaw );
//		if ( angleDelta > 5 )
//		{
//			self setFlaggedAnimKnobRestart ("turn anim", %prone_turn_right, 1, 0.1, 1);
//			self thread UpdateProneThread();
//			self animscripts\shared::DoNoteTracks("turn anim");
//			self notify ("kill UpdateProneThread");
//			self UpdateProne(%prone_legs_up, %prone_legs_down, 1, 0.05, 1);
//		}
//		else if ( angleDelta < -5 )
//		{
//			self setFlaggedAnimKnobRestart ("turn anim", %prone_turn_right, 1, 0.1, 1);
//			self thread UpdateProneThread();
//			self animscripts\shared::DoNoteTracks("turn anim");
//			self notify ("kill UpdateProneThread");
//			self UpdateProne(%prone_legs_up, %prone_legs_down, 1, 0.05, 1);
//		}
//		else 
//		{
//			self setanimknob(%prone_aim_idle, 1, .1, 1);
//			if ( self.desiredangle - myCurrentYaw > 1 || self.desiredangle - myCurrentYaw < -1 )
//			{
//				self UpdateProne(%prone_legs_up, %prone_legs_down, 1, 0.05, 1);
//			}
//			wait 1;
//		}
//	}
}

UpdateProneThread()
{
//	self endon ("killanimscript");
//	self endon ("death");
//	self endon ("kill UpdateProneThread");
//
//	for (;;)
//	{
//		self UpdateProne(%prone_legs_up, %prone_legs_down, 1, 0.05, 1);
//		wait 0.1;
//	}
}

unarmed_crouch_idle()
{

//	for (;;)
//	{
		self setFlaggedAnimKnobAll("crouchanim",%unarmed_crouch_idle1, %body, 1, .1, self.animplaybackrate);
		self animscripts\shared::DoNoteTracks ("crouchanim");

		rand = randomint(100);
		if (rand<60)
		{
			self setFlaggedAnimKnobAll("crouchanim",%unarmed_crouch_twitch1, %body, 1, .1, self.animplaybackrate);
			self animscripts\shared::DoNoteTracks ("crouchanim");
		}
//	}
}

delayedException()
{
	self endon("killanimscript");
	wait (0.05);
	[[ self.exception[ "stop" ] ]]();
}

PrecacheLevelAIAnims()
{
	tmp = %Thu_Stand_OnCellPhone_ForeGrip;
	tmp = %Thu_Stand_OnCellPhone_Pistol;
}

//AI_ANIM_BLOCK_BEGIN
//Begin of Automatically Generated AI Block --- No mannual change!!! 
PrecacheNewAIAnim()
{

	tmp = %thu_stand_die_backleft_explosion;
	tmp = %thu_stand_die_backright_explosion;
	tmp = %thu_stand_die_front_balconynorail_backfalling_chest;
	tmp = %thu_stand_die_front_balconynorail_backfallout_chest;
	tmp = %thu_stand_die_front_balconynorail_frontfalling_chest;
	tmp = %thu_stand_die_front_balconynorail_frontfallout_chest;
	tmp = %thu_stand_die_front_balconyrail_backfalling_chest;
	tmp = %thu_stand_die_front_balconyrail_backfallout_chest;
	tmp = %thu_stand_die_front_balconyrail_frontfalling_chest;
	tmp = %thu_stand_die_front_balconyrail_frontfallout_chest;
	tmp = %thu_stand_die_frontleft_explosion;
	tmp = %thu_stand_die_frontright_explosion;
	tmp = %thu_stand_die_front_ragdoll_v1;
	tmp = %thu_stand_die_front_ragdoll_v2;
	tmp = %thu_stand_die_back_ragdoll_v1;
	tmp = %thu_stand_die_back_ragdoll_v2;
	tmp = %thug_heli_death_front;
    
	tmp = %thu_cvrlt_crch_blindfiredn_foregrip;
	tmp = %thu_cvrlt_crch_blindfiredn_pistol;
	tmp = %thu_cvrlt_crch_blindfiremid_foregrip;
	tmp = %thu_cvrlt_crch_blindfiremid_pistol;
	tmp = %thu_cvrlt_crch_blindfireup_foregrip;
	tmp = %thu_cvrlt_crch_blindfireup_pistol;
	tmp = %thu_cvrlt_crch_expaimdn_foregrip;
	tmp = %thu_cvrlt_crch_expaimdn_pistol;
	tmp = %thu_cvrlt_crch_expaimmid_foregrip;
	tmp = %thu_cvrlt_crch_expaimmid_pistol;
	tmp = %thu_cvrlt_crch_expaimup_foregrip;
	tmp = %thu_cvrlt_crch_expaimup_pistol;
	tmp = %thu_cvrlt_crch_expfiredn_foregrip;
	tmp = %thu_cvrlt_crch_expfiredn_pistol;
	tmp = %thu_cvrlt_crch_expfiremid_foregrip;
	tmp = %thu_cvrlt_crch_expfiremid_pistol;
	tmp = %thu_cvrlt_crch_expfireup_foregrip;
	tmp = %thu_cvrlt_crch_expfireup_pistol;
	tmp = %thu_cvrlt_crch_expwideaimdn_foregrip;
	tmp = %thu_cvrlt_crch_expwideaimdn_pistol;
	tmp = %thu_cvrlt_crch_expwideaimmid_foregrip;
	tmp = %thu_cvrlt_crch_expwideaimmid_pistol;
	tmp = %thu_cvrlt_crch_expwideaimup_foregrip;
	tmp = %thu_cvrlt_crch_expwideaimup_pistol;
	tmp = %thu_cvrlt_crch_expwidefiredn_foregrip;
	tmp = %thu_cvrlt_crch_expwidefiredn_pistol;
	tmp = %thu_cvrlt_crch_expwidefiremid_foregrip;
	tmp = %thu_cvrlt_crch_expwidefiremid_pistol;
	tmp = %thu_cvrlt_crch_expwidefireup_foregrip;
	tmp = %thu_cvrlt_crch_expwidefireup_pistol;
	tmp = %thu_cvrlt_crch_grenade_throw_foregrip;
	tmp = %thu_cvrlt_crch_grenade_throw_pistol;
	tmp = %thu_cvrlt_stnd_blindfiredn_foregrip;
	tmp = %thu_cvrlt_stnd_blindfiredn_pistol;
	tmp = %thu_cvrlt_stnd_blindfiremid_foregrip;
	tmp = %thu_cvrlt_stnd_blindfiremid_pistol;
	tmp = %thu_cvrlt_stnd_blindfireup_foregrip;
	tmp = %thu_cvrlt_stnd_blindfireup_pistol;
	tmp = %thu_cvrlt_stnd_expaimdn_foregrip;
	tmp = %thu_cvrlt_stnd_expaimdn_pistol;
	tmp = %thu_cvrlt_stnd_expaimmid_foregrip;
	tmp = %thu_cvrlt_stnd_expaimmid_pistol;
	tmp = %thu_cvrlt_stnd_expaimup_foregrip;
	tmp = %thu_cvrlt_stnd_expaimup_pistol;
	tmp = %thu_cvrlt_stnd_expfiredn_foregrip;
	tmp = %thu_cvrlt_stnd_expfiredn_pistol;
	tmp = %thu_cvrlt_stnd_expfiremid_foregrip;
	tmp = %thu_cvrlt_stnd_expfiremid_pistol;
	tmp = %thu_cvrlt_stnd_expfireup_foregrip;
	tmp = %thu_cvrlt_stnd_expfireup_pistol;
	tmp = %thu_cvrlt_stnd_expwideaimdn_foregrip;
	tmp = %thu_cvrlt_stnd_expwideaimdn_pistol;
	tmp = %thu_cvrlt_stnd_expwideaimmid_foregrip;
	tmp = %thu_cvrlt_stnd_expwideaimmid_pistol;
	tmp = %thu_cvrlt_stnd_expwideaimup_foregrip;
	tmp = %thu_cvrlt_stnd_expwideaimup_pistol;
	tmp = %thu_cvrlt_stnd_expwidefiredn_foregrip;
	tmp = %thu_cvrlt_stnd_expwidefiredn_pistol;
	tmp = %thu_cvrlt_stnd_expwidefiremid_foregrip;
	tmp = %thu_cvrlt_stnd_expwidefiremid_pistol;
	tmp = %thu_cvrlt_stnd_expwidefireup_foregrip;
	tmp = %thu_cvrlt_stnd_expwidefireup_pistol;
	tmp = %thu_cvrlttns_crch_blindfire2ready_foregrip;
	tmp = %thu_cvrlttns_crch_blindfire2ready_pistol;
	tmp = %thu_cvrlttns_crch_exp2ready_foregrip;
	tmp = %thu_cvrlttns_crch_exp2ready_pistol;
	tmp = %thu_cvrlttns_crch_expup2ready_foregrip;
	tmp = %thu_cvrlttns_crch_expup2ready_pistol;
	tmp = %thu_cvrlttns_crch_expuphigh2ready_foregrip;
	tmp = %thu_cvrlttns_crch_expuphigh2ready_pistol;
	tmp = %thu_cvrlttns_crch_expwide2ready_foregrip;
	tmp = %thu_cvrlttns_crch_expwide2ready_pistol;
	tmp = %thu_cvrlttns_crch_ready2blindfire_foregrip;
	tmp = %thu_cvrlttns_crch_ready2blindfire_pistol;
	tmp = %thu_cvrlttns_crch_ready2exp_foregrip;
	tmp = %thu_cvrlttns_crch_ready2exp_pistol;
	tmp = %thu_cvrlttns_crch_ready2expup_foregrip;
	tmp = %thu_cvrlttns_crch_ready2expup_pistol;
	tmp = %thu_cvrlttns_crch_ready2expuphigh_foregrip;
	tmp = %thu_cvrlttns_crch_ready2expuphigh_pistol;
	tmp = %thu_cvrlttns_crch_ready2expwide_foregrip;
	tmp = %thu_cvrlttns_crch_ready2expwide_pistol;
	tmp = %thu_cvrlttns_stnd_blindfire2ready_foregrip;
	tmp = %thu_cvrlttns_stnd_blindfire2ready_pistol;
	tmp = %thu_cvrlttns_stnd_exp2ready_foregrip;
	tmp = %thu_cvrlttns_stnd_exp2ready_pistol;
	tmp = %thu_cvrlttns_stnd_expwide2ready_foregrip;
	tmp = %thu_cvrlttns_stnd_expwide2ready_pistol;
	tmp = %thu_cvrlttns_stnd_ready2blindfire_foregrip;
	tmp = %thu_cvrlttns_stnd_ready2blindfire_pistol;
	tmp = %thu_cvrlttns_stnd_ready2exp_foregrip;
	tmp = %thu_cvrlttns_stnd_ready2exp_pistol;
	tmp = %thu_cvrlttns_stnd_ready2expwide_foregrip;
	tmp = %thu_cvrlttns_stnd_ready2expwide_pistol;
	tmp = %thu_cvrmid_blindfire_hgncrch_15;
	tmp = %thu_cvrmid_blindfire_hgncrch_n15;
	tmp = %thu_cvrmid_crch_blindfiredn_foregrip;
	tmp = %thu_cvrmid_crch_blindfiredn_pistol;
	tmp = %thu_cvrmid_crch_blindfiremid_foregrip;
	tmp = %thu_cvrmid_crch_blindfiremid_pistol;
	tmp = %thu_cvrmid_crch_blindfireup_foregrip;
	tmp = %thu_cvrmid_crch_blindfireup_pistol;
	tmp = %thu_cvrmid_crch_expaimdn_foregrip;
	tmp = %thu_cvrmid_crch_expaimdn_pistol;
	tmp = %thu_cvrmid_crch_expaimmid_foregrip;
	tmp = %thu_cvrmid_crch_expaimmid_pistol;
	tmp = %thu_cvrmid_crch_expaimup_foregrip;
	tmp = %thu_cvrmid_crch_expaimup_pistol;
	tmp = %thu_cvrmid_crch_expfiredn_foregrip;
	tmp = %thu_cvrmid_crch_expfiredn_pistol;
	tmp = %thu_cvrmid_crch_expfirednnew;
	tmp = %thu_cvrmid_crch_expfiremid_foregrip;
	tmp = %thu_cvrmid_crch_expfiremid_pistol;
	tmp = %thu_cvrmid_crch_expfiremidnew;
	tmp = %thu_cvrmid_crch_expfireup_foregrip;
	tmp = %thu_cvrmid_crch_expfireup_pistol;
	tmp = %thu_cvrmid_crch_expfireupnew;
	tmp = %thu_cvrmid_stnd_blindfiredn_foregrip;
	tmp = %thu_cvrmid_stnd_blindfiredn_pistol;
	tmp = %thu_cvrmid_stnd_blindfiremid_foregrip;
	tmp = %thu_cvrmid_stnd_blindfiremid_pistol;
	tmp = %thu_cvrmid_stnd_blindfireup_foregrip;
	tmp = %thu_cvrmid_stnd_blindfireup_pistol;
	tmp = %thu_cvrmid_stnd_expaimdn_foregrip;
	tmp = %thu_cvrmid_stnd_expaimdn_pistol;
	tmp = %thu_cvrmid_stnd_expaimmid_foregrip;
	tmp = %thu_cvrmid_stnd_expaimmid_pistol;
	tmp = %thu_cvrmid_stnd_expaimup_foregrip;
	tmp = %thu_cvrmid_stnd_expaimup_pistol;
	tmp = %thu_cvrmid_stnd_expfiredn_foregrip;
	tmp = %thu_cvrmid_stnd_expfiredn_pistol;
	tmp = %thu_cvrmid_stnd_expfiremid_foregrip;
	tmp = %thu_cvrmid_stnd_expfiremid_pistol;
	tmp = %thu_cvrmid_stnd_expfireup_foregrip;
	tmp = %thu_cvrmid_stnd_expfireup_pistol;
	tmp = %thu_cvrmidtns_crch_blindfire2ready_foregrip;
	tmp = %thu_cvrmidtns_crch_blindfire2ready_pistol;
	tmp = %thu_cvrmidtns_crch_exp2ready_foregrip;
	tmp = %thu_cvrmidtns_crch_exp2ready_pistol;
	tmp = %thu_cvrmidtns_crch_ready2blindfire_foregrip;
	tmp = %thu_cvrmidtns_crch_ready2blindfire_pistol;
	tmp = %thu_cvrmidtns_crch_ready2exp_foregrip;
	tmp = %thu_cvrmidtns_crch_ready2exp_pistol;
	tmp = %thu_cvrmidtns_stnd_blindfire2ready_foregrip;
	tmp = %thu_cvrmidtns_stnd_blindfire2ready_pistol;
	tmp = %thu_cvrmidtns_stnd_exp2ready_foregrip;
	tmp = %thu_cvrmidtns_stnd_exp2ready_pistol;
	tmp = %thu_cvrmidtns_stnd_ready2blindfire_foregrip;
	tmp = %thu_cvrmidtns_stnd_ready2blindfire_pistol;
	tmp = %thu_cvrmidtns_stnd_ready2exp_foregrip;
	tmp = %thu_cvrmidtns_stnd_ready2exp_pistol;
	tmp = %thu_cvrrt_blindfire_hgncrch_15;
	tmp = %thu_cvrrt_blindfire_hgncrch_n15;
	tmp = %thu_cvrrt_blindfire_hgnstnd_15;
	tmp = %thu_cvrrt_blindfire_hgnstnd_n15;
	tmp = %thu_cvrrt_crch_blindfiredn_foregrip;
	tmp = %thu_cvrrt_crch_blindfiredn_pistol;
	tmp = %thu_cvrrt_crch_blindfiremid_foregrip;
	tmp = %thu_cvrrt_crch_blindfiremid_pistol;
	tmp = %thu_cvrrt_crch_blindfireup_foregrip;
	tmp = %thu_cvrrt_crch_blindfireup_pistol;
	tmp = %thu_cvrrt_crch_expaimdn75;
	tmp = %thu_cvrrt_crch_expaimdn80;
	tmp = %thu_cvrrt_crch_expaimdn90;
	tmp = %thu_cvrrt_crch_expaimdn_foregrip;
	tmp = %thu_cvrrt_crch_expaimdn_pistol;
	tmp = %thu_cvrrt_crch_expaimmid_foregrip;
	tmp = %thu_cvrrt_crch_expaimmid_pistol;
	tmp = %thu_cvrrt_crch_expaimup75;
	tmp = %thu_cvrrt_crch_expaimup80;
	tmp = %thu_cvrrt_crch_expaimup90;
	tmp = %thu_cvrrt_crch_expaimup_foregrip;
	tmp = %thu_cvrrt_crch_expaimup_pistol;
	tmp = %thu_cvrrt_crch_expfiredn75;
	tmp = %thu_cvrrt_crch_expfiredn80;
	tmp = %thu_cvrrt_crch_expfiredn90;
	tmp = %thu_cvrrt_crch_expfiredn_foregrip;
	tmp = %thu_cvrrt_crch_expfiredn_pistol;
	tmp = %thu_cvrrt_crch_expfiremid_foregrip;
	tmp = %thu_cvrrt_crch_expfiremid_pistol;
	tmp = %thu_cvrrt_crch_expfireup75;
	tmp = %thu_cvrrt_crch_expfireup80;
	tmp = %thu_cvrrt_crch_expfireup90;
	tmp = %thu_cvrrt_crch_expfireup_foregrip;
	tmp = %thu_cvrrt_crch_expfireup_pistol;
	tmp = %thu_cvrrt_crch_expwideaimdn_foregrip;
	tmp = %thu_cvrrt_crch_expwideaimdn_pistol;
	tmp = %thu_cvrrt_crch_expwideaimmid_foregrip;
	tmp = %thu_cvrrt_crch_expwideaimmid_pistol;
	tmp = %thu_cvrrt_crch_expwideaimup_foregrip;
	tmp = %thu_cvrrt_crch_expwideaimup_pistol;
	tmp = %thu_cvrrt_crch_expwidefiredn_foregrip;
	tmp = %thu_cvrrt_crch_expwidefiredn_pistol;
	tmp = %thu_cvrrt_crch_expwidefiremid_foregrip;
	tmp = %thu_cvrrt_crch_expwidefiremid_pistol;
	tmp = %thu_cvrrt_crch_expwidefireup_foregrip;
	tmp = %thu_cvrrt_crch_expwidefireup_pistol;
	tmp = %thu_cvrrt_crch_grenade_throw_foregrip;
	tmp = %thu_cvrrt_crch_grenade_throw_pistol;
	tmp = %thu_cvrrt_stnd_blindfiredn_foregrip;
	tmp = %thu_cvrrt_stnd_blindfiredn_pistol;
	tmp = %thu_cvrrt_stnd_blindfiremid_foregrip;
	tmp = %thu_cvrrt_stnd_blindfiremid_pistol;
	tmp = %thu_cvrrt_stnd_blindfireup_foregrip;
	tmp = %thu_cvrrt_stnd_blindfireup_pistol;
	tmp = %thu_cvrrt_stnd_expaimdn_foregrip;
	tmp = %thu_cvrrt_stnd_expaimdn_pistol;
	tmp = %thu_cvrrt_stnd_expaimmid_foregrip;
	tmp = %thu_cvrrt_stnd_expaimmid_pistol;
	tmp = %thu_cvrrt_stnd_expaimup_foregrip;
	tmp = %thu_cvrrt_stnd_expaimup_pistol;
	tmp = %thu_cvrrt_stnd_expfiredn_foregrip;
	tmp = %thu_cvrrt_stnd_expfiredn_pistol;
	tmp = %thu_cvrrt_stnd_expfiremid_foregrip;
	tmp = %thu_cvrrt_stnd_expfiremid_pistol;
	tmp = %thu_cvrrt_stnd_expfireup_foregrip;
	tmp = %thu_cvrrt_stnd_expfireup_pistol;
	tmp = %thu_cvrrt_stnd_expwideaimdn_foregrip;
	tmp = %thu_cvrrt_stnd_expwideaimdn_pistol;
	tmp = %thu_cvrrt_stnd_expwideaimmid_foregrip;
	tmp = %thu_cvrrt_stnd_expwideaimmid_pistol;
	tmp = %thu_cvrrt_stnd_expwideaimup_foregrip;
	tmp = %thu_cvrrt_stnd_expwideaimup_pistol;
	tmp = %thu_cvrrt_stnd_expwidefiredn_foregrip;
	tmp = %thu_cvrrt_stnd_expwidefiredn_pistol;
	tmp = %thu_cvrrt_stnd_expwidefiremid_foregrip;
	tmp = %thu_cvrrt_stnd_expwidefiremid_pistol;
	tmp = %thu_cvrrt_stnd_expwidefireup_foregrip;
	tmp = %thu_cvrrt_stnd_expwidefireup_pistol;
	tmp = %thu_cvrrttns_crch_blindfire2ready_foregrip;
	tmp = %thu_cvrrttns_crch_blindfire2ready_pistol;
	tmp = %thu_cvrrttns_crch_exp2ready_foregrip;
	tmp = %thu_cvrrttns_crch_exp2ready_pistol;
	tmp = %thu_cvrrttns_crch_expup2ready_foregrip;
	tmp = %thu_cvrrttns_crch_expup2ready_pistol;
	tmp = %thu_cvrrttns_crch_expuphigh2ready_foregrip;
	tmp = %thu_cvrrttns_crch_expuphigh2ready_pistol;
	tmp = %thu_cvrrttns_crch_expwide2ready_foregrip;
	tmp = %thu_cvrrttns_crch_expwide2ready_pistol;
	tmp = %thu_cvrrttns_crch_ready2blindfire_foregrip;
	tmp = %thu_cvrrttns_crch_ready2blindfire_pistol;
	tmp = %thu_cvrrttns_crch_ready2exp_foregrip;
	tmp = %thu_cvrrttns_crch_ready2exp_pistol;
	tmp = %thu_cvrrttns_crch_ready2expup_foregrip;
	tmp = %thu_cvrrttns_crch_ready2expup_pistol;
	tmp = %thu_cvrrttns_crch_ready2expuphigh_foregrip;
	tmp = %thu_cvrrttns_crch_ready2expuphigh_pistol;
	tmp = %thu_cvrrttns_crch_ready2expwide_foregrip;
	tmp = %thu_cvrrttns_crch_ready2expwide_pistol;
	tmp = %thu_cvrrttns_stnd_blindfire2ready_foregrip;
	tmp = %thu_cvrrttns_stnd_blindfire2ready_pistol;
	tmp = %thu_cvrrttns_stnd_exp2ready_foregrip;
	tmp = %thu_cvrrttns_stnd_exp2ready_pistol;
	tmp = %thu_cvrrttns_stnd_expwide2ready_foregrip;
	tmp = %thu_cvrrttns_stnd_expwide2ready_pistol;
	tmp = %thu_cvrrttns_stnd_ready2blindfire_foregrip;
	tmp = %thu_cvrrttns_stnd_ready2blindfire_pistol;
	tmp = %thu_cvrrttns_stnd_ready2exp_foregrip;
	tmp = %thu_cvrrttns_stnd_ready2exp_pistol;
	tmp = %thu_cvrrttns_stnd_ready2expwide_foregrip;
	tmp = %thu_cvrrttns_stnd_ready2expwide_pistol;
	tmp = %thu_cvrrttns_crch_blindfireup2ready_foregrip;
	tmp = %thu_cvrrttns_crch_blindfireup2ready_pistol;
	tmp = %thu_cvrlttns_crch_blindfireup2ready_foregrip;
	tmp = %thu_cvrlttns_crch_blindfireup2ready_pistol;
	tmp = %thu_cvrrttns_crch_ready2blindfireup_foregrip;
	tmp = %thu_cvrrttns_crch_ready2blindfireup_pistol;
	tmp = %thu_cvrlttns_crch_ready2blindfireup_foregrip;
	tmp = %thu_cvrlttns_crch_ready2blindfireup_pistol;
    
	tmp = %thu_coverchange_stnd_run_foregrip;
	tmp = %thu_coverchange_stnd_run_pistol;
	tmp = %thu_cvrlt_crch_idlready_foregrip;
	tmp = %thu_cvrlt_crch_idlready_pistol;
	tmp = %thu_cvrlt_crch_idlsuppressed_foregrip;
	tmp = %thu_cvrlt_crch_idlsuppressed_pistol;
	tmp = %thu_cvrlt_crch_look_foregrip;
	tmp = %thu_cvrlt_crch_look_pistol;
	tmp = %thu_cvrlt_crch_peekside_foregrip;
	tmp = %thu_cvrlt_crch_peekside_pistol;
	tmp = %thu_cvrlt_crch_peekup_foregrip;
	tmp = %thu_cvrlt_crch_peekup_pistol;
	tmp = %thu_cvrlt_crch_reload_foregrip;
	tmp = %thu_cvrlt_crch_reload_pistol;
	tmp = %thu_cvrlt_crch_shuffle_foregrip;
	tmp = %thu_cvrlt_crch_shuffle_pistol;
	tmp = %thu_cvrlt_crch_shufflefast_foregrip;
	tmp = %thu_cvrlt_crch_shufflefast_pistol;
	tmp = %thu_cvrlt_stnd_idlready_foregrip;
	tmp = %thu_cvrlt_stnd_idlready_pistol;
	tmp = %thu_cvrlt_stnd_idlsuppressed_foregrip;
	tmp = %thu_cvrlt_stnd_idlsuppressed_pistol;
	tmp = %thu_cvrlt_stnd_look_foregrip;
	tmp = %thu_cvrlt_stnd_look_pistol;
	tmp = %thu_cvrlt_stnd_peekside_foregrip;
	tmp = %thu_cvrlt_stnd_peekside_pistol;
	tmp = %thu_cvrlt_stnd_reload_foregrip;
	tmp = %thu_cvrlt_stnd_reload_pistol;
	tmp = %thu_cvrlttns_crch_ready2idl0_foregrip;
	tmp = %thu_cvrlttns_crch_ready2idl0_pistol;
	tmp = %thu_cvrlttns_crch_ready2idllt180_foregrip;
	tmp = %thu_cvrlttns_crch_ready2idllt180_pistol;
	tmp = %thu_cvrlttns_crch_ready2idllt90_foregrip;
	tmp = %thu_cvrlttns_crch_ready2idllt90_pistol;
	tmp = %thu_cvrlttns_crch_ready2idlrt180_foregrip;
	tmp = %thu_cvrlttns_crch_ready2idlrt180_pistol;
	tmp = %thu_cvrlttns_crch_ready2idlrt90_foregrip;
	tmp = %thu_cvrlttns_crch_ready2idlrt90_pistol;
	tmp = %thu_cvrlttns_crch_ready2run0_foregrip;
	tmp = %thu_cvrlttns_crch_ready2run0_pistol;
	tmp = %thu_cvrlttns_crch_ready2runlt180_foregrip;
	tmp = %thu_cvrlttns_crch_ready2runlt180_pistol;
	tmp = %thu_cvrlttns_crch_roll2ready135_foregrip;
	tmp = %thu_cvrlttns_crch_roll2ready135_pistol;
	tmp = %thu_cvrlttns_crch_roll2ready_foregrip;
	tmp = %thu_cvrlttns_crch_roll2ready_pistol;
	tmp = %thu_cvrlttns_crch_roll2readylt45_foregrip;
	tmp = %thu_cvrlttns_crch_roll2readylt45_pistol;
	tmp = %thu_cvrlttns_crch_roll2readylt90_foregrip;
	tmp = %thu_cvrlttns_crch_roll2readylt90_pistol;
	tmp = %thu_cvrlttns_crch_roll2readyrt45_foregrip;
	tmp = %thu_cvrlttns_crch_roll2readyrt45_pistol;
	tmp = %thu_cvrlttns_crch_roll2readyrt90_foregrip;
	tmp = %thu_cvrlttns_crch_roll2readyrt90_pistol;
	tmp = %thu_cvrlttns_crch_run2ready_foregrip;
	tmp = %thu_cvrlttns_crch_run2ready_pistol;
	tmp = %thu_cvrlttns_crch_run2readylt90_foregrip;
	tmp = %thu_cvrlttns_crch_run2readylt90_pistol;
	tmp = %thu_cvrlttns_crch_run2readyrt90_foregrip;
	tmp = %thu_cvrlttns_crch_run2readyrt90_pistol;
	tmp = %thu_cvrlttns_crch_slide2ready_foregrip;
	tmp = %thu_cvrlttns_crch_slide2ready_pistol;
	tmp = %thu_cvrlttns_crch_slide2readylt45_foregrip;
	tmp = %thu_cvrlttns_crch_slide2readylt45_pistol;
	tmp = %thu_cvrlttns_crch_slide2readylt90_foregrip;
	tmp = %thu_cvrlttns_crch_slide2readylt90_pistol;
	tmp = %thu_cvrlttns_crch_slide2readyrt45_foregrip;
	tmp = %thu_cvrlttns_crch_slide2readyrt45_pistol;
	tmp = %thu_cvrlttns_crch_slide2readyrt90_foregrip;
	tmp = %thu_cvrlttns_crch_slide2readyrt90_pistol;
	tmp = %thu_cvrlttns_crch_stnd2ready_foregrip;
	tmp = %thu_cvrlttns_crch_stnd2ready_pistol;
	tmp = %thu_cvrlttns_crch_stnd2readylt90_foregrip;
	tmp = %thu_cvrlttns_crch_stnd2readylt90_pistol;
	tmp = %thu_cvrlttns_crch_stnd2readyrt90_foregrip;
	tmp = %thu_cvrlttns_crch_stnd2readyrt90_pistol;
	tmp = %thu_cvrlttns_stnd_ready2idl0_foregrip;
	tmp = %thu_cvrlttns_stnd_ready2idl0_pistol;
	tmp = %thu_cvrlttns_stnd_ready2idllt180_foregrip;
	tmp = %thu_cvrlttns_stnd_ready2idllt180_pistol;
	tmp = %thu_cvrlttns_stnd_ready2idllt90_foregrip;
	tmp = %thu_cvrlttns_stnd_ready2idllt90_pistol;
	tmp = %thu_cvrlttns_stnd_ready2idlrt180_foregrip;
	tmp = %thu_cvrlttns_stnd_ready2idlrt180_pistol;
	tmp = %thu_cvrlttns_stnd_ready2idlrt90_foregrip;
	tmp = %thu_cvrlttns_stnd_ready2idlrt90_pistol;
	tmp = %thu_cvrlttns_stnd_ready2run0_foregrip;
	tmp = %thu_cvrlttns_stnd_ready2run0_pistol;
	tmp = %thu_cvrlttns_stnd_ready2runlt180_foregrip;
	tmp = %thu_cvrlttns_stnd_ready2runlt180_pistol;
	tmp = %thu_cvrlttns_stnd_roll2ready135_foregrip;
	tmp = %thu_cvrlttns_stnd_roll2ready135_pistol;
	tmp = %thu_cvrlttns_stnd_roll2ready_foregrip;
	tmp = %thu_cvrlttns_stnd_roll2ready_pistol;
	tmp = %thu_cvrlttns_stnd_roll2readylt45_foregrip;
	tmp = %thu_cvrlttns_stnd_roll2readylt45_pistol;
	tmp = %thu_cvrlttns_stnd_roll2readylt90_foregrip;
	tmp = %thu_cvrlttns_stnd_roll2readylt90_pistol;
	tmp = %thu_cvrlttns_stnd_roll2readyrt45_foregrip;
	tmp = %thu_cvrlttns_stnd_roll2readyrt45_pistol;
	tmp = %thu_cvrlttns_stnd_roll2readyrt90_foregrip;
	tmp = %thu_cvrlttns_stnd_roll2readyrt90_pistol;
	tmp = %thu_cvrlttns_stnd_run2ready_foregrip;
	tmp = %thu_cvrlttns_stnd_run2ready_pistol;
	tmp = %thu_cvrlttns_stnd_run2readylt90_foregrip;
	tmp = %thu_cvrlttns_stnd_run2readylt90_pistol;
	tmp = %thu_cvrlttns_stnd_run2readyrt90_foregrip;
	tmp = %thu_cvrlttns_stnd_run2readyrt90_pistol;
	tmp = %thu_cvrlttns_stnd_slide2ready_foregrip;
	tmp = %thu_cvrlttns_stnd_slide2ready_pistol;
	tmp = %thu_cvrlttns_stnd_slide2readylt45_foregrip;
	tmp = %thu_cvrlttns_stnd_slide2readylt45_pistol;
	tmp = %thu_cvrlttns_stnd_slide2readylt90_foregrip;
	tmp = %thu_cvrlttns_stnd_slide2readylt90_pistol;
	tmp = %thu_cvrlttns_stnd_slide2readyrt45_foregrip;
	tmp = %thu_cvrlttns_stnd_slide2readyrt45_pistol;
	tmp = %thu_cvrlttns_stnd_slide2readyrt90_foregrip;
	tmp = %thu_cvrlttns_stnd_slide2readyrt90_pistol;
	tmp = %thu_cvrlttns_stnd_stnd2ready_foregrip;
	tmp = %thu_cvrlttns_stnd_stnd2ready_pistol;
	tmp = %thu_cvrlttns_stnd_stnd2readylt90_foregrip;
	tmp = %thu_cvrlttns_stnd_stnd2readylt90_pistol;
	tmp = %thu_cvrlttns_stnd_stnd2readyrt90_foregrip;
	tmp = %thu_cvrlttns_stnd_stnd2readyrt90_pistol;
	tmp = %thu_cvrmid_crch_idlready_foregrip;
	tmp = %thu_cvrmid_crch_idlready_pistol;
	tmp = %thu_cvrmid_crch_idlsuppressed_foregrip;
	tmp = %thu_cvrmid_crch_idlsuppressed_pistol;
	tmp = %thu_cvrmid_crch_look_foregrip;
	tmp = %thu_cvrmid_crch_look_pistol;
	tmp = %thu_cvrmid_crch_peekleft_foregrip;
	tmp = %thu_cvrmid_crch_peekleft_pistol;
	tmp = %thu_cvrmid_crch_peekright_foregrip;
	tmp = %thu_cvrmid_crch_peekright_pistol;
	tmp = %thu_cvrmid_crch_reload_foregrip;
	tmp = %thu_cvrmid_crch_reload_pistol;
	tmp = %thu_cvrmid_stnd_idlready_foregrip;
	tmp = %thu_cvrmid_stnd_idlready_pistol;
	tmp = %thu_cvrmid_stnd_idlsuppressed_foregrip;
	tmp = %thu_cvrmid_stnd_idlsuppressed_pistol;
	tmp = %thu_cvrmid_stnd_look_foregrip;
	tmp = %thu_cvrmid_stnd_look_pistol;
	tmp = %thu_cvrmid_stnd_peekup_foregrip;
	tmp = %thu_cvrmid_stnd_peekup_pistol;
	tmp = %thu_cvrmid_stnd_reload_foregrip;
	tmp = %thu_cvrmid_stnd_reload_pistol;
	tmp = %thu_cvrmidtns_crch_cvr2run_foregrip;
	tmp = %thu_cvrmidtns_crch_cvr2run_pistol;
	tmp = %thu_cvrmidtns_crch_cvr2runlt_foregrip;
	tmp = %thu_cvrmidtns_crch_cvr2runlt_pistol;
	tmp = %thu_cvrmidtns_crch_cvr2runrt_foregrip;
	tmp = %thu_cvrmidtns_crch_cvr2runrt_pistol;
	tmp = %thu_cvrmidtns_crch_cvr2tctrun_foregrip;
	tmp = %thu_cvrmidtns_crch_cvr2tctrun_pistol;
	tmp = %thu_cvrmidtns_crch_cvr2tctrunbk_foregrip;
	tmp = %thu_cvrmidtns_crch_cvr2tctrunbk_pistol;
	tmp = %thu_cvrmidtns_crch_cvr2tctrunlt_foregrip;
	tmp = %thu_cvrmidtns_crch_cvr2tctrunlt_pistol;
	tmp = %thu_cvrmidtns_crch_cvr2tctrunrt_foregrip;
	tmp = %thu_cvrmidtns_crch_cvr2tctrunrt_pistol;
	tmp = %thu_cvrmidtns_crch_ready2idl0_foregrip;
	tmp = %thu_cvrmidtns_crch_ready2idl0_pistol;
	tmp = %thu_cvrmidtns_crch_ready2idllt180_foregrip;
	tmp = %thu_cvrmidtns_crch_ready2idllt180_pistol;
	tmp = %thu_cvrmidtns_crch_ready2idllt90_foregrip;
	tmp = %thu_cvrmidtns_crch_ready2idllt90_pistol;
	tmp = %thu_cvrmidtns_crch_ready2idlrt180_foregrip;
	tmp = %thu_cvrmidtns_crch_ready2idlrt180_pistol;
	tmp = %thu_cvrmidtns_crch_ready2idlrt90_foregrip;
	tmp = %thu_cvrmidtns_crch_ready2idlrt90_pistol;
	tmp = %thu_cvrmidtns_crch_ready2runlt180_foregrip;
	tmp = %thu_cvrmidtns_crch_ready2runlt180_pistol;
	tmp = %thu_cvrmidtns_crch_ready2runlt90_foregrip;
	tmp = %thu_cvrmidtns_crch_ready2runlt90_pistol;
	tmp = %thu_cvrmidtns_crch_ready2runrt90_foregrip;
	tmp = %thu_cvrmidtns_crch_ready2runrt90_pistol;
	tmp = %thu_cvrmidtns_crch_roll2ready_foregrip;
	tmp = %thu_cvrmidtns_crch_roll2ready_pistol;
	tmp = %thu_cvrmidtns_crch_roll2readylt45_foregrip;
	tmp = %thu_cvrmidtns_crch_roll2readylt45_pistol;
	tmp = %thu_cvrmidtns_crch_roll2readylt90_foregrip;
	tmp = %thu_cvrmidtns_crch_roll2readylt90_pistol;
	tmp = %thu_cvrmidtns_crch_roll2readyrt45_foregrip;
	tmp = %thu_cvrmidtns_crch_roll2readyrt45_pistol;
	tmp = %thu_cvrmidtns_crch_roll2readyrt90_foregrip;
	tmp = %thu_cvrmidtns_crch_roll2readyrt90_pistol;
	tmp = %thu_cvrmidtns_crch_run2cvr_foregrip;
	tmp = %thu_cvrmidtns_crch_run2cvr_pistol;
	tmp = %thu_cvrmidtns_crch_run2ready_foregrip;
	tmp = %thu_cvrmidtns_crch_run2ready_pistol;
	tmp = %thu_cvrmidtns_crch_run2readylt90_foregrip;
	tmp = %thu_cvrmidtns_crch_run2readylt90_pistol;
	tmp = %thu_cvrmidtns_crch_run2readyrt90_foregrip;
	tmp = %thu_cvrmidtns_crch_run2readyrt90_pistol;
	tmp = %thu_cvrmidtns_crch_runlt2cvr_foregrip;
	tmp = %thu_cvrmidtns_crch_runlt2cvr_pistol;
	tmp = %thu_cvrmidtns_crch_runrt2cvr_foregrip;
	tmp = %thu_cvrmidtns_crch_runrt2cvr_pistol;
	tmp = %thu_cvrmidtns_crch_slide2ready_foregrip;
	tmp = %thu_cvrmidtns_crch_slide2ready_pistol;
	tmp = %thu_cvrmidtns_crch_slide2readylt45_foregrip;
	tmp = %thu_cvrmidtns_crch_slide2readylt45_pistol;
	tmp = %thu_cvrmidtns_crch_slide2readylt90_foregrip;
	tmp = %thu_cvrmidtns_crch_slide2readylt90_pistol;
	tmp = %thu_cvrmidtns_crch_slide2readyrt45_foregrip;
	tmp = %thu_cvrmidtns_crch_slide2readyrt45_pistol;
	tmp = %thu_cvrmidtns_crch_slide2readyrt90_foregrip;
	tmp = %thu_cvrmidtns_crch_slide2readyrt90_pistol;
	tmp = %thu_cvrmidtns_crch_stnd2ready_foregrip;
	tmp = %thu_cvrmidtns_crch_stnd2ready_pistol;
	tmp = %thu_cvrmidtns_crch_stnd2readylt90_foregrip;
	tmp = %thu_cvrmidtns_crch_stnd2readylt90_pistol;
	tmp = %thu_cvrmidtns_crch_stnd2readyrt90_foregrip;
	tmp = %thu_cvrmidtns_crch_stnd2readyrt90_pistol;
	tmp = %thu_cvrmidtns_stnd_ready2idl0_foregrip;
	tmp = %thu_cvrmidtns_stnd_ready2idl0_pistol;
	tmp = %thu_cvrmidtns_stnd_ready2idllt180_foregrip;
	tmp = %thu_cvrmidtns_stnd_ready2idllt180_pistol;
	tmp = %thu_cvrmidtns_stnd_ready2idllt90_foregrip;
	tmp = %thu_cvrmidtns_stnd_ready2idllt90_pistol;
	tmp = %thu_cvrmidtns_stnd_ready2idlrt180_foregrip;
	tmp = %thu_cvrmidtns_stnd_ready2idlrt180_pistol;
	tmp = %thu_cvrmidtns_stnd_ready2idlrt90_foregrip;
	tmp = %thu_cvrmidtns_stnd_ready2idlrt90_pistol;
	tmp = %thu_cvrmidtns_stnd_ready2runlt90_foregrip;
	tmp = %thu_cvrmidtns_stnd_ready2runlt90_pistol;
	tmp = %thu_cvrmidtns_stnd_ready2runrt180_foregrip;
	tmp = %thu_cvrmidtns_stnd_ready2runrt180_pistol;
	tmp = %thu_cvrmidtns_stnd_ready2runrt90_foregrip;
	tmp = %thu_cvrmidtns_stnd_ready2runrt90_pistol;
	tmp = %thu_cvrmidtns_stnd_roll2ready_foregrip;
	tmp = %thu_cvrmidtns_stnd_roll2ready_pistol;
	tmp = %thu_cvrmidtns_stnd_roll2readylt45_foregrip;
	tmp = %thu_cvrmidtns_stnd_roll2readylt45_pistol;
	tmp = %thu_cvrmidtns_stnd_roll2readylt90_foregrip;
	tmp = %thu_cvrmidtns_stnd_roll2readylt90_pistol;
	tmp = %thu_cvrmidtns_stnd_roll2readyrt45_foregrip;
	tmp = %thu_cvrmidtns_stnd_roll2readyrt45_pistol;
	tmp = %thu_cvrmidtns_stnd_roll2readyrt90_foregrip;
	tmp = %thu_cvrmidtns_stnd_roll2readyrt90_pistol;
	tmp = %thu_cvrmidtns_stnd_run2ready_foregrip;
	tmp = %thu_cvrmidtns_stnd_run2ready_pistol;
	tmp = %thu_cvrmidtns_stnd_run2readylt90_foregrip;
	tmp = %thu_cvrmidtns_stnd_run2readylt90_pistol;
	tmp = %thu_cvrmidtns_stnd_run2readyrt90_foregrip;
	tmp = %thu_cvrmidtns_stnd_run2readyrt90_pistol;
	tmp = %thu_cvrmidtns_stnd_slide2ready_foregrip;
	tmp = %thu_cvrmidtns_stnd_slide2ready_pistol;
	tmp = %thu_cvrmidtns_stnd_slide2readylt45_foregrip;
	tmp = %thu_cvrmidtns_stnd_slide2readylt45_pistol;
	tmp = %thu_cvrmidtns_stnd_slide2readylt90_foregrip;
	tmp = %thu_cvrmidtns_stnd_slide2readylt90_pistol;
	tmp = %thu_cvrmidtns_stnd_slide2readyrt45_foregrip;
	tmp = %thu_cvrmidtns_stnd_slide2readyrt45_pistol;
	tmp = %thu_cvrmidtns_stnd_slide2readyrt90_foregrip;
	tmp = %thu_cvrmidtns_stnd_slide2readyrt90_pistol;
	tmp = %thu_cvrmidtns_stnd_stnd2ready_foregrip;
	tmp = %thu_cvrmidtns_stnd_stnd2ready_pistol;
	tmp = %thu_cvrmidtns_stnd_stnd2readylt90_foregrip;
	tmp = %thu_cvrmidtns_stnd_stnd2readylt90_pistol;
	tmp = %thu_cvrmidtns_stnd_stnd2readyrt90_foregrip;
	tmp = %thu_cvrmidtns_stnd_stnd2readyrt90_pistol;
	tmp = %thu_cvrrt_crch_idlready_foregrip;
	tmp = %thu_cvrrt_crch_idlready_pistol;
	tmp = %thu_cvrrt_crch_idlsuppressed_foregrip;
	tmp = %thu_cvrrt_crch_idlsuppressed_pistol;
	tmp = %thu_cvrrt_crch_look_foregrip;
	tmp = %thu_cvrrt_crch_look_pistol;
	tmp = %thu_cvrrt_crch_peekside_foregrip;
	tmp = %thu_cvrrt_crch_peekside_pistol;
	tmp = %thu_cvrrt_crch_peekup_foregrip;
	tmp = %thu_cvrrt_crch_peekup_pistol;
	tmp = %thu_cvrrt_crch_reload_foregrip;
	tmp = %thu_cvrrt_crch_reload_pistol;
	tmp = %thu_cvrrt_crch_shuffle_foregrip;
	tmp = %thu_cvrrt_crch_shuffle_pistol;
	tmp = %thu_cvrrt_crch_shufflefast_foregrip;
	tmp = %thu_cvrrt_crch_shufflefast_pistol;
	tmp = %thu_cvrrt_stnd_idlready_foregrip;
	tmp = %thu_cvrrt_stnd_idlready_pistol;
	tmp = %thu_cvrrt_stnd_idlsuppressed_foregrip;
	tmp = %thu_cvrrt_stnd_idlsuppressed_pistol;
	tmp = %thu_cvrrt_stnd_look_foregrip;
	tmp = %thu_cvrrt_stnd_look_pistol;
	tmp = %thu_cvrrt_stnd_peekside_foregrip;
	tmp = %thu_cvrrt_stnd_peekside_pistol;
	tmp = %thu_cvrrt_stnd_reload_foregrip;
	tmp = %thu_cvrrt_stnd_reload_pistol;
	tmp = %thu_cvrrttns_crch_dive2ready_foregrip;
	tmp = %thu_cvrrttns_crch_dive2ready_pistol;
	tmp = %thu_cvrrttns_crch_dive2readylt90_foregrip;
	tmp = %thu_cvrrttns_crch_dive2readylt90_pistol;
	tmp = %thu_cvrrttns_crch_dive2readyrt90_foregrip;
	tmp = %thu_cvrrttns_crch_dive2readyrt90_pistol;
	tmp = %thu_cvrrttns_crch_ready2idl0_foregrip;
	tmp = %thu_cvrrttns_crch_ready2idl0_pistol;
	tmp = %thu_cvrrttns_crch_ready2idllt180_foregrip;
	tmp = %thu_cvrrttns_crch_ready2idllt180_pistol;
	tmp = %thu_cvrrttns_crch_ready2idllt90_foregrip;
	tmp = %thu_cvrrttns_crch_ready2idllt90_pistol;
	tmp = %thu_cvrrttns_crch_ready2idlrt180_foregrip;
	tmp = %thu_cvrrttns_crch_ready2idlrt180_pistol;
	tmp = %thu_cvrrttns_crch_ready2idlrt90_foregrip;
	tmp = %thu_cvrrttns_crch_ready2idlrt90_pistol;
	tmp = %thu_cvrrttns_crch_ready2run0_foregrip;
	tmp = %thu_cvrrttns_crch_ready2run0_pistol;
	tmp = %thu_cvrrttns_crch_ready2runrt180_foregrip;
	tmp = %thu_cvrrttns_crch_ready2runrt180_pistol;
	tmp = %thu_cvrrttns_crch_roll2ready135_foregrip;
	tmp = %thu_cvrrttns_crch_roll2ready135_pistol;
	tmp = %thu_cvrrttns_crch_roll2ready_foregrip;
	tmp = %thu_cvrrttns_crch_roll2ready_pistol;
	tmp = %thu_cvrrttns_crch_roll2readylt45_foregrip;
	tmp = %thu_cvrrttns_crch_roll2readylt45_pistol;
	tmp = %thu_cvrrttns_crch_roll2readylt90_foregrip;
	tmp = %thu_cvrrttns_crch_roll2readylt90_pistol;
	tmp = %thu_cvrrttns_crch_roll2readyrt45_foregrip;
	tmp = %thu_cvrrttns_crch_roll2readyrt45_pistol;
	tmp = %thu_cvrrttns_crch_roll2readyrt90_foregrip;
	tmp = %thu_cvrrttns_crch_roll2readyrt90_pistol;
	tmp = %thu_cvrrttns_crch_run2ready_foregrip;
	tmp = %thu_cvrrttns_crch_run2ready_pistol;
	tmp = %thu_cvrrttns_crch_run2readylt90_foregrip;
	tmp = %thu_cvrrttns_crch_run2readylt90_pistol;
	tmp = %thu_cvrrttns_crch_run2readyrt90_foregrip;
	tmp = %thu_cvrrttns_crch_run2readyrt90_pistol;
	tmp = %thu_cvrrttns_crch_slide2ready_foregrip;
	tmp = %thu_cvrrttns_crch_slide2ready_pistol;
	tmp = %thu_cvrrttns_crch_slide2readylt45_foregrip;
	tmp = %thu_cvrrttns_crch_slide2readylt45_pistol;
	tmp = %thu_cvrrttns_crch_slide2readylt90_foregrip;
	tmp = %thu_cvrrttns_crch_slide2readylt90_pistol;
	tmp = %thu_cvrrttns_crch_slide2readyrt45_foregrip;
	tmp = %thu_cvrrttns_crch_slide2readyrt45_pistol;
	tmp = %thu_cvrrttns_crch_slide2readyrt90_foregrip;
	tmp = %thu_cvrrttns_crch_slide2readyrt90_pistol;
	tmp = %thu_cvrrttns_crch_stnd2ready_foregrip;
	tmp = %thu_cvrrttns_crch_stnd2ready_pistol;
	tmp = %thu_cvrrttns_crch_stnd2readylt90_foregrip;
	tmp = %thu_cvrrttns_crch_stnd2readylt90_pistol;
	tmp = %thu_cvrrttns_crch_stnd2readyrt90_foregrip;
	tmp = %thu_cvrrttns_crch_stnd2readyrt90_pistol;
	tmp = %thu_cvrrttns_stnd_ready2idl0_foregrip;
	tmp = %thu_cvrrttns_stnd_ready2idl0_pistol;
	tmp = %thu_cvrrttns_stnd_ready2idllt180_foregrip;
	tmp = %thu_cvrrttns_stnd_ready2idllt180_pistol;
	tmp = %thu_cvrrttns_stnd_ready2idllt90_foregrip;
	tmp = %thu_cvrrttns_stnd_ready2idllt90_pistol;
	tmp = %thu_cvrrttns_stnd_ready2idlrt180_foregrip;
	tmp = %thu_cvrrttns_stnd_ready2idlrt180_pistol;
	tmp = %thu_cvrrttns_stnd_ready2idlrt90_foregrip;
	tmp = %thu_cvrrttns_stnd_ready2idlrt90_pistol;
	tmp = %thu_cvrrttns_stnd_ready2run0_foregrip;
	tmp = %thu_cvrrttns_stnd_ready2run0_pistol;
	tmp = %thu_cvrrttns_stnd_ready2runrt180_foregrip;
	tmp = %thu_cvrrttns_stnd_ready2runrt180_pistol;
	tmp = %thu_cvrrttns_stnd_roll2ready135_foregrip;
	tmp = %thu_cvrrttns_stnd_roll2ready135_pistol;
	tmp = %thu_cvrrttns_stnd_roll2ready_foregrip;
	tmp = %thu_cvrrttns_stnd_roll2ready_pistol;
	tmp = %thu_cvrrttns_stnd_roll2readylt45_foregrip;
	tmp = %thu_cvrrttns_stnd_roll2readylt45_pistol;
	tmp = %thu_cvrrttns_stnd_roll2readylt90_foregrip;
	tmp = %thu_cvrrttns_stnd_roll2readylt90_pistol;
	tmp = %thu_cvrrttns_stnd_roll2readyrt45_foregrip;
	tmp = %thu_cvrrttns_stnd_roll2readyrt45_pistol;
	tmp = %thu_cvrrttns_stnd_roll2readyrt90_foregrip;
	tmp = %thu_cvrrttns_stnd_roll2readyrt90_pistol;
	tmp = %thu_cvrrttns_stnd_run2ready_foregrip;
	tmp = %thu_cvrrttns_stnd_run2ready_pistol;
	tmp = %thu_cvrrttns_stnd_run2readylt90_foregrip;
	tmp = %thu_cvrrttns_stnd_run2readylt90_pistol;
	tmp = %thu_cvrrttns_stnd_run2readyrt90_foregrip;
	tmp = %thu_cvrrttns_stnd_run2readyrt90_pistol;
	tmp = %thu_cvrrttns_stnd_slide2ready_foregrip;
	tmp = %thu_cvrrttns_stnd_slide2ready_pistol;
	tmp = %thu_cvrrttns_stnd_slide2readylt45_foregrip;
	tmp = %thu_cvrrttns_stnd_slide2readylt45_pistol;
	tmp = %thu_cvrrttns_stnd_slide2readylt90_foregrip;
	tmp = %thu_cvrrttns_stnd_slide2readylt90_pistol;
	tmp = %thu_cvrrttns_stnd_slide2readyrt45_foregrip;
	tmp = %thu_cvrrttns_stnd_slide2readyrt45_pistol;
	tmp = %thu_cvrrttns_stnd_slide2readyrt90_foregrip;
	tmp = %thu_cvrrttns_stnd_slide2readyrt90_pistol;
	tmp = %thu_cvrrttns_stnd_stnd2ready_foregrip;
	tmp = %thu_cvrrttns_stnd_stnd2ready_pistol;
	tmp = %thu_cvrrttns_stnd_stnd2readylt90_foregrip;
	tmp = %thu_cvrrttns_stnd_stnd2readylt90_pistol;
	tmp = %thu_cvrrttns_stnd_stnd2readyrt90_foregrip;
	tmp = %thu_cvrrttns_stnd_stnd2readyrt90_pistol;
	tmp = %thu_cvrlttns_crch_run2readylt45_foregrip;
	tmp = %thu_cvrlttns_crch_run2readylt45_pistol;
	tmp = %thu_cvrlttns_crch_run2readyrt45_foregrip;
	tmp = %thu_cvrlttns_crch_run2readyrt45_pistol;
	tmp = %thu_cvrlttns_stnd_run2readylt45_foregrip;
	tmp = %thu_cvrlttns_stnd_run2readylt45_pistol;
	tmp = %thu_cvrlttns_stnd_run2readyrt45_foregrip;
	tmp = %thu_cvrlttns_stnd_run2readyrt45_pistol;
	tmp = %thu_cvrmidtns_crch_run2readylt45_foregrip;
	tmp = %thu_cvrmidtns_crch_run2readylt45_pistol;
	tmp = %thu_cvrmidtns_crch_run2readyrt45_foregrip;
	tmp = %thu_cvrmidtns_crch_run2readyrt45_pistol;
	tmp = %thu_cvrmidtns_stnd_run2readylt45_foregrip;
	tmp = %thu_cvrmidtns_stnd_run2readylt45_pistol;
	tmp = %thu_cvrmidtns_stnd_run2readyrt45_foregrip;
	tmp = %thu_cvrmidtns_stnd_run2readyrt45_pistol;
	tmp = %thu_cvrrttns_crch_run2readylt45_foregrip;
	tmp = %thu_cvrrttns_crch_run2readylt45_pistol;
	tmp = %thu_cvrrttns_crch_run2readyrt45_foregrip;
	tmp = %thu_cvrrttns_crch_run2readyrt45_pistol;
	tmp = %thu_cvrrttns_stnd_run2readylt45_foregrip;
	tmp = %thu_cvrrttns_stnd_run2readylt45_pistol;
	tmp = %thu_cvrrttns_stnd_run2readyrt45_foregrip;
	tmp = %thu_cvrrttns_stnd_run2readyrt45_pistol;
    
	tmp = %thu_cvrlt_crouch_die_exp_chest_v1;
	tmp = %thu_cvrlt_crouch_die_exp_chest_v2;
	tmp = %thu_cvrrt_crouch_die_exp_chest_v1;
	tmp = %thu_cvrrt_crouch_die_exp_chest_v2;
	tmp = %thu_cvrlt_crouch_die_ready_chest_v1;
	tmp = %thu_cvrlt_crouch_die_ready_chest_v2;
	tmp = %thu_cvrrt_crouch_die_ready_chest_v1;
	tmp = %thu_cvrrt_crouch_die_ready_chest_v2;
	tmp = %thu_cvrlt_crouch_pain_front_exp_chest;
	tmp = %thu_cvrlt_crouch_pain_front_exp_head;
	tmp = %thu_cvrlt_crouch_pain_front_exp_lleg;
	tmp = %thu_cvrlt_crouch_pain_front_exp_lshoulder;
	tmp = %thu_cvrlt_crouch_pain_front_exp_pelvis;
	tmp = %thu_cvrlt_crouch_pain_front_exp_rleg;
	tmp = %thu_cvrlt_crouch_pain_front_exp_rshoulder;
	tmp = %thu_cvrlt_stand_pain_front_exp_chest;
	tmp = %thu_cvrlt_stand_pain_front_exp_head;
	tmp = %thu_cvrlt_stand_pain_front_exp_lleg;
	tmp = %thu_cvrlt_stand_pain_front_exp_lshoulder;
	tmp = %thu_cvrlt_stand_pain_front_exp_pelvis;
	tmp = %thu_cvrlt_stand_pain_front_exp_rleg;
	tmp = %thu_cvrlt_stand_pain_front_exp_rshoulder;
	tmp = %thu_cvrmid_crouch_pain_front_exp_chest;
	tmp = %thu_cvrmid_crouch_pain_front_exp_head;
	tmp = %thu_cvrmid_crouch_pain_front_exp_lleg;
	tmp = %thu_cvrmid_crouch_pain_front_exp_lshoulder;
	tmp = %thu_cvrmid_crouch_pain_front_exp_pelvis;
	tmp = %thu_cvrmid_crouch_pain_front_exp_rleg;
	tmp = %thu_cvrmid_crouch_pain_front_exp_rshoulder;
	tmp = %thu_cvrmid_stand_pain_front_exp_chest;
	tmp = %thu_cvrmid_stand_pain_front_exp_head;
	tmp = %thu_cvrmid_stand_pain_front_exp_lleg;
	tmp = %thu_cvrmid_stand_pain_front_exp_lshoulder;
	tmp = %thu_cvrmid_stand_pain_front_exp_pelvis;
	tmp = %thu_cvrmid_stand_pain_front_exp_rleg;
	tmp = %thu_cvrmid_stand_pain_front_exp_rshoulder;
	tmp = %thu_cvrrt_crouch_pain_front_exp_chest;
	tmp = %thu_cvrrt_crouch_pain_front_exp_head;
	tmp = %thu_cvrrt_crouch_pain_front_exp_lleg;
	tmp = %thu_cvrrt_crouch_pain_front_exp_lshoulder;
	tmp = %thu_cvrrt_crouch_pain_front_exp_pelvis;
	tmp = %thu_cvrrt_crouch_pain_front_exp_rleg;
	tmp = %thu_cvrrt_crouch_pain_front_exp_rshoulder;
	tmp = %thu_cvrrt_stand_pain_front_exp_chest;
	tmp = %thu_cvrrt_stand_pain_front_exp_head;
	tmp = %thu_cvrrt_stand_pain_front_exp_lleg;
	tmp = %thu_cvrrt_stand_pain_front_exp_lshoulder;
	tmp = %thu_cvrrt_stand_pain_front_exp_pelvis;
	tmp = %thu_cvrrt_stand_pain_front_exp_rleg;
	tmp = %thu_cvrrt_stand_pain_front_exp_rshoulder;
	tmp = %thu_cvrlt_crouch_pain_front_ready_chest;
	tmp = %thu_cvrlt_crouch_pain_front_ready_head;
	tmp = %thu_cvrlt_crouch_pain_front_ready_lleg;
	tmp = %thu_cvrlt_crouch_pain_front_ready_lshoulder;
	tmp = %thu_cvrlt_crouch_pain_front_ready_pelvis;
	tmp = %thu_cvrlt_crouch_pain_front_ready_rleg;
	tmp = %thu_cvrlt_crouch_pain_front_ready_rshoulder;
	tmp = %thu_cvrlt_stand_pain_front_ready_chest;
	tmp = %thu_cvrlt_stand_pain_front_ready_head;
	tmp = %thu_cvrlt_stand_pain_front_ready_lleg;
	tmp = %thu_cvrlt_stand_pain_front_ready_lshoulder;
	tmp = %thu_cvrlt_stand_pain_front_ready_pelvis;
	tmp = %thu_cvrlt_stand_pain_front_ready_rleg;
	tmp = %thu_cvrlt_stand_pain_front_ready_rshoulder;
	tmp = %thu_cvrmid_crouch_pain_front_ready_chest;
	tmp = %thu_cvrmid_crouch_pain_front_ready_head;
	tmp = %thu_cvrmid_crouch_pain_front_ready_lleg;
	tmp = %thu_cvrmid_crouch_pain_front_ready_lshoulder;
	tmp = %thu_cvrmid_crouch_pain_front_ready_pelvis;
	tmp = %thu_cvrmid_crouch_pain_front_ready_rleg;
	tmp = %thu_cvrmid_crouch_pain_front_ready_rshoulder;
	tmp = %thu_cvrmid_stand_pain_front_ready_chest;
	tmp = %thu_cvrmid_stand_pain_front_ready_head;
	tmp = %thu_cvrmid_stand_pain_front_ready_lleg;
	tmp = %thu_cvrmid_stand_pain_front_ready_lshoulder;
	tmp = %thu_cvrmid_stand_pain_front_ready_pelvis;
	tmp = %thu_cvrmid_stand_pain_front_ready_rleg;
	tmp = %thu_cvrmid_stand_pain_front_ready_rshoulder;
	tmp = %thu_cvrrt_crouch_pain_front_ready_chest;
	tmp = %thu_cvrrt_crouch_pain_front_ready_head;
	tmp = %thu_cvrrt_crouch_pain_front_ready_lleg;
	tmp = %thu_cvrrt_crouch_pain_front_ready_lshoulder;
	tmp = %thu_cvrrt_crouch_pain_front_ready_pelvis;
	tmp = %thu_cvrrt_crouch_pain_front_ready_rleg;
	tmp = %thu_cvrrt_crouch_pain_front_ready_rshoulder;
	tmp = %thu_cvrrt_stand_pain_front_ready_chest;
	tmp = %thu_cvrrt_stand_pain_front_ready_head;
	tmp = %thu_cvrrt_stand_pain_front_ready_lleg;
	tmp = %thu_cvrrt_stand_pain_front_ready_lshoulder;
	tmp = %thu_cvrrt_stand_pain_front_ready_pelvis;
	tmp = %thu_cvrrt_stand_pain_front_ready_rleg;
	tmp = %thu_cvrrt_stand_pain_front_ready_rshoulder;
	tmp = %thu_cover_stand_pain_front_exp_flashbangstart;
	tmp = %thu_cover_stand_pain_front_exp_flashbangstart_v2;
	tmp = %thu_cover_stand_pain_front_exp_flashbangstart_v3;
	tmp = %thu_cover_stand_pain_front_exp_flashbangstart_v4;
	tmp = %thu_cover_stand_pain_front_exp_flashbangstart_v5;
	tmp = %thu_cover_stand_pain_front_exp_flashbangloop;
	tmp = %thu_cover_stand_pain_front_exp_flashbangloop_v2;
	tmp = %thu_cover_stand_pain_front_exp_flashbangloop_v3;
	tmp = %thu_cover_stand_pain_front_exp_flashbangloop_v4;
	tmp = %thu_cover_stand_pain_front_exp_flashbangloop_v5;
	tmp = %thu_cvrrt_stand_pain_front_ready_flashbangstart;
	tmp = %thu_cvrlt_stand_pain_front_ready_flashbangstart;
	tmp = %thu_cover_stand_pain_front_exp_concussionstart;
	tmp = %thu_cover_stand_pain_front_exp_concussionstart_v2;
	tmp = %thu_cover_stand_pain_front_exp_concussionstart_v3;
	tmp = %thu_cover_stand_pain_front_exp_concussionloop;
	tmp = %thu_cover_stand_pain_front_exp_concussionloop_v2;
	tmp = %thu_cover_stand_pain_front_exp_concussionloop_v3;
	tmp = %thu_cvrrt_stand_pain_front_ready_concussionstart;
	tmp = %thu_cvrrt_stand_pain_front_ready_concussionstart_v2;
	tmp = %thu_cvrrt_stand_pain_front_ready_concussionloop;
	tmp = %thu_cvrrt_stand_pain_front_ready_concussionloop_v2;
	tmp = %thu_cvrlt_stand_pain_front_ready_concussionstart;
	tmp = %thu_cvrlt_stand_pain_front_ready_concussionstart_v2;
	tmp = %thu_cvrlt_stand_pain_front_ready_concussionloop;
	tmp = %thu_cvrlt_stand_pain_front_ready_concussionloop_v2;
    
	tmp = %thu_alrt_stand_aim2aim_l180_foregrip;
	tmp = %thu_alrt_stand_aim2aim_l180_pistol;
	tmp = %thu_alrt_stand_aim2aim_l90_foregrip;
	tmp = %thu_alrt_stand_aim2aim_l90_pistol;
	tmp = %thu_alrt_stand_aim2aim_r180_foregrip;
	tmp = %thu_alrt_stand_aim2aim_r180_pistol;
	tmp = %thu_alrt_stand_aim2aim_r90_foregrip;
	tmp = %thu_alrt_stand_aim2aim_r90_pistol;
	tmp = %thu_alrt_stand_idl2aim_foregrip;
	tmp = %thu_alrt_stand_idl2aim_l180_foregrip;
	tmp = %thu_alrt_stand_idl2aim_l180_pistol;
	tmp = %thu_alrt_stand_idl2aim_l90_foregrip;
	tmp = %thu_alrt_stand_idl2aim_l90_pistol;
	tmp = %thu_alrt_stand_idl2aim_pistol;
	tmp = %thu_alrt_stand_idl2aim_r180_foregrip;
	tmp = %thu_alrt_stand_idl2aim_r180_pistol;
	tmp = %thu_alrt_stand_idl2aim_r90_foregrip;
	tmp = %thu_alrt_stand_idl2aim_r90_pistol;
	tmp = %thu_alrt_stand_idl_to_tactical_run_fwd_foregrip;
	tmp = %thu_alrt_stand_idl_to_tactical_run_fwd_pistol;
	tmp = %thu_alrt_stand_idl_to_tactical_run_lt_foregrip;
	tmp = %thu_alrt_stand_idl_to_tactical_run_lt_pistol;
	tmp = %thu_alrt_stand_idl_to_tactical_run_rt_foregrip;
	tmp = %thu_alrt_stand_idl_to_tactical_run_rt_pistol;
	tmp = %thu_alrt_stand_run_to_tactical_run_bwd_foregrip;
	tmp = %thu_alrt_stand_run_to_tactical_run_bwd_pistol;
	tmp = %thu_alrt_stand_switchweapondn_foregrip;
	tmp = %thu_alrt_stand_switchweapondn_pistol;
	tmp = %thu_alrt_stand_switchweaponup_foregrip;
	tmp = %thu_alrt_stand_switchweaponup_pistol;
	tmp = %thu_alrt_stnd_run2aimfd_foregrip;
	tmp = %thu_alrt_stnd_run2aimfd_pistol;
	tmp = %thu_alrt_stnd_run2aiml180_foregrip;
	tmp = %thu_alrt_stnd_run2aiml180_pistol;
	tmp = %thu_alrt_stnd_run2aimlt_foregrip;
	tmp = %thu_alrt_stnd_run2aimlt_pistol;
	tmp = %thu_alrt_stnd_run2aimr180_foregrip;
	tmp = %thu_alrt_stnd_run2aimr180_pistol;
	tmp = %thu_alrt_stnd_run2aimrt_foregrip;
	tmp = %thu_alrt_stnd_run2aimrt_pistol;
	tmp = %thu_alrt_stnd_run2crchaimfd_foregrip;
	tmp = %thu_alrt_stnd_run2crchaimfd_pistol;
	tmp = %thu_alrt_stnd_run2crchaiml180_foregrip;
	tmp = %thu_alrt_stnd_run2crchaiml180_pistol;
	tmp = %thu_alrt_stnd_run2crchaimlt_foregrip;
	tmp = %thu_alrt_stnd_run2crchaimlt_pistol;
	tmp = %thu_alrt_stnd_run2crchaimr180_foregrip;
	tmp = %thu_alrt_stnd_run2crchaimr180_pistol;
	tmp = %thu_alrt_stnd_run2crchaimrt_foregrip;
	tmp = %thu_alrt_stnd_run2crchaimrt_pistol;
	tmp = %thu_alrt_stnd_tactical_walkbackward_foregrip;
	tmp = %thu_alrt_stnd_tactical_walkbackward_pistol;
	tmp = %thu_alrt_stnd_tactical_walkforward_foregrip;
	tmp = %thu_alrt_stnd_tactical_walkforward_pistol;
	tmp = %thu_alrt_stnd_tactical_walkleft_foregrip;
	tmp = %thu_alrt_stnd_tactical_walkleft_pistol;
	tmp = %thu_alrt_stnd_tactical_walkright_foregrip;
	tmp = %thu_alrt_stnd_tactical_walkright_pistol;
	tmp = %thu_crouch_aim_dn_foregrip;
	tmp = %thu_crouch_aim_dn_pistol;
	tmp = %thu_crouch_aim_dnfire_foregrip;
	tmp = %thu_crouch_aim_dnfire_pistol;
	tmp = %thu_crouch_aim_loop_dn_foregrip;
	tmp = %thu_crouch_aim_loop_dn_pistol;
	tmp = %thu_crouch_aim_loop_mid_foregrip;
	tmp = %thu_crouch_aim_loop_mid_pistol;
	tmp = %thu_crouch_aim_loop_up_foregrip;
	tmp = %thu_crouch_aim_loop_up_pistol;
	tmp = %thu_crouch_aim_mid_foregrip;
	tmp = %thu_crouch_aim_mid_pistol;
	tmp = %thu_crouch_aim_midfire_foregrip;
	tmp = %thu_crouch_aim_midfire_pistol;
	tmp = %thu_crouch_aim_up_foregrip;
	tmp = %thu_crouch_aim_up_pistol;
	tmp = %thu_crouch_aim_upfire_foregrip;
	tmp = %thu_crouch_aim_upfire_pistol;
	tmp = %thu_relax_stand_idl2aim_foregrip;
	tmp = %thu_relax_stand_idl2aim_l180_foregrip;
	tmp = %thu_relax_stand_idl2aim_l180_pistol;
	tmp = %thu_relax_stand_idl2aim_l90_foregrip;
	tmp = %thu_relax_stand_idl2aim_l90_pistol;
	tmp = %thu_relax_stand_idl2aim_pistol;
	tmp = %thu_relax_stand_idl2aim_r180_foregrip;
	tmp = %thu_relax_stand_idl2aim_r180_pistol;
	tmp = %thu_relax_stand_idl2aim_r90_foregrip;
	tmp = %thu_relax_stand_idl2aim_r90_pistol;
	tmp = %thu_stand_reload_shotgun;
	tmp = %thu_stnd_aim_dn_foregrip;
	tmp = %thu_stnd_aim_dn_pistol;
	tmp = %thu_stnd_aim_dnfire_foregrip;
	tmp = %thu_stnd_aim_dnfire_pistol;
	tmp = %thu_stnd_aim_dnfire_shotgun;
	tmp = %thu_stnd_aim_loop_dn_foregrip;
	tmp = %thu_stnd_aim_loop_dn_pistol;
	tmp = %thu_stnd_aim_loop_mid_foregrip;
	tmp = %thu_stnd_aim_loop_mid_pistol;
	tmp = %thu_stnd_aim_loop_up_foregrip;
	tmp = %thu_stnd_aim_loop_up_pistol;
	tmp = %thu_stnd_aim_mid_foregrip;
	tmp = %thu_stnd_aim_mid_pistol;
	tmp = %thu_stnd_aim_midfire_foregrip;
	tmp = %thu_stnd_aim_midfire_pistol;
	tmp = %thu_stnd_aim_midfire_shotgun;
	tmp = %thu_stnd_aim_up_foregrip;
	tmp = %thu_stnd_aim_up_pistol;
	tmp = %thu_stnd_aim_upfire_foregrip;
	tmp = %thu_stnd_aim_upfire_pistol;
	tmp = %thu_stnd_aim_upfire_shotgun;
	tmp = %thu_stnd_blindfire_runfd_foregrip;
	tmp = %thu_stnd_blindfire_runfd_pistol;
	tmp = %thu_stnd_fire_runbk_foregrip;
	tmp = %thu_stnd_fire_runbk_pistol;
	tmp = %thu_stnd_fire_runfd_foregrip;
	tmp = %thu_stnd_fire_runfd_pistol;
	tmp = %thu_stnd_fire_runlt_foregrip;
	tmp = %thu_stnd_fire_runlt_pistol;
	tmp = %thu_stnd_fire_runrt_foregrip;
	tmp = %thu_stnd_fire_runrt_pistol;
	tmp = %thu_susp_stand_idl2aim_foregrip;
	tmp = %thu_susp_stand_idl2aim_l180_foregrip;
	tmp = %thu_susp_stand_idl2aim_l180_pistol;
	tmp = %thu_susp_stand_idl2aim_l90_foregrip;
	tmp = %thu_susp_stand_idl2aim_l90_pistol;
	tmp = %thu_susp_stand_idl2aim_pistol;
	tmp = %thu_susp_stand_idl2aim_r180_foregrip;
	tmp = %thu_susp_stand_idl2aim_r180_pistol;
	tmp = %thu_susp_stand_idl2aim_r90_foregrip;
	tmp = %thu_susp_stand_idl2aim_r90_pistol;
	tmp = %thu_alrt_crouch_switchweapondn_foregrip;
	tmp = %thu_alrt_crouch_switchweapondn_pistol;
	tmp = %thu_alrt_crouch_switchweaponup_foregrip;
	tmp = %thu_alrt_crouch_switchweaponup_pistol;
    
	tmp = %thu_alrt_crouch_idl_foregrip;
	tmp = %thu_alrt_crouch_idl_pistol;
	tmp = %thu_alrt_crouch_idl_turn_l180_foregrip;
	tmp = %thu_alrt_crouch_idl_turn_l180_pistol;
	tmp = %thu_alrt_crouch_idl_turn_l90_foregrip;
	tmp = %thu_alrt_crouch_idl_turn_l90_pistol;
	tmp = %thu_alrt_crouch_idl_turn_r180_foregrip;
	tmp = %thu_alrt_crouch_idl_turn_r180_pistol;
	tmp = %thu_alrt_crouch_idl_turn_r90_foregrip;
	tmp = %thu_alrt_crouch_idl_turn_r90_pistol;
	tmp = %thu_alrt_crouch_run_foregrip;
	tmp = %thu_alrt_crouch_run_pistol;
	tmp = %thu_alrt_crouch_walk_foregrip;
	tmp = %thu_alrt_crouch_walk_pistol;
	tmp = %thu_alrt_idle_test;
	tmp = %thu_alrt_stand_idl_foregrip;
	tmp = %thu_alrt_stand_idl_pistol;
	tmp = %thu_alrt_stand_idl_to_run_foregrip;
	tmp = %thu_alrt_stand_idl_to_run_l180_foregrip;
	tmp = %thu_alrt_stand_idl_to_run_l180_pistol;
	tmp = %thu_alrt_stand_idl_to_run_l90_foregrip;
	tmp = %thu_alrt_stand_idl_to_run_l90_pistol;
	tmp = %thu_alrt_stand_idl_to_run_pistol;
	tmp = %thu_alrt_stand_idl_to_run_r180_foregrip;
	tmp = %thu_alrt_stand_idl_to_run_r180_pistol;
	tmp = %thu_alrt_stand_idl_to_run_r90_foregrip;
	tmp = %thu_alrt_stand_idl_to_run_r90_pistol;
	tmp = %thu_alrt_stand_idl_to_run_v2_foregrip;
	tmp = %thu_alrt_stand_idl_to_run_v2_pistol;
	tmp = %thu_alrt_stand_idl_to_walk_foregrip;
	tmp = %thu_alrt_stand_idl_to_walk_l180_foregrip;
	tmp = %thu_alrt_stand_idl_to_walk_l180_pistol;
	tmp = %thu_alrt_stand_idl_to_walk_l90_foregrip;
	tmp = %thu_alrt_stand_idl_to_walk_l90_pistol;
	tmp = %thu_alrt_stand_idl_to_walk_pistol;
	tmp = %thu_alrt_stand_idl_to_walk_r180_foregrip;
	tmp = %thu_alrt_stand_idl_to_walk_r180_pistol;
	tmp = %thu_alrt_stand_idl_to_walk_r90_foregrip;
	tmp = %thu_alrt_stand_idl_to_walk_r90_pistol;
	tmp = %thu_alrt_stand_idl_turn_l180_foregrip;
	tmp = %thu_alrt_stand_idl_turn_l180_pistol;
	tmp = %thu_alrt_stand_idl_turn_l45_foregrip;
	tmp = %thu_alrt_stand_idl_turn_l45_pistol;
	tmp = %thu_alrt_stand_idl_turn_l90_foregrip;
	tmp = %thu_alrt_stand_idl_turn_l90_pistol;
	tmp = %thu_alrt_stand_idl_turn_r180_foregrip;
	tmp = %thu_alrt_stand_idl_turn_r180_pistol;
	tmp = %thu_alrt_stand_idl_turn_r45_foregrip;
	tmp = %thu_alrt_stand_idl_turn_r45_pistol;
	tmp = %thu_alrt_stand_idl_turn_r90_foregrip;
	tmp = %thu_alrt_stand_idl_turn_r90_pistol;
	tmp = %thu_alrt_stand_idl_v2_foregrip;
	tmp = %thu_alrt_stand_idl_v2_pistol;
	tmp = %thu_alrt_stand_idl_v3_foregrip;
	tmp = %thu_alrt_stand_idl_v3_pistol;
	tmp = %thu_alrt_stand_run_foregrip;
	tmp = %thu_alrt_stand_run_pistol;
	tmp = %thu_alrt_stand_run_to_idl_foregrip;
	tmp = %thu_alrt_stand_run_to_idl_pistol;
	tmp = %thu_alrt_stand_run_turn_l180_foregrip;
	tmp = %thu_alrt_stand_run_turn_l180_pistol;
	tmp = %thu_alrt_stand_run_turn_l45_foregrip;
	tmp = %thu_alrt_stand_run_turn_l45_pistol;
	tmp = %thu_alrt_stand_run_turn_l90_foregrip;
	tmp = %thu_alrt_stand_run_turn_l90_pistol;
	tmp = %thu_alrt_stand_run_turn_r180_foregrip;
	tmp = %thu_alrt_stand_run_turn_r180_pistol;
	tmp = %thu_alrt_stand_run_turn_r45_foregrip;
	tmp = %thu_alrt_stand_run_turn_r45_pistol;
	tmp = %thu_alrt_stand_run_turn_r90_foregrip;
	tmp = %thu_alrt_stand_run_turn_r90_pistol;
	tmp = %thu_alrt_stand_sprint_foregrip;
	tmp = %thu_alrt_stand_sprint_pistol;
	tmp = %thu_alrt_stand_sprint_turn_l180_foregrip;
	tmp = %thu_alrt_stand_sprint_turn_l180_pistol;
	tmp = %thu_alrt_stand_sprint_turn_l45_foregrip;
	tmp = %thu_alrt_stand_sprint_turn_l45_pistol;
	tmp = %thu_alrt_stand_sprint_turn_l90_foregrip;
	tmp = %thu_alrt_stand_sprint_turn_l90_pistol;
	tmp = %thu_alrt_stand_sprint_turn_r180_foregrip;
	tmp = %thu_alrt_stand_sprint_turn_r180_pistol;
	tmp = %thu_alrt_stand_sprint_turn_r45_foregrip;
	tmp = %thu_alrt_stand_sprint_turn_r45_pistol;
	tmp = %thu_alrt_stand_sprint_turn_r90_foregrip;
	tmp = %thu_alrt_stand_sprint_turn_r90_pistol;
	tmp = %thu_alrt_stand_walk_foregrip;
	tmp = %thu_alrt_stand_walk_pistol;
	tmp = %thu_alrt_stand_walk_to_idl_foregrip;
	tmp = %thu_alrt_stand_walk_to_idl_pistol;
	tmp = %thu_alrt_stand_walk_turn_l180_foregrip;
	tmp = %thu_alrt_stand_walk_turn_l180_pistol;
	tmp = %thu_alrt_stand_walk_turn_l45_foregrip;
	tmp = %thu_alrt_stand_walk_turn_l45_pistol;
	tmp = %thu_alrt_stand_walk_turn_l90_foregrip;
	tmp = %thu_alrt_stand_walk_turn_l90_pistol;
	tmp = %thu_alrt_stand_walk_turn_r180_foregrip;
	tmp = %thu_alrt_stand_walk_turn_r180_pistol;
	tmp = %thu_alrt_stand_walk_turn_r45_foregrip;
	tmp = %thu_alrt_stand_walk_turn_r45_pistol;
	tmp = %thu_alrt_stand_walk_turn_r90_foregrip;
	tmp = %thu_alrt_stand_walk_turn_r90_pistol;
	tmp = %thu_alrt_stand_walk_v2_foregrip;
	tmp = %thu_alrt_stand_walk_v2_pistol;
	tmp = %thu_alrt_stand_walk_v3_foregrip;
	tmp = %thu_alrt_stand_walk_v3_pistol;
	tmp = %thu_alrt_trnsrfl2hgn_dn_stnd;
	tmp = %thu_alrt_trnsrfl2hgn_up_stnd;
	tmp = %thu_alrt_turn_180;
	tmp = %thu_alrt_turn_45;
	tmp = %thu_alrt_turn_90;
	tmp = %thu_alrt_turn_n45;
	tmp = %thu_alrt_turn_n90;
	tmp = %thu_crouch_reload_foregrip;
	tmp = %thu_crouch_reload_pistol;
	tmp = %thu_fac_alrt;
	tmp = %thu_fac_death;
	tmp = %thu_fac_die;
	tmp = %thu_fac_fire;
	tmp = %thu_fac_pain;
	tmp = %thu_fac_relax;
	tmp = %thu_fac_speak;
	tmp = %thu_fac_susp;
	tmp = %thu_laptop;
	tmp = %thu_laptop_lowersurface;
	tmp = %thu_relax_stand_fidget_v1_foregrip;
	tmp = %thu_relax_stand_fidget_v1_pistol;
	tmp = %thu_relax_stand_fidget_v2_foregrip;
	tmp = %thu_relax_stand_fidget_v2_pistol;
	tmp = %thu_relax_stand_fidget_v3_foregrip;
	tmp = %thu_relax_stand_fidget_v3_pistol;
	tmp = %thu_relax_stand_fidget_v4_foregrip;
	tmp = %thu_relax_stand_fidget_v4_pistol;
	tmp = %thu_relax_stand_fidget_v5_foregrip;
	tmp = %thu_relax_stand_fidget_v5_pistol;
	tmp = %thu_relax_stand_idl_foregrip;
	tmp = %thu_relax_stand_idl_pistol;
	tmp = %thu_relax_stand_idl_to_run_foregrip;
	tmp = %thu_relax_stand_idl_to_run_l180_foregrip;
	tmp = %thu_relax_stand_idl_to_run_l180_pistol;
	tmp = %thu_relax_stand_idl_to_run_l90_foregrip;
	tmp = %thu_relax_stand_idl_to_run_l90_pistol;
	tmp = %thu_relax_stand_idl_to_run_pistol;
	tmp = %thu_relax_stand_idl_to_run_r180_foregrip;
	tmp = %thu_relax_stand_idl_to_run_r180_pistol;
	tmp = %thu_relax_stand_idl_to_run_r90_foregrip;
	tmp = %thu_relax_stand_idl_to_run_r90_pistol;
	tmp = %thu_relax_stand_idl_to_run_v2_foregrip;
	tmp = %thu_relax_stand_idl_to_run_v2_pistol;
	tmp = %thu_relax_stand_idl_to_walk_foregrip;
	tmp = %thu_relax_stand_idl_to_walk_l180_foregrip;
	tmp = %thu_relax_stand_idl_to_walk_l180_pistol;
	tmp = %thu_relax_stand_idl_to_walk_l90_foregrip;
	tmp = %thu_relax_stand_idl_to_walk_l90_pistol;
	tmp = %thu_relax_stand_idl_to_walk_pistol;
	tmp = %thu_relax_stand_idl_to_walk_r180_foregrip;
	tmp = %thu_relax_stand_idl_to_walk_r180_pistol;
	tmp = %thu_relax_stand_idl_to_walk_r90_foregrip;
	tmp = %thu_relax_stand_idl_to_walk_r90_pistol;
	tmp = %thu_relax_stand_idl_turn_l180_foregrip;
	tmp = %thu_relax_stand_idl_turn_l180_pistol;
	tmp = %thu_relax_stand_idl_turn_l45_foregrip;
	tmp = %thu_relax_stand_idl_turn_l45_pistol;
	tmp = %thu_relax_stand_idl_turn_l90_foregrip;
	tmp = %thu_relax_stand_idl_turn_l90_pistol;
	tmp = %thu_relax_stand_idl_turn_r180_foregrip;
	tmp = %thu_relax_stand_idl_turn_r180_pistol;
	tmp = %thu_relax_stand_idl_turn_r45_foregrip;
	tmp = %thu_relax_stand_idl_turn_r45_pistol;
	tmp = %thu_relax_stand_idl_turn_r90_foregrip;
	tmp = %thu_relax_stand_idl_turn_r90_pistol;
	tmp = %thu_relax_stand_run_foregrip;
	tmp = %thu_relax_stand_run_pistol;
	tmp = %thu_relax_stand_run_to_idl_foregrip;
	tmp = %thu_relax_stand_run_to_idl_pistol;
	tmp = %thu_relax_stand_run_turn_l180_foregrip;
	tmp = %thu_relax_stand_run_turn_l180_pistol;
	tmp = %thu_relax_stand_run_turn_l45_foregrip;
	tmp = %thu_relax_stand_run_turn_l45_pistol;
	tmp = %thu_relax_stand_run_turn_l90_foregrip;
	tmp = %thu_relax_stand_run_turn_l90_pistol;
	tmp = %thu_relax_stand_run_turn_r180_foregrip;
	tmp = %thu_relax_stand_run_turn_r180_pistol;
	tmp = %thu_relax_stand_run_turn_r45_foregrip;
	tmp = %thu_relax_stand_run_turn_r45_pistol;
	tmp = %thu_relax_stand_run_turn_r90_foregrip;
	tmp = %thu_relax_stand_run_turn_r90_pistol;
	tmp = %thu_relax_stand_walk_foregrip;
	tmp = %thu_relax_stand_walk_pistol;
	tmp = %thu_relax_stand_walk_scanlt_foregrip;
	tmp = %thu_relax_stand_walk_scanlt_pistol;
	tmp = %thu_relax_stand_walk_scanmid_foregrip;
	tmp = %thu_relax_stand_walk_scanmid_pistol;
	tmp = %thu_relax_stand_walk_scanrt_foregrip;
	tmp = %thu_relax_stand_walk_scanrt_pistol;
	tmp = %thu_relax_stand_walk_to_idl_foregrip;
	tmp = %thu_relax_stand_walk_to_idl_pistol;
	tmp = %thu_relax_stand_walk_turn_l180_foregrip;
	tmp = %thu_relax_stand_walk_turn_l180_pistol;
	tmp = %thu_relax_stand_walk_turn_l45_foregrip;
	tmp = %thu_relax_stand_walk_turn_l45_pistol;
	tmp = %thu_relax_stand_walk_turn_l90_foregrip;
	tmp = %thu_relax_stand_walk_turn_l90_pistol;
	tmp = %thu_relax_stand_walk_turn_r180_foregrip;
	tmp = %thu_relax_stand_walk_turn_r180_pistol;
	tmp = %thu_relax_stand_walk_turn_r45_foregrip;
	tmp = %thu_relax_stand_walk_turn_r45_pistol;
	tmp = %thu_relax_stand_walk_turn_r90_foregrip;
	tmp = %thu_relax_stand_walk_turn_r90_pistol;
	tmp = %thu_relax_stand_walk_v2_foregrip;
	tmp = %thu_relax_stand_walk_v2_pistol;
	tmp = %thu_relax_stand_walk_v3_foregrip;
	tmp = %thu_relax_stand_walk_v3_pistol;
	tmp = %thu_stand_callout_foregrip;
	tmp = %thu_stand_callout_pistol;
	tmp = %thu_stand_confront_foregrip;
	tmp = %thu_stand_confront_pistol;
	tmp = %thu_stand_dive_fd_foregrip;
	tmp = %thu_stand_dive_fd_pistol;
	tmp = %thu_stand_diveroll_fd_foregrip;
	tmp = %thu_stand_diveroll_fd_pistol;
	tmp = %thu_stand_flinch_v1_foregrip;
	tmp = %thu_stand_flinch_v1_pistol;
	tmp = %thu_stand_flinch_v2_foregrip;
	tmp = %thu_stand_flinch_v2_pistol;
	tmp = %thu_stand_flinch_v3_foregrip;
	tmp = %thu_stand_flinch_v3_pistol;
	tmp = %thu_stand_grenade_throw_foregrip;
	tmp = %thu_stand_grenade_throw_pistol;
	tmp = %thu_stand_idl_to_lookbehindleft_foregrip;
	tmp = %thu_stand_idl_to_lookbehindleft_pistol;
	tmp = %thu_stand_idl_to_lookbehindright_foregrip;
	tmp = %thu_stand_idl_to_lookbehindright_pistol;
	tmp = %thu_stand_idl_turn_180_foregrip;
	tmp = %thu_stand_idl_turn_180_pistol;
	tmp = %thu_stand_idl_turn_l45_foregrip;
	tmp = %thu_stand_idl_turn_l45_pistol;
	tmp = %thu_stand_idl_turn_l90_foregrip;
	tmp = %thu_stand_idl_turn_l90_pistol;
	tmp = %thu_stand_idl_turn_r45_foregrip;
	tmp = %thu_stand_idl_turn_r45_pistol;
	tmp = %thu_stand_idl_turn_r90_foregrip;
	tmp = %thu_stand_idl_turn_r90_pistol;
	tmp = %thu_stand_idle2listenbackleft_foregrip;
	tmp = %thu_stand_idle2listenbackleft_pistol;
	tmp = %thu_stand_idle2listenbackright_foregrip;
	tmp = %thu_stand_idle2listenbackright_pistol;
	tmp = %thu_stand_inquire_foregrip;
	tmp = %thu_stand_inquire_pistol;
	tmp = %thu_stand_jab_foregrip;
	tmp = %thu_stand_jab_pistol;
	tmp = %thu_stand_listenbackleft2idle_foregrip;
	tmp = %thu_stand_listenbackleft2idle_pistol;
	tmp = %thu_stand_listenbackleft_foregrip;
	tmp = %thu_stand_listenbackleft_pistol;
	tmp = %thu_stand_listenbackright2idle_foregrip;
	tmp = %thu_stand_listenbackright2idle_pistol;
	tmp = %thu_stand_listenbackright_foregrip;
	tmp = %thu_stand_listenbackright_pistol;
	tmp = %thu_stand_listenfront_foregrip;
	tmp = %thu_stand_listenfront_pistol;
	tmp = %thu_stand_lookbehindleft_foregrip;
	tmp = %thu_stand_lookbehindleft_pistol;
	tmp = %thu_stand_lookbehindleft_to_idl_foregrip;
	tmp = %thu_stand_lookbehindleft_to_idl_pistol;
	tmp = %thu_stand_lookbehindright_foregrip;
	tmp = %thu_stand_lookbehindright_pistol;
	tmp = %thu_stand_lookbehindright_to_idl_foregrip;
	tmp = %thu_stand_lookbehindright_to_idl_pistol;
	tmp = %thu_stand_lookfront_foregrip;
	tmp = %thu_stand_lookfront_pistol;
	tmp = %thu_stand_lookover_foregrip;
	tmp = %thu_stand_lookover_pistol;
	tmp = %thu_stand_lookoverend_foregrip;
	tmp = %thu_stand_lookoverend_pistol;
	tmp = %thu_stand_lookoverstart_foregrip;
	tmp = %thu_stand_lookoverstart_pistol;
	tmp = %thu_stand_meleeattack_foregrip;
	tmp = %thu_stand_meleeattack_pistol;
	tmp = %thu_stand_meleeready_foregrip;
	tmp = %thu_stand_meleeready_pistol;
	tmp = %thu_stand_noticebond_foregrip;
	tmp = %thu_stand_noticebond_pistol;
	tmp = %thu_stand_noticebondloop_foregrip;
	tmp = %thu_stand_noticebondloop_pistol;
	tmp = %thu_stand_push_foregrip;
	tmp = %thu_stand_push_pistol;
	tmp = %thu_stand_reload_foregrip;
	tmp = %thu_stand_reload_pistol;
	tmp = %thu_stand_scan_foregrip;
	tmp = %thu_stand_scan_pistol;
	tmp = %thu_stand_scratch_foregrip;
	tmp = %thu_stand_scratch_pistol;
	tmp = %thu_stand_stare_foregrip;
	tmp = %thu_stand_stare_pistol;
	tmp = %thu_stand_talk_a1_foregrip;
	tmp = %thu_stand_talk_a1_pistol;
	tmp = %thu_stand_talk_a2_foregrip;
	tmp = %thu_stand_talk_a2_pistol;
	tmp = %thu_susp_stand_idl_foregrip;
	tmp = %thu_susp_stand_idl_pistol;
	tmp = %thu_susp_stand_idl_to_run_foregrip;
	tmp = %thu_susp_stand_idl_to_run_l180_foregrip;
	tmp = %thu_susp_stand_idl_to_run_l180_pistol;
	tmp = %thu_susp_stand_idl_to_run_l90_foregrip;
	tmp = %thu_susp_stand_idl_to_run_l90_pistol;
	tmp = %thu_susp_stand_idl_to_run_pistol;
	tmp = %thu_susp_stand_idl_to_run_r180_foregrip;
	tmp = %thu_susp_stand_idl_to_run_r180_pistol;
	tmp = %thu_susp_stand_idl_to_run_r90_foregrip;
	tmp = %thu_susp_stand_idl_to_run_r90_pistol;
	tmp = %thu_susp_stand_idl_to_run_v2_foregrip;
	tmp = %thu_susp_stand_idl_to_run_v2_pistol;
	tmp = %thu_susp_stand_idl_to_walk_foregrip;
	tmp = %thu_susp_stand_idl_to_walk_l180_foregrip;
	tmp = %thu_susp_stand_idl_to_walk_l180_pistol;
	tmp = %thu_susp_stand_idl_to_walk_l90_foregrip;
	tmp = %thu_susp_stand_idl_to_walk_l90_pistol;
	tmp = %thu_susp_stand_idl_to_walk_pistol;
	tmp = %thu_susp_stand_idl_to_walk_r180_foregrip;
	tmp = %thu_susp_stand_idl_to_walk_r180_pistol;
	tmp = %thu_susp_stand_idl_to_walk_r90_foregrip;
	tmp = %thu_susp_stand_idl_to_walk_r90_pistol;
	tmp = %thu_susp_stand_idl_turn_l180_foregrip;
	tmp = %thu_susp_stand_idl_turn_l180_pistol;
	tmp = %thu_susp_stand_idl_turn_l45_foregrip;
	tmp = %thu_susp_stand_idl_turn_l45_pistol;
	tmp = %thu_susp_stand_idl_turn_l90_foregrip;
	tmp = %thu_susp_stand_idl_turn_l90_pistol;
	tmp = %thu_susp_stand_idl_turn_r180_foregrip;
	tmp = %thu_susp_stand_idl_turn_r180_pistol;
	tmp = %thu_susp_stand_idl_turn_r45_foregrip;
	tmp = %thu_susp_stand_idl_turn_r45_pistol;
	tmp = %thu_susp_stand_idl_turn_r90_foregrip;
	tmp = %thu_susp_stand_idl_turn_r90_pistol;
	tmp = %thu_susp_stand_idl_v2_foregrip;
	tmp = %thu_susp_stand_idl_v2_pistol;
	tmp = %thu_susp_stand_idl_v3_foregrip;
	tmp = %thu_susp_stand_idl_v3_pistol;
	tmp = %thu_susp_stand_run_foregrip;
	tmp = %thu_susp_stand_run_pistol;
	tmp = %thu_susp_stand_run_to_idl_foregrip;
	tmp = %thu_susp_stand_run_to_idl_pistol;
	tmp = %thu_susp_stand_run_turn_l180_foregrip;
	tmp = %thu_susp_stand_run_turn_l180_pistol;
	tmp = %thu_susp_stand_run_turn_l45_foregrip;
	tmp = %thu_susp_stand_run_turn_l45_pistol;
	tmp = %thu_susp_stand_run_turn_l90_foregrip;
	tmp = %thu_susp_stand_run_turn_l90_pistol;
	tmp = %thu_susp_stand_run_turn_r180_foregrip;
	tmp = %thu_susp_stand_run_turn_r180_pistol;
	tmp = %thu_susp_stand_run_turn_r45_foregrip;
	tmp = %thu_susp_stand_run_turn_r45_pistol;
	tmp = %thu_susp_stand_run_turn_r90_foregrip;
	tmp = %thu_susp_stand_run_turn_r90_pistol;
	tmp = %thu_susp_stand_walk_foregrip;
	tmp = %thu_susp_stand_walk_pistol;
	tmp = %thu_susp_stand_walk_to_idl_foregrip;
	tmp = %thu_susp_stand_walk_to_idl_pistol;
	tmp = %thu_susp_stand_walk_turn_l180_foregrip;
	tmp = %thu_susp_stand_walk_turn_l180_pistol;
	tmp = %thu_susp_stand_walk_turn_l45_foregrip;
	tmp = %thu_susp_stand_walk_turn_l45_pistol;
	tmp = %thu_susp_stand_walk_turn_l90_foregrip;
	tmp = %thu_susp_stand_walk_turn_l90_pistol;
	tmp = %thu_susp_stand_walk_turn_r180_foregrip;
	tmp = %thu_susp_stand_walk_turn_r180_pistol;
	tmp = %thu_susp_stand_walk_turn_r45_foregrip;
	tmp = %thu_susp_stand_walk_turn_r45_pistol;
	tmp = %thu_susp_stand_walk_turn_r90_foregrip;
	tmp = %thu_susp_stand_walk_turn_r90_pistol;
	tmp = %thu_susp_stand_walk_v2_foregrip;
	tmp = %thu_susp_stand_walk_v2_pistol;
	tmp = %thu_susp_stand_walk_v3_foregrip;
	tmp = %thu_susp_stand_walk_v3_pistol;
    
	tmp = %thu_dead_still;
	tmp = %thu_stand_die_back_idle_chest_v1;
	tmp = %thu_stand_die_back_idle_chest_v2;
	tmp = %thu_stand_die_back_idle_chest_v3;
	tmp = %thu_stand_die_back_idle_head_v1;
	tmp = %thu_stand_die_back_idle_head_v2;
	tmp = %thu_stand_die_back_idle_head_v3;
	tmp = %thu_stand_die_back_idle_lleg;
	tmp = %thu_stand_die_back_idle_lshoulder;
	tmp = %thu_stand_die_back_idle_pelvis_v1;
	tmp = %thu_stand_die_back_idle_pelvis_v2;
	tmp = %thu_stand_die_back_idle_pelvis_v3;
	tmp = %thu_stand_die_back_idle_rleg;
	tmp = %thu_stand_die_back_idle_rshoulder;
	tmp = %thu_stand_die_back_run_chest;
	tmp = %thu_stand_die_back_run_head;
	tmp = %thu_stand_die_back_run_lleg;
	tmp = %thu_stand_die_back_run_lshoulder;
	tmp = %thu_stand_die_back_run_pelvis;
	tmp = %thu_stand_die_back_run_rleg;
	tmp = %thu_stand_die_back_run_rshoulder;
	tmp = %thu_stand_die_back_runbackward_chest;
	tmp = %thu_stand_die_back_runbackward_head;
	tmp = %thu_stand_die_back_runbackward_lleg;
	tmp = %thu_stand_die_back_runbackward_lshoulder;
	tmp = %thu_stand_die_back_runbackward_pelvis;
	tmp = %thu_stand_die_back_runbackward_rleg;
	tmp = %thu_stand_die_back_runbackward_rshoulder;
	tmp = %thu_stand_die_back_runleft_chest;
	tmp = %thu_stand_die_back_runleft_head;
	tmp = %thu_stand_die_back_runleft_lleg;
	tmp = %thu_stand_die_back_runleft_lshoulder;
	tmp = %thu_stand_die_back_runleft_pelvis;
	tmp = %thu_stand_die_back_runleft_rleg;
	tmp = %thu_stand_die_back_runleft_rshoulder;
	tmp = %thu_stand_die_back_runright_chest;
	tmp = %thu_stand_die_back_runright_head;
	tmp = %thu_stand_die_back_runright_lleg;
	tmp = %thu_stand_die_back_runright_lshoulder;
	tmp = %thu_stand_die_back_runright_pelvis;
	tmp = %thu_stand_die_back_runright_rleg;
	tmp = %thu_stand_die_back_runright_rshoulder;
	tmp = %thu_stand_die_front_balcony_frontfalling;
	tmp = %thu_stand_die_front_balcony_frontout;
	tmp = %thu_stand_die_front_idle_chest_v1;
	tmp = %thu_stand_die_front_idle_chest_v2;
	tmp = %thu_stand_die_front_idle_chest_v3;
	tmp = %thu_stand_die_front_idle_head_v1;
	tmp = %thu_stand_die_front_idle_head_v2;
	tmp = %thu_stand_die_front_idle_head_v3;
	tmp = %thu_stand_die_front_idle_lleg;
	tmp = %thu_stand_die_front_idle_lshoulder;
	tmp = %thu_stand_die_front_idle_pelvis_v1;
	tmp = %thu_stand_die_front_idle_pelvis_v2;
	tmp = %thu_stand_die_front_idle_pelvis_v3;
	tmp = %thu_stand_die_front_idle_rleg;
	tmp = %thu_stand_die_front_idle_rshoulder;
	tmp = %thu_stand_die_front_run_chest;
	tmp = %thu_stand_die_front_run_head;
	tmp = %thu_stand_die_front_run_lleg;
	tmp = %thu_stand_die_front_run_lshoulder;
	tmp = %thu_stand_die_front_run_pelvis;
	tmp = %thu_stand_die_front_run_rleg;
	tmp = %thu_stand_die_front_run_rshoulder;
	tmp = %thu_stand_die_front_runbackward_chest;
	tmp = %thu_stand_die_front_runbackward_head;
	tmp = %thu_stand_die_front_runbackward_lleg;
	tmp = %thu_stand_die_front_runbackward_lshoulder;
	tmp = %thu_stand_die_front_runbackward_pelvis;
	tmp = %thu_stand_die_front_runbackward_rleg;
	tmp = %thu_stand_die_front_runbackward_rshoulder;
	tmp = %thu_stand_die_front_runleft_chest;
	tmp = %thu_stand_die_front_runleft_head;
	tmp = %thu_stand_die_front_runleft_lleg;
	tmp = %thu_stand_die_front_runleft_lshoulder;
	tmp = %thu_stand_die_front_runleft_pelvis;
	tmp = %thu_stand_die_front_runleft_rleg;
	tmp = %thu_stand_die_front_runleft_rshoulder;
	tmp = %thu_stand_die_front_runright_chest;
	tmp = %thu_stand_die_front_runright_head;
	tmp = %thu_stand_die_front_runright_lleg;
	tmp = %thu_stand_die_front_runright_lshoulder;
	tmp = %thu_stand_die_front_runright_pelvis;
	tmp = %thu_stand_die_front_runright_rleg;
	tmp = %thu_stand_die_front_runright_rshoulder;
	tmp = %thu_stand_dieheavy_back_idle_chest;
	tmp = %thu_stand_dieheavy_back_idle_head;
	tmp = %thu_stand_dieheavy_back_idle_lleg;
	tmp = %thu_stand_dieheavy_back_idle_lshoulder;
	tmp = %thu_stand_dieheavy_back_idle_pelvis;
	tmp = %thu_stand_dieheavy_back_idle_rleg;
	tmp = %thu_stand_dieheavy_back_idle_rshoulder;
	tmp = %thu_stand_dieheavy_front_idle_chest;
	tmp = %thu_stand_dieheavy_front_idle_head;
	tmp = %thu_stand_dieheavy_front_idle_lleg;
	tmp = %thu_stand_dieheavy_front_idle_lshoulder;
	tmp = %thu_stand_dieheavy_front_idle_pelvis;
	tmp = %thu_stand_dieheavy_front_idle_rleg;
	tmp = %thu_stand_dieheavy_front_idle_rshoulder;
	tmp = %thu_stand_pain_back_idle_chest;
	tmp = %thu_stand_pain_back_idle_flashbang;
	tmp = %thu_stand_pain_back_idle_head;
	tmp = %thu_stand_pain_back_idle_lleg;
	tmp = %thu_stand_pain_back_idle_lshoulder;
	tmp = %thu_stand_pain_back_idle_pelvis;
	tmp = %thu_stand_pain_back_idle_rleg;
	tmp = %thu_stand_pain_back_idle_rshoulder;
	tmp = %thu_stand_pain_back_run_chest;
	tmp = %thu_stand_pain_back_run_head;
	tmp = %thu_stand_pain_back_run_lleg;
	tmp = %thu_stand_pain_back_run_lshoulder;
	tmp = %thu_stand_pain_back_run_pelvis;
	tmp = %thu_stand_pain_back_run_rleg;
	tmp = %thu_stand_pain_back_run_rshoulder;
	tmp = %thu_stand_pain_back_runbackward_chest;
	tmp = %thu_stand_pain_back_runbackward_head;
	tmp = %thu_stand_pain_back_runbackward_lleg;
	tmp = %thu_stand_pain_back_runbackward_lshoulder;
	tmp = %thu_stand_pain_back_runbackward_pelvis;
	tmp = %thu_stand_pain_back_runbackward_rleg;
	tmp = %thu_stand_pain_back_runbackward_rshoulder;
	tmp = %thu_stand_pain_back_runleft_chest;
	tmp = %thu_stand_pain_back_runleft_head;
	tmp = %thu_stand_pain_back_runleft_lleg;
	tmp = %thu_stand_pain_back_runleft_lshoulder;
	tmp = %thu_stand_pain_back_runleft_pelvis;
	tmp = %thu_stand_pain_back_runleft_rleg;
	tmp = %thu_stand_pain_back_runleft_rshoulder;
	tmp = %thu_stand_pain_back_runright_chest;
	tmp = %thu_stand_pain_back_runright_head;
	tmp = %thu_stand_pain_back_runright_lleg;
	tmp = %thu_stand_pain_back_runright_lshoulder;
	tmp = %thu_stand_pain_back_runright_pelvis;
	tmp = %thu_stand_pain_back_runright_rleg;
	tmp = %thu_stand_pain_back_runright_rshoulder;
	tmp = %thu_stand_pain_front_idle_chest;
	tmp = %thu_stand_pain_front_idle_flashbang;
	tmp = %thu_stand_pain_front_idle_head;
	tmp = %thu_stand_pain_front_idle_lleg;
	tmp = %thu_stand_pain_front_idle_lshoulder;
	tmp = %thu_stand_pain_front_idle_pelvis;
	tmp = %thu_stand_pain_front_idle_rleg;
	tmp = %thu_stand_pain_front_idle_rshoulder;
	tmp = %thu_stand_pain_front_run_chest;
	tmp = %thu_stand_pain_front_run_head;
	tmp = %thu_stand_pain_front_run_lleg;
	tmp = %thu_stand_pain_front_run_lshoulder;
	tmp = %thu_stand_pain_front_run_pelvis;
	tmp = %thu_stand_pain_front_run_rleg;
	tmp = %thu_stand_pain_front_run_rshoulder;
	tmp = %thu_stand_pain_front_runbackward_chest;
	tmp = %thu_stand_pain_front_runbackward_head;
	tmp = %thu_stand_pain_front_runbackward_lleg;
	tmp = %thu_stand_pain_front_runbackward_lshoulder;
	tmp = %thu_stand_pain_front_runbackward_pelvis;
	tmp = %thu_stand_pain_front_runbackward_rleg;
	tmp = %thu_stand_pain_front_runbackward_rshoulder;
	tmp = %thu_stand_pain_front_runleft_chest;
	tmp = %thu_stand_pain_front_runleft_head;
	tmp = %thu_stand_pain_front_runleft_lleg;
	tmp = %thu_stand_pain_front_runleft_lshoulder;
	tmp = %thu_stand_pain_front_runleft_pelvis;
	tmp = %thu_stand_pain_front_runleft_rleg;
	tmp = %thu_stand_pain_front_runleft_rshoulder;
	tmp = %thu_stand_pain_front_runright_chest;
	tmp = %thu_stand_pain_front_runright_head;
	tmp = %thu_stand_pain_front_runright_lleg;
	tmp = %thu_stand_pain_front_runright_lshoulder;
	tmp = %thu_stand_pain_front_runright_pelvis;
	tmp = %thu_stand_pain_front_runright_rleg;
	tmp = %thu_stand_pain_front_runright_rshoulder;
	tmp = %thu_stand_painhvy_back_idle_chest;
	tmp = %thu_stand_painhvy_back_idle_head;
	tmp = %thu_stand_painhvy_back_idle_lleg;
	tmp = %thu_stand_painhvy_back_idle_lshoulder;
	tmp = %thu_stand_painhvy_back_idle_pelvis;
	tmp = %thu_stand_painhvy_back_idle_rleg;
	tmp = %thu_stand_painhvy_back_idle_rshoulder;
	tmp = %thu_stand_painhvy_front_idle_chest;
	tmp = %thu_stand_painhvy_front_idle_head;
	tmp = %thu_stand_painhvy_front_idle_lleg;
	tmp = %thu_stand_painhvy_front_idle_lshoulder;
	tmp = %thu_stand_painhvy_front_idle_pelvis;
	tmp = %thu_stand_painhvy_front_idle_rleg;
	tmp = %thu_stand_painhvy_front_idle_rshoulder;
	tmp = %thu_stand_painstagger_back_idle_chest;
	tmp = %thu_stand_painstagger_back_idle_head;
	tmp = %thu_stand_painstagger_back_idle_lleg;
	tmp = %thu_stand_painstagger_back_idle_lshoulder;
	tmp = %thu_stand_painstagger_back_idle_pelvis;
	tmp = %thu_stand_painstagger_back_idle_rleg;
	tmp = %thu_stand_painstagger_back_idle_rshoulder;
	tmp = %thu_stand_painstagger_back_run_chest;
	tmp = %thu_stand_painstagger_back_run_head;
	tmp = %thu_stand_painstagger_back_run_lleg;
	tmp = %thu_stand_painstagger_back_run_lshoulder;
	tmp = %thu_stand_painstagger_back_run_pelvis;
	tmp = %thu_stand_painstagger_back_run_rleg;
	tmp = %thu_stand_painstagger_back_run_rshoulder;
	tmp = %thu_stand_painstagger_back_runbackward_chest;
	tmp = %thu_stand_painstagger_back_runbackward_head;
	tmp = %thu_stand_painstagger_back_runbackward_lleg;
	tmp = %thu_stand_painstagger_back_runbackward_lshoulder;
	tmp = %thu_stand_painstagger_back_runbackward_pelvis;
	tmp = %thu_stand_painstagger_back_runbackward_rleg;
	tmp = %thu_stand_painstagger_back_runbackward_rshoulder;
	tmp = %thu_stand_painstagger_back_runleft_chest;
	tmp = %thu_stand_painstagger_back_runleft_head;
	tmp = %thu_stand_painstagger_back_runleft_lleg;
	tmp = %thu_stand_painstagger_back_runleft_lshoulder;
	tmp = %thu_stand_painstagger_back_runleft_pelvis;
	tmp = %thu_stand_painstagger_back_runleft_rleg;
	tmp = %thu_stand_painstagger_back_runleft_rshoulder;
	tmp = %thu_stand_painstagger_back_runright_chest;
	tmp = %thu_stand_painstagger_back_runright_head;
	tmp = %thu_stand_painstagger_back_runright_lleg;
	tmp = %thu_stand_painstagger_back_runright_lshoulder;
	tmp = %thu_stand_painstagger_back_runright_pelvis;
	tmp = %thu_stand_painstagger_back_runright_rleg;
	tmp = %thu_stand_painstagger_back_runright_rshoulder;
	tmp = %thu_stand_painstagger_front_idle_chest;
	tmp = %thu_stand_painstagger_front_idle_head;
	tmp = %thu_stand_painstagger_front_idle_lleg;
	tmp = %thu_stand_painstagger_front_idle_lshoulder;
	tmp = %thu_stand_painstagger_front_idle_pelvis;
	tmp = %thu_stand_painstagger_front_idle_rleg;
	tmp = %thu_stand_painstagger_front_idle_rshoulder;
	tmp = %thu_stand_painstagger_front_run_chest;
	tmp = %thu_stand_painstagger_front_run_head;
	tmp = %thu_stand_painstagger_front_run_lleg;
	tmp = %thu_stand_painstagger_front_run_lshoulder;
	tmp = %thu_stand_painstagger_front_run_pelvis;
	tmp = %thu_stand_painstagger_front_run_rleg;
	tmp = %thu_stand_painstagger_front_run_rshoulder;
	tmp = %thu_stand_painstagger_front_runbackward_chest;
	tmp = %thu_stand_painstagger_front_runbackward_head;
	tmp = %thu_stand_painstagger_front_runbackward_lleg;
	tmp = %thu_stand_painstagger_front_runbackward_lshoulder;
	tmp = %thu_stand_painstagger_front_runbackward_pelvis;
	tmp = %thu_stand_painstagger_front_runbackward_rleg;
	tmp = %thu_stand_painstagger_front_runbackward_rshoulder;
	tmp = %thu_stand_painstagger_front_runleft_chest;
	tmp = %thu_stand_painstagger_front_runleft_head;
	tmp = %thu_stand_painstagger_front_runleft_lleg;
	tmp = %thu_stand_painstagger_front_runleft_lshoulder;
	tmp = %thu_stand_painstagger_front_runleft_pelvis;
	tmp = %thu_stand_painstagger_front_runleft_rleg;
	tmp = %thu_stand_painstagger_front_runleft_rshoulder;
	tmp = %thu_stand_painstagger_front_runright_chest;
	tmp = %thu_stand_painstagger_front_runright_head;
	tmp = %thu_stand_painstagger_front_runright_lleg;
	tmp = %thu_stand_painstagger_front_runright_lshoulder;
	tmp = %thu_stand_painstagger_front_runright_pelvis;
	tmp = %thu_stand_painstagger_front_runright_rleg;
	tmp = %thu_stand_painstagger_front_runright_rshoulder;
    
	tmp = %thu_alrt_traversal_carslide_foregrip;
	tmp = %thu_alrt_traversal_carslide_pistol;
	tmp = %thu_alrt_traversal_carslidein_foregrip;
	tmp = %thu_alrt_traversal_carslidein_pistol;
	tmp = %thu_alrt_traversal_carslideout_foregrip;
	tmp = %thu_alrt_traversal_carslideout_pistol;
	tmp = %thu_alrt_traversal_divefd_foregrip;
	tmp = %thu_alrt_traversal_divefd_pistol;
	tmp = %thu_alrt_traversal_dooropen_foregrip;
	tmp = %thu_alrt_traversal_dooropen_pistol;
	tmp = %thu_alrt_traversal_jumpacrossin_foregrip;
	tmp = %thu_alrt_traversal_jumpacrossin_pistol;
	tmp = %thu_alrt_traversal_jumpacrossland_foregrip;
	tmp = %thu_alrt_traversal_jumpacrossland_pistol;
	tmp = %thu_alrt_traversal_jumpacrosslaunch_foregrip;
	tmp = %thu_alrt_traversal_jumpacrosslaunch_pistol;
	tmp = %thu_alrt_traversal_jumpacrossloop_foregrip;
	tmp = %thu_alrt_traversal_jumpacrossloop_pistol;
	tmp = %thu_alrt_traversal_jumpdn40_foregrip;
	tmp = %thu_alrt_traversal_jumpdn40_pistol;
	tmp = %thu_alrt_traversal_jumpdownland_foregrip;
	tmp = %thu_alrt_traversal_jumpdownland_pistol;
	tmp = %thu_alrt_traversal_jumpdownland_foregrip_v2;
	tmp = %thu_alrt_traversal_jumpdownland_pistol_v2;
	tmp = %thu_alrt_traversal_jumpdownland_foregrip_v3;
	tmp = %thu_alrt_traversal_jumpdownland_pistol_v3;
	tmp = %thu_alrt_traversal_jumpdownlaunch_foregrip;
	tmp = %thu_alrt_traversal_jumpdownlaunch_pistol;
	tmp = %thu_alrt_traversal_jumpdownlaunch_foregrip_v2;
	tmp = %thu_alrt_traversal_jumpdownlaunch_pistol_v2;
	tmp = %thu_alrt_traversal_jumpdownlaunch_foregrip_v3;
	tmp = %thu_alrt_traversal_jumpdownlaunch_pistol_v3;
	tmp = %thu_alrt_traversal_jumpdownloop_foregrip;
	tmp = %thu_alrt_traversal_jumpdownloop_pistol;
	tmp = %thu_alrt_traversal_jumpdownloop_foregrip_v2;
	tmp = %thu_alrt_traversal_jumpdownloop_pistol_v2;
	tmp = %thu_alrt_traversal_jumpdownloop_foregrip_v3;
	tmp = %thu_alrt_traversal_jumpdownloop_pistol_v3;
	tmp = %thu_alrt_traversal_jumpoverhighwall_foregrip;
	tmp = %thu_alrt_traversal_jumpoverhighwall_pistol;
	tmp = %thu_alrt_traversal_jumpoverhighwallin_foregrip;
	tmp = %thu_alrt_traversal_jumpoverhighwallin_pistol;
	tmp = %thu_alrt_traversal_ladderdn_foregrip;
	tmp = %thu_alrt_traversal_ladderdn_pistol;
	tmp = %thu_alrt_traversal_ladderin_foregrip;
	tmp = %thu_alrt_traversal_ladderin_pistol;
	tmp = %thu_alrt_traversal_ladderout_foregrip;
	tmp = %thu_alrt_traversal_ladderout_pistol;
	tmp = %thu_alrt_traversal_ladderslide_foregrip;
	tmp = %thu_alrt_traversal_ladderslide_pistol;
	tmp = %thu_alrt_traversal_ladderslideout_foregrip;
	tmp = %thu_alrt_traversal_ladderslideout_pistol;
	tmp = %thu_alrt_traversal_ladderup_foregrip;
	tmp = %thu_alrt_traversal_ladderup_pistol;
	tmp = %thu_alrt_traversal_ladderupin_foregrip;
	tmp = %thu_alrt_traversal_ladderupin_pistol;
	tmp = %thu_alrt_traversal_ladderupout_foregrip;
	tmp = %thu_alrt_traversal_ladderupout_pistol;
	tmp = %thu_alrt_traversal_mantleon_foregrip;
	tmp = %thu_alrt_traversal_mantleon_pistol;
	tmp = %thu_alrt_traversal_mantleover_foregrip;
	tmp = %thu_alrt_traversal_mantleover_pistol;
	tmp = %thu_alrt_traversal_mantleover_foregrip_v2;
	tmp = %thu_alrt_traversal_mantleover_pistol_v2;
	tmp = %thu_alrt_traversal_stepover_foregrip;
	tmp = %thu_alrt_traversal_stepover_pistol;
	tmp = %thu_alrt_traversal_walldive_foregrip;
	tmp = %thu_alrt_traversal_walldive_pistol;
	tmp = %thu_alrt_traversal_jumpacross72_foregrip;
	tmp = %thu_alrt_traversal_jumpacross72_pistol;
	tmp = %thu_alrt_traversal_jumpacross120_foregrip;
	tmp = %thu_alrt_traversal_jumpacross120_pistol;
    
	tmp = %female_alrt_crouch_idle_none;
	tmp = %female_alrt_crouch_run_none;
	tmp = %female_alrt_crouch_walk_none;
	tmp = %female_alrt_stand_idle_none;
	tmp = %female_alrt_stand_run_none;
	tmp = %female_alrt_stand_sprint_none;
	tmp = %female_alrt_stand_walk_none;
	tmp = %female_alrt_traversal_mantleover_none;
	tmp = %female_relax_stand_idle_none;
	tmp = %female_relax_stand_run_none;
	tmp = %female_relax_stand_walk_none;
	tmp = %female_stand_die_front_idle_head_v1;
	tmp = %female_stand_flinch_v1_none;
	tmp = %female_stand_idle_to_lookbehindleft_none;
	tmp = %female_stand_idle_to_lookbehindright_none;
	tmp = %female_stand_lookbehindleft_none;
	tmp = %female_stand_lookbehindleft_to_idle_none;
	tmp = %female_stand_lookbehindright_none;
	tmp = %female_stand_lookbehindright_to_idle_none;
	tmp = %female_stand_pain_front_idle_chest;
	tmp = %female_susp_stand_idle_none;
	tmp = %female_susp_stand_run_none;
	tmp = %female_susp_stand_walk_none;
	tmp = %female_relax_stand_idleshow_none;
	tmp = %male_relax_stand_idleshow_none;
    
	tmp = %gettlerfemale_stand_die_front_idle_head_v1;
	tmp = %gettlerfemale_stand_flinch_v1_none;
	tmp = %gettlerfemale_stand_pain_front_idle_chest;
	tmp = %gettlerfemale_susp_stand_idle_none;
	tmp = %gettlerfemale_susp_stand_run_none;
	tmp = %gettlerfemale_susp_stand_walk_none;
    
}
//End of Automatically Generated AI Block --- No mannual change!!! 
//AI_ANIM_BLOCK_END


PrecachePlayerCoverAnims()
{
	tmp = %Bnd_Cnr_Stnd_Dash_P99;
	tmp = %Bnd_CnrLt_Crch_AimDn_P99;
	tmp = %Bnd_CnrLt_Crch_AimDnFdIdl_P99;
	tmp = %Bnd_CnrLt_Crch_AimDnMid_P99;
	tmp = %Bnd_CnrLt_Crch_AimFdIdl_P99;
	tmp = %Bnd_CnrLt_Crch_AimMid_P99;
	tmp = %Bnd_CnrLt_Crch_AimUp_P99;
	tmp = %Bnd_CnrLt_Crch_AimUpFdIdl_P99;
	tmp = %Bnd_CnrLt_Crch_BlndAim_P99;
	tmp = %Bnd_CnrLt_Crch_BlndFire_P99;
	tmp = %Bnd_CnrLt_Crch_FireDn_P99;
	tmp = %Bnd_CnrLt_Crch_FireDnMid_P99;
	tmp = %Bnd_CnrLt_Crch_FireMid_P99;
	tmp = %Bnd_CnrLt_Crch_FireUp_P99;
	tmp = %Bnd_CnrLt_Crch_Idl_P99;
	tmp = %Bnd_CnrLt_Crch_IdlReload_P99;
	tmp = %Bnd_CnrLt_Crch_PeekIdl_P99;
	tmp = %Bnd_CnrLt_Crch_PeekReload_P99;
	tmp = %Bnd_CnrLt_Crch_ReloadMid_P99;
	tmp = %Bnd_CnrLt_LwCvr_AimDn_P99;
	tmp = %Bnd_CnrLt_LwCvr_AimMid_P99;
	tmp = %Bnd_CnrLt_LwCvr_AimUp_P99;
	tmp = %Bnd_CnrLt_LwCvr_BlndAim_P99;
	tmp = %Bnd_CnrLt_LwCvr_BlndFire_P99;
	tmp = %Bnd_CnrLt_LwCvr_FireDn_P99;
	tmp = %Bnd_CnrLt_LwCvr_FireMid_P99;
	tmp = %Bnd_CnrLt_LwCvr_FireUp_P99;
	tmp = %Bnd_CnrLt_LwCvr_ReloadMid_P99;
	tmp = %Bnd_CnrLt_LwCvr_StrafeFireDn_P99;
	tmp = %Bnd_CnrLt_LwCvr_StrafeFireMid_P99;
	tmp = %Bnd_CnrLt_LwCvr_StrafeFireUp_P99;
	tmp = %Bnd_CnrLt_Stnd_AimDn_P99;
	tmp = %Bnd_CnrLt_Stnd_AimDnFdIdl_P99;
	tmp = %Bnd_CnrLt_Stnd_AimFdIdl_P99;
	tmp = %Bnd_CnrLt_Stnd_AimMid_P99;
	tmp = %Bnd_CnrLt_Stnd_AimUp_P99;
	tmp = %Bnd_CnrLt_Stnd_AimUpFdIdl_P99;
	tmp = %Bnd_CnrLt_Stnd_BlndAim_P99;
	tmp = %Bnd_CnrLt_Stnd_BlndFire_P99;
	tmp = %Bnd_CnrLt_Stnd_FireDn_P99;
	tmp = %Bnd_CnrLt_Stnd_FireMid_P99;
	tmp = %Bnd_CnrLt_Stnd_FireUp_P99;
	tmp = %Bnd_CnrLt_Stnd_Idl_P99;
	tmp = %Bnd_CnrLt_Stnd_IdlReload_P99;
	tmp = %Bnd_CnrLt_Stnd_PeekIdl_P99;
	tmp = %Bnd_CnrLt_Stnd_PeekReload_P99;
	tmp = %Bnd_CnrLt_Stnd_ReloadMid_P99;
	tmp = %Bnd_CnrLtLoc_Crch_AimDnWlkBk_P99;
	tmp = %Bnd_CnrLtLoc_Crch_AimDnWlkFd_P99;
	tmp = %Bnd_CnrLtLoc_Crch_AimUpWlkBk_P99;
	tmp = %Bnd_CnrLtLoc_Crch_AimUpWlkFd_P99;
	tmp = %Bnd_CnrLtLoc_Crch_AimWlkBk_P99;
	tmp = %Bnd_CnrLtLoc_Crch_AimWlkFd_P99;
	tmp = %Bnd_CnrLtLoc_Crch_WlkBk_P99;
	tmp = %Bnd_CnrLtLoc_Crch_WlkFd_P99;
	tmp = %Bnd_CnrLtLoc_LwCvr_StrafeLt_P99;
	tmp = %Bnd_CnrLtLoc_LwCvr_StrafeLtDn_P99;
	tmp = %Bnd_CnrLtLoc_LwCvr_StrafeLtUp_P99;
	tmp = %Bnd_CnrLtLoc_LwCvr_StrafeRt_P99;
	tmp = %Bnd_CnrLtLoc_LwCvr_StrafeRtDn_P99;
	tmp = %Bnd_CnrLtLoc_LwCvr_StrafeRtUp_P99;
	tmp = %Bnd_CnrLtLoc_Stnd_AimDnWlkBk_P99;
	tmp = %Bnd_CnrLtLoc_Stnd_AimDnWlkFd_P99;
	tmp = %Bnd_CnrLtLoc_Stnd_AimUpWlkBk_P99;
	tmp = %Bnd_CnrLtLoc_Stnd_AimUpWlkFd_P99;
	tmp = %Bnd_CnrLtLoc_Stnd_AimWlkBk_P99;
	tmp = %Bnd_CnrLtLoc_Stnd_AimWlkFd_P99;
	tmp = %Bnd_CnrLtLoc_Stnd_WlkBk_P99;
	tmp = %Bnd_CnrLtLoc_Stnd_WlkFd_P99;
	tmp = %Bnd_CnrRt_Stnd_Shuffle_P99;
	tmp = %Bnd_CnrRt_Crch_Shuffle_P99;
	tmp = %Bnd_CnrLt_Stnd_Shuffle_P99;
	tmp = %Bnd_CnrLt_Crch_Shuffle_P99;
	tmp = %Bnd_CnrRt_Stnd_Jog_P99;
	tmp = %Bnd_CnrRt_Crch_Jog_P99;
	tmp = %Bnd_CnrLt_Stnd_Jog_P99;
	tmp = %Bnd_CnrLt_Crch_Jog_P99;
	tmp = %Bnd_CnrRt_Stnd_Run_P99;
	tmp = %Bnd_CnrRt_Crch_Run_P99;
	tmp = %Bnd_CnrLt_Stnd_Run_P99;
	tmp = %Bnd_CnrLt_Crch_Run_P99;
	tmp = %Bnd_CnrLtTns_Crch_Enter2CrchPeek_P99;
	tmp = %Bnd_CnrLtTns_Crch_Exit_P99;
	tmp = %Bnd_CnrLtTns_Crch_ExitFromPeek_P99;
	tmp = %Bnd_CnrLtTns_Crch_WlkFdLt2WlkFdRt_P99;
	tmp = %Bnd_CnrLtTns_Stnd_Enter2CrchPeek_P99;
	tmp = %Bnd_CnrLtTns_Stnd_Enter2Peek_P99;
	tmp = %Bnd_CnrMid_Crch_Idl_P99;
	tmp = %Bnd_CnrMid_Crch_Reload_P99;
	tmp = %Bnd_CnrMid_LwCvr_BlndAim_P99;
	tmp = %Bnd_CnrMid_LwCvr_BlndFire_P99;
	tmp = %Bnd_CnrMid_Stnd_Idl_P99;
	tmp = %Bnd_CnrMid_Stnd_Reload_P99;
	tmp = %Bnd_CnrMidTns_Crch_Enter2Crch_P99;
	tmp = %Bnd_CnrMidTns_Crch_Exit_P99;
	tmp = %Bnd_CnrMidTns_Stnd_Enter2Crch_P99;
	tmp = %Bnd_CnrMidTns_Stnd_Enter2Stnd_P99;
	tmp = %Bnd_CnrMidTns_Stnd_Exit_P99;
	tmp = %Bnd_CnrRt_Crch_AimDn_P99;
	tmp = %Bnd_CnrRt_Crch_AimDnFdIdl_P99;
	tmp = %Bnd_CnrRt_Crch_AimDnMid_P99;
	tmp = %Bnd_CnrRt_Crch_AimFdIdl_P99;
	tmp = %Bnd_CnrRt_Crch_AimMid_P99;
	tmp = %Bnd_CnrRt_Crch_AimUp_P99;
	tmp = %Bnd_CnrRt_Crch_AimUpFdIdl_P99;
	tmp = %Bnd_CnrRt_Crch_BlndAim_P99;
	tmp = %Bnd_CnrRt_Crch_BlndFire_P99;
	tmp = %Bnd_CnrRt_Crch_FireDn_P99;
	tmp = %Bnd_CnrRt_Crch_FireDnMid_P99;
	tmp = %Bnd_CnrRt_Crch_FireMid_P99;
	tmp = %Bnd_CnrRt_Crch_FireUp_P99;
	tmp = %Bnd_CnrRt_Crch_Idl_P99;
	tmp = %Bnd_CnrRt_Crch_IdlReload_P99;
	tmp = %Bnd_CnrRt_Crch_PeekIdl_P99;
	tmp = %Bnd_CnrRt_Crch_PeekReload_P99;
	tmp = %Bnd_CnrRt_Crch_ReloadMid_P99;
	tmp = %Bnd_CnrRt_LwCvr_AimDn_P99;
	tmp = %Bnd_CnrRt_LwCvr_AimMid_P99;
	tmp = %Bnd_CnrRt_LwCvr_AimUp_P99;
	tmp = %Bnd_CnrRt_LwCvr_BlndAim_P99;
	tmp = %Bnd_CnrRt_LwCvr_BlndFire_P99;
	tmp = %Bnd_CnrRt_LwCvr_FireDn_P99;
	tmp = %Bnd_CnrRt_LwCvr_FireMid_P99;
	tmp = %Bnd_CnrRt_LwCvr_FireUp_P99;
	tmp = %Bnd_CnrRt_LwCvr_ReloadMid_P99;
	tmp = %Bnd_CnrRt_LwCvr_StrafeFireDn_P99;
	tmp = %Bnd_CnrRt_LwCvr_StrafeFireMid_P99;
	tmp = %Bnd_CnrRt_LwCvr_StrafeFireUp_P99;
	tmp = %Bnd_CnrRt_Stnd_AimAround_P99;
	tmp = %Bnd_CnrRt_Stnd_AimAroundDn_P99;
	tmp = %Bnd_CnrRt_Stnd_AimAroundUp_P99;
	tmp = %Bnd_CnrRt_Stnd_AimDn_P99;
	tmp = %Bnd_CnrRt_Stnd_AimDnFdIdl_P99;
	tmp = %Bnd_CnrRt_Stnd_AimFdIdl_P99;
	tmp = %Bnd_CnrRt_Stnd_AimMid_P99;
	tmp = %Bnd_CnrRt_Stnd_AimUp_P99;
	tmp = %Bnd_CnrRt_Stnd_AimUpFdIdl_P99;
	tmp = %Bnd_CnrRt_Stnd_BlndAim_P99;
	tmp = %Bnd_CnrRt_Stnd_BlndFire_P99;
	tmp = %Bnd_CnrRt_Stnd_FireDn_P99;
	tmp = %Bnd_CnrRt_Stnd_FireMid_P99;
	tmp = %Bnd_CnrRt_Stnd_FireUp_P99;
	tmp = %Bnd_CnrRt_Stnd_Idl_P99;
	tmp = %Bnd_CnrRt_Stnd_IdlReload_P99;
	tmp = %Bnd_CnrRt_Stnd_PeekIdl_P99;
	tmp = %Bnd_CnrRt_Stnd_PeekReload_P99;
	tmp = %Bnd_CnrRt_Stnd_ReloadMid_P99;
	tmp = %Bnd_CnrRtLoc_Crch_AimDnWlkBk_P99;
	tmp = %Bnd_CnrRtLoc_Crch_AimDnWlkFd_P99;
	tmp = %Bnd_CnrRtLoc_Crch_AimUpWlkBk_P99;
	tmp = %Bnd_CnrRtLoc_Crch_AimUpWlkFd_P99;
	tmp = %Bnd_CnrRtLoc_Crch_AimWlkBk_P99;
	tmp = %Bnd_CnrRtLoc_Crch_AimWlkFd_P99;
	tmp = %Bnd_CnrRtLoc_Crch_WlkBk_P99;
	tmp = %Bnd_CnrRtLoc_Crch_WlkFd_P99;
	tmp = %Bnd_CnrRtLoc_LwCvr_StrafeLt_P99;
	tmp = %Bnd_CnrRtLoc_LwCvr_StrafeLtDn_P99;
	tmp = %Bnd_CnrRtLoc_LwCvr_StrafeLtUp_P99;
	tmp = %Bnd_CnrRtLoc_LwCvr_StrafeRt_P99;
	tmp = %Bnd_CnrRtLoc_LwCvr_StrafeRtDn_P99;
	tmp = %Bnd_CnrRtLoc_LwCvr_StrafeRtUp_P99;
	tmp = %Bnd_CnrRtLoc_Stnd_AimDnWlkBk_P99;
	tmp = %Bnd_CnrRtLoc_Stnd_AimDnWlkFd_P99;
	tmp = %Bnd_CnrRtLoc_Stnd_AimUpWlkBk_P99;
	tmp = %Bnd_CnrRtLoc_Stnd_AimUpWlkFd_P99;
	tmp = %Bnd_CnrRtLoc_Stnd_AimWlkBk_P99;
	tmp = %Bnd_CnrRtLoc_Stnd_AimWlkFd_P99;
	tmp = %Bnd_CnrRtLoc_Stnd_WlkBk_P99;
	tmp = %Bnd_CnrRtLoc_Stnd_WlkFd_P99;
	tmp = %Bnd_CnrRtTns_Crch_Enter2CrchPeek_P99;
	tmp = %Bnd_CnrRtTns_Crch_Exit_P99;
	tmp = %Bnd_CnrRtTns_Crch_ExitFromPeek_P99;
	tmp = %Bnd_CnrRtTns_Stnd_Enter2CrchPeek_P99;
	tmp = %Bnd_CnrRtTns_Stnd_Enter2Peek_P99;
	
	tmp = %Bnd_CnrTns_Stnd_AroundCnrRT_P99;
	tmp = %Bnd_CnrTns_Stnd_AroundCnrLT_P99;
	tmp = %Bnd_CnrTns_Crch_AroundCnrRT_P99;
	tmp = %Bnd_CnrTns_Crch_AroundCnrLT_P99;
	tmp = %Bnd_CnrRt_Stnd_Idl_A_P99;
	tmp = %Bnd_CnrRt_Stnd_Idl_B_P99;
	tmp = %Bnd_CnrRt_Stnd_Idl_C_P99;
	tmp = %Bnd_CnrRt_Stnd_PeekIdl_A_P99;
	tmp = %Bnd_CnrRt_Stnd_PeekIdl_B_P99;
	tmp = %Bnd_CnrRt_Stnd_PeekIdl_C_P99;
	tmp = %Bnd_CnrRt_Crch_Idl_B_P99;
	tmp = %Bnd_CnrRt_Crch_Idl_A_P99;
	tmp = %Bnd_CnrRt_Crch_Idl_C_P99;
	tmp = %Bnd_CnrRt_Crch_PeekIdl_A_P99;
	tmp = %Bnd_CnrRt_Crch_PeekIdl_B_P99;
	tmp = %Bnd_CnrRt_Crch_PeekIdl_C_P99;
	tmp = %Bnd_CnrLt_Stnd_Idl_A_P99;
	tmp = %Bnd_CnrLt_Stnd_Idl_B_P99;
	tmp = %Bnd_CnrLt_Stnd_Idl_C_P99;
	tmp = %Bnd_CnrLt_Stnd_PeekIdl_A_P99;
	tmp = %Bnd_CnrLt_Stnd_PeekIdl_B_P99;
	tmp = %Bnd_CnrLt_Stnd_PeekIdl_C_P99;
	tmp = %Bnd_CnrLt_Crch_Idl_B_P99;
	tmp = %Bnd_CnrLt_Crch_Idl_A_P99;
	tmp = %Bnd_CnrLt_Crch_Idl_C_P99;
	tmp = %Bnd_CnrLt_Crch_PeekIdl_A_P99;
	tmp = %Bnd_CnrLt_Crch_PeekIdl_B_P99;
	tmp = %Bnd_CnrLt_Crch_PeekIdl_C_P99;
	tmp = %Bnd_CnrMidTns_Stnd_Idl2RtIdl_P99;
	tmp = %Bnd_CnrMidTns_Crch_Idl2RtIdl_P99;
	tmp = %Bnd_CnrMidTns_Crch_Idl2WlkFdRt_P99;
	tmp = %Bnd_CnrRtTns_Crch_Idl2WlkFd_P99;
	tmp = %Bnd_CnrRtTns_Crch_WlkFd2Idl_P99;
	tmp = %Bnd_CnrRtTns_Crch_Peek2WlkFdLt_P99;
	tmp = %Bnd_CnrRtTns_Crch_WlkFdRt2WlkFdLt_P99;
	tmp = %Bnd_CnrRtTns_Stnd_Peek2Aim_P99;
	tmp = %Bnd_CnrRtTns_Stnd_Aim2Peek_P99;
	tmp = %Bnd_CnrRtTns_Crch_Aim2Peek_P99;
	tmp = %Bnd_CnrRtTns_Crch_Peek2Aim_P99;
	tmp = %Bnd_CnrLtTns_Crch_Aim2Peek_P99;
	tmp = %Bnd_CnrLtTns_Crch_Peek2Aim_P99;
	tmp = %Bnd_CnrLtTns_Stnd_Aim2Peek_P99;
	tmp = %Bnd_CnrLtTns_Stnd_Peek2Aim_P99;
	tmp = %Bnd_CnrLtTns_Crch_Idl2RtIdl_P99;
	tmp = %Bnd_CnrLtTns_Stnd_Idl2RtIdl_P99;
	tmp = %Bnd_CnrRtTns_Crch_Idl2LtIdl_P99;
	tmp = %Bnd_CnrRtTns_Stnd_Idl2LtIdl_P99;
	tmp = %Bnd_CnrRtTns_Stnd_BlndAim2Peek_P99;
	tmp = %Bnd_CnrRtTns_Stnd_Peek2BlndAim_P99;
	tmp = %Bnd_CnrRtTns_Crch_BlndAim2Peek_P99;
	tmp = %Bnd_CnrRtTns_Crch_Peek2BlndAim_P99;
	tmp = %Bnd_CnrLtTns_Stnd_BlndAim2Peek_P99;
	tmp = %Bnd_CnrLtTns_Stnd_Peek2BlndAim_P99;
	tmp = %Bnd_CnrLtTns_Crch_BlndAim2Peek_P99;
	tmp = %Bnd_CnrLtTns_Crch_Peek2BlndAim_P99;
	tmp = %Bnd_CnrRtTns_Stnd_WlkFd2Idl_P99;
	tmp = %Bnd_CnrRtTns_Stnd_Idl2WlkFd_P99;
	tmp = %Bnd_CnrMidTns_Stnd_Idl2WlkFdRt_P99;
	tmp = %Bnd_CnrRtTns_Stnd_WlkFdRt2WlkFdLt_P99;
	tmp = %Bnd_CnrRtTns_Stnd_Peek2WlkFdLt_P99;
	tmp = %Bnd_CnrMidTns_Stnd_Idl2LtIdl_P99;
	tmp = %Bnd_CnrMidTns_Crch_Idl2LtIdl_P99;
	tmp = %Bnd_CnrMidTns_Crch_Idl2WlkFdLt_P99;
	tmp = %Bnd_CnrLtTns_Crch_Idl2WlkFd_P99;
	tmp = %Bnd_CnrLtTns_Crch_WlkFd2Idl_P99;
	tmp = %Bnd_CnrLtTns_Crch_Peek2WlkFdLt_P99;
	tmp = %Bnd_CnrLtTns_Crch_WlkFdRt2WlkFdLt_P99;
	tmp = %Bnd_CnrLtTns_Stnd_WlkFd2Idl_P99;
	tmp = %Bnd_CnrLtTns_Stnd_Idl2WlkFd_P99;
	tmp = %Bnd_CnrMidTns_Stnd_Idl2WlkFdLt_P99;
	tmp = %Bnd_CnrLtTns_Stnd_WlkFdLt2WlkFdRt_P99;
	tmp = %Bnd_CnrLtTns_Stnd_Peek2WlkFdRt_P99;
	tmp = %Bnd_CnrRt_Stnd_DashFinish_P99;
	tmp = %Bnd_CnrRt_Crch_DashFinish_P99;
	tmp = %Bnd_CnrLt_Stnd_DashFinish_P99;
	tmp = %Bnd_CnrLt_Crch_DashFinish_P99;
	tmp = %Bnd_CnrRt_Stnd_DashFin2Aim_P99;
	tmp = %Bnd_CnrRt_Crch_DashFin2Aim_P99;
	tmp = %Bnd_CnrLt_Stnd_DashFin2Aim_P99;
	tmp = %Bnd_CnrLt_Crch_DashFin2Aim_P99;
	
	tmp = %Bnd_Cnr_Stnd_Dash_FG;
	tmp = %Bnd_CnrLt_Crch_AimDn_FG;
	tmp = %Bnd_CnrLt_Crch_AimDnFdIdl_FG;
	tmp = %Bnd_CnrLt_Crch_AimDnMid_FG;
	tmp = %Bnd_CnrLt_Crch_AimFdIdl_FG;
	tmp = %Bnd_CnrLt_Crch_AimMid_FG;
	tmp = %Bnd_CnrLt_Crch_AimUp_FG;
	tmp = %Bnd_CnrLt_Crch_AimUpFdIdl_FG;
	tmp = %Bnd_CnrLt_Crch_BlndAim_FG;
	tmp = %Bnd_CnrLt_Crch_BlndFire_FG;
	tmp = %Bnd_CnrLt_Crch_FireDn_FG;
	tmp = %Bnd_CnrLt_Crch_FireDnMid_FG;
	tmp = %Bnd_CnrLt_Crch_FireMid_FG;
	tmp = %Bnd_CnrLt_Crch_FireUp_FG;
	tmp = %Bnd_CnrLt_Crch_Idl_FG;
	tmp = %Bnd_CnrLt_Crch_IdlReload_FG;
	tmp = %Bnd_CnrLt_Crch_PeekIdl_FG;
	tmp = %Bnd_CnrLt_Crch_PeekReload_FG;
	tmp = %Bnd_CnrLt_Crch_ReloadMid_FG;
	tmp = %Bnd_CnrLt_LwCvr_AimDn_FG;
	tmp = %Bnd_CnrLt_LwCvr_AimMid_FG;
	tmp = %Bnd_CnrLt_LwCvr_AimUp_FG;
	tmp = %Bnd_CnrLt_LwCvr_BlndAim_FG;
	tmp = %Bnd_CnrLt_LwCvr_BlndFire_FG;
	tmp = %Bnd_CnrLt_LwCvr_FireDn_FG;
	tmp = %Bnd_CnrLt_LwCvr_FireMid_FG;
	tmp = %Bnd_CnrLt_LwCvr_FireUp_FG;
	tmp = %Bnd_CnrLt_LwCvr_ReloadMid_FG;
	tmp = %Bnd_CnrLt_LwCvr_StrafeFireDn_FG;
	tmp = %Bnd_CnrLt_LwCvr_StrafeFireMid_FG;
	tmp = %Bnd_CnrLt_LwCvr_StrafeFireUp_FG;
	tmp = %Bnd_CnrLt_Stnd_AimDn_FG;
	tmp = %Bnd_CnrLt_Stnd_AimDnFdIdl_FG;
	tmp = %Bnd_CnrLt_Stnd_AimFdIdl_FG;
	tmp = %Bnd_CnrLt_Stnd_AimMid_FG;
	tmp = %Bnd_CnrLt_Stnd_AimUp_FG;
	tmp = %Bnd_CnrLt_Stnd_AimUpFdIdl_FG;
	tmp = %Bnd_CnrLt_Stnd_BlndAim_FG;
	tmp = %Bnd_CnrLt_Stnd_BlndFire_FG;
	tmp = %Bnd_CnrLt_Stnd_FireDn_FG;
	tmp = %Bnd_CnrLt_Stnd_FireMid_FG;
	tmp = %Bnd_CnrLt_Stnd_FireUp_FG;
	tmp = %Bnd_CnrLt_Stnd_Idl_FG;
	tmp = %Bnd_CnrLt_Stnd_IdlReload_FG;
	tmp = %Bnd_CnrLt_Stnd_PeekIdl_FG;
	tmp = %Bnd_CnrLt_Stnd_PeekReload_FG;
	tmp = %Bnd_CnrLt_Stnd_ReloadMid_FG;
	tmp = %Bnd_CnrLtLoc_Crch_AimDnWlkBk_FG;
	tmp = %Bnd_CnrLtLoc_Crch_AimDnWlkFd_FG;
	tmp = %Bnd_CnrLtLoc_Crch_AimUpWlkBk_FG;
	tmp = %Bnd_CnrLtLoc_Crch_AimUpWlkFd_FG;
	tmp = %Bnd_CnrLtLoc_Crch_AimWlkBk_FG;
	tmp = %Bnd_CnrLtLoc_Crch_AimWlkFd_FG;
	tmp = %Bnd_CnrLtLoc_Crch_WlkBk_FG;
	tmp = %Bnd_CnrLtLoc_Crch_WlkFd_FG;
	tmp = %Bnd_CnrLtLoc_LwCvr_StrafeLt_FG;
	tmp = %Bnd_CnrLtLoc_LwCvr_StrafeLtDn_FG;
	tmp = %Bnd_CnrLtLoc_LwCvr_StrafeLtUp_FG;
	tmp = %Bnd_CnrLtLoc_LwCvr_StrafeRt_FG;
	tmp = %Bnd_CnrLtLoc_LwCvr_StrafeRtDn_FG;
	tmp = %Bnd_CnrLtLoc_LwCvr_StrafeRtUp_FG;
	tmp = %Bnd_CnrLtLoc_Stnd_AimDnWlkBk_FG;
	tmp = %Bnd_CnrLtLoc_Stnd_AimDnWlkFd_FG;
	tmp = %Bnd_CnrLtLoc_Stnd_AimUpWlkBk_FG;
	tmp = %Bnd_CnrLtLoc_Stnd_AimUpWlkFd_FG;
	tmp = %Bnd_CnrLtLoc_Stnd_AimWlkBk_FG;
	tmp = %Bnd_CnrLtLoc_Stnd_AimWlkFd_FG;
	tmp = %Bnd_CnrLtLoc_Stnd_WlkBk_FG;
	tmp = %Bnd_CnrLtLoc_Stnd_WlkFd_FG;
	tmp = %Bnd_CnrLtTns_Crch_Enter2CrchPeek_FG;
	tmp = %Bnd_CnrLtTns_Crch_Exit_FG;
	tmp = %Bnd_CnrLtTns_Crch_ExitFromPeek_FG;
	tmp = %Bnd_CnrLtTns_Crch_WlkFdLt2WlkFdRt_FG;
	tmp = %Bnd_CnrLtTns_Stnd_Enter2CrchPeek_FG;
	tmp = %Bnd_CnrLtTns_Stnd_Enter2Peek_FG;
	tmp = %Bnd_CnrMid_Crch_Idl_FG;
	tmp = %Bnd_CnrMid_Crch_Reload_FG;
	tmp = %Bnd_CnrMid_LwCvr_BlndAim_FG;
	tmp = %Bnd_CnrMid_LwCvr_BlndFire_FG;
	tmp = %Bnd_CnrMid_Stnd_Idl_FG;
	tmp = %Bnd_CnrMid_Stnd_Reload_FG;
	tmp = %Bnd_CnrMidTns_Crch_Enter2Crch_FG;
	tmp = %Bnd_CnrMidTns_Crch_Exit_FG;
	tmp = %Bnd_CnrMidTns_Stnd_Enter2Crch_FG;
	tmp = %Bnd_CnrMidTns_Stnd_Enter2Stnd_FG;
	tmp = %Bnd_CnrMidTns_Stnd_Exit_FG;
	tmp = %Bnd_CnrRt_Crch_AimDn_FG;
	tmp = %Bnd_CnrRt_Crch_AimDnFdIdl_FG;
	tmp = %Bnd_CnrRt_Crch_AimDnMid_FG;
	tmp = %Bnd_CnrRt_Crch_AimFdIdl_FG;
	tmp = %Bnd_CnrRt_Crch_AimMid_FG;
	tmp = %Bnd_CnrRt_Crch_AimUp_FG;
	tmp = %Bnd_CnrRt_Crch_AimUpFdIdl_FG;
	tmp = %Bnd_CnrRt_Crch_BlndAim_FG;
	tmp = %Bnd_CnrRt_Crch_BlndFire_FG;
	tmp = %Bnd_CnrRt_Crch_FireDn_FG;
	tmp = %Bnd_CnrRt_Crch_FireDnMid_FG;
	tmp = %Bnd_CnrRt_Crch_FireMid_FG;
	tmp = %Bnd_CnrRt_Crch_FireUp_FG;
	tmp = %Bnd_CnrRt_Crch_Idl_FG;
	tmp = %Bnd_CnrRt_Crch_IdlReload_FG;
	tmp = %Bnd_CnrRt_Crch_PeekIdl_FG;
	tmp = %Bnd_CnrRt_Crch_PeekReload_FG;
	tmp = %Bnd_CnrRt_Crch_ReloadMid_FG;
	tmp = %Bnd_CnrRt_LwCvr_AimDn_FG;
	tmp = %Bnd_CnrRt_LwCvr_AimMid_FG;
	tmp = %Bnd_CnrRt_LwCvr_AimUp_FG;
	tmp = %Bnd_CnrRt_LwCvr_BlndAim_FG;
	tmp = %Bnd_CnrRt_LwCvr_BlndFire_FG;
	tmp = %Bnd_CnrRt_LwCvr_FireDn_FG;
	tmp = %Bnd_CnrRt_LwCvr_FireMid_FG;
	tmp = %Bnd_CnrRt_LwCvr_FireUp_FG;
	tmp = %Bnd_CnrRt_LwCvr_ReloadMid_FG;
	tmp = %Bnd_CnrRt_LwCvr_StrafeFireDn_FG;
	tmp = %Bnd_CnrRt_LwCvr_StrafeFireMid_FG;
	tmp = %Bnd_CnrRt_LwCvr_StrafeFireUp_FG;
	tmp = %Bnd_CnrRt_Stnd_AimAround_FG;
	tmp = %Bnd_CnrRt_Stnd_AimAroundDn_FG;
	tmp = %Bnd_CnrRt_Stnd_AimAroundUp_FG;
	tmp = %Bnd_CnrRt_Stnd_AimDn_FG;
	tmp = %Bnd_CnrRt_Stnd_AimDnFdIdl_FG;
	tmp = %Bnd_CnrRt_Stnd_AimFdIdl_FG;
	tmp = %Bnd_CnrRt_Stnd_AimMid_FG;
	tmp = %Bnd_CnrRt_Stnd_AimUp_FG;
	tmp = %Bnd_CnrRt_Stnd_AimUpFdIdl_FG;
	tmp = %Bnd_CnrRt_Stnd_BlndAim_FG;
	tmp = %Bnd_CnrRt_Stnd_BlndFire_FG;
	tmp = %Bnd_CnrRt_Stnd_FireDn_FG;
	tmp = %Bnd_CnrRt_Stnd_FireMid_FG;
	tmp = %Bnd_CnrRt_Stnd_FireUp_FG;
	tmp = %Bnd_CnrRt_Stnd_Idl_FG;
	tmp = %Bnd_CnrRt_Stnd_IdlReload_FG;
	tmp = %Bnd_CnrRt_Stnd_PeekIdl_FG;
	tmp = %Bnd_CnrRt_Stnd_PeekReload_FG;
	tmp = %Bnd_CnrRt_Stnd_ReloadMid_FG;
	tmp = %Bnd_CnrRtLoc_Crch_AimDnWlkBk_FG;
	tmp = %Bnd_CnrRtLoc_Crch_AimDnWlkFd_FG;
	tmp = %Bnd_CnrRtLoc_Crch_AimUpWlkBk_FG;
	tmp = %Bnd_CnrRtLoc_Crch_AimUpWlkFd_FG;
	tmp = %Bnd_CnrRtLoc_Crch_AimWlkBk_FG;
	tmp = %Bnd_CnrRtLoc_Crch_AimWlkFd_FG;
	tmp = %Bnd_CnrRtLoc_Crch_WlkBk_FG;
	tmp = %Bnd_CnrRtLoc_Crch_WlkFd_FG;
	tmp = %Bnd_CnrRtLoc_LwCvr_StrafeLt_FG;
	tmp = %Bnd_CnrRtLoc_LwCvr_StrafeLtDn_FG;
	tmp = %Bnd_CnrRtLoc_LwCvr_StrafeLtUp_FG;
	tmp = %Bnd_CnrRtLoc_LwCvr_StrafeRt_FG;
	tmp = %Bnd_CnrRtLoc_LwCvr_StrafeRtDn_FG;
	tmp = %Bnd_CnrRtLoc_LwCvr_StrafeRtUp_FG;
	tmp = %Bnd_CnrRtLoc_Stnd_AimDnWlkBk_FG;
	tmp = %Bnd_CnrRtLoc_Stnd_AimDnWlkFd_FG;
	tmp = %Bnd_CnrRtLoc_Stnd_AimUpWlkBk_FG;
	tmp = %Bnd_CnrRtLoc_Stnd_AimUpWlkFd_FG;
	tmp = %Bnd_CnrRtLoc_Stnd_AimWlkBk_FG;
	tmp = %Bnd_CnrRtLoc_Stnd_AimWlkFd_FG;
	tmp = %Bnd_CnrRtLoc_Stnd_WlkBk_FG;
	tmp = %Bnd_CnrRtLoc_Stnd_WlkFd_FG;
	tmp = %Bnd_CnrRtTns_Crch_Enter2CrchPeek_FG;
	tmp = %Bnd_CnrRtTns_Crch_Exit_FG;
	tmp = %Bnd_CnrRtTns_Crch_ExitFromPeek_FG;
	tmp = %Bnd_CnrRtTns_Crch_WlkFdRt2WlkFdLt_FG;
	tmp = %Bnd_CnrRtTns_Stnd_Enter2CrchPeek_FG;
	tmp = %Bnd_CnrRtTns_Stnd_Enter2Peek_FG;
	tmp = %Bnd_CnrRt_Stnd_DashFinish_FG;
	tmp = %Bnd_CnrRt_Crch_DashFinish_FG;
	tmp = %Bnd_CnrLt_Stnd_DashFinish_FG;
	tmp = %Bnd_CnrLt_Crch_DashFinish_FG;
	
	tmp = %Bnd_Cnr_Stnd_Dash_UN;
	tmp = %Bnd_CnrLt_Crch_Idl_UN;
	tmp = %Bnd_CnrLt_Crch_PeekIdl_UN;
	tmp = %Bnd_CnrLt_Stnd_Idl_UN;
	tmp = %Bnd_CnrLt_Stnd_PeekIdl_UN;
	tmp = %Bnd_CnrLtLoc_Crch_WlkBk_UN;
	tmp = %Bnd_CnrLtLoc_Crch_WlkFd_UN;
	tmp = %Bnd_CnrLtLoc_Stnd_WlkBk_UN;
	tmp = %Bnd_CnrLtLoc_Stnd_WlkFd_UN;
	tmp = %Bnd_CnrLtTns_Crch_WlkFdLt2WlkFdRt_UN;
	tmp = %Bnd_CnrMid_Crch_Idl_UN;
	tmp = %Bnd_CnrMid_Stnd_Idl_UN;
	tmp = %Bnd_CnrRt_Crch_Idl_UN;
	tmp = %Bnd_CnrRt_Crch_PeekIdl_UN;
	tmp = %Bnd_CnrRt_Stnd_Idl_UN;
	tmp = %Bnd_CnrRt_Stnd_PeekIdl_UN;
	tmp = %Bnd_CnrRtLoc_Crch_WlkBk_UN;
	tmp = %Bnd_CnrRtLoc_Crch_WlkFd_UN;
	tmp = %Bnd_CnrRtLoc_Stnd_WlkBk_UN;
	tmp = %Bnd_CnrRtLoc_Stnd_WlkFd_UN;
	tmp = %Bnd_CnrRtTns_Crch_WlkFdRt2WlkFdLt_UN;
	tmp = %Bnd_CnrRt_Stnd_DashFinish_UN;
	tmp = %Bnd_CnrRt_Crch_DashFinish_UN;
	tmp = %Bnd_CnrLt_Stnd_DashFinish_UN;
	tmp = %Bnd_CnrLt_Crch_DashFinish_UN;
	
	tmp = %Bnd_Cnr_MPGrndThrw_Crch;
	tmp = %Bnd_Cnr_MPGrndThrw_Crch_Lt;
	tmp = %Bnd_Cnr_MPGrndThrw_Crch_Rt;
	tmp = %Bnd_Cnr_MPGrndThrw_Stnd;
	tmp = %Bnd_Cnr_MPGrndThrw_Stnd_Lt;
	tmp = %Bnd_Cnr_MPGrndThrw_Stnd_Rt;
}








