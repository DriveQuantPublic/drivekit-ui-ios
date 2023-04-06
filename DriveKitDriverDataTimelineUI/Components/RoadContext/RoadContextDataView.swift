//
//  RoadContextDataView.swift
//  DriveKitDriverDataTimelineUI
//
//  Created by David Bauduin on 14/10/2022.
//  Copyright © 2022 DriveQuant. All rights reserved.
//

import UIKit
import DriveKitCommonUI
import DriveKitDBTripAccessModule

class RoadContextDataView: UIView {
    static let collectionViewCellHeight: CGFloat = 26.0
    @IBOutlet private weak var roadContextBarView: RoadContextBarView!
    @IBOutlet private weak var titleLabel: UILabel!
    @IBOutlet private weak var itemsCollectionView: UICollectionView!
    @IBOutlet private weak var collectionViewHeightConstraint: NSLayoutConstraint!
    private var viewModel: RoadContextViewModel?

    override func awakeFromNib() {
        super.awakeFromNib()
        setupView()
    }

    func setupView() {
        self.titleLabel.font = DKStyles.smallText.style.applyTo(font: .primary)
        self.itemsCollectionView.register(UINib(nibName: "RoadContextItemCell", bundle: .driverDataTimelineUIBundle), forCellWithReuseIdentifier: "RoadContextItemCell")
        self.refreshView()
    }

    func refreshView() {
        if let viewModel = viewModel {
            self.titleLabel.text = viewModel.getTitle()
            self.roadContextBarView.configure(viewModel: viewModel)
        }
        let inHalf = 0.5
        self.collectionViewHeightConstraint.constant =
         RoadContextDataView.collectionViewCellHeight *
        CGFloat(Int(ceil(Double(viewModel?.getActiveContextNumber() ?? 1) * inHalf)))
        self.itemsCollectionView.reloadData()
    }

    func configure(viewModel: RoadContextViewModel) {
        self.viewModel = viewModel
        self.refreshView()
    }
}

extension RoadContextDataView: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        guard let viewModel = viewModel else { return 0 }
        return viewModel.getActiveContextNumber()
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell: UICollectionViewCell = collectionView.dequeueReusableCell(withReuseIdentifier: "RoadContextItemCell", for: indexPath)
        if let itemCell = cell as? RoadContextItemCell,
           let items = viewModel?.itemsToDraw,
           items.count > indexPath.row {
            let context = items[indexPath.row].context
            itemCell.update(title: context.getTitle(), color: context.getColor())
        }
        return cell
    }
}
extension RoadContextDataView: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let inHalf = 0.5
        return CGSize(width: collectionView.bounds.width * inHalf, height: RoadContextDataView.collectionViewCellHeight)
    }
}
extension RoadContextDataView: RoadContextViewModelDelegate {
    func roadContextViewModelDidUpdate() {
        setupView()
    }
}

class RoadContextBarView: DKRoundedBarView {
    private var viewModel: RoadContextViewModel?

    override func draw(_ rect: CGRect) {
        guard let itemsToDraw = viewModel?.itemsToDraw, !itemsToDraw.isEmpty else {
            return
        }
        var barViewItems: [DKRoundedBarViewItem] = []
        for item in itemsToDraw {
            barViewItems.append(DKRoundedBarViewItem(percent: item.percent, color: item.context.getColor()))
        }
        draw(items: barViewItems, rect: rect)
    }

    func configure(viewModel: RoadContextViewModel) {
        self.viewModel = viewModel
        self.setNeedsDisplay()
    }
}
