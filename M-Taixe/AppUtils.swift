//
//  AppUtils.swift
//  M-Taixe
//
//  Created by M on 12/20/17.
//  Copyright © 2017 kha. All rights reserved.
//

import UIKit

class AppUtils {
    
    class func hexStringToUIColor (hex:String) -> UIColor {
        var cString:String = hex.trimmingCharacters(in: .whitespacesAndNewlines).uppercased()
        
        if (cString.hasPrefix("#")) {
            cString.remove(at: cString.startIndex)
        }
        
        if ((cString.count) != 6) {
            return UIColor.gray
        }
        
        var rgbValue:UInt32 = 0
        Scanner(string: cString).scanHexInt32(&rgbValue)
        
        return UIColor(
            red: CGFloat((rgbValue & 0xFF0000) >> 16) / 255.0,
            green: CGFloat((rgbValue & 0x00FF00) >> 8) / 255.0,
            blue: CGFloat(rgbValue & 0x0000FF) / 255.0,
            alpha: CGFloat(1.0)
        )
    }
    
    class func HTMLEntityDecode(htmlEncodedString: String) -> String {
        guard let data = htmlEncodedString.data(using: .utf8) else {
            return ""
        }
        
        let options: [String: Any] = [
            NSDocumentTypeDocumentAttribute: NSHTMLTextDocumentType,
            NSCharacterEncodingDocumentAttribute: String.Encoding.utf8.rawValue
        ]
        
        guard let attributedString = try? NSAttributedString(data: data, options: options, documentAttributes: nil) else {
            return ""
        }
        
        return attributedString.string
    }
    
    class func addShadowToView(view: UIView, width: CGFloat, height: CGFloat, color: CGColor, opacity: Float, radius: CGFloat) {
        view.layer.masksToBounds = false
        view.layer.shadowOffset = CGSize(width: width, height: height)
        view.layer.shadowColor = color
        view.layer.shadowOpacity = opacity
        view.layer.shadowRadius = radius
    }
    
    class func ConvertStringToCurrency(string: String) -> String {
        let stringReversed = string.reversed()
        var currency = ""
        for (index, char) in stringReversed.enumerated(){
            if (index+1)%3 == 0 && (index+1) != stringReversed.count{
                currency += "\(char)."
            } else {
                currency += "\(char)"
            }
        }
        
        return "\(String(currency.reversed()))đ"
    }
    
    class func scriptSeat() -> String {
        return "<script>" +
        "var imageElement;" +
        "var a = document.getElementById(\"msvg\");" +
        "imageElement = a.getElementById(\"imgCheck\");" +
        "var imgChoose = a.getElementById(\"imgChoose\");" +
        "imageElement.style.display = 'none';" +
        "a.removeChild(imgChoose);" +
        // Get the SVG document inside the Object tag
        "var svgDoc = a.contentDocument;" +
        "var rects = a.getElementsByTagName(\"rect\");" +
        
        "for (var i = 0; i < rects.length; i++) {" +
        "var rect = rects[i];" +
        "if (rect.getAttribute(\"seatno\") != \"\") {" +
        "rect.onclick = seatClick;" +
        "}" +
        "}" +
        "var texts = a.getElementsByTagName(\"text\");" +
        
        "for (var i = 0; i < texts.length; i++) {" +
        "var text = texts[i];" +
        "if (text.getAttribute(\"isseatnumbertxt\") != \"\") {" +
        "text.onclick = textClick;" +
        "}" +
        "}" +
        "var paths = a.getElementsByTagName(\"path\");" +
        
        "for (var i = 0; i < paths.length; i++) {" +
        "var text = paths[i];" +
        "text.onclick = seatClick;" +
        "}" +
        "function seatClick() {" +
        "var seatid = this.getAttribute(\"seatid\");" +
        "var seatno = this.getAttribute(\"seatno\");" +
        " window.location = \"M-Taixe://kha.M-Taixe?\"+seatid+\"?\"+seatno+\"\";" +
            
        //"MyHandler.seatClick(this.getAttribute(\"seatno\")+\" \" +this.getAttribute(\"seatid\"));" +
        "};" +
        "function textClick() {" +
        "var seatid = this.getAttribute(\"seatid\");" +
        "var seatno = this.innerHTML;" +
        " window.location = \"M-Taixe://kha.M-Taixe?\"+seatid+\"?\"+seatno+\"\";" +
        //"MyHandler.seatClick(this.innerHTML+\" \" +this.getAttribute(\"seatid\"));" +
        "};" +
            
