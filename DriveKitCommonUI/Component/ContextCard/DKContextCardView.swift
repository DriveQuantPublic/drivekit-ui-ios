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
    @IBOutlet private weak var contextBarView: ContextBarView!
    @IBOutlet private weak var titleLabel: UILabel!
    @IBOutlet private weak var itemsCollectionView: UICollectionView!
    @IBOutlet private weak var collectionViewHeightConstraint: NSLayoutConstraint!
    private var viewModel: DKContextCard?

    public static func createView() -> DKContextCardView {
        guard let roadContextDataView = Bundle.driveKitCommonUIBundle?.loadNibNamed(
            "DKContextCardView",
            owner: nil,
            options: nil
        )?.first as? DKContextCardView else {
            preconditionFailure("Can't find bundle or nib for DKContextCardView")
        }
        return roadContextDataView
    }
    public override func awakeFromNib() {
        super.awakeFromNib()
        setupView()
    }

    func setupView() {
        self.titleLabel.font = DKStyles.smallText.style.applyTo(font: .primary)
        self.itemsCollectionView.register(UINib(nibName: "ContextItemCell", bundle: .driveKitCommonUIBundle), forCellWithReuseIdentifier: "ContextItemCell")
        self.refreshView()
    }

    func refreshView() {
        if let viewModel = viewModel {
            self.titleLabel.text = viewModel.getTitle()
            self.contextBarView.configure(viewModel: viewModel)
            var expectedCellHeight = 26.0
            let twoLinesCellHeight = 42.0
            for item in viewModel.getItems() where item.getSubtitle() != nil {
                expectedCellHeight = twoLinesCellHeight
                break
            }
            collectionViewCellHeight = expectedCellHeight
        }
        let inHalf = 0.5
        self.collectionViewHeightConstraint.constant =
         self.collectionViewCellHeight *
        CGFloat(Int(ceil(Double(viewModel?.getItems().count ?? 1) * inHalf)))
        self.itemsCollectionView.reloadData()
    }

    public func configure(viewModel: DKContextCard) {
        self.viewModel = viewModel
        self.refreshView()
    }

    // MARK: UICollectionViewDataSource protocol implementation
    public func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        guard let viewModel = viewModel else { return 0 }
        return viewModel.getItems().count
    }

    public func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell: UICollectionViewCell = collectionView.dequeueReusableCell(withReuseIdentifier: "ContextItemCell", for: indexPath)
        if let itemCell = cell as? ContextItemCell,
           let items = viewModel?.getItems(),
           items.count > indexPath.row {
            let context = items[indexPath.row]
            itemCell.update(title: context.getTitle(), subtitle: context.getSubtitle(), color: context.getColor())
        }
        return cell
    }

    // MARK: UICollectionViewDelegateFlowLayout protocol implementation
    public func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let inHalf = 0.5
        return CGSize(width: collectionView.bounds.width * inHalf, height: self.collectionViewCellHeight)
    }
}

class ContextBarView: DKRoundedBarView {
    private var viewModel: DKContextCard?

    override func draw(_ rect: CGRect) {
        guard let itemsToDraw = viewModel?.getItems(), !itemsToDraw.isEmpty else {
            return
        }
        var barViewItems: [DKRoundedBarViewItem] = []
        for item in itemsToDraw {
            if let percent = viewModel?.getContextPercent(item) {
                barViewItems.append(DKRoundedBarViewItem(percent: percent, color: item.getColor()))
            }
        }
        draw(items: barViewItems, rect: rect)
    }

    func configure(viewModel: DKContextCard) {
        self.viewModel = viewModel
        self.setNeedsDisplay()
    }
}
