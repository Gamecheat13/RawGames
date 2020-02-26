#include maps\mp\_utility;
#include common_scripts\utility;

init()
{
	for(;;)
	{
		level waittill ( "connecting", player );

		player thread onPlayerSpawned();
	}
}

onPlayerSpawned()
{
	self endon( "disconnect" );

	for(;;)
	{
		self waittill( "spawned_player" );

		self thread init_serverfaceanim();
	}
}

init_serverfaceanim()
{	
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
