#include common_scripts\utility;
#include maps\_utility;
#include maps\_shg_fx;
#include maps\_audio;



main()
{
	thread precachefx();
	
	//Exploder nums
	//101 = shanty 01 death fx
	//102 = falling debris on mortar run first hut destruction
	//105 = spreading fire in the player mortar section
	
	//FX Zone flags
	flag_init("fx_zone1");
	flag_init("fx_zone2");
	flag_init("fx_zone3");
	flag_init("fx_zone4");
	flag_init("fx_zone5");
	flag_init("fx_zone6");
	flag_init("fx_zone7");
	flag_init("fx_technical_splash");
	
	flag_init("msg_fx_stop_rain");
	flag_init( "river_allies_stand" );
	
	flag_init( "msg_scaleshadow" );

	thread manage_dof();

	thread fx_zone_watcher(1000,"fx_zone_1000");//beginning river section
	thread fx_zone_watcher(2000,"fx_zone_2000");//river section after wading
	thread fx_zone_watcher(3000,"fx_zone_3000");//river section after the bridge takedown
	thread fx_zone_watcher(5000,"fx_zone_5000","fx_zone_5001");//overwatch shanty town section
	thread fx_zone_watcher(6000,"fx_zone_6000");//section between overwatch and shanty town (the advance)
	thread fx_zone_watcher(7000,"fx_zone_7000");//technical shantytown section
	thread fx_zone_watcher(8000,"fx_zone_8000");//mortar run & player mortor
	thread fx_zone_watcher(9000,"fx_zone_9000","fx_zone_9001");//sewer pipe and lower main town
	thread fx_zone_watcher(10000,"fx_zone_10000");//upper main town and church
	
	thread fx_stop_rain();//stop rain after intro area
	thread treadfx_override();
	thread treadfx_override_heli();
	thread truck_deathfx_override();
	thread fx_technical_splash();
	
	thread convertoneshot();
	//thread fx_zone5_watcher();
	//enable this line for correct vision in createfx BESURE TO DISABLE
	//thread maps\_utility::vision_set_fog_changes( "af_caves_indoors_steamroom", 0 );
	
	footStepEffects();
	
	//set alpha threshold
	thread set_default_dvars();
	
	//River threads
	thread play_oneshot_dragonflies();
	
	//Mortar threads
	thread set_off_falling_debris();
	thread set_off_spreading_fire();
	
	// warlord geo
	thread shanty_brush_destruct("shanty_55",400);
	
	// sniper_script
	thread shanty_brush_destruct("shanty_bldg_58",0,true);
	
	// advance geo
	thread shanty_mortar_destruct( "shanty_4" );
	thread shanty_mortar_destruct( "shanty_4c" );
	thread shanty_mortar_destruct( "shanty_4edeck" );
	thread shanty_mortar_destruct( "shanty_4edeck2" );
	thread shanty_mortar_destruct( "shanty_4etop" );
	thread shanty_mortar_destruct( "shanty_39" );
	thread shanty_mortar_destruct( "shanty_45" );
	thread shanty_mortar_destruct( "shanty_45_blocker", false, true );
	thread shanty_mortar_destruct( "shanty_47" );
	thread shanty_mortar_destruct( "shanty_60" );
	
	// mortar geo
	thread shanty_brush_destruct("shanty_01a",0,true);
	thread shanty_mortar_destruct( "shanty_4b" );
	thread shanty_mortar_destruct( "shanty_4b_02", true );
	
	//thread fx_africa_dustrunners_zone(150,9,"fx_zone_1000","fx_zone_2000");
	//thread fx_africa_dustrunners_zone(250,3,"fx_zone_2000","fx_zone_3000");
	//thread fx_africa_dustrunners_zone(350,3,"fx_zone_3000");
	//thread fx_africa_dustrunners_zone(550,7,"fx_zone_5000","fx_zone_5001");

	maps\createfx\warlord_fx::main();
	setup_shg_fx();
	thread shadow_scale_mortar();
	
	//fx pause
}

set_default_dvars()
{
	setsaveddvar("fx_alphathreshold",9);
}


water_emerge_vfx()
{
	PauseFXID("amb_dust_verylight_cheap");
	PauseFXID("amb_dust_verylight_small");
	PauseFXID("leaves_fall_tropical");
	thread setup_poison_wake_volumes();
	wait(1.0);
	level.player SetWaterSheeting( 1, 2.5 );
	wait(2.0);
	if(isdefined(level.soap)) playfxontag( getfx( "water_emerge" ), level.soap, "J_Neck" );
	wait(1.0);
	if(isdefined(level.price)) playfxontag( getfx( "water_emerge_2" ), level.price, "J_Neck" );
	wait(0.3);
	exploder(59);
	wait(1.2);
	if(isdefined(level.soap.weapon)) playfxontag( getfx( "water_emerge_weapon" ), level.soap, "TAG_FLASH" );
	wait(1.3);
	exploder(58);
	wait(0.9);
	if(isdefined(level.price.weapon)) playfxontag( getfx( "water_emerge_weapon" ), level.price, "TAG_FLASH" );
	RestartFXID("leaves_fall_tropical");
	wait(14.3);
	//RestartFXID("amb_dust_verylight_cheap");
	RestartFXID("amb_dust_verylight_small");
	//iprintlnbold("water drops");
	if(isdefined(level.soap)) playfxontag( getfx( "water_emerge_3" ), level.soap, "J_Neck" );
	wait(1.0);
	if(isdefined(level.price)) playfxontag( getfx( "water_emerge_4" ), level.price, "J_Neck" );
}

intro_player_drips_vfx(player_weapon,player_rig)
{
	wait(1.0);
	if(isdefined(player_weapon)) playfxontag( getfx( "water_emerge_player_weapon" ), player_weapon, "TAG_FLASH" );
	if(isdefined(player_rig)) playfxontag( getfx( "water_emerge_player_hand" ), player_rig, "J_Wrist_RI" );
}

playSuperTechnicalFX()
{
	playfxontag(getfx("tread_smk_road_suptech_back"),self,"tag_wheel_back_left");
	playfxontag(getfx("tread_smk_road_suptech_back"),self,"tag_wheel_back_right");
	self waittill("death");
	stopfxontag(getfx("tread_smk_road_suptech_back"),self,"tag_wheel_back_left");
	stopfxontag(getfx("tread_smk_road_suptech_back"),self,"tag_wheel_back_right");
}

set_off_falling_debris()
{
	level waittill("exploding_shanty_shanty_4b_02");
	wait(1.5);
	//print("exploding");
	exploder(104);
}

set_off_spreading_fire()
{
	level waittill("exploding_shanty_shanty_4etop");
	exploder(105);
}

do_mortar_shake()
{
	thread screenshake(.25,0.9,.1,.4);
	setblur(3, 0.125);
	wait .35;
	setblur(0, 0.2);	
}

get_ordered_trigs(shanty,trigs)
{
	ret_val = [];
	foreach(curr in shanty)
	{
		shanty_pos = curr.origin;
		dist = 10000;
		closest = undefined;
		foreach(trig in trigs)
		{
			curr_dist = distance(trig.origin , shanty_pos);
			if( curr_dist < dist)
			{
				closest = trig;
				dist = curr_dist;
			}
		}
		ret_val[ret_val.size]= closest;
	}
	return ret_val;
}

get_shanty_parts(shanty, shanty_name, part_radius)
{
	//Find closest script models matching the shanty name & associate them
	//with this shanty
	all_shanty_parts = getentarray(shanty_name+"_part","targetname");
	shanty_parts = [];
	if(!isdefined(all_shanty_parts)) return undefined;
	foreach(curr in all_shanty_parts)
	{
		if( distance(shanty.origin,curr.origin) < part_radius )
		{
			shanty_parts[shanty_parts.size] = curr;
		}
	}
	return shanty_parts;
}

shanty_dest_manager(shanty,trig,shanty_name, part_radius, shanty_state, shanty_origin, viewshake )
{
	parts = get_shanty_parts(shanty, shanty_name, part_radius);
	if(isdefined(shanty_state)) shanty_state hide();
	fxorigin = shanty.origin;
	fxangles = shanty.angles;

	for(;;)
	{
		curr_dmg_trig = trig;
		//wait till damage trigger is activated
		curr_dmg_trig waittill( "trigger" );
		level notify("exploding_shanty_"+shanty_name);
		playfx(getfx((shanty_name+"_death")),fxorigin,(0,0,1));
		PhysicsExplosionSphere( fxorigin, 400, 100, .1 );
		if(isdefined(shanty_origin) || !isdefined(shanty))
		{
			fxorigin = shanty_origin.origin;
			fxangles = shanty_origin.angles;
		}
		playfx(getfx((shanty_name+"_dest")),fxorigin,anglestoforward(fxangles));
		if(isdefined(curr_dmg_trig)) curr_dmg_trig delete();
		level waitframe();
		if(isdefined(shanty)) shanty delete();
		if(isdefined(shanty_state)) shanty_state show();
		if(isdefined(parts))
		{
			foreach(curr_part in parts)
			{
				if(isdefined(curr_part)) curr_part delete();
			}
		}
		if(viewshake == true)
		{
					thread screenshake(.25,0.9,.1,.4);
					setblur(.5, 0.125);
					wait .5;
					setblur(0, 0.2);	
		}
		return 0;
	}
}

find_unique_shanty_ent( shanty_name, shanty_script_group )
{
	shanty_array = GetEntArray( shanty_name, "targetname" );
	if ( IsDefined( shanty_script_group ) )
	{
		foreach ( shanty_ent in shanty_array )
		{
			if ( IsDefined( shanty_ent ) && 
				 IsDefined( shanty_ent.script_group ) &&
				 shanty_ent.script_group == shanty_script_group )
			{
				return shanty_ent;
			}
		}
	}
	else
	{
		// no group defined, make sure it's unique
		if ( shanty_array.size == 1 )
		{
			return shanty_array[0];
		}
	}
	
	return undefined;
}

