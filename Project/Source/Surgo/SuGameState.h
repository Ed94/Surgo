#pragma once

#include "CoreMinimal.h"
#include "GameFramework/GameState.h"

#include "SuCommon.h"

#include "SuGameState.generated.h"


UCLASS(BlueprintType)
class SURGO_API ASuGameState : public AGameState
{
	GENERATED_BODY()
public:

	ASuGameState();
	
    // To make sure it doesn't get garbage collected.
    UPROPERTY()
    TObjectPtr<UObject> CogWindowManagerRef = nullptr;
	
#if ENABLE_COG
	TObjectPtr<UCogWindowManager> CogWindowManager = nullptr;
#endif // ENABLE_COG

#pragma region GameState
	void BeginPlay() override;

	void Tick(float DeltaSeconds) override;
#pragma endregion GameState
};
