# Steal an Egg → Steal a Package: visible gameplay reference

Study date: 2 October 2026. Source: the live Roblox Player session of [Steal an Egg](https://www.roblox.com/games/107778070777162/Steal-An-Egg), including a user-driven walkthrough. This is a design reference, not a reconstruction specification.

Only ordinary player-facing gameplay and menus were inspected. No scripts, private files, hidden developer data, asset extraction, or internal balancing tables were accessed. Screenshots document what was actually visible; interpretation and original proposals are labeled separately.

## Evidence and limits

The account began with approximately 4.9M displayed Speed, billions of cash, owned trails, existing eggs, and developed plots. This was an advanced-account study. It cannot establish a new player's first-session timings, purchase affordability, tutorial sequence, or fresh-profile access restrictions. Cash increased while the player traveled, consistent with the income labels on displayed pets. Individual cash changes are not controlled purchase experiments.

Automation could capture the game but could not reliably inject gameplay controls. The user drove the walkthrough. Some captures were occluded by another application or failed during window changes; these are excluded from the curated evidence. Capture gaps must not be treated as observed events. Original screenshot filenames sometimes describe an intended action rather than the actual view; the curated gallery captions are authoritative.

Confidence language: **confirmed** means visible in a screenshot or captured sequence; **partial** means the visible UI suggests a rule but the rule was not fully tested; **unverified** means it was not seen sufficiently to describe as fact. Design principles explain plausible benefits, not measured retention effects.

## 1. Spawn, hub, shops, and home navigation

**OBSERVED**

The hub opens directly onto the first stage. A red line spans the travel corridor; large SAFE ZONE floor lettering and shield symbols make the boundary readable from several camera angles. The Sell stall sits on one side of the entrance, and Trails Shop, a green machine, a free chest, and a money-per-second leaderboard sit near the other side. Plots lie beyond this shared hub area. A home icon points toward the player's plot. The exact first spawn position and fresh-player onboarding were not observed.

**USEFUL PRINCIPLE**

A return trip naturally passes services, other players, and home navigation. The hub becomes a place to recover and choose the next action without another navigation task. Text, color, floor markings, and icons reinforce the same boundary.

**STEAL A PACKAGE ADAPTATION**

Build a delivery depot with an unmistakable dispatch finish line and a short path to personal plots. Place training and practical upgrades along that return path. Use original parcel signage, architecture, and a different arrangement of buildings. Preserve sightlines toward Starter Street and the player's home marker. Do not reproduce the reference's stall arrangement or red-line artwork.

## 2. Plots, spacing, capacity, and social display

**OBSERVED**

Fences outline individual plots. Treadmills and an Upgrade Pen sign sit near the front. Owner portraits/home markers distinguish ownership. Developed plots contain very large collectibles with rarity/name/income labels and repeated floating cash gains. Some models and effects extend well beyond their fences and obscure neighboring plots, services, and the camera. A capacity sign shows the current level, next level, and cash cost. The exact capacity per level, maximum capacity, and inventory-versus-display rule were not established.

**USEFUL PRINCIPLE**

A personal display turns progression into a visible possession. Neighbors provide aspirational examples. Capacity gives cash a practical use once valuable collectibles accumulate. However, unlimited model scale and overlapping labels undermine navigation.

**STEAL A PACKAGE ADAPTATION**

Use parcel shelving and bounded display pads. Keep a clear front walkway between the training belt, capacity sign, and deposit point. Show occupied/available slots and the next upgrade benefit explicitly. Bound collectible scale and effect radius so a full plot remains readable. Keep the current capacity foundation; do not add an opening system merely to match the reference.

## 3. Route, stage shape, and transitions

**OBSERVED**

Captured early and middle stages use broad rectangular spaces between parallel high walls. The central route is mostly clear. Color changes, small edge decorations, thin transverse floor bands, and a region-name/emoji banner signal transitions. Forest, Lake, Desert, Jungle, and Snow names appeared visibly. A lava-themed area follows Snow; an ocean-themed area follows that. A bone-decorated yellow area is visible beyond the ocean. Later-stage names and complete geometry require additional evidence.

Green zones use bushes, reeds, ponds, or trees at the sides; Desert uses sand, cactus shapes, and stepped forms; Snow uses a white floor and blue ice shapes; the lava area uses dark surfaces, orange molten strips, and fire; the ocean area uses blue surfaces, sand patches, coral shapes, bubbles, and bones. Palette changes carry much of the spatial identity. No interaction with a gate was needed on the captured advanced-account route. This does not prove all fresh accounts have identical access.

**USEFUL PRINCIPLE**

The player learns one navigation pattern and recognizes new difficulty through landmarks and atmosphere. Low obstacle density gives a chase room to read clearly. Seeing the next region encourages a deeper attempt.

**STEAL A PACKAGE ADAPTATION**

Keep the existing Plot → Starter Street → Neighborhood → Rich Street → Mansion → Facility sequence. Make each destination recognizable through an original parcel-related landmark and street character. Vary setbacks, widths, and small bends without hiding the route home. Use neighborhood gateways and delivery markings instead of copying identical biome rectangles or studded corridor walls. Place optional scenery outside the pursuit lane.

## 4. Guardian and loot placement

**OBSERVED**

Guardians and eggs sit together near a side wall, leaving the travel lane open. Their side alternates across captured regions: Jungle's group is on the left when traveling deeper; Snow's is on the right; the lava group's is on the left; the ocean group's is on the right. Idle guardians display a blue Z marker. Eggs vary in visible size and appearance. Several groups show more than three physical eggs; a clear Snow view shows five visible nests after earlier interaction, and other views show roughly six. Counts can change after theft/reset or be hidden by overlap. The evidence does **not** support claiming exactly three eggs everywhere.

**USEFUL PRINCIPLE**

Loot placed beside an obvious guardian communicates a deliberate risk choice. A clear center lane lets players scout deeper without automatically committing to a theft. Small loot clusters concentrate the decision instead of scattering search tasks across the stage.

**STEAL A PACKAGE ADAPTATION**

Retain our deliberately simpler three visible package spots and one guardian per stage. Use separate loading pallets or doorstep drops so all three are easy to compare. Give each guardian a readable idle position, wake signal, and return location. Alternate or vary placement for our own street layout; do not duplicate the reference's coordinates, spacing, creatures, nests, or stage dimensions.

## 5. Stealing, pursuit, caught feedback, and safety

**OBSERVED**

Approaching loot reveals an E interaction with a circular hold indicator. Taking an ocean egg changes the guardian from a sleeping Z to a red exclamation mark; it moves toward the carrier. The interface switches to a large red RUN!! banner and Drop button, with a reddish edge treatment. Much of the ordinary HUD disappears during the chase. The carried egg is physically visible and can cover the avatar.

A Jungle theft produces the same chase interface. Its tiger-like guardian follows through Desert, Lake, and Forest toward the hub. Other guardians remain at their own loot groups in the captured sequence. An ocean attempt is followed by the avatar lying on the ground and the normal HUD returning; this is consistent with a caught/knockdown outcome, but the exact contact moment and egg-loss transaction were not captured. The exact safe-line crossing and guardian turn-back need a continuous capture; later normal HUD/inventory views alone cannot prove the termination trigger.

An egg selected near the plot produces “Get closer to your area to place an egg!” This establishes that possession and placement at one's own area are separate player-facing steps. A ready egg on a developed plot offers E Hatch.

**USEFUL PRINCIPLE**

A sudden interface change gives theft an immediate emotional beat. A visible pursuer and known retreat route convert an abstract stat check into a readable escape. Separating safety from home placement gives the return trip a final ownership ritual.

**STEAL A PACKAGE ADAPTATION**

Make our guardian activate only for its own stolen package. Keep the tested hub finish-line rule and guardian exclusion from plots. Show a compact carrying/chase state, the return direction, and clear “Escaped” or “Caught—package lost” feedback. Keep one carried package. Avoid oversized carried objects and preserve enough navigation UI during danger. Our current finish-line test cash remains the graybox reward; future deposit/unboxing should be specified separately.

## 6. Difficulty and reward distribution

**OBSERVED**

Speed recommendation signs appear beside loot groups. Early Forest shows a much lower recommendation than the later Snow and lava signs. Idle Snow, lava, and ocean guardians look more imposing than the earliest one. Guardian wake/pursuit was seen, but speeds were not measured under controlled conditions. The account could traverse many regions quickly; this is not evidence of beginner difficulty.

The index shows multiple rarities inside an individual stage pool rather than a single rarity per stage. Global announcements name exceptionally rare eggs and their destination regions. Exact spawn probabilities, guaranteed slots, income distributions, and the claim that every stage has the full rarity range are not recoverable from these screenshots.

**USEFUL PRINCIPLE**

Recommended strength communicates risk while preserving exploration. A range of outcomes in each area can keep earlier areas interesting. Rare public announcements give players a reason to change plans.

**STEAL A PACKAGE ADAPTATION**

Preserve our unrestricted stages, complete per-stage shipping rarity pools, and stronger later guardians. Use our own odds and reward bands. Explain difficulty with guardian threat and recommended training, not a hard entry gate. A rare dispatch announcement should identify a destination without covering the chase view. Validate that later stages improve average reward while early areas still permit a memorable lucky find.

## 7. Treadmill training and upgrades

**OBSERVED**

Physical treadmills sit at plot fronts. Training runs automatically while the player is on the treadmill; holding movement keys is not required, as clarified by the user during the walkthrough. The [user-supplied treadmill screenshot](screenshots/48-user-treadmill-automatic-training.png) shows the avatar on the belt, repeated +1K Speed feedback, and a nearby Level 7 → Level 8 upgrade sign offering cash or Robux. The still image documents the feedback and upgrade presentation; automatic activation is supported by the user's gameplay clarification.

Earlier views show an ice-colored treadmill labeled +100/step and another developed plot's fire-themed treadmill with a larger per-step label. An upgrade shop compares current and next devices side by side, with cash and premium-currency purchase paths. The captured advanced account sees an Ice Treadmill and a rainbow-styled next device. These are account-relative examples, not recommended balance. The exact gain interval, modifier calculation, and entry/exit trigger boundaries remain unverified.

**USEFUL PRINCIPLE**

Training becomes a recognizable station in the world with automatic gain while occupied. This removes sustained input effort and creates a quiet preparation phase between theft attempts. A new machine is both a functional gain and a visible milestone. Showing current and next output can make an upgrade easier to evaluate than an unexplained level number.

**STEAL A PACKAGE ADAPTATION**

Use a physical courier-training belt that awards training automatically while the player occupies its training position, with clear entry/exit and rate upgrades. A running animation can communicate the activity without requiring held movement input. Make the player-facing stat “Training points/sec” and show the change before purchase. Theme temporary devices as courier practice equipment. Tune travel improvement in modest steps so movement remains controllable; avoid copying treadmill art, device names, upgrade costs, or speed magnitudes. This is an updated design recommendation; the existing package build's movement-input requirement has not been changed by this reference correction.

## 8. Trails and multiplier communication

**OBSERVED**

The Trail Shop uses horizontally arranged cards with a preview, rarity label, multiplier, and action. Owned trails show Equip/Unequip. One captured view shows Red Trail at x4 Speed, Galaxy Trail at x5 Speed with Unequip, and Secret Trail at x7 Speed with cash and premium prices. A purple trail appears behind the player. The wording alone does not establish whether the multiplier changes training gain, movement speed, or another speed-related calculation. An equip/unequip controlled comparison was not performed.

**USEFUL PRINCIPLE**

An equipable visible item combines a progression choice with a social signal. A single active item reduces equipment-management complexity. Ambiguous stat wording risks confusing the player about what they purchased.

**STEAL A PACKAGE ADAPTATION**

Keep temporary parcel-themed trails as multipliers to treadmill training gain only. Label them “Training gain ×…” and show the effective training rate. Equip/unequip must not abruptly change current movement speed. Use independent names, previews, modest multipliers, prices, and UI composition.

## 9. Collection index and completion rewards

**OBSERVED**

Forest and Lake index panels show eight collectible cards in two rows of four. Desert also shows an eight-card panel. Forest reads 3/8 with total collection progress 29/104 on the studied account. Known cards show names, rarity, and income; undiscovered entries use question marks and silhouettes. Card backgrounds differentiate tiers. A reward strip shows cash, Speed, and claimed state. A bat-shaped reward/progress graphic appears beside the stage section. Forest still reads 3/8 while displayed cash/Speed rewards are claimed, so it would be wrong to assume those rewards require full stage completion. The bat threshold and weapon behavior are unverified.

Eight visible possibilities in three sampled pools and a total of 104 are **not** proof that every pool has eight entries or that the map has exactly thirteen stages. The entire catalog was not enumerated.

**USEFUL PRINCIPLE**

Missing silhouettes create understandable goals. Per-stage and overall progress give both small and long-term targets. Claimed-state feedback prevents repeated reward guessing. A functional milestone reward can make completion matter beyond an icon count.

**STEAL A PACKAGE ADAPTATION**

When unboxing is eventually authorized, build an original shipment manifest with discovery counts, silhouettes, clear tier text, and explicitly stated reward conditions. Plan milestone rewards around useful courier tools or bounded cosmetics. Do not copy the pet catalog, names, bat artwork, reward amounts, or exact grid treatment. Do not infer a weapon system requirement from this study.

## 10. Day, night, incubation, and synchronized refresh

**OBSERVED**

The HUD alternates a moon countdown during day and a sun countdown during night. Night adds a green x30 label beside the egg inventory icon. The observed sunrise shows ALL EGG RESET! and rare-egg announcements, followed by a next-night countdown around five minutes. Night was brief enough to pass during a short capture burst. Sampling did not capture the complete night start-to-end interval, so a precise duration is not established. Lighting can lag the countdown transition in a frame.

The reset message confirms an announced global refresh. It does not by itself verify every spawn's actual reroll, behavior for carried eggs, or whether occupied plots are affected. A ready egg and Hatch prompt were visible; base timers, night timer acceleration, offline growth, and size-dependent growth rules were not measured. The x30 indicator is visible boost communication, not a verified timing formula.

**USEFUL PRINCIPLE**

A shared countdown gives the server a rhythm: prepare, take advantage of a short window, then inspect fresh loot. A very brief boost can create anticipation, but may be easy to miss without advance notice and clear feedback.

**STEAL A PACKAGE ADAPTATION**

Keep our synchronized sunrise package refresh and short night phase with a future opening multiplier hook. Use our own cycle lengths and boost. Make the pending refresh and night purpose readable; preserve carried packages and existing player progress. Keep opening deferred. When it is built, test actual timer acceleration and clearly communicate whether boosts affect queued work, newly placed work, or both.

## 11. Sizes and mutations

**OBSERVED**

Collectibles show gender symbols and weight labels. Very large displayed values coincide with enormous models. Cosmic and Mythic labels and elaborate glows appear on developed pets, but those labels alone do not prove mutation rules. No mutation-roll interface, size distribution, gender function, or weight formula was observed.

**USEFUL PRINCIPLE**

Visual variation can make repeated collectibles memorable and publicly distinguish an exceptional find. Unbounded scale can overwhelm the map and hide interaction targets.

**STEAL A PACKAGE ADAPTATION**

Do not add a carried-package weight system. If collectible variants are later useful, use bounded presentation changes such as finish, seal, or provenance, with a clear role. Keep display scale independent of enormous numeric growth. Variant systems are future scope, not a prerequisite for the current loop.

## 12. Fusion, crafting, and rebirth/prestige

**OBSERVED**

A green locked-looking machine is visible near the hub services. Its recipe, unlock condition, and function were not established through an opened menu. No complete fusion/crafting or rebirth/prestige flow was observed. A machine's appearance is insufficient evidence to invent mechanics; absence of a captured menu is also insufficient evidence that a feature does not exist.

**USEFUL PRINCIPLE**

Secondary systems can give surplus items or mature progression a purpose, but they add rules and can obscure a simple first-session loop. Their value must be demonstrated before expanding the game's scope.

**STEAL A PACKAGE ADAPTATION**

Keep fusion, crafting, and rebirth excluded as requested. Evaluate surplus-collectible pressure and long-term goals only after the steal/train/return loop and eventual opening are enjoyable. Do not reproduce an unseen system from assumptions.

## 13. Monetization and shop structure

**OBSERVED**

The Shop has Featured, Speed, and Money tabs. A treadmill comparison offers both earned cash and Robux. Trail cards also offer cash and Robux paths for an unowned item. Speed offers with large advertised gains appear in the shop. A prominent speed offer appears at the top of normal gameplay during part of the walkthrough. The interface does not establish whether each item is a gamepass, repeatable developer product, temporary boost, or permanent entitlement. Premium purchase fulfillment was not tested.

**USEFUL PRINCIPLE**

Offers placed beside a relevant upgrade decision are easy to understand. Earnable paths support progression while a premium option offers acceleration. Excessively prominent offers compete with route and danger information; massive stat offers can also make balance harder to understand.

**STEAL A PACKAGE ADAPTATION**

No monetization is added at this stage. For a future separate design pass, organize offers by an explicit benefit and duration, preserve a satisfying earned route, and keep essential chase readability and basic progression available. Avoid importing reference prices, multipliers, product names, banners, paid scarcity rules, or purchase prompts.

## 14. HUD, menus, text, and onboarding

**OBSERVED**

Normal HUD: Shop, Index, and Slow Mode on the left; egg/pet/potion icons on the right; Speed and cash at bottom left; inventory hotbar at bottom center; event/day-night countdowns at bottom right. Index uses a notification badge. Stage names briefly appear at the top with emoji faces. Menus use large titles, a red close X, bold white lettering, heavy dark outlines, vivid tier colors, and stud-textured/striped backgrounds. Exact font family cannot be identified from screenshots.

The chase substitutes RUN!! and Drop for most ordinary HUD content. Prompts appear beside interactions. The wrong-area placement message explains a failed action, although it does not precisely indicate the valid placement target. No initial tutorial, first login reward flow, or onboarding funnel was observed. Slow Mode is visibly available; its exact movement rule was not tested.

**USEFUL PRINCIPLE**

Stable corner placement makes routine stats easy to find. Clear action states reduce uncertainty. A large danger cue helps under pressure. A dense menu can communicate many rewards, but visual emphasis needs restraint so all buttons do not compete equally.

**STEAL A PACKAGE ADAPTATION**

Keep temporary UI focused on carried package, cash, training progress, current guardian threat, and cycle countdown. Use readable shipping-themed typography and an original restrained color hierarchy. Show before/after upgrade effects and explicit multiplier purpose. Future onboarding should teach one action at a time: steal one package, cross dispatch, return home, train, then try deeper. Do not recreate the exact corner-button arrangement, artwork, texture treatment, or fonts.

## 15. Sound and visual feedback

**OBSERVED**

Visual feedback includes moving trails, guardian Z/! state markers, circular interaction progress, a chase vignette, flashing/floating income, large stage names, rare-spawn notices, sunrise reset notices, and bright collectible effects. A global boss-event announcement and countdown overlay appeared during the walkthrough, partially covering the map. Audio could not be isolated with the available tools: the exposed recording input was a microphone, not game-output loopback. No sounds were recorded, heard, measured, extracted, or identified. This is a visual feedback audit, not a verified sound scan.

**USEFUL PRINCIPLE**

Immediate feedback connects an action to its outcome. Shared event cues can give players something to anticipate together. Overlapping announcements, particles, and huge models reduce the clarity that makes the core loop approachable.

**STEAL A PACKAGE ADAPTATION**

Plan original, short cues for pickup, guardian wake, approach danger, dispatch escape, caught loss, cash award, training milestone, upgrade, and sunrise. Treat this as an audio design proposal, not a description of reference audio. Give threat cues priority over cosmetic sounds; add mute/volume control later. Bound VFX and queue noncritical announcements instead of stacking them over the route.

## 16. Motivation, first-session pacing, and multiplayer

**OBSERVED**

Other players visibly travel the same route, approach shared loot, train on plots, and display owned trails and enormous collectibles. Public rare-spawn announcements point everyone toward a region. A money-per-second leaderboard provides comparison. The walkthrough includes several simultaneous players and an active stage guardian, but contention rules, guardian retargeting, plot theft permissions, combat effectiveness, and multiplayer fairness were not systematically tested.

Visible progression targets include deeper areas, stronger training equipment, trail tiers, capacity, collection gaps, income, and timed refreshes. A free chest and potion countdown provide additional return cues. The account was already developed, so the first 10–30 minutes' actual reward cadence was not measured.

**USEFUL PRINCIPLE**

The loop offers several timescales: immediate escape, near-term training/purchase, medium-term discovery, and longer-term display/status. Nearby players make accomplishments visible. Shared scarcity can make a refresh exciting, but stronger players may crowd out beginners if contention is not designed carefully.

**STEAL A PACKAGE ADAPTATION**

For future new-profile tests, aim for a clear first success, a visible training improvement, an affordable meaningful upgrade, and a tempting next-stage attempt within an understandable sequence. Measure those moments rather than copying the reference's timings. Test shared guardians and simultaneous theft at mixed progression levels; keep Starter Street useful and readable. Keep social display bounded and avoid compulsory PvP or extra systems until the core loop proves reliable.

## The ten most important design lessons

1. Make the route home obvious before asking players to take a risk.
2. Communicate safety using redundant world cues and unmistakable outcome feedback.
3. Put the loot decision near a visible guardian, with room to scout safely.
4. Keep pursuit lanes clear; scenery should explain a destination rather than block travel.
5. Make automatic training a recognizable world station with a visible, understandable upgrade benefit.
6. Name multiplier effects precisely; training gain and current movement speed are different promises.
7. Offer small and large collection goals with explicit reward conditions.
8. Use shared refresh timing to renew choices, with enough warning to prepare.
9. Let plots show ownership and progress while enforcing limits on visual clutter.
10. Protect the simple loop from menu density, giant stat offers, and premature secondary systems.

## Map-layout lessons to keep

- A single understandable outward route and return destination.
- Services adjacent to the return journey and clear home markers.
- Recognizable stage thresholds and visible next destinations.
- Loot/guardian groups with space to approach, compare, turn, and escape.
- Scenery at edges and practical clearances around plots and training equipment.
- Original variations in street geometry and landmarks; no exact corridor reconstruction.
- A finish boundary guardians cannot cross into the hub or plots.

## Progression and economy lessons to keep

- Connect stronger training to a tangible improvement in escape attempts.
- Explain a belt's base rate, a trail's multiplier, and effective gain separately.
- Keep capacity as a useful sink with explicit added slots.
- Preserve meaningful outcomes in early stages while raising later-stage average reward and risk.
- Show completion conditions instead of assuming all rewards mean full completion.
- Evaluate test cash now and future collectible income as separate economy phases.
- Measure fresh-player pacing and mixed-level multiplayer before adding permanent acceleration products.

## UI lessons to keep

- Stable stat locations, readable interaction prompts, and clear close controls.
- State-specific danger feedback with a visible route-home cue.
- Exact benefit labels, current/next comparisons, equip state, and claimed state.
- Day/night preparation cues that explain the action the player should take.
- Tier identification using text as well as color.
- One notification priority system; avoid overlapping economy, event, region, and chase banners.
- Keep shipping-themed visual identity independent of the reference's artwork and typography.

## Features worth adapting

Automatic training at a physical station; training-rate equipment upgrades; a single equipable cosmetic training modifier; capacity progression; coherent loot/guardian clusters; soft difficulty recommendations; a visible hub finish line; sunrise refresh; a future short opening boost; a collection manifest with explicit milestones; bounded social displays; short action/outcome feedback.

These are design principles. Some match the existing package foundation already. Others, especially opening, indexing, income, and sound, are proposals for later approved scope.

## Features and content to avoid copying

Exact biome sequence, rectangular dimensions, wall/floor patterns, loot coordinates, guardian/pet models, egg/nest assets, pet names and catalog, rarity palette, trail art/names/multipliers, treadmill designs, fonts and button artwork, currencies' visual treatment, prices, income formulas, timer values, premium offers, event characters, branding, and proprietary sound recordings.

Also avoid the observed readability problems: collectibles spilling over plots, avatar-obscuring carried loot, effects covering services, floating text spam, overlapping event banners, ambiguous Speed multipliers, and huge-number upgrades without an understandable movement benefit. Keep weight, fusion/crafting, rebirth, monetization, and major art outside the currently authorized package foundation.

## Coverage still requiring a focused follow-up

| Topic | Current evidence | Missing verification |
|---|---|---|
| First spawn/tutorial and first 10–30 minutes | Advanced-account hub only | Fresh-account route and timed milestones |
| All later stages | Early/middle layouts and ocean/bone preview | Complete late-stage names, overview and guardian placement |
| Exact safe-line termination | Marked boundary; pursuit and later inventory | Continuous crossing and guardian return |
| Treadmill/trails math | Automatic training clarified by user; physical devices, rate labels, menus | Exact gain interval, entry/exit boundaries, and controlled modifier comparison |
| Capacity | Current→next sign | Slots per level and storage/display limits |
| Full rarity pools | Three sampled eight-card index panels | Every stage's catalog and disclosed odds, if any |
| Bat/completion reward | Reward graphic and claimed strip | Stated threshold and ordinary-use behavior |
| Hatching/night acceleration | Ready prompt and x30 indicator | Base timer and observed countdown rate |
| Refresh | Sunrise reset announcement | Same spots before/after plus carried-item behavior |
| Fusion/rebirth | Machine exterior only | Actual menus and stated rules, if present |
| Monetization | Cash/Robux offers and tabs | Complete product categories; no purchases needed |
| Audio | No isolated game output | User-supplied game-audio clip or supported loopback capture |

## High-value reference use

Use the accompanying screenshot gallery and captions to select evidence for later map/UI prompts. Ask future agents to study **why** a view is readable, then design an original package-themed solution. Never ask them to match the screenshot, trace the map, reproduce a proprietary asset, or import observed numbers as balance targets.

Suggested prompt: “Use REFERENCE_STUDY.md and the selected screenshots to understand return-route clarity, compact services, guardian/loot grouping, and progression feedback. Produce an original Steal a Package proposal for the existing street sequence and scope. Preserve three package spots, stage-local pursuit, training-gain trails, plot capacity, sunrise refresh, and no hard locks. Do not copy geometry, artwork, names, or balance.”
