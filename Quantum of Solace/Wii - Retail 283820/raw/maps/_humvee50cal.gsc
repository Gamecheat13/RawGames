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
	
	
	
	

	return positions;
}