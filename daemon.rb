#!/usr/bin/env ruby

require 'rubygems'
require 'bundler/setup'
require 'xmpp4r'
require 'xmpp4r/muc/helper/simplemucclient'
require 'mkfifo'
require 'daemons'
require File.expand_path('config.rb', File.dirname(__FILE__))

MYNAME = 'notifier-daemon'

File.unlink(FIFO) rescue nil
begin
  File.mkfifo(FIFO)
  File.chmod(0666, FIFO)
rescue
  $stderr.puts $!
  exit 1
end

Daemons.run_proc(MYNAME) do
  client = Jabber::Client.new(JID)
  client.connect
  client.auth(PASS)
  muc = Jabber::MUC::SimpleMUCClient.new(client)
  muc.join(ROOM + '/' + MYNAME)

  loop do
    fifo = File.open(FIFO)
    while str = fifo.gets
      muc.send Jabber::Message.new(muc.room, str.strip)
    end
    fifo.close
  end
end
