#!/usr/bin/env ruby

require 'how_is'
require 'yaml'

config = YAML.load_file('how_is.yml')

date = Date.strptime(Time.now.to_i.to_s, '%s')
date_string = date.strftime('%Y-%m-%d')
friendly_date = date.strftime('%B %d, %y')

analysis = HowIs.generate_analysis(repository: config['repository'])

report_data = {
  repository: config['repository'],
  date: date,
  friendly_date: friendly_date,
}

def jekyll_header(jekyll_config, report_data)
  headers = jekyll_config.map { |k, v|
    v = v % report_data

    [k, v]
  }.to_h

  YAML.dump(headers)
end

config['reports'].each do |format, report_config|
  filename = report_config['filename'] % report_data
  file = File.join(report_config['directory'], filename)

  report = HowIs::Report.export(analysis, format)

  File.open(file, 'w') do |f|
    if report_config['jekyll']
      f.puts jekyll_header(report_config['jekyll'], report_data)
      f.puts "---"
      f.puts
    end

    f.puts report
  end
end

__END__

# JSON Report.

json_filename = "json/#{date}.json"

json_report = HowIs.generate_report()

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
