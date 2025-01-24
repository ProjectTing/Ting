//
//  PostUploadView.swift
//  Ting
//
//  Created by t2023-m0033 on 1/24/25.
//

import UIKit
import SnapKit
import Then

final class CustomTag: UIButton {
   
    override var isSelected: Bool {
        didSet {
            updateAppearance()
        }
    }
  
    init(title: String, titleColor: UIColor, strokeColor: UIColor, backgroundColor: UIColor, isButton: Bool) {
        super.init(frame: .zero)
        setupUI(title: title, titleColor: titleColor, strokeColor: strokeColor, backgroundColor: backgroundColor, isButton: isButton)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupUI(title: String, titleColor: UIColor, strokeColor: UIColor, backgroundColor: UIColor, isButton: Bool) {
        var config = UIButton.Configuration.filled()
         config.title = title
         config.cornerStyle = .capsule
         config.baseBackgroundColor = backgroundColor
         config.baseForegroundColor = titleColor
         config.background.strokeColor = strokeColor
         config.background.strokeWidth = 0.5
         self.configuration = config
         isUserInteractionEnabled = isButton
     }

    private func updateAppearance() {
           guard var config = self.configuration else { return }
           config.baseBackgroundColor = isSelected ? .primary : .white
           config.baseForegroundColor = isSelected ? .white : .primary
           self.configuration = config
       }
}
