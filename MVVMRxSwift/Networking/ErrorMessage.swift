import SwiftMessages

final class ErrorMessage {
    static func showErrorHud(with message: String) {
        if message.isEmpty {
            SwiftMessages.hide()
        } else {
            let errorMessageView = MessageView.viewFromNib(layout: .statusLine)
            errorMessageView.backgroundView.backgroundColor = .red
            errorMessageView.bodyLabel?.textColor = .white
            var config = SwiftMessages.Config()
            config.presentationContext = .window(windowLevel: UIWindow.Level.normal)
            config.preferredStatusBarStyle = .lightContent
            config.duration = .forever
            errorMessageView.configureContent(body: message)
            SwiftMessages.show(config: config, view: errorMessageView)
        }
    }
}
