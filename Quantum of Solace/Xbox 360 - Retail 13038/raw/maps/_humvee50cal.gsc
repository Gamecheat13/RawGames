#include maps\_vehicle_aianim;
main(model,type)
{
	if(!isdefined(type))
		type = "humvee50cal";
	maps\_humvee::main(model,type);
	level.vehicle_aianims[type] = setanims(type);
}
#using_animtree ("generic_human");
setanims(type)
{

	positions = level.vehicle_aianims[type];
	pos = positions.size;
	positions[pos] = spawnstruct();

	positions[pos].sittag = "tag_guy_turret";
	//PJL positions[pos].idle = %humvee_turret_idle;
	//PJL positions[pos].getout = %humvee_driver_climb_out;
	//PJL positions[pos].getin = %humvee_driver_climb_in;
	//PJL positions[pos].turret_fire = %humvee_turret_fire;

	return positions;
}