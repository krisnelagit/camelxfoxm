/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package com.main.model;

import javax.persistence.Entity;
import javax.persistence.GeneratedValue;
import javax.persistence.Id;
import javax.persistence.Table;

/**
 *
 * @author manish
 */
@Entity(name = "student")
@Table(name = "student")
public class Student {
    @Id
    @GeneratedValue
    private int id;
    private int version;
    private String name,rollnumber;

    public Student(int id, int version, String name, String rollnumber) {
        this.id = id;
        this.version = version;
        this.name = name;
        this.rollnumber = rollnumber;
    }

    public Student() {
    }

    public int getId() {
        return id;
    }

    public void setId(int id) {
        this.id = id;
    }

    public int getVersion() {
        return version;
    }

    public void setVersion(int version) {
        this.version = version;
    }

    public String getName() {
        return name;
    }

    public void setName(String name) {
        this.name = name;
    }

    public String getRollnumber() {
        return rollnumber;
    }

    public void setRollnumber(String rollnumber) {
        this.rollnumber = rollnumber;
    }
    
    
    
}
