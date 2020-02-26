#include maps\mp\_utility;
#include common_scripts\utility;

init()
{
	// TFLAME - 4/28/11 - TODO - shouldn't this be done with the rest of the precaching?  Should be taken care of


	// TFLAME - 4/28/11 - TODO - Should show map instructions such as this when score screen is up
	// turn off the perks
	SetDvar( "scr_game_perks", 0 );
	thread show_perks_disabled();

	// center lines for making sure the gun aims properly
	thread init_debug_center_screen();
	thread weapon_structs_setup();

	players = get_players();
	
	if(players.size <= 0)
	{
		while(players.size <= 0)
		{
			wait 0.1;
			players = get_players();
		}
	}
	
	level.playerone = players[0];
	
	thread player_unlimited_ammo_thread();
	thread debug_center_screen_toggle();
	thread viewarms_cycling();
	
	// TFLAME - 4/28/11 - TODO - Can remove this, would prefer if there was just a trigger that took away all ammo in addition to toggling unlimited on/off
	// TFLAME - 4/28/11 - TODO - Unlimited ammo should be the default ammount you get in MP so you can always see how it feels to deplete given ammo
	thread button_ammo_turn_off();
	
	// TFLAME - 4/28/11 - TODO - Not sure if we need this
	//thread weapons_print();
	
	// TFLAME - 4/28/11 - TODO - Don't think we need this, sound has brought them down to just a few and should be easily distinguishable.
	//thread textures_print();
	
	// TFLAME - 4/28/11 - TODO - currently broken
	//thread watch_laser();
	
	// TFLAME - 4/28/11 - spawn grenades again after use
	thread grenade_pickup();
	
	thread equipment_cycling();

	max_ammo_on_change = weapons_get_dvar_int( "scr_max_ammo_on_change", "1" );
	
	// TFLAME - 4/28/11 - handles spawning in a new weapon on the ground when one is picked up
	thread change_weapon();

	// Wait for the player to have a weapon
	weap = level.playerone GetCurrentWeapon();
	
	while( weap == "none" )
	{
		wait(0.1);
		weap = level.playerone GetCurrentWeapon();	
	}
	
	// Figure out what weapons the player is currently using
	level.playerweapons = level.playerone GetWeaponsListPrimaries();
}

show_perks_disabled()
{
	level.perks_hud = NewHudElem();
	level.perks_hud.alignX = "left";
	level.perks_hud.fontScale = 1.5;
	level.perks_hud.x = -25;
	level.perks_hud.y = 25;
	level.perks_hud.color = ( 1, 1, 1 );
	//level.perks_hud SetText( "Your selected class perks were disabled, use Give Perk in the dev gui if needed" );
}

watch_laser()
{
	button = "DPAD_LEFT";
	laser_on = false;

	while( true )
	{
		if( level.playerone ButtonPressed( button ) )
		{
			current_weapon = level.playerone GetCurrentWeapon();
			if( !laser_on )
			{
				current_weapon LaserOn();
				laser_on = true;
			}
			else
			{
				current_weapon LaserOff();
				laser_on = false;
			}
		}

		while( level.playerone ButtonPressed( button ) )
		{
			wait( 0.05 );
		}

		wait 0.05;
	}
}

// *** Unlimited Ammo ***
// Automatically gives the player max ammo for their current when their ammo count drops below 20% of the weapon's max ammo count
player_unlimited_ammo_thread()
{
	//thread watchUAmmoOnTrigger();
	//thread watchUAmmoOffTrigger();
	
	while( 1 )
	{
		wait( 2 ); 

		if ( GetDvar( "UnlimitedAmmoOff" ) == "1" )
		{
			continue;
		}

		// MP Check
		if( !isdefined(level.players) )
		{
				level.players = get_players();
		}
		
		for( i = 0; i < level.players.size; i++ )
		{
			currentWeapon = level.players[i] GetCurrentWeapon();
			
			if( currentWeapon == "none" )
			{
				continue; 
			}
	
			altFireWeapon = WeaponAltWeaponName( currentWeapon );
	
			currentAmmo = level.players[i] GetFractionMaxAmmo( currentWeapon );
			
			if( currentAmmo < 0.2 )
			{
				level.players[i] GiveMaxAmmo( currentWeapon ); 
			}
			
			if( altFireWeapon == "none" )
			{
				continue;
			}
			
			altAmmo = level.players[i] GetAmmoCount( altFireWeapon );
						
			if( altAmmo < WeaponMaxAmmo( altFireWeapon ) )
			{
				level.players[i] GiveMaxAmmo( altFireWeapon );
			}
		}
	}
}

