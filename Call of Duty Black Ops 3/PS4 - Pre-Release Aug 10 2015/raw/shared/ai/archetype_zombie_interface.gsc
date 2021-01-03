#using scripts\shared\ai\zombie;
#using scripts\shared\ai\systems\ai_interface;

#namespace ZombieInterface;

function RegisterZombieInterfaceAttributes()
{
	/*
	 * Name: can_juke
	 * Summary: Controls whether the zombie can juke.
	 * Initial Value: true
	 * Attribute true: Normal behavior, zombie will occasionally juke left or right.
	 * Attribute false: Disables zombie's ability to juke.
	 * Example: entity ai::set_behavior_attribute( "can_juke", true );"
	 */
	ai::RegisterMatchedInterface(
		"zombie",
		"can_juke",
		false,
		array( true, false ) );
	
	
	/*
	 * Name: suicidal_behavior
	 * Summary: Controls whether the zombie is going to act as suicidal.
	 * Initial Value: false
	 * Attribute true: Will enable the suicidal behavior.
	 * Attribute false: Disables suicidal behavior.
	 * Example: entity ai::set_behavior_attribute( "suicidal_behavior", true );"
	 */
	ai::RegisterMatchedInterface(
		"zombie",
		"suicidal_behavior",
		false,
		array( true, false ) );
}
