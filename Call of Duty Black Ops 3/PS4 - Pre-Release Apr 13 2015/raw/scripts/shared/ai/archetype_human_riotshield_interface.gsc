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