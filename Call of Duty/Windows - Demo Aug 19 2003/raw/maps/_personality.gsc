main()
{
	init_personality_types();
	thread init_personality_motherbrain();
}

init_personality_motherbrain()
{
	wait (10);		
	lastguy = level.player;
	while (1)
	{
		allies = getaiarray ("allies");
		if (allies.size)
		{
			did_chat = !allies.size;
			for (i=0;i<allies.size;i++)
			{
				if ((isalive (allies[i])) && (isalive (lastguy)) && (allies[i] != lastguy) && (isdefined (allies[i].personality_type)))
				{
					if (distance (level.player getorigin(), allies[i].origin) < 500)
					{
						wait (2.5);
						if ((isalive (allies[i])) && (distance (level.player getorigin(), allies[i].origin) < 500))
						{
							allies[i] thread personality_tense_sound();
							did_chat = true;
							lastguy = allies[i];
							i = allies.size + 1;
						}
					}
				}
				wait (0.25);
			}
			
			if (did_chat)
				wait (15 + randomfloat (10));
		}
		else
		wait (1);
	}
}

personality_tense_sound()
{
//	if ((level.script != "burnville") && (level.script != "burnville_nolight"))
	return;
		
	soundnum = randomint ( level.personality [self.personality_type]["tense"].size );
	for (i=0;i<level.personality [self.personality_type]["tense"].size;i++)
	{
		if (!level.previous_said [self.personality_type]["tense"][i])
		{
			chatnum = soundnum;
			i = level.personality [self.personality_type]["tense"].size + 1;
		}
		soundnum++;
		if (soundnum >= level.personality [self.personality_type]["tense"].size)
			soundnum = 0;
	}
	
	if (!isdefined (chatnum))
	{
		for (i=0;i<level.personality [self.personality_type]["tense"].size;i++)
			level.previous_said	[self.personality_type]["tense"][i] = false;
				
		chatnum = randomint ( level.personality [self.personality_type]["tense"].size );
	}

	self playsound (level.personality [self.personality_type]["tense"][chatnum]);
//	println ("played sound ", level.personality [self.personality_type]["tense"][chatnum]);
	level.previous_said [self.personality_type]["tense"][chatnum] = true;
}

create()
{
//	println ("SIZE IS ", level.personality_types.size);
	if ((level.script == "stalingrad") || (level.script == "stalingrad_nolight"))
		return;
		
	for (i=0;i<level.personality_types.size;i++)
	{
		if (!level.personality_types_filled[level.personality_types[i]])
		{
			self.personality_type = level.personality_types[i];
			level.personality_types_filled[level.personality_types[i]] = true;
			i = level.personality_types.size + 1;
		}
	}

	if (!isdefined (self.personality_type))
		return;

//	self thread painthread();	
	self waittill ("death");	
	self playsound (level.personality [self.personality_type]["death"]);
//	println ("played sound ", level.personality [self.personality_type]["death"]);
	level.personality_types_filled[self.personality_type] = false;
}

painthread()
{
	nextpain = 0;
	while (1)
	{
		self waittill ("pain");
		if (gettime() > nextpain)
		{
			nextpain = gettime() + 500 + randomint (1500);
			self playsound (level.personality [self.personality_type]["pain"]);
//			println ("played sound ", level.personality [self.personality_type]["pain"]);
		}
	}
}

