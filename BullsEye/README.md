# Bull's Eye

UIKit Apprentice (Kodeco) — Chapters 1–8 completed.

A landscape slider game: drag the bull’s-eye as close as you can to a random target from 1–100, tap **Hit Me!**, and score points based on accuracy.

## What’s implemented (Ch. 1–8)

- Hit Me! alert with score and closeness title (`Perfect!`, `You almost had it!`, `Pretty good!`, `Not even close...`)
- Bonus points for a perfect hit (+100) and being off by 1 (+50)
- Running score and round counter
- **Start Over** resets score and round, with a fade transition
- Custom artwork (background, buttons, slider thumb/track)
- About screen (`!` / info button) with a `WKWebView` loaded from `BullsEye.html`
- Auto Layout / different screen sizes, app icon, display name

## Open and run

1. On a Mac, open `BullsEye.xcodeproj` in Xcode.
2. Choose an iPhone simulator (landscape works best).
3. Press **Run** (⌘R).

## Screen-recording script (assignment)

Record the Simulator while you:

1. Drag the slider, tap **Hit Me!**, and show the popup of how close you were and how many points you scored.
2. Tap **OK**, play another round if you want, then tap **Start Over** and show that **Score** goes back to `0` and **Round** goes back to `1`.
3. Tap the **!** (info) button and show the About page with game information, then close it.

QuickTime on macOS: **File → New Screen Recording**, select the Simulator window.

## Push to GitHub

```bash
cd BullsEye
git init
git add .
git commit -m "Complete Bull's Eye through UIKit Apprentice chapter 8"
gh repo create BullsEye --public --source=. --remote=origin --push
```

Or create an empty repo on github.com, then:

```bash
git remote add origin https://github.com/YOUR_USERNAME/BullsEye.git
git branch -M main
git push -u origin main
```

Submit that repository URL for deliverable 2.

## Project layout

```
BullsEye/
├── BullsEye.xcodeproj
└── BullsEye/
    ├── ViewController.swift       # game logic
    ├── AboutViewController.swift  # About screen + WKWebView
    ├── BullsEye.html              # About page content
    ├── Main.storyboard            # UI + segues
    ├── Assets.xcassets            # artwork and app icon
    ├── AppDelegate.swift
    └── SceneDelegate.swift
```
