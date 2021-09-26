#include maps\mp\_utility;
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
	
//	ai = getaiarray ();
//	for (i=0;i<ai.size;i++)
//		ai[i] delete();
		
	if (getcvar("effect_sound") == "")
		setcvar("effect_sound", "");
		
	setcvar("effect_soundalias", "");

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
	setcvar("effect_delay", "1");
	setcvar("effect_list", "");

	setcvar("effect_firefx", "");
	setcvar("effect_firefxdelay", "");
	setcvar("effect_firefxsound", "");
	
	org = spawn ("script_model",(0,0,0));
	org.showOrigin = false;
	level thread createfx_draw(org);
	org rotateVelocity((25,10,5),9999999,0,0); //(x,y,z),time,accel,decel
	ent = spawnstruct();
	ent.org = org;
	org.origin2 = (0,0,100);

	ent.org.desired_origin = ent.org.origin;


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
					setcvar ("effect_delay", ent.selected.delay);
					oldDelay = ent.selected.delay;
					msg = ent.selected.id;
					if ((ent.selected.type == "exploderfx") || (ent.selected.type == "loopfx"))
					{
						effectName = msg;
						effect = level._effect[msg];
					}
					else
					if (ent.selected.type == "soundfx")
					{
						soundName = msg;
						sound = msg;
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
				level thread exploderfxWrapper (exploderNum, effectName, ent.org.origin, getcvarfloat("effect_delay"), ent.org.origin2, ent.soundalias);
				ent.selected = level.createFX[level.createFX.size-1];
			}
				
			setcvar("effect_exploder", "");
		}
		
		if (isdefined (ent.selected))		
		{
			if (getcvar ("effect_soundalias") != "")
			{
				ent.selected.soundalias = getcvar ("effect_soundalias");
				createfx_recreate(ent, ent.selected.id);
				setcvar("effect_soundalias", "");
			}

			if (getcvar ("effect_display") != "off")
				setcvar ("effect_display", "off");
			
			if (getcvar ("effect_delete") != "")
			{
				createfx_delete(ent.selected);
				ent.selected = undefined;
				org.origin = (0,0,0);
			}
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
				
//				createfx_delete(ent.selected);
//				level thread maps\mp\_fx::loopfxthread (effectName, ent.org.origin, getcvarfloat("effect_delay"), ent.org.origin2);
//				ent.selected = level.createFX[level.createFX.size-1];
			}
			
			if (exploderNum != -1)
			{
				if (isdefined (ent.selected.exploder))
					ent.selected.exploder.script_exploder = exploderNum;
				else	
				{
					ent.selected.type = "exploderfx";
					createfx_delete(ent.selected);
					level thread exploderfxWrapper (exploderNum, effectName, ent.org.origin, getcvarfloat("effect_delay"), ent.org.origin2, ent.soundalias);
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
				level thread exploderfxWrapper (exploderNum, effectName, ent.org.origin, getcvarfloat("effect_delay"), ent.org.origin2, ent.soundalias);
				ent.selected = level.createFX[level.createFX.size-1];
			}
		}
		
		if (isdefined (highlight))
			highlight.highlight = true;

		if (isdefined (sound))
		{
			if (!isdefined (ent.selected))
			{
				if (getcvar ("effect_create") != "" && ent.org.origin != (0,0,0))
					level thread maps\mp\_fx::soundfx(soundName, ent.org.origin);
			}
			else
			{			
				if ((getcvar ("effect_create") != "") && (ent.org.origin != (0,0,0)))
				{
					type = ent.selected.type;
					if (type == "soundfx")
					{
						createfx_recreate(ent, soundName);
						level thread maps\mp\_fx::soundfx (soundName, ent.org.origin);
					}
				}
			}
		}
		else
		if (isdefined (effect))
		{
			sound = undefined;
			soundName = undefined;
			if (!isdefined (ent.selected))
			{
				if ((getcvar ("effect_create") != "") && (ent.org.origin != (0,0,0)))
					level thread maps\mp\_fx::loopfxthread (effectName, ent.org.origin, getcvarfloat("effect_delay"), ent.org.origin2);			

				if (getcvar ("effect_display") == "on")
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
						level thread exploderfxWrapper (ent.selected.exploder.script_exploder, effectName, ent.org.origin, getcvarfloat("effect_delay"), ent.org.origin2, ent.soundalias);
					else
					if (type == "loopfx")
						level thread maps\mp\_fx::loopfxthread (effectName, ent.org.origin, getcvarfloat("effect_delay"), ent.org.origin2);
					else
					if (type == "soundfx")
						level thread maps\mp\_fx::soundfx (soundName, ent.org.origin);
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
						playfx ( effect, org.origin, vectorNormalize(org.origin2 - org.origin));
				}
			}		
		}
		
		if (getcvar ("effect_generate") != "")
		{
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
						// Has a looping effect or a soundalias
						if (getcvar("effect_firefx") != "" || isdefined(e.exploder.script_soundalias))
						{
							firefx = getcvar("effect_firefx");
							if (!isdefined (level._effect[firefx]))
								firefx = undefined;
						
							firefxdelay = undefined;
							if (getcvar("effect_firefxdelay") != "")
								firefxdelay = getcvarfloat ("effect_firefxdelay");
						
							firefxsound = undefined;
							if (getcvar("effect_firefxsound") != "")
								firefxsound = getcvar ("effect_firefxsound");
								
							print ("	maps\\mp\\_fx::", e.type);
							print ("(", e.exploder.script_exploder, ", \"", e.id, "\", (", int(e.org[0]), ",", int(e.org[1]), ",", int(e.org[2]), "), ", e.delay);
							print (", (", int(e.org2[0]), ",", int(e.org2[1]), ",", int(e.org2[2]), ")");
							if (isdefined(firefx))
								print (", \"", firefx, "\"");
							else
								print (", undefined");
								
							if (isdefined(firefxdelay))
								print (", ", firefxdelay);
							else
								print (", undefined");
								
							if (isdefined(firefxsound))
								print (", \"", firefxsound, "\"");
							else
								print (", undefined");

							if (isdefined(e.exploder.script_soundalias))
							{
								print (", undefined");
								print (", undefined");
								print (", undefined");
								print (", \"", e.exploder.script_soundalias, "\"");
							}
						}
						else
						{
							print ("	maps\\mp\\_fx::", e.type);
							print ("(", e.exploder.script_exploder, ", \"", e.id, "\", (", int(e.org[0]), ",", int(e.org[1]), ",", int(e.org[2]), "), ", e.delay);
							print (", (", int(e.org2[0]), ",", int(e.org2[1]), ",", int(e.org2[2]), ")");
						}
					}
					else
					if (e.type == "loopfx")
					{
						print ("	maps\\mp\\_fx::", e.type);
						print ("(\"", e.id, "\", (", int(e.org[0]), ",", int(e.org[1]), ",", int(e.org[2]), "), ", e.delay);
						print (", (", int(e.org2[0]), ",", int(e.org2[1]), ",", int(e.org2[2]), ")");
					}
					else
					if (e.type == "soundfx")
					{
						print ("	maps\\mp\\_fx::", e.type);
						print ("(\"", e.id, "\", (", int(e.org[0]), ",", int(e.org[1]), ",", int(e.org[2]), ")");
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
				println ("^3 No such thing as level._effect[\"", msg, "^3\"]");
			setcvar("effect_name", "");
		}

		if (getcvar("effect_sound") != "")
		{
			msg = getcvar("effect_sound");
			sound = msg;
			soundName = msg;
			if (isdefined (ent.selected))
				createfx_recreate(ent, soundName);
			setcvar("effect_sound", "");
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
				}
