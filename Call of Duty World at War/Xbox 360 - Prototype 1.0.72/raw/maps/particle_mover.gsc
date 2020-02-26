#include maps\_utility;
main()
{
	// For level._effect["X"]s, X can be whatever makes sense to the scritper. 
	// The loadfx() call needs to point to a valid effect, however.
	level._effect["effect1"]	= loadfx ("misc/fx_axis_test_world");
	level._effect["effect2"]	= loadfx ("misc/fx_axis_test_effect_spawn");
	level._effect["effect3"]	= loadfx ("misc/fx_axis_test_effect_now");
  level._effect["effect4"]	= loadfx ("misc/test_trail");
	
	// speed of movement from point to point, up this to go slower
	level.movespeed = 2.0;
	



	// dont worry about anything below here!
	maps\_load::main();

	if (level.xenon)
	{
		level.play_button = "BUTTON_X";
		level.stop_button = "BUTTON_RTRIG";
		level.speed_up 		= "BUTTON_Y";
		level.speed_down 	= "BUTTON_A";
	}
	else
	{
		level.play_button = "f";
		level.stop_button = "v";
		level.speed_up 		= "g";
		level.speed_down 	= "b";
	}
	
	level.particle_array = [];	
	level.move_toggle = true;
	
	// start the movers
	ent = getent( "effect1", "targetname" );
	ent thread particle_movers();
	
	ent = getent( "effect2", "targetname" );
	ent thread particle_movers();
	
	ent = getent( "effect3", "targetname" );
	ent thread particle_movers();
	
	ent = getent( "effect4", "targetname" );
	ent thread particle_movers();
	
	ent = getent( "static1", "targetname" );
	ent.targetname = ent.targetname + "_org";		
	level.particle_array[level.particle_array.size] = ent;
	
	ent = getent( "static2", "targetname" );
	ent.targetname = ent.targetname + "_org";
	level.particle_array[level.particle_array.size] = ent;
	
	ent = getent( "static3", "targetname" );
	ent.targetname = ent.targetname + "_org";
	level.particle_array[level.particle_array.size] = ent;
	
	ent = getent( "static4", "targetname" );
	ent.targetname = ent.targetname + "_org";
	level.particle_array[level.particle_array.size] = ent;
	
	org = getent( "spawned1", "targetname" );
	ent = spawn ("script_origin", org.origin);
	ent.targetname = org.targetname + "_org";
	level.particle_array[level.particle_array.size] = ent;
	
	org = getent( "spawned2", "targetname" );
	ent = spawn ("script_origin", org.origin);
	ent.targetname = org.targetname + "_org";
	level.particle_array[level.particle_array.size] = ent;
	
	org = getent( "spawned3", "targetname" );
	ent = spawn ("script_origin", org.origin);
	ent.targetname = org.targetname + "_org";
	level.particle_array[level.particle_array.size] = ent;
	
	org = getent( "spawned4", "targetname" );
	ent = spawn ("script_origin", org.origin);
	ent.targetname = org.targetname + "_org";
	level.particle_array[level.particle_array.size] = ent;
	
	thread particle_play();
	thread particle_stop();
	thread particle_speed();
}

// Moves the script origin around
particle_movers()
{
	current = self;
	org = spawn("script_model", current.origin);
	org setmodel ("viewmodel_ussmokegrenade");
	org.targetname = current.targetname + "_org";
	org.angles = current.angles + (270,0,90);
	
	level.particle_array[level.particle_array.size] = org;
	
	while(1)
	{	
		while (!level.move_toggle)
		{
			wait (0.05);
		}
		next = getent(current.target, "targetname");
		org moveto (next.origin, level.movespeed, 0.1, 0.1);
		org waittill ("movedone");
		org.angles = next.angles + (270,0,90);
		current = next;			
	}
}

// Plays FX when the player presses USE
particle_play()
{
	while (1)
	{
		if (get_players()[0] buttonpressed(level.play_button))
		{
			for (i = 0; i < level.particle_array.size; i++)
			{
				if ( level.particle_array[i].targetname == "effect1_org")
				{
					playfxontag( level._effect["effect1"], level.particle_array[i], "tag_flash");
				}
				else if (level.particle_array[i].targetname == "effect2_org")
				{
					playfxontag( level._effect["effect2"], level.particle_array[i], "tag_flash" );
				}
				else if (level.particle_array[i].targetname == "effect3_org")
				{
					playfxontag( level._effect["effect3"], level.particle_array[i], "tag_flash" );
				}
				else if (level.particle_array[i].targetname == "effect4_org")
				{
					playfxontag( level._effect["effect4"], level.particle_array[i], "tag_flash" );
				}	
				else if ( level.particle_array[i].targetname == "static1_org")
				{
					playfx( level._effect["effect1"], level.particle_array[i].origin);
				}
				else if (level.particle_array[i].targetname == "static2_org")
				{
					playfx( level._effect["effect2"], level.particle_array[i].origin);
				}
				else if (level.particle_array[i].targetname == "static3_org")
				{
					playfx( level._effect["effect3"], level.particle_array[i].origin);
				}
				else if (level.particle_array[i].targetname == "static4_org")
				{
					playfx( level._effect["effect4"], level.particle_array[i].origin);
				}	
				else if ( level.particle_array[i].targetname == "spawned1_org")
				{
					playfx( level._effect["effect1"], level.particle_array[i].origin);
				}
				else if (level.particle_array[i].targetname == "spawned2_org")
				{
					playfx( level._effect["effect2"], level.particle_array[i].origin);
				}
				else if (level.particle_array[i].targetname == "spawned3_org")
				{
					playfx( level._effect["effect3"], level.particle_array[i].origin);
				}
				else if (level.particle_array[i].targetname == "spawned4_org")
				{
					playfx( level._effect["effect4"], level.particle_array[i].origin);
				}	
			}
			wait (0.25);
		}
		wait (0.05);
	}
}

particle_stop()
{
	while (1)
	{
		if (get_players()[0] buttonpressed(level.stop_button))
		{
				if (	level.move_toggle )
				{
						level.move_toggle = false;
				}
				else
				{
						level.move_toggle = true;
				}
				wait (0.25);
		}
		wait (0.05);
	}
}

particle_speed()
{
	while (1)
	{
		if (get_players()[0] buttonpressed(level.speed_down))
		{
				level.movespeed = level.movespeed + 0.5;
				wait (0.25);
		}
		else if (get_players()[0] buttonpressed(level.speed_up))
		{
				if (level.movespeed - 1 <= 0.2)
				{
					level.movespeed = 0.2;
				}
				else
				{
					level.movespeed = level.movespeed - 0.5;
				}
				wait (0.25);
		}
		wait (0.05);
	}
}