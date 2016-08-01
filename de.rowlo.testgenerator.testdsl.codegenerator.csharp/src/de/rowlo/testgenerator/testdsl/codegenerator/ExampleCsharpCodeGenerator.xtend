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
package de.rowlo.testgenerator.testdsl.codegenerator

import de.rowlo.testgenerator.testdsl.generator.codegenerator.ICodeGenerator
import de.rowlo.testgenerator.testdsl.testDSL.Test
import org.eclipse.xtext.generator.IFileSystemAccess2

class ExampleCsharpCodeGenerator implements ICodeGenerator {
    
    override generateTestArtifacts(Test test, IFileSystemAccess2 fsa) {
        fsa.generateFile('c#/' + test.name.toFirstUpper + '.cs', pseudoCSharpUnitTestContent(test))
    }
    
    def pseudoCSharpUnitTestContent(Test test) {
        '''
        // generated pseudo C# unit test code
        public class «test.name.toFirstUpper» {
            «FOR testCase : test.testCases»
            [TestMethod]
            public void «testCase.name.toFirstLower»() {
                // TODO: pseudo code for setting input and checking expectation
            }
            
            «ENDFOR»
        }
        '''
    }
}