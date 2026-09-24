import { action, actions } from "datastar"

const csrfToken = () =>
  document.querySelector('meta[name="csrf-token"]')?.getAttribute("content")

for (const method of ["post", "put", "patch", "delete"]) {
  const original = actions[method]
  action({
    name: method,
    apply: (ctx, url, options = {}) =>
      original(ctx, url, {
        ...options,
        headers: { ...options.headers, "X-CSRF-Token": csrfToken() },
      }),
  })
}
