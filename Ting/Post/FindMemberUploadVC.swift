//
//  FindMemberUploadVC.swift
//  Ting
//
//  Created by Watson22_YJ on 1/29/25.
//

/// 팀원 구함 글 작성 VC
import UIKit
import SnapKit

final class FindMemberUploadVC: UIViewController {
    
    private let uploadView = FindMemberUploadView()
    
    // 중복선택 되도록 하기 위한 프로퍼티
    private var selectedPositionTags: [CustomTag] = []
    
    override func loadView() {
        self.view = uploadView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupTagButtonActions()
    }
    
    private func setupTagButtonActions() {
    }
}
