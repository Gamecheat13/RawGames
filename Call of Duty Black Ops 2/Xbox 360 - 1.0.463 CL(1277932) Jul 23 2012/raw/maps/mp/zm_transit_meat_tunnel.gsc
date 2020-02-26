#include maps\mp\_utility;
#include common_scripts\utility;
#include maps\mp\zombies\_zm_utility;
#include maps\mp\zombies\_zm_race_utility;
#include maps\mp\zombies\_zm_game_module_meat_utility;


meat_start()
{
	init_tunnel_meat();
	level thread init_minigun_ring();
	level thread init_splitter_ring();
	init_ammo_ring();

	if(!isDefined(level.spawned_collmap))
	{
		level.spawned_collmap = Spawn( "script_model", (-9872, 1344, 0), 1 );
		level.spawned_collmap SetModel( "zm_collision_transit_tunnel_meat" );
		level.spawned_collmap DisconnectPaths();

		neon = Spawn( "script_model", (-9872, 1344, 0));
		neon SetModel( "zm_tunnel_encounters_neon" );				
	}	

	level maps\mp\zombies\_zm_game_module_meat::hide_non_meat_objects();
	level thread maps\mp\zombies\_zm_game_module_meat::setup_meat_world_objects();

	maps\mp\zombies\_zm_game_module::set_current_game_module(level.GAME_MODULE_MEAT_INDEX);
		
	maps\mp\zombies\_zm_game_module_meat::meat_player_initial_spawn();
	level thread maps\mp\zombies\_zm_game_module_meat::item_meat_reset(level._meat_start_point);
	level thread maps\mp\zombies\_zm_game_module_meat::spawn_meat_zombies();
	level thread maps\mp\zombies\_zm_game_module_meat::monitor_meat_on_team();	
	
	wait(1); 
	level thread link_traversals();
	level._dont_reconnect_paths = true;
	iprintlnbold("ZOMBIES ARE ATTRACTED TO THE TEAM WITH THE MEAT. STAY ALIVE AS LONG AS YOU CAN BY THROWING THE MEAT TO YOUR OPPONENTS SIDE");
	
}

init_tunnel_meat()
{
	level._meat_location = "tunnel";	
	level._meat_start_point = getstruct("meat_tunnel_spawn_point","targetname").origin;
	level._meat_team_1_zombie_spawn_points = getstructarray("meat_tunnel_team_1_zombie_spawn_points","targetname");
	level._meat_team_2_zombie_spawn_points = getstructarray("meat_tunnel_team_2_zombie_spawn_points","targetname");
	level._meat_team_1_volume = getent("meat_tunnel_team_1_volume","targetname");
	level._meat_team_2_Volume = getent("meat_tunnel_team_2_volume","targetname");
	flag_clear("zombie_drop_powerups");
	level.custom_intermission  = ::tunnel_meat_intermission;
	level.zombie_vars["zombie_intermission_time"] = 5;
	level._supress_survived_screen = 1;
	level thread maps\mp\zombies\_zm_game_module_meat::item_meat_clear();

}

//init_minigun_ring()
//{
//	wait(1);
//	if(isDefined(level._minigun_ring))
//	{
//		return;
//	}
//	ring_pos = getstruct("town_meat_minigun","script_noteworthy");
//	level._minigun_ring = spawn("script_model",ring_pos.origin);
//	level._minigun_ring.angles = ring_pos.angles;
//	level._minigun_ring setmodel(ring_pos.script_parameters);
//	
//	level._minigun_ring_clip = getent("town_meat_minigun_clip","script_noteworthy");
//	level._minigun_ring_clip linkto(level._minigun_ring);
//	level._minigun_ring_trig = getent("town_meat_minigun_trig","targetname");	
//	level._minigun_ring_trig enablelinkto();
//	level._minigun_ring_trig linkto(level._minigun_ring);		
//	level._minigun_ring thread rotate_ring(true);	
//	level._minigun_icon = spawn("script_model",level._minigun_ring_trig.origin);
//	level._minigun_icon SetModel( GetWeaponModel("minigun_zm" ) );
//	level._minigun_icon linkto(level._minigun_ring);
//	wait(.5);
//	playfxontag( level._effect["powerup_on"],level._minigun_icon,"tag_origin");
//	level thread ring_toss(level._minigun_ring_trig,"minigun");
//	level._minigun_ring thread move_ring();
//}

