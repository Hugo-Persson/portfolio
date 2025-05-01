---
name: Prototyping
date: 2025-04-15
---

The first step in any project for me involves prototyping to see what works and getting a rough idea of the scope of the project. If I can put together some minimimal code that demonstrates the core functionality, I can then decide if I want to pursue the project further.

My main aspiration with this project was to create a TUI based based task manager that would integrate with Apple Reminders. For this I needed two main things to work:

1. Creating a TUI interface
2. Interacting with Apple Reminders

The first point was pretty straight forward. There exist many libraries for this but I decided to use [Ratatui]() which is a rust based framework to create TUIs. I have quite a bit of experience with Rust and I wanted to use it for this project. The second point was a bit more challenging. I had never interacted with Apple Reminders before and I wasn't sure how to do it.

### Attempt 1: AppleScript

My initial approach was to use AppleScript to interact with Apple Reminders. I had never used AppleScript before but I was able to get ChatGPT to create a simple script like this:

```applescript
ObjC.import('stdlib');

function run() {
    const Reminders = Application('Reminders');
    const lists = Reminders.lists();
    const names = lists.map(list => list.name());
    return names;
}
```

Then I found the library [osascript](https://docs.rs/osascript/latest/osascript/) that allows you to execute OSAScript from Rust. I was able to get this working and I could get a list of all the reminders lists. However, I quickly ran into issues with speed. This script could take multiple minutes to run to just fetch a few reminders. This is because you’re making a separate Apple Event call to the Reminders app for every single property on every single reminder.

If you’re mapping over 100 reminders and getting just 3 fields, that’s already 300+ IPC calls, and each one takes time.

### Attempt 2: objc2_event_kit

After the problem with speed I decided to instead try to use [EventKit](https://developer.apple.com/documentation/eventkit), I found the library [objc2_event_kit](https://docs.rs/objc2-event-kit/latest/objc2_event_kit/). This seemed like the exact thing I needed and I tried implementing it. However, I quickly ran into issues with the library. It was not well documented and I was not able to get it to work. I spent a few hours trying to get it to work but I was not able to make any progress. I decided to move on and try to interop between Swift and Rust.

### Final working attempt: swift-rs

After this I finally found the way forward to make it work for me

