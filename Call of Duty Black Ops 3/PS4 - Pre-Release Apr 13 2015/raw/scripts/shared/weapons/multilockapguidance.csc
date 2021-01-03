#using scripts\codescripts\struct;

#using scripts\shared\array_shared;
#using scripts\shared\clientfield_shared;
#using scripts\shared\duplicaterender_mgr;
#using scripts\shared\filter_shared;
#using scripts\shared\flagsys_shared;
#using scripts\shared\system_shared;
#using scripts\shared\util_shared;

                                                                           
                                          	  	                                                                                  	        
    	   	                                                                                                                         	                                                                                                                                                                                                                                                                                                                                                                    	        	     	             	    	   	                           	                               	                                	                                                              	                                                                                                              	                            	                                     	                                       	                                                               	   	                  	       	                                                    	                   	                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                        	                                                                                        	           	                        	                                            	                                             	                                                   	                                                             	                                                         	                                                                    	                                                                                                                                                                                                    	                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                      	                                                              	                                                          	                                   	                                   	                                                    	                                       
                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                            	                                                                                                                                                                                                                                                                                                                                                                                       

#namespace antipersonnel_guidance;

function autoexec __init__sytem__() {     system::register("multilockap_guidance",&__init__,undefined,undefined);    }


	
function __init__()
{
	level thread player_init();
	
	duplicate_render::set_dr_filter_offscreen( "ap", 75, 
	                                "ap_locked",                        undefined,                    
	                                2, "mc/hud_outline_model_red"  );
	
}


function player_init()
{
	util::waitforclient( 0 );

	players = getlocalplayers();
	
	foreach( player in players )
	{
		player thread watch_lockon(0);
	}
}


function watch_lockon( localClientNum )
{
	
	while(1)
	{
		self waittill("lockon_changed",state,target);
		if (IsDefined(self.replay_lock) && ( !IsDefined(target) || self.replay_lock!= target ) )
		{
		   	self.ap_lock duplicate_render::change_dr_flags( undefined, "ap_locked" );
		   	self.ap_lock = undefined;
		}
		switch(state)
		{
			case 0:
			case 1:
			case 3:
			   	target duplicate_render::change_dr_flags( undefined, "ap_locked" );
				break;
				
			case 2:
			case 4:
			   	target duplicate_render::change_dr_flags( "ap_locked", undefined );
			   	self.ap_lock = target;
				break;
		}
	}
}

/*
function watch_lockon_old( localClientNum )
{
	
	while(1)
	{
		self waittill("lockon_changed",state,target);
		if (IsDefined(self.replay_lock) && ( !IsDefined(target) || self.replay_lock!= target ) )
		{
		   	self.replay_lock ent_set_outline( TARGET_OUTLINE_OFF );
		   	self.replay_lock = undefined;
		}
		target ent_set_outline( state );
		switch(state)
		{
			case REPLAYGUN_TARGET_LOST:
				target ent_set_outline( TARGET_OUTLINE_OFF );
				//self playsound(localClientNum,"wpn_replay_lost");
				break;
			case REPLAYGUN_TARGET_LOCKING:
				target ent_set_outline( TARGET_OUTLINE_OFF );
				//self playsound(localClientNum,"wpn_replay_tracking");
				break;
			case REPLAYGUN_TARGET_SUSPEND:
				target ent_set_outline( TARGET_OUTLINE_OFF );
				break;
			case REPLAYGUN_TARGET_LOCKED:
				//self playsound(localClientNum,"wpn_replay_lock_on");
				// fall through
			case REPLAYGUN_TARGET_REGAIN:
				target ent_set_outline( TARGET_OUTLINE_RED );
			   	self.replay_lock = target;
				break;
		}
	}
	

}


//*****************************************************************************
//*****************************************************************************
// Adding shader filters to Ents
//*****************************************************************************
//*****************************************************************************

function init_ent_shader_materials( player )
{
     //	_filter::init_filter_indices();
    filter::map_material_helper( player,  "mc/hud_outline_model_red" );
	filter::map_material_helper( player,  "mc/hud_outline_model_green" );
	filter::map_material_helper( player,  "mc/hud_outline_model_orange" );

}


function ent_set_outline( color )
{
	switch( color )
	{
		case TARGET_OUTLINE_OFF	:
		case TARGET_OUTLINE_SUSPEND:
		case TARGET_OUTLINE_LOCKING:
		   	self addduplicaterenderoption( DR_TYPE_OFFSCREEN, DR_METHOD_OFF );
		   	self addduplicaterenderoption( DR_TYPE_FRAMEBUFFER, DR_METHOD_DEFAULT_MATERIAL );
		break;
			
		// Thermal Material
		case TARGET_OUTLINE_THERMAL:
			self addduplicaterenderoption( DR_TYPE_OFFSCREEN, DR_METHOD_OFF );
			self addduplicaterenderoption( DR_TYPE_FRAMEBUFFER, DR_METHOD_DEFAULT_MATERIAL );
		break;

		// Red Material
		case TARGET_OUTLINE_LOCKED:
		case TARGET_OUTLINE_RED:
			self addduplicaterenderoption( DR_TYPE_FRAMEBUFFER, DR_METHOD_DEFAULT_MATERIAL );
			self addduplicaterenderoption( DR_TYPE_OFFSCREEN, DR_METHOD_CUSTOM_MATERIAL, filter::mapped_material_id( "mc/hud_outline_model_red" ) );
		break;

		// Green Material
		case TARGET_OUTLINE_GREEN:
			self addduplicaterenderoption( DR_TYPE_FRAMEBUFFER, DR_METHOD_DEFAULT_MATERIAL );
			self addduplicaterenderoption( DR_TYPE_OFFSCREEN, DR_METHOD_CUSTOM_MATERIAL, filter::mapped_material_id( "mc/hud_outline_model_green" ) );	
		break;

		// Orange Material
		case TARGET_OUTLINE_ORANGE:
			self addduplicaterenderoption( DR_TYPE_FRAMEBUFFER, DR_METHOD_DEFAULT_MATERIAL );
			self addduplicaterenderoption( DR_TYPE_OFFSCREEN, DR_METHOD_CUSTOM_MATERIAL, filter::mapped_material_id( "mc/hud_outline_model_orange" ) );	
		break;
	}
}


*/