watchUAmmoOnTrigger()
{
	trig = getent("UAmmoOn", "targetname");
	
	while(true)
	{
		trig waittill("trigger");
		
		if( GetDvarInt( "UnlimitedAmmoOff" ) )
		{
			SetDvar( "UnlimitedAmmoOff", "0" );
			
			iprintlnbold("Unlimited Ammo On");
		}
	}
}

watchUAmmoOffTrigger()
{
	trig = getent("UAmmoOff", "targetname");
	
	while(true)
	{
		trig waittill("trigger");
		
		if( !GetDvarInt( "UnlimitedAmmoOff" ) )
		{
			SetDvar( "UnlimitedAmmoOff", "1" );
		
			iprintlnbold("Unlimited Ammo Off");
		}
	}
}

// *** Debug the Center of the Screen ***
// Allows you to draw a large crosshair in the center of the screen by pressing in both sticks at once
init_debug_center_screen()
{
	if( GetDvar( "debug_center_screen" ) == "" )
		SetDvar( "debug_center_screen", "0" );
	
	zero_idle_movement = "0";

	for (;;)
	{
		if( GetDvar( "debug_center_screen" ) == "1" )
		{
			if (!isdefined (level.center_screen_debug_hudelem_active) || level.center_screen_debug_hudelem_active == false)
			{							
				thread debug_center_screen();

				zero_idle_movement = GetDvar( "zero_idle_movement" );
				if(  IsDefined( zero_idle_movement ) && zero_idle_movement == "0" )
				{
					SetDvar( "zero_idle_movement", "1" );
					zero_idle_movement = "1";
				}
			}
		}
		else
		{	
			level notify ("stop center screen debug");

			if(  zero_idle_movement == "1" )
			{
				SetDvar( "zero_idle_movement", "0" );
				zero_idle_movement = "0";
			}
		}
		wait (0.05);
	}
}

// turns the center screen debug marker on and off
debug_center_screen_toggle()
{
	up_pressed = false;

	while (1)
	{
		if( level.playerone ButtonPressed("BUTTON_LSTICK") &&
			level.playerone ButtonPressed("BUTTON_RSTICK") 
			&& !up_pressed )
		{
			up_pressed = true;
			if (GetDvar( "debug_center_screen" ) == "" || GetDvar( "debug_center_screen" ) == "0")
			{
				SetDvar( "debug_center_screen", "1" );
			}
			else
			{
				SetDvar( "debug_center_screen", "0" );
			}
		}
		else
		{
			up_pressed = false;
		}
		
		wait 0.2;
	}
}

// draws the center screen debug marker
debug_center_screen()
{	
	level.center_screen_debug_hudelem_active = true;	
	wait 0.1;
			
	level.center_screen_debug_hudelem1 = newclienthudelem (level.playerone);
	level.center_screen_debug_hudelem1.alignX = "center";   
 	level.center_screen_debug_hudelem1.alignY = "middle";   
 	level.center_screen_debug_hudelem1.fontScale = 1;
 	level.center_screen_debug_hudelem1.alpha = 0.5;
 	level.center_screen_debug_hudelem1.x = (640/2) - 1;
 	level.center_screen_debug_hudelem1.y = (480/2);	
	level.center_screen_debug_hudelem1 setshader("white", 1000, 1);
	
	level.center_screen_debug_hudelem2 = newclienthudelem (level.playerone);
	level.center_screen_debug_hudelem2.alignX = "center";   
 	level.center_screen_debug_hudelem2.alignY = "middle";   
 	level.center_screen_debug_hudelem2.fontScale = 1;
 	level.center_screen_debug_hudelem2.alpha = 0.5;
 	level.center_screen_debug_hudelem2.x = (640/2) - 1;
 	level.center_screen_debug_hudelem2.y = (480/2);
	level.center_screen_debug_hudelem2 setshader("white", 1, 480);	
	
	level waittill ("stop center screen debug");
	
	level.center_screen_debug_hudelem1 destroy();
	level.center_screen_debug_hudelem2 destroy();
	level.center_screen_debug_hudelem_active = false;
}

