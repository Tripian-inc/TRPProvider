//
//  FileReader.swift
//  TRPProviderTests
//
//  Created by Evren Yaşar on 7.07.2020.
//  Copyright © 2020 Tripian Inc. All rights reserved.
//

import Foundation
class FileReader {
    
    
    /// Bundle içindeki Json dosyaları okur
    /// - Parameter fileName: json dosya adı
    /// - Returns: Okunan json ın data hali
    func json(_ fileName: String) -> Data? {
        
        if let path = Bundle(for: type(of: self)).path(forResource: fileName, ofType: "json") {
            do {
                return try Data(contentsOf: URL(fileURLWithPath: path), options: .mappedIfSafe)
            } catch {
                print("File Reader Error \(error.localizedDescription)")
                return nil
            }
        }
        
        return nil
    }
    
}
