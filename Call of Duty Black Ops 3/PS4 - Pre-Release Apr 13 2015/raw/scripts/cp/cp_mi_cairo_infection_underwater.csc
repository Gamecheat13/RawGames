#using scripts\codescripts\struct;

#using scripts\shared\array_shared;
#using scripts\shared\clientfield_shared;
#using scripts\shared\scene_shared;
#using scripts\shared\util_shared;

    	   	                                                                                                                         	                                                                                                                                                                                                                                                                                                                                                                    	        	     	             	    	   	                           	                               	                                	                                                              	                                                                                                              	                            	                                     	                                       	                                                               	   	                  	       	                                                    	                   	                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                       	                                                                                        	           	                        	                                            	                                             	                                                   	                                                             	                                                         	                                                                    	                                                                                                                                                                                                    	                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                     	                                                              	                                                          	                                   	                                   	                                                    	                                       
                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                            	                                                                                                                                                                                                                                                                                                                                                                                       

#using scripts\cp\_load;
#using scripts\shared\util_shared;

#precache( "client_fx", "water/fx_water_bubbles_debris_50x10" );
#precache( "client_fx", "water/fx_water_bubbles_debris_body" );
#precache( "client_fx", "water/fx_water_bubbles_debris_sm" );

#namespace underwater;
//--------------------------------------------------------------------------------------------------
//		MAIN
//--------------------------------------------------------------------------------------------------
function main()
{
	init_clientfields();
}

function init_clientfields()
{
	clientfield::register("world", "infection_underwater_debris", 1, 1, "int", &handle_underwater_debris, true, true);
}	
//--------------------------------------------------------------------------------------------------
// 	UNDERWATER DEBRIS
//--------------------------------------------------------------------------------------------------
function handle_underwater_debris(localClientNum, oldVal, newVal, bNewEnt, bInitialSnap, fieldName, bWasDemoJump)
{
if(!IsDefined(newVal))
	{
		return;
	}
	
	if(newVal)
	{
		level thread underwater_debris_init( localClientNum );
	}
	else
	{
		level thread underwater_cleanup( localClientNum );
	}
}

function underwater_debris_init( localClientNum )
{
	debris = [];

	level._effect["bubbles_pews"]	= "water/fx_water_bubbles_debris_50x10";
	level._effect["bubbles_body"]	= "water/fx_water_bubbles_debris_body";
	level._effect["bubbles_books"]	= "water/fx_water_bubbles_debris_sm";
	
	position = struct::get_array( "underwater_debris" );
	for( i=0; i < position.size; i++ )
	{
		if(IsDefined(position[i].model))
		{	
			junk = spawn(localClientNum, position[i].origin, "script_model" );
			junk SetModel( position[i].model );
			junk.targetname = position[i].targetname;

			//play scene on dead bodies
			if( ( junk.model === "c_ger_winter_soldier_1_body" ) )
			{
				junk thread scene::play( "cin_gen_ambient_float01", junk );
				junk.sfx_id = PlayFXOnTag(localClientNum, level._effect[ "bubbles_body" ], junk, "tag_origin" );
			}			
			else if( ( junk.model === "c_ger_winter_soldier_2_body" ) )
			{
				junk thread scene::play( "cin_gen_ambient_float02", junk );
				junk.sfx_id = PlayFXOnTag(localClientNum, level._effect[ "bubbles_body" ], junk, "tag_origin" );
			}
			else if( ( junk.model === "p7_church_pew_01" ) )
			{
				junk.sfx_id = PlayFXOnTag(localClientNum, level._effect[ "bubbles_pews" ], junk, "tag_origin" );
			}			
			else if( ( junk.model === "p7_book_vintage_02_burn" ) )
			{
				junk.sfx_id = PlayFXOnTag(localClientNum, level._effect[ "bubbles_books" ], junk, "tag_origin" );
			}	
			else if( ( junk.model === "p7_book_vintage_open_01_burn" ) )
			{
				junk.sfx_id = PlayFXOnTag(localClientNum, level._effect[ "bubbles_books" ], junk, "tag_origin" );
			}	

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

	//debris = GetEntArray(localClientNum, "underwater_debris","targetname");
	array::thread_all(debris, &underwater_debris_move );

}

function underwater_debris_move()
{
	level endon("underwater_move_done");

	bottom = BulletTrace(self.origin, self.origin + (0, 0, -1500), false, undefined);
	self MoveTo( bottom[ "position" ], 60 );

	while(true)
	{
		time = RandomFloatRange(4,6);
		
		self RotateTo(self.angles + (RandomFloatRange(-30,30), RandomFloatRange(-30,30), RandomFloatRange(-30,30)), time);
		self waittill("rotatedone");		
	}
}

function underwater_cleanup(localClientNum)
{
	debris = GetEntArray(localClientNum, "underwater_debris","targetname");
	for(i = 0 ;i < debris.size;i++)
	{
		if( (debris[i] scene::is_playing()) )
		{
			debris[i] scene::stop();
		}
		
		debris[i] delete();
		
		if( isdefined( self.sfx_id ) )
		{	
			DeleteFx( localClientNum, self.sfx_id, false );
			self.sfx_id = undefined;		
		}
	}
	
	StopWaterSheetingFX(localClientNum);
}		

	
