#include common_scripts\utility;
#include maps\_utility;

feature_start()
{
	flag_init( "title_screen_done" );
	flag_init( "updating_hud" );

	wait_for_all_players();

	player = get_players()[0];
	
	if( is_true( level.enable_player_vulnerability ) )
	{
		// disable if enabled before
		player DisableInvulnerability();
	}
	else
	{
		player EnableInvulnerability();
	}
	
	if (IsDefined(level.title_screen))
	{
		title_screen(level.title_screen);
	}
	else
	{
		flag_set("title_screen_done");
	}

	level thread cycle_start_points();
	level thread watch_area_dvar();

	// setup for selecting AI animType through the devgui
	level thread setup_devgui();
	level thread setup_animTypes();

	add_global_spawn_function( "axis", ::ai_spawned );
	//add_global_spawn_function( "allies", ::ai_spawned );
	//add_global_spawn_function( "neutral", ::ai_spawned );
	
	// get rid of the flash grenade
	player thread remove_flash_grenade();

	//make sure the player always has ammo
	player thread infinite_ammo();
}

remove_flash_grenade()
{
	self endon("death");

	// wait till it's given
	wait(0.5);

	self SetActionSlot(4, "");
	self TakeWeapon( "flash_grenade_sp" );
}

//self is the player
infinite_ammo()
{
	self endon("death");
	
	while(1)
	{
		weapon = self GetCurrentWeapon();
		
		if( IsDefined( weapon ) && ( weapon != "none" ) )
		{
			self GiveMaxAmmo( weapon );
		}
		
		wait(1);
	}
}

cycle_start_points()
{
	current_point = -1;

	while (true)
	{
		player = get_players()[0];
		if (player ButtonPressed("BUTTON_LSHLDR"))
		{
			if (player ButtonPressed("DPAD_UP"))
			{
				current_point++;
				if (current_point >= level.start_points.size)
				{
					current_point = 0;
				}
			}
			else if (player ButtonPressed("DPAD_DOWN"))
			{
				current_point--;
				if (current_point < 0)
				{
					current_point = level.start_points.size - 1;
				}
			}
			else
			{
				wait .05;
				continue;
			}

			if (IsDefined(level.start_points[current_point]))
			{
				player SetPlayerAngles(level.start_points[current_point].angles);
				player SetOrigin(level.start_points[current_point].origin);
				wait .5;
			}
		}

		wait .05;
	}
}

watch_area_dvar()
{
	current_area = "";
	while (true)
	{
		area = GetDvar("test_map_area");
		if (area != current_area)
		{
			for (i = 0; i < level.start_points.size; i++)
			{
				point = level.start_points[i];
				if (point.area_name == area)
				{
					current_area = area;

					player = get_players()[0];
					player SetPlayerAngles(point.angles);
					player SetOrigin(point.origin);

					break;
				}
			}
		}

		wait .05;
	}
}

