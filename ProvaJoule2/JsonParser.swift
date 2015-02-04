//
//  JsonParser.swift
//  ProvaJoule2
//
//  Created by TSC Consulting on 10/12/14.
//  Copyright (c) 2014 com.tsc. All rights reserved.
//

import Foundation

class JsonParser: NSObject {
    
    func getTipoUtente (url:String) -> String {
        var parseError:NSError?
        var tipo:String = ""
        
        var jsonObject:NSData = getJSON(url)
        
        
        var myJson:NSDictionary = parseJSONOne(jsonObject)
        
        tipo = myJson.valueForKey("ruolo") as String
        
        return tipo 
    }
       
    func getAdminsList(url:String) -> NSMutableArray{
        
        var arrayResult:NSMutableArray = NSMutableArray()
        
        var jsonObject:NSData = getJSON(url)
       
        
        var myJson:NSArray = parseJSON(jsonObject)
       
        
        
        
        for i in 0...myJson.count-1{
            var u: User = User()
            u.username = myJson[i].valueForKey("username") as String
                //myJson[i]?.valueForKey("username") as String
            u.password = myJson[i].valueForKey("password") as String
            arrayResult.addObject(u as User)
            
        }
        
        return arrayResult

    }
    
        func getInquiliniList(url:String) -> NSMutableArray {
        var arrayResult:NSMutableArray = NSMutableArray()
        
        var jsonObject:NSData = getJSON(url)
        var myJson:NSArray = parseJSON(jsonObject)
        
        
        
        for i in 0...myJson.count-1{
          var inquilino:User = User()
          inquilino.username = myJson[i].valueForKey("username") as String
          inquilino.password = myJson[i].valueForKey("password") as String
            if(myJson[i].valueForKey("nome_su_xls") != nil){
          inquilino.nome_su_xls = myJson[i].valueForKey("nome_su_xls") as String
            }
          inquilino.filenamePalazzo = myJson[i].valueForKey("filenamePalazzo") as String
          inquilino.ruolo = myJson[i].valueForKey("ruolo") as String
           if (inquilino.ruolo == "inquilino") {
            arrayResult.addObject(inquilino)
        }
        }
        return arrayResult
    }
    
    func getInquiliniPianoList(url:String) -> NSArray {
        
        var jsonObject:NSData = getJSON(url)
        var myJson:NSArray = parseJSON(jsonObject)
        
        return myJson
    }
    
    
    func getAppartamento(url:String) -> NSArray {
        
        var jsonObject:NSData = getJSON(url)
        var myJson:NSArray = parseJSON(jsonObject)
        
        return myJson
    }
    
    func getAppartamentoList(url:String, num:Int) -> NSMutableArray {
       
        var arrayResult:NSMutableArray = NSMutableArray()
        
        var jsonObject:NSData = getJSON(url)
        var myJson:NSArray = parseJSON(jsonObject)
        
       
        for i in 0...myJson.count-1{
            var locale:Stanza = Stanza()
            var dizionarioLocale:NSDictionary = myJson[i] as NSDictionary
            var arrayLettureLocale:NSMutableArray = dizionarioLocale.valueForKey("letturaSet") as NSMutableArray
            locale.arrayLetture = arrayLettureLocale
            
             println(arrayLettureLocale)
            
            if(arrayLettureLocale.count > 0){
                var ultimaLettura:NSDictionary = arrayLettureLocale[num] as NSDictionary
                locale.utente = dizionarioLocale.valueForKey("nome_utente_su_xls") as String
                locale.stanza = dizionarioLocale.valueForKey("nomeLocale") as String
                locale.wattInstallati = dizionarioLocale.valueForKey("wattInstallati") as NSNumber
                locale.letturaAttuale = ultimaLettura.valueForKey("lettura") as NSNumber
                locale.matricola = dizionarioLocale.valueForKey("matricola") as NSNumber
                locale.piano = dizionarioLocale.valueForKey("piano") as String
                
                var date:NSDateFormatter = NSDateFormatter()
                date.dateFormat = "MMM dd, yyyy hh:mm:ss aa"
                date.locale = NSLocale(localeIdentifier: "en_US")
                locale.dataLettura = date.dateFromString(ultimaLettura.valueForKey("data") as String)!
                
                arrayResult.addObject(locale)
                
            }
            locale = Stanza()
        }
        return arrayResult
        

    }
    
