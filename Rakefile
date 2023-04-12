# frozen_string_literal: true

require 'rspec/core/rake_task'
require 'json'

task :clean_directories do
  FileUtils.rm_rf(Dir.glob(File.join(Dir.pwd, '/tmp/screenshots/*.png')))
  FileUtils.rm_rf(Dir.glob(File.join(Dir.pwd, '/tmp/allure-results/*')))
  FileUtils.rm_rf(Dir.glob(File.join(Dir.pwd, '/tmp/junit_reports/*.xml')))
  FileUtils.rm_rf(Dir.glob(File.join(Dir.pwd, '/tmp/.*status')))
end

task :merge_junit_report do
  file_names = Dir.entries('tmp/junit_reports/').delete_if { |entry| File.directory?(entry) }
  file_names.each do |file_name|
    case file_name
    when /chrome/
      sh "junit_merge tmp/junit_reports/#{file_name} tmp/junit_reports/rspec_junit_chrome.xml"
    when /firefox/
      sh "junit_merge tmp/junit_reports/#{file_name} tmp/junit_reports/rspec_junit_firefox.xml"
    when /api/
      sh "junit_merge tmp/junit_reports/#{file_name} tmp/junit_reports/rspec_junit_api.xml"
    end
  end
end

task :clean_additional_reports do
  file_names = Dir.entries('tmp/junit_reports/').select { |f| f =~ /[0-9]|rerun/ }
  file_names.each { |f| File.delete(File.join(Dir.pwd,"tmp/junit_reports/#{f}")) }
end

task :add_allure_report_history do
  if File.exist?('tmp/allure-reports/history')
    FileUtils.mv(File.join(Dir.pwd, 'tmp/allure-reports/history'), File.join(Dir.pwd, 'tmp/allure-results/history'))
  end
end

task :generate_allure_report do
  path = 'tmp/allure-results -o tmp/allure-reports'
  sh "allure generate #{path} --clean"
end

task :modify_allure_report do
  files = Dir.glob(File.join(Dir.pwd, '/tmp/allure-results/*-result.json'))
  files.each do |f|
    file = File.read(f)
    data_hash = JSON.parse(file)
    if file.each_line.any? { |line| line.include?('chrome') }
      data_hash['labels'].select { |x| x['name'] == 'thread' }.first['value'] += 1
      data_hash['historyId'] += '1'
    elsif file.each_line.any? { |line| line.include?('firefox') }
      data_hash['labels'].select { |x| x['name'] == 'thread' }.first['value'] += 2
      data_hash['historyId'] += '2'
    end
    File.write(f, JSON.dump(data_hash))
  end
end

task :run_test do
  sh "rspec --tag #{ENV['BROWSER'].nil? ? '~js' : 'js'}"
end

task :rerun_test do
  sh "rspec --only-failures --format RspecJunitFormatter \
            --out tmp/junit_reports/rspec_junit_#{ENV['BROWSER'].nil? ? 'api' :  ENV["BROWSER"]}_rerun.xml"
end

task :flow do
  %w[clean_directories run_test rerun_test merge_junit_report
     add_allure_report_history generate_allure_report clean_additional_reports].each do |task|
    sh "rake #{task}" do
    end
  end
end

task :run_parallel do
  t1 = Thread.new { system 'BROWSER=chrome rake run_test' }
  t2 = Thread.new { system 'BROWSER=firefox rake run_test' }
  t3 = Thread.new { system 'rake run_test' }
  t1.join
  t2.join
  t3.join
end

task :rerun_parallel do
  t1 = Thread.new { system 'BROWSER=chrome rake rerun_test' }
  t2 = Thread.new { system 'BROWSER=firefox rake rerun_test' }
  t3 = Thread.new { system 'rake rerun_test' }
  t1.join
  t2.join
  t3.join
end

task :parallel_flow do
  %w[clean_directories run_parallel rerun_parallel merge_junit_report
     modify_allure_report add_allure_report_history generate_allure_report clean_additional_reports].each do |task|
    sh "rake #{task}" do
    end
  end
end

task :multi_browser_run_test do
  sh "parallel_rspec " +
       "-n #{ENV['TEST_ENV_NUMBER']} " +
       "-o '-t js'"
end

task :multi_browser_flow do
  %w[clean_directories multi_browser_run_test rerun_test merge_junit_report
     modify_allure_report add_allure_report_history generate_allure_report clean_additional_reports].each do |task|
    sh "rake #{task}" do
    end
  end
end

task :multi_browser_run_parallel do
  t1 = Thread.new { system 'BROWSER=chrome TEST_ENV_NUMBER=2 rake multi_browser_run_test' }
  t2 = Thread.new { system 'BROWSER=firefox TEST_ENV_NUMBER=2 rake multi_browser_run_test' }
  t3 = Thread.new { system 'rake run_test' }
  t1.join
  t2.join
  t3.join
end

task :multi_browser_parallel_flow do
  %w[clean_directories multi_browser_run_parallel rerun_parallel merge_junit_report
     modify_allure_report add_allure_report_history generate_allure_report clean_additional_reports].each do |task|
    sh "rake #{task}" do
    end
  end
end
