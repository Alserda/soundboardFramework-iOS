//
//  Backend.swift
//  soundboardFramework
//
//  Created by Peter Alserda on 27/02/16.
//  Copyright © 2016 Peter Alserda. All rights reserved.
//

import Foundation
import Alamofire
import SwiftyJSON

enum Router: URLRequestConvertible {
//    static let baseURLString = "http://peter.al"
    static let baseURLString = "http://peter.dev"
    static var OAuthToken: String?

    case fetchSoundboardData()
    case fetchAudioFile(URL: String)
    case fetchBackgroundImage(URL: String)
    
    var method: Alamofire.Method {
        switch self {
        case .fetchSoundboardData():
            return .GET
        case .fetchAudioFile(_):
            return .GET
        case .fetchBackgroundImage(_):
            return .GET
        }
    }
    
    var path: String {
        switch self {
        case .fetchSoundboardData():
            return "/data.json"
        case .fetchAudioFile(let url):
            return url
        case .fetchBackgroundImage(let url):
            return url
        }
    }
    
    var URLRequest: NSMutableURLRequest {
        let URL = NSURL(string: Router.baseURLString)!
        let mutableURLRequest = NSMutableURLRequest(URL: URL.URLByAppendingPathComponent(path))
        mutableURLRequest.HTTPMethod = method.rawValue
        print(mutableURLRequest)
        
        if let token = Router.OAuthToken {
            mutableURLRequest.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
        }
        
        switch self {
//        case .CreateUser(let parameters):
//            return Alamofire.ParameterEncoding.JSON.encode(mutableURLRequest, parameters: parameters).0
//        case .UpdateUser(_, let parameters):
//            return Alamofire.ParameterEncoding.URL.encode(mutableURLRequest, parameters: parameters).0
        default:
            return mutableURLRequest
        }
    }
}



class BackendConnection {
    static let sharedInstance = BackendConnection()
    
    func fetchSoundboard(success: (response: JSON) -> (), failed: (error: NSError) -> ()) -> Void {
        Alamofire.request(Router.fetchSoundboardData()).responseJSON { response in
            switch (response.result) {
            case .Success:
                if let value = response.result.value {
                    let json = JSON(value);
                    
                    success(response: json)
                }
            case .Failure(let error):
                failed(error: error)
            }
        }
    }
    
    func fetchAudioFile(AudioFileURL: String, success: (response: NSData) -> (), failed: (error: NSError) -> ()) -> Void {
        Alamofire.request(Router.fetchAudioFile(URL: AudioFileURL)).responseData { response in
            switch (response.result) {
            case .Success:
                if let value = response.result.value {
                    success(response: value)
                }
            case .Failure(let error):
                failed(error: error)
            }
        }
    }
    
    func fetchBackgroundImage(BackgroundImageURL: String, success: (response: NSData) -> (), failed: (error: NSError) -> ()) -> Void {
        Alamofire.request(Router.fetchBackgroundImage(URL: BackgroundImageURL)).responseData { response in
            switch (response.result) {
            case .Success:
                if let value = response.result.value {
                    success(response: value)
                }
            case .Failure(let error):
                failed(error: error)
            }
        }
    }
}