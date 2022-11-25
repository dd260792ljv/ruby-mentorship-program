# frozen_string_literal: true

require 'rspec/core/rake_task'

task :clean_directories do
  FileUtils.rm_rf(Dir.glob(File.join(Dir.pwd, '/tmp/screenshots/*.png')))
  FileUtils.rm_rf(Dir.glob(File.join(Dir.pwd, '/tmp/allure-results/*')))
  FileUtils.rm_rf(Dir.glob(File.join(Dir.pwd, '/tmp/junit_reports/*.xml')))
  FileUtils.rm_rf(Dir.glob(File.join(Dir.pwd, '/tmp/.*status')))
end

task :chrome do
  sh "BROWSER='chrome' rspec --tag test --format RspecJunitFormatter \
            --out tmp/junit_reports/rspec_junit_chrome.xml \
            --format AllureRspecFormatter"
end

task :chrome_failures do
  sh "BROWSER='chrome' rspec --only-failures --format RspecJunitFormatter \
            --out tmp/junit_reports/rspec_junit_chrome_rerun.xml \
            --format AllureRspecFormatter"
end

task :merge_junit_reports do
  if File.exist?('tmp/rspec_junit_chrome_rerun.xml')
    sh 'junit_merge tmp/junit_reports/rspec_junit_chrome_rerun.xml tmp/junit_reports/rspec_junit_chrome.xml'
  end
end

task :clean_additional_reports do
  FileUtils.rm_rf(Dir.glob(File.join(Dir.pwd, '/tmp/junit_reports/*rerun.xml')))
end

task :chrome_flow do
  %w[clean_directories chrome chrome_failures merge_junit_reports clean_additional_reports].each do |task|
    sh "rake #{task}" do end
  end
end

task :firefox do
  sh "BROWSER='firefox' rspec --tag test --format RspecJunitFormatter \
--out tmp/junit_reports/rspec_junit_firefox.xml \
--format AllureRspecFormatter"
end
