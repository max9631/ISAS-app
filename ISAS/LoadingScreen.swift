//
//  LoadingScreen.swift
//  ISAS
//
//  Created by Adam Salih on 10/01/16.
//  Copyright © 2016 Adam Salih. All rights reserved.
//

import UIKit

class LoadingScreen: UIVisualEffectView {
    
    var indicator:UIActivityIndicatorView!
    var label:UILabel!
    
    /**
     This class can not initiate all its subviews in the initiation method, sot it does using this method.
     
     - Parameter labelText: Text which will be set on the loadingScreens label.
     */
    
    func startWith(labelText:String){
        let height = UIScreen.mainScreen().bounds.height
        let width = UIScreen.mainScreen().bounds.width
        let indicatorSize = 20 as CGFloat
        self.indicator = UIActivityIndicatorView(frame: CGRect(
            x: (width/2)-(indicatorSize/2),
            y: (height/2)-(indicatorSize/2),
            width: indicatorSize,
            height: indicatorSize))
        self.addSubview(self.indicator)
        self.bringSubviewToFront(self.indicator)
        
        let indicatorOriginY = (height/2)-(indicatorSize/2)
        self.label = UILabel(frame: CGRect(x: 0, y: indicatorOriginY + indicatorSize + 10 , width: width, height: 50))
        self.label.text = ""
        self.label.textAlignment = NSTextAlignment.Center
        self.label.textColor = UIColor.whiteColor()
        self.addSubview(self.label)
        
        self.indicator.startAnimating()
        self.label.text = labelText
    }
    
    /**
     This method sets its classes taxtLabel.
     
     - Parameter text: Text which will be set on the loadingScreens label.
     */
    
    func setLabel(text str:String){
        dispatch_async(dispatch_get_main_queue(), {
            self.label.text = str
        });
    }
}
