//
//  DateFormatter.swift
//  Ting
//
//  Created by Watson22_YJ on 1/30/25.
//

import Foundation

/// DateFormatter 필요 한지 아닌지 판단 필요
extension DateFormatter {
    static let postDateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.locale = Locale(identifier: "ko_KR")
        formatter.dateFormat = "yy년 M월 d일 a h시 mm분"
        return formatter
    }()
}
