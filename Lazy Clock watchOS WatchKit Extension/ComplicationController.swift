//
//  ComplicationController.swift
//  Lazy Clock watchOS WatchKit Extension
//
//  Created by Hundter Biede on 9/29/19.
//  Copyright © 2019 Hundter Biede. All rights reserved.
//

import ClockKit


class ComplicationController: NSObject, CLKComplicationDataSource {
    
    func getCLKComplicationTemplate(for complicationFamily: CLKComplicationFamily, withTextHandler: CLKTextProvider) -> CLKComplicationTemplate {
        let formatter: DateFormatter = {
            let temp = DateFormatter()
            temp.dateFormat = "HH:mm:ss"
            return temp
        }()
        var nlt = NaturalLanguageTime.NatTime()
        nlt.timeString = formatter.string(from: Date())
        
        let imageProvider = CLKImageProvider(onePieceImage: UIImage(named: "complication")!)
        
        let template
        switch complicationFamily {
        case .graphicBezel:
            template = CLKComplicationTemplateGraphicBezelCircularText()
            template.textProvider = textProvider
            
            let circularTemplate = CLKComplicationTemplateGraphicCircularImage()
            circularTemplate.imageProvider = imageProvider
            template.circularTemplate = circularTemplate
            break;
        case .extraLarge:
            template = CLKComplicationTemplateExtraLargeSimpleText()
            template.textProvider = textProvider
            break;
        case .modularLarge:
            template = CLKComplicationTemplateModularLargeStandardBody()
            template.bodyTextProvider = textProvider
            break;
        case .utilitarianLarge:
            template = CLKComplicationTemplateUtilitarianLargeFlat()
            template.textProvider = textProvider
            break;
        default:
            return nil
        }
        template.tintColor = .some(UIColor(red: 0.639, green: 0.157, blue: 0.133, alpha: 1.0))
        
        return template
    }
    
    // MARK: - Timeline Configuration
    
    func getSupportedTimeTravelDirections(for complication: CLKComplication, withHandler handler: @escaping (CLKComplicationTimeTravelDirections) -> Void) {
        handler([.forward, .backward])
    }
    
    func getTimelineStartDate(for complication: CLKComplication, withHandler handler: @escaping (Date?) -> Void) {
        handler(nil)
    }
    
    func getTimelineEndDate(for complication: CLKComplication, withHandler handler: @escaping (Date?) -> Void) {
        handler(nil)
    }
    
    func getPrivacyBehavior(for complication: CLKComplication, withHandler handler: @escaping (CLKComplicationPrivacyBehavior) -> Void) {
        handler(.showOnLockScreen)
    }
    
    // MARK: - Timeline Population
    
    func getCurrentTimelineEntry(for complication: CLKComplication, withHandler handler: @escaping (CLKComplicationTimelineEntry?) -> Void) {
        let textProvider = CLKTextProvider(format: "%@", arguments: nlt.getNatLangString())
        let template = getCLKComplicationTemplate(for: complication.family, withTextHandler: textProvider)
        handler(template == nil ? nil : CLKComplicationTimelineEntry(date: Date(), complicationTemplate: template))
    }
    
    func getTimelineEntries(for complication: CLKComplication, before date: Date, limit: Int, withHandler handler: @escaping ([CLKComplicationTimelineEntry]?) -> Void) {
        // Call the handler with the timeline entries prior to the given date
        handler(nil)
    }
    
    func getTimelineEntries(for complication: CLKComplication, after date: Date, limit: Int, withHandler handler: @escaping ([CLKComplicationTimelineEntry]?) -> Void) {
        // Call the handler with the timeline entries after to the given date
        handler(nil)
    }
    
    // MARK: - Placeholder Templates
    
    func getLocalizableSampleTemplate(for complication: CLKComplication, withHandler handler: @escaping (CLKComplicationTemplate?) -> Void) {
        textProvider = CLKTextProvider(format: "%@", arguments: String.localizedWithFormat(NSLocalizedString("Half past %@", comment: "Half past the hour")), "three")
        let template = getCLKComplicationTemplate(for: complication.family, withTextHandler: textProvider)
        handler(template == nil ? nil : CLKComplicationTimelineEntry(date: Date(), complicationTemplate: template))
    }
    
}
