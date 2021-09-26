#include maps\_utility;
createfx()
{
	// Effects placing tool
	if (!isdefined (level.createFX))
		level.createFX = [];
	
	triggers = getentarray ("trigger_multiple","classname");
	for (i=0;i<triggers.size;i++)
		triggers[i] delete();
	
	triggers = getentarray ("trigger_radius","classname");
	for (i=0;i<triggers.size;i++)
		triggers[i] delete();
	
	ai = getaiarray ();
	for (i=0;i<ai.size;i++)
		ai[i] delete();
		
	if (getcvar("effect_sound") == "")
		setcvar("effect_sound", "");
		
	setcvar("effect_soundalias", "");
	setcvar("effect_rain", "");

	setcvar("effect_drawtext", "on");
	setcvar("effect_create", "");
	setcvar("effect_delete", "");
	setcvar("effect_name", "");
	setcvar("effect_generate", "");
	setcvar("effect_orient", "off");
	setcvar("effect_display", "off");
	setcvar("effect_genshoot", "");
	setcvar("effect_exploder", "");
	setcvar("effect_onceoff", "");
	setcvar("effect_genplayer", "");
	setcvar("effect_showOrigin", "on");
	setcvar("effect_delay", "");
	setcvar("effect_list", "");

	setcvar("effect_firefx", "");
	setcvar("effect_firefxdelay", "");
	setcvar("effect_firefxsound", "");
	setcvar("effect_fxsound", "");
	setcvar("effect_quake", "");
	setcvar("effect_damage", "");
	setcvar("effect_repeat", "");
	setcvar("effect_delay_min", "");
	setcvar("effect_delay_max", "");
	setcvar("effect_damage_radius", "");
	setcvar("effect_fxtimeout", "");
	setcvar("effect_exploder_group", "");
	
	org = spawn ("script_model",(0,0,0));
	org.showOrigin = false;
	level thread createfx_draw(org);
	org rotateVelocity((25,10,5),9999999,0,0); //(x,y,z),time,accel,decel
	ent = spawnstruct();
	ent.org = org;
	org.origin2 = (0,0,100);

	ent.org.desired_origin = ent.org.origin;

	nextGen = gettime() + 300000;
	ent.grid = 16;
	effect = undefined;
	ent.selected = undefined;

	setcvar("effect_grid", "");
	setcvar("effect_1", "");
	setcvar("effect_2", "");
	setcvar("effect_3", "");
	setcvar("effect_4", "");
	setcvar("effect_6", "");
	setcvar("effect_7", "");
	setcvar("effect_8", "");
	setcvar("effect_9", "");
	setcvar("effect_up", "");
	setcvar("effect_down", "");
		
	effectName = undefined;
	soundName = undefined;
	sound = undefined;
	rainName = undefined;
	timer = 0;
	exploderNum = -1;

	oldDelay = 0;
	effectActive = false;
	
	for (;;)
	{
//		forward = anglestoforward (level.player.angles);
		forward = anglestoforward (level.player getplayerangles());

//		right = anglestoright (level.player.angles);

		if (getcvar("effect_list") != "")
		{
			setcvar("effect_list", "");
			println (" *** LIST OF EFFECTS IN USE *** ");
			usedfx = [];
			for (i=0;i<level.createFX.size;i++)
			{
				used = false;
				msg = level.createFX[i].id;
				for (p=0;p<usedfx.size;p++)
				{
					if (usedfx[p] != msg)
						continue;
						
					used = true;
					break;
				}
				
				if (used)
					continue;
					
				usedfx[usedfx.size] = msg;
				println ("\"" + msg + "\"");
			}
			usedfx = undefined;
		}

		
		dot = 0.7;		
		highlight = undefined;
		for (i=0;i<level.createFX.size;i++)
		{
			e = level.createFX[i];
			e.highlight = false;
			if (distance (e.org, level.player.origin) > 1000)
				continue;
			
			difference = vectornormalize(e.org - (level.player.origin + (0,0,55)));
			newdot = vectordot(forward, difference);
			
			if (newdot < dot)
				continue;
			
			highlight = e;
			dot = newdot;
		}

		if (isdefined (highlight))
		{
			if (getcvar ("effect_genshoot") != "")
			{
				setcvar ("effect_genshoot", "");
				if ((isdefined (ent.selected)) && (ent.selected == highlight))
				{
					ent.selected = undefined;
					org.origin = (0,0,0);
					setcvar ("effect_display", "off");
				}
				else
				{
					ent.selected = highlight;
					org.origin = ent.selected.org;
					org.origin2 = ent.selected.org2;
//					setcvar ("effect_delay", ent.selected.delay);
//					oldDelay = ent.selected.delay;
					msg = ent.selected.id;
					if ((ent.selected.type == "exploderfx") || (ent.selected.type == "loopfx"))
					{
						effectName = msg;
						if (isdefined (msg)) // effect might only be a soundalias
							effect = level._effect[msg];
					}
					else
					if (ent.selected.type == "soundfx")
					{
						soundName = msg;
						sound = msg;
					}
					else
					if (ent.selected.type == "rainfx")
					{
						soundName = msg;
						sound = msg;
						rainName = ent.selected.id2;
					}
					

					ent.org.desired_origin = ent.org.origin;
				}
			}
		}

		if (getcvar("effect_exploder") == "")
			exploderNum = -1;
		else
		{
			exploderNum = getcvarint("effect_exploder");

			if (isdefined(ent.selected))
			{
				type = ent.selected.type;
				createfx_delete(ent.selected);
				level thread exploderfxWrapper (exploderNum, effectName, ent.org.origin, ent.delay, ent.org.origin2, ent.fireFx,
					ent.fireFxdelay, ent.fireFxsound, ent.fxSound, ent.fxQuake, ent.fxDamage, ent.soundalias, ent.repeat, 
					ent.delay_min, ent.delay_max, ent.damage_radius, ent.fxTimeout, ent.exploder_group);
				ent.selected = level.createFX[level.createFX.size-1];
			}
				
			setcvar("effect_exploder", "");
		}
		
		if (isdefined (ent.selected))		
		{
			if (getcvar ("effect_soundalias") != "")
			{
				ent.selected.soundalias = getcvar ("effect_soundalias");
				createfx_recreate(ent, ent.selected.id, ent.selected.id2);
				setcvar("effect_soundalias", "");
			}

			if (getcvar ("effect_delay") != "")
			{
				ent.selected.delay = getcvarfloat ("effect_delay");
				createfx_recreate(ent, ent.selected.id, ent.selected.id2);
				setcvar("effect_delay", "");
			}

			if (getcvar ("effect_firefx") != "")
			{
				ent.selected.firefx = getcvar ("effect_firefx");
				createfx_recreate(ent, ent.selected.id, ent.selected.id2);
				setcvar("effect_firefx", "");
			}

			if (getcvar ("effect_firefxdelay") != "")
			{
				ent.selected.firefxdelay = getcvarfloat ("effect_firefxdelay");
				createfx_recreate(ent, ent.selected.id, ent.selected.id2);
				setcvar("effect_firefxdelay", "");
			}

			if (getcvar ("effect_firefxsound") != "")
			{
				ent.selected.firefxsound = getcvar ("effect_firefxsound");
				createfx_recreate(ent, ent.selected.id, ent.selected.id2);
				setcvar("effect_firefxsound", "");
			}

			if (getcvar ("effect_fxsound") != "")
			{
				ent.selected.fxsound = getcvar ("effect_fxsound");
				createfx_recreate(ent, ent.selected.id, ent.selected.id2);
				setcvar("effect_fxsound", "");
			}

			if (getcvar ("effect_quake") != "")
			{
				ent.selected.fxquake = getcvar("effect_quake");
				createfx_recreate(ent, ent.selected.id, ent.selected.id2);
				setcvar("effect_quake", "");
			}

			if (getcvar ("effect_damage") != "")
			{
				ent.selected.fxdamage = getcvarfloat ("effect_damage");
				createfx_recreate(ent, ent.selected.id, ent.selected.id2);
				setcvar("effect_damage", "");
			}

			if (getcvar ("effect_repeat") != "")
			{
				ent.selected.repeat = getcvarint ("effect_repeat");
				createfx_recreate(ent, ent.selected.id, ent.selected.id2);
				setcvar("effect_repeat", "");
			}

			if (getcvar ("effect_delay_min") != "")
			{
				ent.selected.delay_min = getcvarfloat ("effect_delay_min");
				createfx_recreate(ent, ent.selected.id, ent.selected.id2);
				setcvar("effect_delay_min", "");
			}

			if (getcvar ("effect_delay_max") != "")
			{
				ent.selected.delay_max = getcvarfloat ("effect_delay_max");
				createfx_recreate(ent, ent.selected.id, ent.selected.id2);
				setcvar("effect_delay_max", "");
			}

			if (getcvar ("effect_damage_radius") != "")
			{
				ent.selected.damage_radius = getcvarfloat ("effect_damage_radius");
				createfx_recreate(ent, ent.selected.id, ent.selected.id2);
				setcvar("effect_damage_radius", "");
			}

			if (getcvar ("effect_fxtimeout") != "")
			{
				ent.selected.fxTimeout = getcvarfloat ("effect_fxtimeout");
				createfx_recreate(ent, ent.selected.id, ent.selected.id2);
				setcvar("effect_fxtimeout", "");
			}

			if (getcvar ("effect_exploder_group") != "")
			{
				ent.selected.exploder_group = getcvarfloat ("effect_exploder_group");
				createfx_recreate(ent, ent.selected.id, ent.selected.id2);
				setcvar("effect_exploder_group", "");
			}

			if (getcvar ("effect_display") != "off")
				setcvar ("effect_display", "off");
			
			if (getcvar ("effect_delete") != "")
			{
				createfx_delete(ent.selected);
				ent.selected = undefined;
				org.origin = (0,0,0);
			}
			/*
			else
			if (oldDelay != getcvarfloat("effect_delay"))
			{
				origin = ent.selected.org;
				if (isdefined (effectName))
					createfx_recreate(ent, effectName);
				else
				if (ent.selected.type == "soundfx")
				{
					effectName = undefined;
					effect = undefined;
					soundName = ent.selected.id;
					sound = ent.selected.id;
					createfx_recreate(ent, soundName);
				}
				else
				if (ent.selected.type == "rainfx")
				{
					effectName = undefined;
					effect = undefined;
					soundName = ent.selected.id;
					sound = ent.selected.id;
					rainName = ent.selected.id2;
					createfx_recreate(ent, soundName, rainName);
				}
				
//				createfx_delete(ent.selected);
//				level thread maps\_fx::loopfxthread (effectName, ent.org.origin, getcvarfloat("effect_delay"), ent.org.origin2);
//				ent.selected = level.createFX[level.createFX.size-1];
			}
			*/
			
			if (exploderNum != -1)
			{
				if (isdefined (ent.selected.exploder))
					ent.selected.exploder.script_exploder = exploderNum;
				else	
				{
					ent.selected.type = "exploderfx";
					createfx_delete(ent.selected);
					level thread exploderfxWrapper (exploderNum, effectName, ent.org.origin, ent.delay, ent.org.origin2, 
						ent.fireFx, ent.fireFxdelay, ent.fireFxsound, ent.fxSound, ent.fxQuake, ent.fxDamage, ent.soundalias, 
						ent.repeat, ent.delay_min, ent.delay_max, ent.damage_radius, ent.fxTimeout, ent.exploder_group);
					ent.selected = level.createFX[level.createFX.size-1];
				}
			}
		}
		else	
		{
			if (getcvar ("effect_delete") != "")
				org.origin = (0,0,0);
			if (exploderNum != -1)
			{
				level thread exploderfxWrapper (exploderNum, effectName, ent.org.origin, ent.delay, ent.org.origin2, 
					ent.fireFx, ent.fireFxdelay, ent.fireFxsound, ent.fxSound, ent.fxQuake, ent.fxDamage, ent.soundalias, 
					ent.repeat, ent.delay_min, ent.delay_max, ent.damage_radius, ent.fxTimeout, ent.exploder_group);
				ent.selected = level.createFX[level.createFX.size-1];
			}
	
			/*
			if (getcvar("effect_soundalias") != "")
			{
				ent.soundalias = getcvar ("effect_soundalias");
				if (isdefined (ent.selected))
					createfx_recreate(ent, effectName);
				setcvar("effect_soundalias", "");
			}
			*/
		}
		
		if (isdefined (highlight))
			highlight.highlight = true;

		if (isdefined (sound))
		{
			if (!isdefined (ent.selected))
			{
				if (getcvar ("effect_create") != "" && ent.org.origin != (0,0,0))
					level thread maps\_fx::soundfx(soundName, ent.org.origin);
			}
			else
			{			
				if ((getcvar ("effect_create") != "") && (ent.org.origin != (0,0,0)))
				{
					type = ent.selected.type;
					if (type == "soundfx")
					{
						createfx_recreate(ent, soundName);
						level thread maps\_fx::soundfx (soundName, ent.org.origin);
					}
					else
					if (type == "rainfx")
					{
						createfx_recreate(ent, soundName, rainName);
						level thread maps\_fx::rainfx (soundName, rainName, ent.org.origin);
					}
				}
			}
		}
		else
//		if (isdefined (effect))
		{
			sound = undefined;
			soundName = undefined;
			if (!isdefined (ent.selected))
			{
				if ((getcvar ("effect_create") != "") && (ent.org.origin != (0,0,0)))
					level thread maps\_fx::loopfxthread (effectName, ent.org.origin, getcvarfloat("effect_delay"), ent.org.origin2);

				if (getcvar ("effect_display") == "on" && isdefined(effect))
				{
					if (gettime() > timer)
					{
						playfx ( effect, org.origin, vectorNormalize(org.origin2 - org.origin));
						timer = gettime() + (getcvarfloat("effect_delay") * 1000);
					}
				}
			}
			else
			{			
				if ((getcvar ("effect_create") != "") && (ent.org.origin != (0,0,0)))
				{
					type = ent.selected.type;
					if (type == "exploderfx")
						level thread exploderfxWrapper (ent.selected.exploder.script_exploder, effectName, ent.org.origin, 
							ent.selected.delay, ent.org.origin2, ent.selected.fireFx, ent.selected.fireFxdelay, 
							ent.selected.fireFxsound, ent.selected.fxSound, ent.selected.fxQuake, ent.selected.fxDamage, 
							ent.selected.exploder.script_soundalias, ent.selected.repeat, ent.selected.delay_min, ent.selected.delay_max, 
							ent.selected.damage_radius, ent.selected.fxTimeout, ent.selected.exploder_group);
					else
					if (type == "loopfx")
						level thread maps\_fx::loopfxthread (effectName, ent.org.origin, ent.selected.delay, ent.org.origin2);
					else
					if (type == "soundfx" || type == "rainfx")
						level thread maps\_fx::soundfx (soundName, ent.org.origin);
				}
				
				if (getcvar ("effect_onceoff") == "on")
				{
					selectedFX = undefined;
					for (i=0;i<level.createFX.size;i++)
					{
						if (level.createFX[i] != ent.selected)
							continue;
							
						selectedFX = level.createFX[i];
						break;
					}
					
					setcvar ("effect_onceoff", "");
					if (selectedFX.type == "exploderfx")
					{
						if (effectActive)
						{
							level notify ("createfx ready to go");
							level notify ("stop fx" + "createfx_effectStopper");
						}
						else
						{
							assertEX (isdefined(selectedFX.exploder), "Createfx at origin " + selectedFX.org + " is an exploder with no exploder information");
							wait (0.05);
							exploder (selectedFX.exploder.script_exploder);
						}
						effectActive = !effectActive;
					}
					else
					if (isdefined (effect))
						playfx ( effect, org.origin, vectorNormalize(org.origin2 - org.origin));
				}
			}		
		}
		
		if (getcvar ("effect_generate") != "" || gettime() > nextGen)
		{
			nextGen = gettime() + 30000;
			iprintlnbold ("Saved your work");
			setcvar ("effect_generate", "");
			if (level.createFX.size)
			{
				if (level.createFX.size > 1)
					println (" *** CREATING EFFECT, COPY THESE LINES TO ", level.script, "_fx.gsc *** ");
				else
					println (" *** CREATING EFFECT, COPY THIS LINE TO ", level.script, "_fx.gsc *** ");
				
				for (i=0;i<level.createFX.size;i++)
				{
					e = level.createFX[i];
					assertEX(isdefined(e.type), "effect at origin " + e.org + " has no type");
					if (e.type == "exploderfx")
					{
						print ("	maps\\_fx::", e.type);
						print ("(", e.exploder.script_exploder, ",");
						if (isdefined (e.id))
							print ("\"", e.id, "\",(");
						else
							print ("undefined,(");
							
						print (int(e.org[0]), ",", int(e.org[1]), ",", int(e.org[2]), "), ", e.delay);
						print (", (", int(e.org2[0]), ",", int(e.org2[1]), ",", int(e.org2[2]), ")");
						
						if (isdefined(e.exploder.script_fireFx))
							print (", \"", e.exploder.script_fireFx, "\"");
						else
							print (", undefined");

						if (isdefined(e.exploder.script_fireFxDelay))
							print (", ", e.exploder.script_fireFxDelay);
						else
							print (", undefined");

						if (isdefined(e.exploder.script_fireFxSound))
							print (", \"", e.exploder.script_fireFxSound, "\"");
						else
							print (", undefined");

						if (isdefined(e.exploder.script_sound))
							print (", \"", e.exploder.script_sound, "\"");
						else
							print (", undefined");

						if (isdefined(e.exploder.script_earthquake))
							print (", \"", e.exploder.script_earthquake, "\"");
						else
							print (", undefined");

						if (isdefined(e.exploder.script_damage))
							print (", ", e.exploder.script_damage);
						else
							print (", undefined");

						if (isdefined(e.exploder.script_soundalias))
							print (", \"", e.exploder.script_soundalias, "\"");
						else
							print (", undefined");

						if (isdefined(e.exploder.script_repeat))
							print (", ", e.exploder.script_repeat);
						else
							print (", undefined");

						if (isdefined(e.exploder.script_delay_min))
							print (", ", e.exploder.script_delay_min);
						else
							print (", undefined");

						if (isdefined(e.exploder.script_delay_max))
							print (", ", e.exploder.script_delay_max);
						else
							print (", undefined");

						if (isdefined(e.exploder.script_radius))
							print (", ", e.exploder.script_radius);
						else
							print (", undefined");

						if (isdefined(e.exploder.script_firefxtimeout))
							print (", ", e.exploder.script_firefxtimeout);
						else
							print (", undefined");
					/*
					else
					{
						print ("	maps\\_fx::", e.type);
						print ("(", e.exploder.script_exploder, ", \"", e.id, "\", (", int(e.org[0]), ",", int(e.org[1]), ",", int(e.org[2]), "), ", e.delay);
						print (", (", int(e.org2[0]), ",", int(e.org2[1]), ",", int(e.org2[2]), ")");
					}
					*/
					}
					else
					if (e.type == "loopfx")
					{
						print ("	maps\\_fx::", e.type);
						print ("(\"", e.id, "\", (", int(e.org[0]), ",", int(e.org[1]), ",", int(e.org[2]), "), ", e.delay);
						print (", (", int(e.org2[0]), ",", int(e.org2[1]), ",", int(e.org2[2]), ")");
					}
					else
					if (e.type == "soundfx")
					{
						print ("	maps\\_fx::", e.type);
						print ("(\"", e.id, "\", (", int(e.org[0]), ",", int(e.org[1]), ",", int(e.org[2]), ")");
					}
					else
					if (e.type == "rainfx")
					{
						print ("	maps\\_fx::", e.type);
						print ("(\"", e.id, "\", \"", e.id2, "\", (", int(e.org[0]), ",", int(e.org[1]), ",", int(e.org[2]), ")");
					}
					

					println (");");
				}
				println ("");
			}
		}			
		
		if (org.showOrigin)
		{
			if (getcvar ("effect_showOrigin") == "off")
			{
				level notify ("createfx stop showing origins");
				org.showOrigin = !org.showOrigin;
			}
		}
		else
		{
			if (getcvar ("effect_showOrigin") == "on")
			{
				level thread createfx_showOriginProc(ent);
				org.showOrigin = !org.showOrigin;
			}
		}

		if (getcvar("effect_name") != "")
		{
			msg = getcvar("effect_name");
			if (isdefined (level._effect[msg]))
			{
				setcvar ("effect_display", "on");
				effect = level._effect[msg];
				effectName = msg;
				if (isdefined (ent.selected))
					createfx_recreate(ent, effectName);
			}
			else
			if (msg == "delete")
			{
				effect = undefined;
				effectName = undefined;
				if (isdefined (ent.selected))
					createfx_recreate(ent, effectName);
			}
			else
				println ("^3 No such thing as level._effect[\"", msg, "^3\"]");
			setcvar("effect_name", "");
		}

		if (getcvar("effect_sound") != "")
		{
			msg = getcvar("effect_sound");
			sound = msg;
			soundName = msg;
			if (isdefined (ent.selected))
			{
				ent.selected.type = "soundfx";
				createfx_recreate(ent, soundName);
			}
			setcvar("effect_sound", "");
		}

		if (getcvar("effect_rain") != "")
		{
			if (isdefined(soundName))
			{
				rainName = getcvar("effect_rain");
				if (isdefined (ent.selected))
				{
					ent.selected.type = "rainfx";
					createfx_recreate(ent, soundName, rainName);
				}
			}
			else
				iprintlnbold ("Tried to setup rainfx, but no effect_sound was specified");
				
			setcvar("effect_rain", "");
		}
		
		if (getcvar("effect_genplayer") != "")
		{
			if ((getcvar ("effect_orient") != "on") || (org.origin == (0,0,0)))
			{
				setcvar("effect_genplayer", "");
				forward = anglestoforward (level.player.angles);
				forward = vectorScale(forward, 120);
				
				if (org.origin == (0,0,0))
					org.origin2 = (0,0,100);
				
				dif = org.origin2 - org.origin;
				org.origin = level.player.origin + forward;
				org.origin2 = org.origin + dif;
				ent.org.desired_origin = ent.org.origin;
				
				if (isdefined (ent.selected))
				{
					if (ent.selected.type == "soundfx")
					{
						effectName = undefined;
						effect = undefined;
						soundName = ent.selected.id;
						sound = ent.selected.id;

						createfx_recreate(ent, soundName);
					}
					else
					if (ent.selected.type == "rainfx")
					{
						effectName = undefined;
						effect = undefined;
						soundName = ent.selected.id;
						sound = ent.selected.id;
						rainName = ent.selected.id2;

						createfx_recreate(ent, soundName, rainName);
					}
					else
					if (isdefined (effectName))
						createfx_recreate(ent, effectName);
				}
			}
			else
			{
				setcvar("effect_genplayer", "");
				angles = vectortoangles ((level.player.origin + (0,0,60)) - ent.org.origin);
				forward = anglestoforward (angles);
				forward = vectorScale(forward, 100);
				
				org.origin2 = org.desired_origin + forward;
				if (isdefined (ent.selected))
				{
					if (ent.selected.type == "soundfx")
					{
						effectName = undefined;
						effect = undefined;
						soundName = ent.selected.id;
						sound = ent.selected.id;
						createfx_recreate(ent, soundName);
					}
					if (ent.selected.type == "rainfx")
					{
						effectName = undefined;
						effect = undefined;
						soundName = ent.selected.id;
						rainName = ent.selected.id2;
						sound = ent.selected.id;
						createfx_recreate(ent, soundName, rainName);
					}
					else
					if (isdefined (effectName))
						createfx_recreate(ent, effectName);
				}
//					createfx_delete(ent.selected);
//					level thread maps\_fx::loopfxthread (effectName, ent.org.origin, getcvarfloat("effect_delay"), ent.org.origin2);
//					ent.selected = level.createFX[level.createFX.size-1];

			}
		}

		if (getcvar ("effect_grid") != "")
		{
			ent.grid = getcvarint ("effect_grid");
			setcvar("effect_grid", "");
		}		
		
		if (ent.org.origin != (0,0,0))
		{
			oldOrigin = ent.org.desired_origin;
			if (getcvar ("effect_orient") == "on")
			{
				org2 = ent.org.origin2;
				createfx_entrot (ent, "effect_8", ent.grid * -1, 0);
				createfx_entrot (ent, "effect_2", ent.grid * 1, 0);
				createfx_entrot (ent, "effect_6", 0, ent.grid * 1);
				createfx_entrot (ent, "effect_4", 0, ent.grid * -1);

				if ((org2 != ent.org.origin2) && (isdefined (ent.selected)))
				{
					if (ent.selected.type == "soundfx")
					{
						effectName = undefined;
						effect = undefined;
						soundName = ent.selected.id;
						sound = ent.selected.id;
						createfx_recreate(ent, soundName);
					}
					else
					if (ent.selected.type == "rainfx")
					{
						effectName = undefined;
						effect = undefined;
						soundName = ent.selected.id;
						rainName = ent.selected.id2;
						sound = ent.selected.id;
						createfx_recreate(ent, soundName, rainName);
					}
					else
					if (isdefined (effectName))
						createfx_recreate(ent, effectName);
//						createfx_recreate(ent, soundName);
				}
//					createfx_delete(ent.selected);
//					level thread maps\_fx::loopfxthread (effectName, ent.org.origin, getcvarfloat("effect_delay"), ent.org.origin2);
//					ent.selected = level.createFX[level.createFX.size-1];

/*
				setcvar ("effect_orient", "");
				angles = vectortoangles (level.player.origin, ent.org.origin);
				forward = anglestoforward (angles, 100);
				org.origin2 = ent.org.origin + forward;
*/				
			}
			else
			{
				createfx_entmove (ent, "effect_1", ent.grid * -1, ent.grid * -1, 0);
				createfx_entmove (ent, "effect_2", ent.grid *  0, ent.grid * -1, 0);
				createfx_entmove (ent, "effect_3", ent.grid *  1, ent.grid * -1, 0);
				createfx_entmove (ent, "effect_4", ent.grid * -1, ent.grid *  0, 0);
				createfx_entmove (ent, "effect_6", ent.grid *  1, ent.grid *  0, 0);
				createfx_entmove (ent, "effect_7", ent.grid * -1, ent.grid *  1, 0);
				createfx_entmove (ent, "effect_8", ent.grid *  0, ent.grid *  1, 0);
				createfx_entmove (ent, "effect_9", ent.grid *  1, ent.grid *  1, 0);
			}

			createfx_entmove (ent, "effect_up", 0,0, ent.grid);
			createfx_entmove (ent, "effect_down", 0,0, ent.grid*-1);
			if ((oldOrigin != ent.org.desired_origin) && (isdefined (ent.selected)) && (ent.selected.type == "exploderfx" || ent.selected.type == "soundfx" || ent.selected.type == "rainfx"))
			{
				if (ent.selected.type == "soundfx")
				{
					effectName = undefined;
					effect = undefined;
					soundName = ent.selected.id;
					sound = ent.selected.id;
					createfx_recreate(ent, soundName);
				}
				else
				if (ent.selected.type == "rainfx")
				{
					effectName = undefined;
					effect = undefined;
					soundName = ent.selected.id;
					sound = ent.selected.id;
					rainName = ent.selected.id2;
					createfx_recreate(ent, soundName, rainName);
				}
				else
				if (isdefined (effectName))
					createfx_recreate(ent, effectName);
			}
			
		}
		if (isdefined (ent.selected))
		{
			ent.selected.org = ent.org.origin;
			ent.selected.org2 = ent.org.origin2; // <- yaw?
			ent.selected notify ("effect org changed", ent.org.origin);
		}
	
//		oldDelay = getcvarfloat ("effect_delay");			

		blankCvar("effect_create");
		blankCvar("effect_delete");
		blankCvar("effect_genshoot");
		blankCvar("effect_onceoff");
		blankCvar("effect_genplayer");
		wait (0.05);
	}
}

