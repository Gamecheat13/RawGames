#include maps\_utility;











main()
{
	level._attachments = spawnstruct();	
	level._attachments.inventory = [];

	
	
	

	
	
	
	
	
	
	
	
	
	
	
	
	

	
	array_thread(GetEntArray("attachment", "script_noteworthy"), ::attachment);

	level thread hud();
	level thread cycle_attachments();
	level thread weapon_change();
}




add_weapon_attachment(weapon_name, attachment_name)
{
	if (!IsDefined(level._attachments.weapons))
	{
		level._attachments.weapons = [];
	}

	level._attachments.weapons[weapon_name][attachment_name] = true;
	level._attachments.weapons[weapon_name + get_string_for_attachment(attachment_name)][attachment_name] = true;
}





weapon_supports_attachment(weapon_name, attachment_name)
{
	if (IsDefined(level._attachments.weapons[weapon_name]))
	{
		if (IsDefined(level._attachments.weapons[weapon_name][attachment_name])
			&& level._attachments.weapons[weapon_name][attachment_name])
		{
			return true;
		}
	}

	return false;
}

current_weapon_supports_attachment(attachment_name)
{
	current_weapon = level.player GetCurrentWeapon();
	return weapon_supports_attachment(current_weapon, attachment_name);

}

weapon_has_attachment(weapon_name, attachment_name)
{
	attachment_string = get_string_for_attachment(attachment_name);
	sub = GetSubStr(weapon_name, weapon_name.size - attachment_string.size);
	return (sub == attachment_string);
}





give_attachment(attachment_name, activate)
{
	if (!player_has_attachment(attachment_name))
	{
		if (!IsDefined(activate))
		{
			activate = false;
		}

		level._attachments.inventory[attachment_name] = activate;

		
		level notify("update_attachments");
	}
}




activate_attachment(attachment_name, activate)
{
	if (!current_weapon_supports_attachment(attachment_name))
	{
		return;
	}

	if (!activate)
	{
		update_weapons(activate);
	}

	level._attachments.inventory[attachment_name] = activate;
	update_weapons(activate);

	
}

update_weapons(activate)
{
	level._attachments.monitor_weapon_change = false;

	attachment_name = get_current_attachment();
	current_weapon = level.player GetCurrentWeapon();
	weapons_list = level.player GetWeaponsList();

	for (i = 0; i < weapons_list.size; i++)
	{
		ammo_clip = level.player GetWeaponAmmoClip(weapons_list[i]);
		ammo_stock = level.player GetWeaponAmmoStock(weapons_list[i]);

		if (weapon_supports_attachment(weapons_list[i], attachment_name))
		{
			attachment_string = get_string_for_attachment(attachment_name);	

			give_weapon = undefined;
			if (activate)
			{
				if (!weapon_has_attachment(weapons_list[i], attachment_name))
				{
					
					give_weapon = weapons_list[i] + attachment_string;
				}
			}
			else if (weapon_has_attachment(weapons_list[i], attachment_name))
			{
				
				give_weapon = GetSubStr(weapons_list[i], 0, weapons_list[i].size - attachment_string.size);
			}

			if (IsDefined(give_weapon))
			{
				level.player TakeWeapon(weapons_list[i]);
				level.player GiveWeapon(give_weapon);

				
				level.player SetWeaponAmmoClip(give_weapon, ammo_clip);
				level.player SetWeaponAmmoStock(give_weapon, ammo_stock);

				if (weapons_list[i] == current_weapon)
				{
					level.player SwitchToWeapon(give_weapon);
				}
			}
		}
	}

	wait .15;
	level notify("update_attachments");

	level._attachments.monitor_weapon_change = true;
}

get_string_for_attachment(attachment_name)
{
	string = "_";
	switch (attachment_name)
	{
		case "silencer": string += "s"; break;
		case "scope": string += "scoped"; break;
		case "laser": string += "laser"; break;
		default: string += attachment_name;
	}

	return string;
}

player_has_attachment(attachment_name)
{
	if (IsDefined(attachment_name))
	{
		return IsDefined(level._attachments.inventory[attachment_name]);
	}

	return false;
}

player_is_using_attachment(attachment_name)
{
	if (IsDefined(level._attachments.inventory[attachment_name]))
	{
		return level._attachments.inventory[attachment_name];
	}

	return false;
}

get_current_attachment()
{
	attachments = GetArrayKeys(level._attachments.inventory);
	for (i = 0; i < attachments.size; i++)
	{
		attachment_name = attachments[i];
		if (player_is_using_attachment(attachment_name))
		{
			return attachment_name;
		}
	}

	return "none";
}




