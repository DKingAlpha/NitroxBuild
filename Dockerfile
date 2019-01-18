FROM ubuntu:xenial
LABEL maintainer="dking"

WORKDIR /opt

###
RUN apt-get update

# add /etc/localtime to
RUN apt-get install -y tzdata


# unity
## normal dependencies for UnityEditor
RUN apt-get install -y wget gconf-service lib32gcc1 lib32stdc++6 libasound2 libc6-i386 \
                       libcairo2 libcups2 libdbus-1-3 libexpat1 libfontconfig1 \
                       libgdk-pixbuf2.0-0 libgl1-mesa-glx libglu1-mesa libgtk2.0-0 \
                       libnspr4 libnss3 libpango1.0-0 libxcomposite1 libxcursor1 xdg-utils \
                       libpq5 lsb-release npm
## cache or [download](https://forum.unity.com/threads/unity-on-linux-release-notes-and-known-issues.350256/)
#COPY unity-editor_amd64-5.6.2xf1Linux.deb /opt/
#RUN dpkg -i /opt/unity-editor_amd64-5.6.2xf1Linux.deb
RUN  wget -q http://beta.unity3d.com/download/ddd95e743b51/unity-editor_amd64-5.6.2xf1Linux.deb && \
     dpkg -i unity-editor_amd64-5.6.2xf1Linux.deb && rm unity-editor_amd64-5.6.2xf1Linux.deb


# mono latest
ENV MONO_VERSION 5.18.0.225
## in xenial, gpg returns 1 throwing "no ultimately trusted keys found", so I had to ignore this warning to continue
RUN apt-get install -y --no-install-recommends gnupg dirmngr \
  && export GNUPGHOME="$(mktemp -d)" \
  && gpg --batch --keyserver hkp://keyserver.ubuntu.com:80 --recv-keys 3FA7E0328081BFF6A14DA29AA6A19B38D3D831EF \
  && gpg --batch --export --armor 3FA7E0328081BFF6A14DA29AA6A19B38D3D831EF > /etc/apt/trusted.gpg.d/mono.gpg.asc \
  && rm -rf "$GNUPGHOME" \
  && apt-key list | grep Xamarin \
  && apt-get purge -y --auto-remove gnupg dirmngr || true

RUN echo "deb http://download.mono-project.com/repo/ubuntu stable-xenial/snapshots/$MONO_VERSION main" > \
    /etc/apt/sources.list.d/mono-official-stable.list \
    && apt-get update

RUN apt-get install -y --allow-unauthenticated mono-complete msbuild nuget referenceassemblies-pcl


RUN rm -rf /var/lib/apt/lists/*


# default build script
COPY build.sh /opt/
RUN chmod 755 /opt/build.sh
CMD /opt/build.sh

