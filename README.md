# Enforsys UI

This is the draft 1 implementation of the Enforsys User Interface, built using Flutter.

## Overview

Enforsys is designed to provide law enforcement personnel with an intuitive, efficient layout for quick access to critical systems, tools, and notifications. 

## Getting Started

To run this project:
1. Ensure you have Flutter installed.
2. Clone the repository.
3. Run `flutter pub get` to install dependencies.
4. Run `flutter run` to launch the app on your connected device or emulator.

## Features

1. Card-style minimalistic layout
2. Replaced bottom navbar with singular camera button: instantly takes user to CPR module
3. Elderly keyboard: Can be toggled on/off in Settings > My Preference
4. Search bar enquiry: 4 different results i.e. No Parking permit found, Compound Issued, OPN Found, Active User Coupon, Active Season Pass. To test for different result each time, type a different car plate number every time.
5. New Offence: Taking photos and filing in details are now in one screen
6. Confirmation mode toggle in CPR Module's top-right corner.
7. CPR Module: Added validator record button to bottom-right corner for easier access.
8. Able to issue OPN immediately after OPN found.
9. KPI Dashboard "All Staff" View: Added an aggregated dashboard mode that dynamically reorders the layout to prioritize team-wide metrics and Daily Averages.
10. Team Incentive Filtering: The "All Staff" overview includes a real-time Search Bar (by Staff Name or PWID) and a Month dropdown filter, automatically recalculating total team incentives.
11. Incentive Goal Tracking: Users can set target goals (Bronze, Silver, Gold, Platinum) for individual staff, which persists correctly and displays exactly what is needed by payday.
12. Conversion Rate Toggle: Refined the conversion rate card with clear "Show Analysis" and "Show %" toggle buttons.
13. Live Tracker Time Logic: Staff movement statuses (Active, Warning, Critical, Lunch, Off-Duty) are dynamically calculated against the device's real-time clock, including an automatic Lunch status from 12:00 PM to 1:00 PM.
14. Cross-Device UI Stability: Fixed rendering bugs on Wide-Color Gamut displays by ensuring map dots use strict color matching and adding a permanent, color-coded left accent strip to Staff Cards.
15. Map Tracker Enhancements: Replaced the swipe-to-change location filter with a standard dropdown menu and added a clearly styled "Today's Date" header above the map.

## Architecture

The project structure has been refactored for scalability:
- **core**: Contains application themes, colors, and utility files.
- **models**: Standalone data models to prevent circular dependencies.
- **shared**: Reusable UI components like Action Cards, Status Chips, and Section Headers.
- **widgets**: Contains standalone logical widgets like the custom Elderly Keyboard toolset and dialog bottom-sheets.
- **screens**: Screen layouts referencing the shared logic.
