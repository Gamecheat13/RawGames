#include animscripts\traverse\shared;
#using_animtree ("generic_human");


main()
{
	if ( self.type == "human" )
		slide_across_car_human();
	else if ( self.type == "dog" )
		slide_across_car_dog();
}

slide_across_car_human()
{
 	// do not do code prone in this script
	self.desired_anim_pose = "stand";
	animscripts\utility::UpdateAnimPose();
	
	self endon( "killanimscript" );
	self traverseMode( "nogravity" );
	self traverseMode( "noclip" );
	
	// orient to the Negotiation start node
    startnode = self getNegotiationStartNode();
 	endNode = self getNegotiationEndNode();
    assert( isDefined( startnode ) );
    assert( isDefined( endNode ) );
    self OrientMode( "face angle", startnode.angles[1] );
	
	toCover = false;
	if ( isDefined( self.node ) && self.node.type == "Cover Crouch" && distance( self.node.origin, endNode.origin ) < 5.0 )
	{
		toCover = true;
		self setFlaggedAnimKnoballRestart( "slideanim", %slide_across_car_2_cover, %body, 1, .1, 1 );
//		self thread animscripts\utility::ragdollDeath( %slide_across_car_2_cover );
	}
	else
	{
		self setFlaggedAnimKnoballRestart( "slideanim", %slide_across_car, %body, 1, .1, 1 );
//		self thread animscripts\utility::ragdollDeath( %slide_across_car );
	}
	
	self.traverseDeath = 1;
	self animscripts\shared::DoNoteTracks( "slideanim", ::handle_death );
//	self animscripts\shared::DoNoteTracks( "slideanim" );
	self traverseMode( "gravity" );

	if ( self.health == 1 )
		return;

	self.a.nodeath = false;
	if ( toCover && isDefined( self.node ) )
	{
		self teleport( self.node.origin );
		return;
	}
	self.a.movement = "run";
	self.a.alertness = "casual";
	self setAnimKnobAllRestart( self.a.combatrunanim, %body, 1, 0.2, 1 );
}


handle_death( note )
{
	if ( note != "traverse_death" )
		return;

	self endon( "killanimscript" );

	if ( self.health == 1 )
	{
		self.a.nodeath = true;
			
		self.exception["move"] = ::dummyFunc;
		self setFlaggedAnimKnobAllRestart( "deathanim", %slide_across_car_death, %body, 1, .1, 1 );
		self animscripts\face::SayGenericDialogue("death");
		self animscripts\shared::DoNoteTracks( "deathanim" );
		return true;
	}
	self.traverseDeath++;
}

dummyFunc()
{
	self endon ( "killanimscript" );
	self animMode( "zonly_physics" );
	self waittill ( "eternity" );
}


#using_animtree ("dog");

slide_across_car_dog()
{
	self endon("killanimscript");
	self traverseMode("noclip");

	// orient to the Negotiation start node
	startnode = self getnegotiationstartnode();
	assert( isdefined( startnode ) );
	self OrientMode( "face angle", startnode.angles[1] );
	
	self clearanim(%root, 0.1);
	self setflaggedanimrestart( "traverse", anim.dogTraverseAnims["jump_up_40"], 1, 0.1, 1);
	self animscripts\shared::DoNoteTracks( "traverse" );

	self clearanim(%root, 0);
	self setflaggedanimrestart( "traverse", anim.dogTraverseAnims["jump_down_40"], 1, 0, 1);
	self animscripts\shared::DoNoteTracks( "traverse" );

	self traverseMode("gravity");	
	self.traverseComplete = true;
}