#include maps\_utility;

///////////////////////////////////////////////////////////////////////////
//	_data_collection.gsc
//	-----------------
//	Handles data collection.  The player can pick up data collection objects in the
//	level and have an inventory of collected data on the data collection screen
///////////////////////////////////////////////////////////////////////////

///////////////////////////////////////////////////////////////////////////
//	main - called in _load and inits all placed data objects in the level
///////////////////////////////////////////////////////////////////////////
main()
{
	// default string for cellphones
	level.strings["cell_phone_default_name"] = "Cell Phone";
	level.strings["cell_phone_default_text"] = "Cell Phone Data";

	level.data_collection_count = 0;
	level.data_collection_index = 0;

	array_thread(GetEntArray("script_model", "classname"), ::cell_phone);	// cell phones are the only type of data collection we have

	data_collection_size(level.data_collection_count + 1);	// add another slot for mission briefing

	level thread add_mission_briefing();
}

cell_phone()
{
	if (self.model == "p_msc_phone_pickup")
	{
		level.data_collection_count++;

		if (!IsDefined(self.name))
		{
			self.name = "cell_phone_default_name";
		}

		if (!IsDefined(self.script_string))
		{
			self.script_string = "cell_phone_default_text";
		}

		self thread cell_phone_ring();

		//trig = Spawn("trigger_radius", self.origin, 0, 20, 20);
		//trig waittill("trigger");

		self SetUseable(true);
		self SetCursorHint("HINT_ACTIVATE_HOLD");
		self SetHintString(&"HINT_PICKUP_CELLPHONE");
		self waittill("trigger");

		// wwilliams
		// run a function from _achievements to setcollectiblefound
		level thread maps\_achievements::phone_set_collectible( level.script, self.script_int );

		//iPrintLnBold("Picked up a phone.");
		level.player playsound("cell_phone_pickup");

		// wwilliams
		// commenting out this notify, it was the old achievement way
		// level notify( "ACH_CELL_PICKUP" );

		self notify("stop_ring");
		self add_data();
		wait(.1);
		forcephoneactive(true, "data"); // pull up the phone on the data screen
		self delete();
	}
}

cell_phone_ring()
{
	self endon("stop_ring");

	trig = Spawn("trigger_radius", self.origin, 0, 150, 40);
	while (true)
	{
		trig waittill("trigger");
		while ( isdefined( self ) && level.player IsTouching(trig))
		{
			self PlaySound("cell_vibrate");
			wait 5;
		}
	}
}

add_data()
{
	i = undefined;
	if (IsDefined(self.script_int))
	{
		i = self.script_int + 1;
	}
	else
	{		
		i = level.data_collection_index;
		level.data_collection_index++;
	}

	if (IsDefined(self.script_image))
	{
		data_collection_add(i, "image", self.script_image, level.strings[self.name], level.strings[self.script_string]);
	}
	else if (IsDefined(self.script_soundalias))
	{
		data_collection_add(i, "audio", self.script_soundalias, level.strings[self.name], level.strings[self.script_string]);
	}
	else
	{
		data_collection_add(i, "text", level.strings[self.script_string], level.strings[self.name]);
	}
}

