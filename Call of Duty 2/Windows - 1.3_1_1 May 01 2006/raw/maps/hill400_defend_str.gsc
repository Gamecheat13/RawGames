main()
{
	level.strings = [];
	
	//common
	level.strings["mortarteam_hint1"] 				= spawnstruct();
	level.strings["mortarteam_hint1"].text			= &"HILL400_DEFEND_HINT_WATCH_FOR_SMOKE";	
	level.strings["mortarteam_hint1"].alignY = "bottom";
	level.strings["mortarteam_hint2"] 				= spawnstruct();
	level.strings["mortarteam_hint2"].text			= &"HILL400_DEFEND_HINT_MOVE_ALONG_THE_BARBED";	
	level.strings["mortarteam_hint2"].alignY = "bottom";
	
	level.strings["mortarteam_hint1"] 				thread maps\hill400_defend_str::precache_hud_elm();
	level.strings["mortarteam_hint2"] 				thread maps\hill400_defend_str::precache_hud_elm();
}

precache_hud_elm()
{
	/*
	if(isdefined(self.unbound))
	{
		if(self == level.strings["move"])
			self.text = self.unbound;	
		else
		{
			self.bind = self.unbound;	 
			self.text = &"MOSCOW_PLATFORM_UNBOUND";
		}
	}
	*/
	if(!isdefined(self.text2))
		precacheString(self.text);
	if(isdefined(self.text2))
		precacheString(self.text2);
	if(isdefined(self.text3))
		precacheString(self.text3);
	if(isdefined(self.text4))
		precacheString(self.text4);
	if(isdefined(self.text5))
		precacheString(self.text5);
	if(isdefined(self.text6))
		precacheString(self.text6);
	if(isdefined(self.bind))
		precacheString(self.bind);
}

