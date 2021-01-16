-- 
genericKillMedalResponse = onGenericKill:Target(KillingPlayer):Response(
	{
		Medal = 'everything_else_kill',
	});
grenadeKillMedalResponse = onGrenadeKill:Target(KillingPlayer):Response(
	{
		Medal = 'grenade_kill',
	});
incinerationKillMedalResponse = onIncinerationKill:Target(KillingPlayer):Response(
	{
		Medal = 'incineration_kill',		
	});
hunterArmKillMedalResponse = onHunterArmKill:Target(KillingPlayer):Response(
	{
		Medal = 'hunter_arm_kill',		
	});
rocketKillMedalResponse = onRocketLaucherKill:Target(KillingPlayer):Response(
	{
		Medal = 'rocket_kill',		
	});
scattershotKillMedalResponse = onScattershotKill:Target(KillingPlayer):Response(
	{
		Medal = 'scattershot_kill',			
	});
shotgunKillMedalResponse = onShotgunKill:Target(KillingPlayer):Response(
	{
		Medal = 'shotgunkill',			
	});
sniperKillMedalResponse = onSniperKill:Target(KillingPlayer):Response(
	{
		Medal = 'sniper_kill',		
	});
beamRifleKillMedalResponse = onBeamRifleKill:Target(KillingPlayer):Response(
	{
		Medal = 'beam_rifle_kill',		
	});
binaryRifleKillMedalResponse = onBinaryRifleKill:Target(KillingPlayer):Response(
	{
		Medal = 'binary_rifle_kill',		
	});
swordKillMedalResponse = onSwordKill:Target(KillingPlayer):Response(
	{
		Medal = 'sword_kill',	
	});
hammerKillMedalResponse = onHammerKill:Target(KillingPlayer):Response(
	{
		Medal = 'hammer_kill',
	});
hydraKillMedalResponse = onHydraKill:Target(KillingPlayer):Response(
	{
		Medal = 'hydra_kill',	
	});
splaserKillMedalResponse = onSplaserKill:Target(KillingPlayer):Response(
	{
		Medal = 'splaser_kill',	
	});
needlerKillMedalResponse = onNeedlerKill:Target(KillingPlayer):Response(
	{
		Medal = 'supercombine_kill',	
	});
sawKillMedalResponse = onSawKill:Target(KillingPlayer):Response(
	{
		Medal = 'saw_kill',	
	});
reachGrenadeLauncherKillMedalResponse = onReachGrenadeLauncherKill:Target(KillingPlayer):Response(
	{
		Medal = 'grenade_launcher_kill',	
	});
sentinelBeamKillMedalResponse = onSentinelBeamKill:Target(KillingPlayer):Response(
	{
		Medal = 'sentinel_beam_kill',	
	});
railgunMedalResponse = onRailgunKill:Target(KillingPlayer):Response(
	{
		Medal = 'railgun_kill',	
	});
plasmaCasterMedalResponse = onPlasmaCasterKill:Target(KillingPlayer):Response(
	{
		Medal = 'plasma_caster_kill',	
	});
nonGroundPoundPoundTownAssistResponse = onPoundTownAssist:Target(FindNonPoundTownAssistPlayers):Response(
	{
		Medal = 'assist'
	});
nonPlasmaEmpAssistResponse = onEmpAssist:Target(FindNonEmpAssistPlayers):Response(
	{
		Medal = 'assist'
	});
nonWheelmanAssistResponse = onWheelmanAssist:Target(NonWheelmanAssistPlayers):Response(
	{
		Medal = 'assist'
	});
assistResponse = onGenericAssist:Target(AssistingPlayers):Response(
	{
		Medal = 'assist'
	});