add_mission_briefing()
{
	switch (level.script)
	{
	case "whites_estate":
		level.strings["mission_briefing_name"] = &"WHITES_ESTATE_MISSION_BRIEFING_NAME";
		level.strings["mission_briefing_text"] = &"WHITES_ESTATE_MISSION_BRIEFING_TEXT";
		break;
	case "siena":
		level.strings["mission_briefing_name"] = &"SIENA_MISSION_BRIEFING_NAME";
		//BEENOX-PC: GGL : Change some texts for the demo to remove references to Mitchell.
		if( Getdvar( "sf_bx_demo_coke" ) == "1" )
		{
			level.strings["mission_briefing_text"] = &"SIENA_DEMO_MISSION_BRIEFING_TEXT";
		}
		else
		{
			level.strings["mission_briefing_text"] = &"SIENA_MISSION_BRIEFING_TEXT";
		}
		break;
	case "siena_rooftops":
		level.strings["mission_briefing_name"] = &"SIENA_MISSION_BRIEFING_NAME";
		level.strings["mission_briefing_text"] = &"SIENA_MISSION_BRIEFING_TEXT";
		break;
	case "operahouse":
		level.strings["mission_briefing_name"] = &"OPERAHOUSE_MISSION_BRIEFING_NAME";
		level.strings["mission_briefing_text"] = &"OPERAHOUSE_MISSION_BRIEFING_TEXT";
		break;
	case "sink_hole":
		level.strings["mission_briefing_name"] = &"SINK_HOLE_MISSION_BRIEFING_NAME";
		level.strings["mission_briefing_text"] = &"SINK_HOLE_MISSION_BRIEFING_TEXT";
		break;
	case "shantytown":
		level.strings["mission_briefing_name"] = &"SHANTYTOWN_MISSION_BRIEFING_NAME";
		level.strings["mission_briefing_text"] = &"SHANTYTOWN_MISSION_BRIEFING_TEXT";
		break;
	case "constructionsite":
		level.strings["mission_briefing_name"] = &"CONSTRUCTIONSITE_MISSION_BRIEFING_NAME";
		level.strings["mission_briefing_text"] = &"CONSTRUCTIONSITE_MISSION_BRIEFING_TEXT";
		break;
	case "sciencecenter_a":
		level.strings["mission_briefing_name"] = &"SCIENCECENTER_A_MISSION_BRIEFING_NAME";
		level.strings["mission_briefing_text"] = &"SCIENCECENTER_A_MISSION_BRIEFING_TEXT";
		break;
	case "sciencecenter_b":
		level.strings["mission_briefing_name"] = &"SCIENCECENTER_B_MISSION_BRIEFING_NAME";
		level.strings["mission_briefing_text"] = &"SCIENCECENTER_B_MISSION_BRIEFING_TEXT";
		break;
	case "airport":
		level.strings["mission_briefing_name"] = &"AIRPORT_MISSION_BRIEFING_NAME";
		level.strings["mission_briefing_text"] = &"AIRPORT_MISSION_BRIEFING_TEXT";
		break;
	case "montenegrotrain":
		level.strings["mission_briefing_name"] = &"MONTENEGROTRAIN_MISSION_BRIEFING_NAME";
		level.strings["mission_briefing_text"] = &"MONTENEGROTRAIN_MISSION_BRIEFING_TEXT";
		break;
	case "casino":
		level.strings["mission_briefing_name"] = &"CASINO_MISSION_BRIEFING_NAME";
		level.strings["mission_briefing_text"] = &"CASINO_MISSION_BRIEFING_TEXT";
		break;
	case "casino_poison":
		level.strings["mission_briefing_name"] = &"CASINO_POISON_MISSION_BRIEFING_NAME";
		level.strings["mission_briefing_text"] = &"CASINO_POISON_MISSION_BRIEFING_TEXT";
		break;
	case "barge":
		level.strings["mission_briefing_name"] = &"BARGE_MISSION_BRIEFING_NAME";
		level.strings["mission_briefing_text"] = &"BARGE_MISSION_BRIEFING_TEXT";
		break;
	case "gettler":
		level.strings["mission_briefing_name"] = &"GETTLER_MISSION_BRIEFING_NAME";
		level.strings["mission_briefing_text"] = &"GETTLER_MISSION_BRIEFING_TEXT";
		break;
	case "eco_hotel":
		level.strings["mission_briefing_name"] = &"ECO_HOTEL_MISSION_BRIEFING_NAME";
		level.strings["mission_briefing_text"] = &"ECO_HOTEL_MISSION_BRIEFING_TEXT";
		break;
	case "haines_estate":
		level.strings["mission_briefing_name"] = &"HAINES_ESTATE_MISSION_BRIEFING_NAME";
		level.strings["mission_briefing_text"] = &"HAINES_ESTATE_MISSION_BRIEFING_TEXT";
		break;
	default:
		level.strings["mission_briefing_name"] = "NO MISSION BRIEFING FOR MAP";
		level.strings["mission_briefing_text"] = "This map does not have a mission briefing";
	}

	data = spawnstruct();
	data.name = "mission_briefing_name";
	data.script_string = "mission_briefing_text";

	wait 1;
	while (GetDVarInt("letterboxActive") == 1)	// wait untill letterbox is off
	{
		wait .2;
	}

	wait 2;
	data add_data();
}
