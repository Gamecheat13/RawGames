#include maps\_utility;
#include common_scripts\utility;
#include maps\_vehicle;
#include maps\afghanistan_utility;

//how to use this
//first hold down DPAD to select block, Left = West, right = East, Up = North, then Press down on one of the face keys
// X = mortar, Y is Stinger, B = RPG, so if you want Stinger on West Block, hold down Left on DPad and Press Y.
// 2 of each units are limited on the map at same time.


//basic setup for the entire script call this first.
load()
{
	
	level._unit_blocks = [];
	level._unit_blocks["north"] = Spawnstruct();
	level._unit_blocks["north"].direction = "north";
	level._unit_blocks["east"] = Spawnstruct();
	level._unit_blocks["east"].direction = "east";
	level._unit_blocks["west"] = Spawnstruct();
	level._unit_blocks["west"].direction = "west";
	
	level._tank_blocks["arena"] = Spawnstruct();
	level._tank_blocks["arena"].node = "muj_arena_tank_node";
	level._tank_blocks["block_west"] = Spawnstruct();
	level._tank_blocks["block_west"].node = "muj_bp1_tank_node";
	level._tank_blocks["block_north"] = Spawnstruct();
	level._tank_blocks["block_north"].node = "muj_bp2_tank_node";
	level._tank_blocks["block_east"] = Spawnstruct();
	level._tank_blocks["block_east"].node = "muj_bp3_tank_node";
	
//	level._unit_type["RPG"] = spawnstruct();
//	level._unit_type["RPG"][0].is_alive = true;
//	level._unit_type["RPG"][0].is_active = false;
//	level._unit_type["RPG"][1].is_alive = true;
//	level._unit_type["RPG"][1].is_active = false;
//	level._unit_type["Grenade"] = spawnstruct();
//	level._unit_type["Grenade"][0].is_alive = true;
//	level._unit_type["Grenade"][0].is_active = false;
//	level._unit_type["Grenade"][1].is_alive = true;
//	level._unit_type["Grenade"][1].is_active = false;
//	level._unit_type["stinger"] = spawnstruct();
//	level._unit_type["stinger"][0].is_alive = true;
//	level._unit_type["stinger"][0].is_active = false;
//	level._unit_type["stinger"][1].is_alive = true;
//	level._unit_type["stinger"][1].is_active = false;
	
	
	foreach( block in level._unit_blocks)
	{
		block setup_block();
	}
	setup_tank();
	
	display_unit_hud();
	//setup_control();

}

setup_tank()
{
	if( !isdefined( level.muj_tank ) )
	{
		level.muj_tank = spawn_vehicle_from_Targetname("muj_tank");	
	}
	
	//level.muj_tank thread veh_magic_bullet_shield(1);
	level.muj_tank SetNearGoalNotifyDist( 64 );

//	starting_node = getvehiclenode("muj_arena_tank_node", "targetname");
//	level.muj_tank SetBrake( false );	
//	level.muj_tank SetSpeed( 25, 15, 10 );
//	level.muj_tank setvehgoalpos( starting_node.origin, 1, 1);
//	level.muj_tank waittill_any( "goal", "near_goal" );
//	level.muj_tank SetBrake( true );	
}

//setup all the variables for the individual block.
setup_block()
{

	self.rpg_spawner = getent(self.direction + "_rpg_guy_spawn", "targetname");
	self.stinger_spawner = getent(self.direction + "_stinger_guy_spawn", "targetname");
	self.mortar_spawner = getent(self.direction + "_mortar_guy_spawn", "targetname");
	self.destination_nodes = [];
	self.destination_nodes = getnodearray(self.direction + "_block_unit_dest_node", "targetname");
	self.delete_node = getnode(self.direction + "_delete_node", "targetname");
}

