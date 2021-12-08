-- Copyright (c) Microsoft. All rights reserved.

function vehicle_state_machine()
	local anims = {}
	local logic = {}
	local control_parameter = {}
	
	anims["idle"] = vehicle_idle();

	anims["vehicle_enter"] = vehicle_enter();
	anims["vehicle_board"] = vehicle_board();
	anims["vehicle_exit"] = vehicle_exit();
	anims["vehicle_melee"] = vehicle_melee();

	logic['hasEnded'] = hasEndedAnimation()
	logic['inNotVehicle'] = isNOT_vehicle()

	control_parameter['vehicle_enter'] = AnimGraph.CreateBoolControlParameter('vehicle_enter')
	control_parameter['vehicle'] = AnimGraph.CreateBoolControlParameter('vehicle')
	control_parameter['vehicle_exit'] = AnimGraph.CreateBoolControlParameter('vehicle_exit')
	control_parameter['vehicle_melee'] = AnimGraph.CreateBoolControlParameter('vehicle_melee')
	control_parameter['vehicle_board'] = AnimGraph.CreateBoolControlParameter('vehicle_board')

	local vehicle_state_machine = AnimGraph.CreateStateMachine();
	
	local vehicle_idleState = AnimGraph.AddNewState(vehicle_state_machine, anims["idle"].Out,'VEHICLE_IDLE');
	local vehicle_enterState = AnimGraph.AddNewState(vehicle_state_machine, anims["vehicle_enter"].Out,'VEHICLE_ENTER');
	local vehicle_boardState = AnimGraph.AddNewState(vehicle_state_machine, anims["vehicle_board"].Out,'VEHICLE_BOARD');
	local vehicle_exitState = AnimGraph.AddNewState(vehicle_state_machine, anims["vehicle_exit"].Out,'VEHICLE_EXIT');
	local vehicle_meleeState = AnimGraph.AddNewState(vehicle_state_machine, anims["vehicle_melee"].Out,'VEHICLE_MELEE');

	local transitionBlend = CreateDefaultTransitionBlendGraph();
	local default_trans = AnimGraph.AddNewTransitionBlend(vehicle_state_machine, transitionBlend.Out, .25);
	
	AnimGraph.AddDefaultStateRule(vehicle_state_machine, vehicle_enterState, control_parameter['vehicle_enter'].Out);
	AnimGraph.AddDefaultStateRule(vehicle_state_machine, vehicle_idleState, control_parameter['vehicle'].Out);

	AnimGraph.AddNewTransitionRule(vehicle_state_machine, vehicle_enterState, vehicle_idleState, default_trans, control_parameter['vehicle'].Out);
	AnimGraph.AddNewTransitionRule(vehicle_state_machine, vehicle_idleState, vehicle_exitState, default_trans, control_parameter['vehicle_exit'].Out);

	AnimGraph.AddNewTransitionRule(vehicle_state_machine, vehicle_enterState, vehicle_boardState, default_trans, control_parameter['vehicle_board'].Out);
	AnimGraph.AddNewTransitionRule(vehicle_state_machine, vehicle_boardState, vehicle_idleState, default_trans, control_parameter['vehicle'].Out);
	AnimGraph.AddNewTransitionRule(vehicle_state_machine, vehicle_idleState, vehicle_meleeState, default_trans, control_parameter['vehicle_melee'].Out);
	AnimGraph.AddNewTransitionRule(vehicle_state_machine, vehicle_meleeState, vehicle_idleState, default_trans, control_parameter['vehicle'].Out);

	AnimGraph.AddNewTransitionRule(vehicle_state_machine, vehicle_enterState, vehicle_exitState, default_trans, control_parameter['vehicle_exit'].Out);

	return vehicle_state_machine;
end


function idle_state_machine()
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


