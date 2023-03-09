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
            self.titleLabel.text = viewModel.title
            self.roadContextBarView.configure(viewModel: viewModel)
        }
        self.collectionViewHeightConstraint.constant =
         RoadContextDataView.collectionViewCellHeight *
        CGFloat(Int(ceil(Double(viewModel?.getActiveContextNumber() ?? 1) / 2.0)))         // swiftlint:disable:this no_magic_numbers
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
            itemCell.update(title: RoadContextViewModel.getRoadContextTitle(context), color: RoadContextViewModel.getRoadContextColor(context))
        }
        return cell
    }
}
extension RoadContextDataView: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        // swiftlint:disable:next no_magic_numbers
        return CGSize(width: collectionView.bounds.width / 2, height: RoadContextDataView.collectionViewCellHeight)
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
            barViewItems.append(DKRoundedBarViewItem(percent: item.percent, color: RoadContextViewModel.getRoadContextColor(item.context)))
        }
        draw(items: barViewItems, rect: rect)
    }

    func configure(viewModel: RoadContextViewModel) {
        self.viewModel = viewModel
        self.setNeedsDisplay()
    }
}
