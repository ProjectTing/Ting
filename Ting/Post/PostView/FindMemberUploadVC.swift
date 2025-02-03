//
//  FindMemberUploadVC.swift
//  Ting
//
//  Created by Watson22_YJ on 1/29/25.
//

/// 팀원 구함 글 작성 VC
import UIKit
import SnapKit
import RxSwift
import RxCocoa

final class FindMemberUploadVC: UIViewController {
    
    private let uploadView = FindMemberUploadView()
    private let viewModel = FindMemberUploadVM()
    private let disposeBag = DisposeBag()
    
    override func loadView() {
        self.view = uploadView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        bindUI()
    }
    
    private func bindUI() {
        // 1. 직무 태그 바인딩 (중복 선택 가능)
        bindPositionTags()
        // 2. 나머지 단일 선택 태그들 바인딩
        bindSingleSelectionTags()
        bindTextInputs()
        bindSubmitButton()
    }
    
    // MARK: - 태그 버튼 바인딩
    
    // 직무 태그 바인딩 (중복 선택 가능)
    private func bindPositionTags() {
        uploadView.positionSection.buttons.forEach { button in
            button.rx.tap
                .asDriver(onErrorDriveWith: .empty())
                .drive(onNext: { [weak self] in
                    // 버튼 탭 처리
                    button.isSelected.toggle()
                    
                    // 선택된 모든 직무 가져오기
                    let selectedPositions = self?.uploadView.positionSection.buttons
                        .filter { $0.isSelected }
                        .compactMap { $0.titleLabel?.text } ?? []
                    
                    // ViewModel에 선택된 직무 전달
                    self?.viewModel.selectedPositions.accept(selectedPositions)
                })
                .disposed(by: disposeBag)
        }
    }
    
    // 단일 선택 태그들 바인딩
    private func bindSingleSelectionTags() {
        // 각 섹션과 해당하는 ViewModel의 Relay를 매핑
        let sectionBindings = [
            (uploadView.urgencySection, viewModel.selectedUrgency),
            (uploadView.ideaStatusSection, viewModel.selectedIdeaStatus),
            (uploadView.recruitsSection, viewModel.selectedRecruits),
            (uploadView.meetingStyleSection, viewModel.selectedMeetingStyle),
            (uploadView.experienceSection, viewModel.selectedExperience)
        ]
        
        // 각 섹션별로 바인딩 설정
        sectionBindings.forEach { section, relay in
            section.buttons.forEach { button in
                button.rx.tap
                    .asDriver(onErrorDriveWith: .empty())
                    .drive(onNext: {
                        // 다른 버튼들 선택 해제
                        section.buttons.forEach { $0.isSelected = ($0 == button) }
                        
                        // 선택된 버튼의 텍스트를 ViewModel에 전달
                        let selectedText = button.titleLabel?.text ?? ""
                        relay.accept(selectedText)
                    })
                    .disposed(by: disposeBag)
            }
        }
    }
    
    // MARK: - 텍스트 입력 바인딩
    private func bindTextInputs() {
        // 기술 스택 입력 바인딩
        uploadView.teckstackTextField.textField.rx.text.orEmpty
            .map { text in
                // 콤마로 분리하고 공백 제거
                text.components(separatedBy: ",")
                    .map { $0.trimmingCharacters(in: .whitespaces) }
                    .filter { !$0.isEmpty }
            }
            .asDriver(onErrorDriveWith: .empty())
            .drive(viewModel.techStackInput)
            .disposed(by: disposeBag)
        
        // 제목 입력 바인딩
        uploadView.titleSection.textField.rx.text.orEmpty
            .asDriver(onErrorDriveWith: .empty())
            .drive(viewModel.titleInput)
            .disposed(by: disposeBag)
        
        // 상세 내용 입력 바인딩
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
                self?.viewModel.submitButtonTap.accept(()) // 제출 버튼 탭 이벤트 전달
                self?.navigationController?.popViewController(animated: true)
            })
            .disposed(by: disposeBag)
    }
}