blankCvar(cvar)
{
	if (getcvar (cvar) != "")
		setcvar (cvar, "");
}

createfx_entmove (ent, msg, x, y, z)
{
	if (getcvar(msg) == "")
		return;
		
	setcvar (msg, "");
	
	angles = level.player.angles;
	forward = anglestoforward (angles);
	right = anglestoright (angles);
	forward = vectorScale(forward, y);
	right = vectorScale(right, x);

	ent.org.desired_origin += right;
	ent.org.desired_origin += forward;
	ent.org.desired_origin = (ent.org.desired_origin[0], ent.org.desired_origin[1], ent.org.desired_origin[2] + z);
	
	ent.org.origin2 += right;
	ent.org.origin2 += forward;
	ent.org.origin2 = (ent.org.origin2[0], ent.org.origin2[1], ent.org.origin2[2] + z);
	
	ent.org moveto (ent.org.desired_origin, ent.grid * 0.005);
}

createfx_entrot (ent, msg, x, y, z)
{
	if (getcvar(msg) == "")
		return;
		
	setcvar (msg, "");
	

	angles = vectortoangles (ent.org.origin2 - ent.org.origin);
	angles = (angles[0] + x, angles[1] + y, angles[2]);
	
	forward = anglestoforward (angles);
	forward = vectorScale(forward, 100);
	
	ent.org.origin2 = ent.org.origin + forward;
}

