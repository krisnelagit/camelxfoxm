/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package com.main.controller;

import com.main.mailer.KrisnelaSendMailAPI;
import org.springframework.context.ConfigurableApplicationContext;
import org.springframework.context.support.ClassPathXmlApplicationContext;

public class Demo {

    public static void main(String[] args) throws Exception {
        String configfile="dispatcher-servlet.xml";
        ConfigurableApplicationContext context=new ClassPathXmlApplicationContext(configfile);
        KrisnelaSendMailAPI aPI=(KrisnelaSendMailAPI)context.getBean("krisnelaEmail");
        String to="krisnelatest@gmail.com";
        String from="krisnelatest@gmail.com";
        String subject="test subject";
        String body="There you go.. You got an email.. Let's understand details on how Spring MVC works -- By Krisnela Admin\"";
        aPI.sendmailinfok(from, to, subject, body);
    }
}
