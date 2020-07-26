//
//  DoYouKnowTheWordTests.swift
//  DoYouKnowTheWordTests
//
//  Created by Karthikeya Udupa on 15/07/2020.
//  Copyright © 2020 Karthikeya Udupa. All rights reserved.
//

import XCTest
@testable import DoYouKnowTheWord

class DoYouKnowTheWordTests: XCTestCase {
    override func setUpWithError() throws {}

    override func tearDownWithError() throws {}

    func testLocalisedItemInitialisation() throws {
        let item = LocalisedItem("kSample_Key")
        XCTAssert(item.id == "kSample_Key")
        XCTAssertNil(item.context)
        XCTAssertEqual(item.supportedLocaleCount(), 0)
        let englishLocale = Locale(identifier: "EN_GB")
        // Since it has no locale available it should be considered as translated (or empty string).
        XCTAssertTrue(item.isFullyTranslated(allRequestedlocales: [englishLocale]))
    }

    func testLocalisedItemWithTranslations() throws {
        var item = LocalisedItem("kSample_Key")
        let englishLocale = Locale(identifier: "EN_GB")
        let deutscheLocale = Locale(identifier: "DE_DE")

        item.updateTranslation(locale: englishLocale, translationValue: "Test Value")
        XCTAssertEqual(item.supportedLocales.count, 1)
        XCTAssertEqual(item.supportedLocales, [englishLocale])

        item.updateTranslation(locale: deutscheLocale, translationValue: "Test Value DE")
        XCTAssertEqual(item.supportedLocales.count, 2)
        XCTAssertEqual(Set(item.supportedLocales), Set([englishLocale, deutscheLocale]))
        XCTAssertEqual(item.translation(locale: deutscheLocale), "Test Value DE")

        item.updateTranslation(locale: deutscheLocale, translationValue: nil)
        XCTAssertEqual(item.supportedLocales.count, 1)
        XCTAssertEqual(item.supportedLocales, [englishLocale])
        XCTAssertEqual(item.translation(locale: deutscheLocale), nil)
        XCTAssertEqual(item.translation(locale: englishLocale), "Test Value")
    }

    func testInvalidLocale() throws {
        var localisedContent = LocalisedContent()

        let localeHNGLISH = Locale(identifier: "hinglish")
        let contentHNGLISH: [String: String] = ["key_1": "value_1", "key_2": "value_2"]
        localisedContent.addLocalisedContent(locale: localeHNGLISH, content: contentHNGLISH)
        XCTAssertEqual(localisedContent.supportedLocales.count, 0)
    }

    func testLocalisedContentAddingNewLanguage() throws {
        var localisedContent = LocalisedContent()

        let localeEN = Locale(identifier: "EN_GB")
        let localeENUS = Locale(identifier: "EN_US")
        let localeDE = Locale(identifier: "DE_DE")

        // Test empty states in case things change in the future this should not break.
        XCTAssertNil(localisedContent.getAllTranslationKeys())
        XCTAssertNil(localisedContent.all())
        XCTAssertFalse(localisedContent.isFullyTranslated())

        let contentENGB: [String: String] = ["key_1": "value_1", "key_2": "value_2"]
        localisedContent.addLocalisedContent(locale: localeEN, content: contentENGB)
        let contentDEDE: [String: String] = ["key_1": "value_1_DE", "key_2": "value_2_DE", "key_3": "value_3_DE"]
        localisedContent.addLocalisedContent(locale: localeDE, content: contentDEDE)

        let allStrings = localisedContent.all()
        var localisedItem = (allStrings?.first)!
        localisedItem.updateTranslation(locale: localeENUS, translationValue: "english_us_value")
        localisedContent.updateTranslation(item: localisedItem)

        XCTAssertFalse(localisedContent.isFullyTranslated())
        XCTAssertEqual(localisedContent.supportedLocales.count, 3)
        XCTAssertEqual(Set(localisedContent.supportedLocales), Set([localeEN, localeENUS, localeDE]))
    }

    func testLocalisedContent() throws {
        let localisedContent = LocalisedContent()
        XCTAssert(localisedContent.allLocalisedItems.isEmpty)
        XCTAssert(localisedContent.supportedLocales.isEmpty)
        XCTAssertFalse(localisedContent.contextAvailable)
    }

