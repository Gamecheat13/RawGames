// Jump_across_72.gsc
// Makes the character do a lateral jump of 72 units.
#include animscripts\traverse\shared;
#using_animtree( "generic_human" );

main()
{
	// Late in project hack to get dogs to use traversals
	// that do not have a target ent from the begin node. -JC
	if ( self.type == "dog" )
	{
		// 20 is a good number to allow dogs to
		// use the traverse without going too high
		// or too low. JC:ToDo - Adjust this traversal
		// to have a target ent
		dog_long_jump( "wallhop", 20 );
		return;
	}
	
 	// do not do code prone in this script
	self.desired_anim_pose = "stand";
	animscripts\utility::UpdateAnimPose();

	self endon( "killanimscript" );
	self traverseMode( "nogravity" );
	self traverseMode( "noclip" );

	// orient to the Negotiation start node
    startnode = self getnegotiationstartnode();
    assert( isdefined( startnode ) );
    self OrientMode( "face angle", startnode.angles[ 1 ] );

	self setFlaggedAnimKnoballRestart( "jumpanim", %jump_across_72, %body, 1, .1, 1 );
	self waittillmatch( "jumpanim", "gravity on" );
	self traverseMode( "gravity" );
	self animscripts\shared::DoNoteTracks( "jumpanim" );
}
