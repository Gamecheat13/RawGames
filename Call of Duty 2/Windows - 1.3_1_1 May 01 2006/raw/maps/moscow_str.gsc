main()
{
	level.strings = [];
	
	//common
	level.strings["objectives"] 				= spawnstruct();
	level.strings["objectives"].text			= &"MOSCOW_PLATFORM_OBJECTIVES";
	level.strings["grab_potato"] 				= spawnstruct();
	level.strings["grab_potato"].text			= &"MOSCOW_GRAB_POTATO";
	level.strings["grab_weapon"] 				= spawnstruct();
	level.strings["grab_weapon"].text			= &"MOSCOW_PLATFORM_GRAB_WEAPON";
	level.strings["swap_weapon"] 				= spawnstruct();
	level.strings["swap_weapon"].text			= &"MOSCOW_PLATFORM_SWAP_WEAPON";
	level.strings["reload"] 					= spawnstruct();
	level.strings["reload"].text				= &"MOSCOW_PLATFORM_USE_TO_RELOAD";
	level.strings["reload_special"] 			= spawnstruct();
	level.strings["reload_special"].text		= &"MOSCOW_PLATFORM_RELOAD_HINT";
	level.strings["explosives"] 				= spawnstruct();
	level.strings["explosives"].text			= &"MOSCOW_PLATFORM_EXPLOSIVES";
	level.strings["explosives"].alignY = "bottom";
	level.strings["explosives_warn"] 			= spawnstruct();
	level.strings["explosives_warn"].text		= &"MOSCOW_EXPLOSIVES_WARN";
	level.strings["grenade_throw"] 				= spawnstruct();
	level.strings["grenade_throw"].text			= &"MOSCOW_PLATFORM_THROW_GRENADE";
	level.strings["potato_throw"] 				= spawnstruct();
	level.strings["potato_throw"].text			= &"MOSCOW_PLATFORM_THROW_POTATO";
	level.strings["potato_throw"].alignY = "bottom";
	level.strings["fire"] 						= spawnstruct();
	level.strings["fire"].text					= &"MOSCOW_PLATFORM_USE_TO_FIRE";
	level.strings["weapon_switch"] 				= spawnstruct();
	level.strings["weapon_switch"].text			= &"MOSCOW_PLATFORM_SWITCH_WEAPONS";
	level.strings["grenade_switch"] 			= spawnstruct();
	level.strings["grenade_switch"].text		= &"MOSCOW_PLATFORM_SWITCH_GRENADES";		
	level.strings["ladder"] 					= spawnstruct();
	level.strings["ladder"].text				= &"MOSCOW_LADDER";	
	level.strings["melee_approach"] 			= spawnstruct();
	level.strings["melee_approach"].text		= &"MOSCOW_MELEE_APPROACH";	
	level.strings["objective_hint"] 			= spawnstruct();
	level.strings["objective_hint"].text		= &"MOSCOW_OBJ_HINT";	
	level.strings["stance_hint"] 				= spawnstruct();
	level.strings["stance_hint"].text			= &"MOSCOW_STANCE_HINT";	
	level.strings["smoke_placement"] 			= spawnstruct();
	level.strings["smoke_placement"].text		= &"MOSCOW_SMOKE_PLACEMENT";	
	level.strings["smoke_placement"].alignY = "bottom";
	
	
	//XENON
	if(level.xenon)
	{
		level.strings["aim"] 					= spawnstruct();
		level.strings["aim"].text				= &"MOSCOW_PLATFORM_PULL_TO_ADS";
		level.strings["stance_down_1x"] 		= spawnstruct();
		level.strings["stance_down_1x"]			= maps\moscow_str::hint_stance_check(level.strings["stance_down_1x"], "stance_down_1x");
		level.strings["stance_down_2x"] 		= spawnstruct();
		level.strings["stance_down_2x"]			= maps\moscow_str::hint_stance_check(level.strings["stance_down_2x"], "stance_down_2x");
		level.strings["stance_up_1x"] 			= spawnstruct();
		level.strings["stance_up_1x"]			= maps\moscow_str::hint_stance_check(level.strings["stance_up_1x"], "stance_up_1x");
		level.strings["stance_up_2x"] 			= spawnstruct();
		level.strings["stance_up_2x"]			= maps\moscow_str::hint_stance_check(level.strings["stance_up_2x"], "stance_up_2x");
		level.strings["mantle"] 				= spawnstruct();
		level.strings["mantle"]					= maps\moscow_str::hint_stance_check(level.strings["mantle"], "mantle");
		level.strings["melee"] 					= spawnstruct();
		level.strings["melee"]					= maps\moscow_str::hint_melee_check(level.strings["melee"]);
		level.strings["melee"].alignY = "bottom";
		
			level.strings["lookmove"] 				= spawnstruct();
			level.strings["lookmove"].text			= &"MOSCOW_PLATFORM_USE_TO_MOVE_LOOK";
			level.strings["target"] 				= spawnstruct();
			level.strings["target"].text			= &"MOSCOW_PLATFORM_AUTO_AIM";
			level.strings["target_2x"] 				= spawnstruct();
			level.strings["target_2x"].text			= &"MOSCOW_PLATFORM_SWITCH_AIM_TARGET";
			
			level.strings["lookmove"]				thread maps\moscow_str::precache_hud_elm();
			level.strings["target"]					thread maps\moscow_str::precache_hud_elm();
			level.strings["target_2x"]				thread maps\moscow_str::precache_hud_elm();
	}	
	//PC
	else
	{	
		level.strings["aim"] 					= spawnstruct();			
		level.strings["aim"]					= maps\moscow_str::hint_ADS(level.strings["aim"]);
		level.strings["stance_down_1x"] 		= spawnstruct();
		level.strings["stance_down_1x"]			= maps\moscow_str::hint_stand2crouch(level.strings["stance_down_1x"]);
		level.strings["stance_down_2x"] 		= spawnstruct();
		level.strings["stance_down_2x"]			= maps\moscow_str::hint_stand2prone(level.strings["stance_down_2x"]);
		level.strings["stance_up_1x"] 			= spawnstruct();
		level.strings["stance_up_1x"]			= maps\moscow_str::hint_crouch2stand(level.strings["stance_up_1x"]);
		level.strings["stance_up_2x"] 			= spawnstruct();
		level.strings["stance_up_2x"]			= maps\moscow_str::hint_prone2stand(level.strings["stance_up_2x"]);
		level.strings["mantle"] 				= spawnstruct();	
		level.strings["mantle"]					= maps\moscow_str::hint_mantle(level.strings["mantle"]);
		level.strings["melee"] 					= spawnstruct();	
		level.strings["melee"]					= maps\moscow_str::hint_Melee(level.strings["melee"]);	
		
			level.strings["look"] 					= spawnstruct();
			level.strings["look"].text				= &"MOSCOW_PLATFORM_USE_TO_LOOK_AROUND";
			level.strings["move"] 					= spawnstruct();
			level.strings["move"].text				= &"MOSCOW_PLATFORM_USE_TO_MOVE";
			level.strings["move_forward"] 			= spawnstruct();
			level.strings["move_forward"].text		= &"MOSCOW_PLATFORM_MOVE_FORWARD";
			level.strings["move_backward"] 			= spawnstruct();
			level.strings["move_backward"].text		= &"MOSCOW_PLATFORM_MOVE_BACKWARD";
			level.strings["move_left"] 				= spawnstruct();
			level.strings["move_left"].text			= &"MOSCOW_PLATFORM_MOVE_LEFT";
			level.strings["move_right"] 			= spawnstruct();
			level.strings["move_right"].text		= &"MOSCOW_PLATFORM_MOVE_RIGHT";
			
			level.strings["look"] 					thread maps\moscow_str::precache_hud_elm();
			level.strings["move"] 					thread maps\moscow_str::precache_hud_elm();
			level.strings["move_forward"] 			thread maps\moscow_str::precache_hud_elm();
			level.strings["move_backward"] 			thread maps\moscow_str::precache_hud_elm();
			level.strings["move_left"] 				thread maps\moscow_str::precache_hud_elm();
			level.strings["move_right"] 			thread maps\moscow_str::precache_hud_elm();
	}	
	
	level.strings["objectives"] 				thread maps\moscow_str::precache_hud_elm();
	level.strings["grab_potato"] 				thread maps\moscow_str::precache_hud_elm();
	level.strings["grab_weapon"] 				thread maps\moscow_str::precache_hud_elm();
	level.strings["swap_weapon"] 				thread maps\moscow_str::precache_hud_elm();
	level.strings["reload"] 					thread maps\moscow_str::precache_hud_elm();
	level.strings["reload_special"] 			thread maps\moscow_str::precache_hud_elm();
	level.strings["explosives"]					thread maps\moscow_str::precache_hud_elm();
	level.strings["explosives_warn"]			thread maps\moscow_str::precache_hud_elm();
	level.strings["grenade_throw"] 				thread maps\moscow_str::precache_hud_elm();
	level.strings["potato_throw"] 				thread maps\moscow_str::precache_hud_elm();
	
	level.strings["fire"]						thread maps\moscow_str::precache_hud_elm();
	level.strings["weapon_switch"] 				thread maps\moscow_str::precache_hud_elm();
	level.strings["grenade_switch"] 			thread maps\moscow_str::precache_hud_elm();
	level.strings["ladder"] 					thread maps\moscow_str::precache_hud_elm();
	level.strings["melee_approach"] 			thread maps\moscow_str::precache_hud_elm();
	level.strings["objective_hint"] 			thread maps\moscow_str::precache_hud_elm();
	level.strings["stance_hint"] 				thread maps\moscow_str::precache_hud_elm();
	level.strings["smoke_placement"] 			thread maps\moscow_str::precache_hud_elm();
	
	level.strings["aim"]						thread maps\moscow_str::precache_hud_elm();
	level.strings["stance_down_1x"] 			thread maps\moscow_str::precache_hud_elm();
	level.strings["stance_down_2x"] 			thread maps\moscow_str::precache_hud_elm();
	level.strings["stance_up_1x"] 				thread maps\moscow_str::precache_hud_elm();
	level.strings["stance_up_2x"] 				thread maps\moscow_str::precache_hud_elm();
	level.strings["mantle"] 					thread maps\moscow_str::precache_hud_elm();
	level.strings["melee"]						thread maps\moscow_str::precache_hud_elm();
}

