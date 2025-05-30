# The below image is created out of the Dockerfile.base
# It has the dependencies already installed so that codespace will boot up fast
FROM base:latest

# Do the set up required for chatwoot app
WORKDIR /workspace
COPY . /workspace

# Instalar dependências como usuário vscode
USER vscode
RUN pnpm i && gem install bundler && bundle install