/*
check_bind(bind)
{
	binding = getKeyBinding(bind);
	
	unbound = undefined;
	if(!(binding["count"]))
	{
		switch(bind)
		{
			case "+attack":
				unbound = &"MENU_ATTACK";
				break;	
			case "+reload":
				unbound = &"MENU_RELOAD_WEAPON";
				break;	
			case "cycleoffhand":
				unbound = &"MENU_CHANGE_GRENADE_TYPE";
				break;	
			case "+offhand":
				unbound = &"MENU_THROW_GRENADE";
				break;	
			case "weapnext":
				unbound = &"MENU_CHANGE_WEAPON";
				break;	
			case "+scores":
				unbound = &"MENU_SHOW_OBJECTIVES_SCORES";
				break;	
			case "+activate":
				unbound = &"MENU_USE";
				break;		
		}
	}
	return unbound;
}

hint_Melee(keybind)
{
	keybind.text = undefined;
	keybind.bind = undefined;
	keybind.checkagain = true;
	keybind.text2 = &"MOSCOW_PLATFORM_PUSH_TO_MELEE_NORM";
	keybind.text3 = &"MOSCOW_PLATFORM_PUSH_TO_MELEE_BREATH";
	
	binding = getKeyBinding("+melee_breath");
	if(binding["count"])
		keybind.text = keybind.text3;
	
	else
	{
		binding = getKeyBinding("+melee");
		if(binding["count"])
			keybind.text = keybind.text2;
	}
	
	if(!isdefined(keybind.text))
		keybind.text = keybind.text2;
	return keybind;
}

hint_mantle(keybind)
{
	keybind.text = undefined;
	keybind.bind = undefined;
	keybind.checkagain = true;
	keybind.text2 = &"MOSCOW_PLATFORM_PRESS_TO_MANTLE_GOSTAND";
	keybind.text3 = &"MOSCOW_PLATFORM_PRESS_TO_MANTLE_MOVEUP";
	keybind.text4 = &"MOSCOW_PLATFORM_PRESS_TO_MANTLE_RAISE";
	
	binding = getKeyBinding("+gostand");
	if(binding["count"])
		keybind.text = keybind.text2;

	else
	{	
		binding = getKeyBinding("+moveup");
		if(binding["count"])
			keybind.text = keybind.text3;
	
		else
		{
			binding = getKeyBinding("raisestance");
			if(binding["count"])
				keybind.text = keybind.text4;
		}
	}
	
	if(!isdefined(keybind.text))
		keybind.text = keybind.text2;
	return keybind;
}

hint_ADS(keybind)
{		
	keybind.text = undefined;
	keybind.bind = undefined;
	keybind.checkagain = true;
	keybind.text2 = &"MOSCOW_PLATFORM_TOGGLE_ADS";
	keybind.text3 = &"MOSCOW_PLATFORM_HOLD_TO_ADS";
	binding = getKeyBinding("toggleads");
	if(binding["count"])
		keybind.text = keybind.text2;

	else
	{
		binding = getKeyBinding("+speed");
		if(binding["count"])
			keybind.text = keybind.text3;
	}
	
	if(!isdefined(keybind.text))
		keybind.text = keybind.text2;//keybind.unbound = &"MENU_AIM_DOWN_THE_SIGHT";
	return keybind;
}

hint_stand2prone(keybind)
{
	keybind.text = undefined;
	keybind.bind = undefined;
	keybind.checkagain = true;
	keybind.text2 = &"MOSCOW_PLATFORM_GO_PRONE";
	keybind.text3 = &"MOSCOW_PLATFORM_HOLD_PRONE";
	keybind.text4 = &"MOSCOW_PLATFORM_TOGGLE_PRONE";
	keybind.text5 = &"MOSCOW_PLATFORM_PUSH_TWICE_TO_CRAWL";
	
	binding = getKeyBinding("goprone");
	if(binding["count"])
		keybind.text = keybind.text2;

	else
	{
		binding = getKeyBinding("+prone");
		if(binding["count"])
			keybind.text = keybind.text3;
		
		else
		{
			binding = getKeyBinding("toggleprone");
			if(binding["count"])
				keybind.text = keybind.text4;

			else
			{
				binding = getKeyBinding("lowerstance");
				if(binding["count"])
					keybind.text = keybind.text5;
			}
		}
	}
	
	if(!isdefined(keybind.text))
		keybind.text = keybind.text2;
	return keybind;
}		

hint_stand2crouch(keybind)
{
	keybind.text = undefined;
	keybind.bind = undefined;
	keybind.checkagain = true;
	keybind.text2 = &"MOSCOW_PLATFORM_GO_CROUCH";
	keybind.text3 = &"MOSCOW_PLATFORM_TOGGLE_CROUCH";
	keybind.text4 = &"MOSCOW_PLATFORM_HOLD_CROUCH";
	keybind.text5 = &"MOSCOW_PLATFORM_GO_CROUCH_LOWER";
		
	binding = getKeyBinding("gocrouch");
	if(binding["count"])
		keybind.text = keybind.text2;

	else
	{
		binding = getKeyBinding("togglecrouch");
		if(binding["count"])
			keybind.text = keybind.text3;

		else
		{
			binding = getKeyBinding("+movedown");
			if(binding["count"])
				keybind.text = keybind.text4;
	
			else
			{
				binding = getKeyBinding("lowerstance");
				if(binding["count"])
					keybind.text = keybind.text5;
			}
		}
	}
	
	if(!isdefined(keybind.text))
		keybind.text = keybind.text2;
	return keybind;
}

hint_crouch2stand(keybind)
{
	keybind.text = undefined;
	keybind.bind = undefined;
	keybind.checkagain = true;
	keybind.text2 = &"MOSCOW_PLATFORM_HOLD_STAND";
	keybind.text3 = &"MOSCOW_PLATFORM_GO_STAND";
	keybind.text4 = &"MOSCOW_PLATFORM_TOGGLE_STAND";
	keybind.text5 = &"MOSCOW_PLATFORM_GO_STAND_RAISE";
	keybind.text6 = &"MOSCOW_PLATFORM_GO_STAND_MOVEUP";
		
	binding = getKeyBinding("+movedown");
	if(binding["count"])
		keybind.text = keybind.text2;
	
	else
	{
		binding = getKeyBinding("+gostand");
		if(binding["count"])
			keybind.text = keybind.text3;
	
		else
		{
			binding = getKeyBinding("togglecrouch");
			if(binding["count"])
				keybind.text = keybind.text4;

			else
			{
				binding = getKeyBinding("raisestance");
				if(binding["count"])
					keybind.text = keybind.text5;
		
				else
				{
					binding = getKeyBinding("+moveup");
					if(binding["count"])
						keybind.text = keybind.text6;
				}
			}
		}
	}
	
	if(!isdefined(keybind.text))
		keybind.text = keybind.text2;
	return keybind;
}

hint_prone2stand(keybind)
{
	keybind.text = undefined;
	keybind.bind = undefined;
	keybind.checkagain = true;
	keybind.text2 = &"MOSCOW_PLATFORM_GO_STAND";
	keybind.text3 = &"MOSCOW_PLATFORM_HOLD_STAND_PRONE";
	keybind.text4 = &"MOSCOW_PLATFORM_TOGGLE_STAND_PRONE";
	keybind.text5 = &"MOSCOW_PLATFORM_PUSH_TWICE_TO_STAND";
	keybind.text6 = &"MOSCOW_PLATFORM_PUSH_TWICE_TO_STAND_MOVEUP";
	
	binding = getKeyBinding("+gostand");
	if(binding["count"])
		keybind.text = keybind.text2;

	else
	{
		binding = getKeyBinding("+prone");
		if(binding["count"])
			keybind.text = keybind.text3;

		else
		{
			binding = getKeyBinding("toggleprone");
			if(binding["count"])
				keybind.text = keybind.text4;
				
			else
			{
				binding = getKeyBinding("raisestance");
				if(binding["count"])
					keybind.text = keybind.text5;
					
				else
				{
					binding = getKeyBinding("+moveup");
					if(binding["count"])
						keybind.text = keybind.text6;
				}
			}
		}
	}
	if(!isdefined(keybind.text))
		keybind.text = keybind.text2;
	return keybind;
}
*/