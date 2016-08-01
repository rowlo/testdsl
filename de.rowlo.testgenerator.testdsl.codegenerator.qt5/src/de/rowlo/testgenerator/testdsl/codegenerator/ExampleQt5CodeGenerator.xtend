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
import de.rowlo.testgenerator.testdsl.testDSL.DataTypeProperty
import de.rowlo.testgenerator.testdsl.testDSL.EnumProperty
import de.rowlo.testgenerator.testdsl.testDSL.Property
import de.rowlo.testgenerator.testdsl.testDSL.Test
import de.rowlo.testgenerator.testdsl.testDSL.TestCase
import org.eclipse.emf.common.util.EList
import org.eclipse.xtext.generator.IFileSystemAccess2

/**
 * That generator is dependend on a concrete instance of a domain model.
 * Specifically it's looking for enum literals "LITERAL_A" and "LITERAL_B".
 */
class ExampleQt5CodeGenerator implements ICodeGenerator {
    
    override generateTestArtifacts(Test test, IFileSystemAccess2 fsa) {
        fsa.generateFile('qt5/' + test.name.toLowerCase + '.h', pseudoQtUnitTestHeaderContent(test))
        fsa.generateFile('qt5/' + test.name.toLowerCase + '.cpp', pseudoQtUnitTestSourceContent(test))
    }
    
    def pseudoQtUnitTestHeaderContent(Test test) {
        '''
        // generated pseudo Qt5 unit test code: header file
        #include <QtTest/QtTest>
        
        class «test.name.toFirstUpper»: public QObject
        {
            Q_OBJECT
        private slots:
            «FOR testCase : test.testCases»
            void «testCase.name.toFirstLower»();
            «ENDFOR»
        };
        '''
    }
    
    def pseudoQtUnitTestSourceContent(Test test) {
        '''
        // generated pseudo Qt5 unit test code: source file
        #include "«test.name.toLowerCase».h"
        
        «FOR testCase : test.testCases»
        void «test.name.toFirstUpper»::«testCase.name.toFirstLower»()
        {
            «IF testCase.input.properties.hasLiteral("pathA")»
            QString strA = theCallForAToTest("«testCase.inputProperty("pathA")»");
            QCOMPARE(strA, QString("«testCase.expectValue("pathA")»"));
            «ELSEIF testCase.input.properties.hasLiteral("pathB")»
            QString strB = theCallForBToTest("«testCase.inputProperty("pathB")»");
            QCOMPARE(strB, QString("«testCase.expectValue("pathB")»"));
            «ENDIF»
        }
        «ENDFOR»
        
        QTEST_MAIN(«test.name.toFirstUpper»)
        #include "«test.name.toLowerCase».moc"
        '''
    }
    
    def boolean hasLiteral(EList<Property> list, String literalName) {
        return list
                .filter(typeof(EnumProperty))
                .exists[e | e.value.name.equals(literalName)]
    }
    
    
    def String inputProperty(TestCase testCase, String literalName) {
        return propertyValue(testCase.input.properties, literalName)
    }

    def String expectValue(TestCase testCase, String literalName) {
        return propertyValue(testCase.expectation.properties, literalName)
    }
    
    def propertyValue(EList<Property> list, String literalName) {
        val dependentProperties = list
            .filter[p | p.requiredEnumLiteral != null && p.requiredEnumLiteral.name.equals(literalName)]
        if (dependentProperties.isNullOrEmpty) {
            return null;
        }
        val property = dependentProperties.get(0);
        return propertyValue(property);
    }
    
    dispatch def String propertyValue(DataTypeProperty property) {
        return property.value;
    }
    
    dispatch def String propertyValue(EnumProperty property) {
        return property.value.name;
    }
    
}