shanty_mortar_destruct( shanty_name, viewshake, no_fx )
{
	if ( !IsDefined( no_fx ) || !no_fx )
	{
		level._effect[ shanty_name+"_death" ]	= loadfx( "props/"+shanty_name+"_death" );
		level._effect[ shanty_name+"_dest" ]	= loadfx( "props/"+shanty_name+"_dest" );
	}

	shanty_triggers = GetEntArray( shanty_name + "_trigger", "targetname" );
	if ( IsDefined( shanty_triggers ) )
	{
		foreach ( shanty_trigger in shanty_triggers )
		{
			shanty_trigger thread handle_shanty_mortar_destruct( shanty_name, viewshake );
		}
	}
}

handle_shanty_mortar_destruct( shanty_name, viewshake )
{
	shanty_script_group = undefined;
	if ( IsDefined( self.script_group ) )
	{
		shanty_script_group = self.script_group;
	}
			
	shanty = find_unique_shanty_ent( shanty_name, shanty_script_group );
	shanty_destruct_origin = find_unique_shanty_ent( shanty_name + "_origin", shanty_script_group );
			
	// wait till shanty is triggered by mortar
	self waittill( "trigger" );
	level notify( "exploding_shanty_"+shanty_name );
		
	if ( IsDefined( shanty ) )
	{
		shanty_origin = shanty.origin;
		shanty_angles = shanty.angles;
			
		destruct_fx_origin = shanty_origin;
		destruct_fx_angles = shanty_angles;
				
		PlayFX( getfx( shanty_name+"_death" ), shanty_origin, (0,0,1) );
		if ( IsDefined( shanty_destruct_origin ) )
		{
			destruct_fx_origin = shanty_destruct_origin.origin;
			destruct_fx_angles = shanty_destruct_origin.angles;
		}
			
		PlayFX( getfx(shanty_name+"_dest"), destruct_fx_origin, AnglesToForward( destruct_fx_angles ) );
		PhysicsExplosionSphere( shanty_origin, 400, 100, .1 );
	}

	wait 0.05;
			
	if ( IsDefined( shanty ) )
	{
		shanty Delete();
	}
			
	// trigger all leftover triggers that belong to the same script group
	leftover_triggers = GetEntArray( shanty_name + "_trigger", "script_noteworthy" );
	foreach ( leftover_trigger in leftover_triggers )
	{
		if ( !IsDefined( leftover_trigger ) )
			continue;
				
		if ( IsDefined( shanty_script_group ) )
		{
			if ( !IsDefined( leftover_trigger.script_group ) ||
		 		 leftover_trigger.script_group != shanty_script_group )
		 	{
		 		continue;
		 	}
		}
				
		leftover_trigger notify( "trigger" );
	}
			
	destroy_ents = GetEntArray( shanty_name + "_destroy", "script_noteworthy" );
	foreach ( destroy_ent in destroy_ents )
	{
		if ( !IsDefined( destroy_ent ) )
			continue;
					
		if ( IsDefined( shanty_script_group ) )
		{
			if ( !IsDefined( destroy_ent.script_group ) ||
			 	 destroy_ent.script_group != shanty_script_group )
			{
				continue;
			}
		}
					
		if ( destroy_ent.health > 0 )
		{
			destroy_ent DoDamage( 9999, (0,0,0) );
		}
					
		destroy_ent thread delay_delete_me();
	}
	
	if ( IsDefined( viewshake ) && viewshake )
	{
		thread screenshake(.25,0.9,.1,.4);
		setblur(.5, 0.125);
		wait .5;
		setblur(0, 0.2);	
	}
	
	self Delete();
}

delay_delete_me()
{
	wait 2;
	self Delete();
}

shanty_brush_destruct(shanty_name,part_radius_in,viewshake_in)
{
	part_radius = 0;
	viewshake = false;
	if(isdefined(part_radius_in)) part_radius = part_radius_in;
	if(isdefined(viewshake_in)) viewshake = viewshake_in;
	level._effect[ shanty_name+"_death" ]	= loadfx( "props/"+shanty_name+"_death" );
	level._effect[ shanty_name+"_dest" ]	= loadfx( "props/"+shanty_name+"_dest" );
	dam_trig = getentarray(shanty_name+"_trigger","targetname");
	shanty =  getentarray(shanty_name,"targetname");
	shanty_swap = getentarray(shanty_name+"_state","targetname");
	shanty_origin = getentarray(shanty_name+"_origin","targetname");
	ordered_trigs = get_ordered_trigs(shanty,dam_trig);
	if(isdefined(shanty))
	{
		
		for(i=0;i<shanty.size;i++)
		{
			thread Shanty_Dest_Manager(shanty[i],dam_trig[i],shanty_name, part_radius,shanty_swap[i],shanty_origin[i],viewshake);
		}
	}
}

kill_chicken()
{
	wait(1.0);
	self dodamage(500,self.origin);
}

afr_fence_rattle(explosion_origin)
{

	pivot = GetEnt( "fence_pivotpoint", "targetname" );
	//pivot thread maps\_debug::drawOrgForever();

	animated_bridge_fences = GetEntArray( "afr_fence_chainlink", "targetname" );
	animated_bridge_posts = GetEntArray( "afr_fence_postA", "targetname" );
	afr_fence_wood_hitpoint = GetEnt( "afr_fence_wood_hitpoint", "targetname" );

	//check to see if the explosion is close to set off the fence
	//	if not return 0
	distance_m = distance(explosion_origin, pivot.origin);
	
	if(distance_m > 300.00) return 0;


	//Add death fx
	exploder(101);


	foreach ( piece in animated_bridge_fences )
	{
		piece NotSolid();
		piece SetContents( 0 );
		piece LinkTo( pivot );
	}

	foreach ( piece in animated_bridge_posts )
	{
		piece NotSolid();
		piece SetContents( 0 );
		piece LinkTo( pivot );
	}
	
	afr_fence_wood_hitpoint LinkTo( pivot );
	
	//Add mortar shake
	thread do_mortar_shake();
	
	
	
	//Toss some chickens
	dests = GetEntArray( "destructible_toy", "targetname" );
	chickens = [];
	player_comp_vect = vectornormalize(anglestoforward(level.player.angles));
	foreach (chicken in dests)
	{
		//chicken thread kill_chicken();
		/*if(distance(explosion_origin, chicken.origin)<-300)
		{
			m_name = chicken.model;
			if(m_name=="chicken") 
			{
				launch_vect = vectornormalize(level.player.origin + (0,0,100) - chicken.origin);
				random_vect = 75 * (randomfloatrange(-1,1),randomfloatrange(-1,1),0);
				launch_vect += player_comp_vect * 100 + random_vect + (0,0,300 + randomfloat(1) * 100) + launch_vect * (500 + 50 * randomfloat(.51));
				chicken launch(launch_vect);
				chickens[chickens.size] = chicken;
				chicken rotatevelocity((360*randomfloatrange(-1,1),361*randomfloatrange(-1,1),361*randomfloatrange(-1,1)),1);
				chicken thread kill_chicken();
			}
		}*/
	}

	
	start_angles = (pivot.angles[0], pivot.angles[1]-10, pivot.angles[2] + 25 );
	pivot RotateTo( start_angles,  .15, .071, .071 );
	start_val = 0;
	
	mis = spawn_tag_origin();
	mis.origin = afr_fence_wood_hitpoint.origin;
	mis.angles = afr_fence_wood_hitpoint.angles;
	mis LinkTo( pivot );
	
	wait(.5);
	playfxontag(getfx("warlord_fence_woodhit"),mis,"tag_origin");
	
	
	
	wait(1.0);
	amount = -10;
	for ( ;; )
	{
		time = abs( amount ) * 0.0475;
		if ( time < 0.5 )
			time = 0.25;
		pivot RotateTo( ( start_angles[0], start_angles[1], start_angles[2] + amount ), time, time * 0.5, time * 0.5 );
		amount *= -0.65;
		wait( time );
		if ( abs( amount ) <= 2 )
			break;
	}
}




fx_zone1_watcher()
{
	dustcontroller =spawnstruct();
	dustcontroller.status = 1;
	for(;;)
	{
		flag_wait("fx_zone1");
		//set off exploders
		exploder(100);
		dustcontroller.status = 1;
		dustcontroller thread fx_africa_dustrunners(150,8);
		flag_waitopen("fx_zone1");
		dustcontroller.status = 0;
		//kill exploders
		wait(1.0);
	}
}

fx_zone5_watcher()
{
	dustcontroller =spawnstruct();
	dustcontroller.status = 1;
	for(;;)
	{
		flag_wait("fx_zone1");
		//set off exploders
		dustcontroller.status = 1;
		dustcontroller thread fx_africa_dustrunners(550,7);
		exploder(500);
		flag_waitopen("fx_zone1");
		dustcontroller.status = 0;
		//kill exploders
		wait(1.0);
	}
}

fx_africa_dustrunners(start,number)
{
	while(self.status)
	{
		gustnum = randomint(number)+start;
		exploder(gustnum);
		//print("doing dust");
		wait(.2);
	}
}


fx_africa_dustrunners_zone(start,number,msg,msg2)
{
	for(;;)
	{
		assertex(isdefined(msg),"fx_africa_dustrunners_zone doesnt have the right # of args");
		if(isdefined(msg2)) flag_wait_either(msg,msg2);
		else flag_wait(msg);
		gustnum = randomint(number)+start;
		exploder(gustnum);
		//print("doing dust");
		wait(.2);
	}
}



