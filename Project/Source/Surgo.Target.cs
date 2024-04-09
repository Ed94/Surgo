using BuildSettingsVersion = UnrealBuildTool.BuildSettingsVersion;
using TargetInfo = UnrealBuildTool.TargetInfo;
using TargetRules = UnrealBuildTool.TargetRules;
using TargetType = UnrealBuildTool.TargetType;

public class SurgoTarget : TargetRules
{
    public SurgoTarget(TargetInfo Target) : base(Target)
    {
        Type = TargetType.Game;
        DefaultBuildSettings = BuildSettingsVersion.Latest;
        
        ExtraModuleNames.Add("Surgo");
    }
}
