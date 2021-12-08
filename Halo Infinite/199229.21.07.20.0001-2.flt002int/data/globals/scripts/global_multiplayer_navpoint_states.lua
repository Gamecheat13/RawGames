-- Copyright (C) Microsoft. All rights reserved.
-- =============================================================================================================================
-- ============================================ GLOBAL Navpoint MP States ======================================================
-- =============================================================================================================================
-- declare hstructs here to use them in non-global scripts
--## SERVER

--
--	GLOBAL
--

hstructure NavpointState	
	navState 			:visual_state_group;	
	friendlyTeamFilter  :visual_state_filter;
	enemyTeamFilter 	:visual_state_filter;
end