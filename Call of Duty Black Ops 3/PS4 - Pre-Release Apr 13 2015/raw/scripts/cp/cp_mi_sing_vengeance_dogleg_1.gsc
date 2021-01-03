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
#using scripts\shared\animation_shared;

#using scripts\cp\_debug;

#using scripts\cp\cp_mi_sing_vengeance_util;

    	   	                                                                                                                         	                                                                                                                                                                                                                                                                                                                                                                    	        	     	             	    	   	                           	                               	                                	                                                              	                                                                                                              	                            	                                     	                                       	                                                               	   	                  	       	                                                    	                   	                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                       	                                                                                        	           	                        	                                            	                                             	                                                   	                                                             	                                                         	                                                                    	                                                                                                                                                                                                    	                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                     	                                                              	                                                          	                                   	                                   	                                                    	                                       

#using scripts\cp\_util;

#namespace vengeance_dogleg_1;

function skipto_dogleg_1_init( str_objective, b_starting )
{	
	vengeance_util::skipto_baseline( str_objective, b_starting );
	
	if ( b_starting )
	{
		vengeance_util::init_hero( "hendricks", str_objective );
	}
	
	skipto::teleport_players( str_objective );
	skipto::teleport_ai( str_objective );
	
	dogleg_1_main( str_objective );
}

function dogleg_1_main( str_objective )
{
	level.ai_hendricks thread setup_dogleg_1_hendricks();
	
	level thread cafe_execution_setup();
	level thread cafe_burning_setup();
	level thread cafe_molotov_setup();
	
	//level thread dogleg_1_vo();
	
	//setup patrollers
    level.dogleg_1_patroller_spawners = spawner::simple_spawn( "dogleg_1_patroller_spawners", &vengeance_util::setup_patroller );
    
	//temp objective to leave dogleg 1
	trig = level.skipto_triggers[ str_objective ];
	if ( isdefined( trig ) )
	{
		trig.objective_target = struct::get( "dogleg_1_obj_struct", "targetname" );
		objectives::set( "obj_dogleg_1", level.skipto_triggers[ str_objective ].objective_target );
		
		trig trigger::wait_till();
	
		objectives::complete( "obj_dogleg_1", trig.objective_target );

		level thread cleanup_dogleg_1();
	}
}

function setup_dogleg_1_hendricks()
{
	//endon broke stealth
	self endon( "death" );
	
	self ai::set_ignoreall( true );
	self ai::set_ignoreme( true );
	self colors::disable();
	self ai::set_behavior_attribute( "cqb", true );
	self.goalradius = 32;
	
	node = getnode( "dogleg_1_hendricks_node_10", "targetname" );
	self ai::force_goal( node, node.radius );
	
	//self dialog::say( "Targets ahead.  Take this nice and easy, I'll cover you from here." );
	
	//Hendricks::"Contact.  Hold your fire.  54i all over the place."
	self dialog::say( "hend_contact_hold_your_0" );
	
	//Hendricks: I’ll provide overwatch from above, meet me at the rally point.
	self dialog::say( "hend_i_ll_provide_overwat_0" );
	
	node = getnode( "dogleg_1_hendricks_node_15", "targetname" );
	self ai::force_goal( node, node.radius );
	
	self Delete();
}

function dogleg_1_vo()
{
	wait 2;
	
	//"Hendricks: Kane, come in...what is your status?"
	level dialog::remote( "hend_kane_report_what_s_0" );
	
	//"Kane: static, garbled, 1 to 2 words of this make it out: I've got drones providing air cover, but the ground forces are breaking through, ammo running low..."
	level dialog::remote( "kane_i_ve_got_drones_prov_0" );
	
	//"Hendricks: Damn comms are still being jammed, they must be close, keep your eyes peeled."
	level dialog::remote( "hend_damn_comms_are_still_0" );
}


//*************************************
//CAFE EXECUTION
//*************************************
function cafe_execution_setup()
{
	level.cafe_execution_org = struct::get( "cafe_execution_org" );
	spawner::add_spawn_function_group( "cafe_execution_civ_spawners", "script_noteworthy", &cafe_execution_civ_spawn_func );
	spawner::add_spawn_function_group( "cafe_execution_thug_spawners", "script_noteworthy", &cafe_exeuction_thug_spawn_func );
	spawner::add_spawn_function_group( "cafe_execution_thug_spawners", "script_noteworthy", &cafe_exeuction_thug_death_watcher_spawn_func );
	level.cafe_execution_org scene::init( "cin_ven_04_20_cafeexecution_vign_intro" );
}

