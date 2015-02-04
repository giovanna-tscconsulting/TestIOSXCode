//
//  PieChartViewController.swift
//  ProvaJoule2
//
//  Created by TSC Consulting on 08/01/15.
//  Copyright (c) 2015 com.tsc. All rights reserved.
//

import Foundation
import UIKit


class PieChartViewController:UIViewController{
    var listData:NSArray!
    var totalePalazzo:NSNumber!
    var totaleAbitazione:NSNumber!
    var jsonAppartamento:NSString!
    var jsonPalazzo:NSString!
    var listInquilini:NSArray!
    var usernameAdmin:String!
    var usernameGestore:String!
    var inquilinoUsername:String!
    var monthInitializer:NSNumber!
    var arrayPercRispPalazzo:NSMutableArray!
    var edificiList:NSArray!
    var inquiliniPianoList:NSArray!
    var potTermicaPalazzo:NSNumber!
    var listAdmins:NSArray!
    var listAcs:NSArray!
    var urlPalazzo:String!
    var urlAbitazione:String!
   
    
    var bigPieChart:OTPieChart!
    @IBOutlet var bigPieChartArea:UIView!
    @IBOutlet var detailSubview:UIView!
    @IBOutlet var userLabel:UILabel!
    @IBOutlet var userLabel2:UILabel!
    @IBOutlet var stanzaUpperLabel:UILabel!
    @IBOutlet var stanzaTotalValueLabel:UILabel!
    @IBOutlet var stanzaDetailGrayView:UIView!
    @IBOutlet var stanzaTitle:UILabel!
    @IBOutlet var stanzaDetailButtonImage:UIImageView!
    @IBOutlet var prevMonthBtn:UIButton!
    @IBOutlet var nextMonthBtn:UIButton!
    @IBOutlet var logoutButton:UIButton!
    @IBOutlet var monthLbl:UILabel!
    @IBOutlet var consumoLbl:UILabel!
    @IBOutlet var lettureAssentiLbl:UILabel!
    @IBOutlet var backButton:UIButton!
    
      @IBOutlet var piechartButtons:Array<UIButton>!
    
    
    
