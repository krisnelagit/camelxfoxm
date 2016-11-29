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
@Entity(name = "estimate")
@Table(name = "estimate")
public class Estimate {

    @Id
    private String id;
    private String pclid, cvid, confirm_estimate = "No", isjobsheetready = "No", isvoid = "No", reason,comments, isdelete = "No", enableDelete = "Yes", modifydate = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss").format(Calendar.getInstance().getTime());

    public Estimate(String id, String pclid, String cvid, String reason, String comments) {
        this.id = id;
        this.pclid = pclid;
        this.cvid = cvid;
        this.reason = reason;
        this.comments = comments;
    }

    public String getComments() {
        return comments;
    }

    public void setComments(String comments) {
        this.comments = comments;
    }
    
    public String getConfirm_estimate() {
        return confirm_estimate;
    }

    public void setConfirm_estimate(String confirm_estimate) {
        this.confirm_estimate = confirm_estimate;
    }
        
    public String getEnableDelete() {
        return enableDelete;
    }

    public void setEnableDelete(String enableDelete) {
        this.enableDelete = enableDelete;
    }

    public String getIsvoid() {
        return isvoid;
    }

    public void setIsvoid(String isvoid) {
        this.isvoid = isvoid;
    }

    public String getReason() {
        return reason;
    }

    public void setReason(String reason) {
        this.reason = reason;
    }

    public String getIsjobsheetready() {
        return isjobsheetready;
    }

    public void setIsjobsheetready(String isjobsheetready) {
        this.isjobsheetready = isjobsheetready;
    }

    public String getCvid() {
        return cvid;
    }

    public void setCvid(String cvid) {
        this.cvid = cvid;
    }

    public Estimate() {
    }

    public String getId() {
        return id;
    }

    public void setId(String id) {
        this.id = id;
    }

    public String getPclid() {
        return pclid;
    }

    public void setPclid(String pclid) {
        this.pclid = pclid;
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
