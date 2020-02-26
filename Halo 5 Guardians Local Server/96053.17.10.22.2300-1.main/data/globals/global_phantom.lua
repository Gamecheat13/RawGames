--## SERVER

-- =================================================================================================
-- GLOBAL_PHANTOM.LUA
-- HOW TO USE:
-- 	1. Open your scenario in Sapien
--	2. In the menu bar, open the "Scenarios" menu, then select "Add Mission Script"
--	3. Point the dialogue to this file: main\data\globals\global_phantom.lua
-- =================================================================================================


-- === Spawns AI (optional), flies phantom through the point sets until it gets to one named "drop" ===
-- === loads a squad into a phantom, flies phantom through the rest of the point sets, destroys the phantom ===
--			ship squad = the phantom to load -- use ai_current_squad for a command script
--			squad = the AI (group, squad or actor) you want spawned and loaded into the phantom
--			ps = the point set the phantom will fly
--			drop = the point the phantom will drop the AI
--			b_spawn_squad = if TRUE then the squad is spawned
--			b_spawn_ship = if TRUE then drop ship is spawned
--			side = the side the enemies will spawn into and drop out of
--	RETURNS:  void
function f_dropship (ship_squad:ai, squad:ai, ps:point_set, drop:point, b_spawn_squad:boolean, b_spawn_ship:boolean, side:string ):void
	print ("start dropship function");
	sys_dropship (ship_squad, squad, ps, drop, b_spawn_squad, b_spawn_ship, side, false);
	
end

function f_dropship_vehicle (ship_squad:ai, squad:ai, ps:point_set, drop:point, b_spawn_squad:boolean, b_spawn_ship:boolean, side:string ):void
	print ("start dropship function");
	sys_dropship (ship_squad, squad, ps, drop, b_spawn_squad, b_spawn_ship, side, true);
	
end


--====DO NOT USE -- FOR global functionality only
function sys_dropship (ship_squad:ai, squad:ai, ps:point_set, drop:point, b_spawn_squad:boolean, b_spawn_ship:boolean, side:string, veh:boolean ):void
	--print ("dropship");
	
	if ship_squad == nil then
		print ("no dropship squad in function");
	end
	
	if b_spawn_ship and ai_living_count(ship_squad) > 0 then
		return print ("the drop ship is already spawned, ending the f_dropship script");
	end
	
	if squad == nil then
		print ("no specified squad to fill the drop ship");
	end
	
	if ps == nil then
		print ("no point set specified");
		error ("you tried to call f_dropship without specifying a point set");
	end
	
	side = side or "any";
	
	--load the drop ship	
	if veh then
		f_load_drop_ship_vehicle (ship_squad, squad, b_spawn_squad, b_spawn_ship);
	else
		f_load_drop_ship (ship_squad, squad, b_spawn_squad, b_spawn_ship, side);
	end
	
	f_drop_ship_fly_to (ship_squad, ps, drop, side, veh);

	object_set_scale(ai_vehicle_get_from_squad(ship_squad), 0.01, seconds_to_frames(3));
	sleep_s (3);
	ai_erase(ship_squad);

	print ("destroying dropship");
	--object_destroy (ai_vehicle_get_from_squad (ship_squad));

end