    var month_pie:Int = 0
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        println(urlAbitazione)
        if(usernameGestore != nil){
        userLabel.text = capitalizeFirstCharacter (usernameGestore)
        }else if(usernameAdmin != nil){
            userLabel.text = capitalizeFirstCharacter(usernameAdmin)
        }else{
            userLabel.text = capitalizeFirstCharacter(inquilinoUsername)
            backButton.enabled = false
            backButton.hidden = true
        }
        month_pie = Int(monthInitializer)
        piechartButtons = Array<UIButton>()
        nextMonthBtn.enabled = false
        generatePie()
        bigPieChartArea.bringSubviewToFront(logoutButton)
        
    }
    
    func generatePie(){
        var tableRow:Stanza = listData[0] as Stanza
        userLabel2.text = capitalizeFirstCharacter(tableRow.utente)
        updateConsumo()
        
        //*************************************************
        //GET THE ARRAY OF VALUES
        //*************************************************
        
        //sort the array using letturaAttuale
        var sortDescriptor:NSSortDescriptor = NSSortDescriptor(key: "letturaAttuale", ascending: true)
        var sortDescriptors:NSArray = NSArray(object: sortDescriptor)
        var sortedArray:NSArray = listData.sortedArrayUsingDescriptors(sortDescriptors)
        
         //dateformatter per visualizzare la data nel formato mese.anno
        var dateFormatter:NSDateFormatter = NSDateFormatter()
        dateFormatter.dateFormat = "MM.yyyy"
        
        var valuesMutable:NSMutableArray = NSMutableArray()
        
        //utilizza i valori dell'array ordinato
        var i:Int
        
        for(i = 0; i < sortedArray.count; i++){
            var tableRow:Stanza = sortedArray[i] as Stanza
            valuesMutable.addObject(tableRow.letturaAttuale)
            monthLbl.text = NSString (format: "%@", dateFormatter.stringFromDate(tableRow.dataLettura))
        }
        var values:NSArray = NSArray(array: valuesMutable)
        
        
        //*************************************************
        //GET THE PARAMETERS
        //*************************************************
        //elimina il bordo degli spicchi se non ci sono dati da visuallizzare
        var alphaValue:Float = 1.0
        if(totaleAbitazione.intValue == 0){
            alphaValue = 0.0
        }
        var parameters:NSDictionary
       
        var xVar = self.bigPieChartArea.bounds.size.width / 2.0 as CGFloat
        
        var yVar2:CGFloat = 0.0
        if(UIScreen.mainScreen().bounds.size.height < 500){
             self.bigPieChartArea.frame = CGRectMake(0, 161, UIScreen.mainScreen().bounds.size.width, UIScreen.mainScreen().bounds.size.height - 235.0)
              yVar2 = self.bigPieChartArea.bounds.size.height / 2.0 - 7.0 as CGFloat
        }
        
        var yVar:CGFloat = 0.0
        var xVar2:CGFloat = 0.0
        if(UIScreen.mainScreen().bounds.size.height == 568){
            self.bigPieChartArea.frame = CGRectMake(0, 161, UIScreen.mainScreen().bounds.size.width, UIScreen.mainScreen().bounds.size.height - 235.0)
            yVar = self.bigPieChartArea.bounds.size.height / 2.0 as CGFloat
            xVar2 = self.bigPieChartArea.bounds.size.width / 2.0 as CGFloat
        }
       
        
        
        
        var yVar3:CGFloat = 0.0
        if(UIScreen.mainScreen().bounds.size.height == 667){
            self.bigPieChartArea.frame = CGRectMake(0, 161, 400, UIScreen.mainScreen().bounds.size.height - 193.0)
            yVar3 = self.bigPieChartArea.frame.height / 2 - 25 as CGFloat
        }
        
        var yVar4:CGFloat = 0.0
        if(UIScreen.mainScreen().bounds.size.height > 667){
            self.bigPieChartArea.frame = CGRectMake(0, 161, UIScreen.mainScreen().bounds.size.width, UIScreen.mainScreen().bounds.size.height - 235.0)
            yVar4 = self.bigPieChartArea.bounds.size.height / 2.0 as CGFloat
        }

        
        if(UIScreen.mainScreen().bounds.size.height == 568){
            println(self.bigPieChartArea.bounds.size)
            
            parameters = [
            "x": xVar2,
            "y":yVar,
            "radius": 130,
            "big_radius":140,
            "borders_color": UIColor(red: CGFloat(0.60), green: CGFloat(0.67), blue: CGFloat(0.83), alpha: CGFloat(alphaValue)),
            "outter_gradient_start_color":  UIColor(red: CGFloat(0.48), green: CGFloat(0.97), blue: CGFloat(0.80), alpha: CGFloat(1.0)),
            "outter_gradient_end_color": UIColor(red: CGFloat(0.48), green: CGFloat(0.97), blue: CGFloat(0.80), alpha: CGFloat(1.0)),
            "inner_gradient_start_color": UIColor(red: CGFloat(0.97), green: CGFloat(1.0), blue: CGFloat(0.95), alpha: CGFloat(1.0)),
            "inner_gradient_end_color": UIColor(red:CGFloat(0.36), green: CGFloat(0.81), blue: CGFloat(0.38), alpha: CGFloat(1.0)),
            "line_width":0.35]
           
        }else if(UIScreen.mainScreen().bounds.size.height == 667){
            println("bounds iphone 6")
            println(self.bigPieChartArea.bounds.size)
            parameters = [
                "x": CGFloat(UIScreen.mainScreen().bounds.size.width / 2),
                "y":yVar3,
                "radius": 150,
                "big_radius":160,
                "borders_color": UIColor(red: CGFloat(0.60), green: CGFloat(0.67), blue: CGFloat(0.83), alpha: CGFloat(alphaValue)),
                "outter_gradient_start_color":  UIColor(red: CGFloat(0.48), green: CGFloat(0.97), blue: CGFloat(0.80), alpha: CGFloat(1.0)),
                "outter_gradient_end_color": UIColor(red: CGFloat(0.48), green: CGFloat(0.97), blue: CGFloat(0.80), alpha: CGFloat(1.0)),
                "inner_gradient_start_color": UIColor(red: CGFloat(0.97), green: CGFloat(1.0), blue: CGFloat(0.95), alpha: CGFloat(1.0)),
                "inner_gradient_end_color": UIColor(red:CGFloat(0.36), green: CGFloat(0.81), blue: CGFloat(0.38), alpha: CGFloat(1.0)),
                "line_width":0.35]
            
        }else if(UIScreen.mainScreen().bounds.size.height > 667){
                println("bounds iphone 6plus")
                println(self.bigPieChartArea.bounds.size)
                parameters = [
                    "x": CGFloat(UIScreen.mainScreen().bounds.size.width / 2),
                    "y":yVar4,
                    "radius": 160,
                    "big_radius":170,
                    "borders_color": UIColor(red: CGFloat(0.60), green: CGFloat(0.67), blue: CGFloat(0.83), alpha: CGFloat(alphaValue)),
                    "outter_gradient_start_color":  UIColor(red: CGFloat(0.48), green: CGFloat(0.97), blue: CGFloat(0.80), alpha: CGFloat(1.0)),
                    "outter_gradient_end_color": UIColor(red: CGFloat(0.48), green: CGFloat(0.97), blue: CGFloat(0.80), alpha: CGFloat(1.0)),
                    "inner_gradient_start_color": UIColor(red: CGFloat(0.97), green: CGFloat(1.0), blue: CGFloat(0.95), alpha: CGFloat(1.0)),
                    "inner_gradient_end_color": UIColor(red:CGFloat(0.36), green: CGFloat(0.81), blue: CGFloat(0.38), alpha: CGFloat(1.0)),
                    "line_width":0.35]
            
            
        }else{
            parameters = [
                "x": CGFloat(UIScreen.mainScreen().bounds.size.width / 2),
                "y":yVar2,
                "radius": 100,
                "big_radius":110,
                "borders_color": UIColor(red: CGFloat(0.60), green: CGFloat(0.67), blue: CGFloat(0.83), alpha: CGFloat(alphaValue)),
                "outter_gradient_start_color":  UIColor(red: CGFloat(0.48), green: CGFloat(0.97), blue: CGFloat(0.80), alpha: CGFloat(1.0)),
                "outter_gradient_end_color": UIColor(red: CGFloat(0.48), green: CGFloat(0.97), blue: CGFloat(0.80), alpha: CGFloat(1.0)),
                "inner_gradient_start_color": UIColor(red: CGFloat(0.97), green: CGFloat(1.0), blue: CGFloat(0.95), alpha: CGFloat(1.0)),
                "inner_gradient_end_color": UIColor(red:CGFloat(0.36), green: CGFloat(0.81), blue: CGFloat(0.38), alpha: CGFloat(1.0)),
                "line_width":0.35]

        }
        
        //*************************************************
        //FRAME
        //*************************************************
        
        if(UIScreen.mainScreen().bounds.size.height == 667){
            self.bigPieChartArea.frame = CGRectMake(0, 161, 400, UIScreen.mainScreen().bounds.size.height - 193.0)
            
        }
        
        var piechartRect:CGRect = self.bigPieChartArea.bounds
        
       
        //*************************************************
        //CREATE PIECHART
        //*************************************************
        var pieChartTemp:OTPieChart = OTPieChart (frame: piechartRect, parameters_:parameters, values_:values)
        pieChartTemp.backgroundColor = UIColor.clearColor()
        bigPieChart = pieChartTemp
        
        //add subview
        bigPieChartArea.addSubview(bigPieChart)
        
        //*************************************************
        //ADD BUTTONS
        //*************************************************
        var height:CGFloat = 0.0
        var referencePoints:NSArray = bigPieChart.getReferencePointsArray()
        
        if(totaleAbitazione.intValue != 0){
            lettureAssentiLbl.hidden = true
            var i:Int
            for(i = 0; i < sortedArray.count; i++){
                var tableRow:Stanza = sortedArray[i] as Stanza
                if(tableRow.letturaAttuale.intValue != 0){
                    var arrowImage:UIImageView = UIImageView(image: UIImage(named: "NewsRowBackground_arrow.png"))
                    
                    //Get reference point
                    var referencePoint:CGPoint =  (referencePoints[i] as NSValue).CGPointValue()
                    
                    //Create and position the button
                    var labelFont:UIFont = UIFont(name: "HelveticaNeue-Bold", size: 10)!
                    var stanzaId:String = NSString (format: "%@", tableRow.stanza)
                   // CGSize labelSize = [stanzaId sizeWithFont:labelFont];
                    var labelSize:CGSize = stanzaId.sizeWithAttributes([NSFontAttributeName: labelFont])
                    labelSize.width += arrowImage.frame.size.width
                    var labelRect:CGRect = CGRectMake(referencePoint.x, referencePoint.y, labelSize.width, labelSize.height+5.0)
                    labelRect.origin.x -= labelRect.size.width / 2.0
                    labelRect.origin.y -= labelRect.size.height / 2.0
                    
                    if(labelRect.origin.x < 0.0){
                        labelRect.origin.x < 0.0
                    }
                    if(labelRect.origin.y < 0.0){
                        labelRect.origin.y < 0.0
                    }
                    labelRect.origin.x = ceil(labelRect.origin.x)
                    labelRect.origin.y = ceil(labelRect.origin.y)
                    
                    
                     //Create the button and set it up!
                    let stanzaButton:UIButton = UIButton.buttonWithType(UIButtonType.Custom) as UIButton
                    stanzaButton.frame = labelRect
                    stanzaButton.setTitle(stanzaId, forState: UIControlState.Normal)
                    stanzaButton.titleLabel?.font = labelFont
                    
                    stanzaButton.addTarget(self, action: "graphButton:", forControlEvents: UIControlEvents.TouchUpInside)
    
                    stanzaButton.setTitleColor(UIColor(red: CGFloat(0.2), green: CGFloat(0.2), blue: CGFloat(0.2), alpha: CGFloat(1.0)), forState: UIControlState.Normal)
                    stanzaButton.setTitleColor(UIColor(red: CGFloat(0.2), green: CGFloat(0.2), blue: CGFloat(0.2), alpha: CGFloat(1.0)), forState: UIControlState.Highlighted)
                    stanzaButton.setTitleColor(UIColor(red: CGFloat(0.2), green: CGFloat(0.2), blue: CGFloat(0.2), alpha: CGFloat(1.0)), forState: UIControlState.Disabled)
                    stanzaButton.setTitleColor(UIColor(red: CGFloat(0.2), green: CGFloat(0.2), blue: CGFloat(0.2), alpha: CGFloat(1.0)), forState: UIControlState.Selected)
                    stanzaButton.tag = i
                    
                    var arrowRect:CGRect = arrowImage.frame
                    arrowRect.origin.x = stanzaButton.frame.size.width - arrowRect.size.width - 3.0
                    arrowRect.size.height = stanzaButton.frame.size.height
                    
                   
                    bigPieChartArea.addSubview(stanzaButton)   
                    piechartButtons.insert(stanzaButton, atIndex: i)
                    height += labelSize.height + 5.0
                    
                }
                
            }
            
            
            var arrowImage:UIImageView = UIImageView (image: UIImage(named: "NewsRowBackground_arrow.png"))
            
            //Create and position the button
            var labelFont:UIFont = UIFont(name: "HelveticaNeue-Bold", size: 12)!
            var labelSize:CGSize = "CONSUMO".sizeWithAttributes([NSFontAttributeName: labelFont])
            labelSize.width += arrowImage.frame.size.width
            var labelRect:CGRect = CGRectMake(295, 100, labelSize.width+10.0, labelSize.height+5.0)
            labelRect.origin.x -= labelRect.size.width
            labelRect.origin.y -= labelRect.size.height / 2.0
            
            if(labelRect.origin.x < 0.0){
                labelRect.origin.x < 0.0
            }
            if(labelRect.origin.y < 0.0){
                labelRect.origin.y < 0.0
            }
            labelRect.origin.x = ceil(labelRect.origin.x)
            labelRect.origin.y = ceil(labelRect.origin.y)
            }else{
            lettureAssentiLbl.hidden = false
        }
        
    }
    


    
     func graphButton(sender:UIButton!){
        
        detailSubview.removeFromSuperview()
        var button:UIButton = sender
        
        //sort the array using letturaAttuale
        var sortDescriptor:NSSortDescriptor = NSSortDescriptor(key: "letturaAttuale", ascending: true)
        var sortDescriptors:NSArray = NSArray(object: sortDescriptor)
        var sortedArray:NSArray = listData.sortedArrayUsingDescriptors(sortDescriptors)
        var stanza:Stanza = sortedArray[button.tag] as Stanza
        
        var value:String = NSString(format: "%0.2f%%", stanza.letturaAttuale.floatValue*100 / totaleAbitazione.floatValue)
        var subviewPrice:String = NSString(format: "%@", value)
        
        stanzaTotalValueLabel.text = subviewPrice
        var dateFormatter:NSDateFormatter = NSDateFormatter()
        dateFormatter.dateFormat = "MM.yyyy"
        
        stanzaUpperLabel.text = NSString (format: "%@", dateFormatter.stringFromDate(stanza.dataLettura))
        stanzaTitle.text = NSString (format: "%@", stanza.stanza)
        
        detailSubview.center = button.center
        detailSubview.alpha = 0.0
        bigPieChartArea.addSubview(detailSubview)
        
        var viewPos:CGRect = detailSubview.frame
        viewPos.origin.x = ceil(viewPos.origin.x)
        viewPos.origin.y = ceil(viewPos.origin.y)
        
        var margin:CGFloat = 10.0
        if(viewPos.origin.x < margin){
            viewPos.origin.x = margin
        }else if (viewPos.origin.x + viewPos.size.width > bigPieChartArea.frame.size.width - margin){
            viewPos.origin.x = bigPieChartArea.frame.size.width - viewPos.size.width - margin
        }
        
        if(viewPos.origin.y < margin){
            viewPos.origin.y = margin
        }else if (viewPos.origin.y + viewPos.size.height > bigPieChartArea.frame.size.height - margin){
            viewPos.origin.y = bigPieChartArea.frame.size.height - viewPos.size.height - margin
        }
        
        detailSubview.frame = viewPos
        
        UIView.animateWithDuration(0.2, animations: { () -> Void in
            self.detailSubview.alpha = 1.0;
            });


    }
    
    
    func updateConsumo(){
        var value:String = NSString (format: "%0.2f%%", totaleAbitazione.floatValue*100 / totalePalazzo.floatValue)
        var subviewPrice:String = NSString (format: "%@", value)
        consumoLbl.text = NSString (format: "Consumo: ", subviewPrice)
        //consumoLbl.text = subviewPrice
        
        var potTermicaAbitazione:NSNumber = getPotTermicaAbitazione(listData)
        var consumoMedioEdificio:NSNumber = NSNumber (float: totalePalazzo.floatValue / potTermicaPalazzo.floatValue)
        var consumoMedioAppartamento:NSNumber = NSNumber (float: totaleAbitazione.floatValue / potTermicaAbitazione.floatValue)
        var consumoAppartamentoSuEdificio:NSNumber = NSNumber (float: totaleAbitazione.floatValue / totalePalazzo.floatValue)
        
        if(consumoMedioAppartamento.floatValue > (consumoMedioEdificio.floatValue * 1.35) || (consumoAppartamentoSuEdificio.floatValue <= 0.00099)){
            consumoLbl.textColor = UIColor(red: 0.75, green: 0.0, blue: 0.0, alpha: 1.0)
        }else if (consumoMedioAppartamento.floatValue >= (consumoMedioEdificio.floatValue*1.25) && (consumoMedioAppartamento.floatValue <= consumoMedioEdificio.floatValue*0.35)){
            consumoLbl.textColor = UIColor(red: 0.9, green: 0.8, blue: 0.27, alpha: 1.0)
        }else{
            consumoLbl.textColor = UIColor(red: 0.0, green: 0.75, blue: 0.0, alpha: 1.0)
        }
        
        consumoLbl.text = subviewPrice
    }
    
    func getPotTermicaAbitazione (locali:NSArray) -> NSNumber{
        var totale:NSNumber = NSNumber(float: 0.0)
        for stanza:AnyObject in locali  {
            let s = stanza as Stanza
            totale = NSNumber (float: totale.floatValue +  s.wattInstallati.floatValue)
        }
        
        return totale
    }
    
    
    func capitalizeFirstCharacter(toCapitalize:String) -> String{
        toCapitalize.lowercaseString
        var str:String = toCapitalize.capitalizedString
        return str
    }
    
    @IBAction func subviewBackgroundTouched (sender:AnyObject){
        
        UIView.animateWithDuration(0.2, animations: { () -> Void in
            self.detailSubview.alpha = 0.0
        }) { (finished) -> Void in
            if(finished){

                self.detailSubview.removeFromSuperview()
            }
        }
 }
    
    @IBAction func goToUSerListView(){
        
        let storyboard = UIStoryboard(name: "UserListVC", bundle: nil)
        let vc = storyboard.instantiateViewControllerWithIdentifier("UserListVC") as UserListViewController
        vc.listData = self.listData
        vc.totaleConsumiPalazzo = totalePalazzo
        self.view.addSubview(vc.view)
        
    }
    
    func convertExcelDate(excelFormatDate:NSNumber) -> NSString {
        var date:NSDate = NSDate (timeIntervalSince1970: NSTimeInterval((excelFormatDate.integerValue + 24142) * 86400))
        var dateFormat:NSDateFormatter = NSDateFormatter()
        dateFormat.dateFormat = "MM.yyyy"
        var dateString:NSString = dateFormat.stringFromDate(date)
        return dateString
        
    }
    
    @IBAction func back(){
        month_pie = 0
        let storyboard = UIStoryboard(name: "InquiliniVC", bundle: nil)
        let vc = storyboard.instantiateViewControllerWithIdentifier("InquiliniVC") as InquiliniViewController
        vc.usernameAdmin = usernameAdmin
        vc.listData = listInquilini
        vc.arrayPercRispPalazzo = arrayPercRispPalazzo
        vc.edificiList = edificiList
        if(usernameGestore != nil){
        vc.usernameGestore = usernameGestore
        }else if(usernameAdmin != nil){
            vc.usernameAdmin = usernameAdmin
        }
        vc.adminsList = listAdmins
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
    
    
    //resetta la view per mostrare i valori relativi al mese precedente
    @IBAction func previousMonth(){
         //rimuove la view del "vecchio" grafico a torta e dei suoi bottoni
        self.bigPieChart.removeFromSuperview()
        self.detailSubview.removeFromSuperview()
        for v:AnyObject in self.bigPieChartArea.subviews{
            let view:UIView = v as UIView
            view.removeFromSuperview()
        }
        
         //riabilita il bottone per il mese successivo
        nextMonthBtn.enabled = true
        var tableRow:Stanza = listData[0] as Stanza
        if((month_pie+1) < tableRow.arrayLetture.count){
            
            //aggiorna il mese corrente e recupera i valori ad esso relativi
            month_pie = month_pie + 1
            var json:JsonParser = JsonParser()
            var newListData:NSArray = json.getAppartamentoListJson(jsonAppartamento, num: month_pie)
            totalePalazzo = Statistic().getTotal(json.getContentPalazzoJson(jsonPalazzo, withMonth: month_pie)) as Int
            totaleAbitazione = Statistic().getTotal(newListData)
            
            //aggiorna la torta con i nuovi dati
            listData = newListData
            generatePie()
            
            //mette il bottone di logout in primo piano (altrimenti non sarebbe cliccabile)
            bigPieChartArea.bringSubviewToFront(logoutButton)
            
            //se non ci sono mesi precedenti, disabilita il bottone per il mese precedente
            if(month_pie + 1 == tableRow.arrayLetture.count){
                prevMonthBtn.enabled = false
            }else{
                prevMonthBtn.enabled = true
            }
            
            //aggiorna il consumo rispetto al palazzo
            updateConsumo()
            
        }else{
            
        }
        
    }
    
    @IBAction func nextMonth(){
        //rimuove la view del "vecchio" grafico a torta e dei suoi bottoni
        self.bigPieChart.removeFromSuperview()
        self.detailSubview.removeFromSuperview()
        
        for v:AnyObject in self.bigPieChartArea.subviews{
            let view:UIView = v as UIView
            view.removeFromSuperview()
        }
        
        //se non ci sono mesi successivi, disabilita il bottone per il mese successivo
        if((month_pie - 1) < 0){
            nextMonthBtn.enabled = false
        }else{
            nextMonthBtn.enabled = true
        }
        
        //aggiorna il mese corrente e recupera i valori ad esso relativi
        month_pie = month_pie - 1
        var json:JsonParser = JsonParser()
        println(urlAbitazione)
        var newListData:NSArray = json.getAppartamentoListJson(jsonAppartamento, num: month_pie)
        totalePalazzo = Statistic().getTotal(json.getContentPalazzoJson(jsonPalazzo, withMonth: month_pie)) as Int
        totaleAbitazione = Statistic().getTotal(newListData)
        //retain
        //retain
        
        //aggiorna la torta con i nuovi dati
        listData = newListData
        generatePie()
        
        //mette il bottone di logout in primo piano (altrimenti non sarebbe cliccabile)
        bigPieChartArea.bringSubviewToFront(logoutButton)
        if(month_pie == 0){
            nextMonthBtn.enabled = false
        }else{
            nextMonthBtn.enabled = true
        }
        
        //aggiorna il consumo rispetto al palazzo
        updateConsumo()
    }
    
    
   
    
    
 }







