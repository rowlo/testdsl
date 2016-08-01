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
package de.rowlo.testgenerator.testdsl.generator.codegenerator

import de.rowlo.testgenerator.testdsl.testDSL.Test
import org.eclipse.xtext.generator.IFileSystemAccess2

interface ICodeGenerator {
    def void generateTestArtifacts(Test test, IFileSystemAccess2 fsa);
}