//init_ammo_ring()
//{
//	wait(1);
//	if(isDefined(level._ammo_ring))
//	{
//		return;
//	}
//	ring_pos = getstruct("town_meat_ammo","script_noteworthy");
//	level._ammo_ring = spawn("script_model",ring_pos.origin);
//	level._ammo_ring.angles = ring_pos.angles;
//	level._ammo_ring setmodel(ring_pos.script_parameters);
//	
//	level._ammo_ring_clip = getent("town_meat_ammo_clip","script_noteworthy");
//	level._ammo_ring_clip linkto(level._ammo_ring);
//	level._ammo_ring_trig = getent("town_meat_ammo_trig","targetname");	
//	level._ammo_ring_trig enablelinkto();
//	level._ammo_ring_trig linkto(level._ammo_ring);	
//	level._ammo_icon = spawn("script_model",level._ammo_ring_trig.origin);
//	level._ammo_icon SetModel( "zombie_ammocan" );
//	level._ammo_icon linkto(level._ammo_ring);
//	wait(.5);
//	playfxontag( level._effect["powerup_on"],level._ammo_icon,"tag_origin");
//	level thread ring_toss(level._ammo_ring_trig,"ammo");
//	level._ammo_ring thread move_ring();
//	level._ammo_ring thread rotate_ring(true);
//}

//init_splitter_ring()
//{
//	wait(1);
//	if(isDefined(level._splitter_ring))
//	{
//		return;
//	}
//	ring_pos = getstruct("town_meat_splitter","script_noteworthy");
//	level._splitter_ring = spawn("script_model",ring_pos.origin);
//	level._splitter_ring.angles = ring_pos.angles;
//	level._splitter_ring setmodel(ring_pos.script_parameters);
//	level._splitter_ring_trig1 = getent("town_meat_splitter_trig_1","targetname");	
//	level._splitter_ring_trig2 = getent("town_meat_splitter_trig_2","targetname");
//	level._splitter_ring_trig1 enablelinkto();
//	level._splitter_ring_trig2 enablelinkto();
//	level._splitter_ring notsolid();
//	level._meat_icon = spawn("script_model",level._splitter_ring.origin);
//	level._meat_icon setmodel(getweaponmodel("item_meat_zm"));
//	level._meat_icon linkto(level._splitter_ring);
//	
//	wait(.5);
//	playfxontag(level._effect["meat_glow"],level._meat_icon,"tag_origin");
//	level._splitter_ring_trig1 linkto(level._splitter_ring);
//	level._splitter_ring_trig2 linkto(level._splitter_ring);
//	level._splitter_ring.angles = (90, 200, 160);
//	level thread ring_toss(level._splitter_ring_trig1,"splitter");
//	level thread ring_toss(level._splitter_ring_trig2,"splitter");
//	level._splitter_ring thread move_ring();
//}

//move_ring()
//{
//	positions = [];
//	positions[0] = (1583 ,-591, self.origin[2]);
//	positions[1] = (1254, -158 ,self.origin[2]);
//	
//	positions = array_randomize(positions);
//	level endon("end_race");
//	
//	while(1)
//	{
//		foreach(position in positions)
//		{
//			self moveto(position,randomintrange(30,45));
//			self waittill("movedone");
//		}
//	}
//}
//
//rotate_ring(forward)
//{
//	level endon("end_game");
//	dir = -360;
//	if(forward)
//	{
//		dir = 360;
//	}
//	while(1)
//	{
//		self rotateyaw(dir,9);
//		wait(9);
//	}
//}

//ring_toss(trig,type)
//{
//	level endon("end_game");
//	
//	while(1)
//	{
//		if(is_true(level._ring_triggered))
//		{
//			wait(.05);
//			continue;
//		}
//		if( is_true(level._meat_moving) )
//		{
//			if( isDefined(level.item_meat) && level.item_meat istouching(trig))
//			{
//				level thread ring_toss_prize(type,trig);
//				level._ring_triggered = true;
//				level thread ring_cooldown();
//			}
//		}
//		wait(.05);
//	}
//}
//
//ring_cooldown()
//{
//	wait(3);
//	level._ring_triggered = false;
//}

