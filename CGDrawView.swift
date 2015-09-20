// Copyright (c) 2015 torque. See LICENSE for details.

import Cocoa
import CoreGraphics

typealias SSQVDrawBlock = ( CGContextRef, CGRect ) -> ( )

class SSQuartzView: NSView {

    var drawBlock: SSQVDrawBlock = { context, bounds in }

    init( frame: CGRect, drawBlock: SSQVDrawBlock) {
        super.init( frame: frame )
        self.drawBlock = drawBlock
    }

    required init?( coder: NSCoder ) {
        super.init( coder: coder )
    }

    override func drawRect( dirtyRect: NSRect ) {
        super.drawRect( dirtyRect )

        let myContext = NSGraphicsContext.currentContext()!.CGContext
        self.drawBlock( myContext, self.frame )
    }

}
