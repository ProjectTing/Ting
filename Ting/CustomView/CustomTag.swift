//
//  PostUploadView.swift
//  Ting
//
//  Created by Watson22_YJ on 1/24/25.
//

import UIKit
import SnapKit
import Then

final class CustomTag: UIButton {
    
    override var isSelected: Bool {
        didSet {
            // 태그 클릭 시 색상변경
            self.configuration?.baseBackgroundColor = isSelected ? .primary : .white
            self.configuration?.baseForegroundColor = isSelected ? .white : .primary
        }
    }
    
    // 생성자 (재사용 시 타이틀, 컬러, 버튼 설정)
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
        clipsToBounds = true
    }
}