title_screen(title)
{
	hud_fullscreen = NewHudElem();
	hud_fullscreen.x = 0;
	hud_fullscreen.y = 0;
	hud_fullscreen.horzAlign = "fullscreen";
	hud_fullscreen.vertAlign = "fullscreen";
	hud_fullscreen SetShader("black", 640, 480);
	hud_fullscreen.sort = 100;

	hud_title = undefined;
	if (IsDefined(title["title"]))
	{
		hud_title = NewHudElem();
		hud_title.font = "bigfixed";
		hud_title.x = 0;
		hud_title.y = 0;
		hud_title.horzAlign = "left";
		hud_title.vertAlign = "top";
		hud_title.sort = 101;
		hud_title SetText(title["title"]);
		hud_title.color = (0.3568, 0.4588, 0.5568);
	}

	desc_height = 0;
	if (IsDefined(title["desc"]))
	{
		for (i = 0; i < title["desc"].size; i++)
		{
			desc_height = 30 * (i + 1);

			hud_desc = NewHudElem();
			title["desc_elems"][i] = hud_desc;

			hud_desc.font = "objective";
			hud_desc.fontscale = 2;
			hud_desc.x = 0;
			hud_desc.y = desc_height;
			hud_desc.horzAlign = "left";
			hud_desc.vertAlign = "top";
			hud_desc.sort = 101;
			hud_desc SetText(title["desc"][i]);
			hud_desc.color = (0.7, 0.7, 0.7);
		}
	}

	bullet_height = 0;
	if (IsDefined(title["bullets"]))
	{
		for (i = 0; i < title["bullets"].size; i++)
		{
			bullet_height = 20 * (i + 1) + desc_height + 30;

			hud_bullet = NewHudElem();
			title["bullet_elems"][i] = hud_bullet;

			hud_bullet.font = "objective";
			hud_bullet.fontscale = 1.2;
			hud_bullet.x = 0;
			hud_bullet.y = bullet_height;
			hud_bullet.horzAlign = "left";
			hud_bullet.vertAlign = "top";
			hud_bullet.sort = 101;
			hud_bullet SetText("* " + title["bullets"][i]);
			hud_bullet.color = (0.7, 0.7, 0.7);
		}
	}

	additional_height = 0;
	if (IsDefined(title["additional"]))
	{
		for (i = 0; i < title["additional"].size; i++)
		{
			additional_height = 30 * (i + 1) + bullet_height + 50;

			hud_additional = NewHudElem();
			title["additional_elems"][i] = hud_additional;

			hud_additional.font = "objective";
			hud_additional.fontscale = 2;
			hud_additional.x = 0;
			hud_additional.y = additional_height;
			hud_additional.horzAlign = "left";
			hud_additional.vertAlign = "top";
			hud_additional.sort = 101;
			hud_additional SetText(title["additional"][i]);
			hud_additional.color = (0.7, 0.7, 0.7);
		}
	}

	hud_cycle_start_points = undefined;
	if (IsDefined(level.start_points))
	{
		hud_cycle_start_points = NewHudElem();
		hud_cycle_start_points.font = "big";
		hud_cycle_start_points.fontscale = 1.2;
		hud_cycle_start_points.y = -50;
		hud_cycle_start_points.alignX = "center";
		hud_cycle_start_points.alignY = "middle";
		hud_cycle_start_points.horzAlign = "center";
		hud_cycle_start_points.vertAlign = "bottom";
		hud_cycle_start_points.sort = 101;
		hud_cycle_start_points SetText("Press LB + DPAD UP/DPAD DOWN to cycle through spawn areas, or use the \"Jump To\" menu to pick a spot.");
		hud_cycle_start_points.color = (0.3568, 0.4588, 0.5568);
	}

	hud_continue = NewHudElem();
	hud_continue.font = "bigfixed";
	hud_continue.fontscale = 1;
 	hud_continue.y = -30;
	hud_continue.alignX = "center";
	hud_continue.alignY = "middle";
	hud_continue.horzAlign = "center";
	hud_continue.vertAlign = "bottom";
	hud_continue.sort = 101;
	hud_continue SetText("Press X to continue");
	hud_continue.color = (0.8980, 0.7176, 0.2705);

	while (!get_players()[0] ButtonPressed("BUTTON_X"))
	{
		wait .05;
	}

	flag_set("title_screen_done");

	if (IsDefined(hud_cycle_start_points))
	{
		hud_cycle_start_points Destroy();
	}

	hud_fullscreen Destroy();
	hud_continue Destroy();

	if (IsDefined(hud_title))
	{
		hud_title Destroy();
	}

	if (IsDefined(title["desc_elems"]))
	{
		for (i = 0; i < title["desc_elems"].size; i++)
		{
			title["desc_elems"][i] Destroy();
		}
	}
	
	if (IsDefined(title["bullet_elems"]))
	{
		for (i = 0; i < title["bullet_elems"].size; i++)
		{
			title["bullet_elems"][i] Destroy();
		}
	}

	if (IsDefined(title["additional_elems"]))
	{
		for (i = 0; i < title["additional_elems"].size; i++)
		{
			title["additional_elems"][i] Destroy();
		}
	}
}

hint_popup( hint_string, display_time )
{
	if( !isdefined( hint_string ) )
	{
		println( "hint_popup passed invalid parameters" );
		return;
	}
	
	if( !IsDefined( display_time ) )
	{
		display_time = 3.0;
	}
	
	screen_message_create( hint_string );
	
	wait( display_time );
	
	screen_message_delete();
}

spawn_area(area, func, narration_text, shouldLabel)
{
	loop = false;
	one_area_at_a_time = !IsDefined(level.one_area_at_a_time) || level.one_area_at_a_time;

	trig = GetEnt("trig_" + area, "targetname");
	assert(IsDefined(trig), "Trying to set up a spawn area '" + area + "' with an undefined trigger.");
	
	if (IsDefined(narration_text))
	{
		level.narration[area] = narration_text;
	}

	// Add teleport point to array
	if (IsDefined(trig.target))
	{
		if (!IsDefined(level.start_points))
		{
			level.start_points = [];
		}

		start_point = getstruct(trig.target, "targetname");
		start_point.area_name = area;
		level.start_points = array_add(level.start_points, start_point);

		area_desc = area;
		if (IsDefined(level.narration) && IsDefined(level.narration[area]))
		{
			area_desc = level.narration[area];
		}

		AddDebugCommand("devgui_cmd \"Jump To/" + area_desc + ":" + level.start_points.size + "\" \"set test_map_area " + area + "\"\n");
	}

	if (IsDefined(level.narration) && IsDefined(level.narration[area]))
	{
		trig_narration = GetEnt("trig_narration_" + area, "targetname");
		if (IsDefined(trig_narration))	// special narration trigger?
		{
			trig_narration thread narrate(level.narration[area]);
		}
		else if (IsDefined(trig))	// else use spawn trigger
		{
			trig thread narrate(level.narration[area]);
		}
	}

	label = GetEnt("label_" + area, "targetname");
	if (IsDefined(label))
	{
		label thread label(level.narration[area]);
	}

	loop = true;

	level waittill("title_screen_done");

	while (loop)
	{
		if (IsDefined(trig))
		{
			trig waittill("trigger");

			if (IsDefined(level.feature_new_area_callback))
			{
				[[ level.feature_new_area_callback ]]();
			}

			if (one_area_at_a_time)
			{
				level notify("clear_level");
				array_func(GetAIArray(), ::self_delete);
			}
		}
		else
		{
			loop = false;
		}

		guys = [];

		spawners = GetEntArray(area, "targetname");
		for (i = 0; i < spawners.size; i++)
		{
			if (!spawners[i] is_spawner())
			{
				spawners = array_remove(spawners, spawners[i]);
			}
		}

		if (spawners.size)
		{
			guys = simple_spawn(spawners);
		}

		delete_guys = undefined;
		if (IsDefined(func))
		{
			delete_guys = spawn_area_func(func, guys);
		}
		else if (guys.size)
		{
			waittill_dead(guys);
		}

		if (!IsDefined(delete_guys) || delete_guys)
		{
			corpse_cleanup();

			for( i=0; i < guys.size; i++ )
			{
				if( IsDefined(guys[i]) )
				{
					guys[i] Delete();
				}
			}
		}
	}
}

