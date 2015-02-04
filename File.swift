//
//  File.swift
//  ProvaJoule2
//
//  Created by TSC Consulting on 20/01/15.
//  Copyright (c) 2015 com.tsc. All rights reserved.
//

import Foundation


class File{

class func exists (path: String) -> Bool{
    return NSFileManager().fileExistsAtPath(path)
}

class func read (path:String, encoding: NSStringEncoding = NSUTF8StringEncoding) -> String?{
    if File.exists (path){
        return String(contentsOfFile: path, encoding: NSUTF8StringEncoding, error: nil)
    }
    return nil
}
    
class func write(path:String, content:String, encoding:NSStringEncoding = NSUTF8StringEncoding) -> Bool {
    return content.writeToFile(path, atomically: true, encoding: encoding, error: nil)
        
}
    
}