feature 'First test', js: true do
  scenario 'Site opens' do
    visit('https://en.wikipedia.org/wiki/Main_Page')
    expect(page).to have_current_path('/wiki/Main_Page')
    expect(page).to have_css('#p-logo')
  end
end
