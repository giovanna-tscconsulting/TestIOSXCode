//
//  ViewController.swift
//  ProvaJoule2
//
//  Created by TSC Consulting on 04/12/14.
//  Copyright (c) 2014 com.tsc. All rights reserved.
//

import UIKit
import Foundation



let IS_IPHONE:Bool = UIDevice.currentDevice().userInterfaceIdiom == .Phone
let IS_RETINA = UIScreen.mainScreen().scale >= 2.0
let SCREEN_WIDTH = UIScreen.mainScreen().bounds.size.width
let SCREEN_HEIGHT = UIScreen.mainScreen().bounds.size.height
let SCREEN_MAX_LENGTH = max(SCREEN_WIDTH, SCREEN_HEIGHT)
let SCREEN_MIN_LENGTH = min(SCREEN_WIDTH, SCREEN_HEIGHT)

let IS_IPHONE_4_OR_LESS = IS_IPHONE && SCREEN_MAX_LENGTH < 568.0
let IS_IPHONE_5 = IS_IPHONE && SCREEN_MAX_LENGTH == 568.0
let IS_IPHONE_6 = IS_IPHONE && SCREEN_MAX_LENGTH == 667.0
let IS_IPHONE_6P = IS_IPHONE && SCREEN_MAX_LENGTH == 736.0

class ViewController: UIViewController{
    
    
    var imageView:UIImageView = UIImageView()
    var activityIndicator:UIActivityIndicatorView = UIActivityIndicatorView(activityIndicatorStyle: UIActivityIndicatorViewStyle.WhiteLarge)
    
    var userTextField:UITextField = UITextField()
    var passTextField:UITextField = UITextField()
    
    var canConnect:Bool = false
    
    var width:CGFloat = 0
    var heigth:CGFloat = 0
    var x:CGFloat = 0
    var y:CGFloat = 0
    var wRect:CGFloat = 0
    var hRect:CGFloat = 0
    var buttonLogin:UIButton = UIButton()
    var messageLabel:UILabel = UILabel()
    var errorLabel:UILabel = UILabel()
    var path:String!
    var str:String!
    var us:String!
    var pass:String!
    var check:UIButton!
    var loginTF:UITextField!
    var passTF:UITextField!
    var fileManager:NSFileManager!
    
    @IBOutlet var image:UIImageView!
    @IBOutlet var loginVIew:UIView!
    