//ring_toss_prize(type,trig)
//{
//	switch(type)
//	{
//		case "splitter":
//			level thread meat_splitter(trig);
//			break;
//		case "minigun":
//			level thread minigun_prize(trig);
//			break;
//		case "ammo":
//			level thread ammo_prize(trig);
//			break;
//	}
//	
//}

//meat_splitter(trig)
//{
//	level endon("meat_grabbed");
//	level endon("meat_kicked");
//		
//	while(isDefined(level.item_meat) && level.item_meat istouching(trig))
//	{
//		wait(.05);
//	}
//	exit_trig = getent(trig.target,"targetname");
//	exit_struct = getstruct(trig.target,"targetname");
//	while(isDefined(level.item_meat) && !level.item_meat istouching(exit_trig) )
//	{
//		wait(.05);
//	}
//	while(isDefined(level.item_meat) && level.item_meat istouching(exit_trig))
//	{
//		wait(.05);
//	}
//	
//	if(!isDefined(level.item_meat))
//	{
//		return;
//	}
//	playfx(level._effect["fw_burst"],exit_trig.origin);
//	
//	flare_dir = VectorNormalize(anglestoforward(exit_struct.angles));
//	velocity = VectorScale( flare_dir, RandomIntRange(400, 600));
//	
//	velocity1 = (velocity[0] + 75, velocity[1] + 75 ,randomintrange(75,125));
//	velocity2 = (velocity[0] - 75,velocity[1] - 75 ,randomintrange(75,125));
//	velocity3 = (velocity[0] ,velocity[1] ,100);
//	level._fake_meats = [];
//	level._meat_splitter_activated = true;
//	org = exit_trig.origin;
//	level.item_meat delete();	
//	wait_network_frame();		
//	GET_PLAYERS()[0]._spawning_meat = true;		
//	level._fake_meats[level._fake_meats.size] = GET_PLAYERS()[0] MagicGrenadeType( level.item_meat_name, org, velocity1);
//	wait_network_frame();
//	level._fake_meats[level._fake_meats.size] = GET_PLAYERS()[0] MagicGrenadeType( level.item_meat_name, org, velocity2 );
//	wait_network_frame();
//	level._fake_meats[level._fake_meats.size]= GET_PLAYERS()[0] MagicGrenadeType( level.item_meat_name, org, velocity );
//	
//	real_meat = random(level._fake_meats);
//	real_meat._fake_meat = false;
//	foreach(meat in level._fake_meats)
//	{
//		if(real_meat != meat)
//		{
//			meat._fake_meat = true;
//		}
//		meat thread maps\mp\zombies\_zm_game_module_meat::delete_on_real_meat_pickup();
//	}	
//}

