#include animscripts\utility;
#include animscripts\traverse\shared;
#include maps\_utility;
#using_animtree( "generic_human" );

main()
{
	london_roof_slide();
}

london_roof_slide()
{
	traverseData = [];
	traverseData[ "traverseAnim" ]			 = %london_warehouse_slide;

	self thread notetrack_sound();
	thread glass_break();
	DoTraverse( traverseData );
}

notetrack_sound()
{
	self endon( "death" );
	while ( 1 )
	{
		self waittill( "traverseAnim", notetrack );

		if ( notetrack == "end" )
		{
			break;
		}

		prefix = GetSubStr( notetrack, 0, 3 );
		if ( prefix == "ps_" )
		{
			alias = GetSubStr( notetrack, 3 );
			self thread play_sound_on_tag( alias, undefined, true );
			continue;
		}
	}
}

glass_break()
{
	node = self GetNegotiationStartNode();

	if ( !IsDefined( node.script_index ) )
	{
		return;
	}

	wait( 0.2 );

	prefix = "traverse_glass_";
	forward = AnglesToForward( node.angles );

	glass_array = GetGlassArray( prefix + node.script_index );
	foreach ( glass in glass_array )
	{
		DestroyGlass( glass, forward );
	}
}