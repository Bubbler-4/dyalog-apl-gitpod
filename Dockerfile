FROM gitpod/workspace-full:latest

USER root
RUN apt-get update -y -q \
  # Download unregistered Linux build of Dyalog APL, RIDE, and Acre
  && cd /tmp \
  && curl -fsSL -k https://www.dyalog.com/uploads/php/download.dyalog.com/download.php?file=18.0/linux_64_18.0.38525_unicode.x86_64.deb -o dyalog.deb \
  && curl -fsSL -k https://github.com/Dyalog/ride/releases/download/v4.3.3453/ride-4.3.3453-1_amd64.deb -o ride.deb \
  && DEBIAN_FRONTEND=noninteractive apt-get install -y -q --no-install-recommends ./dyalog.deb \
  && DEBIAN_FRONTEND=noninteractive apt-get install -y -q --no-install-recommends ./ride.deb \
  # Workaround for the serve location bug
  # && cd /opt && ln -s ride-4.3 ride-4.2 && cd /tmp

USER gitpod
RUN printf "[Ride]\nhttpdir=/opt/ride-4.3/resources/app\n" > ~/.dyalog/ride.ini
RUN curl -fsSL -k https://github.com/the-carlisle-group/Acre-Desktop/releases/download/v6.0.2.266/acre14.0.zip -o acre.zip \
  && unzip ./acre.zip && cd acre14.0 && ( \
    echo ")load salt" && \
    echo "enableSALT" && \
    echo ")load acre.dws" && \
    echo \
  ) | dyalog

USER root