-- === flies phantom through point sets, optionally unloads ===
--			ship squad = the phantom to load -- use ai_current_squad for a command script
--			ps = the point set the phantom will fly
--			drop = the point the phantom will drop the AI
--			side = the side the enemies will spawn into and drop out of
--			veh = if the sqaud is a vehicle
--	RETURNS:  void
function f_drop_ship_fly_to (ship_squad:ai, ps:point_set, drop:point, side:string, veh:boolean)
	if ship_squad == nil then
		print ("no dropship squad in function");
	end
	
	if ps == nil then
		print ("no point set specified");
		error ("you tried to call f_dropship without specifying a point set");
	end
	
	local driver:ai = ai_vehicle_get_driver(ai_vehicle_get_from_squad (ship_squad));
	
	for i = 1, #ps do
		print ("flying to", ps[i]);
		--print (ai_current_actor);
	
		--if ai_current_actor ~= g_null_actor then
		--	cs_fly_to (driver, true, ps[i]);
		--else
		cs_fly_to (driver, true, ps[i]);
		--end
		if ps[i] == drop then
			print ("unloading");
			sleep_s(0.3);
			--vehicle_hover (ai_vehicle_get_from_squad(ship_squad) , true);
	--======== DROP PASSENGERS HERE ======================
			if veh then
				f_unload_drop_ship_vehicle( ship_squad);
			else
				f_unload_drop_ship( ship_squad, side);
			end
			--sleep_s(2);
			--vehicle_hover (ai_vehicle_get_from_squad(ship_squad) , false);
		end
	end
end

--function f_test():void
--	print ("testing dropships");
--	--f_dropship (AI.squads_3, AI.sq_hot_zone_1, POINTS.ps_1, POINTS.ps_1.drop , true, true);
--	f_dropship_vehicle (AI.squads_3, AI.sq_veh, POINTS.ps_1, POINTS.ps_1.drop , true, true);
--end

-- === Spawns AI (optional) and loads them into a phantom.  Can be used in a command script
--			ship squad = the phantom to load -- use ai_current_squad this for a command script
--			squad = the AI (group, squad or actor) you want spawned and loaded into the phantom
--			b_spawn_squad = if TRUE then the squad is spawned
--			b_spawn_ship = if TRUE then drop ship is spawned
--			side = the side to load the occupants
--	RETURNS:  void

function f_load_drop_ship( ship_squad:ai, squad:ai, b_spawn_squad:boolean, b_spawn_ship:boolean, side:string ):void
	print("load phantom ...");
	
	if ship_squad == nil then
		print ("no dropship squad in function");
		return
	end
	
	
	
	if squad == nil then
		print ("no specified squad to fill the drop ship");
	end
	
	side = side or "any";
--	if b_spawn_squad == nil then
--		b_spawn_squad = false;
--	end
--	
--	if b_spawn_ship == nil then
--		b_spawn_ship = false;
--	end
	
	--if b_spawn_ship is true, then spawn the ship and scale it
	if b_spawn_ship then
		ai_place (ship_squad);
		local dropship:object = ai_vehicle_get_from_squad (ship_squad);
		object_set_scale(dropship, 0.01, 1);
		--object_set_scale (ai_vehicle_get_from_squad (ship_squad), 0.01, 1);
		print ("scaling");
		object_cannot_die(dropship, true);
		sleep_s(1);
		object_set_scale(dropship, 1.0, seconds_to_frames (3));
--		--object_set_scale(ai_vehicle_get_from_squad (ship_squad), 1.0, (3 * n_fps));
		object_cannot_die(dropship, false);
		Sleep(1);
		
	end
	
	if b_spawn_squad then
		ai_place (squad);
		--print ("squad to place in dropship placed");
	end
	
	--place the enemies into the phantom
	if ai_living_count (squad) <= 0 or ai_living_count (ship_squad) <= 0 then
		if ai_living_count (squad) <= 0 then
			print ("no living AI to place in drop ship");
		end
		if ai_living_count (ship_squad) <= 0 then
			print ("no living drop ship");
		end
	else	
		if side == "left" then
			f_load_drop_ship_left (ship_squad, squad);
		elseif side == "right" then
			f_load_drop_ship_right (ship_squad, squad);
		elseif side == "any" then
			f_load_drop_ship_any (ship_squad, squad);
		end
	--	print ("loaded drop ship");
	--	print ("# of ai in the vehicle is", ai_living_count (ship_squad));
	--	print ("# of ai remaining is", ai_living_count (squad));
	end
end

