--## SERVER



-- === Spawns AI (optional), flies phantom through the point sets until it gets to one named "drop" ===
-- === loads a squad into a phantom, flies phantom through the rest of the point sets, destroys the phantom ===
--			shipSquad = the phantom to load -- use ai_current_squad for a command script
--			squad = the AI (group, squad or actor) you want spawned and loaded into the phantom
--			ps = the point set the phantom will fly
--			drop = the point the phantom will drop the AI
--			spawnSquad = if TRUE then the squad is spawned
--			spawnShip = if TRUE then drop ship is spawned
--			side = the side the enemies will spawn into and drop out of
--	RETURNS:  void
function DeliverDropShip (shipSquad:ai, squad:ai, ps:point_set, drop:point, spawnSquad:boolean, spawnShip:boolean, side:string ):void
	dprint ("start dropship function");
	DeliverDropshipFull (shipSquad, squad, ps, drop, spawnSquad, spawnShip, side, false);
end

function DeliverDropShipVehicle (shipSquad:ai, squad:ai, ps:point_set, drop:point, spawnSquad:boolean, spawnShip:boolean, side:string ):void
	dprint ("start dropship function");
	DeliverDropshipFull (shipSquad, squad, ps, drop, spawnSquad, spawnShip, side, true);
end



function DeliverDropshipFull (shipSquad:ai, squad:ai, ps:point_set, drop:point, spawnSquad:boolean, spawnShip:boolean, side:string, veh:boolean ):void

	assert(shipSquad ~= nil, "DeliverDropShipFull: error, no dropship squad specified");
	
	if spawnShip and ai_living_count(shipSquad) > 0 then
		return print ("the drop ship is already spawned, ending the DeliverDropshipFull script");
	end
	
	if squad == nil then
		print ("no specified squad to fill the drop ship");
	end

	assert(ps ~= nil, "DeliverDropShipFull: error, no point set specified");
	
	side = side or "any";
	
	--load the drop ship	
	if veh then
		LoadDropShipVehicle (shipSquad, squad, spawnSquad, spawnShip);
	else
		LoadDropShip (shipSquad, squad, spawnSquad, spawnShip, side);
	end
	
	DropShipFlyTo (shipSquad, ps, drop, side, veh);

	object_set_scale(ai_vehicle_get_from_squad(shipSquad), 0.01, seconds_to_frames(3));
	sleep_s (3);
	ai_erase(shipSquad);

	dprint ("DeliverDropShipFull: destroying dropship");
end


-- === flies phantom through point sets, optionally unloads ===
--			ship squad = the phantom to load -- use ai_current_squad for a command script
--			ps = the point set the phantom will fly
--			drop = the point the phantom will drop the AI
--			side = the side the enemies will spawn into and drop out of
--			veh = if the sqaud is a vehicle
--	RETURNS:  void
function DropShipFlyTo (shipSquad:ai, ps:point_set, drop:point, side:string, veh:boolean)
	if shipSquad == nil then
		print ("no dropship squad in function");
	end
	
	assert(ps ~= nil, "DropShipFlyTo: no pointset called");
	
	local driver:ai = object_get_ai(vehicle_driver(ai_vehicle_get_from_squad (shipSquad)));

	--put the driver into a command script so that it never enters "wander" behavior
	cs_run_command_script(driver, "cs_ActorIsInForeverCommandScript");
	
	for i = 1, #ps do
		dprint ("flying to", ps[i]);
		
		cs_fly_to (driver, true, ps[i]);
		
		if ps[i] == drop then
			dprint ("unloading");
			sleep_s(0.3);
			if veh then
				UnloadDropShipVehicle(shipSquad);
			else
				UnloadDropShip(shipSquad, side);
			end
		end
	end
end


function IsUnitInSpirit(driver:object):boolean
	return unit_in_vehicle_type (driver, CAMPAIGN_METAGAME_BUCKET_TYPE.tuning_fork);
end


--forcing the actor to be in a braindead state forever
--using magic number to less operations
function cs_ActorIsInForeverCommandScript()
	ai_set_blind(ai_current_actor, true);
	ai_set_deaf(ai_current_actor, true);
	SleepUntil([|false], 60000);
end


-- === Spawns AI (optional) and loads them into a phantom.  Can be used in a command script
--			ship squad = the phantom to load -- use ai_current_squad this for a command script
--			squad = the AI (group, squad or actor) you want spawned and loaded into the phantom
--			spawnSquad = if TRUE then the squad is spawned
--			spawnShip = if TRUE then drop ship is spawned
--			side = the side to load the occupants
--	RETURNS:  void

