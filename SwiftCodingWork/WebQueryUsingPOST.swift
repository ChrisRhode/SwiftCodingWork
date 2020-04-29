//
//  WebQueryUsingPOST.swift
//  SwiftCodingWork
//
//  Created by Christopher Rhode on 4/28/20.
//  Copyright © 2020 Christopher Rhode. All rights reserved.
//

import UIKit

protocol WebQueryUsingPOSTPassbackDelegate: class {
    func doWebQueryUsingPOSTPassBack(dataReceived: String)
}
class WebQueryUsingPOST: NSObject,URLSessionDataDelegate {
    
    var gsession: URLSessionTask?
    var grequest: URLRequest?
    var greceivedData: Data?
    
    weak var delegate: WebQueryUsingPOSTPassbackDelegate?
    
    func doQuery(theURL: String, theParameters: String)
    {
        let processedURL = URL(string: theURL)
        
        grequest = URLRequest(url: processedURL!)
        grequest?.httpMethod = "POST"
        grequest?.setValue("application/x-www-form-urlencoded", forHTTPHeaderField: "Content-Type")
        
        let postData = Data(theParameters.utf8)
        let postDataLength = postData.count
        grequest?.setValue("\(postDataLength)", forHTTPHeaderField: "Content-Length")
        grequest?.httpBody = postData
        
        greceivedData = Data()
        
        let task = webSession.dataTask(with: grequest!)
        task.resume()
    }
    
    //
    private lazy var webSession: URLSession =
    {
        let config = URLSessionConfiguration.default
        config.waitsForConnectivity = true
        return URLSession(configuration: config, delegate: self, delegateQueue: nil)
    }()
    
    
    func urlSession(_ session: URLSession, dataTask: URLSessionDataTask, didReceive data: Data) {
        self.greceivedData!.append(data)
    }
    
    func urlSession(_ session: URLSession, task: URLSessionTask, didCompleteWithError error: Error?) {
        
        let receivedDataAsString = String(data: greceivedData!, encoding: .utf8)
        
        delegate?.doWebQueryUsingPOSTPassBack(dataReceived: receivedDataAsString!)
    }
}
