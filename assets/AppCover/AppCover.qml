import bb.cascades 1.0

Container {
    layout: AbsoluteLayout {
    }
    ImageView {
        horizontalAlignment: HorizontalAlignment.Left
        verticalAlignment: VerticalAlignment.Top
        imageSource: "asset:///images/Cover-title.png"
        minWidth: 334
        layoutProperties: AbsoluteLayoutProperties {
            positionX: 0
            positionY: 0
        }
    }
    
    Label {
        objectName: "count"
        textStyle.color: Color.create("#fafafa")
        textStyle.fontSize: FontSize.Small
        layoutProperties: AbsoluteLayoutProperties {
            positionX: 15
            positionY: 10
        }
    }
    
    Label {
        objectName: "randomTask"
        textStyle.fontSize: FontSize.Small
        layoutProperties: AbsoluteLayoutProperties {
            positionX: 15
            positionY: 64
        }
        maxWidth: 289
    }
}