precacheFX()
{
	level._effect[ "warlord_gas_can_spray_cd" ] 	= LoadFX( "maps/warlord/warlord_gas_can_spray_cd" );//placed by fxman
	level._effect[ "warlord_gas_can_spray" ] 	= LoadFX( "maps/warlord/warlord_gas_can_spray" );//placed by fxman
	
	level._effect[ "firelp_med_pm_nolight_burst" ] 	= LoadFX( "fire/firelp_med_pm_nolight_burst" );//placed by fxman
	level._effect[ "fire_smoke_trail_small_detailed2" ] 	= LoadFX( "fire/fire_smoke_trail_small_detailed2" );//placed by fxman
	level._effect[ "fire_smoke_trail_verysmall_detailed" ] 	= LoadFX( "fire/fire_smoke_trail_verysmall_detailed" );//placed by fxman
	level._effect[ "tread_smk_road_suptech_back" ] 	= LoadFX( "treadfx/tread_smk_road_suptech_back" );//placed by fxman
	level._effect[ "birds_takeof_runner" ] 	= LoadFX( "misc/birds_takeof_runner" );//placed by fxman
	level._effect[ "sewer_stream_village_muted" ] 	= LoadFX( "distortion/sewer_stream_village_muted" );//placed by fxman
	level._effect[ "dust_ground_gust_warm_runner" ] 	= LoadFX( "dust/dust_ground_gust_warm_runner" );//placed by fxman
	level._effect[ "amb_dust_light_fakelit" ] 	= LoadFX( "dust/amb_dust_light_fakelit" );//placed by fxman
	level._effect[ "sewer_stream_village" ] 	= LoadFX( "maps/warlord/sewer_stream_village" );//placed by fxman
	level._effect[ "water_flow_sewage_small" ] 	= LoadFX( "water/water_flow_sewage_small" );//placed by fxman
	level._effect[ "water_flow_sewage_small_2" ] 	= LoadFX( "maps/warlord/water_flow_sewage_small" );//placed by fxman
	level._effect[ "sewer_rising_steam" ] 	= LoadFX( "maps/warlord/sewer_rising_steam" );//placed by fxman
	level._effect[ "warlord_church_haze" ] 	= LoadFX( "maps/warlord/warlord_church_haze" );//placed by fxman
	level._effect[ "warlord_plane_runner" ] 	= LoadFX( "maps/warlord/warlord_plane_runner" );//placed by fxman
	
	
	//light fx
	level._effect[ "light_glow_white_bulb" ] 	= LoadFX( "misc/light_glow_white_bulb" );
	level._effect[ "godray_sewerpipe" ] 	= LoadFX( "maps/warlord/godray_warlord_sewerpipe" );

	//rain fx
	level._effect[ "rain_splash_ripples_64x64" ]						= loadfx( "weather/rain_splash_ripples_64x64" );
	level._effect[ "rain_splash_puddles_64x64" ]						= loadfx( "weather/rain_splash_puddles_64x64" );
	level._effect[ "rain_warlord" ]											= loadfx( "maps/warlord/rain_warlord" );
	level._effect[ "rain_warlord_light" ]											= loadfx( "maps/warlord/rain_warlord_light" );
	
	//ambient fx
	level._effect["amb_dust_verylight_cheap"]						= loadfx("dust/amb_dust_verylight_cheap");
	level._effect["amb_dust_verylight_small"]						= loadfx("dust/amb_dust_verylight_small");
	level._effect[ "sand_storm_intro" ]						= loadfx( "weather/sand_storm_intro" );
	level._effect[ "sand_storm_light" ]						= loadfx( "weather/sand_storm_light" );
	level._effect[ "sand_storm_distant_oriented" ] 			= LoadFX( "weather/sand_storm_distant_oriented" );
	level._effect[ "sand_spray_detail_runner0x400" ]	 	= loadfx( "dust/sand_spray_detail_runner_0x400" );
	level._effect[ "sand_spray_detail_runner400x400" ]	 	= loadfx( "dust/sand_spray_detail_runner_400x400" );
	level._effect[ "sand_spray_detail_oriented_runner" ]	= loadfx( "dust/sand_spray_detail_oriented_runner" );
	level._effect[ "sand_spray_cliff_oriented_runner" ] 	= LoadFX( "dust/sand_spray_cliff_oriented_runner" );

	level._effect[ "firelp_med_pm_nolight_atlas" ]							= LoadFX( "fire/fire_med_pm_nolight_atlas" );	
	level._effect[ "firelp_small_pm_nolight" ]							= LoadFX( "fire/firelp_small_pm_nolight" );	
	level._effect[ "firelp_small_pm_a_nolight" ]							= LoadFX( "fire/firelp_small_pm_a_nolight" );	
	level._effect[ "ash_up_01" ]							= LoadFX( "dust/ash_up_01" );	
	level._effect[ "battlefield_smokebank_s_warm_dense" ]							= LoadFX( "smoke/battlefield_smokebank_s_warm_dense" );
	level._effect[ "battlefield_smokebank_s_warm_dense_shadow" ]							= LoadFX( "smoke/battlefield_smokebank_s_warm_dense_shadow" );
	level._effect[ "insects_carcass_flies" ]							= LoadFX( "misc/insects_carcass_flies" );
	level._effect[ "insects_carcass_flies_dark" ]							= LoadFX( "misc/insects_carcass_flies_dark" );
	level._effect[ "moth_runner" ]							= LoadFX( "misc/moth_runner" );
	level._effect[ "insects_dragonfly_runner_a" ]							= LoadFX( "misc/insects_dragonfly_runner_a" );
	level._effect[ "insects_dragonfly_a_oneshot" ]							= LoadFX( "misc/insects_dragonfly_a_oneshot" );
	level._effect[ "birds_parrots_a" ]							= LoadFX( "misc/birds_parrots_a" );
	level._effect[ "leaves_fall_tropical" ]							= LoadFX( "maps/warlord/leaves_fall_tropical" );
	level._effect[ "dust_ground_gust" ]							= LoadFX( "dust/dust_ground_gust_0" );

	level._effect[ "water_stop" ]						 				= loadfx( "maps/warlord/warlord_parabolic_water_stand" );
	level._effect[ "player_water_stop" ]						 				= loadfx( "maps/warlord/warlord_water_stop" );
	level._effect[ "water_movement" ]								 = loadfx( "maps/warlord/warlord_parabolic_water_movement" );
	level._effect[ "footstep_water" ]						 				= loadfx( "maps/warlord/warlord_parabolic_water_movement" );
	level._effect[ "warlord_water_movement" ]				 = loadfx( "misc/warlord_water_walk" );
	level._effect[ "waterfall_splash_falling_mist" ] = loadfx( "water/waterfall_splash_falling_mist_far" );
	level._effect[ "warlord_church_dust" ]					 = loadfx( "maps/warlord/warlord_church_dust" );
	level._effect[ "warlord_village_distortion" ]					 = loadfx( "maps/warlord/warlord_village_distortion" );
	level._effect[ "warlord_village_embers" ]					 = loadfx( "maps/warlord/warlord_village_embers" );
	level._effect[ "warlord_village_wall_embers" ]					 = loadfx( "maps/warlord/warlord_village_wall_embers" );
	level._effect[ "firelp_small_streak_pm_v2" ]					 = loadfx( "fire/firelp_small_streak_pm_v2" );
	level._effect[ "firelp_small_pm_a_nolight_2" ]					 = loadfx( "fire/firelp_small_pm_a_nolight_2" );
	level._effect[ "fire_generic_atlas" ]					 = loadfx( "maps/warlord/warlord_fire_generic_atlas" );
	level._effect[ "fire_generic_l_atlas" ]					 = loadfx( "maps/warlord/warlord_fire_generic_l_atlas" );
	level._effect[ "warlord_fire_woosh" ]					 = loadfx( "maps/warlord/warlord_fire_woosh" );
	level._effect[ "water_emerge" ]					 			= loadfx( "maps/warlord/water_emerge" );
	level._effect[ "water_emerge_2" ]					 			= loadfx( "maps/warlord/water_emerge_2" );
	level._effect[ "water_emerge_3" ]					 			= loadfx( "maps/warlord/water_emerge_3" );
	level._effect[ "water_emerge_4" ]					 			= loadfx( "maps/warlord/water_emerge_4" );
	level._effect[ "water_emerge_weapon" ]					 			= loadfx( "maps/warlord/water_emerge_weapon" );
	level._effect[ "water_emerge_player_weapon" ]					 			= loadfx( "maps/warlord/water_emerge_player_weapon" );
	level._effect[ "water_emerge_player_hand" ]					 			= loadfx( "maps/warlord/water_emerge_player_hand" );
	level._effect[ "water_emerge_bulge" ]					 			= loadfx( "maps/warlord/water_emerge_bulge" );
	level._effect[ "water_emerge_bulge_2" ]					 			= loadfx( "maps/warlord/water_emerge_bulge_2" );
	level._effect[ "truck_splash" ]					 			= loadfx( "maps/warlord/truck_splash" );
	level._effect[ "factory_smokestack" ]					 			= loadfx( "maps/warlord/factory_smokestack" );
	level._effect[ "warlord_river_junk" ]					 			= loadfx( "maps/warlord/warlord_river_junk" );
	level._effect[ "warlord_river_junk_small" ]					 			= loadfx( "maps/warlord/warlord_river_junk_small" );



	
	level._effect[ "steam_vent_large_windslow" ]				= loadfx( "maps/warlord/steam_vent_large_windslow" );
	level._effect[ "dust_wind_fast" ]						= loadfx( "dust/dust_wind_fast_afcaves" );
	level._effect[ "dust_wind_canyon" ]						= loadfx( "dust/dust_wind_canyon" );
	level._effect[ "dust_wind_canyon_fade" ]						= loadfx( "maps/warlord/dust_wind_canyon" );
	level._effect[ "dust_wind_canyon_ground" ]						= loadfx( "dust/dust_wind_canyon_ground" );
	level._effect[ "steam_vent_large_wind" ]				= loadfx( "smoke/steam_vent_large_wind" );
	level._effect[ "steam_burnt_ground" ]				= loadfx( "smoke/steam_burnt_ground" );
	level._effect[ "thermal_draft_afcaves" ]				= loadfx( "smoke/thermal_draft_afcaves" );

	level._effect[ "waterfall_drainage_splash" ] 			= loadfx( "water/waterfall_drainage_splash" );
	level._effect[ "waterfall_splash_large_drops" ]			= loadfx( "water/waterfall_splash_large_drops" );

	level._effect[ "light_shaft_motes_afcaves" ]			= loadfx( "dust/light_shaft_motes_afcaves" );


	//Technical fx
	level._effect[ "warlord_panel2x8_dest" ]																= loadFX( "maps/warlord/warlord_panel2x8_dest" );
	level._effect[ "warlord_panel4x4_dest" ]																= loadFX( "maps/warlord/warlord_panel4x4_dest" );
	level._effect[ "player_splash" ]																= loadFX( "maps/warlord/player_splash" );

	//Mortar run
	level._effect[ "shanty_01_death" ] = loadfx( "props/shanty_01_death" );
	level._effect[ "warlord_fence_woodhit" ] = loadfx( "maps/warlord/warlord_fence_woodhit" );
	level._effect[ "warlord_falling_debris" ] = loadfx( "maps/warlord/warlord_falling_debris" );
	level._effect[ "warlord_panel4x8_dest" ] = loadfx( "maps/warlord/warlord_panel4x8_dest" );
	level._effect[ "warlord_player_fallthrough" ] = loadfx( "maps/warlord/warlord_player_fallthrough" );
	level._effect[ "mortar_fire_aftermath" ] = loadfx( "maps/warlord/mortar_fire_aftermath" );
	level._effect[ "mortar_fire_aftermath_2" ] = loadfx( "maps/warlord/mortar_fire_aftermath_2" );
	level._effect[ "mortar_fire_truck_aftermath" ] = loadfx( "maps/warlord/mortar_fire_truck_aftermath" );
	

	//player mortar
	level._effect[ "firelp_med_spreader" ] = loadfx( "fire/firelp_med_spreader" );

	//sewer 
	level._effect[ "sewer_grate_dust" ] 	= LoadFX( "maps/warlord/sewer_grate_dust" );
	level._effect[ "sewer_grate_dust_2" ] 	= LoadFX( "maps/warlord/sewer_grate_dust_2" );

	//zone 9000
	level._effect[ "dust_spiral_slow_runner_optim" ] = loadfx( "dust/dust_spiral_slow_runner_optim" );
	level._effect[ "ash_spiral_runner" ] = loadfx( "dust/ash_spiral_runner" );
	level._effect[ "dust_wind_slow_paper_narrow" ] = loadfx( "dust/dust_wind_slow_paper_narrow" );
	level._effect[ "trash_spiral_runner" ] = loadfx( "misc/trash_spiral_runner" );
	level._effect[ "battlefield_smk_directional_white_m_cheap" ] = loadfx( "smoke/battlefield_smk_directional_white_m_cheap" );
	level._effect[ "light_shaft_dust_warmlit" ] = loadfx( "dust/light_shaft_dust_warmlit" );
	level._effect[ "trash_spirallo_runner" ] = loadfx( "misc/trash_spirallo_runner" );
	level._effect[ "dust_ground_gust_runner" ] = loadfx( "dust/dust_ground_gust_runner" );
	level._effect[ "light_shaft_ground_dust_warmlit" ] = loadfx( "dust/light_shaft_ground_dust_warmlit" );
	level._effect[ "drips_slow" ] = loadfx( "misc/drips_slow");
	level._effect[ "mist_drifting_sewer_narrow" ] = loadfx( "maps/warlord/mist_drifting_sewer_narrow");
	level._effect[ "light_shaft_dust_medwarmlit" ] = loadfx( "dust/light_shaft_dust_medwarmlit" );



	//Scripted fx
	level._effect[ "burning_man" ] = loadfx( "fire/firelp_med_pm_nolight" );
	level._effect[ "flashlight" ]							= loadfx( "misc/flashlight" );
	level._effect[ "pistol_muzzleflash" ]					= loadfx( "muzzleflashes/pistolflash" );
	level._effect[ "player_death_explosion" ]				= loadfx( "explosions/player_death_explosion" );
	level._effect[ "cave_explosion" ]						= loadfx( "explosions/cave_explosion" );
	level._effect[ "cave_explosion_exit" ]					= loadfx( "explosions/cave_explosion_exit" );

	level._effect[ "mortar" ][ "bunker_ceiling" ]			= loadfx( "dust/ceiling_dust_default" );
	level._effect[ "ceiling_collapse_dirt1" ] 				= loadfx( "dust/ceiling_collapse_dirt1" );
	level._effect[ "ceiling_rock_break" ] 					= loadfx( "misc/ceiling_rock_break" );
	level._effect[ "hallway_collapsing_big" ] 				= loadfx( "misc/hallway_collapsing_big" );
	level._effect[ "hallway_collapsing_huge" ] 				= loadfx( "misc/hallway_collapsing_huge" );
	level._effect[ "hallway_collapsing_cavein" ] 			= loadfx( "misc/hallway_collapsing_cavein" );
	level._effect[ "hallway_collapsing_cavein_short" ]		= loadfx( "misc/hallway_collapsing_cavein_short" );
	
	level._effect[ "hallway_collapsing_burst" ] 			= loadfx( "misc/hallway_collapsing_burst" );
	level._effect[ "hallway_collapsing_burst_no_linger" ] 	= loadfx( "misc/hallway_collapsing_burst_no_linger" );
	level._effect[ "hallway_collapsing_major" ] 			= loadfx( "misc/hallway_collapsing_major" );
	level._effect[ "hallway_collapsing_major_norocks" ] 	= loadfx( "misc/hallway_collapsing_major_norocks" );
	
	level._effect[ "building_explosion_metal" ]				= loadfx( "explosions/building_explosion_metal_gulag" );
	level._effect[ "tanker_explosion" ]						= loadfx( "explosions/tanker_explosion" );
	level._effect[ "airstrip_explosion" ]					= loadfx( "explosions/airstrip_explosion" );
	level._effect[ "bunker_ceiling" ]		 				= loadfx( "dust/ceiling_dust_default" );
	
	level._effect[ "heli_impacts" ] 						= loadfx( "impacts/large_dirt_1" );
	level._effect[ "welding_small_extended" ] 				= loadfx( "misc/welding_small_extended" );
	level._effect[ "fire_falling_runner_point" ]			= loadfx( "fire/fire_falling_runner_point" );
	
	level._effect[ "gulag_cafe_spotlight" ] 				= loadfx( "misc/gulag_cafe_spotlight" );
	
	level._effect[ "heli_aerial_explosion" ]			 	= loadfx( "explosions/aerial_explosion" );
	level._effect[ "heli_aerial_explosion_large" ]		 	= loadfx( "explosions/aerial_explosion_large" );
	//level._effect[ "flaming_tire" ]		  					= loadfx( "fire/firelp_med_pm_nolight" );

	level._effect[ "knife_attack_fx" ] 						= loadfx( "misc/blood_back_stab" );
	level._effect[ "warlord_chestshot_blood" ] 						= loadfx( "maps/warlord/warlord_chestshot_blood" );
	level._effect[ "knife_attack_throat_fx" ] 						= loadfx( "misc/blood_throat_stab" );
	level._effect[ "knife_attack_throat_fx2" ] 						= loadfx( "misc/blood_throat_stab2" );
	level._effect[ "intro_knife_throat_fx" ] 						= loadfx( "maps/warlord/intro_blood_throat_stab" );
	level._effect[ "blood_hyena_bite" ] 						= loadfx( "misc/blood_hyena_bite" );
	level._effect[ "warlord_dust_impact" ] 						= loadfx( "maps/warlord/warlord_dust_impact" );
	level._effect[ "headshot" ]								= loadfx( "impacts/flesh_hit_head_fatal_exit" );
	level._effect[ "bodyshot" ]								= loadfx( "impacts/flesh_hit" );
	level._effect[ "hyena_blood_fx" ]								= loadfx( "maps/warlord/hyena_blood_fx" );
	level._effect[ "execution_blood_fx" ]								= loadfx( "maps/warlord/execution_blood_fx" );
	level._effect[ "execution_blood_fx_2" ]								= loadfx( "maps/warlord/execution_blood_fx_2" );
	level._effect[ "hyena_saliva_fx" ]								= loadfx( "maps/warlord/hyena_saliva_fx" );
	level._effect[ "hyena_saliva_fx_r" ]								= loadfx( "maps/warlord/hyena_saliva_fx_r" );
	level._effect[ "hyena_saliva_fx_2" ]								= loadfx( "maps/warlord/hyena_saliva_fx_2" );
	level._effect[ "hyena_saliva_fx_3" ]								= loadfx( "maps/warlord/hyena_saliva_fx_3" );
	level._effect[ "hyena_dust" ]										= loadfx( "maps/warlord/hyena_dust" );
	level._effect[ "warlord_gnats" ]										= loadfx( "maps/warlord/warlord_gnats" );
	
	level._effect[ "garbage" ]													 = loadfx( "props/garbage_spew" );
	level._effect[ "garbage_des" ]											= loadfx( "props/garbage_spew_des" );
	
	level._effect[ "door_kick" ]												= loadfx( "dust/door_kick" );
	level._effect[ "door_kick_small" ] 									= loadfx( "dust/door_kick_small" );
	
	level._effect[ "bird_takeoff" ]										 = loadfx( "misc/bird_takeoff" );
	level._effect[ "body_water_splash" ] 								= loadfx( "maps/warlord/body_water_splash" );
	level._effect[ "heli_dust_warlord" ] 								= loadfx( "maps/warlord/heli_dust_warlord" );
	level._effect[ "truck_dust_warlord" ] 								= loadfx( "maps/warlord/truck_dust_warlord" );
	
	//truck death fx
	level._effect[ "truck_vehicle_explosion" ]					= loadfx( "maps/warlord/truck_vehicle_explosion" );
	level._effect[ "fire_truck" ]												= loadfx( "maps/warlord/fire_truck" );
	level._effect[ "fire_truck_small" ]									= loadfx( "maps/warlord/fire_truck_small" );
	level._effect[ "mortarExp_debris" ]									= loadfx( "maps/warlord/mortarExp_debris" );
}