createfx_draw(org)
{
	color_dir = [];
	color = [];
	for (i=0;i<3;i++)
	{
		color_dir[i] = "up";
		color[i] = randomfloat(1);
	}
	
	color_rate = (0.005, 0.006, 0.007);
	
	scale = 15;
//	color = (0.1,0.8,0.7);
//	color = (0.1,0.8,0.7);
	num = 150;
	oldAngles = [];
	
	rotate = 0;
	
	for (i=0;i<num;i++)
	{
		oldAngles[i] = (randomint(360),randomint(360),randomint(360));
		for (p=0;p<3;p++)
		{
			if (color_dir[p] == "up")
			{
				color[p] += color_rate[p];
				if (color[p] > 1.0)
				{
					color[p] = 1.0;
					color_dir[p] = "down";
				}
			}
			else
			{
				color[p] -= color_rate[p];
				if (color[p] < 0.0)
				{
					color[p] = 0.0;
					color_dir[p] = "up";
				}
			}
		}
		col = (color[0], color[1], color[2]);
		oldColor[i] = col;
	}
	for (;;)
	{
		for (p=0;p<3;p++)
		{
			if (color_dir[p] == "up")
			{
				color[p] += color_rate[p];
				if (color[p] > 1.0)
				{
					color[p] = 1.0;
					color_dir[p] = "down";
				}
			}
			else
			{
				color[p] -= color_rate[p];
				if (color[p] < 0.0)
				{
					color[p] = 0.0;
					color_dir[p] = "up";
				}
			}
		}
		
		col = (color[0], color[1], color[2]);

		wait (0.05);

		newAngles = (randomint(360), randomint(360), randomint(360));
		oldAngles[0] = newAngles;
		oldColor[0] = col;
		
		if (org.origin == (0,0,0))
		{
			for (i=num-1;i>0;i--)
				oldColor[i] = oldColor[i-1];
			
			for (i=num-1;i>0;i--)
				oldAngles[i] = oldAngles[i-1];
			continue;
		}

		if (getcvar ("effect_orient") != "on")
		{
			for (i=0;i<num;i++)
			{
				col = oldColor[i];
				angles = oldAngles[i] + org.angles;
				forward = anglestoforward(angles);
				forward = vectorScale(forward, scale);
				line (org.origin + forward, org.origin - forward, col, 1, true);
			}
		}
		else
		{
			/*
			for (i=0;i<num;i++)
			{
				col = oldColor[i];
				angles = vectortoangles(org.origin2 - org.origin);
				right = anglestoright(angles);
				right = vectorScale(right, 100);
				line (org.origin, org.origin + right, (1,0,0), 1, true);

				up = anglestoup(angles);
				up = vectorScale(up, 100);
				line (org.origin, org.origin + up, (0,0,1), 1, true);

				angles = vectortoangles(org.origin2 - (org.origin + randomvector(16)));
				forward = anglestoforward(angles);
				forward = vectorScale(forward, 100);
				line (org.origin, org.origin + forward, col, 1, true);
			}
			*/
			angles = vectortoangles(org.origin2 - org.origin);
			right = anglestoright(angles);
			right = vectorScale(right, 100);
			line (org.origin, org.origin + right, (1,0,0), 1, true);

			up = anglestoup(angles);
			up = vectorScale(up, 100);
			line (org.origin, org.origin + up, (0,0,1), 1, true);

			forward = anglestoforward(angles);
			forward = vectorScale(forward, 100);
			line (org.origin, org.origin + forward, (0,1,0), 1, true);
			
		}

		angles = level.player.angles;
		right = anglestoright (angles);
		right = vectorScale(right, -2.0);

		if (getcvar("effect_drawtext") == "on")
		{
			print3d (org.origin + (0,0,-3.0) + right, "x", (1.0 - col[0], 1.0 - col[1], 1.0 - col[2]), 1, 0.5);	// origin, text, RGB, alpha, scale
			print3d (org.origin2 + (0,0,-3.0) + right, "o", (1.0 - col[0], 1.0 - col[1], 1.0 - col[2]), 1, 0.5);	// origin, text, RGB, alpha, scale
		}


		for (i=num-1;i>0;i--)
			oldAngles[i] = oldAngles[i-1];

		for (i=num-1;i>0;i--)
			oldColor[i] = oldColor[i-1];
		
//		line (org.origin + (0,scale * -1, 0), org.origin + (0,scale, 0), color);
//		line (org.origin + (scale * -1, 0, 0), org.origin + (scale, 0, 0), color);
	}
}


