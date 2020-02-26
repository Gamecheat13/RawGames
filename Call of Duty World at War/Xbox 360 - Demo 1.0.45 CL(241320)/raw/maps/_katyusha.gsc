// _katyusha.gsc
// Sets up the behavior for Russian Katyusha rocket truck.

#include maps\_vehicle_aianim;
#include maps\_vehicle;
#include maps\_utility;

#using_animtree( "vehicles" );
main( model, type )
{
	build_template( "katyusha", model, type );
	build_localinit( ::init_local );
	build_deathmodel( "vehicle_opel_blitz_woodland", "vehicle_opel_blitz_woodland_d" );
	build_deathfx( "explosions/large_vehicle_explosion", undefined, "explo_metal_rand" );
	build_exhaust( "vehicle/exhaust/fx_exhaust_rus_rocket_truck" );
	build_treadfx( type );
	build_life( 999, 500, 1500 );
	build_team( "allies" );
	
	build_aianims( ::setanims , ::set_vehicle_anims );
	build_unload_groups( ::Unload_Groups );


// SCRIPTER_MOD: JesseS (5/12/2007) - Took out lights
// TODO: Re-add sick lights!
	//build_light( model, "headlight_truck_left", 		"tag_headlight_left", 		"misc/car_headlight_truck_L", 		"headlights" );
	//build_light( model, "headlight_truck_right", 		"tag_headlight_right", 		"misc/car_headlight_truck_R", 		"headlights" );
	//build_light( model, "parkinglight_truck_left_f",	"tag_parkinglight_left_f", 	"misc/car_parkinglight_truck_LF", 	"headlights" );
	//build_light( model, "parkinglight_truck_right_f", 	"tag_parkinglight_right_f", "misc/car_parkinglight_truck_RF",	"headlights" );
	//build_light( model, "taillight_truck_right",	 	"tag_taillight_right", 		"misc/car_taillight_truck_R", 		"headlights" );
	//build_light( model, "taillight_truck_left",		 	"tag_taillight_left", 		"misc/car_taillight_truck_L", 		"headlights" );

	//build_light( model, "brakelight_truck_right", 		"tag_taillight_right", 		"misc/car_brakelight_truck_R", 		"brakelights" );
	//build_light( model, "brakelight_truck_left", 		"tag_taillight_left", 		"misc/car_brakelight_truck_L", 		"brakelights" );

}

init_local()
{
//	maps\_vehicle::lights_on( "headlights" );
//	maps\_vehicle::lights_on( "brakelights" );
}

set_vehicle_anims( positions )
{
	
	// SCRIPTER_MOD: JesseS (5/12/2007) - Took out anim references
//	positions[ 0 ].vehicle_getoutanim = %door_pickup_driver_climb_out;
//	positions[ 1 ].vehicle_getoutanim = %door_pickup_passenger_climb_out;
//	positions[ 2 ].vehicle_getoutanim = %door_pickup_passenger_RR_climb_out;
//	positions[ 3 ].vehicle_getoutanim = %door_pickup_passenger_RL_climb_out;
//
//	positions[ 0 ].vehicle_getinanim = %door_pickup_driver_climb_in;
//	positions[ 1 ].vehicle_getinanim = %door_pickup_passenger_climb_in;
	//positions[ 2 ].vehicle_getinanim = %door_pickup_driver_climb_in;
	//positions[ 3 ].vehicle_getinanim = %door_pickup_passenger_climb_in;
		return positions;

}


#using_animtree( "generic_human" );

setanims()
{
	positions = [];
	for( i=0;i<4;i++ )
		positions[ i ] = spawnstruct();

	//	positions[ 0 ].getout_delete = true;
	
	/*
	pickup_driver_climb_out
	pickup_passenger_climb_out
	pickup_passenger_RL_idle
	pickup_passenger_RL_climb_out
	pickup_passenger_RR_idle
	pickup_passenger_RR_climb_out
	technical_passenger_climb_out
	
	*/

	positions[ 0 ].sittag = "tag_driver";
	positions[ 1 ].sittag = "tag_passenger";	 
	positions[ 2 ].sittag = "tag_guy1"; //RR
	positions[ 3 ].sittag = "tag_guy2";  //RL

// SCRIPTER_MOD: JesseS (5/12/2007) - Took out anims
//	positions[ 0 ].idle = %technical_driver_idle;
//	positions[ 1 ].idle = %technical_passenger_idle;
//	positions[ 2 ].idle = %pickup_passenger_RR_idle;
//	positions[ 3 ].idle = %pickup_passenger_RL_idle;
//
//	positions[ 0 ].getout = %pickup_driver_climb_out;
//	positions[ 1 ].getout = %pickup_passenger_climb_out;
//	positions[ 2 ].getout = %pickup_passenger_RR_climb_out;
//	positions[ 3 ].getout = %pickup_passenger_RL_climb_out;
//
//	positions[ 0 ].getin = %pickup_driver_climb_in;
//	positions[ 1 ].getin = %pickup_passenger_climb_in;
	//positions[ 2 ].getin = %pickup_driver_climb_in;  //ghetto temp
	//positions[ 3 ].getin = %pickup_passenger_climb_in; //ghetto temp

	return positions;
}

