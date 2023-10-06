// swiftlint:disable all
//
//  LastTripsView.swift
//  DriveKitCommonUI
//
//  Created by David Bauduin on 19/08/2021.
//  Copyright © 2021 DriveQuant. All rights reserved.
//

import UIKit

final class LastTripsView: UIView, Nibable {
    @IBOutlet private weak var collectionView: UICollectionView!
    @IBOutlet private weak var pageControl: UIPageControl!
    private let sections: [LastTripsViewSection] = [.trips, .showAllTrips]

    var viewModel: LastTripsViewModel? {
        didSet {
            update()
        }
    }

    override func awakeFromNib() {
        super.awakeFromNib()

        setupCollectionView()
        setupPageControl()
    }

    private func setupCollectionView() {
        self.collectionView.register(LastTripsViewCell.nib, forCellWithReuseIdentifier: "LastTripsViewCell")
        self.collectionView.register(MoreTripsViewCell.nib, forCellWithReuseIdentifier: "MoreTripsViewCell")
    }

    private func setupPageControl() {
        self.pageControl.pageIndicatorTintColor = DKUIColors.neutralColor.color
        self.pageControl.currentPageIndicatorTintColor = DKUIColors.secondaryColor.color
    }

    private func update() {
        if self.collectionView != nil {
            self.collectionView.reloadData()
            var numberOfItems = 0
            for section in self.sections {
                switch section {
                    case .trips:
                        numberOfItems += self.viewModel?.trips.count ?? 0
                    case .showAllTrips:
                        numberOfItems += 1
                }
            }
            self.pageControl.numberOfPages = numberOfItems
        }
    }

}

extension LastTripsView: UICollectionViewDataSource {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return self.sections.count
    }

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        switch self.sections[section] {
            case .trips:
                return self.viewModel?.trips.count ?? 0
            case .showAllTrips:
                return 1
        }
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if let viewModel = self.viewModel {
            let cell: UICollectionViewCell
            switch self.sections[indexPath.section] {
                case .trips:
                    if let tripCell = collectionView.dequeueReusableCell(withReuseIdentifier: "LastTripsViewCell", for: indexPath) as? LastTripsViewCell {
                        let trip = viewModel.trips[indexPath.row]
                        tripCell.configure(trip: trip, tripData: viewModel.tripData, title: viewModel.titleForTrip(trip))
                        if let tripInfoView = tripCell.tripInfoView {
                            let gestureRec = UITapGestureRecognizer(target: self, action: #selector(tripInfoAction(_:)))
                            gestureRec.delegate = self
                            tripInfoView.addGestureRecognizer(gestureRec)
                        }
                        cell = tripCell
                    } else {
                        cell = UICollectionViewCell()
                    }
                case .showAllTrips:
                    if let moreTripCell = collectionView.dequeueReusableCell(withReuseIdentifier: "MoreTripsViewCell", for: indexPath) as? MoreTripsViewCell {
                        moreTripCell.hasMoreTrips = !viewModel.trips.isEmpty
                        cell = moreTripCell
                    } else {
                        cell = UICollectionViewCell()
                    }

            }
            return cell
        } else {
            return UICollectionViewCell()
        }
    }

    @objc private func tripInfoAction(_ sender: UITapGestureRecognizer) {
        if let tripInfoView = sender.view as? TripInfoView, let tripItem = tripInfoView.trip, let viewModel = self.viewModel {
            viewModel.didSelectInfoView(of: tripItem)
        }
    }
}

extension LastTripsView: UIGestureRecognizerDelegate {
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldReceive touch: UITouch) -> Bool {
        if let _ = touch.view as? TripInfoView { return true }
        return false
    }
}

extension LastTripsView: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if let viewModel = self.viewModel {
            switch self.sections[indexPath.section] {
                case .trips:
                    viewModel.didSelectTrip(at: indexPath.row)
                case .showAllTrips:
                    viewModel.didSelectAllTrips()
            }
        }
    }
}

extension LastTripsView: UIScrollViewDelegate {
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        let index = scrollView.contentOffset.x / scrollView.bounds.width
        self.pageControl.currentPage = Int(index)
    }
}

extension LastTripsView: UICollectionViewDelegateFlowLayout {
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

private enum LastTripsViewSection: Int {
    case trips
    case showAllTrips
}
