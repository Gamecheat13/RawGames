#using scripts\codescripts\struct;

#using scripts\shared\callbacks_shared;
#using scripts\shared\system_shared;

    	   	                                                                                                                                         	                                	                                                                                                                                                                                                                                                                                                                                                                    	        	     	             	    	   	               	                                              	                                                           	                               	                     	                                                                                                           	                                                                 	                                                              	                                                                                                              	                            	                                     	                                       	                                                                                                              	   	                  	       	                                                    	                   	                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                        	                                  	                                                                                        	           	                        	                                            	                                             	                                                   	                                                             	                                                         	                                                                    	                                                                                                                                                                                                    	                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                         	                                                              	                                                          	                                   	                                   	                                                    	                                       	                                           	     	                                                                                                                                                                                                                                                      	                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                     

#namespace serverfaceanim;

function autoexec __init__sytem__() {     system::register("serverfaceanim",&__init__,undefined,undefined);    }

function __init__()
{
	if ( !( isdefined( level._use_faceanim ) && level._use_faceanim ) )
	{
		return;
	}	
	callback::on_spawned( &init_serverfaceanim );
}

function init_serverfaceanim()
{	
	self.do_face_anims = true;

	if( !isdefined( level.face_event_handler ) )
	{
		level.face_event_handler = SpawnStruct();
		level.face_event_handler.events = [];
		level.face_event_handler.events["death"] = 							"face_death";
		level.face_event_handler.events["grenade danger"] = 				"face_alert";
		level.face_event_handler.events["bulletwhizby"] = 					"face_alert";
		level.face_event_handler.events["projectile_impact"] = 				"face_alert";
		level.face_event_handler.events["explode"] = 						"face_alert";
		level.face_event_handler.events["alert"] = 							"face_alert";
		level.face_event_handler.events["shoot"] = 							"face_shoot_single";
		level.face_event_handler.events["melee"] = 							"face_melee";
		level.face_event_handler.events["damage"] = 						"face_pain";
		
		level thread wait_for_face_event();
	}
}

function wait_for_face_event()
{
	while( true )
	{
		level waittill( "face", face_notify, ent );
		
		if( isdefined( ent ) && isdefined( ent.do_face_anims ) && ent.do_face_anims )
		{
			if( isdefined( level.face_event_handler.events[face_notify] ) )
			{
				ent SendFaceEvent( level.face_event_handler.events[face_notify] );
			}
		}
	}
}
