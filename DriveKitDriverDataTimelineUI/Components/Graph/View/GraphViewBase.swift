//
//  GraphViewBase.swift
//  DriveKitDriverDataTimelineUI
//
//  Created by David Bauduin on 14/10/2022.
//  Copyright © 2022 DriveQuant. All rights reserved.
//

import UIKit
import ChartsForDK

class GraphViewBase: UIView {
    weak var delegate: GraphViewDelegate?
    private(set) var viewModel: GraphViewModel

    init(viewModel: GraphViewModel) {
        self.viewModel = viewModel
        super.init(frame: .zero)
        if let chartView = getChartView() {
            chartView.translatesAutoresizingMaskIntoConstraints = false
            self.addSubview(chartView)
            NSLayoutConstraint.activate([
                chartView.topAnchor.constraint(equalTo: self.topAnchor),
                chartView.bottomAnchor.constraint(equalTo: self.bottomAnchor),
                chartView.leftAnchor.constraint(equalTo: self.leftAnchor),
                chartView.rightAnchor.constraint(equalTo: self.rightAnchor)
            ])
        }
        self.viewModel.graphViewModelDidUpdate = { [weak self] in
            self?.setupData()
        }
        setupData()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func getChartView() -> BarLineChartViewBase? {
        return nil
    }

    func setupData() {
        // Must be implemented by the subclass.
    }
}

class GraphAxisFormatter: IAxisValueFormatter {
    private let config: GraphAxisConfig?

    init(config: GraphAxisConfig?) {
        self.config = config
    }

    func stringForValue(_ value: Double, axis: ChartsForDK.AxisBase?) -> String {
        if let config = self.config, let min = config.min, let labels = config.labels {
            let index = Int(value - min)
            if index >= 0 && index < labels.count {
                return labels[index]
            }
        }
        return String(value)
    }
}
