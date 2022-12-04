//
//  DeviceManager.swift
//  Yeelock
//
//  Created by Yudha Hamdi Arzi on 04/12/22.
//

import Foundation

struct DeviceManger {

  static let grantType = "password"
  static let clientId  = "yeeloc"
  static let clientSecret = "adb03414981961952ccf40a1b4031d12"

  static func getAccessToken(_ username: String,_ password: String,_ zone: String)-> String{
    let semaphore = DispatchSemaphore (value: 0)
    let parameters = "grant_type=\(grantType)&client_id=\(clientId)&client_secret=\(clientSecret)&username=\(username)&password=\(password)&zone=\(zone)"
    let postData =  parameters.data(using: .utf8)
    var access = ""

    var request = URLRequest(url: URL(string: "https://api.yeeloc.com/oauth/access_token")!,timeoutInterval: Double.infinity)
    request.addValue("application/x-www-form-urlencoded", forHTTPHeaderField: "Content-Type")

    request.httpMethod = "POST"
    request.httpBody = postData

    let task = URLSession.shared.dataTask(with: request) { data, response, error in
      guard let data = data else {
        print(String(describing: error))
        semaphore.signal()
        return
      }
      let jsonData = try? JSONSerialization.jsonObject(with: data, options: .mutableContainers)
      let result = jsonData as! Dictionary<String, Any>
      access = result["access_token"] as! String
      print ("acces_token: \(access)")
      semaphore.signal()
    }
    task.resume()
    semaphore.wait()
    return access
  }

  static func get_locks(_ access_token: String){
    let semaphore = DispatchSemaphore (value: 0)

    var request = URLRequest(url: URL(string: "https://api.yeeloc.com/lock")!,timeoutInterval: Double.infinity)
    request.addValue("Bearer \(access_token)", forHTTPHeaderField: "Authorization")

    request.httpMethod = "GET"

    let task = URLSession.shared.dataTask(with: request) { data, response, error in
      guard let data = data else {
        print(String(describing: error))
        semaphore.signal()
        return
      }
      let jsonData = try? JSONSerialization.jsonObject(with: data, options: .mutableContainers)
      print(jsonData!)
      semaphore.signal()
    }
    task.resume()
    semaphore.wait()
  }
}
