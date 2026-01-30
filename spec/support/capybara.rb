Capybara.register_driver :headless_chrome do |app|
  options = Selenium::WebDriver::Chrome::Options.new

  # CIではChromiumのパスを指定（ローカルではChromeを自動検出）
  if ENV['CI']
    options.binary = '/usr/bin/google-chrome-stable'
  end

  options.add_argument('--headless=new')
  options.add_argument('--no-sandbox')
  options.add_argument('--disable-dev-shm-usage')
  options.add_argument('--disable-gpu')
  options.add_argument('--window-size=1400,1400')

  Capybara::Selenium::Driver.new(
    app,
    browser: :chrome,
    options: options
  )
end

Capybara.javascript_driver = :headless_chrome

# システムテストで使うドライバーを設定
RSpec.configure do |config|
  config.before(:each, type: :system) do
    driven_by :headless_chrome
  end
end
