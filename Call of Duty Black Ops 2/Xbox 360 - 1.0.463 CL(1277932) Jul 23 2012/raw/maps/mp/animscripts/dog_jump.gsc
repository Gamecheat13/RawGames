#include maps\mp\animscripts\utility;
#include maps\mp\animscripts\shared;

main()
{
	self endon("killanimscript");

	debug_anim_print("dog_jump::main()" );
	self SetAimAnimWeights( 0, 0 );

	self.safeToChangeScript = false;
	self setanimstate( "traverse_wallhop" );
	maps\mp\animscripts\shared::DoNoteTracks( "done" );
	self.safeToChangeScript = true;
}