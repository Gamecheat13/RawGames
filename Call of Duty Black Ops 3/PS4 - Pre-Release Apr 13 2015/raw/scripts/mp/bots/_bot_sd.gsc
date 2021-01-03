#using scripts\shared\array_shared;
#using scripts\shared\callbacks_shared;
#using scripts\shared\killstreaks_shared;
#using scripts\shared\math_shared;
#using scripts\shared\system_shared;
#using scripts\shared\util_shared;
#using scripts\shared\weapons_shared;
#using scripts\shared\weapons\_weapons;

    	   	                                                                                                                         	                                                                                                                                                                                                                                                                                                                                                                    	        	     	            	    	   	                           	                               	                                	                                                              	                                                                          	                            	                                     	                                       	                                                               	   	                  	       	                                                    	                   	                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                      	              	                  	                        	                                            	                                             	                                                   	                                                             	                                                         	                                                                    	                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                    	                                                              	                                                          	                                   	                                   	                                                    	                                       

#namespace bot;

function Callback_BotEnteredUserEdge( start, end, dir, beginDir, dist, zDelta, walldir, climb )
{	
	// These checks are really rough and ridiculous
	if ( climb )
	{
		self MoveTowards( end );
		self thread wait_acrobatics_end();
	}
	else if ( zDelta > 280 )
	{
		// Too high, need assert/cancel
		self BotReleaseManualControl();
	}
	else if ( zDelta >= 134 )
	{
		// DoubleJump
		self thread doublejump_traversal( start, end );
	}
	else if ( dist >= 500 )
	{
		// Wall Run
		self thread wallrun_traversal( start, end, beginDir, walldir );
	}
	else if ( zDelta >= 19 )
	{
		self thread jump_traversal( start, end );
	}
	else if ( zDelta < -225 )
	{
		// > 550 - Death
		// > 225 - Damage
		// Soft Fall
		self thread soft_fall_traversal( start, end );
	}
	else if ( zDelta < -20 )
	{
		// Fall
		self MoveTowards( end );
		self thread wait_acrobatics_end();
	}
	/*
	else if ( dist >= 1000 )
	{
		// Too Far
		self BotReleaseManualControl();
	}
*/
	else if ( dist >= 8 )
	{
		// Jump
		self thread jump_traversal( start, end );
	}
}

function jump_traversal( start, end )
{
	self endon( "death" );
	level endon( "game_ended" );
	
	self MoveTowards( end );
	
	{wait(.05);};
	
	self PressJumpButton();
	
	self thread wait_acrobatics_end();
}

function doublejump_traversal( start, end )
{
	self endon( "death" );
	level endon( "game_ended" );
	
	self MoveTowards( end );
	
	{wait(.05);};
	
	self PressJumpButton();
	
	// TODO: YUCK Fix this
	wait ( 0.3 );
	
	self PressDoubleJumpButton();
	
	self thread wait_acrobatics_end();
	
	self waittill( "acrobatics_end" );
	
	self ReleaseDoubleJumpButton();
}

function wallrun_traversal( start, end, beginDir, walldir )
{
	self endon( "death" );
	level endon( "game_ended" );
	
	self LookDirection( beginDir );
	self MoveDirection( walldir );

	{wait(.05);};
	
	self PressJumpButton();
	
	// TODO: If needed pressdoublejumpbutton
	
	self thread wait_wallrun_begin();
	self thread wait_wallrun_near( end );
	self thread wait_acrobatics_end();
}

function wait_wallrun_begin()
{
	self endon( "death" );
	self endon( "acrobatics_end" );
	level endon( "game_ended" );
	
	self waittill( "wallrun_begin" );
	
	self StopLook();
}

function wait_wallrun_near( end )
{
	self endon( "death" );
	self endon( "acrobatics_end" );
	level endon( "game_ended" );
	
	// Puuuke
	while ( true )
	{
	    {wait(.05);};
	    
		dx = self.origin[ 0 ] - end[ 0 ];
		dy = self.origin[ 1 ] - end[ 1 ];
		// Made up numbers, should get a projection onto the wall from the end node
		if ( dx * dx + dy * dy < 256 * 256 )
	    {
			break;
		}
	}
	
	self ClearLookAt();
	self MoveTowards( end );
	self PressJumpButton();
}

function soft_fall_traversal( start, end )
{
	self endon( "death" );
	self endon( "acrobatics_end" );
	level endon( "game_ended" );
		
	self MoveTowards( end );
	
	self thread wait_acrobatics_end();
	
	self waittill ( "acrobatics_begin" );
	
	// Puuuke
	while ( true )
	{
	    {wait(.05);};
		height = self.origin[ 2 ] - end[ 2 ];
		
		if ( height <= 150 )
		{
			self PressDoubleJumpButton();
			break;
		}
	}
	
	{wait(.05);};
	
	self ReleaseDoubleJumpButton();
}

function wait_acrobatics_end()
{
	self endon( "death" );
	level endon( "game_ended" );
	
	self waittill( "acrobatics_end" );
	
	self ClearLookAt();
	self BotReleaseManualControl();
}
