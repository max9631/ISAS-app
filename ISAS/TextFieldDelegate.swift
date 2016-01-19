//
//  TextFieldDelegate.swift
//  ISAS
//
//  Created by Adam Salih on 19/01/16.
//  Copyright © 2016 Adam Salih. All rights reserved.
//

import UIKit

class TextFieldDelegate: NSObject, UITextFieldDelegate {

    func textFieldShouldReturn(textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
}
