//
//  CalendarHeaderViewModelTests.swift
//  CalendrTests
//
//  Created by Paker on 27/12/20.
//

import XCTest
import RxSwift
import RxTest
@testable import Calendr

class CalendarHeaderViewModelTests: XCTestCase {

    private let testScheduler = TestScheduler()
    private let disposeBag = DisposeBag()

    func testTitle() {
        let observer = testScheduler.createObserver(String.self)

        let dates: [DateComponents] = [
            .init(year: 2020, month: 1),
            .init(year: 2021, month: 6),
            .init(year: 2022, month: 12)
        ]

        let dateObservable = Observable.from(dates.compactMap(Calendar.current.date(from:)))

        CalendarHeaderViewModel(dateObservable: dateObservable)
            .titleObservable
            .bind(to: observer)
            .disposed(by: disposeBag)

        XCTAssertEqual(observer.values, ["Jan 2020", "Jun 2021", "Dec 2022"])
    }

}