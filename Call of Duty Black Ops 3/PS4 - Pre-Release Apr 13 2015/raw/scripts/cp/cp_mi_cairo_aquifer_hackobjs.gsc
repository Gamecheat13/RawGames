#using scripts\shared\flag_shared;

#using scripts\cp\_hacking;
#using scripts\cp\_objectives;
#using scripts\cp\_skipto;

// WHAT DO I NEED THESE FOR?
/*
#precache( "string", "HACK_OBJ_STR_1" );
#precache( "string", "HACK_OBJ_STR_2" );
#precache( "string", "HACK_OBJ_STR_3" );
*/

#precache( "objective", "obj_attack_tanks");
#precache( "objective", "cp_mi_cairo_aquifer_hack_obj1" );
#precache( "objective", "cp_mi_cairo_aquifer_hack_obj2" );
#precache( "objective", "cp_mi_cairo_aquifer_hack_obj3" );
#precache( "objective", "cp_mi_cairo_aquifer_rappel"    );


function main()
{	
	init_skiptos();
}

function init_skiptos()
{
	/*
	// Objectives work in this state, except...
	// restarting or dying at the hack objectives, 
	// will pick a random skipto at any of the three hack objectives,
    // and reset completion of all hack objectives.
    //
    // treats all three as one?
    
	skipto::add_branch("tank_obj",         &skipto_attack_tanks,  "Attack the Tanks",      &done,   undefined,                           "hack_obj_1,hack_obj_2,hack_obj_3");
	skipto::add_branch("hack_obj_1",       &skipto_hack_1,        "Hack Objective 1",      &done,   "tank_obj",                          "rappel_obj");
	skipto::add_branch("hack_obj_2",       &skipto_hack_2,        "Hack Objective 2",      &done,   "tank_obj",                          "rappel_obj");
	skipto::add_branch("hack_obj_3",       &skipto_hack_3,        "Hack Objective 3",      &done,   "tank_obj",                          "rappel_obj");
	skipto::add_branch("rappel_obj",       &skipto_rappel,        "Rappel to Hangar",      &done,   "hack_obj_1&hack_obj_2&hack_obj_3",   undefined);
	
	skipto::add("tank_obj",   &skipto_attack_tanks, "Attack the Tanks", &done);
	skipto::add("hack_obj_1", &skipto_hack_1,       "Hack Objective 1", &done);
	skipto::add("hack_obj_2", &skipto_hack_2,       "Hack Objective 2", &done);
	skipto::add("hack_obj_3", &skipto_hack_3,       "Hack Objective 3", &done);
	skipto::add("rappel_obj", &skipto_rappel,       "Rappel to Hangar", &done);
	*/
	
}

function skipto_attack_tanks(a,b)
{
	tank_obj = GetEnt("tank_obj_target", "targetname");
	
	level.tank_targ = SpawnStruct();
	level.tank_targ.origin = tank_obj.origin;
	
	objectives::set("obj_attack_tanks", level.tank_targ);
	
	IPrintLn("waiting placeholder for attack tanks");
	
	wait 5;
	
	objectives::complete("obj_attack_tanks", level.tank_targ);
	
	skipto::objective_completed(a);
}

function skipto_hack_1(a,b)
{
	hack_trig_1 = GetEnt("exterior_hack_trig_1", "targetname");
	
	level.hack_trig1 = SpawnStruct();
	level.hack_trig1.origin = hack_trig_1.origin;
	
	objectives::set( "cp_mi_cairo_aquifer_hack_obj1", level.hack_trig1);
	
	hack_trig_1 hacking::init_hack_trigger(5);
	hack_trig_1 hacking::trigger_wait();
	
	objectives::complete("cp_mi_cairo_aquifer_hack_obj1", level.hack_trig1);
	
	skipto::objective_completed(a);
}

function skipto_hack_2(a,b)
{
	hack_trig_2 = GetEnt("exterior_hack_trig_2", "targetname");
	
	level.hack_trig2 = SpawnStruct();
	level.hack_trig2.origin = hack_trig_2.origin;
	
	objectives::set( "cp_mi_cairo_aquifer_hack_obj2", level.hack_trig2);
	
	hack_trig_2 hacking::init_hack_trigger(5);
	hack_trig_2 hacking::trigger_wait();
	
	objectives::complete("cp_mi_cairo_aquifer_hack_obj2", level.hack_trig2);
	
	skipto::objective_completed(a);
	
}

function skipto_hack_3(a,b)
{
	hack_trig_3 = GetEnt("exterior_hack_trig_3", "targetname");
	
	level.hack_trig3 = SpawnStruct();
	level.hack_trig3.origin = hack_trig_3.origin;
	
	objectives::set( "cp_mi_cairo_aquifer_hack_obj3", level.hack_trig3);
	
	hack_trig_3 hacking::init_hack_trigger(5);
	hack_trig_3 hacking::trigger_wait();
	
	objectives::complete("cp_mi_cairo_aquifer_hack_obj3", level.hack_trig3);
	
	skipto::objective_completed(a);
	
}

function skipto_rappel(a,b)
{
	rappel_obj = GetEnt("rappel_obj_target", "targetname");
	
	level.rappel_targ = SpawnStruct();
	level.rappel_targ.origin = rappel_obj.origin;
	
	objectives::set("cp_mi_cairo_aquifer_rappel", level.rappel_targ);
	
	IPrintLn("waiting placeholder for rappel...");
	
	wait 5;
	
	objectives::complete("cp_mi_cairo_aquifer_rappel", level.rappel_targ);
	
	skipto::objective_completed(a);
}

function done(a, b, c, d)
{
	IPrintLn("######## " + a + " is completed ########");
}