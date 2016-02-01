//
//  ModelController.swift
//  T4E1
//
//  Created by Jorge Marquez Torres on 15/1/16.
//  Copyright © 2016 jmarquez. All rights reserved.
//

import UIKit

/*
 A controller object that manages a simple model -- a collection of month names.
 
 The controller serves as the data source for the page view controller; it therefore implements pageViewController:viewControllerBeforeViewController: and pageViewController:viewControllerAfterViewController:.
 It also implements a custom method, viewControllerAtIndex: which is useful in the implementation of the data source methods, and in the initial configuration of the application.
 
 There is no need to actually create view controllers for each page in advance -- indeed doing so incurs unnecessary overhead. Given the data model, these methods create, configure, and return a new view controller on demand.
 */


class ModelController: NSObject, UIPageViewControllerDataSource {

    var pageData = NSArray()


    override init() {
        super.init()
        // Create the data model.
        pageData = ["1","2","3","4"]
        //let dateFormatter = NSDateFormatter()
        //pageData = dateFormatter.monthSymbols
    }
    
    func viewControllerAtIndex(index: Int, storyboard: UIStoryboard) -> DataViewController? {
        if (self.pageData.count == 0 || (index >= self.pageData.count)){
            return nil
        }
        let viewControllerId: NSString = "DataViewController\(index+1)"
        let dataViewController = storyboard.instantiateViewControllerWithIdentifier(viewControllerId as String) as! DataViewController
        dataViewController.dataObject = self.pageData.objectAtIndex(index) as! String
        
        return dataViewController
    }

    func indexOfViewController(viewController: DataViewController) -> Int {
        // Return the index of the given data view controller.
        // For simplicity, this implementation uses a static array of model objects and the view controller stores the model object; you can therefore use the model object to identify the index.
        
        return pageData.indexOfObject(viewController.restorationIdentifier!.stringByReplacingOccurrencesOfString("DataViewController", withString: "")) ?? NSNotFound
    }

    // MARK: - Page View Controller Data Source

    func pageViewController(pageViewController: UIPageViewController, viewControllerBeforeViewController viewController: UIViewController) -> UIViewController? {
        var index = self.indexOfViewController(viewController as! DataViewController)
        if (index == 0) || (index == NSNotFound) {
            return nil
        }
        
        index--
        return self.viewControllerAtIndex(index, storyboard: viewController.storyboard!)
    }

    func pageViewController(pageViewController: UIPageViewController, viewControllerAfterViewController viewController: UIViewController) -> UIViewController? {
        var index = self.indexOfViewController(viewController as! DataViewController)
        if index == NSNotFound {
            return nil
        }
        
        index++
        if index == self.pageData.count {
            return nil
        }
        return self.viewControllerAtIndex(index, storyboard: viewController.storyboard!)
    }
    
    func pageViewController(pageViewController: UIPageViewController,
        spineLocationForInterfaceOrientation orientation:
        UIInterfaceOrientation) -> UIPageViewControllerSpineLocation {
            // Set the spine position to "min" and the page view controller's
            //view controllers array to contain just one view controller. Setting
            //the spine position to 'UIPageViewControllerSpineLocationMid' in
            //landscape orientation sets the doubleSided property to true, so set it
            //to false here.
            if(UIInterfaceOrientationIsLandscape(orientation)){
                
                let currentViewController =
                pageViewController.viewControllers![0] as! DataViewController
                var viewControllers:NSArray = [currentViewController]
                let indexOfCurrentViewController =
                self.indexOfViewController(currentViewController)
                if(indexOfCurrentViewController == 0 ||
                    indexOfCurrentViewController % 2 == 0 ) {
                        let nextViewController:UIViewController =
                        self.pageViewController(pageViewController,
                            viewControllerAfterViewController: currentViewController)!
                        viewControllers =
                            [currentViewController,nextViewController]
                }
                else{
                    let previousViewController:UIViewController =
                    self.pageViewController(pageViewController,
                        viewControllerBeforeViewController: currentViewController)!
                    viewControllers =
                        [previousViewController,currentViewController]
                }
                pageViewController.setViewControllers(viewControllers as? [UIViewController],
                    direction: UIPageViewControllerNavigationDirection.Forward, animated:
                    true, completion: nil)
                return UIPageViewControllerSpineLocation.Mid
            }
            else{
                let currentViewController =
                pageViewController.viewControllers![0] as UIViewController
                let viewControllers: NSArray = [currentViewController]
                pageViewController.setViewControllers(viewControllers as? [UIViewController],
                    direction: .Forward, animated: true, completion: {done in })
                
                pageViewController.doubleSided = false
                return UIPageViewControllerSpineLocation.Min
            }
    }

}

