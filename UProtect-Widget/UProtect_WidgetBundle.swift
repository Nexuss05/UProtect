//
//  UProtect_WidgetBundle.swift
//  UProtect-Widget
//
//  Created by Matteo Cotena on 21/05/24.
//

import WidgetKit
import SwiftUI

@main
struct UProtect_WidgetBundle: WidgetBundle {
    var body: some Widget {
        UProtect_Widget()
        UProtect_WidgetLiveActivity()
    }
}
