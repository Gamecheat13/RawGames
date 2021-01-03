#using scripts\shared\array_shared;
#using scripts\shared\colors_shared;
#using scripts\shared\spawner_shared;
#using scripts\shared\system_shared;
#using scripts\shared\util_shared;

    	   	                                                                                                                         	                                                                                                                                                                                                                                                                                                                                                                    	        	     	             	    	   	                           	                               	                                	                                                              	                                                                                                              	                            	                                     	                                       	                                                               	   	                  	       	                                                    	                   	                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                        	                                                                                        	           	                        	                                            	                                             	                                                   	                                                             	                                                         	                                                                    	                                                                                                                                                                                                    	                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                      	                                                              	                                                          	                                   	                                   	                                                    	                                       

#using scripts\shared\ai\archetype_utility;
#using scripts\shared\ai\systems\init;
#using scripts\shared\ai\archetype_utility;
#namespace ai_puppeteer;

function autoexec __init__sytem__() {     system::register("ai_puppeteer",&__init__,undefined,undefined);    }

function __init__()
{
/#
	level thread ai_puppeteer_think();
#/
}

/#
	
function ai_puppeteer_think()
{	
	while(1)
	{
		if( GetDvarString( "debug_ai_puppeteer" ) == "1" && (!isdefined(level.ai_puppeteer_active) || level.ai_puppeteer_active == false) )
		{
			level.ai_puppeteer_active = true;
			level notify ("kill ai puppeteer");	
			AddDebugCommand( "noclip" );
			thread ai_puppeteer();
		}
		else if (GetDvarString( "debug_ai_puppeteer" ) == "0" && isdefined(level.ai_puppeteer_active) && level.ai_puppeteer_active == true )
		{
			level.ai_puppeteer_active = false;
			AddDebugCommand( "noclip" );
			level notify ("kill ai puppeteer");
		}
	
		{wait(.05);};
	}
	
}

// This allows the player to take control of any AI and issue certain commands
function ai_puppeteer()
{
	// main
	player = undefined;
	
	while ( !IsPlayer( player ) )
	{
		player = GetPlayers()[0];
		
		{wait(.05);};
	}
	
	ai_puppeteer_create_hud();
	
	level.ai_puppet_highlighting = false;
	
	player thread ai_puppet_cursor_tracker();
	player thread ai_puppet_manager();

	player.ignoreMe = true;
	
	// Cleanup hudelems, etc.
	level waittill ("kill ai puppeteer");

	player.ignoreMe = false;

	ai_puppet_release(true);

	if( isdefined(level.ai_puppet_target) )
	{
		level.ai_puppet_target Delete();
	}

	ai_puppeteer_destroy_hud();
}

