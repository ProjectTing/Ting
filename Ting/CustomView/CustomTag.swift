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
    // MARK: - Properties
    override var isSelected: Bool {
        didSet {
            updateAppearance()
        }
    }
  
    init() {
        super.init(frame: .zero)
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupUI() {
        titleLabel?.font = .systemFont(ofSize: 14)
        contentEdgeInsets = UIEdgeInsets(top: 8, left: 10, bottom: 8, right: 10)
        layer.cornerRadius = 15
        layer.borderWidth = 0.5
    }

    func setTagButton(layerColor: UIColor, backgroundColor: UIColor, title: String, titleColor: UIColor, isButton: Bool) {
        layer.borderColor = layerColor.cgColor
        self.backgroundColor = backgroundColor
        setTitle(title, for: .normal)
        setTitleColor(titleColor, for: .normal)
        isUserInteractionEnabled = isButton
    }
    
    private func updateAppearance() {
        backgroundColor = isSelected ? .primary : .white
        setTitleColor(isSelected ? .white : .primary, for: .normal)
    }
}
