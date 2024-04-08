#pragma once 

#include "Modules/ModuleInterface.h"

class SURGO_API FSurgoModule : public IModuleInterface
{
public:
	static bool IsAvailable() {
		return FModuleManager::Get().IsModuleLoaded("Surgo");
	}
	
	static FSurgoModule& Get() 	{
		return FModuleManager::LoadModuleChecked<FSurgoModule>("Surgo");
	}
	
protected:
	void StartupModule() override;
	void ShutdownModule() override;
};
