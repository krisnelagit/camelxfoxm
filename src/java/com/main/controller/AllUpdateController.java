/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package com.main.controller;

import com.google.gson.Gson;
import com.main.model.AllArrayPojo;
import com.main.model.ApprovalLimit;
import com.main.model.BankAccount;
import com.main.model.Branch;
import com.main.model.Brand;
import com.main.model.BrandDetails;
import com.main.model.CarPartInfo;
import com.main.model.CarPartVault;
import com.main.model.CarParts;
import com.main.model.Category;
import com.main.model.CleaningDto;
import com.main.model.ConsumableDetails;
import com.main.model.ConsumableDtoArray;
import com.main.model.Customer;
import com.main.model.CustomerAdvance;
import com.main.model.CustomerVehicles;
import com.main.model.CustomerVehiclesDeatils;
import com.main.model.Enquiries;
import com.main.model.Estimate;
import com.main.model.EstimateDetails;
import com.main.model.EstimateLabourArray;
import com.main.model.Feedback;
import com.main.model.Followups;
import com.main.model.GeneralExpense;
import com.main.model.GeneralIncome;
import com.main.model.Insurance;
import com.main.model.InsuranceCompany;
import com.main.model.Inventory;
import com.main.model.InventoryArray;
import com.main.model.InventoryVendor;
import com.main.model.Invoice;
import com.main.model.InvoiceEdit;
import com.main.model.Invoicedetails;
import com.main.model.Jobsheet;
import com.main.model.JobsheetDetails;
import com.main.model.LabourInventory;
import com.main.model.Manufacturer;
import com.main.model.LabourServices;
import com.main.model.Ledger;
import com.main.model.LedgerGroup;
import com.main.model.PointChecklist;
import com.main.model.PointChecklistDetails;
import com.main.model.PurchaseOrder;
import com.main.model.PurchaseOrderArray;
import com.main.model.PurchaseorderDetails;
import com.main.model.ReminderCustomer;
import com.main.model.TaskBoard;
import com.main.model.Taxes;
import com.main.model.UpdateInventoryArray;
import com.main.model.Vendor;
import com.main.model.VendorPaymentDto;
import com.main.model.Workman;
import com.main.service.AllInsertService;
import com.main.service.AllUpdateService;
import com.main.service.AllViewService;
import java.io.IOException;
import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.Calendar;
import java.util.Date;
import java.util.List;
import java.util.Map;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.context.annotation.PropertySource;
import org.springframework.core.env.Environment;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.ModelAttribute;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.servlet.ModelAndView;

/**
 *
 * @author krisnela
 */
@Controller
@PropertySource("classpath:keyidconfig.properties")
public class AllUpdateController {

    static int tempqty = 0;

    @Autowired
    AllUpdateService updateService;

    @Autowired
    AllViewService viewService;

    @Autowired
    AllInsertService insertService;

    @Autowired
    Environment env;

    //update car parts details
    @RequestMapping(value = "updatecarparts", method = RequestMethod.POST)
    public String updatecarparts(@ModelAttribute CarPartVault carPartVault) {
        updateService.update(carPartVault);
        return "redirect:viewVehicleList";
    }

    //delete any record
    @RequestMapping(value = "deleterecord", method = RequestMethod.POST)
    public @ResponseBody
    String deleterecord(@RequestParam(value = "id") String id, @RequestParam(value = "deskname") String tablename) {
        String query = "update " + tablename + " set isdelete='Yes',modifydate=now() where id='" + id + "'";
        updateService.updateanyhqlquery(query);
        return "true";
    }

    //Confirm estimate
    @RequestMapping(value = "confirmEstimate", method = RequestMethod.POST)
    public @ResponseBody
    String confirmEstimate(@RequestParam(value = "id") String id,
            @RequestParam(value = "deskname") String tablename,
            @RequestParam(value = "values") String values) {
        String query = "update " + tablename + " set confirm_estimate='" + values + "',modifydate=now() where id='" + id + "'";
        updateService.updateanyhqlquery(query);
        return values;
    }

    //delete any record
    @RequestMapping(value = "deleteTransactionrecord", method = RequestMethod.POST)
    public @ResponseBody
    String deleteTransactionrecord(@RequestParam(value = "id") String id,
            @RequestParam(value = "immediateup") String immediateup,
            @RequestParam(value = "idcolumnname") String idcolumnname,
            @RequestParam(value = "deskname") String tablename) {
        String query = "update " + tablename + " set isdelete='Yes',modifydate=now() where id='" + id + "'";
        updateService.updateanyhqlquery(query);
        //code to enable immediate upper table delete 
        List<Map<String, Object>> enableidList = viewService.getanyjdbcdatalist("select * from " + tablename + " where id='" + id + "'");
        updateService.updateanyhqlquery("update " + immediateup + " set enableDelete='Yes',modifydate=now() where id='" + enableidList.get(0).get(idcolumnname) + "'");
        return "true";
    }

    //delete any record
    @RequestMapping(value = "deleteIncomerecord", method = RequestMethod.POST)
    public @ResponseBody
    String deleteIncomerecord(@RequestParam(value = "id") String id, @RequestParam(value = "deskname") String tablename) {

        //code to update from invoice and payment begin here
        List<GeneralIncome> incomeList = viewService.getanyhqldatalist("from generalincome where id='" + id + "' and isdelete='No'");
        if (!incomeList.get(0).getInvoiceid().equals("")) {
            updateService.updateanyhqlquery("update invoice set balanceamount=balanceamount+'" + incomeList.get(0).getTotal() + "', ispaid='No' where id='" + incomeList.get(0).getInvoiceid() + "'");
        }

        //code to update from invoice and payment endS! here
        String query = "update " + tablename + " set isdelete='Yes',modifydate=now() where id='" + id + "'";
        updateService.updateanyhqlquery(query);
        return "true";
    }

    //code to hard delete invoice code goes here
    @RequestMapping(value = "permanentdeleteinvoice")
    public String permanentdeleteinvoice(@RequestParam(value = "id") String id,
            @RequestParam(value = "password") String password,
            HttpSession session) {
        //check first if the username password is correct
        if (password.equals(session.getAttribute("PASSWORD"))) {
            //code to delete from invoice
            String query = "delete from invoice where id='" + id + "'";
            updateService.updateanyhqlquery(query);
            //code to delete from invoice details
            String queryforDetails = "delete from invoicedetails where invoiceid='" + id + "'";
            updateService.updateanyhqlquery(queryforDetails);
            //code to delete from payment
            String paymentquery = "delete from payment where invoiceid='" + id + "'";
            updateService.updateanyhqlquery(paymentquery);
            //code to delete general income
            String generalincomequery = "delete from generalincome where invoiceid='" + id + "'";
            updateService.updateanyhqlquery(generalincomequery);
            return "redirect:paidcustomerinvoice";
        } else {
            return "redirect:paidcustomerinvoice?isexist=Yes";
        }
    }

    //delete invoice record
    @RequestMapping(value = "deleteinvoicerecord", method = RequestMethod.POST)
    public @ResponseBody
    String deleteinvoicerecord(@RequestParam(value = "id") String id,
            @RequestParam(value = "immediateup") String immediateup,
            @RequestParam(value = "idcolumnname") String idcolumnname,
            @RequestParam(value = "deskname") String tablename) {
        //code for customer advance mod begin here 
        List<Map<String, Object>> advanceList = viewService.getanyjdbcdatalist("SELECT cu.id as customerid,bd.brandid,bd.id as branddetailid,gi.total as advanceamount FROM generalincome gi\n"
                + "inner join invoice inv on inv.id=gi.invoiceid\n"
                + "inner join customer cu on cu.mobilenumber=inv.customermobilenumber\n"
                + "inner join branddetails bd on bd.id=inv.vehicleid\n"
                + "where gi.invoiceid='" + id + "' and gi.isdelete='No' and inv.isdelete='No'");

        //insert to customer advance begin here
        for (int i = 0; i < advanceList.size(); i++) {
            CustomerAdvance customerAdvance = new CustomerAdvance();
            String prefix2 = env.getProperty("customer_advance");
            String ids = prefix2 + insertService.getmaxcount("customer_advance", "id", 4);
            customerAdvance.setId(ids);
            customerAdvance.setCustomerid(advanceList.get(i).get("customerid").toString());
            customerAdvance.setBrandid(advanceList.get(i).get("brandid").toString());
            customerAdvance.setBranddetailid(advanceList.get(i).get("branddetailid").toString());
            customerAdvance.setAdvance_amount(Float.parseFloat(advanceList.get(i).get("advanceamount").toString()));
            insertService.insert(customerAdvance);

            //code to update in customermaster regarding this bupdate begin here
            List<Customer> customerlist = viewService.getanyhqldatalist("from customer  where id='" + customerAdvance.getCustomerid() + "'");
            float basicamount = customerlist.get(0).getAdvance_amount();
            float finalamount = basicamount + customerAdvance.getAdvance_amount();
            updateService.updateanyhqlquery("update customer set advance_amount='" + finalamount + "',modifydate=now() where id='" + customerAdvance.getCustomerid() + "'");
        }

        //update the general income it delete entries begin here
        updateService.updateanyhqlquery("update generalincome set isdelete='Yes',modifydate=now() where invoiceid='" + id + "' ");

        //code for customer advance mod ends here 
        //code here deletes invoice 
        String query = "update " + tablename + " set isdelete='Yes',modifydate=now() where id='" + id + "'";
        updateService.updateanyhqlquery(query);
        //code here deletes invoice details
        String queryforDetails = "update invoicedetails set isdelete='Yes',modifydate=now() where invoiceid='" + id + "'";
        updateService.updateanyhqlquery(queryforDetails);

        //code to enable immediate upper table delete 
        List<Map<String, Object>> enableidList = viewService.getanyjdbcdatalist("select * from " + tablename + " where id='" + id + "'");
        if (enableidList.get(0).get(idcolumnname) != null) {
            updateService.updateanyhqlquery("update " + immediateup + " set enableDelete='Yes',modifydate=now() where id='" + enableidList.get(0).get(idcolumnname) + "'");
        }

        return "true";
    }

    //delete any record
    @RequestMapping(value = "deleteAdvanceRecord", method = RequestMethod.POST)
    public void deleteAdvanceRecord(@RequestParam(value = "id") String id, @RequestParam(value = "deskname") String tablename) {
        String query = "update " + tablename + " set isdelete='Yes',modifydate=now() where id='" + id + "'";
        updateService.updateanyhqlquery(query);
    }