destroy_tutorial_hud()
{	
	if( isdefined( level.tutorial_hud ) )
	{
		if( isdefined( level.tutorial_hud.hud_title ) )
		{
			level.tutorial_hud.hud_title Destroy();  // title is only one field
		}
		
		
		if( IsDefined( level.tutorial_hud.hud_bullet ) && ( level.tutorial_hud.hud_bullet.size > 0 ) )
		{
			for( i = 0; i < level.tutorial_hud.hud_bullet.size; i++ )
			{
				if( IsDefined( level.tutorial_hud.hud_bullet[ i ] ) )
				{
					level.tutorial_hud.hud_bullet[ i ] Destroy();
				}
			}
			
			level.tutorial_hud.hud_bullet = remove_dead_from_array( level.tutorial_hud.hud_bullet );
		}
		
		if( IsDefined( level.tutorial_hud.hud_desc ) && ( level.tutorial_hud.hud_desc.size > 0 ) )
		{
			for( i = 0; i < level.tutorial_hud.hud_desc.size; i++ )
			{
				if( IsDefined( level.tutorial_hud.hud_desc[ i ] ) )
				{
					level.tutorial_hud.hud_desc[ i ] Destroy();
				}
			}
			
			level.tutorial_hud.hud_desc = remove_dead_from_array( level.tutorial_hud.hud_desc );
		}
		
		if( IsDefined( level.tutorial_hud.hud_additional ) && ( level.tutorial_hud.hud_additional.size > 0 ) )
		{
			for( i = 0; i < level.tutorial_hud.hud_additional.size; i++ )
			{
				if( IsDefined( level.tutorial_hud.hud_additional[ i ] ) )
				{
					level.tutorial_hud.hud_additional[ i ] Destroy();
				}
			}
			
			level.tutorial_hud.hud_additional = remove_dead_from_array( level.tutorial_hud.hud_additional );
		}
		
		if( IsDefined( level.tutorial_hud.addons ) && ( level.tutorial_hud.addons.size > 0 ) )
		{
			for( i = 0; i < level.tutorial_hud.addons.size; i++ )
			{
				if( IsDefined( level.tutorial_hud.addons[ i ] ) )
				{
					level.tutorial_hud.addons[ i ] Destroy();
				}
			}
			
			level.tutorial_hud.addons = remove_dead_from_array( level.tutorial_hud.addons );
		}		
	}
	else
	{
		println( "no tutorial hud exists!" );
	}
}

