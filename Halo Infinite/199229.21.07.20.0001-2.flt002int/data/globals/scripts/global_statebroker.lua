-- preprocess
-- Copyright (c) Microsoft. All rights reserved.

global StateBrokerPreregisteredStates:table = 
{
	{
		name = "Combat::PlayerInCombat",
		type = STATE_TYPE.BooleanValue,
		description = "True when the player is in combat."
	},
	{
		name = "DayNight::Daytime",
		type = STATE_TYPE.BooleanValue,
		description = "True when gameplay is occurring during the day."
	},
	{
		name = "DayNight::Nighttime",
		type = STATE_TYPE.BooleanValue,
		description = "True when gameplay is occurring at night."
	},
	{
		name = "DayNight::TimeOfDay::Dawn",
		type = STATE_TYPE.BooleanValue,
		description = "True when gameplay is occurring during the hours of dawn."
	},
	{
		name = "DayNight::TimeOfDay::Morning",
		type = STATE_TYPE.BooleanValue,
		description = "True when gameplay is occurring during morning hours."
	},
	{
		name = "DayNight::TimeOfDay::Noon",
		type = STATE_TYPE.BooleanValue,
		description = "True when gameplay is occurring around midday."
	},
	{
		name = "DayNight::TimeOfDay::Afternoon",
		type = STATE_TYPE.BooleanValue,
		description = "True when gameplay is occurring after midday."
	},		
	{
		name = "DayNight::TimeOfDay::Evening",
		type = STATE_TYPE.BooleanValue,
		description = "True when gameplay is occurring during evening hours."
	},
		{
		name = "DayNight::TimeOfDay::GoldenHour",
		type = STATE_TYPE.BooleanValue,
		description = "True when gameplay is occurring during golden hour."
	},
	{
		name = "DayNight::TimeOfDay::Dusk",
		type = STATE_TYPE.BooleanValue,
		description = "True when gameplay is occurring during the hours of dusk."
	},
	{
		name = "DayNight::TimeOfDay::Night",
		type = STATE_TYPE.BooleanValue,
		description = "True when gameplay is occurring during nighttime hours."
	},	
	{
		name = "DayNight::TimeOfDay::Clock",
		type = STATE_TYPE.ShortValue,
		description = "Return a value for the current time as defined in the time of day script."
	},
	{
		name = "Dungeon::PlayerWithinActivationDistance",
		type = STATE_TYPE.BooleanValue,
		description = "True when the player is in an activation distance of dungeon start point."
	},
	{
		name = "Dungeon::PlayerEntering",
		type = STATE_TYPE.BooleanValue,
		description = "True when the player started entering a dungeon"
	},
	{
		name = "Dungeon::PlayerEntered",
		type = STATE_TYPE.BooleanValue,
		description = "True when the player has completed loading a dungeon level."
	},
	{
		name = "Dungeon::PlayerLeaving",
		type = STATE_TYPE.BooleanValue,
		description = "True when the player started leaving a dungeon."
	},
	{
		name = "Dungeon::Type::Covenant",
		type = STATE_TYPE.BooleanValue,
		description = "True when the dungeon is a covenant type."
	},
	{
		name = "Dungeon::Type::Forerunner",
		type = STATE_TYPE.BooleanValue,
		description = "True when the dungeon is a forerunner type."
	},
	{
		name = "Dungeon::Type::None",
		type = STATE_TYPE.BooleanValue,
		description = "True when the dungeon has no type defined."
	},
	{
		name = "Region::PlayerEntered",
		type = STATE_TYPE.ShortValue,
		description = "Return an index of the latest region that the player entered."
	},
	{
		name = "Region::IsOccupied",
		type = STATE_TYPE.BooleanValue,
		description = "True when the region the player is in is occupied by enemy forces."
	},
	{
		name = "Region::FirstTimeEntered",
		type = STATE_TYPE.BooleanValue,
		description = "True when the player entered this region for the first time."
	},
	{
		name = "Weather::Skybox::Clear",
		type = STATE_TYPE.BooleanValue,
		description = "True when the sky is clear."
	},
	{
		name = "Weather::Skybox::Clouds",
		type = STATE_TYPE.BooleanValue,
		description = "True when the sky is cloudy."
	},
	{
		name = "Weather::Skybox::Overcast",
		type = STATE_TYPE.BooleanValue,
		description = "True when the sky is overcast."
	},
	{
		name = "Weather::Atmosphere::Clear",
		type = STATE_TYPE.BooleanValue,
		description = "True when the air is clear and visibility is good."
	},
	{
		name = "Weather::Atmosphere::Fog",
		type = STATE_TYPE.BooleanValue,
		description = "True when it's foggy and visibility is bad."
	},
	{
		name = "Weather::Atmosphere::Haze",
		type = STATE_TYPE.BooleanValue,
		description = "True when the air is hazy with dust or smoke."
	},
	{
		name = "Weather::Precipitation::None",
		type = STATE_TYPE.BooleanValue,
		description = "True when no precipitation is falling."
	},
	{
		name = "Weather::Precipitation::Rain",
		type = STATE_TYPE.BooleanValue,
		description = "True when it's raining."
	},
	{
		name = "Weather::Precipitation::Snow",
		type = STATE_TYPE.BooleanValue,
		description = "True when it's snowing."
	},

	{
		name = "Placeholder::PlaceholderBool1",
		type = STATE_TYPE.BooleanValue,
		description = "Design placeholder bool"
	},
	{
		name = "Placeholder::PlaceholderBool2",
		type = STATE_TYPE.BooleanValue,
		description = "Design placeholder bool"
	},
	{
		name = "Placeholder::PlaceholderBool3",
		type = STATE_TYPE.BooleanValue,
		description = "Design placeholder bool"
	},
	{
		name = "Placeholder::PlaceholderBool4",
		type = STATE_TYPE.BooleanValue,
		description = "Design placeholder bool"
	},
	{
		name = "Placeholder::PlaceholderBool5",
		type = STATE_TYPE.BooleanValue,
		description = "Design placeholder bool"
	},

	{
		name = "Placeholder::PlaceholderShort1",
		type = STATE_TYPE.ShortValue,
		description = "Design placeholder short"
	},
	{
		name = "Placeholder::PlaceholderShort2",
		type = STATE_TYPE.ShortValue,
		description = "Design placeholder short"
	},
	{
		name = "Placeholder::PlaceholderShort3",
		type = STATE_TYPE.ShortValue,
		description = "Design placeholder short"
	},
	{ 
		name = "Placeholder::PlaceholderShort4",
		type = STATE_TYPE.ShortValue,
		description = "Design placeholder short"
	},
	{
		name = "Placeholder::PlaceholderShort5",
		type = STATE_TYPE.ShortValue,
		description = "Design placeholder short"
	},

	{
		name = "Spawn::SpawnPointName",
		type = STATE_TYPE.StringIdValue,
		description = "Name of the most recently used spawn point."
	},
	{
		name = "Spawn::TransitionAnchorName",
		type = STATE_TYPE.StringIdValue,
		description = "Name of the most recently used seamless level transition anchor point."
	},
}