--this is the state machine that is referencing sub graphs
function master_animation_graph()

	--create animation, logic and control parameter tables
	local anims = {}
	local logic = {}

	local pingBodyPartLogic = {}
	local control_parameter = {}
	
	--create default transition blend logic
	local transitionBlend = CreateDefaultTransitionBlendGraph();

	--movement state animation sources
	anims["idle"] = idle_state_machine();
	anims["locomotion"] = locomotion();
	anims['airborne'] = airborne();
	anims['land_soft'] = land_soft();

	--fullbody state animation sources
	anims['evade'] = evade();
	anims['dive'] = dive();
	anims['hard_stop'] = hard_stop_animation();
	anims['custom_animation'] = anim_graph_custom_animation();
	anims['hunker_enter'] = hunker_enter();
	anims['hunker_loop'] = hunker_loop();
	anims['hunker_exit'] = hunker_exit();

	--fire state animation sources
	anims['fire'] = fire();
	anims['dummy_pose'] = global_dummy_pose();

	--aim layer animation source
	local aimPose = aim();

	-- damage response animation sources
	anims['fullbody_ping'] = ping();
	anims['sping'] = sping();

	-- replacement animation sources
	anims['put_away'] = replacement_put_away();
	anims['ready'] = replacement_ready();

	anims['banking'] = banking_1d_blend();
	
	
	-- aim state machine
	local weaponDownAnim = AnimGraph.CreateAnimation("locomote_run_front_down", false, 2, 1.0);
	NG.CreateLink(anims["locomotion"].Phase, weaponDownAnim.Position);

	local aimStateMachine = AnimGraph.CreateStateMachine();

	local aimPoseState = AnimGraph.AddNewState(aimStateMachine, aimPose.Out, "AIM");
	local weaponDownAnimState = AnimGraph.AddNewState(aimStateMachine, weaponDownAnim.Out, "SPRINT");

	local aimSlow = AnimGraph.AddNewTransitionBlend(aimStateMachine, transitionBlend.Out, 0.6);

	local weaponDownBool = AnimGraph.CreateBoolControlParameter("weapon_down");
	local aimBool = AnimGraph.CreateBooleanInvert();
	NG.CreateLink(weaponDownBool.Out, aimBool.In);

	AnimGraph.AddNewTransitionRule(aimStateMachine, aimPoseState, weaponDownAnimState, aimSlow, weaponDownBool.Out);
	AnimGraph.AddNewTransitionRule(aimStateMachine, weaponDownAnimState, aimPoseState, aimSlow, aimBool.Out);

	AnimGraph.SetFallbackDefaultState(aimStateMachine, aimPoseState);

	anims['aim'] = aimStateMachine;

	--dead state animation sources
	anims['airborne_dead'] = airborne_dead();
	anims['landing_dead'] = landing_dead();


	----------------------------------CREATE STATEMACHINE TRANSITION LOGIC----------------------------------------------------------
	
	--control parameters used for state transition logic
	control_parameter['ground'] = control_ground()
	control_parameter['evade'] = control_evade()
	control_parameter['dive'] = control_dive()
	control_parameter['airborne'] = control_airborne()
	control_parameter['ping'] = control_ping();
	control_parameter['ping_type'] = control_ping_type();
	control_parameter['ping_body_part'] = control_ping_body_part();
	control_parameter['ping_yaw'] = control_ping_yaw();
	control_parameter['ping_pitch'] = control_ping_pitch();
	control_parameter['ping_direction'] = control_ping_direction();
	control_parameter['resetFullBodyPing'] = control_reset_fullbody_ping();
	control_parameter['resetCustomAnimation'] = control_reset_custom_animation();
	control_parameter['crouch'] = control_crouch();
	control_parameter['s_ping_damage_part'] = control_sping_damage_part();
	control_parameter['custom_animation_start'] = control_custom_animation_start();
	control_parameter['ready'] = control_ready();
	control_parameter['put_away'] = control_put_away();
	control_parameter['hard_stop'] = AnimGraph.CreateBoolControlParameter("hard_stop");
	control_parameter['vehicle'] = is_vehicle()
	control_parameter['brace'] = AnimGraph.CreateBoolControlParameter("brace");

	--movement state specific logic
			--enter state logic
	logic['isIdling'] = isInIdle()
	logic['isLocomoting'] = isInLocomotion()
			--exit state logic
	logic['hasEndedAirborne'] = hasEndedAirborne()
	logic['hasEndedLand_Soft'] = hasEndedLand_Soft()
	
	-- fullbody state logic
			-- fullbody state ending logic
	logic['fullBodyStateRequest'] = fullBodyStateRequest()
	logic['hasEndedFullBodyState'] = hasEndedFullBodyState()
	logic['isFullBodyPing'] = is_full_body_ping();

	logic['hasEndedHunkerEnter'] = hasEndedHunkerEnter()
	logic['hasEndedHunkerExit'] = hasEndedHunkerExit()

	--firing state logic
			--enter state logic
	logic['isFiring'] = isFiring()
			--exit state logic
	logic['hasEndedFire'] = hasEndedFire()

	--fullbody state logic
			--dead state ending logic
	logic['hasEndedDead'] = hasEndedDead()

	logic['airSwim'] = isInAirborneDead();

	--replacement state state logic
	logic['hasEndedReplacement_ready'] = hasEndedReplacement_ready()
	logic['hasEndedReplacement_put_away'] = hasEndedReplacement_put_away()

		logic['isNOT_brace'] = isNOT_brace()

	--vehicle stuffs
	logic['hasEndedVehicle'] = is_exiting_vehicle()
	logic ['push_Vehicle_set'] = is_vehicle()

	----------------------------------CREATE STATEMACHINES--------------------------------------------------------------------------


	local topLevelStateMachine = AnimGraph.CreateStateMachine();
		
	local movingStateMachine = AnimGraph.CreateStateMachine();
	
	local fullbodyStateMachine = AnimGraph.CreateStateMachine();
	
	local airborneDeadStateMachine = AnimGraph.CreateStateMachine();	
	
	local firingStateMachine = AnimGraph.CreateStateMachine();

	local replacementStateMachine = AnimGraph.CreateStateMachine();

	local braceStateMachine = AnimGraph.CreateStateMachine();

	local vehicle_state_machine = vehicle_state_machine()

	local prefire_tell_state_machine = prefire_tell_state_machine();

	----------------------------------CREATE LAYER--------------------------------------------------------------------------

	local final_layer = AnimGraph.CreateLayer()

	----------------------------------CREATE STATES---------------------------------------------------------------------------------

	--Top Level States
	local movingState = AnimGraph.AddNewState(topLevelStateMachine, final_layer.Out,'MOVING');
	local deadState = AnimGraph.AddNewState(topLevelStateMachine, airborneDeadStateMachine.Out,'DEAD');
	local fullbodyState = AnimGraph.AddNewState(topLevelStateMachine, fullbodyStateMachine.Out,'fullbodyState');
	local vehicleState = AnimGraph.AddNewState(topLevelStateMachine, vehicle_state_machine.Out,'VEHICLE');
	local braceState = AnimGraph.AddNewState(topLevelStateMachine, braceStateMachine.Out,'BRACING');

	--Dead States
	local airborneDeadState = AnimGraph.AddNewState(airborneDeadStateMachine, anims["airborne_dead"].Out,'AIRBORNE DEAD');
	local landingDeadState = AnimGraph.AddNewState(airborneDeadStateMachine, anims["landing_dead"].Out,'LANDING DEAD');
	local deadDummyState = AnimGraph.AddNewState(airborneDeadStateMachine, anims["dummy_pose"].Out,'DEAD DUMMY');

	-- full body states
	local diveState = AnimGraph.AddNewState(fullbodyStateMachine, anims["dive"].Out,'DIVE');
	local evadeState = AnimGraph.AddNewState(fullbodyStateMachine, anims["evade"].Out,'EVADE');
	local fullBodyPingState = AnimGraph.AddNewState(fullbodyStateMachine, anims['fullbody_ping'].Out, 'FULLBODY PING');
	local customAnimationState = AnimGraph.AddNewState(fullbodyStateMachine, anims["custom_animation"].Out,'CUSTOM ANIM');
	local hardStopState = AnimGraph.AddNewState(fullbodyStateMachine, anims["hard_stop"].Out, 'HARD STOP');

	--brace states
	local hunkerEnterState = AnimGraph.AddNewState(braceStateMachine, anims["hunker_enter"].Out,'HUNKER_ENTER');
	local hunkerLoopState = AnimGraph.AddNewState(braceStateMachine, anims["hunker_loop"].Out,'HUNKER_LOOP');
	local hunkerExitState = AnimGraph.AddNewState(braceStateMachine, anims["hunker_exit"].Out,'HUNKER_LOOP');
	
	--Moving States
	local idleState = AnimGraph.AddNewState(movingStateMachine, anims["idle"].Out,'IDLE');
	local locomotionState = AnimGraph.AddNewState(movingStateMachine, anims["locomotion"].Out,'LOCOMOTE');
	local airborneState = AnimGraph.AddNewState(movingStateMachine, anims['airborne'].Out,'AIRBORNE');
	local land_softState = AnimGraph.AddNewState(movingStateMachine, anims['land_soft'].Out,'LAND SOFT');

	--Replacement States
	local put_awayState = AnimGraph.AddNewState(replacementStateMachine, anims['put_away'].Out,'PUT_AWAY');
	local readyState = AnimGraph.AddNewState(replacementStateMachine, anims['ready'].Out,'READY');
	local replacement_dummyState = AnimGraph.AddNewState(replacementStateMachine, anims["dummy_pose"].Out,'REPLACMENT DUMMY');

	--Firing States
	local fireState = AnimGraph.AddNewState(firingStateMachine, anims["fire"].Out,'FIRING');
	local fire_dummyState = AnimGraph.AddNewState(firingStateMachine, anims["dummy_pose"].Out,'FIRING DUMMY');

	-- --Transition definitions
	local defaultTransition = AnimGraph.AddNewTransitionBlend(movingStateMachine, transitionBlend.Out, .25);
	local fast = AnimGraph.AddNewTransitionBlend(movingStateMachine, transitionBlend.Out, .25);
	local instantish = AnimGraph.AddNewTransitionBlend(movingStateMachine, transitionBlend.Out, 0.00);

	local topLevelDefaultTransition = AnimGraph.AddNewTransitionBlend(topLevelStateMachine, transitionBlend.Out, .25);
	local topLevelfast = AnimGraph.AddNewTransitionBlend(topLevelStateMachine, transitionBlend.Out, .125);
	local topLevelDefaultTransitionInstant = AnimGraph.AddNewTransitionBlend(topLevelStateMachine, transitionBlend.Out, 0.00);

	local fire_instant = AnimGraph.AddNewTransitionBlend(firingStateMachine, transitionBlend.Out, 0);
	local fire_slowish = AnimGraph.AddNewTransitionBlend(firingStateMachine, transitionBlend.Out, 0.1);

	local dead_transition = AnimGraph.AddNewTransitionBlend(airborneDeadStateMachine, transitionBlend.Out, 0.125);

	local fullBodyInstant = AnimGraph.AddNewTransitionBlend(fullbodyStateMachine, transitionBlend.Out, 0.0);

	local fullBodydefault = AnimGraph.AddNewTransitionBlend(fullbodyStateMachine, transitionBlend.Out, .125);

	local braceDefault = AnimGraph.AddNewTransitionBlend(braceStateMachine, transitionBlend.Out, .125);


	local replacement_default_transition = AnimGraph.AddNewTransitionBlend(replacementStateMachine, transitionBlend.Out, 0.1);

	-------------------------------APPLY TRANSITION CONDIITONS---------------------------------------------------------------------

	--moving state machine transtions
	AnimGraph.AddNewTransitionRule(movingStateMachine, locomotionState, idleState, defaultTransition, logic['isIdling'].Out);
	AnimGraph.AddNewTransitionRule(movingStateMachine, idleState, locomotionState, defaultTransition, logic['isLocomoting'].Out);
	AnimGraph.AddNewTransitionRule(movingStateMachine, locomotionState, airborneState, fast, control_parameter['airborne'].Out);
	AnimGraph.AddNewTransitionRule(movingStateMachine, airborneState, land_softState, instantish, logic['hasEndedAirborne'].Out);
	AnimGraph.AddNewTransitionRule(movingStateMachine, idleState, airborneState, fast, control_parameter['airborne'].Out);
	AnimGraph.AddNewTransitionRule(movingStateMachine, land_softState, airborneState, fast, control_parameter['airborne'].Out);
	AnimGraph.AddNewTransitionRule(movingStateMachine, land_softState, idleState, fast, logic['hasEndedLand_Soft'].Out);

	--firing  state machine transtions
	AnimGraph.AddNewTransitionRule(firingStateMachine, fire_dummyState, fireState, fire_slowish, logic['isFiring'].Out);
	AnimGraph.AddNewTransitionRule(firingStateMachine, fireState, fireState, fire_instant, logic['isFiring'].Out);
	AnimGraph.AddNewTransitionRule(firingStateMachine, fireState, fire_dummyState, fire_instant, logic['hasEndedFire'].Out);

	--replacement state machine transtions
	AnimGraph.AddNewTransitionRule(replacementStateMachine, replacement_dummyState, put_awayState, replacement_default_transition, control_parameter['put_away'].Out);
	AnimGraph.AddNewTransitionRule(replacementStateMachine, replacement_dummyState, readyState, replacement_default_transition, control_parameter['ready'].Out);
	AnimGraph.AddNewTransitionRule(replacementStateMachine, readyState, replacement_dummyState, replacement_default_transition, logic['hasEndedReplacement_ready'].Out); 
	AnimGraph.AddNewTransitionRule(replacementStateMachine, put_awayState, replacement_dummyState, replacement_default_transition, logic['hasEndedReplacement_put_away'].Out); 
	AnimGraph.AddNewTransitionRule(replacementStateMachine, readyState, put_awayState, replacement_default_transition, control_parameter['put_away'].Out);
	AnimGraph.AddNewTransitionRule(replacementStateMachine, put_awayState, readyState, replacement_default_transition, control_parameter['ready'].Out); 
	
	--top level state machine transtions
	AnimGraph.AddNewTransitionRule(topLevelStateMachine, movingState, deadState, topLevelfast, logic['airSwim'].Out);
	AnimGraph.AddNewTransitionRule(topLevelStateMachine, fullbodyState, deadState, topLevelfast, logic['airSwim'].Out);
	AnimGraph.AddNewTransitionRule(topLevelStateMachine, movingState, fullbodyState, topLevelDefaultTransition, logic['fullBodyStateRequest'].Out);
	AnimGraph.AddNewTransitionRule(topLevelStateMachine, fullbodyState, movingState, topLevelDefaultTransition, logic['hasEndedFullBodyState'].Out);
	AnimGraph.AddNewTransitionRule(topLevelStateMachine, movingState, movingState, topLevelDefaultTransition, logic['fullBodyStateRequest'].Out);
	AnimGraph.AddNewTransitionRule(topLevelStateMachine, movingState, vehicleState, topLevelDefaultTransition, logic ['push_Vehicle_set'].Out);
	AnimGraph.AddNewTransitionRule(topLevelStateMachine, vehicleState, movingState, topLevelDefaultTransition, logic['hasEndedVehicle'].Out);
	AnimGraph.AddNewTransitionRule(topLevelStateMachine, movingState, braceState, topLevelDefaultTransition, control_parameter['brace'].Out);
	AnimGraph.AddNewTransitionRule(topLevelStateMachine, braceState, movingState, topLevelDefaultTransition, logic['hasEndedHunkerExit'].Out);
	AnimGraph.AddNewTransitionRule(topLevelStateMachine, braceState, fullbodyState, topLevelDefaultTransition, logic['fullBodyStateRequest'].Out);
	AnimGraph.AddNewTransitionRule(topLevelStateMachine, braceState, deadState, topLevelfast, logic['airSwim'].Out);
	AnimGraph.AddNewTransitionRule(topLevelStateMachine, fullbodyState, braceState, topLevelDefaultTransition, control_parameter['brace'].Out);


	--fullbody state machine transtions
	AnimGraph.AddNewTransitionRule(fullbodyStateMachine, evadeState, fullBodyPingState, fullBodyInstant, logic['isFullBodyPing'].Out);
	AnimGraph.AddNewTransitionRule(fullbodyStateMachine, diveState, fullBodyPingState, fullBodyInstant, logic['isFullBodyPing'].Out);
	AnimGraph.AddNewTransitionRule(fullbodyStateMachine, customAnimationState, fullBodyPingState, fullBodyInstant, logic['isFullBodyPing'].Out);
	AnimGraph.AddNewTransitionRule(fullbodyStateMachine, hardStopState, fullBodyPingState, fullBodyInstant, logic['isFullBodyPing'].Out);
	AnimGraph.AddNewTransitionRule(fullbodyStateMachine, fullBodyPingState, fullBodyPingState, fullBodyInstant, control_parameter['resetFullBodyPing'].Out);

	AnimGraph.AddNewTransitionRule(fullbodyStateMachine, customAnimationState, customAnimationState, fullBodyInstant, control_parameter['resetCustomAnimation'].Out);

	AnimGraph.AddDefaultStateRule(fullbodyStateMachine, evadeState, control_parameter['evade'].Out);
	AnimGraph.AddDefaultStateRule(fullbodyStateMachine, diveState, control_parameter['dive'].Out);
	AnimGraph.AddDefaultStateRule(fullbodyStateMachine, hardStopState, control_parameter['hard_stop'].Out);
	AnimGraph.AddDefaultStateRule(fullbodyStateMachine, fullBodyPingState, logic['isFullBodyPing'].Out);
	AnimGraph.AddDefaultStateRule(fullbodyStateMachine, customAnimationState, control_parameter['custom_animation_start'].Out);

	--brace state machine transitions
	AnimGraph.AddDefaultStateRule(braceStateMachine, hunkerEnterState, control_parameter['brace'].Out);
	AnimGraph.AddNewTransitionRule(braceStateMachine, hunkerEnterState, hunkerLoopState, braceDefault, logic['hasEndedHunkerEnter'].Out);
	AnimGraph.AddNewTransitionRule(braceStateMachine, hunkerLoopState, hunkerExitState, braceDefault, logic['isNOT_brace'].Out);

	--dead state machine transtions
	AnimGraph.AddNewTransitionRule(airborneDeadStateMachine, airborneDeadState, landingDeadState, dead_transition, control_parameter['ground'].Out);
	AnimGraph.AddNewTransitionRule(airborneDeadStateMachine, landingDeadState, deadDummyState, dead_transition, logic['hasEndedFullBodyState'].Out);

	--set Up state machnine defaults states
	AnimGraph.SetFallbackDefaultState(topLevelStateMachine, movingState);
	AnimGraph.SetFallbackDefaultState(firingStateMachine, fire_dummyState);
	AnimGraph.SetFallbackDefaultState(airborneDeadStateMachine, airborneDeadState);
	AnimGraph.SetFallbackDefaultState(fullbodyStateMachine, fullBodyPingState);
	AnimGraph.SetFallbackDefaultState(replacementStateMachine, replacement_dummyState);

	----------------------------------HOOK UP LAYER AND LAYER SETTINGS--------------------------------------------------------------------------

	local ikNode = AnimGraph.CreateIKNode(0, 1, 0.1, true, true);
	NG.CreateLink(anims['aim'].Out, ikNode.Pose);
	-- local bone_mask = AnimGraph.CreateBoneMask('upper_body_only')
	-- NG.CreateLink(replacementStateMachine.Out, bone_mask.Pose);
	
	NG.CreateLink(movingStateMachine.Out, final_layer.Base);
	
	NG.CreateLink(replacementStateMachine.Out, final_layer.Pose);
	NG.CreateLink(firingStateMachine.Out, final_layer.Pose);
	NG.CreateLink(prefire_tell_state_machine.Out,final_layer.Pose);
	NG.CreateLink(ikNode.Out, final_layer.Pose);
	NG.CreateLink(anims['sping'].Out, final_layer.Pose);
	NG.CreateLink(anims['banking'].Out, final_layer.Pose);
	
	local firingWeight = AnimGraph.CreateConstantFloat(1.0);
	local aimingWeight = AnimGraph.CreateConstantFloat(1.0);
	local s_pingWeight = AnimGraph.CreateFloatControlParameter('sping_weight');
	local bankingWeight = AnimGraph.CreateConstantFloat(1.0);
	local replacementWeight = AnimGraph.CreateConstantFloat(1.0); 
	local prefireWeight = AnimGraph.CreateConstantFloat(1.0);

	AnimGraph.AddLayerNodeInputPose(final_layer, 0, replacementWeight.Out, 2);	
	AnimGraph.AddLayerNodeInputPose(final_layer, 1, firingWeight.Out, 1);
	AnimGraph.AddLayerNodeInputPose(final_layer, 2, prefireWeight.Out, 1);
	AnimGraph.AddLayerNodeInputPose(final_layer, 3, aimingWeight.Out, 1);
	AnimGraph.AddLayerNodeInputPose(final_layer, 4, s_pingWeight.Out, 1);
	AnimGraph.AddLayerNodeInputPose(final_layer, 5, bankingWeight.Out, 1);

	---------------------------------HOOK UP STATE MACHINE TO FINAL NODE--------------------------------------------------------------

	local final = AnimGraph.GetFinalPose();
	NG.CreateLink(topLevelStateMachine.Out, final.In);

	------------------------------------------------- ANIM SET LOGIC ---------------------------------------------------

	local animSetStrings = {}
	animSetStrings['rifle'] = AnimGraph.CreateConstantString("rifle");
	animSetStrings['pistol'] = AnimGraph.CreateConstantString("pistol");
	animSetStrings['missile'] = AnimGraph.CreateConstantString("missile");
	animSetStrings['sword'] = AnimGraph.CreateConstantString("sword");
	animSetStrings['unarmed'] = AnimGraph.CreateConstantString("unarmed");
	animSetStrings['hammer'] = AnimGraph.CreateConstantString("hammer");
	animSetStrings['turret'] = AnimGraph.CreateConstantString("turret");

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

	animSetStrings['ghost_d'] = AnimGraph.CreateConstantString("ghost_d");
	animSetStrings['ghost_b_d_r'] = AnimGraph.CreateConstantString("ghost_b_d_r");
	animSetStrings['ghost_b_d_b'] = AnimGraph.CreateConstantString("ghost_b_d_b");
	animSetStrings['ghost_b_d_l'] = AnimGraph.CreateConstantString("ghost_b_d_l");
	animSetStrings['ghost_b_b'] = AnimGraph.CreateConstantString("ghost_b_b");


	local weaponClassName = AnimGraph.CreateSwitchOnString();
	NG.AddSwitchOnStringOption(weaponClassName, "rifle", animSetStrings['rifle']);
	NG.AddSwitchOnStringOption(weaponClassName, "pistol", animSetStrings['pistol']);
	NG.AddSwitchOnStringOption(weaponClassName, "missile", animSetStrings['missile']);
	NG.AddSwitchOnStringOption(weaponClassName, "sword", animSetStrings['sword']);
	NG.AddSwitchOnStringOption(weaponClassName, "unarmed", animSetStrings['unarmed']);
	NG.AddSwitchOnStringOption(weaponClassName, "hammer", animSetStrings['hammer']);
	NG.AddSwitchOnStringOption(weaponClassName, "turret", animSetStrings['turret']);

	local weaponClassNameCP = AnimGraph.CreateStringControlParameter("weapon_class");
	NG.CreateLink(weaponClassNameCP.Out, weaponClassName.Selection);

	AnimGraph.AddPushAnimSetEntry(weaponClassName);

	local crouchWeaponClassName = AnimGraph.CreateAnimSetNameConcatenate();
	AnimGraph.AddAnimSetNameSubstring(crouchWeaponClassName, animSetStrings['crouch_']);
	AnimGraph.AddAnimSetNameSubstring(crouchWeaponClassName, weaponClassName);
	AnimGraph.AddConditionalPushAnimSetEntry(control_parameter['crouch'], crouchWeaponClassName);
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
	AnimGraph.AddAnimSetNameSubstring(pingAnimSetName, weaponClassName);
	AnimGraph.AddAnimSetNameSubstring(pingAnimSetName, animSetStrings['_']);
	AnimGraph.AddAnimSetNameSubstring(pingAnimSetName, pingTypeName);
	AnimGraph.AddAnimSetNameSubstring(pingAnimSetName, pingDirectionName);

	AnimGraph.AddConditionalPushAnimSetEntry(control_parameter['ping'], pingAnimSetName);

	local vehicle_seat_NameCP = AnimGraph.CreateStringControlParameter("vehicle_seat");
	
	AnimGraph.AddConditionalPushAnimSetEntry(logic['push_Vehicle_set'], vehicle_seat_NameCP);

	local s_pingDamageRegion = AnimGraph.CreateSwitchOnInteger();
	NG.AddSwitchOnIntegerOption(s_pingDamageRegion, 0, animSetStrings['gut']);
	NG.AddSwitchOnIntegerOption(s_pingDamageRegion, 1, animSetStrings['chest']);
	NG.AddSwitchOnIntegerOption(s_pingDamageRegion, 2, animSetStrings['head']);
	NG.AddSwitchOnIntegerOption(s_pingDamageRegion, 3, animSetStrings['left_shoulder']);
	NG.AddSwitchOnIntegerOption(s_pingDamageRegion, 4, animSetStrings['left_arm']);
	NG.AddSwitchOnIntegerOption(s_pingDamageRegion, 5, animSetStrings['left_leg']);
	NG.AddSwitchOnIntegerOption(s_pingDamageRegion, 6, animSetStrings['left_foot']);
	NG.AddSwitchOnIntegerOption(s_pingDamageRegion, 7, animSetStrings['right_shoulder']);
	NG.AddSwitchOnIntegerOption(s_pingDamageRegion, 8, animSetStrings['right_arm']);
	NG.AddSwitchOnIntegerOption(s_pingDamageRegion, 9, animSetStrings['right_leg']);
	NG.AddSwitchOnIntegerOption(s_pingDamageRegion, 10, animSetStrings['right_foot']);

	NG.CreateLink(control_parameter['s_ping_damage_part'].Out, s_pingDamageRegion.Selection);
	
	local s_pingAnimSetName = AnimGraph.CreateAnimSetNameConcatenate();
	AnimGraph.AddAnimSetNameSubstring(s_pingAnimSetName, weaponClassName);
	AnimGraph.AddAnimSetNameSubstring(s_pingAnimSetName, animSetStrings['_']);
	AnimGraph.AddAnimSetNameSubstring(s_pingAnimSetName, animSetStrings['s_ping_']);
	AnimGraph.AddAnimSetNameSubstring(s_pingAnimSetName, s_pingDamageRegion);
	
	AnimGraph.AddPushAnimSetEntry(s_pingAnimSetName);

