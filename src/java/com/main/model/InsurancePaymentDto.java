/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package com.main.model;

/**
 *
 * @author nityanand
 */
public class InsurancePaymentDto {
    private String[] partid,serviceid,ispaid,serviceispaid;
    private double [] amount,balance,total,serviceamount,servicebalance,servicetotal;

    public InsurancePaymentDto() {
    }

    public InsurancePaymentDto(String[] partid, String[] serviceid, String[] ispaid, String[] serviceispaid, double[] amount, double[] balance, double[] total, double[] serviceamount, double[] servicebalance, double[] servicetotal) {
        this.partid = partid;
        this.serviceid = serviceid;
        this.ispaid = ispaid;
        this.serviceispaid = serviceispaid;
        this.amount = amount;
        this.balance = balance;
        this.total = total;
        this.serviceamount = serviceamount;
        this.servicebalance = servicebalance;
        this.servicetotal = servicetotal;
    }

    public String[] getPartid() {
        return partid;
    }

    public void setPartid(String[] partid) {
        this.partid = partid;
    }

    public String[] getServiceid() {
        return serviceid;
    }

    public void setServiceid(String[] serviceid) {
        this.serviceid = serviceid;
    }
   
    public String[] getIspaid() {
        return ispaid;
    }

    public void setIspaid(String[] ispaid) {
        this.ispaid = ispaid;
    }

    public String[] getServiceispaid() {
        return serviceispaid;
    }

    public void setServiceispaid(String[] serviceispaid) {
        this.serviceispaid = serviceispaid;
    }

    public double[] getAmount() {
        return amount;
    }

    public void setAmount(double[] amount) {
        this.amount = amount;
    }

    public double[] getBalance() {
        return balance;
    }

    public void setBalance(double[] balance) {
        this.balance = balance;
    }

    public double[] getTotal() {
        return total;
    }

    public void setTotal(double[] total) {
        this.total = total;
    }

    public double[] getServiceamount() {
        return serviceamount;
    }

    public void setServiceamount(double[] serviceamount) {
        this.serviceamount = serviceamount;
    }

    public double[] getServicebalance() {
        return servicebalance;
    }

    public void setServicebalance(double[] servicebalance) {
        this.servicebalance = servicebalance;
    }

    public double[] getServicetotal() {
        return servicetotal;
    }

    public void setServicetotal(double[] servicetotal) {
        this.servicetotal = servicetotal;
    }
    
}
