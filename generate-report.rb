#!/usr/bin/env ruby

require 'how_is'

date = Date.strptime(Time.now.to_i.to_s, '%s').strftime('%Y-%m-%d')
filename = "_posts/#{date}-report.html"

header = <<EOF
---
title: #{date} Report
layout: default
---
EOF

report = HowIs.generate_report(repository: 'rubygems/rubygems', format: 'html')

File.open(filename, 'w') do |f|
  f.puts header
  f.puts
  f.puts report
end
