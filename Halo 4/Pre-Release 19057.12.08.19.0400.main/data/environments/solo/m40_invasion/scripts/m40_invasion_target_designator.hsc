

//The new functions are
//     weapon_get_rounds_total   <weapon> <magazine_index> ; use zero for magazine. returns integer ammo count
//     weapon_set_current_amount <weapon> <percent>        ; percent is [0.0 .. 1.0] 
//
//This will fully exhaust ammo weapons / deplete power weapons:
//     weapon_set_current_amount <weapon> 0
//
//This will give max ammo / fully power:
//     weapon_set_current_amount <weapon> 1
//
//For the m40 target laser
//                weapon_get_rounds_total
//will now return zero or one which I think give you a clear idea of when it has been fired.  
//  m40_target_laser_show_prompt_ui(show)            // 0/1, true/false --> hide/show the UI
//  player_requested_m40_target_laser()              // returns true/false
//
//  weapon_get_lockon_state(weapon)                  // returns 0:idle, 1:aquiring, 2:locked on
//  weapon_get_lockon_target(weapon)                 // returns object instance or none
//  weapon_get_age(weapon)                           // returns age of power weapon (0==fully charged, 1==depleted)
//
//  unit_add_weapon(unit, weaponObject, addMethod) 
//    // addMethod: -1:unknown, 0:normal, 1:silent, 2:as_only, 3:as_primary, 
//    //   4:swap_for_primary, 5:as_secondary, 6:swap_for_secondary, 7:as_secondary_silently
//
//  unit_drop_weapon(unit, weaponObject, dropType)
//    // dropType: 0:default, 1:delete, 2:dual_primary, 3:dual_secondary, 4:response_to_deletion, 5:throw



//var displaying_ui    = false
//var laserWeapon      = NONE
//var gunnerUnit       = NONE 
//var gunnerActor      = NONE        ; AI actor
//var gunnerWeapon     = NONE        ; mammoth rail gun
//var player           = NONE        ; who will be given target laser
//var cooled_down      = false       ; based on whatever script conditions are desired
//       
//initialize player var
//Create & place mammoth AI actor gunner, initialize vars
//Initialize cooldown logic/timer vars
//
//while (in railgun segment)
//  cooled_down = do_cooldown_logic()
//
//  if cooled_down 
//     if laserWeapon != NONE // player has been given weapon?
//
//        if object_get_parent(laserWeapon) == NONE                    // Yes. Has he switched away from it ?
//            object_destroy(laserWeapon)                              // Yes. It will be dropped so delete it 
//            laserWeapon = NONE                                       // and forget about it
//       else
//            paintedLockonState  = weapon_get_lockon_state(laserWeapon)
//            paintedLockonTarget = weapon_get_lockon_target(laserWeapon)
//
//            if paintedLockonState==0
//                cs_coolout_ai_dude(gunnerUnit)                       // nothing targeted so chill
//            else
//                cs_aim/cs_shoot                                      // encourage gunner actor to shoot painted target 
//
//            if weapon_get_age(gunnerWeapon) >= 1.0                   // has the railgun been fired?
//               reset_cooldown_logic()
//                unit_drop_weapon(player_get(player), laserWeapon, 1) // force laser to be dropped & deleted; dropType 1 --> delete
//                laserWeapon = NONE                                   // and forget about it
//
//            else // there's no laser weapon...
//                if !displaying_ui                                    // need to prompt?
//                    m40_target_laser_show_prompt_ui(player, 1)       // yes, bring up UI
//                    displaying_ui = true              
//
//                if m40_target_laser_was_requested(player)               // Did player press on dpad?
//                    laserWeapon = object_create(weapon_tag)             // create a target laser
//                    unit_add_weapon(player_get(player), laserWeapon, 0) // give it to the player; method 0 --> normal
//                    m40_target_laser_show_prompt_ui(0)                  // bring down UI (UI may end up doing this itself automagically)
//                    displaying_ui = false                               //  or internally to m40_target_laser_was_requested()
//                    unit_force_reload(gunnerUnit)                       // reset mammoth weapon's age




