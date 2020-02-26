#include animscripts\anims_table;


// where all the things we have to hide from zombies go
init()
{
	level.setup_anims_callback			= ::setup_anims;
	level.setup_anim_array_callback		= ::setup_anim_array;
	level.setup_wounded_anims_callback	= animscripts\anims_table_wounded::setup_wounded_anims;
}