//probably can be replaced with notetracks?
//now it will not burn the guy after he dies, we could probably burn his corpse :)
gas_can_fx(burner,victim)
{
	if( !flag_exist( "guy_fx_gas_ended" ) ) flag_init( "guy_fx_gas_ended" );


	can_obj = spawn_tag_origin();
	can_obj.origin = burner gettagorigin("j_wrist_le");
	can_obj.angles = burner gettagangles("j_wrist_le");
	can_obj LinkTo( burner, "j_wrist_le", (15,0,-15), (0,0,0) );
	
	wait(4.33);//anim starts at 654 frame784
	
	if(isdefined(victim))
	{
		playfxontag(getfx("warlord_gas_can_spray"),can_obj,"tag_origin");
		
		args = spawnstruct();
		args.v["ent"]=victim;
		args.v["fx"]=getfx("warlord_gas_can_spray_cd");
		args.v["looptime"]=.04;
			
		args.v["chain"]="head";
		stop_head_burn = play_fx_on_actor(args);
		
		args.v["chain"]="l_arm";
		stop_l_arm_burn = play_fx_on_actor(args);
		
		args.v["chain"]="r_arm";
		stop_r_arm_burn = play_fx_on_actor(args);
		
		thread stop_gas_fx(stop_head_burn,stop_l_arm_burn,stop_r_arm_burn,can_obj);
		
		wait(2.43);//frame857
		
		level notify(stop_head_burn);
		level notify(stop_l_arm_burn);
		level notify(stop_r_arm_burn);
		stopfxontag(getfx("warlord_gas_can_spray"),can_obj,"tag_origin");

		wait(5.96);//frame1036

		if(isdefined(victim))
		{		
			args.v["chain"]="head";
			stop_head_burn = play_fx_on_actor(args);
			
			args.v["chain"]="l_arm";
			stop_l_arm_burn = play_fx_on_actor(args);
			
			args.v["chain"]="r_arm";
			stop_r_arm_burn = play_fx_on_actor(args);
			
			playfxontag(getfx("warlord_gas_can_spray"),can_obj,"tag_origin");
			
			wait(1.5);//frame1081
		
			level notify(stop_head_burn);
			level notify(stop_l_arm_burn);
			level notify(stop_r_arm_burn);
			
			flag_set( "guy_fx_gas_ended" );
			
			stopfxontag(getfx("warlord_gas_can_spray"),can_obj,"tag_origin");		
		}
	}
		wait(3.0);
		RestartFXID("amb_dust_verylight_cheap");
}

