# Copyright (c) 2015 torque. See LICENSE for details.

`#target illustrator`
`#targetengine main`

win = new Window "palette", "CGDraw" , undefined, {}

win.outputBox = win.add "edittext", [0, 0, 280, 80], "", {multiline: true}
win.outputBox.text = "Results go here."

win.outputType = win.add "dropdownlist", [0, 0, 280, 20], ["CoreGraphics", "SVG"]
win.outputType.selection = 0

win.typeUI = win.add "Group { orientation: 'column' }"

win.outSize = win.add """
Group { orientation: 'row',
	widthLabel: StaticText { text: 'Width:' },
	width: EditText { text: '', preferredSize: [70, 20] },
	heightLabel: StaticText { text: 'Height:' },
	height: EditText { text: '', preferredSize: [70, 20] }
}
"""

options = {
	show: {
		CoreGraphics: ->
			win.wrap = win.typeUI.add """
			Group {orientation: 'row',
				closure: RadioButton { text: 'closure', value: true },
				bare:    RadioButton { text: 'bare' },
			}
			"""
			win.lang = win.typeUI.add """
			Group {orientation: 'row',
				objc:  RadioButton { text: 'obj-c' },
				swift: RadioButton { text: 'swift', value: true },
			}
			"""
			win.os = win.typeUI.add """
			Group {orientation: 'row',
				iOS: RadioButton { text: 'iOS' },
				Mac: RadioButton { text: 'Mac', value: true },
			}
			"""
			win.variables = win.typeUI.add """
			Group { orientation: 'row',
				ctxLabel: StaticText { text: 'Context:' },
				ctx: EditText { text: 'context', preferredSize: [70, 20] },
				bndLabel: StaticText { text: 'Bounds:' },
				bnd: EditText { text: 'bounds', preferredSize: [70, 20] }
			}
			"""
		SVG: -> # nothing to show.
	}
	hide: {
		CoreGraphics: ->
			win.typeUI.remove win.wrap
			win.typeUI.remove win.lang
			win.typeUI.remove win.os
			win.typeUI.remove win.variables
		SVG: ->
	}
	last: undefined
}

drawOpts = ->
	incoming = win.outputType.selection.text
	options.hide[options.last]?( )
	options.show[incoming]?( )
	options.last = incoming
	win.layout.resize( )
	win.layout.layout yes

win.outputType.onChange = drawOpts

drawOpts( )

win.goButton = win.add "button", undefined, "Generate"

win.layout.layout yes

radioString = ( radioGroup ) ->
	for child in radioGroup.children
		if child.value
			return child.text

win.goButton.onClick = ->
	win.outputBox.active = false
	bt = new BridgeTalk
	bt.target = "illustrator"

	switch win.outputType.selection.text
		when 'CoreGraphics'
			bt.body = """
				(#{CGDraw.toString( )})({\
					type:"#{win.outputType.selection.text}",\
					wrap:"#{radioString win.wrap}",\
					lang:"#{radioString win.lang}",\
					os:"#{radioString win.os}",\
					ctx:"#{win.variables.ctx.text}",\
					bnd:"#{win.variables.bnd.text}",\
					width:"#{win.outSize.width.text}",\
					height:"#{win.outSize.height.text}"});
			"""

		when 'SVG'
			bt.body = """
				(#{CGDraw.toString( )})({\
					type:"#{win.outputType.selection.text}",\
					width:"#{win.outSize.width.text}",\
					height:"#{win.outSize.height.text}"});
			"""

	bt.onResult = ( result ) ->
		win.outputBox.text = result.body.replace( /\\\\/g, "\\" ).replace( /\\n/g, "\n" ).replace( /\\t/g, "\t" )
		win.outputBox.active = true

	bt.onError = ( err ) ->
		alert "#{err.body} (#{a.headers["Error-Code"]})"

	bt.send( )

win.show( )