function LoadDropShip( shipSquad:ai, squad:ai, spawnSquad:boolean, spawnShip:boolean, side:string ):void
	--print("load phantom ...");
	
	if shipSquad == nil then
		print ("LoadDropShip: no dropship squad in function");
		return
	end
	
	if squad == nil then
		print ("LoadDropShip: no specified squad to fill the drop ship");
	end
	
	side = side or "any";
	
	--if spawnShip is true, then spawn the ship and scale it
	if spawnShip then
		ai_place (shipSquad);
	end
	
	local dropship:object = ai_vehicle_get_from_squad (shipSquad);
	object_hide(dropship, true)
			
	if spawnSquad then
		ai_place (squad);
		--print ("squad to place in dropship placed");
	end
	
	--place the enemies into the phantom
	local squadCount = ai_living_count (squad);
	local shipCount = ai_living_count (shipSquad);
	if squadCount <= 0 or shipCount <= 0 then
		if squadCount <= 0 then
			print ("LoadDropShip: no living AI to place in drop ship");
		end
		if shipCount <= 0 then
			print ("LoadDropShip: no living drop ship");
		end
	else	
		if side == "left" then
			LoadDropShipLeft (shipSquad, squad);
		elseif side == "right" then
			LoadDropShipRight (shipSquad, squad);
		elseif side == "any" then
			LoadDropShipAny (shipSquad, squad);
		end
	--	print ("loaded drop ship");
	--	print ("# of ai in the vehicle is", ai_living_count (shipSquad));
	--	print ("# of ai remaining is", ai_living_count (squad));
	end
	
	object_set_scale(dropship, 0.01, 1);
	object_hide(dropship, false);
	dprint ("scaling dropship");
	object_cannot_die(dropship, true);
	sleep_s(0.1);
	object_set_scale(dropship, 1.0, seconds_to_frames (3));
	object_cannot_die(dropship, false);
end


function LoadDropShipSeats (shipSquad:ai, squad:ai, phantomSeats:string, spiritSeats:string)
	local dropship:object = ai_vehicle_get_from_squad (shipSquad);
	local driver:ai = ai_vehicle_get_driver(ai_vehicle_get_from_squad (shipSquad));
	--if the vehicle is a spirit then load this way
	if IsUnitInSpirit(driver) then
		vehicle_load_magic (dropship, spiritSeats, squad);
	--if the vehicle isn't a spirit (it's a phantom) then
	else
		vehicle_load_magic (dropship, phantomSeats, squad);
	end
end

--load the phantom only on the right side
function LoadDropShipRight (shipSquad:ai, squad:ai)
	LoadDropShipSeats (shipSquad, squad, "phantom_p_r", "spirit_p_right");
end


--load the phantom only on the left side
function LoadDropShipLeft (shipSquad:ai, squad:ai)
	LoadDropShipSeats (shipSquad, squad, "phantom_p_l", "spirit_p_left");
end


--load the phantom only on both sides
function LoadDropShipAny (shipSquad:ai, squad:ai)
	LoadDropShipSeats (shipSquad, squad, "phantom_p_", "spirit_p_");
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

function UnloadDropShip( shipSquad:ai, dropside:string ):void
	--print("unload dropship");
		
	dropside = dropside or "any";
		
	local dropship:object = ai_vehicle_get_from_squad (shipSquad);
	local driver:ai = ai_vehicle_get_driver(ai_vehicle_get_from_squad (shipSquad));
	
--	unit_open(dropship);
--	sleep_s (2);
	
	--if the vehicle is a spirit then unload this way
	if IsUnitInSpirit(driver) then
		print ("unloading spirit");
		UnloadSpirit(dropship, dropside);
	else
	--if the vehicle is a phantom then unload this way
	-- determine how to unload the phantom 
	--run f_replace_unload_phantom
		UnloadPhantom(dropship, dropside);
	end
end



-- === Spawns AI and loads them into a phantom.  Usually used in a command script
--			drop ship = the phantom to load -- use script like this for a command script (ai_current_squad)
--			load_squad = the AI (group, squad or actor) that is in a vehicle you want spawned and loaded into the phantom
--			spawnSquad = if TRUE then the squad is spawned
--			spawnShip = if TRUE then drop ship is spawned
--	RETURNS:  void

