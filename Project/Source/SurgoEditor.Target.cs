using TargetInfo = UnrealBuildTool.TargetInfo;
using TargetRules = UnrealBuildTool.TargetRules;
using TargetType  = UnrealBuildTool.TargetType;

public class SurgoEditorTarget : TargetRules
{
    public SurgoEditorTarget(TargetInfo Target) : base(Target)
    {
        Type = TargetType.Editor;
    }
}
