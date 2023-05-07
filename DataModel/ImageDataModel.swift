//
//  ImageDataModel.swift
//  OverlayKit
//
//  Created by Suhail on 06/05/23.
//

import Foundation


/// Model to decode Image data from the repsone
struct ImageDataModel: Decodable {
    var url: String?
    var height: CGFloat?
    var width: CGFloat?
}


