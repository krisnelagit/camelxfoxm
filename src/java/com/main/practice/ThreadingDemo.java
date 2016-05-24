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
public class ThreadingDemo {
    public static void main(String[] args) {
        new NewThread();
        
        try {
            for (int i = 5; i >0; i--) {
                System.out.println("Main thread: "+i);
                Thread.sleep(1000);
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        System.out.println("Main thread Exiting");
    }
    
}
