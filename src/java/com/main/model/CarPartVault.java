/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package com.main.model;

import java.text.SimpleDateFormat;
import java.util.Calendar;
import javax.persistence.Entity;
import javax.persistence.Id;
import javax.persistence.Table;

/**
 *
 * @author user
 */
@Entity(name = "carpartvault")
@Table(name = "carpartvault")
public class CarPartVault {
    @Id
    private String id;
    private String showIn180,isOld,categoryid,oempartnumber="",partlocation="",a,b,c,d,itemtype,name,isdelete="No",modifydate=new SimpleDateFormat("yyyy-MM-dd HH:mm:ss").format(Calendar.getInstance().getTime());  

    public CarPartVault(String id, String showIn180, String isOld, String categoryid, String a, String b, String c, String d, String itemtype, String name) {
        this.id = id;
        this.showIn180 = showIn180;
        this.isOld = isOld;
        this.categoryid = categoryid;
        this.a = a;
        this.b = b;
        this.c = c;
        this.d = d;
        this.itemtype = itemtype;
        this.name = name;
    }

    public String getShowIn180() {
        return showIn180;
    }

    public void setShowIn180(String showIn180) {
        this.showIn180 = showIn180;
    }

    public String getIsOld() {
        return isOld;
    }

    public void setIsOld(String isOld) {
        this.isOld = isOld;
    }
        
    public String getOempartnumber() {
        return oempartnumber;
    }

    public void setOempartnumber(String oempartnumber) {
        this.oempartnumber = oempartnumber;
    }

    public String getPartlocation() {
        return partlocation;
    }

    public void setPartlocation(String partlocation) {
        this.partlocation = partlocation;
    }
    
    public String getItemtype() {
        return itemtype;
    }

    public void setItemtype(String itemtype) {
        this.itemtype = itemtype;
    }
    
    public String getA() {
        return a;
    }

    public void setA(String a) {
        this.a = a;
    }

    public String getB() {
        return b;
    }

    public void setB(String b) {
        this.b = b;
    }

    public String getC() {
        return c;
    }

    public void setC(String c) {
        this.c = c;
    }

    public String getD() {
        return d;
    }

    public void setD(String d) {
        this.d = d;
    }    

    public CarPartVault() {
    }

    public String getId() {
        return id;
    }

    public void setId(String id) {
        this.id = id;
    }

    public String getCategoryid() {
        return categoryid;
    }

    public void setCategoryid(String categoryid) {
        this.categoryid = categoryid;
    }

    public String getName() {
        return name;
    }

    public void setName(String name) {
        this.name = name;
    }

    public String getIsdelete() {
        return isdelete;
    }

    public void setIsdelete(String isdelete) {
        this.isdelete = isdelete;
    }

    public String getModifydate() {
        return modifydate;
    }

    public void setModifydate(String modifydate) {
        this.modifydate = modifydate;
    }
    
    
}