function LoadDropShipVehicle (drop_ship:ai, load_squad:ai, spawnSquad:boolean, spawnShip:boolean)
	--print ("load a drop ship with vehicles");
	
	if drop_ship == nil then
		print ("no dropship squad in function");
	end
	
	if load_squad == nil then
		print ("no specified squad to fill the drop ship");
	end
	
	if spawnSquad == nil then
		spawnSquad = false;
	end
	
	if spawnShip == nil then
		spawnShip = false;
	end
	
	if spawnShip then
		ai_place (drop_ship);
	end
	
	if spawnSquad then
		ai_place (load_squad);
	end
	
	local dropship:object = ai_vehicle_get_from_squad (drop_ship);
	local spirit:boolean = IsUnitInSpirit(ai_vehicle_get_driver(dropship));
	local aiCount = ai_living_count (load_squad);
	
	if aiCount <= 0 then
		print ("LoadDropShipVehicle: no living AI to place in drop ship");
	elseif aiCount == 1 then
		vehicle_load_magic(dropship, "phantom_lc", ai_vehicle_get_from_squad(load_squad, 0));
	elseif aiCount >= 2 then
		if spirit then
			vehicle_load_magic(dropship, "phantom_lcb", ai_vehicle_get_from_squad(load_squad, 0));
			vehicle_load_magic(dropship, "phantom_lc", ai_vehicle_get_from_squad(load_squad, 1));
		else
			vehicle_load_magic(dropship, "phantom_sc01", ai_vehicle_get_from_squad(load_squad, 0));
			vehicle_load_magic(dropship, "phantom_sc02", ai_vehicle_get_from_squad(load_squad, 1));
		end
		
		if aiCount > 2 then
			print ("LoadDropShipVehicle: too many vehicles to load, not all loaded");
		end
	end
	
	dprint ("loaded drop ship");
	dprint ("# of ai in the vehicle is", ai_living_count (ai_get_squad(ai_vehicle_get_driver(dropship))));
	dprint ("# of ai remaining is", ai_living_count (load_squad));
end


-- === Unloads a drop ship.  Usually used in a command script
--			drop ship = the dropship to unload -- use script like this for a command script... ai_current_squad
--			drop_num = which cargo seat to unload.  1, 2 or both (anything besides 1 or 2 will do both)
--	RETURNS:  void
function UnloadDropShipVehicle(drop_ship:ai, drop_num:number):void
	-- unload cargo seats 
	--print ("unload drop ship vehicles");
	
	local dropShip:object = ai_vehicle_get_from_squad (drop_ship);
	
	if drop_num == nil then
		drop_num = 0;
		--drop_num = vehicle_test_seat(dropship, "phantom_lc") + vehicle_test_seat(dropship, "phantom_sc01") + vehicle_test_seat(dropship, "phantom_sc02");
	end
	
	if drop_num == 1 then
		UnloadDropShipSeatOne(dropShip);
	elseif drop_num == 2 then
		UnloadDropShipSeatTwo(dropShip);
	else
		UnloadDropShipSeatOne(dropShip);
		sleep_s (random_range(0.5, 1));
		UnloadDropShipSeatTwo(dropShip);
	end
end

function UnloadDropShipSeatOne(dropShip:object):void
	vehicle_unload(dropShip, "phantom_lc");
	vehicle_unload(dropShip, "phantom_sc01");

end

function UnloadDropShipSeatTwo(dropShip:object):void
	vehicle_unload(dropShip, "phantom_sc02");
	vehicle_unload(dropShip, "phantom_lcb");
end

--THIS FUNCTION IS FOR ADVANCED PHANTOM SCRIPTING AND BACKWARDS COMPATIBILITY -- USE UnloadDropShip FOR SIMPLE DROP SHIP LOADING
function UnloadPhantom( phantom:object, drop_side:string ):void

	drop_side = drop_side or "any";
		
	unit_open(phantom);
	sleep_s (2);
	-- determine how to unload the phantom 
	if drop_side == "left" then
		UnloadPhantomLeft(phantom);
		sleep_s (0.5);
		UnloadPhantomMidLeft(phantom);
		sleep_s (1.5);
	end
	if drop_side == "right" then
		UnloadPhantomRight(phantom);
		sleep_s (0.5);
		UnloadPhantomMidRight(phantom);
		sleep_s (1.5);
	end
	if drop_side == "dual" then
	
		sleep_s (0.5);
		UnloadPhantomLeft(phantom);
		UnloadPhantomRight(phantom);
		sleep_s (1.5);
		UnloadPhantomMidLeft(phantom);
		UnloadPhantomMidRight(phantom);
		
		sleep_s (1.5);
	end
	
	if drop_side == "any" then
		
		sleep_s (1);
