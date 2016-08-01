/*******************************************************************************
* Copyright (c) 2016 Robert Wloch
* All rights reserved. This program and the accompanying materials
* are made available under the terms of the Eclipse Public License v1.0
* which accompanies this distribution, and is available at
* http://www.eclipse.org/legal/epl-v10.html
*
* Contributors:
* Robert Wloch - initial API and implementation
*******************************************************************************/
package de.rowlo.testgenerator.testdsl.generator.codegenerator;

import java.util.HashMap;
import java.util.Map;

import org.eclipse.core.runtime.CoreException;
import org.eclipse.core.runtime.IConfigurationElement;
import org.eclipse.core.runtime.IExtensionRegistry;
import org.eclipse.core.runtime.Platform;
import org.eclipse.e4.core.di.annotations.Execute;

public class CodeGeneratorExtensionsManager {
	private static final String CODEGENERATOR_ID = "de.rowlo.testgenerator.testdsl.codeGenerator";
	private static final Map<String, ICodeGenerator> codeGenerators = new HashMap<String, ICodeGenerator>();

	@Execute
	public void execute(IExtensionRegistry registry) {
		IConfigurationElement[] config = registry.getConfigurationElementsFor(CODEGENERATOR_ID);
		try {
			for (IConfigurationElement e : config) {
				final Object o = e.createExecutableExtension("class");
				if (o instanceof ICodeGenerator) {
					ICodeGenerator codeGenerator = (ICodeGenerator) o;
					String codeGeneratorName = e.getAttribute("name");
					if (codeGeneratorName == null || codeGeneratorName.isEmpty()) continue;
					codeGenerators.put(codeGeneratorName, codeGenerator);
				}
			}
		} catch (CoreException ex) {
		}
	}
	
	public static Map<String, ICodeGenerator> getRegisteredCodeGenerators() {
		if (codeGenerators.isEmpty()) {
			IExtensionRegistry extensionRegistry = Platform.getExtensionRegistry();
			CodeGeneratorExtensionsManager extensionsManager = new CodeGeneratorExtensionsManager();
			extensionsManager.execute(extensionRegistry);
		}
		return new HashMap<String, ICodeGenerator>(codeGenerators);
	}
}
