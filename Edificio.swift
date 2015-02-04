//
//  Edificio.swift
//  ProvaJoule2
//
//  Created by TSC Consulting on 11/12/14.
//  Copyright (c) 2014 com.tsc. All rights reserved.
//

import Foundation


class Edificio:NSObject {
    
    var amministratore:String
    var filename:String
    var latitudine:NSNumber
    var longitudine:NSNumber
    
     init(amministratore:String, filename:String, latitudine:NSNumber, longitudine:NSNumber) {
        self.amministratore = amministratore
        self.filename = filename
        self.latitudine = latitudine
        self.longitudine = longitudine
        super.init()
    }
    
    override init(){
        amministratore = ""
        filename = ""
        latitudine = 0.0
        longitudine = 0.0
        super.init()
    }
}