//•	Target Locator can lock onto and shoot Forerunner AA cannons from within a certain trigger volume 
//o	If outside of that volume, we need to return failure VO (“AA cannon out of range”)
//•	Need to return VO if player “locks on” to anything other than phantoms and AA gun, like environment or vehicles (“no target, chief”)
//o	Would be ideal if we could tell the difference between environment and any ground vehicles or infantry (“no target” vs. “too low! rail gun can’t hit ground targets, chief”)
//o	Need to return VO for successful lock
//o	Need to return VO if Rail Gun cannot see target at time of lockon (object_can_see_object?) (“can’t see that target, chief”)
//o	Need to return VO for successful lock onto AA cannons

//•	Need a way to manually end the cooldown ourselves in script for special cases - DONE
//•	Target Locator needs cooldown that can be easily adjusted - DONE
//•	Need to return VO if player tries to access target locator before cooldown has expired - DONE
//•	Need to disable access to target locator completely, and return VO if player tries to access it (“rail gun is damaged!”) - DONE
//•	Target locator needs to auto-stow after rail gun successfully shoots a target - DONE
//o	Need to retun VO for successful enemy death - DONE
//o	Need to return VO if target doesn’t die (if rail gun missed bc target flew behind rock or something) - DONE
//I think that’s it… I’ll email you back if I think of anything. Or let me know if you’re putting it together and think that there’s some stuff I forgot.
//




// bugs:
// 	- cs_shoot doesn't work so I have to use braindead on phantoms, also this means it wont work on distant guns
// 	- unless I do a sleep after the miss function, it gets called twice and charges twice

// bools to see when the td is ready for use or not
global boolean	td_ready_for_mission_use				= FALSE;		// used as a check for the first time it gets used
global boolean 	target_designator_is_ready 			= FALSE;		// is the td ready to use during regular use?
global boolean 	td_force_stow										= FALSE;		// should the td be stowed after firing?
global boolean	td_is_out												= FALSE;		// check for if the td is already out in the player's hands
global boolean	td_force_cool_down							= FALSE;		// force a cool down to happen immediately
global boolean	td_disabled 										= FALSE;		// when the td gets disabled at chopper bowl
// input vars
global boolean 	td_pulled_out_input 						= FALSE;		// did the player press dpad
global boolean 	td_switched_weapons_input 			= FALSE;		// did the player press y?
global boolean	td_tried_to_fire_input					= FALSE;		// did the player press trigger?
global boolean 	td_trigger_down_time_met 				= FALSE;		// did teh player hold the trigger down for long enough?
global long 		td_trigger_down_time 						= 0;				// check to see how long the player has had the trigger down for
global long 		td_trigger_down_time_max 				= 14;				// the const for how long the trigger neesd to be down for

// ammo, timer and locked object settings
global short 		td_current_ammo									= 0;				// the current ammo of the td, either 0 or 1
global short 		td_max_ammo											= 1;				// should always be 1
global real			td_time_to_charge_rail_gun			= 30;				// change this to make the time between shots more / less
global real			td_current_time									= -1;				// current game tick set when the charge of the rail gun begins
global object 	td_locked_on_target_previous		= NONE;			// the object the td is locked onto, the real thing
global object 	td_locked_on_target_current			= NONE;			// the object the td is locked onto, hack, gets reset the next frame

// vo bools
global boolean 	td_vo_is_playing								= FALSE;		// is vo playing?
global boolean 	td_is_firing										= FALSE;		// is the rail gun firing?
global boolean 	td_fired												= FALSE;		// has the rail gun fired?
global boolean 	td_couldnt_see_target						= FALSE;		// has the rail gun started to fire but couldnt see its target
global boolean 	td_aiming_timeout								= FALSE;		// has the rail gun taken too long to aim at its target?

// the player
global player 	td_user 												= player0;	// the user of this thing.

//global boolean td_disabled = false;

// call this when you want to start the td script up
script static void m40_target_designator_main()
	print ("m40 td");

	sleep_until(player_count() > 0, 1);
	
