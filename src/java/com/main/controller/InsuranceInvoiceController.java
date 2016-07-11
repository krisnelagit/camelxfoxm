/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package com.main.controller;

import com.main.model.InsurancePaymentDto;
import com.main.model.Invoice;
import com.main.model.Invoicedetails;
import com.main.model.Jobsheet;
import com.main.model.Taxes;
import com.main.service.AllInsertService;
import com.main.service.AllUpdateService;
import com.main.service.AllViewService;
import java.text.DateFormat;
import java.text.DecimalFormat;
import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.Date;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.core.env.Environment;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.ModelAttribute;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.servlet.ModelAndView;

/**
 *
 * @author nityanand
 */
@Controller
public class InsuranceInvoiceController {

    @Autowired
    AllViewService viewService;

    @Autowired
    AllInsertService insertService;

    @Autowired
    AllUpdateService updateService;

    @Autowired
    Environment env;

    //redirects to View Customer Invoice form page
    @RequestMapping("onlyInsuranceinvoice")
    public ModelAndView onlyInsuranceinvoice() {
        ModelAndView modelAndView = new ModelAndView("ViewInvoiceOfInsurance");
        DateFormat dateFormat = new SimpleDateFormat("yyyy-MM");
        Date date = new Date();
        String month = dateFormat.format(date);
        modelAndView.addObject("currentmonth", month);
        List<Map<String, Object>> dtList = new ArrayList<Map<String, Object>>();

        List<Map<String, Object>> invoicedt = viewService.getanyjdbcdatalist("SELECT inv.*,bd.vehiclename,SUBSTRING(inv.savedate,1,7) as monthcheck,substring_index(inv.savedate,' ',1)as invoicedate,ic.name insurancecompany FROM invoice inv\n"
                + "inner join customer cu on cu.mobilenumber=inv.customermobilenumber\n"
                + "inner join branddetails bd on bd.id=inv.vehicleid\n"
                + "inner join insurance_company ic on ic.id=inv.insurancecompany\n"
                + "where inv.isdelete='No' and cu.isdelete='No' and inv.ispaid='No' order by length(inv.id) desc,inv.id desc");

        for (int i = 0; i < invoicedt.size(); i++) {
            Map<String, Object> setmap = new HashMap<String, Object>();
            setmap.put("invoicedate", invoicedt.get(i).get("invoicedate"));
            setmap.put("invoiceid", invoicedt.get(i).get("invoiceid"));
            setmap.put("customer_name", invoicedt.get(i).get("customer_name"));
            setmap.put("vehiclename", invoicedt.get(i).get("vehiclename"));
            setmap.put("insurancecompany", invoicedt.get(i).get("insurancecompany"));
            setmap.put("vehiclenumber", invoicedt.get(i).get("vehiclenumber"));
            setmap.put("customer_id", invoicedt.get(i).get("customer_id"));
            setmap.put("companytotal", invoicedt.get(i).get("companytotal"));

            List<Map<String, Object>> idList = viewService.getanyjdbcdatalist("SELECT sum(balance) partsum FROM invoicedetails where invoiceid='" + invoicedt.get(i).get("invoiceid") + "'");
            List<Map<String, Object>> sdList = viewService.getanyjdbcdatalist("SELECT sum(balance) servicesum FROM labourinventory where invoiceid='" + invoicedt.get(i).get("invoiceid") + "'");
            double parts, services, result;
            if (idList.get(0).get("partsum") != null) {
                parts = Double.parseDouble(idList.get(0).get("partsum").toString());
            } else {
                parts = 0.0;
            }
            if (sdList.get(0).get("servicesum") != null) {
                services = Double.parseDouble(sdList.get(0).get("servicesum").toString());
            } else {
                services = 0.0;
            }
            result = parts + services;
            setmap.put("balanceamount", result);
            dtList.add(setmap);
        }

        modelAndView.addObject("invoiceListDt", dtList);

        return modelAndView;
    }

//    @RequestMapping(value = "viewInsuranceCompanyPaymentLink")
//    public ModelAndView viewInsuranceCompanyPaymentLink(@RequestParam(value = "invoiceid") String id) {
//        ModelAndView modelAndView = new ModelAndView("ViewInsuranceCompanyPayment");
//
//        return modelAndView;
//    }
    //redirects with data to edit invoice page
    @RequestMapping(value = "viewInsuranceCompanyPaymentLink")
    public ModelAndView editInvoiceDetailsLink(@RequestParam(value = "invoiceid") String invoiceId) {
        ModelAndView modelAndView = new ModelAndView("ViewInsuranceCompanyPayment");
        DecimalFormat df2 = new DecimalFormat(".##");
        //ajax data required for adding data .
        modelAndView.addObject("customers", viewService.getanyhqldatalist("from customer where isdelete<>'Yes'"));
        modelAndView.addObject("vehicles", viewService.getanyhqldatalist("from branddetails where isdelete<>'Yes'"));
        modelAndView.addObject("services", viewService.getanyhqldatalist("from labourservices where isdelete<>'Yes' and id like '" + env.getProperty("branch_prefix") + "%'"));
        modelAndView.addObject("allmfgdata", viewService.getanyhqldatalist("from manufacturer where isdelete<>'Yes'"));
        modelAndView.addObject("insuranceCompanyDetails", viewService.getanyhqldatalist("from insurance_company where isdelete<>'Yes'"));
        List<Taxes> taxList = viewService.getanyhqldatalist("from taxes where isdelete<>'Yes' and id in('LTX1','LTX2')");
        modelAndView.addObject("vatDetails", taxList);

        //invoice data required for getting data
        List<Map<Object, String>> invoicemap = viewService.getanyjdbcdatalist("SELECT iv.*,bd.vehiclename,bd.labourChargeType,ic.id as insurancecompanyid,ic.name as insurancecompanyname  \n"
                + "FROM invoice iv\n"
                + "inner join branddetails bd on bd.id=iv.vehicleid\n"
                + "inner join insurance_company ic on ic.id=iv.insurancecompany\n"
                + "where iv.id='" + invoiceId + "'");
        //code for caclulating liabilities goes here
        List<Map<String, Object>> liabilityList = viewService.getanyjdbcdatalist("SELECT sum(i.insurancecompanyamount) company,sum(i.insurancecustomeramount) customer\n"
                + "FROM invoicedetails i \n"
                + "where i.invoiceid='" + invoiceId + "' and i.isdelete='No'");
        List<Map<String, Object>> laborliabilityList = viewService.getanyjdbcdatalist("SELECT sum(companyinsurance) company,sum(customerinsurance) customer FROM labourinventory\n"
                + "where invoiceid='" + invoiceId + "' and isdelete='No'");

        //code for all part calculations goes here
        DecimalFormat df = new DecimalFormat("####0.00");
        double company, customer, vattax, servicetax, companyresult, customerresult;
        String companyy = "";
        if (liabilityList.get(0).get("company") != null) {
            companyy = liabilityList.get(0).get("company").toString();
        } else {
            companyy = "0";
        }
        company = Double.parseDouble(companyy);
        if (liabilityList.get(0).get("customer") != null) {
            customer = Double.parseDouble(liabilityList.get(0).get("customer").toString());
        } else {
            customer = 0;
        }
        vattax = Double.parseDouble(taxList.get(0).getPercent().toString());
        servicetax = Double.parseDouble(taxList.get(1).getPercent().toString());

        companyresult = company * vattax / 100;
        customerresult = customer * vattax / 100;
        modelAndView.addObject("liabilitypartcompanysum", company);
        modelAndView.addObject("liabilitypartcompany", companyresult + company);
        modelAndView.addObject("liabilitypartcompanytax", companyresult);
        modelAndView.addObject("liabilitypartcustomersum", customer);
        modelAndView.addObject("liabilitypartcustomer", customerresult + customer);
        modelAndView.addObject("liabilitypartcustomertax", customerresult);
        //code for all labor calculations goes here
        if (laborliabilityList.get(0).get("company") != null) {
            company = Double.parseDouble(laborliabilityList.get(0).get("company").toString());
        } else {
            company = 0;
        }
        if (laborliabilityList.get(0).get("customer") != null) {
            customer = Double.parseDouble(laborliabilityList.get(0).get("customer").toString());
        } else {
            customer = 0;
        }
        companyresult = company * servicetax / 100;
        customerresult = customer * servicetax / 100;
        modelAndView.addObject("liabilitylaborcompanysum", company);
        modelAndView.addObject("liabilitylaborcompany", companyresult + company);
        modelAndView.addObject("liabilitylaborcompanytax", companyresult);
        modelAndView.addObject("liabilitylaborcustomersum", customer);
        modelAndView.addObject("liabilitylaborcustomer", customerresult + customer);
        modelAndView.addObject("liabilitylaborcustomertax", customerresult);

        modelAndView.addObject("invoiceDt", invoicemap.get(0));

        //code for final comments here
        if (invoicemap.get(0).get("jobno") != null && !invoicemap.get(0).get("jobno").isEmpty()) {
            String jsid = invoicemap.get(0).get("jobno");
            List<Jobsheet> jobList = viewService.getanyhqldatalist("from jobsheet where id='" + jsid + "'");
            modelAndView.addObject("finalcomments", jobList.get(0).getFinalcomments());
            modelAndView.addObject("deliverydate", jobList.get(0).getDeliverydate());
        }

        //code for ledger begins here 
        modelAndView.addObject("ledgerdt", viewService.getanyhqldatalist("from ledger where isdelete='No' and customerid='" + invoicemap.get(0).get("customer_id") + "' and ledger_type='income'"));
        //code for ledger ends! here 

        String vehicleid = invoicemap.get(0).get("vehicleid");

        List<Map<String, Object>> getparts = viewService.getanyjdbcdatalist("SELECT cpi.*,cpv.name as partname \n"
                + "FROM carpartinfo cpi\n"
                + "left join carpartvault cpv on cpv.id=cpi.vaultid\n"
                + "where branddetailid='" + vehicleid + "'\n"
                + "and cpv.isdelete<>'Yes' and cpi.id like '" + env.getProperty("branch_prefix") + "%'");
        List<Map<String, Object>> jsonlist = new ArrayList<Map<String, Object>>();
        for (int i = 0;
                getparts.size()
                > 0 && i < getparts.size(); i++) {
            Map<String, Object> setjsonmap = new HashMap<String, Object>();
            setjsonmap.put("partname", getparts.get(i).get("partname"));
            setjsonmap.put("id", getparts.get(i).get("id"));
            jsonlist.add(setjsonmap);
        }

        modelAndView.addObject(
                "carparts", jsonlist);

        //normal create k time pe part value code here
        List<Map<String, Object>> partList = new ArrayList<Map<String, Object>>();
        List<Map<String, Object>> partdt = viewService.getanyjdbcdatalist("SELECT i.*,i.partname as itemname,mfg.name as mfgname \n"
                + "FROM invoicedetails i                \n"
                + "left join  carpartinfo cpi on cpi.id=i.partid\n"
                + "left join  carpartvault cpv on cpv.id=cpi.vaultid\n"
                + "left join  manufacturer mfg on mfg.id=i.manufacturerid                \n"
                + "where i.invoiceid='" + invoiceId + "' and i.isdelete='No'");

        for (int i = 0; i < partdt.size(); i++) {
            Map<String, Object> setmap = new HashMap<String, Object>();
            setmap.put("invoicedetailid", partdt.get(i).get("id"));
            setmap.put("itemname", partdt.get(i).get("itemname"));
            setmap.put("mfgname", partdt.get(i).get("mfgname"));
            setmap.put("quantity", partdt.get(i).get("quantity"));
            setmap.put("sellingprice", partdt.get(i).get("sellingprice"));
            setmap.put("insurancepercent", partdt.get(i).get("insurancepercent"));
            setmap.put("insurancecompanyamount", partdt.get(i).get("insurancecompanyamount"));
            setmap.put("isinsurancepaid", partdt.get(i).get("isinsurancepaid"));
            double amount = Double.parseDouble(partdt.get(i).get("insurancecompanyamount").toString());
            double paidamount = Double.parseDouble(partdt.get(i).get("paidamount").toString());
            double balance = Double.parseDouble(partdt.get(i).get("balance").toString());
            if (paidamount > 0) {
                setmap.put("paidamount", df.format(paidamount));
            } else {
                setmap.put("paidamount", 0);
            }
            double taxes = amount * vattax / 100;
            double total = amount + taxes;
            setmap.put("total", df.format(total));            
            setmap.put("balance", df.format(balance)); 
            if (total > 0) {
                partList.add(setmap);
            }
        }
        modelAndView.addObject("labourandpartdt", partList);

        //customer selected labor code set here
        List<Map<String, Object>> serviceList = new ArrayList<Map<String, Object>>();
        List<Map<String, Object>> servicedt = viewService.getanyjdbcdatalist("SELECT *,servicename as name FROM labourinventory\n"
                + "where invoiceid='" + invoiceId + "' and isdelete='No'");

        for (int i = 0; i < servicedt.size(); i++) {
            Map<String, Object> setmap = new HashMap<String, Object>();
            setmap.put("labourdetailid", servicedt.get(i).get("id"));
            setmap.put("name", servicedt.get(i).get("name"));
            setmap.put("description", servicedt.get(i).get("description"));
            setmap.put("serviceinsurancepercent", servicedt.get(i).get("serviceinsurancepercent"));
            setmap.put("paidamount", servicedt.get(i).get("paidamount"));
            double amount = Double.parseDouble(servicedt.get(i).get("companyinsurance").toString());
            double balance = Double.parseDouble(servicedt.get(i).get("balance").toString());
            double paidamount = Double.parseDouble(servicedt.get(i).get("paidamount").toString());
            if (paidamount > 0) {
                setmap.put("paidamount", df.format(paidamount));
            } else {
                setmap.put("paidamount", 0);
            }
            double taxes = amount * servicetax / 100;
            double total = amount + taxes;
            setmap.put("companyinsurance", servicedt.get(i).get("companyinsurance"));
            setmap.put("isinsurancepaid", servicedt.get(i).get("isinsurancepaid"));
            setmap.put("total", df.format(total));
            setmap.put("balance", df.format(balance));
            if (total > 0) {
                serviceList.add(setmap);
            }

        }

        modelAndView.addObject("labourinventorydt", serviceList);
        return modelAndView;
    }

