-- 
-- Kill Medal Events
--

--
-- Generic kill
--

genericKillMedalResponse = onGenericKill:Target(KillingPlayer):Response(
	{
		Medal = 'everything_else_kill',
	});
	
--
-- Grenade kill
--

grenadeKillMedalResponse = onGrenadeKill:Target(KillingPlayer):Response(
	{
		Medal = 'grenade_kill',
	});

--
-- Incineration Kill
--

incinerationKillMedalResponse = onIncinerationKill:Target(KillingPlayer):Response(
	{
		Medal = 'incineration_kill',		
	});
	
--
-- Rocket launcher kill
--

rocketKillMedalResponse = onRocketLaucherKill:Target(KillingPlayer):Response(
	{
		Medal = 'rocket_kill',		
	});

--
-- Scattershot kill
--

scattershotKillMedalResponse = onScattershotKill:Target(KillingPlayer):Response(
	{
		Medal = 'scattershot_kill',			
	});
	
--
-- Shotgun kill
--

shotgunKillMedalResponse = onShotgunKill:Target(KillingPlayer):Response(
	{
		Medal = 'shotgunkill',			
	});
	
--
-- Sniper Rifle Kill
--

sniperKillMedalResponse = onSniperKill:Target(KillingPlayer):Response(
	{
		Medal = 'sniper_kill',		
	});
	
--
-- Beam Rifle Kill
--

beamRifleKillMedalResponse = onBeamRifleKill:Target(KillingPlayer):Response(
	{
		Medal = 'beam_rifle_kill',		
	});
	
--
-- Binary Rifle Kill
--

binaryRifleKillMedalResponse = onBinaryRifleKill:Target(KillingPlayer):Response(
	{
		Medal = 'binary_rifle_kill',		
	});
	
--
-- Sword kill
--

swordKillMedalResponse = onSwordKill:Target(KillingPlayer):Response(
	{
		Medal = 'sword_kill',	
	});

--
-- Hydra Kill
--

hydraKillMedalResponse = onHydraKill:Target(KillingPlayer):Response(
	{
		Medal = 'hydra_kill',	
	});
	
--
-- Splaser Kill
--

splaserKillMedalResponse = onSplaserKill:Target(KillingPlayer):Response(
	{
		Medal = 'splaser_kill',	
	});
	
--
-- Needler Kill
--

needlerKillMedalResponse = onNeedlerKill:Target(KillingPlayer):Response(
	{
		Medal = 'supercombine_kill',	
	});
	
--
-- SAW Kill
--

sawKillMedalResponse = onSawKill:Target(KillingPlayer):Response(
	{
		Medal = 'saw_kill',	
	});
	
--
-- Railgun Kill
--

railgunMedalResponse = onRailgunKill:Target(KillingPlayer):Response(
	{
		Medal = 'railgun_kill',	
	});
	
--
-- Plasma Caster Kill
--

plasmaCasterMedalResponse = onPlasmaCasterKill:Target(KillingPlayer):Response(
	{
		Medal = 'plasma_caster_kill',	
	});
	
--
-- Assist Medals
--
	
nonGroundPoundPoundTownAssistResponse = onPoundTownAssist:Target(FindNonPoundTownAssistPlayers):Response(
	{
		Medal = 'assist'
	});

nonPlasmaEmpAssistResponse = onEmpAssist:Target(FindNonEmpAssistPlayers):Response(
	{
		Medal = 'assist'
	});

assistResponse = onGenericAssist:Target(AssistingPlayers):Response(
	{
		Medal = 'assist'
	});