--load the phantom only on the right side
function f_load_drop_ship_right (ship_squad:ai, squad:ai)
	local dropship:object = ai_vehicle_get_from_squad (ship_squad);
	local driver:ai = ai_vehicle_get_driver(ai_vehicle_get_from_squad (ship_squad));
	
	--if the vehicle is a spirit then load this way
	if unit_in_vehicle_type (driver, 34) then
		vehicle_load_magic (dropship, "spirit_p_right", squad);
	--if the vehicle isn't a spirit (it's a phantom) then
	else
		vehicle_load_magic (dropship, "phantom_p_r", squad);
	end
end


--load the phantom only on the left side
function f_load_drop_ship_left (ship_squad:ai, squad:ai)
	local dropship:object = ai_vehicle_get_from_squad (ship_squad);
	local driver:ai = ai_vehicle_get_driver(ai_vehicle_get_from_squad (ship_squad));
	
	--if the vehicle is a spirit then load this way
	if unit_in_vehicle_type (driver, 34) then
		vehicle_load_magic (dropship, "spirit_p_left", squad);
	--if the vehicle isn't a spirit (it's a phantom) then
	else
		vehicle_load_magic (dropship, "phantom_p_l", squad);
	end
end


--load the phantom only on both sides
function f_load_drop_ship_any (ship_squad:ai, squad:ai)
	print ("load drop ship any");
	local dropship:object = ai_vehicle_get_from_squad (ship_squad);
	local driver:ai = ai_vehicle_get_driver(ai_vehicle_get_from_squad (ship_squad));
	--if the vehicle is a spirit then load this way
	if unit_in_vehicle_type (driver, 34) then
		vehicle_load_magic (dropship, "spirit_p_", squad);
	--if the vehicle isn't a spirit (it's a phantom) then
	else
		vehicle_load_magic (dropship, "phantom_p_", squad);
	end
end
	

--call this script when the drop ship is in place to drop off all the ai ====================================================================
-- === Unloads a drop ship.  Usually used in a command script
--			ship squad = the drop ship squad to unload -- use script like this for a command script...
--			drop_side = the side of the phantom you want to unload
--
--== UNLOAD PARAMETERS ==
--- left 
--- right 
--- dual 
--- any
--- chute 
--
--	RETURNS:  void

function f_unload_drop_ship( ship_squad:ai, dropside:string ):void
	print("unload dropship");
		
	dropside = dropside or "any";
		
	local dropship:object = ai_vehicle_get_from_squad (ship_squad);
	local driver:ai = ai_vehicle_get_driver(ai_vehicle_get_from_squad (ship_squad));
	
--	unit_open(dropship);
--	sleep_s (2);
	
	--if the vehicle is a spirit then unload this way
	if unit_in_vehicle_type (driver, 34) then
		print ("unloading spirit");
		f_unload_spirit(dropship, dropside);
	else
	--if the vehicle is a phantom then unload this way
	-- determine how to unload the phantom 
	--run f_unload_phantom
		f_unload_phantom(dropship, dropside);
	end
end
--		if drop_side == "left" then
--			f_unload_ph_left(phantom);
--			sleep_s (0.5);
--			f_unload_ph_mid_left(phantom);
--			sleep_s (1.5);
--		end
--		if drop_side == "right" then
--			f_unload_ph_right(phantom);
--			sleep_s (0.5);
--			f_unload_ph_mid_right(phantom);
--			sleep_s (1.5);
--		end
--		if drop_side == "dual" then
--		
--			sleep_s (0.5);
--			f_unload_ph_left(phantom);
--			f_unload_ph_right(phantom);
--			sleep_s (0.5);
--			f_unload_ph_mid_left(phantom);
--			f_unload_ph_mid_right(phantom);
--			
--			sleep_s (1.5);
--		end
--		
--		if drop_side == "any" then
--			
--			sleep_s (1);
--	--		vehicle_unload (phantom, "");
--			f_unload_ph_left(phantom);
--			f_unload_ph_right(phantom);
--			sleep_s (1);
--			f_unload_ph_mid_left(phantom);
--			f_unload_ph_mid_right(phantom);
--			vehicle_unload(phantom, "phantom_p");
--			sleep_s (3);
--		end
--		if drop_side == "chute" then
--			f_unload_ph_chute(phantom);
--			sleep_s (1.5);
--		end

