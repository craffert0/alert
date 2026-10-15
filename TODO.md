# Done

## Proper timeZone

1. Use `MKReverseGeocodingRequest` to convert from lat/long to timeZone.
2. Except for `eBirdChecklist`, the top-level objects in `eBirdService` each have lat/long.
3. We already have timeZone from the observation when we create a `Checklist` instance.
4. Switch to DTO for all objects that have `Date` field. In the DTO, it's now the `String`,
   and use the inferred timeZone to properly parse the Date.
5. See "work on timezone and checklist" stash for thinking about timeZone.
6. Before the DTO conversion, reduce fields to what's used.
