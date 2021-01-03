    	   	                                                                                                                         	                                                                                                                                                                                                                                                                                                                                                                    	        	     	             	    	   	                           	                               	                                	                                                              	                                                                                                              	                            	                                     	                                       	                                                               	   	                  	       	                                                    	                   	                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                       	                                                                                        	           	                        	                                            	                                             	                                                   	                                                             	                                                         	                                                                    	                                                                                                                                                                                                    	                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                     	                                                              	                                                          	                                   	                                   	                                                    	                                       
                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                            	                                                                                                                                                                                                                                                                                                                                                                                       
                                                                                                                                                                                                                                                                                                                                                                                                                 	                                                                                                                                                                          	                                                                                         	                                                                                                                                                                                                                                                                                                                                                                                                                                        	                                                                                                                               	                                                                                                                                                                                                                                              	                                                                                                                                           	                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                   	                                                                                                                       	   	                                                                                                                                                                                                                                                                                                                         	                                                                                                                                                                                                                                      

#using scripts\codescripts\struct;
#using scripts\shared\animation_shared;
#using scripts\shared\callbacks_shared;
#using scripts\shared\clientfield_shared;
#using scripts\shared\system_shared;
#using scripts\shared\util_shared;
#using scripts\shared\array_shared;

#using scripts\zm\_load;
#using scripts\zm\_zm;
#using scripts\zm\_zm_utility;
#using scripts\zm\_zm_weapons;
#using scripts\shared\system_shared;
	
#namespace zm_zod_traps;


#using_animtree( "generic" );

function autoexec __init__sytem__() {     system::register("zm_zod_traps",&__init__,undefined,undefined);    }

function __init__()
{
	clientfield::register( "scriptmover", "trap_chain_state",		1, 2, "int", &update_chain_anims,	!true, !true );
	clientfield::register( "scriptmover", "trap_chain_location",	1, 2, "int", &location_func,			!true, !true );
}


function update_chain_anims( localClientNum, oldVal, newVal, bNewEnt, bInitialSnap, fieldName, bWasDemoJump )
{
	a_str_areaname = [];
	a_str_areaname[0] = "theater";
	a_str_areaname[1] = "slums";
	a_str_areaname[2] = "canals";
	a_str_areaname[3] = "pap";
	
	int_location = self clientfield::get( "trap_chain_location" );
		
	str_areaname = a_str_areaname[ int_location ];
	
	a_mdl_chain_active = GetEntArray( localClientNum, "fxanim_chain_trap", "targetname" );
	a_mdl_chain_active = array::filter( a_mdl_chain_active, false, &filter_areaname, str_areaname );
	mdl_chain_active = a_mdl_chain_active[0];
	
	a_mdl_chain_idle = GetEntArray( localClientNum, "fxanim_chain_trap_idle", "targetname" );
	a_mdl_chain_idle = array::filter( a_mdl_chain_idle, false, &filter_areaname, str_areaname );
	mdl_chain_idle = a_mdl_chain_idle[0];
	
	mdl_chain_active thread update_active_chain_anims( localClientNum, oldVal, newVal, bNewEnt, bInitialSnap, fieldName, bWasDemoJump );
	mdl_chain_idle thread update_idle_chain_anims( localClientNum, oldVal, newVal, bNewEnt, bInitialSnap, fieldName, bWasDemoJump );
}

function location_func( localClientNum, oldVal, newVal, bNewEnt, bInitialSnap, fieldName, bWasDemoJump )
{
	//dummy func just to store some the location int on the heart, so it can be referenced on the client	
}


function filter_areaname( e_entity, str_areaname )
{
	if( e_entity.script_noteworthy !== str_areaname )
	{
		return false;
	}
	return true;
}


function update_active_chain_anims( localClientNum, oldVal, newVal, bNewEnt, bInitialSnap, fieldName, bWasDemoJump )
{
	self notify( "update_active_chain_anims" );
	self endon( "update_active_chain_anims" );
	
	mdl_chains_active = self;
	mdl_chains_active	util::waittill_dobj( localClientNum );
	
	if ( !mdl_chains_active HasAnimTree() )
	{
		mdl_chains_active UseAnimTree( #animtree );
	}

	switch( newVal )
	{
		case 1:
			break;
		case 0:
			break;
		case 2:
			mdl_chains_active thread animation::play( "p7_fxanim_zm_zod_chain_trap_start_anim" );
			mdl_chains_active thread end_active_state_chain_animation();
			mdl_chains_active animation::play( "p7_fxanim_zm_zod_chain_trap_on_anim" );
			break;
		case 3:		
			break;
	}
}

function end_active_state_chain_animation()
{
	end_anim_length = GetAnimLength( "p7_fxanim_zm_zod_chain_trap_end_anim" );
	assert( end_anim_length < 25 , "Trap chain active ending animation is longer than the trap's active duration" );
	wait( 25 - end_anim_length );
	self animation::play( "p7_fxanim_zm_zod_chain_trap_end_anim" );
}

function update_idle_chain_anims( localClientNum, oldVal, newVal, bNewEnt, bInitialSnap, fieldName, bWasDemoJump )
{
	self notify( "update_idle_chain_anims" );
	self endon( "update_idle_chain_anims" );
	
	mdl_chains_idle = self;
	mdl_chains_idle		util::waittill_dobj( localClientNum );
	
	if ( !mdl_chains_idle HasAnimTree() )
	{
		mdl_chains_idle UseAnimTree( #animtree );
	}

	switch( newVal )
	{
		case 1:
			mdl_chains_idle animation::play( "p7_fxanim_zm_zod_chain_trap_idle_start_anim" );
			mdl_chains_idle animation::play( "p7_fxanim_zm_zod_chain_trap_idle_on_anim" );
			break;
		case 0:
			mdl_chains_idle animation::play( "p7_fxanim_zm_zod_chain_trap_idle_end_anim" );
			break;
		case 2:
			mdl_chains_idle animation::play( "p7_fxanim_zm_zod_chain_trap_idle_on_anim" );
			break;
		case 3:
			mdl_chains_idle animation::play( "p7_fxanim_zm_zod_chain_trap_idle_end_anim" );
			break;
	}
}