    //delete car part records
    @RequestMapping(value = "deletePartRecord", method = RequestMethod.POST)
    public void deletePartRecord(@RequestParam(value = "id") String id, @RequestParam(value = "deskname") String tablename) {
        //delete from car part begin! here
        String query = "update " + tablename + " set isdelete='Yes',modifydate=now() where id='" + id + "'";
        updateService.updateanyhqlquery(query);
        //delete from car part end! here

        //delete from car part info begin! here
        updateService.updateanyhqlquery("update carpartinfo set isdelete='Yes',modifydate=now() where vaultid='" + id + "'");
        //delete from car part info end! here
    }

    //delete inventory record and also update balance qty 
    @RequestMapping(value = "deleteInventoryRecord", method = RequestMethod.POST)
    public void deleteInventoryRecord(@ModelAttribute Inventory i, @RequestParam(value = "id") String id, @RequestParam(value = "partids") String partids, @RequestParam(value = "deskname") String tablename) {
        int temp, tempprevqty, actualQty;
        String query = "update " + tablename + " set isdelete='Yes',modifydate=now() where id='" + id + "'";

        List<Map<String, Object>> prevqty = viewService.getanyjdbcdatalist("Select quantity from inventory where id='" + id + "' and isdelete='No'");
        tempprevqty = Integer.parseInt(prevqty.get(0).get("quantity").toString());

        List<Map<String, Object>> qty = viewService.getanyjdbcdatalist("Select balancequantity from carpartinfo where id='" + partids + "' and isdelete='No'");
        temp = Integer.parseInt(qty.get(0).get("balancequantity").toString());

        actualQty = temp - tempprevqty;

        updateService.updateanyhqlquery("update  carpartinfo  set balancequantity='" + actualQty + "',modifydate=now() where id='" + partids + "'");
        updateService.updateanyhqlquery(query);
    }

    //redirect to edit inventory page with data
    @RequestMapping(value = "editinventory")
    public ModelAndView editinventory(@RequestParam(value = "id") String id) {
        ModelAndView modelAndView = new ModelAndView("EditInventory");
        Inventory i = (Inventory) viewService.getspecifichqldata(Inventory.class, id);
        tempqty = Integer.parseInt(i.getQuantity());
        modelAndView.addObject("invdata", i);
        modelAndView.addObject("manufacturer", viewService.getanyhqldatalist("from manufacturer where isdelete<>'Yes'"));
        modelAndView.addObject("vendor", viewService.getanyhqldatalist("from vendor where isdelete<>'Yes'"));
        modelAndView.addObject("taxdt", viewService.getanyjdbcdatalist("SELECT * from taxes where isdelete<>'Yes' and id not in('LTX2','LTX3','LTX4')"));
        return modelAndView;
    }

    //update inventory details and calculates balanceqty 
    @RequestMapping(value = "updatetinventory", method = RequestMethod.POST)
    public String updatetinventory(@ModelAttribute Inventory i) {
        int a, temp, tempprevqty, actualQty;

        tempprevqty = tempqty;
        List<Map<String, Object>> qty = viewService.getanyjdbcdatalist("Select balancequantity from carpartinfo where id='" + i.getPartid() + "' and isdelete='No'");
        temp = Integer.parseInt(qty.get(0).get("balancequantity").toString());

        actualQty = tempprevqty - temp;
        if (actualQty > Integer.parseInt(i.getQuantity())) {
            a = actualQty + Integer.parseInt(i.getQuantity());
        } else {
            a = Integer.parseInt(i.getQuantity()) - actualQty;
        }

        updateService.update(i);
        updateService.updateanyhqlquery("update  carpartinfo  set balancequantity='" + a + "',modifydate=now() where id='" + i.getPartid() + "'");
        return "redirect:inventoryqty?id=" + i.getPartid() + "";
    }

    // nitya work done
    //update brand
    @RequestMapping("updateBrand")
    public String updateBrand(@ModelAttribute Brand brand) {
        updateService.update(brand);
        return "redirect:brandMasterLink";
    }

    //update ledger group
    @RequestMapping("updateLedgerGroup")
    public String updateLedgerGroup(@ModelAttribute LedgerGroup group) {
        updateService.update(group);
        return "redirect:ledgerGroupMasterLink";
    }

    //update branch
    @RequestMapping("updateBranch")
    public String updateBranch(@ModelAttribute Branch branch) {
        updateService.update(branch);
        return "redirect:branchMasterLink";
    }

    //update brand details
    @RequestMapping("updateCar")
    public String updateCar(@RequestParam(value = "brandname") String brandName, @RequestParam(value = "carname") String[] carNames, @RequestParam(value = "detailid") String[] detailid, @RequestParam(value = "deletedbranddetails", required = false) String deletedbranddetailids, @RequestParam(value = "labourChargeTypes") String[] labourType) {
        BrandDetails brandDetails = new BrandDetails();
        for (int i = 0; i < carNames.length; i++) {
            brandDetails.setId(detailid[i]);
            brandDetails.setBrandid(brandName);
            brandDetails.setVehiclename(carNames[i]);
            brandDetails.setLabourChargeType(labourType[i]);
            updateService.update(brandDetails);
        }

        if (deletedbranddetailids != null && !deletedbranddetailids.isEmpty()) {
            String alldeletedbdids = deletedbranddetailids.replaceAll(",$", "");
            String deletedbdidsArray[] = alldeletedbdids.split(",");
            for (int i = 0; deletedbdidsArray.length > 0 && i < deletedbdidsArray.length; i++) {
                updateService.updateanyhqlquery("update branddetails set isdelete='Yes',modifydate=now() where id='" + deletedbdidsArray[i] + "'");
            }
        }

        return "redirect:brandMasterLink";
    }

    //update vendor details
    @RequestMapping("updateVendor")
    public String updateVendor(@ModelAttribute Vendor vendor) {
        updateService.update(vendor);
        return "redirect:vendorMasterLink";
    }

    //update approval Limit details
    @RequestMapping("editApprovalLimit")
    public String updateApprovalLimit(@ModelAttribute ApprovalLimit approvalLimit) {
        updateService.update(approvalLimit);
        return "redirect:approvalMasterLink";
    }

    @RequestMapping("updateLedgerAccount")
    public String updateLedgerAccount(@ModelAttribute Ledger ledger) {
        updateService.update(ledger);
        return "redirect:ledgerMasterLink";
    }

    //update mfg details
    @RequestMapping("updateMfg")
    public String updateMfg(@ModelAttribute Manufacturer manufacturer) {
        updateService.update(manufacturer);
        return "redirect:mfgMasterLink";
    }

    //update category details
    @RequestMapping("updateCategory")
    public String updateMfg(@ModelAttribute Category category) {
        updateService.update(category);
        return "redirect:categoryMasterLink";
    }

    //update customer details
    @RequestMapping("updateCustomer")
    public String updateCustomer(@ModelAttribute Customer customer) {
        try {
            updateService.update(customer);
            return "redirect:customerMasterLink";
        } catch (Exception e) {
            e.printStackTrace();
            return "redirect:customerMasterLink?isexist=Yes";
        }
    }

    //update Services details
    @RequestMapping("updateServices")
    public String updateServices(@ModelAttribute LabourServices services) {
        updateService.update(services);
        return "redirect:serviceMasterLink";
    }

    //update Tax details
    @RequestMapping("updateTaxes")
    public String updateTaxes(@ModelAttribute Taxes taxes) {
        double comboTax;
        if (taxes.getId().equals("LTX1")) {
            //query to get the value of vat
            List<Taxes> taxpecent = viewService.getanyhqldatalist("from taxes where id='LTX2'");
            comboTax = Double.parseDouble(taxpecent.get(0).getPercent()) + Double.parseDouble(taxes.getPercent());
            //query to update vat+ service tax query executed here
            updateService.updateanyhqlquery("update taxes set percent='" + comboTax + "',modifydate=now() where id='LTX4'");
        } else if (taxes.getId().equals("LTX2")) {
            //query to get the value of servicetax
            List<Taxes> taxpecent = viewService.getanyhqldatalist("from taxes where id='LTX1'");
            comboTax = Double.parseDouble(taxpecent.get(0).getPercent()) + Double.parseDouble(taxes.getPercent());
            //query to update vat+ service tax query executed here
            updateService.updateanyhqlquery("update taxes set percent='" + comboTax + "',modifydate=now() where id='LTX4'");
        }
        updateService.update(taxes);
        return "redirect:taxMasterLink";
    }

    @RequestMapping("deletePartData")
    public @ResponseBody
    String deletePartData(@RequestParam(value = "inventoryid") String inventoryid) {

        String allinventoryids = inventoryid.replaceAll(",$", "");
        String inventoryidsarray[] = allinventoryids.split(",");
        for (int i = 0; inventoryidsarray.length > 0 && i < inventoryidsarray.length; i++) {

            //code to delete from inventory, inventoryvendor, invoicedetails begins! here
            List<InventoryVendor> deleteinVendorList = viewService.getanyhqldatalist("from inventoryvendor where invoicedetailid='" + inventoryidsarray[i] + "' and isdelete='No'");
            for (int j = 0; j < deleteinVendorList.size(); j++) {
                //delete from inventoryvendor
                updateService.updateanyhqlquery("update inventoryvendor set isdelete='Yes' where id='" + deleteinVendorList.get(j).getId() + "'");
                //update quantity revertback
                if (!deleteinVendorList.get(j).getFrom_inventoryid().equals("NA")) {
                    Inventory inventory2 = (Inventory) viewService.getspecifichqldata(Inventory.class, deleteinVendorList.get(j).getFrom_inventoryid());
                    double available = Double.parseDouble(inventory2.getSell_qty());
                    double totalqty = available + Double.parseDouble(deleteinVendorList.get(j).getQuantity());
                    updateService.updateanyhqlquery("update inventory set sold='No',sell_qty='" + totalqty + "',modifydate=now() where id='" + deleteinVendorList.get(j).getFrom_inventoryid() + "'");
                }
                //Delete the entry form inventory table outward.
                updateService.updateanyhqlquery("update inventory set isdelete='Yes',modifydate=now() where id='" + deleteinVendorList.get(j).getTo_inventoryid() + "'");

            }
            //code to delete from inventory, inventoryvendor, invoicedetails ends! here

            List<Invoicedetails> inv = viewService.getanyhqldatalist("from invoicedetails where id='" + inventoryidsarray[i] + "' and isdelete='No'");
            int qty = 0;
            try {
                qty = Integer.parseInt(inv.get(0).getQuantity());
            } catch (Exception e) {
                e.printStackTrace();
            }
            String partid = inv.get(0).getPartid();

            CarPartInfo c = (CarPartInfo) viewService.getspecifichqldata(CarPartInfo.class, partid);
            int avail = Integer.parseInt(c.getBalancequantity());
            int result = avail + qty;

            updateService.updateanyhqlquery("update  carpartinfo  set balancequantity='" + result + "',modifydate=now() where id='" + partid + "'");
            updateService.updateanyhqlquery("update  invoicedetails  set isdelete='yes',modifydate=now() where id='" + inventoryidsarray[i] + "'");
        }
        return "Success";
    }

