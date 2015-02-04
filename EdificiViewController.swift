//
//  EdificiViewController.swift
//  ProvaJoule2
//
//  Created by TSC Consulting on 11/12/14.
//  Copyright (c) 2014 com.tsc. All rights reserved.
//

import Foundation
import UIKit

class EdificiViewController:UIViewController, UITableViewDataSource, UITableViewDelegate {
    
   
    var adminsList:NSArray!
    var edificiList:NSArray!
    var usernameGestore:String!
    var usernameAmministratore:String!
    var arrayPercRispPalazzo:NSMutableArray!
    
     @IBOutlet var buttonLogOut:UIButton!
     @IBOutlet var labelNomeUtente:UILabel!
     @IBOutlet var backButton:UIButton!
    
    override func viewDidLoad(){
        super.viewDidLoad()
        if (usernameGestore != nil){
        labelNomeUtente.text = capitalizeFirstCharacter(usernameGestore)
        }else{
            backButton.hidden = true
            backButton.enabled = false
            labelNomeUtente.text = capitalizeFirstCharacter(usernameAmministratore)
        }
    }
    
    

    //Table view
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return edificiList.count
        
    }

    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let nibName = UINib(nibName: "CustomCell", bundle:nil)
        tableView.registerNib(nibName, forCellReuseIdentifier: "Cell")
        
        let cell = tableView.dequeueReusableCellWithIdentifier("Cell", forIndexPath:indexPath) as CustomCellEdificio
        
      //  cell.sizeThatFits(CGSize(width: width, height: 44))
        var edificio:Edificio = edificiList[indexPath.row] as Edificio
        
        var nomeEdificio = edificio.filename
        
        cell.nomeLbl.text = capitalizeFirstCharacter(nomeEdificio)
        return cell
    }
    
    func tableView (tableView:UITableView, didSelectRowAtIndexPath indexPath:NSIndexPath){
        
        println("you selected row at\(indexPath.row)")
        var row = indexPath.row
        var cell:CustomCellEdificio = tableView.cellForRowAtIndexPath(indexPath) as CustomCellEdificio
        var spinner:UIActivityIndicatorView = UIActivityIndicatorView()
        spinner.activityIndicatorViewStyle = UIActivityIndicatorViewStyle.White
         //spinner.frame = cell.arrow.frame
        cell.accessoryView = spinner
        spinner.startAnimating()
        //cell.arrow.hidden = true
        var timer = NSTimer.scheduledTimerWithTimeInterval(0.1, target: self, selector: Selector("pushDetailView:"), userInfo: indexPath, repeats: false)
        // (0.1, target:self , selector:Selector(pushDetailView(indexPath)), userInfo:nil, repeats:false)
        
        
    }



    
    func pushDetailView (timer:NSTimer){
        
        var path:NSIndexPath = timer.userInfo as NSIndexPath
        
        var edificio:Edificio = edificiList[path.row] as Edificio
        
        println(edificio)
        println(edificio.filename)
        
        var urlNotFormattedInquilini = "http://joule-40.appspot.com/inquilini?edificio="+edificio.filename
        var urlStringInquilini = urlNotFormattedInquilini.stringByAddingPercentEscapesUsingEncoding(NSUTF8StringEncoding)
        var urlInquilini:NSURL = NSURL (string: urlStringInquilini!)!
        
        var json:JsonParser = JsonParser()
        var inquiliniList:NSArray = json.getInquiliniList(urlStringInquilini!)
        
        var sort:NSSortDescriptor = NSSortDescriptor(key: "nome_su_xls", ascending: true)
        var sortedInquilini:NSArray = inquiliniList.sortedArrayUsingDescriptors([sort])
        
        var urlNotFormattedInquiliniPiano = "http://joule-40.appspot.com/utentipiano?palazzo="+edificio.filename
        var urlStringInquiliniPiano = urlNotFormattedInquiliniPiano.stringByAddingPercentEscapesUsingEncoding(NSUTF8StringEncoding)
       
        var inquiliniPianoList:NSArray = json.getInquiliniPianoList(urlStringInquiliniPiano!)
        
        let storyboard = UIStoryboard(name: "InquiliniVC", bundle: nil)
        let vc = storyboard.instantiateViewControllerWithIdentifier("InquiliniVC") as InquiliniViewController
        vc.inquiliniList = sortedInquilini
        vc.inquiliniPianoList = inquiliniPianoList
        vc.adminsList = adminsList
        vc.usernameAdmin = usernameAmministratore
        vc.usernameGestore = usernameGestore
        vc.edificiList = edificiList
        vc.palazzo = edificio.filename
        self.presentViewController(vc, animated: true, completion: nil)
        //self.view.addSubview(edifici.view)

    }
    
    func capitalizeFirstCharacter (toCapitalize:String)->String{
        toCapitalize.lowercaseString
        var str:String = toCapitalize.capitalizedString
        return str
    }
    
    @IBAction func back(){
        let storyboard = UIStoryboard(name: "AdminVC", bundle: nil)
        let vc = storyboard.instantiateViewControllerWithIdentifier("AdminVC") as AdminViewController
        vc.adminsList = adminsList
        if(usernameGestore != nil){
        vc.usernameGestore = usernameGestore
        }else{
            backButton.hidden = true
            backButton.enabled = false
        }
        //super.view.addSubview(vc.view)
        super.presentViewController(vc, animated: true, completion: nil)
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