--	unit_close(phantom);
--end


-- === Spawns AI and loads them into a phantom.  Usually used in a command script
--			drop ship = the phantom to load -- use script like this for a command script (ai_current_squad)
--			load_squad = the AI (group, squad or actor) that is in a vehicle you want spawned and loaded into the phantom
--			b_spawn_squad = if TRUE then the squad is spawned
--			b_spawn_ship = if TRUE then drop ship is spawned
--	RETURNS:  void

function f_load_drop_ship_vehicle (drop_ship:ai, load_squad:ai, b_spawn_squad:boolean, b_spawn_ship:boolean)
	print ("load a drop ship with vehicles");
	
	if drop_ship == nil then
		print ("no dropship squad in function");
	end
	
	if load_squad == nil then
		print ("no specified squad to fill the drop ship");
	end
	
	if b_spawn_squad == nil then
		b_spawn_squad = false;
	end
	
	if b_spawn_ship == nil then
		b_spawn_ship = false;
	end
	
	if b_spawn_ship then
		ai_place (drop_ship);
	end
	
	if b_spawn_squad then
		ai_place (load_squad);
	end
	
	local dropship:object = ai_vehicle_get_from_squad (drop_ship);
	local spirit:boolean = unit_in_vehicle_type (ai_vehicle_get_driver(dropship), 34);
		
	if ai_living_count (load_squad) <= 0 then
		print ("no living AI to place in drop ship");
	elseif ai_living_count (load_squad) == 1 then
		vehicle_load_magic(dropship, "phantom_lc", ai_vehicle_get_from_squad(load_squad, 0));
	elseif ai_living_count (load_squad) == 2 then
		if spirit then
			vehicle_load_magic(dropship, "phantom_lcb", ai_vehicle_get_from_squad(load_squad, 0));
			vehicle_load_magic(dropship, "phantom_lc", ai_vehicle_get_from_squad(load_squad, 1));
		else
			vehicle_load_magic(dropship, "phantom_sc01", ai_vehicle_get_from_squad(load_squad, 0));
			vehicle_load_magic(dropship, "phantom_sc02", ai_vehicle_get_from_squad(load_squad, 1));
		end
	elseif ai_living_count (load_squad) > 2 then
		print ("too many vehicles to load, not all loaded");
		if spirit then
			vehicle_load_magic(dropship, "phantom_lcb", ai_vehicle_get_from_squad(load_squad, 0));
			vehicle_load_magic(dropship, "phantom_lc", ai_vehicle_get_from_squad(load_squad, 1));
		else
			vehicle_load_magic(dropship, "phantom_sc01", ai_vehicle_get_from_squad(load_squad, 0));
			vehicle_load_magic(dropship, "phantom_sc02", ai_vehicle_get_from_squad(load_squad, 1));
		end
	end
	
	print ("loaded drop ship");
	print ("# of ai in the vehicle is", ai_living_count (ai_get_squad(ai_vehicle_get_driver(dropship))));
	print ("# of ai remaining is", ai_living_count (load_squad));
end


