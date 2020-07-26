//
//  LocalisedContent.swift
//  DoYouKnowTheWord
//
//  Created by Karthikeya Udupa on 25/07/2020.
//  Copyright © 2020 Karthikeya Udupa. All rights reserved.
//

import Foundation

extension Array where Element == String {
    /// Compares items inside an array in a case-sensitive manner and finds a match.
    /// - Parameter element: Element to search, has to be a string
    /// - Returns: Boolean indicating if the item was found or not.
    func containsIgnoringCase(_ element: Element) -> Bool {
        contains { $0.caseInsensitiveCompare(element) == .orderedSame }
    }
}

extension Locale {
    /// Checks the `Locale` object and finds the string in the list of known locale-identifiers (case insensitive)
    /// - Parameter code: Locale string to cross check against the available list of locales
    /// - Returns: Boolean indicating if the locale string is valid or not.
    static func isValidLocalisationString(code: String) -> Bool {
        return Locale.availableIdentifiers.containsIgnoringCase(code)
    }

    // Since a `Locale` can be initiated with any identifier, we validate if the current locale is actually valid.
    func isValid() -> Bool {
        return Locale.isValidLocalisationString(code: identifier)
    }
}

/// Represents a localised string in the project with a valid key, context and all available localisations.
struct LocalisedItem: Codable, Identifiable {
    /// Unique key for the object that is also the translation key for the object, currently cannot have emoji (it's stripped off).
    var id: String
    /// Context for translation of the string.
    var context: String?
    private var translations: [Locale: String?]

    /// List of valid `Locale` the item has translations in.
    var supportedLocales: [Locale] { return Array(translations.keys) }

    /// Checks if the item has translations in all the requested `Locale`s.
    /// - Parameter allRequestedlocales: Array of Locales in which the translation needs to be presented to be marked as translated.
    /// - Returns: Boolean indicating if the item is fully translated.
    func isFullyTranslated(allRequestedlocales: [Locale]) -> Bool {
        // If there is no translation in any languages, we might just skip it and consider this as translated.
        guard !translations.isEmpty else {
            return true
        }
        // Since the var is private and we are manually removing values when nil is set for a key, this check should work.
        for item in allRequestedlocales where translations[item] == nil {
            return false
        }
        return true
    }

    // Clear the translation for a certain Locale.
    mutating func clearLocale(locale: Locale) {
        translations.removeValue(forKey: locale)
    }

    // Get translation for the item in a certain locale, returns `nil` if locale is unavailable
    func translation(locale: Locale) -> String? {
        return translations[locale] ?? nil
    }

    // Add/replace translation string for the item in a certain locale
    // Passing nil will remove the language from the list of supported languages for the item.
    mutating func updateTranslation(locale: Locale, translationValue: String?) {
        guard translationValue != nil else {
            clearLocale(locale: locale)
            return
        }
        translations.updateValue(translationValue, forKey: locale)
    }

    // Total number of locales that are supported by this item.
    func supportedLocaleCount() -> Int {
        return translations.count
    }

    // Initialise the translation with the translation key as the identifier.
    init(_ translationKey: String) {
        id = translationKey
        context = nil
        translations = Dictionary()
    }
}

/// Core object to handle all translation related logic for a set of translation files.
struct LocalisedContent: Codable {
    public private(set) var allLocalisedItems: [String: LocalisedItem]
    public private(set) var supportedLocales: Set<Locale>
    public private(set) var contextAvailable: Bool

    /// Add localised key-value pair of translation keys and values/translations in a certain locale.
    /// - Parameters:
    ///   - locale: Locale in which the translations are in.
    ///   - content: Content is a dictionary with key has the translation key and value as a translated string.
    mutating func addLocalisedContent(locale: Locale, content: [String: String]) {
        // If the locale is not valid, we do not process it (as of now).
        guard locale.isValid() else {
            return
        }
        // Add the locale to the list of supported locales (it's a set so it will never duplicate).
        supportedLocales.insert(locale)

        for (key, value) in content {
            var item = allLocalisedItems[key] ?? LocalisedItem(key)
            item.updateTranslation(locale: locale, translationValue: value)
            allLocalisedItems.updateValue(item, forKey: key)
        }
    }

