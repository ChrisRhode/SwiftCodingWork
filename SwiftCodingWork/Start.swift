//
//  Start.swift
//  SwiftCodingWork
//
//  Created by Christopher Rhode on 4/23/20.
//  Copyright © 2020 Christopher Rhode. All rights reserved.
//

import UIKit

// ** (4) reference protocols
class Start: UITableViewController,BarcodeScannerPassbackDelegate {
    
    override init(style:UITableView.Style)
    {
        // put code here
        super.init(style:style)
        
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
    
    // MARK: - Table view data source
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return 1
    }
    
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        // ** fix to use reusable cells ASAP
        // let cell = tableView.dequeueReusableCell(withIdentifier: "reuseIdentifier", for: indexPath)
        let cell = UITableViewCell.init(style: .subtitle, reuseIdentifier: "MainListCell")
        cell.accessoryType = .none
        let thisRow = indexPath.row
        switch (thisRow)
        {
        case 0:
            cell.textLabel?.text = "Scan barcodes with camera"
        default:
            // ** throw exception instead
            cell.textLabel?.text = "Error!"
        }
        
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let thisRow = indexPath.row
        switch (thisRow)
        {
        case 0:
            // ** (5) invoke including delegate setup
            
            let tmp = BarcodeScanner()
            tmp.delegate = self
            self.navigationController?.pushViewController(tmp, animated: true)
            
            /*
             var theList : [String]  = []
             theList.append("051000224767")
             theList.append("042272005130")
             theList.append("728028064469")
             let tmp = ReviewBarcodeResults.init(withListOfBarcodeValues: theList)
             self.navigationController?.pushViewController(tmp, animated: true)
             */
        default:
            // ** throw exception instead
            fatalError("error!")
        }
        
    }
    
    // ** (6) implement delegate callbacks
    func doBarcodeScannerPassBack(barcodeValuesSeen: [String], didTapCancel: Bool) {
        
        self.navigationController?.popViewController(animated: false)
        let tmp = ReviewBarcodeResults(withListOfBarcodeValues: barcodeValuesSeen)
        self.navigationController?.pushViewController(tmp, animated: true)
        
        
    }
    
    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
