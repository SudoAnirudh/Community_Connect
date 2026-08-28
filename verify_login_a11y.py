import os
import subprocess
from playwright.sync_api import sync_playwright

# Create temporary directories for the verification output
os.makedirs("/app/verification/videos", exist_ok=True)
os.makedirs("/app/verification/screenshots", exist_ok=True)

def run_cuj(page):
    # Navigate to the app (assuming Vite runs on localhost:5173 by default)
    page.goto("http://localhost:5173")
    page.wait_for_timeout(1000)

    # We should land on the login page.
    # Take a screenshot to inspect the changes.
    page.screenshot(path="/app/verification/screenshots/login_a11y.png")
    page.wait_for_timeout(1000)

if __name__ == "__main__":
    with sync_playwright() as p:
        browser = p.chromium.launch(headless=True)
        context = browser.new_context(
            record_video_dir="/app/verification/videos"
        )
        page = context.new_page()
        try:
            run_cuj(page)
        finally:
            context.close()  # MUST close context to save the video
            browser.close()
