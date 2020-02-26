#using_animtree("generic_human");

main()
{
	anims();
	//run_anims();
	//dialogue();
}

anims()
{

	// First house
	level.scr_anim[ "price" ][ "hunted_open_barndoor" ] =			%hunted_open_barndoor;
	level.scr_anim[ "price" ][ "hunted_open_barndoor_stop" ] =		%hunted_open_barndoor_stop;
	level.scr_anim[ "price" ][ "hunted_open_barndoor_idle" ][0] =	%hunted_open_barndoor_idle;
	

}