function cafe_execution_civ_spawn_func()
{
	self endon( "death" );
	
	self.team = "allies";
	self ai::set_ignoreme( true );
	self ai::set_ignoreall( true );
	self ai::set_behavior_attribute( "panic" , false );
	self.health = 1;
	
	self util::waittill_either( "try_to_escape", "kill_me" );

	if ( !level flag::get( "cafe_execution_thug_dead" ) )
	{
		self.takedamage = true;
		self.skipdeath = true;
		self.allowdeath = true;
		self Kill();
	}
	else
	{
		self scene::stop();
		self stopAnimScripted();
		{wait(.05);};
		self animation::play( self.script_parameters, level.cafe_execution_org.origin, level.cafe_execution_org.angles );
		
		if ( isdefined( self.target ) )
		{
			node = GetNode( self.target, "targetname" );
			self.goalradius = node.radius;
			self setGoal( node, false, node.radius );
		}
		
		self ai::set_behavior_attribute( "panic" , true );
	}
}

function cafe_exeuction_thug_spawn_func()
{
	self endon( "death" );
	
	self waittill( "alert", state );
	
	level.cafe_execution_org scene::play( "cin_ven_04_20_cafeexecution_vign_intro" );
}

function cafe_exeuction_thug_death_watcher_spawn_func()
{
	self waittill( "death" );
	
	level flag::set( "cafe_execution_thug_dead" );
	
	for( i = 1; i < 6; i++ )
	{
		guy = GetEnt( "cafe_execution_civ_0" + i + "_ai", "targetname" );
		
		if ( isDefined( guy ) && isAlive( guy ) )
		{
			guy notify( "try_to_escape" );
		}
	}
}


//*************************************
//CAFE BURNING
//*************************************
function cafe_burning_setup()
{
	level.cafe_burning_org = struct::get( "cafe_burning_org" );
	spawner::add_spawn_function_group( "cafe_burning_civ_spawners", "script_noteworthy", &cafe_burning_civ_spawn_func );
	spawner::add_spawn_function_group( "cafe_burning_thug_spawners", "script_noteworthy", &cafe_burning_thug_spawn_func );
	level.cafe_burning_org scene::init( "cin_ven_04_20_cafeburning_vign_loop" );
}

function cafe_burning_thug_spawn_func()
{
	self endon( "death" );
	
	self waittill( "cafe_burning_match_thrown" );
	
	level flag::set( "cafe_burning_match_thrown" );
}

function cafe_burning_civ_spawn_func()
{
	self endon( "death" );
	
	self.team = "allies";
	self ai::set_ignoreme( true );
	self ai::set_ignoreall( true );
	self ai::set_behavior_attribute( "panic" , false );
	self.health = 1;
	
	self waittill( "cafe_burning_check_for_escape" );
	
	if ( !level flag::get( "cafe_burning_match_thrown" ) )
	{
		self scene::stop( "cin_ven_04_20_cafeburning_vign_loop" );
		self stopanimscripted();
		
		{wait(.05);};
		
		self animation::play( self.script_parameters, level.cafe_burning_org.origin, level.cafe_burning_org.angles );
		
		if ( isdefined( self.target ) )
		{
			node = GetNode( self.target, "targetname" );
			self.goalradius = node.radius;
			self setGoal( node, false, node.radius );
		}
		
		self ai::set_behavior_attribute( "panic" , true );
	}
	else
	{
		self thread vengeance_util::set_civilian_on_fire( false );
		
		self waittill( "kill_me" );
		
		self.takedamage = true;
		self.skipdeath = true;
		self.allowdeath = true;
		self Kill();
	}
}