setup_detailed_narration(title)
{
	tutorial_hud = title;
	
	if( !isdefined( level.tutorial_hud ) )
	{
		level.tutorial_hud = SpawnStruct();
	}
	
	if( !IsArray( title ) )  // in case this is passed a string instead of an array
	{
		level.tutorial_hud.hud_title = NewHudElem();
		level.tutorial_hud.hud_title.font = "bigfixed";
		level.tutorial_hud.hud_title.x = 0;
		level.tutorial_hud.hud_title.y = 0;
		level.tutorial_hud.hud_title.horzAlign = "left";
		level.tutorial_hud.hud_title.vertAlign = "top";
		level.tutorial_hud.hud_title.sort = 101;
		level.tutorial_hud.hud_title SetText( title );
		level.tutorial_hud.hud_title.color = (0.3568, 0.4588, 0.5568);	
		
		level.tutorial_hud.safe_hud_pos = 30;
		
		return;
	}
	
	hud_title = undefined;
	title_height = 0;
	if (IsDefined(title["title"]))
	{
		level.tutorial_hud.hud_title = NewHudElem();
		level.tutorial_hud.hud_title.font = "bigfixed";
		level.tutorial_hud.hud_title.x = 0;
		level.tutorial_hud.hud_title.y = 0;
		level.tutorial_hud.hud_title.horzAlign = "left";
		level.tutorial_hud.hud_title.vertAlign = "top";
		level.tutorial_hud.hud_title.sort = 101;
		level.tutorial_hud.hud_title SetText(title["title"]);
		level.tutorial_hud.hud_title.color = (0.3568, 0.4588, 0.5568);
		
		title_height = 30;
	}

	desc_height = 0;
	if (IsDefined(title["desc"]))
	{
		level.tutorial_hud.hud_desc = [];
		
		for (i = 0; i < title["desc"].size; i++)
		{
			desc_height = 30 * (i + 1);

			level.tutorial_hud.hud_desc[ i ] = NewHudElem();
			//title["desc_elems"][i] = level.tutorial_hud.hud_desc;

			level.tutorial_hud.hud_desc[ i ].font = "objective";
			level.tutorial_hud.hud_desc[ i ].fontscale = 1.75;
			level.tutorial_hud.hud_desc[ i ].x = 0;
			level.tutorial_hud.hud_desc[ i ].y = desc_height;
			level.tutorial_hud.hud_desc[ i ].horzAlign = "left";
			level.tutorial_hud.hud_desc[ i ].vertAlign = "top";
			level.tutorial_hud.hud_desc[ i ].sort = 101;
			level.tutorial_hud.hud_desc[ i ] SetText(title["desc"][i]);
			level.tutorial_hud.hud_desc[ i ].color = (0.7, 0.7, 0.7);
		}
	}

	bullet_height = 0;
	if (IsDefined(title["bullets"]))
	{
		level.tutorial_hud.hud_bullet = [];
		
		for (i = 0; i < title["bullets"].size; i++)
		{
			bullet_height = 20 * (i + 1) + desc_height + 30;

			level.tutorial_hud.hud_bullet[ i ] = NewHudElem();
			//title["bullet_elems"][i] = level.tutorial_hud.hud_bullet;

			level.tutorial_hud.hud_bullet[ i ].font = "objective";
			level.tutorial_hud.hud_bullet[ i ].fontscale = 1.5;
			level.tutorial_hud.hud_bullet[ i ].x = 0;
			level.tutorial_hud.hud_bullet[ i ].y = bullet_height;
			level.tutorial_hud.hud_bullet[ i ].horzAlign = "left";
			level.tutorial_hud.hud_bullet[ i ].vertAlign = "top";
			level.tutorial_hud.hud_bullet[ i ].sort = 101;
			level.tutorial_hud.hud_bullet[ i ] SetText("* " + title["bullets"][i]);
			level.tutorial_hud.hud_bullet[ i ].color = (0.7, 0.7, 0.7);
		}
	}

	additional_height = 0;
	if (IsDefined(title["additional"]))
	{
		level.tutorial_hud.hud_additional = [];
		
		for (i = 0; i < title["additional"].size; i++)
		{
			additional_height = 30 * (i + 1) + bullet_height + 50;

			level.tutorial_hud.hud_additional[ i ] = NewHudElem();
			//title["additional_elems"][i] = level.tutorial_hud.hud_additional;

			level.tutorial_hud.hud_additional[ i ].font = "objective";
			level.tutorial_hud.hud_additional[ i ].fontscale = 2;
			level.tutorial_hud.hud_additional[ i ].x = 0;
			level.tutorial_hud.hud_additional[ i ].y = additional_height;
			level.tutorial_hud.hud_additional[ i ].horzAlign = "left";
			level.tutorial_hud.hud_additional[ i ].vertAlign = "top";
			level.tutorial_hud.hud_additional[ i ].sort = 101;
			level.tutorial_hud.hud_additional[ i ] SetText(title["additional"][i]);
			level.tutorial_hud.hud_additional[ i ].color = (0.7, 0.7, 0.7);
		}
	}
	
	level.tutorial_hud.safe_hud_pos = title_height + desc_height + bullet_height + additional_height;
}


narrate_detailed(detailed_text)
{
	self endon( "death" );
		
	while (true)
	{
		self waittill("trigger", ent);
		
		if( !IsDefined( level.tutorial_hud_zone ) || level.tutorial_hud_zone != self ) // should we update hud?
		{
			flag_set( "updating_hud" );
			destroy_tutorial_hud();
			level.tutorial_hud_zone = self; 
			setup_detailed_narration( detailed_text );
			flag_clear_delayed( "updating_hud", 0.25 );
			
			while( ent IsTouching( self ) )
			{
				wait( 0.25 );
			}
			
			if( !flag( "updating_hud" ) )
			{
				destroy_tutorial_hud();
				level.tutorial_hud_zone = undefined;
			}
		}
		
		wait .25;
	}
}