end

function prefire_tell_state_machine()

	local anims = {}
	local logic = {}

	--Init animations 
	anims["prefireLoop"] = AnimGraph.CreateAnimation("prefire_loop", true,1,1);
	anims["prefireEnter"] = AnimGraph.CreateAnimationWithGroupName("prefire_enter",false,1,"prefire_enter",1);
	anims["prefireExit"] = AnimGraph.CreateAnimationWithGroupName("prefire_exit", false,1,"prefire_exit",1);
	--anims["prefireStart"] = AnimGraph.CreateAnimation("prefire_in", false, 1, 1);
	--anims["prefireExit"] = AnimGraph.CreateAnimation("prefire_exit",false,1,1);
	anims['dummy_pose'] = global_dummy_pose();

	--Init paramenters
	logic["preparingToFire"] = preparingToFire();
	logic["isNotPrefireOrIsFiring"] = isNotPrefireOrIsFiring();
	logic["isPrefireOrIsFiring"] = isPrefireOrIsFiring();
	logic["hasEnded"] = AnimGraph.CreateEndOfAnimationWithGroupName(0,"prefire_enter");
	logic["prefireExitEnded"] = AnimGraph.CreateEndOfAnimationWithGroupName(0,"prefire_exit");
	logic["canPrefireEnter"] = canPrefireEnter();

	--Declare statemachine 
	local prefireTellSM = AnimGraph.CreateStateMachine();

	--Init states
	local prefireStartState = AnimGraph.AddNewState(prefireTellSM, anims["prefireEnter"].Out,'PREFIREENTER');
	local prefireLoopState = AnimGraph.AddNewState(prefireTellSM, anims["prefireLoop"].Out, "PREFIRELOOP") ;
	local prefireCompleteState = AnimGraph.AddNewState(prefireTellSM,anims["prefireExit"].Out,"PREFIREEXIT");
	local dummyState = AnimGraph.AddNewState(prefireTellSM, anims["dummy_pose"].Out,"DUMMYPOSE");

	--Set default state
	AnimGraph.SetFallbackDefaultState(prefireTellSM, dummyState);

	--Declare transition blend	
	local transitionBlend = CreateDefaultTransitionBlendGraph();

	local fastTransition = AnimGraph.AddNewTransitionBlend(prefireTellSM, transitionBlend.Out, .125);
	local slowTransition = AnimGraph.AddNewTransitionBlend(prefireTellSM, transitionBlend.Out, .25);

	-- Create and initialize transition

	--Dummy to enter
	AnimGraph.AddNewTransitionRule(prefireTellSM,dummyState,prefireStartState,fastTransition,logic["canPrefireEnter"].Out);
	--Complete to dummy
	AnimGraph.AddNewTransitionRule(prefireTellSM,prefireCompleteState, dummyState, fastTransition, logic["prefireExitEnded"].Out);

	--Prefire start to prefire loop
	AnimGraph.AddNewTransitionRule(prefireTellSM,prefireStartState,prefireLoopState,fastTransition,logic["hasEnded"].Out);
	--Fire to Prefire complete
	AnimGraph.AddNewTransitionRule(prefireTellSM, prefireLoopState, prefireCompleteState, fastTransition, logic["isNotPrefireOrIsFiring"].Out);
	--Prefire complete to prefire start
	AnimGraph.AddNewTransitionRule(prefireTellSM, prefireCompleteState, prefireStartState, fastTransition, logic["preparingToFire"].Out);

	return prefireTellSM;

