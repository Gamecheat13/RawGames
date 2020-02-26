// this is called when an AI is in the exposed attack state, unable to attack its enemy
// it calls this anim script while it thinks about different ways to attack the enemy
// it also calls this script when trying to find new cover
// it could call this anim script for a single server frame, or it could take several seconds

#using_animtree ("generic_human");

main()
{
    self trackScriptState( "Reacquire Main", "code" );
	self endon("killanimscript");
    animscripts\utility::initialize("reacquire");

    for (;;)
    {
        //        self . scriptState = "reacquire";

        // If I'm wounded, I act differently until I recover
        if (self.anim_pose == "wounded")
        {
            self animscripts\wounded::rest("reacquire::main");
        }

        //If I'm aiming then keep aiming while I figure out what to do
        if ( (self.anim_alertness == "aiming") && (self.anim_movement == "stop") )
        {
            animscripts\aim::keep_aiming();
        }
        //Otherwise stand around and think
        else
            animscripts\stop::main();
    }
    
}