    @RequestMapping("deleteLabourData")
    public @ResponseBody
    String deleteLabourData(@RequestParam(value = "labourinventoryid") String labourinventoryid) {

        String alllabourinventoryids = labourinventoryid.replaceAll(",$", "");
        String labourinventoryidsarray[] = alllabourinventoryids.split(",");
        for (int i = 0; labourinventoryidsarray.length > 0 && i < labourinventoryidsarray.length; i++) {
            updateService.updateanyhqlquery("update  labourinventory  set isdelete='yes',modifydate=now() where id='" + labourinventoryidsarray[i] + "'");
        }
        return "Success";
    }

    //latest
    @RequestMapping(value = "updateservicechecklist", method = RequestMethod.POST)
    public String updateservicechecklist(@ModelAttribute CustomerVehicles cv, @ModelAttribute CustomerVehiclesDeatils cvd, String cvdid) {
        cvd.setId(cvdid);
        cvd.setCustvehicleid(cv.getId());
        updateService.update(cv);
        updateService.update(cvd);
        return "redirect:service_checklist_grid.html";
    }
    //latest
    //nitz work done

    //12:41 24/04/2015 
    @RequestMapping("update180pointchecklist")
    public String update180pointchecklist(@ModelAttribute PointChecklistDetails pointChecklistDetails, @RequestParam("carpartvaultchecks") String[] carpartvaultchecks, @RequestParam("pointchecklistid") String pointCheckListid, @RequestParam(value = "date") String date180) {
        updateService.updateanyhqlquery("delete from pointchecklistdetails where pointchecklistid = '" + pointChecklistDetails.getPointchecklistid() + "' ");
        updateService.updateanyhqlquery("update pointchecklist set date='" + date180 + "' where id='" + pointCheckListid + "'");
        for (int i = 0; i < carpartvaultchecks.length; i++) {
            String prefix2 = env.getProperty("pointchecklistdetails");
            String id2 = prefix2 + insertService.getmaxcount("pointchecklistdetails", "id", 6);
            pointChecklistDetails.setId(id2);
            pointChecklistDetails.setPointchecklistid(pointCheckListid);
            pointChecklistDetails.setPartlistid(carpartvaultchecks[i]);
            insertService.insert(pointChecklistDetails);
        }
        return "redirect:180pointchecklistgridlink";
    }
//12:41 24/04/2015

    //update workman 
    @RequestMapping(value = "updateWorkman")
    public String updateWorkman(@ModelAttribute Workman workman) {
        updateService.update(workman);
        return "redirect:viewWorkmanLink";
    }

    //add verification / also update jobsheetdetails table
    @RequestMapping(value = "insertverification")
    public String insertVerification(@RequestParam(value = "verifiedids", required = false) String[] verifiedids, 
            @RequestParam(value = "jobno") String jobno, 
            @ModelAttribute CleaningDto cleaningDto, 
            @RequestParam(value = "km_out") String km_out,
            @RequestParam(value = "jvcomments") String jvcomments) {
        boolean flag = true;
        //update km_out if only tha is updated
        if (km_out != null && !km_out.isEmpty()) {
            updateService.updateanyhqlquery("update jobsheet set km_out='" + km_out + "',modifydate=now() where id='" + jobno + "' ");
        }
        if (jvcomments != null && !jvcomments.isEmpty()) {
            updateService.updateanyhqlquery("update jobsheet set jvcomments='" + jvcomments + "',modifydate=now() where id='" + jobno + "' ");
        }
        //checking for the verified task and updating verified as yes when all the ids are verified
        if (verifiedids != null && verifiedids.length > 0) {
            for (int i = 0; i < verifiedids.length; i++) {
                updateService.updateanyhqlquery("update jobsheetdetails set verified='Yes',modifydate=now() where id='" + verifiedids[i] + "'");
                updateService.updateanyhqlquery("update jobsheet set km_out='" + km_out + "',modifydate=now() where id='" + jobno + "' ");
            }
            try {
                List<JobsheetDetails> listverified = viewService.getanyhqldatalist("from jobsheetdetails where jobsheetid='" + jobno + "'");

                for (int i = 0; i < listverified.size() && flag; i++) {
                    if (!listverified.get(i).getVerified().equals("Yes")) {
                        flag = false;
                    }
                }
                if (flag) {
                    updateService.updateanyhqlquery("update jobsheet set verified='Yes', km_out='" + km_out + "',modifydate=now() where id='" + jobno + "' ");
                }
            } catch (Exception e) {
                e.printStackTrace();
            }
        }
        //check if the cleaning is done and update accordingly to jobsheet
        if (cleaningDto.getCar_vacuuming().equals("done")
                && cleaningDto.getCar_washing().equals("done")
                && cleaningDto.getDashboard_polish().equals("done")
                && cleaningDto.getEngine_cleaning().equals("done")
                && cleaningDto.getTrunk_cleaning().equals("done")
                && cleaningDto.getTyre_polish().equals("done")
                && cleaningDto.getUnderchasis_cleaning().equals("done")) {
            updateService.updateanyhqlquery("update jobsheet set cleaning='done',modifydate=now(), car_washing='" + cleaningDto.getCar_washing() + "', car_vacuuming='" + cleaningDto.getCar_vacuuming() + "', tyre_polish='" + cleaningDto.getTyre_polish() + "', dashboard_polish='" + cleaningDto.getDashboard_polish() + "', engine_cleaning='" + cleaningDto.getEngine_cleaning() + "', underchasis_cleaning='" + cleaningDto.getUnderchasis_cleaning() + "', trunk_cleaning='" + cleaningDto.getTrunk_cleaning() + "' where id='" + jobno + "'");
        } else {
            updateService.updateanyhqlquery("update jobsheet set cleaning='not done',modifydate=now(), car_washing='" + cleaningDto.getCar_washing() + "', car_vacuuming='" + cleaningDto.getCar_vacuuming() + "', tyre_polish='" + cleaningDto.getTyre_polish() + "', dashboard_polish='" + cleaningDto.getDashboard_polish() + "', engine_cleaning='" + cleaningDto.getEngine_cleaning() + "', underchasis_cleaning='" + cleaningDto.getUnderchasis_cleaning() + "', trunk_cleaning='" + cleaningDto.getTrunk_cleaning() + "' where id='" + jobno + "'");
        }
        return "redirect:viewJobsheetVerificationGridLink";
    }

    //cleaning list coding here
    @RequestMapping(value = "updateCleaning")
    public String updateCleaning(@RequestParam(value = "id") String id, @RequestParam(value = "cleaning") String cleaningdetail) {
        updateService.updateanyhqlquery("update jobsheet set cleaning='" + cleaningdetail + "',modifydate=now() where id='" + id + "'");
        return "redirect:cleaningListLink";
    }

    //basically updates the johshettdetials table
    @RequestMapping(value = "saveRequisition")
    public String saveRequisition(@RequestParam(value = "jsdid") String[] jsdid,
            @RequestParam(value = "partstatus2") String[] partstatus2,
            @RequestParam(value = "mfgnames") List mfgnames,
            @RequestParam(value = "myjsid") String myjsid,
            @RequestParam(value = "spcomments") String spcomments,
            HttpSession session) {
        if (spcomments!=null) {
            updateService.updateanyhqlquery("update jobsheet set spcomments='" + spcomments + "' where id='" + myjsid + "'");
        }
        
        if (mfgnames.size() > 0) {
            for (int i = 0; i < mfgnames.size(); i++) {
                if (mfgnames.get(i).equals("")) {
                    continue;
                }
                updateService.updateanyhqlquery("update jobsheetdetails set partstatus='" + partstatus2[i] + "',modifydate=now(), mfgid='" + mfgnames.get(i) + "' where id='" + jsdid[i] + "'");
            }
        }
        //code to update main requistion status in jobsheet table begin here
        List<JobsheetDetails> jobDetailList = viewService.getanyhqldatalist("from jobsheetdetails where jobsheetid='" + myjsid + "' and isdelete='No' and itemtype='part'");
        List<JobsheetDetails> assignedJobDetailList = viewService.getanyhqldatalist("from jobsheetdetails where jobsheetid='" + myjsid + "' and isdelete='No' and itemtype='part' and partstatus='assigned'");

        if (jobDetailList.size() == assignedJobDetailList.size()) {
            updateService.updateanyhqlquery("update jobsheet set isrequisitionready='Yes',modifydate=now() where id='" + myjsid + "'");
        }

        //code below is for type spares to update the count in dashboard
        if (session.getAttribute("USERTYPE").equals("spares")) {
            List<Map<String, Object>> requisitionList = viewService.getanyjdbcdatalist("select count(jsd.id) as idcount from jobsheet js\n"
                    + "inner join jobsheetdetails jsd on jsd.jobsheetid=js.id\n"
                    + "where js.isdelete='No' and js.isrequisitionready='No' and jsd.isdelete='No'");
            session.setAttribute("REQUISITIONCOUNT", requisitionList.get(0).get("idcount"));
        }

        return "redirect:viewSpareRequisitionGrid";
    }

    //basically updates the johshettdetials table
    @RequestMapping(value = "updateRequisition")
    public String updateRequisition(@RequestParam(value = "jsdid") String[] jsdid,
            @RequestParam(value = "partstatus2") String[] partstatus2,
            @RequestParam(value = "mfgnames") String[] mfgnames,
            @RequestParam(value = "myjsid") String myjsid,
            @RequestParam(value = "spcomments") String spcomments) {
        if (spcomments!=null) {
            updateService.updateanyhqlquery("update jobsheet set spcomments='"+spcomments+"' where id='"+myjsid+"'");
        }
        
        if (partstatus2.length > 0) {
            for (int i = 0; i < partstatus2.length; i++) {
                updateService.updateanyhqlquery("update jobsheetdetails set partstatus='" + partstatus2[i] + "',modifydate=now(), mfgid='" + mfgnames[i] + "' where id='" + jsdid[i] + "'");
            }
        }
        return "redirect:viewSpareRequisitionGrid";
    }

