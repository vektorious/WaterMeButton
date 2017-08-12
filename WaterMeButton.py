#!/usr/bin/python
# -*- coding: utf-8 -*-
"""
23.07.2017
@author: Alexander Kutschera, alexander.kutschera@gmail.com
"""

import datetime
import logging
import urllib2
import multiprocessing
import ctypes
import subprocess

# Constants
timespan_threshhold = 3

# Globals
lastpress = datetime.datetime(1970,1,1)
doublePress = False
waterCount = 0

# Ctypes
count = multiprocessing.Value(ctypes.c_int,0)

logging.getLogger("scapy.runtime").setLevel(logging.ERROR)
from scapy.all import *


def button_pressed_dash1():
    global lastpress
    thistime = datetime.datetime.now()
    timespan = thistime - lastpress
    if timespan.total_seconds() > timespan_threshhold:
        current_time = datetime.datetime.strftime(thistime, '%Y-%m-%d %H:%M:%S')
        print 'Dash button pressed at ' + current_time
        count.value += 1
        print count.value
        if count.value > 3:
            count.value = 0
        lastpress = thistime


def udp_filter(pkt):
    options = pkt[DHCP].options
    for option in options:
        if isinstance(option, tuple):
          if 'requested_addr' in option:
              # we've found the IP address, which means its the second and final UDP request, so we can trigger our action
              mac_to_action[pkt.src]()
              break

def sniffing():
    print "Waiting for a button press..."
    sniff(prn=udp_filter, store=0, filter="udp", lfilter=lambda d: d.src in mac_id_list)

def threaded_sniff():
    q = Queue()
    sniffer = Thread(target = sniffing(), args = (q,))
    sniffer.daemon = True
    sniffer.start()


def water_count():
    last = datetime.datetime.now()
    critical_time = 24
    email = False
    while True:
        time.sleep(60)
        now = datetime.datetime.now()

        if count.value > 0:
            last = now
            email = False

        if count.value == 1: critical_time = 24
        if count.value == 2: critical_time = 48
        if count.value == 3: critical_time = 72

        delta = now - last
        minutes = delta.seconds/60
        hours = minutes/60
        print count.value
        print "It hast been %i minutes (%i hours) since the last press" %(minutes, hours)

        if hours > critical_time:
            if minutes//critical_time == 2: email = False
            if email is False:
                print "You should check for your plants! Sending reminder via email..."
                subprocess.call(['./send_mail.sh'])
                email = True

        count.value = 0


mac_to_action = {'ac:63:be:03:1a:7c' : button_pressed_dash1}
mac_id_list = list(mac_to_action.keys())


try:
    counter = multiprocessing.Process(target = water_count)
    counter.start()
    sniffer = multiprocessing.Process(target = sniffing)
    sniffer.start()
except (KeyboardInterrupt, SystemExit):
    counter.stop()
    sniffer.stop()
    exit()