precache_hud_elm()
{
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

hint_melee_check(keybind)
{
	keybind.text = undefined;
	keybind.text2 = &"MOSCOW_PLATFORM_PUSH_TO_MELEE_BREATH";;
	keybind.text3 = &"MOSCOW_PLATFORM_CLICK_TO_MELEE";;
	keybind.bind = undefined;
	keybind.checkagain = true;
	
	if( (getcommandfromkey( "BUTTON_RSTICK" ) == "+melee") || (getcommandfromkey( "BUTTON_LSTICK" ) == "+melee") )
		keybind.text = keybind.text3;
	else
		keybind.text = keybind.text2;
	return keybind;
}

hint_stance_check(keybind, name)
{
	keybind.text = undefined;
	keybind.text2 = undefined;
	keybind.text3 = undefined;
	keybind.bind = undefined;
	keybind.checkagain = true;
	if(name == "mantle")
	{
		keybind.text2 = &"MOSCOW_PLATFORM_PRESS_TO_MANTLE";
		keybind.text3 = &"MOSCOW_PLATFORM_PRESS_TO_MANTLE_SINGLE";
	}
	if(name == "stance_up_1x")
	{
		keybind.text2 = &"MOSCOW_PLATFORM_PUSH_TO_STAND";
		keybind.text3 = &"MOSCOW_PLATFORM_PUSH_TO_STAND_SINGLE";
	}
	else if(name == "stance_up_2x")
	{
		keybind.text2 = &"MOSCOW_PLATFORM_PUSH_TWICE_TO_STAND";
		keybind.text3 = &"MOSCOW_PLATFORM_PUSH_TWICE_TO_STAND_SINGLE";
	}
	else if(name == "stance_down_1x")
	{
		keybind.text2 = &"MOSCOW_PLATFORM_PUSH_TO_CROUCH";
		keybind.text3 = &"MOSCOW_PLATFORM_PUSH_TO_CROUCH_SINGLE";
	}
	else if(name == "stance_down_2x")
	{
		keybind.text2 = &"MOSCOW_PLATFORM_PUSH_TWICE_TO_CRAWL";
		keybind.text3 = &"MOSCOW_PLATFORM_PUSH_TWICE_TO_CRAWL_SINGLE";
	}
	
	binding = getKeyBinding("+stance");
	if(binding["count"])
		keybind.text = keybind.text3;
	else
		keybind.text = keybind.text2;
	return keybind;
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
