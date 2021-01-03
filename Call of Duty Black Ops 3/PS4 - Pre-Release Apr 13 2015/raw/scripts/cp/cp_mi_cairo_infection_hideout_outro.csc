#using scripts\codescripts\struct;

#using scripts\shared\array_shared;
#using scripts\shared\clientfield_shared;
#using scripts\shared\scene_shared;
#using scripts\shared\util_shared;

    	   	                                                                                                                         	                                                                                                                                                                                                                                                                                                                                                                    	        	     	             	    	   	                           	                               	                                	                                                              	                                                                                                              	                            	                                     	                                       	                                                               	   	                  	       	                                                    	                   	                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                       	                                                                                        	           	                        	                                            	                                             	                                                   	                                                             	                                                         	                                                                    	                                                                                                                                                                                                    	                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                     	                                                              	                                                          	                                   	                                   	                                                    	                                       
                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                            	                                                                                                                                                                                                                                                                                                                                                                                       

#using scripts\cp\_load;
#using scripts\shared\util_shared;



#namespace hideout_outro;
//--------------------------------------------------------------------------------------------------
//		MAIN
//--------------------------------------------------------------------------------------------------
function main()
{
	init_clientfields();
	
	//init so show in world.
	level thread city_ceilings_init();
}

function init_clientfields()
{
	n_clientbits = GetMinBitCountForNum( 4 );
	
	clientfield::register("world", "infection_hideout_fx", 1, 1, "int", &handle_hideout_fx, true, true);
	clientfield::register("world", "hideout_stretch", 1, 1, "int", &hideout_stretch_fxanim, true, true);
	clientfield::register("world", "stalingrad_rise_nuke", 1, 2, "int", &stalingrad_rise_fxanim, true, true);
	clientfield::register("world", "city_tree_passed", 1, 1, "int", &city_tree_passed, true, true);
	clientfield::register("world", "stalingrad_tree_init", 1, 2, "int", &stalingrad_tree_fxanim, true, true);
	clientfield::register("world", "stalingrad_city_ceilings", 1, n_clientbits, "int", &city_ceilings_play, true, true);
	clientfield::register("world", "stalingrad_nuke_fog", 1, 2, "int", &stalingrad_nuke_fog, !true, !true);
}	
	
//--------------------------------------------------------------------------------------------------
// 	HIDEOUT FX
//--------------------------------------------------------------------------------------------------
	
function handle_hideout_fx(localClientNum, oldVal, newVal, bNewEnt, bInitialSnap, fieldName, bWasDemoJump)
{
if(!IsDefined(newVal))
	{
		return;
	}
	
	if(newVal)
	{
		StartWaterSheetingFX(localClientNum, 8); 
	}
}

function hideout_stretch_fxanim(localClientNum, oldVal, newVal, bNewEnt, bInitialSnap, fieldName, bWasDemoJump)
{
	if(newVal)
	{
	//	level thread scene::play( "p7_fxanim_cp_infection_hideout_stretch_bundle" );
	}
}
	
//--------------------------------------------------------------------------------------------------
// 	STALINGRAD
//--------------------------------------------------------------------------------------------------
function stalingrad_rise_fxanim(localClientNum, oldVal, newVal, bNewEnt, bInitialSnap, fieldName, bWasDemoJump)
{
	if(newVal == 1)
	{
		//init is supposed to move buildings up into place.
		level thread scene::init( "p7_fxanim_cp_infection_nuke_buildings_bundle" );
		level thread scene::init( "p7_fxanim_cp_infection_nuke_tree_building_bundle" );
	}
	else if(newVal == 2)
	{
		level thread scene::play( "p7_fxanim_cp_infection_nuke_wave_bundle" );
		
		level waittill( "nuke_buildings" );
		level thread scene::play( "p7_fxanim_cp_infection_nuke_buildings_bundle" );
	}
}

function stalingrad_tree_fxanim(localClientNum, oldVal, newVal, bNewEnt, bInitialSnap, fieldName, bWasDemoJump)
{
	if(newVal == 1)
	{
		scene::add_scene_func( "p7_fxanim_cp_infection_nuke_tree_01_bundle", &callback_city_tree, "play" );
		scene::add_scene_func( "p7_fxanim_cp_infection_nuke_tree_02_bundle", &callback_city_tree, "init" );
		
		level thread scene::play( "p7_fxanim_cp_infection_nuke_tree_01_bundle" );
		level thread scene::init( "p7_fxanim_cp_infection_nuke_tree_02_bundle" );	
	}
	else if(newVal == 2)
	{
		scene::add_scene_func( "p7_fxanim_cp_infection_nuke_tree_02_bundle", &tree_hits_building, "play" );

		level thread scene::play( "p7_fxanim_cp_infection_nuke_tree_02_bundle" );	
	}
}

