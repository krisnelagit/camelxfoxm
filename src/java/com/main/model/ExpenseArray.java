/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package com.main.model;

/**
 *
 * @author manish
 */
public class ExpenseArray {
    private String [] amounts,modes,chequenumbers,chequedates,transactionnumbers,transactiondates,carddetailss,bank_accountids,banknames;

    public ExpenseArray(String[] amounts, String[] modes, String[] chequenumbers, String[] chequedates, String[] transactionnumbers, String[] transactiondates, String[] carddetailss, String[] bank_accountids, String[] banknames) {
        this.amounts = amounts;
        this.modes = modes;
        this.chequenumbers = chequenumbers;
        this.chequedates = chequedates;
        this.transactionnumbers = transactionnumbers;
        this.transactiondates = transactiondates;
        this.carddetailss = carddetailss;
        this.bank_accountids = bank_accountids;
        this.banknames = banknames;
    }

    public String[] getBanknames() {
        return banknames;
    }

    public void setBanknames(String[] banknames) {
        this.banknames = banknames;
    }
    
    public ExpenseArray() {
    }

    public String[] getAmounts() {
        return amounts;
    }

    public void setAmounts(String[] amounts) {
        this.amounts = amounts;
    }

    public String[] getModes() {
        return modes;
    }

    public void setModes(String[] modes) {
        this.modes = modes;
    }

    public String[] getChequenumbers() {
        return chequenumbers;
    }

    public void setChequenumbers(String[] chequenumbers) {
        this.chequenumbers = chequenumbers;
    }

    public String[] getChequedates() {
        return chequedates;
    }

    public void setChequedates(String[] chequedates) {
        this.chequedates = chequedates;
    }

    public String[] getTransactionnumbers() {
        return transactionnumbers;
    }

    public void setTransactionnumbers(String[] transactionnumbers) {
        this.transactionnumbers = transactionnumbers;
    }

    public String[] getTransactiondates() {
        return transactiondates;
    }

    public void setTransactiondates(String[] transactiondates) {
        this.transactiondates = transactiondates;
    }

    public String[] getCarddetailss() {
        return carddetailss;
    }

    public void setCarddetailss(String[] carddetailss) {
        this.carddetailss = carddetailss;
    }

    public String[] getBank_accountids() {
        return bank_accountids;
    }

    public void setBank_accountids(String[] bank_accountids) {
        this.bank_accountids = bank_accountids;
    }
    
    
    
}
