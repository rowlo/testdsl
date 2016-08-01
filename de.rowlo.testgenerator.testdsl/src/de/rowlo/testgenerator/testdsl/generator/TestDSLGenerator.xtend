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
package de.rowlo.testgenerator.testdsl.generator

import de.rowlo.testgenerator.testdsl.generator.codegenerator.CodeGeneratorExtensionsManager
import de.rowlo.testgenerator.testdsl.testDSL.Test
import org.eclipse.emf.ecore.resource.Resource
import org.eclipse.xtext.generator.AbstractGenerator
import org.eclipse.xtext.generator.IFileSystemAccess2
import org.eclipse.xtext.generator.IGeneratorContext

/**
 * Generates code from your model files on save.
 * 
 * See https://www.eclipse.org/Xtext/documentation/303_runtime_concepts.html#code-generation
 */
class TestDSLGenerator extends AbstractGenerator {

	override void doGenerate(Resource resource, IFileSystemAccess2 fsa, IGeneratorContext context) {
	    var allTests = resource.allContents.filter(typeof(Test))
	    allTests.forEach[test | generateUnitTestFiles(test,fsa)]
	}
    
    def generateUnitTestFiles(Test test, IFileSystemAccess2 fsa) {
        val codeGenerators = CodeGeneratorExtensionsManager.registeredCodeGenerators.values
        for (codeGenerator : codeGenerators) {
        	codeGenerator.generateTestArtifacts(test, fsa)
        }
    }

}
