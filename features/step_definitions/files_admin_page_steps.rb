When(/^I (?:am on|visit) the files admin page$/) do
  add_some_files
  wait_for_ajax_complete
  @page = files_admin_page
  step("I am logged in")
  @page.load(site: cms_site.id)
  define_bind rescue nil
  wait_for_ajax_complete
end

When(/^I (?:am on|visit) the new file page$/) do
  cms_site
  @page = files_new_page
  step("I am logged in")
  @page.load(site: cms_site.id)
  define_bind rescue nil
  wait_for_page_load rescue nil
  wait_for_ajax
end

Then(/^I should see a files header$/) do
  expect(@page).to have_files_header
end

Then(/^(?:I should see |also )?a file (.+) section$/) do |section|
  expect(@page).to have_selector(".js-files-#{section}")
end

Then(/^I choose to sort files by name$/) do
  @page.files_filters.form.sort_by.select('name (a to z)')
  wait_for_ajax_complete
end

Then(/^I choose to sort files by date$/) do
  @page.files_filters.form.sort_by.select('date added (lattest first)')
  wait_for_ajax_complete
end

Then(/^(?:The files|They) get (?:sorted|ordered) by name$/) do
  expect(@page.files_filters.form).to have_select('order', :selected => 'name (a to z)')
  expect(@page.files_listing.files.map(&:label).map(&:text).join(', ')).to eq('afile_10, afile_8, afile_9')
end

Then(/^(?:The files|They) get (?:sorted|ordered) by date \(lattest first\)$/) do
  expect(@page.files_filters.form).to have_select('order', :selected => 'date added (lattest first)')
  expect(@page.files_listing.files.map(&:label).map(&:text).join(', ')).to eq('afile_8, afile_9, afile_10')
end

Then(/^I choose to filter files by (.+) type$/) do |type|
  @page.files_filters.form.type.select(type)
  wait_for_ajax_complete
end

Then(/^Only (.+) files are shown$/) do |type|
  expect(@page.files_filters.form).to have_select('type', :selected => type)
  expect(@page.files_listing.files.map(&:label).map(&:text)).to contain_exactly(*send("#{type}_filenames"))
end

Then(/^Only (.+) files sorted by date are shown$/) do |type|
  expect(@page.files_filters.form).to have_select('order', :selected => 'date added (lattest first)')
  expect(@page.files_filters.form).to have_select('type',  :selected => type)
  expect(@page.files_listing.files.map(&:label).map(&:text)).to eq(send("#{type}_filenames").reverse)
end

Then(/^Only (.+) files sorted by name are shown$/) do |type|
  expect(@page.files_filters.form).to have_select('order', :selected => 'name (a to z)')
  expect(@page.files_filters.form).to have_select('type',  :selected => type)
  expect(@page.files_listing.files.map(&:label).map(&:text)).to eq(send("#{type}_filenames"))
end

When(/^I add a new "(.*?)" file$/) do |type|
  step('I visit the new file page')
  add_file(type: type)
end

def add_some_files
  add_file(type: :jpeg)
  add_file(type: :jpeg)
  add_file(type: :pdf)
end

def doc_filenames; %w()                 end
def jpg_filenames; %w(afile_10 afile_9) end
def pdf_filenames; %w(afile_8)          end
def xls_filenames; %w()                 end

# Uploads a new file into the system.
def add_file(type:)
  label, path, desc = new_test_file_attrs(type: type)
  step('I visit the new file page')
  fill_in("file_label", with: label)
  attach_file('file_file', path)
  fill_in('file_description', with: desc)
  click_link_or_button('Upload File')
  wait_for_ajax_complete
end

# The label, path and desc of a new sample file
def new_test_file_attrs(type:)
  root  = 'afile'
  index = 10 - Comfy::Cms::File.count
  label = [root, index].join('_')
  name  = [label, type].join('.')
  desc  = ['this is the description for file', name].join(' ')
  path  = File.join(Rails.root, 'features', 'support', name)
  [label, path, desc]
end
