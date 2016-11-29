/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package com.main.mailer;

/**
 *
 * @author user
 */
import java.io.UnsupportedEncodingException;
import javax.mail.Message;
import javax.mail.PasswordAuthentication;
import javax.mail.Transport;
import javax.mail.internet.InternetAddress;
import javax.mail.internet.MimeMessage;
import javax.servlet.http.HttpServletRequest;
import java.util.Properties;
import javax.mail.Session;

public class SendMail {
    
    public static void main(String[] args) {
        SendMail sendMail=new SendMail();
        sendMail.SendVerificationMail(555, "Nitz", "krisnelatest@gmail.com", "dbjfhdjfhjf",  null);
    }
    

    public void SendVerificationMail(Integer Registration_Id, String stName, String stEmailId, String stVerificationCode,  String type) {
        try {
            System.setProperty("java.protocol.handler.pkgs", "com.sun.net.ssl.internal.www.protocol");
            final String user = "customer.first@karworx.com";//change accordingly  
            final String pass = "customer123";
            String stHost = "smtpout.asia.secureserver.net";
            String stTo = stEmailId;

            String stFromName = "Karworx";
            String stFrom = "customer.first@karworx.com";  // write your email address means from email address.

            String stSubject = "Karworx Password";

            String stMessageText = "Hi " + stName + ",<br/><br/>";
            stMessageText += "You just signed up for Karworx. Please follow this link to confirm that this is your e-mail address.<br/><br/>";
            //stMessageText += "Please use " + stVerificationCode + " as verification code.\n\n";
            stMessageText += "Please click on the link below to complete verification.<br/><br/>";
            stMessageText += "<a href='http://perkmart.com/Perkmart/TermsAndCondition?Id=" + Registration_Id.toString() + "&type=" + type + "&code=" + stVerificationCode + "' style='font-size: 14px;font-weight: bold;color: white;border: 1px solid #0d851b;background: #15981e;text-decoration: none;padding: 5px 10px;'>Verify your email address</a><br/><br/>";
            stMessageText += "If you have any issues verifying your email we will be happy to help you.<br/>You can contact us on contactus@perkmart.com<br/><br/>";
            stMessageText += "Thanks,<br/>";
            stMessageText += "The Perkmart Team<br/>";
            stMessageText += "This is an unattended mailbox, do not hit the reply button to send mails to us. Kindly direct your queries to contactus@perkmart.com";

            boolean sessionDebug = true;
            // Create some properties and get the default Session.
            //System.setProperty("smtp.protocols", "SSLv3");
            Properties props = System.getProperties();

            props.put("mail.smtp.host", "smtpout.asia.secureserver.net");//change accordingly  
            props.put("mail.smtp.auth", "true");
            props.put("mail.smtp.port", 25);    //port is 587 for TLS  if you use SSL then port is 465

            Session session = Session.getDefaultInstance(props,
                    new javax.mail.Authenticator() {
                        protected PasswordAuthentication getPasswordAuthentication() {
                            return new PasswordAuthentication(user, pass);
                        }
                    });
//2nd step)compose message  
            MimeMessage message = new MimeMessage(session);
            message.setFrom(new InternetAddress(stFrom, "Perkmart Admin"));
            message.addRecipient(Message.RecipientType.TO, new InternetAddress(stTo));
            message.setSubject(stSubject);
            message.setText("");
            message.setContent("" + stMessageText + "", "text/html");

            //3rd step)send message  
            Transport.send(message);
        } catch (Exception e) {
            e.printStackTrace();

        }
    }

}
