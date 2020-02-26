#using_animtree ("dog");

main()
{
	self endon("killanimscript");
	
	self clearanim(%root, 0.2);
	self clearanim(%german_shepherd_idle, 0);
	self setflaggedanimrestart("dog_idle", %german_shepherd_idle, 1, 0.2, 1);	
	
	while (1)
	{
		animscripts\shared::DoNoteTracksForTime(1, "dog_idle");
		self setanim(%german_shepherd_idle, 1, 0.2, 1);
	}
}