attachment()
{
	
	
	trig = Spawn("trigger_radius", self.origin, 0, 20, 20);
	trig waittill("trigger");

	iPrintLnBold("Picked up a " + self.name + ".");

	give_attachment(self.name);
	self delete();
}

hud()
{
	level._attachments_hud = [];

	while (true)
	{
		level waittill("update_attachments");

		attachments = GetArrayKeys(level._attachments.inventory);
		for (i = 0; i < attachments.size; i++)
		{
			attachment_name = attachments[i];
			attachment_on = player_is_using_attachment(attachment_name);

			if (!IsDefined(level._attachments_hud[attachment_name]))
			{
				level._attachments_hud[attachment_name] = SpawnStruct();
			}

			if (!IsDefined(level._attachments_hud[attachment_name].hud))
			{
				level._attachments_hud[attachment_name].hud = NewHudElem();
				level._attachments_hud[attachment_name].hud.horzAlign = "left";
				level._attachments_hud[attachment_name].hud.vertAlign = "bottom";
				level._attachments_hud[attachment_name].hud.x = -10;
				level._attachments_hud[attachment_name].hud.sort = -1;

				level._attachments_hud[attachment_name].hud_disabled = NewHudElem();
				level._attachments_hud[attachment_name].hud_disabled.horzAlign = "left";
				level._attachments_hud[attachment_name].hud_disabled.vertAlign = "bottom";
				level._attachments_hud[attachment_name].hud_disabled.x = -10;
				level._attachments_hud[attachment_name].hud_disabled SetText("/");
				level._attachments_hud[attachment_name].hud_disabled.fontScale = 1.3;
				level._attachments_hud[attachment_name].hud_disabled.color = (0, 0, 0);
			}

			line_height = int(level.fontHeight * 1.3);

			level._attachments_hud[attachment_name].hud.y = -60 + (-1 * level._attachments.inventory.size * line_height / 2) + (i * line_height) + 3;
			level._attachments_hud[attachment_name].hud_disabled.y = -60 + (-1 * level._attachments.inventory.size * line_height / 2) + (i * line_height);

			shader = get_display_shader(attachment_name, attachment_on);
			if (IsDefined(shader))
			{
				level._attachments_hud[attachment_name].hud SetShader(shader);
			}
			else
			{
				hud_text = get_display_text(attachment_name);
				level._attachments_hud[attachment_name].hud SetText(hud_text);
			}

			if (current_weapon_supports_attachment(attachment_name))
			{
				level._attachments_hud[attachment_name].hud_disabled.alpha = 0.0;

				if (attachment_on)
				{
					level._attachments_hud[attachment_name].hud.alpha = 1.0;
				}
				else
				{
					level._attachments_hud[attachment_name].hud.alpha = 0.5;
				}
			}
			else
			{
				level._attachments_hud[attachment_name].hud.alpha = 0.5;
				level._attachments_hud[attachment_name].hud_disabled.alpha = 0.5;
			}
		}
	}
}

get_display_text(attachment_name)
{
	text = "*";
	switch (attachment_name)
	{
		case "silencer":text = "SL";break;
		case "laser":text = "LR";break;
		case "scope":text = "SC";break;
	}

	return text;
}

get_display_shader(attachment_name, on)
{
	shader = undefined;
	switch (attachment_name)
	{
	case "silencer":
		if (on)
		{
			
		}
		else
		{
			
		}
		break;
	}

	return shader;
}

cycle_attachments()
{
	current_attachment_index = 0;

	while (true)
	{
		wait .05;

		if (level.player buttonPressed("DPAD_DOWN"))
		{
			
			while (level.player buttonPressed("DPAD_DOWN"))
			{
				wait .05;
			}

			attachments = GetArrayKeys(level._attachments.inventory);
			if (current_attachment_index > attachments.size)
			{
				current_attachment_index = 0;
			}

			if (player_has_attachment(attachments[current_attachment_index - 1]))
			{
				activate_attachment(attachments[current_attachment_index - 1], false);
			}

			if (player_has_attachment(attachments[current_attachment_index]))
			{
				activate_attachment(attachments[current_attachment_index], true);
			}

			current_attachment_index++;

			level notify("update_attachments");
		}
	}
}

weapon_change()
{
	level._attachments.monitor_weapon_change = true;

	while (true)
	{
		level.player waittill("weapon_change", weapon);
		if (level._attachments.monitor_weapon_change)
		{
			if (weapon != "defaultweapon")
			{
				update_weapons(true);
				
			}
		}
	}
}
