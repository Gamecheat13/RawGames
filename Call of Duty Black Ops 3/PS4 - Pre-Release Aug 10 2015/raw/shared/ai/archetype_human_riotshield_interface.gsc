#using scripts\shared\ai\archetype_human_riotshield;
#using scripts\shared\ai\systems\ai_interface;

#namespace HumanRiotshieldInterface;

function RegisterHumanRiotshieldInterfaceAttributes()
{
	/*
	 * Name: can_be_meleed
	 * Summary: Controls whether other AI will choose to melee the human.
	 * Initial Value: true
	 * Attribute true: Normal behavior, humans will be meleed when close to their enemy.
	 * Attribute false: Forces other AI to shoot the AI instead of melee them at
	 *     close distances.
	 * Example: entity ai::set_behavior_attribute( "can_be_meleed", true );"
	 */
	ai::RegisterMatchedInterface(
		"human_riotshield",
		"can_be_meleed",
		true,
		array( true, false ) );

	/*
	 * Name: can_melee
	 * Summary: Controls whether the human AI is able to melee their enemies.
	 * Initial Value: true
	 * Attribute true: Normal behavior, will melee when close to their enemy.
	 * Attribute false: Forced to shoot even when they are within melee distance.
	 * Example: entity ai::set_behavior_attribute( "can_melee", true );"
	 */
	ai::RegisterMatchedInterface(
		"human_riotshield",
		"can_melee",
		true,
		array( true, false ) );
	
			/*
	 * Name: can_initiateaivsaimelee
	 * Summary: Controls whether the human AI are able to initiate synced melee with their enemies.
	 * Initial Value: true
	 * Attribute true: Normal behavior, will do synced melee when appropriate conditions are met.
	 * Attribute false: Will never initiate synced melee even if it is possible.
	 * Example: entity ai::set_behavior_attribute( "can_initiateaivsaimelee", true );"
	 */
	ai::RegisterMatchedInterface(
		"human_riotshield",
		"can_initiateaivsaimelee",
		true,
		array( true, false ) );

	/*
	 * Name: coverIdleOnly
	 * Summary: Forces humans to only choose the idle behavior when at cover.
	 * Initial Value: false
	 * Attribute true : Forces a human to only idle at cover.
	 * Attribute false : Disables forcing idle.
	 * Example: entity ai::set_behavior_attribute( "coverIdleOnly", true );"
	 */
	ai::RegisterMatchedInterface(
		"human_riotshield",
		"coverIdleOnly",
		false,
		array( true, false ) );

	/*
	 * Name: phalanx
	 * Summary: Controls whether the riotshield is in a phalanx formation or not.
	 *     This value should be left to the phalanx system to manipulate.
	 * Initial Value: false
	 * Attribute true: Riotshield is in a phalanx formation.
	 * Attribute false: Riotshield is not in a phalanx formation.
	 * Example: entity ai::set_behavior_attribute( "phalanx", true );"
	 */
	ai::RegisterMatchedInterface(
		"human_riotshield",
		"phalanx",
		false,
		array( true, false ) );
	
	/*
	 * Name: phalanx_force_stance
	 * Summary: Forces a riotshield in a phalanx formation to a specific stance when stationary.
	 *     This value should be left to the phalanx system to manipulate.
	 * Initial Value: normal
	 * Attribute normal: Uses the default stance.
	 * Attribute stand: Forces the riotshield to stand.
	 * Attribute crouch: Forces the riotshield to crouch.
	 * Example: entity ai::set_behavior_attribute( "phalanx_force_stance", "stand" );"
	 */
	ai::RegisterMatchedInterface(
		"human_riotshield",
		"phalanx_force_stance",
		"normal",
		array( "normal", "stand", "crouch" ) );

	/*
	 * Name: sprint
	 * Summary: Controls whether humans will forcefully sprint while moving,
	 *     this prevents shooting while moving.
	 * Initial Value: false
	 * Attribute true : Forces a human to sprint when moving.
	 * Attribute false : Disables forcing sprint.
	 * Example: entity ai::set_behavior_attribute( "sprint", true );"
	 */
	ai::RegisterMatchedInterface(
		"human_riotshield",
		"sprint",
		false,
		array( true, false ) );

	/*
	 * Name: attack_mode
	 * Summary: Controls how human riot shields attack their enemies.
	 * Initial Value: normal
	 * Attribute normal: Adheres to normal combat.
	 * Attribute unarmed: Can't shoot at enemies, try to melee enemies within goal.
	 * Example: entity ai::set_behavior_attribute( "attack_mode", "unarmed" );"
	 */
	ai::RegisterMatchedInterface(
		"human_riotshield",
		"attack_mode",
		"normal",
		array( "normal", "unarmed" ) );
}