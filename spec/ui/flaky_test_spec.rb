# frozen_string_literal: true

feature 'Flaky test', js: true do
  sign_in_page = SignInPage.new

  before(:all) do
    if ENV['BROWSER'] == 'chrome'
      @path1 = './spec/support/test_data'
      File.open(@path1, 'w') { |f| f.write('0') } if File.read(@path1) != '1'
    elsif ENV['BROWSER'] == 'firefox'
      @path2 = './spec/support/ff_test_data'
      File.open(@path2, 'w') { |f| f.write('0') } if File.read(@path2) != '1'
    end
  end

  after(:all) do
    if ENV['BROWSER'] == 'chrome'
      File.read(@path1) == '0' ? File.open(@path1, 'w') { |f| f.write('1') } : File.open(@path1, 'w') { |f| f.write('0') }
    elsif ENV['BROWSER'] == 'firefox'
      File.read(@path2) == '0' ? File.open(@path2, 'w') { |f| f.write('1') } : File.open(@path2, 'w') { |f| f.write('0') }
    end
  end

  scenario 'Edit file', severity: :minor do
    sign_in_page.load
    if ENV['BROWSER'] == 'chrome'
      expect(File.read(@path1)).to eq('1')
    elsif ENV['BROWSER'] == 'firefox'
      expect(File.read(@path2)).to eq('1')
    end
  end
end