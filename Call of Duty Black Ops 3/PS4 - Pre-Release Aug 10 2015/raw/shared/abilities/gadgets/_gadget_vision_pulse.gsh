

 // no alpha to differentiate from view model in shader

	
//	SCRIPT VECTOR USAGE
//		scriptVector0.x : pulse position in the world (1.0 near, 0.0 far)
//		scriptVector0.y : pulse width (percentage of value in material)
//		scriptVector0.z : pulse edge width
//		scriptVector0.w : iris appearance and character glow fade
//		scriptVector1.x : highlight enemeies (0: no, 1: yes)
//		scriptVector1.y : viewmodel pulse width
//		scriptVector1.z : viewmodel pulse edge width
//		scriptVector1.w : viewmodel pulse max radius
//		scriptVector2.xy: viewmodel pulse origin
//		scriptVector2.z : viewmodel pulse position
//		scriptVector2.w : max distance to pulse.
	












	

	


 // Must  be smaller than VISION_PULSE_REVEAL_TIME
	
	// How far from 0 ( start )  - 1 ( end ) it takes for it to ramp in all the way
	// How far from VISION_PULSE_FADE_RAMP_IN ( start )  - 1 ( end ) it takes for it to ramp out all the way
	


	// Name of the visionset file
	// alias in script
	// priority vs other visionsets
	// number of steps when ramping in/out
	// activation ramp-in time
	// How long to hold after ramp-in is done and before ramping-out
	// deactivation ramp-out time
	
// Ramp in + ramp out + ramp hold == VISION_PULSE_DURATION + VISION_PULSE_REVEAL_TIME