--		vehicle_unload (phantom, "");
		UnloadPhantomLeft(phantom);
		UnloadPhantomRight(phantom);
		sleep_s (1);
		UnloadPhantomMidLeft(phantom);
		UnloadPhantomMidRight(phantom);
		vehicle_unload(phantom, "phantom_p");
		sleep_s (3);
	end
	if drop_side == "chute" then
		UnloadPhantomChute(phantom);
		sleep_s (2.5);
	end

	unit_close(phantom);
end

function UnloadSpirit (dropship:object, dropside:string)
	
	dropside = dropside or "any";
		
	unit_open(dropship);
	sleep_s (2);
	
	if dropside == "left" then
		UnloadSpiritLeft(dropship);
		sleep_s (1.5);
	end
	if dropside == "right" then
		UnloadSpiritRight(dropship);
		sleep_s (1.5);
	end
	if dropside == "dual" then
	
		sleep_s (0.5);
		CreateThread (UnloadSpiritLeft, dropship);
		sleep_s (0.5);
		UnloadSpiritRight(dropship);
		sleep_s (1);
	end
	
	if dropside == "any" then
		
		sleep_s (0.1);
--		vehicle_unload (dropship, "");
		CreateThread(UnloadSpiritLeft, dropship);
		UnloadSpiritRight(dropship);
		sleep_s (1);
	end

	if dropside == "chute" then
		print ("unloading chute, which doesn't work");
		sleep_s (1.5);
	end

	unit_close(dropship);
end


function UnloadPelican(pelican:object, dropSide:string ):void
	print("unloading Pelican");
	dropSide = dropSide or "any";
		
	unit_open(pelican);
	sleep_s (2);
	-- determine how to unload the pelican 
	if dropSide == "left" then
		--UnloadPhantomLeft(pelican);
		vehicle_unload(pelican, "pelican_p_l");
		sleep_s (1.5);
	end
	
	if dropSide == "right" then
		vehicle_unload(pelican, "pelican_p_r");
		sleep_s (1.5);
	end
		
	if dropSide == "any" then
		local randomTable:table = RandomOrder({"pelican_p_l", "pelican_p_r"});
		vehicle_unload(pelican, randomTable[1]);
		sleep_s (1);
		vehicle_unload(pelican, randomTable[2]);
		sleep_s (1.5);
	end
	
	unit_close(pelican);
end


-- you never have to call these scripts directly ===========================================================================================
--SPIRIT SIDE UNLOADS
function UnloadSpiritSeats(spirit:object, seats:string):void
	-- randomly evacuate the side
	for _,i in pairs (RandomOrder(4)) do
		vehicle_unload(spirit, seats..(i+4));
		Sleep(random_range(0, 30));
	end
	
	for _,i in pairs (RandomOrder(4)) do
		vehicle_unload(spirit, seats..i);
		Sleep(random_range(0, 30));
	end
end

function UnloadSpiritLeft(spirit:object):void
	UnloadSpiritSeats(spirit, "spirit_p_left_0");
end

function UnloadSpiritRight(spirit:object):void
	UnloadSpiritSeats(spirit, "spirit_p_right_0");
end

--PHANTOM SIDE UNLOADS
function UnloadPhantomSeats(phantom:object, seatOne:string, seatTwo:string):void
	-- randomly evacuate the two sides 
	for _, idx in ipairs(RandomOrder(2)) do
		if idx==1 then
			vehicle_unload(phantom, seatOne);
			Sleep(random_range(0, 10));
		elseif idx==2 then
			vehicle_unload(phantom, seatTwo);
			Sleep(random_range(0, 10));
		end
	end
end


function UnloadPhantomLeft(phantom:object):void
	UnloadPhantomSeats(phantom, "phantom_p_lf", "phantom_p_lb");
end

function UnloadPhantomRight(phantom:object):void
	UnloadPhantomSeats(phantom, "phantom_p_rf", "phantom_p_rb");
end

function UnloadPhantomMidLeft(phantom:object):void
	UnloadPhantomSeats(phantom, "phantom_p_ml_f", "phantom_p_ml_b");
end

function UnloadPhantomMidRight(phantom:object):void
	UnloadPhantomSeats(phantom, "phantom_p_mr_f", "phantom_p_mr_b");
end

function UnloadPhantomChute(phantom):void
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

function UnloadPhantomCargo(phantom:object, load_number:string):void
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
function PhantomDestroy( obj_phantom:object ):void
	if obj_phantom~=nil then
		damage_object(obj_phantom, "engine_right", 10000);
		damage_object(obj_phantom, "engine_left", 10000);
		damage_object(obj_phantom, "hull", 10000);
	end
end