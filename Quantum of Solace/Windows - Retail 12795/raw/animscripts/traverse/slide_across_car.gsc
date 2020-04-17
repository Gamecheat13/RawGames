#include animscripts\traverse\shared;
//#using_animtree ("generic_human");

main()
{
// 	// do not do code prone in this script
//	self.desired_anim_pose = "stand";
//	animscripts\utility::UpdateAnimPose();
//	
//	self endon( "killanimscript" );
//	self traverseMode( "nogravity" );
//	self traverseMode( "noclip" );
//	
//	// orient to the Negotiation start node
//    startnode = self getNegotiationStartNode();
// 	endNode = self getNegotiationEndNode();
//    assert( isDefined( startnode ) );
//    assert( isDefined( endNode ) );
//    self OrientMode( "face angle", startnode.angles[1] );
//	
//	toCover = false;
//	if ( isDefined( self.node ) && self.node.type == "Cover Crouch" && distance( self.node.origin, endNode.origin ) < 5.0 )
//	{
//		toCover = true;
//		self setFlaggedAnimKnoballRestart( "slideanim", %slide_across_car_2_cover, %body, 1, .1, 1 );
//	}
//	else
//	{
//		self setFlaggedAnimKnoballRestart( "slideanim", %slide_across_car, %body, 1, .1, 1 );
//	}
//	
//	self.traverseDeath = 1;
//	self animscripts\shared::DoNoteTracks( "slideanim", ::handle_death );
//	self traverseMode( "gravity" );
//	if ( self.health == 1 )
//		return;
//
//	if ( toCover )
//	{
//		self teleport( self.node.origin );
//		println( distance( (self.node.origin[0], 0, 0), (self.origin[0], 0, 0) ) );
//		println( distance( (self.node.origin[1], 0, 0), (self.origin[1], 0, 0) ) );
//		return;
//	}
//	self.a.movement = "run";
//	self.a.alertness = "casual";
//	self setAnimKnobAllRestart( self.a.combatrunanim, %body, 1, 0.2, 1 );
}

handle_death( note )
{
//	if ( note != "traverse_death" )
//		return false;
//
////	self doDamage( self.health + 5, (0,0,0) );
//	self endon( "killanimscript" );
//
//	if ( self.health == 1 )
//	{
//		self.a.nodeath = true;
//		self setFlaggedAnimKnobAll( "deathanim", %slide_across_car_death, %body, 1, .1, 1 );
//		self animscripts\face::SayGenericDialogue("death");
//	}
//	self.traverseDeath++;
//	
//	return true;
}