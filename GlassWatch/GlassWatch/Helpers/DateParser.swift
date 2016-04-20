

import UIKit

class DateParser: NSObject {
  static let dateFormatter = NSDateFormatter()

  //Wed, 04 Nov 2015 21:00:14 +0000
  static func dateWithPodcastDateString(dateString: String) -> NSDate? {
    dateFormatter.dateFormat = "EEE, dd, MMM yyyy HH:mm:ss Z"
    return dateFormatter.dateFromString(dateString)
  }

  static func displayString(fordate date: NSDate) -> String {
    dateFormatter.dateFormat = "HH:mm MMMM dd, yyyy"
    return dateFormatter.stringFromDate(date)
  }
}

