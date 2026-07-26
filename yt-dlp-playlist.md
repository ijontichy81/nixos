# yt-dlp Playlist Download One-Liner

```bash
yt-dlp \
  -f 'ba[ext=opus]/ba[acodec^=opus]/ba' \
  --extract-audio --audio-format opus --audio-quality 0 \
  --embed-thumbnail --embed-metadata --embed-chapters \
  --write-description --write-info-json \
  --write-sub --embed-subs --convert-subs srt \
  --download-archive archive.txt \
  --sponsorblock-mark all --sponsorblock-remove sponsor \
  -o '%(playlist_title)s/%(playlist_index)s - %(title)s.%(ext)s' \
  '<PLAYLIST_URL>'
```

## Flags Breakdown

| Flag | Purpose |
|------|---------|
| `-f "ba[ext=opus]/ba[acodec^=opus]/ba"` | Best audio, prefers opus, fallback to any audio |
| `--extract-audio` | Extract audio from video |
| `--audio-format opus` | Convert to opus codec |
| `--audio-quality 0` | Best quality (0 = best, 10 = worst) |
| `--embed-thumbnail` | Embed thumbnail into file |
| `--embed-metadata` | Embed metadata (title, artist, album, etc.) |
| `--embed-chapters` | Embed chapter markers |
| `--write-description` | Save video description to file |
| `--write-info-json` | Save yt-dlp metadata JSON |
| `--write-sub --embed-subs --convert-subs srt` | Download, embed, and convert subtitles to SRT |
| `--download-archive archive.txt` | Keep track of downloaded files (skip on re-run) |
| `--sponsorblock-mark all` | Mark all sponsorblock segments |
| `--sponsorblock-remove sponsor` | Auto-remove sponsor segments |
| `-o "..."` | Output template: playlist folder, numbered tracks |

Replace `<PLAYLIST_URL>` with your playlist URL.