end

------------------------------------ Grunt Graph ------------------------------------------

function grunt_animation_graph()

	local anims = {};
	local logic = {};

	anims['aim'] = aim_state_machine();

	local control_parameter = {};
	control_parameter['ping'] = control_ping();
	control_parameter['dead'] = AnimGraph.CreateStringControlParameter("dead");
	control_parameter['precombat_point_activity'] = AnimGraph.CreateBoolControlParameter("precombat_point_activity");
	
	--vehicle stuffs
	logic['hasEndedVehicle'] = is_exiting_vehicle()
	logic ['push_Vehicle_set'] = is_vehicle()

	-- fullbody state logic
	logic['fullBodyStateRequest'] = fullBodyStateRequest()
	logic['hasEndedFullBodyState'] = hasEndedFullBodyState()
	logic['isFullBodyPing'] = is_full_body_ping();

	--create default transition blend logic
	local transitionBlend = CreateDefaultTransitionBlendGraph();

	--------------------------------------------------------------------------------------------
	--State machines
	local topLevelStateMachine = AnimGraph.CreateStateMachine();
	local moveStateMachine = move_state_machine();
	local firingStateMachine = fire_state_machine();
	local vehicleStateMachine = vehicle_state_machine();
	local fullbodyStateMachine = fullbody_state_machine();
	local deadStateMachine = dead_state_machine();
	--------------------------------------------------------------------------------------------
	--Top level transition
	local topLevelDefaultTransition = AnimGraph.AddNewTransitionBlend(topLevelStateMachine, transitionBlend.Out, .25);
	local topLevelfast = AnimGraph.AddNewTransitionBlend(topLevelStateMachine, transitionBlend.Out, .125);
	local topLevelDefaultTransitionInstant = AnimGraph.AddNewTransitionBlend(topLevelStateMachine, transitionBlend.Out, 0.00);
	----------------------------------- Layer Setup -------------------------------------

	local ikNode = AnimGraph.CreateIKNode(0, 1, 0.1, true, true);
	NG.CreateLink(anims['aim'].Out, ikNode.Pose);

	--Create Layer
	local final_layer = AnimGraph.CreateLayer();

	--Top level state machine states
	local movingState = AnimGraph.AddNewState(topLevelStateMachine, final_layer.Out,'MOVING');
	local vehicleState = AnimGraph.AddNewState(topLevelStateMachine, vehicleStateMachine.Out,'VEHICLE');
	local fullbodyState = AnimGraph.AddNewState(topLevelStateMachine, fullbodyStateMachine.Out,'FULLBODY');
	local deadState = AnimGraph.AddNewState(topLevelStateMachine, deadStateMachine.Out, 'DEADSTATE');

	--Top level state transitions
	AnimGraph.AddNewTransitionRule(topLevelStateMachine, movingState, vehicleState, topLevelDefaultTransition, logic ['push_Vehicle_set'].Out);
	AnimGraph.AddNewTransitionRule(topLevelStateMachine, vehicleState, movingState, topLevelDefaultTransition, logic['hasEndedVehicle'].Out);

	AnimGraph.AddNewTransitionRule(topLevelStateMachine, movingState, fullbodyState, topLevelDefaultTransition, logic['fullBodyStateRequest'].Out);
	AnimGraph.AddNewTransitionRule(topLevelStateMachine, fullbodyState, movingState, topLevelDefaultTransition, logic['hasEndedFullBodyState'].Out);

	--transition to dead state
	AnimGraph.AddNewTransitionRule(topLevelStateMachine, fullbodyState,deadState,topLevelDefaultTransition, control_parameter['dead'].Out);
	AnimGraph.AddNewTransitionRule(topLevelStateMachine, movingState, deadState, topLevelDefaultTransition, control_parameter['dead'].Out);


	--Weights 
	local firingWeight = AnimGraph.CreateConstantFloat(1.0);
	local aimingWeight = AnimGraph.CreateConstantFloat(1.0);

	--Create link layer
	NG.CreateLink(moveStateMachine.Out, final_layer.Base);
	NG.CreateLink(firingStateMachine.Out, final_layer.Pose);
	NG.CreateLink(aim_state_machine().Out, final_layer.Pose);

	--Input link
	AnimGraph.AddLayerNodeInputPose(final_layer, 0, firingWeight.Out, 1);
	AnimGraph.AddLayerNodeInputPose(final_layer, 1, aimingWeight.Out, 1);
	
	--Set default transition
	AnimGraph.SetFallbackDefaultState(topLevelStateMachine, movingState);

	--Final pose
	local final = AnimGraph.GetFinalPose();
	NG.CreateLink(topLevelStateMachine.Out, final.In);

	----------Push anim sets-----------

	local weaponClassName = weapon_class_name();
	local pingSetName = ping_set_name();

	push_vehicle_set();
	AnimGraph.AddPushAnimSetEntry(weaponClassName);
	AnimGraph.AddConditionalPushAnimSetEntry(control_parameter['ping'],pingSetName);
