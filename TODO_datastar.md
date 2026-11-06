# Datafruits Ember → Rails/Datastar migration plan

Updated 2026-11-04 from the local `/home/tony/src/datafruits` source
and this Rails working tree. This replaces the earlier
POC checklist. Status below is based on source inspection, not browser acceptance testing.

## Scope

Chat development is on hold. Preserve the existing work, but defer chat transport,
rooms, presence, moderation UI, chat preview, and chat-specific interactions. A new
backend in another language is likely; its protocol and implementation are undecided.
The rest of the migration must be able to ship without that decision. Keep shared
authentication, profiles, and playback usable independently of chat.

Keep the existing APIs available while Ember still consumes them. Existing JSON
controllers are reusable backend capabilities, not proof that an HTML page is ported.
Preserve public URLs or add explicit redirects when replacing them.

## Current inventory

| Area | Rails status | Remaining work |
| --- | --- | --- |
| Desktop shell and navigation | ERB layout, navigation, modal component, Datastar imports exist | Mobile nav, persistent player, working profile/signup links, accessibility and assets |
| Authentication | Datastar login/logout responses and CSRF/nav replacement exist | Verify failures/session expiry; signup, password-reset and standalone login pages |
| Homepage `/` | Empty template | Upcoming shows, latest archives, wiki, forum, shrimpos, merch/video; defer chat preview |
| Timetable | ERB day groups, timezone, links and live highlight implemented; Debussy assets copied | Browser/timezone verification and working episode destinations |
| DJs `/djs` | ERB directory and Datastar filtering exist | Profile links, HTML detail page, bio/badges/affinity, archive list and ticket gifts; `show` still returns JSON |
| Shows and episodes | Public routes declared; corresponding HTML controllers/views missing | Series directory/detail, episode detail, playback, labels, hosts, comments and favorites |
| Archives `/podcasts` | ERB published-episode listing, title search, label filters, pagination, RSS links and shared-player controls implemented; Datastar updates preserve audio | Database-backed and browser acceptance checks; artwork, episode/host links and favorites |
| Forum | ERB list/detail, thread creation and streamed replies exist | Parity review, standalone `/forum/new` compatibility, pagination/empty/error states and markdown/emoji rendering |
| Wiki | ERB list/read/create/edit/history and Datastar preview/save exist | Parity review, authorization/errors, history content and rendering |
| About and support | ERB pages exist | Links/assets/translations and responsive acceptance checks |
| Signup and DJ inquiry | Routes declared, matching HTML controllers/views missing | Listener registration/validation and host application forms, success/error states |
| Shrimpos | Routes declared; API functionality exists, HTML implementation missing | List/create/detail, entries/uploads/player, categories/votes/results, comments and embeds |
| User pages | Existing backend APIs; no corresponding ERB user pages | Settings/avatar, favorites, notifications, my shows and studio |
| Other routes | No equivalent Ember-facing views identified | Code of conduct, newsletter, blogs, site settings, admin dashboard, cat/hat, embeds and not-found |

## Proposed implementation order

### 1. Playback and navigation foundation

- [ ] Port the live player: play/stop, loading/error/retry, volume/mute, current
      title/show link, live state, and return-to-live behavior.
- [ ] Add archive playback, pause/resume, seek and elapsed time through the same
      player; prevent competing audio instances.
- [ ] Establish a persistent layout/player and content-region navigation strategy.
      Datastar content updates must leave the audio element intact. Support normal
      direct requests as well as URL/history updates, back/forward, page titles,
      scroll and focus. Prove uninterrupted playback before rolling this out.
- [ ] Port metadata updates independently of chat. Audit Ember's metadata/socket
      dependencies; select a polling or streaming path from existing radio endpoints.
- [ ] Add mobile navigation and replace placeholder account/signup/radio links.
- [ ] Finish theme/locale persistence and server-side locale selection. Treat weather
      effects separately from the settings controls that choose them.
- [ ] Audit referenced fonts/images/icons, restore favicon and relevant metadata,
      give the skip link text and a valid content target.

Acceptance: listen while navigating between Rails pages on desktop/mobile, use
back/forward and direct links, and recover from playback failure without duplicate audio.

### 2. Public listening and discovery

- [ ] Implement `/shows`, `/shows/:slug`, and `/shows/:series/episodes/:slug`, using
      the existing show-series/scheduled-show models and API queries as references.
