# ReflexUI

## DON'T INSTALL IF YOU HAVE 0.33.4
the behviour of `require` in Reflex changed and i need to come up with a decent solution for development and dristribution

## installation
- on the right side is download zip button
- extract the content to `<steam>\steamapps\common\Reflex\base\internal\ui` and rename `ReflexUI-master` to `bonus`

## displaying widgets
in reflex open the console and type
```
ui_show_widget <widgetName>
```
to change size arrange and use the following commands
```
ui_set_widget_scale <widget> number
ui_set_widget_anchor <widget> h v
  // h -1=left, 0=center, 1=right
  // v -1=top, 0=middle, 1=bottom
ui_set_widget_offset <widgetName> x y
```

Widgets provided with this installation are

- Acceleration (displays speed changes)
- AllPlayerStats (shows stats of all players while specing)
- ItemArrivals (displays items spawns sorted by resulting stack)
- MiniScores
- ShowKeys
- SpeedMeter (shows your speed)
- TeamInfo (shows the stats of your teammates)
- TrueStack (shows how much damage it takes to kill you)
- WidgetList (shows the complete list of widgets available)
