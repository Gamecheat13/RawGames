init()
{
	// Scriptmovers
	level.const_flag_rocket_fx = 1;
	level.const_flag_missile_swarm = 1;
	level.const_flag_tactical_insertion = 2;
	level.const_flag_warn_targeted = 3;  // HELICOPTER AS WELL. NEEDS TO MATCH.
	level.const_flag_warn_locked = 4;		// HELICOPTER AS WELL. NEEDS TO MATCH.	
	level.const_flag_warn_fired = 5; 		// HELICOPTER AS WELL. NEEDS TO MATCH.
	level.const_flag_flag_away = 6;
	level.const_flag_stunned = 9;
	level.const_flag_camera_spike = 10;
	level.const_flag_counteruav = 11;
	level.const_flag_destructible_car = 12;
	level.const_flag_riotshield_deploy = 13;
	level.const_flag_riotshield_destroy = 14;
	level.const_flag_emp = 15;
	
	
	// Missiles
	level.const_flag_scrambler = 3;
	level.const_flag_proximity = 4;
	level.const_flag_stunned = 9;
	level.const_flag_emp = 15;
	
	// Helicopters
	level.const_flag_warn_targeted = 3; // SCRIPTMOVER AS WELL. NEEDS TO MATCH.
	level.const_flag_warn_locked = 4; // SCRIPTMOVER AS WELL. NEEDS TO MATCH.
	level.const_flag_warn_fired = 5; // SCRIPTMOVER AS WELL. NEEDS TO MATCH.
	
	// Vehicles
	level.const_flag_countdown = 1;
	level.const_flag_timeout = 2;
	level.const_flag_stunned = 9;
	level.const_flag_emp = 15;
	
	// Players
	level.const_flag_ctfcarrier = 0;
	level.const_flag_operatingreaper = 1;
	level.const_flag_operatingpredator = 2;
	level.const_flag_operatingchoppergunner = 3;
	level.const_flag_laseractive = 13;
	level.const_flag_drawhudoutlinegreen = 14;
	level.const_flag_drawhudoutlinered = 15;
	
	// Planes
	level.const_flag_bombing = 1;
	level.const_flag_airstrike = 2;
	level.const_flag_napalm = 3;
}
