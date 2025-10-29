grim -t ppm -g "$(slurp -d -w 2)" - | satty --filename - --output-filename ~/Pictures/Screenshots/Screenshot_$time.png --early-exit --actions-on-enter save-to-clipboard --copy-command 'wl-copy'