    //update the estimate
    @RequestMapping(value = "updateEstimate")
    public String updateEstimate(@RequestParam(value = "estdetailids") List estdetailids,
            @ModelAttribute AllArrayPojo aap, @ModelAttribute Estimate estimate,
            @RequestParam(value = "allEstDetailIds", required = false) List allEstDetailIds,
            @RequestParam(value = "comments") String comments,
            @RequestParam(value = "estimateid") String estimateid,
            @ModelAttribute EstimateLabourArray labourArray) {
        //code to update estimate comments
        if (estimateid!=null) {
            updateService.updateanyhqlquery("update estimate set comments='"+comments+"' where id='"+estimateid+"'");
        }
        
        //code to update old part estimate begin here
        if (aap.getEstdetailids().length > 0) {
            for (int i = 0; i < aap.getEstdetailids().length; i++) {
                try {
                    if (aap.getDescription().length > 0 && aap.getDescription()[i] != null && !aap.getDescription()[i].isEmpty()) {
                        updateService.updateanyhqlquery("update estimatedetails set partlistid='" + aap.getPartlistid()[i] + "',modifydate=now(), description='" + aap.getDescription()[i] + "', partrs='" + aap.getPartrs()[i] + "', labourrs='" + aap.getLabourrs()[i] + "', quantity='" + aap.getQuantity()[i] + "', partlistname='" + aap.getPartname()[i] + "', totalpartrs='" + aap.getTotalpartrs()[i] + "' where id='" + aap.getEstdetailids()[i] + "'");
                    } else {
                        updateService.updateanyhqlquery("update estimatedetails set partlistid='" + aap.getPartlistid()[i] + "',modifydate=now(), description='', partrs='" + aap.getPartrs()[i] + "', labourrs='" + aap.getLabourrs()[i] + "', quantity='" + aap.getQuantity()[i] + "', partlistname='" + aap.getPartname()[i] + "', totalpartrs='" + aap.getTotalpartrs()[i] + "' where id='" + aap.getEstdetailids()[i] + "'");
                    }

                } catch (Exception e) {
                    e.printStackTrace();
                }

            }
        }
        //code to update old part estimate ends! here

        //nitz code modified 02-03-2016 begin here
        List<EstimateDetails> edlist = viewService.getanyhqldatalist("from estimate where id='" + estimateid + "' and isjobsheetready='Yes'");
        if (edlist.size() > 0) {
            //update estimate
            List estimatedetailidlist = new ArrayList();
            if (aap.getNewpartlistid() != null) {
                for (int i = 0; i < aap.getNewpartlistid().length; i++) {
                    EstimateDetails e = new EstimateDetails();
                    String prefix2 = env.getProperty("estimatedetails");
                    e.setId(prefix2 + insertService.getmaxcount("estimatedetails", "id", 4));
                    e.setEstimateid(estimateid);
                    e.setPartlistid(aap.getNewpartlistid()[i]);
                    e.setLabourrs(aap.getNewlabourrs()[i]);
                    e.setPartrs(aap.getNewpartrs()[i]);
                    e.setQuantity(aap.getNewquantity()[i]);
                    e.setTotalpartrs(aap.getNewtotalpartrs()[i]);
                    if (aap.getNewdescription().length > 0 && aap.getNewdescription()[i] != null && !aap.getNewdescription()[i].isEmpty()) {
                        e.setDescription(aap.getNewdescription()[i]);
                    } else {
                        e.setDescription("");
                    }
                    e.setItem_type("part");
                    e.setApproval("Yes");
                    e.setPartlistname(aap.getNewpartname()[i]);
                    insertService.insert(e);
                    estimatedetailidlist.add(e.getId());
                }
            }

            List<Jobsheet> jslist = viewService.getanyhqldatalist("from jobsheet where estimateid='" + estimateid + "' and isdelete='No'");
            List<Workman> workmanlist = viewService.getanyhqldatalist("from workman where employee_type='workman' and isdelete='No'");

            for (int i = 0; i < estimatedetailidlist.size(); i++) {
                JobsheetDetails jobsheetDetails = new JobsheetDetails();
                String prefix2 = env.getProperty("jobsheetdetails");
                String id2 = prefix2 + insertService.getmaxcount("jobsheetdetails", "id", 5);
                jobsheetDetails.setId(id2);
                jobsheetDetails.setEstimatedetailid((String) estimatedetailidlist.get(i));
                jobsheetDetails.setJobsheetid(jslist.get(0).getId());
                jobsheetDetails.setWorkmanid(workmanlist.get(0).getId());
                jobsheetDetails.setItemtype("part");
                jobsheetDetails.setEstimatetime(0);
                insertService.insert(jobsheetDetails);
            }

            //insert in jobsheet details
        } else //code to update new part estimate begin here
        {
            if (aap.getNewpartlistid() != null) {
                for (int i = 0; i < aap.getNewpartlistid().length; i++) {
                    EstimateDetails e = new EstimateDetails();
                    String prefix2 = env.getProperty("estimatedetails");
                    e.setId(prefix2 + insertService.getmaxcount("estimatedetails", "id", 4));
                    e.setEstimateid(estimateid);
                    e.setPartlistid(aap.getNewpartlistid()[i]);
                    e.setLabourrs(aap.getNewlabourrs()[i]);
                    e.setPartrs(aap.getNewpartrs()[i]);
                    e.setQuantity(aap.getNewquantity()[i]);
                    e.setTotalpartrs(aap.getNewtotalpartrs()[i]);
                    if (aap.getNewdescription().length > 0 && aap.getNewdescription()[i] != null && !aap.getNewdescription()[i].isEmpty()) {
                        e.setDescription(aap.getNewdescription()[i]);
                    } else {
                        e.setDescription("");
                    }
//                    e.setDescription(aap.getNewdescription()[i]);
                    e.setItem_type("part");
                    e.setPartlistname(aap.getNewpartname()[i]);
                    insertService.insert(e);
                }
            } //code to update new part estimate ends! here        //nitz code modified 02-03-2016 ends! here        //delete part & service code begin here
        }
        for (int i = 0; i < allEstDetailIds.size(); i++) {
            if (!estdetailids.contains(allEstDetailIds.get(i))) {
                updateService.updateanyhqlquery("update estimatedetails set isdelete='Yes',modifydate=now() where id='" + allEstDetailIds.get(i) + "'");
                if (edlist.size() > 0) {
                    //code to update jobsheet detail also about deletion
                    updateService.updateanyhqlquery("update jobsheetdetails set isdelete='Yes',modifydate=now() where estimatedetailid='" + allEstDetailIds.get(i) + "'");
                }
            }
        }
        //delete part & service code ends here

        //code to update old service estimate begin here
        if (labourArray.getServiceid() != null && labourArray.getServiceid().length > 0) {
            for (int i = 0; i < labourArray.getServiceid().length; i++) {
                if (labourArray.getLabourdescription().length > 0 && labourArray.getLabourdescription()[i] != null && !labourArray.getLabourdescription()[i].isEmpty()) {
                    updateService.updateanyhqlquery("update estimatedetails set partlistid='" + labourArray.getServiceid()[i] + "', partlistname='" + labourArray.getServicename()[i] + "', modifydate=now(), description='" + labourArray.getLabourdescription()[i] + "', partrs='0', labourrs='" + labourArray.getServicetotal()[i] + "', quantity='0', totalpartrs='" + labourArray.getServicetotal()[i] + "' where id='" + labourArray.getServiceestdetailids()[i] + "'");
                } else {
                    updateService.updateanyhqlquery("update estimatedetails set partlistid='" + labourArray.getServiceid()[i] + "', partlistname='" + labourArray.getServicename()[i] + "', modifydate=now(), description='', partrs='0', labourrs='" + labourArray.getServicetotal()[i] + "', quantity='0', totalpartrs='" + labourArray.getServicetotal()[i] + "' where id='" + labourArray.getServiceestdetailids()[i] + "'");
                }
            }
        }
        //code to update old service estimate ends! here

        //code to update new service estimate begin here
        if (labourArray.getNewserviceid() != null) {
            for (int i = 0; i < labourArray.getNewserviceid().length; i++) {
                EstimateDetails e = new EstimateDetails();
                String prefix2 = env.getProperty("estimatedetails");
                e.setId(prefix2 + insertService.getmaxcount("estimatedetails", "id", 4));
                e.setEstimateid(estimateid);
                e.setPartlistid(labourArray.getNewserviceid()[i]);
                e.setLabourrs(labourArray.getNewservicetotal()[i]);
                e.setPartrs("0");
                e.setQuantity("0");
                e.setTotalpartrs(labourArray.getNewservicetotal()[i]);
                if (labourArray.getNewlabourdescription().length > 0 && labourArray.getNewlabourdescription()[i] != null && !labourArray.getNewlabourdescription()[i].isEmpty()) {
                    e.setDescription(labourArray.getNewlabourdescription()[i]);
                } else {
                    e.setDescription("");
                }
                e.setItem_type("service");
                e.setPartlistname(labourArray.getNewservicename()[i]);
                insertService.insert(e);
            }
        }
        //code to update new service estimate ends! here

        return "redirect:estimate";
    }