// this is another spawn_area function, but with multi-line text capability. use setup_detailed_narration() for narration_text array
spawn_area_detailed( area, func, narration_text, hud_function, should_loop)
{
	if(!IsDefined(should_loop))
	{
		should_loop = true;
	}
	
	one_area_at_a_time = !IsDefined(level.one_area_at_a_time) || level.one_area_at_a_time;

	trig = GetEnt("trig_" + area, "targetname");
	assert(IsDefined(trig), "Trying to set up a spawn area '" + area + "' with an undefined trigger.");
	
	if (IsDefined(narration_text))
	{
		if( IsArray( narration_text ) )
		{
			if( IsDefined( narration_text[ "title" ] ) )
			{
				level.narration[ area ] = narration_text[ "title" ];
			}
		}
		else
		{
			level.narration[area] = narration_text;
		}
	}

	// Add teleport point to array
	if (IsDefined(trig.target))
	{
		if (!IsDefined(level.start_points))
		{
			level.start_points = [];
		}

		start_point = getstruct(trig.target, "targetname");
		start_point.area_name = area;
		level.start_points = array_add(level.start_points, start_point);

		area_desc = area;
		if (IsDefined(level.narration) && IsDefined(level.narration[area]))
		{
			area_desc = level.narration[area];
		}

		AddDebugCommand("devgui_cmd \"Jump To/" + area_desc + ":" + level.start_points.size + "\" \"set test_map_area " + area + "\"\n");
	}

	if (IsDefined(level.narration) && IsDefined(level.narration[area]))
	{
		trig_narration = GetEnt("trig_narration_" + area, "targetname");
		if (IsDefined(trig_narration))	// special narration trigger?
		{
			trig_narration thread narrate_detailed( narration_text );
		}
		else if (IsDefined(trig))	// else use spawn trigger
		{
			trig thread narrate_detailed( narration_text );
		}
	}

	label = GetEnt("label_" + area, "targetname");
	if (IsDefined(label))
	{
		label thread label(level.narration[area]);
	}

	level waittill("title_screen_done");
	
	loop = true;

	while (loop)
	{
		if (IsDefined(trig))
		{
			trig waittill("trigger");

			if (IsDefined(level.feature_new_area_callback))
			{
				[[ level.feature_new_area_callback ]]();
			}

			if (one_area_at_a_time)
			{
				level notify("clear_level");
				array_func(GetAIArray(), ::self_delete);
			}
			
			if (!should_loop)
			{
				loop = false;
			}
		}
		else
		{
			loop = false;
		}

		if( IsDefined( hud_function ) && IsDefined( trig ) )
		{
			trig thread spawn_area_func( hud_function );  // , "new_tutorial_zone"
		}		
		
		guys = [];

		spawners = GetEntArray(area, "targetname");
		for (i = 0; i < spawners.size; i++)
		{
			if (!spawners[i] is_spawner())
			{
				spawners = array_remove(spawners, spawners[i]);
			}
		}

		if (spawners.size)
		{
			guys = simple_spawn(spawners);
		}

		delete_guys = undefined;
		if (IsDefined(func))
		{
			delete_guys = spawn_area_func(func, guys);
		}
		else if (guys.size)
		{
			waittill_dead(guys);
		}
		
		if( should_loop )
		{
			if (!IsDefined(delete_guys) || delete_guys)
			{
				corpse_cleanup();

				for( i=0; i < guys.size; i++ )
				{
					if( IsDefined(guys[i]) )
					{
						guys[i] Delete();
					}
				}
			}
		}
	}
}


// returns hud element addon for use with in-game explanation text. Useful for adding hud messages that need to be updated, as
// it's designed to take in the last safe position of the tutorial hud so it displays below it 
new_addon_hud_elem() // self = trigger
{	
	while( flag( "updating_hud" ) || !IsDefined( level.tutorial_hud_zone ) )  // when hud is updating, addons get destroyed. make sure it's clear to add new elements first
	{
		wait( 0.05 );
	}
	
	if( !IsDefined( level.tutorial_hud ) || !IsDefined( level.tutorial_hud.safe_hud_pos ) )
	{
		println( "can't add new_tutorial_hud_elem, missing tutorial_hud" );
		return;
	}	
	
	if (!IsDefined(level.tutorial_hud.addons))
	{
		level.tutorial_hud.addons = [];
	}
	
	start_pos = 415;  // bottom of the screen
	
	index = level.tutorial_hud.addons.size;

	level.tutorial_hud.addons[ index ] = NewHudElem(); 
	level.tutorial_hud.addons[ index ].alignX = "left";
	level.tutorial_hud.addons[ index ].horzAlign = "left";
	level.tutorial_hud.addons[ index ].x = 0; 
	level.tutorial_hud.addons[ index ].y = start_pos + ( index * ( -30 ) ); // start at the bottom of the screen and move up with each new addon
	level.tutorial_hud.addons[ index ].fontscale = 2;
	level.tutorial_hud.addons[ index ].color = ( 0.8, 1, 0.8 );
	level.tutorial_hud.addons[ index ] SetText( "" );
	
	return level.tutorial_hud.addons[ index ];
}



spawn_area_func(func, guys)
{
	level endon("clear_level");
	
	if( IsDefined( guys ) && guys.size > 0 )
		return [[ func ]](guys);
	else
		return [[ func ]]();
}

narrate(text)
{
	if (!IsDefined(level.narration_hud))
	{
		level.narration_hud = NewHudElem(); 
		level.narration_hud.alignX = "left";
		level.narration_hud.horzAlign = "left";
		level.narration_hud.x = 0; 
		level.narration_hud.y = 50;
		level.narration_hud.fontscale = 2.25;
		level.narration_hud.color = ( 0.8, 1, 0.8 );
	}

	volumes = getentarray( "vol_narrate", "script_noteworthy" );
//	array_thread( volumes, ::narrate_thread );
		
	

	level.narration_hud_text = "";

	while (true)
	{
		self waittill("trigger", ent);
		
		destroy_tutorial_hud();  // if using spawn_area_detailed, it's created there
		if( IsDefined( level.tutorial_hud_zone ) )
		{
			level.tutorial_hud_zone = self;
		}
		
		if (level.narration_hud_text == "")
		{
			level.narration_hud SetText(text);
			level.narration_hud_text = text;

			while (ent IsTouching(self))
			{
				wait_network_frame();
			}

			level.narration_hud SetText("");
			level.narration_hud_text = "";
		}

		wait .1;
	}
}

