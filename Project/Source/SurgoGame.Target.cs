using TargetInfo = UnrealBuildTool.TargetInfo;
using TargetRules = UnrealBuildTool.TargetRules;
using TargetType = UnrealBuildTool.TargetType;

public class SurgoGameTarget : TargetRules
{
    public SurgoGameTarget(TargetInfo Target) : base(Target)
    {
        Type = TargetType.Game;
    }
}
