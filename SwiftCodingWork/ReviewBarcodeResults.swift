//
//  ReviewBarcodeResults.swift
//  SwiftCodingWork
//
//  Created by Christopher Rhode on 4/24/20.
//  Copyright © 2020 Christopher Rhode. All rights reserved.
//

import UIKit

class ReviewBarcodeResults: UITableViewController,WebQueryUsingPOSTPassbackDelegate {
    
    struct JSONresponseToLookupUPC: Decodable
    {
        //enum response_type: String, Decodable
        //{
        //    case KnownValue,PossibleValues
        //}
        let response_type: String
        let known_description: String?;
        let possible_descriptions: [[String: String]];
    }
    
    //var receivedData: Data?
    var json_response : JSONresponseToLookupUPC?
    
    var barcodeValues : [String]
    var barcodeValuesCurrNdx : Int = 0
    var barcodeValuesLastNdx : Int = 0
    
    var descriptionValues : [String] = []
    
    var WebQueryInstance : WebQueryUsingPOST?
    var progressMessage: StatusMessage?
    
    //var progressView: UIView?
    
    init(withListOfBarcodeValues: [String])
    {
        barcodeValues = withListOfBarcodeValues
        var ndx,lastNdx : Int
        lastNdx = barcodeValues.count - 1
        ndx = 0;
        while (ndx <= lastNdx)
        {
            descriptionValues.append("[Description not loaded yet]")
            ndx += 1
        }
        super.init(style: .plain)
    }
    
    required init?(coder: NSCoder)
    {
        fatalError("init(coder:) not supported")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false
        
        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        WebQueryInstance = WebQueryUsingPOST()
        WebQueryInstance?.delegate = self
        
        // for each UPC code, lookup either known value or possible values
        
        progressMessage = StatusMessage(withView: self.view)
        self.progressMessage?.setMessage(theMessage: "Loading data from server, please wait...", withMessageType: .isInProgress, isLastMessage: false)
        
        DispatchQueue.global(qos: .utility).async {
            sleep(1) // gives the initial progress message time to finish displaying
           
            self.barcodeValuesLastNdx = self.barcodeValues.count - 1
            self.setupToGetDescriptionOfNextBarcode()
            

        }
    }
    
    func setupToGetDescriptionOfNextBarcode()
    {
        self.progressMessage?.setMessage(theMessage: "Loading (\(barcodeValuesCurrNdx+1)) of (\(barcodeValuesLastNdx+1))", withMessageType: .isInProgress, isLastMessage: false)
        doLookupUPC(UPCValue:barcodeValues[barcodeValuesCurrNdx])
        
    }
    
    func doLookupUPC(UPCValue:String)
    {
        let url = "http://www.zoggoth2.com/MyWebServices/LookupUPC.aspx"
        var params = ""
        params += "cmd" + "=" + "LookupUPC"
        params += "&" + "UPCValue" + "=" + UPCValue
        
        WebQueryInstance?.doQuery(theURL: url, theParameters: params)
    }
    
    func doWebQueryUsingPOSTPassBack(dataReceived: String)
    {
        let range : Range<String.Index> = dataReceived.range(of : "\r\n\r\n<!DOCTYPE html>")!
        let redoneString = dataReceived[..<range.lowerBound]
        let revisedData : Data? = redoneString.data(using: .utf8)
        
        json_response = try! JSONDecoder().decode(JSONresponseToLookupUPC.self, from: revisedData!)
        
        if (json_response?.response_type == "KnownValue")
        {
            descriptionValues[barcodeValuesCurrNdx] = ((json_response?.known_description)!)
        }
        else if (json_response?.response_type == "PossibleValues")
        {
            var allPossibilities: String
            allPossibilities = ""
            var ndx2,lastNdx2: Int
            lastNdx2 = json_response!.possible_descriptions.count - 1
            ndx2 = 0
            while (ndx2 <= lastNdx2)
            {
                let thisDict = json_response!.possible_descriptions[ndx2]
                allPossibilities += thisDict["description_value"]! + "|";
                ndx2 += 1
            }
            descriptionValues[barcodeValuesCurrNdx] = allPossibilities
        }
        else
        {
            //this will be a fatal error
        }
        
        barcodeValuesCurrNdx += 1
        if (barcodeValuesCurrNdx <= barcodeValuesLastNdx)
        {
            setupToGetDescriptionOfNextBarcode()
        }
        else
        {
            self.progressMessage?.setMessage(theMessage: "Done", withMessageType: .isSuccessful, isLastMessage: true)
            DispatchQueue.main.async
                {
                    self.tableView.reloadData()
            }
        }
        
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return barcodeValues.count
    }
    
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        // **** fix this soon
        // let cell = tableView.dequeueReusableCell(withIdentifier: "reuseIdentifier", for: indexPath)
        let cell = UITableViewCell.init(style: .subtitle, reuseIdentifier: "MainListCell")
        cell.accessoryType = .none
        let thisRow = indexPath.row
        cell.textLabel!.text = descriptionValues[thisRow]
        cell.detailTextLabel!.text = barcodeValues[thisRow]
        return cell
    }
}

 

