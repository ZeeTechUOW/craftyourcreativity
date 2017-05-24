/*
 * Copyright 2017 Andree Yosua.
 *
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 *      http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 */
package Model;

import java.util.Properties;
import javax.mail.Message;
import javax.mail.MessagingException;
import javax.mail.PasswordAuthentication;
import javax.mail.Session;
import javax.mail.Transport;
import javax.mail.internet.InternetAddress;
import javax.mail.internet.MimeMessage;

/**
 *
 * @author Deni Barasena
 */
public class MailAdmin {

    public final static String USER = "cyc.noreply@gmail.com";
    public final static String HOST = "smtp.gmail.com";
    public final static String PORT = "587";
    public final static String PASSWORD = "asdf12341234";

    private static final String ACCOUNT_REQUEST_SUBJECT_TEMPLATE = "CYC: Trainer Application - %s (%s)";

    private static String ACCOUNT_REQUEST_CONTENT_TEMPLATE(User user) {
        String link = user.getActivationLink() + "?fullname=" + user.getFullName() + "&email=" + user.getEmail() + "&organization=" + user.getOrganization();

        return "Trainer Application - " + user.getFullName() + " (" + user.getOrganization() + ")<br><br>"
                + "Email : " + user.getEmail() + "<br>"
                + "Full Name : " + user.getFullName() + "<br>"
                + "Organization : " + user.getOrganization() + "<br>"
                + "Click the following link to approve this account :<br>"
                + "<a href='" + link + "'>" + link + "</a><br>Or<br>"
                + "<form action='" + user.getActivationLink() + "' method='post'>"
                + "<input type='hidden' name='fullname' value='" + user.getFullName() + "'>"
                + "<input type='hidden' name='email' value='" + user.getEmail() + "'>"
                + "<input type='hidden' name='organization' value='" + user.getOrganization() + "'>"
                + "<input type='submit' value='Approve'>"
                + "</form>";
    }
    private static final String ACCOUNT_CONFIRMED_SUBJECT_TEMPLATE = "CYC: Trainer Application Approved";

    private static String ACCOUNT_CONFIRMED_CONTENT_TEMPLATE(User user) {
        return "Trainer Application - " + user.getFullName() + " (" + user.getOrganization() + ") Approved<br><br>"
                + "Username : " + user.getUsername() + "<br>"
                + "Password : " + user.getPassword() + "<br>"
                + "Note that your password can be changed on the settings page.<br><br>"
                + "Click the following link to login :<br>"
                + "<a href='" + user.getActivationLink() + "'>" + user.getActivationLink() + "</a><br>Or<br>"
                + "<form action='" + user.getActivationLink() + "' method='post'>"
                + "<input type='hidden' name='username' value='" + user.getUsername() + "'>"
                + "<input type='hidden' name='password' value='" + user.getPassword() + "'>"
                + "<input type='submit' value='Log in'>"
                + "</form>";
    }
    private static final String NEW_PASSWORD_SUBJECT_TEMPLATE = "CYC: Account Password Reset";

    private static String NEW_PASSWORD_CONTENT_TEMPLATE(User user, String password) {
        return "Account Password Reset - " + user.getFullName() + "<br><br>"
                + "Username : " + user.getUsername() + "<br>"
                + "Password : " + password + "<br>"
                + "Note that your password can be changed on the settings page.<br><br>"
                + "Click the following link to login :<br>"
                + "<a href='" + user.getActivationLink() + "'>" + user.getActivationLink() + "</a><br>Or<br>"
                + "<form action='" + user.getActivationLink() + "' method='post'>"
                + "<input type='hidden' name='username' value='" + user.getUsername() + "'>"
                + "<input type='hidden' name='password' value='" + password + "'>"
                + "<input type='submit' value='Log in'>"
                + "</form>";
    }

    public static void sendAccountRequestMail(User userData) {
        sendAccountRequestMail(userData, DBAdmin.getAdminEmail());
    }

    public static void sendAccountRequestMail(User userData, String toAddress) {
        String subject = String.format(ACCOUNT_REQUEST_SUBJECT_TEMPLATE, userData.getFullName(), userData.getOrganization());
        String content = ACCOUNT_REQUEST_CONTENT_TEMPLATE(userData);
        sendMail(subject, content, toAddress);
    }

    public static void sendAccountConfirmedMail(User confirmedUser) {
        String subject = ACCOUNT_CONFIRMED_SUBJECT_TEMPLATE;
        String content = ACCOUNT_CONFIRMED_CONTENT_TEMPLATE(confirmedUser);
        sendMail(subject, content, confirmedUser.getEmail());
    }

    public static void sendNewPassword(User user, String password) {
        String subject = NEW_PASSWORD_SUBJECT_TEMPLATE;
        String content = NEW_PASSWORD_CONTENT_TEMPLATE(user, password);
        sendMail(subject, content, user.getEmail());
    }

    public static void sendMail(String subject, String content, String to) {
        Properties properties = System.getProperties();
        properties.put("mail.smtp.host", HOST);
        properties.put("mail.smtp.port", PORT);
        properties.put("mail.smtp.auth", "true");
        properties.put("mail.smtp.starttls.enable", "true");

        Session session = Session.getInstance(properties, new javax.mail.Authenticator() {
            @Override
            protected PasswordAuthentication getPasswordAuthentication() {
                return new PasswordAuthentication(USER, PASSWORD);
            }
        });

        try {
            MimeMessage message = new MimeMessage(session);
            message.setFrom(new InternetAddress(USER));
            message.addRecipient(Message.RecipientType.TO, new InternetAddress(to));

            message.setSubject(subject);
            message.setContent(content, "text/html; charset=utf-8");

            Transport.send(message);
        } catch (MessagingException mex) {
            mex.printStackTrace();
        }
    }
}
