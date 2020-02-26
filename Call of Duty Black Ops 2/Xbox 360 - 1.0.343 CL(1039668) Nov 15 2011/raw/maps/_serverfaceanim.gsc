#include maps\_utility;
#include common_scripts\utility;

#using_animtree( "generic_human" );

// We need to have this function so that these animations are forcibly loaded during script parsing
// It is not called from anywhere
codecall null_ai_face_anims_func()
{
	// Reserve on server
	anims = %faces;
	
	anims = %f_idle_casual_v1;
	
	anims = %f_idle_alert_v1;
	anims = %f_idle_alert_v2;
	anims = %f_idle_alert_v3;
	
	anims = %f_firing_v1;
	anims = %f_firing_v2;
	anims = %f_firing_v3;
	anims = %f_firing_v4;
	anims = %f_firing_v5;
	anims = %f_firing_v6;
	anims = %f_firing_v7;
	anims = %f_firing_v8;
	anims = %f_firing_v9;
	anims = %f_firing_v10;
	anims = %f_firing_v12;
	anims = %f_firing_v13;
	anims = %f_firing_v14;
	anims = %f_firing_v15;

	anims = %f_im_reloading;
	
	anims = %f_melee_v1;
	anims = %f_melee_v2;
	anims = %f_melee_v3;
	anims = %f_melee_v4;
	
	anims = %f_pain_v1;
	anims = %f_pain_v2;
	anims = %f_pain_v3;
	anims = %f_pain_v4;
	anims = %f_pain_v5;
	
	anims = %f_death_v1;
	anims = %f_death_v2;
	anims = %f_death_v3;
	anims = %f_death_v4;
	anims = %f_death_v5;
	anims = %f_death_v6;
	anims = %f_death_v7;
	anims = %f_death_v8;
	
	anims = %f_react_v1;
	anims = %f_react_v2;
	anims = %f_react_v3;
	anims = %f_react_v4;
	anims = %f_react_v5;
	
	anims = %f_running_v1;
	anims = %f_running_v2;
}

init_serverfaceanim()
{
	self addAIEventListener( "grenade danger" );	
	self addAIEventListener( "bulletwhizby" );	
	self addAIEventListener( "projectile_impact" );	

	self.do_face_anims = true;

	if( !IsDefined( level.face_event_handler ) )
	{
		level.face_event_handler = SpawnStruct();
		level.face_event_handler.events = [];
		level.face_event_handler.events["death"] = 							"face_death";
		level.face_event_handler.events["grenade danger"] = 		"face_alert";
		level.face_event_handler.events["bulletwhizby"] = 			"face_alert";
		level.face_event_handler.events["projectile_impact"] = 	"face_alert";
		level.face_event_handler.events["explode"] = 						"face_alert";
		level.face_event_handler.events["alert"] = 							"face_alert";
		level.face_event_handler.events["shoot"] = 							"face_shoot_single";
		level.face_event_handler.events["melee"] = 							"face_melee";
		level.face_event_handler.events["damage"] = 						"face_pain";
		
		level thread wait_for_face_event();
	}
}

wait_for_face_event()
{
	while( true )
	{
		level waittill( "face", face_notify, ent );
		
		if( IsDefined( ent ) && IsDefined( ent.do_face_anims ) && ent.do_face_anims )
		{
			if( IsDefined( level.face_event_handler.events[face_notify] ) )
			{
				ent SendFaceEvent( level.face_event_handler.events[face_notify] );
			}
		}
	}
}
