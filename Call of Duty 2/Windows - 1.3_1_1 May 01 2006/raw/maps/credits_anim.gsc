#include maps\_utility;
#include maps\_anim;
#include animscripts\utility;
#using_animtree("generic_human");
main()
{
	level.scr_anim["price"]["idle"][0]	 		= %german_idle;
	level.scr_anim["price"]["double"]			= %german_doublepunch;
	level.scr_anim["price"]["spit"]				= %german_gethit3;
	
	level.scr_anim["guard"]["idle"][0]			= %guard_idle;
	level.scr_anim["guard"]["double"] 			= %guard_doublepunch;
	level.scr_anim["guard"]["spit"] 			= %guard_wipeface;
	
	addNotetrack_sound("guard", "punch", "double", "moscow_fistfist");
	addNotetrack_sound("guard", "punch", "double", "melee_hit");


	level.scr_anim["soldier"]["barndoor"]		= %breakout_barngate_open_guy;
	level.scr_anim["soldier"]["setupladder"]	= %toujane_ladder_kick_guy2;
	level.scr_anim["soldier"]["kick_door"]		= %duhoc_kickdoor; //%chateau_kickdoor1;
	addNotetrack_customFunction("soldier", "fire", ::shootGun, "kick_door");
	addNotetrack_customFunction("soldier", "kick", ::doorKick, "kick_door");

	level.scr_anim["waveGuy"]["wave2run"]		= %credits_wave_run; //%crossroads_letsgo_wave2run;
	level.scr_anim["surrenderGuy"]["idle"][0]	= %beltot_german_surrendering_loop;
	level.scr_anim["surrenderGuy"]["surrender"]	= %beltot_german_surrendering_loop;
	level.scr_anim["surrenderGuy"]["pistol_pull"] = %pistol_boltaction_toss_struggle;
	
	level.scr_anim["dragger"]["drag_start"]		= %demolition_trench_dragend_idle;
	
	level.scr_anim["grenade_stand"]			["grenade_throw"] = %stand_grenade_throw;
	addNotetrack_attach("grenade_stand", "grenade_right", "xmodel/weapon_us_smoke_grenade", "TAG_WEAPON_RIGHT", "grenade_throw");
	addNotetrack_detach("grenade_stand", "fire", "xmodel/weapon_us_smoke_grenade", "TAG_WEAPON_RIGHT", "grenade_throw");
	addNotetrack_customFunction("grenade_stand", "fire", maps\credits::smokeThrow);

	level.scr_anim["grenade_corner_crouch"]	["grenade_throw"] = %corner_right_crouch_alertgrenaderight;
	addNotetrack_attach("grenade_corner_crouch", "grenade_right", "xmodel/weapon_us_smoke_grenade", "TAG_WEAPON_RIGHT", "grenade_throw");
	addNotetrack_detach("grenade_corner_crouch", "fire", "xmodel/weapon_us_smoke_grenade", "TAG_WEAPON_RIGHT", "grenade_throw");
	addNotetrack_customFunction("grenade_corner_crouch", "fire", maps\credits::smokeThrow);

	level.scr_anim["grenade_corner_stand"]	["grenade_throw"] = %corner_right_stand_alertgrenaderight;
	addNotetrack_attach("grenade_corner_stand", "grenade_right", "xmodel/weapon_us_smoke_grenade", "TAG_WEAPON_RIGHT", "grenade_throw");
	addNotetrack_detach("grenade_corner_stand", "fire", "xmodel/weapon_us_smoke_grenade", "TAG_WEAPON_RIGHT", "grenade_throw");
	addNotetrack_customFunction("grenade_corner_stand", "fire", maps\credits::smokeThrow);
	
	level.scrsound["generic"]["cough"] 			= "coughing";
	level.scrsound["grenade_corner_crouch"]["call_for_smoke"]	= "credits_smoke";

	level.scr_anim["stairguy"]["jumpdown"]		= %demolition_hall_shout;	
	
	level.scr_anim["gunner"]["alive_idle"][0]			= %toujane_german_armored_car_basic_idle;
	level.scr_anim["gunner"]["death"]					= %toujane_german_armored_car_death;
	level.scr_anim["gunner"]["death_idle"][0]			= %toujane_german_armored_car_death_pose;
	level.scr_anim["gunner"]["grab"]					= %toujane_german_armored_car_grab;
	level.scr_anim["gunner"]["deathPose"][0]			= %toujane_german_armored_car_death_end_pose;
	
	level.scr_anim["price"]["getin"]					= %toujane_mgreg_armored_car_getin;
	level.scr_anim["ender"]["getin"]					= %toujane_price_armored_car_getin;
	level.scr_anim["ender"]["getinEnd"]					= %toujane_price_armored_car_end_getin;
	level.scr_anim["ender"]["sitIdle"][0]				= %toujane_price_armored_car_idle;
	addNotetrack_customFunction("ender", "grab", maps\credits::priceGrabsGunner);

	level.scr_anim["german"]["truck"]					= (%beltot_truckscene_checktruck_guy);

	//wounded guy gets carried by a medic
	level.scr_anim["price"]["walk"]					= %credits_wounded_carrier_walk;
	level.scr_anim["ender"]["walk"]					= %credits_wounded_carried_walk;

	level.scr_anim["ending_guy"]["cheer_crouch"]	= %decoy_town_cheer_crouch;
	level.scr_anim["ending_guy"]["cheer_stand"]		= %decoy_town_cheer_stand;
}

DoorKick(guy)
{
	door = getent ("town_door","targetname");
	door connectpaths();
	door rotateyaw(-85,1,0.1,0.8);
	door playsound ("wood_door_kick");
	wait (4);
	door delete(); // blocks camera shot later
}

shootGun(guy)
{
	guy shoot();
}


#using_animtree( "vehicles" );
armored_car_openHatch()
{
	self UseAnimTree(#animtree);
	self setAnim( %armoredcar_hatch_open_pose );
}

#using_animtree("germantruck");
anim_truck_door()
{
	self useanimtree (#animtree);
	self setanim(%beltot_truckscene_checktruck_truck);
	wait 6.3;
//	playsoundinspace ("truck_door_open", self gettagorigin("tag_driver"));
	wait 10.1;
//	playsoundinspace ("car_door_close", self gettagorigin("tag_driver"));
}


#using_animtree("toujane_wall_tank_collapse");
breakwall()
{
	breakwall = getent ("tank_wall","targetname");
	breakwall UseAnimTree(#animtree);
	
	breakwall setmodel ("xmodel/wall_tank_pieces");
	breakwall setflaggedanim("wall done", %wall_tank_collapse);
	breakwall playsound ("wall_crumble");
//	exploder(0);
	breakwall waittill ("wall done");
	breakwall setmodel ("xmodel/wall_tank_broke");
}
