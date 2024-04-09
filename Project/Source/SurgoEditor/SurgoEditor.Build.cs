using ModuleRules = UnrealBuildTool.ModuleRules;
using ReadOnlyTargetRules = UnrealBuildTool.ReadOnlyTargetRules;

public class SurgoEditor : ModuleRules
{
    public SurgoEditor(ReadOnlyTargetRules Target) : base(Target)
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
