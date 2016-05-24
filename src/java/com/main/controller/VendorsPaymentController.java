/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package com.main.controller;

import com.main.model.GeneralExpense;
import com.main.model.VendorPaymentDto;
import com.main.service.AllInsertService;
import com.main.service.AllUpdateService;
import com.main.service.AllViewService;
import java.util.ArrayList;
import java.util.List;
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
public class VendorsPaymentController {

    @Autowired
    AllUpdateService updateService;

    @Autowired
    AllViewService viewService;

    @Autowired
    AllInsertService insertService;

    @Autowired
    Environment env;

    //redirect to purchase order payment grid cumulative view
    @RequestMapping(value = "VendorPaymentGridLink")
    public ModelAndView VendorPaymentGridLink() {
        ModelAndView modelAndView = new ModelAndView("ViewVendorPaymentGrid");
//        modelAndView.addObject("generalexpensedtls", viewService.getanyjdbcdatalist("SELECT ge.*,lg.accountname,ldg.name FROM generalexpense ge\n"
//                + "inner join ledger lg on lg.id=ge.ledgerid\n"
//                + "inner join ledgergroup ldg on ldg.id=lg.ledgergroupid\n"
//                + "where ge.isdelete='No' and ge.purchaseorderid like '%PO%'"));

        modelAndView.addObject("generalexpensedtls", viewService.getanyjdbcdatalist("SELECT sum( ge.total) totalamount, GROUP_CONCAT( ge.id) geid, GROUP_CONCAT( ge.purchaseorderid) poid, ge.vendorid, ge.towards, ge.`status`, ge.ispaid,lg.accountname,ldg.name groupname\n"
                + "FROM generalexpense ge\n"
                + "inner join ledger lg on lg.id=ge.ledgerid\n"
                + "inner join ledgergroup ldg on ldg.id=lg.ledgergroupid\n"
                + "where  ge.isdelete='No' and ge.purchaseorderid like '%PO%'\n"
                + "group by ge.expense_billnumber and ge.vendorid;"));
//
//        modelAndView.addObject("purchaseorderdt", viewService.getanyjdbcdatalist("SELECT po.*,vn.name as vendorname FROM purchaseorder po\n"
//                + "inner join vendor vn on vn.id=po.vendorid\n"
//                + "where po.isdelete='No' and po.isreceived='Received'"));
        return modelAndView;
    }

    

    //code to save payment
    @RequestMapping(value = "insertVendorPayment")
    public String insertVendorPayment(@ModelAttribute VendorPaymentDto paymentDto,
            @RequestParam(value = "expenseid") String expenseids) {
        String allexpenseids = expenseids.replaceAll(",$", "");
        String[] ids = allexpenseids.split(",");
        for (int i = 0; ids.length > 0 && i < ids.length; i++) {
            if (paymentDto.getMode().equals("Cash")) {
                updateService.updateanyjdbcdatalist("update generalexpense set mode='" + paymentDto.getMode() + "',ispaid='Yes', narration='" + paymentDto.getNarration() + "', bankname='', chequenumber='', chequedate='', transactionnumber='', transactiondate='' where id='" + ids[i] + "'");
            }

            if (paymentDto.getMode().equals("Cheque")) {
                updateService.updateanyjdbcdatalist("update generalexpense set mode='" + paymentDto.getMode() + "',ispaid='Yes', narration='" + paymentDto.getNarration() + "', bankname='" + paymentDto.getBankname() + "', chequenumber='" + paymentDto.getChequenumber() + "', chequedate='" + paymentDto.getChequedate() + "', transactionnumber='', transactiondate='' where id='" + ids[i] + "'");
            }

            if (paymentDto.getMode().equals("Online")) {
                updateService.updateanyjdbcdatalist("update generalexpense set mode='" + paymentDto.getMode() + "',ispaid='Yes', narration='" + paymentDto.getNarration() + "', bankname='', chequenumber='', chequedate='', transactionnumber='" + paymentDto.getTransactionnumber() + "', transactiondate='" + paymentDto.getTransactiondate() + "' where id='" + ids[i] + "'");
            }
        }

        return "redirect:VendorPaymentGridLink";
    }


}
