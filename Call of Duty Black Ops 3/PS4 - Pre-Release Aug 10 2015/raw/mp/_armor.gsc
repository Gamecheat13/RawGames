#using scripts\codescripts\struct;

#using scripts\shared\callbacks_shared;
#using scripts\shared\clientfield_shared;
#using scripts\shared\math_shared;
#using scripts\shared\system_shared;
#using scripts\shared\util_shared;

#precache( "lui_menu_data", "hudItems.armorPercent" );

#namespace armor;

function setLightArmorHP( newValue )
{
	if ( IsDefined( newValue ) )
	{
		self.lightArmorHP = newValue;
		if( IsPlayer( self ) && IsDefined( self.maxLightArmorHP ) && self.maxLightArmorHP > 0 )
		{
			lightArmorPercent = math::clamp( self.lightArmorHP / self.maxLightArmorHP, 0, 1 );
			self SetControllerUIModelValue( "hudItems.armorPercent", lightArmorPercent );
		}
	}
	else
	{
		self.lightArmorHP = undefined;
		self.maxLightArmorHP = undefined;
			self SetControllerUIModelValue( "hudItems.armorPercent", 0 );
	}
}

/////////////////////////////////////////////////////////////////
// ARMOR: give a health boost
function setLightArmor( optionalArmorValue )
{
	self notify( "give_light_armor" );

	if( IsDefined( self.lightArmorHP ) )
		unsetLightArmor();

	self thread removeLightArmorOnDeath();	
	self thread removeLightArmorOnMatchEnd();

	if( IsDefined( optionalArmorValue ) )
		self.maxLightArmorHP = optionalArmorValue;
	else
		self.maxLightArmorHP = 150;
	
	self setLightArmorHP( self.maxLightArmorHP );
}

function removeLightArmorOnDeath()
{
	self endon ( "disconnect" );
	self endon( "give_light_armor" );
	self endon( "remove_light_armor" );

	self waittill ( "death" );
	unsetLightArmor();		
}

function unsetLightArmor()
{
	self setLightArmorHP( undefined );

	self notify( "remove_light_armor" );
}

function removeLightArmorOnMatchEnd()
{
	self endon ( "disconnect" );
	self endon ( "remove_light_armor" );

	level waittill( "game_ended" );

	self thread unsetLightArmor();
}

function hasLightArmor()
{
	return ( IsDefined( self.lightArmorHP ) && self.lightArmorHP > 0 );
}

function getArmor()
{
	if( IsDefined( self.lightArmorHP ) )
	{
		return self.lightArmorHP;
	}
	return 0;
}
