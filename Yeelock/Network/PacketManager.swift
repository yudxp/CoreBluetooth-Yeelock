//
//  PacketManager.swift
//  Yeelock
//
//  Created by Yudha Hamdi Arzi on 04/12/22.
//



import UIKit
import Foundation
import CryptoKit

struct CBUUIDs{
  static let yeelockName         = "EL_B0HWoL0l"
  static let writeCommand        = "58AF3DCA-6FC0-4FA3-9464-74662F043A3B"
  static let notificationChannel = "58AF3DCA-6FC0-4FA3-9464-74662F043A3A"
  static let batteryLevel        = "00002A19-0000-1000-8000-00805f9B34FB"
}


enum Command: UInt8 {
  case doAction = 0x01
  case setTime = 0x08
}

enum UnlockMode: UInt8 {
  case tempUnlock = 0x00
  case unlock = 0x01
  case lock = 0x02
}

struct YeelockProtocol {

  static func actionPacket() -> [UInt8]{
    let time = Int32(NSDate().timeIntervalSince1970)
    var data: [UInt8] = []
    let timeArray = (withUnsafeBytes(of: time, Array.init)).reversed()
    data = [Command.doAction.rawValue] + [0x50] + timeArray + [UnlockMode.tempUnlock.rawValue]
    let signature = sign(data)
    let dataSend = data + signature[...12]
    return dataSend
  }

  static func timePacket() -> [UInt8]{
    let time = UInt32(NSDate().timeIntervalSince1970)
    var data: [UInt8] = []
    let timeArray = (withUnsafeBytes(of: time.bigEndian, Array.init)).reversed()
    data = [Command.doAction.rawValue] + [0x40] + timeArray
    let signature = sign(data)
    let dataSend = data + signature[...13]
    return dataSend
  }

  static func sign (_ data:[UInt8]) -> [UInt8] {
    let bleSign = SymmetricKey(data: [0x61,0x76,0x67,0x47,0x62,0x75,0x74,0x56]) //your ble_sign_key in hex
    let signature = HMAC<Insecure.SHA1>.authenticationCode(for: data, using: bleSign)
    let signatureArray = withUnsafeBytes(of: signature, Array.init)
    return signatureArray
  }

  static func sign_key (_ data: String) -> Void {

  }



  static func notif_handler(_ data: Data) -> Void {
    switch data[0] {
    case 0x09:
      print("Received time sync request ")
    case 0x02:
      print("Received unlockStart notification")
    case 0x03:
      print("Received unlockComplete notification")
    case 0x04:
      print("Received lockStart notification")
    case 0x05:
      print("Received lockComplete notification")
    case 0x25:
      print("Received invalidOpeningCode notification")
    case 0xFF:
      print("Error, check your key")
    default:
      print("Unknown notification code :")
    }
  }

}