stop_gas_fx(stop_head_burn,stop_l_arm_burn,stop_r_arm_burn,can_obj)
{
	flag_wait( "river_burn_interrupted" );
	flag_waitopen ( "guy_fx_gas_ended" );
	level notify(stop_head_burn);
	level notify(stop_l_arm_burn);
	level notify(stop_r_arm_burn);
	stopfxontag(getfx("warlord_gas_can_spray"),can_obj,"tag_origin");
}

/#
testmsg()
{
	self waittillmatch("single anim","pourgas");
	//self waittill("single anim");
	iprintln("gas message");
	self waittill("single anim");
	iprintln("gas message2");
	self waittill("single anim");
	iprintln("gas message3");
}
#/
set_guy_on_fire()
{
	//wait(2.0);
	//play the burst flame
	playfx(getfx("firelp_med_pm_nolight_burst"),self.origin,anglestoforward((270,0,0)));
	args = spawnstruct();
	args.v["ent"]=self;
	args.v["fx"]=getfx("fire_smoke_trail_verysmall_detailed");
	args.v["chain"]="all";
	args.v["looptime"]=.08;
	notify1 = play_fx_on_actor(args);
	args.v["ent"]=self;
	args.v["fx"]=getfx("fire_smoke_trail_small_detailed2");
	args.v["chain"]="torso";
	args.v["looptime"]=.1;
	notify2 = play_fx_on_actor(args);
	wait(32.0);
	level notify(notify1);
	level notify(notify2);
	
}


introSandStorm()
{
	player = getentarray( "player", "classname" )[ 0 ];
	playfx( getfx( "sand_storm_intro" ), player.origin );
}

get_global_fx( name )
{
	fxName = level.global_fx[ name ];
	return level._effect[ fxName ];
}

footStepEffects()
{
	//Regular footstep fx
	animscripts\utility::setFootstepEffect( "mud",				loadfx ( "impacts/footstep_mud" ) );
	//animscripts\utility::setFootstepEffect( "water",				loadfx ( "maps/warlord/warlord_parabolic_water_movement" ) );
	animscripts\utility::setFootstepEffect( "dirt",				loadfx ( "impacts/footstep_dust" ) );
	//animscripts\utility::setNotetrackEffect( "knee fx left", 		"J_Knee_LE", 			"water",		loadfx ( "impacts/footstep_water" ) );
	//animscripts\utility::setNotetrackEffect( "knee fx right", 		"J_Knee_RI", 			"water",		loadfx ( "impacts/footstep_water" ) );
	
	//Small footstep fx
	animscripts\utility::setFootstepEffectSmall( "mud",		loadfx ( "impacts/footstep_mud" ) );
	//animscripts\utility::setFootstepEffectSmall( "water",			loadfx ( "maps/warlord/warlord_parabolic_water_movement" ) );
	animscripts\utility::setFootstepEffectSmall( "dirt",			loadfx ( "impacts/footstep_dust" ) );
	//animscripts\utility::setFootstepEffectSmall( "slush",		loadfx ( "impacts/footstep_snow_slush_small" ) );
}

treadfx_override()
{
	fx = "maps/warlord/tread_sand_warlord";
	vehicletype_fx[0] = "script_vehicle_pickup_technical";
	vehicletype_fx[1] = "script_vehicle_pickup_technical_physics";
	vehicletype_fx[2] = "script_vehicle_pickup_technical_m2";
	vehicletype_fx[3] = "script_vehicle_pickup_roobars";
	vehicletype_fx[4] = "script_vehicle_pickup_roobars_physics_instant_death";
	vehicletype_fx[5] = "script_vehicle_pickup_roobars_physics_instant_death";
	vehicletype_fx[6] = "script_vehicle_pickup_technical_aa";
	vehicletype_fx[7] = "script_vehicle_pickup_technical_aa_physics";
	vehicletype_fx[8] = "script_vehicle_pickup_technical_custom_fx";
	

	foreach(vehicletype in vehicletype_fx)
	{
		maps\_treadfx::setvehiclefx( vehicletype, "brick", fx );
	 	maps\_treadfx::setvehiclefx( vehicletype, "bark", fx );
	 	maps\_treadfx::setvehiclefx( vehicletype, "carpet", fx );
	 	maps\_treadfx::setvehiclefx( vehicletype, "cloth", fx );
	 	maps\_treadfx::setvehiclefx( vehicletype, "concrete", fx );
	 	maps\_treadfx::setvehiclefx( vehicletype, "dirt", fx );
	 	maps\_treadfx::setvehiclefx( vehicletype, "flesh", fx );
	 	maps\_treadfx::setvehiclefx( vehicletype, "foliage", fx );
	 	maps\_treadfx::setvehiclefx( vehicletype, "glass", fx );
	 	maps\_treadfx::setvehiclefx( vehicletype, "grass", fx );
	 	maps\_treadfx::setvehiclefx( vehicletype, "gravel", fx );
	 	maps\_treadfx::setvehiclefx( vehicletype, "ice", fx );
	 	maps\_treadfx::setvehiclefx( vehicletype, "metal", fx );
	 	maps\_treadfx::setvehiclefx( vehicletype, "mud", fx );
	 	maps\_treadfx::setvehiclefx( vehicletype, "paper", fx );
	 	maps\_treadfx::setvehiclefx( vehicletype, "plaster", fx );
	 	maps\_treadfx::setvehiclefx( vehicletype, "rock", fx );
	 	maps\_treadfx::setvehiclefx( vehicletype, "sand", fx );
	 	maps\_treadfx::setvehiclefx( vehicletype, "snow", fx );
	 	//maps\_treadfx::setvehiclefx( vehicletype, "water", fx );
	 	maps\_treadfx::setvehiclefx( vehicletype, "wood", fx );
	 	maps\_treadfx::setvehiclefx( vehicletype, "asphalt", fx );
	 	maps\_treadfx::setvehiclefx( vehicletype, "ceramic", fx );
	 	maps\_treadfx::setvehiclefx( vehicletype, "plastic", fx );
	 	maps\_treadfx::setvehiclefx( vehicletype, "rubber", fx );
	 	maps\_treadfx::setvehiclefx( vehicletype, "cushion", fx );
	 	maps\_treadfx::setvehiclefx( vehicletype, "fruit", fx );
	 	maps\_treadfx::setvehiclefx( vehicletype, "paintedmetal", fx );
	 	maps\_treadfx::setvehiclefx( vehicletype, "riotshield", fx );
	 	maps\_treadfx::setvehiclefx( vehicletype, "slush", fx );
	 	maps\_treadfx::setvehiclefx( vehicletype, "default", fx );
		maps\_treadfx::setvehiclefx( vehicletype, "none" );
	}


	
}

// Depth of field
manage_dof()
{
	flag_init( "enable_river_dof" );

	thread manage_river_dof_flag();
	thread river_dof_settings();
}

manage_river_dof_flag()
{
	// keep track of how many triggers you are in,
	//   to support overlapping/adjacent triggers
	level.river_dof_trigger_count = 0;
	
	river_dof_triggers = GetEntArray( "trig_river_dof", "targetname" );
	foreach ( river_dof_trigger in river_dof_triggers )
	{
		river_dof_trigger thread monitor_river_dof_trigger();
	}
	
	while ( true )
	{
		// wait for count notify
		level waittill( "river_dof_trigger_count_updated" );
		// wait until all the triggers have run
		waittillframeend;
		if ( level.river_dof_trigger_count > 0 )
		{
			flag_set( "enable_river_dof" );
		}
		else
		{
			flag_clear( "enable_river_dof" );
		}
	}
}

enable_river_dof_condition()
{
	if ( level.player GetStance() != "stand" && !flag( "_stealth_spotted" ) )
	{
		return true;
	}
	
	return false;
}

monitor_river_dof_trigger()
{
	while ( true )
	{
		self waittill( "trigger" );
		if ( enable_river_dof_condition() )
		{
			level.river_dof_trigger_count++;
			level notify( "river_dof_trigger_count_updated" );
			while ( level.player IsTouching( self ) && enable_river_dof_condition() )
			{
				wait 0.1;
			}
			
			level.river_dof_trigger_count--;
			level notify( "river_dof_trigger_count_updated" );
		}
	}
}

