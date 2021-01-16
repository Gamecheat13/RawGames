
__OnFamineSkullActive = Delegate:new();
onFamineSkullActive = root:AddCallback(
	__OnFamineSkullActive
	);
pveFamineSkullActiveResponse = onFamineSkullActive:Target(TargetAllPlayers):Response(
	{
		Sound = 'multiplayer\audio\wzcmndrsustain\dontplayanything',
		Fanfare = FanfareDefinitions.KillFeed,
		FanfareText = 'warzone_pve_famine_active',
	});
__OnThunderstormSkullActive = Delegate:new();
onThunderstormSkullActive = root:AddCallback(
	__OnThunderstormSkullActive
	);
pveThunderstormSkullActiveResponse = onThunderstormSkullActive:Target(TargetAllPlayers):Response(
	{
		Sound = 'multiplayer\audio\wzcmndrsustain\dontplayanything',
		Fanfare = FanfareDefinitions.KillFeed,
		FanfareText = 'warzone_pve_thunderstorm_active',
	});
__OnMythicSkullActive = Delegate:new();
onMythicSkullActive = root:AddCallback(
	__OnMythicSkullActive
	);
pveMythicSkullActiveResponse = onMythicSkullActive:Target(TargetAllPlayers):Response(
	{
		Sound = 'multiplayer\audio\wzcmndrsustain\dontplayanything',
		Fanfare = FanfareDefinitions.KillFeed,
		FanfareText = 'warzone_pve_mythic_active',
	});
__OnIronSkullActive = Delegate:new();
onIronSkullActive = root:AddCallback(
	__OnIronSkullActive
	);
pveIronSkullActiveResponse = onIronSkullActive:Target(TargetAllPlayers):Response(
	{
		Sound = 'multiplayer\audio\wzcmndrsustain\dontplayanything',
		Fanfare = FanfareDefinitions.KillFeed,
		FanfareText = 'warzone_pve_iron_active',
	});
__OnToughLuckSkullActive = Delegate:new();
onToughLuckSkullActive = root:AddCallback(
	__OnToughLuckSkullActive
	);
pveToughLuckSkullActiveResponse = onToughLuckSkullActive:Target(TargetAllPlayers):Response(
	{
		Sound = 'multiplayer\audio\wzcmndrsustain\dontplayanything',
		Fanfare = FanfareDefinitions.KillFeed,
		FanfareText = 'warzone_pve_tough_luck_active',
	});
__OnCatchSkullActive = Delegate:new();
onCatchSkullActive = root:AddCallback(
	__OnCatchSkullActive
	);
pveCatchSkullActiveResponse = onCatchSkullActive:Target(TargetAllPlayers):Response(
	{
		Sound = 'multiplayer\audio\wzcmndrsustain\dontplayanything',
		Fanfare = FanfareDefinitions.KillFeed,
		FanfareText = 'warzone_pve_catch_active',
	});
__OnBlackEyeSkullActive = Delegate:new();
onBlackEyeSkullActive = root:AddCallback(
	__OnBlackEyeSkullActive
	);
pveBlackEyeSkullActiveResponse = onBlackEyeSkullActive:Target(TargetAllPlayers):Response(
	{
		Sound = 'multiplayer\audio\wzcmndrsustain\dontplayanything',
		Fanfare = FanfareDefinitions.KillFeed,
		FanfareText = 'warzone_pve_black_eye_active',
	});
__OnFogSkullActive = Delegate:new();
onFogSkullActive = root:AddCallback(
	__OnFogSkullActive
	);
pveFogSkullActiveResponse = onFogSkullActive:Target(TargetAllPlayers):Response(
	{
		Sound = 'multiplayer\audio\wzcmndrsustain\dontplayanything',
		Fanfare = FanfareDefinitions.KillFeed,
		FanfareText = 'warzone_pve_fog_active',
	});
__OnTiltSkullActive = Delegate:new();
onTiltSkullActive = root:AddCallback(
	__OnTiltSkullActive
	);
pveTiltSkullActiveResponse = onTiltSkullActive:Target(TargetAllPlayers):Response(
	{
		Sound = 'multiplayer\audio\wzcmndrsustain\dontplayanything',
		Fanfare = FanfareDefinitions.KillFeed,
		FanfareText = 'warzone_pve_tilt_active',
	});
__OnIWHBYDSkullActive = Delegate:new();
onIWHBYDSkullActive = root:AddCallback(
	__OnIWHBYDSkullActive
	);
pveIWHBYDSkullActiveResponse = onIWHBYDSkullActive:Target(TargetAllPlayers):Response(
	{
		Sound = 'multiplayer\audio\wzcmndrsustain\dontplayanything',
		Fanfare = FanfareDefinitions.KillFeed,
		FanfareText = 'warzone_pve_IWHBYD_active',
	});
__OnGruntBirthdayPartySkullActive = Delegate:new();
onGruntBirthdayPartySkullActive = root:AddCallback(
	__OnGruntBirthdayPartySkullActive
	);
pveGruntBirthdayPartySkullActiveResponse = onGruntBirthdayPartySkullActive:Target(TargetAllPlayers):Response(
	{
		Sound = 'multiplayer\audio\wzcmndrsustain\dontplayanything',
		Fanfare = FanfareDefinitions.KillFeed,
		FanfareText = 'warzone_pve_grunt_birthday_party_active',
	});
__OnSupermanSkullActive = Delegate:new();
onSupermanSkullActive = root:AddCallback(
	__OnSupermanSkullActive
	);
pveSupermanSkullActiveResponse = onSupermanSkullActive:Target(TargetAllPlayers):Response(
	{
		Sound = 'multiplayer\audio\wzcmndrsustain\dontplayanything',
		Fanfare = FanfareDefinitions.KillFeed,
		FanfareText = 'warzone_pve_superman_active',
	});
__OnSkullsCleared = Delegate:new();
onSkullsCleared = root:AddCallback(
	__OnSkullsCleared
	);
pveOnSkullsClearedResponse = onSkullsCleared:Target(TargetAllPlayers):Response(
	{
		Sound = 'multiplayer\audio\wzcmndrsustain\dontplayanything',
		Fanfare = FanfareDefinitions.KillFeed,
		FanfareText = 'warzone_pve_skulls_cleared',
	});