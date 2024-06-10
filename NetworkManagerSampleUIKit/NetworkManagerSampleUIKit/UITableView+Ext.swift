//
//  UITableView+Ext.swift
//  NetworkManagerSampleUIKit
//
//  Created by Irsyad Ashari on 07/05/24.
//

import UIKit

extension UITableViewCell {
    static var reuseIdentifier: String {
        return String(describing: self)
    }
}
