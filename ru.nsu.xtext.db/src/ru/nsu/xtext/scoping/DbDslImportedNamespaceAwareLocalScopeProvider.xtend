package ru.nsu.xtext.scoping

import org.eclipse.xtext.scoping.impl.ImportedNamespaceAwareLocalScopeProvider
import org.eclipse.xtext.scoping.impl.ImportNormalizer
import org.eclipse.xtext.naming.QualifiedName

class DbDslImportedNamespaceAwareLocalScopeProvider 
   extends ImportedNamespaceAwareLocalScopeProvider{
	
	override getImplicitImports(boolean ignoreCase){
		newArrayList(new ImportNormalizer(
			QualifiedName::create("object", "Object"), true, ignoreCase
		))
	}	
}