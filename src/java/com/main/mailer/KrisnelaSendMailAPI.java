/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package com.main.mailer;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.mail.MailSender;
import org.springframework.mail.SimpleMailMessage;
import org.springframework.stereotype.Service;

/**
 *
 * @author nityanand
 */
@Service("krisnelaEmail")
public class KrisnelaSendMailAPI {
    
    @Autowired
    private MailSender krisnelamail;
    
    public void sendmailinfok(String from,String to,String subject,String messageBody){
        SimpleMailMessage mailMessage=new SimpleMailMessage();
        mailMessage.setFrom(from);
        mailMessage.setTo(from);
        mailMessage.setSubject(from);
        mailMessage.setText(from);
        krisnelamail.send(mailMessage);
    }
    
    
}