init_personality_types()
{
	level.personality_types[0] = "trained";
	level.personality_types_filled["trained"] = false;

	level.personality ["trained"]["death"] = "trained_die";
	level.personality ["trained"]["run"] = "trained_run";
	level.personality ["trained"]["oneoff"][0] = "trained_oneoff1";
	level.personality ["trained"]["oneoff"][1] = "trained_oneoff2";
	level.personality ["trained"]["oneoff"][2] = "trained_oneoff3";
	level.personality ["trained"]["oneoff"][3] = "trained_oneoff4";
	level.personality ["trained"]["tense"][0] = "trained_tense1";
	level.personality ["trained"]["tense"][1] = "trained_tense2";
	level.personality ["trained"]["tense"][2] = "trained_tense3";
	level.personality ["trained"]["tense"][3] = "trained_tense4";
	level.personality ["trained"]["tense"][4] = "trained_tense5";
	level.personality ["trained"]["tense"][5] = "trained_tense6";
	level.personality ["trained"]["tense"][6] = "trained_tense7";
	level.personality ["trained"]["nottense"][0] = "trained_nottense1";
	level.personality ["trained"]["nottense"][1] = "trained_nottense2";
	level.personality ["trained"]["nottense"][2] = "trained_nottense3";
	level.personality ["trained"]["pain"] = "trained_shot";

	level.personality_types[level.personality_types.size] = "cheerleader";
	level.personality_types_filled["cheerleader"] = false;

	level.personality ["cheerleader"]["death"] = "cheerleader_die";
	level.personality ["cheerleader"]["run"] = "cheerleader_run";
	level.personality ["cheerleader"]["oneoff"][0] = "cheerleader_oneoff1";
	level.personality ["cheerleader"]["oneoff"][1] = "cheerleader_oneoff2";
	level.personality ["cheerleader"]["oneoff"][2] = "cheerleader_oneoff3";
	level.personality ["cheerleader"]["tense"][0] = "cheerleader_tense1";
	level.personality ["cheerleader"]["tense"][1] = "cheerleader_tense2";
	level.personality ["cheerleader"]["tense"][2] = "cheerleader_tense3";
	level.personality ["cheerleader"]["nottense"][0] = "cheerleader_nottense1";
	level.personality ["cheerleader"]["nottense"][1] = "cheerleader_nottense2";
	level.personality ["cheerleader"]["nottense"][2] = "cheerleader_nottense3";
	level.personality ["cheerleader"]["nottense"][3] = "cheerleader_nottense4";
	level.personality ["cheerleader"]["pain"] = "cheerleader_shot";

	level.personality_types[level.personality_types.size] = "educated";
	level.personality_types_filled["educated"] = false;

	level.personality ["educated"]["death"] = "educated_die";
	level.personality ["educated"]["run"] = "educated_run";
	level.personality ["educated"]["oneoff"][0] = "educated_oneoff1";
	level.personality ["educated"]["oneoff"][1] = "educated_oneoff2";
	level.personality ["educated"]["oneoff"][2] = "educated_oneoff3";
	level.personality ["educated"]["oneoff"][3] = "educated_oneoff4";
	level.personality ["educated"]["tense"][0] = "educated_tense1";
	level.personality ["educated"]["tense"][1] = "educated_tense2";
	level.personality ["educated"]["tense"][2] = "educated_tense3";
	level.personality ["educated"]["nottense"][0] = "educated_nottense1";
	level.personality ["educated"]["nottense"][1] = "educated_nottense2";
	level.personality ["educated"]["nottense"][2] = "educated_nottense3";
	level.personality ["educated"]["nottense"][3] = "educated_nottense4";
	level.personality ["educated"]["pain"] = "educated_shot";

	level.personality_types[level.personality_types.size] = "fearless";
	level.personality_types_filled["fearless"] = false;

	level.personality ["fearless"]["death"] = "fearless_die";
	level.personality ["fearless"]["run"] = "fearless_run";
	level.personality ["fearless"]["oneoff"][0] = "fearless_oneoff1";
	level.personality ["fearless"]["oneoff"][1] = "fearless_oneoff2";
	level.personality ["fearless"]["oneoff"][2] = "fearless_oneoff3";
	level.personality ["fearless"]["oneoff"][3] = "fearless_oneoff4";
	level.personality ["fearless"]["tense"][0] = "fearless_tense1";
	level.personality ["fearless"]["tense"][1] = "fearless_tense2";
	level.personality ["fearless"]["tense"][2] = "fearless_tense3";
	level.personality ["fearless"]["tense"][3] = "fearless_tense4";
	level.personality ["fearless"]["tense"][4] = "fearless_tense5";
	level.personality ["fearless"]["nottense"][0] = "fearless_nottense1";
	level.personality ["fearless"]["nottense"][1] = "fearless_nottense2";
	level.personality ["fearless"]["nottense"][2] = "fearless_nottense3";
	level.personality ["fearless"]["pain"] = "fearless_shot";

	level.personality_types[level.personality_types.size] = "friendly";
	level.personality_types_filled["friendly"] = false;

	level.personality ["friendly"]["death"] = "friendly_die";
	level.personality ["friendly"]["run"] = "friendly_run";
	level.personality ["friendly"]["oneoff"][0] = "friendly_oneoff1";
	level.personality ["friendly"]["oneoff"][1] = "friendly_oneoff2";
	level.personality ["friendly"]["oneoff"][2] = "friendly_oneoff3";
	level.personality ["friendly"]["tense"][0] = "friendly_tense1";
	level.personality ["friendly"]["tense"][1] = "friendly_tense2";
	level.personality ["friendly"]["tense"][2] = "friendly_tense3";
	level.personality ["friendly"]["tense"][3] = "friendly_tense4";
	level.personality ["friendly"]["tense"][4] = "friendly_tense5";
	level.personality ["friendly"]["nottense"][0] = "friendly_nottense1";
	level.personality ["friendly"]["nottense"][1] = "friendly_nottense2";
	level.personality ["friendly"]["nottense"][2] = "friendly_nottense3";
	level.personality ["friendly"]["pain"] = "friendly_shot";

	level.personality_types[level.personality_types.size] = "smartass";
	level.personality_types_filled["smartass"] = false;

	level.personality ["smartass"]["death"] = "smartass_die";
	level.personality ["smartass"]["run"] = "smartass_run";
	level.personality ["smartass"]["oneoff"][0] = "smartass_oneoff1";
	level.personality ["smartass"]["oneoff"][1] = "smartass_oneoff2";
	level.personality ["smartass"]["oneoff"][2] = "smartass_oneoff3";
	level.personality ["smartass"]["oneoff"][3] = "smartass_oneoff4";
	level.personality ["smartass"]["tense"][0] = "smartass_tense1";
	level.personality ["smartass"]["tense"][1] = "smartass_tense2";
	level.personality ["smartass"]["tense"][2] = "smartass_tense3";
	level.personality ["smartass"]["tense"][3] = "smartass_tense4";
	level.personality ["smartass"]["tense"][4] = "smartass_tense5";
	level.personality ["smartass"]["nottense"][0] = "smartass_nottense1";
	level.personality ["smartass"]["nottense"][1] = "smartass_nottense2";
	level.personality ["smartass"]["nottense"][2] = "smartass_nottense3";
	level.personality ["smartass"]["nottense"][3] = "smartass_nottense4";
	level.personality ["smartass"]["pain"] = "smartass_shot";

	for (i=0;i<level.personality_types.size;i++)
		for (p=0;p<level.personality [level.personality_types[i]]["tense"].size;p++)
			level.previous_said	[level.personality_types[i]]["tense"][p] = false;
}