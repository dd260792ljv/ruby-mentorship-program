# frozen_string_literal: true

require 'rspec/core/rake_task'
require 'json'

task :clean_directories do
  FileUtils.rm_rf(Dir.glob(File.join(Dir.pwd, '/tmp/screenshots/*.png')))
  FileUtils.rm_rf(Dir.glob(File.join(Dir.pwd, '/tmp/allure-results/*')))
  FileUtils.rm_rf(Dir.glob(File.join(Dir.pwd, '/tmp/junit_reports/*.xml')))
  FileUtils.rm_rf(Dir.glob(File.join(Dir.pwd, '/tmp/.*status')))
end

task :chrome do
  sh "BROWSER='chrome' rspec --tag js --format RspecJunitFormatter \
            --out tmp/junit_reports/rspec_junit_chrome.xml"
end

task :chrome_failures do
  sh "BROWSER='chrome' rspec --only-failures --format RspecJunitFormatter \
            --out tmp/junit_reports/rspec_junit_chrome_rerun.xml"
end

task :merge_chrome_junit_reports do
  if File.exist?('tmp/junit_reports/rspec_junit_chrome_rerun.xml')
    sh 'junit_merge tmp/junit_reports/rspec_junit_chrome_rerun.xml tmp/junit_reports/rspec_junit_chrome.xml'
  end
end

task :clean_additional_reports do
  FileUtils.rm_rf(Dir.glob(File.join(Dir.pwd, '/tmp/junit_reports/*rerun.xml')))
end

task :add_report_history do
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
    if File.read(f).each_line.any? { |line| line.include?('chrome') }
      file = File.read(f)
      data_hash = JSON.parse(file)
      data_hash['labels'].select { |x| x['name'] == 'thread' }.first['value'] += 1
      data_hash['historyId'] += '1'
      File.write(f, JSON.dump(data_hash))
    end
  end
end

task :chrome_flow do
  %w[clean_directories chrome chrome_failures merge_chrome_junit_reports
     add_report_history generate_allure_report clean_additional_reports].each do |task|
    sh "rake #{task}" do
    end
  end
end

task :firefox do
  sh "BROWSER='firefox' rspec --tag js --format RspecJunitFormatter \
            --out tmp/junit_reports/rspec_junit_firefox.xml"
end

task :firefox_failures do
  sh "BROWSER='firefox' rspec --only-failures --format RspecJunitFormatter \
            --out tmp/junit_reports/rspec_junit_firefox_rerun.xml"
end

task :merge_firefox_junit_reports do
  if File.exist?('tmp/junit_reports/rspec_junit_firefox_rerun.xml')
    sh 'junit_merge tmp/junit_reports/rspec_junit_firefox_rerun.xml tmp/junit_reports/rspec_junit_firefox.xml'
  end
end

task :firefox_flow do
  %w[clean_directories firefox firefox_failures merge_firefox_junit_reports
     add_report_history generate_allure_report clean_additional_reports].each do |task|
    sh "rake #{task}" do
    end
  end
end

task :api do
  sh "rspec --tag ~js --format RspecJunitFormatter \
            --out tmp/junit_reports/rspec_junit_api.xml"
end

task :api_failures do
  sh "rspec --only-failures --format RspecJunitFormatter \
            --out tmp/junit_reports/rspec_junit_api_rerun.xml"
end

task :merge_api_junit_reports do
  if File.exist?('tmp/junit_reports/rspec_junit_api_rerun.xml')
    sh 'junit_merge tmp/junit_reports/rspec_junit_api_rerun.xml tmp/junit_reports/rspec_junit_api.xml'
  end
end

task :api_flow do
  %w[clean_directories api api_failures merge_api_junit_reports
     add_report_history generate_allure_report clean_additional_reports].each do |task|
    sh "rake #{task}" do
    end
  end
end

task :run_parallel do
  t1 = Thread.new { system 'rake chrome' }
  t2 = Thread.new { system 'rake firefox' }
  t3 = Thread.new { system 'rake api' }
  t1.join
  t2.join
  t3.join
end

task :rerun_parallel do
  t1 = Thread.new { system 'rake chrome_failures' }
  t2 = Thread.new { system 'rake firefox_failures' }
  t3 = Thread.new { system 'rake api_failures' }
  t1.join
  t2.join
  t3.join
end

task :parallel_flow do
  %w[clean_directories run_parallel rerun_parallel
     merge_chrome_junit_reports merge_firefox_junit_reports merge_api_junit_reports
     modify_allure_report add_report_history generate_allure_report clean_additional_reports].each do |task|
    sh "rake #{task}" do
    end
  end
end
