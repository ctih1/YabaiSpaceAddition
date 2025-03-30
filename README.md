# YabaiSpaceAddition
A simple utility that displays the space and its title you're currently in

![Näyttökuva 2025-3-30 kello 10 21 26](https://github.com/user-attachments/assets/bbad7101-02be-4923-bbb3-1a5ebbef1ee2)


## Installation
Open the app, and add the following to your yabai config 
```
yabai -m signal --add event=mission_control_exit action='echo "refresh" | nc -U /tmp/yabaispacemanager.socket'
yabai -m signal --add event=display_added action='echo "refresh" | nc -U /tmp/yabaispacemanager.socket'code
yabai -m signal --add event=display_removed action='echo "refresh" | nc -U /tmp/yabaispacemanager.socket'
yabai -m signal --add event=window_created action='echo "refresh" | nc -U /tmp/yabaispacemanager.socket'
yabai -m signal --add event=window_destroyed action='echo "refresh" | nc -U /tmp/yabaispacemanager.socket'
yabai -m signal --add event=window_focused action='echo "refresh" | nc -U /tmp/yabaispacemanager.socket'
yabai -m signal --add event=window_moved action='echo "refresh" | nc -U /tmp/yabaispacemanager.socket'
yabai -m signal --add event=window_resized action='echo "refresh" | nc -U /tmp/yabaispacemanager.socket'
yabai -m signal --add event=window_minimized action='echo "refresh" | nc -U /tmp/yabaispacemanager.socket'
yabai -m signal --add event=window_deminimized action='echo "refresh" | nc -U /tmp/yabaispacemanager.socket'
```
