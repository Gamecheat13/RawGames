



	

	
//SESSION MODE FLAGS
// should stay the same as eGameModes in com_gamemodes.h








// SPAWNFLAGS













	










// UNDELETABLE									4
// ENEMYINFO									8










// UNDELETABLE										4

// These match the SPAWNFLAG_ACTOR flags
//#define SPAWNFLAG_VEHICLE_SCRIPTFORCESPAWN			16
//#define SPAWNFLAG_VEHICLE_SM_PRIORITY					32
//#define SPAWNFLAG_VEHICLE_SCRIPTINFINITESPAWN			64
//#define SPAWNFLAG_VEHICLE_SCRIPTDELETEONZEROCOUNT		128
	





	



	










	


	

	
// CONTENTS












	// AI cannot see through this
	// bullets hit this











	// used for mantle / ladder / ledge / pipe traversals







	
// Physics Trace Masks






// LUI defines









// Team enums




// IDENTIFIERS











	

























	
// Native UI resolution is 720p


	
// Register Systems









	


// UTILITIES































	

	
// MATH




	



	









// STRINGS




// ARRAYS




	
 // match code

	
//********************************************************************************	
//MOVED FROM CLIENTFLAGS.GSH
//  These are not client flags they're just constants
//  TODO - these should be moved into their respective scripts
//********************************************************************************	

// Riotshield



// Trophy System





// Bouncing Betty ( Trip mine, Spider mine )




// Proxy (Tazer Spike)



// QR Drone






//********************************************************************************	
//MOVED FROM SP.GSH
//********************************************************************************	





//VEHICLE FUNCTIONS











//VEHICLE TYPE FUNCTIONS - we should maybe break this out into a vehicle.gsh





//











// script defines for fog bank bit mask






//Analog stick layout stat values




	
//ID FLAGS
//code-defined in g_local.h:
//also matches scripts\zm\_callbacks.gsc

	// damage
	// damage was indirect
	// armor does not protect from this damage
	// do not affect velocity, just view angles
	// damage occurred after one or more penetrations
	// force the destructible system to do damage to the entity
	// missile impacted on the front of the victim's shield
	//   ...and was from a projectile with "Big Explosion" checked on.
	// explosive splash, somewhat deflected by the victim's shield
 // The trigger that applied the damage will ignore laststand
 // Don't go to ragdoll if got damage while playing death animation
	
// script-defined:




// TODO: can probably be remove once the real awareness system is up





//use this macro to smooth out periodic updates that don't need to occur at a tightly fixed interval.  Over time monitor loops will tend to spread out, removing large performance spikes



// IF_DEFINED MACROS	















//********************************************************************************	
//MOVED FROM _MENU.GSC
//********************************************************************************	




















//********************************************************************************	
// FILTER_SHARED 
//********************************************************************************	















	
// flags for auto-deleting entities with util::auto_delete
	// only delete if ent is behind player AND sight blocked
	// delete if ent is behind player
	// delete if ent is sight blocked
	// delete if ent is behind player OR sight blocked
	// same as DELETE_BOTH but quicker


