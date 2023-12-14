//
//  Models.swift
//  TestApp
//
//  Created by ульяна on 13.12.23.
//

import Foundation

struct PagePhotoTypeDtoOut : Decodable {
    
    let content : [PhotoTypeDtoOut]?
    let page : Int32?
    let pageSize : Int32?
    let totalElements : Int64?
    let totalPages : Int32?
    
    enum CodingKeys: String, CodingKey {
        case content = "content"
        case page = "page"
        case pageSize = "pageSize"
        case totalElements = "totalElements"
        case totalPages = "totalPages"
    }
}

struct PhotoDtoOut : Decodable {
    
    let id : String?

    enum CodingKeys: String, CodingKey {
        case id = "id"
    }
}

struct PhotoTypeDtoOut : Decodable {
    
    let id : Int32?
    let name : String?
    let image : String?
    
    enum CodingKeys: String, CodingKey {
        case id = "id"
        case name = "name"
        case image = "image"
    }
}
