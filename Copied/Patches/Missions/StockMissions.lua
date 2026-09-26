-- Rewires the stock mission tree to activate the Mission Tree Expanded missions.
-- The new missions themselves are defined as JSON under Definitions/Missions.

local function AddActivation(branch, target)
    branch.actions:Append(PM.Missions:Action("ActivateMissionAction", function(action)
        action.TargetMissionID = target
        action.MissionOwner = "Agency"
    end))
end

local function RemoveActivation(branch, target)
    branch.actions:RemoveWhere(function(action) return action.TargetMissionID == target end)
end

local function RetargetActivation(branch, from, to)
    for _, action in ipairs(branch.actions) do
        if action.TargetMissionID == from then
            action.TargetMissionID = to
        end
    end
end

PM.Missions:Patch("DressRehearsalAvailableAtStart")
           :Named("KSP2Mission_Secondary_Kerbin_EVAGround")
           :Do(function(mission)
               -- Available as soon as a campaign starts.
               mission.state = "Active"
           end)

PM.Missions:Patch("Kerbin02Activations")
           :Named("KSP2Mission_Main_Kerbin_02")
           :Do(function(mission)
               -- Survival Training, I
               AddActivation(mission.ContentBranches.OnSubmit, "MTE_Secondary_MTES13_Survival_Training_Desert")
           end)

PM.Missions:Patch("Kerbin03Activations")
           :Named("KSP2Mission_Main_Kerbin_03")
           :Do(function(mission)
               local onSubmit = mission.ContentBranches.OnSubmit
               -- Fly by the Mun now sits between Kerbin orbit and Mun or Bust
               RetargetActivation(onSubmit, "Main_MunOrBust_04", "MTE_Main_Mun_Flyby")
               -- The Ice Spy
               AddActivation(onSubmit, "MTE_Secondary_MTES01_Polar_Orbit")
           end)

PM.Missions:Patch("MunOrBustActivations")
           :Named("KSP2Mission_Main_MunorBust")
           :Do(function(mission)
               local onSubmit = mission.ContentBranches.OnSubmit
               -- Circular Orbit now spawns from The Ice Spy
               RemoveActivation(onSubmit, "KSP2Mission_Secondary_Kerbin_OrbitCircular")
               -- Disco Party. Redux ships this mission but nothing in Redux activates it.
               AddActivation(onSubmit, "KSP2Mission_Secondary_Mun_OrbitInclination")
           end)

PM.Missions:Patch("OrbitCircularReward")
           :Named("KSP2Mission_Secondary_Kerbin_OrbitCircular")
           :Do(function(mission)
               -- Originally 100
               mission.missionStages["Mission Complete"].MissionReward.SciencePoints.RewardAmount = 50.0
           end)

PM.Missions:Patch("OrbitEccentricActivations")
           :Named("KSP2Mission_Secondary_Kerbin_OrbitEccentric")
           :Do(function(mission)
               -- Lonely Satellite now spawns here instead of from Mun OSS
               AddActivation(mission.ContentBranches.Debrief, "KSP2Mission_Secondary_Kerbin_Satellite")
           end)

PM.Missions:Patch("SatelliteActivations")
           :Named("KSP2Mission_Secondary_Kerbin_Satellite")
           :Do(function(mission)
               -- Keostationary Orbit now spawns here instead of from Bad Signal
               AddActivation(mission.ContentBranches.Debrief, "KSP2Mission_Secondary_Kerbin_OrbitKeostationary")
           end)

PM.Missions:Patch("MunOssActivations")
           :Named("KSP2Mission_Main_Mun_OSS")
           :Do(function(mission)
               -- Lonely Satellite now spawns from Eccentric Orbit
               RemoveActivation(mission.ContentBranches.OnSubmit, "KSP2Mission_Secondary_Kerbin_Satellite")
           end)

PM.Missions:Patch("Mun01Activations")
           :Named("KSP2Mission_Main_Mun_01")
           :Do(function(mission)
               -- Phone Home
               AddActivation(mission.ContentBranches.OnSubmit, "MTE_Secondary_MTES05_ComSat_Mun")
           end)

PM.Missions:Patch("KerbinRoverActivations")
           :Named("KSP2Mission_Secondary_Kerbin_Rover")
           :Do(function(mission)
               -- Strong Is The Far Side
               AddActivation(mission.ContentBranches.OnSubmit, "MTE_Secondary_MTES12_Far_Side")
           end)

PM.Missions:Patch("MinmusBadSignalActivations")
           :Named("KSP2Mission_Main_Minmus_BadSignal")
           :Do(function(mission)
               -- Keostationary Orbit now spawns from Lonely Satellite
               RemoveActivation(mission.ContentBranches.OnSubmit, "KSP2Mission_Secondary_Kerbin_OrbitKeostationary")
           end)

PM.Missions:Patch("MinmusLandHeavyReward")
           :Named("KSP2Mission_Secondary_Minmus_LandHeavy")
           :Do(function(mission)
               -- Originally 35
               mission.missionStages["Mission Complete"].MissionReward.SciencePoints.RewardAmount = 400.0
           end)

PM.Missions:Patch("Minmus01Activations")
           :Named("KSP2Mission_Main_Minmus_01")
           :Do(function(mission)
               local onSubmit = mission.ContentBranches.OnSubmit
               -- Picnic at Teetering Rock
               AddActivation(onSubmit, "MTE_Secondary_MTES09_Picnic_Teetering_Rock")
               -- The Outpost
               AddActivation(onSubmit, "MTE_Secondary_MTES10_Gound_Station_Monument")
               -- Celestial Dialogue
               AddActivation(onSubmit, "MTE_Primary_MTE02_Munar_Gateway")
           end)

PM.Missions:Patch("KerbinTourSOIActivations")
           :Named("KSP2Mission_Secondary_Kerbin_KerbinTourSOI")
           :Do(function(mission)
               -- Redux's Sightseeing activates its own Landing Party, which Redux does not ship.
               -- Point it at the MTE one instead.
               RetargetActivation(mission.ContentBranches.OnSubmit,
                   "KSP2Mission_Secondary_Kerbin_KerbinTourLanding", "MTE_Secondary_Kerbin_KerbinTourLanding")
           end)
