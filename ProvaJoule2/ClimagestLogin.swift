//
//  ClimagestLogin.swift
//  ProvaJoule2
//
//  Created by TSC Consulting on 10/12/14.
//  Copyright (c) 2014 com.tsc. All rights reserved.
//

import Foundation

class ClimagestLogin: NSObject {
    
    var path:String!
    
    func startLogin (username:String, password:String){
        
        var credential:Dictionary<String, String> = Dictionary()
        
        credential = ["nomeUtente":username, "password":password]
       
        var loginThread:NSThread = NSThread(target: self, selector: "loginBackground:", object: credential)
        loginThread.start()

    }
    
    func loginBackground(credential:Dictionary<String,String>){
        
      
        
        var username = credential["nomeUtente"]
        var password = credential["password"]
        
        var urlStringNotFormatted:String = "http://joule-40.appspot.com/auth?username="+username!+"&password="+password!
        println(urlStringNotFormatted)
        var urlString = urlStringNotFormatted.stringByAddingPercentEscapesUsingEncoding(NSUTF8StringEncoding)!
       
        
        let urlS = NSString(format: urlString)
       
        var url:NSURL = NSURL(string: urlS)!
        
        
       
        
        var result:String = String (contentsOfURL: url, encoding: NSUTF8StringEncoding, error: nil)!
       
        
        let json = JsonParser()
        
        if(!result.isEmpty && (result.hasPrefix("{") || result.hasPrefix("[")) && json.getTipoUtente(urlS) == "gestore"){
        NSNotificationCenter.defaultCenter().postNotificationName("ClimagestUserLoginSuccessGestore", object: nil)
       
        } else if(!result.isEmpty && result.hasPrefix("{") && json.getTipoUtente(urlS) == "amministratore"){
            NSNotificationCenter.defaultCenter().postNotificationName("ClimagestUserLoginSuccessAmministratore", object: nil)
         
        
        }else if(!result.isEmpty && result.hasPrefix("{") && json.getTipoUtente(urlS) == "inquilino"){
            NSNotificationCenter.defaultCenter().postNotificationName("ClimagestUserLoginSuccessInquilino", object: nil)
        }else{
        NSNotificationCenter.defaultCenter().postNotificationName("ClimagestUserLoginFailed", object: nil)
        }
        
        
}
    
    
    
}