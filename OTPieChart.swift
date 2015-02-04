//
//  OTPieChart.swift
//  ProvaJoule2
//
//  Created by TSC Consulting on 08/01/15.
//  Copyright (c) 2015 com.tsc. All rights reserved.
//

import Foundation
import UIKit
import Darwin
import QuartzCore

class OTPieChart:UIView{
    var parameters:NSDictionary!
    var values:NSArray!
    
    
    override init(){
        parameters = NSDictionary()
        values = NSArray()
        super.init()
    }
    

    
     init (frame:CGRect, parameters_:NSDictionary, values_:NSArray) {
        //self = 
        super.init(frame: frame)
       // if (self) {
            // Initialization code
            parameters = NSDictionary(dictionary: parameters_)
            values = NSArray(array: values_)
      //  }
       // return self;
        }


    required init(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func getReferencePointsArray() -> NSArray{
        var xPos:Float = parameters.valueForKey("x") as Float
        var yPos:Float = parameters.valueForKey("y") as Float
        
        var pointsMutable:NSMutableArray = NSMutableArray()
        
         //Get the sum of values, and the angle value for 1 unit
        var sum:Float = 0
        for value in values {
            sum = sum + (value as Float) as Float
        }
        
        var mult:Float = (2 * Float(M_PI) ) / sum
        var radius:Float = parameters.valueForKey("radius") as Float
        var referencePointRadius:CGFloat = (2.0 * CGFloat(radius)) / 3.0  as CGFloat
        
         //Now, get all points position
        var startAngle:CGFloat = 0.0
        
        for value in values{
            //Get the angle of the value
            var valueAngle:CGFloat = (CGFloat(mult)) * (value as CGFloat)
            var halfAngle:CGFloat = valueAngle / 2.0
            
             //Reference point angle
            var referencePointAngle:CGFloat = startAngle + halfAngle
            var referencePoint = CGPointMake(referencePointRadius * cos(referencePointAngle), referencePointRadius * sin(referencePointAngle))
            referencePoint.x += CGFloat(xPos)
            referencePoint.y += CGFloat(yPos)
            referencePoint.x = ceil(referencePoint.x)
            referencePoint.y = ceil(referencePoint.y)
            var referencePointValue:NSValue = NSValue(CGPoint: referencePoint)
            pointsMutable.addObject(referencePointValue)
          
            startAngle += valueAngle
            
            
        }
        
        var points:NSArray = NSArray (array: pointsMutable)
        return points
        
    }
    
    func getConsolidatoReferencePoint() -> CGPoint{
        
        var xPos:Float = parameters.valueForKey("x") as Float
        var yPos:Float = parameters.valueForKey("y") as Float
        var radius:Float = parameters.valueForKey("big_radius") as Float
        
        var xRef:CGFloat = CGFloat(radius) * cos(1.91986218)
        var yRef:CGFloat = CGFloat(radius) * sin(1.91986218)
        
        var returnedPoint:CGPoint = CGPointMake(CGFloat(xPos) + xRef, CGFloat(yPos) - yRef)
        return returnedPoint
    }
    
    
    // Only override drawRect: if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    
     override func drawRect(rect: CGRect) {
        
        var x:Float = parameters.valueForKey("x") as Float
        var y:Float = parameters.valueForKey("y") as Float
        var radius:Float = parameters.valueForKey("radius") as Float
        var bigRadius:Float = parameters.valueForKey("big_radius") as Float
        
        var circleFrame:CGRect = CGRectMake(CGFloat(x - bigRadius), CGFloat(y - bigRadius), CGFloat(bigRadius * 2), CGFloat(bigRadius * 2))
        
        var bordersColor:UIColor = parameters.valueForKey("borders_color") as UIColor
        var innerGradientStartColor:UIColor = parameters.valueForKey("inner_gradient_start_color") as UIColor
        var innerGradientEndColor:UIColor = parameters.valueForKey("inner_gradient_end_color") as UIColor
        var outterGradientStartColor:UIColor = parameters.valueForKey("outter_gradient_start_color") as UIColor
        var outterGradientEndColor:UIColor = parameters.valueForKey("outter_gradient_end_color") as UIColor
        var lineWidth:Float = parameters.valueForKey("line_width") as Float
        
        var sum:Float = 0
        
        for value in values {
            sum += value as Float
        }
        
        var mult:Float = (2 * Float(M_PI)) / sum
        
        var ctx:CGContextRef = UIGraphicsGetCurrentContext()
        CGContextSetRGBStrokeColor (ctx, 0.5, 0.5, 0.5, 1)
        CGContextSetLineWidth(ctx, CGFloat(lineWidth))
        
        
        var colors:[CGFloat] = [CGFloat(0.48), CGFloat(0.97), CGFloat(0.80), CGFloat(1.0), CGFloat(0.48), CGFloat(0.97), CGFloat(0.80), CGFloat(1.0)]
        
        var baseSpace:CGColorSpaceRef = CGColorSpaceCreateDeviceRGB()
        var gradient:CGGradientRef = CGGradientCreateWithColorComponents(baseSpace, colors, nil, 2)
      
        CGContextSaveGState(ctx)
        CGContextAddEllipseInRect(ctx, circleFrame)
        CGContextClip(ctx)
        
        var startPoint:CGPoint = CGPointMake(CGRectGetMidX(rect), CGRectGetMinY(rect))
        var endPoint:CGPoint = CGPointMake(CGRectGetMidX(rect), CGRectGetMaxY(rect));
        
        CGContextDrawLinearGradient(ctx, gradient, startPoint, endPoint, 0);
       
        
        CGContextRestoreGState(ctx)
        
        CGContextAddEllipseInRect(ctx, circleFrame)
        CGContextDrawPath(ctx, kCGPathStroke)
        
        var startDeg:Float = 0
        var endDeg:Float = 0
        
        var colorOffsetRed:Float = Float(0.0)
        var colorOffsetGreen:Float = Float(0.0)
        var colorOffsetBlue:Float = Float(0.0)
        
        var colorMultRed:Float = (Float(1.0) - Float(0.2)) / Float(values.count)
        var colorMultGreen:Float = (Float(1.0) - Float(0.5)) / Float(values.count)
        var colorMultBlue:Float = (Float(1.0) - Float(0.7)) / Float(values.count)
        
        for value in values {
            var valueFloat:Float = value as Float
            
            startDeg = endDeg
            endDeg += valueFloat * mult
            
            if(startDeg != endDeg){
              
                var colors:[CGFloat] = [CGFloat(0.97), CGFloat(1.0), CGFloat(0.95), CGFloat(1.0),CGFloat(0.36)+CGFloat(colorOffsetRed), CGFloat(0.81)+CGFloat(colorOffsetGreen), CGFloat(0.38)+CGFloat(colorOffsetBlue), CGFloat(1.0)]
                
                var baseSpace:CGColorSpaceRef = CGColorSpaceCreateDeviceRGB()
                var gradient: CGGradientRef = CGGradientCreateWithColorComponents(baseSpace, colors, nil, 2)
              
                
                CGContextSaveGState(ctx)
                CGContextMoveToPoint(ctx, CGFloat(x), CGFloat(y))
                CGContextAddArc(ctx, CGFloat(x), CGFloat(y), CGFloat(radius), CGFloat(startDeg), CGFloat(endDeg), 0)
                CGContextClosePath(ctx)
                CGContextClip(ctx)
                
                CGContextDrawLinearGradient(ctx, gradient, startPoint, endPoint, 0)
               
                
                CGContextRestoreGState(ctx)
                
                CGContextMoveToPoint(ctx, CGFloat(x), CGFloat(y))
                CGContextAddArc(ctx,CGFloat(x), CGFloat(y), CGFloat(radius), CGFloat(startDeg), CGFloat(endDeg), 0)
                CGContextClosePath(ctx)
                CGContextStrokePath(ctx)

 
            }
            
            colorOffsetRed += colorMultRed
            colorOffsetGreen += colorMultGreen
            colorOffsetBlue += colorMultBlue
            
        }
        
        self.layer.masksToBounds = false
        self.layer.shadowOffset = CGSizeMake(-5, 5)
        self.layer.shadowRadius = 5
        self.layer.shadowOpacity = 0.5
        
        var path = UIBezierPath(arcCenter: CGPointMake(CGFloat(x), CGFloat(y)), radius: CGFloat(bigRadius), startAngle: CGFloat(0), endAngle: CGFloat(2*M_PI), clockwise: true).CGPath
        
        self.layer.shadowPath = path

    }
    
}


/*

#import <QuartzCore/QuartzCore.h>
#import "UIColor-Expanded.h"


@end
*/
