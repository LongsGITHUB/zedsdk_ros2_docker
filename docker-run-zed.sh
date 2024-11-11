DOCKERFILE=Dockerfile.zed
IMAGE_NAME=utsma/zed
CONTAINER_NAME=zed_container

# Allow X11 access for the container
xhost +local:root

# Remove old containers
docker ps -a | grep $IMAGE_NAME | awk '{print $1}' | xargs -r docker rm

# Remove old images
docker rmi -f $IMAGE_NAME
docker rm -f $CONTAINER_NAME

# Build the Docker image
docker build -t $IMAGE_NAME -f $DOCKERFILE .

# Run the Docker container
docker run -it --runtime=nvidia \
   --name $CONTAINER_NAME \
   --privileged \
   --network host \
   --device /dev/video0 \
   --volume /tmp/argus_socket:/tmp/argus_socket \
   --env DISPLAY=$DISPLAY \
   --env NVIDIA_DRIVER_CAPABILITIES=all \
   --env NVIDIA_VISIBLE_DEVICES=all \
   --env QT_X11_NO_MITSHM=1 \
   --volume /tmp/.X11-unix:/tmp/.X11-unix \
   --volume /home/utsma/zedsdk_ros2_docker/sdk_config:/usr/local/zed/resources \
   $IMAGE_NAME