createfx_showOrigin (id, org, delay, org2, type, exploder, id2, fireFx, fireFxDelay, fireFxSound, fxSound, fxQuake, fxDamage, soundalias, repeat, delay_min, delay_max, damage_radius, fireFxTimeout)
{
	if (!isdefined (level.createFX))
		level.createFX = [];
	
	ent = spawnstruct();
	ent.id = id;
	ent.id2 = id2;
	ent.org = org;
	ent.delay = delay;
	ent.type = type;
	
	ent.fireFx = fireFx;
	ent.fireFxdelay = fireFxDelay;
	ent.fireFxsound = fireFxSOund;
	ent.fxQuake = fxQuake;
	ent.fxDamage = fxDamage;
	ent.soundalias = soundalias;
	ent.repeat = repeat;
	ent.delay_min = delay_min;
	ent.delay_max = delay_max;
	ent.damage_radius = damage_radius;
	ent.fxTimeout = fireFXTimeout;

	if (!isdefined (org2))
		org2 = ent.org + (0,0,100);
	ent.org2 = org2;
	if (isdefined(exploder))
		ent.exploder = exploder;
	
	ent.highlight = false;
	level.createFX[level.createFX.size] = ent;
	return ent;
}

createfx_showOriginProc (e)
{
	level endon ("createfx stop showing origins");
	for (;;)
	{
		for (i=0;i<level.createFX.size;i++)
		{		
			ent = level.createFX[i];
			isSelected = false;
			if (ent.type == "soundfx")
			{
				if ((isdefined (e.selected)) && (e.selected == ent))
				{
					isSelected = true;
					color = (1.0, 1.0, 0.2);
				}
				else
				if (ent.highlight)
					color = (.5, 1.0, 0.75);
				else
					color = (.2, 0.9, 0.2);
			}
			else
			if (ent.type == "rainfx")
			{
				if ((isdefined (e.selected)) && (e.selected == ent))
				{
					isSelected = true;
					color = (1.0, 1.0, 0.2);
				}
				else
				if (ent.highlight)
					color = (.95, 0.4, 0.95);
				else
					color = (.78, 0.0, 0.73);
			}
			else
			{
				if ((isdefined (e.selected)) && (e.selected == ent))
				{
					isSelected = true;
					color = (1.0, 1.0, 0.2);
				}
				else
				if (ent.highlight)
					color = (.8, .95, 1);
				else
					color = (.3, .8, 1);
			}
			
			angles = level.player.angles;
			right = anglestoright (angles);
			if (isdefined (ent.id))
				right = vectorScale(right, ent.id.size * -2.93);
				
//			print3d (ent.org + right, ent.org, color, 1, 0.75);	// origin, text, RGB, alpha, scale
			if (distancesquared(level.player.origin, ent.org) > 9000000) // 1200x1200
				continue;
			if (getcvar("effect_drawtext") == "on")
			{
				if (isdefined (ent.id))
					print3d (ent.org + right, ent.id, color, 1, 0.75);	// origin, text, RGB, alpha, scale
	
				if (ent.type == "exploderfx")
				{
					print3d (ent.org + right + (0,0,-15), "exploder: " + ent.exploder.script_exploder, color, 1, 0.75);	// origin, text, RGB, alpha, scale
					if (isSelected)
						addSelected3dPrints(ent, color, right);
				}
				else
				if (isdefined (ent.soundalias))
					print3d (ent.org + right + (0,0,-15), "alias: " + ent.soundalias, color, 1, 0.75);	// origin, text, RGB, alpha, scale
				else
				if (ent.type == "rainfx")
					print3d (ent.org + right + (0,0,-15), "rain: " + ent.id2, color, 1, 0.75);	// origin, text, RGB, alpha, scale
			}
		}
		wait (0.05);
	}
}


