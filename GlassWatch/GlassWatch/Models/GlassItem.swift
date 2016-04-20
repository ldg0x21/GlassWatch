

import UIKit

final class GlassItem: NSObject {
  let title: String
   let date: NSDate
  let link: String
    let subtitle: String
 
    init(title: String, date: NSDate, link: String, subtitle: String ) {
    self.title = title
    self.date = date
    self.link = link
    self.subtitle = subtitle
    }
}

extension GlassItem: NSCoding {
  struct CodingKeys {
    static let Title = "title"
    static let Date = "date"
    static let Link = "link"
    static let Subtitle = "subtitle"
    }

  convenience init?(coder aDecoder: NSCoder) {
    if let title = aDecoder.decodeObjectForKey(CodingKeys.Title) as? String,
        let subtitle = aDecoder.decodeObjectForKey(CodingKeys.Subtitle) as? String,
       let date = aDecoder.decodeObjectForKey(CodingKeys.Date) as? NSDate,
       let link = aDecoder.decodeObjectForKey(CodingKeys.Link) as? String {
        self.init(title: title, date: date, link: link, subtitle: subtitle)
    } else {
      return nil
    }
  }

  func encodeWithCoder(aCoder: NSCoder) {
    aCoder.encodeObject(title, forKey: CodingKeys.Title)
    aCoder.encodeObject(title, forKey: CodingKeys.Subtitle)

    aCoder.encodeObject(date, forKey: CodingKeys.Date)
    aCoder.encodeObject(link, forKey: CodingKeys.Link)
   }
}