--[[
-- === Unloads a drop ship.  Usually used in a command script
--			drop ship = the dropship to unload -- use script like this for a command script... ai_current_squad
--			drop_num = which cargo seat to unload.  1, 2 or both (anything besides 1 or 2 will do both)
--	RETURNS:  void
]]
function f_unload_drop_ship_vehicle( drop_ship:ai, drop_num:number):void
	-- unload cargo seats 
	print ("unload drop ship vehicles");
	
	local dropship:object = ai_vehicle_get_from_squad (drop_ship);
	
	if drop_num == nil then
		drop_num = 0;
		--drop_num = vehicle_test_seat(dropship, "phantom_lc") + vehicle_test_seat(dropship, "phantom_sc01") + vehicle_test_seat(dropship, "phantom_sc02");
	end
	
	if drop_num == 1 then
		vehicle_unload(dropship, "phantom_lc");
		vehicle_unload(dropship, "phantom_sc01");
			print ("number 1");
	elseif drop_num == 2 then
		vehicle_unload(dropship, "phantom_sc02");
		vehicle_unload(dropship, "phantom_lcb");
		print ("number 2");
	else
	print ("number blah");
		vehicle_unload(dropship, "phantom_lc");
		vehicle_unload(dropship, "phantom_sc01");
		sleep_s (random_range(0.5, 1));
		vehicle_unload(dropship, "phantom_sc02");
		vehicle_unload(dropship, "phantom_lcb");
	end
end


-- =======================================================================================
-- ==============OLD SCRIPTS==============================================================
-- =======================================================================================


----
---- === Spawns AI and loads them into a phantom.  Usually used in a command script
----			phantom = the phantom to load -- use script like this for a command script... ai_vehicle_get(ai_current_actor)
----			load_side = the side of the phantom you want the AI to populate
----			load_squad = the AI (group, squad or actor) you want spawned and loaded into the phantom (up to 4)
----	RETURNS:  void
--
--== LOAD PARAMETERS ==
--- left 
--- right 
--- dual 
--- any
--- chute 
--

--THIS FUNCTION IS FOR ADVANCED PHANTOM SCRIPTING AND BACKWARDS COMPATIBILITY -- USE f_load_drop_ship FOR SIMPLE DROP SHIP LOADING
function f_load_phantom( phantom:object, load_side:string, load_squad_01:ai, load_squad_02:ai, load_squad_03:ai, load_squad_04:ai ):void
	Sleep(1);
	
	if load_side == nil then
		f_load_phantom_dual(phantom, load_squad_01, load_squad_02, load_squad_03, load_squad_04, true);
	end
	-- left 
	if load_side == "left" then
		f_load_phantom_left(phantom, load_squad_01, load_squad_02, load_squad_03, load_squad_04, true);
	end
	-- right 
	if load_side == "right" then
		f_load_phantom_right(phantom, load_squad_01, load_squad_02, load_squad_03, load_squad_04, true);
	end
	-- dual 
	if load_side == "dual" then
		f_load_phantom_dual(phantom, load_squad_01, load_squad_02, load_squad_03, load_squad_04, true);
	end
	--any
	if load_side == "any" then
		f_load_phantom_any(phantom, load_squad_01, load_squad_02, load_squad_03, load_squad_04, true);
	end
	-- chute lives!
	if load_side == "chute" then
		f_load_phantom_chute(phantom, load_squad_01, load_squad_02, load_squad_03, load_squad_04, true);
	end
end

function f_load_phantom_left( u_phantom:object, ai_squad_01:ai, ai_squad_02:ai, ai_squad_03:ai, ai_squad_04:ai, b_ai_place:boolean ):void

	f_load_phantom_seat(ai_squad_01, u_phantom, "phantom_p_lb", b_ai_place);
	f_load_phantom_seat(ai_squad_02, u_phantom, "phantom_p_lf", b_ai_place);
	f_load_phantom_seat(ai_squad_03, u_phantom, "phantom_p_ml_f", b_ai_place);
	f_load_phantom_seat(ai_squad_04, u_phantom, "phantom_p_ml_b", b_ai_place);
end

