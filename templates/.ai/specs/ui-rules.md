# UI Rules

## 1. UI standard

- simple and readable
- mobile-first but web-focused
- consistent spacing
- clear visual hierarchy
- one primary action per screen when possible

## 2. Allowed patterns

- Tailwind utilities for straightforward styling
- simple component props
- clear empty, loading and error states
- consistent button and form behavior

## 3. Forbidden patterns

- decorative clutter without functional value
- multiple competing primary actions
- inconsistent spacing scales
- hard-to-read text contrast
- surprise interactions without visible cues

## 4. File placement rules

- reusable UI components in `src/lib/components`
- page-specific presentation stays near the route
- do not create parallel component systems

## 5. Test expectations

- verify primary user path manually
- verify obvious empty/error states when touched
- verify layout does not break on common viewport widths

## 6. Done criteria

- screen is understandable without explanation
- primary action is obvious
- spacing and typography are consistent with nearby screens
