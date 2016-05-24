/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package com.main.sync;

import java.sql.Connection;

/**
 *
 * @author user
 */
public class CompareTables {
    Connection ServerConnection;
    Connection LocalConnection;

    public CompareTables(Connection ServerConnection, Connection LocalConnection) {
        this.ServerConnection = ServerConnection;
        this.LocalConnection = LocalConnection;
    }
    
    
    
}