function ai_puppet_manager()
{
	level endon("kill ai puppeteer");
	self endon("death");
	
	while(1)
	{
		// Update the look at position each frame
		if( isdefined( level.playerCursor["position"] ) && isdefined( level.ai_puppet ) && isdefined( level.ai_puppet.debugLookAtEnabled ) && ( level.ai_puppet.debugLookAtEnabled == 1 ) )
		{
			level.ai_puppet lookAtPos( level.playerCursor["position"] );
		}
			
		//added in to teleport AI
		if( self ButtonPressed( "BUTTON_RSTICK" ) && self ButtonPressed( "BUTTON_LSTICK" ) )
		{
			if( isdefined( level.ai_puppet ) )
			{
				level.ai_puppet ForceTeleport( level.playerCursor["position"], level.ai_puppet.angles );
			}
			wait(0.2);
		}
		else if( self ButtonPressed("BUTTON_RSTICK") ) // shoot
		{
			if( isdefined(level.ai_puppet) )
			{
				// get rid of old target
				if( isdefined( level.ai_puppet_target ) )
				{
					if( IsAi(level.ai_puppet_target) )
					{
						self thread ai_puppeteer_highlight_ai( level.ai_puppet_target, (1,0,0) );

						level.ai_puppet ClearEntityTarget();
						level.ai_puppet_target = undefined;
					}
					else
					{
						self thread ai_puppeteer_highlight_point( level.ai_puppet_target.origin, level.ai_puppet_target_normal, anglestoforward( self getplayerangles() ), (1,0,0) );

						level.ai_puppet ClearEntityTarget();
						level.ai_puppet_target Delete();
					}
				}
				else // setup new target
				{
					if( isdefined(level.playerCursorAi) )
					{
						if( level.playerCursorAi != level.ai_puppet )
						{
							level.ai_puppet SetEntityTarget( level.playerCursorAi );
							
							level.ai_puppet_target = level.playerCursorAi;
							level.ai_puppet GetPerfectInfo( level.ai_puppet_target );

							self thread ai_puppeteer_highlight_ai( level.playerCursorAi, (1,0,0) );
						}
					}
					else
					{
						level.ai_puppet_target = Spawn( "script_model", level.playerCursor["position"] );
						//level.ai_puppet_target SetModel( "tag_origin" );
						level.ai_puppet_target_normal = level.playerCursor["normal"];

						level.ai_puppet SetEntityTarget( level.ai_puppet_target );

						self thread ai_puppeteer_highlight_point( level.ai_puppet_target.origin, level.ai_puppet_target_normal, anglestoforward( self getplayerangles() ), (1,0,0) );
					}
				}
			}

			wait(0.2);
		}
		else if( self ButtonPressed("BUTTON_A") ) // goto
		{
			if( isdefined(level.ai_puppet) )
			{
				if( isdefined(level.playerCursorAi) && level.playerCursorAi != level.ai_puppet )
				{
					level.ai_puppet SetGoal(level.playerCursorAi);
					level.ai_puppet.goalradius = 64;

					self thread ai_puppeteer_highlight_ai( level.playerCursorAi, (0,1,0) );
				}
				else if( isdefined(level.playerCursorNode) )
				{
					level.ai_puppet SetGoal(level.playerCursorNode );
					
					self thread ai_puppeteer_highlight_node( level.playerCursorNode );
				}
				else
				{
					if( isdefined(level.ai_puppet.scriptenemy) )
					{
						to_target = level.ai_puppet.scriptenemy.origin - level.ai_puppet.origin;
					}
					else
					{
						to_target = level.playerCursor["position"] - level.ai_puppet.origin;
					}

					angles = VectorToAngles(to_target);

					level.ai_puppet SetGoal( level.playerCursor["position"] );
					
					self thread ai_puppeteer_highlight_point( level.playerCursor["position"], level.playerCursor["normal"], anglestoforward( self getplayerangles() ), (0,1,0) );
				}	
				
			}

			wait(0.2);
		}
		else if( self ButtonPressed("BUTTON_B") && self ButtonPressed("BUTTON_Y") ) // goto forced
		{
			if( isdefined(level.ai_puppet) )
			{
				if( isdefined(level.playerCursorAi) && level.playerCursorAi != level.ai_puppet )
				{
					level.ai_puppet SetGoal(level.playerCursorAi);
					level.ai_puppet.goalradius = 64;

					self thread ai_puppeteer_highlight_ai( level.playerCursorAi, (0,1,0) );
				}
				else if( isdefined(level.playerCursorNode) )
				{
					level.ai_puppet SetGoal(level.playerCursorNode, true );
					
					self thread ai_puppeteer_highlight_node( level.playerCursorNode );
				}
				else
				{
					if( isdefined(level.ai_puppet.scriptenemy) )
					{
						to_target = level.ai_puppet.scriptenemy.origin - level.ai_puppet.origin;
					}
					else
					{
						to_target = level.playerCursor["position"] - level.ai_puppet.origin;
					}

					angles = VectorToAngles(to_target);

					level.ai_puppet SetGoal( level.playerCursor["position"], true );
					
					self thread ai_puppeteer_highlight_point( level.playerCursor["position"], level.playerCursor["normal"], anglestoforward( self getplayerangles() ), (0,1,0) );
				}	
				
			}

			wait(0.2);
		}
		else if( self ButtonPressed("BUTTON_X") ) // select
		{
			if( isdefined(level.playerCursorAi) )
			{
				if( isdefined(level.ai_puppet) && level.playerCursorAi == level.ai_puppet )
				{
					ai_puppet_release(true);
				}
				else
				{
					if( isdefined(level.ai_puppet) )
					{
						ai_puppet_release(false);
					}

					ai_puppet_set();

					self thread ai_puppeteer_highlight_ai( level.ai_puppet, (0,1,1) );
				}
			}

			wait(0.2);
		}
		else if( self ButtonPressed("BUTTON_Y") ) 
		{
			if( IsDefined( level.ai_puppet ) )
				level.ai_puppet ClearForcedGoal();
			
			wait(0.2);
		}

		// render chose targets
		if( isdefined(level.ai_puppet) )
		{
			ai_puppeteer_render_ai( level.ai_puppet, (0,1,1) );

			if( isdefined(level.ai_puppet.scriptenemy) && !level.ai_puppet_highlighting )
			{
				if( IsAi(level.ai_puppet.scriptenemy) )
				{
					ai_puppeteer_render_ai( level.ai_puppet.scriptenemy, (1,0,0) );
				}
				else if( isdefined(level.ai_puppet_target) )
				{
					self thread ai_puppeteer_render_point( level.ai_puppet_target.origin, level.ai_puppet_target_normal, anglestoforward( self getplayerangles() ), (1,0,0) );
				}
			}
		}
		
		
		// modify the radius based on the devgui
		if( IsDefined(level.ai_puppet) )
		{
			if( self ButtonPressed("DPAD_UP") )
			{
				level.ai_puppet.goalradius = level.ai_puppet.goalradius + 64;
			}
			else if( self ButtonPressed("DPAD_DOWN") )
			{
				radius = level.ai_puppet.goalradius - 64;
				
				if( radius < 16 )
				{
					radius = 16;
				}
				
				level.ai_puppet.goalradius = radius;
			}
			else if( self ButtonPressed("DPAD_LEFT") )
			{
				level.ai_puppet.goalradius = 16;
			}
		}
		
		if( IsDefined( level.ai_puppet ) )
		{
			if(GetDvarString("debug_ai_puppeteer_fixednode") == "1" )
			{
				level.ai_puppet.fixedNode = true;
				ai_puppeteer_render_ai( level.ai_puppet, (1,1,1) );
			}
			else
			{
				level.ai_puppet.fixedNode = false;
			}
		}

		{wait(.05);};
	}
}

