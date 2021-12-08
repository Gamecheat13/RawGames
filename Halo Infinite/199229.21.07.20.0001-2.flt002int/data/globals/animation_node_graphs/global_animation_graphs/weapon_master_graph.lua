-- Copyright (c) Microsoft. All rights reserved.

-- This is the weapon animation control function
function weapon_master_animation_graph()
	-- Control parameters
	local resetParam = AnimGraph.CreateBoolControlParameter("reset");
	local crouchParam = AnimGraph.CreateBoolControlParameter("crouch");

	-- Animations
	local idleAnim =		AnimGraph.CreateAnimation("idle", false, 1.0, 1.0);
	local fireAnim =		AnimGraph.CreateAnimation("fire_1", false, 1.0, 1.0);
	local fire2Anim =		AnimGraph.CreateAnimation("fire_2", false, 1.0, 1.0);
	local reloadAnim =		AnimGraph.CreateAnimation("reload_1", false, 1.0, 1.0);
		--local chargedAnim =		AnimGraph.CreateAnimation("charged_1", false, 1.0, 1.0);
	local overheatingAnim =	AnimGraph.CreateAnimation("overheating", false, 1.0, 1.0);
	local overheatedAnim =	AnimGraph.CreateAnimation("overheated", false, 1.0, 1.0);
	local oHExitAnim =		AnimGraph.CreateAnimation("o_h_exit", false, 1.0, 1.0);
	local chamberAnim =		AnimGraph.CreateAnimation("chamber_1", false, 1.0, 1.0);
	--local putAwayAnim =		AnimGraph.CreateAnimation("put_away", false, 1.0, 1.0);

	-- Transition logic functions
	local isIdle =			AnimGraph.CreateBoolControlParameter("idle");
	local isFire =			AnimGraph.CreateBoolControlParameter("fire_1");
	local isFire2 =			AnimGraph.CreateBoolControlParameter("fire_2");
	local isReload =		AnimGraph.CreateBoolControlParameter("reload_1");
		--local isCharged =		AnimGraph.CreateBoolControlParameter("charged_1");
	local isOverheating =	AnimGraph.CreateBoolControlParameter("overheating");
	local isOverheated =	AnimGraph.CreateBoolControlParameter("overheated");
	local isOHExit =		AnimGraph.CreateBoolControlParameter("o_h_exit");
	local isChamber =		AnimGraph.CreateBoolControlParameter("chamber_1");
	local isPutAway =		AnimGraph.CreateBoolControlParameter("put_away");
	local isReady =			AnimGraph.CreateBoolControlParameter("ready");

	local isAnimDone =		AnimGraph.CreateEndOfAnimation(0.0000);

	-- State machine, allows for resetting the same animation
	local weaponStateMachine = AnimGraph.CreateStateMachine();

	local idleState =			AnimGraph.AddNewState(weaponStateMachine, idleAnim.Out, "IDLE");
	local fireState =			AnimGraph.AddNewState(weaponStateMachine, fireAnim.Out, "FIRE_1");
	local fire2State =			AnimGraph.AddNewState(weaponStateMachine, fire2Anim.Out, "FIRE_2");
		--local chargedState =		AnimGraph.AddNewState(weaponStateMachine, chargedAnim.Out, "CHARGED_1");
	local reloadState =			AnimGraph.AddNewState(weaponStateMachine, reloadAnim.Out, "RELOAD_1");
	local overheatingState =	AnimGraph.AddNewState(weaponStateMachine, overheatingAnim.Out, "OVERHEATING");
	local overheatedState =		AnimGraph.AddNewState(weaponStateMachine, overheatedAnim.Out, "OVERHEATED");
	local oHExitState =			AnimGraph.AddNewState(weaponStateMachine, oHExitAnim.Out, "O_H_EXIT");
	local chamberState =		AnimGraph.AddNewState(weaponStateMachine, chamberAnim.Out, "CHAMBER");
	local putAwayState =		AnimGraph.AddNewState(weaponStateMachine, idleAnim.Out, "PUT_AWAY");

	AnimGraph.SetFallbackDefaultState(weaponStateMachine, idleState);

	-- State transitions
	local transitionBlend = CreateDefaultTransitionBlendGraph();
	local instant =	AnimGraph.AddNewTransitionBlend(weaponStateMachine, transitionBlend.Out, 0.0);

	-- From idleState
	AnimGraph.AddNewTransitionRule(weaponStateMachine, idleState, fireState, instant, isFire.Out);
	AnimGraph.AddNewTransitionRule(weaponStateMachine, idleState, fire2State, instant, isFire2.Out);
	AnimGraph.AddNewTransitionRule(weaponStateMachine, idleState, reloadState, instant, isReload.Out);
	AnimGraph.AddNewTransitionRule(weaponStateMachine, idleState, chamberState, instant, isChamber.Out);
	AnimGraph.AddNewTransitionRule(weaponStateMachine, idleState, overheatedState, instant, isOverheated.Out);
	AnimGraph.AddNewTransitionRule(weaponStateMachine, idleState, putAwayState, instant, isPutAway.Out);
	-- From fireState
	AnimGraph.AddNewTransitionRule(weaponStateMachine, fireState, fireState, instant, isFire.Out);
	AnimGraph.AddNewTransitionRule(weaponStateMachine, fireState, fire2State, instant, isFire2.Out);
	AnimGraph.AddNewTransitionRule(weaponStateMachine, fireState, reloadState, instant, isReload.Out);
	AnimGraph.AddNewTransitionRule(weaponStateMachine, fireState, overheatingState, instant, isOverheating.Out);
	AnimGraph.AddNewTransitionRule(weaponStateMachine, fireState, putAwayState, instant, isPutAway.Out);
	AnimGraph.AddNewTransitionRule(weaponStateMachine, fireState, idleState, instant, isAnimDone.Out);
	-- Frome fire2State
	AnimGraph.AddNewTransitionRule(weaponStateMachine, fire2State, fire2State, instant, isFire2.Out);
	AnimGraph.AddNewTransitionRule(weaponStateMachine, fire2State, fireState, instant, isFire.Out);
	AnimGraph.AddNewTransitionRule(weaponStateMachine, fire2State, reloadState, instant, isReload.Out);
	AnimGraph.AddNewTransitionRule(weaponStateMachine, fire2State, overheatingState, instant, isOverheating.Out);
	AnimGraph.AddNewTransitionRule(weaponStateMachine, fire2State, oHExitState, instant, isOHExit.Out);
	AnimGraph.AddNewTransitionRule(weaponStateMachine, fire2State, putAwayState, instant, isPutAway.Out);
	AnimGraph.AddNewTransitionRule(weaponStateMachine, fire2State, idleState, instant, isAnimDone.Out);
	-- From reloadState
	AnimGraph.AddNewTransitionRule(weaponStateMachine, reloadState, reloadState, instant, isReload.Out);
	AnimGraph.AddNewTransitionRule(weaponStateMachine, reloadState, fireState, instant, isFire.Out);
	AnimGraph.AddNewTransitionRule(weaponStateMachine, reloadState, fire2State, instant, isFire2.Out);
	AnimGraph.AddNewTransitionRule(weaponStateMachine, reloadState, putAwayState, instant, isPutAway.Out);
	AnimGraph.AddNewTransitionRule(weaponStateMachine, reloadState, idleState, instant, isAnimDone.Out);
	-- From overheatingState
	AnimGraph.AddNewTransitionRule(weaponStateMachine, overheatingState, overheatedState, instant, isOverheated.Out);
	AnimGraph.AddNewTransitionRule(weaponStateMachine, overheatingState, oHExitState, instant, isOHExit.Out);
	-- From overheatedState
	AnimGraph.AddNewTransitionRule(weaponStateMachine, overheatedState, oHExitState, instant, isOHExit.Out);
	-- From oHExitState
	AnimGraph.AddNewTransitionRule(weaponStateMachine, oHExitState, fireState, instant, isFire.Out);
	AnimGraph.AddNewTransitionRule(weaponStateMachine, oHExitState, putAwayState, instant, isPutAway.Out);
	AnimGraph.AddNewTransitionRule(weaponStateMachine, oHExitState, idleState, instant, isAnimDone.Out);
	-- From chamberState
	AnimGraph.AddNewTransitionRule(weaponStateMachine, chamberState, idleState, instant, isAnimDone.Out);
	AnimGraph.AddNewTransitionRule(weaponStateMachine, chamberState, fireState, instant, isFire.Out);
	AnimGraph.AddNewTransitionRule(weaponStateMachine, chamberState, putAwayState, instant, isPutAway.Out);
	-- From putAwayState
	AnimGraph.AddNewTransitionRule(weaponStateMachine, putAwayState, idleState, instant, isAnimDone.Out);

	-- Hook up final pose
	local final = AnimGraph.GetFinalPose();
	NG.CreateLink(weaponStateMachine.Out, final.In);

	-- Default set puahing
	local baseAnimSet = AnimGraph.CreateConstantString("any");
	AnimGraph.AddPushAnimSetEntry(baseAnimSet);

	-- Crouch set conditional pushing
	local crouchAnimSet = AnimGraph.CreateConstantString("crouch");
	AnimGraph.AddConditionalPushAnimSetEntry(crouchParam, crouchAnimSet);
end