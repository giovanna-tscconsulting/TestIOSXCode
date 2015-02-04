
//
//  AdminViewController.swift
//  ProvaJoule2
//
//  Created by TSC Consulting on 10/12/14.
//  Copyright (c) 2014 com.tsc. All rights reserved.
//

import Foundation
import UIKit


class AdminViewController: UIViewController,UITableViewDataSource , UITableViewDelegate{
    
    
    @IBOutlet var tableView:UITableView!

    @IBOutlet var buttonLogOut:UIButton!
    
   
    var adminsList:NSArray!
    var usernameGestore:String!
    @IBOutlet var labelNomeUtente:UILabel!
   
   
    
    
    
    override func viewDidLoad(){
        super.viewDidLoad()
        labelNomeUtente.text = capitalizeFirstCharacter(usernameGestore)
     
}

    //Table view
   
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return adminsList.count
       
    }
    
    
     func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let nibName = UINib(nibName: "CustomCell", bundle:nil)
        tableView.registerNib(nibName, forCellReuseIdentifier: "Cell")
       
        let cell = tableView.dequeueReusableCellWithIdentifier("Cell", forIndexPath:indexPath) as CustomCellEdificio
        
       // cell.sizeThatFits(CGSize(width: width, height: 44))
        var admin:User = adminsList[indexPath.row] as User
        
        var usern = admin.username
       
        cell.nomeLbl.text = capitalizeFirstCharacter(usern)
        
        return cell 
    }
    
    
    func tableView (tableView:UITableView, didSelectRowAtIndexPath indexPath:NSIndexPath){
       
        println("you selected row at\(indexPath.row)")
        println(indexPath)
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
        
        
        var cell:UITableViewCell = tableView.cellForRowAtIndexPath(path)!
    
        println(cell)
        
        var admin:User = adminsList[path.row] as User
        var usernameAdmin = admin.username


        var urlStringNotFormattedEdifici = "http://joule-40.appspot.com/adminpalazzi?amministratore="+usernameAdmin
        var urlStringEdifici = urlStringNotFormattedEdifici.stringByAddingPercentEscapesUsingEncoding(NSUTF8StringEncoding)
        var json:JsonParser = JsonParser()
        //var edificiVC:EdificiViewController = EdificiViewController()
        let storyboard = UIStoryboard(name: "EdificiVC", bundle: nil)
        let vc = storyboard.instantiateViewControllerWithIdentifier("EdificiVC") as EdificiViewController
        vc.edificiList = json.getEdifici(urlStringEdifici!)
        vc.adminsList = adminsList
        vc.usernameGestore = usernameGestore
        vc.usernameAmministratore = usernameAdmin
        self.presentViewController(vc, animated: true, completion: nil)
        //self.view.addSubview(edifici.view)


    }
    
  

    
    func capitalizeFirstCharacter(toCapitalize:String) -> String{
        toCapitalize.lowercaseString
        var str:String = toCapitalize.capitalizedString
        return str
    }
    
    
   @IBAction func logout(sender:UIButton!){
        var button:UIButton = buttonLogOut
        
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