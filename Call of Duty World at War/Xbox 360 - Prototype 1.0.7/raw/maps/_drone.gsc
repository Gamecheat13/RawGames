#include maps\_utility;
init()
{
	if (!isdefined(level.traceHeight))
		level.traceHeight = 400;
	
	if (!isdefined(level.droneStepHeight))
		level.droneStepHeight = 100;
	
	//lookahead value - how far the character will lookahead for movement direction
	//larger number makes smother, more linear travel. small value makes character go almost exactly point to point
	if (!isdefined(level.lookAhead_value))
		level.civilian_lookAhead_value = 200;
	
	if(!isdefined(level.max_drones))
		level.max_drones = [];
	if(!isdefined(level.max_drones["allies"]))
		level.max_drones["allies"] = 99999;
	if(!isdefined(level.max_drones["axis"]))
		level.max_drones["axis"] = 99999;
	if(!isdefined(level.max_drones["civilian"]))
		level.max_drones["civilian"] = 99999;

	if(!isdefined(level.drones))
		level.drones = [];
	if(!isdefined(level.drones["allies"]))
		level.drones["allies"] = struct_arrayspawn();
	if(!isdefined(level.drones["axis"]))
		level.drones["axis"] = struct_arrayspawn();
	if(!isdefined(level.drones["civilian"]))
		level.drones["civilian"] = struct_arrayspawn();
}