function ai_puppet_set()
{
	level.ai_puppet = level.playerCursorAi;
	//added this to let the ai know he is a puppet
	level.ai_puppet.isPuppet = true;
	// save some settings
	level.ai_puppet.old_goalradius = level.ai_puppet.goalradius;
	level.ai_puppet.goalradius = 16;
	level.ai_puppet StopAnimScripted();
}

function ai_puppet_release(restore)
{
	if( isdefined(level.ai_puppet) )
	{
		if( restore )
		{
			// restore old setting
			//level.ai_puppet.ignoreAll	= level.ai_puppet.old_ignoreAll;
			level.ai_puppet.goalradius	= level.ai_puppet.old_goalradius;
			level.ai_puppet.isPuppet = false;
			level.ai_puppet ClearEntityTarget();
		}

		level.ai_puppet = undefined;
	}
}

function ai_puppet_cursor_tracker()
{
	level endon("kill ai puppeteer");
	self endon("death");

	while(1)
	{
		forward = anglestoforward( self getplayerangles() );
		forward_vector = VectorScale(forward, 4000);

		level.playerCursor = bullettrace( self geteye(), self geteye() + forward_vector, true, self );

		level.playerCursorAi	= undefined;
		level.playerCursorNode	= undefined;
		
		cursorColor = (0,1,1);

		hitEnt = level.playerCursor["entity"];
		if( isdefined(hitEnt) && IsAi(hitEnt) )
		{
			cursorColor = (1,0,0);

			if( isdefined(level.ai_puppet) && level.ai_puppet != hitEnt )
			{
				if( !level.ai_puppet_highlighting )
				{
					ai_puppeteer_render_ai( hitEnt, cursorColor );
				}
			}

			level.playerCursorAi = hitEnt;
		}
		else if( isdefined(level.ai_puppet) )
		{			
			nodes = GetAnyNodeArray( level.playerCursor["position"], 24 );
			if( nodes.size > 0 )
			{
				node = nodes[0];

				if( node.type != "Path" && DistanceSquared(node.origin, level.playerCursor["position"]) < 24*24 )
				{
					if( !level.ai_puppet_highlighting )
					{
						ai_puppeteer_render_node( node, (0,1,1) );
					}

					level.playerCursorNode = node;
				}
			}
		}
				
		// render the cross hair
		if( !level.ai_puppet_highlighting )
		{
			ai_puppeteer_render_point( level.playerCursor["position"], level.playerCursor["normal"], forward, cursorColor );
		}

		{wait(.05);};
	}
}

