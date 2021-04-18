print $sock "Taking picture...<p>\n";

`cd /dev/shm && fswebcam cam.jpg`;

print $sock "<a href =\"/ls.htm?path=/dev/shm/cam.jpg\"><img src=\"/ls.htm?path=/dev/shm/cam.jpg\" width=\"384x288\"></a>";

