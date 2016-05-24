/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package com.main.practice;

/**
 *
 * @author manish
 */
public class NewThread implements Runnable{
    
    Thread t;

    public NewThread() {
        //create a new second thread
        t=new Thread(this, "Demo thread");
        System.out.println("Child thread: "+t);
        t.start();
    }
    
    

    //Entry point of second thread
    public void run() {
        try {
            for (int i = 5; i >0; i--) {
                System.out.println("Child thread: "+i);
                Thread.sleep(500);
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        System.out.println("Exiting child thread.");
    }
    
}
