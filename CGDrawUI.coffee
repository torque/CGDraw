`#target illustrator`
`#targetengine main`

win = new Window "palette", "CGDraw" , undefined, {}

win.outputBox = win.add "edittext", [0, 0, 280, 80], "", {multiline: true}
win.outputBox.text = "Results go here."

win.outputType = win.add "dropdownlist", [0, 0, 280, 20], ["CoreGraphics"]
win.outputType.selection = 0

win.wrap = win.add """
Group {orientation: 'row',
  closure: RadioButton { text: 'closure', value: true },
  bare:    RadioButton { text: 'bare' },
}
"""
win.lang = win.add """
Group {orientation: 'row',
  objc:  RadioButton { text: 'obj-c' },
  swift: RadioButton { text: 'swift', value: true },
}
"""
win.os = win.add """
Group {orientation: 'row',
  iOS: RadioButton { text: 'iOS' },
  Mac: RadioButton { text: 'Mac', value: true },
}
"""
win.goButton = win.add "button", undefined, "Generate"

radioString = ( radioGroup ) ->
  for child in radioGroup.children
    if child.value
      return child.text

win.goButton.onClick = ->
  win.outputBox.active = false
  bt = new BridgeTalk
  bt.target = "illustrator"
  bt.body = """
    (#{CGDraw.toString( )})({\
      type:"#{win.outputType.selection.text}",\
      wrap:"#{radioString win.wrap}",\
      lang:"#{radioString win.lang}",\
      os:"#{radioString win.os}",\
      ctx:"context",\
      bnd:"bounds"});
  """

  bt.onResult = ( result ) ->
    win.outputBox.text = result.body.replace( /\\\\/g, "\\" ).replace( /\\n/g, "\n" ).replace( /\\t/g, "\t" )
    win.outputBox.active = true

  bt.onError = ( err ) ->
    alert "#{err.body} (#{a.headers["Error-Code"]})"

  bt.send( )

win.show( )
