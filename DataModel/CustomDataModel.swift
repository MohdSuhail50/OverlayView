//
//  CustomDataModel.swift
//  OverlayKit
//
//  Created by Suhail on 06/05/23.
//

import Foundation

/// Model to decode data from response
class CustomDataModel: Decodable {
    var image: ImageDataModel?
    var text: String?
    var buttons: Array<ButtonDataModel>?
}
