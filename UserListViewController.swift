//
//  UserListViewController.swift
//  ProvaJoule2
//
//  Created by TSC Consulting on 19/12/14.
//  Copyright (c) 2014 com.tsc. All rights reserved.
//

import Foundation
import UIKit


class UserListViewController:UIViewController , UITableViewDataSource , UITableViewDelegate {
    
  
    @IBOutlet var tableView:UITableView!
    @IBOutlet var customCell:CustomCellInq!
    @IBOutlet var userLabel:UILabel!
    @IBOutlet var userLabel2:UILabel!
    @IBOutlet var acsLabel:UILabel!
    @IBOutlet var totalLabel:UILabel!
    @IBOutlet var prevMonthBtn:UIButton!
    @IBOutlet var nextMonthBtn:UIButton!
    @IBOutlet var edificioDateLabel:UILabel!
    @IBOutlet var edificioTotLabel:UILabel!
    @IBOutlet var backButton:UIButton!
   
 
    var listData:NSArray!
    var totaleConsumiAbitazione:NSNumber!
    var totaleConsumiPalazzo:NSNumber!
    var percPalazzo:String!
    var jsonAppartamento:String!
    var jsonPalazzo:String!
    var inquiliniList:NSArray!
    var usernameAdmin:String!
    var usernameGestore:String!
    var inquilinoUsername:String!
    var monthInitializer:NSNumber!
    var arrayPercRispPalazzo:NSMutableArray!
    var edificiList:NSArray!
    var adminsList:NSArray!
    var listAcs:NSArray!
    var inquiliniPianoList:NSArray!
    var potTermicaPalazzo:NSNumber!
    var urlPalazzo:String!
    var urlAbitazione:String!
  
    
    //inizializzazione totali
    var totalePalazzo:Int=0;
    var totaleAbitazione:Int=0;
    
    //inizializzazione mese: 0 corrisponde al mese dell'ultima lettura, 1 al mese della penultima, ecc...
    var month:Int=0;
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        month = monthInitializer as Int
        
        //recupera i totali
        totaleAbitazione = Int(Statistic().getTotal(listData))
        totalePalazzo = totaleConsumiPalazzo as Int
        totaleConsumiAbitazione = NSNumber(integer: totaleAbitazione)
    
        //setta le label
        var tableRow:Stanza = listData[0] as Stanza
        if(usernameGestore != nil){
        userLabel.text = capitalizeFirstCharacter (usernameGestore)
        }else if(usernameAdmin != nil){
            userLabel.text = capitalizeFirstCharacter(usernameAdmin)
        }else{
            userLabel.text = capitalizeFirstCharacter(inquilinoUsername)
            backButton.hidden = true
            backButton.enabled = false
        }
        userLabel2.text = capitalizeFirstCharacter(tableRow.utente)
        edificioTotLabel.text = NSString (format: "Lettura %d", totalePalazzo)
    
        //dateformatter per visualizzare la data nel formato mese.anno
        var dateFormatter:NSDateFormatter = NSDateFormatter()
        dateFormatter.dateFormat = "MM.yyyy"
        var stanza:Stanza = listData[0] as Stanza
        edificioDateLabel.text = NSString (format:"%@", dateFormatter.stringFromDate(stanza.dataLettura))
    
    
        if (totaleAbitazione == 0) {
            totalLabel.text = NSString (format: "Letture assenti per il mese in oggetto")
        } else {
            println(totaleAbitazione)
            println(totalePalazzo)
            var tot = (Float)(totaleAbitazione*100) / (Float)(totalePalazzo)
            totalLabel.text = NSString(format: "Consumo: %0.2f%%", tot)  //((format: "Consumo: %0.2f%%"), tot)
        }
    
        acsLabel.text = NSString (format:"Acqua calda: %0.2f m3", listAcs[month] as Float )
    
