//
//  UIAlertController+Extensions.swift
//  Soundscape
//
//  Copyright (c) Microsoft Corporation.
//  Licensed under the MIT License.
//

import Foundation

enum MailClient: String, CaseIterable {

    // Feedback destination email address
    public static let supportEmail = "support@scottishtecharmy.org"

    // Supported Mail Clients
    // These applications must also be defined in 'Queried URL Schemes' in Info.plist

    case systemMail
    case gmail
    case outlook
    case yahooMail
    
    var localizedTitle: String {
        switch self {
        case .systemMail: return GDLocalizedString("mail.default")
        case .gmail: return GDLocalizedString("mail.gmail")
        case .outlook: return GDLocalizedString("mail.msoutlook")
        case .yahooMail: return GDLocalizedString("mail.yahoo")
        }
    }
    
    func url(email: String, subject: String) -> URL? {
        let deviceInfo = "iOS \(UIDevice.current.systemVersion), \(UIDevice.current.modelName), \(LocalizationContext.currentAppLocale.identifierHyphened), v\(AppContext.appVersion).\(AppContext.appBuild)"
        let escapedSubject = "\(subject) (\(deviceInfo))".addingPercentEncoding(withAllowedCharacters: NSCharacterSet.urlQueryAllowed) ?? GDLocalizedString("settings.feedback.subject")

        switch self {
        case .systemMail: return URL(string: "mailto:\(email)?subject=\(escapedSubject)")
        case .gmail: return URL(string: "googlegmail:///co?to=\(email)&subject=\(escapedSubject)")
        case .outlook: return URL(string: "ms-outlook://compose?to=\(email)&subject=\(escapedSubject)")
        case .yahooMail: return  URL(string: "ymail://mail/compose?to=\(email)&subject=\(escapedSubject)")
        }
    }
}

extension UIAlertController {
    /// Create and return a `UIAlertController` that is able to send an email with external email clients
    convenience init(email: String, subject: String, preferredStyle: UIAlertController.Style, handler: ((MailClient?) -> Void)? = nil) {

        // Create alert actions from mail clients
        let actions = MailClient.allCases.compactMap { (client) -> UIAlertAction? in
            guard let url = client.url(email: email, subject: subject) else { return nil }
            return UIAlertAction(title: client.localizedTitle, url: url) {
                handler?(client)
            }
        }
        
        if actions.isEmpty {
            self.init(title: GDLocalizedString("general.error.error_occurred"),
                      message: GDLocalizedString("settings.feedback.no_mail_client_error"),
                      preferredStyle: .alert)
        } else {
            self.init(title: GDLocalizedString("settings.feedback.choose_email_app"),
                      message: nil,
                      preferredStyle: preferredStyle)
            
            actions.forEach({ action in
                self.addAction(action)
            })
        }
        
        self.addAction(UIAlertAction(title: GDLocalizedString("general.alert.cancel"), style: .cancel, handler: nil))
    }
}