end

------------------------------------ Brute Graph ------------------------------------------


function brute_animation_graph()

	local anims = {};
	local logic = {};

	anims['aim'] = aim_state_machine();

	local control_parameter = {};
	control_parameter['ping'] = control_ping();
	control_parameter['dead'] = AnimGraph.CreateStringControlParameter("dead");
	
	--vehicle stuffs
	logic['hasEndedVehicle'] = is_exiting_vehicle()
	logic ['push_Vehicle_set'] = is_vehicle()

	-- fullbody state logic
	logic['fullBodyStateRequest'] = fullBodyStateRequest()
	logic['hasEndedFullBodyState'] = hasEndedFullBodyState()
	logic['isFullBodyPing'] = is_full_body_ping();

	--create default transition blend logic
	local transitionBlend = CreateDefaultTransitionBlendGraph();

	--------------------------------------------------------------------------------------------
	--State machines
	local topLevelStateMachine = AnimGraph.CreateStateMachine();
	local moveStateMachine = move_state_machine();
	local firingStateMachine = fire_state_machine();
	local vehicleStateMachine = vehicle_state_machine();
	local fullbodyStateMachine = fullbody_state_machine();
	local deadStateMachine = dead_state_machine();
	--------------------------------------------------------------------------------------------
	--Top level transition
	local topLevelDefaultTransition = AnimGraph.AddNewTransitionBlend(topLevelStateMachine, transitionBlend.Out, .25);
	local topLevelfast = AnimGraph.AddNewTransitionBlend(topLevelStateMachine, transitionBlend.Out, .125);
	local topLevelDefaultTransitionInstant = AnimGraph.AddNewTransitionBlend(topLevelStateMachine, transitionBlend.Out, 0.00);
	----------------------------------- Layer Setup -------------------------------------

	local ikNode = AnimGraph.CreateIKNode(0, 1, 0.1, true, true);
	NG.CreateLink(anims['aim'].Out, ikNode.Pose);

	--Create Layer
	local final_layer = AnimGraph.CreateLayer();

	--Top level state machine states
	local movingState = AnimGraph.AddNewState(topLevelStateMachine, final_layer.Out,'MOVING');
	local vehicleState = AnimGraph.AddNewState(topLevelStateMachine, vehicleStateMachine.Out,'VEHICLE');
	local fullbodyState = AnimGraph.AddNewState(topLevelStateMachine, fullbodyStateMachine.Out,'FULLBODY');
	local deadState = AnimGraph.AddNewState(topLevelStateMachine, deadStateMachine.Out, 'DEADSTATE');

	--Top level state transitions
	AnimGraph.AddNewTransitionRule(topLevelStateMachine, movingState, vehicleState, topLevelDefaultTransition, logic ['push_Vehicle_set'].Out);
	AnimGraph.AddNewTransitionRule(topLevelStateMachine, vehicleState, movingState, topLevelDefaultTransition, logic['hasEndedVehicle'].Out);

	AnimGraph.AddNewTransitionRule(topLevelStateMachine, movingState, fullbodyState, topLevelDefaultTransition, logic['fullBodyStateRequest'].Out);
	AnimGraph.AddNewTransitionRule(topLevelStateMachine, fullbodyState, movingState, topLevelDefaultTransition, logic['hasEndedFullBodyState'].Out);

	--transition to dead state
	AnimGraph.AddNewTransitionRule(topLevelStateMachine, fullbodyState,deadState,topLevelDefaultTransition, control_parameter['dead'].Out);
	AnimGraph.AddNewTransitionRule(topLevelStateMachine, movingState, deadState, topLevelDefaultTransition, control_parameter['dead'].Out);


	--Weights 
	local firingWeight = AnimGraph.CreateConstantFloat(1.0);
	local aimingWeight = AnimGraph.CreateConstantFloat(1.0);

	--Create link layer
	NG.CreateLink(moveStateMachine.Out, final_layer.Base);
	NG.CreateLink(firingStateMachine.Out, final_layer.Pose);
	--NG.CreateLink(aim_state_machine().Out, final_layer.Pose);

	--Input link
	AnimGraph.AddLayerNodeInputPose(final_layer, 0, firingWeight.Out, 1);
	AnimGraph.AddLayerNodeInputPose(final_layer, 1, aimingWeight.Out, 1);
	
	--Set default transition
	AnimGraph.SetFallbackDefaultState(topLevelStateMachine, movingState);

	--Final pose
	local final = AnimGraph.GetFinalPose();
	NG.CreateLink(topLevelStateMachine.Out, final.In);

	----------Push anim sets-----------

	local weaponClassName = weapon_class_name();
	local pingSetName = ping_set_name();

	push_vehicle_set();
	AnimGraph.AddPushAnimSetEntry(weaponClassName);
	AnimGraph.AddConditionalPushAnimSetEntry(control_parameter['ping'],pingSetName);


	--local deadAnimSetName = AnimGraph.CreateConstantString("any_s_kill_front");
	--AnimGraph.AddConditionalPushAnimSetEntry(control_parameter['ping'],deadAnimSetName);
