#using scripts\shared\ai\archetype_human_rpg;
#using scripts\shared\ai\systems\ai_interface;

#namespace HumanRpgInterface;

function RegisterHumanRpgInterfaceAttributes()
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
		"human_rpg",
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
		"human_rpg",
		"can_melee",
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
		"human_rpg",
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
		"human_rpg",
		"sprint",
		false,
		array( true, false ) );

	/*
	 * Name: patrol
	 * Summary: Controls whether humans will use their patrol walking
	 *     animation set.  Patrol walks are meant for non-combat situations.
	 *     NOTE: This is only supported for male human characters.
	 * Initial Value: false
	 * Attribute true : Non combat movement uses patrol walk animations.
	 * Attribute false : Non combat movement uses default animations.
	 * Example: entity ai::set_behavior_attribute( "patrol", true );"
	 */
	ai::RegisterMatchedInterface(
		"human_rpg",
		"patrol",
		false,
		array( true, false ) );
}