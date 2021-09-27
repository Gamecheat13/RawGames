#include maps\_utility;
#include common_scripts\utility;
#include maps\_anim;
#include maps\_vehicle;
#include maps\_sandstorm;
#include maps\_audio;
//#include maps\_stealth_utility;
//#include maps\_stealth_visibility_enemy;
//#include maps\_stealth_visibility_system;
//#include maps\_stealth_shared_utilities;
#include maps\payback_util;

// used so I can write code that will run fine without the heroes (ally NPCs), so I can quickly test
// stealth and enemy reaction without worrying about ally NPCs
debug_no_heroes()
{
	if ( !IsDefined( level.debug_no_heroes ))
	{
		level.debug_no_heroes = false;
	}
	return level.debug_no_heroes;
}

sandstorm_skybox_hide()
{
	skyboxes = GetEntArray( "sandstorm_sky" , "targetname" );
	foreach( box in skyboxes )
	{
		box Hide();
	}
	skyboxes = GetEntArray( "blue_sky" , "targetname" );
	foreach( box in skyboxes )
	{
		box Show();
	}
}

sandstorm_skybox_show()
{
	skyboxes = GetEntArray( "sandstorm_sky" , "targetname" );
	foreach( box in skyboxes )
	{
		box Show();
	}
	skyboxes = GetEntArray( "blue_sky" , "targetname" );
	foreach( box in skyboxes )
	{
		box Hide();
	}

}
/* 
 * redundant with the direct calls to set sandstorm level - not needed
 * 
// sandstorm fx
init_sandstorm_logic()
{
	if ( !IsDefined(level.sandstorm_logic_init) )
	{
		level.sandstorm_levels = [];
		level.sandstorm_levels[0] = "light";
		level.sandstorm_levels[1] = "medium";
		level.sandstorm_levels[2] = "hard";
		level.sandstorm_levels[3] = "extreme";
		level.sandstorm_levels[4] = "aftermath";
		level.sandstorm_levels[5] = "none";
		level.sandstorm_curr = "none";
		
		for ( i = 0 ; i < level.sandstorm_levels.size ; i++ )
		{
			flagname = "sandstorm_" + level.sandstorm_levels[i]; 
			if ( !flag_exist( flagname )) 
			{
				flag_init( "sandstorm_" + level.sandstorm_levels[i] );
			}
		}
		
		for ( i = 0 ; i < level.sandstorm_levels.size ; i++ )
		{
			thread sandstorm_listen( level.sandstorm_levels[i] );
		}
		
		level.sandstorm_logic_init = true;
	}
}

sandstorm_listen( stormlevel )
{
	flag = "sandstorm_" + stormlevel;
	while( 1 )
	{
		flag_wait( flag );
		flag_clear( flag );
		if( stormlevel != level.sandstorm_curr )
		{
			level.sandstorm_curr = stormlevel;
			thread set_sandstorm_level( stormlevel );
		}
	}
}

*/
	
set_sandstorm_level( stormlevel, transition_time, disable_fog )
{
	// add option to disable sandstorm while debugging
	if ( IsDefined( level.debug_no_sandstorm ) && level.debug_no_sandstorm )
	{
		return;
	}
	if ( !IsDefined( transition_time ))
	{
		transition_time = 10;
	}
	aud_send_msg( "sandstorm_" + stormlevel ); 

	switch( stormlevel )
	{
		case "light": 
			//IPrintLn("LIGHT");
			blizzard_level_transition_light( transition_time ); 
			break;
		case "medium": 
			//IPrintLn("MEDIUM");
			blizzard_level_transition_med( transition_time ); 
			//level notify("stop_sandstorm_wall"); 
			wait(5);
			sandstorm_fx(3);
			break;
		case "hard": 
			//IPrintLn("HARD");
			blizzard_level_transition_hard( transition_time ); 
			break;
		case "blackout": 
			//IPrintLn("BLACKOUT");
			blizzard_level_transition_blackout( transition_time); 
			break;
		case "extreme": 
			//IPrintLn("EXTREME");
			if ( IsDefined( disable_fog ))
			{
				blizzard_level_transition_extreme( transition_time,disable_fog ); 
			}
			else{
				blizzard_level_transition_extreme( transition_time); 
			}
			//wait(.4);
			sandstorm_fx(0);
			SetSavedDvar("r_fog_depthhack_scale", 0.5);
			//level notify("stop_sandstorm_construction_wall"); 
			break;
		// jblumel: replaced "extreme" with "aftermath" to be used during s3_escape
		case "aftermath": 
			blizzard_level_transition_aftermath( transition_time ); 
			break;
		case "none": 
			blizzard_level_transition_none( transition_time ); 
			break;
	}
	

}
//---------------------------------------------------------------
// vehicles
handle_vehicle_lights()
{
	self endon( "sandstorm_vehicle_delete" );
	
	self vehicle_lights_on();
	
	self waittill( "death" );
	
	self vehicle_lights_off( "all" );
}




attachFlashlight( notify_name )
{
    attach_tag = "TAG_INHAND";
    self.flashlight = Spawn( "script_model", self.origin );
    flashlight = self.flashlight;
    
    flashlight.owner = self;
    flashlight.origin = self GetTagOrigin( attach_tag );
    flashlight.angles = self GetTagAngles( attach_tag );
    flashlight SetModel( "com_flashlight_on" );
    flashlight LinkTo( self, attach_tag );
    
	flashlight_tag = "tag_light";
	flashlight_effect = level._effect[ "lights_flashlight_sandstorm" ];
	PlayFXOnTag(flashlight_effect, flashlight, flashlight_tag);
	
	self thread remove_flashlight_on_alert(notify_name, flashlight_effect, flashlight, flashlight_tag);
	self waittill_any( "death", "remove_flashlight");
   	wait(0.1);
   	flashlight Delete();
}

remove_flashlight_on_alert(notify_name, flashlight_effect, flashlight, flashlight_tag)
{
	self endon( "death" );
	self endon( "remove_flashlight" );
	
	while ( 1 )
	{
		level waittill(notify_name);
		self notify( "remove_flashlight" );
		flashlight SetModel( "com_flashlight_off" );
   		StopFXOnTag( flashlight_effect, flashlight, flashlight_tag );
		wait(0.1);
	}
}



flashlight_on_guy()
{
	if ( IsDefined(self) )
	{
		self.flashlight_tag = "tag_weapon_right";
		self.flashlight_effect = level._effect[ "lights_flashlight_sandstorm_offset" ];
		PlayFXOnTag(self.flashlight_effect, self, self.flashlight_tag);
		self thread flashlight_off_on_death();
	}
}

flashlight_off_guy()
{
	if ( IsDefined(self) && IsDefined(self.flashlight_tag) && IsDefined(self.flashlight_effect) )
	{
		StopFXOnTag(self.flashlight_effect, self, self.flashlight_tag);
		self.flashlight_effect = undefined;
		self.flashlight_tag = undefined;
	}
}

flashlight_off_on_death()
{
	// Make sure only one of these is running on any given guy
	self notify("flashlight_off_on_death");
	self endon("flashlight_off_on_death");
	
	self waittill_any("death", "flashlight_off_delayed");
	if ( IsDefined(self.flashlight_off_delay) )
	{
		wait self.flashlight_off_delay;
	}
	else
	{
		wait 0.75;
	}
	self flashlight_off_guy();
}