function ai_puppeteer_create_hud()
{
	/#
	level.puppeteer_hud_select = NewDebugHudElem();
	level.puppeteer_hud_select.x = 0;
	level.puppeteer_hud_select.y = 180;
	level.puppeteer_hud_select.fontscale = 1;
	level.puppeteer_hud_select.alignX = "left";
	level.puppeteer_hud_select.horzAlign = "left";
	level.puppeteer_hud_select.color = (0,0,1);

	level.puppeteer_hud_goto = NewDebugHudElem();
	level.puppeteer_hud_goto.x = 0;
	level.puppeteer_hud_goto.y = 200;
	level.puppeteer_hud_goto.fontscale = 1;
	level.puppeteer_hud_goto.alignX = "left";
	level.puppeteer_hud_goto.horzAlign = "left";
	level.puppeteer_hud_goto.color = (0,1,0);

	level.puppeteer_hud_lookat = NewDebugHudElem();
	level.puppeteer_hud_lookat.x = 0;
	level.puppeteer_hud_lookat.y = 220;
	level.puppeteer_hud_lookat.fontscale = 1;
	level.puppeteer_hud_lookat.alignX = "left";
	level.puppeteer_hud_lookat.horzAlign = "left";
	level.puppeteer_hud_lookat.color = (0,1,1);

	level.puppeteer_hud_shoot = NewDebugHudElem();
	level.puppeteer_hud_shoot.x = 0;
	level.puppeteer_hud_shoot.y = 240;
	level.puppeteer_hud_shoot.fontscale = 1;
	level.puppeteer_hud_shoot.alignX = "left";
	level.puppeteer_hud_shoot.horzAlign = "left";
	level.puppeteer_hud_shoot.color = (1,1,1);
	
	level.puppeteer_hud_teleport = NewDebugHudElem();
	level.puppeteer_hud_teleport.x = 0;
	level.puppeteer_hud_teleport.y = 260;
	level.puppeteer_hud_teleport.fontscale = 1;
	level.puppeteer_hud_teleport.alignX = "left";
	level.puppeteer_hud_teleport.horzAlign = "left";
	level.puppeteer_hud_teleport.color = (1,0,0);
		
	level.puppeteer_hud_select	SetText("X for select : DPAD+- modify goalradius");
	level.puppeteer_hud_goto	SetText("A for goto");
	level.puppeteer_hud_lookat	SetText("Y+B for goto forced : Y- ClearForcedGoal");
	level.puppeteer_hud_shoot	SetText("R-STICK for shoot");
	level.puppeteer_hud_teleport SetText("B to teleport");
	#/
}

function ai_puppeteer_destroy_hud()
{
	if( isdefined(level.puppeteer_hud_select) )
	{
		level.puppeteer_hud_select Destroy();
	}

	if( isdefined(level.puppeteer_hud_lookat) )
	{
		level.puppeteer_hud_lookat Destroy();
	}

	if( isdefined(level.puppeteer_hud_goto) )
	{
		level.puppeteer_hud_goto Destroy();
	}

	if( isdefined(level.puppeteer_hud_shoot) )
	{
		level.puppeteer_hud_shoot Destroy();
	}
}

function ai_puppeteer_render_point(point, normal, forward, color)
{
	surface_vector = VectorCross( forward, normal );
	surface_vector = VectorNormalize(surface_vector);

	line( point, point + VectorScale(surface_vector, 5), color, 1, true );
	line( point, point + VectorScale(surface_vector, -5), color, 1, true );

	surface_vector = VectorCross( normal, surface_vector );
	surface_vector = VectorNormalize(surface_vector);

	line( point, point + VectorScale(surface_vector, 5), color, 1, true );
	line( point, point + VectorScale(surface_vector, -5), color, 1, true );
}

function ai_puppeteer_render_node(node, color)
{
	print3d( node.origin, node.type, color, 1, 0.35 );
	box( node.origin, (-16,-16,0), (16,16,16), node.angles[1], color, 1, 1 );

	nodeForward = anglesToForward( node.angles );
	nodeForward = VectorScale( nodeForward, 8 );
	line( node.origin, node.origin + nodeForward, color, 1, 1 );
}

function ai_puppeteer_render_ai(ai, color)
{
	circle( ai.goalpos + (0,0,1), ai.goalradius, color, false, true );
	line( ai.goalpos, ai.origin, color, 1, true );
}

function ai_puppeteer_highlight_point(point, normal, forward, color)
{
	level endon("kill ai puppeteer");
	self endon("death");

	level.ai_puppet_highlighting = true;

	const maxTime		= 0.7;
	timer		= 0;
	const waitTime	= 0.15;
	
	while( timer < maxTime )
	{
		ai_puppeteer_render_point( point, normal, forward, color );

		timer += waitTime;
		wait( waitTime );
	}

	level.ai_puppet_highlighting = false;
}

function ai_puppeteer_highlight_node(node)
{
	level endon("kill ai puppeteer");
	self endon("death");

	level.ai_puppet_highlighting = true;

	const maxTime		= 0.7;
	timer		= 0;
	const waitTime	= 0.15;
	
	while( timer < maxTime )
	{
		ai_puppeteer_render_node( node, (0,1,0) );

		timer += waitTime;
		wait( waitTime );
	}

	level.ai_puppet_highlighting = false;
}

function ai_puppeteer_highlight_ai(ai, color)
{
	level endon("kill ai puppeteer");
	self endon("death");

	level.ai_puppet_highlighting = true;

	const maxTime		= 0.7;
	timer		= 0;
	const waitTime	= 0.15;
	
	while( timer < maxTime && isdefined(ai) )
	{
		ai_puppeteer_render_ai( ai, color );
				
		timer += waitTime;
		wait( waitTime );
	}

	level.ai_puppet_highlighting = false;
}

#/
