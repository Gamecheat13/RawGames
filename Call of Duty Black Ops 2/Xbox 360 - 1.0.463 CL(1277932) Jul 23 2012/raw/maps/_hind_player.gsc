/*

 TODO:
  - see what functionality needs to be ported over from inc_pilot::hind_weapon_system()
	- also checkout inc_pilot::fire_rocket(tag) to see if there is any ported functionality needed
	- make it so that the tutorial control stuff isn't always on
*/


#include maps\_vehicle;
#include maps\_utility;
#include common_scripts\utility;

#using_animtree("vehicles");

main()
{
	/*
	precache_models();
	precache_weapons();
	precache_hud();
	*/
	
	self UseAnimTree( #animtree );
	
	init_vehicle_anims(); //-- this includes the landed animation with the gear down
	
	//-- Setup variables for tutorial hud
	self.tut_hud = [];
	self.tut_hud["fly_controls"] = false;
	self.tut_hud["gun_controls"] = false;
	self.tut_hud["rocket_controls"] = false;

	self ent_flag_init("arming_rockets");
	self ent_flag_init("reloading_rockets");
	
	self.console_models = array("t5_veh_helo_hind_ckpitdmg0", "t5_veh_helo_hind_ckpitdmg1", "t5_veh_helo_hind_ckpitdmg2");
	
	self thread landed_animation();
	self thread watch_for_cockpit_switch();
	self thread create_tutorial_hud();
}

precache_models()
{
	//-- This is the model used for the first person view of the pilot of the helicopter
	PreCacheModel("t5_veh_helo_hind_cockpitview");
	PreCacheModel("t5_veh_helo_hind_ckpitdmg0");
	PreCacheModel("t5_veh_helo_hind_ckpitdmg1");
	PreCacheModel("t5_veh_helo_hind_ckpitdmg2");
}

precache_weapons()
{
	PreCacheItem( "hind_minigun_pilot" );
	PreCacheItem( "hind_rockets" );
	PreCacheRumble( "minigun_rumble" );
	PreCacheRumble( "damage_light" );
}

precache_hud()
{
	PreCacheShader( "hud_hind_cannon01" );
	PreCacheShader( "hud_hind_cannon02" );
	PreCacheShader( "hud_hind_cannon03" );
	PreCacheShader( "hud_hind_cannon04" );
	PreCacheShader( "hud_hind_cannon05" );
		
	PreCacheShader( "hud_hind_rocket" );
	PreCacheShader( "hud_hind_rocket_border_left" );
	PreCacheShader( "hud_hind_rocket_border_right" );
	//PreCacheShader( "hud_hind_rocket_charged" );
	//PreCacheShader( "hud_hind_rocket_container" );
	//PreCacheShader( "hud_hind_rocket_ready" );
	
}

//-- SWITCHES THE COCKPIT FOR THE ACCEPTABLE FIRST PERSON VIEW AND BACK
watch_for_cockpit_switch()
{
	self endon("death");
	self endon("animated_switch");
	
	self.cockpit_models = array("t5_veh_helo_hind_cockpitview", "t5_veh_helo_hind_cockpit_damg_low", "t5_veh_helo_hind_cockpit_damg_med", "t5_veh_helo_hind_cockpit_damg_high" );
	self.current_cockpit_state = 0;
	
	while(true)
	{
		while(true)
		{
			self waittill("enter_vehicle", player);
		
			self HidePart( "tag_instrument_warning", "t5_veh_helo_hind_cockpitview" ); //-- turn off the missile warning and radar lock on
			//self HidePart( "tag_instrument_loading", "t5_veh_helo_hind_cockpitview" );
		
			if(IsDefined(player) &&  IsPlayer(player))
			{
				self SetModel(self.cockpit_models[self.current_cockpit_state]);
				
				self.console_model = maps\_utility::spawn("script_model", self.origin);
				self.console_model setmodel("t5_veh_helo_hind_ckpitdmg0");
				self.console_model linkto(self, "origin_animate_jnt", (0,0,0), (0,0,0) );
				
				self HidePart( "tag_window_l_dmg_0a", "t5_veh_helo_hind_cockpitview" );
				self HidePart( "tag_window_l_dmg_0b", "t5_veh_helo_hind_cockpitview" );
				self HidePart( "tag_window_c_dmg_0", "t5_veh_helo_hind_cockpitview" );
				self HidePart( "tag_window_r_dmg_0", "t5_veh_helo_hind_cockpitview" );
				
				self HidePart( "tag_window_l_dmg_1", "t5_veh_helo_hind_cockpitview" );
				self HidePart( "tag_window_c_dmg_1", "t5_veh_helo_hind_cockpitview" );
				self HidePart( "tag_window_r_dmg_1", "t5_veh_helo_hind_cockpitview" );
				
				self HidePart( "tag_window_l_dmg_2", "t5_veh_helo_hind_cockpitview" );
				self HidePart( "tag_window_c_dmg_2", "t5_veh_helo_hind_cockpitview" );
				self HidePart( "tag_window_r_dmg_2", "t5_veh_helo_hind_cockpitview" );
				
				self thread hind_weapons_think();
				break;
			} 
		}
		
		while(true)
		{
			self waittill("exit_vehicle", player);
		
			if(IsDefined(player) &&  IsPlayer(player))
			{
				self notify("hind weapons disabled");
				self setModel("t5_veh_helo_hind_blockout");
				break;
			}
		}
	}
}

flash_warning_indicator() //-- self == hind
{
	self endon("stop_warning_indicator");
	
	self thread stop_warning_indicator();
	for(;;)
	{
		self ShowPart( "tag_instrument_warning", "t5_veh_helo_hind_cockpitview" );
		wait(0.2);
		self HidePart( "tag_instrument_warning", "t5_veh_helo_hind_cockpitview" );
		wait(0.2);
	}
}

stop_warning_indicator()
{
	self waittill("stop_warning_indicator");
	waittillframeend;
	self HidePart( "tag_instrument_warning", "t5_veh_helo_hind_cockpitview");
}

next_cockpit_damage_state() //-- self is the hind
{
	self.current_cockpit_state++;
	assert(self.current_cockpit_state <= self.console_models.size, "Tried to switch the hind to a cockpit damage state that does not exist");
	
	if(self.current_cockpit_state > 2)
	{
		return false;
	}
	
	//self SetModel(self.cockpit_models[self.current_cockpit_state]);
	if( self.current_cockpit_state - 1 < 0 )
	{
		self Detach( self.console_models[self.console_models.size - 1], "origin_animate_jnt" );
	}
	else
	{
		self Detach( self.console_models[self.current_cockpit_state - 1], "origin_animate_jnt" );
	}
	self Attach( self.console_models[self.current_cockpit_state], "origin_animate_jnt");
	
	if(self.current_cockpit_state == 0)
	{
		
		self ShowPart( "tag_window_l_dmg_0a", "t5_veh_helo_hind_cockpitview" );
		self ShowPart( "tag_window_l_dmg_0b", "t5_veh_helo_hind_cockpitview" );
		self ShowPart( "tag_window_c_dmg_0", "t5_veh_helo_hind_cockpitview" );
		self ShowPart( "tag_window_r_dmg_0", "t5_veh_helo_hind_cockpitview" );
				
		self HidePart( "tag_window_l_dmg_1", "t5_veh_helo_hind_cockpitview" );
		self HidePart( "tag_window_c_dmg_1", "t5_veh_helo_hind_cockpitview" );
		self HidePart( "tag_window_r_dmg_1", "t5_veh_helo_hind_cockpitview" );
		
		self HidePart( "tag_window_l_dmg_2", "t5_veh_helo_hind_cockpitview" );
		self HidePart( "tag_window_c_dmg_2", "t5_veh_helo_hind_cockpitview" );
		self HidePart( "tag_window_r_dmg_2", "t5_veh_helo_hind_cockpitview" );
		
		return true;
	}
	else if(self.current_cockpit_state == 1)
	{
		self HidePart( "tag_window_l_dmg_0a", "t5_veh_helo_hind_cockpitview" );
		self HidePart( "tag_window_l_dmg_0b", "t5_veh_helo_hind_cockpitview" );
		self HidePart( "tag_window_c_dmg_0", "t5_veh_helo_hind_cockpitview" );
		self HidePart( "tag_window_r_dmg_0", "t5_veh_helo_hind_cockpitview" );
				
		self ShowPart( "tag_window_l_dmg_1", "t5_veh_helo_hind_cockpitview" );
		self ShowPart( "tag_window_c_dmg_1", "t5_veh_helo_hind_cockpitview" );
		self ShowPart( "tag_window_r_dmg_1", "t5_veh_helo_hind_cockpitview" );
		
		self HidePart( "tag_window_l_dmg_2", "t5_veh_helo_hind_cockpitview" );
		self HidePart( "tag_window_c_dmg_2", "t5_veh_helo_hind_cockpitview" );
		self HidePart( "tag_window_r_dmg_2", "t5_veh_helo_hind_cockpitview" );
		
		return true;
	}
	else if(self.current_cockpit_state == 2)
	{
		
		self HidePart( "tag_window_l_dmg_0a", "t5_veh_helo_hind_cockpitview" );
		self HidePart( "tag_window_l_dmg_0b", "t5_veh_helo_hind_cockpitview" );
		self HidePart( "tag_window_c_dmg_0", "t5_veh_helo_hind_cockpitview" );
		self HidePart( "tag_window_r_dmg_0", "t5_veh_helo_hind_cockpitview" );
				
		self HidePart( "tag_window_l_dmg_1", "t5_veh_helo_hind_cockpitview" );
		self HidePart( "tag_window_c_dmg_1", "t5_veh_helo_hind_cockpitview" );
		self HidePart( "tag_window_r_dmg_1", "t5_veh_helo_hind_cockpitview" );
		
		self ShowPart( "tag_window_l_dmg_2", "t5_veh_helo_hind_cockpitview" );
		self ShowPart( "tag_window_c_dmg_2", "t5_veh_helo_hind_cockpitview" );
		self ShowPart( "tag_window_r_dmg_2", "t5_veh_helo_hind_cockpitview" );
		
		return false;
	}
	
}

debug_cycle_damage_states()
{
	self endon("death");
	
	while(1)
	{
		self next_cockpit_damage_state();
		wait(5);
		if(self.current_cockpit_state + 1 >= self.cockpit_models.size)
		{
			self.current_cockpit_state = -1;
		}
	}
}

hind_weapons_think()
{
	self thread watch_weapon_systems();
}

//-- utility functions for the hind specifically
disable_driver_weapons()
{
	self notify("hind weapons disabled");
	self disable_driver_turret();
	self DisableGunnerFiring(0, true);
	player = get_players()[0];
	player stoploopsound(); //-- make sure I kill the weapon sounds
}

//-- utility functions for the hind specifically
enable_driver_weapons()
{
 	self enable_driver_turret();
 	self thread watch_for_rocket_firing();
}

//-- THIS HANDLES SWITCHING BETWEEN THE DIFFERENT WEAPON SYSTEMS //-- TODO: this might be deprecated
watch_weapon_systems()
{
	self thread watch_for_rockets();
	self thread watch_for_minigun();
}

watch_for_rockets()
{
	self endon("death");
	
	while(true)
	{
		self waittill("switch_to_rockets");
		self switchto_rockets();
	}
}

watch_for_minigun()
{
	self endon("death");
	
	while(true)
	{
		self waittill("switch_to_minigun");
		self switchto_minigun();
	}
}

//-- TODO: make co-op friendly
switchto_rockets()
{
	self SetVehWeapon( "hind_rockets" );
		
	players = get_players();
	players[0] SetClientDvar( "vehHelicopterHeadSwayDontSwayTheTurret", 0);
}

//-- TODO: make co-op friendly
switchto_minigun()
{
		self SetVehWeapon( "hind_minigun_pilot" );
		
		players = get_players();
		players[0] SetClientDvar( "vehHelicopterHeadSwayDontSwayTheTurret", 0);
}


//-- Displays the controls on the screen
create_tutorial_hud( no_wait )
{
	if(!IsDefined(no_wait))
	{
		self waittill("enter_vehicle");
	}
	
	self thread destroy_tutorial_hud();
	
	level.fly_up_hud = newHudElem();
	level.fly_up_hud.fontScale = 1.25;
	level.fly_up_hud.x = 25;
	level.fly_up_hud.y = 53; // original setting: 13 // added 55 units to it
	level.fly_up_hud.alignX = "left";
	level.fly_up_hud.alignY = "top";
	level.fly_up_hud.horzAlign = "left";
	level.fly_up_hud.vertAlign = "top";
	level.fly_up_hud.foreground = true;
	
	if(self.tut_hud["fly_controls"])
	{
		level.fly_up_hud SetText( "Press [{+smoke}] to fly up" );
	}
		
	level.fly_down_hud = newHudElem();
	level.fly_down_hud.fontScale = 1.25;
	level.fly_down_hud.x = 25;
	level.fly_down_hud.y = 68; // original setting: 28 // 
	level.fly_down_hud.alignX = "left";
	level.fly_down_hud.alignY = "top";
	level.fly_down_hud.horzAlign = "left";
	level.fly_down_hud.vertAlign = "top";
	level.fly_down_hud.foreground = true;
	
	if(self.tut_hud["fly_controls"])
	{
		level.fly_down_hud SetText( "Press [{+speed_throw}] to fly down" );
	}
	
	level.fire_hud = newHudElem();
	level.fire_hud.fontScale = 1.25;
	level.fire_hud.x = 25;
	level.fire_hud.y = 93; // original setting: 43
	level.fire_hud.alignX = "left";
	level.fire_hud.alignY = "top";
	level.fire_hud.horzAlign = "left";
	level.fire_hud.vertAlign = "top";
	level.fire_hud.foreground = true;
	
	if(self.tut_hud["gun_controls"])
	{
		level.fire_hud SetText( "[{+attack}] mini-gun" );
	}

	level.rocket_hud = newHudElem();
	level.rocket_hud.fontScale = 1;
	level.rocket_hud.x = 25;
	level.rocket_hud.y = 107; 
	level.rocket_hud.alignX = "left";
	level.rocket_hud.alignY = "top";
	level.rocket_hud.horzAlign = "left";
	level.rocket_hud.vertAlign = "top";
	level.rocket_hud.foreground = true;

	if(self.tut_hud["rocket_controls"])
	{	
		level.rocket_hud SetText( "[{+speed_throw}] rocket pods - [{+usereload}] reload" );
	}
}

update_tutorial_hud()
{
	
	if(self.tut_hud["fly_controls"])
	{
		level.fly_up_hud SetText( "Press [{+smoke}] to fly up" );
	}
	else
	{
		level.fly_up_hud SetText( "" );
	}
		
	if(self.tut_hud["fly_controls"])
	{
		level.fly_down_hud SetText( "Press [{+speed_throw}] to fly down." );
	}
	else
	{
		level.fly_down_hud SetText( "" );
	}
	
	if(self.tut_hud["gun_controls"])
	{
		level.fire_hud SetText( "[{+attack}] mini-gun" );
	}
	else
	{
		level.fire_hud SetText( "" );
	}

	if(self.tut_hud["rocket_controls"])
	{	
		level.rocket_hud SetText( "[{+speed_throw}] rocket pods - [{+usereload}] reload" );
	}
	else
	{
		level.rocket_hud SetText( "" );
	}
	
}

destroy_tutorial_hud()
{
	self waittill("exit_vehicle");
	
	self thread create_tutorial_hud();
	
	level.fly_up_hud Destroy();
	level.fly_down_hud Destroy();
	level.fire_hud Destroy();
	level.rocket_hud Destroy();
}

//------------------------------------ Rocket Firing -----------------------------------//

/* -------------------------------------------------------
self = vehicle

Watches for player input for firing/arming rockets
and sets flags/notfies for the current state.
--------------------------------------------------------*/
watch_for_rocket_firing()
{
	self endon("death");
	self endon("hind weapons disabled");

	self setup_rockets();

	/#
		self thread debug_rocket_targetting();
	#/

	// gunner firing is scripted so disable it
	self DisableGunnerFiring(0, true);
	
	self thread fire_rockets();

	//update_rocket_hud(undefined, self._rocket_pods.free_rockets);
	
	//-- keep track of the player arming and firing rockets and set flags and notifies
	while (true)
	{
		player = get_players()[0];
		while(!player ThrowButtonPressed() || self._rocket_pods.free_rockets <= 0)
		{
			wait .05;
		}

		self ent_flag_clear("reloading_rockets");
		self ent_flag_set("arming_rockets");

		player = get_players()[0];
		while (player ThrowButtonPressed())
		{
			wait (.05);
		}

		self ent_flag_clear("arming_rockets");
		self notify("fire_rockets");
	}

}

/* -------------------------------------------------------
self = vehicle

Calls function to arm the rockets and fires them.
--------------------------------------------------------*/
fire_rockets()
{
	self endon("death");
	self endon("hind weapons disabled");

	while(true)
	{
		rockets = self arm_rockets();

		//update_rocket_hud( undefined, self._rocket_pods.free_rockets ); // clear hud

		for (i = 0; i < rockets.size; i++)
		{
			self fire_rocket(rockets[i]);
		}
		
		//-- Unlimited rocket ammo with no reloading for the demo
		if(IsDefined(level.pow_demo) && level.pow_demo)
		{
			if(self._rocket_pods.free_rockets < 3)
			{
				self._rocket_pods.free_rockets = self._rocket_pods.total_rockets;
			}
		}
		
		self.armed_rockets = 0;
		wait(.05);
	}
}

/* -------------------------------------------------------
self = vehicle

Go through all the rockets and arm them sequentially until
all are armed or player quits arming.

return: array of the armed rockets
--------------------------------------------------------*/
arm_rockets()
{
	self ent_flag_wait("arming_rockets");

	armed_rockets = [];
	while(armed_rockets.size < self._rocket_pods.total_rockets && self._rocket_pods.free_rockets > 0)
	{
		for(pod_index = self._rocket_pods.pod_index; pod_index < self._rocket_pods.pods.size; pod_index++)
		{
			pod = self._rocket_pods.pods[pod_index];
			for(rocket_index = 0; rocket_index < pod.rockets.size; rocket_index++)
			{
				rocket = pod.rockets[rocket_index];
				if (!rocket.is_armed)
				{
					arm_time = 0;
					if (armed_rockets.size)
					{
						//-- apply arm_time for all but the first rocket
						arm_time = self._rocket_pods.arm_time;
					}

					rocket = arm_single_rocket(rocket, arm_time);

					if(self ent_flag("arming_rockets"))
					{
						//-- if still arming rockets, add the newly armed rocket to the array

						armed_rockets = add_to_array(armed_rockets, rocket);
						self._rocket_pods.free_rockets--;
						self.armed_rockets = armed_rockets.size;
						self notify( "charged_rocket");
						//update_rocket_hud(armed_rockets.size, self._rocket_pods.free_rockets);
						advance_pod_index();
						playsoundatposition("wpn_rocket_prime_chopper_trigger", (0,0,0));
						
						if (armed_rockets.size > 1)
						{
							playsoundatposition ("wpn_rocket_prime_chopper", (0,0,0));	
						}							

						break; //armed a rocket so go to next pod
					}
					else
					{
						//-- not arming anymore, return our armed rockets so they can fire
						// TUEY thread the panned reload sounds (left rear\right rear)
						level thread reload_chopper_sounds();
						return armed_rockets;
					}
				}
			}
		}
	}

	//-- at this point all rockets are armed, fire automatically or when the player releases
	//self waittill_notify_or_timeout("fire_rockets", .5);
	
	//-- GLocke (12/9/09): removed the autofire when all rockets are armed.
	self waittill( "fire_rockets");
	
	return armed_rockets;
}
reload_chopper_sounds()
{
	if(!IsDefined ( level.reload_string))
	{
		level.reload_string = "left";	
	}
	if ( level.reload_string == "left")
	{
		playsoundatposition ("wpn_rocket_reload_chopper_left_battery", (0,0,0));
		level.reload_string = "right";
	}
	else
	{
		playsoundatposition ("wpn_rocket_reload_chopper_right_battery", (0,0,0));
		level.reload_string = "left";	
	}	
	
	
}
/* -------------------------------------------------------
self = vehicle

Keep track of pod index so we keep alternating which pod
to fire out of.
--------------------------------------------------------*/
advance_pod_index()
{
	if (self._rocket_pods.pod_index == self._rocket_pods.pods.size - 1)
	{
		self._rocket_pods.pod_index = 0;
	}
	else
	{
		self._rocket_pods.pod_index++;
	}
}


/* -------------------------------------------------------
self = vehicle

Returns the rocket after the specified arming time or
quits if the rockets are fired.
--------------------------------------------------------*/
arm_single_rocket(rocket, time)
{
	self endon("fire_rockets");
	wait(time);
	rocket.is_armed = true;
	return rocket;
}

/* -------------------------------------------------------
self = vehicle

Add rocket pods.
--------------------------------------------------------*/
setup_rockets()
{
	//-- value is used for the hud
	self.armed_rockets = 0;
	
	self add_rocket_pod(self, "tag_flash_gunner1", 4);
	self add_rocket_pod(create_right_rocket_pod(), undefined, 4);
	
	self track_available_rockets();
}

// self = rocket manager
add_rocket_pod(entity, tag, num_rockets)
{
	//-- set up struct to keep track of everything
	if (!IsDefined(self._rocket_pods))
	{
		self._rocket_pods = SpawnStruct();
		self._rocket_pods.arm_time = .6;
		self._rocket_pods.fire_wait = .15;
		self._rocket_pods.total_rockets = 0;
		self._rocket_pods.free_rockets = 0;
		self._rocket_pods.pod_index = 0;

		//-- take a look at this after the demo
		self thread cleanup_rocket_pods();
	}

	self._rocket_pods.total_rockets += num_rockets;
	self._rocket_pods.free_rockets += num_rockets;

	//-- set up array of pods
	if (!IsDefined(self._rocket_pods.pods))
	{
		self._rocket_pods.pods = [];
	}

	pod_index = self._rocket_pods.pods.size;
	self._rocket_pods.pods[pod_index] = SpawnStruct();
	self._rocket_pods.pods[pod_index].ent = entity;
	self._rocket_pods.pods[pod_index].tag = tag;

	rockets = [];
	for (i = 0; i < num_rockets; i++)
	{
		rockets[i] = SpawnStruct();
		rockets[i].pod_index = pod_index;
		rockets[i].is_armed = false;
	}

	self._rocket_pods.pods[pod_index].rockets = rockets;
}

//self = rocket manager
track_available_rockets()
{
	//self.rocket_pods.free_rockets == available ammo
	assert( IsDefined(self._rocket_pods.free_rockets), "Hind rockets don't have a defined ammo amount" );
	
	//self thread rocket_regen();
	self thread rocket_reload();
	self thread rocket_reload_button();
	
}

//self = rocket manager
rocket_regen()
{
	self endon("death");
	self endon("hind weapons disabled");
	
	while(1)
	{
		if( !self ent_flag("arming_rockets") && self._rocket_pods.free_rockets < self._rocket_pods.total_rockets )
		{
			wait(3);
			if(!self ent_flag("arming_rockets"))
			{
				self._rocket_pods.free_rockets++;
				//update_rocket_hud(undefined, self._rocket_pods.free_rockets);
			}
		}
		else
		{
			wait(0.05);
		}
	}
}

rocket_reload()
{
	self endon("death");
	self endon("hind weapons disabled");
	
	while(1)
	{
		while( self._rocket_pods.free_rockets > 0  || self ent_flag("arming_rockets"))
		{
			wait(0.1);
		}
		
		if(!self ent_flag("reloading_rockets")) //-- somehow the button reload triggered first
		{
			self notify("rocket_reload", self._rocket_pods.free_rockets );
			self ent_flag_set("reloading_rockets"); //disables the ability to fire rockets at this time even though there is ammo left
			//update_rocket_hud(undefined, self._rocket_pods.free_rockets, true);
			wait(1.5);
			while ( self._rocket_pods.free_rockets < self._rocket_pods.total_rockets && ent_flag("reloading_rockets") )
			{
				self._rocket_pods.free_rockets++;
				
				level thread reload_chopper_sounds();
				self notify("reloaded_rocket");
				//playsoundatposition ("wpn_rocket_reload_chopper_battery", (0,0,0));
				wait(0.5);			
			}
			//update_rocket_hud(undefined, self._rocket_pods.free_rockets, false);
			self ent_flag_clear("reloading_rockets");
			playsoundatposition ("wpn_rocket_reload_chopper_reloaded_buzzer", (0,0,0));
		}
	}
}

rocket_reload_button()
{
	self endon("death");
	self endon("hind weapons disabled");
	
	//TODO: take this out
	player = get_players()[0];
		
	while(1)
	{
		while(self._rocket_pods.free_rockets >= self._rocket_pods.total_rockets || self ent_flag("arming_rockets") || self ent_flag("reloading_rockets"))
		{
			wait(0.1);
		}
		
		while(!player UseButtonPressed())
		{
			wait(0.05);
		}	
		
		if(!self ent_flag("reloading_rockets")) //-- autoreload triggered first
		{
			self notify("rocket_reload", self._rocket_pods.free_rockets );
			self ent_flag_set("reloading_rockets");
			//update_rocket_hud(undefined, self._rocket_pods.free_rockets, true );
			while ( self._rocket_pods.free_rockets < self._rocket_pods.total_rockets && ent_flag("reloading_rockets") )
			{
				self._rocket_pods.free_rockets++;
				
				level thread reload_chopper_sounds();
				self notify("reloaded_rocket");
			//	playsoundatposition ("wpn_rocket_reload_chopper_battery", (0,0,0));
				wait(0.5);			
			}
			//self._rocket_pods.free_rockets = self._rocket_pods.total_rockets;
			//update_rocket_hud(undefined, self._rocket_pods.free_rockets, false);
			self ent_flag_clear("reloading_rockets");
			playsoundatposition ("wpn_rocket_reload_chopper_reloaded_buzzer", (0,0,0));
		}
	}
}

cleanup_rocket_pods()
{
	self waittill("death");

	for (pod_index = 0; pod_index < self._rocket_pods.pods.size; pod_index++)
	{
		pod = self._rocket_pods.pods[pod_index];

		array_delete(pod.rockets);
		pod Delete();
	}

	self._rocket_pods Delete();
}

/* -------------------------------------------------------
self = vehicle

Creates the rocket pod that sits on the right side of the
cockpit.
--------------------------------------------------------*/
create_right_rocket_pod()
{
	//-- The offset from the helicopter for the opposite rocket pod from the actual gunner weapon
	rocket_pod_origin = self GetTagOrigin("tag_flash_gunner1");
	rocket_pod_offset = self.origin - rocket_pod_origin;

	rocket_pod = Spawn("script_origin", rocket_pod_origin);
	rocket_pod.origin = (self.origin[0] + rocket_pod_offset[0], self.origin[1] + rocket_pod_offset[1], rocket_pod_origin[2]);
	rocket_pod LinkTo(self);

	return rocket_pod;
}

/* -------------------------------------------------------
self = vehicle

Used to find the position that a rocket should fire from.
--------------------------------------------------------*/
get_rocket_pod_fire_pos(pod_index)
{
	pod = self._rocket_pods.pods[pod_index];
	
	pos = pod.ent.origin;
	if (IsDefined(pod.tag))
	{
		pos = pod.ent GetTagOrigin(pod.tag);
	}

	return pos;
}

/* -------------------------------------------------------
self = vehicle

Fires the rocket that's passed in.
--------------------------------------------------------*/
fire_rocket(rocket)
{
	trace_origin = self GetTagOrigin("tag_flash");
	trace_angles = self GetTagAngles("tag_flash");
	forward = AnglesToForward(trace_angles);
	start_origin = get_rocket_pod_fire_pos(rocket.pod_index);	

	//-- Do a trace so that the rockets hit closer to the reticule when you are closer to your target
	trace_origin = self GetTagOrigin("tag_flash");
	trace_direction = self GetTagAngles("tag_barrel");
	trace_direction = AnglesToForward(trace_direction) * 5000;
	trace = BulletTrace( trace_origin, trace_origin + trace_direction, false, self );
	
	trace_dist_sq = DistanceSquared( trace_origin, trace["position"] );
	if(  trace_dist_sq < 5000*5000 && trace_dist_sq > 500*500 )
	{
		end_origin = trace["position"];
	}
	else
	{
		end_origin = start_origin + (forward * 1000);	
	}
	
	get_players()[0] PlayRumbleOnEntity( "damage_light" );
	MagicBullet( "hind_rockets", start_origin, end_origin, self );
	rocket.is_armed = false;
	self notify("fired_rocket");
	wait(self._rocket_pods.fire_wait);
}

/* -------------------------------------------------------
self = vehicle

Update the rocket HUD with how many rockets are armed.
--------------------------------------------------------*/
update_rocket_hud(rocket_count, ammo_left, reloading)
{
	if(IsDefined(self.rocket_reloading) && self.rocket_reloading && !IsDefined(reloading))
	{
		
		return;
	}
	
	if(!IsDefined(level._rocket_hud))
	{
		level._rocket_hud = NewClientHudElem(get_players()[0]);
		level._rocket_hud.horzAlign = "center";
		level._rocket_hud.vertAlign = "middle";
		level._rocket_hud.alignX = "center";
		level._rocket_hud.alignY = "bottom";
		level._rocket_hud.y = 5;
	}
	
	if(!IsDefined(level._rocket_hud_ammo))
	{
		level._rocket_hud_ammo = NewClientHudElem(get_players()[0]);
		level._rocket_hud_ammo.horzAlign = "center";
		level._rocket_hud_ammo.vertAlign = "middle";
		level._rocket_hud_ammo.alignX = "center";
		level._rocket_hud_ammo.alignY = "bottom";
		level._rocket_hud_ammo.y = 30;
	}

	if(IsDefined(rocket_count))
	{
		level._rocket_hud SetText(rocket_count);
	}
	else
	{
		level._rocket_hud SetText("");
	}
	
	if(IsDefined(reloading) && reloading)
	{
		self.rocket_reloading = true;
		level._rocket_hud_ammo SetText( "*Reloading*" );
	}
	else if(IsDefined(reloading) && !reloading)
	{
		self.rocket_reloading = false;
		level._rocket_hud_ammo SetText( "Rocket Ammo: " + ammo_left );
	}
	else
	{
		level._rocket_hud_ammo SetText( "Rocket Ammo: " + ammo_left );
	}
}

/#
debug_rocket_targetting()
{
	//-- TODO: Rip this out if it never gets used
	if(1) return;

	for(;;)
	{
		rocket_pod_origin = self GetTagOrigin("tag_flash_gunner1");
		rocket_pod_angles = self GetTagAngles("tag_flash_gunner1");
		//rocket_pod_angles = self.angles;

		//trace = BulletTrace( rocket_pod_origin + (50 * AnglesToForward(rocket_pod_angles)), rocket_pod_origin + ( 1000 * AnglesToForward(rocket_pod_angles)), true, undefined );

		forward = AnglesToForward(rocket_pod_angles);

		line( rocket_pod_origin + (2500 * forward), rocket_pod_origin + (8000 * forward), (1,0,0), 20, 1, 1);
		line( self.other_rocket_pod.origin + (2500 * forward), self.other_rocket_pod.origin + (8000 * forward), (1,0,0), 20, 1, 1);
		wait(0.05);
	}
}
#/


///////////////////////////////////////////////////
//
// 	Weapon HUD
//
///////////////////////////////////////////////////

//TODO: rewrite this using loops so its easier to update.

hud_rocket_create()
{
	if(!IsDefined(self.rocket_hud))
	{
		self.rocket_hud = [];
	}
	
	
	self.rocket_hud["border_left"] = newHudElem();
	self.rocket_hud["border_left"].alignX = "left";
	self.rocket_hud["border_left"].alignY = "bottom";
	self.rocket_hud["border_left"].horzAlign = "user_left";
	self.rocket_hud["border_left"].vertAlign = "user_bottom";
	self.rocket_hud["border_left"].y = 0;
	self.rocket_hud["border_left"].x = 2;
	self.rocket_hud["border_left"].alpha = 1.0;
	self.rocket_hud["border_left"] fadeOverTime( 0.05 );
	self.rocket_hud["border_left"] SetShader( "hud_hind_rocket_border_left", 72, 20 );
	self.rocket_hud["border_left"].hidewheninmenu = true;
	
		
	self.rocket_hud["ammo7"] = newHudElem();
	self.rocket_hud["ammo7"].alignX = "left";
	self.rocket_hud["ammo7"].alignY = "bottom";
	self.rocket_hud["ammo7"].horzAlign = "user_left";
	self.rocket_hud["ammo7"].vertAlign = "user_bottom";
	self.rocket_hud["ammo7"].y = -8;
	self.rocket_hud["ammo7"].x = -2;
	self.rocket_hud["ammo7"].alpha = 0.55;
	self.rocket_hud["ammo7"] fadeOverTime( 0.05 );
	self.rocket_hud["ammo7"] SetShader( "hud_hind_rocket", 48, 48 );
	self.rocket_hud["ammo7"].hidewheninmenu = true;
	
	self.rocket_hud["ammo5"] = newHudElem();
	self.rocket_hud["ammo5"].alignX = "left";
	self.rocket_hud["ammo5"].alignY = "bottom";
	self.rocket_hud["ammo5"].horzAlign = "user_left";
	self.rocket_hud["ammo5"].vertAlign = "user_bottom";
	self.rocket_hud["ammo5"].alpha = 0.55;
	self.rocket_hud["ammo5"] fadeOverTime( 0.05 );
	self.rocket_hud["ammo5"].y = -8;
	self.rocket_hud["ammo5"].x = 8;
	self.rocket_hud["ammo5"] SetShader( "hud_hind_rocket", 48, 48 );
	self.rocket_hud["ammo5"].hidewheninmenu = true;
	
	
	self.rocket_hud["ammo3"] = newHudElem();
	self.rocket_hud["ammo3"].alignX = "left";
	self.rocket_hud["ammo3"].alignY = "bottom";
	self.rocket_hud["ammo3"].horzAlign = "user_left";
	self.rocket_hud["ammo3"].vertAlign = "user_bottom";
	self.rocket_hud["ammo3"].alpha = 0.55;
	self.rocket_hud["ammo3"] fadeOverTime( 0.05 );
	self.rocket_hud["ammo3"].y = -8;
	self.rocket_hud["ammo3"].x = 18;
	self.rocket_hud["ammo3"] SetShader( "hud_hind_rocket", 48, 48 );
	self.rocket_hud["ammo3"].hidewheninmenu = true;
	
	
	self.rocket_hud["ammo1"] = newHudElem();
	self.rocket_hud["ammo1"].alignX = "left";
	self.rocket_hud["ammo1"].alignY = "bottom";
	self.rocket_hud["ammo1"].horzAlign = "user_left";
	self.rocket_hud["ammo1"].vertAlign = "user_bottom";
	self.rocket_hud["ammo1"].alpha = 0.55;
	self.rocket_hud["ammo1"] fadeOverTime( 0.05 );
	self.rocket_hud["ammo1"].y = -8;
	self.rocket_hud["ammo1"].x = 28;
	self.rocket_hud["ammo1"] SetShader( "hud_hind_rocket", 48, 48 );
	self.rocket_hud["ammo1"].hidewheninmenu = true;
	
	self.rocket_hud["button"] = newHudElem();
	self.rocket_hud["button"].alignX = "left";
	self.rocket_hud["button"].alignY = "bottom";
	self.rocket_hud["button"].horzAlign = "user_left";
	self.rocket_hud["button"].vertAlign = "user_bottom";
	self.rocket_hud["button"].y = -8;
	self.rocket_hud["button"].foreground = true;
	self.rocket_hud["button"] SetText("[{+speed_throw}]");
	self.rocket_hud["button"].hidewheninmenu = true;

	if (level.ps3)
	{
		self.rocket_hud["button"].x = 56;
		self.rocket_hud["button"].fontscale = 2.5;
	}
	else
	{
		self.rocket_hud["button"].x = 60;
		self.rocket_hud["button"].fontscale = 1;
	}
	
	self.rocket_hud["border_right"] = newHudElem();
	self.rocket_hud["border_right"].alignX = "left";
	self.rocket_hud["border_right"].alignY = "bottom";
	self.rocket_hud["border_right"].horzAlign = "user_left";
	self.rocket_hud["border_right"].vertAlign = "user_bottom";
	self.rocket_hud["border_right"].y = 0;
	self.rocket_hud["border_right"].x = 61;
	self.rocket_hud["border_right"].alpha = 1.0;
	self.rocket_hud["border_right"] fadeOverTime( 0.05 );
	self.rocket_hud["border_right"] SetShader( "hud_hind_rocket_border_right", 72, 20 );
	self.rocket_hud["border_right"].hidewheninmenu = true;
	
	self.rocket_hud["ammo2"] = newHudElem();
	self.rocket_hud["ammo2"].alignX = "left";
	self.rocket_hud["ammo2"].alignY = "bottom";
	self.rocket_hud["ammo2"].horzAlign = "user_left";
	self.rocket_hud["ammo2"].vertAlign = "user_bottom";
	self.rocket_hud["ammo2"].alpha = 0.55;
	self.rocket_hud["ammo2"] fadeOverTime( 0.05 );
	self.rocket_hud["ammo2"].y = -8;
	self.rocket_hud["ammo2"].x = 58;
	self.rocket_hud["ammo2"] SetShader( "hud_hind_rocket", 48, 48 );
	self.rocket_hud["ammo2"].hidewheninmenu = true;
	
	self.rocket_hud["ammo4"] = newHudElem();
	self.rocket_hud["ammo4"].alignX = "left";
	self.rocket_hud["ammo4"].alignY = "bottom";
	self.rocket_hud["ammo4"].horzAlign = "user_left";
	self.rocket_hud["ammo4"].vertAlign = "user_bottom";
	self.rocket_hud["ammo4"].alpha = 0.55;
	self.rocket_hud["ammo4"] fadeOverTime( 0.05 );
	self.rocket_hud["ammo4"].y = -8;
	self.rocket_hud["ammo4"].x = 68;
	self.rocket_hud["ammo4"] SetShader( "hud_hind_rocket", 48, 48 );
	self.rocket_hud["ammo4"].hidewheninmenu = true;
	
	self.rocket_hud["ammo6"] = newHudElem();
	self.rocket_hud["ammo6"].alignX = "left";
	self.rocket_hud["ammo6"].alignY = "bottom";
	self.rocket_hud["ammo6"].horzAlign = "user_left";
	self.rocket_hud["ammo6"].vertAlign = "user_bottom";
	self.rocket_hud["ammo6"].alpha = 0.55;
	self.rocket_hud["ammo6"] fadeOverTime( 0.05 );
	self.rocket_hud["ammo6"].y = -8;
	self.rocket_hud["ammo6"].x = 78;
	self.rocket_hud["ammo6"] SetShader( "hud_hind_rocket", 48, 48 );
	self.rocket_hud["ammo6"].hidewheninmenu = true;
	
	self.rocket_hud["ammo8"] = newHudElem();
	self.rocket_hud["ammo8"].alignX = "left";
	self.rocket_hud["ammo8"].alignY = "bottom";
	self.rocket_hud["ammo8"].horzAlign = "user_left";
	self.rocket_hud["ammo8"].vertAlign = "user_bottom";
	self.rocket_hud["ammo8"].alpha = 0.55;
	self.rocket_hud["ammo8"] fadeOverTime( 0.05 );
	self.rocket_hud["ammo8"].y = -8;
	self.rocket_hud["ammo8"].x = 88;
	self.rocket_hud["ammo8"] SetShader( "hud_hind_rocket", 48, 48 );
	self.rocket_hud["ammo8"].hidewheninmenu = true;
	
	//self.rocket_hud["rocket_charged"] SetShader( "hud_hind_rocket_charged", 12, 12 );
	
	self thread hud_rocket_think();
	self thread hud_rocket_destroy();
}

hud_rocket_destroy()
{
	self waittill("hind weapons disabled");

	self.rocket_hud["border_left"] Destroy();
	self.rocket_hud["ammo7"] Destroy();
	self.rocket_hud["ammo5"] Destroy();
	self.rocket_hud["ammo3"] Destroy();
	self.rocket_hud["ammo1"] Destroy();
	self.rocket_hud["button"] Destroy();
	self.rocket_hud["border_right"] Destroy();
	self.rocket_hud["ammo2"] Destroy();
	self.rocket_hud["ammo4"] Destroy();
	self.rocket_hud["ammo6"] Destroy();
	self.rocket_hud["ammo8"] Destroy();
}

hud_rocket_think()
{
	self waittill("activate_hud");
	self endon("hind weapons disabled");
	
	while(1)
	{
		//self waittill_any("fired_rocket", "charged_rocket", "reloaded_rocket");
		
		for(i = 1; i < 9; i++ )
		{
			if( i - 1 <  self._rocket_pods.free_rockets )
			{
				//-- rocket exists, but not armed
				self.rocket_hud["ammo" + i] SetShader( "hud_hind_rocket", 48, 48 );
				self.rocket_hud["ammo" + i].alpha = 0.45;
				self.rocket_hud["ammo" + i] fadeOverTime( 0.05 );
			}
			else if( i <= self._rocket_pods.free_rockets + self.armed_rockets )
			{
				self.rocket_hud["ammo" + i] SetShader( "hud_hind_rocket", 48, 48 );
				self.rocket_hud["ammo" + i].alpha = 0.9;
				self.rocket_hud["ammo" + i] fadeOverTime( 0.05 );
			}
			else
			{
				//-- no rocket
				self.rocket_hud["ammo" + i] SetShader( "hud_hind_rocket", 48, 48 );
				self.rocket_hud["ammo" + i].alpha = 0;
				self.rocket_hud["ammo" + i] fadeOverTime( 0.05 );					
			}			
		}
		wait(0.05);
	}
}

hud_minigun_create()
{
	
	if(!IsDefined(self.minigun_hud))
	{
		self.minigun_hud = [];
	}
	
	self.minigun_hud["gun"] = newHudElem();
	self.minigun_hud["gun"].alignX = "right";
	self.minigun_hud["gun"].alignY = "bottom";
	self.minigun_hud["gun"].horzAlign = "user_right";
	self.minigun_hud["gun"].vertAlign = "user_bottom";
	self.minigun_hud["gun"].alpha = 0.55;
	self.minigun_hud["gun"] fadeOverTime( 0.05 );
	self.minigun_hud["gun"] SetShader( "hud_hind_cannon01", 64, 64 );
	self.minigun_hud["gun"].hidewheninmenu = true;
	
	self.minigun_hud["button"] = newHudElem();
	self.minigun_hud["button"].alignX = "right";
	self.minigun_hud["button"].alignY = "bottom";
	self.minigun_hud["button"].horzAlign = "user_right";
	self.minigun_hud["button"].vertAlign = "user_bottom";
	self.minigun_hud["button"].x = -52;
	self.minigun_hud["button"].y = -6;
	self.minigun_hud["button"].foreground = true;
	self.minigun_hud["button"] SetText("[{+attack}]");
	self.minigun_hud["button"].hidewheninmenu = true;
	
	if (level.ps3)
	{
		self.minigun_hud["button"].x = -55;
		self.minigun_hud["button"].fontscale = 2.5;
	}
	else
	{
		self.minigun_hud["button"].x = -52;
		self.minigun_hud["button"].fontscale = 1.0;
	}
	
	self thread hud_minigun_think();	
	self thread hud_minigun_destroy();
}

hud_minigun_destroy()
{
	self waittill("hind weapons disabled");
	
	self.minigun_hud["gun"] Destroy();
	self.minigun_hud["button"] Destroy();
}

minigun_sound()
{
	self waittill("activate_hud");
	self endon("hind weapons disabled");
	
	player = get_players()[0];
	
	while(1)
	{
		while(!player AttackButtonPressed())
		{
			wait(0.05);
		}		
	
		while(player AttackButtonPressed())
		{
			wait(0.05);
			player playloopsound( "wpn_hind_pilot_fire_loop_plr" );
		}
		player stoploopsound();
		player playsound( "wpn_hind_pilot_stop_plr" );
	}
}

hud_minigun_think()
{
	self waittill("activate_hud");
	self endon("hind weapons disabled");
	
	player = get_players()[0];
	
	while(1)
	{
		while(!player AttackButtonPressed())
		{
			wait(0.05);
		}
			
		swap_counter = 1;
		self.minigun_hud["gun"] fadeOverTime( 0.05 );
		self.minigun_hud["gun"].alpha = 0.65;
	
		while(player AttackButtonPressed())
		{
			wait(0.05);
			player playloopsound( "wpn_hind_pilot_fire_loop_plr" );
			
			self.minigun_hud["gun"] SetShader( "hud_hind_cannon0" + swap_counter, 64, 64 );
			
			if(swap_counter == 5)
			{
				swap_counter = 1;
			}
			else
			{
				swap_counter++;	
			}
		}
		
		self.minigun_hud["gun"] SetShader( "hud_hind_cannon01", 64, 64 );
		self.minigun_hud["gun"] fadeOverTime( 0.05 );
		self.minigun_hud["gun"].alpha = 0.55;
		player stoploopsound();
		player playsound( "wpn_hind_pilot_stop_plr" );
	}
}












///////////////////////////////////////////////////
//
// Player entering the helicopter stuff
//
///////////////////////////////////////////////////

make_player_usable()
{
	self endon("disable player entry");
	
	init_player_anims();
	//init_vehicle_anims();
	
	if(!IsDefined(self.enter_trig))
	{
		trig_origin = self GetTagOrigin("tag_driver");
		self.enter_trig = Spawn("trigger_radius", trig_origin - (0,0,500), 0, 52, 1000); 
	}
	
	while(1)
	{
		self.enter_trig waittill("trigger", who);
		
		if( IsPlayer(who) )
		{
			if(who GetStance() != "stand")
			{
				while(who.divetoprone)
				{
					wait(0.2);
				}
				
				who FreezeControls(true);
				
				who SetStance( "stand" );
				wait(0.5);
				who FreezeControls(false);
			}
			
			self notify("animated_switch");
			
			//SOUND - Shawn J - enter hind sounds
			playsoundatposition("evt_hind_climb_1",(0,0,0));
	
			level.animating_helicopter = self; //-- This is used by the notetrack function to setup the right helicopter
			self player_enter_animation(who);
			//self UseBy(who);
			self notify("player_entered");
			return;
		}
		else
		{
			wait(0.05);
		}
	}
}

make_player_unusable()
{
	self notify("disable player entry");
}

swap_for_interior( guy, no_attach )
{
	level.animating_helicopter SetModel("t5_veh_helo_hind_cockpitview");
	
	if( !IsDefined(no_attach) || !no_attach )
	{
		level.animating_helicopter Attach("t5_veh_helo_hind_ckpitdmg0", "origin_animate_jnt");
	}
	
	/*
	level.animating_helicopter HidePart( "tag_window_l_dmg_0a", "t5_veh_helo_hind_cockpitview" );
	level.animating_helicopter HidePart( "tag_window_l_dmg_0b", "t5_veh_helo_hind_cockpitview" );
	level.animating_helicopter HidePart( "tag_window_c_dmg_0", "t5_veh_helo_hind_cockpitview" );
	level.animating_helicopter HidePart( "tag_window_r_dmg_0", "t5_veh_helo_hind_cockpitview" );
	*/
	
	level.animating_helicopter HidePart( "tag_window_l_dmg_1", "t5_veh_helo_hind_cockpitview" );
	level.animating_helicopter HidePart( "tag_window_c_dmg_1", "t5_veh_helo_hind_cockpitview" );
	level.animating_helicopter HidePart( "tag_window_r_dmg_1", "t5_veh_helo_hind_cockpitview" );
	
	level.animating_helicopter HidePart( "tag_window_l_dmg_2", "t5_veh_helo_hind_cockpitview" );
	level.animating_helicopter HidePart( "tag_window_c_dmg_2", "t5_veh_helo_hind_cockpitview" );
	level.animating_helicopter HidePart( "tag_window_r_dmg_2", "t5_veh_helo_hind_cockpitview" );
	
	level.animating_helicopter notify("switch_climbin_anim");
	
	level.animating_helicopter = undefined;
}

swap_for_exterior( guy )
{
	level.animating_helicopter SetModel("t5_veh_helo_hind_blockout");
	level.animating_helicopter notify("switch_climbout_anim");
	
	level.animating_helicopter = undefined;
}

#using_animtree("player");
player_enter_animation(player)
{
	player AllowPickupWeapons( false );
	
	player_body = spawn_anim_model( "hind_body", player.origin, player.angles );
	self.player_body = player_body;
	player_body Hide();
	
	//TODO: rewrite this after the demo so it's not using the pow utility script
	player_body LinkTo(self, "origin_animate_jnt" );
	//player_body thread maps\pow_utility::temp_dialogue_and_logic_takeoff();
	self notify("playing takeoff animation");
	self thread maps\_anim::anim_single_aligned(player_body, "playable_hind_climbin", "origin_animate_jnt");
	self thread exterior_window_anim();
	
	wait( 0.10 );
	
	//player StartCameraTween(0.5);	
	//player TakeAllWeapons();
	player thread take_and_giveback_weapons("playable_hind_climbin");
	player PlayerLinkToAbsolute(player_body, "tag_player");
	//player PlayerLinkToDelta( player_body, "tag_player", 1, 30, 30, 20, 10, false );
	
	player_body Attach( "t5_veh_helo_hind_cockpit_control", "tag_weapon" );

	player_body Show();

	while(self GetSpeed() > 0.1)
	{
		wait(0.05);
	}
	
	self waittill( "playable_hind_climbin" );
	player notify("playable_hind_climbin");
	
	player AllowPickupWeapons( true );
}

player_exit_animation(player)
{
	self notify("animated_switch"); //-- For Jumptos
	
	//-- for notetrack functions
	level.animating_helicopter = self;
	
	if(!IsDefined(self.player_body))
	{
		player_body = spawn_anim_model( "hind_body", player.origin, player.angles );
		self.player_body = player_body;
		player_body Hide();
		
		player_body LinkTo(self, "origin_animate_jnt" );
	}
	else
	{
		player_body = self.player_body;
		self.player_body.animname = "hind_body";
	}
	
	self notify("playing landing animation");
	self thread maps\_anim::anim_single_aligned(player_body, "playable_hind_climbout", "origin_animate_jnt");
	self thread interior_window_anim_exit();
	
	wait( 0.10 );
	
	self Useby(player);
	
	self notify("hind weapons disabled"); //-- turn off the rockets, so they don't fire when the player isn't in the chopper
	
	//player TakeAllWeapons();
	player thread take_and_giveback_weapons("playable_hind_climbout");
	player PlayerLinkToAbsolute(player_body, "tag_player");
	
	player_body Show();
		
	self waittill( "playable_hind_climbout" );
	player notify( "playable_hind_climbout" );
	
	player Unlink();
	player_body Delete();
	
	//-- TODO: hack to keep you from falling out of the world
	trace_start = player.origin + (0,0,200);
	trace_end = player.origin + (0,0,-100);
	player_trace = BulletTrace(trace_start, trace_end, false, self);

	player SetOrigin(player_trace["position"]);
}

init_player_anims()
{
	assert( IsDefined(level.player_interactive_model), "The playable hind requires that you set a player_interactive_model in _loadout.gsc");
		
	level.scr_animtree["hind_body"] 	= #animtree;
	level.scr_model["hind_body"] 		= level.player_interactive_model;
	//level.scr_anim["hind_body"]["playable_hind_climbin"]	= %int_pow_b03_cockpit_climbin; //-- removed for a scripted sequence of the entire takeoff
	level.scr_anim["hind_body"]["playable_hind_climbin"] = %int_pow_b03_cockpit_inandup;
	maps\_anim::addNotetrack_customFunction( "hind_body", "swap", ::swap_for_interior, "playable_hind_climbin" );
	
	level.scr_anim["hind_body"]["playable_hind_climbout"] = %int_pow_b03_cockpit_exit;
	maps\_anim::addNotetrack_customFunction( "hind_body", "swap", ::swap_for_exterior, "playable_hind_climbout" );
}

#using_animtree("vehicles");

init_vehicle_anims()
{
	level.scr_anim["hind"]["climbout_exterior"] = %v_pow_b03_hind_exit_exterior;
	level.scr_anim["hind"]["climbout_interior"] = %v_pow_b03_hind_exit_interior;
	level.scr_anim["hind"]["climbin_exterior"] = %v_pow_b03_hind_climbin_exterior;
	level.scr_anim["hind"]["climbin_interior"] = %v_pow_b03_hind_climbin_interior;
	level.scr_anim["hind"]["landed"] = %v_pow_b03_hind_landed;
}

exterior_window_anim() //-- self = hind
{
	self ClearAnim(level.scr_anim["hind"]["landed"], 0);
	self SetAnim(level.scr_anim["hind"]["climbin_exterior"], 1);
	self waittill("switch_climbin_anim");
	self interior_window_anim();
}

interior_window_anim() //-- self = hind
{
	self ClearAnim(level.scr_anim["hind"]["climbin_exterior"], .15);
	self SetAnim(level.scr_anim["hind"]["climbin_interior"], 1);
	self waittill("player_entered");
	//self ClearAnim(level.scr_anim["hind"]["climbin_interior"], .15);
}

interior_window_anim_exit() //-- self = hind
{
	self ClearAnim(level.scr_anim["hind"]["landed"], 0);
	//self ClearAnim(level.scr_anim["hind"]["climbout_exterior"], .15);
	//self SetAnim( level.scr_anim["hind"]["climbout_interior"], 1);
	self AnimScripted("hind_exit_anim", self.origin, self.angles, level.scr_anim["hind"]["climbout_interior"]);
	self waittill("playable_hind_climbout");
	self exterior_window_anim_exit();
	//self ClearAnim(level.scr_anim["hind"]["climbin_interior"], .15);
}

exterior_window_anim_exit() //-- self = hind
{
	//self ClearAnim(level.scr_anim["hind"]["climbout_interior"], .15);
	//self SetAnim(level.scr_anim["hind"]["climbout_exterior"], 1);
	self AnimScripted("hind_exit_anim", self.origin, self.angles, level.scr_anim["hind"]["climbout_exterior"]);
}

landed_animation() //-- self = hind
{
	self SetAnim(level.scr_anim["hind"]["landed"], 1);
}
