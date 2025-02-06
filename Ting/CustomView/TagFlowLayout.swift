//
//  ReportVC.swift
//  Ting
//
//  Created by 이재건 on 1/21/25.
//
import UIKit

class TagFlowLayout: UIView {
    private var tags: [UIView] = []
    private let horizontalSpacing: CGFloat = 8
    private let verticalSpacing: CGFloat = 8
    
    func addTag(_ tagView: UIView) {
        tags.append(tagView)
        addSubview(tagView)
        setNeedsLayout()
        invalidateIntrinsicContentSize()
    }
    
    func removeAllTags() {
        tags.forEach { $0.removeFromSuperview() }
        tags.removeAll()
    }

    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        var currentX: CGFloat = 0
        var currentY: CGFloat = 0
        var maxHeight: CGFloat = 0
        
        for tag in tags {
            let tagSize = tag.sizeThatFits(bounds.size)
            
            if currentX + tagSize.width > bounds.width {
                currentX = 0
                currentY += maxHeight + verticalSpacing
                maxHeight = 0
            }
            
            tag.frame = CGRect(x: currentX, y: currentY, width: tagSize.width, height: tagSize.height)
            currentX += tagSize.width + horizontalSpacing
            maxHeight = max(maxHeight, tagSize.height)
        }
        
        invalidateIntrinsicContentSize()
    }
    
    override var intrinsicContentSize: CGSize {
        var maxY: CGFloat = 0
        var currentX: CGFloat = 0
        var currentY: CGFloat = 0
        var maxHeight: CGFloat = 0
        
        for tag in tags {
            let tagSize = tag.sizeThatFits(bounds.size)
            
            if currentX + tagSize.width > bounds.width {
                currentX = 0
                currentY += maxHeight + verticalSpacing
                maxHeight = 0
            }
            
            currentX += tagSize.width + horizontalSpacing
            maxHeight = max(maxHeight, tagSize.height)
            maxY = currentY + maxHeight
        }
        
        return CGSize(width: bounds.width, height: maxY + verticalSpacing)
    }
}
