#include common_scripts\utility;
#include maps\_utility;
#include maps\_anim;
#include maps\_shg_common;
#include animscripts\shared;
#include animscripts\track;
#include animscripts\utility;

#using_animtree( "generic_human" );
CONST_MPHCONVERSION = 17.6;

main()
{
	assert( isdefined( self.blackshadow ) );

	self.current_event = "none";
    self.shoot_while_driving_thread = undefined;

    self blackshadow_geton();

	main_driver();
}

blackshadow_geton()
{
	self.grenadeawareness = 0;
//	self.a.pose = "crouch";
    self disable_surprise();
	self.allowpain = false;

    self.getOffVehicleFunc = ::blackshadow_getoff;
//	self.specialDeathFunc = ::blackshadow_normal_death;
    self.disableBulletWhizbyReaction = true;

//	self linktoblendtotag(self.blackshadow, "tag_player", false);
}

blackshadow_getoff()
{
	self.allowpain = true;

	self.getOffVehicleFunc = undefined;
	self.specialDeathFunc = undefined;
	self.a.specialShootBehavior = undefined;
	self.disableBulletWhizbyReaction = undefined;
}



main_driver()
{
	blackshadow_setanim(  );
	self thread blackshadow_loop_driver();
}

blackshadow_loop_driver()
{
	self endon( "death" );
	self endon( "killanimscript" );

	blackshadow = self.blackshadow;
	
	pitch_angle_scale = 8.0;
	yaw_roll_scale = 8.0;
	fwd_speed_scale = 1/6.0;	// 8 mph ~ 150 inches/sec
	rate = RandomFloatRange( 0.8, 1.2 );
	self SetAnim(animarray( "idle" ), 1.0, 0.5, rate );
	self SetAnim(animarray( "fwd" ), 0.0, 0.5, rate );
	self SetAnim(animarray( "left" ), 0.0, 0.5, rate );
	self SetAnim(animarray( "right" ), 0.0, 0.5, rate );
	self SetAnim(animarray( "up" ), 0.0, 0.5, rate );
	self SetAnim(animarray( "down" ), 0.0, 0.5, rate );
	prvangles = blackshadow GetTagAngles( "tag_npc_origin" );
	ratetimeout = 1.0;
	altblend = RandomFloatRange(0.0, 1.0);
	altblendtarget = altblend;
	altblendtimeout = 1.5 + 0.05*randomintrange( 0, 20 );
	self.blackshadow_driving = true;
	
	while (true)
	{
		speed = blackshadow.veh_speed;
		fwdmix = speed * fwd_speed_scale;	// 8 mph ~ 150 inches/sec
		if (fwdmix > 1.0)
			fwdmix = 1.0;
		stopmix = 1 - fwdmix;
		angles = blackshadow GetTagAngles( "tag_npc_origin" );
		forward = AnglesToForward( angles );
		right = AnglesToRight( angles );
		up = AnglesToUp( angles );
		prvforward = AnglesToForward( prvangles );
		tmpup = VectorCross(right,prvforward);
		forw_in_xzplane = VectorNormalize(VectorCross(tmpup, right));
		sin_dpitch = VectorDot( forw_in_xzplane, up );
		prvright = AnglesToRight( prvangles );
		tmpforward = VectorCross(up,prvright);
		right_in_yzplane = VectorNormalize(VectorCross(tmpforward, up));
		sin_droll = VectorDot( right_in_yzplane, up );
		
		dangles = angles - prvangles;
		prvangles = angles;
		lmix = 0;
		rmix = 0;
		umix = 0;
		dmix = 0;
		mix = 0;
		if (sin_droll > 0)
		{
			lmix = yaw_roll_scale * sin_droll;
			if (lmix > 1)
				lmix = 1;
		}
		if (sin_droll < 0)
		{
			rmix = -1.0 * yaw_roll_scale * sin_droll;
			if (rmix > 1)
				rmix = 1;
		}
		if (sin_dpitch < 0)
		{
			umix = -1 * pitch_angle_scale * sin_dpitch;
			if (umix > 1)
				umix = 1;
		}
		if (sin_dpitch > 0)
		{
			dmix = pitch_angle_scale * sin_dpitch;
			if (dmix > 1)
				dmix = 1;
		}
		total = lmix + rmix + umix + dmix;
		if (total > 0)
		{
			total += stopmix;
			fwdmix = 1 - total;
			if (fwdmix < 0)
				fwdmix = 0;
				
			mix = (1.0-fwdmix)/total;
			stopmix *= mix;
			lmix *= mix;
			rmix *= mix;
			umix *= mix;
			dmix *= mix;
		}
		ratetimeout -= 0.05;
		if (ratetimeout <= 0)
		{
			ratetimeout = 1.0 + 0.05*RandomIntRange(-4, 4);
			rate = RandomFloatRange( 0.8, 1.2 );
			/*
			rate += RandomFloatRange( -0.2, 0.2 );
			if (rate < 0.8)
				rate = 0.8;
			if (rate > 1.2)
				rate = 1.2;
			*/
		}
		delta = 0.05*(altblendtarget - altblend)/altblendtimeout;
		altblend += delta;
		if (altblend > 1.0)
			altblend = 1.0;
		if (altblend < 0.0)
			altblend = 0.0;
		altblendtimeout -= 0.05;
		if (altblendtimeout <= 0)
		{
			altblendtarget = RandomFloatRange(0.0, 1.0);
			altblendtimeout = 1.5 + 0.05*randomintrange( 0, 20 );
		}
		omaltblend = 1 - altblend;
		
		if (self.blackshadow_driving)
		{
			self SetAnim(animarray( "idle" ), stopmix, 0.5, rate );
			self SetAnim(animarray( "fwd" ), fwdmix*omaltblend, 0.5, rate );
			self SetAnim(animarray( "left" ), lmix*omaltblend, 0.5, rate );
			self SetAnim(animarray( "right" ), rmix*omaltblend, 0.5, rate );
			self SetAnim(animarray( "fwdb" ), fwdmix*altblend, 0.5, rate );
			self SetAnim(animarray( "leftb" ), lmix*altblend, 0.5, rate );
			self SetAnim(animarray( "rightb" ), rmix*altblend, 0.5, rate );
			self SetAnim(animarray( "up" ), umix, 0.5, rate );
			self SetAnim(animarray( "down" ), dmix, 0.5, rate );
		}
		else
		{
			self SetAnim(animarray( "idle" ), 0.0, 0.2, 1.0 );
			self SetAnim(animarray( "fwd" ), 0.0, 0.2, 1.0 );
			self SetAnim(animarray( "left" ), 0.0, 0.2, 1.0 );
			self SetAnim(animarray( "right" ), 0.0, 0.2, 1.0 );
			self SetAnim(animarray( "fwdb" ), 0.0, 0.2, 1.0 );
			self SetAnim(animarray( "leftb" ), 0.0, 0.2, 1.0 );
			self SetAnim(animarray( "rightb" ), 0.0, 0.2, 1.0 );
			self SetAnim(animarray( "up" ), 0.0, 0.2, 1.0 );
			self SetAnim(animarray( "down" ), 0.0, 0.2, 1.0 );
		}
		wait 0.05;
	}
	
}


blackshadow_setanim(  )
{
	self.a.array = [];
	
	self.a.array[ "idle" ] = level.scr_anim[ "generic" ][ "wetsub_idle" ];
	self.a.array[ "fwd" ] = level.scr_anim[ "generic" ][ "wetsub_fwd" ];
	self.a.array[ "right" ] = level.scr_anim[ "generic" ][ "wetsub_rt" ];
	self.a.array[ "left" ] = level.scr_anim[ "generic" ][ "wetsub_lt" ];
	self.a.array[ "up" ] = level.scr_anim[ "generic" ][ "wetsub_up" ];
	self.a.array[ "down" ] = level.scr_anim[ "generic" ][ "wetsub_dn" ];
	self.a.array[ "fwdb" ] = level.scr_anim[ "generic" ][ "wetsub_fwd_alt" ];
	self.a.array[ "rightb" ] = level.scr_anim[ "generic" ][ "wetsub_rt_alt" ];
	self.a.array[ "leftb" ] = level.scr_anim[ "generic" ][ "wetsub_lt_alt" ];
}

