#include maps\_vehicle_aianim;
#using_animtree ("vehicles");
main(model,type)
{
	if(!isdefined(type))
		type = "hind";
	maps\_blackhawk::main(model,type);  //piggy backing for now since they are identical

	level.vehicleInitThread[type][model] = ::init_local;


}

init_local()
{
	self.originheightoffset = 144;  //TODO-FIXME: this is ugly.
//	self.fastropeoffset = 760; //blackhawk
	self.fastropeoffset = 792;  //TODO-FIXME: this is ugly.
	self.delete_on_death = true;
	self.script_badplace = false; //All helicopters dont need to create bad places
}