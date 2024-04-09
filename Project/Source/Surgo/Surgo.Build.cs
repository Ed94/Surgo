using System;
using System.Collections.Generic;

using ModuleRules = UnrealBuildTool.ModuleRules;
using ReadOnlyTargetRules = UnrealBuildTool.ReadOnlyTargetRules;
using TargetRules = UnrealBuildTool.TargetRules;
using UnrealTargetConfiguration = UnrealBuildTool.UnrealTargetConfiguration;

public class Surgo : ModuleRules
{
    public Surgo(ReadOnlyTargetRules Target) : base(Target)
    {
    #region Engine
        PrivateIncludePathModuleNames.AddRange(new string[] {
            "Core",
        });
        PrivateDependencyModuleNames.AddRange(new string[] {
            "Core",
            
            "AIModule",
            "CoreUObject", 
            "Engine", 
            "EnhancedInput",
            "GameplayAbilities",
            "GameplayTags",
            "GameplayTasks",
            "InputCore", 
            "NetCore",
            "Niagara",
        });
    #endregion Engine
    
    #region Plugins
		if (Target.Configuration != UnrealTargetConfiguration.Shipping && Target.Type != TargetRules.TargetType.Server)
        {
	        PrivateIncludePathModuleNames.AddRange( new string[]
	        {
		        "CogCommon",
	        });
            PrivateDependencyModuleNames.AddRange(new string[]
            {
	            // "UE_ImGui",
	            "CogCommon",
                "CogAbility",
                "CogAI",
                "CogAll",
                "CogDebug",
                "CogEngine",
                "CogImgui",
                "CogInput",
                "CogWindow",
            });
        }
    #endregion Plugins
    
		PublicIncludePathModuleNames.Add("Surgo");
    }
}
