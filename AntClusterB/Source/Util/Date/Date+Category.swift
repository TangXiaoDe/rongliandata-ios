//
//  Date+Category.swift
//  AntClusterB
//
//  Created by crow on 2021/8/10.
//  Copyright © 2021 ChainOne. All rights reserved.
//

import Foundation

public extension Date {
    func getDaysInCurrentMonth() -> Int {
        let calendar = Calendar.current

        let date = Date()
        let nowComps = calendar.dateComponents([.year, .month, .day], from: date)
        let year: Int = nowComps.year ?? 2000
        let month: Int = nowComps.month ?? 1

        var startComps = DateComponents()
        startComps.day = 1
        startComps.month = month
        startComps.year = year

        var endComps = DateComponents()
        endComps.day = 1
        endComps.month = month == 12 ? 1 : month + 1
        endComps.year = month == 12 ? year + 1 : year

        let startDate: Date = calendar.date(from: startComps) ?? Date()
        let endDate: Date = calendar.date(from: endComps) ?? Date()

        let diff = calendar.dateComponents([.day], from: startDate, to: endDate)
        return diff.day ?? 30
    }
}
