// Fence_climb.gsc
// Makes the character climb a 48 unit fence
// TEMP - copied wall dive until we get an animation
// Makes the character dive over a low wall

#include animscripts\traverse\shared;
#using_animtree ("generic_human");

main()
{
	if (randomint(100) < 30)
		self advancedTraverse(%traverse_wallhop_3, 39.875);
	else
		self advancedTraverse(%traverse_wallhop, 39.875);
}