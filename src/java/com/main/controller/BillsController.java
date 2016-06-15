/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package com.main.controller;

import com.main.model.GeneralExpense;
import com.main.model.PurchaseOrder;
import com.main.model.PurchaseorderDetails;
import com.main.service.AllInsertService;
import com.main.service.AllUpdateService;
import com.main.service.AllViewService;
import java.util.ArrayList;
import java.util.Arrays;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.context.annotation.PropertySource;
import org.springframework.core.env.Environment;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.servlet.ModelAndView;

/**
 *
 * @author manish
 */
@Controller
@PropertySource("classpath:keyidconfig.properties")
public class BillsController {

    @Autowired
    AllUpdateService updateService;

    @Autowired
    AllViewService viewService;

    @Autowired
    AllInsertService insertService;

    @Autowired
    Environment env;

    //show grid of bills for payment\
    @RequestMapping(value = "viewbillGrid")
    public ModelAndView viewbillGrid() {
        ModelAndView modelAndView = new ModelAndView("ViewBillGrid");
        modelAndView.addObject("billdt", viewService.getanyjdbcdatalist("SELECT pod.*,vn.name vendorname,count(pod.expense_billnumber) totalbills,sum(pod.tax_amt+pod.itemtotal)total ,GROUP_CONCAT(pod.id) podetailid,GROUP_CONCAT(DISTINCT pod.purchaseorderid) poid\n"
                + "FROM purchaseorderdetails pod\n"
                + "inner join vendor vn on vn.id=pod.vendorid\n"
                + "where pod.isdelete='No' and pod.ispaid='No' and vn.isdelete='No'\n"
                + "group by  pod.expense_billnumber,pod.vendorid"));
        return modelAndView;
    }

    //code for vendor payment link here 179 288 664 4
    @RequestMapping(value = "makeVendorPaymentLink")
    public ModelAndView makeVendorPaymentLink(@RequestParam(value = "podid") String podid,
            @RequestParam(value = "viz") String viz,
            @RequestParam(value = "poids") String poids) {
        ModelAndView modelAndView = new ModelAndView("ViewPaymentDetails");
        //get branch prefix
        String whichBranchPo = podid.substring(0, 1);
        String allpodid = podid.replaceAll(",$", "");
        String[] ids = allpodid.split(",");
        modelAndView.addObject("amount", viz);
        modelAndView.addObject("poids", poids);
        modelAndView.addObject("podids", podid);
        List<Map<String, Object>> podList = viewService.getanyjdbcdatalist("SELECT pod.*,vn.name as vendorname \n"
                + "FROM purchaseorderdetails pod\n"
                + "inner join vendor vn on vn.id=pod.vendorid\n"
                + "where pod.isdelete='No' and pod.ispaid='No' and vn.isdelete='No' and pod.id='" + ids[0] + "'");
        modelAndView.addObject("expensedtls", podList.get(0));
        modelAndView.addObject("bankaccountdtls", viewService.getanyhqldatalist("from bank_account where isdelete='No' and id not in ('" + env.getProperty("cashinhand") + "')"));
        modelAndView.addObject("cashaccountdtls", viewService.getanyhqldatalist("from bank_account where id='" + env.getProperty("cashinhand") + "' and isdelete='No'"));
        //code for po and total goes here
        //to get tax info code here
        List<String> poid = Arrays.asList(poids.split(","));
        modelAndView.addObject("podt", viewService.getspecifichqldata(PurchaseOrder.class, poid.get(0)));
        modelAndView.addObject("ledgerdtls", viewService.getanyhqldatalist("from ledger where isdelete='No' and ledger_type='expense'"));

        List<Map<String, Object>> podqtyList = new ArrayList<Map<String, Object>>();
        if (whichBranchPo.equals("M")) {
            //code for part details quantity sold not sold goes here

            for (int i = 0; i < ids.length; i++) {
                List<Map<String, Object>> poDetailList = viewService.getanyjdbcdatalist("SELECT inv.sold,inv.sell_qty out_qty, inv.quantity in_qty,cpv.`name` partname,mfg.`name` mfgname  FROM inventory inv\n"
                        + "inner join carpartinfo cpi on cpi.id=inv.partid\n"
                        + "inner join carpartvault cpv on cpv.id=cpi.vaultid\n"
                        + "inner join manufacturer mfg on mfg.id=inv.manufacturerid\n"
                        + "where inv.isdelete='No' and inv.podetailid='" + ids[i] + "'");
                Map<String, Object> setmap = new HashMap<String, Object>();
                setmap.put("sold", poDetailList.get(0).get("sold"));
                setmap.put("out_qty", poDetailList.get(0).get("out_qty"));
                setmap.put("in_qty", poDetailList.get(0).get("in_qty"));
                setmap.put("partname", poDetailList.get(0).get("partname"));
                setmap.put("mfgname", poDetailList.get(0).get("mfgname"));
                podqtyList.add(setmap);
            }
            modelAndView.addObject("podetailsdt", podqtyList);
            modelAndView.addObject("showDetails", "Yes");
        } else {
            for (int i = 0; i < ids.length; i++) {
                List<Map<String, Object>> poDetailList = viewService.getanyjdbcdatalist("SELECT pod.partQuantity qty,pod.itemtotal,cpv.name partname,mfg.name mfgname FROM purchaseorderdetails pod\n"
                        + "inner join carpartinfo cpi on cpi.id=pod.partid\n"
                        + "inner join carpartvault cpv on cpv.id=cpi.vaultid\n"
                        + "inner join manufacturer mfg on mfg.id=pod.manufacturerid\n"
                        + "where pod.isdelete='No' and pod.id='" + ids[i] + "'");
                Map<String, Object> setmap = new HashMap<String, Object>();
                setmap.put("itemtotal", poDetailList.get(0).get("itemtotal"));
                setmap.put("in_qty", poDetailList.get(0).get("qty"));
                setmap.put("partname", poDetailList.get(0).get("partname"));
                setmap.put("mfgname", poDetailList.get(0).get("mfgname"));
                podqtyList.add(setmap);
            }
            modelAndView.addObject("podetailsdt", podqtyList);
            modelAndView.addObject("showDetails", "No");
        }

        return modelAndView;
    }