end

function brute_idle_state_machine()
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

	return anims["idle"];
end

function fullbody_state_machine()

	local anims = {}
	local logic = {}

	local control_parameter = {}

	--fullbody state animation sources
	anims['evade'] = evade();
	anims['dive'] = dive();
	anims['custom_animation'] = anim_graph_custom_animation();
	anims['hunker_enter'] = hunker_enter();
	anims['hunker_loop'] = hunker_loop();
	anims['hunker_exit'] = hunker_exit();

	-- damage response animation sources
	anims['fullbody_ping'] = AnimGraph.CreateAnimationWithGroupName("gut", false, 1, "fullbody_ping", 1.0); --ping();
	AnimGraph.ToggleRootMotionOn(anims['fullbody_ping']);

	--control parameters used for state transition logic
	control_parameter['evade'] = control_evade()
	control_parameter['dive'] = control_dive()
	control_parameter['resetFullBodyPing'] = control_reset_fullbody_ping();
	control_parameter['resetCustomAnimation'] = control_reset_custom_animation();
	control_parameter['custom_animation_start'] = control_custom_animation_start();
	control_parameter['leap_airborne'] = AnimGraph.CreateBoolControlParameter('leap_airborne');

	-- fullbody state logic
	-- fullbody state ending logic
	logic['isFullBodyPing'] = is_full_body_ping();

	logic['hasEndedHunkerEnter'] = hasEndedHunkerEnter()
	logic['hasEndedHunkerExit'] = hasEndedHunkerExit()

	--fullbody state logic
	--dead state ending logic
	logic['hasEndedDead'] = hasEndedDead()
	logic['airSwim'] = isInAirborneDead();
	--Create state machine
	local fullbodyStateMachine = AnimGraph.CreateStateMachine();

	-- full body states
	local diveState = AnimGraph.AddNewState(fullbodyStateMachine, anims["dive"].Out,'DIVE');
	local evadeState = AnimGraph.AddNewState(fullbodyStateMachine, anims["evade"].Out,'EVADE');
	local fullBodyPingState = AnimGraph.AddNewState(fullbodyStateMachine, anims['fullbody_ping'].Out, 'FULLBODY PING');
	local customAnimationState = AnimGraph.AddNewState(fullbodyStateMachine, anims["custom_animation"].Out,'CUSTOM ANIM');

	--Transition blends
	local transitionBlend = CreateDefaultTransitionBlendGraph();
	local fullBodyInstant = AnimGraph.AddNewTransitionBlend(fullbodyStateMachine, transitionBlend.Out, 0.0);
	local fullBodydefault = AnimGraph.AddNewTransitionBlend(fullbodyStateMachine, transitionBlend.Out, .125);

	--fullbody state machine transtions
	AnimGraph.AddNewTransitionRule(fullbodyStateMachine, evadeState, fullBodyPingState, fullBodyInstant, logic['isFullBodyPing'].Out);
	AnimGraph.AddNewTransitionRule(fullbodyStateMachine, diveState, fullBodyPingState, fullBodyInstant, logic['isFullBodyPing'].Out);
	AnimGraph.AddNewTransitionRule(fullbodyStateMachine, customAnimationState, fullBodyPingState, fullBodyInstant, logic['isFullBodyPing'].Out);
	AnimGraph.AddNewTransitionRule(fullbodyStateMachine, fullBodyPingState, fullBodyPingState, fullBodyInstant, control_parameter['resetFullBodyPing'].Out);

	AnimGraph.AddNewTransitionRule(fullbodyStateMachine, customAnimationState, customAnimationState, fullBodyInstant, control_parameter['resetCustomAnimation'].Out);
	
	AnimGraph.AddDefaultStateRule(fullbodyStateMachine, evadeState, control_parameter['evade'].Out);
	AnimGraph.AddDefaultStateRule(fullbodyStateMachine, diveState, control_parameter['dive'].Out);
	AnimGraph.AddDefaultStateRule(fullbodyStateMachine, fullBodyPingState, logic['isFullBodyPing'].Out);
	AnimGraph.AddDefaultStateRule(fullbodyStateMachine, customAnimationState, control_parameter['custom_animation_start'].Out);

	--set default state
	AnimGraph.SetFallbackDefaultState(fullbodyStateMachine, diveState);

	return fullbodyStateMachine;