    func getAppartamentoListJson (json:NSString, num:Int) -> NSMutableArray{
        
        var arrayResult:NSMutableArray = NSMutableArray()
        var st:NSData = stringToNSData(json)
        var arrayLocali:NSArray = parseJSON(st)
        
        for i in 0...arrayLocali.count-1 {
            var locale:Stanza = Stanza()
            var dizionarioLocale:NSDictionary = arrayLocali[i] as NSDictionary
            var arrayLettureLocale:NSMutableArray = dizionarioLocale.valueForKey("letturaSet") as NSMutableArray
            locale.arrayLetture = arrayLettureLocale
            
            println(arrayLettureLocale)
            
            if(arrayLettureLocale.count > 0){
                var ultimaLettura:NSDictionary = arrayLettureLocale[num] as NSDictionary
                locale.utente = dizionarioLocale.valueForKey("nome_utente_su_xls") as String
                locale.stanza = dizionarioLocale.valueForKey("nomeLocale") as String
                locale.wattInstallati = dizionarioLocale.valueForKey("wattInstallati") as NSNumber
                locale.letturaAttuale = ultimaLettura.valueForKey("lettura") as NSNumber
                locale.matricola = dizionarioLocale.valueForKey("matricola") as NSNumber
                locale.piano = dizionarioLocale.valueForKey("piano") as String
                
                var date:NSDateFormatter = NSDateFormatter()
                date.dateFormat = "MMM dd, yyyy hh:mm:ss aa"
                date.locale = NSLocale(localeIdentifier: "en_US")
                locale.dataLettura = date.dateFromString(ultimaLettura.valueForKey("data") as String)!
                
                arrayResult.addObject(locale)
                
            }
            locale = Stanza()
        }
        return arrayResult

        
    }
       
    func getContentPalazzo (url:String, withMonth num:Int) -> NSArray{
        
        var arrayResult:NSMutableArray = NSMutableArray()
        
        var jsonObject:NSData = getJSON(url)
        var myJson:NSDictionary = parseJSONOne(jsonObject)
        var arrayLocali:NSMutableArray = myJson.valueForKey("localeSet") as NSMutableArray
       
        for i in 0...arrayLocali.count-1{
        
            var tableRow:Stanza = Stanza()
            var dizionarioLocale:NSDictionary = arrayLocali[i] as NSDictionary
            if(dizionarioLocale.valueForKey("tipoSensore") as String == "HCA"){
                var arrayLettureLocale:NSMutableArray = dizionarioLocale.valueForKey("letturaSet") as NSMutableArray
                
                if(arrayLettureLocale.count > 0){
                    
                    var dizionarioUltimaLettura:NSDictionary = arrayLettureLocale[num] as NSDictionary
                    tableRow.utente = dizionarioLocale.valueForKey("nome_utente_su_xls") as String
                    tableRow.stanza = dizionarioLocale.valueForKey("nomeLocale") as String
                    tableRow.wattInstallati = dizionarioLocale.valueForKey("wattInstallati") as NSNumber
                    tableRow.letturaAttuale = dizionarioUltimaLettura.valueForKey("lettura") as NSNumber
                    
                    var dateFormatter:NSDateFormatter = NSDateFormatter()
                    dateFormatter.dateFormat = "MMM dd, yyyy hh:mm:ss aa"
                    dateFormatter.locale = NSLocale (localeIdentifier: "en_US")
                    tableRow.dataLettura = dateFormatter.dateFromString(dizionarioUltimaLettura.valueForKey("data") as String)!
                    
                    tableRow.matricola = dizionarioLocale.valueForKey("matricola") as NSNumber
                    tableRow.piano = dizionarioLocale.valueForKey("piano") as String
                    
                    arrayResult.addObject(tableRow)
                    
                }
            }
                tableRow = Stanza()
            
        
        }
        return arrayResult
        

    }
    
    
    func getContentPalazzoJson (json:String, withMonth num:Int) -> NSArray{
        
        var arrayResult:NSMutableArray = NSMutableArray()
        
        var st:NSData = stringToNSData(json)
        var myJson:NSDictionary = parseJSONOne(st)
        var arrayLocali:NSMutableArray = myJson.valueForKey("localeSet") as NSMutableArray
        
        for i in 0...arrayLocali.count-1{
            
            var tableRow:Stanza = Stanza()
            var dizionarioLocale:NSDictionary = arrayLocali[i] as NSDictionary
            if(dizionarioLocale.valueForKey("tipoSensore") as String == "HCA"){
                var arrayLettureLocale:NSMutableArray = dizionarioLocale.valueForKey("letturaSet") as NSMutableArray
                
                if(arrayLettureLocale.count > 0){
                    
                    var dizionarioUltimaLettura:NSDictionary = arrayLettureLocale[num] as NSDictionary
                    tableRow.utente = dizionarioLocale.valueForKey("nome_utente_su_xls") as String
                    tableRow.stanza = dizionarioLocale.valueForKey("nomeLocale") as String
                    tableRow.wattInstallati = dizionarioLocale.valueForKey("wattInstallati") as NSNumber
                    tableRow.letturaAttuale = dizionarioUltimaLettura.valueForKey("lettura") as NSNumber
                    
                    var dateFormatter:NSDateFormatter = NSDateFormatter()
                    dateFormatter.dateFormat = "MMM dd, yyyy hh:mm:ss aa"
                    dateFormatter.locale = NSLocale (localeIdentifier: "en_US")
                    tableRow.dataLettura = dateFormatter.dateFromString(dizionarioUltimaLettura.valueForKey("data") as String)!
                    
                    tableRow.matricola = dizionarioLocale.valueForKey("matricola") as NSNumber
                    tableRow.piano = dizionarioLocale.valueForKey("piano") as String
                    
                    arrayResult.addObject(tableRow)
                    
                }
            }
            tableRow = Stanza()
            
            
        }
        return arrayResult
        
        
    }

    
    
