//
//  DKContextCardView.swift
//  DriveKitCommonUI
//
//  Created by Amine Gahbiche on 06/04/2023.
//  Copyright © 2023 DriveQuant. All rights reserved.
//

import UIKit

public class DKContextCardView: UIView, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    var collectionViewCellHeight: CGFloat = 26.0
    let numberOfColumns = 2.0
    @IBOutlet private weak var contextBarView: ContextBarView!
    @IBOutlet private weak var titleLabel: UILabel!
    @IBOutlet private weak var itemsCollectionView: UICollectionView!
    private var viewModel: DKContextCard?

    public static func createView() -> DKContextCardView {
        guard let contextCardView = Bundle.driveKitCommonUIBundle?.loadNibNamed(
            "DKContextCardView",
            owner: nil,
            options: nil
        )?.first as? DKContextCardView else {
            preconditionFailure("Can't find bundle or nib for DKContextCardView")
        }
        return contextCardView
    }
    public override func awakeFromNib() {
        super.awakeFromNib()
        setupView()
    }

    func setupView() {
        self.titleLabel.font = DKStyles.headLine2.style.applyTo(font: .primary)
        self.titleLabel.textColor = DKUIColors.mainFontColor.color
        self.itemsCollectionView.register(UINib(nibName: "ContextItemCell", bundle: .driveKitCommonUIBundle), forCellWithReuseIdentifier: "ContextItemCell")
        self.refreshView()
    }

    public func refreshView() {
        if let viewModel = viewModel {
            self.titleLabel.text = viewModel.title
            self.contextBarView.configure(viewModel: viewModel)
            var expectedCellHeight = 26.0
            let twoLinesCellHeight = 42.0
            let threeLinesCellHeight = 63.0
            let font = DKStyles.normalText.style.applyTo(font: .primary)
            let fontAttributes = [NSAttributedString.Key.font: font]
            
            var hasTwoLineTitle = false
            for item in viewModel.items {
                let size = (item.title as NSString).size(withAttributes: fontAttributes)
                let half = 0.5
                let marginAndDots = 130.0
                if size.width >= (self.bounds.width - marginAndDots) * half {
                    hasTwoLineTitle = true
                    expectedCellHeight = twoLinesCellHeight
                }
            }
            
            for item in viewModel.items where item.subtitle != nil {
                expectedCellHeight = hasTwoLineTitle ? threeLinesCellHeight : twoLinesCellHeight
                break
            }
            collectionViewCellHeight = expectedCellHeight
        }
        self.itemsCollectionView.reloadData()
    }

    public func configure(viewModel: DKContextCard) {
        self.viewModel = viewModel
        self.refreshView()
    }

    // MARK: UICollectionViewDataSource protocol implementation
    public func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        guard let viewModel = viewModel else { return 0 }
        return viewModel.items.count
    }

    public func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell: UICollectionViewCell = collectionView.dequeueReusableCell(withReuseIdentifier: "ContextItemCell", for: indexPath)
        if let itemCell = cell as? ContextItemCell,
           let items = viewModel?.items,
           items.count > indexPath.row {
            let context = items[indexPath.row]
            itemCell.update(with: context)
        }
        return cell
    }

    // MARK: UICollectionViewDelegateFlowLayout protocol implementation
    public func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: collectionView.bounds.width / numberOfColumns, height: self.collectionViewCellHeight)
    }
}

class ContextBarView: DKRoundedBarView {
    private var viewModel: DKContextCard?

    override func draw(_ rect: CGRect) {
        guard let itemsToDraw = viewModel?.items, !itemsToDraw.isEmpty else {
            return
        }
        var barViewItems: [DKRoundedBarViewItem] = []
        for item in itemsToDraw {
            if let percent = viewModel?.getContextPercent(item) {
                barViewItems.append(DKRoundedBarViewItem(percent: percent, color: item.color))
            }
        }
        draw(items: barViewItems, rect: rect)
    }

    func configure(viewModel: DKContextCard) {
        self.viewModel = viewModel
        self.setNeedsDisplay()
    }
}

class TopAlignedLabel: UILabel {
      override func drawText(in rect: CGRect) {
        let textRect = super.textRect(forBounds: bounds, limitedToNumberOfLines: numberOfLines)
        super.drawText(in: textRect)
      }
}
