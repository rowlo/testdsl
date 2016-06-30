package de.rowlo.testgenerator.testdsl.codegenerator

import de.rowlo.testgenerator.testdsl.generator.codegenerator.ICodeGenerator
import de.rowlo.testgenerator.testdsl.testDSL.Test
import org.eclipse.xtext.generator.IFileSystemAccess2

class ExampleJavaCodeGenerator implements ICodeGenerator {
    
    override generateTestArtifacts(Test test, IFileSystemAccess2 fsa) {
        fsa.generateFile('java/' + test.name.toFirstUpper + '.java', pseudoJavaUnitTestContent(test))
    }
    
    def pseudoJavaUnitTestContent(Test test) {
        '''
        // generated pseudo Java unit test code
        public class «test.name.toFirstUpper» {
            «FOR testCase : test.testCases»
            @Test
            public void «testCase.name.toFirstLower»() {
                // TODO: pseudo code for setting input and asserting expectation
            }
            
            «ENDFOR»
        }
        '''
    }
    
}