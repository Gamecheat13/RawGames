#include common_scripts\utility;
#include animscripts\traverse\shared;
#include animscripts\anims;

#using_animtree ("generic_human");

main()
{
	switch (self.type)
	{
	case "human": human(); break;
	default: assertmsg("Traversal: 'generic' doesn't support entity type '" + self.type + "'.");
	}
}

human()
{
	node = self GetNegotiationStartNode();

	assert( IsDefined(node) );
	assert( IsDefined(node.script_animation), "Negotion start node must have script_parameters kvp with animname when using generic traversal script" );

	animName = node.script_animation;

	assert( IsDefined(level.scr_anim[ "generic" ][ animName ]), "Anim '" + animName + "' not defined in level.scr_anim[\"generic\"]" );

	traverseData = [];
	traverseData[ "traverseAnim" ]	= level.scr_anim[ "generic" ][ animName ];

	DoTraverse( traverseData );
}
