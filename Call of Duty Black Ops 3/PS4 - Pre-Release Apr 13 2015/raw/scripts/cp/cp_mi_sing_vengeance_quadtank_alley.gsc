#using scripts\codescripts\struct;

#using scripts\shared\ai_shared;
#using scripts\shared\array_shared;
#using scripts\shared\callbacks_shared;
#using scripts\shared\clientfield_shared;
#using scripts\shared\flag_shared;
#using scripts\shared\system_shared;
#using scripts\shared\colors_shared;

#using scripts\shared\spawner_shared;
#using scripts\shared\trigger_shared;
#using scripts\shared\util_shared;
#using scripts\shared\scene_shared;
#using scripts\cp\_spawn_manager;
#using scripts\cp\_util;
#using scripts\cp\_objectives;
#using scripts\cp\_skipto;
#using scripts\cp\_dialog;
#using scripts\shared\stealth;
#using scripts\shared\stealth_status;
#using scripts\shared\vehicles\_quadtank;
#using scripts\shared\vehicle_ai_shared;
#using scripts\shared\vehicle_shared;
#using scripts\shared\vehicles\_quadtank;
#using scripts\shared\turret_shared;

#using scripts\cp\cp_mi_sing_vengeance_util;

    	   	                                                                                                                         	                                                                                                                                                                                                                                                                                                                                                                    	        	     	             	    	   	                           	                               	                                	                                                              	                                                                                                              	                            	                                     	                                       	                                                               	   	                  	       	                                                    	                   	                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                       	                                                                                        	           	                        	                                            	                                             	                                                   	                                                             	                                                         	                                                                    	                                                                                                                                                                                                    	                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                     	                                                              	                                                          	                                   	                                   	                                                    	                                       

#using scripts\cp\_util;

#namespace vengeance_quadtank_alley;

function skipto_quadtank_alley_init( str_objective, b_starting )
{	
	vengeance_util::skipto_baseline( str_objective, b_starting );
	
	if ( b_starting )
	{
	}
	vengeance_util::init_hero( "hendricks", str_objective );
	
	quadtank_alley_main( str_objective );
}

function quadtank_alley_main( str_objective )
{
    spawner::add_spawn_function_group( "quadtank_alley_civilian_spawners", "script_noteworthy", &setup_quadtank_alley_civilian );
    spawner::add_spawn_function_group( "quadteaser_civs", "script_noteworthy", &setup_quadteaser_civs );
	spawner::add_spawn_function_group( "quadteaser_qt", "script_noteworthy", &quadtank_alley_quadtank_setup );
    
    level.ai_hendricks thread setup_quadtank_alley_hendricks();
}

function quadtank_alley_quadtank_setup()
{
	self endon( "death" );
	
	self ai::set_ignoreall( true );
	self ai::set_ignoreme( true );
	
	self vehicle_ai::start_scripted( true );
	self util::magic_bullet_shield();
	
	self thread quadtank_alley_quadtank_notetracks();
	
	while ( 1 )
	{
		self waittill( "damage", attacker );
		
		if ( isDefined( attacker ) && isPlayer( attacker ) )
		{
			break;
		}
	}
	
	level notify( "quadtank_alley_backup" );
}

function quadtank_alley_quadtank_notetracks()
{
	self endon( "death" );
	
	self thread quadtank_fire_missile_watcher();
	self thread quadtank_fire_mg_watcher();
}

function quadtank_fire_missile_watcher()
{
	self endon( "death" );
	
	while ( 1 )
	{
		self waittillmatch( "qt_fire_missile" );
		
		self fireweapon( 0 );
	}
}

function quadtank_fire_mg_watcher()
{
	self endon( "death" );
	
	while ( 1 )
	{
		self waittillmatch( "qt_fire_mg_on" );
		
		self thread turret::fire_for_time( -1, 1 );
		self thread turret::fire_for_time( -1, 2 );
		
		self waittillmatch( "qt_fire_mg_off" );
		
		self notify( "_stop_turret1" );
		self notify( "_stop_turret2" );
	}
}

function setup_quadtank_alley_hendricks()
{
	//endon broke stealth
	self endon( "death" );
	
	self ai::set_ignoreall( true );
	self ai::set_ignoreme( true );
	self colors::disable();
	self ai::set_behavior_attribute( "cqb", true );
	self.goalradius = 32;
	objectives::set( "cp_standard_follow_breadcrumb", self );
	
	self thread dialog::say( "Something big headed our way." );
	
	node = getnode( "quadtank_alley_hendricks_node_05", "targetname" );
	self thread ai::force_goal( node, node.radius );
	level flag::wait_till( "move_quadtank_alley_hendricks_node_10" );
	
	self thread dialog::say( "Quick...get to the rooftops." );
	
	self ai::set_behavior_attribute( "cqb", false );
	
	node = getnode( "quadtank_alley_hendricks_node_10", "targetname" );
	self thread ai::force_goal( node, node.radius );
}

function setup_quadtank_alley_civilian()
{
	self endon( "death" );
	
	self.team = "allies";
	self ai::set_behavior_attribute( "panic" , false );
	self.health = 1;
	node = GetNode( self.target, "targetname" );
	self setgoalnode( node, true, node.radius );
}

function setup_quadteaser_civs()
{
	self endon( "death" );
	
	self.team = "allies";
	self ai::set_ignoreall( true );
	self ai::set_ignoreme( true );
	self ai::set_behavior_attribute( "panic" , false );
	self.health = 1;
}

function skipto_quadtank_alley_done( str_objective, b_starting, b_direct, player )
{
	level thread cleanup_quadtank_alley();
}

//this should clean up all ents/scripting/etc...when the players cleared the area
function cleanup_quadtank_alley()
{
	array::run_all( GetCorpseArray(), &Delete );
}