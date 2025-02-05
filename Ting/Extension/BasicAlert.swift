//
//  BasicAlert.swift
//  Ting
//
//  Created by t2023-m0033 on 2/4/25.
//

import UIKit

extension UIViewController {
    func basicAlert(title: String, message: String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "확인", style: .default))
        self.present(alert, animated: true)
    }
}