    func getPotenzaTotalePalazzo (url:String) -> NSNumber{
        var dizionarioPalazzo:NSDictionary = parseJSONOne(getJSON(url))
        return dizionarioPalazzo.valueForKey("potenzaTermica") as NSNumber
    }
    
    func getContentACS (url:String)-> NSMutableArray {
        var arrayResult:NSMutableArray = NSMutableArray()
        var jsonObject:NSData = getJSON(url)
        var myJson:NSArray = parseJSON(jsonObject)
        
        for i in 0...myJson.count-1{
        
              var consumoAcqua:Float = myJson[i].valueForKey("consumoAcquaTotale") as Float
              arrayResult.addObject(consumoAcqua)
        }
        
      return arrayResult
      
    }
    
    func getEdifici (url:String) -> NSMutableArray{
        var arrayResult:NSMutableArray = NSMutableArray()
        var edifici:NSArray = parseJSON(getJSON(url))
        
        if(edifici.count > 0){
        for i in 0...edifici.count-1{
        
        var edificio:Edificio = Edificio()
        edificio.amministratore = edifici[i].valueForKey("amministratore") as String
        edificio.filename = edifici[i].valueForKey("filename") as String
        edificio.latitudine = edifici[i].valueForKey("latitudine") as NSNumber
        edificio.longitudine = edifici[i].valueForKey("longitudine") as NSNumber
        arrayResult.addObject(edificio)
        }
        }
        return arrayResult
        
    }
    


    func getJSON(urlToRequest: String) -> NSData{
        return NSData(contentsOfURL: NSURL(string: urlToRequest)!)!
    }
    
    func parseJSON(inputData: NSData) -> NSArray{
        var error: NSError?
        var boardsDictionary: NSArray = NSJSONSerialization.JSONObjectWithData(inputData, options: NSJSONReadingOptions.MutableContainers, error: &error) as NSArray
        
        return boardsDictionary
    }
    
    func parseJSONOne(inputData: NSData) -> NSDictionary{
        var error: NSError?
        var boardsDictionary: NSDictionary = NSJSONSerialization.JSONObjectWithData(inputData, options: NSJSONReadingOptions.MutableContainers, error: &error) as NSDictionary
        
        return boardsDictionary
    }
    
    func stringToNSData (json:String) -> NSData{
        return json.dataUsingEncoding(NSUTF8StringEncoding, allowLossyConversion: true)!
    }

    
}