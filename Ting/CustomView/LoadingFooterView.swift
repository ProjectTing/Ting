//
//  LoadingFooterView.swift
//  Ting
//
//  Created by Watson22_YJ on 2/5/25.
//

import UIKit
import SnapKit

// MARK: - 로딩 푸터 뷰 (커스텀)
final class LoadingFooterView: UICollectionReusableView {
    
    static let id = "LoadingFooterView"
    
    private lazy var loadingIndicator: UIActivityIndicatorView = {
        let indicator = UIActivityIndicatorView(style: .medium)
        indicator.hidesWhenStopped = true
        indicator.startAnimating()
        return indicator
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupUI() {
        addSubview(loadingIndicator)
        loadingIndicator.snp.makeConstraints { make in
            make.center.equalToSuperview()
        }
    }
    
    /// 외부에서 인디케이터 애니메이션을 제어할 수 있도록 메서드 추가
     func startAnimating() {
         loadingIndicator.startAnimating()
     }
     
     func stopAnimating() {
         loadingIndicator.stopAnimating()
     }
}
