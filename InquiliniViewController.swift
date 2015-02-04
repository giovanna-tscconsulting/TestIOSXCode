//
//  InquiliniViewController.swift
//  ProvaJoule2
//
//  Created by TSC Consulting on 11/12/14.
//  Copyright (c) 2014 com.tsc. All rights reserved.
//

import Foundation
import UIKit

class InquiliniViewController: UIViewController, UITableViewDataSource {
    
    var listPianoInquilini:NSArray!
    var inquiliniList:NSArray!
    var inquiliniPianoList:NSArray!
    var adminsList:NSArray!
    var listData:NSArray!
    var edificiList:NSArray!
    var usernameGestore:String!
    var usernameAdmin:String!
    var palazzo:String!
    var width:CGFloat!
    var height:CGFloat!
    var y:CGFloat!
    var arrayPercRispPalazzo:NSMutableArray!
    
    var appartamentoSorted:NSArray!
    var urlStringAppartamento:String!
    var appartamentoList:NSArray!
    var resultAppartamento:String!
    
    var urlStringPalazzo:String!
    var palazzoList:NSArray!
    var resultPalazzo:String!
    var potenzaTermicaPalazzo:NSNumber!
    
    
    var jsonAppartamento:String!
    var jsonPalazzo:String!
    var acsList:NSArray!
    var inquilinoUser:String!
    var potenzaTotPalazzo:NSNumber!

    
    @IBOutlet var buttonLogOut: UIButton!
    @IBOutlet var labelNomeUtente: UILabel!
    
    
    override func viewDidLoad(){
        super.viewDidLoad()
        if(usernameGestore != nil){
        labelNomeUtente.text = capitalizeFirstCharacter(usernameGestore)
        }else{
            labelNomeUtente.text = capitalizeFirstCharacter(usernameAdmin)
        }
        if(arrayPercRispPalazzo == nil){
            arrayPercRispPalazzo = NSMutableArray()
            var urlStringNotFormattedAppartamento = "http://joule-40.appspot.com/totaliconsumo?palazzo="+palazzo
            var urlStringAppartamento = urlStringNotFormattedAppartamento.stringByAddingPercentEscapesUsingEncoding(NSUTF8StringEncoding)
            
            var json:JsonParser = JsonParser()
            var resultApp:NSArray = json.getAppartamento(urlStringAppartamento!)
            
            var totPalazzo:NSNumber = resultApp.objectAtIndex(0).valueForKey("totale") as NSNumber
            var i:Int
            for (i = 1; i < resultApp.count; i++){
                var num:NSNumber = (resultApp[i].valueForKey("totale") as Float * 100) / (totPalazzo as Float)  as Float
                arrayPercRispPalazzo.addObject(num)
            }
            
        }
    }

    //Table view
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return inquiliniPianoList.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let nibName = UINib(nibName: "CustomCellIInquilino", bundle:nil)
        tableView.registerNib(nibName, forCellReuseIdentifier: "CellInquilino")
        
        let cell = tableView.dequeueReusableCellWithIdentifier("CellInquilino", forIndexPath:indexPath) as CustomCellInquilino
        
       // cell.sizeThatFits(CGSize(width: width, height: 44))
      
        var utenteConPiano:String = inquiliniPianoList[indexPath.row] as String
        
        cell.nomeLbl.text = capitalizeFirstCharacter(utenteConPiano.componentsSeparatedByString("_")[1])
        cell.pianoLbl.text = NSString(format: "PIANO %@", utenteConPiano.componentsSeparatedByString("_")[0])
        cell.percLbl.text = NSString (format: "%0.2f%%", arrayPercRispPalazzo[indexPath.row] as Float)
        
