//
//  TRPImageController.swift
//  TRPProvider
//
//  Created by Evren Yaşar on 23.01.2022.
//  Copyright © 2022 Tripian Inc. All rights reserved.
//

import Foundation
import UIKit
class TRPImageController {
    
    public func getImage(inFramework: String?, inApp: String?) -> UIImage? {
        if let image = inApp {
            return UIImage(named: image, in: Bundle.main, compatibleWith: nil)
        }
        if let image = inFramework {
            return UIImage(named: image, in: Bundle.init(for: type(of: self)), compatibleWith: nil)
        }
        return nil
    }
    
}
