# Design System Document: The Cinematic Director

## 1. Overview & Creative North Star
This design system is built for the high-stakes environment of cinema management, where efficiency meets the glamour of the silver screen. Our Creative North Star is **"The Red Carpet Editorial."**

We are moving away from the "generic SaaS dashboard" look. Instead of a sea of gray boxes and 1px borders, this system treats data like a high-end film program. We achieve a professional, modern feel through **Tonal Layering** and **Intentional Asymmetry**. By utilizing dramatic shifts in typography scale and unconventional spacing, we create a layout that feels curated, not generated. 

The goal is a "Flat-Plus" aesthetic: strictly no skeuomorphism or heavy gradients, but immense depth achieved through stacked monochromatic surfaces and sharp, decisive crimson accents.

---

## 2. Colors & Surface Philosophy
The palette is rooted in a high-contrast cinematic language: deep charcoal, crisp whites, and a "Director’s Red" that commands immediate attention.

### Color Tokens
- **Primary (The Director’s Red):** `#b1002c` (Base) | `#dc143c` (Container)
- **Neutral (The Film Stock):** `#f6faff` (Background) | `#141d23` (On-Surface)
- **Secondary (The Slate):** `#5d5f5f`

### The "No-Line" Rule
Sectioning must be achieved without 1px solid borders. Boundaries are defined solely through background color shifts. For example, a movie schedule list (using `surface_container_low`) should sit directly on the main dashboard (`surface`), allowing the eye to perceive the change in plane through tone rather than a rigid line.

### Surface Hierarchy & Nesting
Treat the UI as a series of physical layers. Use the following hierarchy to define importance:
1.  **Level 0 (Background):** `surface` (#f6faff) - The base canvas.
2.  **Level 1 (Sections):** `surface_container_low` (#ecf5fe) - For sidebar or secondary content areas.
3.  **Level 2 (Active Cards):** `surface_container_highest` (#dbe4ed) - For primary interactive data cards.
4.  **Level 3 (Floating Modals):** `surface_container_lowest` (#ffffff) - Reserved for the highest level of focus, like ticket confirmation modals.

### Glass & Atmosphere
To soften the "flat" constraint, use **Glassmorphism** for navigation bars or floating action panels. Apply a `surface` color at 80% opacity with a `20px` backdrop-blur. This ensures the vibrant movie posters or data visualizations beneath provide a "visual soul" to the interface.

---

## 3. Typography
We use a dual-font approach to balance editorial flair with technical precision.

*   **Display & Headlines (Manrope):** A sophisticated, wide-set sans-serif that feels authoritative. Use `display-lg` (3.5rem) for theater occupancy percentages or total revenue to make the data feel like a headline.
*   **Body & UI (Inter):** A workhorse typeface for legibility in dense movie schedules and booking tables.

| Role | Font | Size | Weight | Usage |
| :--- | :--- | :--- | :--- | :--- |
| **Display-LG** | Manrope | 3.5rem | 700 | Hero metrics (e.g., Daily Revenue) |
| **Headline-MD** | Manrope | 1.75rem | 600 | Page titles / Movie Titles |
| **Title-SM** | Inter | 1rem | 600 | Card headers / Form labels |
| **Body-MD** | Inter | 0.875rem | 400 | General data / Descriptions |
| **Label-SM** | Inter | 0.6875rem | 700 | Table headers (All Caps) |

---

## 4. Elevation & Depth
In this design system, depth is a result of **Tonal Layering**, not shadows.

*   **The Layering Principle:** To "lift" a component, move it to a lighter surface token. A booking form on `surface_container_low` should use `surface_container_lowest` for the input fields to create a natural inset feel.
*   **Ambient Shadows:** If a floating effect is required (e.g., a movie detail popover), use a "Cinema Shadow": `0 20px 40px rgba(20, 29, 35, 0.06)`. This mimics natural light reflecting off a screen.
*   **The "Ghost Border" Fallback:** For input field focus states, use `outline_variant` at 20% opacity. Never use a 100% opaque black or gray border.

---

## 5. Components

### Buttons (The "Call to Action")
- **Primary:** Background `#b1002c`, Text `#ffffff`. Roundedness `md` (0.375rem). Use uppercase `label-md` for a cinematic feel.
- **Secondary:** Background `secondary_container` (#dfe0e0), Text `on_secondary_container`.
- **Ghost:** No background, `outline` color text. Use for "Cancel" or "Go Back."

### Cards & Lists (The "Film Strips")
- **Forbidden:** No divider lines between list items.
- **Pattern:** Use a `16px` vertical gap and subtle background shifts. For a movie list, the "Active" movie card should be `surface_container_highest`, while "Inactive" ones are `surface`.
- **Corner Radius:** Use `xl` (0.75rem) for large movie posters and `md` (0.375rem) for internal UI elements to create a nested, professional look.

### Input Fields
- **Style:** Minimalist. Use `surface_container_lowest` for the field background. 
- **Focus:** Transition the background to `white` and add a `2px` left-accent bar in `primary` (#b1002c) instead of a full border glow.

### Data Tables (The "Schedule")
- **Header:** `label-sm` in `on_surface_variant`, all caps, with a 2px `primary` underline on the active sort column.
- **Row:** `body-md`. Alternate rows using `surface` and `surface_container_low`.

---

## 6. Do's and Don'ts

### Do:
*   **Use White Space as a Tool:** Give movie titles room to breathe. Use a minimum of `32px` padding on cards.
*   **Respect the Red:** Use `primary` (#b1002c) sparingly—only for buttons, active states, and critical alerts. If everything is red, nothing is important.
*   **Vertical Rhythm:** Ensure all components align to a 4px grid to maintain the "Professional" promise.

### Don't:
*   **Don't Use 1px Borders:** Never use `#6c757d` as a 1px border around a card. Use a background color shift instead.
*   **Don't Use Standard Grays:** Avoid generic `#cccccc`. Use our tinted neutrals like `surface_dim` (#d2dbe4) to keep the UI feeling premium.
*   **Don't Use Skeuomorphism:** No inner shadows, no embossed buttons. The "Director’s Red" provides all the impact needed.