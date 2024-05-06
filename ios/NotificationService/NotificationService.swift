import UserNotifications

class NotificationService: UNNotificationServiceExtension {
    var contentHandler: ((UNNotificationContent) -> Void)?
    var bestAttemptContent: UNMutableNotificationContent?

    override func didReceive(_ request: UNNotificationRequest, withContentHandler contentHandler: @escaping (UNNotificationContent) -> Void) {
        self.contentHandler = contentHandler
        bestAttemptContent = (request.content.mutableCopy() as? UNMutableNotificationContent)

        guard let bestAttemptContent = bestAttemptContent else {
            return
        }

        if let imageURLString = bestAttemptContent.userInfo["image_url"] as? String,
           let imageURL = URL(string: imageURLString) {
            downloadImage(from: imageURL) { [weak self] image in
                if let image = image {
                    if let attachment = self?.createImageAttachment(image: image, identifier: "imageAttachment") {
                        bestAttemptContent.attachments = [attachment]
                    }
                    self?.contentHandler?(bestAttemptContent)
                } else {
                    self?.contentHandler?(bestAttemptContent)
                }
            }
        } else {
            contentHandler(bestAttemptContent)
        }
    }
    
    func downloadImage(from url: URL, completion: @escaping (UIImage?) -> Void) {
        URLSession.shared.dataTask(with: url) { (data, response, error) in
            guard let data = data, error == nil else {
                completion(nil)
                return
            }
            let image = UIImage(data: data)
            completion(image)
        }.resume()
    }
    
    func createImageAttachment(image: UIImage, identifier: String) -> UNNotificationAttachment? {
        if let imageData = image.pngData() {
            let tempDirectory = URL(fileURLWithPath: NSTemporaryDirectory())
            let imageFileIdentifier = identifier+".png"
            let fileURL = tempDirectory.appendingPathComponent(imageFileIdentifier)
            do {
                try imageData.write(to: fileURL)
                let imageAttachment = try UNNotificationAttachment(identifier: identifier, url: fileURL, options: nil)
                return imageAttachment
            } catch {
                return nil
            }
        }
        return nil
    }
    
    override func serviceExtensionTimeWillExpire() {
        if let contentHandler = contentHandler, let bestAttemptContent = bestAttemptContent {
            contentHandler(bestAttemptContent)
        }
    }
}