corpse_cleanup()
{
// 	entaVis_ents = entsearch( level.CONTENTS_CORPSE, (0, 0, 0), 4000 );	// no work
// 	for( i = 0; isdefined(entaVis_ents) && i < entaVis_ents.size; i++ )
// 	{
// 		entaVis_ents[i] delete();
// 	}
}

label(text)
{
	while (true)
	{
		print3d( self.origin, text, (1,1,1), 1, 2, 1 );

		wait 0.05;
	}
}

setup_animTypes()
{
	wait_for_first_player();

	animTypeArray = [];
	animTypeArray[ animTypeArray.size ] = "default";
	animTypeArray[ animTypeArray.size ] = "vc";
	animTypeArray[ animTypeArray.size ] = "spetsnaz";
	//animTypeArray[ animTypeArray.size ] = "civilian";
	//animTypeArray[ animTypeArray.size ] = "female";

	// initialize all the anims for this map
	for(i=0; i < animTypeArray.size; i++ )
	{
		animscripts\anims_table::setup_anim_array( animTypeArray[i] );
	}
}

setup_devgui()
{
	SetDvar( "feature_ai_stance",				"all" );
	SetDvar( "feature_ai_animType",				"clear" );
	SetDvar( "feature_ai_weapon",				"primary" );
	SetDvar( "feature_ai_cqb_cycle",			"disable" );
	SetDvar( "feature_ai_grenade_awareness",	"-1" );
	SetDvar( "feature_ai_heat",					"disable" );
	SetDvar( "feature_ai_movement",				"run" );
	SetDvar( "feature_ai_melee",				"enable" );
	SetDvar( "feature_ai_ambush",				"disable" );

	mapname = GetDvar("mapname");

	AddDebugCommand( "devgui_cmd \"|" + mapname + "|/AnimType:1/Clear All:1\" \"feature_ai_animType clear\"\n" );

	if( IsDefined(level.feature_animTypes) )
	{
		for( i=0; i < level.feature_animTypes.size; i++ )
		{
			animType = level.feature_animTypes[i].name;

			AddDebugCommand( "devgui_cmd \"|" + mapname + "|/AnimType:1/" + animType + ":" + (i+2) + "\" \"feature_ai_animType " + i + "\"\n" );
		}
	}

	AddDebugCommand( "devgui_cmd \"|" + mapname + "|/Stance:2/All:1\" \"feature_ai_stance all\"\n" );
	AddDebugCommand( "devgui_cmd \"|" + mapname + "|/Stance:2/Stand:2\" \"feature_ai_stance stand\"\n" );
	AddDebugCommand( "devgui_cmd \"|" + mapname + "|/Stance:2/Crouch:3\" \"feature_ai_stance crouch\"\n" );
	AddDebugCommand( "devgui_cmd \"|" + mapname + "|/Stance:2/Prone:4\" \"feature_ai_stance prone\"\n" );
	
	AddDebugCommand( "devgui_cmd \"|" + mapname + "|/Weapon:3/Primary:1\" \"feature_ai_weapon primary\"\n" );
	AddDebugCommand( "devgui_cmd \"|" + mapname + "|/Weapon:3/Secondary:2\" \"feature_ai_weapon secondary\"\n" );
	AddDebugCommand( "devgui_cmd \"|" + mapname + "|/Weapon:3/Sidearm:3\" \"feature_ai_weapon sidearm\"\n" );
	AddDebugCommand( "devgui_cmd \"|" + mapname + "|/Weapon:3/None:4\" \"feature_ai_weapon none\"\n" );

	AddDebugCommand( "devgui_cmd \"|" + mapname + "|/CQB Transitions:4/Enable:1\" \"feature_ai_cqb_cycle enable\"\n" );
	AddDebugCommand( "devgui_cmd \"|" + mapname + "|/CQB Transitions:4/Disable:2\" \"feature_ai_cqb_cycle disable\"\n" );

	AddDebugCommand( "devgui_cmd \"|" + mapname + "|/Grenade Awareness:5/On:1\" \"feature_ai_grenade_awareness 1\"\n" );
	AddDebugCommand( "devgui_cmd \"|" + mapname + "|/Grenade Awareness:5/Off:2\" \"feature_ai_grenade_awareness 0\"\n" );

	AddDebugCommand( "devgui_cmd \"|" + mapname + "|/Heat:6/Enable:1\" \"feature_ai_heat enable\"\n" );
	AddDebugCommand( "devgui_cmd \"|" + mapname + "|/Heat:6/Disable:2\" \"feature_ai_heat disable\"\n" );

	AddDebugCommand( "devgui_cmd \"|" + mapname + "|/Movement:7/Walk:1\" \"feature_ai_movement walk\"\n" );
	AddDebugCommand( "devgui_cmd \"|" + mapname + "|/Movement:7/Run:2\" \"feature_ai_movement run\"\n" );
	AddDebugCommand( "devgui_cmd \"|" + mapname + "|/Movement:7/Sprint:2\" \"feature_ai_movement sprint\"\n" );

	AddDebugCommand( "devgui_cmd \"|" + mapname + "|/Melee:8/Enable:1\" \"feature_ai_melee enable\"\n" );
	AddDebugCommand( "devgui_cmd \"|" + mapname + "|/Melee:8/Disable:2\" \"feature_ai_melee disable\"\n" );
	
	AddDebugCommand( "devgui_cmd \"|" + mapname + "|/Ambush:9/Ambush:1\" \"feature_ai_ambush ambush\"\n" );
	AddDebugCommand( "devgui_cmd \"|" + mapname + "|/Ambush:9/Ambush Nodes Only:2\" \"feature_ai_ambush ambush_nodes_only\"\n" );
	AddDebugCommand( "devgui_cmd \"|" + mapname + "|/Ambush:9/No Cover:3\" \"feature_ai_ambush no_cover\"\n" );
	AddDebugCommand( "devgui_cmd \"|" + mapname + "|/Ambush:9/Disable:4\" \"feature_ai_ambush disable\"\n" );
	watch_devgui();
}

