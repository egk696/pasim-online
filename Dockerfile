# base image
FROM ubuntu:18.04



# add requirements (to leverage Docker cache)
ADD ./requirements.txt /usr/src/app/requirements.txt
ENV TZ=Europe/Moscow
RUN ln -snf /usr/share/zoneinfo/$TZ /etc/localtime && echo $TZ > /etc/timezone
# install requirements
RUN DEBIAN_FRONTEND="noninteractive" apt-get -v install tzdata
RUN apt-get update && apt-get install -y \
    aufs-tools \
    automake \
    build-essential \
    curl \
    dpkg-sig \
    libcap-dev \
    libsqlite3-dev \
    python3.8 \
    python3-pip \
    locales \
    git \
    default-jdk \
    gitk \
    cmake \
    make \
    g++ \
    flex \
    bison \
    libelf-dev \
    graphviz \
    libboost-dev \
    libboost-program-options-dev \
    ruby-full \
    liblpsolve55-dev \
    zlib1g-dev \
    autoconf\
    libfl2 \
    ruby-full \
    wget \
 && rm -rf /var/lib/apt/lists/*

 # Set the locale
RUN sed -i -e 's/# en_US.UTF-8 UTF-8/en_US.UTF-8 UTF-8/' /etc/locale.gen && \
    locale-gen
ENV LANG en_US.UTF-8
ENV LANGUAGE en_US:en
ENV LC_ALL en_US.UTF-8

# Setup patmos stuff first
RUN mkdir -p /home/t-crest/local
WORKDIR /home/t-crest/local
RUN wget -O patmos-compiler-rt.tar.gz "https://github.com/t-crest/patmos-compiler-rt/releases/download/v1.0.0-rc-1/patmos-compiler-rt-v1.0.0-rc-1.tar.gz" \
&& wget -O patmos-gold.tar.gz "https://github.com/t-crest/patmos-gold/releases/download/v1.0.0-rc-1/patmos-gold-v1.0.0-rc-1.tar.gz"\
&& wget -O patmos-simulator.tar.gz "https://github.com/t-crest/patmos-simulator/releases/download/1.0.1/patmos-simulator-x86_64-linux-gnu.tar.gz" \
&& wget -O patmos-llvm.tar.gz "https://github.com/t-crest/patmos-llvm/releases/download/1.0.0-rc1/patmos-llvm-x86_64-linux-gnu.tar.gz" \
&& tar -xvf patmos-compiler-rt.tar.gz \
&& tar -xvf patmos-gold.tar.gz \
&& tar -xvf patmos-simulator.tar.gz \
&& tar -xvf patmos-llvm.tar.gz

ENV PATH="/home/t-crest/local/bin:${PATH}"

# set working directory
RUN mkdir -p /usr/src/app
WORKDIR /usr/src/app

# copy project
COPY . /usr/src/app

RUN pip3 install -r requirements.txt

ENV FLASK_APP manage.py

CMD ["gunicorn", "manage:app"]
