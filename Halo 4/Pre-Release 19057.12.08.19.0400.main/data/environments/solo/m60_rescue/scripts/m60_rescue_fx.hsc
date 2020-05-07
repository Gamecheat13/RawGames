//343434343434343434343434343434343434343434343434343434343434343434343434343434343434343434343434343
//
// Mission: 					m60_rescue_fx
//										
//343434343434343434343434343434343434343434343434343434343434343434343434343434343434343434343434343

// =================================================================================================
// =================================================================================================
// *** GLOBALS ***
// =================================================================================================
// =================================================================================================

//

// =================================================================================================
// =================================================================================================
// *** START-UP ***
// =================================================================================================
// =================================================================================================


// The script is played by the "mech_reveal" puppeteer in the m60_rescue_3d scenario layer
script static void mech_reveal_effects()
	dprint("Mech door effects.");
	
	// Mech door
	effect_new_on_object_marker(environments\solo\m60_rescue\fx\sparks\sparks_mech_rising_door_opening.effect, mech_platform, fx_door_opening_crack);
	effect_new_on_object_marker(environments\solo\m60_rescue\fx\steam\steam_mech_rising_door_opening.effect, mech_platform, fx_door_opening_crack);
	effect_new_on_object_marker(environments\solo\m60_rescue\fx\steam\dry_ice_mech_rising_platform.effect, mech_platform, fx_center_rising_platform);
	
	// Mech
	effect_new_on_object_marker(environments\solo\m60_rescue\fx\steam\dry_ice_mech_rising_from_mech.effect, mechsuit_1, fx_l_shoulder );
	effect_new_on_object_marker(environments\solo\m60_rescue\fx\steam\dry_ice_mech_rising_from_mech.effect, mechsuit_1, fx_r_shoulder );
	
end

/*script startup m60_rescue_fx()

	if b_debug then 
		print ("::: M60 - FX :::");
	end
	
	thread(test_fx());
end

script static void test_fx()
	print ("::: test FX :::");
	//effect_new( cinematics\cin_verticalslice\fx\rig_spark_pipe.effect, test_fx );
end



// === fx_zoneset_13_rally_point::: Startup and cleanup area FX
script static void fx_zoneset_13_rally_point( short s_zoneset_loading_index, short s_zoneset_unloading_index )
	if ( current_zone_set_fully_active() == S_zoneset_13_rally_point ) then
		effect_attached_to_camera_new ( environments\solo\m60_rescue\fx\embers\embers_ambient_floating.effect );
	elseif ( s_zoneset_unloading_index == s_rally_ins_idx ) then
		dprint( "fx_zoneset_13_rally_point: CLEANUP" );
	end
end
// === fx_zoneset_14_rally_point::: Startup and cleanup area FX
script static void fx_zoneset_14_rally_point( short s_zoneset_loading_index, short s_zoneset_unloading_index )
	if ( current_zone_set_fully_active() == s_rally_bowl_ins_idx ) then
		effect_attached_to_camera_new ( environments\solo\m60_rescue\fx\embers\embers_ambient_floating.effect );
	elseif ( s_zoneset_unloading_index == S_zoneset_14_rally_point ) then
		dprint( "fx_zoneset_14_rally_point: CLEANUP" );
	end
end
// === fx_zoneset_15_rally_point::: Startup and cleanup area FX
script static void fx_zoneset_15_rally_point( short s_zoneset_loading_index, short s_zoneset_unloading_index )
	if ( current_zone_set_fully_active() == S_zoneset_15_rally_point ) then
		effect_attached_to_camera_new( environments\solo\m60_rescue\fx\embers\embers_ambient_floating.effect );
	elseif ( s_zoneset_unloading_index == S_zoneset_15_rally_point ) then
		dprint( "fx_zoneset_15_rally_point: CLEANUP" );
	end
end
// === fx_zoneset_16_rally_point::: Startup and cleanup area FX
script static void fx_zoneset_16_rally_point( short s_zoneset_loading_index, short s_zoneset_unloading_index )
	if ( current_zone_set_fully_active() == S_zoneset_16_rally_point ) then
		effect_attached_to_camera_new( environments\solo\m60_rescue\fx\embers\embers_ambient_floating.effect );
	elseif ( s_zoneset_unloading_index == S_zoneset_16_rally_point ) then
		dprint( "fx_zoneset_16_rally_point: CLEANUP" );
	end
end
// === fx_zoneset_17_air_lock::: Startup and cleanup area FX
script static void fx_zoneset_17_air_lock( short s_zoneset_loading_index, short s_zoneset_unloading_index )
	if ( current_zone_set_fully_active() == S_zoneset_17_air_lock ) then
		effect_attached_to_camera_new( NONE );
	elseif ( s_zoneset_unloading_index == S_zoneset_17_air_lock ) then
		dprint( "fx_zoneset_17_air_lock: CLEANUP" );
	end
end



// -------------------------------------------------------------------------------------------------
// FX: CAMERA
// -------------------------------------------------------------------------------------------------
// VARIABLES
global boolean B_fx_camera_paused = FALSE;
global effect FX_camera_last = NONE;
global effect FX_camera_paused = NONE;

// FUNCTIONS
// === fx_camera_set::: Sets the camera FX and cleans up any fx that may be running; while paused will only store new camera FX requests and then re-add them when unpaused
script static void fx_camera_set( effect fx_camera_new )

	if ( not B_fx_camera_paused ) then
		// make sure this is a new FX
		if ( fx_camera_new != fx_camera_last ) then
		
			// start the new effect
			if ( fx_camera_new != NONE ) then
				effect_attached_to_camera_new( fx_camera_new );
			end
		
			// remove the old effect
			if ( fx_camera_last != NONE ) then
				effect_attached_to_camera_stop( fx_camera_last );
			end
			
			// store the camera FX for the next time it changes
			fx_camera_last = fx_camera_new;
		end
	else
		// store the fx for later
		FX_camera_paused = fx_camera_new;
	end

end

// === fx_camera_pause::: Pauses or unpauses camera FX; if TRUE will stores and clear current FX from the camera, FALSE will restore FX
script static void fx_camera_pause( boolean b_pause )

	if ( B_fx_camera_paused != b_pause ) then
	
		if ( b_pause ) then
	
			// store the last fx in the paused
			FX_camera_paused = FX_camera_last;
			// set fx to none
			fx_camera_set( NONE );
			
		else
		
			// restore the paused camera FX
			fx_camera_set( FX_camera_paused );
			// clear the paused fx stored
			FX_camera_paused = NONE;
			
		end
	
		B_fx_camera_paused = b_pause;
	end

end
*/