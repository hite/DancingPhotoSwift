//
//  ModelController.swift
//  DancingPhotoSwift
//
//  Created by liang on 2018/7/20.
//  Copyright © 2018 liang. All rights reserved.
//

import UIKit

/*
 A controller object that manages a simple model -- a collection of month names.
 
 The controller serves as the data source for the page view controller; it therefore implements pageViewController:viewControllerBeforeViewController: and pageViewController:viewControllerAfterViewController:.
 It also implements a custom method, viewControllerAtIndex: which is useful in the implementation of the data source methods, and in the initial configuration of the application.
 
 There is no need to actually create view controllers for each page in advance -- indeed doing so incurs unnecessary overhead. Given the data model, these methods create, configure, and return a new view controller on demand.
 */


class ModelController: NSObject, UIPageViewControllerDataSource {

    var pageData: [DPPageType] = []
    
    private var _welcomeController: DPWelcomeViewController?;
    private var _frameController: DPLayoutFrameController?;
    private var _VFLController: DPLayoutVFLViewController?;
    private var _anchorController: DPLayoutAnchorViewController?;
    private var _snapKitController: DPLayoutSnapKitController?;
    private var _layoutController: DPLayoutKitViewController?;

    override init() {
        super.init()
        // Create the data model.
        pageData = [.welcome, DPPageType.frame, DPPageType.VFL, .anchor, .layoutkit, .snapkit]
    }

    func viewControllerAtIndex(_ index: Int) -> DPLayoutPageController? {
        // Return the data view controller for the given index.
        if (self.pageData.count == 0) || (index >= self.pageData.count) {
            return nil
        }

        // Create a new view controller and pass suitable data.
        let type: DPPageType = self.pageData[index]
        var vc: DPLayoutPageController;
        if (type == .welcome){
            if _welcomeController == nil{
                _welcomeController = DPWelcomeViewController(pageType: type)
            }
            vc = _welcomeController!;
        } else if(type == .frame){
            if _frameController == nil{
                _frameController = DPLayoutFrameController(pageType: type)
            }
            vc = _frameController!
        } else if(type == .VFL){
            if _VFLController == nil{
                _VFLController = DPLayoutVFLViewController(pageType: type)
            }
            vc = _VFLController!
        } else if(type == .anchor){
            if _anchorController == nil{
                _anchorController = DPLayoutAnchorViewController(pageType: type)
            }
            vc = _anchorController!
        } else if(type == .snapkit){
            if _snapKitController == nil{
                _snapKitController = DPLayoutSnapKitController(pageType: type)
            }
            vc = _snapKitController!
        } else if(type == .layoutkit){
            if _layoutController == nil{
                _layoutController = DPLayoutKitViewController(pageType: type)
            }
            vc = _layoutController!
        } else {
            vc = DPWelcomeViewController(pageType: type);
        }
 
        return vc;
    }

    func indexOfViewController(_ viewController: DPLayoutPageController) -> Int {
        // Return the index of the given data view controller.
        // For simplicity, this implementation uses a static array of model objects and the view controller stores the model object; you can therefore use the model object to identify the index.
        return pageData.index(of: viewController.pageType) ?? NSNotFound
    }

    // MARK: - Page View Controller Data Source

    func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController? {
        var index = self.indexOfViewController(viewController as! DPLayoutPageController)
        if (index == 0) || (index == NSNotFound) {
            return nil
        }
        
        index -= 1
        return self.viewControllerAtIndex(index)
    }

    func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController? {
        var index = self.indexOfViewController(viewController as! DPLayoutPageController)
        if index == NSNotFound {
            return nil
        }
        
        index += 1
        if index == self.pageData.count {
            return nil
        }
        return self.viewControllerAtIndex(index)
    }

}