//	td_user	= player_get_first_valid();
	
	// place and load in the firing AI, probably needs to be broken out more in m40
	ai_place (bt_sq);
	ai_player_add_fireteam_squad (td_user, bt_sq);
	ai_vehicle_enter_immediate (bt_sq, main_mammoth, "mac_d");

	cs_run_command_script (bt_sq.guy2, mammoth_gunner_think);
	cs_run_command_script (bt_sq.guy3, mammoth_gunner_think);

	
	// all the rail gun and td threads start thinking here
	thread (target_designator_think());
	thread (target_designator_dpad_input_watch());
	thread (target_designator_give_think());
	thread (target_designator_swap_away_think());
	thread (target_designator_force_stow_think());
	
	// a loop that goes forever and tries to give ammo to the target designator
	thread (target_designator_give_ammo_fail_safe());
	
	// tracks the state of the thing you're targeting
	thread (target_designator_track_target());
					
	thread (target_designator_check_trigger_down_time());
	// unlocks the td initially, may want to lock it instead in m40
	//sleep_s(5);
	//target_designator_charge(true);
end

// main firing loop for the mammoth
script static void target_designator_think()
	repeat	
	
		repeat		
			if (not target_designator_is_ready) and object_valid(m40_lakeside_target_laser) and player_count() > 0 then
				repeat
					// this doesn't work, and needs to in order to check for VO calls when you try to fire but the TD isn't ready / charged yet
					if (unit_has_weapon_readied (td_user, "objects\weapons\pistol\storm_target_laser\storm_target_laser_m40.weapon")) then
						if (td_tried_to_fire_input) then
							thread (target_designator_vo_callouts("not ready"));
						end
					end
				until (target_designator_is_ready, 1);		
			elseif object_valid(m40_lakeside_target_laser) and player_count() > 0 then
				// we can fire now
				if (weapon_get_lockon_state(m40_lakeside_target_laser) == 0) then 
					if (weapon_get_rounds_total (m40_lakeside_target_laser, 0) == 0) then	
						thread (target_designator_charge(false, true));
						thread (target_designator_vo_callouts("not a target"));
						// hack, not sleeping here makes this function get called twice because threading anything eats a tick
						sleep (2);
					end
				elseif (weapon_get_lockon_state(m40_lakeside_target_laser) == 1) then
					print ("TD AQUIRING");
				elseif (weapon_get_lockon_state(m40_lakeside_target_laser) == 2) then
	//				repeat
						print ("TD LOCKED ON");
						//inspect(td_locked_on_target);
//					until (td_tried_to_fire_input and (weapon_get_lockon_state(m40_lakeside_target_laser) != 2 or weapon_get_rounds_total (m40_lakeside_target_laser, 0) == 0), 1);
						td_locked_on_target_current = weapon_get_lockon_target(m40_lakeside_target_laser, true, false);	
						//inspect(td_tried_to_fire_input);
						//inspect(weapon_get_rounds_total (m40_lakeside_target_laser, 0));
					if (weapon_get_rounds_total (m40_lakeside_target_laser, 0) == 0 and td_trigger_down_time_met) then
						thread (target_designator_vo_callouts("firing"));
						td_is_firing = TRUE;
						td_trigger_down_time_met = FALSE;
						thread (target_designator_charge(false, false));
						//sleep_s(3);
					end
				end
			end
			//td_locked_on_target_current = weapon_get_lockon_target(m40_lakeside_target_laser, true, false);					
		until (target_designator_disabled == true, 1);
	sleep_until (target_designator_disabled == false);
	until(1 == 0, 1);			
end

