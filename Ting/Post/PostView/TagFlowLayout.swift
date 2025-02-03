//
//  TagFlowLayout.swift
//  Ting
//
//  Created by 유태호 on 2/2/25.
//

import UIKit

extension UIView {
    func addSubviews(_ views: [UIView]) {
        views.forEach { addSubview($0) }
    }
}


class TagFlowLayout: UIView {
   private var tags: [UIView] = []
   private let horizontalSpacing: CGFloat = 8
   private let verticalSpacing: CGFloat = 8
   
   override var intrinsicContentSize: CGSize {
       let size = calculateContentSize()
       return size
   }
   
   private func calculateContentSize() -> CGSize {
       var currentX: CGFloat = 0
       var currentY: CGFloat = 0
       var maxHeight: CGFloat = 0
       let maxWidth = bounds.width > 0 ? bounds.width : UIScreen.main.bounds.width - 40
       
       for tag in tags {
           let tagWidth = tag.frame.width
           let tagHeight = tag.frame.height
           
           if currentX + tagWidth > maxWidth {
               currentX = 0
               currentY += maxHeight + verticalSpacing
               maxHeight = tagHeight
           } else {
               maxHeight = max(maxHeight, tagHeight)
           }
           
           currentX += tagWidth + horizontalSpacing
       }
       
       return CGSize(width: maxWidth, height: currentY + maxHeight)
   }
   
   func addTag(_ tagView: UIView) {
       tags.append(tagView)
       addSubview(tagView)
       invalidateIntrinsicContentSize()
       setNeedsLayout()
   }
   
   override func layoutSubviews() {
       super.layoutSubviews()
       
       var currentX: CGFloat = 0
       var currentY: CGFloat = 0
       var maxHeight: CGFloat = 0
       
       for tag in tags {
           let tagWidth = tag.frame.width
           let tagHeight = tag.frame.height
           
           if currentX + tagWidth > bounds.width {
               currentX = 0
               currentY += maxHeight + verticalSpacing
               maxHeight = 0
           }
           
           tag.frame = CGRect(x: currentX, y: currentY, width: tagWidth, height: tagHeight)
           currentX += tagWidth + horizontalSpacing
           maxHeight = max(maxHeight, tagHeight)
       }
       
       invalidateIntrinsicContentSize()
   }
}
