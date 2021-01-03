#using scripts\codescripts\struct;

#using scripts\shared\ai_shared;
#using scripts\shared\array_shared;
#using scripts\shared\callbacks_shared;
#using scripts\shared\clientfield_shared;
#using scripts\shared\flag_shared;
#using scripts\shared\system_shared;

#using scripts\shared\spawner_shared;
#using scripts\shared\trigger_shared;
#using scripts\shared\colors_shared;
#using scripts\shared\util_shared;
#using scripts\shared\scene_shared;
#using scripts\shared\math_shared;
#using scripts\shared\turret_shared;
#using scripts\shared\ai_sniper_shared;
#using scripts\cp\_spawn_manager;
#using scripts\cp\_util;
#using scripts\cp\_objectives;
#using scripts\cp\_skipto;
#using scripts\cp\_dialog;
#using scripts\shared\stealth;

#using scripts\cp\_debug;
#using scripts\cp\sidemissions\_sm_ui;

#using scripts\cp\cp_mi_sing_vengeance_util;

    	   	                                                                                                                         	                                                                                                                                                                                                                                                                                                                                                                    	        	     	             	    	   	                           	                               	                                	                                                              	                                                                                                              	                            	                                     	                                       	                                                               	   	                  	       	                                                    	                   	                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                       	                                                                                        	           	                        	                                            	                                             	                                                   	                                                             	                                                         	                                                                    	                                                                                                                                                                                                    	                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                     	                                                              	                                                          	                                   	                                   	                                                    	                                       

#using scripts\cp\_util;



#namespace vengeance_garage;

/***********************************
 * -- Parking Garage Arena --
 * -- Avoid Snipers --
 * ********************************/

function skipto_garage_init( str_objective, b_starting )
{
	if( b_starting )
	{
		vengeance_util::skipto_baseline();
		
		vengeance_util::init_hero( "hendricks", str_objective );
		
		level flag::wait_till( "all_players_spawned" );
	}
				
	//Run main checkpoint functions	
//	level thread generic_vignette_setup(); // dedwards - commented from string refernce problem stemming from scene::play spammed every frame
	level thread garage_enemies();
	level.ai_hendricks thread garage_hendricks();
	garage_main();
}

function skipto_garage_done( str_objective, b_starting, b_direct, player )
{

	if ( isdefined( level.a_garage_patrollers ) )
	{
		foreach ( e_enemy in level.a_garage_patrollers ) 
		{
			if ( isdefined( e_enemy ) )
			{
				e_enemy Delete();
			}
		}
	}
	
	if ( isdefined( level.a_garage_snipers ) )
	{
		foreach ( e_enemy in level.a_garage_snipers ) 
		{
			if ( isdefined( e_enemy ) )
			{
				e_enemy Delete();
			}
		}
	}
		
	if ( isdefined( level.e_garage_rpg ) )
	{
		foreach ( e_enemy in level.e_garage_rpg ) 
		{
			if ( isdefined( e_enemy ) )
			{
				e_enemy Delete();
			}
		}
	}
}


function garage_main()
{
	skipto::teleport_players( "garage", undefined );
	level.ai_hendricks skipto::teleport_single_ai( struct::get( "garage_hendricks" , "targetname" ) );

	level thread garage_igc();
	

	
//	a_players = GetPlayers();
//	foreach( e_player in a_players )
//	{
//		e_player Freezecontrols( true );
//		e_player setClientUIVisibilityFlag( "hud_visible", 0 );
//	}
//	
//	text_array = [];
//	text_array[ 0 ] = "This area starts with an IGC showing 54i";
//	text_array[ 1 ] = "hanging civilians from the parking structure.";
//	text_array[ 2 ] = "Police enter from the right but are attacked by";
//	text_array[ 3 ] = "snipers.  The player must navigate to the structure";
//	text_array[ 4 ] = "while avoiding sniper fire.  While stealth is still";
//	text_array[ 5 ] = "active, it is unlikely to stay that way.";
//	
//	debug::debug_info_screen( text_array );
//
//	foreach( e_player in a_players )
//	{
//		e_player Freezecontrols( false );
//		e_player setClientUIVisibilityFlag( "hud_visible", 1 );
//	}	
	
	level flag::wait_till( "garage_igc_done" );
	obj_loc = struct::get( "obj_gather_market", "targetname" );
	objectives::set( "cp_level_vengeance_gather_market", obj_loc );
	
	level flag::wait_till_all( array( "hendricks_at_market", "players_at_market" ) );
	objectives::complete( "cp_level_vengeance_gather_market" );
	
	level flag::set( "entering_market" );
//	e_entry_door = GetEnt( "market_shop_entry_door", "targetname" );
//	e_entry_door thread vengeance_util::handle_door( 2 );
	
//	level flag::wait_till( "players_in_market" );
//	e_entry_door thread vengeance_util::handle_door( 2, true );
	
	skipto::objective_completed( "garage" );
}

