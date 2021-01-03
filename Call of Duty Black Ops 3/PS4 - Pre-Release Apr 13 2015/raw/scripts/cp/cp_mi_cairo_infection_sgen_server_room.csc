#using scripts\codescripts\struct;

#using scripts\shared\array_shared;
#using scripts\shared\clientfield_shared;
#using scripts\shared\util_shared;
#using scripts\shared\scene_shared;

    	   	                                                                                                                         	                                                                                                                                                                                                                                                                                                                                                                    	        	     	             	    	   	                           	                               	                                	                                                              	                                                                                                              	                            	                                     	                                       	                                                               	   	                  	       	                                                    	                   	                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                       	                                                                                        	           	                        	                                            	                                             	                                                   	                                                             	                                                         	                                                                    	                                                                                                                                                                                                    	                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                     	                                                              	                                                          	                                   	                                   	                                                    	                                       
                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                            	                                                                                                                                                                                                                                                                                                                                                                                       

#using scripts\cp\_load;
#using scripts\shared\util_shared;








#namespace sgen_server_room;
//--------------------------------------------------------------------------------------------------
//		MAIN
//--------------------------------------------------------------------------------------------------
function main()
{
	clientfield::register("world", "infection_sgen_server_debris", 1, 2, "int", &handle_sgen_server_debris, true, true);
	clientfield::register("world", "infection_sgen_xcam_models", 1, 1, "int", &handle_sgen_xcam_models, true, true);
	clientfield::register( "scriptmover", "left_arm_shader", 1, 1, "int", 	&callback_left_arm_shader, 	!true, !true);
}

//--------------------------------------------------------------------------------------------------
// 	UNDERWATER DEBRIS
//--------------------------------------------------------------------------------------------------
function handle_sgen_server_debris(localClientNum, oldVal, newVal, bNewEnt, bInitialSnap, fieldName, bWasDemoJump)
{
	if(!IsDefined(newVal))
	{
		return;
	}
	
	switch ( newVal )
	{
		case 1:
		level thread sgen_server_debris_init( localClientNum );
		break;
		
		case 2:
		level notify( "server_debris_fall" );
		break;
		
		case 3:
		level notify("sgen_server_debris_done");
		break;
		
		default:
		break;
	}	
}

function sgen_server_debris_init( localClientNum )
{
	debris = [];
	
	position = struct::get_array( "sgen_server_debris" );
	for( i=0; i < position.size; i++ )
	{
		if(IsDefined(position[i].model))
		{	
			junk = spawn(localClientNum, position[i].origin, "script_model" );
			junk SetModel( position[i].model );
			junk.targetname = position[i].targetname;

			if ( isdefined( position[i].angles ) )
			{
				junk.angles = position[i].angles;
			}
			
			if(IsDefined(position[i].script_noteworthy))
			{
				junk.script_noteworthy = position[i].script_noteworthy;
			}
			array::add(debris, junk, false);
		}
	}	

	level waittill( "server_debris_fall" );
	array::thread_all(debris, &sgen_server_debris_move );

}

function sgen_server_debris_move()
{
	drop_distance = self get_drop_distance();
	drop_time = drop_distance / 600;
	
	drop_time_min = drop_time;
	drop_time_max = ( drop_time_min * 1.25 );
	
	n_accel_time = ( drop_time * 0.25 );	
	
	drop_time_temp = RandomFloatRange( drop_time_min, drop_time_max );
	endpos = (self.origin[0], self.origin[1], self.origin[2] - drop_distance);
	
	self MoveTo(endpos, drop_time_temp);
	self RotateTo(self.angles + (RandomFloatRange(-45,45), RandomFloatRange(-45,45), RandomFloatRange(-45,45)), drop_time_temp);

	level waittill("sgen_server_debris_done");
	self delete();
}
	
function get_drop_distance( )
{	
	forest_tag = struct::get("tag_align_bastogne_sarah_intro", "targetname");
	
	v_start = self.origin;
	v_end 	= forest_tag.origin;

	n_drop_distance = ( v_start - v_end )[ 2 ]; 
	
	return Abs(n_drop_distance) + 64 + 40;
}

function handle_sgen_xcam_models(localClientNum, oldVal, newVal, bNewEnt, bInitialSnap, fieldName, bWasDemoJump)
{
	xcam_models = GetEntArray( localClientNum, "pallas_xcam_model", "targetname" );
	foreach( xcam_model in xcam_models )
	{		
		xcam_model delete();		
	}
}

// ----------------------------------------------------------------------------
// callback_baby_skin_shader
// ----------------------------------------------------------------------------
function callback_left_arm_shader( localClientNum, oldVal, newVal, bNewEnt, bInitialSnap, fieldName, bWasDemoJump )
{	
	timegap = 4/3;
	
	for( i=0; i<3; i++ )
	{
		thread dni_pulse( 0.1 );
		wait( timegap );
	}
}

function dni_pulse( speed )
{
	pulseLevel=0;
	
	for( pulseLevel = 0; pulseLevel<= 1; pulseLevel+=speed )
	{
		self MapShaderConstant( 0, 0, "scriptVector1", pulseLevel );
	}
} 

