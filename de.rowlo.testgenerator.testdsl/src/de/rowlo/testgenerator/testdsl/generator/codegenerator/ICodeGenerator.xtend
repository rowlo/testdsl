package de.rowlo.testgenerator.testdsl.generator.codegenerator

import de.rowlo.testgenerator.testdsl.testDSL.Test
import org.eclipse.xtext.generator.IFileSystemAccess2

interface ICodeGenerator {
    def void generateTestArtifacts(Test test, IFileSystemAccess2 fsa);
}