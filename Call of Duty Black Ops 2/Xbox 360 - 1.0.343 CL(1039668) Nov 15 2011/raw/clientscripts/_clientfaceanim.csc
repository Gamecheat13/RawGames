// Initial clientside script for doing face animations.
#include clientscripts\_utility;
#include clientscripts\_face_utility;

actor_facial_anim_flag_handler( localClientNum, set, newEnt )
{
	if ( set )
	{
		if ( GetDvarint( "cg_debugFace" ) != 0 )
		{
			PrintLn("*** SET flag face_disable - for ent " + self getentitynumber() + "["+self.type+"]");
		}
		self.face_disable = true;
		self notify( "face", "face_advance" );
	}
	else
	{
		if ( GetDvarint( "cg_debugFace" ) != 0 )
		{
			PrintLn("*** CLEARED flag face_disable - for ent " + self getentitynumber() + "["+self.type+"]");
		}
		self.face_disable = false;
		self notify( "face", "face_advance" );
	}
}

init_clientfaceanim()
{
	register_clientflag_callback("actor", 1, ::actor_facial_anim_flag_handler);
	
	// Attached in entity spawned
	if ( IsDefined(level.zombiemode) && level.zombiemode )
	{
		level._faceAnimCBFunc = clientscripts\_clientfaceanim::doFace;
	}
}

doFace( localClientNum )
{
	if ( self IsPlayer() )
		doFace_player( localClientNum );
	else if( isdefined( level._faceCBFunc_generichuman ) )
		self [[ level._faceCBFunc_generichuman ]]( localClientNum );
}

#using_animtree ( "multiplayer" );
doFace_player( localClientNum )
{
	self.face_anim_tree = "multiplayer";
	
	self setFaceRoot( %head );
	self buildFaceState( "face_casual", true, -1, 0, "basestate", %pf_casual_idle );
	self buildFaceState( "face_alert", true, -1, 0, "basestate", %pf_alert_idle );
	self buildFaceState( "face_shoot", true, 1, 1, "eventstate", %pf_firing );
	self buildFaceState( "face_melee", true, 2, 1, "eventstate", %pf_melee );
	self buildFaceState( "face_pain", false, -1, 2, "eventstate", %pf_pain );
	self buildFaceState( "face_death", false, -1, 2, "exitstate", %pf_death );
	self buildFaceState( "face_advance", false, -1, 3, "nullstate", undefined );

	self thread processFaceEvents( localClientNum );
}



