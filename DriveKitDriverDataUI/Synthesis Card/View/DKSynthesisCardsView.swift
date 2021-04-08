//
//  DKSynthesisCardsView.swift
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

    var viewModel: SynthesisCardsViewModel? = nil {
        didSet {
            update()
        }
    }

    override func awakeFromNib() {
        super.awakeFromNib()

        self.collectionView.register(DKSynthesisCardViewCell.self, forCellWithReuseIdentifier: "DKSynthesisCardViewCell")
        self.pageControl.hidesForSinglePage = true
        self.pageControl.pageIndicatorTintColor = DKUIColors.neutralColor.color
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
        let cardViewCell: DKSynthesisCardViewCell = collectionView.dequeueReusableCell(withReuseIdentifier: "DKSynthesisCardViewCell", for: indexPath) as! DKSynthesisCardViewCell
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
