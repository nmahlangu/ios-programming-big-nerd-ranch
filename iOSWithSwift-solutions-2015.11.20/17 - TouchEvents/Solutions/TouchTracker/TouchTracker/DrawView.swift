//
//  Copyright © 2015 Big Nerd Ranch
//

import UIKit

class DrawView: UIView {
    
    var currentLines = [NSValue:Line]()
    var finishedLines = [Line]()

    @IBInspectable var finishedLineColor: UIColor = UIColor.blackColor() {
        didSet {
            setNeedsDisplay()
        }
    }

    @IBInspectable var currentLineColor: UIColor = UIColor.redColor() {
        didSet {
            setNeedsDisplay()
        }
    }

    @IBInspectable var lineThickness: CGFloat = 10 {
        didSet {
            setNeedsDisplay()
        }
    }
 
    func strokeLine(line: Line) {
        let path = UIBezierPath()
        path.lineWidth = lineThickness
        path.lineCapStyle = CGLineCap.Round
        
        path.moveToPoint(line.begin)
        path.addLineToPoint(line.end)
        path.stroke()
    }

    override func drawRect(rect: CGRect) {
        // Draw finished lines in black
        finishedLineColor.setStroke()
        for line in finishedLines {
            strokeLine(line)
        }
        
        // Draw current lines in red
        currentLineColor.setStroke()
        for (_, line) in currentLines {
            strokeLine(line)
        }
    }
    
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        // Let's put in a log statement to see the order of events
        print(__FUNCTION__)
        
        for touch in touches {
            let location = touch.locationInView(self)
            
            let newLine = Line(begin: location, end: location)
            
            let key = NSValue(nonretainedObject: touch)
            currentLines[key] = newLine
        }
        
        setNeedsDisplay()
    }
    
    override func touchesMoved(touches: Set<UITouch>, withEvent event: UIEvent?) {
        // Let's put in a print statement to see the order of events
        print(__FUNCTION__)
        
        for touch in touches {
            let key = NSValue(nonretainedObject: touch)
            currentLines[key]?.end = touch.locationInView(self)
        }
        
        setNeedsDisplay()
    }
    
    override func touchesEnded(touches: Set<UITouch>, withEvent event: UIEvent?) {
        // Let's put in a log statement to see the order of events
        print(__FUNCTION__)
        
        for touch in touches {
            let key = NSValue(nonretainedObject: touch)
            if var line = currentLines[key] {
                line.end = touch.locationInView(self)
                
                finishedLines.append(line)
                currentLines.removeValueForKey(key)
            }
        }
        
        setNeedsDisplay()
    }
    
    override func touchesCancelled(touches: Set<UITouch>?, withEvent event: UIEvent?) {
        
        // Let's put in a log statement to see the order of events
        print(__FUNCTION__)
        
        currentLines.removeAll()
        
        setNeedsDisplay()
    }
    
}