- [ ] Extract reusable ERB series/episode cards and label/host links.
- [ ] Implement archive search, label filtering and pagination with bookmarkable
      query parameters and Datastar result updates.
- [ ] Implement `/djs/:name` HTML profiles and their published archives; preserve
      username URL behavior, including names containing dots.
- [ ] Populate the homepage with shared cards and existing data queries. Leave the
      chat preview out of this phase; add shrimpo cards when their destinations work.
- [ ] Verify timetable links, local-day grouping and timezone selection, including
      first visits and daylight-saving boundaries.
- [ ] Add public code-of-conduct, DJ-inquiry and newsletter pages; preserve legacy
      `/sign-up` versus `/sign_up` paths when signup is implemented.

Acceptance: browse from homepage or timetable to a show, episode or DJ, search
archives, play a recording, and return to live radio. RSS and existing API consumers
continue working.

### 3. Listener accounts and interactions

- [ ] Complete signup with username/email validation, standalone login and both
      password-reset steps, including URLs used by existing reset emails.
- [ ] Verify login errors, logout, expired sessions and CSRF handling across pages.
- [ ] Port profile settings: avatar upload/progress, username, bio, homepage,
      pronouns, style and timezone.
- [ ] Port track/show favorites and `/user/favorites`, plus notifications and their
      destination links.
- [ ] Generalize the existing forum reply pattern for episode comments, preserving
      model-specific authorization; the current HTML post controller is forum-only.
- [ ] Port non-chat ticket gifting, balances, badges and affinity display where used
      by profile/support flows. Defer chat-triggered rewards and commands.

Acceptance: a listener can register, recover access, edit their profile and interact
with recordings. Invalid forms show useful errors without losing their input.

### 4. DJ workflow

- [ ] Port `/user/my-shows`: list/create/edit series and manage episodes.
- [ ] Cover scheduling/recurrence, timezone and DST behavior, performers, artwork,
      descriptions, labels and episode overrides exposed by the Ember forms.
- [ ] Port recording upload/progress, metadata editing and publishing/removal flows
      that are actually exposed in Ember; reuse existing processing services.
- [ ] Port studio metadata update, donation link and stream settings controls.
- [ ] Enforce ownership/role checks server-side for every mutation.

Acceptance: a DJ can manage a series and episode, upload/publish a recording and use
studio controls without Ember. Validate schedule boundaries and upload failures.

### 5. Community feature completion

- [ ] Finish forum/wiki parity with their existing Rails implementations; reuse
      safe markdown, emoji, preview and form-error patterns across content pages.
- [ ] Port the full shrimpo workflow: creation, rules/deadlines/countdown, entry upload,
      listening, voting categories, voting, results/ending and entry comments.
- [ ] Port public blogs and the Ember admin charts, keeping admin-only access.
- [ ] Port non-chat embed routes (`/container/shows/:id` and shrimpo entry embeds)
      with their minimal layout and playback behavior.

Acceptance: existing content URLs resolve and authorized users can finish the complete
community workflows, including uploads and deadline-sensitive voting.

### 6. Visual features and final parity

- [ ] Inventory and decide the disposition of cat/hat pages, weather, visualizer,
      video visuals, hack button, add-datafruit effects and DJ donation modal.
      These are lower priority, not implicitly dropped from parity.
- [ ] Audit remaining Ember routes/components against this list, including blog
      routes whose declaration exists without a matching local template.
- [ ] Verify locale coverage, responsive layouts, keyboard/focus behavior, metadata,
      missing assets, empty states, 404s and broken internal links.
- [ ] Check production radio/tenant resolution for anonymous visitors and scoped
      queries before cutover.
- [ ] Retire commented Ember markup and unused assets only after replacement or an
      explicit decision to drop the feature.
- [ ] Retire APIs only after Ember and other consumers no longer require them.

## Working conventions

Render pages/partials in ERB; use Datastar for filters, previews, mutations and targeted
updates. Keep browser-owned audio, file upload progress and canvas/video behavior in
small JavaScript modules or web components. Reuse models/services directly rather
than having Rails call its own JSON API.

For each slice: compare the Ember UI and actions, implement the complete user journey,
check permissions and error/empty states, verify in a browser, and add focused tests
for meaningful behavior. Current inventory entries remain provisional until that check.

## Recommended next slice

Start with the live player and persistent navigation proof, then implement show/episode
pages and archive playback. This establishes the listening experience and makes the
existing timetable links useful before expanding the homepage and account features.
