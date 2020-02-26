#include maps\_utility;
#include maps\_civilian;

civilian_idle()
{
	self endon ( "civilian_death" );
	
	//takes notifies to start and stop doing idles - usually so another animation can take over
	for (;;)
	{
		self civilian_doIdle();
		self waittill ( "civilian_stop_idle" );
		self civilian_stopIdle();
		self waittill ( "civilian_idle" );
	}
}

civilian_doIdle()
{
	self endon ( "civilian_stop_idle" );
	self endon ( "civilian_death" );
	
	//make sure he's not doing a looping anim already
	self notify ( "stop_looping_anim" );
	
	//make sure this thread can't be ran 2 time simultaniously
	self endon ( "stop_looping_anim" );
	
	//start the generic idle animation loop
	self thread civilian_anim_loop ( "idle", "stop_looping_anim" );
	
	//run the thread to wait for him to be aimed at
	self thread civilian_aimedAt();
}

civilian_stopIdle()
{	
	//end the thread that waits for him to be aimed at since he's not idleing anymore
	self notify ( "civilian_stop_aimedAt" );
	
	//stop the idle animation from playing - another function is taking over to play animations
	self notify ( "stop_looping_anim" );
}

civilian_aimedAt()
{
	//end this thread when he isn't doing idles anymore - ended by the 'civilian_stopIdle' function
	self notify ( "civilian_stop_aimedAt" );
	self endon ( "civilian_stop_aimedAt" );
	self endon ( "civilian_death" );
	
	for (;;)
	{
		while (!self playerAimAtCharacterCheck())
			wait 0.5;
		
		//gun is now pointed at him - stop looping idle animations
		self notify ( "stop_looping_anim" );
		
		//idle to pointidle transition
		self civilian_anim_single ( "idle2point" );
		
		//looping 'pointidle' animation with arms in the air
		self thread civilian_anim_loop ( "pointidle", "stop_looping_anim");
		
		//wait until players gun is not pointed at him anymore
		while (self playerAimAtCharacterCheck())
			wait 0.5;
		
		//end the looping 'pointidle' animation
		self notify ( "stop_looping_anim" );
		
		//transition from 'pointidle' to 'idle' - arms come back down
		self civilian_anim_single ( "point2idle" );
	
		//back to idle where he was
		self civilian_doIdle();
		
		wait 0.5;
	}
}

civilian_react_gunfire()
{
	self endon ( "civilian_death" );
	nextAnim = 0;
	for (;;)
	{
		self waittill ( "do_reaction", type );
		println ( "Civilian or Hostage is reacting to: " + type );
		
		//gun was fired - make him stop doing his idle
		self notify ( "civilian_stop_idle" );
		
		//play a reaction animation - temp - switches between the 2 valid reaction animations available
		if (nextAnim == 0)
		{
			self civilian_anim_single ( "react" );
			nextAnim = 1;
		}
		else
		{
			self civilian_anim_single ( "react2crouch" );
			nextAnim = 0;
		}
		
		//go back to doing idle now
		self notify ( "civilian_idle" );
		
		//wait before making him aware again - fixes animation bug where he wont react since they could be the same frame
		wait 0.5;
	}
}

playerAimAtCharacterCheck()
{
	prof_begin("civilian_math");
	
	characterWithinPlayersView = false;
	playerWithinCharactersView = false;
	sightTracePassed = false;
	
	//Character is within 20 degrees of the Players FOV
	if (!isdefined(level.cos20))
		level.cos20 = cos(20);
	
	//Player is within 40 degrees of the Characters FOV
	if (!isdefined(level.cos50))
		level.cos50 = cos(50);
	
	//Check if the Character is within range of the Player
	//####################################################
	if (distance( level.player.origin, self.origin ) > 300 )
	{
		prof_end("civilian_math");
		return false;
	}
	
	//Check if the Character is within the Players View
	//#################################################
	forwardvec = anglestoforward( level.player.angles );
	normalvec = vectorNormalize( self.origin - ( level.player getOrigin() ) );
	vecdot = vectordot( forwardvec, normalvec );
	if (vecdot > level.cos20)
		characterWithinPlayersView = true;
	else
	{
		prof_end("civilian_math");
		return false;
	}
	
	//Check if the Player is within the Characters View
	//#################################################
	forwardvec = anglestoforward( self.angles );
	normalvec = vectorNormalize( ( level.player getOrigin() ) - self.origin );
	vecdot = vectordot( forwardvec, normalvec );
	if (vecdot > level.cos50)
		playerWithinCharactersView = true;
	else
	{
		prof_end("civilian_math");
		return false;
	}
	
	//Check if the Player and Character can see each other
	//####################################################
	sightTracePassed = ( bullettracepassed(level.player getEye(), self.origin + (0,0,48), false, self) );
	
	prof_end("civilian_math");
	
	if (characterWithinPlayersView & playerWithinCharactersView & sightTracePassed)
		return true;
}