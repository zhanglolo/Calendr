//
//  SettingsTests.swift
//  CalendrUITests
//
//  Created by Paker on 18/07/2021.
//

import XCTest

class SettingsTests: UITestCase {

    func testSettingsTabs() {

        MenuBar.main.click()
        Main.settingsBtn.click()

        XCTAssertEqual(Settings.tabs.map(\.title), ["General", "Calendars", "About"])
        XCTAssertTrue(Settings.General.view.didAppear)

        XCTAssertFalse(Settings.Calendars.view.didAppear)
        Settings.Tab.calendars.click()
        XCTAssertTrue(Settings.Calendars.view.didAppear)

        XCTAssertFalse(Settings.About.view.didAppear)
        Settings.Tab.about.click()
        XCTAssertTrue(Settings.About.view.didAppear)

        XCTAssertFalse(Settings.General.view.didAppear)
        Settings.Tab.general.click()
        XCTAssertTrue(Settings.General.view.didAppear)
    }

    func testSettingsAbout_withQuitClicked_shouldCloseApp() {

        MenuBar.main.click()
        Main.settingsBtn.click()
        Settings.Tab.about.click()
        Settings.About.quitBtn.click()

        XCTAssertEqual(app.state, .notRunning)
    }

    func testSettingsCalendarPicker() {

        MenuBar.main.click()
        Main.settingsBtn.click()
        Settings.Tab.calendars.click()

        let checkbox = Settings.Calendars.view.checkBoxes
            .element(matching: NSPredicate(format: "title = %@", "Personal"))

        XCTAssert(checkbox.waitForExistence(timeout: 1))

        let initial = Calendar.events.count

        XCTAssert(initial > 0)

        checkbox.click()

        XCTAssertEqual(Calendar.events.count, initial - 1)

        // click label
        checkbox.coordinate(withNormalizedOffset: .init(dx: 0.3, dy: 0.5)).click()

        XCTAssertEqual(Calendar.events.count, initial)
    }

    func testSettingsGeneral_toggleShowIcon() {

        MenuBar.main.click()
        Main.settingsBtn.click()

        let showIcon = Settings.General.view.checkBoxes
            .element(matching: NSPredicate(format: "title = %@", "Show icon"))

        showIcon.click()
        XCTAssertFalse(showIcon.isChecked)
        XCTAssertEqual(MenuBar.main.title, "Friday, 1 January 2021")

        showIcon.click()
        XCTAssertTrue(showIcon.isChecked)
        XCTAssertNotEqual(MenuBar.main.title, "Friday, 1 January 2021")
        XCTAssertTrue(MenuBar.main.title.hasSuffix("Friday, 1 January 2021"))
    }

    func testSettingsGeneral_toggleShowDate() {

        MenuBar.main.click()
        Main.settingsBtn.click()

        let showDate = Settings.General.view.checkBoxes
            .element(matching: NSPredicate(format: "title = %@", "Show date"))

        showDate.click()
        XCTAssertFalse(showDate.isChecked)
        XCTAssertFalse(MenuBar.main.title.hasSuffix("Friday, 1 January 2021"))

        showDate.click()
        XCTAssertTrue(showDate.isChecked)
        XCTAssertTrue(MenuBar.main.title.hasSuffix("Friday, 1 January 2021"))
    }

    func testSettingsGeneral_toggleShowDateOffWithShowIconOff() {

        MenuBar.main.click()
        Main.settingsBtn.click()

        let showIcon = Settings.General.view.checkBoxes
            .element(matching: NSPredicate(format: "title = %@", "Show icon"))

        let showDate = Settings.General.view.checkBoxes
            .element(matching: NSPredicate(format: "title = %@", "Show date"))

        showIcon.click()
        XCTAssertFalse(showIcon.isChecked)
        XCTAssertTrue(showDate.isChecked)
        XCTAssertEqual(MenuBar.main.title, "Friday, 1 January 2021")

        showDate.click()
        XCTAssertTrue(showIcon.isChecked)
        XCTAssertFalse(showDate.isChecked)
        XCTAssertFalse(MenuBar.main.title.hasSuffix("Friday, 1 January 2021"))
    }

    func testSettingsGeneral_toggleShowIconOffWithShowDateOff() {

        MenuBar.main.click()
        Main.settingsBtn.click()

        let showIcon = Settings.General.view.checkBoxes
            .element(matching: NSPredicate(format: "title = %@", "Show icon"))

        let showDate = Settings.General.view.checkBoxes
            .element(matching: NSPredicate(format: "title = %@", "Show date"))

        showDate.click()
        XCTAssertTrue(showIcon.isChecked)
        XCTAssertFalse(showDate.isChecked)
        XCTAssertFalse(MenuBar.main.title.hasSuffix("Friday, 1 January 2021"))

        showIcon.click()
        XCTAssertTrue(showIcon.isChecked)
        XCTAssertFalse(showDate.isChecked)
        XCTAssertFalse(MenuBar.main.title.hasSuffix("Friday, 1 January 2021"))

        showDate.click()
        XCTAssertFalse(showIcon.isChecked)
        XCTAssertTrue(showDate.isChecked)
        XCTAssertEqual(MenuBar.main.title, "Friday, 1 January 2021")
    }

    func testSettingsGeneral_toggleShowNextEvent() {

        MenuBar.main.click()
        Main.settingsBtn.click()

        let checkbox = Settings.General.view.checkBoxes
            .element(matching: NSPredicate(format: "title = %@", "Show next event"))

        XCTAssertTrue(MenuBar.event.exists)

        checkbox.click()
        XCTAssertFalse(MenuBar.event.exists)

        checkbox.click()
        XCTAssertTrue(MenuBar.event.exists)
    }

    func testSettingsGeneral_changeDateFormat() {

        MenuBar.main.click()
        Main.settingsBtn.click()

        let dropdown = Settings.General.view.popUpButtons.element

        XCTAssertEqual(dropdown.text, "Friday, 1 January 2021")
        XCTAssertTrue(MenuBar.main.title.hasSuffix("Friday, 1 January 2021"))

        dropdown.click()
        dropdown.menuItems.element(boundBy: 0).click()

        XCTAssertEqual(dropdown.text, "01/01/2021")
        XCTAssertTrue(MenuBar.main.title.hasSuffix("01/01/2021"))
    }

    func testSettingsGeneral_toggleShowWeekNumbers() {

        MenuBar.main.click()
        Main.settingsBtn.click()

        let checkbox = Settings.General.view.checkBoxes
            .element(matching: NSPredicate(format: "title = %@", "Show week numbers"))

        XCTAssertTrue(Calendar.weekNumbers.first!.isHittable)

        checkbox.click()
        XCTAssertFalse(Calendar.weekNumbers.first!.isHittable)

        checkbox.click()
        XCTAssertTrue(Calendar.weekNumbers.first!.isHittable)
    }
}