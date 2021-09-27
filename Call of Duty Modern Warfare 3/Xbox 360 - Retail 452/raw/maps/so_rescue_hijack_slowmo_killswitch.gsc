#include maps\_utility;

//Becasue of a bug in coop network code we may not be able to do
//slow motion in coop networked game. This switch controls it.
init()
{
	if(is_coop())
	{
		level.no_slowmo 	= true;
		level.alena_escape 	= true;
	}
}