        //disabilita il tasto per il mese successivo
        nextMonthBtn.enabled = false
    }
    
    func convertExcelDate (excelFormatDate:NSNumber) -> NSString{
        var newDate:NSNumber = ((excelFormatDate as Int) + 24142)*86400
        var date:NSDate = NSDate(timeIntervalSince1970: NSTimeInterval(newDate))
        var dateFormatt:NSDateFormatter = NSDateFormatter()
        dateFormatt.dateFormat = "MM.yyyy"
        var dateString:NSString = dateFormatt.stringFromDate(date)
        return dateString
    }
    
    //Table view
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return listData.count
        
    }
    
     func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let nibName = UINib(nibName: "CustomCellInq", bundle:nil)
        tableView.registerNib(nibName, forCellReuseIdentifier: "CellInq")
        
        let cell = tableView.dequeueReusableCellWithIdentifier("CellInq", forIndexPath:indexPath) as CustomCellInq
        
        var dateFormatter:NSDateFormatter = NSDateFormatter()
        dateFormatter.dateFormat = "MM.yyyy"
        
        var tableRow:Stanza = listData[indexPath.row] as Stanza
        cell.stanzaLbl.text = tableRow.stanza.uppercaseString
        cell.pianoLbl.text = capitalizeFirstCharacter(tableRow.piano)
        cell.letturaLbl.text = NSString(format: "Lettura %d", tableRow.letturaAttuale.intValue)
        cell.matricolaLbl.text = NSString(format: "MATR.: %@", tableRow.matricola.stringValue)
        cell.dataLbl.text = NSString(format: "%@", dateFormatter.stringFromDate(tableRow.dataLettura))
        
        if (totaleAbitazione == 0){
            cell.percentualeLbl.text = NSString (format: "Percentuale 0.00%%")
        }else{
            
            cell.percentualeLbl.text = NSString(format: "Percentuale %0.2f%%", (tableRow.letturaAttuale.doubleValue*100) / Statistic().getTotal(listData).doubleValue)
        }
        
        return cell
        
    }
    
    func capitalizeFirstCharacter(toCapitalize:String) -> String{
        toCapitalize.lowercaseString
        var str:String = toCapitalize.capitalizedString
        return str
    }

    func tableView (tableView:UITableView, didSelectRowAtIndexPath indexPath:NSIndexPath){
    }
    
    @IBAction func back(){
        month = 0
        let storyboard = UIStoryboard(name: "InquiliniVC", bundle: nil)
        let vc = storyboard.instantiateViewControllerWithIdentifier("InquiliniVC") as InquiliniViewController
        vc.usernameAdmin = usernameAdmin
        if(usernameGestore != nil){
        vc.usernameGestore = usernameGestore
        }else if(usernameAdmin != nil){
            vc.usernameAdmin = usernameAdmin
        }
        vc.listData = inquiliniList
        vc.arrayPercRispPalazzo = arrayPercRispPalazzo
        vc.adminsList = adminsList
        vc.edificiList = edificiList
        vc.inquiliniPianoList = inquiliniPianoList
        vc.jsonAppartamento = jsonAppartamento
        vc.jsonPalazzo = jsonPalazzo
        vc.acsList = listAcs
        var allInquilino:[String] = inquilinoUsername.componentsSeparatedByString("_")
        var iUsername:String = allInquilino[1] as String
        vc.inquilinoUser = iUsername
        super.tabBarController?.tabBar.hidden = true
        self.presentViewController(vc, animated: true, completion: nil)
        
    }
    
    
    
    //resetta la view per mostrare i valori relativi al mese precedente
    @IBAction func previousMonth(){
        //riabilita il bottone per il mese successivo
        nextMonthBtn.enabled = true
        
        var tableRow:Stanza = listData[0] as Stanza
        if((month+1) < tableRow.arrayLetture.count){
            
            //aggiorna il mese corrente e recupera i valori ad esso relativi
            month = month+1
            var json:JsonParser = JsonParser()
            //var newListData:NSArray = json.getAppartamentoList(urlAbitazione, num: month)
            println(jsonAppartamento)
            println(jsonPalazzo)
            var newListData:NSArray = json.getAppartamentoListJson(jsonAppartamento, num: month)
            totalePalazzo = Statistic().getTotal(json.getContentPalazzoJson(jsonPalazzo, withMonth: month)) as Int
            totaleAbitazione = Statistic().getTotal(newListData) as Int
            edificioTotLabel.text = NSString (format: "Lettura %d", totalePalazzo)
            var stanza:Stanza = newListData[0] as Stanza
            var dateFormatter:NSDateFormatter = NSDateFormatter()
            dateFormatter.dateFormat = "MM.yyyy"
            edificioDateLabel.text = NSString(format: "%@", dateFormatter.stringFromDate(stanza.dataLettura))
            if(totaleAbitazione == 0){
                totalLabel.text = NSString (format: "Letture assenti per il mese in oggetto")
            }else{
                var tot = (Float)(totaleAbitazione*100) / (Float)(totalePalazzo)
                totalLabel.text = NSString(format: "Consumo %0.2f%%", tot)
            }
            
            acsLabel.text = NSString(format: "Acqua calda: %0.2f m3", listAcs[month].floatValue)
            listData = newListData
            
            //aggiorna la tabella con i nuovi dati
             Dispatcher(tableView.reloadData)
            tableView.reloadRowsAtIndexPaths(tableView.indexPathsForVisibleRows()!, withRowAnimation: UITableViewRowAnimation.None)
            tableView.setNeedsDisplay()
            tableView.setNeedsLayout()
            
            //se non ci sono mesi precedenti, disabilita il bottone per il mese precedente
            if(month+1 == tableRow.arrayLetture.count){
                prevMonthBtn.enabled = false
            }else{
                prevMonthBtn.enabled = true
            }
            
        }
    }
    
    @IBAction func nextMonth(){
        
         //se non ci sono mesi successivi, disabilita il bottone per il mese successivo
        if((month-1) < 0){
            nextMonthBtn.enabled = false
        }else{
            prevMonthBtn.enabled = true
        }
        
         //aggiorna il mese corrente e recupera i valori ad esso relativi
        month = month-1
        var json:JsonParser = JsonParser()
        var newListData:NSArray = json.getAppartamentoListJson(jsonAppartamento, num: month)
        totalePalazzo = Statistic().getTotal(json.getContentPalazzoJson(jsonPalazzo, withMonth: month)) as Int
        totaleAbitazione = Statistic().getTotal(newListData) as Int
        edificioTotLabel.text = NSString(format: "Lettura %d", totalePalazzo)
        var stanza:Stanza = newListData[0] as Stanza
        var dateFormatter:NSDateFormatter = NSDateFormatter()
        dateFormatter.dateFormat = "MM.yyyy"
        edificioDateLabel.text = NSString(format: "%@", dateFormatter.stringFromDate(stanza.dataLettura))
        if(totaleAbitazione == 0){
            totalLabel.text = NSString(format: "Letture assenti per il mese in oggetto")
        }else{
            var tot = (Float)(totaleAbitazione*100) / (Float)(totalePalazzo)
            totalLabel.text = NSString(format: "Consumo %0.2f%%", tot)
        }
        
        acsLabel.text = NSString(format: "Acqua calda: %0.2f m3", listAcs[month].floatValue)
        listData = newListData
        
         //aggiorna la tabella con i nuovi dati
        Dispatcher(tableView.reloadData)
        tableView.reloadRowsAtIndexPaths(tableView.indexPathsForVisibleRows()!, withRowAnimation: UITableViewRowAnimation.None)
        tableView.setNeedsDisplay()
        tableView.setNeedsLayout()
        if(month == 0){
            nextMonthBtn.enabled = false
        }else{
            nextMonthBtn.enabled = true
        }
        
    }
    
    func Dispatcher(functionToRunOnMainThread: () -> ()){
        dispatch_async(dispatch_get_main_queue(), functionToRunOnMainThread)
    }
    
    
    @IBAction func logout(){
        var vc:ViewController = ViewController()
        super.tabBarController?.tabBar.hidden = true
        let paths = NSSearchPathForDirectoriesInDomains(NSSearchPathDirectory.DocumentDirectory, .UserDomainMask, true) as NSArray
        let documentsDirectory = paths[0] as NSString
        var path = documentsDirectory.stringByAppendingPathComponent("MyFile9.plist")
        var fileManager = NSFileManager.defaultManager()
        fileManager.removeItemAtPath(path, error: nil)
        self.presentViewController(vc, animated: true, completion: nil)
    }


    
}


