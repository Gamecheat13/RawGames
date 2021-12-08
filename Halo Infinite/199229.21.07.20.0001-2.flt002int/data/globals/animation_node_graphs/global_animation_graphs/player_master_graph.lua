-- Copyright (c) Microsoft. All rights reserved.

function player_idle_state_machine()
	local anims = {}
	local logic = {}
	-- local idle = AnimGraph.CreateAnimation("idle", true, 1.000000, 1.000000);
	anims["idle"] = idle();
	anims["stationary_turn_right"] = stationary_turn_right()
	anims["stationary_turn_left"] = stationary_turn_left()	

	logic['is_in_stationary_turn_left'] = is_in_stationary_turn_left()

	logic['is_in_stationary_turn_right'] = is_in_stationary_turn_right()

	logic['isNOT_in_stationary_turn'] = isNOT_in_stationary_turn()


	local idleStateMachine = AnimGraph.CreateStateMachine();

	local idleState = AnimGraph.AddNewState(idleStateMachine, anims["idle"].Out,'IDLE');
	local turnLeftState = AnimGraph.AddNewState(idleStateMachine, anims["stationary_turn_left"].Out,'TURN LEFT');
	local turnRightState = AnimGraph.AddNewState(idleStateMachine, anims["stationary_turn_right"].Out,'TURN RIGHT');

	local transitionBlend = CreateDefaultTransitionBlendGraph();
	local fastTransition = AnimGraph.AddNewTransitionBlend(idleStateMachine, transitionBlend.Out, .125);
	local slowTransition = AnimGraph.AddNewTransitionBlend(idleStateMachine, transitionBlend.Out, .25);

	AnimGraph.AddNewTransitionRule(idleStateMachine, idleState, turnLeftState, fastTransition, logic['is_in_stationary_turn_left'].Out);
	AnimGraph.AddNewTransitionRule(idleStateMachine, idleState, turnRightState, fastTransition, logic['is_in_stationary_turn_right'].Out);

	AnimGraph.AddNewTransitionRule(idleStateMachine, turnLeftState, idleState, slowTransition, logic['isNOT_in_stationary_turn'].Out);
	AnimGraph.AddNewTransitionRule(idleStateMachine, turnLeftState, turnRightState, fastTransition, logic['is_in_stationary_turn_right'].Out);

	AnimGraph.AddNewTransitionRule(idleStateMachine, turnRightState, idleState, slowTransition, logic['isNOT_in_stationary_turn'].Out);
	AnimGraph.AddNewTransitionRule(idleStateMachine, turnRightState, turnLeftState, fastTransition, logic['is_in_stationary_turn_left'].Out);

	return idleStateMachine;
end


function player_airborne()
	local anim = AnimGraph.CreateAnimation('airborne', false, 2.0, 1.0);
	local airborne_control_param = control_airborne_progress_0to1();
	NG.CreateLink(airborne_control_param.Out, anim.Position);

	return anim;
end


function player_throw_grenade()
	local anim = AnimGraph.CreateAnimation("throw_grenade", false, 1.0, 1.0);
	local BoneMask = AnimGraph.CreateBoneMask('upper_body_only');
	NG.CreateLink(anim.Out, BoneMask.Pose);

	return BoneMask;
end


function player_melee()
	local anim = AnimGraph.CreateAnimation("melee", false, 1.0, 1.0);
	local BoneMask = AnimGraph.CreateBoneMask('upper_body_only');
	NG.CreateLink(anim.Out, BoneMask.Pose);

	return BoneMask;
end


function player_clamber_enter()
	local anim = clamber_enter();
	local yaw = AnimGraph.CreateFloatControlParameter("jump_offset_yaw");

	NG.CreateLink(yaw.Out, anim.Alpha);
	return anim;
end


function player_clamber_exit()
	local anim = clamber_exit();
	local yaw = AnimGraph.CreateFloatControlParameter("jump_offset_yaw");

	NG.CreateLink(yaw.Out, anim.Alpha);
	return anim;
end


function exit_clamber_to_idle()
	local lessThan = AnimGraph.CreateNumericalLogic(NG.NumCond.LessThan);
	local boolAnd = AnimGraph.CreateBooleanLogic(NG.BoolOp.AND);
	local throttle = AnimGraph.CreateObjectFunction("animation_throttle_magnitude");
	local threshold = AnimGraph.CreateConstantFloat(0.05);
	local onGround = AnimGraph.CreateBoolControlParameter("ground");

	-- is throttle less than threshold, and is player on ground
	NG.CreateLink(throttle.Out, lessThan.Left);
	NG.CreateLink(threshold.Out, lessThan.Right);
	NG.CreateLink(lessThan.Out, boolAnd.MultiIn);
	NG.CreateLink(onGround.Out, boolAnd.MultiIn);
	return boolAnd;
end


