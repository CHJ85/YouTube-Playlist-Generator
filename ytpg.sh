#!/bin/bash

playlist_ids=("PLUIixndCOJ8xIlKX6JnYNlPOtwMKkeaqG" "PLUIixndCOJ8zPGm6OEdiMwtYadXBA_gvY" "PLUIixndCOJ8waZQoavUVxMSWIDX4Cpm3B" "PLUIixndCOJ8xq-rnxUjacYz4O_6klIzMN" "PLUIixndCOJ8wQCjQhYG9bViwtg7lgIWO-" "PLUIixndCOJ8xcSkdMLxt8VdnxKJt2hDAV" "PLUIixndCOJ8xU-OBhsTBYNVEcVtv5hcpV" "PLUIixndCOJ8wX7BodwHBhXjpZ89xEG8o-" "PLUIixndCOJ8y8PUyWWHF9A0D3suCUFJOn" "PLUIixndCOJ8zETNen8Cl5gL51QyT7-bYy" "PLUIixndCOJ8wl3KS57xKpb2tugAlIsxLp" "PLUIixndCOJ8zD1GbtYvXgVrZCDW7B5j_2" "PLUIixndCOJ8yNBH3FmtlUTxDj-sfBxPEx")
channel_ids=("UCgDFVgTnw_W5DftgN2NQApQ")
live_stream_urls=("https://www.youtube.com/channel/UCMsgXPD3wzzt8RxHJmXH7hQ/live")

playlist_file="$HOME/nelvana.m3u"

# Array to store all video URLs
all_video_urls=()

# Function to append video URLs to the array
add_video_urls() {
  local video_urls=$1
  all_video_urls+=("$video_urls")
}

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

# Shuffle the video URLs
shuffled_urls=$(echo "$combined_video_urls" | shuf)

# Create playlist file
echo "#EXTM3U" > "$playlist_file"

# Write shuffled video URLs to the playlist file
echo "$shuffled_urls" >> "$playlist_file"

# Show dialog message when playlist is built
zenity --info --text="Playlist has been built!" --title="Playlist Built"
