#!/bin/bash
FISH_PATH="$(command -v fish)"
if ! grep -qF "$FISH_PATH" /etc/shells; then
  echo "$FISH_PATH" | sudo tee -a /etc/shells
fi
chsh -s "$FISH_PATH"
