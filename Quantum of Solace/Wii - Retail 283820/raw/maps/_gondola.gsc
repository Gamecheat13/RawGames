#include maps\_vehicle_aianim;
#include maps\_vehicle;

#using_animtree ("vehicles");

main(model, type)
{
	if (!IsDefined(model))
	{
		model = "v_gondola";
	}
	
	build_template("gondola", model, type);
	
	build_localinit(::init_local);
		
	
	
	
	
	
	
	build_life(999, 500, 1500);
	
	build_team("allies");
	build_aianims(::setanims , ::set_vehicle_anims);
}

init_local()
{	
}

set_vehicle_anims(positions)
{
	return positions;
}


#using_animtree ("generic_human");

setanims ()
{
	positions = [];
	return positions;
}