script static void target_designator_track_target()
	// wait until rail gun has fired
	repeat
		if (object_valid(m40_lakeside_target_laser) and player_count() > 0) then
			//if (weapon_get_lockon_state(m40_lakeside_target_laser) == 2) then
				td_locked_on_target_previous = td_locked_on_target_current;
				//print ("TD TRACKING - td_locked_on_target_previous = td_locked_on_target_current");
				//td_locked_on_target_current = weapon_get_lockon_target(m40_lakeside_target_laser, true, false);
			//end
		end
		
		if (td_is_firing) then
			// wait until rail gun HAS fired, fake with a sleep for now
			sleep_until(td_fired or td_couldnt_see_target, 1);
			sleep (5);
			print ("TD TRACKING - td_fired in target_designator_track_target");
			if (object_get_health (td_locked_on_target_previous) <= .2 and td_fired) then
				target_designator_vo_callouts("hit");
			elseif (object_get_health (td_locked_on_target_previous) > .2 and td_fired) then
				target_designator_vo_callouts("missed");
			else
				target_designator_vo_callouts("not a target");
			end
			
			td_fired = FALSE;
			td_couldnt_see_target = FALSE;
		end
	until(1 == 0, 1);			

end

//script static void test_see()
//	sleep_until (objects_can_see_object (unit(bt_sq), cannon_lakeside, 1));
//	print ("I CAN SEE IT");
//end

// Logic to make the gunner think about shooting at his targets
script command_script mammoth_gunner_think()
	print ("Mammoth Gunner Alive!");
		
	repeat
		if (not td_is_firing) then
			cs_shoot (0);
			cs_aim (1, mtest2.p23);
			//dprint ("not shooting, aiming at default point");
		else
			cs_aim_object(1,td_locked_on_target_previous);
//			thread (td_aiming_timeout_sc());
			sleep_until (objects_can_see_object (ai_current_actor, td_locked_on_target_previous, 30) or td_aiming_timeout == true);			
			//dprint ("aiming at locked on (previous) target");
			//if (objects_can_see_object (ai_current_actor, td_locked_on_target_previous, 30)) then
			
			//	print ("TD TRACKING - CAN SEE TARGET");
//				sleep_s(3);
				//dprint ("still can see target");
			if (objects_can_see_object (ai_current_actor, td_locked_on_target_previous, 30)) then
				sleep_s(2);
				cs_shoot (1);		
				print ("TD TRACKING - ORDERED TO CS SHOOT");		
				sleep_s(1);
				print ("FIRED AT THING!");
			else
				print ("Couldn't see target!");
				thread (target_designator_unlock());
				td_couldnt_see_target = TRUE;
			end
			
			td_fired = TRUE;		
			//else
//				sleep_s(3);
			//end
			td_aiming_timeout = false;
		end	
	until (1 == 0, 1);
	
	//cs_aim (bt_sq, 1, ps_mammoth_points.default);
	//cs_shoot (false);
end

script static void td_aiming_timeout_sc()
	sleep_s(3.75);
	td_aiming_timeout = true;
end

// watches the input of the controller and sets some vars that other scripts look for
script static void target_designator_dpad_input_watch()
	repeat
		// reset these at the top of the loop
		td_pulled_out_input = false;
		td_switched_weapons_input = false;
		td_tried_to_fire_input = false;
			
		// this call allowes input to be checked every frame
		unit_action_test_reset(td_user);
		
		// check against various inputs and set global vars that other functions look at
		
		// pull the weapon out
		if (unit_action_test_dpad_up(td_user)) then
			td_pulled_out_input = true;
		end
		
		// swap weapons
		if (unit_action_test_primary_trigger(td_user)) then
			td_switched_weapons_input = true;
		end
		
		// pull trigger
		if (unit_action_test_primary_trigger(td_user)) then
			td_tried_to_fire_input = true;
		end

	until (td_disabled == true, 1);
end


script static void target_designator_check_trigger_down_time()
	repeat
		if (unit_has_weapon_readied (td_user, "objects\weapons\pistol\storm_target_laser\storm_target_laser_m40.weapon") and td_tried_to_fire_input and weapon_get_rounds_total (m40_lakeside_target_laser, 0) > 0) then
			td_trigger_down_time = td_trigger_down_time + 1;
		else
			td_trigger_down_time = 0;
		end
		
		if (td_trigger_down_time > td_trigger_down_time_max) then
			td_trigger_down_time_met = true;
		end
		
		//inspect(td_trigger_down_time);
	until (td_disabled == true, 1);