createfx_delete(selected)
{
	if (selected.type == "exploderfx")
	{
		/*
		for (i=0;i<level._script_exploders.size;i++)
		{
			if (!isdefined(level._script_exploders[i]))
				continue;
			if (level._script_exploders[i] != selected.exploder)
				continue;
			level._script_exploders[i] = undefined;
		}
		*/
		num = selected.exploder.script_exploder;
		selected.exploder delete();
	}
	else
	if (selected.type == "soundfx" || selected.type == "rainfx")
		selected.soundfx delete();
	
	
	newfx = [];
	for (i=0;i<level.createFX.size;i++)
	{
		if (level.createFX[i] == selected)
			continue;
			
		newfx[newfx.size] = level.createFX[i];
	}
	level.createFX = undefined;
	
	level.createFX = newfx;
	newfx = undefined;
	selected notify ("effect deleted");
}

createfx_recreate(ent, effectName, effectName2)
{
	num = undefined;
	type = ent.selected.type;
	if (type == "exploderfx")
		num = ent.selected.exploder.script_exploder;

	createfx_delete(ent.selected);

	if (type == "exploderfx")
		level thread exploderfxWrapper (num, effectName, ent.org.origin, ent.selected.delay, ent.org.origin2, ent.selected.fireFx, ent.selected.fireFxdelay, ent.selected.fireFxsound, ent.selected.fxSound, ent.selected.fxQuake, ent.selected.fxDamage, ent.selected.soundalias, ent.selected.repeat, ent.selected.delay_min, ent.selected.delay_max, ent.selected.damage_radius, ent.selected.fxTimeout, ent.exploder_group);
	else
	if (type == "loopfx")
		level thread maps\_fx::loopfxthread (effectName, ent.org.origin, ent.selected.delay, ent.org.origin2 );
	else
	if (type == "soundfx")
		level thread maps\_fx::soundfx (effectName, ent.org.origin);
	else
	if (type == "rainfx")
		level thread maps\_fx::rainfx (effectName, effectName2, ent.org.origin);
		

	ent.selected = level.createFX[level.createFX.size-1];
}

