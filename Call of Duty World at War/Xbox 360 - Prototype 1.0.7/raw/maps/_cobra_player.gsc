#include maps\_vehicle_aianim;
#using_animtree ("vehicles");
main(model,type)
{
	if(!isdefined(type))
		type = "cobra_player";
	level.vehicleInitThread[type][model] = ::init_local;
	
	maps\_cobra::setParams( model, type );
}

init_local()
{
	self.delete_on_death = true;
	self.script_badplace = false; //All helicopters dont need to create bad places
	self thread maps\_vehicle::helicopter_dust_kickup();
}