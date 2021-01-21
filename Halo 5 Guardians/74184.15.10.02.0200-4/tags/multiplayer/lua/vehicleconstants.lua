--
-- Vehicle Constants
--

--
-- Vehicle Metagame Types
--

BansheeType = CampaignMetagameType.Banshee;

GhostType = CampaignMetagameType.Ghost;

MantisType = CampaignMetagameType.Mantis;

MongooseType = CampaignMetagameType.Mongoose;

PhaetonType = CampaignMetagameType.Phaeton;

ScorpionType = CampaignMetagameType.Scorpion;

WarthogType = CampaignMetagameType.Warthog;

WraithType = CampaignMetagameType.Wraith;

PhantomType = CampaignMetagameType.Phantom;

-- ToDo: v-evsfor / wiarchbe: figure out why this cannot be accessed from defaultevents.lua
-- AllVehicleNamesAndTypes = 
-- {
-- 	{ "banshee", 	BansheeType },
-- 	{ "ghost", 		GhostType },
-- 	{ "mantis", 	MantisType },
-- 	{ "mongoose",	MongooseType },
-- 	{ "vtol", 		PhaetonType },
-- 	{ "scorpion", 	ScorpionType },
-- 	{ "warthog", 	WarthogType },
-- 	{ "wraith", 	WraithType },
--	{ "phantom", 	PhantomType }
-- }

AllVehicleTypes = 
{
	BansheeType,
	GhostType,
	MantisType,
	MongooseType,
	PhaetonType,
	ScorpionType,
	WarthogType,
	WraithType,
	PhantomType
};

LandVehicleTypes = 
{
	GhostType,
	MantisType,
	MongooseType,
	ScorpionType,
	WarthogType,
	WraithType
};

AirVehicleTypes = 
{
	BansheeType,
	PhaetonType,
	PhantomType
};
