#include common_scripts\utility;
#include maps\_utility;
#include maps\_vehicle;
#include maps\_so_code;
#include maps\_specialops;
#include maps\_hud_util;

#define ALLY_SWITCH_BUTTON "DPAD_RIGHT"
#define TEAM_ICON_SIZE 		28
#define TEAM_ICON_SIZE_LG	36
#define TEAM_X_START		-320
#define TEAM_Y_START		186

// ==========================================================================
// Manages the player switching between the available allies
// ==========================================================================

ally_init_hudElem(iconMat)
{
	if (!isDefined(level.highlight_icon) )
	{
		level.highlight_icon = self maps\_so_war_support::special_item_hudelem( TEAM_X_START, TEAM_Y_START,true );
		level.highlight_icon.sort = 9;
		level.highlight_icon setShader( "hud_specops_ui_deltasupport", TEAM_ICON_SIZE_LG, TEAM_ICON_SIZE_LG );
		level.highlight_icon.alpha = 0.7;
	}

	if(!isDefined(level.teamXstart) )
	{
		level.teamXstart = TEAM_X_START;
	}
	else
	{
		level.teamXstart += TEAM_ICON_SIZE + 6;
	}

	icon = self maps\_so_war_support::special_item_hudelem( level.teamXstart , TEAM_Y_START,true );
	icon setShader( iconMat, TEAM_ICON_SIZE, TEAM_ICON_SIZE );
	icon.color 		= (1,1,1);
	icon.sort  		= 10;
	icon.mat   		= iconMat;
	icon.iconsize 	= TEAM_ICON_SIZE;
/*	
	icon.jitterIcon = self maps\_so_war_support::special_item_hudelem( level.teamXstart , TEAM_Y_START,true );
	icon.jitterIcon.alpha =	0;
	icon.jitterIcon.sort = 10;
*/	
	return icon;
}

ally_hud_class_died(class)
{
	class.hudElm.color = (0.5,0.5,0.5);
	class.hudElm setShader( class.icon, TEAM_ICON_SIZE, TEAM_ICON_SIZE);
}

ally_hud_highlight()
{
	while(1)
	{
		level waittill("ally_selection_update",ally);


		foreach(class in level.player_classes)
		{
			class.hudElm setShader( class.icon, TEAM_ICON_SIZE, TEAM_ICON_SIZE );
			class.hudElm.color = (1,1,1);
			
			if ( is_true(class.player) )
			{
				class.hudElm setShader( class.icon, TEAM_ICON_SIZE_LG, TEAM_ICON_SIZE_LG );
				class.hudElm.color = (.7,.7,1);
				if (!isDefined(ally))
				{
					level.highlight_icon.x = class.hudElm.x;
				}
			}
			else			
			if ( isDefined(ally) && isDefined(class.ai) && class.ai == ally )
			{
				level.highlight_icon.x = class.hudElm.x;
			}
		}
	}
}

ally_hud_getNumAlive()
{
	alive = 0;
	
	foreach(class in level.player_classes)
	{
		if( IsDefined( class.ai ) && IsAlive( class.ai ) )
		{
			alive++;
		}
	}
	return alive;
}

ally_switch_think()
{
	self endon( "death" );
	self thread ally_switch_input();
	self thread ally_hud_highlight();
	
	turn_off_ally_cam(self);
	
	activeSelect = false;
	flag_wait("war_switch_avail");
	while( 1 )
	{		
	
		classPossibles = [];
		for(i=0;i<level.player_classes.size;i++)
		{
			class = level.player_classes[i];
			if ( is_true(class.player) )
				continue;
			if( IsAlive(class.ai) )
			{
				classPossibles[classPossibles.size] = class;
				class.ai thread ally_switch_on_death( self );
			}
		}
		
		if (classPossibles.size == 0 )
		{//all done potentially
			wait 0.05;
		}
		
		for(i=0;i<classPossibles.size;i++)
		{
			button = self waittill_any_return( "ally_death", "button_up", "button_select", "button_exit", "war_char_switch" );
			if ( button == "ally_death" || button == "war_char_switch" )
			{
				if ( button == "war_char_switch")
				{
					level waittill("war_char_switch_complete");
				}
				
				level.activeClassSelected = undefined;
				level notify("ally_selection_update");
				break;
			}
			
			if (button == "button_up")
			{
				class = classPossibles[i];
				level.activeClassSelected = class;
				level notify("ally_selection_update",level.activeClassSelected.ai);
				maps\_so_war_support::turn_on_ally_cam( level.activeClassSelected.ai, self );
				
				// so that pressing A or B doesn't change it during ally switching mode
				self player_lock_stance();
			}
			else
			{
				i--;
			}

			if( isDefined(level.activeClassSelected) && button == "button_select" )
			{
				if( IsAlive( level.activeClassSelected.ai ) )
				{						
					self thread maps\_so_war_support::do_ally_switch( level.activeClassSelected.ai, true );
					self player_unlock_stance();
					level.activeClassSelected = undefined;
				}
				break;
			}
			
			if( button == "button_exit" )
			{
				maps\_so_war_support::turn_off_ally_cam(self);
				self player_unlock_stance();
				level notify("ally_selection_update");
				level.activeClassSelected = undefined;
				break;
			}
		}
	}
}

player_lock_stance()
{
	switch( self GetStance() )
	{
		case "stand":
			self AllowCrouch( false );
			self AllowProne( false );
			break;
			
		case "crouch":
			self AllowStand( false );
			self AllowProne( false );
			break;
			
		case "prone":
			self AllowStand( false );
			self AllowCrouch( false );
			break;
			
		default:
			AssertMsg( "Unknown player stance: " + self GetStance() );
	}
}

player_unlock_stance()
{
	self AllowStand( true );
	self AllowCrouch( true );
	self AllowProne( true );
}

ally_switch_input()
{
	self endon("death");
	self endon("switch_input_done");
	
	// so it doesn't send a notify right away
	wait( 0.05 );
	
	// let player choose
	down = 0;
	while( 1 )
	{
		if( self ButtonPressed(ALLY_SWITCH_BUTTON) )
		{
			if ( down == 0 )
			{
				down = GetTime();
			}
			if ( GetTime()-down > 1000 )
			{
				self notify( "button_up" );

				down = 0;
			}
		}
		else if( down>0 )
		{
			self notify( "button_up" );
			down = 0;
		}
		else if( self ButtonPressed("BUTTON_A") )
		{
			self notify( "button_select" );
		}
		else if( self ButtonPressed("BUTTON_B") )
		{
			self notify( "button_exit" );
		}
		
		wait( 0.05 );
	}
}

ally_switch_on_death( player )
{
	self notify("ally_switch_on_death");
	self endon("ally_switch_on_death");
	
	self waittill("death");
	
	player notify( "ally_death" );
}

