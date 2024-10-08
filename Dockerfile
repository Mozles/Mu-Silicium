FROM debian:bookworm AS mu_builder

# Update package list and install necessary packages
RUN apt update -y && \
    apt install -y pip git mono-devel build-essential nuget uuid-dev iasl nasm gcc-aarch64-linux-gnu gcc-arm-linux-gnueabihf python3 python3-distutils python3-git python3-pip gettext locales gnupg ca-certificates python3-venv git-core clang llvm curl python-is-python3 device-tree-compiler adb fastboot

RUN ln -s /usr/bin/env /usr/bin/sudo

COPY .docker /app
RUN sed -i 's/pip install/pip install --break-system-packages/' /app/setup_env.sh
RUN /bin/sh -c "cd /app && ./setup_env.sh -p apt"

RUN useradd -d /home/dockeruser -u $(id -u) dockeruser || useradd -u 1000 dockeruser
RUN install -d -m 0744 -o dockeruser /home/dockeruser
USER dockeruser

WORKDIR /app
RUN git config --global safe.directory '*'

# Label the image
LABEL maintainer="Dani Ash <d4n1.551@gmail.com>" \
      description="Image for EDK2 development with necessary tools" \
      version="latest" \
      edk2-builder="latest"

ENTRYPOINT [ "/app/build_uefi.sh" ]
#ENTRYPOINT /bin/bash