//setup up all the units
setup_units()
{
	
	if(isDefined(self) && IsAlive(self))
	{
		self thread magic_bullet_shield();
		self.fixednode = true;
	}
	//self.ignoreall = true;
	
}
//pass in type of unit as a string
move_unit_in_position( type )
{
	
	count = 0;
	foreach( block in level._unit_blocks)
	{
		if(!isdefined(block.current_unit_type))
			continue;
		
		if(block.current_unit_type == type)
		{
			count += 1;
		}
	}
	
//	for(i = 0; i < level._unit_type[type].size; i++)
//	{
//		if( level._unit_type[type][i].is_alive == true && level._unit_type[type][i].is_active == false )
//		{
//			level._unit_type[type][i].is_active = true;
//			break;
//		}
//		else
//			count++;
//	}
	
	if(count >= 2)
		return;
	
	if(isdefined(self.current_unit_type))
	{
		//move them and delete them.
		if(type == self.current_unit_type)
		{
			return;		
		}
		else
		{
			num = self.current_unit.size;
			for(i = 0; i < num; i++)
			{
				self.current_unit[i] stop_magic_bullet_shield();
			}
			
			array_delete(self.current_unit);
		}
	}
	
	self.current_unit_type = type;

	units = [];
	if(type == "stinger")
	{
		for(i = 0 ; i < 2; i++)
		{
			units[i] = simple_spawn_single(self.stinger_spawner);
			units[i] setup_units();
			units[i] SetGoalNode(self.destination_nodes[i]);
			units[i] thread notify_unit_has_arived( self.direction );
			units[i].ignoreall = true;
			units[i].crew = true;
			wait(0.05);
		}
		
		units[ 0 ] thread stinger_crew_logic();
	}
	else if(type == "RPG")
	{
		for(i = 0 ; i < 2; i++)
		{
			units[i] = simple_spawn_single(self.rpg_spawner);
			units[i] setup_units();
			units[i] SetGoalNode(self.destination_nodes[i]);
			units[i] thread notify_unit_has_arived( self.direction );
			units[i].ignoreall = true;
			units[i].crew = true;
			wait(0.05);
		}
		
		units[ 0 ] thread rpg_crew_logic();
	}
	else if(type == "sniper")
	{
		for(i = 0 ; i < 2; i++)
		{
			units[i] = simple_spawn_single(self.mortar_spawner);
			units[i] setup_units();
			units[i] SetGoalNode(self.destination_nodes[i]);
			units[i] thread notify_unit_has_arived( self.direction );
			units[i].ignoreall = true;
			units[i].crew = true;
			wait(0.05);
		}
		
		units[ 0 ] thread sniper_crew_logic();
	}
	
	self.current_unit = units;
	
	if(self.direction == "north")
	{
		level._unit_hud_north setText( "North - " + type );
	}
	else if(self.direction == "west")
	{
		level._unit_hud_west setText( "West - " + type );
	}
	else if(self.direction == "east")
	{
		level._unit_hud_east setText( "East - " + type );
	}
}

remove_unit_from_blocking_point()
{
	if(isdefined(self.current_unit_type))
	{
		
		//move them and delete them.
		num = self.current_unit.size;
		for(i = 0; i < num; i++)
		{
			if(isDefined(self.current_unit[i]) && IsAlive(self.current_unit[i]))
			{
				self.current_unit[i] stop_magic_bullet_shield();
				self.current_unit[i] delete();
			}
		}
	}
}