    //update jobsheet
    @RequestMapping(value = "updateWorkmanJob")
    public String updateWorkmanJob(@RequestParam(value = "estimatedtime") float[] estimatedtime,
            @RequestParam(value = "workmen") String[] workmenids,
            @RequestParam(value = "jsdid") String[] jsdids,
            @RequestParam(value = "jobno") String jobno,
            @RequestParam(value = "jobsheetcomments") String jobsheetcomments) {
        //code to update jobsheet table goes here
        if (jobsheetcomments!=null) {
            updateService.updateanyhqlquery("update jobsheet set jobsheetcomments='" + jobsheetcomments + "' where id='" + jobno + "'");
        }
        
        updateService.updateanyhqlquery("delete from taskboard where jobsheetid='" + jobno + "'");

        for (int i = 0; i < jsdids.length; i++) {
            updateService.updateanyhqlquery("update jobsheetdetails set workmanid='" + workmenids[i] + "',modifydate=now(), estimatetime='" + estimatedtime[i] + "' where id='" + jsdids[i] + "'");
        }

        List<Map<String, Object>> taskrelated = viewService.getanyjdbcdatalist("SELECT jsd.id,jsd.workmanid,wm.name,sum(jsd.estimatetime) as totalestimatetime FROM jobsheetdetails jsd\n"
                + "inner join workman wm on wm.id=jsd.workmanid\n"
                + "where jsd.jobsheetid='" + jobno + "'\n"
                + "group by jsd.workmanid");

        TaskBoard taskBoard = new TaskBoard();
        try {
            for (int i = 0; i < taskrelated.size(); i++) {
                String prefix2 = env.getProperty("taskboard");
                String id3 = prefix2 + insertService.getmaxcount("taskboard", "id", 5);
                taskBoard.setId(id3);
                taskBoard.setJobsheetid(jobno);
                taskBoard.setWorkmanid(taskrelated.get(i).get("workmanid").toString());
                taskBoard.setEstimatetime(taskrelated.get(i).get("totalestimatetime").toString());
                taskBoard.setTimeconsumed("0");
                insertService.insert(taskBoard);
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return "redirect:viewJobsheetGridLink";
    }

    @RequestMapping(value = "playtask", method = RequestMethod.POST)
    public void playtask(@RequestParam(value = "id") String id, @RequestParam(value = "status") String status, @RequestParam(value = "starttime") String starttime, HttpServletResponse response) throws IOException {
        List<TaskBoard> tasklist = viewService.getanyhqldatalist("from taskboard where id='" + id + "'");
        if (tasklist.get(0).getElapsed() == null) {
            updateService.updateanyhqlquery("update taskboard set starttime='" + starttime + "' ,status='" + status + "',modifydate=now() where id='" + id + "' ");
        }

        if (tasklist.get(0).getStatus() != null && tasklist.get(0).getStatus().equals("pause")) {
            updateService.updateanyhqlquery("update taskboard set starttime='" + starttime + "' ,status='" + status + "', elapsed='0',modifydate=now() where id='" + id + "' ");
        }
        String responseStatus = "";

        if (tasklist.get(0).getStatus() != null && tasklist.get(0).getStatus().equals("stop")) {
            responseStatus = "stop";
        }

        responseStatus = new Gson().toJson(responseStatus);
        response.setContentType("application/json");
        response.setCharacterEncoding("UTF-8");
        response.getWriter().write(responseStatus);
    }

    @RequestMapping(value = "pausetask", method = RequestMethod.POST)
    public void pausetask(@RequestParam(value = "id") String id, @RequestParam(value = "status") String status, @RequestParam(value = "endtime") String endtime, HttpServletResponse response) throws IOException {
        List<TaskBoard> tasklist = viewService.getanyhqldatalist("from taskboard where id='" + id + "'");
        String responseStatus = "";
        long totalelapsedtime = 0;
        String elapsedtime = "";

        if (tasklist.get(0).getStatus() != null && tasklist.get(0).getStatus().isEmpty()) {
            String dateStart = tasklist.get(0).getStarttime();

            SimpleDateFormat format = new SimpleDateFormat("HH:mm");

            Date d1 = null;
            Date d2 = null;

            try {
                d1 = format.parse(dateStart);
                d2 = format.parse(endtime);

                long diff = d2.getTime() - d1.getTime();
                long diffMinutes = diff / (60 * 1000) % 60;
                long diffHours = diff / (60 * 60 * 1000) % 24;

                long hourmin = diffHours * 60;

                long finaltime = hourmin + diffMinutes;

                updateService.updateanyhqlquery("update taskboard set endtime='" + endtime + "' ,status='" + status + "' ,modifydate=now(),elapsed='" + finaltime + "', timeconsumed='" + finaltime + "' where id='" + id + "' ");

            } catch (Exception e) {
            }

        }

        if (tasklist.get(0).getStatus().equals("play")) {
            String dateStart = tasklist.get(0).getStarttime();

            SimpleDateFormat format = new SimpleDateFormat("HH:mm");

            Date d1 = null;
            Date d2 = null;

            try {
                d1 = format.parse(dateStart);
                d2 = format.parse(endtime);

                long diff = d2.getTime() - d1.getTime();
                long diffMinutes = diff / (60 * 1000) % 60;
                long diffHours = diff / (60 * 60 * 1000) % 24;

                long timetaken = Long.parseLong(tasklist.get(0).getTimeconsumed());
                long hourmin = diffHours * 60;

                totalelapsedtime = hourmin + diffMinutes;

                long totalfinaltime = totalelapsedtime + timetaken;

                updateService.updateanyhqlquery("update taskboard set endtime='" + endtime + "' ,modifydate=now(),status='" + status + "' ,elapsed='" + totalelapsedtime + "', timeconsumed='" + totalfinaltime + "' where id='" + id + "' ");
                List<TaskBoard> taskList = viewService.getanyhqldatalist("from taskboard where id='" + id + "'");
                elapsedtime = taskList.get(0).getTimeconsumed();

            } catch (Exception e) {
            }
        }

        if (tasklist.get(0).getStatus().equals("stop")) {
            responseStatus = "stop";
        }

        responseStatus = new Gson().toJson(responseStatus + "," + elapsedtime);
        response.setContentType("application/json");
        response.setCharacterEncoding("UTF-8");
        response.getWriter().write(responseStatus);
    }

    @RequestMapping(value = "showtaskdetail")
    public @ResponseBody
    String showtaskdetail(@RequestParam(value = "jobid") String jobid, @RequestParam(value = "id") String id, @RequestParam(value = "status") String status, @RequestParam(value = "endtime") String endtime) {

        List<TaskBoard> tasklist = viewService.getanyhqldatalist("from taskboard where id='" + id + "'");

        if (tasklist.get(0).getStatus() != null && tasklist.get(0).getStatus().isEmpty()) {
            String dateStart = tasklist.get(0).getStarttime();

            SimpleDateFormat format = new SimpleDateFormat("HH:mm");

            Date d1 = null;
            Date d2 = null;

            try {
                d1 = format.parse(dateStart);
                d2 = format.parse(endtime);

                long diff = d2.getTime() - d1.getTime();
                long diffMinutes = diff / (60 * 1000) % 60;
                long diffHours = diff / (60 * 60 * 1000) % 24;

                long hourmin = diffHours * 60;

                long finaltime = hourmin + diffMinutes;

                updateService.updateanyhqlquery("update taskboard set endtime='" + endtime + "' ,modifydate=now(),status='" + status + "' ,elapsed='" + finaltime + "', timeconsumed='" + finaltime + "' where id='" + id + "' ");

                return "" + finaltime;

            } catch (Exception e) {
                e.printStackTrace();
            }

        }

        if (tasklist.get(0).getStatus().equals("play")) {
            String dateStart = tasklist.get(0).getStarttime();

            SimpleDateFormat format = new SimpleDateFormat("HH:mm");

            Date d1 = null;
            Date d2 = null;

            try {
                d1 = format.parse(dateStart);
                d2 = format.parse(endtime);

                long diff = d2.getTime() - d1.getTime();
                long diffMinutes = diff / (60 * 1000) % 60;
                long diffHours = diff / (60 * 60 * 1000) % 24;

                long timetaken = Long.parseLong(tasklist.get(0).getTimeconsumed());
                long hourmin = diffHours * 60;

                long totalelapsedtime = hourmin + diffMinutes;

                long totalfinaltime = totalelapsedtime + timetaken;

                updateService.updateanyhqlquery("update taskboard set endtime='" + endtime + "' ,modifydate=now(),status='" + status + "' ,elapsed='" + totalelapsedtime + "', timeconsumed='" + totalfinaltime + "' where id='" + id + "' ");
                //check for the task completion
                List<TaskBoard> taskBoardList = viewService.getanyhqldatalist("from taskboard where jobsheetid='" + jobid + "'");
                int stopCount = 0;
                for (int i = 0; i < taskBoardList.size(); i++) {
                    if (taskBoardList.get(i).getStatus() != null && !taskBoardList.get(i).getStatus().isEmpty()) {
                        if (taskBoardList.get(i).getStatus().equals("stop")) {
                            stopCount++;
                            System.out.println("nityanand checking task count" + stopCount);
                        }
                    }
                }
                if (taskBoardList.size() == stopCount) {
                    updateService.updateanyhqlquery("update jobsheet set istaskcompleted='Yes',modifydate=now() where id='" + jobid + "'");
                }
                //end of checking task completion
                return "" + totalfinaltime;

            } catch (Exception e) {
                e.printStackTrace();
            }
        }

        if (tasklist.get(0).getStatus().equals("pause") || tasklist.get(0).getStatus().equals("play")) {
            updateService.updateanyhqlquery("update taskboard set status='stop',modifydate=now() where id='" + id + "'");
            //check for the task completion
            List<TaskBoard> taskBoardList = viewService.getanyhqldatalist("from taskboard where jobsheetid='" + jobid + "'");
            int stopCount = 0;
            for (int i = 0; i < taskBoardList.size(); i++) {
                if (taskBoardList.get(i).getStatus() != null && !taskBoardList.get(i).getStatus().isEmpty()) {
                    if (taskBoardList.get(i).getStatus().equals("stop")) {
                        stopCount++;
                        System.out.println("nityanand checking task count" + stopCount);
                    }
                }
            }
            if (taskBoardList.size() == stopCount) {
                updateService.updateanyhqlquery("update jobsheet set istaskcompleted='Yes',modifydate=now() where id='" + jobid + "'");
            }
            //end of checking task completion
            return "" + tasklist.get(0).getTimeconsumed();
        }
        return "";
    }

    //======================CRMUPDATES=====================
    //update lead
    @RequestMapping(value = "updateLead")
    public String updateLead(@ModelAttribute Enquiries enquiries) {
        updateService.update(enquiries);
        return "redirect:enquiriesgridlink";
    }

    //update followups
    @RequestMapping(value = "updateFollowUp")
    public String updatefollowup(@ModelAttribute Followups followups) {
        updateService.update(followups);
        return "redirect:followupgridlink";
    }

    //update Appointment date
    @RequestMapping(value = "updateAppointmentDate", method = RequestMethod.POST)
    public void updateAppointmentDate(@RequestParam(value = "datetime") String datetime, @RequestParam(value = "apid") String apid, HttpServletResponse response) {
        updateService.updateanyhqlquery("update appointment set datetime='" + datetime + "',modifydate=now() where id='" + apid + "'");
    }

    //update insurance exprinig
    @RequestMapping(value = "updateInsuranceExpiring")
    public String updateInsuranceExpiring(@ModelAttribute Insurance insurance) {
        updateService.update(insurance);
        return "redirect:viewInsuranceExpiringGridLink";
    }

    //============crmend==========================
    //=========enxpense begin=====================
    @RequestMapping(value = "editPurchaseOrder")
    public String editPurchaseOrder(@RequestParam(value = "oldsparepartsfinal") float oldsparesfinal, @RequestParam(value = "oldpodsid", required = false) List oldpodids, @RequestParam(value = "allpodids") List allOldPodIds, @ModelAttribute PurchaseOrder purchaseOrder, @ModelAttribute PurchaseorderDetails purchaseorderDetails, @ModelAttribute PurchaseOrderArray purchaseOrderArray) {
        String limit = env.getProperty("purchase_order_limit");
        List<ApprovalLimit> limitdtls = viewService.getanyhqldatalist("from approvallimit where id='" + limit + "'");
        if (Float.parseFloat(purchaseOrder.getFinaltotal()) <= Float.parseFloat(limitdtls.get(0).getAmount().toString())) {
            purchaseOrder.setStatus("Approved");
            purchaseOrder.setSubadminapproval("Approved");
            purchaseOrder.setAcceptance("Approved");
        } else {
            purchaseOrder.setStatus("Pending");
            purchaseOrder.setSubadminapproval("Pending");
            purchaseOrder.setAcceptance("Pending");
        }
        purchaseOrder.setSparepartsfinal(oldsparesfinal);
        purchaseOrder.setBalance(purchaseOrder.getFinaltotal());
        updateService.update(purchaseOrder);

        //code to update old entry in podetails 
        for (int i = 0; purchaseOrderArray.getOldpodsid() != null && i < purchaseOrderArray.getOldpodsid().length; i++) {
            purchaseorderDetails.setId(purchaseOrderArray.getOldpodsid()[i]);
            purchaseorderDetails.setBranddetailid(purchaseOrderArray.getOldbranddetailid()[i]);
            purchaseorderDetails.setPartid(purchaseOrderArray.getOldpartid()[i]);
            purchaseorderDetails.setManufacturerid(purchaseOrderArray.getOldmanufacturerid()[i]);
            purchaseorderDetails.setPartQuantity(purchaseOrderArray.getOldpartQuantity()[i]);
            purchaseorderDetails.setCostprice(purchaseOrderArray.getOldcostprice()[i]);
            purchaseorderDetails.setSellingprice(purchaseOrderArray.getOldsellingprice()[i]);
            purchaseorderDetails.setItemtotal(purchaseOrderArray.getOlditemtotal()[i]);
            purchaseorderDetails.setPurchaseorderid(purchaseOrder.getId());
            purchaseorderDetails.setVendorid(purchaseOrder.getVendorid());
            //tax calculation code begins! here
            double tax = Double.parseDouble(purchaseOrder.getTax());
            double amount = Double.parseDouble(purchaseOrderArray.getOlditemtotal()[i]);
            double taxamount = amount * tax / 100;
            purchaseorderDetails.setTax_amt("" + taxamount);
            //tax calculation code ends! here        
            updateService.update(purchaseorderDetails);
        }

        //code to add new entry in podetails
        if (purchaseOrderArray.getPartid() != null) {
            for (int i = 0; i < purchaseOrderArray.getPartid().length; i++) {
                String prefix2 = env.getProperty("purchaseorderdetails");
                String id2 = prefix2 + insertService.getmaxcount("purchaseorderdetails", "id", 5);
                purchaseorderDetails.setId(id2);
                purchaseorderDetails.setBranddetailid(purchaseOrderArray.getBranddetailid()[i]);
                purchaseorderDetails.setPartid(purchaseOrderArray.getPartid()[i]);
                purchaseorderDetails.setManufacturerid(purchaseOrderArray.getManufacturerid()[i]);
                purchaseorderDetails.setPartQuantity(purchaseOrderArray.getPartQuantity()[i]);
                purchaseorderDetails.setItemtotal(purchaseOrderArray.getItemtotal()[i]);
                purchaseorderDetails.setCostprice(purchaseOrderArray.getCostprice()[i]);
                purchaseorderDetails.setSellingprice(purchaseOrderArray.getSellingprice()[i]);
                purchaseorderDetails.setPurchaseorderid(purchaseOrder.getId());
                purchaseorderDetails.setVendorid(purchaseOrder.getVendorid());
                //tax calculation code begins! here
                double tax = Double.parseDouble(purchaseOrder.getTax());
                double amount = Double.parseDouble(purchaseOrderArray.getItemtotal()[i]);
                double taxamount = amount * tax / 100;
                purchaseorderDetails.setTax_amt("" + taxamount);
                //tax calculation code ends! here        
                insertService.insert(purchaseorderDetails);
            }
        }

        for (int i = 0; i < allOldPodIds.size(); i++) {
            if (!oldpodids.contains(allOldPodIds.get(i))) {
                updateService.updateanyhqlquery("update purchaseorderdetails set isdelete='Yes',modifydate=now() where id='" + allOldPodIds.get(i) + "'");
            }
        }

        return "redirect:PurchaseOrderGridLink";
    }

    //general expense edit 
    @RequestMapping(value = "editGeneralExpense")
    public String editGeneralExpense(@ModelAttribute GeneralExpense generalExpense,
            @RequestParam(value = "oldmode") String oldmode,
            @RequestParam(value = "tax_amount", required = false) String tax_amount,
            @RequestParam(value = "vattax", required = false) String vattax,
            @RequestParam(value = "servicetax", required = false) String servicetax) {
        //fetching limit information from limit approvals table
        String limit = env.getProperty("general_expense_limit");
        List<ApprovalLimit> limitdtls = viewService.getanyhqldatalist("from approvallimit where id='" + limit + "'");
        if (Float.parseFloat(generalExpense.getTotal()) <= Float.parseFloat(limitdtls.get(0).getAmount())) {
            generalExpense.setStatus("Approved");
            generalExpense.setSubadminapproval("Approved");
            generalExpense.setAcceptance("Approved");
        } else {
            generalExpense.setStatus("Pending");
            generalExpense.setSubadminapproval("Pending");
            generalExpense.setAcceptance("Pending");
        }
        //if it is from po ie; bill number set approved for all -sir 06-05-2016
        if (generalExpense.getExpense_billnumber() != null && !generalExpense.getExpense_billnumber().isEmpty()) {
            generalExpense.setStatus("Approved");
            generalExpense.setSubadminapproval("Approved");
            generalExpense.setAcceptance("Approved");
        }
        //-end! of fetching .status set.

        //coding regarding the tax begin here
        if (generalExpense.getTax_applicable().equals("N/A")) {
            generalExpense.setTax("0");
            generalExpense.setTaxid("LTX3");
            generalExpense.setVat_tax("0");
            generalExpense.setService_tax("0");
            generalExpense.setVat_service_tax("0");
            generalExpense.setTotal(generalExpense.getAmount());
        }

        //code for handling the tax type begin here
        if (generalExpense.getTaxid().equals("LTX1")) {
            generalExpense.setVat_tax(tax_amount);
        } else if (generalExpense.getTaxid().equals("LTX2")) {
            generalExpense.setService_tax(tax_amount);
        } else if (generalExpense.getTaxid().equals("LTX3")) {
            generalExpense.setVat_tax("0");
            generalExpense.setService_tax("0");
            generalExpense.setVat_service_tax("0");
        } else if (generalExpense.getTaxid().equals("LTX4")) {
            generalExpense.setVat_tax(vattax);
            generalExpense.setService_tax(servicetax);
            generalExpense.setVat_service_tax(tax_amount);
        }
        //code for handling the tax type end! here
        //coding regarding the tax end! here
        if (oldmode.equals(generalExpense.getMode())) {
            updateService.update(generalExpense);
        } else {
            if (oldmode.equals("Online")) {
                generalExpense.setTransactionnumber("");
                generalExpense.setTransactiondate("");
                updateService.updateanyhqlquery("update generalexpense set transactionnumber='', transactiondate='',modifydate=now() where id='" + generalExpense.getId() + "' ");
            }

            if (oldmode.equals("Cheque")) {
                generalExpense.setBankname("");
                generalExpense.setChequedate("");
                generalExpense.setChequenumber("");
                updateService.updateanyhqlquery("update generalexpense set chequenumber='', bankname='',modifydate=now(), chequedate='' where id='" + generalExpense.getId() + "' ");
            }
            updateService.update(generalExpense);
        }

        return "redirect:viewGeneralExpenseDetails?expenseid=" + generalExpense.getId();
    }

    //general expense edit 
    @RequestMapping(value = "updateVendorPaymentExpense")
    public String updateVendorPaymentExpense(@ModelAttribute VendorPaymentDto paymentDto, @RequestParam(value = "oldmode") String oldmode) {

        if (paymentDto.getMode().equals("Cash")) {
            updateService.updateanyjdbcdatalist("update generalexpense set mode='" + paymentDto.getMode() + "', narration='" + paymentDto.getNarration() + "', bankname='', chequenumber='', chequedate='', transactionnumber='', transactiondate='' where id='" + paymentDto.getId() + "'");
        }

        if (paymentDto.getMode().equals("Cheque")) {
            updateService.updateanyjdbcdatalist("update generalexpense set mode='" + paymentDto.getMode() + "', narration='" + paymentDto.getNarration() + "', bankname='" + paymentDto.getBankname() + "', chequenumber='" + paymentDto.getChequenumber() + "', chequedate='" + paymentDto.getChequedate() + "', transactionnumber='', transactiondate='' where id='" + paymentDto.getId() + "'");
        }

        if (paymentDto.getMode().equals("Online")) {
            updateService.updateanyjdbcdatalist("update generalexpense set mode='" + paymentDto.getMode() + "', narration='" + paymentDto.getNarration() + "', bankname='', chequenumber='', chequedate='', transactionnumber='" + paymentDto.getTransactionnumber() + "', transactiondate='" + paymentDto.getTransactiondate() + "' where id='" + paymentDto.getId() + "'");
        }

        return "redirect:VendorPaymentGridLink";
    }

    //expense approval of purchase order by admin
    @RequestMapping(value = "addApprovalStatus")
    public String addApprovalStatus(@RequestParam(value = "id") String id, @RequestParam(value = "status") String status, HttpSession session) {

        //code to approve by super admin and sub admin changes begin here
        if (session.getAttribute("USERTYPE").equals("admin") && status.equals("Approved")) {
            updateService.updateanyhqlquery("update purchaseorder set status='" + status + "',acceptance='" + status + "', modifydate=now() where id='" + id + "'");
        } else if (session.getAttribute("USERTYPE").equals("admin") && status.equals("Not approved")) {
            updateService.updateanyhqlquery("update purchaseorder set status='" + status + "',acceptance='" + status + "',modifydate=now() where id='" + id + "'");
        } else {
            List<PurchaseOrder> poList = viewService.getanyhqldatalist("from purchaseorder  where id='" + id + "'");
            if (poList.get(0).getSubadminapproval().equals("Approved") && status.equals("Approved")) {
                updateService.updateanyhqlquery("update purchaseorder set status='" + status + "',acceptance='" + status + "',modifydate=now() where id='" + id + "'");
            }

            if (poList.get(0).getSubadminapproval().equals("Not approved") && status.equals("Not approved")) {
                updateService.updateanyhqlquery("update purchaseorder set status='" + status + "',acceptance='" + status + "',modifydate=now() where id='" + id + "'");
            }

            if (poList.get(0).getSubadminapproval().equals("Pending") && status.equals("Pending")) {
                updateService.updateanyhqlquery("update purchaseorder set status='" + status + "',acceptance='Pending',modifydate=now() where id='" + id + "'");
            }

            if (poList.get(0).getSubadminapproval().equals("Pending") && status.equals("Approved") || poList.get(0).getSubadminapproval().equals("Approved") && status.equals("Pending") || poList.get(0).getSubadminapproval().equals("Not approved") && status.equals("Pending") || poList.get(0).getSubadminapproval().equals("Pending") && status.equals("Not approved") || poList.get(0).getSubadminapproval().equals("Not approved") && status.equals("Approved") || poList.get(0).getSubadminapproval().equals("Approved") && status.equals("Not approved")) {
                updateService.updateanyhqlquery("update purchaseorder set status='" + status + "',acceptance='Pending',modifydate=now() where id='" + id + "'");
            }
        }

        return "redirect:purchaseorderappovalsLink";
    }

    //approval of purchase order by admin
    @RequestMapping(value = "addsubApprovalStatus")
    public String addsubApprovalStatus(@RequestParam(value = "id") String id, @RequestParam(value = "status") String status) {
        List<PurchaseOrder> poList = viewService.getanyhqldatalist("from purchaseorder  where id='" + id + "'");
        if (poList.get(0).getStatus().equals("Approved") && status.equals("Approved") || poList.get(0).getStatus().equals("Approved") && status.equals("Not approved") || poList.get(0).getStatus().equals("Approved") && status.equals("Pending") || poList.get(0).getStatus().equals("Pending") && status.equals("Approved") || poList.get(0).getStatus().equals("Not approved") && status.equals("Approved")) {
            updateService.updateanyhqlquery("update purchaseorder set subadminapproval='" + status + "',modifydate=now() where id='" + id + "'");
        }

        if (poList.get(0).getStatus().equals("Not approved") && status.equals("Not approved") || poList.get(0).getStatus().equals("Pending") && status.equals("Not approved")) {
            updateService.updateanyhqlquery("update purchaseorder set subadminapproval='" + status + "',modifydate=now() where id='" + id + "'");
        }

        if (poList.get(0).getStatus().equals("Pending") && status.equals("Pending")) {
            updateService.updateanyhqlquery("update purchaseorder set subadminapproval='" + status + "',modifydate=now() where id='" + id + "'");
        }

        if (poList.get(0).getStatus().equals("Not approved") && status.equals("Pending")) {
            updateService.updateanyhqlquery("update purchaseorder set subadminapproval='" + status + "',modifydate=now() where id='" + id + "'");
        }

        return "redirect:purchaseorderappovalsLink";
    }

    //expense approval of purchase order by admin
    @RequestMapping(value = "addGEApprovalStatus")
    public String addGEApprovalStatus(@RequestParam(value = "id") String id, @RequestParam(value = "status") String status, HttpSession session) {

        //code to get approved if approved by super admin begin here
        if (session.getAttribute("USERTYPE").equals("admin") && status.equals("Approved")) {
            updateService.updateanyhqlquery("update generalexpense set status='" + status + "', acceptance='" + status + "', modifydate=now() where id='" + id + "'");
        } else if (session.getAttribute("USERTYPE").equals("admin") && status.equals("Not approved")) {
            updateService.updateanyhqlquery("update generalexpense set status='" + status + "', acceptance='" + status + "', modifydate=now() where id='" + id + "'");
        } else {
            List<GeneralExpense> expenseList = viewService.getanyhqldatalist("from generalexpense where id='" + id + "'");

            if (expenseList.get(0).getSubadminapproval().equals("Approved") && status.equals("Approved")) {
                updateService.updateanyhqlquery("update generalexpense set status='" + status + "', acceptance='" + status + "', modifydate=now() where id='" + id + "'");
            }

            if (expenseList.get(0).getSubadminapproval().equals("Not approved") && status.equals("Not approved")) {
                updateService.updateanyhqlquery("update generalexpense set status='" + status + "', acceptance='" + status + "', modifydate=now() where id='" + id + "'");
            }

            if (expenseList.get(0).getSubadminapproval().equals("Pending") && status.equals("Pending")) {
                updateService.updateanyhqlquery("update generalexpense set status='" + status + "', acceptance='Pending', modifydate=now() where id='" + id + "'");
            }

            if (expenseList.get(0).getSubadminapproval().equals("Pending") && status.equals("Approved") || expenseList.get(0).getSubadminapproval().equals("Approved") && status.equals("Pending") || expenseList.get(0).getSubadminapproval().equals("Not approved") && status.equals("Pending") || expenseList.get(0).getSubadminapproval().equals("Pending") && status.equals("Not approved") || expenseList.get(0).getSubadminapproval().equals("Not approved") && status.equals("Approved") || expenseList.get(0).getSubadminapproval().equals("Approved") && status.equals("Not approved")) {
                updateService.updateanyhqlquery("update generalexpense set status='" + status + "', acceptance='Pending', modifydate=now() where id='" + id + "'");
            }
        }

        return "redirect:expenseappovalsLink";
    }

    //expense approval of purchase order by admin
    @RequestMapping(value = "addsubGEApprovalStatus")
    public String addsubGEApprovalStatus(@RequestParam(value = "id") String id, @RequestParam(value = "status") String status) {
        List<GeneralExpense> expenseList = viewService.getanyhqldatalist("from generalexpense where id='" + id + "'");

        if (expenseList.get(0).getStatus().equals("Approved") && status.equals("Approved") || expenseList.get(0).getStatus().equals("Pending") && status.equals("Approved") || expenseList.get(0).getStatus().equals("Not approved") && status.equals("Approved")) {
            updateService.updateanyhqlquery("update generalexpense set subadminapproval='" + status + "', modifydate=now() where id='" + id + "'");
        }

        if (expenseList.get(0).getStatus().equals("Not approved") && status.equals("Not approved") || expenseList.get(0).getStatus().equals("Pending") && status.equals("Not approved") || expenseList.get(0).getStatus().equals("Approved") && status.equals("Not approved")) {
            updateService.updateanyhqlquery("update generalexpense set subadminapproval='" + status + "', modifydate=now() where id='" + id + "'");
        }

        if (expenseList.get(0).getStatus().equals("Pending") && status.equals("Pending")) {
            updateService.updateanyhqlquery("update generalexpense set subadminapproval='" + status + "', modifydate=now() where id='" + id + "'");
        }

        if (expenseList.get(0).getStatus().equals("Approved") && status.equals("Pending") || expenseList.get(0).getStatus().equals("Not approved") && status.equals("Pending")) {
            updateService.updateanyhqlquery("update generalexpense set subadminapproval='" + status + "', modifydate=now() where id='" + id + "'");
        }

        return "redirect:expenseappovalsLink";
    }

    //feature: feedback coding begin here
    @RequestMapping(value = "editFollowups")
    public String editFollowups(@ModelAttribute Followups followups) {
        updateService.update(followups);
        return "redirect:userFeedbackLink?fbid=" + followups.getFeedbackid();
    }

    //feature: feedback coding begin here
    @RequestMapping(value = "updateInsuranceCompany")
    public String updateInsuranceCompany(@ModelAttribute InsuranceCompany insuranceCompany) {
        updateService.update(insuranceCompany);
        return "redirect:insuranceCompanyMasterLink";
    }

    //feature: attendance coding begin here
    @RequestMapping(value = "updateAttendance")
    public String updateAttendance(@RequestParam(value = "id") String[] attid, @RequestParam(value = "attendanceStatus") String[] attendanceStatus, @RequestParam(value = "datedetail") String date) {
        for (int i = 0; i < attid.length; i++) {
            String status = "";
            if (attendanceStatus[i].equals("Present")) {
                status = "P";
            }

            if (attendanceStatus[i].equals("Absent")) {
                status = "A";
            }

            if (attendanceStatus[i].equals("Half-day")) {
                status = "H";
            }

            if (attendanceStatus[i].equals("Overtime")) {
                status = "O";
            }

            if (attendanceStatus[i].equals("Holiday")) {
                status = "OF";
            }

            if (attendanceStatus[i].equals("N/A")) {
                status = "N/A";
            }
            //getting the date detail for update query
            String[] dateParts = date.split("/");
            String month = dateParts[0];
            String day = dateParts[1];
            String year = dateParts[2];

            insertService.setanyjdbcdatalist("update daily_attendance da set da." + day + "='" + status + "',modifydate=now() where da.id='" + attid[i] + "'");
//            updateService.updateanyhqlquery("update attendance set status='" + status + "' where id='" + attid[i] + "'");
        }
        return "redirect:viewAttendance";
    }

    //attendance module cpoding end here============
    //customer advance coding begin here===========
    @RequestMapping(value = "updateCustomerAdvance")
    public String updateCustomerAdvance(@ModelAttribute CustomerAdvance customerAdvance, @RequestParam(value = "old_advance_amount") float old_advance_amount) {
        //update customer advance
        updateService.update(customerAdvance);
        //subtracting old amount from customer balance amount     

        List<Customer> oldcustomerlist = viewService.getanyhqldatalist("from customer  where id='" + customerAdvance.getCustomerid() + "'");
        float prevamount = oldcustomerlist.get(0).getAdvance_amount();
        float removeableamount = prevamount - old_advance_amount;
        updateService.updateanyhqlquery("update customer set advance_amount='" + removeableamount + "',modifydate=now() where id='" + customerAdvance.getCustomerid() + "'");

        float finalamount = removeableamount + customerAdvance.getAdvance_amount();

        updateService.updateanyhqlquery("update customer set advance_amount='" + finalamount + "',modifydate=now() where id='" + customerAdvance.getCustomerid() + "'");

        return "redirect:customerAdvanceGridLink";
    }

    //general income code begin here!======================
    //general expense edit 
    @RequestMapping(value = "editGeneralIncome")
    public String editGeneralIncome(@ModelAttribute GeneralIncome generalIncome, @RequestParam(value = "oldmode") String oldmode,
            @RequestParam(value = "tax_amount", required = false) String tax_amount,
            @RequestParam(value = "vattax", required = false) String vattax,
            @RequestParam(value = "oldtotal", required = false) String oldtotal,
            @RequestParam(value = "servicetax", required = false) String servicetax) {

        //CODE TO UPDATE INVOICE BEGIN HERE
        if (generalIncome.getInvoiceid().contains("IV")) {
            System.out.println("I aM FROM INVOICE AND EDITING");
            List<GeneralIncome> incomeList = viewService.getanyhqldatalist("from generalincome where invoiceid='" + generalIncome.getInvoiceid() + "' and ID NOT IN ('" + generalIncome.getId() + "') and isdelete='No'");
            List<Invoice> invoiceList = viewService.getanyhqldatalist("from invoice where id='" + generalIncome.getInvoiceid() + "'");
            double amount = 0;
            double invoicetotal = Double.parseDouble(invoiceList.get(0).getAmountTotal());
            for (int i = 0; i < incomeList.size(); i++) {
                amount += Double.parseDouble(incomeList.get(i).getTotal());
            }
            double paidamount = amount + Double.parseDouble(generalIncome.getTotal());

            if (paidamount < invoicetotal) {
                updateService.updateanyhqlquery("update invoice set ispaid='No', balanceamount=balanceamount+'" + oldtotal + "',modifydate=now() where id='" + generalIncome.getInvoiceid() + "'");
                double newtotal = invoicetotal - Double.parseDouble(generalIncome.getTotal());
                if (newtotal < invoicetotal) {
                    updateService.updateanyhqlquery("update invoice set ispaid='No', balanceamount=balanceamount-'" + generalIncome.getTotal() + "',modifydate=now() where id='" + generalIncome.getInvoiceid() + "'");
                } else {
                    double sundrydr = invoicetotal - newtotal;
                    updateService.updateanyhqlquery("update invoice set ispaid='Yes', balanceamount='0', sundry_debitors='" + sundrydr + "',modifydate=now() where id='" + generalIncome.getInvoiceid() + "'");
                }
            } else if (paidamount > invoicetotal) {
                double sundrydr = paidamount - invoicetotal;
                updateService.updateanyhqlquery("update invoice set balanceamount='0', ispaid='Yes', sundry_debitors='" + sundrydr + "',modifydate=now() where id='" + generalIncome.getInvoiceid() + "'");
            }
        }
        //CODE TO UPDATE INVOICE ENDS! HERE

        //coding regarding the tax begin here
        if (generalIncome.getTax_applicable().equals("N/A")) {
            generalIncome.setTax("0");
            generalIncome.setTaxid("LTX3");
            generalIncome.setVat_tax("0");
            generalIncome.setService_tax("0");
            generalIncome.setVat_service_tax("0");
            generalIncome.setTotal(generalIncome.getAmount());
        }

        //code for handling the tax type begin here
        if (generalIncome.getTaxid().equals("LTX1")) {
            generalIncome.setVat_tax(tax_amount);
        } else if (generalIncome.getTaxid().equals("LTX2")) {
            generalIncome.setService_tax(tax_amount);
        } else if (generalIncome.getTaxid().equals("LTX3")) {
            generalIncome.setVat_tax("0");
            generalIncome.setService_tax("0");
            generalIncome.setVat_service_tax("0");
        } else if (generalIncome.getTaxid().equals("LTX4")) {
            generalIncome.setVat_tax(vattax);
            generalIncome.setService_tax(servicetax);
            generalIncome.setVat_service_tax(tax_amount);
        }
        //code for handling the tax type end! here
        //coding regarding the tax end! here

        if (oldmode.equals(generalIncome.getMode())) {
            updateService.update(generalIncome);
        } else {
            if (oldmode.equals("Online")) {
                generalIncome.setTransactionnumber("");
                generalIncome.setTransactiondate("");
                updateService.updateanyhqlquery("update generalincome set transactionnumber='', transactiondate='',modifydate=now() where id='" + generalIncome.getId() + "' ");
            }

            if (oldmode.equals("Cheque")) {
                generalIncome.setBankname("");
                generalIncome.setChequedate("");
                generalIncome.setChequenumber("");
                updateService.updateanyhqlquery("update generalincome set chequenumber='', bankname='', chequedate='',modifydate=now() where id='" + generalIncome.getId() + "' ");
            }
            updateService.update(generalIncome);
        }

        return "redirect:viewGeneralIncomeDetails?incomeid=" + generalIncome.getId();
    }

    //admin making payment to vendors
    //bank ccount master update codgin here
    @RequestMapping(value = "editbankAccount")
    public String editbankAccount(@ModelAttribute BankAccount bankAccount) {
        updateService.update(bankAccount);
        return "redirect:bankAccountMasterLink";
    }

    @RequestMapping(value = "updateReminderCustomer")
    public String updateReminderCustomer(@ModelAttribute ReminderCustomer reminderCustomer) {
        updateService.update(reminderCustomer);
        return "redirect:reminderCustomerLink";
    }

    //void estimae code begin here
    @RequestMapping(value = "voidestimate")
    public String voidestimate(@RequestParam(value = "id") String id, @RequestParam(value = "pointchecklistid") String pointchecklistid, @RequestParam(value = "reason") String reason) {

        //update estimate details
        updateService.updateanyhqlquery("update estimate set isdelete='Yes', isvoid='Yes',reason='" + reason + "' where id='" + id + "'");
        updateService.updateanyhqlquery("update estimatedetails set isdelete='Yes' where estimateid='" + id + "'");

        //update 180point
        updateService.updateanyhqlquery("update pointchecklist set isdelete='Yes' where id='" + pointchecklistid + "'");
        updateService.updateanyhqlquery("update pointchecklistdetails set isdelete='Yes' where pointchecklistid='" + pointchecklistid + "'");

        //update service checklist
        List<PointChecklist> pointcheckList = viewService.getanyhqldatalist("from pointchecklist where id='" + pointchecklistid + "'");
        updateService.updateanyhqlquery("update customervehicles set isdelete='Yes'  where id='" + pointcheckList.get(0).getCustomervehiclesid() + "'");
        updateService.updateanyhqlquery("update customervehiclesdetails set isdelete='Yes' where custvehicleid='" + pointcheckList.get(0).getCustomervehiclesid() + "'");

        return "redirect:estimate";
    }
    //void estimae code ends!! here

    //update consumable detail begin here
    @RequestMapping(value = "updateConsumable")
    public String updateConsumable(@RequestParam(value = "consumablecount") int consumablecount, @RequestParam(value = "newconsumableid", required = false) List newconsumableid, @RequestParam(value = "allconsumableids") List allconsumableids, @RequestParam(value = "jobno") String jobno, @RequestParam(value = "consumableid", required = false) String[] consumableid, @ModelAttribute ConsumableDtoArray dtoArray) {
        //updates the old consumable code here
        if (consumableid != null) {

            if (consumableid.length > 0) {

                //1.code to update(revert) carpartinfo balance begin here
                List<Inventory> inventoryList = viewService.getanyhqldatalist("from inventory where jobsheetid='" + jobno + "' and isdelete='No'");
                for (int i = 0; i < inventoryList.size(); i++) {
                    int partquantity = Integer.parseInt(inventoryList.get(i).getQuantity());
                    CarPartInfo c = (CarPartInfo) viewService.getspecifichqldata(CarPartInfo.class, inventoryList.get(i).getPartid());
                    int availableqty = Integer.parseInt(c.getBalancequantity());
                    int result = availableqty + partquantity;
                    updateService.updateanyhqlquery("update  carpartinfo  set balancequantity='" + result + "',modifydate=now() where id='" + inventoryList.get(i).getPartid() + "'");
                }

                //if any random part deleted code begin here!
                if (consumableid.length < consumablecount) {
                    for (int i = 0; i < allconsumableids.size(); i++) {
                        if (!newconsumableid.contains(allconsumableids.get(i))) {
                            updateService.updateanyhqlquery("update consumable_details set isdelete='Yes',modifydate=now() where id='" + allconsumableids.get(i) + "'");
                            updateService.updateanyhqlquery("update inventory set isdelete='Yes',modifydate=now() where consumableid='" + allconsumableids.get(i) + "'");
                        }
                    }
                }

                //code to update the details of consumables
                for (int i = 0; i < consumableid.length; i++) {
                    //2.code to update consumable_details
                    updateService.updateanyhqlquery("update consumable_details set quantity='" + dtoArray.getQuantity()[i] + "', sellingprice='" + dtoArray.getSellingprice()[i] + "', total='" + dtoArray.getTotal()[i] + "',modifydate=now() where id='" + consumableid[i] + "'");

                    //3.code to update inventory here
                    updateService.updateanyhqlquery("update inventory set quantity='" + dtoArray.getQuantity()[i] + "', sellingprice='" + dtoArray.getSellingprice()[i] + "', total='" + dtoArray.getTotal()[i] + "',modifydate=now() where consumableid='" + consumableid[i] + "'");

                    //4.code to update balancequantity of carpartinfo begin here!
                    int partquantity = Integer.parseInt(dtoArray.getQuantity()[i]);
                    CarPartInfo c = (CarPartInfo) viewService.getspecifichqldata(CarPartInfo.class, dtoArray.getPartid()[i]);
                    int availableqty = Integer.parseInt(c.getBalancequantity());
                    int result = availableqty - partquantity;
                    updateService.updateanyhqlquery("update  carpartinfo  set balancequantity='" + result + "',modifydate=now() where id='" + dtoArray.getPartid()[i] + "'");
                }

            }

        } else {
            //lenght is less than zero then delete all details from consumable_details, update carpartinfo,delete from inventory code here

            //1.code to update carpartinfo begin here
            List<Inventory> inventoryList = viewService.getanyhqldatalist("from inventory where jobsheetid='" + jobno + "' and isdelete='No'");
            for (int i = 0; i < inventoryList.size(); i++) {
                int partquantity = Integer.parseInt(inventoryList.get(i).getQuantity());
                CarPartInfo c = (CarPartInfo) viewService.getspecifichqldata(CarPartInfo.class, inventoryList.get(i).getPartid());
                int availableqty = Integer.parseInt(c.getBalancequantity());
                int result = availableqty + partquantity;
                updateService.updateanyhqlquery("update  carpartinfo  set balancequantity='" + result + "',modifydate=now() where id='" + inventoryList.get(i).getPartid() + "'");
            }

            //2.delete from consumable code here
            updateService.updateanyhqlquery("update consumable_details set isdelete='Yes',modifydate=now() where jobsheetid='" + jobno + "'");

            //3.delete from inventory code here            
            updateService.updateanyhqlquery("update inventory set isdelete='Yes',modifydate=now() where jobsheetid='" + jobno + "'");
        }

        return "redirect:viewSpareRequisitionGrid";
    }
    //update consumable detail ends!! here

    //========================customer insert==============
    //add approved
    @RequestMapping(value = "addapproved")
    public String addapproved(@RequestParam(value = "estimatedetails") String[] estimateDetails, @RequestParam(value = "estimateid") String estimateid) {

        if (estimateDetails.length > 0) {
            updateService.updateanyhqlquery("update estimate set approval='Yes',modifydate=now() where id='" + estimateid + "'");

            for (int i = 0; i < estimateDetails.length; i++) {
                updateService.updateanyhqlquery("update estimatedetails set approval='Yes',modifydate=now() where id='" + estimateDetails[i] + "'");
            }
        } else {

        }
        return "redirect:estimate";
    }
}
