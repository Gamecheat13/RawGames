////////////////////////////////////////////
//	CHARACTERS
////////////////////////////////////////////





////////////////////////////////////////////
//	TRAPS
////////////////////////////////////////////

// GENERIC TRAP





// CHAIN TRAP








// SMASHER TRAP








////////////////////////////////////////////
//	QUEST
////////////////////////////////////////////

// CLIENTFIELDS - RITUAL STATE







// CLIENTFIELDS - DEFEND AREAS

	
// CLIENTFIELDS - RITUALS
// ritual identities - used to store which ritual is currently active (so we can reuse CF_AREA_DEFEND_PROGRESS_BITS for each defend)







	
// TUNABLES - RITUALS
 // how many units the corpse at a ritual will rise at maximum
	
// TUNABLES - DEFEND AREAS
// --RADIUS

// --PROGRESS

 // default number of seconds it takes for the full team to complete the area defend


 // in seconds
 // default number of seconds

// RITUAL CIRCLE VISUAL STATES





////////////////////////////////////////////
//	STAIR
////////////////////////////////////////////







////////////////////////////////////////////
//	POWER
////////////////////////////////////////////












	
////////////////////////////////////////////
//	DISTRICT NAMES
////////////////////////////////////////////












////////////////////////////////////////////
//	ZONE SUBSTRINGS
////////////////////////////////////////////







	
////////////////////////////////////////////
//	TRAIN PARAMETERS
////////////////////////////////////////////






////////////////////////////////////////////
//	IDGUN PARAMETERS
////////////////////////////////////////////
	


















////////////////////////////////////////////
//	SWORD
////////////////////////////////////////////




// what stage is the player's keeper/egg? (this is a toplayer clientfield)











// which magic circle is currently active (world clientfield; one magic circle can be active at a time)






// what state of activation is the magic circle?








	
////////////////////////////////////////////
//	PLAYER RUMBLE DEFINES
////////////////////////////////////////////













////////////////////////////////////////////
//	IDGUN DEFINES
////////////////////////////////////////////

// how many idguns are allowed in the map?

// what round do idgun parts start to drop in?



////////////////////////////////////////////
//	OCTOBOMB PARAMETERS
////////////////////////////////////////////





// number of states that the octobomb dash can have relative to a location

// how many octobomb dash areas are there in the map?

// delay before the octobomb does its dash (sound plays inside the walls during this)




	
	
////////////////////////////////////////////
//	MAGIC BOX PARAMETERS
////////////////////////////////////////////
	



////////////////////////////////////////////
//	BGB (BUBBLEGUM BUFF) SETTINGS
////////////////////////////////////////////




////////////////////////////////////////////
//	PORTAL STATES
////////////////////////////////////////////






// how long it takes players/zombies to go through the portal



////////////////////////////////////////////
//	EE QUEST DEFINES
////////////////////////////////////////////
	
















	// Keeper lifts off of Altar, then relocates to the Shadow Man room
	// Keeper has its sword in hand, is semi-crouched in the air
	// Keeper lifts a few feet in the air, straightens its pose and points its sword at the Shadow Man
	// Keeper returns to the rest-pose, but with curse fx playing on it (Superbeast player needs to cleanse)
	// Keeper teleports away, relocates to the Boss fight
	// Keeper floats in the rest-pose in its Boss fight location
	// Keeper enters the attack-pose in its Boss fight location







// keeper locations throughout the ee quest




	
// had to split darkfire buffs b/c two ai are actors and two ai are vehicles, which have different pools

































// overall ee tuning
 // if a player is within this safety radius, don't spawn the cursetrap yet

// zombie challenge


	// how many keeper symbols can be available for pickup at the same time?
	// this minus one -> highest number of drops that can take place before a correct drop occurs
 // how long it takes a symbol to fly into place after being picked up
 // squared safety radius to prevent keeper symbols from spawning on top of each other
	// distance at which a Keeper equation activates
	// height the Keeper equations should be off the ground (above their struct)

// elemental challenge


// parasite challenge
	// Max number that can be alive at any one time (mainly limited by networking concerns)
	// Max alive per player in the game

// time for a pod to grow to each stage














// margwa challenge






// shadowman battle




 // shadowman location where he can be defeated
 // min count of buffed zombies to spawn
 // max count of buffed zombies to spawn at a time
 // min count of elementals to spawn
 // max count of elementals to spawn at a time
 // min count of margwa to spawn
 // max count of margwa to spawn at a time
 // max count of zombies to spawn at a time
 // how much normal damage must be applied to the Shadow Man to make it change position?


// apothigod battle




 // number of seconds after a successful shot against the boss before spawning restarts
 // number of seconds between Margwa spawns
 // number of seconds Margwa heart stays up until disappearing














	
// superworm states for the apothigod battle











	
////////////////////////////////////////////
//	MISC EXTRA
////////////////////////////////////////////