function f_load_phantom_right( u_phantom:object, ai_squad_01:ai, ai_squad_02:ai, ai_squad_03:ai, ai_squad_04:ai, b_ai_place:boolean ):void

	f_load_phantom_seat(ai_squad_01, u_phantom, "phantom_p_rb", b_ai_place);
	f_load_phantom_seat(ai_squad_02, u_phantom, "phantom_p_rf", b_ai_place);
	f_load_phantom_seat(ai_squad_03, u_phantom, "phantom_p_mr_f", b_ai_place);
	f_load_phantom_seat(ai_squad_04, u_phantom, "phantom_p_mr_b", b_ai_place);
end

function f_load_phantom_dual( u_phantom:object, ai_squad_01:ai, ai_squad_02:ai, ai_squad_03:ai, ai_squad_04:ai, b_ai_place:boolean ):void

	f_load_phantom_seat(ai_squad_01, u_phantom, "phantom_p_lf", b_ai_place);
	f_load_phantom_seat(ai_squad_02, u_phantom, "phantom_p_rf", b_ai_place);
	f_load_phantom_seat(ai_squad_03, u_phantom, "phantom_p_lb", b_ai_place);
	f_load_phantom_seat(ai_squad_04, u_phantom, "phantom_p_rb", b_ai_place);
	
	
end

function f_load_phantom_any( u_phantom:object, ai_squad_01:ai, ai_squad_02:ai, ai_squad_03:ai, ai_squad_04:ai, b_ai_place:boolean ):void

	
--	f_load_phantom_seat(ai_squad_01, u_phantom, "phantom_p", b_ai_place);
--	f_load_phantom_seat(ai_squad_02, u_phantom, "phantom_p", b_ai_place);
--	f_load_phantom_seat(ai_squad_03, u_phantom, "phantom_p", b_ai_place);
--	f_load_phantom_seat(ai_squad_04, u_phantom, "phantom_p", b_ai_place);
	
	f_load_phantom_seat(ai_squad_01, u_phantom, "phantom_p_lf", b_ai_place);
	f_load_phantom_seat(ai_squad_02, u_phantom, "phantom_p_rf", b_ai_place);
	f_load_phantom_seat(ai_squad_03, u_phantom, "phantom_p_lb", b_ai_place);
	f_load_phantom_seat(ai_squad_04, u_phantom, "phantom_p_rb", b_ai_place);
--	
--	f_load_phantom_seat(ai_squad_01, u_phantom, "phantom_p_mr_f", false);
--	f_load_phantom_seat(ai_squad_02, u_phantom, "phantom_p_mr_b", false);
--	f_load_phantom_seat(ai_squad_03, u_phantom, "phantom_p_ml_f", false);
--	f_load_phantom_seat(ai_squad_04, u_phantom, "phantom_p_ml_b", false);
	

end



function f_load_phantom_chute( u_phantom:object, ai_squad_01:ai, ai_squad_02:ai, ai_squad_03:ai, ai_squad_04:ai, b_ai_place:boolean ):void

	f_load_phantom_seat(ai_squad_01, u_phantom, "phantom_pc_1", b_ai_place);
	f_load_phantom_seat(ai_squad_02, u_phantom, "phantom_pc_2", b_ai_place);
	f_load_phantom_seat(ai_squad_03, u_phantom, "phantom_pc_3", b_ai_place);
	f_load_phantom_seat(ai_squad_04, u_phantom, "phantom_pc_4", b_ai_place);
end

function f_load_phantom_seat( ai_squad:ai, u_phantom:object, usm_seat:string, b_ai_place:boolean ):void
	if ai_squad~=nil and b_ai_place then
		ai_place(ai_squad);
	end
		
	if ai_squad~=nil then
		ai_vehicle_enter_immediate(ai_squad, u_phantom, usm_seat);
	end
end

