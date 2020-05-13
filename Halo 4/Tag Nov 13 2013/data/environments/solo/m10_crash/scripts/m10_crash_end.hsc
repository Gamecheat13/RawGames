//343434343434343434343434343434343434343434343434343434343434343434343434343434343434343434343434343
//
// Mission: 					m10_crash_end
//	Insertion Points:	start (or icr)	- Beginning
//										ibr							- Broken Floor
//										iea							- explosion alley
//										ivb							- Vehicle Bay
//										iju							- Jump Debris
//										
//343434343434343434343434343434343434343434343434343434343434343434343434343434343434343434343434343

// =================================================================================================
// TODO ============================================================================================
// GENERAL -----------------------------------------------------------------------------------------
//	-	rename script to areas/insertions
//	- Screenshake
//		- Hook into Jesse's system
//		- Variety
//		- Discuss with Audio
//		- Implement new system stuff
//			- Direction
//			- Falloff
//		- Escelate shakes as the mission goes on
//		- Share integration [libraries]
//		- Drop
//			- Get validitation of design
//			- Spec
//			- Implement
//	- Weapons & ammo
//	- No vibration in zero g from screenshakes
// START -------------------------------------------------------------------------------------------
//	- Setup start room
// SPLIT -------------------------------------------------------------------------------------------
//	- Test pathing
//	- Elarge area?
//	- Platform 01 ramp cause slide
// EXPLOSION ALLEY ---------------------------------------------------------------------------------
//	- Add Covenant that gets killed
//	- Explosion force
// VEHICLE -----------------------------------------------------------------------------------------
//	- Get new area hooked up
//	- Update encounter for area changes
// JUMP DEBRIS -------------------------------------------------------------------------------------
//	- Mission Complete
//		- Integrate real mission complete
// =================================================================================================

// =================================================================================================
// =================================================================================================
// END
// =================================================================================================
// =================================================================================================
// variables

// functions
// === f_END_startup: Initialize all the end sequence pieces
script startup f_END_startup()
	sleep_until( b_mission_started == TRUE, 1 );
	//dprint( "::: f_END_startup :::" );
	
	// initialize sub areas
	//wake( f_END_airlock_init );
	wake( f_brokenfloor_init );
	wake( f_maintenance_init );
//	wake( f_vehiclebay_init );
//	wake( f_debris_init );
	
end

// === f_END_deinit::: Deinitialize
script dormant f_END_deinit()
	//dprint( "::: f_END_deinit :::" );

	// kill any functions
	//sleep_forever( f_END_init );

	// deinitialize sub areas
	//wake( f_END_airlock_deinit );
	wake( f_brokenfloor_deinit );
	wake( f_maintenance_deinit );
//	wake( f_vehiclebay_deinit );
//	wake( f_debris_deinit );

end
