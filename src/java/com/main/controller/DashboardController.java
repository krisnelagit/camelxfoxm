/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package com.main.controller;

import com.main.service.AllInsertService;
import com.main.service.AllViewService;
import java.text.SimpleDateFormat;
import java.util.Calendar;
import java.util.Map;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.core.env.Environment;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.servlet.ModelAndView;

/**
 *
 * @author user
 */
@Controller
public class DashboardController {

    @Autowired
    AllViewService viewService;

    @Autowired
    AllInsertService insertService;

    @Autowired
    Environment env;

    //dahsboard coding begin here
    //code below get the branch prefix andredirects
    @RequestMapping(value = "gotobranchinfo")
    public String gotobranchinfo(@RequestParam(value = "prefixid") String prefixid, Map<String, Object> map) {
        map.put("prefixdt", prefixid);
        return "Dashboard_menu";
    }

    @RequestMapping(value = "operation_Dashboard")
    public ModelAndView operation_Dashboard(@RequestParam(value = "prefixid") String prefix) {
        ModelAndView modelAndView = new ModelAndView("Dashboard_operation");

        //today service checklist begin here
        String todayDate = new SimpleDateFormat("yyyy-MM-dd").format(Calendar.getInstance().getTime());
        modelAndView.addObject("todayServiceCheckListDt", viewService.getanyjdbcdatalist("SELECT cv.*,cv.id as cvid,c.name,cvd.id as cvdid FROM customervehicles cv\n"
                + "inner join customervehiclesdetails cvd on cvd.custvehicleid=cv.id\n"
                + "inner join customer c on cv.custid=c.id \n"
                + "where cv.isdelete='No' and cv.savedate Like '" + todayDate + "%'  and cv.id like '" + prefix + "%' \n"
                + "order by length(cv.id) desc,cv.id desc"));
        //today service checklist end here

        //pending 180 code begin here        
        modelAndView.addObject("pending180Dt", viewService.getanyjdbcdatalist("SELECT cv.*,c.name,cvd.id as cvdid FROM customervehicles cv\n"
                + "inner join customervehiclesdetails cvd on cvd.custvehicleid=cv.id\n"
                + "inner join customer c on cv.custid=c.id \n"
                + "where cv.isdelete='No' and cv.is180ready='No' and cv.id like '" + prefix + "%'\n"
                + "order by cv.savedate desc"));
        //pending 180 code ends! here

        //Completed 180 code begin here        
        modelAndView.addObject("completed180Dt", viewService.getanyjdbcdatalist("SELECT cv.*,c.name,cvd.id as cvdid FROM customervehicles cv\n"
                + "inner join customervehiclesdetails cvd on cvd.custvehicleid=cv.id\n"
                + "inner join customer c on cv.custid=c.id \n"
                + "where cv.isdelete='No' and cv.is180ready='Yes' and cv.id like '" + prefix + "%'\n"
                + "order by cv.savedate desc"));
        //Completed 180 code ends! here

        //pending estimate code begin here        
        modelAndView.addObject("pendingestimateDt", viewService.getanyjdbcdatalist("SELECT pcl.date as pcldate,pcl.id,pcl.isestimate as estimatestatus,pcl.servicechecklistid,cv.vehiclenumber,cv.carmodel,cv.branddetailid FROM pointchecklist pcl\n"
                + "inner join customervehicles cv on cv.id=pcl.customervehiclesid \n"
                + "where pcl.isdelete='No' and pcl.id like '" + prefix + "%' and pcl.isestimate='No'\n"
                + " order by pcl.savedate desc"));
        //pending estimate code ends! here

        //Completed estimate code begin here        
        modelAndView.addObject("completedestimateDt", viewService.getanyjdbcdatalist("SELECT pcl.date as pcldate,pcl.id,pcl.isestimate as estimatestatus,pcl.servicechecklistid,cv.vehiclenumber,cv.carmodel,cv.branddetailid FROM pointchecklist pcl\n"
                + "inner join customervehicles cv on cv.id=pcl.customervehiclesid \n"
                + "where pcl.isdelete='No' and pcl.id like '" + prefix + "%' and pcl.isestimate='Yes'\n"
                + " order by pcl.savedate desc"));
        //Completed estimate code ends! here

        //pending jobsheet code begin here        
        modelAndView.addObject("pendingjobsheetDt", viewService.getanyjdbcdatalist("SELECT js.id as jsid,cu.name as custname,cv.carmodel,cv.branddetailid,cv.vehiclenumber,js.isinvoiceconverted,js.istaskcompleted,est.isjobsheetready FROM jobsheet js\n"
                + "inner join customervehicles cv on cv.id=js.cvid\n"
                + "inner join customer cu on cu.id=cv.custid\n"
                + "inner join estimate est on est.id=js.estimateid\n"
                + "where js.isdelete='No' and est.isjobsheetready='No' and js.id like '" + prefix + "%'"));
        //pending jobsheet code ends! here

        //Today invoice code     
        modelAndView.addObject("pendingjobsheetDt", viewService.getanyjdbcdatalist("SELECT inv.*,cu.name FROM invoice inv\n"
                + "inner join customer cu on cu.mobilenumber=inv.customermobilenumber\n"
                + "where inv.isdelete='No' and inv.savedate Like '" + todayDate + "%' and inv.id Like '" + prefix + "%'"));
        //todays invoice code ends! here
        return modelAndView;
    }