    override func awakeFromNib() {
        
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.activityIndicator.stopAnimating()
        self.activityIndicator.hidesWhenStopped = true
        // Do any additional setup after loading the view, typically from a nib.
        
        if(IS_IPHONE_6){
            width = 375
            heigth = 667
            y=600
        }else if (IS_IPHONE_6 && IS_RETINA){
            width = 750
            heigth = 1334
             y = 1246
        }else if(IS_IPHONE_6P){
            width = 540
            heigth = 960
            y = 872
        }else if(IS_IPHONE_6P && IS_RETINA){
            width = 1080
            heigth = 1920
            y = 1832
        }else if(IS_IPHONE_5){
            width = 320
            heigth = 568
            y = 480
        }else if(IS_IPHONE_5 && IS_RETINA){
           width = 640
            heigth = 1136
            y = 1048
        }else if(IS_IPHONE_4_OR_LESS){
            width = 320
            heigth = 480
            y = 392
        }else if(IS_IPHONE_4_OR_LESS && IS_RETINA){
            width = 640
            heigth = 960
            y = 872
        }

        var usernameAmministratore:String!
        
        
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "userLoginSuccessGestore:", name: "ClimagestUserLoginSuccessGestore", object: nil)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "userLoginFailed:", name: "ClimagestUserLoginFailed", object: nil)


       NSNotificationCenter.defaultCenter().addObserver(self, selector: "userLoginSuccessAmministratore:", name: "ClimagestUserLoginSuccessAmministratore", object: nil)
        
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "userLoginSuccessInquilino:", name: "ClimagestUserLoginSuccessInquilino", object: nil)
        
      
        
        
        var frame = CGRectMake(0, 0, 0, 0)
        
        if(IS_IPHONE_4_OR_LESS){
           frame = CGRectMake(0, 0, UIScreen.mainScreen().bounds.size.width, UIScreen.mainScreen().bounds.size.height)
        }else if(IS_IPHONE_5){
            frame = CGRectMake(0, 0, UIScreen.mainScreen().bounds.size.width, UIScreen.mainScreen().bounds.size.height)
        }else if(IS_IPHONE_6){
            frame = CGRectMake(0, 0, UIScreen.mainScreen().bounds.size.width, UIScreen.mainScreen().bounds.size.height)
        }else {
            frame = CGRectMake(0, 0, UIScreen.mainScreen().bounds.size.width, UIScreen.mainScreen().bounds.size.height)
            
        }
        
        var view:UIView = UIView(frame: frame)
        self.view.addSubview(view)
        
        var backgroundImage:UIImage = UIImage(named:"login_bg.png")!
        
        
        image = UIImageView(frame: view.frame)
        image.image = backgroundImage
        
        view.addSubview(image)

        loginVIew = UIView(frame: CGRectMake(60, 200, 250, 200))
        loginVIew.layer.cornerRadius = 8.0
        loginVIew.backgroundColor = UIColor(red: 197/255, green: 164/255, blue: 169/255, alpha: 1)
        loginVIew.center = self.view.center
        
        var loginLabel:UILabel = UILabel(frame: CGRectMake(104, 13, 43, 21))
        loginLabel.text = "Login"
        loginLabel.textColor = UIColor.whiteColor()
        loginVIew.addSubview(loginLabel)
        
        var separator:UIImageView = UIImageView(frame: CGRectMake(0, 36, 250, 1))
        separator.image = UIImage(named: "separator.png")
        loginVIew.addSubview(separator)
        
        loginTF = UITextField(frame: CGRectMake(25, 47, 205, 30))
        loginTF.layer.cornerRadius = 8.0
        loginTF.backgroundColor = UIColor.whiteColor()
        loginTF.placeholder = "Login"
        loginVIew.addSubview(loginTF)
        
        passTF = UITextField(frame: CGRectMake(25, 85, 205, 30))
        passTF.secureTextEntry = true
        passTF.layer.cornerRadius = 8.0
        passTF.backgroundColor = UIColor.whiteColor()
        passTF.placeholder = "Password"
        loginVIew.addSubview(passTF)
        
        check = UIButton(frame: CGRectMake(25, 129, 22, 21))
        var imageSel:UIImage = UIImage(named: "checked_checkbox.png")!
        check.addGestureRecognizer(UITapGestureRecognizer(target: self, action: "changeImage:"))
        //check.setBackgroundImage(imageSel, forState: UIControlState.Highlighted)
        var imageNotSel:UIImage = UIImage(named: "unchecked_checkbox.png")!
        check.setImage(imageNotSel, forState: UIControlState.Normal)
        loginVIew.addSubview(check)
        
        var memLabel:UILabel = UILabel(frame: CGRectMake(58, 129, 152, 21))
        memLabel.text = "Memorizza le credenziali"
        memLabel.font = UIFont(name: "HelveticaNeue", size: 13.0)
        memLabel.textColor = UIColor.whiteColor()
        loginVIew.addSubview(memLabel)
        
        var separator2:UIImageView = UIImageView(frame: CGRectMake(0, 160, 250, 1))
        separator2.image = UIImage(named: "separator.png")
        loginVIew.addSubview(separator2)
        
        var cancButton:UIButton = UIButton(frame: CGRectMake(0, 162, 125, 30))
        cancButton.setTitle("Cancel", forState: UIControlState.Normal)
        cancButton.setTitleColor(UIColor.whiteColor(), forState: UIControlState.Normal)
        cancButton.addTarget(self, action: "cancelAction:", forControlEvents: UIControlEvents.TouchUpInside)
        loginVIew.addSubview(cancButton)
        
        
        var okButton:UIButton = UIButton(frame: CGRectMake(125, 162, 125, 30))
        okButton.setTitle("OK", forState: UIControlState.Normal)
        okButton.setTitleColor(UIColor.whiteColor(), forState: UIControlState.Normal)
        okButton.addTarget(self, action: "okAction:", forControlEvents: UIControlEvents.TouchUpInside)
        loginVIew.addSubview(okButton)
       
        var loginWidth:CGFloat = 86
        buttonLogin = UIButton.buttonWithType(UIButtonType.System) as UIButton
        buttonLogin.frame = CGRectMake((UIScreen.mainScreen().bounds.size.width/2)-(loginWidth/2), UIScreen.mainScreen().bounds.size.height - 88, loginWidth, 20)
        buttonLogin.backgroundColor = UIColor(red: 226/255, green: 96/255, blue: 108/255, alpha: 1)
        buttonLogin.setTitle("LOGIN", forState: UIControlState.Normal)
        buttonLogin.setTitleColor(UIColor.whiteColor(), forState: UIControlState.Normal)
        buttonLogin.addTarget(self, action: "buttonClicked:", forControlEvents: UIControlEvents.TouchUpInside)
        self.view.addSubview(buttonLogin)
        
        
        errorLabel.frame = CGRectMake((UIScreen.mainScreen().bounds.size.width/2)-130, UIScreen.mainScreen().bounds.size.height-88-11-60, 260, 60)
        errorLabel.text = "Non è stato possibile autenticarsi"
        errorLabel.textColor = UIColor.whiteColor()
        errorLabel.hidden = true
        self.view.addSubview(errorLabel)
        
        activityIndicator.frame = CGRectMake((UIScreen.mainScreen().bounds.size.width/2)-25, UIScreen.mainScreen().bounds.size.height-88-71-25, 50, 50)
        activityIndicator.hidden = true
        self.view.addSubview(activityIndicator)
        
       
        messageLabel.frame = CGRectMake((UIScreen.mainScreen().bounds.size.width/2)-130,30, 260, 30)
        messageLabel.text = "Recupero informazioni in corso"
        messageLabel.textColor = UIColor.whiteColor()
        messageLabel.hidden = true
        self.view.addSubview(messageLabel)
        
        //showAlertForLogin()
    
        
        
        let paths = NSSearchPathForDirectoriesInDomains(NSSearchPathDirectory.DocumentDirectory, .UserDomainMask, true) as NSArray
        let documentsDirectory = paths[0] as NSString
        path = documentsDirectory.stringByAppendingPathComponent("MyFile9.plist")
        /*
        let fileManager = NSFileManager.defaultManager()
        //fileManager.createFileAtPath(path, contents: nil, attributes: nil)
       */
    
        
       fileManager = NSFileManager.defaultManager()
        if(!fileManager.fileExistsAtPath(path)){
            fileManager.createFileAtPath(path, contents: nil, attributes: nil)
            showAlertForLogin()
        
        }else {
            var cl:ClimagestLogin = ClimagestLogin()
            var fileContent:NSData
            fileContent = fileManager.contentsAtPath(path)!
            str = NSString (data: fileContent, encoding: NSUTF8StringEncoding)
            if(str == ""){
                showAlertForLogin()
            }else{
            us = str.componentsSeparatedByString("_")[0]
            pass = str.componentsSeparatedByString("_")[1]
            cl.startLogin(us, password: pass)
            }
       }
        
        
       
       

        
       // showAlertForLogin()
    }
    


    func changeImage(recognizer:UITapGestureRecognizer){
        var imageSel:UIImage = UIImage(named: "checked_checkbox.png")!
        check.selected = true
        check.setImage(imageSel, forState:UIControlState.Normal)
        check.addGestureRecognizer(UITapGestureRecognizer(target: self, action: "changeImageTwo:"))
    }
    
    func changeImageTwo(recognizer:UITapGestureRecognizer){
        var imageNotSel:UIImage = UIImage(named: "unchecked_checkbox.png")!
        check.selected = false
        check.setImage(imageNotSel, forState:UIControlState.Normal)
        check.addGestureRecognizer(UITapGestureRecognizer(target: self, action: "changeImage:"))
    }
    
    func cancelAction(sender:UIButton){
        var button:UIButton = sender
        buttonLogin.enabled = true
        loginVIew.removeFromSuperview()
        
    }
    
    func okAction (sender:UIButton){
        var button:UIButton = sender
        self.userTextField = loginTF
        self.passTextField = passTF
        self.activityIndicator.startAnimating()
        self.messageLabel.hidden = false
        buttonLogin.enabled = false
        println(self.userTextField.text)
        println(self.passTextField.text)
        loginVIew.removeFromSuperview()
        var cred:String = self.userTextField.text+"_"+self.passTextField.text
        if(check.selected){
            var content:NSData = cred.dataUsingEncoding(NSUTF8StringEncoding, allowLossyConversion: true)!
            content.writeToFile(path, atomically: true)
        }
        var cl:ClimagestLogin = ClimagestLogin()
        cl.startLogin(self.userTextField.text, password: self.passTextField.text)
    }

    

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    func buttonClicked(sender:UIButton){
        var button:UIButton = sender
        showAlertForLogin()
    }
    
    
    func showAlertForLogin(){
        var alertMessage:String = "Login"
        self.messageLabel.hidden = true
        var loginAlert:UIAlertView = UIAlertView(frame: CGRectMake(0, 0, 150, 100))
        loginAlert.delegate = self
        loginAlert.title = alertMessage
        loginAlert.cancelButtonIndex = 0
        loginAlert.addButtonWithTitle("Cancel")
        loginAlert.addButtonWithTitle("OK")
        loginAlert.alertViewStyle = UIAlertViewStyle.LoginAndPasswordInput
        loginAlert.tag = 1
        
        //loginAlert.show()
        self.view.addSubview(loginVIew)
    }


        
    func alertView (loginAlert:UIAlertView! , clickedButtonAtIndex buttonIndex: Int){
        if (buttonIndex == 0){
            buttonLogin.enabled = true
        }
        else{
            self.userTextField = loginAlert.textFieldAtIndex(0)!
            self.passTextField = loginAlert.textFieldAtIndex(1)!
            self.activityIndicator.startAnimating()
            self.messageLabel.hidden = false
            buttonLogin.enabled = false
            println(self.userTextField.text)
            println(self.passTextField.text)
            var cred:String = self.userTextField.text+"_"+self.passTextField.text
            var content:NSData = cred.dataUsingEncoding(NSUTF8StringEncoding, allowLossyConversion: true)!
            content.writeToFile(path, atomically: true)
            var cl:ClimagestLogin = ClimagestLogin()
            cl.startLogin(self.userTextField.text, password: self.passTextField.text)
        }
        
    }
    
    func userLoginFailed (notification:NSNotification){
        canConnect=false
        self.activityIndicator.stopAnimating()
        self.messageLabel.hidden = true
        self.errorLabel.hidden = false
        buttonLogin.enabled = true
        println("Impossibile effettuare il login")
    }
    
    
    func userLoginSuccessGestore (notification:NSNotification){
        
        self.activityIndicator.stopAnimating()
        self.messageLabel.hidden = true
        
        var username:String = self.userTextField.text
        
        var urlStringNotFormattedAdmin:String = "http://joule-40.appspot.com/admin"
        println(urlStringNotFormattedAdmin)
        
        var urlStringAdmin = urlStringNotFormattedAdmin.stringByAddingPercentEscapesUsingEncoding(NSUTF8StringEncoding)!
        println(urlStringAdmin)
        
        let urlS = NSString(format: urlStringAdmin)
        
        var url:NSURL = NSURL(string: urlS)!
        println(url)
        
        
        var resultAdmin:String = String (contentsOfURL: url, encoding: NSUTF8StringEncoding, error: nil)!
        println(resultAdmin)
        
        let json = JsonParser()
        var adminList:NSArray = json.getAdminsList(urlS)
        var sort:NSSortDescriptor = NSSortDescriptor(key: "username", ascending: true)
        
        var sortedAdmins:NSArray = adminList.sortedArrayUsingDescriptors([sort])
        
        
        var adminVC:AdminViewController = AdminViewController()
        let storyboard = UIStoryboard(name: "AdminVC", bundle: nil)
        let vc = storyboard.instantiateViewControllerWithIdentifier("AdminVC") as AdminViewController
        
        vc.adminsList = sortedAdmins
        if(username != ""){
          vc.usernameGestore = username
        }else{
            vc.usernameGestore = us
        }
        
        self.presentViewController(vc, animated: true, completion: nil)
       
    }
    
    
   
    
    
    func userLoginSuccessAmministratore (notification:NSNotification){
        
        self.activityIndicator.stopAnimating()
        self.messageLabel.hidden = true
        
        var username:String = self.userTextField.text
        
        //l'amministratore vede la lista solo dei suoi edifici
        
      
        var urlStringNotFormattedEdifici = "http://joule-40.appspot.com/adminpalazzi?amministratore="+username
        var urlStringEdifici = urlStringNotFormattedEdifici.stringByAddingPercentEscapesUsingEncoding(NSUTF8StringEncoding)
        var json:JsonParser = JsonParser()
       
        let storyboard = UIStoryboard(name: "EdificiVC", bundle: nil)
        let vc = storyboard.instantiateViewControllerWithIdentifier("EdificiVC") as EdificiViewController
        vc.edificiList = json.getEdifici(urlStringEdifici!)
        vc.usernameAmministratore = username
        //self.view.addSubview(vc.view)
        self.presentViewController(vc, animated: true, completion: nil)
        

    }
    
    
    func userLoginSuccessInquilino (notification:NSNotification){
        
        self.activityIndicator.stopAnimating()
        self.messageLabel.hidden = true
        
        var username:String = self.userTextField.text
        
        //l'inquilino vede solo i suoi consumi
        
        
        var urlStringNotFormattedAppartamento:String = "http://joule-40.appspot.com/appartamento?username="+username
        var urlStringAppartamento:String = urlStringNotFormattedAppartamento.stringByAddingPercentEscapesUsingEncoding(NSUTF8StringEncoding)!
        var urlAppartamento:NSURL = NSURL(string: urlStringAppartamento)!
        var resultAppartamento:String = String (contentsOfURL: urlAppartamento, encoding: NSUTF8StringEncoding, error: nil)!
        
        
        var json:JsonParser = JsonParser()
        
        var appartamentoList:NSArray = json.getAppartamentoList(urlStringAppartamento, num: 0)
        
        var sort:NSSortDescriptor = NSSortDescriptor(key: "stanza", ascending: true)
        var appartamentoSorted:NSArray = appartamentoList.sortedArrayUsingDescriptors([sort])
        
        var urlStringNotFormattedPalazzo:String = "http://joule-40.appspot.com/palazzo?username="+username
        var urlStringPalazzo:String = urlStringNotFormattedPalazzo.stringByAddingPercentEscapesUsingEncoding(NSUTF8StringEncoding)!
        var urlPalazzo:NSURL = NSURL (string: urlStringPalazzo)!
        var resultPalazzo:String = String (contentsOfURL: urlPalazzo, encoding: NSUTF8StringEncoding, error: nil)!
        
        var palazzoList:NSArray = json.getContentPalazzo(urlStringPalazzo, withMonth: 0)
        
        var potenzaTermicaPalazzo:NSNumber = json.getPotenzaTotalePalazzo(urlStringPalazzo)
        
        
        var urlStringNotFormattedAcs:String = "http://joule-40.appspot.com/appartamentoacqua?username="+username
        var urlStringAcs:String = urlStringNotFormattedAcs.stringByAddingPercentEscapesUsingEncoding(NSUTF8StringEncoding)!
        
        var acsList:NSArray = json.getContentACS(urlStringAcs)
        
        let storyboard = UIStoryboard(name: "TabBar", bundle: nil)
        let vc = storyboard.instantiateViewControllerWithIdentifier("TabBar") as TabBar
        vc.listData = appartamentoSorted
        vc.urlPalazzo = urlStringPalazzo
        vc.urlAbitazione = urlStringAppartamento
        println(urlStringAppartamento)
        vc.totaleConsumiPalazzo = Statistic().getTotal(palazzoList)
        vc.totaleConsumiAbitazione = Statistic().getTotal(appartamentoList)
        vc.resultAppartamento = resultAppartamento
        vc.resultPalazzo = resultPalazzo
        vc.potTermicaPalazzo = potenzaTermicaPalazzo
        vc.listAcs = acsList
        vc.inquilinoUsername = username
        self.presentViewController(vc, animated: true, completion: nil)
        
        
        
        
        
    }


    
    
    
    
   
   
    
    

    

}
    
    