        return cell
    }

 
    func capitalizeFirstCharacter (toCapitalize:String)->String{
        toCapitalize.lowercaseString
        var str:String = toCapitalize.capitalizedString
        return str
    }
  
    
     func tableView (tableView:UITableView, didSelectRowAtIndexPath indexPath:NSIndexPath){
        
        var cell:CustomCellInquilino = tableView.cellForRowAtIndexPath(indexPath) as CustomCellInquilino
        var spinner:UIActivityIndicatorView = UIActivityIndicatorView()
        spinner.activityIndicatorViewStyle = UIActivityIndicatorViewStyle.White
        cell.accessoryView = spinner
         //spinner.frame = cell.arrow.frame
        spinner.startAnimating()
        //cell.arrow.hidden = true
        var timer = NSTimer.scheduledTimerWithTimeInterval(0.1, target: self, selector: Selector("pushDetailView:"), userInfo: indexPath, repeats: false)
     }

    
    func pushDetailView (timer:NSTimer){
        
        var path:NSIndexPath = timer.userInfo as NSIndexPath
       
        var inquilinoUsername:String = inquiliniPianoList[path.row] as String
        var allInquilino:[String] = inquilinoUsername.componentsSeparatedByString("_")
        var iUsername:String = allInquilino[1] as String
        
        var json:JsonParser = JsonParser()
        var urlStringNotFormattedPalazzo:String = "http://joule-40.appspot.com/palazzo?username="+iUsername
        self.urlStringPalazzo = urlStringNotFormattedPalazzo.stringByAddingPercentEscapesUsingEncoding(NSUTF8StringEncoding)!
       
        
        if(jsonAppartamento != nil && jsonPalazzo != nil && acsList != nil && inquilinoUser == iUsername){
            appartamentoList = json.getAppartamentoListJson(jsonAppartamento, num: 0)
            palazzoList = json.getContentPalazzoJson(jsonPalazzo, withMonth: 0)
        
        }else{
        
        var urlStringNotFormattedAppartamento:String = "http://joule-40.appspot.com/appartamento?username="+iUsername
        urlStringAppartamento = urlStringNotFormattedAppartamento.stringByAddingPercentEscapesUsingEncoding(NSUTF8StringEncoding)!
        var urlAppartamento:NSURL = NSURL(string: self.urlStringAppartamento)!
        resultAppartamento = String (contentsOfURL: urlAppartamento, encoding: NSUTF8StringEncoding, error: nil)!
        appartamentoList = json.getAppartamentoList(self.urlStringAppartamento, num: 0)
        
        //var sort:NSSortDescriptor = NSSortDescriptor(key: "stanza", ascending: true)
        //self.appartamentoSorted = self.appartamentoList.sortedArrayUsingDescriptors([sort])
        
        //var urlStringNotFormattedPalazzo:String = "http://joule-40.appspot.com/palazzo?username="+iUsername
        //self.urlStringPalazzo = urlStringNotFormattedPalazzo.stringByAddingPercentEscapesUsingEncoding(NSUTF8StringEncoding)!
        var urlPalazzo:NSURL = NSURL (string: self.urlStringPalazzo)!
        resultPalazzo = String (contentsOfURL: urlPalazzo, encoding: NSUTF8StringEncoding, error: nil)!
        
        self.palazzoList = json.getContentPalazzo(self.urlStringPalazzo, withMonth: 0)
        var urlStringNotFormattedAcs:String = "http://joule-40.appspot.com/appartamentoacqua?username="+iUsername
        var urlStringAcs:String = urlStringNotFormattedAcs.stringByAddingPercentEscapesUsingEncoding(NSUTF8StringEncoding)!
            
        acsList = json.getContentACS(urlStringAcs)
        potenzaTermicaPalazzo = json.getPotenzaTotalePalazzo(self.urlStringPalazzo)
        }
        
        var sort:NSSortDescriptor = NSSortDescriptor(key: "stanza", ascending: true)
        appartamentoSorted = self.appartamentoList.sortedArrayUsingDescriptors([sort])
        
        
        let storyboard = UIStoryboard(name: "TabBar", bundle: nil)
        let vc = storyboard.instantiateViewControllerWithIdentifier("TabBar") as TabBar
        vc.listData = self.appartamentoSorted
        //vc.urlPalazzo = self.urlStringPalazzo
        //vc.urlAbitazione = self.urlStringAppartamento
        //println(self.urlStringAppartamento)
        vc.totaleConsumiPalazzo = Statistic().getTotal(self.palazzoList)
        vc.totaleConsumiAbitazione = Statistic().getTotal(self.appartamentoList)
        if(jsonAppartamento != nil && jsonPalazzo != nil){
            vc.resultAppartamento = jsonAppartamento
            vc.resultPalazzo = jsonPalazzo
        }else{
        vc.resultAppartamento = self.resultAppartamento
        vc.resultPalazzo = self.resultPalazzo
        }
        if(potenzaTotPalazzo != nil){
            vc.potTermicaPalazzo == potenzaTotPalazzo
        }else{
        vc.potTermicaPalazzo = self.potenzaTermicaPalazzo
        }
        vc.inquiliniList = self.listData
        vc.usernameAdmin = self.usernameAdmin
        vc.arrayPercRispPalazzo = self.arrayPercRispPalazzo
        vc.edificiList = self.edificiList
        vc.adminsList = self.adminsList
        vc.listAcs = acsList
        vc.usernameGestore = self.usernameGestore
        vc.inquiliniPianoList = self.inquiliniPianoList
        vc.inquilinoUsername = inquilinoUsername
        self.presentViewController(vc, animated: true, completion: nil)
        
        
    }
    
    
    @IBAction func back(){
        let storyboard = UIStoryboard(name: "EdificiVC", bundle: nil)
        let vc = storyboard.instantiateViewControllerWithIdentifier("EdificiVC") as EdificiViewController
        vc.edificiList = edificiList
        vc.adminsList = adminsList
        vc.arrayPercRispPalazzo = arrayPercRispPalazzo
        if(usernameGestore != nil){
        vc.usernameGestore = usernameGestore
        }
        vc.usernameAmministratore = usernameAdmin
        self.presentViewController(vc, animated: true, completion: nil)

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