river_dof_settings()
{
	wait 0.05;
	start = level.dofDefault;
	
	// the default viewmodel dof numbers
	start_viewmodel = [];
	start_viewmodel[ "start" ] = 2;
	start_viewmodel[ "end" ] = 8;
	
	level.player.viewmodel_dof_start = start_viewmodel[ "start" ];
	level.player.viewmodel_dof_end = start_viewmodel[ "end" ];
	level.player SetViewModelDepthofField( 0, 0 );
	
	while ( true )
	{
		flag_wait( "enable_river_dof" );
		
		// new dof
		river_dof = [];
		river_dof[ "nearStart" ] = 1;
		river_dof[ "nearEnd" ] = 104;
		river_dof[ "nearBlur" ] = 4.5;
		river_dof[ "farStart" ] = 500;
		river_dof[ "farEnd" ] = 500;
		river_dof[ "farBlur" ] = 1.8;
		
		// new viewmodel dof
		end_viewmodel[ "start" ] = 10;
		end_viewmodel[ "end" ] = 90;
		
		blend_viewmodel_dof( start_viewmodel, end_viewmodel, 1, false );

		blend_dof( start, river_dof, 1 );
		
		// reset dof
		flag_waitopen( "enable_river_dof" );
		blend_dof( river_dof, start, 1 );
		
		blend_viewmodel_dof( end_viewmodel, start_viewmodel, 1, true );
	}
}

/* lerps the viewmodel dof between two values 
     start_viewmodel - array containing "start" and "end", the dof the viewmodel would be ideally starting from
     end_viewmodel - array containing "start" and "end", the dof the viewmodel would be ending at
     time - time in seconds to lerp, if viewmodel was at the ideal start dof
*/
blend_viewmodel_dof( start_viewmodel, end_viewmodel, time, disable_when_done )
{
	if ( time > 0 )
	{
		start_dof_inc = ( ( end_viewmodel[ "start" ] - start_viewmodel[ "start" ] ) * 0.05 ) / time;
		end_dof_inc = ( ( end_viewmodel[ "end" ] - start_viewmodel[ "end" ] ) * 0.05 ) / time;
		
		thread lerp_viewmodel_dof( end_viewmodel, start_dof_inc, end_dof_inc, disable_when_done );
	}
	else
	{
		level.player.viewmodel_dof_start = end_viewmodel[ "start" ];
		level.player.viewmodel_dof_end = end_viewmodel[ "end" ];
		
		if ( disable_when_done )
		{
			level.player SetViewModelDepthOfField( 0, 0 );
		}
	}
}

lerp_viewmodel_dof( end_viewmodel, start_dof_inc, end_dof_inc, disable_when_done )
{
	level notify( "lerp_viewmodel_dof" );
	level endon( "lerp_viewmodel_dof" );
	
	start_done = false;
	end_done = false;
	
	while ( !start_done || !end_done )
	{
		if ( !start_done )
		{
			level.player.viewmodel_dof_start = level.player.viewmodel_dof_start + start_dof_inc;
			if ( ( start_dof_inc > 0 && level.player.viewmodel_dof_start > end_viewmodel[ "start" ] ) ||
				 ( start_dof_inc < 0 && level.player.viewmodel_dof_start < end_viewmodel[ "start" ] ) )
			{
				level.player.viewmodel_dof_start = end_viewmodel[ "start" ];
				start_done = true;
			}
		}
		
		if ( !end_done )
		{
			level.player.viewmodel_dof_end = level.player.viewmodel_dof_end + end_dof_inc;
			if ( ( end_dof_inc > 0 && level.player.viewmodel_dof_end > end_viewmodel[ "end" ] ) ||
				 ( end_dof_inc < 0 && level.player.viewmodel_dof_end < end_viewmodel[ "end" ] ) )
			{
				level.player.viewmodel_dof_end = end_viewmodel[ "end" ];
				end_done = true;
			}
		}
		
		level.player SetViewModelDepthOfField( level.player.viewmodel_dof_start, level.player.viewmodel_dof_end );
		wait 0.05;
	}
	
	if ( disable_when_done )
	{
		level.player SetViewModelDepthOfField( 0, 0 );
	}
}

fx_stop_rain()
{
	flag_wait("msg_fx_stop_rain");
	kill_oneshot("rain_splash_ripples_64x64");
	kill_oneshot("rain_warlord");
	kill_oneshot("rain_warlord_light");
}

//hide dust fx in level for confrontation
fx_stop_dust()
{
	foreach ( fx in level.createFXent )
	{
		if (( fx.v[ "type" ] == "oneshotfx" ))  
		fx pauseEffect();
	}
}
	
	
church_breach_vfx()
{
	wait (1.0);
	exploder(996);
	exploder(10);
	flag_init( "hyena_dead" );
}

additional_shake()
{
	pos = level.player.origin;
	rampup = 0.01;
	i = 0;
	duration = 600.5;
	shake_scale = 40;
	elapsed_time = 0;
	ramp_time = .1;
	
	while ( elapsed_time < duration )
	{
		flag_waitopen("fx_shakeon");
		flag_waitopen("hyena_dead");
		waittime = randomfloat(1.0) * 8.0+ 1.0;
		s_waittime = waittime / 20.00;
		//do roll
		earthquake( randomfloatrange(.15,.2), s_waittime, level.player.origin, 1024 );
		
		wait(s_waittime);
		elapsed_time += s_waittime;
	}
}

hyena_attack_fx()
{
	self endon( "death" );
	
	level.fx_dust_tag = spawn_tag_origin();
	level.fx_dust_tag.origin = self gettagorigin("tag_origin");
	level.fx_dust_tag.angles = self gettagangles("tag_origin");
	level.fx_dust_tag linkto(self, "tag_origin");
	playfxontag( getfx( "hyena_dust" ), level.fx_dust_tag, "TAG_ORIGIN" );
	playfxontag( getfx( "hyena_saliva_fx_r" ), self, "J_Lip_Top_RI" );
	playfxontag( getfx( "hyena_saliva_fx" ), self, "J_Lip_Top_LE" );
	playfxontag( getfx( "hyena_saliva_fx_3" ), self, "tag_mouth_fx" );
	wait (3.1);
	flag_init("fx_shakeon");
	thread additional_shake();
	for (;;)
	{
		wait (0.2);
		thread hyena_camera_shake();
		playfxontag( getfx( "hyena_saliva_fx_2" ), self, "tag_mouth_fx" );
		wait (0.3);
		thread hyena_camera_shake();
		playfxontag( getfx( "hyena_saliva_fx_2" ), self, "tag_mouth_fx" );
		wait (0.5);
		thread hyena_camera_shake();
		playfxontag( getfx( "hyena_saliva_fx_2" ), self, "tag_mouth_fx" );
		wait (0.2);
		thread hyena_camera_shake();
		wait (0.8);
		thread hyena_camera_shake();
		playfxontag( getfx( "hyena_saliva_fx_3" ), self, "tag_mouth_fx" );
		wait (0.5);
		playfxontag( getfx( "hyena_saliva_fx_2" ), self, "tag_mouth_fx" );
		wait (0.5);
	}
}

hyena_death_fx( beretta )
{
	flag_set( "hyena_dead" );
	wait (1.4);
	if(isdefined(beretta)) playfxontag( getfx( "hyena_blood_fx" ), beretta, "TAG_FLASH" );
	wait (0.5);
	if(isdefined(beretta)) playfxontag( getfx( "hyena_blood_fx" ), beretta, "TAG_FLASH" );
	wait (0.5);
	if(isdefined(beretta)) playfxontag( getfx( "hyena_blood_fx" ), beretta, "TAG_FLASH" );
	level.fx_dust_tag delete();
		
	//unhide dust fx in level for confrontation
	foreach ( fx in level.createFXent )
	{
		if (( fx.v[ "type" ] == "oneshotfx" ))
			fx restartEffect();
	}
	
	wait (5.5);
	PauseFXID("heli_dust_warlord");
}

hyena_camera_shake()
{
	flag_set("fx_shakeon");
	earthquake ( randomfloatrange(0.2,0.4), 0.5, level.player.origin, 1024 );	
	level waitframe();
	flag_clear("fx_shakeon");
}    


/*
spawn_body_toss_fx()
{
	wait (7.5);
	exploder(891);
	foreach ( fx in level.createFXent )
	{
		if (( fx.v[ "type" ] == "oneshotfx" ))  
		Fx pauseEffect();
		
	}
}
*/

shadow_mortar_lerp(currscale,targetscale,time,currsample,targetsample)
{
 currframe = 0;
 numframes = time*20;
 numframes_less = numframes - 1;
 while(currframe<(numframes))//since the server runs at 20fps
 {
  lerpsunscale = (targetscale-currscale)*(currframe/numframes_less);
  lerpsunscale += currscale;
  setsaveddvar("sm_sunshadowscale",lerpsunscale);
  lerpsunsample = (targetsample-currsample)*(currframe/numframes_less);
  lerpsunsample += currsample;
  setsaveddvar("sm_sunsamplesizenear",lerpsunsample);
  currframe++;
  level waitframe();
 }
// setsunlight(targetlight[0],targetlight[1],targetlight[2]);
}

shadow_scale_mortar()
{
	wait (.1);
	for(;;)
	{
		flag_wait ("msg_scaleshadow");
		
		currscale = getDvarFloat ("sm_sunshadowscale");
		currsample = getDvarFloat ("sm_sunsamplesizenear");
		targetscale = .25; 
		targetsample = .08;
		time = 6;
		thread shadow_mortar_lerp(currscale,targetscale,time,currsample,targetsample);
		wait (time);
		//setsaveddvar ("sm_sunenable", 0);
		flag_waitopen ("msg_scaleshadow");
		
		currscale = getDvarFloat ("sm_sunshadowscale");
		currsample = getDvarFloat ("sm_sunsamplesizenear");
		targetscale = .5; 
		targetsample = .35;
		time = 6;
		thread shadow_mortar_lerp(currscale,targetscale,time,currsample,targetsample);
		wait (time);
		//setsaveddvar ("sm_sunenable", 1);
	}
}

//mortar technical
mortar_explosion_0_fx()
{
	//iprintlnbold( "mortar" );
	//wait (0.9);
	exploder(50);
}

//mortar run
mortar_explosion_1_fx()
{
	wait (0.9);
	exploder(51);
}

mortar_explosion_2_fx()
{
	//wait (1.0);
	exploder(52);
}


mortar_explosion_3_fx()
{
	wait (0.4);
	exploder(53);
}

mortar_explosion_4_fx()
{
	exploder(54);
}

mortar_explosion_5_fx()
{
	exploder(55);
}

