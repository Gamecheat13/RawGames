// Initial clientside script for doing face animations.
#include clientscripts\mp\_face_utility_mp;
#include clientscripts\mp\_utility;

actor_flag_change_handler( localClientNum, flag, set, newEnt )
{
	if( flag == 1 )
	{
		if ( set )
		{
			//println("*** SET flag " + flag + " - for ent " + self getentitynumber() + "["+self.type+"]");
			self.face_disable = true;
			self notify( "face", "face_advance" );
		}
		else
		{
			//println("*** CLEARED flag " + flag + " - for ent " + self getentitynumber() + "["+self.type+"]");
			self.face_disable = false;
			self notify( "face", "face_advance" );
		}
	}
}

init_clientfaceanim()
{
	level._client_flag_callbacks["actor"] = clientscripts\mp\_clientfaceanim_mp::actor_flag_change_handler;

	// Attached in entity spawned
	if ( level.IsDemoPlaying )
	{
		level._faceAnimCBFunc = clientscripts\mp\_clientfaceanim_mp::doFace;	
	}
	BuildFace_player();
}

doFace( localClientNum )
{
	if ( self IsPlayer() )
	{
		while( true )
		{
			if ( self IsPlayer() )
			{
				//PrintLn( "DoFace!" );
				self thread processFaceEvents( localClientNum );
				self waittill( "respawn" );
				while( !IsDefined( self ) )
				{
					wait( 0.05 );
				}
				self.face_death = false;
				self.face_disable = false;
			}
		}
	}	
}

#using_animtree ( "multiplayer" );
BuildFace_player()
{
	level.face_anim_tree = "multiplayer";
	
	self setFaceRoot( %head );
	self buildFaceState( "face_casual", true, -1, 0, "basestate", %pf_casual_idle );
	self buildFaceState( "face_alert", true, -1, 0, "basestate", %pf_alert_idle );
	self buildFaceState( "face_shoot", true, 1, 1, "eventstate", %pf_firing );
	self buildFaceState( "face_shoot_single", true, 1, 1, "eventstate", %pf_firing );
	self buildFaceState( "face_melee", true, 2, 1, "eventstate", %pf_melee );
	self buildFaceState( "face_pain", false, -1, 2, "eventstate", %pf_pain );
	self buildFaceState( "face_death", false, -1, 2, "exitstate", %pf_death );
	self buildFaceState( "face_advance", false, -1, 3, "nullstate", undefined );
}

do_corpse_face_hack(localClientNum)
{
	if( IsDefined( self ) && IsDefined( level.face_anim_tree ) && IsDefined( level.faceStates ) )
	{
		numAnims = level.faceStates["face_death"]["animation"].size;
		self waittill_dobj(localClientNum);
		if ( !isdefined ( self ) )
			return;
		self SetAnimKnob( level.faceStates["face_death"]["animation"][RandomInt(numAnims)], 1.0, 0.1, 1.0 );
	}
}
