// ----------------------------------------------------------------------------
// codescripts
// ----------------------------------------------------------------------------
#using scripts\codescripts\struct;

// ----------------------------------------------------------------------------
// shared
// ----------------------------------------------------------------------------
#using scripts\shared\clientfield_shared;
#using scripts\shared\util_shared;
#using scripts\shared\scene_shared;

    	   	                                                                                                                         	                                                                                                                                                                                                                                                                                                                                                                    	        	     	             	    	   	                           	                               	                                	                                                              	                                                                                                              	                            	                                     	                                       	                                                               	   	                  	       	                                                    	                   	                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                       	                                                                                        	           	                        	                                            	                                             	                                                   	                                                             	                                                         	                                                                    	                                                                                                                                                                                                    	                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                     	                                                              	                                                          	                                   	                                   	                                                    	                                       
                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                            	                                                                                                                                                                                                                                                                                                                                                                                       
                                               	                                                          	              	                                                                                           

// ----------------------------------------------------------------------------
// #define
// ----------------------------------------------------------------------------



// ----------------------------------------------------------------------------
// main
// ----------------------------------------------------------------------------
function main()
{
	init_clientfields();
}

// ----------------------------------------------------------------------------
// init_clientfields
// ----------------------------------------------------------------------------
function init_clientfields()
{
	clientfield::register( "world", "sgen_test_chamber_time_lapse", 1, 1, "int", &callback_time_lapse, !true, !true );	
	clientfield::register( "scriptmover", "sgen_test_guys_decay", 1, 1, "int", &callback_guys_decay, !true, !true );
	
	// FXanim
	clientfield::register( "world", "fxanim_hive_cluster_break", 1, 1, "int", &fxanim_hive_cluster_break, !true, !true );
	clientfield::register( "world", "fxanim_time_lapse_objects", 1, 1, "int", &fxanim_time_lapse_objects, !true, !true );
	
	clientfield::register( "world", "water_level", 1, 1, "int", &water_level_manager, !true, !true );
}

// ----------------------------------------------------------------------------
// FXanim Hive cluster break
// ----------------------------------------------------------------------------
function fxanim_hive_cluster_break( localClientNum, oldVal, newVal, bNewEnt, bInitialSnap, fieldName, bWasDemoJump )
{
	if ( newVal )
	{
		level thread scene::init( "p7_fxanim_cp_infection_sgen_hive_drop_bundle");
	}
	else
	{
		scene::add_scene_func( "p7_fxanim_cp_infection_sgen_hive_drop_bundle", &callback_hive_remove, "play" );		
		level thread scene::play( "p7_fxanim_cp_infection_sgen_hive_drop_bundle");
	}
}

function callback_hive_remove( a_ent )
{
	wait 1;
	a_ent[ "sgen_hive_drop" ] delete();
}

// ----------------------------------------------------------------------------
// time_lapse
// ----------------------------------------------------------------------------
function callback_time_lapse( localClientNum, oldVal, newVal, bNewEnt, bInitialSnap, fieldName, bWasDemoJump )
{		
	testing_pod_ents = GetEntArray(localClientNum, "dni_testing_pod", "targetname");
	
	foreach( testing_pod_ent in testing_pod_ents )
	{
		testing_pod_ent thread time_lapse();				
	}
}

function time_lapse()
{
	n_wait_per_cycle = 1 / 15;
	
	n_growth_increment = 1 / ( 15 * 12 );
	n_growth = 0;
	
	for ( i = 0; i <= 12; i = i + n_wait_per_cycle )
	{
		self MapShaderConstant( 0, 0, "scriptVector0", n_growth, 0, 0, 0 );
		//SetWeatherGrimeAmounts( n_growth, 0, n_growth, 0 );
			
		n_growth += n_growth_increment;
			
		wait n_wait_per_cycle;
	}
}

// ----------------------------------------------------------------------------
// decayedman shader
// ----------------------------------------------------------------------------
function callback_guys_decay( localClientNum, oldVal, newVal, bNewEnt, bInitialSnap, fieldName, bWasDemoJump )
{			
	self thread DecaymanMaterial(localClientNum);
}

function DecaymanMaterial(localClientNum)
{
	self endon("disconnect");
	self endon("death");
	
	self notify("DecaymanMaterial");
	self endon("DecaymanMaterial");
	
	for ( i = 0.0; i <= 2.0; i += 0.01 )
	{
		if(!isdefined(self))
			return;
		
		self MapShaderConstant( localClientNum, 0, "scriptVector0", i / 2.0, 0, 0, 0 );
		wait 0.01;
	}
}


// ----------------------------------------------------------------------------
// FXanim time lapse objects
// ----------------------------------------------------------------------------
function fxanim_time_lapse_objects( localClientNum, oldVal, newVal, bNewEnt, bInitialSnap, fieldName, bWasDemoJump )
{
	if ( newVal )
	{
		level thread scene::play( "p7_fxanim_cp_infection_sgen_time_lapse_objects_bundle");
	}
}


function water_level_manager( localClientNum, oldVal, newVal, bNewEnt, bInitialSnap, fieldName, bWasDemoJump )
{
	if ( newVal )
	{
		level thread water_level_rise();
	}
	else
	{
		level thread water_level_lower();
	}
}

function water_level_lower()
{
	level notify( "stop_water_rise" );
	level endon( "stop_water_lower" );
	
	n_curr = 5980;
	n_drop = 0.5;
	b_rising = false;	
	
	while( !b_rising )
	{
		SetWaveWaterHeight( "lab_water", n_curr );
		
		if ( n_curr > n_drop )
		{
			n_curr -= n_drop;
			
			if ( n_curr <= 5960 )
			{				
				b_rising = true;
			}
		}
		
		wait 0.1;
	}	
}

function water_level_rise()
{
	level notify( "stop_water_lower" );
	level endon( "stop_water_rise" );
	
	n_curr = 5960;
	n_rise = 0.5;
	b_rising = true;	
	
	//SetWaveWaterHeight( "lab_water", n_curr );
	
	while( b_rising )
	{
		SetWaveWaterHeight( "lab_water", n_curr );
		
		if ( n_curr < 5980)
		{
			 n_curr+= n_rise;
			
			if ( n_curr >= 5980 )
			{				
				b_rising = false;	
			}
		}
		
		wait 0.1;
	}	
}