//					createfx_delete(ent.selected);
//					level thread maps\mp\_fx::loopfxthread (effectName, ent.org.origin, getcvarfloat("effect_delay"), ent.org.origin2);
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
					}
					if (isdefined (effectName))
						createfx_recreate(ent, effectName);
					else
						createfx_recreate(ent, soundName);
				}
//					createfx_delete(ent.selected);
//					level thread maps\mp\_fx::loopfxthread (effectName, ent.org.origin, getcvarfloat("effect_delay"), ent.org.origin2);
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
			if ((oldOrigin != ent.org.desired_origin) && (isdefined (ent.selected)) && (ent.selected.type == "exploderfx" || ent.selected.type == "soundfx"))
			{
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
					createfx_recreate(ent, soundName);
			}
			
		}
		if (isdefined (ent.selected))
		{
			ent.selected.org = ent.org.origin;
			ent.selected.org2 = ent.org.origin2; // <- yaw?
			ent.selected notify ("effect org changed", ent.org.origin);
		}
	
		oldDelay = getcvarfloat ("effect_delay");			

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

		print3d (org.origin + (0,0,-3.0) + right, "x", (1.0 - col[0], 1.0 - col[1], 1.0 - col[2]), 1, 0.5);	// origin, text, RGB, alpha, scale
		print3d (org.origin2 + (0,0,-3.0) + right, "o", (1.0 - col[0], 1.0 - col[1], 1.0 - col[2]), 1, 0.5);	// origin, text, RGB, alpha, scale


		for (i=num-1;i>0;i--)
			oldAngles[i] = oldAngles[i-1];

		for (i=num-1;i>0;i--)
			oldColor[i] = oldColor[i-1];
		