function f_load_phantom_cargo( phantom:object, load_number:string, load_squad_01:ai, load_squad_02:ai ):void
	-- place ai 
	-- load into phantom 
	if load_number == "single" then
		ai_place(load_squad_01);
		Sleep(1);
		vehicle_load_magic(phantom, "phantom_lc", ai_vehicle_get_from_squad(load_squad_01, 0));
	elseif load_number == "double" then
		ai_place(load_squad_01);
		ai_place(load_squad_02);
		Sleep(1);
		vehicle_load_magic(phantom, "phantom_sc01", ai_vehicle_get_from_squad(load_squad_01, 0));
		vehicle_load_magic(phantom, "phantom_sc02", ai_vehicle_get_from_squad(load_squad_02, 0));
	end
end



--THIS FUNCTION IS FOR ADVANCED PHANTOM SCRIPTING AND BACKWARDS COMPATIBILITY -- USE f_unload_drop_ship FOR SIMPLE DROP SHIP LOADING
function f_unload_phantom( phantom:object, drop_side:string ):void

	drop_side = drop_side or "any";
		
	unit_open(phantom);
	sleep_s (2);
	-- determine how to unload the phantom 
	if drop_side == "left" then
		f_unload_ph_left(phantom);
		sleep_s (0.5);
		f_unload_ph_mid_left(phantom);
		sleep_s (1.5);
	end
	if drop_side == "right" then
		f_unload_ph_right(phantom);
		sleep_s (0.5);
		f_unload_ph_mid_right(phantom);
		sleep_s (1.5);
	end
	if drop_side == "dual" then
	
		sleep_s (0.5);
		f_unload_ph_left(phantom);
		f_unload_ph_right(phantom);
		sleep_s (1.5);
		f_unload_ph_mid_left(phantom);
		f_unload_ph_mid_right(phantom);
		
		sleep_s (1.5);
	end
	
	if drop_side == "any" then
		
		sleep_s (1);
--		vehicle_unload (phantom, "");
		f_unload_ph_left(phantom);
		f_unload_ph_right(phantom);
		sleep_s (1);
		f_unload_ph_mid_left(phantom);
		f_unload_ph_mid_right(phantom);
		vehicle_unload(phantom, "phantom_p");
		sleep_s (3);
	end
	if drop_side == "chute" then
		f_unload_ph_chute(phantom);
		sleep_s (2.5);
	end

	unit_close(phantom);
end

function f_unload_spirit (dropship:object, dropside:string)
	
	dropside = dropside or "any";
		
	unit_open(dropship);
	sleep_s (2);
	
	if dropside == "left" then
		f_unload_sp_left(dropship);
		sleep_s (1.5);
	end
	if dropside == "right" then
		f_unload_sp_right(dropship);
		sleep_s (1.5);
	end
	if dropside == "dual" then
	
		sleep_s (0.5);
		CreateThread (f_unload_sp_left, dropship);
		sleep_s (0.5);
		f_unload_sp_right(dropship);
		sleep_s (1);
	end
	
	if dropside == "any" then
		
		sleep_s (0.1);
--		vehicle_unload (dropship, "");
		CreateThread(f_unload_sp_left, dropship);
		f_unload_sp_right(dropship);
		sleep_s (1);
	end

	if dropside == "chute" then
		print ("unloading chute, which doesn't work");
		sleep_s (1.5);
	end

	unit_close(dropship);
end


-- you never have to call these scripts directly ===========================================================================================
--SPIRIT SIDE UNLOADS
function f_unload_sp_left( spirit:object ):void
	-- randomly evacuate the side
	for _,i in pairs (RandomOrder(4)) do
		vehicle_unload(spirit, "spirit_p_left_0"..(i+4));
		Sleep(random_range(0, 30));
	end
	
	for _,i in pairs (RandomOrder(4)) do
		vehicle_unload(spirit, "spirit_p_left_0"..i);
		Sleep(random_range(0, 30));
	end

end