end

function aim_state_machine()

	local aimScreen = AnimGraph.CreateAimScreen2D("aim_still_up");

	local aimYaw = AnimGraph.CreateObjectFunction("aim_yaw");
	local aimPitch = AnimGraph.CreateObjectFunction("aim_pitch");

	NG.CreateLink(aimYaw.Out, aimScreen.Yaw);
	NG.CreateLink(aimPitch.Out, aimScreen.Pitch);

	return aimScreen;
end

function move_state_machine()
	--create animation, logic and control parameter tables
	local anims = {}
	local logic = {}

	local control_parameter = {}
	
	--create default transition blend logic
	local transitionBlend = CreateDefaultTransitionBlendGraph();

	--movement state animation sources
	anims["idle"] = brute_idle_state_machine();
	anims["locomotion"] = brute_locomotion();
	anims['airborne'] = airborne_state_machine(); --AnimGraph.CreateAnimation("airborne_arc_center", false, 1.000000, 1.000000); --airborne();
	anims['land_soft'] = AnimGraph.CreateAnimationWithGroupName("land_soft_center", false,1,"land_soft",1); --land_soft();

	--movement state specific logic
	--enter state logic
	logic['isIdling'] = isInIdle()
	logic['isLocomoting'] = isInLocomotion()
	logic['hasEndedAirborne'] = can_land_soft() --hasEndedAirborne()
	logic['hasEndedLand_Soft'] = hasEndedLand_Soft()


	--aim layer animation source
	local aimPose = aim();

	--Create state machine
	local movingStateMachine = AnimGraph.CreateStateMachine();
	local fireStateMachine = fire_state_machine();

	control_parameter['airborne'] = control_airborne();

	-- Transition blends
	local defaultTransition = AnimGraph.AddNewTransitionBlend(movingStateMachine, transitionBlend.Out, .25);
	local fast = AnimGraph.AddNewTransitionBlend(movingStateMachine, transitionBlend.Out, .25);
	local instantish = AnimGraph.AddNewTransitionBlend(movingStateMachine, transitionBlend.Out, 0.00);

	--Init States
	local idleState = AnimGraph.AddNewState(movingStateMachine, anims["idle"].Out,'IDLE');
	local locomotionState = AnimGraph.AddNewState(movingStateMachine, anims["locomotion"].Out,'LOCOMOTE');
	local airborneState = AnimGraph.AddNewState(movingStateMachine, anims['airborne'].Out,'AIRBORNE');
	local land_softState = AnimGraph.AddNewState(movingStateMachine, anims['land_soft'].Out,'LAND SOFT');
	
	--moving state machine transtions
	AnimGraph.AddNewTransitionRule(movingStateMachine, locomotionState, idleState, defaultTransition, logic['isIdling'].Out);
	AnimGraph.AddNewTransitionRule(movingStateMachine, idleState, locomotionState, defaultTransition, logic['isLocomoting'].Out);
	AnimGraph.AddNewTransitionRule(movingStateMachine, locomotionState, airborneState, fast, control_parameter['airborne'].Out);
	AnimGraph.AddNewTransitionRule(movingStateMachine, airborneState, land_softState, instantish, logic['hasEndedAirborne'].Out);
	AnimGraph.AddNewTransitionRule(movingStateMachine, idleState, airborneState, fast, control_parameter['airborne'].Out);
	AnimGraph.AddNewTransitionRule(movingStateMachine, land_softState, airborneState, fast, control_parameter['airborne'].Out);
	AnimGraph.AddNewTransitionRule(movingStateMachine, land_softState, idleState, fast, logic['hasEndedLand_Soft'].Out);

	--Set default transition
	AnimGraph.SetFallbackDefaultState(movingStateMachine, idleState);
	
	return movingStateMachine;
end