    // Add context file to the translation.
    mutating func addContext(content: [String: String]) {
        contextAvailable = true
        for (key, value) in content {
            var item = allLocalisedItems[key] ?? LocalisedItem(key)
            item.context = value
            allLocalisedItems.updateValue(item, forKey: key)
        }
    }

    // Get all translation keys that have at least 1 translation (sorted alphabetically)
    func getAllTranslationKeys() -> [String]? {
        guard let allItems = all() else {
            return nil
        }
        return allItems.map { $0.id }
    }

    // Get all LocalisedItems that have at least 1 translation (sorted alphabetically)
    func all() -> [LocalisedItem]? {
        guard !allLocalisedItems.isEmpty else {
            return nil
        }
        var allValidItemsArray: [LocalisedItem] = allLocalisedItems.values.filter { $0.supportedLocaleCount() > 0 }
        // We are currently sorting by alphabetic order of keys, should be moved to a way where we can map it to the sequence of entry.
        allValidItemsArray.sort { $0.id.compare($1.id) == .orderedAscending }
        return allValidItemsArray
    }

    // Are all the items in the list have all supported languages translated.
    func isFullyTranslated() -> Bool {
        // If there are no items, it's not translated at all.
        guard let allItems = all() else {
            return false
        }
        // If we find 1 non-fully translated item, we can say that the whole set is not fully translated and no need to look for more examples.
        let firstNonLocalisedItem = allItems.first {
            !$0.isFullyTranslated(allRequestedlocales: Array(supportedLocales))
        }
        return firstNonLocalisedItem == nil ? true : false
    }

    // Provide a list of all untranslated items.
    func allUntranslatedContent() -> [LocalisedItem] {
        return allLocalisedItems.values.filter { !$0.isFullyTranslated(allRequestedlocales: Array(supportedLocales)) }
    }

    // Provide a list of all fully translated items.
    func allTranslatedContent() -> [LocalisedItem] {
        return allLocalisedItems.values.filter { $0.isFullyTranslated(allRequestedlocales: Array(supportedLocales)) }
    }

    // Update the translation for an item (or add it if the item does not exist).
    mutating func updateTranslation(item: LocalisedItem) {
        updateSupportedLocalesIfNeeded(locales: item.supportedLocales)
        allLocalisedItems.updateValue(item, forKey: item.id)
    }

    // Get `LocalisedItem` for a translation key (if available)
    func getLocalisedItem(translationKey: String) -> LocalisedItem? {
        return allLocalisedItems[translationKey]
    }

    // Find differences in the list of locales and the list of supported locales, add any missing ones to the supported locales list.
    mutating func updateSupportedLocalesIfNeeded(locales: [Locale]) {
        for locale in locales where !supportedLocales.contains(locale) {
            supportedLocales.insert(locale)
        }
    }

    // Generate a key-value mapping for available translations for all the `LocalisedItems` in the given locale.
    func localisedMapping(locale: Locale) -> [String: String] {
        var langaugeSpecificMapping: [String: String] = Dictionary()
        guard let allItems = all() else {
            return langaugeSpecificMapping
        }
        for item in allItems {
            if let translation = item.translation(locale: locale) {
                langaugeSpecificMapping[item.id] = translation
            }
        }
        return langaugeSpecificMapping
    }

    // Generate a key-value pair for mapping of context.
    func contextMapping() -> [String: String]? {
        var contextMapping: [String: String] = Dictionary()
        guard !allLocalisedItems.isEmpty else {
            return nil
        }
        var allValidItemsArray = Array(allLocalisedItems.values)
        allValidItemsArray.sort { $0.id.compare($1.id) == .orderedAscending }
        for item in allValidItemsArray {
            if let context = item.context {
                contextMapping[item.id] = context
            }
        }
        return contextMapping
    }

    init() {
        allLocalisedItems = Dictionary()
        supportedLocales = Set()
        contextAvailable = false
    }
}
