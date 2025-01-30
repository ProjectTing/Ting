//
//  HexColorCode.swift
//  Ting
//
//  Created by 이재건 on 1/24/25.
//

import UIKit

// RGB를 Hex Color로 변환
extension UIColor {
    
    // MARK: - 컬러값
    static let grayCloud = UIColor(hexCode: "D1D1D1") // 카드 등의 테두리 컬러 (연한 그레이)
    static let ivoryWhite = UIColor(hexCode: "FFFBF5") // 배경 컬러 (연한)
    static let deepCocoa = UIColor(hexCode: "3A150A") // 기본 텍스트 컬러 (검정에 가까운 브라운)
    static let primary = UIColor(hexCode: "C2410C") // 선명한 브라운 (메인 컬러)
    static let secondary = UIColor(hexCode: "FB923C") // 밝은 브라운, 거의 주황색
    static let accent = UIColor(hexCode: "9A3412") // 진한 브라운
    static let background = UIColor(hexCode: "FFF7ED") // 배경 컬러 (진한)
    static let brownText = UIColor(hexCode: "7C2D12") // 갈색 포인트 텍스트 (어두운 브라운)
    
    convenience init(hexCode: String, alpha: CGFloat = 1.0) {
        var hexFormatted: String = hexCode.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines).uppercased()
        
        if hexFormatted.hasPrefix("#") {
            hexFormatted = String(hexFormatted.dropFirst())
        }
        
        assert(hexFormatted.count == 6, "Invalid hex code used.")
        
        var rgbValue: UInt64 = 0
        Scanner(string: hexFormatted).scanHexInt64(&rgbValue)
        
        self.init(red: CGFloat((rgbValue & 0xFF0000) >> 16) / 255.0,
                  green: CGFloat((rgbValue & 0x00FF00) >> 8) / 255.0,
                  blue: CGFloat(rgbValue & 0x0000FF) / 255.0,
                  alpha: alpha)
    }
}