    func testLocalisedContentModifyContent() throws {
        var localisedContent = LocalisedContent()

        let localeEN = Locale(identifier: "EN_GB")
        let localeDE = Locale(identifier: "DE_DE")

        let contentENGB: [String: String] = ["key_1": "value_1", "key_2": "value_2"]
        localisedContent.addLocalisedContent(locale: localeEN, content: contentENGB)
        XCTAssertEqual(localisedContent.getAllTranslationKeys(), ["key_1", "key_2"])
        XCTAssertEqual(localisedContent.allLocalisedItems["key_1"]?.translation(locale: localeEN), "value_1")
        XCTAssertEqual(localisedContent.allLocalisedItems["key_2"]?.translation(locale: localeEN), "value_2")
        XCTAssertTrue(localisedContent.isFullyTranslated())
        let contentDEDE: [String: String] = ["key_1": "value_1_DE", "key_2": "value_2_DE", "key_3": "value_3_DE"]
        localisedContent.addLocalisedContent(locale: localeDE, content: contentDEDE)
        XCTAssertEqual(localisedContent.getAllTranslationKeys()!, ["key_1", "key_2", "key_3"])
        XCTAssertEqual(localisedContent.allLocalisedItems["key_1"]?.translation(locale: localeDE), "value_1_DE")
        XCTAssertEqual(localisedContent.allLocalisedItems["key_1"]?.translation(locale: localeEN), "value_1")
        XCTAssertEqual(localisedContent.allLocalisedItems["key_2"]?.translation(locale: localeDE), "value_2_DE")
        XCTAssertEqual(localisedContent.allLocalisedItems["key_2"]?.translation(locale: localeEN), "value_2")

        XCTAssertEqual(localisedContent.allLocalisedItems["key_3"]?.translation(locale: localeDE), "value_3_DE")
        XCTAssertNil(localisedContent.allLocalisedItems["key_3"]?.translation(locale: localeEN))

        XCTAssertFalse(localisedContent.isFullyTranslated())
        XCTAssertEqual(localisedContent.allTranslatedContent().count, 2)
        XCTAssertEqual(localisedContent.allUntranslatedContent().count, 1)

        XCTAssertEqual(Set(localisedContent.allTranslatedContent().map { $0.id }), Set(["key_1", "key_2"]))
        XCTAssertEqual(localisedContent.allUntranslatedContent().map { $0.id }, ["key_3"])

        var untranslatedItem = localisedContent.getLocalisedItem(translationKey: "key_3")
        untranslatedItem!.updateTranslation(locale: localeEN, translationValue: "value_3_EN")
        localisedContent.updateTranslation(item: untranslatedItem!)

        XCTAssertEqual(localisedContent.allLocalisedItems["key_3"]?.translation(locale: localeDE), "value_3_DE")
        XCTAssertEqual(localisedContent.allLocalisedItems["key_3"]?.translation(locale: localeEN), "value_3_EN")
        XCTAssertTrue(localisedContent.isFullyTranslated())

        untranslatedItem!.updateTranslation(locale: localeEN, translationValue: nil)
        localisedContent.updateTranslation(item: untranslatedItem!)

        XCTAssertEqual(localisedContent.allLocalisedItems["key_3"]?.translation(locale: localeDE), "value_3_DE")
        XCTAssertNil(localisedContent.allLocalisedItems["key_3"]?.translation(locale: localeEN))
        XCTAssertFalse(localisedContent.isFullyTranslated())
    }

    func testLocalisedContentContextModification() throws {
        var localisedContent = LocalisedContent()

        let localeEN = Locale(identifier: "EN_GB")
        let localeDE = Locale(identifier: "DE_DE")

        let contentENGB: [String: String] = ["key_1": "value_1", "key_2": "value_2"]
        localisedContent.addLocalisedContent(locale: localeEN, content: contentENGB)
        let contentDEDE: [String: String] = ["key_1": "value_1_DE", "key_2": "value_2_DE", "key_3": "value_3_DE"]
        localisedContent.addLocalisedContent(locale: localeDE, content: contentDEDE)

        localisedContent.addContext(content: ["key_1": "CTX_1", "key_2": "CTX_2", "key_3": "CTX_3", "key_4": "CTX_4"])

        XCTAssertEqual(localisedContent.all()?.count, 3)
        XCTAssertEqual(localisedContent.getLocalisedItem(translationKey: "key_1")?.context, "CTX_1")
        XCTAssertEqual(localisedContent.getLocalisedItem(translationKey: "key_2")?.context, "CTX_2")
        XCTAssertEqual(localisedContent.getLocalisedItem(translationKey: "key_3")?.context, "CTX_3")
        XCTAssertEqual(localisedContent.getLocalisedItem(translationKey: "key_4")?.context, "CTX_4")
        XCTAssertEqual(localisedContent.getLocalisedItem(translationKey: "key_4")?.supportedLocaleCount(), 0)

        let allStrings = localisedContent.all()
        var localisedItem = (allStrings?.first)!
        localisedItem.context = "new_context"
        localisedContent.updateTranslation(item: localisedItem)
        XCTAssertEqual(localisedContent.all()?.first?.context, "new_context")
    }

    func testMappingGeneration() throws {
        var localisedContent = LocalisedContent()

        let localeEN = Locale(identifier: "EN_GB")
        let localeDE = Locale(identifier: "DE_DE")
        let localeENUS = Locale(identifier: "EN_US")

        XCTAssertEqual(localisedContent.localisedMapping(locale: localeEN), Dictionary())
        XCTAssertEqual(localisedContent.contextMapping(), nil)

        let contentENGB: [String: String] = ["key_1": "value_1", "key_2": "value_2"]
        localisedContent.addLocalisedContent(locale: localeEN, content: contentENGB)
        let contentDEDE: [String: String] = ["key_1": "value_1_DE", "key_2": "value_2_DE", "key_3": "value_3_DE"]
        localisedContent.addLocalisedContent(locale: localeDE, content: contentDEDE)

        localisedContent.addContext(content: ["key_1": "CTX_1", "key_2": "CTX_2", "key_3": "CTX_3", "key_4": "CTX_4"])
        XCTAssertEqual(localisedContent.localisedMapping(locale: localeEN), ["key_1": "value_1", "key_2": "value_2"])
        XCTAssertEqual(localisedContent.localisedMapping(locale: localeDE), ["key_1": "value_1_DE", "key_2": "value_2_DE", "key_3": "value_3_DE"])

        let allStrings = localisedContent.all()
        var localisedItem = (allStrings?.first)!
        localisedItem.updateTranslation(locale: localeENUS, translationValue: "english_us_value")
        localisedContent.updateTranslation(item: localisedItem)
        XCTAssertEqual(localisedContent.localisedMapping(locale: localeENUS), ["key_1": "english_us_value"])
        XCTAssertEqual(localisedContent.contextMapping(), ["key_1": "CTX_1", "key_2": "CTX_2", "key_3": "CTX_3", "key_4": "CTX_4"])
    }
}
