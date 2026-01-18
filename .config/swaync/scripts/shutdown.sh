echo -e 'Yes\nNo' | vicinae dmenu --section-title 'Are you sure you want to shutdown?' | grep -q 'Yes' && shutdown
