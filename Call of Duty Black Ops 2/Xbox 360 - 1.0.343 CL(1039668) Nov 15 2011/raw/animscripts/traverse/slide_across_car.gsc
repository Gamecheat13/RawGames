#include common_scripts\utility;
#include animscripts\traverse\shared;
#include maps\_utility;
#include animscripts\anims;

#using_animtree ("generic_human");

main()
{
	switch (self.type)
	{
	case "human": human(); break;
	case "dog": dog(); break;
	case "zombie": human(); break;
	case "zombie_dog": dog(); break;
	default: assertmsg("Traversal: 'mantle_over_40' doesn't support entity type '" + self.type + "'.");
	}
}

human()
{
	PrepareForTraverse();

	traverseData = [];
	traverseData[ "traverseAnim" ]			= animArray("slide_across_car", "move");
	traverseData[ "traverseToCoverAnim" ]	= animArray("slide_across_car_to_cover", "move");
	traverseData[ "coverType" ]				= "Cover Crouch";
	traverseData[ "traverseHeight" ]		= 38.0;
	traverseData[ "interruptDeathAnim" ][0]	= array( animArray("slide_across_car_death", "move") );
	traverseData[ "traverseSound" ] 		= "npc_car_slide_hood";
	traverseData[ "traverseToCoverSound" ]	= "npc_car_slide_cover";
	
	DoTraverse( traverseData );
}

#using_animtree("dog");

dog()
{
	self endon("killanimscript");
	self traverseMode("noclip");

	// orient to the Negotiation start node
	startnode = self getnegotiationstartnode();
	assert( IsDefined( startnode ) );
	self OrientMode( "face angle", startnode.angles[1] );
	
	self ClearAnim(%root, 0.1);
	self SetFlaggedAnimRestart( "traverse", anim.dogTraverseAnims["jump_up_40"], 1, 0.1, 1);
	self animscripts\shared::DoNoteTracks( "traverse" );

	// TEMP, can't hear jump over sounds
	self thread play_sound_in_space( "aml_dog_bark", self gettagorigin( "tag_eye" ) );

	self ClearAnim(%root, 0);
	self SetFlaggedAnimRestart( "traverse", anim.dogTraverseAnims["jump_down_40"], 1, 0, 1);
	self animscripts\shared::DoNoteTracks( "traverse" );

	self traverseMode("gravity");	
	self.traverseComplete = true;
}