end

// main loop for what state the designator needs to be in when the player pulls it up
script static void target_designator_give_think()
	repeat
  	if (td_pulled_out_input) and (not td_is_out) then
			
			// make the laser exist
			object_create_anew(m40_lakeside_target_laser);
			
			if object_valid(m40_lakeside_target_laser) and player_count() > 0 then
				target_designator_give_ammo();
				
				// give the weapon
				unit_add_weapon(td_user, m40_lakeside_target_laser, 0);
				td_is_out	= TRUE;
				print ("gave td");
								
				// give ammo if it's actually ready, take it away if its not
				if (target_designator_is_ready) then	
					target_designator_give_ammo();
				else
					target_designator_deplete_ammo();
				end
				sleep (30);
			end
		end
	until (td_disabled == true, 1);
end

// if the player swaps away, this handles what happens to the TD
script static void target_designator_swap_away_think()
	repeat
		if (object_valid(m40_lakeside_target_laser) and player_count() > 0) then
			if (td_switched_weapons_input or object_get_parent(m40_lakeside_target_laser) == NONE) then      // swapped to another weapon OR object_get_parent(m40_lakeside_target_laser)==NONE) then    // or it was dropped
				object_destroy(m40_lakeside_target_laser);
					td_is_out = FALSE;
					if td_switched_weapons_input then
						print ("switched away from TD");
					else
						print ("dropped TD!");
					end
				sleep (30);
			end
		else
			td_is_out = FALSE;
//			print ("TD invalid/no players");                
			sleep (30);
		end
	until (td_disabled == true, 1);
end


// after the player fires we need the "stow" to be forced
script static void target_designator_force_stow_think()
	repeat
		if (td_force_stow) then			// fired the weapon, ammo = 0
			if (object_valid(m40_lakeside_target_laser) and player_count() > 0) then
				unit_drop_weapon(td_user, m40_lakeside_target_laser, 1);
				td_is_out = FALSE;
				print ("fired TD");
				sleep (30);
			end
		end
	until (td_disabled == true, 1);
end

// the main "charge" loop, this gets called once the rail gun is fired or is started for the first time
script static void target_designator_charge(boolean first_charge, boolean fast_charge)
	
	print ("TD Charging!");
//	td_ready_for_mission_use = TRUE;
	
	td_current_time = game_tick_get();
	
	// to thread or not to thread?
	if (not first_charge and td_locked_on_target_previous != NONE) then
		thread (target_designator_force_stow());
		print ("TD TRACKING - target_designator_force_stow, will STOW");
	end
		
	thread (mammoth_gunner_clear_target());
	target_designator_deplete_ammo();
	target_designator_lock();
	
	if (not fast_charge) then
		weapon_set_target_designator_cooldown_timer (td_time_to_charge_rail_gun);
		sleep_s (td_time_to_charge_rail_gun);
	end
	
	target_designator_unlock();
	target_designator_give_ammo();		// this is currently set on the fail safe, leaving out for now
	print ("TD Ready to Fire!");
	
	if (first_time_charged == FALSE and rail_gun_prompt_bool == FALSE) then
 		thread (f_dialog_m40_rail_gun_ready());
	end
end

// VO queue for this gun so that dialogue doesn't play on top of each other, etc.

//f_dialog_m40_target_missed - Target acquired!
//f_dialog_m40_no_line_of_sight - No line of sight on target!
//f_dialog_m40_target_destroyed - Target destroyed!
//f_dialog_m40_rail_gun_reloading - Rail gun reloading!
//f_dialog_m40_rail_gun_ready - Rail gun available!
//f_dialog_40_good_job - Good job, Chief.