// *** Viewarms Cycling ***
// Allows you to select and vew different viewmodels by pressing the DPad Down Arrow
viewarms_cycling()
{
	if( !IsDefined( level.viewarms ) || level.viewarms.size < 1 )
	{
		return;
	}
	
	level.viewarms_hud = NewHudElem();
	level.viewarms_hud.alignX = "left";
	level.viewarms_hud.fontScale = 1.5;
	level.viewarms_hud.x = -25;
	level.viewarms_hud.y = 315;
	level.viewarms_hud.color = ( 1, 1, 1 );
	
	button = "DPAD_DOWN";
	
	currentIndex = 0;
	maxIndex = level.viewarms.size - 1;
	
	level.playerone SetViewModel( level.viewarms[currentIndex] );
	
	dpad_modifier_button = "BUTTON_X";
/#
	dpad_modifier_button = maps\mp\gametypes\_dev::getAttachmentChangeModifierButton();
#/

	dpad_modifier_button2 = "BUTTON_RSTICK";

	while( 1 )
	{
		if( level.playerone ButtonPressed( button ) && 
			!level.playerone ButtonPressed( dpad_modifier_button ) &&
			!level.playerone ButtonPressed( dpad_modifier_button2 ))
		{
			currentIndex++;
			
			if( currentIndex > maxIndex )
			{
				currentIndex = 0;
			}
			
			level.playerone SetViewModel( level.viewarms[currentIndex] );
			thread viewarms_cycling_updatehud( currentIndex );
		}
		
		while( level.playerone ButtonPressed( button ) )
		{
			wait( 0.05 );
		}
		
		wait 0.05;
	}
}

// prints the name of the current viewmodel arms on screen
viewarms_cycling_updatehud( currentIndex )
{
	level notify( "viewarm_cycle_updatehud" );
	level endon( "viewarm_cycle_updatehud" );
	
	ps = "";
	
	if( IsDefined( level.viewarms_lastSPIndex ) )
	{
		if( currentIndex <= level.viewarms_lastSPIndex )
		{
			ps = " (SP/MP)";
		}
		else
		{
			ps = " (MP only)";
		}
	}
	
	level.viewarms_hud SetText( level.viewarms[currentIndex] + ps );
	level.viewarms_hud FadeOverTime( 0.25 );
	level.viewarms_hud.alpha = 1;
	
	wait( 4 );
	
	level.viewarms_hud FadeOverTime( 0.5 );
	level.viewarms_hud.alpha = 0;
}

// *** Weapons Table ***
// Creates structs for each gun to display the name
weapon_structs_setup()
{
	// This creates an array of structs to hold the location and classname of guns, so we can respawn them
	for(i = 0; i < level.guns.size; i++)
	{
		gsIndex = level.gunstructs.size;	// add a new struct to the end of the array
		
		level.gunstructs[gsIndex] = Spawn("script_origin", level.guns[i].origin);
		level.gunstructs[gsIndex].origin = level.guns[i].origin;
		level.gunstructs[gsIndex].angles = level.guns[i].angles;
		level.gunstructs[gsIndex].targetname = level.guns[i].classname;
	}
	
}

// prints the name of the weapon over the corresponding struct
weapons_print()
{
	
	// get the triggers for the printing
	level.gun_triggers = [];
	level.gun_triggers[0] = GetEnt("smg_trig", "targetname");
	level.gun_triggers[1] = GetEnt("ar_trig", "targetname");
	level.gun_triggers[2] = GetEnt("lmg_trig", "targetname");
	level.gun_triggers[3] = GetEnt("sniper_trig", "targetname");
	level.gun_triggers[4] = GetEnt("pistol_trig", "targetname");
	level.gun_triggers[5] = GetEnt("shotgun_trig", "targetname");
	level.gun_triggers[6] = GetEnt("misc_trig", "targetname");
	
	while(true)
	{
		// only print gun names if we're in the gun group's trigger
		for( i = 0; i < level.gun_triggers.size; i++ )
		{
			trig_ent = level.gun_triggers[i];

			if( level.playerone IsTouching(trig_ent) )
			{
				// print the guns in that trigger
				for( j = 0; j < level.gunstructs.size; j++ )
				{	
					gun_ent = level.gunstructs[j];
					weapon_name = gun_ent.targetname;

					if( !IsDefined(weapon_name) )
					{
						continue;
					}

					if( gun_ent IsTouching(trig_ent) )
					{
						Print3d( gun_ent.origin, GetSubStr(weapon_name, 7), (1,1,1), 1, .3);
					}
				}
			}
		}

		wait(0.05);
	}
}

// prints the name of the texture in use over the corresponding brush in radiant using structs
textures_print()
{
	text_struct_array = getstructarray("texture_text_struct", "targetname");
	
	while(1)
	{
		for(i=0; i < text_struct_array.size; i++)
		{	
			textureName = text_struct_array[i].script_string;
			
			print3d( text_struct_array[i].origin, textureName,(1,1,1), 1, .3);
		}
		wait .05;
	}
	
}

