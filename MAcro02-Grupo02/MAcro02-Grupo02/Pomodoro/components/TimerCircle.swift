//
//  TimerCircle.swift
//  MAcro02-Grupo02
//
//  Created by Felipe Porto on 04/10/24.
//

import Foundation
import UIKit
import QuartzCore

class TimerCircle: UIView {
    
    private var progressLayer = CAShapeLayer()
    private var tracklayer = CAShapeLayer()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.configureProgressViewToBeCircular()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.configureProgressViewToBeCircular()
    }
    
    var ProgressColor: UIColor = UIColor.black
    var TrackColor: UIColor = UIColor.lightGray
    var progress: Float = 0 {
            didSet {
                
                animateProgress(to: progress)
            }
        }
    
    private var viewCGPath: CGPath? {
        return UIBezierPath(arcCenter: CGPoint(x: frame.size.width / 2.0, y: frame.size.height / 2.0),
                            radius: 150,
                            startAngle: CGFloat(-0.5 * Double.pi),
                            endAngle: CGFloat(1.5 * Double.pi), clockwise: true).cgPath
    }
    
    
    private func configureProgressViewToBeCircular() {
        self.drawsView(using: tracklayer, startingPoint: 15.0, ending: 1.0, color: TrackColor.cgColor)
        self.drawsView(using: progressLayer, startingPoint: 15.0, ending: CGFloat(progress), color: ProgressColor.cgColor)
    }
    
    private func drawsView(using shape: CAShapeLayer, startingPoint: CGFloat, ending: CGFloat, color: CGColor) {
        self.backgroundColor = UIColor.clear
        self.layer.cornerRadius = self.frame.size.width/2.0
        
        shape.path = self.viewCGPath
        shape.fillColor = UIColor.clear.cgColor
        shape.strokeColor = color
        shape.lineCap = .round
        shape.lineWidth = 30
        shape.strokeEnd = ending
        
        self.layer.addSublayer(shape)
    }
    
    private func animateProgress(to progress: Float) {
        
        if progress == 0 {
            self.progressLayer.strokeEnd = CGFloat(progress)
        } else {
            let animation = CABasicAnimation(keyPath: "strokeEnd")
            animation.fromValue = self.progressLayer.strokeEnd
            animation.toValue = progress
            animation.duration = 0.1
            animation.timingFunction = CAMediaTimingFunction(name: .easeInEaseOut)
            self.progressLayer.strokeEnd = CGFloat(progress)
            self.progressLayer.add(animation, forKey: "animateProgress")
        }
    }
}
