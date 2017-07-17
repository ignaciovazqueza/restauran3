/*
 * $Header: /cvsroot/securityfilter/securityfilter/src/example/org/securityfilter/example/realm/TrivialSecurityRealm.java,v 1.3 2003/10/25 10:49:04 maxcooper Exp $
 * $Revision: 1.3 $
 * $Date: 2003/10/25 10:49:04 $
 *
 * ====================================================================
 * The SecurityFilter Software License, Version 1.1
 *
 * (this license is derived and fully compatible with the Apache Software
 * License - see http://www.apache.org/LICENSE.txt)
 *
 * Copyright (c) 2002 SecurityFilter.org. All rights reserved.
 *
 * Redistribution and use in source and binary forms, with or without
 * modification, are permitted provided that the following conditions
 * are met:
 *
 * 1. Redistributions of source code must retain the above copyright
 *    notice, this list of conditions and the following disclaimer.
 *
 * 2. Redistributions in binary form must reproduce the above copyright
 *    notice, this list of conditions and the following disclaimer in
 *    the documentation and/or other materials provided with the
 *    distribution.
 *
 * 3. The end-user documentation included with the redistribution,
 *    if any, must include the following acknowledgment:
 *       "This product includes software developed by
 *        SecurityFilter.org (http://www.securityfilter.org/)."
 *    Alternately, this acknowledgment may appear in the software itself,
 *    if and wherever such third-party acknowledgments normally appear.
 *
 * 4. The name "SecurityFilter" must not be used to endorse or promote
 *    products derived from this software without prior written permission.
 *    For written permission, please contact license@securityfilter.org .
 *
 * 5. Products derived from this software may not be called "SecurityFilter",
 *    nor may "SecurityFilter" appear in their name, without prior written
 *    permission of SecurityFilter.org.
 *
 * THIS SOFTWARE IS PROVIDED ``AS IS'' AND ANY EXPRESSED OR IMPLIED
 * WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED WARRANTIES
 * OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE
 * DISCLAIMED.  IN NO EVENT SHALL THE SECURITY FILTER PROJECT OR
 * ITS CONTRIBUTORS BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL,
 * SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT
 * LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF
 * USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND
 * ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY,
 * OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT
 * OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF
 * SUCH DAMAGE.
 * ====================================================================
 */

package securityfilter;

import org.hibernate.Session;
import org.securityfilter.realm.SimpleSecurityRealmBase;
import securityfilter.util.HibernateUtil;

import java.io.IOException;

public class TrivialSecurityRealm extends SimpleSecurityRealmBase {

   public boolean booleanAuthenticate(String username, String password) {
      Session session = HibernateUtil.getInstance().getSession();
      AdminValues admin = new AdminValues();
      try {
         if (admin.getAdminName().equals(username) && admin.getPassword().equals(password)) {
            return true;
         }
         Object mesa = session.createQuery("from Mesa where mesa='" + username + "' and token='" + password + "'").uniqueResult();
         if (mesa != null) {
            return true;
         }
      } catch (IOException e1) {
         e1.printStackTrace();
      }
      return false;
   }


   @Override
   public boolean isUserInRole(String username, String rolename) {
      Session session = HibernateUtil.getInstance().getSession();
      Object mesa = session.createQuery("from Mesa where mesa='" + username + "'").uniqueResult();
      AdminValues admin = new AdminValues();
      try {
         if (mesa != null && rolename.equals("userrole")) {
            return true;
         } else if (admin.getAdminName().equals(username) && rolename.equals("adminrole")) {
            return true;
         }
      } catch (IOException e) {
         e.printStackTrace();
      }
      return false;
   }
}