# Script to build the docker image and deploy it to the cluster
# Pull env variables
source env.sh

# Build the image
echo "2. Build docker image"
docker build \
    --build-arg STEAM_USERNAME="$steam_username" \
    --build-arg STEAM_PASSWORD="$steam_password" \
    --build-arg SCRN_GDRIVE_ID="$scrn_gdrive_id" \
    --build-arg SCRN_GDRIVE_FILE_NAME="$scrn_gdrive_file_name" \
    --build-arg GAME_PORT="$game_port" \
    --build-arg QUERY_PORT="$query_port" \
    --build-arg LISTEN_PORT="$listen_port" \
    --build-arg GAME_ADMIN_NAME="$game_admin_name" \
    --build-arg GAME_ADMIN_PASSWORD="$game_admin_password" \
    --build-arg SERVERNAME="$server_name" \
    --build-arg GAME_PASSWORD="$game_password" \
    -t kf1scrn:latest \
    .
echo "2. End build docker image"

# Update the cluster
echo "3. Update pod"
# kubectl replace --force -f ../k8s/kf1scrn.yml
echo "3. End update pod"
