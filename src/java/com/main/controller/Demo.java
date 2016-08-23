/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package com.main.controller;

import java.io.BufferedReader;
import java.io.FileInputStream;
import java.io.FileReader;
import java.util.Arrays;
import java.util.Collections;
import java.util.HashSet;
import java.util.List;
import java.util.Set;

public class Demo {

    private static final long MEGABYTE = 1024L * 1024L;

    public static long bytesToMegabytes(long bytes) {
        return bytes / MEGABYTE;
    }

    public static void main(String[] args) {
        long startTime = System.currentTimeMillis();
        BufferedReader br = null;
        try {
            String scurrentLine;
            br = new BufferedReader(new FileReader("/home/nityanand/Desktop/testt.txt"));
            while ((scurrentLine = br.readLine()) != null) {
//                System.out.print(scurrentLine);   
                List<String> list = Arrays.asList(scurrentLine.split(" "));
                Set<String> uniquewords = new HashSet<String>(list);
                for (String word : uniquewords) {
                    System.out.println(word + ": " + Collections.frequency(list, word));
                }
            }
            

        } catch (Exception e) {
        }
        long stopTime = System.currentTimeMillis();
        long elapsedTime = stopTime - startTime;
        System.out.println(elapsedTime);

// Get the Java runtime
        Runtime runtime = Runtime.getRuntime();
// Run the garbage collector
        runtime.gc();
// Calculate the used memory
        long memory = runtime.totalMemory() - runtime.freeMemory();
        System.out.println("Used memory is bytes: " + memory);
        System.out.println("Used memory is megabytes: "
                + bytesToMegabytes(memory));
    }
}
