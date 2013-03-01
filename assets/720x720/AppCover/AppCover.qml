import bb.cascades 1.0

Container {
	background: Color.create("#262626")
    layout: AbsoluteLayout {
    }
    layoutProperties: AbsoluteLayoutProperties {

    }
    ImageView {
        horizontalAlignment: HorizontalAlignment.Left
        verticalAlignment: VerticalAlignment.Top
        imageSource: "asset:///images/Cover-title.png"
        minWidth: 334
        maxHeight: 56
        layoutProperties: AbsoluteLayoutProperties {
            positionX: 0
            positionY: 0
        }
    }
    
    Label {
        objectName: "count"
        textStyle.color: Color.create("#00a8df")
        layoutProperties: AbsoluteLayoutProperties {
            positionX: 15
            positionY: 6
        }
    }
    
    Label {
        objectName: "randomTask"
        layoutProperties: AbsoluteLayoutProperties {
            positionX: 15
            positionY: 64
        }
        maxWidth: 289
    }
}
