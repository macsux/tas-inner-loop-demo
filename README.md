This is a proof of concept demo of an inner-loop for .NET app running on Tanzu Application Service. It relies on patching existing container image already running in TAS without doing a full redeploy via `cf push`, greatly speeding up time it takes to reflect local changes remotely.

## Quick start

1. Have .NET 6 SDK & Tilt installed
2. Be logged in and targeting org / space with `cf`
3. Run `tilt up` from root dir

## Config

### Trigger mode

The code allows two types of triggers, controlled by `trigger` variable inside `Tiltfile`:

- `build`: will synchronize when the application is built. This is the most likely usage scenario for compilation based languages like .NET
- `source`: will trigger synchronization when any source code changes

### Fast initial deploy

By default tilt will do a `cf push` when tilt is first started. However, if the app is already running and was deployed using correct manifest previously, this can be skipped in favor of a delta binary transfer. You can control this feature by edit `.env` file and changing `CF_PUSH_INIT` variable. 

## Performance

Experiments show that the time from local source change to being reflected by the running app using LiveSync is ~7 seconds vs ~80 seconds for `cf push` for a typical .NET web application.

## How it works

Since tilt only supports syncing with Kubernetes or Docker Compose, the system relies on three stages stages. 

1. Tilt file system watch for either source files or local compilation output triggers a secondary compilation specific for Linux
2. After the compiled binaries are synced into an intermediately docker-compose container. This container has `cf` and `rwatch` tooling 
3. Deploy to TAS
   1. If Tilt detects that full rebuilt is necessary, it will initiate a `cf push` from inside docker compose container starts it will do a `cf push` to do intial deployment (unless fast initial deploy option is enabled)
   2. If Tilt detects that `LiveSync` can be done, it will first sync binaries into the container, and then invoke a special shell script inside the running docker container that will do an `rsync` folder synchronization using SSH to TAS container.

While this architecture is slightly inefficient as there is double synchronization (first into local container via Tilt, then with `rsync` over ssh into TAS), it ensures maximum compatibility as `rsync` does not work natively on Windows requiring a transient Linux container. It also allows use of Tilt to bring experience as close to that of TAP. 

