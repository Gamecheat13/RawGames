#using scripts\shared\ai\archetype_robot;
#using scripts\shared\ai\systems\ai_interface;

                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                    

#namespace RobotInterface;

function RegisterRobotInterfaceAttributes()
{
	/*
	 * Name: can_be_meleed
	 * Summary: Controls whether other AI will choose to melee the robot.
	 * Initial Value: true
	 * Attribute true: Normal behavior, robots will be meleed when close to their enemy.
	 * Attribute false: Forces other AI to shoot the robot instead of melee them at
	 *     close distances.
	 * Example: entity ai::set_behavior_attribute( "can_be_meleed", true );"
	 */
	ai::RegisterMatchedInterface(
		"robot",
		"can_be_meleed",
		true,
		array( true, false ) );

	/*
	 * Name: can_become_crawler
	 * Summary: Controls whether the robot can become a crawler robot.  This does not prevent a
	 *     robot from having their legs gibbed upon death.
	 * Initial Value: true
	 * Attribute true: Normal behavior, robot can become a crawler.
	 * Attribute false: Robots will not become a crawler.
	 * Example: entity ai::set_behavior_attribute( "can_become_crawler", false );"
	 */
	ai::RegisterMatchedInterface(
		"robot",
		"can_become_crawler",
		true,
		array( true, false ) );

	/*
	 * Name: can_become_rusher
	 * Summary: Controls whether the robot can become a rusher, even when told to become a rusher.
	 * Initial Value: true
	 * Attribute true: Normal behavior, robot can become a rusher.
	 * Attribute false: Robots will not become a rusher, even when told to become a rusher.
	 * Example: entity ai::set_behavior_attribute( "can_become_rusher", true );"
	 */
	ai::RegisterMatchedInterface(
		"robot",
		"can_become_rusher",
		true,
		array( true, false ) );
	
	/*
	 * Name: can_gib
	 * Summary: Controls whether the robot can gib at all.  This should not be turned off in normal gameplay and is needed for cybercom.
	 * Initial Value: true
	 * Attribute true: Normal behavior, robot can gib.
	 * Attribute false: Robots will not gib, unless gibbing is explicitly called on them.
	 * Example: entity ai::set_behavior_attribute( "can_gib", true );"
	 */
	ai::RegisterMatchedInterface(
		"robot",
		"can_gib",
		true,
		array( true, false ) );

	/*
	 * Name: can_melee
	 * Summary: Controls whether the robot is able to melee their enemies.  This only pertains
	 *     to normal shooting robots.
	 * Initial Value: true
	 * Attribute true: Normal behavior, robot will melee when close to their enemy.
	 * Attribute false: Forces a robot to shoot even when they are within melee distance.
	 * Example: entity ai::set_behavior_attribute( "can_melee", true );"
	 */
	ai::RegisterMatchedInterface(
		"robot",
		"can_melee",
		true,
		array( true, false ) );
	
	/*
	 * Name: can_initiateaivsaimelee
	 * Summary: Controls whether the robot AI are able to initiate synced melee with their enemies.
	 * Initial Value: true
	 * Attribute true: Normal behavior, will do synced melee when appropriate conditions are met.
	 * Attribute false: Will never initiate synced melee even if it is possible.
	 * Example: entity ai::set_behavior_attribute( "can_initiateaivsaimelee", true );"
	 */
	ai::RegisterMatchedInterface(
		"robot",
		"can_initiateaivsaimelee",
		true,
		array( true, false ) );

	/*
	 * Name: disablesprint
	 * Summary: Controls whether humans will use their sprint locomotion.
	 * Initial Value: false
	 * Attribute true : when set to true, AI's will not use sprint locomotion.
	 * Attribute false : AI will use sprint locomotion when applicable.
	 * Example: entity ai::set_behavior_attribute( "disablesprint", true );
	 */
	ai::RegisterMatchedInterface(
		"robot",
		"disablesprint",
		false,
		array( true, false ) );

	/*
	 * Name: escort_position
	 * Summary: If the robot is in the escort move_mode, this position is used to determine where
	 *     the robot should stay close to.
	 * Initial Value: undefined
	 * Attribute: Vector position.
	 * Example: entity ai::set_behavior_attribute( "escort_position", player.origin );"
	 */
	ai::RegisterVectorInterface(
		"robot",
		"escort_position" );

	/*
	 * Name: force_cover
	 * Summary: Controls whether robots will forcefully go to cover positions instead
	 *     of a mixture of cover and exposed positions.
	 * Initial Value: false
	 * Attribute true: Forces a robot to move to cover positions.
	 * Attribute false: Disables forcing cover positions.
	 * Example: entity ai::set_behavior_attribute( "force_cover", true );"
	 */
	ai::RegisterMatchedInterface(
		"robot",
		"force_cover",
		false,
		array( true, false ) );
	
	/*
	 * Name: force_crawler
	 * Summary: Converts a robot into a crawler, either by gibbing their legs immediately
	 *      or making their legs disappear.
	 * Initial Value: normal
	 * Attribute normal: A normal walking robot, crawlers cannot be turned back into normal
	 *      robots.
	 * Attribute gib_legs: Immediately gibs the legs of a robot creating a crawler.
	 * Attribute remove_legs: Makes the legs of the robot disappear, useful for spawning.
	 * Example: entity ai::set_behavior_attribute( "force_crawler", "remove_legs" );"
	 */
	ai::RegisterMatchedInterface(
		"robot",
		"force_crawler",
		"normal",
		array( "normal", "gib_legs", "remove_legs" ),
		&RobotSoldierServerUtils::robotForceCrawler );

	/*
	 * Name: move_mode
	 * Summary: Controls how robots choose to move to their goal position.
	 * Initial Value normal
	 * Attribute escort: Forces a robot to move toward their designated escort_position.
	 * Attribute guard: Randomly chooses positions to move to within the current goal radius.
	 * Attribute normal: Adheres to normal movement and combat.
	 * Attribute marching: Walks using a slow forward moving march. Marching robots can only
	 *     shoot targets that are facing in front of them.
	* Attribute rambo: Runs to goal position, allowed to shoot at enemies, but doesn't stop and
	 *     fight enemies.
	 * Attribute rusher: Moves toward the player instead of staying at cover or in the open.
	 * Attribute squadmember: Indicates that the robot belongs to a squad.
	 * Example: entity ai::set_behavior_attribute( "move_mode", "rambo" );"
	 */
	ai::RegisterMatchedInterface(
		"robot",
		"move_mode",
		"normal",
		array( "escort", "guard", "normal", "marching", "rambo", "rusher", "squadmember" ),
		&RobotSoldierServerUtils::robotMoveModeAttributeCallback );

	/*
	 * Name: phalanx
	 * Summary: Controls whether the robot is in a phalanx formation or not.
	 *     This value should be left to the robot_phalanx system to manipulate.
	 * Initial Value: false
	 * Attribute true: Robot is in a phalanx formation.
	 * Attribute false: Robot is not in a phalanx formation.
	 * Example: entity ai::set_behavior_attribute( "phalanx", true );"
	 */
	ai::RegisterMatchedInterface(
		"robot",
		"phalanx",
		false,
		array( true, false ) );

	/*
	 * Name: phalanx_force_stance
	 * Summary: Forces a robot in a phalanx formation to a specific stance when stationary.
	 *     This value should be left to the robot_phalanx system to manipulate.
	 * Initial Value: normal
	 * Attribute normal: Uses the default stance.
	 * Attribute stand: Forces the robot to stand.
	 * Attribute crouch: Forces the robot to crouch.
	 * Example: entity ai::set_behavior_attribute( "phalanx_force_stance", "stand" );"
	 */
	ai::RegisterMatchedInterface(
		"robot",
		"phalanx_force_stance",
		"normal",
		array( "normal", "stand", "crouch" ) );
	
	/*
	 * Name: robot_lights
	 * Summary: Enables or disable the lights attached to the robot.
	 * Initial Value: ROBOT_LIGHTS_ON
	 * Attribute ROBOT_LIGHTS_ON: Enable lights.
	 * Attribute ROBOT_LIGHTS_FLICKER: Enable flickering lights.
	 * Attribute ROBOT_LIGHTS_OFF: Disable lights.
	 * Attribute ROBOT_LIGHTS_DEATH: Play death fx.
	 * * Attribute ROBOT_LIGHTS_OFF: Enable hacked lights.
	 * Example: entity ai::set_behavior_attribute( "robot_lights", ROBOT_LIGHTS_ON );"
	 */
	ai::RegisterMatchedInterface(
		"robot",
		"robot_lights",
		0,
		array( 0, 1, 2, 3, 4 ),
		&RobotSoldierServerUtils::robotLights );
	
	/*
	 * Name: robot_mini_raps
	 * Summary: Equips a robot with a mini raps they can deploy like a grenade.
	 * Initial Value: false
	 * Attribute true: Gives a mini raps to the robot.
	 * Attribute false: Takes away the mini raps from the robot.
	 * Example: entity ai::set_behavior_attribute( "robot_mini_raps", true );"
	 */
	ai::RegisterMatchedInterface(
		"robot",
		"robot_mini_raps",
		false,
		array( true, false ),
		&RobotSoldierServerUtils::robotEquipMiniRaps );
	
	/*
	 * Name: rogue_allow_predestruct
	 * Summary: If true, allows robots forced into level_2 or level_3 to spawn with destructible pieces missing.
	 * Initial Value: true
	 * Attribute true: Spawns rogue controlled robot predestructed.
	 * Attribute false: Spawn rogue controlled robot without predestructing.
	 * Example: entity ai::set_behavior_attribute( "rogue_allow_predestruct", true );"
	 */
	ai::RegisterMatchedInterface(
		"robot",
		"rogue_allow_predestruct",
		true,
		array( true, false ) );
	
	/*
	 * Name: rogue_allow_pregib
	 * Summary: If true, allows robots forced into level_2 or level_3 to spawn with limbs missing.
	 * Initial Value: true
	 * Attribute true: Spawns rogue controlled robot pregibbed.
	 * Attribute false: Spawn rogue controlled robot without pregibbing.
	 * Example: entity ai::set_behavior_attribute( "rogue_allow_pregib", true );"
	 */
	ai::RegisterMatchedInterface(
		"robot",
		"rogue_allow_pregib",
		true,
		array( true, false ) );

	/*
	 * Name: rogue_control
	 * Summary: Controls whether or not a robot is rogue controlled.  Note that
	 *     setting a level lower than the current level has no effect and will be disregarded.
	 * Initial Value: level_0
	 * Attribute level_0: A normal robot, not rogue controlled.
	 * Attribute level_1: Swaps the robot to team three but still lets them shoot like a normal robot.
	 * Attribute forced_level_1: Immediately moves to level_1 without playing an animation.
	 * Attribute level_2: Swaps the robot to team three and makes them melee only.
	 * Attribute forced_level_2: Immediately moves to level_2 without playing an animation.
	 * Attribute level_3: Swaps the robot to team three, makes them melee only, and they explode when 
	 *     within reach of their enemy.
	 * Attribute forced_level_3: Immediately moves to level_3 without playing an animation.
	 * Example: entity ai::set_behavior_attribute( "rogue_control", "forced_level_1" );
	 */
	ai::RegisterMatchedInterface(
		"robot",
		"rogue_control",
		"level_0",
		array( "level_0", "level_1", "forced_level_1", "level_2", "forced_level_2", "level_3", "forced_level_3" ),
		&RobotSoldierServerUtils::rogueControlAttributeCallback );
	
	/*
	 * Name: rogue_control_force_goal
	 * Summary: Forces a rogue controlled robot that is in level_2 or level_3 to move to a position
	 *     if the robot is currently unable to path to the player.  Once the robot can path to the
	 *     player, this value will be ignored and reset to undefined.
	 * Initial Value: undefined
	 * Example: entity ai::set_behavior_attribute( "rogue_control_force_goal", (10, 100, 0) );
	 */
	ai::RegisterVectorInterface(
		"robot",
		"rogue_control_force_goal",
		undefined,
		&RobotSoldierServerUtils::rogueControlForceGoalAttributeCallback );
	
	/*
	 * Name: rogue_control_speed
	 * Summary: Controls how fast a rogue controlled robot moves at.
	 * Initial Value: sprint
	 * Attribute walk: Slow speed walk.
	 * Attribute run: Medium speed walk.
	 * Attribute sprint: Fast sprint.
	 * Example: entity ai::set_behavior_attribute( "rogue_control_speed", "walk" );"
	 */
	ai::RegisterMatchedInterface(
		"robot",
		"rogue_control_speed",
		"sprint",
		array( "walk", "run", "sprint" ),
		&RobotSoldierServerUtils::rogueControlSpeedAttributeCallback );
	
	/*
	 * Name: rogue_force_explosion
	 * Summary: Causes a level 3 robot to forcefully explode regardless of range to
	 *     their enemy.
	 * Initial Value: false
	 * Attribute true: Forces a level 3robot to explode.
	 * Attribute false: Level 3 robot will only explode within range of their enemy.
	 * Example: entity ai::set_behavior_attribute( "rogue_force_explosion", true );"
	 */
	ai::RegisterMatchedInterface(
		"robot",
		"rogue_force_explosion",
		false,
		array( true, false ) );
	
	/*
	 * Name: shutdown
	 * Summary: When set to true the robot will shutdown, as if they were hit
	 *     by an emp.
	 * Initial Value: false
	 * Attribute true: Forces a robot to shutdown.
	 * Attribute false: Returns the robot to normal.
	 * Example: entity ai::set_behavior_attribute( "shutdown", true );"
	 */
	ai::RegisterMatchedInterface(
		"robot",
		"shutdown",
		false,
		array( true, false ) );
	
	/*
	 * Name: sprint
	 * Summary: Controls whether robots will forcefully sprint while moving,
	 *     this prevents shooting while moving.
	 * Initial Value: false
	 * Attribute true: Forces a robot to sprint when moving.
	 * Attribute false: Disables forcing sprint.
	 * Example: entity ai::set_behavior_attribute( "sprint", true );"
	 */
	ai::RegisterMatchedInterface(
		"robot",
		"sprint",
		false,
		array( true, false ) );
	
	/*
	 * Name: supports_super_sprint
	 * Summary: Allows the robot to use super sprint.
	 *     NOTE: This is an MP only feature of robots and should not be used in other modes.
	 * Initial Value: false
	 * Attribute true: Allows the robot to super sprint.
	 * Attribute false: Disables the use of super sprint.
	 * Example: entity ai::set_behavior_attribute( "supports_super_sprint", true );"
	 */
	ai::RegisterMatchedInterface(
		"robot",
		"supports_super_sprint",
		false,
		array( true, false ) );
	
	/*
	 * Name: traversals
	 * Summary: Controls how robots handle traversals, either through animations
	 *     or procedurally calculating a trajectory.
	 * Initial Value: normal
	 * Attribute normal: Animated traverals, only normal AI traverals and custom traverals.
	 * Attribute procedural: Procedurally created trajectory, supports nearly any possible traveral.
	 * Example: entity ai::set_behavior_attribute( "traversals", "normal" );"
	 */
	ai::RegisterMatchedInterface(
		"robot",
		"traversals",
		"normal",
		array( "normal", "procedural" ),
		&RobotSoldierServerUtils::robotTraversalAttributeCallback );
}