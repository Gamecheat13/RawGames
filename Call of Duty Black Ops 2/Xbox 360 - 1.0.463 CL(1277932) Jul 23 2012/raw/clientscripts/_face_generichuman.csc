// Initial clientside script for doing face animations.
#include clientscripts\_face_utility;

init()
{
	// Attached in entity spawned
	level._faceCBFunc_generichuman = clientscripts\_face_generichuman::doFace_generichuman;
}

#using_animtree ( "generic_human" );

buildCasualFaceAnims()
{
	animlist = array(
		%f_idle_casual_v1,
		%f_idle_casual_v2,
		%f_idle_casual_v3
	);
	self buildFaceState( "face_casual", true, -1, 0, "basestate", animlist );
}

buildAlertFaceAnims()
{
	animlist = array(
		%f_idle_alert_v2,
		%f_idle_alert_v4,
		%f_idle_alert_v6,
		%f_idle_alert_v8,
		%f_idle_alert_v9,
		%f_idle_alert_v10
	);
	self buildFaceState( "face_alert", true, -1, 0, "basestate", animlist );	
}

buildCQBFaceAnims()
{
	animlist = array (
		%f_idle_alert_v1,
		%f_idle_alert_v4
	);
	self buildFaceState( "face_cqb", true, -1, 0, "basestate", animlist );
}

buildRunningAnims()
{
	animlist = array(
		%f_running_v1,
		%f_running_v2
	);
	self buildFaceState( "face_running", true, -1, 0, "basestate", animlist );
}

buildSingleFireFaceAnims()
{
	animlist = array(
		%f_firing_v8,
		%f_firing_v10,
		%f_firing_v11,
		%f_firing_v13,
		%f_firing_v14
	);
	self buildFaceState( "face_shoot_single", false, 1, 1, "eventstate", animlist );
}

buildBurstFireFaceAnims()
{
	animlist = array(
		%f_firing_v2,
		%f_firing_v3,
		%f_firing_v7,
		%f_firing_v9,
		%f_firing_v12
	);
	self buildFaceState( "face_shoot_burst", true, 1, 1, "eventstate", animlist );
}

buildMeleeFaceAnims()
{
	animlist = array(
		%f_melee_v1,
		%f_melee_v2,
		%f_melee_v3,
		%f_melee_v4,
		%f_melee_v5,
		%f_melee_v6,
		%f_melee_v7,
		%f_melee_v8
	);
	self buildFaceState( "face_melee", true, 2, 1, "eventstate", animlist );
}

buildTalkAnims()
{
	animlist = array(
		%f_im_reloading
	);
	self buildFaceState( "face_talk", true, 0.1, 2, "eventstate", animlist );
}

buildReactAnims()
{
	animlist = array(
		%f_react_v3,
		%f_react_v4,
		%f_react_v6
	);
	self buildFaceState( "face_react", false, -1, 2, "eventstate", animlist );
}

buildPainFaceAnims()
{
	animlist = array(
		%f_pain_v1,
		%f_pain_v2,
		%f_pain_v4,
		%f_pain_v5,
		%f_pain_v6,
		%f_pain_v7
	);
	self buildFaceState( "face_pain", false, -1, 3, "eventstate", animlist );
}

buildDeathFaceAnims()
{
	animlist = array(
		%f_death_v1,
		%f_death_v2,
		%f_death_v3,
		%f_death_v4,
		%f_death_v5,
		%f_death_v6,
		%f_death_v7,
		%f_death_v8
	);
	self buildFaceState( "face_death", false, -1, 4, "exitstate", animlist );
}

doFace_generichuman( localClientNum )
{
	if( self.species != "human" )
		return;

	if( !IsDefined( self.face_disable ) )
	{
		self.face_disable = false;
	}
	if( !IsDefined( self.face_death ) )
	{
		self.face_death = false;
	}

	self.face_anim_tree = "generic_human";
	
	if( !IsDefined( level.faceStates ) )
	{
		level.faceStates = [];
	}
	
	if ( !isdefined( level.faceStates[self.face_anim_tree] ) )
	{
		self setFaceRoot( %faces );
		self buildCasualFaceAnims();
		self buildAlertFaceAnims();
		self buildCQBFaceAnims();
		self buildSingleFireFaceAnims();
		self buildBurstFireFaceAnims();
		self buildMeleeFaceAnims();
		self buildPainFaceAnims();
		self buildDeathFaceAnims();
		self buildTalkAnims();
		self buildReactAnims();
		self buildRunningAnims();
		self buildFaceState( "face_advance", false, -1, 4, "nullstate", undefined ); // Face advance has an empty list
	}

	self thread processFaceEvents( localClientNum );
}