// X = mortar, Y is Stinger, B = RPG
setup_control()
{
	player = get_players()[0];

	while(1)
	{
		if(player ButtonPressed("DPAD_UP"))
		{
			if(player ButtonPressed("Button_x"))
			{
				level._unit_blocks["north"] thread move_unit_in_position("sniper");	
			}
			else if(player ButtonPressed("Button_y"))
			{
				level._unit_blocks["north"] thread move_unit_in_position("stinger");
			}
			else if(player ButtonPressed("Button_B"))
			{
				level._unit_blocks["north"] thread move_unit_in_position("RPG");	
			}
			else if(player ButtonPressed("Button_A"))
			{
				level._tank_blocks["block_north"] thread move_tank_in_position();
			}
			
		}
		else if(player ButtonPressed("DPAD_LEFT"))
		{
			if(player ButtonPressed("Button_x"))
			{
				level._unit_blocks["west"] thread move_unit_in_position("sniper");	
			}
			else if(player ButtonPressed("Button_y"))
			{
				level._unit_blocks["west"] thread move_unit_in_position("stinger");
			}
			else if(player ButtonPressed("Button_B"))
			{
				level._unit_blocks["west"] thread move_unit_in_position("RPG");	
			}
			else if(player ButtonPressed("Button_A"))
			{
				level._tank_blocks["block_west"] thread move_tank_in_position();
			}
		}
		else if(player ButtonPressed("DPAD_RIGHT"))
		{
			if(player ButtonPressed("Button_x"))
			{
				level._unit_blocks["east"] thread move_unit_in_position("sniper");	
			}
			else if(player ButtonPressed("Button_y"))
			{
				level._unit_blocks["east"] thread move_unit_in_position("stinger");
			}
			else if(player ButtonPressed("Button_B"))
			{
				level._unit_blocks["east"] thread move_unit_in_position("RPG");	
			}
			else if(player ButtonPressed("Button_A"))
			{
				level._tank_blocks["block_east"] thread move_tank_in_position();
			}
		}
		else if(player ButtonPressed("DPAD_DOWN"))
		{
			if(player ButtonPressed("Button_A"))
			{
				level._tank_blocks["arena"] thread move_tank_in_position();
			}
				
		}
		wait(0.5);

	}

}
move_tank_in_position()
{
	
	if( !isdefined( level.muj_tank) )
	{
		return;
	}
	level.muj_tank notify("new_destination");
	level.muj_tank endon("death");
	level.muj_tank endon("new_destination");

	dest_node = getstruct( self.node, "targetname" );
	level.muj_tank ClearVehGoalPos();
	level.muj_tank SetBrake( false );
	level.muj_tank SetSpeed( 20, 15, 10 );
	level.muj_tank setvehgoalpos( dest_node.origin, 1, 1);
	level.muj_tank waittill_any( "goal", "near_goal" , "new_destination");
	level.muj_tank SetBrake( true );	
	
}

//draw location - unit type at top left of the screen
display_unit_hud()
{
	level._unit_hud_north = newHudElem();
	level._unit_hud_north.x = 30;
	level._unit_hud_north.y = 30;
	level._unit_hud_north.alignX = "left";
	level._unit_hud_north.alignY = "top";
	level._unit_hud_north.horzAlign = "fullscreen";
	level._unit_hud_north.vertAlign = "fullscreen";
	level._unit_hud_north setText( " " );
	
	level._unit_hud_west = newHudElem();
	level._unit_hud_west.x = 30;
	level._unit_hud_west.y = 40;
	level._unit_hud_west.alignX = "left";
	level._unit_hud_west.alignY = "top";
	level._unit_hud_west.horzAlign = "fullscreen";
	level._unit_hud_west.vertAlign = "fullscreen";
	level._unit_hud_west setText( " " );
	
	level._unit_hud_east = newHudElem();
	level._unit_hud_east.x = 30;
	level._unit_hud_east.y = 50;
	level._unit_hud_east.alignX = "left";
	level._unit_hud_east.alignY = "top";
	level._unit_hud_east.horzAlign = "fullscreen";
	level._unit_hud_east.vertAlign = "fullscreen";
	level._unit_hud_east setText( " " );
	
}



// return unit type currently in position at that block point.
// return a type string, example type = return_unit_at_location("east"); 
// it will return "Sniper", "Stinger", "RPG"
return_unit_at_location( location )
{
	return level._unit_blocks[ location ].current_unit_type;
}

notify_unit_has_arived( string )
{
	self waittill("goal");
	level notify(string + "_arrival");
}