# Next implementation steps

The first deployable milestone is a static site with live weather and a working FAQ chat. To make the marketplace and bookings genuinely multi-user, implement these in order:

1. Add Supabase client setup using your Project URL and anon/public key (never the service-role key).
2. Add sign-up/sign-in/sign-out UI and create `profiles` rows.
3. Load crop listings from `crop_listings`, and insert/update them for signed-in users.
4. Save soil appointment requests to `soil_test_bookings`; add a protected admin workflow for confirming slots.
5. Save chat messages only if you need chat history. For AI answers, call a server-side Edge Function.
6. Test Row Level Security with separate farmer accounts before using real data.
