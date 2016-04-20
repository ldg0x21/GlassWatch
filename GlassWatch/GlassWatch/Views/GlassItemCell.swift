
import UIKit

class GlassItemCell: UITableViewCell {
  func updateWithGlassItem(item:GlassItem) {
    self.textLabel?.text = item.title
    
    //self.detailTextLabel?.text = "BLAH"
    self.detailTextLabel?.text = DateParser.displayString(fordate:item.date)
  }
}