function tree_hits_building( a_ents )
{
	a_ents[ "nuke_tree_02_trunk" ] waittill( "tree_smash" );
	level thread scene::play( "p7_fxanim_cp_infection_nuke_tree_building_bundle" );	
}	

//--------------------------------------------------------------------------------------------------
// 	STALINGRAD CEILING COLLAPSES
//--------------------------------------------------------------------------------------------------
function city_ceilings_init()
{
	level thread scene::init( "p7_fxanim_cp_infection_house_ceiling_01_bundle" );	
	level thread scene::init( "p7_fxanim_cp_infection_house_ceiling_03_bundle" );	
	level thread scene::init( "p7_fxanim_cp_infection_house_ceiling_04_bundle" );	
}

function city_ceilings_play(localClientNum, oldVal, newVal, bNewEnt, bInitialSnap, fieldName, bWasDemoJump)
{
	if(newVal == 1)
	{
		level thread scene::play( "p7_fxanim_cp_infection_house_ceiling_01_bundle" );	
	}
	else if(newVal == 3)
	{
		level thread scene::play( "p7_fxanim_cp_infection_house_ceiling_03_bundle" );	
	}
	else if(newVal == 4)
	{
		level thread scene::play( "p7_fxanim_cp_infection_house_ceiling_04_bundle" );	
	}	
}


//--------------------------------------------------------------------------------------------------
// 	CITY TREE PASSED
//--------------------------------------------------------------------------------------------------
function city_tree_passed(localClientNum, oldVal, newVal, bNewEnt, bInitialSnap, fieldName, bWasDemoJump)
{
	if(newVal == 1)
	{
		level.city_skipped = true;
	}
}

//--------------------------------------------------------------------------------------------------
// 	CITY TREE SHADER
//--------------------------------------------------------------------------------------------------
function callback_city_tree( a_ents )
{		
	
	foreach( e_tree in a_ents )
	{
		e_tree thread city_tree_shader();				
	}
}

function city_tree_shader() //self = tree parts
{
	self endon( "death" );

	//example:
	//self MapShaderConstant( 0, 0, "scriptVector0", x, y, z, w );

	n_growth = 0; //starts at zero each cycle
	n_increment = 0.1;

	//tree shader grows up tree scriptVector0.x
	while( n_growth < 1 )
	{
		n_growth = n_growth + n_increment;
		
		self MapShaderConstant( 0, 0, "scriptVector0", n_growth, 1.0, 0, 0 );

		wait( n_increment );
	}
	
	n_pulse_max = 1.0;
	n_pulse_min = 0.2; 
	n_pulse = n_pulse_min; //starting pulse level

	//tree shader pulses scriptVector0.y
	while( true )
	{	
		n_cycle_time = RandomFloatRange( 2, 8 );

		n_pulse_increment =  ( n_pulse_max - n_pulse_min )  / ( n_cycle_time / n_increment );	

		//Ramp Up
		while( n_pulse < n_pulse_max )
		{
			self MapShaderConstant( 0, 0, "scriptVector0", 1.0, n_pulse, 0, 0 );			

			n_pulse += n_pulse_increment;
			
			wait( n_increment );
		}		

		n_cycle_time = RandomFloatRange( 2, 8 );

		n_pulse_increment = ( n_pulse_max - n_pulse_min )  / ( n_cycle_time / n_increment );	
	
		//Ramp Down
		while( n_pulse_min < n_pulse )
		{
			self MapShaderConstant( 0, 0, "scriptVector0", 1.0, n_pulse, 0, 0 );			
			
			n_pulse -= n_pulse_increment;

			wait( n_increment );
		}	
	}	
}

//--------------------------------------------------------------------------------------------------
// 	STALINGRAD NUKE FOG
//--------------------------------------------------------------------------------------------------
function stalingrad_nuke_fog(localClientNum, oldVal, newVal, bNewEnt, bInitialSnap, fieldName, bWasDemoJump)
{
	if(newVal == 1)
	{
			SetWorldFogActiveBank( localClientNum, 1 );
	}
	else if(newVal == 2)
	{
			SetWorldFogActiveBank( localClientNum, 2 );
	}
	else
	{
			SetWorldFogActiveBank( localClientNum, 0 );
	}
}



