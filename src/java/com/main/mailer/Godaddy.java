/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package com.main.mailer;

import java.util.Properties;
import javax.mail.Address;
import javax.mail.Message;
import javax.mail.Session;
import javax.mail.Transport;
import javax.mail.internet.InternetAddress;
import javax.mail.internet.MimeMessage;
import javax.security.auth.Subject;

/**
 *
 * @author user
 */
public class Godaddy {

    private static final String SMTP_HOST_NAME = "smtpout.asia.secureserver.net"; //smtp URL
    private static final int SMTP_HOST_PORT = 465; //port number
    private static String SMTP_AUTH_USER = "customer.first@karworx.com"; //email_id of sender
    private static String SMTP_AUTH_PWD = "customer123"; //password of sender email_id

    public static void main(String[] args) {

        try {
            Properties props = new Properties();
            props.put("mail.transport.protocol", "smtps");
            props.put("mail.smtps.host", SMTP_HOST_NAME);
            props.put("mail.smtps.auth", "true");

            Session mailSession = Session.getDefaultInstance(props);
            mailSession.setDebug(true);
            Transport transport = mailSession.getTransport();
            MimeMessage message = new MimeMessage(mailSession);

            message.setSubject("Hello");
            message.setContent("Message that you want to send", "text/html");
            Address[] from = InternetAddress.parse("customer.first@karworx.com");//Your domain email
            message.addFrom(from);
            message.addRecipient(Message.RecipientType.TO, new InternetAddress("krisnelatest@gmail.com")); //Send email To (Type email ID that you want to send)

            transport.connect(SMTP_HOST_NAME, SMTP_HOST_PORT, SMTP_AUTH_USER, SMTP_AUTH_PWD);
            transport.sendMessage(message, message.getRecipients(Message.RecipientType.TO));
            transport.close();
        } catch (Exception e) {
            e.printStackTrace();
        }
    }

}