    @RequestMapping(value = "crm_Dashboard")
    public ModelAndView crm_Dashboard(@RequestParam(value = "prefixid") String prefix) {
        ModelAndView modelAndView = new ModelAndView("Dashboard_crm");

        //todays enquries begin here
        String todayDate = new SimpleDateFormat("yyyy-MM-dd").format(Calendar.getInstance().getTime());
        modelAndView.addObject("enquiriesDt", viewService.getanyhqldatalist("from enquiries where isdelete='No' and iscustomer='No' and savedate like '" + todayDate + "%' and id like '" + prefix + "%'"));

        //todays followups begin here
        modelAndView.addObject("followupdt", viewService.getanyjdbcdatalist("SELECT fo.id,eq.name,fo.nextfollowup,fo.fpstatus,fo.followedby,date(fo.savedate)as date FROM followups fo\n"
                + "inner join enquiries eq on eq.id=fo.enquirieid\n"
                + "where fo.isdelete='No' and fo.savedate like '" + todayDate + "%' and fo.id like '" + prefix + "%' order by length(fo.id) desc,fo.id desc"));

        //todays appointments begin here
        modelAndView.addObject("datatabledtt", viewService.getanyjdbcdatalist("SELECT ap.id,ap.datetime,eq.name,ap.subject,ap.appointmentowner,ap.address,ap.apdescription FROM appointment ap\n"
                + "inner join enquiries eq on eq.id=ap.enquirieid\n"
                + "where ap.isdelete='No' and ap.savedate like '" + todayDate + "%' and ap.id like '" + prefix + "%'"));

        return modelAndView;
    }

    @RequestMapping(value = "accounts_Dashboard")
    public ModelAndView accounts_Dashboard(@RequestParam(value = "prefixid") String prefix) {
        ModelAndView modelAndView = new ModelAndView("Dashboard_crm");

        //todays enquries begin here
        String todayDate = new SimpleDateFormat("yyyy-MM-dd").format(Calendar.getInstance().getTime());
        modelAndView.addObject("enquiriesDt", viewService.getanyhqldatalist("from enquiries where isdelete='No' and iscustomer='No' and savedate like '" + todayDate + "%' and id like '" + prefix + "%'"));

        //expense approval begin here
        modelAndView.addObject("generalexpensedtls", viewService.getanyjdbcdatalist("SELECT ge.*,lg.accountname,ldg.name FROM generalexpense ge\n"
                + "inner join ledger lg on lg.id=ge.ledgerid\n"
                + "inner join ledgergroup ldg on ldg.id=lg.ledgergroupid\n"
                + "where ge.isdelete='No' and ge.id like '" + prefix + "%'"));

        //todays appointments begin here
        modelAndView.addObject("datatabledtt", viewService.getanyjdbcdatalist("SELECT ap.id,ap.datetime,eq.name,ap.subject,ap.appointmentowner,ap.address,ap.apdescription FROM appointment ap\n"
                + "inner join enquiries eq on eq.id=ap.enquirieid"));

        return modelAndView;
    }
}
