--
-- Saved map variant confirmation
--

__OnForgeMapVariantSaved = Delegate:new();

onForgeMapVariantSaved = root:AddCallback(
	__OnForgeMapVariantSaved,
	function(context, targetPlayer)
		context.TargetPlayer = targetPlayer;
	end
	);

mapVariantSavedPlayerResponse = onForgeMapVariantSaved:Target(TargetPlayer):Response(
	{
		Fanfare = FanfareDefinitions.KillFeed,
		FanfareText = function (context)
			return FormatText('forge_saved_map_variant_self', context.TargetPlayer);
		end,
	});

mapVariantSavedOtherPlayersResponse = onForgeMapVariantSaved:Target(AllButTargetPlayer):Response(
	{
		Fanfare = FanfareDefinitions.KillFeed,
		FanfareText = function (context)
			return FormatText('forge_saved_map_variant_others', context.TargetPlayer);
		end,
	});

--
-- Server Shutdown
--
	
forgeServerShutdownWarningResponse = onServerShutdown:Target(TargetAllPlayers):Response(
	{
		Fanfare = FanfareDefinitions.KillFeed,
		FanfareText = 'server_shutdown_warning_forge',
	});

--
-- Failed to place Forge object - object budget exceeded
--

__OnForgeObjectFailToPlaceBudget = Delegate:new();

onForgeObjectFailToPlaceBudget = root:AddCallback(
	__OnForgeObjectFailToPlaceBudget,
	function(context, targetPlayer)
		context.TargetPlayer = targetPlayer;
	end
	);
	
failureToPlaceForgeObjectBudgetResponse = onForgeObjectFailToPlaceBudget:Target(TargetPlayer):Response(
	{
		Fanfare = FanfareDefinitions.KillFeed,
		FanfareText = 'forge_failure_to_place_object_budget',
	});

--
-- Failed to place Forge object - no physical space for object
--

__OnForgeObjectFailToPlaceNoSpace = Delegate:new();

onForgeObjectFailToPlaceNoSpace = root:AddCallback(
	__OnForgeObjectFailToPlaceNoSpace,
	function(context, targetPlayer)
		context.TargetPlayer = targetPlayer;
	end
	);

failureToPlaceForgeObjectPhysicalSpaceResponse = onForgeObjectFailToPlaceNoSpace:Target(TargetPlayer):Response(
	{
		Fanfare = FanfareDefinitions.KillFeed,
		FanfareText = 'forge_failure_to_place_object_no_space',
	});

--
-- Failed to add object script - no scripts available
--

__OnForgeFailureToAddObjectScriptNoScripts = Delegate:new();

onForgeFailureToAddObjectScriptNoScripts = root:AddCallback(
	__OnForgeFailureToAddObjectScriptNoScripts,
	function(context, targetPlayer)
		context.TargetPlayer = targetPlayer;
	end
	);

failureToAddObjectScriptNoScriptsResponse = onForgeFailureToAddObjectScriptNoScripts:Target(TargetPlayer):Response(
	{
		Fanfare = FanfareDefinitions.KillFeed,
		FanfareText = 'forge_failure_to_add_object_script',
	});