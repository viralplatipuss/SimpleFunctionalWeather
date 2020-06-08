# SimpleFunctionalWeather

This is a really simple app that can fetch the weather for a given zip code.
It is built using the [SimpleFunctional library](https://github.com/viralplatipuss/SimpleFunctional/).

A user enters a zip code, and presses fetch. They will see the weather, or an error message. The app will then wait 3 seconds before re-enabling the fetch button (mainly to demo another IO).

There are 3 IO types/handlers:

**ViewIO** - A highly specific IO type for updating the weather app UI. Ideally, this could be more generic, so there is less impure code and the project is more platform agnostic. But generically wrapping a useful amount of SwiftUI or UIKit is a big task.

**HTTPIO** - A simple IO for fetching data over HTTP.

**TimerIO** - An IO for setting timers with a given delay.


## Demo

![Alt Text](https://github.com/viralplatipuss/SimpleFunctionalWeather/blob/master/WeatherApp.gif)
