
import UIKit
import SafariServices
import Foundation
import UIKit
import MessageUI


weak var nameTextField: UITextField!

class GlassFeedTableViewController: UITableViewController,MFMailComposeViewControllerDelegate {
    // MARK: Properties
  static let RefreshGlassFeedNotification = "RefreshGlassFeedNotification"
  let pollStore = GlassStore.sharedStore
    
  @IBOutlet weak var subject: UITextField!
    
  override func viewDidLoad() {
    super.viewDidLoad()
    tableView.rowHeight = UITableViewAutomaticDimension
    tableView.estimatedRowHeight = 75

    if let patternImage = UIImage(named: "pattern-grey") {
      let backgroundView = UIView()
      backgroundView.backgroundColor = UIColor(patternImage: patternImage)
      tableView.backgroundView = backgroundView
    }
    

    NSNotificationCenter.defaultCenter().addObserver(self, selector: "receivedRefreshGlassFeedNotification:", name: GlassFeedTableViewController.RefreshGlassFeedNotification, object: nil)
  }

  deinit {
    NSNotificationCenter.defaultCenter().removeObserver(self)
  }

  func receivedRefreshGlassFeedNotification(notification: NSNotification) {
    dispatch_async(dispatch_get_main_queue()) {
      self.tableView.reloadSections(NSIndexSet(index: 0), withRowAnimation: .Automatic)
    }
  }
}

