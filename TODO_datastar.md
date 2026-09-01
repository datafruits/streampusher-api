# Datastar migration TODO

Snapshot taken from the `data-star` branch (commits: `e9b887f7` POC → `1820110a` pc-nav port →
`c2c1ec79` CSS copy → `bce2d768` tailwind/ui-modal → `b7caa17b` login_modal), cross-referenced
against the commented-out Ember/Handlebars markup still sitting in the layout.

## Bugs / inconsistencies (fix before building more on top)

- [ ] **Alpine.js leftover syntax won't run under Datastar** — `@click` / `:class` in
      `app/views/shared/_pc_nav.html.erb:151,193,194` need to become `data-on:click` /
      `data-class:` like the rest of the file.
- [ ] **Modal portal target mismatch** — `_pc_nav.html.erb:223` wraps the `<ui-modal>`s in
      `<div id="modal-portal">`, but `app/javascript/components/ui-modal.js:54` teleports into
      `#modals-container` (defined in `layouts/application.html.erb:146`). The wrapper div does
      nothing.
- [ ] **Dead settings button** — `_pc_nav.html.erb:167` still calls `onclick="openSettingsModal()"`,
      but that function is commented out in `app/javascript/settings.js:31-44`. The other settings
      button (line 69) correctly uses `data-on:click="$settingsModalOpen = !$settingsModalOpen"` —
      make this one match.
- [ ] **Datastar loaded twice** — CDN `<script>` tag in `layouts/application.html.erb:82` *and* a
      vendored copy at `app/javascript/datastar.js`, despite `gem "datastar"` being in the Gemfile.
      Pick one source (probably drop the CDN tag, serve the vendored/gem-managed one via importmap).
- [ ] **Login form likely broken end-to-end** — `_login_modal.html.erb:2` does
      `data-on:submit="@post('/login')"`, but `SessionsController#create` always `render json:` a
      raw Devise payload; it never checks `datastar_request?` or returns SSE/patch-elements, so
      Datastar won't know how to handle the response.

## Core site (biggest gaps)

- [ ] `app/views/landing/index.html.erb` is **completely empty** — this is the homepage the nav
      anchors (`#radio`, `#shows`, `#djs`, `#podcasts`, `#timetable`, etc.) all point into.
- [ ] Port the actual radio player (`DatafruitsPlayer` in the commented-out layout) — not started
      at all.
- [ ] Decide fate of `AudioVisualizer`/`DatafruitsVisuals` (Pixi-based), `HackButton`,
      `AddDatafruit`, `DjDonateModal` — all referenced only as HTML comments in
      `layouts/application.html.erb:96-136`.
- [ ] No mobile nav — `_pc_nav.html.erb` is `hidden md:block` / `hidden md:flex` only; the old
      `SpNav` component has no replacement.

## Nav wiring

- [ ] Anchor links for Chat (`href="#"`, line 21), Radio/Shows/DJs/Podcasts/Timetable/DJ-Inquiry/
      Forum/Wiki/Shrimpos/Support/About are all placeholder `#fragment` hrefs with no target
      content yet.
- [ ] Sign Up button uses `href="#"` (line 208) instead of `users_new_path` (which the login modal
      already uses correctly).
- [ ] User dropdown Profile/Logout (lines 196-201) point to `#profile`/`#logout` placeholders, not
      real routes.

## Settings modal

- [ ] Theme/locale/weather `<select>`s in `_website_settings.html.erb` have **no
      `data-bind`/`data-on:change` at all** — picking an option currently does nothing. Needs to be
      reconnected to `applyTheme()`/localStorage via Datastar signals.
- [ ] Remove the dead, fully-commented-out `openSettingsModal` function in `settings.js`.

## Smaller/cleanup

- [ ] `/coc` and `/support`, linked from `landing/about.html.erb`, have no matching routes/controllers.
- [ ] `layouts/application.html.erb` head: favicon, apple-touch-icon, manifest,
      google-site-verification are all commented out — nothing currently serves a favicon.
- [ ] Skip-to-content link (`application.html.erb:88`) has no text — `{{t "skip_to_content"}}` was
      never converted to `<%= t(...) %>`, so it's an empty link (a11y regression).
- [ ] Strip the remaining commented-out Ember/Handlebars blocks in `application.html.erb` once each
      piece above is ported or explicitly dropped.
- [ ] Once `djs` search/filter (already working via `datastar.patch_elements` in
      `djs_controller.rb`) is confirmed solid, reuse that same pattern for podcasts/shows/forum/wiki
      listing pages.
