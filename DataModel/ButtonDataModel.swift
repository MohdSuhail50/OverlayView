//
//  ButtonDataModel.swift
//  OverlayKit
//
//  Created by Suhail on 05/05/23.
//

import Foundation

/// Model to decode buttons data from the repsone
struct ButtonDataModel: Decodable {
    var text: String?
    var redirect_url: String?
    var size: SizeDataModel?
}


/// Model to decode size of buttons data from the buttons repsone
struct SizeDataModel: Decodable {
    var height: CGFloat?
    var width: CGFloat?
}
