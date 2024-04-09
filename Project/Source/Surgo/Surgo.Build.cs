using System;
using System.Collections.Generic;

using ModuleRules = UnrealBuildTool.ModuleRules;
using ReadOnlyTargetRules = UnrealBuildTool.ReadOnlyTargetRules;

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
        });
    #endregion Engine
    
		PublicIncludePathModuleNames.Add("Surgo");
    }
}
