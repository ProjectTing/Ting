//
//  FindTeamUploadVC.swift
//  Ting
//
//  Created by Watson22_YJ on 1/29/25.
//

/// 팀 구함 글 작성 VC
import UIKit
import SnapKit

final class FindTeamUploadVC: UIViewController {
    private let uploadView = FindTeamUploadView()
    
    override func loadView() {
        self.view = uploadView
    }
    override func viewDidLoad() {
        super.viewDidLoad()
    }
}
