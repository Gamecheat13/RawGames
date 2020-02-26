//34343434343434343434343434343434343434343434343434343434343434343434343434343434343434343434343434334343434343434343434343434343434343434343434343434343434
//
// 	SPARTAN OPS: AI
//										
//34343434343434343434343434343434343434343434343434343434343434343434343434343434343434343434343434334343434343434343434343434343434343434343434343434343434

// ----------------------------------------------------------------------------------------------------------------------------------------------------------
// ----------------------------------------------------------------------------------------------------------------------------------------------------------
// ----------------------------------------------------------------------------------------------------------------------------------------------------------
// *** SPOPS: VEHICLE ***
// ----------------------------------------------------------------------------------------------------------------------------------------------------------
// ----------------------------------------------------------------------------------------------------------------------------------------------------------
// ----------------------------------------------------------------------------------------------------------------------------------------------------------

// FUNCTIONS ------------------------------------------------------------------------------------------------------------------------------------------------

// === spops_ai_get_vehicle::: Will try every type of function for getting a vehicle
// XXX document params
script static vehicle spops_ai_get_vehicle( ai ai_any )
	local vehicle vh_return = NONE;
	
	if ( vh_return == NONE ) then
		vh_return = ai_vehicle_get( ai_any );
	end
	if ( vh_return == NONE ) then
		vh_return = ai_vehicle_get_from_squad( ai_any, 0 );
	end
	if ( vh_return == NONE ) then
		vh_return = unit_get_vehicle( ai_any );
	end
	if ( vh_return == NONE ) then
		vh_return = ai_vehicle_get_from_spawn_point( ai_any );
	end
	
	// return
	vh_return;
end

// === spops_vehicle_load_seat::: XXX
// XXX document params
script static boolean spops_vehicle_load_seat( vehicle vh_vehicle, ai ai_load, unit_seat_mapping usm_seat )
local boolean b_loaded = FALSE;
 
 	// magic load
 	if ( (not b_loaded) and (not vehicle_test_seat(vh_vehicle, usm_seat)) ) then
		//dprint( "spops_vehicle_load_seat: MAGIC" );
		ai_exit_limbo( ai_load );
		vehicle_load_magic( vh_vehicle, usm_seat, ai_load );
		b_loaded = vehicle_test_seat( vh_vehicle, usm_seat );
 	end
 
	// immediate load
 	if ( (not b_loaded) and (not vehicle_test_seat(vh_vehicle, usm_seat)) ) then
		//dprint( "spops_vehicle_load_seat: IMMEDIATE" );
		ai_exit_limbo( ai_load );
		ai_vehicle_enter_immediate( ai_load, vh_vehicle, usm_seat );
		b_loaded = vehicle_test_seat( vh_vehicle, usm_seat );
 	end

	// return
	//dprint( "spops_vehicle_load_seat: FINAL" );
	//inspect( b_loaded );
	b_loaded;
end

// === spops_vehicle_load_marker::: XXX
// XXX document params
script static boolean spops_vehicle_load_marker( vehicle vh_vehicle, object obj_load, string_id sid_marker )
local ai ai_load = object_get_ai( obj_load );

	if ( object_at_marker(vh_vehicle, sid_marker) == NONE ) then

		// check if loading an ai with a vehicle
		if ( ai_load != NONE ) then
			local object obj_vehicle = spops_ai_get_vehicle( ai_load );
			
			if ( obj_vehicle != NONE ) then
				//dprint( "spops_vehicle_load_marker: VEHICLE" );
				obj_load = obj_vehicle;
			end
			
		end
		
		//attach
		//dprint( "spops_vehicle_load_marker: ATTACH" );
		objects_attach( vh_vehicle, sid_marker, obj_load, "" );

	end

	// return
	object_at_marker(vh_vehicle, sid_marker) == obj_load;
end