    //multiple bill payment controller 
    @RequestMapping(value = "multipleBillPayment")
    public ModelAndView multipleBillPayment(@RequestParam(value = "podid") String[] podids,
            @RequestParam(value = "vendorids") List<String> vendorList,
            @RequestParam(value = "billids") String[] billids,
            @RequestParam(value = "poid") String[] poid,
            @RequestParam(value = "total") double[] total) {
        ModelAndView modelAndView = new ModelAndView("AddMultipleBillPayments");
        boolean flag = true;
        String vendorid = vendorList.get(0);
        for (int i = 0; i < vendorList.size(); i++) {
            if (!vendorList.get(i).equals(vendorid)) {
                flag = false;
            }
        }
        if (flag) {
            //code for payment details code goes here
            //total amount code here
            double sum = 0;
            for (double i : total) {
                sum += i;
            }
            //code for payment page details
            String allpodid = podids[0].replaceAll(",$", "");
            String[] ids = allpodid.split(",");
            List<Map<String, Object>> poddt = viewService.getanyjdbcdatalist("SELECT pod.*,vn.name as vendorname \n"
                    + "FROM purchaseorderdetails pod\n"
                    + "inner join vendor vn on vn.id=pod.vendorid\n"
                    + "where pod.isdelete='No' and pod.ispaid='No' and vn.isdelete='No' and pod.id='" + ids[0] + "'");
            modelAndView.addObject("expensedtls", poddt.get(0));
            //code for ledger here
            String allpoid = poid[0].replaceAll(",$", "");
            String[] ids2 = allpoid.split(",");
            modelAndView.addObject("podt", viewService.getspecifichqldata(PurchaseOrder.class, ids2[0]));
            modelAndView.addObject("ledgerdtls", viewService.getanyhqldatalist("from ledger where isdelete='No' and ledger_type='expense'"));
            modelAndView.addObject("amount", sum);
            modelAndView.addObject("bankaccountdtls", viewService.getanyhqldatalist("from bank_account where isdelete='No' and id not in ('" + env.getProperty("cashinhand") + "')"));
            modelAndView.addObject("cashaccountdtls", viewService.getanyhqldatalist("from bank_account where id='" + env.getProperty("cashinhand") + "' and isdelete='No'"));
            //code for po and pod details begins1 here
            StringBuilder sbpodid = new StringBuilder();
            for (String s : podids) {
                sbpodid.append(s);
                sbpodid.append(",");
            }
            StringBuilder sbpoid = new StringBuilder();
            for (String s : poid) {
                sbpoid.append(s);
                sbpoid.append(",");
            }
            StringBuilder sbbillid = new StringBuilder();
            for (String s : billids) {
                sbbillid.append(s);
                sbbillid.append(",");
            }
            modelAndView.addObject("poids", sbpoid);
            modelAndView.addObject("podids", sbpodid);
            modelAndView.addObject("billids", sbbillid);
            //code for po and pod details ends! here     
            //code for part details quanttiy sold not sold goes here
            String sumpodids = "" + sbpodid;

            String sumpodidsd = sbpodid.toString().replaceAll(",$", "");
            String[] idv = sumpodidsd.split(",");
            List<Map<String, Object>> podqtyList = new ArrayList<Map<String, Object>>();
            for (int i = 0; i < idv.length; i++) {
                List<Map<String, Object>> poDetailList = viewService.getanyjdbcdatalist("SELECT inv.sold,inv.sell_qty out_qty, inv.quantity in_qty,cpv.`name` partname,mfg.`name` mfgname  FROM inventory inv\n"
                        + "inner join carpartinfo cpi on cpi.id=inv.partid\n"
                        + "inner join carpartvault cpv on cpv.id=cpi.vaultid\n"
                        + "inner join manufacturer mfg on mfg.id=inv.manufacturerid\n"
                        + "where inv.isdelete='No' and inv.podetailid='" + idv[i] + "'");
                Map<String, Object> setmap = new HashMap<String, Object>();
                setmap.put("sold", poDetailList.get(0).get("sold"));
                setmap.put("out_qty", poDetailList.get(0).get("out_qty"));
                setmap.put("in_qty", poDetailList.get(0).get("in_qty"));
                setmap.put("partname", poDetailList.get(0).get("partname"));
                setmap.put("mfgname", poDetailList.get(0).get("mfgname"));
                podqtyList.add(setmap);
            }
            modelAndView.addObject("podetailsdt", podqtyList);
        } else {
//            modelAndView = new ModelAndView("redirect:viewbillGrid", "errmsg", "Multiple vendors not allowed");
            modelAndView = new ModelAndView("redirect:viewbillGrid", "errmsg", "Yes");
        }
        return modelAndView;
    }

}
