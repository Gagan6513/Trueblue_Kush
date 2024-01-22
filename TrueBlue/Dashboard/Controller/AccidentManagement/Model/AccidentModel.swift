//
//  AccidentModel.swift
//  TrueBlue
//
//  Created by Kushkumar Katira on 19/01/24.
//

import Foundation

class AccidentModel: Codable {
    
    var data: AccidentDataModel?
    var status: Int?
    var msg:String?
    var statusCode: Int?
    
}

class AccidentDataModel: Codable {
    
    var app_id: String?
    var application_id: String?
}


class DocModel: Codable {
    
//    var data: DocDataModel?
    var status: Int?
    var msg:String?
    var statusCode: Int?
    
}

class DocListModel: Codable {
    
    var data: DocDataListModel?
    var status: Int?
    var msg:String?
    var statusCode: Int?
    
}

class DocDataListModel: Codable {
    
    var document_details: [uploadedImagesModel]?
}

class uploadedImagesModel: Codable {
    
    var doc_id: String?
    var document: String?
    var image_url: String?
    
}
