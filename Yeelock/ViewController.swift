//
//  ViewController.swift
//  Yeelock
//
//  Created by Yudha Hamdi Arzi on 19/11/22.
//

import UIKit
import Foundation
import CoreBluetooth

class ViewController: UIViewController {
  var centralManager: CBCentralManager!
  var yeelockPeripheral: CBPeripheral!
  var txCharacteristic: CBCharacteristic!


  @IBOutlet weak var lock: UIButton!
  @IBOutlet weak var getDevice: UIButton!
  
  override func viewDidLoad() {
    super.viewDidLoad()
    centralManager = CBCentralManager(delegate: self, queue: nil)
  }

  @IBAction func lockFunction(_ sender: Any) {

    let dataWillSend = YeelockProtocol.actionPacket()
    yeelockPeripheral.writeValue(Data(dataWillSend), for: txCharacteristic , type: .withResponse)
  }

  @IBAction func getDevice(_ sender: Any) {
    DeviceManger.get_locks(DeviceManger.getAccessToken("phoneNumber","yourPassword","xy"))
    //phone number without 0, password, country zone
  }
  
}

