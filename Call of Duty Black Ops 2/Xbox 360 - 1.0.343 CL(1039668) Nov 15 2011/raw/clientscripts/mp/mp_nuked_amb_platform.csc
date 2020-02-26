#include clientscripts\mp\_utility; 
#include clientscripts\mp\_ambientpackage;

main()
{
	if ( isdemoplaying() )
		return;
		
	thread clientscripts\mp\mp_nuked_amb::pa_think("notify_stones","mus_sympathy_for_the_devil");
}

pa_music()
{
	wait (10);
	level notify ("notify_stones");
}	
