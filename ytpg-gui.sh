#!/bin/bash

# Function to append video URLs to the array
add_video_urls() {
  local video_urls=$1
  all_video_urls+=("$video_urls")
}

# Function to generate the playlist
generate_playlist() {
  # Array to store all video URLs
  all_video_urls=()

  # Iterate over each playlist ID
  for playlist_id in "${playlist_ids[@]}"; do
    # Use youtube-dl to fetch video URLs from the playlist
    video_urls=$(yt-dlp --get-url --flat-playlist "https://www.youtube.com/playlist?list=$playlist_id")

    # Append video URLs to the array
    add_video_urls "$video_urls"
  done

  # Iterate over each channel ID
  for channel_id in "${channel_ids[@]}"; do
    # Use youtube-dl to fetch video URLs from the channel
    video_urls=$(yt-dlp --get-url --flat-playlist "https://www.youtube.com/channel/$channel_id/videos")

    # Append video URLs to the array
    add_video_urls "$video_urls"
  done

  # Append live stream URLs to the array
  add_video_urls "${live_stream_urls[@]}"

  # Combine all video URLs into a single string
  combined_video_urls=$(printf "%s\n" "${all_video_urls[@]}")

  # Shuffle the video URLs if enabled
  if [ "$shuffle_enabled" = true ]; then
    shuffled_urls=$(echo "$combined_video_urls" | shuf)
  else
    shuffled_urls="$combined_video_urls"
  fi

  # Create or overwrite the playlist file
  if [ "$overwrite_playlist" = true ]; then
    echo "#EXTM3U" > "$playlist_file"
  fi

  # Write video URLs to the playlist file
  echo "$shuffled_urls" >> "$playlist_file"

  # Show dialog message when playlist is built
  zenity --info --text="Playlist has been built!" --title="Playlist Built"
}

# GUI elements
playlist_ids=""
channel_ids=""
live_stream_urls=""
shuffle_enabled=""
overwrite_playlist=""

# Function to show the GUI and capture user input
show_gui() {
  # Show the GUI elements and capture user input
  input=$(zenity --forms --title="YouTube Playlist Generator" --text="Enter YouTube Playlist, Channel, and Live Stream Details" \
    --add-entry="Playlist IDs:" \
    --add-entry="Channel IDs:" \
    --add-entry="Live Stream URLs:" \
    --add-combo="Shuffle Playlist:" --combo-values="Yes|No" \
    --add-combo="Existing Playlist:" --combo-values="Add to Playlist|Overwrite Playlist" \
    --separator="|"
  )

  # Handle Cancel button or window close event
  if [ $? -ne 0 ]; then
    exit 0
  fi

  IFS='|' read -r playlist_ids channel_ids live_stream_urls shuffle_enabled overwrite_playlist <<< "$input"
  playlist_ids=($playlist_ids)
  channel_ids=($channel_ids)
  live_stream_urls=($live_stream_urls)

  # Convert combo box values to boolean variables
  if [ "$shuffle_enabled" = "Yes" ]; then
    shuffle_enabled=true
  else
    shuffle_enabled=false
  fi

  if [ "$overwrite_playlist" = "Overwrite Playlist" ]; then
    overwrite_playlist=true
  else
    overwrite_playlist=false
  fi
}

# Show the GUI and capture user input
show_gui

# Set the playlist file path
playlist_file="$HOME/playlist.m3u"

# Generate the playlist
generate_playlist
