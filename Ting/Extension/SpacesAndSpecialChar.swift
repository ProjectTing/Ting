//
//  Untitled.swift
//  Ting
//
//  Created by 이재건 on 2/12/25.
//

import UIKit

// MARK: - 공백, 줄바꿈으로만 입력되었는지 체크
func isThereSpaces(text: String) -> Bool { // 어느곳이던 공백이 포함되어있으면 true return
    return text.range(of: "\\s", options: .regularExpression) != nil
}

// MARK: - 특수문자 입력되었는지 체크
func isThereSpecialChar(text: String) -> Bool { // 어느곳이던 특수문자가 포함되어있으면 true return
    return text.range(of: "[^a-zA-Z0-9가-힣]", options: .regularExpression) != nil
}

// MARK: - 첫 글자가 공백인지 체크
func isFirstCharSpace(text: String) -> Bool {
    return text.first == " "
}
