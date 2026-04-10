#!/usr/bin/env bash

###############################################################################
# General UI/UX                                                               #
###############################################################################

# Enable dark mode
defaults write NSGlobalDomain AppleInterfaceStyle -string "Dark"

# Always show scrollbars
defaults write NSGlobalDomain AppleShowScrollBars -string "Always"

# Disable window opening/closing animations
defaults write NSGlobalDomain NSAutomaticWindowAnimationsEnabled -bool false

# Nearly instant window resize animation
defaults write NSGlobalDomain NSWindowResizeTime -float 0.001

# Disable focus ring animation
defaults write NSGlobalDomain NSUseAnimatedFocusRing -bool false

# Reduce toolbar title rollover delay
defaults write NSGlobalDomain NSToolbarTitleViewRolloverDelay -float 0

# Disable automatic termination of inactive apps
defaults write NSGlobalDomain NSDisableAutomaticTermination -bool true

# Save to disk (not to iCloud) by default
defaults write NSGlobalDomain NSDocumentSaveNewDocumentsToCloud -bool false

# Expand save panel by default
defaults write NSGlobalDomain NSNavPanelExpandedStateForSaveMode -bool true
defaults write NSGlobalDomain NSNavPanelExpandedStateForSaveMode2 -bool true

# Disable the "Are you sure you want to open this application?" dialog
defaults write com.apple.LaunchServices LSQuarantine -bool false

###############################################################################
# Trackpad, mouse, keyboard, and input                                        #
###############################################################################

# Trackpad: enable tap to click
defaults write com.apple.AppleMultitouchTrackpad Clicking -bool true
defaults write com.apple.driver.AppleBluetoothMultitouch.trackpad Clicking -bool true
defaults -currentHost write NSGlobalDomain com.apple.mouse.tapBehavior -int 1
defaults write NSGlobalDomain com.apple.mouse.tapBehavior -int 1

# Magic Mouse: enable left and right-clicking
defaults write com.apple.driver.AppleBluetoothMultitouch.mouse MouseButtonMode -string "TwoButton"

# Disable press-and-hold in favor of key repeat
defaults write NSGlobalDomain ApplePressAndHoldEnabled -bool false

# Set fast keyboard repeat rate
defaults write NSGlobalDomain InitialKeyRepeat -int 20
defaults write NSGlobalDomain KeyRepeat -int 2

# Disable automatic text substitutions
defaults write NSGlobalDomain NSAutomaticCapitalizationEnabled -bool false
defaults write NSGlobalDomain NSAutomaticDashSubstitutionEnabled -bool false
defaults write NSGlobalDomain NSAutomaticPeriodSubstitutionEnabled -bool false
defaults write NSGlobalDomain NSAutomaticQuoteSubstitutionEnabled -bool false
defaults write NSGlobalDomain NSAutomaticSpellingCorrectionEnabled -bool false

# Set language and text formats
defaults write NSGlobalDomain AppleLanguages -array "en" "es"
defaults write NSGlobalDomain AppleMeasurementUnits -string "Centimeters"
defaults write NSGlobalDomain AppleMetricUnits -bool true

###############################################################################
# Screen                                                                      #
###############################################################################

# Require password immediately after sleep or screen saver begins
defaults write com.apple.screensaver askForPassword -int 1
defaults write com.apple.screensaver askForPasswordDelay -int 0

###############################################################################
# Finder                                                                      #
###############################################################################

# Show all filename extensions
defaults write NSGlobalDomain AppleShowAllExtensions -bool true

# Show hidden files by default
defaults write com.apple.finder AppleShowAllFiles -bool true

# Show path bar
defaults write com.apple.finder ShowPathbar -bool true

# Display full POSIX path as window title
defaults write com.apple.finder _FXShowPosixPathInTitle -bool true

# Disable the warning when changing a file extension
defaults write com.apple.finder FXEnableExtensionChangeWarning -bool false

# Use list view in all Finder windows by default
defaults write com.apple.finder FXPreferredViewStyle -string "Nlsv"

# Keep folders on top when sorting by name
defaults write com.apple.finder _FXSortFoldersFirst -bool true

# Avoid creating .DS_Store files on network or USB volumes
defaults write com.apple.desktopservices DSDontWriteNetworkStores -bool true
defaults write com.apple.desktopservices DSDontWriteUSBStores -bool true

###############################################################################
# Dock                                                                        #
###############################################################################

# Automatically hide and show the Dock
defaults write com.apple.dock autohide -bool true

# Remove the auto-hiding Dock delay
defaults write com.apple.dock autohide-delay -float 0

# Remove the animation when hiding/showing the Dock
defaults write com.apple.dock autohide-time-modifier -float 0

# Set icon size to 36 pixels
defaults write com.apple.dock tilesize -int 36

# Use scale effect for minimizing windows
defaults write com.apple.dock mineffect -string "scale"

# Minimize windows into their application's icon
defaults write com.apple.dock minimize-to-application -bool true

# Wipe all default app icons from the Dock
defaults write com.apple.dock persistent-apps -array

# Show only open applications in the Dock
defaults write com.apple.dock static-only -bool true

# Don't animate opening applications from the Dock
defaults write com.apple.dock launchanim -bool false

# Make icons of hidden applications translucent
defaults write com.apple.dock showhidden -bool true

# Don't show recent applications in Dock
defaults write com.apple.dock show-recents -bool false

###############################################################################
# Software Update                                                             #
###############################################################################

# Check for updates daily, download in background, install security updates
defaults write com.apple.SoftwareUpdate AutomaticCheckEnabled -bool true
defaults write com.apple.SoftwareUpdate ScheduleFrequency -int 1
defaults write com.apple.SoftwareUpdate AutomaticDownload -int 1
defaults write com.apple.SoftwareUpdate CriticalUpdateInstall -int 1
defaults write com.apple.SoftwareUpdate ConfigDataInstall -int 1

###############################################################################
# Restart affected apps                                                       #
###############################################################################

killall Finder
killall Dock
/System/Library/PrivateFrameworks/SystemAdministration.framework/Resources/activateSettings -u
