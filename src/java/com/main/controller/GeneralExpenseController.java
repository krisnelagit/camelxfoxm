/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package com.main.controller;

import com.main.model.Branch;
import com.main.model.ExpenseArray;
import com.main.model.GeneralExpense;
import com.main.service.AllInsertService;
import com.main.service.AllUpdateService;
import com.main.service.AllViewService;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.context.annotation.PropertySource;
import org.springframework.core.env.Environment;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.ModelAttribute;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.servlet.ModelAndView;

/**
 *
 * @author manish
 */
@Controller
@PropertySource("classpath:keyidconfig.properties")
public class GeneralExpenseController {

    @Autowired
    AllUpdateService updateService;

    @Autowired
    AllViewService viewService;

    @Autowired
    AllInsertService insertService;

    @Autowired
    Environment env;

    @RequestMapping(value = "insertVendorMultiplePayments")
    public String insertVendorMultiplePayments(@ModelAttribute GeneralExpense ge, @RequestParam(value = "expenseid") String podids) {
        String prefix2 = env.getProperty("generalexpense");
        String id = prefix2 + insertService.getmaxcount("generalexpense", "id", 4);
        ge.setId(id);
        ge.setBill_date(ge.getExpense_date());
        double total = Double.parseDouble(ge.getTotal());
        double tax = Double.parseDouble(ge.getTax());
        double taxAmount = total * tax / 100;
        double amount = total - taxAmount;
        ge.setAmount("" + amount);
        ge.setVat_tax("" + taxAmount);
        if (ge.getMode().equals("Cheque")) {
            ge.setTransactionnumber("");
            ge.setTransactiondate("");
            ge.setCarddetails("");
        } else if (ge.getMode().equals("Online")) {
            ge.setChequedate("");
            ge.setChequenumber("");
            ge.setCarddetails("");
        } else if (ge.getMode().equals("Card")) {
            ge.setChequedate("");
            ge.setChequenumber("");
            ge.setTransactionnumber("");
            ge.setTransactiondate("");
        } else {
            ge.setChequedate("");
            ge.setBankname("");
            ge.setChequenumber("");
            ge.setTransactionnumber("");
            ge.setTransactiondate("");
            ge.setCarddetails("");
        }

        insertService.insert(ge);

        //code to update purchase orderdetails here
        String allpodid = podids.replaceAll(",$", "");
        String[] ids = allpodid.split(",");
        for (int i = 0; i < ids.length; i++) {
            updateService.updateanyhqlquery("update purchaseorderdetails set ispaid='Yes' where id='" + ids[i] + "'");
        }
        return "redirect:viewbillGrid";
    }

    @RequestMapping(value = "insertVendorPayments")
    public String insertVendorPayments(@ModelAttribute ExpenseArray ea, @ModelAttribute GeneralExpense ge, @RequestParam(value = "expenseid") List podids) {
        for (int i = 0; i < ea.getAmounts().length; i++) {
            String prefix2 = env.getProperty("generalexpense");
            String id = prefix2 + insertService.getmaxcount("generalexpense", "id", 4);
            ge.setId(id);
            ge.setBill_date(ge.getExpense_date());
            ge.setTotal(ea.getAmounts()[i]);
            double total = Double.parseDouble(ea.getAmounts()[i]);
            double tax = Double.parseDouble(ge.getTax());
            double taxAmount = total * tax / 100;
            double amount = total - taxAmount;
            ge.setAmount("" + amount);
            ge.setVat_tax("" + taxAmount);
            ge.setMode(ea.getModes()[i]);
            ge.setBank_accountid(ea.getBank_accountids()[i]);
            if (ea.getModes()[i].equals("Cheque")) {
                ge.setChequedate(ea.getChequedates()[i]);
                ge.setBankname(ea.getBank_accountids()[i]);
                ge.setChequenumber(ea.getChequenumbers()[i]);
                ge.setTransactionnumber("");
                ge.setTransactiondate("");
                ge.setCarddetails("");
            } else if (ea.getModes()[i].equals("Online")) {
                ge.setChequedate("");
                ge.setBankname(ea.getBank_accountids()[i]);
                ge.setChequenumber("");
                ge.setTransactionnumber(ea.getTransactionnumbers()[i]);
                ge.setTransactiondate(ea.getTransactiondates()[i]);
                ge.setCarddetails("");
            } else if (ea.getModes()[i].equals("Card")) {
                ge.setChequedate("");
                ge.setBankname(ea.getBank_accountids()[i]);
                ge.setChequenumber("");
                ge.setTransactionnumber("");
                ge.setTransactiondate("");
                ge.setCarddetails(ea.getCarddetailss()[i]);
            } else {
                ge.setChequedate("");
                ge.setBankname("");
                ge.setChequenumber("");
                ge.setTransactionnumber("");
                ge.setTransactiondate("");
                ge.setCarddetails("");
            }

            insertService.insert(ge);
        }

        //code to update purchase orderdetails here
        for (int i = 0; i < podids.size(); i++) {
            updateService.updateanyhqlquery("update purchaseorderdetails set ispaid='Yes' where id='" + podids.get(i).toString() + "'");
        }
        return "redirect:viewbillGrid";

    }

