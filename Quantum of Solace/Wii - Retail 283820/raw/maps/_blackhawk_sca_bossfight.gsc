#include maps\_vehicle_aianim;
#using_animtree ("vehicles");
main()
{
	model = "v_heli_sca_red";
	type  = "blackhawk_sca_bossfight";

	level.vehicleInitThread[type][model] = ::init_local;

	deathfx = undefined;

	precachemodel(model);
	level.vehicle_deathmodel[model] = model;

	precachevehicle(type);

	level.vehicleanimtree[model] = #animtree;
	level.vehicle_DriveIdle[model] = %bh_rotors;
	level.vehicle_DriveIdle_normal_speed[model] = 0;  

	
	
	
	level.vehicle_searchlight_fx[type] = Loadfx( "maps/miamisciencecenter/science_copter_searchlite" );
	level.vehicle_tailrotor_light_fx[type] = Loadfx( "maps/miamisciencecenter/science_copter_steady_white" );
	level.vehicle_rightwing_light_fx[type] = Loadfx( "maps/miamisciencecenter/science_copter_blink_red" );
	level.vehicle_leftwing_light_fx[type] = Loadfx( "maps/miamisciencecenter/science_copter_blink_green" );

	
	level.vehicle_life[type] = 999;
	level.vehicle_life_range_low[type] = 500;
	level.vehicle_life_range_high[type] = 1500;

	
	level.vehicle_team[type] = "allies";	

	
	level.vehicle_hasMainTurret[model] = false;
}

init_local()
{
	self.originheightoffset = distance(self gettagorigin("tag_origin"), self gettagorigin("tag_ground"));  
	self.fastropeoffset = 762; 

	self.script_badplace = false; 
}

#using_animtree ("vehicles");
set_vehicle_anims(positions)
{
	for(i=0;i<positions.size;i++)
		positions[i].vehicle_getoutanim = %bh_idle;

	return positions;
}

#using_animtree ("generic_human");
setanims()
{                 
}                                             


unload_groups()
{
}

set_attached_models()
{
}