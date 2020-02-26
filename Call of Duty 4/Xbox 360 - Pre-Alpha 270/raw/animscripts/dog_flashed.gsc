#include animscripts\Combat_utility;

#using_animtree ("dog");

main()
{
	self endon("killanimscript");

	self clearanim(%root, 0);
	
	duration = self startFlashBanged();

	self setflaggedanimrestart("dog_anim", %german_shepherd_idle, 1, 0.2, 1);
	
	self animscripts\shared::DoNoteTracksForTime( duration * 0.001, "dog_anim" );
	
	self notify("stop_flashbang_effect");	
	self setFlashBanged( false );
	self.flashed = false;
}
