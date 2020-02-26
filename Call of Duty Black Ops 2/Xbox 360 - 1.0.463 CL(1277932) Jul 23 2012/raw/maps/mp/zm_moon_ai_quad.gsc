#include common_scripts\utility;
#include maps\mp\_utility;
#include maps\mp\zombies\_zm_utility;
#include maps\mp\animscripts\zm_utility;


//-----------------------------------------------------------------------
// setup level funcs
//-----------------------------------------------------------------------
init()
{
	level.quad_prespawn = ::moon_quad_prespawn;

	level.quad_gas_immune_func = ::moon_quad_gas_immune;
}


//-----------------------------------------------------------------------
// setup moon quads
//-----------------------------------------------------------------------
moon_quad_prespawn()
{
	self.no_gib = true;

	self.zombie_can_sidestep = true;
	self.zombie_can_forwardstep = true;

/*t6todo	self.sideStepAnims["step_left"]	= array( %ai_zombie_quad_phaseleft_long_a, %ai_zombie_quad_phaseleft_long_b, %ai_zombie_quad_phaseleft_short_a, %ai_zombie_quad_phaseleft_short_b );
	self.sideStepAnims["step_right"]	= array( %ai_zombie_quad_phaseright_long_a, %ai_zombie_quad_phaseright_long_b, %ai_zombie_quad_phaseright_short_a, %ai_zombie_quad_phaseright_short_b );

	self.sideStepAnims["roll_forward"]	= array( %ai_zombie_quad_phaseforward_long_a, %ai_zombie_quad_phaseforward_long_b, %ai_zombie_quad_phaseforward_short_a, %ai_zombie_quad_phaseforward_short_b );

	self.sideStepAnims["phase_forward"]	= array( %ai_zombie_quad_phaseforward_long_a, %ai_zombie_quad_phaseforward_long_b );
*/
	self.sideStepFunc = ::moon_quad_sidestep;
	self.fastSprintFunc = ::moon_quad_fastSprint;
}

//-----------------------------------------------------------------------
// quad sidestep callback
//-----------------------------------------------------------------------
moon_quad_sidestep( animname, stepAnim )
{
	self endon( "death" );
	self endon( "stop_sidestep" );

	self thread moon_quad_wait_phase_end( stepAnim );
	self thread moon_quad_exit_align( stepAnim );

	while ( 1 )
	{
		self waittill( animname, note );
		if ( note == "phase_start" )
		{
			self thread moon_quad_phase_fx();
			self playsound( "zmb_quad_phase_out" );
			self hide();
		}
		else if ( note == "phase_end" )
		{
			self notify( "stop_wait_phase_end" );
			self thread moon_quad_phase_fx();
			self show();
			self playsound( "zmb_quad_phase_in" );
			break;
		}
	}
}

//-----------------------------------------------------------------------
// returns the fast sprint anim key
//-----------------------------------------------------------------------
moon_quad_fastSprint()
{
	if ( is_true( self.in_low_gravity ) )
	{
		return "low_g_super_sprint";
	}

	return "super_sprint";
}

//-----------------------------------------------------------------------
// setup coast director
//-----------------------------------------------------------------------
moon_quad_wait_phase_end( stepAnim )
{
	self endon( "death" );
	self endon( "stop_wait_phase_end" );

	anim_length = GetAnimLength( stepAnim );
	wait( anim_length );

	self thread moon_quad_phase_fx();
	self show();
	self notify( "stop_sidestep" );
}

moon_quad_exit_align( stepAnim )
{
	self endon( "death" );

	anim_length = GetAnimLength( stepAnim );
	wait( anim_length );

	if ( !is_true( self.exit_align ) )
	{
		self notify( "stepAnim", "exit_align" );
	}
}

//-----------------------------------------------------------------------
// quad phasing fx
//-----------------------------------------------------------------------
moon_quad_phase_fx()
{
	self endon( "death" );

	PlayFxOnTag( level._effect["quad_phasing"], self, "j_head" );
	//PlayFxOnTag( level._effect["quad_phasing"], self, "j_spine_upper" );
	PlayFxOnTag( level._effect["quad_phasing"], self, "j_mainroot" );
}

//-----------------------------------------------------------------------
// don't affect players wearing gasmask
//-----------------------------------------------------------------------
moon_quad_gas_immune()
{
	self endon( "disconnect" );
	self endon( "death" );

	return self maps\mp\zombies\_zm_equip_gasmask::gasmask_active();
}