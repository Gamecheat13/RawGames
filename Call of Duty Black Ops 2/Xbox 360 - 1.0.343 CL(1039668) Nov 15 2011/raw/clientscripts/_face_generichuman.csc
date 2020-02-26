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
	self buildFaceState( "face_casual", true, -1, 0, "basestate", %f_idle_casual_v1 );
	
}

buildAlertFaceAnims()
{
	self buildFaceState( "face_alert", true, -1, 0, "basestate", %f_idle_alert_v1 );
	self addAnimToFaceState( "face_alert", %f_idle_alert_v2 );
}

buildCQBFaceAnims()
{
	self buildFaceState( "face_cqb", true, -1, 0, "basestate", %f_idle_alert_v3 );
}

buildRunningAnims()
{
	self buildFaceState( "face_running", true, -1, 0, "basestate", %f_running_v1 );
	self addAnimToFaceState( "face_running", %f_running_v2 );
}

buildSingleFireFaceAnims()
{
	self buildFaceState( "face_shoot_single", false, 1, 1, "eventstate", %f_firing_v7 );
	self addAnimToFaceState( "face_shoot_single", %f_firing_v10 );
	self addAnimToFaceState( "face_shoot_single", %f_firing_v13 );
	self addAnimToFaceState( "face_shoot_single", %f_firing_v14 );
	self addAnimToFaceState( "face_shoot_single", %f_firing_v15 );
}

buildBurstFireFaceAnims()
{
	self buildFaceState( "face_shoot_burst", true, 1, 1, "eventstate", %f_firing_v1 );
	self addAnimToFaceState( "face_shoot_burst", %f_firing_v2 );
	self addAnimToFaceState( "face_shoot_burst", %f_firing_v3 );
	self addAnimToFaceState( "face_shoot_burst", %f_firing_v4 );
	self addAnimToFaceState( "face_shoot_burst", %f_firing_v5 );
	self addAnimToFaceState( "face_shoot_burst", %f_firing_v6 );
	self addAnimToFaceState( "face_shoot_burst", %f_firing_v7 );
	self addAnimToFaceState( "face_shoot_burst", %f_firing_v8 );
	self addAnimToFaceState( "face_shoot_burst", %f_firing_v9 );
	self addAnimToFaceState( "face_shoot_burst", %f_firing_v10 );
	self addAnimToFaceState( "face_shoot_burst", %f_firing_v12 );
}

buildMeleeFaceAnims()
{
	self buildFaceState( "face_melee", true, 2, 1, "eventstate", %f_melee_v1 );
	self addAnimToFaceState( "face_melee", %f_melee_v2 );
	self addAnimToFaceState( "face_melee", %f_melee_v3 );
	self addAnimToFaceState( "face_melee", %f_melee_v4 );
}

buildTalkAnims()
{
	self buildFaceState( "face_talk", true, 0.1, 2, "eventstate", %f_im_reloading );
}

buildReactAnims()
{
	self buildFaceState( "face_react", false, -1, 2, "eventstate", %f_react_v1 );
	self addAnimToFaceState( "face_react", %f_react_v2 );
	self addAnimToFaceState( "face_react", %f_react_v3 );
	self addAnimToFaceState( "face_react", %f_react_v4 );
	self addAnimToFaceState( "face_react", %f_react_v5 );
}

buildPainFaceAnims()
{
	self buildFaceState( "face_pain", false, -1, 3, "eventstate", %f_pain_v1 );
	self addAnimToFaceState( "face_pain", %f_pain_v2 );
	self addAnimToFaceState( "face_pain", %f_pain_v3 );
	self addAnimToFaceState( "face_pain", %f_pain_v4 );
	self addAnimToFaceState( "face_pain", %f_pain_v5 );
}

buildDeathFaceAnims()
{
	self buildFaceState( "face_death", false, -1, 4, "exitstate", %f_death_v1 );
	self addAnimToFaceState( "face_death", %f_death_v2 );
	self addAnimToFaceState( "face_death", %f_death_v3 );
	self addAnimToFaceState( "face_death", %f_death_v4 );
	self addAnimToFaceState( "face_death", %f_death_v5 );
	self addAnimToFaceState( "face_death", %f_death_v6 );
	self addAnimToFaceState( "face_death", %f_death_v7 );
	self addAnimToFaceState( "face_death", %f_death_v8 );
}

doFace_generichuman( localClientNum )
{
	if ( isdefined( level.zombiemode ) && level.zombiemode )
		return;

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
	self buildFaceState( "face_advance", false, -1, 4, "nullstate", undefined );

	self thread processFaceEvents( localClientNum );
}
