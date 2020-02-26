-- *-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*
-- *_*_*_*_*_*_ GLOBAL TUTORIAL SCRIPT *_*_*_*_*_*_*_*
-- *_*_*_*_*_*_*_*_*_*_*_*_*_*_*_*_*_*_*_*_*_*_*_*_*

-- Convert turorial ID to array index

global tutorialSwitchTable:table =
{
	-- Add new tutorials here. Do not change their orders.
	"training_clamber_halsey_01",
	"training_charge_halsey_01",
	"training_orders_vehicle_01",
	"training_guard_jump_01",
	"training_chief_ping_01",
	"training_chief_charge_01",
	"training_meridian_tracking_01",
	

}

-- Get the index of the string in the table.
function getTutorialIndex(name:string)
	local index = nil;
	for i = 1, #tutorialSwitchTable do
		if tutorialSwitchTable[i] == name then
			if not index then
				index = i;
			else
				error("tutorials have duplicate names");
			end
		end
	end
	if not index then
		error("invalid tutorial name");
	end
	return index;
end