//
//  Stanza.swift
//  ProvaJoule2
//
//  Created by TSC Consulting on 22/12/14.
//  Copyright (c) 2014 com.tsc. All rights reserved.
//

import Foundation

class Stanza: NSObject {
    
    var utente:String
    var stanza:String
    var piano:String
    var matricola:NSNumber
    var arrayLetture:NSArray
    var letturaAttuale:NSNumber
    var dataLettura:NSDate
    var wattInstallati:NSNumber
    
    
    init(utente:String, stanza:String, piano:String, matricola:NSNumber, arrayLetture:NSArray, letturaAttuale:NSNumber, dataLettura:NSDate, wattInstallati:NSNumber){
        
        self.utente = utente
        self.stanza = stanza
        self.piano = piano
        self.matricola = matricola
        self.arrayLetture = arrayLetture
        self.letturaAttuale = letturaAttuale
        self.dataLettura = dataLettura
        self.wattInstallati = wattInstallati
        super.init()
        
    }
    
    override init(){
        utente = ""
        stanza = ""
        piano = ""
        matricola = 0
        arrayLetture = NSArray()
        letturaAttuale = 0
        dataLettura = NSDate()
        wattInstallati = 0
        super.init()
    }
}


