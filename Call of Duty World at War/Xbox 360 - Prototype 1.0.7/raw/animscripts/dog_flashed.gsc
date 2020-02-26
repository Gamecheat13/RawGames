#using_animtree ("dog");

main()
{
	self endon("killanimscript");

	self clearanim(%root, 0);
	self setflaggedanimrestart("dog_anim", %german_shepherd_idle, 1, 0.2, 1);
	self waittillmatch( "dog_anim", "end" );
}
