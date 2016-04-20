
import UIKit

class GlassStore: NSObject {
  static let sharedStore = GlassStore()

   var items: [GlassItem] = []

  override init() {
    super.init()
    self.loadItemsFromCache()
  }

  func addItem(newItem: GlassItem) {
     items.insert(newItem, atIndex: 0)
    saveItemsToCache()
  }
}


// MARK: Persistance
extension GlassStore {
  func saveItemsToCache() {
    NSKeyedArchiver.archiveRootObject(items, toFile: itemsCachePath)
  }

  func loadItemsFromCache() {
    if let cachedItems = NSKeyedUnarchiver.unarchiveObjectWithFile(itemsCachePath) as? [GlassItem] {
      items = cachedItems
    }
  }

  var itemsCachePath: String {
    let documentsURL = NSFileManager.defaultManager().URLsForDirectory(.DocumentDirectory, inDomains: .UserDomainMask)[0]
    let fileURL = documentsURL.URLByAppendingPathComponent("glass.dat")
    return fileURL.path!
  }
}
