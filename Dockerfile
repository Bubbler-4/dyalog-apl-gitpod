FROM gitpod/workspace-full:latest

USER root
RUN apt-get update -y -q \
  # Download unregistered Linux build of Dyalog APL, RIDE, Cider, and Tatin
  && cd /tmp \
  && curl -fsSL -k https://www.dyalog.com/uploads/php/download.dyalog.com/download.php?file=18.2/linux_64_18.2.45405_unicode.x86_64.deb -o dyalog.deb \
  && curl -fsSL -k https://github.com/Dyalog/ride/releases/download/v4.4.3689/ride-4.4.3689-1_amd64.deb -o ride.deb \
  && DEBIAN_FRONTEND=noninteractive apt-get install -y -q --no-install-recommends ./dyalog.deb \
  && DEBIAN_FRONTEND=noninteractive apt-get install -y -q --no-install-recommends ./ride.deb
  # Workaround for the serve location bug
  # && cd /opt && ln -s ride-4.3 ride-4.2 && cd /tmp

USER gitpod
RUN cd /tmp \
  && curl -fsSL -k https://github.com/aplteam/Cider/releases/download/v0.11.0/Cider-0.11.0.zip -o cider.zip \
  && curl -fsSL -k https://github.com/aplteam/Tatin/releases/download/v0.69.0/Tatin-Client-0.69.0.zip -o tatin.zip \
  && unzip ./cider.zip && unzip ./tatin.zip \
  && mkdir ~/MyUCMDs \
  && cp -a cider/. ~/MyUCMDs/ && cp -a tatin/. ~/MyUCMDs/
RUN printf "[Ride]\nhttpdir=/opt/ride-4.4/resources/app\n" > ~/.dyalog/ride.ini

USER root
