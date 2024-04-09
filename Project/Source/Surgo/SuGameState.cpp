#include "SuGameState.h"

#include "CogAll.h"
#include "CogWindowManager.h"

ASuGameState::ASuGameState()
{
	// Enable ticking
    PrimaryActorTick.bCanEverTick = true;
    PrimaryActorTick.SetTickFunctionEnable(true);
    PrimaryActorTick.bStartWithTickEnabled = true;
}

#pragma region GameState
void ASuGameState::BeginPlay()
{
#if ENABLE_COG
    CogWindowManager = NewObject<UCogWindowManager>(this);
    CogWindowManagerRef = CogWindowManager;

    // Add all the built-in windows
    Cog::AddAllWindows(*CogWindowManager);
#endif //ENABLE_COG
}

void ASuGameState::Tick(float DeltaSeconds)
{
	Super::Tick(DeltaSeconds);

#if ENABLE_COG
    CogWindowManager->Tick(DeltaSeconds);
#endif //ENABLE_COG
}
#pragma endregion GameState