// MARK: - UITableViewDataSource, UITableViewDelegate
extension GlassFeedTableViewController {
  override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    print ("Number of items:", pollStore.items.count)
    return pollStore.items.count
  }
   
    override func tableView(tableView: UITableView, editActionsForRowAtIndexPath indexPath: NSIndexPath) -> [UITableViewRowAction]? {
        let delete = UITableViewRowAction(style: .Destructive, title: "Delete") { (action, indexPath) in
            // delete item at indexPath
            print("Delete the item:", (NSindexPath: indexPath.row))
            
            //Remove the item from the view if delete specified
             tableView.beginUpdates()
             let glassStore = GlassStore.sharedStore
            
            //Save the new data

             glassStore.items.removeAtIndex(indexPath.row)
            glassStore.saveItemsToCache()
            
            //Update the tableView
            tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Fade)
            
            
            
            //End of update
            
            tableView.endUpdates()
        }
        
        let share = UITableViewRowAction(style: .Normal, title: "Share") { (action, indexPath) in
            // share item at indexPath
            print ("user hit share button")
            
            let  mailComposeViewController = self.configuredMailComposeViewController()
            if MFMailComposeViewController.canSendMail() {
                self.presentViewController(mailComposeViewController, animated: true, completion: nil)
            } else {
                self.showSendMailErrorAlert()
            }
        }
        
        print("Slide the entry")
        share.backgroundColor = UIColor.blueColor()
        
        return [delete, share]
    }
    
    
    
    
    
    
  override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
    let cell = tableView.dequeueReusableCellWithIdentifier("GlassItemCell", forIndexPath: indexPath) as! GlassItemCell
    cell.updateWithGlassItem(pollStore.items[indexPath.row])
    return cell
  }

  override func tableView(tableView: UITableView, shouldHighlightRowAtIndexPath indexPath: NSIndexPath) -> Bool {
    let item = pollStore.items[indexPath.row]
    
    
    //get a file from the the server link
    if let url = NSURL(string: item.link) where url.scheme == "file" {
       // let url = NSURL(string:"http://104.45.140.246:9900/test.txt")!
        let url1 = NSURL(string:"http://10.0.1.5:9900/test.txt")!

        let request = NSURLRequest(URL: url1)
        NSURLConnection.sendAsynchronousRequest(request, queue: NSOperationQueue.currentQueue()!) { (response, data, error) -> Void in
            if error != nil {
                print(error!)
            } else {
                if let textFile = NSString(data: data!, encoding: NSUTF8StringEncoding) {
                    print("-------- The Text File --------------")
                    print(textFile)
                }
            }
        }
        return true
    }
    
    if let url = NSURL(string: item.link) where url.scheme == "http" {
        // let url = NSURL(string:"http://104.45.140.246:9900/test.txt")!
        //let url = NSURL(string:"http://10.0.1.5:9900/test.txt")!
        
        let request = NSURLRequest(URL: url)
        NSURLConnection.sendAsynchronousRequest(request, queue: NSOperationQueue.currentQueue()!) { (response, data, error) -> Void in
            if error != nil {
                print(error!)
            } else {
                if let textFile = NSString(data: data!, encoding: NSUTF8StringEncoding) {
                    print("-------- The Text File --------------")
                    print(textFile)
                }
            }
        }

        return true
    }
    if let url = NSURL(string: item.link) where url.scheme == "https" {
        //let url = NSURL(string:"http://10.0.1.5:9900/test.txt")!
        print ("Connect to port:", url.port)
        let request = NSURLRequest(URL: url)
        NSURLConnection.sendAsynchronousRequest(request, queue: NSOperationQueue.currentQueue()!) { (response, data, error) -> Void in
            if error != nil {
                print(error!)
            } else {
                if let textFile = NSString(data: data!, encoding: NSUTF8StringEncoding) {
                    print("-------- The Text File --------------")
                    print(textFile)
                }
            }
        }

      return true
    }
    return false
  }

  override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
    let item = pollStore.items[indexPath.row]

    if let url = NSURL(string: item.link) {
      let safari = SFSafariViewController(URL: url)
      presentViewController(safari, animated: true, completion: nil)
        print("User selected:", indexPath)
        
       var selectedCell:UITableViewCell = tableView.cellForRowAtIndexPath(indexPath)!
       selectedCell.contentView.backgroundColor = UIColor.greenColor()
        selectedCell.backgroundColor = UIColor.grayColor()
        
        
    }
  }
    
    //override func tableView(tableView: UITableView, willDisplayCell cell: UITableViewCell, forRowAtIndexPath indexPath: NSIndexPath)
    //{
    //    cell.contentView.backgroundColor = UIColor.yellowColor()
    //}

    override func tableView(tableView: UITableView, willDisplayCell cell: UITableViewCell, forRowAtIndexPath indexPath: NSIndexPath) {
        cell.backgroundColor = UIColor.clearColor()
    }
    
    //override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
    //    var selectedCell:UITableViewCell = tableView.cellForRowAtIndexPath(indexPath)!
    //    selectedCell.contentView.backgroundColor = UIColor.redColor()
    //}
    

    
    func configuredMailComposeViewController() -> MFMailComposeViewController {
        let mailComposerVC = MFMailComposeViewController()
        mailComposerVC.mailComposeDelegate = self // Extremely important to set the --mailComposeDelegate-- property, NOT the --delegate-- property
        
        mailComposerVC.setToRecipients([])
        mailComposerVC.setSubject("Forward GlassWatch Push Notify!")
        var mailBody = ""
        let msg = "----- I got the following -----"
        mailBody += msg
        mailBody += "---Add the notify push msg details here !----"
        mailComposerVC.setMessageBody(mailBody, isHTML: false)
        
        return mailComposerVC
    }
    
    
    
    func showSendMailErrorAlert() {
        let sendMailErrorAlert = UIAlertView(title: "Could Not Send Email", message: "Your device could not send e-mail.  Please check e-mail configuration and try again.", delegate: self, cancelButtonTitle: "OK")
        sendMailErrorAlert.show()
    }
    
    // MARK: MFMailComposeViewControllerDelegate
    
    func mailComposeController(controller: MFMailComposeViewController!, didFinishWithResult result: MFMailComposeResult, error: NSError!) {
        controller.dismissViewControllerAnimated(true, completion: nil)
        
    }
    
}
