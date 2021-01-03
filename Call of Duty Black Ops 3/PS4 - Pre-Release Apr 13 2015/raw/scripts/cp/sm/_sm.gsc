#using scripts\codescripts\struct;

#using scripts\shared\clientfield_shared;
#using scripts\shared\flag_shared;
#using scripts\shared\system_shared;
#using scripts\shared\util_shared;

    	   	                                                                                                                         	                                                                                                                                                                                                                                                                                                                                                                    	        	     	             	    	   	                           	                               	                                	                                                              	                                                                                                              	                            	                                     	                                       	                                                               	   	                  	       	                                                    	                   	                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                      	                                                                                        	           	                        	                                            	                                             	                                                   	                                                             	                                                         	                                                                    	                                                                                                                                                                                                    	                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                    	                                                              	                                                          	                                   	                                   	                                                    	                                       
                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                            	                                                                                                                                                                                                                                                                                                                                                                                       

#using scripts\cp\sm\_sm_resource_manager;
#using scripts\cp\sm\_sm_round_manager;
#using scripts\cp\sm\_sm_barricade;

                                                                   	       	     	          	      	                                                                                            	                                                           	                                  

#namespace sm;

function autoexec __init__sytem__() {     system::register("sm",&__init__,undefined,undefined);    }
	
function __init__()
{
	level.can_revive = &sm::sm_can_revive;
	level flag::init( "prematch_active", true );
	level thread waittill_prematch_over();
	level thread cleanup_remaining_ai();
	level.scoreModifierCallback = &score_modifier_callback;
	level thread init_special_kills();
	
	clientfield::register( "scriptmover", "sm_barricade_glow", 1, 1, "int" );
	clientfield::register( "scriptmover", "sm_scavenger_glow", 1, 1, "int" );
}

function init_special_kills()
{
	while ( !isdefined(level.scoreInfo) )
	{
		util::wait_network_frame();
	}
	
	// We get this out of the way at level init, since it's quite inefficient--o(n^2) with a substr.
	//
	a_classes = array( "melee", "assist" );
	foreach ( key, s_event in level.scoreInfo )
	{
		s_event["classes"] = [];
		foreach( str_class in a_classes )
		{
			s_event["classes"][str_class] = IsSubStr( key, str_class );
		}
	}
}

function score_modifier_callback( str_type, n_points )
{
	if ( isdefined(level.score_bonus) )
	{
		if ( ( isdefined( level.scoreInfo[str_type]["classes"][level.score_bonus.type] ) && level.scoreInfo[str_type]["classes"][level.score_bonus.type] ) )
		{
			return Int(n_points * level.score_bonus.multiplier);
		}
	}
	
	return n_points;
}

function waittill_prematch_over()
{
	level waittill( "prematch_over" );
	level flag::clear( "prematch_active" );
}

function sm_can_revive( e_reviver )
{
	if ( isdefined( self.robo_reviving ) && IsAlive( self.robo_reviving ) )
	{
		return false;
	}
	
	return true;
}

function cleanup_remaining_ai()
{	
	//clean up any remaining ai
	level waittill( "round_end_done" );

	all_ai = GetAIArray();
	foreach(ai in all_ai)
	{
		if ( IsActor(ai) )
		{
			ai dodamage(ai.health * 2, ai.origin);
		}
	}	
}