button_ammo_turn_off()
{	
	button = "DPAD_RIGHT";
	
	dpad_modifier_button = "BUTTON_X";
/#
	dpad_modifier_button = maps\mp\gametypes\_dev::getAttachmentChangeModifierButton();
#/
	while( 1 )
	{
		if( level.playerone ButtonPressed( button ) && !level.playerone ButtonPressed( dpad_modifier_button ) )
		{
			level.playerweapons = level.playerone GetWeaponsListPrimaries();
			for(i = 0; i < level.playerweapons.size; i++)
			{
				level.playerone SetWeaponAmmoClip( level.playerweapons[i], 0 );
				level.playerone SetWeaponAmmoStock( level.playerweapons[i], 0 );
			}

			// also turn off the max ammo on change
			if( weapons_get_dvar_int( "scr_max_ammo_on_change" ) )
			{
				SetDvar( "scr_max_ammo_on_change", "0" );
			}
			else
			{
				SetDvar( "scr_max_ammo_on_change", "1" );
			}
		}
		
		while( level.playerone ButtonPressed( button ) )
		{
			wait( 0.05 );
		}
		
		wait 0.05;
	}
}

change_weapon()
{
	level.playerone.lastDroppableWeapon = level.playerone GetCurrentWeapon();
	
	while(true)
	{
		// when a weapon is switched or picked up this is the notify
		level.playerone waittill("weapon_change", weapon_name);

		switch( weapon_name )
		{
		case "m202_flash_mp":
		case "m220_tow_mp":
		case "minigun_mp":
			level.playerone.lastdroppableweapon = weapon_name;
			break;
		}

		// if the weapon_name is none then we just dropped our weapon
		if( weapon_name == "none" )
		{
			// delete the weapon that was dropped and respawn it in the right place
			gun_array = GetEntArray( "weapon_" + level.playerone.lastdroppableweapon, "classname");
			for( i = 0; i < gun_array.size; i++ )
			{
				gun_array[i] delete();
				
				iprintln(level.playerone.lastdroppableweapon + "got deleted!"); // TODO delete
				
			}

			spawn_new_gun( level.playerone.lastdroppableweapon );

			continue;
		}

		if( weapons_get_dvar_int( "scr_max_ammo_on_change", "1" ) )
		{
			// the weapon_name wasn't none so this is the weapon we changed to
			// fill the clip
			level.playerone GiveMaxAmmo( weapon_name );
			clip_size = WeaponClipSize( weapon_name );
			level.playerone SetWeaponAmmoClip( weapon_name, clip_size );
		}
		wait(0.05);

		// now spawn this weapon in the space that we just picked it up from
		spawn_new_gun( weapon_name );
	}
}

spawn_new_gun( weapon_name )
{
	for( i = 0; i < level.gunstructs.size; i++ )
	{	
		gun_ent = level.gunstructs[i];
		if(  gun_ent.targetname == ("weapon_" + weapon_name) )
		{
			new_gun = Spawn( gun_ent.targetname, gun_ent.origin + (0, 0, 15) );
			if( IsDefined(new_gun) )
			{
				new_gun.angles = gun_ent.angles;
			}
			break;
		}
	}
}

weapons_get_dvar_int( dvar, def )
{
	return int( weapons_get_dvar( dvar, def ) );
}

weapons_get_dvar( dvar, def )
{
	if ( getdvar( dvar ) != "" )
	{
		return getdvarfloat( dvar );
	}
	else
	{
		setdvar( dvar, def );
		return def;
	}
}

grenade_pickup()
{
	while(true)
	{
		// when a weapon is switched or picked up this is the notify
		level.playerone waittill("grenade_fire", grenade, weapon_name);

		// now spawn this weapon in the space that we just picked it up from
		spawn_new_gun( weapon_name );
	}
}

// *** Equipment Cycling ***
// Allows you to select different equipment by pressing the DPad Down Arrow + RS click
equipment_cycling()
{
	if( !IsDefined( level.equipment ) || level.equipment.size < 1 )
	{
		return;
	}

	button = "DPAD_DOWN";

	currentIndex = 0;
	maxIndex = level.equipment.size - 1;

	dpad_modifier_button = "BUTTON_RSTICK";

	while( 1 )
	{
		if( level.playerone ButtonPressed( button ) && level.playerone ButtonPressed( dpad_modifier_button ) )
		{
			currentIndex++;

			if( currentIndex > maxIndex )
			{
				currentIndex = 0;
			}

			level.playerone GiveWeapon( level.equipment[currentIndex] );
			level.playerone SetActionSlot( 1, "weapon", level.equipment[currentIndex] );
		}

		while( level.playerone ButtonPressed( button ) && level.playerone ButtonPressed( dpad_modifier_button ) )
		{
			wait( 0.05 );
		}

		wait 0.05;
	}
}
