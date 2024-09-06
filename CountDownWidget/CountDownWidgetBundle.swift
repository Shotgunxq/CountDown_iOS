//
//  CountDownWidgetBundle.swift
//  CountDownWidget
//
//  Created by Bence Bodnár on 06/09/2024.
//

import WidgetKit
import SwiftUI

@main
struct CountDownWidgetBundle: WidgetBundle {
    var body: some Widget {
        CountDownWidget()
        CountDownWidgetLiveActivity()
    }
}
