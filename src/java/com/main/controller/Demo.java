/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package com.main.controller;

import java.util.Scanner;

import java.io.BufferedReader;
import java.io.InputStreamReader;
import java.util.HashSet;
import java.util.Iterator;

public class Demo {

    public static void main(String args[]) throws Exception {
        HashSet hs=new HashSet<Object>();
        hs.add("Hey");
        hs.add("Hello");
        hs.add("world");
        Iterator<HashSet> it = hs.iterator();
        while (it.hasNext()) {
             System.out.println(it.next());
            
        }
       
    }
}
