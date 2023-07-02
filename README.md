# YouTube Playlist Generator

These two Bash scripts generates an M3U playlist using yt-dlp or youtube-dl, which retrieves video URLs from YouTube playlists, channels, and live streams. The script prompts the user to enter YouTube playlist IDs, channel IDs, and live stream URLs through teither a text based version, or a GUI version created with Zenity. Additionally, the GUI version includes options to enable playlist shuffling and choose whether to add videos to an existing playlist or overwrite it.

You can add as many playlist IDs, Channels and livestreams as you want.

# GUI version:
Separate the Playlist IDs, Channels and Livestreams with a space.
Once you provide the necessary input and clicks "Generate Playlist," the script fetches the video URLs using yt-dlp (optionally you can replace yt-dlp with youtube-dl) and stores them in an array. It then combines the video URLs into a single string and shuffles them if the shuffle option is enabled. The script creates a playlist file (either a new file or overwrites an existing one) and writes the shuffled video URLs to it in the M3U format.

# Text-based version:
In the text version, separate them with double quotes and a space (Ex. "playlist1" "playlist2" "playlist3").
Shuffle mode is enabled by default. Comment it out if you don't want a shuffled playlist.

After the playlist is successfully built, a dialog message appears to notify the user. The script utilizes zenity for GUI elements and interaction.