//		line (org.origin + (0,scale * -1, 0), org.origin + (0,scale, 0), color);
//		line (org.origin + (scale * -1, 0, 0), org.origin + (scale, 0, 0), color);
	}
}


createfx_showOrigin (id, org, delay, org2, type, exploder, id2)
{
	if (!isdefined (level.createFX))
		level.createFX = [];
	
	ent = spawnstruct();
	ent.id = id;
	ent.id2 = id2;
	ent.org = org;
	ent.delay = delay;
	ent.type = type;

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
			if (ent.type == "soundfx")
			{
				if ((isdefined (e.selected)) && (e.selected == ent))
					color = (1.0, 1.0, 0.2);
				else
				if (ent.highlight)
					color = (.5, 1.0, 0.75);
				else
					color = (.2, 0.9, 0.2);
			}
			else
			{
				if ((isdefined (e.selected)) && (e.selected == ent))
					color = (1.0, 1.0, 0.2);
				else
				if (ent.highlight)
					color = (.8, .95, 1);
				else
					color = (.3, .8, 1);
			}
			
			angles = level.player.angles;
			right = anglestoright (angles);
			right = vectorScale(right, ent.id.size * -2.93);
				
//			print3d (ent.org + right, ent.org, color, 1, 0.75);	// origin, text, RGB, alpha, scale
			if (distancesquared(level.player.origin, ent.org) > 9000000) // 1200x1200
				continue;
			print3d (ent.org + right, ent.id, color, 1, 0.75);	// origin, text, RGB, alpha, scale

			if (ent.type == "exploderfx")
			{
				print3d (ent.org + right + (0,0,-15), "exploder: " + ent.exploder.script_exploder, color, 1, 0.75);	// origin, text, RGB, alpha, scale
				if (isdefined (ent.exploder.script_soundalias))
					print3d (ent.org + right + (0,0,-30), "alias: " + ent.exploder.script_soundalias, color, 1, 0.75);	// origin, text, RGB, alpha, scale
			}
			else
			if (isdefined (ent.soundalias))
				print3d (ent.org + right + (0,0,-15), "alias: " + ent.soundalias, color, 1, 0.75);	// origin, text, RGB, alpha, scale
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
	if (selected.type == "soundfx")
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
		level thread exploderfxWrapper (num, effectName, ent.org.origin, getcvarfloat("effect_delay"), ent.org.origin2, ent.selected.soundalias);
	else
	if (type == "loopfx")
		level thread maps\mp\_fx::loopfxthread (effectName, ent.org.origin, getcvarfloat("effect_delay"), ent.org.origin2 );
	else
	if (type == "soundfx")
		level thread maps\mp\_fx::soundfx (effectName, ent.org.origin);
		

	ent.selected = level.createFX[level.createFX.size-1];
}

exploderfxWrapper (num, effectName, org, delay, org2, soundalias)
{
	firefx = undefined;
	if (getcvar("effect_firefx") != "")
	{
		firefx = getcvar("effect_firefx");
		if (!isdefined (level._effect[firefx]))
			firefx = undefined;
	}

	firefxdelay = undefined;
	if (getcvar("effect_firefxdelay") != "")
		firefxdelay = getcvarfloat ("effect_firefxdelay");

	firefxsound = undefined;
	if (getcvar("effect_firefxsound") != "")
		firefxsound = getcvar ("effect_firefxsound");
	maps\mp\_fx::exploderfx (num, effectName, org, delay, org2, firefx, firefxdelay, firefxsound, undefined, undefined, undefined, soundalias);
}
