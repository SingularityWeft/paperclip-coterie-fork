# Coterie Local Patches

This fork exists to keep MoselMinds/Coterie-specific Paperclip changes reviewable while staying close to upstream.

## Repositories

- Fork: `https://github.com/SingularityWeft/paperclip-coterie-fork`
- Upstream: `https://github.com/paperclipai/paperclip`
- Upstream default branch: `master`

## Branch Discipline

- Keep `master` aligned with `upstream/master`.
- Put every local change on a small `coterie/*` branch.
- Prefer upstreamable fixes over Coterie-specific UI behavior.
- Do not commit generated bundles, local database files, secrets, or one-off deployment artifacts.
- Treat `/Users/aiuser/agents/paperclip` as a deployment target, not as the source of truth for patches.

## Active Patches

### `coterie/fix-org-chart-mobile-layout`

- File: `ui/src/pages/OrgChart.tsx`
- Problem: the org chart can appear blank in a narrow embedded browser pane when the chart viewport is temporarily zero-height or too small during first render.
- Fix: give the chart viewport a mobile minimum height, and fit the chart after the container reports real dimensions through `ResizeObserver`.
- Expected user-facing behavior: `/MMO/org` and `/CUS/org` should show the hierarchy in both the Codex in-app browser pane and a full browser window.

## Maintenance Routine

Weekly:

1. Fetch `origin` and `upstream`.
2. Confirm fork `master` has no drift from `upstream/master`.
3. Check each `coterie/*` branch for upstream drift and likely conflicts.
4. Rebase only the branch being actively maintained.
5. Run focused checks for the touched package before deploying to the local Paperclip runtime.

Use `scripts/coterie-maintenance-check.sh` for the read-only status check.
