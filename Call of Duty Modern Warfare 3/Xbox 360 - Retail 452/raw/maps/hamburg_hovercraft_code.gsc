#include maps\_utility;
#include common_scripts\utility;
#include maps\_anim;
#include maps\_vehicle;
#include maps\hamburg_code;
#include maps\hamburg_tank_ai;

#using_animtree( "vehicles" );

ORIGIN_ZERO = ( 0, 0, 0 );
reference_vehicles_to_hovercraft( tank1, tank2 )
{
	reference_tank_1 = tank1 vehicle_to_dummy();
	reference_tank_2 = tank2 vehicle_to_dummy();
	
	tank1.dummyspeed = 6;
	tank2.dummyspeed = 6;
	
	reference_tank_1 UseAnimTree(#animtree );
	reference_tank_2 UseAnimTree(#animtree );
	
	reference_tank_1 ThermalDrawEnable();
	reference_tank_2 ThermalDrawEnable();

	if( issubstr ( reference_tank_1.model, "viewmodel" ) )
		reference_tank_1 SetModel( "vehicle_m1a1_abrams_viewmodel_tread_stop" );
	else
		reference_tank_1 SetModel( "vehicle_m1a1_abrams_minigun_tread_stop" );

	if( issubstr ( reference_tank_2.model, "viewmodel" ) )
		reference_tank_2 SetModel( "vehicle_m1a1_abrams_viewmodel_tread_stop" );
	else
		reference_tank_2 SetModel( "vehicle_m1a1_abrams_minigun_tread_stop" );

	reference_tank_1 LinkTo( self, "TAG_TANK_BACK", ORIGIN_ZERO, ORIGIN_ZERO );	
	reference_tank_2 LinkTo( self, "TAG_TANK_FORWARD", ORIGIN_ZERO, ORIGIN_ZERO );	
	
	self.hovercrafts_exiting = 2;
	thread hovercraft_exit_tank( "hovercraft_tank_back_exit", "TAG_TANK_BACK", tank1 );
	thread hovercraft_exit_tank( "hovercraft_tank_forward_exit", "TAG_TANK_FORWARD", tank2 );
}

hovercraft_exit_tank( animation, tag, tank )
{
	god_was_on = IsDefined( tank.godmode ) && tank.godmode;
	tank godon();

	self ent_flag_wait( "hovercraft_unload" );
	
	SetSavedDvar( "ui_hideMap", "0" );

	dummy = tank get_dummy();
	dummy SetModel ( tank.model ); // turns the treads back on

	lookedup_anim = getanim_generic( animation );
	animtime = getanimlength( lookedup_anim );
	//dummy SetAnim( lookedup_anim );
	self thread anim_generic( dummy, animation, tag );
	wait animtime - 0.05;
	dummy Unlink();
	dummy StopAnimScripted();
	
	tank maps\_vehicle::move_truck_junk_here( tank );

	speed = 176;
	if ( IsDefined( tank.currentnode ) )
	{
		speed = tank.currentnode.speed;
	}
	else if ( IsDefined( tank.attachedpath ) )
	{
		speed = tank.attachedpath.speed;
	}
	
	dummy move_with_rate( tank.origin, tank.angles, speed );
	
	tank dummy_to_vehicle();

	if( ! god_was_on )
		tank godoff();
		
	tank.teleported_to_path_section = true; // don't do teleporting.
	tank do_path_section( tank.attachedpath.targetname );
	
	tank thread turret_attack_think_hamburg();
	tank notify ( "exited_hovercraft" );
	hovercraft_minus_one_tank();
}

hovercraft_minus_one_tank()
{
	self.hovercrafts_exiting--;
	if ( ! self.hovercrafts_exiting )
	{
		self notify ( "tanks_exited" );
	}
}

hovercraft_do_other_tank( hovercraft_targetname, tank1_targetname, tank2_targetname )
{
	tank1 = spawn_vehicle_from_targetname( tank1_targetname );
	tank2 = spawn_vehicle_from_targetname( tank2_targetname );
	
	add_cleanup_ent( tank1, tank1_targetname );
	add_cleanup_ent( tank2, tank2_targetname );

	tank1 godon();
	tank2 godon();
	
	hovercraft = spawn_vehicle_from_targetname_and_drive( hovercraft_targetname );
	hovercraft hovercraft_init();
	
	hovercraft godon();
	hovercraft reference_vehicles_to_hovercraft( tank1, tank2 );
	
	hovercraft vehicle_setspeed( 0, 100);
	hovercraft resumespeed( 100 );

}

hovercraft_do_other_tank_friend( hovercraft_targetname )
{
	tank2 = level.hero_tank;
	
	other_tank_end_path = GetVehicleNode( "friend_path_off_hovercraft", "targetname" );
	tank2.attachedpath = other_tank_end_path;
	tank2 AttachPath( other_tank_end_path );
	
	other_tank_end_path = GetVehicleNode( "craft_2_tank1_path_one", "targetname" );
	level.glory_tank.attachedpath = other_tank_end_path;
	level.glory_tank AttachPath( other_tank_end_path );
	
	//tank1 godon();
	tank2 godon();
	hovercraft = spawn_vehicle_from_targetname_and_drive( hovercraft_targetname );
	hovercraft hovercraft_init();

	hovercraft godon();
	hovercraft reference_vehicles_to_hovercraft( level.glory_tank, tank2 );
}

hovercraft_init()
{
	self ent_flag_init( "hovercraft_unload" );
	self ent_flag_init( "hovercraft_unloaded" );

	self SetAnim( %hovercraft_rocking );
	self thread hovercraft_unload();
}

hovercraft_unload()
{
	self ent_flag_wait( "hovercraft_unload" );

	self ClearAnim( %hovercraft_rocking, 1 );
	anim_length = getanimlength( %lcac_deflate );
	timer = GetTime();

	self SetAnim( %lcac_deflate );
	
	self waittill ( "tanks_exited" );

	// Make sure teh deflate anim is done before continuing
	wait_for_buffer_time_to_pass( timer, anim_length );

	self ent_flag_set( "hovercraft_unloaded" );
	self.script_vehicle_selfremove = true;
}