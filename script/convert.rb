#!/usr/bin/env ruby

require File.expand_path(File.dirname(__FILE__)) + '/../wtf'

WTF::PageGenerator.scrape(ARGV[0], ARGV[1]) 
