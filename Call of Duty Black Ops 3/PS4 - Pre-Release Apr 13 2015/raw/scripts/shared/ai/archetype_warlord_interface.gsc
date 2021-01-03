#using scripts\shared\ai\warlord;
#using scripts\shared\ai\systems\ai_interface;

#namespace WarlordInterface;

function RegisterWarlordInterfaceAttributes()
{
	/*
	 * Name: can_be_meleed
	 * Summary: Controls whether other AI will choose to melee the warlord.
	 * Initial Value: true
	 * Attribute true: Normal behavior, warlord will be meleed when close to their enemy.
	 * Attribute false: Forces other AI to shoot the warlord instead of melee it at close distances.
	 * Example: entity ai::set_behavior_attribute( "can_be_meleed", true );"
	 */
	ai::RegisterMatchedInterface(
		"warlord",
		"can_be_meleed",
		false,
		array( true, false ) );
}

/*
 * Name: AddPreferedPoint
 * Summary: Adds a prefered go to location that the warlord will be inclined to go to every now and then.
 * The warlord will choose the location only if it is inside the goal bounadries.
 * Multiple points can be added.
 * Mandatory Arg - self : warlord entity
 * Mandatory Arg - position : prefered position.
 * Optional Arg  - min_duration/max_duration Range in milliseconds where the warlord should hold that position if he chooses it
 * Optional Arg  - position name
 * Example: entity AddPreferedPoint(interesting_node.origin, 10000, 15000);
 */
function AddPreferedPoint(position, min_duration, max_duration, name)
{
	WarlordServerUtils::AddPreferedPoint(self, position, min_duration, max_duration, name);
}

/*
 * Name: ClearAllPreferedPoints
 * Summary: Clears all Warlord prefered nodes.
 * Mandatory Arg - self : warlord entity
 * Example: entity ClearAllPreferedPoints();
 */
function ClearAllPreferedPoints()
{
	WarlordServerUtils::ClearAllPreferedPoints(self);
}
/*
 * Name: ClearPreferedPointsOutsideGoal
 * Summary: Clears all Warlord prefered nodes which are outside the current Goal
 * Mandatory Arg - self : warlord entity
 * Example: entity ClearAllPreferedPoints();
 */
function ClearPreferedPointsOutsideGoal()
{
	WarlordServerUtils::ClearPreferedPointsOutsideGoal(self);
}