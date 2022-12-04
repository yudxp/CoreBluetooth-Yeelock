//
//  UDManager.swift
//  Yeelock
//
//  Created by Yudha Hamdi Arzi on 04/12/22.
//

import Foundation

extension UserDefaults {

  public var userDevice: Int {
    get {
      integer(forKey: "FeelingTabIndex")
    }
    set {
      set(newValue, forKey: "FeelingTabIndex")
    }
  }

}
