This is a proof of concept demo of an inner-loop for .NET app running on Tanzu Application Service. It relies on patching existing container image already running in TAS without doing a full redeploy via `cf push`, greatly speeding up time it takes to reflect local changes remotely.

## Quick start

1. Have .NET 6 SDK & Tilt installed
2. Run `tilt up` from root dir

## Config

### Trigger mode

The code allows two types of triggers, controlled by `trigger` variable inside `Tiltfile`:

- `build`: will synchronize when the application is built. This is the most likely usage scenario for compilation based languages like .NET
- `source`: will trigger synchronization when any source code changes

### Fast initial deploy

By default tilt will do a `cf push` when tilt is first started. However, if the app is already running and was deployed using correct manifest previously, this can be skipped in favor of a delta binary transfer. You can control this feature by edit `.env` file and changing `CF_PUSH_INIT` variable. 

