#include maps\_vehicle_aianim;
#include maps\_vehicle;
#include maps\_utility;
#using_animtree( "vehicles" );

main( model, type, classname )
{
	build_template( "m1a1", model, type, classname );
	build_localinit( ::init_local );
	build_deathmodel( "vehicle_m1a1_abrams_viewmodel", "vehicle_m1a1_abrams_minigun_destroy", undefined, "script_vehicle_m1a1_abrams_minigun" );
	build_deathmodel( "vehicle_m1a1_abrams_minigun", "vehicle_m1a1_abrams_minigun_destroy", undefined, "script_vehicle_m1a1_abrams_minigun" );
	build_deathmodel( "vehicle_m1a1_abrams_viewmodel", "vehicle_m1a1_abrams_minigun_destroy", undefined, "script_vehicle_m1a1_abrams_player_tm" );
	build_shoot_shock( "tankblast" );
	build_drive( %abrams_movement, %abrams_movement_backwards, 10 );
	build_exhaust( "distortion/abrams_exhaust" );
	build_deckdust( "dust/abrams_deck_dust" );
	build_deathfx( "explosions/vehicle_explosion_m1a1", 			"tag_deathfx", 			"exp_armor_vehicle", 		undefined, 			undefined, 		undefined, 		0, undefined, undefined, undefined, 10 );
	build_Turret( "m1a1_coaxial_mg", "tag_coax_mg", "vehicle_m1a1_abrams_PKT_Coaxial_MG_woodland", undefined, undefined, undefined, 0, 0 );
	build_turret( "minigun_m1a1", "tag_turret_mg_r", "weapon_m1a1_minigun", undefined, "sentry", undefined, 0, 0 );
	build_treadfx();
	build_life( 999, 500, 1500 );
	build_rumble( "tank_rumble", 0.15, 4.5, 900, 1, 1 );
	build_team( "allies" );
	build_mainturret();
	build_aianims( ::setanims, ::set_vehicle_anims );
	build_frontarmor( .33 );// regens this much of the damage from attacks to the front
}

init_local()
{
	waittillframeend; //let riders be defined;
	foreach( rider in self.riders )
	{
		rider thread magic_bullet_shield( true );
	}
}

#using_animtree( "vehicles" );
set_vehicle_anims( positions )
{
	//loaderText
	this_position = 0;
	positions[ this_position ].vehicle_turret_fire = %abrams_loader_shell;
	return positions;
}

//level.hero_tank.riders[0] linkto( level.hero_tank, "tag_turret_mg_r", (0,0,-38),(0,0,0) )
#using_animtree( "generic_human" );

setanims()
{
	positions = [];
	//gunner
	this_position = 0;
	position = spawnstruct();
	position.idle = %hamburg_tank_loader_afterfall_loop;
	position.turret_fire = %abrams_loader_load;
	position.turret_fire_tag = "tag_guy1";
	position.sittag = "tag_guy0";
	positions[ this_position ] = position;

	//loader
	this_position = 1;
	position = spawnstruct();
	position.idle = %hamburg_tank_driver_afterfall_loop;
	position.sittag = "tag_guy0";
	positions[ this_position ] = position;
	
	//minigun guy
	this_position = 2;
	position = spawnstruct();
	position.mgturret = 1;// which of the turrets is this guy going to use
	position.passenger_2_turret_func = ::humvee_turret_guy_gettin_func;
	position.sittag = "tag_turret_mg_r";
	position.sittag_offset = (0,0,-40);
	positions[ this_position ] = position;

	return positions;
}

humvee_turret_guy_gettin_func( vehicle, guy, pos, turret )
{
	animation = %humvee_passenger_2_turret;
	guy animscripts\hummer_turret\common::guy_goes_directly_to_turret( vehicle, pos, turret, animation );	
}


/*QUAKED script_vehicle_m1a1_abrams_minigun (1 0 0) (-16 -16 -24) (16 16 32) USABLE SPAWNER

You will need to include the asset in your map called misc_turret_m1a1_minigun

This will be added to your precache script when compile with Repackage Zone/Script:

vehicle_scripts\_m1a1_minigun::main( "vehicle_m1a1_abrams_minigun", undefined, "script_vehicle_m1a1_abrams_minigun" );

These will be added to your levels CSV when compile with Repackage Zone/Script:

include,vehicle_m1a1_abrams_minigun
sound,vehicle_abrams,vehicle_standard,all_sp


defaultmdl="vehicle_m1a1_abrams_minigun"
default:"vehicletype" "m1a1"
default:"script_team" "allies"
*/


/*QUAKED script_vehicle_m1a1_abrams_player_tm (1 0 0) (-16 -16 -24) (16 16 32) USABLE SPAWNER

This will be added to your precache script when compile with Repackage Zone/Script:

vehicle_scripts\_m1a1_minigun::main( "vehicle_m1a1_abrams_viewmodel", "m1a1_player_tm", "script_vehicle_m1a1_abrams_player_tm" );

These will be added to your levels CSV when compile with Repackage Zone/Script:

include,vehicle_m1a1_abrams_m1a1_player_tm
sound,vehicle_abrams,vehicle_standard,all_sp
sound,vehicle_abrams_commander,vehicle_standard,all_sp
sound,weapon_minigun,vehicle_standard,all_sp

defaultmdl="vehicle_m1a1_abrams_viewmodel"
default:"vehicletype" "m1a1_player_tm"
default:"script_team" "allies"
*/

/*QUAKED misc_turret_m1a1_minigun (1 0 0) (-16 -16 0) (16 16 56) pre-placed
Spawn Flags:
	pre-placed - Means it already exists in map.  Used by script only.

Key Pairs:
	leftarc - horizonal left fire arc.
	rightarc - horizonal left fire arc.
	toparc - vertical top fire arc.
	bottomarc - vertical bottom fire arc.
	yawconvergencetime - time (in seconds) to converge horizontally to target.
	pitchconvergencetime - time (in seconds) to converge vertically to target.
	suppressionTime - time (in seconds) that the turret will suppress a target hidden behind cover
	maxrange - maximum firing/sight range.
	aiSpread - spread of the bullets out of the muzzle in degrees when used by the AI
	playerSpread - spread of the bullets out of the muzzle in degrees when used by the player
	defaultmdl="weapon_m1a1_minigun"
	default:"weaponinfo" "minigun_m1a1"
	default:"targetname" "delete_on_load"
*/

