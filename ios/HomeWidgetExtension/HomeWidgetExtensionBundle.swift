//
//  HomeWidgetExtensionBundle.swift
//  HomeWidgetExtension
//
//  Created by skybooking on 2/6/23.
//

import WidgetKit
import SwiftUI

@main
struct HomeWidgetExtensionBundle: WidgetBundle {
    var body: some Widget {
        HomeWidgetExtension()
        HomeWidgetExtensionLiveActivity()
    }
}
