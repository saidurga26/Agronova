# Agrononova — deployable website starter

Agrononova is a beginner-friendly static web app based on the original HTML prototype. It includes:
- Responsive farmer crop marketplace with sample crop cards and filters
- Soil-testing appointment request form
- Live current weather and a 3-day forecast using Open-Meteo (no API key required)
- Farmer help chat with preset answers
- Supabase SQL schema for future shared listings, accounts, bookings and chat records

## 1. Run it locally

1. Extract the ZIP.
2. Open `index.html` in a browser, or use VS Code with the **Live Server** extension.
3. To use Live Server: right-click `index.html` → **Open with Live Server**.

The marketplace and soil request form are still browser-only in this starter. They do not yet save to a shared online database. Weather is live when Open-Meteo is reachable. The chat is a simple FAQ helper, not an AI model.

## 2. Publish a public website

### Option A — Netlify (simple)
1. Open https://app.netlify.com/ and sign in.
2. Choose **Add new site** / **Deploy manually**.
3. Drag the extracted `Agrononova` folder (containing `index.html`) into the deploy area.
4. Netlify gives you a public URL.

### Option B — Vercel
1. Put this folder in a GitHub repository.
2. Open https://vercel.com/ and import the repository.
3. Deploy it as a static site. No build command is required; the output directory is the project root.

## 3. Connect Supabase for shared data

1. Create a project at https://supabase.com/.
2. Open **SQL Editor** in your Supabase project.
3. Copy the contents of `supabase-schema.sql`, review it, and run it.
4. The schema creates tables and basic Row Level Security policies for profiles, crop listings, soil bookings and chat messages.

Important: this schema is a starting point, not a complete production security review. Do not collect real farmer contact details until authentication, policies, consent, and booking workflows have been tested. The current `index.html` does not yet call Supabase, so running the SQL alone does not connect the UI. The next development step is to add Supabase sign-in and replace browser-only crop/booking handlers with database calls.

## 4. Weather

The weather panel calls the public Open-Meteo geocoding and forecast APIs from the browser. Forecasts are estimates, and the UI reminds users to follow official local alerts. A location name should be specific enough to find the correct town/district.

## 5. Help chat

The current help chat answers common marketplace questions with preset responses. To make it an AI-powered assistant, create a server-side endpoint (for example, a Supabase Edge Function) and call it from the browser. Store any AI provider key as a server-side secret only—never inside `index.html`.

## 6. Before real launch

- Implement email/phone authentication and account recovery.
- Connect listings and bookings to Supabase.
- Add an admin/lab workflow to confirm or decline soil appointments.
- Integrate an AI chat through a secure server-side function if desired.
- Add consent, privacy policy, terms, abuse reporting, and contact details.
- Test on Android phones, desktop browsers, slow connections, and keyboard/screen-reader navigation.
- Confirm real soil-testing providers and booking availability; the app currently does not contact a laboratory.