function garage_igc()
{
	s_anim_node = struct::get( "garage_igc_script_node", "targetname" );
	
	garage_igc_scene_setup();
	
	level thread garage_igc_notifies();
		
	s_anim_node scene::play( "cin_ven_06_10_parkingstructure_3rd_main" );
	
	level flag::set( "garage_igc_done" );
	
	//this line is not playing??
	//Hendricks: Quick! Take cover!
	//level.ai_hendricks dialog::say( "hend_quick_take_cover_0" );
	//level dialog::remote( "hend_quick_take_cover_0" );
	
	wait(0.5);
	
	//Hendricks: We’ll have to move car to car, get to the parking structure!
	level.ai_hendricks dialog::say( "hend_we_ll_have_to_move_c_0" );
}

function garage_igc_notifies()
{
	level waittill( "garage_igc_fire_rpg" );
	
	foreach( e_car in level.a_garage_police_cars )
	{
		if( e_car.animname == "cop_car_8" )
		{
			level.exploding_police_car = e_car;
		}
	}
	
	magicbullet( level.garage_rpg_guy.weapon, level.garage_rpg_guy gettagorigin( "tag_flash" ), level.exploding_police_car gettagorigin( "tag_hood_animate" ));
}

function garage_igc_scene_setup()
{
	//Sniper 1
    e_sniper1_spawner = getent( "garage_enemy_a", "targetname" );
    e_sniper1_spawner spawner::add_spawn_function( &setup_sniper, true );
    
    //Sniper 2
    e_sniper2_spawner = getent( "garage_enemy_b", "targetname" );
    e_sniper2_spawner spawner::add_spawn_function( &setup_sniper, true );

	//RPG enemy
    e_rpg_spawner = getent( "garage_enemy_c", "targetname" );
    e_rpg_spawner spawner::add_spawn_function( &setup_rpg );
	    
    //Civs
    a_civ_spawners = getentarray( "garage_civs", "script_noteworthy" );
    foreach( e_spawner in a_civ_spawners )
	{
		e_spawner spawner::add_spawn_function( &setup_civ );
	}
    
    //Cars
    level.a_garage_police_cars = getentarray( "garage_police_cars", "script_noteworthy" );
    for( i = 0; i < level.a_garage_police_cars.size; i++ )
	{
    	level.a_garage_police_cars[ i ].animname = "cop_car_" + ( i + 1 );
	}
}

function garage_hendricks()
{
	self ai::set_ignoreall( true );
	self ai::set_ignoreme( true );
	self.goalradius = 32;
	
	level flag::wait_till( "garage_igc_done" );
	
	trigger::use( "hendricks_sniper_color" ); //starts color navigation.
	
	level flag::wait_till( "entering_market" );
	self colors::disable();
	
//	wait( 1.5 ); //waiting for door to open.
//	e_node = GetNode( "hendricks_market_entry_node", "targetname" );
//	self setgoalnode( e_node, true );
//	
//	self waittill( "goal" );

//	//The safehouse is too hot for extraction.  We need to find something more secure.
//	self dialog::say( "hend_the_safehouse_is_too_0", 0 );
}

function garage_enemies()
{
	//Set up Garage patrollers
//    a_patroller_spawners = getentarray( "garage_patroller_spawners", "targetname" );
//    foreach ( e_spawner in a_patroller_spawners )
//    {
//    	e_spawner spawner::add_spawn_function( &vengeance_util::setup_patroller );
//    }
//    
//    level.a_garage_patrollers = spawner::simple_spawn( "garage_patroller_spawners" );		

	//Set up Snipers   
    a_sniper_spawners = getentarray( "garage_snipers", "targetname" );
    foreach ( e_spawner in a_sniper_spawners )
    {
    	e_spawner spawner::add_spawn_function( &setup_sniper );
    }
    
    level.a_garage_snipers = spawner::simple_spawn( "garage_snipers" );
    
}

