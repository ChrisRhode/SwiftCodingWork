//
//  BarcodeScanner.swift
//  SwiftCodingWork
//
//  Created by Christopher Rhode on 4/23/20.
//  Copyright © 2020 Christopher Rhode. All rights reserved.
//

import UIKit
// **** needed for AVCaptureSession
import AVFoundation

// ** (1) define protocol
protocol BarcodeScannerPassbackDelegate: class {
    func doBarcodeScannerPassBack(barcodeValuesSeen: [String], didTapCancel: Bool)
}
// **** add AVCaptureMetadataOutput protocol delegate (AVCaptureMetadataOutputObjectsDelegate)
class BarcodeScanner: UIViewController, AVCaptureMetadataOutputObjectsDelegate {

    var session : AVCaptureSession?
    // ****
    var device :  AVCaptureDevice?
    
    var output:  AVCaptureMetadataOutput?
    var input: AVCaptureDeviceInput?
    var layer:  AVCaptureVideoPreviewLayer?
    
    var seenValues: [String] = []
    
    var ugbl: Utility
    
   // ** (2) define delegate reference
    weak var delegate: BarcodeScannerPassbackDelegate? = nil
    
    init()
    {
        ugbl = Utility()
        session = nil
        device = nil
        output = nil
        input = nil
        layer = nil
        
        super.init(nibName:nil, bundle:nil)
    }
    // implement the other required superclass initializers as errors
    required init?(coder: NSCoder) {
       fatalError("init(coder:) is not supported")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    //_ means what?
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        setUpCameraForBarcodeScanning()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        session?.stopRunning()
        // ** (3) delegate callback to calling code
        delegate?.doBarcodeScannerPassBack(barcodeValuesSeen: seenValues, didTapCancel: false)
    }
    
    func setUpCameraForBarcodeScanning() {
        //var input : AVCaptureDeviceInput
        session = AVCaptureSession()
        //let device = AVCaptureDevice(uniqueID:"")
        device = AVCaptureDevice.default(for: .video)!
        do {
            input = try AVCaptureDeviceInput(device: device!) // throws!
            session?.addInput(input!) // why is pname not needed here?
            
            output = AVCaptureMetadataOutput()
            // ****
            
            //let queue = DispatchQueue(label: "scan")
            
           // output!.setMetadataObjectsDelegate(self, queue: queue)
            // *** move this to be first
              session?.addOutput(output!)
            
           
           // output?.metadataObjectTypes =
            output?.setMetadataObjectsDelegate(self, queue: DispatchQueue.main)
            // *** move to be last
          //   output!.metadataObjectTypes = output?.availableMetadataObjectTypes
            // ** this works, for QR codes only: output?.metadataObjectTypes = [.qr]
            output?.metadataObjectTypes = output?.availableMetadataObjectTypes
          
                  // var barcodeType : [AVMetadataObject.ObjectType] = []
                   
                  // barcodeType.append(.upce)
                   
                   layer = AVCaptureVideoPreviewLayer(session: session!)
            layer!.videoGravity = .resizeAspectFill
            layer!.frame = self.view.bounds
            self.view.layer.addSublayer(layer!)
                   
                   session?.startRunning()
            
            
        } catch {}  // pname is needed here, !?
    }
    
    // protocol implementation for captured metadata
    
    // not used for iOS 13.0
    func captureOutput(_ output: AVCaptureOutput!, didOutputMetadataObjects metadataObjects: [Any]!, from connection: AVCaptureConnection!)
    {
        
    }
    
    // ** verified this is the delegate used as of iOS 13.x
    func metadataOutput(_ output: AVCaptureMetadataOutput, didOutput metadataObjects: [AVMetadataObject], from connection: AVCaptureConnection) {
        
        var ndx : Int
                      var lastNdx : Int
                      var wasSeenAlready: Bool
                      var theValue: String
                      
                      for i in metadataObjects
                      {
                          // ****
                          let theObject:AVMetadataMachineReadableCodeObject = i as! AVMetadataMachineReadableCodeObject
                          theValue = theObject.stringValue!
                      
                          lastNdx = seenValues.count - 1
                          wasSeenAlready = false;
                          ndx = 0
                          while (ndx <= lastNdx)
                          {
                              if (seenValues[ndx] == theValue)
                              {
                                  wasSeenAlready = true
                                  break
                              }
                              ndx += 1
                          }
                          if (!wasSeenAlready)
                          {
                              seenValues.append(theValue)
                            ugbl.popUpSimpleAlert(alertMessage: "Saw value: " + theValue, withTypeOfAlert: .isInfo)
                          }
                      }
    }
  
    
    
    // **** was metadataOutput
    
    // template code after this line
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

    
}
