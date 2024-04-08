#pragma once 

#include "Modules/ModuleInterface.h"

class SURGOEDITOR_API FSurgoEditorModule : public IModuleInterface
{
public:
	static bool IsAvailable() {
		return FModuleManager::Get().IsModuleLoaded("SurgoEditor");
	}
	
	static FSurgoEditorModule& Get() 	{
		return FModuleManager::LoadModuleChecked<FSurgoEditorModule>("SurgoEditor");
	}

protected:
	void StartupModule() override;
	void ShutdownModule() override;
};
