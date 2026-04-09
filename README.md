# config

macOS and Linux machine setup — chezmoi, homebrew, mise.

## Setup

Some steps are macOS only.

### 1. Create SSH key and add to GitHub

See [GitHub docs](https://docs.github.com/en/authentication/connecting-to-github-with-ssh/generating-a-new-ssh-key-and-adding-it-to-the-ssh-agent) for full instructions.

```sh
ssh-keygen -t ed25519 -C "229201+diorman@users.noreply.github.com"
```

Then add the public key to your [GitHub account](https://github.com/settings/keys).

### 2. Install Homebrew (macOS)

See [brew.sh](https://brew.sh) for installation instructions.

### 3. Install chezmoi (macOS)

```sh
brew install chezmoi
```

### 4. Initialize chezmoi

```sh
chezmoi init --ssh --source "$HOME/code/github.com/diorman/config" diorman/config
```

### 5. Apply dotfiles

```sh
chezmoi apply --dry-run --verbose  # preview
chezmoi apply
```

### 6. Install packages (macOS)

```sh
brew bundle --global
```

### 7. Import GPG key (macOS)

Required before making signed git commits. Download the private key from 1Password, then:

```sh
gpg --import /path/to/gpg-private-key.asc
rm /path/to/gpg-private-key.asc
```
