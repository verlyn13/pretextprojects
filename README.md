# pretextprojects

## Docker Workflow for PreTeXt Projects

This workflow allows you to run the Docker container in the background while you continue to use your terminal for other tasks. You can then attach a terminal session to the running container whenever you need to run PreTeXt CLI commands or perform other interactive tasks within the container.

### Starting the Container in Detached Mode

To start the Docker container in detached mode and keep it running in the background:

```bash
docker run -d -p 8888:8888 --cpus="1.0" --memory="4g" -v ${PWD}:/home/jupyter --name pretext_project verlyn13/pretext-image:latest

### Attaching a Terminal Session to the Running Container

To start an interactive terminal session inside the running container, use the following command:

```bash
docker exec -it pretext_project /bin/bash
