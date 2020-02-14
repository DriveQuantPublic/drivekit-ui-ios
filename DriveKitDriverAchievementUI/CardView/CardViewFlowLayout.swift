//
//  CardViewFlowLayout.swift
//  DriveKitDriverAchievementUI
//
//  Created by Jérémy Bayle on 13/02/2020.
//  Copyright © 2020 DriveQuant. All rights reserved.
//

import UIKit

class CardViewFlowLayout: UICollectionViewFlowLayout {
    let zIndexBack =  -1
    let zIndexFront = 0
    
    var decorationAttributes = [IndexPath:UICollectionViewLayoutAttributes]()
    
    
    override init () {
        super.init()
        register(CardViewCollectionReusableView.self, forDecorationViewOfKind: "CardViewCollectionReusableView")
        scrollDirection = .vertical
        sectionInset = UIEdgeInsets(top: 8, left: 8, bottom: 8, right: 8)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    override func prepare() {
        super.prepare()
        
        guard let collectionView = collectionView else {
            return
        }
        
        decorationAttributes.removeAll()
        
        let numberOfSections = collectionView.numberOfSections
        for section in 0..<numberOfSections  {
            
            let firstCellIndexPath = IndexPath(row: 0, section: section)
            let customSectionAttributes = CustomLayoutAttributes(forDecorationViewOfKind: "CardViewCollectionReusableView", with: firstCellIndexPath)
            
            customSectionAttributes.zIndex = zIndexBack
            customSectionAttributes.frame = decorationFrameForSection(section: section)
            
            customSectionAttributes.backgroundColor = .white
            customSectionAttributes.cornerRadius = 2.0
            customSectionAttributes.masksToBounds = false
            customSectionAttributes.shadowOpacity = 0.5
            customSectionAttributes.shadowColor = .black
            customSectionAttributes.shadowOffset = CGSize(width: 1, height: 1)
            decorationAttributes[firstCellIndexPath] = customSectionAttributes
            
        }
    }
    
    override func layoutAttributesForElements(in rect: CGRect) -> [UICollectionViewLayoutAttributes]? {
        if let attributes = super.layoutAttributesForElements(in: rect) {
            return attributes + decorationAttributes.values
        }
        return nil
    }
    
    override func layoutAttributesForDecorationView(ofKind elementKind: String, at indexPath: IndexPath) -> UICollectionViewLayoutAttributes? {
        return decorationAttributes[indexPath]
    }
    
    override func layoutAttributesForItem(at indexPath: IndexPath) -> UICollectionViewLayoutAttributes? {
        guard let attributes = super.layoutAttributesForItem(at: indexPath) else {
            return nil
        }
        return attributes
    }
    
    override func layoutAttributesForSupplementaryView(ofKind elementKind: String, at indexPath: IndexPath) -> UICollectionViewLayoutAttributes? {
        guard let attributes = super.layoutAttributesForSupplementaryView(ofKind: elementKind, at: indexPath) else {
            return nil
        }
        return attributes
    }
    
    private func decorationFrameForSection(section : Int) -> CGRect {
        
        guard let collectionView = collectionView else {
            return .zero
        }
        
        let firstCellIndexPath = IndexPath(row: 0, section: section)
        let firstCellAttributes = layoutAttributesForItem(at: firstCellIndexPath)!
        
        let numberOfRowsInSection = collectionView.numberOfItems(inSection: section)
        let lastCellIndexPath = IndexPath(row: numberOfRowsInSection - 1, section: section)
        let lastCellAttributes = layoutAttributesForItem(at: lastCellIndexPath)!
        
        
        let origin = CGPoint(x: firstCellAttributes.frame.minX - sectionInset.left / 2, y: firstCellAttributes.frame.minY - sectionInset.top / 2)
        
        let size = CGSize(width: firstCellAttributes.bounds.width + sectionInset.left / 2 + sectionInset.right / 2, height: lastCellAttributes.frame.maxY - firstCellAttributes.frame.minY + sectionInset.top / 2 + sectionInset.bottom / 2)
        
        return CGRect(origin: origin, size: size)
        
    }
    
}
