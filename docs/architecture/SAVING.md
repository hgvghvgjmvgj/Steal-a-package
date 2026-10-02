# Basic saving

Schema v2 persists Cash, TrainingPoints, TreadmillLevel, CapacityLevel, OwnedTrails, EquippedTrail and validated Collectibles. Movement speed is derived from training points, not saved independently. Old v1 SpeedLevel migrates to equivalent training points, preserving the old +2 movement per purchased level. Carried packages, guardian threats, plot assignments, training sessions and day/night state are transient.

ProfileStore uses UpdateAsync for acquisition and writes. A renewable 180-second session lease prevents concurrent servers from overwriting the same profile. Autosaves run every 45 seconds; treadmill/capacity purchases and trail equip request a save; player leave and BindToClose save and release the lease. Revision tracking keeps new training earned during an in-flight save marked Unsaved. Failed loads never overwrite existing data with defaults in a live server. Numeric fields, trail ownership, rarity IDs and capacity-limited collectible records are normalized.

Store: `StealAPackage_Graybox_v1`. Live keys use `player:<UserId>`. Studio uses `studio:<UserId>` to keep test progress separate. The opt-in persistence regression uses `StealAPackage_Graybox_v1_QA` with a disposable key.

If API access is disabled, Studio alone falls back to session-only data and the HUD says `SessionOnly`; this mode is not persistent. Live load failures kick with a rejoin message. Failed writes keep in-memory values for later retries and show `SaveFailed`.

Enable File → Experience Settings → Security → Enable Studio Access to API Services for a real write/reload test. This place is a new test project. Do not reuse Studio test keys for live players.

This is a graybox persistence layer with v1 → v2 migration. Collectible records and displays are a foundation for future unboxing; test placeholder records are restored after QA.