mortar_explosion_6_fx()
{
	wait (1.0);
	exploder(56);
}

mortar_explosion_7_fx()
{
	wait (1.0);
	exploder(57);
}

sewer_grate_vfx()
{
	wait (2.0);
	exploder(60);
	wait (1.5);
	wait (2.5);
	exploder(61);
	PauseFXID("firelp_med_spreader");
}

pre_truck_mortar_vfx()
{
	exp_num = 64;
	aud_send_msg("pre_truck_explode_fake_mortar_incoming", exp_num);
	wait(0.9);
	exploder(64);	
	flag_set("aud_fake_mortar_exploded");
	aud_send_msg("pre_truck_explode_fake_mortar", exp_num);
}

intro_truck_splash_vfx()
{
	wait (1.5);
	exploder(65);	
	wait (0.5);
	exploder(65);	
	wait (1.0);
	exploder(65);
	wait (0.5);
	exploder(65);	
}

play_oneshot_dragonflies()
{
	waitframe();
	flag_wait( "river_allies_stand" );
	data = spawnStruct();
	get_createfx(33, data);
	ents = data.v["ents"];
	for (i=0; i<ents.size; i++)
	{
		thread oneshot_dragonflies_update(ents[i]);
	}
}

oneshot_dragonflies_update(fx_ent)
{
	if(isdefined(fx_ent.v["delay"]))
		wait(fx_ent.v["delay"]);
	endLoc = fx_ent.v["origin"] + (0,750,0);
	aud_data[0] = fx_ent.v["origin"];
	aud_data[1] = endLoc;
	aud_data[2] = 4;
	aud_send_msg("fx_dragonfly_flyby", aud_data);
	fx_ent activate_individual_exploder();
}

get_createfx(num, data)
{
	org = [];
	ang = [];
	ents = [];
	delay = [];
	exploders = GetExploders( num );
	foreach (ent in exploders)
	{
		org[(org.size)]=ent.v["origin"];
		ang[(ang.size)]=ent.v["angles"];
		ents[(ents.size)]=ent;
		delay[(org.size)]=ent.v["delay"];
	}
	data.v["origins"] =  org;
	data.v["angles"] = ang;
	data.v["ents"] = ents;
	data.v["delay"] = delay;
}

treadfx_override_heli()
{
	level.treadfx_maxheight = 5000;
	flying_tread_fx = "maps/warlord/heli_dust_warlord_empty";
	vehicletype_fx[0] = "script_vehicle_mi17_africa";

	

	foreach(vehicletype in vehicletype_fx)
	{
	
		maps\_treadfx::setvehiclefx( vehicletype, "brick", flying_tread_fx );
	 	maps\_treadfx::setvehiclefx( vehicletype, "bark", flying_tread_fx );
	 	maps\_treadfx::setvehiclefx( vehicletype, "carpet", flying_tread_fx );
	 	maps\_treadfx::setvehiclefx( vehicletype, "cloth", flying_tread_fx );
	 	maps\_treadfx::setvehiclefx( vehicletype, "concrete", flying_tread_fx );
	 	maps\_treadfx::setvehiclefx( vehicletype, "dirt", flying_tread_fx );
	 	maps\_treadfx::setvehiclefx( vehicletype, "flesh", flying_tread_fx );
	 	maps\_treadfx::setvehiclefx( vehicletype, "foliage", flying_tread_fx );
	 	maps\_treadfx::setvehiclefx( vehicletype, "glass", flying_tread_fx );
	 	maps\_treadfx::setvehiclefx( vehicletype, "grass", flying_tread_fx );
	 	maps\_treadfx::setvehiclefx( vehicletype, "gravel", flying_tread_fx );
	 	maps\_treadfx::setvehiclefx( vehicletype, "ice", flying_tread_fx );
	 	maps\_treadfx::setvehiclefx( vehicletype, "metal", flying_tread_fx );
	 	maps\_treadfx::setvehiclefx( vehicletype, "mud", flying_tread_fx );
	 	maps\_treadfx::setvehiclefx( vehicletype, "paper", flying_tread_fx );
	 	maps\_treadfx::setvehiclefx( vehicletype, "plaster", flying_tread_fx );
	 	maps\_treadfx::setvehiclefx( vehicletype, "rock", flying_tread_fx );
	 	maps\_treadfx::setvehiclefx( vehicletype, "sand", flying_tread_fx );
	 	maps\_treadfx::setvehiclefx( vehicletype, "snow", flying_tread_fx );
	 	maps\_treadfx::setvehiclefx( vehicletype, "water", flying_tread_fx );
	 	maps\_treadfx::setvehiclefx( vehicletype, "wood", flying_tread_fx );
	 	maps\_treadfx::setvehiclefx( vehicletype, "asphalt", flying_tread_fx );
	 	maps\_treadfx::setvehiclefx( vehicletype, "ceramic", flying_tread_fx );
	 	maps\_treadfx::setvehiclefx( vehicletype, "plastic", flying_tread_fx );
	 	maps\_treadfx::setvehiclefx( vehicletype, "rubber", flying_tread_fx );
	 	maps\_treadfx::setvehiclefx( vehicletype, "cushion", flying_tread_fx );
	 	maps\_treadfx::setvehiclefx( vehicletype, "fruit", flying_tread_fx );
	 	maps\_treadfx::setvehiclefx( vehicletype, "painted metal", flying_tread_fx );
	 	maps\_treadfx::setvehiclefx( vehicletype, "default", flying_tread_fx );
		maps\_treadfx::setvehiclefx( vehicletype, "none", flying_tread_fx );
	}



}

