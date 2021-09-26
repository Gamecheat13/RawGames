#include maps\_utility;

/*			Example map_amb.gsc file:
main()
{
	// Set the underlying ambient track
	level.ambient_track ["exterior"] = "ambient_test";
	thread maps\_utility::set_ambient("exterior");
		
	ambientDelay("exterior", 1.3, 3.4); // Trackname, min and max delay between ambient events
	ambientEvent("exterior", "burnville_foley_13b",			 0.3);
	ambientEvent("exterior", "boat_sink",					 0.6);
	ambientEvent("exterior", "bullet_large_canvas",			 0.3);
	ambientEvent("exterior", "explo_boat",					 1.3);
	ambientEvent("exterior", "Stuka_hit",					 0.1);
	
	ambientEventStart("exterior");
}
*/

ambientDelay (track, min, max)
{
	assertEX (max > min, "Ambient max must be greater than min for track " + track);
	if (!isdefined (level.ambientEventEnt))
		level.ambientEventEnt[track] = spawnstruct();
	else
	if (!isdefined (level.ambientEventEnt[track]))
		level.ambientEventEnt[track] = spawnstruct();
	
	level.ambientEventEnt[track].min = min;
	level.ambientEventEnt[track].range = max - min;
}

ambientEvent (track, name, weight)
{
	assertEX (isdefined (level.ambientEventEnt), "ambientDelay has not been run");
	assertEX (isdefined (level.ambientEventEnt[track]), "ambientDelay has not been run");

	if (!isdefined (level.ambientEventEnt[track].event_alias))
		index = 0;
	else
		index = level.ambientEventEnt[track].event_alias.size;

	level.ambientEventEnt[track].event_alias[index] = name;
	level.ambientEventEnt[track].event_weight[index] = weight;
}

ambientReverb(type)
{
	level.player setReverb(level.ambient_reverb[type]["priority"], level.ambient_reverb[type]["roomtype"], level.ambient_reverb[type]["drylevel"], level.ambient_reverb[type]["wetlevel"], level.ambient_reverb[type]["fadetime"]);
	level waittill ("new ambient event track");
//	if(level.ambient != type)
		level.player deactivatereverb(level.ambient_reverb[type]["priority"],2);
}

ambientEventStart (track)
{
	level notify ("new ambient event track");
	level endon ("new ambient event track");
	
	assertEX (isdefined (level.ambientEventEnt), "ambientDelay has not been run");
	assertEX (isdefined (level.ambientEventEnt[track]), "ambientDelay has not been run");
	
	if (!isdefined(level.player.soundEnt))
	{
		level.player.soundEnt = spawn ("script_origin",(0,0,0));
		level.player.soundEnt.playingSound = false;
	}
	else
	{
		if (level.player.soundEnt.playingSound)
			level.player.soundEnt waittill ("sounddone");
	}	
	
	ent = level.player.soundEnt;
	min = level.ambientEventEnt[track].min;
	range = level.ambientEventEnt[track].range;
	
	lastIndex = 0;
	index = 0;
	assertEX (level.ambientEventEnt[track].event_alias.size > 1, "Need more than one ambient event for track " + track);
	if(isdefined(level.ambient_reverb[track]))
		thread ambientReverb(track);

	for (;;)
	{
		wait (min + randomfloat(range));
		while (index == lastIndex)
			index = ambient_weight(track);
			
		lastIndex = index;
		ent.origin = level.player.origin;
		ent linkto (level.player);
		ent playsound (level.ambientEventEnt[track].event_alias[index], "sounddone");
		ent.playingSound = true;
		ent waittill ("sounddone");
		ent.playingSound = false;
	}
}

ambient_weight (track)
{
	total_events = level.ambientEventEnt[track].event_alias.size;
	idleanim = randomint (total_events);
	if (total_events > 1)
	{
		weights = 0;
		anim_weight = 0;
		
		for (i=0;i<total_events;i++)
		{
			weights++;
			anim_weight += level.ambientEventEnt[track].event_weight[i];
		}
		
		if (weights == total_events)
		{
			anim_play = randomfloat (anim_weight);
			anim_weight	= 0;
			
			for (i=0;i<total_events;i++)
			{
				anim_weight += level.ambientEventEnt[track].event_weight[i];
				if (anim_play < anim_weight)
				{
					idleanim = i;
					break;
				}
			}
		}
	}
	
	return idleanim;
}		
	