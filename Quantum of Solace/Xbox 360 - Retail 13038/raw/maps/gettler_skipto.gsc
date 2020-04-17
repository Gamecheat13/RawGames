#include maps\_utility;
#include maps\gettler_util;

main(skipto)
{
	level.skipto = "";
	if (level.script != "gettlertest")
	{
		if (!IsDefined(skipto))
		{
			level.skipto = GetDVar("skipto");
			//level.skipto = "gettler";
		}
		else
		{
			level.skipto = skipto;
		}

		if (level.skipto != "")
		{
			if (level.skipto == "pillars")
			{
				//level.gave_weapon = true;
				maps\gettler_vesper::spawn_run_aways();
				
				scrub_zone("zone1", true, true);
				scrub_zone("zone2", true, true, "drone", "targetname");

				level thread maps\gettler::objectives(2);
			}
			else if (level.skipto == "alley")
			{
				//level.gave_weapon = true;
				unholster_weapons();
				scrub_zone("zone1", true, true);
				scrub_zone("zone2", true, true, "drone", "targetname");

				level thread maps\gettler::objectives(4);

				GetEnt("atrium_player_clip", "targetname") delete();
				GetEnt( "ent_atrium_gate", "targetname" ) playsound( "GET_Fence_Open" );
				GetEnt( "ent_atrium_gate", "targetname" ) RotateTo( (0, 90, 0), 0.25 );
			}			
			else if (level.skipto == "middle")
			{
				//level.gave_weapon = true;
				unholster_weapons();
				scrub_zone("zone1", true, true);
				scrub_zone("zone2", true, true, "drone", "targetname");
				scrub_zone("zone3", true, true);

				level thread maps\gettler::objectives(4);
			}
			else if (level.skipto == "boats")
			{
				//level.gave_weapon = true;
				unholster_weapons();
				scrub_zone("zone1", true, true);
				scrub_zone("zone2", true, true, "drone", "targetname");
				scrub_zone("zone3", true, true);

				level thread maps\gettler::objectives(5);
			}
			else if (level.skipto == "gettler")
			{
				//level.gave_weapon = true;
				unholster_weapons();
				scrub_zone("zone1", true, true);
				scrub_zone("zone2", true, true, "drone", "targetname");
				scrub_zone("zone3", true, true);
				scrub_zone("zone4", true, true);
				scrub_zone("zone5", true, true);

				level thread maps\gettler::objectives(6);

				level thread move_escape_boat_to_end_node();

				//wait 3;
				//level.player customcamera_checkcollisions( 0 );
				//level.player customCamera_push("external", "gettler", "gettler_vesper_meet");	// for editing the custom camera
			}
			else if (level.skipto == "end")
			{
				//level.gave_weapon = true;
				unholster_weapons();
				scrub_zone("zone1", true, true);
				scrub_zone("zone2", true, true, "drone", "targetname");
				scrub_zone("zone3", true, true);
				scrub_zone("zone4", true, true);
				scrub_zone("zone5", true, true);
				
				level thread maps\gettler_load::elevator(true);

				level thread maps\gettler::objectives(9);
			}

			move_player(level.skipto);
			return true;
		}
	}

	return false;
}

move_player(skipto)
{
	skipto_org = GetEnt("skipto_" + skipto, "script_noteworthy");
	if (IsDefined(skipto_org))
	{
		level.player setorigin( skipto_org.origin );
		level.player setplayerangles( skipto_org.angles );
	}
}