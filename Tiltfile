version_settings(constraint='>=0.22.1')
os.putenv ('DOCKER_BUILDKIT' , '1' )
isWindows = True if os.name == "nt" else False
expected_ref = "%EXPECTED_REF%" if isWindows else "$EXPECTED_REF"

trigger='source' # use 'build' to trigger deploy after compiling locally. use 'source' to trigger on any file change
rid = "linux-x64"
configuration = "Debug"
appFolder = "sample"
syncFolder = "./sample/bin/.buildsync"
buildSyncCmd = 'dotnet publish ./sample --configuration ' + configuration + ' --runtime ' + rid + ' --no-self-contained --output ' + syncFolder

# a local build triggers a second build specific for linux into $syncFolder

if trigger == 'build':
  trigger_deps = ['./sample/bin/' + configuration]
  trigger_ignore = ['./sample/bin/**/' + rid]
elif trigger == 'source':
  trigger_deps = ['./sample']
  trigger_ignore = ['./sample/bin/**', './sample/obj/**']

local_resource(
  'live-update-build',
  cmd= buildSyncCmd,
  deps=trigger_deps,
  ignore=trigger_ignore
)

docker_compose('docker-compose.yaml')


custom_build(
        'sample:live-sync',
        'docker-compose stop && ' + buildSyncCmd + ' && docker build ./rsync-exec -t ' + expected_ref,
        deps=[syncFolder, "./sample/manifest.yaml", "./rsync-exec"],
        live_update=[
          sync(syncFolder, '/sync'),
          run('/resync.sh')
        ]
    )
