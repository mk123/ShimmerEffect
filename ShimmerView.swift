import UIKit

public class ShimmerView: UIView {
    
    private var startLocations : [NSNumber] = [-1.0,-0.5, 0.0]
    private var endLocations : [NSNumber] = [1.0,1.5, 2.0]
    
    private var gradientBackgroundColor : CGColor = UIColor(white: 0.85, alpha: 1.0).cgColor
    private var gradientMovingColor : CGColor = UIColor(white: 0.75, alpha: 1.0).cgColor
    
    private var movingAnimationDuration : CFTimeInterval = 0.8
    private var delayBetweenAnimationLoops : CFTimeInterval = 1.0
    
    private var maskingViews: [UIView] = []
    
    
    private var gradientLayer : CAGradientLayer!

    override public func draw(_ rect: CGRect) {
        super.draw(rect)
        
        let gradientLayer = CAGradientLayer()
        gradientLayer.frame = self.bounds
        gradientLayer.startPoint = CGPoint(x: 0.0, y: 1.0)
        gradientLayer.endPoint = CGPoint(x: 1.0, y: 1.0)
        gradientLayer.colors = [
            gradientBackgroundColor,
            gradientMovingColor,
            gradientBackgroundColor
        ]
        gradientLayer.locations = self.startLocations
        self.gradientLayer = gradientLayer
    }
   
    
    
    public func startAnimating(){
        self.layer.addSublayer(gradientLayer)
        let animation = CABasicAnimation(keyPath: "locations")
        animation.fromValue = self.startLocations
        animation.toValue = self.endLocations
        animation.duration = self.movingAnimationDuration
        animation.timingFunction = CAMediaTimingFunction(name: CAMediaTimingFunctionName.easeInEaseOut)
        
        
        let animationGroup = CAAnimationGroup()
        animationGroup.duration = self.movingAnimationDuration + self.delayBetweenAnimationLoops
        animationGroup.animations = [animation]
        animationGroup.repeatCount = .infinity
        self.gradientLayer.add(animationGroup, forKey: animation.keyPath)
    }
    
    public func stopAnimating() {
        self.gradientLayer.removeAllAnimations()
        self.gradientLayer.removeFromSuperlayer()
        self.layer.mask = nil
    }
    
    public func populateMaskingViewsList(){
        // Add child views with tag value greater than 0 to maskingViews array
        var viewsList: Array<UIView> = []
        viewsList.append(self)
         while let viewNode = viewsList.first {
             viewsList.remove(at: 0)
             for element in viewNode.subviews {
                if element.tag > 0 {
                     maskingViews.append(element)
                 }else {
                     viewsList.append(element)
                 }
             }
         }
     }
    
    public func setMaskingViews() {
        self.setMaskingViews(maskingViews)
    }
    
    public func clearMaskingViewsList() {
        maskingViews = []
    }
    
}
