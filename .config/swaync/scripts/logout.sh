echo -e 'Yes\nNo' | vicinae dmenu --section-title 'Are you sure you want to logout?' | grep -q 'Yes' && hyprctl dispatch exit
