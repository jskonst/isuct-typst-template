FROM debian:bookworm-slim

ENV DEBIAN_FRONTEND=noninteractive

# Times New Roman лежит в non-free (ttf-mscorefonts-installer).
RUN sed -i 's/Components: main/Components: main contrib non-free/' /etc/apt/sources.list.d/debian.sources \
    && apt-get update && apt-get install -y --no-install-recommends \
        ca-certificates \
        wget \
        xz-utils \
        fontconfig \
        fonts-liberation \
        graphviz \
        zip \
        debconf \
    && echo "ttf-mscorefonts-installer msttcorefonts/accepted-mscorefonts-eula select true" \
        | debconf-set-selections \
    && apt-get install -y --no-install-recommends ttf-mscorefonts-installer \
    && wget -qO /tmp/typst.tar.xz \
        https://github.com/typst/typst/releases/download/v0.14.2/typst-x86_64-unknown-linux-musl.tar.xz \
    && tar -xJf /tmp/typst.tar.xz -C /tmp \
    && mv /tmp/typst-x86_64-unknown-linux-musl/typst /usr/local/bin/typst \
    && chmod +x /usr/local/bin/typst \
    && rm -rf /tmp/typst.tar.xz /tmp/typst-x86_64-unknown-linux-musl \
    && fc-cache -f \
    && apt-get clean && rm -rf /var/lib/apt/lists/*

WORKDIR /work
COPY . /work

# Прогрев кэша пакетов Fletcher, CeTZ и diagraph.
RUN typst compile --root . examples/isit-diploma/main.typ /tmp/isuct-example.pdf \
    && typst compile --root . template/main.typ /tmp/isuct-generic.pdf \
    && rm -f /tmp/isuct-example.pdf /tmp/isuct-generic.pdf

ENTRYPOINT ["typst"]
CMD ["compile", "--root", ".", "examples/isit-diploma/main.typ", "results/example.pdf"]
