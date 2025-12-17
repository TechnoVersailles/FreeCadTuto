#!/bin/bash
# remove_first_frames.sh

input="$1"
frames_to_remove="${2:-10}"  # 10 images par défaut

# Obtenir le FPS
fps=$(ffprobe -v error -select_streams v:0 \
  -show_entries stream=r_frame_rate \
  -of default=noprint_wrappers=1:nokey=1 "$input" | \
  awk -F'/' '{print $1/$2}')

# Calculer le temps
temps=$(echo "scale=3; $frames_to_remove / $fps" | bc)

# Créer le nom de sortie
output="${input%.mp4}_no${frames_to_remove}fr.mp4"

echo "📊 Vidéo: $input"
echo "🎞️  FPS: $fps"
echo "🗑️  Suppression: $frames_to_remove images ($temps secondes)"

# Supprimer les premières images
ffmpeg -i "$input" -ss "$temps" -c copy "$output"

echo "✅ Fichier créé: $output"