unload_groups()
{
	unload_groups = [];
	unload_groups[ "passengers" ] = [];
	unload_groups[ "all" ] = [];

	group = "passengers";
	unload_groups[ group ][ unload_groups[ group ].size ] = 1;
	unload_groups[ group ][ unload_groups[ group ].size ] = 2;
	unload_groups[ group ][ unload_groups[ group ].size ] = 3;

	group = "all";
	unload_groups[ group ][ unload_groups[ group ].size ] = 0;
	unload_groups[ group ][ unload_groups[ group ].size ] = 1;
	unload_groups[ group ][ unload_groups[ group ].size ] = 2;
	unload_groups[ group ][ unload_groups[ group ].size ] = 3;

	unload_groups[ "default" ] = unload_groups[ "all" ];
	
	return unload_groups;
}


// SRS 11/01/07 - adding Terrebonne/MikeD steez w/ some tweaks
// self = the Katyusha vehicle
rocket_barrage( rocket_amount, targets, attack_range, dest_z_height )
{
	// SRS 4/9/2008: added ender
	self endon( "stop_rocket_barrage" );
	
	// SRS - allow default rocket amount, do a quick error check
	if( !IsDefined( rocket_amount ) || rocket_amount <= 0 )
	{
		rocket_amount = 8;
	}
	
	if( !IsDefined( attack_range ) )
	{
		attack_range = 1500;
	}

	if( !IsDefined( dest_z_height ) )
	{
		dest_z_height = 500;
	}

	tags = [];
	tags[0]  = "tag_rocket00";
	tags[1]  = "tag_rocket01";
	tags[2]  = "tag_rocket02";
	tags[3]  = "tag_rocket03";
	tags[4]  = "tag_rocket04";
	tags[5]  = "tag_rocket05";
	tags[6]  = "tag_rocket06";
	tags[7]  = "tag_rocket07";
	tags[8]  = "tag_rocket08";
	tags[9]  = "tag_rocket09";
	tags[10] = "tag_rocket10";
	tags[11] = "tag_rocket11";
	tags[12] = "tag_rocket12";
	tags[13] = "tag_rocket13";
	tags[14] = "tag_rocket14";
	tags[15] = "tag_rocket15";
	
	for( i = 0; i < rocket_amount; i++ )
	{
		if( IsDefined( targets ) )
		{
			n = i % targets.size;
			dest_point = targets[n].origin;
		}
		else
		{
			// get the angles forward relative to the direction the truck is facing plus an offset of +/- 40 units
			forward = AnglesToForward( self.angles + ( 0, 20 - RandomInt( 40 ), 0 ) );
			
			// the specified or default range plus an offset of +/- 150 units
			range = attack_range + ( 150 - RandomInt( 300 ) );
			
			dest_point = self.origin + vector_multiply( forward, range );			
			
			// Test for Z Height, due to elevation changes or buildings height at the rocket's impact point
			trace = BulletTrace( dest_point + ( 0, 0, dest_z_height ), dest_point + ( 0, 0, -2000 ), false, self );
			dest_point = trace["position"];
		}

		n = i % tags.size;
	
		while( !OkTospawn() )
		{
			wait( 0.1 ); 
		}
	
		rocket = Spawn( "script_model", self GetTagOrigin( tags[n] ) );
		rocket SetModel( "katyusha_rocket" );
		rocket.angles = self GetTagAngles( tags[n] );
		
		rocket PlaySound("katyusha_launch_rocket");
		PlayFxOnTag( level._effect["katyusha_rocket_launch"], rocket, "tag_fx" );
		PlayFxOnTag( level._effect["katyusha_rocket_trail"], rocket, "tag_fx" );

		// Kevin's sound of rocket flying through the air
		rocket playloopsound( "katy_rocket_run" );

		rocket thread fire_rocket( dest_point );
		
		// SRS - set a minimum wait time on these so they don't all fire off at once (potentially)
		//Kevin adjusted this to get the sound closer to the actuall salvo speed.
		wait( RandomFloatRange( 0.2, 0.25 ) );
	}
}

// self = the rocket model
fire_rocket( target_pos )
{
	start_pos = self.origin; // Get the start position
	
	///////// Math Section
	// Reverse the gravity so it's negative, you could change the gravity
	// by just putting a number in there, but if you keep the dvar, then the
	// user will see it change.
	gravity = GetDvarInt( "g_gravity" ) * -1;
	
	// Get the distance
	dist = Distance( start_pos, target_pos);
	
	// Figure out the time depending on how fast we are going to
	// throw the object... 300 changes the "strength" of the velocity.
	// 300 seems to be pretty good. To make it more lofty, lower the number.
	// To make it more of a b-line throw, increase the number.
	time = dist / 2000;
	
	// Get the delta between the 2 points.
	delta = target_pos - start_pos;
	
	// Here's the math I stole from the grenade code. :) First figure out
	// the drop we're going to need using gravity and time squared.
	drop = 0.5 * gravity * ( time * time );
	
	// Now figure out the trajectory to throw the object at in order to
	// hit our map, taking drop and time into account.
	velocity = ( ( delta[0] / time ), ( delta[1] / time ), ( delta[2] - drop ) / time );
	///////// End Math Section
	
	self MoveGravity( velocity, time );
	wait( time );
	
	self hide();
	//Kevin stopping the rocket looping sound after it explodes.
	self stoploopsound(.1);
	
	PlayFX( level._effect[ "katyusha_rocket_explosion" ], self.origin );
	radiusdamage(self.origin, 128, 300, 35);
	earthquake(0.3, 2, self.origin, 1024);
	
	wait .2;

	self Delete();
}