watch_devgui()
{
	last_feature_ai_stance					= GetDvar("feature_ai_stance");
	last_feature_ai_animType				= GetDvar("feature_ai_animType");
	last_feature_ai_weapon					= GetDvar("feature_ai_weapon");
	last_feature_ai_grenade_awareness		= GetDvar("feature_ai_stance");
	last_feature_ai_cqb_cycle				= GetDvar("feature_ai_cqb_cycle");
	last_feature_ai_heat					= GetDvar("feature_ai_heat");
	last_feature_ai_movement				= GetDvar("feature_ai_movement");
	last_feature_ai_melee					= GetDvar("feature_ai_melee");	
	while(1)
	{
		feature_ai_stance				= GetDvar("feature_ai_stance");
		feature_ai_animType				= GetDvar("feature_ai_animType");
		feature_ai_weapon				= GetDvar("feature_ai_weapon");
		feature_ai_cqb_cycle			= GetDvar("feature_ai_cqb_cycle");
		feature_ai_grenade_awareness	= GetDvar("feature_ai_grenade_awareness");
		feature_ai_heat					= GetDvar("feature_ai_heat");
		feature_ai_movement				= GetDvar("feature_ai_movement");
		feature_ai_melee				= GetDvar("feature_ai_melee");

		if( feature_ai_stance != last_feature_ai_stance )
		{
			iprintln( "Stance: " + feature_ai_stance );

			// set all current ai to this animType
			allAI = GetAIArray();
			for( i=0; i < allAI.size; i++ )
			{
				allAI[i] set_ai_stance();
			}

			last_feature_ai_stance = feature_ai_stance;
		}

		if( feature_ai_animType != last_feature_ai_animType )
		{
			iprintln( "AnimType: " + feature_ai_animType );

			// set all current ai to this animType
			allAI = GetAIArray();
			for( i=0; i < allAI.size; i++ )
			{
				allAI[i] set_ai_animType();
			}

			last_feature_ai_animType = feature_ai_animType;
		}

		if( feature_ai_weapon != last_feature_ai_weapon )
		{
			iprintln( "Weapon: " + feature_ai_weapon );

			// set all current ai to this animType
			allAI = GetAIArray();
			for( i=0; i < allAI.size; i++ )
			{
				allAI[i] set_ai_weapon();
			}

			last_feature_ai_weapon = feature_ai_weapon;

//			if( feature_ai_weapon == "sidearm" )
//			{
//				SetDvar("scr_forceSideArm", 1);
//			}
//			else
//			{
//				SetDvar("scr_forceSideArm", 0);
//			}
		}
		
		if( feature_ai_cqb_cycle != last_feature_ai_cqb_cycle )
		{
			allAI    = GetAIArray();
			for( i=0; i < allAI.size; i++ )
			{
				allAI[i] set_ai_cqb();
			}

			last_feature_ai_cqb_cycle = feature_ai_cqb_cycle;
		}

		if( feature_ai_grenade_awareness != last_feature_ai_grenade_awareness )
		{
			allAI    = GetAIArray();
			for( i=0; i < allAI.size; i++ )
			{
				if( feature_ai_grenade_awareness == "1" )
				{
					allAI[i].grenadeawareness = 1;
				}
				else
				{
					allAI[i].grenadeawareness = 0;
				}
			}

			last_feature_ai_grenade_awareness = feature_ai_grenade_awareness;
		}

		if( feature_ai_heat != last_feature_ai_heat )
		{
			allAI    = GetAIArray();
			for( i=0; i < allAI.size; i++ )
			{
				allAI[i] set_ai_heat();
			}

			last_feature_ai_heat = feature_ai_heat;
		}

		if( feature_ai_movement != last_feature_ai_movement )
		{
			allAI    = GetAIArray();
			for( i=0; i < allAI.size; i++ )
			{
				allAI[i] set_ai_movement();
			}

			last_feature_ai_movement = feature_ai_movement;
		}
	

		if( feature_ai_melee != last_feature_ai_melee )
		{
			allAI    = GetAIArray();
			for( i=0; i < allAI.size; i++ )
			{
				allAI[i] set_ai_melee();
			}

			last_feature_ai_melee = feature_ai_melee;
		}

		wait(0.05);
	}
}

