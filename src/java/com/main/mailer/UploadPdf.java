/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package com.main.mailer;

import java.io.BufferedWriter;
import java.io.File;
import java.io.FileNotFoundException;
import java.io.FileOutputStream;
import java.io.FileWriter;
import java.io.IOException;
import java.sql.Timestamp;
import org.apache.commons.codec.binary.Base64;

/**
 *
 * @author user
 */
public class UploadPdf {

    public void savePdf(String imgv, String fileName, String filePath, String fileType) {
        try {
            imgv = imgv.replaceFirst("^data:application/[^;]*;base64,?", "");
            // Converting a Base64 String into Image byte array
            byte[] imageByteArray = decodeImage(imgv);

            // Write a image byte array into file system
            FileOutputStream imageOutFile = new FileOutputStream(filePath + fileName + fileType);
            imageOutFile.write(imageByteArray);

            imageOutFile.close();

            System.out.println("Pdf Successfully Uploaded!");

        } catch (FileNotFoundException e) {
            System.out.println("Image not found" + e);
        } catch (IOException ioe) {
            System.out.println("Exception while reading the Image " + ioe);
        }

    }

    public static byte[] decodeImage(String imageDataString) {
        return Base64.decodeBase64(imageDataString);
    }

    public void savehtml(String filePath, String mypdfbase) throws IOException {
        String head = "<!DOCTYPE html><html><head><title>TODO supply a title</title><meta charset=\"UTF-8\"><meta name=\"viewport\" content=\"width=device-width, initial-scale=1.0\"><style type=\"text/css\">@media print{#printdivinside *{font-size: 8px !important;}} </style></head><body>";

        String foot = "</body>\n"
                + "</html>";
        File file = new File(filePath);
        //if file doesnt exists, then create it
        if (!file.exists()) {
            file.createNewFile();
        }
        FileWriter fw = new FileWriter(file.getAbsoluteFile());
        BufferedWriter bw = new BufferedWriter(fw);
        bw.write(head);
        bw.write(mypdfbase);
        bw.write(foot);
        bw.close();
    }

    public static void main(String[] args) throws IOException {
        UploadPdf pdf = new UploadPdf();
        String filepath = "/media/pc2/Data/Nityanand/test nitz.html";
        String filedata = "world";

        pdf.savehtml(filepath, filedata);
        System.out.println("Saved nitzzzzzz");
    }
}
