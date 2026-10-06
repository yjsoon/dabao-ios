# Dabao

A pretend food delivery app, written in UIKit, for the NP/foodpanda iOS traineeship. "Dabao" is Singlish for takeaway.

We use Dabao as our "existing app": a codebase you didn't write, that you'll learn to find your way around, debug, extend and improve over the course.

## Running it

1. Open `Dabao.xcodeproj` in Xcode 27 (Xcode 26 should work too).
2. Pick an iPhone simulator at the top of the window.
3. Press `Cmd-R`.

There's no server: the restaurants and menus come from `Dabao/Resources/restaurants.json`.

## Finding your way around

| Folder | What's in it |
| --- | --- |
| `Dabao/App` | Start-up code and the tab bar |
| `Dabao/Models` | Plain data: `Restaurant`, `MenuItem`, `CartLine` |
| `Dabao/Services` | Loading restaurants, the shared cart, price formatting |
| `Dabao/Features/RestaurantList` | The first screen. Plain MVC |
| `Dabao/Features/Menu` | A restaurant's menu. Built with **VIPER** |
| `Dabao/Features/Cart` | The cart tab. Plain MVC |
| `Dabao/Features/About` | About screen and the list of contributors |
| `DabaoTests` | Unit tests for the Menu presenter |

## Branches

| Branch | Used on | What it is |
| --- | --- | --- |
| `main` | Day 1 onwards | The app as it is |
| `bug-hunt` | Day 10 | The same app with a few bugs added, plus an `AGENTS.md` that sets up OpenCode as a tutor |
| `viper-exercise` | Day 13 | A Menu bug to fix, and a half-built Restaurant Info module to finish |
| `viper-solution` | Day 13 (afterwards) | One way to finish the VIPER exercise |
| `a11y-solution` | Day 16 (afterwards) | One way to fix the accessibility issues we find in our audit |

## Contributing

On Day 9 you'll fork this repo, add your name to `Dabao/Features/About/Credits.swift`, and open a pull request. See the course notes for the steps.
