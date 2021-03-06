#!/bin/sh
# vim:set et sw=2:

date
env
PATH="$HOME/bin:/usr/local/bin:/usr/bin:/bin:/usr/bin/X11"
[ -n "$ENV" ] || ENV="$HOME/.shrc"
. "$ENV"
export ENV
unset STY TMUX

BROWSER="$HOME/bin/sensible-browser"
TERMINAL="$HOME/bin/x-terminal-emulator"
export TERMINAL BROWSER

xsetroot -solid '#000420'
xset r rate 600 30
xset b 40 440 60
xset dpms 600

if [ -f "$HOME/.xmodmap" ]; then
  xmodmap "$HOME/.xmodmap"
else
  setxkbmap -option ctrl:nocaps
fi

if [ ! -f "$HOME/. tpope" ]; then
  echo 'Performing an initial "tpope install"'
  tpope install
fi
tpope cron --login

if [ -x /usr/bin/ssh-agent -a -z "$SSH_AUTH_SOCK" ]; then
  sshagent="/usr/bin/ssh-agent --"
fi

[ ! -x "`which unclutter 2>/dev/null`" ] || unclutter -idle 10 -noevents &
[ ! -x "`which pulseaudio 2>/dev/null`" ] || pulseaudio &
[ ! -x "`which bluetooth-applet 2>/dev/null`" ] || bluetooth-applet &

xsetroot -solid '#000840'

[ ! -f "$HOME/.xsession.local" ] || . "$HOME/.xsession.local"

if [ -n "$GNOME_FVWM" -a -x /usr/bin/fvwm2 -a -x /usr/bin/gnome-session -a -x /usr/bin/gnome-control-center ] && fvwm2 --version >/dev/null 2>&1; then
  export WINDOW_MANAGER=fvwm2
  exec $sshagent gnome-session
fi

for wm in fvwm2 icewm startkde fluxbox enlightenment mwm twm xterm; do
  [ -x "`which $wm 2>/dev/null`" ] && exec $sshagent $wm
done
