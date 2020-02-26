#include common_scripts\utility;


//**********************************************************
//**********************************************************

init()
{
	//Use our own array to not break or be broken by other system
	/* Not use anumore
	level.ai_PerceptHudArray	 = [];
	level.ai_PerceptHudInCombat  = false;
	level.ai_PerceptHudForce	 = false;
	
	level thread PlayerInCombatThread();
	level thread indicator_thread();
	*/
}

//**********************************************************
//**********************************************************

PlayerInCombatThread()
{	
	self endon("death");
		
	/* Not use anumore
	while( 1 )
	{
		level.ai_PerceptHudInCombat = false;
		
		for(i=0; i < level.ai_PerceptHudArray.size && level.ai_PerceptHudInCombat == false;i++)
		{
			dude = level.ai_PerceptHudArray[i];
			if( isdefined(dude) )
			{	
				if( dude isengaged() ) 
				{
					level.ai_PerceptHudInCombat = true;
				}
			}
		}
		
		wait(0.5);
	}		
	*/
}

//**********************************************************
//**********************************************************

CalcNumBarAudition( target, distSq, yaw, pitch )
{	
	coneExtra = 20;		
	distExtra = 12*20;
	
	numBar   = 0;
	
	/* Not use anumore
	distId = self getauditiondist(target,"Identify");
	
	if( distSq < distId*distId )
	{
		numBar = 3;
	}
	else
	{
		distNotice = self getauditiondist(target,"Notice");
		if( distSq < distNotice*distNotice )
		{
			numBar = 2;
		}
		else 
		{
			distNoticeSafe = distNotice + distExtra;
			if( distSq < distNoticeSafe*distNoticeSafe )
			{
				numBar = 1;
			}
		}
	}
	*/
	return numBar;
}

//**********************************************************
//**********************************************************

CalcNumBarVision( target, distSq, yaw, pitch )
{				
	coneExtra = 20;		
	distExtra = 12*20;
	
	cone	  = self getvisioncone()+ coneExtra;	
						
	numBar   = 0;
	
	/* Not use anumore
	if( yaw < cone  )
	{
		distId = self getvisiondist(target,"Identify");
				
		if( distSq < distId*distId )
		{
			numBar = 3;
		}
		else
		{
			distNotice = self getvisiondist(target,"Notice");
			if( distSq < distNotice*distNotice )
			{
				numBar = 2;
			}
			else 
			{
				distNoticeSafe = distNotice + distExtra;
				if( distSq < distNoticeSafe*distNoticeSafe )
				{
					numBar = 1;
				}
			}
		}
	}
	else
	{
		distNotice = self getvisiondist(target,"Notice");
		distNoticeSafe = distNotice + distExtra;
		if( distSq < distNoticeSafe*distNoticeSafe )
		{
			numBar = 1;
		}
	}
	*/
	return numBar;
}

//**********************************************************
//**********************************************************

UpdateNumBar()
{		
	self endon("death");
	
	/* Not use anumore
	maxDistSq = 12*150;
	maxDistSq = maxDistSq*maxDistSq;
	
	self.PerceptHudNumBar = 0;
	
	while( self.PerceptHudIdx >= 0 )
	{		
		self.PerceptHudNumBar = 0;
		
		//For now we alwyas add a "bad" guy on the radar... later on, we might use isathreat only 
		if( self.team == "axis" || self isathreat(level.player) )
		{
			delta = level.player.origin - self.origin;
			distSq= lengthsquared(delta);
			
			//print3d (self.origin + (0,0,-20), "" + (sqrt(distSq)/12),	(0,1,0), 1, 1);	// origin, text, RGB, alpha, scale	
							
			if( level.ai_PerceptHudForce || distSq < maxDistSq )
			{										
				angles	  = vectortoangles(delta);
				eyeAngle  = self geteyeangles();
				yaw       = abs( angles[1] - eyeAngle[1] );
				if( yaw > 180 )
				{
					yaw = 360-yaw; 
				}
				pitch      = abs( angles[0] - eyeAngle[0] );
				if( pitch > 180 )
				{
					pitch = 360-pitch;
				}
				
				//print3d (self.origin + (0,0,-40), "" + yaw,	(0,1,0), 1, 1);	// origin, text, RGB, alpha, scale	

				numBarVision   = self CalcNumBarVision( level.player, distSq, yaw, pitch );
				numBarAudition = 0;
				//We are already maxed out.. no need to check audition
				if( level.ai_PerceptHudForce )
				{
					self.PerceptHudNumBar = 3;
				}
				else if( numBarVision>=3 )
				{
					self.PerceptHudNumBar = numBarVision;
				}
				else
				{
					numBarAudition = self CalcNumBarAudition( level.player, distSq, yaw, pitch );
					
					if( numBarVision > numBarAudition )
					{
						self.PerceptHudNumBar = numBarVision;
					}
					else
					{
						self.PerceptHudNumBar = numBarAudition;
					}
				}			
			}
		}		
		
		//Update with a little random, to avoid many AI in the same frame
		wait(randomfloatrange(0.10, 0.15));
	}	
	*/
}

//**********************************************************
//**********************************************************

cleanarray()
{		
	/* Not use anumore
	newArray = [];

	for(i=0;i<level.ai_PerceptHudArray.size;i++)
	{
		dude = level.ai_PerceptHudArray[i];
		if( isdefined(dude) )
		{			
			dude.PerceptHudIdx = newArray.size;
			newArray[newArray.size] = dude;				
		}
	}
	
	level.ai_PerceptHudArray = newArray;	
	*/	
	
}
			
//**********************************************************
//**********************************************************

indicator_thread()
{
	self endon("death");
		
	/* Not use anumore
	while( 1 )
	{
		if( isdefined(level.player) )
		{			
			perceiverIndex	= 0;
			
			cleanarray();

			if( !level.ai_PerceptHudInCombat || level.ai_PerceptHudForce )
			{
				for( i=0; i<level.ai_PerceptHudArray.size; i++)
				{
					dude = level.ai_PerceptHudArray[i];
					if( isdefined(dude) && dude.PerceptHudNumBar > 0 )
					{

						delta	  = level.player.origin - dude.origin;
						angles	  = vectortoangles(delta);
						
						dude setAiPerception( dude.PerceptHudNumBar );
						// removed by Steve Crowe - AI perception in minimap, not blue bars
						// level.player addaiperceiver( angles[1], dude.PerceptHudNumBar, perceiverIndex );
						perceiverIndex++;
																		
						//print3d (dude.origin + (0,0,0), "" + (sqrt(lengthsquared(delta))/12),	(1,0,0), 1, 1);	// origin, text, RGB, alpha, scale	
						//print3d (dude.origin + (0,0,20), "" + dude.PerceptHudNumBar,			(1,0,0), 1, 2);	// origin, text, RGB, alpha, scale				
					}
				}			
			}
			
			// removed by Steve Crowe - AI perception in minimap, not blue bars
//			level.player setnumaiperceivers( perceiverIndex );	
		}
		
		wait(0.05);
	}
	*/
}

//**********************************************************
//**********************************************************

add_ai()
{	
	/* Not use anumore
	self.PerceptHudIdx = level.ai_PerceptHudArray.size;
	
	level.ai_PerceptHudArray[ self.PerceptHudIdx ] = self;	
	
	self thread UpdateNumBar();
	*/
}

//**********************************************************
//**********************************************************
