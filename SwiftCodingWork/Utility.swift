//
//  Utility.swift
//  SwiftCodingWork
//
//  Created by Christopher Rhode on 4/24/20.
//  Copyright © 2020 Christopher Rhode. All rights reserved.
//

import Foundation
import UIKit

enum ALERT_TYPES
{
    case isInfo
    case isWarning
    case isError
}

class Utility: NSObject {

    func popUpSimpleAlert(alertMessage: String, withTypeOfAlert: ALERT_TYPES)
     {
         let alertTypeString: String
         
         // **** no need for default, because it enforces exhaustiveness for enums
         switch withTypeOfAlert
         {
         case .isInfo:
            alertTypeString = "Information"
         case .isWarning:
             alertTypeString = "Warning"
         case .isError:
             alertTypeString = "Error"
         }
         
         let ac = UIAlertController(title: alertTypeString, message: alertMessage, preferredStyle: .alert)
         ac.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
         
         let app = UIApplication.shared
         let currnc = app.keyWindow!.rootViewController
         currnc!.present(ac, animated: true, completion: nil)
     }
}
