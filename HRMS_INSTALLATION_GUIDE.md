# ERPNext + HRMS Docker Installation Guide

This guide explains how to build and deploy a custom Docker image that includes both ERPNext and HRMS to your Docker Hub account.

## Prerequisites

- Docker installed and running
- Docker Hub account
- Git

## Step-by-Step Instructions

### 1. Update Build Script with Your Docker Hub Username

Edit `build-hrms-image.sh` and replace `your-dockerhub-username` with your actual Docker Hub username:

```bash
DOCKER_HUB_USERNAME="your-actual-username"
```

### 2. Build and Push the Image

Run the build script:

```bash
./build-hrms-image.sh
```

This script will:
- Build a custom Docker image with ERPNext and HRMS
- Prompt you to login to Docker Hub
- Push the image to your Docker Hub repository

### 3. Update Environment Configuration

Copy the custom environment template:

```bash
cp .env.custom .env
```

Edit `.env` and update the `CUSTOM_IMAGE` with your Docker Hub username:

```bash
CUSTOM_IMAGE=your-actual-username/erpnext-hrms
CUSTOM_TAG=v15
PULL_POLICY=always
```

### 4. Deploy the Custom Image

Run your Docker Compose setup as usual:

```bash
docker compose up -d
```

The system will now pull and use your custom image from Docker Hub.

## Verifying HRMS Installation

After deployment, you can verify HRMS is installed by:

1. Access your ERPNext instance
2. Go to the app list or modules
3. You should see "HRMS" or "HR" module available

## Updating the Image

To update your image with new versions:

1. Update `apps.json` if needed
2. Run `./build-hrms-image.sh` again
3. Restart your containers: `docker compose down && docker compose up -d`

## Troubleshooting

### Build Fails
- Ensure you have enough disk space
- Check your internet connection
- Verify the branch names in `apps.json` are correct

### Push Fails
- Ensure you're logged in to Docker Hub: `docker login`
- Verify your username is correct
- Check if the repository name is available

### HRMS Not Showing
- Check container logs: `docker compose logs backend`
- Ensure the site is properly initialized
- Try running bench commands to install the app manually

## Additional Customization

You can add more Frappe apps by editing `apps.json`:

```json
[
  {
    "url": "https://github.com/frappe/erpnext",
    "branch": "version-15"
  },
  {
    "url": "https://github.com/frappe/hrms",
    "branch": "version-15"
  },
  {
    "url": "https://github.com/frappe/payments",
    "branch": "version-15"
  }
]
```

Remember to rebuild and push the image after making changes.