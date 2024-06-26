//
//  SynthesisCardsView.swift
//  DriveKitDriverDataUI
//
//  Created by David Bauduin on 08/04/2021.
//  Copyright © 2021 DriveQuant. All rights reserved.
//

import UIKit
import DriveKitCommonUI

final class SynthesisCardsView: UIView, Nibable {
    @IBOutlet private weak var collectionView: UICollectionView!
    @IBOutlet private weak var pageControl: UIPageControl!
    @IBOutlet private weak var collectionContainerView: UIView!
    @IBOutlet private weak var cardContainerView: UIView!

    var viewModel: SynthesisCardsViewModel? {
        didSet {
            update()
        }
    }

    override func awakeFromNib() {
        super.awakeFromNib()

        self.collectionView.register(SynthesisCardViewCell.self, forCellWithReuseIdentifier: "SynthesisCardViewCell")
        self.cardContainerView.applyCardStyle()
        self.collectionContainerView.roundCorners(clipping: true)
        self.pageControl.pageIndicatorTintColor = .dkPageIndicatorTintColor
        self.pageControl.currentPageIndicatorTintColor = DKUIColors.secondaryColor.color
    }

    private func update() {
        if self.collectionView != nil {
            self.collectionView.reloadData()
            self.pageControl.numberOfPages = self.viewModel?.synthesisCardViewModels.count ?? 0
        }
    }

}

extension SynthesisCardsView: UICollectionViewDataSource {

    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.viewModel?.synthesisCardViewModels.count ?? 0
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cardViewCell: SynthesisCardViewCell = collectionView.dequeue(
            withReuseIdentifier: "SynthesisCardViewCell",
            for: indexPath
        )
        cardViewCell.viewModel = self.viewModel?.synthesisCardViewModels[indexPath.item]
        return cardViewCell
    }

}

extension SynthesisCardsView: UIScrollViewDelegate {

    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        let index = scrollView.contentOffset.x / scrollView.bounds.width
        self.pageControl.currentPage = Int(index)
    }

}

extension SynthesisCardsView: UICollectionViewDelegateFlowLayout {

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return collectionView.bounds.size
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return .zero
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }

}
