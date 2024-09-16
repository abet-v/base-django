# base-django

This repository serves as a base template for a Django project encapsulated within a Docker container. It is designed to provide a quick and easy setup for developing Django applications with Docker.

## Features

- **Django 5.1.1**: The project is set up with Django version 5.1.1.
- **Docker**: The project uses Docker to create an isolated environment for the Django application.
- **Debian-based Python Image**: The Dockerfile is based on `python:3.12.6-bookworm`, but you can modify it to use a newer version of Debian or Python as needed.

## Getting Started

### Prerequisites

- Docker installed on your machine.

### Setup

1. **Clone the repository**:
    ```sh
    git clone https://github.com/yourusername/base-django.git
    cd base-django
    ```

2. **Build the Docker image**:
    ```sh
    docker compose build
    ```

3. **Run the Docker container**:
    ```sh
    make start
    ```

4. **Access the application**:
    Open your web browser and navigate to `http://localhost:8000`.

## Customization

### Updating the Dockerfile

To update the Dockerfile to use a newer version of Debian or Python, modify the `FROM` line in the Dockerfile. For example:
```dockerfile
FROM python:3.12.6-bookworm
```


### Updating Django Version
To update the Django version, modify the requirements.txt file:

```
Django==5.1.1
```

After updating the requirements.txt file, rebuild the Docker image to apply the changes:

```sh
docker compose build
```

Contributing
Feel free to submit issues or pull requests if you find any bugs or have suggestions for improvements.
