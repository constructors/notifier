# Notifier #

Uses an XMPP MUC to broadcast notifications. It's a dirty hack, but it works.

## Installing ##

    bundle install
    cp config.rb.sample config.rb
    $EDITOR config.rb

## Usage ##

`./daemon.rb start` starts the daemon. Pusing stuff onto the `FIFO` puts them on
the MUC channel. The idea is only one daemon is present on a channel.

`./client.rb start` listens on that channel and uses Freedesktop Notifications
to display those messages on your desktop.
