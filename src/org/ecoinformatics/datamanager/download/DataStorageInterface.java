/**
 *    '$RCSfile: DataStorageInterface.java,v $'
 *
 *     '$Author: tao $'
 *       '$Date: 2006-08-30 00:04:03 $'
 *   '$Revision: 1.2 $'
 *
 *  For Details: http://kepler.ecoinformatics.org
 *
 * Copyright (c) 2003 The Regents of the University of California.
 * All rights reserved.
 *
 * Permission is hereby granted, without written agreement and without
 * license or royalty fees, to use, copy, modify, and distribute this
 * software and its documentation for any purpose, provided that the
 * above copyright notice and the following two paragraphs appear in
 * all copies of this software.
 *
 * IN NO EVENT SHALL THE UNIVERSITY OF CALIFORNIA BE LIABLE TO ANY PARTY
 * FOR DIRECT, INDIRECT, SPECIAL, INCIDENTAL, OR CONSEQUENTIAL DAMAGES
 * ARISING OUT OF THE USE OF THIS SOFTWARE AND ITS DOCUMENTATION, EVEN
 * IF THE UNIVERSITY OF CALIFORNIA HAS BEEN ADVISED OF THE POSSIBILITY
 * OF SUCH DAMAGE.
 *
 * THE UNIVERSITY OF CALIFORNIA SPECIFICALLY DISCLAIMS ANY WARRANTIES,
 * INCLUDING, BUT NOT LIMITED TO, THE IMPLIED WARRANTIES OF
 * MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE. THE SOFTWARE
 * PROVIDED HEREUNDER IS ON AN "AS IS" BASIS, AND THE UNIVERSITY
 * OF CALIFORNIA HAS NO OBLIGATION TO PROVIDE MAINTENANCE, SUPPORT,
 * UPDATES, ENHANCEMENTS, OR MODIFICATIONS.
 */
package org.ecoinformatics.datamanager.download;

import java.io.InputStream;
import java.io.OutputStream;

public interface DataStorageInterface 
{
	/**
	 * Start to serialize remote inputstream. The OutputStream is 
	 * the destination.
	 * @param identifier
	 * @return
	 */
	public OutputStream startSerialize(String identifier);
	
	/**
	 * Finish serialize method
	 * @param indentifier
	 * @param errorCode
	 */
	public void finishSerialize(String indentifier, String errorCode);
	
	/**
	 * Load data from data storage system
	 * @param identifier
	 * @return
	 * @throws DataSourceNotFoundException
	 */
	public InputStream load(String identifier) throws DataSourceNotFoundException;
	
	/**
	 * Method to test if data already download or not.
	 * @param identifier
	 * @return
	 */
	public boolean doesDataExist(String identifier);
}