truck_deathfx_override()
{
	maps\_vehicle::build_deathfx_override( "script_vehicle_pickup_roobars", "undefined", "vehicle_pickup_roobars", "maps/warlord/fire_truck_small", 					"tag_body", 			"smallfire", 		undefined, 			undefined, 		true, 			0, true );
	maps\_vehicle::build_deathfx_override( "script_vehicle_pickup_roobars", "undefined", "vehicle_pickup_roobars","maps/warlord/truck_vehicle_explosion", 	undefined, 				"car_explode", 		undefined, 			undefined, 		undefined, 		1.9, true );
	maps\_vehicle::build_deathfx_override( "script_vehicle_pickup_roobars", "undefined", "vehicle_pickup_roobars","maps/warlord/fire_truck_small", 				"tag_fx_tire_right_r", 	"smallfire", 		undefined, 			undefined, 		true, 			2, true );
	maps\_vehicle::build_deathfx_override( "script_vehicle_pickup_roobars", "undefined", "vehicle_pickup_roobars","maps/warlord/fire_truck", 					"tag_fx_cab", 			"smallfire", 		undefined, 			undefined, 		true, 			2.01, true );
	maps\_vehicle::build_deathfx_override( "script_vehicle_pickup_roobars", "undefined", "vehicle_pickup_roobars","maps/warlord/fire_truck_small", 				"tag_engine_left", 		"smallfire", 		undefined, 			undefined, 		true, 			2.01, true );
	
	maps\_vehicle::build_deathfx_override( "script_vehicle_pickup_technical", "undefined", "vehicle_pickup_technical", "maps/warlord/fire_truck_small", 					"tag_body", 			"smallfire", 		undefined, 			undefined, 		true, 			0, true );
	maps\_vehicle::build_deathfx_override( "script_vehicle_pickup_technical", "undefined", "vehicle_pickup_technical","maps/warlord/truck_vehicle_explosion", 	undefined, 				"car_explode", 		undefined, 			undefined, 		undefined, 		1.9, true );
	maps\_vehicle::build_deathfx_override( "script_vehicle_pickup_technical", "undefined", "vehicle_pickup_technical","maps/warlord/fire_truck_small", 				"tag_fx_tire_right_r", 	"smallfire", 		undefined, 			undefined, 		true, 			2, true );
	maps\_vehicle::build_deathfx_override( "script_vehicle_pickup_technical", "undefined", "vehicle_pickup_technical","maps/warlord/fire_truck", 					"tag_fx_cab", 			"smallfire", 		undefined, 			undefined, 		true, 			2.01, true );
	maps\_vehicle::build_deathfx_override( "script_vehicle_pickup_technical", "undefined", "vehicle_pickup_technical","maps/warlord/fire_truck_small", 				"tag_engine_left", 		"smallfire", 		undefined, 			undefined, 		true, 			2.01, true );
	
	maps\_vehicle::build_deathfx_override( "script_vehicle_pickup_technical_custom_fx", "undefined", "vehicle_pickup_technical", "maps/warlord/fire_truck_small", 					"tag_body", 			"smallfire", 		undefined, 			undefined, 		true, 			0, true );
	maps\_vehicle::build_deathfx_override( "script_vehicle_pickup_technical_custom_fx", "undefined", "vehicle_pickup_technical","maps/warlord/truck_vehicle_explosion", 	undefined, 				"car_explode", 		undefined, 			undefined, 		undefined, 		0.9, true );
	maps\_vehicle::build_deathfx_override( "script_vehicle_pickup_technical_custom_fx", "undefined", "vehicle_pickup_technical","maps/warlord/fire_truck_small", 				"tag_fx_tire_right_r", 	"smallfire", 		undefined, 			undefined, 		true, 			1, true );
	maps\_vehicle::build_deathfx_override( "script_vehicle_pickup_technical_custom_fx", "undefined", "vehicle_pickup_technical","maps/warlord/fire_truck", 					"tag_fx_cab", 			"smallfire", 		undefined, 			undefined, 		true, 			1.01, true );
	maps\_vehicle::build_deathfx_override( "script_vehicle_pickup_technical_custom_fx", "undefined", "vehicle_pickup_technical","maps/warlord/fire_truck_small", 				"tag_engine_left", 		"smallfire", 		undefined, 			undefined, 		true, 			1.01, true );
	
	maps\_vehicle::build_deathfx_override( "script_vehicle_pickup_technical_instant_death", "undefined", "vehicle_pickup_technical", "maps/warlord/fire_truck_small", 					"tag_body", 			"smallfire", 		undefined, 			undefined, 		true, 			0, true );
	maps\_vehicle::build_deathfx_override( "script_vehicle_pickup_technical_instant_death", "undefined", "vehicle_pickup_technical","maps/warlord/truck_vehicle_explosion", 	undefined, 				"car_explode", 		undefined, 			undefined, 		undefined, 		0.1, true );
	maps\_vehicle::build_deathfx_override( "script_vehicle_pickup_technical_instant_death", "undefined", "vehicle_pickup_technical","maps/warlord/fire_truck_small", 				"tag_fx_tire_right_r", 	"smallfire", 		undefined, 			undefined, 		true, 			0.1, true );
	maps\_vehicle::build_deathfx_override( "script_vehicle_pickup_technical_instant_death", "undefined", "vehicle_pickup_technical","maps/warlord/fire_truck", 					"tag_fx_cab", 			"smallfire", 		undefined, 			undefined, 		true, 			0.11, true );
	maps\_vehicle::build_deathfx_override( "script_vehicle_pickup_technical_instant_death", "undefined", "vehicle_pickup_technical","maps/warlord/fire_truck_small", 				"tag_engine_left", 		"smallfire", 		undefined, 			undefined, 		true, 			0.11, true );
	
	maps\_vehicle::build_deathfx_override( "script_vehicle_pickup_roobars_physics_instant_death", "truck_physics", "vehicle_pickup_roobars", "maps/warlord/fire_truck_small", 					"tag_body", 			"smallfire", 		undefined, 			undefined, 		true, 			0, true );
	maps\_vehicle::build_deathfx_override( "script_vehicle_pickup_roobars_physics_instant_death", "truck_physics", "vehicle_pickup_roobars","maps/warlord/truck_vehicle_explosion", 	undefined, 				"car_explode", 		undefined, 			undefined, 		undefined, 		0.1, true );
	maps\_vehicle::build_deathfx_override( "script_vehicle_pickup_roobars_physics_instant_death", "truck_physics", "vehicle_pickup_roobars","maps/warlord/fire_truck_small", 				"tag_fx_tire_right_r", 	"smallfire", 		undefined, 			undefined, 		true, 			0.1, true );
	maps\_vehicle::build_deathfx_override( "script_vehicle_pickup_roobars_physics_instant_death", "truck_physics", "vehicle_pickup_roobars","maps/warlord/fire_truck", 					"tag_fx_cab", 			"smallfire", 		undefined, 			undefined, 		true, 			0.11, true );
	maps\_vehicle::build_deathfx_override( "script_vehicle_pickup_roobars_physics_instant_death", "truck_physics", "vehicle_pickup_roobars","maps/warlord/fire_truck_small", 				"tag_engine_left", 		"smallfire", 		undefined, 			undefined, 		true, 			0.11, true );
	
	maps\_vehicle::build_deathfx_override( "script_vehicle_pickup_roobars_instant_death", "undefined", "vehicle_pickup_roobars", "maps/warlord/fire_truck_small", 					"tag_body", 			"smallfire", 		undefined, 			undefined, 		true, 			0, true );
	maps\_vehicle::build_deathfx_override( "script_vehicle_pickup_roobars_instant_death", "undefined", "vehicle_pickup_roobars","maps/warlord/truck_vehicle_explosion", 	undefined, 				"car_explode", 		undefined, 			undefined, 		undefined, 		0.1, true );
	maps\_vehicle::build_deathfx_override( "script_vehicle_pickup_roobars_instant_death", "undefined", "vehicle_pickup_roobars","maps/warlord/fire_truck_small", 				"tag_fx_tire_right_r", 	"smallfire", 		undefined, 			undefined, 		true, 			0.1, true );
	maps\_vehicle::build_deathfx_override( "script_vehicle_pickup_roobars_instant_death", "undefined", "vehicle_pickup_roobars","maps/warlord/fire_truck", 					"tag_fx_cab", 			"smallfire", 		undefined, 			undefined, 		true, 			0.11, true );
	maps\_vehicle::build_deathfx_override( "script_vehicle_pickup_roobars_instant_death", "undefined", "vehicle_pickup_roobars","maps/warlord/fire_truck_small", 				"tag_engine_left", 		"smallfire", 		undefined, 			undefined, 		true, 			0.11, true );
	
	maps\_vehicle::build_deathfx_override( "script_vehicle_pickup_technical_payback_instant_death", "undefined", "vehicle_pickup_technical_pb_rusted", "maps/warlord/fire_truck_small", 					"tag_body", 			"smallfire", 		undefined, 			undefined, 		true, 			0, true );
	maps\_vehicle::build_deathfx_override( "script_vehicle_pickup_technical_payback_instant_death", "undefined", "vehicle_pickup_technical_pb_rusted","maps/warlord/truck_vehicle_explosion", 	undefined, 				"car_explode", 		undefined, 			undefined, 		undefined, 		0.1, true );
	maps\_vehicle::build_deathfx_override( "script_vehicle_pickup_technical_payback_instant_death", "undefined", "vehicle_pickup_technical_pb_rusted","maps/warlord/fire_truck_small", 				"tag_fx_tire_right_r", 	"smallfire", 		undefined, 			undefined, 		true, 			0.1, true );
	maps\_vehicle::build_deathfx_override( "script_vehicle_pickup_technical_payback_instant_death", "undefined", "vehicle_pickup_technical_pb_rusted","maps/warlord/fire_truck", 					"tag_fx_cab", 			"smallfire", 		undefined, 			undefined, 		true, 			0.11, true );
	maps\_vehicle::build_deathfx_override( "script_vehicle_pickup_technical_payback_instant_death", "undefined", "vehicle_pickup_technical_pb_rusted","maps/warlord/fire_truck_small", 				"tag_engine_left", 		"smallfire", 		undefined, 			undefined, 		true, 			0.11, true );
}


setup_poison_wake_volumes()
{
		poison_wake_triggers = getentarray( "poison_wake_volume", "targetname" );
		array_thread( poison_wake_triggers, ::poison_wake_trigger_think);
}

poison_wake_trigger_think()
{
	for( ;; )
	{
		self waittill( "trigger", other );
		if (other ent_flag_exist("in_poison_volume"))
			{}
		else
			other ent_flag_init("in_poison_volume");
		
		if (isDefined (other) && DistanceSquared( other.origin, level.player.origin ) < 9250000)
		{	
			if (other ent_flag("in_poison_volume"))
			{}
			else
			{
				other thread poison_wakefx(self);
				other ent_flag_set ("in_poison_volume");
				/*if(isDefined (other.ainame))
					print(other.ainame + "has entered the poison volume\n");
				else
					print("player has entered the poison volume\n");*/
			}
		}
	}
}


poison_wakefx( parentTrigger )
{
	self endon( "death" );
	speed = 200;
	for ( ;; )
	{
		if (self IsTouching(parentTrigger))
		{
			//loop fx based off of player speed
			if (speed > 10)
				wait(max(( 1 - (speed / 120)),0.1) );
			else
				wait (0.15);
			//if ( trace[ "surfacetype" ] != "water" )
			//	continue;
	
			fx = parentTrigger.script_fxid;
			if ( IsPlayer( self ) )
			{
				speed = Distance( self GetVelocity(), ( 0, 0, 0 ) );
				if ( speed < 10 )
				{
					fx = "player_water_stop";
				}
			}
			if ( IsAI( self ) )
			{
				speed = Distance( self.velocity, ( 0, 0, 0 ) );
				if ( speed < 10 )
				{
					fx = "player_water_stop";
				}
			}
		
			start = self.origin + ( 0, 0, 64 );
			end = self.origin - ( 0, 0, 150 );
			trace = BulletTrace( start, end, false, undefined );
			water_fx = getfx( fx );
			start = trace[ "position" ];
			angles = vectortoangles( trace[ "normal" ] );
			angles = (0,self.angles[1],0);
			forward = anglestoforward( angles );
			up = anglestoup( angles );
			PlayFX( water_fx, start, up, forward );
			

		}
		else
		{	
			self ent_flag_clear("in_poison_volume");
				/*if(isDefined (self.ainame))
					print(self.ainame + "has exited the poison volume\n");
				else
					print("player has exited the poison volume\n");*/
			return;
		}
	}
}

hyena_village_fx()
{
	self endon( "death" );
	
	saliva_fx_2 = getfx( "hyena_saliva_fx_2" );
	blood_hyena_bite = getfx( "blood_hyena_bite" );
	
	for(;;)
	{
		playfxontag( saliva_fx_2, self, "tag_mouth_fx" );
		wait (0.5);
		playfxontag( blood_hyena_bite, self, "tag_mouth_fx" );
		wait (1.5);
		//60
		playfxontag( blood_hyena_bite, self, "tag_mouth_fx" );
		wait (1.0);
		playfxontag( blood_hyena_bite, self, "tag_mouth_fx" );
		wait (0.5);
		playfxontag( blood_hyena_bite, self, "tag_mouth_fx" );
		wait (1.1);
		playfxontag( blood_hyena_bite, self, "tag_mouth_fx" );
		wait (1.0);
		playfxontag( saliva_fx_2, self, "tag_mouth_fx" );
		wait (0.4);
		//180
		playfxontag( blood_hyena_bite, self, "tag_mouth_fx" );
		wait (0.5);
		playfxontag( saliva_fx_2, self, "tag_mouth_fx" );
		wait (0.5);
		playfxontag( blood_hyena_bite, self, "tag_mouth_fx" );
		wait (0.5);
		playfxontag( saliva_fx_2, self, "tag_mouth_fx" );
		wait (0.5);
		//240
		playfxontag( blood_hyena_bite, self, "tag_mouth_fx" );
		wait (0.5);
		playfxontag( blood_hyena_bite, self, "tag_mouth_fx" );
		wait (0.5);
		playfxontag( saliva_fx_2, self, "tag_mouth_fx" );
		wait (0.5);
		playfxontag( saliva_fx_2, self, "tag_mouth_fx" );
		wait (0.5);
		//300
		playfxontag( saliva_fx_2, self, "tag_mouth_fx" );
		wait (2.0);
		//360
		playfxontag( saliva_fx_2, self, "tag_mouth_fx" );
		wait (1.0);
	}
}  

fx_technical_splash()
{
	flag_wait("fx_technical_splash");	

	position = level.player.origin;
	aud_send_msg("player_technical_splashdown", position);
	PlayFX(getfx("player_splash"),position,(0,0,1),(0,1,0));
}        