    //redirect to create general expense page
    @RequestMapping(value = "createGeneralExpensesLink")
    public ModelAndView createGeneralExpensesLink() {
        ModelAndView modelAndView = new ModelAndView("AddGeneralExpense");
        modelAndView.addObject("taxdtls", viewService.getanyhqldatalist("from taxes where isdelete='No'"));
        modelAndView.addObject("ledgerdtls", viewService.getanyhqldatalist("from ledger where isdelete='No' and ledger_type='expense'"));
        modelAndView.addObject("bankaccountdtls", viewService.getanyhqldatalist("from bank_account where isdelete='No' and id not in ('" + env.getProperty("cashinhand") + "')"));
        modelAndView.addObject("cashaccountdtls", viewService.getanyhqldatalist("from bank_account where id='" + env.getProperty("cashinhand") + "' and isdelete='No'"));
        return modelAndView;
    }

    //redirect to general expenses page
    @RequestMapping(value = "generalExpenseLink")
    public ModelAndView generalExpenseLink() {
        ModelAndView modelAndView = new ModelAndView("ViewGeneralExpenseGrid");
//        modelAndView.addObject("generalexpensedtls", viewService.getanyjdbcdatalist("SELECT ge.*,lg.accountname,ldg.name FROM generalexpense ge\n"
//                + "inner join ledger lg on lg.id=ge.ledgerid\n"
//                + "inner join ledgergroup ldg on ldg.id=lg.ledgergroupid\n"
//                + "where ge.isdelete='No' and ge.isdelete='No'"));

        //nitz mod code begins here
        //get all branch list
        List<Branch> branchList = viewService.getanyhqldatalist("from branch where isdelete='No'");
        List<Map<String, Object>> alldataList = new ArrayList<Map<String, Object>>();
        //code to get part list begin here
        for (int i = 0; i < branchList.size(); i++) {
            String branchPrefix = branchList.get(i).getPurchase_ord_prefix().substring(0, 1);
            System.out.println("Branch prefix: " + branchPrefix);
            List<Map<String, Object>> branchwiseparts = viewService.getanyjdbcdatalist("SELECT ge.*,lg.accountname,ldg.name FROM generalexpense ge\n"
                    + "inner join ledger lg on lg.id=ge.ledgerid\n"
                    + "inner join ledgergroup ldg on ldg.id=lg.ledgergroupid\n"
                    + "where ge.isdelete='No' and lg.isdelete='No' and ldg.isdelete='No' and ge.id like '" + branchPrefix + "%' order by length(ge.id) desc,ge.id desc");
            System.out.println("partdetailsize : " + branchwiseparts.size());
            Map<String, Object> getmap = new HashMap<String, Object>();
            getmap.put("generalexpensedtls", branchwiseparts);
            getmap.put("branchname", branchList.get(i).getName());
            alldataList.add(getmap);
        }
        modelAndView.addObject("branchandpartdetails", alldataList);
        //code to get part list ends! here
        //nitz mod code ends! here
        return modelAndView;
    }

    //redirect to edit expenses details
    @RequestMapping(value = "editExpenseDetails")
    public ModelAndView editExpenseDetails(@RequestParam(value = "expenseid") String expenseid) {
        ModelAndView modelAndView = new ModelAndView("EditGeneralExpense");
        modelAndView.addObject("expensedtls", viewService.getanyjdbcdatalist("SELECT ge.*,lg.accountname,ldg.name FROM generalexpense ge\n"
                + "inner join ledger lg on lg.id=ge.ledgerid\n"
                + "inner join ledgergroup ldg on ldg.id=lg.ledgergroupid\n"
                + "where ge.isdelete='No' and ge.id='" + expenseid + "'").get(0));
        modelAndView.addObject("taxdtls", viewService.getanyhqldatalist("from taxes where isdelete='No'"));
        modelAndView.addObject("ledgerdtls", viewService.getanyhqldatalist("from ledger where isdelete='No' and ledger_type='expense'"));
        modelAndView.addObject("bankaccountdtls", viewService.getanyhqldatalist("from bank_account where isdelete='No' and id not in ('" + env.getProperty("cashinhand") + "')"));
        modelAndView.addObject("cashaccountdtls", viewService.getanyhqldatalist("from bank_account where id='" + env.getProperty("cashinhand") + "' and isdelete='No'"));
//        modelAndView.addObject("bankdtls", viewService.getanyhqldatalist("from bank_account where isdelete='No'"));
        return modelAndView;
    }

    //redirect to view General Expenses details
    @RequestMapping(value = "viewGeneralExpenseDetails")
    public ModelAndView viewGeneralExpenseDetails(@RequestParam(value = "expenseid") String expenseid) {
        ModelAndView modelAndView = new ModelAndView("ViewExpensesDetails");
        modelAndView.addObject("expensesdtls", viewService.getanyjdbcdatalist("SELECT ge.*,lg.accountname,ldg.name,ba.bank_name FROM generalexpense ge\n"
                + "inner join ledger lg on lg.id=ge.ledgerid\n"
                + "inner join ledgergroup ldg on ldg.id=lg.ledgergroupid\n"
                + "left join bank_account ba on ba.id=ge.bank_accountid\n"
                + "where ge.isdelete='No' and ge.id='" + expenseid + "'").get(0));
        return modelAndView;
    }

}