function setup_sniper( igc_guy )
{
	//self is AI.
	self endon( "death" );

	self stealth::stop();
    self ai::set_ignoreall( true );
    self ai::set_ignoreme( true );
	
	self.overrideActorDamage = &monitor_damage;

	if( isdefined( igc_guy ) && igc_guy == true )
	{
		level flag::wait_till( "garage_igc_done" );		
	}
	else
	{
		e_node = getnode( self.target, "targetname" );
		self setgoal( e_node, true );
		
		self waittill( "goal" );
	}

	if ( isDefined( self.script_noteworthy ) )
	{
		a_aimpoints = getentarray( self.script_noteworthy, "targetname" );
		
		v_aimpoints = [];
		foreach( e_aimpoint in a_aimpoints )
		{
			v_aimpoints[ v_aimpoints.size ] = e_aimpoint.origin;
		}
		
		self thread ai_sniper::actor_lase_points_behavior( v_aimpoints );
	}
}

function setup_rpg()
{
	self.overrideActorDamage = &monitor_damage;
	
	self stealth::stop();
	self ai::set_ignoreall( true );
	self ai::set_ignoreme( true );
	
	// dont actually pull the trigger
    self.holdfire = true;    
	
	// aim at target even when visually obstructed
	self.blindaim = true;

	// dont relocate just stay put
	self.goalradius = 8;
	
	level.garage_rpg_guy = self;
	
	level flag::wait_till( "garage_igc_done" );
	
//	self garage_rpg_behavior();
}

function setup_civ()
{
	self stealth::stop();
	self ai::set_ignoreall( true );
	self ai::set_ignoreme( true );
	
	if( self.script_noteworthy == "civilian_1" )
	{
		self.animname = "civilian_1";
	}
	if( self.script_noteworthy == "civilian_2" )
	{
		self.animname = "civilian_2";
	}
	if( self.script_noteworthy == "civilian_3" )
	{
		self.animname = "civilian_3";
	}
}

function garage_rpg_behavior()
{
	self endon( "death" );
	
	a_cars = GetEntArray( "garage_police_cars", "script_noteworthy" );
		
	//RPG guy randomly blows up certain cop cars.
//	while( 1 )
//	{
//		wait( RandomFloatRange( 8.0, 11.0 ));
//
//		e_car_target = array::random( a_cars );
//		
//		if( !isdefined( e_car_target ))
//		{
//			continue;
//		}
//		
//		e_car_target_offset = Spawn( "script_model", e_car_target.origin + ( 0, 0, 48 ) );
//		e_car_target_offset SetModel( "tag_origin" );
////		e_car_target_offset hide();
//		e_car_target_offset.health = 1;
//				
//		self ai::set_ignoreall( false );
//		self.holdfire = false;    
//
//		ai::shoot_at_target( "normal", e_car_target_offset, "tag_origin", 1.0 );
//		
//		wait 1;
//		self ai::set_ignoreall( true );
//		self.holdfire = true; 
//		
//		e_car_target_offset delete();
//	}
}

function monitor_damage( eInflictor, eAttacker, iDamage, iDFlags, sMeansOfDeath, weapon, vPoint, vDir, sHitLoc, modelIndex, psOffsetTime, boneName )
{
	//Don't let cops or Hendricks kill snipers.  Only players can kill them.
	if ( IsDefined( eAttacker ) && !isplayer( eAttacker ) )
	{
		iDamage = 0;
	}
	
	return iDamage;
}

function generic_vignette_setup()
{
	a_vign = struct::get_array( "garage_vign", "targetname" );

	a_vign_guy_array = [];
	
	foreach( s_vign in a_vign )
	{
		e_vign_guy = spawner::simple_spawn_single( "garage_vign_spawner" );
		e_vign_guy.team = "allies";
		e_vign_guy ai::set_ignoreall( true );
		e_vign_guy ai::set_ignoreme( true );
		e_vign_guy stealth::stop();
		array::add( a_vign_guy_array, e_vign_guy );
		
		level thread generic_vignette_play( s_vign, e_vign_guy );
		
		e_vign_guy.allowdeath = false;	
	}
	
	level flag::wait_till( "players_in_market" );
	wait 2;
	
	foreach( e_vign_guy in a_vign_guy_array )
	{
		if( IsDefined( e_vign_guy ) )
		{
			e_vign_guy stopanimscripted();
			e_vign_guy Delete();
		}
	}
	
}

function generic_vignette_play( s_vign, e_guy )
{
	level endon( "players_in_market" );
	e_guy endon( "death" );

	while( 1 )
	{
		s_vign scene::play( s_vign.script_noteworthy, e_guy );
		wait 0.05;
	}

}
