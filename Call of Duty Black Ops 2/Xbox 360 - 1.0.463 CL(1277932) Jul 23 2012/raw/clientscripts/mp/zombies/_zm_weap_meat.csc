#include clientscripts\mp\_utility;
#include clientscripts\mp\zombies\_zm_weapons;
#include clientscripts\mp\zombies\_zm_utility;

meat_fx()
{
	localclientnum = self GetLocalClientNumber();
	self endon( "disconnect" );
	
	for( ;; )
	{
		waitrealtime( .1 );
		
		currentweapon = GetCurrentWeapon( localclientnum ); 
		if ( currentweapon != "item_meat_zm" )
		{
			if(isDefined(self._meat_fly_fx))
			{
				deletefx(localclientnum,self._meat_fly_fx);
				self._meat_fly_fx = undefined;
			}
			self._playing_fly_fx = false;
			continue;
		}
		if(isDefined(self._meat_fly_fx))
		{
			continue;
		}
		if ( IsThrowingGrenade( localclientnum ) || IsMeleeing( localclientnum )  || IsOnTurret( localclientnum ) )
		{
			continue;
		}
		
		ammo = GetWeaponAmmoClip( localclientnum, currentweapon );

		fx = level._effect["meat_glow3p"];	
		self._meat_fly_fx = PlayFXOnTag( localclientnum, fx, self ,"TAG_FX" );
	}
}