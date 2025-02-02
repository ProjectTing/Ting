//
//  FindTeamUploadVC.swift
//  Ting
//
//  Created by Watson22_YJ on 1/29/25.
//

/// 팀 구함 글 작성 VC
import UIKit
import SnapKit
import RxSwift

final class FindTeamUploadVC: UIViewController {
    
    private let uploadView = FindTeamUploadView()
    private let viewModel = FindTeamUploadVM()
    private let disposeBag = DisposeBag()
    
    let postType: PostType = .findTeam
    
    override func loadView() {
        self.view = uploadView
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        bindUI()
    }
    
    private func bindUI() {
        bindTagButtons()
        bindTextInputs()
        bindSubmitButton()
    }
    
    // MARK: - 태그 버튼 바인딩
    private func bindTagButtons() {
        // 모든 섹션이 단일 선택
        let sectionBindings = [
            (uploadView.positionSection, viewModel.selectedPosition),
            (uploadView.availableSection, viewModel.selectedAvailable),
            (uploadView.ideaStatusSection, viewModel.selectedIdeaStatus),
            (uploadView.teamSizeSection, viewModel.selectedTeamSize),
            (uploadView.meetingStyleSection, viewModel.selectedMeetingStyle),
            (uploadView.currentStatusSection, viewModel.selectedCurrentStatus)
        ]
        
        sectionBindings.forEach { section, relay in
            section.buttons.forEach { button in
                button.rx.tap
                    .asDriver(onErrorDriveWith: .empty())
                    .drive(onNext: {
                        section.buttons.forEach { $0.isSelected = ($0 == button) }
                        let selectedText = button.titleLabel?.text ?? ""
                        relay.accept(selectedText)
                    })
                    .disposed(by: disposeBag)
            }
        }
    }
    
    // MARK: - 텍스트 입력 바인딩
    private func bindTextInputs() {
        uploadView.teckstackTextField.textField.rx.text.orEmpty
            .map { text in
                text.components(separatedBy: ",")
                    .map { $0.trimmingCharacters(in: .whitespaces) }
                    .filter { !$0.isEmpty }
            }
            .asDriver(onErrorDriveWith: .empty())
            .drive(viewModel.techStackInput)
            .disposed(by: disposeBag)
        
        uploadView.titleSection.textField.rx.text.orEmpty
            .asDriver(onErrorDriveWith: .empty())
            .drive(viewModel.titleInput)
            .disposed(by: disposeBag)
        
        uploadView.detailTextView.rx.text.orEmpty
            .asDriver(onErrorDriveWith: .empty())
            .drive(viewModel.detailInput)
            .disposed(by: disposeBag)
    }
    
    // MARK: - 제출 버튼 바인딩
    private func bindSubmitButton() {
        uploadView.submitButton.rx.tap
            .asDriver(onErrorDriveWith: .empty())
            .drive(onNext: { [weak self] in
                self?.viewModel.submitButtonTapped()
                self?.navigationController?.popViewController(animated: true)
            })
            .disposed(by: disposeBag)
    }
}