function fire_state_machine()

	--create animation, logic and control parameter tables
	local anims = {}
	local logic = {}

	local control_parameter = {}
	
	--create default transition blend logic
	local transitionBlend = CreateDefaultTransitionBlendGraph();

	--fire state animation sources
	anims['fire'] = fire();
	anims['dummy_pose'] = global_dummy_pose();

	--firing state logic
	logic['isFiring'] = isFiring();
	logic['hasEndedFire'] = hasEndedFire();

	--Create state machine
	local firingStateMachine = AnimGraph.CreateStateMachine();

	--Firing States
	local fireState = AnimGraph.AddNewState(firingStateMachine, anims["fire"].Out,'FIRING');
	local fire_dummyState = AnimGraph.AddNewState(firingStateMachine, anims["dummy_pose"].Out,'FIRING DUMMY');

	--Init Transition blend
	local fire_instant = AnimGraph.AddNewTransitionBlend(firingStateMachine, transitionBlend.Out, 0);
	local fire_slowish = AnimGraph.AddNewTransitionBlend(firingStateMachine, transitionBlend.Out, 0.1);

	--Init Transition rules
	AnimGraph.AddNewTransitionRule(firingStateMachine, fire_dummyState, fireState, fire_slowish, logic['isFiring'].Out);
	AnimGraph.AddNewTransitionRule(firingStateMachine, fireState, fireState, fire_instant, logic['isFiring'].Out);
	AnimGraph.AddNewTransitionRule(firingStateMachine, fireState, fire_dummyState, fire_instant, logic['hasEndedFire'].Out);

	--Set default state
	AnimGraph.SetFallbackDefaultState(firingStateMachine, fire_dummyState);

	return firingStateMachine;
end

function dead_state_machine()
	local anim = {};
	
	anim['dead'] = AnimGraph.CreateAnimation("gut", false, 1.000000, 1.000000);

	return anim['dead'];
end

function airborne_state_machine()
	local anims = {};
	anims['airborne'] = AnimGraph.CreateAnimation("airborne_arc_center", false, 1.000000, 1.000000);
	anims['leap_airborne'] = AnimGraph.CreateAnimation("idle",false,1,1);
	

	local is_leap_airborne = AnimGraph.CreateBoolControlParameter("leap_airborne");
	local is_not_leap_airborne = AnimGraph.CreateBooleanInvert();
	NG.CreateLink(is_leap_airborne.Out, is_not_leap_airborne.In);

	local airborneStateMachine = AnimGraph.CreateStateMachine();
	
	local airborneState = AnimGraph.AddNewState(airborneStateMachine,anims['airborne'].Out,'AIRBORNE');
	local leapAirborneState = AnimGraph.AddNewState(airborneStateMachine,anims['leap_airborne'].Out,'LEAP AIRBORNE');

	AnimGraph.AddDefaultStateRule(airborneStateMachine, airborneState, is_not_leap_airborne.Out);
	AnimGraph.AddDefaultStateRule(airborneStateMachine, leapAirborneState,is_leap_airborne.Out);

	AnimGraph.SetFallbackDefaultState(airborneStateMachine, airborneState);

	return airborneStateMachine;
end

function can_land_soft()
	--end airborne control paramenter
	local hasEndedAirborne = AnimGraph.CreateBoolControlParameter("ground");
	
	--leap airborne control parameter
	local is_leap_airborne = AnimGraph.CreateBoolControlParameter("leap_airborne");
	local is_not_leap_airborne = AnimGraph.CreateBooleanInvert();
	NG.CreateLink(is_leap_airborne.Out, is_not_leap_airborne.In);

	local canLandSoft = AnimGraph.CreateBooleanLogic(NG.BoolOp.AND);
	NG.CreateLink(is_not_leap_airborne.Out,canLandSoft.MultiIn);
	NG.CreateLink(hasEndedAirborne.Out, canLandSoft.MultiIn);

	return canLandSoft;
end


------------ Anim Set Names ----------------

function push_vehicle_set()
	local logic = {};

	--vehicle stuffs
	logic['hasEndedVehicle'] = is_exiting_vehicle()
	logic ['push_Vehicle_set'] = is_vehicle()
	----------------push vehicle anim set----------
	local vehicle_seat_NameCP = AnimGraph.CreateStringControlParameter("vehicle_seat");
	AnimGraph.AddConditionalPushAnimSetEntry(logic['push_Vehicle_set'], vehicle_seat_NameCP);
end

function ping_set_name()
	local control_parameter = {};
	
	control_parameter['ping'] = control_ping();
	control_parameter['ping_type'] = control_ping_type();
	
	local weaponClassName = weapon_class_name();
	local _string = AnimGraph.CreateConstantString("_");
	local pingDirectionName = AnimGraph.CreateConstantString("front")

	local animSetStrings = {}

	animSetStrings['s_ping_'] = AnimGraph.CreateConstantString("s_ping_");
	animSetStrings['m_ping_'] = AnimGraph.CreateConstantString("m_ping_");
	animSetStrings['h_ping_'] = AnimGraph.CreateConstantString("h_ping_");
	animSetStrings['s_kill_'] = AnimGraph.CreateConstantString("s_kill_");
	animSetStrings['h_kill_'] = AnimGraph.CreateConstantString("h_kill_");

	--Get ping type
	local pingTypeName = AnimGraph.CreateSwitchOnInteger();
	NG.AddSwitchOnIntegerOption(pingTypeName, 2, animSetStrings['h_ping_']);
	NG.AddSwitchOnIntegerOption(pingTypeName, 3, animSetStrings['h_ping_']);
	NG.AddSwitchOnIntegerOption(pingTypeName, 4, animSetStrings['s_kill_']);
	NG.AddSwitchOnIntegerOption(pingTypeName, 5, animSetStrings['s_kill_']);
	-- NG.AddSwitchOnIntegerOption(pingTypeName, 6, animSetStrings['h_kill_']);
	NG.CreateLink(control_parameter['ping_type'].Out, pingTypeName.Selection);

	--Concatenate names
	local pingAnimSetName = AnimGraph.CreateAnimSetNameConcatenate();
	AnimGraph.AddAnimSetNameSubstring(pingAnimSetName, weaponClassName);
	AnimGraph.AddAnimSetNameSubstring(pingAnimSetName, _string);
	AnimGraph.AddAnimSetNameSubstring(pingAnimSetName, pingTypeName);
	AnimGraph.AddAnimSetNameSubstring(pingAnimSetName, pingDirectionName);

	return pingAnimSetName;
end

function weapon_class_name()
	-------------Push Weapon anim set-----------
	local weaponClassName = AnimGraph.CreateSwitchOnString();
	
	local animSetStrings = {}

	animSetStrings['rifle'] = AnimGraph.CreateConstantString("rifle");
	animSetStrings['pistol'] = AnimGraph.CreateConstantString("pistol");
	animSetStrings['missile'] = AnimGraph.CreateConstantString("missile");
	animSetStrings['sword'] = AnimGraph.CreateConstantString("sword");
	animSetStrings['unarmed'] = AnimGraph.CreateConstantString("unarmed");
	animSetStrings['hammer'] = AnimGraph.CreateConstantString("hammer");
	animSetStrings['turret'] = AnimGraph.CreateConstantString("turret");
	animSetStrings['berserk'] = AnimGraph.CreateConstantString("berserk");

	NG.AddSwitchOnStringOption(weaponClassName, "rifle", animSetStrings['rifle']);
	NG.AddSwitchOnStringOption(weaponClassName, "pistol", animSetStrings['pistol']);
	NG.AddSwitchOnStringOption(weaponClassName, "missile", animSetStrings['missile']);
	NG.AddSwitchOnStringOption(weaponClassName, "hammer", animSetStrings['hammer']);
	NG.AddSwitchOnStringOption(weaponClassName, "turret", animSetStrings['turret']);
	NG.AddSwitchOnStringOption(weaponClassName, "fist", animSetStrings["berserk"]);

	local weaponClassNameCP = AnimGraph.CreateStringControlParameter("weapon_class");
	NG.CreateLink(weaponClassNameCP.Out, weaponClassName.Selection);

	return weaponClassName;
end


