echo -e 'Yes\nNo' | vicinae dmenu --section-title 'Are you sure you want to reboot?' | grep -q 'Yes' && reboot
