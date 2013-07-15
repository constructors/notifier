#!/usr/bin/env ruby

require 'rubygems'
require 'bundler/setup'
require 'dbus'
require 'xmpp4r'
require 'xmpp4r/muc/helper/simplemucclient'
require 'daemons'
require 'securerandom'
require File.expand_path('config.rb', File.dirname(__FILE__))

MYNAME = 'notifier-client'

def notify(who, msg)
  bus = DBus::SessionBus.instance
  notify_service = bus.service('org.freedesktop.Notifications')
  notify_object = notify_service.object('/org/freedesktop/Notifications')
  notify_object.introspect
  notify_object.default_iface = 'org.freedesktop.Notifications'
  notify_object.Notify(MYNAME, 0, '', who, msg,
                       [], [], -1)
end

Daemons.run_proc(MYNAME) do
  client = Jabber::Client.new(JID)
  client.connect
  client.auth(PASS)
  muc = Jabber::MUC::SimpleMUCClient.new(client)

  muc.on_message do |time, nick, msg|
    notify nick, msg
  end

  muc.join(ROOM + '/' + MYNAME + '-' + SecureRandom.hex(4))

  sleep
end
