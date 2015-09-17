# Dependencies
require 'main.scss'
m = require 'moment'
mz = require 'moment-timezone'
gui = require 'nw.gui'


tray = new gui.Tray title: 'times'

win = gui.Window.get()

win.on 'close', (event) ->
  if event is 'quit'
    win.close(true)
  else
    win.hide()

gui.App.on 'reopen', ->
  win.show()

mb = new gui.Menu type: 'menubar'
mb.createMacBuiltin('times')
gui.Window.get().menu = mb

window.onbeforeunload = () -> tray.remove()

activeZones = []

setInterval(() ->
  setTaskLabel()
  injectZoneDiv()

, 1000)

generateMenuItems = () ->
  menu = new gui.Menu()
  timezones = m.tz.names()

  for i in timezones
    menu.append new gui.MenuItem({ type: 'checkbox', label: i})

  if menu.items.length is 0
    menu.append {type: 'label', label: 'No Timezones Available.'}

  return menu

injectZoneDiv = () ->
  zoneList = document.getElementById('zones')

  zoneList.innerHTML = activeZones.map((t) -> "<li>" + t.label + "&nbsp;<a href='\#' onclick='moveUp(\"#{t.label}\")'>Up</a>&nbsp;<a href='\#' onclick='moveDown(\"#{t.label}\")'>Down</a></li>").join('')

setTaskLabel = () ->
  format = 'hh:mm:ss z'

  times = []

  if tray.menu?.items.length isnt 0
    checkedZones = tray.menu.items?.filter((d) ->
      return d.checked
    )

    if activeZones.length > 0
      activeZones = activeZones.concat(checkedZones.filter((i) -> activeZones.indexOf(i) < 0))
    else
      activeZones = checkedZones.slice(0)


    for i in activeZones
      times.push m().tz(i.label).format(format)

  tray.title = if times.length <= 0 then 'times' else times.join(' ')


window.moveUp = (label) ->
  activeZones.splice(activeZones.map((z) -> z.label).indexOf(label) - 1,0,activeZones.splice(activeZones.map((z) -> z.label).indexOf(label),1)[0])
  setTaskLabel()

window.moveDown = (label) ->
  activeZones.splice(activeZones.map((z) -> z.label).indexOf(label) + 1,0,activeZones.splice(activeZones.map((z) -> z.label).indexOf(label),1)[0])
  setTaskLabel()

tray.menu = generateMenuItems()