ai_spawned()
{
	if( IsDefined(self) && IsAlive(self) )
	{
		self set_ai_animType();
		self set_ai_stance();
		self set_ai_weapon();
		self set_ai_cqb();
		self set_ai_movement();
	}
}

set_ai_animType()
{
	feature_ai_animType	= GetDvar("feature_ai_animType");

	if( !IsDefined(level.feature_animTypes) )
	{
		return;
	}

	if( IsDefined(feature_ai_animType) && feature_ai_animType != "clear" && self.animType != feature_ai_animType )
	{
		self.animType = level.feature_animTypes[ int(feature_ai_animType) ].name;

		if( IsDefined(self.headmodel) )
		{
			self Detach(self.headmodel);
			self.headmodel = undefined;
		}

		if( IsDefined(self.gearmodel) )
		{
			self Detach(self.gearmodel);
			self.gearmodel = undefined;
		}

		self animscripts\squadManager::removeFromSquad(); // slooooow

		self [[level.feature_animTypes[ int(feature_ai_animType) ].callback]]();

		// redo the self array since the animType may have changed
		if( IsDefined( self.anim_array ) && IsDefined( self.pre_move_delta_array ) )
		{
			self.pre_move_delta_array		= undefined;
			self.move_delta_array			= undefined;
			self.post_move_delta_array		= undefined;
			self.angle_delta_array			= undefined;
			self.notetrack_array			= undefined;
			self.longestExposedApproachDist	= undefined;
		}

		self thread animscripts\squadManager::addToSquad();

		self animscripts\anims::clearAnimCache();
	}
}

set_ai_stance()
{
	feature_ai_stance	= GetDvar("feature_ai_stance");

	if( IsDefined(feature_ai_stance) )
	{
		switch(feature_ai_stance)
		{
			case "all":
				self allowedStances( "stand", "crouch", "prone" );
				break;

			default:
				self allowedStances( feature_ai_stance );
				break;
		}
	}
}

set_ai_weapon()
{
	if (self.type != "human")
	{
		return;
	}

	feature_ai_weapon	= GetDvar("feature_ai_weapon");

	if( IsDefined(feature_ai_weapon) )
	{
		switch(feature_ai_weapon)
		{
			case "primary":
				if( self.weapon != self.primaryweapon )
				{
					self animscripts\shared::placeWeaponOn( self.primaryweapon, "right" );
					self.forceSideArm = false;
				}
				break;

			case "secondary":
				if( self.weapon != self.secondaryweapon )
				{
					self animscripts\shared::placeWeaponOn( self.secondaryweapon, "right" );
					self.forceSideArm = false;
				}
				break;

			case "sidearm":
				if( self.weapon != self.sidearm )
				{
					self animscripts\shared::placeWeaponOn( self.sidearm, "right" );
					self.pistolSwitchTime = GetTime() + 99999999;
					self.forceSideArm = true;
				}
				break;

			case "none":
				if( self.weapon != self.sidearm )
				{
					self animscripts\shared::placeWeaponOn( self.weapon, "none" );
					self.forceSideArm = false;
				}
				break;
		}
	}
}

set_ai_cqb()
{
	feature_ai_cqb_cycle = GetDvar("feature_ai_cqb_cycle");

	if( IsDefined(feature_ai_cqb_cycle) )
	{
		switch(feature_ai_cqb_cycle)
		{
			case "enable":
				self enable_cqbwalk();
				break;

			default:
				self disable_cqbwalk();
				break;
		}
	}
}

set_ai_heat()
{
	feature_ai_heat = GetDvar("feature_ai_heat");

	if( IsDefined(feature_ai_heat) )
	{
		switch(feature_ai_heat)
		{
			case "enable":
				self.noHeatAnims = false;
				self animscripts\anims_table::setup_heat_anim_array();
				break;

			default:
				self.noHeatAnims = true; // set this so that AI will not switch to heat anims randomly through animscripts.
				self animscripts\anims_table::reset_heat_anim_array();
				break;
		}
	}
}

set_ai_melee()
{
	feature_ai_melee = GetDvar("feature_ai_melee");

	if( IsDefined(feature_ai_melee) )
	{
		switch(feature_ai_melee)
		{
			case "enable":
				self.dontMelee = false;
				break;

			default:
				self.dontMelee = true;
				break;
		}
	}
}

set_ai_movement()
{
	feature_ai_movement = GetDvar("feature_ai_movement");

	if( IsDefined(feature_ai_movement) )
	{
		switch(feature_ai_movement)
		{
			case "sprint":
				self.walk			= false;
				self.sprint			= true;
				self.cqbsprinting	= true;
				break;

			case "walk":
				self.walk			= true;
				self.sprint			= false;
				self.cqbsprinting	= false;
				break;

			default:
				self.walk			= false;
				self.sprint			= false;
				self.cqbsprinting	= false;
				break;
		}
	}
}

add_ai_animtype(name, callback, precache)
{
	if( !IsDefined(level.feature_animTypes) )
	{
		level.feature_animTypes = [];
	}

	index = level.feature_animTypes.size;

	level.feature_animTypes[ index ] = SpawnStruct();
	level.feature_animTypes[ index ].name = name;
	level.feature_animTypes[ index ].callback = callback;

	[[ precache ]]();
}