script static void target_designator_vo_callouts(string call_out)
	
	if td_disabled == FALSE
	
	then
	
		if (not td_vo_is_playing or call_out == "firing" or call_out == "hit" or call_out == "missed") then
			local sound the_vo = NONE;
			local string the_vo_string = NONE;
	
			td_vo_is_playing = TRUE;
			
			if (call_out == "not ready") then
				the_vo_string = "Not Ready!";
				
			elseif (call_out == "missed") then
				the_vo_string = "Missed!";
				thread (b_target_missed_sc());
							
			elseif (call_out == "firing") then
				the_vo_string = "Firing!";	
				thread (b_target_acquired_sc());
							
			elseif (call_out == "hit") then
				the_vo_string = "Hit!";	
				//thread (b_target_destroyed_sc());	
				thread (b_rail_gun_reloading_sc());	
				
			elseif (call_out == "not a target") then
				the_vo_string = "Not a target!";	
				thread (b_no_line_of_sight_sc());
				
			end
			
			if (td_is_firing) then	
				print ("Killing all VO to play firing line");
			end
			
			// stop all VO here that would be playing for firing
			print (the_vo_string);		// play the VO here instead
			sleep_s (1);							// wait the longest VO line length plus some change
			
			// reset this
			td_vo_is_playing = FALSE;
			td_is_firing = FALSE;
		end	
	
	end
	
end


script static void b_rail_gun_available_sc()
	b_rail_gun_available = true;
	sleep_s (1);
	b_rail_gun_available = false;	
end

script static void b_rail_gun_ready_sc()
	b_rail_gun_ready = true;
	sleep_s (1);
	b_rail_gun_ready = false;	
end

script static void b_rail_gun_reloading_sc()
	sleep_s (3);	
	if chopper_cannon_alive == TRUE
	then
		b_rail_gun_reloading = true;
		sleep_s (1);
		b_rail_gun_reloading = false;	
	else
	print ("rail gun reloading not playing");
	end
end

script static void b_target_destroyed_sc()
	b_target_destroyed = true;
	sleep_s (1);
	b_target_destroyed = false;	
end

script static void b_no_line_of_sight_sc()
	b_no_line_of_sight = true;
	sleep_s (1);
	b_no_line_of_sight = false;	
end

script static void b_target_acquired_sc()
	b_target_acquired = true;
	sleep_s (1);
	b_target_acquired = false;	
end

script static void b_target_missed_sc()
	b_target_missed = true;
	sleep_s (1);
	b_target_missed = false;	
end


// support functions and re-scripting of code calls to be more designer readable
script static void target_designator_lock()
	target_designator_is_ready = FALSE;
end

script static void target_designator_unlock()
	target_designator_is_ready = TRUE;
	weapon_force_end_target_designator_cooldown_timer();
end

script static void target_designator_give_ammo()
	if (object_valid(m40_lakeside_target_laser) and player_count() > 0) then
		weapon_set_current_amount (m40_lakeside_target_laser, 1);
	end
end

script static void target_designator_deplete_ammo()
	if (object_valid(m40_lakeside_target_laser) and player_count() > 0) then
		weapon_set_current_amount (m40_lakeside_target_laser, 0);
		print ("depleted TD Ammo");
	end
end

script static void mammoth_gunner_braindead(boolean b_braindead)
	ai_braindead (bt_sq, b_braindead);
end

script static void mammoth_gunner_clear_target()
	sleep_s(4);
	print ("clearing target!");
	td_locked_on_target_previous = NONE;
	td_locked_on_target_current = NONE;
	td_aiming_timeout = true;	
end

script static void target_designator_force_stow()
	td_force_stow = TRUE;
	print ("td_force_stow = TRUE");
	sleep (2);
	td_force_stow = FALSE;
	print ("td_force_stow = FALSE");
end

// check current time against last time it was fired vs. max time
script static void target_designator_give_ammo_fail_safe()
	repeat
		if (object_valid(m40_lakeside_target_laser) and player_count() > 0) and td_ready_for_mission_use then
			if (((game_tick_get() / 30) - (td_current_time / 30)) >= td_time_to_charge_rail_gun) or td_force_cool_down then
				target_designator_give_ammo();
				td_force_cool_down = FALSE;
			end
		end
	until (1 == 0, 1);
end

// forces immediate cool down
script static void target_designator_force_immediate_cooldown()
	td_force_cool_down = true;
	weapon_force_end_target_designator_cooldown_timer();
end