//minigun_prize(trig)
//{
//	while(isDefined(level.item_meat) && level.item_meat istouching(trig))
//	{
//		wait(.05);
//	}
//	if(!isDefined(level.item_meat))
//	{
//		return;
//	}
//	if(is_true(level._minigun_toss_cooldown))
//	{
//		return;
//	}
//	level thread minigun_toss_cooldown();
//	level._last_person_to_throw_meat thread maps\mp\zombies\_zm_powerups::powerup_vo("minigun");
//	level thread maps\mp\zombies\_zm_powerups::minigun_weapon_powerup( level._last_person_to_throw_meat );
//	
////	velocity = level.item_meat getvelocity();	
////	velocity1 = (velocity[0] *-1,velocity[1] *-1 ,velocity[2]);
////	org = level.item_meat.origin;
////	fake_powerup = spawn("script_model",org);
////	fake_powerup setmodel("tag_origin");
////	wait(.5);
////	playfxontag(level._effect["powerup_on"],fake_powerup,"tag_origin");
////	powerup_org = level._last_person_to_throw_meat.origin; 
////	time = fake_powerup fake_physicslaunch(powerup_org ,velocity1[2]*.75);
////	if(time +.05 < 0 )
////	{
////		time = 1;
////	}
////	playfx(level._effect["transporter_start"],	powerup_org + (0,0,30));
////	wait(time+.05);
////	powerup_org = powerup_org + (0,0,15);
////	fake_powerup delete();
////	wait(1);	
////	level thread maps\mp\zombies\_zm_powerups::specific_powerup_drop( "minigun", 	powerup_org );
//}
//
//ammo_prize(trig)
//{
//	while(isDefined(level.item_meat) && level.item_meat istouching(trig))
//	{
//		wait(.05);
//	}
//	if(!isDefined(level.item_meat))
//	{
//		return;
//	}
//	if(is_true(level._ammo_toss_cooldown))
//	{
//		return;
//	}
//	playfx(level._effect["poltergeist"],trig.origin);
//	level thread ammo_toss_cooldown();
//	level._last_person_to_throw_meat thread maps\mp\zombies\_zm_powerups::powerup_vo("full_ammo");
//	level thread maps\mp\zombies\_zm_powerups::full_ammo_powerup(undefined,level._last_person_to_throw_meat);
//}


//minigun_toss_cooldown()
//{
//	level._minigun_toss_cooldown = true;
//	if(isDefined(level._minigun_icon))
//	{
//		level._minigun_icon delete();
//		
//	}
//	waittill_any_or_timeout(120,"meat_end");
//	playfx(level._effect["poltergeist"],level._minigun_ring_trig.origin);
//	level._minigun_icon = spawn("script_model",level._minigun_ring_trig.origin);
//	level._minigun_icon SetModel( GetWeaponModel("minigun_zm" ) );
//	level._minigun_icon linkto(level._minigun_ring);
//	wait_network_frame();
//	playfxontag( level._effect["powerup_on"],level._minigun_icon,"tag_origin");
//	level._minigun_toss_cooldown = false;
//	
//}

//ammo_toss_cooldown()
//{
//	
//	level._ammo_toss_cooldown = true;
//	if(isDefined(level._ammo_icon))
//	{
//		level._ammo_icon delete();
//		
//	}
//	waittill_any_or_timeout(60,"meat_end");
//	playfx(level._effect["poltergeist"],level._ammo_ring_trig.origin);
//	level._ammo_icon = spawn("script_model",level._ammo_ring_trig.origin);
//	level._ammo_icon SetModel( "zombie_ammocan" );
//	level._ammo_icon linkto(level._ammo_ring);
//	wait_network_frame();
//	playfxontag( level._effect["powerup_on"],level._ammo_icon,"tag_origin");
//	level._ammo_toss_cooldown = false;
//	
//}

//connect the traversals
link_traversals()
{
	if(is_true(level._traversals_linked))
	{
		return;
	}
	level._traversals_linked = true;
	traversal_nodes = getnodearray("meat_tunnel_barrier_traversals","targetname");
	for(i=0;i<traversal_nodes.size;i++)
	{
		end_node = getnode(traversal_nodes[i].target,"targetname");
		UnLinkNodes(traversal_nodes[i],end_node);
		wait(.05);
	}
	wait(1);
	for(i=0;i<traversal_nodes.size;i++)
	{
		end_node = getnode(traversal_nodes[i].target,"targetname");
		LinkNodes(traversal_nodes[i],end_node);
	}
}

//connect the traversals
unlink_traversals()
{
	level waittill("link_traversals");
	traversal_nodes = getnodearray("meat_town_barrier_traversals","targetname");

	for(i=0;i<traversal_nodes.size;i++)
	{
		end_node = getnode(traversal_nodes[i].target,"targetname");
		LinkNodes(traversal_nodes[i],end_node);
		wait(.05);
	}	
	for(i=0;i<traversal_nodes.size;i++)
	{
		end_node = getnode(traversal_nodes[i].target,"targetname");
		UnLinkNodes(traversal_nodes[i],end_node);
	}
}

tunnel_meat_intermission()
{
	self maps\mp\zombies\_zm_game_module::game_module_custom_intermission("tunnel_meat_intermission_cam");
}