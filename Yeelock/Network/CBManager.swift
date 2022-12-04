//
//  CBManager.swift
//  Yeelock
//
//  Created by Yudha Hamdi Arzi on 04/12/22.
//

import Foundation
import CoreBluetooth

extension ViewController: CBCentralManagerDelegate, CBPeripheralDelegate {

  func peripheral(_ peripheral: CBPeripheral, didDiscoverServices error: Error?) {
    guard let services = peripheral.services else {return}
    for service in services {
      print(service)
      peripheral.discoverCharacteristics(nil, for: service)
    }
  }

  // MARK: - Parse incoming data
  func peripheral(_ peripheral: CBPeripheral, didUpdateValueFor characteristic: CBCharacteristic, error: Error?) {
    guard let data = characteristic.value else {
      print("missing updated value"); return }
    YeelockProtocol.notif_handler(data)
  }

  // MARK: - If found characteristic read the value
  func peripheral(_ peripheral: CBPeripheral, didDiscoverCharacteristicsFor service: CBService, error: Error?) {
    if let characteristics = service.characteristics {
      for characteristic in characteristics {
        switch characteristic.uuid.uuidString{
        case CBUUIDs.batteryLevel:
          peripheral.setNotifyValue(true, for: characteristic)
          peripheral.readValue(for: characteristic)
        case CBUUIDs.notificationChannel:
          peripheral.setNotifyValue(true, for: characteristic)
          peripheral.readValue(for: characteristic)
        case CBUUIDs.writeCommand:
          txCharacteristic = characteristic
        default:
          print("")
        }
      }
    }
  }

  // MARK: - Do something when bluetooth in the state. I scan when bluetooth power on
  func centralManagerDidUpdateState(_ central: CBCentralManager) {
    switch central.state {
    case .unknown:
      print("central.state is .unknown")
    case .resetting:
      print("central.state is .resetting")
    case .unsupported:
      print("central.state is .unsupported")
    case .unauthorized:
      print("central.state is .unauthorized")
    case .poweredOff:
      print("central.state is .poweredOff")
    case .poweredOn:
      print("central.state is .poweredOn")
      centralManager.scanForPeripherals(withServices: nil, options: nil)
    @unknown default:
      print("Error")
    }
  }

  func centralManager(_ central: CBCentralManager, didConnect peripheral: CBPeripheral) {
    print("connected")
    peripheral.delegate = self
    yeelockPeripheral.discoverServices(nil)
  }

  func centralManager(_ central: CBCentralManager, didDisconnectPeripheral peripheral: CBPeripheral, error: Error?) {
    print("device disconnected")
  }

  func centralManager(_ central: CBCentralManager, didDiscover peripheral: CBPeripheral, advertisementData: [String : Any], rssi RSSI: NSNumber) {
    guard peripheral.name != nil else {return}

    if peripheral.name! == CBUUIDs.yeelockName {
      print("Sensor Found!")
      print(peripheral.name!)
      yeelockPeripheral = peripheral
      centralManager.stopScan()
      centralManager.connect(peripheral, options: nil)
    }
  }

}

