from playwright.sync_api import sync_playwright
import os

os.makedirs("/home/jules/verification/screenshots", exist_ok=True)
os.makedirs("/home/jules/verification/videos", exist_ok=True)

with sync_playwright() as p:
    browser = p.chromium.launch(headless=True)
    context = browser.new_context(record_video_dir="/home/jules/verification/videos", record_video_size={"width": 1280, "height": 720})
    page = context.new_page()

    page.goto("http://localhost:5173/404")

    # Inject fake supabase auth token
    page.evaluate("""
        localStorage.setItem('sb-placeholder-url-auth-token', JSON.stringify({
            access_token: 'fake_access_token',
            refresh_token: 'fake_refresh_token',
            user: { id: 'fake_user_id', email: 'admin@test.com' },
            expires_in: 3600,
            expires_at: Math.floor(Date.now() / 1000) + 3600
        }));
    """)

    def intercept(route):
        pass

    page.route("**/rest/v1/families*", intercept)

    # Go to families dashboard
    page.goto("http://localhost:5173/families", wait_until="domcontentloaded")

    # Wait for the spinner
    page.wait_for_selector(".spinner", timeout=5000)

    # Wait a bit to capture animation
    page.wait_for_timeout(2000)

    # Take screenshot
    page.screenshot(path="/home/jules/verification/screenshots/spinner_animated.png")
    print("Screenshot saved!")

    context.close()
    browser.close()

    # Rename the video to a known name
    for file in os.listdir("/home/jules/verification/videos"):
        if file.endswith(".webm"):
            os.rename(os.path.join("/home/jules/verification/videos", file), "/home/jules/verification/videos/spinner.webm")