exploderfxWrapper (num, effectName, org, delay, org2, fireFx, fireFxdelay, fireFxsound, fxSound, fxQuake, fxDamage, soundalias, repeat, delay_min, delay_max, damage_radius, fxTimeout, exploder_group)
{
	maps\_fx::exploderfx (num, effectName, org, delay, org2, firefx, firefxdelay, firefxsound, fxSound, fxQuake, fxDamage, soundalias, repeat, delay_min, delay_max, damage_radius, fxTimeout, exploder_group);
}

addParam(param)
{
	if (isdefined(param))
		print (", \"", param, "\"");
	else
		print (", undefined");
}

addSelected3dPrints(ent, color, right)
{
	var = -30;
	var = addSelected3dPrintFunc( ent.exploder.script_exploder_group, "Exploder_group: ", color, ent, var, right);
	var = addSelected3dPrintFunc( ent.exploder.script_soundalias, "alias: ", color, ent, var, right);
	var = addSelected3dPrintFunc( ent.exploder.script_firefx, "fireFx: ", color, ent, var, right);
	var = addSelected3dPrintFunc( ent.exploder.script_fireFxDelay, "fireFxDelay: ", color, ent, var, right);
	var = addSelected3dPrintFunc( ent.exploder.script_fireFxSound, "fireFxSound: ", color, ent, var, right);
	var = addSelected3dPrintFunc( ent.exploder.script_firefxtimeout, "fireFxTimeout: ", color, ent, var, right);
	var = addSelected3dPrintFunc( ent.exploder.script_Sound, "fxSound: ", color, ent, var, right);
	var = addSelected3dPrintFunc( ent.exploder.script_earthQuake, "Quake: ", color, ent, var, right);
	var = addSelected3dPrintFunc( ent.exploder.script_damage, "Damage: ", color, ent, var, right);
	var = addSelected3dPrintFunc( ent.exploder.script_radius, "Damage Radius: ", color, ent, var, right);
	var = addSelected3dPrintFunc( ent.exploder.script_repeat, "Repetitions: ", color, ent, var, right);
	var = addSelected3dPrintFunc( ent.exploder.script_delay, "Delay: ", color, ent, var, right);
	var = addSelected3dPrintFunc( ent.exploder.script_delay_min, "Delay_min: ", color, ent, var, right);
	var = addSelected3dPrintFunc( ent.exploder.script_delay_max, "Delay_max: ", color, ent, var, right);
}

addSelected3dPrintFunc( param, msg, color, ent, offset, right)
{
	if (!isdefined (param))
		return offset;

	if (getcvar("effect_drawtext") == "on")
		print3d (ent.org + right + (0,0,offset), msg + param, color, 1, 0.75);

	offset -= 15;
	return offset;		
}
