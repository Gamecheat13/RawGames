#using scripts\zm\archetype_zod_companion;
#using scripts\shared\ai\systems\ai_interface;

#namespace ZodCompanionInterface;

function RegisterZodCompanionInterfaceAttributes()
{
	/*
	 * Name: sprint
	 * Summary: Controls whether zod_companions will forcefully sprint while moving,
	 *     this prevents shooting while moving.
	 * Initial Value: false
	 * Attribute true: Forces a zod_companion to sprint when moving.
	 * Attribute false: Disables forcing sprint.
	 * Example: entity ai::set_behavior_attribute( "sprint", true );"
	 */
	ai::RegisterMatchedInterface(
		"zod_companion",
		"sprint",
		false,
		array( true, false ) );
}