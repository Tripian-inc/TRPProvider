//
//  TRPBarButtonItem.swift
//  TRPProvider
//
//  Created by Evren Yaşar on 30.01.2022.
//  Copyright © 2022 Tripian Inc. All rights reserved.
//

import UIKit

public enum TRPBarButtonItemType {
    case createTrip,dismiss,profile,custom, close
}

public struct TRPBarButtonItem {
    public let id: Int?
    public let image: UIImage?
    public var type = TRPBarButtonItemType.custom
    
    public init(id: Int, image: UIImage?, type: TRPBarButtonItemType = .custom ) {
        self.id = id
        self.image = image
        self.type = type
    }
    
    public init(type: TRPBarButtonItemType = .createTrip) {
        self.type = type
        id = nil
        image = nil
    }
}