    //insert invoice for insurance payment code begins here
    @RequestMapping(value = "insurancepayment")
    public String insurancepayment(@ModelAttribute InsurancePaymentDto paymentDto) {
        if (paymentDto.getPartid() != null) {
            for (int i = 0; i < paymentDto.getPartid().length; i++) {
                if (paymentDto.getBalance()[i] != 0) {
                    double newbalance = paymentDto.getBalance()[i] - paymentDto.getAmount()[i];
                    if (newbalance <= 0) {
                        updateService.updateanyhqlquery("update invoicedetails set balance='" + newbalance + "',isinsurancepaid='Yes',paidamount='" + paymentDto.getAmount()[i] + "' where id='" + paymentDto.getPartid()[i] + "'");
                    } else {
                        updateService.updateanyhqlquery("update invoicedetails set balance='" + newbalance + "' where id='" + paymentDto.getPartid()[i] + "'");
                    }
                }

            }
        }

        if (paymentDto.getServiceid() != null) {
            for (int i = 0; i < paymentDto.getServiceid().length; i++) {
                if (paymentDto.getServicebalance()[i] != 0) {
                    double newbalance = paymentDto.getServicebalance()[i] - paymentDto.getServiceamount()[i];
                    if (newbalance <= 0) {
                        updateService.updateanyhqlquery("update labourinventory set balance='" + newbalance + "',isinsurancepaid='Yes',paidamount='" + paymentDto.getServiceamount()[i] + "' where id='" + paymentDto.getServiceid()[i] + "'");
                    } else {
                        updateService.updateanyhqlquery("update labourinventory set balance='" + newbalance + "' where id='" + paymentDto.getServiceid()[i] + "'");
                    }
                }
            }
        }

        return "redirect:onlyInsuranceinvoice";
    }
    //insert invoice for insurance payment code ends! here
}