//*************************************
//CAFE MOLOTOV
//*************************************
function cafe_molotov_setup()
{
	level.cafe_molotov_org = struct::get( "cafe_molotov_org" );
	
	level.cafe_molotov_org thread scene::play( "cin_ven_04_20_cafemolotovflush_vign_intro" );
	
	wait 14;
	
	level.cafe_molotov_org thread scene::play( "cin_ven_04_20_cafemolotovflush_vign_civa" );
	{wait(.05);};
	guy = GetEnt( "cafe_molotov_civ_01_ai", "targetname" );
	guy thread vengeance_util::set_civilian_on_fire();
	
	wait randomFloatRange( 4.0, 8.0 );
	
	level.cafe_molotov_org thread scene::play( "cin_ven_04_20_cafemolotovflush_vign_civb" );
	{wait(.05);};
	guy = GetEnt( "cafe_molotov_civ_02_ai", "targetname" );
	guy thread vengeance_util::set_civilian_on_fire();
	
	wait randomFloatRange( 4.0, 8.0 );
	
	level.cafe_molotov_org thread scene::play( "cin_ven_04_20_cafemolotovflush_vign_civc" );
	{wait(.05);};
	guy = GetEnt( "cafe_molotov_civ_03_ai", "targetname" );
	guy thread vengeance_util::set_civilian_on_fire();
	
	wait randomFloatRange( 4.0, 8.0 );
	
	level.cafe_molotov_org thread scene::play( "cin_ven_04_20_cafemolotovflush_vign_civd" );
	{wait(.05);};
	guy = GetEnt( "cafe_molotov_civ_04_ai", "targetname" );
	guy thread vengeance_util::set_civilian_on_fire();
	
	wait randomFloatRange( 4.0, 8.0 );
	
	level.cafe_molotov_org thread scene::play( "cin_ven_04_20_cafemolotovflush_vign_cive" );
	{wait(.05);};
	guy = GetEnt( "cafe_molotov_civ_05_ai", "targetname" );
	guy thread vengeance_util::set_civilian_on_fire();
	
	wait randomFloatRange( 4.0, 8.0 );
	
	level.cafe_molotov_org thread scene::play( "cin_ven_04_20_cafemolotovflush_vign_civf" );
	{wait(.05);};
	guy = GetEnt( "cafe_molotov_civ_06_ai", "targetname" );
	guy thread vengeance_util::set_civilian_on_fire();
	
	wait randomFloatRange( 4.0, 8.0 );
	
	level.cafe_molotov_org thread scene::play( "cin_ven_04_20_cafemolotovflush_vign_civg" );
	{wait(.05);};
	guy = GetEnt( "cafe_molotov_civ_07_ai", "targetname" );
	guy thread vengeance_util::set_civilian_on_fire();
}

function dogleg_1_civilians_spawn_func( wait_flag )
{
	self endon( "death" );
	
	self.team = "allies";
	self ai::set_ignoreme( true );
	self ai::set_ignoreall( true );
	self ai::set_behavior_attribute( "panic" , false );
	self.health = 1;
	
	level flag::wait_till( wait_flag );
	
	{wait(.05);};
	
	if ( isdefined( self.script_parameters ) )
	{
		org = undefined;
		
		if ( IsSubStr( self.targetname, "cafe_execution_" ) )
	    {
			org = level.cafe_execution_org;
	    }
		else if ( IsSubStr( self.targetname, "cafe_burning_" ) )
	    {
			org = level.cafe_burning_org;
	    }
		else if ( IsSubStr( self.targetname, "cafe_molotov_" ) )
	    {
			org = level.cafe_molotov_org;
	    }
				
		self stopanimscripted();
		
		self animation::play( self.script_parameters, org.origin, org.angles );
	}
	
	self ai::set_ignoreme( false );
	self ai::set_ignoreall( false );
	
	if ( isdefined( self.target ) )
	{
		node = GetNode( self.target, "targetname" );
		self setGoal( node, false, node.radius );
	}
	
	self ai::set_behavior_attribute( "panic" , true );
}

function skipto_dogleg_1_done( str_objective, b_starting, b_direct, player )
{
}

//this should clean up all ents/scripting/etc...when the players cleared the area
function cleanup_dogleg_1()
{
	if ( isdefined( level.dogleg_1_patroller_spawners ) )
	{
		foreach ( enemy in level.dogleg_1_patroller_spawners ) 
		{
			if ( isdefined( enemy ) )
			{
				enemy stealth_status::clean_icon();
				enemy Delete();
			}
		}
	}
	
	array::run_all( GetCorpseArray(), &Delete );
}
