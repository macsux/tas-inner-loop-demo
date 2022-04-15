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

# docker_build(
#   # Image name - must match the image in the docker-compose file
#   'sample:live-sync',
#   # Docker context
#   '.',
#   #deps=['./sample/bin/.buildsync'],
#   live_update = [
#     # Sync local files into the container.
#     sync('./sample/bin/.buildsync', '/sync'),
#     run('/resync.sh')
#     # Re-run npm install whenever package.json changes.
#     #run('npm i', trigger='package.json'),
#   ])


custom_build(
        'sample:live-sync',
        'docker-compose stop && ' + buildSyncCmd + ' && docker build ./rsync-exec -t ' + expected_ref,
        deps=[syncFolder, "./sample/manifest.yaml", "./rsync-exec"],
        live_update=[
          sync(syncFolder, '/sync'),
          run('/resync.sh')
        ]
    )

# custom_build(
#   # Image name - must match the image in the docker-compose file
#   'tilt.dev/express-redis-app',
#   # Docker context
#   '.',
#   live_update = [
#     # Sync local files into the container.
#     sync('.', '/var/www/app'),

#     # Re-run npm install whenever package.json changes.
#     run('npm i', trigger='package.json'),

#     # Restart the process to pick up the changed files.
#     restart_container()
#   ])

# Add labels to Docker services
# dc_resource('redis', labels=["database"])
# dc_resource('app', labels=["server"])