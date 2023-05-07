//
//  DataHelper.swift
//  OverlayKit
//
//  Created by Suhail on 06/05/23.
//

import Foundation


class DataHelper {
    /// Decode response
    /// - Parameter data: Response data to be used to decode
    /// - Returns: Will return decoded data in the form of data model
    static func decodJson(data: String) -> CustomDataModel? {
        var customViewData: CustomDataModel?
        let jsonData = Data(data.utf8)
        let decoder = JSONDecoder()
        do {
            customViewData = try decoder.decode(CustomDataModel.self, from: jsonData)
            print(customViewData as Any)
            
            return customViewData
        } catch {
            print(error.localizedDescription)
            
            return nil
        }
        
    }
    
    /// To be called to get Image from the url
    /// - Parameter url: A url address to remote image is stored
    /// - Returns: Will return downloaded image data
    static func getImageData(url: String) -> UIImage? {
        if let url = URL(string: url) {
            do {
                let data = try Data(contentsOf: url)
                return UIImage(data: data)
            } catch let error {
                print(("Error : \(error.localizedDescription)"))
            }
        }
        
        return nil
    }
}