function f_unload_sp_right( spirit:object ):void
	-- randomly evacuate the side
	for _,i in pairs (RandomOrder(4)) do
		vehicle_unload(spirit, "spirit_p_right_0"..(i+4));
		Sleep(random_range(0, 30));
	end
	
	for _,i in pairs (RandomOrder(4)) do
		vehicle_unload(spirit, "spirit_p_right_0"..i);
		Sleep(random_range(0, 30));
	end

end

--PHANTOM SIDE UNLOADS
function f_unload_ph_left( phantom:object ):void
	-- randomly evacuate the two sides 
	for _, idx in ipairs(RandomOrder(2)) do
		if idx==1 then
			vehicle_unload(phantom, "phantom_p_lf");
			Sleep(random_range(0, 10));
		elseif idx==2 then
			vehicle_unload(phantom, "phantom_p_lb");
			Sleep(random_range(0, 10));
		end
	end
end

function f_unload_ph_right( phantom:object ):void
	-- randomly evacuate the two sides
	for _, idx in ipairs(RandomOrder(2)) do
		if idx==1 then
			vehicle_unload(phantom, "phantom_p_rf");
			Sleep(random_range(0, 10));
		elseif idx==2 then
			vehicle_unload(phantom, "phantom_p_rb");
			Sleep(random_range(0, 10));
		end
	end
end

function f_unload_ph_mid_left( phantom:object ):void
	for _, idx in ipairs(RandomOrder(2)) do
		if idx==1 then
			-- randomly evacuate the two sides 
			vehicle_unload(phantom, "phantom_p_ml_f");
			Sleep(random_range(0, 10));
		elseif idx==2 then
			vehicle_unload(phantom, "phantom_p_ml_b");
			Sleep(random_range(0, 10));
		end
	end
end

function f_unload_ph_mid_right( phantom:object ):void
	for _, idx in ipairs(RandomOrder(2)) do
		if idx==1 then
			-- randomly evacuate the two sides 
			vehicle_unload(phantom, "phantom_p_mr_f");
			Sleep(random_range(0, 10));
		elseif idx==2 then
			vehicle_unload(phantom, "phantom_p_mr_b");
			Sleep(random_range(0, 10));
		end
	end
end

function f_unload_ph_chute( phantom:object ):void
	-- turn on phantom power 
	object_set_phantom_power(phantom, true);
	-- poop dudes out the chute 
	if vehicle_test_seat(phantom, "phantom_pc_1") then
		vehicle_unload(phantom, "phantom_pc_1");
		Sleep(120);
	end
	if vehicle_test_seat(phantom, "phantom_pc_2") then
		vehicle_unload(phantom, "phantom_pc_2");
		Sleep(120);
	end
	if vehicle_test_seat(phantom, "phantom_pc_3") then
		vehicle_unload(phantom, "phantom_pc_3");
		Sleep(120);
	end
	if vehicle_test_seat(phantom, "phantom_pc_4") then
		vehicle_unload(phantom, "phantom_pc_4");
		Sleep(120);
	end
	-- turn off phantom power 
	object_set_phantom_power(phantom, false);
end

function f_unload_phantom_cargo( phantom:object, load_number:string ):void
	-- unload cargo seats 
	if load_number == "single" then
		vehicle_unload(phantom, "phantom_lc");
	elseif load_number == "double" then
		for _, idx in ipairs(RandomOrder(2)) do
			if idx==1 then
				vehicle_unload(phantom, "phantom_sc01");
				Sleep(random_range(15, 30));
			elseif idx==2 then
				vehicle_unload(phantom, "phantom_sc02");
				Sleep(random_range(15, 30));
			end
		end
	end
end


-- DESTROY a phantom in a way that is supposed to look neat
function f_phantom_destroy( obj_phantom:object ):void
	if obj_phantom~=nil then
		damage_object(obj_phantom, "engine_right", 10000);
		damage_object(obj_phantom, "engine_left", 10000);
		damage_object(obj_phantom, "hull", 10000);
	end
end