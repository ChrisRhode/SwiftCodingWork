//
//  WebQuery.swift
//  SwiftCodingWork
//
//  Created by Christopher Rhode on 4/26/20.
//  Copyright © 2020 Christopher Rhode. All rights reserved.
//
// *** this is/was a debugging version that used GET, until I could get POST working
// *** in general will use WebQueryUsingPOST moving forward wherever possible
import UIKit

protocol WebQueryPassbackDelegate: class {
    func doWebQueryPassBack(dataReceived: String)
}

class WebQuery: NSObject,URLSessionDataDelegate {
    
    var gsession: URLSessionTask?
    var grequest: URLRequest?
    var greceivedData: Data?
    
    weak var delegate: WebQueryPassbackDelegate?
    
    func doQuery(theURL: String, theParameters: String)
    {
        // use GET for now, figure out why POST does not work (server does not see data)
        //let processedURL = URL(string: theURL)
        let augmentedURL = theURL + "?" + theParameters
        //let processedURL = URL(string: theURL)
        let processedURL = URL(string: augmentedURL)
        grequest = URLRequest(url: processedURL!)
        //grequest?.httpMethod = "POST"
        grequest?.httpMethod = "GET"
        //grequest?.setValue("application/x-www-form-urlencoded", forHTTPHeaderField: "Content-Type")
        //let postData = Data(theParameters.utf8)
        //let postDataLength = postData.count
        //grequest?.setValue("\(postDataLength)", forHTTPHeaderField: "Content-Length")
        //grequest?.httpBody = postData
        
        greceivedData = Data()
        
        let task = webSession.dataTask(with: processedURL!)
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
        
        delegate?.doWebQueryPassBack(dataReceived: receivedDataAsString!)
    }
    //
}
