cd ~/disf-ras-projectpage/src/assets/grasp_real/ur3e

# ===== parameters =====
CUT=0.3

CROP_W=1500     # 切り出し幅
CROP_H=800     # 切り出し高さ

OUT_W=1500     # 最終出力幅
OUT_H=800     # 最終出力高さ

SHIFT_X=200    # 右にずらすpx（x方向）
SHIFT_Y=-50      # 下にずらすpx（y方向、必要なら）

OUTDIR="h264_trim_crop"
mkdir -p "$OUTDIR"

# x = clamp((iw-CROP_W)/2 + SHIFT_X, 0, iw-CROP_W)
# y = clamp((ih-CROP_H)/2 + SHIFT_Y, 0, ih-CROP_H)
VF="crop=${CROP_W}:${CROP_H}:max(0\,min((iw-${CROP_W})/2+${SHIFT_X}\,iw-${CROP_W})):max(0\,min((ih-${CROP_H})/2+${SHIFT_Y}\,ih-${CROP_H})),scale=${OUT_W}:${OUT_H}"

for f in *.mp4; do
  out="$OUTDIR/${f%.mp4}_h264_crop.mp4"
  echo "Convert+trim+crop(${CROP_W}x${CROP_H})+scale(${OUT_W}x${OUT_H}): $f -> $out"

  ffmpeg -y -i "$f" \
    -ss "$CUT" \
    -vf "$VF" \
    -c:v libx264 -pix_fmt yuv420p -profile:v high -level 4.1 \
    -preset medium -crf 23 -movflags +faststart -an \
    "$out"
done

