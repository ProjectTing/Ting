//
//  PostUploadVC.swift
//  Ting
//
//  Created by 이재건 on 1/21/25.
//

import UIKit
import SnapKit

final class PostUploadVC: UIViewController {
    
    private let postUploadView = PostUploadView()
   
    override func loadView() {
        self.view = postUploadView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
}