        // Get the Object by ID
        "function setSeat(seatId, paid){" +
        "var imgNew = imageElement.cloneNode(true);" +
        "imgNew.style.display = 'block';" +
        "var svgDoc = a.contentDocument;" +
        "var rects = a.getElementsByTagName(\"rect\");" +
        "for(var i=0;i<rects.length; i++){" +
        "var rect = rects[i];" +
        "if(rect.getAttribute(\"seatid\") == seatId){" +
        "rect.setAttribute(\"opacity\", \"0.3\");" +
        "var x = parseInt(rect.getAttribute(\"x\"))+2;" +
            "var y = parseInt(rect.getAttribute(\"y\"))+2;" +
        "imgNew.setAttribute(\"transform\",\"translate(\" +x+\" \" +y+\")\");" +
        "if(paid){" +
        "imgNew.setAttribute(\"xlink:href\",\"http://mobihome.vn/Data/style/site/images/icon/tick.png\");" +
        "}" +
        "a.appendChild(imgNew, rect.nextSibling);" +
        "}" +
        
        "}" +
        "}" +
            
        // Get the Object by ID
        "function myChoose(seatId, paid){" +
        "var imgNew = imgChoose.cloneNode(true);" +
        "imgNew.setAttribute(\"seatid\",seatId);" +
        "imgNew.style.display = 'block';" +
        "var svgDoc = a.contentDocument;" +
        "var rects = a.getElementsByTagName(\"rect\");" +
        "for(var i=0;i<rects.length; i++){" +
        "var rect = rects[i];" +
        "if(rect.getAttribute(\"seatid\") == seatId){" +
        "rect.setAttribute(\"opacity\", \"0.3\");" +
        "var x = parseInt(rect.getAttribute(\"x\"))-97;" +
        "var y = parseInt(rect.getAttribute(\"y\"))-65;" +
        "imgNew.onclick = seatClick;" +
        "imgNew.setAttribute(\"transform\",\"translate(\" +x+\" \" +y+\")\");" +
        "imgNew.setAttribute(\"seatno\",rect.getAttribute(\"seatno\"));" +
        
        "a.appendChild(imgNew, rect.nextSibling);" +
        "}" +
        
        "}" +
        "}" +
        "function chooseSeat(seatId){" +
        "var svgDoc = a.contentDocument;" +
        "var rects = a.getElementsByTagName(\"rect\");" +
        "for(var i=0;i<rects.length; i++){" +
        "var rect = rects[i];" +
        "if(rect.getAttribute(\"seatid\") == seatId){" +
        "rect.setAttribute(\"opacity\", \"0.3\");" +
        
        "}" +
        
        "}" +
        "}" +
            
        "function resetSeat(seatId){" +
        "var svgDoc = a.contentDocument;" +
        "var rects = a.getElementsByTagName(\"rect\");" +
        "for(var i=0;i<rects.length; i++){" +
        "var rect = rects[i];" +
        "if(rect.getAttribute(\"seatid\") == seatId){" +
        "rect.setAttribute(\"opacity\", \"1.0\");" +
        "}" +
        
        "}" +
        "for (var i = 0; i < paths.length; i++) {" +
        "var text = paths[i];" +
        "if(text.getAttribute(\"seatid\")==seatId){" +
        "a.removeChild(text);" +
        "}" +
        "}" +
        "}" +
            
        "function unchoose(seatId){" +
        "var svgDoc = a.contentDocument;" +
        "var rects = a.getElementsByTagName(\"rect\");" +
        "for(var i=0;i<rects.length; i++){" +
        "var rect = rects[i];" +
        "if(rect.getAttribute(\"seatid\") == seatId){" +
        "rect.setAttribute(\"opacity\", \"1.0\");" +
        "}" +
        
        "}" +
        "for (var i = 0; i < paths.length; i++) {" +
        "var text = paths[i];" +
        "if(text.getAttribute(\"seatid\")==seatId){" +
        "a.removeChild(text);" +
        "}" +
        "}" +
        "}" +
            
        "function clearAllTicket(){" +
        "var paths = a.getElementsByTagName(\"path\");" +
        "for(var i=0;i<paths.length;i++){" +
        "a.removeChild(paths[i]);" +
        "}" +
        "var images = a.getElementsByTagName(\"image\");" +
        "for(var i =0;i<images.length;i++){" +
        "a.removeChild(images[i]);" +
        "}" +
        "var rects = a.getElementsByTagName(\"rect\");" +
        "for(var i=0;i<rects.length; i++){" +
        "var rect = rects[i];" +
        "rect.setAttribute(\"opacity\", \"1.0\");" +
        
        "}" +
        "}" +
        "</script>"
    }
}
