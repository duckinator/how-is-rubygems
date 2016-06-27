#!/usr/bin/env ruby

require 'how_is'

date = Date.strptime(Time.now.to_i.to_s, '%s').strftime('%Y-%m-%d')

# JSON Report.

json_filename = "json/#{date}.json"

json_report = HowIs.generate_report(repository: 'rubygems/rubygems', format: 'json')

File.open(json_filename, 'w') {|f| f.puts json_report }

# HTML Report.

html_filename = "_posts/#{date}-report.html"

html_header = <<EOF
---
title: #{date} Report
layout: default
---
EOF

html_report = HowIs.generate_report(repository: 'rubygems/rubygems', from_file: json_filename, format: 'html')

File.open(html_filename, 'w') do |f|
  f.puts html_header
  f.puts
  f.puts html_report
end
