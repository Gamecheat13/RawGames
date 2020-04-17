#include maps\_vehicle_aianim;
#using_animtree ("tank");
main(model,type)
{
	if(!isdefined(type))
		type = "camera";
	level.vehicleInitThread[type][model] = ::init_local;

	deathfx = undefined;
	switch(model)	
	{
		
		case "vehicle_camera":
			precachemodel("vehicle_camera");
			precachemodel("vehicle_camera");
			level.vehicle_deathmodel[model] = "vehicle_camera";

			break;
	}
	precachevehicle(type);
	




	
	level.vehicle_death_fx[type] = [];
	


	





	
	


	
	



	
	
	

	
	level.vehicle_life[type] = 999;
	level.vehicle_life_range_low[type] = 500;
	level.vehicle_life_range_high[type] = 1500;
	
	
	

	
	


	
	level.vehicle_team[type] = "axis";	
	
	
	level.vehicle_hasMainTurret[model] = false;
	
	

	
	

	


	
	

	
	


}

init_local()
{
}

#using_animtree ("tank");
set_vehicle_anims(positions)
{
	
	return positions;
}


#using_animtree ("generic_human");

setanims ()
{
	positions = [];
	for(i=0;i<11;i++)
		positions[i] = spawnstruct();

	positions[0].getout_delete = true;


	return positions;
}