function exit_clamber_to_locomote()
	local greaterThan = AnimGraph.CreateNumericalLogic(NG.NumCond.GreaterThan);
	local boolAnd = AnimGraph.CreateBooleanLogic(NG.BoolOp.AND);
	local throttle = AnimGraph.CreateObjectFunction("animation_throttle_magnitude");
	local threshold = AnimGraph.CreateConstantFloat(0.05);
	local onGround = AnimGraph.CreateBoolControlParameter("ground");

	-- is throttle greater than threshold, and is player on ground
	NG.CreateLink(throttle.Out, greaterThan.Left);
	NG.CreateLink(threshold.Out, greaterThan.Right);
	NG.CreateLink(greaterThan.Out, boolAnd.MultiIn);
	NG.CreateLink(onGround.Out, boolAnd.MultiIn);
	return boolAnd;
end


function player_throw_equipment()
	local throwToken = AnimGraph.CreateStringControlParameter("throw_equipment");
	local throwAnim = AnimGraph.CreateAnimation("custom_animation", false, 1.0, 1.0);
	--AnimGraph.ToggleRootMotionOn(throwAnim)
	NG.CreateLink(throwToken.Out, throwAnim.AnimationTokenName)

	return throwAnim;
end


--this is the state machine that is referencing sub graphs
function player_master_animation_graph()
	--create animation, logic and control parameter tables
	local anims = {};
	local logic = {};
	local control_parameter = {};

	-- Movement state animation sources
	anims["idle"] =					player_idle_state_machine();
	anims["locomotion"] =			player_locomotion();
	anims['airborne'] =				player_airborne();
	anims['land_soft'] =			land_soft();
	anims['sprint'] =				AnimGraph.CreateAnimation("sprint", true, 2, 1.0);
	anims['clamber_enter'] =		player_clamber_enter();
	anims['clamber_exit'] =			player_clamber_exit();
	anims['clamber_exit_idle'] =	AnimGraph.CreateAnimation("clamber_exit_2_idle", false, 1.000000, 1.000000);
	anims['clamber_exit_loco'] =	AnimGraph.CreateAnimation("clamber_exit_2_locomote", false, 1.000000, 1.000000);

	-- Full body state animation sources
	anims['button_press'] =			AnimGraph.CreateAnimation("button_press", false, 1.000000, 1.000000); --button_press();
	anims['weaponrack_pickup'] =	AnimGraph.CreateAnimation("weaponrack_pickup", false, 1.000000, 1.000000); --weaponrack_pickup();
	anims['custom_animation'] =		anim_graph_custom_animation(); -- this also creates a stringControlParameter named 'custom_animation_token'.

	-- Upper body state animation sources
	anims['throw_grenade'] =		AnimGraph.CreateAnimation("throw_grenade", false, 1.0, 1.0);
	anims['melee'] =				AnimGraph.CreateAnimation("melee", false, 1.0, 1.0);
	anims['reload'] =				AnimGraph.CreateAnimation("reload_1", false, 1.0, 1.0);
	anims['weapon_put_away'] =		AnimGraph.CreateAnimation("put_away", false, 1.0, 1.0);
	anims['weapon_ready'] =			AnimGraph.CreateAnimation("ready", false, 1.0, 1.0);
	anims['throw_equipment'] =		player_throw_equipment();

	-- Fire state animation sources
	anims['fire'] =					fire();
	anims['dummy_pose'] =			global_dummy_pose();

	-- Aim state animation source
	anims['aim'] =					aim();

	-- Damage response animation sources
	anims['fullbody_ping'] =		ping();
	anims['sping'] =				ping();

	-- Dead state animation sources
	anims['airborne_dead'] =		airborne_dead();
	anims['landing_dead'] =			landing_dead();

	---------------------------------- CREATE STATEMACHINE TRANSITION LOGIC --------------------------------------------
	--control parameters used for state transition logic
	control_parameter['ground'] = control_ground();
	control_parameter['melee'] = AnimGraph.CreateBoolControlParameter("melee"); --control_melee()
	control_parameter['throw_grenade'] = AnimGraph.CreateBoolControlParameter("throw_grenade"); --control_grenade()
	control_parameter['reload'] = AnimGraph.CreateBoolControlParameter("reload_1");
	control_parameter['airborne'] = control_airborne();
	control_parameter['interact_weapon_pickup'] = AnimGraph.CreateBoolControlParameter("interact_weapon_pickup"); --control_interact_weapon_pickup()
	control_parameter['interact_device'] = AnimGraph.CreateBoolControlParameter("interact_device"); --control_interact_device()
	control_parameter['ping'] = control_ping();
	control_parameter['ping_type'] = control_ping_type();
	control_parameter['ping_body_part'] = control_ping_body_part();
	control_parameter['ping_yaw'] = control_ping_yaw();
	control_parameter['ping_pitch'] = control_ping_pitch();
	control_parameter['ping_direction'] = control_ping_direction();
	control_parameter['resetFullBodyPing'] = control_reset_fullbody_ping();
	control_parameter['crouch'] = control_crouch();
	control_parameter['s_ping_damage_part'] = control_sping_damage_part();
	control_parameter['custom_animation_start'] = control_custom_animation_start();
	control_parameter['sprint'] = AnimGraph.CreateBoolControlParameter("sprint");
	control_parameter['testVec'] = AnimGraph.CreateVectorControlParameter("testVec");
	control_parameter['weapon_class'] = AnimGraph.CreateStringControlParameter("weapon_class");
	control_parameter['weapon_name'] = AnimGraph.CreateStringControlParameter("weapon_name");
	control_parameter['weapon_put_away'] = AnimGraph.CreateBoolControlParameter("weapon_put_away");
	control_parameter['weapon_ready'] = AnimGraph.CreateBoolControlParameter("weapon_ready");
	control_parameter['clamber_enter'] = AnimGraph.CreateBoolControlParameter("clamber_enter");
	control_parameter['clamber_exit'] = AnimGraph.CreateBoolControlParameter("clamber_exit");
	control_parameter['equipment_activate'] = AnimGraph.CreateBoolControlParameter("equipment_activate");

	--state machine interrupts
	control_parameter['upper_body_interrupt'] = AnimGraph.CreateBoolControlParameter("upper_body_interrupt");
	control_parameter['moving_interrupt'] = AnimGraph.CreateBoolControlParameter("moving_interrupt");

	--movement state specific logic
	logic['isIdling'] = player_isInIdle();
	logic['isLocomoting'] = player_isInLocomotion();
	logic['hasEndedAirborne'] = hasEndedAirborne();
	logic['hasEndedLand_Soft'] = hasEndedLand_Soft();
	logic['fullBodyStateRequest'] = fullBodyStateRequest();
	logic['hasEndedFullBodyState'] = hasEndedFullBodyState();
	logic['clamber_to_idle'] = exit_clamber_to_idle();
	logic['clamber_to_locomote'] = exit_clamber_to_locomote();
	logic['isFullBodyPing'] = is_full_body_ping();

	--firing state logic
	logic['isFiring'] = isFiring();
	logic['hasEndedFire'] = hasEndedFire();
	logic['hasEndedAnim'] = AnimGraph.CreateEndOfAnimation(0.0000);
	logic['hasEndedSprint'] = AnimGraph.CreateBooleanInvert();
	NG.CreateLink(control_parameter['sprint'].Out, logic['hasEndedSprint'].In);

	--dead state ending logic
	logic['hasEndedDead'] = hasEndedDead();
	logic['airSwim'] = isInAirborneDead();

	----------------------------------- CREATE STATEMACHINES -----------------------------------------------------------
	local topLevelStateMachine =	AnimGraph.CreateStateMachine();
	local aimingStateMachine =		AnimGraph.CreateStateMachine();
	local movingStateMachine =		AnimGraph.CreateStateMachine();
	local fullbodyStateMachine =	AnimGraph.CreateStateMachine();
	local deadStateMachine =		AnimGraph.CreateStateMachine();
	local firingStateMachine =		AnimGraph.CreateStateMachine();
	local upperBodyStateMachine =	AnimGraph.CreateStateMachine();

	---------------------------------- CREATE LAYER --------------------------------------------------------------------
	local final_layer = AnimGraph.CreateLayer();

	---------------------------------- CREATE STATES -------------------------------------------------------------------
	-- Top Level States
	local movingState =			AnimGraph.AddNewState(topLevelStateMachine, final_layer.Out,'MOVING');
	local deadState =			AnimGraph.AddNewState(topLevelStateMachine, deadStateMachine.Out,'DEAD');
	local fullbodyState =		AnimGraph.AddNewState(topLevelStateMachine, fullbodyStateMachine.Out,'fullbodyState');
	-- Aiming STATES
	local aimState =			AnimGraph.AddNewState(aimingStateMachine, anims["aim"], "AIM");
	-- Moving States
	local idleState =			AnimGraph.AddNewState(movingStateMachine, anims["idle"].Out, 'IDLE');
	local locomotionState =		AnimGraph.AddNewState(movingStateMachine, anims["locomotion"].Out, 'LOCOMOTE');
	local airborneState =		AnimGraph.AddNewState(movingStateMachine, anims['airborne'].Out, 'AIRBORNE');
	local sprintState =			AnimGraph.AddNewState(movingStateMachine, anims['sprint'].Out, 'SPRINT');
	local clamberEnterState =	AnimGraph.AddNewState(movingStateMachine, anims['clamber_enter'].Out, 'CLAMBERENTER');
	local clamberExitState =	AnimGraph.AddNewState(movingStateMachine, anims['clamber_exit'].Out, 'CLAMBEREXIT');
	local clamberExitToIdle =	AnimGraph.AddNewState(movingStateMachine, anims['clamber_exit_idle'].Out, 'CLAMBEREXIT2IDLE');
	local clamberExitToLoco =	AnimGraph.AddNewState(movingStateMachine, anims['clamber_exit_loco'].Out, 'CLAMBEREXIT2LOCO');
	-- Full body states
	local fullBodyPingState =	AnimGraph.AddNewState(fullbodyStateMachine, anims['fullbody_ping'].Out, 'FULLBODY PING');
	-- Dead States
	local airborneDeadState =	AnimGraph.AddNewState(deadStateMachine, anims["airborne_dead"].Out,'AIRBORNE DEAD');
	local landingDeadState =	AnimGraph.AddNewState(deadStateMachine, anims["landing_dead"].Out,'LANDING DEAD');
	local deadDummyState =		AnimGraph.AddNewState(deadStateMachine, anims["dummy_pose"].Out,'DEAD DUMMY');
	-- Firing States
	local fireState =			AnimGraph.AddNewState(firingStateMachine, anims["fire"].Out,'FIRING');
	local fire_dummyState =		AnimGraph.AddNewState(firingStateMachine, anims["dummy_pose"].Out,'FIRING DUMMY');
	-- Upper body states
	local upperBodyIdle =		AnimGraph.AddNewState(upperBodyStateMachine, anims["dummy_pose"].Out, 'UPPER_BODY_IDLE');
	local upperBodyGrenade =	AnimGraph.AddNewState(upperBodyStateMachine, anims["throw_grenade"].Out, 'GRENADE');
	local upperBodyMelee =		AnimGraph.AddNewState(upperBodyStateMachine, anims["melee"].Out, 'MELEE');
	local weaponReload =		AnimGraph.AddNewState(upperBodyStateMachine, anims["reload"].Out, 'RELOAD');
	local weaponPutAway =		AnimGraph.AddNewState(upperBodyStateMachine, anims['weapon_put_away'].Out, 'PUTAWAY');
	local weaponReady =			AnimGraph.AddNewState(upperBodyStateMachine, anims['weapon_ready'].Out, 'READY');
	local upperBodyEquipment =	AnimGraph.AddNewState(upperBodyStateMachine, anims['throw_equipment'].Out, 'THROW_EQUIPMENT');

	-- Transition definitions
	local transitionBlend = CreateDefaultTransitionBlendGraph();

	local moveDefault =			AnimGraph.AddNewTransitionBlend(movingStateMachine, transitionBlend.Out, 0.25);
	local moveFast =			AnimGraph.AddNewTransitionBlend(movingStateMachine, transitionBlend.Out, 0.125);
	local moveInstant =			AnimGraph.AddNewTransitionBlend(movingStateMachine, transitionBlend.Out, 0.0);

	local topLevelDefault =		AnimGraph.AddNewTransitionBlend(topLevelStateMachine, transitionBlend.Out, 0.25);
	local topLevelFast =		AnimGraph.AddNewTransitionBlend(topLevelStateMachine, transitionBlend.Out, 0.125);
	local topLevelInstant =		AnimGraph.AddNewTransitionBlend(topLevelStateMachine, transitionBlend.Out, 0.0);

	local fireInstant =			AnimGraph.AddNewTransitionBlend(firingStateMachine, transitionBlend.Out, 0.0);
	local fireSlow =			AnimGraph.AddNewTransitionBlend(firingStateMachine, transitionBlend.Out, 0.1);

	local deadDefault =			AnimGraph.AddNewTransitionBlend(deadStateMachine, transitionBlend.Out, 0.125);
	local fullBodyInstant =		AnimGraph.AddNewTransitionBlend(fullbodyStateMachine, transitionBlend.Out, 0.0);
	local upperBodyInstant =	AnimGraph.AddNewTransitionBlend(upperBodyStateMachine, transitionBlend.Out, 0.0);

	------------------------------- APPLY TRANSITION CONDIITONS --------------------------------------------------------
	--moving state machine transtions
	AnimGraph.AddNewTransitionRule(movingStateMachine, idleState, locomotionState, moveDefault, logic['isLocomoting'].Out);
	AnimGraph.AddNewTransitionRule(movingStateMachine, idleState, airborneState, moveDefault, control_parameter['airborne'].Out);
	AnimGraph.AddNewTransitionRule(movingStateMachine, idleState, clamberEnterState, moveFast, control_parameter['clamber_enter'].Out);

	AnimGraph.AddNewTransitionRule(movingStateMachine, locomotionState, idleState, moveDefault, logic['isIdling'].Out);
	AnimGraph.AddNewTransitionRule(movingStateMachine, locomotionState, airborneState, moveFast, control_parameter['airborne'].Out);
	AnimGraph.AddNewTransitionRule(movingStateMachine, locomotionState, sprintState, moveFast, control_parameter['sprint'].Out);
	AnimGraph.AddNewTransitionRule(movingStateMachine, locomotionState, clamberEnterState, moveFast, control_parameter['clamber_enter'].Out);

	AnimGraph.AddNewTransitionRule(movingStateMachine, airborneState, idleState, moveFast, logic['hasEndedAirborne'].Out);
	AnimGraph.AddNewTransitionRule(movingStateMachine, airborneState, locomotionState, moveFast, logic['isLocomoting'].Out);
	AnimGraph.AddNewTransitionRule(movingStateMachine, airborneState, clamberEnterState, moveFast, control_parameter['clamber_enter'].Out);
	--AnimGraph.AddNewTransitionRule(movingStateMachine, airborneState, sprintState, moveFast, logic['hasEndedAirborne'].Out);

	AnimGraph.AddNewTransitionRule(movingStateMachine, sprintState, locomotionState, moveFast, logic['hasEndedSprint'].Out);
	AnimGraph.AddNewTransitionRule(movingStateMachine, sprintState, airborneState, moveFast, control_parameter['airborne'].Out);

	AnimGraph.AddNewTransitionRule(movingStateMachine, clamberEnterState, clamberExitState, moveFast, control_parameter['clamber_exit'].Out);

	AnimGraph.AddNewTransitionRule(movingStateMachine, clamberExitState, clamberExitToIdle, moveFast, logic['clamber_to_idle'].Out);
	AnimGraph.AddNewTransitionRule(movingStateMachine, clamberExitState, clamberExitToLoco, moveFast, logic['clamber_to_locomote'].Out);

	AnimGraph.AddNewTransitionRule(movingStateMachine, clamberExitToIdle, idleState, moveFast, logic['hasEndedAnim'].Out);
	AnimGraph.AddNewTransitionRule(movingStateMachine, clamberExitToIdle, locomotionState, moveFast, logic['isLocomoting'].Out);

	AnimGraph.AddNewTransitionRule(movingStateMachine, clamberExitToLoco, locomotionState, moveFast, logic['hasEndedAnim'].Out);
	--AnimGraph.AddNewTransitionRule(movingStateMachine, clamberExitToLoco, idleState, moveFast, logic['isIdling'].Out);

	--top level state machine transtions
	AnimGraph.AddNewTransitionRule(topLevelStateMachine, movingState, deadState, topLevelFast, logic['airSwim'].Out);
	AnimGraph.AddNewTransitionRule(topLevelStateMachine, movingState, movingState, topLevelDefault, logic['fullBodyStateRequest'].Out);

	--fullbody state machine transtions
	AnimGraph.AddNewTransitionRule(fullbodyStateMachine, fullBodyPingState, fullBodyPingState, fullBodyInstant, control_parameter['resetFullBodyPing'].Out);
	AnimGraph.AddDefaultStateRule(fullbodyStateMachine, fullBodyPingState, logic['isFullBodyPing'].Out);

	--dead state machine transtions
	AnimGraph.AddNewTransitionRule(deadStateMachine, airborneDeadState, landingDeadState, deadDefault, control_parameter['ground'].Out);
	AnimGraph.AddNewTransitionRule(deadStateMachine, landingDeadState, deadDummyState, deadDefault, logic['hasEndedFullBodyState'].Out);

	--firing state machine transtions
	AnimGraph.AddNewTransitionRule(firingStateMachine, fire_dummyState, fireState, fireSlow, logic['isFiring'].Out);
	AnimGraph.AddNewTransitionRule(firingStateMachine, fireState, fireState, fireInstant, logic['isFiring'].Out);
	AnimGraph.AddNewTransitionRule(firingStateMachine, fireState, fire_dummyState, fireInstant, logic['hasEndedFire'].Out);

	--upper body state machine transitions
	AnimGraph.AddNewTransitionRule(upperBodyStateMachine, upperBodyIdle, upperBodyMelee, upperBodyInstant, control_parameter['melee'].Out);
	AnimGraph.AddNewTransitionRule(upperBodyStateMachine, upperBodyIdle, upperBodyGrenade, upperBodyInstant, control_parameter['throw_grenade'].Out);
	AnimGraph.AddNewTransitionRule(upperBodyStateMachine, upperBodyIdle, weaponReload, upperBodyInstant, control_parameter['reload'].Out);
	AnimGraph.AddNewTransitionRule(upperBodyStateMachine, upperBodyIdle, weaponPutAway, upperBodyInstant, control_parameter['weapon_put_away'].Out);
	AnimGraph.AddNewTransitionRule(upperBodyStateMachine, upperBodyIdle, weaponReady, upperBodyInstant, control_parameter['weapon_ready'].Out);
	AnimGraph.AddNewTransitionRule(upperBodyStateMachine, upperBodyIdle, upperBodyEquipment, upperBodyInstant, control_parameter['equipment_activate'].Out);

	AnimGraph.AddNewTransitionRule(upperBodyStateMachine, upperBodyMelee, upperBodyMelee, upperBodyInstant, control_parameter['melee'].Out);
	AnimGraph.AddNewTransitionRule(upperBodyStateMachine, upperBodyMelee, upperBodyIdle, upperBodyInstant, logic['hasEndedAnim'].Out);
	AnimGraph.AddNewTransitionRule(upperBodyStateMachine, upperBodyMelee, upperBodyIdle, upperBodyInstant, control_parameter['upper_body_interrupt'].Out);
	AnimGraph.AddNewTransitionRule(upperBodyStateMachine, upperBodyMelee, upperBodyGrenade, upperBodyInstant, control_parameter['throw_grenade'].Out);
	AnimGraph.AddNewTransitionRule(upperBodyStateMachine, upperBodyMelee, weaponReload, upperBodyInstant, control_parameter['reload'].Out);
	AnimGraph.AddNewTransitionRule(upperBodyStateMachine, upperBodyMelee, weaponPutAway, upperBodyInstant, control_parameter['weapon_put_away'].Out);
	AnimGraph.AddNewTransitionRule(upperBodyStateMachine, upperBodyMelee, weaponReady, upperBodyInstant, control_parameter['weapon_ready'].Out);
	AnimGraph.AddNewTransitionRule(upperBodyStateMachine, upperBodyMelee, upperBodyEquipment, upperBodyInstant, control_parameter['equipment_activate'].Out);

	AnimGraph.AddNewTransitionRule(upperBodyStateMachine, upperBodyGrenade, upperBodyIdle, upperBodyInstant, logic['hasEndedAnim'].Out);
	AnimGraph.AddNewTransitionRule(upperBodyStateMachine, upperBodyGrenade, upperBodyIdle, upperBodyInstant, control_parameter['upper_body_interrupt'].Out);
	AnimGraph.AddNewTransitionRule(upperBodyStateMachine, upperBodyGrenade, weaponPutAway, upperBodyInstant, control_parameter['weapon_put_away'].Out);
	AnimGraph.AddNewTransitionRule(upperBodyStateMachine, upperBodyGrenade, weaponReady, upperBodyInstant, control_parameter['weapon_ready'].Out);
	AnimGraph.AddNewTransitionRule(upperBodyStateMachine, upperBodyGrenade, upperBodyEquipment, upperBodyInstant, control_parameter['equipment_activate'].Out);

	AnimGraph.AddNewTransitionRule(upperBodyStateMachine, weaponReload, upperBodyGrenade, upperBodyInstant, control_parameter['throw_grenade'].Out);
	AnimGraph.AddNewTransitionRule(upperBodyStateMachine, weaponReload, upperBodyMelee, upperBodyInstant, control_parameter['melee'].Out);
	AnimGraph.AddNewTransitionRule(upperBodyStateMachine, weaponReload, upperBodyIdle, upperBodyInstant, control_parameter['upper_body_interrupt'].Out);
	AnimGraph.AddNewTransitionRule(upperBodyStateMachine, weaponReload, upperBodyIdle, upperBodyInstant, logic['hasEndedAnim'].Out);
	AnimGraph.AddNewTransitionRule(upperBodyStateMachine, weaponReload, weaponPutAway, upperBodyInstant, control_parameter['weapon_put_away'].Out);
	AnimGraph.AddNewTransitionRule(upperBodyStateMachine, weaponReload, weaponReady, upperBodyInstant, control_parameter['weapon_ready'].Out);
	AnimGraph.AddNewTransitionRule(upperBodyStateMachine, weaponReload, upperBodyEquipment, upperBodyInstant, control_parameter['equipment_activate'].Out);

	AnimGraph.AddNewTransitionRule(upperBodyStateMachine, weaponPutAway, weaponReady, upperBodyInstant, control_parameter['weapon_ready'].Out);

	AnimGraph.AddNewTransitionRule(upperBodyStateMachine, weaponReady, upperBodyIdle, upperBodyInstant, logic['hasEndedAnim'].Out);
	AnimGraph.AddNewTransitionRule(upperBodyStateMachine, weaponReady, upperBodyMelee, upperBodyInstant, control_parameter['melee'].Out);
	AnimGraph.AddNewTransitionRule(upperBodyStateMachine, weaponReady, upperBodyGrenade, upperBodyInstant, control_parameter['throw_grenade'].Out);
	AnimGraph.AddNewTransitionRule(upperBodyStateMachine, weaponReady, weaponReload, upperBodyInstant, control_parameter['reload'].Out);
	AnimGraph.AddNewTransitionRule(upperBodyStateMachine, weaponReady, weaponPutAway, upperBodyInstant, control_parameter['weapon_put_away'].Out);
	AnimGraph.AddNewTransitionRule(upperBodyStateMachine, weaponReady, upperBodyEquipment, upperBodyInstant, control_parameter['equipment_activate'].Out);

	AnimGraph.AddNewTransitionRule(upperBodyStateMachine, upperBodyEquipment, upperBodyIdle, upperBodyInstant, logic['hasEndedAnim'].Out);
	AnimGraph.AddNewTransitionRule(upperBodyStateMachine, upperBodyEquipment, upperBodyMelee, upperBodyInstant, control_parameter['melee'].Out);
	--AnimGraph.AddNewTransitionRule(upperBodyStateMachine, upperBodyEquipment, upperBodyGrenade, upperBodyInstant, control_parameter['throw_grenade'].Out);
	--AnimGraph.AddNewTransitionRule(upperBodyStateMachine, upperBodyEquipment, weaponReload, upperBodyInstant, control_parameter['reload'].Out);
	--AnimGraph.AddNewTransitionRule(upperBodyStateMachine, upperBodyEquipment, weaponPutAway, upperBodyInstant, control_parameter['weapon_put_away'].Out);

	--set Up state machnine defaults states
	AnimGraph.SetFallbackDefaultState(topLevelStateMachine, movingState);
	AnimGraph.SetFallbackDefaultState(aimingStateMachine, aimState);
	AnimGraph.SetFallbackDefaultState(firingStateMachine, fire_dummyState);
	AnimGraph.SetFallbackDefaultState(deadStateMachine, airborneDeadState);
	AnimGraph.SetFallbackDefaultState(fullbodyStateMachine, fullBodyPingState);
	AnimGraph.SetFallbackDefaultState(upperBodyStateMachine, upperBodyIdle);

	---------------------------------- HOOK UP LAYER AND LAYER SETTINGS ------------------------------------------------
	NG.CreateLink(movingStateMachine.Out, final_layer.Base);
	NG.CreateLink(firingStateMachine.Out, final_layer.Pose);
	NG.CreateLink(upperBodyStateMachine.Out, final_layer.Pose);
	NG.CreateLink(aimingStateMachine.Out, final_layer.Pose);
	-- NG.CreateLink(anims['sping'].Out, final_layer.Pose);

	local firingWeight = AnimGraph.CreateConstantFloat(1.0);
	local upperBodyWeight = AnimGraph.CreateConstantFloat(1.0);
	local aimingWeight = AnimGraph.CreateConstantFloat(1.0);
	-- local s_pingWeight = AnimGraph.CreateConstantFloat(0.0);

	AnimGraph.AddLayerNodeInputPose(final_layer, 0, firingWeight.Out, 1);
	AnimGraph.AddLayerNodeInputPose(final_layer, 1, upperBodyWeight.Out, 2);
	AnimGraph.AddLayerNodeInputPose(final_layer, 2, aimingWeight.Out, 1);
	-- AnimGraph.AddLayerNodeInputPose(final_layer, 2, s_pingWeight.Out, 1);

	--------------------------------- HOOK UP STATE MACHINE TO FINAL NODE ----------------------------------------------
	local final = AnimGraph.GetFinalPose();
	NG.CreateLink(final_layer.Out, final.In);

	-------------------------------------------- ANIM SET PUSHING ------------------------------------------------------
	local animSetStrings = {}
	-- Concatination tokens
	animSetStrings['crouch_'] = AnimGraph.CreateConstantString("crouch_");
	animSetStrings['rifle_'] = AnimGraph.CreateConstantString("rifle_");
	animSetStrings['s_ping_'] = AnimGraph.CreateConstantString("s_ping_");
	animSetStrings['m_ping_'] = AnimGraph.CreateConstantString("m_ping_");
	animSetStrings['h_ping_'] = AnimGraph.CreateConstantString("h_ping_");
	animSetStrings['s_kill_'] = AnimGraph.CreateConstantString("s_kill_");
	animSetStrings['h_kill_'] = AnimGraph.CreateConstantString("h_kill_");
	animSetStrings['back'] = AnimGraph.CreateConstantString("back");
	animSetStrings['front'] = AnimGraph.CreateConstantString("front");
	animSetStrings['left'] = AnimGraph.CreateConstantString("left");
	animSetStrings['right'] = AnimGraph.CreateConstantString("right");
	animSetStrings['_'] = AnimGraph.CreateConstantString("_");
	-- Ping name tokens
	animSetStrings['gut'] = AnimGraph.CreateConstantString("gut");
	animSetStrings['chest'] = AnimGraph.CreateConstantString("chest");
	animSetStrings['head'] = AnimGraph.CreateConstantString("head");
	animSetStrings['left_shoulder'] = AnimGraph.CreateConstantString("left_shoulder");
	animSetStrings['left_arm'] = AnimGraph.CreateConstantString("left_arm");
	animSetStrings['left_leg'] = AnimGraph.CreateConstantString("left_leg");
	animSetStrings['left_foot'] = AnimGraph.CreateConstantString("left_foot");
	animSetStrings['right_shoulder'] = AnimGraph.CreateConstantString("right_shoulder");
	animSetStrings['right_arm'] = AnimGraph.CreateConstantString("right_arm");
	animSetStrings['right_leg'] = AnimGraph.CreateConstantString("right_leg");
	animSetStrings['right_foot'] = AnimGraph.CreateConstantString("right_foot");

	-- Weapon class selection switch. Add classes to this list when creating new ones
	local weaponClassSwitch = AnimGraph.CreateSwitchOnString();
	AnimGraph.AddSwitchOnStringOption(weaponClassSwitch, "rifle");
	AnimGraph.AddSwitchOnStringOption(weaponClassSwitch, "pistol");
	AnimGraph.AddSwitchOnStringOption(weaponClassSwitch, "missile");
	AnimGraph.AddSwitchOnStringOption(weaponClassSwitch, "sword");
	NG.CreateLink(control_parameter['weapon_class'].Out, weaponClassSwitch.Selection);

	-- Weapon name selection switch. Add weapons to this list when creating new ones
	local weaponNameSwitch = AnimGraph.CreateSwitchOnString();
	AnimGraph.AddSwitchOnStringOption(weaponNameSwitch, "ar");
	AnimGraph.AddSwitchOnStringOption(weaponNameSwitch, "sg");
	AnimGraph.AddSwitchOnStringOption(weaponNameSwitch, "hp");
	AnimGraph.AddSwitchOnStringOption(weaponNameSwitch, "ac");
	NG.CreateLink(control_parameter['weapon_name'].Out, weaponNameSwitch);

	AnimGraph.AddPushAnimSetEntry(control_parameter['weapon_class'].Out); -- Push default class set
	AnimGraph.AddPushAnimSetEntry(control_parameter['weapon_name'].Out); -- Push named weapon set

	-- Crouching set conditional pushing
	local crouchWeaponClass = AnimGraph.CreateAnimSetNameConcatenate();
	AnimGraph.AddAnimSetNameSubstring(crouchWeaponClass, animSetStrings['crouch_']);
	AnimGraph.AddAnimSetNameSubstring(crouchWeaponClass, weaponClassSwitch);
	AnimGraph.AddConditionalPushAnimSetEntry(control_parameter['crouch'], crouchWeaponClass); -- Push the default crouch class set

	local crouchWeaponName = AnimGraph.CreateAnimSetNameConcatenate();
	AnimGraph.AddAnimSetNameSubstring(crouchWeaponName, animSetStrings['crouch_']);
	AnimGraph.AddAnimSetNameSubstring(crouchWeaponName, weaponNameSwitch);
	AnimGraph.AddConditionalPushAnimSetEntry(control_parameter['crouch'], crouchWeaponName); -- Push the crouch weapon_name set

	-- Ping type conditional pushing
	local pingTypeName = AnimGraph.CreateSwitchOnInteger();
	NG.AddSwitchOnIntegerOption(pingTypeName, 2, animSetStrings['m_ping_']);
	NG.AddSwitchOnIntegerOption(pingTypeName, 3, animSetStrings['h_ping_']);
	NG.AddSwitchOnIntegerOption(pingTypeName, 4, animSetStrings['s_kill_']);
	NG.AddSwitchOnIntegerOption(pingTypeName, 5, animSetStrings['h_kill_']);
	-- NG.AddSwitchOnIntegerOption(pingTypeName, 6, animSetStrings['h_kill_']);
	NG.AddSwitchOnIntegerOption(pingTypeName, 7, animSetStrings['h_kill_']);
	NG.AddSwitchOnIntegerOption(pingTypeName, 8, animSetStrings['h_kill_']);
	NG.AddSwitchOnIntegerOption(pingTypeName, 9, animSetStrings['h_kill_']);
	NG.CreateLink(control_parameter['ping_type'].Out, pingTypeName.Selection);

	local pingDirectionName = AnimGraph.CreateSwitchOnInteger();
	NG.AddSwitchOnIntegerOption(pingDirectionName, 0, animSetStrings['front']);
	NG.AddSwitchOnIntegerOption(pingDirectionName, 1, animSetStrings['left']);
	NG.AddSwitchOnIntegerOption(pingDirectionName, 2, animSetStrings['right']);
	NG.AddSwitchOnIntegerOption(pingDirectionName, 3, animSetStrings['back']);
	NG.CreateLink(control_parameter['ping_direction'].Out, pingDirectionName.Selection);

	local pingAnimSetName = AnimGraph.CreateAnimSetNameConcatenate();
	AnimGraph.AddAnimSetNameSubstring(pingAnimSetName, weaponClassSwitch);
	AnimGraph.AddAnimSetNameSubstring(pingAnimSetName, animSetStrings['_']);
	AnimGraph.AddAnimSetNameSubstring(pingAnimSetName, pingTypeName);
	AnimGraph.AddAnimSetNameSubstring(pingAnimSetName, pingDirectionName);

	AnimGraph.AddConditionalPushAnimSetEntry(control_parameter['ping'], pingAnimSetName);

	-- local s_pingDamageRegion = AnimGraph.CreateSwitchOnInteger();
	-- NG.AddSwitchOnIntegerOption(s_pingDamageRegion, 0, animSetStrings['gut']);
	-- NG.AddSwitchOnIntegerOption(s_pingDamageRegion, 1, animSetStrings['chest']);
	-- NG.AddSwitchOnIntegerOption(s_pingDamageRegion, 2, animSetStrings['head']);
	-- NG.AddSwitchOnIntegerOption(s_pingDamageRegion, 3, animSetStrings['left_shoulder']);
	-- NG.AddSwitchOnIntegerOption(s_pingDamageRegion, 4, animSetStrings['left_arm']);
	-- NG.AddSwitchOnIntegerOption(s_pingDamageRegion, 5, animSetStrings['left_leg']);
	-- NG.AddSwitchOnIntegerOption(s_pingDamageRegion, 6, animSetStrings['left_foot']);
	-- NG.AddSwitchOnIntegerOption(s_pingDamageRegion, 7, animSetStrings['right_shoulder']);
	-- NG.AddSwitchOnIntegerOption(s_pingDamageRegion, 8, animSetStrings['right_arm']);
	-- NG.AddSwitchOnIntegerOption(s_pingDamageRegion, 9, animSetStrings['right_leg']);
	-- NG.AddSwitchOnIntegerOption(s_pingDamageRegion, 10, animSetStrings['right_foot']);

	-- NG.CreateLink(control_parameter['s_ping_damage_part'].Out, s_pingDamageRegion.Selection);
	
	-- local s_pingAnimSetName = AnimGraph.CreateAnimSetNameConcatenate();
	-- AnimGraph.AddAnimSetNameSubstring(s_pingAnimSetName, weaponClassSwitch);
	-- AnimGraph.AddAnimSetNameSubstring(s_pingAnimSetName, animSetStrings['_']);
	-- AnimGraph.AddAnimSetNameSubstring(s_pingAnimSetName, animSetStrings['s_ping_']);
	-- AnimGraph.AddAnimSetNameSubstring(s_pingAnimSetName, s_pingDamageRegion);
	
	-- AnimGraph.AddPushAnimSetEntry(s_pingAnimSetName);
end

